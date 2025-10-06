import QtQuick

Item{
    id: root

    property real desiredSize: 10
    property string desiredColor: "#11111b"

    LeftBorder{
        desiredSize: root.desiredSize
        desiredColor: root.desiredColor
    }
    RightBorder{
        desiredSize: root.desiredSize
        desiredColor: root.desiredColor
    }
    BottomBorder{
        desiredSize: root.desiredSize
        desiredColor: root.desiredColor
    }
    BottomLeft{
        desiredRadius: root.desiredSize*1.5
        desiredColor: root.desiredColor
    }
    BottomRight{
        desiredRadius: root.desiredSize*1.5
        desiredColor: root.desiredColor
    }
    TopLeft{
        desiredRadius: root.desiredSize*1.5
        desiredColor: root.desiredColor
    }
    TopRight{
        desiredRadius: root.desiredSize*1.5
        desiredColor: root.desiredColor
    }
}
