import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

Rectangle {
    id: block
    color: valid? palette.blockColor : palette.invalidBlockColor
    width: mm(65)
    height: mm(55)
    border.width: mm(.3)
    border.color: valid? palette.blockBorderColor : palette.invalidBlockBorderColor

    Behavior on color { ColorAnimation {} }
    Behavior on border.color { ColorAnimation {} }

    readonly property bool valid: validPow(id)
    property string id: Qt.md5(blockHeight + previous + nonce + transactionModel.digest())
    property int blockHeight: 1
    property string previous: new Array(Qt.md5(0).length).join("0")
    property int nonce: 0
    property alias transactions: transactionModel
    property var setting
    property bool animateReparenting: true

    function addTransaction(transaction) {
        transactionModel.append({"content": transaction})
        transactions.goToEnd()
    }
    
    ListModel {
        id: transactionModel
        
        function digest() {
            var ids = ""
            for (var i = 0; i < transactionModel.count; i++)
                ids += get(i).id
            return Qt.md5(ids)
        }
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: mm(1)
        
        Text {
            text: "<b>Block ID:</b> %1".arg(block.id)
        }
        Text {
            text: "Height: %1".arg(block.blockHeight)
        }
        Text {
            text: "Previous: %1".arg(block.previous)
        }
        Text {
            text: "Nonce: %1".arg(block.nonce)
        }
        Text {
            text: "Transactions:"
        }
        AnimatedListView {
            id: transactions
            Layout.fillHeight: true
            Layout.fillWidth: true
            interactive: block.valid

            model: transactionModel
        }
    }

    states: [
        State {
            name: "REPARENTED"
            ParentChange {
                target: block
                parent: setting
                x: mm(.5)
                y: mm(.5)
            }
            PropertyChanges {
                target: block
                width: setting.width - mm(1)
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
                    duration: 300
                    easing.type: Easing.InQuad
                }
            }
        }
    ]
}
