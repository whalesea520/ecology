
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdDOC_wev8.gif";
String titlename = Util.toScreen(SystemEnv.getHtmlLabelName(17599,user.getLanguage()) ,user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";

String userid = user.getUID()+"";
boolean canview = false ;
boolean canedit = false ;

canview=HrmUserVarify.checkUserRight("Voting:Maint", user);
canedit=HrmUserVarify.checkUserRight("Voting:Maint", user);
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<DIV class=HdrProps></DIV>

<TABLE class=ListShort>
  <COLGROUP>
  <COL width="40%">
  <COL width="10%">
  <COL width="20%">
  <COL width="20%">
  <COL width="10%">
  <TBODY>
  <TR class=Header>
  <th><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(81517,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(83971,user.getLanguage())%></th>
  <th><%=SystemEnv.getHtmlLabelName(1929,user.getLanguage())%></th>
  </tr>
  <%
boolean islight=true ;
String sql="";
sql="select t1.* from voting t1,VotingShareDetail t2 where t1.id=t2.votingid and t2.resourceid="+userid+" and t1.status!=0 order by t1.status,t1.begindate desc";
RecordSet.executeSql(sql);
     
while(RecordSet.next()){
	String votingid=RecordSet.getString("id");
	String subject = RecordSet.getString("subject");
    String begindate=RecordSet.getString("begindate");
    String begintime=RecordSet.getString("begintime");
    String createrid=RecordSet.getString("createrid");
    String votingcount=RecordSet.getString("votingcount");
    String status = RecordSet.getString("status");
%> 
  <TR <%if(islight){%> class=datalight <%} else {%>class=datadark <%}%>>
  <td><A href="VotingPoll.jsp?votingid=<%=votingid%>"><%=subject%></A></td>
  <td><%=ResourceComInfo.getResourcename(createrid)%></td>
  <td><%=begindate%></td>
  <td><%=votingcount%></td>
  <td>
  <%if(status.equals("1")){%><%=SystemEnv.getHtmlLabelName(18600,user.getLanguage())%><%}%>
  <%if(status.equals("2")){%><%=SystemEnv.getHtmlLabelName(405,user.getLanguage())%><%}%>
  </td>
  </tr>
<%
    islight=!islight ;
}
%>
</table>

</BODY></HTML>