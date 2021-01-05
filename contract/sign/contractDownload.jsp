<%@ page language="java" contentType="application/x-download;charset=UTF-8"%>
<%@ page import="java.io.*"%>
<%@ page import="weaver.contractn.service.SignStandardService"%>
<%@ page import="weaver.contractn.serviceImpl.SignStandardServiceImpl"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%  
    // 合同ID
    String contractId = request.getParameter("contractId");
    String fileName = java.net.URLEncoder.encode("合同文件.pdf", "UTF-8");
    response.setHeader("content-disposition","attachment; filename="+fileName);
    // 根据合同ID查询契约锁合同ID
	rs.executeSql("select documentid from uf_t_cons_info where id='"+contractId+"'");
	String documentId = "";
	if(rs.next()){
	    documentId = rs.getString("documentid");
	}
	SignStandardService signStandardService = new SignStandardServiceImpl();
	OutputStream outputDoc = response.getOutputStream();
	signStandardService.downloadDoc(Long.valueOf(documentId),outputDoc);
	if(outputDoc != null){
	    outputDoc.flush();
	    outputDoc.close();
	}
%>