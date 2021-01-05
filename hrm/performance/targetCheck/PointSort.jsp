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
String titlename = SystemEnv.getHtmlLabelName(18267,user.getLanguage());
String needfav ="1";
String needhelp ="";
String currentYear=TimeUtil.getCurrentDateString().substring(0,4);
String CurrentUser = ""+user.getUID();
%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
<style>
#tabPane tr td{padding-top:2px}
#monthHtmlTbl td,#seasonHtmlTbl td{cursor:hand;text-align:center;padding:0 2px 0 2px;color:#333;text-decoration:underline}
.cycleTD{font-family:MS Shell Dlg,Arial;background-image:url(/images/tab2.png);cursor:hand;font-weight:bold;text-align:center;color:#666;border-bottom:1px solid #879293;}
.cycleTDCurrent{font-family:MS Shell Dlg,Arial;padding-top:2px;background-image:url(/images/tab.active2.png);cursor:hand;font-weight:bold;text-align:center;color:#666}
.seasonTDCurrent,.monthTDCurrent{color:black;font-weight:bold;background-color:#CCC}
#subTab{border-bottom:1px solid #879293;padding:0}
</style>
</HEAD>
<script language=javascript>
 function resetbanner(objid,typeid){
  	for(i=1;i<=3;i++){
  	    
  		document.all("oTDtype_"+i).background="/images/tab2.png";
  		document.all("oTDtype_"+i).className="cycleTD";
  	}
  	document.all("oTDtype_"+objid).background="/images/tab.active2.png";
  	document.all("oTDtype_"+objid).className="cycleTDCurrent";
    var o = document.iframem.document;
    o.location="PointSortType.jsp?type_d="+typeid;
  
  }
 </script>
<body style="overflow:auto">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width="100%" height="100%" cellspacing="0"  cellpadding="0">
<tr>
<td height="30">
<%@ include file="/systeminfo/TopTitle.jsp" %>
 <table style="width:100%;height:95%" border=0 cellspacing=0 cellpadding=0  scrolling=no id="tabPane">
	  <colgroup>
	  	<col width="10"/>
		<col width="79"/>
		<col width="79"/>
		<col width="79"/>
		<col width="*"/>
		<col width="10"/>
		</colgroup>
       <TBODY>
       <tr><td height="2%" clospan="6"></td></tr>
	  <tr align=left height="20">
	  <td></td>
	  <td class="cycleTDCurrent" name="oTDtype_1"  id="oTDtype_1" background="/images/tab2.png" width=79px align=center onmouseover="style.cursor='hand'" onclick="resetbanner(1,1)" ><b><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></b></td>
	  <td class="cycleTD" name="oTDtype_2" id="oTDtype_2"  background="/images/tab2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(2,2)"><b><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></b></td>
      <td class="cycleTD" name="oTDtype_3"  id="oTDtype_3" background="/images/tab2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(3,3)" ><b><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></b></td>
      <td style="border-bottom:1px solid rgb(145,155,156)">&nbsp;</td>
      <td></td>
	  </tr>
	 <tr>
	 <td></td>
	 <td colspan="4" style="padding:0;">
	 <iframe src="PointSortType.jsp?type_d=1" ID="iframem" name="iframem" frameborder=0 style="padding:0;width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0" scrolling="auto"/>
	</td>
		<td></td>
	</tr>
  </TBODY>
</TABLE>
</td>
</tr>
</table>

</body>