
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!-- modified by wcd 2014-07-30 [E7 to E8] -->
<%@ include file="/hrm/header.jsp" %>
<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(16530,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17602,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(17088,user.getLanguage());
	String needfav ="1";
	String needhelp ="";

	String qname = Util.null2String(request.getParameter("flowTitle"));
	String formLabel = Util.null2String(request.getParameter("formlabel"));
	String parentFormLabel = Util.null2String(request.getParameter("parentFormLabel"));
%>
<HTML>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
		<script type="text/javascript">
			function onBtnSearchClick(){
				jQuery("#searchfrm").submit();
			}
		</script>	
	</head>
	<body>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form action="" name="searchfrm" id="searchfrm">
			<table id="topTitle" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<td class="rightSearchSpan" style="text-align:right;">
						<input type="text" class="searchInput" name="flowTitle" value="<%=qname%>"/>
						<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span><span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
					</td>
				</tr>
			</table>
			<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;" >
				<wea:layout type="4col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(20331,user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(15517,user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="formlabel" name="formlabel" class="inputStyle" value='<%=formLabel%>'></wea:item>
						<wea:item><%=SystemEnv.getHtmlLabelName(15434,user.getLanguage())%></wea:item>
						<wea:item><input type="text" id="parentFormLabel" name="parentFormLabel" class="inputStyle" value='<%=parentFormLabel%>'></wea:item>
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
			String backfields = " a.id,a.parentId,a.formLabel,b.formlabel as parentFormLabel "; 
			String fromSql  = " cus_treeform a left join cus_treeform b on a.parentid = b.id ";
			String sqlWhere = " a.viewtype = '1' and b.scope= 'HrmCustomFieldByInfoType' AND b.parentid = 0 ";
			String orderby = " b.formlabel " ;
			String tableString = "";
			
			if(qname.length() > 0){
				sqlWhere += " and a.formLabel like '%"+qname+"%'";
			}else if(formLabel.length() > 0){
				sqlWhere += " and a.formLabel like '%"+formLabel+"%'";
			}
			if(parentFormLabel.length()>0){
				sqlWhere += " and b.formLabel like '%"+parentFormLabel+"%'";
			}
			tableString =" <table pageId=\""+Constants.HRM_Q_013+"\" pagesize=\""+PageIdConst.getPageSize(Constants.HRM_Q_013,user.getUID(),Constants.HRM)+"\" tabletype=\"none\">"+
				" <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"a.id\" sqlsortway=\"Asc\" sqlisdistinct=\"true\"/>"+
		    "	<head>"+
		    "		<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(15517,user.getLanguage())+"\" column=\"formlabel\" orderkey=\"formlabel\" linkkey=\"scopeid\" linkvaluecolumn=\"id\" href=\"/hrm/report/resource/HrmRpSubSearch.jsp\" target=\"_self\"/>"+
			"		<col width=\"50%\" text=\""+SystemEnv.getHtmlLabelName(15434,user.getLanguage())+"\" column=\"parentFormLabel\" orderkey=\"parentFormLabel\" />"+
		    "	</head>"+
		    " </table>";
		%>
		<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run" />
	</BODY>
</HTML>