
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- added by wcd 2014-09-12 [下属] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="authorityManager" class="weaver.hrm.authority.manager.AuthorityManager" scope="page"/>
<%
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelName(442,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String fromid=Util.null2String(request.getParameter("fromid"));
	String toid=Util.null2String(request.getParameter("toid"));
	String _type = Util.null2String(request.getParameter("type"));
	String selectedstrs = Util.null2String(request.getParameter("idStr"));
	String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
	String isHidden = Util.null2String(request.getParameter("isHidden"));
	String isAll = Util.null2String(request.getParameter("isAll"));
	String oldJson = jsonSql;
	jsonSql = Tools.replace(jsonSql,"\"","\\\\\"");
	
	String qname = Util.null2String(request.getParameter("qname"));

%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			//var parentWin = parent.parent.getParentWindow(parent);
			var dialog = top.getDialog(window);
			
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}

			function doCloseDialog() {
				dialog.close();
			}
		</script>
	</head>
	<BODY>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="portal"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(84135,user.getLanguage())%>"/> 
		</jsp:include>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(!"true".equals(isHidden)){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(555,user.getLanguage())+",javascript:selectDone(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{"+SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())+",javascript:selectAll(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
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
			<input type=hidden name="isAll" value="<%=isAll%>">
			<input type=hidden name="isHidden" value="<%=Tools.vString(isHidden)%>">

			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%if(!"true".equals(isHidden)){%>
							<input type=button class="e8_btn_top" onclick="selectDone();" value="<%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%>"></input>
							<input type=button class="e8_btn_top" onclick="selectAll();" value="<%=SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())%>"></input>
						<%}%>
						<input type="text" class="searchInput" name="qname" value="<%=qname %>"/>
						<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			
		</form>
		<%
			String backfields = " a.dirid,b.id,b.infoname,b.subcompanyid "; 
			String fromSql  = " from ptAccessControlList a inner join hpinfo b on a.dirid=b.id ";
			String sqlWhere = "";
			if(_type.equalsIgnoreCase("C181IdStr")||_type.equalsIgnoreCase("T191IdStr")||_type.equalsIgnoreCase("D161IdStr")){
				sqlWhere = "where a.userid = "+fromid+" "; 
			}else if(_type.equalsIgnoreCase("C261IdStr")||_type.equalsIgnoreCase("T241IdStr")||_type.equalsIgnoreCase("D241IdStr")){
				sqlWhere = "where a.departmentid = "+fromid+" "; 
			}else if(_type.equalsIgnoreCase("C361IdStr")||_type.equalsIgnoreCase("T341IdStr")||_type.equalsIgnoreCase("D341IdStr")){
				sqlWhere = "where a.subcompnayid = "+fromid+" ";
				
			}else if(_type.equalsIgnoreCase("C451IdStr")||_type.equalsIgnoreCase("T431IdStr")||_type.equalsIgnoreCase("D431IdStr")){
				sqlWhere = "where a.roleid = "+fromid+" ";
			}
			
			String orderby = " a.dirid,b.infoname " ;
			
			if(qname.length() > 0 ){
				sqlWhere += " and b.infoname like '%"+qname+"%' ";
			}
			String tabletype="none";
			if(!"true".equals(isHidden)){
				tabletype ="checkbox";
			}
			String operateString= "";
			String tableString =" <table pageId=\""+Constants.HRM_Z_011+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_011,user.getUID(),Constants.HRM)+"\" tabletype=\""+tabletype+"\">"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.dirid\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
			operateString+
			"	<head>"+
			"		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"infoname\" orderkey=\"infoname\" linkvaluecolumn=\"dirid\"  linkkey=\"dirid\" />"+
			"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" />"+
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
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
		<wea:item type="toolbar">
	     <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel();"/>
		</wea:item>
	</wea:group>
	</wea:layout>
</div>	
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
	<script type="text/javascript">
		jQuery(document).ready(function(){
			resizeDialog(document);
		});
	</script>
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
		
		function onCancel(){
			top.getDialog(window).close();
		}
	</script>
	</body>
</html>
