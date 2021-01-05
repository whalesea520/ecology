
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-06-27 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	int hrmdetachable=Util.getIntValue(String.valueOf(session.getAttribute("hrmdetachable")),0);
	String operationType=Util.null2String(request.getParameter("operationType"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(431,user.getLanguage());
	String needfav ="1";
	String needhelp ="";
	
	String qname = Util.null2String(request.getParameter("flowTitle"));
	
	String hrmName = Util.null2String(request.getParameter("hrmName"));
	String hrmJobtitle = Util.null2String(request.getParameter("hrmJobtitle"));
	String hrmSubcompany = Util.null2String(request.getParameter("hrmSubcompany"));
	String department = Util.null2String(request.getParameter("department"));
	String roleLevel = Util.null2String(request.getParameter("roleLevel"));

	String id=Util.null2String(request.getParameter("id"));
	rs.execute("hrmroles_selectSingle",id);
	rs.next();

	String rolesmark=rs.getString(1);
	String rolesname=rs.getString(2);
	int docid=Util.getIntValue(rs.getString(3),0);
	int roletype=Util.getIntValue(rs.getString(4),0);
	String structureid=rs.getString(5);

	int operatelevel=0;
	if(hrmdetachable==1){
		operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmRolesAdd:Add",Integer.parseInt(structureid));
	}else{
		if(HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user))
			operatelevel=2;
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/hrm/HrmTools_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}
			
			var dialog = null;
			var dWidth = 500;
			var dHeight = 400;
			
			var id = "<%=id%>";
			function closeDialog(){
				if(dialog)
					dialog.close();
					onBtnSearchClick();
				//window.location.href="/hrm/roles/HrmRolesMembers.jsp?isdialog=1&id="+id;
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
			
			var parentDialog = parent.parent.getDialog(parent);
			var parentWin = parent.parent.getParentWindow(parent);
			if("<%=isclose%>"=="1"){
				parentWin.id = "<%=id%>";
				parentWin.closeDialog();	
			}
			
			function doAdd(){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmRolesMem&method=HrmRolesMembersAdd&id=<%=id%>","<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(431,user.getLanguage())%>");
			}
			
			function doEdit(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmRolesMem&method=HrmRolesMembersEdit&id="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(431,user.getLanguage())%>");
			}
			
			function resetSelect(){
				changeSelectValue($GetEle("roleLevel").id,"");
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
					for(var i=0;i<idArr.length;i++){
						ajaxNum++;
						jQuery.ajax({
							url:"HrmRolesMembersOperation.jsp?isdialog=1&operationType=Delete&roleID=<%=id%>&id="+idArr[i],
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
			function showLog(id){
				var url = "";
				if(id && id!=""){
					url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=32 and relatedid=")%>&relatedid="+id;
				}else{
					url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=32")%>";
				}
				doOpen(url,"<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>",jQuery(window).width(),jQuery(window).height());
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
			if(operatelevel > 0){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd();,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showLog("+id+");,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<input type=hidden name="operationType" value="MutiDelete">
			<input type=hidden name="id" value="<%=id%>">
			<input type=hidden name="isdialog" value="<%=isDialog%>">
			<input type=hidden id=roleID name="roleID" value="<%=id%>">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%if(operatelevel > 0){%>
							<input type=button class="e8_btn_top" onclick="doAdd();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
							<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
						<%}%>
						<input type="text" class="searchInput" name="flowTitle" value=""/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(431,user.getLanguage())%></wea:item>
						<wea:item><input type="text" class=InputStyle maxLength=50 size=30 name="hrmName" value='<%=hrmName%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
						<wea:item>
							<select name="roleLevel" id="roleLevel" class=InputStyle>
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<option value="0" <%=roleLevel.equals("0")?"selected":""%>><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
								<option value="1" <%=roleLevel.equals("1")?"selected":""%>><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
								<option value="2" <%=roleLevel.equals("2")?"selected":""%>><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="hrmJobtitle" browserValue='<%=hrmJobtitle%>'
								browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp"
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=hrmjobtitles" width="60%" browserSpanValue='<%=JobTitlesComInfo.getJobTitlesname(hrmJobtitle)%>'>
							</brow:browser>		 
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="hrmSubcompany" browserValue='<%=hrmSubcompany%>' 
								browserUrl="/systeminfo/BrowserMain.jsp?mouldID=hrm&url=/hrm/company/SubcompanyBrowser.jsp?excludeid="
								hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='1'
								completeUrl="/data.jsp?type=164" width="60%" browserSpanValue='<%=SubCompanyComInfo.getSubCompanyname(hrmSubcompany)%>'>
							</brow:browser>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></wea:item>
						<wea:item>
							<brow:browser viewType="0" name="department"  browserValue='<%=department %>'
						         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
						         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='1'
						         completeUrl="/data.jsp?type=4" width="60%" 
						         browserSpanValue='<%=DepartmentComInfo.getDepartmentname(department) %>'
						         ></brow:browser>
						</wea:item>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick()"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" class="e8_btn_cancel" onclick="resetCondtion();resetSelect();"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>
		<%
			String backfields = " a.id,a.resourceid,a.rolelevel,a.lastname,a.jobtitle,a.departmentid,a.subcompanyid1 ";
			String fromSql  = " from (select a.id,a.resourceid,a.rolelevel,(case when a.resourceid = 1 then -1 else b.jobtitle end) as jobtitle,(case when a.resourceid = 1 then -1 else b.departmentid end) as departmentid,(case when a.resourceid = 1 then -1 else b.subcompanyid1 end) as subcompanyid1,(case when b.lastname is null then c.lastname else b.lastname end) as lastname from hrmrolemembers a left join HrmResource b on a.resourceid = b.id left join HrmResourceManager c on a.resourceid = c.id where a.roleid = "+id+") a ";
			String sqlWhere = " where 1 = 1 ";
			String orderby = " a.rolelevel desc, a.id asc " ;
			
			if(qname.length() > 0 ){
				sqlWhere += " and a.lastname like '%"+qname+"%' ";
			}else if(hrmName.length() > 0 ){
				sqlWhere += " and a.lastname like '%"+hrmName+"%' ";
			}
			if(hrmJobtitle.length() > 0){
				sqlWhere += " and a.jobtitle  = "+hrmJobtitle;
			}				
			if(hrmSubcompany.length() > 0){
				sqlWhere += " and a.subcompanyid1  = "+hrmSubcompany;
			}
			if(department.length() >0){
				sqlWhere += " and a.departmentid = "+department ;
			}
			if(roleLevel.length() > 0){
				sqlWhere += " and a.rolelevel = "+roleLevel;
			}
			String operateString= "<operates width=\"20%\">";
			operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\""+(HrmUserVarify.checkUserRight("HrmRolesEdit:Edit", user)&&operatelevel > 0)+":"+(HrmUserVarify.checkUserRight("HrmRolesEdit:Delete", user)&&operatelevel > 0)+"\"></popedom> ";
			operateString+="     <operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
			operateString+="     <operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
			operateString+="</operates>";
			String tableString =" <table pageId=\""+Constants.HRM_Z_023+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_023,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"desc\" sqlisdistinct=\"\"/>"+
			operateString+
			"	<head>"+
			"		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(431,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\"  href=\"/hrm/HrmTab.jsp?_fromURL=HrmResource\" linkvaluecolumn=\"resourceid\" linkkey=\"id\"/>"+
			"		<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(139,user.getLanguage())+"\" column=\"rolelevel\" orderkey=\"rolelevel\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+";0=124,1=141,default=140]}\"/>"+
			"		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitle\" orderkey=\"jobtitle\" transmethod=\"weaver.hrm.job.JobTitlesComInfo.getJobTitlesname\" linkvaluecolumn=\"jobtitle\" linkkey=\"id\" href=\"/hrm/jobtitles/HrmJobTitlesEdit.jsp\"/>"+
			"		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"\" column=\"subcompanyid1\" orderkey=\"subcompanyid1\" transmethod=\"weaver.hrm.company.SubCompanyComInfo.getSubCompanyname\" linkvaluecolumn=\"subcompanyid1\" linkkey=\"subcompanyid\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmDepartment\"/>"+
			"		<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"\" column=\"departmentid\" orderkey=\"departmentid\" transmethod=\"weaver.hrm.company.DepartmentComInfo.getDepartmentname\" linkvaluecolumn=\"departmentid\" linkkey=\"id\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmDepartmentDsp\"/>"+
			"	</head>"+
			" </table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
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
	</body>
</HTML>
