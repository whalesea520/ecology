
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="authorityManager" class="weaver.hrm.authority.manager.AuthorityManager" scope="page"/>
<%
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelName(17991, user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String fromid=Util.null2String(request.getParameter("fromid"));
	String toid=Util.null2String(request.getParameter("toid"));
	String _type = Util.null2String(request.getParameter("type"));
	String selectedstrs = Util.null2String(request.getParameter("idStr"));
	String isAll = Util.null2String(request.getParameter("isAll"));
	String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
	String oldJson = jsonSql;
	jsonSql = Tools.replace(jsonSql,"\"","\\\\\"");
	boolean isHidden = Boolean.valueOf(Util.null2String(request.getParameter("isHidden")));

	String qname = Util.null2String(request.getParameter("qname"));

	String eventName = Util.null2String(request.getParameter("eventName"));
	String eventCode = Util.null2String(request.getParameter("eventCode"));
	String eventType = Util.null2String(request.getParameter("eventType"));
	String eventWorkFlowName = Util.null2String(request.getParameter("eventWorkFlowName"));

	int eventSearchType = Util.getIntValue(request.getParameter("eventSearchType"), 1);
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			parentDialog.checkDataChange = false;

			function onBtnSearchClick() {
				jQuery("#searchfrm").submit();
			}

			function doAdvancedSearch() {
				jQuery('#topTitle input[name="qname"]').val('');
				jQuery("#searchfrm").submit();
			}

			function doCloseDialog() {
				parentDialog.close();
			}

			function setSelectBoxValue(selector, value) {
				if (value == null) {
					value = jQuery(selector).find('option').first().val();
				}
				jQuery(selector).selectbox('change',value,jQuery(selector).find('option[value="'+value+'"]').text());
			}

			function doReset() {
				//input
				jQuery('#advancedSearchDiv input:text').val('');
				//select
				jQuery('#advancedSearchDiv select').each(function() {
					setSelectBoxValue(this);
				});
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
			if (!isHidden) {
				RCMenu += "{"+SystemEnv.getHtmlLabelName(555,user.getLanguage())+",javascript:selectDone(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{"+SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())+",javascript:selectAll(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="WorkflowHandledMatters.jsp" name="searchfrm" id="searchfrm">
			<input type=hidden name="isHidden" value="<%=isHidden%>">
			<input type=hidden name="isdialog" value="<%=isDialog%>">
			<input type=hidden name="cmd" value="closeDialog">
			<input type=hidden name="fromid" value="<%=fromid%>">
			<input type=hidden name="toid" value="<%=toid%>">
			<input type=hidden name="type" value="<%=_type%>">
			<input type=hidden name="idStr" value="<%=selectedstrs%>">
			<input type=hidden name="isAll" value="<%=isAll%>">
			<input type=hidden name="jsonSql" value="<%=Tools.getURLEncode(oldJson)%>">
			<input type=hidden name="isDelType" value="0">
			<input type=hidden name="selectAllSql" value="">
			<input type=hidden name="needExecuteSql" value="0">
			<input type=hidden name="eventSearchType" value="<%=eventSearchType%>">
			
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%if (!isHidden) {%>
						<input type=button class="e8_btn_top" onclick="selectDone();" value="<%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%>"></input>
						<input type=button class="e8_btn_top" onclick="selectAll();" value="<%=SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())%>"></input>
						<%}%>
						<input type="text" class="searchInput" name="qname" value="<%=qname %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(26876,user.getLanguage())%></wea:item>
						<wea:item> <input type="text" class=InputStyle maxLength=50 size=30 name="eventName" value='<%=eventName%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(19502,user.getLanguage())%></wea:item>
						<wea:item> <input type="text" class=InputStyle maxLength=50 size=30 name="eventCode" value='<%=eventCode%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(33806, user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<select id="eventType" name="eventType">
									<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
									<%
										WorkTypeComInfo.setTofirstRow();
										while(WorkTypeComInfo.next()){
									%>
									<option value="<%=WorkTypeComInfo.getWorkTypeid()%>" <%=eventType.equals(WorkTypeComInfo.getWorkTypeid())?"selected":""%>><%=WorkTypeComInfo.getWorkTypename()%></option>
									<%}%>
								</select>
							</span> 
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelNames("33476,18499",user.getLanguage())%></wea:item>
						<wea:item> <input type="text" class=InputStyle maxLength=50 size=30 name="eventWorkFlowName" value='<%=eventWorkFlowName%>'></wea:item>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="doAdvancedSearch();"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="doReset();"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>
		<%	
			String para2 = "column:requestid+column:workflowid+column:viewtype+0+" + user.getLanguage() + "+column:nodeid+column:isremark+" + fromid
					+ "+column:agentorbyagentid+column:agenttype+column:isprocessed";
			String backfields = " a.requestId as id, a.requestId as requestId, a.workflowId, a.requestName,a.requestnamenew, a.creater, a.creatertype, a.createDate, a.createTime, c.workflowname,b.viewtype,b.nodeid,b.isremark,b.agentorbyagentid,b.agenttype,b.isprocessed "; 
			String fromSql  = " FROM Workflow_CurrentOperator b inner join Workflow_RequestBase a on a.requestId = b.requestId inner join workflow_base c on a.workflowid = c.id ";
			String sqlWhere = " WHERE b.userId = "+fromid+" AND b.isRemark in ('2', '4') AND b.userType = "+(String.valueOf(user.getLogintype()).equals("2") ? 1 : 0)+" and c.isvalid in ('1', '3') AND b.isLastTimes = 1 ";
			String orderby = "" ;
	
			/* 2014-7-31 start */
			switch(eventSearchType) {
				case 2:
					sqlWhere += " AND (b.isComplete <> 1 AND b.agenttype<>1)";
					break;
				case 3:
					sqlWhere += " AND b.isComplete = 1";
					break;
				default:
					sqlWhere += "AND (b.isComplete = 1 OR b.agenttype<>1)";
					break;
			}
			/* 2014-7-31 end */
	
			if(qname.length() > 0 ){
				sqlWhere += " AND a.requestnamenew LIKE '%"+qname+"%' ";
			}else if(eventName.length() > 0){
				sqlWhere += " AND a.requestnamenew LIKE '%"+eventName+"%' ";
			}
			if(eventWorkFlowName.length() > 0){
				sqlWhere += " AND c.workflowname LIKE '%"+eventWorkFlowName+"%' ";
			}
			if(eventCode.length() > 0){
				//sqlWhere += " AND a.creatertype='0' AND d.workcode LIKE '%"+eventCode+"%' ";
				sqlWhere += " AND a.requestmark LIKE '%"+eventCode+"%' ";
			}
			if(eventType.length() > 0){
				sqlWhere += " AND c.workflowtype="+eventType;
			}
			String tableString =" <table pageId=\""+Constants.HRM_Z_011+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_011,user.getUID(),Constants.HRM)+"\" tabletype=\""+(isHidden?"none":"checkbox")+"\">"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.requestId\" sqlsortway=\"DESC\" sqlisdistinct=\"true\"/>"+
			"	<head>"+
			"		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(26876,user.getLanguage())+"\" column=\"requestName\" orderkey=\"requestnamenew\" linkkey=\"requestid\" linkvaluecolumn=\"requestId\" transmethod=\"weaver.general.WorkFlowTransMethod.getWfNewLinkWithTitle\" otherpara=\""+para2+"\" />"+
			"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(882,user.getLanguage())+"\" column=\"creater\" orderkey=\"creater\" transmethod=\"weaver.general.WorkFlowTransMethod.getWFSearchResultName\" otherpara=\"column:creatertype\" />"+
			"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelNames("33476,18499",user.getLanguage())+"\" column=\"workflowname\" orderkey=\"workflowname\"/>"+
			"	</head>"+
			" </table>";
		

			StringBuilder _sql = new StringBuilder();
			_sql.append("select ").append(backfields).append(fromSql).append(sqlWhere);

			rs.executeSql("select count(1) as count from (" + _sql.toString() + ") temp");
			long count = 0;
			if (rs.next()) {
				count = Long.parseLong(Util.null2String(rs.getString("count"), "0"));
			}

			String tempSql = strUtil.encode(_sql.toString());
			_sql.setLength(0);
			_sql.append(tempSql);
			MJson mjson = new MJson(oldJson, true);
			if (mjson.exsit(_type)) {
				selectedstrs = authorityManager.getData("requestid", strUtil.decode(mjson.getValue(_type)));
				mjson.updateArrayValue(_type, _sql.toString());
			} else {
				if(Boolean.valueOf(isAll).booleanValue()) selectedstrs = authorityManager.getData("requestid", strUtil.decode(_sql.toString()));
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
	<%if ("1".equals(isDialog)) {%>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.close();">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
	<%}%>
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
			if (parentDialog) {
				var data = {
					type: '<%=_type%>',
					isAll: false,
					id: id,
					json: '<%=nJson%>'
				};
				parentDialog.callback(data);
				doCloseDialog();
			}
		}

		function selectAll(){
			if (parentDialog) {
				var data = {
					type: '<%=_type%>',
					isAll: true,
					count: <%=count%>,
					json: '<%=oJson%>'
				};
				parentDialog.callback(data);
				doCloseDialog();
			}
		}
	</script>
	</body>
</html>
