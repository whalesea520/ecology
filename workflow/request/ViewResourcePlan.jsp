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
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />
<%
boolean canview=HrmUserVarify.checkUserRight("ViewRequest:View", user);
boolean canactive=HrmUserVarify.checkUserRight("ViewRequest:Active", user);
boolean isprint = Util.null2String(request.getParameter("isprint")).equals("1")?true:false;//xwj for td2576 20050909
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
int desrequestid=Util.getIntValue(request.getParameter("desrequestid"));
String  isrequest=Util.null2String(request.getParameter("isrequest"));
String logintype = user.getLogintype();
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String currenttime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);
int requestid_vrp = Util.getIntValue((String)session.getAttribute("viewresourceplan"));
String requestname="";
String requestlevel="";
int workflowid=0;
String isbill="1";          //是否单据 0:否 1:是
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
String isurgerStr = Util.null2String(request.getParameter("isurger"));
boolean isurger = false;
if(canview == false){
	if(isurgerStr.equalsIgnoreCase("true")){
		isurger = true;
	}
}

boolean wfmonitor=false;                //流程监控人
wfmonitor=WFUrgerManager.getMonitorViewRight(requestid,userid);

if(!canview && isurger==false && !wfmonitor){
	response.sendRedirect("/notice/noright.jsp");
    	return;
}

RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
RecordSet.next();
formid=RecordSet.getInt("billformid");
billid=RecordSet.getInt("billid");

ArrayList tmpids = new ArrayList();
RecordSet.executeSql("select id from bill_hrmtimedetail where requestid="+requestid+" order by id");
while(RecordSet.next()){
    tmpids.add(RecordSet.getString("id"));
}

int rowindex=0;
String requestmark = "";
String fromFlowDoc = "";

RecordSet.executeProc("workflow_Requestbase_SByID",""+requestid);
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
   requestmark = Util.null2String(RecordSet.getString("requestmark")) ;
}
String workflowname=WorkflowComInfo.getWorkflowname(""+workflowid);
%>
<form name="frmmain" method="post" action="ResourcePlanOperation.jsp">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="<%=nodetype%>">
<input type=hidden name="src" value="active">
<input type=hidden name="iscreate" value="0">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name="billid" value=<%=billid%>>
<input type="hidden" id="requestid" name="requestid" value=<%=requestid%>>
<br>
  <div align="center">
    <font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
  </div>
<br>
	<table class="ViewForm" >
  	<colgroup>
  	<col width="20%">
  	<col width="80%">
  	<!--新建的第一行说明 -->
  	<tr><td class=Line1 colSpan=2></td></tr>
  	<tr>
  		<td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
  		<td class=field>
  			<span id=requestnamespan><%=requestname%></span>&nbsp;&nbsp;&nbsp;&nbsp;
  			<%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%><%}%>
  			<%if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%><%}%>
  			<%if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%><%}%>
  		</td>
  	</tr>
  	<tr><td class=Line1 colSpan=2></td></tr>
  </table>
<%
for(int t=0; t<tmpids.size(); t++){
    boolean canshow=false;
    String tmpdetailid=(String) tmpids.get(t);
    String workstatus="";
    //得到具体数据
    RecordSet.executeSql("select * from bill_hrmtimedetail where id="+tmpdetailid);
    RecordSet.next();
    String detailid=RecordSet.getString("id");
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
    String requestlevelD=RecordSet.getString("requestlevel");
    
    if(resourceid.equals(userid+"")){
    	canshow=true;
    	}else if((","+accepterid+",").indexOf(","+userid+",")!=-1){
    		canshow=true;
    	}else if(isopen.equals("1")){
    		canshow=true;
    	}else if((""+requestid_vrp).equals(""+requestid)){
    		canshow=true;
    	}
    if(!canshow){
    	continue;
    }
    if(nodetype.equals("0"))    workstatus= SystemEnv.getHtmlLabelName(16336,user.getLanguage())  ;
    if(nodetype.equals("3"))    workstatus= SystemEnv.getHtmlLabelName(16337,user.getLanguage())  ;
    if(nodetype.equals("1"))    workstatus= SystemEnv.getHtmlLabelName(1343,user.getLanguage())  ;
    if(nodetype.equals("2")){
    if(currentdate.compareTo(enddate)>0)    
        workstatus= SystemEnv.getHtmlLabelName(16338,user.getLanguage())  ;
    else    
        workstatus= SystemEnv.getHtmlLabelName(16339,user.getLanguage())  ;
    }
    
%>
<input type=hidden name="detailid_<%=rowindex%>" value=<%=detailid%>>
<div>
<!--
<%if((hasright==1||isremark==1)&&deleted==0){%>
<BUTTON class=btnEdit accessKey=E type=button onclick="doEdit()"><U>E</U>-<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></button>
<%}%>
-->
<%if(canactive&&deleted==1){%>
<BUTTON class=btn accessKey=A type=submit><U>A</U>-<%=SystemEnv.getHtmlLabelName(737,user.getLanguage())%></button>
<%}%>
</div>
<br>
    <table class="viewform">
        <COLGROUP> 
    	<COL width="20%"><COL width="15%"><COL width="20%">
    	<COL width="15%"><COL width="15%"><COL width="15%">
	    <TR>
	        <td colspan=6 ><b><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%> <%=rowindex+1%>&nbsp;&nbsp;&nbsp;&nbsp;<%=workstatus%></b></td>
	    </tr>
		<tr ><td colspan=6 class="Line1"></td></tr>
		<tr>
          <td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
          <td class=field colspan=5> <%=Util.toScreen(name,user.getLanguage())%>
          &nbsp;&nbsp;&nbsp;&nbsp;
          <span id=levelspan>
          <%if(requestlevelD.equals("1")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%> <%}%>
          <%if(requestlevelD.equals("2")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%> <%}%>
          <%if(requestlevelD.equals("3")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
          </span>
          </td>  
        </tr>
    <TR  ><TD class=Line2 colSpan=6></TD></TR> 
        
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
          <td class=field><A href="javaScript:openhrm(<%=resourceid%>);" onclick='pointerXY(event);'>
          <%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A> 
          <input type=hidden name="resourceid_<%=rowindex%>" value=<%=resourceid%>>
      </td>
          <td><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></td>
          <td class=field>
          <span id="accepterspan_<%=rowindex%>">
          <%
          ArrayList accepterids=Util.TokenizerString(accepterid,",");
          for(int m=0; m < accepterids.size(); m++){
            String tmpaccepterid=(String) accepterids.get(m);
          %>
          <A href="javaScript:openhrm(<%=tmpaccepterid%>);" onclick='pointerXY(event);'>
          <%=Util.toScreen(ResourceComInfo.getResourcename(tmpaccepterid),user.getLanguage())%></A>&nbsp;
          <%}%>
          </span>
          <input type=hidden name="accepterid_<%=rowindex%>" value=<%=accepterid%>>
          </td>
          <td><%=SystemEnv.getHtmlLabelName(16283,user.getLanguage())%></td>
          <td class=field><input type=checkbox name="isopen_<%=rowindex%>" value='1' disabled <%if(isopen.equals("1")){%> checked <%}%>></td>
        </tr>    <TR  ><TD class=Line2 colSpan=6></TD></TR> 
       <tr> 
          <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
          <td class=field>
          <span id="begindatespan_<%=rowindex%>"><%=begindate%></span>
          <input type=hidden name="begindate_<%=rowindex%>" value="<%=begindate%>">
          </td>
          <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
          <td class=field>
          <span id="begintimespan_<%=rowindex%>"><%=begintime%></span>
          <input type=hidden name="begintime_<%=rowindex%>" value="<%=begintime%>">
          </td>
          <td colspan=2>&nbsp;</td>
        </tr>    <TR  ><TD class=Line2 colSpan=6></TD></TR> <tr>
          <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
          <td class=field>
          <span id="enddatespan_<%=rowindex%>"><%=enddate%></span>
          <input type=hidden name="enddate_<%=rowindex%>" value="<%=enddate%>">
          </td>
          <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
          <td class=field>
          <span id="endtimespan_<%=rowindex%>"><%=endtime%></span>
          <input type=hidden name="endtime_<%=rowindex%>" value="<%=endtime%>">
          </td>
          <td colspan=2>&nbsp;</td>
        </tr>    <TR  ><TD class=Line2 colSpan=6></TD></TR> <tr> 
          <td><%=SystemEnv.getHtmlLabelName(784,user.getLanguage())%></td>
          <td class=field>
          <span id="wakedatespan_<%=rowindex%>"><%=wakedate%></span>
          <input type=hidden name="wakedate_<%=rowindex%>" value="<%=wakedate%>">
          </td>
          <td><%=SystemEnv.getHtmlLabelName(16340,user.getLanguage())%></td>
          <td class=field>
          <span id="delaydatespan_<%=rowindex%>"><%=delaydate%></span>
          <input type=hidden name="delaydate_<%=rowindex%>" value="<%=delaydate%>">
          </td>
          <td colspan=2>&nbsp;</td>
        </tr>    <TR  ><TD class=Line2 colSpan=6></TD></TR> <tr>
            <td><%=SystemEnv.getHtmlLabelName(16284,user.getLanguage())%></td>
            <td colspan=5 class=field><%=Util.toScreen(summary,user.getLanguage())%>
            </td>
        </tr>
		    <TR  ><TD class=Line2 colSpan=6></TD></TR> 
		<tr> 
          <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
          <td class=field>
          <input type=hidden name="projectid_<%=rowindex%>" value="<%=projectid%>">
          <%
			String projectInfoname="<a style='cursor:pointer' href='/proj/data/ViewProject.jsp?ProjID="+projectid+"' target='_blank' \">"+Util.toScreen(ProjectInfoComInfo.getProjectInfoname(projectid),user.getLanguage())+"</a>";
		  %>
          <span id="projectspan_<%=rowindex%>"><%=projectInfoname %></span></td>
          <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
          <td class=field>
          <input type=hidden name="crmid_<%=rowindex%>" value="<%=crmid%>">
          <%
			String customerInfoname="<a style='cursor:pointer' href='/CRM/data/ViewCustomer.jsp?CustomerID="+crmid+"' target='_blank' \">"+Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())+"</a>";
		  %>
          <span id="crmspan_<%=rowindex%>"><%=customerInfoname%></span>
          </td>
          <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
          <td class=field>
          <input type=hidden name="requestid_<%=rowindex%>" value="<%=relatedrequestid%>">
          <%
			String temprequestname="<a style='cursor:pointer' onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?isrequest=1&requestid="+relatedrequestid+"')\">"+RequestComInfo.getRequestname(relatedrequestid)+"</a>";
		  %>
          <span id="requestspan_<%=rowindex%>"><%=temprequestname %></span>
          </td>
        </tr>
             <TR  ><TD class=Line2 colSpan=6></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
        <%
          boolean islight=true;
          ArrayList alldocids=Util.TokenizerString(alldoc,",");
          String showname = "";
          for(int m=0; m < alldocids.size(); m++){
            String tmpdocid=(String) alldocids.get(m);
            String tmpdocname=DocComInfo.getDocname(tmpdocid);
            String tmpownerid=DocComInfo.getDocOwnerid(tmpdocid);
            String tmpownername=ResourceComInfo.getResourcename(tmpownerid);
            showname += "<a href='/docs/docs/DocDsp.jsp?isrequest=1&requestid=" + requestid + "&id="+tmpdocid+"' target='_new'>"+Util.toScreen(tmpdocname,user.getLanguage())+"</a>&nbsp;";
          }%>
          <td colspan=5 class=field><%=showname%></td>    
        </tr> <TR  ><TD class=Line2 colSpan=6></TD></TR>  
    </table>
    
<br><br>
<%
    rowindex++;
}
%>
<%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
  
</form>
 
<script language=javascript>
	function doEdit(){
		document.frmmain.action="ManageRequest.jsp";
		document.frmmain.submit();
	}
</script>
</body>
</html>
