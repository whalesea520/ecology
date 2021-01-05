
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.company.SubCompanyComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util,
				 weaver.hrm.common.*,
                 weaver.general.GCONST" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
    String CustomerID = Util.null2String(request.getParameter("CustomerID")); //
	ShowTab tab = new ShowTab(rs,user);
	String mouldid = "customer";
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
			String url = "/CRM/data/CRMBusinessInfo.jsp?CustomerID="+CustomerID;
			
		%>
		<script type="text/javascript">
			jQuery(function(){
				jQuery('.e8_box').Tabs({
					getLine:1,
					iframe:"tabcontentframe",
					mouldID:"<%=MouldIDConst.getID(mouldid)%>",
					staticOnLoad:true,
					objName:"<%=SystemEnv.getHtmlLabelName(130760,user.getLanguage())%>"
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
						<ul class="tab_menu">
						<%
							tab.add(new TabLi("/CRM/data/CRMBusinessInfo.jsp?CustomerID="+CustomerID+"&isfromCrmTab=true",SystemEnv.getHtmlLabelName(130760,user.getLanguage())));
							tab.add(new TabLi("/CRM/data/CRMBusinessInfoLog.jsp?CustomerID="+CustomerID,SystemEnv.getHtmlLabelName(83,user.getLanguage())));
							out.println(tab.show());
						%>
			
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
		</div>
	</body>
</html>

