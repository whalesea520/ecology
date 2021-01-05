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

String imagefilename = "/images/hdDOC_wev8.gif";
String type=Util.null2String(request.getParameter("type"));

String titlename ="";

if (type.equals("0"))
titlename =SystemEnv.getHtmlLabelName(316,user.getLanguage());
if (type.equals("1"))
titlename =SystemEnv.getHtmlLabelName(2080,user.getLanguage());
if (type.equals("2"))
titlename =SystemEnv.getHtmlLabelName(6007,user.getLanguage());

String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location.href='/system/HomePage.jsp',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


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
</DIV>
<br>
<%
char flag = Util.getSeparator();
int userid=user.getUID();
String userseclevel=user.getSeclevel();
String newscount=Util.null2String(request.getParameter("newscount"));
DocRecComInfo.resetSearchInfo();
DocRecComInfo.setType(type);

    type=DocRecComInfo.getType();
    
    if (type.equals("0")){
        RecordSet.executeProc("DocFrontpage_ALLCount",user.getLogintype()+flag+"-"+user.getType()+flag+userid+flag+userseclevel);
        if(RecordSet.next())
        newscount=RecordSet.getString("countnew");
        
        }
    if (type.equals("1")){
         RecordSet.executeProc("NewDocFrontpage_SRecentCount",user.getLogintype()+flag+"-"+user.getType()+flag+userid+flag+userseclevel);
        if(RecordSet.next())
        newscount=RecordSet.getString("countnew");
        }
    if (type.equals("2")){
        RecordSet.executeProc("NewDocFrontpage_SMRecentCount",user.getLogintype()+flag+"-"+user.getType()+flag+userid+flag+user.getSeclevel());
        if(RecordSet.next())
        newscount=RecordSet.getString("countnew");
        
        }



String linkstr = "NewsRecDsp.jsp?type="+type+"&newscount="+newscount ;
int pagenum = Util.getIntValue(request.getParameter("pagenum") , 1) ;
int perpage = 10;
int recordersize=0;
int noreplysize =0 ;

if(!newscount.equals("")){
recordersize=Util.getIntValue(newscount);
noreplysize =Util.getIntValue(newscount);
}

%>

<TABLE class=ListStyle cellspacing="1">
  <TBODY>
  <TR class=Header>
  <th width=25%><%=SystemEnv.getHtmlLabelName(16242,user.getLanguage())%></th>
  <th width=20%><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></th>
  <th width=20%><%=SystemEnv.getHtmlLabelName(1339,user.getLanguage())%></th>
  </tr>
  <TR class=Line><TD colSpan=2></TD></TR>
  <% 
     boolean tdclasslight = false ;
if(type.equals("0"))
RecordSet.executeProc("DocFrontpage_SelectAllId",""+pagenum+flag+perpage+flag+newscount+flag+user.getLogintype()+flag+"-"+user.getType()+flag+userid+flag+userseclevel);
if(type.equals("1"))
RecordSet.executeProc("NewDocFrontpage_SelectAllNId",""+pagenum+flag+perpage+flag+newscount+flag+user.getLogintype()+flag+"-"+user.getType()+flag+userid+flag+userseclevel);
if(type.equals("2"))
RecordSet.executeProc("NewDocFrontpage_SelectMAllNId",""+pagenum+flag+perpage+flag+newscount+flag+user.getLogintype()+flag+"-"+user.getType()+flag+userid+flag+userseclevel);
    
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
  <td width=25%><A 
  href="/docs/docs/DocDsp.jsp?id=<%=RecordSet.getString("id")%>"><B><%=RecordSet.getString(2)%></B></A>&nbsp; </td>
  <td width=20%><%=RecordSet.getString(3)%></td>
  <td width=20%><%=RecordSet.getString(4)%></td>
  </tr>
  <%}%>
  </tbody>
</table>

      
<TABLE width="100%" border=0>
  <TBODY> 
  <TR> 
    <TD noWrap><%=Util.makeNavbar2(pagenum, recordersize , perpage, linkstr)%></TD>
  </TR>
  </TBODY> 
</TABLE>

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
<br>
</BODY></HTML>