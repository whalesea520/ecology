
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="SearchComInfo" class="weaver.album.SearchComInfo" scope="session" />
<%
String sName = Util.null2String(request.getParameter("sName"));
String sUserId = Util.null2String(request.getParameter("sUserId"));
String sDate1 = Util.null2String(request.getParameter("sDate1"));
String sDate2 = Util.null2String(request.getParameter("sDate2"));
String sSubcompanyId = Util.null2String(request.getParameter("sSubcompanyId"));

SearchComInfo.setPhotoName(sName);
SearchComInfo.setUserId(sUserId);
SearchComInfo.setPostDate1(sDate1);
SearchComInfo.setPostDate2(sDate2);
SearchComInfo.setSubcompanyId(sSubcompanyId);

response.sendRedirect("PhotoSearchResult.jsp");
%>