<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="weaver.templetecheck.ConfigUtil" %>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	//判断只有管理员才有权限
	int userid = user.getUID();
	if(userid!=1) {
		response.sendRedirect("/notice/noright.jsp");
	  return;
	}
// 	String url = "/templetecheck/KBVersionList.jsp?patchtype=sys";
	String url = "/templetecheck/ConfigManager.jsp";
	
	String patchtype = request.getParameter("patchtype");//补丁包类型
	String kbversion  = request.getParameter("kbversion");//补丁包的id
	String type = request.getParameter("type");//跳转类型 是配置详细还是qc明细
	String sysversion = request.getParameter("sysversion");
	String qcnumber = Util.null2String(request.getParameter("qcnumber"));
	
%>
<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("configManager")%>",
        staticOnLoad:true,
        notRefreshIfrm:true,
        objName:"配置文件维护"
    });
    
    var kbversion = "<%=kbversion%>";
    var type = "<%=type%>";
    var patchtype = "<%=patchtype%>";
    var sysversion = "<%=sysversion%>"
    var qcnumber ="<%=qcnumber%>"
    var param = "";
    if(patchtype == "patch") {//KB补丁包
    	param = param + "&kbversion="+kbversion;
    } else if(patchtype == "sys"){
    	param = param + "&sysversion="+sysversion;
    }
    if(type=="qc") {//qc明细
    	param = param + "&qcnumber_fixed="+qcnumber;
    	change("3",param);
    } else if(type=="config"){//配置详细
    	change("2",param);
    }
}); 


function change(type,param) {
	$(".tab_menu").find("li").each(function(){
		$(this).removeClass("current")
	});
	
	if("4" == type) {
		$("#tabcontentframe").attr("src","/templetecheck/ConfigManager.jsp");
		$(".tab_menu").find("li").eq(4).addClass("current");
	} else if("0" == type){
		$("#tabcontentframe").attr("src","/templetecheck/KBVersionList.jsp?patchtype=sys"+param);
		$(".tab_menu").find("li").eq(0).addClass("current");
	} else if("1" == type) {
		$("#tabcontentframe").attr("src","/templetecheck/KBVersionList.jsp?patchtype=patch"+param);
		$(".tab_menu").find("li").eq(1).addClass("current");
	} else if("2" == type) {
		$("#tabcontentframe").attr("src","/templetecheck/KBConfigurationDetail.jsp?1=1"+param);
		$(".tab_menu").find("li").eq(2).addClass("current");
	} else if("3" == type) {
		$("#tabcontentframe").attr("src","/templetecheck/QCDetail.jsp?1=1"+param);	
		$(".tab_menu").find("li").eq(3).addClass("current");
	} 
}
</script>

</head>
<BODY scroll="no">
	<div class="e8_box demo2">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
			<div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
						 <ul class="tab_menu">
					 	<li onclick="javascript:change(0,'')">
					    	<a href="#" onclick="return false;" target="tabcontentframe">
					    		系统版本信息
					    	</a>
					    </li>
					    <li onclick="javascript:change(1,'')">
					    	<a href="#" onclick="return false;" target="tabcontentframe">
					    		补丁包版本信息
					    	</a>
					    </li>
					    <li onclick="javascript:change(2,'')">
					    	<a href="#" onclick="return false;" target="tabcontentframe">
					    		补丁包配置说明
					    	</a>
					    </li>
					    <li onclick="javascript:change(3,'')">
					    	<a href="#" onclick="return false;" target="tabcontentframe">
					    		补丁包QC列表
					    	</a>
					    </li>
					    <li class='current'  onclick="javascript:change(4,'')">
					    	<a href="#" onclick="return false;" target="tabcontentframe">
					    		配置文件维护
					    	</a>
					    </li>
					 </ul>
					<div id="rightBox" class=" e8_rightBox"></div>
				</div>
			</div>
		</div>
		<div class="  tab_box">
			<div>
				<iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
			</div>
		</div>
	</div>
	<style>
		span .searchImg{
		display:none !important;
	}
	</style>
</body>
</html>