/*----------------------------------------------------------------------------\
|                       Cross Browser Tree Widget 1.17                        |
|-----------------------------------------------------------------------------|
|                          Created by Emil A Eklund                           |
|                  (http://webfx.eae.net/contact.html#emil)                   |
|                      For WebFX (http://webfx.eae.net/)                      |
|-----------------------------------------------------------------------------|
| An object based tree widget,  emulating the one found in microsoft windows, |
| with persistence using cookies. Works in IE 5+, Mozilla and konqueror 3.    |
|-----------------------------------------------------------------------------|
|                   Copyright (c) 1999 - 2002 Emil A Eklund                   |
|-----------------------------------------------------------------------------|
| This software is provided "as is", without warranty of any kind, express or |
| implied, including  but not limited  to the warranties of  merchantability, |
| fitness for a particular purpose and noninfringement. In no event shall the |
| authors or  copyright  holders be  liable for any claim,  damages or  other |
| liability, whether  in an  action of  contract, tort  or otherwise, arising |
| from,  out of  or in  connection with  the software or  the  use  or  other |
| dealings in the software.                                                   |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| This  software is  available under the  three different licenses  mentioned |
| below.  To use this software you must chose, and qualify, for one of those. |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| The WebFX Non-Commercial License          http://webfx.eae.net/license.html |
| Permits  anyone the right to use the  software in a  non-commercial context |
| free of charge.                                                             |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| The WebFX Commercial license           http://webfx.eae.net/commercial.html |
| Permits the  license holder the right to use  the software in a  commercial |
| context. Such license must be specifically obtained, however it's valid for |
| any number of  implementations of the licensed software.                    |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| GPL - The GNU General Public License    http://www.gnu.org/licenses/gpl.txt |
| Permits anyone the right to use and modify the software without limitations |
| as long as proper  credits are given  and the original  and modified source |
| code are included. Requires  that the final product, software derivate from |
| the original  source or any  software  utilizing a GPL  component, such  as |
| this, is also licensed under the GPL license.                               |
|-----------------------------------------------------------------------------|
| Dependencies: xtree_wev8.css (To set up the CSS of the tree classes)             |
|-----------------------------------------------------------------------------|
| 2001-01-10 | Original Version Posted.                                       |
| 2001-03-18 | Added getSelected and get/setBehavior  that can make it behave |
|            | more like windows explorer, check usage for more information.  |
| 2001-09-23 | Version 1.1 - New features included  keyboard  navigation (ie) |
|            | and the ability  to add and  remove nodes dynamically and some |
|            | other small tweaks and fixes.                                  |
| 2002-01-27 | Version 1.11 - Bug fixes and improved mozilla support.         |
| 2002-06-11 | Version 1.12 - Fixed a bug that prevented the indentation line |
|            | from  updating correctly  under some  circumstances.  This bug |
|            | happened when removing the last item in a subtree and items in |
|            | siblings to the remove subtree where not correctly updated.    |
| 2002-06-13 | Fixed a few minor bugs cased by the 1.12 bug-fix.              |
| 2002-08-20 | Added usePersistence flag to allow disable of cookies.         |
| 2002-10-23 | (1.14) Fixed a plus icon issue                                 |
| 2002-10-29 | (1.15) Last changes broke more than they fixed. This version   |
|            | is based on 1.13 and fixes the bugs 1.14 fixed withou breaking |
|            | lots of other things.                                          |
| 2003-02-15 | The  selected node can now be made visible even when  the tree |
|            | control  loses focus.  It uses a new class  declaration in the |
|            | css file '.webfx-tree-item a.selected-inactive', by default it |
|            | puts a light-gray rectangle around the selected node.          |
| 2003-03-16 | Adding target support after lots of lobbying...                |
|-----------------------------------------------------------------------------|
| Created 2000-12-11 | All changes are in the log above. | Updated 2003-03-16 |
\----------------------------------------------------------------------------*/

var webFXTreeConfig = {
	rootIcon        : 'images/foldericon_wev8.png',
	openRootIcon    : 'images/openfoldericon_wev8.png',
	folderIcon      : 'images/foldericon_wev8.png',
	openFolderIcon  : 'images/openfoldericon_wev8.png',
	fileIcon        : 'images/file_wev8.png',
	iIcon           : 'images/I_wev8.png',
	lIcon           : 'images/L_wev8.png',
	lMinusIcon      : 'images/Lminus_wev8.png',
	lPlusIcon       : 'images/Lplus_wev8.png',
	tIcon           : 'images/T_wev8.png',
	tMinusIcon      : 'images/Tminus_wev8.png',
	tPlusIcon       : 'images/Tplus_wev8.png',
	blankIcon       : 'images/blank_wev8.png',
	defaultText     : 'Tree Item',
	defaultAction   : 'javascript:void(0);',
	defaultBehavior : 'classic',
	usePersistence	: true,
    wfintervenor    : false
};
var flags=true;
var viewflags=true;
var intervenorflags=true;
var delflags=true;
var fbflags=true;
var foflags=true;
var soflags=true;
var webFXTreeHandler = {
	idCounter : 0,
	idPrefix  : "webfx-tree-object-",
	all       : {},
	behavior  : null,
	selected  : null,
	onSelect  : null, /* should be part of tree, not handler */
	getId     : function() { return this.idPrefix + this.idCounter++; },
	toggle    : function (oItem) { this.all[oItem.id.replace('-plus','')].toggle(); },
	toggles    : function (oItem) { this.all[oItem.id.replace('-plus','')].toggles(); },
    viewtoggles    : function (oItem) { this.all[oItem.id.replace('-plus','')].viewtoggles(); },
    select    : function (oItem) { this.all[oItem.id.replace('-icon','')].select(); },
	focus     : function (oItem) { this.all[oItem.id.replace('-anchor','')].focus(); },
	blur      : function (oItem) { this.all[oItem.id.replace('-anchor','')].blur(); },
	keydown   : function (oItem, e) { return this.all[oItem.id].keydown(e.keyCode); },
	cookies   : new WebFXCookie(),
	insertHTMLBeforeEnd	:	function (oElement, sHTML) {
		if (oElement.insertAdjacentHTML != null) {
			oElement.insertAdjacentHTML("BeforeEnd", sHTML)
			return;
		}
		var df;	// DocumentFragment
		var r = oElement.ownerDocument.createRange();
		r.selectNodeContents(oElement);
		r.collapse(false);
		df = r.createContextualFragment(sHTML);
		oElement.appendChild(df);
	}
};

/*
 * WebFXCookie class
 */

function WebFXCookie() {
	if (document.cookie.length) { this.cookies = ' ' + document.cookie; }
}

WebFXCookie.prototype.setCookie = function (key, value) {
	document.cookie = key + "=" + escape(value);
}

WebFXCookie.prototype.getCookie = function (key) {
	if (this.cookies) {
		var start = this.cookies.indexOf(' ' + key + '=');
		if (start == -1) { return null; }
		var end = this.cookies.indexOf(";", start);
		if (end == -1) { end = this.cookies.length; }
		end -= start;
		var cookie = this.cookies.substr(start,end);
		return unescape(cookie.substr(cookie.indexOf('=') + 1, cookie.length - cookie.indexOf('=') + 1));
	}
	else { return null; }
}

/*
 * WebFXTreeAbstractNode class
 */

function WebFXTreeAbstractNode(sText, sAction) {
	this.childNodes  = [];
	this.id     = webFXTreeHandler.getId();
	this.text   = sText || webFXTreeConfig.defaultText;
	this.action = sAction || webFXTreeConfig.defaultAction;
	this._last  = false;
	webFXTreeHandler.all[this.id] = this;
}

/*
 * To speed thing up if you're adding multiple nodes at once (after load)
 * use the bNoIdent parameter to prevent automatic re-indentation and call
 * the obj.ident() method manually once all nodes has been added.
 */

WebFXTreeAbstractNode.prototype.add = function (node, bNoIdent) {
	node.parentNode = this;
	this.childNodes[this.childNodes.length] = node;
	var root = this;
	if (this.childNodes.length >= 2) {
		this.childNodes[this.childNodes.length - 2]._last = false;
	}
	while (root.parentNode) { root = root.parentNode; }
	if (root.rendered) {
		if (this.childNodes.length >= 2) {
			document.getElementById(this.childNodes[this.childNodes.length - 2].id + '-plus').src = ((this.childNodes[this.childNodes.length -2].folder)?((this.childNodes[this.childNodes.length -2].open)?webFXTreeConfig.tMinusIcon:webFXTreeConfig.tPlusIcon):webFXTreeConfig.tIcon);
			this.childNodes[this.childNodes.length - 2].plusIcon = webFXTreeConfig.tPlusIcon;
			this.childNodes[this.childNodes.length - 2].minusIcon = webFXTreeConfig.tMinusIcon;
			this.childNodes[this.childNodes.length - 2]._last = false;
		}
		this._last = true;
		var foo = this;
		while (foo.parentNode) {
			for (var i = 0; i < foo.parentNode.childNodes.length; i++) {
				if (foo.id == foo.parentNode.childNodes[i].id) { break; }
			}
			if (i == foo.parentNode.childNodes.length - 1) { foo.parentNode._last = true; }
			else { foo.parentNode._last = false; }
			foo = foo.parentNode;
		}
		webFXTreeHandler.insertHTMLBeforeEnd(document.getElementById(this.id + '-cont'), node.toString());
		if ((!this.folder) && (!this.openIcon)) {
			this.icon = webFXTreeConfig.folderIcon;
			this.openIcon = webFXTreeConfig.openFolderIcon;
		}
		if (!this.folder) { this.folder = true; this.collapse(true); }
		if (!bNoIdent) { this.indent(); }
	}
	return node;
}

WebFXTreeAbstractNode.prototype.toggle = function() {

	if (this.folder) {
		if (this.open) { this.collapse(); }
		else {
			flags=true  ;
            viewflags=true  ;
            intervenorflags=true;
            delflags=true;
            fbflags=true;
            foflags=true;
            soflags = true;
            this.expand();

		//this.expand();
		}
}



}


WebFXTreeAbstractNode.prototype.toggles = function() {

	if (this.folder) {
		if (this.open) { return; }
		else {
	        flags=false;
			viewflags=false  ;
            intervenorflags=false;
            delflags=false  ;
            fbflags=false  ;
            foflags=false  ;
            soflags = false;
    this.expand(); }

}	}

WebFXTreeAbstractNode.prototype.viewtoggles = function() {

	if (this.folder) {
		if (this.open) { return; }
		else {
	        viewflags=false;
            intervenorflags=false;
            delflags=false  ;
            fbflags=false  ;
            foflags=false  ;
            soflags = false;
            flags=false;
    this.expand(); }

}	}


WebFXTreeAbstractNode.prototype.select = function() {
	document.getElementById(this.id + '-anchor').focus();
}

WebFXTreeAbstractNode.prototype.deSelect = function() {
	document.getElementById(this.id + '-anchor').className = '';
	webFXTreeHandler.selected = null;
}

WebFXTreeAbstractNode.prototype.focus = function() {
	if ((webFXTreeHandler.selected) && (webFXTreeHandler.selected != this)) { webFXTreeHandler.selected.deSelect(); }
	webFXTreeHandler.selected = this;
	if ((this.openIcon) && (webFXTreeHandler.behavior != 'classic')) { document.getElementById(this.id + '-icon').src = this.icon; }
	document.getElementById(this.id + '-anchor').className = 'selected';
	document.getElementById(this.id + '-anchor').focus();
	if (webFXTreeHandler.onSelect) { webFXTreeHandler.onSelect(this); }
}

WebFXTreeAbstractNode.prototype.blur = function() {
	if ((this.openIcon) && (webFXTreeHandler.behavior != 'classic')) { document.getElementById(this.id + '-icon').src = this.icon; }
	document.getElementById(this.id + '-anchor').className = 'selected-inactive';
}

WebFXTreeAbstractNode.prototype.doExpand = function() {


	if (webFXTreeHandler.behavior == 'classic') { document.getElementById(this.id + '-icon').src = this.icon; }
	if (this.childNodes.length) {  document.getElementById(this.id + '-cont').style.display = 'block'; }
	this.open = true;
	if (webFXTreeConfig.usePersistence) {
		webFXTreeHandler.cookies.setCookie(this.id.substr(18,this.id.length - 18), '1');
}

	//var wfid=this.id.substring(this.id.indexOf("object-")+7,this.id.length);

}

WebFXTreeAbstractNode.prototype.doCollapse = function() {
	if (webFXTreeHandler.behavior == 'classic') { document.getElementById(this.id + '-icon').src = this.icon; }
	if (this.childNodes.length) { document.getElementById(this.id + '-cont').style.display = 'none'; }
	this.open = false;
	if (webFXTreeConfig.usePersistence) {
		webFXTreeHandler.cookies.setCookie(this.id.substr(18,this.id.length - 18), '0');
}	}

WebFXTreeAbstractNode.prototype.expandAll = function() {
	this.expandChildren();
	if ((this.folder) && (!this.open)) { this.expand(); }
}

WebFXTreeAbstractNode.prototype.expandChildren = function() {
	for (var i = 0; i < this.childNodes.length; i++) {
		this.childNodes[i].expandAll();
} }

WebFXTreeAbstractNode.prototype.collapseAll = function() {
	this.collapseChildren();
	if ((this.folder) && (this.open)) { this.collapse(true); }
}

WebFXTreeAbstractNode.prototype.collapseChildren = function() {
	for (var i = 0; i < this.childNodes.length; i++) {
		this.childNodes[i].collapseAll();
} }

WebFXTreeAbstractNode.prototype.indent = function(lvl, del, last, level, nodesLeft) {
	/*
	 * Since we only want to modify items one level below ourself,
	 * and since the rightmost indentation position is occupied by
	 * the plus icon we set this to -2
	 */
	if (lvl == null) { lvl = -2; }
	var state = 0;
	for (var i = this.childNodes.length - 1; i >= 0 ; i--) {
		state = this.childNodes[i].indent(lvl + 1, del, last, level);
		if (state) { return; }
	}
	if (del) {
		if ((level >= this._level) && (document.getElementById(this.id + '-plus'))) {
			if (this.folder) {
				document.getElementById(this.id + '-plus').src = (this.open)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.lPlusIcon;
				this.plusIcon = webFXTreeConfig.lPlusIcon;
				this.minusIcon = webFXTreeConfig.lMinusIcon;
			}
			else if (nodesLeft) { document.getElementById(this.id + '-plus').src = webFXTreeConfig.lIcon; }
			return 1;
	}	}
	var foo = document.getElementById(this.id + '-indent-' + lvl);
	if (foo) {
		if ((foo._last) || ((del) && (last))) { foo.src =  webFXTreeConfig.blankIcon; }
		else { foo.src =  webFXTreeConfig.iIcon; }
	}
	return 0;
}

/*
 * WebFXTree class
 */

function WebFXTree(sText, sAction, sBehavior, sIcon, sOpenIcon) {
	this.base = WebFXTreeAbstractNode;
	this.base(sText, sAction);
	this.icon      = sIcon || webFXTreeConfig.rootIcon;
	this.openIcon  = sOpenIcon || webFXTreeConfig.openRootIcon;
	/* Defaults to open */
	if (webFXTreeConfig.usePersistence) {
		this.open  = (webFXTreeHandler.cookies.getCookie(this.id.substr(18,this.id.length - 18)) == '0')?false:true;
	} else { this.open  = true; }
	this.folder    = false;
	this.rendered  = false;
	this.onSelect  = null;
	if (!webFXTreeHandler.behavior) {  webFXTreeHandler.behavior = sBehavior || webFXTreeConfig.defaultBehavior; }
}

WebFXTree.prototype = new WebFXTreeAbstractNode;

WebFXTree.prototype.setBehavior = function (sBehavior) {
	webFXTreeHandler.behavior =  sBehavior;
};

WebFXTree.prototype.getBehavior = function (sBehavior) {
	return webFXTreeHandler.behavior;
};

WebFXTree.prototype.getSelected = function() {
	if (webFXTreeHandler.selected) { return webFXTreeHandler.selected; }
	else { return null; }
}

WebFXTree.prototype.remove = function() { }

WebFXTree.prototype.expand = function() {
	this.doExpand();

}

WebFXTree.prototype.collapse = function(b) {
	if (!b) { this.focus(); }
	this.doCollapse();
}

WebFXTree.prototype.getFirst = function() {
	return null;
}

WebFXTree.prototype.getLast = function() {
	return null;
}

WebFXTree.prototype.getNextSibling = function() {
	return null;
}

WebFXTree.prototype.getPreviousSibling = function() {
	return null;
}

WebFXTree.prototype.keydown = function(key) {
	if (key == 39) {
		if (!this.open) { this.expand(); }
		else if (this.childNodes.length) { this.childNodes[0].select(); }
		return false;
	}
	if (key == 37) { this.collapse(); return false; }
	if ((key == 40) && (this.open) && (this.childNodes.length)) { this.childNodes[0].select(); return false; }
	return true;
}

WebFXTree.prototype.toString = function() {

	var str = "<table onmouseover=\"document.getElementById('"+this.id+"-anchor').style.backgroundColor='#FFFFFF';document.getElementById('"+this.id+"-anchor').style.border='1px solid #0099CC';\" onmouseout=\"document.getElementById('"+this.id+"-anchor').style.backgroundColor='';document.getElementById('"+this.id+"-anchor').style.border='1px solid #FFFFFF';\" id=\"" + this.id + "\" ondblclick=\"webFXTreeHandler.toggle(this);\" class=\"webfx-tree-item\" onkeydown=\"return webFXTreeHandler.keydown(this, event)\" style=\"width:100%\" cellpadding=\"0\" cellspacing=\"0\"><tr><td width=\"50%\" style=\"background:#FFFFFF!important;\">" +
		"<img id=\"" + this.id + "-icon\" class=\"webfx-tree-icon\" src=\"" + ((webFXTreeHandler.behavior == 'classic' && this.open)?this.openIcon:this.icon) + "\" onclick=\"webFXTreeHandler.select(this);\">" +
		"<span style=\"cursor:hand;border:1px solid #FFFFFF;padding:0 4px 0 4px\" id=\"" + this.id + "-anchor\" onfocus=\"webFXTreeHandler.focus(this);\" onblur=\"webFXTreeHandler.blur(this);\"" +
		(this.target ? " target=\"" + this.target + "\"" : "") +
		">" + this.text + "</span></td><td width=\"25%\" style=\"background:#FFFFFF!important;\"></td></tr></table>" +
		"<div id=\"" + this.id + "-cont\" class=\"webfx-tree-container\" style=\"display: " + ((this.open)?'block':'none') + ";\">";
	var sb = [];
	for (var i = 0; i < this.childNodes.length; i++) {
		sb[i] = this.childNodes[i].toString(i, this.childNodes.length);
	}
	this.rendered = true;
	return str + sb.join("") + "</div>";
};

/*
 * WebFXTreeItem class
 */

function WebFXTreeItem(sText, sAction, eParent, sIcon, sOpenIcon) {
	this.base = WebFXTreeAbstractNode;
	this.base(sText, sAction);
	/* Defaults to close */
	if (webFXTreeConfig.usePersistence) {
		this.open = (webFXTreeHandler.cookies.getCookie(this.id.substr(18,this.id.length - 18)) == '1')?true:false;
	} else { this.open = false; }
	if (sIcon) { this.icon = sIcon; }
	if (sOpenIcon) { this.openIcon = sOpenIcon; }
	if (eParent) { eParent.add(this); }
}

WebFXTreeItem.prototype = new WebFXTreeAbstractNode;

WebFXTreeItem.prototype.remove = function() {
	var iconSrc = document.getElementById(this.id + '-plus').src;
	var parentNode = this.parentNode;
	var prevSibling = this.getPreviousSibling(true);
	var nextSibling = this.getNextSibling(true);
	var folder = this.parentNode.folder;
	var last = ((nextSibling) && (nextSibling.parentNode) && (nextSibling.parentNode.id == parentNode.id))?false:true;
	this.getPreviousSibling().focus();
	this._remove();
	if (parentNode.childNodes.length == 0) {
		document.getElementById(parentNode.id + '-cont').style.display = 'none';
		parentNode.doCollapse();
		parentNode.folder = false;
		parentNode.open = false;
	}
	if (!nextSibling || last) { parentNode.indent(null, true, last, this._level, parentNode.childNodes.length); }
	if ((prevSibling == parentNode) && !(parentNode.childNodes.length)) {
		prevSibling.folder = false;
		prevSibling.open = false;
		iconSrc = document.getElementById(prevSibling.id + '-plus').src;
		iconSrc = iconSrc.replace('minus', '').replace('plus', '');
		document.getElementById(prevSibling.id + '-plus').src = iconSrc;
		//document.getElementById(prevSibling.id + '-icon').src = webFXTreeConfig.fileIcon;
	}
	if (document.getElementById(prevSibling.id + '-plus')) {
		if (parentNode == prevSibling.parentNode) {
			iconSrc = iconSrc.replace('minus', '').replace('plus', '');
			document.getElementById(prevSibling.id + '-plus').src = iconSrc;
}	}	}

WebFXTreeItem.prototype._remove = function() {
	for (var i = this.childNodes.length - 1; i >= 0; i--) {
		this.childNodes[i]._remove();
 	}
	for (var i = 0; i < this.parentNode.childNodes.length; i++) {
		if (this == this.parentNode.childNodes[i]) {
			for (var j = i; j < this.parentNode.childNodes.length; j++) {
				this.parentNode.childNodes[j] = this.parentNode.childNodes[j+1];
			}
			this.parentNode.childNodes.length -= 1;
			if (i + 1 == this.parentNode.childNodes.length) { this.parentNode._last = true; }
			break;
	}	}
	webFXTreeHandler.all[this.id] = null;
	var tmp = document.getElementById(this.id);
	if (tmp) { tmp.parentNode.removeChild(tmp); }
	tmp = document.getElementById(this.id + '-cont');
	if (tmp) { tmp.parentNode.removeChild(tmp); }
}

WebFXTreeItem.prototype.expand = function() {
	this.doExpand();
	document.getElementById(this.id + '-plus').src = this.minusIcon;


}

WebFXTreeItem.prototype.collapse = function(b) {
	if (!b) { this.focus(); }
	this.doCollapse();
	document.getElementById(this.id + '-plus').src = this.plusIcon;
}

WebFXTreeItem.prototype.getFirst = function() {
	return this.childNodes[0];
}

WebFXTreeItem.prototype.getLast = function() {
	if (this.childNodes[this.childNodes.length - 1].open) { return this.childNodes[this.childNodes.length - 1].getLast(); }
	else { return this.childNodes[this.childNodes.length - 1]; }
}

WebFXTreeItem.prototype.getNextSibling = function() {
	for (var i = 0; i < this.parentNode.childNodes.length; i++) {
		if (this == this.parentNode.childNodes[i]) { break; }
	}
	if (++i == this.parentNode.childNodes.length) { return this.parentNode.getNextSibling(); }
	else { return this.parentNode.childNodes[i]; }
}

WebFXTreeItem.prototype.getPreviousSibling = function(b) {
	for (var i = 0; i < this.parentNode.childNodes.length; i++) {
		if (this == this.parentNode.childNodes[i]) { break; }
	}
	if (i == 0) { return this.parentNode; }
	else {
		if ((this.parentNode.childNodes[--i].open) || (b && this.parentNode.childNodes[i].folder)) { return this.parentNode.childNodes[i].getLast(); }
		else { return this.parentNode.childNodes[i]; }
} }

WebFXTreeItem.prototype.keydown = function(key) {
	if ((key == 39) && (this.folder)) {
		if (!this.open) { this.expand(); }
		else { this.getFirst().select(); }
		return false;
	}
	else if (key == 37) {
		if (this.open) { this.collapse(); }
		else { this.parentNode.select(); }
		return false;
	}
	else if (key == 40) {
		if (this.open) { this.getFirst().select(); }
		else {
			var sib = this.getNextSibling();
			if (sib) { sib.select(); }
		}
		return false;
	}
	else if (key == 38) { this.getPreviousSibling().select(); return false; }
	return true;
}

WebFXTreeItem.prototype.toString = function (nItem, nItemCount) {
	var foo = this.parentNode;
	var indent = '';
	if (nItem + 1 == nItemCount) { this.parentNode._last = true; }
	var i = 0;
	while (foo.parentNode) {
		foo = foo.parentNode;
		indent = "<img id=\"" + this.id + "-indent-" + i + "\" src=\"" + ((foo._last)?webFXTreeConfig.blankIcon:webFXTreeConfig.iIcon) + "\">" + indent;
		i++;
	}
	this._level = i;
	if (this.childNodes.length) { this.folder = 1; }
	else { this.open = false; }
	if ((this.folder) || (webFXTreeHandler.behavior != 'classic')) {
		if (!this.icon) { this.icon = webFXTreeConfig.folderIcon; }
		if (!this.openIcon) { this.openIcon = webFXTreeConfig.openFolderIcon; }
	}
	//else if (!this.icon) { this.icon = webFXTreeConfig.fileIcon; }
	var label = this.text.replace(/</g, '&lt;').replace(/>/g, '&gt;');
	var tmpArray = this.action.split("|");

	var tmpArray0 = tmpArray[0]==null ? "" : tmpArray[0];
	var tmpArray1 = tmpArray[1]==null ? "" : tmpArray[1];
	var tmpArray2 = tmpArray[2]==null ? "" : tmpArray[2];
	var tmpArray3 = tmpArray[3]==null ? "" : tmpArray[3];
    var tmpArray4 = tmpArray[4]==null ? "" : tmpArray[4];
    var tmpArray5 = tmpArray[5]==null ? "" : tmpArray[5];
    var tmpArray6 = tmpArray[6]==null ? "" : tmpArray[6];
    var tmpArray7 = tmpArray[7]==null ? "" : tmpArray[7];
    var tmpArray8 = tmpArray[8]==null ? "" : tmpArray[8];
    var tmpArray9 = tmpArray[9]==null ? "" : tmpArray[9];
    var checkAllStr = "";
    var viewcheckAllStr = "";
    var intervenorcheckAllStr = "";
    var delcheckAllStr = "";
    var fbcheckAllStr = "";
    var focheckAllStr = "";
    var socheckAllStr = "";
    if(tmpArray0=='wftype'){
		if(tmpArray2=='1')
			checkAllStr = "<input type=checkbox notBeauty=true id='"+this.id+"_chk' name='t"+tmpArray1+"' value='T"+tmpArray1+"' onclick=\"checkMain('"+tmpArray1+"');webFXTreeHandler.toggles(this.parentNode.parentNode.parentNode.parentNode);\" checked>";
		else
			checkAllStr = "<input type=checkbox notBeauty=true id='"+this.id+"_chk' name='t"+tmpArray1+"' value='T"+tmpArray1+"' onclick=\"checkMain('"+tmpArray1+"');webFXTreeHandler.toggles(this.parentNode.parentNode.parentNode.parentNode);\">";
        if(tmpArray3=='1')
            viewcheckAllStr = "<input type=checkbox notBeauty=true id='"+this.id+"_viewchk' name='vt"+tmpArray1+"' value='VT"+tmpArray1+"' onclick=\"viewcheckMain('"+tmpArray1+"');webFXTreeHandler.viewtoggles(this.parentNode.parentNode.parentNode.parentNode);\" checked>";
        else
            viewcheckAllStr = "<input type=checkbox notBeauty=true id='"+this.id+"_viewchk' name='vt"+tmpArray1+"' value='VT"+tmpArray1+"' onclick=\"viewcheckMain('"+tmpArray1+"');webFXTreeHandler.viewtoggles(this.parentNode.parentNode.parentNode.parentNode);\">";
        if(tmpArray4=='1')
            intervenorcheckAllStr = "<input type=checkbox notBeauty=true id='"+this.id+"_intervenorchk' name='it"+tmpArray1+"' value='IT"+tmpArray1+"' onclick=\"intervenorcheckMain('"+tmpArray1+"');webFXTreeHandler.viewtoggles(this.parentNode.parentNode.parentNode.parentNode);\" checked>";
        else
            intervenorcheckAllStr = "<input type=checkbox notBeauty=true id='"+this.id+"_intervenorchk' name='it"+tmpArray1+"' value='IT"+tmpArray1+"' onclick=\"intervenorcheckMain('"+tmpArray1+"');webFXTreeHandler.viewtoggles(this.parentNode.parentNode.parentNode.parentNode);\">";
        if(tmpArray5=='1')
            delcheckAllStr = "<input type=checkbox notBeauty=true id='"+this.id+"_delchk' name='dt"+tmpArray1+"' value='DT"+tmpArray1+"' onclick=\"delcheckMain('"+tmpArray1+"');webFXTreeHandler.viewtoggles(this.parentNode.parentNode.parentNode.parentNode);\" checked>";
        else
            delcheckAllStr = "<input type=checkbox notBeauty=true id='"+this.id+"_delchk' name='dt"+tmpArray1+"' value='DT"+tmpArray1+"' onclick=\"delcheckMain('"+tmpArray1+"');webFXTreeHandler.viewtoggles(this.parentNode.parentNode.parentNode.parentNode);\">";
        if(tmpArray6=='1')
            fbcheckAllStr = "<input type=checkbox notBeauty=true id='"+this.id+"_fbchk' name='bt"+tmpArray1+"' value='BT"+tmpArray1+"' onclick=\"fbcheckMain('"+tmpArray1+"');webFXTreeHandler.viewtoggles(this.parentNode.parentNode.parentNode.parentNode);\" checked>";
        else
            fbcheckAllStr = "<input type=checkbox notBeauty=true id='"+this.id+"_fbchk' name='bt"+tmpArray1+"' value='BT"+tmpArray1+"' onclick=\"fbcheckMain('"+tmpArray1+"');webFXTreeHandler.viewtoggles(this.parentNode.parentNode.parentNode.parentNode);\">";
        if(tmpArray7=='1')
            focheckAllStr = "<input type=checkbox notBeauty=true id='"+this.id+"_fochk' name='ot"+tmpArray1+"' value='OT"+tmpArray1+"' onclick=\"focheckMain('"+tmpArray1+"');webFXTreeHandler.viewtoggles(this.parentNode.parentNode.parentNode.parentNode);\" checked>";
        else
            focheckAllStr = "<input type=checkbox notBeauty=true id='"+this.id+"_fochk' name='ot"+tmpArray1+"' value='OT"+tmpArray1+"' onclick=\"focheckMain('"+tmpArray1+"');webFXTreeHandler.viewtoggles(this.parentNode.parentNode.parentNode.parentNode);\">";
        if(tmpArray8=='1')
            socheckAllStr = "<input type=checkbox notBeauty=true id='"+this.id+"_sochk' name='st"+tmpArray1+"' value='ST"+tmpArray1+"' onclick=\"socheckMain('"+tmpArray1+"');webFXTreeHandler.viewtoggles(this.parentNode.parentNode.parentNode.parentNode);\" checked>";
        else
            socheckAllStr = "<input type=checkbox notBeauty=true id='"+this.id+"_sochk' name='st"+tmpArray1+"' value='ST"+tmpArray1+"' onclick=\"socheckMain('"+tmpArray1+"');webFXTreeHandler.viewtoggles(this.parentNode.parentNode.parentNode.parentNode);\">";
    }
	if(tmpArray0=='wf'){
		var c = "";
        var vc="";
        var o = document.getElementById(this.parentNode.id+"_chk");
        var vo = document.getElementById(this.parentNode.id+"_viewchk");
        var io = document.getElementById(this.parentNode.id+"_intervenorchk");
        var ic="";
        var delo = document.getElementById(this.parentNode.id+"_delchk");
        var delc="";
        var fbo = document.getElementById(this.parentNode.id+"_fbchk");
        var fbc="";
        var foo = document.getElementById(this.parentNode.id+"_fochk");
        var foc="";
        var soo = document.getElementById(this.parentNode.id+"_sochk");
        var soc="";
        if(o){
			if(o.checked&&!flags){c = "checked";
			flags=false;
			}
		}
        if(vo){
			if(vo.checked&&!viewflags){vc = "checked";
			viewflags=false;
			}
		}
        if(io){
			if(io.checked&&!intervenorflags){
                ic = "checked";
			    intervenorflags=false;
			}
		}
		if(delo){
			if(delo.checked&&!delflags){
                delc = "checked";
			    delflags=false;
			}
		}
        if(fbo){
			if(fbo.checked&&!fbflags){
                fbc = "checked";
			    fbflags=false;
			}
		}
        if(foo){
			if(foo.checked&&!foflags){
                foc = "checked";
			    foflags=false;
			}
		}
		if(soo){
			if(soo.checked&&!soflags){
                soc = "checked";
			    soflags=false;
			}
		}
        if(flags){
            if(tmpArray3=='1')
                checkAllStr = "<input type=checkbox notBeauty=true name='w"+tmpArray1+"'  value='W"+tmpArray2+"' onclick=checkSub(this,'"+tmpArray2+"','"+tmpArray1+"') checked>";
            else
                checkAllStr = "<input type=checkbox notBeauty=true name='w"+tmpArray1+"'  value='W"+tmpArray2+"' onclick=checkSub(this,'"+tmpArray2+"','"+tmpArray1+"') >";
        }else{
            checkAllStr = "<input type=checkbox notBeauty=true name='w"+tmpArray1+"'  value='W"+tmpArray2+"' onclick=checkSub(this,'"+tmpArray2+"','"+tmpArray1+"') "+c+" >";
        }
        if(viewflags){
            if(tmpArray4=='1')
                viewcheckAllStr = "<input type=checkbox notBeauty=true name='vw"+tmpArray1+"'  value='VW"+tmpArray2+"' onclick=viewcheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') checked>";
            else
                viewcheckAllStr = "<input type=checkbox notBeauty=true name='vw"+tmpArray1+"'  value='VW"+tmpArray2+"' onclick=viewcheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') >";
        }else{
			viewcheckAllStr = "<input type=checkbox notBeauty=true name='vw"+tmpArray1+"'  value='VW"+tmpArray2+"' onclick=viewcheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') "+vc+" >";
        }
        if(intervenorflags){
            if(tmpArray5=='1')
                intervenorcheckAllStr = "<input type=checkbox notBeauty=true name='iw"+tmpArray1+"'  value='IW"+tmpArray2+"' onclick=intervenorcheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') checked>";
            else
                intervenorcheckAllStr = "<input type=checkbox notBeauty=true name='iw"+tmpArray1+"'  value='IW"+tmpArray2+"' onclick=intervenorcheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') >";
        }else{
			intervenorcheckAllStr = "<input type=checkbox notBeauty=true name='iw"+tmpArray1+"'  value='IW"+tmpArray2+"' onclick=intervenorcheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') "+ic+" >";
        }
        if(delflags){
            if(tmpArray6=='1')
                delcheckAllStr = "<input type=checkbox notBeauty=true name='dw"+tmpArray1+"'  value='DW"+tmpArray2+"' onclick=delcheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') checked>";
            else
                delcheckAllStr = "<input type=checkbox notBeauty=true name='dw"+tmpArray1+"'  value='DW"+tmpArray2+"' onclick=delcheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') >";
        }else{
			delcheckAllStr = "<input type=checkbox notBeauty=true name='dw"+tmpArray1+"'  value='DW"+tmpArray2+"' onclick=delcheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') "+delc+" >";
        }
        if(fbflags){
            if(tmpArray7=='1')
                fbcheckAllStr = "<input type=checkbox notBeauty=true name='bw"+tmpArray1+"'  value='BW"+tmpArray2+"' onclick=fbcheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') checked>";
            else
                fbcheckAllStr = "<input type=checkbox notBeauty=true name='bw"+tmpArray1+"'  value='BW"+tmpArray2+"' onclick=fbcheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') >";
        }else{
			fbcheckAllStr = "<input type=checkbox notBeauty=true name='bw"+tmpArray1+"'  value='BW"+tmpArray2+"' onclick=fbcheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') "+fbc+" >";
        }
        if(foflags){
            if(tmpArray8=='1')
                focheckAllStr = "<input type=checkbox notBeauty=true name='ow"+tmpArray1+"'  value='OW"+tmpArray2+"' onclick=focheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') checked>";
            else
                focheckAllStr = "<input type=checkbox notBeauty=true name='ow"+tmpArray1+"'  value='OW"+tmpArray2+"' onclick=focheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') >";
        }else{
			focheckAllStr = "<input type=checkbox notBeauty=true name='ow"+tmpArray1+"'  value='OW"+tmpArray2+"' onclick=focheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') "+foc+" >";
        }
        if(foflags){
            if(tmpArray8=='1')
                focheckAllStr = "<input type=checkbox notBeauty=true name='ow"+tmpArray1+"'  value='OW"+tmpArray2+"' onclick=focheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') checked>";
            else
                focheckAllStr = "<input type=checkbox notBeauty=true name='ow"+tmpArray1+"'  value='OW"+tmpArray2+"' onclick=focheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') >";
        }else{
			focheckAllStr = "<input type=checkbox notBeauty=true name='ow"+tmpArray1+"'  value='OW"+tmpArray2+"' onclick=focheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') "+foc+" >";
        }
        if(soflags){
            if(tmpArray9=='1')
                socheckAllStr = "<input type=checkbox notBeauty=true name='sw"+tmpArray1+"'  value='SW"+tmpArray2+"' onclick=socheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') checked>";
            else
                socheckAllStr = "<input type=checkbox notBeauty=true name='sw"+tmpArray1+"'  value='SW"+tmpArray2+"' onclick=socheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') >";
        }else{
			socheckAllStr = "<input type=checkbox notBeauty=true name='sw"+tmpArray1+"'  value='SW"+tmpArray2+"' onclick=socheckSub(this,'"+tmpArray2+"','"+tmpArray1+"') "+soc+" >";
        }
    }
    var tdstyle="style='display:none;background:#FFFFFF!important;'";
    if(webFXTreeConfig.wfintervenor){
        tdstyle="style='background:#FFFFFF!important;'";
    }


    var str = "<table onmouseover=\"document.getElementById('"+this.id+"-anchor').style.backgroundColor='#FFFFFF';document.getElementById('"+this.id+"-anchor').style.border='1px solid #0099CC';\" onmouseout=\"document.getElementById('"+this.id+"-anchor').style.backgroundColor='';document.getElementById('"+this.id+"-anchor').style.border='1px solid #FFFFFF';\" id=\"" + this.id + "\" ondblclick=\"webFXTreeHandler.toggle(this);\" class=\"webfx-tree-item\" onkeydown=\"return webFXTreeHandler.keydown(this, event)\" style=\"width:100%\" cellpadding=\"0\" cellspacing=\"0\"><tr onmouseover=\"this.style.backgroundColor='#FFFFFF';\" onmouseout=\"this.style.backgroundColor='';\"><td width=\"29%\" style=\"background:#FFFFFF!important;\">" +
		indent +
		"<img id=\"" + this.id + "-plus\" src=\"" + ((this.folder)?((this.open)?((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon):((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon)):((this.parentNode._last)?webFXTreeConfig.lIcon:webFXTreeConfig.tIcon)) + "\" onclick=\"webFXTreeHandler.toggle(this);\">" +
		"<img id=\"" + this.id + "-icon\" class=\"webfx-tree-icon\" src=\"" + ((webFXTreeHandler.behavior == 'classic' && this.open)?this.openIcon:this.icon) + "\" onclick=\"webFXTreeHandler.select(this);\">" +
		"<span style=\"cursor:hand;border:1px solid #FFFFFF;padding:0 4px 0 4px\" id=\"" + this.id + "-anchor\" onfocus=\"webFXTreeHandler.focus(this);\" onblur=\"webFXTreeHandler.blur(this);\"" +
		(this.target ? " target=\"" + this.target + "\"" : "") +
		">" + label + "</span></td><td width=\"7%\" style=\"background:#FFFFFF!important;\">"+checkAllStr+"</td><td width=\"13%\" style=\"background:#FFFFFF!important;\">"+viewcheckAllStr+"</td><td width=\"10%\" "+tdstyle+" >"+intervenorcheckAllStr+"</td><td width=\"8%\" style=\"background:#FFFFFF!important;\">"+delcheckAllStr+"</td><td width=\"11%\" style=\"background:#FFFFFF!important;\">"+fbcheckAllStr+"</td><td width=\"11%\" style=\"background:#FFFFFF!important;\">"+focheckAllStr+"</td><td width=\"11%\" style='"+(isOpenWorkflowStopOrCancel=="1"?"":"display:none")+";background:#FFFFFF!important;'>"+socheckAllStr+"</td></tr></table>" +
		"<div id=\"" + this.id + "-cont\" class=\"webfx-tree-container\" style=\"display: " + ((this.open)?'block':'none') + ";\">";
	var sb = [];
	for (var i = 0; i < this.childNodes.length; i++) {
		sb[i] = this.childNodes[i].toString(i,this.childNodes.length);
	}
	this.plusIcon = ((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon);
	this.minusIcon = ((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon);
    return str + sb.join("") + "</div>";
}