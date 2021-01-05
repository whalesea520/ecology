<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="java.net.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocRecComInfo" class="weaver.docs.news.DocRecComInfo" scope="page"/>


<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String type = "0"; 

String imagefilename = "/images/hdDOC_wev8.gif";
String titlename ="";
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%
char flag = Util.getSeparator();
int userid=user.getUID();
String userseclevel=user.getSeclevel();
String newscount=Util.null2String(request.getParameter("newscount"));
DocRecComInfo.resetSearchInfo();
DocRecComInfo.setType(type);
type=DocRecComInfo.getType();   RecordSet.executeProc("DocFrontpage_ALLCount",user.getLogintype()+flag+"-"+user.getType()+flag+userid+flag+userseclevel);
if(RecordSet.next())  newscount=RecordSet.getString("countnew");

String linkstr = "HomePageNews.jsp?type="+type+"&newscount="+newscount ;
int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;
int perpage = 10;
int recordersize=0;
int noreplysize =0 ;

if(!newscount.equals("")){
recordersize=Util.getIntValue(newscount);
noreplysize =Util.getIntValue(newscount);
}

%>

<TABLE class=ListStyle cellspacing=1>
  <TBODY>
 <tr class=Header> 
      <th colspan = 2><%=SystemEnv.getHtmlLabelName(15088,user.getLanguage())%></th>
 </tr>
  <% 
  boolean tdclasslight = false ;	RecordSet.executeProc("DocFrontpage_SelectAllId",""+pagenum+flag+perpage+flag+newscount+flag+user.getLogintype()+flag+"-"+user.getType()+flag+userid+flag+userseclevel);
  RecordSet.afterLast() ;
  while(RecordSet.previous())  {
     if(tdclasslight){	
	    tdclasslight = false ;
  %> 
  <TR class=datadark>
  <%} else{
	    tdclasslight = true ;
  %> 
  <TR class=datalight>
  <%}%>
  <td width=20%><%=RecordSet.getString(3)%></td>
  <td width=25%><A 
  href="/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("id")%>" target = "mainFrame"><B><%=RecordSet.getString(2)%></B></A>&nbsp; </td> 
  </tr>
  <%}%>
  </tbody>
</table>
<TABLE width="100%" border=0 class="ListStyle">
  <TBODY> 
  <TR> 
    <TD noWrap><%=Util.makeNavbar2(pagenum, recordersize , perpage, linkstr)%></TD>
  </TR>
  </TBODY> 
</TABLE>
<br>
</BODY></HTML>