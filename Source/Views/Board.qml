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
import QtQuick.Controls.Styles 1.2
import "mainPresenter.js" as Presenter

ScrollView
{
    id : board

    property alias internalBoard : flickBoard

    function createPostIt(component)
    {
        component.createObject(flickBoard.contentItem)
    }

    Component.onCompleted:
    {
    //    flickableItem.interactive = false
    }

    style : ScrollViewStyle {}

    function resize()
    {
        var vx = 0;
        var vy = 0;

        for(var i = 0 ; i < contentItem.children.length ; i++)
        {
            var item = contentItem.children[i];

            if (item.idItem!== undefined)
            {
                if (item.x+item.width > vx)
                {
                    vx = item.x+item.width;
                }
                if (item.y+item.height > vy)
                {
                    vy = item.y+item.height;
                }
            }
        }

        flickBoard.width = vx //+ 10
        flickBoard.height = vy //+ 10
    }

    anchors.fill: parent

    signal clicked();

    Item
    {
        id : flickBoard

        Component.onCompleted:
        {
            height = parent.height// - 10
            width = parent.width// - 10
        }

        MouseArea
        {
            anchors.fill: parent

            onClicked: mainView.idItemFocused = false
        }


    }
}
