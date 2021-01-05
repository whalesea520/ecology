<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page language="java" contentType="text/html; charset=gbk" %> <%@ include file="/systeminfo/init.jsp" %>

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
String outrepid = Util.null2String(request.getParameter("outrepid"));
String systemset = Util.null2String(request.getParameter("systemset"));

// 如果systemset 为1 则为系统管理员设置的模板， 否则为用户自定义的模板
String userid = "0" ;
String usertype = "0" ;

if( !systemset.equals("1") ) {
    userid = "" + user.getUID();
    usertype = user.getLogintype() ;
}

String imagefilename = "/images/hdHRM.gif";
String titlename = SystemEnv.getHtmlLabelName(16367,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",ReportSearchModuleAdd.jsp?outrepid="+outrepid+"&systemset="+systemset+",_self} " ;
RCMenuHeight += RCMenuHeightStep;

String backurl = "" ;
if( systemset.equals("1") ) backurl = "OutReportEdit.jsp?outrepid="+outrepid ;
else backurl = "/datacenter/report/OutReportSel.jsp?outrepid="+outrepid ;

RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+","+backurl+",_self} " ;
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
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></TH></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD colspan="2"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
    
  </TR><TR class=Line><TD colspan="3" style="padding:0;"></TD></TR> 
<%

String sql="select * from outrepmodule where outrepid = " + outrepid + " and userid= "+userid+" and usertype = " + usertype ;

boolean isLight = false;
rs.executeSql(sql);
while(rs.next()){
    String id=Util.null2String(rs.getString("id")) ;
    String modulename=Util.null2String(rs.getString("modulename")) ;
    String moduledesc=Util.null2String(rs.getString("moduledesc")) ;
    isLight = ! isLight ;
%>
  <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
    <TD><a href='ReportSearchModuleEdit.jsp?id=<%=id%>&systemset=<%=systemset%>'><%=modulename%></a></TD>
    <TD colspan="2"><%=moduledesc%></TD>
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
