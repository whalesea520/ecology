<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="SubComanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
int modelId = Util.getIntValue(request.getParameter("modelId"), 0);
String titlename = SystemEnv.getHtmlLabelNames("33640,68",user.getLanguage()) ;//建模引擎设置
int formEngineSetid = Util.getIntValue(request.getParameter("formEngineSetid"),0);
String isEnFormModeReply = "";
RecordSet.executeSql("select * from formEngineSet where isdelete=0");
if(RecordSet.next()){
	formEngineSetid = RecordSet.getInt("id");
	isEnFormModeReply = RecordSet.getString("isEnFormModeReply");
}
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/e8Common_wev8.js"></script>
		<script type="text/javascript">
			$(function(){
	 			$("#e8_tablogo").css({"background-image":"url(/js/tabs/images/nav/mnav2_wev8.png)"});
	 		});
		</script>
	</head>
	<body>
		<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="<%=modelId%>"/>
		   <jsp:param name="navName" value="<%=titlename%>"/>
		</jsp:include>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form style="margin-top: 0px" id="frmMain" name=frmMain method=post action="/formmode/setup/formEngineSetOperation.jsp">
			<input type="hidden" id="formEngineSetid" name="formEngineSetid" value="<%=formEngineSetid%>"/>
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<input type=button class="e8_btn_top" onclick="onSubmit();" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>"></input>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<wea:layout type="4col">
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("33640,68",user.getLanguage())%>' attributes="{'itemAreaDisplay':'display'}">
					 <wea:item>
					  	<%=SystemEnv.getHtmlLabelName(82603,user.getLanguage())%>
					 </wea:item>
					 <wea:item>
				      	<input type="checkbox" id="isEnFormModeReply" name="isEnFormModeReply" value="<%=isEnFormModeReply%>" tzCheckbox="true" onClick="formCheckAll(this);" <%if(isEnFormModeReply.equals("1")){%>checked<%}%>>
				   	 </wea:item>
				</wea:group>
			</wea:layout>
		 </form>
	</body>
<script type="text/javascript">
function onSubmit(){
	frmMain.submit();
}
function formCheckAll() {
	if($G("isEnFormModeReply").checked) {
		jQuery("#isEnFormModeReply").val(1);
	}else{
		jQuery("#isEnFormModeReply").val(0);
	}
}
</script>
</HTML>
