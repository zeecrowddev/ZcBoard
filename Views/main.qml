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

        image.imageSource = documentFolder.getUrl(idItem)

        updatePosition(image,imageDefinition.position);
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

        if (pos === "")
        {
            element.x = 0;
            element.y = 0;
        }
        else
        {
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
    }

    function closeTask()
    {
        mainView.close();
    }

    Zc.ResourceDescriptor
    {
        id : zcResourceDescriptorId
    }


    property int zMax : 0;

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
            onTriggered:
            {
                showLoader("qrc:/ZcBoard/Views/WebViewer.qml")
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

    UploadScreen
    {
        id : uploadScreenId
        width : parent.width
        height: parent.height
        visible : false
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
                    o.text = newText
                    elementDefinition.setItem(idItem,JSON.stringify(o));
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

        console.log(">> grabPath " + grabPath)

        uploadScreenId.visible = true;
        uploadScreenId.type = "Url"
        uploadScreenId.idItem = generateId();
        uploadScreenId.url = url;
        documentFolder.uploadFile(".web/" + uploadScreenId.idItem,grabPath,queryStatusForAddUrlDocumentFolder)
    }


    function generateId()
    {
        var d = new Date();
        return mainView.context.nickname + "_" + d.getTime();
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
                }
            }
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
                            elementDefinition.addOrUpdateItemFromIdItem(x)
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
            }

            onItemChanged :
            {
                addOrUpdateItemFromIdItem(idItem)
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

        onStarted :
        {
            elementDefinition.loadItems(elementDefinitionItemQueryStatus);
        }

    }

    onLoaded :
    {
        Presenter.initPresenter()
        activity.start();
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
                documentFolder.uploadFile(uploadScreenId.idItem,fileUrl,queryStatusForAddRessourceDocumentFolder)
            }
        }
    }
}