<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.SessionOper" %>
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
String titlename = ""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+": "+SystemEnv.getHtmlLabelName(330,user.getLanguage())+"";
String needfav ="1";
String needhelp ="";    

int userid=0;
userid=user.getUID();

int id = Util.getIntValue(request.getParameter("id"));
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
String targetName = "";
String parentGoalName = "";
String goalDate = "";
String sql = "";

int minPoint = 0;
int maxPoint = 0;

//取得评分规则中的分数范围--------------------------------------------------------------------
sql = "SELECT * FROM HrmPerformancePointRule";
rs.executeSql(sql);
if(rs.next()){
	minPoint = rs.getInt("minPoint");
	maxPoint = rs.getInt("maxPoint");
}
//----------------------------------------------------------------------------



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
	memo = rs.getString("memo");
	percent_n = rs.getString("percent_n");
	pointStdId = rs.getInt("pointStdId");
	status = rs.getString("status");
	targetName = rs.getString("targetName");
	goalDate = rs.getString("goalDate");
}
rs.executeSql("SELECT goalName FROM HrmPerformanceGoal WHERE id="+parentId+"");
if(rs.next()) parentGoalName=rs.getString("goalName");

HashMap orgIdName = GoalUtil.getOrgIdName(Util.getIntValue(goalType),objId);
String objOrgName = (String)orgIdName.get("objOrgName");

//=============================================================================
//取得该目标剩余的权重大小
int percentSum = 0;
if (rs.getDBType().equals("oracle")){
	sql = "SELECT SUM(percent_n) AS percentSum FROM HrmPerformanceGoal WHERE goalType='"+goalType+"' AND objId="+objId+" AND cycle='"+cycle+"' AND goalDate='"+goalDate+"'";
}else if (rs.getDBType().equals("db2")){
	sql = "SELECT SUM(double(percent_n)) AS percentSum FROM HrmPerformanceGoal WHERE goalType='"+goalType+"' AND objId="+objId+" AND cycle='"+cycle+"' AND goalDate='"+goalDate+"'";
}else{
	sql = "SELECT sum(CAST(percent_n as bigint)) AS percentSum FROM HrmPerformanceGoal WHERE goalType='"+goalType+"' AND objId="+objId+" AND cycle='"+cycle+"' AND goalDate='"+goalDate+"'";
}
rs.executeSql(sql);
if(rs.next()){
	percentSum = rs.getInt("percentSum")==-1 ? 0 : rs.getInt("percentSum"); 
}
//=============================================================================
%>
<html>
<head>
<link href="/css/Weaver.css" type="text/css" rel="stylesheet">
<script language="javascript" src="/js/weaver.js"></script>
<script language="javascript" src="/js/addRowBg.js"></script>
</head>
  
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
//status: 0草稿 1退回 2待审批 3发布
if(status.equals("0") || status.equals("1")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
	//TD3762
	//modified by hubo,2006-03-21
	//RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:del("+id+"),_self} " ;
	//RCMenuHeight += RCMenuHeightStep ;
}
if(status.equals("3")){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:setFormAction();,_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 10px" name=frmMain method=post action="myGoalOperation.jsp">
<input name="id" type="hidden" value="<%=id%>"/>
<input name="operation" type="hidden" value="goalEdit"/>
<input name="goalType" type="hidden" value="<%=goalType%>"/>
<input name="objId" type="hidden" value="<%=objId%>"/>
<input type="hidden" id="rownum" name="rownum">
<!--=================================-->
<TABLE class=ViewForm id="formTable">
<COLGROUP>
<COL width="20%">
<COL width="80%">
</COLGROUP>
<TBODY>
<TR class=Title>
	<TH colSpan=2><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TH>
</TR>
<TR class=Spacing>
	<TD class=Line1 colSpan=2></TD>
</TR>
<tr>
	<td><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></td>
	<td class=Field><INPUT class=InputStyle maxLength=50 style="width:90%" name="goalName" onchange="checkinput('goalName','Nameimage')" value="<%=goalName%>">
	<SPAN id=Nameimage><%if(goalName.equals("")){%><IMG src='/images/BacoError.gif' align=absMiddle><%}%></SPAN>
	</td>
</tr>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--目标代码-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(590,user.getLanguage())%></td>
	<td class=Field><INPUT class=InputStyle maxLength=50  name="goalCode" value="<%=goalCode%>"></td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--上级目标-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(330,user.getLanguage())%></td>
	<td class=Field>
	<button type="button" class=Browser id=SelectFlowID onClick="onShowParentTargetID()"></button>
	<span id="parentTargetSpan"><a href="myGoalView.jsp?id=<%=parentId%>"><%=parentGoalName%></a></SPAN>
	<input type="hidden" id="parentTargetId" name="parentTargetId" value="<%=parentId%>"/>
	</td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--类型-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18085,user.getLanguage())%></td>
	<td class=Field>
	<BUTTON type="button" class=Browser id=SelectFlowID onClick="onShowTargetTypeBrowser()"></button>
	<span id="targetTypeSpan"><%=targetName%></SPAN>
	<input type="hidden" id="targetTypeId" name="targetTypeId" value="<%=type_t%>" />
	</td>
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
	<td class=Field>
	<%=user.getLastname()%>
	<INPUT type="hidden" name="operations" value="<%=user.getUID()%>">
	</td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--开始日期-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></td>
	<td class=Field>
	<BUTTON type="button" class=calendar onclick="getPfStartDate()"></BUTTON>
	<SPAN id=startDateSpan><%=startDate%></SPAN>
	<INPUT type=hidden name="startDate" value="<%=startDate%>">
	</td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--结束日期-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></td>
	<td class=Field>
	<BUTTON type="button" class=calendar onclick="getPfEndDate()"></BUTTON>
	<SPAN id=endDateSpan><%=endDate%></SPAN>
	<INPUT type=hidden name="endDate" value="<%=endDate%>">
	</td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--周期-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(15386,user.getLanguage())%></td>
	<td class=Field>
	<!-- update by liaodong for qc57566 in 20131011 start -->
	<%if(cycle !=null && !"".equals(cycle)){ %>
	   <%=SystemEnv.getHtmlLabelName(GoalUtil.getCycleLabelIdByKey(Util.getIntValue(cycle)),user.getLanguage())%>
	<%}%>
	<!-- end -->
	<input type="hidden" name="cycle" value="<%=cycle%>">
	</td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--属性-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></td>
	<td class=Field>
		<%if(property.equals("1")){%>
			<select class=inputStyle id="goalProperty" name="goalProperty" onchange="toggleProperties()">
			<option value=1 selected><%=SystemEnv.getHtmlLabelName(18089,user.getLanguage())%></option>
			<option value=0 ><%=SystemEnv.getHtmlLabelName(18090,user.getLanguage())%></option>
			</select><!--0:定性1:定量-->
		<%}else{%>
			<select class=inputStyle id="goalProperty" name="goalProperty" onchange="toggleProperties()">
			<option value=1><%=SystemEnv.getHtmlLabelName(18089,user.getLanguage())%></option>
			<option value=0 selected><%=SystemEnv.getHtmlLabelName(18090,user.getLanguage())%></option>
			</select><!--0:定性1:定量-->
		<%}%>
	</td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
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
	<option value="<%=rs1.getString("id")%>" <%if(rs1.getString("id").equals(unit)){out.println("selected");}%>><%=rs1.getString("unitName")%></option>
	<%}%>
	</select>
	</td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--目标值-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18087,user.getLanguage())%></td>
	<td class=Field>
	<input class=inputstyle name=targetValue  size=10 maxLength=10 onchange='checknumber("targetValue")' value="<%=targetValue%>">
	</td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--预警值-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18088,user.getLanguage())%></td>
	<td class=Field><input class=inputstyle name=previewValue  size=10 maxLength=10 onchange='checknumber("previewValue")' value="<%=previewValue%>"></td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--权重-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(6071,user.getLanguage())%></td>
	<td class=Field>			
		<input class=inputstyle id=percent_n name=percent_n size=10 maxLength=5 onkeypress='ItemNum_KeyPress()' onchange="checkPercent(this)" value="<%=percent_n%>">%
	</td>
</TR>
<TR style="height:1px;"><TD class=Line colSpan=2></TD></TR> 
<!--定义-->
<tr>
	<td><%=SystemEnv.getHtmlLabelName(18075,user.getLanguage())%></td>
	<td class=Field><textarea class="inputstyle" name="memo" style="width:90%"><%=memo%></textarea></td>
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
<TR class=Line><TD colspan="3"></TD></TR>
<%
String bgColor = "";
int rowIndex = 0;
rs.executeSql("SELECT * FROM HrmPerformanceGoalStd WHERE goalId="+id+"");
while(rs.next()){
	bgColor = (rowIndex%2)==0 ? "#E7E7E7" : "#F5F5F5";
%>
<tr style="background-color:<%=bgColor%>">
<td><div><input class='inputstyle rowTag' type='checkbox' name='check_node' value='0'></div></td>
<td><div><input class=inputstyle style='width:95%' type=text  name='stdName_<%=rowIndex%>' value="<%=rs.getString("stdName")%>" onchange="checkinput('stdName_<%=rowIndex%>','stdNameImage_<%=rowIndex%>')"><span id='stdNameImage_<%=rowIndex%>'></span></div></td>
<td><div><input class=inputstyle style='width:90%' type=text  name='point_<%=rowIndex%>' value='<%=rs.getInt("point")%>' onkeypress='ItemCount_KeyPress()' onblur='checkPoint(this)' onchange="checkinput('point_<%=rowIndex%>','pointImage_<%=rowIndex%>')"><span id='pointImage_<%=rowIndex%>'></span></div></td>
</tr>
<%rowIndex++;}%>
</tbody>
<tbody></tbody>
</table>
<!--=================================-->
</form>
</body>
</html>
<SCRIPT language="javascript" defer="defer" src="/js/datetime.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker.js"></script>
<script type="text/javascript">
<%if(property.equals("0")){%>
window.onload = function(){
	var rationRowIndex = document.all("ration").rowIndex;
	for(var i=0;i<6;i++){formTable.rows[rationRowIndex+i].style.display="none";}
	document.getElementById("unit").style.display = "none";
}
<%}%>
function checkPercent(o){
	var re = /^[1-9]\d*$/;
    	 if (o.value!="" && !re.test(o.value))
    {
        alert("<%=SystemEnv.getHtmlLabelName(24475,user.getLanguage())%>");
   o.value="";
        o.focus();
        return false;
     }else{
		var oddPercent = 0;
		oddPercent = parseInt(<%=100-percentSum%>);
		if(o.value>oddPercent){
			alert("<%=SystemEnv.getHtmlLabelName(18262,user.getLanguage())%>"+oddPercent+"!");
			o.value = "";
			o.focus();
			return false;
		}
	}
 	return true;
}
function del(id){
	if(confirm("<%=SystemEnv.getHtmlLabelName(17048,user.getLanguage())%>")){
		document.getElementById("operation").value = "delete";
		document.forms[0].submit();
		window.frames["rightMenuIframe"].event.srcElement.disabled = true;
	}
}

function setFormAction(){
	document.frmMain.action = "myGoalOperation.jsp?saveRevision=1&isApproved=true";
	checkSubmit();
}

function checkSubmit(){
	if(check_form(frmMain,'goalName') && check_form(frmMain,'parentTargetId') && check_form(frmMain,'targetTypeId')){
		var percent_n_obj = document.getElementById("percent_n");
		var flag_percent_n = checkPercent(percent_n_obj);
		if(flag_percent_n == false){
			return false;
		}
		var rowCount = $('.rowTag').length;
		for(var i=0;i<rowCount;i++){
			if((eval("frmMain.stdName_"+i)).value=="" || (eval("frmMain.point_"+i)).value==""){
				alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
				return false;
			}else{
				continue;
			}
		}
		document.getElementById("rownum").value = rowCount;
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
var rowindex = <%=rowIndex%>;
function addRow(){
	rowColor = getRowBg();
	var oTbody = oTable.tBodies[1];
	//var ncol = oTbody.firstChild.childNodes.length;
	var ncol=3;
	var oRow = oTbody.insertRow();
	rowindex = oRow.rowIndex - 4;
	for(j=0; j<ncol; j++) {
		oCell = oRow.insertCell();
		oCell.style.height = 24;
		oCell.style.background= rowColor;
		switch(j) {
            case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input class='inputstyle rowTag' type='checkbox' name='check_node' value='0'>";
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

function onShowTargetTypeBrowser(){
	var results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/maintenance/targetType/TargetTypeBrowser.jsp");
	if (results) {
		if (results.id!=""){
			targetTypeSpan.innerHTML =results.name;
			$G("targetTypeId").value =results.id;
		}else{
			targetTypeSpan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			$G("targetTypeId").value ="";
		}
	}
}

function onShowParentTargetID(){
	//goalType = document.getElementById("goalType").value;
	//objId = document.getElementById("objId").value;
	goalType =$G("goalType").value;
	objId = $G("objId").value;
	tempParam = goalType+","+objId;
	cycle = "<%=cycle%>";
	results = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/performance/goal/myGoalBrowser.jsp?cycle="+cycle)
	//alert(id(0))
	if (results) {
		if (results.id!="") {
			parentTargetSpan.innerHTML = "<A href='myGoalView.jsp?id="+results.id+"' target='_blank'>"+results.name+"</A>"
			$G("parentTargetId").value =results.id;
			targetTypeSpan.innerHTML =results.targetName;
			$G("targetTypeId").value =results.targetId;
		}else{
			parentTargetSpan.innerHTML = "<IMG src='/images/BacoError.gif' align=absMiddle>";
			$G("parentTargetId").value ="";
		}
	}
}

</script>