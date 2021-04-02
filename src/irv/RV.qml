import QtQuick 2.13
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.4 as Quick1_4
import QtQuick.Controls 2.5

import Backend 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 940
    height: 500
    title: qsTr("Hello World")

    FileDialog {
        id: fileDialog
        nameFilters: ["RawData files (*.raw)", "Ismrmrd files (*.h5)"]
        onAccepted: function() {
            vm.open_file_by_qurl(fileDialog.fileUrl)
        }
    }

    header: ToolBar {
        id: head

        RowLayout {
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            anchors.fill: parent
            ToolButton {
                width: 32
                text: qsTr("Load a file")
                onClicked: {
                    fileDialog.open()
                }
            }
            Item {
                Layout.fillWidth: true
            }
        }
    }

    RowLayout {
        anchors.fill: parent
        ColumnLayout {
            id: leftColumnLayout
            Layout.fillHeight: true
            Layout.fillWidth:  true
            Layout.preferredWidth: parent.width-128

            //data header part
            Quick1_4.TableView {
                id: tableView
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 64
                Layout.minimumWidth: 64

                Layout.preferredHeight: parent.height/2
                model: vm.tableModel

                currentRow: vm.tableModelSelectIndex

                Binding {
                    target: vm
                    property: "tableModelSelectIndex"
                    value: tableView.currentRow
                }


                Component{
                    id: columnComponet
                    Quick1_4.TableViewColumn {
                    }
                }

               Component.onCompleted: function() {
                    console.warn('method is: ' + Object.getOwnPropertyNames(tableView))
                }

                Connections {
                    target: vm.tableModel
                    onModelReset: function(){
                        console.warn('column number is '+tableView.columnCount)


                        var columnCount=tableView.columnCount
                        for(var i=0; i< columnCount;++i)
                        {
                            tableView.removeColumn(0)
                        }

                        var roleNames = tableView.model.RoleNames
                        console.warn("js role names is "+roleNames)

                        var roleNamesArray=roleNames.split(",")

                        for(var i=0; i<roleNamesArray.length; i++)
                        {
                                var role  = roleNamesArray[i]
                                var column=tableView.addColumn(columnComponet)

                                console.warn("add a new role" + role )
                                column.title=role
                                column.role=role
                        }
                    }
                }
            }

           Label{
             text: "CurrentRow:"+ vm.tableModelSelectIndex
           }

           //main plot part
           FigureCanvasByPython {
                id: mplView
                objectName : "figure"
                Layout.preferredHeight: parent.height/2

                Layout.fillWidth: true
                Layout.fillHeight: true
           }

        }

        ColumnLayout {
            Layout.fillHeight: true
            //Layout.preferredWidth: 128
            //channel control
            Label{
                text: "Channel:"+channelSlider.value
            }
            Quick1_4.Slider {
                id: channelSlider
                Layout.fillWidth: true
                Layout.preferredHeight: 32
                stepSize: 5
                maximumValue: vm.channelCount==0? 0:  vm.channelCount-1
                minimumValue: 0
                value: vm.currentChannelIndex

                Binding {
                    target: vm
                    property: "currentChannelIndex"
                    value: channelSlider.value
                }
            }
            //channel data
            ListView {
                Layout.fillHeight: true
                Layout.fillWidth: true
                delegate: Label {
                            text: display

                }
                model:vm.currentLineListModel
            }

        }
    }

}

