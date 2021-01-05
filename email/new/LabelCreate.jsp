<%@page import="weaver.email.service.LabelManagerService"%>
<%@page import="weaver.email.domain.MailLabel"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="lms" class="weaver.email.service.LabelManagerService" scope="page" />

<link href="/email/css/base_wev8.css" rel="stylesheet" type="text/css" />
<link href="/email/css/color_wev8.css" rel="stylesheet" type="text/css" />
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css" />

<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js" charset="UTF-8"></script>
<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js" ></script>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitDate(),_self} " ;    
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<script type="text/javascript" src="/email/js/colorselect/jquery.colorselect_wev8.js"></script>
<%
String mailsId = Util.null2String(request.getParameter("mailsId"));
String labelid = Util.null2String(request.getParameter("labelid"));
String type=Util.null2String(request.getParameter("type"));

%>

<script type="text/javascript">
var type="<%=type%>";
var dialog = parent.getDialog(window); 
var parentWin = parent.getParentWindow(window);
$(document).ready(function(){
	$("#colorselector").bind("click",function(){
		//$(this).offset().top
		$(".colorpicker").css("left",$(this).offset().left)
		$(".colorpicker").css("top",$(this).offset().top+30)
		$(".colorpicker").fadeIn(200)
	});
	
	$("#addLabel").bind("click",function(){
		$("#method").val("add");
	})
	
	$("#colorpicker").find("div").bind("click",function(event){
		$(".selectedColor").css("background-color",$(this).css("background-color"));
		$("#colorpicker").hide();
		event.stopPropagation();
	});
});

function submitDate(){
	
	if($.trim($("#labelname").val())==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81327,user.getLanguage()) %>")
		return;
	}
	var labelcolor= getBackgroundColor(".selectedColor");
	var labelid="";
	var method="LabelCreate";
	if(type=="3"){
		method="edit";
	}
	var para ={method:method,labelname:$("#labelname").val(),labelcolor:labelcolor,mailsId:"<%=mailsId%>",labelid:"<%=labelid%>"}	;
	$.post("/email/new/LabelManageOperation.jsp",para,function(data){
		if("repeat"==data){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(31222,user.getLanguage()) %>!");
		}else{
			parentWin.closeDialogcreateLabel();
		}
	});
	
}

function getBackgroundColor(selecter){
	<%if(isIE.equals("true")){%>
		var color= $(selecter).css("background-color");
		<%
	}else{
		%>
		var color= $(selecter).getHexBackgroundColor();
		<%
	}
	%>
	return color;
}
$.fn.getHexBackgroundColor = function() {
    var rgb = $(this).css('background-color');
    rgb = rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
    function hex(x) {return ("0" + parseInt(x).toString(16)).slice(-2);}
    return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]);
}
</script>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="mail"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<input class="e8_btn_top middle" onclick="submitDate()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<div id="colorpicker" class="colorpicker hide ">
	<div class=item1></div>
	<div class=item2></div>
	<div class=item3></div>
	<div class=item4></div>
	<div class=item5></div>
	<div class=item6></div>
	<div class=item7></div>
	<div class=item8></div>
	<div class=item9></div>
	<div class=item10></div>
	<div class=item11></div>
	<div class=item12></div>
	<div class=item13></div>
	<div class=item14></div>
	<div class=item15></div>
	<div class=item16></div>
	<div class=item17></div>
	<div class=item18></div>
	<div class=item19></div>
	<div class=item20></div>
</div>

<%
	if("1".equals(type)){//新增标签
%>

<wea:layout attributes="{'cw1':'30%','cw2':'70%'}">
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(81325,user.getLanguage()) %></wea:item>
		<wea:item><input type="text" style="width:50%" name="labelname" id="labelname"></wea:item>
		
		<wea:item><%=SystemEnv.getHtmlLabelName(81326,user.getLanguage()) %></wea:item>
		<wea:item>
			<div class="btnGray w-100 relative font12 p-l-10" id="colorselector" style="line-height: 28px;width: 80px!important;"><b class="selectedColor h-10 w-10  font12 absolute" style="overflow:hidden;top:10px;left:2px;display:block;background: #B54143"></b>&nbsp;<%=SystemEnv.getHtmlLabelName(16217,user.getLanguage()) %>
				 <img class="absolute" style="right: 5px; top:10px" src="/email/images/iconDArr_wev8.png">
			</div>
		</wea:item>
	</wea:group>
</wea:layout>

<%}else if("3".equals(type)){
	MailLabel mb=LabelManagerService.getOnelabelByID(labelid);
%>
	<wea:layout attributes="{'cw1':'30%','cw2':'70%'}">
		<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(81325,user.getLanguage()) %></wea:item>
			<wea:item><input type="text" style="width:50%" name="labelname" id="labelname"  value='<%=mb.getName()%>'></wea:item>
			
			<wea:item><%=SystemEnv.getHtmlLabelName(81326,user.getLanguage()) %></wea:item>
			<wea:item>
				<div class="btnGray w-80 relative font12 p-l-10" id="colorselector" style="line-height: 28px;width: 80px!important;"><b class="selectedColor h-10 w-10  font12 absolute" style="overflow:hidden;top:10px;left:2px;display:block;background: <%=mb.getColor()%>"></b>&nbsp;<%=SystemEnv.getHtmlLabelName(16217,user.getLanguage()) %>
					 <img class="absolute" style="right: 5px; top:10px" src="/email/images/iconDArr_wev8.png">
				</div>
			</wea:item>
		</wea:group>
	</wea:layout>

<%}%>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 
</body> 
<style>
#labelList tr{
	border-bottom: 1px solid #eee;
	height: 35px;
}

#labelList td,th{
	padding: 5px;
	font-size: 12px;
	color:#333;
	vertical-align: middle;
}

#labelList b{
	display: block;
	height: 10px;
	width: 10px;
	overflow:hidden;
}

#lean_overlay {
    position: fixed;
    z-index:100;
    top: 0px;
    left: 0px;
    height:100%;
    width:100%;
    background: #000;
    display: none;
    filter: alpha(opacity=30);
}

.colorpicker{
	width: 120px;
	box-shadow:rgba(0,0,0,0.2) 0px 0px 5px 0px;
    border: 2px solid #90969E;
    background: #ffffff;
    height: 100px;
    left:0px;
    padding-left:10px;
    padding-top: 10px;
    position: absolute;
    z-index: 1000000;
  
    
}

.colorpicker div{
	
	width: 10px;
	height:10px!important;
	margin: 5px;
	cursor:pointer;
	float: left;
	border-radius:3px;
	min-height: 0px;
	overflow:hidden;
	
}
.colorpicker div:hover{
	border-radius:0px;
	border: 1px solid #3366cc;
	
}
.popWindow{
      width:450px;
      height:auto;
      box-shadow:rgba(0,0,0,0.2) 0px 0px 5px 0px;
      border: 2px solid #90969E;
      background: #ffffff;
      top:100px;
      left:50%;
    }
.labelcolor{
	border-radius:2px;
	display: inline-block;
}
</style>

