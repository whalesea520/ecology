
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />
<jsp:useBean id="LocationComInfo" class="weaver.hrm.location.LocationComInfo" scope="page" />
<jsp:useBean id="CapitalComInfo" class="weaver.cpt.capital.CapitalComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSetRight" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="AllManagers" class="weaver.hrm.resource.AllManagers" scope="page"/>
<jsp:useBean id="VerifyPower" class="weaver.proj.VerifyPower" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script LANGUAGE="JavaScript" SRC="/js/checkinput_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>
<%
char flag = 2;
String ProcPara = "";
String taskrecordid = Util.null2String(request.getParameter("taskrecordid"));
RecordSet.executeProc("Prj_TaskProcess_SelectByID",taskrecordid);
RecordSet.next();
String ProjID = RecordSet.getString("prjid");

String logintype = ""+user.getLogintype();
/*权限－begin*/
boolean canview=false;
boolean canedit=false;
boolean iscreater=false;
boolean ismanager=false;
boolean ismanagers=false;
boolean ismember=false;
boolean isrole=false;
boolean isshare=false;
String iscustomer="0";

VerifyPower.init(request,response,ProjID);
if(logintype.equals("1")){
	iscreater = VerifyPower.isCreater();
	ismanager = VerifyPower.isManager();
	if(!ismanager){
		ismanagers = VerifyPower.isManagers();
	}
	if(!ismanagers){
		isrole = VerifyPower.isRole();
	}
	if(!iscreater && !ismanager && !ismanagers && !isrole){
		ismember = VerifyPower.isMember();
	}
	if(!iscreater && !ismanager && !ismanagers && !isrole && !ismember){
		isshare = VerifyPower.isShare();
	}
}else if(logintype.equals("2")){
	iscustomer = VerifyPower.isCustomer();
}
if(iscreater || ismanager || ismanagers || isrole || ismember || isshare || iscustomer.equals("2")){
	canview = true;
}

if(iscreater || ismanager || ismanagers || isrole){
	canedit = true;
}

if(!canview){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
/*权限－end*/

String TaskID = RecordSet.getString("taskid");
String Version = RecordSet.getString("version");

RecordSet2.executeProc("Prj_ProjectInfo_SelectByID",ProjID);
if(RecordSet2.getCounts()<=0)
	response.sendRedirect("/proj/DBError.jsp?type=FindData_VP");
RecordSet2.first();

%>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(367,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(1332,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",/proj/plan/EditTaskProcess.jsp?taskrecordid="+taskrecordid+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/proj/plan/ViewProcess.jsp?ProjID="+RecordSet.getString("prjid")+"&version="+RecordSet.getString("version")+",_self} " ;
RCMenuHeight += RCMenuHeightStep;
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


<TABLE class=viewform>
  <COLGROUP>
  <COL width="49%">
  <COL width="10">
  <COL width="49%">
  <TBODY>
  <TR class=spacing>
    <TD class=line1 colSpan=3></TD>
  </TR>
  <TR>
    <TD vAlign=top>
      <TABLE class=viewform>
      <COLGROUP>
  	  <COL width="30%">
  	  <COL width="70%">
        <TBODY>
        <TR>
          <TD><%=SystemEnv.getHtmlLabelName(1321,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("wbscoding")%></TD>
		</TR> <TR class=spacing>
    <TD class=line colSpan=2></TD>
  </TR>
		<TR>
          <TD><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("subject")%></TD>
         </TR>        
         <TR class=spacing>
    <TD class=line colSpan=2></TD>
  </TR>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(1322,user.getLanguage())%></TD>
          <TD class=Field>
		  <%if(!RecordSet.getString("begindate").equals("x")){%>
				<%=RecordSet.getString("begindate")%>
          <%}%>    
          </TD>
        </TR><TR class=spacing>
    <TD class=line colSpan=2></TD>
  </TR>
        <TR>
        <TD><%=SystemEnv.getHtmlLabelName(1323,user.getLanguage())%></TD>
          <TD class=Field>
		  <%if(!RecordSet.getString("enddate").equals("-")){%>
				<%=RecordSet.getString("enddate")%>
		  <%}%>
          </TD>
         </TR><TR class=spacing>
    <TD class=line colSpan=2></TD>
  </TR>
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("workday")%></TD>
         </TR><TR class=spacing>
    <TD class=line colSpan=2></TD>
  </TR>
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(1325,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("fixedcost")%></TD>
         </TR><TR class=spacing>
    <TD class=line colSpan=2></TD>
  </TR>
         <TR>
         <TD><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></TD>
          <TD class=Field><%=RecordSet.getString("finish")%>%</TD>
         </TR><TR class=spacing>
    <TD class=line colSpan=2></TD>
  </TR>
	  </TABLE>
	</TD>
	<TD></TD>
	<TD vAlign=top>
	 <TABLE class=viewform>
      <COLGROUP>
  	  <COL width="100%">
         <TR>
           <TD ><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TD>
		 </TR>
		 <TR>
           <TD class=Field><%=RecordSet.getString("content")%></TD>
         </TR><TR class=spacing>
    <TD class=line ></TD>
  </TR>
     </TABLE>
	</TD>
   </TR>
   </TBODY>
</TABLE>
      <TABLE class=liststyle cellspacing=1 >
        <TBODY>
        <TR class=header>
          <TH colSpan=6><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></TH>
          <TD align=right colSpan=2>
	<%if(canedit){%>
		  <A             href="/proj/plan/AddProjMemberProcess.jsp?taskrecordid=<%=taskrecordid%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>
	<%}%>
		  </TD></TR>
        <TR class=Header>
          <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(640,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(481,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(617,user.getLanguage())%></TD>
          <TD width=70><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></TD></TR>
      
        <TR class=line>
          <TD colSpan=8></TD></TR>
<%
	ProcPara = ProjID;
	ProcPara += flag+TaskID;
RecordSet.executeProc("Prj_Find_MemberProcess",ProcPara);
while(RecordSet.next())
{
String relateid = RecordSet.getString("relateid");
String jobtitle = JobTitlesComInfo.getJobTitlesname(ResourceComInfo.getJobTitle(relateid));
String departid =ResourceComInfo.getDepartmentID(relateid);
%>
        <TR class=DataDark>          
          <TD><a href="/hrm/resource/HrmResource.jsp?id=<%=relateid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(relateid),user.getLanguage())%></a>
          </TD>
          <TD><%=jobtitle%></TD>
          <TD><a href="/hrm/company/HrmDepartmentDsp.jsp?id=<%=departid%>"><%=Util.toScreen(DepartmentComInfo.getDepartmentname(departid),user.getLanguage())%></a></TD>
          <TD><%=RecordSet.getString("workday")%></TD>
          <TD>
		  <%if(!RecordSet.getString("begindate").equals("x")){%>
				<%=RecordSet.getString("begindate")%>
          <%}%> 	
		  </TD>
          <TD>
		  <%if(!RecordSet.getString("enddate").equals("-")){%>
				<%=RecordSet.getString("enddate")%>
		  <%}%>
		  </TD>
          <TD>
	<%if(canedit){%>
		  <a href="EditProjMemberProcess.jsp?taskrecordid=<%=taskrecordid%>&recordid=<%=RecordSet.getString("id")%>"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></a>
	<%}%>
		  </TD>
        </TR> <TR class=spacing>
          <TD class=line1 colSpan=8></TD></TR>
<%}%>
		</TBODY>
	</TABLE>

      <TABLE class=liststyle cellspacing=1 >
        <TBODY>
        <TR class=header>
          <TH colSpan=6><%=SystemEnv.getHtmlLabelName(1326,user.getLanguage())%></TH>
          <TD align=right colSpan=2>
	<%if(canedit){%>
		  <A             href="/proj/plan/AddProjToolProcess.jsp?taskrecordid=<%=taskrecordid%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>
	<%}%>
		  </TD></TR>
  
        <TR class=Header>
          <TD><%=SystemEnv.getHtmlLabelName(714,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1327,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1324,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(481,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(617,user.getLanguage())%></TD>
          <TD  width=70><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></TD></TR>
        <TR class=line>
          <TD colSpan=8></TD></TR>
<%
	ProcPara = ProjID;
	ProcPara += flag+TaskID;
RecordSet.executeProc("Prj_Find_ToolProcess",ProcPara);
while(RecordSet.next())
{
String relateid = RecordSet.getString("relateid");
String toolcode = CapitalComInfo.getMark(relateid);
String toolname = CapitalComInfo.getCapitalname(relateid);
%>
        <TR class=DataDark>          
          <TD><%=toolcode%>
          </TD>
          <TD><a href="/cpt/capital/CptCapital.jsp?id=<%=relateid%>"><%=toolname%></a></TD>
          <TD><%=RecordSet.getString("cost")%></TD>
          <TD><%=RecordSet.getString("workday")%></TD>
          <TD>
		  <%if(!RecordSet.getString("begindate").equals("x")){%>
				<%=RecordSet.getString("begindate")%>
          <%}%> 	
		  </TD>
          <TD>
		  <%if(!RecordSet.getString("enddate").equals("-")){%>
				<%=RecordSet.getString("enddate")%>
		  <%}%>
		  </TD>
          <TD>
	<%if(canedit){%>
		  <a href="EditProjToolProcess.jsp?taskrecordid=<%=taskrecordid%>&recordid=<%=RecordSet.getString("id")%>"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></a>
	<%}%>
		  </TD>
        </TR>
<%}%>
		</TBODY>
	</TABLE>

      <TABLE class=liststyle cellspacing=1 >
        <TBODY>
        <TR class=header>
          <TH colSpan=3><%=SystemEnv.getHtmlLabelName(1328,user.getLanguage())%></TH>
          <TD align=right colSpan=2>
	<%if(canedit){%>
		  <A             href="/proj/plan/AddProjMaterialProcess.jsp?taskrecordid=<%=taskrecordid%>"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>
    <%}%>
		  </TD></TR>

        <TR class=Header>
          <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1329,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1330,user.getLanguage())%></TD>
          <TD><%=SystemEnv.getHtmlLabelName(1331,user.getLanguage())%></TD>
          <TD width=70><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></TD></TR>
              <TR class=line>
          <TD  colSpan=5></TD></TR>
<%
	ProcPara = ProjID;
	ProcPara += flag+TaskID;
RecordSet.executeProc("Prj_Find_MaterialProcess",ProcPara);
while(RecordSet.next())
{
%>
        <TR class=DataDark>          
          <TD><%=RecordSet.getString("material")%></TD>
          <TD><%=RecordSet.getString("unit")%></TD>
          <TD><%=RecordSet.getString("cost")%></TD>
          <TD><%=RecordSet.getString("quantity")%></TD>
          <TD>
	<%if(canedit){%>
		  <a href="EditProjMaterialProcess.jsp?taskrecordid=<%=taskrecordid%>&recordid=<%=RecordSet.getString("id")%>"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></a>
	<%}%>
		  </TD>
        </TR>
<%}%>
		</TBODY>
	</TABLE>
<%
String topage=URLEncoder.encode( "/proj/plan/RequestOperation.jsp?method=add&ProjID="+ProjID+"&taskid="+TaskID+"&version=1000&isactived=1&type=2&taskrecordid="+taskrecordid);			  
%>
      <TABLE class=liststyle cellspacing=1 >
	<form name=workflow method=post action="/workflow/request/RequestType.jsp">
	<input type=hidden name=topage value='<%=topage%>'>
	<input type=hidden name=prjid value='<%=ProjID%>'>
	</form>
        <TBODY>
        <TR class=header>
          <TH colSpan=4><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></TH>
          <TD align=right colSpan=2>
		  <A href="javascript:document.workflow.submit();"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>
		  </TD></TR>
 
        <TR class=Header>
          <th><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1335,user.getLanguage())%></th>
		</TR>       <TR class=line>
          <TD  colSpan=6></TD></TR>
      
<%
String CurrentUser = ""+user.getUID();
int usertype = 0;
if(logintype.equals("2"))
	usertype= 1;
String sql="select distinct t1.requestid, t1.createdate, t1.creater,t1.creatertype, t1.workflowid, t1.requestname, t1.status from workflow_requestbase t1,workflow_currentoperator t2, Prj_Request t3 ";
String sqlwhere=" where t1.requestid = t2.requestid and t2.userid = "+CurrentUser+" and t2.usertype=" + usertype + " and t1.requestid = t3.requestid  and (t3.type = '1' or t3.type = '2') and t3.prjid = "+ProjID+" and t3.taskid = "+TaskID+" and t3.version <= '1000' ";
String orderby=" order by t1.createdate desc ";
sql=sql+sqlwhere+orderby;
RecordSet.executeSql(sql);
while(RecordSet.next())
{
	String requestid=RecordSet.getString("requestid");
	String createdate=RecordSet.getString("createdate");
	String creater=RecordSet.getString("creater");
	String creatertype=RecordSet.getString("creatertype");
	String creatername=ResourceComInfo.getResourcename(creater);
	String workflowid=RecordSet.getString("workflowid");
	String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
	String requestname=RecordSet.getString("requestname");
	String status=RecordSet.getString("status");
%>
    <tr class=datadark>
      <td><%=Util.toScreen(createdate,user.getLanguage())%></td>
      <td>
      <%if(creatertype.equals("0")){%>
      <a href="/hrm/resource/HrmResource.jsp?id=<%=creater%>"><%=Util.toScreen(creatername,user.getLanguage())%></a>
      <%}else if(creatertype.equals("1")){%>
      <a href="/CRM/data/ViewCustomer.jsp?CustomerID=<%=creater%>"><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(creater),user.getLanguage())%></a>
      <%}else{%>
      <%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%>
      <%}%>
      </td>
      <td><%=Util.toScreen(workflowname,user.getLanguage())%></td>
      <td><a href="/workflow/request/ViewRequest.jsp?requestid=<%=requestid%>"><%=Util.toScreen(requestname,user.getLanguage())%></a></td>
      <td><%=Util.toScreen(createdate,user.getLanguage())%></td>
      <td><%=Util.toScreen(status,user.getLanguage())%></td>
       </tr>

<%}%>
		</TBODY>
	</TABLE>
<%
topage=URLEncoder.encode( "/proj/plan/DocOperation.jsp?method=add&ProjID="+ProjID+"&taskid="+TaskID+"&version="+Version+"&isactived=0&type=1&taskrecordid="+taskrecordid);			  
%>
      <TABLE class=liststyle cellspacing=1 >
	<form name=doc method=post action="/docs/docs/DocList.jsp">
	<input type=hidden name=topage value='<%=topage%>'>
	<input type=hidden name=prjid value='<%=ProjID%>'>
	</form>
        <TBODY>
        <TR class=header>
          <TH colSpan=2><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></TH>
          <TD align=right colSpan=1>
		  <A href="javascript:document.doc.submit();"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></A>
		  </TD></TR>
 
        <TR class=Header>
          <th><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></th>
		  <th><%=SystemEnv.getHtmlLabelName(1341,user.getLanguage())%></th>
		</TR>       <TR class=line>
          <TD  colSpan=3></TD></TR>
      
<%

sql="SELECT t1.id, t1.docsubject, t1.ownerid, t1.doccreatedate, t1.doccreatetime FROM DocDetail  t1, docuserview t2, Prj_Doc t3 ";
sqlwhere=" where t1.id = t2.docid and t2.userid = "+CurrentUser + " and t1.id = t3.docid  and (t3.type = '1' or t3.type = '2') and t3.prjid = "+ProjID+" and t3.taskid = "+TaskID+" and t3.version <= 1000" ;
orderby=" ORDER BY t1.id DESC ";
sql=sql+sqlwhere+orderby;
RecordSet.executeSql(sql);
while(RecordSet.next())
{
	String id=RecordSet.getString("id");
	String createdate=RecordSet.getString("doccreatedate");
	String createtime=RecordSet.getString("doccreatetime");
	String ownerid=RecordSet.getString("ownerid");
	String docsubject=RecordSet.getString("docsubject");
%>
    <tr class=datadark>
      <td><%=Util.toScreen(createdate,user.getLanguage())%>&nbsp<%=Util.toScreen(createtime,user.getLanguage())%></td>
      <td>
      <a href="/hrm/resource/HrmResource.jsp?id=<%=ownerid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(ownerid),user.getLanguage())%></a>
      </td>
      <td><a href="/docs/docs/DocDsp.jsp?id=<%=id%>"><%=Util.toScreen(docsubject,user.getLanguage())%></a></td>
       </tr>

<%}%>
		</TBODY>
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

</BODY>
</HTML>
