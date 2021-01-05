<%@page import="weaver.page.menu.MenuCenterCominfo"%>
<%@page import="weaver.formmode.cuspage.cpt.CptGenmenu4mode"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.proj.util.PropUtil"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>



<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename ="";
String needfav ="1";
String needhelp ="";
String toggle=Util.null2String(request.getParameter("toggle"));
if(!"".equals(toggle)){
	CptGenmenu4mode.toggleMenu(toggle);
}



String sql="select module from MainMenuInfo where parentId=8 ";
String currentType="standardcpt";
String toggleType="modecpt";
String btnTitle= SystemEnv.getHtmlLabelName(127971,user.getLanguage());
RecordSet.executeSql(sql);
if(RecordSet.next()){
	currentType=Util.null2String( RecordSet.getString("module"));
}
if("modecpt".equalsIgnoreCase(currentType)){
	btnTitle= SystemEnv.getHtmlLabelName(127972,user.getLanguage());
	toggleType="standardcpt";
}


%>
<BODY>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(127973,user.getLanguage())%>" />
</jsp:include>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>


<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=form2 name=form2 action="" >
<input type="hidden" name="toggle" value="<%=toggleType %>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<span id="advancedSearch" class="advancedSearch" style="display:none;"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage())%></span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<!-- advanced search -->
<div class="advancedSearchDiv" id="advancedSearchDiv" style="display:none;">
</div>
<div style="height:100px;"></div>
<div style="text-align: center;vertical-align: middle;">
	<input type="button" value="<%=btnTitle %>" class="e8_btn_top" style="height:80px;width: 150px;" onclick="form2.submit()"/>
</div>


<script type="text/javascript">


$(function(){
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
});
function onBtnSearchClick(){
	form2.submit();
}
</script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
</BODY>
</HTML>
