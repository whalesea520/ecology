<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" type="text/javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" type="text/javascript">
function searchText(){//搜索内容
	var key=$GetEle("key").value;
	if(key==""){
		window.alert('<%=SystemEnv.getHtmlLabelName(20456,user.getLanguage())%>');
	}else {
		jQuery("#searchtsInfo").show();
		$GetEle('frm1').submit();
	}
}
function _init(){
	$GetEle("key").focus();
}
jQuery(document).ready(function(){
	_init();
})
</script>

</head>
<%
String name =SystemEnv.getHtmlLabelName(20454,user.getLanguage());//"检索条件";
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(18446,user.getLanguage())+":"+name;
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:searchText(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<table class=Shadow>
<tr>
<td valign="top">

<form method="get" name="frm1" id="frm1" action="SearchDocumentsResult.jsp">

<table class=ViewForm>

<!--标题-->
<tr class=Spacing><td height="40">&nbsp;</td></tr>
<tr><td align="center">
<!---###标题框####-->
<table><tr>
<td><img src="/images/tu44_wev8.gif" width="70" height="80" border="0" alt="weaver"/></td>
<td><font size="7"><b><%=SystemEnv.getHtmlLabelName(18446,user.getLanguage())%></b></font></td>
</tr>
</table>
<!--#END#--->
</td></tr>
<tr class=Spacing><td height="40">&nbsp;</td>
</tr>
<tr class=Spacing ><td class=Line1></td></tr>
<!--模块-->
<tr style="height:1px;"><td class=Line colSpan=4></td></tr>
<tr><td class=field colSpan=4>
	<div align="center">
		<!--<label for="searchAll"><input type="radio" name="searchType" id="searchAll" value="all" >--><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%><!--</label>-->&nbsp;
		<label for="searchDocument"><input type="radio" name="searchType" id="searchDocument" checked value="document"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></label>&nbsp;
		<!--<label for="searchWorkflow"><input type="radio" name="searchType" id="searchWorkflow" value="workflow" >--><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%><!--</label>-->&nbsp;
		<!--<label for="searchCollaboration"><input type="radio" name="searchType" id="searchCollaboration" value="collaboration" >--><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%><!--</label>-->&nbsp;
		<!--<label for="searchClient"><input type="radio" name="searchType" id="searchClient" value="client" >--><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%><!--</label>-->&nbsp;
		<!--<label for="searchProject"><input type="radio" name="searchType" id="searchProject" value="project" >--><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%><!--</label>-->&nbsp;
	</div>
</td></tr>

<!--关键字-->
<tr style="height:1px;"><td class=Line colSpan=4></td></tr>
<tr><td class=field colSpan=4 align="center">
	<input class=InputStyle size=70 name="key">
</td></tr>

<!--内容-->
<tr style="height:1px;"><td class=Line colSpan=4></td></tr>
<!--
<tr><td class=field colSpan=4>
	<div align="center">
    	<label for="docAll"><input type="radio" id="docAll" name="sdoctype" checked ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></label>&nbsp;
		<label for="docHtml"><input type="radio" id="docHtml" name="sdoctype" >HTML<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></label>&nbsp;
		<label for="docWord"><input type="radio" id="docWord" name="sdoctype" >WORD<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></label>&nbsp;
		<label for="docExcel"><input type="radio" id="docExcel" name="sdoctype" >EXCEL<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></label>&nbsp;
		<label for="docPdf"><input type="radio" id="docPdf" name="sdoctype" >PDF<%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></label>&nbsp;
	</div>
</td></tr>

<tr><td class=Line colSpan=4></td></tr>
-->
<tr><td class=field colSpan=4 align="center" style="color:red;display:none;" id="searchtsInfo">
	<%=SystemEnv.getHtmlLabelName(31521,user.getLanguage())%>
</td></tr>
</table>
</form> 

</td>
</tr>
</table>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>

</body></html>
