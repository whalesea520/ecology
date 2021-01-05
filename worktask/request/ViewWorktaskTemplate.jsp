
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.worktask.worktask.*" %>

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<STYLE TYPE="text/css">
/*样式名未定义*/
.btn_RequestSubmitList {BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
}
.SectionHeader {
	FONT-WEIGHT: bold; COLOR: white; BACKGROUND-COLOR: teal
}

.vis1	{ visibility:visible } 
.vis2	{ visibility:hidden }
.vis3   { display:'' }
.vis4   { display:none }
</STYLE>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="recordSet_requestbase" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet_operator" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%
int isRefash = Util.getIntValue(request.getParameter("isRefash"), 0);
session.setAttribute("relaterequest", "new");
//权限判断，确定菜单 Start
boolean canView = false;
boolean canEdit = false;
boolean canDel = false;

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
int creater = 0;
if(requestid != 0 || operatorid != 0){
	if(requestid != 0){
		recordSet_requestbase.execute("select * from worktask_requestbase where requestid="+requestid);
		if(recordSet_requestbase.next()){
			wtid = Util.getIntValue(recordSet_requestbase.getString("taskid"), 0);
			request_status = Util.getIntValue(recordSet_requestbase.getString("status"), 0);
			creater = Util.getIntValue(recordSet_requestbase.getString("creater"), 0);
			int deleted = Util.getIntValue(recordSet_requestbase.getString("deleted"), 0);
			int istemplate_tmp = Util.getIntValue(recordSet_requestbase.getString("istemplate"), 0);
			if(deleted==1 || istemplate_tmp==0){
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
int approverequest = Util.getIntValue(recordSet_requestbase.getString("approverequest"), 0);
Hashtable checkRight_hs = wtRequestManager.checkTemplateRight(requestid, request_status, operator_optstatus, creater, checkor, approverequest);
canView = (Util.null2String((String)checkRight_hs.get("canView"))).equalsIgnoreCase("true")?true:false;
canEdit = (Util.null2String((String)checkRight_hs.get("canEdit"))).equalsIgnoreCase("true")?true:false;
canDel = (Util.null2String((String)checkRight_hs.get("canDel"))).equalsIgnoreCase("true")?true:false;

if(canView == false){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
//权限判断，确定菜单 End
Hashtable canCreateTasks_hs = wtRequestManager.getCanCreateTasks(false);

worktaskName = (String)canCreateTasks_hs.get("tasks_"+wtid);
String tasksSelectStr = (String)canCreateTasks_hs.get("tasksSelectStr");

Hashtable ret_hs_1 = wtRequestManager.getViewTemplateFieldInfo();
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
String titlename = SystemEnv.getHtmlLabelName(367, user.getLanguage())+SystemEnv.getHtmlLabelName(64, user.getLanguage())+": "+worktaskName;
String imagefilename = "/images/hdMaintenance_wev8.gif";
%>
<BODY id="taskbody">
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(canEdit==true && operatorid_in==0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(93, user.getLanguage())+",javaScript:doEdit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
if(canDel == true){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+",javaScript:OnDel(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="worktask"/>
   <jsp:param name="navName" value='<%=SystemEnv.getHtmlLabelName(33564,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(22183,user.getLanguage()) %>'/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="doEdit()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="OnDel()" type="button" jQuery1392950000546="32" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"/>
			</span>
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
<input type="hidden" id="isCreate" name="isCreate" value="0">
<input type="hidden" id="needcheck" name="needcheck" value="wtid" >
<input type="hidden" id="functionPage" name="functionPage" value="ViewWorktask.jsp" >
<input type="hidden" id="approverequest" name="approverequest" value="<%=approverequest%>" >
<input type="hidden" id="isRefash" name="isRefash" value="<%=isRefash%>" >
<input type="hidden" id="istemplate" name="istemplate" value="1" >
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
				<td  class="field"><%=SystemEnv.getHtmlLabelName(16539, user.getLanguage())+SystemEnv.getHtmlLabelName(64, user.getLanguage())%></td>
			</tr>
			<tr style="height: 1px;"><td class=Line2 colSpan=2></td></tr>
			<%
				String checkStr = "";
				String realStartDate = "";
				String realEndDate = "";
				String realDays = "";
				if(needcheck==1 && checkor!=0){
					needcheck = 1;
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
					String value_tmp = Util.null2String(recordSet_requestbase.getString(fieldname_tmp));//recordSet获取
					String fieldlen_tmp = Util.null2String((String)fieldlenList.get(i));
					int wttype = Util.getIntValue((String)wttypeList.get(i), 1);
					if(wttype != 1){
						continue;
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
			<TR style='height: 1px;'>
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
			<TR id="startTimeLine" style="height: 1px;display:<%if(remindtype == 0) {%>none<%}%>">
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<TR id="startTime2" style="display:<%if(remindtype == 0) {%>none<%}%>">
				<TD class="fieldName"><%=SystemEnv.getHtmlLabelName(18080, user.getLanguage())%></TD>
				<TD class="field">
					<%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="beforestartper"  size=5 value="<%=beforestartper%>" disabled>
					<span id="beforestarttypespan" name="beforestarttypespan"><%=startTimeType%></span>
				</TD>
			</TR>
			<TR id="startTimeLine2" style="height: 1px;display:<%if(remindtype == 0) {%>none<%}%>">
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<!--结束前提醒-->
			<TR id="endTime" style="display:'<%if(remindtype == 0) {%>none<%}%>'">
				<TD class="fieldName"><%=SystemEnv.getHtmlLabelName(785, user.getLanguage())%></TD>
				<TD class="field">
					<INPUT type="checkbox" name="beforeend" value="1" <% if(beforeend == 1) { %>checked<% } %> disabled>
						<%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%>
						<INPUT class="InputStyle" type="input" name="beforeendtime" size=5 value="<%= beforeendtime%>" disabled>
						<select name="beforeendtype" id="beforeendtype" style="display:'<%if(remindtype == 0) {%>none<%}%>'" disabled>
							<option value="0" <%if(beforeendtype == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
							<option value="1" <%if(beforeendtype == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
							<option value="2" <%if(beforeendtype == 2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
						</select>
				</TD>
			</TR>
			<TR id="endTimeLine" style="height: 1px;display:<%if(remindtype == 0) {%>none<%}%>">
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<TR id="endTime2" style="display:<%if(remindtype == 0) {%>none<%}%>">
				<TD class="fieldName"><%=SystemEnv.getHtmlLabelName(18080, user.getLanguage())%></TD>
				<TD class="field">
					<%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%>
					<INPUT class="InputStyle" type="input" name="beforeendper"  size=5 value="<%=beforeendper%>" disabled>
					<span id="beforeendtypespan" name="beforeendtypespan"><%=endTimeType%></span>
				</TD>
			</TR>
			<TR id="endTimeLine2" style="height: 1px;display:<%if(remindtype == 0) {%>none<%}%>">
				<TD class="Line2" colSpan="2"></TD>
			</TR>
			<%
				int wakemode = 0;
				String wakecreatetime = "";
				int wakefrequency = 0;
				int wakefrequencyy = 0;
				int wakecreatetype = 0;
				int waketimes = 0;
				int waketimetype = 0;
				String wakebegindate = "";
				String wakeenddate = "";
				wakemode = Util.getIntValue(recordSet_requestbase.getString("wakemode"), 9);
				wakecreatetime = Util.null2String(recordSet_requestbase.getString("wakecreatetime"));
				wakefrequency = Util.getIntValue(recordSet_requestbase.getString("wakefrequency"), 1);
				wakefrequencyy = Util.getIntValue(recordSet_requestbase.getString("wakefrequencyy"), 1);
				wakecreatetype = Util.getIntValue(recordSet_requestbase.getString("wakecreatetype"), 1);
				waketimes = Util.getIntValue(recordSet_requestbase.getString("waketimes"), 0);
				waketimetype = Util.getIntValue(recordSet_requestbase.getString("waketimetype"), 1);
				wakebegindate = Util.null2String(recordSet_requestbase.getString("wakebegindate"));
				wakeenddate = Util.null2String(recordSet_requestbase.getString("wakeenddate"));
			%>
			<TR> 
					<TD class="fieldName"><%=SystemEnv.getHtmlLabelName(18221, user.getLanguage())%></TD>
					<TD class=field> 										   
						<SELECT id="wakemode" name="wakemode" onchange="showFre(this.value)" disabled>
							<OPTION value="9" <%if(wakemode==9){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(18223,user.getLanguage())%></OPTION><!--不定期建立计划-->
							<OPTION value="3" <%if(wakemode==3){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></OPTION><!--天-->
							<OPTION value="0" <%if(wakemode==0){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></OPTION><!--周-->
							<OPTION value="1" <%if(wakemode==1){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></OPTION><!--月-->
							<OPTION value="4" <%if(wakemode==4){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18280,user.getLanguage())%></OPTION><!--季-->
							<OPTION value="2" <%if(wakemode==2){out.print("selected");}%>><%=SystemEnv.getHtmlLabelName(18222,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></OPTION><!--年-->
						</SELECT>
						<%
							String a="vis4";
							String b="vis4";
							String c="vis4";
							String d="vis4";
							String e="vis4";
							if(wakemode == 3){
								d = "vis3";
							}else if(wakemode == 0){
								a = "vis3";
							}else if(wakemode == 1){
								b = "vis3";
							}else if(wakemode == 2){
								c = "vis3";
							}else if(wakemode == 4){
								e = "vis3";
							}
						%>
						&nbsp;&nbsp;&nbsp;
						<!--================== 天 ==================-->
						<SPAN id="show_3" class="<%=d%>"  style="width:220px !important">
							<%=SystemEnv.getHtmlLabelName(539,user.getLanguage())%>
							&nbsp;
							<SELECT name="daytime" disabled  style="width:120px ">
							<%
							for(int i = 0; i < 24; i++){
								String selectStr = "";
								if(wakecreatetime.equals(Util.add0(i, 2)+":00") && wakemode==3){
									selectStr = " selected ";
								}
								out.println("<OPTION value=\""+Util.add0(i, 2)+":00\" "+selectStr+">"+Util.add0(i, 2)+":00</OPTION>");
							}
							%>
							</SELECT>
							<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
						</SPAN>
						<!--================== 周 ==================-->
						<SPAN id="show_0" class="<%=a%>" ><%=SystemEnv.getHtmlLabelName(545,user.getLanguage())%>																												
							<SELECT name="fer_0" disabled>
								<OPTION value="1" <%if(wakefrequency==1 && wakemode==0){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(16100, user.getLanguage())%></OPTION>
								<OPTION value="2" <%if(wakefrequency==2 && wakemode==0){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(16101, user.getLanguage())%></OPTION>
								<OPTION value="3" <%if(wakefrequency==3 && wakemode==0){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(16102, user.getLanguage())%></OPTION>
								<OPTION value="4" <%if(wakefrequency==4 && wakemode==0){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(16103, user.getLanguage())%></OPTION>
								<OPTION value="5" <%if(wakefrequency==5 && wakemode==0){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(16104, user.getLanguage())%></OPTION>
								<OPTION value="6" <%if(wakefrequency==6 && wakemode==0){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(16105, user.getLanguage())%></OPTION>
								<OPTION value="7" <%if(wakefrequency==7 && wakemode==0){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(16106, user.getLanguage())%></OPTION>											 				
							</SELECT>														
							&nbsp;
							<SELECT name="weektime" disabled>
							<%
							for(int i = 0; i < 24; i++){
								String selectStr = "";
								if(wakecreatetime.equals(Util.add0(i, 2)+":00") && wakemode==0){
									selectStr = " selected ";
								}
								out.println("<OPTION value=\""+Util.add0(i, 2)+":00\" "+selectStr+">"+Util.add0(i, 2)+":00</OPTION>");
							}
							%>
							</SELECT>
							<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
						</SPAN>
						<!--================== 月 ==================-->
						<SPAN id="show_1" class="<%=b%>">
							<%=SystemEnv.getHtmlLabelName(541,user.getLanguage())%>
							<SELECT name="monthtype" disabled>
								<OPTION value="0" <%if(wakecreatetype==0 && wakemode==1){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></OPTION>
								<OPTION value="1" <%if(wakecreatetype==1 && wakemode==1){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></OPTION>
							</SELECT>														
							<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>
							<SELECT name="fer_1" disabled>
							<%
								for(int i = 1; i <= 31; i++){
									String selectStr = "";
									if(wakefrequency==i && wakemode==1){
										selectStr = " selected ";
									}
									out.println("<OPTION value=\""+i+"\" "+selectStr+">"+i+"</OPTION>");
								}
							%>
							</SELECT>
							<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
							&nbsp;
							<SELECT name="monthtime" disabled>
							<%
							for(int i = 0; i < 24; i++){
								String selectStr = "";
								if(wakecreatetime.equals(Util.add0(i, 2)+":00") && wakemode==1){
									selectStr = " selected ";
								}
								out.println("<OPTION value=\""+Util.add0(i, 2)+":00\" "+selectStr+">"+Util.add0(i, 2)+":00</OPTION>");
							}
							%>
							</SELECT>
							<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
						</SPAN>
					<!--================== 季 ==================-->
						<SPAN id="show_4" class="<%=e%>">
							<%=SystemEnv.getHtmlLabelName(22266,user.getLanguage())%>
							<SELECT name="fer_4" disabled>
							<%
								for(int i = 1; i <= 3; i++){
									String selectStr = "";
									if(wakefrequency==i && wakemode==4){
										selectStr = " selected ";
									}
									out.println("<OPTION value=\""+Util.add0(i, 2)+"\" "+selectStr+">"+Util.add0(i, 2)+"</OPTION>");
								}
							%>
							</SELECT>
							<%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
							<SELECT name="seasontype" disabled>														
								<OPTION value="0" <%if(wakecreatetype==0 && wakemode==4){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></OPTION>
								<OPTION value="1" <%if(wakecreatetype==1 && wakemode==4){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></OPTION>
							</SELECT>														
							<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>
							<SELECT name="fres" disabled>
							<%
								for (int i = 1; i <= 31; i++) {
									String selectStr = "";
									if(wakefrequencyy==i && wakemode==4){
										selectStr = " selected ";
									}
									out.println("<OPTION value=\""+i+"\" "+selectStr+">"+i+"</OPTION>");
								}
							%>
							</SELECT>
							<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
							&nbsp;
							<SELECT name="seasontime" disabled>
							<%
							for(int i = 0; i < 24; i++){
								String selectStr = "";
								if(wakecreatetime.equals(Util.add0(i, 2)+":00") && wakemode==4){
									selectStr = " selected ";
								}
								out.println("<OPTION value=\""+Util.add0(i, 2)+":00\" "+selectStr+">"+Util.add0(i, 2)+":00</OPTION>");
							}
							%>
							</SELECT>
							<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
						</SPAN>
						<!--================== 年 ==================-->
						<SPAN id="show_2" class="<%=c%>"><%=SystemEnv.getHtmlLabelName(546,user.getLanguage())%>
							<SELECT name="fer_2" disabled>
							<%
								for(int i = 1; i <= 12; i++){
									String selectStr = "";
									if(wakefrequency==i && wakemode==2){
										selectStr = " selected ";
									}
									out.println("<OPTION value=\""+Util.add0(i, 2)+"\" "+selectStr+">"+Util.add0(i, 2)+"</OPTION>");
								}
							%>
							</SELECT>
							<%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%>
							<SELECT name="yeartype" disabled>														
								<OPTION value="0" <%if(wakecreatetype==0 && wakemode==2){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(18817,user.getLanguage())%></OPTION>
								<OPTION value="1" <%if(wakecreatetype==1 && wakemode==2){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(18816,user.getLanguage())%></OPTION>
							</SELECT>														
							<%=SystemEnv.getHtmlLabelName(15323,user.getLanguage())%>
							<SELECT name="frey" disabled>
							<%
								for (int i = 1; i <= 31; i++) {
									String selectStr = "";
									if(wakefrequencyy==i && wakemode==2){
										selectStr = " selected ";
									}
									out.println("<OPTION value=\""+i+"\" "+selectStr+">"+i+"</OPTION>");
								}
							%>
							</SELECT>
							<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
							&nbsp;
							<SELECT name="yeartime" disabled>
							<%
							for(int i = 0; i < 24; i++){
								String selectStr = "";
								if(wakecreatetime.equals(Util.add0(i, 2)+":00") && wakemode==2){
									selectStr = " selected ";
								}
								out.println("<OPTION value=\""+Util.add0(i, 2)+":00\" "+selectStr+">"+Util.add0(i, 2)+":00</OPTION>");
							}
							%>
							</SELECT>
							<%=SystemEnv.getHtmlLabelName(18815, user.getLanguage())%>
						</SPAN>
					</TD>
				</TR>
				<TR style='height: 1px;'><TD class="Line2" colSpan="2"></TD></TR>
				<DIV id="generateSet" name="generateSet" <%if(wakemode==9){out.print("class=\"vis4\"");}else{out.print("class=\"vis3\"");}%>>
				<TR style="display:<%if(wakemode==9){%>none<%}%>">
				
					<TD class="fieldName">
						
						
									<%=SystemEnv.getHtmlLabelName(19798,user.getLanguage())%>
					</TD>
					<TD class="field">
						<INPUT type="text" id="times" name="times" size=5 maxlength="4" class=inputStyle value="<%=waketimes%>" onKeyPress="ItemCount_KeyPress_self()" disabled>
						<SPAN id="timesSpan" name="timesSpan">
						</SPAN>
						<SELECT class="inputStyle" name="timetype" id="timetype" disabled>									            
							<OPTION value="1" <%if(waketimetype==1){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></OPTION>
							<OPTION value="2" <%if(waketimetype==2){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></OPTION>
							<OPTION value="3" <%if(waketimetype==3){out.println("selected");}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></OPTION>
						</SELECT>	
					</TD>
				</TR>
				<TR style='height: 1px;'><TD class="Line2" colSpan="2"></TD></TR>
				<!--================ 有效期  ================-->	
				<TR>          
					<TD class="fieldName">
						<%=SystemEnv.getHtmlLabelName(15030,user.getLanguage())%>
					</TD>
					<TD class="field">
						<%=SystemEnv.getHtmlLabelName(348,user.getLanguage())%>
						<SPAN id="beginDateSpan"><%=wakebegindate%></SPAN> 
						<INPUT type="hidden" name="wakebegindate" value="<%=wakebegindate%>">  
						&nbsp;&nbsp;&nbsp;
						<%=SystemEnv.getHtmlLabelName(15322,user.getLanguage())%>
						<SPAN id="endDateSpan"><%=wakeenddate%></SPAN> 
						<INPUT type="hidden" name="wakeenddate" value="<%=wakeenddate%>">
						&nbsp;&nbsp;&nbsp;
						<%=SystemEnv.getHtmlLabelName(22135,user.getLanguage())%>
					</TD>
				</TR>
							
				</DIV>


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
		location.href="/worktask/request/AddworktaskTemplate.jsp?wtid="+wtid;
	}else{
		for(i=0; i<length; i++){
			document.all("selectWorktask").options[i].selected = false;
		}
		document.all("selectWorktask").options[selectedIndex].selected = true;
	}
}

function OnSave(){
	//alert(document.all("needcheck").value);
	//if(check_form(document.taskform, document.all("needcheck").value)){
		//document.taskform.action = "RequestOperation.jsp";
		//document.taskform.operationType.value="multisave";
		//showPrompt("<%=SystemEnv.getHtmlLabelName(22060, user.getLanguage())%>");
		//document.taskform.submit();
		//enableAllmenu();
	//}
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

function doEdit(){
	location.href="/worktask/request/EditWorktaskTemplate.jsp?isRefash=<%=isRefash%>&requestid=<%=requestid%>";
}

function OnDel(){
	if(isdel()){
		document.taskform.action = "RequestOperation.jsp";
		document.taskform.operationType.value="deletetemplate";
		document.taskform.submit();
		enableAllmenu();
	}
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
    try {
        File.FilePath=objValue;
        fileLenth= File.getFileSize();
    } catch (e){
        //alert('<%=SystemEnv.getHtmlLabelName(20253,user.getLanguage())%>');
		if(e.message=="Type mismatch"||e.message=="类型不匹配"){
			alert("<%=SystemEnv.getHtmlLabelName(21015,user.getLanguage())%> ");
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21090,user.getLanguage())%> ");
		}
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
    if (fileLenthByM><%=maxUploadImageSize%>) {
        alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%><%=maxUploadImageSize%>M<%=SystemEnv.getHtmlLabelName(20256 ,user.getLanguage())%>");
        createAndRemoveObj(obj);
    }
}
  function addannexRow(accname,maxsize)
  {
    document.all(accname+'_num').value=parseInt(document.all(accname+'_num').value)+1;
    ncol = document.all(accname+'_tab').cols;
    oRow = document.all(accname+'_tab').insertRow();
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell();
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
</script>

</BODY>
</HTML>
<SCRIPT language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
