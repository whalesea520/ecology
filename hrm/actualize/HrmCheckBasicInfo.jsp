
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- modified by wcd 2014-07-01 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<%
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String id = Util.null2String(request.getParameter("id"));
	
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename =SystemEnv.getHtmlLabelName(7014,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	ArrayList checkitemids = new ArrayList() ;
	ArrayList checkitemproportions = new ArrayList() ;
	String sql = "select checkitemid , checkitemproportion from HrmCheckKindItem where checktypeid in (select checktypeid from HrmCheckList where id = "+id+")";
	rs.executeSql(sql) ;
	while(rs.next()) {
		String checkitemid = Util.null2String(rs.getString("checkitemid"));
		String checkitemproportion = Util.null2String(rs.getString("checkitemproportion"));
		checkitemids.add(checkitemid) ;
		checkitemproportions.add(checkitemproportion) ;
	}
%>
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = parent.parent.getParentWindow(parent);
			var parentDialog = parent.parent.getDialog(parent);
			if("<%=isclose%>"=="1"){
				parentWin.onBtnSearchClick();
				parentWin.closeDialog();	
			}
			
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}
			
			var dialog = null;
			var dWidth = 600;
			var dHeight = 400;
			var id = "<%=id%>";
			function closeDialog(){
				if(dialog)
					dialog.close();
				window.location.href="/hrm/actualize/HrmCheckBasicInfo.jsp?id="+id;
			}
			
			function openCheckResource(resourceid){
				showDetail(resourceid);
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
				doOpen("/hrm/HrmDialogTab.jsp?_fromURL=hrmCheckInfo&method=HrmCheckResourceInfo&isdialog=1&checkid=<%=id%>&id="+id,"<%=SystemEnv.getHtmlLabelNames("6106,17463",user.getLanguage())%>");
			}
		</script>
	</head>
	<BODY>
		<%if("1".equals(isDialog)){ %>
			<div class="zDialog_div_content">
		<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right;">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<%
			String _sql = rs.getDBType().equals("oracle")?"number":"decimal";
			String backFields = "a.resourceid,b.lastname,c.jobtitlename,d.departmentname,a.aCount,a.bCount,a.result"; 
			String sqlFrom  = "from ( select a.resourceid,count(1) as aCount, SUM((case when a.result > 0 then 1 else 0 end)) as bCount,cast(SUM(a.result*a.proportion/100) as "+_sql+"(10,2)) as result from HrmByCheckPeople a where a.checkid = "+id +" group by a.resourceid ) a left join HrmResource b on a.resourceid = b.id left join HrmJobTitles c on b.jobtitle = c.id left join HrmDepartment d on b.departmentid = d.id ";
			String sqlWhere = "";
			String orderby = "" ;
			
			String operateString = "<operates width=\"20%\">";
			operateString+="     <operate href=\"javascript:showDetail();\" text=\""+(SystemEnv.getHtmlLabelName(6106,user.getLanguage())+SystemEnv.getHtmlLabelName(17463,user.getLanguage()))+"\" index=\"0\"/>";
			operateString+="</operates>";
			
			String tableString=""+
				"<table pageId=\""+Constants.HRM_Z_043+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Z_043,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
					"<sql backfields=\""+backFields+"\" sqlform=\""+sqlFrom+"\" sqlprimarykey=\"a.resourceid\" sqlorderby=\""+orderby+"\" sqlsortway=\"asc\" sqldistinct=\"true\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"/>"+
					operateString+
					"<head>"+
						"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(27511,user.getLanguage())+"\" column=\"departmentname\" orderkey=\"departmentname\" />"+
						"<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitlename\" orderkey=\"jobtitlename\" />"+
						"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15648,user.getLanguage())+"\" column=\"lastname\" orderkey=\"lastname\" linkvaluecolumn=\"resourceid\" linkkey=\"id\" href=\"/hrm/HrmTab.jsp?_fromURL=HrmResource\" target=\"_blank\" />"+
						"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(15649,user.getLanguage())+"\" column=\"result\" orderkey=\"result\" />"+
						"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(33812,user.getLanguage())+"\" column=\"aCount\" orderkey=\"aCount\" transmethod=\"weaver.hrm.common.plugin.PluginTagFormat.colFormat\" otherpara=\"HrmCheckBasicInfo+"+SystemEnv.getHtmlLabelName(33423,user.getLanguage())+"+column:resourceid+\" />"+
						"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(33813,user.getLanguage())+"\" column=\"bCount\" orderkey=\"bCount\" transmethod=\"weaver.hrm.common.plugin.PluginTagFormat.colFormat\" otherpara=\"HrmCheckBasicInfo+"+SystemEnv.getHtmlLabelName(33423,user.getLanguage())+"+column:resourceid+\" />"+
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
	</BODY>
</HTML>
