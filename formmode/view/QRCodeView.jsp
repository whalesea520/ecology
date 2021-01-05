
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.general.Util" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
//获取modeid
String modeId = request.getParameter("modeId");
String formId = request.getParameter("formId");
String customid = request.getParameter("customid");
String billid = request.getParameter("billid");

String url = "/formmode/view/QRCodeViewIframe.jsp?modeId="+modeId+"&formId="+formId+"&customid="+customid+"&billid="+billid;


%>
<!DOCTYPE html><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("formmode")%>",
        staticOnLoad:true,
        objName:"<%=SystemEnv.getHtmlLabelName(30184 ,user.getLanguage()) %>" //二维码
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
					<span id="objName" ></span>
				</div>
				<div>	
				    <ul class="tab_menu">
					    <li class="current">
							<a href="<%=url %>" target="tabcontentframe" class="a_tabcontentframe">
							</a>
						</li>
				    </ul>
		      		<div id="rightBox" class="e8_rightBox"></div>
	   			</div>
	  		</div>
		</div>	 
	    <div class="tab_box">
	        <div>
	            <iframe src="<%=url %>" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;" onload="update()"></iframe>
	        </div>
	    </div>
	</div>     
</body>
</html>
<script language="javascript">
	$(function(){
		$('.a_tabcontentframe').hover(function(){
			$('.a_tabcontentframe').attr('title', "");
		});
	});
</script>
