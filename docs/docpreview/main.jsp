<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.file.ImageFileManager"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<!-- saved from url=(0014)about:internet -->
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en"> 
    <!-- 
    Smart developers always View Source. 
    
    This application was built using Adobe Flex, an open source framework
    for building rich Internet applications that get delivered via the
    Flash Player or to desktops via Adobe AIR. 
    
    Learn more about Flex at http://flex.org 
    // -->
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<%@page import="java.net.*" %>
<%@ page import="com.converter.main.MainConverter"%>
<%@ page import="com.converter.system.WebappContext" %>
<%@ page import="org.artofsolving.jodconverter.OfficeDocumentConverter" %>
<%@ page import="weaver.alioss.AliOSSObjectManager" %>
<%@ page import="weaver.file.ImageFileManager,java.util.*" %>
<%@page import="weaver.docs.pdf.docpreview.ConvertPDFUtil"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");
    String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");
	int workplanid = Util.getIntValue(request.getParameter("workplanid"),0);
	int desrequestid = Util.getIntValue(request.getParameter("desrequestid"),0);
	int requestid=Util.getIntValue(request.getParameter("requestid"),0);
    int docId = Util.getIntValue(request.getParameter("docId"),0);//文档id
    int versionId = Util.getIntValue(request.getParameter("versionId"),0);//文档版本id
    String iscopycontrol = Util.null2String(request.getParameter("iscopycontrol"));//是否开启复制控制
    String docPreviewType = Util.null2String(request.getParameter("docPreviewType"));//文档预览方式    1：OpenOffice    2:html
	String docPreviewType_prop=Util.null2String(RecordSet.getPropValue("docpreview","DocPreviewType"));//文档预览方式    1：OpenOffice    2:html
	//表单建模关联授权
	String formmodeflag = request.getParameter("formmode_authorize");
    String formmodeparamsStr ="";
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
    
	int imageFileId = Util.getIntValue(request.getParameter("imageFileId"),0);//文档附件id
		if(imageFileId<=0){
			RecordSet.executeSql("select imageFileId from DocImageFile where docId="+docId+" and versionId="+versionId);
			if (RecordSet.next()) {
				imageFileId= Util.getIntValue( RecordSet.getString("imageFileId"),0);
			}
		}
	
	RecordSet.executeSql("select filesize,imagefilename from ImageFile where imagefileid=" + imageFileId);
	double size = 0;
	double maxSize = 35d;
	String fileName = "";
	if(RecordSet.next()){
		try{
			size = Double.valueOf( RecordSet.getString("filesize"));
		}catch(Exception e){
			size = 0;
		}
		fileName = Util.null2String(RecordSet.getString("imagefilename"));
	}	
	
	fileName = fileName.toLowerCase();

	if(fileName.endsWith(".png") || fileName.endsWith(".gif") || fileName.endsWith(".jpg") || fileName.endsWith(".jpeg") || fileName.endsWith(".bmp")){
		%>
		 <link rel="stylesheet" href="/docs/pdfview/web/viewer.css"/>
		</head><body style="overflow:hidden">
		<div id="imageShow" class="pdfViewer">
			<div class="page" style="width:816px;overflow:auto">
				<div style="padding:80px;">
					<img style="margin:auto;display:block;max-width:100%;cursor:pointer" src="/weaver/weaver.file.FileDownload?fileid=<%=imageFileId%>&nolog=1&workplanid=<%=workplanid%>&requestid=<%=requestid%>&desrequestid=<%=desrequestid%><%=formmodeparamsStr %>"/>
				</div>
			</div>
			
		</div>
		<script>
			hideLoading();
			var winHei = parent.window.innerHeight;
			winHei = winHei - 95;
			
			jQuery("#imageShow .page").height(winHei - 20);
			jQuery("#imageShow img").css("max-height",winHei - 200);
			window.onload = function(){
				
				var innerHeight = winHei < window.innerHeight ? window.innerHeight : winHei;
				innerHeight = innerHeight - 160;
				var imgHeight = jQuery("#imageShow img").height();
				var imgWidth = jQuery("#imageShow img").width();
				if(innerHeight > imgHeight){
					jQuery("#imageShow img").css("margin-top",(innerHeight - imgHeight)/2 + "px");
				}
				
			}
			
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
			
			jQuery(function(){
				jQuery("img").live({
					click : function(){
						playImgs(this);
					}
				});
			})
			
			function playImgs(e){
				var imgPool=new Array()
				var indexNum = 0;
				var imgs = $("#imageShow img");
				imgs.each(function(){
					imgPool.push($(this).attr('src'));
				});
				for(var i = 0; i < imgPool.length ; i ++){
					if($(e).attr('src') == imgPool[i]){
						break;
					}
					else{
						indexNum++;
					}
				}
				parent.parent.IMCarousel.showImgScanner4Pool(true, imgPool, indexNum, null, window.top);
			}
		</script>
		</body></html>
		<%
		return;	
	}
	if(fileName.endsWith(".html")||fileName.endsWith(".htm")){
	%>
		<link rel="stylesheet" href="/docs/pdfview/web/viewer.css"/>
		<style>
			body{
				background-color:#ffffff;
				background-image:none;
			}
		</style>
		</head><body style="overflow:hidden">
		<iframe id="htmlShowContent" frameborder="0" style="width:100%;height:100%;" src="<%="/weaver/weaver.file.FileDownload?fileid="+imageFileId+"&nolog=1&requestid="+requestid+"&workplanid="+workplanid+"&desrequestid="+desrequestid%>" onload="hideLoading();displayRightMenu(this);"></iframe>
		</body></html>
	
	<%
	return;
	}
	String canDownload=request.getParameter("canDownload");
	if(docPreviewType.equals("2")||(docPreviewType.equals("")&&docPreviewType_prop.equals("2"))){
		ImageFileManager imageFileManager=new ImageFileManager();
		imageFileManager.getImageFileInfoById(imageFileId);
		String imageFileName=imageFileManager.getImageFileName();
		String canPrint=request.getParameter("canPrint");
		String isPDF = imageFileName.toLowerCase().endsWith(".pdf")+"";
		boolean isUsePDFViewer = ConvertPDFUtil.isUsePDFViewer();
		if(((imageFileName.toLowerCase().endsWith(".txt")||imageFileName.toLowerCase().endsWith(".log")||imageFileName.toLowerCase().endsWith(".sql")||imageFileName.toLowerCase().endsWith(".js")||imageFileName.toLowerCase().endsWith(".css")||imageFileName.toLowerCase().endsWith(".json")||imageFileName.toLowerCase().endsWith(".wps")||imageFileName.toLowerCase().endsWith(".ppt")||imageFileName.toLowerCase().endsWith(".pptx")) && isUsePDFViewer)||imageFileName.toLowerCase().endsWith(".pdf")||imageFileName.toLowerCase().endsWith(".doc")||imageFileName.toLowerCase().endsWith(".docx")||imageFileName.toLowerCase().endsWith(".xls")||imageFileName.toLowerCase().endsWith(".xlsx")){
			if(imageFileName.toLowerCase().endsWith("xls") || imageFileName.toLowerCase().endsWith("xlsx")){
				maxSize = 20d;
			}
			maxSize = maxSize*1024*1024;
			if(size > maxSize && !imageFileName.toLowerCase().endsWith(".pdf")){
				request.setAttribute("labelid","999");
				request.getRequestDispatcher("/docs/pdfview/web/sysRemind.jsp").forward(request,response);
				return;
			}
			response.sendRedirect("/docs/docpreview/main_html.jsp?iscopycontrol="+iscopycontrol+"&imagefilename="+URLEncoder.encode(imageFileName,"utf-8")+"&canPrint="+canPrint+"&canDownload="+canDownload+"&isPDF="+isPDF+"&docId="+docId+"&versionId="+versionId+"&imageFileId="+imageFileId+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&workplanid="+workplanid+"&requestid="+requestid+"&desrequestid="+desrequestid+""+formmodeparamsStr) ;
			return ;
		}
		else{
			  String sysremindurl="/wui/common/page/sysRemind.jsp?labelid=129755";
				if(canDownload.equals("true")){
					sysremindurl="/wui/common/page/sysRemind.jsp?labelid=129755";
				}else{
					sysremindurl="/wui/common/page/sysRemind.jsp?labelid=129757";
				}
			response.sendRedirect(sysremindurl) ;
			return ;
		}
	}
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

	//判断当前用户对当前附件是否有权限 结束

	String swfPara="";


	String  loadDspSwfPara=""+userId+"_"+loginType+"_"+docId+"_"+versionId+"_"+imageFileId;

	loadDspSwfPara = loadDspSwfPara + "_" + (int)(Math.random()*1000000000);
	try{
		WebappContext webappContext = WebappContext.get(getServletConfig().getServletContext());
		OfficeDocumentConverter converter = webappContext.getDocumentConverter();
		MainConverter mc = new MainConverter(converter);
	    String fileTableName="ImageFile";
		String systemtag=new weaver.general.BaseBean().getPropValue("docpreview","systemtag");
		mc.doFileConvert(imageFileId,fileTableName,systemtag,docId);

		swfPara= "loadDspSwf.jsp?loadDspSwfPara="+loadDspSwfPara;
		if(AliOSSObjectManager.isEnableForDsp(request)){
			int swfFileId=0;
			RecordSet.executeSql("select swfFileId from DocPreview where imageFileId="+imageFileId+" order by id desc");
			if(RecordSet.next()){
				swfFileId=Util.getIntValue(RecordSet.getString("swfFileId"));
			}
			String tokenKey=AliOSSObjectManager.getTokenKeyByImageFileId(swfFileId);
			if(!tokenKey.equals("")){
				String imageFileName="";
				RecordSet.executeSql(" select imageFileName from ImageFile where imageFileId="+swfFileId);
				if(RecordSet.next()){
					imageFileName=Util.null2String(RecordSet.getString("imageFileName"));
				}
				boolean isSafari=AliOSSObjectManager.isSafari(request);

				String urlString=Util.null2String(weaver.alioss.AliOSSObjectUtil.generatePresignedUrl(tokenKey,imageFileName,"application/x-shockwave-flash",true,"",isSafari));
				if(!urlString.equals("")){
					swfPara=urlString;
				}
			}
		}

	}catch(Exception e){
		RecordSet.writeLog(e);
		response.sendRedirect("/wui/common/page/sysRemind.jsp?labelid=123456");
		return;
	}
%>

    <head>
        <title><%=SystemEnv.getHtmlLabelName(221,user.getLanguage())%></title>
        <meta name="google" value="notranslate" />         
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <!-- Include CSS to eliminate any default margins/padding and set the height of the html element and 
             the body element to 100%, because Firefox, or any Gecko based browser, interprets percentage as 
             the percentage of the height of its parent container, which has to be set explicitly.  Fix for
             Firefox 3.6 focus border issues.  Initially, don't display flashContent div so it won't show 
             if JavaScript disabled.
        -->
        <style type="text/css" media="screen"> 
            html, body  { height:100%; }
            body { margin:0; padding:0; overflow:auto; text-align:center; 
                   background-color: #ffffff; }   
            object:focus { outline:none; }
            #flashContent { display:none; }
        </style>
        
        <!-- Enable Browser History by replacing useBrowserHistory tokens with two hyphens -->
        <!-- BEGIN Browser History required section -->
        <link rel="stylesheet" type="text/css" href="history/history_wev8.css" />
        <script type="text/javascript" src="history/history_wev8.js"></script>
        <!-- END Browser History required section -->  
            
        <script type="text/javascript" src="swfobject_wev8.js"></script>
<script type="text/javascript">
        	function getPara(){
        		return "<%=swfPara%>";
        	}

			function hidePageLoading(){
				try{
        			parent.finalDo("view");
        		}catch(e){}
        	}
			
			function loadswfobject(){
			//alert(getPara());
				// For version detection, set to min. required Flash Player version, or 0 (or 0.0.0), for no version detection. 
				var swfVersionStr = "10.2.0";
				// To use express install, set to playerProductInstall.swf, otherwise the empty string. 
				var xiSwfUrlStr = "playerProductInstall.swf";
				var flashvars = {};
				var params = {};
				params.quality = "high";
				params.bgcolor = "#ffffff";
				params.allowscriptaccess = "sameDomain";
				params.allowfullscreen = "true";
				params.wmode="direct";
				flashvars.SwfFile = "1";
				flashvars.FitWidthOnLoad = true;//适合宽度加载

				var attributes = {};
				attributes.id = "FlexPaperDemo";
				attributes.name = "FlexPaperDemo";
				attributes.align = "middle";
				swfobject.embedSWF(
					"FlexPaperDemo.swf", "flashContent", 
					"100%", "100%", 
					swfVersionStr, xiSwfUrlStr, 
					flashvars, params, attributes);
				// JavaScript enabled so display the flashContent div in case it is not replaced with a swf object.
				swfobject.createCSS("#flashContent", "display:block;text-align:left;");
			}
</script>  
        <script type="text/javascript">
$(document).ready(
	function(){
		loadswfobject();
	}
);
        </script>
    </head>
    <body>
        <!-- SWFObject's dynamic embed method replaces this alternative HTML content with Flash content when enough 
             JavaScript and Flash plug-in support is available. The div is initially hidden so that it doesn't show
             when JavaScript is disabled.
        -->
        <div id="flashContent">
            <p>
                To view this page ensure that Adobe Flash Player version 
                10.2.0 or greater is installed. 
            </p>
            <script type="text/javascript"> 
                var pageHost = ((document.location.protocol == "https:") ? "https://" : "http://"); 
                document.write("<a href='http://www.adobe.com/go/getflashplayer'><img src='" 
                                + pageHost + "www.adobe.com/images/shared/download_buttons/get_flash_player.gif' alt='Get Adobe Flash player' /></a>" ); 
            </script> 
        </div>
        
        <noscript>
            <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="100%" height="100%" id="FlexPaperDemo">
                <param name="movie" value="FlexPaperDemo.swf" />
                <param name="quality" value="high" />
                <param name="bgcolor" value="#ffffff" />
                <param name="allowScriptAccess" value="sameDomain" />
                <param name="allowFullScreen" value="true" />
                <!--[if !IE]>-->
                <object type="application/x-shockwave-flash" data="FlexPaperDemo.swf" width="100%" height="100%">
                    <param name="quality" value="high" />
                    <param name="bgcolor" value="#ffffff" />
                    <param name="allowScriptAccess" value="sameDomain" />
                    <param name="allowFullScreen" value="true" />
                <!--<![endif]-->
                <!--[if gte IE 6]>-->
                    <p> 
                        Either scripts and active content are not permitted to run or Adobe Flash Player version
                        10.2.0 or greater is not installed.
                    </p>
                <!--<![endif]-->
                    <a href="http://www.adobe.com/go/getflashplayer">
                        <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif" alt="Get Adobe Flash Player" />
                    </a>
                <!--[if !IE]>-->
                </object>
                <!--<![endif]-->
            </object>
        </noscript>     
   </body>
</html>


