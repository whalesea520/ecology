<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<!-- Added by wcd 2015-10-16[班次设置] Generated from 长东设计 www.mfstyle.cn -->
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<%
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(24803, user.getLanguage());
	String qCondition = strUtil.vString(request.getParameter("sqlwhere"), "where 1 = 1");
	String field001 = strUtil.vString(request.getParameter("field001"));
	String field003 = strUtil.vString(request.getParameter("field003"));
	String field006 = strUtil.vString(request.getParameter("field006"));
	String field002 = strUtil.vString(request.getParameter("field002"));
%>
<html>
	<head>
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript">
			var common = new MFCommon();
			var dialog = parent.parent.getDialog(parent);
			try{parent.setTabObjName("<%=titlename%>");}catch(e){}

			function setValue(value) {
				if(dialog) {
					try{dialog.callback(value);}catch(e){}
					try{dialog.close(value);}catch(e){}
				} else {
					window.parent.returnValue = value;
					window.parent.close();
				}
			}

			function cancelValue() {
				if(dialog) dialog.close();
				else window.parent.close();
			}

			function clearValue() {
				setValue({id:"", name:""});
			}

			function afterDoWhenLoaded() {
				$("#_xTable").find("table.ListStyle tbody").children("tr[class!='Spacing']").each(function(){
					var tr = jQuery(this);
					tr.bind("click",function(){
						var id = tr.children("td:first").children().val();
						var name = tr.children("td:first").next().html();
						setValue({"id":id, "name":name});
					});
				});
			}

		</script>
	</head>
	<body style="overflow:hidden;">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			TopMenu topMenu = new TopMenu(out, user);
			topMenu.add(SystemEnv.getHtmlLabelName(197,user.getLanguage()), "document.searchfrm.submit()");
			topMenu.addRight(SystemEnv.getHtmlLabelName(199,user.getLanguage()), "common.resetFormCondition()");
			topMenu.addRight(SystemEnv.getHtmlLabelName(311,user.getLanguage()), "clearValue()");
			topMenu.addRight(SystemEnv.getHtmlLabelName(201,user.getLanguage()), "cancelValue()");
			RCMenu += topMenu.getRightMenus();
			RCMenuHeight += RCMenuHeightStep * topMenu.size();
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<div class="zDialog_div_content" style="width:100%;height:100%">
			<form id="searchfrm" name="searchfrm" action="">
				<input type="hidden" id="sqlwhere" name="sqlwhere" value="<%=xssUtil.put(qCondition)%>">
				<table id="topTitle" cellpadding="0" cellspacing="0">
					<tr>
						<td></td>
						<td class="rightSearchSpan" style="text-align:right;">
							<%topMenu.show();%>
							<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
						</td>
					</tr>
				</table>
				<wea:layout type="4col">
					<wea:group context="<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>">
						<wea:item><%=SystemEnv.getHtmlLabelName(125818,user.getLanguage())%></wea:item>
						<wea:item>
							<input class="inputstyle" type="text" maxlength="100" name="field001" value="<%=field001%>">
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(125819,user.getLanguage())%></wea:item>
						<wea:item>
							<select id="field003" name="field003" class="inputStyle">
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<option value="0" <%=String.valueOf(field003).equals("0") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125827,user.getLanguage())%></option>
								<option value="1" <%=String.valueOf(field003).equals("1") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125828,user.getLanguage())%></option>
								<option value="2" <%=String.valueOf(field003).equals("2") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125823,user.getLanguage())%></option>
								<option value="3" <%=String.valueOf(field003).equals("3") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125824,user.getLanguage())%></option>
								<option value="4" <%=String.valueOf(field003).equals("4") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125825,user.getLanguage())%></option>
								<option value="5" <%=String.valueOf(field003).equals("5") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(125826,user.getLanguage())%></option>
								<option value="6" <%=String.valueOf(field003).equals("6") ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(19516,user.getLanguage())%></option>
							</select>
						</wea:item>
					</wea:group>
				</wea:layout>
			</form>
			<%
				String sqlField = "id, tId, field001, field003, field004, field005, field006, field002, field007, last_modification_time";
				String sqlFrom = "from (select t2.id, t.id as tId, t.field001, t.field003, t.field004, t.field005, t.field006, t.field002, t.field007, t.last_modification_time from hrm_schedule_shifts_set t left join hrm_schedule_shifts_set_id t2 on t.id = t2.field001 where t.delflag = 0) t";
				String sqlWhere = qCondition;
				if(field001.length() > 0) {
					sqlWhere += " and field001 like '%"+field001+"%'";
				}
				if(field003.length() > 0) {
					sqlWhere += " and field003 = "+field003;
				}
				if(strUtil.vString(detachCommonInfo.getDetachable()).equals("1")) {
					String allIds = "";
					ArrayList sList = SubCompanyComInfo.getRightSubCompany(user.getUID(), "HrmScheduling:set");
					for(int i=0;i<sList.size();i++) allIds += (allIds.length() == 0 ? "" : ",") + strUtil.vString(sList.get(i));
					sqlWhere += " and field002 in ("+(strUtil.isNull(allIds) ? "-99999" : allIds)+")";
				}
				SplitPageTagTable table = new SplitPageTagTable(out, user);
				table.addAttribute("tabletype", "none");
				table.setSql(sqlField, sqlFrom, sqlWhere, "last_modification_time", "desc");
				table.addCol("15%", SystemEnv.getHtmlLabelName(125818,user.getLanguage()), "field001");
				table.addFormatCol("17%", SystemEnv.getHtmlLabelName(125819,user.getLanguage()), "field003", "{cmd:class[weaver.hrm.schedule.manager.HrmScheduleShiftsSetManager.getField003Name("+user.getLanguage()+",+column:field003+,+column:field004+,+column:field005+)]}");
				table.addFormatCol("20%", SystemEnv.getHtmlLabelName(125820,user.getLanguage()), "field006", "{cmd:array["+user.getLanguage()+";default=125837,1=125899]}");
				table.addFormatCol("43%", SystemEnv.getHtmlLabelName(125799,user.getLanguage()), "id", "{cmd:class[weaver.hrm.schedule.manager.HrmScheduleShiftsDetailManager.getWorkTime(+column:tId+, "+user.getLanguage()+")]}");
			%>
			<wea:SplitPageTag isShowTopInfo="false" tableString="<%=table.toString()%>" selectedstrs="" mode="run"/>
		</div>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="" attributes="{'groupDisplay':'none'}">
					<wea:item type="toolbar">
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(311,user.getLanguage())%>" id="btnClear" class="zd_btn_cancle" onclick="clearValue();"/>
						<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>" id="btnCancel" class="zd_btn_cancle" onclick="cancelValue();"/>
					</wea:item>
				</wea:group>
			</wea:layout>
			<script type="text/javascript">jQuery(document).ready(function(){resizeDialog(document);});</script>
		</div>
	</body>
</html>