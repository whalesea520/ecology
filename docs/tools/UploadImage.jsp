<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="PicUploadManager" class="weaver.docs.tools.PicUploadManager" scope="page" />
<jsp:useBean id="PicUploadComInfo" class="weaver.docs.tools.PicUploadComInfo" scope="page" />
<%
  	PicUploadManager.setClientAddress(request.getRemoteAddr());
	PicUploadManager.setUserid(user.getUID());
  	String imagetype = PicUploadManager.foruploadfile(request);
  	String isDialog = PicUploadManager.getIsDialog();
    String errorcode = PicUploadManager.getErrorcode();
    if(isDialog.equals("2")){//ajax请求
    	response.getWriter().println("1");
    	return;
    }
    if(!errorcode.equals("")){
        response.sendRedirect("DocPicUploadEdit.jsp?id="+PicUploadManager.getReturnId()+"&errorcode="+errorcode);
        return;
    }else if("edit".equals(PicUploadManager.getOperation())){
    	PicUploadComInfo.removePicUploadCache();
    	if(isDialog.equals("1")){
	  		response.sendRedirect("DocPicUploadEdit.jsp?isclose=1&id="+PicUploadManager.getReturnId()+"&imagetype="+imagetype);
	  	}else{
	 		response.sendRedirect("DocPicUpload.jsp?imagetype="+imagetype);
	 	}
    }else{
	    PicUploadComInfo.removePicUploadCache();  	
	  	if(isDialog.equals("1")){
	  		response.sendRedirect("DocPicUploadAdd.jsp?isclose=1&imagetype="+imagetype);
	  	}else{
	 		response.sendRedirect("DocPicUpload.jsp?imagetype="+imagetype);
	 	}
	 }
%>
 <input type="button" name="Submit2" value="<%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%>" onClick="javascript:history.go(-1)">