
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CrmShareBase" class="weaver.crm.CrmShareBase" scope="page" />
<%
User user = HrmUserVarify.getUser(request,response);
if(user == null)  return ;
String q = request.getParameter("q");
if(q.equals("")) return;
String userId = request.getParameter("userId");
RecordSet.executeSql("select * from MailUserAddress where userId="+userId+" and mailUserName like '%"+q+"%'");
while(RecordSet.next()){//联系人

	String id = RecordSet.getString("id");
	String mailUserName = Util.null2String(RecordSet.getString("mailUserName"));
	String mailaddress = Util.null2String(RecordSet.getString("mailaddress"));
	if(!mailaddress.equals("")) mailaddress = "<"+mailaddress+">";
	out.println(mailUserName+mailaddress+"/联系人(联系人)"+"|"+id);
}

RecordSet.executeSql("select * from HrmResource where lastname like '%"+q+"%'");
while(RecordSet.next()){//人力资源
	String id = RecordSet.getString("id");
	String lastname = Util.null2String(RecordSet.getString("lastname"));
	String departmentid = Util.null2String(RecordSet.getString("departmentid"));
	String departmentname = Util.null2String(DepartmentComInfo.getDepartmentname(departmentid));
	String email = Util.null2String(RecordSet.getString("email"));
	if(!email.equals("")) email = "<"+email+">";
	out.println(lastname+email+"/"+departmentname+"(人力资源)"+"|"+id);
}

String leftjointable = CrmShareBase.getTempTable(""+user.getUID());
RecordSet.executeSql("select distinct t3.id,t3.fullname,t3.email from CRM_CustomerInfo  t1,"+leftjointable+" t2, CRM_CustomerContacter t3 where t1.id != 0  and t1.id=t3.customerid and t1.deleted<>1 and t1.id = t2.relateditemid and t3.fullname like '%"+q+"%'");
while(RecordSet.next()){//客户联系人

	String id = RecordSet.getString("id");
	String fullname = Util.null2String(RecordSet.getString("fullname"));
	String email = Util.null2String(RecordSet.getString("email"));
	if(!email.equals("")) email = "<"+email+">";
	out.println(fullname+email+"/客户(客户联系人)"+"|"+id);
}

%>