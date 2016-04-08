import QtQuick 2.6
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

Rectangle {
    id: transaction
    color: palette.transactionColor
    border.width: mm(.5)
    border.color: palette.transactionBorderColor
    radius: mm(2)
    width: mm(60)
    height: transactionText.height + radius * 2
    layer.enabled: elevation > 0
    layer.effect: DropShadow {
        horizontalOffset: mm(.1)
        verticalOffset: mm(.1)
        radius: mm(transaction.elevation)
        samples: 1 + radius*2
    }
    
    property real elevation: 1
    property string id: Qt.md5(text)
    property string text: Math.round(Math.random() * 1000)/100 + " from " + Qt.md5(Math.random()).slice(0,10) +
                          " to " + Qt.md5(Math.random()).slice(0,10)
    property var setting
    property bool animateReparenting: true

    Text {
        id: transactionText
        anchors.centerIn: parent
        opacity: .75
        text: "<b>ID:</b> " + transaction.id + "<br/>" + transaction.text
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
        width: parent.width - parent.radius * 2
    }

    states: [
        State {
            name: "REPARENTED"
            ParentChange {
                target: transaction
                parent: setting
                x: mm(.5)
                y: mm(.5)
            }
        }
    ]
    transitions: [
        Transition {
            from: "*"
            to: "REPARENTED"
            enabled: animateReparenting

            ParentAnimation {
                via: users

                NumberAnimation {
                    property: "x"
                    duration: 300
                    easing.type: Easing.InQuad
                }
                NumberAnimation {
                    property: "y"
                    duration: 400
                    easing.type: Easing.InQuad
                }
            }
        }
    ]
}
