
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- added by wcd 2014-09-25 [分部自定义字段] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="cusFieldsManager" class="weaver.hrm.authority.manager.HrmSubcompanyCusFieldsManager" scope="page" />
<%
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelName(33645,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	boolean isHidden = Boolean.valueOf(Util.null2String(request.getParameter("isHidden"),"false"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String fromid=Util.null2String(request.getParameter("fromid"));
	String toid=Util.null2String(request.getParameter("toid"));
	String _type = Util.null2String(request.getParameter("type"));
	String selectedstrs = Util.null2String(request.getParameter("idStr"));
	String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
	String oldJson = jsonSql;
	jsonSql = Tools.replace(jsonSql,"\"","\\\\\"");
	
	String qname = Util.null2String(request.getParameter("qname"));
	String fieldname = Util.null2String(request.getParameter("fieldname"));
	String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			var parentDialog = parent.parent.getDialog(parent);
			
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}

			function doCloseDialog() {
				parentDialog.close();
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
			
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%if(!isHidden){%>
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
						<wea:item><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%></wea:item>
						<wea:item><input type="text" class=InputStyle maxLength=50 size=30 name="fieldname" value='<%=fieldname%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(19799,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="subcompanyid" browserValue='<%=subcompanyid%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=164" width="60%" browserSpanValue='<%=SubCompanyComInfo.getMoreSubCompanyname(subcompanyid)%>' _callback="doProcFrom">
							</brow:browser>
						</wea:item>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>
		<wea:layout type="diycol">
			<wea:group context='<%=SystemEnv.getHtmlLabelNames("15101,356",user.getLanguage())%>' >
				<wea:item attributes="{'isTableList':'true','colspan':'full'}">
					<%
						String tableString =" <table needPage=\"false\" datasource=\"weaver.hrm.authority.manager.HrmSubcompanyCusFieldsManager.getResult\" sourceparams=\"fromid:"+fromid+"+subcompanyid:"+subcompanyid+"+qname:"+qname+"+fieldname:"+fieldname+"\" pageId=\""+Constants.HRM_Q_021+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Q_021,user.getUID(),Constants.HRM)+"\" tabletype=\""+(isHidden?"none":"checkbox")+"\">"+
							" <sql backfields=\"*\" sqlform=\"temp\" sqlwhere=\"\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"/>"+
						"	<head>"+
						"		<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(685,user.getLanguage())+"\" column=\"showName\" orderkey=\"showName\" />"+
						"		<col width=\"45%\" text=\""+SystemEnv.getHtmlLabelName(19799,user.getLanguage())+"\" column=\"subName\" orderkey=\"subName\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmSubCompanyDsp\" linkkey=\"id\" linkvaluecolumn=\"subId\" target=\"_fullwindow\"/>"+
						"	</head></table>";
					%>
					<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' selectedstrs="<%=selectedstrs%>" mode="run" /> 
				</wea:item>
			</wea:group>
		</wea:layout>
		<%
			Map paramMap = new HashMap();
			paramMap.put("fromid",fromid);
			paramMap.put("subcompanyid",subcompanyid);
			paramMap.put("qname",qname);
			paramMap.put("fieldname",fieldname);
			List results = cusFieldsManager.getResult(user,paramMap,request,response);
			StringBuilder _sql = new StringBuilder();
			long count = results==null?0:results.size();
			
			String idStr = "";
			Map map = null;
			for(int i=0; i<count; i++){
				map = (Map)results.get(i);
				idStr += Tools.vString(map.get("id"))+(i==count-1?"":",");
			}

			MJson mjson = new MJson(oldJson, true);
			String nJson = Tools.getURLEncode(mjson.toString());
		%>
<%if("1".equals(isDialog)){ %>
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
			selectDone("<%=idStr%>");
		}
	</script>
	</body>
</html>
