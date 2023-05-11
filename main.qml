import QtQuick 2.15
import QtQuick.Window 2.15

import Ros 1.0
import QtQuick.Controls 2.15
import QtQuick.Shapes 1.15

import "RAF_GUI.js" as GUI

Window {
    id: window
    width: 1920     // Tablet Monitor
    height: 1015
    visible: true
    title: qsTr("Robot-Assisted Feeding")

    Rectangle {
        property double mousePosX: 0
        property double mousePosY: 0

        id: screen
        width: parent.width
        height: parent.height
        color: "#1a6850"
        state: "StartScreen"

        RosStringSubscriber{
                id: to_gui
                topic: "to_gui"
        }

        RosStringSubscriber{
                id: raf_message_subscriber
                topic: "raf_message"
        }

        RosStringSubscriber{
                id: cursor_angle
                topic: "raf_cursor_angle"
        }

        RosStringPublisher{
                id: from_gui
                topic: "from_gui"
            }

        RosStringPublisher{
                id: focus_request
                topic: "focus_request"
            }

//        Text {
//            id: toGuiText
//            color: "#ffffff"
//            text: "To GUI: " + to_gui.text
//            font.pixelSize: 16
//            anchors.top: parent.top
//            anchors.right: parent.right
//            anchors.topMargin: 300
//            anchors.rightMargin: 150
//        }

//        Text {
//            id: fromGuiText
//            color: "#ffffff"
//            text: "From GUI: " + from_gui.text
//            font.pixelSize: 16
//            anchors.top: parent.top
//            anchors.right: parent.right
//            anchors.topMargin: 400
//            anchors.rightMargin: 150
//        }

        MouseArea {
            id: screen_MouseArea
            hoverEnabled: true
            anchors.fill: parent
            propagateComposedEvents: true
            onPositionChanged: {
                var screenPosition = mapToItem(screen, mouse.x, mouse.y)
                screen.mousePosX = screenPosition.x
                screen.mousePosY = screenPosition.y
            }
          }

        SystemPalette { id: activePalette }

        Item {
            id: item_logo
            width: screen.width / 2
            height: screen.height / 1.8
            anchors.horizontalCenter: parent.horizontalCenter
            anchors { top: parent.top; }

            Image {
                id: chms_logo
                anchors.fill: parent
                source: "images/chms_logo.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Item {
            id: item_titleText
            width: titleText.width
            height: titleText.height
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: item_logo.bottom
            anchors.topMargin: 30

            Text {
                id: titleText
                width: screen.width
                color: "#ffffff"
                text: qsTr("Robot-Assisted Self-Feeding for Individuals with Spinal Cord Injury")
                font.pixelSize: 32
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }

        Item {
            id: item_logoSmall
            width: screen.width / 10
            height: screen.height / 6
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: -10
            anchors.rightMargin: 30

            Image {
                id: chms_logoSmall
                anchors.fill: parent
                source: "images/chms_logo.png"
                fillMode: Image.PreserveAspectFit
            }
        }

        Item {
            id: item_objectsHeader
            width: item_objects.width
            height: objectsText.height
            anchors.bottom: item_objects.top
            anchors.horizontalCenter: item_objects.horizontalCenter
            anchors.bottomMargin: 10

            Text {
                id: objectsText
                width: parent.width
                color: "#ffffff"
                text: raf_message_subscriber.text
                font.pixelSize: 36
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.right: parent.right
            }
        }

        Item {
            id: item_objects
            width: 1280
            height: 720
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 100

            Image {
                id: armCamera
                cache: false
                anchors.fill: parent
                source: "image://rosimage/arm_camera_image"
                fillMode: Image.PreserveAspectFit

                Timer {
                    interval: 50
                    repeat: true
                    running: true
                    onTriggered: { armCamera.source = ""; armCamera.source = "image://rosimage/arm_camera_image" }
                }
            }
        }

        Item {
            id: estop
            x: 1680
            y: 800
            width: 200
            height: 200
            property bool hoverDisabled: false

            Image {
                id: stop_sign
                anchors.fill: parent
                source: ma.containsMouse ? "images/stop_sign_highlight.png" : "images/stop_sign.png"
                fillMode: Image.PreserveAspectFit
                MouseArea {
                    id: ma
                    enabled: !estop.hoverDisabled
                    hoverEnabled: true
                    anchors.fill: parent
                    onPositionChanged: {
                        var screenPosition = mapToItem(screen, mouse.x, mouse.y)
                        screen.mousePosX = screenPosition.x
                        screen.mousePosY = screenPosition.y
                    }
                }
            }
        }

        StartDelay {
            id: startDelay
            text: "Press Here to Start"
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 180
            anchors.horizontalCenter: parent.horizontalCenter
        }

        BackDelay {
            id: backDelay
            text: "Back"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 20
            anchors.topMargin: 20
        }

        CustomDelay {
            id: enableDetections
            active: GUI.enableDetections
            guiEnableText: "enable-detections"
            guiDisableText: "disable-detections"
            enableText: "Enable Detections"
            disableText: "Disable Detections"
            disableCommand: "disable-detections"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: 75
            anchors.leftMargin: 325
        }

        CustomDelay {
            id: viewDetections
            active: GUI.viewDetections
            guiEnableText: "visualize-detections-normal"
            guiDisableText: "visualize-detections-normal-disable"
            enableText: "Show Detections"
            disableText: "Hide Detections"
            disableCommand: "disable-visualize-detections"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: 75
            anchors.leftMargin: 425
        }

        CustomDelay {
            id: selectDetections
            active: GUI.enableSelection
            guiEnableText: "visualize-detections-selection"
            guiDisableText: "visualize-detections-selection-disable"
            enableText: "Start Selection"
            disableText: "Stop Selection"
            disableCommand: "disable-selection"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: 75
            anchors.leftMargin: 525
        }

        CustomDelay {
            id: faceDetections
            active: GUI.enableFace
            guiEnableText: "enable-face-detections"
            guiDisableText: "disable-face-detections"
            enableText: "Enable Face Detection"
            disableText: "Disable Face Detection"
            disableCommand: "disable-face"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: 75
            anchors.leftMargin: 675
        }

        CustomDelay {
            id: viewFaceDetections
            active: GUI.viewFaceDetections
            guiEnableText: "visualize-face-detections"
            guiDisableText: "visualize-face-detections-disable"
            enableText: "Show Face Detection"
            disableText: "Hide Face Detection"
            disableCommand: "disable-visualize-face"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: 75
            anchors.leftMargin: 775
        }

        CustomDelay {
            id: visualServoing
            active: GUI.enableVisualServoing
            guiEnableText: "enable-visual-servoing"
            guiDisableText: "disable-visual-servoing"
            enableText: "Enable Visual Servoing"
            disableText: "Disable Visual Servoing"
            disableCommand: "disable-visual-servoing"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: 75
            anchors.leftMargin: 925
        }

        ResetDelay {
            id: reset
            active: GUI.enableReset
            guiEnableText: "reset"
            guiDisableText: "reset"
            enableText: "Reset"
            disableText: "Reset"
            disableCommand: "reset"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: 75
            anchors.leftMargin: 125
        }

        FocusDelay {
            id: focusCam
            active: GUI.enableFocus
            guiEnableText: "focus"
            guiDisableText: "focus"
            enableText: "Focus Camera"
            disableText: "Focus Camera"
            disableCommand: "disable-focus"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.bottomMargin: 275
            anchors.leftMargin: 125
        }

        Connections {
            target: to_gui
            function onTextChanged() {
                if (to_gui.text === enableDetections.disableCommand) {
                    enableDetections.border.color = Qt.darker(activePalette.button)
                    enableDetections.border.width = 1
                    enableDetections.active = false
                } else if (to_gui.text === viewDetections.disableCommand) {
                    viewDetections.border.color = Qt.darker(activePalette.button)
                    viewDetections.border.width = 1
                    viewDetections.active = false
                } else if (to_gui.text === selectDetections.disableCommand) {
                    selectDetections.border.color = Qt.darker(activePalette.button)
                    selectDetections.border.width = 1
                    selectDetections.active = false
                } else if (to_gui.text === faceDetections.disableCommand) {
                    faceDetections.border.color = Qt.darker(activePalette.button)
                    faceDetections.border.width = 1
                    faceDetections.active = false
                } else if (to_gui.text === viewFaceDetections.disableCommand) {
                    viewFaceDetections.border.color = Qt.darker(activePalette.button)
                    viewFaceDetections.border.width = 1
                    viewFaceDetections.active = false
                } else if (to_gui.text === visualServoing.disableCommand) {
                    visualServoing.border.color = Qt.darker(activePalette.button)
                    visualServoing.border.width = 1
                    visualServoing.active = false
                } else if (to_gui.text === focusCam.disableCommand) {
                    focusCam.border.color = Qt.darker(activePalette.button)
                    focusCam.border.width = 1
                    focusCam.active = false
                }
            }
        }

        CustomDelay {
            id: viewSelector
            active: false
            guiEnableText: "view-scene"
            guiDisableText: "view-arm"
            enableText: "Toggle Scene View"
            disableText: "Toggle Arm View"
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            anchors.bottomMargin: 75
            anchors.rightMargin: 350
        }

        Cursor {
            id: cursor
            x: screen.mousePosX - (width / 2)
            y: screen.mousePosY - (height / 2)
            z: 100
            angle: parseFloat(cursor_angle.text)
        }

        states: [
            State {
                name: "StartScreen"

                PropertyChanges {
                    target: item_logoSmall
                    visible: false
                }

                PropertyChanges {
                    target: item_objects
                    visible: false
                }

                PropertyChanges {
                    target: item_objectsHeader
                    visible: false
                }

                PropertyChanges {
                    target: backDelay
                    visible: false
                }

                PropertyChanges {
                    target: estop
                    visible: false
                }

                PropertyChanges {
                    target: enableDetections
                    visible: false
                }

                PropertyChanges {
                    target: viewDetections
                    visible: false
                }

                PropertyChanges {
                    target: selectDetections
                    visible: false
                }

                PropertyChanges {
                    target: viewSelector
                    visible: false
                }

                PropertyChanges {
                    target: reset
                    visible: false
                }

                PropertyChanges {
                    target: focusCam
                    visible: false
                }

                PropertyChanges {
                    target: faceDetections
                    visible: false
                }

                PropertyChanges {
                    target: viewFaceDetections
                    visible: false
                }

                PropertyChanges {
                    target: visualServoing
                    visible: false
                }
            },
            State {
                name: "SelectFoodItem"

                PropertyChanges {
                    target: item_logo
                    visible: false
                }

                PropertyChanges {
                    target: item_titleText
                    visible: false
                }

                PropertyChanges {
                    target: startDelay
                    visible: false
                }

                PropertyChanges {
                    target: estop
                    visible: true
                }

                PropertyChanges {
                    target: enableDetections
                    visible: true
                }

                PropertyChanges {
                    target: viewDetections
                    visible: true
                }

                PropertyChanges {
                    target: selectDetections
                    visible: true
                }

                PropertyChanges {
                    target: viewSelector
                    visible: true
                }

                PropertyChanges {
                    target: reset
                    visible: true
                }

                PropertyChanges {
                    target: focusCam
                    visible: true
                }

                PropertyChanges {
                    target: faceDetections
                    visible: true
                }

                PropertyChanges {
                    target: viewFaceDetections
                    visible: true
                }

                PropertyChanges {
                    target: visualServoing
                    visible: true
                }
            }
        ]
    }
}
