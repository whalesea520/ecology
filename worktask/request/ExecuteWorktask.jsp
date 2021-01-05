
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
<%@page import="weaver.workflow.workflow.GetShowCondition"%>
<jsp:useBean id="recordSet_requestbase" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet_operator" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
int canCreateHistoryWorktask = Util.getIntValue(BaseBean.getPropValue("worktask", "canCreateHistoryWorktask"), 1);
session.setAttribute("relaterequest", "new");
//权限判断，确定菜单 Start
boolean canView = false;
boolean canBack = false;

int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
int requestid_in = Util.getIntValue(request.getParameter("requestid"), 0);
int operatorid_in = Util.getIntValue(request.getParameter("operatorid"), 0);//用于判断来源
int operatorid = Util.getIntValue(request.getParameter("operatorid"), 0);
String worktaskName = "";
String worktaskStatusName = "";

int wtid = 0;
int request_status = 0;
int operator_optstatus = 0;
int operator_type = 0;
if(operatorid != 0){
	int requestid_tmp = 0;
	recordSet_operator.execute("select * from worktask_operator where id="+operatorid);
	if(recordSet_operator.next()){
		requestid_tmp = Util.getIntValue(recordSet_operator.getString("requestid"), 0);
		operator_optstatus = Util.getIntValue(recordSet_operator.getString("optstatus"), 0);
		operator_type = Util.getIntValue(recordSet_operator.getString("type"), 0);
	}else{
		response.sendRedirect("/notice/noright.jsp");
	}
	if(requestid_tmp == 0){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}else{
		requestid = requestid_tmp;
		recordSet_requestbase.execute("select * from worktask_requestbase where requestid="+requestid);
		if(recordSet_requestbase.next()){
			wtid = Util.getIntValue(recordSet_requestbase.getString("taskid"), 0);
			request_status = Util.getIntValue(recordSet_requestbase.getString("status"), 0);
			int deleted = Util.getIntValue(recordSet_requestbase.getString("deleted"), 0);
			if(deleted == 1){
				response.sendRedirect("/notice/noright.jsp");
			}
		}else{
			response.sendRedirect("/notice/noright.jsp");
		}
	}
}else{
	response.sendRedirect("/notice/noright.jsp");
}
WTRequestManager wtRequestManager = new WTRequestManager(wtid);
wtRequestManager.setLanguageID(user.getLanguage());
wtRequestManager.setUserID(user.getUID());
int needcheck = Util.getIntValue(recordSet_requestbase.getString("needcheck"), 0);
int checkor = Util.getIntValue(recordSet_requestbase.getString("checkor"), 0);
if(needcheck == 0){
	checkor = 0;
}
int creater = Util.getIntValue(recordSet_requestbase.getString("creater"), 0);
int approverequest = Util.getIntValue(recordSet_requestbase.getString("approverequest"), 0);
Hashtable checkRight_hs = wtRequestManager.checkRight(requestid, request_status, operator_optstatus, creater, checkor, approverequest);
canView = (Util.null2String((String)checkRight_hs.get("canView"))).equalsIgnoreCase("true")?true:false;
canBack = (Util.null2String((String)checkRight_hs.get("canBack"))).equalsIgnoreCase("true")?true:false;

if(canView == false){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
//权限判断，确定菜单 End
int liableperson_userid = Util.getIntValue(recordSet_operator.getString("userid"), 0);
Hashtable worktaskStatus_hs = new Hashtable();
rs.execute("select * from SysPubRef where masterCode='WorkTaskStatus' and flag=1");
while(rs.next()){
	int detailCode_tmp = Util.getIntValue(rs.getString("detailCode"), 0);
	String worktaskStatusName_tmp = SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("detailLabel")), user.getLanguage());
	worktaskStatus_hs.put("worktaskstatus_"+detailCode_tmp, worktaskStatusName_tmp);
	if(request_status == detailCode_tmp){
		worktaskStatusName = worktaskStatusName_tmp;
	}
}

Hashtable canCreateTasks_hs = wtRequestManager.getCanCreateTasks(false);

worktaskName = (String)canCreateTasks_hs.get("tasks_"+wtid);
String tasksSelectStr = (String)canCreateTasks_hs.get("tasksSelectStr");

Hashtable ret_hs_1 = wtRequestManager.getViewFieldInfo();
ArrayList textheightList = (ArrayList)ret_hs_1.get("textheightList");
ArrayList idList = (ArrayList)ret_hs_1.get("idList");
ArrayList fieldnameList = (ArrayList)ret_hs_1.get("fieldnameList");
ArrayList crmnameList = (ArrayList)ret_hs_1.get("crmnameList");
ArrayList ismandList = (ArrayList)ret_hs_1.get("ismandList");
ArrayList fieldhtmltypeList = (ArrayList)ret_hs_1.get("fieldhtmltypeList");
ArrayList typeList = (ArrayList)ret_hs_1.get("typeList");
ArrayList wttypeList = (ArrayList)ret_hs_1.get("wttypeList");
ArrayList iseditList = (ArrayList)ret_hs_1.get("iseditList");
ArrayList defaultvalueList = (ArrayList)ret_hs_1.get("defaultvalueList");
ArrayList defaultvaluecnList = (ArrayList)ret_hs_1.get("defaultvaluecnList");
ArrayList fieldlenList = (ArrayList)ret_hs_1.get("fieldlenList");

int annexmaincategory = 0;
int annexsubcategory = 0;
int annexseccategory = 0;
rs.execute("select * from worktask_base where id="+wtid);
if(rs.next()){
	annexmaincategory = Util.getIntValue(rs.getString("annexmaincategory"), 0);
	annexsubcategory = Util.getIntValue(rs.getString("annexsubcategory"), 0);
	annexseccategory = Util.getIntValue(rs.getString("annexseccategory"), 0);
}
int maxUploadImageSize = 5;
maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexseccategory), 5);
if(maxUploadImageSize<=0){
	maxUploadImageSize = 5;
}
%>
<HTML><HEAD>
<title><%=Util.toScreen(worktaskName, user.getLanguage())%></title>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/css/rp_wev8.css" rel="STYLESHEET" type="text/css">
<script language=javascript src="/js/weaver_wev8.js"></script>
<script language=javascript src="/js/xmlextras_wev8.js"></script>
<script type='text/javascript' src='/dwr/interface/DocReadTagUtil.js'></script>
<script type='text/javascript' src='/dwr/engine.js'></script>
<script type='text/javascript' src='/dwr/util.js'></script>
</HEAD>
<%
String needfav ="1";
String needhelp ="";
String titlename = SystemEnv.getHtmlLabelName(1338, user.getLanguage())+": "+worktaskName;
String imagefilename = "/images/hdMaintenance_wev8.gif";

//根据浏览框id值获取具体的名称
GetShowCondition broconditions=new GetShowCondition();
 //多选按钮id
String browsermoreids=",17,18,37,257,57,65,194,240,135,152,162,166,168,170,";
%>
<BODY id="taskbody">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/cowork/uploader.jsp" %>
<%

if(canBack==true && operatorid!=0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(22002, user.getLanguage())+",javaScript:OnExecute(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
//返回按钮，返回到查看页面
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290, user.getLanguage())+",javaScript:OnComeBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="worktask"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelName(21950,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(16539,user.getLanguage()) %>'/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
		   <% if(canBack==true && operatorid!=0){ %>
			<span title="<%=SystemEnv.getHtmlLabelName(22002,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="OnExecute()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(22002,user.getLanguage()) %>"/>
			</span>
		   <%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<form name="taskform" method="post" action="ViewWorktask.jsp" enctype="multipart/form-data">
<input type="hidden" name="wtid" id="wtid" value="<%=wtid%>">
<input type="hidden" name="taskid_<%=requestid%>" id="taskid_<%=requestid%>" value="<%=wtid%>">
<input type="hidden" name="requestid" id="requestid" value="<%=requestid%>">
<input type="hidden" name="operatorid" id="operatorid" value="<%=operatorid%>">
<input type="hidden" name="operatorid_add" id="operatorid_add" value="<%=operatorid%>">
<input type="hidden" name="operationType">
<input type="hidden" name="liableperson_<%=operatorid%>" id="liableperson_<%=operatorid%>" value="<%=liableperson_userid%>">
<input type="hidden" id="isCreate" name="isCreate" value="0">
<input type="hidden" id="needcheck" name="needcheck" value="wtid" >
<input type="hidden" id="functionPage" name="functionPage" value="ViewWorktask.jsp" >
<input type="hidden" id="approverequest" name="approverequest" value="<%=approverequest%>" >
<table width=100% height=95% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
	<tr>
		<td height="10" colspan="3">
			<br>
			<div align="center">
				<font style="font-size:14pt;FONT-WEIGHT: bold"><%=worktaskName%></font>
			</div>
			<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
			</div>
			</td>
	</tr>
	<tr>
		<td></td>
		<td valign="top">
		<TABLE class="Shadow">
		<tr>
			<td valign="top">
			<!--table class="ViewForm" style="border:1px solid #FF0000"-->
			<table class="ViewForm">
			<colgroup>
			<col width="20%">
			<col width="80%">
			<tr style="height: 1px;"><td class=Line2 colSpan=2></td></tr>
			<tr>
				<td class="fieldName"><%=SystemEnv.getHtmlLabelName(18177, user.getLanguage())%></td>
				<td  class="field"><%=worktaskName%></td>
			</tr>
			<tr style="height: 1px;"><td class=Line2 colSpan=2></td></tr>
			<tr>
				<td class="fieldName"><%=SystemEnv.getHtmlLabelName(21947, user.getLanguage())%></td>
				<td  class="field"><a href="/worktask/request/ViewWorktask.jsp?requestid=<%=requestid%>"><%=worktaskStatusName%></a></td>
			</tr>
			<tr style="height: 1px;"><td class=Line2 colSpan=2></td></tr>
			<%
				if(needcheck==1 && checkor!=0){
					needcheck = 1;
				}
				String planstartdate_tmp = Util.null2String(recordSet_requestbase.getString("planstartdate"));
				String realstartdate_tmp = Util.null2String(recordSet_operator.getString("realstartdate"));
				String remindnum = "";
				if("".equals(realstartdate_tmp)){
					remindnum = wtRequestManager.computerRemindNum(planstartdate_tmp);
				}else{
					remindnum = "0";
				}
				for(int i=0; i<idList.size(); i++){
					int textheight_tmp = Util.getIntValue((String)textheightList.get(i), 0);
					int fieldid_tmp = Util.getIntValue((String)idList.get(i), 0);
					String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));
					String crmname_tmp = Util.null2String((String)crmnameList.get(i));
					String fieldhtmltype_tmp = Util.null2String((String)fieldhtmltypeList.get(i));
					String type_tmp = Util.null2String((String)typeList.get(i));
					int isedit_tmp = Util.getIntValue((String)iseditList.get(i), 0);
					int ismand_tmp = Util.getIntValue((String)ismandList.get(i), 0);
					String value_tmp = recordSet_requestbase.getString(fieldname_tmp);//recordSet获取
					String fieldlen_tmp = Util.null2String((String)fieldlenList.get(i));
					int wttype = Util.getIntValue((String)wttypeList.get(i), 1);
					if(wttype != 1){
						continue;
					}
					if("remindnum".equalsIgnoreCase(fieldname_tmp)){
						value_tmp = remindnum;
					}
					if("16".equals(type_tmp) || "152".equals(type_tmp) || "171".equals(type_tmp)){
						if("!".equals(value_tmp)){
							String[] tlinkwts = Util.TokenizerString2(value_tmp, ",");
							for(int dx=0; dx<tlinkwts.length; dx++){
								String tlinkwt = Util.null2o(tlinkwts[dx]);
								int tempnum = Util.getIntValue((String)(session.getAttribute("tlinkwtnum")), 0);
								tempnum++;
								session.setAttribute("retrequestid"+tempnum, tlinkwt);
								session.setAttribute("tlinkwfnum", ""+tempnum);
								session.setAttribute("haslinkworktask", "1");
								session.setAttribute("deswtrequestid"+tempnum, ""+requestid);
							}
						}
					}
					String sHtml = "";

					sHtml = wtRequestManager.getFieldCellWithValue(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, 0, 0, value_tmp, requestid);
					out.println("<tr><td class=\"fieldName\">"+crmname_tmp+"</td><td class=\"field\">"+sHtml+"</td></tr>");
					out.println("<tr style='height: 1px;'><td class=Line2 colSpan=2></td></tr>");
				}
				//提醒设置
				int remindtype = 0;
				int beforestart = 0;
				int beforestarttime = 0;
				int beforestarttype = 0;
				int beforestartper = 0;
				int beforeend = 0;
				int beforeendtime = 0;
				int beforeendtype = 0;
				int beforeendper = 0;
				remindtype = Util.getIntValue(recordSet_requestbase.getString("remindtype"), 0);
				beforestart = Util.getIntValue(recordSet_requestbase.getString("beforestart"), 0);
				beforestarttime = Util.getIntValue(recordSet_requestbase.getString("beforestarttime"), 0);
				beforestarttype = Util.getIntValue(recordSet_requestbase.getString("beforestarttype"), 0);
				beforestartper = Util.getIntValue(recordSet_requestbase.getString("beforestartper"), 0);
				beforeend = Util.getIntValue(recordSet_requestbase.getString("beforeend"), 0);
				beforeendtime = Util.getIntValue(recordSet_requestbase.getString("beforeendtime"), 0);
				beforeendtype = Util.getIntValue(recordSet_requestbase.getString("beforeendtype"), 0);
				beforeendper = Util.getIntValue(recordSet_requestbase.getString("beforeendper"), 0);
				String startTimeType = "";
				String endTimeType = "";
				if(beforestarttype == 0){
					startTimeType = SystemEnv.getHtmlLabelName(1925,user.getLanguage());
				}else if(beforestarttype == 1){
					startTimeType = SystemEnv.getHtmlLabelName(391,user.getLanguage());
				}else{
					startTimeType = SystemEnv.getHtmlLabelName(15049,user.getLanguage());
				}
				if(beforeendtype == 0){
					endTimeType = SystemEnv.getHtmlLabelName(1925,user.getLanguage());
				}else if(beforeendtype == 1){
					endTimeType = SystemEnv.getHtmlLabelName(391,user.getLanguage());
				}else{
					endTimeType = SystemEnv.getHtmlLabelName(15049,user.getLanguage());
				}
			%>
			<TR>
				<TD class="fieldName"><%=SystemEnv.getHtmlLabelName(18713, user.getLanguage())%></TD>
				<TD class="field">
					<INPUT type="radio" value="0" name="remindtype" id="remindtype" <%if (remindtype == 0) {%>checked<%}%> disabled><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%>
					<INPUT type="radio" value="1" name="remindtype" id="remindtype" <%if (remindtype == 1) {%>checked<%}%> disabled><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%>
					<INPUT type="radio" value="2" name="remindtype" id="remindtype" <%if (remindtype == 2) {%>checked<%}%> disabled><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%>
				</TD>
			</TR>
			<TR style="height: 1px;">
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<!--开始前提醒-->
			<TR id="startTime" style="display:'<%if(remindtype == 0) {%>none<%}%>'">
				<TD class="fieldName"><%=SystemEnv.getHtmlLabelName(785, user.getLanguage())%></TD>
				<TD class="field">
					<INPUT type="checkbox" name="beforestart" value="1" <% if(beforestart == 1) { %>checked<% } %> disabled>
						<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
						<INPUT class="InputStyle" type="input" name="beforestarttime" size=5 value="<%= beforestarttime%>" disabled>
						<select name="beforestarttype" id="beforestarttype" style="display:'<%if(remindtype == 0) {%>none<%}%>'" disabled>
							<option value="0" <%if(beforestarttype == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
							<option value="1" <%if(beforestarttype == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
							<option value="2" <%if(beforestarttype == 2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
						</select>
				</TD>
			</TR>
			<TR id="startTimeLine" style="display:'<%if(remindtype == 0) {%>none<%}%>';height:1px;">
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<TR id="startTime2" style="display:'<%if(remindtype == 0) {%>none<%}%>'">
				<TD class="fieldName"><%=SystemEnv.getHtmlLabelName(18080, user.getLanguage())%></TD>
				<TD class="field">
					<%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="beforestartper"  size=5 value="<%=beforestartper%>" disabled>
					<span id="beforestarttypespan" name="beforestarttypespan"><%=startTimeType%></span>
				</TD>
			</TR>
			<TR id="startTimeLine2" style="display:'<%if(remindtype == 0) {%>none<%}%>';height:1px;">
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<!--结束前提醒-->
			<TR id="endTime" style="display:'<%if(remindtype == 0) {%>none<%}%>'">
				<TD class="fieldName"><%=SystemEnv.getHtmlLabelName(785, user.getLanguage())%></TD>
				<TD class="field">
					<INPUT type="checkbox" name="beforeend" value="1" <% if(beforeend == 1) { %>checked<% } %> disabled>
						<%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%>
						<INPUT class="InputStyle" type="input" name="beforeendtime" size=5 value="<%= beforeendtime%>" disabled>
						<select name="beforeendtype" id="beforeendtype" style="display:'<%if(remindtype == 0) {%>none<%}%>'" disabled>
							<option value="0" <%if(beforeendtype == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
							<option value="1" <%if(beforeendtype == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
							<option value="2" <%if(beforeendtype == 2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
						</select>
				</TD>
			</TR>
			<TR id="endTimeLine" style="display:'<%if(remindtype == 0) {%>none<%}%>';height:1px;">
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<TR id="endTime2" style="display:'<%if(remindtype == 0) {%>none<%}%>'">
				<TD class="fieldName"><%=SystemEnv.getHtmlLabelName(18080, user.getLanguage())%></TD>
				<TD class="field">
					<%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="beforeendper"  size=5 value="<%=beforeendper%>" disabled>
					<span id="beforeendtypespan" name="beforeendtypespan"><%=endTimeType%></span>
				</TD>
			</TR>
			<TR id="endTimeLine2" style="display:'<%if(remindtype == 0) {%>none<%}%>';height:1px;">
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<%
				//System.out.println("request_status = " + request_status);
				//System.out.println("operatorid = " + operatorid);
				//完成情况 Start
				String checkStr1 = "";
				String checkStr2 = "";
				String createstatus = "";
				String realStartDate = "";
				String realEndDate = "";
				String realDays = "";
				if(request_status >= 6 && operatorid != 0){//只有 未开始、进行中、已超期、待验证、已完成 任务才显示完成情况
					out.println("<TR><TD colspan=\"2\"><table class=\"ListStyle\"><tr class=\"header\"><td nowrap align=\"center\">"+SystemEnv.getHtmlLabelName(22069, user.getLanguage())+"</td></tr></table></TD></TR>");
					out.println("<tr style='height: 1px;'><td class=Line2 colSpan=2></td></tr>");
					for(int i=0; i<idList.size(); i++){
						int textheight_tmp = Util.getIntValue((String)textheightList.get(i), 0);
						int fieldid_tmp = Util.getIntValue((String)idList.get(i), 0);
						String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));
						String crmname_tmp = Util.null2String((String)crmnameList.get(i));
						String fieldhtmltype_tmp = Util.null2String((String)fieldhtmltypeList.get(i));
						String type_tmp = Util.null2String((String)typeList.get(i));
						int isedit_tmp = Util.getIntValue((String)iseditList.get(i), 0);
						int ismand_tmp = Util.getIntValue((String)ismandList.get(i), 0);
						String value_tmp = recordSet_operator.getString(fieldname_tmp);
						String fieldlen_tmp = Util.null2String((String)fieldlenList.get(i));
						int wttype = Util.getIntValue((String)wttypeList.get(i), 1);
						if(wttype != 2){
							continue;
						}
						if(liableperson_userid!=user.getUID() && ("realstartdate".equalsIgnoreCase(fieldname_tmp) || "realenddate".equalsIgnoreCase(fieldname_tmp) || "realdays".equalsIgnoreCase(fieldname_tmp) || "createstatus".equalsIgnoreCase(fieldname_tmp))){
							continue;
						}
						if(!"realstartdate".equalsIgnoreCase(fieldname_tmp) && !"realstarttime".equalsIgnoreCase(fieldname_tmp)){
							value_tmp = "";
						}
						if(ismand_tmp == 1 && !"4".equals(fieldhtmltype_tmp)){
							if("createstatus".equalsIgnoreCase(fieldname_tmp)){
								createstatus = "field" + fieldid_tmp + "_"+operatorid;
							}else if("realenddate".equalsIgnoreCase(fieldname_tmp)){
								checkStr2 = "field" + fieldid_tmp + "_"+operatorid;
							}else{
								checkStr1 += (",field" + fieldid_tmp + "_"+operatorid);
							}
						}
						if("realstartdate".equalsIgnoreCase(fieldname_tmp)){
							realStartDate = "field" + fieldid_tmp + "_"+operatorid;
						}else if("realenddate".equalsIgnoreCase(fieldname_tmp)){
							realEndDate = "field" + fieldid_tmp + "_"+operatorid;
						}else if("realdays".equalsIgnoreCase(fieldname_tmp)){
							realDays = "field" + fieldid_tmp + "_"+operatorid;
							if("".equals(value_tmp.trim())){
								value_tmp = "0";
							}
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
									session.setAttribute("deswtrequestid"+tempnum, ""+requestid);
								}
							}
						}
						String sHtml = "";
						
						int fieldtype = Util.getIntValue(type_tmp);
						
						//判断 浏览框 是否 多选
						String isSingle = browsermoreids.indexOf(","+fieldtype+",")>-1?"false":"true";
						
						if(!"3".equals(fieldhtmltype_tmp) || ("3".equals(fieldhtmltype_tmp) && (fieldtype==2 || fieldtype==19))){//非浏览框,除日期浏览框
							sHtml = wtRequestManager.getFieldCellWithValueExecute(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, 
									fieldhtmltype_tmp, type_tmp, isedit_tmp, ismand_tmp, value_tmp, operatorid);
						}

						//sHtml = wtRequestManager.getFieldCellWithValueExecute(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, isedit_tmp, ismand_tmp, value_tmp, operatorid);
						//out.println("<tr><td class=\"fieldName\">"+crmname_tmp+"</td><td class=\"field\">"+sHtml+"</td></tr>");
						//out.println("<tr style='height: 1px;'><td class=Line2 colSpan=2></td></tr>");
		   %>
		               
		               
		           <% if(!"3".equals(fieldhtmltype_tmp)  || ("3".equals(fieldhtmltype_tmp) && (fieldtype==2 || fieldtype==19))){//非浏览框 %>
			           <tr><td class=fieldName><%=crmname_tmp %></td><td class="field"><%=sHtml %></td></tr>
		               <tr style='height: 1px;'><td class=Line2 colSpan=2></td></tr>
			       <%}else{//浏览框 %>
			           <tr>
			               <td class=fieldName><%=crmname_tmp %></td>
				           <td class="field">
				               <%
				                String url=BrowserComInfo.getBrowserurl(""+fieldtype);     // 浏览按钮弹出页面的url
								String linkurl=BrowserComInfo.getLinkurl(""+fieldtype);    // 浏览值点击的时候链接的url
							   %>
								<%if(fieldtype==2 || fieldtype==19){// 这部分已无用%>
									<input type="hidden" name="field<%=fieldid_tmp%>_<%=requestid%>" value="<%=value_tmp%>" >
									<button class=Calendar type="button"   
									<%if(fieldtype==2){%>
									 onclick="onSearchWFDate(defaultvaluespan_<%=fieldid_tmp%>, field<%=fieldid_tmp%>_<%=requestid%>)"
									<%}else{%>
									 onclick ="onSearchWFTime(defaultvaluespan_<%=fieldid_tmp%>, field<%=fieldid_tmp%>_<%=requestid%>)"
									<%}%>
									 ></button>
									 <span name="defaultvaluespan_<%=fieldid_tmp%>" id="defaultvaluespan_<%=fieldid_tmp%>"><%=value_tmp%></span>
								<%}else if("liableperson".equalsIgnoreCase(fieldname_tmp) && "17".equals(fieldtype)){
									out.println(SystemEnv.getHtmlLabelName(21691, user.getLanguage()));
									out.print("<input type=\"hidden\" id=\"field"+fieldid_tmp+"_"+requestid+"\" name=\"field"+fieldid_tmp+"_"+requestid+"\" value=\"\" >");
									out.print("<input type=\"hidden\" id=\"field"+fieldid_tmp+"_"+requestid+"span\" name=\"field"+fieldid_tmp+"_"+requestid+"span\" value=\"\" />");
								}else if(fieldtype==161 || fieldtype==162){%>
			                        <brow:browser viewType="0" name='<%="field"+fieldid_tmp+"_"+requestid+""%>'
										browserUrl='<%=url+"?type="+fieldlen_tmp%>'
										hasInput="false" isSingle='<%=isSingle %>' hasBrowser = "true" isMustInput='1'
										completeUrl='<%="/data.jsp?type="+fieldtype %>'   browserValue='<%=value_tmp%>' browserSpanValue='<%=broconditions.getShowCN("3", fieldtype+"", value_tmp, "1",fieldlen_tmp) %>' width="260px">
							       </brow:browser> 	
		                        <%}else{%>
									 <brow:browser viewType="0" name='<%="field"+fieldid_tmp+"_"+requestid+""%>'
									browserUrl='<%=url%>'
									hasInput="true" isSingle='<%=isSingle %>' hasBrowser = "true" isMustInput='1'
									completeUrl='<%="/data.jsp?type="+fieldtype %>' browserValue='<%=value_tmp%>' browserSpanValue='<%=broconditions.getShowCN("3", fieldtype+"", value_tmp, "1") %>'   width="260px">
						      			 </brow:browser> 	
								<%}%>
				          </td>
				       </tr>
			       <%} %>
		   <%
					}
					//完成情况 End
				}
			%>
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
</form>
<script language="javascript">
function doChangeWorktask(obj){
	var selectedIndex = 0;
	var i = 0;
	var length = document.all("selectWorktask").options.length;
	for(i=0; i<length; i++){
		if("<%=wtid%>" == document.all("selectWorktask").options[i].value){
			selectedIndex = i;
		}
	}
	if(confirm("<%=SystemEnv.getHtmlLabelName(18691, user.getLanguage())%>")){
		var wtid = obj.value;
		location.href="/worktask/request/Addworktask.jsp?wtid="+wtid;
	}else{
		for(i=0; i<length; i++){
			document.all("selectWorktask").options[i].selected = false;
		}
		document.all("selectWorktask").options[selectedIndex].selected = true;
	}
}

function showPrompt(content){
     var showTableDiv  = document.getElementById('_xTable');
     var message_table_Div = document.createElement("<div>")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = document.getElementById("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_table_Div.style.position="absolute"
     message_table_Div.style.posTop=pTop;
     message_table_Div.style.posLeft=pLeft;

     message_table_Div.style.zIndex=1002;
     var oIframe = document.createElement('iframe');
     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
     oIframe.style.width = parseInt(message_table_Div.offsetWidth);
     oIframe.style.height = parseInt(message_table_Div.offsetHeight);
     oIframe.style.display = 'block';
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
<script language="vbs">
sub onShowBrowser3(id,url,linkurl,type1,ismand)

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
end sub
</script>
<script language="javascript">
function onShowRealDateCompute(inputname, spanname, ismand){
	WdatePicker_onShowRealDateCompute(inputname, spanname, ismand);
}
function WdatePicker_onShowRealDateCompute(objinput, objspan, ismand){
	var returnvalue;
	var oncleaingFun = function(){
		$dp.$(objinput).value = "";
		try{
			if(objinput.name==("<%=realStartDate%>")){
				$dp.$(objspan).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			}else{
				var createstatus = document.getElementById("<%=createstatus%>").value;
				if(createstatus==0 || createstatus=='0'){
					$dp.$(objspan).innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
				}else{
					$dp.$(objspan).innerHTML = "";
				}
			}
		}catch(e){}
		try{
			document.getElementById("<%=realDays%>").value = 0;
			try{
				document.getElementById("<%=realDays%>span").innerHTML = "";
			}catch(e){}
			try{
				if(document.getElementById("<%=realDays%>").type == "hidden"){
					document.getElementById("<%=realDays%>span").innerHTML = 0;
				}
			}catch(e){}
		}catch(e){}
	  }
	 WdatePicker({el:objspan,onpicked:function(dp){
		var returnvalue = dp.cal.getDateStr();
		var oldValue = $dp.$(objinput).value;
		var oldinnerHTML = $dp.$(objspan).innerHTML;
		$dp.$(objinput).value = returnvalue;
		$dp.$(objspan).innerHTML = returnvalue;
		try{
			var realStartDate = document.getElementById("<%=realStartDate%>").value;
			//alert(realStartDate);
			var realEndDate = document.getElementById("<%=realEndDate%>").value;
			try{
				if(realStartDate!=null && realStartDate!="" && realEndDate!=null && realEndDate!=""){
					if(realStartDate > realEndDate){
						Dialog.alert(jQuery("#<%=realEndDate%>").attr("temptitle") + "<%=SystemEnv.getHtmlLabelName(22269, user.getLanguage())%>" + jQuery("#<%=realStartDate%>").attr("temptitle") + "<%=SystemEnv.getHtmlLabelName(22270, user.getLanguage())%>");
						$dp.$(objinput).value = "";
						$dp.$(objspan).innerHTML = "";
						return false;
					}
				}
			}catch(e){
			}
			if(realStartDate != null && realStartDate != "" && realEndDate != null && realEndDate != ""){
				var days = getnumber(realStartDate, realEndDate);
				document.getElementById("<%=realDays%>").value = days;
				try{
					document.getElementById("<%=realDays%>span").innerHTML = "";
				}catch(e){}
				try{
					if(document.getElementById("<%=realDays%>").type == "hidden"){
						document.getElementById("<%=realDays%>span").innerHTML = days;
					}
				}catch(e){}
			}else{
				document.getElementById("<%=realDays%>").value = 0;
				try{
					document.getElementById("<%=realDays%>span").innerHTML = "";
				}catch(e){}
				try{
					if(document.getElementById("<%=realDays%>").type == "hidden"){
						document.getElementById("<%=realDays%>span").innerHTML = 0;
					}
				}catch(e){}
			}
		}catch(e){
			try{
				document.getElementById("<%=realDays%>").value = 0;
				try{
					document.getElementById("<%=realDays%>span").innerHTML = "";
				}catch(e){}
				try{
					if(document.getElementById("<%=realDays%>").type == "hidden"){
						document.getElementById("<%=realDays%>span").innerHTML = 0;
					}
				}catch(e){}
			}catch(e){}
		}
	},oncleared:oncleaingFun});

	//onShowFlowDate(spanname, inputname, ismand);
}
function changeEndDate(obj, operatorid){
	try{
		var realenddate = document.getElementById("<%=realEndDate%>span");
		if(obj.value == '0'){
			realenddate.innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
		}else{
			realenddate.innerHTML = "";
		}
	}catch(e){}
}

function ItemCount_KeyPress_self(){
	if(!((window.event.keyCode>=48) && (window.event.keyCode<=57))){
		window.event.keyCode=0;
	}
}
function displaydiv_1(){
	try{
		if(worktasklogDiv.style.display == ""){
			worktasklogDiv.style.display = "none";
			worktaskbacklogspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>";
		}else{
			worktasklogDiv.style.display = "";
			worktaskbacklogspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></span>";
		}
	}catch(e){}
}

function OnExecute(){
	//location.href="/worktask/request/ExecuteWorktask.jsp?operatorid=<%=operatorid%>";
	if(check_form_self()){
		document.taskform.action = "RequestOperation.jsp";
		document.taskform.operationType.value="Execute";
		//document.taskform.submit();
		doUpload();
		enableAllmenu();
	}
}
function doUpload(){
	jQuery(".uploadfield").each(function(){
		var oUploader=window[jQuery(this).attr("oUploaderIndex")];
		if(oUploader.getStats().files_queued != 0){ //判断是否需要上传
	     	 oUploader.startUpload(); 
	    }
	});
	doSaveAfterAccUpload();
}
function afterChooseFile(uploaddiv,totalnumFiles){
	var ismand=jQuery(uploaddiv).attr("ismand");
	var field=jQuery(uploaddiv).attr("field");
	if(ismand=="1"){
	   if(totalnumFiles>0)
	      jQuery("#field"+field+"span").html("");
	   else
	      jQuery("#field"+field+"span").html("<IMG align=absMiddle src='/images/BacoError_wev8.gif'>");   
	}
}


function doSaveAfterAccUpload(){
	var isuploaded=true;
	jQuery(".uploadfield").each(function(){
		var oUploader=window[jQuery(this).attr("oUploaderIndex")];
		if(oUploader.getStats().files_queued != 0){ //判断上传是否完成
	     	 isuploaded=false; 
	    }
	});
	if(isuploaded){
		document.taskform.submit();
	}
}


function check_form_self(){
	//check_form(document.taskform, document.all("needcheck").value);
	var flag = true;
	try{

		var checkStr1 = "<%=createstatus%>";
		var checkStr2 = "<%=checkStr2%>";
		var checkStr3 = document.getElementById("needcheck").value + "<%=checkStr1%>";
		if(checkStr3 == null || checkStr3 == ""){
			flag = true;
		}else{
			flag = check_form(document.taskform, checkStr3);
		}
		if(flag == false){
			return flag;
		}
		var createstatus = "1";
		try{
			createstatus = document.getElementById(checkStr1).value;
		}catch(e){}
		if(createstatus == '0'){
			flag = check_form(document.taskform, checkStr2);
		}
		if(flag == false){
			return flag;
		}

	}catch(e){}
	return flag;
}

function OnComeBack(){
	location.href="/worktask/request/ViewWorktask.jsp?operatorid=<%=operatorid%>";
}
//附件相关JS Start
function openDocExt(showid,versionid,docImagefileid,isedit){
	taskbody.onbeforeunload=null;
    
	if(isedit==1){
		openFullWindowHaveBar("/docs/docs/DocEditExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&operatorid=<%=operatorid%>&fromworktask=1");
	}else{
		openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&operatorid=<%=operatorid%>&fromworktask=1");
	}
}

function openAccessory(fileId){ 
	taskbody.onbeforeunload=null;
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&requestid=<%=requestid%>&operatorid=<%=operatorid%>&fromworktask=1");
}
function accesoryChanage(obj){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    /*try {
        File.FilePath=objValue;  
        fileLenth= File.getFileSize();  
    } catch (e){
        alert("用于检查文件上传大小的控件没有安装，请检查IE设置，或与管理员联系！");
        createAndRemoveObj(obj);
        return  ;
    }*/
    var fileLenth=-1;
    try {
    	File.FilePath=objValue;   
        fileLenth= File.getFileSize();
    } catch (e){
        try{
            fileLenth=parseInt(obj.files[0].size);
        }catch (e) {
			alert("<%=SystemEnv.getHtmlLabelName(31567,user.getLanguage()) %>");
			createAndRemoveObj(obj)
			return;
		}
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    //var fileLenthByM = fileLenth/(1024*1024) 
	var fileLenthByK =  fileLenth/1024;
	var fileLenthByM =  fileLenthByK/1024;

	var fileLenthName;
	if(fileLenthByM>=0.1){
		fileLenthName=fileLenthByM.toFixed(1)+"M";
	}else if(fileLenthByK>=0.1){
		fileLenthName=fileLenthByK.toFixed(1)+"K";
	}else{
		fileLenthName=fileLenth+"B";
	}
    if (fileLenthByM><%=maxUploadImageSize%>) {
        //alert("所传附件为:"+fileLenthByM+"M,此目录下不能上传超过<%=maxUploadImageSize%>M的文件,如果需要传送大文件,请与管理员联系!");
        alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthName+",<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%><%=maxUploadImageSize%>M<%=SystemEnv.getHtmlLabelName(20256,user.getLanguage())%>");		
        createAndRemoveObj(obj);
    }
}
  function addannexRow(accname,maxsize)
  {
    document.all(accname+'_num').value=parseInt(document.all(accname+'_num').value)+1;
    ncol = document.all(accname+'_tab').cols;
    ncol=2;
    oRow = document.all(accname+'_tab').insertRow(-1);
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1);
      oCell.style.height=24;
      switch(j) {
        case 1:
          var oDiv = document.createElement("div");
          var sHtml = "";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
        case 0:
          var oDiv = document.createElement("div");
          <%----- Modified by xwj for td3323 20051209  ------%>
          var sHtml = "<input class=InputStyle  type=file size=60 name='"+accname+"_"+document.all(accname+'_num').value+"' onchange='accesoryChanage(this)'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
}
function createAndRemoveObj(obj){
    objName = obj.name;
    tempObjonchange=obj.onchange;
    outerHTML="<input name="+objName+" class=InputStyle type=file size=60 >";  
    document.getElementById(objName).outerHTML=outerHTML;       
    document.getElementById(objName).onchange=tempObjonchange;
}
function addDocReadTag(docId) {
	//user.getLogintype() 当前用户类型  1: 类别用户  2:外部用户
	DocReadTagUtil.addDocReadTag(docId,<%=user.getUID()%>,<%=user.getLogintype()%>,"<%=request.getRemoteAddr()%>",returnTrue);

}
function openDocExt(showid,versionid,docImagefileid,isedit){
	taskbody.onbeforeunload=null;

	if(isedit==1){
		openFullWindowHaveBar("/docs/docs/DocEditExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&operatorid=<%=operatorid%>&fromworktask=1");
	}else{
		openFullWindowHaveBar("/docs/docs/DocDspExt.jsp?id="+showid+"&imagefileId="+docImagefileid+"&isFromAccessory=true&isrequest=1&requestid=<%=requestid%>&operatorid=<%=operatorid%>&fromworktask=1");
	}
}

function openAccessory(fileId){
	taskbody.onbeforeunload=null;
	openFullWindowHaveBar("/weaver/weaver.file.FileDownload?fileid="+fileId+"&requestid=<%=requestid%>&operatorid=<%=operatorid%>&fromworktask=1");
}
function returnTrue(o){
	return;
}
function downloads(files){
	taskbody.onbeforeunload=null;
	document.location.href="/weaver/weaver.file.FileDownload?fileid="+files+"&download=1";
}
 function onChangeSharetype(delspan,delid,ismand,maxUploadImageSize){
	fieldid=delid.substr(0,delid.indexOf("_"));
	fieldidnum=fieldid+"_idnum_1";
	fieldidspan=fieldid+"span";
	fieldidspans=fieldid+"spans";
	fieldid=fieldid+"_1";
	 var sHtml = "<input class=InputStyle  type=file size=50 name="+fieldid+" onchange='accesoryChanage(this,"+maxUploadImageSize+")'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
	 var sHtml1 = "<input class=InputStyle  type=file size=50 name="+fieldid+" onchange=\"accesoryChanage(this,"+maxUploadImageSize+");checkinput(\'"+fieldid+"\',\'"+fieldidspan+"\')\"> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";

    if(document.all(delspan).style.visibility=='visible'){
      document.all(delspan).style.visibility='hidden';
      document.all(delid).value='0';
	  document.all(fieldidnum).value=parseInt(document.all(fieldidnum).value)+1;
    }else{
      document.all(delspan).style.visibility='visible';
      document.all(delid).value='1';
	  document.all(fieldidnum).value=parseInt(document.all(fieldidnum).value)-1;
    }
	//alert(document.all(fieldidnum).value);
	if (ismand=="1")
	  {
	if (document.all(fieldidnum).value=="0")
	  {
	    document.all("needcheck").value=document.all("needcheck").value+","+fieldid;
		document.all(fieldidspan).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";

		document.all(fieldidspans).innerHTML=sHtml1;
	  }
	  else
	  {   if (document.all("needcheck").value.indexOf(","+fieldid)>0)
		  {
	     document.all("needcheck").value=document.all("needcheck").value.substr(0,document.all("needcheck").value.indexOf(","+fieldid));
		 document.all(fieldidspan).innerHTML="";
		 document.all(fieldidspans).innerHTML=sHtml;
		  }
	  }
	  }
  }
  //附件相关JS End
    jQuery(document).ready(function(){
	jQuery(".uploadfield").each(function(){
		var fieldid=jQuery(this).attr("field");
		bindUploaderDiv(jQuery(this),"field"+fieldid+"_1"); 
	});
	jQuery(".progressCancel").live("click",function(){
		var uploaddiv=jQuery(this).parents(".uploadfield");
		var totalnumFiles=window[uploaddiv.attr("oUploaderIndex")].getStats().files_queued;
		afterChooseFile(uploaddiv,totalnumFiles);
	});
	jQuery(".btnCancel_upload").live("click",function(){
		var uploaddiv=jQuery(this).parents(".uploadfield");
		var totalnumFiles=window[uploaddiv.attr("oUploaderIndex")].getStats().files_queued;
		afterChooseFile(uploaddiv,totalnumFiles);
	});
});  
  
  
  
</script>

</BODY>
</HTML>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
