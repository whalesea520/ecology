<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.conn.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%
String needfav ="1";
String needhelp ="";
String currentYear=TimeUtil.getCurrentDateString().substring(0,4);
String type_d=request.getParameter("type_d");
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
    years=document.all("years").value;
  	for(i=0;i<=3;i++){
  		document.all("oTDtype_"+i).background="/images/tab2.png";
  		document.all("oTDtype_"+i).className="cycleTD";
  	}
  	document.all("oTDtype_"+objid).background="/images/tab.active2.png";
  	document.all("oTDtype_"+objid).className="cycleTDCurrent";
    var o = parent.iframem.iframes.document;
    o.location="PointSortDetail.jsp?type="+typeid+"&type_d=<%=type_d%>&pointType=1&years="+years;
  
  }
 </script>
<body style="overflow:auto" >
<form name=weaver id=weaver>
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr>
<td height="100%">

<table style="width:100%;height:95%" border=0 cellspacing=0 cellpadding=0  scrolling=no id="tabPane">
	  <colgroup>
		<col width="79"></col>
		<col width="79"></col>
		<col width="79"></col>
		<col width="79"></col>
		<col width="*"></col>
		</colgroup>
       <TBODY>
	  <tr align=left height="20">
	  <td class="cycleTDCurrent" name="oTDtype_0"  id="oTDtype_0" background="/images/tab.active2.png" width=79px  align=center onmouseover="style.cursor='hand'"  onclick="resetbanner(0,0)"><b>
	  <select name="years" onchange="resetbanner(0,0)">
	   <%for (int i=Util.getIntValue(currentYear)-10; i<Util.getIntValue(currentYear)+11;i++) {%>
	  <option value="<%=i%>" <%if (String.valueOf(i).equals(currentYear)) {%>selected<%}%>><%=i%></option>
	  <%}%>
	  <!-- option value="2005" <%if (currentYear.equals("2005")) {%>selected<%}%>>2005</option>
	  <option value="2006" <%if (currentYear.equals("2006")) {%>selected<%}%>>2006</option>
	  <option value="2007" <%if (currentYear.equals("2007")) {%>selected<%}%>>2007</option>
	  <option value="2008" <%if (currentYear.equals("2008")) {%>selected<%}%>>2008</option>
	  <option value="2009" <%if (currentYear.equals("2009")) {%>selected<%}%>>2009</option>
	  <option value="2010" <%if (currentYear.equals("2010")) {%>selected<%}%>>2010</option>
	  <option value="2011" <%if (currentYear.equals("2011")) {%>selected<%}%>>2011</option>
	  <option value="2012" <%if (currentYear.equals("2012")) {%>selected<%}%>>2012</option-->
	  </select>
	  <%=SystemEnv.getHtmlLabelName(445,user.getLanguage())%></b></td>
	  <td class="cycleTD" name="oTDtype_3"  id="oTDtype_3" background="/images/tab2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(3,3)" ><b><%=SystemEnv.getHtmlLabelName(18059,user.getLanguage())%></b></td>
	  <td class="cycleTD" name="oTDtype_1"  id="oTDtype_1" background="/images/tab2.png" width=79px align=center onmouseover="style.cursor='hand'" onclick="resetbanner(1,1)" ><b><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%></b></td>
	  <td class="cycleTD" name="oTDtype_2" id="oTDtype_2"  background="/images/tab2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(2,2)"><b><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></b></td>
      <td style="border-bottom:1px solid rgb(145,155,156)">&nbsp;</td>
	  </tr>
	 <tr>
	 <td colspan="5" style="padding:0;">
	 <iframe src="PointSortDetail.jsp?type=0&type_d=<%=type_d%>&years=<%=currentYear%>" ID="iframes" name="iframes" frameborder=0 style="width:100%;height:100%;padding:0px;padding-right:0" scrolling="auto"/>
	</td></tr>
  </TBODY>
</TABLE>
</td>
</tr>
</table>
</form>
</body>