<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@ page import="net.sf.json.JSONObject"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>
<%
User user = HrmUserVarify.getUser (request , response) ;
try{
out.clear();
}catch(Exception e) {
}
String rebulidFlag = Util.null2String(request.getParameter("rebulidFlag"));
String modeRightRebuildProcess = Util.null2String(session.getAttribute(rebulidFlag));
int totalCount = 0;
int currentCount = 0;
int isfinish = 0;
JSONObject processObject = new JSONObject();
if(!"".equals(modeRightRebuildProcess)){
	processObject = JSONObject.fromObject(modeRightRebuildProcess);
	totalCount = Util.getIntValue(processObject.getString("totalCount"), 0);
	currentCount = Util.getIntValue(processObject.getString("currentCount"), 0);
	isfinish = Util.getIntValue(processObject.getString("isfinish"), 0);
}
//重构完成，删除进度信息
if(isfinish==1){
	session.removeAttribute(rebulidFlag);
}
String action=Util.null2String(request.getParameter("action"));
if("getRebuildProcess".equalsIgnoreCase(action)){
	out.print(processObject);
	return;
}
%>

<html>
  <head>
	<link type="text/css" rel="Stylesheet" href="/js/jquery/ui/jquery-ui_wev8.css" />
    <script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>
    <script type="text/javascript" src="/js/jquery/ui/jquery-ui-1.7.1.custom_wev8.js"></script>
    <script type="text/javascript" src="/formmode/js/FormmodeUtil_wev8.js"></script>
	<style>
		html,body{
			margin:0px;
			width:100%;
			height:100%;
		}
		#divProgressbar{
			width:300px;
			height:18px;
			float:left;
		}
		#progressdesc{
			position:absolute;
			left:146px;
			font-size:12px;
			font-weight:bold;
			font-family:Microsoft YaHei;
			color:#222222;
			height:20px;
			line-height:20px;
		}
		#successmsg{
			display:none;
			font-size:12px;
			font-family:Microsoft YaHei;
			color:red;
			float:left;
			height:20px;
			line-height:20px;
		}
		.ui-widget-content { border: 1px solid #aaaaaa;}
		.ui-widget-header { border: 1px solid #aaaaaa; background-color: #53A2E0;background-image:none;}
	</style>
	<script type="text/javascript">
	$(function(){
		var currentCount = <%=currentCount%>;
		var totalCount = <%=totalCount%>;
		var showCurrentCount = parseInt(currentCount/totalCount*100);
	    $("#divProgressbar").progressbar({value: showCurrentCount});
	    try{
    		parent.showRebulidProcessDiv();
    	}catch(e){}
	    if(<%=isfinish%>==1){
	    	setTimeout(rebulidSuccessFun, 800);
	    }else{
	    	setTimeout(updateProgressbarValue, 800);
	    }
	});

	function updateProgressbarValue(){
	    var url = "/formmode/setup/ModeRightRebuildProcess.jsp?action=getRebuildProcess&rebulidFlag=<%=rebulidFlag%>";
	    $.ajax({
		    url: url,
		    dataType: 'json',
		    type: 'POST',
		    success: function (res) {
		    	if(res!=null&&res!=""){
		    		var isfinish=res.isfinish;
					var totalCount=res.totalCount;
					var currentCount=res.currentCount;
					var showCurrentCount = parseInt(currentCount/totalCount*100);
					$("#currentCount").html(currentCount);
					$("#totalCount").html(totalCount);
					$("#divProgressbar").progressbar("option", "value", showCurrentCount);
					if(isfinish==1){
						setTimeout(rebulidSuccessFun,800);
					}else{
						setTimeout(updateProgressbarValue, 800);
					}
		    	}
			},
		    error: function(){}
		});
	}
	
	function rebulidSuccessFun(){
		try{
			parent.hideRebulidProcessDiv();
		}catch(e){}
		$("#divProgressbar").hide();
		$("#progressdesc").hide();
		$("#successmsg").show();
	}
    </script>

  </head>
  <body>
  <div id="divProgressbar"></div>
  <div id="progressdesc">
  	<span id="currentCount"><%=currentCount%></span>/<span id="totalCount"><%=totalCount%></span>
  </div>
  <div id="successmsg"><%=SystemEnv.getHtmlLabelName(127096,user.getLanguage()) %></div>
  </body>
</html>