<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<script type="text/javascript" language="javascript" src="/FCKEditor/fckeditor_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/FCKEditor/FCKEditorExt_wev8.js"></script>
<%

String workflowid=Util.null2String(request.getParameter("workflowid"));
String nodeid=Util.null2String(request.getParameter("nodeid"));
String formid=Util.null2String(request.getParameter("formid"));


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

String workflowname=WorkflowComInfo.getWorkflowname(workflowid);
String needcheck="";
int rowsum=0;
String isSignDoc_add="";
String isSignWorkflow_add="";
RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
}
%>
<form name="frmmain" method="post" action="BillCptCarMantantOperation.jsp">
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="0">
<input type=hidden name="src">
<input type=hidden name="iscreate" value="1">
 <input type=hidden name="formid" value=<%=formid%>>
<input type="hidden" value="0" name="nodesnum">
  <div> 
    <BUTTON class=btn accessKey=B type=button onclick="doSubmit()"><U>B</U>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button> 
    <BUTTON class=btnSave accessKey=S type=button onclick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button> 
  </div>
  <br>
  <table class=form>
    <colgroup> <col width="15%"> <col width="85%">
    <tr class=separator> 
      <td class=Sep1 colspan=2></td>
    </tr>
    <tr>
      <td>说明</td>
      <td class=field> 
        <input type=text name="name" onChange="checkinput('name','namespan')" size=40 maxlength=25
        value="<%=Util.toScreenToEdit(workflowname+"-"+username+"-"+currentdate,user.getLanguage())%>">
        <span id=namespan></span> 
        <input type=radio value="0" name="requestlevel" checked>正常
        <input type=radio value="1" name="requestlevel">重要
        <input type=radio value="2" name="requestlevel">紧急
      </td>
     </tr>
<tr><td>&nbsp</td></tr>
<TR class=Section>
    	  <TH colSpan=2>
    	  国际战略投资有限公司行政管理部车辆保养单
    	  </TH></TR>
     <TR class=separator>
    	  <TD class=Sep1 colSpan=2></TD></TR>
  <tr>
   <table class=form>
   <tr>
      <td width=15%>车辆编号</td>
      <td class=field  width=85%> 
      <button class=Browser onClick='onShowAsset(node_0_carnospan,node_0_carno)'></button> 
	<span class=saveHistory id=node_0_carnospan></span> 
	<input type='hidden' name='node_0_carno' id='node_0_carno'>
      </td>
     </tr>
     <tr>
     <td>保养人</td>
     <td class=field>
     <button class=Browser onClick='onShowResource(node_0_driverspan,node_0_driver)'></button>
	<span class=saveHistory id=node_0_driverspan></span> 
	<input type='hidden' name='node_0_driver' id='node_0_driver'>
     </td>
     </tr>
     <tr>
     <td>保养时间</td>
     <td class=field>
      <button class=Browser onClick='onShowDate(node_0_datespan,node_0_date)'></button> 
         <span class=saveHistory id=node_0_datespan></span> 
    	<input type='hidden' name='node_0_date' id='node_0_date'></td>
      </td>
     </tr>
      <tr>
     <td>保养费用</td>
     <td class=field> <input type='text' style=width:50%  name='node_0_mantantfee'>
      </td>
     </tr>
      <tr>
     <td>备注</td>
     <td class=field>   
     <textarea name = 'node_0_remax' rows=4 cols=40 style=width:80% ></textarea>
      </td>
     </tr>
     
  </table>
  
  </tr>  
 
    <tr class="Title">
      <td colspan=2 align="center" valign="middle"><font style="font-size:14pt;FONT-WEIGHT: bold"><%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%></font></td>
    </tr>
    <tr>
      <td><%=SystemEnv.getHtmlLabelName(504,user.getLanguage())%></td>
      <td class=field>
		<input type="hidden" id="remarkText10404" name="remarkText10404" value="">
        <textarea name=remark rows=4 cols=40 style="width=80%;display:none" ></textarea>
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
	function doSave(){
		if(check_form(document.frmmain,"name")){
			document.frmmain.src.value='save';
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
	function doSubmit(){
		if(check_form(document.frmmain,"name")){
			document.frmmain.src.value='submit';
			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
	
</script>
<script language=vbs>

sub onShowDate(spanname,inputname)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	spanname.innerHtml= returndate
	inputname.value=returndate
end sub

sub onShowTime(spanname,inputname)
	returndate = window.showModalDialog("/systeminfo/Clock.jsp",,"dialogHeight:320px;dialogwidth:275px")
	spanname.innerHtml= returndate
	inputname.value=returndate
end sub

sub onShowResource(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	spanname.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	inputname.value=id(0)
	else 
	spanname.innerHtml = ""
	inputname.value=""
	end if
	end if
end sub

sub onShowDepartment(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="&inputname.value)
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
		spanname.innerHtml = id(1)
		inputname.value=id(0)
	else
		spanname.innerHtml = ""
		inputname.value=""
	end if
	end if
end sub

sub onShowAsset(spanname,inputname)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/cpt/capital/CapitalBrowser.jsp?sqlwhere=where isdata='2' and capitalgroupid=9 ")
	if NOT isempty(id) then
	    if id(0)<> "" then
		spanname.innerHtml = "<a href='/cpt/capital/CptCapital.jsp?id="&id(0)&"'>"&id(1)&"</a>"
		inputname.value=id(0)
		else
		spanname.innerHtml = ""
		inputname.value=""
		end if
	end if
end sub
</script>