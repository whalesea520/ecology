
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-06-24 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<%
	String cmd = Util.null2String(request.getParameter("cmd"));
	String id = Util.null2String(request.getParameter("id"));
	String qname = Util.null2String(request.getParameter("flowTitle"));
	String rightgroupmark = Util.null2String(request.getParameter("rightgroupmark"));
	String rightgroupname = Util.null2String(request.getParameter("rightgroupname"));
	
	int allAuthSize = 0;
	String sql = "select count(b.id) as result from SystemRights b left join SystemRightsLanguage c on c.id = b.id where c.languageid = "+user.getLanguage();
	rs.executeSql(sql);
	if(rs.next()){
		allAuthSize = rs.getInt("result");
	}
	String imagefilename = "/images/hdSystem_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(492,user.getLanguage());
	String needfav ="1";
	String needhelp ="1";
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			var dialog = null;
			var dWidth = 800;
			var dHeight = 500;
			
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}
			
			function closeDialog(){
				if(dialog)
					dialog.close();
				window.location.href="/systeminfo/systemright/SystemRightGroup.jsp";
			}
			
			function todo(url,title,_dWidth,_dHeight){
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
					for(var i=0;i<idArr.length;i++){
						ajaxNum++;
						jQuery.ajax({
							url:"SystemRightGroupOperation.jsp?operationType=delete&groupID="+idArr[i],
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
				todo("/hrm/HrmDialogTab.jsp?_fromURL=systemRightGroup&method=add","<%=SystemEnv.getHtmlLabelNames("82,492",user.getLanguage())%>");
			}
			
			function doEdit(id){
				if(id == "9980"){
					id = "-2";
				}
				todo("/hrm/HrmDialogTab.jsp?_fromURL=systemRightGroup&method=edit&showpage=1&id="+id,"<%=SystemEnv.getHtmlLabelNames("93,492",user.getLanguage())%>");
			}
			
			function doShowDetail(id){
				if(id == "9980"){
					id = "-2";
				}
				todo("/hrm/HrmDialogTab.jsp?_fromURL=systemRightGroup&method=edit&showpage=2&id="+id,"<%=SystemEnv.getHtmlLabelNames("93,492",user.getLanguage())%>");
			}
			function doShowAuth(){
				parent.location.href = "/hrm/HrmTab.jsp?_fromURL=SystemRightGroup&cmd=SystemRightAuthority";
			}
			
			if('<%=cmd%>' == 'f' || '<%=cmd%>' == 'fs'){
				if('<%=id%>' == '9999' || '<%=id%>' == "<%=SystemEnv.getHtmlLabelNames("492,84",user.getLanguage())%>" || '<%=id%>' == "<%=SystemEnv.getHtmlLabelNames("440,1331",user.getLanguage())%>" ){
					doShowAuth();
				}else {
					if("<%=cmd%>" == "fs"){
						doShowDetail('<%=id%>');
					}else{
						doEdit('<%=id%>');
					}
				}
			}
		</script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		if(HrmUserVarify.checkUserRight("SystemRightGroupAdd:Add",user)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:doAdd(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		if(HrmUserVarify.checkUserRight("SystemRightGroupEdit:Delete",user)){
			RCMenu += "{"+SystemEnv.getHtmlLabelName(32136,user.getLanguage())+",javascript:doDel(),_self} " ;
			RCMenuHeight += RCMenuHeightStep ;
		}
		RCMenu += "{"+SystemEnv.getHtmlLabelName(33363, user.getLanguage())+"("+allAuthSize+")"+",javascript:doShowAuth(),_self} " ;
		RCMenuHeight += RCMenuHeightStep ;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<%
							if(HrmUserVarify.checkUserRight("SystemRightGroupAdd:Add", user)){ 
						%>
								<input type=button class="e8_btn_top" onclick="doAdd();" value="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
						<%
							} 
							if(HrmUserVarify.checkUserRight("SystemRightGroupEdit:Delete", user)){ 
						%>
								<input type=button class="e8_btn_top" onclick="doDel();" value="<%=SystemEnv.getHtmlLabelName(32136, user.getLanguage())%>"></input>
						<%	} %>
						<input type=button class="e8_btn_top" onclick="doShowAuth();" value="<%=SystemEnv.getHtmlLabelName(33363, user.getLanguage())+"("+allAuthSize+")"%>"></input>
						<input type="text" class="searchInput" name="flowTitle" value=""/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelNames("492,84",user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="rightgroupmark" name="rightgroupmark" class="inputStyle" value=""></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelNames("492,85",user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="rightgroupname" name="rightgroupname" class="inputStyle" value=""></wea:item>
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
			String allStr = SystemEnv.getHtmlLabelName(332,user.getLanguage());
			String backFields = " (case when a.id = -2 then 9980 else id end) as id,a.rightgroupmark,a.rightgroupname,a.rightgroupremark,(case when a.id = -2 then (select count(distinct a.id) from SystemRights a left join SystemRightToGroup b on a.id=b.rightid left join SystemRightsLanguage c on c.id = a.id where b.rightid is null ) else (case when b.result is null then 0 else b.result end) end) as result "; 
			String sqlFrom  = "  SystemRightGroups a left join ( select a.groupid,COUNT(b.id) as result from SystemRights b left join systemrighttogroup a on a.rightid = b.id left join SystemRightsLanguage c on c.id = b.id where c.languageid = "+user.getLanguage()+" group by a.groupid ) b on a.id = b.groupid ";
			String sqlWhere = " where 1=1 ";
			String orderby = " a.id " ;
			String tableString = "";
			
			if(qname.length() > 0){
				sqlWhere += " and a.rightgroupmark like '%"+qname+"%' ";
			}else if (rightgroupmark.length() > 0){
				sqlWhere += " and a.rightgroupmark like '%"+rightgroupmark+"%' ";
			}
			if (rightgroupname.length() > 0){
				sqlWhere += " and a.rightgroupname like '%"+rightgroupname+"%' ";
			}
			
			String operateString= "<operates width=\"20%\">";
 	    	operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\""+HrmUserVarify.checkUserRight("SystemRightGroupEdit:Edit", user)+":+column:result+==0and"+HrmUserVarify.checkUserRight("SystemRightGroupEdit:Delete", user)+":"+HrmUserVarify.checkUserRight("SystemRightGroupEdit:Edit", user)+"\"></popedom> ";
			operateString+="     <operate href=\"javascript:doEdit();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
 	       	operateString+="     <operate href=\"javascript:doDel();\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
 	       	operateString+="     <operate href=\"javascript:doShowDetail();\" text=\""+SystemEnv.getHtmlLabelNames("385,17463",user.getLanguage())+"\" index=\"2\"/>";
 	       	operateString+="</operates>";
			tableString=""+
				"<table pageId=\""+Constants.HRM_Z_001+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_001,user.getUID(),Constants.HRM)+"\" tabletype=\"checkbox\">"+
					" <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"column:result+==0\" />"+
					"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
					operateString+
					"<head>"+
						"<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelNames("492,84",user.getLanguage())+"\" column=\"rightgroupmark\" orderkey=\"rightgroupmark\" linkkey=\"id\" linkvaluecolumn=\"id\" href=\"SystemRightGroup.jsp?cmd=f\" target=\"_self\"/>"+
						"<col width=\"35%\"  text=\""+SystemEnv.getHtmlLabelNames("492,85",user.getLanguage())+"\" column=\"rightgroupname\" orderkey=\"rightgroupname\" linkkey=\"id\" linkvaluecolumn=\"id\" href=\"SystemRightGroup.jsp?cmd=f\" target=\"_self\"/>"+
						"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelNames("440,1331",user.getLanguage())+"\" column=\"result\" orderkey=\"result\" linkkey=\"id\" linkvaluecolumn=\"id\" href=\"SystemRightGroup.jsp?cmd=fs\" target=\"_self\"/>"+
					"</head>"+
				"</table>";
		%>
		 <input type="hidden" name="pageId" id="pageId" value="<%= Constants.HRM_Z_001 %>"/>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" /> 
	</BODY>
</HTML>  
