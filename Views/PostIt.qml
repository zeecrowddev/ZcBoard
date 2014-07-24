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
    id : postIt

    width : 200
    height : 200

    property int boxWidth : 0
    property int boxHeight : 0

    property string idItem  : "";
    property alias  text    : textArea.text

    property string postItColor : "yellow"

    x : 0
    y : 0

    signal positionChanged(int valx,int valy,int valz, int valw, int valh, string c);
    signal postItTextChanged(string newText);
    signal deletePostIt(string idItem);


    BorderImage
    {
        id              : activeBorder
     //   color           : "#FBFC86"
        border { left: 30; top: 30; right: 30; bottom: 30 }
        anchors.fill    : parent
        source                      : "qrc:/ZcBoard/Resources/postit_" + postIt.postItColor +  ".png"

    }


    state           : "readonly"

    states:
        [
        State
        {
            name   : "edition"
            PropertyChanges
            {
                target      : textArea;
                readOnly    : false
                focus       : true
            }


            PropertyChanges
            {
                target      : mouseArea.anchors;
                bottom     : mouseAreaItem.top
            }

            PropertyChanges
            {
                target      : grow
                visible     : true
            }
            PropertyChanges
            {
                target      : close
                visible     : true
            }
            PropertyChanges
            {
                target      : toback
                visible     : true
            }
            PropertyChanges
            {
                target      : tofront
                visible     : true
            }
        },
        State
        {
            name   : "readonly"
            PropertyChanges
            {
                target      : textArea;
                readOnly    : true
                focus       : false;
            }

            PropertyChanges
            {
                target      : mouseArea.anchors;
                bottom     : postIt.bottom
            }
            PropertyChanges
            {
                target      : grow
                visible    : false
            }
            PropertyChanges
            {
                target      : close
                visible    : false
            }
            PropertyChanges
            {
                target      : toback
                visible     : false
            }
            PropertyChanges
            {
                target      : tofront
                visible     : false
            }
            PropertyChanges
            {
                target      : validate
                visible     : false
                enabled     : false
            }
        }
    ]


    Image
    {
        source                      : "qrc:/ZcBoard/Resources/tack.png"
        anchors.top                 : parent.top
        anchors.horizontalCenter    : parent.horizontalCenter
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

        TextArea
        {
            id                      : textArea
            anchors.top             : parent.top
            anchors.topMargin       : -2
            anchors.bottom          : parent.bottom
            anchors.bottomMargin    : -2
            anchors.left            : parent.left
            anchors.leftMargin      : -2
            anchors.right           : parent.right
            font.pixelSize          : 18
            anchors.rightMargin     : -2
            wrapMode                : TextEdit.WordWrap
            backgroundVisible: false

            onActiveFocusChanged:
            {
                if (activeFocus === false)
                {
                    postItTextChanged(text);
                }

            }

            onTextChanged:
            {
                if (postIt.state === "edition")
                 {
                    validate.visible = true;
                    validate.enabled = true;
                }
            }
        }
    }


    MouseArea
    {
        id : mouseArea

        anchors.top  : parent.top
        anchors.left  : parent.left
        anchors.right  : parent.right

        drag.target     : postIt
        drag.axis       : Drag.XAndYAxis
        drag.minimumX   : 0
        drag.minimumY   : 0


        property int oldPostItX : 0
        property int oldPostItY : 0

        onReleased:
        {
            if ( oldPostItX !== postIt.x ||
                    oldPostItY !== postIt.y
                    )
            {
                postIt.positionChanged(postIt.x,postIt.y,postIt.z,postIt.width, postIt.height,postIt.postItColor)
            }
        }

        onPressed:
        {
            oldPostItX = postIt.x
            oldPostItY = postIt.y
            postIt.state = "edition"
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

        radius : 10
        color : "#00000000"
        border.width    : 2
        border.color    : "blue"


        width           : 20
        height          : 20
        x               : postIt.width - 10
        y               : postIt.height - 30

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
                postIt.width = grow.x
                postIt.height = grow.y
                postIt.positionChanged(postIt.x,postIt.y,postIt.z,postIt.width, postIt.height,postIt.postItColor)
            }
        }
    }

    Image
    {
        id          :   close
        source                      : "qrc:/ZcBoard/Resources/bin.png"
        width           : 30
        height          : 30
        x               : postIt.width - 50
        y               : 0

        MouseArea
        {
            id : closeMouseArea

            anchors.fill  : parent

            onClicked: deletePostIt(idItem);

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

        MouseArea
        {
            anchors.fill: parent
            onClicked:
                postIt.positionChanged(postIt.x,postIt.y,postIt.z + 1,postIt.width, postIt.height,postIt.postItColor)
        }
    }



    Image
    {
        id : validate
        source                      : "qrc:/ZcBoard/Resources/validate.png"
        width           : 30
        height          : 30
        anchors.top     : tofront.top
        anchors.left    : tofront.right

        visible : false
        enabled : false

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                postIt.postItTextChanged(textArea.text)
                validate.visible = false;
                enabled.visible = false;
            }
        }
    }

    Image
    {
        id : toback
        source                      : "qrc:/ZcBoard/Resources/toBack.png"
        width           : 30
        height          : 30
        x               : 10
        y               : 0

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                var z = postIt.z - 1
                if (z <= 1)
                    z = 1;
                postIt.positionChanged(postIt.x,postIt.y, z,postIt.width, postIt.height,postIt.postItColor)
            }
        }
    }



}
