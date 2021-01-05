<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CostcenterSubComInfo" class="weaver.hrm.company.CostcenterSubComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename =SystemEnv.getHtmlLabelName(124,user.getLanguage())+SystemEnv.getHtmlLabelName(425,user.getLanguage())+SystemEnv.getHtmlLabelName(426,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%if(HrmUserVarify.checkUserRight("HrmCostCenterAdd:Add", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",/hrm/company/HrmCostCenterAdd.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
}
if(HrmUserVarify.checkUserRight("HrmCostCenter:Log", user)){
RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",/systeminfo/SysMaintenanceLog.jsp?sqlwhere=where operateitem="+20+",_self} " ;
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
  <COL width="20%"> 
  <COL width="20%">
  <COL width="60%">
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(425,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(426,user.getLanguage())%></TH></TR>
   <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelName(15769,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(399,user.getLanguage())%></TD>
    <TD><%=SystemEnv.getHtmlLabelName(15767,user.getLanguage())%></TD>
  </TR>
  <TR class=Line><TD colspan="3" ></TD></TR> 
<%  
    int line = 0;
    int temp=0;
    String sql = "select * from HrmCostcenter order by ccsubcategory1";
    rs.executeSql(sql);    
    while(rs.next()){
      if(line%2==0){ line++;     
%> 
   <TR class=datalight> 
<%
       }else{line++;
%>   
    <TR class=datadark>
<%
       }
%>
     <td class=Field> 
<%
  int subcc = rs.getInt("ccsubcategory1");
  if(temp != subcc){
    temp = subcc;
  sql = "select * from HrmCostCenterSubCategory where id = "+subcc;
  rs2.executeSql(sql);
  while(rs2.next()){
    
%>     
      <a href="/hrm/company/HrmCostCenterSubCategoryEdit.jsp?id=<%=rs2.getString("id")%>"><%=rs2.getString("ccsubcategoryname")%></a>
<%
  }
  }
%>     
    </td>
      
    <TD class=Field><a href="/hrm/company/HrmCostcenterDsp.jsp?id=<%=rs.getInt("id")%>"><%=rs.getString("costcentermark")%></a></TD>
    <TD class=Field><%=rs.getString("costcentername")%></TD>    
  </TR>
<%  }%>  
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