
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,weaver.file.*,java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocSeccategoryUtil" class="weaver.docs.docs.DocSeccategoryUtil" scope="page" />
<%
	if (!HrmUserVarify.checkUserRight("DocSecCategoryAdd:add",user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String subcompanyid = Util.null2String(request.getParameter("subcompanyid"));
	if(subcompanyid != null && !subcompanyid.isEmpty()){
		DocSeccategoryUtil.setSubcompanyid(subcompanyid);
	}
	FileUploadToPath fu = new FileUploadToPath(request) ;
	DocSeccategoryUtil.setUserid(user.getUID());
	DocSeccategoryUtil.setAddr(request.getRemoteAddr());
	int id=DocSeccategoryUtil.seccategoryImport(fu);
	if(id>0){
	response.sendRedirect("/docs/category/SecCategoryImportResult.jsp?isdialog=1&historyid="+id);
	}else{
	response.sendRedirect("/docs/category/SecCategoryImport.jsp?flag=-1&subcompanyid="+subcompanyid);	
	}
%>

