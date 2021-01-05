<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(140,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCompany:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(140,user.getLanguage())+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+10+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="20%">
  <COL width="30%">
  <COL width="40%">
  <COL width="10%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></TH></TR>
 
  <TR class=Header>    
    <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15768,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
  </TR>

<%
       rs.executeProc("HrmCompany_Select","");
    int needchange = 0;
      while(rs.next()){
      String companyweb = rs.getString("companyweb"); 
       try{
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
    <%  	}%>    
    <TD><a href="/hrm/company/HrmCompanyEdit.jsp?id=<%=rs.getInt(1)%>"><%=rs.getString("companyname")%></a></TD>
    <TD><%=rs.getString("companydesc")%></TD>
    <TD><a href="http://<%=companyweb%>"><%=rs.getString("companyweb")%></a></TD>
    <TD><a href="/hrm/company/HrmDepartment.jsp?companyid=<%=rs.getInt(1)%>"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></a></TD>    
  </TR>
<%
      }catch(Exception e){
        rs.writeLog(e.toString());
      }
      break;
    }
%>  
 </TBODY></TABLE>

</BODY></HTML>
