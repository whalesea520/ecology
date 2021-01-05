<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<%
String tablename = Util.null2String(request.getParameter("tablename"));

if(tablename.equals("c1"))
	response.sendRedirect("/base/ffield/ListCustomerFreeField.jsp");
else if(tablename.equals("c2"))
	response.sendRedirect("/base/ffield/ListContacterFreeField.jsp");
else if(tablename.equals("c3"))
	response.sendRedirect("/base/ffield/ListAddressFreeField.jsp");
else if(tablename.equals("p1"))
	response.sendRedirect("/base/ffield/ListProjectFreeField.jsp");
else if(tablename.equals("b1"))
	response.sendRedirect("/base/ffield/ListBill1FreeField.jsp");
else if(tablename.equals("b2"))
	response.sendRedirect("/base/ffield/ListBill2FreeField.jsp");
else if(tablename.equals("b3"))
	response.sendRedirect("/base/ffield/ListBill3FreeField.jsp");
else if(tablename.equals("b4"))
	response.sendRedirect("/base/ffield/ListBill4FreeField.jsp");
else if(tablename.equals("hr"))
	response.sendRedirect("/base/ffield/ListHrmResourceFreeField.jsp");
else if(tablename.equals("cp"))
	response.sendRedirect("/base/ffield/ListCptFreeField.jsp");
%>