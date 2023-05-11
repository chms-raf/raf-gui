import QtQuick 2.15
import QtQuick.Controls 2.12

DelayButton {
    id: control
    checked: false
    text: qsTr("Delay\nButton")
    delay: 1000
    onActivated: gui_state.text = "arm-cam-toggle"

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: "white"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: 100
        implicitHeight: 100
        opacity: enabled ? 1 : 0.3
        color: control.down ? "#17a81a" : "#21be2b"
        radius: size / 2

        readonly property real size: Math.min(control.width, control.height)
        width: size
        height: size
        anchors.centerIn: parent

        Canvas {
            id: canvas
            anchors.fill: parent

            Connections {
                target: control
                function onProgressChanged() { canvas.requestPaint(); }
            }

            onPaint: {
                var ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                ctx.strokeStyle = "white"
                ctx.lineWidth = parent.size / 20
                ctx.beginPath()
                var startAngle = Math.PI
                var endAngle = startAngle + control.progress * 2 * Math.PI
                ctx.arc(width / 2, height / 2, width / 2 - ctx.lineWidth / 2 - 2, startAngle, endAngle)
                ctx.stroke()
            }
        }
    }
}
