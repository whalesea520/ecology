
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<%
String titlename = SystemEnv.getHtmlLabelName(23142,user.getLanguage());

int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"));

if(!HrmUserVarify.checkUserRight("SystemTemplate:Edit", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

String url="PortalTabs.jsp";
boolean isOpenSoftAndSiteTempate=GCONST.getsystemThemeTemplate().equals("0")?false:true; //是否启用软件模板和网站模板
HashMap kv = (HashMap)pack.packageParams(request, HashMap.class);
String _fromURL = Util.null2String((String)kv.get("_fromURL"));
if("soft".equals(_fromURL)){//软件
	url = "/portal/plugin/homepage/soft2/PortalList.jsp";
}else if("web".equals(_fromURL)){//网站
	url = "/portal/plugin/homepage/web1/PortalList.jsp";
}else if("ecology7".equals(_fromURL)){//ecology7
	url = "/portal/plugin/homepage/ecology7theme/PortalList.jsp";
}else if("ecology8".equals(_fromURL)){//ecology8
	url = "/portal/plugin/homepage/ecology7theme/PortalList.jsp";
}else if("webcustom".equals(_fromURL)){//webcustom
	url = "/page/maint/template/login/List.jsp";
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<link href="/css/Weaver_wev8.css" type=text/css rel=stylesheet>
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
        	<a href="<%="/portal/plugin/homepage/ecology7theme/PortalList.jsp?theme=ecology8" %>" target="tabcontentframe">
        		<%="ECOLOGY8"+SystemEnv.getHtmlLabelName(344,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="<%="/portal/plugin/homepage/ecology7theme/PortalList.jsp?theme=ecology7" %>" target="tabcontentframe">
        		<%="ECOLOGY7"+SystemEnv.getHtmlLabelName(344,user.getLanguage()) %>
        	</a>
        </li>
        <%if(isOpenSoftAndSiteTempate){%>
        <!-- <li>
        	<a href="<%="/portal/plugin/homepage/ecology7theme/PortalList.jsp?theme=soft" %>" target="tabcontentframe">
        		<%=SystemEnv.getHtmlLabelName(20621,user.getLanguage()) %>
        	</a>
        </li>
        <li>
        	<a href="<%="/portal/plugin/homepage/ecology7theme/PortalList.jsp?theme=web" %>" target="tabcontentframe">
        		<%=SystemEnv.getHtmlLabelName(27890,user.getLanguage()) %>
        	</a>
        </li> -->
        <%}%>
        <%
        	String isCustom = new weaver.general.BaseBean().getPropValue("page","portal.custom");
        	if(isCustom.equals("true")){
        %>
          <li>
        	<a href="<%="/page/maint/template/login/List.jsp?theme=webcustom" %>" target="tabcontentframe">
        		<%=SystemEnv.getHtmlLabelName(33809,user.getLanguage()) %>
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
            <iframe src="<%=url+"?theme=ecology8" %>" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;" onload="update()"></iframe>
        </div>
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
        objName:"<%=SystemEnv.getHtmlLabelName(32462,user.getLanguage()) %>"
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