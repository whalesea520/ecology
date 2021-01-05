<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.workflow.request.RequestBrowser" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="crmComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="sysInfo" class="weaver.system.SystemComInfo" scope="page"/>
<jsp:useBean id="Browsedatadefinition" class="weaver.workflow.request.Browsedatadefinition" scope="page"/>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<BODY style='overflow-x:hidden'>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86, user.getLanguage())+",javascript:btnok_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(2022, user.getLanguage())+",javascript:btncz_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep;


RCMenu += "{"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+",javascript:btnsc_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

RCMenu += "{"+SystemEnv.getHtmlLabelName(201, user.getLanguage())+",javascript:btncancel_onclick(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
 
 <%
 //wfdateduring.properties
  BaseBean bean=new BaseBean();
  String wfdateduring=Util.null2String(bean.getPropValue("wfdateduring","wfdateduring"));
  String fieldid=Util.null2String(request.getParameter("fieldid")); 
  String type=Util.null2String(request.getParameter("type"));
  String workflowid=Util.null2String(request.getParameter("workflowid"));
  String isornshow="";
  if(!type.equals("")){
	  if(type.equals("171")){
		  isornshow="no";
	  }
  }else{
	  if(Browsedatadefinition.getFieldTypeString(""+workflowid,fieldid).equals(""+SystemEnv.getHtmlLabelName(21876,user.getLanguage()))){
		  isornshow="no";
		  type="171";
	  }else if(Browsedatadefinition.getFieldTypeString(""+workflowid,fieldid).equals(""+SystemEnv.getHtmlLabelName(648,user.getLanguage()))){
		  type="16";
	  }else if(Browsedatadefinition.getFieldTypeString(""+workflowid,fieldid).equals(""+SystemEnv.getHtmlLabelName(20156,user.getLanguage()))){
		  type="152";
	  }
  }
 String xgkhid=Util.null2String(request.getParameter("xgkhid")); 
 String optionmethod=Util.null2String(request.getParameter("optionmethod")); 
 String xgxmid=Util.null2String(request.getParameter("xgxmid")); 
 String createdatestart=Util.null2String(request.getParameter("createdatestart"));
 String createdateend=Util.null2String(request.getParameter("createdateend")); 
 String createtypeid=Util.null2String(request.getParameter("createtypeid")); 
 String department=Util.null2String(request.getParameter("department"));
 String createsubid=Util.null2String(request.getParameter("createsubid"));
 String requestnameopen=Util.null2String(request.getParameter("requestnameopen01"));
 String workflowtypeopen=Util.null2String(request.getParameter("workflowtypeopen01"));
 String Processnumberopen=Util.null2String(request.getParameter("Processnumberopen01"));
 String createtypeidopen=Util.null2String(request.getParameter("createtypeidopen01"));
 String createdeptidopen=Util.null2String(request.getParameter("createdeptidopen01"));
 String createsubidopen=Util.null2String(request.getParameter("createsubidopen01"));
 String createdateopen=Util.null2String(request.getParameter("createdateopen01"));
 String xgxmidopen=Util.null2String(request.getParameter("xgxmidopen01"));
 String xgkhidopen=Util.null2String(request.getParameter("xgkhidopen01"));
 String gdtypeopen=Util.null2String(request.getParameter("gdtypeopen01"));
 String jsqjtypeopen=Util.null2String(request.getParameter("jsqjtypeopen01"));
 String requestbs=Util.null2String(request.getParameter("requestbs"));
 String requestname=Util.null2String(request.getParameter("requestname"));
 String workflowtype=Util.null2String(request.getParameter("workflowtype"));
 String Processnumber=Util.null2String(request.getParameter("Processnumber"));
 String createtype=Util.null2String(request.getParameter("createtype"));
 String createdepttype=Util.null2String(request.getParameter("createdepttype"));
 String createsubtype=Util.null2String(request.getParameter("createsubtype")); 
 String createdatetype=Util.null2String(request.getParameter("createdatetype")); 
 String gdtype=Util.null2String(request.getParameter("gdtype")); 
 String jsqjtype=Util.null2String(request.getParameter("jsqjtype")); 
 
 
 int requestnameshoworder=Util.getIntValue(request.getParameter("requestnameshoworder"),0); 
 int workflowtypeshoworder=Util.getIntValue(request.getParameter("workflowtypeshoworder"),1); 
 int Processnumbershoworder=Util.getIntValue(request.getParameter("Processnumbershoworder"),2); 
 int createtypeidshoworder=Util.getIntValue(request.getParameter("createtypeidshoworder"),3); 
 int departmentshoworder=Util.getIntValue(request.getParameter("departmentshoworder"),4); 
 int createsubidcreatesubidshoworder=Util.getIntValue(request.getParameter("createsubidcreatesubidshoworder"),5); 
 int createdatetypeshoworder=Util.getIntValue(request.getParameter("createdatetypeshoworder"),6); 
 int xgxmidshoworder=Util.getIntValue(request.getParameter("xgxmidshoworder"),7); 
 int xgkhidshoworder=Util.getIntValue(request.getParameter("xgkhidshoworder"),8); 
 int gdtypeshoworder=Util.getIntValue(request.getParameter("gdtypeshoworder"),9); 
 int jsqjtypeshoworder=Util.getIntValue(request.getParameter("jsqjtypeshoworder"),10); 
 
 if(optionmethod.equals("add")){
   RecordSet.executeSql("delete workflow_rquestBrowseFunction where workflowid='"+workflowid+"' and fieldid='"+fieldid+"'");
   RecordSet.executeSql("insert into workflow_rquestBrowseFunction(workflowid,fieldid,fieldtype,requestbs,requestname,workflowtype,Processnumber,createtype,createtypeid,createdepttype,department,createsubtype,createsubid,createdatetype,createdatestart,xgxmid,xgkhid,gdtype,jsqjtype,requestnameopen,workflowtypeopen,Processnumberopen,createtypeidopen,createdeptidopen,createsubidopen,createdateopen,xgxmidopen,xgkhidopen,gdtypeopen,jsqjtypeopen,createdateend,requestnameshoworder,workflowtypeshoworder,Processnumbershoworder,createtypeidshoworder,departmentshoworder,createsubidcreatesubidshoworder,createdatetypeshoworder,xgxmidshoworder,xgkhidshoworder,gdtypeshoworder,jsqjtypeshoworder)values('"+workflowid+"','"+fieldid+"','"+type+"','"+requestbs+"','"+requestname+"','"+workflowtype+"','"+Processnumber+"','"+createtype+"',	'"+createtypeid+"',	'"+createdepttype+"','"+department+"','"+createsubtype+"','"+createsubid+"','"+createdatetype+"','"+createdatestart+"','"+xgxmid+"',	'"+xgkhid+"',	'"+gdtype+"',	'"+jsqjtype+"',	'"+requestnameopen+"',	'"+workflowtypeopen+"',	'"+Processnumberopen+"',	'"+createtypeidopen+"',	'"+createdeptidopen+"',	'"+createsubidopen+"',	'"+createsubidopen+"',	'"+xgxmidopen+"',	'"+xgkhidopen+"',	'"+gdtypeopen+"',	'"+jsqjtypeopen+"',	'"+createdateend+"','"+requestnameshoworder+"','"+workflowtypeshoworder+"','"+Processnumbershoworder+"','"+createtypeidshoworder+"','"+departmentshoworder+"','"+createsubidcreatesubidshoworder+"','"+createdatetypeshoworder+"','"+xgxmidshoworder+"','"+xgkhidshoworder+"','"+gdtypeshoworder+"','"+jsqjtypeshoworder+"') ");	 
  // out.println("insert into workflow_rquestBrowseFunction(workflowid,fieldid,fieldtype,requestbs,requestname,workflowtype,Processnumber,createtype,createtypeid,createdepttype,department,createsubtype,createsubid,createdatetype,createdatestart,xgxmid,xgkhid,gdtype,jsqjtype,requestnameopen,workflowtypeopen,Processnumberopen,createtypeidopen,createdeptidopen,createsubidopen,createdateopen,xgxmidopen,xgkhidopen,gdtypeopen,jsqjtypeopen,createdateend,requestnameshoworder,workflowtypeshoworder,Processnumbershoworder,createtypeidshoworder,departmentshoworder,createsubidcreatesubidshoworder,createdatetypeshoworder,xgxmidshoworder,xgkhidshoworder,gdtypeshoworder,jsqjtypeshoworder)values('"+workflowid+"','"+fieldid+"','"+type+"','"+requestbs+"','"+requestname+"','"+workflowtype+"','"+Processnumber+"','"+createtype+"',	'"+createtypeid+"',	'"+createdepttype+"','"+department+"','"+createsubtype+"','"+createsubid+"','"+createdatetype+"','"+createdatestart+"','"+xgxmid+"',	'"+xgkhid+"',	'"+gdtype+"',	'"+jsqjtype+"',	'"+requestnameopen+"',	'"+workflowtypeopen+"',	'"+Processnumberopen+"',	'"+createtypeidopen+"',	'"+createdeptidopen+"',	'"+createsubidopen+"',	'"+createsubidopen+"',	'"+xgxmidopen+"',	'"+xgkhidopen+"',	'"+gdtypeopen+"',	'"+jsqjtypeopen+"',	'"+createdateend+"','"+requestnameshoworder+"','"+workflowtypeshoworder+"','"+Processnumbershoworder+"','"+createtypeidshoworder+"','"+departmentshoworder+"','"+createsubidcreatesubidshoworder+"','"+createdatetypeshoworder+"','"+xgxmidshoworder+"','"+xgkhidshoworder+"','"+gdtypeshoworder+"','"+jsqjtypeshoworder+"') ");
 }else if(optionmethod.equals("del")){
	 RecordSet.executeSql("delete workflow_rquestBrowseFunction where workflowid='"+workflowid+"' and fieldid='"+fieldid+"'");
 
%>
<script type="text/javascript">
window.parent.parent.close();
</script>
 <%}else{
	 RecordSet.executeSql("select * from workflow_rquestBrowseFunction where workflowid='"+workflowid+"' and fieldid='"+fieldid+"'"); 
	 if(RecordSet.next()){
		 jsqjtype=Util.null2String(RecordSet.getString("jsqjtype"));
		 gdtype=Util.null2String(RecordSet.getString("gdtype"));
		 createdatetype=Util.null2String(RecordSet.getString("createdatetype"));
		 createsubtype=Util.null2String(RecordSet.getString("createsubtype"));
		 createdepttype=Util.null2String(RecordSet.getString("createdepttype"));
		 createtype=Util.null2String(RecordSet.getString("createtype"));
		 Processnumber=Util.null2String(RecordSet.getString("Processnumber"));
		 workflowtype=Util.null2String(RecordSet.getString("workflowtype"));
		 requestname=Util.null2String(RecordSet.getString("requestname"));
		 requestbs=Util.null2String(RecordSet.getString("requestbs"));
		 jsqjtypeopen=Util.null2String(RecordSet.getString("jsqjtypeopen"));
		 gdtypeopen=Util.null2String(RecordSet.getString("gdtypeopen"));
		 xgkhidopen=Util.null2String(RecordSet.getString("xgkhidopen"));
		 xgxmidopen=Util.null2String(RecordSet.getString("xgxmidopen"));
		 createdateopen=Util.null2String(RecordSet.getString("createdateopen"));
		 createsubidopen=Util.null2String(RecordSet.getString("createsubidopen"));
		 createdeptidopen=Util.null2String(RecordSet.getString("createdeptidopen"));
		 createtypeidopen=Util.null2String(RecordSet.getString("createtypeidopen"));
		 Processnumberopen=Util.null2String(RecordSet.getString("Processnumberopen"));
		 workflowtypeopen=Util.null2String(RecordSet.getString("workflowtypeopen"));
		 requestnameopen=Util.null2String(RecordSet.getString("requestnameopen"));
		 createsubid=Util.null2String(RecordSet.getString("createsubid"));
		 createdateend=Util.null2String(RecordSet.getString("createdateend"));
		 createdatestart=Util.null2String(RecordSet.getString("createdatestart"));
		 department=Util.null2String(RecordSet.getString("department"));
		 xgkhid=Util.null2String(RecordSet.getString("xgkhid"));
		 xgxmid=Util.null2String(RecordSet.getString("xgxmid"));
		 createtypeid=Util.null2String(RecordSet.getString("createtypeid")); 
		  requestnameshoworder=Util.getIntValue(RecordSet.getString("requestnameshoworder"),0); 
		  workflowtypeshoworder=Util.getIntValue(RecordSet.getString("workflowtypeshoworder"),1); 
		  Processnumbershoworder=Util.getIntValue(RecordSet.getString("Processnumbershoworder"),2); 
		  createtypeidshoworder=Util.getIntValue(RecordSet.getString("createtypeidshoworder"),3);  
		  departmentshoworder=Util.getIntValue(RecordSet.getString("departmentshoworder"),4); 
		  createsubidcreatesubidshoworder=Util.getIntValue(RecordSet.getString("createsubidcreatesubidshoworder"),5);  
		  createdatetypeshoworder=Util.getIntValue(RecordSet.getString("createdatetypeshoworder"),6); 
		  xgxmidshoworder=Util.getIntValue(RecordSet.getString("xgxmidshoworder"),7);  
		  xgkhidshoworder=Util.getIntValue(RecordSet.getString("xgkhidshoworder"),8); 
		  gdtypeshoworder=Util.getIntValue(RecordSet.getString("gdtypeshoworder"),9); 
		  jsqjtypeshoworder=Util.getIntValue(RecordSet.getString("jsqjtypeshoworder"),10); 
	 }
	 
 }
 %>

<FORM NAME="SearchForm" id="SearchForm" STYLE="margin-bottom:0" action="RequestBrowserfunction.jsp" method=post>
<input type="hidden" name="fieldid" id="fieldid" value="<%=fieldid %>">
<input type="hidden" name="type" id="type" value="<%=type %>">
<input type="hidden" name="optionmethod" id="optionmethod" value="">
<input type="hidden" name="workflowid" id="workflowid" value="<%=workflowid %>">
<input type="hidden" name="requestnameopen01" id="requestnameopen01" value="<%=requestnameopen %>">
<input type="hidden" name="workflowtypeopen01" id="workflowtypeopen01" value="<%=workflowtypeopen %>">
<input type="hidden" name="Processnumberopen01" id="Processnumberopen01" value="<%=Processnumberopen %>">
<input type="hidden" name="createtypeidopen01" id="createtypeidopen01" value="<%=createtypeidopen %>">
<input type="hidden" name="createdeptidopen01" id="createdeptidopen01" value="<%=createdeptidopen %>">
<input type="hidden" name="createsubidopen01" id="createsubidopen01" value="<%=createsubidopen %>">
<input type="hidden" name="createdateopen01" id="createdateopen01" value="<%=createdateopen %>">
<input type="hidden" name="xgxmidopen01" id="xgxmidopen01" value="<%=xgxmidopen %>">
<input type="hidden" name="xgkhidopen01" id="xgkhidopen01" value="<%=xgkhidopen %>">
<input type="hidden" name="gdtypeopen01" id="gdtypeopen01" value="<%=gdtypeopen %>">
<input type="hidden" name="jsqjtypeopen01" id="jsqjtypeopen01" value="<%=jsqjtypeopen %>">
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">

  <table width=100% class="viewform">
    <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(129380, user.getLanguage())%></TD>
      <TD width=35% class=field>
       <input name="requestbs" id="requestbs" class="Inputstyle" maxlength="100" value="<%=requestbs %>">
       <span id="requestbsspan">
        <%
         if(requestbs.equals("")){
        %>
        <IMG src="/images/BacoError_wev8.gif" align=absMiddle>
      <%} %>
       </span> 
      </TD>
      <TD width=15% class=field colSpan=2></TD>
	 </TR>
	 <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=4></TD></TR>
      
  <TR class="Title">
      <TR class="Title">
        <TH colSpan=2><%=SystemEnv.getHtmlLabelName(32752, user.getLanguage())%></TH>
         
          <TH><%=SystemEnv.getHtmlLabelName(88, user.getLanguage())%></TH>
          <TH  ><input name="checkAll" id="checkAll" type="checkbox"><%=SystemEnv.getHtmlLabelName(18096, user.getLanguage())%></TH>
      </TR>
      <TR class="Spacing" style="height:1px;">
	  <TD class="Line1" colSpan=4></TD></TR>
	  
    <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%>
       
      </TD>
      <TD width=35% class=field><input name="requestname" id="requestname" class=Inputstyle  value="<%=requestname %>"> </TD>
      <TD ><input name="requestnameshoworder" id="requestnameshoworder" onblur="checkPlusnumber1(this)"  type="text" size=4 value="<%=requestnameshoworder %>"></TD>
      <TD width=15% class=field  ><input name="isopen" <%if(requestnameopen.equals("1")){%> checked<%} %> id="requestnameopen" type="checkbox" value="1"><%=SystemEnv.getHtmlLabelName(18096, user.getLanguage())%></TD>
	 </TR>
	 <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=4></TD></TR>
	<TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(16579, user.getLanguage())%></TD>
      <TD width=35% class=field>
      <button type="button" class=browser onClick="onShowWorkFlowBase('workflowtype','workflowspan')"></button>
		<span id=workflowspan name="workflowspan">
		<%=WorkflowComInfo.getWorkflowname(workflowtype)%>
		</span>
		<input id="workflowtype" name=workflowtype type=hidden value="<%=workflowtype%>">	
       </TD>
        <TD ><input onblur="checkPlusnumber1(this)" name="workflowtypeshoworder" value="<%=workflowtypeshoworder %>" id="workflowtypeshoworder" type="text" size=4></TD>
      <TD width=15% class=field  ><input name="isopen" id="workflowtypeopen" <%if(workflowtypeopen.equals("1")){%> checked<%} %>  type="checkbox" value="1"><%=SystemEnv.getHtmlLabelName(18096, user.getLanguage())%></TD>
	 </TR>
	 <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=4></TD></TR>
	 
	 <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(714, user.getLanguage())%></TD>
      <TD width=35% class=field><input name="Processnumber" id="Processnumber" value="<%=Processnumber %>" class="Inputstyle" > </TD>
      <TD ><input name="Processnumbershoworder" value="<%=Processnumbershoworder %>" id="Processnumbershoworder" type="text" size=4></TD>
      <TD width=15% class=field  ><input name="isopen"  id="Processnumberopen" type="checkbox" value="1" <%if(Processnumberopen.equals("1")){%> checked<%} %>><%=SystemEnv.getHtmlLabelName(18096, user.getLanguage())%></TD>
	 </TR>
	 <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=4></TD></TR>
	 
	 
	 <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></TD>
      <TD width=35% class=field  style=" white-space:nowrap;">
      <select name="createtype" id="createtype">
	      <option value="0" ></option>
	      <option value="1" <%if(createtype.equals("1")){%> selected <%} %>><%=SystemEnv.getHtmlLabelName(20558, user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
	      <option value="2" <%if(createtype.equals("2")){%> selected <%} %>><%=SystemEnv.getHtmlLabelName(81811, user.getLanguage())%></option>
      </select>
      
       <BUTTON <%if(!createtype.equals("2")){%> style="display:none" <%} %> class=Browser type="button" id=SelectManagerID onClick="onShowManagerID(createtypeid,createrspan)"></BUTTON>
	  <span id="createrspan"  <%if(!createtype.equals("2")){%> style="display:none" <%} %>><%=Util.toScreen(ResourceComInfo.getResourcename(createtypeid),user.getLanguage())%></span>
      <INPUT class=Inputstyle id=createtypeid type=hidden name=createtypeid value="<%=createtypeid%>">
       
      
      
      </TD>
       <TD ><input name="createtypeidshoworder" value="<%=createtypeidshoworder %>" id="createtypeidshoworder" type="text" size=4></TD>
      <TD width=15% class=field ><input name="isopen"  id="createtypeidopen" <%if(createtypeidopen.equals("1")){%> checked<%} %> type="checkbox" value="1"><%=SystemEnv.getHtmlLabelName(18096, user.getLanguage())%></TD>
	 </TR>
	 <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=4></TD></TR>
	 
	 <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(19225, user.getLanguage())%></TD>
      <TD width=35% class=field>
       <select name="createdepttype" id="createdepttype">
	      <option value="0"></option>
	      <option value="1" <%if(createdepttype.equals("1")){%> selected<%} %>><%=SystemEnv.getHtmlLabelNames("20558,124",user.getLanguage()) %></option>
	      <option value="2" <%if(createdepttype.equals("2")){%> selected <%} %>><%=SystemEnv.getHtmlLabelName(19438, user.getLanguage())%></option>
      </select>
     <button type="button" class=Browser <%if(!createdepttype.equals("2")){%> style="display:none" <%} %>  id="deparbutton" onClick="onShowDepartment();"></button>
		<span id="departmentspan"  <%if(!createdepttype.equals("2")){%> style="display:none" <%} %>>
		<%
			String departments[] = Util.TokenizerString2(department,",");
			String departmentnames = "";
			for(int i=0;i<departments.length;i++){
				if(!departments[i].equals("")&&!departments[i].equals("0")){
					departmentnames += (!departmentnames.equals("")?",":"") + DepartmentComInfo.getDepartmentname(departments[i]);
				}
			}
			out.println(departmentnames);	
		%>
		</span>
		<input class=inputstyle id=department type=hidden name=department value="<%=department%>">
       </TD>
        <TD ><input name="departmentshoworder"  value="<%=departmentshoworder %>" id="departmentshoworder" type="text" size=4></TD>
      <TD width=15% class=field  ><input name="isopen"<%if(createdeptidopen.equals("1")){%> checked<%} %>  id="createdeptidopen" type="checkbox" value="1"><%=SystemEnv.getHtmlLabelName(18096, user.getLanguage())%></TD>
	 </TR>
	 <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=4></TD></TR>
	 <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(22788, user.getLanguage())%></TD>
      <TD width=35% class=field>
      <select name="createsubtype" id="createsubtype">
	      <option value="0"></option>
	      <option value="1" <%if(createsubtype.equals("1")){%> selected <%} %>><%=SystemEnv.getHtmlLabelNames("20558,141",user.getLanguage()) %></option>
	      <option value="2" <%if(createsubtype.equals("2")){%> selected <%} %>><%=SystemEnv.getHtmlLabelName(19437, user.getLanguage())%></option>
      </select>
      
      <BUTTON type=button class=Browser  <%if(!createsubtype.equals("2")){%> style="display:none" <%} %>  onclick="onShowBranch('createsubid','objName')"  id="showBranch" name=showBranch></BUTTON>
	  <SPAN id=objName   <%if(!createsubtype.equals("2")){%> style="display:none" <%} %>  >
	  
	  </SPAN> 
	<input type=hidden name="createsubid" id="createsubid" value="<%=createsubid%>">
      
       
      <span id="createsubtypespan"></span>
      <input type="hidden" name="createsubidcreatesubid" id="createsubidcreatesubid">
      </TD>
       <TD ><input name="createsubidcreatesubidshoworder"  value="<%=createsubidcreatesubidshoworder %>"  id="createsubidcreatesubidshoworder" type="text" size=4></TD>
      <TD width=15% class=field  ><input name="isopen" id="createsubidopen" <%if(createsubidopen.equals("1")){%> checked<%} %>  type="checkbox"><%=SystemEnv.getHtmlLabelName(18096, user.getLanguage())%></TD>
	 </TR>
	 <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=4></TD></TR>
	 
	 
	 <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(722, user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select name="createdatetype" id="createdatetype" >
	      <option value="1" <%if(createdatetype.equals("1")){%> selected <%} %> ><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
	      <option value="2" <%if(createdatetype.equals("2")){%> selected <%} %> ><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage())%></option>
	      <option value="3" <%if(createdatetype.equals("3")){%> selected <%} %>><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage())%></option>
	      <option value="4" <%if(createdatetype.equals("4")){%> selected <%} %>><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage())%></option>
	      <option value="5" <%if(createdatetype.equals("5")){%> selected <%} %>><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage())%></option>
	      <option value="6" <%if(createdatetype.equals("6")){%> selected <%} %>><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage())%></option>
	      <option value="7" <%if(createdatetype.equals("7")){%> selected <%} %>><%=SystemEnv.getHtmlLabelName(84617, user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
      </select>
      <span id="createdatetypediv" <%if(!createdatetype.equals("7")){%> style="display:none" <%} %> >
           <BUTTON class=Calendar type="button" id=selectbirthday onclick="getTheDate(createdatestart,createdatestartspan)"></BUTTON>
  		  <SPAN id=createdatestartspan ><%=createdatestart%></SPAN>
  		  - &nbsp;<BUTTON class=Calendar type="button" id=selectbirthday1 onclick="getTheDate(createdateend,createdateendspan)"></BUTTON>
  		  <SPAN id=createdateendspan ><%=createdateend%></SPAN>
  		  <input type="hidden" id=createdatestart name="createdatestart" value="<%=createdatestart%>">
  		  <input type="hidden" id=createdateend name="createdateend" value="<%=createdateend%>">
    </span>
      </TD>
       <TD ><input name="createdatetypeshoworder" value="<%=createdatetypeshoworder %>" id="createdatetypeshoworder" type="text" size=4></TD>
      <TD width=15% class=field  ><input name="isopen" id="createdateopen" <%if(createdateopen.equals("1")){%> checked<%} %> type="checkbox"><%=SystemEnv.getHtmlLabelName(18096, user.getLanguage())%></TD>
	 </TR>
	 <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=4></TD></TR>
	 
	 
	 <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></TD>
      <TD width=35% class=field> 
      <%
      String projname="";
      if(!xgxmid.equals("")){
    	  String st[]=xgxmid.split(",");
    	  for(int i=0;i<st.length;i++){
    		  String str01=""+st[i];
    		  if(!str01.equals("")){
    			  projname+="  "+ProjectInfoComInfo.getProjectInfoname(str01);
    		  }
    	  }
      }
      
     
      %>
      <input class="wuiBrowser"    _param=resourceids  _displayText="<%=projname%>" _url="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp" name=xgxmid type=hidden value="<%=xgxmid%>">
     
      </TD>
       <TD ><input name="xgxmidshoworder" value="<%=xgxmidshoworder %>" id="xgxmidshoworder" type="text" size=4></TD>
      <TD width=15% class=field  ><input name="isopen" id="xgxmidopen" <%if(xgxmidopen.equals("1")){%> checked<%} %> type="checkbox"><%=SystemEnv.getHtmlLabelName(18096, user.getLanguage())%></TD>
	 </TR>
	 <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=4></TD></TR>
	 
	 <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></TD>
      <TD width=35% class=field>
        <%
      String crmname="";
      if(!xgkhid.equals("")){
    	  String st[]=xgkhid.split(",");
    	  for(int i=0;i<st.length;i++){
    		  String str01=""+st[i];
    		  if(!str01.equals("")){
    			  crmname+="  "+crmComInfo.getCustomerInfoname(str01);
    		  }
    	  }
      }
      
      %>
       <input class="wuiBrowser" _displayText="<%=crmname%>" _url="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp"   _param=resourceids  name=xgkhid type=hidden value="<%=xgkhid%>"></td>
      </TD>
       <TD ><input name="xgkhidshoworder"  value="<%=xgkhidshoworder %>" id="xgkhidshoworder" type="text" size=4></TD>
      <TD width=15% class=field  ><input name="isopen" id="xgkhidopen" <%if(xgkhidopen.equals("1")){%> checked<%} %> type="checkbox"><%=SystemEnv.getHtmlLabelName(18096, user.getLanguage())%></TD>
	 </TR>
	 <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=4></TD></TR>
	 <%
	  if(!isornshow.equals("no")){
	 %>
	 <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(15112, user.getLanguage())%></TD>
      <TD width=35% class=field>
        <select name="gdtype">
          <option value="0" <%if(gdtype.equals("")){%> selected<%} %>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
	      <option value="1" <%if(gdtype.equals("1")){%> selected <%} %>><%=SystemEnv.getHtmlLabelName(17999, user.getLanguage())%></option>
	      <option value="2" <%if(gdtype.equals("2")){%> selected<%} %>><%=SystemEnv.getHtmlLabelName(18800, user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
      </select>
      </TD>
       <TD ><input name="gdtypeshoworder" value="<%=gdtypeshoworder %>" id="gdtypeshoworder" type="text" size=4></TD>
      <TD width=15% class=field  ><input name="isopen" id="gdtypeopen" <%if(gdtypeopen.equals("1")){%> checked<%} %>  type="checkbox"><%=SystemEnv.getHtmlLabelName(18096, user.getLanguage())%></TD>
	 </TR>
	 <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=4></TD></TR>
	 <%} %>
	 <TR>
      <TD width=15%><%=SystemEnv.getHtmlLabelName(31787, user.getLanguage())%></TD>
      <TD width=35% class=field>
	       <select name="jsqjtype">
	          <%
	          ArrayList list= Util.TokenizerString(wfdateduring,",");
	          for(int i=0;i<list.size();i++){
	        	  String qjdate=(String)list.get(i);
	          %>
	          <option value="<%=qjdate %>"   <%if(jsqjtype.equals(qjdate)){%> selected<%} %>><%=SystemEnv.getHtmlLabelName(524, user.getLanguage())%><%=qjdate %><%=SystemEnv.getHtmlLabelName(26301, user.getLanguage())%></option>
	          <%}%>
		      <option value="2"><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
	      </select> 
       </TD>
        <TD ><input name="jsqjtypeshoworder" value="<%=jsqjtypeshoworder %>" id="jsqjtypeshoworder" type="text" size=4></TD>
      <TD width=15% class=field  ><input name="isopen" <%if(jsqjtypeopen.equals("1")){%> checked<%} %> id="jsqjtypeopen" type="checkbox"><%=SystemEnv.getHtmlLabelName(18096, user.getLanguage())%></TD>
	 </TR>
	 <TR class="Spacing" style="height:1px;"><TD class="Line" colSpan=4></TD></TR>
	 
	<TR >
	<TD colspan="4" align="center" height="80px"> 
	 <br>
	<BUTTON class=btn accessKey=O  id=btnok onclick="btnok_onclick();"><U>b</U>-<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%></BUTTON>
	<BUTTON class=btn accessKey=2  id=btnclear onclick="btncz_onclick();"><U>c</U>-<%=SystemEnv.getHtmlLabelName(2022, user.getLanguage())%></BUTTON>
    <BUTTON class=btnSearch onclick="btnsc_onclick();" accessKey=S  id=btnsc><U>s</U>-<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%></BUTTON>
    <BUTTON class=btnReset accessKey=T  id=btncancel onclick="btncancel_onclick();";><U>q</U>-<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%></BUTTON>
  </TD>
  </TR>
  </table>
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

</FORM>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript" src="/js/browser/WorkFlowBrowser_wev8.js"></script>
<script type="text/javascript">

function onShowWorkFlowBase(inputname, spanname) {
	var retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MutilWorkflow_Browser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
	if (retValue != null) {
		if (wuiUtil.getJsonValueByIndex(retValue, 0) != "" ) {
			$G(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1).substr(1,wuiUtil.getJsonValueByIndex(retValue, 1).length);
			$G(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0).substr(1,wuiUtil.getJsonValueByIndex(retValue, 0).length);
		} else { 
			$G(inputname).value = "";
			$G(spanname).innerHTML = "";
		}
	}
}

   $(function() {    
   $("#checkAll").click(function() {
        $('input[name="isopen"]').attr("checked",this.checked);   
    });  
    var $subBox = $("input[name='isopen']");  
    $subBox.click(function(){  
        $("#checkAll").attr("checked",$subBox.length == $("input[name='isopen']:checked").length ? true : false);  
    });  
    $("#requestbs").blur(function() {
       var requestbs=$("#requestbs").val();
        requestbs = $.trim(requestbs);
        if(requestbs==''){
           $("#requestbs").val('');
           $("#requestbsspan").html("<img src=/images/BacoError_wev8.gif align=absMiddle>");//<IMG src='/images/BacoError_wev8.gif' align=absMiddle>   
        }else{
          $("#requestbsspan").html("");
        }
    }); 
    
    
     $("#createdatetype").change(function() {
        var createdatetype=$("#createdatetype").val();
           if(createdatetype=='7'){
            $("#createdatetypediv").css('display','');
           }else{
            $("#createdatetypediv").css('display','none');
           }
      }); 
      
         $("#createtype").change(function() {
          var createtype=$("#createtype").val();
           if(createtype=='2'){
             $("#SelectManagerID").css('display','');
             $("#createrspan").css('display','');
           }else{
             $("#SelectManagerID").css('display','none');
             $("#createrspan").css('display','none');
           }
      }); 
      
      
    $("#createdepttype").change(function() {
          var createdepttype=$("#createdepttype").val();
           if(createdepttype=='2'){
             $("#deparbutton").css('display','');
             $("#departmentspan").css('display','');
           }else{
             $("#deparbutton").css('display','none');
             $("#departmentspan").css('display','none');
           }
      }); 
      
     $("#createsubtype").change(function() {
          var createsubtype=$("#createsubtype").val();
           if(createsubtype=='2'){
             $("#showBranch").css('display','');
             $("#objName").css('display','');
           }else{
             $("#showBranch").css('display','none');
             $("#objName").css('display','none');
           }
      }); 
    
 });
 
function onShowBranch(inputename,tdname){
	var ids = jQuery("#"+inputename).val();            
	var datas=null;
	var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置; 
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+ids+"&selectedDepartmentIds="+ids);
    
    if (datas){
	    if (datas.id!= "" ){
	    	var ids=datas.id.slice(1).split(",");
	    	var names=datas.name.slice(1).split(",");
	    	var i=0;
	    	var strs="";
            for(i=0;i<ids.length;i++){
                strs=strs+""+names[i]+"&nbsp;";
            }
           
			jQuery("#"+tdname).html(strs);
			jQuery("#"+inputename).val(datas.id.slice(1));
			 
		}
		else{
			jQuery("#"+tdname).html("");
			jQuery("#"+inputename).val("");
			
		}
	}
}

function btncancel_onclick(){//q
	 window.parent.parent.close();
}

function btnsc_onclick(){//删除

 $("#optionmethod").val("del");
  document.SearchForm.submit();

}

function btncz_onclick(){//重置
 document.getElementById("SearchForm").reset();
}


function btnok_onclick(){//保存
  var requestbs=$("#requestbs").val();
      requestbs = $.trim(requestbs);
   if(requestbs==''){
      alert("<%=SystemEnv.getHtmlLabelName(84514,user.getLanguage())%>");
      return;
   }else{
   var jsqjtypeopen= document.getElementById('jsqjtypeopen');
   
 
   
   var xgkhidopen = document.getElementById('xgkhidopen');
   var xgxmidopen = document.getElementById('xgxmidopen');
   var createdateopen= document.getElementById('createdateopen');
   var createsubidopen= document.getElementById('createsubidopen');
   var createdeptidopen= document.getElementById('createdeptidopen');
   var createtypeidopen= document.getElementById('createtypeidopen');
   var Processnumberopen= document.getElementById('Processnumberopen');
   var workflowtypeopen = document.getElementById('workflowtypeopen');
   var requestnameopen= document.getElementById('requestnameopen');
    if(jsqjtypeopen.checked) { 
       $("#jsqjtypeopen01").val("1");
    }else{
      $("#jsqjtypeopen01").val("0");
    }
    
	     <%
		  if(!isornshow.equals("no")){
		 %>
		   var gdtypeopen = document.getElementById('gdtypeopen');
		     if(gdtypeopen.checked) { 
		       $("#gdtypeopen01").val("1");
		    }else{
		      $("#gdtypeopen01").val("0");
		    }
	  <%}%>
	  
     if(xgkhidopen.checked) { 
       $("#xgkhidopen01").val("1");
    }else{
      $("#xgkhidopen01").val("0");
    }
     if(xgxmidopen.checked) { 
       $("#xgxmidopen01").val("1");
    }else{
      $("#xgxmidopen01").val("0");
    }
     if(createdateopen.checked) { 
       $("#createdateopen01").val("1");
    }else{
      $("#createdateopen01").val("0");
    }
     if(createsubidopen.checked) { 
       $("#createsubidopen01").val("1");
    }else{
      $("#createsubidopen01").val("0");
    }
     if(createdeptidopen.checked) { 
       $("#createdeptidopen01").val("1");
    }else{
      $("#createdeptidopen01").val("0");
    }
     if(createtypeidopen.checked) { 
       $("#createtypeidopen01").val("1");
    }else{
      $("#createtypeidopen01").val("0");
    }
     if(Processnumberopen.checked) { 
       $("#Processnumberopen01").val("1");
    }else{
      $("#Processnumberopen01").val("0");
    }
    if(workflowtypeopen.checked) { 
       $("#workflowtypeopen01").val("1");
    }else{
      $("#workflowtypeopen01").val("0");
    }
     if(requestnameopen.checked) { 
       $("#requestnameopen01").val("1");
     }else{
      $("#requestnameopen01").val("0");
     }
      $("#optionmethod").val("add");
      document.SearchForm.submit();
   }
}


function onShowManagerID(inputname,spanname){
	var opts={
			_dwidth:'550px',
			_dheight:'550px',
			_url:'about:blank',
			_scroll:"no",
			_dialogArguments:"",
			
			value:""
		};
	var iTop = (window.screen.availHeight-30-parseInt(opts._dheight))/2+"px"; //获得窗口的垂直位置;
	var iLeft = (window.screen.availWidth-10-parseInt(opts._dwidth))/2+"px"; //获得窗口的水平位置;url=/hrm/resource/MutiResourceBrowser.jsp
	opts.top=iTop;
	opts.left=iLeft;
	var resourceids=$("#createtypeid").val();
	data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+resourceids,"","addressbar=no;status=0;scroll="+opts._scroll+";dialogHeight="+opts._dheight+";dialogWidth="+opts._dwidth+";dialogLeft="+opts.left+";dialogTop="+opts.top+";resizable=0;center=1;");
	if (data){
		if (data.id!=""){
			  spanname.innerHTML = data.name;
			//end
			inputname.value=data.id;
		}else{
			spanname.innerHTML = "";
			inputname.value="";
		}
	}
}

function onShowDepartment(){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+$G("department").value)    
    if (results) {
		if (results.id!="") {
		  $G("departmentspan").innerHTML =results.name.substr(1);
		  $G("department").value=results.id.substr(1);
		}else{
		  $G("departmentspan").innerHTML ="";
		  $G("department").value="";
		}
     }		
  }


function submitClear()
{
	window.parent.returnValue = {id:"",name:"",fieldtype:"",options:""};
	window.parent.close()
}

</script>
</BODY></HTML>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
