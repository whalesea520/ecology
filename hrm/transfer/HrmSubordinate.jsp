
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
	
	boolean isHidden = Boolean.valueOf(Util.null2String(request.getParameter("isHidden"),"false"));
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
	String hrmName = Util.null2String(request.getParameter("hrmName"));
	String hrmJobtitle = Util.null2String(request.getParameter("hrmJobtitle"));
	String hrmDepartment = Util.null2String(request.getParameter("hrmDepartment"));
	String hrmSubcompany = Util.null2String(request.getParameter("hrmSubcompany"));
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			var parentDialog = parent.parent.getDialog(parent);
			var dialog = null;

			function openDialog(id){
				if(dialog==null){
					dialog = new window.top.Dialog();
				}
				dialog.currentWindow = window;
				var url = "";
				if(id && id!=""){
					dialog.Title = "<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())+SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>";
					url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmJobTitlesEdit&id="+id;
				}else{
					dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(6086,user.getLanguage())%>";
					url = "/hrm/HrmDialogTab.jsp?_fromURL=HrmJobTitlesAdd&departmentid=<%=fromid%>";
				}
				dialog.Width = 700;
				dialog.Height = 593;
				dialog.Drag = true;
				dialog.URL = url;
				dialog.show();
			}
			
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
			<input type=hidden name="isAll" value="<%=isAll%>">
			<input type=hidden name="isHidden" value="<%=Tools.vString(isHidden)%>">
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
						<wea:item><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></wea:item>
						<wea:item><input type="text" class=InputStyle maxLength=50 size=30 name="hrmName" value='<%=hrmName%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="hrmJobtitle" browserValue='<%=hrmJobtitle%>'
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/jobtitles/JobTitlesBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=hrmjobtitles" width="60%" browserSpanValue='<%=JobTitlesComInfo.getJobTitlesname(hrmJobtitle)%>'>
							</brow:browser>		 
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="hrmDepartment" browserValue='<%=hrmDepartment%>' browserOnClick=""
								browserurl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/MutiDepartmentBrowser.jsp?excludeid=&selectedids="
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=4" width="60%" browserSpanValue='<%=DepartmentComInfo.getDepartmentname(hrmDepartment)%>'>
							</brow:browser>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="hrmSubcompany" browserValue='<%=hrmSubcompany%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser3.jsp?excludeid="
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=164" width="60%" browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(hrmSubcompany)%>'>
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
		<%
			String backfields = " a.id,a.lastname,a.jobtitle,a.departmentid,a.subcompanyid1,a.managerid,a.dsporder,b.jobtitlename "; 
			String fromSql  = " from HrmResource a left join HrmJobTitles b on a.jobtitle = b.id ";
			String sqlWhere = " where a.managerid = "+fromid+" and (a.status between 0  and 3) ";
			String orderby = " a.dsporder,a.lastname " ;
			
			if(qname.length() > 0 ){
				sqlWhere += " and a.lastname like '%"+qname+"%' ";
			}else if(hrmName.length() > 0){
				sqlWhere += " and a.lastname like '%"+hrmName+"%' ";
			}
			if(hrmJobtitle.length() > 0){
				sqlWhere += " and a.jobtitle  = "+hrmJobtitle;
			}				
			if(hrmDepartment.length() > 0){
				sqlWhere += " and a.departmentid  = "+hrmDepartment;
			}
			if(hrmSubcompany.length() > 0){
				sqlWhere += " and a.subcompanyid1  = "+hrmSubcompany;
			}
			String operateString= "";
			String tableString =" <table pageId=\""+Constants.HRM_Z_011+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_011,user.getUID(),Constants.HRM)+"\" tabletype=\""+(isHidden?"none":"checkbox")+"\">"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
			operateString+
			"	<head>"+
			"		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"id\" orderkey=\"lastname\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getName\" otherpara=\"1\" />"+
			"		<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitlename\" orderkey=\"jobtitlename\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmOpenDialogName\" otherpara=\"column:jobtitle\"/>"+
			"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDsp\" linkkey=\"id\" linkvaluecolumn=\"departmentid\" target=\"_fullwindow\"/>"+
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
