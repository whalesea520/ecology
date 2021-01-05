<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
</head>
<body>
<%
String id = request.getParameter("id");
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "Hrm:ContractTemplet:Edit";
String needfav ="1";
String needhelp ="";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:dosave(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:dodelete(),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",/hrm/contract/contracttemplet/HrmContractTemplet.jsp,_self} " ;
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
<input class=inputstyle type=hidden name=operation>
<input class=inputstyle type=hidden name=id value="<%=id%>">
<TABLE class=viewForm>
  <COLGROUP>   
    <COL width="15%">
    <COL width="85%">     
  <TBODY>
  <TR class=title>
    <TH colSpan=3><%=SystemEnv.getHtmlLabelName(15786, user.getLanguage())%></TH>
  </TR>
  <TR class=spacing>
    <TD class=line1 colSpan=3 ></TD>
  </TR>
<%
  String sql = " select * from HrmContractTemplet where id = "+id;
  rs.executeSql(sql);
  while(rs.next()){
    String name = Util.null2String(rs.getString("templetname"));
    String docid = Util.null2String(rs.getString("templetdocid"));
    sql = "select mouldtext from DocMould where id = "+docid;    
%>  
  <TR >
    <TD class=Field><%=SystemEnv.getHtmlLabelNames("64,84",user.getLanguage()) %> </TD>
    <td class=Field> <%=id%></td>
  </tr>
    <TR><TD class=Line colSpan=2></TD></TR> 
  <tr>  
    <TD class=Field><%=SystemEnv.getHtmlLabelName(18151, user.getLanguage())%> </TD>    
    <td><input class=inputstyle type=text name=templetname value="<%=name%>"></td>
  </tr> 
<%
    rs2.executeSql(sql);
    while(rs2.next()){
%>   
    <TR><TD class=Line colSpan=2></TD></TR> 
  <tr>
    <TD class=Field><%=SystemEnv.getHtmlLabelNames("30754,58,84",user.getLanguage()) %> </TD>  
    <td>     
      <textarea rows=4 cols=80 name=mouldtext><%=rs2.getString("mouldtext")%></textarea>
      <input class=inputstyle type=hidden name=templetdocid value="<%=docid%>">
    </td>  
  </TR>  
    <TR><TD class=Line colSpan=2></TD></TR> 
<%
    }
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
<script language=javascript>
  function dosave(){
    document.templet.operation.value = "edit";
    document.templet.submit();
  }
  function dodelete(){
    if(confirm("Are you sure to delete?")){
      document.templet.operation.value = "delete";
      document.templet.submit();
    }
  }
</script>
</body>
</html>