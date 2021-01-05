<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=GBK" %> <%@ include file="/systeminfo/init.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
char separator = Util.getSeparator() ;
String para = "" ;
String sql = "select id, customerid from CRM_CustomerContacter order by customerid " ;
RecordSet.executeSql(sql);      		      		
while(RecordSet.next()){  
    String id = Util.null2String(RecordSet.getString("id")) ;
    String customerid = Util.null2String(RecordSet.getString("customerid")) ;
    String loginid = Util.null2String(request.getParameter("loginid_"+id)) ;
    String password = Util.null2String(request.getParameter("password_"+id)) ;
    String status = Util.null2String(request.getParameter("status_"+id));

    //para = customerid + separator + id + separator + loginid + separator + password + separator + status ;
    
    String sqlstr = "update T_Datacenteruser set loginid='"+loginid+"',password='"+password+"',status='"+status+"' where crmid="+customerid+" and contacterid="+id;
    
    rsexecuteSql(sqlstr);  
}

response.sendRedirect("UserManager.jsp");

%>
