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
String titlename =SystemEnv.getHtmlLabelName(16245,user.getLanguage());
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
  <TR class=header>
    <TH colSpan=<%=4+itemdspnames.size()%>><%=SystemEnv.getHtmlLabelName(15174,user.getLanguage())%></TH>
  </TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></TD>
<%
sql = " select state from T_ResearchTable where inputid="+inputid ;
rs.executeSql(sql);
if(rs.next()) state = rs.getString("state") ;
if(state.equals("0")) {
%>
    <td id=contacter style="display:none"><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></td>
<%
}else{
%>
    <td><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></td>
<%
}
%>
    <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
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
<TR class=Line><TD colSpan=<%=4+itemdspnames.size()%>></TD></TR>
<%  
    int temp=0;
    boolean isLight = false;
    sql = " select inpreptablename from T_SurveyItem where inprepid="+inprepid ;
    rs.executeSql(sql);
    if(rs.next()) inpreptablename = rs.getString("inpreptablename") ;

    sql = "select * from "+inpreptablename+ " where inputid="+inputid ;
    rs.executeSql(sql);
    while(rs.next()){
        isLight = !isLight ; 
%>
    <TR class='<%=( isLight ? "datalight" : "datadark" )%>'>
    <td> <a href="/CRM/investigate/FormContent.jsp?inputid=<%=inputid%>&inprepid=<%=inprepid%>&crmid=<%=rs.getString("crmid")%>&contacterid=<%=rs.getString("contacterid")%>">
    <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(rs.getString("crmid")),user.getLanguage())%></a></td>
<%
    sql = " select state from T_ResearchTable where inputid="+inputid ;
    rs3.executeSql(sql);
    if(rs3.next()) state = rs3.getString("state") ;
    if(state.equals("0")) {
    %>
        <td id=contacter style="display:none"><%=rs.getString("contacterid")%></td>
    <%
    }else{
    %>
        <td><%=Util.toScreen(ContacterComInfo.getContacterName(rs.getString("contacterid")),user.getLanguage())%></td>
    <%
    }
    %>
    <td><%=SystemEnv.getHtmlLabelName(15176,user.getLanguage())%></td>
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
 <br>
 <TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
   
  <TBODY>
  <TR class=header><br>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15177,user.getLanguage())%></TH>
  </TR>
  </TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></TD>
<%
sql = " select state from T_ResearchTable where inputid="+inputid ;
rs.executeSql(sql);
if(rs.next()) state = rs.getString("state") ;
if(state.equals("0")) {
%>
    <td id=contacter style="display:none"><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></td>
<%
}else{
%>
    <td><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></td>
<%
}
%>
    <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
  </TR>
<%  
    
    sql = "select * from T_InceptForm where inputid="+inputid+ " and state = 1 " ;
    rs.executeSql(sql);
    while(rs.next()){
        crmid = Util.null2String(rs.getString("crmid"));
        contacterid = Util.null2String(rs.getString("contacterid"));
        state = Util.null2String(rs.getString("state"));
        isLight = !isLight ;   
        
%> 
   <TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
    <TD><%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%></TD>
<%
sql = " select state from T_ResearchTable where inputid="+inputid ;
rs3.executeSql(sql);
if(rs3.next()) state = rs3.getString("state") ;
if(state.equals("0")) {
%>
    <td id=contacter style="display:none"><%=contacterid%></td>
<%
}else{
%>
    <td><%=Util.toScreen(ContacterComInfo.getContacterName(rs.getString("contacterid")),user.getLanguage())%></td>
<%
}
%>

    <TD><%=SystemEnv.getHtmlLabelName(15178,user.getLanguage())%></TD> 
    </TR>
<TR class=Line><TD colSpan=3></TD></TR>
<%      
   }  
%>  
  </TBODY>
</TABLE>
<br>
<TABLE class=ListStyle cellspacing=1>
  <COLGROUP>
  
  <TBODY>
  <TR class=header>
    <TH colSpan=4><%=SystemEnv.getHtmlLabelName(15179,user.getLanguage())%></TH>
  </TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(1268,user.getLanguage())%></TD>
<%
sql = " select state from T_ResearchTable where inputid="+inputid ;
rs.executeSql(sql);
if(rs.next()) state = rs.getString("state") ;
if(state.equals("0")) {
%>
    <td id=contacter style="display:none"><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></td>
<%
}else{
%>
    <td><%=SystemEnv.getHtmlLabelName(572,user.getLanguage())%></td>
<%
}
%>

    <TD><%=SystemEnv.getHtmlLabelName(602,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15180,user.getLanguage())%></TD>
  </TR>
<TR class=Line><TD colSpan=4></TD></TR>
  <%  
    sql = "select * from T_FadeBespeak where inputid="+inputid+" and inprepid="+inprepid ;
    rs.executeSql(sql);
    while(rs.next()){
        crmid = Util.null2String(rs.getString("crmid"));
        contacterid = Util.null2String(rs.getString("contacterid"));
        date = Util.null2String(rs.getString("referdate"));
        isLight = !isLight ;   
%> 
<TR class='<%=( isLight ? "datalight" : "datadark" )%>'> 
    <TD>
    <%=Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(crmid),user.getLanguage())%>
    </TD>
<%
sql = " select state from T_ResearchTable where inputid="+inputid ;
rs3.executeSql(sql);
if(rs3.next()) state = rs3.getString("state") ;
if(state.equals("0")) {
%>
    <td id=contacter style="display:none"><%=contacterid%></td>
<%
}else{
%>
    <td><%=Util.toScreen(ContacterComInfo.getContacterName(rs.getString("contacterid")),user.getLanguage())%></td>
<%
}
%>
    <TD><%=SystemEnv.getHtmlLabelName(15167,user.getLanguage())%></TD> 
    <TD><%=date%></TD>
    </TR>
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
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY></HTML>
