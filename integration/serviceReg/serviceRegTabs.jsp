
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.page.element.ElementBaseCominfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="scc" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(23142,user.getLanguage());
String needfav ="1";
String needhelp ="";



String url="";
String navName="";
HashMap kv = (HashMap)pack.packageParams(request, HashMap.class);
String _fromURL = Util.null2String((String)kv.get("_fromURL"));
String showtype = Util.null2String((String)kv.get("showtype"));
String hpid = Util.null2String((String)kv.get("hpid"));

if("1".equals(_fromURL)){//数据源
	url = "/integration/serviceReg/serviceRegMainRight.jsp?showtype=1";
	if(!"".equals(showtype)&&!"".equals(hpid)){
		if("1".equals(showtype))url = "/integration/dateSource/dataDMLlist.jsp?hpid="+hpid;
		else if("2".equals(showtype))url ="/integration/dateSource/dataWebservicelist.jsp?hpid="+hpid;
		else if("3".equals(showtype))url ="/integration/dateSource/dataSAPlist.jsp?hpid="+hpid;
	}
}else if("2".equals(_fromURL)){//注册服务
	url = "/integration/serviceReg/serviceRegMainRight.jsp?showtype=2";
	if(!"".equals(showtype)&&!"".equals(hpid))
		url = "/integration/serviceReg/serviceReg_"+showtype+"list.jsp?hpid="+hpid;
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
        <li class="e8_tree">
        	<a onclick="javascript:refreshTab();">SAP集成</a>
        </li>
        <%
        if("1".equals(_fromURL)){//数据源 %>
        <%navName=SystemEnv.getHtmlLabelName(18076,user.getLanguage());
			if(!"".equals(showtype)&&!"".equals(hpid))
				navName=SystemEnv.getHtmlLabelName(18076,user.getLanguage()); 
		%>
        <li class="defaultTab">
			<a target="tabcontentframe"><%=TimeUtil.getCurrentTimeString() %></a>
		</li>
        <%}else if("2".equals(_fromURL)){//注册服务 %>
     	<%navName=SystemEnv.getHtmlLabelName(30624,user.getLanguage()); 
			if(!"".equals(showtype)&&!"".equals(hpid))
				navName=SystemEnv.getHtmlLabelName(30624,user.getLanguage()); 
		%>
        <li class="defaultTab">
			<a target="tabcontentframe"><%=TimeUtil.getCurrentTimeString() %></a>
		</li>
        <%}%>
    </ul>
    <div id="rightBox" class="e8_rightBox"></div>
    		</div>
		</div>
	</div>
    
    <div class="tab_box">
        <div>
            <iframe src="<%=url %>" onload="update();" id="tabcontentframe" name="tabcontentframe" frameborder="0" height="100%" width="100%;"></iframe>
        </div>
    </div>
</div>
</body>
</html>

<script language="javascript">
window.e8ShowAllways = true;
jQuery(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        staticOnLoad:true,
        mouldID:"<%= MouldIDConst.getID("integration")%>",
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
</script>