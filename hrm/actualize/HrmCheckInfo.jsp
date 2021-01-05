
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-07-01 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<%
	if(!HrmUserVarify.checkUserRight("HrmCheckInfo:Maintenance", user)) {
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelName(7014,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	String cmd = Util.null2String(request.getParameter("cmd"));
	String checkname = Util.null2String(request.getParameter("checkname"));
	String qname = Util.null2String(request.getParameter("flowTitle"));
	String exFromMemId = Util.null2String(request.getParameter("exFromMemId"));
	String exToMemId = Util.null2String(request.getParameter("exToMemId"));
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
			var dWidth = 700;
			var dHeight = 500;
			var cmd = "<%=cmd%>";
			function closeDialog(){
				if(dialog)
					dialog.close();
				window.location.href="/hrm/actualize/HrmCheckInfo.jsp?cmd="+cmd;
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
		
			function showDetail(id){
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmCheckInfo&method=showDetail&isdialog=1&id="+id,"<%=SystemEnv.getHtmlLabelName(15920,user.getLanguage())%>");
			}
		</script>
	</head>
	<BODY>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<input type="text" class="searchInput" name="flowTitle" value="<%=qname%>"/>
						<input type="hidden" name="cmd" value="<%=cmd%>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(15653,user.getLanguage())%></wea:item>
						<wea:item>
							<wea:required id="namespan" required="false">
								<input class=inputstyle maxlength=20  size=15 name="checkname" value="<%=checkname%>"/>
							</wea:required>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(15662,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<brow:browser viewType="0" name="exFromMemId" browserValue="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp" width="60%" browserSpanValue="">
								</brow:browser>
							</span>
						</wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(15648,user.getLanguage())%></wea:item>
						<wea:item>
							<span>
								<brow:browser viewType="0" name="exToMemId" browserValue="" 
									browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
									hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
									completeUrl="/data.jsp" width="60%" browserSpanValue="">
								</brow:browser>
							</span>
						</wea:item>
					</wea:group>
					<wea:group context="">
						<wea:item type="toolbar">
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(30947,user.getLanguage())%>" class="e8_btn_submit" onclick="onBtnSearchClick();"/>
							<input type="button" value="<%=SystemEnv.getHtmlLabelName(31129,user.getLanguage())%>" class="e8_btn_cancel" id="cancel"/>
						</wea:item>
					</wea:group>
				</wea:layout>
			</div>
		</form>
		<%
			Calendar todaycal = Calendar.getInstance ();
			String nowdate = Util.add0(todaycal.get(Calendar.YEAR), 4) +"-"+
						 Util.add0(todaycal.get(Calendar.MONTH) + 1, 2) +"-"+
						 Util.add0(todaycal.get(Calendar.DAY_OF_MONTH) , 2) ;
			String backFields = "a.id,a.checkname,a.enddate,b.countresourceid,b.countcheckercount"; 
			String sqlFrom  = "from HrmCheckList a left join (select a.checkid as id,sum(1) as countresourceid,sum(a.bCount)/SUM(1) as countcheckercount from ( select a.checkid,count(1) as bCount from HrmByCheckPeople a group by a.resourceid,a.checkid ) a group by a.checkid ) b on a.id = b.id";
			String sqlWhere = "";
			String orderby = "" ;
			
			if(cmd.equals("15652")){
				sqlWhere = "where a.enddate >= '"+nowdate+"'";
			} else {
				sqlWhere = "where a.enddate < '"+nowdate+"'";
			}
			if(qname.length() > 0){
				sqlWhere += " and a.checkname like '%"+qname+"%' ";
			}
			if (checkname.length() > 0) {
				sqlWhere += " and a.checkname like '%"+checkname+"%' ";
			}
			if(exFromMemId.length() > 0){
				sqlWhere += " and exists (select 1 from HrmByCheckPeople where checkid = a.id and resourceid = "+exFromMemId+")";
			}
			if(exToMemId.length() > 0){
				sqlWhere += " and exists (select 1 from HrmByCheckPeople where checkid = a.id and resourceid = "+exToMemId+")";
			}
			String operateString = "<operates width=\"20%\">";
 	    	operateString+=" <popedom transmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicOperate\" otherpara=\"true\"></popedom> ";
			operateString+="     <operate href=\"javascript:showDetail();\" text=\""+SystemEnv.getHtmlLabelName(15920,user.getLanguage())+"\" index=\"0\"/>";
			operateString+="</operates>";
			
			String tableString=""+
				"<table pageId=\""+Constants.HRM_Z_042+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_042,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
					" <checkboxpopedom showmethod=\"weaver.hrm.common.SplitPageTagOperate.getBasicCheckbox\"  id=\"checkbox\"  popedompara=\"false\" />"+
					"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.id\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
					operateString+
					"<head>"+                             
						"<col width=\"50%\"  text=\""+SystemEnv.getHtmlLabelName(15653,user.getLanguage())+"\" column=\"checkname\" orderkey=\"checkname\" />"+
						"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(33810,user.getLanguage())+"\" column=\"countresourceid\" orderkey=\"countresourceid\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\""+SystemEnv.getHtmlLabelName(33423,user.getLanguage())+"\" />"+
						"<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(33811,user.getLanguage())+"\" column=\"countcheckercount\" orderkey=\"countcheckercount\" transmethod=\"weaver.hrm.common.SplitPageTagFormat.colFormat\" otherpara=\""+SystemEnv.getHtmlLabelName(33423,user.getLanguage())+"\" />"+
					"</head>"+
				"</table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
	</BODY>
</HTML>
