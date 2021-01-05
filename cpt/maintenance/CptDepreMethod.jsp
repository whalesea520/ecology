<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(837,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<DIV class=HdrProps></DIV>
<%
if(HrmUserVarify.checkUserRight("CptDepreMethodAdd:Add", user)){
%>
<BUTTON class=BtnNew id=button2 accessKey=1 name=button2 onclick="location.href='CptDepreMethod1Add.jsp'"><U>1</U>-<%=SystemEnv.getHtmlLabelName(835,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON>
<BUTTON class=BtnNew id=button2 accessKey=2 name=button2 onclick="location.href='CptDepreMethod2Add.jsp'"><U>2</U>-<%=SystemEnv.getHtmlLabelName(836,user.getLanguage())%>:<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON>
<%
}
%>
<TABLE class=ListShort>
  <COLGROUP>
  <COL width="30%">
  <COL width="20%">
  <COL width="50%">
  <TBODY>
  <TR class=Section>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(837,user.getLanguage())%></TH></TR>
  <TR class=separator>
    <TD class=Sep1 colSpan=3></TD></TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
    
  </TR>
 
<%
       rs.executeProc("CptDepreMethod_Select","");
    int needchange = 0;
      while(rs.next()){
		String	name=rs.getString("name");
		String	depretype=rs.getString("depretype");
		String	description=rs.getString("description");
       try{
       	if(needchange ==0){
       		needchange = 1;
%>
  <TR class=datalight>
  <%
  	}else{
  		needchange=0;
  %><TR class=datadark>
  <%  	}
	if(depretype.equals("1")){
  %>
    <TD><a href="CptDepreMethod1Edit.jsp?id=<%=rs.getString(1)%>"><%=name%></a></TD>
	<TD><%=SystemEnv.getHtmlLabelName(835,user.getLanguage())%></TD>
  <% }
	  else{
  %>
	<TD><a href="CptDepreMethod2Add.jsp?id=<%=rs.getString(1)%>"><%=name%></a></TD>
	<TD><%=SystemEnv.getHtmlLabelName(836,user.getLanguage())%></TD>
  <%
	  }
  %>
	<TD><%=description%></TD>
    
  </TR>
<%
      }catch(Exception e){
        //System.out.println(e.toString());
      }
    }
%>  
 </TBODY></TABLE>
 
</BODY></HTML>
