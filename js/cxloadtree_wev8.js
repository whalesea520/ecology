/*----------------------------------------------------------------------------\
|modified by cyril on 2008-07-30
|replace deeptree.
|
|last modified by cyril on 2008-08-12
|for the parentNode extend.
\----------------------------------------------------------------------------*/

/*----------------------------------------------------------------------------\
|                               XLoadTree 1.11                                |
|-----------------------------------------------------------------------------|
|                         Created by Erik Arvidsson                           |
|                  (http://webfx.eae.net/contact.html#erik)                   |
|                      For WebFX (http://webfx.eae.net/)                      |
|-----------------------------------------------------------------------------|
| An extension to xTree that allows sub trees to be loaded at runtime by      |
| reading XML files from the server. Works with IE5+ and Mozilla 1.0+         |
|-----------------------------------------------------------------------------|
|             Copyright (c) 2001, 2002, 2003, 2006 Erik Arvidsson             |
|-----------------------------------------------------------------------------|
| Licensed under the Apache License, Version 2.0 (the "License"); you may not |
| use this file except in compliance with the License.  You may obtain a copy |
| of the License at http://www.apache.org/licenses/LICENSE-2.0                |
| - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - |
| Unless  required  by  applicable law or  agreed  to  in  writing,  software |
| distributed under the License is distributed on an  "AS IS" BASIS,  WITHOUT |
| WARRANTIES OR  CONDITIONS OF ANY KIND,  either express or implied.  See the |
| License  for the  specific language  governing permissions  and limitations |
| under the License.                                                          |
|-----------------------------------------------------------------------------|
| Dependencies: xtree_wev8.js     - original xtree library                         |
|               xtree_wev8.css    - simple css styling of xtree                    |
|               xmlextras_wev8.js - provides xml http objects and xml document     |
|                              objects                                        |
|-----------------------------------------------------------------------------|
| 2001-09-27 | Original Version Posted.                                       |
| 2002-01-19 | Added some simple error handling and string templates for      |
|            | reporting the errors.                                          |
| 2002-01-28 | Fixed loading issues in IE50 and IE55 that made the tree load  |
|            | twice.                                                         |
| 2002-10-10 | (1.1) Added reload method that reloads the XML file from the   |
|            | server.                                                        |
| 2003-05-06 | Added support for target attribute                             |
| 2006-05-28 | Changed license to Apache Software License 2.0.                |
|-----------------------------------------------------------------------------|
| Created 2001-09-27 | All changes are in the log above. | Updated 2006-05-28 |
\----------------------------------------------------------------------------*/

/* start by cyril */
var cxtree_id;
var cxtree_ids = new Array();
var cxtree_obj;
var cxtree_loaded;
var cxtree_IdArr = new Array();
function CXLoadTreeItem(sText, sXmlSrc, sAction, eParent, sIcon, sOpenIcon) {
	cxtree_loaded = false;
	cxtree_obj = null;
	cxtree_obj = new WebFXLoadTreeItem(sText, sXmlSrc, sAction, eParent, sIcon, sOpenIcon);
}

function tree_expand(node) {
	if(node==null) {
		node = cxtree_obj;
		if(cxtree_loaded)
			return;
		cxtree_loaded = true;
	}
	
	if(cxtree_ids.length == 0 && (cxtree_id != null || cxtree_id != '')){
		cxtree_ids[0] =  cxtree_id;
	}
	
	for(var i=0; i<node.childNodes.length; i++) {
		if(cxtree_id==null || cxtree_id=='') {
			if(window._fna_subjectBrowseDefExpanded==null || window._fna_subjectBrowseDefExpanded=="1"){
				node.childNodes[i].expand();
				return;
			}
		}
		if(cxtree_ids.Contains(cxtree_IdArr[node.childNodes[i].id])) {
			parent_expand(node.childNodes[i]);
			webFXTreeHandler.focus(document.getElementById(node.childNodes[i].id+'-anchor'));//set the focus.
		}
		if(node.childNodes[i].childNodes.length>0) {
			tree_expand(node.childNodes[i]);
		}
	}
}
Array.prototype.Contains=function(obj) 
{ 
   if(null==obj){return;} 
   for(var i=0,n=0;i<this.length;i++) 
   { 
    if(this[i]==obj) 
    { 
     return true; 
    } 
   } 
   return false; 
}
function parent_expand(node) {
	try {
		if(node.parentNode!=null) {
			//alert(node.text+'->'+node.parentNode.text);
			node.parentNode.expand();
			if(node.parentNode.parentNode!=null) {
				parent_expand(node.parentNode);
			}
		}
	}
	catch(e) {
		
	}
}
/* end by cyril */

webFXTreeConfig.loadingText = "Loading...";
webFXTreeConfig.loadErrorTextTemplate = "Error loading \"%1%\"";
webFXTreeConfig.emptyErrorTextTemplate = "Error \"%1%\" does not contain any tree items";

/*
 * WebFXLoadTree class
 */

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
	}else if(window._reload && !this.loading){
		this.reload();
		window._reload = false;
	}
	this._webfxtree_expand();
};

/*
 * WebFXLoadTreeItem class
 */

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
		this._loadingItem = new WebFXTreeItem(webFXTreeConfig.loadingText);
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
	}else if(window._reload && !this.loading){
		this.reload();
		window._reload = false;
	}
	this._webfxtreeitem_expand();
};

// reloads the src file if already loaded
WebFXLoadTree.prototype.reload =
WebFXLoadTreeItem.prototype.reload = function () {
	// if loading do nothing
	if (this.loaded) {
		var open = this.open;
		// remove
		while (this.childNodes.length > 0)
			this.childNodes[this.childNodes.length - 1].remove();

		this.loaded = false;

		this._loadingItem = new WebFXTreeItem(webFXTreeConfig.loadingText);
		this.add(this._loadingItem);

		if (true || open)
			this.expand();
	}else if (this.open && !this.loading) {
		_startLoadXmlTree(this.src, this);
	}
};

/*
 * Helper functions
 */

// creates the xmlhttp object and starts the load of the xml document
function _startLoadXmlTree(sSrc, jsNode) {
	if (jsNode.loading || jsNode.loaded)
		return;
	jsNode.loading = true;
	var xmlHttp = XmlHttp.create();
	sSrc = encodeURI(sSrc);
	xmlHttp.open("GET", sSrc, true);	// async
	xmlHttp.onreadystatechange = function () {
		if (xmlHttp.readyState == 4 && xmlHttp.status==200) {
			_xmlFileLoaded(xmlHttp.responseXML, jsNode);
			try {
				tree_expand();
				window.parent.focus();
			}
			catch(e) {}
		}
	};
	// call in new thread to allow ui to update
	window.setTimeout(function () {
		xmlHttp.send(null);
	}, 10);
}


// Converts an xml tree to a js tree. See article about xml tree format
function _xmlTreeToJsTree(oNode) {
	// retreive attributes
	var text = oNode.getAttribute("Title");
	var action = oNode.getAttribute("Href");
	var parent = null;
	var icon = oNode.getAttribute("Icon");
	var openIcon = oNode.getAttribute("Icon");
	var src = oNode.getAttribute("NodeXmlSrc");
	var target = oNode.getAttribute("Target");
	var _id = oNode.getAttribute("_id");
	// create jsNode
	var jsNode;
	if (src != null && src != "")
		jsNode = new WebFXLoadTreeItem(text, src, action, parent, icon, openIcon);
	else
		jsNode = new WebFXTreeItem(text, action, parent, icon, openIcon);

	if (target != "")
		jsNode.target = target;
	if(!!_id){
		jsNode._id = _id;
	}
	// by cyril
	cxtree_IdArr[jsNode.id] = oNode.getAttribute("NodeId");

	// go through childNOdes
	var cs = oNode.childNodes;
	var l = cs.length;
	//alert(l+'---'+text);
	for (var i = 0; i < l; i++) {
		if (cs[i].tagName == "TreeNode")
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
		//alert(oXmlDoc.xml);
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
			if (cs[i].tagName == "TreeNode") {
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
	window._treeLoaded = true;
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