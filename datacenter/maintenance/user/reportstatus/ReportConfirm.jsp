<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerContacterComInfo" class="weaver.crm.Maint.CustomerContacterComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = Util.toScreen("输入报表确认",user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

<DIV class=HdrProps></DIV>

 <br>
<TABLE class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="40%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <TBODY>
  <TR class=title>
    <TH colSpan=4>待确认报表</TH></TR>
  <TR class=spacing>
    <TD class=line1 colSpan=4 ></TD></TR>
  <TR class=Header>
    <TD>报表名称</TD>
    <TD>报表日期</TD>
	<TD>填报人</TD>
	<TD>填报日期</TD>
  </TR>
<%
    String usercrmid = ""+ user.getUID() ;
    String contacterid = ""+user.getTitle() ;
    char separator = Util.getSeparator() ;
    String para = usercrmid + separator + contacterid ;
    rs.executeProc("T_InputReportConfirm_SByUID",para);

    boolean isLight = false ;
    while(rs.next()){
        String confirmid = Util.null2String(rs.getString("confirmid")) ;
        String inputid = Util.null2String(rs.getString("inputid")) ;
        String inprepname = Util.toScreen(rs.getString("inprepname"),user.getLanguage()) ;
        String inprepdspdate = Util.toScreen(rs.getString("inprepdspdate"),user.getLanguage()) ;
        String inprepbudget = Util.null2String(rs.getString("inprepbudget")) ;
        String crmid = Util.null2String(rs.getString("crmid")) ;
        String thetable = Util.null2String(rs.getString("thetable")) ;
        String reportuserid = Util.null2String(rs.getString("reportuserid")) ;
        String inputdate = "" ;
        String fullname = CustomerContacterComInfo.getCustomerContactername(reportuserid) ; ;

        if(reportuserid.equals(contacterid)) continue ;

        if( !inputid.equals("0") ) {
            rs1.executeSql("select inputdate from " + thetable +" where inputid = " + inputid) ;
            if(rs1.next()) inputdate = Util.null2String(rs1.getString("inputdate")) ;
        }
        else {
            rs1.executeSql("select inputdate from " + thetable +" where reportdate = '" + inprepdspdate + "' and crmid =" + crmid) ;
            if(rs1.next()) inputdate = Util.null2String(rs1.getString("inputdate")) ;
        }

        isLight = !isLight ; 
%>
  <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
    <TD><a href='ReportConfirmDetail.jsp?confirmid=<%=confirmid%>'><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%> - <%=inprepname%></a>
		<% if(inprepbudget.equals("1")) {%> 预算 <%}%>
        <% if(inprepbudget.equals("2")) {%> 预测 <%}%>
	</TD>
    <TD><%=inprepdspdate%></TD>
	<TD><%=fullname%></TD>
	<TD><%=inputdate%></TD>
    
  </TR>
<%
    }
%>  
 </TBODY></TABLE>
 
</BODY></HTML>
