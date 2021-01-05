
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<html>
<head>
<meta NAME="GENERATOR" CONTENT="Microsoft Visual Studio 6.0">
<title></title>

<!-- Styles -->
<link REL="stylesheet" TYPE="text/css" HREF="/css/toolbars_wev8.css">


<!-- Script Functions and Event Handlers -->
<script LANGUAGE="JavaScript" SRC="/js/dhtmled_wev8.js">
</script>


<!-- Script Object -->
<script LANGUAGE="JavaScript" SRC="/js/doc/dhtmlobj_wev8.js">
</script>

<script ID="clientEventHandlersJS" LANGUAGE="javascript">
<!--

//
// Constants
//
var MENU_SEPARATOR = ""; // Context menu separator

//
// Globals
//
var docimgnum = 0;
var docComplete = false;
var initialDocComplete = false;

var QueryStatusToolbarButtons = new Array();
var QueryStatusEditMenu = new Array();
var QueryStatusFormatMenu = new Array();
var QueryStatusHTMLMenu = new Array();
var QueryStatusTableMenu = new Array();
var QueryStatusZOrderMenu = new Array();
var ContextMenu = new Array();
var GeneralContextMenu = new Array();
var TableContextMenu = new Array();
var AbsPosContextMenu = new Array();

//
// Utility functions
//

// Constructor for custom object that represents an item on the context menu
function ContextMenuItem(string, cmdId) {
  this.string = string;
  this.cmdId = cmdId;
}

// Constructor for custom object that represents a QueryStatus command and 
// corresponding toolbar element.
function QueryStatusItem(command, element) {
  this.command = command;
  this.element = element;
}

//
// Event handlers
//
function window_onload() {
	try{
  // Initialze QueryStatus tables. These tables associate a command id with the
  // corresponding button object. Must be done on window load, 'cause the buttons must exist.
  QueryStatusToolbarButtons[0] = new QueryStatusItem(DECMD_BOLD, document.body.all["DECMD_BOLD"]);
  QueryStatusToolbarButtons[1] = new QueryStatusItem(DECMD_COPY, document.body.all["DECMD_COPY"]);
  QueryStatusToolbarButtons[2] = new QueryStatusItem(DECMD_CUT, document.body.all["DECMD_CUT"]);
  QueryStatusToolbarButtons[3] = new QueryStatusItem(DECMD_HYPERLINK, document.body.all["DECMD_HYPERLINK"]);
  QueryStatusToolbarButtons[4] = new QueryStatusItem(DECMD_INDENT, document.body.all["DECMD_INDENT"]);
  QueryStatusToolbarButtons[5] = new QueryStatusItem(DECMD_ITALIC, document.body.all["DECMD_ITALIC"]);
  QueryStatusToolbarButtons[6] = new QueryStatusItem(DECMD_JUSTIFYLEFT, document.body.all["DECMD_JUSTIFYLEFT"]);
  QueryStatusToolbarButtons[7] = new QueryStatusItem(DECMD_JUSTIFYCENTER, document.body.all["DECMD_JUSTIFYCENTER"]);
  QueryStatusToolbarButtons[8] = new QueryStatusItem(DECMD_JUSTIFYRIGHT, document.body.all["DECMD_JUSTIFYRIGHT"]);
  QueryStatusToolbarButtons[9] = new QueryStatusItem(DECMD_LOCK_ELEMENT, document.body.all["DECMD_LOCK_ELEMENT"]);
  QueryStatusToolbarButtons[10] = new QueryStatusItem(DECMD_MAKE_ABSOLUTE, document.body.all["DECMD_MAKE_ABSOLUTE"]);
  QueryStatusToolbarButtons[11] = new QueryStatusItem(DECMD_ORDERLIST, document.body.all["DECMD_ORDERLIST"]);
  QueryStatusToolbarButtons[12] = new QueryStatusItem(DECMD_OUTDENT, document.body.all["DECMD_OUTDENT"]);
  QueryStatusToolbarButtons[13] = new QueryStatusItem(DECMD_PASTE, document.body.all["DECMD_PASTE"]);
  QueryStatusToolbarButtons[14] = new QueryStatusItem(DECMD_REDO, document.body.all["DECMD_REDO"]);
  QueryStatusToolbarButtons[15] = new QueryStatusItem(DECMD_UNDERLINE, document.body.all["DECMD_UNDERLINE"]);
  QueryStatusToolbarButtons[16] = new QueryStatusItem(DECMD_UNDO, document.body.all["DECMD_UNDO"]);
  QueryStatusToolbarButtons[17] = new QueryStatusItem(DECMD_UNORDERLIST, document.body.all["DECMD_UNORDERLIST"]);
  QueryStatusToolbarButtons[18] = new QueryStatusItem(DECMD_INSERTTABLE, document.body.all["DECMD_INSERTTABLE"]);
  QueryStatusToolbarButtons[19] = new QueryStatusItem(DECMD_INSERTROW, document.body.all["DECMD_INSERTROW"]);
  QueryStatusToolbarButtons[20] = new QueryStatusItem(DECMD_DELETEROWS, document.body.all["DECMD_DELETEROWS"]);
  QueryStatusToolbarButtons[21] = new QueryStatusItem(DECMD_INSERTCOL, document.body.all["DECMD_INSERTCOL"]);
  QueryStatusToolbarButtons[22] = new QueryStatusItem(DECMD_DELETECOLS, document.body.all["DECMD_DELETECOLS"]);
  QueryStatusToolbarButtons[23] = new QueryStatusItem(DECMD_INSERTCELL, document.body.all["DECMD_INSERTCELL"]);
  QueryStatusToolbarButtons[24] = new QueryStatusItem(DECMD_DELETECELLS, document.body.all["DECMD_DELETECELLS"]);
  QueryStatusToolbarButtons[25] = new QueryStatusItem(DECMD_MERGECELLS, document.body.all["DECMD_MERGECELLS"]);
  QueryStatusToolbarButtons[26] = new QueryStatusItem(DECMD_SPLITCELL, document.body.all["DECMD_SPLITCELL"]);
  QueryStatusToolbarButtons[27] = new QueryStatusItem(DECMD_SETFORECOLOR, document.body.all["DECMD_SETFORECOLOR"]);
  QueryStatusToolbarButtons[28] = new QueryStatusItem(DECMD_SETBACKCOLOR, document.body.all["DECMD_SETBACKCOLOR"]);
  QueryStatusEditMenu[0] = new QueryStatusItem(DECMD_UNDO, document.body.all["EDIT_UNDO"]);
  QueryStatusEditMenu[1] = new QueryStatusItem(DECMD_REDO, document.body.all["EDIT_REDO"]);
  QueryStatusEditMenu[2] = new QueryStatusItem(DECMD_CUT, document.body.all["EDIT_CUT"]);
  QueryStatusEditMenu[3] = new QueryStatusItem(DECMD_COPY, document.body.all["EDIT_COPY"]);
  QueryStatusEditMenu[4] = new QueryStatusItem(DECMD_PASTE, document.body.all["EDIT_PASTE"]);
  QueryStatusEditMenu[5] = new QueryStatusItem(DECMD_DELETE, document.body.all["EDIT_DELETE"]);
  QueryStatusHTMLMenu[0] = new QueryStatusItem(DECMD_HYPERLINK, document.body.all["HTML_HYPERLINK"]);
  QueryStatusHTMLMenu[1] = new QueryStatusItem(DECMD_IMAGE, document.body.all["HTML_IMAGE"]);
  QueryStatusFormatMenu[0] = new QueryStatusItem(DECMD_FONT, document.body.all["FORMAT_FONT"]);
  QueryStatusFormatMenu[1] = new QueryStatusItem(DECMD_BOLD, document.body.all["FORMAT_BOLD"]);
  QueryStatusFormatMenu[2] = new QueryStatusItem(DECMD_ITALIC, document.body.all["FORMAT_ITALIC"]);
  QueryStatusFormatMenu[3] = new QueryStatusItem(DECMD_UNDERLINE, document.body.all["FORMAT_UNDERLINE"]);
  QueryStatusFormatMenu[4] = new QueryStatusItem(DECMD_JUSTIFYLEFT, document.body.all["FORMAT_JUSTIFYLEFT"]);
  QueryStatusFormatMenu[5] = new QueryStatusItem(DECMD_JUSTIFYCENTER, document.body.all["FORMAT_JUSTIFYCENTER"]);
  QueryStatusFormatMenu[6] = new QueryStatusItem(DECMD_JUSTIFYRIGHT, document.body.all["FORMAT_JUSTIFYRIGHT"]);
  QueryStatusFormatMenu[7] = new QueryStatusItem(DECMD_SETFORECOLOR, document.body.all["FORMAT_SETFORECOLOR"]);
  QueryStatusFormatMenu[8] = new QueryStatusItem(DECMD_SETBACKCOLOR, document.body.all["FORMAT_SETBACKCOLOR"]);
  QueryStatusTableMenu[0] = new QueryStatusItem(DECMD_INSERTTABLE, document.body.all["TABLE_INSERTTABLE"]);
  QueryStatusTableMenu[1] = new QueryStatusItem(DECMD_INSERTROW, document.body.all["TABLE_INSERTROW"]);
  QueryStatusTableMenu[2] = new QueryStatusItem(DECMD_DELETEROWS, document.body.all["TABLE_DELETEROW"]);
  QueryStatusTableMenu[3] = new QueryStatusItem(DECMD_INSERTCOL, document.body.all["TABLE_INSERTCOL"]);
  QueryStatusTableMenu[4] = new QueryStatusItem(DECMD_DELETECOLS, document.body.all["TABLE_DELETECOL"]);
  QueryStatusTableMenu[5] = new QueryStatusItem(DECMD_INSERTCELL, document.body.all["TABLE_INSERTCELL"]);
  QueryStatusTableMenu[6] = new QueryStatusItem(DECMD_DELETECELLS, document.body.all["TABLE_DELETECELL"]);
  QueryStatusTableMenu[7] = new QueryStatusItem(DECMD_MERGECELLS, document.body.all["TABLE_MERGECELL"]);
  QueryStatusTableMenu[8] = new QueryStatusItem(DECMD_SPLITCELL, document.body.all["TABLE_SPLITCELL"]);
  QueryStatusZOrderMenu[0] = new QueryStatusItem(DECMD_SEND_TO_BACK, document.body.all["ZORDER_SENDBACK"]);
  QueryStatusZOrderMenu[1] = new QueryStatusItem(DECMD_BRING_TO_FRONT, document.body.all["ZORDER_BRINGFRONT"]);
  QueryStatusZOrderMenu[2] = new QueryStatusItem(DECMD_SEND_BACKWARD, document.body.all["ZORDER_SENDBACKWARD"]);
  QueryStatusZOrderMenu[3] = new QueryStatusItem(DECMD_BRING_FORWARD, document.body.all["ZORDER_BRINGFORWARD"]);
  QueryStatusZOrderMenu[4] = new QueryStatusItem(DECMD_SEND_BELOW_TEXT, document.body.all["ZORDER_BELOWTEXT"]);
  QueryStatusZOrderMenu[5] = new QueryStatusItem(DECMD_BRING_ABOVE_TEXT, document.body.all["ZORDER_ABOVETEXT"]);
  
  // Initialize the context menu arrays.
  GeneralContextMenu[0] = new ContextMenuItem("<%=SystemEnv.getHtmlLabelName(16179,user.getLanguage())%>", DECMD_CUT);
  GeneralContextMenu[1] = new ContextMenuItem("<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%>", DECMD_COPY);
  GeneralContextMenu[2] = new ContextMenuItem("<%=SystemEnv.getHtmlLabelName(16180,user.getLanguage())%>", DECMD_PASTE);
  GeneralContextMenu[3] = new ContextMenuItem("<%=SystemEnv.getHtmlLabelName(16181,user.getLanguage())%>", DECMD_INSERTTABLE);
 // GeneralContextMenu[4] = new ContextMenuItem("插入图像", DECMD_IMAGE);
  
  TableContextMenu[0] = new ContextMenuItem(MENU_SEPARATOR, 0);
  TableContextMenu[1] = new ContextMenuItem("<%=SystemEnv.getHtmlLabelName(1988,user.getLanguage())%>", DECMD_INSERTROW);
  TableContextMenu[2] = new ContextMenuItem("<%=SystemEnv.getHtmlLabelName(16182,user.getLanguage())%>", DECMD_DELETEROWS);
  TableContextMenu[3] = new ContextMenuItem(MENU_SEPARATOR, 0);
  TableContextMenu[4] = new ContextMenuItem("<%=SystemEnv.getHtmlLabelName(1989,user.getLanguage())%>", DECMD_INSERTCOL);
  TableContextMenu[5] = new ContextMenuItem("<%=SystemEnv.getHtmlLabelName(16183,user.getLanguage())%>", DECMD_DELETECOLS);
  TableContextMenu[6] = new ContextMenuItem(MENU_SEPARATOR, 0);
  TableContextMenu[7] = new ContextMenuItem("<%=SystemEnv.getHtmlLabelName(16184,user.getLanguage())%>", DECMD_INSERTCELL);
  TableContextMenu[8] = new ContextMenuItem("<%=SystemEnv.getHtmlLabelName(16185,user.getLanguage())%>", DECMD_DELETECELLS);
  TableContextMenu[9] = new ContextMenuItem("<%=SystemEnv.getHtmlLabelName(16186,user.getLanguage())%>", DECMD_MERGECELLS);
  TableContextMenu[10] = new ContextMenuItem("<%=SystemEnv.getHtmlLabelName(16187,user.getLanguage())%>", DECMD_SPLITCELL);
  AbsPosContextMenu[0] = new ContextMenuItem(MENU_SEPARATOR, 0);
  AbsPosContextMenu[1] = new ContextMenuItem("Send To Back", DECMD_SEND_TO_BACK);
  AbsPosContextMenu[2] = new ContextMenuItem("Bring To Front", DECMD_BRING_TO_FRONT);
  AbsPosContextMenu[3] = new ContextMenuItem(MENU_SEPARATOR, 0);
  AbsPosContextMenu[4] = new ContextMenuItem("Send Backward", DECMD_SEND_BACKWARD);
  AbsPosContextMenu[5] = new ContextMenuItem("Bring Forward", DECMD_BRING_FORWARD);
  AbsPosContextMenu[6] = new ContextMenuItem(MENU_SEPARATOR, 0);
  AbsPosContextMenu[7] = new ContextMenuItem("Send Below Text", DECMD_SEND_BELOW_TEXT);
  AbsPosContextMenu[8] = new ContextMenuItem("Bring Above Text", DECMD_BRING_ABOVE_TEXT);

  document.getElementById("FontName").value="<%=SystemEnv.getHtmlLabelName(16190,user.getLanguage())%>";
  tbContentElement.ExecCommand(DECMD_SETFONTNAME, OLECMDEXECOPT_DODEFAULT,"<%=SystemEnv.getHtmlLabelName(16190,user.getLanguage())%>");
} catch(e) {
}
}

function InsertTable() {
  var pVar = ObjTableInfo;
  var args = new Array();
  var arr = null;
     
  // Display table information dialog
  args["NumRows"] = ObjTableInfo.NumRows;
  args["NumCols"] = ObjTableInfo.NumCols;
  args["TableAttrs"] = ObjTableInfo.TableAttrs;
  args["CellAttrs"] = ObjTableInfo.CellAttrs;
  args["Caption"] = ObjTableInfo.Caption;
  
  arr = null;
    
  arr = showModalDialog( "instable.jsp",
                             args,
                             "font-family:Verdana; font-size:12; dialogWidth:36em; dialogHeight:25em");
  if (arr != null) {
  
    // Initialize table object
    for ( elem in arr ) {
      if ("NumRows" == elem && arr["NumRows"] != null) {
        ObjTableInfo.NumRows = arr["NumRows"];
      } else if ("NumCols" == elem && arr["NumCols"] != null) {
        ObjTableInfo.NumCols = arr["NumCols"];
      } else if ("TableAttrs" == elem) {
        ObjTableInfo.TableAttrs = arr["TableAttrs"];
      } else if ("CellAttrs" == elem) {
        ObjTableInfo.CellAttrs = arr["CellAttrs"];
      } else if ("Caption" == elem) {
        ObjTableInfo.Caption = arr["Caption"];
      }
    }
    
    tbContentElement.ExecCommand(DECMD_INSERTTABLE,OLECMDEXECOPT_DODEFAULT, pVar);  
  }
}

function tbContentElement_ShowContextMenu() {
  var menuStrings = new Array();
  var menuStates = new Array();
  var state;
  var i
  var idx = 0;

  // Rebuild the context menu. 
  ContextMenu.length = 0;

  // Always show general menu
  for (i=0; i<GeneralContextMenu.length; i++) {
    ContextMenu[idx++] = GeneralContextMenu[i];
  }

  // Is the selection inside a table? Add table menu if so
  if (tbContentElement.QueryStatus(DECMD_INSERTROW) != DECMDF_DISABLED) {
    for (i=0; i<TableContextMenu.length; i++) {
      ContextMenu[idx++] = TableContextMenu[i];
    }
  }

  // Is the selection on an absolutely positioned element? Add z-index commands if so
  if (tbContentElement.QueryStatus(DECMD_LOCK_ELEMENT) != DECMDF_DISABLED) {
    for (i=0; i<AbsPosContextMenu.length; i++) {
      ContextMenu[idx++] = AbsPosContextMenu[i];
    }
  }

  // Set up the actual arrays that get passed to SetContextMenu
  for (i=0; i<ContextMenu.length; i++) {
    menuStrings[i] = ContextMenu[i].string;
    if (menuStrings[i] != MENU_SEPARATOR) {
      state = tbContentElement.QueryStatus(ContextMenu[i].cmdId);
    } else {
      state = DECMDF_ENABLED;
    }
    if (state == DECMDF_DISABLED || state == DECMDF_NOTSUPPORTED) {
      menuStates[i] = OLE_TRISTATE_GRAY;
    } else if (state == DECMDF_ENABLED || state == DECMDF_NINCHED) {
      menuStates[i] = OLE_TRISTATE_UNCHECKED;
    } else { // DECMDF_LATCHED
      menuStates[i] = OLE_TRISTATE_CHECKED;
    }
  }
  
  // Set the context menu
  tbContentElement.SetContextMenu(menuStrings, menuStates);
}

function tbContentElement_ContextMenuAction(itemIndex) {
  
  if (ContextMenu[itemIndex].cmdId == DECMD_INSERTTABLE) {
    InsertTable();
  } else {
    tbContentElement.ExecCommand(ContextMenu[itemIndex].cmdId, OLECMDEXECOPT_DODEFAULT);
  }
}

// DisplayChanged handler. Very time-critical routine; this is called
// every time a character is typed. QueryStatus those toolbar buttons that need
// to be in synch with the current state of the document and update. 
function tbContentElement_DisplayChanged() {
  var i, s;
		 
  for (i=0; i<QueryStatusToolbarButtons.length; i++) {
	s = tbContentElement.QueryStatus(QueryStatusToolbarButtons[i].command);
	if (s == DECMDF_DISABLED || s == DECMDF_NOTSUPPORTED) {
      TBSetState(QueryStatusToolbarButtons[i].element, "gray"); 
    } else if (s == DECMDF_ENABLED  || s == DECMDF_NINCHED) {
       TBSetState(QueryStatusToolbarButtons[i].element, "unchecked"); 
    } else { // DECMDF_LATCHED
       TBSetState(QueryStatusToolbarButtons[i].element, "checked");
    }
  }

//  s = tbContentElement.QueryStatus(DECMD_GETBLOCKFMT);
//  if (s == DECMDF_DISABLED || s == DECMDF_NOTSUPPORTED) {
//	ParagraphStyle.disabled = true;
//  } else {
//	ParagraphStyle.disabled = false;
 //   ParagraphStyle.value = tbContentElement.ExecCommand(DECMD_GETBLOCKFMT, OLECMDEXECOPT_DODEFAULT);
//  }
  s = tbContentElement.QueryStatus(DECMD_GETFONTNAME);
  if (s == DECMDF_DISABLED || s == DECMDF_NOTSUPPORTED) {
	FontName.disabled = true;
  } else {
	FontName.disabled = false;
    FontName.value = tbContentElement.ExecCommand(DECMD_GETFONTNAME, OLECMDEXECOPT_DODEFAULT);
  }
  if (s == DECMDF_DISABLED || s == DECMDF_NOTSUPPORTED) {
	FontSize.disabled = true;
  } else {
	FontSize.disabled = false;
    FontSize.value = tbContentElement.ExecCommand(DECMD_GETFONTSIZE, OLECMDEXECOPT_DODEFAULT);
  }
}

function tbContentElement_DocumentComplete() {

    if (initialDocComplete) {
	    if (tbContentElement.CurrentDocumentPath == "") {
   //     URL_VALUE.value = "http://";
    }
    else {
  //    URL_VALUE.value = tbContentElement.CurrentDocumentPath;
    }
  }

  initialDocComplete = true;
  docComplete = true;
}

function MENU_FILE_OPEN_onclick() {
  /**
    NOTE: The user is not prompted to save the the current 
    document before the call to LoadDocument. Therefore the
    user will lose any edits he has made to the current document
    after the call to LoadDocument. The purpose of the sample is
    to provide a basic demonstration of how to use the DHTMLEdit 
    control. A complete implementation would check if there were
    unsaved edits to the current document by testing the IsDirty
    property on the control. If the IsDirty property is true, the
    user should be given an opporunity to save his edits first.

    See the implementation of MENU_FILE_NEW_onclick() in this sample
    for a demonstration how to do this.
  **/

  docComplete = false;
  tbContentElement.LoadDocument("", true);
  tbContentElement.focus();
}

function MENU_FILE_SAVE_onclick() {

  if (tbContentElement.CurrentDocumentPath != "") {
    var path;
      
    path = tbContentElement.CurrentDocumentPath;

    if (path.substring(0, 7) == "http://" || path.substring(0, 7) == "file://")
      tbContentElement.SaveDocument("", true);
    else
      tbContentElement.SaveDocument(tbContentElement.CurrentDocumentPath, false);
  }
  else {
    tbContentElement.SaveDocument("", true);
  }

 // URL_VALUE.value = tbContentElement.CurrentDocumentPath;

//  // tbContentElement.focus();
}

function MENU_FILE_SAVEAS_onclick() {
  tbContentElement.SaveDocument("", true);
//  // tbContentElement.focus();
}

function DECMD_VISIBLEBORDERS_onclick() {
  tbContentElement.ShowBorders = !tbContentElement.ShowBorders;
//  // tbContentElement.focus();
}

function DECMD_UNORDERLIST_onclick() {
  tbContentElement.ExecCommand(DECMD_UNORDERLIST,OLECMDEXECOPT_DODEFAULT);
//  // tbContentElement.focus();
}

function DECMD_UNDO_onclick() {
  tbContentElement.ExecCommand(DECMD_UNDO,OLECMDEXECOPT_DODEFAULT);
//  // tbContentElement.focus();
}

function DECMD_UNDERLINE_onclick() {
  tbContentElement.ExecCommand(DECMD_UNDERLINE,OLECMDEXECOPT_DODEFAULT);
//  // tbContentElement.focus();
}

function DECMD_SNAPTOGRID_onclick() {
  tbContentElement.SnapToGrid = !tbContentElement.SnapToGrid;
//  // tbContentElement.focus();
}

function DECMD_SHOWDETAILS_onclick() {
  tbContentElement.ShowDetails = !tbContentElement.ShowDetails;
//  // tbContentElement.focus();
}

function DECMD_SETFORECOLOR_onclick() {
  var arr = showModalDialog( "selcolor.jsp",
                             "",
                             "font-family:Verdana; font-size:12; dialogWidth:30em; dialogHeight:30em" );

  if (arr != null) {
    tbContentElement.ExecCommand(DECMD_SETFORECOLOR,OLECMDEXECOPT_DODEFAULT, arr);
  }
}

function DECMD_SETBACKCOLOR_onclick() {
  var arr = showModalDialog( "selcolor.jsp",
                             "",
                             "font-family:Verdana; font-size:12; dialogWidth:30em; dialogHeight:30em" );

  if (arr != null) {
    tbContentElement.ExecCommand(DECMD_SETBACKCOLOR,OLECMDEXECOPT_DODEFAULT, arr);
  }
//  // tbContentElement.focus();
}

function DECMD_SELECTALL_onclick() {
  tbContentElement.ExecCommand(DECMD_SELECTALL,OLECMDEXECOPT_DODEFAULT);
//  // tbContentElement.focus();
}

function DECMD_REDO_onclick() {
  tbContentElement.ExecCommand(DECMD_REDO,OLECMDEXECOPT_DODEFAULT);
//  // tbContentElement.focus();
}

function DECMD_PASTE_onclick() {
  tbContentElement.ExecCommand(DECMD_PASTE,OLECMDEXECOPT_DODEFAULT);
//  // tbContentElement.focus();
}

function DECMD_OUTDENT_onclick() {
  tbContentElement.ExecCommand(DECMD_OUTDENT,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function DECMD_ORDERLIST_onclick() {
  tbContentElement.ExecCommand(DECMD_ORDERLIST,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function DECMD_MAKE_ABSOLUTE_onclick() {
  tbContentElement.ExecCommand(DECMD_MAKE_ABSOLUTE,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function DECMD_LOCK_ELEMENT_onclick() {
  tbContentElement.ExecCommand(DECMD_LOCK_ELEMENT,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function DECMD_JUSTIFYRIGHT_onclick() {
  tbContentElement.ExecCommand(DECMD_JUSTIFYRIGHT,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function DECMD_JUSTIFYLEFT_onclick() {
  tbContentElement.ExecCommand(DECMD_JUSTIFYLEFT,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function DECMD_JUSTIFYCENTER_onclick() {
  tbContentElement.ExecCommand(DECMD_JUSTIFYCENTER,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function DECMD_ITALIC_onclick() {
  tbContentElement.ExecCommand(DECMD_ITALIC,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function DECMD_INDENT_onclick() {
  tbContentElement.ExecCommand(DECMD_INDENT,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function DECMD_IMAGE_onclick() {
//  tbContentElement.ExecCommand(DECMD_IMAGE,OLECMDEXECOPT_PROMPTUSER);
  
 imgpath = window.parent.document.all("docimages_"+docimgnum).value;

 if(imgpath==""){
 	alert("<%=SystemEnv.getHtmlLabelName(16188,user.getLanguage())%>");
 }else{
 //插入图片
 	
	   var pVar = ObjTableInfo;
	   var args = new Array();
	 
	     
	  // Display table information dialog
	  args["NumRows"] = ObjTableInfo.NumRows;
	  args["NumCols"] = ObjTableInfo.NumCols;
	  args["TableAttrs"] = ObjTableInfo.TableAttrs;
	  args["CellAttrs"] = ObjTableInfo.CellAttrs;
	  args["Caption"] = ObjTableInfo.Caption;
	 
	ObjTableInfo.NumRows = "0";
	ObjTableInfo.NumCols = "0";
	 ObjTableInfo.TableAttrs = " border=0 cellPadding=0 cellSpacing=0 width=100% ";
	ObjTableInfo.Caption = "<img alt=docimages_"+docimgnum+" src=\""+imgpath+"\">";

	tbContentElement.ExecCommand(DECMD_INSERTTABLE,OLECMDEXECOPT_DODEFAULT, pVar);  
	 oldcontent = tbContentElement.DocumentHTML;
	 tmppos = oldcontent.indexOf(imgpath);
	 startpos = oldcontent.lastIndexOf("<TABLE ",tmppos);
	 endpos = oldcontent.indexOf("</TABLE>",tmppos);	 
	   tmpstr = oldcontent.substring(startpos,endpos+8);
	   oldcontent=oldcontent.replace(tmpstr,"<IMG alt=docimages_"+docimgnum+" src=\""+imgpath+"\">");
	  tbContentElement.DocumentHTML = oldcontent;
	  // tbContentElement.focus();
//生成新的插入图片按钮
	window.parent.document.all("docimages_"+docimgnum).style.display='none';
	docimgnum++;
	var oDiv = window.parent.document.createElement("div");
	var sHtml = "<input class=InputStyle type='file' size='60' name='docimages_"+docimgnum+"' >";
	oDiv.innerHTML = sHtml;    
	window.parent.document.all("divimg").appendChild(oDiv); 
	
//恢复ObjTableInfo对象属性
	   ObjTableInfo.NumRows = args["NumRows"];
	  ObjTableInfo.NumCols=args["NumCols"] ;
	  ObjTableInfo.TableAttrs=args["TableAttrs"];
	  ObjTableInfo.CellAttrs=args["CellAttrs"] ;
	  ObjTableInfo.Caption=args["Caption"] ;
//重置docimages_num的值
	window.parent.document.all("docimages_num").value=docimgnum
 }
}

function DECMD_HYPERLINK_onclick() {
  tbContentElement.ExecCommand(DECMD_HYPERLINK,OLECMDEXECOPT_PROMPTUSER);
  // tbContentElement.focus();
}

function DECMD_FINDTEXT_onclick() {
  tbContentElement.ExecCommand(DECMD_FINDTEXT,OLECMDEXECOPT_PROMPTUSER);
  // tbContentElement.focus();
}

function DECMD_DELETE_onclick() {
  tbContentElement.ExecCommand(DECMD_DELETE,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function DECMD_CUT_onclick() {
  tbContentElement.ExecCommand(DECMD_CUT,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function DECMD_COPY_onclick() {
  tbContentElement.ExecCommand(DECMD_COPY,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function DECMD_BOLD_onclick() {
  tbContentElement.ExecCommand(DECMD_BOLD,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function OnMenuShow(QueryStatusArray) {
  var i, s;
 
  for (i=0; i<QueryStatusArray.length; i++) {
  s = tbContentElement.QueryStatus(QueryStatusArray[i].command);
  if (s == DECMDF_DISABLED || s == DECMDF_NOTSUPPORTED) {
      TBSetState(QueryStatusArray[i].element, "gray"); 
    } else if (s == DECMDF_ENABLED  || s == DECMDF_NINCHED) {
       TBSetState(QueryStatusArray[i].element, "unchecked"); 
    } else { // DECMDF_LATCHED
       TBSetState(QueryStatusArray[i].element, "checked");
    }
  }
  // tbContentElement.focus();
}

function INTRINSICS_onclick(html) {
  var selection;
  
  selection = tbContentElement.DOM.selection.createRange();
  selection.pasteHTML(html);
  // tbContentElement.focus();
}

function TABLE_DELETECELL_onclick() {
  tbContentElement.ExecCommand(DECMD_DELETECELLS,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function TABLE_DELETECOL_onclick() {
  tbContentElement.ExecCommand(DECMD_DELETECOLS,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function TABLE_DELETEROW_onclick() {
  tbContentElement.ExecCommand(DECMD_DELETEROWS,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function TABLE_INSERTCELL_onclick() {
  tbContentElement.ExecCommand(DECMD_INSERTCELL,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function TABLE_INSERTCOL_onclick() {
  tbContentElement.ExecCommand(DECMD_INSERTCOL,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function TABLE_INSERTROW_onclick() {
  tbContentElement.ExecCommand(DECMD_INSERTROW,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function TABLE_INSERTTABLE_onclick() {
  InsertTable();
  // tbContentElement.focus();
}

function TABLE_MERGECELL_onclick() {
  tbContentElement.ExecCommand(DECMD_MERGECELLS,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function TABLE_SPLITCELL_onclick() {
  tbContentElement.ExecCommand(DECMD_SPLITCELL,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function FORMAT_FONT_onclick() {
  tbContentElement.ExecCommand(DECMD_FONT,OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function MENU_FILE_NEW_onclick() {
  if (tbContentElement.IsDirty) {
    if (confirm("Save changes?")) {
      MENU_FILE_SAVE_onclick();
    }
  }
//    URL_VALUE.value = "http://";
  tbContentElement.NewDocument();
  // tbContentElement.focus();
}

function URL_VALUE_onkeypress() {
  if (event.keyCode == 13) {

  /**
    NOTE: The user is not prompted to save the the current 
    document before the call to LoadURL. Therefore the
    user will lose any edits he has made to the current document
    after the call to LoadURL. The purpose of the sample is
    to provide a basic demonstration of how to use the DHTMLEdit 
    control. A complete implementation would check if there were
    unsaved edits to the current document by testing the IsDirty
    property on the control. If the IsDirty property is true, the
    user should be given an opporunity to save his edits first.

    See the implementation of MENU_FILE_NEW_onclick() in this sample
    for a demonstration how to do this.
  **/

    docComplete = false;
    tbContentElement.LoadURL(URL_VALUE.value);
    // tbContentElement.focus();
  }
}

function ZORDER_ABOVETEXT_onclick() {
  tbContentElement.ExecCommand(DECMD_BRING_ABOVE_TEXT, OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function ZORDER_BELOWTEXT_onclick() {
  tbContentElement.ExecCommand(DECMD_SEND_BELOW_TEXT, OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function ZORDER_BRINGFORWARD_onclick() {
  tbContentElement.ExecCommand(DECMD_BRING_FORWARD, OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function ZORDER_BRINGFRONT_onclick() {
  tbContentElement.ExecCommand(DECMD_BRING_TO_FRONT, OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function ZORDER_SENDBACK_onclick() {
  tbContentElement.ExecCommand(DECMD_SEND_TO_BACK, OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function ZORDER_SENDBACKWARD_onclick() {
  tbContentElement.ExecCommand(DECMD_SEND_BACKWARD, OLECMDEXECOPT_DODEFAULT);
  // tbContentElement.focus();
}

function TOOLBARS_onclick(toolbar) {
  if (toolbar.TBSTATE == "hidden") {
    TBSetState(toolbar, "dockedTop");
  } else {
    TBSetState(toolbar, "hidden");
  }
  // tbContentElement.focus();
}

function ParagraphStyle_onchange() {	 
  tbContentElement.ExecCommand(DECMD_SETBLOCKFMT, OLECMDEXECOPT_DODEFAULT, ParagraphStyle.value);
  // tbContentElement.focus();
}

function FontName_onchange() {
  tbContentElement.ExecCommand(DECMD_SETFONTNAME, OLECMDEXECOPT_DODEFAULT, FontName.value);
  // tbContentElement.focus();
}

function FontSize_onchange() {
  tbContentElement.ExecCommand(DECMD_SETFONTSIZE, OLECMDEXECOPT_DODEFAULT, parseInt(FontSize.value));
  // tbContentElement.focus();
}

//-->
</script>

<script LANGUAGE="javascript" FOR="tbContentElement" EVENT="DisplayChanged">
<!--
return tbContentElement_DisplayChanged()
//-->
</script>

<script LANGUAGE="javascript" FOR="tbContentElement" EVENT="DocumentComplete">
<!--
return tbContentElement_DocumentComplete()
//--> 
</script>

<script LANGUAGE="javascript" FOR="tbContentElement" EVENT="ShowContextMenu">
<!--
return tbContentElement_ShowContextMenu()
//-->
</script>

<script LANGUAGE="javascript" FOR="tbContentElement" EVENT="ContextMenuAction(itemIndex)">
<!--
return tbContentElement_ContextMenuAction(itemIndex)
//-->
</script>

</head>
<body LANGUAGE="javascript" onload="return window_onload()">

<!-- Toolbars -->
<div class="tbToolbar" ID="FormatToolbar">
<!--  <select ID="ParagraphStyle" class="tbGeneral" style="width:90" TITLE="样式" LANGUAGE="javascript" onchange="return ParagraphStyle_onchange()">
    <option value="Normal">正文
    <option value="Heading 1">标题 1
    <option value="Heading 2">标题 2
    <option value="Heading 3">标题 3
    <option value="Heading 4">标题 4
    <option value="Heading 5">标题 5
    <option value="Heading 6">标题 6
    <option value="Address">地址
    <option value="Formatted">已编排格式
  </select>
-->  <select ID="FontName" class="tbGeneral" style="width:140" TITLE="<%=SystemEnv.getHtmlLabelName(16189,user.getLanguage())%>" LANGUAGE="javascript" onchange="return FontName_onchange()">
    <option value="Arial">Arial
    <option value="Tahoma">Tahoma
    <option value="Courier New">Courier New
    <option value="Times New Roman">Times New Roman
    <option value="Wingdings">Wingdings
    <option value="<%=SystemEnv.getHtmlLabelName(16190,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(16190,user.getLanguage())%>
    <option value="<%=SystemEnv.getHtmlLabelName(16191,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(16191,user.getLanguage())%>
    <option value="<%=SystemEnv.getHtmlLabelName(16192,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(16192,user.getLanguage())%>
    <option value="<%=SystemEnv.getHtmlLabelName(16193,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(16193,user.getLanguage())%>
    <option value="<%=SystemEnv.getHtmlLabelName(16194,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(16194,user.getLanguage())%>
    <option value="<%=SystemEnv.getHtmlLabelName(16195,user.getLanguage())%>_GBK"><%=SystemEnv.getHtmlLabelName(16195,user.getLanguage())%>_GBK
    <option value="<%=SystemEnv.getHtmlLabelName(16196,user.getLanguage())%>_GBK"><%=SystemEnv.getHtmlLabelName(16196,user.getLanguage())%>_GBK
  </select>
  <select ID="FontSize" class="tbGeneral" style="width:40" TITLE="<%=SystemEnv.getHtmlLabelName(16197,user.getLanguage())%>" LANGUAGE="javascript" onchange="return FontSize_onchange()">
    <option value="1">1
    <option value="2">2
    <option value="3">3
    <option value="4">4
    <option value="5">5
    <option value="6">6
    <option value="7">7
  </select>
  
  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_BOLD" TITLE="<%=SystemEnv.getHtmlLabelName(16198,user.getLanguage())%>" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_BOLD_onclick()">
    <img class="tbIcon" src="/images/Bold_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_ITALIC" TITLE="<%=SystemEnv.getHtmlLabelName(16199,user.getLanguage())%>" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_ITALIC_onclick()">
    <img class="tbIcon" src="/images/Italic_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_UNDERLINE" TITLE="<%=SystemEnv.getHtmlLabelName(16200,user.getLanguage())%>" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_UNDERLINE_onclick()">
    <img class="tbIcon" src="/images/under_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  
  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_SETFORECOLOR" TITLE="<%=SystemEnv.getHtmlLabelName(2076,user.getLanguage())%>" LANGUAGE="javascript" onclick="return DECMD_SETFORECOLOR_onclick()">
    <img class="tbIcon" src="/images/fgcolor_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_SETBACKCOLOR" TITLE="<%=SystemEnv.getHtmlLabelName(16201,user.getLanguage())%>" LANGUAGE="javascript" onclick="return DECMD_SETBACKCOLOR_onclick()">
    <img class="tbIcon" src="/images/bgcolor_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  
  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_JUSTIFYLEFT" TITLE="<%=SystemEnv.getHtmlLabelName(16202,user.getLanguage())%>" TBTYPE="toggle" NAME="Justify" LANGUAGE="javascript" onclick="return DECMD_JUSTIFYLEFT_onclick()">
    <img class="tbIcon" src="/images/left_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_JUSTIFYCENTER" TITLE="<%=SystemEnv.getHtmlLabelName(16203,user.getLanguage())%>" TBTYPE="toggle" NAME="Justify" LANGUAGE="javascript" onclick="return DECMD_JUSTIFYCENTER_onclick()">
    <img class="tbIcon" src="/images/Center_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_JUSTIFYRIGHT" TITLE="<%=SystemEnv.getHtmlLabelName(16204,user.getLanguage())%>" TBTYPE="toggle" NAME="Justify" LANGUAGE="javascript" onclick="return DECMD_JUSTIFYRIGHT_onclick()">
    <img class="tbIcon" src="/images/right_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_ORDERLIST" TITLE="<%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%>" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_ORDERLIST_onclick()">
    <img class="tbIcon" src="/images/numlist_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_UNORDERLIST" TITLE="<%=SystemEnv.getHtmlLabelName(16205,user.getLanguage())%>" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_UNORDERLIST_onclick()">
    <img class="tbIcon" src="/images/bullist_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  
  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_OUTDENT" TITLE="<%=SystemEnv.getHtmlLabelName(16206,user.getLanguage())%>" LANGUAGE="javascript" onclick="return DECMD_OUTDENT_onclick()">
    <img class="tbIcon" src="/images/DeIndent_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_INDENT" TITLE="<%=SystemEnv.getHtmlLabelName(16207,user.getLanguage())%>" LANGUAGE="javascript" onclick="return DECMD_INDENT_onclick()">
    <img class="tbIcon" src="/images/inindent_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_HYPERLINK" TITLE="<%=SystemEnv.getHtmlLabelName(16208,user.getLanguage())%>" LANGUAGE="javascript" onclick="return DECMD_HYPERLINK_onclick()">
    <img class="tbIcon" src="/images/Link_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_IMAGE" TITLE="<%=SystemEnv.getHtmlLabelName(16209,user.getLanguage())%>" LANGUAGE="javascript" onclick="return DECMD_IMAGE_onclick()">
    <img class="tbIcon" src="/images/image_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
</div>

<div class="tbToolbar" ID="StandardToolbar">
 <!--
  <div class="tbGeneral" ID="URL_LABEL" TITLE="Enter URL" style="top:6; width:27; FONT-FAMILY: ms sans serif; FONT-SIZE: 10px;">
    URL:
  </div>
   <input type="text" class="tbGeneral" ID="URL_VALUE" TITLE="Enter URL" value="http://" style="width:200" LANGUAGE="javascript" onkeypress="return URL_VALUE_onkeypress()">
 
  <div class="tbSeparator"></div>

  <div class="tbButton" ID="MENU_FILE_NEW" TITLE="New File" LANGUAGE="javascript" onclick="return MENU_FILE_NEW_onclick()">
    <img class="tbIcon" src="/images/newdoc_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
   <div class="tbButton" ID="MENU_FILE_OPEN" TITLE="Open File" LANGUAGE="javascript" onclick="return MENU_FILE_OPEN_onclick()">
    <img class="tbIcon" src="/images/Open_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
   <div class="tbButton" ID="MENU_FILE_SAVE" TITLE="Save File" LANGUAGE="javascript" onclick="return MENU_FILE_SAVE_onclick()">
    <img class="tbIcon" src="/images/save_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  -->
  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_CUT" TITLE="<%=SystemEnv.getHtmlLabelName(16179,user.getLanguage())%>" LANGUAGE="javascript" onclick="return DECMD_CUT_onclick()">
    <img class="tbIcon" src="/images/Cut_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_COPY" TITLE="<%=SystemEnv.getHtmlLabelName(77,user.getLanguage())%>" LANGUAGE="javascript" onclick="return DECMD_COPY_onclick()">
    <img class="tbIcon" src="/images/copy_wev8.gif" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_PASTE" TITLE="<%=SystemEnv.getHtmlLabelName(16180,user.getLanguage())%>" LANGUAGE="javascript" onclick="return DECMD_PASTE_onclick()">
    <img class="tbIcon" src="/images/Paste_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_UNDO" TITLE="<%=SystemEnv.getHtmlLabelName(16210,user.getLanguage())%>" LANGUAGE="javascript" onclick="return DECMD_UNDO_onclick()">
    <img class="tbIcon" src="/images/Undo_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_REDO" TITLE="<%=SystemEnv.getHtmlLabelName(16211,user.getLanguage())%>" LANGUAGE="javascript" onclick="return DECMD_REDO_onclick()">
    <img class="tbIcon" src="/images/Redo_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_FINDTEXT" TITLE="<%=SystemEnv.getHtmlLabelName(15100,user.getLanguage())%>" LANGUAGE="javascript" onclick="return DECMD_FINDTEXT_onclick()">
    <img class="tbIcon" src="/images/Find_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
</div>

<div class="tbToolbar" ID="AbsolutePositioningToolbar">
 <!--
  <div class="tbButton" ID="DECMD_VISIBLEBORDERS" TITLE="Visible Borders" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_VISIBLEBORDERS_onclick()">
    <img class="tbIcon" src="/images/borders_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_SHOWDETAILS" TITLE="Show Details" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_SHOWDETAILS_onclick()">
    <img class="tbIcon" src="/images/details_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  -->
  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_MAKE_ABSOLUTE" TBTYPE="toggle" LANGUAGE="javascript" TITLE="<%=SystemEnv.getHtmlLabelName(16212,user.getLanguage())%>" onclick="return DECMD_MAKE_ABSOLUTE_onclick()">
    <img class="tbIcon" src="/images/abspos_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_LOCK_ELEMENT" TBTYPE="toggle" LANGUAGE="javascript" TITLE="<%=SystemEnv.getHtmlLabelName(16213,user.getLanguage())%>" onclick="return DECMD_LOCK_ELEMENT_onclick()">
    <img class="tbIcon" src="/images/Lock_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  
  <div class="tbSeparator"></div>
  
  <div class="tbButton" ID="DECMD_SNAPTOGRID" TITLE="<%=SystemEnv.getHtmlLabelName(16214,user.getLanguage())%>" TBTYPE="toggle" LANGUAGE="javascript" onclick="return DECMD_SNAPTOGRID_onclick()">
    <img class="tbIcon" src="/images/snapgrid_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
</div>

<div class="tbToolbar" ID="TableToolbar">
  <div class="tbButton" ID="DECMD_INSERTTABLE" TITLE="<%=SystemEnv.getHtmlLabelName(16181,user.getLanguage())%>" LANGUAGE="javascript" onclick="return TABLE_INSERTTABLE_onclick()">
    <img class="tbIcon" src="/images/instable_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>

  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_INSERTROW" TITLE="<%=SystemEnv.getHtmlLabelName(1988,user.getLanguage())%>" LANGUAGE="javascript" onclick="return TABLE_INSERTROW_onclick()">
    <img class="tbIcon" src="/images/insrow_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_DELETEROWS" TITLE="<%=SystemEnv.getHtmlLabelName(16182,user.getLanguage())%>" LANGUAGE="javascript" onclick="return TABLE_DELETEROW_onclick()">
    <img class="tbIcon" src="/images/delrow_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
 
  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_INSERTCOL" TITLE="<%=SystemEnv.getHtmlLabelName(1989,user.getLanguage())%>" LANGUAGE="javascript" onclick="return TABLE_INSERTCOL_onclick()">
    <img class="tbIcon" src="/images/inscol_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_DELETECOLS" TITLE="<%=SystemEnv.getHtmlLabelName(16183,user.getLanguage())%>" LANGUAGE="javascript" onclick="return TABLE_DELETECOL_onclick()">
    <img class="tbIcon" src="/images/delcol_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  
  <div class="tbSeparator"></div>

  <div class="tbButton" ID="DECMD_INSERTCELL" TITLE="<%=SystemEnv.getHtmlLabelName(16184,user.getLanguage())%>" LANGUAGE="javascript" onclick="return TABLE_INSERTCELL_onclick()">
    <img class="tbIcon" src="/images/inscell_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_DELETECELLS" TITLE="<%=SystemEnv.getHtmlLabelName(16185,user.getLanguage())%>" LANGUAGE="javascript" onclick="return TABLE_DELETECELL_onclick()">
    <img class="tbIcon" src="/images/delcell_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_MERGECELLS" TITLE="<%=SystemEnv.getHtmlLabelName(16186,user.getLanguage())%>" LANGUAGE="javascript" onclick="return TABLE_MERGECELL_onclick()">
    <img class="tbIcon" src="/images/mrgcell_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
  <div class="tbButton" ID="DECMD_SPLITCELL" TITLE="<%=SystemEnv.getHtmlLabelName(16187,user.getLanguage())%>" LANGUAGE="javascript" onclick="return TABLE_SPLITCELL_onclick()">
    <img class="tbIcon" src="/images/spltcell_wev8.GIF" WIDTH="23" HEIGHT="22">
  </div>
</div>

<!-- Toolbar Code File. Note: This must always be the last thing on the page -->
<script LANGUAGE="Javascript" SRC="/js/toolbars_wev8.js">
</script>
<div id="odiv" style.display="null" innerHTML="hello">
</body>
</html>
<script type="text/javascript">
<%
int showwaiting = Util.getIntValue(Util.null2String(request.getParameter("showwaiting")),0);
if(showwaiting==1){
%>
window.parent.document.getElementById("message_table_Div").style.display = "none";
window.parent.document.getElementById('_xTable').style.display = "none";
window.parent.document.getElementById('rightMenu').style.display = "block";
<%
}
%>
</script>