<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="OtherInfoTypeComInfo" class="weaver.hrm.tools.OtherInfoTypeComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String resourceid = Util.null2String(request.getParameter("resourceid")) ;
String infotype = Util.null2String(request.getParameter("infotype")) ;
String seclevel = Util.null2String(user.getSeclevel()) ;
char separator = Util.getSeparator() ;
String para = resourceid+separator+infotype+separator+seclevel ;
String departmentid = Util.null2String(ResourceComInfo.getDepartmentID(resourceid)) ;

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(87,user.getLanguage())+" : "+Util.toScreen(OtherInfoTypeComInfo.getTypename(infotype),user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<DIV class=HdrProps></DIV>
<DIV>
<%
if(HrmUserVarify.checkUserRight("HrmResourceOtherInfoAdd:Add", user, departmentid)){
%>
<BUTTON 
class=BtnNew id=AddNew accessKey=N onclick="location='HrmResourceOtherInfoAdd.jsp?resourceid=<%=resourceid%>&infotype=<%=infotype%>'"><U>N</U>-<%=SystemEnv.getHtmlLabelName(365,user.getLanguage())%></BUTTON>
<%}%>
 
</DIV>
<TABLE class=ListShort>
  <TBODY>
  <TR class=Section>
    <TH><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%> <A 
href="HrmResource.jsp?id=<%=resourceid%>"><%=Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage())%></A></TH>
  </TR>
  <TR class=separator>
    <TD class=Sep1 colSpan=2></TD></TR></TBODY></TABLE>
<TABLE class=ListShort>
  <THEAD>
  <COLGROUP>
  <COL width="40%" align=left>
  <COL width="60%"  align=left>
  <TR class=Header>
    <TH><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></TH>
    <TH><%=SystemEnv.getHtmlLabelName(454,user.getLanguage())%></TH></TR></THEAD>
<%
int i= 0;
RecordSet.executeProc("HrmResourceOtherInfo_SByType",para);
while(RecordSet.next()) {
	String id = RecordSet.getString("id") ;
	String infoname = Util.toScreen(RecordSet.getString("infoname"),user.getLanguage()) ;
	String inforemark = Util.toScreen(RecordSet.getString("inforemark"),user.getLanguage()) ;
if(i==0){
		i=1;
%>
<TR class=DataLight>
<%
	}else{
		i=0;
%>
<TR class=DataDark>
<%
}
%>
    <TD><A 
      href="HrmResourceOtherInfoEdit.jsp?id=<%=id%>"><%=infoname%></A></TD>
    <TD><%=inforemark%></TD></TR>
<%}%>
  </TABLE></BODY></HTML>
