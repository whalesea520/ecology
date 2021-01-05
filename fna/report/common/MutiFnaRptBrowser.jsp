<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<!-- modified by wcd 2014-07-07 [E7 to E8] -->
<%@ page import="org.json.JSONObject"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<%
Calendar today = Calendar.getInstance();
String currentdate = Util.add0(today.get(Calendar.YEAR), 4) +"-"+
				 Util.add0(today.get(Calendar.MONTH) + 1, 2) +"-"+
				 Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String _guid1 = Util.null2String(request.getParameter("_guid1"));
String check_per = Util.null2String(request.getParameter("selectedids"));
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
					<iframe name=frame1 id=frame1 src="/fna/report/common/MultiFnaRptSearch.jsp?_guid1=<%=_guid1 %>" width="100%" height="180px" frameborder=no scrolling=yes>
						//浏览器不支持嵌入式框架，或被配置为不显示嵌入式框架。</iframe>
					<iframe src="/fna/report/common/MultiFnaRptSelect.jsp?selectids=<%=check_per%>&_guid1=<%=_guid1 %>" onload="update();" id="frame2" name="frame2" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
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
				mouldID:"<%=MouldIDConst.getID("fna") %>",
				objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelNames("18748", user.getLanguage())) %>,
				staticOnLoad:true
			});
		</script>
	</body>
</html>