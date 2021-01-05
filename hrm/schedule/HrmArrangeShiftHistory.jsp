<%@ page import = "weaver.general.Util" %>
<%@ page import = "weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file = "/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id = "RecordSet" class = "weaver.conn.RecordSet" scope = "page"/>
<HTML><HEAD>
<LINK href = "/css/Weaver_wev8.css" type = text/css rel = STYLESHEET>
<script language=javascript src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript">
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}

</script>
</head>

<%
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(16255 , user.getLanguage()) ; 
String needfav = "1" ; 
String needhelp = "" ; 
String qname = Util.null2String(request.getParameter("flowTitle"));

%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/schedule/HrmArrangeShiftList.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
*/
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<form action="" name="searchfrm" id="searchfrm">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="text" class="searchInput" name="flowTitle" value="<%=qname %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
</form>
<%
String backfields = " id, shiftname, shiftbegintime, shiftendtime, (validedatefrom+'~'+validedateto) as validedatefrom "; 
String fromSql  = " from HrmArrangeShift ";
String sqlWhere = " where ishistory=1 ";
String orderby = " id " ;
String tableString = "";

if(!qname.equals("")){
	sqlWhere += " and shiftname like '%"+qname+"%'";
}		
 
tableString =" <table pageId=\""+PageIdConst.Hrm_ArrangeShiftHistory+"\" tabletype=\"none\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.Hrm_ArrangeShiftHistory,user.getUID(),PageIdConst.HRM)+"\" >"+
		"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>"+
    "			<head>"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(195,user.getLanguage())+"\" column=\"shiftname\" orderkey=\"shiftname\" />"+
    "				<col width=\"40%\" text=\""+SystemEnv.getHtmlLabelName(742,user.getLanguage())+"\" column=\"shiftbegintime\" orderkey=\"shiftbegintime\"/>"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(743,user.getLanguage())+"\" column=\"shiftendtime\" orderkey=\"shiftendtime\"/>"+
    "				<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(15030,user.getLanguage())+"\" column=\"validedatefrom\" orderkey=\"validedatefrom\"/>"+
    "			</head>"+
    " </table>";
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.Hrm_ArrangeShiftHistory %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  /> 
</BODY></HTML>
