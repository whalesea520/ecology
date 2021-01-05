<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.net.*" %>
<%@page import="weaver.docs.pdf.docpreview.ConvertPDFUtil"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocPreviewHtmlManager" class="weaver.docs.docpreview.DocPreviewHtmlManager" scope="page"/>
<%@ page import="weaver.docs.pdf.docpreview.ConvertPDFTools" %>
<%@ page import="weaver.email.service.MailFilePreviewService" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<% 
	BaseBean baseBeanRigthMenu = new BaseBean();

    int docId = Util.getIntValue(request.getParameter("docId"),0);//文档id
    int versionId = Util.getIntValue(request.getParameter("versionId"),0);//文档版本id
    String isPDF = Util.null2String(request.getParameter("isPDF"),"false");
    int imageFileId = Util.getIntValue(request.getParameter("imageFileId"),0);//文档附件id
	String imagefilename = Util.null2String(request.getParameter("imagefilename"),"document.pdf");
	
	String agent = request.getHeader("user-agent");
	boolean isIE8 = (agent.indexOf("MSIE 8.0;") > 0||agent.indexOf("MSIE 7.0") > 0);

	int  userId=user.getUID();
	int  loginType= Util.getIntValue(user.getLogintype(),1);

	
	MailFilePreviewService mfps = new MailFilePreviewService();
	
	Map<String,String>	fileInfo = mfps.getFileInfoMap(user.getUID(),imageFileId + "");
	
	
	//判断当前用户对当前附件是否有权限 开始
	boolean hasRight = fileInfo.get("canread").equals("true") ? true : false;
	String filename = fileInfo.get("filename");
	
	if(!hasRight){
		response.sendRedirect("/notice/noright.jsp") ;
		return;
	}
	
	try{
	    boolean isUsePDFViewer = ConvertPDFUtil.isUsePDFViewer();
		int htmlFileId = 0;
	    if(isUsePDFViewer || "true".equals(isPDF)){
			//if("true".equals(isPDF)){
			//	htmlFileId = imageFileId;
			//}else{
				ConvertPDFTools convertPDFTools = new ConvertPDFTools();
				htmlFileId= convertPDFTools.conertToPdfForEmail(imageFileId,filename,0);
				if(htmlFileId == -1){
					request.setAttribute("labelid","转换失败!");
					request.getRequestDispatcher("/wui/common/page/sysRemindDocpreview.jsp").forward(request,response);
					return;
				}
			//}
	    }else{
			int maxFileSize = Util.getIntValue(RecordSet.getPropValue("docpreview","maxFileSize"),5);
			int fileSize = Util.getIntValue( fileInfo.get("filesize"),0);
			if(fileSize>maxFileSize*1024*1024){
				request.setAttribute("labelid","-99999");
				request.getRequestDispatcher("/wui/common/page/sysRemind.jsp").forward(request,response);
				return;
			}
			try{
				 htmlFileId=DocPreviewHtmlManager.doFileConvertForEmail(imageFileId,filename,0);
				 if(htmlFileId == -1){
					request.setAttribute("labelid","转换失败!");
					request.getRequestDispatcher("/wui/common/page/sysRemindDocpreview.jsp").forward(request,response);
					return;
				}
			}catch(Exception fpe){	
			    request.setAttribute("labelid",Util.null2String(fpe.getMessage()));
				request.getRequestDispatcher("/wui/common/page/sysRemindDocpreview.jsp").forward(request,response);
				return;
			}
	    }
		if(htmlFileId>0){
		%>
		<script type="text/javascript">
				try{
					document.body.style.overflow="hidden";
				}catch(e){}
				function hideLoading(){
					try{
						parent.finalDo("view");
					}catch(e){
						window.setTimeout(function(){
								try{
									parent.finalDo("view");
								}catch(e){}
									},1000);					
					}
				}
		</script>
		
			<% if((isUsePDFViewer || "true".equals(isPDF))&&!isIE8) { %>
		<iframe id="htmlShowContent" frameborder="0" onselectstart="return false;" unselectable="on" style="width:100%;height:100%;" hidden="hidden" src="<%="/docs/pdfview/web/filepdfview.jsp?imagefilename="+URLEncoder.encode(imagefilename,"utf-8")+"&pdfimagefileid="+htmlFileId %>" onload="changeType();hideLoading();"></iframe>	
		<%
			}
			else{
				 %>
				 <iframe id="htmlShowContent" frameborder="0" style="width:100%;height:100%;" src="<%="/weaver/weaver.file.FileDownload?fileid="+htmlFileId%>" hidden="hidden" src="下载" onload="changeType();hideLoading();"></iframe>
				 <%
			}
		}

	}catch(Exception e){
		RecordSet.writeLog(e);
		request.setAttribute("labelid","123456");
		request.getRequestDispatcher("/wui/common/page/sysRemind.jsp").forward(request,response);
		return;
	}
%>
<script type="text/javascript">
	
	function changeType(){
		var $body = document.getElementById("htmlShowContent").contentWindow.document.body;
		replaceImgSrc($body);
		jQuery("#htmlShowContent").removeAttr("hidden");
	}
	
	function replaceImgSrc($obj){
		if($obj.tagName == "IMG"){
			$obj.setAttribute("src",$obj.getAttribute("src"));
		}else{
			for(var i = 0;i < $obj.childNodes.length;i++){
				replaceImgSrc($obj.childNodes[i]);
			}
		}
		
	}
</script>