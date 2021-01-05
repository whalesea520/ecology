
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- added by wcd 2014-09-12 [下属] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="authorityManager" class="weaver.hrm.authority.manager.AuthorityManager" scope="page"/>
<%
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelName(442,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	boolean isHidden="true".equalsIgnoreCase(Util.null2String(request.getParameter("isHidden"))); 
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String fromid=Util.null2String(request.getParameter("fromid"));
	String toid=Util.null2String(request.getParameter("toid"));
	String _type = Util.null2String(request.getParameter("type"));
	String selectedstrs = Util.null2String(request.getParameter("idStr"));
	String isAll = Util.null2String(request.getParameter("isAll"));
	String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
	String oldJson = jsonSql;
	jsonSql = Tools.replace(jsonSql,"\"","\\\\\"");
	
	String planName = Util.null2String(request.getParameter("planname"));  //日程名
	String urgentLevel = Util.null2String(request.getParameter("urgentlevel"));  //紧急程度
	String planType = Util.null2String(request.getParameter("plantype"));  //日程类型
	String planStatus = Util.null2String(request.getParameter("planstatus"));  //状态  0：代办；1：完成；2、归档
	String beginDate = Util.null2String(request.getParameter("begindate"));  //开始日期
	String endDate = Util.null2String(request.getParameter("enddate"));  //结束日期
	String beginDate2 = Util.null2String(request.getParameter("begindate2"));  //开始日期
	String endDate2 = Util.null2String(request.getParameter("enddate2"));  //结束日期
	int timeSag = Util.getIntValue(request.getParameter("timeSag"),0);
	int timeSagEnd = Util.getIntValue(request.getParameter("timeSagEnd"),0);
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var dialog = parent.parent.getDialog(parent);

			function doCloseDialog() {
				dialog.close();
			}
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(!isHidden){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(555,user.getLanguage())+",javascript:selectDone(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())+",javascript:selectAll(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="WorkPlan.jsp" name="searchfrm" id="searchfrm">
			<input type=hidden name="isdialog" value="<%=isDialog%>">
			<input type=hidden name="cmd" value="closeDialog">
			<input type=hidden name="fromid" value="<%=fromid%>">
			<input type=hidden name="toid" value="<%=toid%>">
			<input type=hidden name="type" value="<%=_type%>">
			<input type=hidden name="idStr" value="<%=selectedstrs%>">
			<input type=hidden name="jsonSql" value="<%=Tools.getURLEncode(oldJson)%>">
			<input type=hidden name="isDelType" value="0">
			<input type=hidden name="selectAllSql" value="">
			<input type=hidden name="needExecuteSql" value="0">
			<input type=hidden name="isHidden" value="<%=isHidden %>">
			<input type=hidden name="isAll" value="<%=isAll%>">
			
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%if(!isHidden){ %>
						<input type=button class="e8_btn_top" onclick="selectDone();" value="<%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%>"></input>
						<input type=button class="e8_btn_top" onclick="selectAll();" value="<%=SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())%>"></input>
						<%} %>
						<input type="text" class="searchInput" name="qname" value="<%=planName %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<!--================== 标题 ==================-->			                	
				<wea:item><%=SystemEnv.getHtmlLabelName(229,user.getLanguage())%></wea:item>
				<wea:item attributes="{'colspan':'full'}">
			  		<INPUT type="text" class="InputStyle" maxlength="100" size="30" id="planname" name="planname" value="<%=planName%>">
			  	</wea:item>
				<!--================== 紧急程度 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></wea:item>
				<wea:item>
		    		<SELECT name="urgentlevel" style="width:100px;">
						<OPTION value="" <%if(!"1".equals(urgentLevel) && !"2".equals(urgentLevel) && !"3".equals(urgentLevel)){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>
						<OPTION value="1" <%if("1".equals(urgentLevel) ){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></OPTION>
						<OPTION value="2" <%if("2".equals(urgentLevel) ){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></OPTION>
						<OPTION value="3" <%if("3".equals(urgentLevel) ){%>selected <%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></OPTION>
					</SELECT>
				</wea:item>
				<!--================== 日程类型 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%></wea:item>
				<wea:item>
					<SELECT name="plantype" style="width:100px;">
						<OPTION value="" <%if("".equals(planType)) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></OPTION>											
						<%
				  			rs.executeSql("SELECT * FROM WorkPlanType ORDER BY displayOrder ASC");
				  			while(rs.next())
				  			{
				  		%>
				  			<OPTION value="<%= rs.getInt("workPlanTypeID") %>" <%if(planType.equals(rs.getString("workPlanTypeID"))) {%>selected<%}%>><%= rs.getString("workPlanTypeName") %></OPTION>
				  		<%
				  			}
				  		%>
					</SELECT>
				</wea:item>
			 
				<!--================== 开始日期  ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></wea:item>
			  	<wea:item attributes="{'colspan':'full'}">
					<span>
						<select name="timeSag" id="timeSag" onchange="changeDate(this,'wpbegindate');" style="width:100px;">
							<option value="0" <%=timeSag==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							<option value="1" <%=timeSag==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
							<option value="2" <%=timeSag==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
							<option value="3" <%=timeSag==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
							<option value="4" <%=timeSag==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
							<option value="5" <%=timeSag==5?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
							<option value="6" <%=timeSag==6?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
						</select>
					</span>
					<span id="wpbegindate"  style="<%=timeSag==6?"":"display:none;" %>">
						<button type="button" class="Calendar" id="SelectBeginDate" onclick="getDate(begindatespan,begindate)"></BUTTON> 
					  	<SPAN id="begindatespan"><%=beginDate%></SPAN> 
				  		<INPUT type="hidden" name="begindate" value="<%=beginDate%>">  
				  		&nbsp;-&nbsp;&nbsp;
				  		<button type="button" class="Calendar" id="SelectEndDate" onclick="getDate(enddatespan,enddate)"></BUTTON> 
				  		<SPAN id="enddatespan"><%=endDate%></SPAN> 
					    <INPUT type="hidden" name="enddate" value="<%=endDate%>">
					</span>
					
				</wea:item>
				<!--==================  结束日期 ==================-->
				<wea:item><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></wea:item>
			  	<wea:item attributes="{'colspan':'full'}">
			  		<span>
						<select name="timeSagEnd" id="timeSagEnd" onchange="changeDate(this,'wpendate');" style="width:100px;">
							<option value="0" <%=timeSagEnd==0?"selected":"" %>><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							<option value="1" <%=timeSagEnd==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15537,user.getLanguage())%></option><!-- 今天 -->
							<option value="2" <%=timeSagEnd==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15539,user.getLanguage())%></option><!-- 本周 -->
							<option value="3" <%=timeSagEnd==3?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15541,user.getLanguage())%></option><!-- 本月 -->
							<option value="4" <%=timeSagEnd==4?"selected":"" %>><%=SystemEnv.getHtmlLabelName(21904,user.getLanguage())%></option><!-- 本季 -->
							<option value="5" <%=timeSagEnd==5?"selected":"" %>><%=SystemEnv.getHtmlLabelName(15384,user.getLanguage())%></option><!-- 本年 -->
							<option value="6" <%=timeSagEnd==6?"selected":"" %>><%=SystemEnv.getHtmlLabelName(32530,user.getLanguage())%></option><!-- 指定日期范围 -->
						</select>
					</span>
					<span id="wpendate"  style="<%=timeSagEnd==6?"":"display:none;" %>">
						<button type="button" class="Calendar" id="SelectBeginDate2" onclick="getDate(begindatespan2,begindate2)"></BUTTON> 
					  	<SPAN id="begindatespan2"><%=beginDate2%></SPAN> 
				  		<INPUT type="hidden" name="begindate2" value="<%=beginDate2%>">  
				  		&nbsp;-&nbsp;&nbsp;
				  		<button type="button" class="Calendar" id="SelectEndDate2" onclick="getDate(enddatespan2,enddate2)"></BUTTON> 
				  		<SPAN id="enddatespan2"><%=endDate2%></SPAN> 
					    <INPUT type="hidden" name="enddate2" value="<%=endDate2%>">
					</span>
				</wea:item>
				
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="doSubmit()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>
		<%
			String backfields = "a.ID, a.name,a.urgentLevel, a.type_n, a.status, a.beginDate, a.beginTime, a.endDate, a.createDate, a.createTime "; 
			String fromSql  = " from workplan a ";
			String sqlWhere = " ";
			String orderby = " a.beginDate, a.beginTime";
			
			if(rs.getDBType().equals("oracle")){
				sqlWhere=" where ','||resourceid||',' like '%,"+fromid+",%'";
			}else{
				sqlWhere=" where ','+resourceid+',' like '%,"+fromid+",%'";
			}
			sqlWhere += " AND a.status = '0'";
			
			if(!"".equals(planName) && null != planName)
			{
				planName=planName.replaceAll("\"","＂");
				planName=planName.replaceAll("'","＇");
				sqlWhere += " AND a.name LIKE '%" + planName + "%'";
			}
			if(!"".equals(urgentLevel) && null != urgentLevel)
			{	
				if("1".equals(urgentLevel)){
					sqlWhere += " AND (a.urgentLevel = '1' or a.urgentLevel='')";
				}else{
					sqlWhere += " AND a.urgentLevel = '" + urgentLevel + "'";
				}
				
			}
			if(!"".equals(planType) && null != planType)
			{
				sqlWhere += " AND a.type_n = '" + planType + "'";
			}
			 
			if(timeSag > 0&&timeSag<6){
				String doclastmoddatefrom = TimeUtil.getDateByOption(""+timeSag,"0");
				String doclastmoddateto = TimeUtil.getDateByOption(""+timeSag,"1");
				if(!doclastmoddatefrom.equals("")){
					sqlWhere += " and a.beginDate >= '" + doclastmoddatefrom + "'";
				}
				
				if(!doclastmoddateto.equals("")){
					sqlWhere += " and a.beginDate <= '" + doclastmoddateto + "'";
				}
				
			}else{
				if(timeSag==6){//指定时间
					if((!"".equals(beginDate) && null != beginDate))
					{
						sqlWhere += " AND a.beginDate >= '" + beginDate+ "'";								    
					   // sqlWhere += "' OR workPlan.endDate IS NULL)";
					}
					if((!"".equals(endDate) && null != endDate))
					{
						sqlWhere += " AND a.beginDate <= '" + endDate + "'";
					}
				}
				
			}
			
			if(timeSagEnd > 0&&timeSagEnd<6){
				String doclastmoddatefrom = TimeUtil.getDateByOption(""+timeSagEnd,"0");
				String doclastmoddateto = TimeUtil.getDateByOption(""+timeSagEnd,"1");
				if(!doclastmoddatefrom.equals("")){
					sqlWhere += " and a.endDate >= '" + doclastmoddatefrom + "'";
				}
				
				if(!doclastmoddateto.equals("")){
					sqlWhere += " and a.endDate <= '" + doclastmoddateto + "'";
				}
				
			}else{
				if(timeSagEnd==6){//指定时间
					if((!"".equals(beginDate2) && null != beginDate2))
					{
						sqlWhere += " AND a.endDate >= '" + beginDate2+ "'";								    
					   // sqlWhere += "' OR workPlan.endDate IS NULL)";
					}
					if((!"".equals(endDate2) && null != endDate2))
					{
						sqlWhere += " AND a.endDate <= '" + endDate2+ "'";								    
					   // sqlWhere += "' OR workPlan.endDate IS NULL)";
					}
				}
				
			}
			
			String operateString= "";
			String tableString =" <table pageId=\""+PageIdConst.WP_TRANSFER_LIST+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WP_TRANSFER_LIST,user.getUID())+"\" tabletype=\""+(isHidden?"none":"checkbox")+"\">"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
			operateString+
			"	<head>"+
			"      <col width=\"20%%\"  text=\""+SystemEnv.getHtmlLabelName(229,user.getLanguage())+"\" column=\"ID\" otherpara=\"column:name+column:type_n\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanName\"/>"+
			"      <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(15534,user.getLanguage())+"\" column=\"urgentLevel\" otherpara=\"" + user.getLanguage() + "\" orderkey=\"urgentLevel\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getUrgentName\" />"+
			"      <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(16094,user.getLanguage())+"\" column=\"type_n\" orderkey=\"type_n\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getWorkPlanType\"/>"+							    
			"      <col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(2211,user.getLanguage()) + SystemEnv.getHtmlLabelName(602,user.getLanguage())+ "\" column=\"status\" otherpara=\"" + user.getLanguage() + "\" orderkey=\"status\" transmethod=\"weaver.splitepage.transform.SptmForWorkPlan.getStatusName\"/>"+
			"      <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(740,user.getLanguage())+"\" column=\"beginDate\" orderkey=\"beginDate\"/>"+
			"      <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(741,user.getLanguage())+"\" column=\"endDate\" orderkey=\"endDate\"/>"+						    
			"	</head>"+
			" </table>";

			StringBuilder _sql = new StringBuilder();
			_sql.append("select ").append(backfields).append(fromSql).append(sqlWhere);
			rs.executeSql("select count(1) as count from (" + _sql.toString() + ") temp");
			long count = 0;
			if (rs.next()){
				count = Long.parseLong(Util.null2String(rs.getString("count"), "0"));
			}
			
			String tempSql = strUtil.encode(_sql.toString());
			_sql.setLength(0);
			_sql.append(tempSql);
			MJson mjson = new MJson(oldJson, true);
			if(mjson.exsit(_type)) {
				selectedstrs = authorityManager.getData("id", strUtil.decode(mjson.getValue(_type)));
				mjson.updateArrayValue(_type, _sql.toString());
			} else {
				if(Boolean.valueOf(isAll).booleanValue()) selectedstrs = authorityManager.getData("id", strUtil.decode(_sql.toString()));
				mjson.putArrayValue(_type, _sql.toString());
			}
		 
			String oJson = Tools.getURLEncode(mjson.toString());
			mjson.removeArrayValue(_type);
			String nJson = Tools.getURLEncode(mjson.toString());
		%>
		<script>
			$GetEle("selectAllSql").value = encodeURI("<%=_sql.toString()%>");
		</script>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' selectedstrs="<%=selectedstrs%>" mode="run" /> 
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="dialog.close();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
<%} %>
	<script type="text/javascript">
		function selectDone(id){
			if(!id){
				id = _xtable_CheckedCheckboxId();
			}
			if(!id){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
				return;
			}
			if(id.match(/,$/)){
				id = id.substring(0,id.length-1);
			}
			//window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22161,user.getLanguage())%>",function(){
			
			//});
			if (dialog) {
				var data = {
					type: '<%=_type%>',
					isAll: false,
					id: id,
					json: '<%=nJson%>'
				};
				dialog.callback(data);
				doCloseDialog();
			}
		}

		function selectAll(){
			//window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22161,user.getLanguage())%>",function(){
				
			//});
			if (dialog) {
				var data = {
					type: '<%=_type%>',
					isAll: true,
					count: <%=count%>,
					json: '<%=oJson%>'
				};
				dialog.callback(data);
				doCloseDialog();
			}
		}
	
	var diag_vote;
	function closeDialog(){
		diag_vote.close();
	}

	function closeWinARfrsh(){
		diag_vote.close();
		doSearch();
	}

	function view(id, workPlanTypeID){
		if(window.top.Dialog){
			diag_vote = new window.top.Dialog();
		} else {
			diag_vote = new Dialog();
		}
		diag_vote.currentWindow = window;
		diag_vote.Width = 800;
		diag_vote.Height = 600;
		diag_vote.Modal = true;
		diag_vote.maxiumnable = true;
		diag_vote.checkDataChange = false;
		diag_vote.isIframe=false;
		diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(2211,user.getLanguage())%>";
		if(workPlanTypeID == 6){
			diag_vote.URL = "/hrm/performance/targetPlan/PlanView.jsp?from=2&id=" + id ;
		} else {
			diag_vote.URL = "/workplan/data/WorkPlanDetail.jsp?from=1&workid=" + id ;
		}
		diag_vote.show();
		
	}

		function onBtnSearchClick(){
			var name=$("input[name='qname']",parent.document).val();
			$("#planname").val(name);
			$('#searchfrm').submit();
		}
		
		function doSubmit(){
			$('#searchfrm').submit();
		} 
 
/**
*清空搜索条件
*/
function resetCondtion1() {
	//清空文本框
	jQuery("#advancedSearchDiv").find("input[type='text']").val("");
	//清空浏览按钮及对应隐藏域
	jQuery("#advancedSearchDiv").find(".Browser").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".Browser").siblings("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_os").find("input[type='hidden']").val("");
	jQuery("#advancedSearchDiv").find(".e8_outScroll .e8_innerShow span").html("");
	//清空下拉框
	jQuery("#advancedSearchDiv").find("select").val("");
	jQuery("#timeSag").val("0");
	jQuery("#timeSagEnd").val("0");
	jQuery("#advancedSearchDiv").find("select").trigger("change");

	jQuery("#advancedSearchDiv").find("select").selectbox('detach');
	jQuery("#advancedSearchDiv").find("select").selectbox('attach');
	
	//清空日期
	jQuery("#advancedSearchDiv").find(".calendar").siblings("span").html("");
	jQuery("#advancedSearchDiv").find(".calendar").siblings("input[type='hidden']").val("");
}
jQuery(document).ready(function () {
	if (typeof onBtnSearchClick != "undefined" && onBtnSearchClick instanceof Function) {
		jQuery("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	}
	jQuery(".topMenuTitle td:eq(0)").html(jQuery("#tabDiv").html());
	jQuery("#tabDiv").remove();
	jQuery("#hoverBtnSpan").hoverBtn();


});
function changeDate(obj, id, val) {
	if (val == null) {
		val = "6";
	}
	if (obj.value == val) {
		jQuery("#" + id).show();
	} else {
		jQuery("#" + id).hide();
		jQuery("#" + id).siblings("input[type='hidden']").val("");
	}
}

	</script>
	</body>
</html>
<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
