# Removed Built-In Login System

## `frames` -> `frame 1`

Removed:

-   `Password:` label.
-   Password input.
-   `Confirm:` label.
-   Confirm input.
-   `Email:` label.
-   Email input.
-   Password asterisk.
-   Confirm asterisk.
-   B-Day month input.
-   `B-Day:` label.
-   B-Day day input.

## `texts` -> `DefineText (201)`

Original:

```
* Indicates required field. Email will only be used for password recovery
```

Modified:

```
* Indicates required field.
```

## `scripts` -> `frame 3`

Original:

```
if(username.text == "")
{
    errorVar = "Please enter a username";
    this.gotoAndStop(1);
}
else if(passwordBox.text == "" || confirm.text == "")
{
    errorVar = "Please enter a password and confirm";
    this.gotoAndStop(1);
}
else if(passwordBox.text != confirm.text)
{
    errorVar = "Passwords do not match. Please retype.";
    this.gotoAndStop(1);
}
else if(_root.player.checkStatus[0] == "true")
{
    errorVar = "That username is already taken. Please choose another.";
    this.gotoAndStop(1);
}
_root.debugger.output(_root.player.checkStatus);
delete _root.player.checkStatus;
```

Modified:

```
if(username.text == "")
{
    errorVar = "Please enter a username";
    this.gotoAndStop(1);
}
else if(_root.player.checkStatus[0] == "true")
{
    errorVar = "Error starting new game.";
    this.gotoAndStop(1);
}
_root.debugger.output(_root.player.checkStatus);
delete _root.player.checkStatus;
```

## `scripts` -> `frame 4`

Original:

```
if(metru == "ta")
{
    firstDisk = "11";
}
else if(metru == "ga")
{
    firstDisk = "21";
}
else if(metru == "po")
{
    firstDisk = "31";
}
else if(metru == "ko")
{
    firstDisk = "41";
}
else if(metru == "le")
{
    firstDisk = "51";
}
else if(metru == "onu")
{
    firstDisk = "61";
}
_root.XMLObject.loadToArray("player","insertUser.php?username=" + username.text + "&password=" + passwordBox.text + "&colors=" + bodyColor + "," + footColor + "," + maskVar + "," + maskColor + "," + metru + ",black," + sackColor + "&firstDisk=" + firstDisk + "&email=" + email.text + "&bday=" + birthday,"_root.creatorBox");
```

Modified:

```
if(metru == "ta")
{
    firstDisk = "11";
}
else if(metru == "ga")
{
    firstDisk = "21";
}
else if(metru == "po")
{
    firstDisk = "31";
}
else if(metru == "ko")
{
    firstDisk = "41";
}
else if(metru == "le")
{
    firstDisk = "51";
}
else if(metru == "onu")
{
    firstDisk = "61";
}
_root.XMLObject.loadToArray("player","insertUser.php?username=" + username.text + "&password=" + "" + "&colors=" + bodyColor + "," + footColor + "," + maskVar + "," + maskColor + "," + metru + ",black," + sackColor + "&firstDisk=" + firstDisk + "&email=" + "" + "&bday=" + "","_root.creatorBox");
```

## `scripts` -> `frame 5`

Original:

```
_root.XMLObject.loadToArray("player","getStatus.php?username=" + username.text + "&password=" + passwordBox.text,"_root.creatorBox");
```

Modified:

```
_root.XMLObject.loadToArray("player","getStatus.php?username=" + username.text + "&password=" + "","_root.creatorBox");
```


# Alternative saving

TODO
