<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocTypeManager" class="weaver.docs.type.DocTypeManager" scope="page" />
<jsp:useBean id="DocTypeComInfo" class="weaver.docs.type.DocTypeComInfo" scope="page" />
<%
  String operation = Util.null2String(request.getParameter("operation"));
  if(operation.equalsIgnoreCase("add") ||operation.equalsIgnoreCase("edit") ){   	
  	DocTypeManager.resetParameter();	
  	
	DocTypeManager.setId(Util.getIntValue(request.getParameter("id"),0) );
	DocTypeManager.setTypename(Util.fromScreen(request.getParameter("typename"),user.getLanguage()));
	DocTypeManager.setIsactive(Util.fromScreen(request.getParameter("isactive"),user.getLanguage()));
	DocTypeManager.setHasaccessory(Util.fromScreen(request.getParameter("hasaccessory"),user.getLanguage()));
	DocTypeManager.setAccessorynum(Util.getIntValue(request.getParameter("accessorynum"),0));
	DocTypeManager.setHasitems(Util.fromScreen(request.getParameter("hasitems"),user.getLanguage()));
	DocTypeManager.setItemclause(Util.fromScreen(request.getParameter("itemclause"),user.getLanguage()));
	DocTypeManager.setItemlabel(Util.fromScreen(request.getParameter("itemlabel"),user.getLanguage()));
	DocTypeManager.setHasitemmaincategory(Util.fromScreen(request.getParameter("hasitemmaincategory"),user.getLanguage()));
	DocTypeManager.setItemmaincategorylabel(Util.fromScreen(request.getParameter("itemmaincategorylabel"),user.getLanguage()));
	DocTypeManager.setHashrmres(Util.fromScreen(request.getParameter("hashrmres"),user.getLanguage()));
	DocTypeManager.setHrmresclause(Util.fromScreen(request.getParameter("hrmresclause"),user.getLanguage()));
	DocTypeManager.setHrmreslabel(Util.fromScreen(request.getParameter("hrmreslabel"),user.getLanguage()));
	DocTypeManager.setHascrm(Util.fromScreen(request.getParameter("hascrm"),user.getLanguage()));
	DocTypeManager.setCrmclause(Util.fromScreen(request.getParameter("crmclause"),user.getLanguage()));
	DocTypeManager.setCrmlabel(Util.fromScreen(request.getParameter("crmlabel"),user.getLanguage()));
	DocTypeManager.setHasproject(Util.fromScreen(request.getParameter("hasproject"),user.getLanguage()));
	DocTypeManager.setProjectclause(Util.fromScreen(request.getParameter("projectclause"),user.getLanguage()));
	DocTypeManager.setProjectlabel(Util.fromScreen(request.getParameter("projectlabel"),user.getLanguage()));
	DocTypeManager.setHasfinance(Util.fromScreen(request.getParameter("hasfinance"),user.getLanguage()));
	DocTypeManager.setFinanceclause(Util.fromScreen(request.getParameter("financeclause"),user.getLanguage()));
	DocTypeManager.setFinancelabel(Util.fromScreen(request.getParameter("financelabel"),user.getLanguage()));
	DocTypeManager.setHasrefence1(Util.fromScreen(request.getParameter("hasrefence1"),user.getLanguage()));
	DocTypeManager.setHasrefence2(Util.fromScreen(request.getParameter("hasrefence2"),user.getLanguage()));
	
	DocTypeManager.setClientAddress(request.getRemoteAddr());
	DocTypeManager.setUserid(user.getUID());
	DocTypeManager.setAction(operation);
	DocTypeComInfo.removeDocTypeCache();
	response.sendRedirect("DocTypes.jsp");
  }
  else if(operation.equalsIgnoreCase("delete")){ 
  	
  	DocTypeManager.resetParameter();
  	DocTypeManager.setClientAddress(request.getRemoteAddr());
	DocTypeManager.setUserid(user.getUID());
	DocTypeManager.setId(Util.getIntValue(request.getParameter("id"),0) );
	DocTypeManager.setTypename(Util.fromScreen(request.getParameter("typename"),user.getLanguage()));
	String msg = DocTypeManager.DeleteTypeInfo();
	DocTypeComInfo.removeDocTypeCache();
	response.sendRedirect("DocTypes.jsp?msg="+msg);
  }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">