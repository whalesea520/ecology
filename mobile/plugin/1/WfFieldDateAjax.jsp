<%
//forward to WfFieldAttrAjax.jsp
request.setAttribute("isformmobile", "1");
request.getRequestDispatcher("/workflow/request/WfFieldDateAjax.jsp").forward(request, response);
return;
%>