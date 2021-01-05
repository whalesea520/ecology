
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.general.Util" %><%@ page import="java.util.ArrayList" %><jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%
    int departmentid = Util.getIntValue(request.getParameter("departmentid"));
    int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
    int userid = Util.getIntValue(request.getParameter("userid"));
%>
<table style="width:100%;" border="0" >
  <%
  String sql="";
  int i = Util.getIntValue(request.getParameter("xuhao"),0);
  sql="select id, workcode, lastname from Hrmresource where status in (0,1,2,3) and departmentid="+departmentid+" order by dsporder,lastname";
  RecordSet.executeSql(sql);
  while(RecordSet.next()){
      int cuserid=RecordSet.getInt("id");
      String workcode=RecordSet.getString("workcode");
      String lastname=RecordSet.getString("lastname");
      //ArrayList templist=CompensationTargetMaint.getTarget(comtargetid,targetlist);
	  if(i%2==0){
	  %>
	  <TR style="BACKGROUND-COLOR: #F7F7F7;word-wrap:break-word; word-break:break-all;">
	  <%}else{%>
	  <TR style="BACKGROUND-COLOR: #FFFFFF;word-wrap:break-word; word-break:break-all;">
	  <%}%>
	      <TD width="15%"><%=Util.toScreen(lastname, 7)%></TD>
	      <TD width="15%"><%=workcode%></TD>
	      <TD width="70%" ><input class=inputstyle type = 'text' name = 'resource_<%=cuserid%>' value = '' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'></TD>
  		</TR>
  <%
  		i++;
  }
  %>
</table>