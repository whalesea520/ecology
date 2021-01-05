
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<%

if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
} 

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(32024,user.getLanguage());
String needfav ="";
String needhelp ="";

String ajax="1";
int design = 1;
int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
String isbill=Util.null2String(request.getParameter("isbill"));
String iscust="0";
request.getSession(true).setAttribute("por0_con","");
request.getSession(true).setAttribute("por0_con_cn","");
String nodetype="0";
char flag=2;
int iscreate = 1;

%>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:nodeopaddsave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form id="addopform" name="addopform" method=post action="Batchwf_operation.jsp" >
<input type="hidden" name="selectindex">
<input type="hidden" name="selectvalue">
<input type="hidden" name="nodetype_operatorgroup" value="<%=nodetype%>" >
<input type="hidden" value="<%=nodeid%>" name="nodeid">
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="<%=formid%>" name="formid">
<input type=hidden name=isbill value="<%=isbill%>">
<input type=hidden name=iscust value="<%=iscust%>">
<input type="hidden" value="<%=design%>" name="design">
<input type="hidden" name="singerorder_flag" id="singerorder_flag" value="0">
<input type="hidden" name="singerorder_type" id="singerorder_type" value="">
<input type="hidden" value="addoperatorgroup" name="src">
<input type="hidden" value="0" name="groupnum">

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

 			<table class="viewform" >
				<COLGROUP>
				  	<COL width="20%">
				  	<COL width="60%">
				  	<COL width="20%">
			  	</COLGROUP>
        		<TR class="Title">
    	  			<TH colSpan=3><b><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></b></TH>
				</TR>
  				<TR class="Spacing">
    	  			<TD class="Line1" colSpan=3></TD>
    	  		</TR>
		    	<tr>
			    	<td><%=SystemEnv.getHtmlLabelName(15545,user.getLanguage())%></td>
			    	<td class=field colSpan=2>
				    	<input class=Inputstyle type=text name="groupname" size=40 maxlength="60"  onchange='checkinput("groupname","groupnameimage")'>
				    	<SPAN id=groupnameimage><IMG src="/images/BacoError_wev8.gif" align=absMiddle></SPAN>
			    	</TD>
		    	</tr>
				<TR class="Spacing">
					<TD class="Line" colSpan=3></TD>
				</TR>
		
				<tr>
					<td><%=SystemEnv.getHtmlLabelName(2118,user.getLanguage()) %></td>
					<td class="Field">
						<BUTTON type="button" class=Browser onClick="onShowWorkflow('wfids','wfNamespan')" id="ShowWorkflow" name=ShowWorkflow></BUTTON>
						<SPAN id=wfNamespan><img src='/images/BacoError_wev8.gif' align=absmiddle></SPAN>
						<input type=hidden name="wfids" id="wfids" value="">
					</td>
				</tr>
				<TR class="Spacing">
					<TD class="Line" colSpan=3></TD>
				</TR>
			</table>
			<table class="viewform" >
			      	<COLGROUP>
			  	<COL width="20%">
			  	<COL width="40%">
			  	<COL width="40%">
			  	</COLGROUP>
			        <TR class="Title">
			    	  <TH colSpan=3><b><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></b></TH></TR>
			  		<TR class="Spacing">
			    	  <TD class="Line1" colSpan=3></TD></TR>
		    	  <tr>
			    	  <td colSpan=3>
			    	  <table width=100%>
			    	  <tr>
			    	  <td width=11%><nobr>
			    	  <input type=radio  name=operategroup checked value=1 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%>
			    	  </td>
			          <%if(!nodetype.equals("0")){%>
			    	  <td width=11%><nobr>
			    	  <input type=radio  name=operategroup value=2 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15549,user.getLanguage())%>
			    	  </nobr></td><td width=11%><nobr>
			    	  <input type=radio  name=operategroup value=3 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15550,user.getLanguage())%>
			    	  </nobr></td><td width=11%><nobr>
			    	  <input type=radio  name=operategroup value=4 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15551,user.getLanguage())%>
			    	  </nobr></td><td width=11%><nobr>
			    	  <input type=radio  name=operategroup value=5 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15552,user.getLanguage())%>
			    	  </nobr></td><td width=11%><nobr>
			    	  <input type=radio  name=operategroup value=6 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15553,user.getLanguage())%>
			    	  </nobr></td><td width=11%><nobr>
			    	  <input type=radio  name=operategroup value=7 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%>
			    	  </nobr></td>
			          <td width=11%><nobr>
			    	  <input type=radio  name=operategroup value=9 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%>
			    	  </nobr></td>
			          <%}%>
			    	  <td width=11%><nobr>
			    	  <%if(iscust.equals("1")){%>
			    	  <input type=radio  name=operategroup value=8 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%>
			    	  <%}%>
			    	  </nobr></td>
			    	  </tr></table></td>
		    	  </tr>
			</table>
			<div id=odiv_1 style="display:''">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="40%">
  	<COL width="10%">
  	<COL width="30%">
    <!-- 新增加分部 liuyu-->

     <tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('0','30')" name=tmptype id='tmptype_0' value=30><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
	<td>
	<%if(nodetype.equals("0")){%>
		<select id="signorder_0" name="signorder_0" onfocus="changelevel(tmptype_0)">
			<option value="1"><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
			<option value="2"><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
		</select>
	<%}else{%>
		<input type="hidden" id="signorder_0" name="signorder_0" value="0">
	<%}%>
     <%if(!ajax.equals("1")){%>
    <button type=button  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp','0',tmptype_0)"></button>
     <%}else if(!nodetype.equals("0")){%>
    <button type=button  class=Browser onclick="onShowBrowser4op('/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp','0',tmptype_0)"></button>
     <%}else{%>
       <button type=button  class=Browser onclick="onShowBrowser4opM1('/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp','0',tmptype_0)"></button>
     <%}%>
    <input type=hidden name=id_0>
          <span id=name_0 name=name_0></span>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_0 onfocus="changelevel(tmptype_0)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_0 onfocus="changelevel(tmptype_0)" style="width:40%" value=100>
    	</td>
    	</tr>
  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('1','1')" name=tmptype id='tmptype_1' value=1><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
	<td>
	<%if(nodetype.equals("0")){%>
		<select id="signorder_1" name="signorder_1" onfocus="changelevel(tmptype_1)">
			<option value="1"><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
			<option value="2"><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
		</select>
	<%}else{%>
		<input type="hidden" id="signorder_1" name="signorder_1" value="0">
	<%}%>
          <%if(!ajax.equals("1")){%>
      <button type=button  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','1',tmptype_1)"></button>
          <%}else if(!nodetype.equals("0")){%>
      <button type=button  class=Browser onclick="onShowBrowser4op('/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','1',tmptype_1)"></button>
          <%}else{%>
      <button type=button  class=Browser onclick="onShowBrowser4opM1('/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp','1',tmptype_1)"></button>
          <%}%>
      <input type=hidden name=id_1 value=0>
          <span id=name_1 name=name_1></span>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text  class=Inputstyle name=level_1 onfocus="changelevel(tmptype_1)" style="width:40%" value=0>-
    	<input type=text  class=Inputstyle name=level2_1 onfocus="changelevel(tmptype_1)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('2','2')" name=tmptype id='tmptype_2' value=2><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
	<td>
	<%if(nodetype.equals("0")){%>
		<select id="signorder_2" name="" onfocus="changelevel(tmptype_2)">
			<option value="1"><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
			<option value="2"><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
		</select>
	<%}else{%>
		<input type="hidden" id="signorder_2" name="signorder_2" value="0">
	<%}%>
          <%if(!ajax.equals("1")){%>
      <button type=button  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp','2',tmptype_2)"></button>
          <%}else{%>
      <button type=button  class=Browser onclick="onShowBrowser4op('/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp','2',tmptype_2)"></button>
          <%}%>
      <input type=hidden name=id_2 value=0>
          <span id=name_2 name=name_2></span>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td><td>
    	<select class=inputstyle  name=level_2  onfocus="changelevel(tmptype_2)" style="width:80%">
	    	<option value=0 ><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
	      <option value=1 ><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
		<%if(!nodetype.equals("0")){%><option value=3 ><%=SystemEnv.getHtmlLabelName(22753,user.getLanguage())%></option><%}%>
	      <option value=2 ><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
      </select>
    	</td>
    	</tr>

    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('3','3')" name=tmptype id='tmptype_3' value=3><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></td>
  	<td>
          <%if(!ajax.equals("1")){%>
      <button type=button  class=Browser onclick="onShowBrowserM('/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp','3',tmptype_3)"></button>
          <%}else{%>
      <button type=button  class=Browser onclick="onShowBrowser4opM('/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp','3',tmptype_3)"></button>
          <%}%>
      <input type=hidden name=id_3 value=0>
          <span id=name_3 name=name_3></span>
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle name=level_3 style="display:none">
    	</td>
    	</tr>
    	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('4','4')" name=tmptype id='tmptype_4' value=4 ><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></td>
  	<td>
  	<input type=text class=Inputstyle name=id_4 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_4  onfocus="changelevel(tmptype_4)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_4  onfocus="changelevel(tmptype_4)" style="width:40%" value=100>
    	</td>
    	</tr>
	
 </table>
</div>

<div id=odiv_2 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('5','5')" name=tmptype id='tmptype_5' value=5><%=SystemEnv.getHtmlLabelName(15555,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_5 onfocus="changelevel(tmptype_5)" style="width:50%">
  	<%
  	 String sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and (workflow_formdict.type = 1 or workflow_formdict.type=17 or workflow_formdict.type=165 or workflow_formdict.type=166) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 包括多人力资源字段
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=165 or type=166) and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
    <nobr><input type=radio name=signorder_5 value="0" onfocus="changelevel(tmptype_5)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp</nobr>
    	<nobr><input type=radio name=signorder_5 value="1" checked  onfocus="changelevel(tmptype_5)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp</nobr>
        <nobr><input type=radio name=signorder_5 value="2" onfocus="changelevel(tmptype_5)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%></nobr>
        <nobr><input type=radio name=signorder_5 value="3" onfocus="changelevel(tmptype_5)"><%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>&nbsp;&nbsp</nobr>
        <nobr><input type=radio name=signorder_5 value="4" onfocus="changelevel(tmptype_5)"><%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%></nobr>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('6','6')" name=tmptype id='tmptype_6' value=6 ><%=SystemEnv.getHtmlLabelName(15559,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_6 onfocus="changelevel(tmptype_6)" style="width:50%">
  	<%
  	  	  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and (workflow_formdict.type = 1 or workflow_formdict.type = 165) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid; // 不包括多人力资源字段
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=1 or type=165)  and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle name=level_6 style="display:none">

    	</td>
    	</tr>

        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('7','31')" name=tmptype id='tmptype_7' value=31><%=SystemEnv.getHtmlLabelName(15560,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_7 onfocus="changelevel(tmptype_7)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_7  onfocus="changelevel(tmptype_7)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_7  onfocus="changelevel(tmptype_7)" style="width:40%" value=100>
    	</td>
    	</tr>


          <tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('8','32')" name=tmptype id='tmptype_8' value=32><%=SystemEnv.getHtmlLabelName(15561,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_8 onfocus="changelevel(tmptype_8)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_8  onfocus="changelevel(tmptype_8)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_8  onfocus="changelevel(tmptype_8)" style="width:40%" value=100>
    	</td>
    	</tr>

    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('9','7')" name=tmptype id='tmptype_9' value=7><%=SystemEnv.getHtmlLabelName(15562,user.getLanguage())%></td>
        <td><select class=inputstyle  name=id_9 onfocus="changelevel(tmptype_9)" style="width:50%">
        <%
		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_9  onfocus="changelevel(tmptype_9)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_9  onfocus="changelevel(tmptype_9)" style="width:40%" value=100>
    	</td>
    	</tr>

        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('38','38')" name=tmptype id='tmptype_38' value=38><%=SystemEnv.getHtmlLabelName(15563,user.getLanguage())%></td>
  	    <td><select class=inputstyle  name=id_38 onfocus="changelevel(tmptype_38)" style="width:50%">
  	    <%
		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_38  onfocus="changelevel(tmptype_38)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_38  onfocus="changelevel(tmptype_38)" style="width:40%" value=100>
    	</td>
    	</tr>

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('42','42')" name=tmptype id='tmptype_42' value=42><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_42 onfocus="changelevel(tmptype_42)" style="width:50%">
  	<%
  	       sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and (workflow_formdict.type = 4 or workflow_formdict.type=57 or workflow_formdict.type=167 or workflow_formdict.type=168) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 多部门
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=4 or type=57 or type=167 or type=168)  and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td><input type=text class=Inputstyle name=level_42  onfocus="changelevel(tmptype_42)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_42  onfocus="changelevel(tmptype_42)" style="width:40%" value=100><br>
    	<input type=radio name=signorder_42 value="0" onfocus="changelevel(tmptype_42)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
    	<input type=radio name=signorder_42 value="1" checked  onfocus="changelevel(tmptype_42)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
        <input type=radio name=signorder_42 value="2" onfocus="changelevel(tmptype_42)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>&nbsp;&nbsp 
    	</td>
    	</tr>
    	
    	<!-- 组织架构部门负责人 -->
	  	<tr class=datalight style="display:none">
		  	<td><input type=radio onClick="setSelIndex('52','52')" name=tmptype id='tmptype_52' value=52><%=SystemEnv.getHtmlLabelName(27107,user.getLanguage())%></td>
		  	<td>
			  	<select class=inputstyle  name=id_52 onfocus="changelevel(tmptype_52)" style="width:50%">
		  		<%
					sql ="" ;
					if(isbill.equals("0")){
						sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 4 or workflow_formdict.type=57 or workflow_formdict.type=167 or workflow_formdict.type=168) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 多部门
					}else{
						sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=4 or type=57 or type=167 or type=168) and viewtype = 0" ;
					}
					RecordSet.executeSql(sql);
					while(RecordSet.next()){
				%>
						<option value=<%=RecordSet.getString("id")%>>
							<% if(isbill.equals("0")) {%> 
								<%=RecordSet.getString("name")%>
							<%} else {%> 
								<%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> 
							<%}%>
						</option>
				<%}%>
				</select>
	    	</td>
	    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
	    	<td>
	    		<input type=hidden class=Inputstyle name=level_52  onfocus="changelevel(tmptype_52)" style="width:40%" value=0>
		    	<input type=hidden class=Inputstyle name=level2_52  onfocus="changelevel(tmptype_52)" style="width:40%" value=100>
		    	<input type=radio name=signorder_52 value="0" onfocus="changelevel(tmptype_52)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
		    	<input type=radio name=signorder_52 value="1" checked  onfocus="changelevel(tmptype_52)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
		        <input type=radio name=signorder_52 value="2" onfocus="changelevel(tmptype_52)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>&nbsp;&nbsp
				<input type=radio name=signorder_52 value="3" onfocus="changelevel(tmptype_52)"><%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>&nbsp;&nbsp
				<input type=radio name=signorder_52 value="4" onfocus="changelevel(tmptype_52)"><%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>
	    	</td>
    	</tr>
    	
    	<!-- 组织架构部门分管领导 -->
	  	<tr class=datalight style="display:none">
		  	<td><input type=radio onClick="setSelIndex('53','53')" name=tmptype id='tmptype_53' value=53><%=SystemEnv.getHtmlLabelName(27108,user.getLanguage())%></td>
		  	<td>
			  	<select class=inputstyle  name=id_53 onfocus="changelevel(tmptype_53)" style="width:50%">
		  		<%
					sql ="" ;
					if(isbill.equals("0")){
						sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 4 or workflow_formdict.type=57 or workflow_formdict.type=167 or workflow_formdict.type=168) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 多部门
					}else{
						sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=4 or type=57 or type=167 or type=168) and viewtype = 0" ;
					}
					RecordSet.executeSql(sql);
					while(RecordSet.next()){
				%>
						<option value=<%=RecordSet.getString("id")%>>
							<% if(isbill.equals("0")) {%> 
								<%=RecordSet.getString("name")%>
							<%} else {%> 
								<%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> 
							<%}%>
						</option>
				<%}%>
				</select>
	    	</td>
	    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
	    	<td>
	    		<input type=hidden class=Inputstyle name=level_53  onfocus="changelevel(tmptype_53)" style="width:40%" value=0>
		    	<input type=hidden class=Inputstyle name=level2_53  onfocus="changelevel(tmptype_53)" style="width:40%" value=100>
		    	<input type=radio name=signorder_53 value="0" onfocus="changelevel(tmptype_53)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
		    	<input type=radio name=signorder_53 value="1" checked  onfocus="changelevel(tmptype_53)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
		        <input type=radio name=signorder_53 value="2" onfocus="changelevel(tmptype_53)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>&nbsp;&nbsp
				<input type=radio name=signorder_53 value="3" onfocus="changelevel(tmptype_53)"><%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>&nbsp;&nbsp
				<input type=radio name=signorder_53 value="4" onfocus="changelevel(tmptype_53)"><%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>
	    	</td>
    	</tr>
    	
    	<!-- 矩阵管理部门负责人 -->
	  	<tr class=datalight style="display:none">
		  	<td><input type=radio onClick="setSelIndex('54','54')" name=tmptype id='tmptype_54' value=54><%=SystemEnv.getHtmlLabelName(27109,user.getLanguage())%></td>
		  	<td>
			  	<select class=inputstyle  name=id_54 onfocus="changelevel(tmptype_54)" style="width:50%">
		  		<%
					sql ="" ;
					if(isbill.equals("0")){
						sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 4 or workflow_formdict.type=57 or workflow_formdict.type=167 or workflow_formdict.type=168) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 多部门
					}else{
						sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=4 or type=57 or type=167 or type=168) and viewtype = 0" ;
					}
					RecordSet.executeSql(sql);
					while(RecordSet.next()){
				%>
						<option value=<%=RecordSet.getString("id")%>>
							<% if(isbill.equals("0")) {%> 
								<%=RecordSet.getString("name")%>
							<%} else {%> 
								<%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> 
							<%}%>
						</option>
				<%}%>
				</select>
	    	</td>
	    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
	    	<td>
	    		<input type=hidden class=Inputstyle name=level_54  onfocus="changelevel(tmptype_54)" style="width:40%" value=0>
		    	<input type=hidden class=Inputstyle name=level2_54  onfocus="changelevel(tmptype_54)" style="width:40%" value=100>
		    	<input type=radio name=signorder_54 value="0" onfocus="changelevel(tmptype_54)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
		    	<input type=radio name=signorder_54 value="1" checked  onfocus="changelevel(tmptype_54)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
		        <input type=radio name=signorder_54 value="2" onfocus="changelevel(tmptype_54)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>&nbsp;&nbsp
				<input type=radio name=signorder_54 value="3" onfocus="changelevel(tmptype_54)"><%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>&nbsp;&nbsp
				<input type=radio name=signorder_54 value="4" onfocus="changelevel(tmptype_54)"><%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>
	    	</td>
    	</tr>
    	
    	<!-- 矩阵管理部门分管领导 -->
	  	<tr class=datalight style="display:none">
		  	<td><input type=radio onClick="setSelIndex('55','55')" name=tmptype id='tmptype_55' value=55><%=SystemEnv.getHtmlLabelName(27110,user.getLanguage())%></td>
		  	<td>
			  	<select class=inputstyle  name=id_55 onfocus="changelevel(tmptype_55)" style="width:50%">
		  		<%
					sql ="" ;
					if(isbill.equals("0")){
						sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type = 4 or workflow_formdict.type=57 or workflow_formdict.type=167 or workflow_formdict.type=168) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 多部门
					}else{
						sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=4 or type=57 or type=167 or type=168) and viewtype = 0" ;
					}
					RecordSet.executeSql(sql);
					while(RecordSet.next()){
				%>
						<option value=<%=RecordSet.getString("id")%>>
							<% if(isbill.equals("0")) {%> 
								<%=RecordSet.getString("name")%>
							<%} else {%> 
								<%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> 
							<%}%>
						</option>
				<%}%>
				</select>
	    	</td>
	    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
	    	<td>
	    		<input type=hidden class=Inputstyle name=level_55  onfocus="changelevel(tmptype_55)" style="width:40%" value=0>
		    	<input type=hidden class=Inputstyle name=level2_55  onfocus="changelevel(tmptype_55)" style="width:40%" value=100>
		    	<input type=radio name=signorder_55 value="0" onfocus="changelevel(tmptype_55)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
		    	<input type=radio name=signorder_55 value="1" checked  onfocus="changelevel(tmptype_55)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
		        <input type=radio name=signorder_55 value="2" onfocus="changelevel(tmptype_55)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>&nbsp;&nbsp
				<input type=radio name=signorder_55 value="3" onfocus="changelevel(tmptype_55)"><%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>&nbsp;&nbsp
				<input type=radio name=signorder_55 value="4" onfocus="changelevel(tmptype_55)"><%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>
	    	</td>
    	</tr>

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('51','51')" name=tmptype id='tmptype_51' value=51><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_51 onfocus="changelevel(tmptype_51)" style="width:50%">
  	<%
  	       sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and (workflow_formdict.type=164 or workflow_formdict.type=169 or workflow_formdict.type=170) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 分部
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=164 or type=169 or type=170) and viewtype = 0" ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td>
    	<td><input type=text class=Inputstyle name=level_51  onfocus="changelevel(tmptype_51)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_51  onfocus="changelevel(tmptype_51)" style="width:40%" value=100><br>
    	<input type=radio name=signorder_51 value="0" onfocus="changelevel(tmptype_51)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
    	<input type=radio name=signorder_51 value="1" checked  onfocus="changelevel(tmptype_51)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
        <input type=radio name=signorder_51 value="2" onfocus="changelevel(tmptype_51)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>&nbsp;&nbsp  
    	</td>
    	</tr>

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('43','43')" name=tmptype id='tmptype_43' value=43><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_43 onfocus="changelevel(tmptype_43)" style="width:50%">
  	<%
  	       sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and workflow_formdict.type = 65 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 多角色
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=65 and viewtype = 0 " ;
          //System.out.println("sql = " + sql);

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
    	<input type=radio name=signorder_43 value="0" onfocus="changelevel(tmptype_43)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
    	<input type=radio name=signorder_43 value="1" checked  onfocus="changelevel(tmptype_43)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
    	</td>
    	</tr>

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('49','49')" name=tmptype id='tmptype_49' value=49><%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_49 onfocus="changelevel(tmptype_49)" style="width:50%">
  	<%
		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault='1' and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype='3' and workflow_formdict.type = 142  and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 收发文单位字段
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=142 and viewtype = 0 " ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
        <input type=radio name=signorder_49 value="0" onfocus="changelevel(tmptype_49)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
    	<input type=radio name=signorder_49 value="1" checked  onfocus="changelevel(tmptype_49)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
    	</td>
    	</tr>
<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('50','50')" name=tmptype id='tmptype_50' value=50><%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_50 onfocus="changelevel(tmptype_50)" style="width:50%">
  	<%
  	       sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and ( workflow_formdict.type=160) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 角色人员
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=160) and viewtype = 0 " ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
          <%if(!ajax.equals("1")){%>
      <button type=button  class=Browser onclick="onShowBrowserLevel('/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp','50',tmptype_50)"></button>
          <%}else{%>
      <button type=button  class=Browser onclick="onShowBrowser4opLevel('/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp','50',tmptype_50)"></button>
          <%}%>
      <input type="hidden" id="level_50" name="level_50" value="0">
          <span id="templevel_50" name="templevel_50"></span>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(22691,user.getLanguage())%>
			<select id="level2_50" name="level2_50" class="inputstyle" onfocus="changelevel(tmptype_50)">
				<option value="0"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
				<option value="1"><%=SystemEnv.getHtmlLabelName(22689,user.getLanguage())%></option>
				<option value="2"><%=SystemEnv.getHtmlLabelName(22690,user.getLanguage())%></option>
				<option value="3"><%=SystemEnv.getHtmlLabelName(22667,user.getLanguage())%></option>
			</select>
		</td>
		<td>
        <input type=radio name=signorder_50 value="0" onfocus="changelevel(tmptype_50)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
    	<input type=radio name=signorder_50 value="1" checked  onfocus="changelevel(tmptype_50)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp
        <input type=radio name=signorder_50 value="2" onfocus="changelevel(tmptype_50)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>&nbsp;&nbsp
    	</td>
    	</tr>
 </table>
</div>

<div id=odiv_3 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('10','8')" name=tmptype id='tmptype_10' value=8><%=SystemEnv.getHtmlLabelName(15564,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_10 style="width:50%" onfocus="changelevel(tmptype_10)">
  	<%
  	  sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and workflow_formdict.type = 9 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=9 and viewtype = 0 " ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td><input type=text class=Inputstyle name=level_10 style="display:none">
    	</td>
    	</tr>
        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('11','33')" name=tmptype id='tmptype_11' value=33><%=SystemEnv.getHtmlLabelName(15565,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_11 onfocus="changelevel(tmptype_11)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_11  onfocus="changelevel(tmptype_11)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_11  onfocus="changelevel(tmptype_11)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('12','9')" name=tmptype id='tmptype_12' value=9><%=SystemEnv.getHtmlLabelName(15566,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_12 onfocus="changelevel(tmptype_12)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_12  onfocus="changelevel(tmptype_12)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_12  onfocus="changelevel(tmptype_12)" style="width:40%" value=100>
    	</td>
    	</tr>
 </table>
</div>


<div id=odiv_4 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('13','10')" name=tmptype id='tmptype_13' value=10><%=SystemEnv.getHtmlLabelName(15567,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_13 style="width:50%" onfocus="changelevel(tmptype_13)">
  	<%
  	  sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and workflow_formdict.type = 8 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=8 and viewtype = 0 " ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td><input type=text class=Inputstyle name=level_13 style="display:none">

    	</td>
    	</tr>


        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('47','47')" name=tmptype id='tmptype_47' value=47><%=SystemEnv.getHtmlLabelName(18680, user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_47 onfocus="changelevel(tmptype_47)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle name=level_47 style="display:none">

    	</td>
    	</tr>


        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('14','34')" name=tmptype id='tmptype_14' value=34><%=SystemEnv.getHtmlLabelName(15568,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_14 onfocus="changelevel(tmptype_14)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_14  onfocus="changelevel(tmptype_14)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_14  onfocus="changelevel(tmptype_14)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('15','11')" name=tmptype id='tmptype_15' value=11><%=SystemEnv.getHtmlLabelName(15569,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_15 onfocus="changelevel(tmptype_15)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_15  onfocus="changelevel(tmptype_15)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_15  onfocus="changelevel(tmptype_15)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('16','12')" name=tmptype id='tmptype_16' value=12><%=SystemEnv.getHtmlLabelName(15570,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_16 onfocus="changelevel(tmptype_16)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_16  onfocus="changelevel(tmptype_16)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_16  onfocus="changelevel(tmptype_16)" style="width:40%" value=100>
    	</td>
    	</tr>

        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('48','48')" name=tmptype id='tmptype_48' value=48><%=SystemEnv.getHtmlLabelName(18681, user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_48 onfocus="changelevel(tmptype_48)" style="width:50%">
  	<%

          sql="";
		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and workflow_formdict.type = 87 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=87 and viewtype = 0 " ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><%=(isbill.equals("0"))?RecordSet.getString("name"):SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name"),0),user.getLanguage())%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle name=level_48 style="display:none">

    	</td>
    	</tr>



 </table>
</div>

<div id=odiv_5 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('17','13')" name=tmptype id='tmptype_17' value=13><%=SystemEnv.getHtmlLabelName(15571,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_17 style="width:50%" onfocus="changelevel(tmptype_17)">
  	<%
  	  sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and workflow_formdict.type = 23 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=23 and viewtype = 0 " ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle name=level_17 style="display:none">
    	</td>
    	</tr>
        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('18','35')" name=tmptype id='tmptype_18' value=35><%=SystemEnv.getHtmlLabelName(15572,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_18 onfocus="changelevel(tmptype_18)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_18  onfocus="changelevel(tmptype_18)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_18  onfocus="changelevel(tmptype_18)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('19','14')" name=tmptype id='tmptype_19' value=14><%=SystemEnv.getHtmlLabelName(15573,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_19 onfocus="changelevel(tmptype_19)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_19  onfocus="changelevel(tmptype_19)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_19  onfocus="changelevel(tmptype_19)" style="width:40%" value=100>
    	</td>
    	</tr>
 </table>
</div>

<div id=odiv_6 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('20','15')" name=tmptype id='tmptype_20' value=15><%=SystemEnv.getHtmlLabelName(15574,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_20 style="width:50%" onfocus="changelevel(tmptype_20)">
  	<%
  	  sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and workflow_formdict.type = 7 and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and type=7 and viewtype = 0 " ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle name=level_20 style="display:none">
    	</td>
    	</tr>

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('44','44')" name=tmptype id='tmptype_44' value=44><%=SystemEnv.getHtmlLabelName(17204,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_44 style="width:50%" onfocus="changelevel(tmptype_44)">
  	<%
		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle name=level_44 style="display:none">
    	</td>
    	</tr>

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('45','45')" name=tmptype id='tmptype_45' value=45><%=SystemEnv.getHtmlLabelName(18678, user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_45 style="width:50%" onfocus="changelevel(tmptype_45)">
  	<%
		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_45  onfocus="changelevel(tmptype_45)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_45  onfocus="changelevel(tmptype_45)" style="width:40%" value=100>
    	</td>
    	</tr>

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('46','46')" name=tmptype id='tmptype_46' value=46><%=SystemEnv.getHtmlLabelName(18679, user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_46 style="width:50%" onfocus="changelevel(tmptype_46)">
  	<%
		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_46  onfocus="changelevel(tmptype_46)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_46  onfocus="changelevel(tmptype_46)" style="width:40%" value=100>
    	</td>
    	</tr>



    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('21','16')" name=tmptype id='tmptype_21' value=16><%=SystemEnv.getHtmlLabelName(15575,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_21 onfocus="changelevel(tmptype_21)" style="width:50%">
  	<%

		  RecordSet.beforFirst();
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td></td><td><input type=text class=Inputstyle name=level_21 style="display:none">
    	</td>
    	</tr>
 </table>
</div>

<div id=odiv_7 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
        <COL width="35%">
        <COL width="10%">
        <COL width="35%">

        <tr class=datalight >
        <td><input type=radio onClick="setSelIndex('22','17')" name=tmptype id='tmptype_22' value=17><%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%></td>
        <td>
    	<input type=text class=Inputstyle name=id_22 style="display:none">
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle name=level_22 style="display:none">
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('23','18')" name=tmptype id='tmptype_23' value=18><%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%></td>
  	    <td>
    	<input type=text class=Inputstyle name=id_23 style="display:none">
    	</td>
    	<td></td><td>
    	<input type=text class=Inputstyle name=level_23 style="display:none">
    	</td>
    	</tr>
        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('24','36')" name=tmptype id='tmptype_24' value=36><%=SystemEnv.getHtmlLabelName(15576,user.getLanguage())%></td>
  	    <td>
    	<input type=text class=Inputstyle name=id_24 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_24  onfocus="changelevel(tmptype_24)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_24  onfocus="changelevel(tmptype_24)" style="width:40%" value=100>
    	</td>
    	</tr>

        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('25','37')" name=tmptype id='tmptype_25' value=37><%=SystemEnv.getHtmlLabelName(15577,user.getLanguage())%></td>
  	    <td>
    	<input type=text class=Inputstyle name=id_25 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_25  onfocus="changelevel(tmptype_25)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_25  onfocus="changelevel(tmptype_25)" style="width:40%" value=100>
    	</td>
    	</tr>

    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('26','19')" name=tmptype id='tmptype_26' value=19><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%></td>
  	    <td>
    	<input type=text class=Inputstyle name=id_26 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_26  onfocus="changelevel(tmptype_26)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_26  onfocus="changelevel(tmptype_26)" style="width:40%" value=100>
    	</td>
    	</tr>
        <tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('39','39')" name=tmptype id='tmptype_39' value=39><%=SystemEnv.getHtmlLabelName(15578,user.getLanguage())%></td>
  	    <td>
    	<input type=text class=Inputstyle name=id_39 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_39  onfocus="changelevel(tmptype_39)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_39  onfocus="changelevel(tmptype_39)" style="width:40%" value=100>
    	</td>
    	</tr>
 </table>
</div>


<div id=odiv_8 style="display:none">
<table class=liststyle cellspacing=1  >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">
<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('27','20')" name=tmptype id='tmptype_27' value=20><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%></td>
  	<td>
  	<select class=inputstyle  name=id_27 onfocus="changelevel(tmptype_27)" style="width:50%">
  	<%

		  RecordSet.executeProc("CRM_CustomerType_SelectAll","");
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><%=Util.toScreen(RecordSet.getString("fullname"),user.getLanguage())%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_27  onfocus="changelevel(tmptype_27)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_27  onfocus="changelevel(tmptype_27)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('28','21')" name=tmptype id='tmptype_28' value=21><%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%></td>
            <%if(!ajax.equals("1")){%>
      <td><button type=button  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp','28',tmptype_28)"></button>
            <%}else{%>
      <td><button type=button  class=Browser onclick="onShowBrowser4op('/systeminfo/BrowserMain.jsp?url=/CRM/Maint/CustomerStatusBrowser.jsp','28',tmptype_28)"></button>
            <%}%>
      <input type=hidden name=id_28 value=0>
          <span id=name_28 name=name_28></span>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_28  onfocus="changelevel(tmptype_28)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_28  onfocus="changelevel(tmptype_28)" style="width:40%" value=100>
    	</td>
    	</tr>

    	<tr class=datalight >
    	<td><input type=radio onClick="setSelIndex('29','22')" name=tmptype id='tmptype_29' value=22><%=SystemEnv.getHtmlLabelName(15579,user.getLanguage())%></td>
  	<td>
          <%if(!ajax.equals("1")){%>
      <button type=button  class=Browser onclick="onShowBrowser('/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','29',tmptype_29)"></button>
          <%}else{%>
      <button type=button  class=Browser onclick="onShowBrowser4op('/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp','29',tmptype_29)"></button>
          <%}%>
      <input type=hidden name=id_29 value=0>
          <span id=name_29 name=name_29></span>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_29  onfocus="changelevel(tmptype_29)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_29  onfocus="changelevel(tmptype_29)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight <%if(nodetype.equals("0")){%> style="display:none" <%}%>>
    	<td><input type=radio onClick="setSelIndex('30','23')" name=tmptype id='tmptype_30' value=23><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%></td>
    	<td><select class=inputstyle  name=id_30 style="width:50%" onfocus="changelevel(tmptype_30)">
  	<%
  	 sql ="" ;
  	 if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and (workflow_formdict.type = 1 or workflow_formdict.type=17 or workflow_formdict.type=165 or workflow_formdict.type=166) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=165 or type=166) and viewtype = 0 " ;

		  RecordSet.executeSql(sql);
		   while(RecordSet.next()){
		 %>
  	<option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_30  onfocus="changelevel(tmptype_30)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_30  onfocus="changelevel(tmptype_30)" style="width:40%" value=100>
    	</td>
    	</tr>
    	<tr class=datalight <%if(nodetype.equals("0")){%> style="display:none" <%}%>>
    	<td><input type=radio onClick="setSelIndex('31','24')" name=tmptype id='tmptype_31' value=24><%=SystemEnv.getHtmlLabelName(15580,user.getLanguage())%></td>
  	<td><select class=inputstyle  name=id_31 style="width:50%" onfocus="changelevel(tmptype_31)">
  	<%
  	  sql ="" ;

		  if(isbill.equals("0"))
			  sql = "select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and workflow_formfield.fieldid = workflow_formdict.id and workflow_formdict.fieldhtmltype=3 and (workflow_formdict.type = 7 or workflow_formdict.type = 18 ) and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;
		  else
			  sql = "select id as id , fieldlabel as name from workflow_billfield where billid="+ formid+ " and fieldhtmltype = '3' and (type=7 or type=18) and viewtype = 0  " ;

		  RecordSet.executeSql(sql);
		  while(RecordSet.next()){
		  %>
		  <option value=<%=RecordSet.getString("id")%>><% if(isbill.equals("0")) {%> <%=RecordSet.getString("name")%>
			  <%} else {%> <%=SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage())%> <%}%></option>
		  <%}%>
		  </select>
    	</td>
    	<td><input type=text name=level_31 style="display:none"></td>
    <td>
    	<input type=radio name=signorder_31 value="0" onfocus="changelevel(tmptype_31)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp;
    	<input type=radio name=signorder_31 value="1" checked  onfocus="changelevel(tmptype_31)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp;
	</td>
    	</tr>

    	 <tr class=datalight>
    	<td><input type=radio onClick="setSelIndex('32','25')" name=tmptype id='tmptype_32' value=25><%=SystemEnv.getHtmlLabelName(15581,user.getLanguage())%></td>
  	<td><input type=text class=Inputstyle name=id_32 style="display:none">
    	</td>
    	<td><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></td><td>
    	<input type=text class=Inputstyle name=level_32  onfocus="changelevel(tmptype_32)" style="width:40%" value=0>-
    	<input type=text class=Inputstyle name=level2_32  onfocus="changelevel(tmptype_32)" style="width:40%" value=100>
    	</td>
    	</tr>
 </table>
</div>


<div id=odiv_9 style="display:none">

<%
    ArrayList nodeids = new ArrayList() ;
    ArrayList nodenames = new ArrayList() ;

    WFNodeMainManager.setWfid(wfid);
    WFNodeMainManager.selectWfNode();
    while(WFNodeMainManager.next()){
        int tmpid = WFNodeMainManager.getNodeid();
        String tmpname = WFNodeMainManager.getNodename();
        nodeids.add(""+tmpid) ;
        nodenames.add(tmpname) ;
    }

    WFNodeMainManager.closeStatement();
%>


<table Class=liststyle cellspacing=1>
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">

  	<tr class=datalight >
  	<td><input type=radio onClick="setSelIndex('40','40')" name=tmptype id='tmptype_40' value=40><%=SystemEnv.getHtmlLabelName(18676,user.getLanguage())%></td>
  	<td>
  	<select name=id_40 onfocus="changelevel(tmptype_40)" style="width:50%">
        <%
        for(int i=0 ; i< nodeids.size() ; i++ ) {
            String tmpid = (String) nodeids.get(i);
            String tmpname = (String) nodenames.get(i);
            if(tmpid.equals(""+nodeid))
            {
            	continue;
            }
        %>
            <option value="<%=tmpid%>"><strong><%=tmpname%></strong>
        <%}%>
    </select>
    </td>
    <td><input type=text name=level_40 style="display:none"></td>
    <td>
    	<input type=radio name=signorder_40 value="0" onfocus="changelevel(tmptype_40)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
    	<input type=radio name=signorder_40 value="1" checked  onfocus="changelevel(tmptype_40)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp			
	</td>
    </tr>
    <tr class=datalight >
    <td><input type=radio onClick="setSelIndex('41','41')" name=tmptype id='tmptype_41' value=41 ><%=SystemEnv.getHtmlLabelName(18677,user.getLanguage())%></td>
  	<td>
  	<select name=id_41 onfocus="changelevel(tmptype_41)" style="width:50%">
        <%
        for(int i=0 ; i< nodeids.size() ; i++ ) {
            String tmpid = (String) nodeids.get(i);
            String tmpname = (String) nodenames.get(i);
            if(tmpid.equals(""+nodeid))
            {
            	continue;
            }
        %>
            <option value="<%=tmpid%>"><strong><%=tmpname%></strong>
        <%}%>
    </select>
    </td>
    <td><input type=text name=level_41 style="display:none"></td>
    <td>
    	<input type=radio name=signorder_41 value="0" onfocus="changelevel(tmptype_41)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>&nbsp;&nbsp
    	<input type=radio name=signorder_41 value="1" checked  onfocus="changelevel(tmptype_41)"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>&nbsp;&nbsp			
	</td>
    </tr>
 </table>
</div>
<%if (!nodetype.equals("0")) {%>
<table class="viewform" >
      	<COLGROUP>
  	<COL width="20%">
  	<COL width="40%">
  	<COL width="40%">
  	<TR class="Spacing">
    	  <TD class="Line1" colSpan=3></TD></TR>
        <TR class="Title">
    	  <TH colSpan=3><b><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></b></TH></TR>
  	<TR class="Spacing">
    	  <TD class="Line1" colSpan=3></TD></TR>
    	  <tr>
    	  <td colSpan=3>
    	  <table width=100%>
    	  <tr>
    	  <td width="80%"><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>
    	  
    	  <%if(!ajax.equals("1")){%>
    	  <button type=button  class=Browser onclick="onShowBrowser4s('<%=wfid%>','<%=formid%>','<%=isbill%>')"></button>
    	  <%}else {%>
    	  <button type=button  class=Browser onclick="onShowBrowsers('<%=wfid%>','<%=formid%>','<%=isbill%>')"></button>
    	  <%}%>
    	  <input type=hidden name=fromsrc id=fromsrc value="2">
    	  <input type=hidden name=conditionss id=conditionss>
    	  <input type=hidden name=conditioncn id=conditioncn>
		  <span id="conditions">
		  
		   </span>
		   
    	  </td>
          <td width="20%"><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%>
              	<input type=text class=Inputstyle name=orders  onchange="check_number('orders');checkDigit(this,5,2)"  maxlength="5" style="width:40%"></td>
              	
    	  </tr></table></td>
    	  
    	  </tr>
<tr>
        <td colspan="3">
            <table class="viewform" id="Tab_Coadjutant" name="Tab_Coadjutant" style="display:none">
                <input type=hidden name=IsCoadjutant id=IsCoadjutant>
              <input type=hidden name=signtype id=signtype>
              <input type=hidden name=issyscoadjutant id=issyscoadjutant>
              <input type=hidden name=coadjutants id=coadjutants>
              <input type=hidden name=coadjutantnames id=coadjutantnames>
              <input type=hidden name=issubmitdesc id=issubmitdesc>
              <input type=hidden name=ispending id=ispending>
              <input type=hidden name=isforward id=isforward>
              <input type=hidden name=ismodify id=ismodify>
              <input type=hidden name=Coadjutantconditions id=Coadjutantconditions>
      	<COLGROUP>
  	<COL width="20%">
  	<COL width="40%">
  	<COL width="40%">
          <TR class="Spacing">
    	  <TD class="Line" colSpan=3></TD></TR>
    	  <tr>
    	  <td colSpan=3><%=SystemEnv.getHtmlLabelName(22675,user.getLanguage())%>
              <button type=button  class=Browser onclick="onShowCoadjutantBrowser()"></button>
              <span id="Coadjutantconditionspan"></span>
    	  </td>

    	  </tr>
</table>
        </td>
    </tr>
</table>
<%}
else {%>
<input type=hidden name=fromsrc id=fromsrc value="2">
<input type=hidden name=conditionss id=conditionss>
<input type=hidden name=conditioncn id=conditioncn>
<span id="conditions">
</span>
<input type=hidden name=orders  value=0>
<table class="viewform" id="Tab_Coadjutant" name="Tab_Coadjutant" style="display:none">
     <input type=hidden name=IsCoadjutant id=IsCoadjutant>
     <input type=hidden name=signtype id=signtype>
     <input type=hidden name=issyscoadjutant id=issyscoadjutant>
     <input type=hidden name=coadjutants id=coadjutants>
     <input type=hidden name=coadjutantnames id=coadjutantnames>
     <input type=hidden name=issubmitdesc id=issubmitdesc>
     <input type=hidden name=ispending id=ispending>
     <input type=hidden name=isforward id=isforward>
     <input type=hidden name=ismodify id=ismodify>
     <input type=hidden name=Coadjutantconditions id=Coadjutantconditions>
     <COLGROUP>
         <COL width="20%">
         <COL width="40%">
         <COL width="40%">
         <TR class="Spacing">
             <TD class="Line" colSpan=3></TD>
         </TR>
         <tr>
             <td colSpan=3><%=SystemEnv.getHtmlLabelName(22675, user.getLanguage())%>
                 <button type=button  class=Browser onclick="onShowCoadjutantBrowser()"></button>
                 <span id="Coadjutantconditionspan"></span>
             </td>

         </tr>
 </table> 
<%}%>
<table class="viewform" >
      	<COLGROUP>
      	<COL width="20%">
  	<COL width="35%">
  	<COL width="10%">
  	<COL width="35%">
  	<TR class="Spacing">
    	  <TD class="Line1" colSpan=4></TD></TR>
</table>
<div>
    <%if(!ajax.equals("1")){%>
<button type=button  Class=Btn type=button accessKey=A onclick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%></BUTTON>
<button type=button  Class=Btn type=button accessKey=D onclick="if(isdel()){deleteRow();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%></BUTTON></div>
    <%}else{%>
<button type=button  Class=Btn type=button accessKey=A onclick="addRow4op();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%></BUTTON>
<button type=button  Class=Btn type=button accessKey=D onclick="if(isdel()){deleteRow4op();}"><U>D</U>-<%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%></BUTTON></div>
    <%}%>
<table class="viewform" >
      	<COLGROUP>
  	<COL width="20%">
  	<COL width="80%">
  	<TR class="Spacing">
    	  <TD class="Line1" colSpan=2></TD></TR>

</table>
<%if(!ajax.equals("1")){%>
<table class=liststyle cellspacing=1   cols=7 id="oTable">
<%}else{%>
<table class=liststyle cellspacing=1   cols=7 id="oTable4op">
<%}%>
      	<COLGROUP>
  	<COL width="4%">
  	<COL width="20%">
  	<COL width="10%">
  	<COL width="13%">
	<COL width="10%">
  	<COL width="36%">
  	<COL width="7%">
  	<tr class=header>
            <td><%=SystemEnv.getHtmlLabelName(1426,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></td>
			<td><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(22671,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></td>
            <td><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%></td>
</tr>
<tr class="Line"><td colspan="7"></td></tr>
</table>
<BR>
<BR>
<BR>
<table class=ReportStyle>
<TBODY>
<TR><TD>
<B><%=SystemEnv.getHtmlLabelName(19010,user.getLanguage())%></B>:<BR>
<B><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(19013,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(19012,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(18739,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(19011,user.getLanguage())%>
<BR>
<B><%=SystemEnv.getHtmlLabelName(2084,user.getLanguage())%>：</B><%=SystemEnv.getHtmlLabelName(27761,user.getLanguage())%>
<BR>
</TD>
</TR>
</TBODY>
</table>
</td>
		</tr>
		</TABLE>

	</td>
	<td></td>
</tr>

</table>
</form>


<%if(design==1){%>
<script language=vbs>
sub onChangetype(objval)
	if objval=1 then
		odiv_1.style.display=""
		odiv_2.style.display="none"
		odiv_3.style.display="none"
		odiv_4.style.display="none"
		odiv_5.style.display="none"
		odiv_6.style.display="none"
		odiv_7.style.display="none"
		odiv_8.style.display="none"
        odiv_9.style.display="none"
	end if
	if objval=2 then
		odiv_1.style.display="none"
		odiv_2.style.display=""
		odiv_3.style.display="none"
		odiv_4.style.display="none"
		odiv_5.style.display="none"
		odiv_6.style.display="none"
		odiv_7.style.display="none"
		odiv_8.style.display="none"
        odiv_9.style.display="none"
	end if
	if objval=3 then
		odiv_1.style.display="none"
		odiv_2.style.display="none"
		odiv_3.style.display=""
		odiv_4.style.display="none"
		odiv_5.style.display="none"
		odiv_6.style.display="none"
		odiv_7.style.display="none"
		odiv_8.style.display="none"
        odiv_9.style.display="none"
	end if
	if objval=4 then
		odiv_1.style.display="none"
		odiv_2.style.display="none"
		odiv_3.style.display="none"
		odiv_4.style.display=""
		odiv_5.style.display="none"
		odiv_6.style.display="none"
		odiv_7.style.display="none"
		odiv_8.style.display="none"
        odiv_9.style.display="none"
	end if
	if objval=5 then
		odiv_1.style.display="none"
		odiv_2.style.display="none"
		odiv_3.style.display="none"
		odiv_4.style.display="none"
		odiv_5.style.display=""
		odiv_6.style.display="none"
		odiv_7.style.display="none"
		odiv_8.style.display="none"
        odiv_9.style.display="none"
	end if
	if objval=6 then
		odiv_1.style.display="none"
		odiv_2.style.display="none"
		odiv_3.style.display="none"
		odiv_4.style.display="none"
		odiv_5.style.display="none"
		odiv_6.style.display=""
		odiv_7.style.display="none"
		odiv_8.style.display="none"
        odiv_9.style.display="none"
	end if
	if objval=7 then
		odiv_1.style.display="none"
		odiv_2.style.display="none"
		odiv_3.style.display="none"
		odiv_4.style.display="none"
		odiv_5.style.display="none"
		odiv_6.style.display="none"
		odiv_7.style.display=""
		odiv_8.style.display="none"
        odiv_9.style.display="none"
	end if
	if objval=8 then
		odiv_1.style.display="none"
		odiv_2.style.display="none"
		odiv_3.style.display="none"
		odiv_4.style.display="none"
		odiv_5.style.display="none"
		odiv_6.style.display="none"
		odiv_7.style.display="none"
		odiv_8.style.display=""
        odiv_9.style.display="none"
	end if
    if objval=9 then
		odiv_1.style.display="none"
		odiv_2.style.display="none"
		odiv_3.style.display="none"
		odiv_4.style.display="none"
		odiv_5.style.display="none"
		odiv_6.style.display="none"
		odiv_7.style.display="none"
		odiv_8.style.display="none"
        odiv_9.style.display=""
	end if

end sub

sub onShowBrowser(url,index,tmpindex)
	tmpid = "id_"&index
	tmpname = "name_"&index
	id = window.showModalDialog(url)
	if NOT isempty(id) then
	        if id(0)<> "" then
			document.all(tmpname).innerHtml = id(1)
			document.all(tmpid).value=id(0)
			tmpindex.checked = true
            tmpid = tmpindex.id
            document.addopform.selectindex.value = Mid(tmpid,9,len(tmpid))
            document.addopform.selectvalue.value = tmpindex.value
		else
			document.all(tmpname).innerHtml = empty
			document.all(tmpid).value="0"
		end if
	end if
end sub

sub onShowBrowserLevel(url,index,tmpindex)
tmpid = "level_"&index
	tmpname = "templevel_"&index
	id = window.showModalDialog(url)
	if NOT isempty(id) then
	        if id(0)<> "" then
			document.all(tmpname).innerHtml = id(1)
			document.all(tmpid).value=id(0)
			tmpindex.checked = true
            tmpid = tmpindex.id
            document.addopform.selectindex.value = Mid(tmpid,9,len(tmpid))
            document.addopform.selectvalue.value = tmpindex.value
		else
			document.all(tmpname).innerHtml = empty
			document.all(tmpid).value="0"
		end if
	end if
end sub




sub onShowBrowserM(url,index,tmpindex)
	tmpid = "id_"&index
	tmpname = "name_"&index
	id = window.showModalDialog(url)
	if NOT isempty(id) then
	        if id(0)<> "" then
			document.all(tmpname).innerHtml = mid(id(1),2,len(id(1)))
			document.all(tmpid).value=mid(id(0),2,len(id(0)))
			tmpindex.checked = true
            tmpid = tmpindex.id
            document.addopform.selectindex.value = Mid(tmpid,9,len(tmpid))
            document.addopform.selectvalue.value = tmpindex.value
		else
			document.all(tmpname).innerHtml = empty
			document.all(tmpid).value="0"
		end if
	end if
end sub
sub onShowBrowser4s(wfid,formid,isbill)
    
 
	src=document.all("fromsrc").value
	url = "BrowserMain.jsp?url=OperatorCondition.jsp?fromsrc="+src+"&formid="+formid+"&isbill="+isbill
	id = window.showModalDialog(url)
	if NOT isempty(id) then
	        if id(0)<> "" then
            'document.all("conditions").innerHTML="<img src=\"/images/BacoCheck_wev8.gif\" width=\"16\" height=\"16\" border=\"0\">"
			document.all("conditionss").value=id(0)
			document.all("conditions").innerHTML=id(1)
			document.all("conditioncn").value=id(1)
			document.all("fromsrc").value="2"
		    else
            document.all("conditions").innerHTML=""
			document.all("conditionss").value=""
			document.all("conditioncn").value=""
		   end if
	end if
    
end sub


</script>

<script type="text/javascript">
var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
function onShowBrowsers(wfid,formid,isbill){
	var src=$("#fromsrc").val();
	var url = "BrowserMain.jsp?url=OperatorCondition.jsp?fromsrc="+src+"&formid="+formid+"&isbill="+isbill;
	
	id = window.showModalDialog(url);
	if (id != null && id != undefined) {
	        if (wuiUtil.getJsonValueByIndex(id, 0)!="") {
				$("#conditionss").val(wuiUtil.getJsonValueByIndex(id, 0));
				$("#conditions").html(wuiUtil.getJsonValueByIndex(id, 1));
				$("#conditioncn").val(wuiUtil.getJsonValueByIndex(id, 1));
				$("#fromsrc").val("2");
			}else{
				$("#conditionss").val("");
				$("#conditions").html("");
				$("#conditioncn").val("");
			}
	}
}


function onShowBrowser4opM(url,index,tmpindex){
	tmpid = "id_"+index;
	tmpname = "name_"+index;
	datas = window.showModalDialog(url + "?resourceids=," + $G(tmpid).value, "","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas){
        if (datas.id!= ""){
			$("#"+tmpname).html(datas.name.substr(1));
			
			$("input[name="+tmpid+"]").val(datas.id.substr(1));
			tmpindex.checked = true
	        tmpid = $(tmpindex).attr("id");
	        document.addopform.selectindex.value = tmpid.substr(8);
	        document.addopform.selectvalue.value = tmpindex.value;
		}else{
			$("#"+tmpname).html("");
			$("input[name="+tmpid+"]").val("");
		}
	}
}

function onShowBrowser4opLevel(url,index,tmpindex){
	tmpid = "level_"+index;
	tmpname = "templevel_"+index;
	datas = window.showModalDialog(url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas){
	    if (datas.id!= ""){
			$("#"+tmpname).html(datas.name);
			$("input[name="+tmpid+"]").val(datas.id);
			tmpindex.checked = true
	        tmpid = $(tmpindex).attr("id");
	        document.addopform.selectindex.value = index;
	        document.addopform.selectvalue.value = tmpindex.value;
		}else{
			$("#"+tmpname).html("");
			$("input[name="+tmpid+"]").val("");
		}
	}
}

function onShowBrowser4op(url,index,tmpindex){
	tmpid = "id_"+index;
	tmpname = "name_"+index;
	url=url+"?selectedids=" + $G(tmpid).value;
	datas = window.showModalDialog(url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;");
	if (datas){
        if (datas.id!= ""){
			$("#"+tmpname).html(datas.name.substr(0));
			$("input[name="+tmpid+"]").val(datas.id.substr(0));
			tmpindex.checked = true;
	        tmpid = $(tmpindex).attr("id");
	        document.addopform.selectindex.value = tmpid.substr(8);
	        document.addopform.selectvalue.value = tmpindex.value;
		}else{
			$("#"+tmpname).html("");
			$("input[name="+tmpid+"]").val("");
		}
	}
}
</script>
<script language="JavaScript" src="/js/addRowBg_wev8.js" >
</script>
<script language=javascript>
function changelevel(tmpindex) {
	tmpindex.checked = true;
	tmpid = tmpindex.id;
	//document.addopform.selectindex.value = Mid(tmpid, 9, len(tmpid));
	document.addopform.selectindex.value = tmpid.substring(8);// Mid(tmpid, 9, len(tmpid));
	document.addopform.selectvalue.value = tmpindex.value;
	if($GetEle("tmptype_42").checked){
		$GetEle("Tab_Coadjutant").style.display='';
	}else {
		$GetEle("Tab_Coadjutant").style.display='none';
	}
    //alert("selindex:"+Mid(tmpid,9,len(tmpid)))+"   selectvalue:"+tmpindex.value;
}
function onShowCoadjutantBrowser() {
   
    url = encode("/workflow/workflow/showCoadjutantOperate.jsp?iscoadjutant=" + $GetEle("IsCoadjutant").value + "+signtype=" + $GetEle("signtype").value + "+issyscoadjutant=" + $GetEle("issyscoadjutant").value + "+coadjutants=" + $GetEle("coadjutants").value + "+coadjutantnames=" + $GetEle("coadjutantnames").value + "+issubmitdesc=" + $GetEle("issubmitdesc").value + "+ispending=" + $GetEle("ispending").value + "+isforward=" + $GetEle("isforward").value + "+ismodify=" + $GetEle("ismodify").value);
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url);
    if (data) {
        if (wuiUtil.getJsonValueByIndex(data, 0) != "") {
            
            $GetEle("IsCoadjutant").value = wuiUtil.getJsonValueByIndex(data, 0);
            $GetEle("signtype").value = wuiUtil.getJsonValueByIndex(data, 1);
            $GetEle("issyscoadjutant").value = wuiUtil.getJsonValueByIndex(data, 2);
            $GetEle("coadjutants").value = wuiUtil.getJsonValueByIndex(data, 3);
            $GetEle("coadjutantnames").value = wuiUtil.getJsonValueByIndex(data, 4);
            $GetEle("issubmitdesc").value = wuiUtil.getJsonValueByIndex(data, 5);
            $GetEle("ispending").value = wuiUtil.getJsonValueByIndex(data, 6);
            $GetEle("isforward").value = wuiUtil.getJsonValueByIndex(data, 7);
            $GetEle("ismodify").value = wuiUtil.getJsonValueByIndex(data, 8);
            $GetEle("Coadjutantconditions").value = wuiUtil.getJsonValueByIndex(data, 9);
            $GetEle("Coadjutantconditionspan").innerHTML = wuiUtil.getJsonValueByIndex(data,9);
        } else {
            $GetEle("IsCoadjutant").value = "";
            $GetEle("signtype").value = "";
            $GetEle("issyscoadjutant").value = "";
            $GetEle("coadjutants").value = "";
            $GetEle("coadjutantnames").value = "";
            $GetEle("issubmitdesc").value = "";
            $GetEle("ispending").value = "";
            $GetEle("isforward").value = "";
            $GetEle("ismodify").value = "";
            $GetEle("Coadjutantconditions").value = "";
            $GetEle("Coadjutantconditionspan").innerHTML = "";
        }
    }
}
var rowColor="" ;
rowindex = 0;
theselectradio = null ;

function onShowBrowser4opM1(url,index,tmpindex){
	var tempid = "id_"+index;
	var url1 = url+"?selectedids="+document.all(tempid).value;
	onShowBrowser4opM(url1,index,tmpindex);
	}

function setSelIndex(selindex, selectvalue) {
    //alert("selindex:"+selindex+"   selectvalue:"+selectvalue);
	document.addopform.selectindex.value = selindex ;
	document.addopform.selectvalue.value = selectvalue ;
	if($GetEle("tmptype_42").checked){
		$GetEle("Tab_Coadjutant").style.display='';
	}else {
		$GetEle("Tab_Coadjutant").style.display='none';
	}
}

//工作流图形化确定
function designOnClose() {
	window.parent.design_callback('addoperatorgroup');
}
function addRow4op(){
    var rowindex4op = 0;
    var rows=document.getElementsByName('check_node');
    var len = document.addopform.elements.length;
    var rowsum1 = 0;
    var obj;
    for(i=0; i < len;i++) {
		if (document.addopform.elements[i].name=='check_node'){
			rowsum1 += 1;
            obj=document.addopform.elements[i];
            }
    }

    if(rowsum1>0) {
    	rowindex4op=parseInt(obj.getAttribute("rowIndex"))+1;
    }

    for(i=0;i<56;i++){
    	var belongtype ="0";
        if(document.addopform.selectindex.value == i){
			switch (i) {
            case 0:
			case 1:
            case 2:
			case 7:
			case 8:
			case 9:
			case 11:
			case 12:
			case 14:
			case 15:
			case 16:
			case 18:
			case 19:
			case 27:
			case 28:
			case 29:
			case 30:
            case 38:
            case 45:
            case 46:
			case 50:
				
				//如果安全级别最大值不为空且最小值为空, 则最小值默认为0 。
				if($G("level_"+i).value ==''  &&  $G("level2_"+i).value != '')     $G("level_"+i).value = '0';
				if($GetEle("id_"+i).value ==0 || $GetEle("level_"+i).value =="" || ($GetEle("level_"+i).value =="0"&&i==50)){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 3:
			case 5:
			case 49:
			case 6:
			case 10:
			case 13:
			case 17:
			case 20:
			case 21:
			case 31:
			case 40:
			case 41:
			case 42:
			case 43:
			case 44:
			case 47:
			case 48:
			case 51:
			
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;

			case 52:
				
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 53:
				
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 54:
				
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 55:
				
				if($G("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 4:   //所有人
            case 24:  //创建人下属
			case 25:  //创建人本分部
			case 26:  //创建人本部门 
			case 39:  //创建人上级部门
			case 32:  //创建客户

				//如果安全级别最大值不为空且最小值为空, 则最小值默认为0 。
				if($G("level_"+i).value ==''  &&  $G("level2_"+i).value != '')    $G("level_"+i).value = '0';
				if($G("level_"+i).value ==''){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			}
            var hrmids,hrmnames; 
			var k=1;
			var subcompanyids,subcompanynames; 
			var belongtypeStr = "";
			var singerorder_flag = 0;
			try{
				singerorder_flag = parseInt(document.getElementById("singerorder_flag").value);
			}catch(e){
				singerorder_flag = 0;
			}
			var singerorder_type = document.getElementById("singerorder_type").value;
      if (i==0){//多分部
			var stmps = $G("id_"+i).value;
			var sHtmls = $G("name_"+i).innerHTML;
			if($G("signorder_"+i)) belongtype = $G("signorder_"+i).value;
			if(belongtype=="1"){
                subcompanyids=stmps.split(",");
                subcompanynames=sHtmls.split(",");
                k=subcompanyids.length;
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%>)";
			}else if(belongtype=="2"){
                if(singerorder_flag>0 && singerorder_type!="30"){
                    alert("<%=SystemEnv.getHtmlLabelName(24767,user.getLanguage())%>");
                    return;
                }
                subcompanyids=stmps.split(",");
                subcompanynames=sHtmls.split(",");
                k=subcompanyids.length;
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%>)";
                document.getElementById("singerorder_flag").value = ""+k;
                document.getElementById("singerorder_type").value = "30";
			}else{
                subcompanyids=stmps.split(",");
                subcompanynames=sHtmls.split(",");
                k=subcompanyids.length;
            }
			}
			var departmentids,departmentnames; 
      if (i==1){//多部门
			var stmps = $G("id_"+i).value;
			var sHtmls = $G("name_"+i).innerHTML;
			if($G("signorder_"+i)) belongtype = $G("signorder_"+i).value;
			if(belongtype=="1"){
                departmentids=stmps.split(",");
                departmentnames=sHtmls.split(",");
                k=departmentids.length;
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%>)";
			}else if(belongtype=="2"){
                if(singerorder_flag>0 && singerorder_type!="1"){
                    alert("<%=SystemEnv.getHtmlLabelName(24767,user.getLanguage())%>");
                    return;
                }
                departmentids=stmps.split(",");
                departmentnames=sHtmls.split(",");
                k=departmentids.length;
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%>)";
                document.getElementById("singerorder_flag").value = ""+k;
                document.getElementById("singerorder_type").value = "1";
			}else{
                departmentids=stmps.split(",");
                departmentnames=sHtmls.split(",");
                k=departmentids.length;
            }
			}
		if(i==2){//角色
			if($G("signorder_"+i)) belongtype = $G("signorder_"+i).value;
			if(belongtype=="1"){
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%>)";
			}else if(belongtype=="2"){
                if(singerorder_flag > 0){
                    alert("<%=SystemEnv.getHtmlLabelName(24767,user.getLanguage())%>");
                    return;
                }
				belongtypeStr = " (<%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%>)";
                document.getElementById("singerorder_flag").value = "1";
                document.getElementById("singerorder_type").value = "2";
			}
		}
            if (i==3)  //多人力资源
			{
			var stmps = $G("id_"+i).value;
			hrmids=stmps.split(",");
			var sHtmls = $G("name_"+i).innerHTML;
			hrmnames=sHtmls.split(",");
			k=hrmids.length;
			}
			for (m=0;m<k;m++)
			{ rowColor = getRowBg();
//			ncol = oTable4op.cols;
			ncol = oTable4op.rows[0].cells.length
			oRow = oTable4op.insertRow(-1);
			for(j=0; j<ncol; j++) {
				oCell = oRow.insertCell(-1);
				oCell.style.height=24;
				oCell.style.background= rowColor;
				switch(j) {
					case 0:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' name='check_node' value='0' rowindex="+rowindex4op+" belongtype="+belongtype+">";
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
					case 1:
						var oDiv = document.createElement("div");
						var sHtml="";

						if(i==0)
							sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>"+belongtypeStr;
						if(i== 1 )
							sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>"+belongtypeStr;
						if(i== 2 )
							sHtml="<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>"+belongtypeStr;
						if(i== 3 )
							sHtml="<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>";
						if(i== 4 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%>";
						if(i== 5 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15555,user.getLanguage())%>";
						if(i== 6 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15559,user.getLanguage())%>";
						if(i== 7 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15560,user.getLanguage())%>";
						if(i== 8 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15561,user.getLanguage())%>";
						if(i== 9 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15562,user.getLanguage())%>";
						if(i== 10 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15564,user.getLanguage())%>";
						if(i== 11 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15565,user.getLanguage())%>";
						if(i== 12 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15566,user.getLanguage())%>";
						if(i== 13 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15567,user.getLanguage())%>";
						if(i== 14 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15568,user.getLanguage())%>";
						if(i== 15 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15569,user.getLanguage())%>";
						if(i== 16 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15570,user.getLanguage())%>";
						if(i== 17 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15571,user.getLanguage())%>";
						if(i== 18 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15572,user.getLanguage())%>";
						if(i== 19 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15573,user.getLanguage())%>";
						if(i== 20 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15574,user.getLanguage())%>";
						if(i== 21 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15575,user.getLanguage())%>";
						if(i== 22 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%>";
						if(i== 23 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%>";
						if(i== 24 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15576,user.getLanguage())%>";
						if(i== 25 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15577,user.getLanguage())%>";
						if(i== 26 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%>";
						if(i== 27 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%>";
						if(i== 28 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%>";
						if(i== 29 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15579,user.getLanguage())%>";
						if(i== 30 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%>";
						if(i== 31 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15580,user.getLanguage())%>";
						if(i== 32 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15581,user.getLanguage())%>";
						if(i== 38 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15563,user.getLanguage())%>";
                        if(i== 39 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15578,user.getLanguage())%>";
                        if(i== 40 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18676,user.getLanguage())%>";
                        if(i== 41 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18677,user.getLanguage())%>";
                        if(i== 42 )
							sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>";
                        if(i== 43 )
							sHtml="<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>";
                        if(i== 44 )
							sHtml="<%=SystemEnv.getHtmlLabelName(17204,user.getLanguage())%>";
                        if(i== 45 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18678,user.getLanguage())%>";
                        if(i== 46 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18679,user.getLanguage())%>";
                        if(i== 47 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18680,user.getLanguage())%>";
                        if(i== 48 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18681,user.getLanguage())%>";
                        if(i== 49 )
							sHtml="<%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%>";
						if(i== 50 )
							sHtml="<%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%>";
						if(i== 51 )
							sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>";
						if(i== 52 )
							sHtml="<%=SystemEnv.getHtmlLabelName(27107,user.getLanguage())%>";
						if(i== 53 )
							sHtml="<%=SystemEnv.getHtmlLabelName(27108,user.getLanguage())%>";
						if(i== 54 )
							sHtml="<%=SystemEnv.getHtmlLabelName(27109,user.getLanguage())%>";
						if(i== 55 )
							sHtml="<%=SystemEnv.getHtmlLabelName(27110,user.getLanguage())%>";
                        oDiv.innerHTML = sHtml;

						jQuery(oCell).append(oDiv);

                        var rowtypevalue = document.addopform.selectvalue.value ;
						
						var oDiv1 = document.createElement("div");
						var sHtml1 = "<input type='hidden' name='group_"+rowindex4op+"_type'  value='"+rowtypevalue+"'>";
						oDiv1.innerHTML = sHtml1;
						jQuery(oCell).append(oDiv1);
						break;
				case 2:
					{
						var stmp="";
					if(i==0){
					  	stmp=""+subcompanyids[m];
					  }else if(i==1){
					  	stmp=""+departmentids[m];
					  }else{ 
						if (i==3)
					    {
						stmp=""+hrmids[m];
						}
					    else
					    {
						 stmp = $G("id_"+i).value;
					    }
            		}
						var oDiv = document.createElement("div");
						var sHtml = "";
						if((i>= 5 && i <= 21) || i == 27 || i == 31 || i == 30 || i==38  || i== 40 || i == 41|| i == 42|| i == 43|| i == 44|| i == 45|| i == 46|| i == 47|| i == 48|| i == 49|| i == 50|| i == 51|| i == 52 || i == 53 || i == 54 || i == 55){
							var srcList = $G("id_"+i);
							for (var count = srcList.options.length - 1; count >= 0; count--) {
								if(srcList.options[count].value==stmp)
									sHtml = srcList.options[count].text;
							}
						}
						else if(i== 4 || i== 22 || i== 23 || i==24 || i== 25 || i== 26  || i== 32 || i == 39){
							sHtml = stmp;
						}
						else
					      {
						    if(i==0){ sHtml=subcompanynames[m];}
						    else if(i==1){ sHtml=departmentnames[m];}
					    else{
							if (i==3)
							sHtml=hrmnames[m];
							else
							sHtml = $G("name_"+i).innerHTML;
							}
						  }
						  if (i==50)  sHtml =sHtml+"/"+$G("templevel_"+i).innerHTML;

						oDiv.innerHTML = sHtml;

						jQuery(oCell).append(oDiv);

						var oDiv2= document.createElement("div");
                       
						var stemp=stmp;
						
                        var sHtml1;
                        if(i==0 || i==1){
                        	sHtml1="<input type='hidden'  name='group_"+rowindex4op+"_subcompanyids' value='"+stemp+"'>";
                        	sHtml1 += "<input type='hidden'  name='group_"+rowindex4op+"_id' value='"+stemp+"'>";
                        }else{
							sHtml1="<input type='hidden'  name='group_"+rowindex4op+"_id' value='"+stemp+"'>";
                        }
						oDiv2.innerHTML = sHtml1;
						jQuery(oCell).append(oDiv2);
						break;
					}
					case 3:
						var oDiv = document.createElement("div");
						var sval = "";
						var sval2 = "";
						var sHtml="";
					
						if(i == 0 || i == 1 || i == 4 || i == 7 || i == 8 || i == 9 || i == 11 || i == 12 || i== 14 || i == 15 || i == 16 || i == 18 || i == 19 || i == 24 || i == 25 || i == 26 || i == 27 || i == 28 || i == 29 || i == 30 || i == 32 || i == 38 || i == 39 || i == 45 || i == 46){
                            sval = $G("level_"+i).value;
                            sval2 = $G("level2_"+i).value;
							
                            if(sval2!=""){
							    sHtml = sval+" - " + sval2;
                            }else{
                                sHtml = ">= "+sval;
                            }

						}
						
						if (i==42){
						   var tmpval = $GetEle("id_42_dept").value;
	                       if(tmpval=='0'){
                            sval = $G("level_"+i).value;
                            sval2 = $G("level2_"+i).value;
							
                            if(sval2!=""){
							    sHtml = sval+" - " + sval2;
                            }else{
                                sHtml = ">= "+sval;
                            }
	   
	                       }else{
	                          var obj=document.getElementById('id_42_dept'); 
                              var text=obj.options[obj.selectedIndex].text;//获取文本
                              sHtml=text;
	                       }
						}
						
						if (i==51){
						   var tmpval = $GetEle("id_51_sub").value;
	                       if(tmpval=='0'){
                            sval = $G("level_"+i).value;
                            sval2 = $G("level2_"+i).value;
							
                            if(sval2!=""){
							    sHtml = sval+" - " + sval2;
                            }else{
                                sHtml = ">= "+sval;
                            }
	   
	                       }else{
	                          var obj=document.getElementById('id_51_sub'); 
                              var text=obj.options[obj.selectedIndex].text;//获取文本
                              sHtml=text;
	                       }
						}

						if (i==50){

                            sval = $G("level_"+i).value;
							sval2 = $G("level2_"+i).value;
							if(sval2=="1"){
								sHtml = "<%=SystemEnv.getHtmlLabelName(22689,user.getLanguage())%>";
							}else if(sval2=="2"){
								sHtml = "<%=SystemEnv.getHtmlLabelName(22690,user.getLanguage())%>";
							}else if(sval2=="3"){
								sHtml = "<%=SystemEnv.getHtmlLabelName(22667,user.getLanguage())%>";
							}else{
								sHtml = "<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>";
							}
						}
						if(i == 2 ){
							sval = $G("level_"+i).value;
							if(sval==0)
								sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>";
							if(sval==1)
								sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>";
							if(sval==2)
								sHtml="<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>";
							if(sval==3)
								sHtml="<%=SystemEnv.getHtmlLabelName(22753,user.getLanguage())%>";
						}
					
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);

						var oDiv3= document.createElement("div");
                        var sHtml1 = "<input type='hidden' size='32' name='group_"+rowindex4op+"_level'  value='"+sval+"'>";
                        
                        if(sval2!=""){
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_level2'  value='"+sval2+"'>";
                        }else{
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_level2'  value='-1'>";
                        }
                        
                       if (i==42){
						   var tmpval = $GetEle("id_42_dept").value;
	                       if(tmpval!='0'){
	                          sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_deptField'  value='"+tmpval+"'>";
	                       }else{
	                          sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_deptField'  value=''>";
	                       }
	                   }
                        
                       if (i==51){
						   var tmpval = $GetEle("id_51_sub").value;
	                       if(tmpval!='0'){
	                          sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_subcompanyField'  value='"+tmpval+"'>";
	                       }else{
	                          sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex4op+"_subcompanyField'  value=''>";
	                       }
	                   }                        
                        
						
						oDiv3.innerHTML = sHtml1;
						jQuery(oCell).append(oDiv3);
						break;

					case 4:
						var oDiv = document.createElement("div");
						var sval = "";
						var sHtml="";
					
						if((document.getElementById("signordertr")&&document.getElementById("signordertr").style.display!="none"
							&&(i == 5||i == 6||i == 7||i == 8||i == 9||i == 38||i == 42||i == 52||i == 53||i == 54||i == 55||i == 51||i == 43
							||i == 49||i == 50||i == 22||i == 23||i == 24||i == 25||i == 26||i == 39||i == 40||i == 41 || i==48))
							||i == 31||((i == 2||i == 3)&&document.all("signorder_"+i))){
							if(i==31||i==2||i==3)
							{
								sval = document.all("signorder_"+i);
							}
							else
							{
								sval = document.all("signorder");
							}
							if(sval)
							{
								if(sval[0]&&sval[0].checked){
	                                sHtml="<%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>";
									sval = "0";
	                            }else if(sval[1]&&sval[1].checked){
									sHtml="<%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>";
									sval = "1";
								}else if(sval[2]&&sval[2].checked){
									sHtml="<%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>";
									sval = "2";
								}else if(sval[3]&&sval[3].checked){
									sHtml="<%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>";
									sval = "3";
								}else if(sval[4]&&sval[4].checked){
									sHtml="<%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>";
									sval = "4";
								}
							}
						}
						if(i==0 || i==1 || i==2){
							sval = $G("signorder_"+i).value;
						}
                        sHtml += "<input type='hidden' size='32' name='group_"+rowindex4op+"_signorder'  value='"+sval+"'>";
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
					case 5:
						var oDiv = document.createElement("div");
						var sval = $G("conditionss").value;
						var sval1 = $G("conditioncn").value;
                        var sval2 = $G("Coadjutantconditions").value;
						/*var temp = document.all("signorder_5");
						if(document.all("tmptype_5").checked&&(temp[3].checked||temp[4].checked)){
							sval="";
							sval1="";
						}*/
                        if(!$G("tmptype_42").checked){
                            sval2="";
                        }
						while (sval.indexOf("'")>0)
						{
							sval=sval.replace("'","’");
						}
						while (sval1.indexOf("'")>0)
						{
							sval1=sval1.replace("'","’");
						}
						if($G("Tab_Coadjutant") && $G("Tab_Coadjutant").style.display=="none"){
							sval2="";
							$G("IsCoadjutant").value="";
							$G("issyscoadjutant").value="";
							$G("signtype").value="";
							$G("coadjutants").value="";
							$G("issubmitdesc").value="";
							$G("ispending").value="";
							$G("isforward").value="";
							$G("ismodify").value="";
						}
						var hashead=0;
						var sHtml="<input type='hidden' name='group_"+rowindex4op+"_condition' value='"+sval+"'>";
						sHtml+="<input type='hidden' name='group_"+rowindex4op+"_conditioncn' value='"+sval1+"'>";
						sHtml+="<input type='hidden' name='group_"+rowindex4op+"_Coadjutantconditions' value='"+sval2+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_IsCoadjutant' value='"+$G("IsCoadjutant").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_signtype' value='"+$G("signtype").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_issyscoadjutant' value='"+$G("issyscoadjutant").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_coadjutants' value='"+$G("coadjutants").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_issubmitdesc' value='"+$G("issubmitdesc").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_ispending' value='"+$G("ispending").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_isforward' value='"+$G("isforward").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex4op+"_ismodify' value='"+$G("ismodify").value+"'>";
                        if(sval1!=""){
						    sHtml+="<%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())+SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>:"+sval1;
                            hashead=1;
                        }
                        if(sval2!=""){
                            if(hashead==1) sHtml+="<br>";
                            sHtml+="<%=SystemEnv.getHtmlLabelName(22675,user.getLanguage())%>:"+sval2;
                        }
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
						case 6:
							var sval = "";
							if(($G("signordertr")&&$G("signordertr").style.display!="none"
								&&(i == 5||i == 6||i == 7||i == 8||i == 9||i == 38||i == 42||i == 52||i == 53||i == 54||i == 55||i == 51||i == 43
								||i == 49||i == 50||i == 22||i == 23||i == 24||i == 25||i == 26||i == 39||i == 40||i == 41))
								||i == 31||((i == 2||i == 3)&&$G("signorder_"+i))){
								if(i==31||i==2||i==3)
								{
									sval = document.all("signorder_"+i);
								}
								else
								{
									sval = document.all("signorder");
								}
								if(sval)
								{
									
									if(sval[0]&&sval[0].checked){ 
										sval = "0";
		                            }else if(sval[1]&&sval[1].checked){ 
										sval = "1";
									}else if(sval[2]&&sval[2].checked){ 
										sval = "2";
									}else if(sval[3]&&sval[3].checked){ 
										sval = "3";
									}else if(sval[4]&&sval[4].checked){ 
										sval = "4";
									} 
								}
							} 
							
						var oDiv = document.createElement("div");

						//var sval1 = document.getElementById("orders").value;
						var sval1 = $G("orders").value;

						var temp = document.all("signorder");
						var f_check = true;
						if(temp)
						{
							if(document.getElementById("signordertr")&&document.getElementById("signordertr").style.display!="none"&&(temp[3].checked||temp[4].checked)){
								sval1="";
								f_check = false;
							}
						}
						if (sval1==null || sval1 == ''){
							sval1=0;
						}
						//alert(sval1);
						var sHtml="<input type='hidden' name='group_"+rowindex4op+"_orderold' value='"+sval1+"'>";
						var nodetype_operatorgroup = $GetEle("nodetype_operatorgroup").value;
						//如果是会签抄送不显示批次
						if(sval=='3'||sval=='4'){
							sHtml += '';
						} 
						else{
							if(nodetype_operatorgroup == 1 || nodetype_operatorgroup == 2 || nodetype_operatorgroup == 3){
								sHtml+="<input type='text' class='Inputstyle' name='group_"+rowindex4op+"_order' value='"+sval1+"' onchange=\"check_number('group_"+rowindex4op+"_order');checkDigit(this,5,2)\"  maxlength=\"5\" style=\"width:80%\">";
							}else{
								sHtml += sval1;
							}
						}
						if(f_check == false){
							sHtml = "";
						}
						oDiv.innerHTML = sHtml;
						jQuery(oCell).append(oDiv);
						break;
				}
			}
			rowindex4op = rowindex4op*1 +1;
			}
			$G("fromsrc").value="1";
			$G("conditionss").value="";
			$G("conditioncn").value="";
			$G("conditions").innerHTML="";
			$G("IsCoadjutant").value="";
			$G("signtype").value="";
			$G("issyscoadjutant").value="";
			$G("coadjutants").value="";
			$G("issubmitdesc").value="";
			$G("ispending").value="";
			$G("isforward").value="";
			$G("ismodify").value="";
            $G("Coadjutantconditions").value="";
			$G("Coadjutantconditionspan").innerHTML="";
			//for(itmp = 0;itmp < 32;itmp++)
				//document.form1.tmptype(itmp).checked = false;
			return;
		}
	}
	alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
}

function addRow()
{		
	for(i=0;i<51;i++){
		if(document.addopform.selectindex.value == i){
			switch (i) {
            case 0:
			case 1:
			case 2:
			case 7:
			case 8:
			case 9:
			case 11:
			case 12:
			case 14:
			case 15:
			case 16:
			case 18:
			case 19:
			case 27:
			case 28:
			case 29:
			case 30:
            case 38:
            case 45:
            case 46:
			case 50:
				if($GetEle("id_"+i).value ==0 || $GetEle("level_"+i).value =="" || ($GetEle("level_"+i).value =="0"&&i==50)){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			case 3:
			case 5:
			case 49:
			case 6:
			case 10:
			case 13:
			case 17:
			case 20:
			case 21:
			case 31:
			case 40:
			case 41:
			case 42:
			case 43:
			case 44:
			case 47:
			case 48:
			
				if(document.all("id_"+i).value ==0){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;

			case 4:
            case 24:
			case 25:
			case 26:
			case 32:

				if(document.all("level_"+i).value ==''){
					alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");
					return;
				}
				break;
			}
			var subcompanyids,subcompanynames; 
      if (i==0){//多分部
				var stmps = document.all("id_"+i).value;
				subcompanyids=stmps.split(",");
				var sHtmls = document.all("name_"+i).innerHTML;
				subcompanynames=sHtmls.split(",");
				k=subcompanyids.length;
			}
			var departmentids,departmentnames; 
      if (i==1){//多部门
				var stmps = document.all("id_"+i).value;
				departmentids=stmps.split(",");
				var sHtmls = document.all("name_"+i).innerHTML;
				departmentnames=sHtmls.split(",");
				k=departmentids.length;
			}
            var hrmids,hrmnames; 
			var k=1;
            if (i==3)  //多人力资源
			{
			var stmps = document.all("id_"+i).value;
			hrmids=stmps.split(",");
			var sHtmls = document.all("name_"+i).innerHTML;
			hrmnames=sHtmls.split(",");
			k=hrmids.length;
			}
			for (m=0;m<k;m++)
			{
			rowColor = getRowBg();
			ncol = oTable.cols;
			oRow = oTable.insertRow();
			for(j=0; j<ncol; j++) {
				oCell = oRow.insertCell();
				oCell.style.height=24;
				oCell.style.background= rowColor;

				switch(j) {
					case 0:
						var oDiv = document.createElement("div");
						var sHtml = "<input type='checkbox' name='check_node' value='0'>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
					case 1:
						var oDiv = document.createElement("div");
						var sHtml="";

						if(i==0)
							sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>";
						if(i== 1 )
							sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>";
						if(i== 2 )
							sHtml="<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>";
						if(i== 3 )
							sHtml="<%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>";
						if(i== 4 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%>";
						if(i== 5 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15555,user.getLanguage())%>";
						if(i== 6 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15559,user.getLanguage())%>";
						if(i== 7 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15560,user.getLanguage())%>";
						if(i== 8 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15561,user.getLanguage())%>";
						if(i== 9 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15562,user.getLanguage())%>";
						if(i== 10 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15564,user.getLanguage())%>";
						if(i== 11 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15565,user.getLanguage())%>";
						if(i== 12 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15566,user.getLanguage())%>";
						if(i== 13 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15567,user.getLanguage())%>";
						if(i== 14 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15568,user.getLanguage())%>";
						if(i== 15 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15569,user.getLanguage())%>";
						if(i== 16 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15570,user.getLanguage())%>";
						if(i== 17 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15571,user.getLanguage())%>";
						if(i== 18 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15572,user.getLanguage())%>";
						if(i== 19 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15573,user.getLanguage())%>";
						if(i== 20 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15574,user.getLanguage())%>";
						if(i== 21 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15575,user.getLanguage())%>";
						if(i== 22 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%>";
						if(i== 23 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())%>";
						if(i== 24 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15576,user.getLanguage())%>";
						if(i== 25 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15577,user.getLanguage())%>";
						if(i== 26 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())%>";
						if(i== 27 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%>";
						if(i== 28 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%>";
						if(i== 29 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15579,user.getLanguage())%>";
						if(i== 30 )
							sHtml="<%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%>";
						if(i== 31 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15580,user.getLanguage())%>";
						if(i== 32 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15581,user.getLanguage())%>";
						if(i== 38 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15563,user.getLanguage())%>";
                        if(i== 39 )
							sHtml="<%=SystemEnv.getHtmlLabelName(15578,user.getLanguage())%>";
                        if(i== 40 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18676,user.getLanguage())%>";
                        if(i== 41 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18677,user.getLanguage())%>";
                        if(i== 42 )
							sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>";
                        if(i== 43 )
							sHtml="<%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>";
                        if(i== 44 )
							sHtml="<%=SystemEnv.getHtmlLabelName(17204,user.getLanguage())%>";
                        if(i== 45 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18678,user.getLanguage())%>";
                        if(i== 46 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18679,user.getLanguage())%>";
                        if(i== 47 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18680,user.getLanguage())%>";
                        if(i== 48 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18681,user.getLanguage())%>";
                        if(i== 49 )
							sHtml="<%=SystemEnv.getHtmlLabelName(18681,user.getLanguage())%>";
						if(i== 50 )
							sHtml="<%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%>";
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);

                        var rowtypevalue = document.addopform.selectvalue.value ;
						var oDiv1 = document.createElement("div");
						var sHtml1 = "<input type='hidden' name='group_"+rowindex+"_type'  value='"+rowtypevalue+"'>";
						oDiv1.innerHTML = sHtml1;
						oCell.appendChild(oDiv1);
						break;
					case 2:

							var stmp="";
					  if(i==0){
					  	stmp=""+subcompanyids[m];
					  }else if(i==1){
					  	stmp=""+departmentids[m];
					  }else{ 
						if (i==3)
					    {
						stmp=""+hrmids[m];
						}
					    else
					    {
						 stmp = document.all("id_"+i).value;
					    }
            }           
						var oDiv = document.createElement("div");
						var sHtml = "";
						if(i>= 5 && i <= 21 || i == 27 || i == 31 || i == 30 || i==38  || i== 40 || i == 41|| i == 42|| i == 43|| i == 44|| i == 45|| i == 46|| i == 47|| i == 48|| i == 49|| i == 50){
							var srcList = document.all("id_"+i);
							for (var count = srcList.options.length - 1; count >= 0; count--) {
								if(srcList.options[count].value==stmp)
									sHtml = srcList.options[count].text;
							}
						}
						else if(i== 4 || i== 22 || i== 23 || i==24 || i== 25 || i== 26  || i== 32 || i == 39){
							sHtml = stmp;
						}
						else
					      {
					    if(i==0){ sHtml=subcompanynames[m];}
					    else if(i==1){ sHtml=departmentnames[m];}
					    else{
							if (i==3)
							sHtml=hrmnames[m];
							else
							sHtml = document.all("name_"+i).innerHTML;
							}
						  }
						  if (i==50)  sHtml =sHtml+"/"+document.all("templevel_"+i).innerHTML;

						oDiv.innerHTML = sHtml;

						oCell.appendChild(oDiv);

						var oDiv2= document.createElement("div");
                       
						var stemp=stmp;
						
						var sHtml1 = "<input type='hidden'  name='group_"+rowindex+"_id' value='"+stemp+"'>";
						oDiv2.innerHTML = sHtml1;
						oCell.appendChild(oDiv2);
						break;
					case 3:
						var oDiv = document.createElement("div");
						var sval = "";
						var sval2 = "";
						var sHtml="";
					
						if(i == 0 || i == 1 || i == 4 || i == 7 || i == 8 || i == 9 || i == 11 || i == 12 || i== 14 || i == 15 || i == 16 || i == 18 || i == 19 || i == 24 || i == 25 || i == 26 || i == 27 || i == 28 || i == 29 || i == 30 || i == 32 || i == 38 || i == 39 || i == 45 || i == 46||i == 42){
                            sval = document.all("level_"+i).value;
                            sval2 = document.all("level2_"+i).value;
							
                            if(sval2!=""){
							    sHtml = sval+" - " + sval2;
                            }else{
                                sHtml = ">= "+sval;
                            }

						}
						if (i==50)
							{
                            sval = document.all("level_"+i).value;
							
							}
						if(i == 2 ){
							sval = document.all("level_"+i).value;
							if(sval==0)
								sHtml="<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>";
							if(sval==1)
								sHtml="<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>";
							if(sval==2)
								sHtml="<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>";
						}
					
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);

						var oDiv3= document.createElement("div");
                        var sHtml1 = "<input type='hidden' size='32' name='group_"+rowindex+"_level'  value='"+sval+"'>";
                        if(sval2!=""){
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex+"_level2'  value='"+sval2+"'>";
                        }else{
                            sHtml1 += "<input type='hidden' size='32' name='group_"+rowindex+"_level2'  value='-1'>";
                        }
						
						oDiv3.innerHTML = sHtml1;
						oCell.appendChild(oDiv3);
						break;
						case 4:

						var oDiv = document.createElement("div");
						var sval = "";
						var sHtml="";
						if(i == 5|| i == 42|| i == 43|| i == 49||i == 50||i == 40||i == 41||i == 31 ){

							sval = document.all("signorder_"+i);

							if(sval[0].checked){
                                sHtml="<%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>";
								sval = "0";
                            }
                            else if(sval[1].checked){
								sHtml="<%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>";
								sval = "1";
							}else if(sval[2].checked){
								sHtml="<%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>";
								sval = "2";
							}else if(sval[3].checked){
								sHtml="<%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>";
								sval = "3";
							}else if(sval[4].checked){
								sHtml="<%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>";
								sval = "4";
							}
						}
                        sHtml += "<input type='hidden' size='32' name='group_"+rowindex+"_signorder'  value='"+sval+"'>";

						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
						case 5:
						var oDiv = document.createElement("div");
						var sval = $G("conditionss").value;
						var sval1 = $G("conditioncn").value;
						var sval2 = $G("Coadjutantconditions").value;
						if(!$G("tmptype_42").checked){
                            sval2="";
                        }
						while (sval.indexOf("'")>0)
						{
						sval=sval.replace("'","’");
						}
						while (sval1.indexOf("'")>0)
						{
						sval1=sval1.replace("'","’");
						}
						var hashead=0;
						var sHtml="<input type='hidden' name='group_"+rowindex+"_condition' value='"+sval+"'>";
						sHtml+="<input type='hidden' name='group_"+rowindex+"_conditioncn' value='"+sval1+"'>";
						sHtml+="<input type='hidden' name='group_"+rowindex+"_Coadjutantconditions' value='"+sval2+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex+"_IsCoadjutant' value='"+$G("IsCoadjutant").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex+"_signtype' value='"+$G("signtype").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex+"_issyscoadjutant' value='"+$G("issyscoadjutant").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex+"_coadjutants' value='"+$G("coadjutants").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex+"_issubmitdesc' value='"+$G("issubmitdesc").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex+"_ispending' value='"+$G("ispending").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex+"_isforward' value='"+$G("isforward").value+"'>";
                        sHtml+="<input type='hidden' name='group_"+rowindex+"_ismodify' value='"+$G("ismodify").value+"'>";
						if(sval1!=""){
						    sHtml+="<%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())+SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>:"+sval1;
                            hashead=1;
                        }
                        if(sval2!=""){
                            if(hashead==1) sHtml+="<br>";
                            sHtml+="<%=SystemEnv.getHtmlLabelName(22675,user.getLanguage())%>:"+sval2;
                        }
						oDiv.innerHTML = sHtml;
						oCell.appendChild(oDiv);
						break;
						case 6:
						var oDiv = document.createElement("div");
						
						var sval1 = document.all("orders").value;
						if (sval1==null || sval1 == ''){
							sval1=0;
						}
						
						var sHtml="<input type='hidden' name='group_"+rowindex+"_orderold' value='"+sval1+"'>";
						<%if (!nodetype.equals("0")&&!nodetype.equals("3")){%>
							sHtml1+="<input type='text' class='Inputstyle' name='group_"+rowindex+"_order' value='"+sval1+"' onchange=\"check_number('group_"+rowindex+"_order');checkDigit(this,5,2)\"  maxlength=\"5\" style=\"width:80%\">";
						<%}else{%>
							sHtml1+=sval1;
						<%}%>
						oDiv.innerHTML = sHtml1;
						oCell.appendChild(oDiv);
						break;
				}
			}
			rowindex = rowindex*1 +1;
			}
			document.all("fromsrc").value="1";
			document.all("conditionss").value="";
			document.all("conditioncn").value="";
			document.all("conditions").innerHTML="";
			
			return;
		}
	}
	alert("<%=SystemEnv.getHtmlLabelName(15584,user.getLanguage())%>!");

}


function deleteRow()
{
	len = document.forms[0].elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				oTable.deleteRow(rowsum1+1);
			}
			rowsum1 -=1;
		}

	}
}
function deleteRow4op()
{
	len = document.addopform.elements.length;
	var i=0;
	var rowsum1 = 0;
	for(i=len-1; i >= 0;i--) {
		if (document.addopform.elements[i].name=='check_node')
			rowsum1 += 1;
	}
	for(i=len-1; i >= 0;i--) {
		if (document.addopform.elements[i].name=='check_node'){
			if(document.addopform.elements[i].checked==true) {
				oTable4op.deleteRow(rowsum1+1);
			}
			rowsum1 -=1;
		}

	}
}

function selectall(){    
    if(check_form(window.document.forms[0],'groupname,wfids')){
		document.forms[0].groupnum.value=rowindex;
		window.document.forms[0].submit();
	}
}
function nodeopaddsave(obj){
	
    var sss=document.addopform.groupname.value;
    if(sss.length>60){
    alert("<%=SystemEnv.getHtmlLabelName(18686,user.getLanguage())%>");
    }else{
    
	    if (check_form(addopform, 'groupname')) {
	        var rowindex4op = 0;
	        var len = document.addopform.elements.length;
	        var rowsum1 = 0;
	        var obj;
	        for (i = 0; i < len; i++) {
	            if (document.addopform.elements[i].name == 'check_node') {
	                rowsum1 += 1;
	                obj = document.addopform.elements[i];
	            }
	        }
	
	        if (rowsum1 > 0) {
	            rowindex4op = parseInt(obj.rowindex) + 1;
	        }
	
	        addopform.groupnum.value = rowindex4op;
	        obj.disabled = true;
	        addopform.submit();
	    }
   }
}

function checkDigit(elementName,p,s){
	tmpvalue = elementName.value;

    var len = -1;
    if(elementName){
		len = tmpvalue.length;
    }

	var integerCount=0;
	var afterDotCount=0;
	var hasDot=false;

    var newIntValue="";
	var newDecValue="";
    for(i = 0; i < len; i++){
		if(tmpvalue.charAt(i) == "."){ 
			hasDot=true;
		}else{
			if(hasDot==false){
				integerCount++;
				if(integerCount<=p-s){
					newIntValue+=tmpvalue.charAt(i);
				}
			}else{
				afterDotCount++;
				if(afterDotCount<=s){
					newDecValue+=tmpvalue.charAt(i);
				}
			}
		}		
    }

    var newValue="";
	if(newDecValue==""){
		newValue=newIntValue;
	}else{
		newValue=newIntValue+"."+newDecValue;
	}
    elementName.value=newValue;
}
function encode(str){
    return escape(str);
}

function setSelIndex(selindex, selectvalue) {
    document.addopform.selectindex.value = selindex ;
    document.addopform.selectvalue.value = selectvalue ;
    if($GetEle("tmptype_42").checked){
    $GetEle("Tab_Coadjutant").style.display='';
    }else {
    $GetEle("Tab_Coadjutant").style.display='none';
    }
}

function onShowWorkflow(inputename,showname){
    tmpids = $G(inputename).value;
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowMutiBrowser.jsp?tmpwfright=1&wfids="+tmpids);
	if (id1){
        if (id1.id!="" && id1.id != 0) {
          resourceids = id1.id;
          resourcename = id1.name;
          sHtml = ""
         
          resourceids =resourceids.substr(1);
          $G(inputename).value= resourceids;
          resourcename =resourcename.substr(1);
          
          resourceids=resourceids.split(",");
          resourcename=resourcename.split(",");
          for(var i=0;i<resourceids.length;i++){
              sHtml = sHtml+resourcename[i]+"&nbsp;";
          }
          $G(showname).innerHTML = sHtml;
        }else{
		  $G(showname).innerHTML ="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
          $G(inputename).value="";
       }
    }
}
</script>
<%} %>
</body>