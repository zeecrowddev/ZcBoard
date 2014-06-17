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

var instance = new Object();

function initPresenter()
{   
    instance.activePostIt = null;

    instance.forEachInArray = function(array, delegate)
    {
        for (var i=0;i<array.length;i++)
        {
            delegate(array[i]);
        }
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
