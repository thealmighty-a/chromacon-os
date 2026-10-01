// ChromaCon SDDM theme: monochrome, keyboard-first.
// Enter logs in, Tab moves between fields, F1/F2 cycle the session,
// F11 reboots, F12 shuts down.
import QtQuick
import QtQuick.Controls

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: config.background || "#000000"

    readonly property color fg: config.foreground || "#e8e8e8"
    readonly property color dim: config.dim || "#6e6e6e"
    readonly property color line: config.line || "#262626"
    readonly property string fontFamily: config.font || "JetBrainsMono Nerd Font"
    readonly property real unit: Math.max(1, height / 1080)

    property int sessionIndex: sessionModel.lastIndex >= 0 ? sessionModel.lastIndex : 0
    property var sessionNames: []
    property string message: ""

    // Collect session names (the model has no index accessor in QML).
    Repeater {
        model: sessionModel
        delegate: Item {
            Component.onCompleted: {
                var names = root.sessionNames.slice()
                names[index] = model.name
                root.sessionNames = names
            }
        }
    }

    function sessionName() {
        return sessionNames[sessionIndex] || "Session"
    }

    function cycleSession(step) {
        var count = Math.max(1, sessionModel.rowCount())
        sessionIndex = (sessionIndex + step + count) % count
    }

    function doLogin() {
        message = ""
        sddm.login(userField.text, passwordField.text, sessionIndex)
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            root.message = "access denied"
            passwordField.text = ""
            passwordField.forceActiveFocus()
            shake.start()
        }
        function onLoginSucceeded() {
            root.message = ""
        }
    }

    // Thin frame around the screen.
    Rectangle {
        anchors.fill: parent
        anchors.margins: 28 * root.unit
        color: "transparent"
        border.color: root.line
        border.width: 1
    }

    // Wordmark, top left.
    Column {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 64 * root.unit
        spacing: 6 * root.unit

        Text {
            text: "CHROMACON"
            color: root.fg
            font.family: root.fontFamily
            font.bold: true
            font.pixelSize: 34 * root.unit
            font.letterSpacing: 10 * root.unit
        }
        Rectangle {
            width: 64 * root.unit
            height: 3 * root.unit
            color: root.fg
        }
        Text {
            text: sddm.hostName.toLowerCase()
            color: root.dim
            font.family: root.fontFamily
            font.bold: true
            font.pixelSize: 14 * root.unit
            font.letterSpacing: 3 * root.unit
        }
    }

    // Clock, top right.
    Column {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.margins: 64 * root.unit
        spacing: 2 * root.unit

        Text {
            id: clock
            anchors.right: parent.right
            color: root.fg
            font.family: root.fontFamily
            font.bold: true
            font.pixelSize: 56 * root.unit
            text: Qt.formatTime(new Date(), "HH:mm")
        }
        Text {
            id: date
            anchors.right: parent.right
            color: root.dim
            font.family: root.fontFamily
            font.bold: true
            font.pixelSize: 14 * root.unit
            font.letterSpacing: 3 * root.unit
            text: Qt.formatDate(new Date(), "dddd dd MMMM").toLowerCase()
        }
        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: {
                clock.text = Qt.formatTime(new Date(), "HH:mm")
                date.text = Qt.formatDate(new Date(), "dddd dd MMMM").toLowerCase()
            }
        }
    }

    // Login box, centre.
    Column {
        id: loginBox
        anchors.centerIn: parent
        width: 460 * root.unit
        spacing: 14 * root.unit

        SequentialAnimation {
            id: shake
            loops: 1
            NumberAnimation { target: loginBox; property: "anchors.horizontalCenterOffset"; to: -12; duration: 50 }
            NumberAnimation { target: loginBox; property: "anchors.horizontalCenterOffset"; to: 12; duration: 70 }
            NumberAnimation { target: loginBox; property: "anchors.horizontalCenterOffset"; to: -6; duration: 60 }
            NumberAnimation { target: loginBox; property: "anchors.horizontalCenterOffset"; to: 0; duration: 50 }
        }

        Text {
            text: "login"
            color: root.dim
            font.family: root.fontFamily
            font.bold: true
            font.pixelSize: 13 * root.unit
            font.letterSpacing: 4 * root.unit
        }

        TextField {
            id: userField
            width: parent.width
            height: 54 * root.unit
            text: userModel.lastUser
            placeholderText: "user"
            color: root.fg
            placeholderTextColor: root.dim
            selectionColor: root.fg
            selectedTextColor: root.color
            font.family: root.fontFamily
            font.bold: true
            font.pixelSize: 18 * root.unit
            leftPadding: 18 * root.unit
            background: Rectangle {
                color: "transparent"
                border.color: userField.activeFocus ? root.fg : root.line
                border.width: userField.activeFocus ? 2 : 1
            }
            KeyNavigation.tab: passwordField
            Keys.onReturnPressed: passwordField.forceActiveFocus()
            Keys.onEnterPressed: passwordField.forceActiveFocus()
        }

        TextField {
            id: passwordField
            width: parent.width
            height: 54 * root.unit
            echoMode: TextInput.Password
            passwordCharacter: "•"
            placeholderText: "password"
            color: root.fg
            placeholderTextColor: root.dim
            selectionColor: root.fg
            selectedTextColor: root.color
            font.family: root.fontFamily
            font.bold: true
            font.pixelSize: 18 * root.unit
            leftPadding: 18 * root.unit
            focus: true
            background: Rectangle {
                color: "transparent"
                border.color: passwordField.activeFocus ? root.fg : root.line
                border.width: passwordField.activeFocus ? 2 : 1
            }
            KeyNavigation.backtab: userField
            KeyNavigation.tab: loginButton
            Keys.onReturnPressed: root.doLogin()
            Keys.onEnterPressed: root.doLogin()
        }

        Rectangle {
            id: loginButton
            width: parent.width
            height: 54 * root.unit
            color: activeFocus || loginMouse.containsMouse ? root.fg : "transparent"
            border.color: root.fg
            border.width: 2
            activeFocusOnTab: true
            KeyNavigation.backtab: passwordField
            Keys.onReturnPressed: root.doLogin()
            Keys.onEnterPressed: root.doLogin()
            Keys.onSpacePressed: root.doLogin()

            Text {
                anchors.centerIn: parent
                text: "enter"
                color: loginButton.activeFocus || loginMouse.containsMouse ? root.color : root.fg
                font.family: root.fontFamily
                font.bold: true
                font.pixelSize: 16 * root.unit
                font.letterSpacing: 6 * root.unit
            }
            MouseArea {
                id: loginMouse
                anchors.fill: parent
                hoverEnabled: true
                onClicked: root.doLogin()
            }
        }

        Text {
            width: parent.width
            height: 20 * root.unit
            text: root.message
            color: root.fg
            horizontalAlignment: Text.AlignHCenter
            font.family: root.fontFamily
            font.bold: true
            font.pixelSize: 13 * root.unit
            font.letterSpacing: 3 * root.unit
        }
    }

    // Session selector, bottom left.
    Row {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.margins: 64 * root.unit
        spacing: 14 * root.unit

        Text {
            text: "‹"
            color: sessionPrev.containsMouse ? root.fg : root.dim
            font.family: root.fontFamily
            font.bold: true
            font.pixelSize: 18 * root.unit
            MouseArea { id: sessionPrev; anchors.fill: parent; hoverEnabled: true; onClicked: root.cycleSession(-1) }
        }
        Text {
            text: root.sessionName().toLowerCase()
            color: root.fg
            font.family: root.fontFamily
            font.bold: true
            font.pixelSize: 14 * root.unit
            font.letterSpacing: 2 * root.unit
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            text: "›"
            color: sessionNext.containsMouse ? root.fg : root.dim
            font.family: root.fontFamily
            font.bold: true
            font.pixelSize: 18 * root.unit
            MouseArea { id: sessionNext; anchors.fill: parent; hoverEnabled: true; onClicked: root.cycleSession(1) }
        }
        Text {
            text: "f1/f2"
            color: root.line
            font.family: root.fontFamily
            font.bold: true
            font.pixelSize: 12 * root.unit
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    // Power, bottom right.
    Row {
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.margins: 64 * root.unit
        spacing: 36 * root.unit

        Repeater {
            model: [
                { label: "reboot  f11", enabled: sddm.canReboot, action: function() { sddm.reboot() } },
                { label: "shutdown  f12", enabled: sddm.canPowerOff, action: function() { sddm.powerOff() } }
            ]
            delegate: Text {
                visible: modelData.enabled
                text: modelData.label
                color: powerMouse.containsMouse ? root.fg : root.dim
                font.family: root.fontFamily
                font.bold: true
                font.pixelSize: 13 * root.unit
                font.letterSpacing: 2 * root.unit
                MouseArea { id: powerMouse; anchors.fill: parent; hoverEnabled: true; onClicked: modelData.action() }
            }
        }
    }

    // Global keys.
    Shortcut { sequence: "F1"; onActivated: root.cycleSession(-1) }
    Shortcut { sequence: "F2"; onActivated: root.cycleSession(1) }
    Shortcut { sequence: "F11"; onActivated: if (sddm.canReboot) sddm.reboot() }
    Shortcut { sequence: "F12"; onActivated: if (sddm.canPowerOff) sddm.powerOff() }

    Component.onCompleted: passwordField.forceActiveFocus()
}
