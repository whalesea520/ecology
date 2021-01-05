<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Timestamp" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page" />
<jsp:useBean id="PlanTypeComInfo" class="weaver.proj.Maint.PlanTypeComInfo" scope="page" />
<jsp:useBean id="PlanSortComInfo" class="weaver.proj.Maint.PlanSortComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page"/>
<jsp:useBean id="FieldFormSelect" class="weaver.workflow.field.FieldFormSelect" scope="page" />
<%
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

RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+"and usertype = "+usertype+" and isremark='0'");
if(RecordSet.next())	hasright=1;

RecordSet.executeSql("select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+ usertype + " and isremark='1'");
if(RecordSet.next()){
	isremark=1;
}

if(hasright==0&&isremark==0){
	response.sendRedirect("/notice/noright.jsp");
    	return;
}

String user_fieldid="";
String isreopen="";
String isreject="";
String isend="";
RecordSet.executeProc("workflow_Nodebase_SelectByID",nodeid+"");
if(RecordSet.next()){
	user_fieldid=RecordSet.getString("userids");
	isreopen=RecordSet.getString("isreopen");
	isreject=RecordSet.getString("isreject");
	isend=RecordSet.getString("isend");
}

//~~~~~~~~~~~~~get submit button title~~~~~~~~~~~~~~~
String submit="";
if(nodetype.equals("0"))	submit=SystemEnv.getHtmlLabelName(615,user.getLanguage());
if(nodetype.equals("1"))	submit=SystemEnv.getHtmlLabelName(142,user.getLanguage());
if(nodetype.equals("2"))	submit=SystemEnv.getHtmlLabelName(725,user.getLanguage());
if(nodetype.equals("3"))	submit=SystemEnv.getHtmlLabelName(251,user.getLanguage());

//~~~~~~~~~~~~~~get billformid & billid~~~~~~~~~~~~~~~~~~~~~
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

// 显示属性相关字段
String needcheck="";
String isview="";
String isedit="";
String ismand="";
FieldFormSelect.setNodeid(nodeid);
FieldFormSelect.getFieldInfo();
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
<input type=hidden name=isremark >
<div>
<%if(isremark==1){%>
<BUTTON class=btnSave accessKey=S type=button onclick="doRemark()"><U>S</U>-提交</button>
<%} else {%>
<%if(!isend.equals("1")){%>
<BUTTON class=btn accessKey=B type=button onclick="doSubmit()"><U>B</U>-<%=submit%></button>
<BUTTON class=btn accessKey=M type=button onclick="location.href='Remark.jsp?requestid=<%=requestid%>'"><U>M</U>-转发</button>
<%}}%>
<% if(!isend.equals("1")){%>
<BUTTON class=btnSave accessKey=S type=button onclick="doSave()"><U>S</U>-<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></button>
<%}%>
<%if(isremark!=1){%>
<%if(isreopen.equals("1")){%>
<BUTTON class=btn accessKey=O type=button onclick="doReopen()"><U>O</U>-<%=SystemEnv.getHtmlLabelName(244,user.getLanguage())%></button>
<%}%>
<%if(isreject.equals("1")){%>
<BUTTON class=btn accessKey=J type=button onclick="doReject()"><U>J</U>-<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></button>
<%}%>
<BUTTON class=btnDelete accessKey=S type=button onclick="doDelete()"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></button>
<%}%>
<BUTTON class=btn accessKey=1 type=button onclick="location.href='RequestView.jsp'"><U>1</U>-返回</button>
</div>
  <table class=form>
    <colgroup> 
    <col width="15%"> <col width="35%">
    <col width="15%"> <col width="35%"> 
    <TR class=separator> 
      <TD class=Sep1 colSpan=4></TD>
    </TR>
    <TR>
        <%FieldFormSelect.setFieldid(92);
       		isedit=FieldFormSelect.getIsedit();
			ismand=FieldFormSelect.getIsmand();
			if(ismand.equals("1"))	needcheck+=",name";
	    %>
        <TD>主题</TD>
        <TD class=Field>
          <%if(isedit.equals("1")){%>
          <input name="name" value="<%=Util.toScreenToEdit(name,user.getLanguage())%>" 
          maxLength=150 style="width:90%" 
          <%if(ismand.equals("1")){%>onChange="checkinput('name','namespan')" <%}%>>
          <%} else {%>
          <%=Util.toScreen(name,user.getLanguage())%>
          <input type=hidden name=name value="<%=Util.toScreen(name,user.getLanguage())%>">
          <%}%>
          <span id=namespan></span></TD>
        <%   FieldFormSelect.setFieldid(91);
			 isedit=FieldFormSelect.getIsedit();
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",resourceid";
	    %>
        <TD>员工</TD>
        <TD class=Field>
          <%if(isedit.equals("1")){%>
          <BUTTON class=Browser id=SelectManagerID onClick="onShowResourceID(<%=ismand%>)"></BUTTON><%}%>
          <span id=resourceidspan><a href="/hrm/resource/HrmResource.jsp?id=<%=resourceid%>">
          <%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></a></span>
          <INPUT class=saveHistory type=hidden name="resourceid" value="<%=resourceid%>">
        </TD>
    </TR>
    <tr>
    	<%   FieldFormSelect.setFieldid(102);
			 isedit=FieldFormSelect.getIsedit();
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",projectid";
	    %>
    	<TD>项目</TD>
        <TD class=Field>
          <%if(isedit.equals("1")){%>
          <BUTTON class=Browser id=SelectProjID onClick="onShowProjID(<%=ismand%>)"></BUTTON><%}%>
          <span id=projectspan><a href="/proj/data/ViewProject.jsp?ProjID=<%=projectid%>">
          <%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(projectid),user.getLanguage())%></a></span>
          <INPUT class=saveHistory type=hidden name="projectid" value=<%=projectid%>>
        </TD>
        <%   FieldFormSelect.setFieldid(103);
        	 isedit=FieldFormSelect.getIsedit();
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",subprojectid";
	    %>
        <TD>子项目</TD>
        <TD class=Field>
          <%if(isedit.equals("1")){%>
          <BUTTON class=Browser id=SelectSubProjID onClick="onShowSubProjID(<%=ismand%>)"></BUTTON><%}%>
          <span id=subprojectspan><a href="/proj/data/ViewProject.jsp?ProjID=<%=subprojectid%>">
          <%=Util.toScreen(ProjectInfoComInfo.getProjectInfoname(subprojectid),user.getLanguage())%></a></span>
          <INPUT class=saveHistory type=hidden name="subprojectid" value="<%=subprojectid%>">
        </TD>
    </tr>        
    <TR>
          <% FieldFormSelect.setFieldid(93);
          	 isedit=FieldFormSelect.getIsedit();
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",plantype";
	      %>
          <TD>计划类型</TD>
          <TD class=Field>
          <%if(isedit.equals("1")){%>
          <BUTTON class=Browser onClick="onShowPlanType(<%=ismand%>)"></BUTTON><%}%>
          <span id=plantypespan><a href="/proj/Maint/EditPlanType.jsp?id=<%=plantype%>">
          <%=Util.toScreen(PlanTypeComInfo.getPlanTypename(plantype),user.getLanguage())%></a></span>
          <INPUT class=saveHistory type=hidden name="plantype" value="<%=plantype%>">
          </TD>
          <%   FieldFormSelect.setFieldid(94);
          	 isedit=FieldFormSelect.getIsedit();
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",plansort";
	      %>
          <TD>计划种类</TD>
          <TD class=Field>
          <%if(isedit.equals("1")){%>
          <BUTTON class=Browser onClick="onShowPlanSort(<%=ismand%>)"></BUTTON><%}%>
          <span id=plansortspan><a href="/proj/Maint/EditPlanSort.jsp?id=<%=plansort%>">
          <%=Util.toScreen(PlanSortComInfo.getPlanSortname(plansort),user.getLanguage())%></a></span>
          <INPUT class=saveHistory type=hidden name="plansort" value="<%=plansort%>">
          </TD>
    </TR>
    <tr>
    	<%   FieldFormSelect.setFieldid(95);
    		 isedit=FieldFormSelect.getIsedit();
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",begindate";
	    %>
        <TD>起始日期</TD>
        <TD class=Field>
          <%if(isedit.equals("1")){%>
          <BUTTON class=Calendar onclick="getBDate(<%=ismand%>)"></BUTTON> <%}%>
           <SPAN id=begindatespan >
           <%=Util.toScreen(begindate,user.getLanguage())%><span>
           <input type="hidden" name="begindate" value="<%=begindate%>">
        </td>
        <%   FieldFormSelect.setFieldid(96);
        	 isedit=FieldFormSelect.getIsedit();
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",begintime";
	    %>
        <td>起始时间</td>
        <TD class=Field>
          <%if(isedit.equals("1")){%>
          <BUTTON class=Calendar onclick="getBTime(<%=ismand%>)"></BUTTON> <%}%>
          <SPAN id=begintimespan >
          <%=Util.toScreen(begintime,user.getLanguage())%></span>
           <input type="hidden" name="begintime" value="<%=begintime%>">
        </TD>
    </tr>
    <tr>
        <%   FieldFormSelect.setFieldid(97);
        	 isedit=FieldFormSelect.getIsedit();
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",enddate";
	    %>
        <TD>结束日期</TD>
        <TD class=Field>
          <%if(isedit.equals("1")){%>
          <BUTTON class=Calendar onclick="getEDate(<%=ismand%>)"></BUTTON> <%}%>
              <SPAN id=enddatespan >
              <%=Util.toScreen(enddate,user.getLanguage())%></span>
              <input type="hidden" name="enddate" value="<%=enddate%>">
        </td>
        <%   FieldFormSelect.setFieldid(98);
        	 isedit=FieldFormSelect.getIsedit();
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",endtime";
	    %>
        <td>结束时间</td>
           <TD class=Field>
              <%if(isedit.equals("1")){%>
              <BUTTON class=Calendar onclick="getETime(<%=ismand%>)"></BUTTON><%}%> 
              <SPAN id=endtimespan >
              <%=Util.toScreen(endtime,user.getLanguage())%></span>
              <input type="hidden" name="endtime" value="<%=endtime%>"> 
           </TD>
    </tr>
    <tr>
    	 <%   FieldFormSelect.setFieldid(99);
    	 	 isedit=FieldFormSelect.getIsedit();
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",docid";
	    %>
         <td>参考文档</td>
         <td class=field>
         <%if(isedit.equals("1")){%>
         <BUTTON class=Browser onclick="showDoc(<%=ismand%>)"></BUTTON><%}%>      
         <SPAN ID=docidname><a href="/docs/docs/DocDsp.jsp?id=<%=docid%>">
         <%=Util.toScreen(DocComInfo.getDocname(docid),user.getLanguage())%></a></span>
         <INPUT class=saveHistory type=hidden name="docid" value="<%=docid%>">
         </td>
         <%   FieldFormSelect.setFieldid(100);
         	 isedit=FieldFormSelect.getIsedit();
			 ismand=FieldFormSelect.getIsmand();
			 if(ismand.equals("1"))	needcheck+=",budgetmoney";
	    %>
         <td>预算金额</td>
           <TD class=Field>
           <%if(isedit.equals("1")){%>
           <INPUT class=saveHistory maxLength=10 size=20 name="budgetmoney" 
           onKeyPress="ItemNum_KeyPress()" onBlur='checknumber1(this)' 
           <%if(ismand.equals("1")){%> onchange=checkinput('budgetmoney','budgetspan') <%}%>
           value="<%=Util.toScreenToEdit(budgetmoney,user.getLanguage())%>">
           <%} else {%>
           <%=Util.toScreen(budgetmoney,user.getLanguage())%>
           <input name=budgetmoney type=hidden value="<%=Util.toScreen(budgetmoney,user.getLanguage())%>">
           <%}%>
           </TD>
    </tr>
    <tr>
      <%FieldFormSelect.setFieldid(101);
      	isedit=FieldFormSelect.getIsedit();
		ismand=FieldFormSelect.getIsmand();
		if(ismand.equals("1"))	needcheck+=",summary";
	  %> 
      <td>备注</td>
      <td colspan=3 class=field>
      	<%if(isedit.equals("1")){%>
        <textarea name=summary rows=4 cols=40 style="width=80%"><%=Util.toScreenToEdit(summary,user.getLanguage())%></textarea>
        <%} else {%>
        <%=Util.toScreen(summary,user.getLanguage())%>
        <textarea name=summary style="display:none"><%=Util.toScreenToEdit(summary,user.getLanguage())%></textarea>
        <%}%>
      </td>
    </tr>
  </table>
	<%	if(!needcheck.equals(""))
		needcheck=needcheck.substring(1);%>   
  <br>
  <br>
<%@ include file="/workflow/request/WorkflowManageSign.jsp" %>
<script language=vbs>
sub onShowResourceID(ismand)
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp")
	if (Not IsEmpty(id)) then
	if id(0)<> "" then
	resourceidspan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
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
	function doRemark(){
		document.frmmain.isremark.value='1';
		document.frmmain.src.value='save';
		document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
		//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	
	function doSave(){
		if(check_form(document.frmmain,'<%=needcheck%>')){
			document.frmmain.src.value='save';
//			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
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
	function doReject(){
			document.frmmain.src.value='reject';
			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
        if(onSetRejectNode()){
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
        }
		}
	function doReopen(){
			document.frmmain.src.value='reopen';
			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
	}
	function doDelete(){
			document.frmmain.src.value='delete';
			document.all("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
			//附件上传
                        StartUploadAll();
                        checkuploadcomplet();
		}
</script>