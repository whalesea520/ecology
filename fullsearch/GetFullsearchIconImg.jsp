<%@page import="weaver.file.AESCoder"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.file.FileUpload,weaver.file.Prop"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.hrm.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.sun.image.codec.jpeg.*"%>
<%@ page import="java.awt.*"%>
<%@ page import="java.awt.geom.Rectangle2D"%>
<%@ page import="java.awt.image.*"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.imageio.ImageIO"%>
<%@ page import="org.apache.commons.fileupload.*"%>
<%@ page import="java.util.zip.ZipInputStream"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="java.net.URLEncoder"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="mdci" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />



<%
    User user = HrmUserVarify.getUser (request , response) ;
    if(user == null)  return ;

    FileUpload fu = new FileUpload(request);
    int imagefileid = Util.getIntValue(fu.uploadFiles("fileSrcUrl"));
    String showStatus = Util.null2String(request.getParameter("showStatus"));
    String name = Util.null2String(request.getParameter("name"));
    String order = Util.null2String(request.getParameter("order"));
    String addDescLst = Util.null2String(request.getParameter("addDescLst"));
    //response.sendRedirect("ViewFixedInstLib.jsp?imagefileid="+imagefileid+"&showStatus="+showStatus+"&order="+order+"&fromUrl=1&name="+URLEncoder.encode(name,"UTF-8"));
    request.getRequestDispatcher("ViewFixedInstLib.jsp?imagefileid="+imagefileid+"&showStatus="+showStatus+"&order="+order+"&fromUrl=1&name="+URLEncoder.encode(name,"UTF-8")+"&addDescLst="+addDescLst).forward(request,response);
	
%>