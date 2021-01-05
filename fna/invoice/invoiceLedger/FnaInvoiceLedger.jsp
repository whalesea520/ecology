<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="org.json.JSONObject"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*" %>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<script type="text/javascript">
jQuery(function(){
    jQuery('.e8_box').Tabs({
        getLine:1,
        contentID:"#divMainInfo",
        iframe:"tabcontentframe",
        mouldID:"<%=MouldIDConst.getID("fna") %>",
        objName:<%=JSONObject.quote(SystemEnv.getHtmlLabelName(131485, user.getLanguage())) %>,
        staticOnLoad:true
    });
});
</script>
<%
boolean canEdit = HrmUserVarify.checkUserRight("FnaInvoiceLedger:settings",user);
if(!canEdit){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
%>
<html>
<head></head>			        
<BODY scroll="no">
	<div class="e8_box demo2">
	<div class="e8_boxhead">
		<div class="div_e8_xtree" id="div_e8_xtree"></div>
        <div class="e8_tablogo" id="e8_tablogo" onclick="mnToggleleft(this);"></div>
		<div class="e8_ultab">
			<div class="e8_navtab" id="e8_navtab">
				<span id="objName"></span>
			</div>
			<div>
			    <ul class="tab_menu">
					<li class="defaultTab">
						<a href="#">
							<%=TimeUtil.getCurrentTimeString() %>
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
	            <iframe src="/fna/invoice/invoiceLedger/FnaInvoiceLedgerInner.jsp" onload="update();" id="tabcontentframe" name="tabcontentframe" 
	            	class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
	        </div>
	    </div>
	</div>     
</body>
<script type="text/javascript">
function mnToggleleft(obj){
	if(window!=null&&window.parent!=null&&window.parent.oTd1!=null&&window.parent.oTd1.style!=null){
		var f = window.parent.oTd1.style.display;
		if(f==null||f==""){
			obj.innerHTML=obj.innerHTML.replace("&lt;&lt;","&gt;&gt;");
			window.parent.oTd1.style.display='none';
		}else{
			obj.innerHTML=obj.innerHTML.replace("&gt;&gt;","&lt;&lt;");
			window.parent.oTd1.style.display='';
		}
	}
}
</script>
</html>

