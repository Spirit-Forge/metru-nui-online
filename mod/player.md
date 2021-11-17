# Removed Built-In Login System

## `texts` -> `DefineText (136)`

Original:

```
Create New User
```

Modified:

```
Start New Game
```

## `sprites` -> `DefineSprite (150)`

Removed:

-    `Username:` label.
-    `Password:` label.
-    Username input.
-    Password input.

## `scripts` -> `DefineButton2 (145)`

Original:

```
on(release, keyPress "<Enter>"){
    if(_root.creatorBox.goButton._x == undefined)
    {
        _root.validated.text = "";
        if(username.text == "Alicia" && password.text == "ilovebees")
        {
            _root.scene.change("z_colossal_caverns");
        }
        else if(username.text == "Akilini")
        {
            _root.scene.change("akilini");
        }
        else if(username.text != "" && password.text != "")
        {
            _parent.userVar = username.text;
            _parent.passVar = password.text;
            play();
        }
        else if(username.text == "" && password.text != "")
        {
            _root.validated.text = "Please input a username.";
        }
        else if(username.text != "" && password.text == "")
        {
            _root.validated.text = "Please input a password.";
        }
        else if(username.text == "" && password.text == "")
        {
            _root.validated.text = "Please input a username and password.";
        }
    }
}
```

Modified:

```
on(release, keyPress "<Enter>"){
    if(_root.creatorBox.goButton._x == undefined)
    {
        _root.validated.text = "";
        _parent.userVar = "";
        _parent.passVar = "password";
        play();
    }
}
```

## `scripts` -> `DefineSprite (150)` -> `frame 4`

```
if(_parent.passVar == _root.player.playerStatus[7])
{
    if(_root.player.playerStatus[9] == "endgame")
    {
        _root.gotoAndStop("endgame");
    }
    else
    {
        _root.scene.change(_root.player.playerStatus[9]);
    }
    this.gotoAndStop(1);
}
else
{
    delete _root.player.playerStatus;
    _root.validated.text = "That username and password do not match.";
    this.gotoAndStop(1);
}
```

```
if(_parent.passVar == _root.player.playerStatus[7])
{
    if(_root.player.playerStatus[9] == "endgame")
    {
        _root.gotoAndStop("endgame");
    }
    else
    {
        _root.scene.change(_root.player.playerStatus[9]);
    }
    this.gotoAndStop(1);
}
else
{
    delete _root.player.playerStatus;
    _root.validated.text = "No saved game, please start a new game.";
    this.gotoAndStop(1);
}
```

## `scripts` -> `frame 3`

Original:

```
player = new Object();
player.setStatus = function()
{
    XMLObject.loadToArray("player","setStatus.php?username=" + player.playerStatus[6] + "&password=" + player.playerStatus[7] + "&location=" + player.playerStatus[0] + "&prevLocation=" + player.playerStatus[1] + "&items=" + player.playerStatus[3] + "&energy=" + player.playerStatus[4] + "&disks=" + player.playerStatus[5] + "&widgets=" + player.playerStatus[8] + "&currentZone=" + player.playerStatus[9] + "&akiliniDisks=" + player.playerStatus[10] + "&hoverDisk=" + player.playerStatus[11] + "&anarchist=" + player.playerStatus[12] + "&idealist=" + player.playerStatus[13] + "&airship=" + player.playerStatus[14] + "&akilini=" + player.playerStatus[15] + "&gamesWon=" + player.playerStatus[16] + "&temple=" + player.playerStatus[17] + "&tournament=" + player.playerStatus[18],targetPath(this));
};
player.loadStatus = function(username, password)
{
    XMLObject.loadToArray("player","getStatus.php?username=" + username + "&password=" + password,"_root.loginBar");
};
player.checkStatusFunc = function(username)
{
    XMLObject.loadToArray("player","checkStatus.php?username=" + username,"_root.creatorBox");
};
player.validate = function()
{
    player.loadStatus(loginBar.username.text);
    if(loginBar.password.text == player.playerStatus[7])
    {
        _root.scene.change(_root.player.playerStatus[9]);
    }
    else
    {
        delete player.playerStatus;
        validated.text = "That username and password do not match.";
    }
};
player.playerStatus = new Array();
player.itemAdd = function(item, number)
{
    debugger.output("Item No. " + item + " attached.","item");
    debugger.output(String(item).charAt(2));
    if(String(item).charAt(2) != "9")
    {
        player.playerStatus[3] = player.playerStatus[3] + "," + item;
        menuHolder.itemContainer["itemBox" + _root.stage.platform.player.activeItem].highlightBar._visible = false;
        _root.stage.platform.player.activeItem = item;
        menuHolder.itemContainer["itemBox" + item].highlightBar._visible = true;
    }
    else
    {
        player.playerStatus[10] = player.playerStatus[10] + "," + String(item).charAt(0) + String(item).charAt(1);
        menuHolder.itemContainer["itemBox" + _root.stage.platform.player.activeItem].highlightBar._visible = false;
        _root.stage.platform.player.activeItem = 11;
        _root.stage.platform.player.body.leftArm.hand.item.diskNum = String(item).charAt(0) + String(item).charAt(1);
    }
    if(menu.itemData[item] == "material")
    {
        menu.activeItems = "materials";
        menuHolder.selector1.gotoAndStop(2);
        menuHolder.selector2.gotoAndStop(1);
        menuHolder.selector3.gotoAndStop(1);
        menuHolder.selector4.gotoAndStop(1);
    }
    else if(menu.itemData[item] == "key")
    {
        menu.activeItems = "keys";
        menuHolder.selector1.gotoAndStop(1);
        menuHolder.selector2.gotoAndStop(1);
        menuHolder.selector3.gotoAndStop(2);
        enuHolder.selector4.gotoAndStop(1);
    }
    else if(menu.itemData[item] == "tool")
    {
        menu.activeItems = "tools";
        menuHolder.selector1.gotoAndStop(1);
        menuHolder.selector2.gotoAndStop(2);
        menuHolder.selector3.gotoAndStop(1);
        enuHolder.selector4.gotoAndStop(1);
    }
    menu.itemParse();
};
player.itemRemove = function(item, number)
{
    debugger.output("Item No. " + item + " removed.","item");
    removeArray = new Array();
    removeArray = player.playerStatus[3].split(",");
    var i = 0;
    while(i < removeArray.length)
    {
        if(removeArray[i] == item && number > 0)
        {
            number--;
            removeArray.splice(i,1);
        }
        i++;
    }
    player.playerStatus[3] = removeArray.toString();
    menu.itemParse();
};
player.healthChange = function(amount)
{
    if(_root.menuHolder.healthPill._currentframe + amount > 0 && _root.menuHolder.healthPill._currentframe + amount <= 100)
    {
        _root.player.playerStatus[4] += amount;
        _root.menuHolder.healthPill.gotoAndStop(Math.floor(_root.player.playerStatus[4]));
    }
    else if(_root.menuHolder.healthPill._currentframe + amount > 100)
    {
        _root.player.playerStatus[4] = 100;
        _root.menuHolder.healthPill.gotoAndStop(100);
    }
    else
    {
        scene.change("z_coliseum");
        _root.player.playerStatus[0] = "prison";
        _root.player.playerStatus[1] = "elsewhere";
    }
};
player.examine = function(frame)
{
    debugger.output("Examining " + frame);
    examine._visible = true;
    examine.gotoAndStop(frame);
};
_root.loader.nextFrame();
```

Modified:

```
player = new Object();
player.setStatus = function()
{
    XMLObject.loadToArray("player","setStatus.php?username=" + player.playerStatus[6] + "&password=" + player.playerStatus[7] + "&location=" + player.playerStatus[0] + "&prevLocation=" + player.playerStatus[1] + "&items=" + player.playerStatus[3] + "&energy=" + player.playerStatus[4] + "&disks=" + player.playerStatus[5] + "&widgets=" + player.playerStatus[8] + "&currentZone=" + player.playerStatus[9] + "&akiliniDisks=" + player.playerStatus[10] + "&hoverDisk=" + player.playerStatus[11] + "&anarchist=" + player.playerStatus[12] + "&idealist=" + player.playerStatus[13] + "&airship=" + player.playerStatus[14] + "&akilini=" + player.playerStatus[15] + "&gamesWon=" + player.playerStatus[16] + "&temple=" + player.playerStatus[17] + "&tournament=" + player.playerStatus[18],targetPath(this));
};
player.loadStatus = function(username, password)
{
    XMLObject.loadToArray("player","getStatus.php?username=" + username + "&password=" + password,"_root.loginBar");
};
player.checkStatusFunc = function(username)
{
    XMLObject.loadToArray("player","checkStatus.php?username=" + username,"_root.creatorBox");
};
player.validate = function()
{
    player.loadStatus("");
    if(player.playerStatus[7] == "password")
    {
        _root.scene.change(_root.player.playerStatus[9]);
    }
    else
    {
        delete player.playerStatus;
        validated.text = "No saved game, please start a new game.";
    }
};
player.playerStatus = new Array();
player.itemAdd = function(item, number)
{
    debugger.output("Item No. " + item + " attached.","item");
    debugger.output(String(item).charAt(2));
    if(String(item).charAt(2) != "9")
    {
        player.playerStatus[3] = player.playerStatus[3] + "," + item;
        menuHolder.itemContainer["itemBox" + _root.stage.platform.player.activeItem].highlightBar._visible = false;
        _root.stage.platform.player.activeItem = item;
        menuHolder.itemContainer["itemBox" + item].highlightBar._visible = true;
    }
    else
    {
        player.playerStatus[10] = player.playerStatus[10] + "," + String(item).charAt(0) + String(item).charAt(1);
        menuHolder.itemContainer["itemBox" + _root.stage.platform.player.activeItem].highlightBar._visible = false;
        _root.stage.platform.player.activeItem = 11;
        _root.stage.platform.player.body.leftArm.hand.item.diskNum = String(item).charAt(0) + String(item).charAt(1);
    }
    if(menu.itemData[item] == "material")
    {
        menu.activeItems = "materials";
        menuHolder.selector1.gotoAndStop(2);
        menuHolder.selector2.gotoAndStop(1);
        menuHolder.selector3.gotoAndStop(1);
        menuHolder.selector4.gotoAndStop(1);
    }
    else if(menu.itemData[item] == "key")
    {
        menu.activeItems = "keys";
        menuHolder.selector1.gotoAndStop(1);
        menuHolder.selector2.gotoAndStop(1);
        menuHolder.selector3.gotoAndStop(2);
        enuHolder.selector4.gotoAndStop(1);
    }
    else if(menu.itemData[item] == "tool")
    {
        menu.activeItems = "tools";
        menuHolder.selector1.gotoAndStop(1);
        menuHolder.selector2.gotoAndStop(2);
        menuHolder.selector3.gotoAndStop(1);
        enuHolder.selector4.gotoAndStop(1);
    }
    menu.itemParse();
};
player.itemRemove = function(item, number)
{
    debugger.output("Item No. " + item + " removed.","item");
    removeArray = new Array();
    removeArray = player.playerStatus[3].split(",");
    var i = 0;
    while(i < removeArray.length)
    {
        if(removeArray[i] == item && number > 0)
        {
            number--;
            removeArray.splice(i,1);
        }
        i++;
    }
    player.playerStatus[3] = removeArray.toString();
    menu.itemParse();
};
player.healthChange = function(amount)
{
    if(_root.menuHolder.healthPill._currentframe + amount > 0 && _root.menuHolder.healthPill._currentframe + amount <= 100)
    {
        _root.player.playerStatus[4] += amount;
        _root.menuHolder.healthPill.gotoAndStop(Math.floor(_root.player.playerStatus[4]));
    }
    else if(_root.menuHolder.healthPill._currentframe + amount > 100)
    {
        _root.player.playerStatus[4] = 100;
        _root.menuHolder.healthPill.gotoAndStop(100);
    }
    else
    {
        scene.change("z_coliseum");
        _root.player.playerStatus[0] = "prison";
        _root.player.playerStatus[1] = "elsewhere";
    }
};
player.examine = function(frame)
{
    debugger.output("Examining " + frame);
    examine._visible = true;
    examine.gotoAndStop(frame);
};
_root.loader.nextFrame();
```


# Alternative saving

## `scripts` -> `frame 5`

Original:

```
XMLObject = new Object();
XMLObject.loadToArray = function(arrayLocation, XMLName, location)
{
    function onMyLoad(success)
    {
        if(!success)
        {
            _root.debugger.display("If you are experiencing this error, the XML data did not load correctly. Please report the following error code to the administrator:",XMLName);
        }
        else
        {
            _root[arrayLocation].loaderXML.parseXML(src);
            if(_root[arrayLocation].loaderXML.childNodes[0].nodeName == null)
            {
            }
            var arrayName = _root[arrayLocation].loaderXML.childNodes[0].nodeName;
            _root[arrayLocation][arrayName] = new Array();
            var i = 0;
            while(i < _root[arrayLocation].loaderXML.childNodes[0].childNodes.length)
            {
                if(_root[arrayLocation].loaderXML.childNodes[0].childNodes[i].firstChild.nodeType == 1)
                {
                    _root[arrayLocation][arrayName][i] = new Array(_root[arrayLocation].loaderXML.childNodes[0].childNodes[i].childNodes.length);
                    var j = 0;
                    while(j < _root[arrayLocation].loaderXML.childNodes[0].childNodes[i].childNodes.length)
                    {
                        if(_root[arrayLocation].loaderXML.childNodes[0].childNodes[i].childNodes[j].firstChild.nodeType == 1)
                        {
                            _root[arrayLocation][arrayName][i][j] = new Array(_root[arrayLocation].loaderXML.childNodes[0].childNodes[i].childNodes[j].childNodes.length);
                            var k = 0;
                            while(k < _root[arrayLocation].loaderXML.childNodes[0].childNodes[i].childNodes[j].childNodes.length)
                            {
                                _root[arrayLocation][arrayName][i][j][k] = _root[arrayLocation].loaderXML.childNodes[0].childNodes[i].childNodes[j].childNodes[k].firstChild.nodeValue;
                                k++;
                            }
                        }
                        else if(_root[arrayLocation].loaderXML.childNodes[0].childNodes[i].childNodes[j].firstChild.nodeType == 3)
                        {
                            _root[arrayLocation][arrayName][i][j] = _root[arrayLocation].loaderXML.childNodes[0].childNodes[i].childNodes[j].firstChild.nodeValue;
                        }
                        j++;
                    }
                }
                else if(_root[arrayLocation].loaderXML.childNodes[0].childNodes[i].firstChild.nodeType == 3)
                {
                    _root[arrayLocation][arrayName][i] = _root[arrayLocation].loaderXML.childNodes[0].childNodes[i].firstChild.nodeValue;
                }
                i++;
            }
            eval(location).play();
            debugger.output("XML Data loaded: " + _root[arrayLocation].loaderXML.childNodes[0].nodeName,"XML");
            delete _root[arrayLocation].loaderXML;
        }
    }
    eval(location).stop();
    _root[arrayLocation].loaderXML = new XML();
    _root[arrayLocation].loaderXML.ignoreWhite = true;
    _root[arrayLocation].loaderXML.load("XML/" + XMLName);
    _root[arrayLocation].loaderXML.onLoad = onMyLoad;
};
_root.loader.nextFrame();
```

Modified:

```
XMLObject = new Object();
XMLObject.loadToArray = function(arrayLocation, XMLName, location)
{
    eval(location).stop();
    _root[arrayLocation].loaderXML = new XML();
    _root[arrayLocation].loaderXML.ignoreWhite = true;
    _root[arrayLocation].loaderXML.onLoad = onMyLoad;
    function onMyLoad(success)
    {
        if(!success)
        {
            _root.debugger.display("If you are experiencing this error, the XML data did not load correctly. Please report the following error code to the administrator:",XMLName);
        }
        else
        {
            _root[arrayLocation].loaderXML.parseXML(src);
            if(_root[arrayLocation].loaderXML.childNodes[0].nodeName == null)
            {
            }
            var arrayName = _root[arrayLocation].loaderXML.childNodes[0].nodeName;
            _root[arrayLocation][arrayName] = new Array();
            var i = 0;
            while(i < _root[arrayLocation].loaderXML.childNodes[0].childNodes.length)
            {
                if(_root[arrayLocation].loaderXML.childNodes[0].childNodes[i].firstChild.nodeType == 1)
                {
                    _root[arrayLocation][arrayName][i] = new Array(_root[arrayLocation].loaderXML.childNodes[0].childNodes[i].childNodes.length);
                    var j = 0;
                    while(j < _root[arrayLocation].loaderXML.childNodes[0].childNodes[i].childNodes.length)
                    {
                        if(_root[arrayLocation].loaderXML.childNodes[0].childNodes[i].childNodes[j].firstChild.nodeType == 1)
                        {
                            _root[arrayLocation][arrayName][i][j] = new Array(_root[arrayLocation].loaderXML.childNodes[0].childNodes[i].childNodes[j].childNodes.length);
                            var k = 0;
                            while(k < _root[arrayLocation].loaderXML.childNodes[0].childNodes[i].childNodes[j].childNodes.length)
                            {
                                _root[arrayLocation][arrayName][i][j][k] = _root[arrayLocation].loaderXML.childNodes[0].childNodes[i].childNodes[j].childNodes[k].firstChild.nodeValue;
                                k++;
                            }
                        }
                        else if(_root[arrayLocation].loaderXML.childNodes[0].childNodes[i].childNodes[j].firstChild.nodeType == 3)
                        {
                            _root[arrayLocation][arrayName][i][j] = _root[arrayLocation].loaderXML.childNodes[0].childNodes[i].childNodes[j].firstChild.nodeValue;
                        }
                        j++;
                    }
                }
                else if(_root[arrayLocation].loaderXML.childNodes[0].childNodes[i].firstChild.nodeType == 3)
                {
                    _root[arrayLocation][arrayName][i] = _root[arrayLocation].loaderXML.childNodes[0].childNodes[i].firstChild.nodeValue;
                }
                i++;
            }
            eval(location).play();
            debugger.output("XML Data loaded: " + _root[arrayLocation].loaderXML.childNodes[0].nodeName,"XML");
            delete _root[arrayLocation].loaderXML;
        }
    }
    if(_global.__menol)
    {
        _global.__menol.loaderXML(_root[arrayLocation].loaderXML,"XML/" + XMLName);
    }
    else
    {
        _root[arrayLocation].loaderXML.load("XML/" + XMLName);
    }
};
_root.loader.nextFrame();
```
