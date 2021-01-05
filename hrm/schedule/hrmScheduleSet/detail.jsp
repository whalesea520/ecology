<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-10-28[排班详情] Generated from 长东设计 www.mfstyle.cn -->
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="hrmSchedulePersonnelManager" class="weaver.hrm.schedule.manager.HrmSchedulePersonnelManager" scope="page"/>
<%
	if(!HrmUserVarify.checkUserRight("HrmScheduling:set", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(125840, user.getLanguage());
	String isDialog = strUtil.vString(request.getParameter("isdialog"), "1");
	int field004 = strUtil.parseToInt(request.getParameter("subcompanyid"), 0);
	String sId = strUtil.getURLDecode(request.getParameter("sId"));
	String field001 = strUtil.getURLDecode(request.getParameter("field001"));
	String startDate = strUtil.getURLDecode(request.getParameter("startDate"));
	String endDate = strUtil.getURLDecode(request.getParameter("endDate"));
	boolean isDetachable = strUtil.vString(detachCommonInfo.getDetachable()).equals("1");
	String allIds = "";
	if(!user.getLoginid().equalsIgnoreCase("sysadmin") && isDetachable) {
		int subCompany[] = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "HrmScheduling:set");
		StringBuffer sIds = new StringBuffer();
		for(int i=0;i<subCompany.length;i++) sIds.append(sIds.length()==0?"":",").append(subCompany[i]);
		allIds = strUtil.vString(sIds.toString(), "-99999");
	}
	String sqlwhere = "";
%>
<html>
	<head>
		<link rel="stylesheet" type="text/css" href="/css/Weaver_wev8.css">
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript" src="/js/datetime_wev8.js"></script>
		<script type="text/javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			var common = new MFCommon();

			jQuery(document).ready(function(){showFieldItem();});

			function showFieldItem() {}

			function doClean() {
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("826,125841",user.getLanguage())%>?",function() {
					try{parent.disableTabBtn();}catch(e){}
					common.ajax($("#weaver").attr("action")+"?cmd=clean&"+$("#weaver").serialize()+"&randomstr="+randomString(6), false, function(result) {
						parentWin._table.reLoad();
						result = jQuery.parseJSON(result);
						parentWin.closeAndSubmit();
					});
				});
			}
			
			var dialog = null;
			
			function closeDialog() {
				if(dialog) dialog.close();
			}
			
			function showDatas(datas) {
				var result = common.getDialogReturnValue(datas);
				var startDate = $GetEle("startDate").value;
				var endDate = $GetEle("endDate").value;
				common.ajax("/hrm/schedule/hrmScheduleSetPerson/save.jsp?cmd=mInsert&sId=<%=sId%>&startDate="+startDate+"&endDate="+endDate+"&field001=0&field002="+result.id, false, function(result){_table.reLoad();});
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
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
					return;
				}
				if(id.match(/,$/)) id = id.substring(0,id.length-1);
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function() {
					common.ajax("/hrm/schedule/hrmScheduleSetDetail/save.jsp?cmd=delete&ids="+id, false, function(result){_table.reLoad();});
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
				topMenu.add(SystemEnv.getHtmlLabelName(125841,user.getLanguage()), "doClean()");
				RCMenu += topMenu.getRightMenus();
				RCMenuHeight += RCMenuHeightStep * topMenu.size();
			%>
			<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
			<form id="weaver" name="frmMain" action="/hrm/schedule/hrmScheduleSetPerson/save.jsp" method="post" >
				<input type="hidden" name="sId" value="<%=sId%>">
				<input type="hidden" name="startDate" id="startDate" value="<%=startDate%>">
				<input type="hidden" name="endDate" id="endDate" value="<%=endDate%>">
				<table id="topTitle" cellpadding="0" cellspacing="0">
					<tr>
						<td></td>
						<td class="rightSearchSpan" style="text-align:right;">
							<%topMenu.show();%>
							<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
						</td>
					</tr>
				</table>
				<wea:layout type="2col">
					<wea:group context="<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>">
						<wea:item attributes="{'samePair':'field001Item'}"><%=SystemEnv.getHtmlLabelNames("33604,740",user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field001Item'}">
							<button class="Calendar" type="button" id="field001Date" onclick="getDate(field001Span, startDate)"></button>
							<span id="field001Span"><%=startDate%></span>
						</wea:item>
						<wea:item attributes="{'samePair':'field002Item'}"><%=SystemEnv.getHtmlLabelNames("33604,741",user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field002Item'}">
							<button class="Calendar" type="button" id="field002Date" onclick="getDate(field002Span, endDate)"></button>
							<span id="field002Span"><%=endDate%></span>
						</wea:item>
						<wea:item attributes="{'samePair':'field003Item'}"><%=SystemEnv.getHtmlLabelName(24803,user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':'field003Item'}">
							<span id="field003Span"><%=field001%></span>
						</wea:item>
					</wea:group>
					<wea:group context="<%=SystemEnv.getHtmlLabelName(125839,user.getLanguage())%>">
						<wea:item type="groupHead">
							<img class="toolpic additem" style="vertical-align:middle;margin-right:5px" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" accesskey="" src="/wui/theme/ecology8/weaveredittable/img/add_wev8.png" onclick="doAdd()">
							<img class="toolpic deleteitem" style="vertical-align:middle;margin-right:10px" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" accesskey="" src="/wui/theme/ecology8/weaveredittable/img/delete_wev8.png" onclick="doDel()">
						</wea:item>
						<wea:item attributes="{'isTableList':'true','colspan':'full', 'id':'Hrm_HrmScheduleSet_Table'}">
							<%
								String sqlField = "t.*";
								String sqlFrom = "from (select t2.lastname,t2.subcompanyid1,t3.subcompanyname,t4.departmentname,t5.jobtitlename, t.*, 0 as cnt from hrm_schedule_set_detail t right join hrmresource t2 on t.field002 = t2.id left join HrmSubCompany t3 on t2.subcompanyid1 = t3.id left join HrmDepartment t4 on t2.departmentid = t4.id left join HrmJobTitles t5 on t2.jobtitle = t5.id where t.delflag = 0 and t.field005 != '"+(rs.getDBType().equalsIgnoreCase("oracle")?"-1":"")+"') t";
								String sqlWhere = "where t.delflag = 0";
								if(sId.length() > 0) {
									sqlWhere += " and t.field001 = '"+sId+"'";
								}
								if(startDate.length() > 0 && endDate.length() > 0) {
									sqlWhere += " and t.field003 between '"+startDate+"' and '"+endDate+"'";
								}
								if(strUtil.vString(detachCommonInfo.getDetachable()).equals("1")) {
									if(field004 != 0) {
										sqlWhere += " and t.subcompanyid1 = "+field004;
									}
									if(allIds.length() > 0) {
										sqlWhere += " and t.subcompanyid1 in ("+allIds+")";
									}
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
				</wea:layout>
			</form>
	<%if("1".equals(isDialog)){ %>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2col">
				<wea:group context="">
					<wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentWin.closeAndSubmit();">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		<script type="text/javascript">jQuery(document).ready(function(){resizeDialog(document);});</script>
	<%} %>
	</body>
</html>