/**
* Copyright (c) 2010-2014 "Jabber Bees"
*
* This file is part of the ZcPostIt application for the Zeecrowd platform.
*
* Zeecrowd is an online collaboration platform [http://www.zeecrowd.com]
*
* ZcPostIt is free software: you can redistribute it and/or modify
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
        console.log(">> CREATE POSTIT")
        var postIt = null;
        if (Presenter.instance[idItem] === undefined ||
                Presenter.instance[idItem] === null)
        {
            postIt = postItComponent.createObject(board.internalBoard);
            postIt.idItem = idItem;
            Presenter.instance[idItem] = postIt;
            console.log(">> Presenter.instance[idItem] " + idItem + " " + postIt)
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
        console.log(">> CREATE IMAGE")
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
            element.x = position[0];
            element.y = position[1];
            element.z = position[2];
            element.width = position[3];
            element.height = position[4];


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

    toolBarActions :
        [
        Action {
            id: closeAction
            shortcut: "Ctrl+X"
            iconSource: "qrc:/ZcPostIt/Resources/close.png"
            tooltip : "Close Aplication"
            onTriggered:
            {
                mainView.closeTask();
            }
        },
        Action {
            id: plusYellow
            tooltip : "Add a yellow PostIt"
            iconSource : "qrc:/ZcPostIt/Resources/postit_yellow_icon.png"
            onTriggered:
            {
                var idItem = generateId();
                var element = {}
                element.type = "PostIt"
                element.position =  "0|0|0|200|200"
                element.color = "yellow"
                element.text = ""
                element.id = idItem
                elementDefinition.setItem(idItem,JSON.stringify(element));
            }
        },
        Action {
            id: plusResource
            tooltip : "Add a resource"
            iconSource : ""
            onTriggered:
            {
                fileDialog.open();
            }
        }

        /*,
        Action {
            id: plusBlue
            tooltip : "Add a blue PostIt"
            iconSource : "qrc:/ZcPostIt/Resources/postit_blue_icon.png"
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
            iconSource : "qrc:/ZcPostIt/Resources/postit_pink_icon.png"
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
            iconSource : "qrc:/ZcPostIt/Resources/postit_green_icon.png"
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
                id : queryStatusDocumentFolder


                onProgress :
                {
                    uploadScreenId.progressValue = value
                }

                onCompleted :
                {

                    var element = {}
                    element.type = uploadScreenId.type
                    element.position =  "0|0|0|200|200"
                    element.id = uploadScreenId.idItem
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
                console.log(">> itemchanged " +  value)
                var element = Tools.parseDatas(value)

                if (element.type === "PostIt")
                {
                    mainView.updatePostIt(idItem,element)

                }
                else if (element.type === "Image")
                {
                    mainView.updateImage(idItem,element)
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
        //        parking: parkingPanelLeft
        //        main : mainPanel

        //        state : "show"

        onClicked:
        {
            if (Presenter.instance.activePostIt !== null)
            {
                Presenter.instance.setActivePostIt(null);
            }
        }
    }

    Item
    {
        id : mainPanel
        anchors.fill: parent;
    }

    Item
    {
        id : parkingPanelLeft
        anchors.top         : parent.top
        anchors.right       : mainPanel.left
        width               : mainPanel.width
        height              : mainPanel.height
    }


    FileDialog
    {
        id: fileDialog
        nameFilters: ["All Files(*.*)"]

        onAccepted:
        {
            var ressource = zcResourceDescriptorId.fromLocalFile(fileUrl)
            console.log(">> MIMETYPE : " + zcResourceDescriptorId.mimeType)
            console.log(">> isImage : " + zcResourceDescriptorId.isImage())

            if (zcResourceDescriptorId.isImage())
            {

                uploadScreenId.visible = true;
                uploadScreenId.type = "Image"
                uploadScreenId.idItem = generateId();
                console.log(">> upload " + uploadScreenId.idItem)
                documentFolder.uploadFile(uploadScreenId.idItem,fileUrl,queryStatusDocumentFolder)
            }
        }
    }
}
