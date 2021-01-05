
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@page import="java.net.*" %>
<%@page import="weaver.docs.pdf.docpreview.ConvertPDFUtil"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocPreviewHtmlManager" class="weaver.docs.docpreview.DocPreviewHtmlManager" scope="page"/>
<%@ page import="weaver.docs.pdf.docpreview.ConvertPDFTools" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<% 
	BaseBean baseBeanRigthMenu = new BaseBean();
	int desrequestid = Util.getIntValue(request.getParameter("desrequestid"),0);
	int requestid=Util.getIntValue(request.getParameter("requestid"),0);
	int workplanid = Util.getIntValue(request.getParameter("workplanid"),0);
	String  formmodeparamsStr = "";
	String formmodeflag = Util.null2String(request.getParameter("formmode_authorize"));
	if(formmodeflag.equals("formmode_authorize")){
		int modeId = 0;
		int formmodebillId = 0;
		int fieldid = 0;
		int formModeReplyid = 0;
		modeId = Util.getIntValue(request.getParameter("authorizemodeId"),0);
		formmodebillId = Util.getIntValue(request.getParameter("authorizeformmodebillId"),0);
		fieldid = Util.getIntValue(request.getParameter("authorizefieldid"),0);
		formModeReplyid = Util.getIntValue(request.getParameter("authorizeformModeReplyid"),0);
		String fMReplyFName = Util.null2String(request.getParameter("authorizefMReplyFName"));
			
		formmodeparamsStr = "&formmode_authorize="+formmodeflag+"&authorizemodeId="+modeId+"&authorizeformmodebillId="+
        	formmodebillId+"&authorizefieldid="+fieldid+"&authorizeformModeReplyid="+formModeReplyid+"&authorizefMReplyFName="+fMReplyFName;
		
		
	}
int userightmenu = 1;
try{
	userightmenu = Util.getIntValue(baseBeanRigthMenu.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}
%>
<script type="text/javascript">
var rightMenu = null;
	jQuery(document).ready(function(){
		<%if(userightmenu==1){%>
			document.oncontextmenu=showRightClickMenu;
			document.body.onclick=hideRightClickMenu;		
		<%}%>
		rightMenu=parent.document.getElementById('rightMenu');
	});
	function showRightClickMenu(e){	
		var event = e?e:(window.event?window.event:null);
		var loc=event.clientY+70;
		var rightedge=document.body.clientWidth-event.clientX;
		var bottomedge=document.body.clientHeight-event.clientY;
		if (rightedge<rightMenu.offsetWidth)
			rightMenu.style.left=(event.clientX-rightMenu.offsetWidth)+"px";
		else
			rightMenu.style.left=event.clientX+"px";
		if (bottomedge<rightMenu.offsetHeight)
			rightMenu.style.top=(loc-rightMenu.offsetHeight)+"px";
		else
			rightMenu.style.top=loc+"px";
			rightMenu.style.visibility="visible"
			rightMenu.style.display="block";
		if(!!event){
			try{
			 	event.stopPropagation();
			 	event.preventDefault();
			}catch(e){
				window.event.cancelBubble = true;
				return false;
			}
		}	
		return false;
	}
	
	function hideRightClickMenu(){		
			rightMenu.style.visibility="hidden"
			rightMenu.style.display="none";
			
	}
	
	function displayRightMenu(obj){
		//try{
			var _document = obj.contentWindow.document;
			<%if(userightmenu==1){%>
				jQuery(_document.body).bind("contextmenu",function(e){
					showRightClickMenu(e);						
				});
				_document.body.onclick=hideRightClickMenu;		
			<%}%>
			jQuery(_document.body).css("height","100%");
			jQuery(_document.body).parent().css("height","100%");
		//}catch(e){}
	}
</script>
<%

    int docId = Util.getIntValue(request.getParameter("docId"),0);//文档id
    int versionId = Util.getIntValue(request.getParameter("versionId"),0);//文档版本id
        String iscopycontrol = Util.null2String(request.getParameter("iscopycontrol"));//是否开启锁定查看文档
	String isPDF = Util.null2String(request.getParameter("isPDF"),"false");
	String canDownload=request.getParameter("canDownload");
	String canPrint=request.getParameter("canPrint");
    int imageFileId = Util.getIntValue(request.getParameter("imageFileId"),0);//文档附件id
	String imagefilename = Util.null2String(request.getParameter("imagefilename"),"document.pdf");
	if(imageFileId<=0){
		RecordSet.executeSql("select imageFileId from DocImageFile where docId="+docId+" and versionId="+versionId);
		if (RecordSet.next()) {
			imageFileId= Util.getIntValue( RecordSet.getString("imageFileId"),0);
		}
	}
	String agent = request.getHeader("user-agent");
	boolean isIE8 = (agent.indexOf("MSIE 8.0;") > 0||agent.indexOf("MSIE 7.0") > 0);

	int  userId=user.getUID();
	int  loginType= Util.getIntValue(user.getLogintype(),1);

	//判断当前用户对当前附件是否有权限 开始
	boolean hasRight = false;
	int hasRightInt=Util.getIntValue((String)session.getAttribute("hasRight_"+userId+"_"+loginType+"_"+docId+"_"+versionId+"_"+imageFileId),-1);

	if(hasRightInt==1){
		hasRight=true;
	}
	if(docId<=0&&versionId<=0&&imageFileId<=0){
		hasRight=false;
	}
	
	if(!hasRight){
		response.sendRedirect("/notice/noright.jsp") ;
		return;
	}


	try{
	    boolean isUsePDFViewer = ConvertPDFUtil.isUsePDFViewer();
		int htmlFileId = 0;
	    if(isUsePDFViewer || "true".equals(isPDF))
	    {
		if("true".equals(isPDF))
		{
			htmlFileId = imageFileId;
		}
		else
		{
			String sql = "select * from pdf_imagefile where imagefileid="+imageFileId;
			RecordSet.executeSql(sql);
			if(RecordSet.next()){
				htmlFileId = Util.getIntValue(RecordSet.getString("pdfimagefileid"),0);
			}
			else
			{
				ConvertPDFTools convertPDFTools = new ConvertPDFTools();
				htmlFileId= convertPDFTools.conertToPdf(imageFileId+"");
			}
		}
	    }
	    else
	    {
	        String sql = " select fileSize from ImageFile where imagefileid="+imageFileId;
			RecordSet.executeSql(sql);
			int fileSize = 0;
			int maxFileSize = Util.getIntValue(RecordSet.getPropValue("docpreview","maxFileSize"),5);
			if(RecordSet.next()){
				fileSize = Util.getIntValue( RecordSet.getString("fileSize"),0);
			}
			if(fileSize>maxFileSize*1024*1024){
				request.setAttribute("labelid","-99999");
				request.getRequestDispatcher("/wui/common/page/sysRemind.jsp").forward(request,response);
				return;
			}
			try{
				 htmlFileId=DocPreviewHtmlManager.doFileConvert(imageFileId,null,null,docId,versionId);
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
			<script type="text/javascript">
				window.__printvar=encodeURI("<%="/docs/pdfview/web/pdfPrintViewer.jsp?imagefilename="+URLEncoder.encode(imagefilename,"utf-8")+"&canPrint="+canPrint+"&canDownload="+canDownload+"&pdfimagefileid="+htmlFileId +"&requestid="+requestid+formmodeparamsStr%>");
			</script>
			<iframe id="htmlShowContent" frameborder="0" onselectstart="return false;" unselectable="on" style="width:100%;height:100%;" src="<%="/docs/pdfview/web/pdfViewer.jsp?imagefilename="+URLEncoder.encode(imagefilename,"utf-8")+"&canPrint="+canPrint+"&canDownload="+canDownload+"&pdfimagefileid="+htmlFileId +"&requestid="+requestid+formmodeparamsStr%>" onload="hideLoading();displayRightMenu(this);
			<%
			if("1".equals(iscopycontrol)){
				%>
					addCopycontrol();
				<%  
			}
			%>
		"></iframe>	
		<%
			}
			else{
				 %>
				<iframe id="htmlShowContent" frameborder="0" style="width:100%;height:100%;" src="<%="/weaver/weaver.file.FileDownload?fileid="+htmlFileId+"&requestid="+requestid+"&desrequestid="+desrequestid+formmodeparamsStr%>" onload="hideLoading();displayRightMenu(this);
				 <%
				if("1".equals(iscopycontrol)){
					%>
						addCopycontrol();
					<%  
				}
				%>
			"></iframe>
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
	function addCopycontrol(){
		var ifmObj=document.getElementById("htmlShowContent").contentWindow.document.body;
		ifmObj.setAttribute("onselectstart", "return false");
		ifmObj.setAttribute("unselectable", "on");
		ifmObj.style.cssText="display: block;-moz-user-select: none;-webkit-user-select: none;-ms-user-select: none;-o-user-select:none;-khtml-user-select: none;user-select: none;";
	}
	
	function changeType(){
		var $body = document.getElementById("htmlShowContent").contentWindow.document.body;
		replaceImgSrc($body);
		jQuery("#htmlShowContent").removeAttr("hidden");
	}
	
	function replaceImgSrc($obj){
		if($obj.tagName == "IMG"){
			$obj.setAttribute("src",$obj.getAttribute("src") + "<%="&requestid="+requestid+"&desrequestid="+desrequestid%>");
		}else{
			for(var i = 0;i < $obj.childNodes.length;i++){
				replaceImgSrc($obj.childNodes[i]);
			}
		}
		
	}
</script>