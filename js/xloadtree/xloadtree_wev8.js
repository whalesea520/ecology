/*
 * This script was created by Erik Arvidsson (erik(at)eae.net)
 * for WebFX (http://webfx.eae.net)
 * Copyright 2001
 * 
 * For usage see license at http://webfx.eae.net/license.html	
 *
 * Version: 1.0
 * Created: 2001-09-27
 * Updated: 2002-01-19	Added some simple error handling and string templates
 *						for reporting the errors
 *			2002-01-28	Fixed loading issues in IE50 and IE55 that made the tree
 *						load twice
 *
 * Dependencies: xtree_wev8.js - original xtree library
 *               xtree_wev8.css - simple css styling of xtree
 *               xmlextras_wev8.js - provides xml http objects and xml document objects
 *
 *	Usage:
 *
 *    <script type="text/javascript" src="xmlextras_wev8.js"></script>
 *    <script type="text/javascript" src="xtree_wev8.js"></script>
 *    <script type="text/javascript" src="xloadtree_wev8.js"></script>
 *    <link type="text/css" rel="stylesheet" href="xtree_wev8.css" />
 *
 */

//<script>	Stupid InterDev

webFXTreeConfig.loadingText = "Loading...";
webFXTreeConfig.loadErrorTextTemplate = "";
webFXTreeConfig.emptyErrorTextTemplate = "";

function WebFXLoadTree(sText, sXmlSrc, sAction, sBehavior, sIcon, sOpenIcon) {
	// call super
	this.WebFXTree = WebFXTree;
	this.WebFXTree(sText, sAction, sBehavior, sIcon, sOpenIcon);
	
	// setup default property values
	this.src = sXmlSrc;
	this.loading = false;
	this.loaded = false;
	this.errorText = "";
	
	// check start state and load if open
	if (this.open)
		_startLoadXmlTree(this.src, this);
	else {
		// and create loading item if not
		this._loadingItem = new WebFXTreeItem(webFXTreeConfig.loadingText);
		this.add(this._loadingItem);
	}
}
WebFXLoadTree.prototype = new WebFXTree;

// override the expand method to load the xml file
WebFXLoadTree.prototype._webfxtree_expand = WebFXTree.prototype.expand;
WebFXLoadTree.prototype.expand = function() {
	if (!this.loaded && !this.loading) {
		// load
		_startLoadXmlTree(this.src, this);
	}
	this._webfxtree_expand();
};
 function WebFXLoadTreeItem(sText, sXmlSrc, sAction, eParent, sIcon, sOpenIcon) {
	// call super
	this.WebFXTreeItem = WebFXTreeItem;
	this.WebFXTreeItem(sText, sAction, eParent, sIcon, sOpenIcon);

	// setup default property values
	this.src = sXmlSrc;
	this.loading = false;
	this.loaded = false;
	this.errorText = "";
	
	// check start state and load if open
	if (this.open)
		_startLoadXmlTree(this.src, this);
	else {
		// and create loading item if not
		this._loadingItem = new WebFXTreeItem(webFXTreeConfig.loadingText,'','','/images/loading2_wev8.gif','/images/loading2_wev8.gif');
		this.add(this._loadingItem);
	}
}
WebFXLoadTreeItem.prototype = new WebFXTreeItem;

// override the expand method to load the xml file
WebFXLoadTreeItem.prototype._webfxtreeitem_expand = WebFXTreeItem.prototype.expand;
WebFXLoadTreeItem.prototype.expand = function() {
	if (!this.loaded && !this.loading) {
		// load
		_startLoadXmlTree(this.src, this);
	}
	this._webfxtreeitem_expand();
};
 // creates the xmlhttp object and starts the load of the xml document
function _startLoadXmlTree(sSrc, jsNode) {
	if (jsNode.loading || jsNode.loaded)
		return;
	jsNode.loading = true;
	var xmlHttp = XmlHttp.create();
	xmlHttp.open("GET", sSrc, true);	// async
	xmlHttp.onreadystatechange = function () {
		if (xmlHttp.readyState == 4)
			_xmlFileLoaded(xmlHttp.responseXML, jsNode);
	};
	// call in new thread to allow ui to update
	window.setTimeout(function () {
		xmlHttp.send(null);
	}, 10);
}


// Converts an xml tree to a js tree. See article about xml tree format
function _xmlTreeToJsTree(oNode) {
	// retreive attributes
	var text = oNode.getAttribute("text");
	var action = oNode.getAttribute("action");
	var parent = null;
	var icon = oNode.getAttribute("icon");
	var openIcon = oNode.getAttribute("openIcon");
	var src = oNode.getAttribute("src");
	
	// create jsNode
	var jsNode;
	if (src != null && src != "")
		jsNode = new WebFXLoadTreeItem(text, src, action, parent, icon, openIcon);
	else
		jsNode = new WebFXTreeItem(text, action, parent, icon, openIcon);
		
	// go through childNOdes
	var cs = oNode.childNodes;
	var l = cs.length;
	for (var i = 0; i < l; i++) {
		if (cs[i].tagName == "tree")
			jsNode.add( _xmlTreeToJsTree(cs[i]), true );
	}
	
	return jsNode;
}

// Inserts an xml document as a subtree to the provided node
function _xmlFileLoaded(oXmlDoc, jsParentNode) {
	if (jsParentNode.loaded)
		return;

	var bIndent = false;
	var bAnyChildren = false;
	jsParentNode.loaded = true;
	jsParentNode.loading = false;

	// check that the load of the xml file went well
	if( oXmlDoc == null || oXmlDoc.documentElement == null) {
		jsParentNode.errorText = parseTemplateString(webFXTreeConfig.loadErrorTextTemplate,
							jsParentNode.src);
	}
	else {
		// there is one extra level of tree elements
		var root = oXmlDoc.documentElement;

		// loop through all tree children
		var cs = root.childNodes;
		var l = cs.length;
		for (var i = 0; i < l; i++) {
			if (cs[i].tagName == "tree") {
				bAnyChildren = true;
				bIndent = true;
				jsParentNode.add( _xmlTreeToJsTree(cs[i]), true);
			}
		}

		// if no children we got an error
		if (!bAnyChildren)
			jsParentNode.errorText = parseTemplateString(webFXTreeConfig.emptyErrorTextTemplate,
										jsParentNode.src);
	}
	
	// remove dummy
	if (jsParentNode._loadingItem != null) {
		jsParentNode._loadingItem.remove();
		bIndent = true;
	}
	
	if (bIndent) {
		// indent now that all items are added
		jsParentNode.indent();
	}
	
	// show error in status bar
	if (jsParentNode.errorText != "")
		window.status = jsParentNode.errorText;
}

// parses a string and replaces %n% with argument nr n
function parseTemplateString(sTemplate) {
	var args = arguments;
	var s = sTemplate;
	
	s = s.replace(/\%\%/g, "%");
	
	for (var i = 1; i < args.length; i++)
		s = s.replace( new RegExp("\%" + i + "\%", "g"), args[i] )
	
	return s;
}
