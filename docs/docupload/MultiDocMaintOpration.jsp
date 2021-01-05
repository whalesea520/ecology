
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page"/>


<% 
  if(!HrmUserVarify.checkUserRight("MultiDocUpload:maint", user))  {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
  }
%>


<%
//权限判断
//如果上传的附件列表中没有文件，则此用户可能没有上传文件或没有权限向此目录传送文件


String imagefileids_MultiDocUp=(String) session.getValue("imagefileids_MultiDocUp");
if(imagefileids_MultiDocUp==null) {
	//你没有访问当前页面的权限
	out.println( SystemEnv.getHtmlLabelName(2012,user.getLanguage()));	
	return;
}

ArrayList imgFileList=Util.TokenizerString(imagefileids_MultiDocUp,"+");

for(int i=0;i<imgFileList.size();i++){
	String imgFileId=(String)imgFileList.get(i);
	//out.println("imgFileId:"+imgFileId+"<br>");	
    //存储相关内容
	DocManager.resetParameter();
  	DocManager.setClientAddress(request.getRemoteAddr());
    DocManager.setUserid(user.getUID());
    DocManager.setLanguageid(user.getLanguage());
    DocManager.setUsertype(""+user.getLogintype());	 

	DocManager.UploadFileToDoc(request,imgFileId);
}


//返回上传页面
response.sendRedirect("/docs/docupload/MultiDocMaint.jsp");
%>