<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.meeting.MeetingServiceUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("Meeting:Service", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}

	
String id = Util.null2String(request.getParameter("id"));
String method=Util.null2String(request.getParameter("method"));
if("type".equals(method)||"item".equals(method)){
	
}else{
	response.sendRedirect("/notice/noright.jsp");
	return;
}
int  title=2155;
String name="";
String desc="";
String itemname="";
String type="";

if("type".equals(method)){
	title=2155;
	if(!"".equals(id)){
		RecordSet.execute("select * from Meeting_Service_Type where id="+id);
		if(RecordSet.next()){
			name=RecordSet.getString("name");
			desc=RecordSet.getString("desc_n");
		}
	}
}else{
	title=2157;
	if(!"".equals(id)){
		RecordSet.execute("select * from Meeting_Service_Item where id="+id);
		if(RecordSet.next()){
			type=RecordSet.getString("type");
			itemname=RecordSet.getString("itemname");
		}
	}
}
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<LINK href="/js/ecology8/meeting/meetingbase_wev8.css" type=text/css rel=STYLESHEET>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css"
			type="text/css" />
		<link rel="stylesheet"
			href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css"
			type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(780, user
				.getLanguage());
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY style="overflow: hidden;">
	<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
		RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())+ ",javascript:save(),_self} ";
		RCMenuHeight += RCMenuHeightStep;
	%>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="meeting"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(title,user.getLanguage()) %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan"
					style="text-align: right; width: 400px !important">
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="save()" />
					<span
						title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>"  class="cornerMenu middle"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv">
			<span style="width:10px"></span>
			<span id="hoverBtnSpan" class="hoverBtnSpan">  
			</span>
		</div>
		<div class="zDialog_div_content" id="editDiv" name="editDiv">
			<FORM id=weaverA name=weaverA action="MeetingServiceOperation.jsp" method=post>
				<input type="hidden" value="<%=id%>" name="id">
				<input type="hidden" value="<%="add"+method%>" name="method">
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
					<%if("type".equals(method)){ %>
						<!-- 服务类型名称 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></wea:item>
						<wea:item>
							<input class="InputStyle" name="name" id="name" style="width:250px" value="<%=name%>" size="30" onchange='checkinput("name","nameimage")'>
							<SPAN id=nameimage>
							<%if("".equals(name)) {%>
							<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
							<%} %>
							</SPAN>
						</wea:item>
						
						<!-- 服务类型描述 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(433, user.getLanguage())%></wea:item>
						<wea:item>
							<input class="InputStyle" name="desc" id="desc" style="width:250px" value="<%=desc%>" size="30" onchange='checkinput("desc","descimage")'> 
							<SPAN id=descimage>
							<%if("".equals(desc)) {%>
							<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
							<%} %>
							</SPAN>
						</wea:item>
					<%}else{%>
						<!-- 服务项目名称 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(1353, user.getLanguage())%></wea:item>
						<wea:item>
							<input class="InputStyle" name="itemname" id="itemname" style="width:250px" value="<%=itemname%>" size="30" onchange='checkinput("itemname","itemnameimage")'>
							<SPAN id=itemnameimage>
							<%if("".equals(itemname)) {%>
							<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
							<%} %>
							</SPAN>
						</wea:item>
						
						<!-- 服务项目所属类型 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="type" browserValue='<%=type%>' 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/meeting/Maint/MeetingServiceTypeBrowser.jsp" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="250px"
							completeUrl="/data.jsp?type=meetingService" linkUrl="" 
							browserSpanValue='<%=MeetingServiceUtil.getMeetingServiceTypeName(Util.getIntValue(type))%>'></brow:browser>
						</wea:item>
					<%} %>
					</wea:group>
				</wea:layout>
			</FORM>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2col">
				<wea:group context="">
					<wea:item type="toolbar">
						<input type="button"
							value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
							id="zd_btn_cancle" class="zd_btn_cancle" onclick="closeDialog()">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
	</body>
</html>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script type="text/javascript">
var parentWin;
try{
parentWin = parent.getParentWindow(window);
}catch(e){}

function preDo(){
	$("#topTitle").topMenuTitle({});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	jQuery("#hoverBtnSpan").hoverBtn();
};

var checkForm="type"=="<%=method%>"?"name,desc":"itemname,type";

function save(){
	if(!check_form(weaverA,checkForm)){
		return false;
	}
	$('#weaverA').submit();	
}

function closeDialog(){
	parentWin.closeDialog();
}

//关闭页面并刷新列表
function closeDlgARfsh(){
	parentWin.closeDlgARfsh();
}
 
jQuery(document).ready(function(){
	resizeDialog();
});
</script>
