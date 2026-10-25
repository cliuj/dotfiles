import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Pam

// State shared by every lock surface, so all screens show the same thing
Scope {
    id: root

    signal unlocked

    // test.qml sets this so the power buttons only log
    property bool dryRun: false

    // The field shows on this screen, or on whichever screen niri focuses
    readonly property string primaryName: {
        const screens = Quickshell.screens;
        for (let i = 0; i < screens.length; i++) {
            if (screens[i].name === "eDP-1")
                return "eDP-1";
        }
        return screens.length > 0 ? screens[0].name : "";
    }

    // Password text; each surface mirrors it into its own field
    property string currentText: ""
    property bool showPassword: false
    property bool unlockInProgress: false

    // "idle", "failed", "lockout" or "error"
    property string status: "idle"
    // PAM's own text for the last failure, e.g. the faillock notice
    property string statusDetail: ""

    // Messages PAM sent during the current attempt (faillock sends two)
    property var pamMessages: []

    // A power action waiting for confirmation, or null
    property var pendingAction: null

    // faillock settings; the defaults match pam_faillock's own
    readonly property int denyLimit: confValue("deny", 3)
    readonly property int unlockTime: confValue("unlock_time", 600)

    // Valid failures in the faillock tally (sudo failures count too)
    property int failures: 0

    function confValue(key, fallback) {
        if (!faillockConf.loaded)
            return fallback;
        const match = faillockConf.text().match(new RegExp("^\\s*" + key + "\\s*=\\s*(\\d+)", "m"));
        return match ? Number(match[1]) : fallback;
    }

    FileView {
        id: faillockConf
        path: "/etc/security/faillock.conf"
    }

    // Lines that end in "V" are failures inside fail_interval
    Process {
        id: tally
        running: true
        command: ["faillock", "--user", Quickshell.env("USER")]
        stdout: StdioCollector {
            onStreamFinished: {
                root.failures = this.text.split("\n").filter(line => /\sV\s*$/.test(line)).length;

                // The failure that reaches the limit may not get a PAM message,
                // so show the lockout as soon as the count reaches the limit
                if (root.failures >= root.denyLimit && root.status === "failed") {
                    root.status = "lockout";
                    if (root.statusDetail === "")
                        root.statusDetail = "Too many failed attempts. Try again in " + Math.round(root.unlockTime / 60) + " min.";
                }
            }
        }
    }

    readonly property var actions: [
        {
            id: "sleep",
            label: "Sleep",
            icon: "moon",
            warm: false,
            title: "Sleep now?",
            text: "Suspends the laptop to memory. You need your password when it wakes.",
            command: ["systemctl", "suspend"]
        },
        {
            id: "hibernate",
            label: "Hibernate",
            icon: "snowflake",
            warm: false,
            title: "Hibernate now?",
            text: "Saves your session to disk and turns the laptop off. It uses no battery, but waking takes longer than sleep.",
            command: ["systemctl", "hibernate"]
        },
        {
            id: "reboot",
            label: "Restart",
            icon: "rotate-ccw",
            warm: true,
            title: "Restart now?",
            text: "Closes all apps and restarts the laptop. Unsaved work in open apps is lost.",
            command: ["systemctl", "reboot"]
        },
        {
            id: "poweroff",
            label: "Power off",
            icon: "power",
            warm: true,
            title: "Power off now?",
            text: "Closes all apps and turns the laptop off. Unsaved work in open apps is lost.",
            command: ["systemctl", "poweroff"]
        }
    ]

    // Typing clears "wrong password", but the lockout notice stays
    onCurrentTextChanged: {
        if (currentText !== "" && status === "failed")
            status = "idle";
        if (showPassword)
            hideTimer.restart();
    }

    onShowPasswordChanged: showPassword ? hideTimer.restart() : hideTimer.stop()

    function tryUnlock() {
        if (currentText === "" || unlockInProgress || pendingAction !== null)
            return;
        pamMessages = [];
        showPassword = false;
        unlockInProgress = true;
        pam.start();
    }

    function ask(action) {
        pendingAction = action;
    }

    function cancelAction() {
        pendingAction = null;
    }

    function confirmAction() {
        const action = pendingAction;
        pendingAction = null;
        if (action === null)
            return;
        if (dryRun)
            console.log("dry run:", action.command.join(" "));
        else
            Quickshell.execDetached(action.command);
    }

    // Hide a visible password again after 10 s without typing
    Timer {
        id: hideTimer
        interval: 10000
        onTriggered: root.showPassword = false
    }

    PamContext {
        id: pam

        // The system "login" stack, the same one a TTY login uses. It includes
        // pam_faillock, so failures count and a lockout is reported.
        config: "login"

        onPamMessage: {
            if (pam.responseRequired)
                pam.respond(root.currentText);
            else if (pam.message !== "")
                root.pamMessages = root.pamMessages.concat([pam.message]);
        }

        onCompleted: result => {
            root.currentText = "";
            root.unlockInProgress = false;

            if (result === PamResult.Success) {
                root.status = "idle";
                root.statusDetail = "";
                root.unlocked();
                return;
            }

            // faillock: "The account is locked due to 3 failed logins."
            const detail = root.pamMessages.join(" ");
            if (/locked/i.test(detail))
                root.status = "lockout";
            else if (result === PamResult.Failed)
                root.status = "failed";
            else
                root.status = "error";
            root.statusDetail = detail;
            tally.running = true;
        }
    }
}
