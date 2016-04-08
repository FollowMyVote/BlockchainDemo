import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

Window {
    visible: true
    width: 1920
    height: 1080
    color: palette.backgroundColor

    property alias pendingBlock: pendingBlockSetting.block

    function mm(count) {
        return count * Screen.pixelDensity
    }
    function validPow(id) {
        return id.slice(0,3) === "000"
    }

    QtObject {
        id: palette

        property color backgroundColor: "#DAFED3"
        property color foregroundColor: "#4BE22B"
        property color lightForegroundColor: "#88F471"

        property color blockColor: "#98F3E7"
        property color blockBorderColor: "#24BEA8"
        property color invalidBlockColor: "#FD7582"
        property color invalidBlockBorderColor: "#F93043"

        property color transactionColor: "#D4FB74"
        property color transactionBorderColor: "#BCF52F"

        property color blockchainColor: "#D4FB74"
        property color blockchainBorderColor: "#BCF52F"
    }
    Timer {
        id: miningTimer
        interval: 1
        running: true
        repeat: true
        onTriggered: {
            if (validPow(pendingBlock.id)) {
                transactionTimer.running = false
                miningTimer.running = false
                var finishedBlock = pendingBlock
                finishedBlock.z = 2
                pendingBlockSetting.createBlock()
                pendingBlock.previous = finishedBlock.id
                pendingBlock.blockHeight = finishedBlock.blockHeight + 1
                blockchain.addBlock(finishedBlock)
                transactionTimer.running = true
                miningTimer.running = true
            } else {
                pendingBlock.nonce += 1
            }
        }
    }
    Timer {
        id: transactionTimer
        running: true
        interval: 1000
        onTriggered: {
            pendingBlock.addTransaction(users.createTransaction())
            interval = Math.random()*3000 + 1000
            start()
        }
    }

    Item {
        anchors.fill: parent
        focus: true
        Keys.onEscapePressed: Qt.quit()
        Keys.onPressed: {
            if (event.key === Qt.Key_Q) Qt.quit()
            else if (event.key === Qt.Key_M) miningTimer.running = !miningTimer.running
            else if (event.key === Qt.Key_T) transactionTimer.running = !transactionTimer.running
        }
    }

    RowLayout {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: mm(3)

        ColumnLayout {
            id: miningColumn
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: mm(3)

            Item {
                id: pendingBlockSetting
                Layout.fillWidth: true
                Layout.preferredHeight: mm(55)

                property var block

                Component.onCompleted: createBlock()
                function createBlock() {
                    block = blockMaker.createObject(pendingBlockSetting)
                }

                Component {
                    id: blockMaker

                    Block {
                        setting: pendingBlockSetting
                    }
                }
            }
            Text {
                text: miningTimer.running? "Press M to stop mining" :
                                           "Press M to start mining"
            }
            Text {
                text: transactionTimer.running? "Press T to stop producing transactions"
                                              : "Press T to start producing transactions"
            }
            Item { width: 1; Layout.fillHeight: true }
            Users {
                id: users
            }
        }
        Blockchain {
            id: blockchain
        }
    }
}
