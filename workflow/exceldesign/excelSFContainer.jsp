
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<%
	String excelid = Util.null2String(request.getParameter("excelid"));
	int bxsize = Util.getIntValue(Util.null2String(request.getParameter("bxsize")),1);
	boolean isEditMoreContent = "true".equals(Util.null2String(request.getParameter("isEditMoreContent"))) ? true : false;
%>
<HTML><HEAD>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			$('.e8_box').Tabs({
				getLine : 1,
				iframe : "tabcontentframe",
				mouldID:"<%= MouldIDConst.getID("workflow")%>",
				staticOnLoad:true,
				objName:"<%=SystemEnv.getHtmlLabelName(607, user.getLanguage())%>"
			});
			
			$(".tab_menu li a").click(function(){
				//alert($('#tabcontentframe').contents().find(".zd_btn_submit").val());
				$("#objName").text($(this).text());
				$('#tabcontentframe')[0].contentWindow.changeTab($(this).attr("target"));
			});
		});
		
	</script>
</HEAD>
<BODY>
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
					<li class="current" ><a target="number"><%=SystemEnv.getHtmlLabelName(607, user.getLanguage())%></a></li>
					<%if(!isEditMoreContent){ %>
						<li class="" ><a target="align"><%=SystemEnv.getHtmlLabelName(127996, user.getLanguage())%></a></li>
					<%} %>
					<li class="" ><a target="font"><%=SystemEnv.getHtmlLabelName(16189, user.getLanguage())%></a></li>
					<%if(!isEditMoreContent){ %>
						<li class="" ><a target="border"><%=SystemEnv.getHtmlLabelName(128028, user.getLanguage())%></a></li>
					<%} %>
					<li class="" ><a target="bgfill"><%=SystemEnv.getHtmlLabelName(128030, user.getLanguage())%></a></li>
				</ul>
				<div id="rightBox" class="e8_rightBox"></div>
			</div>
		</div>
	</div>
	<div class="tab_box"><div>
	<iframe src="/workflow/exceldesign/excelSetFormat.jsp?excelid=<%=excelid %>&bxsize=<%=bxsize %>" onload="update();" id="tabcontentframe" name="tabcontentframe" class="flowFrame" frameborder="0" height="100%" width="100%;"></iframe>
</div> 
</BODY>
</HTML>
