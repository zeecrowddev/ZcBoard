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
import QtQuick.Dialogs 1.1

import "Tools.js" as Tools
import "mainPresenter.js" as Presenter

import ZcClient 1.0 as Zc

Zc.AppView
{
    id : mainView

    anchors.fill : parent

    property string useWebView : ""

    function updatePostIt(idItem,postItDefinition)
    {
        var postIt = null;
        if (Presenter.instance[idItem] === undefined ||
                Presenter.instance[idItem] === null)
        {
            postIt = postItComponent.createObject(board.internalBoard);
            postIt.idItem = idItem;
            Presenter.instance[idItem] = postIt;
        }
        else
        {
            postIt = Presenter.instance[idItem];
        }

        if (postIt === null)
            return;

        updatePosition(postIt,postItDefinition.position);

        postIt.text = postItDefinition.text;
        postIt.postItColor = postItDefinition.color;
    }

    function updateImage(idItem,imageDefinition)
    {
        var image = null;
        if (Presenter.instance[idItem] === undefined ||
                Presenter.instance[idItem] === null)
        {
            image = imageComponent.createObject(board.internalBoard);
            image.idItem = idItem;
            Presenter.instance[idItem] = image;
        }
        else
        {
            image = Presenter.instance[idItem];
        }

        if (image === null)
            return;

        image.imageSource = documentFolder.getUrl(".image/"+ idItem)

        updatePosition(image,imageDefinition.position);
    }

    function updateForum(idItem,forumDefinition)
    {
        var forumElement = null;
        if (Presenter.instance[idItem] === undefined ||
                Presenter.instance[idItem] === null)
        {
            forumElement = forumComponent.createObject(board.internalBoard);
            forumElement.idItem = idItem;
            Presenter.instance[idItem] = forumElement;
        }
        else
        {
            forumElement = Presenter.instance[idItem];
        }

        if (forumElement === null)
            return;


        updatePosition(forumElement,forumDefinition.position);
    }

    function updateCommentInForum(idItem,forumDefinition)
    {
        var forumElement = null;
        if (Presenter.instance[idItem] === undefined ||
                Presenter.instance[idItem] === null)
        {
            forumElement = forumComponent.createObject(board.internalBoard);
            forumElement.idItem = idItem;
            Presenter.instance[idItem] = forumElement;
        }
        else
        {
            forumElement = Presenter.instance[idItem];
        }

        if (forumElement === null)
            return;

        if (forumDefinition.comments !== undefined && forumDefinition.comments !== null)
        {
            forumElement.updateComments(forumDefinition.comments)
        }
        else
            forumElement.updateComments(null)

        if (forumDefinition.title !== null && forumDefinition.title !== undefined)
        {
            forumElement.title = forumDefinition.title
        }

    }

    function updateWebView(idItem,webViewDefinition)
    {
        var webView = null;
        if (Presenter.instance[idItem] === undefined ||
                Presenter.instance[idItem] === null)
        {
            webView = webViewComponent.createObject(board.internalBoard);
            webView.idItem = idItem;
            Presenter.instance[idItem] = webView;
        }
        else
        {
            webView = Presenter.instance[idItem];
        }

        if (webView === null)
            return;

        webView.url = webViewDefinition.url
        webView.imageSource = documentFolder.getUrl(".web/" +idItem)

        updatePosition(webView,webViewDefinition.position);
    }

    function updatePosition(element,pos)
    {

        if (pos === "" || pos === undefined)
        {

            pos = mainView.getDefaultPosition();
        }
        var position = pos.split("|");

        if (position[0] !== "NaN")
            element.x = position[0];
        else
            element.x = 0

        if (position[1] !== "NaN")
            element.y = position[1];
        else
            element.y = 0

        if (position[2] !== "NaN")
            element.z = position[2];
        else
            element.z = 0

        element.width = position[3];
        element.height = position[4];

        if (element.z > mainView.zMax)
            zMax = element.z + 1;

        board.resize()
    }

    function closeTask()
    {
        mainView.close();
    }

    Zc.ResourceDescriptor
    {
        id : zcResourceDescriptorId
    }

    Zc.AppNotification
    {
        id : appNotification
    }

    onIsCurrentViewChanged :
    {
        if (isCurrentView == true)
        {
            appNotification.resetNotification();
        }
    }

    property int zMax : 0;
    property string idItemFocused : ""

    function getDefaultPosition()
    {
        var x = mainView.width / 2 - 100
        var y = mainView.height / 2 - 100
        var z = mainView.zMax + 1;

        return x  +"|" + y + "|" + z + "|200|200";
    }

    toolBarActions :
        [
        Action {
            id: closeAction
            shortcut: "Ctrl+X"
            iconSource: "qrc:/ZcBoard/Resources/close.png"
            tooltip : "Close Aplication"
            onTriggered:
            {
                board.focus = false;
                Qt.inputMethod.hide();
                mainView.closeTask();
            }
        },
        Action {
            id: plusYellow
            tooltip : "Add a yellow PostIt"
            iconSource : "qrc:/ZcBoard/Resources/postit_yellow_icon.png"
            onTriggered:
            {
                var idItem = generateId();
                var element = {}
                element.type = "PostIt"
                element.position = mainView.getDefaultPosition()
                element.color = "yellow"
                element.text = ""
                element.id = idItem
                elementDefinition.setItem(idItem,JSON.stringify(element));
            }
        },
        Action {
            id: plusResource
            tooltip : "Add a resource"
            iconSource : "qrc:/ZcBoard/Resources/plus.png"
            onTriggered:
            {
                fileDialog.open();
            }
        }
        ,
        Action {
            id: addUrl
            tooltip : "Add a web page"
            iconSource : "qrc:/ZcBoard/Resources/addUrl.png"
            enabled: mainView.useWebView !== ""
            onTriggered:
            {
                showLoader("qrc:/ZcBoard/Views/WebViewer.qml")
            }
        }
        ,
        Action {
            id: addForum
            tooltip : "Add a little forum"
            iconSource : "qrc:/ZcBoard/Resources/forum.png"
            onTriggered:
            {
                showLoader("qrc:/ZcBoard/Views/ForumViewer.qml")
            }
        }

        /*,
        Action {
            id: plusBlue
            tooltip : "Add a blue PostIt"
            iconSource : "qrc:/ZcBoard/Resources/postit_blue_icon.png"
            onTriggered:
            {
                var idItem = generateId();
                postItDefinition.setItem(idItem,"");
                postItPosition.setItem(idItem,"0|0|0|200|200|blue");
            }
        },
        Action {
            id: plusPink
            tooltip : "Add a pink PostIt"
            iconSource : "qrc:/ZcBoard/Resources/postit_pink_icon.png"
            onTriggered:
            {
                var idItem = generateId();
                postItDefinition.setItem(idItem,"");
                postItPosition.setItem(idItem,"0|0|0|200|200|pink");
            }
        }
        ,
        Action {
            id: plusGreen
            tooltip : "Add a green PostIt"
            iconSource : "qrc:/ZcBoard/Resources/postit_green_icon.png"
            onTriggered:
            {
                var idItem = generateId();
                postItDefinition.setItem(idItem,"");
                postItPosition.setItem(idItem,"0|0|0|200|200|green");
            }
        }*/
    ]

    SplashScreen
    {
        id : splashScreenId
        width : parent.width
        height: parent.height
    }

    Component
    {
        id : postItComponent

        PostIt
        {
            id : postIt
            boxWidth : mainView.width
            boxHeight : mainView.height

            onStateChanged:
            {
                if (state === "edition")
                {
                    Presenter.instance.setActivePostIt(postIt)
                }
            }

            onDeletePostIt:
            {
                elementDefinition.deleteItem(idItem);
            }

            onPositionChanged:
            {
                var o =  Tools.parseDatas(elementDefinition.getItem(idItem,""));
                o.position =  valx + "|" + valy + "|" + valz + "|" + valw + "|" + valh + "|" + c;
                elementDefinition.setItem(idItem,JSON.stringify(o));
            }

            onPostItTextChanged:
            {
                if (visible)
                {
                    var o =  Tools.parseDatas(elementDefinition.getItem(idItem,""));


                    if (o.text !== newText)
                    {
                        var modif = o.text === "" || o.text === null
                        o.text = newText
                        elementDefinition.setItem(idItem,JSON.stringify(o));
                        appNotification.logEvent( modif ? Zc.AppNotification.Modify : Zc.AppNotification.Add,"Post It",o.text,"")
                    }
                }
            }
        }
    }

    Component
    {
        id : imageComponent

        ImageElement
        {
            id : imageId
            boxWidth : mainView.width
            boxHeight : mainView.height


            onDeleteImage:
            {
                elementDefinition.deleteItem(idItem);
                documentFolder.deleteFile(".image/"+idItem,null)
            }

            onPositionChanged:
            {
                var o =  Tools.parseDatas(elementDefinition.getItem(idItem,""));
                o.position =  valx + "|" + valy + "|" + valz + "|" + valw + "|" + valh + "|" + c;
                elementDefinition.setItem(idItem,JSON.stringify(o));
            }
        }
    }

    Component
    {
        id : forumComponent

        ForumElement
        {
            id : imageId
            boxWidth : mainView.width
            boxHeight : mainView.height


            onDeleteForum:
            {
                elementDefinition.deleteItem(idItem);
               documentFolder.deleteFile(".forum/" + idItem  +"_txt",null)
            }

            onPositionChanged:
            {
                var o =  Tools.parseDatas(elementDefinition.getItem(idItem,""));
                o.position =  valx + "|" + valy + "|" + valz + "|" + valw + "|" + valh + "|" + c;
                elementDefinition.setItem(idItem,JSON.stringify(o));
            }
        }
    }

    Component
    {
        id : webViewComponent

        WebViewElement
        {
            id : webViewId
            boxWidth : mainView.width
            boxHeight : mainView.height


            onDeleteWebView:
            {
                elementDefinition.deleteItem(idItem);
                documentFolder.deleteFile(".web/" +idItem ,null)
            }

            onPositionChanged:
            {
                var o =  Tools.parseDatas(elementDefinition.getItem(idItem,""));
                o.position =  valx + "|" + valy + "|" + valz + "|" + valw + "|" + valh + "|" + c;
                elementDefinition.setItem(idItem,JSON.stringify(o));
            }
        }
    }

    function addUrlRessource(grabPath,url)
    {
        uploadScreenId.visible = true;
        uploadScreenId.type = "Url"
        uploadScreenId.idItem = generateId();
        uploadScreenId.url = url;
        documentFolder.uploadFile(".web/" + uploadScreenId.idItem,grabPath,queryStatusForAddUrlDocumentFolder)
    }

    function addComments(idItem,title,newtext,forum)
    {
        uploadScreenId.visible = true

        uploadScreenId.type = "Forum"
        uploadScreenId.idItem = idItem

        queryStatusForAddCommentDocumentFolder.title = title
        queryStatusForAddCommentDocumentFolder.newComment = newtext

        documentFolder.putText(".forum/" + uploadScreenId.idItem + "_txt",forum,queryStatusForAddCommentDocumentFolder);
    }


    function createANewForum(idItem,title,newtext,forum)
    {
        if (idItem === null || idItem === "")
        {
            idItem = generateId();
        }

        var element = {}
        element.type = "Forum"
        element.id =idItem

        elementDefinition.setItem(element.id,JSON.stringify(element));

        uploadScreenId.visible = true

        uploadScreenId.type = "Forum"
        uploadScreenId.idItem = idItem

        queryStatusForAddCommentDocumentFolder.title = title
        queryStatusForAddCommentDocumentFolder.newComment = newtext

        documentFolder.putText(".forum/" + uploadScreenId.idItem + "_txt",forum,queryStatusForAddCommentDocumentFolder);
     }

    function generateId()
    {
        var d = new Date();
        return mainView.context.nickname + "_" + d.getTime();
    }

    function loadForum(idItem)
    {
        var query = queryStatusForGetForumDocumentFolderComponent.createObject(mainView)

        query.idItem = idItem
        documentFolder.getText(".forum/" + idItem  + "_txt",query);

    }

    Zc.CrowdActivity
    {
        id : activity

        Zc.CrowdSharedResource
        {
            id   : documentFolder
            name : "ZcBoard"

            Zc.StorageQueryStatus
            {
                id : queryStatusForAddRessourceDocumentFolder


                onProgress :
                {
                    uploadScreenId.progressValue = value
                }

                onCompleted :
                {

                    var element = {}
                    element.type = uploadScreenId.type
                    element.position =  mainView.getDefaultPosition()
                    element.id = uploadScreenId.idItem
                    elementDefinition.setItem(element.id,JSON.stringify(element));
                    uploadScreenId.visible = false;
                    appNotification.logEvent(Zc.AppNotification.Add,"Picture","",documentFolder.getUrl(".image/"+ uploadScreenId.idItem))
                }
            }

            Zc.StorageQueryStatus
            {
                id : queryStatusForAddUrlDocumentFolder


                onProgress :
                {
                    uploadScreenId.progressValue = value
                }

                onCompleted :
                {

                    var element = {}
                    element.type = uploadScreenId.type
                    element.position =  mainView.getDefaultPosition()
                    element.id = uploadScreenId.idItem
                    element.url = uploadScreenId.url

                    elementDefinition.setItem(element.id,JSON.stringify(element));
                    uploadScreenId.visible = false;

                    appNotification.logEvent(Zc.AppNotification.Add,"Url",uploadScreenId.url,documentFolder.getUrl(".web/"+ uploadScreenId.idItem))

                }
            }

            Zc.StorageQueryStatus
            {
                id : queryStatusForAddCommentDocumentFolder

                property string title : ""
                property string newComment : ""

                onProgress :
                {
                    uploadScreenId.progressValue = value
                }

                onCompleted :
                {
//                    // Si l'element n'existe pas on le crée
//                    var element = {}
//                    element.type = uploadScreenId.type
//                    element.id = uploadScreenId.idItem

//                    elementDefinition.setItem(element.id,JSON.stringify(element));

                    // on notifie que le comment a changé
                    senderCommentNotify.sendMessage("",uploadScreenId.idItem)

                    appNotification.logEvent(Zc.AppNotification.Add,"Smart Forum \n" + title,newComment,"")


                    uploadScreenId.visible = false;
                }
            }

            Component
            {
                id : queryStatusForGetForumDocumentFolderComponent

                Zc.StorageQueryStatus
                {
                    id : queryStatusForGetForumDocumentFolder


                    property string idItem : ""

                    onProgress :
                    {
                        //       uploadScreenId.progressValue = value
                    }

                    onCompleted :
                    {
                        var value = elementDefinition.getItem(idItem,"");
                        var element = Tools.parseDatas(value)

                        var content = Tools.parseDatas(sender.text)
                        element.title = content.title
                        element.comments = content.comments

                        updateCommentInForum(idItem,element)

                        Presenter.instance.downloadForumFinished();
                    }
                }}

        }

        Zc.CrowdActivityItems
        {
            Zc.QueryStatus
            {
                id : elementDefinitionItemQueryStatus

                onCompleted :
                {
                    splashScreenId.visible = false;
                    splashScreenId.width = 0;
                    splashScreenId.height = 0;

                    var items = elementDefinition.getAllItems();

                    if (items !== null)
                    {
                        Tools.forEachInArray( items ,function (x)
                        {
                            var type =elementDefinition.addOrUpdateItemFromIdItem(x)

                            if (type === "Forum")
                            {
                                Presenter.instance.startForumDownload(x);
                            }
                        })
                    }
                }
            }

            id          : elementDefinition
            name        : "ElementDefinition"
            persistent  : true


            function addOrUpdateItemFromIdItem(idItem)
            {
                var value = elementDefinition.getItem(idItem,"");
                var element = Tools.parseDatas(value)

                if (element.type === "PostIt")
                {
                    mainView.updatePostIt(idItem,element)

                }
                else if (element.type === "Image")
                {
                    mainView.updateImage(idItem,element)
                }
                else if (element.type === "Url")
                {
                    mainView.updateWebView(idItem,element)
                }
                else if (element.type === "Forum")
                {
                    mainView.updateForum(idItem,element)
                }

                return element.type;

            }

            onItemChanged :
            {
                addOrUpdateItemFromIdItem(idItem)

                appNotification.blink();
                if (!mainView.isCurrentView)
                {
                    appNotification.incrementNotification();
                }
            }

            onItemDeleted :
            {
                if (Presenter.instance[idItem] === undefined ||
                        Presenter.instance[idItem] === null)
                    return;
                Presenter.instance[idItem].visible = false;
                Presenter.instance[idItem].parent === null;
                Presenter.instance[idItem] = null;
            }
        }

        Zc.MessageSender
        {
            id      : senderCommentNotify
            subject : "Comments"
        }

        Zc.MessageListener
        {
            id      : listenerCommentNotify
            subject : "Comments"

            onMessageReceived :
            {
                Presenter.instance.startForumDownload(message.body);
            }
        }

        onStarted :
        {
            elementDefinition.loadItems(elementDefinitionItemQueryStatus);
        }

    }

    onLoaded :
    {
        Presenter.initPresenter()
        activity.start();

        var webViewVersion =  mainView.context.getQtModuleVersion("QtWebView") !== "";
        var webKitVersion =  mainView.context.getQtModuleVersion("QtWebKit") !== "";
        mainView.useWebView = "";

        if (Qt.platform.os === "windows")
        {
            if (webViewVersion !== null && webViewVersion !== undefined)
                mainView.useWebView = "WebView"
            else
                mainView.useWebView = "WebKit"
        }
        else
        {
            if (webViewVersion !== null && webViewVersion !== undefined)
                mainView.useWebView = "WebView"
            else if (webKitVersion !== null && webKitVersion !== undefined)
                mainView.useWebView = "WebKit"
        }
 }

    onClosed :
    {
        activity.stop();
    }


    Board
    {
        id : board

        onClicked:
        {
            if (Presenter.instance.activePostIt !== null)
            {
                Presenter.instance.setActivePostIt(null);
            }
        }
    }

    function showLoader(source)
    {
        loader.source = source;
        loader.visible = true
    }

    function hideLoader()
    {
        loader.source = "";
        loader.visible = false
    }

    Loader
    {
        id : loader
        anchors.fill: parent
        visible : false
    }

    FileDialog
    {
        id: fileDialog
        nameFilters: ["All Files(*.*)"]

        onAccepted:
        {
            var ressource = zcResourceDescriptorId.fromLocalFile(fileUrl)

            if (zcResourceDescriptorId.isImage())
            {
                uploadScreenId.visible = true;
                uploadScreenId.type = "Image"
                uploadScreenId.idItem = generateId();
                documentFolder.uploadFile(".image/" + uploadScreenId.idItem,fileUrl,queryStatusForAddRessourceDocumentFolder)
            }
        }
    }

    UploadScreen
    {
        id : uploadScreenId
        width : parent.width
        height: parent.height
        visible : false

        z : 1000
    }

}
