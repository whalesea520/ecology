<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.workflow.layout.WorkflowPicDisplayUtil"%>


<%
//高版本chrome直接使用H5版本流程图进行展示 start
if (WorkflowPicDisplayUtil.isHVChrome(request)) {
    request.getRequestDispatcher("/workflow/design/h5display/index.jsp?" + request.getQueryString()).forward(request, response);
    return;
}
//高版本chrome直接使用H5版本流程图进行展示 end
%>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%
	int isfromdirection = Util.getIntValue(request.getParameter("isfromdirection"), 0);
	if(user == null)  return ;
	String isview = Util.null2String(request.getParameter("isview")) ;
	String fromFlowDoc = Util.null2String(request.getParameter("fromFlowDoc")) ;
	int modeid = Util.getIntValue(request.getParameter("modeid"),0) ;
	String requestid = Util.null2String(request.getParameter("requestid")) ;
	String workflowid = Util.null2String(request.getParameter("workflowid")) ;
	String nodeid = Util.null2String(request.getParameter("nodeid")) ;
	String isbill = Util.null2String(request.getParameter("isbill")) ;
	String formid = Util.null2String(request.getParameter("formid")) ;
%>
<% 
	String type = Util.null2String(request.getParameter("type"));
	String workflowId = Util.null2String((String)request.getParameter("wfid"));
	String serverstr=request.getScheme()+"://"+request.getHeader("Host");
	String dataurl = "/workflow/design/workflowPicDisplayInfo.jsp;jsessionid=" + session.getId() + "?requestid=" + requestid + "&wfid=" + workflowid + "&type=" + type;
//String dataurl = serverstr + "/workflow/design/workflow_view.xml";
//	System.out.println(dataurl);
%>

<%
String projectPath = request.getRequestURL().substring(0, request.getRequestURL().indexOf("/", 7) + 1);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html>
	<head>
		<title></title>

		<meta http-equiv="pragma" content="no-cache">
		 <link rel="stylesheet" type="text/css" href="/workflow/design/bin-debug/history/history_wev8.css" />
        <script type="text/javascript" src="/workflow/design/bin-debug/history/history_wev8.js"></script>
            
        <script type="text/javascript" src="/workflow/design/bin-debug/swfobject_wev8.js"></script>
        <script type="text/javascript">
            // For version detection, set to min. required Flash Player version, or 0 (or 0.0.0), for no version detection. 
            var swfVersionStr = "10.2.0";
            // To use express install, set to playerProductInstall.swf, otherwise the empty string. 
            var xiSwfUrlStr = "/workflow/design/bin-debug/playerProductInstall.swf";
            var flashvars = {};
            var params = {};
            params.quality = "high";
            params.bgcolor = "#ffffff";
            params.allowscriptaccess = "sameDomain";
            params.allowfullscreen = "true";
            //params.wmode="transparent";
            params.wmode = "opaque";
            var attributes = {};
            attributes.id = "EAdvanceGrid";
            attributes.name = "EAdvanceGrid";
            attributes.align = "middle";
            swfobject.embedSWF(
                "/workflow/design/bin-debug/EAdvanceGrid.swf", "flashContent", 
                "100%", "100%", 
                swfVersionStr, xiSwfUrlStr, 
                flashvars, params, attributes);
            // JavaScript enabled so display the flashContent div in case it is not replaced with a swf object.
            swfobject.createCSS("#flashContent", "display:block;text-align:left;");
        </script>
		 
		<script type="text/javascript"> 
		</script> 
		
		<script type="text/javascript">
		function getDataUrl() {
			var url = window.location.protocol + "//" + window.location.host + "<%=dataurl%>";
			return url;
		}
				
		function getAppUrl() {
			var url = window.location.protocol + "//" + window.location.host + "/";
			return url;
		}
		
		function getLanguage() {
			var language = "<%=user.getLanguage() %>";
			return language;
		}
		//鑾峰彇鍑哄彛鏉′欢
		function getOutletConditions(workflowid, nodelinkid){
			var ajaxUrl = '/workflow/design/wfQueryConditions.jsp?nodelinkid='+nodelinkid+'&workflowid='+workflowid+'&timeToken=' + new Date().getTime();
			//alert(ajaxUrl);
			jQuery.ajax({
			    url: ajaxUrl,
			    dataType: "text", 
			    contentType : "charset=UTF-8", 
			    error:function(ajaxrequest){}, 
			    success:function(data){
			    	//alert(data);
			    	jQuery("#Main")[0].flexFunctionNodeLinkCondition(nodelinkid, jQuery.trim(data));
			    }  
		    });
		}
		jQuery(document).ready(function () {
			jQuery("#Main").focus();
			jQuery("#Main").height(jQuery(document.body).height() - 5);
		});
		
		window.onresize = function () {
			jQuery("#Main").height(jQuery(document.body).height() - 5);
		};
		
		function isE8() {
			return true;
		}
		</script>
	</head>
	<body class="" id="" scroll="no" oncontextmenu="return false" onbeforeunload="" style="height:100%;padding:0px!important;margin:0px!important;margin-top:5px!important;overflow:hidden;">
		<DIV style="width:100%;height:100%;" id="editContentArea">
		<%
		String agent = request.getHeader("user-agent");
        if (agent == null || agent.indexOf("Trident") != -1) {
		%>
		<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="100%" height="100%" id="Main">
	                <param name="movie" value="/workflow/design/bin-debug/Main.swf" />
	                <param name="quality" value="high" />
	                <param value='transparent'>
	                <param name="wmode" value="window" />
	                <param name="bgcolor" value="#ffffff" />
	                <param name="allowScriptAccess" value="sameDomain" />
	                <param name="allowFullScreen" value="true" />
	                <!--[if !IE]>-->
	                <object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" type="application/x-shockwave-flash" width="100%" height="100%" id="wfdesignNotIE">

	                	<param name="movie" value="/workflow/design/bin-debug/Main.swf" />
	                    <param name="quality" value="high" />
	                    <param value='transparent'>
	                    <param name="wmode" value="transparent" />
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
	                        <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player_wev8.gif" alt="Get Adobe Flash Player" />
	                    </a>
	                	<!--[if !IE]>-->
	                </object>
	                <!--<![endif]-->
	            </object>
        <%
		}else{
		%>
	                <object type="application/x-shockwave-flash" width="100%" height="100%" id="Main" data="/workflow/design/bin-debug/Main.swf">
	                	<param name="movie" value="/workflow/design/bin-debug/Main.swf" />
	                    <param name="quality" value="high" />
	                    <param value='transparent'>
	                    <param name="wmode" value="transparent" />
	                    <param name="bgcolor" value="#ffffff" />
	                    <param name="allowScriptAccess" value="sameDomain" />
	                    <param name="allowFullScreen" value="true" />
	                </object>

		<%}%>	


		</DIV>
	</body>
</html>