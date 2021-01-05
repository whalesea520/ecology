
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*,weaver.hrm.common.*,weaver.general.MouldIDConst" %>
<%@ include file="/systeminfo/nlinit.jsp" %>
<!-- Added by wcd 2014-12-18 -->
<jsp:useBean id="pack" class="weaver.general.ParameterPackage" scope="page"/>
<%
	HashMap<String,String> kv = (HashMap<String,String>)pack.packageParams(request, HashMap.class);
	String fromUrl = Tools.vString(kv.get("fromUrl"));
	int languageid = Tools.parseToInt(kv.get("languageid"),7);
	String cmd = Tools.vString(kv.get("cmd"));
	String id = Tools.vString(kv.get("id"));
	String mouldid = "resource";
%>
<HTML>
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
		function refreshTab(){
			jQuery('.flowMenusTd',parent.document).toggle();
			jQuery('.leftTypeSearch',parent.document).toggle();
		} 
		</script>
		<%
			String title = "";
			String url = "";
			if("forgotPassword".equals(fromUrl)){
				title = SystemEnv.getHtmlLabelName(83510, languageid);
				url = "/hrm/password/forgotPassword.jsp?languageid="+languageid;
			} else if ("resetPassword".equals(fromUrl)){
				title = SystemEnv.getHtmlLabelName(31479, languageid);
				String loginid = Tools.vString(kv.get("loginid"));
				url = "/hrm/password/resetPassword.jsp?loginid="+loginid;
			} else if("hrmResourcePassword".equals(fromUrl)){
				title = SystemEnv.getHtmlLabelName(17993, languageid);
				String redirectFile = Tools.vString(kv.get("RedirectFile"));
				String canpass = Tools.vString(kv.get("canpass"));
				String showClose = Tools.vString(kv.get("showClose"));
				url = "/hrm/resource/HrmResourcePassword.jsp?isdialog=1&frompage=/login/RemindLogin.jsp&canpass="+canpass+"&RedirectFile="+redirectFile+"&showClose="+showClose;
			}
		%>
		<script type="text/javascript">
			jQuery(function(){
				jQuery('.e8_box').Tabs({
					getLine:1,
					iframe:"tabcontentframe",
					mouldID:"<%=MouldIDConst.getID(mouldid)%>",
					staticOnLoad:true,
					objName:"<%=title%>"
				});
			});
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
						<ul class="tab_menu"></ul>
						<div id="rightBox" class="e8_rightBox"></div>
					</div>
				</div>
			</div>
			<div class="tab_box">
				<div>
					<iframe src="<%=url %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
				</div>
			</div>
		</div>
	</body>
</html>

