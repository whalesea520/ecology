<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.hrm.performance.goal.GoalUtil" %>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="kpi" class="weaver.hrm.performance.goal.KPIComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/systeminfo/init.jsp" %>
<%
kpi.removeKPIComInfoCache();
String imagefilename = "/images/hdHRM.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

/*
if(!HrmUserVarify.checkUserRight("SetGoal:Performance", user)){
    response.sendRedirect("/notice/noright.jsp");
    return;
}
*/
String msg = Util.null2String(request.getParameter("msg"));

//TD4941
//added by hubo, 2006-09-05
String strOrderBy = "";
String _orderby = Util.null2String(request.getParameter("orderby"));
String _orderasc = Util.null2String(request.getParameter("orderasc"));
if(!_orderby.equals("")){
	strOrderBy = "ORDER BY " + _orderby + " " + _orderasc;
}else{
	strOrderBy = "ORDER BY a.id asc ";
}

boolean hasSub = false;
String sql = "";
String objOrgName = "";
String goalType = "";
int objId = 0;
String goalDate = "";
String cycle = "";
String month = "";
String season = "";
String year = "";

//for退回提交
int groupId = 0;


//from workflow
boolean showCycleDiv = true;

int goalGroupId = Util.getIntValue(request.getParameter("id"));
if(goalGroupId!=-1){
	sql = "SELECT goalType,objId,goalDate,cycle FROM BPMGoalGroup WHERE id="+goalGroupId+"";
	rs.executeSql(sql);
	if(rs.next()){
		goalType = rs.getString("goalType");
		objId = rs.getInt("objId");
		goalDate = rs.getString("goalDate");
		cycle = rs.getString("cycle");
	}
	SessionOper.setAttribute(session,"goalGroupId",new Integer(goalGroupId));
	showCycleDiv = false;
}else if(SessionOper.getAttribute(session,"goalGroupId")!=null){
	sql = "SELECT goalType,objId,goalDate,cycle FROM BPMGoalGroup WHERE id="+((Integer)SessionOper.getAttribute(session,"goalGroupId")).intValue()+"";
	rs.executeSql(sql);
	if(rs.next()){
		goalType = rs.getString("goalType");
		objId = rs.getInt("objId");
		goalDate = rs.getString("goalDate");
		cycle = rs.getString("cycle");
	}
	showCycleDiv = false;
}else{
	if(SessionOper.getAttribute(session,"goalType") != null){
		goalType = (String)SessionOper.getAttribute(session,"goalType");
	}
	if(SessionOper.getAttribute(session,"objId") != null){
		objId = ((Integer)SessionOper.getAttribute(session,"objId")).intValue();
	}
	cycle = Util.null2String(request.getParameter("cycle"));
	
	month = Util.null2String(request.getParameter("month"));
	String tmpMonth = TimeUtil.getFormartString(Calendar.getInstance(),"MM");
	tmpMonth = tmpMonth.startsWith("0") ? tmpMonth.substring(1,tmpMonth.length()) : tmpMonth;
	if(month.equals("")){
		if(SessionOper.getAttribute(session,"month")==null){
			month = tmpMonth;
		}else{
			month = (String)SessionOper.getAttribute(session,"month");
		}
	}

	season = Util.null2String(request.getParameter("season"));
	if(season.equals("")){
		if(SessionOper.getAttribute(session,"season")==null){
			season = TimeUtil.getCurrentSeason();
		}else{
			season = (String)SessionOper.getAttribute(session,"season");
		}
	}

	year = Util.null2String(request.getParameter("year"));
	if(year.equals("")){
		if(SessionOper.getAttribute(session,"year")==null){
			year = TimeUtil.getFormartString(Calendar.getInstance(),"yyyy");
		}else{
			year = (String)SessionOper.getAttribute(session,"year");
		}
	}

	if(cycle.equals("0")){
		goalDate = year + month;
	}else if(cycle.equals("1")){
		goalDate = year + season;
	}else if(cycle.equals("2")){
		goalDate = year;
	}else if(cycle.equals("3")){
		goalDate = year;
	}else{
		if(SessionOper.getAttribute(session,"goalDate")==null){
			goalDate = year;
		}else{
			goalDate = (String)SessionOper.getAttribute(session,"goalDate");
		}
		if(SessionOper.getAttribute(session,"cycle")==null){
			cycle = "3";
		}else{
			cycle = (String)SessionOper.getAttribute(session,"cycle");
		}
	}

	SessionOper.setAttribute(session,"cycle",cycle);
	SessionOper.setAttribute(session,"month",month);
	SessionOper.setAttribute(session,"season",season);
	SessionOper.setAttribute(session,"year",year);
	SessionOper.setAttribute(session,"goalDate",goalDate);

	goalDate = (String)SessionOper.getAttribute(session,"goalDate");
}


//0草稿 1退回 2待审批 3发布
char goalGroupStatus = '0';
sql = "SELECT id,status FROM BPMGoalGroup WHERE objId="+objId+" AND goalType='"+goalType+"' AND goalDate='"+goalDate+"' AND cycle='"+cycle+"'";
//out.println(sql);
rs.executeSql(sql);
if(rs.next()){
	goalGroupStatus = rs.getString("status").charAt(0);
}

HashMap orgIdName = GoalUtil.getOrgIdName(Util.getIntValue(goalType),objId);
objOrgName = (String)orgIdName.get("objOrgName");

StringBuffer goalGroupName = new StringBuffer("");
goalGroupName.append(objOrgName);
if(cycle.equals("2")||cycle.equals("3")){
	goalGroupName.append(goalDate.substring(0,4));
}else{
	goalGroupName.append(goalDate.substring(0,4));
	goalGroupName.append(SystemEnv.getHtmlLabelName(445,user.getLanguage()));
	goalGroupName.append(goalDate.substring(4));
}
goalGroupName.append(SystemEnv.getHtmlLabelName(GoalUtil.getCycleLabelIdByKey(Util.getIntValue(cycle)),user.getLanguage()));
goalGroupName.append(SystemEnv.getHtmlLabelName(330,user.getLanguage()));

titlename = goalGroupName.toString();
%>
<html>
<head>
<link href="/css/Weaver.css" type="text/css" rel="stylesheet">
<style>
#divSeason,#divMonth{margin:5px 0 0 2px}
</style>
<script language="javascript" src="/js/weaver.js"></script>
<script type="text/javascript">
window.onload = function(){
	var o = document.getElementById("tblList");
	setTableRowBg(o);
	if(o.rows.length==2){document.getElementById("goalGroupStatus").style.display="none";}

	//TD4941
	//added by hubo, 2006-09-05
	var ths = document.getElementById("tblList").tHead.firstChild.childNodes;
	for(var i=1;i<ths.length-1;i++){
		ths[i].style.cursor = "hand";
		ths[i].onclick = doOrder;
	}
	switch("<%=_orderby%>"){
		case "a.goalName" : setOrderImg(ths[1]); break;
		case "b.targetName" : setOrderImg(ths[2]); break;
		case "a.objId" : setOrderImg(ths[3]); break;
		case "a.property" : setOrderImg(ths[4]); break;
		case "a.targetValue" : setOrderImg(ths[5]); break;
		case "a.parentId" : setOrderImg(ths[7]); break;
		default : setOrderImg(ths[6]); break;
	}
}

function doOrder(){
	var f = document.forms[1];
	var o = event.srcElement;
	switch(o.cellIndex){
		case 1 :	f.orderby.value = "a.goalName";	break;
		case 2 :	f.orderby.value = "b.targetName";break;
		case 3 :	f.orderby.value = "a.objId";		break;
		case 4 :	f.orderby.value = "a.property";	break;
		case 5 : f.orderby.value = "a.targetValue";	break;
		case 6 : f.orderby.value = "a.percent_n";	break;
		case 7 : f.orderby.value = "a.parentId";	break;
	}
	if(o.innerHTML.indexOf("img")!=-1 || o.innerHTML.indexOf("Asc")!=-1){
		f.orderasc.value = "desc";
	}else{
		f.orderasc.value = "asc";
	}
	f.method = "get";
	f.submit();
}

function setOrderImg(o){
	var orderImg = "<%=_orderasc%>"=="asc" ? "/images/orderAsc.gif" : "/images/orderDesc.gif";
	o.insertAdjacentHTML("beforeEnd", "<img src='"+orderImg+"'>");	
}

function doSubmit(){
	if(document.getElementById("targetTBody").children.length<=1){
		alert("<%=SystemEnv.getHtmlLabelName(18258,user.getLanguage())%>!");
		return false;
	}
	if(!checkPercent100()){
		alert("<%=SystemEnv.getHtmlLabelName(18179,user.getLanguage())%>!");
		return false;
	}
	if(confirm("<%=SystemEnv.getHtmlLabelName(18259,user.getLanguage())%>?")){
		document.getElementById("operation").value = "goalSubmit";
		document.forms[0].submit();
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
	}
}
function doSubmit2(){
	if(document.getElementById("targetTBody").children.length<=1){
		alert("<%=SystemEnv.getHtmlLabelName(18258,user.getLanguage())%>!");
		return false;
	}
	if(!checkPercent100()){
		alert("<%=SystemEnv.getHtmlLabelName(18179,user.getLanguage())%>!");
		return false;
	}
	if(confirm("<%=SystemEnv.getHtmlLabelName(18259,user.getLanguage())%>?")){
		document.getElementById("operation").value = "goalSubmit2";
		document.forms[0].submit();
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
	}
}
function goalBreak(goalid){
	location.href = "myGoalBreak.jsp?id="+goalid;
}
function exportToTarget(){
	var o = document.getElementsByName("id");
	var goalIds = "";
	for(var i=0;i<o.length;i++){
		if(!o[i].checked) continue;
		goalIds += o[i].value + ",";
	}
	//alert(goalIds);
	if(goalIds.length==0){
		alert("<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(330,user.getLanguage())%>!");
		return false;
	}else{
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
		location.href = "myGoalOperation.jsp?operation=exportToTarget&goalIds="+goalIds;
	}
}

function doSwitch(objTbls){
	var spanSwitch = window.event.srcElement;
	var o  = document.getElementsByTagName("TR");
	if((spanSwitch.src).indexOf("expanded")==-1){
		for(var i=0;i<o.length;i++){
			if(o[i].getAttribute("sr")==objTbls){
				o[i].style.display="block";
			}
		}
		spanSwitch.src = "/images/expanded.gif";
	}else{
		for(var i=0;i<o.length;i++){
			if(o[i].getAttribute("sr")==objTbls){
				o[i].style.display="none";
			}
		}
		spanSwitch.src = "/images/collapsed.gif";
	}
}

function setTableRowBg(obj){
	for(var i=2;i<obj.rows.length;i++){
		obj.rows[i].style.backgroundColor = i%2==0 ? "#FFF" : "#EEE";
	}
}

function checkPercent100(){
	if(document.getElementById("sumPercent").value==100){
		return true;
	}else{
		return false;
	}
}

function checkPercent()
{
per=0;

var lenn=document.getElementsByName("percent_n")

var  len=lenn.length;
if (len>1)
{
for(i=0;i<len;i++)
{
if (document.frmMain.percent_n[i].value=="")
{
alert('<%=SystemEnv.getHtmlLabelName(18138,user.getLanguage())%>');
return false;
}
else
{
per=per+parseInt(document.frmMain.percent_n[i].value);
}
}
}
if (len==1)
{
if (document.frmMain.percent_n.value=="")
{
alert('<%=SystemEnv.getHtmlLabelName(18138,user.getLanguage())%>');
return false;
}
else
{
per=parseInt(document.frmMain.percent_n.value);
}
}
if (per!=100)
{
alert('<%=SystemEnv.getHtmlLabelName(18212,user.getLanguage())%>');
return false;
}
document.getElementById("operation").value = "modifyPercent";
document.forms[0].submit();
window.frames["rightMenuIframe"].event.srcElement.disabled = true;
return true;
}

function checkNumber(o){
	var re = /^[1-9]\d*$/;
     if (o.value!="" && !re.test(o.value))
    {
        alert("<%=SystemEnv.getHtmlLabelName(24475,user.getLanguage())%>");
   o.value="";
        o.focus();
        return false;
     }
	 return true;
}
</script>
</head>

<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
boolean hasPower = false;
if(goalType.equals("3")){
	if(objId==user.getUID() || Rights.getRights(user,String.valueOf(objId),goalType,"DepartmentGoal:Manage","0")) hasPower=true;
}else if(goalType.equals("2")){
	if(Rights.getRights(user,String.valueOf(objId),goalType,"DepartmentGoal:Manage","0")) hasPower=true;
}else if(goalType.equals("1")){
	if(Rights.getRights(user,String.valueOf(objId),goalType,"SubCompanyGoal:Manage","0")) hasPower=true;
}else if(goalType.equals("0")){
	if(Rights.getRights(user,String.valueOf(objId),goalType,"CompanyGoal:Manage","0")) hasPower=true;
}
//out.println(goalGroupStatus);
if(goalGroupStatus=='0' && hasPower){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(330,user.getLanguage())+",javascript:location.href='myGoalAdd.jsp',_self} ";
	RCMenuHeight += RCMenuHeightStep;
	if((goalType.equals("3") && objId==user.getUID()) || (!goalType.equals("3") && hasPower)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(15143,user.getLanguage())+",javascript:doSubmit(),_self}";
		RCMenuHeight += RCMenuHeightStep;
	}
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(18225,user.getLanguage())+",javascript:checkPercent(),_self}";
}else if(goalGroupStatus=='1' && hasPower){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(330,user.getLanguage())+",javascript:location.href='myGoalAdd.jsp',_self} ";
	RCMenuHeight += RCMenuHeightStep;
	if((goalType.equals("3") && objId==user.getUID()) || (!goalType.equals("3") && hasPower)){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(15143,user.getLanguage())+",javascript:doSubmit2(),_self}";
		RCMenuHeight += RCMenuHeightStep;
	}
	RCMenu += "{"+SystemEnv.getHtmlLabelName(18225,user.getLanguage())+",javascript:checkPercent(),_self}";
	RCMenuHeight += RCMenuHeightStep;
//TD4201
//modified by hubo,2006-04-19
}else if(goalGroupStatus=='3' && HrmUserVarify.checkUserRight("TargetTypeInfo:Maintenance",user)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(330,user.getLanguage())+",javascript:location.href='myGoalAdd.jsp?isApproved=true',_self} ";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(18237,user.getLanguage())+",javascript:exportToTarget(),_self}";
	RCMenuHeight += RCMenuHeightStep;
}else if(goalGroupStatus=='3' && hasPower){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(330,user.getLanguage())+",javascript:location.href='myGoalAdd.jsp',_self} ";
	RCMenuHeight += RCMenuHeightStep;
}
//TD4195
//modified by hubo,2006-04-19
if(SessionOper.getAttribute(session,"goalGroupId")!=null){
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self}";
}
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<%
if(showCycleDiv){
if(cycle.equals("1")){
	out.println("<div id='divSeason'>");
	for(int i=1;i<=4;i++){
		if(season.equals(String.valueOf(i))){
			out.println(""+i+SystemEnv.getHtmlLabelName(17495,user.getLanguage()));
		}else{
			out.println("<a href='myGoalListIframe.jsp?cycle=1&season="+i+"'>"+i+SystemEnv.getHtmlLabelName(17495,user.getLanguage())+"</a>");
		}
	}
	out.println("</div>");
}else if(cycle.equals("0")){	
	out.println("<div id='divMonth'>");
	for(int i=1;i<=12;i++){
		if(month.equals(String.valueOf(i))){
			out.println(""+i+SystemEnv.getHtmlLabelName(6076,user.getLanguage()));
		}else{
			out.println("<a href='myGoalListIframe.jsp?cycle=0&month="+i+"'>"+i+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+"</a>");
		}
	}
	out.println("</div>");
}}
%>

<form name="frmMain" method="post" action="myGoalOperation.jsp" style="margin:10px 0 0 0;padding:0">
<input type="hidden" id="operation" name="operation" value="">
<input type="hidden" id="goalGroupId" name="goalGroupId" value="<%=goalGroupId%>">
<input type="hidden" id="goalGroupName" name="goalGroupName" value="<%=goalGroupName.toString()%>">
<input type="hidden" id="targetIds" name="targetIds" value="">
<!--
<table style="width:100%;height:100%;border:1;border-collapse:collapse;">
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
<h2><%=goalGroupName.toString()%></h2>
<table id="goalGroupStatus" style="width:100%">
<tr>
	<td width="45%" style="color:red"><%if(msg.equals("1")){out.println(SystemEnv.getHtmlLabelName(18268,user.getLanguage())+"!");}%></td>
	<td width="55%" style="font-weight:bold">(<%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%>:
	<%=SystemEnv.getHtmlLabelName(GoalUtil.getGoalStatusLabelId(goalGroupStatus),user.getLanguage())%>)</td>
</tr>
</table>
<table class="ListStyle" cellspacing="1" id="tblList">
<thead>
<tr class="Header">
	<th width="5%"></th>
	<th width="20%"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
	<th width="18%"><%=SystemEnv.getHtmlLabelName(18085,user.getLanguage())%></th>
	<th width="17%"><%=SystemEnv.getHtmlLabelName(18239,user.getLanguage())%></th>
	<th width="5%"><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></th>
	<th width="15%"><%=SystemEnv.getHtmlLabelName(18087,user.getLanguage())%></th>
	<th width="5%"><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></th>
	<th width="10%"><%=SystemEnv.getHtmlLabelName(19709,user.getLanguage())%></th>
	<th width="5%"><%=SystemEnv.getHtmlLabelName(18215,user.getLanguage())%></th>
</tr>
</thead>
<tbody id="targetTBody">
<tr class="Line">
	<td colSpan="8"></td>
</tr>
<%
if(goalGroupId!=-1){//from workflow
	sql = "SELECT a.id,a.goalName,a.objId,a.parentId,a.cycle,a.property,a.targetValue,a.percent_n,a.beExported,a.modifyStatus,a.modifyUser,b.targetName FROM HrmPerformanceGoal a,HrmPerformanceTargetType b WHERE a.type_t=b.id AND a.groupid="+goalGroupId+" "+strOrderBy+"";
}else{
	sql = "SELECT a.id,a.goalName,a.objId,a.parentId,a.cycle,a.property,a.targetValue,a.percent_n,a.groupid,a.beExported,a.modifyStatus,a.modifyUser,b.targetName FROM HrmPerformanceGoal a,HrmPerformanceTargetType b WHERE a.type_t=b.id AND a.goalDate='"+goalDate+"' AND a.goalType='"+goalType+"' AND a.objId="+objId+" AND a.cycle='"+cycle+"' "+strOrderBy+"";
}
//out.println(sql);
rs.executeSql(sql);
ArrayList arrListId = new ArrayList();
ArrayList arrListName = new ArrayList();
ArrayList arrListTargetName = new ArrayList();
ArrayList arrListObjName = new ArrayList();
ArrayList arrListProperty = new ArrayList();
ArrayList arrListTargetValue = new ArrayList();
ArrayList arrListId2 = new ArrayList();
ArrayList arrListName2 = new ArrayList();
ArrayList arrListTargetName2 = new ArrayList();
ArrayList arrListObjName2 = new ArrayList();
ArrayList arrListProperty2 = new ArrayList();
ArrayList arrListTargetValue2 = new ArrayList();
HashMap orgIdNameSub = new HashMap();
HashMap orgIdNameSub2 = new HashMap();
boolean hasSubGoal;
double sumPercent = 0.0;
while(rs.next()){
	sumPercent += Util.getDoubleValue(rs.getString("percent_n"));
	hasSubGoal = false;
	groupId = rs.getInt("groupid");
	//横向分解==================================================================
	rs2.executeSql("SELECT a.id,a.goalName,a.goalType,a.objId,a.property,a.targetValue,a.beExported,b.targetName FROM HrmPerformanceGoal a,HrmPerformanceTargetType b WHERE a.type_t=b.id AND parentId="+rs.getInt("id")+" AND a.objId="+rs.getInt("objId")+" AND a.goalType='"+goalType+"'");
	while(rs2.next()){
		hasSubGoal = true;
		arrListId.add(new Integer(rs2.getInt("id")));
		arrListName.add(new String(rs2.getString("goalName")));
		arrListTargetName.add(new String(rs2.getString("targetName")));
		orgIdNameSub = GoalUtil.getOrgIdName(Util.getIntValue(rs2.getString("goalType")),rs2.getInt("objId"));
		arrListObjName.add(orgIdNameSub.get("objOrgName"));
		arrListProperty.add(new String(rs2.getString("property")));
		arrListTargetValue.add(new String(Util.getPointValue(rs2.getString("targetValue"),1,rs2.getString("targetValue"))));
	}
	//纵向分解==================================================================
	rs2.executeSql("SELECT a.id,a.goalName,a.goalType,a.objId,a.property,a.targetValue,a.beExported,b.targetName FROM HrmPerformanceGoal a,HrmPerformanceTargetType b WHERE a.type_t=b.id AND parentId="+rs.getInt("id")+" ORDER BY a.goalType ASC,a.objId ASC");
	while(rs2.next()){
		if(rs2.getInt("objId")==rs.getInt("objId"))	continue;
		hasSubGoal = true;
		arrListId2.add(new Integer(rs2.getInt("id")));
		arrListName2.add(new String(rs2.getString("goalName")));
		arrListTargetName2.add(new String(rs2.getString("targetName")));
		orgIdNameSub2 = GoalUtil.getOrgIdName(Util.getIntValue(rs2.getString("goalType")),rs2.getInt("objId"));
		arrListObjName2.add(orgIdNameSub2.get("objOrgName"));
		arrListProperty2.add(new String(rs2.getString("property")));
		arrListTargetValue2.add(new String(Util.getPointValue(rs2.getString("targetValue"),1,rs2.getString("targetValue"))));
	}
%>
<tr>
	<td><%if(goalGroupStatus=='3'){%><input type="checkbox" name="id" value="<%=rs.getInt("id")%>" <%if(rs.getString("beExported").equals("1")){out.println("disabled");}%>><%}%></td>
	<td>
		<%if(hasSubGoal){%><img src="/images/collapsed.gif" align="absmiddle" onclick="doSwitch('tbl_<%=rs.getInt("id")%>')" style="cursor:hand"><%}else{%><img src="/images/expanded.gif" align="absmiddle"><%}%><a href="myGoalView.jsp?id=<%=rs.getInt("id")%>"><%=rs.getString("goalName")%></a>
		<%
		//TD
		//added by hubo, 2006-10-16
		String strStatus = "";
		String modifyStatus = Util.null2String(rs.getString("modifyStatus"));
		String modifyUser = Util.null2String(rs.getString("modifyUser"));
		//Td14122异常处理，根据目标变更记录表记录操作者ID取操作者直接上级，如操作者没有直接上级，则操作者自行处理
		String userobjod = "";
		if(modifyUser.equals("") || modifyUser.equals(null)){
			userobjod = rs.getString("id");
			if(userobjod.equals("") || userobjod.equals(null)){
				userobjod = "0";
			}
			rs3.executeSql("select operator from HrmKPIRevision where goalId ="+ userobjod);
			if(rs3.next()){
				modifyUser = rs3.getString(1); 
			}	
		}
		int modifyUserManager = Util.getIntValue(ResourceComInfo.getManagerID(modifyUser));
		if(modifyUserManager == 0){
			modifyUserManager =user.getUID();
		}
		if(modifyStatus.equals("1")){
			strStatus = "(" + SystemEnv.getHtmlLabelName(2242,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage()) +")";
		}else if(modifyStatus.equals("2")){
			strStatus = "(" + SystemEnv.getHtmlLabelName(2242,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(93,user.getLanguage()) +")";
		}else if(modifyStatus.equals("3")){
			strStatus = "(" + SystemEnv.getHtmlLabelName(2242,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(91,user.getLanguage()) +")";
		}else{
			strStatus = "";
		}
		%>
		<%if(user.getUID()==modifyUserManager){%>
		<div style="color:red;cursor:hand;text-decoration:underline" onclick="location.href='goalRevision.jsp?id=<%=rs.getString("id")%>'"><%=strStatus%></div>
		<%}else{%>
		<div style="color:red"><%=strStatus%></div>
		<%}%>
	</td>
	<td><%=rs.getString("targetName")%></td>
	<td><%=objOrgName%></td>
	<td><%=SystemEnv.getHtmlLabelName(GoalUtil.getGoalProperty(rs.getString("property")),user.getLanguage())%></td>
	<td>
		<%
		if(rs.getString("property").equals("1")){
			out.println(Util.getPointValue(rs.getString("targetValue"),1,rs.getString("targetValue")));
		}
		%>
	</td>
	<td>
		<%if(goalGroupStatus=='0' || goalGroupStatus=='1'){%>
		<input type="text" name="percent_n" value="<%=rs.getString("percent_n")%>" class="InputStyle" size="3" maxlength="5" onchange="checkNumber(this)" onkeypress='ItemNum_KeyPress()'>%
		<input type="hidden" name="percent_id" value="<%=rs.getInt("id")%>">
		<input type="text" value="" style="display:none"> 
		<%}else{%>
		<%=rs.getString("percent_n")%>%
		<%}%>
	</td>
	<td><a href="myGoalView.jsp?id=<%=rs.getInt("parentId")%>"><%=kpi.getName(rs.getString("parentId"))%></a></td>
	<td style="padding-left:5px">
	<%if(goalGroupStatus=='3' && hasPower && !(goalType.equals("3") && cycle.equals("0"))){%>
		<a href="javascript:goalBreak(<%=rs.getInt("id")%>)"><img src="/images/goalBreak.gif" alt="<%=SystemEnv.getHtmlLabelName(330,user.getLanguage())+SystemEnv.getHtmlLabelName(18215,user.getLanguage())%>" style="border:0"></a>
	<%}%>
	</td>
</tr>

<%
Iterator itId = arrListId.iterator();
Iterator itName = arrListName.iterator();
Iterator itTargetName = arrListTargetName.iterator();
Iterator itObjName = arrListObjName.iterator();
Iterator itProperty = arrListProperty.iterator();
Iterator itTargetValue = arrListTargetValue.iterator();
while(itId.hasNext()){
%>
<tr sr="tbl_<%=rs.getInt("id")%>" style="display:none">
	<td>&nbsp;</td>
	<td style="padding-left:10px"><img src="/images/ArrowNextBlue.gif"> <a href="myGoalView.jsp?id=<%=itId.next()%>"><%=itName.next()%></a></td>
	<td><%=itTargetName.next()%></td>
	<td><%=itObjName.next()%></td>
	<td>
		<%
		String p = (String)itProperty.next();
		out.println(SystemEnv.getHtmlLabelName(GoalUtil.getGoalProperty(p),user.getLanguage()));
		%>
	</td>
	<td>
		<%if(p.equals("1")){out.println(itTargetValue.next());}%>
	</td>
	<td></td>
	<td>&nbsp;</td>
</tr>
<%}%>

<%
Iterator itId2 = arrListId2.iterator();
Iterator itName2 = arrListName2.iterator();
Iterator itTargetName2 = arrListTargetName2.iterator();
Iterator itObjName2 = arrListObjName2.iterator();
Iterator itProperty2 = arrListProperty2.iterator();
Iterator itTargetValue2 = arrListTargetValue2.iterator();
while(itId2.hasNext()){
%>
<tr sr="tbl_<%=rs.getInt("id")%>" style="display:none">
	<td>&nbsp;</td>
	<td style="padding-left:10px"><img src="/images/ArrowNextGreen.gif"> <a href="myGoalView.jsp?id=<%=itId2.next()%>"><%=itName2.next()%></a></td>
	<td><%=itTargetName2.next()%></td>
	<td><%=itObjName2.next()%></td>
	<td>
		<%
		String p = (String)itProperty2.next();
		out.println(SystemEnv.getHtmlLabelName(GoalUtil.getGoalProperty(p),user.getLanguage()));
		%>
	</td>
	<td>
		<%if(p.equals("1")){out.println(itTargetValue2.next());}%>
	</td>
	<td></td>
	<td>&nbsp;</td>
</tr>
<%}%>

<%
	arrListId.clear();
	arrListName.clear();
	arrListId2.clear();
	arrListName2.clear();
	arrListTargetName.clear();
	arrListTargetName2.clear();
	arrListObjName.clear();
	arrListObjName2.clear();
	arrListProperty.clear();
	arrListProperty2.clear();
	arrListTargetValue.clear();
	arrListTargetValue2.clear();
}
%>
</tbody>
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
<input type="hidden" name="groupId" id="groupId" value="<%=groupId%>">
<input type="hidden" name="sumPercent" id="sumPercent" value="<%=sumPercent%>">
</form>

<form method="post">
<input type="hidden" name="msg" id="msg" value="<%=msg%>">
<input type="hidden" name="id" id="id" value="<%=goalGroupId%>">
<input type="hidden" name="cycle" id="cycle" value="<%=cycle%>">
<input type="hidden" name="month" id="month" value="<%=month%>">
<input type="hidden" name="season" id="season" value="<%=season%>">
<input type="hidden" name="year" id="year" value="<%=year%>">
<input type="hidden" name="orderby" id="orderby" />
<input type="hidden" name="orderasc" id="orderasc" />
</form>
</body>
</html>

<script language="vbscript">
sub onShowDoc()
	id1 = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/hrm/performance/maintenance/targetType/TargetBrowserMuti.jsp")
	if (Not IsEmpty(id1)) then
		targetIds = id1(0)
		targetIds = Mid(targetIds,2,len(targetIds))
		'alert(targetIds)
		document.all("operation").value = "targetImport"
		document.all("targetIds").value = targetIds
		document.all("frmMain").submit()
	end if
end sub
</script>