
<%@ page language="java" contentType="text/html; charset=UTF-8" %><%@ page import="weaver.hrm.*" %><%@ page import="weaver.general.Util" %><%@ page import="java.util.ArrayList" %><jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" /><jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<%
	User user = HrmUserVarify.getUser (request , response) ;
	if(user == null)  return ;
    int departmentid = Util.getIntValue(request.getParameter("departmentid"));
    int subcompanyid=Util.getIntValue(request.getParameter("subCompanyId"));
    int userid = Util.getIntValue(request.getParameter("userid"));
%>
<table style="width:100%;" border="0" >
  <%
  int itemid = Util.getIntValue(request.getParameter("itemid"),0);
  String sql="";
  int i = Util.getIntValue(request.getParameter("xuhao"),0);
  sql="select id, workcode,lastname from Hrmresource where status in (0,1,2,3) and departmentid ="+departmentid+" order by dsporder,lastname";
  RecordSet.executeSql(sql);
  while(RecordSet.next()){
      int cuserid=RecordSet.getInt("id");
      String workcode=RecordSet.getString("workcode");
      String lastname=RecordSet.getString("lastname");
      String resourcepay = "";
      String isBatch = "";
      sql="select salary from HrmSalaryPersonality where hrmid="+cuserid+" and itemid = "+itemid;
      RecordSet1.executeSql(sql);
      if(RecordSet1.next()){
    	  resourcepay = RecordSet1.getString("salary");
      }
      sql="select resourcepay,isBatch from HrmSalaryResourcePay where resourceid="+cuserid+" and itemid = "+itemid;
      RecordSet1.executeSql(sql);
      if(RecordSet1.next()){
		isBatch = RecordSet1.getString("isBatch");
		if(isBatch.equals("0")){
			resourcepay = RecordSet1.getString("resourcepay");
		}
      }
      //ArrayList templist=CompensationTargetMaint.getTarget(comtargetid,targetlist);
	  if(i%2==0){
	  %>
	  <TR style="word-wrap:break-word; word-break:break-all;">
	  <%}else{%>
	  <TR style="word-wrap:break-word; word-break:break-all;">
	  <%}%>
	      <TD width="15%"><%=Util.toScreen(lastname, 7)%></TD>
	      <TD width="15%"><%=workcode%></TD>
		  <TD width="70%"><input type = 'text' name = 'resource_<%=cuserid%>' value = '<%=resourcepay%>' onKeyPress='ItemNum_KeyPress()' onBlur='checknumber1(this)'>
    <input type = 'hidden' name = 'resource_<%=cuserid%>_oldpay' value = '<%=resourcepay%>'>
  		</TR>
  <%
  		i++;
  }
  %>
</table>