<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>

<%
if(!HrmUserVarify.checkUserRight("DataCenter:Maintenance", user)) {
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>


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
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(15436,user.getLanguage())+",OutReportAdd.jsp?outrepcategory=0,_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(17070,user.getLanguage())+",OutReportAdd.jsp?outrepcategory=2,_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+SystemEnv.getHtmlLabelName(16538,user.getLanguage())+",OutReportAdd.jsp?outrepcategory=1,_self} " ;
RCMenuHeight += RCMenuHeightStep;

%>

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
  <COL width="60%">
  <COL width="20%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15436,user.getLanguage())%></TH></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD>行数</TD>
	<TD>列数</TD>
    
  </TR><TR class=Line><TD colspan="3"  style="padding:0;"></TD></TR> 
<%
      rs.executeProc("T_OutReport_SelectAll","0");  // 固定报表
      boolean isLight = false;

      while(rs.next()){
	    String outrepid = Util.null2String(rs.getString("outrepid")) ;
	  	String outrepname = Util.toScreen(rs.getString("outrepname"),user.getLanguage()) ;
		String outreprow = Util.null2String(rs.getString("outreprow")) ;
		String outrepcolumn = Util.null2String(rs.getString("outrepcolumn")) ;
        isLight = ! isLight ;
		
%>
  <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
    <TD><a href='OutReportEdit.jsp?outrepid=<%=outrepid%>'><%=outrepname%></a></TD>
    <TD><%=outreprow%></TD>
	<TD><%=outrepcolumn%></TD>
    
  </TR>
<%
    }
%>  
 </TBODY></TABLE>

 <br> <br>


 <TABLE class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="60%">
  <COL width="20%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(17070,user.getLanguage())%></TH></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD>列数</TD>
	<TD>描述</TD>
    
  </TR><TR class=Line ><TD colspan="3" style="padding:0;"></TD></TR> 
<%
      rs.executeProc("T_OutReport_SelectAll","2");  // 排序报表
      while(rs.next()){
	    String outrepid = Util.null2String(rs.getString("outrepid")) ;
	  	String outrepname = Util.toScreen(rs.getString("outrepname"),user.getLanguage()) ;
      String outreprow = Util.null2String(rs.getString("outreprow")) ;
		  String outrepcolumn = Util.null2String(rs.getString("outrepcolumn")) ;
      String outrepdesc = Util.toScreen(rs.getString("outrepdesc"),user.getLanguage()) ;
      isLight = ! isLight ;
		
%>
  <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
    <TD><a href='OutReportEdit.jsp?outrepid=<%=outrepid%>'><%=outrepname%></a></TD>
    <TD><%=outreprow%></TD>
    <TD><%=outrepcolumn%></TD>
  </TR>
<%
    }
%>  
 </TBODY></TABLE>

 <br> <br>

 <TABLE class=liststyle cellspacing=1 >
  <COLGROUP>
  <COL width="40%">
  <COL width="60%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(16538,user.getLanguage())%></TH></TR>
  <TR class=Header>
    <TD>名称</TD>
    <TD>描述</TD>
    
  </TR><TR class=Line  ><TD colspan="3"  style="padding:0;"></TD></TR> 
<%
      rs.executeProc("T_OutReport_SelectAll","1");  // 明细报表

      while(rs.next()){
	    String outrepid = Util.null2String(rs.getString("outrepid")) ;
	  	String outrepname = Util.toScreen(rs.getString("outrepname"),user.getLanguage()) ;
		String outrepdesc = Util.null2String(rs.getString("outrepdesc")) ;
		isLight = ! isLight ;
%>
  <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
    <TD><a href='OutReportEdit.jsp?outrepid=<%=outrepid%>'><%=outrepname%></a></TD>
    <TD><%=outrepdesc%></TD>
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
