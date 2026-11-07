import QtQuick
import QtQuick.Controls

Rectangle {
    id: root

    width: 1920
    height: 1080
    color: "#000000"

    // Background
    // ----------------------------------------------------------------------------------------------
    Image {
        anchors.fill: parent

        source: config.background
        fillMode: Image.PreserveAspectCrop
        smooth: true
    }


    // Main panel
    // ----------------------------------------------------------------------------------------------
    Rectangle {
        id: loginPanel

        width: loginColumn.width + (config.panelPadding * 2)

        anchors.top: parent.top
        anchors.bottom: parent.bottom

        x: {
            if (config.panelPosition === "left")
                return 0

            if (config.panelPosition === "right")
                return parent.width - width

            return (parent.width - width) / 2
        }

        color: config.panelBgColor

        // Clock
        // ------------------------------------------------------------------------------------------
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            y: loginPanel.height * config.clockDateY
            spacing: 8

            // Time
            Text {
                id: clock

                color: config.clockFgColor
                font.pixelSize: config.clockSize
                font.bold: true

                anchors.horizontalCenter: parent.horizontalCenter

                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter

                function updateTime() {
                    text = Qt.formatTime(new Date(), "hh\t\n\tmm")
                }

                Component.onCompleted: updateTime()

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: clock.updateTime()
                }
            }

            // Date
            Text {
                color: config.dateFgColor
                font.pixelSize: config.dateSize
                opacity: config.dateOpacity

                anchors.horizontalCenter: parent.horizontalCenter
                horizontalAlignment: Text.AlignHCenter

                function updateDate() {
                    text = Qt.formatDate(new Date(), "dddd, dd MMMM yyyy")
                }

                Component.onCompleted: updateDate()

                Timer {
                    interval: 60000
                    running: true
                    repeat: true
                    onTriggered: parent.updateDate()
                }
            }
        }
        
        // Login stuff
        // ------------------------------------------------------------------------------------------
        Column {
            id: loginColumn

            y: config.loginY * loginPanel.height
            anchors.horizontalCenter: loginPanel.horizontalCenter

            width: config.panelWidth
            spacing: 15
            
            // User
            // --------------------------------------------------------------------------------------
            Item {
                width: parent.width
                height: 48

                // Left Bracket
                Text {
                    anchors.left: userSelect.left
                    anchors.leftMargin: config.BracketDistance
                    anchors.verticalCenter: parent.verticalCenter

                    text: config.BracketLeft
                    color: config.BracketFgColor
                    font.pixelSize: config.BracketSize
                }

                // User
                ComboBox {
                    id: userSelect

                    anchors.fill: parent

                    model: userModel
                    textRole: "name"
                    currentIndex: userModel.lastIndex

                    contentItem: Text {
                        text: userSelect.displayText
                        color: config.userFgColor
                        font.pixelSize: config.userSize
                        font.bold: true
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        color: "transparent"
                        border.width: 0
                    }

                    indicator: Item {
                        width: 0
                        height: 0
                    }

                    delegate: ItemDelegate {
                        width: userSelect.width
                        height: 42

                        highlighted: userSelect.highlightedIndex === index

                        contentItem: Text {
                            text: model.name
                            color: config.userFgColor
                            font.pixelSize: config.userSize
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        background: Rectangle {
                            color: "transparent"
                        }
                    }

                    popup: Popup {
                        y: userSelect.height
                        width: userSelect.width
                        padding: 0

                        implicitHeight: Math.min(userSelect.delegateModel.count * 42, 210)

                        background: Rectangle {
                            color: config.userBgColor
                        }

                        contentItem: ListView {
                            clip: true
                            implicitHeight: contentHeight
                            model: userSelect.delegateModel
                            currentIndex: userSelect.highlightedIndex

                            ScrollIndicator.vertical: ScrollIndicator {
                                visible: userSelect.delegateModel.count > 5
                            }
                        }
                    }
                }
                
                // Right Bracket
                Text {
                    anchors.right: userSelect.right
                    anchors.rightMargin: config.BracketDistance
                    anchors.verticalCenter: parent.verticalCenter

                    text: config.BracketRight
                    color: config.BracketFgColor
                    font.pixelSize: config.BracketSize
                }
            }

            // Password
            // --------------------------------------------------------------------------------------
            TextField {
                id: password

                width: parent.width
                placeholderText: "Input password"
                placeholderTextColor: config.passwordPlaceholderColor
                echoMode: TextInput.Password
                color: config.passwordFgColor
                Component.onCompleted: forceActiveFocus()
                cursorVisible: false
                cursorDelegate: Item { }
                font.pixelSize: config.passwordSize
                
                focusPolicy: Qt.TabFocus

                KeyNavigation.tab: powerReboot
                KeyNavigation.backtab: powerOff
                
                horizontalAlignment: TextInput.AlignHCenter
                verticalAlignment: TextInput.AlignVCenter

                Keys.onReturnPressed: {
                    sddm.login(
                        userSelect.currentText,
                        password.text,
                        sessionModel.lastIndex
                    )

                    passwordClearAnimation.start()
                }

                NumberAnimation {
                    id: passwordClearAnimation
                    target: password
                    property: "clearProgressIn"
                    from: -0.2 // a little delay before 0.0
                    to: 1.0
                    duration: config.passwordAnimDuration / 2
                    easing.type: Easing.Linear
                }
                // Clear animation gradient
                property real clearProgressIn: 0.0
                property real clearProgressOut: 0.0
                background: Rectangle {
                    id: passwordBackground

                    color: "transparent"

                    gradient: Gradient {
                        orientation: Gradient.Horizontal

                        // Start
                        GradientStop {
                            position: 0.0
                            color: "transparent"
                        }

                        // Fill start
                        GradientStop {
                            position: Math.min(0.99999997, Math.max(0.0000001, Math.pow(password.clearProgressOut, 3.0) - 0.000001))
                            color: "transparent"
                        }

                        GradientStop {
                            position: Math.min(0.99999998, Math.max(0.0000002, Math.pow(password.clearProgressOut, 3.0)))
                            color: config.passwordFgColor
                        }

                        // Fill end
                        GradientStop {
                            position: Math.min(0.99999998, Math.max(0.0000003, Math.pow(password.clearProgressIn, 3.0)))
                            color: config.passwordFgColor
                        }
                        
                        GradientStop {
                            position: Math.min(0.99999999, Math.max(0.0000004, Math.pow(password.clearProgressIn, 3.0) + 0.0000001))
                            color: "transparent"
                        }

                        // end
                        GradientStop {
                            position: 1.0
                            color: "transparent"
                        }
                    }
                }
            }

            // Fail animation handler
            SequentialAnimation {
                id: errorAnimation

                ScriptAction {
                    script: {
                        password.text = ""
                        password.forceActiveFocus()
                    }
                }
                
                NumberAnimation {
                    target: password
                    property: "clearProgressOut"
                    from: 0.0
                    to: 1.0
                    duration: config.passwordAnimDuration / 2
                    easing.type: Easing.Linear
                }
                
                PropertyAction {
                    target: password
                    property: "clearProgressIn"
                    value: 0.0
                }

                PropertyAction {
                    target: password
                    property: "clearProgressOut"
                    value: 0.0
                }
            }
        }

        // Power buttons
        // ------------------------------------------------------------------------------------------
        Row {
            width: parent.width - config.powerPadding
            anchors.horizontalCenter: loginPanel.horizontalCenter
            y: config.powerY * loginPanel.height
            spacing: 15

            Button {
                id: powerReboot
                height: 40

                text: "OFF"

                onClicked: sddm.powerOff()
                Keys.onReturnPressed: click()
                Keys.onEnterPressed: click()
                hoverEnabled: true

                background: Rectangle {
                    color: "transparent"
                }

                focusPolicy: Qt.TabFocus

                KeyNavigation.tab: powerOff
                KeyNavigation.backtab: password
                
                contentItem: Text {
                    text: parent.text
                    color: parent.activeFocus ? config.powerOffFgColor : config.powerColor
                    font.pixelSize: config.powerSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
            }

            Button {
                id: powerOff
                height: 40

                text: "RBT"

                onClicked: sddm.reboot()
                Keys.onReturnPressed: click()
                Keys.onEnterPressed: click()
                hoverEnabled: true

                background: Rectangle {
                    color: "transparent"
                }

                focusPolicy: Qt.TabFocus

                KeyNavigation.tab: password
                KeyNavigation.backtab: powerReboot

                contentItem: Text {
                    text: parent.text
                    color: parent.activeFocus ? config.powerRebootFgColor : config.powerColor
                    font.pixelSize: config.powerSize
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    
                    Behavior on color {
                        ColorAnimation { duration: 150 }
                    }
                }
            }

        }
    }

    Connections {
        target: sddm

        function onLoginFailed() {
            errorAnimation.restart()
        }
    }
}
