<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%
	int maintype = Util.getIntValue(request.getParameter("maintype"),0);

	boolean isgoal = weaver.workrelate.util.TransUtil.isgoal();
	boolean isperformance = weaver.workrelate.util.TransUtil.isperformance();
	boolean isplan = weaver.workrelate.util.TransUtil.isplan();
	boolean istask = weaver.workrelate.util.TransUtil.istask();
%>
<div id="topmenu" style="width: 100%;height: 30px;">
	<!-- <div style="width:100%;height: 40px;background: url('/workrelate/images/logo.png') left center no-repeat;background-color: #1d5899;"></div> -->
	<div style="width: 100%;height: 30px;background: #1d5899;">
	<%if(isgoal){ %><div class="toptitle <%if(maintype==1){ %>toptitle_click<%} %>" style="border-left: 0px;" _url="/workrelate/Index.jsp?maintype=1">目标</div><%} %>
	<%if(isplan){ %><div class="toptitle <%if(maintype==3){ %>toptitle_click<%} %>" _url="/workrelate/Index.jsp?maintype=3">报告</div><%} %>
	<%if(istask){ %><div class="toptitle <%if(maintype==4){ %>toptitle_click<%} %>" style="border-right: 0px;" _url="/workrelate/Index.jsp?maintype=4">任务</div><%} %>
	<%if(isperformance){ %><div class="toptitle <%if(maintype==2){ %>toptitle_click<%} %>" _url="/workrelate/Index.jsp?maintype=2">绩效</div><%} %>
	</div>
</div> 
<script type="text/javascript">
var dounload=1;
$(document).ready(function(){
	$("div.toptitle").bind("mouseover",function(){
		$(this).addClass("toptitle_hover");
	}).bind("mouseout",function(){
		$(this).removeClass("toptitle_hover");
	}).bind("click",function(){
		dounload = 0;
		var _url = $(this).attr("_url");
		window.location = _url;
	});
	
	$("a").live("click",function(){dounload=0;});
});

window.onbeforeunload=function(){
	if(dounload==1){
		//显示主题页面的左侧菜单
		showLeftMenu();
	}else{
		dounload = 1;
	}
}
</script>