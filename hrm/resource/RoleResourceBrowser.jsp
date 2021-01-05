<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-09 [E7 to E8] -->
<%@ page import="org.json.JSONObject"%>
<%
	String sqlwhere=Util.null2String(request.getParameter("sqlwhere"));
	String roleid=Util.null2String(request.getParameter("roleid"));
	String selectids = Util.null2String(request.getParameter("selectids"));
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
						<div id="rightBox" class="e8_rightBox"></div>
					</div>
				</div>
			</div>
			<div class="tab_box">
				<div>
					<!-- 
					<iframe name=frame1 id=frame1 src="/hrm/resource/RoleResourceSearch.jsp?roleid=<%=roleid%>&selectids=<%=selectids%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>" width="100%" height="80px" frameborder=no scrolling=yes>浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</iframe>
					 -->
					<iframe src="/hrm/resource/RoleResourceSelect.jsp?roleid=<%=roleid%>&selectids=<%=selectids%>&sqlwhere=<%=xssUtil.put(sqlwhere)%>" onload="update();" id="frame2" name="frame2" class="flowFrame" frameborder="0" height="455px" width="100%;"></iframe>
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
				iframe:"frame2",
				contentID:"#frame1",
				mouldID:"<%=MouldIDConst.getID("hrm") %>",
				objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(33251, user.getLanguage())+SystemEnv.getHtmlLabelName(20570, user.getLanguage())) %>,
				staticOnLoad:true
			});
		</script>
	</body>
</html>