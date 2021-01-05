<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/element/viewCommon.jsp"%>
<%@ include file="common.jsp"%>

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<%
	//元素设置显示的字段
	String planType = (String)valueList.get(nameList.indexOf("planType"));
	String ifBegindate = (String)valueList.get(nameList.indexOf("begindate"));
	String ifEnddate = (String)valueList.get(nameList.indexOf("enddate"));
	String planWeek = (String)valueList.get(nameList.indexOf("planWeek"));	
	String planMonth = (String)valueList.get(nameList.indexOf("planMonth"));
	String planDay = (String)valueList.get(nameList.indexOf("planDay"));
	
	String iframeUrl = "/page/element/plan/planView.jsp?planType="+planType+"&ifBegindate="+ifBegindate+"&ifEnddate="+
	ifEnddate+"&planWeek="+planWeek+"&planMonth="+planMonth+"&planDay="+planDay+"&perpage="+perpage+"&eid="+eid;
%>
<div id="planDiv_<%=eid %>">
	<iframe src="<%=iframeUrl %>" frameborder="0" width="100%" id="planIframe_<%=eid %>"></iframe>
</div>
<script type="text/javascript">
	$(document).ready(function(){
		$("#planDiv_<%=eid %>").css("height",$("#content_view_id_<%=eid %>").height());
		$("#planIframe_<%=eid %>").css("height",$("#content_view_id_<%=eid %>").height()-3);
	});
	function openDetail<%=eid %>(detailid){
		var h = jQuery(window).height()-100;
		var left = ($(window).width()-500)/2;
		var top = ($(window).height()-450)/2+$(document).scrollTop();
		var _divDetail = '<div id="plandetail_<%=eid %>" '+
		'style="width: 500px;height:600px;position:absolute;top:40px;background:#75ACEA;display:none;z-index:1000;">'+
		'<iframe id="detailframe_<%=eid %>" class="scroll" style="width:496px;height:450px;margin:2px"'+
		' src="" scrolling="auto" frameborder="0"></iframe></div>';
		$("#item_<%=eid%>").after(_divDetail);
		jQuery("#detailframe_<%=eid %>").height(h-4).attr("src","/workrelate/plan/data/DetailView.jsp?plandetailid="+detailid+"&fromplan=1&eid=<%=eid%>");
		jQuery("#plandetail_<%=eid %>").height(h).css("left",left).css("top",top).show();
		jQuery("body").css("overflow","hidden");
	}
	function closeDetail<%=eid %>(){
		jQuery("#plandetail_<%=eid %>").remove();
		jQuery("body").css("overflow","");
	}
</script>