
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="org.json.JSONObject"%>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
</HEAD>
<%
CompanyVirtualComInfo.setTofirstRow();
String dfvirtualtype = "";
if(CompanyVirtualComInfo.next()){
	dfvirtualtype = CompanyVirtualComInfo.getCompanyid();
}
%>
<body scroll="no">
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
			      <%
			      CompanyVirtualComInfo.setTofirstRow();
			      while(CompanyVirtualComInfo.next()){
			      %>
			      <li class="">
		        	<a id="tabId<%=CompanyVirtualComInfo.getCompanyid() %>" href="javascript:resetbanner(<%=CompanyVirtualComInfo.getCompanyid() %>);">
		        		<%=CompanyVirtualComInfo.getVirtualType()%><!-- 按组织结构 --> 
		        	</a>
			      </li>
			      <%} %>
			    </ul>
			    <div id="rightBox" class="e8_rightBox">
			    </div>
			</div>
		</div>
	</div>
	    <div class="tab_box">
        <div>
        	<iframe onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
        </div>
	    </div>
	</div>
<script language=javascript>
 jQuery('.e8_box').Tabs({
		getLine:1,
		iframe:"tabcontentframe",
	  mouldID:"<%=MouldIDConst.getID("hrm") %>",
	  objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(124, user.getLanguage())) %>,
		staticOnLoad:true
	});

	function resetbanner(objid){
	 window.tabcontentframe.location="/hrm/companyvirtual/MutiSubCompanyBrowserTab.jsp?virtualtype="+objid;
	}
	resetbanner(<%=dfvirtualtype%>);
</script>
</body>
</html>