
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- added by wcd 2014-09-19 [角色] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="authorityManager" class="weaver.hrm.authority.manager.AuthorityManager" scope="page"/>
<%
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelName(122,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	boolean isHidden = Boolean.valueOf(Util.null2String(request.getParameter("isHidden"),"false"));
	boolean isHrmFlag = Boolean.valueOf(Util.null2String(request.getParameter("_HRM_FLAG"),"false"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String fromid=Util.null2String(request.getParameter("fromid"));
	String toid=Util.null2String(request.getParameter("toid"));
	String _type = Util.null2String(request.getParameter("type"));
	String isAll = Util.null2String(request.getParameter("isAll"));
	String selectedstrs = Util.null2String(request.getParameter("idStr"));
	String jsonSql = Tools.getURLDecode(request.getParameter("jsonSql"));
	String oldJson = jsonSql;
	jsonSql = Tools.replace(jsonSql,"\"","\\\\\"");
	
	int hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	String qname = Util.null2String(request.getParameter("qname"));
	String rightId = Util.null2String(request.getParameter("rightId"));
	String roleName = Util.null2String(request.getParameter("roleName"));
	String roleMemo = Util.null2String(request.getParameter("roleMemo"));
	String roleMember = Util.null2String(request.getParameter("roleMember"));
	String roleType = Util.null2String(request.getParameter("roleType"));
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
					url = "/hrm/HrmDialogTab.jsp?_fromURL=hrmRoles&method=HrmRolesEdit&nShow=true&isdialog=1&showpage=1&id="+id;
					dialog.Modal = true;
					dialog.maxiumnable = true;
				}else{
					dialog.Title = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(122,user.getLanguage())%>";
					url = "/hrm/HrmDialogTab.jsp?_fromURL=hrmRoles&method=HrmRolesAdd&nShow=true&isdialog=1";
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
						<wea:item><%=SystemEnv.getHtmlLabelName(15068,user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="roleName" name="roleName" class="inputStyle" value='<%=roleName%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="roleMember" browserValue='<%=roleMember %>' 
		          browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
		          hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
		          completeUrl="/data.jsp" browserSpanValue='<%=ResourceComInfo.getLastname(roleMember) %>' >
		          </brow:browser>
		        </wea:item> 
		        <wea:item><%=SystemEnv.getHtmlLabelName(81897,user.getLanguage())%></wea:item>
						<wea:item>
						<%
						String rightname = "";
						if(rightId.length()>0){
							rs.executeSql(" SELECT b.rightname FROM SystemRights a, SystemRightsLanguage b " 
														+ " WHERE a.id = b.id AND languageid = 7 and a.id in( "+rightId+")");
							while(rs.next()){
								if(rightname!="")rightname+=",";
								rightname += rs.getString("rightname");
							}
						}
						%>
							<brow:browser viewType="0" name="rightId" browserValue='<%=rightId %>' 
		          browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRoleRightBrowser.jsp?selectedids="
		          hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
		          completeUrl="/data.jsp?type=HrmRoleRight" browserSpanValue='<%=rightname %>' >
		          </brow:browser>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(85,user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="roleMemo" name="roleMemo" class="inputStyle" value='<%=roleMemo%>'></wea:item>
						<%if(hrmdetachable==1){%>
						<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
						<wea:item>
						<span>
							<select name="roleType" id="roleType" class="inputstyle">
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<option value="0" <%=roleType.equals("0")?"selected":""%>><%=SystemEnv.getHtmlLabelName(17866,user.getLanguage())%></option>
								<option value="1" <%=roleType.equals("1")?"selected":""%>><%=SystemEnv.getHtmlLabelName(17867,user.getLanguage())%></option>
							</select>
						</span>
						</wea:item>
						<%}%>
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
			String backfields = " a.id,a.subcompanyid,a.rolesmark,a.rolesname,a.type,a.cnt,(case when b.result is null then 0 else b.result end) as result ";
			String fromSql = "from (select t1.id,t1.subcompanyid,t2.roleid,t1.rolesmark,t1.rolesname,t1.type,count(t2.roleid) as cnt from hrmroles t1 left join HrmRoleMembers t2 on t1.id=t2.roleid group by t1.id,t1.subcompanyid,t1.rolesmark,t1.rolesname,t1.type,t2.roleid) a left join (select t1.roleid,COUNT(*) as result from systemrightroles t1 left join SystemRightToGroup t2 on t1.rightid = t2.rightid left join SystemRightGroups t3 on t2.groupid = t3.id group by t1.roleid) b on a.id = b.roleid";
			String sqlWhere = " where a.id in ( select roleid from hrmrolemembers where resourceid = "+fromid+" ) and a.type = 0 ";
			String orderby = "" ;
			if(isHrmFlag){
				backfields = " a.*,b.result ";
				fromSql = " from (select a.*,b.rolelevel,b.resourceid from hrmroles a left join HrmRoleMembers b on a.id=b.roleid ) a left join (select t1.roleid,COUNT(*) as result from systemrightroles t1 left join SystemRightToGroup t2 on t1.rightid = t2.rightid left join SystemRightGroups t3 on t2.groupid = t3.id group by t1.roleid ) b on a.id = b.roleid ";
				sqlWhere = " where a.resourceid = "+fromid+" and a.type = 0 ";
			}
			if(qname.length() > 0 ){
				sqlWhere += " and a.rolesmark like '%"+qname+"%' ";
			}
			if(roleName.length() > 0){
				sqlWhere += " and a.rolesmark like '%"+roleName+"%' ";
			}
			if(rightId.length() > 0){
				sqlWhere += " and a.id in (SELECT distinct roleid FROM systemrightroles where rightid in ( "+rightId+")) ";
			}
			if(roleMember.length() > 0){
				sqlWhere += " and a.id in ( select roleid from hrmrolemembers where resourceid = "+roleMember+" )";
			}
			if(roleMemo.length() > 0){
				sqlWhere += " and a.rolesname like '%"+roleMemo+"%' ";
			}
			String tableString =" <table pageId=\""+Constants.HRM_Z_021+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_021,user.getUID(),Constants.HRM)+"\" tabletype=\""+(isHidden?"none":"checkbox")+"\">"+
			" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
			"	<head>";
			if(isHrmFlag){
				tableString +=
			"		<col width=\"45%\" text=\""+SystemEnv.getHtmlLabelName(15068,user.getLanguage())+"\" column=\"rolesmark\" orderkey=\"rolesmark\"/>" +
			"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelNames("17864,1331",user.getLanguage())+"\" column=\"result\"/>" + 
			"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelNames("431,139",user.getLanguage())+"\" column=\"rolelevel\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+";0=124,1=141,default=140]}\"/>";
			} else {
				tableString += 
			"		<col width=\"45%\" text=\""+SystemEnv.getHtmlLabelName(15068,user.getLanguage())+"\" column=\"rolesmark\" orderkey=\"rolesmark\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmRolesA\" otherpara=\"column:id\"/>" +
			"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelNames("17864,1331",user.getLanguage())+"\" column=\"result\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmRolesC\" otherpara=\"column:id\"/>" + 
			"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelNames("431,1331",user.getLanguage())+"\" column=\"cnt\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmRolesD\" otherpara=\"column:id\"/>";
			}
			tableString += "	</head>" +
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
