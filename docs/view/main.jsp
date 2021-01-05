<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.*" %>
<%@ page import="weaver.email.service.MailFilePreviewService" %>
<%@ page import="weaver.docs.pdf.docpreview.ConvertPDFUtil"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en"> 
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
    String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");
	
    String docPreviewType = Util.null2String(request.getParameter("docPreviewType"));
	String docPreviewType_prop=Util.null2String(RecordSet.getPropValue("docpreview","DocPreviewType"));
	
	int imageFileId = Util.getIntValue(request.getParameter("imageFileId"),0);//文档附件id
	
	// 通过接口获取附件信息
	MailFilePreviewService mfps = new MailFilePreviewService();
			
	Map<String,String>	fileInfo = mfps.getFileInfoMap(user.getUID(),imageFileId + "");
	
	//String downloadUrl = Util.null2String(fileInfo.get("downloadUrl"));
	double size = Double.valueOf(fileInfo.get("filesize"));
	double maxSize = 35d;
	String fileName = Util.null2String(fileInfo.get("filename")).toLowerCase();
	
	if(docPreviewType.equals("1") || fileName.endsWith(".png") || fileName.endsWith(".gif") 
			|| fileName.endsWith(".jpg") || fileName.endsWith(".jpeg") || fileName.endsWith(".bmp")){
		String viewUrl = mfps.getPreviewUrl(imageFileId + "");
		%>
		<link rel="stylesheet" href="/docs/pdfview/web/viewer.css"/>
		</head><body style="overflow:auto;text-align:center">
			<img src="<%=viewUrl %>"/>
		</body></html>
		<%
		return;
	}
	
	if(fileName.endsWith(".html")||fileName.endsWith(".htm")){
		String viewUrl = mfps.getPreviewUrl(imageFileId + "");
	%>
		<link rel="stylesheet" href="/docs/pdfview/web/viewer.css"/>
		</head><body style="overflow:hidden">
		<iframe id="htmlShowContent" frameborder="0" style="width:100%;height:100%;" src="<%= viewUrl %>"></iframe>
		</body></html>
	
	<%
	return;
	}
	if(docPreviewType.equals("2")||(docPreviewType.equals("")&&docPreviewType_prop.equals("2"))){
		
		String isPDF = fileName.toLowerCase().endsWith(".pdf")+"";
		
		boolean isUsePDFViewer = ConvertPDFUtil.isUsePDFViewer();
		
		
		if(((fileName.toLowerCase().endsWith(".wps")||fileName.toLowerCase().endsWith(".ppt")||fileName.toLowerCase().endsWith(".pptx")) && isUsePDFViewer)||fileName.toLowerCase().endsWith(".pdf")||fileName.toLowerCase().endsWith(".doc")||fileName.toLowerCase().endsWith(".docx")||fileName.toLowerCase().endsWith(".xls")||fileName.toLowerCase().endsWith(".xlsx")){
			if(fileName.toLowerCase().endsWith("xls") || fileName.toLowerCase().endsWith("xlsx")){
				maxSize = 20d;
			}
			maxSize = maxSize*1024*1024;
			if(size > maxSize && !fileName.toLowerCase().endsWith(".pdf")){
				request.setAttribute("labelid","999");
				request.getRequestDispatcher("/docs/pdfview/web/sysRemind.jsp").forward(request,response);
				return;
			}
			response.sendRedirect("/docs/view/main_html.jsp?imagefileName="+URLEncoder.encode(fileName,"utf-8")+"&isPDF="+isPDF+"&imageFileId="+imageFileId+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype) ;
			return ;
		}
		else{
			response.sendRedirect("/wui/common/page/sysRemind.jsp?labelid=129755");
			return ;
		}
	}
%>
    <head>
        <title><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></title>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    </head>
    <body>
   </body>
</html>