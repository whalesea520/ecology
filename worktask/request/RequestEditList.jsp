
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.worktask.worktask.*" %>
<STYLE TYPE="text/css">
/*样式名未定义*/
.btn_RequestSubmitList {BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
}
</STYLE>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetu" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetd" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="sysPubRefComInfo" class="weaver.general.SysPubRefComInfo" scope="page" />
<%
int canCreateHistoryWorktask = Util.getIntValue(BaseBean.getPropValue("worktask", "canCreateHistoryWorktask"), 1);
session.setAttribute("relaterequest", "new");
String functionPage = Util.null2String(request.getParameter("functionPage"));
String CurrentUser = ""+user.getUID();
String currentMonth = String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).MONTH)+1);
String currentWeek = String.valueOf(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).get(TimeUtil.getCalendar(TimeUtil.getCurrentDateString()).WEEK_OF_YEAR));
String currentDay = TimeUtil.getCurrentDateString();
String currentQuarter="";
String years = Util.null2String(request.getParameter("years"));
String months = Util.null2String(request.getParameter("months"));
String quarters = Util.null2String(request.getParameter("quarters"));
String weeks = Util.null2String(request.getParameter("weeks"));
String days = Util.null2String(request.getParameter("days"));
String objId = Util.null2String((String)SessionOper.getAttribute(session,"hrm.objId"));
String type = Util.null2String(request.getParameter("type")); //周期
String type_d = Util.null2String((String)SessionOper.getAttribute(session,"hrm.type_d")); //计划所有者类型
String objName = Util.null2String((String)SessionOper.getAttribute(session,"hrm.objName"));
String operationType = Util.null2String(request.getParameter("operationType"));
int wtid = Util.getIntValue(request.getParameter("wtid"), 0);
int worktaskStatus = Util.getIntValue(request.getParameter("worktaskStatus"), 0);
String editids = Util.null2String(request.getParameter("editids"));
editids = "," + editids + ",";
int isfromleft = Util.getIntValue(request.getParameter("isfromleft"), 0);
String checkStr = "";

String sqlWhere = "";
WTSerachManager wtSerachManager = new WTSerachManager(wtid);
wtSerachManager.setLanguageID(user.getLanguage());
wtSerachManager.setType_d(type_d);
wtSerachManager.setObjid(objId);
wtSerachManager.setUserID(user.getUID());
wtSerachManager.setWorktaskStatus(worktaskStatus);
wtSerachManager.setIsfromleft(isfromleft);

String worktaskName = "";
String worktaskStatusName = "";
Hashtable worktaskName_hs = new Hashtable();
rs1.execute("select * from worktask_base");
while(rs1.next()){
	String id_tmp = Util.null2String(rs1.getString("id"));
	String worktaskName_tmp = Util.null2String(rs1.getString("name"));
	worktaskName_hs.put("worktaskname_"+id_tmp, worktaskName_tmp);
}
if(wtid > 0){
	worktaskName = Util.null2String((String)worktaskName_hs.get("worktaskname_"+wtid));
}
ArrayList wtsdetailCodeList = sysPubRefComInfo.getDetailCodeList("WorkTaskStatus");
ArrayList wtsdetailLabelList = sysPubRefComInfo.getDetailLabelList("WorkTaskStatus");
if(wtsdetailCodeList.contains(""+worktaskStatus)){
		worktaskStatusName = SystemEnv.getHtmlLabelName(Util.getIntValue((String)wtsdetailLabelList.get(wtsdetailCodeList.indexOf(""+worktaskStatus))), user.getLanguage());
}
Hashtable codefield_hs = new Hashtable();
rs1.execute("select * from worktask_code");
while(rs1.next()){
	int taskid_tmp = Util.getIntValue(rs1.getString("taskid"), 0);
	int coldfield_tmp = Util.getIntValue(rs1.getString("coldfield"), 0);
	if(coldfield_tmp != 0){
		codefield_hs.put("codefield_"+taskid_tmp, ""+coldfield_tmp);
	}
}

String planDate="";

String strStatus = "";

if (objId.equals("")) {
	objId=CurrentUser;
	type = "0";
	type_d = "3";
}

if(weeks.equals("")){
	weeks = currentWeek;
}
if(months.equals("")){
	months = currentMonth;
}
if(days.equals("")){
	days = currentDay;
}
if (1<=Integer.parseInt(months)&& Integer.parseInt(months)<=3){
	currentQuarter="1";
}else if (4<=Integer.parseInt(months)&& Integer.parseInt(months)<=6){
	currentQuarter="2";
}else if (7<=Integer.parseInt(months)&& Integer.parseInt(months)<=9){
	currentQuarter="3";
}else if (10<=Integer.parseInt(months)&& Integer.parseInt(months)<=12){
	currentQuarter="4";
}
if (quarters.equals("")){
	quarters = currentQuarter;
}

if (type.equals("0")){
	planDate = years;
}else if (type.equals("2")){
	planDate=years+months;
}else if (type.equals("1")){
	planDate = years+quarters;
}else if (type.equals("3")){
	planDate = years+weeks;
}else if(type.equals("4")){
	planDate = days;
}

String createPageSql = "";
Hashtable ret_hs_1 = null;
if("RequestSubmitList.jsp".equals(functionPage)){
	ret_hs_1 = wtSerachManager.getCreatePageSql();
}else if("RequestApproveList.jsp".equals(functionPage)){
	ret_hs_1 = wtSerachManager.getApprovePageSql();
}else if("RequestMonitorList.jsp".equals(functionPage)){
	ret_hs_1 = wtSerachManager.getMonitorPageSql();
}
createPageSql = (String)ret_hs_1.get("createPageSql");
ArrayList textheightList = (ArrayList)ret_hs_1.get("textheightList");
ArrayList idList = (ArrayList)ret_hs_1.get("idList");
ArrayList fieldnameList = (ArrayList)ret_hs_1.get("fieldnameList");
ArrayList crmnameList = (ArrayList)ret_hs_1.get("crmnameList");
ArrayList ismandList = (ArrayList)ret_hs_1.get("ismandList");
ArrayList fieldhtmltypeList = (ArrayList)ret_hs_1.get("fieldhtmltypeList");
ArrayList typeList = (ArrayList)ret_hs_1.get("typeList");
ArrayList iseditList = (ArrayList)ret_hs_1.get("iseditList");
ArrayList defaultvalueList = (ArrayList)ret_hs_1.get("defaultvalueList");
ArrayList defaultvaluecnList = (ArrayList)ret_hs_1.get("defaultvaluecnList");
ArrayList fieldlenList = (ArrayList)ret_hs_1.get("fieldlenList");
ArrayList widthList = (ArrayList)ret_hs_1.get("widthList");
int listCount = Util.getIntValue(((String)ret_hs_1.get("listCount")), 0);
if(wtid == 0){//页面上沿计划任务类型选择框，如果选择所有类型，则必须多加一列“任务类型”
	listCount += 1;
}
listCount += 1;

//使用自定义查询时，时间限定无作用
if("search".equals(operationType)){
	createPageSql += sqlWhere;
}else{
	String sqlDate = "";
	sqlDate = wtSerachManager.getDateSql(type, years, currentQuarter, months, weeks, days);
	createPageSql += sqlDate;
}
//System.out.println("createPageSql = " + createPageSql);

String pName1="";
pName1 = years+SystemEnv.getHtmlLabelName(445,user.getLanguage());
if(type.equals("1")){
	 pName1 += quarters+SystemEnv.getHtmlLabelName(17495,user.getLanguage());
}else if(type.equals("2")){
	pName1 += months+SystemEnv.getHtmlLabelName(6076,user.getLanguage());
}else if(type.equals("3")){
	pName1+=weeks+SystemEnv.getHtmlLabelName(1926,user.getLanguage());
}else if(type.equals("4")){
	pName1 = days.substring(0, 4)+SystemEnv.getHtmlLabelName(445,user.getLanguage())+days.substring(5, 7)+SystemEnv.getHtmlLabelName(6076,user.getLanguage())+days.substring(8, 10)+SystemEnv.getHtmlLabelName(390, user.getLanguage());
}
pName1 += (worktaskStatusName + worktaskName);
String pName = objName+pName1;
	
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<style>
#tabPane tr td{padding-top:2px}
#monthHtmlTbl td,#seasonHtmlTbl td{cursor:hand;text-align:left;padding:0 2px 0 2px;color:#333}
.cycleTD{font-family:MS Shell Dlg,Arial;background-image:url(/images/tab2_wev8.png);cursor:hand;font-weight:bold;text-align:center;color:#666;border-bottom:1px solid #879293;}
.cycleTDCurrent{font-family:MS Shell Dlg,Arial;padding-top:2px;background-image:url(/images/tab.active2_wev8.png);cursor:hand;font-weight:bold;text-align:center;color:#666}
.seasonTDCurrent,.monthTDCurrent{color:black;font-weight:bold;background-color:#CCC}
#subTab{border-bottom:1px solid #879293;padding:0}
</style>
</HEAD>
<%
String needfav ="1";
String needhelp ="";
String titlename = pName;
String imagefilename = "/images/hdHRM_wev8.gif";
%>

<BODY id="worktaskBody">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86, user.getLanguage())+",javaScript:OnSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
if("RequestSubmitList.jsp".equals(functionPage)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(15143, user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290, user.getLanguage())+",javaScript:OnComeBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<table width=100% height=95% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="1">
<col width="">
<col width="1">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=ListStyle>
<tr>
<td valign="top">
<form name="taskform" method="post" action="RequestOperation.jsp" enctype="multipart/form-data">
<input type="hidden" name="wtid" value="<%=wtid%>">
<input type="hidden" name="worktaskStatus" value="<%=worktaskStatus%>">
<input type="hidden" name="type" value=<%=type%>>
<input type="hidden" name="operationType">
<input type="hidden" name="planId">
<input type="hidden" name="importType" value="0" >
<input type="hidden" name="planDate" value=<%=planDate%>>
<input type="hidden" name="pName1" value=<%=pName1%>>
<input type="hidden" name="ishidden" value="1" >
<input type="hidden" name="years" value="<%=years%>">
<input type="hidden" name="months" value="<%=months%>">
<input type="hidden" name="quarters" value="<%=quarters%>">
<input type="hidden" name="weeks" value="<%=weeks%>">
<input type="hidden" name="days" value="<%=days%>">
<input type="hidden" id="isCreate" name="isCreate" value="0">
<input type="hidden" id="nodesnum" name="nodesnum" value="1">
<input type="hidden" id="indexnum" name="indexnum" value="1">
<input type="hidden" id="needcheck" name="needcheck" value="wtid" >
<input type="hidden" id="delids" name="delids" >
<input type="hidden" id="editids" name="isfromleft" value="<%=isfromleft%>">
<input type="hidden" id="functionPage" name="functionPage" value="<%=functionPage%>" >
<%
int totalWidth = 0;
String colStr = "";
if(wtid == 0){
	totalWidth += 80;
	colStr += "<COL width=\"80\">\n";
}
totalWidth += 80;
colStr += "<COL width=\"80\">\n";
for(int cx=0; cx<widthList.size(); cx++){
	int width = Util.getIntValue((String)widthList.get(cx), 80);
	totalWidth += width;
	colStr += "<COL width=\""+width+"\">\n";
}
%>
<div id="firstDiv" name="firstDiv" style="width:100%;overflow-x:auto;height=300px;overflow-y:auto;">
<TABLE class=ListStyle cellspacing=1 id="oTable" name="oTable" style="width:<%=totalWidth%>px;">
	<COLGROUP>
	<%=colStr%>
	<TBODY>
	<TR class=Header>
	<%
	if(wtid == 0){//计划任务类型。新增时为必选框
		out.println("<th>"+SystemEnv.getHtmlLabelName(63, user.getLanguage())+"</th>");
	}
	out.println("<th>"+SystemEnv.getHtmlLabelName(602, user.getLanguage())+"</th>");
	for(int cx=0; cx<crmnameList.size(); cx++){
		String crmname_tmp = Util.null2String((String)crmnameList.get(cx));
		out.println("<th>"+crmname_tmp+"</th>");
	}
	%>
	</TR>
	<TR class=Line><TD colspan="<%=(listCount+1)%>" ></TD></TR>
	<%
		//列表数据查询开始
		//System.out.println("createPageSql = "+createPageSql);
		String planStartDate = "";
		String planEndDate = "";
		String planDays = "";
		String needcheck = "";
		String checkor = "";
		rs2.execute(createPageSql);
		String classStr = "DataDark";
		boolean trClass = true;
		while(rs2.next()){
			int requestid_tmp = Util.getIntValue(rs2.getString("requestid"), 0);
			int taskid_tmp = Util.getIntValue(rs2.getString("taskid"), 0);
			//System.out.println("requestid_tmp = "+requestid_tmp);
			if(requestid_tmp <= 0 ){
				continue;
			}else{
				if(editids.indexOf(","+requestid_tmp+",") == -1){//控制显示的任务是前面页面所勾选的
					continue;
				}
			}
			out.println("<TR CLASS="+classStr+" onmouseover=\"browseTable_onmouseover(this)\" onmouseout=\"browseTable_onmouseout(this)\">");
			int status_tmp = Util.getIntValue(rs2.getString("status"), 1);
			//System.out.println("status = "+status);
		if(wtid == 0){//计划任务类型不可修改
			out.println("<td>"+Util.null2String((String)worktaskName_hs.get("worktaskname_"+taskid_tmp))+"</td>");
		}
		out.println("<td>"+SystemEnv.getHtmlLabelName(Util.getIntValue((String)wtsdetailLabelList.get(wtsdetailCodeList.indexOf(""+status_tmp))), user.getLanguage())+"</td>");
		for(int i=0; i<fieldnameList.size(); i++){
			int textheight_tmp = Util.getIntValue((String)textheightList.get(i), 0);
			String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));
			String value_tmp = rs2.getString(fieldname_tmp);
			int fieldid_tmp = Util.getIntValue((String)idList.get(i), 0);
			String fieldhtmltype_tmp = Util.null2String((String)fieldhtmltypeList.get(i));
			String type_tmp = Util.null2String((String)typeList.get(i));
			String fieldlen_tmp = Util.null2String((String)fieldlenList.get(i));
			String crmname_tmp = Util.null2String((String)crmnameList.get(i));
			int isedit_tmp = Util.getIntValue((String)iseditList.get(i), 0);
			int ismand_tmp = Util.getIntValue((String)ismandList.get(i), 0);
			if(ismand_tmp == 1 && !"5".equals(fieldhtmltype_tmp)){
				checkStr += (",field" + fieldid_tmp + "_" + requestid_tmp);
			}
			if("planstartdate".equalsIgnoreCase(fieldname_tmp)){
				planStartDate = "field" + fieldid_tmp + "_";
			}else if("planenddate".equalsIgnoreCase(fieldname_tmp)){
				planEndDate = "field" + fieldid_tmp + "_";
			}else if("plandays".equalsIgnoreCase(fieldname_tmp)){
				planDays = "field" + fieldid_tmp + "_";
				if("".equals(value_tmp.trim())){
					value_tmp = "0";
				}
			}else if("needcheck".equalsIgnoreCase(fieldname_tmp)){
				needcheck = "field" + fieldid_tmp + "_";
			}else if("checkor".equalsIgnoreCase(fieldname_tmp)){
				checkor = "field" + fieldid_tmp + "_";
			}
			if("16".equals(type_tmp) || "152".equals(type_tmp) || "171".equals(type_tmp)){
					if(!"".equals(value_tmp)){
						String[] tlinkwts = Util.TokenizerString2(value_tmp, ",");
						for(int dx=0; dx<tlinkwts.length; dx++){
							String tlinkwt = Util.null2o(tlinkwts[dx]);
							int tempnum = Util.getIntValue((String)(session.getAttribute("tlinkwtnum")), 0);
							tempnum++;
							session.setAttribute("retrequestid"+tempnum, tlinkwt);
							session.setAttribute("tlinkwfnum", ""+tempnum);
							session.setAttribute("haslinkworktask", "1");
							session.setAttribute("deswtrequestid"+tempnum, ""+requestid_tmp);
						}
					}
				}
			String valueStr = "";
			int codefield = Util.getIntValue((String)codefield_hs.get("codefield_"+taskid_tmp), 0);
			if(codefield != fieldid_tmp){
				valueStr = wtSerachManager.getFieldCellWithValue(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, isedit_tmp, ismand_tmp, value_tmp, requestid_tmp);
			}else{
				valueStr = value_tmp;
			}
			String input_requestid_tmp = "";
			if(i==0){//第一列，放入隐藏的input，记录requestid
				input_requestid_tmp = "<input type='hidden' name='requestid_add' value='"+requestid_tmp+"'><input type='hidden' name='taskid_"+requestid_tmp+"' value='"+taskid_tmp+"'><input type='hidden' name='checktask2' value='"+requestid_tmp+"'>";
			}
			out.print("<td>"+input_requestid_tmp+valueStr+"</td>");
		}
%>
	</TR>
<%
	if(trClass == true){
		classStr = "DataLight";
		trClass = false;
	}else{
		classStr = "DataDark";
		trClass = true;
	}
}
if(!"".equals(checkStr)){
	checkStr.substring(1);
}
%>
</TABLE>
</div>
</td>
</tr>
</TABLE>
</form>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
</BODY>
<script>
function setFirstDivHeight(){
	firstDiv.style.width = "100%";
	var bodyheight = worktaskBody.clientHeight;
	if(bodyheight > 94){
		bodyheight = bodyheight - 94;
	}
	firstDiv.style.height = bodyheight;
	firstDiv.style.width = worktaskBody.clientWidth - 15;
	var tableWidth = parseInt(oTable.style.width);
	var divWidth = parseInt(firstDiv.style.width);
	if(tableWidth < divWidth){
		oTable.style.width = worktaskBody.clientWidth - 40;
	}else if(tableWidth != <%=totalWidth%>){
		oTable.style.width = <%=totalWidth%>;
	}
}
parent.parent.onHuidden();
setFirstDivHeight();
function browseTable_onmouseover(obj){
	/*
	var e = window.event.srcElement;
	while(e.tagName != "TR"){
		e = e.parentElement;
	}
	*/
	obj.className = "Selected";
}
function browseTable_onmouseout(obj){
  /*
	var e = window.event.srcElement;
	while(e.tagName != "TR"){
		e = e.parentElement;
	}
  */	
	if(obj.rowIndex%2==0){
		obj.className = "DataDark";
	}else{
		obj.className = "DataLight";
	}
}
function OnSave(){
	document.all("needcheck").value += "<%=checkStr%>";
	//alert(document.all("needcheck").value);
	if(check_form(document.taskform, document.all("needcheck").value)){
		document.taskform.action = "RequestOperation.jsp";
		document.taskform.operationType.value="multisave";
		document.taskform.submit();
		enableAllmenu();
	}else{
		document.all("needcheck").value = "wtid";
	}
}

function OnSubmit(){
	document.all("needcheck").value += "<%=checkStr%>";
	if(check_form(document.taskform, document.all("needcheck").value)){
		document.taskform.action = "RequestOperation.jsp";
		document.taskform.operationType.value="multiSubmit";
		document.taskform.submit();
		enableAllmenu();
	}else{
		document.all("needcheck").value = "wtid";
	}
}

function OnComeBack(){
	location.href = "<%=functionPage%>?wtid=<%=wtid%>&worktaskStatus=<%=worktaskStatus%>&type=<%=type%>&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=years%>&weeks=<%=weeks%>&months=<%=months%>&quarters=<%=quarters%>&days=<%=days%>&isfromleft=<%=isfromleft%>";
}
function onShowPlanDateCompute(objinput, objspan, ismand, rowindex){
	WdatePicker_onShowPlanDateCompute(objinput, objspan, ismand, rowindex);
}
function WdatePicker_onShowPlanDateCompute(objinput, objspan, ismand, rowindex){
	WdatePicker(
	{
		el:
			objspan,
			onpicked:function(dp){
				var returnvalue = dp.cal.getDateStr();
				var oldValue = $dp.$(objinput).value;
				var oldinnerHTML = $dp.$(objspan).innerHTML;
				$dp.$(objinput).value = returnvalue;
				$dp.$(objspan).innerHTML = returnvalue;
				try{
					var planStartDate = document.getElementById("<%=planStartDate%>"+rowindex).value;
					//alert(planStartDate);
					var planEndDate = document.getElementById("<%=planEndDate%>"+rowindex).value;
					<%if(canCreateHistoryWorktask == 0){%>
						try{
							if(planStartDate!=null && planStartDate!=""){
								if(planStartDate < "<%=currentDay%>"){
									alert(document.getElementById("<%=planStartDate%>"+rowindex).temptitle + "<%=SystemEnv.getHtmlLabelName(22269, user.getLanguage())+SystemEnv.getHtmlLabelName(15625, user.getLanguage())+SystemEnv.getHtmlLabelName(22270, user.getLanguage())%>");
									$dp.$(objinput).value = oldValue;
									$dp.$(objspan).innerHTML = oldinnerHTML;
									return false;
								}
							}
						}catch(e){
						}
					<%}%>
					try{
						if(planStartDate!=null && planStartDate!="" && planEndDate!=null && planEndDate!=""){
							if(planStartDate > planEndDate){
								alert(document.getElementById("<%=planEndDate%>"+rowindex).temptitle + "<%=SystemEnv.getHtmlLabelName(22269, user.getLanguage())%>" + document.getElementById("<%=planStartDate%>"+rowindex).temptitle + "<%=SystemEnv.getHtmlLabelName(22270, user.getLanguage())%>");
								$dp.$(objinput).value = oldValue;
								$dp.$(objspan).innerHTML = oldinnerHTML;
								return false;
							}
						}
					}catch(e){
					}
					if(planStartDate != null && planStartDate != "" && planEndDate != null && planEndDate != ""){
						var days = getnumber(planStartDate, planEndDate);
						document.getElementById("<%=planDays%>"+rowindex).value = days;
						try{
							if(document.getElementById("<%=planDays%>"+rowindex).type == "hidden"){
								document.getElementById("<%=planDays%>"+rowindex+"span").innerHTML = days;
							}
						}catch(e){}
					}else{
						document.getElementById("<%=planDays%>"+rowindex).value = 0;
						try{
							if(document.getElementById("<%=planDays%>"+rowindex).type == "hidden"){
								document.getElementById("<%=planDays%>"+rowindex+"span").innerHTML = 0;
							}
						}catch(e){}
					}
				}catch(e){
					try{
						document.getElementById("<%=planDays%>"+rowindex).value = 0;
						try{
							if(document.getElementById("<%=planDays%>"+rowindex).type == "hidden"){
								document.getElementById("<%=planDays%>"+rowindex+"span").innerHTML = 0;
							}
						}catch(e){}
					}catch(e){}
				}
			},
			oncleared:function(dp){
				$dp.$(objinput).value = "";
				if(ismand == 1){
					$dp.$(objspan).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
				}else{
					$dp.$(objspan).innerHTML = "";
				}
				try{
					document.getElementById("<%=planDays%>"+rowindex).value = 0;
					try{
						if(document.getElementById("<%=planDays%>"+rowindex).type == "hidden"){
							document.getElementById("<%=planDays%>"+rowindex+"span").innerHTML = 0;
						}
					}catch(e){}
				}catch(e){}
			}
		}
	);

	//onShowFlowDate(spanname, inputname, ismand);
}
function getnumber(date1,date2){
	//默认格式为"20030303",根据自己需要改格式和方法
	var year1 =  date1.substr(0,4);
	var year2 =  date2.substr(0,4);

	var month1 = date1.substr(5,2);
	var month2 = date2.substr(5,2);

	var day1 = date1.substr(8,2);
	var day2 = date2.substr(8,2);

	temp1 = year1+"/"+month1+"/"+day1;
	temp2 = year2+"/"+month2+"/"+day2;

	var dateaa= new Date(temp1); 
	var datebb = new Date(temp2); 
	var date = datebb.getTime() - dateaa.getTime(); 
	var time = Math.floor(date / (1000 * 60 * 60 * 24)+1);
	return time;
	//alert(time);
}
</script>
</HTML>

<script language="vbs">
sub changelevel(tmpindex)
 	document.taskform.check_con(tmpindex*1).checked = true
end sub

sub onShowBrowser2(id,url,type1)
    
          if type1=8 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?projectids="&tmpids)
			elseif type1=9 then
            tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?documentids="&tmpids)
			elseif type1=1 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
			elseif type1=4 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
			elseif type1=16 then
			tmpids = document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
			else type1=7 
			tmpids =document.all("con"+id+"_value").value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
           end if
	//id1 = window.showModalDialog(url)
		if NOT isempty(id1) then
			resourceids = id1(0)
			resourcename = id1(1)
			resourceids = Mid(resourceids,2,len(resourceids))
			resourcename = Mid(resourcename,2,len(resourcename))	
			document.all("con"+id+"_valuespan").innerHtml =resourcename 
			document.all("con"+id+"_value").value=resourceids
			document.all("con"+id+"_name").value=resourcename
			else
			document.all("con"+id+"_valuespan").innerHtml = empty
			document.all("con"+id+"_value").value=""
			document.all("con"+id+"_name").value=""
		 end if
		
end sub

sub onShowBrowser(id,url)

		id1 = window.showModalDialog(url)
		if NOT isempty(id1) then
		        if id1(0)<> "" then
				document.all("con"+id+"_valuespan").innerHtml = id1(1)
				document.all("con"+id+"_value").value=id1(0)
				document.all("con"+id+"_name").value=id1(1)
			else
				document.all("con"+id+"_valuespan").innerHtml = empty
				document.all("con"+id+"_value").value=""
				document.all("con"+id+"_name").value=""
			end if
		end if
end sub

sub onShowBrowser31(id,url,linkurl,type1,ismand)

	if type1= 2 or type1 = 19 then
	    spanname = "field"+id+"span"
	    inputname = "field"+id
		if type1 = 2 then
		  onFlownoShowDate spanname,inputname,ismand
        else
	      onWorkFlowShowTime spanname,inputname,ismand
		end if
	else
		if  type1 <> 152 and type1 <> 142 and type1 <> 135 and type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>165 and type1<>166 and type1<>167 and type1<>168 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		else
            if type1=135 then
			tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?projectids="&tmpids)
			elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
			elseif type1=37 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?documentids="&tmpids)
            elseif type1=142 then
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?receiveUnitIds="&tmpids)
            elseif type1=165 or type1=166 or type1=167 or type1=168 then
            index=InStr(id,"_")
            if index>0 then
            tmpids=uescape("?isdetail=1&fieldid="& Mid(id,1,index-1)&"&resourceids="&document.all("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            else
            tmpids=uescape("?fieldid="&id&"&resourceids="&document.all("field"+id).value)
            id1 = window.showModalDialog(url&tmpids)
            end if
            else
            tmpids = document.all("field"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
            end if
		end if
		if NOT isempty(id1) then
			if  type1 = 152 or type1 = 142 or type1 = 135 or type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 or type1=166 or type1=168 or type1=170 then
				if id1(0)<> ""  and id1(0)<> "0"  then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceidss = Mid(resourceids,2,len(resourceids))
					resourceids = Mid(resourceids,2,len(resourceids))

					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_new'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_new'>"&resourcename&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					document.all("field"+id).value= resourceidss
				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if

			else
			   if  id1(0)<>""  and id1(0)<> "0"  then
                   if type1=162 then
				     ids = id1(0)
					names = id1(1)
					descs = id1(2)
					sHtml = ""
					ids = Mid(ids,2,len(ids))
					document.all("field"+id).value= ids
					names = Mid(names,2,len(names))
					descs = Mid(descs,2,len(descs))
					while InStr(ids,",") <> 0
						curid = Mid(ids,1,InStr(ids,","))
						curname = Mid(names,1,InStr(names,",")-1)
						curdesc = Mid(descs,1,InStr(descs,",")-1)
						ids = Mid(ids,InStr(ids,",")+1,Len(ids))
						names = Mid(names,InStr(names,",")+1,Len(names))
						descs = Mid(descs,InStr(descs,",")+1,Len(descs))
						sHtml = sHtml&"<a title='"&curdesc&"' >"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a title='"&descs&"'>"&names&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
				   if type1=161 then
				     name = id1(1)
					desc = id1(2)
				    document.all("field"+id).value=id1(0)
					sHtml = "<a title='"&desc&"'>"&name&"</a>&nbsp"
					document.all("field"+id+"span").innerHtml = sHtml
					exit sub
				   end if
			        if linkurl = "" then
						document.all("field"+id+"span").innerHtml = id1(1)
					else
						document.all("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&" target='_new'>"&id1(1)&"</a>"
					end if
					document.all("field"+id).value=id1(0)

				else
					if ismand=0 then
						document.all("field"+id+"span").innerHtml = empty
					else
						document.all("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.all("field"+id).value=""
				end if
			end if
		end if
	end if
	onChangeCheckor(id)
end sub

</script>
<script>
function onChangeCheckor(id){
	try{
		var ids = id.split("_");
		var fieldid = ids[0];
		var rowindex = ids[1];
		var fieldname1 = "field"+id;
		var fieldname2 = "<%=checkor%>"+rowindex;
		if(fieldname1 == fieldname2){
			if(document.getElementById("<%=checkor%>"+rowindex).value==null || document.getElementById("<%=checkor%>"+rowindex).value==""){
				document.getElementById("<%=needcheck%>"+rowindex).checked = false;
			}else{
				document.getElementById("<%=needcheck%>"+rowindex).checked = true;
			}
		}
	}catch(e){}
}

function onShowBrowser3(id,url,linkurl,type1,ismand){
	if(type1==2||type1 ==19){
	    spanname = "field"+id+"span";
	    inputname = "field"+id;
		if(type1 ==2)
		  onFlownoShowDate(spanname,inputname,ismand);
        else
	      onWorkFlowShowTime(spanname,inputname,ismand);
	}else{
		if(type1!=152 && type1 !=142 && type1 != 135 && type1 != 17 && type1 != 18 && type1!=27 && type1!=37 && type1!=56 && type1!=57 && type1!=65 && type1!=165 && type1!=166 && type1!=167 && type1!=168 && type1!=4 && type1!=167 && type1!=164 && type1!=169 && type1!=170)
		{
			id1 = window.showModalDialog(url);
		}else{
            if(type1==135){
			    tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?projectids="+tmpids)
			}else if(type1==4 || type1==167 || type1==164 || type1==169 || type1==170){
                tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?selectedids="+tmpids);
			}else if(type1==37) {
            tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?documentids="+tmpids);
            }else if (type1==142){
            tmpids = document.all("field"+id).value;
			    id1 = window.showModalDialog(url+"?receiveUnitIds="+tmpids);
            }else if( type1==165 || type1==166 || type1==167 || type1==168){
                //index=InStr(id,"_");
                index=id.indexOf("_");
	            if (index!=-1){
		            //Mid(id,1,index-1)
		            tmpids=uescape("?isdetail=1&fieldid="+substr(id,0,index-1)+"&resourceids="+document.all("field"+id).value)
		            id1 = window.showModalDialog(url+tmpids);
	            }else{
		            tmpids=uescape("?fieldid="+id+"&resourceids="+document.all("field"+id).value);
		            id1 = window.showModalDialog(url+tmpids);
	            }
            }else{
               tmpids = document.all("field"+id).value;
			   id1 = window.showModalDialog(url+"?resourceids="+tmpids);
			}
           }
		
		if(id1){
			if  (type1 == 152 || type1 == 142 || type1 == 135 || type1 == 17 || type1 == 18 || type1==27 || type1==37 || type1==56 || type1==57 || type1==65 || type1==166 || type1==168 || type1==170) 
			{
				if (id1.id!==""  && id1.id!=="0"){
					resourceids = id1.id;
					resourcename = id1.name;
					sHtml = "";
					resourceidss =resourceids.substr(1);
					resourceids = resourceids.substr(1);

					resourcename =resourcename.substr(1);
					
					ids=resourceids.split(",");
					names=resourcename.split(",");
					for(var i=0;i<ids.length;i++){
					   if(ids[i]!="")
					      sHtml = sHtml+"<a href="+linkurl+ids[i]+" target='_blank'>"+names[i]+"</a>&nbsp";
					}
					//$GetEle("field"+id+"span").innerHTML = sHtml;
					document.all("field"+id+"span").innerHTML = sHtml;
					document.all("field"+id).value= resourceidss;
				}else{
					if (ismand==0)
						document.all("field"+id+"span").innerHTML ="";
					else
						document.all("field"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>";
					document.all("field"+id).value="";
				}
			}else{
			   if  (id1.id!=""  && id1.id!="0"){
                   if (type1==162){
				     ids = id1.id;
					names = id1.name;
					descs = wuiUtil.getJsonValueByIndex(id1,2);
					sHtml = "";
					ids =ids.substr(1);
					document.all("field"+id).value= ids;
					names =names.substr(1).split(",");
					descs =descs.substr(1).split(",");
					for(var i=0;i<names.length;i++){
					   sHtml = sHtml+"<a title='"+descs[i]+"' >"+names[i]+"</a>&nbsp";
					}
					document.all("field"+id+"span").innerHTML = sHtml;
					return;
				   }
				   if (type1==161){
				     name =wuiUtil.getJsonValueByIndex(id1,1);
					 desc = wuiUtil.getJsonValueByIndex(id1,2);
				     document.all("field"+id).value=wuiUtil.getJsonValueByIndex(id1,0);
					 sHtml = "<a title='"+desc+"'>"+name+"</a>&nbsp";
					 document.all("field"+id+"span").innerHTML = sHtml;
					 return;
				   }
			        if (linkurl == "") 
						document.all("field"+id+"span").innerHTML =wuiUtil.getJsonValueByIndex(id1,1);
					else
						document.all("field"+id+"span").innerHTML = "<a href="+linkurl+id1.id+" target='_blank'>"+id1.name+"</a>";
					document.all("field"+id).value=id1.id;

				}else{
					if (ismand==0)
						document.all("field"+id+"span").innerHTML ="";
					else
						document.all("field"+id+"span").innerHTML ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					
					document.all("field"+id).value=""
				}
              }  			
		}
	 }	
	onChangeCheckor(id);
}


</script>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
