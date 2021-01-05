<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-10-13[班次设置] Generated from 长东设计 www.mfstyle.cn -->
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
	if(!HrmUserVarify.checkUserRight("HrmSchedulingShifts:set", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(125800, user.getLanguage());
	int ads = strUtil.parseToInt(request.getParameter("ads"));
	String qCondition = ads == 1 ? "" : strUtil.vString(request.getParameter("qCondition"));
	String field001 = ads != 1 ? "" : strUtil.vString(request.getParameter("field001"));
	String field006 = strUtil.vString(request.getParameter("field006"));
	int field003 = strUtil.parseToInt(request.getParameter("field003"));
	int field002 = strUtil.parseToInt(request.getParameter("subcompanyid"), 0);
	field002 = field002 < 0 ? 0 : field002;
	String field002Name = field002 == 0 ? "" : SubCompanyComInfo.getSubCompanyname(String.valueOf(field002));
	
	String allIds = "";
	if(strUtil.vString(detachCommonInfo.getDetachable()).equals("1")) {
		int subCompany[] = checkSubCompanyRight.getSubComByUserRightId(user.getUID(), "HrmSchedulingShifts:set");
		StringBuffer sIds = new StringBuffer();
		for(int i=0;i<subCompany.length;i++) sIds.append(sIds.length()==0?"":",").append(subCompany[i]);
		allIds = strUtil.vString(sIds.toString(), "-99999");
	}
%>
<html>
	<head>
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/schedule.css">
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			var common = new MFCommon();
			var dialog = null;
			
			try{if("<%=field002%>" != "0") parent.setTabObjName("<%=field002Name%>");}catch(e){}

			function onBtnSearchClick(aValue) {
				$GetEle("ads").value = aValue;
				jQuery("#searchfrm").submit();
			}

			function closeDialog() {
				if(dialog) dialog.close();
			}

			function showContent(id) {
				id = id && id != "" ? id : "";
				closeDialog();
				showDetail(id);
				dialog = common.showDialog("/hrm/schedule/hrmScheduleShiftsSet/tab.jsp?topage=content&id="+id+"&subcompanyid=<%=field002%>", id == "" ? "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" : "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>");
			}
			
			function showDetail(id) {
				if(id != null) {
					common.ajax("/hrm/schedule/hrmScheduleShiftsSet/save.jsp?cmd=getContent&id="+id+"&randomstr="+randomString(6), false, function(result) {
						result = jQuery.parseJSON(result);
						$GetEle("scrollContainer").innerHTML = "<span id='content' class='wspan'>"+result.content+"</span>";
					});
				} else {
					$GetEle("scrollContainer").innerHTML = "<span id='content' class='wspan'><%=SystemEnv.getHtmlLabelName(125822,user.getLanguage())%></span>";
				}
			}

			function doDel(id) {
				if(!id) id = _xtable_CheckedCheckboxId();
				if(!id) {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
					return;
				}
				if(id.match(/,$/)) id = id.substring(0,id.length-1);
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>",function() {
					common.ajax("/hrm/schedule/hrmScheduleShiftsSet/save.jsp?cmd=delete&ids="+id, false, function(result){_table.reLoad();showDetail();});
				});
			}

		</script>
	</head>
	<body style="overflow:hidden">
		<div style="width:100%;height:100%;" onclick=""><!--showDetail();-->
			<div style="width:75%;height:100%;float:left">
				<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
				<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
				<%
					TopMenu topMenu = new TopMenu(out, user);
					topMenu.add(SystemEnv.getHtmlLabelName(82,user.getLanguage()), "showContent()");
					topMenu.add(SystemEnv.getHtmlLabelName(32136,user.getLanguage()), "doDel()");
					RCMenu += topMenu.getRightMenus();
					RCMenuHeight += RCMenuHeightStep * topMenu.size();
				%>
				<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
				<form id="searchfrm" name="searchfrm" action="">
					<table id="topTitle" cellpadding="0" cellspacing="0">
						<tr>
							<td></td>
							<td class="rightSearchSpan" style="text-align:right;">
								<%topMenu.show();%>
								<input type="text" class="searchInput" name="qCondition" value="<%=qCondition%>"/>
								<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
								<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
							</td>
						</tr>
					</table>
					<input type="hidden" name="ads" value="-1">
					<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
						<wea:layout type="4col">
							<wea:group context="<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>">
								<wea:item><%=SystemEnv.getHtmlLabelName(125818,user.getLanguage())%></wea:item>
								<wea:item>
									<input class="inputstyle" type="text" maxlength="100" name="field001" value="<%=field001%>">
								</wea:item>
								<wea:item><%=SystemEnv.getHtmlLabelName(125819,user.getLanguage())%></wea:item>
								<wea:item>
									<select id="field003" name="field003" class="inputStyle">
										<option value="-1"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
										<option value="0" <%=String.valueOf(field003).equals("0") || field003 == -1 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125827,user.getLanguage())%></option>
										<option value="1" <%=String.valueOf(field003).equals("1") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125828,user.getLanguage())%></option>
										<option value="2" <%=String.valueOf(field003).equals("2") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125823,user.getLanguage())%></option>
										<option value="3" <%=String.valueOf(field003).equals("3") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125824,user.getLanguage())%></option>
										<option value="4" <%=String.valueOf(field003).equals("4") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125825,user.getLanguage())%></option>
										<option value="5" <%=String.valueOf(field003).equals("5") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125826,user.getLanguage())%></option>
										<option value="6" <%=String.valueOf(field003).equals("6") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%></option>
									</select>
								</wea:item>
								<wea:item><%=SystemEnv.getHtmlLabelName(125820,user.getLanguage())%></wea:item>
								<wea:item>
									<select id="field006" name="field006" class="inputStyle">
										<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
										<option value="0" <%=String.valueOf(field006).equals("0") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125837,user.getLanguage())%></option>
										<option value="1" <%=String.valueOf(field006).equals("1") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125899,user.getLanguage())%></option>
									</select>
								</wea:item>
								<%
									if(strUtil.vString(detachCommonInfo.getDetachable()).equals("1")) {
								%>
								<wea:item><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></wea:item>
								<wea:item>
									<brow:browser viewType="0" name="subcompanyid" width="60%"
										browserValue="<%=String.valueOf(field002)%>"
										browserSpanValue="<%=field002Name%>"
										browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1"
										hasInput="true" isSingle="true" hasBrowser="true" isMustInput="1"
										completeUrl="/data.jsp?type=164&show_virtual_org=-1" _callback="">
									</brow:browser>
								</wea:item>
								<%}%>
							</wea:group>
							<wea:group context="">
								<wea:item type="toolbar">
									<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick(1)"/>
									<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="common.resetCondition(this);common.changeSelectValue('field003', '0');"/>
									<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
								</wea:item>
							</wea:group>
						</wea:layout>
					</div>
				</form>
				<%
					String sqlField = "id, field001, field003, field004, field005, field006, field002, field007, last_modification_time, cnt";
					String sqlFrom = "from (select t.*, (select COUNT(id) from hrm_schedule_set where field003 = t2.id and ( exists (select 1 from hrm_schedule_set_detail dt where dt.field001=t.id and dt.delflag='0' and t.id=t2.field001 and t2.id=hrm_schedule_set.field003) or id in (select field001 from hrm_schedule_personnel where delflag='0'))) as cnt from hrm_schedule_shifts_set t left join hrm_schedule_shifts_set_id t2 on t.id = t2.field001 where t.delflag = 0) t";
					String sqlWhere = "where delflag = 0";
					if(ads == 1){
						if(field001.length() > 0) {
							sqlWhere += " and field001 like '%"+field001+"%'";
						}
						if(field003 != -1) {
							sqlWhere += " and field003 = "+field003;
						}
						if(field006.length() > 0) {
							sqlWhere += " and field006 = "+field006;
						}
					} else {
						if(qCondition.length() > 0) {
							sqlWhere += " and field001 like '%"+qCondition+"%'";
						}
					}
					if(field002 > 0) {
						sqlWhere += " and field002 = "+field002;
					}
					if(user.getUID()!=1 && allIds.length() > 0) {
						sqlWhere += " and field002 in ("+allIds+")";
					}
					SplitPageTagTable table = new SplitPageTagTable("Hrm_HrmScheduleShiftsSet", out, user);
					table.addOperate(SystemEnv.getHtmlLabelName(93,user.getLanguage()), "javascript:showContent();", "true");
					table.addOperate(SystemEnv.getHtmlLabelName(91,user.getLanguage()), "javascript:doDel();", "+column:cnt+==0");
					table.addAttribute("rowClick", "showDetail('+column:id+')");
					table.setPopedompara("+column:cnt+==0");
					table.setSql(sqlField, sqlFrom, sqlWhere, "last_modification_time", "desc");
					table.addFormatCol("12%", SystemEnv.getHtmlLabelName(125818,user.getLanguage()), "field001", "{cmd:link[+column:field001+|javascript:showContent;+column:id+]}");
					table.addFormatCol("12%", SystemEnv.getHtmlLabelName(125819,user.getLanguage()), "field003", "{cmd:class[weaver.hrm.schedule.manager.HrmScheduleShiftsSetManager.getField003Name("+user.getLanguage()+",+column:field003+,+column:field004+,+column:field005+)]}");
					table.addFormatCol("12%", SystemEnv.getHtmlLabelName(125820,user.getLanguage()), "field006", "{cmd:array["+user.getLanguage()+";default=125837,1=125899]}");
					if(strUtil.vString(detachCommonInfo.getDetachable()).equals("1")) {
						table.addFormatCol("16%", SystemEnv.getHtmlLabelName(19799,user.getLanguage()), "field002", "{cmd:class[weaver.hrm.schedule.manager.HrmScheduleShiftsSetManager.getSubcompanyName(+column:field002+)]}");
					}
					table.addFormatCol("28%", SystemEnv.getHtmlLabelName(125799,user.getLanguage()), "id", null, "{cmd:class[weaver.hrm.schedule.manager.HrmScheduleShiftsDetailManager.getWorkTime(+column:id+, "+user.getLanguage()+")]}");
					table.addFormatCol("15%", SystemEnv.getHtmlLabelName(16071,user.getLanguage()), "field007", null, "{cmd:class[weaver.hrm.schedule.manager.HrmScheduleShiftsDetailManager.getColorSpan(+column:field007+)]}");
				%>
				<wea:SplitPageTag isShowTopInfo="false" tableString="<%=table.toString()%>" selectedstrs="" mode="run"/>
			</div>
			<div style="width:25%;height:100%;float:left;background:rgb(242,243,248);"><div style="border-left:1px solid rgb(220,220,220);width:100%;height:100%">
				<div id="header"><p><%=SystemEnv.getHtmlLabelName(125817,user.getLanguage())%></p><!--[if lt IE 8]><span></span><![endif]--></div>
				<div id="scrollContainer" style="height:94%;overflow:hidden;margin-top:5px"><span id="content" class="wspan"><%=SystemEnv.getHtmlLabelName(125822,user.getLanguage())%></span></div>
			</div></div>
		</div>
		<script type="text/javascript">jQuery('#scrollContainer').perfectScrollbar();</script>
	</body>
</html>