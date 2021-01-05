<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
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
<%	

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
String isSignDoc_add="";
String isSignWorkflow_add="";
RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
}    
%>
<form name="frmmain" method="post" action="BillDiscussOperation.jsp">
  <input type="hidden" name="needwfback"  id="needwfback" value="1"/>
  <input type=hidden name="workflowid" value=<%=workflowid%>>
  <input type=hidden name="nodeid" value=<%=nodeid%>>
  <input type=hidden name="nodetype" value="0">
  <input type=hidden name="src">
  <input type=hidden name="iscreate" value="1">
  <input type=hidden name="formid" value=<%=formid%>>
  <input type=hidden name ="topage" value="<%=topage%>">
  <input type=hidden name="method" >
  <div align="center">
    <font style="font-size:14pt;FONT-WEIGHT: bold"><%=Util.toScreen(workflowname,user.getLanguage())%></font>
  </div>
<table class="viewform"> 
    <COLGROUP> 
	<COL width="10%"><COL width="25%"><COL width="10%">
	<COL width="25%"><COL width="10%"><COL width="20%">
    <tr class="Spacing"> <td class="Line2" colspan=6></td></tr>  
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(344,user.getLanguage())%></td>
      <td class=field colspan=5> 
        <input type=text  class=Inputstyle name="name" onChange="checkinput('name','namespan')" size=50 maxlength=25>
        <span id="namespan"><img src="/images/BacoError_wev8.gif" align=absmiddle></span> 
        <input type=radio value="0" name="requestlevel" checked><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>
        <input type=radio value="1" name="requestlevel"><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%>
        <input type=radio value="2" name="requestlevel"><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>
      </td>  
        <tr class="Spacing"> <td class="Line2" colspan=6></td></tr>  </tr>
    
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></td>
      <td class=field><A href="javaScript:openhrm(<%=hrmid%>);" onclick='pointerXY(event);'><%=Util.toScreen(ResourceComInfo.getResourcename(hrmid),user.getLanguage())%></A> 
      <input type=hidden name="resourceid" value=<%=hrmid%>>
      </td>
      <td><%=SystemEnv.getHtmlLabelName(15525,user.getLanguage())%></td>
      <td class=field><button class=browser onclick="onShowResource(accepterid,accepterspan)"></button>
      <input type=hidden name="accepterid" value=<%=hrmid%>>
      <span id="accepterspan"><A href="javaScript:openhrm(<%=hrmid%>);" onclick='pointerXY(event);'>
      <%=Util.toScreen(ResourceComInfo.getResourcename(hrmid),user.getLanguage())%></A> </span>
      </td>
      <!--td>结束讨论</td>
      <td class=field><input type=checkbox name="isend" value='1'></td !-->
      <td colspan=2>&nbsp; </td>
    </tr>
        <tr class="Spacing"> <td class="Line2" colspan=6></td></tr>     
    <tr> 
      <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
      <td class=field><button class=browser onclick="onShowProject(projectid,projectspan)"></button>
      <input type=hidden name="projectid" value="0"><span id="projectspan"></span>
      </td>
      <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
      <td class=field><button class=browser onclick="onShowCRM(crmid,crmspan)"></button>
      <input type=hidden name="crmid" value="0"><span id="crmspan"></span>
      </td>
      <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
      <td class=field><button class=browser onclick="onShowRequest(relatedrequestid,relatedrequestspan)"></button>
      <input type=hidden name="relatedrequestid" value="0"><span id="relatedrequestspan"></span>
      </td>
    </tr>    <tr class="Spacing"> <td class="Line2" colspan=6></td></tr>  
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
      <td><a href="javascript:onNewDoc()"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></a>&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:onAddDoc()"><%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%></a></td>    
      <td align=right colspan=4>&nbsp;</td>
    </tr>    <tr class="Spacing"> <td class="Line2" colspan=6></td></tr>  
</table>
    
<table class="viewform">
    <colgroup>
	<col width="20%">
	<col width="80%">
    <tr class="Title">
      <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></font></td>
    </tr>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></td>
      <td class=field>
		<input type="hidden" id="remarkText10404" name="remarkText10404" value="">
        <textarea class=Inputstyle name=remark id=remark  rows=4 cols=40 style="width=80%;display:none"></textarea>
<script defer>
function funcremark_log(){
	FCKEditorExt.initEditor("frmmain","remark",<%=user.getLanguage()%>,FCKEditorExt.NO_IMAGE);
	FCKEditorExt.toolbarExpand(false);
}
funcremark_log();
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

</form> 

<script language=javascript>
function onNewDoc(){
    if(frmmain.name.value==""){
        alert("<%=SystemEnv.getHtmlLabelName(16270,user.getLanguage())%>");
        return;
    }
    frmmain.method.value="docnew";
    frmmain.src.value="save";
	//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
}

function doSave(){
	if(check_form(document.frmmain,'name,accepterid')){
		document.frmmain.src.value='save';
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
}
function doSubmit(){
	if(check_form(document.frmmain,'name,accepterid')){
		document.frmmain.src.value='submit';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
}
</script>

<script language=vbs>
sub onAddDoc()
    if frmmain.name.value="" then
        msgbox "<%=SystemEnv.getHtmlLabelName(16270,user.getLanguage())%>"
        exit sub
    end if
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" and id(0)<>"0" then
	    frmmain.method.value="docadd"
	    frmmain.src.value="save"
	    frmmain.action="BillDiscussOperation.jsp?docid=" & id(0)
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

sub onShowProject(inputname,spanname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
		inputname.value= id(0)
		spanname.innerHtml = "<a href='/proj/data/ViewProject.jsp?ProjID="+id(0)+"'>"+id(1)+"</a>"
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
		spanname.innerHtml = "<a href='/CRM/data/ViewCustomer.jsp?CustomerID="+id(0)+"'>"+id(1)+"</a>"
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
		spanname.innerHtml = "<a href='/workflow/request/ViewRequest.jsp?requestid="+id(0)+"'>"+id(1)+"</a>"
	else	
    	spanname.innerHtml = ""
    	inputname.value="0"
	end if
	end if
end sub
</script>