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
<%	//      check user's right about current request operate

boolean canview=HrmUserVarify.checkUserRight("ViewRequest:View", user);
boolean canactive=HrmUserVarify.checkUserRight("ViewRequest:Active", user);

int requestid=Util.getIntValue(request.getParameter("requestid"),0);
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
if(!canview){
	response.sendRedirect("/notice/noright.jsp");
    	return;
}

RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
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

String isreopen="";
String isreject="";
String isendnode="";
RecordSet.executeProc("workflow_Nodebase_SelectByID",nodeid+"");
if(RecordSet.next()){
	isreopen=RecordSet.getString("isreopen");
	isreject=RecordSet.getString("isreject");
	isendnode=RecordSet.getString("isend");
}

RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
RecordSet.next();
formid=RecordSet.getInt("billformid");
billid=RecordSet.getInt("billid");

//具体数据值
RecordSet.executeSql("select * from bill_discuss where requestid="+requestid);
RecordSet.next() ;
String resourceid=RecordSet.getString("resourceid") ;
String accepterid=RecordSet.getString("accepterid") ;
String isend=RecordSet.getString("isend") ;
String name=RecordSet.getString("subject") ;
String projectid=RecordSet.getString("projectid") ;
String crmid=RecordSet.getString("crmid") ;
String relatedrequestid=RecordSet.getString("relatedrequestid") ;
String alldoc=RecordSet.getString("alldoc") ;
%>
<form name="frmmain" method="post" action="BillDiscussOperation.jsp">
<input type="hidden" name="needwfback"  id="needwfback" value="1"/>
<input type=hidden name=isremark >
<input type=hidden name="iscreate" value="0">
<input type=hidden name="src">
<input type=hidden name="nodesnum" >
<input type=hidden name="method" >
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value=<%=nodetype%>>
<input type=hidden name="formid" value=<%=formid%>>
<div>
<BUTTON class=btn accessKey=1 type=button onclick="location.href='RequestView.jsp'"><U>1</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></button>
</div>

<table class="viewform"> 
    <COLGROUP> 
	<COL width="10%"><COL width="25%"><COL width="10%">
	<COL width="25%"><COL width="10%"><COL width="20%">
    <tr class="Spacing"> <td class="Line1" colspan=6></td></tr>  
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
      <td class=field colspan=5> 
        <%=Util.toScreen(name,user.getLanguage())%>
        <input type=hidden name="name" value="<%=Util.toScreenToEdit(name,user.getLanguage())%>">
        <span id=levelspan>
        <%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%> <%}%>
        <%if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%> <%}%>
        <%if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
        </span>
      </td>  
    </tr>
    
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
      <td class=field><A href="javaScript:openhrm(<%=resourceid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A> 
      <input type=hidden name="resourceid" value=<%=resourceid%>>
      </td>
      <td><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></td>
      <td class=field>
      <input type=hidden name="accepterid" value=<%=accepterid%>>
      <span id="accepterspan">
      <%
      ArrayList accepterids=Util.TokenizerString(accepterid,",");
      for(int m=0; m < accepterids.size(); m++){
        String tmpaccepterid=(String) accepterids.get(m);
      %>
      <A href="javaScript:openhrm(<%=tmpaccepterid%>);" onclick='pointerXY(event);'>
      <%=Util.toScreen(ResourceComInfo.getResourcename(tmpaccepterid),user.getLanguage())%></A>&nbsp;
      <%}%>
      <%if(accepterid.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%>
      </span>
      </td>
      <td><%=SystemEnv.getHtmlLabelName(16310,user.getLanguage())%></td>
      <td class=field><input type=checkbox name="isend" value='1' <%if(isend.equals("1")){%> checked <%}%> disabled ></td>
    </tr>
       
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
      <td class=field>
      <input type=hidden name="projectid" value="<%=projectid%>">
      <span id="projectspan"><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(projectid),user.getLanguage())%></span>
      </td>
      <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
      <td class=field>
      <input type=hidden name="crmid" value="<%=crmid%>">
      <span id="crmspan"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%></span>
      </td>
      <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
      <td class=field>
      <input type=hidden name="relatedrequestid" value="<%=relatedrequestid%>">
      <span id="relatedrequestspan"><%=Util.toScreen(RequestComInfo.getRequestname(relatedrequestid),user.getLanguage())%></span>
      </td>
    </tr>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
      <td>&nbsp;</td>    
      <td align=right colspan=4>&nbsp;</td>
    </tr>
    <tr><td colspan=6>
        <table class=liststyle cellspacing=1   width=100%>
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
            <td width="80%"><a href="/docs/docs/DocDsp.jsp?id=<%=tmpdocid%>"><%=Util.toScreen(tmpdocname,user.getLanguage())%></a></td>
            <td width="10%"><a href="javaScript:openhrm(<%=tmpownerid%>);" onclick='pointerXY(event);'><%=Util.toScreen(tmpownername,user.getLanguage())%></a></td>
            <td width="10%" align=right>&nbsp;</td>
        </tr>
        <%  islight=!islight;
          }%>
        </table>
    </td></tr>
</table>

<%@ include file="/workflow/request/WorkflowViewSign.jsp" %>
     
</form>