<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>

<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(18046,user.getLanguage());
String needfav ="1";
String needhelp ="";

%>
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
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
    
    document.iframeAlert.document.resource.bton.click();
    if (document.all("changed").value=="1")
    {return;}
 
  	for(i=0;i<=2;i++){
  		document.all("oTDtype_"+i).background="/images/tab2.png";
  		document.all("oTDtype_"+i).className="cycleTD";
  	}
  	document.all("oTDtype_"+objid).background="/images/tab.active2.png";
  	document.all("oTDtype_"+objid).className="cycleTDCurrent";
    var o = document.frames[1].document;
    o.location="alertListType.jsp?type="+typeid;
  
  }
 </script>
<body style="overflow:auto">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr>
<td height="60">
<%@ include file="/systeminfo/TopTitle.jsp" %>
</td>
<tr>
<td valign="top" style="width:100%">
<form name=weaver id=weaver style="height:100%">
<input type="hidden" name="changed" value="0">
<table style="width:100%;height:95%" border=0 cellspacing=0 cellpadding=0  scrolling=no id="tabPane">
	  <colgroup>
		<col width="79"></col>
		<col width="79"></col>
		<col width="79"></col>
		<!-- col width="79"></col-->
		<col width="*"></col>
		</colgroup>
      <TBODY>
      <tr>
      <td height="1px"></td></tr>
	  <tr align=left height="20">
	  <td class="cycleTDCurrent" name="oTDtype_0"  id="oTDtype_0" background="/images/tab.active2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(0,0)" ><b><%=SystemEnv.getHtmlLabelName(18106,user.getLanguage())%></b></td>
	  <td class="cycleTD" name="oTDtype_1"  id="oTDtype_1" background="/images/tab2.png" width=79px align=center onmouseover="style.cursor='hand'" onclick="resetbanner(1,1)" ><b><%=SystemEnv.getHtmlLabelName(18107,user.getLanguage())%></b></td>
	  <td class="cycleTD" name="oTDtype_2" id="oTDtype_2"  background="/images/tab2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(2,2)"><b><%=SystemEnv.getHtmlLabelName(18108,user.getLanguage())%></b></td>
	  <!-- td class="cycleTD" name="oTDtype_3"  id="oTDtype_3" background="/images/tab2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(3,3)" ><b><%=SystemEnv.getHtmlLabelName(6106,user.getLanguage())%></b></td-->
      <td style="border-bottom:1px solid rgb(145,155,156)">&nbsp;</td>
	  </tr>
		<tr>
		<td colspan="4" style="padding:0;">
		 <iframe src="alertListType.jsp?type=0" ID="iframeAlert" name="iframeAlert" frameborder="0" style="width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0" scrolling="auto"/>
		</td></tr>
  </TBODY>
</TABLE>

</form>

 
</td>
</tr>
</table>

</body>