
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	String moduleManageDetach = Util.null2String(request.getParameter("moduleManageDetach"));//(模块管理分权-分权管理员专用)

	String selectedids = Util.null2String(request.getParameter("selectedids"));
	String workflowids = Util.null2String(request.getParameter("workflowids"));
	if (selectedids.isEmpty()) {
		selectedids = workflowids;
	}

	String tabid = "0";
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));

	int uid = user.getUID();
	String multiworkflow = null;
	Cookie[] cks = request.getCookies();
	for (int i = 0; i < cks.length; i++) {
	    if (cks[i].getName().equals("mutiworkflow" + uid)) {
	    	multiworkflow = cks[i].getValue();
	        break;
	    }
	}
	if(multiworkflow != null && !multiworkflow.isEmpty()){
		String[] atts = Util.TokenizerString2(multiworkflow, "|");
		tabid = atts[0];
	}
%>
<HTML>
	<HEAD>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<STYLE type=text/css>
			PRE {
				
			}
			
			A {
				COLOR: #000000;
				FONT-WEIGHT: bold;
				TEXT-DECORATION: none
			}
			
			A:hover {
				COLOR: #56275D;
				TEXT-DECORATION: none
			}
		</STYLE>
	</HEAD>
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
							<li class="<%=tabid.equals("0")?"current":"" %>">
								<a id="tabId0" href="javascript:resetbanner(0);"> <%=SystemEnv.getHtmlLabelName(124787,user.getLanguage())%> </a>
							</li>
							<li class="<%=tabid.equals("1")?"current":"" %>">
								<a id="tabId1" href="javascript:resetbanner(1);"> <%=SystemEnv.getHtmlLabelName(18412,user.getLanguage())%><!-- 组合查询 -->
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
				<div class="zDialog_div_content">
					<IFRAME name=frame1 id=frame1 width="100%" onload="update();" height="210px" frameborder=no scrolling=no>
						<%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%>
					</IFRAME>
					<iframe id="frame2" name="frame2" src="MultiSelect.jsp?tabid=<%=tabid%>&selectedids=<%=selectedids%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>" class="flowFrame" frameborder="0" height="330px" width="100%;" scrolling=no></iframe>
				</div>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			jQuery('.e8_box').Tabs({
				getLine:1,
				iframe:"frame1",
				needNotCalHeight:true,
			  	mouldID:"<%=MouldIDConst.getID("workflow")%>",
			  	objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(18499, user.getLanguage())) %>,
				staticOnLoad:true
			});

			function resetbanner(tabid) {
				if (tabid == 1) {
					document.getElementById("frame1").src = "/workflow/workflow/MutiWorkflowBrowser_search.jsp?sqlwhere=<%=xssUtil.put(sqlwhere)%>";
				} else {
					document.getElementById("frame1").src = "/workflow/workflow/MutiWorkflowBrowser_searchByType.jsp?sqlwhere=<%=xssUtil.put(sqlwhere)%>";
				}
			}

			resetbanner(<%=tabid%>);
			
			resizeDialog(document);
			
			
		</script>
	</body>
</html>