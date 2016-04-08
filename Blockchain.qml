import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

Rectangle {
    id: blockchain
    Layout.fillHeight: true
    Layout.preferredWidth: mainLayout.width / 2
    color: palette.blockchainColor
    border.width: mm(.3)
    border.color: palette.blockchainBorderColor
    z: -1
    
    function addBlock(block) {
        blockchainModel.append({"content": block})
        chainBlocks.goToEnd()
    }
    
    ListModel {
        id: blockchainModel
    }
    
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: mm(2)
        
        Text {
            text: "Blockchain"
        }
        AnimatedListView {
            id: chainBlocks
            Layout.fillHeight: true
            Layout.fillWidth: true
            interactive: miningTimer.running === false
            verticalLayoutDirection: ListView.BottomToTop
            
            model: blockchainModel
        }
    }
}
