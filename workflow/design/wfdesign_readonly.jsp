
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<%@ page contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%
	String workflowId = Util.null2String((String)request.getParameter("wfid"));
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(Util.getIntValue(workflowId), 0, user, WfRightManager.OPERATION_CREATEDIR);
	if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	
	String type = Util.null2String(request.getParameter("type"));
	String serverstr=request.getScheme()+"://"+request.getHeader("Host");
	
	String dataurl = "/workflow/design/wfdesign_data.jsp;jsessionid=" + session.getId() + "?userid=" + user.getUID() + "&wfid=" + workflowId + "&type=" + type;
	boolean isFullScreen = Util.null2String(request.getParameter("isFullScreen")).equals("true")?true:false;
	type= type==""?"edit":type;
	
	WFManager.setWfid(Util.getIntValue(workflowId));
	WFManager.getWfInfo();
%>
<%@ include file="/workflow/workflow/addwf_checktetachable.jsp" %>
<jsp:useBean id="xmlParser" class="weaver.workflow.layout.WorkflowXmlParser" scope="page" />
<!DOCTYPE html PUBLIC "">
<html>
	<head>
		<style type="text/css">
		/* CSS Document */		

/* BUTTONS */

.buttons a, .buttons button{
    display:block;
    float:left;
    margin:0 7px 0 0;
    background-color:#f8f8f8;
    border:0px solid #dedede;
    border-top:1px solid #eee;
    border-left:1px solid #eee;

    font-family:"Lucida Grande", Tahoma, Arial, Verdana, sans-serif;
    font-size:12px;
    line-height:130%;
    text-decoration:none;
    font-weight:bold;
    color:#565656;
    cursor:pointer;
    padding:5px 10px 6px 7px; /* Links */
}
.buttons button{
    width:auto;
    overflow:visible;
    padding:4px 10px 3px 7px; /* IE6 */
}
.buttons button[type]{
    padding:5px 10px 5px 7px; /* Firefox */
    line-height:17px; /* Safari */
}
*:first-child+html button[type]{
    padding:4px 10px 3px 7px; /* IE7 */
}
.buttons button img, .buttons a img{
    margin:0 3px -3px 0 !important;
    padding:0;
    border:none;
    width:16px;
    height:16px;
}

/* STANDARD */
/*
button:hover, .buttons a:hover{
    background-color:#dff4ff;
    border:1px solid #c2e1ef;
    color:#336699;
}*/
.buttons a:active{
    background-color:#f8f8f8;
    border:0px solid #6299c5;
    color:#fff;
}

/* POSITIVE */

button.positive, .buttons a.positive{
    color:#529214;
}
/*
.buttons a.positive:hover, button.positive:hover{
    background-color:#E6EFC2;
    border:1px solid #C6D880;
    color:#529214;
}*/
.buttons a.positive:active{
    background-color:#f8f8f8;
    border:0px solid #529214;
    color:#fff;
}

/* CSS Document */		

/* BUTTONS */

.buttons a, .buttons button{
    display:block;
    float:left;
    margin:0 7px 0 0;
    background-color:#f8f8f8;
    border:0px solid #dedede;
    border-top:1px solid #eee;
    border-left:1px solid #eee;

    font-family:"Lucida Grande", Tahoma, Arial, Verdana, sans-serif;
    font-size:12px;
    line-height:130%;
    text-decoration:none;
    font-weight:bold;
    color:#565656;
    cursor:pointer;
    padding:5px 10px 6px 7px; /* Links */
}
.buttons button{
    width:auto;
    overflow:visible;
    padding:4px 10px 3px 7px; /* IE6 */
}
.buttons button[type]{
    padding:5px 10px 5px 7px; /* Firefox */
    line-height:17px; /* Safari */
}
*:first-child+html button[type]{
    padding:4px 10px 3px 7px; /* IE7 */
}
.buttons button img, .buttons a img{
    margin:0 3px -3px 0 !important;
    padding:0;
    border:none;
    width:16px;
    height:16px;
}

/* STANDARD */
/*
button:hover, .buttons a:hover{
    background-color:#dff4ff;
    border:1px solid #c2e1ef;
    color:#336699;
}*/
.buttons a:active{
    background-color:#f8f8f8;
    border:0px solid #6299c5;
    color:#fff;
}

/* POSITIVE */

button.positive, .buttons a.positive{
    color:#529214;
}
/*
.buttons a.positive:hover, button.positive:hover{
    background-color:#E6EFC2;
    border:1px solid #C6D880;
    color:#529214;
}*/
.buttons a.positive:active{
    background-color:#f8f8f8;
    border:0px solid #529214;
    color:#fff;
}

/* NEGATIVE */

.buttons a.negative, button.negative{
    color:#d12f19;
}
/*
.buttons a.negative:hover, button.negative:hover{
    background:#fbe3e4;
    border:1px solid #fbc2c4;
    color:#d12f19;
}*/
.buttons a.negative:active{
    background-color:#f8f8f8;
    border:0px solid #d12f19;
    color:#fff;
}

/* REGULAR */

button.regular, .buttons a.regular{
    color:#336699;
}
/*
.buttons a.regular:hover, button.regular:hover{
    background-color:#dff4ff;
    border:1px solid #c2e1ef;
    color:#336699;
}
*/
.buttons a.regular:active{
    background-color:#f8f8f8;
    border:0px solid #6299c5;
    color:#fff;
}
		
		</style>
		<%if(user.getLanguage()==7) {%>
			<script type="text/javascript" src="/js/workflow/design/lang-cn_wev8.js"></script>
		<%} else if(user.getLanguage()==8) {%>
			<script type='text/javascript' src='/js/workflow/design/lang-en_wev8.js'></script>
		<%} else if(user.getLanguage()==9) {%>
			<script type='text/javascript' src='/js/workflow/design/lang-tw_wev8.js'></script>
		<%}%>
		<script type="text/javascript" src="../../js/jquery/jquery-1.4.2.min_wev8.js"></script>
		<link rel="stylesheet" type="text/css" href="/workflow/design/bin-debug/history/history_wev8.css" />
        <script type="text/javascript" src="/workflow/design/bin-debug/history/history_wev8.js"/>
        <!-- END Browser History required section -->  
        <script type="text/javascript" src="/workflow/design/bin-debug/swfobject_wev8.js" />
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
        	/**
             * 流程图加载数据url
             */
            function getDataUrl() {
				var url = window.location.protocol + "//" + window.location.host + "<%=dataurl %>";
				return url;
			}
			
			function getIsDesign() {
				return "true";
			}
			
			function getLanguage() {
				var language = "<%=user.getLanguage() %>";
				return language;
			}
			
			function edit() {
				jQuery.ajax({
				    url: "/workflow/design/wfdesign_status.jsp?wfid=<%=workflowId %>&userid=<%=user.getUID()%>&d" + (new Date().getTime()) + "=",
				    dataType: "text", 
				    error:function(ajaxrequest){alert("<%=SystemEnv.getHtmlLabelName(81499,user.getLanguage())%>");}, 
				    success:function(content){
				    	content = jQuery.trim(content);
				    	if (content != "1") {
				    		var url = "/workflow/design/wfdesign_display.jsp?wfid=<%=workflowId %>&type=<%=type %>";
				    		//window.open (url,'_blank','height='+window.screen.height+',width='+window.screen.width+',top=0,left=0,toolbar=no,menubar=no,scrollbars=no,resizable=no');
							//window.showModalDialog(url, window,'dialogWidth:'+window.screen.width+';dialogHeight:'+window.screen.height)
							//closewindow();
							//改为弹出层
							var dialog = new window.top.Dialog();
							dialog.currentWindow = window;
							dialog.Title = "<%=SystemEnv.getHtmlLabelName(125060,user.getLanguage()) %>";
							dialog.URL = url;
							dialog.CancelEvent = function () {
								dialog.close();
								checkInWfChart();	//流程图迁入
							}
							dialog.Width = $(window.top).width()-60;
							dialog.Height = $(window.top).height()-80;
							dialog.maxiumnable=true;
							dialog.show();
				    	} else {
				    		alert(wmsg.wfdesign.checkoutMsg);
				    	}
				    }  
		    	});
				
			}
			
			function checkInWfChart(){
				jQuery.ajax({
					type: "POST",
				    url: "/weaver/weaver.workflow.layout.WorkflowDesignOperatoinServlet?method=checkin&wfId=<%=workflowId%>",
				    error:function(ajaxrequest){
				    	alert(wmsg.wfdesign.checkinError);
				    	window.location.reload();
				    }, 
				    success:function(data){
				    	eval(data);
						if(result.status!='0'){
							alert(wmsg.wfdesign.error,result.errormsg)
						}
						window.location.reload();
				    }
			    });
			}
			
			
			var isFullScreen ='<%=isFullScreen%>'
			if(window.console){    console.log("isFullScreen="+isFullScreen);}
			function fullScreen() {
				var url='/workflow/design/wfdesign_readonly.jsp?wfid=<%=workflowId %>&type=view&isFullScreen='+isFullScreen+'&timeStamp='+new Date().getTime();
				//window.showModalDialog(url,window,'dialogWidth:'+document.body.offsetWidth+';dialogHeight:'+document.body.offsetHeight);
				window.open(url,'_blank','height='+window.screen.height+',width='+window.screen.width+',top=0,left=0,toolbar=no,menubar=no,scrollbars=no,resizable=no')
			}
			
			function closeSelf() {
				window.close();
			}
			
			
		function closewindow() {   
			var xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
			xmlHttp.onreadystatechange = function(){
				if (xmlHttp.readyState == 4) {
					try {
						eval(xmlHttp.responseText)
						if(result.status=='0'){
						
							//成功，刷新流程设置页面
							if(window.dialogArguments!=null){
								var href = window.dialogArguments.parent.location.href;
								if(href.indexOf("?")!=-1){
									href = href+"&fromWfEdit=true";
								}else{
									href = href+"?fromWfEdit=true";
								}
								window.close();
								window.dialogArguments.parent.location.replace(href)
							} else {
								//成功，刷新流程设置页面
								var href = window.parent.location.href;
								if(href.indexOf("?")!=-1){
									href = href+"&fromWfEdit=true";
								}else{
									href = href+"?fromWfEdit=true";
								}
								window.parent.location.replace(href)
							}
						}else{
							//失败
							parent.alert(wmsg.wfdesign.error,result.errormsg);
						}
					}
					catch(e) {
						alert(wmsg.wfdesign.checkinError);
					}
			    }
			}
			xmlHttp.open("POST", "/weaver/weaver.workflow.layout.WorkflowDesignOperatoinServlet?method=checkin&wfId=<%=workflowId%>", false);
			xmlHttp.send();
		}
		
		
		//获取出口条件
		function getOutletConditions(workflowid, nodelinkid){
			var ajaxUrl = '/workflow/design/wfQueryConditions.jsp?nodelinkid='+nodelinkid+'&workflowid='+workflowid+'&timeToken=' + new Date().getTime();
			//alert(ajaxUrl);
			jQuery.ajax({
			    url: ajaxUrl,
			    dataType: "text", 
			    contentType : "charset=UTF-8", 
			    error:function(ajaxrequest){alert("error");}, 
			    success:function(data){
			    	swfObj[0].flexFunctionNodeLinkCondition(nodelinkid, jQuery.trim(data));
			    }  
		    });
		}
		
		var swfObj;
		window.onresize = function () {
			swfObj.height(jQuery(document.body).height() - 40);
		};
		jQuery(document).ready(function () {
			if(navigator.appName.indexOf("Microsoft") != -1){
				swfObj=$("#wfdesignIE");
			}else{
				swfObj=$("#wfdesignNotIE");
			}
			swfObj.height(jQuery(document.body).height() - 40);
			<%if(Util.null2String(WFManager.getIsEdit()).equals("1") && WFManager.getEditor()!=user.getUID()){
				ResourceComInfo ResourceComInfo=new ResourceComInfo();
				String username=ResourceComInfo.getResourcename(String.valueOf(WFManager.getEditor()));
			%>
			if(isFullScreen!='true')
				alert("<%=SystemEnv.getHtmlLabelName(128940,user.getLanguage())%><%=username %><%=SystemEnv.getHtmlLabelName(128941,user.getLanguage())%>");
			<%}%>
			
			jQuery(".regular").blur();
		});
        </script>
	</head>
	<body class="" id="" scroll="no" oncontextmenu="return false" onbeforeunload="" style="width:100%;height:100%;padding:0px!important;margin:0px!important;overflow:hidden;">
		<div style="height:100%;overflow:hidden;">
			<%
				/*
				 * 当流程不是自由流程时，显示“编辑”和“全屏”按钮
				 * 当流程为自由流程时，不允许进行编辑和全屏操作
				 */
				if( !WFManager.getIsFree().equals("1") ){
			%>
			<div style="width:100%;height:30px;background-color:#F8F8F8;">
				<div class="buttons" style="background-color:#F8F8F8;">
			<%
					if( !(Util.null2String(WFManager.getIsEdit()).equals("1") && WFManager.getEditor()!=user.getUID()) ){
			%>
						<a class="regular" href="javascript:edit();" id="edit" title="<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%>">
							<img src="/images/ecology8/workflow/edit0822_wev8.png"/>
							<%=SystemEnv.getHtmlLabelName(26473,user.getLanguage())%>
						</a>
			<%
					} 
			%>
			<%
					if (!isFullScreen) {
			%>
						<a class="regular" id="full" title="<%=SystemEnv.getHtmlLabelName(26096,user.getLanguage())%>"  href="javascript:fullScreen();">
							<img src="/images/ecology8/workflow/allprintscreen_wev8.png"/>
							<%=SystemEnv.getHtmlLabelName(26096,user.getLanguage())%>
						</a>
			<%
					} else {
			%>
						<a class="regular" id="close" title="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"  href="javascript:closeSelf();">
							<img src="/images/wfdesign/close_wev8.gif"/>
							<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>
						</a>
			<%
					}
			%>
				</div>
			</div>
			<%
				}
			%>
				
			<div id="container" style="border:0px solid #ccc;height:100%;width:100%;">
				<!-- 左侧工作区 -->
				<div style="height:100%;width:100%;">
					<!-- <noscript> -->
				<object classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" width="100%" height="100%" id="wfdesignIE">
	                <param name="movie" value="/workflow/design/bin-debug/Main.swf" />
	                <param name="quality" value="high" />
	                <param value='transparent'>
	                <param name="wmode" value="window" />
	                <param name="bgcolor" value="#ffffff" />
	                <param name="allowScriptAccess" value="sameDomain" />
	                <param name="allowFullScreen" value="true" />
	                <!--[if !IE]>-->
	                <object type="application/x-shockwave-flash" width="100%" height="100%" id="wfdesignNotIE">
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
				<!-- </noscript>  -->
				</div>
			</div>
		</div>
	</body>
</html>
