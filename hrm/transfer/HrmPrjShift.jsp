<%@page import="weaver.proj.util.SQLUtil"%>
<%@page import="weaver.proj.util.PropUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ProjectStatusComInfo" class="weaver.proj.Maint.ProjectStatusComInfo" scope="page" />
<jsp:useBean id="ProjectTypeComInfo" class="weaver.proj.Maint.ProjectTypeComInfo" scope="page" />
<jsp:useBean id="XssUtil" class="weaver.filter.XssUtil" scope="page"/>
<%
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelName(122,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	boolean onlyQuery = "true".equalsIgnoreCase( Util.null2String(request.getParameter("onlyQuery")));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String fromid=Util.null2String(request.getParameter("fromid"));
	String toid=Util.null2String(request.getParameter("toid"));
	String _type = Util.null2String(request.getParameter("type"));
	String selectedstrs = Util.null2String(request.getParameter("idStr"));
	String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
	String oldJson = jsonSql;
	jsonSql = Tools.replace(jsonSql,"\"","\\\\\"");
	String isAll = Util.null2String(request.getParameter("isAll"));
	String qname = Util.null2String(request.getParameter("qname"));
	String prjname = Util.null2String(request.getParameter("prjname"));
	String prjtype = Util.null2String(request.getParameter("prjtype"));
	String prjstatus = Util.null2String(request.getParameter("prjstatus"));
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
			
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}

			function doCloseDialog() {
				parentDialog.close();
			}
			
			var dialog = null;
			var dWidth = 700;
			var dHeight = 500;
			function doOpen(url,title,_dWidth,_dHeight){
				if(dialog==null){
					dialog = new window.top.Dialog();
				}
				dialog.currentWindow = window;
				dialog.Title = title;
				dialog.Width = _dWidth ? _dWidth : dWidth;
				dialog.Height = _dHeight ? _dHeight : dHeight;
				dialog.Drag = true;
				dialog.maxiumnable = true;
				dialog.URL = url;
				dialog.show();
			}
			function toAuthList(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmRoles&method=HrmRolesEdit&isdialog=1&showpage=2&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(122,user.getLanguage())%>");
			}
			function toMemList(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmRoles&method=HrmRolesEdit&isdialog=1&showpage=3&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(122,user.getLanguage())%>");
			}
			function openDialog(id){
				if(window.top.Dialog){
					dialog = new window.top.Dialog();
				} else {
					dialog = new Dialog();
				}
				dialog.currentWindow = window;
				if(id == null){
					id = "";
				}
				var url = "";
				if(!!id){
					dialog.Title = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(122,user.getLanguage())%>";
					url = "/hrm/HrmDialogTab.jsp?_fromURL=hrmRoles&method=HrmRolesEdit&isdialog=1&showpage=1&id="+id;
					dialog.Modal = true;
					dialog.maxiumnable = true;
				}else{
					dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(122,user.getLanguage())%>";
					url = "/hrm/HrmDialogTab.jsp?_fromURL=hrmRoles&method=HrmRolesAdd&isdialog=1";
					dialog.Drag = true;
				}
				dialog.Width = dWidth;
				dialog.Height = dHeight;
				dialog.URL = url;
				dialog.show();
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
		if(!onlyQuery){
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
			<input type=hidden name="onlyQuery" value="<%=""+onlyQuery %>">
			<input type=hidden name="isAll" value="<%=isAll%>">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
					<%
					if(!onlyQuery){
						%>
						<input type=button class="e8_btn_top" onclick="selectDone();" value="<%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%>"></input>
						<input type=button class="e8_btn_top" onclick="selectAll();" value="<%=SystemEnv.getHtmlLabelNames("172,332",user.getLanguage())%>"></input>
						<%
					}
					%>
						<input type="text" class="searchInput" name="qname" value="<%=qname %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(1353,user.getLanguage())%></wea:item>
						<wea:item><input type="text" class=InputStyle maxLength=50 size=30 name="prjname" value='<%=prjname %>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(586,user.getLanguage())%></wea:item>
						<wea:item>
								<brow:browser viewType="0" name="prjtype" 
								browserValue='<%=prjtype %>' browserSpanValue='<%=Util.getIntValue( prjtype)>0?ProjectTypeComInfo.getProjectTypename(""+prjtype):"" %>' 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/Maint/ProjectTypeBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=244" />
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(587,user.getLanguage())%></wea:item>
						<wea:item>
							<select class="InputStyle" name='prjstatus' >
				    			<option value="" ><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
				    		<%
			              		while(ProjectStatusComInfo .next()){
			              			String tmpid= ProjectStatusComInfo.getProjectStatusid();
			              			String tmpname=ProjectStatusComInfo.getProjectStatusdesc();
			              		%>	
			              		<option value="<%=tmpid %>" <%=prjstatus.equals(tmpid)?"selected":"" %> ><%=tmpname %></option>
			              		<%
			              		}
			              	%>
				    		</select>
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
			String backfields = " t1.id,t1.name,t1.status,t1.prjtype "; 
			String fromSql = "from Prj_ProjectInfo t1";
			String sqlWhere = " where 1=1 ";
			if(_type.startsWith("T111")){//负责项目
				sqlWhere+=" and t1.manager='"+fromid+"' ";
			}else if(_type.startsWith("T112")||_type.startsWith("C111")){//参与项目
				sqlWhere+=SQLUtil.filteSql(rs.getDBType()," and ','+members+',' like '%,"+fromid+",%' ");
			}else if(_type.startsWith("C112")||_type.startsWith("D181")){//可查看项目(人)
				sqlWhere+=" and exists(select 1 from Prj_ShareInfo t2 where t1.id=t2.relateditemid and t2.sharetype=1 and t2.userid='"+fromid+"' ) ";
			}else if(_type.startsWith("C221")||_type.startsWith("D261")){//可查看项目(部门)
				sqlWhere+=" and exists(select 1 from Prj_ShareInfo t2 where t1.id=t2.relateditemid and t2.sharetype=2 and t2.departmentid='"+fromid+"' ) ";
			}else if(_type.startsWith("C321")||_type.startsWith("D361")){//可查看项目(分部)
				sqlWhere+=" and exists(select 1 from Prj_ShareInfo t2 where t1.id=t2.relateditemid and t2.sharetype=5 and t2.subcompanyid='"+fromid+"' ) ";
			}else if(_type.startsWith("C411")||_type.startsWith("D451")){//可查看项目(角色)
				sqlWhere+=" and exists(select 1 from Prj_ShareInfo t2 where t1.id=t2.relateditemid and t2.sharetype=3 and t2.roleid='"+fromid+"' ) ";
			}else if(_type.startsWith("C511")||_type.startsWith("D511")){//可查看项目(岗位)
				sqlWhere+=" and exists(select 1 from Prj_ShareInfo t2 where t1.id=t2.relateditemid and t2.sharetype=11 and t2.jobtitleid='"+fromid+"' ) ";
			}
			
			
			String orderby = "" ;
			
			if(qname.length() > 0 ){
				sqlWhere += " and t1.name like '%"+qname+"%' ";
			}else if(prjname.length() > 0){
				sqlWhere += " and t1.name like '%"+prjname+"%' ";
			}
			
			if(prjstatus.length()>0){
				sqlWhere += " and t1.status='"+prjstatus+"' ";
			}
			if(prjtype.length()>0){
				sqlWhere += " and t1.prjtype='"+prjtype+"' ";
			}
			
			
			String pageId=Util.null2String(PropUtil.getPageId("prj_hrmprjshifter"));
			String tableString =" <table pageId=\""+pageId+"\" pagesize=\""+PageIdConst.getPageSize(pageId,user.getUID(),"prj")+"\" tabletype=\""+(onlyQuery?"none":"checkbox")+"\">"+
			" <sql backfields=\""+backfields+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
			"	<head>"+
			"		<col width=\"45%\" text=\""+SystemEnv.getHtmlLabelName(1353,user.getLanguage())+"\" column=\"id\" orderkey=\"name\" otherpara=\"column:name+column:status+"+user.getLanguage()+"+column:begindate+column:enddate\"  transmethod='weaver.proj.util.ProjectTransUtil.getPrjName'  />"+
			"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelNames("586",user.getLanguage())+"\" column=\"prjtype\" orderkey=\"prjtype\" transmethod=\"weaver.proj.Maint.ProjectTypeComInfo.getProjectTypename\" />"+
			"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelNames("587",user.getLanguage())+"\" column=\"status\" orderkey=\"status\" transmethod=\"weaver.proj.Maint.ProjectStatusComInfo.getProjectStatusdesc\" />"+
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
				selectedstrs = "";
				rs.executeSql(strUtil.decode(mjson.getValue(_type)));
				while(rs.next()) selectedstrs += rs.getString("id")+",";
				if(selectedstrs.endsWith(",")) selectedstrs = selectedstrs.substring(0, selectedstrs.length() - 1);
				mjson.updateArrayValue(_type, _sql.toString());
			} else {
				mjson.putArrayValue(_type, _sql.toString());
			}
			String oJson = Tools.getURLEncode(mjson.toString());
			mjson.removeArrayValue(_type);
			String nJson = Tools.getURLEncode(mjson.toString());
		%>
		<script>
			$GetEle("selectAllSql").value = encodeURI("<%=XssUtil.put( _sql.toString()) %>");
		</script>
		<wea:SplitPageTag  isShowTopInfo="false" tableString='<%=tableString%>' selectedstrs="<%=selectedstrs%>" mode="run" /> 
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
			//window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22161,user.getLanguage())%>",function(){
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
			//});
		}

		function selectAll(){
			//window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(22161,user.getLanguage())%>",function(){
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
			//});
		}
	</script>
	</body>
</html>
