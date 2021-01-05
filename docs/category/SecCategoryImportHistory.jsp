
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.IsGovProj" %>
<html>
<HEAD> 
    <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
    <SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
	<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>

<% 
	if (!HrmUserVarify.checkUserRight("DocSecCategoryAdd:add",user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	String message = Util.null2String(request.getParameter("message"));
%>
<script language=javascript >
var parentWin = parent.getParentWindow(window);
var dialog = parent.getDialog(window);

</script>
</HEAD>

<body style="overflow:hidden;">


<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<%} %>
<%	

				String tableString=""+
					   "<table  pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_DOCLOG,user.getUID(),PageIdConst.DOC)+"\" tabletype=\"none\">"+
					   "<sql backfields=\"*\"  sqlform=\"docseccategoryimporthistory\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"desc\"  sqldistinct=\"true\" />"+
					   "<head>";
					   		tableString+=	 "<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18596,user.getLanguage())+SystemEnv.getHtmlLabelName(17482,user.getLanguage())+"\"  	transmethod=\"weaver.docs.category.DocSecCategoryTransMethod.getUserName\" 	column=\"operateuserid\" 	otherpara=\""+user.getLogintype()+"\"  	orderkey=\"operateuserid\" />";
							tableString+=	 "<col width=\"25%\"  text=\""+SystemEnv.getHtmlLabelName(20515,user.getLanguage())+"\"  	transmethod=\"weaver.docs.category.DocSecCategoryTransMethod.getDateTime\"	column=\"operatedate\" 		otherpara=\"column:operatetime\"  	orderkey=\"operatedate\" />";
					   		tableString +=   "<col width=\"40%\"  text=\""+SystemEnv.getHtmlLabelName(82341,user.getLanguage())+"\"   	transmethod=\"weaver.docs.category.DocSecCategoryTransMethod.getResult\"  	column=\"successnum\" 		otherpara=\"column:failnum+column:id\" 		orderkey=\"successnum\"/>";
							tableString +=	 "<col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(33586,user.getLanguage())+"\"  	column=\"clientaddress\"  	orderkey=\"clientaddress\" />"+
					   "</head>"+
					   "</table>";
%>
<br>
<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>         
<%if("1".equals(isDialog)){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parent.getDialog(window).close()">
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
 <jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>       
</body>
</html>

<SCRIPT LANGUAGE="JavaScript">
	function openResultDialog(historyid){
		var	_time = jQuery("#line" + historyid).closest("td").prev().html();
		dialog = new window.top.Dialog();
		dialog.currentWindow = window; 
		dialog.URL = "/docs/category/SecCategoryImportResult.jsp?isdialog=1&historyid="+historyid;
		dialog.Title = _time+ "-<%=SystemEnv.getHtmlLabelName(82341,user.getLanguage())%>";
		dialog.Width = 650;
		dialog.Height = 520;
		dialog.Drag = true;
		dialog.show();
	}

</SCRIPT>

