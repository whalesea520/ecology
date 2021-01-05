<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<body>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "Hrm:ContractTemplet";
String needfav ="1";
String needhelp ="";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",/hrm/contract/contracttemplet/HrmContractTempletAdd.jsp,_self} " ;
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

<FORM id=templet name=templet action="HrmConTempletOperation.jsp" method=post>
<TABLE class=ListStyle cellspacing=1 >
  <COLGROUP>   
    <COL width="30%">
    <COL width="50%"> 
    <COL width="20%"> 
  <TBODY>
  <TR class=Header>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15786, user.getLanguage())%></TH>
  </TR>
  <TR class=Header>
    <TD><%=SystemEnv.getHtmlLabelNames("64,84",user.getLanguage()) %></TD>
    <TD><%=SystemEnv.getHtmlLabelName(18151, user.getLanguage())%></TD>    
    <TD><%=SystemEnv.getHtmlLabelNames("30754,58,84",user.getLanguage()) %></TD>        
  </TR>  
  <TR class=Line><TD colspan="3" ></TD></TR> 
<%
  int needchange = 0;
  String sql = "";
  sql = "select * from HrmContractTemplet";
  rs.executeSql(sql);
  while(rs.next()){
    String id = Util.null2String(rs.getString("id"));
    String templetname  = Util.null2String(rs.getString("templetname"));
    String templetdocid  = Util.null2String(rs.getString("templetdocid"));
    if(needchange==0){
      needchange =1;
%>  
    <TR class=datalight>
<%
    }else{    
%>
    <TR class=datadark>
<%
}
%>
    <td><%=id%></td>
    <td><a href="HrmContractTempletEdit.jsp?id=<%=id%>"><%=templetname%></a></td>
    <td><%=templetdocid%></td>
<%
  }
%>
  </tbody>      
</table>
</form>
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
</body>
</html>