<%
	String mainids = request.getParameter("mainids");
	response.sendRedirect("/docs/category/DocMainCategoryMutiBrowser.jsp?mainCategoryIds="+mainids+"&"+request.getQueryString());
%>