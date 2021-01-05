<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="java.util.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="kpi" class="weaver.hrm.performance.goal.KPIComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="hrm" class="weaver.hrm.resource.ResourceComInfo" scope="page" />

<%@ include file="/systeminfo/init.jsp" %>
<%
int goalId = Util.getIntValue(request.getParameter("id"));
String goalName = kpi.getName(String.valueOf(goalId));

String imagefilename = "/images/hdMaintenance.gif";
String titlename = SystemEnv.getHtmlLabelName(330,user.getLanguage()) + SystemEnv.getHtmlLabelName(19765,user.getLanguage()) + ": ";
titlename += "<a href='myGoalView.jsp?id="+goalId+"'>"+goalName+"</a>";
String needfav ="1";
String needhelp ="";    

int userid=0;
userid=user.getUID();
%>
<html>
<head>
<link href="/css/Weaver.css" type="text/css" rel="stylesheet">
<script language="javascript" src="/js/weaver.js"></script>
<script language="javascript" src="/js/addRowBg.js"></script>
<script type="text/javascript">

</script>
</head>
  
<body>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM style="MARGIN-TOP: 10px" name=frmMain method=post action="">
<!--=================================-->
<%
String sqlWhere = " where goalId="+goalId+"";
String tableString=""+
	"<table pagesize=\"10\" tabletype=\"none\">"+
	"<sql backfields=\"*\" sqlform=\"HrmKPIRevisionDetail"+Util.toHtmlForSplitPage(sqlWhere)+"\" sqlprimarykey=\"operateTime\" sqlsortway=\"Desc\" />"+
	"<head>"+
	"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(15502,user.getLanguage())+"\" column=\"operateTime\" orderkey=\"operateTime\" />"+
	"<col width=\"10%\" text=\""+SystemEnv.getHtmlLabelName(99,user.getLanguage())+"\" column=\"operator\" orderkey=\"operator\" target=\"_self\" linkkey=\"id\" linkvaluecolumn=\"operator\" href=\"/hrm/resource/HrmResource.jsp\" transmethod=\"weaver.splitepage.transform.SptmForDoc.getHrmname\" />"+
	//"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(63,user.getLanguage())+"\" column=\"operateType\" transmethod=\"weaver.splitepage.transform.SptmForKPI.getOperateTypeName\" otherpara=\""+user.getLanguage()+"\" />"+
	"<col width=\"15%\" text=\""+SystemEnv.getHtmlLabelName(261,user.getLanguage())+"\" column=\"fieldName\" orderkey=\"fieldName\" transmethod=\"weaver.splitepage.transform.SptmForKPI.getFieldName\" otherpara=\""+user.getLanguage()+"\" />"+
	"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(19766,user.getLanguage())+"\" column=\"originalValue\" orderkey=\"originalValue\"/>"+
	"<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(19767,user.getLanguage())+"\" column=\"updatedValue\" orderkey=\"updatedValue\"/>"+
	"<col width=\"15%\" text=\"IP\" column=\"clientIP\" orderkey=\"clientIP\"/>"+
	"</head>"+
	"</table>";

%>
<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" isShowTopInfo="true"/> 
<!--=================================-->
</form>
</body>
</html>
