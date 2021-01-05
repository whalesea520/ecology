<%@ page import="java.io.*" %>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
  <%
  	String preview = request.getParameter("preview");
	String path = getServletConfig().getServletContext().getRealPath("/");
	String imgPath = "";
	FileInputStream fis = null;
	try {
		File imgFile = new File(path+preview);
		baseBean.writeLog(imgFile.getAbsolutePath());
		if(!imgFile.exists())imgPath = "/page/resource/Thumbnail/priview_wev8.png";
		response.setContentType("image/png;charset=UTF-8");
		fis = new FileInputStream(path+preview);
		byte[] b = new byte[2048];

		while(fis.read(b)!=-1){
			response.getOutputStream().write(b);
		}

	} catch (Exception e) {
		e.printStackTrace();
	}finally{
		try{
		if(fis!=null) fis.close();
		}catch(Exception e){
			e.printStackTrace();
		}
	}
%>