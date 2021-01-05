<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("DataCenter:Maintenance", user)) {
    response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
    String imagefilename = "/images/hdHRM_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(15218,user.getLanguage());
    String needfav = "1" ;
    String needhelp = "" ;
    String sql = "" ;
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
//RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_top} " ;
//RCMenuHeight += RCMenuHeightStep ;
%>

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
 <br>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <COL width="40%">
  <COL width="20%">
  <COL width="20%">  
  <COL width="20%">
  <TBODY>
  <TR class=header>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(15219,user.getLanguage())%></TH></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(15189,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15220,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15221,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15222,user.getLanguage())%></TD>
  </TR>
<TR class=Line><TD colSpan=4></TD></TR>
<%
    String rsearchname = "" ;
    int countfrom = 0 ;
    int fromcount = 0 ;
    int countfade = 0 ;
    int needchange = 0;
    String inprepid = "";
    String inputid = "" ;
    sql = " select * from T_ResearchTable";
    rs.executeSql(sql);
    while(rs.next()){
        inputid = rs.getString("inputid");
        inprepid = rs.getString("inprepid");
        rsearchname = rs.getString("rsearchname");
        countfrom = Util.getIntValue(rs.getString("countfrom"),0);
        fromcount = Util.getIntValue(rs.getString("fromcount"),0);
        countfade = Util.getIntValue(rs.getString("countfade"),0);
               
        if(needchange ==0){
            needchange = 1;

%>
            <TR class=datalight>
<%
        }else{
  		    needchange=0;
%>          <TR class=datadark>
<%
        }
%>
    <TD><a href="/CRM/investigate/CountForm.jsp?inprepid=<%=inprepid%>&inputid=<%=inputid%>"><%=rsearchname%></a></TD>
    <TD>
	<%=countfrom%>
	</TD>
    <TD>
	<%=fromcount%>
	</TD>
    <TD>
	<%=countfade%>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>