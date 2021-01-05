<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-10-20[排班设置] Generated from 长东设计 www.mfstyle.cn -->
<%@ page import="weaver.hrm.schedule.domain.HrmScheduleSet"%>
<jsp:useBean id="hrmScheduleShiftsSetManager" class="weaver.hrm.schedule.manager.HrmScheduleShiftsSetManager" scope="page"/>
<jsp:useBean id="hrmSchedulePersonnelManager" class="weaver.hrm.schedule.manager.HrmSchedulePersonnelManager" scope="page"/>
<%
	if(!HrmUserVarify.checkUserRight("HrmScheduling:set", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(16695, user.getLanguage());
	String isDialog = strUtil.vString(request.getParameter("isdialog"), "1");
	String id = strUtil.vString(request.getParameter("id"));
	String cmd = strUtil.vString(request.getParameter("cmd"));
	String startDate = strUtil.vString(request.getParameter("startDate"), dateUtil.getFirstDayOfMonthToString());
	String endDate = strUtil.vString(request.getParameter("endDate"), dateUtil.getLastDayOfMonthToString());
	int field004 = strUtil.parseToInt(request.getParameter("subcompanyid"), 0);
	boolean showResource = id.length() == 0;

	boolean isNew = true;
	HrmScheduleSet bean = new HrmScheduleSet(strUtil.getUUID());
	if(isNew) {
		bean.setField001(startDate);
		bean.setField002(endDate);
		bean.setField004(field004);
	}
	boolean isDetachable = strUtil.vString(detachCommonInfo.getDetachable()).equals("1");
	String sqlwhere = "";
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			var common = new MFCommon();
			var isTime = "<%=cmd%>" == "time";

			jQuery(document).ready(function(){showFieldItem();});

			function showFieldItem() {}

			function doSave() {
				if(!check_form(document.frmMain,'field001,field002,field003')) return;
				try{parent.disableTabBtn();}catch(e){}
				common.ajax($("#weaver").attr("action")+"?cmd=save&"+$("#weaver").serialize()+"&randomstr="+randomString(6), false, function(result) {
					parentWin._table.reLoad();
					result = jQuery.parseJSON(result);
					if(result.canSave != "true") {
						try{parent.enableTabBtn();}catch(e){}
						window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelNames("83638,83956,611,27290,27591,125839",user.getLanguage())%>");
						return;
					}					
					if(isTime) {
						parentWin.closeAndSubmit();
					} else {
						parentWin.closeDialog();
					}
				});
			}
			
			var dialog = null;
			
			function closeDialog() {
				if(dialog) dialog.close();
			}
			
			function showDatas(datas) {
				var result = common.getDialogReturnValue(datas);
				if(result.id != "") {
					common.ajax("/hrm/schedule/hrmScheduleSetPerson/save.jsp?cmd=mInsert&field001=<%=bean.getId()%>&field002="+result.id, false, function(result){_table.reLoad();});
				}
			}
			
			function doAdd(id) {
				id = id && id != "" ? id : "";
				closeDialog();
				common.initDialog({width:650, height:600, showMax:false, _callBack:showDatas});
				dialog = common.showDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?sqlwhere=<%=sqlwhere%>&show_virtual_org=-1", "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>");
			}
			
			function doDel(id) {
				if(!id) id = _xtable_CheckedCheckboxId();
				if(!id) {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
					return;
				}
				if(id.match(/,$/)) id = id.substring(0,id.length-1);
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function() {
					common.ajax("/hrm/schedule/hrmScheduleSetPerson/save.jsp?cmd=delete&ids="+id, false, function(result){_table.reLoad();});
				});
			}

		</script>
	</head>
	<body style="overflow:hidden">
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
			<form id="weaver" name="frmMain" action="/hrm/schedule/hrmScheduleSet/save.jsp" method="post" >
				<input type="hidden" name="id" value="<%=bean.getId()%>">
				<input type="hidden" name="resourceId" id="resourceId" value="<%=id%>">
				<wea:layout type="2col">
					<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
						<wea:item attributes="{'samePair':'field001Item'}"><%=SystemEnv.getHtmlLabelNames("33604,740",user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field001Item'}">
							<wea:required id="field001Span" required="<%=String.valueOf(bean.getField001()).length() == 0%>">
								<button class="Calendar" type="button" id="field001Date" onclick="common.getDate(field001DateSpan, field001)"></button>
								<span id="field001DateSpan"><%=dateUtil.getDate(bean.getField001())%></span>
								<input type="hidden" id="field001" name="field001" value="<%=dateUtil.getDate(bean.getField001())%>">
							</wea:required>
						</wea:item>
						<wea:item attributes="{'samePair':'field002Item'}"><%=SystemEnv.getHtmlLabelNames("33604,741",user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field002Item'}">
							<wea:required id="field002Span" required="<%=String.valueOf(bean.getField002()).length() == 0%>">
								<button class="Calendar" type="button" id="field002Date" onclick="common.getDate(field002DateSpan, field002)"></button>
								<span id="field002DateSpan"><%=dateUtil.getDate(bean.getField002())%></span>
								<input type="hidden" id="field002" name="field002" value="<%=dateUtil.getDate(bean.getField002())%>">
							</wea:required>
						</wea:item>
						<wea:item attributes="{'samePair':'field003Item'}"><%=SystemEnv.getHtmlLabelName(24803,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field003Item'}">
							<brow:browser viewType="0" name="field003" width="60%"
								browserValue="<%=String.valueOf(bean.getField003())%>"
								browserSpanValue="<%=hrmScheduleShiftsSetManager.getDescription(String.valueOf(bean.getT2Field001()))%>"
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/schedule/hrmScheduleShiftsSet/browser.jsp?selectedids="
								hasInput="true" isSingle="true" hasBrowser="true" isMustInput="2"
								completeUrl="/data.jsp?type=Hrm_HrmScheduleShiftsSet" _callback="">
							</brow:browser>
						</wea:item>
					</wea:group>
					<%if(showResource){%>
					<wea:group context="<%=SystemEnv.getHtmlLabelName(125839,user.getLanguage())%>">
						<wea:item type="groupHead">
							<img class="toolpic additem" style="vertical-align:middle;margin-right:5px" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" accesskey="" src="/wui/theme/ecology8/weaveredittable/img/add_wev8.png" onclick="doAdd()">
							<img class="toolpic deleteitem" style="vertical-align:middle;margin-right:10px" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" accesskey="" src="/wui/theme/ecology8/weaveredittable/img/delete_wev8.png" onclick="doDel()">
						</wea:item>
						<wea:item attributes="{'isTableList':'true','colspan':'full', 'id':'Hrm_HrmScheduleSet_Table'}">
							<%
								String sqlField = "t.*";
								String sqlFrom = "from (select t2.lastname,t2.subcompanyid1,t3.subcompanyname,t4.departmentname,t5.jobtitlename, t.*, 0 as cnt from hrm_schedule_set_person t right join hrmresource t2 on t.field002 = t2.id left join HrmSubCompany t3 on t2.subcompanyid1 = t3.id left join HrmDepartment t4 on t2.departmentid = t4.id left join HrmJobTitles t5 on t2.jobtitle = t5.id where t.delflag = 0) t";
								String sqlWhere = "where t.delflag = 0 and t.field001 = "+bean.getId();
								if(strUtil.vString(detachCommonInfo.getDetachable()).equals("1") && field004 != 0) {
									sqlWhere += " and t.subcompanyid1 = "+field004;
								}
								SplitPageTagTable table = new SplitPageTagTable("Hrm_HrmScheduleSetPerson", out, user);
								table.addOperate(SystemEnv.getHtmlLabelName(91,user.getLanguage()), "javascript:doDel();", "+column:cnt+==0");
								table.setPopedompara("+column:cnt+==0");
								table.setSql(sqlField, sqlFrom, sqlWhere, "id", "desc");
								table.addCol("20%", SystemEnv.getHtmlLabelName(413,user.getLanguage()), "lastname");
								table.addCol("25%", SystemEnv.getHtmlLabelName(141,user.getLanguage()), "subcompanyname");
								table.addCol("25%", SystemEnv.getHtmlLabelName(124,user.getLanguage()), "departmentname");
								table.addCol("25%", SystemEnv.getHtmlLabelName(6086,user.getLanguage()), "jobtitlename");
							%>
							<wea:SplitPageTag isShowTopInfo="false" tableString="<%=table.toString()%>" selectedstrs="" mode="run"/>
						</wea:item>
					</wea:group>
					<%}%>
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
