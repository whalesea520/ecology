
<%@ page language="java" contentType="application/vnd.ms-excel; charset=GBK" %>
<%@ page import="weaver.systeminfo.*,java.util.*,weaver.hrm.*" %>
<%@ page import="weaver.general.Util,weaver.hrm.common.*" %>
<!-- added by wcd 2014-07-30 [E7 to E8] -->
<jsp:useBean id="HrmAgeRpManager" class="weaver.hrm.report.manager.HrmAgeRpManager" scope="page"/>
<jsp:useBean id="HrmJobLevelRpManager" class="weaver.hrm.report.manager.HrmJobLevelRpManager" scope="page"/>
<jsp:useBean id="HrmSexRpManager" class="weaver.hrm.report.manager.HrmSexRpManager" scope="page"/>
<jsp:useBean id="HrmWorkageRpManager" class="weaver.hrm.report.manager.HrmWorkageRpManager" scope="page"/>
<jsp:useBean id="HrmEducationLevelRpManager" class="weaver.hrm.report.manager.HrmEducationLevelRpManager" scope="page"/>
<jsp:useBean id="HrmJobCallRpManager" class="weaver.hrm.report.manager.HrmJobCallRpManager" scope="page"/>
<jsp:useBean id="HrmStatusRpManager" class="weaver.hrm.report.manager.HrmStatusRpManager" scope="page"/>
<jsp:useBean id="HrmUsekindRpManager" class="weaver.hrm.report.manager.HrmUsekindRpManager" scope="page"/>
<jsp:useBean id="HrmMarriedRpManager" class="weaver.hrm.report.manager.HrmMarriedRpManager" scope="page"/>
<jsp:useBean id="HrmSecLevelRpManager" class="weaver.hrm.report.manager.HrmSecLevelRpManager" scope="page"/>
<jsp:useBean id="HrmDepartmentRpManager" class="weaver.hrm.report.manager.HrmDepartmentRpManager" scope="page"/>
<jsp:useBean id="HrmJobTitleRpManager" class="weaver.hrm.report.manager.HrmJobTitleRpManager" scope="page"/>
<jsp:useBean id="HrmJobActivityRpManager" class="weaver.hrm.report.manager.HrmJobActivityRpManager" scope="page"/>
<jsp:useBean id="HrmJobGroupRpManager" class="weaver.hrm.report.manager.HrmJobGroupRpManager" scope="page"/>
<style>
<!--
td{font-size:12px}
.title{font-weight:bold;font-size:20px}
-->
</style>
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
	
	String cmd = Util.null2String(request.getParameter("cmd"));
	int tnum = Util.getIntValue(request.getParameter("tnum"),0);	
	String fromdate=Tools.vString(request.getParameter("fromdate"));
	String enddate=Tools.vString(request.getParameter("enddate"));
	String department=Util.fromScreen(request.getParameter("department"),user.getLanguage());
	String location=Util.fromScreen(request.getParameter("location"),user.getLanguage());
	String status=Util.fromScreen(request.getParameter("status"),user.getLanguage());
	String area=Util.fromScreen(request.getParameter("area"),user.getLanguage());
	
	String fileName = (Tools.isNotNull(fromdate)&&Tools.isNotNull(enddate)?fromdate+" "+SystemEnv.getHtmlLabelName(15322,user.getLanguage())+" "+enddate+" ":"") + SystemEnv.getHtmlLabelName(tnum,user.getLanguage());
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-disposition","attachment;filename="+new String(fileName.getBytes("GBK"),"iso8859-1")+".xls");
	
	List list = null;
	int listSize = 0;
	Map map = null;
	
	if(cmd.equals("hrmAgeRp")){
%>
  <table width="100%" class="ListStyle" border="1">
	<tr class="Header">
		<th width="30%"><%=SystemEnv.getHtmlLabelName(671, user.getLanguage())%></th>
		<th width="30%"><%=SystemEnv.getHtmlLabelName(1859, user.getLanguage())%></th>
		<th width="40%"><%=SystemEnv.getHtmlLabelName(31143, user.getLanguage())%></th>
	</tr>
	<%
		Map paramMap = new HashMap();
		paramMap.put("fromdate",fromdate);
		paramMap.put("enddate",enddate);
		paramMap.put("department",department);
		paramMap.put("location",location);
		paramMap.put("status",status);
		paramMap.put("area",area);
		list = HrmAgeRpManager.getResult(user,paramMap,request,response);
		if(list != null){
			listSize = list.size();
		}
		for(int i=0; i<listSize; i++){
			map = (Map)list.get(i);
	%>
	<tr align="left">
		<td><%=Tools.vString(map.get("title"))%></td>
		<td><%=Tools.vString(map.get("result"))%></td>
		<td><%=Tools.vString(map.get("percent"))+"%"%></td>
	</tr>
	<%	}%>
  </table>
<%
	}else if(cmd.equals("HrmJobLevelRp")){
%>
  <table width="100%" class="ListStyle" border="1">
	<tr class="Header">
		<th width="30%"><%=SystemEnv.getHtmlLabelName(1909, user.getLanguage())%></th>
		<th width="30%"><%=SystemEnv.getHtmlLabelName(1859, user.getLanguage())%></th>
		<th width="40%"><%=SystemEnv.getHtmlLabelName(31143, user.getLanguage())%></th>
	</tr>
	<%
		Map paramMap = new HashMap();
		paramMap.put("fromdate",fromdate);
		paramMap.put("enddate",enddate);
		paramMap.put("department",department);
		paramMap.put("location",location);
		paramMap.put("status",status);
		paramMap.put("area",area);
		list = HrmJobLevelRpManager.getResult(user,paramMap,request,response);
		if(list != null){
			listSize = list.size();
		}
		for(int i=0; i<listSize; i++){
			map = (Map)list.get(i);
	%>
	<tr align="left">
		<td>&nbsp;<%=Tools.vString(map.get("title"))%></td>
		<td>&nbsp;<%=Tools.vString(map.get("result"))%></td>
		<td>&nbsp;<%=Tools.vString(map.get("percent"))+"%"%></td>
	</tr>
	<%	}%>
  </table>
<%
	}else if(cmd.equals("hrmSexRp")){
%>
  <table width="100%" class="ListStyle" border="1">
	<tr class="Header">
		<th width="30%"><%=SystemEnv.getHtmlLabelName(416, user.getLanguage())%></th>
		<th width="30%"><%=SystemEnv.getHtmlLabelName(1859, user.getLanguage())%></th>
		<th width="40%"><%=SystemEnv.getHtmlLabelName(31143, user.getLanguage())%></th>
	</tr>
	<%
		Map paramMap = new HashMap();
		paramMap.put("fromdate",fromdate);
		paramMap.put("enddate",enddate);
		paramMap.put("department",department);
		paramMap.put("location",location);
		paramMap.put("status",status);
		list = HrmSexRpManager.getResult(user,paramMap,request,response);
		if(list != null){
			listSize = list.size();
		}
		for(int i=0; i<listSize; i++){
			map = (Map)list.get(i);
	%>
	<tr align="left">
		<td><%=Tools.vString(map.get("title"))%></td>
		<td><%=Tools.vString(map.get("result"))%></td>
		<td><%=Tools.vString(map.get("percent"))+"%"%></td>
	</tr>
	<%	}%>
  </table>
<%
	}else if(cmd.equals("hrmWorkageRp")){
%>
  <table width="100%" class="ListStyle" border="1">
	<tr class="Header">
		<th width="30%"><%=SystemEnv.getHtmlLabelName(15878, user.getLanguage())%></th>
		<th width="30%"><%=SystemEnv.getHtmlLabelName(1859, user.getLanguage())%></th>
		<th width="40%"><%=SystemEnv.getHtmlLabelName(31143, user.getLanguage())%></th>
	</tr>
	<%
		Map paramMap = new HashMap();
		paramMap.put("department",department);
		paramMap.put("location",location);
		paramMap.put("status",status);
		paramMap.put("area",area);
		list = HrmWorkageRpManager.getResult(user,paramMap,request,response);
		if(list != null){
			listSize = list.size();
		}
		for(int i=0; i<listSize; i++){
			map = (Map)list.get(i);
	%>
	<tr align="left">
		<td><%=Tools.vString(map.get("title"))%></td>
		<td><%=Tools.vString(map.get("result"))%></td>
		<td><%=Tools.vString(map.get("percent"))+"%"%></td>
	</tr>
	<%	}%>
  </table>
<%
	}else if(cmd.equals("hrmEducationLevelRp")){
%>
  <table width="100%" class="ListStyle" border="1">
	<tr class="Header">
		<th width="30%"><%=SystemEnv.getHtmlLabelName(818, user.getLanguage())%></th>
		<th width="30%"><%=SystemEnv.getHtmlLabelName(1859, user.getLanguage())%></th>
		<th width="40%"><%=SystemEnv.getHtmlLabelName(31143, user.getLanguage())%></th>
	</tr>
	<%
		Map paramMap = new HashMap();
		paramMap.put("fromdate",fromdate);
		paramMap.put("enddate",enddate);
		paramMap.put("department",department);
		paramMap.put("location",location);
		paramMap.put("status",status);
		list = HrmEducationLevelRpManager.getResult(user,paramMap,request,response);
		if(list != null){
			listSize = list.size();
		}
		for(int i=0; i<listSize; i++){
			map = (Map)list.get(i);
	%>
	<tr align="left">
		<td><%=Tools.vString(map.get("title"))%></td>
		<td><%=Tools.vString(map.get("result"))%></td>
		<td><%=Tools.vString(map.get("percent"))+"%"%></td>
	</tr>
	<%	}%>
  </table>
<%
	}else if(cmd.equals("HrmJobCallRp")){
%>
  <table width="100%" class="ListStyle" border="1">
	<tr class="Header">
		<th width="30%"><%=SystemEnv.getHtmlLabelName(806, user.getLanguage())%></th>
		<th width="30%"><%=SystemEnv.getHtmlLabelName(1859, user.getLanguage())%></th>
		<th width="40%"><%=SystemEnv.getHtmlLabelName(31143, user.getLanguage())%></th>
	</tr>
	<%
		Map paramMap = new HashMap();
		paramMap.put("fromdate",fromdate);
		paramMap.put("enddate",enddate);
		paramMap.put("location",location);
		paramMap.put("status",status);
		list = HrmJobCallRpManager.getResult(user,paramMap,request,response);
		if(list != null){
			listSize = list.size();
		}
		for(int i=0; i<listSize; i++){
			map = (Map)list.get(i);
	%>
	<tr align="left">
		<td><%=Tools.vString(map.get("title"))%></td>
		<td><%=Tools.vString(map.get("result"))%></td>
		<td><%=Tools.vString(map.get("percent"))+"%"%></td>
	</tr>
	<%	}%>
  </table>
<%
	}else if(cmd.equals("hrmStatusRp")){
%>
  <table width="100%" class="ListStyle" border="1">
	<tr class="Header">
		<th width="30%"><%=SystemEnv.getHtmlLabelName(15890, user.getLanguage())%></th>
		<th width="30%"><%=SystemEnv.getHtmlLabelName(1859, user.getLanguage())%></th>
		<th width="40%"><%=SystemEnv.getHtmlLabelName(31143, user.getLanguage())%></th>
	</tr>
	<%
		Map paramMap = new HashMap();
		paramMap.put("fromdate",fromdate);
		paramMap.put("enddate",enddate);
		paramMap.put("department",department);
		paramMap.put("location",location);
		paramMap.put("status",status);
		list = HrmStatusRpManager.getResult(user,paramMap,request,response);
		if(list != null){
			listSize = list.size();
		}
		for(int i=0; i<listSize; i++){
			map = (Map)list.get(i);
	%>
	<tr align="left">
		<td><%=Tools.vString(map.get("title"))%></td>
		<td><%=Tools.vString(map.get("result"))%></td>
		<td><%=Tools.vString(map.get("percent"))+"%"%></td>
	</tr>
	<%	}%>
  </table>
<%
	}else if(cmd.equals("hrmUsekindRp")){
%>
  <table width="100%" class="ListStyle" border="1">
	<tr class="Header">
		<th width="30%"><%=SystemEnv.getHtmlLabelName(804, user.getLanguage())%></th>
		<th width="30%"><%=SystemEnv.getHtmlLabelName(1859, user.getLanguage())%></th>
		<th width="40%"><%=SystemEnv.getHtmlLabelName(31143, user.getLanguage())%></th>
	</tr>
	<%
		Map paramMap = new HashMap();
		paramMap.put("fromdate",fromdate);
		paramMap.put("enddate",enddate);
		paramMap.put("department",department);
		paramMap.put("location",location);
		paramMap.put("status",status);
		list = HrmUsekindRpManager.getResult(user,paramMap,request,response);
		if(list != null){
			listSize = list.size();
		}
		for(int i=0; i<listSize; i++){
			map = (Map)list.get(i);
	%>
	<tr align="left">
		<td><%=Tools.vString(map.get("title"))%></td>
		<td><%=Tools.vString(map.get("result"))%></td>
		<td><%=Tools.vString(map.get("percent"))+"%"%></td>
	</tr>
	<%	}%>
  </table>
<%
	}else if(cmd.equals("hrmMarriedRp")){
%>
  <table width="100%" class="ListStyle" border="1">
	<tr class="Header">
		<th width="30%"><%=SystemEnv.getHtmlLabelName(469, user.getLanguage())%></th>
		<th width="30%"><%=SystemEnv.getHtmlLabelName(1859, user.getLanguage())%></th>
		<th width="40%"><%=SystemEnv.getHtmlLabelName(31143, user.getLanguage())%></th>
	</tr>
	<%
		Map paramMap = new HashMap();
		paramMap.put("fromdate",fromdate);
		paramMap.put("enddate",enddate);
		paramMap.put("department",department);
		paramMap.put("location",location);
		paramMap.put("status",status);
		list = HrmMarriedRpManager.getResult(user,paramMap,request,response);
		if(list != null){
			listSize = list.size();
		}
		for(int i=0; i<listSize; i++){
			map = (Map)list.get(i);
	%>
	<tr align="left">
		<td><%=Tools.vString(map.get("title"))%></td>
		<td><%=Tools.vString(map.get("result"))%></td>
		<td><%=Tools.vString(map.get("percent"))+"%"%></td>
	</tr>
	<%	}%>
  </table>
<%
	}else if(cmd.equals("hrmSecLevelRp")){
%>
  <table width="100%" class="ListStyle" border="1">
	<tr class="Header">
		<th width="30%"><%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%></th>
		<th width="30%"><%=SystemEnv.getHtmlLabelName(1859, user.getLanguage())%></th>
		<th width="40%"><%=SystemEnv.getHtmlLabelName(31143, user.getLanguage())%></th>
	</tr>
	<%
		Map paramMap = new HashMap();
		paramMap.put("fromdate",fromdate);
		paramMap.put("enddate",enddate);
		paramMap.put("department",department);
		paramMap.put("location",location);
		paramMap.put("status",status);
		list = HrmSecLevelRpManager.getResult(user,paramMap,request,response);
		if(list != null){
			listSize = list.size();
		}
		for(int i=0; i<listSize; i++){
			map = (Map)list.get(i);
	%>
	<tr align="left">
		<td><%=Tools.vString(map.get("title"))%></td>
		<td><%=Tools.vString(map.get("result"))%></td>
		<td><%=Tools.vString(map.get("percent"))+"%"%></td>
	</tr>
	<%	}%>
  </table>
<%
	}else if(cmd.equals("hrmDepartmentRp")){
%>
  <table width="100%" class="ListStyle" border="1">
	<tr class="Header">
		<th width="20%"><%=SystemEnv.getHtmlLabelName(141, user.getLanguage())%></th>
		<th width="20%"><%=SystemEnv.getHtmlLabelName(124, user.getLanguage())%></th>
		
		<th width="10%"><%=SystemEnv.getHtmlLabelName(1859, user.getLanguage())%></th>
		<th width="30%"><%=SystemEnv.getHtmlLabelName(31143, user.getLanguage())%></th>
	</tr>
	<%
		Map paramMap = new HashMap();
		paramMap.put("fromdate",fromdate);
		paramMap.put("enddate",enddate);
		paramMap.put("location",location);
		paramMap.put("status",status);
		list = HrmDepartmentRpManager.getResult(user,paramMap,request,response);
		if(list != null){
			listSize = list.size();
		}
		for(int i=0; i<listSize; i++){
			map = (Map)list.get(i);
	%>
	<tr align="left">
		<td><%=Tools.vString(map.get("subcompanyname"))%></td>
		<td><%=Tools.vString(map.get("departmentname"))%></td>
		
		<td><%=Tools.vString(map.get("result"))%></td>
		<td><%=Tools.vString(map.get("percent"))+"%"%></td>
	</tr>
	<%	}%>
  </table>
<%
	}else if(cmd.equals("HrmJobTitleRp")){
%>
  <table width="100%" class="ListStyle" border="1">
	<tr class="Header">
		<th width="30%"><%=SystemEnv.getHtmlLabelName(6086, user.getLanguage())%></th>
		<th width="30%"><%=SystemEnv.getHtmlLabelName(1859, user.getLanguage())%></th>
		<th width="40%"><%=SystemEnv.getHtmlLabelName(31143, user.getLanguage())%></th>
	</tr>
	<%
		Map paramMap = new HashMap();
		paramMap.put("fromdate",fromdate);
		paramMap.put("enddate",enddate);
		paramMap.put("location",location);
		paramMap.put("status",status);
		list = HrmJobTitleRpManager.getResult(user,paramMap,request,response);
		if(list != null){
			listSize = list.size();
		}
		for(int i=0; i<listSize; i++){
			map = (Map)list.get(i);
	%>
	<tr align="left">
		<td><%=Tools.vString(map.get("title"))%></td>
		<td><%=Tools.vString(map.get("result"))%></td>
		<td><%=Tools.vString(map.get("percent"))+"%"%></td>
	</tr>
	<%	}%>
  </table>
<%
	}else if(cmd.equals("HrmJobActivityRp")){
%>
  <table width="100%" class="ListStyle" border="1">
	<tr class="Header">
		<th width="30%"><%=SystemEnv.getHtmlLabelName(1915, user.getLanguage())%></th>
		<th width="30%"><%=SystemEnv.getHtmlLabelName(1859, user.getLanguage())%></th>
		<th width="40%"><%=SystemEnv.getHtmlLabelName(31143, user.getLanguage())%></th>
	</tr>
	<%
		Map paramMap = new HashMap();
		paramMap.put("fromdate",fromdate);
		paramMap.put("enddate",enddate);
		paramMap.put("location",location);
		paramMap.put("status",status);
		list = HrmJobActivityRpManager.getResult(user,paramMap,request,response);
		if(list != null){
			listSize = list.size();
		}
		for(int i=0; i<listSize; i++){
			map = (Map)list.get(i);
	%>
	<tr align="left">
		<td><%=Tools.vString(map.get("title"))%></td>
		<td><%=Tools.vString(map.get("result"))%></td>
		<td><%=Tools.vString(map.get("percent"))+"%"%></td>
	</tr>
	<%	}%>
  </table>
<%
	}else if(cmd.equals("HrmJobGroupRp")){
%>
  <table width="100%" class="ListStyle" border="1">
	<tr class="Header">
		<th width="30%"><%=SystemEnv.getHtmlLabelName(806, user.getLanguage())%></th>
		<th width="30%"><%=SystemEnv.getHtmlLabelName(1859, user.getLanguage())%></th>
		<th width="40%"><%=SystemEnv.getHtmlLabelName(31143, user.getLanguage())%></th>
	</tr>
	<%
		Map paramMap = new HashMap();
		paramMap.put("fromdate",fromdate);
		paramMap.put("enddate",enddate);
		paramMap.put("location",location);
		paramMap.put("status",status);
		list = HrmJobGroupRpManager.getResult(user,paramMap,request,response);
		if(list != null){
			listSize = list.size();
		}
		for(int i=0; i<listSize; i++){
			map = (Map)list.get(i);
	%>
	<tr align="left">
		<td><%=Tools.vString(map.get("title"))%></td>
		<td><%=Tools.vString(map.get("result"))%></td>
		<td><%=Tools.vString(map.get("percent"))+"%"%></td>
	</tr>
	<%	}%>
  </table>
<%
	}
%>