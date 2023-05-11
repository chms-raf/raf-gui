import QtQuick 2.15

Rectangle {
    id: container
    property bool active: false
    property string text: "StartButton"

    width: buttonLabel.width + 30; height: buttonLabel.height + 30
    border { width: 1; color: Qt.darker(activePalette.button) }
    antialiasing: true
    radius: 8

    Text {
        id: buttonLabel
        anchors.centerIn: container
        color: activePalette.buttonText
        text: container.text
        font.pixelSize: 32
    }

    // color the button with a gradient
    gradient: Gradient {
        GradientStop {
            position: 0.0
            color: {
                if (mouseArea.containsMouse)
                    return activePalette.dark
                else
                    return activePalette.light
            }
        }
        GradientStop { position: 1.0; color: activePalette.button }
    }

    MouseArea {

        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        propagateComposedEvents: true

        onPositionChanged: {
            var screenPosition = mapToItem(screen, mouse.x, mouse.y)
            screen.mousePosX = screenPosition.x
            screen.mousePosY = screenPosition.y
        }

        onEntered: {
            timer.start()
        }

        onExited: {
            timer.stop()
        }
    }

    Timer {
        id: timer
        interval: 1000
        running: false
        repeat: false

        onTriggered: {
            screen.state = "StartScreen"
        }
    }

}
