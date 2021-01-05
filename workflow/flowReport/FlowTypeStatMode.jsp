
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</head>
<BODY>
<%
String imagefilename = "/images/hdReport_wev8.gif" ; 
String titlename = SystemEnv.getHtmlLabelName(19032 , user.getLanguage()) ; 
String needfav = "1" ;
String needhelp = "" ; 
String userRights=shareRights.getUserRights("-4",user);//得到用户查看范围
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="10" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top">
<FORM id=frmMain name=frmMain action=FnaBudgetDepartment.jsp method=post>
<!--查询条件-->
</FORM>
<TABLE class=ListStyle cellspacing=1 >
<!--详细内容在此-->
  <COLGROUP> <col width="30%"> <col width="10%"> <col width="10%"> 
  <col width="10%"> <col width="10%"> <col width="10%"> <col width="10%">
  <col align=right width="10%">

</TABLE>
<fieldset style="overflow:auto;height:90%;border-width:0px;">

</fieldset>
<!--详细内容结束-->
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="10" colspan="3"></td>
</tr>
</table>
<script>
</script>
</body></html>
