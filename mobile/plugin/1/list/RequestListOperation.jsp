<%
//forward to WfFieldAttrAjax.jsp
weaver.file.FileUpload fu = new weaver.file.FileUpload(request);
String remark = fu.getParameter("remark");
String multiSubIds = fu.getParameter("multiSubIds");
String isfrommobile = fu.getParameter("isfrommobile");
//QC174906
String belongtoUserids = fu.getParameter("belongtoUserids");
request.setAttribute("remark", remark);
//request.getRequestDispatcher("/workflow/request/RequestListOperation.jsp?isfrommobile=" + isfrommobile + "&multiSubIds=" + multiSubIds).forward(request, response);
//QC174906
request.getRequestDispatcher("/workflow/request/RequestListOperation.jsp?isfrommobile=" + isfrommobile + "&multiSubIds=" + multiSubIds + "&belongtoUserids=" + belongtoUserids).forward(request, response);
return;
%>