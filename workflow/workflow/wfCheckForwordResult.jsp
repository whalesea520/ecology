
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%><!--added by xwj for td2023 on 2005-05-20-->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<%
if(user.getUID()!=1) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
 %>
</head>
<BODY overflow=hidden>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:OnSearch(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=frmmain method=post action="wfCheckForwordResult.jsp">
<table width=100% height=94% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
			<table class="viewform">
			  <colgroup>
			  <tbody>
			  <tr>
			  	<td align="center"><h2 style="color: red;"><%=SystemEnv.getHtmlLabelName(129506, user.getLanguage())%></h2></td>
			  </tr>
			  </tbody>
			</table>	
<%
String sqlWhere = " where t1.workflowid = t2.id and IsPendingForward=1 ";
sqlWhere += " and ((IsWaitForwardOpinion=1 and IsBeForwardModify=0 and IsSubmitedOpinion=0 and IsBeForwardSubmit=0 and IsBeForwardPending=0) ";
sqlWhere += " or (IsShowWaitForwardOpinion=1 and IsShowBeForwardModify=0 and IsShowSubmitedOpinion=0 and IsShowBeForwardSubmit=0 and IsShowBeForwardPending= 0) ";
sqlWhere += " or (IsSubmitedOpinion=1 and(IsBeForwardSubmit=1 or IsWaitForwardOpinion=1 or IsBeForwardPending=1)) ";
sqlWhere += " or (IsShowSubmitedOpinion=1 and(IsShowBeForwardSubmit=1 or IsShowWaitForwardOpinion=1 or IsShowBeForwardPending=1)) ";
sqlWhere += " or (IsWaitForwardOpinion=1 and (IsSubmitedOpinion=1 or IsBeForwardPending=1)) ";
sqlWhere += " or (IsShowWaitForwardOpinion=1 and (IsShowSubmitedOpinion=1 or IsShowBeForwardPending=1))) ";
String orderby =" t2.id ";
String tableString = "";
int perpage=10;                                 
String backfields = " t2.id,t2.workflowname,t2.workflowdesc,t2.istemplate ";
String fromSql  = " workflow_flownode t1,workflow_base t2 ";
tableString =   " <table instanceid=\"wcCheckForwordTable\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_WFCHECKFORWORDRESULT,user.getUID())+"\" >";
tableString+=   "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t2.id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />";
tableString+=   "       <head>";
tableString+=   "           <col width=\"10%\"  text=\"ID\" column=\"id\" orderkey=\"id\" />";
tableString+=   "           <col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(2079,user.getLanguage())+"\" column=\"workflowname\" orderkey=\"workflowname\" otherpara=\"column:id+column:istemplate\" transmethod=\"weaver.workflow.request.WFForwardManager.getWorkflowlink\" />";
tableString+=   "           <col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(15594,user.getLanguage())+"\" column=\"workflowdesc\"  orderkey=\"workflowdesc\"  />";
tableString+=   "       </head>";
tableString+=   " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_WFCHECKFORWORDRESULT %>"/>
<TABLE width="100%" cellspacing=0>
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>			  
	 	</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
</form>
<script type="text/javascript">
function OnSearch(){
	frmmain.submit();
}
</script>
</body>
</html>
