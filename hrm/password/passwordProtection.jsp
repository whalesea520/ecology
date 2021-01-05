
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- Added by wcd 2014-11-19 [密保设置] -->
<%@ page import="weaver.hrm.passwordprotection.domain.*,weaver.hrm.passwordprotection.manager.*,weaver.hrm.common.*" %>
<%@ include file="/hrm/header.jsp" %>
<%
	String id = String.valueOf(user.getUID());
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(81604,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	boolean allowShow = user.isAdmin() ? true : AjaxManager.getData(id, "getAccountType;0").equals("0");
	if(!allowShow) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	
	Map map = new HashMap();
	map.put("userId", id);
	HrmPasswordProtectionSet bean = new HrmPasswordProtectionSetManager().get(map);
	boolean isEnabled = bean == null ? false : bean.getEnabled() == 1;
	boolean showEdit = new HrmPasswordProtectionQuestionManager().find(map).size() > 0;
%>
<HTML>
	<HEAD>
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/mfcommon_wev8.css" />
		<link type="text/css" rel="stylesheet" href="/js/checkbox/jquery.tzCheckbox_wev8.css" />
		<script language="javascript" src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
		<script language="javascript" type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script language="javascript">
			var common = new MFCommon();
			var dialog;
			
			function changeValue(checked, cShow){
				common.ajax("cmd=ppset&id=<%=id%>&checked="+checked);
				if(cShow){
					showVerifyPswd(checked, true);
				}
				if(checked == false) {
					$GetEle("upBtn").style.display = "none";
				} else {
					$GetEle("upBtn").style.display = "<%=showEdit%>" == "true" ? "" : "none";
				}
			}
			
			function closeDialog(){
				if(dialog) dialog.close();
			}
			
			function close(pStep, checked){
				closeDialog();
				if(pStep && pStep == 3){
					window.location.reload();
				} else if(!pStep || pStep == -1){
					changeSwitchStatus($GetEle("enabled"),checked == "true" ? false : true);
					changeValue(checked == "true" ? false : true, false);
				}
			}
			
			function showVerifyPswd(checked, isShow){
				common.initDialog({width:380,height:140,showMax:false,showClose:false,normalDialog:false});
				dialog = common.showDialog("/hrm/password/verifyPswd.jsp?checked="+checked+"&isShow="+isShow,"<%=SystemEnv.getHtmlLabelName(81607,user.getLanguage())%>");
			}
			
			function showQuestion(cmd, checked, arg0){
				if(cmd && cmd == "close"){
					closeDialog();
				}
				if(checked == "true" || arg0 == "false"){
					common.initDialog({width:800,height:480,showMax:false});
					dialog = common.showDialog("/hrm/HrmDialogTab.jsp?_fromURL=questionSetStep","<%=SystemEnv.getHtmlLabelNames("81605,68",user.getLanguage())%>");
				}
			}
			
			function doUpdate(){
				showVerifyPswd("true", false);
			}
		</script>
	</HEAD>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<form id="weaver" name="frmMain" action="" method="post">
			<wea:layout type="2col" attributes="{'expandAllGroup':'true'}">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				  	<wea:item><%=SystemEnv.getHtmlLabelName(81605,user.getLanguage())%></wea:item>
				  	<wea:item>
				  		<input type="checkbox" tzCheckbox="true" class="InputStyle" name="enabled" value="1" onclick="changeValue(this.checked, true);" <% if(isEnabled) {%>checked<%}%> >
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(103,user.getLanguage())%>" name="upBtn" class="e8_btn_top" onclick="doUpdate()" style="margin-left:10px;display:<%=showEdit ? (isEnabled ? "" : "none") : "none"%>">
					</wea:item>
				</wea:group>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%>'>
				  	<wea:item attributes="{'isTableList':'true','colspan':'full'}">
					<div class="item_margin"><%=SystemEnv.getHtmlLabelName(81606,user.getLanguage())%></div>
					</wea:item>
				</wea:group>
			</wea:layout>
			<input class="inputstyle" type="hidden" name="id" value="<%=id%>">
		</form>
	</BODY>
</HTML>
