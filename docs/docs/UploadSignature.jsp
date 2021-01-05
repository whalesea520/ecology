
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<jsp:useBean id="SignatureManager" class="weaver.docs.docs.SignatureManager" scope="page" />
<%
		SignatureManager.resetParameter();
  	if(request.getParameter("opera")!=null&&request.getParameter("opera").equals("delete")){
  		String[] ids = Util.null2String(request.getParameter("id")).split(",");
  		for(int i=0;i<ids.length;i++){
	  		SignatureManager.resetParameter();
	  		SignatureManager.setMarkId(Util.getIntValue(ids[i], 0));
	  		SignatureManager.deleteSignatureInfo();
	  	}
	  	out.println("1");
  	}else{
			String opera = SignatureManager.UploadSignature(request);
	  	String isDialog = Util.null2String(SignatureManager.getIsDialog());
	  	if(isDialog.equals("1")){	
	  		if(opera.equals("edit"))
	 				response.sendRedirect("SignatureEdit.jsp?isclose=1&id="+request.getParameter("id"));
	  		else
	  			response.sendRedirect("SignatureAdd.jsp?isclose=1");
		 	}else{
		 		response.sendRedirect("SignatureList.jsp");
		 	}
  	}
%>