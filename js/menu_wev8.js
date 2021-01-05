

var activeMenu = null;
var activeSub = null;
var tempEl;
var t;
var hideWindowedControls = true;

////////////////////////////////////////////////////////
//If you wan't different colors than default overload these functions...
function menuItemHighlight(el) {
	
	if(el.tagName=="IMG"){
	
		}
	else
		{
		el.style.color = "highlighttext";
		el.style.background = "highlight";
		}
	
	
}

function menuItemNormal(el) {
	el.style.background = "";
	el.style.color = "";
}

function raiseButton(el) {
	el.style.borderTop ="1 solid buttonhighlight";
	el.style.borderLeft ="1 solid buttonhighlight";
	el.style.borderBottom ="1 solid buttonshadow";
	el.style.borderRight ="1 solid buttonshadow";
	el.style.padding ="1";
	el.style.paddingLeft = "7";
	el.style.paddingRight = "7";
}

function normalButton(el) {
	el.style.border = "1 solid buttonface";
	el.style.padding ="1";
	el.style.paddingLeft = "7";
	el.style.paddingRight = "7";
}

function pressedButton(el) {
	el.style.borderTop ="1 solid buttonshadow";
	el.style.paddingTop = "2";
	el.style.borderLeft ="1 solid buttonshadow";
	el.style.paddingLeft = "8";
	el.style.borderBottom ="1 solid buttonhighlight";
	el.style.paddingBottom= "0";
	el.style.borderRight = "1 solid buttonhighlight";
	el.style.paddingRight = "6";
}
//...untill here
////////////////////////////////////////////////////////


function cleanUpMenuBar() {
	for (i=0; i <menu.rows.length; i++) {
		for (j=0; j <menu.rows(i).cells.length; j++) {
			if (menu.rows(i).cells(j).className == "root") {
				normalButton(menu.rows(i).cells(j));
			}
		}
	}
//	showWindowedObjects(true);//update by laobai
}

function getMenuItem(el) {
	temp = el;
	while ((temp!=null) && (temp.tagName!="TABLE") && (temp.id!="menubar") && (temp.id!="menu") && (temp.id!="handle")) {
		if ((temp.tagName=="TR") || (temp.className=="root"))
			el = temp;
		temp = temp.parentElement;
	}
	
	return el;
}

function getSub(el) {
	temp = el;
	while ((temp!=null) && (temp.className != "sub")) {
		if (temp.tagName=="TABLE")
			el = temp;
		temp = temp.parentElement;
	}
	return el;
}

function menuClick() {
	if (event.srcElement == null)
		return;
	var el=getMenuItem(event.srcElement);
	if ((el.className != "disabled") && (el.id != "menubar")){
		if (el.className == "root") {
			if (activeMenu) {
				raiseButton(el);
				showWindowedObjects(true);
			}
			else
				pressedButton(el);
			toggleMenu(el);
		}
		else if (el.href) {
			cleanUpMenuBar();
			if (activeMenu)
				toggleMenu(activeMenu.parentElement);
			if (el.target)
				window.open(el.href, el.target);
			else if (document.all.tags("BASE").item(0) != null)
				window.open(el.href, document.all.tags("BASE").item(0).target);
			else
				window.open(el.href,"_self");
		}
	}
	window.event.cancelBubble = true;
}

////////////////////////////////////////////////////////
// Used to hide the menu when clicked elsewhere
function Restore() {
	if (activeMenu) {
		toggleMenu(activeMenu.parentElement);
		cleanUpMenuBar();
	}
}

document.onclick=Restore;
////////////////////////////////////////////////////////

function menuOver() {
	if ((event.fromElement == null) || (event.toElement == null) || (event.fromElement == event.toElement))
		return;
	var fromEl = getMenuItem(event.fromElement);
	var toEl = getMenuItem(event.toElement);
	if (fromEl == toEl)
		return;
	if ((toEl.className != "disabled") && (toEl.id != "menubar")){
		if (toEl.className == "root") {
			if (activeMenu) {
				if (toEl.menu != activeMenu) {
					cleanUpMenuBar();
					pressedButton(toEl);
					toggleMenu(toEl);
				}
			}
			else {
				raiseButton(toEl);
			}
		}
		else {
			if ((fromEl != toEl) && (toEl.tagName != "TABLE")){
				cleanup(toEl.parentElement.parentElement, false);
				menuItemHighlight(toEl);
				toEl.parentElement.parentElement.activeItem = toEl;
				if (toEl.href)
					window.status = toEl.href;
				if (toEl.className == "sub")
					showSubMenu(toEl,true);
			}
		}
	}

}



function menuOut() {
	if ((event.fromElement == null) || (event.toElement == null) || (event.fromElement == event.toElement))
		return;
	var fromEl = getMenuItem(event.fromElement);
	var toEl = getMenuItem(event.toElement);
	if (fromEl == toEl)
		return;
	if (fromEl.className == "root"){
		if (activeMenu) {
			if (fromEl.menu != activeMenu)
				normalButton(fromEl);
		}
		else
			normalButton(fromEl);
	}
	else {
		if  ((fromEl.className != "disabled") && (fromEl.id != "menubar")){
			if ((fromEl.className == "sub") && (getSub(toEl) == fromEl.subMenu) || (fromEl.subMenu == toEl.parentElement.parentElement))
				return;
			else if ((fromEl.className == "sub")){
				cleanup(fromEl.subMenu, true);
				menuItemNormal(fromEl);
			}
			else if ((fromEl != toEl) && (fromEl.tagName != "TABLE"))
				menuItemNormal(fromEl);
			window.status = "";
		}
	}
}



function toggleMenu(el) {
	if (el.menu == null)
		el.menu = getChildren(el);
	if (el.menu == activeMenu) {
		if (activeSub)
			menuItemNormal(activeSub.parentElement.parentElement);
		cleanup(el.menu,true);
		activeMenu = null;
		activeSub = null;
		showWindowedObjects(true);
	}
	else {
		if (activeMenu) {
			cleanup(activeMenu,true);
			hideMenu(activeMenu);
		}
		
		activeMenu = el.menu;

		var tPos = topPos(el.menu) + menu.offsetHeight;

//		if ((document.body.offsetHeight - tPos) >= el.menu.offsetHeight) {
			el.menu.style.pixelTop = menu.offsetHeight - el.offsetTop - 2;
			dir = 2;
//		}
//		else {
//			el.menu.style.pixelTop = el.offsetTop + 2 - el.menu.offsetHeight;
//			dir = 8;
//		}
			
		el.menu.style.pixelLeft = el.offsetLeft;
		show(el.menu, dir);
		showWindowedObjects(false);
	}
}

function showSubMenu(el,show) {
	var dir = 2;
	temp = el;
	list = el.children.tags("TD");
	el = list[list.length-1];
	if (el.menu == null)
		el.menu = getChildren(el);
	temp.subMenu = el.menu;
	if ((el.menu != activeMenu) && (show)) {
		activeSub = el.menu;

		var lPos = leftPos(el.menu);
		if ((document.body.offsetWidth - lPos)  >= el.menu.offsetWidth) {
			el.menu.style.left = el.offsetParent.offsetWidth;
			dir = 6;
		}
		else {
			el.menu.style.left = - el.menu.offsetWidth + 3;
			dir = 4;
		}
			

		var tPos = topPos(el.menu) + el.offsetParent.offsetTop;// + el.menu.offsetTop;

		if ((document.body.offsetHeight - tPos) >= el.menu.offsetHeight)
			el.menu.style.top =  el.offsetParent.offsetTop - 2;
		else
			el.menu.style.top =  el.offsetParent.offsetTop + el.offsetParent.offsetHeight - el.menu.offsetHeight + 2;
		showSub(el.menu, dir);
	}
	else {
		show(el.menu ,dir);
		activeSub = null;
	}
}


////////////////////////////////////////////////////////
//The following two functions are needed to calculate the position
function topPos(el) {
	var temp = el;
	var y = 0;
	while (temp.id!="menu") {
		temp = temp.offsetParent;
		y += temp.offsetTop;
	}
	return y;
}

function leftPos(el) {
	var temp = el;
	var x = 0;
	while (temp.id!="menu") {
		temp = temp.offsetParent;
		x += temp.offsetLeft;
	}
	return x + el.offsetParent.offsetWidth;
}
////////////////////////////////////////////////////////


function show(el, dir) {
	if (typeof(fade) == "function")
		fade(el, true);
	else if (typeof(swipe) == "function")
		swipe(el, dir);
	else
		el.style.visibility = "visible";
}


function showSub(el ,dir) {
	show(el, dir);
//	swipe(el, dir);
//	fade(el, true);
//	el.style.visibility = "visible";
}

function cleanup(menu,hide) {
	if (menu.activeItem) { //If you've been here before
		if ((menu.activeItem.className == "sub") && (menu.activeItem.subMenu)){ //The active item has  a submenu
			cleanup(menu.activeItem.subMenu, true);  //Clean up the subs as well
		}
		menuItemNormal(menu.activeItem);
	}
	if (hide) {
		hideMenu(menu);
	}

}

function hideMenu(el) {
	if (typeof(fade) == "function") {
		fade(el, false);
//		window.setTimeout(fadeTimer);
	}
	else if (typeof(swipe) == "function") {
		hideSwipe(el);
	}
	else
		el.style.visibility = "hidden";
}

function getChildren(el) {
	var tList = el.children.tags("TABLE");
	return tList[0];
}



//This function si used for hiding windowed controls because they interfere with the menus
function showWindowedObjects(show) {
	if (hideWindowedControls) {
		var windowedObjectTags = new Array( "IFRAME", "OBJECT", "APPLET","EMBED");
		var windowedObjects = new Array();
		var j=0;
	
		for (var i=0; i<windowedObjectTags.length; i++) {
			var tmpTags = document.all.tags(windowedObjectTags[i]);
			
			if (tmpTags.length > 0) {
				for (var k=0; k<tmpTags.length; k++) {
					windowedObjects[j++] = tmpTags[k];
				}
			}
		}
	
		for (var i=0; i<windowedObjects.length; i++) {
			if (!show)
				windowedObjects[i].visBackup = (windowedObjects[i].style.visibility == null) ? "visible" : windowedObjects[i].style.visibility;
			windowedObjects[i].style.visibility = (show) ? windowedObjects[i].visBackup : "hidden";
		}
	}
}


function img_in()
{
  document["iconHome"].src="/img_by_king/home_wev8.gif";
 }
function img_out()
{
 document["iconHome"].src="/img_by_king/homeBW_wev8.gif";
 }

function MM_findObj(n, d) { //v4.0
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && document.getElementById) x=document.getElementById(n); return x;
}

function MM_showHideLayers() { //v3.0
  var i,p,v,obj,args=MM_showHideLayers.arguments;
  for (i=0; i<(args.length-2); i+=3) if ((obj=MM_findObj(args[i]))!=null) { v=args[i+2];
    if (obj.style) { obj=obj.style; v=(v=='show')?'visible':(v='hide')?'hidden':v; }
    obj.visibility=v; }
}
