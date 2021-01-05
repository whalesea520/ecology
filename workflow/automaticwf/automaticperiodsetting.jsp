
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<% 
if(!HrmUserVarify.checkUserRight("intergration:automaticsetting",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String operate = Util.null2String(request.getParameter("operate"));
if(operate.equals("add")){
    int periodvalue = Util.getIntValue(Util.null2String(request.getParameter("periodvalue")),0);
    RecordSet.executeSql("delete from outerdatawfperiodset");
    RecordSet.executeSql("insert into outerdatawfperiodset(periodvalue) values("+periodvalue+")");
}
String periodvalue = "";
RecordSet.executeSql("select periodvalue from outerdatawfperiodset");
if(RecordSet.next()) periodvalue = Util.null2String(RecordSet.getString("periodvalue"));
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type="text/javascript">
function formsubmit() {
	$GetEle("frmmain").submit()
}
function doBack()
{
	document.location.href="/workflow/automaticwf/automaticsetting.jsp";
}
</script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23076,user.getLanguage())+" - " +SystemEnv.getHtmlLabelName(23112,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:formsubmit();,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
				<%if(HrmUserVarify.checkUserRight("intergration:automaticsetting", user)){%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="formsubmit()"/>
			<%}%>
			<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div id="tabDiv" >
   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
</div>
<div class="cornerMenuDiv"></div>
<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
</div>
<form name="frmmain" method="post" action="automaticperiodsetting.jsp">
<input type="hidden" id="operate" name="operate" value="add">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(23136,user.getLanguage())%></wea:item>
		<wea:item>
			<input type=text class=inputstyle size=10 maxlength=8 style='width:120px!important;' id="periodvalue" name="periodvalue" value="<%=periodvalue%>" onKeyPress="ItemCount_KeyPress()">
			<span><font color=red>(<%=SystemEnv.getHtmlLabelName(23137,user.getLanguage())%>,<%=SystemEnv.getHtmlLabelName(23138,user.getLanguage())%>)</font></span>
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</body>
</html>
<script language="javascript">
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	  $(".searchInput").val('');
	});
});
</script>
