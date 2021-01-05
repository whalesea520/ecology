<%@ page language="java" contentType="text/html; charset=GBK" %> 
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.general.*" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";

String years=Util.null2String(request.getParameter("years"));
String months=Util.null2String(request.getParameter("months"));
String quarters=Util.null2String(request.getParameter("quarters"));
String weeks=Util.null2String(request.getParameter("weeks"));
String type=Util.null2String(request.getParameter("type"));
int id = Util.getIntValue(request.getParameter("id"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<script language=javascript>
function ok(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(19775,user.getLanguage())%>")){
		location.href = 'PlanRevisionOperation.jsp?operateType=1&id=<%=id%>&years=<%=years%>&months=<%=months%>&quarters=<%=quarters%>&weeks=<%=weeks%>&type=<%=type%>';
	}
}
function cancel(){
	if(confirm("<%=SystemEnv.getHtmlLabelName(19776,user.getLanguage())%>")){
		location.href = "PlanRevisionOperation.jsp?operateType=0&id=<%=id%>&years=<%=years%>&months=<%=months%>&quarters=<%=quarters%>&weeks=<%=weeks%>&type=<%=type%>";
	}
}
</script>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(142,user.getLanguage())+",javascript:ok(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(236,user.getLanguage())+",javascript:cancel(),_self}" ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<FORM style="MARGIN-TOP: 10px" name=frmMain method=post action="">
<!--=================================-->
<%
String sqlWhere = " where planId="+id+"";
String tableString=""+
	"<table pagesize=\"10\" tabletype=\"none\">"+
	"<sql backfields=\"operateTime,operator,operateType,clientIP\" sqlform=\"WorkplanRevision"+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlprimarykey=\"operateTime\" sqlsortway=\"Desc\" />"+
	"<head>"+
	"<col width=\"30%\" text=\""+SystemEnv.getHtmlLabelName(15502,user.getLanguage())+"\" column=\"operateTime\" orderkey=\"operateTime\" />"+
	"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(99,user.getLanguage())+"\" column=\"operator\" orderkey=\"operator\" target=\"_self\" linkkey=\"id\" linkvaluecolumn=\"operator\" href=\"/hrm/resource/HrmResource.jsp\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getHrmname\" />"+
	"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"operateType\" transmethod=\"weaver.splitepage.transform.SptmForKPI.getOperateTypeName\" otherpara=\""+user.getLanguage()+"\" />"+
	"<col width=\"30%\" text=\"IP\" column=\"clientIP\" orderkey=\"clientIP\"/>"+
	"</head>"+
	"</table>";

%>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="false"/> 
</form>
</BODY>
</HTML>
    
