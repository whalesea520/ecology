
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetR" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetC" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
String CustomerID = Util.fromScreen(request.getParameter("CustomerID"),user.getLanguage());
String daytype = ""+Util.getIntValue(request.getParameter("daytype"),1);
String before = ""+Util.getIntValue(request.getParameter("before"),0);
String isremind = Util.fromScreen(request.getParameter("isremind"),user.getLanguage());
boolean isfromtab =  Util.null2String(request.getParameter("isfromtab")).equals("true")?true:false;
String para = "";
char flag = 2;
	
	if (isremind.equals("")) isremind = "1";
	para = CustomerID;
	para += flag + daytype;
	para += flag + before;	
	para += flag + isremind;
	RecordSetC.execute("select 1 from CRM_ContacterLog_Remind where customerid= "+CustomerID);
	if(RecordSetC.next())
	RecordSetR.executeProc("CRM_ContacterLog_R_Update",para);
	else
	RecordSetC.execute("insert into CRM_ContacterLog_Remind (customerid,daytype,before,isremind) values ("+CustomerID+","+daytype+","+before+","+isremind+")");
	//out.print(isremind);
	/*
	if(!isfromtab){
		response.sendRedirect("/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID);
	}else{
		response.sendRedirect("/CRM/data/AddContacterLogRemind.jsp?CustomerID="+CustomerID+"&isfromtab="+isfromtab);
	}
	*/
	out.print("<script>parent.getParentWindow(window).ContacterRemindCallback("+CustomerID+");</script>");
%>