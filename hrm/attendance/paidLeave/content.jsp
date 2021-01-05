<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="weaver.hrm.attendance.domain.HrmPaidLeaveSet"%>
<%@ include file="/hrm/header.jsp"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="paidLeaveSetManager" class="weaver.hrm.attendance.manager.HrmPaidLeaveSetManager" scope="page" />
<!-- Added by wcd 2015-04-29[调休管理-调休设置] -->
<%
	if(!HrmUserVarify.checkUserRight("HrmPaidLeave:setting", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(82799,user.getLanguage());
	String isDialog = strUtil.vString(request.getParameter("isdialog"), "1");
	int subcompanyid = strUtil.parseToInt(request.getParameter("subcompanyid"), 0);
	String showname = subcompanyid > 0 ? SubCompanyComInfo.getSubCompanyname(String.valueOf(subcompanyid)) : "";
	
	HrmPaidLeaveSet bean = paidLeaveSetManager.get(paidLeaveSetManager.getMapParam("field001:"+subcompanyid));
	String id = bean == null ? "0" : String.valueOf(bean.getId());
	bean = bean == null ? new HrmPaidLeaveSet() : bean;
%>
<html>
	<head>
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript">
			var common = new MFCommon();
			jQuery(document).ready(function(){
			<%if(showname.length()>0){%>
				parent.setTabObjName('<%=showname%>')
			<%}%>
				showItem(true || "<%=bean.getField002() == 1%>" == "true");
			});
		 	function doSave(op){
				if($GetEle("field002").checked && $GetEle("field003").value == "") {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>");
					return;
				} else if($GetEle("field002").checked && Number($GetEle("field003").value) <= 0) {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21765,user.getLanguage())%>");
					return;
				}
				try{parent.disableTabBtn();}catch(e){}
				
				if(op == 0) {
					common.ajax($("#weaver").attr("action")+"?cmd=save&"+$("#weaver").serialize(), false, function(result){
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage())%>", function(){
							try{parent.enableTabBtn();}catch(e){}
						});
					});
				} else {
					window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(21669,user.getLanguage())%>",function(){
						common.ajax($("#weaver").attr("action")+"?cmd=sync&"+$("#weaver").serialize(), false, function(result){
							window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("18240,15242",user.getLanguage())%>", function(){
								try{parent.enableTabBtn();}catch(e){}
							});
						});
					}, function(){try{parent.enableTabBtn();}catch(e){}});
				}
		 	}
			
			function showItem(checked){
				if(checked) showEle("field002Item");
				else hideEle("field002Item");
			}
		</script>
	</head>
	<body>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			TopMenu topMenu = new TopMenu(out, user);
			topMenu.add(SystemEnv.getHtmlLabelName(86,user.getLanguage()), "javascript:doSave(0);");
			topMenu.add(SystemEnv.getHtmlLabelName(21671,user.getLanguage()), "javascript:doSave(1);");
			RCMenu += topMenu.getRightMenus();
			RCMenuHeight += RCMenuHeightStep * topMenu.size();
		%>	
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<%topMenu.show();%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form id="weaver" name="frmMain" action="/hrm/attendance/paidLeave/save.jsp" method="post" >
			<input type="hidden" name="id" value="<%=id%>">
			<input type="hidden" name="field001" value="<%=subcompanyid%>">
			<input type="hidden" name="field002" value="1">
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
					<wea:item attributes="{'samePair':'field002Item'}"><%=SystemEnv.getHtmlLabelName(82838,user.getLanguage())%></wea:item>
					<wea:item attributes="{'samePair':'field002Item'}">
						<wea:required id="field003Span" required='<%=String.valueOf(bean.getField003()).length() == 0%>'>
							<input class="inputstyle" type="text" maxlength="30" style="width:120px" name="field003" onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("field003");checkinput("field003","field003Span");' onchange='checkinput("field003","field003Span");' value="<%=bean.getField003() < 0 ? 365 : bean.getField003()%>">&nbsp;<%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%>
						</wea:required>
					</wea:item>
				</wea:group>
			</wea:layout>
		</form>
	</body>
</html>
