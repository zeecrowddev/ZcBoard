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

Item
{
    id : mainForumView

    anchors.fill: parent


    Rectangle
    {
        anchors.fill: parent
        color : "grey"
        opacity : 0.8
    }


    Item
    {

        width : parent.width * 2 / 3
        height : parent.height * 2 / 3

        anchors.centerIn: parent

        ToolBar
        {
            id : toolBar

            anchors.top : parent.top

            RowLayout
            {
                ToolButton
                {
            action : Action
            {
            id : closeId
            iconSource  : "qrc:/ZcBoard/Resources/close.png"
            tooltip     : "Close"
            enabled : true
            onTriggered :
            {
                mainView.hideLoader()
            }
        }
    }
                ToolButton
                {
                    visible : true
                    action : Action
    {
    iconSource  : "qrc:/ZcBoard/Resources/validate.png"
    tooltip     : "Add to the board"
    onTriggered :
    {
        mainView.hideLoader()

        var forum = {}
        forum .title = textFieldLabel.text
        forum.comments = [];
        var comment = {};
        comment.who = mainView.context.nickname
        comment.comment = textAreaComment.text
        comment.date = new Date().getTime()
        forum.comments.push(comment)

        mainView.createANewForum("",textFieldLabel.text,textAreaComment.text,JSON.stringify(forum))
    }
}
}
            }
        }

        Item
        {
            anchors.top : toolBar.bottom
            anchors.topMargin : 5
            anchors.left: toolBar.left

            width : parent.width

            Rectangle
            {
                anchors.fill: parent
                color : "white"
                opacity : 0.5
            }

            height : 200

            Label
            {
                id : titleLabel

                anchors.top  : parent.top
                anchors.topMargin : 5
                anchors.left : parent.left
                anchors.leftMargin : 5

                text : "Title"

                font.pixelSize: 20
            }

            TextField
            {

                id : textFieldLabel

                style : TextFieldStyle
                {
                    background: Rectangle {
                            radius: 2
                            implicitWidth: 100
                            implicitHeight: 24
                            border.color: "#333"
                            border.width: 1
                        }
                }

                anchors.left : titleLabel.right
                anchors.leftMargin : 10
                anchors.right: parent.right
                anchors.rightMargin: 5

                anchors.verticalCenter: titleLabel.verticalCenter

            }

            TextArea
            {
                id : textAreaComment
                anchors.top : textFieldLabel.bottom
                anchors.left : parent.left
                anchors.right: parent.right
                anchors.bottom : parent.bottom
                anchors.topMargin : 10
                anchors.bottomMargin : 10
                anchors.leftMargin : 10
                anchors.rightMargin : 10
            }

        }


    }
}

