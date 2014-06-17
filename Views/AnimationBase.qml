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

FocusScope
{
    id      : animationPanelId

    width   : parent.width
    height  : parent.height

    property Item main          : null
    property Item parking       : null


    signal showed()
    signal hided()

    function show()
    {
        animationPanelId.state = "show"
        showed();
    }

    function hide()
    {
        animationPanelId.state = "hide"
        hided();
    }

    states  :
        [
        State
        {
            name: "hide"

            ParentChange
            {
                target: animationPanelId;
                parent: parking;
                x: 0;
                y: 0
            }

        },
        State
        {
            name: "show"
            ParentChange
            {
                target: animationPanelId;
                parent: main;
                x: 0;
                y: 0
            }
        }
    ]


     transitions:
        Transition
        {
            ParentAnimation
            {
                NumberAnimation
                {
                    properties: "x,y";
                    duration: 700 ;
                    easing.type: Easing.InOutQuad
                }
            }
        }

}
