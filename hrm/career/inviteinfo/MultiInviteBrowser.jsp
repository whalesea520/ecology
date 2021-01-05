
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="org.json.JSONObject"%>
<%
	String resourceids=Util.null2String(request.getParameter("resourceids"));
	String sqlwhere = Util.null2String(request.getParameter("sqlwhere"));
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
					<iframe src="/hrm/career/inviteinfo/MultiSelect.jsp?selectids=<%=resourceids%>" onload="update();" id="frame2" name="frame2" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
				</div>
			</div>
		</div>
		<script type="text/javascript">
			var id = "";
			var name = "";
			function setValue(obj){
				id = obj.id;
				name = obj.name;
				doClose();
			}
			function onCancel(){
				try{
					var dialog = parent.parent.getDialog(parent);
					dialog.close();
				}catch(ex1){}
				doClose();
			}

			function doClose(){
				try{
					var parentWin = parent.parent.getParentWindow(parent);
					parentWin._id = id;
					parentWin._name = name;
					parentWin.closeDialog();
				}catch(ex1){}
			}
			jQuery('.e8_box').Tabs({
				getLine:1,
				iframe:"frame2",
				contentID:"#frame1",
				mouldID:"<%=MouldIDConst.getID("hrm") %>",
				objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelNames("33251,366", user.getLanguage())) %>,
				staticOnLoad:true
			});
		</script>
	</body>
</html>