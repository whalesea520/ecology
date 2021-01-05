
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
String customerId =  Util.null2String(request.getParameter("customerId"));  //客户Id
String isValid =  Util.null2String(request.getParameter("isValid"));  //是否有效
String remark = Util.convertInput2DB(request.getParameter("fbremark"));  //相关说明
if(customerId.equals("") || isValid.equals("")){
	out.print(false);	
	return;
}
String sql = "";
RecordSet.executeSql("select customerId,isValid,remark from CRM_CustomerFeedback where customerId = "+customerId);
if(RecordSet.next()){
	sql = "update CRM_CustomerFeedback set isValid="+isValid+",remark='"+remark+"' where customerId="+customerId;
}else{
	sql = "insert into CRM_CustomerFeedback (customerId,isValid,remark) values("+customerId+","+isValid+",'"+remark+"')";
}
boolean b = RecordSet.executeSql(sql);
out.print(b);	
return;
%>