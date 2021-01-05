<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/weaver_wev8.js"></script>
</head>
<br><br>
<%
    String requestid = Util.null2String(request.getParameter("requestid"));
    /*
    String sql = "select workflowid from workflow_requestLog where requestid="+requestid;
    RecordSet.executeSql(sql);
    if(RecordSet.next()){
        String workflowid = RecordSet.getString("workflowid");
        if("3".equals(workflowid)){
            response.sendRedirect("WorkflowSignPrintLW.jsp?requestid="+requestid);
        }
    }
    */
    RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
    if(RecordSet.next()){
        int workflowid = Util.getIntValue(RecordSet.getString("workflowid"),0);
        String workflowname = WorkflowComInfo.getWorkflowname(workflowid+"");
        workflowname = Util.processBody(workflowname,user.getLanguage()+"");
        //System.out.println("workflowname = " + workflowname);
        %>
        <!--<%=workflowname%>-->
        <%
        if("来文".equals(workflowname)){
            response.sendRedirect("WorkflowSignPrintLW.jsp?requestid="+requestid);
        }else if("发文".equals(workflowname)){
            response.sendRedirect("WorkflowSignPrintFW.jsp?requestid="+requestid);
        }else if("请示".equals(workflowname)){
            response.sendRedirect("WorkflowSignPrintQS.jsp?requestid="+requestid);
        }else if("会议纪要".equals(workflowname)){
            response.sendRedirect("WorkflowSignPrintHYJY.jsp?requestid="+requestid);
        }else if("督办".equals(workflowname)){
            response.sendRedirect("WorkflowSignPrintDB.jsp?requestid="+requestid);
        }else if("报告".equals(workflowname)){
            response.sendRedirect("WorkflowSignPrintBG.jsp?requestid="+requestid);
        }else if("合同审批".equals(workflowname)){
            response.sendRedirect("WorkflowSignPrintHT.jsp?requestid="+requestid);
        }
    }
%>


<table class=ListShort>
  <colgroup> <col width="35%"> <col width="20%"> <col width="20%"> <col width="20%">
  <tbody>
  <tr class=Section>
      <th colspan=4><%=SystemEnv.getHtmlLabelNames("1380,1007",user.getLanguage()) %></th>
    </tr>
    <tr class=separator>
      <td class=Sep1 colspan=4></td>
  </tr>
  <tr class=Header>
  <th><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%></th>
    <th><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></th>
    <th><%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%></th>
    <th><%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></th>
  </tr>
<%
boolean isLight = false;
RecordSet.executeProc("workflow_RequestLog_SNSRemark",""+requestid );
while(RecordSet.next()) {

%>
          <tr <%if(isLight){%> class=datalight <%} else {%> class=datadark  <%}%>>
            <td><%=Util.toScreen(RecordSet.getString("operatedate"),user.getLanguage())%>
              &nbsp<%=Util.toScreen(RecordSet.getString("operatetime"),user.getLanguage())%></td>
            <td>
            <%if(RecordSet.getString("operatortype").equals("0")){%>
	<a href="javaScript:openhrm(<%=RecordSet.getString("operator")%>);" onclick='pointerXY(event);'>
              <%=Util.toScreen(ResourceComInfo.getResourcename(RecordSet.getString("operator")),user.getLanguage())%></a>

<%}else if(RecordSet.getString("operatortype").equals("1")){%>
	<a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=RecordSet.getString("operator")%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(RecordSet.getString("operator")),user.getLanguage())%></a>
<%}else{%>
<%=SystemEnv.getHtmlLabelName(468, user.getLanguage())%>
<%}%>
            </td>
            <td><%=Util.toScreen(RecordSet.getString("nodename"),user.getLanguage())%>
            </td>
            <td>
              <%
	String logtype = RecordSet.getString("logtype");
	if(logtype.equals("9"))
	{
		%>
              <%=SystemEnv.getHtmlLabelName(1006,user.getLanguage())%>
              <%
	}
	else if(logtype.equals("2"))
	{
		%>
              <%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>
              <%
	}
	else if(logtype.equals("3"))
	{
		%>
              <%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>
              <%
	}
	else if(logtype.equals("4"))
	{
		%>
              <%=SystemEnv.getHtmlLabelName(244,user.getLanguage())%>
              <%
	}
	else if(logtype.equals("5"))
	{
		%>
              <%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
              <%
	}
	else if(logtype.equals("6"))
	{
		%>
              <%=SystemEnv.getHtmlLabelName(737,user.getLanguage())%>
              <%
	}

	else if(logtype.equals("0"))
	{
		%>
              <%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%>
              <%
	}
%>
            </td>
          </tr>
          <tr <%if(isLight){%> class=datalight <%} else {%> class=datadark  <%}%>>
            <td colspan="4">
              <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td width="15%"><font color="#FF0000"><%=SystemEnv.getHtmlLabelName(1007, user.getLanguage())%></font></td>
                  <td width="85%">
                    <%if(RecordSet.getString("remark").equals("")){%>
                    &nbsp
                    <%}%>
                    <%=Util.toScreen(RecordSet.getString("remark"),user.getLanguage())%></td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td colspan="4" height=8></td>
          </tr>
          <%
	isLight = !isLight;
}
%>
 </tbody>
</table>
  <br>
 </body>
</html>