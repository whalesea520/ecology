<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.*" %>
<%
User user = HrmUserVarify.getUser (request , response);
%>
<html>
<head>
<title><%=SystemEnv.getHtmlLabelName(15446,user.getLanguage())%></title>
<script language="JavaScript">
 
<!--Begin
// Add the selected items in the parent by calling method of parent
function addSelectedItemsToParent() {
self.opener.addToParentList(window.document.forms[0].destList);
window.close();
}
// Fill the selcted item list with the items already present in parent.
function fillInitialDestList() {
	var destList = window.document.forms[0].destList; 
	var srcList = self.opener.window.document.forms[0].parentList;
	for (var count = destList.options.length - 1; count >= 0; count--) {
		destList.options[count] = null;
	}
	if(srcList != null){
		for(var i = 0; i < srcList.options.length; i++) { 
			if (srcList.options[i] != null)
				destList.options[i] = new Option(srcList.options[i].text,srcList.options[i].value);
   		}
   	}
}
// Add the selected items from the source to destination list
function addSrcToDestList() {
destList = window.document.forms[0].destList;
srcList = window.document.forms[0].srcList; 
var len = destList.length;
for(var i = 0; i < srcList.length; i++) {
if ((srcList.options[i] != null) && (srcList.options[i].selected)) {
//Check if this value already exist in the destList or not
//if not then add it otherwise do not add it.
var found = false;
for(var count = 0; count < len; count++) {
if (destList.options[count] != null) {
if (srcList.options[i].text == destList.options[count].text) {
found = true;
break;
      }
   }
}
if (found != true) {
destList.options[len] = new Option(srcList.options[i].text,srcList.options[i].value); 
len++;
         }
      }
   }
}
// Deletes from the destination list.
function deleteFromDestList() {
var destList  = window.document.forms[0].destList;
var len = destList.options.length;
for(var i = (len-1); i >= 0; i--) {
if ((destList.options[i] != null) && (destList.options[i].selected == true)) {
destList.options[i] = null;
      }
   }
}
// End -->
</SCRIPT>
</head>
<body onLoad="javascript:fillInitialDestList();" bgcolor="#CCCCCC">
<center>
<form method="POST">
<table bgcolor="#CCCCCC">
<tr>
<td bgcolor="#CCCCCC" width="74"><%=SystemEnv.getHtmlLabelName(15447,user.getLanguage())%></td>
<td bgcolor="#CCCCCC"> </td>
<td bgcolor="#CCCCCC" width="69"><%=SystemEnv.getHtmlLabelName(15448,user.getLanguage())%></td>
</tr>
<tr>
<td bgcolor="#CCCCCC" width="85">
<select class=inputstyle  size="6" name="srcList" multiple>
<%while(FieldComInfo.next()){
%>
<option value="<%=FieldComInfo.getFieldid()%>"><%=FieldComInfo.getFieldname()%></option>
<%
}
%>
</select>
</td>
<td bgcolor="#CCCCCC" width="74" align="center">
<input type="button" value=" >> " onClick="javascript:addSrcToDestList()">
<br><br>
<input type="button" value=" << " onclick="javascript:deleteFromDestList();">
</td>
<td bgcolor="#CCCCCC" width="69">
<select class=inputstyle  size="6" name="destList" multiple>
</select>
</td>
</tr>
</table>
<br>
<center>

<input type="button" value="<%=SystemEnv.getHtmlLabelName(555, user.getLanguage())%>ˆ" onClick = "javascript:addSelectedItemsToParent()">

</center>

</form>
</body>
</html>

