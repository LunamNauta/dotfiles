import QtQuick

QtObject {
    required property var service

    Component.onCompleted: service.ref_count++
    Component.onDestruction: service.ref_count--
}
