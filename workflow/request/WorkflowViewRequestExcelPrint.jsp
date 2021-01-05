<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%@ page import="weaver.hrm.*" %>
<%
User user = HrmUserVarify.getUser (request , response);
String pdfStreamLink="/workflow/request/WorkflowPDFStream.jsp";
String pdf_html = Util.null2String(request.getParameter("pdf_html"));
String pdf_css = Util.null2String(request.getParameter("pdf_css"));
String pdf_requestid = Util.null2String(request.getParameter("pdf_requestid"));
String pdf_userid = Util.null2String(request.getParameter("pdf_userid"));
if("".equals(pdf_requestid) || "".equals(pdf_userid) || "".equals(pdf_html))
	return;
//生成唯一sessionKey
String uniqueKey = pdf_requestid+"_"+pdf_userid+"_"+new Date().getTime();
pdfStreamLink += "?uniqueKey="+uniqueKey;
//生成需要打印的Html
//String pdf_width = Util.null2String(request.getParameter("pdf_width"), "760");
//int pdf_height = Integer.parseInt(pdf_width)*297/210;
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort();
StringBuffer pdf_formhtml=new StringBuffer();
pdf_formhtml.append("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">")
	.append("\n").append("<html>")
	.append("\n").append("<head>")
	.append("\n").append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />")
	.append("\n").append("<link href=\"").append(basePath).append("/workflow/exceldesign/css/excelHtml_wev8.css\" rel=\"stylesheet\" type=\"text/css\" />")
	.append("\n").append("<style>")
	//.append("\n").append("@page{size: "+pdf_width+"px "+pdf_height+"px}")
	.append("\n").append("table{table-layout:fixed; word-break:break-strict;}")	//转PDF中文换行table必须加此属性
	.append("\n").append("a{text-decoration:none;color:black !important}")
	.append("\n").append("</style>")
	.append("\n").append(pdf_css)
	.append("\n").append("</head>")
	.append("\n").append("<body>")
	.append("\n").append(pdf_html)
	.append("\n").append("</body>")
	.append("\n").append("</html>");
//System.err.println(pdf_formhtml);
session.setAttribute("pdf_formhtml_"+uniqueKey, pdf_formhtml);
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <TITLE>PDF<%=SystemEnv.getHtmlLabelNames("257,221",user.getLanguage()) %></TITLE>
    <script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
    <script type="text/javascript">
    isAcrobatPluginInstall();
    
   	//检查客户端是否安装pdf阅读器软件
	function isAcrobatPluginInstall(){
		 var flag = false;
		 if (navigator.plugins && navigator.plugins.length) {		 // 如果是firefox浏览器
		 	for (x = 0; x < navigator.plugins.length; x++) {
				if(navigator.plugins[x].name == 'Adobe Acrobat')
				flag = true;
			}
		 }else if (window.ActiveXObject) {		 // 下面代码都是处理IE浏览器的情况
			 for (x = 2; x < 10; x++) {
				 try {
				 	oAcro = eval("new ActiveXObject('PDF.PdfCtrl." + x + "');");
					if (oAcro)	flag = true;
				 } catch (e) {
				 	flag = false;
				 }
			 }
			 try {
				 oAcro4 = new ActiveXObject('PDF.PdfCtrl.1');
				 if (oAcro4)	flag = true;
			 } catch (e) {
			 	flag = false;
			 }
			 try {
				 oAcro7 = new ActiveXObject('AcroPDF.PDF.1');
				 if (oAcro7)	flag = true;
			 } catch (e) {
			 	flag = false;
			 }
		 }
		 if (!flag) {
		 	window.location.href="/workflow/exceldesign/loadAdobeReader.jsp";
		 }
	}
	
	jQuery(document).ready(function(){
		jQuery(".pdf_loaddingdiv").css("left",parseInt(jQuery(window).width()-jQuery(".pdf_loaddingdiv").width())/2);
		jQuery(".pdf_loaddingdiv").css("top",parseInt(jQuery(window).height()-jQuery(".pdf_loaddingdiv").height())/2);
		var ajaxover = false;		//ajax请求是否完成
		var firstajax = true;		//是否第一次ajax请求
		var loadTimer = setInterval(function(){
			if(firstajax || ajaxover){
				jQuery.ajax({
					type: "POST",
					url: "/workflow/request/WorkflowPDFStreamResult.jsp?uniqueKey=<%=uniqueKey %>",
					success: function(msg){
						firstajax = false;
						var streamResult = jQuery.trim(msg);
						if(streamResult == "1"){
							clearInterval(loadTimer);
							jQuery(".pdf_showdiv").css("display","block");
						}
						ajaxover = true;
					}
				})
			}
		},500);
	});
    </script>
    <style>
        .pdf_bgdiv{
        	width:100%; height:100%; background:#000;
        	position:absolute; top:0px; left:0px;
        	z-index:9999; filter:alpha(opacity=20);-moz-opacity:0.2;opacity:0.2;
        }
        .pdf_loaddingdiv{
        	height:48px; line-height:48px; width:217px; 
        	background:#ebf8ff; color:#4c7c9f;
        	border:1px solid #9cc5db; position:absolute;
        	z-index:9999;font-size:12px;
        }
     	.pdf_showdiv{
     		width:100%; height:100%; z-index:0; display:none;
     		position:absolute; top:0px; left:0px;
     	}
    </style>
</head>
<body style="overflow:hidden">
	<div class="pdf_bgdiv"></div>
	<span class="pdf_loaddingdiv">
		<img src="/images/ecology8/workflow/multres/cg_lodding_wev8.gif" height="27px" width="57px" style="vertical-align:middle;"/>
		<span style="margin-left:22px;"><%=SystemEnv.getHtmlLabelName(84041, user.getLanguage())%></span>
	</span>
	<div class="pdf_showdiv">
		<object classid="clsid:CA8A9780-280D-11CF-A24D-444553540000" width="100%" height="100%" border="0" top="-10" name="pdf">
			<param name="toolbar" value="false">
			<param name="_Version" value="65539"> 
			<param name="_ExtentX" value="20108">
			<param name="_ExtentY" value="10866">
			<param name="_StockProps" value="0">

			<param name="src" value="<%=pdfStreamLink %>">
			<!--[if !IE]>-->
			<object type="application/pdf" width="100%" height="100%" border="0" top="-10" name="pdf">
				<param name="toolbar" value="false">
				<param name="_Version" value="65539"> 
				<param name="_ExtentX" value="20108">
				<param name="_ExtentY" value="10866">
				<param name="_StockProps" value="0">
				
				<param name="src" value="<%=pdfStreamLink %>">
			</object>
			<!--<![endif]-->
		</object>
	</div>
</body>
</html>