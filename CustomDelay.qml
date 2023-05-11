import QtQuick 2.15

Rectangle {
    id: container

    property bool active: false
    property string guiEnableText: ""
    property string guiDisableText: ""
    property string enableText: ""
    property string disableText: ""
    property string disableCommand: ""

    width: 100
    height: 100
    radius: width*0.5
    border { width: 1; color: Qt.darker(activePalette.button) }

    Text {
        width: 78
        id: container_text
        text: container.enableText
        anchors.centerIn: parent
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
    }

    Connections {
        target: to_gui
        function onTextChanged() {
            container_text.text = Qt.binding(function() { return (to_gui.text === container.disableCommand) ? container.enableText : container_text.text });
        }
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
            container.active ? from_gui.text = container.guiDisableText : from_gui.text = container.guiEnableText
            container.active ? container.border.color = Qt.darker(activePalette.button) : container.border.color = "yellow"
            container.active ? container.border.width = 1 : container.border.width = 3
            container.active ? container_text.text = container.enableText : container_text.text = container.disableText
            container.active ? container.active = false : container.active = true
        }
    }

}
