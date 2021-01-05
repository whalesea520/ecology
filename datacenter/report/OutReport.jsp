<%@ page language="java" contentType="text/html; charset=GBK" %>
<%@ include file="/systeminfo/init.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(15514,user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>

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

<%if(HrmUserVarify.checkUserRight("DataCenter:Maintenance", user)) {%>
	<TABLE class=liststyle cellspacing=1 >
	  <COLGROUP>
	  <COL width="100%">
	  <TBODY>
	  <TR class=Header>
	    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15436,user.getLanguage())%></TH></TR>
	  <TR class=Header>
	    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
	  </TR><TR class=Line><TD></TD></TR> 
	<%
	      rs.executeProc("T_OutReport_SelectAll","0");  // 固定报表
	      boolean isLight = false;
	
	      while(rs.next()){
		    String outrepid = Util.null2String(rs.getString("outrepid")) ;
	        String outrepname = Util.toScreen(rs.getString("outrepname"),user.getLanguage()) ;
	        String outrepenname = Util.null2String(rs.getString("outrepenname")) ;
	        if(user.getLanguage() == 8 && !outrepenname.equals("")) outrepname = outrepenname ;
	
	        isLight = ! isLight ;
	%>
	  <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
	    <TD><a href='/datacenter/report/OutReportSel.jsp?outrepid=<%=outrepid%>'><%=outrepname%></a></TD>
	  </TR>
	<%
	    }
	%>  
	 </TBODY></TABLE>
	
	 <br> <br>
	
	<TABLE class=liststyle cellspacing=1 >
	  <COLGROUP>
	  <COL width="100%">
	  <TBODY>
	  <TR class=Header>
	    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(17070,user.getLanguage())%></TH></TR>
	  <TR class=Header>
	    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
	  </TR><TR class=Line><TD></TD></TR> 
	<%
	      rs.executeProc("T_OutReport_SelectAll","2");  // 排序报表
	      isLight = false;
	
	      while(rs.next()){
		    String outrepid = Util.null2String(rs.getString("outrepid")) ;
		  	String outrepname = Util.toScreen(rs.getString("outrepname"),user.getLanguage()) ;
	        String outrepenname = Util.null2String(rs.getString("outrepenname")) ;
	        if(user.getLanguage() == 8 && !outrepenname.equals("")) outrepname = outrepenname ;
	        isLight = ! isLight ;
	%>
	  <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
	    <TD><a href='/datacenter/report/OutReportSel.jsp?outrepid=<%=outrepid%>'><%=outrepname%></a></TD>
	  </TR>
	<%
	    }
	%>  
	 </TBODY></TABLE>
	 
	 <br> <br>
	
	 <TABLE class=liststyle cellspacing=1 >
	  <COLGROUP>
	  <COL width="100%">
	  <TBODY>
	  <TR class=Header>
	    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(16538,user.getLanguage())%></TH></TR>
	  <TR class=Header>
	    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
	  </TR><TR class=Line><TD></TD></TR> 
	<%
	      rs.executeProc("T_OutReport_SelectAll","1");  // 明细报表
	      isLight = false;
	
	      while(rs.next()){
		    String outrepid = Util.null2String(rs.getString("outrepid")) ;
		  	String outrepname = Util.toScreen(rs.getString("outrepname"),user.getLanguage()) ;
	        String outrepenname = Util.null2String(rs.getString("outrepenname")) ;
	        if(user.getLanguage() == 8 && !outrepenname.equals("")) outrepname = outrepenname ;
	        isLight = ! isLight ;
	%>
	  <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
	    <TD><a href='/datacenter/report/OutReportSel.jsp?outrepid=<%=outrepid%>'><%=outrepname%></a></TD>
	  </TR>
	<%
	    }
	%>  
	 </TBODY></TABLE>
<%}else{
	char separator = Util.getSeparator() ;
	String userid = user.getUID() + "";
	String para = userid + separator + "1" ;
	%>
	 <TABLE class=liststyle cellspacing=1 >
	  <COLGROUP>
	  <COL width="100%">
	  <TBODY>
	  <TR class=Header>
	    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15101,user.getLanguage())%></TH></TR>
	  <TR class=Header>
	    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
	  </TR><TR class=Line><TD></TD></TR> 
	<%
	      rs.executeProc("T_OutReport_SelectByUserid",para);  // 报表
	      boolean isLight = false;
	
	      while(rs.next()){
		    String outrepid = Util.null2String(rs.getString("outrepid")) ;
		  	String outrepname = Util.toScreen(rs.getString("outrepname"),user.getLanguage()) ;
	        String outrepenname = Util.null2String(rs.getString("outrepenname")) ;
	        if(user.getLanguage() == 8 && !outrepenname.equals("")) outrepname = outrepenname ;
	        isLight = ! isLight ;
	%>
	  <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
	    <TD><a href='/datacenter/report/OutReportSel.jsp?outrepid=<%=outrepid%>'><%=outrepname%></a></TD>
	  </TR>
	<%
	    }
	%>  
	 </TBODY></TABLE>
<%}%>
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
