<%@ page import="weaver.general.Util,
                 weaver.hrm.resign.ResignProcess,
                 weaver.hrm.resign.WorkFlowDetail" %>
<%@ page import="java.util.*" %>
<%@page import="weaver.hrm.common.Constants"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String id=Util.null2String(request.getParameter("id"));
//当前用户为记录本人或者其上级或者具有“离职审批”权限则可查看此页面
String userId = "" + user.getUID();
String managerId = ResourceComInfo.getManagerID(id);
if(!userId.equals(id) && !userId.equals(managerId) && !HrmUserVarify.checkUserRight("Resign:Main", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(125,user.getLanguage())+SystemEnv.getHtmlLabelName(17855,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
	<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;"><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
int perpage=Util.getIntValue(Util.null2String(request.getParameter("perpage")),10);
%>
                          <%
                           String tableString = "";
 String pageId = "HRM_RESIGN_COWORKS" ; 
                            if(perpage <2) perpage=10;

                            String backfields = " id,name,creater,createdate,createtime ";
                            String fromSql  = " from cowork_items ";
                            String sqlWhere = " where coworkmanager="+id;
														String orderby=" id ";


                         tableString =" <table tabletype=\"none\"  pageId=\""+pageId+"\" pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),Constants.HRM)+"\" >"+
                                                 "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlisdistinct=\"true\"/>"+
                                                 "			<head>"+
                                                 "				<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(18831,user.getLanguage())+"\" column=\"name\" orderkey=\"name\" otherpara=\"column:id\" transmethod=\"weaver.general.CoworkTransMethod.getCoworkLink\"/>"+
                                                 "				<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(722,user.getLanguage())+"\" column=\"createdate\" orderkey=\"createdate,createtime\" otherpara=\"column:createtime\" transmethod=\"weaver.general.CoworkTransMethod.getCreateTime\" />"+
                                                 "				<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\" transmethod=\"weaver.general.CoworkTransMethod.getCoworkCreaterName\"/>"+
                                                 "			</head>"+
                                                 "</table>";


                          %>

                          <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</body>
<SCRIPT language="javascript">
function returnMain(){
        window.location="/hrm/resign/Resign.jsp?resourceid=<%=id%>";
}
</script>

</html>
