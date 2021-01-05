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
String titlename = Util.toScreen("报表条件项",user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",OutReportConditionAdd.jsp,_self} " ;
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
  <COL width="40%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=4>报表条件项</TH></TR>
  <TR class=Header>
    <TD>条件名称</TD>
    <TD>数据库字段名</TD>
    <TD>条件描述</TD>
	<TD>条件类型</TD>
    
  </TR>
  <TR class=line >
    <TD colSpan=4 style="padding: 0px"></TD></TR>
<%
      rs.executeProc("T_Condition_SelectAll","");
      int needchange = 0;
    
      while(rs.next()){
	    String conditionid = Util.null2String(rs.getString("conditionid")) ;
	  	String conditionname = Util.toScreen(rs.getString("conditionname"),user.getLanguage()) ;
        String conditionitemfieldname = Util.null2String(rs.getString("conditionitemfieldname")) ;
        String conditiondesc = Util.toScreen(rs.getString("conditiondesc"),user.getLanguage()) ;
		String conditiontype = Util.null2String(rs.getString("conditiontype")) ;
		String issystemdef = Util.null2String(rs.getString("issystemdef")) ;
		
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}%>
    <TD><%if(!issystemdef.equals("1")) {%><a href='OutReportConditionEdit.jsp?conditionid=<%=conditionid%>'><%}%><%=conditionname%><%if(!issystemdef.equals("1")) {%></a><%}%></TD>
      <TD><%=conditionitemfieldname%></TD>
    <TD><%=conditiondesc%></TD>
	<TD>
	<% if(conditiontype.equals("1")) { %>文本型
	<%} else if(conditiontype.equals("2")) { %>选择型
    <%} else if(conditiontype.equals("3")) { %>公式型<%}%>
	</TD>
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
