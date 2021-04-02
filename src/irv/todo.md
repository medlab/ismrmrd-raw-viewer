1. change to static column
2. change to pyside6
3. change data to acq


#include <qqml.h>
#include <QAbstractTableModel>

class TableModel : public QAbstractTableModel
{
    Q_OBJECT
    QML_ELEMENT
    QML_ADDED_IN_MINOR_VERSION(1)

public:
    int rowCount(const QModelIndex & = QModelIndex()) const override
    {
        return 200;
    }

    int columnCount(const QModelIndex & = QModelIndex()) const override
    {
        return 200;
    }

    QVariant data(const QModelIndex &index, int role) const override
    {
        switch (role) {
            case Qt::DisplayRole:
                return QString("%1, %2").arg(index.column()).arg(index.row());
            default:
                break;
        }

        return QVariant();
    }

    QHash<int, QByteArray> roleNames() const override
    {
        return { {Qt::DisplayRole, "display"} };
    }
};
And then how to use it from QML:

import QtQuick 2.12
import TableModel 0.1

TableView {
    anchors.fill: parent
    columnSpacing: 1
    rowSpacing: 1
    clip: true

    model: TableModel {}

    delegate: Rectangle {
        implicitWidth: 100
        implicitHeight: 50
        Text {
            text: display
        }
    }
}


