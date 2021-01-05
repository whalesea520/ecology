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
	rootIcon        : '/images/xp_none/T_wev8.png',//'/images/xp_none/foldericon_wev8.png',
	openRootIcon    : '/images/xp_none/T_wev8.png',//'/images/xp_none/openfoldericon_wev8.png',
	folderIcon      : '/images/xp_none/T_wev8.png',//'/images/xp_none/foldericon_wev8.png',
	openFolderIcon  : '/images/xp_none/T_wev8.png',//'/images/xp_none/openfoldericon_wev8.png',
	fileIcon        : '/images/xp_none/T_wev8.png',//'/images/xp_none/file_wev8.png',
	iIcon           : '/images/xp_none/I_wev8.png',
	lIcon           : '/images/xp_none/L_wev8.png',
	lMinusIcon      : '/images/xp_none/Lminus_wev8.png',
	lPlusIcon       : '/images/xp_none/Lplus_wev8.png',
	tIcon           : '/images/xp_none/T_wev8.png',
	tMinusIcon      : '/images/xp_none/Tminus_wev8.png',
	tPlusIcon       : '/images/xp_none/Tplus_wev8.png',
	blankIcon       : '/images/xp_none/blank_wev8.png',
	defaultText     : '',
	defaultAction   : 'javascript:void(0);',
	defaultBehavior : 'classic',
	usePersistence	: false
};
var once = true;
var FIX_HEIGHT = 30;
var webFXTreeHandler = {
	idCounter : 0,
	idPrefix  : "webfx-tree-object-",
	all       : {},
	behavior  : null,
	selected  : null,
	onSelect  : null, /* should be part of tree, not handler */
	getId     : function() { return this.idPrefix + this.idCounter++; },
	toggle    : function (oItem) { this.all[oItem.id.replace('-plus','')].toggle(); },
	expandAnyway:function(oItem){this.all[oItem.id.replace('-plus','')].expandAnyway();},
	select    : function (oItem) { 
					var id = oItem.id.replace("-icon",'');
					this.all[id].select();
					jQuery("div.webfx-tree-item_selected").removeClass("webfx-tree-item_selected");
					jQuery(oItem).closest("div.webfx-tree-item").addClass("webfx-tree-item_selected");
					this.all[id].switchImage(id);
				},
	focus     : function (oItem) { this.all[oItem.id.replace('-anchor','')].focus(); },
	blur      : function (oItem) { this.all[oItem.id.replace('-anchor','')].blur(); },
	keydown   : function (oItem, e) { return this.all[oItem.id].keydown(e.keyCode); },
	xtree_highlight   : function (oItem) { this.all[oItem.id].xtree_highlight(); },
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
var addselect = "";
var label = "";
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
 * To speed thing up if you're adding multiple nodes at once (after load) use
 * the bNoIdent parameter to prevent automatic re-indentation and call the
 * obj.ident() method manually once all nodes has been added.
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

WebFXTreeAbstractNode.prototype.switchImage = function(id){
	var src = jQuery("#"+id+"-plus").attr("src");
	var lastSrc = "";
	if(jQuery("div#"+id).hasClass("webfx-tree-item_selected")){
		jQuery("img[src*='w_']").each(function(){
			lastSrc = jQuery(this).attr("src");
			jQuery(this).attr("src",lastSrc.replace("w_",""));
		});
		
		var image = src.substring(src.indexOf("/images/xp_none/")+16);
		if(image.indexOf("w_")<0){
			image = "w_"+image;
		}
		jQuery("img#"+id+"-plus").attr("src","/images/xp_none/"+image);
	}
}

WebFXTreeAbstractNode.prototype.toggle = function() {
	if (this.folder) {
		if (this.open) { this.collapse(); }
		else {
			this.expand();
		}
		this.switchImage(this.id);
}	}

WebFXTreeAbstractNode.prototype.expandAnyway = function(){
	this.expand();
	this.switchImage(this.id);
}

WebFXTreeAbstractNode.prototype.select = function() {
	document.getElementById(this.id + '-anchor').focus();
}

WebFXTreeAbstractNode.prototype.deSelect = function() {
	try{
		document.getElementById(this.id + '-anchor').className = '';
	}catch(e){
		if(window.console)console.log(e+"---/js/xtree.js---deSelect()");
	}
	webFXTreeHandler.selected = null;
}

WebFXTreeAbstractNode.prototype.focus = function() {
	if ((webFXTreeHandler.selected) && (webFXTreeHandler.selected != this)) { webFXTreeHandler.selected.deSelect(); }
	webFXTreeHandler.selected = this;
	//if ((this.openIcon) && (webFXTreeHandler.behavior != 'classic')) { document.getElementById(this.id + '-icon').src = this.openIcon; }
	document.getElementById(this.id + '-anchor').className = 'selected';
	//document.getElementById(this.id + '-anchor').focus();
	if (webFXTreeHandler.onSelect) { webFXTreeHandler.onSelect(this); }
}

WebFXTreeAbstractNode.prototype.blur = function() {
	//if ((this.openIcon) && (webFXTreeHandler.behavior != 'classic')) { document.getElementById(this.id + '-icon').src = this.icon; }
	document.getElementById(this.id + '-anchor').className = 'selected-inactive';
}

WebFXTreeAbstractNode.prototype.doExpand = function() {
	//if (webFXTreeHandler.behavior == 'classic') { document.getElementById(this.id + '-icon').src = this.openIcon; }
	if (this.childNodes.length) {  
		document.getElementById(this.id + '-cont').style.display = 'block'; 
		jQuery("#"+this.id + '-cont').children("div.webfx-tree-item").show();
	}
	this.open = true;
	if (webFXTreeConfig.usePersistence) {
		webFXTreeHandler.cookies.setCookie(this.id.substr(18,this.id.length - 18), '1');
}	}

WebFXTreeAbstractNode.prototype.doCollapse = function() {
	//if (webFXTreeHandler.behavior == 'classic') { document.getElementById(this.id + '-icon').src = this.icon; }
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
	 * Since we only want to modify items one level below ourself, and since the
	 * rightmost indentation position is occupied by the plus icon we set this
	 * to -2
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
	this.folder    = true;
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
	/*var str = "<div  onmouseover=\"jQuery(this).addClass('webfx-tree-item_hover');\" onmouseout=\"jQuery(this).removeClass('webfx-tree-item_hover');\" style=\"margin:-27px 0 0 0\" id=\"" + this.id + "\" ondblclick=\"webFXTreeHandler.toggle(this);\" class=\"webfx-tree-item\" onkeydown=\"return webFXTreeHandler.keydown(this, event)\" style=\"width:0;height:0;overflow:hidden\">" +
		"<img id=\"" + this.id + "-icon\" class=\"webfx-tree-icon\" src=\"" + ((webFXTreeHandler.behavior == 'classic' && this.open)?this.openIcon:this.icon) + "\" onclick=\"webFXTreeHandler.select(this);\">" +
		"<a href=\"" + this.action + "\" id=\"" + this.id + "-anchor\" onclick=\"webFXTreeHandler.select(document.getElementById('"+this.id+"-icon'));webFXTreeHandler.toggle(document.getElementById('"+this.id+"'));\" onkeydown=\"return webFXTreeHandler.keydown(document.getElementById('"+this.id+"'), event)\" onfocus=\"webFXTreeHandler.focus(this);\" onblur=\"webFXTreeHandler.blur(this);\"" +
		(this.target ? " target=\"" + this.target + "\"" : "") +
		">" + this.text + "</a></div>" +
		"<div id=\"" + this.id + "-cont\" class=\"webfx-tree-container\" style=\"display: " + ((this.open)?'block':'none') + ";\">";*/
	var str = "";	
	var sb = [];
	for (var i = 0; i < this.childNodes.length; i++) {
		sb[i] = this.childNodes[i].toString(i, this.childNodes.length);
	}
	this.rendered = true;
	var html = str + sb.join("") + "</div>";
	html = "<div style=\"overflow:hidden;height:708px;position:relative;\" id=\"overFlowDivTree\" _count=0><div class=\"ulDiv\" style='display:none;' >"+
	"<div id='hiddenImage' style='display:none;'><img src='/images/xp_none/Lminus_wev8.png' onload='__xTreeNamespace__.prefectScrollBarForXtree();'/></div>"+html+"</div></div>";
	return html;
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
		document.getElementById(prevSibling.id + '-icon').src = webFXTreeConfig.fileIcon;
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
	window.setTimeout(function(){
		try{
			jQuery("#overFlowDivTree .ulDiv").height(jQuery(".webfx-tree-container").height()+FIX_HEIGHT);
			jQuery('#overFlowDivTree').perfectScrollbar("update");
		}catch(e){
			if(window.console)console.log("/js/xtree.js-->expand-->"+e);
		}
	},300);
}

WebFXTreeItem.prototype.collapse = function(b) {
	if (!b) { this.focus(); }
	this.doCollapse();
	document.getElementById(this.id + '-plus').src = this.plusIcon;
	window.setTimeout(function(){
		try{
			jQuery("#overFlowDivTree .ulDiv").height(jQuery(".webfx-tree-container").height()+FIX_HEIGHT);
			jQuery('#overFlowDivTree').perfectScrollbar("update");
		}catch(e){
			if(window.console)console.log("/js/xtree.js-->collapse-->"+e);
		}
	},300);
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
WebFXTreeItem.prototype.xtree_highlight = function() {
	try{
		var canceledDepartmentIds;
		var canceledDepartmentIdsObj = document.getElementById("canceledDepartmentIds");
		if(canceledDepartmentIdsObj != null) {
			canceledDepartmentIds = document.getElementById("canceledDepartmentIds").value;
		}
		var showcheck=false;
		try{
			if(selectallflag!=null){
				showcheck = selectallflag;
			}
		}catch(e){
			showcheck = false;
		}
		if(showcheck){
			if(document.getElementById(this.id+'_radio').getElementsByTagName('INPUT')[0].checked){
				document.getElementById(this.id+'_radio').getElementsByTagName('INPUT')[0].value = cxtree_IdArr[this.id].substring(3)+'_'+this.text.replace(/</g, '&lt;').replace(/>/g, '&gt;');
				if(canceledDepartmentIds != null) {
					if(canceledDepartmentIds.indexOf("," + document.getElementById(this.id+'_radio').getElementsByTagName('INPUT')[0].value) > -1) {
						canceledDepartmentIds = canceledDepartmentIds.replace("," + document.getElementById(this.id+'_radio').getElementsByTagName('INPUT')[0].value, "");
						if(canceledDepartmentIdsObj != null) {
							document.getElementById("canceledDepartmentIds").value = canceledDepartmentIds;
						}
					}
				}
				for(var i=0;i<this.childNodes.length;i++){
					if(document.getElementById(this.childNodes[i].id+'_radio').getElementsByTagName('INPUT')[0].style.display==""){
						document.getElementById(this.childNodes[i].id+'_radio').getElementsByTagName('INPUT')[0].checked = true;
						document.getElementById(this.childNodes[i].id+'_radio').getElementsByTagName('INPUT')[0].value = cxtree_IdArr[this.childNodes[i].id].substring(3)+'_'+this.childNodes[i].text.replace(/</g, '&lt;').replace(/>/g, '&gt;');
						this.childNodes[i].xtree_highlight();
					}
				}
			}else{
				if(canceledDepartmentIdsObj != null) {
					document.getElementById("canceledDepartmentIds").value = document.getElementById("canceledDepartmentIds").value + "," + document.getElementById(this.id+'_radio').getElementsByTagName('INPUT')[0].value;
				}
				if(document.getElementById(this.parentNode.id+'_radio')!=null){
					var tmpvalue = document.getElementById(this.parentNode.id+'_radio').getElementsByTagName('INPUT')[0].value;
					var arraytemp = tmpvalue.split("_");
					if(arraytemp.length <= 3) {
						document.getElementById(this.parentNode.id+'_radio').getElementsByTagName('INPUT')[0].checked=false;
					}
					// document.getElementById(this.parentNode.id+'_radio').getElementsByTagName('INPUT')[0].checked=false;
				}
				for(var i=0;i<this.childNodes.length;i++){
					if(document.getElementById(this.childNodes[i].id+'_radio').getElementsByTagName('INPUT')[0].style.display==""){
						document.getElementById(this.childNodes[i].id+'_radio').getElementsByTagName('INPUT')[0].checked = false;
						document.getElementById(this.childNodes[i].id+'_radio').getElementsByTagName('INPUT')[0].value = 'on';
						this.childNodes[i].xtree_highlight();
					}
				}
			}
		}else{
			document.getElementById(this.id+'_radio').getElementsByTagName('INPUT')[0].value = cxtree_IdArr[this.id].substring(3)+'_'+this.text.replace(/</g, '&lt;').replace(/>/g, '&gt;');
		}
	}catch(e){}
};
WebFXTreeItem.prototype.toString = function (nItem, nItemCount) {
	var addstr = false;
	var indeximg = '';
	var addstrname = '';
	try {
		if(appendname!=null){
			addstr = true;
			addstrname = appendname;
		}
		if(appendimg!=null) indeximg = appendimg;
	}
	catch(e) {addstr=false;indeximg='subject3';addstrname='';}
	
	var foo = this.parentNode;
	var indent = '';
	if (nItem + 1 == nItemCount) { this.parentNode._last = true; }
	var i = 0;
	while (foo.parentNode) {
		foo = foo.parentNode;
		indent = ((foo._last)?"&nbsp;&nbsp;":"<img id=\"" + this.id + "-indent-" + i + "\" src=\"" + webFXTreeConfig.iIcon + "\">") + indent;
		//indent = "&nbsp;" + indent;
		i++;
	}
	this._level = i;
	if (this.childNodes.length) { this.folder = 1; }
	else { this.open = false; }
	if ((this.folder) || (webFXTreeHandler.behavior != 'classic')) {
		if (!this.icon) { this.icon = webFXTreeConfig.folderIcon; }
		if (!this.openIcon) { this.openIcon = webFXTreeConfig.openFolderIcon; }
	}
	else if (!this.icon) { this.icon = webFXTreeConfig.fileIcon; }
	label = this.text.replace(/</g, '&lt;').replace(/>/g, '&gt;');
	if(this._num==null)this._num="";
	if(label!=""){
		var str = "";
		var appendstr="";
		var selectstr = "";
		var typestr="";
		var showcheck=false;
		var selids = "";
		try{
			if(allselect!=null){
				selectstr = "all";
			}
		}catch(e){
			selectstr = "";
		}
		try{
			if(typename!=null){
				typestr = "checkbox";
			}
		}catch(e){
			typestr = "";
		}
		try{
			if(selectreview!=null){
				addselect = selectreview;
			}
		}catch(e){
			addselect = "";
		}
		try{
			if(selectallflag!=null){
				showcheck = selectallflag;
			}
		}catch(e){
			showcheck = false;
		}
		try{
			if(selectedids!=null){
				selids = selectedids;
			}
		}catch(e){
			selids = "";
		}
		if(selectstr=="all"){
			if(typestr=="checkbox"){
				if(addselect=="openall"){
					if(this.icon.indexOf(indeximg)>1){
						if(showcheck){
							if(document.getElementById(this.parentNode.id+'_radio').getElementsByTagName('INPUT')[0].checked){
								appendstr = "<span id='"+this.id+"_radio'><input type=\"checkbox\" checked=\"checked\" value=\""+cxtree_IdArr[this.id].substring(3)+'_'+label+"\" name=\""+addstrname+"\" onclick=\"webFXTreeHandler.xtree_highlight(document.getElementById('"+this.id+"'))\"></span>";
							}else{
								appendstr = "<span id='"+this.id+"_radio'><input type=\"checkbox\" name=\""+addstrname+"\" onclick=\"webFXTreeHandler.xtree_highlight(document.getElementById('"+this.id+"'))\"></span>";
							}
						}else{
							if(cxtree_IdArr[this.id]!=null&&selids!=null&&selids!=''){
								var strname = cxtree_IdArr[this.id].split("_");
								var strsel = selids.split(",");
								for(var num=0;num<strsel.length;num++){
									if(strname[strname.length-1]==strsel[num]){
										appendstr = "<span id='"+this.id+"_radio'><input type=\"checkbox\" checked=\"checked\" value=\""+cxtree_IdArr[this.id].substring(3)+'_'+label+"\" name=\""+addstrname+"\" onclick=\"webFXTreeHandler.xtree_highlight(document.getElementById('"+this.id+"'))\"></span>";
										break;
									}else{
										appendstr = "<span id='"+this.id+"_radio'><input type=\"checkbox\" name=\""+addstrname+"\" onclick=\"webFXTreeHandler.xtree_highlight(document.getElementById('"+this.id+"'))\"></span>";
									}
								}
							}else{
								appendstr = "<span id='"+this.id+"_radio'><input type=\"checkbox\" name=\""+addstrname+"\" onclick=\"webFXTreeHandler.xtree_highlight(document.getElementById('"+this.id+"'))\"></span>";
							}
						}
					}else{
						if(showcheck){
							if(document.getElementById(this.parentNode.id+'_radio')!=null){
								if(document.getElementById(this.parentNode.id+'_radio').getElementsByTagName('INPUT')[0].checked){
									appendstr = "<span id='"+this.id+"_radio'><input type=\"checkbox\" checked=\"checked\" value=\""+cxtree_IdArr[this.id].substring(3)+'_'+label+"\" name=\""+addstrname+"\" onclick=\"webFXTreeHandler.xtree_highlight(document.getElementById('"+this.id+"'))\"></span>";
								}else{
									appendstr = "<span id='"+this.id+"_radio'><input type=\"checkbox\" name=\""+addstrname+"\" onclick=\"webFXTreeHandler.xtree_highlight(document.getElementById('"+this.id+"'))\"></span>";
								}
							}
						}else{
							appendstr = "<span id='"+this.id+"_radio'><input type=\"checkbox\" style=\"display:none\" name=\""+addstrname+"\" onclick=\"webFXTreeHandler.xtree_highlight(document.getElementById('"+this.id+"'))\"></span>";
						}
					}
				}else{
					appendstr = "<span id='"+this.id+"_radio'>"+(this.icon.indexOf(indeximg)>1?"<input type=\"checkbox\" name=\""+addstrname+"\" onclick=\"webFXTreeHandler.xtree_highlight(document.getElementById('"+this.id+"'))\">":"")+"</span>";
				}
			}else{
				if(cxtree_IdArr[this.id]!=null&&selids!=null&&selids!=''){
					var strname = cxtree_IdArr[this.id].split("_");
					if(strname[strname.length-1]==selids){
						appendstr = "<span id='"+this.id+"_radio'>"+(this.icon.indexOf(indeximg)>1?"<input type=\"radio\" checked=\"checked\" value=\""+cxtree_IdArr[this.id].substring(3)+'_'+this.text.replace(/</g, '&lt;').replace(/>/g, '&gt;')+"\" name=\""+addstrname+"\" onclick=\"webFXTreeHandler.xtree_highlight(document.getElementById('"+this.id+"'))\">":"")+"</span>";
					}else{
						appendstr = "<span id='"+this.id+"_radio'>"+(this.icon.indexOf(indeximg)>1?"<input type=\"radio\" name=\""+addstrname+"\" onclick=\"webFXTreeHandler.xtree_highlight(document.getElementById('"+this.id+"'))\">":"")+"</span>";
					}
				}else{
					appendstr = "<span id='"+this.id+"_radio'>"+(this.icon.indexOf(indeximg)>1?"<input type=\"radio\" name=\""+addstrname+"\" onclick=\"webFXTreeHandler.xtree_highlight(document.getElementById('"+this.id+"'))\">":"")+"</span>";
				}
			}
		}else{
			if(typestr=="checkbox"){
				appendstr = "<span id='"+this.id+"_radio'>"+(!this.folder&&this.icon.indexOf(indeximg)>1?"<input type=\"checkbox\" name=\""+addstrname+"\" onclick=\"webFXTreeHandler.xtree_highlight(document.getElementById('"+this.id+"'))\">":"")+"</span>";
			}else{
				appendstr = "<span id='"+this.id+"_radio'>"+(!this.folder&&this.icon.indexOf(indeximg)>1?"<input type=\"radio\" name=\""+addstrname+"\" onclick=\"webFXTreeHandler.xtree_highlight(document.getElementById('"+this.id+"'))\">":"")+"</span>";
			}
		}
		if(!this._id){
			this._id = "root";
		}
		if(this.action=="noright"){
			str = "<div _needHide="+!label+" style=\"display:"+(!!label?"block":"none")+"\" _id=\"div_"+this._id+"\"   onmouseover=\"__xTreeNamespace__.xtreemouseover(this)\" onmouseout=\"__xTreeNamespace__.xtreemouseout(this)\" style=\"margin-left:0px\" id=\"" + this.id + "\" ondblclick=\"webFXTreeHandler.toggle(this);\" class=\"webfx-tree-item_sec webfx-tree-item\" onkeydown=\"return webFXTreeHandler.keydown(this, event)\">" +
				indent +
				"<img _id=\"img_"+this._id+"\" id=\"" + this.id + "-plus\" src=\"" + ((this.folder)?((this.open)?((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon):((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon)):((this.parentNode._last)?webFXTreeConfig.lIcon:webFXTreeConfig.tIcon)) + "\" onclick=\"webFXTreeHandler.toggle(this);\" width='16px'>" +
				//"<img id=\"" + this.id + "-icon\" class=\"webfx-tree-icon\" src=\"" + ((webFXTreeHandler.behavior == 'classic' && this.open)?this.openIcon:this.icon) + "\">" +
				(addstr?appendstr:"")+
				"<label>" + label + "</label>" +
				"<span class=\"e8_num_xtree\" id=\"num_"+this._id+"\" style=\"display:"+(this._num?"inline-block":"none")+"\">"+this._num+"</span>"+
				"</div>" +
				"<div id=\"" + this.id + "-cont\" class=\"webfx-tree-container\" style=\"display: " + ((this.open)?'block':'none') + ";\">";
		}else{
			//console.log(this.icon+"::"+this.openIcon);
			var _width = this._level*10+21;
			if(appendstr){
				_width += 16;
			}
			var _awidth = "100%";
			if(jQuery.browser.msie || isIE11()){
				_awidth = (jQuery("#overFlowDivTree").width()-_width)+"px";
			}
			str = "<div _needHide="+!label+" style=\"display:"+(!!label?"block":"none")+"\" _id=\"div_"+this._id+"\"   onmouseover=\"__xTreeNamespace__.xtreemouseover(this)\" onmouseout=\"__xTreeNamespace__.xtreemouseout(this)\" style=\"margin-left:0px\" id=\"" + this.id + "\" ondblclick=\"webFXTreeHandler.toggle(this);\" class=\""+(this._level<=1?"":"webfx-tree-item-sec ")+ "webfx-tree-item\" onkeydown=\"return webFXTreeHandler.keydown(this, event)\">" + 
				indent +
				"<img _id=\"img_"+this._id+"\" id=\"" + this.id + "-plus\" src=\"" + ((this.folder)?((this.open)?((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon):((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon)):((this.parentNode._last)?webFXTreeConfig.lIcon:webFXTreeConfig.tIcon)) + "\" onclick=\"webFXTreeHandler.toggle(this);\" width='16px'>" +
				"<img id=\"" + this.id + "-icon\" class=\"webfx-tree-icon\" style=\"display:"+((this.openIcon||this.icon)?'':'none')+"\" src=\"" + ((webFXTreeHandler.behavior == 'classic' && this.open)?this.openIcon:this.icon) + "\" onclick=\"webFXTreeHandler.select(this);\">" +
				"<a _id=\"a_"+this._id+"\" style='display:none' id=\"" + this.id + "-icon\" onclick=\"webFXTreeHandler.select(this);\"></a>"+
				(addstr?appendstr:"")+
				"<a style=\"display:inline-block;text-overflow:ellipsis;white-space:nowrap;width:"+_awidth+";\" href=\"" + (addstr?"javascript:webFXTreeHandler.xtree_highlight(document.getElementById('"+this.id+"'));":this.action) + "\" id=\"" + this.id + "-anchor\" onclick=\"webFXTreeHandler.select(document.getElementById('"+this.id+"-icon'));webFXTreeHandler.toggle(document.getElementById('"+this.id+"'));\" onkeydown=\"return webFXTreeHandler.keydown(document.getElementById('"+this.id+"'), event)\" onfocus=\"webFXTreeHandler.focus(this);\" onblur=\"webFXTreeHandler.blur(this);\"" +
				(this.target ? " target=\"" + this.target + "\"" : "") +
				">" + label +"</a>"+
				"<span class=\"e8_num_xtree\" id=\"num_"+this._id+"\" style=\"display:"+(this._num?"inline-block":"none")+"\">"+this._num+"</span>"+
				"</div>" +
				"<div id=\"" + this.id + "-cont\" class=\"webfx-tree-container\" style=\"display: " + ((this.open)?'block':'none') + ";\">";
		}
		var sb = [];
		for (var i = 0; i < this.childNodes.length; i++) {
			sb[i] = this.childNodes[i].toString(i,this.childNodes.length);
		}
		this.plusIcon = ((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon);
		this.minusIcon = ((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon);
		return str + sb.join("") + "</div><div style=\"display:none\"><img src=\""+this.minusIcon+"\"/></div>";
	}else{
		var str = "<div _needHide="+!label+" style=\"display:"+(!!label?"block":"none")+"\" _id=\"div_"+this._id+"\"   onmouseover=\"__xTreeNamespace__.xtreemouseover(this)\" onmouseout=\"__xTreeNamespace__.xtreemouseout(this)\" style=\"margin-left:0px\" id=\"" + this.id + "\" ondblclick=\"webFXTreeHandler.toggle(this);\" class=\"webfx-tree-item_sec webfx-tree-item\" onkeydown=\"return webFXTreeHandler.keydown(this, event)\" style=\"width:0;height:0;overflow:hidden\">" +
			indent +
			"<img _id=\"img_"+this._id+"\" id=\"" + this.id + "-plus\" style='display:none;'  src=\"" + ((this.folder)?((this.open)?((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon):((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon)):((this.parentNode._last)?webFXTreeConfig.lIcon:webFXTreeConfig.tIcon)) + "\" onclick=\"webFXTreeHandler.toggle(this);\" width='16px'>" +
			"<img id=\"" + this.id + "-icon\" class=\"webfx-tree-icon\" style=\"display:"+((this.openIcon||this.icon)?'':'none')+"\" src=\"" + ((webFXTreeHandler.behavior == 'classic' && this.open)?this.openIcon:this.icon) + "\" onclick=\"webFXTreeHandler.select(this);\">" +
			"<a _id=\"a_"+this._id+"\" href=\"" + this.action + "\" id=\"" + this.id + "-anchor\" onclick=\"webFXTreeHandler.select(document.getElementById('"+this.id+"-icon'));webFXTreeHandler.toggle(document.getElementById('"+this.id+"'));\" onkeydown=\"return webFXTreeHandler.keydown(document.getElementById('"+this.id+"'), event)\" onfocus=\"webFXTreeHandler.focus(this);\" onblur=\"webFXTreeHandler.blur(this);\"" +
			(this.target ? " target=\"" + this.target + "\"" : "") +
			"></a>"+"<span class=\"e8_num_xtree\" id=\"num_"+this._id+"\" style=\"display:"+(this._num?"inline-block":"none")+"\">"+this._num+"</span>"+
			"</div>" +
			"<div id=\"" + this.id + "-cont\" class=\"webfx-tree-container\" style=\"display: " + ((this.open)?'block':'none') + ";\">";
		var sb = [];
		for (var i = 0; i < this.childNodes.length; i++) {
			sb[i] = this.childNodes[i].toString(i,this.childNodes.length);
		}
		this.plusIcon = ((this.parentNode._last)?webFXTreeConfig.lPlusIcon:webFXTreeConfig.tPlusIcon);
		this.minusIcon = ((this.parentNode._last)?webFXTreeConfig.lMinusIcon:webFXTreeConfig.tMinusIcon);
		return str + sb.join("") + "</div><div style=\"display:none\"><img src=\""+this.minusIcon+"\"/></div>";
	}
}

var __xTreeNamespace__  = (function(){
	return (function(){
		return {
			e8HasData:function(){
				if(window._treeLoaded){
					var ulDiv = jQuery("#overFlowDivTree .ulDiv");
					var height = ulDiv.children(".webfx-tree-container").height();
					try{
						if(ulDiv.children(".webfx-tree-container").length==0||height==0){
							var emptyinfo = jQuery("#e8emptyInfo");
							if(emptyinfo.length==0){
								emptyinfo=jQuery("<div id='e8emptyInfo'></div>");
								ulDiv.parent().after(emptyinfo);
							}
							emptyinfo.html(SystemEnv.getHtmlNoteName(3558,readCookie("languageidweaver")));
							emptyinfo.show();
						}else{
							jQuery("#e8emptyInfo").hide();

						}
					}catch(e){
						if(window.console)console.log(e);
					}
				}else{
					setTimeout(function(){
						e8HasData();
					},100);
				}
			},
			prefectScrollBarForXtree:function(){
				var overflowDivTree = jQuery("#overFlowDivTree");
				var ulDiv = overflowDivTree.children(".ulDiv");
				ulDiv.show();
				var height = ulDiv.children(".webfx-tree-container").height();
				var cc = parseInt(overflowDivTree.attr("_count"))+1;
				overflowDivTree.attr("_count",cc)
				var oTd = jQuery("#oTd1",parent.document);
				var leftTypeSearch = jQuery("td.leftTypeSearch");
				var leftTypeSearchHeight = leftTypeSearch.height();
				if(leftTypeSearchHeight==jQuery(window).height()){
					leftTypeSearchHeight = 60;
				}
				if(window._treeLoaded){
					jQuery("#overFlowDiv").height(jQuery(window).height()-leftTypeSearchHeight);
				}
				if(!height && cc>20 && (oTd.length==0||oTd.css("display")!="none")){
					e8HasData();
				}
				if(!!height && window._treeLoaded){
					var expandOrCollapseDiv = jQuery("div.e8_expandOrCollapseDiv");
					var flowMenusTd = overflowDivTree.closest("td.flowMenusTd");
					var __hideExpandOrCollapseDiv = flowMenusTd.attr("__hideExpandOrCollapseDiv");
					var e8_searching = jQuery("div#e8_loading");
					if(e8_searching.length==0){
						e8_searching = getLoadingDiv();
						jQuery("body").append(e8_searching);
						e8_searching.css({
							//top:flowMenusTd.height()/2,
							width:flowMenusTd.width()-12
						});
					}
					if(expandOrCollapseDiv.length==0 && flowMenusTd.length>0){
						var subcompany = jQuery("#subCompanyId");
						if(subcompany.length>0 && !window.__hideExpandOrCollapseDiv){
							expandOrCollapseDiv = jQuery("<div class='e8_expandOrCollapseDiv'><</div>");
							if(flowMenusTd.css("display")=="none"){
								expandOrCollapseDiv.hide();
							}
							jQuery("body").append(expandOrCollapseDiv);
							//console.log((flowMenusTd.position().left+flowMenusTd.width())-expandOrCollapseDiv.width());
							expandOrCollapseDiv.css({
								left:flowMenusTd.position().left+flowMenusTd.width()-expandOrCollapseDiv.width(),
								top:flowMenusTd.height()/2
							});
							expandOrCollapseDiv.bind("click",function(){
								refreshTop(document);
							});
						}
					}
					var overFlowDiv = null; //jQuery("div.ps-container");
					if(!!overFlowDiv && overFlowDiv.length>0){
						jQuery("#overFlowDivTree").height(overFlowDiv.height());
						overFlowDiv.children("div").height(overFlowDiv.height());
					}else{
						var zDialog_div_content = jQuery("div.zDialog_div_content");
						var pageHeight = jQuery(window).height();
						if(zDialog_div_content.length>0){
							pageHeight = zDialog_div_content.height();
						}
						var e8_boxhead = jQuery("div.e8_boxhead");
						if(e8_boxhead.length>0){
							if(e8_boxhead.closest("div.zDialog_div_content").length>0){
								pageHeight -= e8_boxhead.height();
							}else{
								pageHeight -= 5;
							}
						}
						jQuery("#overFlowDivTree").height(pageHeight-leftTypeSearchHeight-5);
					}
					ulDiv.height(height);
					jQuery("#btncancel").closest("td").show();
					window.setTimeout(function(){
						jQuery("#overFlowDivTree .ulDiv").height(jQuery(".webfx-tree-container").height()+FIX_HEIGHT);
						jQuery('#overFlowDivTree').perfectScrollbar();
					},300);
				}else{
					if(!window._treeLoaded && (!((oTd.css("display")=="none")||leftTypeSearch.css("display")=="none")||top._initStatus===false)){
						window.setTimeout(function(){
							prefectScrollBarForXtree();
						},300);
					}
				}
			},
			e8_initTree:function(url){
				jQuery.ajax({
				url:url,
				success:function(data){
					jQuery(".ulDiv").css("display","none");
					jQuery(".ulDiv").html(data);
					jQuery(".ulDiv").css("display","");
					jQuery(".ulDiv").height(jQuery("#overFlowDiv").height());
				}
			  });
			},
			refreshTree:function(id,parentId,options){
				window._reload = true;
				var options = jQuery.extend({
					fn:function(){},
					url:"",
					needRefresh:true
				},options);
				if(parentId=="0" || !parentId)parentId="root";
				if(!!parentId){
					//jQuery("img[_id='img_"+parentId+"']:first").click();
					var parentObj = jQuery("img[_id='img_"+parentId+"']").get(0);
					if(!parentObj && parentId=="root")parentObj = jQuery("img[_id='img_undefined']").get(0);
					webFXTreeHandler.expandAnyway(parentObj);
					window.setTimeout(function(){
						//jQuery("div#overFlowDivTree div.webfx-tree-item_selected").removeClass("webfx-tree-item_selected");
						//jQuery("div[_id='div_"+id+"']:first").addClass("webfx-tree-item_selected");
						try{
							webFXTreeHandler.select(jQuery("div[_id='div_"+id+"']:first").get(0));
						}catch(e){}
					},500);
				}else{
					if(options.needRefresh){
						var fn = options.fn;
						fn(options.url);
					}else{
						jQuery("div#overFlowDivTree div.webfx-tree-item_selected").removeClass("webfx-tree-item_selected");
						if(!!id){
							//jQuery("div[_id='div_"+id+"']:first").addClass("webfx-tree-item_selected");
							webFXTreeHandler.select(jQuery("div[_id='div_"+id+"']:first").get(0));
						}
					}
				}
			},
			xtreemouseover:function(obj){
				var haswfversion=0;
				var versonid = 1;
				var xtobj = jQuery(obj);
					xtobj.addClass('webfx-tree-item_hover');
					xtobj.find("a").each(function(){
						var href = $(this).attr("href")+"";
						var getversion = href.indexOf("versionid_toXtree=");
						if(getversion>0){
							versonid = href.substring(href.lastIndexOf("=")+1);
							haswfversion = 1;
						}
					});
				if(haswfversion==1){
					if(xtobj.find("#xtreeversionspan").length==0){
						xtobj.append("<span id='xtreeversionspan' style='position:absolute;background-color:#A6A6A6;right: 0px;width:30px;text-align:center;'>V"+versonid+"</span>");
					}else{
						xtobj.find("#xtreeversionspan").show();
					}
				}
			},
			xtreemouseout:function(obj){
				var xtobj = jQuery(obj);
				xtobj.removeClass('webfx-tree-item_hover');
				if(xtobj.find("#xtreeversionspan").length!=0){
					xtobj.find("#xtreeversionspan").remove();
				}
			},
			expandAll_xtree:function(){
				 var imgs = jQuery("#overFlowDivTree img");
				var i=0;
				imgs.each(function(){
					src = jQuery(this).attr("src");
					if(src.match(/Lplus.png/)||src.match(/Tplus.png/)){
						jQuery(this).click();
						i++;
					}
				});
				return i;
			},
			format_xtree:function(searchStr,show){
				var as = jQuery("div.webfx-tree-item a[target]");
				var hasMore = false;
				as.each(function(){
					var display = jQuery(this).closest("div.webfx-tree-item").css("display");
					if(jQuery(this).text().toLowerCase().indexOf(searchStr)<0 && display!="none"){
						jQuery(this).closest("div.webfx-tree-item").hide();
						hasMore = true;
					}else{
					  if(show && jQuery(this).text().toLowerCase().indexOf(searchStr)>-1){
						  jQuery(this).closest("div.webfx-tree-item").show();
						  var needHide = jQuery(this).closest("div.webfx-tree-container").prev("div.webfx-tree-item").attr("_needHide");
						  if(needHide=="true"){
						  }else{
							jQuery(this).closest("div.webfx-tree-container").prev("div.webfx-tree-item").show()
						  }
					  }
					}
				});
				return hasMore;
			},
			e8_before:function(){
				e8_before_xtree();
			},
			e8_before_xtree:function(){
				jQuery("#overFlowDivTree").hide();
				jQuery("div#e8_loading").show();
				 jQuery("#e8emptyInfo").hide();
			},
			e8_after:function(){
				e8_after_xtree();
			},
			e8_after_xtree:function(){
				jQuery("#overFlowDivTree").show();
				jQuery("div#e8_loading").hide();
				try{
					jQuery("#overFlowDivTree .ulDiv").height(jQuery(".webfx-tree-container").height()+FIX_HEIGHT);
					var ulDiv = jQuery("#overFlowDivTree .ulDiv");
					var div = ulDiv.children("div.webfx-tree-container");
					if(div.length==0 || div.height()==0){
						var emptyinfo = jQuery("#e8emptyInfo");
						if(emptyinfo.length==0){
							emptyinfo=jQuery("<div id='e8emptyInfo'></div>");
							ulDiv.parent().after(emptyinfo);
						}
						emptyinfo.html(SystemEnv.getHtmlNoteName(3558,readCookie("languageidweaver")));
						emptyinfo.show();
					}else{
						jQuery("#e8emptyInfo").hide();
					}
					jQuery('#overFlowDivTree').perfectScrollbar("update");
				}catch(e){
					if(window.console)console.log("/js/xtree.js-->format-->"+e);
				}
			},
			e8_search_xtree:function(searchStr,notExpand){
				var i = 0;
				if(notExpand){
					i=0;
				}else{
					i=expandAll_xtree();
				}
				if(i>0){
					window.setTimeout(function(){
						e8_search_xtree(searchStr);
					},1000);
				}else{
					var hasMore = format_xtree(searchStr);
					if(hasMore){
						window.setTimeout(function(){
							e8_search_xtree(searchStr,true);
						},500);
					}else{
						format_xtree(searchStr,true);
						e8_after_xtree();
					}
				}
			}
		}
	})();
})();

//@deprecated
function e8HasData(){
	__xTreeNamespace__.e8HasData();
}

//@deprecated
function prefectScrollBarForXtree(){
	__xTreeNamespace__.prefectScrollBarForXtree();
}

//@deprecated
function e8_initTree(url){
	__xTreeNamespace__.e8_initTree(url);
}

//@deprecated
function refreshTree(id,parentId,options){
	__xTreeNamespace__.refreshTree(id,parentId,options);
}

//@deprecated
function xtreemouseover(obj){
		__xTreeNamespace__.xtreemouseover(obj);
}

//@deprecated
function xtreemouseout(obj){
	__xTreeNamespace__.xtreemouseout(obj);
}

//@deprecated
function expandAll_xtree(){
   return __xTreeNamespace__.expandAll_xtree();
}

//@deprecated
function format_xtree(searchStr,show){
	return __xTreeNamespace__.format_xtree(searchStr,show);
}

//@deprecated
function e8_before(){
	__xTreeNamespace__.e8_before();
}

function e8_before_xtree(){
	__xTreeNamespace__.e8_before_xtree();
}

//@deprecated
function e8_after(){
	__xTreeNamespace__.e8_after();
}

//@deprecated
function e8_after_xtree(){
	__xTreeNamespace__.e8_after_xtree();
}

//@deprecated
function e8_search_xtree(searchStr,notExpand){
	__xTreeNamespace__.e8_search_xtree(searchStr,notExpand);
}