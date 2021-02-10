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

            Rectangle {
              id: bgCircle
              width: units.gu(40)
              height: units.gu(40)
              opacity: 0.85
              color: "#191919"
              radius: units.gu(20)
              Layout.alignment: Qt.AlignHCenter

            }

            Label {
              id: timerLabel
              Layout.alignment: Qt.AlignHCenter
              text: timer.display
              textSize: Label.XLarge
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
