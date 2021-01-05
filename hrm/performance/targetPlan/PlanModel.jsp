<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(18220,user.getLanguage());
String needfav ="1";
String needhelp ="";
String currentYear=TimeUtil.getCurrentDateString().substring(0,4);
String CurrentUser = ""+user.getUID();

String objId=CurrentUser; 
String type_d="3";
String objName="";
objName=ResourceComInfo.getLastname(objId);


SessionOper.setAttribute(session,"hrm.objId",objId);
SessionOper.setAttribute(session,"hrm.objName",objName);
SessionOper.setAttribute(session,"hrm.type_d",type_d);

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</HEAD>
<script language=javascript>
 function resetbanner(objid,typeid){
   
  	for(i=0;i<=3;i++){
  		document.all("oTDtype_"+i).background="/images/tab2.png";
  	}
  	document.all("oTDtype_"+objid).background="/images/tab.active2.png";
    var o = document.iframes.document;
    o.location="PlanModelAdd.jsp?type="+typeid+"&type_d=<%=type_d%>&objId=<%=objId%>";
  
  }
 </script>
<body style="overflow:auto">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr>
<td height="60">
<%@ include file="/systeminfo/TopTitle.jsp" %>
<form name=weaver id=weaver>
<TABLE class=viewform width=100% id=oTable1 height=32px border=0>
  <COLGROUP>
  <COL width="50%">
  <COL width=5>
  <COL width="50%">
  <TBODY>
  <tr>
  	<td  height=30 colspan=3  align=left>
  	<style>#tabPane tr td{padding:3px 0 0 1px}</style>
	  <table width=100% border=0 cellspacing=0 cellpadding=0  scrolling=no id="tabPane">
	  <tr aligh=left>
	  <td nowrap name="oTDtype_0"  id="oTDtype_0" background="/images/tab.active2.png" width=79px  align=center onmouseover="style.cursor='hand'"  onclick="resetbanner(0,0)"><b>
	  <%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></b></td>
	  <td nowrap name="oTDtype_1"  id="oTDtype_1" background="/images/tab2.png" width=79px align=center onmouseover="style.cursor='hand'" onclick="resetbanner(1,1)" ><b><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%></b></td>
	  <td nowrap name="oTDtype_2" id="oTDtype_2"  background="/images/tab2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(2,2)"><b><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></b></td>
	  <td nowrap name="oTDtype_3"  id="oTDtype_3" background="/images/tab2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(3,3)" ><b><%=SystemEnv.getHtmlLabelName(1926,user.getLanguage())%></b></td>
      <td style="border-bottom:1px solid rgb(145,155,156)">&nbsp;</td>
	  </tr>
	  </table>
	</td>
  </tr>
  </TBODY>
</TABLE>


</form>


 
</td>
</tr>
<tr>
<td height="*">
 <iframe src="PlanModelAdd.jsp?type=0&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=currentYear%>" ID="iframes" name="iframes" style="width:100%;height:100%" scrolling="auto"/>
</td></tr>
</table>

</body>