<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="PlanTypeComInfo" class="weaver.proj.Maint.PlanTypeComInfo" scope="page" />
<jsp:useBean id="PlanSortComInfo" class="weaver.proj.Maint.PlanSortComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<%
boolean canview=HrmUserVarify.checkUserRight("ViewRequest:View", user);
boolean canactive=HrmUserVarify.checkUserRight("ViewRequest:Active", user);

int requestid=Util.getIntValue(request.getParameter("requestid"),0);
String  isrequest=Util.null2String(request.getParameter("isrequest"));
String logintype = user.getLogintype();

String requestname="";
int workflowid=0;
int formid=0;
int billid=0;
int nodeid=0;
String nodetype="";
int userid=user.getUID();
int hasright=0;
String status="";
int creater=0;
int deleted=0;
int isremark=0;
int creatertype = 0;

int usertype = 0;
if(logintype.equals("1"))
	usertype = 0;
if(logintype.equals("2"))
	usertype = 1;
	
char flag=Util.getSeparator() ;

RecordSet.executeProc("workflow_Requestbase_SelectByID",requestid+"");
if(RecordSet.next()){	
	workflowid=RecordSet.getInt("workflowid");
	nodeid=RecordSet.getInt("currentnodeid");
	nodetype=RecordSet.getString("currentnodetype");
	requestname=RecordSet.getString("requestname");
	status=RecordSet.getString("status");
	creater=RecordSet.getInt("creater");
	deleted=RecordSet.getInt("deleted");
	creatertype = RecordSet.getInt("creatertype");	
}

if(isrequest.equals("1")) canview=true;

if(creater==userid && creatertype==usertype){
	canview=true;
	canactive=true;
}


RecordSet.executeProc("workflow_currentoperator_SelectByUserid",userid+""+flag+""+usertype+flag+requestid+"");
if(RecordSet.next())	canview=true;

RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+"and usertype = "+usertype+" and isremark='0'");
if(RecordSet.next()){
	hasright=1;
}

RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+ usertype + " and isremark='1'");
if(RecordSet.next()){
	isremark=1;
}

if(hasright==1 ||isremark==1){
	canview=true;
	canactive=true;
}
if(!canview){
	response.sendRedirect("/notice/noright.jsp");
    	return;
}

RecordSet.executeProc("workflow_form_SelectByRequestid",requestid+"");
RecordSet.next();
formid=RecordSet.getInt("billformid");
billid=RecordSet.getInt("billid");

//得到项目计划数据

RecordSet.executeProc("bill_HrmTime_SelectByID",billid+"");
RecordSet.next();
String projectid=RecordSet.getString("projectid");
String name=RecordSet.getString("name");
String resourceid=RecordSet.getString("resourceid");
String subprojectid=RecordSet.getString("customizeint3");
String plantype=RecordSet.getString("customizeint1");
String plansort=RecordSet.getString("customizeint2");
String begindate=RecordSet.getString("begindate");
String begintime=RecordSet.getString("begintime");
String enddate=RecordSet.getString("enddate");
String endtime=RecordSet.getString("endtime");
String docid=RecordSet.getString("docid");
String budgetmoney=RecordSet.getString("customizefloat1");
String summary=RecordSet.getString("remark");
%>
<form name="frmmain" method="post" action="ProjectPlanOperation.jsp">
<input type=hidden name="requestid" value=<%=requestid%>>
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="<%=nodetype%>">
<input type=hidden name="src" value="active">
<input type=hidden name="iscreate" value="0">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name="billid" value=<%=billid%>>
<div>
<%if((hasright==1||isremark==1)&&deleted==0){%>
<BUTTON class=btnEdit accessKey=E type=button onclick="doEdit()"><U>E</U>-<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></button>
<%}%>
<%if(canactive&&deleted==1){%>
<BUTTON class=btn accessKey=A type=submit><U>A</U>-<%=SystemEnv.getHtmlLabelName(737,user.getLanguage())%></button>
<%}%>
</div>
  <br>
  <table class=form>
    <colgroup> 
    <col width="15%"> <col width="35%">
    <col width="15%"> <col width="35%"> 
    <TR class=separator> 
      <TD class=Sep1 colSpan=4></TD>
    </TR>
    <TR>
          <TD>主题</TD>
          <TD class=Field>
          <%=Util.toScreen(name,user.getLanguage())%>
          <input type=hidden name="name" value="<%=name%>"></TD>
          <TD>员工</TD>
        <TD class=Field>
          <a href="javaScript:openhrm(<%=resourceid%>);" onclick='pointerXY(event);'>
          <%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a>
        </TD>
    </TR>
    <tr>
    	<TD>项目</TD>
        <TD class=Field>
          <a href="/proj/data/ViewProject.jsp?ProjID=<%=projectid%>">
          <%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(projectid),user.getLanguage())%></a>
        </TD>
        <TD>子项目</TD>
        <TD class=Field>
          <a href="/proj/data/ViewProject.jsp?ProjID=<%=subprojectid%>">
          <%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(subprojectid),user.getLanguage())%></a>
        </TD>
    </tr>        
    <TR>
          <TD>计划类型</TD>
          <TD class=Field>
          <a href="/proj/Maint/EditPlanType.jsp?id=<%=plantype%>">
          <%=Util.toScreen(PlanTypeComInfo.getPlanTypename(plantype),user.getLanguage())%></a>
          </TD>
          <TD>计划种类</TD>
          <TD class=Field>
          <a href="/proj/Maint/EditPlanSort.jsp?id=<%=plansort%>">
          <%=Util.toScreen(PlanSortComInfo.getPlanSortname(plansort),user.getLanguage())%></a>
          </TD>
    </TR>
    <tr>
        <TD>起始日期</TD>
          <TD class=Field>
          <%=Util.toScreen(begindate,user.getLanguage())%>
          </td>
        <td>起始时间</td>
           <TD class=Field>
           <%=Util.toScreen(begintime,user.getLanguage())%>
           </TD>
    </tr>
    <tr>
        <TD>结束日期</TD>
          <TD class=Field>
          <%=Util.toScreen(enddate,user.getLanguage())%>
          </td>
        <td>结束时间</td>
           <TD class=Field>
           <%=Util.toScreen(endtime,user.getLanguage())%>
           </TD>
    </tr>
    <tr>
         <td>参考文档</td>
         <td class=field>
         <a href="/docs/docs/DocDsp.jsp?id=<%=docid%>">
         <%=Util.toScreen(DocComInfo.getDocname(docid),user.getLanguage())%></a>
         </td>
         <td>预算金额</td>
           <TD class=Field>
           <%=Util.toScreen(budgetmoney,user.getLanguage())%>
           </TD>
    </tr>
    <tr>
      <td>备注</td>
      <td colspan=3 class=field>
        <%=Util.toScreen(summary,user.getLanguage())%>
      </td>
    </tr>
  </table>

  <br>
  <br>
<%@ include file="/workflow/request/WorkflowViewSign.jsp" %>

</form>
<script language=javascript>
	function doEdit(){
		document.frmmain.action="ManageRequest.jsp";
		document.frmmain.submit();
	}
</script>