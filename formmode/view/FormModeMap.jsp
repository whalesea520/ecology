<%@page import="java.net.URLEncoder"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.workflow.form.FormManager"%>
<%@ page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Map.Entry" %>
<%@ page import="weaver.formmode.interfaces.ModeManageMenu" %>
<%@ page import="weaver.formmode.view.ResolveFormMode"%>
<%@page import="weaver.common.util.string.StringUtil"%>
<%@ page import="weaver.formmode.setup.ExpandBaseRightInfo" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResolveFormMode" class="weaver.formmode.view.ResolveFormMode" scope="page" />
<jsp:useBean id="ModeRightInfo" class="weaver.formmode.setup.ModeRightInfo" scope="page" />
<jsp:useBean id="ModeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="ModeViewLog" class="weaver.formmode.view.ModeViewLog" scope="page"/>
<jsp:useBean id="FormModeRightInfo" class="weaver.formmode.search.FormModeRightInfo" scope="page" />
<jsp:useBean id="ExpandInfoService" class="weaver.formmode.service.ExpandInfoService" scope="page" />
<jsp:useBean id="FieldInfo" class="weaver.formmode.data.FieldInfo" scope="page" />
<jsp:useBean id="modeShareManager" class="weaver.formmode.view.ModeShareManager" scope="page" />
<jsp:useBean id="expandBaseRightInfo" class="weaver.formmode.setup.ExpandBaseRightInfo" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String fieldid = Util.null2String(request.getParameter("fieldid"));
String maptype = Util.null2String(request.getParameter("maptype"));

String queryString = request.getQueryString();
//处理特殊值
String iframeurl = "";
String tabname = "";
if(maptype.equals("D")){ 
	iframeurl = "/formmode/view/FormModeMapShowIframe.jsp?"+queryString;
	tabname = "地址显示" ;//获取地址
}else if(maptype.equals("customsearch")){
	iframeurl = "/formmode/view/FormModeMapPageIframe.jsp?"+queryString;
	tabname = "地址显示" ;//获取地址
}else{
	iframeurl = "/formmode/view/FormModeMapIframe.jsp?"+queryString;
	tabname = SystemEnv.getHtmlLabelName(126782, user.getLanguage()) ;//获取地址
}

%>
<!DOCTYPE html>
<HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        staticOnLoad:true,
        mouldID:"<%= MouldIDConst.getID("formmode")%>",
        objName:"<%=tabname%>"
    });
 });
</script>
</head>
<BODY scroll="no">
	<input type="hidden" id="fieldid" name="fieldid" value="<%=fieldid %>">
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
				    <li class="current">
				    	<a href="javascript:void(0)"  url="<%=iframeurl%>" onclick="showTabIframe(this,0,0)" class="a_tabcontentframe" >
							<%=tabname %>
						</a>
					</li>
			    </ul>
	      <div id="rightBox" class="e8_rightBox">
	    </div>
	   </div>
	  </div>
	</div>	 
	    <div class="tab_box">
	        <div id="iframeDiv">
	            <iframe src="<%=iframeurl%>" id="tabcontentframe" name="tabcontentframe" onload="update()" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>
<script language="javascript">
	$(function(){
		$('.a_tabcontentframe').hover(function(){
			$('.a_tabcontentframe').attr('title', "<%=tabname%>");
		});
	});
	
	function showTabIframe(obj,index,innerTabCount){
		var url = $(obj).attr("url");
		var name = $(obj).text();
		if(index==0&&innerTabCount>0){
			name = "<%=tabname%>";
		}
		var tabcontentframe;
		tabcontentframe = $("#tabcontentframe");
		tabcontentframe.attr("src",url);
		if(url.indexOf("http:")==0||url.indexOf("https:")==0){
			$("#rightBox").hide();
		}else{
			$("#rightBox").show();
		}
		$('.e8_box').Tabs({
	        getLine:1,
	        iframe:"tabcontentframe",
	        staticOnLoad:true,
	        mouldID:"formmodeMap",
	        objName:name
	    });
	}
</script>
<script type="text/javascript">
function closeWinAFrsh(addressinfo,type){
try{
// var parentWin = parent.parent.getParentWindow(window);
// 	if(type==2){
// 		jQuery("#field<%=fieldid%>",parentWin).val(addressinfo);
// 		if(jQuery("#field<%=fieldid%>span",parentWin)){
// 			if(jQuery("#field<%=fieldid%>span",parentWin).attr("isedit")!=1){
// 				jQuery("#field<%=fieldid%>span",parentWin).html(addressinfo);
// 			}
// 		}
// 	}else{
// 		var temp = jQuery("#field<%=fieldid%>",parentWin).val();
// 		jQuery("#field<%=fieldid%>",parentWin).val(temp+addressinfo);
// 		if(jQuery("#field<%=fieldid%>span",parentWin)){
// 			if(jQuery("#field<%=fieldid%>span",parentWin).attr("isedit")!=1){
// 				jQuery("#field<%=fieldid%>span",parentWin).html(temp+addressinfo);
// 			}
// 		}
// 	}
	var dialog = parent.parent.getDialog(parent);
	var returnjson = {address:addressinfo,typestr:type};
	dialog.callbackfun(returnjson);
	dialog.close();
	}catch(e){}
}
</script>

