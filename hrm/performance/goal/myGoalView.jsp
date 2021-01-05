<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.hrm.performance.goal.GoalUtil" %>
<%@ page import="weaver.hrm.resource.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>
<%
String imagefilename = "/images/hdMaintenance.gif";
//TD3950
//modified by hubo,2006-03-15
String titlename = ""+SystemEnv.getHtmlLabelName(367,user.getLanguage())+": "+SystemEnv.getHtmlLabelName(330,user.getLanguage())+"";
String needfav ="1";
String needhelp ="";    

int userid=0;
userid=user.getUID();

int id = Util.getIntValue(request.getParameter("id"));
String objOrgName = "";
String goalName = "";
int objId = 0;
String goalCode = "";
int parentId = 0;
int operations = 0;
String type_t = "";
String startDate = "";
String endDate = "";
String goalType = "";
String cycle = "";
String property = "";
String unit = "";
String targetValue = "";
String previewValue = "";
String memo = "";
String percent_n = "";
int pointStdId = 0;
String status = "";
int groupId = 0;
String targetName = "";
String parentGoalName = "";
String sql = "";
String modifyStatus = "";

sql = "SELECT a.*,b.targetName FROM HrmPerformanceGoal a,HrmPerformanceTargetType b WHERE a.id="+id+" AND a.type_t=b.id";
rs.executeSql(sql);
if(rs.next()){
	goalName = rs.getString("goalName");
	objId = rs.getInt("objId");
	goalCode = rs.getString("goalCode");
	parentId = rs.getInt("parentId");
	operations = rs.getInt("operations");
	type_t = rs.getString("type_t");
	startDate = rs.getString("startDate");
	endDate = rs.getString("endDate");
	goalType = rs.getString("goalType");
	cycle = rs.getString("cycle");
	property = rs.getString("property");
	unit = rs.getString("unit");
	targetValue = Util.getPointValue(rs.getString("targetValue"),1,rs.getString("targetValue"));
	previewValue = Util.getPointValue(rs.getString("previewValue"),1,rs.getString("previewValue"));
	percent_n = rs.getString("percent_n");
	memo = rs.getString("memo");
	pointStdId = rs.getInt("pointStdId");
	status = rs.getString("status");
	groupId = rs.getInt("groupid");
	targetName = rs.getString("targetName");
	modifyStatus = Util.null2String(rs.getString("modifyStatus"));
}
HashMap orgIdName = GoalUtil.getOrgIdName(Util.getIntValue(goalType),objId);
objOrgName = (String)orgIdName.get("objOrgName");

rs.executeSql("SELECT goalName FROM HrmPerformanceGoal WHERE id="+parentId+"");
if(rs.next()) parentGoalName=rs.getString("goalName");
%>
<html>
<head>
<link href="/css/Weaver.css" type="text/css" rel="stylesheet">
<script language="javascript" src="/js/weaver.js"></script>
<script language="javascript" src="/js/addRowBg.js"></script>
<script type="text/javascript">
function del(id){
	if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>")){
		document.getElementById("operation").value = "delete";
		document.forms[0].action = "myGoalOperation.jsp";
		document.forms[0].submit();
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
	}
}
</script>
</head>
  
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
int managerId = 0;
if(goalType.equals("3")){
	managerId = Util.getIntValue(resComInfo.getManagerID(String.valueOf(objId)));
}else{
	rs.executeSql("SELECT b.creater FROM BPMGoalGroup a, Workflow_RequestBase b WHERE a.requestid=b.requestid AND a.id="+groupId+"");
	if(rs.next()){
		managerId = Util.getIntValue(resComInfo.getManagerID(rs.getString("creater")));
	}
}

boolean hasPower = false;
if(goalType.equals("3")){
	//TD4941 上级分解的目标不能编辑、删除，只能维护自己为分配人的目标。
	//modified by hubo, 2006-10-10
	if(operations==user.getUID() || Rights.getRights(user,String.valueOf(objId),goalType,"DepartmentGoal:Manage","0")) hasPower=true;
}else if(goalType.equals("2")){
	if(Rights.getRights(user,String.valueOf(objId),goalType,"DepartmentGoal:Manage","0")) hasPower=true;
}else if(goalType.equals("1")){
	if(Rights.getRights(user,String.valueOf(objId),goalType,"SubCompanyGoal:Manage","0")) hasPower=true;
}else if(goalType.equals("0")){
	if(Rights.getRights(user,String.valueOf(objId),goalType,"CompanyGoal:Manage","0")) hasPower=true;
}
//status: 0草稿 1退回 2待审批 3发布
if((status.equals("0") || status.equals("1") || status.equals("3")) && hasPower && modifyStatus.equals("")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",myGoalEdit.jsp?id="+id+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	//TD3762
	//modified by hubo,2006-03-21
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:del("+id+"),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
/*
//目标发布后其负责单位的上级可以编辑
if(status.equals("3") && user.getUID()==managerId){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93,user.getLanguage())+",myGoalEdit.jsp?id="+id+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
if(status.equals("3")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(19765,user.getLanguage())+",goalRevision.jsp?id="+id+",_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
*/
//TD4195
//modified by hubo,2006-04-19
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 10px" name=frmMain method=post action="">
<input type="hidden" name="isApproved" value="<%if(status.equals("3")){out.print("true");}%>">
<input type="hidden" id="rownum" name="rownum">
<input name="id" type="hidden" value="<%=id%>"/>
<input name="operation" id="operation" type="hidden" value=""/>
<!--
<table style="width:100%;height:100%;border:1;border-collapse:collapse">
<colgroup>
	<col width="0">
	<col width="">
	<col width="0">
</colgroup>
<tr>
	<td></td>
	<td valign="top">
		<table class="Shadow">
		<tr>
			<td valign="top">
-->		
<!--=================================-->
<TABLE class=ViewForm id="formTable">
<COLGROUP>
<COL width="20%">
<COL width="80%">
</COLGROUP>
<TBODY>
<TR class=Title>
	<TH colSpan=2><%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%></TH>
</TR>
<TR class=Spacing>
	<TD class=Line1 colSpan=2></TD>
</TR>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
	<td class=Field><%=goalName%></td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--目标代码-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(590,user.getLanguage())%></td>
	<td class=Field><%=goalCode%></td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--上级目标-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(330,user.getLanguage())%></td>
	<td class=Field><a href="myGoalView.jsp?id=<%=parentId%>"><%=parentGoalName%></a></td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--类型-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18085,user.getLanguage())%></td>
	<td class=Field><%=targetName%></td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--负责单位-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18239,user.getLanguage())%></td>
	<td class=Field><%=objOrgName%></td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--分配人-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18257,user.getLanguage())%></td>
	<td class=Field><a href="/hrm/resource/HrmResource.jsp?id=<%=operations%>"><%=resComInfo.getResourcename(String.valueOf(operations))%></a></td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--开始日期-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
	<td class=Field><%=startDate%></td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--结束日期-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
	<td class=Field><%=endDate%></td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--周期-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></td>
	<td class=Field><%=SystemEnv.getHtmlLabelName(GoalUtil.getCycleLabelIdByKey(Util.getIntValue(cycle)),user.getLanguage())%></td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--属性-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></td>
	<td class=Field>
		<%if(property.equals("1")){%>
			<%=SystemEnv.getHtmlLabelName(18089,user.getLanguage())%>
		<%}else{%>
			<%=SystemEnv.getHtmlLabelName(18090,user.getLanguage())%>
		<%}%>
	</td>
</TR>
<%if(property.equals("1")){%>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--计量单位-->
<tr id="ration">
	<td><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></td>
	<td class=Field>
	<%
	//TD3995
	//modified by hubo,2006-03-21
	rs1.execute("select * from HrmPerformanceCustom where id="+Util.getIntValue(unit)+"");
	if(rs1.next()) out.println(rs1.getString("unitName"));
	%>
	</td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--目标值-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18087,user.getLanguage())%></td>
	<td class=Field><%=targetValue%></td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--预警值-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18088,user.getLanguage())%></td>
	<td class=Field><%=previewValue%></td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<%}%>
<!--权重-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></td>
	<td class=Field><%=percent_n%>%</td>
</TR>
<!--定义-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18075,user.getLanguage())%></td>
	<td class=Field><%=memo%></td>
</TR>
</TBODY>
</TABLE>

<TABLE width="100%" id="oTable" class=ListStyle cellspacing=1>
<thead>
<TR>
	<td colspan="3">
		<table style="width:100%;border-collapse:collapse;" cellpadding="0">
		<tr>
			<Td style="font-weight:bold;vertical-align:bottom"><%=SystemEnv.getHtmlLabelName(18091,user.getLanguage())%></Td>
			<Td align=right></Td>
		</tr>
		</table>
	</td>
</TR>
</thead>
<TR><TD style="height:2px;background-color:#A1A1A1" colSpan=3></TD></TR>
<tbody>
<tr class=Header style="height:22px">
	<td width="10%"></td>
	<td width="70%"><%=SystemEnv.getHtmlLabelName(18092,user.getLanguage())%></td>
	<td width="20%"><%=SystemEnv.getHtmlLabelName(18093,user.getLanguage())%></td>
</tr>
<TR class=Line><TD colspan="3"></TD></TR>
<%
String bgColor = "";
int rowIndex = 0;
rs.executeSql("SELECT * FROM HrmPerformanceGoalStd WHERE goalId="+id+" ORDER BY point DESC");
while(rs.next()){
	bgColor = (rowIndex%2)==0 ? "#FFFFFF" : "#F7F7F7";
%>
<tr style="background-color:<%=bgColor%>">
<td></td>
<td><%=rs.getString("stdName")%></td>
<td><%=rs.getInt("point")%></td>
</tr>
<%rowIndex++;}%>
</tbody>
<tbody></tbody>
</table>
<!--=================================-->
<!--
			</td>
		</tr>
		</table>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
-->
</form>
</body>
</html>