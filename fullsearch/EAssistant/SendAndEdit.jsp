
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<HTML>
<HEAD>
	<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
	<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
	<style>
		.content{
			margin-left: 60px;
    		margin-top: 10px;
    		font-size: 13px;
		}
	</style>
</HEAD>
<%!

%>
<%
String askid =Util.null2String(request.getParameter("askid"));
String askname =Util.null2String(request.getParameter("askname"));
String faqid =Util.null2String(request.getParameter("faqid"));
%>
<BODY>
<div style="float:left;margin-top:50px">
	<p style="margin-left:260px"><img src='\fullsearch\img\green_sucess_wev8.png'><span style="margin-left:5px;font-size:13px"><%=SystemEnv.getHtmlLabelName(130377, user.getLanguage())%></span></p>

	<p class="content"><%=SystemEnv.getHtmlLabelName(130378, user.getLanguage())%></p>
	<input type="text" id="otherAsk" name="otherAsk" value="<%=askname %>" class="InputStyle content" style="width:500px;height:30px">
	<p class="content"><%=SystemEnv.getHtmlLabelName(130379, user.getLanguage())%>？</p>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout type="2col">
		<wea:group context="">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="doSubmit()">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="closeDialog()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<SCRIPT LANGUAGE="JavaScript">
var parentWin = null;
try{
	parentWin =parent.getParentWindow(window);
}catch(e){}
function doSubmit(){
	$.post("/fullsearch/EAssistant/eWorkbenchAjax.jsp",{type:'addOtherAskToFAQ',faqId:"<%=askid%>",addFaqId:"<%=faqid%>",otherAsk:$("#otherAsk").val()},function(data){
			if(data.result=="success"){
				closeDialog();
			}
		});
}
function closeDialog(){
	parentWin.closeDialog();
}
</SCRIPT>
</BODY>
</HTML>
