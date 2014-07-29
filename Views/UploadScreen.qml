/**
* Copyright (c) 2010-2014 "Jabber Bees"
*
* This file is part of the ZcBoard application for the Zeecrowd platform.
*
* Zeecrowd is an online collaboration platform [http://www.zeecrowd.com]
*
* ChatTabs is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.2
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2

Rectangle
{
    anchors.fill: parent
    color : "grey"
    opacity : 0.5

    property alias progressValue : progressBar.value

    property string idItem  : ""
    property string type : ""
    property string name : ""
    property string url : ""
    //property string forum : ""

    Label
    {
        id : label
        anchors.centerIn: parent
        font.pixelSize:  40;
        color : "white"
        text : "Uploading ..."
    }

    ProgressBar
    {
        id : progressBar
        anchors.horizontalCenter: label.horizontalCenter
        anchors.top: label.bottom
        anchors.topMargin: 10
        height : 10
        width : 250

        style: ProgressBarStyle
        {
        }
    }
}

