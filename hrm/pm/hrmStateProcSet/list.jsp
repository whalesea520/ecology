<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/hrm/header.jsp"%>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<!-- Added by wcd 2015-07-03[状态变更流程] -->
<%
	if(!HrmUserVarify.checkUserRight("StateChangeProcess:Set", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdSystem_wev8.gif", needfav = "1", needhelp = "";
	String titlename = SystemEnv.getHtmlLabelName(84790, user.getLanguage());
	String qCondition = strUtil.vString(request.getParameter("qCondition"));
	String field001 = strUtil.vString(request.getParameter("field001"));
	String field002 = strUtil.vString(request.getParameter("field002"));
	String field002Name = "";
	if(field002.length() > 0){
		rs.executeSql("select b.labelname from WorkFlow_Bill a left join HtmlLabelInfo b on a.nameLabel = b.indexID and b.languageid = "+user.getLanguage()+" where a.id in ("+field002+")");
		while(rs.next()) field002Name+= (field002Name.length()==0?"":",") + rs.getString(1);
	}
	int field003 = strUtil.parseToInt(request.getParameter("field003"));
	int field004 = strUtil.parseToInt(request.getParameter("subcompanyid"), 0);
	field004 = field004 < 0 ? 0 : field004;
	
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	if(detachable == 1) {
		rs.executeProc("SystemSet_Select","");
		int _subcompanyid = rs.next() ? rs.getInt("dftsubcomid") : 0;
		if(_subcompanyid != 0) {
			rs.executeSql("update hrm_state_proc_set set field004 = "+_subcompanyid+" where field004 = 0");
		}
	}
	String field004Name = field004 == 0 ? "" : SubCompanyComInfo.getSubCompanyname(String.valueOf(field004));
	int field005 = strUtil.parseToInt(request.getParameter("field005"));
	int field006 = strUtil.parseToInt(request.getParameter("field006"));
	String fromdate = strUtil.vString(request.getParameter("fromdate"));
	String enddate = strUtil.vString(request.getParameter("enddate"));
	
	String allIds = "";
	if(strUtil.vString(ManageDetachComInfo.getDetachable()).equals("1")) {
		ArrayList sList = SubCompanyComInfo.getRightSubCompany(user.getUID(), "StateChangeProcess:Set");
		for(int i=0;i<sList.size();i++) allIds += (allIds.length() == 0 ? "" : ",") + strUtil.vString(sList.get(i));
	}
%>
<html>
	<head>
		<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">
		<link type="text/css" rel="stylesheet" href="/appres/hrm/css/mfcommon_wev8.css">
		<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<script type="text/javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript">
			var common = new MFCommon();
			var dialog = null;
			try{if("<%=field004%>" != "0") parent.setTabObjName("<%=field004Name%>");}catch(e){}

			function onBtnSearchClick() {
				if($GetEle("fromdate").value != "" && $GetEle("enddate").value != "" && $GetEle("fromdate").value > $GetEle("enddate").value) {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16721,user.getLanguage())%>");
					return;
				}
				jQuery("#searchfrm").submit();
			}

			function closeDialog() {
				if(dialog) dialog.close();
			}

			function showContent(id, field006) {
				if(!id) id = "";
				if(field006 != "0" && !field006) field006 = "";
				closeDialog();
				dialog = common.showDialog("/hrm/pm/hrmStateProcSet/tab.jsp?topage=content&subcompanyid=<%=String.valueOf(field004)%>&isDialog=1&id="+id+"&field006="+field006, (id == "" ? "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" : "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>") + "<%=SystemEnv.getHtmlLabelName(84790, user.getLanguage())%>");
			}

			function doDel(id) {
				if(!id) id = _xtable_CheckedCheckboxId();
				if(!id) {
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
					return;
				}
				if(id.match(/,$/)) id = id.substring(0,id.length-1);
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83449,user.getLanguage())%>",function() {
					common.ajax("/hrm/pm/hrmStateProcSet/save.jsp?cmd=delete&ids="+id, false, function(result){_table.reLoad();});
				});
			}
			
			function changeStatus(field005, id) {
				window.top.Dialog.confirm(field005 === 1 ? "<%=SystemEnv.getHtmlLabelName(83450,user.getLanguage())%>" : "<%=SystemEnv.getHtmlLabelName(83451,user.getLanguage())%>",function(){
					common.ajax("/hrm/pm/hrmStateProcSet/save.jsp?cmd=changeStatus&id="+id+"&field005="+field005, false, function(result){_table.reLoad();});
				});
			}
			
			function procSet(id, field001) {
				if(field001 && field001 != ""){
					var url="/workflow/workflow/addwf.jsp?src=editwf&wfid="+field001+"&isTemplate=0&versionid_toXtree=1&from=prjwf&isdialog=1";
					common.showDialog(url,"<%=SystemEnv.getHtmlLabelName(21954,user.getLanguage())%>");
				}
			}
			
			function getFormCompleteUrl(data) {
				return "/data.jsp?type=wfFormBrowser&from=prjwf&isbill=1&sqlwhere=";
			}
			
			function getFormBrowserUrl(data) {
				return "/systeminfo/BrowserMain.jsp?url=/workflow/FormBillBrowser.jsp?from=prjwf&isbill=1&sqlwhere=";
			}

		</script>
	</head>
	<body style="overflow:hidden">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			TopMenu topMenu = new TopMenu(out, user);
			topMenu.add(SystemEnv.getHtmlLabelName(82,user.getLanguage()), "showContent()");
			topMenu.add(SystemEnv.getHtmlLabelNames("20839,20230",user.getLanguage()), "doDel()");
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
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(34067,user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="field001" name="field001" style="width:60%" value='<%=qCondition.length() == 0 ? field001 : qCondition%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(15600,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="field002" browserValue='<%=field002%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?cmd=cleanMID&url=/hrm/attendance/workflowBill/multiBrowser.jsp?selectedids=&sqlwhere=onlystateform"
								hasInput="true" isSingle="false" hasBrowser="true" isMustInput="1"
								completeUrl="/data.jsp?type=Hrm_WorkflowBill&onlystateform=true" width="60%" browserSpanValue='<%=field002Name%>'>
							</brow:browser>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(18411,user.getLanguage())%></wea:item>
						<wea:item>
							<select id="field003" name="field003" style="width:120px">
								<option value=""></option>
								<option value="0" <%=field003 == 0 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("19516,19532",user.getLanguage())%></option>
								<option value="1" <%=field003 == 1 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("468,19532",user.getLanguage())%></option>
							</select>
						</wea:item>
						<%
							if(strUtil.vString(ManageDetachComInfo.getDetachable()).equals("1")) {
						%>
						<wea:item><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="subcompanyid" browserValue='<%=String.valueOf(field004)%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?show_virtual_org=-1"
								hasInput="true" isSingle="true" hasBrowser="true" isMustInput='1'
								completeUrl="/data.jsp?type=164&show_virtual_org=-1" width="60%" browserSpanValue='<%=field004Name%>'>
							</brow:browser>
						</wea:item>
						<%	}%>
						<wea:item><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></wea:item>
						<wea:item>
							<select id="field005" name="field005" style="width:120px">
								<option value=""></option>
								<option value="0" <%=field005 == 0 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(18096,user.getLanguage())%></option>
								<option value="1" <%=field005 == 1 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></option>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(19521,user.getLanguage())%></wea:item>
						<wea:item>
							<span class="wuiDateSpan" selectId="createdateselect" selectValue="">
								<input class=wuiDateSel type="hidden" name="fromdate" value="<%=fromdate%>">
								<input class=wuiDateSel type="hidden" name="enddate" value="<%=enddate%>">
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(84791,user.getLanguage())%></wea:item>
						<wea:item>
							<select id="field006" name="field006" style="width:120px">
								<option value=""></option>
								<option value="0" <%=field006 == 0 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("16250,18015",user.getLanguage())%></option>
								<option value="1" <%=field006 == 1 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("15710,18015",user.getLanguage())%></option>
								<option value="2" <%=field006 == 2 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("6088,18015",user.getLanguage())%></option>
								<option value="3" <%=field006 == 3 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("6089,18015",user.getLanguage())%></option>
								<option value="4" <%=field006 == 4 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("6090,18015",user.getLanguage())%></option>
								<option value="5" <%=field006 == 5 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("6091,18015",user.getLanguage())%></option>
								<option value="6" <%=field006 == 6 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("6092,18015",user.getLanguage())%></option>
								<option value="7" <%=field006 == 7 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("6094,18015",user.getLanguage())%></option>
								<option value="8" <%=field006 == 8 ? "selected" : ""%>><%=SystemEnv.getHtmlLabelNames("6093,18015",user.getLanguage())%></option>
							</select>
						</wea:item>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="common.resetCondition(this);"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>
		<%
			String sqlField = "id, field001, field002, field003, field004, field005, field006, field009, tablename, labelname";
			String sqlFrom = " from ( select a.id, field001, field002, field003, field004, field005, field006, field009, b.tablename, c.labelname from hrm_state_proc_set a left join WorkFlow_Bill b on a.field002 = b.id left join HtmlLabelInfo c on b.nameLabel = c.indexID and c.languageid = "+user.getLanguage()+" ) a";
			String sqlWhere = " where 1=1 ";
			
			if(qCondition.length() > 0){
				sqlWhere += " and field001 in (select id from workflow_base where workflowname like '%"+qCondition+"%')";
			} else if(field001.length() > 0){
				sqlWhere += " and field001 in (select id from workflow_base where workflowname like '%"+field001+"%')";
			}
			if(field002.length() > 0) {
				sqlWhere += " and field002 in ("+field002+")";
			}
			if(field003 != -1) {
				sqlWhere += " and field003 = "+field003;
			}
			if(field004 > 0) {
				sqlWhere += " and field004 = "+field004;
			} else if(user.getUID()!=1 && allIds.length() > 0) {
				sqlWhere += " and field004 in ("+allIds+")";
			}
			if(field005 != -1) {
				sqlWhere += " and field005 = "+field005;
			}
			if(field006 != -1) {
				sqlWhere += " and field006 = "+field006;
			}
			if(fromdate.length() > 0 && enddate.length() > 0) {
				sqlWhere += " and field009 between '"+fromdate+"' and '"+enddate+"'";
			} else {
				if(fromdate.length() > 0) {
					sqlWhere += " and field009 >= '"+fromdate+"'";
				}
				if(enddate.length() > 0) {
					sqlWhere += " and field009 between '1949-10-01' and '"+enddate+"'";
				}
			}
			SplitPageTagTable table = new SplitPageTagTable("Hrm_HrmStateProcSet", out, user);
			table.addOperate(SystemEnv.getHtmlLabelName(18095,user.getLanguage()), "javascript:changeStatus(1);", "+column:field005+==0and+column:field002+!=40and+column:field002+!=41and+column:field002+!=42");
			table.addOperate(SystemEnv.getHtmlLabelName(18096,user.getLanguage()), "javascript:changeStatus(0);", "+column:field005+==1and+column:field002+!=40and+column:field002+!=41and+column:field002+!=42");
			table.addOperate(SystemEnv.getHtmlLabelName(93,user.getLanguage()), "javascript:showContent();", "true", "column:field006");
			table.addOperate(SystemEnv.getHtmlLabelName(21954,user.getLanguage()), "javascript:procSet();", "true", "column:field001");
			table.addOperate(SystemEnv.getHtmlLabelName(20230,user.getLanguage()), "javascript:doDel();", "true");
			table.setPopedompara("true");
			table.setSql(sqlField, sqlFrom, sqlWhere, "id");
			
			int width1 = 20, width2 = 20, width3 = 15, width4 = 0, width5 = 10, width6 = 15, width7 = 20;
			if(strUtil.vString(ManageDetachComInfo.getDetachable()).equals("1")) width3 = (width1 = width2 = width4 = 15) - 5;
			table.addCol(width1, SystemEnv.getHtmlLabelName(34067,user.getLanguage()), "field001", "field001", "weaver.hrm.common.SplitPageTagFormat.colFormat", "{cmd:link[class:weaver.workflow.workflow.WorkflowComInfo.getWorkflowname(+column:field001+)|javascript:showContent;+column:id+___+column:field006+]}");
			table.addCol(width2, SystemEnv.getHtmlLabelName(15600,user.getLanguage()), "labelname");
			table.addCol(width3, SystemEnv.getHtmlLabelName(18411,user.getLanguage()), "field003", "field003", "weaver.hrm.common.SplitPageTagFormat.colFormat", "{cmd:array["+user.getLanguage()+";default=19516and19532,1=468and19532]}");
			if(strUtil.vString(ManageDetachComInfo.getDetachable()).equals("1")) {
				table.addCol(width4, SystemEnv.getHtmlLabelName(19799,user.getLanguage()), "field004", "field004", "weaver.hrm.company.SubCompanyComInfo.getSubCompanyname");
			}
			table.addCol(width5, SystemEnv.getHtmlLabelName(602,user.getLanguage()), "field005", "field005", "weaver.hrm.common.SplitPageTagFormat.colFormat", "{cmd:style[0=color:red]}{cmd:array["+user.getLanguage()+";default=18096,1=18095]}");
			table.addCol(width6, SystemEnv.getHtmlLabelName(19521,user.getLanguage()), "field009");
			table.addCol(width7, SystemEnv.getHtmlLabelName(84791,user.getLanguage()), "field006", "field006", "weaver.hrm.common.SplitPageTagFormat.colFormat", "{cmd:array["+user.getLanguage()+";default=16250and18015,1=15710and18015,2=6088and18015,3=6089and18015,4=6090and18015,5=6091and18015,6=6092and18015,7=6094and18015,8=6093and18015]}");
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=table.toString()%>' selectedstrs="" mode="run"/>
	</body>
</html>
