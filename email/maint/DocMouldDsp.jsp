
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="MailMouldManager" class="weaver.email.MailMouldManager" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(71,user.getLanguage())+SystemEnv.getHtmlLabelName(64,user.getLanguage());
String needfav ="1";
String needhelp ="";

String isDialog = Util.null2String(request.getParameter("isdialog"),"true");
%>
</head>

<%
int id = Util.getIntValue(request.getParameter("id"),0);
MailMouldManager.setId(id);
MailMouldManager.getMailMouldInfoById();
String mouldname=MailMouldManager.getMailMouldName();
String moulddesc=MailMouldManager.getMoulddesc();
String mouldtext=MailMouldManager.getMailMouldText();
String mouldSubject = MailMouldManager.getMouldSubject();
MailMouldManager.closeStatement();

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%if("false".equals(isDialog)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;    
	RCMenuHeight += RCMenuHeightStep;
}%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%if("true".equals(isDialog)){ %>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="mail"/>
	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(16218,user.getLanguage()) %>"/>
	</jsp:include>
<%} %>

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(18151,user.getLanguage())%></wea:item>
		<wea:item><%=mouldname%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(20622,user.getLanguage())%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("81821,33144",user.getLanguage())%></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(18627,user.getLanguage())%></wea:item>
		<wea:item>
				<%=moulddesc %>
		</wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></wea:item>
		<wea:item>
				<%= mouldSubject%>
		</wea:item>
		
		<wea:item attributes="{'colspan':'full'}"><%=SystemEnv.getHtmlLabelName(18693,user.getLanguage())%></wea:item>
		<wea:item attributes="{'customAttrs':'style=padding-right:20px'}">
			<%=mouldtext%>
		</wea:item>
	</wea:group>
</wea:layout>

<%if("true".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout>
			<wea:group context="" attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
<%} %>
</body>
</html>
