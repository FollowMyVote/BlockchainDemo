import QtQuick 2.6
import QtQuick.Window 2.2
import QtGraphicalEffects 1.0

Item {
    id: users
    width: mm(4) + userBackRight.width
    height: mm(1) + userFront.height

    function createTransaction() {
        var user = priv.randomUser()
        var properties = {
            "y": user.y + mm(2),
            "scale": 0.05
        }

        var transaction = transactionMaker.createObject(users, properties)
        transaction.x = user.x + user.width/2 - transaction.width/2

        createTransactionAnimation.creatingUser = user
        createTransactionAnimation.createdTransaction = transaction
        createTransactionAnimation.restart()

        return transaction
    }

    QtObject {
        id: priv

        function randomUser() {
            var users = [userBackLeft, userFront, userBackRight]
            return users[Math.floor(Math.random() * 3)];
        }
    }
    Component {
        id: transactionMaker

        Transaction {}
    }

    SequentialAnimation {
        id: createTransactionAnimation
        property Item creatingUser
        property Item createdTransaction

        NumberAnimation {
            target: createTransactionAnimation.creatingUser
            property: "y"
            duration: 150
            easing.type: Easing.OutQuad
            from: 0; to: mm(-2)
        }
        ParallelAnimation {
            NumberAnimation {
                target: createTransactionAnimation.createdTransaction
                properties: "scale"
                from: 0; to: 1
                duration: 500
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: createTransactionAnimation.creatingUser
                property: "y"
                duration: 300
                easing.type: Easing.OutBounce
                from: mm(-2); to: 0
            }
        }
    }

    Image {
        id: userBackLeft
        source: "user.svg"
        fillMode: Image.PreserveAspectFit
        height: mm(15)
        layer.enabled: true
        layer.effect: ColorOverlay {
            color: palette.lightForegroundColor
        }
    }
    Image {
        id: userBackRight
        x: mm(4)
        source: "user.svg"
        fillMode: Image.PreserveAspectFit
        height: mm(15)
        layer.enabled: true
        layer.effect: ColorOverlay {
            color: palette.lightForegroundColor
        }
    }
    Image {
        id: userFront
        y: mm(1)
        x: mm(2)
        z: 1
        source: "user.svg"
        fillMode: Image.PreserveAspectFit
        height: mm(15)
        layer.enabled: true
        layer.effect: ColorOverlay {
            color: palette.foregroundColor
        }
    }
}
