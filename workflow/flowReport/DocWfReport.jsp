
<%@ page language="java" contentType="text/html; charset=UTF-8"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="shareRights" class="weaver.workflow.report.UserShareRights" scope="page"/>
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />
<HTML>
	<HEAD>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />

<%
String userRights = ReportAuthorization.getUserRights("-11", user);//得到用户查看范围
if(userRights.equals("-100")){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>

		<script type="text/javascript">
			jQuery(function(){
			    jQuery('.e8_box').Tabs({
			        getLine:1,
			        mouldID:"<%=MouldIDConst.getID("workflow")%>",
			        iframe:"tabcontentframe",
			        staticOnLoad:true,
			        objName:"<%=SystemEnv.getHtmlLabelName(21899,user.getLanguage())%>"
			    });
			});
			
			function settab2(){
				$("#tabcontentframe").attr("src","/workflow/flowReport/DocWfReportShow.jsp?objType=2");
			}
			function settab1(){
				$("#tabcontentframe").attr("src","/workflow/flowReport/DocWfReportShow.jsp?objType=1");
			}
			function settab3(){
				$("#tabcontentframe").attr("src","/workflow/flowReport/DocWfReportShow.jsp?objType=3");
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
							<li id="tab_1" class="current">
								<a onclick="settab2()" target="tabcontentframe">
									<%=SystemEnv.getHtmlLabelName(1015,user.getLanguage())%>
								</a>
							</li>
							<li id="tab_2">
								<a onclick="settab1()" target="tabcontentframe">
									<%=SystemEnv.getHtmlLabelName(124826,user.getLanguage())%>
								</a>
							</li>
							<li id="tab_3">
								<a onclick="settab3()" target="tabcontentframe">
									<%=SystemEnv.getHtmlLabelName(124827,user.getLanguage())%>
								</a>
							</li>
						</ul>
						<div id="rightBox" class="e8_rightBox">
						</div>
					</div>
				</div>
			</div>
			<div class="tab_box">
				<div>
					<iframe src="/workflow/flowReport/DocWfReportShow.jsp" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
				</div>
			</div>

		</div>
	</body>
</html>