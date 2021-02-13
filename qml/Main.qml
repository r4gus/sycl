/*
 * Copyright (C) 2021  David P. Sugar
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * sycl is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Ubuntu.Components 1.3
import Ubuntu.Components.Pickers 1.0
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

import sugar.timer 1.0

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'sycl.sugar'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    Timer {
      id: timer
      onDisplayChanged: timerCanvas.requestPaint()
    }

    PageStack {
      id: pageStack
      Component.onCompleted: push(mainPage)

      Page {
          id: mainPage
          visible: false
          anchors.fill: parent

          header: PageHeader {
              id: header
              title: i18n.tr('sycl')

              trailingActionBar {
                actions: [
                  Action {
                    iconName: "settings"
                    text: "settings"
                    onTriggered: pageStack.push(settingsPage, {color: UbuntuColors.orange})
                  }
                ]
              }
          }

          ColumnLayout {
              spacing: units.gu(2)

              anchors {
                  margins: units.gu(2)
                  top: header.bottom
                  left: parent.left
                  right: parent.right
                  bottom: parent.bottom
              }

              RowLayout {

                Label {
                  text: "On"
                }

                Button {
                  id: onButton
                  property date date: new Date()
                  text: Qt.formatDateTime(date, "mm:ss")
                  onClicked: PickerPanel.openDatePicker(onButton, "date", "Minutes|Seconds")
                }

                Item {
                    Layout.fillWidth: true
                }

                Label {
                  text: "Off"
                }

                Button {
                  id: offButton
                  property date date: new Date()
                  text: Qt.formatDateTime(date, "mm:ss")
                  onClicked: PickerPanel.openDatePicker(offButton, "date", "Minutes|Seconds")
                }
              }



              Item {
                  Layout.fillHeight: true
              }

              Canvas {
                  id:timerCanvas
                  Layout.alignment: Qt.AlignHCenter

                  property color arcColor: UbuntuColors.orange
                  property color arcBackgroundColor: UbuntuColors.slate
                  property int bgArcWidth: units.gu(2)
                  property int arcWidth: units.gu(2)
                  property real progress: timer.progress // 0~360
                  property real radius: units.gu(16) //
                  property bool anticlockwise:false

                  width: 2 * radius + bgArcWidth
                  height:  2 * radius + bgArcWidth

                  onPaint: {
                      var ctx = getContext("2d")
                      var text,text_w
                      ctx.clearRect(0,0,width, height)
                      ctx.beginPath()
                      ctx.strokeStyle = arcBackgroundColor
                      ctx.lineWidth = bgArcWidth
                      ctx.fillStyle = UbuntuColors.ash
                      ctx.arc(width/2,height/2,radius,0,Math.PI*2,anticlockwise)
                      ctx.fill()
                      ctx.stroke()
                      ctx.restore()

                      var r = progress*Math.PI/180
                      ctx.beginPath()
                      ctx.strokeStyle = arcColor
                      ctx.lineWidth = arcWidth

                      ctx.arc(width/2,height/2,radius,0-90*Math.PI/180,r-90*Math.PI/180,anticlockwise)
                      ctx.stroke()
                      ctx.restore()
                  }

                  Label {
                    id: timerLapsLabel
                    anchors.bottom: timerLabel.top
                    anchors.horizontalCenter: timerLabel.horizontalCenter
                    text: timer.laps
                    textSize: Label.Large
                  }

                  Label {
                    id: timerLabel
                    anchors.centerIn: parent
                    text: timer.display
                    textSize: Label.XLarge
                  }

              }

              Button {
                  Layout.alignment: Qt.AlignHCenter
                  text: i18n.tr(timer.buttonText)
                  onClicked: {
                    timer.toggle()
                  }
              }

              Item {
                  Layout.fillHeight: true
              }
          }
      }

      Page {
        title: "Settings"
        id: settingsPage
        visible: false

        ColumnLayout {
            spacing: units.gu(2)

            Label {
                text: "On time: " + Qt.formatTime(onTimePicker.date, "mm:ss") + " mm/ss"
            }
            DatePicker {
                id: onTimePicker
                mode: "Minutes|Seconds"
            }

            Label {
                text: "Off time: " + Qt.formatTime(offTimePicker.date, "mm:ss") + " mm/ss"
            }
            DatePicker {
                id: offTimePicker
                mode: "Minutes|Seconds"
            }

            Button {
                text: i18n.tr("set time")
                onClicked: {
                  timer.set_on_time(onTimePicker.minutes, onTimePicker.seconds)
                  timer.set_off_time(offTimePicker.minutes, offTimePicker.seconds)
                }
            }

            Button {
              id: dateButton
              property date date: new Date()
              text: Qt.formatDateTime(date, "yyyy/MMMM")
              onClicked: PickerPanel.openDatePicker(dateButton, "date", "Years|Months")
            }
        }
      }
    }
}
