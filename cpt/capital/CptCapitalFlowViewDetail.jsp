<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CapitalStateComInfo" class="weaver.cpt.maintenance.CapitalStateComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript" src="/cpt/js/common_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.parent.getParentWindow(window);
}
if("<%=isclose%>"=="1"){
	parentWin.onBtnSearchClick();
	parentWin.closeDialog();	
}
</script>
</head>
<%
int id = Util.getIntValue(request.getParameter("id"),0);


if(!HrmUserVarify.checkUserRight("CptCapital:FlowView", user)){
    		response.sendRedirect("/notice/noright.jsp");
    		return;
	}

rs.executeProc("CptUseLog_SelectByID",""+id);

String capitalid = "";
String usedate = "";
String usedeptid = "";
String useresourceid = "";
String usecount = "";
String useaddress = "";
String userequest = "";
String maintaincompany = "";
String fee = "";
String usestatus = "";
String remark = "";
String resourceid = "";
String mendperioddate ="";

if(rs.next()){
	capitalid = Util.toScreen(rs.getString("capitalid"),user.getLanguage());
	usedate = Util.toScreen(rs.getString("usedate"),user.getLanguage());
	usedeptid = Util.toScreen(rs.getString("usedeptid"),user.getLanguage());
	useresourceid = Util.toScreen(rs.getString("useresourceid"),user.getLanguage());
	usecount = Util.toScreen(rs.getString("usecount"),user.getLanguage());
	useaddress = Util.toScreen(rs.getString("useaddress"),user.getLanguage());
	userequest = Util.toScreen(rs.getString("userequest"),user.getLanguage());
	maintaincompany = Util.toScreen(rs.getString("maintaincompany"),user.getLanguage());
	fee = Util.toScreen(rs.getString("fee"),user.getLanguage());
	usestatus = Util.toScreen(rs.getString("usestatus"),user.getLanguage());
	remark = Util.toScreen(rs.getString("remark"),user.getLanguage());
	resourceid = Util.toScreen(rs.getString("resourceid"),user.getLanguage());
	mendperioddate = Util.toScreen(rs.getString("mendperioddate"),user.getLanguage());
}

String imagefilename = "/images/hdHRMCard_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(1501,user.getLanguage());
String needfav ="1";
String needhelp ="";
boolean canEdit = false;
%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="assest"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(2121, user.getLanguage()) %>"/>
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:back(),_self} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(2121, user.getLanguage()) %>'>
		<wea:item attributes="{'colspan':'full'}"><A HREF="CptCapital.jsp?id=<%=capitalid%>"><%=Util.toScreen(CapitalComInfo.getCapitalname(capitalid),user.getLanguage())%></A></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1394,user.getLanguage())%></wea:item>
		<wea:item><%=usedate%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(DepartmentComInfo.getDepartmentname(usedeptid),user.getLanguage())%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(ResourceComInfo.getResourcename(useresourceid),user.getLanguage())%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1047,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
		<wea:item><%=Util.toScreen(CapitalStateComInfo.getCapitalStatename(usestatus),user.getLanguage())%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></wea:item>
		<wea:item><%=usecount%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(793,user.getLanguage())%></wea:item>
		<wea:item><%if(!usestatus.equals("-1")&&!usestatus.equals("-2")) {%>
			  <%=Util.toScreen(RequestComInfo.getRequestname(userequest),user.getLanguage())%>
			  <%}%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1399,user.getLanguage())%></wea:item>
		<wea:item><%=CustomerInfoComInfo.getCustomerInfoname(maintaincompany)%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(22457,user.getLanguage())%></wea:item>
		<wea:item><%=mendperioddate%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1400,user.getLanguage())%></wea:item>
		<wea:item><%=fee%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1395,user.getLanguage())%></wea:item>
		<wea:item><%=useaddress%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></wea:item>
		<wea:item><%=remark%></wea:item>
	</wea:group>
</wea:layout>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>

</BODY></HTML>
