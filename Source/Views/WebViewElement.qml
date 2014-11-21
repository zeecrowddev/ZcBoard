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
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

FocusScope
{
    id : mainWebView

    width : 200
    height : 200

    property int boxWidth : 0
    property int boxHeight : 0

    property string idItem  : "";

    x : 0
    y : 0

    signal positionChanged(int valx,int valy,int valz, int valw, int valh, string c);
    signal deleteWebView(string idItem);

    property string url :  ""
    property alias imageSource :  imageId.source

    Rectangle
    {

        id : imageContainer

        anchors.fill    : parent

        color : "white"

        border.width : 1
        border.color : "black"

        clip : true

        Image
        {
            id              : imageId

            anchors.centerIn: parent

            property double sourceRatio : sourceSize.width / sourceSize.height
            property double  imageRatio : parent.width / parent.height

            width :  sourceRatio > imageRatio ? parent.height * sourceRatio : parent.width
            height : width /  sourceRatio

            Image
            {
                width : 50
                height : 50
                opacity : 0.5

                anchors.centerIn: parent

                source : "qrc:/ZcBoard/Resources/eye.png"


            }

        }
    }


    Item
    {
        id                      : mouseAreaItem
        anchors.bottom          : parent.bottom
        anchors.bottomMargin    : 30
        anchors.left            : parent.left
        anchors.leftMargin      : 20
        anchors.right           : parent.right
        anchors.rightMargin     : 20
        anchors.top             : parent.top
        anchors.topMargin       : 40
        clip                    : true
    }


    MouseArea
    {
        id : mouseArea

        anchors.fill : parent

        drag.target     : mainWebView
        drag.axis       : Drag.XAndYAxis
        drag.minimumX   : 0
        drag.minimumY   : 0


        property int oldmainWebViewX : 0
        property int oldmainWebViewY : 0

        MouseArea
        {
            width : 50
            height : 50

            anchors.centerIn:  parent

            onClicked:
            {
                Qt.openUrlExternally(mainWebView.url)

            }
        }


        onReleased:
        {
            if ( oldmainWebViewX !== mainWebView.x ||
                    oldmainWebViewY !== mainWebView.y
                    )
            {
                mainWebView.positionChanged(mainWebView.x,mainWebView.y,mainWebView.z,mainWebView.width, mainWebView.height,"")
            }
        }

        onPressed:
        {
            oldmainWebViewX = mainWebView.x
            oldmainWebViewY = mainWebView.y
            //           mainImage.state = "edition"
        }

        onClicked:
        {
            mainView.idItemFocused = idItem
        }
    }

    onStateChanged:
    {
    }

    Rectangle
    {
        x : 0
        y : 0

        color : "#00000000"
        visible : growMouseArea.drag.active ? true :  false
        width : grow.x
        height : grow.y

        border.width : 2
        border.color : "blue"
    }

    Rectangle
    {
        id : grow

        color : "white"
        border.width    : 2
        border.color    : "black"

        width           : 20
        height          : 20
        x               : mainWebView.width - 10
        y               : mainWebView.height - 10

        visible : idItem === mainView.idItemFocused

        MouseArea
        {
            id : growMouseArea

            anchors.fill  : parent

            drag.target     : grow
            drag.axis       : Drag.XAndYAxis
            drag.minimumX   : 0
            drag.minimumY   : 0

            onReleased:
            {
                mainWebView.width = grow.x
                mainWebView.height = grow.y
                mainWebView.positionChanged(mainWebView.x,mainWebView.y,mainWebView.z,mainWebView.width, mainWebView.height,"")
            }
        }
    }

    Image
    {
        id          :   close
        source                      : "qrc:/ZcBoard/Resources/bin.png"
        width           : 30
        height          : 30
        x               : mainWebView.width - 15
        y               : - 15

        visible : idItem === mainView.idItemFocused

        MouseArea
        {
            id : closeMouseArea

            anchors.fill    : parent
            onClicked       : deleteWebView(idItem);
        }
    }

    Image
    {
        id : tofront
        source                      : "qrc:/ZcBoard/Resources/toFront.png"
        width           : 30
        height          : 30
        anchors.top     : toback.top
        anchors.left    : toback.right

        visible : idItem === mainView.idItemFocused

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                mainWebView.positionChanged(mainWebView.x,mainWebView.y,mainWebView.z + 1,mainWebView.width, mainWebView.height,"")
            }
        }
    }

    Image
    {
        id : toback
        source                      : "qrc:/ZcBoard/Resources/toBack.png"
        width           : 30
        height          : 30
        x               : -15
        y               : -15

        visible : idItem === mainView.idItemFocused

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                var z = mainWebView.z - 1
                if (z <= 1)
                    z = 1;
                mainWebView.positionChanged(mainWebView.x,mainWebView.y, z,mainWebView.width, mainWebView.height,"")
            }
        }
    }
}
