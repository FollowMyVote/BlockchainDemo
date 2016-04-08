import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

ListView {
    id: transactions
    spacing: mm(1)
    clip: true
    interactive: false
    
    NumberAnimation on contentY {
        id: yAnimation
        duration: 200
    }
    function goToEnd() {
        yAnimation.running = false
        var pos = transactions.contentY
        var destPos
        transactions.positionViewAtEnd()
        destPos = transactions.contentY
        yAnimation.from = pos
        yAnimation.to = destPos
        yAnimation.running = true
    }
    delegate: Item {
        id: setting
        height: content.height + mm(1)
        width: parent.width

        property var content: model.content

        Component.onCompleted: {
            content.setting = setting
            if (!content.animateReparenting)
                content.state = "REPARENTED"
            content.visible = true
        }
        Component.onDestruction: {
            content.animateReparenting = false
            content.state = ""
            content.visible = false
        }

        ListView.onAdd: {
            var updater = function() {
                content.state = "REPARENTED"
                yAnimation.stopped.disconnect(updater)
            }
            yAnimation.stopped.connect(updater)
        }
    }
}
