<%@ page import="weaver.general.Util,weaver.conn.*,java.math.*" %>
<%@ page import="" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="ContacterComInfo" class="weaver.crm.investigate.ContacterComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String inprepid = ""+Util.getIntValue(request.getParameter("inprepid"),0);
String crmid = ""+Util.getIntValue(request.getParameter("crmid"),0);
String contacterid = ""+Util.getIntValue(request.getParameter("contacterid"),0);
String inputid = ""+Util.getIntValue(request.getParameter("inputid"),0);
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15181,user.getLanguage());
String needfav ="1";
String needhelp ="";
String sql="" ;
String itemdspname = "" ;
String inprepname = "" ;
String inpreptablename = "" ;
String itemfieldname = "" ;
String itemfield = "" ;
String state = "" ;
ArrayList itemdspnames = new ArrayList() ;
ArrayList itemfieldnames = new ArrayList() ;
sql = "select itemdspname,itemfieldname from T_fieldItem where inprepid="+inprepid+" order by itemid "; ;
rs.executeSql(sql);
while(rs.next()) {
    itemdspname = Util.null2String(rs.getString("itemdspname"));
    itemfieldname = Util.null2String(rs.getString("itemfieldname"));
    itemdspnames.add(itemdspname) ;
    itemfieldnames.add(itemfieldname) ;
}
sql = "select inpreptablename from T_SurveyItem where inprepid="+inprepid ;
rs.executeSql(sql) ;
if(rs.next()) inpreptablename = Util.null2String(rs.getString("inpreptablename"));
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

<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  <TBODY>
  <TR class=header><br>
  <%
  sql = " select state from T_ResearchTable where inputid="+inputid ;
  rs.executeSql(sql);
  if(rs.next()) state = rs.getString("state") ;
  if(state.equals("0")){
  %>
    <TH colSpan=2><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(15182,user.getLanguage())%></TH>
  <%
  }else{    
  %>
      <TH colSpan=2><%=Util.toScreen(ContacterComInfo.getContacterName(contacterid),user.getLanguage())%>: <%=SystemEnv.getHtmlLabelName(15182,user.getLanguage())%></TH>
 <%
  }    
 %>
  </TR>
<TR class=Line><TD colSpan=2></TD></TR>
  <TR class=datadark>
    <TD><%=SystemEnv.getHtmlLabelName(15183,user.getLanguage())%></TD>
<%
sql = "select inprepname,inpreptablename from T_SurveyItem where inprepid="+inprepid ;
rs.executeSql(sql) ;
if(rs.next()) {
    inprepname = Util.null2String(rs.getString("inprepname"));
    inpreptablename = Util.null2String(rs.getString("inpreptablename"));
}
 %>    
    <td><%=inprepname%></td></tr>
<%
int temp=0;
boolean isLight = false;
for(int i=0;i<itemdspnames.size();i++){
    itemdspname = (String)itemdspnames.get(i);
    itemfieldname = (String)itemfieldnames.get(i);
    isLight = !isLight ; 

%>
    <tr class='<%=( isLight ? "datalight" : "datadark" )%>'>
    <TD><%=itemdspname%></TD>
<%
    sql = "select "+itemfieldname+ " from "+inpreptablename+ " where inputid="+inputid+" and crmid="+crmid+" and contacterid="+contacterid;
    rs1.executeSql(sql) ;
    while(rs1.next()){
        itemfield = Util.null2String(rs1.getString(itemfieldname));
%>
 <td><%=itemfield%></td>
  <%
    }
}
  %>
</tr>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>
