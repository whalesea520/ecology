
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*,weaver.conn.RecordSet"%>
<%@ page import="weaver.file.*"%>
<jsp:useBean id="ps"
    class="weaver.mobile.plugin.ecology.service.PluginServiceImpl"
    scope="page" />
<%@ page import="weaver.docs.networkdisk.tools.ImageFileUtil"%>
<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html;charset=UTF-8");
    
    RecordSet rs = new RecordSet();
    FileUpload fu = new FileUpload(request); 
    String sessionkey = Util.null2String(fu.getParameter("sessionkey"));
    
    String uploadname = Util.null2String(fu.getParameter("uploadname"));
    String uploaddata = Util.null2String(fu.getParameter("uploaddata"));
    
    
    int imagefileid = ImageFileUtil.createImageFileForMobile(uploaddata,uploadname);
    
    
    out.println("<script>parent.uploadedCallback(" + imagefileid + ")</script>");
%>