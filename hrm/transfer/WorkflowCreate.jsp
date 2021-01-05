
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="WorkTypeComInfo" class="weaver.workflow.workflow.WorkTypeComInfo" scope="page" />
<jsp:useBean id="authorityManager" class="weaver.hrm.authority.manager.AuthorityManager" scope="page"/>
<%
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelNames("18499", user.getLanguage());
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

	String qname = Util.null2String(request.getParameter("qname"));

	String workflowName = Util.null2String(request.getParameter("workflowName"));
	String workflowType = Util.null2String(request.getParameter("workflowType"));
	String gdtype = Util.null2String(request.getParameter("gdtype"));
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
			RCMenu += "{"+SystemEnv.getHtmlLabelName(555,user.getLanguage())+",javascript:selectDone(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
			RCMenu += "{"+SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())+",javascript:selectAll(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="WorkflowCreate.jsp" name="searchfrm" id="searchfrm">
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
			<input type=hidden name="gdtype" value="<%=gdtype%>">

			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<input type=button class="e8_btn_top" onclick="selectDone();" value="<%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%>"></input>
						<input type=button class="e8_btn_top" onclick="selectAll();" value="<%=SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())%>"></input>
						<input type="text" class="searchInput" name="qname" value="<%=qname%>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelNames("18499,33439",user.getLanguage())%></wea:item>
						<wea:item><input type="text" class=InputStyle maxLength=50 size=30 name="workflowName" value='<%=workflowName%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(33806, user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<select name="workflowType">
									<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
									<%
										WorkTypeComInfo.setTofirstRow();
										while(WorkTypeComInfo.next()){
									%>
									<option value="<%=WorkTypeComInfo.getWorkTypeid()%>" <%=workflowType.equals(WorkTypeComInfo.getWorkTypeid())?"selected":""%>><%=WorkTypeComInfo.getWorkTypename()%></option>
									<%}%>
								</select>
							</span> 
						</wea:item>
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
			String para2 = "";
			String backfields = " wfb.id,wfb.workflowname AS workflowname,wft.typename AS typename"; 
			String fromSql  = " FROM workflow_base wfb INNER JOIN workflow_type wft ON wft.id=wfb.workflowtype INNER JOIN workflow_flownode wffn ON wffn.workflowid=wfb.id INNER JOIN workflow_nodegroup wfng ON wfng.nodeid=wffn.nodeid INNER JOIN workflow_groupdetail wfgd ON wfgd.groupid=wfng.id";
			String sqlWhere = "";
			if(gdtype.equals("58")){//岗位
				sqlWhere = " WHERE wffn.nodetype='0' AND wfgd.type='"+gdtype+"' ";
				if (rs.getDBType().equals("oracle")||rs.getDBType().equals("db2")){
					sqlWhere += " and ','||to_char(wfgd.jobobj)||',' like '%,"+fromid+",%' ";
	    		}else{
	    			sqlWhere += " and ','+convert(varchar,wfgd.jobobj)+',' like '%,"+fromid+",%' ";
	    		}
			}else{
				sqlWhere = " WHERE wffn.nodetype='0' AND wfgd.type='"+gdtype+"' AND wfgd.objid='"+fromid+"'";
			}
			String orderby = "" ;

			if (!qname.isEmpty()) {
				sqlWhere += " AND wfb.workflowname like '%"+qname+"%'";
			} else if (!workflowName.isEmpty()) {
				sqlWhere += " AND wfb.workflowname like '%"+workflowName+"%'";
			}
			if (!workflowType.isEmpty()) {
				sqlWhere += " AND wfb.workflowtype="+workflowType;
			}
			String tableString =" <table pageId=\""+Constants.HRM_Z_011+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_011,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlorderby=\""+orderby+"\" sqlprimarykey=\"wfb.id\" sqlsortway=\"DESC\" sqlisdistinct=\"\"/>"+
			"	<head>"+
			"		<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelNames("18499,33439",user.getLanguage())+"\" column=\"workflowname\" orderkey=\"workflowname\" />"+
			"		<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(33806,user.getLanguage())+"\" column=\"typename\" orderkey=\"typename\" />"+
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
