
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="weaver.workflow.workflow.UserWFOperateLevel"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />
<html>
<head>
</head>
<body style="overflow:hidden;">
<%
int wfid=0;
wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
int subCompanyID= Util.getIntValue(Util.null2String(session.getAttribute(wfid+"subcompanyid")),-1);
int operateLevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subCompanyID,user,haspermission,"WorkflowManage:All");
if(operateLevel < 1){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(32940,user.getLanguage()) %>"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<!-- 
			<span title="菜单" class="cornerMenu"></span>
		-->
		</td>
	</tr>
</table>
<wea:layout type="twoCol" attributes="{'layoutTableId':'top'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%>' attributes="{groupOperDisplay:none}">
		<wea:item>
			<select style="width:160px" onchange="logtype(this);">
        		<option value=0>----------</option>
        		<option value=1><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></option>
        		<option value=2><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></option>
        		<option value=3><%=SystemEnv.getHtmlLabelName(15587,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%></option>
    		</select>
		</wea:item>
	</wea:group>
</wea:layout>
<iframe id="slog" frameborder="0" width="100%" scrolling="auto" src=""></iframe>
</body>
<script type="text/javascript">
function logtype(obj){
	$("#slog").height($(window).height()-$("#top").height()-64);
    if(obj.value=="0")
    	$GetEle('slog').src="";
    else if(obj.value=="1")
    	$GetEle('slog').src="/systeminfo/SysMaintenanceLog.jsp?_fromURL=3&wflog=1&isdialog=1&sqlwhere=<%=xssUtil.put("where operateitem=85 and relatedid="+wfid+" and (operatesmalltype is null or operatesmalltype<>1) ")%>";
    else if(obj.value=="2")
    	$GetEle('slog').src="/systeminfo/SysMaintenanceLog.jsp?_fromURL=3&wflog=1&isdialog=1&sqlwhere=<%=xssUtil.put("where operateitem=86 and relatedid="+wfid)%>";
    else if(obj.value=="3")
   		$GetEle('slog').src="/systeminfo/SysMaintenanceLog.jsp?_fromURL=3&wflog=1&isdialog=1&sqlwhere=<%=xssUtil.put("where operateitem=88 and relatedid="+wfid)%>";
}
</script>
</html>
