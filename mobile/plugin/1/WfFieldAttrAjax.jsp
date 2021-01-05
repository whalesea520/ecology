<%
//forward to WfFieldAttrAjax.jsp
request.setAttribute("isformmobile", "1");
request.getRequestDispatcher("/workflow/request/WfFieldAttrAjax.jsp").forward(request, response);
return;
%>