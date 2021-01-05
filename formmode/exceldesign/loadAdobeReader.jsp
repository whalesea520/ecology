
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="java.io.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String begload=Util.null2String(request.getParameter("begload"));
	if("true".equals(begload)){
		String fontFileName = "AdobeReader.rar";
	    String fontFilePath = "/formmode/exceldesign/";
	    
	    BufferedInputStream bis = null;
	    BufferedOutputStream bos = null;
	    try {
	    	String projectPath = this.getServletConfig().getServletContext().getRealPath("/");
			if (projectPath.lastIndexOf("/") != (projectPath.length() - 1) && projectPath.lastIndexOf("\\") != (projectPath.length() - 1)) {
				projectPath += "/";
			}
	        String filepath = projectPath + fontFilePath + fontFileName;

	        response.reset();
	        response.setHeader("Pragma", "No-cache");
	        response.setHeader("Cache-Control", "no-cache");
	        response.setDateHeader("Expires", 0);
	        response.setContentType("application/octet-stream;charset=UTF-8");
	        response.setHeader("Content-disposition", "attachment;filename=\"" + fontFileName + "\"");
	        
	        bis = new BufferedInputStream(new FileInputStream(filepath));
	        bos = new BufferedOutputStream(response.getOutputStream());
	        
	        byte[] buff = new byte[2048];
	        int bytesRead;
	        while ((bytesRead = bis.read(buff, 0, buff.length)) != -1) {
	            bos.write(buff, 0, bytesRead);
	        }
	        bos.flush();
	        //out.clear();
	        out = pageContext.pushBody();
	    } catch(IOException e) {
	        e.printStackTrace();
	    } finally {
	        if (bis != null) {
	            try {
	                bis.close();
	                bis = null;
	            } catch (IOException e) {
	            }
	        }
	        
	        if (bos != null) {
	            try {
	                bos.close();
	                bos = null;
	            } catch (IOException e) {
	            }
	        }
	    }
	    return;
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Load Adobe Reader</title>
<style type="text/css">
	.loadDiv{height:188px; width:521px; margin:122px auto 0px auto; border:#dbdbdb solid 1px;}
	.left{width:175px; height:100%; float:left;}
	.left span{margin-left:60px; font-size:14px; color:#134070; }
	.left .img{width:100%; height:100px; padding-top:38px; background: url("/formmode/exceldesign/image/printpdf_wev8.png") no-repeat 38px 38px; }
	.right{width:346px; height:100%; float:left;}
	.right .right_top{margin-top:66px; }
	.right .right_top span{padding-left:4px; font-size:14px;color:#242424}
	.right .right_bottom{margin-top:42px; margin-left:94px}
	.right .right_bottom a{color:#42b6f8; font-size:16px;}
</style>
</head>
<body>
	<div class="loadDiv">
		<div class="left">
			<div class="img"></div>
			<span>打印提示</span>
		</div>
		<div class="right">
			<div class="right_top">
				<span>请先安装 Adobe Reader 才能正常打印文件</span>
			</div>
			<div class="right_bottom">
				<a href="/formmode/exceldesign/loadAdobeReader.jsp?begload=true">立即下载</a>
			</div>
		</div>
	</div>
</body>
</html>