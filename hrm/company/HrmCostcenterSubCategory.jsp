<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(6084,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(HrmUserVarify.checkUserRight("HrmCostCenterSubCategoryAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/company/HrmCostcenterSubCategoryAdd.jsp?id="+1+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCostCenterSubCategory:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+19+",_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
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
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>
  <COL width="40%">
  <COL width="60%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=2><%=SystemEnv.getHtmlLabelName(6084,user.getLanguage())%></TH></TR>
   <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan="2" ></TD></TR> 
<%
    String sql = "select * from HrmCostcenterSubCategory where ccmaincategoryid = 1";    
    rs.executeSql(sql);
//    rs.executeProc("HrmCostcenterMainCategory_S","");
    int needchange = 0;
      while(rs.next()){
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
    <TD><a href="/hrm/company/HrmCostcenterSubCategoryEdit.jsp?id=<%=rs.getInt("id")%>">      <%=rs.getString("ccsubcategoryname")%></a></TD>
    <TD><%=rs.getString("ccsubcategorydesc")%></TD>
    
  </TR>
<%
      }catch(Exception e){
        rs.writeLog(e.toString());
      }
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