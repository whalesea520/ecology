
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type="text/css" rel="STYLESHEET">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
</HEAD>

<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(18463,user.getLanguage());
String needfav ="1";
String needhelp ="";
int userid=user.getUID();
String logintype = user.getLogintype();
int usertype = 0;
if(logintype.equals("2"))
  usertype = 1;
String seclevel = user.getSeclevel();

String agentid = Util.fromScreen(request.getParameter("agentid"),user.getLanguage());


int beagenterId=0;
int agenterId=0;
int isCreateAgenter=0;
int workflowid = 0;
int ispending = 0;
String beginDate="";
String beginTime="";
String endDate="";
String endTime="";
String agentType="1";
  rs.executeSql("select * from Workflow_Agent where agentId = " + agentid);
  if(rs.next()){
    workflowid = rs.getInt("workflowid");
    agenterId=rs.getInt("agenterId");
    ispending = Util.getIntValue(rs.getString("ispending"), 0);
    beginDate=rs.getString("beginDate");
    beginTime=rs.getString("beginTime");
    endDate=rs.getString("endDate");
    endTime=rs.getString("endTime");
    isCreateAgenter=rs.getInt("isCreateAgenter");
    beagenterId = rs.getInt("beagenterId");
    agentType= rs.getString("agenttype");
  }


%>

<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:goBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


  <TABLE class="ViewForm">
  <COLGROUP>
  <COL width="20%">
  <COL width="80%">
  <TBODY>   

  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TD>
    <TD class="Field">
       <%=WorkflowComInfo.getWorkflowname(""+workflowid)%>
    </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>

    <!--被代理人-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17565,user.getLanguage())%></TD>
    <TD class="Field">
      <A href="javaScript:openhrm(<%=beagenterId%>);" onclick='pointerXY(event);'>
        <%=Util.toScreen(ResourceComInfo.getResourcename("" + beagenterId),user.getLanguage())%>
      </A> 
    </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>

    <!--代理人-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17566,user.getLanguage())%></TD>
    <TD class="Field">
       <A href="javaScript:openhrm(<%=agenterId%>);" onclick='pointerXY(event);'>
        <%=Util.toScreen(ResourceComInfo.getResourcename("" + agenterId),user.getLanguage())%>
      </A> 
      </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>

    <!--开始时间-->
  <TR>          
  <TD>
  <%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%>
  </TD>
    <TD class="Field">

         <%=beginDate%> 
         <%=beginTime%>
    
     </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>

    <!--结束时间-->
  <TR>    
  <TD>
  <%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(97,user.getLanguage())%>, <%=SystemEnv.getHtmlLabelName(277,user.getLanguage())%>
  </TD>
    <TD class="Field">
        <%=endDate%> 
         <%=endTime%>
    
     </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR> 

    <!--是否为可创建代理-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(17577,user.getLanguage())%></TD>
    <TD class="Field">
        <%if(isCreateAgenter == 1){
        out.println(SystemEnv.getHtmlLabelName(163,user.getLanguage()));
        }
        else{
        out.println(SystemEnv.getHtmlLabelName(161,user.getLanguage()));
        }%>
      </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
  <!--是否处理待办事宜-->
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(1207,user.getLanguage())%></TD>
    <TD class="Field">
		<INPUT id="ispending" name="ispending" class="InputStyle" type="checkbox" value="1" disabled <%if(ispending==1){out.print("checked");}%> >
		<INPUT id="isPendThing" name="isPendThing" type="hidden" value="<%=ispending%>" >
   </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
  <TR>
    <TD><%=SystemEnv.getHtmlLabelName(15591,user.getLanguage())%></TD>
    <TD class="Field">
    <%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%>
    </TD>
  </TR>
  <TR style="height:1px;"><TD class="Line" colSpan="2"></TD></TR>
  </TBODY>
  </TABLE>



</body>



<script language="JavaScript">
function goBack() {
	document.location.href="/workflow/request/wfAgentList.jsp?agentid=<%=agenterId%>&beagentid=<%=beagenterId%>&agenttype=<%=agentType%>"
}
</script>
</html>
