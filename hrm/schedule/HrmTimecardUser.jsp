<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<HTML>
<%
if(!HrmUserVarify.checkUserRight("HrmTimecardUser:Maintenance" , user)) {
    response.sendRedirect("/notice/noright.jsp") ; 
    return ; 
} 


ArrayList resourceids = new ArrayList() ;
ArrayList usercodes = new ArrayList() ;

String sql = " select * from HrmTimecardUser " ;
rs.executeSql(sql);
while ( rs.next() ) {
    String resourceid = Util.null2String(rs.getString("resourceid"));  
    String usercode = Util.null2String(rs.getString("usercode")); 
    
    resourceids.add( resourceid ) ;
    usercodes.add( usercode ) ;
}

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16724 , user.getLanguage()) ;
String needfav ="1";
String needhelp ="";
%>
<HEAD>
  <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
</HEAD>

<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>    
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:window.history.go(-1),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
<td height="0" colspan="3"></td>
</tr>
<tr>
<td ></td>
<td valign="top">
<TABLE class=Shadow>
<tr>
<td valign="top"><FORM name=frmmain action="OtherSystemUserOperation.jsp" method=post>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="30%">
  <COL width="20%">
  <COL width="20%">
  <COL width="20%">
  <COL width="10%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=5><%=SystemEnv.getHtmlLabelName(16724 , user.getLanguage())%></TH></TR>
    <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(16725 , user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(16702 , user.getLanguage())%></TD>
    <td>&nbsp;</td>
  </TR>

<% 
sql = "select id, lastname , departmentid from Hrmresource order by departmentid "; 
rs.executeSql(sql); 
boolean isLight = false ; 

while(rs.next()){ 
    String	id = Util.null2String( rs.getString("id") ); 
    String  lastname = Util.toScreen( rs.getString("lastname") , user.getLanguage()); 
    String  departmentid = Util.null2String( rs.getString("departmentid") ); 
    String  usercode = "" ;
    int resourceidindex = resourceids.indexOf(id) ;
    if( resourceidindex != -1 ) usercode = (String) usercodes.get( resourceidindex ) ;
    
    isLight = !isLight ;
%> 
    <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
       <TD><a target="_blank" href="/hrm/resource/HrmResource.jsp?id=<%=id%>"><%=lastname%></a></TD> 
       <TD><%=DepartmentComInfo.getDepartmentname(departmentid)%></TD> 
       <TD><%=id%></TD> 
       <td><%=usercode%></td> 
       <TD><a href="HrmTimecardUserEdit.jsp?id=<%=id%>"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></a>
       </TD>   
      </TR>
    <% 
} 
%>
</TBODY></TABLE>
</form>
</td>
</tr>
</TABLE>
</td>
<td></td>
</tr>
<tr>
<td height="0" colspan="3"></td>
</tr>
</table>
</BODY>
</HTML>