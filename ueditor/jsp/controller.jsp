
<%@ page language="java" contentType="text/html; charset=UTF-8"
	import="com.baidu.ueditor.ActionEnter"
    pageEncoding="UTF-8"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.file.FileUpload"%>
<%@page import="com.baidu.ueditor.define.BaseState"%>
<%

    request.setCharacterEncoding( "UTF-8" );
	response.setHeader("Content-Type" , "text/html");
	
	String rootPath = application.getRealPath( "/" );
	String result="";
	String action=Util.null2String(request.getParameter("action"));
	//拖动上传图片、剪切上传图片
	if(action.equals("uploadimage")){
		FileUpload fu = new FileUpload(request,"utf-8");
		
			int imagefileid = Util.getIntValue(fu.uploadFiles("Filedata"));
			if(imagefileid==-1)
				imagefileid = Util.getIntValue(fu.uploadFiles("upfile"));
			BaseState state=new BaseState();
			
			if(imagefileid==-1){
				state.setState(false);
				state.setInfo("上传文件失败！");
			}else
				state.setState(true);
			
			state.putInfo("url", "/weaver/weaver.file.FileDownload?fileid="+imagefileid);
			result=state.toJSONString();
	}else{
		result=new ActionEnter( request, rootPath ).exec();
	}
	out.write( result );
%>