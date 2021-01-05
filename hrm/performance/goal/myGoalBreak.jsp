<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.goal.GoalUtil" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdMaintenance.gif";
String titlename = ""+SystemEnv.getHtmlLabelName(18215,user.getLanguage())+": "+SystemEnv.getHtmlLabelName(330,user.getLanguage())+"";
String needfav ="1";
String needhelp ="";    

int userid=0;
userid=user.getUID();

String sql = "";
int targetId = 0;
String targetTypeName = "";
int targetTypeId = 0;
String targetName = "";
String targetCode = "";
String unit = "";
String targetValue = "";
String previewValue = "";
String memo = "";
String addRowStr = "";
int minPoint = 0;
int maxPoint = 0;

//取得评分规则中的分数范围----------------------------------------------------
sql = "SELECT * FROM HrmPerformancePointRule";
rs.executeSql(sql);
if(rs.next()){
	minPoint = rs.getInt("minPoint");
	maxPoint = rs.getInt("maxPoint");
}

//导入指标--------------------------------------------------------------------
int targetImportId = Util.getIntValue(request.getParameter("targetImportId"));
if(targetImportId!=-1){
	sql = "SELECT a.*,b.id AS targetTypeId,b.targetName AS targetTypeName FROM HrmPerformanceTargetDetail a, HrmPerformanceTargetType b WHERE a.id="+targetImportId+" AND a.targetId=b.id";
	rs.executeSql(sql);
	if(rs.next()){
		targetId = rs.getInt("targetId");
		targetTypeId = rs.getInt("targetTypeId");
		targetTypeName = rs.getString("targetTypeName");
		targetName = rs.getString("targetName");
		targetCode = rs.getString("targetCode");
		unit = rs.getString("unit");
		targetValue = rs.getString("targetValue");
		previewValue = rs.getString("previewValue");
		memo = rs.getString("memo");
	}
	//评分标准
	sql = "SELECT * FROM HrmPerformanceTargetStd WHERE targetDetailId="+targetImportId+"";
	rs.executeSql(sql);
	while(rs.next()){
		addRowStr += "addRowImport('"+rs.getString("stdName")+"',"+rs.getInt("point")+");";
	}
}
//----------------------------------------------------------------------------

int parentGoalId = Util.getIntValue(request.getParameter("id"));
String parentGoalName = "";
int parentObjId = 0;
String parentGoalType = "";
String parentCycle = "";
int parentTargetId = 0;
String parentTargetName = "";
String parentProperty = "";
String parentTargetValue = "";
sql = "SELECT a.*,b.id AS targetTypeId,b.targetName FROM HrmPerformanceGoal a,HrmPerformanceTargetType b WHERE a.type_t=b.id AND a.id="+parentGoalId+"";
rs.executeSql(sql);
if(rs.next()){
	parentGoalName = rs.getString("goalName");
	parentObjId = rs.getInt("objId");
	parentGoalType = rs.getString("goalType");
	parentCycle = rs.getString("cycle");
	parentTargetId = rs.getInt("targetTypeId");
	parentTargetName = rs.getString("targetName");
	parentProperty = rs.getString("property");
	parentTargetValue = Util.getPointValue(rs.getString("targetValue"),1,rs.getString("targetValue"));
}

int goalType = Util.getIntValue((String)SessionOper.getAttribute(session,"goalType"));
int objId = ((Integer)SessionOper.getAttribute(session,"objId")).intValue();
HashMap hm = GoalUtil.getOrgIdName(goalType,objId);
HashMap hmParent = GoalUtil.getOrgIdName(Util.getIntValue(parentGoalType),parentObjId);


int cycle = Util.getIntValue((String)SessionOper.getAttribute(session,"cycle"));
%>
<html>
<head>
<link href="/css/Weaver.css" type="text/css" rel="stylesheet">
<style>
#cycleSeason, #cycleMonth{display:none;}
</style>
<script language="javascript" src="/js/weaver.js"></script>
<script language="javascript" src="/js/addRowBg.js"></script>
<script type="text/javascript">
var cycleTD;
var oCycleInnerHTML = "";

function setTableRowBg(obj){
	for(var i=3;i<obj.rows.length;i++){
		obj.rows[i].style.backgroundColor = i%2==0 ? "#FFF" : "#EEE";
	}
}

window.onload = function(){
	var o = document.getElementById("tblParentGoal");
	setTableRowBg(o);

	cycleTD = document.getElementById("cycleTD");
	initCycleSelect();
	<%=addRowStr%>
};

function initCycleSelect(){
	setCycleSelect();
	var o = document.getElementById("cycle");
	if(o.options.length><%=cycle%>){
		o.options[<%=cycle%>].selected;		
	}
	showCycleSub(o);
}

function showCycleSub(o){
	if(o.options[o.selectedIndex].value=="1"){
		document.getElementById("cycleSeason").style.display = "block";
		document.getElementById("cycleMonth").style.display = "none";
	}else if(o.options[o.selectedIndex].value=="0"){
		document.getElementById("cycleSeason").style.display = "none";
		document.getElementById("cycleMonth").style.display = "block";
	}else{
		document.getElementById("cycleSeason").style.display = "none";
		document.getElementById("cycleMonth").style.display = "none";
	}
}

function setCycleSelect(){
	oCycleInnerHTML = '<select id="cycle" name="cycle" onchange="showCycleSub(this)" style="float:left">';
	for(var i=3;i>=0;i--){
		<%if(goalType==3){%>
		if(i>=<%=parentCycle%>) continue;
		<%}%>
		if(i==3){
			oCycleInnerHTML += "<option value='3'><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></option>";
		}else if(i==2){
			oCycleInnerHTML += "<option value='2'><%=SystemEnv.getHtmlLabelName(18059,user.getLanguage())%></option>";
		}else if(i==1){
			oCycleInnerHTML += "<option value='1'><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%></option>";
		}else if(i==0){
			oCycleInnerHTML += "<option value='0'><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></option>";
		}
	}
	oCycleInnerHTML += "</select>";	
	cycleTD.innerHTML = oCycleInnerHTML;
}

function doSwitch(objTbls){
	var spanSwitch = window.event.srcElement;
   if (spanSwitch.tagName=="IMG") spanSwitch = spanSwitch.parentElement;
	var tblList = (objTbls).split(",");
	for(i=0;i<tblList.length;i++){
		if(document.getElementById(tblList[i])==null) continue;
		with(document.getElementById(tblList[i])){
			if(tBodies[0].style.display=="none"){
				tBodies[0].style.display = "block";
				spanSwitch.innerHTML = "<img src='/images/up.jpg' style='cursor:hand' alt='<%=SystemEnv.getHtmlLabelName(16636,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18224,user.getLanguage())%>'> ";
			}else{
				tBodies[0].style.display = "none";
				spanSwitch.innerHTML = "<img src='/images/down.jpg' style='cursor:hand' alt='<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18224,user.getLanguage())%>'>";
			}
		}
	}
}
</script>
</head>
  
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(18231,user.getLanguage())+",javascript:onShowTargetSingle(),_self} ";
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",myGoalListIframe.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 10px" name=frmMain method=post action="myGoalOperation.jsp" >
<input type="hidden" id="operation" name="operation" value="goalAdd"/>
<input type="hidden" id="operation2" name="operation2" value="goalBreak"/>
<input type="hidden" id="goalType" name="goalType" value="<%=goalType%>"/>
<input type="hidden" id="parentTargetId" name="parentTargetId" value="<%=parentGoalId%>"/>
<input type="hidden" id="rownum" name="rownum">
<!--
<table style="width:100%;height:100%;border:0;border-collapse:collapse">
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
<div style="color:red">
<%
//TD3707
//added by hubo,2006-03-21
String msg = Util.null2String(request.getParameter("msg"));
int msgObjId = Util.getIntValue(request.getParameter("msgObjId")); 
String msgGoalDate = Util.null2String(request.getParameter("msgGoalDate"));
int msgGoalType = Util.getIntValue(request.getParameter("msgGoalType"));
String msgCycle = Util.null2String(request.getParameter("msgCycle"));
HashMap hmMsg = GoalUtil.getOrgIdName(msgGoalType,msgObjId);
if(msgCycle.equals("3")){
	out.println(hmMsg.get("objOrgName")+msgGoalDate.substring(0,4)+SystemEnv.getHtmlLabelName(445,user.getLanguage())+SystemEnv.getHtmlLabelName(18551,user.getLanguage())+"!");
}else if(msgCycle.equals("2")){
	out.println(hmMsg.get("objOrgName")+msgGoalDate.substring(0,4)+SystemEnv.getHtmlLabelName(18059,user.getLanguage())+SystemEnv.getHtmlLabelName(18551,user.getLanguage())+"!");
}else if(msgCycle.equals("1")){
	out.println(hmMsg.get("objOrgName")+msgGoalDate.substring(0,4)+SystemEnv.getHtmlLabelName(445,user.getLanguage())+msgGoalDate.substring(4,msgGoalDate.length())+SystemEnv.getHtmlLabelName(17495,user.getLanguage())+SystemEnv.getHtmlLabelName(18551,user.getLanguage())+"!");
}else if(msgCycle.equals("0")){
	out.println(hmMsg.get("objOrgName")+msgGoalDate.substring(0,4)+SystemEnv.getHtmlLabelName(445,user.getLanguage())+msgGoalDate.substring(4,msgGoalDate.length())+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+SystemEnv.getHtmlLabelName(18551,user.getLanguage())+"!");
}
%>
</div>
<table style="width:100%" class="ViewForm" id="tblParentGoal">
<thead>
<TR class=Title>
	<TH><%=SystemEnv.getHtmlLabelName(18224,user.getLanguage())%></TH>
	<th></th>
	<th></th>
	<th></th>
	<th></th>
	<th style="text-align:right"><span class="spanSwitch" onclick="doSwitch('tblParentGoal')"><img src='/images/down.jpg' style="cursor:hand" alt='<%=SystemEnv.getHtmlLabelName(89,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18224,user.getLanguage())%>'></th>
</TR>
<TR class=Spacing><TD class=Line1 colSpan=6></TD>
</TR>
</thead>
<tbody style="display:none">
<tr style="background-color:#C8C8C8;color:#003366;font-weight:bold;height:20px">
	<td width="*" colspan="2"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
	<td width="100"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
	<td width="120"><%=SystemEnv.getHtmlLabelName(18239,user.getLanguage())%></td>
	<td width="50"><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></td>
	<td width="60"><%=SystemEnv.getHtmlLabelName(18087,user.getLanguage())%></td>
</tr>
<tr>
	<td colspan="2"><img src="/images/expanded.gif" align="absmiddle"> <a href="myGoalView.jsp?id=<%=parentGoalId%>"><%=parentGoalName%></a></td>
	<td><%=parentTargetName%></td>
	<td><%=hmParent.get("objOrgName")%></td>
	<td><%=SystemEnv.getHtmlLabelName(GoalUtil.getGoalProperty(parentProperty),user.getLanguage())%></td>
	<td>
	<%
	if(parentProperty.equals("0")){
		out.println("&nbsp;");
	}else{
		out.println(parentTargetValue);
	}
	%>
	</td>
</tr>
<%
HashMap hmSub = new HashMap();
//横向分解==================================================================
rs.executeSql("SELECT a.*,b.targetName FROM HrmPerformanceGoal a,HrmPerformanceTargetType b WHERE a.type_t=b.id AND a.parentId="+parentGoalId+" AND a.objId="+parentObjId+" AND a.goalType='"+parentGoalType+"'");
while(rs.next()){
	hmSub = GoalUtil.getOrgIdName(Util.getIntValue(rs.getString("goalType")),rs.getInt("objId"));
%>
<tr>
	<td style="padding-left:10px" colspan="2"><img src="/images/ArrowNextBlue.gif"> <a href="myGoalView.jsp?id=<%=rs.getInt("id")%>"><%=rs.getString("goalName")%></a></td>
	<td><%=rs.getString("targetName")%></td>
	<td><%=hmSub.get("objOrgName")%></td>
	<td><%=SystemEnv.getHtmlLabelName(GoalUtil.getGoalProperty(rs.getString("property")),user.getLanguage())%></td>
	<td>
		<%
		if(rs.getString("property").equals("0")){
			out.println("&nbsp;");
		}else{
			out.println(Util.getPointValue(rs.getString("targetValue"),1,rs.getString("targetValue")));
		}
		%>
	</td>
</tr>
<%}%>

<%
//纵向分解==================================================================
rs.executeSql("SELECT a.*,b.targetName FROM HrmPerformanceGoal a,HrmPerformanceTargetType b WHERE a.type_t=b.id AND a.parentId="+parentGoalId+" AND a.objId<>"+parentObjId+" ORDER BY a.goalType ASC,a.objId ASC");
while(rs.next()){
	hmSub = GoalUtil.getOrgIdName(Util.getIntValue(rs.getString("goalType")),rs.getInt("objId"));
%>
<tr>
	<td style="padding-left:10px" colspan="2"><img src="/images/ArrowNextGreen.gif"> <a href="myGoalView.jsp?id=<%=rs.getInt("id")%>"><%=rs.getString("goalName")%></a></td>
	<td><%=rs.getString("targetName")%></td>
	<td><%=hmSub.get("objOrgName")%></td>
	<td><%=SystemEnv.getHtmlLabelName(GoalUtil.getGoalProperty(rs.getString("property")),user.getLanguage())%></td>
	<td>
		<%
		if(rs.getString("property").equals("0")){
			out.println("&nbsp;");
		}else{
			out.println(Util.getPointValue(rs.getString("targetValue"),1,rs.getString("targetValue")));
		}
		%>
	</td>
</tr>
<%}%>
</tbody>
</table>

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
	<td class=Field>
		<INPUT class=InputStyle maxLength=50 style="width:90%" name="goalName"  onchange="checkinput('goalName','Nameimage')" value="<%=targetName%>">
		<SPAN id=Nameimage><%if(targetName.equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></SPAN>
	</td>
</tr>
<TR><TD class=Line colSpan=2></TD></TR>
<!--目标代码-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(590,user.getLanguage())%></td>
	<td class=Field>			
		<INPUT class=InputStyle maxLength=50  name="goalCode" value="<%=targetCode%>">
	</td>
</TR>
<TR><TD class=Line colSpan=2></TD></TR>
<!--上级目标-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(330,user.getLanguage())%></td>
	<td class=Field>
		<a href=""><a href="myGoalView.jsp?id=<%=parentGoalId%>"><%=parentGoalName%></a>
	</td>
</TR>
<TR><TD class=Line colSpan=2></TD></TR>
<!--类型-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></td>
	<td class=Field>			
		<BUTTON type="button" class=Browser id=SelectFlowID onClick="onShowTargetTypeBrowser()"></button>
		<%if(!targetTypeName.equals("")){%>
		<span id="targetTypeSpan"><%=targetTypeName%></SPAN>
		<input type="hidden" id="targetTypeId" name="targetTypeId" value="<%=targetTypeId%>" />
		<%}else if(!parentTargetName.equals("")){%>
		<span id="targetTypeSpan"><%=parentTargetName%></SPAN>
		<input type="hidden" id="targetTypeId" name="targetTypeId" value="<%=parentTargetId%>" />
		<%}else{%>
		<span id="targetTypeSpan"><IMG src='/images/BacoError.gif' align=absMiddle></SPAN>
		<input type="hidden" id="targetTypeId" name="targetTypeId" />
		<%}%>
	</td>
</TR>
<TR><TD class=Line colSpan=2></TD></TR>
<!--负责单位-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18239,user.getLanguage())%></td>
	<td class=Field>
	<input type="hidden" name="objIdAll" id="objIdAll">
	<%
	switch(goalType){
		case 0:
	%>
	<BUTTON type="button" class=Browser id=SelectSubCompany onclick="onShowDepartment2()"></BUTTON>
   <SPAN id=objIdSpan><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
   <INPUT class=inputstyle id=objId type=hidden name=objId value="">
	</td>
	<%
			break;
		case 1:
	%>
	<BUTTON type="button" class=Browser id=SelectDepartment onclick="onShowDepartment2()"></BUTTON>
	<SPAN id=objIdSpan><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
	<INPUT class=inputstyle id=objId type=hidden name=objId value="">
	<%
			break;
		case 2:
	%>
	<BUTTON type="button" class=Browser id=SelectDepartment onclick="onShowDepartment2()"></BUTTON>
	<SPAN id=objIdSpan><IMG src="/images/BacoError.gif" align=absMiddle></SPAN>
	<INPUT class=inputstyle id=objId type=hidden name=objId value="">	
	<%
			break;
		case 3:
	%>
	<%=hm.get("objOrgName")%>
	<INPUT class=inputstyle id=objId type=hidden name=objId value="<%=objId%>">
	<%
			break;
	}
	%>
</TR>
<TR><TD class=Line colSpan=2></TD></TR>
<!--分配人-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18257,user.getLanguage())%></td>
	<td class=Field>			
		<%=user.getLastname()%>
		<INPUT type="hidden" name="operations" value="<%=user.getUID()%>">
	</td>
</TR>
<TR><TD class=Line colSpan=2></TD></TR>
<!--开始日期-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
	<td class=Field>			
		<BUTTON type="button" class=calendar onclick="getPfStartDate()"></BUTTON>
		<SPAN id=startDateSpan></SPAN>
		<INPUT type=hidden name="startDate">
	</td>
</TR>
<TR><TD class=Line colSpan=2></TD></TR>
<!--结束日期-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
	<td class=Field>			
		<BUTTON type="button" class=calendar onclick="getPfEndDate()"></BUTTON>
		<SPAN id=endDateSpan></SPAN>
		<INPUT type=hidden name="endDate">
	</td>
</TR>
<TR><TD class=Line colSpan=2></TD></TR>
<!--周期-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></td>
	<td class=Field>		
		<span id="cycleTD"></span>
	  <select id="cycleSeason" name="cycleSeason">
		<option value="1">1<%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%></option>
		<option value="2">2<%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%></option>
		<option value="3">3<%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%></option>
		<option value="4">4<%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%></option>
	  </select>
		
	  <select id="cycleMonth" name="cycleMonth">
		<script type="text/javascript">
		for(var i=1;i<=12;i++){
			document.write("<option value=\""+i+"\">"+i+"月</option>");
		}
		</script>
	  </select>
	</td>
</TR>
<TR><TD class=Line colSpan=2></TD></TR>
<!--属性-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></td>
	<td class=Field>			
		<select class=inputStyle id="goalProperty" name="goalProperty" onchange="toggleProperties()">
      <option value=1 selected><%=SystemEnv.getHtmlLabelName(18089,user.getLanguage())%></option>
		<option value=0 ><%=SystemEnv.getHtmlLabelName(18090,user.getLanguage())%></option>
      </select><!--0:定性1:定量-->
	</td>
</TR>
<TR><TD class=Line colSpan=2></TD></TR>
<!--计量单位-->
<tr id="ration">
	<td><%=SystemEnv.getHtmlLabelName(705,user.getLanguage())%></td>
	<td class=Field>			
		<select class=inputStyle id=unit name=unit> 
		<%
		//TD3995
		//modified by hubo,2006-03-21
		rs1.execute("select * from HrmPerformanceCustom where status='0' order by id desc");
		while (rs1.next()){
		%>    
		<option value="<%=rs1.getString("id")%>" ><%=rs1.getString("unitName")%></option>
		<%}%>
		</select>
	</td>
</TR>
<TR><TD class=Line colSpan=2></TD></TR>
<!--目标值-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18087,user.getLanguage())%></td>
	<td class=Field>			
		<input class=inputstyle name=targetValue  size=10 maxLength=10 onchange='checknumber("targetValue")' value="<%=targetValue%>">
	</td>
</TR>
<TR><TD class=Line colSpan=2></TD></TR>
<!--预警值-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18088,user.getLanguage())%></td>
	<td class=Field>			
		<input class=inputstyle name=previewValue  size=10 maxLength=10 onchange='checknumber("previewValue")' value="<%=previewValue%>">
	</td>
</TR>
<TR><TD class=Line colSpan=2></TD></TR>
<!--定义-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18075,user.getLanguage())%></td>
	<td class=Field>			
		<textarea class="inputstyle" name="memo" style="width:90%"><%=memo%></textarea>
	</td>
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
			<Td align=right>
			<BUTTON type="button" class=btnNew accessKey=A onClick="addRow();"><U>A</U>-<%=SystemEnv.getHtmlLabelName(551,user.getLanguage())%></BUTTON>
			<BUTTON type="button" class=btnDelete accessKey=D onClick="javascript:deleteRow1();"><U>D</U>-<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%></BUTTON>
			</Td>
		</tr>
		</table>
	</td>
</TR>
</thead>
<TR><TD style="height:2px;background-color:#A1A1A1" colSpan=3></TD></TR>
<tbody>
<tr class=Header>
	<td width="10%"></td>
	<td width="70%"><%=SystemEnv.getHtmlLabelName(18092,user.getLanguage())%></td>
	<td width="20%"><%=SystemEnv.getHtmlLabelName(18093,user.getLanguage())%></td>
</tr>
<TR class=Line><TD colspan="3" ></TD></TR>
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
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
</html>

<script type="text/javascript">
function onShowDepartment2(){
	var selected = document.getElementById("objIdAll").value;
	vDialog = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/goal/objBrowser.jsp?selected="+selected);
	if(vDialog){
		document.getElementById("objIdSpan").innerHTML = vDialog[0];
		document.getElementById("objId").value = vDialog[1];
		document.getElementById("objIdAll").value = vDialog[2];
	}else{
		document.getElementById("objId").value = "";
		document.getElementById("objIdSpan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		document.getElementById("objIdAll").value = "";
	}
}
/*
function onShowDepartment2(){
	vDialog = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/goal/objBrowser.jsp");
	if(vDialog==null){
		document.getElementById("objId").value = "";
		document.getElementById("objIdSpan").innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
	}else{
		if(document.getElementById("objId").value==vDialog[0]) return false;
		document.getElementById("objId").value = vDialog[0];
		document.getElementById("objIdSpan").innerHTML = vDialog[1];
		document.getElementById("goalType").value = vDialog[2];
		//横向分解目标，排除周期
		var oCycle = document.getElementById("cycle");
		if(vDialog[0]==<%=parentObjId%> && vDialog[2]==<%=parentGoalType%>){
			for(var i=3;i>=<%=parentCycle%>;i--){
				oCycle.removeChild(oCycle.options[0]);
			}
			showCycleSub(oCycle);
		}else{
			initCycleSelect();
		}
	}
}
*/
function checkSubmit(){
	if(check_form(frmMain,'goalName') && check_form(frmMain,'targetTypeId') && check_form(frmMain,'objId')){
		var oTbody = oTable.tBodies[1];
		var rowCount = oTbody.childNodes.length;
		for(var i=0;i<rowCount-2;i++){
			if((eval("frmMain.stdName_"+i)).value=="" || (eval("frmMain.point_"+i)).value==""){
				alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				return false;
			}else{
				continue;
			}
		}
		document.getElementById("rownum").value = oTable.tBodies[1].rows.length - 2;
		frmMain.submit();
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
	}
}

function toggleProperties(){
	var rationRowIndex = document.all("ration").rowIndex;
	if(document.all.goalProperty.options[document.all.goalProperty.selectedIndex].value=="1"){
		for(var i=0;i<6;i++){formTable.rows[rationRowIndex+i].style.display="";}
		document.getElementById("unit").style.display = "";
	}else{
		for(var i=0;i<6;i++){formTable.rows[rationRowIndex+i].style.display="none";}
		document.getElementById("unit").style.display = "none";
	}
	
}

var rowColor;
function addRowImport(stdName,stdPoint){
	rowColor = getRowBg();
	var oTbody = oTable.tBodies[1];
	var ncol = oTbody.firstChild.childNodes.length;
	var oRow = oTbody.insertRow();
	var rowindex = oRow.rowIndex - 4;

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.style.height = 24;
		oCell.style.background= rowColor;
		switch(j) {
            case 0:
				var oDiv = document.createElement("div");
				var sHtml =  "<input class=inputstyle style='width:95%' type=text  name='stdName_"+rowindex+"' value='"+stdName+"' onchange=\"checkinput('stdName_"+rowindex+"','stdNameImage_"+rowindex+"')\"><span id='stdNameImage_"+rowindex+"'></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml =  "<input class=inputstyle style='width:100%' type=text  name='stdName_"+rowindex+"' value='"+stdName+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle style='width:90%' type=text  name='point_"+rowindex+"' value='"+stdPoint+"'  onkeypress='ItemCount_KeyPress()' onblur='checkPoint(this)'  onchange=\"checkinput('point_"+rowindex+"','pointImage_"+rowindex+"')\"><span id='pointImage_"+rowindex+"'></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
}

function addRow(){
	rowColor = getRowBg();
	var oTbody = oTable.tBodies[1];
	var ncol = oTbody.firstChild.childNodes.length;
	var oRow = oTbody.insertRow();
	var rowindex = oRow.rowIndex - 4;

	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.style.height = 24;
		oCell.style.background= rowColor;
		switch(j) {
            case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' name='check_node' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml =  "<input class=inputstyle style='width:95%' type=text  name='stdName_"+rowindex+"'  onchange=\"checkinput('stdName_"+rowindex+"','stdNameImage_"+rowindex+"')\"><span id='stdNameImage_"+rowindex+"'><IMG src='/images/BacoError.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle style='width:90%' type=text  name='point_"+rowindex+"' onkeypress='ItemCount_KeyPress()' onblur='checkPoint(this)' onchange=\"checkinput('point_"+rowindex+"','pointImage_"+rowindex+"')\"><span id='pointImage_"+rowindex+"'><IMG src='/images/BacoError.gif' align=absMiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
}

function deleteRow1(){
	len = document.forms[0].elements.length;
	for(i=len-1; i >= 0;i--){		
		if(document.forms[0].elements[i].name=='check_node'){
			if(document.forms[0].elements[i].checked==true) {
				delRowIndex = document.forms[0].elements[i].parentNode.parentNode.parentNode.rowIndex;
				oTable.deleteRow(delRowIndex);
			}
		}
	}
}

function checkPoint(o){
	if(o.value<<%=minPoint%> || o.value><%=maxPoint%>){
		alert("<%=SystemEnv.getHtmlLabelName(18261,user.getLanguage())%>(<%=minPoint%>-<%=maxPoint%>)");
		o.value = "";
		o.parentElement.childNodes[1].innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
		o.focus();
		return false;
	}
}
</script>

<script type="text/vbscript">
sub onShowSubcompany()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp&selectedids="&frmMain.objId.value)
	issame = false
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = frmMain.objId.value then
		issame = true
	end if
	objIdSpan.innerHtml = id(1)
	frmMain.objId.value=id(0)
	frmMain.goalType.value = "1"
	else
	objIdSpan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmMain.objId.value=""
	frmMain.goalType.value = "1"
	end if
	end if
end sub


sub onShowDepartment()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/goal/objBrowser.jsp")
	alert(id)
	issame = false
	if (Not IsEmpty(id)) then
	if id(0)<> 0 then
	if id(0) = frmMain.objId.value then
		issame = true
	end if
	objIdSpan.innerHtml = id(1)
	frmMain.objId.value=id(0)
	frmMain.goalType.value = "2"
	else
	objIdSpan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
	frmMain.objId.value=""
	frmMain.goalType.value = "2"
	end if
	end if
end sub

sub onShowGoalID()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/goal/myGoalBrowserForPlan.jsp")
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			alert(id(1))
			alert(id(0))
		else
			parentTargetSpan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			alert(id(0))
		end if
	end if
end sub

sub onShowTargetTypeBrowser()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/maintenance/targetType/TargetTypeBrowser.jsp")
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			targetTypeSpan.innerHtml = "<A href='/hrm/resource/HrmResource.jsp?id="&id(0)&"'>"&id(1)&"</A>"
			frmMain.targetTypeId.value = id(0)
		else
			targetTypeSpan.innerHtml = "<IMG src='/images/BacoError.gif' align=absMiddle>"
			frmMain.targetTypeId.value = id(0)
		end if
	end if
end sub

sub onShowTargetSingle()
	id = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/maintenance/targetType/TargetBrowserSingle.jsp")
	if (Not IsEmpty(id)) then
		if id(0)<> "" then
			location.href = "myGoalBreak.jsp?id=<%=parentGoalId%>&targetImportId="&id(0)
		end if
	end if
end sub
</script>