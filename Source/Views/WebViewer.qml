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
    id : mainWebView

    anchors.fill: parent

    signal addUrl(string url)


    Rectangle
    {
        anchors.fill: parent
        color : "grey"
        opacity : 0.8
    }


    Item
    {
        id : webViewContainer

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
                    enabled  : webView.item === null ? false : webView.item.canGoBack
                    onTriggered :
                    {
                        webView.item.goBack()
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
                enabled  : webView.item === null ? false : webView.canGoForward
                onTriggered :
                {
                    webView.item.goForward()
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
        visible : webView.item !== null && webView.item.url.toString() !== null && webView.item.url.toString() !== "" && !webView.item.loading
        action : Action
        {
        iconSource  : "qrc:/ZcBoard/Resources/validate.png"
        tooltip     : "Add to the board"
        onTriggered :
        {

            var tmpx = mainView.x + webViewContainer.x + scrollView.x + scrollView.flickableItem.contentX
            var tmpy = mainView.y + webViewContainer.y + scrollView.y + scrollView.flickableItem.contentY
            var val =  mainView.mapToItem(null,tmpx,tmpy)

            mainView.grabWindow(mainView.context.temporaryPath + "web_grap.png" ,val.x,val.y,webView.width,webView.height);

            mainView.addUrlRessource(mainView.context.temporaryPath + "web_grap.png",webView.item.url.toString())
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


        width : webView.item === null ? 0 : parent.width * webView.item.loadProgress / 100

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

    text : webView === null ? "" : webView.item.url

    onAccepted:
    {
        webView.item.url = text
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


    Item
    {

        anchors.fill: parent

        Loader
        {
            id : webView
            width : scrollView.width
            height : scrollView.height
            Component.onCompleted:
            {

                if (mainView.useWebView === "")
                {
                    source = "qrc:/ZcBoard/Views/WebView/NoWebView.qml"
                }
                else if (mainView.useWebView === "WebKit")
                {
                    source = "qrc:/ZcBoard/Views/WebView/WebKit3.0.qml"
                }
                else if (mainView.useWebView === "WebView")
                {
                    source = "qrc:/ZcBoard/Views/WebView/WebView1.0.qml"
                }
            }
        }

    }
}

}
}
