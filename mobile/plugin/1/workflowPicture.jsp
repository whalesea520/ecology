
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.workflow.layout.RequestDisplayInfo" %>
<%

boolean isoldData = "true".equals(Util.null2String(request.getParameter("isOldData")));
//是否开启新版流程图，开启则跳转至新版显示
BaseBean bb = new BaseBean();
int isuseNewDesign = Util.getIntValue(
		bb.getPropValue("workflowNewDesign", "isusingnewDesign"), 0);

if (isuseNewDesign == 1 && !isoldData) {
	request.getRequestDispatcher("/mobile/plugin/1/workflowNewPicture.jsp").forward(request, response);
	return ;
}

request.setCharacterEncoding("UTF-8");
response.setContentType("text/html;charset=UTF-8");

String module = Util.null2String((String)request.getParameter("module"));
String scope = Util.null2String((String)request.getParameter("scope"));
String clienttype = Util.null2String((String)request.getParameter("clienttype"));
String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));

//2015/12/07 获取次账号信息
//User user = HrmUserVarify.getUser(request , response) ;
String f_weaver_belongto_userid=Util.null2String(request.getParameter("f_weaver_belongto_userid"));//需要增加的代码
String f_weaver_belongto_usertype=Util.null2String(request.getParameter("f_weaver_belongto_usertype"));//需要增加的代码
User user  = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int workflowid =  Util.getIntValue(request.getParameter("workflowid"), 0);
int requestid = Util.getIntValue(request.getParameter("requestid"), -1);
RequestDisplayInfo reqDisplayInfo = new RequestDisplayInfo(String.valueOf(workflowid), String.valueOf(requestid));
reqDisplayInfo.setUser(user);
reqDisplayInfo.setIsnewDesign(false);
Map<String, Object> reqDisBean = reqDisplayInfo.getReqDisInfo();
int fromRequestid = Util.getIntValue(request.getParameter("fromRequestid"), 0);

List<Map<String, Object>> nodeDisInfo = (List<Map<String, Object>>)reqDisBean.get("nodeinfo");
List<Map<String, Object>> nodeLinkLineInfo = (List<Map<String, Object>>)reqDisBean.get("lineinfo");

int minWidth = 0;
int minHeigth = 0;

//标记是从微搜模块进入start
String fromES=Util.null2String((String)request.getParameter("fromES"));
//标记是从微搜模块进入end
%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery_wev8.js'></script>
	<script type='text/javascript' src='/mobile/plugin/js/jquery/jquery-ui_wev8.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/css/cupertino/jquery-ui_wev8.css" type="text/css">
	<link rel="stylesheet" href="/mobile/plugin/css/mobile_wev8.css" type="text/css">
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
		#dialog-overlay { 
			width:100%; height:100%; 
			filter:alpha(opacity=50); 
			-moz-opacity:0.5; 
			-khtml-opacity: 0.5; 
			opacity: 0.5; 
			position:absolute; 
			background:#000; 
			top:0; left:0; 
			z-index:3000; 
			display:none; 
		} 
		#dialog-box {
			box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5); 
			-webkit-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5); 
			-moz-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5); 
			border-radius: 5px; 
			-moz-border-radius: 5px; 
			-webkit-border-radius: 5px; 
			background:#eee; width:240px; position:absolute; z-index:5000; display:none; 
		} 
		#dialog-box .dialog-content { 
			text-align:left; 
			padding:10px; 
			margin:13px; 
			color:#666; 
			font-family:arial; 
			font-size:11px; 
		} 
		a.button { margin:10px auto 0 auto; text-align:center; background-color: #e33100; display: block; width:50px; padding: 5px 10px 6px; color: #fff; text-decoration: none; font-weight: bold; line-height: 1; -moz-border-radius: 5px; -webkit-border-radius: 5px; -moz-box-shadow: 0 1px 3px rgba(0, 0, 0, 0.5); -webkit-box-shadow: 0 1px 3px rgba(0, 0, 0, 0.5); text-shadow: 0 -1px 1px rgba(0, 0, 0, 0.25); border-bottom: 1px solid rgba(0, 0, 0, 0.25); position: relative; cursor: pointer; } 
		a.button:hover { background-color: #c33100; } 
		#dialog-box .dialog-content p { font-weight:700; margin:0; } 
		#dialog-box .dialog-content ul { margin:10px 0 10px 20px; padding:0; height:50px; }
		.nodeBlock {
			box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5);
			-webkit-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5); 
			-moz-box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.5); 
			border-radius: 5px; 
			-moz-border-radius: 5px; 
			-webkit-border-radius: 5px;
		}
		.radiusBlock {
			-moz-border-top-left-radius: 5px;
			-moz-border-top-right-radius: 5px;
			-webkit-border-top-left-radius: 5px; 
			-webkit-border-top-right-radius: 5px; 
			border-top-left-radius:5px;
			border-top-right-radius:5px;
			box-shadow: 10px 10px 10px rgba(0, 0, 0, 0.5); 
			-webkit-box-shadow: 10px 10px 10px rgba(0, 0, 0, 0.5); 
			-moz-box-shadow: 10px 10px 10px rgba(0, 0, 0, 0.5);
			padding-left:2px;padding-top:1px;color:white;
			border:1px solid black;
			border-bottom:0px solid black;
		}
		
		.radiusBlockBottom {
			-moz-border-bottom-left-radius: 5px;
			-moz-border-bottom-right-radius: 5px;
			-webkit-border-bottom-left-radius: 5px; 
			-webkit-border-bottom-right-radius: 5px; 
			border-bottom-left-radius:5px;
			border-bottom-right-radius:5px;
			box-shadow: 10px 10px 10px rgba(0, 0, 0, 0.5);
			-webkit-box-shadow: 10px 10px 10px rgba(0, 0, 0, 0.5);
			-moz-box-shadow: 10px 10px 10px rgba(0, 0, 0, 0.5);
			padding-top:1px;height:100%;background-color:#F5F5F5;border:1px solid #0079A4;padding-left:2px;
			padding-right:2px;
			height:55px;
		}
		
		.borderRed {
			border:2px solid red;
		}
		
		body{
			background: white!important;
		}
		</style>
		<script type="text/javascript">
		function popup(e, message, t, l) { 
			var ev = e ? e : event;
			var position = getPointerPosition(ev);
			
			var maskHeight = $(document).height(); 
			var maskWidth = $(window).width(); 
			var dialogTop = position.top;//t + 45;//(maskHeight/3) - ($('#dialog-box').height()); 
			var dialogLeft = position.left;//l + 20;//(maskWidth/2) - ($('#dialog-box').width()/2); 
			
			//alert(position.top);
			//alert(position.left);
			//$('#dialog-overlay').css({height:maskHeight, width:maskWidth}).show(); 
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
		       if ($("#clientType").val() == 'Web') {
		           position.top -= 40;
		       }
		       position.top -= 40;
		       return position;
		}
		
		function drawLine(context, lineWidth, lineColor, x1, y1, x2, y2) {
			context.beginPath();
			context.lineWidth = lineWidth;
			context.strokeStyle = lineColor;
			context.moveTo(x1, y1);
			context.lineTo(x2, y2);
			context.stroke(); 
		}
		
		</script>
		<script type="text/javascript">
		
		    var f_weaver_belongto_userid = '<%=f_weaver_belongto_userid%>';
		    var f_weaver_belongto_usertype = '<%=f_weaver_belongto_usertype%>';
			function drawWfPic(canvas) {
				var canvas = $("#nodeLinkLineArea")[0];
				var _callBack = function () {
					drawWfPic();
				};
				if (canvas == null || canvas == undefined) {
					setTimeout(_callBack, 500);
					return ;
				} 
				var context = canvas.getContext("2d");
					
				<%
				for (Iterator<Map<String, Object>> it=nodeLinkLineInfo.iterator();it.hasNext();) {
					
					Map<String, Object> lineBean = it.next();
					
					List<Map<String, Integer>> lines = (List<Map<String, Integer>>)lineBean.get("lines");
					if (minWidth == 0) {
						minWidth = (Integer)lineBean.get("minWidth");
						minHeigth = (Integer)lineBean.get("minHeigth");
					}
					for (Iterator<Map<String, Integer>> lineIt=lines.iterator();lineIt.hasNext();) {
						Map<String, Integer> line = lineIt.next();
				%>
						drawLine(context, 3, "<%=lineBean.get("color")%>", <%=line.get("x1") %>, <%=line.get("y1")%>, <%=line.get("x2") %>, <%=line.get("y2")%>);
				<%
					}
				}
				%>
				
				
			}
			$(document).ready(function () { 
				$(window).resize(function () { 
					if (!$('#dialog-box').is(':hidden')) popup(); 
				}); 
				drawWfPic();
				
				$(document.body).bind("click", function () {
					$("#dialog-box, #dialog-overlay").css("display", "none");
				});
			}); 
			
			/**
			 * 阻止事件冒泡
			 * @param e 事件event 
			 * @param handler 
			 * @return
			 */
			function isMouseLeaveOrEnter(e, handler) {
			    if (e.type != 'mouseout' && e.type != 'mouseover') return false;
			    var reltg = e.relatedTarget ? e.relatedTarget : e.type == 'mouseout' ? e.toElement : e.fromElement;
			    while (reltg && reltg != handler)
			        reltg = reltg.parentNode;
			    return (reltg != handler);
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
				window.location.href = "/mobile/plugin/1/workflowStatus.jsp?requestid=<%=requestid%>&workflowid=<%=workflowid%>&module=<%=module%>&scope=<%=scope%>&clienttype=<%=clienttype%>&clientlevel=<%=clientlevel%>&fromRequestid=<%=fromRequestid%>&fromES=<%=fromES%>";
				
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
			
			
			var widthViewPage = <%=(minWidth + 20)%>;
			window.onresize = winResize;
			
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
	<body style="margin:0px;">

<div id="view_page" style="width:<%=(minWidth + 20)%>">
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




		<div id="content" style="position:relative;">
			<div id="dialog-overlay" onclick="onHide(this);"></div> 
			<div id="dialog-box" onclick="onHide(this);"> 
				<div class="dialog-content"> 
					<div id="dialog-message"></div> 
					<!-- <a href="#" class="button">Close</a>  -->
				</div> 
			</div> 
			<canvas id="nodeLinkLineArea" width="<%=(minWidth + 13) %>px" height="<%=minHeigth %>">您的浏览器不支持HTML5 CANCAL元素</canvas>
			<% 
			Iterator<Map<String, Object>> iterator = nodeDisInfo.iterator();
			
			for(int icount=0; iterator.hasNext(); icount++) {
				Map<String, Object> picBean = iterator.next();
				int[] nodePoint = (int[])picBean.get("nodePoint");
				int[] nodeDecPoint = (int[])picBean.get("nodeDecPoint");
				String nodeColor = (String)picBean.get("nodeColor");
				
				String nodeName = (String)picBean.get("nodeName");
				int nodeType = (Integer)picBean.get("nodeType");
				String nodeOperatorName = (String)picBean.get("nodeOperatorName");
				String nodeOperatorGropId = (String)picBean.get("nodeOperatorGropId");
				List<String> nodeNotOperatorNameList = (List<String>)picBean.get("nodeNotOperatorNameList");
				List<String> nodeOperatorNameList = (List<String>)picBean.get("nodeOperatorNameList");
				List<String> nodeViewNameList = (List<String>)picBean.get("nodeViewNameList");
				List<String> nodeOperatorGropIdList = (List<String>)picBean.get("nodeOperatorGropIdList");
				boolean isCurrentNode = (Boolean)picBean.get("isCurrentNode");
				
				int w = nodePoint[0];
				int h = nodePoint[1];
				int t = nodePoint[2];
				int l = nodePoint[3];
				
				int x = nodeDecPoint[0];
				int y = nodeDecPoint[1];
			%>
				
				<TABLE class="" cellpadding=0 cellspacing=0 Class=ChartCompany STYLE="POSITION:absolute;Z-INDEX:100;FONT-SIZE:8pt;LETTER-SPACING:-1pt;TOP:<%=t-17 %>px;LEFT:<%=l+1 %>px; height:<%=h %>px;width:<%=w %>px" LANGUAGE=javascript 
					onclick="javascript:popup(event, document.getElementById('oc_divMenuDivision<%=icount%>').innerHTML, <%=t %>, <%=l %>);" >
    				<tr height=15px>
    					<TD VALIGN=TOP style="">
    						<div class="radiusBlock" style="background-color:<%=nodeColor%>;border-color:<%=nodeColor%>;">
    							<B><%=nodeName%></B>
    						</div>
    					</TD>
    				</TR>
    				<TR>
  				<%
  				if (isCurrentNode) {
  				%>
  					<TD VALIGN=TOP align=left style="">
  						<div class="radiusBlockBottom borderRed">
  				<%
  				} else {
  				%>
  					<TD VALIGN=TOP align=left style="">
  						<div class="radiusBlockBottom" style="border-color:<%=nodeColor%>;">
  				<%
  				}
				if (nodeType == 0) {
				%>
					<img src="/mobile/plugin/1/images/iconemp_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16353,user.getLanguage())%>">
				<%
				} else if (nodeType == 1) {
				%>
					<img src="/mobile/plugin/1/images/imgPersonHead_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>">
				<%
				} else if (nodeType == 2) {
				%>
					<img src="/mobile/plugin/1/images/imgPersonHead_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>">
				<%
				}
				
				if (nodeOperatorGropId != null && !"".equals(nodeOperatorGropId)) {
				%>
					<!-- 
					<a href="/workflow/workflow/editoperatorgroup.jsp?isview=1&formid=<%=reqDisplayInfo.getFormid()%>&isbill=<%=reqDisplayInfo.getIsbill()%>&id=<%=nodeOperatorGropId%>"><%=nodeOperatorName %></a>
					 -->
					 <%=nodeOperatorName %>
				<%
				} else {
				%>
					<%=nodeOperatorName %>
				<%
				}
  				%>
  					</div>
  				</TD></TR></TABLE>
  				
  				<DIV id="oc_divMenuDivision<%=icount%>" style="display:none;">
  					<table border="0" cellpadding="0" cellspacing="0">
  						<tr>
  							<td>
  				<%
  				if (nodeType == 0) {
  				%>	
  								<img src="images/iconemp_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16353,user.getLanguage())%>">
  					<%
  					for (Iterator<String> it=nodeOperatorNameList.iterator(); it.hasNext();) {
  						String tempNodeOperatorName = it.next();
  					%>
  								&nbsp;<%=tempNodeOperatorName %>
  					<%
  					}
  					%>
  				<%
  				} else if (nodeType == 1 && requestid != -1) {
				%>
								<img src="images/imgPersonHead_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>">
					<%
  					for (Iterator<String> it=nodeNotOperatorNameList.iterator(); it.hasNext();) {
  						String tempNodeOperatorName = it.next();
  					%>
  								&nbsp;<%=tempNodeOperatorName %>
  					<%
  					}
  					%>
  							</td>
  						</tr>
  						<tr>
  							<td>
								<img src="images/icon_resource_flat_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16355,user.getLanguage())%>">
					<%
  					for (Iterator<String> it=nodeViewNameList.iterator(); it.hasNext();) {
  						String tempNodeOperatorName = it.next();
  					%>
  								&nbsp;<%=tempNodeOperatorName %>
  					<%
  					}
  					%>
  							</td>
  						</tr>
  						<tr>
  							<td>
								<img src="images/iconemp_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16353,user.getLanguage())%>">
					<%
  					for (Iterator<String> it=nodeOperatorNameList.iterator(); it.hasNext();) {
  						String tempNodeOperatorName = it.next();
  					%>
  								&nbsp;<%=tempNodeOperatorName %>
  					<%
  					}
  					%>
								
				<%
  				} else if (nodeType == 1 && requestid == -1) {	
				%>
								<img src="images/iconemp_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16353,user.getLanguage())%>">
					<%
  					for (Iterator<String> it=nodeOperatorNameList.iterator(); it.hasNext();) {
  						String tempNodeOperatorName = it.next();
  					%>
  								&nbsp;<%=tempNodeOperatorName %>
  					<%
  					}
  					%>
				<%
  				} else if (nodeType == 2) {
  				%>
  								<img src="images/imgPersonHead_wev8.gif" title="<%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%>">
  					<%
  					for (Iterator<String> it=nodeOperatorNameList.iterator(); it.hasNext();) {
  						String tempNodeOperatorName = it.next();
  					%>
  								&nbsp;<%=tempNodeOperatorName %>
  					<%
  					}
  					%>
  				<%
  				}
  				%>
  							</td>
  						</tr>
  					</table>
  				</DIV>
     					
  				
			<%
			}
			%>
	</DIV>
</div>
</body>
</html>