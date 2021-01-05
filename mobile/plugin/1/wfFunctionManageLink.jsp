<%
//forward to wfFunctionManageLink.jsp
request.setAttribute("isformmobile", "1");
request.getRequestDispatcher("/workflow/workflow/wfFunctionManageLink.jsp").forward(request, response);
return;
%>