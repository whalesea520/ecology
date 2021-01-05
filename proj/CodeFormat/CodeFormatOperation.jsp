
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="ProjCodeParaBean" class="weaver.proj.form.ProjCodeParaBean" scope="page"/>

<%
    String txtCodePrefix = Util.null2String(request.getParameter("txtCodePrefix"));
    String chkIsNeedProjTypeCode= Util.null2String(request.getParameter( "chkIsNeedProjTypeCode"));
    String chkYear= Util.null2String(request.getParameter("chkYear"));
    String selYear= Util.null2String(request.getParameter("selYear"));
    String chkMonth= Util.null2String(request.getParameter("chkMonth"));
    String chkDate= Util.null2String(request.getParameter("chkDate"));
    int txtGlideNum= Util.getIntValue(request.getParameter("txtGlideNum"),0);
    String txtUseCode = Util.null2String(request.getParameter("txtUseCode")); 
    
    ProjCodeParaBean.clear();
    ProjCodeParaBean.setCodePrefix(txtCodePrefix);
    ProjCodeParaBean.setNeedProjTypeCode("1".equals(chkIsNeedProjTypeCode));
    if ("1".equals(chkYear)) ProjCodeParaBean.setStrYear(selYear);
    ProjCodeParaBean.setStrMonth(chkMonth);
    ProjCodeParaBean.setStrDate(chkDate);
    ProjCodeParaBean.setGlideNum(txtGlideNum);
    ProjCodeParaBean.setUseCode("1".equals(txtUseCode));
    ProjCodeParaBean.setCodePara();
    
    response.sendRedirect("CodeFormatView.jsp");
%>