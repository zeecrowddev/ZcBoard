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
import QtWebKit 3.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.1

Item
{
    id : mainWebView

    anchors.fill: parent

    signal addUrl(string url)


    function grabVisible()
    {
        growDown.visible = true;
        growUp.visible = true;
        grabBorder.visible = true;
        grabValidate.visible = true;
        grabClose.visible = true;
    }

    function  grabUnvisible()
    {
        growDown.visible = false;
        growUp.visible = false;
        grabBorder.visible = false;
        grabValidate.visible = false;
        grabClose.visible = false;
    }

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
                    id : downloadAction
                    iconSource  : "qrc:/ZcBoard/Resources/back.png"
                    tooltip     : "Back"
                    enabled  : webView.canGoBack
                    onTriggered :
                    {
                        webView.goBack()
                    }
                }
            }
                ToolButton
                {
                action : Action
                {
                id : nextId
                iconSource  : "qrc:/ZcBoard/Resources/next.png"
                tooltip     : "Next"
                enabled  : webView.canGoForward
                onTriggered :
                {
                    webView.goForward()
                }
            }
        }
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
    action : Action
    {
    iconSource  : "qrc:/ChatTabs/Resources/ok2.png"
    tooltip     : "Add to the board"
    onTriggered :
    {
        var idItem = mainView.generateId();
        var element = {}
        element.type = "Url"
        element.position =  mainView.getDefaultPosition()
        element.id = idItem
        element.url = webView.url.toString()
        elementDefinition.setItem(idItem,JSON.stringify(element));
        mainView.hideLoader()
    }
}
}
            }
        }


Rectangle
{
    id          : progressBarContainerId

    color : "black"
    anchors
    {
        top     : toolBar.bottom
        right   : parent.right
        left    : parent.left
    }

    height  : 3


    Rectangle
    {
        id          : progressBarId


        width : parent.width * webView.loadProgress / 100

        color       : "red"
        anchors
        {
            top     : parent.top
            left    : parent.left
        }

        height  : 3
    }
}

TextField
{
    style: TextFieldStyle{}

    id: textFieldUrl
    height : 30
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: progressBarContainerId.bottom
    anchors.topMargin: 3

    font.pixelSize: 16

    text : webView.url

    onAccepted:
    {
        webView.url = text
    }

    Component.onCompleted:
    {
        text = "http://"
    }
}


ScrollView
{
    id : scrollView

    anchors.top         : textFieldUrl.bottom
    anchors.topMargin   : 4
    anchors.bottom      : parent.bottom
    anchors.left        : parent.left
    anchors.right       : parent.right

    style : ScrollViewStyle {}


    WebView
    {
        id : webView


        anchors.fill: parent
    }
}

}
}
