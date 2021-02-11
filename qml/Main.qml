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
    }

    Connections {
      target: timerCanvas
      onDisplayChanged: {
        timerCanvas.requestPaint()
      }
    }

    Page {
        anchors.fill: parent

        header: PageHeader {
            id: header
            title: i18n.tr('sycl')
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

            Item {
                Layout.fillHeight: true
            }

            Canvas {
                id:timerCanvas
                Layout.alignment: Qt.AlignHCenter

                property color arcColor:"lightgreen"
                property color arcBackgroundColor:"#ccc"
                property int bgArcWidth: units.gu(2)
                property int arcWidth: units.gu(1)
                property real progress: timer.progress * 360 // 0~360
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
                    ctx.arc(width/2,height/2,radius,0,Math.PI*2,anticlockwise)
                    ctx.stroke()

                    var r = progress*Math.PI/180
                    ctx.beginPath()
                    ctx.strokeStyle = arcColor
                    ctx.lineWidth = arcWidth

                    ctx.arc(width/2,height/2,radius,0-90*Math.PI/180,r-90*Math.PI/180,anticlockwise)
                    ctx.stroke()
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
}
