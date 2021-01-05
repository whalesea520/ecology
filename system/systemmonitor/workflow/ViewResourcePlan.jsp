<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<%
boolean canview=HrmUserVarify.checkUserRight("ViewRequest:View", user);
boolean canactive=HrmUserVarify.checkUserRight("ViewRequest:Active", user);

int requestid=Util.getIntValue(request.getParameter("requestid"),0);
int start =Util.getIntValue(request.getParameter("start"),1);
String  isrequest=Util.null2String(request.getParameter("isrequest"));
String logintype = user.getLogintype();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String currenttime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);

String requestname="";
String requestlevel="";
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

if(isrequest.equals("1")) canview=true;

if(creater==userid && creatertype==usertype){
	canview=true;
	canactive=true;
}


RecordSet.executeProc("workflow_currentoperator_SByUs",userid+""+flag+""+usertype+flag+requestid+"");
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


RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
RecordSet.next();
formid=RecordSet.getInt("billformid");
billid=RecordSet.getInt("billid");

//得到相关所有工作安排的请求id数据
RecordSet.executeProc("bill_HrmTime_SelectByID",billid+"");
RecordSet.next();
String allrequest=RecordSet.getString("allrequest") ;

ArrayList requestids=Util.TokenizerString(allrequest,",");
int rowindex=0;
%>
<form name="frmmain" method="post" action="ResourcePlanOperation.jsp">
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="<%=nodetype%>">
<input type=hidden name="src" value="active">
<input type=hidden name="iscreate" value="0">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name="billid" value=<%=billid%>>
<%
for(int t=0; t<requestids.size(); t++){
    boolean canshow=false;
    String tmprequestid=(String) requestids.get(t);
    String workstatus="";
    //得到具体数据
    RecordSet.executeSql("select * from bill_hrmtime where requestid="+tmprequestid);
    RecordSet.next();
    String name=RecordSet.getString("name");
    String resourceid=RecordSet.getString("resourceid");
    String accepterid=RecordSet.getString("accepterid");
    String begindate=RecordSet.getString("begindate");
    String begintime=RecordSet.getString("begintime");
    String enddate=RecordSet.getString("enddate");
    String endtime=RecordSet.getString("endtime");
    String wakedate=RecordSet.getString("wakedate");
    String delaydate=RecordSet.getString("delaydate");
    String crmid=RecordSet.getString("crmid");
    String projectid=RecordSet.getString("projectid");
    String relatedrequestid=RecordSet.getString("relatedrequestid");
    String isopen=RecordSet.getString("isopen") ;
    String summary=RecordSet.getString("remark");
    String alldoc=RecordSet.getString("alldoc");
    
    RecordSet.executeProc("workflow_Requestbase_SByID",tmprequestid);
    if(RecordSet.next()){	
    	workflowid=RecordSet.getInt("workflowid");
    	nodeid=RecordSet.getInt("currentnodeid");
    	nodetype=RecordSet.getString("currentnodetype");
    	requestname=RecordSet.getString("requestname");
    	status=RecordSet.getString("status");
    	creater=RecordSet.getInt("creater");
    	deleted=RecordSet.getInt("deleted");
    	creatertype = RecordSet.getInt("creatertype");	
    	requestlevel=RecordSet.getString("requestlevel");
    }
    if(resourceid.equals(userid+""))    canshow=true;
    else    if((","+accepterid+",").indexOf(","+userid+",")!=-1)  canshow=true;
    else    if(isopen.equals("1"))   canshow=true;
    if(!canshow)    continue;
    
    if(nodetype.equals("0"))    workstatus=Util.toScreen("创建任务",user.getLanguage(),"0") ;
    if(nodetype.equals("3"))    workstatus=Util.toScreen("任务已完成",user.getLanguage(),"0") ;
    if(nodetype.equals("1"))    workstatus=Util.toScreen("提交批准",user.getLanguage(),"0") ;
    if(nodetype.equals("2")){
        if(currentdate.compareTo(enddate)>0)    workstatus=Util.toScreen("任务延期",user.getLanguage(),"0") ;
        else    workstatus=Util.toScreen("任务进行中",user.getLanguage(),"0") ;
    }
    
%>
<input type=hidden name="requestid_<%=rowindex%>" value=<%=tmprequestid%>>
<div>
<BUTTON class=btn accessKey=R onClick="location.href='WorkflowMonitor.jsp?start=<%=start%>'"><U>R</U>-返回</BUTTON>
</div>
<br>
    <table class=form>
        <COLGROUP> 
    	<COL width="15%"><COL width="20%"><COL width="15%">
    	<COL width="20%"><COL width="15%"><COL width="15%">
    	<tr class=separator> <td class=Sep1  colspan=6></td></tr>
	    <TR>
	        <td colspan=6 bgcolor=#e7e3bd><b>序号 <%=rowindex+1%>&nbsp;&nbsp;&nbsp;&nbsp;<%=workstatus%></b></td>
	    </tr>
        <tr>
          <td>说明</td>
          <td class=field colspan=5> <%=Util.toScreen(name,user.getLanguage())%>
          &nbsp;&nbsp;&nbsp;&nbsp;
          <span id=levelspan>
          <%if(requestlevel.equals("0")){%>正常 <%}%>
          <%if(requestlevel.equals("1")){%>重要 <%}%>
          <%if(requestlevel.equals("2")){%>紧急 <%}%>
          </span>
          </td>  
        </tr>
        
        <tr> 
          <td>创建人</td>
          <td class=field><A href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>">
          <%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A> 
          <input type=hidden name="resourceid_<%=rowindex%>" value=<%=resourceid%>>
          </td>
          <td>接收人</td>
          <td class=field>
          <span id="accepterspan_<%=rowindex%>">
          <%
          ArrayList accepterids=Util.TokenizerString(accepterid,",");
          for(int m=0; m < accepterids.size(); m++){
            String tmpaccepterid=(String) accepterids.get(m);
          %>
          <A href="/hrm/resource/HrmResource.jsp?id=<%=tmpaccepterid%>">
          <%=Util.toScreen(ResourceComInfo.getResourcename(tmpaccepterid),user.getLanguage())%></A>&nbsp;
          <%}%>
          </span>
          <input type=hidden name="accepterid_<%=rowindex%>" value=<%=accepterid%>>
          </td>
          <td>是否公开</td>
          <td class=field><input type=checkbox name="isopen_<%=rowindex%>" value='1' disabled <%if(isopen.equals("1")){%> checked <%}%>></td>
        </tr>
        
        <tr> 
          <td>开始日期</td>
          <td class=field>
          <span id="begindatespan_<%=rowindex%>"><%=begindate%></span>
          <input type=hidden name="begindate_<%=rowindex%>" value="<%=begindate%>">
          </td>
          <td>开始时间</td>
          <td class=field>
          <span id="begintimespan_<%=rowindex%>"><%=begintime%></span>
          <input type=hidden name="begintime_<%=rowindex%>" value="<%=begintime%>">
          </td>
          <td colspan=2>&nbsp;</td>
        </tr>
        <tr>
          <td>结束日期</td>
          <td class=field>
          <span id="enddatespan_<%=rowindex%>"><%=enddate%></span>
          <input type=hidden name="enddate_<%=rowindex%>" value="<%=enddate%>">
          </td>
          <td>结束时间</td>
          <td class=field>
          <span id="endtimespan_<%=rowindex%>"><%=endtime%></span>
          <input type=hidden name="endtime_<%=rowindex%>" value="<%=endtime%>">
          </td>
          <td colspan=2>&nbsp;</td>
        </tr>
        <tr> 
          <td>提醒日期</td>
          <td class=field>
          <span id="wakedatespan_<%=rowindex%>"><%=wakedate%></span>
          <input type=hidden name="wakedate_<%=rowindex%>" value="<%=wakedate%>">
          </td>
          <td>延期日期</td>
          <td class=field>
          <span id="delaydatespan_<%=rowindex%>"><%=delaydate%></span>
          <input type=hidden name="delaydate_<%=rowindex%>" value="<%=delaydate%>">
          </td>
          <td colspan=2>&nbsp;</td>
        </tr>
        <tr>
            <td>详细说明</td>
            <td colspan=5 class=field><%=Util.toScreen(summary,user.getLanguage())%>
            </td>
        </tr>
        
        <tr> 
          <td>相关项目</td>
          <td class=field>
          <input type=hidden name="projectid_<%=rowindex%>" value="<%=projectid%>">
          <span id="projectspan_<%=rowindex%>"><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(projectid),user.getLanguage())%></span>
          </td>
          <td>相关客户</td>
          <td class=field>
          <input type=hidden name="crmid_<%=rowindex%>" value="<%=crmid%>">
          <span id="crmspan_<%=rowindex%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%></span>
          </td>
          <td>相关流程</td>
          <td class=field>
          <input type=hidden name="requestid_<%=rowindex%>" value="<%=relatedrequestid%>">
          <span id="requestspan_<%=rowindex%>"><%=Util.toScreen(RequestComInfo.getRequestname(relatedrequestid),user.getLanguage())%></span>
          </td>
        </tr>
        
        <tr>
          <td>相关文档</td>
          <td align=right colspan=5>&nbsp;</td>    
        </tr>
        <tr><td colspan=6>
        <table class=ListShort>
        <%
          boolean islight=true;
          ArrayList alldocids=Util.TokenizerString(alldoc,",");
          for(int m=0; m < alldocids.size(); m++){
            String tmpdocid=(String) alldocids.get(m);
            String tmpdocname=DocComInfo.getDocname(tmpdocid);
            String tmpownerid=DocComInfo.getDocOwnerid(tmpdocid);
            String tmpownername=ResourceComInfo.getResourcename(tmpownerid);
        %>
        <tr <%if(islight){%> class=datalight <%} else {%> class=datadark <%}%>>
            <td width="60%"><a href="/docs/docs/DocDsp.jsp?id=<%=tmpdocid%>"><%=Util.toScreen(tmpdocname,user.getLanguage())%></a></td>
            <td width="30%"><a href="/hrm/resource/HrmResource.jsp?id=<%=tmpownerid%>"><%=Util.toScreen(tmpownername,user.getLanguage())%></a></td>
            <td width="10%">&nbsp;</td>
        </tr>
        <%  islight=!islight;
          }%>
        </table>
        </td></tr>
    </table>
    
<%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
<br><br>
<%
    rowindex++;
}
%>
  
</form>
 
<script language=javascript>
	function doEdit(){
		document.frmmain.action="ManageRequest.jsp";
		document.frmmain.submit();
	}
</script>
</body>
</html>
