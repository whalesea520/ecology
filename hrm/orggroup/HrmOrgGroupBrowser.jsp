
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<!-- Modified by wcd 2014-11-13 [E7 to E8] -->
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
	String check_per=Util.null2String(request.getParameter("selectedids"));
	if(check_per.length()==0)check_per = Util.null2String(request.getParameter("orgGroupIds"));
%>
<HTML>
	<HEAD>
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<STYLE type=text/css>
			PRE {}
			A {
				COLOR:#000000;FONT-WEIGHT: bold; TEXT-DECORATION: none
			}
			A:hover {
				COLOR:#56275D;TEXT-DECORATION: none
			}
		</STYLE>
	</HEAD>
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
						<div id="rightBox" class="e8_rightBox"></div>
					</div>
				</div>
			</div>
			<div class="tab_box">
				<div>
					<iframe src="/hrm/orggroup/HrmOrgGroupBrowserSearch.jsp?sqlwhere=<%=xssUtil.put(sqlwhere)%>" id="frame1" name="frame1" width="100%" height="120px" frameborder="no" scrolling="no"><%=SystemEnv.getHtmlLabelName(15017, user.getLanguage())%></iframe>
					<iframe src="/hrm/orggroup/HrmOrgGroupBrowserSelect.jsp?selectids=<%=check_per%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>" onload="update();" id="frame2" name="frame2" class="flowFrame" frameborder="0" height="100%" style="min-height:360px" width="100%;"></iframe>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			function onCancel(){
				try{
					var dialog = parent.getDialog(window);	
					dialog.close();
				}catch(ex1){}
				doClose();
			}

			function doClose(){
				try{
					var parentWin = parent.parent.getParentWindow(window);
					parentWin.closeDialog();
				}catch(ex1){}
			}
			jQuery('.e8_box').Tabs({
				getLine:1,
				iframe:"frame1",
				needNotCalHeight:true,
				//contentID:"#frame1",
				mouldID:"<%=MouldIDConst.getID("resource") %>",
				objName:<%=org.json.JSONObject.quote(SystemEnv.getHtmlLabelNames("33251,24002", user.getLanguage())) %>,
				staticOnLoad:true
			});
		</script>
	</BODY>
</HTML>