<%@page import="weaver.servicefiles.DataSourceXML"%>
<%@page import="weaver.formmode.virtualform.VirtualFormHandler"%>
<%@ page import="weaver.join.news.*"%>
<%@ page import="java.text.*, java.util.*" %>
<%@ include file="/page/element/viewCommon.jsp"%>
<%@ include file="common.jsp"%>
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />

<!-- 判断元素是否可以独立显示，引入样式 -->
<%
	String queryString = request.getQueryString() == null ? "": ("&"+request.getQueryString());
	String indie = Util.null2String(request.getParameter("indie"), "false");
	if ("true".equals(indie)) {
%>
		<%@ include file="/hrm/resource/simpleHrmResource_wev8.jsp" %>
		<%@ include file="/homepage/HpElementCss.jsp" %>
<%	} %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
if(perpage<=0){
	rs_Setting.executeSql("select perpage from hpElementSettingDetail where eid=6156");
	if(rs_Setting.next()){
		perpage = rs_Setting.getInt("perpage");
	}
}
%>
<script type="text/javascript" src="/js/jquery/jquery.scrollTo_wev8.js"></script>
<script type="text/javascript">
function backMarqueeDiv8(eid)
{
	$(eid).scrollTo( {top:'0px',left:($(eid).get(0).scrollLeft - 100 + 'px')}, 500 );
}

function nextMarqueeDiv8(eid)
{
	$(eid).scrollTo( {top:'0px',left:($(eid).get(0).scrollLeft + 100 + 'px')}, 500 );
}
</script>
<style type="text/css" rel="STYLESHEET">
.picturebackhp 
{
    width: 18px;
    height: 32px;
    float:left;
    background: transparent url(/page/element/Picture/resource/image/scroll_left_wev8.gif) no-repeat 0 0;
}
.picturenexthp 
{
    width: 18px;
    height: 32px;
    float:left;
    background: transparent url(/page/element/Picture/resource/image/scroll_right_wev8.gif) no-repeat 0 0;
}
</style>
<%
rs1.executeSql("select * from formmodeelement where eid in("+eid+") order by disorder");
String display ="none";
if(rs1.getCounts()>1){
	display = "";
}
int sumLength = 0;
String firstSearchId="";
%>
<div id="titleContainer_<%=eid%>"  style="border:0px;width:100%;overflow: hidden;position: relative;display:<%=display %>">

<div id="tabnavprev_<%=eid%>" style="cursor:hand;position:relative;float:left;left:-5px;top:-6px;" class="picturebackhp" onclick="backMarqueeDiv8('#tabContainer_<%=eid%>');">&nbsp;</div>

<div id="tabContainer_<%=eid%>" class='tab2' style="width:100%;overflow:hidden;display:none;float:left;">
<table height='32px' width="<%=89*rs1.getCounts()%>" cellspacing='0' cellpadding='0' border='0' style="table-layout:fixed;">
	<tr id="tr_<%=eid%>">
	<%
	while(rs1.next()){
		String searchtitle = Util.null2String(rs1.getString("searchtitle"));
		String id = Util.null2String(rs1.getString("id"));
		int isshowunread = Util.getIntValue(Util.null2String(rs1.getString("isshowunread")),0);
		if(firstSearchId.equals("")){
			firstSearchId=id;
		}
		int length = 89;
	 %>
		<td title="<%=Util.toHtml2((searchtitle).replaceAll("&","&amp;")) %>" class="tab2unselected" id="td_<%=id %>" 
		style="word-wrap:break-word;vertical-align:middle;padding-top:0px" 
		onclick="loadContentFormMode<%=eid %>('<%=eid %>','<%=id %>',this)" >
		<span class="ellipsis">
		<%=Util.getByteNumString(Util.toHtml2((searchtitle).replaceAll("&","&amp;")),10) %>
		</span>
		</td>
		<%
		sumLength += length;
		}
		sumLength = sumLength + 36;
		 %>
	</tr>
</table>
</div>
<script>
  var bgitem='';
  bgitem=$("#tabContainer_<%=eid%>").css("background-image");
  if(bgitem!=='' && bgitem!=='none'){
   $("#titleContainer_<%=eid%>").css("background-image",bgitem);
  }
</script>
<div id="tabnavnext_<%=eid%>" style="cursor:hand;position:relative;float:right;right:0;top:-8px;" class="picturenexthp" onclick="nextMarqueeDiv8('#tabContainer_<%=eid%>');">&nbsp;</div>
</div>
<div style="padding-top: 2px;" id="listContainer_<%=eid%>"></div>
<style>
/*CustomSearch ProgressBar*/
.csProgressBar{ 
	position: relative;
	width: 100px;
	border: 1px solid #eee; 
	padding: 1px; 
} 
.csProgressBar div{ 
	display: block; 
	position: relative;
	height: 18px;
	background-color: #99b433;
}
.csProgressBar div span{ 
	position: absolute; 
	width: 100px;
	text-align: center; 
	font: 10px Verdana;
	line-height: 18px;
	color: #000;
}
.csProgressBarGold div{
	background-color: #e3a21a;
}
.csProgressBarRed div{
	background-color: #da532c;
}
</style>
<script type="text/javascript">
function loadContentFormMode<%=eid%>(eid,searchid,tdobj){
	jQuery("#tr_<%=eid%>").find("td").each(function(i,val){
		if(jQuery(val).hasClass("tab2selected")){
			jQuery(val).removeClass("tab2selected");
			jQuery(val).addClass("tab2unselected");
		}
	})
	jQuery(tdobj).addClass("tab2selected");
	$.ajax({
		url: "/page/element/FormModeCustomSearch/ReportResultData.jsp?r="+Math.random() + "<%=queryString%>",
		data: {eid:"<%=eid%>",linkmode:"<%=linkmode%>",perpage:"<%=perpage%>",searchid:searchid},
		success: function(d){
			$("#listContainer_<%=eid%>").html(d);
		}
	});

}

$(function(){
	loadContentFormMode<%=eid%>('<%=eid%>','<%=firstSearchId%>',jQuery("#td_<%=firstSearchId%>"));
});
</script>
<script type="text/javascript">


	var divWidth = "<%=sumLength%>";
	var hpWidth = $("#content_"+<%=eid%>).width();
	
	//元素独立显示时，获取宽度方法
	if ("true" == "<%=indie%>") {
		hpWidth = $("#tabContant_"+<%=eid%>).width();
	}
	var issetting=$("input[name='ispagesetting']").val();
	if(hpWidth < 200){
	   //hpWidth = 382;//临时处理，出现小于 200 情况，基本是不正常，一般是 属于协同元素。协同元素宽度固定
	}
	if(parseFloat(divWidth) > parseFloat(hpWidth)) {
		$("#tabnavprev_<%=eid%>").css("display","block");
		$("#tabnavnext_<%=eid%>").css("display","block");
		
		<%if(rs1.getCounts()>1){%>
	        $("#tabContainer_<%=eid%>").css("width", hpWidth - 55);
			$("#tabContainer_<%=eid%>").css("display", ""); 
			$("#tabContainer_<%=eid%>").css("margin-left", "0px");
			$("#tabContainer_<%=eid%>").css("margin-right", "0px"); 
		<%
		  }else{
		%>
			$("#tabnavprev_<%=eid%>").css("display","none");
			$("#tabnavnext_<%=eid%>").css("display","none");
			$("#tabContainer_<%=eid%>").css("display", "none"); 
		<%
		  }
	    %>
	}else{
		$("#tabnavprev_<%=eid%>").css("display","none");
		$("#tabnavnext_<%=eid%>").css("display","none");
	
		<%if(rs1.getCounts()>1){%>
        $("#tabContainer_<%=eid%>").css("width", hpWidth);
		$("#tabContainer_<%=eid%>").css("display", ""); 
		$("#tabContainer_<%=eid%>").css("margin-left", "0");
		$("#tabContainer_<%=eid%>").css("margin-right", "0"); 
		<%}else{
		%>
		$("#tabContainer_<%=eid%>").css("display", "none"); 
		<%
		}%>
	}
</script>