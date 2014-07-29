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

Qt.include("Tools.js")

var instance = new Object();

function initPresenter()
{   
    instance.activePostIt = null;
    var forumsToDownload = []

    var dowloadInProgress = false;

    instance.nextForumDownload = function ()
    {
        if (forumsToDownload.length > 0 && !dowloadInProgress)
        {
            dowloadInProgress = true;
            var idItem = forumsToDownload.pop();
            mainView.loadForum(idItem)
        }
    }

    instance.startForumDownload = function(idItem)
    {
        if (existInArray(forumsToDownload, function(x){ return x === idItem }) )
            return;

        forumsToDownload.push(idItem)
        instance.nextForumDownload();
    }

    instance.downloadForumFinished = function()
    {
        dowloadInProgress = false
        instance.nextForumDownload();
    }

    instance.setActivePostIt = function(postIt)
    {
        if (instance.activePostIt !== null)
        {
            instance.activePostIt.state = "readonly";
        }

        instance.activePostIt = postIt;
   }
}
