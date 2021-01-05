<%@ page import="weaver.general.Util,java.util.*,java.math.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />


<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver.js"></script>
</head>
<%
String inprepid = Util.null2String(request.getParameter("inprepid"));
String inprepname = Util.fromScreen(request.getParameter("inprepname"),user.getLanguage());
String dspdate = Util.null2String(request.getParameter("dspdate"));
String inprepbudget = Util.null2String(request.getParameter("inprepbudget"));
String thetable = Util.null2String(request.getParameter("thetable"));
String thedate = Util.null2String(request.getParameter("thedate"));
String currentdate = Util.null2String(request.getParameter("currentdate"));
String hasvalue = Util.null2String(request.getParameter("hasvalue"));
String hasmod = Util.null2String(request.getParameter("hasmod"));
String inputid = Util.null2String(request.getParameter("inputid"));
String inputmodid = Util.null2String(request.getParameter("inputmodid"));
String crmid = Util.null2String(request.getParameter("crmid"));
String fromcheck = Util.null2String(request.getParameter("fromcheck"));

String imagefilename = "/images/hdHRMCard.gif";
String titlename = Util.toScreen("输入报表确认",user.getLanguage(),"0") + inprepname;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosubmit(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>

<FORM id=frmMain name=frmMain action="InputReportUploadOperation.jsp" method=post enctype="multipart/form-data">
    <input type="hidden" name="inprepid" value="<%=inprepid%>">
    <input type="hidden" name="inprepname" value="<%=inprepname%>">
    <input type="hidden" name="thetable" value="<%=thetable%>">
    <input type="hidden" name="thedate" value="<%=thedate%>">
    <input type="hidden" name="currentdate" value="<%=currentdate%>">
    <input type="hidden" name="dspdate" value="<%=dspdate%>">
    <input type="hidden" name="hasvalue" value="<%=hasvalue%>">
    <input type="hidden" name="hasmod" value="<%=hasmod%>">
    <input type="hidden" name="inputid" value="<%=inputid%>">
    <input type="hidden" name="inputmodid" value="<%=inputmodid%>">
    <input type="hidden" name="inprepbudget" value="<%=inprepbudget%>">
    <input type="hidden" name="crmid" value="<%=crmid%>">
    <input type="hidden" name="fromcheck" value="<%=fromcheck%>">

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

  <table class=viewform>
    <COLGROUP> <COL width="15%"> <COL width="5%"> <COL width="80%"> <tbody> 
    <tr > 
      <td><nobr><b><%=inprepname%> : <font color=red><%=dspdate%></font></b></td>
      <td align=right colspan=2></td>
    </tr>
   <TR><TD class=Line1 colSpan=3></TD></TR> 
    <tr> 
      <td colspan=2>Excel文件</td>
      <td>
        <input type="file" name="excelfile">
      </td>
    </tr> <TR><TD class=Line1 colSpan=3></TD></TR> 

    </tbody> 
  </table>
  
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

</form>

<script language=javascript>
function dosubmit() {
    if(check_form(document.frmMain,'excelfile')) {
        document.frmMain.submit() ;
    }
}
</script>
</BODY></HTML>
