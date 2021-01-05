<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
User user=HrmUserVarify.getUser(request, response);

String opera=Util.null2String(request.getParameter("operation"));

int id=Util.getIntValue(request.getParameter("mouldid"),0);

String mouldname=Util.fromScreen(request.getParameter("mouldname"),user.getLanguage());
int userid=user.getUID();
String prjtype=Util.null2String( request.getParameter("prjtype"));
String worktype=Util.null2String( request.getParameter("worktype"));
String status=Util.null2String( request.getParameter("status"));


	String prjid =Util.fromScreen(request.getParameter("prjid"),user.getLanguage());
	String nameopt =Util.fromScreen(request.getParameter("nameopt"),user.getLanguage());
	String name   =Util.fromScreen(request.getParameter("name"),user.getLanguage());
	String description=Util.fromScreen(request.getParameter("description"),user.getLanguage());
	String customer   =Util.fromScreen(request.getParameter("customer"),user.getLanguage());
	String parent=Util.fromScreen(request.getParameter("parent"),user.getLanguage());
	String securelevel =Util.fromScreen(request.getParameter("securelevel"),user.getLanguage());
	String department =Util.fromScreen(request.getParameter("department"),user.getLanguage());
	String manager =Util.fromScreen(request.getParameter("manager"),user.getLanguage());
	String member       =Util.fromScreen(request.getParameter("member"),user.getLanguage());
    String procode=Util.fromScreen(request.getParameter("procode"),user.getLanguage());
    
    String startdate=Util.fromScreen(request.getParameter("startdate"),user.getLanguage());
    String startdateTo=Util.fromScreen(request.getParameter("startdateTo"),user.getLanguage());
    String enddate=Util.fromScreen(request.getParameter("enddate"),user.getLanguage());
    String enddateTo=Util.fromScreen(request.getParameter("enddateTo"),user.getLanguage());
    String finish=Util.fromScreen(request.getParameter("finish"),user.getLanguage());
    String finish1=Util.fromScreen(request.getParameter("finish1"),user.getLanguage());
    String subcompanyid1=Util.fromScreen(request.getParameter("subcompanyid1"),user.getLanguage());
    
  char separator = Util.getSeparator() ;
  
if(opera.equals("add")){

String para = mouldname + separator+userid + separator + prjid + separator + status + separator+ prjtype + separator+ worktype + separator+ nameopt + separator + name   + separator + description + separator + customer   + separator + parent + separator + securelevel + separator + department + separator + manager + separator + member+separator +procode;
	RecordSet.executeProc("Prj_SearchMould_Insert",para);
	if(RecordSet.next()){
		id = RecordSet.getInt(1);
	}
	RecordSet.executeSql("update Prj_SearchMould set subcompanyid1='"+subcompanyid1+"',finish='"+finish+"',finish1='"+finish1+"',startdatefrom='"+startdate+"',startdateto='"+startdateTo+"',enddatefrom='"+enddate+"',enddateto='"+enddateTo+"' where id="+id);
	//response.sendRedirect("Search.jsp?mouldid="+id);
}
if(opera.equals("update")){
String para = ""+id+separator+userid + separator + prjid + separator + status + separator+ prjtype + separator+ worktype + separator+ nameopt + separator + name   + separator + description + separator + customer   + separator + parent + separator + securelevel + separator + department + separator + manager + separator + member+ separator + procode;
	RecordSet.executeProc("Prj_SearchMould_Update",para);
	
	RecordSet.executeSql("update Prj_SearchMould set subcompanyid1='"+subcompanyid1+"',finish='"+finish+"',finish1='"+finish1+"',startdatefrom='"+startdate+"',startdateto='"+startdateTo+"',enddatefrom='"+enddate+"',enddateto='"+enddateTo+"' where id="+id);
	
//response.sendRedirect("Search.jsp?mouldid="+id);
	
}
if(opera.equals("delete")){
String para = ""+id;
	RecordSet.executeProc("Prj_SearchMould_Delete",para);
	//response.sendRedirect("Search.jsp?mouldid=0");
}

%>