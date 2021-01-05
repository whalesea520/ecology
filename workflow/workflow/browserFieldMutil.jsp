<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<script language=javascript src="/workplan/calendar/src/Plugins/jquery.form_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/ajaxmanager_wev8.js"></script>
<script type="text/javascript" src="/js/dragBox/rightspluingForBrowserNew_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/workflow/browserFieldMutil_wev8.js"></script>
<style type="text/css">
   .e8_box_middle{
     height: 320px!important;
   }
   .e8_first_allow{
     height: 140px!important;
   }
</style>
<script type="text/javascript">
	try{
		parent.setTabObjName("<%=SystemEnv.getHtmlLabelNames("33331",user.getLanguage())%>");
	}catch(e){
		if(window.console)console.log(e);
	}
	var parentWin = null;
	var dialog = null;
	try{
		parentWin = parent.parent.getParentWindow(parent);
		dialog = parent.parent.getDialog(parent);
	}catch(e){}
</script>
<link type="text/css" href="/js/dragBox/e8browser_wev8.css" rel=stylesheet>
</HEAD>
<%

String check_per = Util.null2String(request.getParameter("oldfields"));
int wfid = Util.getIntValue(request.getParameter("workflowid"));
String fieldname = Util.null2String(request.getParameter("fieldname"));
String tabletype = Util.null2String(request.getParameter("tabletype"));
%>
<BODY>
<div class="zDialog_div_content">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" onclick="btnOnSearch()" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(826,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:btnOnSearch(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:onReset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(826,user.getLanguage())+",javascript:btnok_onclick(),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onClose(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(311,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%
String isbill = "";
String formid = "";
RecordSet.executeSql("select formid, isbill from workflow_base where id=" + wfid);
if(RecordSet.next()) {
	formid = RecordSet.getString("formid");
	isbill = RecordSet.getString("isbill");
}
int count = 0; // 明细表个数
if(isbill.equals("0")) { // 表单
	RecordSet.executeSql("select MAX(groupId) count from workflow_formfield where isdetail=1 and formid=" + formid);
	if(RecordSet.next()) {
		count = Util.getIntValue(Util.null2String(RecordSet.getString("count")), -1) + 1;
	}
}else if(isbill.equals("1")) { // 单据
	RecordSet.executeSql("select COUNT(*) count from workflow_billdetailtable where billid=" + formid);
	if(RecordSet.next()) {
		count = Util.getIntValue(Util.null2String(RecordSet.getString("count")), 0);
	}
}
%>

<FORM NAME=SearchForm id="SearchForm" STYLE="margin-bottom:0" action="" onsubmit="return false;" method=post>
<%--added by XWJ on 2005-03-16 for td:1549--%>
<input type="hidden" name="wfid" value='<%=wfid%>'>
<div style="max-height:155px;overflow:hidden;" id="e8QuerySearchArea">
<wea:layout type="4col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>' attributes="{'groupSHBtnDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName( 685 ,user.getLanguage())%></wea:item>
		<wea:item><input class=InputStyle id=fieldname name=fieldname value='<%=fieldname %>' ></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(26734,user.getLanguage())%></wea:item>
		<wea:item>
			<select id="tabletype" name="tabletype">
				<option value="" <%if("".equals(tabletype)){%>selected<%}%>></option>
				<option value="0" <%if("0".equals(tabletype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%></option>
				<option value="1" <%if("1".equals(tabletype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%></option>
				<%-- <% for(int i = 0; i < count; i++) { %>
					<option value="<%=(i + 1) %>" <%if(("" + (i + 1)).equals(tabletype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage()) + (i+1) %></option>
				<% } %> --%>
			</select>		
		</wea:item>
	</wea:group>
</wea:layout>
</div>
<div id="dialog">
	<div id='colShow'></div>
</div>


</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
			<input type="button" class=zd_btn_submit accessKey=O  id=btnok value="O-<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>"></input>
			<input type="button" class=zd_btn_submit accessKey=2  id=btnclear value="2-<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>"></input>
	        <input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"></input>
		</wea:item>
	</wea:group>
</wea:layout>
<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
</div>
<script type="text/javascript">

jQuery(document).ready(function(){
	showMultiMouldDialog("<%=check_per%>");
});


</SCRIPT>
</BODY></HTML>
