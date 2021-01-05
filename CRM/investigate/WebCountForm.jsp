<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ContacterComInfo" class="weaver.crm.investigate.ContacterComInfo" scope="page" />

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =Util.toScreen("调查表单接收情况",user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";
String sql="" ;
String id = "";
String inprepid = Util.null2String(request.getParameter("inprepid"));
String inputid = Util.null2String(request.getParameter("inputid"));
String date = "" ;
String reportdate = "" ;
String crmid ="" ;
String state = "" ;
String itemdspname = "" ;
String inpreptablename = "" ;
String contacterid = "" ;
String itemfieldname = "" ;
ArrayList itemdspnames = new ArrayList() ;
ArrayList itemfieldnames = new ArrayList() ;
sql = "select itemfieldname ,itemdspname from T_fieldItem where inprepid="+inprepid+" order by itemid ";
rs.executeSql(sql) ;
while(rs.next()){
    itemdspname = rs.getString("itemdspname") ;
    itemfieldname = rs.getString("itemfieldname");
    itemfieldnames.add(itemfieldname);
    itemdspnames.add(itemdspname) ;
}
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(),_self} " ;
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

<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>  
  <TBODY>
  <TR class=Header>
    <TD>ID</TD>
    <TD><%=SystemEnv.getHtmlLabelName(15175,user.getLanguage())%></TD>
    <%
    for(int i=0;i<itemdspnames.size();i++){
        itemdspname = (String)itemdspnames.get(i);
    %>
    <TD><%=itemdspname%></TD>
    <%
    }    
    %>
  </TR>
  <TR class=Line>
    <TD class=Sep1 colSpan=<%=4+itemdspnames.size()%>></TD>
  </TR>
<%  
    int temp=0;
    boolean isLight = false;
    sql = " select inpreptablename from T_SurveyItem where inprepid="+inprepid ;
    rs.executeSql(sql);
    if(rs.next()) inpreptablename = rs.getString("inpreptablename") ;

    sql = "select * from "+inpreptablename+ " where inputid="+inputid +" order by crmid desc";
    rs.executeSql(sql);
    while(rs.next()){
        isLight = !isLight ; 
%>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
	<TD> <%=rs.getString("crmid")%></TD>
    <td> <%=rs.getString("reportdate")%></td>
<%
    for(int i=0;i<itemfieldnames.size();i++){
        itemfieldname = (String)itemfieldnames.get(i);
%>
    <td><%=rs.getString(itemfieldname)%></td>
<%
}
%>
 </tr>
<%
  }
%>

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
  
</BODY>
</HTML>
