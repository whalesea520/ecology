
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<%

String approver = "";

%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<SCRIPT language="javascript" src="../../js/jquery/jquery_wev8.js"></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
</head>
<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18599, user.getLanguage());
String needfav = "1";
String needhelp = "";

String votingid = Util.fromScreen(request.getParameter("votingid"),user.getLanguage());
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{" + SystemEnv.getHtmlLabelName(615, user.getLanguage())+ ",javascript:doSave(),_top} ";
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="voting"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(23756,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doSave()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(615,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver name=frmMain action="VotingRemindersOperation.jsp" method=post>
<input type="hidden" name="votingid" value="<%=votingid%>">
<input type="hidden" name="method" value="reminders">
<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item><%=SystemEnv.getHtmlLabelName(18713,user.getLanguage())%></wea:item>
		<wea:item><nobr> 
				 <INPUT type=radio class=inputstyle name="sendtype" value="1" checked><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
				 <INPUT type=radio class=inputstyle name="sendtype" value="0"><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
		</wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(345,user.getLanguage())%></wea:item>
		<wea:item><nobr> 
			 <TEXTAREA class=inputStyle NAME=decision ROWS=10 STYLE="width:90%"></TEXTAREA>	
		</wea:item>
		
	</wea:group>
</wea:layout>
</FORM>

<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
<script language=javascript>
function doSave(){
	document.frmMain.submit();
}
</script>




</BODY></HTML>

