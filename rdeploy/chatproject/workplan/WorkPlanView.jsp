<%
//request.getRequestDispatcher("/workplan/data/WorkPlan.jsp?isfromrdeploy=1").forward(request, response);
response.sendRedirect("/workplan/data/WorkPlan.jsp?isfromrdeploy=1");
return;
%>