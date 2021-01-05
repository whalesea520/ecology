<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsaddop" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rscount" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="FieldFormSelect" class="weaver.workflow.field.FieldFormSelect" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>

<!-- 
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditor_wev8.js"></script>
<script type="text/javascript" src="/wui/common/js/ckeditor/ckeditorext_wev8.js"></script>
 -->
<%	
int languagebodyid = user.getLanguage() ;
String workflowid=Util.null2String(request.getParameter("workflowid"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String formid=Util.null2String(request.getParameter("formid"));
//对不同的模块来说,可以定义自己相关的工作流
String prjid = Util.null2String(request.getParameter("prjid"));
String docid = Util.null2String(request.getParameter("docid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String hrmid = Util.null2String(request.getParameter("hrmid"));
//......
String topage = Util.null2String(request.getParameter("topage"));
int isSignMustInput = Util.getIntValue(request.getParameter("isSignMustInput"));
if(hrmid.equals(""))	hrmid=""+user.getUID();
int userid=user.getUID();
String logintype = user.getLogintype();
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

String userseclevel=user.getSeclevel();
String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
String needcheck="";
int rowindex=0;

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
	accepterid_tmp = ""+hrmid;
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
String isSignDoc_add="";
String isSignWorkflow_add="";
RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
}
 String requestname = Util.toScreenToEdit( workflowname+"-"+username+"-"+currentdate,user.getLanguage() );
 
  
  weaver.crm.Maint.CustomerInfoComInfo customerInfoComInfo = new weaver.crm.Maint.CustomerInfoComInfo();
  String usernamenew = "";
 	if(user.getLogintype().equals("1"))
 		usernamenew = user.getLastname();
 	if(user.getLogintype().equals("2"))
 		usernamenew = customerInfoComInfo.getCustomerInfoname(""+user.getUID());
 	
   weaver.general.DateUtil   DateUtil=new weaver.general.DateUtil();
   String 	txtuseruse=DateUtil.getWFTitleNew(""+workflowid,""+user.getUID(),""+usernamenew,user.getLogintype());


int defaultName = Util.getIntValue(Util.null2String(request.getParameter("defaultName")),0);
%>
<form name="frmmain" method="post" action="ResourcePlanOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="needwfback" id="needwfback" value="1" />
  <input type=hidden name="workflowid" value=<%=workflowid%>>
  <input type=hidden name="nodeid" value=<%=nodeid%>>
  <input type=hidden name="nodetype" value="0">
  <input type=hidden name="src">
  <input type=hidden name="iscreate" value="1">
  <input type=hidden name="formid" value=<%=formid%>>
  <input type=hidden name ="topage" value="<%=topage%>">
  <input type=hidden name="nodesnum" >
  <input type=hidden name="method" >
  <input type="hidden" name="htmlfieldids">
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
  			<%if(defaultName==1){%>
  			<input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan')" size=60  maxlength=100  value = "<%=Util.toScreenToEdit( txtuseruse,user.getLanguage() )%>" >
  			<span id=requestnamespan>
			
 	<%
		 if(txtuseruse.equals("")){
		%>	
		<img src="/images/BacoError_wev8.gif" align=absmiddle>
		 <%}
		%>
			
			</span>
  		<%}else{%>
  			<input type=text class=Inputstyle  temptitle="<%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%>" name=requestname onChange="checkinput('requestname','requestnamespan')" size=60  maxlength=100  value = "" >
  			<span id=requestnamespan><img src="/images/BacoError_wev8.gif" align=absmiddle></span>
  		<%}%>
  		<input type=radio value="0" name="requestlevel" checked><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
  		<input type=radio value="1" name="requestlevel"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
  		<input type=radio value="2" name="requestlevel"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
  		</td>
  	</tr>
  	<tr><td class=Line1 colSpan=2></td></tr>
  </table>
  
  <table class="viewform"> 
    <tr><td>
		<BUTTON Class=Btn type=button onclick="addRow()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></BUTTON>
		<BUTTON Class=Btn type=button onclick="deleteRow();"><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
    </td></tr>
    <tr class="Spacing"> <td class="Line1"></td></tr>
    <tr><td width="100%">
    <table class="viewform" cols=6 id="oTable">
    <tr><td></td></tr>
    <tr><td><div>
        <table class="viewform">
        <COLGROUP> 
    	<COL width="20%"><COL width="15%"><COL width="20%">
    	<COL width="15%"><COL width="15%"><COL width="15%">
	    <TR >
	        <td ><b><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%> <%=rowindex+1%></b></td>
	    </tr><TR class="Spacing"><TD class=Line2 colSpan=6></TD></TR> 
        <tr>
          <td><input type=checkbox name="check_plan" value="<%=rowindex%>"><%=SystemEnv.getHtmlLabelName(786,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>
          <td class=field colspan=5> 
            <input type=text class=inputstyle  name="name_<%=rowindex%>" onChange="checkinput1(name_<%=rowindex%>,namespan_<%=rowindex%>)" 
            size=50 maxlength=25>
            <span id="namespan_<%=rowindex%>"><img src="/images/BacoError_wev8.gif" align=absmiddle></span> 
            <input type=radio value="1" name="requestlevel_<%=rowindex%>" checked><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
            <input type=radio value="2" name="requestlevel_<%=rowindex%>"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
            <input type=radio value="3" name="requestlevel_<%=rowindex%>"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
          </td>  
        </tr>
        <TR class="Spacing"><TD class=Line2 colSpan=6></TD></TR> 
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
          <td class=field><A href="javaScript:openhrm(<%=hrmid%>);" onclick='pointerXY(event);'>
          <%=Util.toScreen(ResourceComInfo.getResourcename(hrmid),user.getLanguage())%></A> 
          <input type=hidden name="resourceid_<%=rowindex%>" value=<%=hrmid%>>
                    </td>
          <td><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></td>
          <td class=field><button class=browser onclick="onShowResource(accepterid_<%=rowindex%>,accepterspan_<%=rowindex%>)"></button>
          <input type=hidden name="accepterid_<%=rowindex%>" value=<%=accepterid_tmp%>>
          <span id="accepterspan_<%=rowindex%>">
          <%=accepteridStr%></span>
          </td>
          <td><%=SystemEnv.getHtmlLabelName(16283,user.getLanguage())%></td>
          <td class=field><input type=checkbox name="isopen_<%=rowindex%>" value='1'></td>
        </tr>
        <TR class="Spacing"><TD class=Line2 colSpan=6></TD></TR> 
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
          <td class=field><button class=Calendar onclick="onShowDate(begindatespan_<%=rowindex%>,begindate_<%=rowindex%>)"></button>
          <span id="begindatespan_<%=rowindex%>"><%=begindateStr%></span>
          <input type=hidden name="begindate_<%=rowindex%>" value="<%=begindate_tmp%>">
          </td>
          <td><%=SystemEnv.getHtmlLabelName(742,user.getLanguage())%></td>
          <td class=field><button class=Calendar onclick="onShowTime(begintimespan_<%=rowindex%>,begintime_<%=rowindex%>)"></button>
          <span id="begintimespan_<%=rowindex%>"></span>
          <input type=hidden name="begintime_<%=rowindex%>" value="">
          </td>
          <td colspan=2>&nbsp;</td>
        </tr>
         <TR class="Spacing"><TD class=Line2 colSpan=6></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
          <td class=field><button class=Calendar onclick="onShowDate(enddatespan_<%=rowindex%>,enddate_<%=rowindex%>)"></button>
          <span id="enddatespan_<%=rowindex%>"><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
          <input type=hidden name="enddate_<%=rowindex%>" value="">
          </td>
          <td><%=SystemEnv.getHtmlLabelName(743,user.getLanguage())%></td>
          <td class=field><button class=Calendar onclick="onShowTime(endtimespan_<%=rowindex%>,endtime_<%=rowindex%>)"></button>
          <span id="endtimespan_<%=rowindex%>"></span>
          <input type=hidden name="endtime_<%=rowindex%>" value="">
          </td>
          <td colspan=2>&nbsp;</td>
        </tr>
         <TR class="Spacing"><TD class=Line2 colSpan=6></TD></TR> 
        <tr>
            <td><%=SystemEnv.getHtmlLabelName(16284,user.getLanguage())%></td>
            <td colspan=5 class=field>
			<script>document.getElementById("htmlfieldids").value += "summary_<%=rowindex%>;<%=Util.toScreen(SystemEnv.getHtmlLabelName(16284,user.getLanguage()),languagebodyid)%>,";</script>
            <textarea  class=Inputstyle  name="summary_<%=rowindex%>" style="width:80%" rows=5
            onchange=checkinput1(summary_<%=rowindex%>,summaryspan_<%=rowindex%>)></textarea>
            <span id="summaryspan_<%=rowindex%>"><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>
            </td>
        </tr>
         <TR class="Spacing"><TD class=Line2 colSpan=6></TD></TR> 
        <tr> 
          <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
          <td class=field><button class=browser onclick="onShowProject(projectid_<%=rowindex%>,projectspan_<%=rowindex%>)"></button>
          <input type=hidden name="projectid_<%=rowindex%>" value="">
          <span id="projectspan_<%=rowindex%>"></span>
          </td>
          <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
          <td class=field><button class=browser onclick="onShowCRM(crmid_<%=rowindex%>,crmspan_<%=rowindex%>)"></button>
          <input type=hidden name="crmid_<%=rowindex%>" value="">
          <span id="crmspan_<%=rowindex%>"></span>
          </td>
          <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
          <td class=field><button class=browser onclick="onShowRequest(relatedrequestid_<%=rowindex%>,relatedrequestspan_<%=rowindex%>)"></button>
          <input type=hidden name="relatedrequestid_<%=rowindex%>" value="">
          <span id="relatedrequestspan_<%=rowindex%>"></span>
          </td>
        </tr>     <TR class="Spacing"><TD class=Line2 colSpan=6></TD></TR> 
        <tr>
          <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
          <td>
		   <button class=AddDoc onclick="onAddDoc(<%=rowindex%>)" > <%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>&nbsp;&nbsp<button class=AddDoc onclick="onNewDoc(<%=rowindex%>)" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button>
		  </td>    
          <td align=right colspan=4>&nbsp;</td>
        </tr>     <TR class="Spacing"><TD class=Line2 colSpan=6></TD></TR> 
        </table>
        <br><br>
    </div>
    </td></tr>
    </table>
    <% rowindex++ ; %>
</td></tr>
</table>
    
<table class="viewform">
    <colgroup>
  <col width="20%">
  <col width="80%">
    <tr class="Title">
      <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></font></td>
    </tr>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></td>
      <td class=field>
		<input type="hidden" id="remarkText10404" name="remarkText10404" value="" temptitle="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>" >
        <textarea  class="Inputstyle" id="remark" name="remark" rows="4" cols="40" temptitle="<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>" style="width=80%;display:none" <%if(isSignMustInput==1){%>onChange="checkinput('remark','remarkSpan')"<%}%>></textarea>
		<span id="remarkSpan">
<%
	if(isSignMustInput==1){
		needcheck = needcheck + ",remarkText10404";
%>
			  <img src="/images/BacoError_wev8.gif" align=absmiddle>
<%
	}
%>
              </span>
		<script defer>
	  		   	function funcremark_log(){
	  		   		CkeditorExt.initEditor("frmmain","remark",<%=user.getLanguage()%>,CkeditorExt.NO_IMAGE, 200);
				<%if(isSignMustInput==1){%>
					CkeditorExt.checkText("remarkSpan","remark");
				<%}%>
					CkeditorExt.toolbarExpand(false,"remark");
				}
	  		 	window.attachEvent("onload", funcremark_log);
				//funcremark_log();
				</script>
      </td>
    </tr>
        <tr><td class=Line2 colSpan=2></td></tr>
    <%
         if("1".equals(isSignDoc_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signdocids" name="signdocids">
                <button class=Browser onclick="onShowSignBrowser('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37)" title="<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>"></button>
                <span id="signdocspan"></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
     <%
         if("1".equals(isSignWorkflow_add)){
         %>
          <tr>
            <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
            <td class=field>
                <input type="hidden" id="signworkflowids" name="signworkflowids">
                <button class=Browser onclick="onShowSignBrowser('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152)" title="<%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>"></button>
                <span id="signworkflowspan"></span>
            </td>
          </tr>
          <tr><td class=Line2 colSpan=2></td></tr>
         <%}%>
</table> 
<input type=hidden name="rownum" value="<%=rowindex%>">
</form> 

<script language=javascript>
var rowindex=<%=rowindex%>
function addRow()
{
	ncol = oTable.cols;
	oRow = oTable.insertRow(-1);          		//在table中新建一行,返回行的id
	oCell = oRow.insertCell(-1);  
	var oDiv = document.createElement("div");
	var sHtml = "<table class=viewform><COLGROUP><COL width='20%'><COL width='15%'><COL width='20%'>"+
	            "<COL width='15%'><COL width='15%'><COL width='15%'>"+
	            "<tr><td colspan=6 ><b><%=SystemEnv.getHtmlLabelName(15486,user.getLanguage())%> "+(rowindex+1)+"</b></td></tr><TR><TD class=Line colSpan=6></TD></TR> "+
	            "<tr>"+
                "<td><input type=checkbox name='check_plan' value='"+rowindex+"'><%=SystemEnv.getHtmlLabelName(786,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21192,user.getLanguage())%></td>"+
                "<td class=field colspan=5><input type=text class=inputstyle name='name_"+rowindex+"' onChange='checkinput1(name_"+rowindex+",namespan_"+rowindex+")' size=50 maxlength=25>"+
                "<span id='namespan_"+rowindex+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>"+ 
                "<input type=radio value='1' name='requestlevel_"+rowindex+"' checked><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>"+
                "<input type=radio value='2' name='requestlevel_"+rowindex+"'><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>"+
                "<input type=radio value='3' name='requestlevel_"+rowindex+"'><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>"+
                "</td></tr><TR><TD class=Line2 colSpan=6></TD></TR>"+
                "<tr> "+
                "<td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>"+
                "<td class=field><A href='javaScript:openhrm(<%=hrmid%>);' onclick='pointerXY(event);'><%=username%></A>"+ 
                "<input type=hidden name='resourceid_"+rowindex+"' value=<%=hrmid%>>"+
                "</td>"+
                "<td><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></td>"+
                "<td class=field><button class=browser onclick='onShowResource(accepterid_"+rowindex+",accepterspan_"+rowindex+")'></button>"+
                "<input type=hidden name='accepterid_"+rowindex+"' value=<%=accepterid_tmp%>>"+
                "<span id='accepterspan_"+rowindex+"'><%=accepteridStr%></span>"+
                "</td>"+
                "<td><%=SystemEnv.getHtmlLabelName(16283,user.getLanguage())%></td>"+
                "<td class=field><input type=checkbox name='isopen_"+rowindex+"' value='1'>"+
                "</td></tr><TR><TD class=Line2 colSpan=6></TD></TR>"+
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
                "</td></tr><TR><TD class=Line2 colSpan=6></TD></TR>"+
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
                "</td></tr><TR><TD class=Line2 colSpan=6></TD></TR>"+
                "<tr>"+
                "<td><%=SystemEnv.getHtmlLabelName(16284,user.getLanguage())%></td>"+
                "<td colspan=5 class=field>"+
                "<textarea  class=Inputstyle  name='summary_"+rowindex+"' style='width:80%' rows=5 onchange=checkinput1(summary_"+rowindex+",summaryspan_"+rowindex+")></textarea>"+
                "<span id='summaryspan_"+rowindex+"'><IMG src='/images/BacoError_wev8.gif' align=absMiddle></span>"+
                "</td></tr><TR><TD class=Line2 colSpan=6></TD></TR>"+
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
                "</td></tr><TR><TD class=Line2 colSpan=6></TD></TR>"+
                "<tr>"+
                "<td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>"+
                "<td><button class=AddDoc onclick='onAddDoc("+rowindex+")'><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></button>&nbsp;&nbsp<button class=AddDoc onclick='onNewDoc("+rowindex+")' title='<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>'><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></button></td>"+
                "<td align=right colspan=4>&nbsp;</td>"+
                "</tr><TR><TD class=Line2 colSpan=6></TD></TR>"+
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

function onNewDoc(rownum){
    if(document.all("name_"+rownum).value==""){
        alert("<%=SystemEnv.getHtmlLabelName(16270,user.getLanguage())%>");
        return;
    }
    frmmain.method.value="docnew";
    frmmain.src.value="save";
    frmmain.nodesnum.value=rowindex;
    frmmain.action="ResourcePlanOperation.jsp?relatedrow=" + rownum ;
	//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
    
}

function doSave(){
    var parastr="<%=needcheck%>";
    len = document.forms[0].elements.length;
	var i=0;
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
	//if(check_form(document.frmmain,parastr)){
	if(check_form(document.frmmain,"requestname")){
		document.frmmain.src.value='save';
		document.frmmain.nodesnum.value=rowindex;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
}
function doSubmit(obj){
    var parastr="<%=needcheck%>";
    len = document.forms[0].elements.length;
	var i=0;
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
	if(check_form(document.frmmain,parastr)){
		document.frmmain.src.value='submit';
		document.frmmain.nodesnum.value=rowindex;
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
        obj.disabled=true;
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
			sHtml = sHtml&"<a href='javaScript:openhrm("&curid&");' onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
		wend
		sHtml = sHtml&"<a href='javaScript:openhrm("&resourceids&");' onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"
		spanname.innerHtml = sHtml
	else	
    	spanname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
    	inputname.value="0"
	end if
	end if
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
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript" src="/js/selectDateTime_wev8.js"></script>