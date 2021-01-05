
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-07-01 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<%
	String id = Util.null2String(request.getParameter("id"));
	String groupID = Util.null2String(request.getParameter("groupID"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));

	boolean canadd = HrmUserVarify.checkUserRight("SystemRightRolesAdd:Add",user) ;
	boolean candelete = HrmUserVarify.checkUserRight("SystemRightRolesEdit:Delete",user) ;	
	
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(385,user.getLanguage()) ;
	String needfav ="";
	String needhelp ="1";
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
			var groupID = "<%=groupID%>";
			function closeDialog(){
				if(dialog)
					dialog.close();
				window.location.href="/systeminfo/systemright/SystemRightRoles.jsp?isdialog=1&id="+id+"&groupID="+groupID;
			}
		
		function openDialog(id){
			dWidth = 700;
			dHeight = 500;
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
					url = "/hrm/HrmDialogTab.jsp?_fromURL=hrmRoles&method=HrmRolesAdd&isdialog=1";
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
			
			var parentDialog = parent.parent.getDialog(parent);
			var parentWin = parent.parent.getParentWindow(parent);
			if("<%=isclose%>"=="1"){
				parentWin.id = "<%=id%>";
				parentWin.groupID = "<%=groupID%>";
				parentWin.closeDialog();	
			}
			
			function doAdd(){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=systemRightGroup&method=SystemRightRolesAdd&id=<%=id%>&groupID=<%=groupID%>","<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(19422,user.getLanguage())%>");
			}
			
			function doEdit(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=systemRightGroup&method=SystemRightRolesEdit&id="+id+"&rightid=<%=id%>&groupID=<%=groupID%>","<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())+SystemEnv.getHtmlLabelName(19422,user.getLanguage())%>");
			}
		
			function toMemList(id){
				dWidth = 700;
				dHeight = 500;
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmRoles&method=HrmRolesEdit&isdialog=1&showpage=3&id="+id,"<%=SystemEnv.getHtmlLabelNames("93,122",user.getLanguage())%>");
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
							url:"SystemRightGroupOperation.jsp?isdialog=1&operationType=deleterightroles&rightid=<%=id%>&roleid=&groupID=<%=groupID%>&id="+idArr[i],
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
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			if(canadd){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(candelete){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
				<%if(canadd){ %>
					<input type=button class="e8_btn_top" onclick="doAdd();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
					<% }if(candelete) {%>
					<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
					<%}%>
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<%
			String backfields = " a.id,a.rightid,a.roleid,a.rolelevel,b.rolesmark , (SELECT count(c.roleid) as cnt from HrmRoleMembers c  WHERE c.roleid = b.id) cnt ";
			String fromSql  = " from SystemRightRoles a left join HrmRoles b on a.roleid = b.id ";
			String sqlWhere = " where a.rightid = "+id;
			String orderby = "" ;
			
			String operateString= "<operates width=\"20%\">";
			if(canadd){
			operateString+="     <operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
			operateString+="     <operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
			}
			operateString+="</operates>";
			String tableString =" <table pageId=\""+Constants.HRM_Z_003+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_003,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"asc\" sqlisdistinct=\"true\"/>"+
			operateString+
			"	<head>"+
			"		<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(32011,user.getLanguage())+"\" column=\"roleid\" orderkey=\"roleid\" />"+
			"		<col width=\"35%\" text=\""+SystemEnv.getHtmlLabelName(15068,user.getLanguage())+"\" column=\"rolesmark\" orderkey=\"rolesmark\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmRolesA\" otherpara=\"column:roleid\" />"+
			"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelNames("431,1331",user.getLanguage())+"\" column=\"cnt\" orderkey=\"cnt\" transmethod=\"weaver.hrm.HrmTransMethod.getHrmRolesD\" otherpara=\"column:roleid\" />"+
			"		<col width=\"25%\" text=\""+SystemEnv.getHtmlLabelName(139,user.getLanguage())+"\" column=\"rolelevel\" orderkey=\"rolelevel\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+";0=124,1=141,default=140]}\"/>"+
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
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" class="e8_btn_cancel" onclick="parentDialog.closeByHand();">
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
