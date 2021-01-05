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
String titlename = SystemEnv.getHtmlLabelName(18058,user.getLanguage());
String needfav ="1";
String needhelp ="";
String currentYear=TimeUtil.getCurrentDateString().substring(0,4);
String CurrentUser = ""+user.getUID();
//要创建的计划的所有者类型  "1"：分部 "2":部门 "3"：人力资源
String type_d=Util.null2String(request.getParameter("type_d")); 
//要创建的计划的所有者ID
String objId=Util.null2String(request.getParameter("objId")); 

if (objId.equals("")) 
{
objId=CurrentUser;
type_d="3";
}

String objName="";
if (type_d.equals("1"))
{
objName=SubCompanyComInfo.getSubCompanyname(objId);
}
else if (type_d.equals("2"))
{
objName=DepartmentComInfo.getDepartmentname(objId);
}
else if (type_d.equals("3"))
{
objName=ResourceComInfo.getLastname(objId);
}

SessionOper.setAttribute(session,"hrm.objId",objId);
SessionOper.setAttribute(session,"hrm.objName",objName);
SessionOper.setAttribute(session,"hrm.type_d",type_d);

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
<SCRIPT language="javascript" src="/js/weaver.js"></script>
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
    var o = parent.contentframe.iframes.document;
    o.location="MyCheck.jsp?type="+typeid+"&type_d=<%=type_d%>&objId=<%=objId%>&years="+years;
  
  }
 </script>
<body style="overflow:auto">
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
<form name=weaver id=weaver>
<table width="100%" height="100%" cellspacing="0" cellpadding="0">
<tr>
<td style="height: 100%">
	  <table style="width:98%;height:95%" border=0 cellspacing=0 cellpadding=0  scrolling=no id="tabPane">
	  <colgroup>
		<col width="79"></col>
		<col width="79"></col>
		<col width="79"></col>
		<col width="79"></col>
		<col width="*"></col>
		</colgroup>
	  <tr align=left height="20">
	  <td class="cycleTDCurrent" nowrap name="oTDtype_0"  id="oTDtype_0" background="/images/tab.active2.png" width=79px  align=center onmouseover="style.cursor='hand'"  onclick="resetbanner(0,0)"><b>
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
	  <td class="cycleTD" nowrap name="oTDtype_3"  id="oTDtype_3" background="/images/tab2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(3,3)" ><b><%=SystemEnv.getHtmlLabelName(18059,user.getLanguage())%></b></td>
	  <td class="cycleTD" nowrap name="oTDtype_1"  id="oTDtype_1" background="/images/tab2.png" width=79px align=center onmouseover="style.cursor='hand'" onclick="resetbanner(1,1)" ><b><%=SystemEnv.getHtmlLabelName(17495,user.getLanguage())%></b></td>
	  <td class="cycleTD" nowrap name="oTDtype_2" id="oTDtype_2"  background="/images/tab2.png" width=79px  align=center onmouseover="style.cursor='hand'" onclick="resetbanner(2,2)"><b><%=SystemEnv.getHtmlLabelName(6076,user.getLanguage())%></b></td>
      <td style="border-bottom:1px solid rgb(145,155,156)">&nbsp;</td>
	  </tr>
	  <tr>
      <td  colspan="5" style="padding:0;">
      <iframe src="MyCheck.jsp?type=0&type_d=<%=type_d%>&objId=<%=objId%>&years=<%=currentYear%>" ID="iframes" name="iframes" style="width:100%;height:100%;border-right:1px solid #879293;border-bottom:1px solid #879293;border-left:1px solid #879293;padding:10px;padding-right:0" scrolling="auto" frameborder="0"/>
      </td></tr>
	  </table>

</td></tr></table>
</form>
</body>