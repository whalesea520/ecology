
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.worktask.worktask.*" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<STYLE TYPE="text/css">
/*样式名未定义*/
.btn_RequestSubmitList {BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
} 
</STYLE>
<%@ page import="weaver.general.*" %> 
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<script language="javascript">
function openFullWindowHaveBarTmp(url){
	var redirectUrl = url ;
	var width = screen.width ;
	var height = screen.height ;
	var szFeatures = "top=0," ; 
	szFeatures +="left=0," ;
	szFeatures +="width="+width+"," ;
	szFeatures +="height="+height+"," ; 
	szFeatures +="directories=no," ;
	szFeatures +="status=yes," ;
	szFeatures +="menubar=no," ;
	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
	if(typeof(window.dialogArguments) == "object"){
		openobj =  window.dialogArguments;
		openobj.open(redirectUrl,"",szFeatures);
	}else{
		window.open(redirectUrl,"",szFeatures);
	}
}
</script>
<%
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
boolean hasSuchWT = false;
String worktaskName = "";
String hasCanCreateTasks = "false";
WTRequestManager wtRequestManager = new WTRequestManager(wtid);
wtRequestManager.setLanguageID(user.getLanguage());
wtRequestManager.setUserID(user.getUID());
Hashtable canCreateTasks_hs = wtRequestManager.getCanCreateTasks();
hasCanCreateTasks = (String)canCreateTasks_hs.get("hasCanCreateTasks");
String tasksSelectStr = (String)canCreateTasks_hs.get("tasksSelectStr");

%>

<%if("true".equals(hasCanCreateTasks)){ %>

<script>
    openFullWindowHaveBarTmp("/worktask/request/AddWorktask.jsp?isRefash=1&wtid=<%=wtid%>");
</script>

<%}%>

<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/xmlextras_wev8.js"></script>
</HEAD>
<%
String needfav ="1";
String needhelp ="";
String titlename = SystemEnv.getHtmlLabelName(82, user.getLanguage()) + SystemEnv.getHtmlLabelName(16539, user.getLanguage());
String imagefilename = "/images/hdHRM_wev8.gif";
%>

<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(86, user.getLanguage())+",javaScript:OnSave(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
//RCMenu += "{"+SystemEnv.getHtmlLabelName(15143, user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
//RCMenuHeight += RCMenuHeightStep;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="worktask"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(16539,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form name="taskform" method="post" action="AddWorktaskFrame.jsp">
<input type="hidden" name="wtid" id="wtid" value="<%=wtid%>">

<wea:layout>
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item  attributes="{'colspan':'full'}">
		    <div align="center" style="font-size:14pt;FONT-WEIGHT: bold;height:60px;line-height: 60px;">
				<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage())+SystemEnv.getHtmlLabelName(16539, user.getLanguage())+SystemEnv.getHtmlLabelName(63, user.getLanguage())%>
			</div>
	   </wea:item>

		<wea:item><%=SystemEnv.getHtmlLabelName(18177,user.getLanguage())%></wea:item>
		<wea:item>
		    <div  style="height:40px;line-height: 40px;text-align: left;">
				<%=tasksSelectStr%>
			</div>
		</wea:item>
		
	</wea:group>
</wea:layout>

</form>
<script language="javascript">
function doChangeWorktask(obj){
	var wtid = obj.value;
	if(document.taskform.selectWorktask.value != "0"){
		//openFullWindowForXtable("/worktask/request/AddWorktask.jsp?wtid="+wtid);
		openFullWindowHaveBarTmp("/worktask/request/AddWorktask.jsp?isRefash=1&wtid="+wtid);
		//location.href="/worktask/request/Addworktask.jsp?wtid="+wtid;
		//window.parent.close();
	}
}
</script>
</BODY>
</HTML>