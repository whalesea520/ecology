
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(82,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(67,user.getLanguage());
String needfav ="1";
String needhelp ="";
int isclose = Util.getIntValue(request.getParameter("isclose"));
%>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
var dialog = parent.parent.getDialog(parent);
<%if(isclose==1){%>
	try{
		parentWin._table.reLoad();
	}catch(e){}
	dialog.close();
<%}%>
</script>
</head>
<%

if(!HrmUserVarify.checkUserRight("SensitiveWord:Manage", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<BODY>
<div class="zDialog_div_content">

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top" onclick="onSave();">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" class="e8_btn_top" onclick="dialog.close();">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM id=weaver name=weaver action="/security/sensitive/SensitiveWordOperation.jsp" method=post>
<input type=hidden name="operation" value="add">

<%

	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:dialog.close(),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
	
	
%>

<wea:layout>
	<wea:group context="<%=SystemEnv.getHtmlLabelName(61,user.getLanguage())+SystemEnv.getHtmlLabelName(87,user.getLanguage())%>">
		<wea:item><%=SystemEnv.getHtmlLabelName(131596,user.getLanguage())%></wea:item>
		<wea:item>
			<wea:required id="wordspan" required="true" value="">
				<INPUT maxLength=500 size=500 class=InputStyle viewtype=0 name="word" onchange="checkinput('word','wordspan')" id="word" temptitle="<%=SystemEnv.getHtmlLabelName(131596,user.getLanguage())%>"  value="">
			</wea:required>
		</wea:item>
	</wea:group>
</wea:layout>
       
</form>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script language="javascript">

function onSave(isEnterDetail){
	try{
		parent.disableTabBtn();
	}catch(e){}
	if(check_form(document.weaver,'word')){
			document.weaver.submit();
	}else{
		try{
			parent.enableTabBtn();
		}catch(e){}
	}
}


</script>
</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
					<wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
					</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>	
</BODY></HTML>