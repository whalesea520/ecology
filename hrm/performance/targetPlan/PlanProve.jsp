<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="autoPlan" class="weaver.hrm.performance.targetplan.AutoPlan" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%

String needfav ="1";
String needhelp ="";
String titlename = SystemEnv.getHtmlLabelName(18507,user.getLanguage());
String imagefilename = "/images/hdHRM.gif";
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
  	for(i=0;i<=1;i++){
  		document.all("oTDtype_"+i).background="/images/tab2.png";
  		document.all("oTDtype_"+i).className="cycleTD";
  	}
  	document.all("oTDtype_"+objid).background="/images/tab.active2.png";
  	document.all("oTDtype_"+objid).className="cycleTDCurrent";
    var o = document.iframes.document;
    o.location="/workflow/search/WFSearchTemp.jsp?method=reqeustbybill&billid=145&complete="+typeid;
  
  }
 </script>
<body style="overflow:auto">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name=weaver id=weaver>
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr>
<td height="100%">
<%@ include file="/systeminfo/TopTitle.jsp" %>

 <table style="width:98%;height:95%" border=0 cellspacing=0 cellpadding=0  scrolling=no id="tabPane">
	  <colgroup>
		<col width="79"></col>
		<col width="79"></col>
		<col width="*"></col>
		</colgroup>
  <TBODY><tr align=left height="5"><td colspan="3"></td></tr>
	  <tr align=left height="20">
	  <td class="cycleTDCurrent"  name="oTDtype_0" id="oTDtype_0"  background="/images/tab.active2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(0,0)"><b><%=SystemEnv.getHtmlLabelName(1422,user.getLanguage())%></b></td>
	  <td class="cycleTD"  name="oTDtype_1"  id="oTDtype_1" background="/images/tab2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(1,2)" ><b><%=SystemEnv.getHtmlLabelName(1423,user.getLanguage())%></b></td>
      <td style="border-bottom:1px solid rgb(145,155,156)">&nbsp;</td>
	  </tr>
	  <tr>
		 <td  colspan="3" style="padding:0;">
		 <iframe src="/workflow/search/WFSearchTemp.jsp?method=reqeustbybill&billid=145&complete=0" ID="iframes" name="iframes" frameborder="0" style="width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0" scrolling="auto"/>
		</td></tr>
		</TBODY>
	  </table>
</td>
</tr>
</table>
</form>
</body>