
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetR" class="weaver.conn.RecordSet" scope="page" />
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
	RecordSetR.executeProc("CRM_ContacterLog_R_Update",para);
	//out.print(isremind);
	
	//增加联系无效及是否再联系设置
	String invalid = ("on".equals(request.getParameter("invalid")))?"1":"0";
	String isContact = Util.getIntValue(request.getParameter("isContact"),0)+"";
	String contactDate = Util.fromScreen3(request.getParameter("contactDate"),user.getLanguage());
	RecordSet.executeSql("select 1 from CRM_ContactSetting where customerId="+CustomerID);
	if(RecordSet.next()){
		RecordSet.executeSql("update CRM_ContactSetting set invalid="+invalid+",isContact="+isContact+",contactDate='"+contactDate+"' where customerId="+CustomerID);
	}else{
		RecordSet.executeSql("insert into CRM_ContactSetting (customerId,invalid,isContact,contactDate) values("+CustomerID+","+invalid+","+isContact+",'"+contactDate+"')");
	}
	
	
	if(!isfromtab){
		response.sendRedirect("/CRM/data/ViewCustomer.jsp?CustomerID="+CustomerID);
	}else{
		response.sendRedirect("/CRM/data/AddContacterLogRemind.jsp?CustomerID="+CustomerID+"&isfromtab="+isfromtab);
	}
%>