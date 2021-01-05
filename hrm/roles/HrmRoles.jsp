
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-06-26 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<% 	
	if(!(user.getLogintype()).equals("1")) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	if(!HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user)){
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(16527,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String cmd = Util.null2String(request.getParameter("cmd"));
	String id = Util.null2String(request.getParameter("id"));

	String rolesnameq = Util.null2String(request.getParameter("rolesnameq"));
	String qname = Util.null2String(request.getParameter("flowTitle"));
	if(qname.length()>0&&rolesnameq.length()==0)rolesnameq=qname;
	String rightId = Util.null2String(request.getParameter("rightId"));
	String roleName = Util.null2String(request.getParameter("roleName"));
	if(qname.length()==0 && roleName.length()>0)qname = roleName;
	if(roleName.length()==0&&qname.length()>0)roleName=qname;
	String roleMemo = Util.null2String(request.getParameter("roleMemo"));
	String roleMember = Util.null2String(request.getParameter("roleMember"));
	String roleType = Util.null2String(request.getParameter("roleType"));

	int subCompanyId= 0;
	int operatelevel= 0;
	
	if(Util.null2String(ManageDetachComInfo.getDetachable()).equals("1")){ 
		session.setAttribute("detachable","1");
	}else{
		session.setAttribute("detachable","0");
	}
	
	int dftsubcomid = 0;
	rs.executeProc("SystemSet_Select","");
	if(rs.next()){
		dftsubcomid = Util.getIntValue(rs.getString("dftsubcomid"), 0);
	}
	
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	
	int hrmdetachable=detachable;
	if(hrmdetachable==1){
		if(Util.null2String(request.getParameter("subCompanyId")).trim().length()==0){
			//subCompanyId=dftsubcomid;//Util.getIntValue(String.valueOf(session.getAttribute("role_subCompanyId")),-1);
		}else{
			subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
		}
		session.setAttribute("role_subCompanyId",String.valueOf(subCompanyId));
		operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmRolesAdd:Add",subCompanyId);
	}else{
		if(HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user))
			operatelevel=2;
	}
%>

<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
		try{
			parent.setTabObjName("<%=titlename%>");
		}catch(e){
		}
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}
			
			var dialog = null;
			var dWidth = 700;
			var dHeight = 500;
			function closeDialog(){
				if(dialog){
					dialog.close();
					onBtnSearchClick();
				}
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
					dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,122",user.getLanguage())%>";
					url = "/hrm/HrmDialogTab.jsp?_fromURL=hrmRoles&method=HrmRolesEdit&isdialog=1&showpage=1&id="+id;
					dialog.Modal = true;
					dialog.maxiumnable = true;
				}else{
					dialog.Title = "<%=SystemEnv.getHtmlLabelNames("82,122",user.getLanguage())%>";
					url = "/hrm/HrmDialogTab.jsp?_fromURL=hrmRoles&method=HrmRolesAdd&isdialog=1&subCompanyId=<%=subCompanyId%>&showpage=0";
					dialog.Drag = true;
				}
				dialog.Width = dWidth;
				dialog.Height = dHeight;
				dialog.URL = url;
				dialog.show();
			}
			
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
		
			function doDel(id){
				if(!id){
					id = _xtable_CheckedCheckboxId();
				}
				if(!id){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>");
					return;
				}
				if(id.match(/,$/)){
					id = id.substring(0,id.length-1);
				}
				window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
					var idArr = id.split(",");
					var ajaxNum = 0;
					var ajaxNum = 0;
					for(var i=0;i<idArr.length;i++){
						ajaxNum++;
						jQuery.ajax({
							url:"HrmRolesOperation.jsp?isdialog=1&operationType=Delete&id="+idArr[i],
							type:"post",
							async:true,
							complete:function(xhr,status){
								ajaxNum--;
								if(ajaxNum==0){
									_table.reLoad();
								}
							}
						});
					}
				});
			}
			function toAuthList(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmRoles&method=HrmRolesEdit&isdialog=1&showpage=2&id="+id,"<%=SystemEnv.getHtmlLabelNames("93,122",user.getLanguage())%>");
			}
			function toMemList(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmRoles&method=HrmRolesEdit&isdialog=1&showpage=3&id="+id,"<%=SystemEnv.getHtmlLabelNames("93,122",user.getLanguage())%>");
			}
			function toCompanyList(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmRoles&method=HrmRolesEdit&isdialog=1&showpage=4&id="+id,"<%=SystemEnv.getHtmlLabelNames("93,122",user.getLanguage())%>");
			}
			if("<%=cmd.length()>0%>" == "true"){
				if('<%=cmd%>' == 'a'){
					openDialog('<%=id%>');
				}else if('<%=cmd%>' == 'b'){
					toCompanyList('<%=id%>');
				}else if('<%=cmd%>' == 'c'){
					toAuthList('<%=id%>');
				}else if('<%=cmd%>' == 'd'){
					toMemList('<%=id%>');
				}
			}
			function showLog(id){
				var url = "";
				if(id && id!=""){
					url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=16 and relatedid=")%>&relatedid="+id;
				}else{
					url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=16")%>";
				}
				doOpen(url,"<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
			}
		</script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(operatelevel>0){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:openDialog();,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(HrmUserVarify.checkUserRight("HrmRolesEdit:Delete", user)){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(operatelevel>0){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showLog();,_self} " ;
			    RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%
							if(operatelevel>0){ 
						%>
								<input type=button class="e8_btn_top" onclick="openDialog();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
						<%	
							}
							if(HrmUserVarify.checkUserRight("HrmRolesEdit:Delete", user)&&operatelevel>0){ 
						%>
								<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
						<%	} %>
						<input type="text" class="searchInput" id="flowTitle" name="flowTitle" value="<%=qname %>" onchange="setKeyword('flowTitle','roleName','searchfrm');"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
		<form action="" name="searchfrm" id="searchfrm">
		<input type="hidden" name="subCompanyId" value="<%=subCompanyId%>">
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
			String backFields=Util.toHtmlForSplitPage("a.id,a.subcompanyid,a.rolesmark,a.rolesname,a.type,a.isdefault,a.cnt,a.cnt1,a.cnt2,a.cnt3,a.cnt4,a.cnt5,a.cnt6,a.cnt7,a.cnt8,(case when b.result is null then 0 else b.result end) as result");
			String sqlFrom = "from (select t1.id,t1.subcompanyid,t2.roleid,t1.rolesmark,t1.rolesname,t1.type,"+(rs.getDBType().equals("oracle") ? "nvl(t1.isdefault,0)" : "ISNULL(t1.isdefault,0)")+" as isdefault,count(t2.roleid) as cnt,(select COUNT(id) from workflow_groupdetail where type = 2 and objid = t1.id) as cnt1,(select COUNT(id) from HrmGroupShare where sharetype = 4 and roleid = t1.id) as cnt2,(select COUNT(id) from VotingShare where sharetype = 4 and roleid = t1.id) as cnt3, (select count(o.id) from(select id,sharevalue val from OfUserRoleExp where (sharetype = 3 ) or (tosharetype = 3 and tosharevalue = 1081) union select id,tosharevalue val from OfUserRole where (sharetype = 3 and sharevalue = 8) or (tosharetype = 3 )) o where o.val = t1.id) as cnt4,(select COUNT(id) from WorkPlanShareSet where sharetype = 4 and roleid = t1.id) as cnt5,(select COUNT(id) from PluginLicenseUser where sharetype = 3 and sharevalue = t1.id) as cnt6,(select COUNT(id) from coworkshare where type=4 and "+(rs.getDBType().equals("oracle") ? "instr(content,','||t1.id,1,1) > 0" : "charindex(','+CAST(t1.id as varchar),content) > 0")+") as cnt7,(select COUNT(id) from VotingViewer where sharetype = 4 and roleid = t1.id) as cnt8 from hrmroles t1 left join HrmRoleMembers t2 on t1.id=t2.roleid ";
			sqlFrom += "where 1=1 ";
			String defaultSql = "";
			if(hrmdetachable==1){
				int[] companyids = CheckSubCompanyRight.getSubComByUserRightId(user.getUID(),"HrmRolesAdd:Add");
				String companyid = "";
				if(user.getUID() != 1){
					for(int i=0;companyids!=null&&i<companyids.length;i++){
						companyid += ","+companyids[i];
					}
					if(companyid.length() > 0){
						companyid = companyid.substring(1);
					}
				}
				if(subCompanyId != 0){
					sqlFrom += " and t1.subcompanyid="+subCompanyId;
					if(companyid.length() > 0 ){
						defaultSql += " and a.subcompanyid in("+companyid+")";
					}
				}else{
					if(companyid.length() > 0 ){
						defaultSql += " and a.subcompanyid in("+companyid+")";
					}
				}
				if(rolesnameq.length() > 0){
					sqlFrom += " and t1.rolesmark like '%"+rolesnameq+"%' ";
				}
				if(roleType.length() > 0){
					sqlFrom += " and t1.type="+roleType;
				}
			}else{
				sqlFrom += " and t1.type=0 ";
				if(!"".equals(rolesnameq)){
					sqlFrom += " and t1.rolesmark like '%"+rolesnameq+"%' ";
				}
			}
			
			sqlFrom += " group by t1.id,t1.subcompanyid,t1.rolesmark,t1.rolesname,t1.type,t1.isdefault,t2.roleid) a left join (select t1.roleid,COUNT(*) as result from systemrightroles t1 left join SystemRightToGroup t2 on t1.rightid = t2.rightid left join SystemRightGroups t3 on t2.groupid = t3.id group by t1.roleid) b on a.id = b.roleid ";
			sqlFrom=Util.toHtmlForSplitPage(sqlFrom);
			String sqlWhere = " where 1 = 1";
			if(defaultSql.length() > 0){
				sqlWhere += defaultSql;
			}
			if(rightId.length() > 0){
				sqlWhere += " and a.id in (SELECT distinct roleid FROM systemrightroles where rightid in ( "+rightId+")) ";
			}
			if(qname.length() > 0){
				sqlWhere += " and a.rolesmark like '%"+qname+"%'";
			}else if(roleName.length() > 0){
				sqlWhere += " and a.rolesmark like '%"+roleName+"%'";
			}
			if(roleMember.length() > 0){
				sqlWhere += " and a.id in ( select roleid from hrmrolemembers where resourceid = "+roleMember+" )";
			}
			if(roleMemo.length() > 0){
				sqlWhere += " and a.rolesname like '%"+roleMemo+"%'";
			}
			String orderBy = "id";
			String colString;
			String operateString= "<operates width=\"20%\">";
			operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\""+HrmUserVarify.checkUserRight("HrmRolesEdit:Edit", user)+":+column:cnt+==0andcolumn:cnt1+==0andcolumn:cnt2+==0andcolumn:cnt3+==0andcolumn:cnt4+==0andcolumn:cnt5+==0andcolumn:cnt6+==0andcolumn:cnt7+==0andcolumn:cnt8+==0andcolumn:isdefault+==0and"+(HrmUserVarify.checkUserRight("HrmRolesEdit:Delete", user)&&operatelevel>0)+":"+String.valueOf(operatelevel>0)+":"+HrmUserVarify.checkUserRight("HrmRolesEdit:Edit", user)+":"+HrmUserVarify.checkUserRight("HrmRolesEdit:Edit", user)+(hrmdetachable==1?(":"+HrmUserVarify.checkUserRight("HrmRolesEdit:Edit", user)):"")+"\"></popedom> ";
			operateString+="     <operate href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
			operateString+="     <operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
			operateString+="     <operate href=\"javascript:showLog();\" text=\""+SystemEnv.getHtmlLabelName(83,user.getLanguage())+"\" index=\"2\"/>";
			operateString+="     <operate href=\"javascript:toAuthList();\" text=\""+SystemEnv.getHtmlLabelName(17864,user.getLanguage())+"\" index=\"3\"/>";
			if(hrmdetachable==1){
				operateString+=" <operate href=\"javascript:toCompanyList();\" text=\""+SystemEnv.getHtmlLabelName(17865,user.getLanguage())+"\" index=\"5\"/>";
			}
			operateString+="     <operate href=\"javascript:toMemList();\" text=\""+(SystemEnv.getHtmlLabelName(431,user.getLanguage())+SystemEnv.getHtmlLabelName(320,user.getLanguage()))+"\" index=\"4\"/>";
			operateString+="</operates>";
			
			if(hrmdetachable==1){
				colString ="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(32011,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmRolesA\" otherpara=\"column:id\"/>";
				colString +="<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15068,user.getLanguage())+"\" column=\"rolesmark\" orderkey=\"rolesmark\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmRolesA\" otherpara=\"column:id\"/>";
				colString +="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"type\" orderkey=\"type\" transmethod=\"weaver.hrm.roles.RolesComInfo.getRoleTypeName\" otherpara=\""+user.getLanguage()+"\" />";
				colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(17868,user.getLanguage())+"\" column=\"subcompanyid\" orderkey=\"subcompanyid\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" />";
				colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("17864,1331",user.getLanguage())+"\" column=\"result\" orderkey=\"result\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmRolesC\" otherpara=\"column:id\"/>";
				colString +="<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("431,1331",user.getLanguage())+"\" column=\"cnt\" orderkey=\"cnt\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmRolesD\" otherpara=\"column:id\"/>";
			}else{
				colString ="<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(32011,user.getLanguage())+"\" column=\"id\" orderkey=\"id\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmRolesA\" otherpara=\"column:id\"/>";
				colString +="<col width=\"45%\"  text=\""+SystemEnv.getHtmlLabelName(15068,user.getLanguage())+"\" column=\"rolesmark\" orderkey=\"rolesmark\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmRolesA\" otherpara=\"column:id\"/>";
				colString +="<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelNames("17864,1331",user.getLanguage())+"\" column=\"result\" orderkey=\"result\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmRolesC\" otherpara=\"column:id\"/>";
				colString +="<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("431,1331",user.getLanguage())+"\" column=\"cnt\" orderkey=\"cnt\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmRolesD\" otherpara=\"column:id\"/>";
			}
			String tableString =" <table pageId=\""+Constants.HRM_Z_021+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_021,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">";
			tableString+=" <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"column:cnt+==0andcolumn:cnt1+==0andcolumn:cnt2+==0andcolumn:cnt3+==0andcolumn:cnt4+==0andcolumn:cnt5+==0andcolumn:cnt6+==0andcolumn:cnt7+==0andcolumn:cnt8+==0andcolumn:isdefault+==0\" />";
			tableString+="<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlorderby=\""+orderBy+"\"  sqlprimarykey=\"id\" sqlsortway=\"Desc\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" sqldistinct=\"true\"/>";
			tableString+=operateString;
			tableString+="<head>"+colString+"</head>";
			tableString+="</table>";
		%>
				 <input type="hidden" name="pageId" id="pageId" value="<%= Constants.HRM_Z_021 %>"/>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
	</BODY>
</HTML>

