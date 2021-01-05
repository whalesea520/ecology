
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-06-27 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
    int id=Util.getIntValue(request.getParameter("id"),0);
    int flag=Util.getIntValue(request.getParameter("flag"),0);
    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	String imagefilename = "/images/hdHRMCard_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(122,user.getLanguage())+":"+SystemEnv.getHtmlLabelName(17864,user.getLanguage());
    String needfav ="1";
    String needhelp ="";
	
	String qname = Util.null2String(request.getParameter("flowTitle"));
	String groupName = Util.null2String(request.getParameter("groupName"));
	String roleLevel = Util.null2String(request.getParameter("roleLevel"));
	String roleName = Util.null2String(request.getParameter("roleName"));

    rs.execute("hrmroles_selectSingle",String.valueOf(id));
    rs.next();

    String rolesmark=rs.getString(1);
    String rolesname=rs.getString(2);
    int docid=Util.getIntValue(rs.getString(3),0);
    int roletype=Util.getIntValue(rs.getString(4),0);
    String structureid=rs.getString(5);

    session.setAttribute("role_type",String.valueOf(roletype));

    int operatelevel=0;
    if(detachable==1){
        operatelevel=CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"HrmRolesAdd:Add",Integer.parseInt(structureid));
    }else{
        if(HrmUserVarify.checkUserRight("HrmRolesAdd:Add", user))
            operatelevel=2;
    }
	rs.executeSql("select rightgroupname from SystemRightGroups where id = -2");
	rs.next();
	String otherGroupName = Util.null2String(rs.getString("rightgroupname"));
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
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
				//window.location.href="/hrm/roles/HrmRolesFucRightSet.jsp?isdialog=1&id="+id;
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
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmRolesAuth&method=HrmRoleRightAdd&detachable=<%=detachable%>&isdialog=1&id=<%=id%>","<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())+SystemEnv.getHtmlLabelName(17864,user.getLanguage())%>",700,600);
			}
			
			function doEdit(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmRolesAuth&method=HrmRoleRightEdit&detachable=<%=detachable%>&isdialog=1&id=<%=id%>&rightid="+id,"<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(17864,user.getLanguage())%>",700,600);
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
							url:"HrmRoleRightOperation.jsp?isdialog=1&operationType=deleteRoleRight&cmd=selectId&roleId=<%=id%>&rightId="+idArr[i],
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
					url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=102 and relatedid=")%>&relatedid="+id;
				}else{
					url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=102")%>";
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
				RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doAdd();,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel();,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
				RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:showLog("+id+");,_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<input type=hidden name="operationType"> 
			<input type=hidden name="id" value="<%=id%>">
			<input type=hidden name="isdialog" value="<%=isDialog%>">
			<input type=hidden name="detachable" value="<%=detachable%>"> 
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%if(operatelevel > 0){%>
							<input type=button class="e8_btn_top" onclick="doAdd();" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
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
						<wea:item><%=SystemEnv.getHtmlLabelName(440,user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="roleName" name="roleName" class="inputStyle" value=""></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
						<wea:item>
							<select name="roleLevel" class=InputStyle>
								<option value=""><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
								<option value="0"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
								<option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
								<option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
							</select>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(492,user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="groupName" name="groupName" class="inputStyle" value=""></wea:item>
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
			String backfields = " (case when t3.id is null then -2 else t3.id end) as id,(case when t3.rightgroupname is null then (select rightgroupname from SystemRightGroups where id = -2) else t3.rightgroupname end ) as rightgroupname,t1.rolelevel,t1.rightid ";
			String fromSql  = " from systemrightroles t1 left join SystemRightToGroup t2 on t1.rightid = t2.rightid left join SystemRightGroups t3 on t2.groupid = t3.id right join SystemRights t4 on t1.rightid = t4.id";
			String sqlWhere = " where t1.roleid = "+id+" and t1.rolelevel between '0' and '2'";
			String orderby = " t3.id" ;
			
			String qSql = " and t1.rightid in (select id from systemrightslanguage where languageid = 7 and rightname like '%";
			if(qname.length() > 0 ){
				sqlWhere += qSql+qname+"%') ";
			}else if(roleName.length() > 0 ){
				sqlWhere += qSql+roleName+"%') ";
			}
			if(groupName.length() > 0){
				String appendSql = "";
				if(otherGroupName.length()>0 && otherGroupName.indexOf(groupName) != -1){
					appendSql += " or t3.id is null ";
				}
				sqlWhere += " and (t3.rightgroupname like '%"+groupName+"%' "+appendSql+")";
			}
			if(roleLevel.length() > 0){
				sqlWhere += " and t1.rolelevel = "+roleLevel;
			}
			String operateString= "<operates width=\"20%\">";
			operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\""+(HrmUserVarify.checkUserRight("HrmRolesEdit:Edit", user)&&operatelevel > 0)+":"+(HrmUserVarify.checkUserRight("HrmRolesEdit:Delete", user)&&operatelevel > 0)+"\"></popedom> ";
			operateString+="     <operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
			operateString+="     <operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
			operateString+="</operates>";
			String tableString =" <table pageId=\""+Constants.HRM_Z_022+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_022,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"t1.rightid\" sqlsortway=\"asc\" sqlisdistinct=\"\"/>"+
			operateString+
			"	<head>"+
			"		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(492,user.getLanguage())+"\" column=\"rightgroupname\" orderkey=\"rightgroupname\" />"+
			"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(139,user.getLanguage())+"\" column=\"rolelevel\" orderkey=\"rolelevel\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+";0=124,1=141,default=140]}\"/>"+
			"		<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(440,user.getLanguage())+"\" column=\"rightid\" orderkey=\"t1.rightid\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:class[weaver.systeminfo.systemright.RightComInfo.getRightname(+column:rightid+,"+user.getLanguage()+")]}\" />"+
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
</html>
