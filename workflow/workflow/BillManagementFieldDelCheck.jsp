
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<script language=javascript src="/js/weaver_wev8.js"></script>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<%

if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
		response.sendRedirect("/notice/noright.jsp");
    		return;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(17996,user.getLanguage());
String needfav ="1";
String needhelp ="";

String actionType = Util.null2String(request.getParameter("actionType")) ;
String fieldIds = Util.null2String(request.getParameter("fieldIds")) ;
int billId = Util.getIntValue(request.getParameter("billId"),0) ;

ArrayList idS = Util.TokenizerString(fieldIds,",");	
String nodeLinkIdS = "";
String sql = "" ;
String fieldName = "" ;
int fieldId = 0;
//出口条件检测
for(int i=0;i<idS.size();i++){
	fieldId = Integer.parseInt((String)idS.get(i));			
	//获得字段名
	sql = "select fieldname from  workflow_billfield where id = " + fieldId ;	
	RecordSet.execute(sql) ;
	if(RecordSet.next()){
		fieldName = RecordSet.getString("fieldname") ;	
	}
	sql="select t1.id from workflow_nodelink t1, workflow_base t2 where t1.wfrequestid is null and t1.workflowid=t2.id and t2.isbill='1' and t2.formid=" + billId + " and t1.condition like '%"+fieldName+"%'";
	RecordSet.execute(sql);
	while(RecordSet.next()){
		nodeLinkIdS += RecordSet.getString("id") + "," ;
	}
}
if(!nodeLinkIdS.equals(""))
	nodeLinkIdS = nodeLinkIdS.substring(0,nodeLinkIdS.lastIndexOf(","));
			
%>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(615,user.getLanguage())+",javascript:frmmain.submit(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/workflow/workflow/BillManagementDetail.jsp?billId=" + billId + ",_self}" ;
RCMenuHeight += RCMenuHeightStep ;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
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
		
				<TABLE width="100%">
                    <tr>
                      <td valign="top">     
                      		<span style="COLOR: RED"><%=SystemEnv.getHtmlLabelName(26946 ,user.getLanguage()) %></span>
                          <%      
                  	
                  	int  perpage=50;                                          
                    String backfields = "id, workflowid, linkname , nodeid , destnodeid";
                    String fromSql  = "from workflow_nodelink ";
                    String sqlWhere = " where id in(" + nodeLinkIdS + ")";  
                    String orderby = "workflowid" ;
                    String tableString = "";  
                  	tableString =" <table instanceid=\"billManagementNodeLinkTable\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_BILLMANAGEFIELDDELCHECK,user.getUID())+"\" >"+
                                         "	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
                                         "			<head>"+                                          
                                         "				<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(2118,user.getLanguage())+"\" column=\"workflowid\" orderkey=\"workflowid\" transmethod=\"weaver.workflow.workflow.WorkflowComInfo.getWorkflowname\" />"+                                   
                                         "				<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15611,user.getLanguage())+"\" column=\"linkname\"  />"+                                              	 
                          				 "				<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15586,user.getLanguage())+"\" column=\"nodeid\"  transmethod=\"weaver.workflow.workflow.WorkFlowFieldTransMethod.getNodeLinkInfo\"  />"+  
                          				 "				<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15074,user.getLanguage())+"\" column=\"destnodeid\"  transmethod=\"weaver.workflow.workflow.WorkFlowFieldTransMethod.getNodeLinkInfo\" />"+  
                                     	 "			</head>"+  
										 "<operates width=\"20%\">"+
                                         "			<operate text=\""+SystemEnv.getHtmlLabelName(2191,user.getLanguage())+"\" href =\"javascript:doShowCondition()\" target=\"_fullwindow\" />" +          
										 "</operates>"+
										 "</table>";                         
                 %>                          
                 <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
              </td>
            </tr>
          </TABLE>
<form id="frmmain" name="frmmain" method="post" action="BillManagementFieldOperation.jsp">
<input id="actionType" name="actionType" type="hidden" value="<%=actionType%>">
<input id="fieldIds" name="fieldIds" type="hidden" value="<%=fieldIds%>">
<input id="billId" name="billId" type="hidden" value="<%=billId%>">
		<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_WORKFLOW_BILLMANAGEFIELDDELCHECK %>"/>
		</form>
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
<body>
</html>
<script language="javaScript">
function doShowCondition(id){
	window.showModalDialog("BrowserMain.jsp?url=showcondition.jsp?fromBillManagement=1&formid=<%=billId%>&isbill=1&linkid="+id,'','dialogHeight:400px;dialogwidth:600px');
}
</script>
