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
</HEAD>
<script language=javascript>
 function resetbanner(objid,typeid){
 

 
  	for(i=0;i<=3;i++){
  		document.all("oTDtype_"+i).background="/cowork/images/bgdark.gif";
  	}
  	document.all("oTDtype_"+objid).background="/cowork/images/bglight.gif";
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
<form name=weaver id=weaver>
<TABLE class=viewform width=100% id=oTable1 height=32px border=0>
  <COLGROUP>
  <COL width="50%">
  <COL width=5>
  <COL width="50%">
  <TBODY>
  <tr>
  	<td  height=30 colspan=3 background="/cowork/images/bg1.gif" align=left>
	  <table width=100% border=0 cellspacing=0 cellpadding=0 height=100%  scrolling=no>
	  <tr aligh=left>
	   <td nowrap background="/cowork/images/bg1.gif" width=15px height=100% align=center></td>
	  <td nowrap name="oTDtype_0"  id="oTDtype_0" background="/cowork/images/bgdark.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(0,0)" ><b><%=SystemEnv.getHtmlLabelName(18106,user.getLanguage())%></b></td>
	  <td nowrap name="oTDtype_1"  id="oTDtype_1" background="/cowork/images/bglight.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(1,1)" ><b><%=SystemEnv.getHtmlLabelName(18107,user.getLanguage())%></b></td>
	  <td nowrap name="oTDtype_2" id="oTDtype_2"  background="/cowork/images/bglight.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(2,2)"><b><%=SystemEnv.getHtmlLabelName(18108,user.getLanguage())%></b></td>
	  <td nowrap name="oTDtype_3"  id="oTDtype_3" background="/cowork/images/bglight.gif" width=70px height=100% align=center onmouseover="style.cursor='hand'" onclick="resetbanner(3,3)" ><b><%=SystemEnv.getHtmlLabelName(6106,user.getLanguage())%></b></td>
      <td nowrap valign=top width=100% height=100%></td>
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
 <iframe src="alertListType.jsp?type=0" ID="iframeAlert" name="iframeAlert" style="width:100%;height:100%" scrolling="auto"/>
</td></tr>
</table>

</body>