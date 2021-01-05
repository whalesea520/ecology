
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="MainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<%
String maincategory=Util.null2String(request.getParameter("maincategory"));
if(maincategory.equals("0")) maincategory="";
String subcategory=Util.null2String(request.getParameter("subcategory"));
if(subcategory.equals("0")) subcategory="";
String seccategory=Util.null2String(request.getParameter("seccategory"));
if(seccategory.equals("0")) seccategory="";

int reftree = Util.getIntValue(request.getParameter("reftree"),0);

if("".equals(maincategory)&&"".equals(subcategory)&&"".equals(seccategory)){
	MainCategoryComInfo.setTofirstRow();
	if(MainCategoryComInfo.next()){
		maincategory = MainCategoryComInfo.getMainCategoryid();
	}
}

if(!"".equals(maincategory)){
	response.sendRedirect("DocMainCategoryEdit.jsp?id="+maincategory+(reftree>0?"&reftree="+reftree:""));
} else if(!"".equals(subcategory)) {
	response.sendRedirect("DocSubCategoryEdit.jsp?id="+subcategory+(reftree>0?"&reftree="+reftree:""));
} else if(!"".equals(seccategory)) {
	response.sendRedirect("DocSecCategoryEdit.jsp?id="+seccategory+(reftree>0?"&reftree="+reftree:""));
} else {
	response.sendRedirect("DocMainCategoryAdd.jsp");
}
return;
%>