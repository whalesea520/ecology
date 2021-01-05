<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String from=Util.null2String(request.getParameter("from"));
String paraid=Util.null2String(request.getParameter("paraid"));
String wftype=Util.null2String(request.getParameter("wftype"));
String isDialog=Util.null2String(request.getParameter("isdialog"));
String rightStr="3".equals(wftype)?"projTemplateSetting:Maint":"Prj:WorkflowSetting";
if(!HrmUserVarify.checkUserRight(rightStr, user)){
	response.sendRedirect("/notice/noright.jsp");	
	return;
}
String qrystr=request.getQueryString();
%>
<HTML><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
<SCRIPT language="javascript" src="/proj/js/common_wev8.js"></script>
<script type="text/javascript">
var parentWin;
if("<%=isDialog %>"=="1"){
	parentWin = parent.getParentWindow(window);
}

</script>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("proj")%>",
        staticOnLoad:true
    });
}); 
</script>

<%
	String url = "/proj/conf/prjwfadd.jsp?isdialog=0&"+qrystr;
%>

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
		        <li class="current">
					<a target="tabcontentframe" href="<%=url %>"><%=SystemEnv.getHtmlLabelNames("1361",user.getLanguage())%></a>
				</li>
				<li class="">
					<a target="tabcontentframe" href="/proj/conf/prjwffieldset.jsp?<%=qrystr %>"><%=SystemEnv.getHtmlLabelNames("33084",user.getLanguage())%></a>
				</li>
				<li class="">
					<a target="tabcontentframe" href="/proj/conf/prjwfactionset.jsp?<%=qrystr %>"><%=SystemEnv.getHtmlLabelNames("33085",user.getLanguage())%></a>
				</li>
		    </ul>
	    <div id="rightBox" class="e8_rightBox">
	    </div>
	    </div>
	    </div>
	    </div>
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>  
<%if("1".equals(isDialog)){ %>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout>	
	<wea:group context="">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>
</div>
<script type="text/javascript">
jQuery(document).ready(function(){
	resizeDialog(document);
});
</script>
<%} %>  	
	
<script type="text/javascript">	
$(function(){
	var wftype='<%=wftype %>';
	if(wftype==1){
		setTabObjName("<%=SystemEnv.getHtmlLabelName(81937,user.getLanguage()) %>");
	}else if(wftype==2){
		setTabObjName("<%=SystemEnv.getHtmlLabelName(81938,user.getLanguage()) %>");
	}else if(wftype==3){
		setTabObjName("<%=SystemEnv.getHtmlLabelName(18374,user.getLanguage()) %>");
	}
	
	
});
</script>   
</BODY>
</HTML>
