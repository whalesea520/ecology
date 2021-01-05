<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="docinfplan" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfoplan" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfoplan" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
<%	//      check user's right about current request operate
int languagebodyid = user.getLanguage() ;
int requestid=Util.getIntValue(request.getParameter("requestid"),0);
String  isrequest=Util.null2String(request.getParameter("isrequest"));
String logintype = user.getLogintype();

String requestmark=Util.null2String(request.getParameter("requestmark"));
String workflowtype=Util.null2String(request.getParameter("workflowtype"));
String docfileid=Util.null2String(request.getParameter("docfileid"));
String newdocid=Util.null2String(request.getParameter("newdocid"));
String topage=Util.null2String(request.getParameter("topage"));

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
Date newdate = new Date() ;
long datetime = newdate.getTime() ;
Timestamp timestamp = new Timestamp(datetime) ;
String currentdate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
String currenttime = (timestamp.toString()).substring(11,13) +":" +(timestamp.toString()).substring(14,16)+":"+(timestamp.toString()).substring(17,19);
String username = "";
if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

int lastOperator=0;
String lastOperateDate="";
String lastOperateTime="";

lastOperator=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"lastOperator"),0);
lastOperateDate=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"lastOperateDate"));
lastOperateTime=Util.null2String((String)session.getAttribute(userid+"_"+requestid+"lastOperateTime"));

char flag=Util.getSeparator() ;

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

String iscreate = "0";
if(nodetype.equals("0")) iscreate = "1";

RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+"and usertype = "+usertype+" and isremark='0'");
if(RecordSet.next())	hasright=1;

RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+ usertype + " and isremark='1'");
if(RecordSet.next()){
	isremark=1;
}

if(hasright==0&&isremark==0){
	//response.sendRedirect("/notice/noright.jsp");
	%>
	 <script language="javascript">
	    window.onload = function (){
		   document.getElementById("frmmain").style.display="none";
	       window.parent.location.href="/notice/noright.jsp";
	   }  
	 </script>
	<%
    //return;
}

RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
RecordSet.next();
formid=RecordSet.getInt("billformid");

RecordSet.executeSql("select id from bill_hrmtime where requestid="+requestid);
RecordSet.next();
billid=RecordSet.getInt("id");

ArrayList tmpids = new ArrayList();
RecordSet.executeSql("select id from bill_hrmtimedetail where requestid="+requestid+" order by id");
while(RecordSet.next()){
    tmpids.add(RecordSet.getString("id"));
}

int rowindex=0;
String needcheck="";
String thisnodetype=nodetype;

int fieldop1id=0;
String strFieldId = null;
String strFieldName = null;
String strCustomerValue = null;
String strManagerId = null;
String strUnderlings = null;
Hashtable inoperatefield_hs = new Hashtable();
Hashtable inoperatevalue_hs = new Hashtable();
rsaddop.executeSql("select a.fieldid, a.customervalue, a.fieldop1id, b.fieldname from workflow_addinoperate a, workflow_billfield b where a.fieldid=b.id and a.workflowid=" + workflowid + " and a.ispreadd='1' and a.isnode = 1 and a.objid = "+nodeid);
while(rsaddop.next()){
    //inoperatefields.add(rsaddop.getString("fieldid"));
    //inoperatevalues.add(rsaddop.getString("customervalue"));
	strFieldId = Util.null2String(rsaddop.getString("fieldid"));
	strFieldName = Util.null2String(rsaddop.getString("fieldname"));
	strCustomerValue = Util.null2String(rsaddop.getString("customervalue"));
	fieldop1id = Util.getIntValue(rsaddop.getString("fieldop1id"),0);
	if(fieldop1id == -3){
		strManagerId = "";
		rscount.executeSql("select managerId from HrmResource where id="+userid);
		if(rscount.next()){
			strManagerId = Util.null2String(rscount.getString("managerId"));
		}
		inoperatefield_hs.put("field_"+strFieldName, strFieldId);
		inoperatevalue_hs.put("field_"+strFieldName, strManagerId);
	}else if(fieldop1id == -4){
		strUnderlings = "";
		rscount.executeSql("select id from HrmResource where managerId="+userid+" and status in(0,1,2,3)");
		while(rscount.next()){
			strUnderlings += ","+Util.null2String(rscount.getString("id"));
		}
		if(!strUnderlings.equals("")){
			strUnderlings = strUnderlings.substring(1);
		}
		inoperatefield_hs.put("field_"+strFieldName, strFieldId);
		inoperatevalue_hs.put("field_"+strFieldName, strUnderlings);
	}else{
		inoperatefield_hs.put("field_"+strFieldName, strFieldId);
		inoperatevalue_hs.put("field_"+strFieldName, strCustomerValue);
	}
}
String field_accepterid = Util.null2String((String)inoperatefield_hs.get("field_accepterid"));
String accepterid_tmp = Util.null2String((String)inoperatevalue_hs.get("field_accepterid"));
String accepteridStr = "";
if("".equals(field_accepterid)){
	accepterid_tmp = ""+userid;
	accepteridStr = "<A href='javaScript:openhrm("+accepterid_tmp+");' onclick='pointerXY(event);'>"+Util.toScreen(ResourceComInfo.getResourcename(accepterid_tmp), user.getLanguage())+"</A>&nbsp;";
}else{
	String[] accepterids = Util.TokenizerString2(accepterid_tmp, ",");
	for(int i=0; i<accepterids.length; i++){
		accepteridStr += "<A href='javaScript:openhrm("+accepterids[i]+");' onclick='pointerXY(event);'>"+Util.toScreen(ResourceComInfo.getResourcename(accepterids[i]), user.getLanguage())+"</A>&nbsp;";
	}
	if("".equals(accepterid_tmp)){
		accepteridStr = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	}
}
String field_begindate = Util.null2String((String)inoperatefield_hs.get("field_begindate"));
String begindate_tmp = Util.null2String((String)inoperatevalue_hs.get("field_begindate"));
String begindateStr = "";
if("".equals(field_begindate)){
	begindate_tmp = currentdate;
	begindateStr = currentdate;
}else{
	begindateStr = begindate_tmp;
	if("".equals(begindate_tmp)){
		begindateStr = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	}
}

String isreopen="";
String isreject="";
String isend="";
RecordSet.executeProc("workflow_Nodebase_SelectByID",nodeid+"");
if(RecordSet.next()){
    isreopen=RecordSet.getString("isreopen");
    isreject=RecordSet.getString("isreject");
    isend=RecordSet.getString("isend");
}
String isannexupload_edit="";
String annexdocCategory_edit="";
String isSignDoc_edit="";
String isSignWorkflow_edit="";
RecordSet.execute("select isannexupload,annexdocCategory,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isannexupload_edit=Util.null2String(RecordSet.getString("isannexupload"));
    annexdocCategory_edit=Util.null2String(RecordSet.getString("annexdocCategory"));
    isSignDoc_edit=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_edit=Util.null2String(RecordSet.getString("isSignWorkflow"));
}
String workflowname=WorkflowComInfo.getWorkflowname(""+workflowid);
%>
<form name="frmmain" method="post" action="ResourcePlanOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
<input type="hidden" name="lastOperator"  id="lastOperator" value="<%=lastOperator%>"/>
<input type="hidden" name="lastOperateDate"  id="lastOperateDate" value="<%=lastOperateDate%>"/>
<input type="hidden" name="lastOperateTime"  id="lastOperateTime" value="<%=lastOperateTime%>"/>
<input type="hidden" name="htmlfieldids">
<input type=hidden name=requestid value="<%=requestid%>">
<input type=hidden name=requestlevel value="<%=requestlevel%>">
<input type=hidden name=isremark >
<input type=hidden name="iscreate" value="0">
<input type=hidden name="src">
<input type=hidden name="nodesnum" >
<input type=hidden name="method" >
<input type=hidden name="relatedrow" >
<input type=hidden name="saverow" >
<input type=hidden name="billid" value=<%=billid%>>
<br>
  <div align="center">
    <font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
  </div>
<br>
<%if(nodetype.equals("0")){%>
  <input type=hidden name="workflowid" value=<%=workflowid%>>
  <input type=hidden name="nodeid" value=<%=nodeid%>>
  <input type=hidden name="nodetype" value=<%=nodetype%>>
  <input type=hidden name="formid" value=<%=formid%>>
  
  <table class="ViewForm" >
  	<colgroup>
  	<col width="20%">
  	<col width="80%">
  	<!--新建的第一行说明 -->
  	<tr><td class=Line1 colSpan=2></td></tr>
  	<tr>
  		<td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
  		<td class=field>
  			<input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan')" size=60  maxlength=100  value = "<%=requestname%>" >
  			<span id=requestnamespan></span>
  			<input type=radio value="0" name="requestlevel" <%if(requestlevel.equals("0")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
  			<input type=radio value="1" name="requestlevel" <%if(requestlevel.equals("1")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
  			<input type=radio value="2" name="requestlevel" <%if(requestlevel.equals("2")){%>checked<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
  		</td>
  	</tr>
  	<tr><td class=Line1 colSpan=2></td></tr>
  </table>
  
  <!--
  <div>
    <BUTTON class=btn accessKey=B type=button id="planDoSubmit" onclick="doSubmit2(-1)"><U>B</U>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button>
    <BUTTON class=btnSave accessKey=S type=button id="planDoSave" onclick="doSave2(-1)"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button>
    <BUTTON class=btnDelete accessKey=D type=button id="planDoDelete" onclick="if(isdel()){location.href='ResourcePlanOperation.jsp?src=deleteall&requestid=<%=requestid%>'}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(16335,user.getLanguage())%></button>
  </div>
  -->
  <br>
  <table class="viewform">
    <tr><td>
		<BUTTON Class=Btn type=button onclick="addRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
		<BUTTON Class=Btn type=button onclick="deleteRow();"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
    </td></tr>
    <tr class="Spacing"> <td class="Line1"></td></tr>
    <tr><td width="100%">
    <table class="viewform" cols=6 id="oTable">
    <tr><td></td></tr>
    <%
    String strDocId = "";
    for(int t=0; t<tmpids.size(); t++){
        boolean canshow=false;
        boolean canedit=false;
        boolean showbutton=false;
        String tmpid=(String) tmpids.get(t);
        String workstatus="";
        //得到具体数据
        RecordSet.executeSql("select * from bill_hrmtimedetail where id="+tmpid);
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
        if( !"".equals(alldoc)){
          strDocId += ("," + alldoc);
        }
        String reqlevelD=RecordSet.getString("requestlevel");

        //RecordSet.executeProc("workflow_Requestbase_SByID",""+requestid);
        //if(RecordSet.next())
        //	requestlevel=RecordSet.getString("requestlevel");

        workstatus= SystemEnv.getHtmlLabelName(16336,user.getLanguage())  ;
    %>
    <tr><td><div>
    <input type=hidden name="detailid_<%=rowindex%>" value=<%=detailid%>>
    <table class="viewform">
        <COLGROUP>
    	<COL width="20%"><COL width="15%"><COL width="20%">
    	<COL width="15%"><COL width="15%"><COL width="15%">
	    <TR>
	        <td colspan=6 ><b><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%> <%=rowindex+1%>&nbsp;&nbsp;&nbsp;&nbsp;<%=workstatus%></b></td>
	    </tr>
        <tr>
          <td><input type=checkbox name="check_plan" value="<%=rowindex%>"> <%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
          <td class=field colspan=5>
            <input type=text class=inputstyle  name="name_<%=rowindex%>" value="<%=Util.toScreenToEdit(name,user.getLanguage())%>" onChange="checkinput1(name_<%=rowindex%>,namespan_<%=rowindex%>)" size=50 maxlength=25>
            <span id="namespan_<%=rowindex%>"><%if(name.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
            <input type=radio value="1" name="requestlevel_<%=rowindex%>" <%if(reqlevelD.equals("1")){%> checked <%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
            <input type=radio value="2" name="requestlevel_<%=rowindex%>" <%if(reqlevelD.equals("2")){%> checked <%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
            <input type=radio value="3" name="requestlevel_<%=rowindex%>" <%if(reqlevelD.equals("3")){%> checked <%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
          </td>
        </tr>
        <TR><TD class=Line2 colSpan=6></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
          <td class=field>
          <A href="javaScript:openhrm(<%=resourceid%>);" onclick='pointerXY(event);'>
          <%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A>
          <input type=hidden name="resourceid_<%=rowindex%>" value=<%=resourceid%>>
          </td>
          <td><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></td>
          <td class=field>
          <button class=browser onclick="onShowResource(accepterid_<%=rowindex%>,accepterspan_<%=rowindex%>)"></button>
          <span id="accepterspan_<%=rowindex%>">
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
          <input type=hidden name="accepterid_<%=rowindex%>" value=<%=accepterid%>>
          </td>
          <td><%=SystemEnv.getHtmlLabelName(16283,user.getLanguage())%></td>
          <td class=field><input type=checkbox name="isopen_<%=rowindex%>" value='1' <%if(isopen.equals("1")){%> checked <%}%>>
          </td>
        </tr>
        <TR><TD class=Line2 colSpan=6></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
          <td class=field>
          <button class=Calendar onclick="onShowDate(begindatespan_<%=rowindex%>,begindate_<%=rowindex%>)"></button>
          <span id="begindatespan_<%=rowindex%>"><%=begindate%><%if(begindate.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
          <input type=hidden name="begindate_<%=rowindex%>" value="<%=begindate%>">
          </td>
          <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
          <td class=field>
          <button class=Calendar onclick="onShowTime(begintimespan_<%=rowindex%>,begintime_<%=rowindex%>)"></button>
          <span id="begintimespan_<%=rowindex%>"><%=begintime%></span>
          <input type=hidden name="begintime_<%=rowindex%>" value="<%=begintime%>">
          </td>
          <td colspan=2>&nbsp;</td>
        </tr><TR><TD class=Line2 colSpan=6></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
          <td class=field>
          <button class=Calendar onclick="onShowDate(enddatespan_<%=rowindex%>,enddate_<%=rowindex%>)"></button>
          <span id="enddatespan_<%=rowindex%>"><%=enddate%><%if(enddate.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
          <input type=hidden name="enddate_<%=rowindex%>" value="<%=enddate%>">
                    </td>
          <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
          <td class=field>
          <button class=Calendar onclick="onShowTime(endtimespan_<%=rowindex%>,endtime_<%=rowindex%>)"></button>
          <span id="endtimespan_<%=rowindex%>"><%=endtime%></span>
          <input type=hidden name="endtime_<%=rowindex%>" value="<%=endtime%>">
          </td>
          <td colspan=2>&nbsp;</td>
        </tr><TR><TD class=Line2 colSpan=6></TD></TR>
        <tr>
            <td><%=SystemEnv.getHtmlLabelName(16284,user.getLanguage())%></td>
            <td colspan=5 class=field>
            <script>document.getElementById("htmlfieldids").value += "summary_<%=rowindex%>;<%=Util.toScreen(SystemEnv.getHtmlLabelName(16284,user.getLanguage()),languagebodyid)%>,";</script>
            <textarea class=inputstyle  name="summary_<%=rowindex%>" style="width:80%" rows=5
            onchange=checkinput1(summary_<%=rowindex%>,summaryspan_<%=rowindex%>)><%=Util.toScreenToEdit(summary,user.getLanguage())%></textarea>
            <span id="summaryspan_<%=rowindex%>"><%if(summary.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
            </td>
        </tr>
        <TR><TD class=Line2 colSpan=6></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
          <td class=field>
          <button class=browser onclick="onShowProject(projectid_<%=rowindex%>,projectspan_<%=rowindex%>)"></button>
          <input type=hidden name="projectid_<%=rowindex%>" value="<%=projectid%>">
          <span id="projectspan_<%=rowindex%>">
          <a href='/proj/data/ViewProject.jsp?ProjID=<%=projectid%>' target='_blank'><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(projectid),user.getLanguage())%></a></span>
          </td>
          <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
          <td class=field>
          <button class=browser onclick="onShowCRM(crmid_<%=rowindex%>,crmspan_<%=rowindex%>)"></button>
          <input type=hidden name="crmid_<%=rowindex%>" value="<%=crmid%>">
          <span id="crmspan_<%=rowindex%>">
          <a href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=crmid%>' target='_blank'><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%></a></span>
          </td>
          <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
          <td class=field>
          <button class=browser onclick="onShowRequest(relatedrequestid_<%=rowindex%>,relatedrequestspan_<%=rowindex%>)"></button>
          <input type=hidden name="relatedrequestid_<%=rowindex%>" value="<%=relatedrequestid%>">
          <span id="relatedrequestspan_<%=rowindex%>">
          <a href='/workflow/request/ViewRequest.jsp?requestid=<%=relatedrequestid%>' target='_blank'><%=Util.toScreen(RequestComInfo.getRequestname(relatedrequestid),user.getLanguage())%></a></span>
          </td>
        </tr><TR><TD class=Line2 colSpan=6></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
          <td colSpan=5 class=field><button class=AddDoc onclick="onAddDoc(<%=rowindex%>)" > <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>&nbsp;&nbsp<button class=AddDoc onclick="onNewDoc(<%=rowindex%>)" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
		  
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
          &nbsp;&nbsp;<span><%=showname%></span></td>
        	</TR>
        	<TR><TD class=Line2 colSpan=6></TD></TR>
    </table><br><br>
    </div></td></tr>
    <%
    rowindex++;
    }
    
    if(!"".equals(strDocId)){
      strDocId = strDocId.substring(1);
    }
    %>
    <input type="hidden" name="field184" value="<%=strDocId%>">
    </table>
    </td></tr>
  </table>
<%} else { %>
  <input type=hidden name="requestid" value=<%=requestid%>>
  <input type=hidden name="workflowid" value=<%=workflowid%>>
  <input type=hidden name="nodeid" value=<%=nodeid%>>
  <input type=hidden name="nodetype" value=<%=nodetype%>>
  <input type=hidden name="formid" value=<%=formid%>>
  <input type=hidden name="isreject">
  
  <table class="ViewForm" >
  	<colgroup>
  	<col width="20%">
  	<col width="80%">
  	<!--新建的第一行说明 -->
  	<tr><td class=Line1 colSpan=2></td></tr>
  	<tr>
  		<td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
  		<td class=field>
  			<input type=hidden class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan')" size=60  maxlength=100  value = "<%=requestname%>" >
  			<span id=requestnamespan><%=requestname%></span>&nbsp;&nbsp;&nbsp;&nbsp;
  			<%if(requestlevel.equals("0")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%><%}%>
  			<%if(requestlevel.equals("1")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%><%}%>
  			<%if(requestlevel.equals("2")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%><%}%>
  		</td>
  	</tr>
  	<tr><td class=Line1 colSpan=2></td></tr>
  </table>
  
<table class="viewform">
    <tr><td width="100%">
    <table class="viewform" >
    <tr><td></td></tr>
<%
for(int t=0; t<tmpids.size(); t++){
    boolean canshow=false;
    boolean canedit=false;
    boolean showbutton=false;
    String tmpid=(String) tmpids.get(t);
    String workstatus="";
    //得到具体数据
    RecordSet.executeSql("select * from bill_hrmtimedetail where id="+tmpid);
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
    String reqlevelD=RecordSet.getString("requestlevel");

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
    }

    //~~~~~~~~~~~~~get submit button title~~~~~~~~~~~~~~~
    String submit="";
    if(nodetype.equals("0"))	submit=SystemEnv.getHtmlLabelName(615,user.getLanguage());
    if(nodetype.equals("1"))	submit=SystemEnv.getHtmlLabelName(142,user.getLanguage());
    if(nodetype.equals("2"))	submit=SystemEnv.getHtmlLabelName(725,user.getLanguage());
    if(nodetype.equals("3"))	submit=SystemEnv.getHtmlLabelName(251,user.getLanguage());

    if(resourceid.equals(userid+""))    canshow=true;
    else    if((","+accepterid+",").indexOf(","+userid+",")!=-1)  canshow=true;
    else    if(isopen.equals("1"))   canshow=true;
    else    if(isremark==1)     canshow=true;
    	
    //if(!canshow)    continue;

    if(nodetype.equals("0")&&resourceid.equals(userid+""))    canedit=true;
    if(nodetype.equals("2")&&(","+accepterid+",").indexOf(","+userid+",")!=-1)     showbutton=true;
    if(nodetype.equals("1")&&resourceid.equals(userid+""))    showbutton=true;
    if(isremark==1)     showbutton=true;
    if(nodetype.equals("1")||(nodetype.equals("2"))) showbutton = true;

    if(nodetype.equals("0"))    workstatus= SystemEnv.getHtmlLabelName(16336,user.getLanguage())  ;
    if(nodetype.equals("3"))    workstatus= SystemEnv.getHtmlLabelName(16337,user.getLanguage())  ;
    if(nodetype.equals("1"))    workstatus= SystemEnv.getHtmlLabelName(1343,user.getLanguage())  ;
    if(nodetype.equals("2")){
    if(currentdate.compareTo(enddate)>0)
        workstatus=SystemEnv.getHtmlLabelName(16338,user.getLanguage()) ;
    else
        workstatus=SystemEnv.getHtmlLabelName(16339,user.getLanguage()) ;
    }

%>
<input type=hidden name="detailid_<%=rowindex%>" value=<%=detailid%>>
<%if(showbutton){%>
    <div style="display:none">
    <%if(!isend.equals("1")&&(userid==creater)){%>
    <BUTTON class=btnSave accessKey=S type=button id="planDoSave" onclick="doSave2(<%=rowindex%>)"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button>
    <%}%>
    <%if(isremark==1){%>
    <BUTTON class=btnSave accessKey=S type=button id="planDoRemark" onclick="doRemark2(<%=rowindex%>)"><U>S</U>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button>
    <%} else {%>
    <%if(!isend.equals("1")){%>
    <BUTTON class=btn accessKey=B type=button id="planDoSubmit" onclick="doSubmit2(<%=rowindex%>)"><U>B</U>-<%if(nodetype.equals("1")){%><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%> <%} else { if(userid==creater){%><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%> <%} else {%><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%> <%} }%></button>
    <BUTTON class=btn accessKey=M type=button onclick="location.href='Remark.jsp?requestid=<%=requestid%>'"><U>M</U>-<%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%></button>
    <%}}%>
    <%if(!isend.equals("1")&&(userid!=creater)){%>
    <BUTTON class=btnSave accessKey=S type=button id="planDoSave" onclick="doSave2(<%=rowindex%>)"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button>
    <%}%>
    <%if(isremark!=1){%>
    <%if(isreopen.equals("1") && false){%>
    <BUTTON class=btn accessKey=O type=button id="planDoReopen" onclick="doReopen2(<%=rowindex%>)"><U>O</U>-<%=SystemEnv.getHtmlLabelName(244,user.getLanguage())%></button>
    <%}%>
    <%if(isreject.equals("1")){%>
    <BUTTON class=btn accessKey=J type=button id="planDoReject" onclick="doReject2(<%=rowindex%>,1)"><U>J</U>-<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></button>
    <BUTTON class=btn accessKey=A type=button onclick="doReject(<%=rowindex%>,0)"><U>A</U>-<%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></button>
    <%}%>
    <%if(nodetype.equals("0")){%>
    <BUTTON class=btnDelete accessKey=D type=button id="planDoDelete" onclick="doDelete2(<%=rowindex%>)"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
    <%}%>
    <%}%>
    <BUTTON class=btn accessKey=1 type=button onclick="location.href='RequestView.jsp'"><U>1</U>-<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage())%></button>
    </div>
<%}%>
    <table class="viewform">
        <COLGROUP>
    	<COL width="15%"><COL width="20%"><COL width="15%">
    	<COL width="20%"><COL width="15%"><COL width="15%">
	    <TR>
	        <td colspan=6 bgcolor=#e7e3bd><b><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%> <%=rowindex+1%>&nbsp;&nbsp;&nbsp;&nbsp;<%=workstatus%></b></td>
	    </tr><TR><TD class=Line2 colSpan=6></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
          <td class=field colspan=5>
          <%if(canedit){
                needcheck+=",name_"+rowindex;
          %>
            <input type=text class=inputstyle  name="name_<%=rowindex%>" value="<%=Util.toScreenToEdit(name,user.getLanguage())%>" onChange="checkinput1(name_<%=rowindex%>,namespan_<%=rowindex%>)" size=50 maxlength=25>
            <span id="namespan_<%=rowindex%>"><%if(name.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
            <input type=radio value="1" name="requestlevel_<%=rowindex%>" <%if(reqlevelD.equals("1")){%> checked <%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
            <input type=radio value="2" name="requestlevel_<%=rowindex%>" <%if(reqlevelD.equals("2")){%> checked <%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
            <input type=radio value="3" name="requestlevel_<%=rowindex%>" <%if(reqlevelD.equals("3")){%> checked <%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
          <%} else {%>
          <%=Util.toScreen(name,user.getLanguage())%><%if(showbutton){%><input type=hidden name="name_<%=rowindex%>" value="<%=Util.toScreenToEdit(name,user.getLanguage())%>"><%}%>
          &nbsp;&nbsp;&nbsp;&nbsp;
          <span id=levelspan>
          <%if(reqlevelD.equals("1")){%><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%> <%}%>
          <%if(reqlevelD.equals("2")){%><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%> <%}%>
          <%if(reqlevelD.equals("3")){%><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%> <%}%>
          </span>
          <input type=hidden name="requestlevel_<%=rowindex%>" value="<%=reqlevelD%>">
          <%}%>
          </td>
        </tr>
        <TR><TD class=Line2 colSpan=6></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
          <td class=field>
          <A href="javaScript:openhrm(<%=resourceid%>);" onclick='pointerXY(event);'>
          <%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A>
          <input type=hidden name="resourceid_<%=rowindex%>" value=<%=resourceid%>>
          </td>
          <td><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></td>
          <td class=field>
          <%if(canedit){
                needcheck+=",accepterid_"+rowindex;
          %>
          <button class=browser onclick="onShowResource(accepterid_<%=rowindex%>,accepterspan_<%=rowindex%>)"></button>
          <%}%>
          <span id="accepterspan_<%=rowindex%>">
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
          <input type=hidden name="accepterid_<%=rowindex%>" value=<%=accepterid%>>
          </td>
          <td><%=SystemEnv.getHtmlLabelName(16283,user.getLanguage())%></td>
          <td class=field><%if(!canedit){%><input type=checkbox name="isopen1_<%=rowindex%>" value='1'
          disabled <%if(isopen.equals("1")){%> checked <%}%>>
          <input type=hidden name="isopen_<%=rowindex%>" value='<%=isopen%>'>
          <%} else {%>
            <input type=checkbox name="isopen_<%=rowindex%>" value="1" <%if(isopen.equals("1")){%> checked <%}%>>
          <%}%>
          </td>
        </tr>
       <TR><TD class=Line2 colSpan=6></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
          <td class=field>
          <%if(canedit){
                needcheck+=",begindate_"+rowindex;
          %>
            <button class=Calendar onclick="onShowDate(begindatespan_<%=rowindex%>,begindate_<%=rowindex%>)"></button>
          <%}%>
          <span id="begindatespan_<%=rowindex%>"><%=begindate%><%if(begindate.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
          <input type=hidden name="begindate_<%=rowindex%>" value="<%=begindate%>">
          </td>
          <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
          <td class=field>
          <%if(canedit){
          %>
            <button class=Calendar onclick="onShowTime(begintimespan_<%=rowindex%>,begintime_<%=rowindex%>)"></button>
          <%}%>
          <span id="begintimespan_<%=rowindex%>"><%=begintime%></span>
          <input type=hidden name="begintime_<%=rowindex%>" value="<%=begintime%>">
          </td>
          <td colspan=2>&nbsp;</td>
        </tr>
        <TR><TD class=Line2 colSpan=6></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
          <td class=field>
          <%if(canedit){
                needcheck+=",enddate_"+rowindex;
          %>
            <button class=Calendar onclick="onShowDate(enddatespan_<%=rowindex%>,enddate_<%=rowindex%>)"></button>
          <%}%>
          <span id="enddatespan_<%=rowindex%>"><%=enddate%><%if(enddate.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%}%></span>
          <input type=hidden name="enddate_<%=rowindex%>" value="<%=enddate%>">
          </td>
          <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
          <td class=field>
          <%if(canedit){
          %>
            <button class=Calendar onclick="onShowTime(endtimespan_<%=rowindex%>,endtime_<%=rowindex%>)"></button>
          <%}%>
          <span id="endtimespan_<%=rowindex%>"><%=endtime%></span>
          <input type=hidden name="endtime_<%=rowindex%>" value="<%=endtime%>">
          </td>
          <td colspan=2>&nbsp;</td>
        </tr>
        <TR><TD class=Line2 colSpan=6></TD></TR>
        <%if(!nodetype.equals("0")&&isremark!=1){%>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(784,user.getLanguage())%></td>
          <td class=field>
          <%if(showbutton&&nodetype.equals("2")){%>
            <button class=Calendar onclick="onShowDate(wakedatespan_<%=rowindex%>,wakedate_<%=rowindex%>)"></button>
          <%}%>
          <span id="wakedatespan_<%=rowindex%>"><%=wakedate%></span>
          <input type=hidden name="wakedate_<%=rowindex%>" value="<%=wakedate%>">
          </td>
          <td><%=SystemEnv.getHtmlLabelName(16340,user.getLanguage())%></td>
          <td class=field>
          <%if(showbutton&&nodetype.equals("2")){%>
            <button class=Calendar onclick="onShowDate(delaydatespan_<%=rowindex%>,delaydate_<%=rowindex%>)"></button>
          <%}%>
          <span id="delaydatespan_<%=rowindex%>"><%=delaydate%></span>
          <input type=hidden name="delaydate_<%=rowindex%>" value="<%=delaydate%>">
          </td>
          <td colspan=2>&nbsp;</td>
        </tr><TR><TD class=Line2 colSpan=6></TD></TR>
        <%}%>
        <tr>
            <td><%=SystemEnv.getHtmlLabelName(16284,user.getLanguage())%></td>
            <td colspan=5 class=field>
            <%if(canedit){
                needcheck=",summary_"+rowindex ; %>
            <textarea class=inputstyle  name="summary_<%=rowindex%>" style="width:80%" rows=5
            onchange=checkinput1(summary_<%=rowindex%>,summaryspan_<%=rowindex%>)><%=Util.toScreenToEdit(summary,user.getLanguage())%></textarea>
            <span id="summaryspan_<%=rowindex%>"><%if(summary.equals("")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
            <%} else {%><%=Util.toScreen(summary,user.getLanguage())%>
            <input type=hidden name="summary_<%=rowindex%>" value="<%=Util.toScreenToEdit(summary,user.getLanguage())%>">
            <%}%>
            </td>
        </tr>
        <TR><TD class=Line2 colSpan=6></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
          <td class=field>
          <%if(canedit){%>
          <button class=browser onclick="onShowProject(projectid_<%=rowindex%>,projectspan_<%=rowindex%>)"></button>
          <%}%>
          <input type=hidden name="projectid_<%=rowindex%>" value="<%=projectid%>">
          <span id="projectspan_<%=rowindex%>">
          <a href='/proj/data/ViewProject.jsp?ProjID=<%=projectid%>' target='_blank'><%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(projectid),user.getLanguage())%></a></span>
          </td>
          <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
          <td class=field>
          <%if(canedit){%>
          <button class=browser onclick="onShowCRM(crmid_<%=rowindex%>,crmspan_<%=rowindex%>)"></button>
          <%}%>
          <input type=hidden name="crmid_<%=rowindex%>" value="<%=crmid%>">
          <span id="crmspan_<%=rowindex%>">
          <a href='/CRM/data/ViewCustomer.jsp?CustomerID=<%=crmid%>' target='_blank'><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%></a></span>
          </td>
          <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
          <td class=field>
          <%if(canedit){%>
          <button class=browser onclick="onShowRequest(relatedrequestid_<%=rowindex%>,relatedrequestspan_<%=rowindex%>)"></button>
          <%}%>
          <input type=hidden name="relatedrequestid_<%=rowindex%>" value="<%=relatedrequestid%>">
          <span id="relatedrequestspan_<%=rowindex%>">
          <a href='/workflow/request/ViewRequest.jsp?requestid=<%=relatedrequestid%>' target='_blank'><%=Util.toScreen(RequestComInfo.getRequestname(relatedrequestid),user.getLanguage())%></a></span>
          </td>
        </tr>
        <TR><TD class=Line2 colSpan=6></TD></TR>
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
          <td><%if(showbutton){%>
          <button class=AddDoc onclick="onAddDoc(<%=rowindex%>)" > <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>&nbsp;&nbsp<button class=AddDoc onclick="onNewDoc(<%=rowindex%>)" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
          <%}%></td>
          <td align=right colspan=4>&nbsp;</td>
        </tr><TR><TD class=Line2 colSpan=6></TD></TR>
        <tr><td colspan=6>
        <table class=liststyle cellspacing=1  cellspacing=1  width=100%>
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
            <td width="80%"><a href="/docs/docs/DocDsp.jsp?isrequest=1&requestid=<%=requestid %>&id=<%=tmpdocid%>" target="_new"><%=Util.toScreen(tmpdocname,user.getLanguage())%></a></td>
            <td width="10%"><a href="javaScript:openhrm(<%=tmpownerid%>);" onclick='pointerXY(event);'><%=Util.toScreen(tmpownername,user.getLanguage())%></a></td>
            <td width="10%" align=right>
            <%if(showbutton){%>
            <a href="javascript:onDelDoc(<%=rowindex%>,<%=tmpdocid%>)"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></a><%} else {%> &nbsp; <%}%></td>
        </tr>
        <TR><TD class=Line2 colSpan=3></TD></TR>
        <%  islight=!islight;
          }%>
        </table>
        </td></tr>
    </table>
 <br><br>
<%
    rowindex++;
}
%>
</table>
<%}%>
<input type=hidden name="rownum" value="<%=rowindex%>">
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
</form>

<script language=javascript>
var parastr_remark = "";
<%
String isSignMustInput="0";
RecordSet.executeSql("select issignmustinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSet.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
}
if(isSignMustInput.equals("1")){
	needcheck = needcheck + ",remarkText10404,";
%>
parastr_remark = ",remarkText10404,";
<%
}
%>
var rowindex=<%=rowindex%>
function addRow()
{
	ncol = oTable.cols;
	oRow = oTable.insertRow(-1);          		//在table中新建一行,返回行的id
	oCell = oRow.insertCell(-1); 
	var oDiv = document.createElement("div");
	var sHtml = "<table class=viewform><COLGROUP><COL width='20%'><COL width='15%'><COL width='20%'>"+
	            "<COL width='15%'><COL width='15%'><COL width='15%'>"+
	            "<tr><td colspan=6 ><b><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%> "+(rowindex+1)+"</b></td></tr><TR><TD class=Line2 colSpan=6></TD></TR> "+
	            "<tr>"+
                "<td><input type=checkbox name='check_plan' value='"+rowindex+"'> <%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>"+
                "<td class=field colspan=5><input type=text class=inputstyle  name='name_"+rowindex+"' onChange='checkinput1(name_"+rowindex+",namespan_"+rowindex+")' size=50 maxlength=25>"+
                "<span id='namespan_"+rowindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>"+
                "<input type=radio value='1' name='requestlevel_"+rowindex+"' checked><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>"+
                "<input type=radio value='2' name='requestlevel_"+rowindex+"'><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>"+
                "<input type=radio value='3' name='requestlevel_"+rowindex+"'><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>"+
                "</td></tr><TR><TD class=Line2 colSpan=6></TD></TR> "+
                "<tr> "+
                "<td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>"+
                "<td class=field><A href='javaScript:openhrm(<%=userid%>);' onclick='pointerXY(event);'><%=username%></A>"+
                "<input type=hidden name='resourceid_"+rowindex+"' value=<%=userid%>>"+
                "</td>"+
                "<td><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></td>"+
                "<td class=field><button class=browser onclick='onShowResource(accepterid_"+rowindex+",accepterspan_"+rowindex+")'></button>"+
                "<input type=hidden name='accepterid_"+rowindex+"' value=<%=accepterid_tmp%>>"+
                "<span id='accepterspan_"+rowindex+"'><%=accepteridStr%></span>"+
                "</td>"+
                "<td><%=SystemEnv.getHtmlLabelName(16283,user.getLanguage())%></td>"+
                "<td class=field><input type=checkbox name='isopen_"+rowindex+"' value='1'>"+
                "</td></tr><TR><TD class=Line2 colSpan=6></TD></TR> "+
                "<tr>"+
                "<td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>"+
                "<td class=field><button class=Calendar onclick='onShowDate(begindatespan_"+rowindex+",begindate_"+rowindex+")'></button>"+
                "<span id='begindatespan_"+rowindex+"'><%=begindateStr%></span>"+
                "<input type=hidden name='begindate_"+rowindex+"' value='<%=begindate_tmp%>'>"+
                "</td>"+
                "<td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>"+
                "<td class=field><button class=Calendar onclick='onShowTime(begintimespan_"+rowindex+",begintime_"+rowindex+")'></button>"+
                "<span id='begintimespan_"+rowindex+"'></span>"+
                "<input type=hidden name='begintime_"+rowindex+"' value=''>"+
                "</td>"+
                "<td colspan=2>&nbsp;"+
                "</td></tr><TR><TD class=Line2 colSpan=6></TD></TR> "+
                "<tr>"+
                "<td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>"+
                "<td class=field><button class=Calendar onclick='onShowDate(enddatespan_"+rowindex+",enddate_"+rowindex+")'></button>"+
                "<span id='enddatespan_"+rowindex+"'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>"+
                "<input type=hidden name='enddate_"+rowindex+"' value=''>"+
                "</td>"+
                "<td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>"+
                "<td class=field><button class=Calendar onclick='onShowTime(endtimespan_"+rowindex+",endtime_"+rowindex+")'></button>"+
                "<span id='endtimespan_"+rowindex+"'></span>"+
                "<input type=hidden name='endtime_"+rowindex+"' value=''>"+
                "</td>"+
                "<td colspan=2>&nbsp;"+
                "</td></tr><TR><TD class=Line2 colSpan=6></TD></TR> "+
                "<tr>"+
                "<td><%=SystemEnv.getHtmlLabelName(16284,user.getLanguage())%></td>"+
                "<td colspan=5 class=field>"+
                "<textarea name='summary_"+rowindex+"' style='width:80%' rows=5 onchange=checkinput1(summary_"+rowindex+",summaryspan_"+rowindex+")></textarea>"+
                "<span id='summaryspan_"+rowindex+"'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>"+
                "</td></tr><TR><TD class=Line2 colSpan=6></TD></TR> "+
                "<tr>"+
                "<td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>"+
                "<td class=field><button class=browser onclick='onShowProject(projectid_"+rowindex+",projectspan_"+rowindex+")'></button>"+
                "<input type=hidden name='projectid_"+rowindex+"' value=''>"+
                "<span id='projectspan_"+rowindex+"'></span>"+
                "</td>"+
                "<td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>"+
                "<td class=field><button class=browser onclick='onShowCRM(crmid_"+rowindex+",crmspan_"+rowindex+")'></button>"+
                "<input type=hidden name='crmid_"+rowindex+"' value=''>"+
                "<span id='crmspan_"+rowindex+"'></span>"+
                "</td>"+
                "<td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>"+
                "<td class=field><button class=browser onclick='onShowRequest(relatedrequestid_"+rowindex+",relatedrequestspan_"+rowindex+")'></button>"+
                "<input type=hidden name='relatedrequestid_"+rowindex+"' value=''>"+
                "<span id='relatedrequestspan_"+rowindex+"'></span>"+
                "</td></tr><TR><TD class=Line2 colSpan=6></TD></TR> "+
                "<tr>"+
                "<td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>"+
                "<td><a href='javascript:onNewDoc("+rowindex+")'><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:onAddDoc("+rowindex+")'><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a></td>"+
                "<td align=right colspan=4>&nbsp;</td>"+
                "</tr><TR><TD class=Line2 colSpan=6></TD></TR> "+
	            "</table><br><br>";
	oDiv.innerHTML = sHtml;    //内嵌html语句
	oCell.appendChild(oDiv);   //将odiv插入到ocell后面,作为ocell的内容
	rowindex ++;
	frmmain.rownum.value=rowindex;
	document.getElementById("htmlfieldids").value += "summary_<%=rowindex%>;<%=Util.toScreen(SystemEnv.getHtmlLabelName(16284,user.getLanguage()),languagebodyid)%>,";
}
function deleteRow()
{
    var flag = false;
	var ids = document.getElementsByName('check_plan');
	for(i=0; i<ids.length; i++) {
		if(ids[i].checked==true) {
			flag = true;
			break;
		}
	}
    if(flag) {
		if(isdel()){
            len = document.forms[0].elements.length;
            var i=0;
            var rowsum1 = 0;
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_plan')
                    rowsum1 ++;
            }
            for(i=len-1; i >= 0;i--) {
                if (document.forms[0].elements[i].name=='check_plan'){
                    if(document.forms[0].elements[i].checked==true)
                        oTable.deleteRow(rowsum1);
                    rowsum1--;
                }
            }
        }
    }else{
        alert('<%=SystemEnv.getHtmlLabelName(22686,user.getLanguage())%>');
		return;
    }
}
function doRemark2(rownum){
    document.frmmain.saverow.value=rownum;
	document.frmmain.isremark.value='1';
	document.frmmain.src.value='save';
	document.frmmain.nodesnum.value=rowindex;
	document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
	//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
}

function doSave2(rownum){
	var parastr=parastr_remark;
    len = document.forms[0].elements.length;
	var i=0;
	if(rownum==-1){
	    for(i=len-1; i >= 0;i--) {
    		if (document.forms[0].elements[i].name=="check_plan"){
    			parastr+=",name_"+document.forms[0].elements[i].value;
    			parastr+=",resourceid_"+document.forms[0].elements[i].value;
    			parastr+=",accepterid_"+document.forms[0].elements[i].value;
    			parastr+=",begindate_"+document.forms[0].elements[i].value;
    			parastr+=",enddate_"+document.forms[0].elements[i].value;
    			parastr+=",summary_"+document.forms[0].elements[i].value;

    			var tmpbegindate=document.all("begindate_"+document.forms[0].elements[i].value).value;
    			var tmpenddate=document.all("enddate_"+document.forms[0].elements[i].value).value;
    			if(tmpbegindate>tmpenddate){
    			    alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
    			    return;
    			}
        	}
        }
    	parastr=parastr.substring(1);
	}else{
	    parastr="<%=needcheck%>";
	}
    document.frmmain.document.body.onbeforeunload = null;
    displayAllmenu();
	if(check_form(document.frmmain,parastr)){
		enableAllmenu();
		document.frmmain.document.getElementById(tagFlag+'saverow').value=rownum;
		document.frmmain.saverow.value=rownum;
		document.frmmain.document.getElementById(tagFlag+'src').value='save';
		document.frmmain.src.value='save';
		document.frmmain.document.getElementById(tagFlag+'nodesnum').value=rowindex;
		document.frmmain.nodesnum.value=rowindex;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
}

function doSubmit2(rownum){
	var parastr=parastr_remark;
    len = document.forms[0].elements.length;
	var i=0;
	if(rownum==-1){
	    for(i=len-1; i >= 0;i--) {
    		if (document.forms[0].elements[i].name=='check_plan'){
    			parastr+=",name_"+document.forms[0].elements[i].value;
    			parastr+=",resourceid_"+document.forms[0].elements[i].value;
    			parastr+=",accepterid_"+document.forms[0].elements[i].value;
    			parastr+=",begindate_"+document.forms[0].elements[i].value;
    			parastr+=",enddate_"+document.forms[0].elements[i].value;
    			parastr+=",summary_"+document.forms[0].elements[i].value;

    			var tmpbegindate=document.all("begindate_"+document.forms[0].elements[i].value).value;
    			var tmpenddate=document.all("enddate_"+document.forms[0].elements[i].value).value;
    			if(tmpbegindate>tmpenddate){
    			    alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
    			    return;
    			}
        	}
        }
    	parastr=parastr.substring(1);
	}else{
	    parastr="<%=needcheck%>";
	}
	document.frmmain.document.body.onbeforeunload = null;
	displayAllmenu();
	if(check_form(document.frmmain,parastr)){
		enableAllmenu();
		document.frmmain.document.getElementById(tagFlag+'saverow').value=rownum;
	    document.frmmain.saverow.value=rownum;
		document.frmmain.document.getElementById(tagFlag+'src').value='submit';
		document.frmmain.src.value='submit';
		document.frmmain.document.getElementById(tagFlag+'nodesnum').value=rowindex;
		document.frmmain.nodesnum.value=rowindex;
		document.frmmain.document.getElementById(tagFlag+'remark').value += "\n<%=username%> <%=currentdate%> <%=currenttime%>";
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
}

function doReject2(rownum,rejectvalue){
    document.frmmain.saverow.value=rownum;
    document.frmmain.isreject.value=rejectvalue;
    document.frmmain.src.value='reject';
    document.frmmain.nodesnum.value=rowindex;
    document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
    document.frmmain.document.body.onbeforeunload = null;
    if(onSetRejectNode()){
    //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
    }
}

function onNewDoc(rownum){
    if(document.all("name_"+rownum).value==""){
        alert("<%=SystemEnv.getHtmlLabelName(16270,user.getLanguage())%>");
        return;
    }
    frmmain.method.value="docnew";
    frmmain.src.value="save";
    frmmain.nodesnum.value=rowindex;
    if(<%=thisnodetype%>==0)    frmmain.saverow.value=-1;
    else    frmmain.saverow.value=rownum;
    frmmain.action="ResourcePlanOperation.jsp?relatedrow=" + rownum ;
	//附件上传
                        StartUploadAll();
                        checkuploadcomplet();

}
function onDelDoc(rownum,docid){
    frmmain.method.value="docdel";
    frmmain.src.value="save";
    frmmain.nodesnum.value=rowindex;
    if(<%=thisnodetype%>==0)    frmmain.saverow.value=-1;
    else    frmmain.saverow.value=rownum;
    frmmain.action="ResourcePlanOperation.jsp?relatedrow=" + rownum + "&docid=" + docid ;
	//附件上传
                        StartUploadAll();
                        checkuploadcomplet();

}
function checktimeok(){
    return true;
}

function doSave_n(rownum){
    var parastr="";
    len = document.forms[0].elements.length;
	var i=0;
	rownum = -1;
	if(rownum==-1){
	    for(i=len-1; i >= 0;i--) {
    		if (document.forms[0].elements[i].name=="check_plan"){
    			parastr+=",name_"+document.forms[0].elements[i].value;
    			parastr+=",resourceid_"+document.forms[0].elements[i].value;
    			parastr+=",accepterid_"+document.forms[0].elements[i].value;
    			parastr+=",begindate_"+document.forms[0].elements[i].value;
    			parastr+=",enddate_"+document.forms[0].elements[i].value;
    			parastr+=",summary_"+document.forms[0].elements[i].value;

    			var tmpbegindate=document.all("begindate_"+document.forms[0].elements[i].value).value;
    			var tmpenddate=document.all("enddate_"+document.forms[0].elements[i].value).value;
    			if(tmpbegindate>tmpenddate){
    			    alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
    			    return;
    			}
        	}
        }
    	parastr=parastr.substring(1);
	}else{
	    parastr="<%=needcheck%>";
	}

    document.frmmain.document.body.onbeforeunload = null;
	//if(check_form(document.frmmain,parastr)){
	if(check_form(document.frmmain, "requestname")){
		document.frmmain.document.getElementById(tagFlag+'saverow').value=rownum;
		document.frmmain.saverow.value=rownum;
		document.frmmain.document.getElementById(tagFlag+'src').value='save';
		document.frmmain.src.value='save';
		document.frmmain.document.getElementById(tagFlag+'nodesnum').value=rowindex;
		document.frmmain.nodesnum.value=rowindex;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
}
function doSubmit(rownum){
    var parastr="";
    len = document.forms[0].elements.length;
	var i=0;
	rownum = -1;
	if(rownum==-1){
	    for(i=len-1; i >= 0;i--) {
    		if (document.forms[0].elements[i].name=='check_plan'){
    			parastr+=",name_"+document.forms[0].elements[i].value;
    			parastr+=",resourceid_"+document.forms[0].elements[i].value;
    			parastr+=",accepterid_"+document.forms[0].elements[i].value;
    			parastr+=",begindate_"+document.forms[0].elements[i].value;
    			parastr+=",enddate_"+document.forms[0].elements[i].value;
    			parastr+=",summary_"+document.forms[0].elements[i].value;

    			var tmpbegindate=document.all("begindate_"+document.forms[0].elements[i].value).value;
    			var tmpenddate=document.all("enddate_"+document.forms[0].elements[i].value).value;
    			if(tmpbegindate>tmpenddate){
    			    alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
    			    return;
    			}
        	}
        }
    	parastr=parastr.substring(1);
	}else{
	    parastr="<%=needcheck%>";
	}
    document.frmmain.document.body.onbeforeunload = null;
	if(check_form(document.frmmain,parastr)){
	    document.frmmain.document.getElementById(tagFlag+'saverow').value=rownum;
	    document.frmmain.saverow.value=rownum;
		document.frmmain.document.getElementById(tagFlag+'src').value='submit';
		document.frmmain.src.value='submit';
		document.frmmain.document.getElementById(tagFlag+'nodesnum').value=rowindex;
		document.frmmain.nodesnum.value=rowindex;
        document.frmmain.document.getElementById(tagFlag+'remark').value += "\n<%=username%> <%=currentdate%> <%=currenttime%>";
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
}
function doRemark_n(rownum){
	document.frmmain.document.getElementById(tagFlag+'saverow').value=rownum;
    document.frmmain.saverow.value=rownum;
	document.frmmain.document.getElementById(tagFlag+'isremark').value='1';
	document.frmmain.isremark.value='1';
	document.frmmain.document.getElementById(tagFlag+'src').value='save';
	document.frmmain.src.value='save';
    document.frmmain.document.getElementById(tagFlag+'nodesnum').value=rowindex;
	document.frmmain.nodesnum.value=rowindex;
	document.frmmain.document.getElementById(tagFlag+'remark').value += "\n<%=username%> <%=currentdate%> <%=currenttime%>";
	document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
    document.frmmain.document.body.onbeforeunload = null;
	//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
}
function doReject(){
	var obj = document.frmmain.document.getElementById(tagFlag+'reject');
	if(obj != null){
		obj.value='reject';
	}
    document.frmmain.src.value='reject';
    obj = document.frmmain.document.getElementById(tagFlag+'remark');
	if(obj != null){
		obj.value += "\n<%=username%> <%=currentdate%> <%=currenttime%>";
	}
    document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
    document.frmmain.document.body.onbeforeunload = null;
    if(onSetRejectNode()){
    //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
    }
}
</script>
<script language=vbs>
sub onAddDoc(rownum)
    if document.all("name_"&rownum).value="" then
        msgbox "<%=SystemEnv.getHtmlLabelName(16270,user.getLanguage())%>"
        exit sub
    end if
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" and id(0)<>"0" then
	    frmmain.method.value="docadd"
	    frmmain.src.value="save"
	    if(<%=thisnodetype%>=0) then
	        frmmain.saverow.value=-1
        else
            frmmain.saverow.value=rownum
        end if
	    frmmain.nodesnum.value=frmmain.rownum.value
	    frmmain.action="ResourcePlanOperation.jsp?relatedrow=" & rownum & "&docid=" & id(0)
                        StartUploadAll()
                        checkuploadcomplet()
	end if
	end if
end sub

sub onShowResource(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	    resourceids = id(0)
		resourcename = id(1)
		sHtml = ""
		resourceids = Mid(resourceids,2,len(resourceids))
		resourcename = Mid(resourcename,2,len(resourcename))
		inputname.value= resourceids
		while InStr(resourceids,",") <> 0
			curid = Mid(resourceids,1,InStr(resourceids,",")-1)
			curname = Mid(resourcename,1,InStr(resourcename,",")-1)
			resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
			resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
			sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else
    	spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    	inputname.value="0"
	end if
	end if
end sub

sub onShowDate1(inputname,spanname)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if  returndate="" then
	    spanname.innerHtml= ""
	else
	    spanname.innerHtml= returndate
	end if
	inputname.value=returndate
end sub

sub onShowProject(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
		inputname.value= id(0)
		spanname.innerHtml = "<a href='/proj/data/ViewProject.jsp?ProjID="+id(0)+"' target='_blank'>"+id(1)+"</a>"
	else
    	spanname.innerHtml = ""
    	inputname.value="0"
	end if
	end if
end sub

sub onShowCRM(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/CustomerBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
		inputname.value= id(0)
		spanname.innerHtml = "<a href='/CRM/data/ViewCustomer.jsp?CustomerID="+id(0)+"' target='_blank'>"+id(1)+"</a>"
	else
    	spanname.innerHtml = ""
    	inputname.value="0"
	end if
	end if
end sub

sub onShowRequest(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/RequestBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
		inputname.value= id(0)
		spanname.innerHtml = "<a href='/workflow/request/ViewRequest.jsp?requestid="+id(0)+"' target='_blank'>"+id(1)+"</a>"
	else
    	spanname.innerHtml = ""
    	inputname.value="0"
	end if
	end if
end sub
</script>
</body>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</html>
