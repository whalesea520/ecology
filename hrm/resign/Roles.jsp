
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/hrm/header.jsp" %>
<%@page import="weaver.hrm.common.Constants"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%
	String id=Util.null2String(request.getParameter("id"));
	//当前用户为记录本人或者其上级或者具有“离职审批”权限则可查看此页面
	String userId = "" + user.getUID();
	String managerId = ResourceComInfo.getManagerID(id);
	if(!userId.equals(id) && !userId.equals(managerId) && !HrmUserVarify.checkUserRight("Resign:Main", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String imagefilename = "/images/hdDOC_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(17575,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	boolean hasNextPage=false;
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align:right;"><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<%
			String backfields = " a.id,a.roleid,a.resourceid,a.rolelevel,b.rolesmark ";
			String fromSql  = " from HrmRoleMembers a left join HrmRoles b on a.roleid = b.id ";
			String sqlWhere = " where resourceid = "+id;
			String orderby = " a.orderby " ;
			
			String pageId = "HRM_RESIGN_ROLES" ; 
			
			String tableString = " <table pageId=\""+pageId+"\" pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
			" 	<sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"asc\" sqlisdistinct=\"\"/>"+
			"	<head>"+
			"		<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(122,user.getLanguage())+"\" column=\"rolesmark\" orderkey=\"rolesmark\" linkkey=\"id\" linkvaluecolumn=\"roleid\" href=\"/hrm/roles/HrmRolesMembers.jsp\" target=\"_self\"/>"+
			"		<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(139,user.getLanguage())+"\" column=\"rolelevel\" orderkey=\"rolelevel\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+";0=124,1=141,default=140]}\"/>"+
			"	</head>"+
			" </table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
	</BODY>
</HTML>
