
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "" + SystemEnv.getHtmlLabelName(572,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(18596,user.getLanguage());
String needfav ="1";
String needhelp ="";

int groupId = Util.getIntValue(request.getParameter("groupId"));
%>
<html>
<head>
<script type="text/javascript" src="/js/prototype_wev8.js"></script>
<script type="text/javascript">
String.prototype.trim = function() {
	return (this.replace(/^\s+|\s+$/g,""));
}
function doSubmit(){	
	if($F("contacterType")==1){
		$("fMailContacterFile").submit();
	}else{
		if(check_form(fMailContacter,'resourceid')){
			$("fMailContacter").submit();
		}
	}
}
function contacterTypeChange(o){
	var btn = $("btnBrowser");
	var selected = o.options[o.selectedIndex].value;
	switch(selected){
		case "1" :	toggleTbl(1);
						//$("fMailContacter").action = "MailContacterImportCSV.jsp";
						//$("fMailContacter").operation.value = "contacterImportCSV";
						//$("fMailContacter").enctype = "multipart/form-data";
						break;
		case "2" :	toggleTbl(2);
						$("fMailContacter").operation.value = "contacterImportHRM";
						$("fMailContacter").enctype = "application/x-www-form-urlencoded";
						btn.onclick = onShowResourcemail;
						break;
		case "3" :	toggleTbl(3);
						$("fMailContacter").operation.value = "contacterImportCRM";
						$("fMailContacter").enctype = "application/x-www-form-urlencoded";
						btn.onclick = onShowCRMContacterMail;	
						break;
	}
}
function toggleTbl(selected){
	showHelpMsg(selected);
	var tB = $("tbl").tBodies;
	switch(selected){
		case 1 :	Element.hide(tB[1]);
					Element.show(tB[2]);
					Element.show(tB[3]);
					break;
		case 2 :
		case 3 :	Element.show(tB[1]);
					Element.hide(tB[2]);
					Element.hide(tB[2]);
					break;
	}
}
function showHelpMsg(selected){
	var helpMsg = ["<%=SystemEnv.getHtmlLabelName(20024,user.getLanguage())%>",
						"<%=SystemEnv.getHtmlLabelName(20025,user.getLanguage())%>",
						"<%=SystemEnv.getHtmlLabelName(20026,user.getLanguage())%>"];
	$("help").innerHTML = helpMsg[selected-1];
}
//==============================================
// Browser
//==============================================
function onShowCRMContacterMail(){
	var ids;
	var _idspan = "";
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCRMContacterBrowserMail.jsp");
	if(typeof id=="undefined") return false;
	ids = id.toArray();
	if(ids){
		var _ids = ids[0].split(",");
		var _names = ids[1].split(",");
		for(var i=0;i<_names.length;i++){
			if(_ids[i]=="") continue;
			_idspan += "<a href='/CRM/data/ViewCustomer.jsp?CustomerID="+_ids[i]+"'>"+_names[i]+"</a>";
		}
	}
	$("resourceid").value = ids[0];
	$("resourceidspan").innerHTML = _idspan;
}
function onShowResourcemail(){
	var ids;
	var _idspan = "";
	var strTemp = "?resourceids="+$("resourceid").value;
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/email/MutiResourceMailBrowser.jsp"+strTemp);
	if(typeof id=="undefined") return false;
	ids = id.toArray();
	if(ids){
		var _ids = ids[0].split(",");
		var _names = ids[1].split(",");
		for(var i=0;i<_names.length;i++){
			if(_ids[i]=="") continue;
			_idspan += _names[i]+" ";
		}
	}
	$("resourceid").value = ids[0];
	$("resourceidspan").innerHTML = _idspan;
}
</script>
<script type="text/vbscript">
sub onShowResourcemail1()
	dim objNames,objIds
   objNames = document.getElementById("resourceidspan")
	objIds = document.getElementById("resourceid")
	alert(document.getElementById("resourceid").value)
   objidsValue=objIds.value
	strTemp=""
   //if(objidsValue<>"") then strTemp="?resourceids=" & objidsValue End if
   id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/email/MutiResourceMailBrowser.jsp"&strTemp)
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			objIds.value = id(0)
      else
          objIds.value = ""
      end if
      if id(1)<> "" then
			objNames.innerHTML = id(1)
		else
			objNames.innerHTML = ""
      end if
	end if 
end Sub
</script>
<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css" />
<style type="text/css" media="screen">
input{width:100%;}
</style>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSubmit(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table style="width:100%;height:92%;border-collapse:collapse">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td valign="top">
		<table class="Shadow">
		<tr>
		<td valign="top">
<!--==========================================================================================-->
<form method="post" action="MailContacterOperation.jsp" id="fMailContacter" name="fMailContacter">
<input type="hidden" id="operation" name="operation" value="contacterImportHRM" />
<input type="hidden" name="groupId" value="<%=groupId%>" />
<table id="tbl" class="ViewForm">
<colgroup>
<col width="30%">
<col width="70%">
</colgroup>
<tbody>
<tr class="Title">
	<th colspan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></th>
</tr>
<tr class="Spacing" style="height:2px"><td class="Line1" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
	<td class="Field">
		<select id="contacterType" name="contacterType" onchange="contacterTypeChange(this)">
		<option value="2"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
		<option value="3"><%=SystemEnv.getHtmlLabelName(17129,user.getLanguage())%></option>
		<option value="1"><%=SystemEnv.getHtmlLabelName(19815,user.getLanguage())%></option>
		</select>
	</td>
</tr>
</tbody>
<tbody>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></td>
	<td class="Field">
		<button class="Browser" type=button id="btnBrowser" onclick="onShowResourcemail()"></button>
		<span id="resourceidspan" name="resourceidspan"><img src="/images/BacoError_wev8.gif" align="absMiddle"></span>
		<input type="hidden" id="resourceid" name="resourceid" />
		<input type="hidden" id="resourcemail" name="resourcemail" />
	</td>
</tr>
</tbody>
</form>

<form method="post" action="MailContacterImportCSV.jsp" id="fMailContacterFile" name="fMailContacterFile" enctype="multipart/form-data">
<input type="hidden" name="groupId" value="<%=groupId%>" />
<tbody style="display:none">
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18493,user.getLanguage())%></td>
	<td class="Field">
		<input type="file" name="csvFile" class="inputstyle" />
	</td>
</tr>
<!--
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
<tr>
	<td>Outlook</td>
	<td class="Field">
		<input type="checkbox" name="isOutlook" class="inputstyle" style="width:20px" />
	</td>
</tr>
-->
</tbody>
</form>
<tr style="height:1px"><td class="Line" colspan="2"></td></tr>
</table>
<!--==========================================================================================-->
<div id="help" class="help"><%=SystemEnv.getHtmlLabelName(20025,user.getLanguage())%></div>
<!--==========================================================================================-->
		</td>
		</tr>
		</table>
	</td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</body>
</html>


<script type="text/vbscript">
sub onShowResourceID()
	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if id1(0)<> "" then
		resourceids = id1(0)
		resourcename = id1(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		fMailContacter.resourceid.value= resourceids
		resourcename = Mid(resourcename,2,len(resourcename))
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&curid&">"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href=/hrm/resource/HrmResource.jsp?id="&resourceids&">"&resourcename&"</a>&nbsp"
		resourceidspan.innerHtml = sHtml
	else
		resourceidspan.innerHtml =""
		fMailContacter.resourceid.value=""
	end if
end sub
</script>