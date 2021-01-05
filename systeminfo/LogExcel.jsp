
<%@ page language="java" contentType="application/vnd.ms-excel; charset=UTF-8" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.general.Util" %>

<jsp:useBean id="SysMaintenanceLog" class="weaver.systeminfo.SysMaintenanceLog" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="companyInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SptmForCowork" class="weaver.splitepage.transform.SptmForCowork" scope="page" />
<jsp:useBean id="SptmForLog" class="weaver.splitepage.transform.SptmForLog" scope="page" />
<jsp:useBean id="Monitor" class="weaver.workflow.monitor.Monitor" scope="page" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style>
<!--
td{font-size:12px}
.title{font-weight:bold;font-size:20px}
-->
</style>

<%
response.setContentType("application/vnd.ms-excel");
response.setHeader("Content-disposition","attachment;filename=logexcel.xls");
User user = HrmUserVarify.getUser (request , response) ;
if(user == null)  return ;
String sql="";
String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
String cmd = Util.null2String(request.getParameter("cmd"));
boolean isLogView = HrmUserVarify.checkUserRight("LogView:View", user);
// 如果是登录日志查看，需要检查是否有登录日志查看的权限 （刘煜修改）
if( (sqlwhere.equals("")||(sqlwhere.indexOf("operateitem=60")>=0)) && !HrmUserVarify.checkUserRight("LogView:View", user))  {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}

				String backFields = "id, relatedName, operateType, lableId, operateUserId, operateDate, operateTime, clientAddress";
				
				String sqlForm = "";
				if(sqlwhere.indexOf("operateitem=60")>=0){
					sqlForm = "HrmSysMaintenanceLog  SysMaintenanceLog, SystemLogItem";
				}else{
					sqlForm = "SysMaintenanceLog, SystemLogItem";
				}
				if(sqlwhere.indexOf("operateitem=85") >= 0 && !isLogView)
				//流程监控需要根据监控列表判断查看范围
				{
				}
				else if(sqlwhere.indexOf("operateitem=91") >= 0)
				{
				    sqlForm += ", WorkPlanMonitor";
				}
								
				String sqlWhere = sqlwhere;
				sqlWhere += " AND SysMaintenanceLog.operateItem = SystemLogItem.itemId";
				if(sqlwhere.indexOf("operateitem=85") >= 0 && !isLogView)
				//流程监控需要根据监控列表判断查看范围
				{
				    //sqlWhere += " AND WorkFlow_Monitor_Bound.monitorHrmId = " + user.getUID() + " AND WorkFlow_Monitor_Bound.workFlowId = SysMaintenanceLog.relatedId";
					String wfidsql = Monitor.getwfidRightSql(user.getUID()+"",RecordSet.getDBType());
					sqlWhere += " and SysMaintenanceLog.relatedId in ("+wfidsql+")";
				}
				else if(sqlwhere.indexOf("operateitem=91") >= 0)
				{
				    sqlWhere += " AND WorkPlanMonitor.hrmId = " + user.getUID() + " AND WorkPlanMonitor.workPlanTypeId = SysMaintenanceLog.relatedId";
				}
				RecordSet.execute("select "+backFields+ " from "+sqlForm+ " " +sqlWhere + " order by id desc ");
				
%>
			   
  <table class=ListStyle border="1">

  <tr class=Header>
  <%if(cmd.equals("sr")){%>
  <th width=15%><%=SystemEnv.getHtmlLabelNames("674,1867", user.getLanguage())%></th>
  <th width=15%><%=SystemEnv.getHtmlLabelName(1276, user.getLanguage())%></th>
  <th width=15%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></th>
  <th width=15%><%=SystemEnv.getHtmlLabelName(101, user.getLanguage())%></th>
  <th width=15%><%=SystemEnv.getHtmlLabelName(106, user.getLanguage())%></th>
  <th width=20%><%=SystemEnv.getHtmlLabelNames("108,110", user.getLanguage())%></th>
  <%}else{%>
  <th width=15%><%=SystemEnv.getHtmlLabelName(97, user.getLanguage())%></th>
  <!--
  <th width=20%><%=SystemEnv.getHtmlLabelName(16017, user.getLanguage())%></th>
  <th width=20%><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></th>
  <th width=10%><%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%></th>
  -->
  <th width=15%><%=SystemEnv.getHtmlLabelName(99, user.getLanguage())%></th>
  <th width=15%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></th>
  <th width=15%><%=SystemEnv.getHtmlLabelName(101, user.getLanguage())%></th>
  <th width=25%><%=SystemEnv.getHtmlLabelName(106, user.getLanguage())%></th>
  <th width=15%><%out.print(SystemEnv.getHtmlLabelName(108,user.getLanguage())+SystemEnv.getHtmlLabelName(110, user.getLanguage()));%></th>
  <%}%>
  </tr>

 <%
  
  while (RecordSet.next()) {%>
  <tr>
  <%if(cmd.equals("sr")){%>
  <td><%=SptmForCowork.getResourceName(RecordSet.getString("operateUserId"))%></td>
  <td><%out.print(RecordSet.getString("operateDate")+" "+RecordSet.getString("operateTime"));%></td>
  <td><%=SptmForCowork.getTypeName(RecordSet.getString("operateType"),""+user.getLanguage())%></td>
  <td><%=SptmForCowork.getItemLableName(RecordSet.getString("lableId"),""+user.getLanguage())%></td>
  <td><%out.print(RecordSet.getString("relatedName"));%></td>
  <td><%out.print(RecordSet.getString("clientAddress"));%></td>
  <%}else{%>
  <td><%out.print(RecordSet.getString("operateDate")+" "+RecordSet.getString("operateTime"));%></td>
    <!--
  <td><%=SptmForLog.getLoginName(RecordSet.getString("operateUserId"))%></td>
  <td><%=SptmForLog.getSubName(RecordSet.getString("operateUserId"))%></td>
  <td><%=SptmForLog.getDepName(RecordSet.getString("operateUserId"))%></td>
  -->
  <td><%=SptmForCowork.getResourceName(RecordSet.getString("operateUserId"))%></td>
  <td><%=SptmForCowork.getTypeName(RecordSet.getString("operateType"),""+user.getLanguage())%></td>
  <td><%=SptmForCowork.getItemLableName(RecordSet.getString("lableId"),""+user.getLanguage())%></td>
  <td><%out.print(RecordSet.getString("relatedName"));%></td>
  <td><%out.print(RecordSet.getString("clientAddress"));%></td>
  <%}%>
  </tr>
  
  <%}%>
  
  </table>


   
