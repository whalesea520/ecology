<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String printtype = Util.null2String(request.getParameter("printtype"));  // 1: 个人 2： 部门
String printscrope = Util.null2String(request.getParameter("printscrope"));        // 1: 当前 2： 全部
String printdet = Util.null2String(request.getParameter("printdet"));        // 1: 当前 2： 全部

String modulefilename = "" ;
if(printtype.equals("1")) {
    if(printdet.equals("1")) modulefilename = "personsalary1" ;
    else if(printdet.equals("2")) modulefilename = "personsalary2" ;
}
else if(printtype.equals("2")) modulefilename = "departmentsalary" ;


session.setAttribute("weaverprinttype" , printtype) ;
session.setAttribute("weaverprintscrope" , printscrope) ;

%>
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css></HEAD>
<BODY onload="return init()">
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
<BUTTON class=btn accessKey=P onClick="javascript:ChinaExcel.OnFilePrint();"><U>P</U>-<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=U onClick="javascript:ChinaExcel.OnPrintSetup();"><U>U</U>-<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(68,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=V onClick="javascript:ChinaExcel.OnFilePrintPreview();"><U>V</U>-<%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></BUTTON>

<div> <!--style="display:none"-->
<object width="100%" height="100%" classid="CLSID:15261F9B-22CC-4692-9089-0C40ACBDFDD8" codeBase="/weaverplugin/chinaexcelweb.cab#VERSION=3.6.7.1" name="ChinaExcel" id="ChinaExcel">
<param name="_Version" value="65536">
<param name="_ExtentX" value="20505">
<param name="_ExtentY" value="14155">
<param name="_StockProps" value="0">
</OBJECT>
</div>

<table width=100% class=Viewform>
<TR>
<TD height=100 align="center" valign="middle"><%=SystemEnv.getHtmlLabelName(83492,user.getLanguage())%></td>
</tr>
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

<script language=javascript>
function init()
{
    ChinaExcel.Login("<%=SystemEnv.getHtmlLabelName(83493,user.getLanguage())%>","891e490cd34e3e33975b1b7e523e8b32","<%=SystemEnv.getHtmlLabelName(83494,user.getLanguage())%>");
	ChinaExcel.ReadHttpTabFile("/reportModel/<%=modulefilename%>.tab");
    ChinaExcel.DesignMode = false;
    ChinaExcel.ReCalculate();
	ChinaExcel.SetOnlyShowTipMessage(false);
    ChinaExcel.ReCalculate();
//    ChinaExcel.OnFilePrint();
}

function setChinaExcelValue(setKey,valueStr)
{
	TitleRow=ChinaExcel.GetCellUserStringValueRow(setKey);
	TitleCol=ChinaExcel.GetCellUserStringValueCol(setKey);	
	ChinaExcel.SetCellVal(TitleRow,TitleCol,valueStr);
	ChinaExcel.Refresh();
}
</script>

</body>
</html>