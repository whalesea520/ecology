
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%

	String module = Util.null2String((String)request.getParameter("module"));
	String scope = Util.null2String((String)request.getParameter("scope"));
	String clienttype = Util.null2String((String)request.getParameter("clienttype"));
	String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));
	int fromRequestid = Util.getIntValue(request.getParameter("fromRequestid"), 0);
	
	int isfromdirection = Util.getIntValue(request.getParameter("isfromdirection"), 0);

	//2015/12/07 获取次账号信息
	//User user = HrmUserVarify.getUser(request , response) ;
	String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));//需要增加的代码
	String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));//需要增加的代码
	User user  = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
	
	String isview = Util.null2String(request.getParameter("isview")) ;
	String fromFlowDoc = Util.null2String(request.getParameter("fromFlowDoc")) ;
	int modeid = Util.getIntValue(request.getParameter("modeid"),0) ;
	String requestid = Util.null2String(request.getParameter("requestid")) ;
	String nodeid = Util.null2String(request.getParameter("nodeid")) ;
	String isbill = Util.null2String(request.getParameter("isbill")) ;
	String formid = Util.null2String(request.getParameter("formid")) ;
	//标记是从微搜模块进入start
String fromES=Util.null2String((String)request.getParameter("fromES"));
//标记是从微搜模块进入end
%>
<% 
	String type = Util.null2String(request.getParameter("type"));
	String workflowid = Util.null2String((String)request.getParameter("workflowid"));
	String dataurl = "/mobile/plugin/1/workflowPicDisplayInfo.jsp?requestid=" + requestid + "&wfid=" + workflowid + "&type=" + type + "&charsetgbk=true";
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<!-- jQuery 1.9.1 -->
	<script type="text/javascript" src="design/js/jquery_wev8.js"></script>
	<script type="text/javascript" src="design/js/beans_wev8.js"></script>
	<script type="text/javascript" src="design/js/design_wev8.js"></script>
	<script type="text/javascript" src="design/js/xmlParse_wev8.js"></script>
	<script type="text/javascript" src="design/js/canvasUtil_wev8.js"></script>
	<link rel="stylesheet" type="text/css" href="design/css/design_wev8.css" />
	<link rel="stylesheet" href="/mobile/plugin/css/mobile_wev8.css" type="text/css">
	<title></title>
	
	<style type="text/css">
	
	#header {
			width:100%;
			background: -moz-linear-gradient(top, white, #ECECEC);
			filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#FFFFFF', endColorstr='#ececec');
			background: -webkit-gradient(linear, left top, left bottom, from(#FFFFFF), to(#ECECEC));
			background: -moz-linear-gradient(top, white, #ECECEC);
			border-bottom: #CCC solid 1px;
			/*filter: alpha(opacity=70);
			-moz-opacity: 0.70;
			opacity: 0.70;*/
			position:relative;
		}
	</style>
	<script type="text/javascript">
	
	var nodebases = null;
	
	var maxPoint = new Point(0, 0);
	
    var f_weaver_belongto_userid = '<%=f_weaver_belongto_userid%>';
    var f_weaver_belongto_usertype = '<%=f_weaver_belongto_usertype%>';
	function popup(e, message, t, l) { 
		if (jQuery("#dialog-box, #dialog-overlay").css("display") != "none") {
			return;
		} 
		var ev = e ? e : event;
		var position = getPointerPosition(ev);
		
		var interY = $("#titleBlock").height(); 
		var message = isClickNode(new Point(position.left, position.top - interY))
		if (message == "") {
			return;
		}
		
		var maskHeight = $(document).height(); 
		var maskWidth = $(window).width(); 
		var dialogTop = position.top; 
		var dialogLeft = position.left; 
		
		$('#dialog-box').css({top:dialogTop, left:dialogLeft}).show(); 
		$('#dialog-message').html(message); 
		e.stopPropagation();
	}
	
	function getPointerPosition(e){
       var obj = e.currentTarget||document.activeElement;
       var position = {
              left:e.pageX || (e.clientX + (document.documentElement.scrollLeft || document.body.scrollLeft)),
              top:e.pageY || (e.clientY + (document.documentElement.scrollTop || document.body.scrollTop))
           };
       return position;
	}
	
	function isClickNode(oldPoint) {
		for (var i=0; i<nodebases.length; i++) {
			var x = nodebases[i].x;
			var y = nodebases[i].y;
			var w = nodebases[i].getWHPoint().x;
			var h = nodebases[i].getWHPoint().y;
			if (oldPoint.x >= x && oldPoint.x <= x + w
				&& oldPoint.y >= y && oldPoint.y <= y + h) {
				return getShowMessage(nodebases[i]);;
			}
		}
		return "";
	}
	
	function getShowMessage(nodebase) {
		var rhtml = "<table border=\"0\" cellpadding=\"0\" cellspacing=\"0\" width=\"200px\">";
		if (nodebase.nodeOptType == 1) {
			rhtml += "<tr><td style='word-break : break-all; overflow:hidden; '>";
			rhtml += "<img src=\"/mobile/plugin/1/images/imgPersonHead_wev8.png\" title=\"<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>\">";
			rhtml += "&nbsp;" + nodebase.nodeNotOperatorNames;
			rhtml += "</td></tr>";
			
			rhtml += "<tr><td style='word-break : break-all; overflow:hidden; '>";
			rhtml += "<img src=\"/mobile/plugin/1/images/icon_resource_wev8.png\" title=\"<%=SystemEnv.getHtmlLabelName(16355,user.getLanguage())%>\">";
			rhtml += "&nbsp;" + nodebase.nodeViewNames;
			rhtml += "</td></tr>";
			
			rhtml += "<tr><td style='word-break : break-all; overflow:hidden; '>";
			rhtml += "<img src=\"/mobile/plugin/1/images/iconemp_wev8.png\" title=\"<%=SystemEnv.getHtmlLabelName(16353,user.getLanguage())%>\">";
			rhtml += "&nbsp;" + nodebase.nodeOperatorNames;
			rhtml += "</td></tr>";
		} else if (nodebase.nodeOptType == 0) {
		
			rhtml += "<tr><td style='word-break : break-all; overflow:hidden; '>";
			rhtml += "<img src=\"/mobile/plugin/1/images/iconemp_wev8.png\" title=\"<%=SystemEnv.getHtmlLabelName(16353,user.getLanguage())%>\">";
			rhtml += "&nbsp;" + nodebase.nodeOperatorNames;
			rhtml += "</td></tr>";
		} else if (nodebase.nodeOptType == 2) {
			rhtml += "<tr><td style='word-break : break-all; overflow:hidden; '>";
			rhtml += "<img src=\"/mobile/plugin/1/images/imgPersonHead_wev8.png\" title=\"<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>\">";
			rhtml += "&nbsp;" + nodebase.nodeOperatorNames;
			rhtml += "</td></tr>";
		}
		rhtml += "</table>";
		return rhtml;
	}
	var maxWidth = 800;
	var maxHeight = 600;
	var widthViewPage = maxWidth;
	
	jQuery(document).ready(function () {
		jQuery(window).resize(function () { 
			if (!jQuery('#dialog-box').is(':hidden')) popup(); 
		}); 
		
		jQuery(document.body).bind("click", function () {
			jQuery("#dialog-box, #dialog-overlay").css("display", "none");
		});
		
		jQuery.ajax({
            url: "<%=dataurl %>",
      		cache: false, 
      		contentType:"application/x-www-form-urlencoded; charset=UTF-8", 
            error:function(ajaxrequest){alert("error");}, 
            success:function(content){
		        var xmlParse = new XmlParse();
				var workflowBase = xmlParse.parse(content);
				nodebases = workflowBase.nodeBases;
				
				for (var i=0; i<nodebases.length; i++) {
					var crtNode = nodebases[i];
					if (crtNode.x + 150 > maxWidth) {
						maxWidth = crtNode.x + 150;
					}
					if (crtNode.y + 150 > maxHeight) {
						maxHeight = crtNode.y + 150;
					}
				}
				
				for (var i=0; i<workflowBase.groups.length; i++) {
					var g =  workflowBase.groups[i];
					if (g.direction == 0) {
						if (g.x + g.width > maxWidth) {
							maxWidth = g.x + g.width;
						}
						if (g.y + g.height > maxHeight) {
							maxHeight = g.y + g.height;
						}
					} else if (g.direction == 1) {
						if (g.y + g.height > maxHeight) {
							maxHeight = g.y + g.height;
						}
					} else if (g.direction == 2) {
						if (g.x + g.width > maxWidth) {
							maxWidth = g.x + g.width;
						}
					}
				}
				maxWidth += 50;
				var canvashtml = "<canvas id='mainArea' width='" + maxWidth + "px' height='" + maxHeight + "px' style='background:#ffffff;' >您的浏览器不支持HTML5 CANCAL元素</canvas>";
				$("#content").html($("#content").html() + canvashtml);
				jQuery("#mainArea").bind("click", function () {
					popup(event, "");
				});
				draw(workflowBase);
				
				widthViewPage = maxWidth;
				winResize();
            }  
        });
	});
	
	function backoldPic() {
		//window.location.href = "/mobile/plugin/1/workflowPicture.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>&fromRequestid=<%=fromRequestid%>&isOldData=true&fromES=<%=fromES%>";
		
	    var locationHref = "/mobile/plugin/1/workflowPicture.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>&fromRequestid=<%=fromRequestid%>&isOldData=true&fromES=<%=fromES%>";
	    
	    try{
	        locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
	    }catch(e){
	    }
	    window.location.href = locationHref;
	}
	
	function goWfForm() {
		//window.location.href = "/mobile/plugin/1/view.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>&fromRequestid=<%=fromRequestid%>&fromES=<%=fromES%>";
		
        var locationHref = "/mobile/plugin/1/view.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>&fromRequestid=<%=fromRequestid%>&fromES=<%=fromES%>";
        
        try{
            locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
        }catch(e){
        }
        window.location.href = locationHref;
		
	}
	function goWfStatus() {
		//window.location.href = "/mobile/plugin/1/workflowStatus.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>&fromRequestid=<%=fromRequestid%>&fromES=<%=fromES%>";
		
        var locationHref = "/mobile/plugin/1/workflowStatus.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>&fromRequestid=<%=fromRequestid%>&fromES=<%=fromES%>";
        
        try{
            locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
        }catch(e){
        }
        window.location.href = locationHref;
	}
	
	function doLeftButton() {
		if(<%=fromRequestid%> > 0 || "<%=fromES%>"=="true"){
			goBack();
			return 1;
		}
	}

	function goBack() {
		if(<%=fromRequestid%> > 0){
			//location = "/mobile/plugin/1/view.jsp?requestid=<%=fromRequestid%>&workflowid=<%=workflowid%>&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>";
			
	        var locationHref = "/mobile/plugin/1/view.jsp?requestid=<%=fromRequestid%>&workflowid=<%=workflowid%>&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>";
	        
	        try{
	            locationHref += "&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype;
	        }catch(e){
	        }
	        location = locationHref;
		} else {
			var fromES="<%=fromES%>";
			if(fromES=="true"){
				 location = "/mobile/plugin/fullsearch/list.jsp?module=<%=module%>&scope=<%=scope%>&fromES=true";
			}else{
				location = "/list.do?module=<%=module%>&scope=<%=scope%>";
			}
		}
	}
		
	
	var widthViewPage = maxWidth;
	window.onresize = winResize;
	
	//调整页面顶端导航栏的宽度。
	function winResize(){
		if(document.body.clientWidth > widthViewPage){
			document.getElementById("view_page").style.width = document.body.clientWidth;
		}else{
			document.getElementById("view_page").style.width = widthViewPage;	
		}
	}  
	
	jQuery(winResize);
	</script>
	
	</head>
	<body style="">	
<div id="view_page">
	<div id="titleBlock">
	<div id="view_header" style="<%if (clienttype.equals("Webclient")) {%>display:block;<%} else {%>display:none;<%}%>">
		<table style="width:100%;height:40px;font-size:13px;">
			<tr>
				<td width="10%" align="left" valign="middle" style="padding-left:5px;">
					<a href="javascript:goBack();">
						<div style="width:56px;height:26px;background:url('/images/bg-top-btn_wev8.png') no-repeat;text-align:center;line-height:26px;color:#000;">
						<%-- 返回 --%>
                        <%=SystemEnv.getHtmlLabelName(83823,user.getLanguage()) %>
						</div>
					</a>
				</td>
				<td align="center" valign="middle">
					<div id="view_title">
					   <%-- 流程图 --%>
                        <%=SystemEnv.getHtmlLabelName(18912,user.getLanguage()) %>
					</div>
				</td>
				<td width="10%" align="right" valign="middle" style="padding-right:5px;">
				</td>
			</tr>
		</table>
	</div>

	<div id="header" style="height:30px;padding-top:3px;">
		
		<div style="width:182px;height:25px;margin-right:auto;margin-left:auto;-webkit-border-radius:3px;-moz-border-radius:3px;text-align:center;color:#000;filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#FEFEFE',endColorstr='#D1D1D1' );background: -webkit-gradient(linear, left top, left bottom, from(#FEFEFE),to(#D1D1D1) );background: -moz-linear-gradient(top, #FEFEFE, #D1D1D1);border: #A4A4A4 solid 1px;">
			<a href="javascript:goWfForm();">
			<div style="float:left;width:60px;height:25px;line-height:25px;border-right: #A4A4A4 solid 1px;">
			
            <%-- 表单 --%>
            <%=SystemEnv.getHtmlLabelName(31923,user.getLanguage()) %>
			</div>
			</a>
			<div style="float:left;width:60px;height:25px;line-height:25px;filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='#D1D1D1',endColorstr='A4A4A4' );background: -webkit-gradient(linear, left top, left bottom, from(#D1D1D1),to(#A4A4A4) );background: -moz-linear-gradient(top, #D1D1D1, #A4A4A4);">
			<%-- 流程图 --%>
            <%=SystemEnv.getHtmlLabelName(18912,user.getLanguage()) %>
			</div>
			
			<a href="javascript:goWfStatus();">
			<div style="float:right;width:60px;height:25px;line-height:25px;border-left: #A4A4A4 solid 1px;">
			<%-- 状态 --%>
            <%=SystemEnv.getHtmlLabelName(126034,user.getLanguage()) %>
			</div>
			</a>		
		</div>
	
	</div>
	</div>
		<div id="content" style="height:100%;width:100%;">
			<div id="dialog-overlay"></div> 
			
			<!-- 操作者信息展示 Start -->
			<div id="dialog-box" style=""> 
				<div id="msgTitle">
					<div id="msgtleblockleft"></div>
					<div id="msgtleblockright"></div>
					<div id="msgtleblockcenter">
					<%-- 操作者 --%>
	                    <%=SystemEnv.getHtmlLabelName(99,user.getLanguage()) %>
					</div>
				</div>
				<div id="msgblock"> 
					<div id="dialog-message" style="margin-left:5px;margin-right:5px;"></div> 
				</div> 
			</div> 
			<!-- 操作者信息展示 END -->
			<!-- 
			<canvas id="mainArea" style="background:#ffffff;" >您的浏览器不支持HTML5 CANCAL元素</canvas>
			-->
		</div>
</div>
	</body>
</html>