
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="ManageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<!-- modified by wcd 2014-06-24 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<%
	String id= Util.null2String(request.getParameter("id"));   
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String qname = Util.null2String(request.getParameter("flowTitle"));
	String coulddetach = Util.null2String(request.getParameter("coulddetach"));
	String rightid = Util.null2String(request.getParameter("rightid"));
	String rightname = Util.null2String(request.getParameter("rightname"));
	String righttype = Util.null2String(request.getParameter("righttype"));
/*
	rs.executeSql("select detachable from SystemSet");
	int detachable=0;
	if(rs.next()){
		detachable=rs.getInt("detachable");
		session.setAttribute("detachable",String.valueOf(detachable));
	}*/
	int detachable=0;
	boolean isUseHrmManageDetach=ManageDetachComInfo.isUseHrmManageDetach();
	if(isUseHrmManageDetach){
		 detachable =1;
		 session.setAttribute("detachable","1");
		 session.setAttribute("hrmdetachable","1");
	}else{
		 detachable =0;
		 session.setAttribute("detachable","0");
	   session.setAttribute("hrmdetachable","0");
	}
	
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelNames("385,17463",user.getLanguage()) ;
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
			var dWidth = 800;
			var dHeight = 500;
			
			var _id = "";
			var _name = "";
		
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
			
			function closeDialog(){
				if(dialog)
					dialog.close();
				if (_id != null) {
					window.location.href="/systeminfo/systemright/SystemRightGroupOperation.jsp?operationType=addright&groupID=<%=id%>&rightid="+_id;
				}else {
					window.location.href="/systeminfo/systemright/SystemRightGroup.jsp";
				}
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
							url:"SystemRightGroupOperation.jsp?operationType=deleteright&groupID=<%=id%>&rightid="+idArr[i],
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
			function doAdd(){
				doOpen("/systeminfo/BrowserMain.jsp?url=/systeminfo/systemright/MultiSystemRightBrowser.jsp","<%=SystemEnv.getHtmlLabelNames("33251,385",user.getLanguage())%>",550,520);
			}
			function doShow(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=systemRightGroup&method=showAuth&detachable=<%=detachable%>&groupID=<%=id%>&id="+id,"<%=SystemEnv.getHtmlLabelNames("18932,19422,33292",user.getLanguage())%>",800,500);
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
			if(HrmUserVarify.checkUserRight("SystemRightGroupEdit:Edit", user) && id.length() > 0){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:doAdd(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
			if(HrmUserVarify.checkUserRight("SystemRightGroupEdit:Delete", user) && id.length() > 0){
				RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel(),_self} " ;
				RCMenuHeight += RCMenuHeightStep ;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%
							if(HrmUserVarify.checkUserRight("SystemRightGroupEdit:Edit", user) && id.length() > 0){ 
						%>
								<input type=button class="e8_btn_top" onclick="doAdd();" value="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
						<%
							} 
							if(HrmUserVarify.checkUserRight("SystemRightGroupEdit:Delete", user) && id.length() > 0){
						%>
								<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
						<%	} %>
						<input type="text" class="searchInput" name="flowTitle" value=""/>
						<input type="hidden" name="id" value="<%=id %>"/>
						<input type="hidden" name="isDialog" value="<%=isDialog %>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="rightname" name="rightname" class="inputStyle" value=""></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="rightid" name="rightid" class="inputStyle" value=""></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<select name="righttype" id="righttype" class="inputStyle">
									<option value=""></option>
									<option value="0"><%=SystemEnv.getHtmlLabelName(147,user.getLanguage())%></option>
									<option value="1"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></option>
									<option value="2"><%=SystemEnv.getHtmlLabelName(189,user.getLanguage())%></option>
									<option value="3"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
									<option value="5"><%=SystemEnv.getHtmlLabelName(259,user.getLanguage())%></option>
									<option value="6"><%=SystemEnv.getHtmlLabelName(101,user.getLanguage())%></option>
									<option value="7"><%=SystemEnv.getHtmlLabelName(468,user.getLanguage())%></option>
									<option value="8"><%=SystemEnv.getHtmlLabelName(535,user.getLanguage())%></option>
									<option value="9"><%=SystemEnv.getHtmlLabelName(582,user.getLanguage())%></option>
								</select>
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(17861,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<select name="coulddetach" id="coulddetach" class="inputStyle">
									<option value=""></option>
									<option value="0"><%=SystemEnv.getHtmlLabelName(161,user.getLanguage())%></option>
									<option value="1"><%=SystemEnv.getHtmlLabelName(163,user.getLanguage())%></option>
								</select>
							</span>
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
			String backFields = "  b.id,(case when b.detachable is null then 0 else b.detachable end) as detachable, b.righttype, c.rightname, c.rightdesc "; 
			String sqlFrom  = id.length() == 0 ? " from SystemRights b left join SystemRightsLanguage c on c.id = b.id " : " from SystemRights b left join systemrighttogroup a on a.rightid = b.id left join SystemRightsLanguage c on c.id = b.id ";
			String sqlWhere = " where c.languageid = "+user.getLanguage();
			String orderby = " b.righttype,b.id " ;
			
			if(id.length() > 0){
				if(id.equals("-2")){
					sqlWhere += " and a.rightid is null";
				}else{
					sqlWhere += " and a.groupid = "+id;
				}
			}
			if(qname.length() > 0){
				sqlWhere += " and c.rightname like '%"+qname+"%' ";
			}else if(rightname.length() > 0){
				sqlWhere += " and c.rightname like '%"+rightname+"%' ";
			}
			if(coulddetach.length() > 0){
				if(coulddetach.equals("0")){
					sqlWhere += " and (b.detachable = 0 or b.detachable is null)";
				}else{
					sqlWhere += " and b.detachable = "+coulddetach;
				}
			}
			if(rightid.length() > 0){
				sqlWhere += " and b.id = "+rightid;
			}
			if(righttype.length() > 0){
				sqlWhere += " and b.righttype = "+righttype;
			}
			
			String operateString= "<operates width=\"20%\">";
 	    	//operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\""+HrmUserVarify.checkUserRight("SystemRightGroupEdit:Delete", user)+"\"></popedom> ";
			if(id.length() > 0 && HrmUserVarify.checkUserRight("SystemRightGroupEdit:Delete", user)){
				operateString+="     <operate href=\"javascript:doDel()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"0\"/>";
			}else{
				operateString+="     <operate href=\"javascript:doShow()\" text=\""+SystemEnv.getHtmlLabelName(33364,user.getLanguage())+"\" index=\"0\"/>";
			}
 	       	operateString+="</operates>";
			String tableString=""+
				"<table pageId=\""+Constants.HRM_Z_002+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_002,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
					"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"b.id\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
					operateString+
					"<head>"+                             
						"<col width=\"10%\"  text=\""+SystemEnv.getHtmlLabelName(84,user.getLanguage())+"\" column=\"id\" orderkey=\"b.id\" linkkey=\"id\" linkvaluecolumn=\"id\" href=\"SystemRightRoles.jsp\" target=\"_self\"/>"+
						"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"rightname\" orderkey=\"rightname\"/>"+
						"<col width=\"30%\"  text=\""+SystemEnv.getHtmlLabelName(433,user.getLanguage())+"\" column=\"rightdesc\" orderkey=\"rightdesc\"/>"+
						"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"righttype\" orderkey=\"righttype\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+";0=147,1=58,2=189,3=179,5=259,6=101,7=468,8=535,9=582]}\"/>"+
						"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(17861,user.getLanguage())+"\" column=\"detachable\" orderkey=\"detachable\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\"{cmd:array["+user.getLanguage()+";0=161,1=163]}\"/>"+
					"</head>"+
				"</table>";
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
