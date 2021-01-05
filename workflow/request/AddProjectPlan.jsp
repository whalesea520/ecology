<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="FieldFormSelect" class="weaver.workflow.field.FieldFormSelect" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
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
String isSignDoc_add="";
String isSignWorkflow_add="";
RecordSet.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSet.next()){
    isSignDoc_add=Util.null2String(RecordSet.getString("isSignDoc"));
    isSignWorkflow_add=Util.null2String(RecordSet.getString("isSignWorkflow"));
}
String needcheck="";
String isview="";
String isedit="";
String ismand="";
FieldFormSelect.setNodeid(Util.getIntValue(nodeid));
FieldFormSelect.getFieldInfo();
%>

<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page"/>

<form name="frmmain" method="post" action="ProjectPlanOperation.jsp">
<input type=hidden name="workflowid" value=<%=workflowid%>>
<input type=hidden name="nodeid" value=<%=nodeid%>>
<input type=hidden name="nodetype" value="0">
<input type=hidden name="src">
<input type=hidden name="iscreate" value="1">
<input type=hidden name="formid" value=<%=formid%>>
<input type=hidden name ="topage" value="<%=topage%>">
<div>
<BUTTON class=btn accessKey=B type=button onclick="doSubmit()"><U>B</U>-<%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%></button>
<BUTTON class=btnSave accessKey=S type=button onclick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button>
</div><br>
  <div align="center">
    <font style="font-size:14pt;FONT-WEIGHT: bold">项目计划</font>
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
       <%   FieldFormSelect.setFieldid(92);
			ismand=FieldFormSelect.getIsmand();
			if(ismand.equals("1"))	needcheck+=",name";
	   %>
       <TD>主题</TD>
       <TD class=Field>
          <INPUT class=saveHistory maxLength=150 style="width:90%" name="name" 
          <%if(ismand.equals("1")){%>onChange="checkinput('name','namespan')" <%}%>>
          <span id=namespan>
          <%if(ismand.equals("1")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span> 
        </TD>
        <%   FieldFormSelect.setFieldid(91);
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",resourceid";
	    %>
        <TD>员工</TD>
        <TD class=Field>
          <BUTTON class=Browser id=SelectManagerID onClick="onShowResourceID(<%=ismand%>)"></BUTTON>
          <span id=resourceidspan>
          <%if(hrmid.equals("")){%><%if(ismand.equals("1")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%>
          <%} else {%><a href="javaScript:openhrm(<%=hrmid%>);" onclick='pointerXY(event);'>
          <%=Util.toScreen(ResourceComInfo.getResourcename(hrmid),user.getLanguage())%></a><%}%>
          </span> 
              <INPUT class=saveHistory type=hidden name="resourceid" value="<%=hrmid%>">
        </TD>
    </TR>
    <tr>
    	<%   FieldFormSelect.setFieldid(102);
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",projectid";
	    %>
    	<TD>项目</TD>
        <TD class=Field>
          <BUTTON class=Browser id=SelectProjID onClick="onShowProjID(<%=ismand%>)"></BUTTON>
          <span id=projectspan>
          <%if(prjid.equals("")){%>
          <%if(ismand.equals("1")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%>
          <%} else {%><a href="/proj/data/ViewProject.jsp?ProjID=<%=prjid%>">
          <%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(prjid),user.getLanguage())%></a>
          <%}%></span>
          <INPUT class=saveHistory type=hidden name="projectid" value=<%=prjid%>>
        </TD>
        <%   FieldFormSelect.setFieldid(103);
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",subprojectid";
	    %>
        <TD>子项目</TD>
        <TD class=Field>
          <BUTTON class=Browser id=SelectSubProjID onClick="onShowSubProjID(<%=ismand%>)"></BUTTON>
          <span id=subprojectspan><%if(ismand.equals("1")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
          <INPUT class=saveHistory type=hidden name="subprojectid">
        </TD>
    </tr>        
    <TR>
          <%   FieldFormSelect.setFieldid(93);
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",plantype";
	    %>
          <TD>计划类型</TD>
          <TD class=Field>
          <BUTTON class=Browser onClick="onShowPlanType(<%=ismand%>)"></BUTTON>
          <span id=plantypespan><%if(ismand.equals("1")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
          <INPUT class=saveHistory type=hidden name="plantype">
          </TD>
          <%   FieldFormSelect.setFieldid(94);
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",plansort";
	      %>
          <TD>计划种类</TD>
          <TD class=Field>
          <BUTTON class=Browser onClick="onShowPlanSort(<%=ismand%>)"></BUTTON>
          <span id=plansortspan><%if(ismand.equals("1")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
          <INPUT class=saveHistory type=hidden name="plansort">
          </TD>
    </TR>
    <tr>
        <%   FieldFormSelect.setFieldid(95);
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",begindate";
	    %>
        <TD>起始日期</TD>
        <TD class=Field>
          <BUTTON class=Calendar onclick="getBDate(<%=ismand%>)"></BUTTON> 
              <SPAN id=begindatespan >
              <%if(ismand.equals("1")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span> 
              <input type="hidden" name="begindate" id="begindate">   
        </td>
        <%   FieldFormSelect.setFieldid(96);
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",begintime";
	    %>
        <td>起始时间</td>
           <TD class=Field>
           <BUTTON class=Calendar onclick="getBTime(<%=ismand%>)"></BUTTON> 
              <SPAN id=begintimespan >
              <%if(ismand.equals("1")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
              <input type="hidden" name="begintime" id="begintime">   
           </TD>
    </tr>
    <tr>
        <%   FieldFormSelect.setFieldid(97);
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",enddate";
	    %>
        <TD>结束日期</TD>
        <TD class=Field>
          <BUTTON class=Calendar onclick="getEDate(<%=ismand%>)"></BUTTON> 
              <SPAN id=enddatespan >
              <%if(ismand.equals("1")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
              <input type="hidden" name="enddate" id="enddate">
        </td>
        <%   FieldFormSelect.setFieldid(98);
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",endtime";
	    %>
        <td>结束时间</td>
        <TD class=Field>
           <BUTTON class=Calendar onclick="getETime(<%=ismand%>)"></BUTTON> 
              <SPAN id=endtimespan >
              <%if(ismand.equals("1")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
              <input type="hidden" name="endtime" id="endtime">   
        </TD>
    </tr>
    <tr>
         <%   FieldFormSelect.setFieldid(99);
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",docid";
	    %>
         <td>参考文档</td>
         <td class=field>
         <BUTTON class=Browser onclick="showDoc(<%=ismand%>)"></BUTTON>      
      <SPAN ID=docidname>
      <%if(docid.equals("")){%>
      <%if(ismand.equals("1")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%>
      <%} else {%><a href="/docs/docs/DocDsp.jsp?id=<%=docid%>">
      <%=Util.toScreen(DocComInfo.getDocname(docid),user.getLanguage())%></a>
      <%}%>
      </span>
        <INPUT class=saveHistory type=hidden name="docid">
         </td>
         <%   FieldFormSelect.setFieldid(100);
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",budgetmoney";
	    %>
         <td>预算金额</td>
           <TD class=Field>
           <INPUT class=saveHistory maxLength=10 size=20 name="budgetmoney" 
           onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)' 
           <%if(ismand.equals("1")){%> onchange=checkinput('budgetmoney','budgetspan') <%}%>>
           <span id=budgetspan><%if(ismand.equals("1")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
           </TD>
    </tr>
    <tr>
      <%   FieldFormSelect.setFieldid(101);
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",summary";
	    %> 
      <td>备注</td>
      <td colspan=3 class=field>
        <textarea name=summary rows=4 cols=40 style="width=80%" 
        <%if(ismand.equals("1")){%> onchange=checkinput('summary','summaryspan') <%}%>></textarea>
        <span id=summaryspan><%if(ismand.equals("1")){%><IMG src='/images/BacoError_wev8.gif' align=absMiddle><%}%></span>
      </td>
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
<%	if(!needcheck.equals(""))
		needcheck=needcheck.substring(1);%>  
<script language=vbs>
sub onShowResourceID(ismand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='javaScript:openhrm("&id(0)&");' onclick='pointerXY(event);'>"&id(1)&"</A>"
	frmmain.resourceid.value=id(0)
	else 
		if ismand=1 then
			resourceidspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		else
			resourceidspan.innerHtml = ""
		end if
	frmmain.resourceid.value="0"
	end if
	end if
end sub

sub onShowProjID(ismand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	projectspan.innerHtml = "<A href='/proj/data/ViewProject.jsp?ProjID="&id(0)&"'>"&id(1)&"</A>"
	frmmain.projectid.value=id(0)
	else
		if ismand=1 then 
			projectspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		else
			projectspan.innerHtml = ""
		end if
	frmmain.projectid.value="0"
	end if
	end if
end sub

sub onShowSubProjID(ismand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/ProjectBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	subprojectspan.innerHtml = "<A href='/proj/data/ViewProject.jsp?ProjID="&id(0)&"'>"&id(1)&"</A>"
	frmmain.subprojectid.value=id(0)
	else 
		if ismand=1 then 
			subprojectspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		else
			subprojectspan.innerHtml = ""
		end if
	frmmain.subprojectid.value="0"
	end if
	end if
end sub

sub onShowPlanType(ismand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/plan/PlanTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "0" then
	plantypespan.innerHtml = "<A href='/proj/Maint/EditPlanType.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.plantype.value=id(0)
	else 
		if ismand=1 then 
			plantypespan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		else
			plantypespan.innerHtml = ""
		end if
	frmmain.plantype.value="0"
	end if
	end if
end sub

sub onShowPlanSort(ismand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/plan/PlanSortBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "0" then
	plansortspan.innerHtml = "<A href='/proj/Maint/EditPlanSort.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.plansort.value=id(0)
	else 
		if ismand=1 then 
			plansortspan.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		else
			plansortspan.innerHtml = ""
		end if
	frmmain.plansort.value="0"
	end if
	end if
end sub

sub getBDate(ismand)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if	returndate="" and ismand=1 then
		document.all("begindatespan").innerHtml= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	else
		document.all("begindatespan").innerHtml= returndate
	end if
	document.all("begindate").value=returndate
end sub
sub getEDate(ismand)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	if	returndate="" and ismand=1 then
		document.all("enddatespan").innerHtml= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	else	
		document.all("enddatespan").innerHtml= returndate
	end if
	document.all("enddate").value=returndate
end sub
sub getBTime(ismand)
	returntime = window.showModalDialog("/systeminfo/Clock.jsp",,"dialogHeight:360px;dialogwidth:275px")
	if	returntime="" and ismand=1 then
		document.all("begintimespan").innerHtml= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	else	
		document.all("begintimespan").innerHtml= returntime
	end if
	document.all("begintime").value=returntime
end sub
sub getETime(ismand)
	returntime = window.showModalDialog("/systeminfo/Clock.jsp",,"dialogHeight:360px;dialogwidth:275px")
	if	returntime="" and ismand=1 then
		document.all("endtimespan").innerHtml= "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	else
		document.all("endtimespan").innerHtml= returntime
	end if
	document.all("endtime").value=returntime
end sub
sub showDoc(ismand)
	id = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/DocBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "0" then
	docidname.innerHtml = "<A href='/proj/Maint/EditPlanSort.jsp?id="&id(0)&"'>"&id(1)&"</A>"
	frmmain.docid.value=id(0)
	else 
		if ismand=1 then 
			docidname.innerHtml = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
		else
			docidname.innerHtml = ""
		end if
	frmmain.docid.value="0"
	end if
	end if
end sub
</script>
</form>

<script language=javascript>
	function doSave(){
		if(check_form(document.frmmain,'<%=needcheck%>')){
			document.frmmain.src.value='save';
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
	function doSubmit(){
		if(check_form(document.frmmain,'<%=needcheck%>')){
			document.frmmain.src.value='submit';
			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
	}
</script>
</body>
</html>