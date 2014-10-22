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

FocusScope
{
    id : mainImage

    width : 200
    height : 200

    property int boxWidth : 0
    property int boxHeight : 0

    property string idItem  : "";

    x : 0
    y : 0

    signal positionChanged(int valx,int valy,int valz, int valw, int valh, string c);
    signal deleteImage(string idItem);

    property alias imageSource :  imageId.source

    Rectangle
    {
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

        }

        Label
        {
            anchors.centerIn: parent
            text : "Loading ... " + Math.round(imageId.progress * 100) + "%"
            visible : imageId.status !== Image.Ready
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

        drag.target     : mainImage
        drag.axis       : Drag.XAndYAxis
        drag.minimumX   : 0
        drag.minimumY   : 0


        property int oldmainImageX : 0
        property int oldmainImageY : 0

        onReleased:
        {
            if ( oldmainImageX !== mainImage.x ||
                    oldmainImageY !== mainImage.y
                    )
            {
                mainImage.positionChanged(mainImage.x,mainImage.y,mainImage.z,mainImage.width, mainImage.height,mainImage.mainImageColor)
            }
        }

        onPressed:
        {
            oldmainImageX = mainImage.x
            oldmainImageY = mainImage.y
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

        visible : idItem === mainView.idItemFocused


        width           : 20
        height          : 20
        x               : mainImage.width - 10
        y               : mainImage.height - 10

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
                mainImage.width = grow.x
                mainImage.height = grow.y
                mainImage.positionChanged(mainImage.x,mainImage.y,mainImage.z,mainImage.width, mainImage.height,mainImage.mainImageColor)
            }
        }
    }

    Image
    {
        id          :   close
        source                      : "qrc:/ZcBoard/Resources/bin.png"
        width           : 30
        height          : 30
        x               : mainImage.width - 15
        y               : - 15

        visible : idItem === mainView.idItemFocused

        MouseArea
        {
            id : closeMouseArea

            anchors.fill    : parent
            onClicked       : deleteImage(idItem);
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
                mainImage.positionChanged(mainImage.x,mainImage.y,mainImage.z + 1,mainImage.width, mainImage.height,mainImage.mainImageColor)
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
                var z = mainImage.z - 1
                if (z <= 1)
                    z = 1;
                mainImage.positionChanged(mainImage.x,mainImage.y, z,mainImage.width, mainImage.height,mainImage.mainImageColor)
            }
        }
    }
}
