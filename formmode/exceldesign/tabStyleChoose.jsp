<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%
	String tabstyle = Util.null2String(request.getParameter("tabstyle"), "-1");
%>
<html>
<head>
<link type="text/css" rel="stylesheet" href="/formmode/exceldesign/css/contextmenu_wev8.css"/>
<script type="text/javascript" src="/formmode/exceldesign/js/excelRightClick_wev8.js"></script>
<script type="text/javascript" src="/formmode/exceldesign/js/tabpage_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/formmode/exceldesign/css/tabPage_wev8.css"/>
<script>
$(document).unbind("contextmenu").bind("contextmenu", function (e) {
    return false;
});

var dialog; 
jQuery(document).ready(function(){
	jQuery("#topTitle").topMenuTitle({searchFn:searchStyle});
	dialog = window.top.getDialog(window);
	var tab_style_temp = $(".show #styletemplate");
	//加载系统样式
	var sysStyle = tabPage.sysStyleFace();
	var sysDefault = tabPage.sysDefaultFace();
	for(var key in sysStyle){
		var stylejson = {};
		jQuery.extend(true, stylejson, sysDefault, sysStyle[key]);
		var styleDiv = tab_style_temp.clone();
		styleDiv.removeAttr("id").attr("target", stylejson.styleid).css("display", "");
		$(".show").append(styleDiv);
		
		styleDiv.find("span[name='stylename']").text(stylejson.stylename);
		var divStyle = tabPage.getDivStyle_ByStyleFace(stylejson);
		tabPage.applyDivStyleFace(styleDiv, divStyle);
	}
	//加载自定义样式
	jQuery.ajax({
		type: "post",
		url: "/formmode/exceldesign/tabStyleOperation.jsp",
		data: {method:"selectall"},
		dataType: "JSON",
		success: function(msg){
			//生成自定义标签页样式
			var resjson = JSON.parse(msg);
			for(var key in resjson){
				var stylejson = resjson[key];
				var styleDiv = tab_style_temp.clone();
				styleDiv.removeAttr("id").attr("target", stylejson.styleid).css("display", "");
				$(".show").append(styleDiv);
				
				styleDiv.find("span[name='stylename']").text(stylejson.stylename);
				var divStyle = tabPage.getDivStyle_ByStyleFace(stylejson);
				tabPage.applyDivStyleFace(styleDiv, divStyle);
			}
			var styleObj = jQuery(".show").children("div[id!=styletemplate]");
			bindStyleDivEvent(styleObj);
			//默认选中
			var tabstyle = "<%=tabstyle %>";
			jQuery(".show").children("div[target='"+tabstyle+"']")
				.find("[name='stylecheck']").attr("checked", true).next().addClass("jNiceChecked");
		}
	});
});

function bindStyleDivEvent(styleObj){
	//checkbox美化、绑定单击事件
	styleObj.each(function(){
		bindClickEvent(jQuery(this));
	});
	styleObj.find("[name='stylecheck']").removeAttr("notBeauty");
	jQuery("body").jNice();
}

function bindClickEvent(stylediv){
	stylediv.find("input[name='stylecheck'],div.style_outside").click(function(){
		var style_outside = stylediv.find(".style_outside");
		if(style_outside.is(".selected"))
			return;
		$(".show").find(".style_outside").removeClass("selected");
		$(".show").find("input[type=checkbox]").attr("checked",false).next().removeClass("jNiceChecked");
		style_outside.addClass("selected");
		stylediv.find("input[type=checkbox]").attr("checked", true).next().addClass("jNiceChecked");
	});
	
	var styleid = stylediv.attr("target");
	if(parseInt(styleid) <= 0)		//系统样式不能修改
		return;
	stylediv.find("div.style_outside").contextMenu({
		menu : 'tabStyleMenu',
		button: 3,
		onPopup : function(el,e) {
			try{
 				e.stopPropagation();
 				e.preventDefault();
			}catch(er){
				window.event.cancelBubble = true;
				return false;
			}
			$("#tabStyleMenu").html("");
			var menuJson = "{";
			menuJson += "\"children\": [{";
			menuJson += "\"title\" : \"编辑\",";
			menuJson += "\"icon\": \"rmenuedit2\",";
			menuJson += "\"action\": \"editstyle\"";
			menuJson += "},{";
			menuJson += "\"title\" : \"删除\",";
			menuJson += "\"icon\": \"rmenudel\",";
			menuJson += "\"action\": \"delstyle\"";
			menuJson += "}";
			menuJson += "]}";
			menuJson = JSON.parse(menuJson); 
			$('#tabStyleMenu').mac('menu', menuJson);
		},
		offset: { x: 0, y: 0 }
	}, function(action, el, pos) {
		if(action === "editstyle"){	//编辑
			openStyleDesign("编辑标签页样式", "edit", styleid);
		}else if(action === "delstyle"){	//删除
			window.top.Dialog.confirm("确认删除此标签页样式？<br>注:已使用此样式的表单将以默认样式替代！",function(){
				$.ajax({
					type : "post",
					url : "/formmode/exceldesign/tabStyleOperation.jsp",
					data : {method:"deleteone", styleid:styleid},
					dataType:"JSON",
					success : function(msg){
						var result = JSON.parse(msg);
						if(result.state == "true"){
							el.closest(".stylediv").remove();
						}
					}
				});
			});
		}
	});
}

function openStyleDesign(title, opertype, styleid){
	var dlg = new window.top.Dialog();
	dlg.currentWindow = window;
	var url = "/formmode/exceldesign/tabStyleDesign.jsp?opertype="+opertype;
	if(opertype === "edit")
		url += "&styleid="+styleid;
	dlg.Title = title;
	dlg.Width = 900;
	dlg.Height = 720;
	dlg.Drag = true;
	dlg.URL = url;
	dlg.callbackfun = function(paramobj, datas){
		var stylejson = JSON.parse(datas);
		var styleDiv;
		if(opertype === "add"){
			var styleDiv = $(".show #styletemplate").clone();
			styleDiv.removeAttr("id").attr("target", stylejson.styleid).css("display", "");
			$(".show").append(styleDiv);
			bindStyleDivEvent(styleDiv);
		}else if(opertype === "edit"){
			styleDiv = $(".show").children("div[target='"+stylejson.styleid+"']");
		}
		styleDiv.find("span[name='stylename']").text(stylejson.stylename);
		var divStyle = tabPage.getDivStyle_ByStyleFace(stylejson);
		tabPage.applyDivStyleFace(styleDiv, divStyle);
	}
	dlg.show();
}

function confirmStyle(){
	var selectedStyle = jQuery(".show").find("[name='stylecheck']:checked");
	if(selectedStyle.size() == 0){
		window.top.Dialog.alert("请选择需要使用的样式！");
	}else{
		var styledivObj = selectedStyle.closest(".stylediv");
		var divstyle = {};
		divstyle.t_area = "";
		divstyle.t_sep = "";
		divstyle.t_sel_left = "";
		divstyle.t_sel_middle = "";
		divstyle.t_sel_right = "";
		divstyle.t_unsel_left = "";
		divstyle.t_unsel_middle = "";
		divstyle.t_unsel_right = "";
		for(var key in divstyle){
			divstyle[key] = styledivObj.find("div."+key).attr("style");
		}
		var retjson = {"styleid" : styledivObj.attr("target"), "divstyle" : divstyle};
		dialog.close(retjson);
	}
}

function searchStyle(){
	var searchval=$("input[name='searchval']").val();
	var styleObj = jQuery(".show").children("[target]");
	if(searchval === ""){
		styleObj.css("display", "");
	}else{
		styleObj.each(function(){
			if($(this).attr("target") < 0)
				return true;
			var stylename = $(this).find("span[name='stylename']").text();
			if(stylename.indexOf(searchval) > -1){
				$(this).css("display", "");
			}else{
				$(this).css("display", "none");
			}
		});
	}
}
</script>
<style>
body{
	height:100%; width:100%; overflow:hidden;
	margin:0px; padding:0px; font-size:12px;
}
.show .stylediv{
    height:80px; float:left; text-align:center;
	margin-left:40px; margin-top:30px; width:290px;
}
.show .style_outside{
	border: 1px solid white; padding:4px; cursor:pointer;
}
.show .selected{
	border-color:#38b2ec;
}
</style>
</head>
<body>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="标签页样式选择"/>
</jsp:include>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="text" class="searchInput" name="searchval" />
			<span id="advancedSearch" class="advancedSearch" style="display:none">高级搜索</span>
			<input type="button" value="添加样式" onclick="openStyleDesign('新建标签页样式', 'add');" class="e8_btn_top" style="margin-right:5px">
		</td>
	</tr>
</table>
<ul id="tabStyleMenu" class="contextMenu"></ul>
<div class="show" style="overflow-y:auto; height:496px;">
	<div id="styletemplate" class="stylediv" style="display:none">
		<input type="checkbox" notBeauty=true name="stylecheck"/>
		<span name="stylename"></span>
		<div class="style_outside">
			<div class="t_area xrepeat">
				<div class="t_sel">
					<div class="t_sel_left norepeat"></div>
					<div class="t_sel_middle xrepeat lineheight30">标签页1</div>
					<div class="t_sel_right norepeat"></div>
				</div>
				<div class="t_sep norepeat"></div>
				<div class="t_unsel">
					<div class="t_unsel_left norepeat"></div>
					<div class="t_unsel_middle xrepeat lineheight30">标签页2</div>
					<div class="t_unsel_right norepeat"></div>
				</div>
				<div class="t_sep norepeat"></div>
				<div class="t_unsel">
					<div class="t_unsel_left norepeat"></div>
					<div class="t_unsel_middle xrepeat lineheight30">标签页3</div>
					<div class="t_unsel_right norepeat"></div>
				</div>
			</div>
		</div>
	</div>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="确定" class="zd_btn_cancle" onclick="confirmStyle()">
				<input type="button" value="取消" class="zd_btn_cancle" onclick="dialog.close()">
			</wea:item>
		</wea:group>
	</wea:layout>      
</div>
</body>
</html>