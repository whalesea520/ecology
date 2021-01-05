
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.file.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="weaver.conn.RecordSet"%>
<jsp:useBean id="ps"
	class="weaver.mobile.plugin.ecology.service.PluginServiceImpl"
	scope="page" />
<%@ page import="weaver.docs.networkdisk.server.UploadFileServer"%>
<%@ page import="weaver.docs.networkdisk.server.PublishNetWorkFile" %>
<%@ page import="weaver.docs.networkdisk.tools.ImageFileUtil" %>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html;charset=UTF-8");
	
	FileUpload fu = new FileUpload(request); 
	String sessionkey = fu.getParameter("sessionkey");
	User user = HrmUserVarify.getUser(request,response);
	if(user == null){
	   Map result = ps.getCurrUser(sessionkey);
	   user = new User();
	   user.setUid(Util.getIntValue(result.get("id").toString()));
	   user.setLastname(result.get("name").toString());
	}
	
	String uploadname = Util.null2String(fu.getParameter("uploadname"));
	String uploaddata = Util.null2String(fu.getParameter("uploaddata"));
	String folderid = Util.null2String(fu.getParameter("folderid"));
	
	String uploadtype = Util.null2String(fu.getParameter("uploadtype"));
	
	RecordSet rs = new RecordSet();
	if(uploadtype.equals("system")){ //系统文档
	   	rs.executeSql("select id from DocSecCategory where id=" + folderid);
	   	if(rs.next()){
	   	    PublishNetWorkFile publishNetWorkFile = new PublishNetWorkFile();
	   	    int imagefileid = ImageFileUtil.createImageFileForMobile(uploaddata,uploadname);
	   	    List<Integer> imagefileids = new ArrayList<Integer>();
	   	 	imagefileids.add(imagefileid);
	   	    publishNetWorkFile.publishNetWorkFile(imagefileids, Util.getIntValue(folderid,0), user,1);
	   	 	out.println("<script>parent.uploadedCallback2()</script>");
	   	}else{
	   	 	out.println("<script>alert('上传失败!')</script>");
	   	}
	}else{ //云盘文件
        if(folderid.equals("0"))
        {
            rs.executeSql("select id from DocPrivateSecCategory where categoryname = '" + user.getUID() + "_" + user.getLastname() + "' and parentid=0");
			if(rs.next())
			{
				folderid = rs.getString("id");
			}
        }
	
		UploadFileServer uploadFileServer = new UploadFileServer();
		uploadFileServer.addImageFileRef(uploadname,uploaddata,user.getUID()+"",folderid);
		out.println("<script>parent.uploadedCallback()</script>");
	}
%>