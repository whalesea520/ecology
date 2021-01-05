
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23142,user.getLanguage());
String needfav ="1";
String needhelp ="";

String url="";
String navName=SystemEnv.getHtmlLabelName(27714,user.getLanguage());
HashMap kv = (HashMap)pack.packageParams(request, HashMap.class);

String listCur = "",colorCur = "";
String theme =(String)session.getAttribute("SESSION_CURRENT_THEME");
if("ecology8".equals(theme) && session.getAttribute("ColorStyleInfo") != null && !"".equals((String)session.getAttribute("ColorStyleInfo"))){
	url = "/wui/theme/ecology8/page/skinColor.jsp";
	colorCur = "current";
}else{
	url = "/wui/theme/ecology8/page/skinList.jsp";
	listCur = "current";
}

	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

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
    	
        
        <li  class="<%=listCur %>">
        	<a href="/wui/theme/ecology8/page/skinList.jsp" target="tabcontentframe">
        		<%=SystemEnv.getHtmlLabelName(25025,user.getLanguage()) %>
        	</a>
        </li>
        <%if("ecology8".equals(theme)){ %>
        <li class="<%=colorCur %>">
        	<a href="/wui/theme/ecology8/page/skinColor.jsp" target="tabcontentframe">
        		<%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %>
        	</a>
        </li>
        <%} %>

    </ul>
    <div id="rightBox" class="e8_rightBox"></div>
    		</div>
		</div>
	</div>
    
    <div class="tab_box">
        <div>
            <iframe src="<%=url %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
        </div>
    </div>
    
    <div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<table width="100%">
	    <tr><td style="text-align:center;" colspan="3">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="onCancel()">
	    </td></tr>
	</table>
	</div>
</div>
</body>
</html>

<script language="javascript">
jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        staticOnLoad:true,
        mouldID:"<%= MouldIDConst.getID("portal")%>",
        objName:"<%=navName%>"
    });
    
});

function refreshTab(){
	var f = window.parent.oTd1.style.display;
	if (f != null) {
		if(f==''){
			window.parent.oTd1.style.display='none';
		}else{ 
			window.parent.oTd1.style.display='';
			window.parent.wfleftFrame.setHeight();
		}
	}
}

function onCancel(){
	parentDialog.close();
}

</script>