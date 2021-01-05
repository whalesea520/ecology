<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
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
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%@ include file="/systeminfo/RightClickMenu.jsp" %>
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

<TABLE class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="40%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=4>待确认报表</TH></TR>
  <TR class=Header>
    <TD>报表名称</TD>
    <TD>报表日期</TD>
	<TD>填报单位</TD>
	<TD>填报日期</TD>
  </TR>
  <TR class=line>
    <TD colSpan=4 ></TD></TR>
<%
      rs.executeProc("T_IRConfirm_SelectByUserid",""+user.getUID());

      int needchange = 0;
      while(rs.next()){
	    String confirmid = Util.null2String(rs.getString("confirmid")) ;
		String inputid = Util.null2String(rs.getString("inputid")) ;
		String inprepname = Util.toScreen(rs.getString("inprepname"),user.getLanguage()) ;
	  	String inprepdspdate = Util.toScreen(rs.getString("inprepdspdate"),user.getLanguage()) ;
		String inprepbudget = Util.null2String(rs.getString("inprepbudget")) ;
		String crmid = Util.null2String(rs.getString("crmid")) ;
		String thetable = Util.null2String(rs.getString("thetable")) ;
		String inputdate = "" ;

        if( !inputid.equals("0") ) {
            rs1.executeSql("select inputdate from " + thetable +" where inputid = " + inputid) ;
            if(rs1.next()) inputdate = Util.null2String(rs1.getString("inputdate")) ;
        }
        else {
            rs1.executeSql("select inputdate from " + thetable +" where reportdate = '" + inprepdspdate + "'") ;
            if(rs1.next()) inputdate = Util.null2String(rs1.getString("inputdate")) ;
        }
		
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}%>
    <TD><a href='ReportConfirmDetail.jsp?confirmid=<%=confirmid%>'><%=inprepname%></a>
		<% if(inprepbudget.equals("1")) {%> 预算 <%}%>
        <% if(inprepbudget.equals("2")) {%> 预测 <%}%>
	</TD>
    <TD><%=inprepdspdate%></TD>
	<TD><%=CustomerInfoComInfo.getCustomerInfoname(crmid)%></TD>
	<TD><%=inputdate%></TD>
    
  </TR>
<%
    }
%>  
 </TBODY></TABLE>
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

</BODY></HTML>
