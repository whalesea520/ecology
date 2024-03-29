
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%
String carName = SystemEnv.getHtmlLabelNames("126428,83476",user.getLanguage());
String carDesc = SystemEnv.getHtmlLabelNames("126428,83476",user.getLanguage());
String id = Util.null2String(request.getParameter("id"));

String url = "/cpt/car/UseCarWorkflowSetAdd.jsp?id="+id;
%>
<!DOCTYPE html><HEAD>
<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
<link type="text/css" href="/js/tabs/css/e8tabs1_wev8.css" rel="stylesheet" />
<link rel="stylesheet" href="/css/ecology8/request/searchInput_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/searchInput_wev8.js"></script>

<link rel="stylesheet" href="/css/ecology8/request/seachBody_wev8.css" type="text/css" />
<link rel="stylesheet" href="/css/ecology8/request/hoverBtn_wev8.css" type="text/css" />
<script type="text/javascript" src="/js/ecology8/request/hoverBtn_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/request/titleCommon_wev8.js"></script>

<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>

<script type="text/javascript">
$(function(){
    $('.e8_box').Tabs({
        getLine:1,
        iframe:"tabcontentframe",
        mouldID:"<%= MouldIDConst.getID("workflow")%>",
        staticOnLoad:true,
        objName:"<%=carName%>"
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
				    <li class="current">
						<a href="<%=url %>" target="tabcontentframe">
							<%=carDesc %>
						</a>
					</li>
					<%if (!"".equals(id)) { %>
						<li class="">
							<a href="javascript:void(0)" url="/cpt/car/CarInfoRelateMode.jsp?id=<%=id %>" onclick="showTabIframe(this,1)" class="a_tabcontentframe" >
								<%=SystemEnv.getHtmlLabelName(33084,user.getLanguage())%><!-- 字段对应 -->
							</a>
						</li>
						<!-- <li class="">
							<a href="javascript:void(0)" url="xx" onclick="showTabIframe(this,1)" class="a_tabcontentframe" >
								动作设置
							</a>
						</li> -->
					<%} %>
			    </ul>
	      <div id="rightBox" class="e8_rightBox">
	    </div>
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
			$('.a_tabcontentframe').attr('title', "<%=carDesc%>");
		});
	});
	
	function showTabIframe(obj,index,innerTabCount){
		var url = $(obj).attr("url");
		var name = $(obj).text();
		if(index==0&&innerTabCount>0){
			name = "";
		}
		var tabcontentframe;
		tabcontentframe = $("#tabcontentframe");
		tabcontentframe.attr("src",url);
		if(url.indexOf("http:")==0||url.indexOf("https:")==0){
			$("#rightBox").hide();
		}else{
			$("#rightBox").show();
		}
		$('.e8_box').Tabs({
	        getLine:1,
	        iframe:"tabcontentframe",
	        staticOnLoad:true,
	        mouldID:"<%= MouldIDConst.getID("workflow")%>",
	        objName:name
	    });
	}
</script>
<script type="text/javascript">
function closeWinAFrsh(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDlgARfsh();
}
</script>

