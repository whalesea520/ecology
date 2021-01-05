
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rsExtend" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<html>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";
String needfav ="1";
String needhelp ="";
%>
<%
	String assortmenttype = Util.null2String(request.getParameter("ptype"));
	if(assortmenttype.equals(""))
		assortmenttype = SystemEnv.getHtmlLabelName(332,user.getLanguage());
	String assortmentid = Util.null2String(request.getParameter("assortmentid"));
	String url = "/lgc/search/LgcProductListInner.jsp";
	String dataform = "";
	if(!assortmentid.equals(""))
	{
		url = url+"?assortmentid="+assortmentid+"&assortmenttype="+assortmenttype;
		dataform = "?assortmentid="+assortmentid+"&assortmenttype="+assortmenttype;
	}
%>
<head>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>
</head>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<body scroll="no">
	<div class="e8_box demo2" id="rightContent">
		<div class="e8_boxhead">
			<div class="div_e8_xtree" id="div_e8_xtree"></div>
	        <div class="e8_tablogo" id="e8_tablogo"></div>
			<div class="e8_ultab">
				<div class="e8_navtab" id="e8_navtab">
					<span id="objName"></span>
				</div>
				<div>
					<ul class="tab_menu">
						<li class="e8_tree" onclick="javascript:refreshTab();">
							<a onclick="javascript:refreshTab();"><%=SystemEnv.getHtmlLabelName(455,user.getLanguage()) %></a>
						</li>
						<li class="current" >
							<a href="" target="tabcontentframe" _datetype="list"><%=SystemEnv.getHtmlLabelName(15108,user.getLanguage()) %></a>
						</li>
						<li>
							<a href="" target="tabcontentframe" _datetype="type"><%=SystemEnv.getHtmlLabelName(32655,user.getLanguage()) %></a>
						</li>
					</ul>
					<div id="rightBox" class="e8_rightBox"></div>
				</div>
			</div>
		</div>
		
		<div class="tab_box">
			<iframe src="<%=url %>" onload="update()" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
			
		<div>
	</div>	
</body>
</html>

<script language="javascript">
jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("customer")%>",
		staticOnLoad:true,
		objName:"<%=SystemEnv.getHtmlLabelName(20348,user.getLanguage())%>"
    });
    attachUrl();
});

function attachUrl(){
	
	$("a[target='tabcontentframe']").each(function(){
		
		var datetype=$(this).attr("_datetype");
		
		if("list" == datetype){
			$(this).attr("href","<%=url%>");
		}
		
		if("type" == datetype){
			$(this).attr("href","/lgc/maintenance/LgcAssortment.jsp<%=dataform%>");
		}
		
	});
	$("[name='tabcontentframe']").attr("src",$("a[target='tabcontentframe']:eq(0)").attr("href"));
}

function refreshTab(){
	var f = window.parent.oTd1.style.display;
	if (f != null) {
		if(f==''){
			window.parent.oTd1.style.display='none';
		}else{ 
			window.parent.oTd1.style.display='';
		}
	}
}
function refreshTreeMain(id,parentid,needrefresh)
{
	parent.refreshTreeMain(id,parentid,needrefresh);
}

function refreshTreeNum(ids,isadd)
{
	parent.refreshTreeNum(ids,isadd);
}
</script>