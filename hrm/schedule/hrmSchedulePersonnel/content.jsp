<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-10-10[排班人员范围] Generated from 长东设计 www.mfstyle.cn -->
<%@ page import="weaver.hrm.schedule.domain.HrmSchedulePersonnel"%>
<jsp:useBean id="hrmSchedulePersonnelManager" class="weaver.hrm.schedule.manager.HrmSchedulePersonnelManager" scope="page"/>
<%
	if(!HrmUserVarify.checkUserRight("HrmSchedulingPersonnel:set", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(124810, user.getLanguage());
	String isDialog = strUtil.vString(request.getParameter("isdialog"), "1");
	String id = strUtil.vString(request.getParameter("id"));

	HrmSchedulePersonnel bean = id.length() > 0 ? hrmSchedulePersonnelManager.get(id) : null;
	bean = bean == null ? new HrmSchedulePersonnel() : bean;
	String field002Name = hrmSchedulePersonnelManager.getField002Value(String.valueOf(bean.getField001()), bean.getField002());
	String field007Name = hrmSchedulePersonnelManager.getField007Value(String.valueOf(bean.getField006()), bean.getField007());
%>
<html>
	<head>
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			var common = new MFCommon();
			
			jQuery(document).ready(function(){
				showFieldItem();
			});

			function doSave() {
				var type = $GetEle("field001").value;
				var checkFields = "field001"+(type == 4 ? "" : ",field002")+(type == 0 ? "" : ",field003,field004");
				if (type==7){
					checkFields = "field001,field002,jobtitlelevel";
					$GetEle("field003").value=0;
					$GetEle("field004").value=0;
					if($GetEle("jobtitlelevel").value=="1"){
						checkFields+=",jobtitledepartment";
					}else if($GetEle("jobtitlelevel").value=="2"){
						checkFields+=",jobtitlesubcompany";
					}
				}
					
				if(!check_form(document.frmMain, checkFields)) return;
				if(type != 0) {
					var field003Value = $GetEle("field003").value;
					var field004Value = $GetEle("field004").value;
					var message = "";
					if(parseInt(field003Value) > parseInt(field004Value)) message += "<%=SystemEnv.getHtmlLabelName(24665,user.getLanguage())%>";
					if(parseInt(field003Value) < 0 || parseInt(field003Value) > 100 || parseInt(field004Value) < 0 || parseInt(field004Value) > 100) message += (message == "" ? "" : "<br/>")+"<%=SystemEnv.getHtmlLabelName(125893,user.getLanguage())%>";
					if(message != "") {
						window.top.Dialog.alert(message);
						return;
					}
				}

				try{parent.disableTabBtn();}catch(e){}
				common.ajax($("#weaver").attr("action")+"?cmd=save&"+$("#weaver").serialize()+"&randomstr="+randomString(6), false, function(result) {
					parentWin._table.reLoad();
					result = jQuery.parseJSON(result);
					parentWin.closeDialog();
				});
			}
			
			function doChangeType(){
				_writeBackData('field002', 2, {id:'',name:''},{hasInput:true});
				showFieldItem();
			}
			
			function showFieldItem() {
				var type = $GetEle("field001").value;
				common.showItem(type != '4', "field002Item");
				common.showItem((type != '0' && type != '7'), "field003Item");
				common.showItem(type == '3', "field005Item");
				common.showItem(type == '7', "item_jobtitlelevel");
				if(type == '7'){
					if(jQuery("#jobtitlelevel").val()=="1"){
						$GetEle("showjobtitledepartment").style.display='';
					}else if(jQuery("#jobtitlelevel").val()=="2"){
						$GetEle("showjobtitlesubcompany").style.display='';
					}
				}
			}
			
			function delField002(text,fieldid,params){
				doChangeType();
			}
			
			function getCompleteUrl() {
				var type = $GetEle("field001").value;
				var value = "1";
				if (type == '0') {
					value = "1";
				} else if (type == '1') {
					value = "4";
				} else if (type == '2') {
					value = "164";
				} else if (type == '3') {
					value = "65";
				} else if (type == '7') {
					value = "24";
				}
        		return "/data.jsp?type=" + value;
        	}
			
			function onShowBrowser() {
				var type = $GetEle("field001").value;
				var field002val = $GetEle("field002").value;
				
				var url = "";
				if (type == '0') {
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?show_virtual_org=-1&resourceids="+field002val;
				} else if (type == '1') {
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?show_virtual_org=-1&selectedids="+field002val;
				} else if (type == '2') {
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?show_virtual_org=-1&selectedids="+field002val;
				} else if (type == '3') {
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp?selectids="+field002val;
				} else if (type == '7') {
					url = "/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?resourceids="+field002val;
				}
				return url;
			}
			
			function onjobtitlelevelChange(){
				$GetEle("showjobtitlesubcompany").style.display='none';
				$GetEle("showjobtitledepartment").style.display='none';
				_writeBackData('jobtitlesubcompany', 2, {id:'',name:''},{hasInput:true});
				_writeBackData('jobtitledepartment', 2, {id:'',name:''},{hasInput:true});
				if(jQuery("#jobtitlelevel").val()==1){
					$GetEle("showjobtitledepartment").style.display='';
				}else if(jQuery("#jobtitlelevel").val()==2){
					$GetEle("showjobtitlesubcompany").style.display='';
				}
			}
		</script>
	</head>
	<body>
	<%if("1".equals(isDialog)){ %>
		<div class="zDialog_div_content">
	<%} %>
			<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
			<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
			<%
				TopMenu topMenu = new TopMenu(out, user);
				topMenu.add(SystemEnv.getHtmlLabelName(86,user.getLanguage()), "javascript:doSave();");
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
			<form id="weaver" name="frmMain" action="/hrm/schedule/hrmSchedulePersonnel/save.jsp" method="post" >
				<input type="hidden" name="id" value="<%=id%>">
				<wea:layout type="2col">
					<wea:group context="<%=SystemEnv.getHtmlLabelName(124810,user.getLanguage())%>">
						<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="field001Span" required="<%=String.valueOf(bean.getField001()).length() == 0%>">
								<select id="field001" name="field001" class="inputStyle" onchange="doChangeType()">
									<option value="0" <%=String.valueOf(bean.getField001()).equals("0") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
									<option value="1" <%=String.valueOf(bean.getField001()).equals("1") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
									<option value="2" <%=String.valueOf(bean.getField001()).equals("2") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
									<option value="3" <%=String.valueOf(bean.getField001()).equals("3") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
									<option value="7" <%=String.valueOf(bean.getField001()).equals("7") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
									<option value="4" <%=String.valueOf(bean.getField001()).equals("4") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
								</select>
							</wea:required>
						</wea:item>
						<wea:item attributes="{'samePair':'field002Item'}"><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field002Item'}">
							<div style="width:100%">
								<brow:browser viewType="0" name="field002" width="60%"
									browserValue="<%=String.valueOf(bean.getField002())%>"
									browserSpanValue="<%=field002Name%>"
									hasInput="true" isSingle="false" hasBrowser="true" isMustInput="2"
									getBrowserUrlFn="onShowBrowser" 
									completeUrl="javascript:getCompleteUrl()" 
									afterDelCallback = "delField002">
								</brow:browser>
							</div>
						</wea:item>
						<wea:item attributes="{'samePair':'field005Item'}"><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field005Item'}">
							<select id="field005" name="field005" class="inputStyle">
								<option value="0" <%=String.valueOf(bean.getField005()).equals("0") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
								<option value="1" <%=String.valueOf(bean.getField005()).equals("1") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
								<option value="2" <%=String.valueOf(bean.getField005()).equals("2") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
							</select>
						</wea:item>
						<wea:item attributes="{'samePair':'item_jobtitlelevel'}"><%=SystemEnv.getHtmlLabelName(28169,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'item_jobtitlelevel'}">
							<SELECT id=jobtitlelevel name=jobtitlelevel onchange="onjobtitlelevelChange()" style="float: left;">
								<option value="0" <%=String.valueOf(bean.getField006()).equals("0") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
								<option value="1" <%=String.valueOf(bean.getField006()).equals("1") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%>
								<option value="2" <%=String.valueOf(bean.getField006()).equals("2") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%>
							</SELECT>
							<span id="showjobtitlesubcompany" style="display:none">
								<brow:browser viewType="0" name="jobtitlesubcompany" browserValue="<%=bean.getField007()%>" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
									hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
									completeUrl="/data.jsp?type=164" width="60%" browserSpanValue="<%=field007Name%>">
								</brow:browser>
							</span>
							<span id="showjobtitledepartment" style="display:none">
								<brow:browser viewType="0" name="jobtitledepartment" browserValue="<%=bean.getField007()%>" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
									hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
									completeUrl="/data.jsp?type=4" width="60%" browserSpanValue="<%=field007Name%>">
								</brow:browser>
							</span>
						</wea:item>
						<wea:item attributes="{'samePair':'field003Item'}"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field003Item'}">
							<wea:required id="field003Span" required="<%=bean.getField003() < 0 || bean.getField003() > 100%>"><input style="width:15%" type="text" maxlength="10" name="field003" onKeyPress="ItemCount_KeyPress()" onBlur="checknumber('field003')" onchange="checkinput('field003','field003Span')" value="<%=bean.getField003()%>"></wea:required> - <wea:required id="field004Span" required="<%=bean.getField004() < 0 || bean.getField004() > 100%>"><input style="width:15%" type="text" maxlength="10" name="field004" onKeyPress="ItemCount_KeyPress()" onBlur="checknumber('field004')" onchange="checkinput('field004','field004Span')" value="<%=bean.getField004()%>"></wea:required>
						</wea:item>
					</wea:group>
				</wea:layout>
			</form>
	<%if("1".equals(isDialog)){ %>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2col">
				<wea:group context="">
					<wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.closeByHand();">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		<script type="text/javascript">jQuery(document).ready(function(){resizeDialog(document);});</script>
	<%} %>
	</body>
</html>
