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
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.2

import "Tools.js" as Tools

FocusScope
{
    id : mainForum

    width : 200
    height : 200

    property int boxWidth : 0
    property int boxHeight : 0

    property string idItem  : "";
    property string title  : "";


    state : "comments"

    x : 0
    y : 0

    signal positionChanged(int valx,int valy,int valz, int valw, int valh, string c);
    signal deleteForum(string idItem);

    ListModel
    {
        id : comments
    }

    function updateComments(listComments)
    {
        comments.clear();

        if (listComments === null)
            return;

        Tools.forEachInArray( listComments , function (x) {
            comments.append({ "who" : x.who, "comment" : x.comment , "date" : x.date }) })
    }

    Rectangle
    {
        anchors.fill    : parent

        color : "white"

        opacity : 0.9

        border.width : 1
        border.color : "black"

        clip : true

    }


    TextArea
    {
        id : textAreaComment
        anchors
        {
            top : toolBarComments.bottom
            topMargin : 5
            horizontalCenter : parent.horizontalCenter
        }

        style : TextAreaStyle {  transientScrollBars : false; backgroundColor: Qt.lighter("#ff6600") }

        width : parent.width - 10

        height : mainForum.state == "addComments" ? 100 : 0
        visible : mainForum.state == "addComments"

        wrapMode: TextEdit.WordWrap
    }


    ListView
    {
        id : commentListView

        anchors.top : textAreaComment.bottom
        anchors.left : parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        model : comments

        delegate: commentDelegateComponent

//            CommentDelegate
//        {
//        contactImageSource : activity.getParticipantImageUrl(model.who)

//        Component.onCompleted:
//        {
//        }
//    }
    }


    //    Item
    //    {
    //        id                      : mouseAreaItem
    //        anchors.bottom          : parent.bottom
    //        anchors.bottomMargin    : 30
    //        anchors.left            : parent.left
    //        anchors.leftMargin      : 20
    //        anchors.right           : parent.right
    //        anchors.rightMargin     : 20
    //        anchors.top             : parent.top
    //        anchors.topMargin       : 40
    //        clip                    : true
    //    }


    MouseArea
    {
        id : mouseArea

        anchors.fill : parent

        drag.target     : mainForum
        drag.axis       : Drag.XAndYAxis
        drag.minimumX   : 0
        drag.minimumY   : 0


        property int oldmainForumX : 0
        property int oldmainForumY : 0

        onReleased:
        {
            if ( oldmainForumX !== mainForum.x ||
                    oldmainForumY !== mainForum.y
                    )
            {
                mainForum.positionChanged(mainForum.x,mainForum.y,mainForum.z,mainForum.width, mainForum.height,"")
            }
        }

        onPressed:
        {
            oldmainForumX = mainForum.x
            oldmainForumY = mainForum.y
            //           mainImage.state = "edition"
        }
    }


    ToolBar
    {
        id : toolBarComments
        style: ToolBarStyle {}

        RowLayout
        {
            ToolButton
            {

                visible : mainForum.state == "comments" ? true : false

                action : Action
                {
                id : addComment
                iconSource  : "qrc:/ZcBoard/Resources/plus.png"
                tooltip     : "Add a comment"
                onTriggered :
                {
                    mainForum.state = "addComments"
                    textAreaComment.focus = true
                    textAreaComment.forceActiveFocus();
                    textAreaComment.text = ""
                }
            }
        }
            ToolButton
            {
            visible : mainForum.state === "comments" ? false : true

            action : Action
            {
            id : validateComment
            iconSource  : "qrc:/ZcBoard/Resources/validate.png"
            tooltip     : "Validate the comment"
            onTriggered :
            {
                if (textAreaComment.text === "")
                    return;

                var element = {}
                element.title = mainForum.title
                element.comments = [];

                Tools.forEachInListModel(comments, function(x) {
                  var o = {};
                  o.who = x.who
                  o.date = x.date;
                  o.comment = x.comment;
                  element.comments.unshift(o)
                });

                var newElemnt = {}
                newElemnt.who = mainView.context.nickname
                newElemnt.comment = textAreaComment.text
                newElemnt.date = new Date().getTime()

                element.comments.unshift(newElemnt)

                mainView.addComments(idItem,JSON.stringify(element))
                mainForum.state = "comments"

            }
        }
    }
            ToolButton
            {
    visible : mainForum.state === "comments" ? false : true

    action : Action
    {
    id : cancelComment
    iconSource  : "qrc:/ZcBoard/Resources/cancel.png"
    tooltip     : "Cancel the comment"
    onTriggered :
    {
        mainForum.state = "comments"
    }
}
}

        Label
        {
    height : parent.height

    text : mainForum.title

    font.pixelSize: 16

    visible : mainForum.state == "comments" ? true : false
}
}
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
        x               : mainForum.width - 10
        y               : mainForum.height - 10

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
                mainForum.width = grow.x
                mainForum.height = grow.y
                mainForum.positionChanged(mainForum.x,mainForum.y,mainForum.z,mainForum.width, mainForum.height,"")
            }
        }
    }

    Image
    {
        id          :   close
        source                      : "qrc:/ZcBoard/Resources/bin.png"
        width           : 30
        height          : 30
        x               : mainForum.width - 15
        y               : - 15

        MouseArea
        {
            id : closeMouseArea

            anchors.fill    : parent
            onClicked       : deleteForum(idItem);
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
            {
                mainForum.positionChanged(mainForum.x,mainForum.y,mainForum.z + 1,mainForum.width, mainForum.height,"")
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

        MouseArea
        {
            anchors.fill: parent
            onClicked:
            {
                var z = mainForum.z - 1
                if (z <= 1)
                    z = 1;
                mainForum.positionChanged(mainForum.x,mainForum.y, z,mainForum.width, mainForum.height,"")
            }
        }
    }


    Component
    {
            id : commentDelegateComponent

                Item
                {
                    id : commentDelegate

                    property alias contactImageSource : contactImage.source

                    height : 50
                    width : parent.width


                    /*
                    ** Contact Image
                    ** default contact image set
                    */
                    Image
                    {
                        id : contactImage

                        width  : 50
                        height : width

                        anchors
                        {
                            top        : parent.top
                            topMargin  : 2
                            left       : parent.left
                            leftMargin : 2
                        }


                        source : activity.getParticipantImageUrl(model.who)

                        onStatusChanged:
                        {
                            if (status === Image.Error)
                            {
                                source = "qrc:/Crowd.Core/Qml/Ressources/Pictures/DefaultUser.png"
                            }
                        }
                    }

                    Item
                    {
                        id : textZone

                        anchors.top : parent.top
                        anchors.left : contactImage.right
                        anchors.leftMargin : 5


                        height : 50
                        width : parent.width - 60


                        property string url : ""


                        function updateDelegate(text)
                        {

                            textEdit.text = text;


                            var ligneHeight =  textEdit.lineCount * 17

                            var finalHeight = 28 + ligneHeight;

                            if (finalHeight < 70 )
                                finalHeight = 70;

                            textZone.height = finalHeight;
                            commentDelegate.height = finalHeight;
                        }

                        Component.onCompleted:
                        {
                            updateDelegate(model.comment);
                        }



                        Label
                        {
                            id                      : fromId
                            text                    : model.who
                            color                   : "black"
                            font.pixelSize          : appStyleId.baseTextHeigth
                            anchors
                            {
                                top             : parent.top
                                left            : parent.left
                                leftMargin      : 5
                            }

                            maximumLineCount        : 1
                            font.bold               : true
                            elide                   : Text.ElideRight
                            wrapMode                : Text.WrapAnywhere
                        }


                        Label
                        {
                            function getDate(x)
                            {
                                if (x !== null && x !== undefined && x !== "")
                                {
                                    return new Date(parseInt(x)).toDateString();
                                }
                                return new Date(0).toDateString();
                            }

                            id                      : timeStampId
                            text                    : getDate(model.date)
                            font.pixelSize          : 10
                            font.italic 			: true
                            anchors
                            {
                                top             : parent.top
                                right           : parent.right
                                rightMargin     : 2
                            }
                            maximumLineCount        : 1
                            elide                   : Text.ElideRight
                            wrapMode                : Text.WrapAnywhere
                            color                   : "gray"

                            horizontalAlignment: Text.AlignRight
                        }


                        Item
                        {

                            clip : true

                            anchors
                            {
                                top        : fromId.bottom
                                left       : parent.left
                                leftMargin : 25
                                right      : parent.right
                                rightMargin: 5
                                bottom     : parent.bottom
                            }

                            TextEdit
                            {
                                id  : textEdit
                                color : "black"

                                textFormat: Text.RichText

                                anchors
                                {
                                    top         : parent.top
                                    left        : parent.left
                                    leftMargin  : 5
                                    right       : parent.right
                                    bottom      : parent.bottom
                                }

                                readOnly                : true
                                selectByMouse           : true
                                font.pixelSize          : 14
                                wrapMode                : TextEdit.WrapAtWordBoundaryOrAnywhere

                            }

                        }
                    }

                    Rectangle
                    {
                        height : 1
                        width : parent.width - 10
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter

                        color : "grey"
                    }

                }

    }

}
