<%@ page import="java.util.*,java.math.*,java.io.*,weaver.general.Util,weaver.file.*,weaver.datacenter.*" %>

<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="OutReportManage" class="weaver.datacenter.OutReportManage" scope="session" />
<jsp:useBean id="ExcelFile" class="weaver.file.ExcelFile" scope="session"/>

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String acceptlanguage = request.getHeader("Accept-Language");
if(!"".equals(acceptlanguage))
	acceptlanguage = acceptlanguage.toLowerCase();

String islink = Util.null2String(request.getParameter("islink"));
String outrepid = Util.null2String(request.getParameter("outrepid"));
String modulename = Util.null2String(request.getParameter("modulename"));

//String userid = "" + user.getUID();
//String usertype = user.getLogintype() ;
String designusername = user.getUsername() ;


Calendar today = Calendar.getInstance();
String currentyear = Util.add0(today.get(Calendar.YEAR), 4) ;
String currentmonth = Util.add0(today.get(Calendar.MONTH) + 1, 2) ;
String currentday = Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;
String currentdate = currentyear + " " + SystemEnv.getHtmlLabelName(445,user.getLanguage()) + " " + currentmonth + " " + SystemEnv.getHtmlLabelName(6076,user.getLanguage()) + " " + currentday + " " + SystemEnv.getHtmlLabelName(16889,user.getLanguage()) ;




ExcelSheet es = null ;
ExcelRow er = null ;

if(!islink.equals("1")) {
    OutReportManage.init(request, user) ;
    OutReportManage.initReportValue() ;
    es = new ExcelSheet() ;
}

String outrepname = OutReportManage.getOutRepName() ;
String modulefilename = OutReportManage.getModulefilename() ;
int reportrowcount = OutReportManage.getReportRowCount() ;
int outrepcolumn = OutReportManage.getReportColumnCount() ;

if(!modulename.equals("")) outrepname += " (" + modulename + ") " ;

String yearf = OutReportManage.getYearf() ;
String monthf = OutReportManage.getMonthf() ;   
String dayf = OutReportManage.getDayf() ;  
String yeart = OutReportManage.getYeart() ;  
String montht = OutReportManage.getMontht() ;
String dayt = OutReportManage.getDayt() ;


String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(15101,user.getLanguage()) + ": " + outrepname ;
String needfav ="1";
String needhelp ="";
%>
<BODY <% if( !modulefilename.equals("") ) {%>onload="return init()"<%}%> >
<%@ include file="/systeminfo/TopTitle.jsp" %>
<DIV>
<BUTTON class=btn accessKey=S onClick="javascript:location.href='OutReportSel.jsp?outrepid=<%=outrepid%>'"><U>S</U>-<%=SystemEnv.getHtmlLabelName(15518,user.getLanguage())%></BUTTON>
<% if( modulefilename.equals("") ) { // 没有插件的时候导出Excel插件来显示报表的时候不显示excel %>      
<BUTTON class=btn accessKey=E onClick="javascript:location.href='/weaver/weaver.file.ExcelOut'"><U>E</U>-<%=SystemEnv.getHtmlLabelName(17416,user.getLanguage())%>Excel</BUTTON>
<% } else { // 插件的功能 %>
<BUTTON class=btn accessKey=E onClick="javascript:ChinaExcel.OnSaveAsExcelFile();"><U>E</U>-<%=SystemEnv.getHtmlLabelName(17416,user.getLanguage())%>Excel</BUTTON>
<BUTTON class=btn accessKey=P onClick="javascript:ChinaExcel.OnFilePrint();"><U>P</U>-<%=SystemEnv.getHtmlLabelName(257,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=U onClick="javascript:ChinaExcel.OnPrintSetup();"><U>U</U>-<%=SystemEnv.getHtmlLabelName(20756,user.getLanguage())%></BUTTON>
<BUTTON class=btn accessKey=V onClick="javascript:ChinaExcel.OnFilePrintPreview();"><U>V</U>-<%=SystemEnv.getHtmlLabelName(20757,user.getLanguage())%></BUTTON>
<% } %>
</DIV>
<br>
<table width=100% height=90% border="0" cellspacing="0" cellpadding="0">
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
<% 
if( modulefilename.equals("") ) {   // 原来的显示方式
%>
		
    <TABLE class=liststyle cellspacing=1 >
      <TBODY>
      <TR class=header>
        <TH colSpan=<%=outrepcolumn%>><%=SystemEnv.getHtmlLabelName(15101,user.getLanguage())%> :  <%=outrepname%>
        </TH>
      </TR>
      <TR class=line>
        <TD  colSpan=<%=outrepcolumn%>></TD>
      </TR>
    <% 

    boolean isLight = false;
    for(int j=1; j<reportrowcount+1 ; j++) {  // 每行
        if(!islink.equals("1")) er =es.newExcelRow () ;
        isLight = ! isLight ;
    %>
      <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
    <%                      
        for(int i= 1; i<outrepcolumn+1 ; i++) {  // 每列
            String thevalue = OutReportManage.getReportValue(j,i) ;
            boolean isdigital = false ;
            if(Util.getDoubleValue(thevalue,-9999.99) != -9999.99 && i!=1 && j!=1) {
                isdigital = true ;
                thevalue = "" + (new BigDecimal(thevalue)).divide ( new BigDecimal ( 1 ), 2, BigDecimal.ROUND_HALF_DOWN ).doubleValue() ;
                if(!islink.equals("1")) er.addValue(Util.getfloatToString(thevalue)) ;
                thevalue = Util.getFloatStr(Util.getfloatToString(thevalue),3) ;
            }
            else {
                String tempthevalue = thevalue ;
                thevalue = Util.StringReplace(thevalue,"^" , "<br>") ;
                if(!islink.equals("1"))  er.addStringValue(Util.StringReplace(tempthevalue,"^" , ",")) ;
            }
    %>
        <TD <%if(i==1 || j==1) {%> style="BACKGROUND-COLOR:#d6d3ce" align=center <%} else if(isdigital) {%> align=right <%}%>><nobr>
            <% if(thevalue.equals("")) {%>&nbsp;<%} else {%><%=thevalue%><%}%>
        </TD>
    <%
        }   
    %>
      </TR>
    <%  
    }

    if(!islink.equals("1")) {
        ExcelFile.init() ;
        ExcelFile.setFilename(outrepname) ;
        ExcelFile.addSheet(outrepname, es) ;
    }

    %>  
     </TBODY></TABLE>
<%
} else {      // 由插件显示
 
%>
<%if(acceptlanguage.indexOf("zh-tw")>-1||acceptlanguage.indexOf("zh-hk")>-1){%>
<script language=javascript src="/workflow/mode/chinaexcelobj_tw.js"></script>
<%}else{%>
<script language=javascript src="/workflow/mode/chinaexcelobj.js"></script>
<%} %>


<% 
}
%>

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

<% if( !modulefilename.equals("") ) {%>
<SCRIPT FOR="ChinaExcel" EVENT="MouseLClick()"	LANGUAGE="JavaScript" >
    rightMenu.style.visibility="hidden";
    return false;
</SCRIPT>
<SCRIPT FOR="ChinaExcel" EVENT="MouseRClick()"	LANGUAGE="JavaScript" >
        rightMenu.style.left=ChinaExcel.offsetLeft+ChinaExcel.GetMousePosX();
        rightMenu.style.top=ChinaExcel.offsetTop+ChinaExcel.GetMousePosY();
		rightMenu.style.visibility="visible";
		return false;
</SCRIPT>
<script language=javascript>

function init()
{
    ChinaExcel.Login("泛微软件","891e490cd34e3e33975b1b7e523e8b32","上海泛微网络技术有限公司");
	ChinaExcel.ReadHttpTabFile("/reportModel/<%=modulefilename%>.tab");
    // ChinaExcel.SetStatFetchDataMode("OutReportXml.jsp",1);
    ChinaExcel.DesignMode = false;
    ChinaExcel.ReCalculate();
	ChinaExcel.SetOnlyShowTipMessage(false);
    setChinaExcelValue("ReportTitle","<%=outrepname%>");
    setChinaExcelValue("ReportDesigner","<%=designusername%>");
    setChinaExcelValue("ReportDate","<%=currentdate%>");

    setChinaExcelValue("yearf","<%=yearf%>");
    setChinaExcelValue("monthf","<%=monthf%>");
    setChinaExcelValue("dayf","<%=dayf%>");
    setChinaExcelValue("yeart","<%=yeart%>");
    setChinaExcelValue("montht","<%=montht%>");
    setChinaExcelValue("dayt","<%=dayt%>");

    ChinaExcel.ReCalculate();
    ChinaExcel.SetPasteType(1);
    ChinaExcel.SetCanAutoSizeHideCols(true);
    ChinaExcel.SetProtectFormShowCursor(true);
    ChinaExcel.ShowGrid = false;
    ChinaExcel.height="100%";
    ChinaExcel.RefreshViewSize();
}

function setChinaExcelValue(setKey,valueStr)
{
	TitleRow=ChinaExcel.GetCellUserStringValueRow(setKey);
	TitleCol=ChinaExcel.GetCellUserStringValueCol(setKey);	
	ChinaExcel.SetCellVal(TitleRow,TitleCol,valueStr);
	ChinaExcel.Refresh();
}

function onCbClick(szCommand)
{
	switch(szCommand.toUpperCase())
	{
		case "CMDPRINTSETUP":
			ChinaExcel.OnPrintSetup();			
			break;
		case "CMDFILEPRINT":
			ChinaExcel.OnFilePrint();			
			break;
		case "CMDFILEPRINTPREVIEW":
			ChinaExcel.OnFilePrintPreview();
			break;
		case "CMDABOUT":
			ChinaExcel.AboutBox();
			break;
	}
}

</script>

<%}%>
 
</BODY></HTML>
