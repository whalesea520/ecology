
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="com.weaver.formmodel.mobile.ui.manager.MobileTemplateManager"%>
<%@ include file="/mobilemode/init.jsp"%>
<%
MobileTemplateManager mobileTemplateManager=MobileTemplateManager.getInstance();
String templateType=Util.null2String(request.getParameter("templateType"));
int index=Util.getIntValue(Util.null2String(request.getParameter("index")),0);
int oldIndex=Util.getIntValue(Util.null2String(request.getParameter("oldIndex")),0);
Map hpTemplateMap=mobileTemplateManager.getTemplateMap(templateType,index);

int refresh=Util.getIntValue(Util.null2String(request.getParameter("refresh")),0);

String name=Util.null2String(hpTemplateMap.get("name"));
String enable=Util.null2String(hpTemplateMap.get("enable"));
String desc=Util.null2String(hpTemplateMap.get("desc"));
String url=Util.null2String(hpTemplateMap.get("url"));
String content=Util.null2String(hpTemplateMap.get("content"));
String crdate=Util.null2String(hpTemplateMap.get("crdate"));

String topname = SystemEnv.getHtmlLabelName(127570,user.getLanguage());  //UI模板
if("homepage".equals(templateType)){
	topname = SystemEnv.getHtmlLabelName(127706,user.getLanguage());  //首页模板
}
String topnamedes="";
if("".equals(name)){
	topnamedes = SystemEnv.getHtmlLabelName(64,user.getLanguage())+index;  //模板
}else{
	topnamedes=name;
}
%>
<HTML><HEAD>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<script src="/formmode/js/codemirror/lib/codemirror_wev8.js"></script>
	<link rel="stylesheet" href="/formmode/js/codemirror/lib/codemirror_wev8.css"/>
	<script src="/formmode/js/codemirror/mode/javascript/javascript_wev8.js"></script>
	<script src="/formmode/js/codemirror/mode/xml/xml_wev8.js"></script>
	<script src="/formmode/js/codemirror/mode/css/css_wev8.js"></script>
	<script src="/formmode/js/codemirror/mode/htmlmixed/htmlmixed_wev8.js"></script>
	<SCRIPT language="javascript" src="/js/weaver_wev8.js"></SCRIPT>
	<style>
		*, textarea{
			font-family: 'Microsoft Yahei', Arial;
			font-size: 12px;
		}
		html,body{
			height: 100%;
			margin: 0px;
			padding: 0px;
			overflow: hidden;
		}
		.e8_form_top{
				padding: 13px 10px 0px 10px;
				position: relative;
		}
		.e8_form_top .e8_from_info{
			border-bottom: 1px solid #E9E9E9;
			padding-bottom: 16px;
		}
		.e8_form_top .e8_from_name{
			font-size: 18px;
			color: #333;
		}
		.e8_form_top .e8_from_modify{
			font-size: 12px;
			color: #AFAFAF;
		}
		.e8_form_top ul{
			list-style: none;
			position: absolute;
			right: 10px;
			bottom: 10px;
		}
		.e8_form_top ul li{
			float: left;
			padding: 0px 5px;
		}
		.e8_form_top ul li a{
			font-size: 15px;
			color: #A3A3A3;
			padding: 1px;
			text-decoration: none;
			cursor: pointer;
			border-bottom: 2px solid #fff;
		}
		.e8_form_top ul li.selected a{
			color: #0072C6;		
			border-bottom: 2px solid #0072C6;
		}
		.e8_form_center{
			overflow: hidden;
			padding: 0px 10px;
		}
		.e8_form_center .e8_form_frameContainer{
			display: none;
			height: 100%;
		}
		.toptable{
			padding: 0px 10px 0px 10px;
			position: relative;
		}
		.e8_tblForm{
			width: 100%;
			margin: 0 0;
			border-collapse: collapse;
		}
		.e8_tblForm .e8_tblForm_label{
			vertical-align: middle;
			border-bottom: 1px solid #e6e6e6;
			padding: 5px 2px;
		}
		.e8_tblForm .e8_tblForm_field{
			border-bottom: 1px solid #e6e6e6;
			padding: 5px 7px;
			background-color: #f8f8f8;
		}
		.e8_label_desc{
			color: #aaa;
		}
		.loading{
		    position:absolute;
		    left:45%;
		    background:#ffffff;
		    top:40%;
		    padding:8px;
		    z-index:20001;
		    height:auto;
		    border:1px solid #ccc;
		}
		.CodeMirror{
			font-size: 12px;
			line-height: 1.5em;
			height: 100%;
			border-left: 1px solid #eee;
			border-right: 1px solid #eee;
			border-bottom: 1px solid #eee;
		}
		.slide-preview{
			background: url("/mobilemode/images/mec/pic-icon_wev8.png") no-repeat;
			color: rgb(51, 51, 51);
			height: 150px;
			width: 320px;
			line-height: 20px;
			margin-bottom: 8px;
			margin-top: 8px;
			overflow-x: hidden;
			overflow-y: hidden;
			position: relative;
		}
		#picpath{
			position: absolute;
			margin-left:-115px;
			font-size: 20px;
			width: 200px;
			top: 0px;
			left: 0px;
			filter:alpha(opacity=0);
		    opacity:0;
		    cursor: pointer;
		}
		.slide-upload-div{
			background-color: rgb(93, 156, 236);
			color: rgb(255, 255, 255);
			cursor: pointer;
			display: inline-block;
			font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
			font-size: 12px;
			font-weight: bold;
			height: 30px;
			line-height: 30px;
			padding-bottom: 0px;
			padding-left: 20px;
			padding-right: 20px;
			padding-top: 0px;
		}
		#previewImg{
			width: 100%;
			height: 100%;
		}
	</style>
<script type="text/javascript">
if('<%=refresh%>'=='1'){
	if(<%=index%>==-1){
		alert("<%=SystemEnv.getHtmlLabelName(127707,user.getLanguage())%>");  //请至少保证有一个模板启用！
		if(<%=oldIndex%>==0){
			parent.refreshData();
		}else{
			parent.refreshForm(<%=oldIndex%>);
		}
	}else{
		parent.refreshForm(<%=index%>);
	}
}
</script>
<script>
var utils={
	html:function (str) {
        return str ? str.replace(/&((g|l|quo)t|amp|#39|nbsp);/g, function (m) {
            return {
                '&lt;':'<',
                '&amp;':'&',
                '&quot;':'"',
                '&gt;':'>',
                '&#39;':"'",
                '&nbsp;':' '
            }[m]
        }) : '';
    }
}

function onCreate(){
	location.href="templateEdit.jsp?templateType=<%=templateType%>&index=0";
}

function onSave(){
	var obj = document.getElementById("name");
	if(obj&&obj.value==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859,user.getLanguage())%>",function(){displayAllmenu();});  //必要信息不完整！
	}else{
		enableAllmenu();
		$(".loading").show();
		var contenthtml=editor.getValue();
		$("#content").val(utils.html(contenthtml));
		document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileTemplateAction", "action=save");
		document.frmMain.submit();
	}
}

function onDelete(){
	if(confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>")) {
		enableAllmenu();
		$(".loading").show();
		document.frmMain.action = jionActionUrl("com.weaver.formmodel.mobile.ui.servlet.MobileTemplateAction", "action=delete");
		document.frmMain.submit();
	}
}

var editor;
window.onload = function(){
	$(".e8_form_tabs > ul > li").click(function(){
		if(!$(this).hasClass("selected")){
			var $prevSelectedTab = $(this).siblings(".selected");
			$prevSelectedTab.removeClass("selected");
			$(this).addClass("selected");
			
			var prevH = $prevSelectedTab.attr("href");
			if(prevH && prevH != ""){
				$(prevH).hide();
			}
			
			var h = $(this).attr("href");
			if(h && h != ""){
				$(h).show();
			}
		}
	});
	
	$("#tabs-content-2").height($(document.body).height() - $(".e8_form_top").height()-16);
	editor = CodeMirror.fromTextArea(document.getElementById("editcontent"), {
		lineNumbers: true,
		indentUnit: 4,
		mode: "htmlmixed"
	});
	$("#tabs-content-2").css("visibility", "visible").hide();
};

function preview(){
	var previewImg = document.getElementById("previewImg");
	var slidePreview = document.getElementById("slide-preview");
	var uploadfile = document.getElementById("picpath");
	if(uploadfile.files && uploadfile.files[0]){ 
		$(previewImg).show();
		var reader = new FileReader();  
    	reader.onload = function(evt){previewImg.src = evt.target.result;}  
    	reader.readAsDataURL(uploadfile.files[0]);
    }else{
    	$(previewImg).hide();
    	uploadfile.select();
    	slidePreview.focus();	//ie9 hack
		var src = document.selection.createRange().text;
		slidePreview.style.filter="progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale',src='"+src+"')";
		//previewImg.filters.item('DXImageTransform.Microsoft.AlphaImageLoader').src = src;  
    }
}
</script>
</HEAD>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(82,user.getLanguage())+",javascript:onCreate(),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
    RCMenuHeight += RCMenuHeightStep ;
    if(index > 0) {
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(),_self} ";
    	RCMenuHeight += RCMenuHeightStep ;
    }
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<body>
<div class="e8_form_top">
		<div style="width:40px;float:left;margin:2px 10px 0 0;"><img src="/formmode/images/formIconRounded_wev8.png" /></div>
		<div class="e8_from_info">
			<div class="e8_from_name">
				 <%=topname %>/ <%=name %>  
			</div>
			<div class="e8_from_modify">
				<%=SystemEnv.getHtmlLabelName(127704,user.getLanguage())%><!-- 最后编辑时间： --><%=crdate %>
			</div>
		</div>
		<div class="e8_form_tabs">
			<ul>
				<li href="#tabs-content-1" defaultSelected="true" class="selected"><a><%=SystemEnv.getHtmlLabelName(81990,user.getLanguage())%><!-- 基础 --></a></li>
				<li href="#tabs-content-2"><a><%=SystemEnv.getHtmlLabelName(590,user.getLanguage())%><!-- 代码 --></a></li>
			</ul>
		</div>
</div>
<form id="frmMain" name="frmMain" method="post" target="_self" enctype="multipart/form-data">
<input type="hidden" id="templateType" name="templateType" value="<%=templateType%>"/>
<input type="hidden" id="index" name="index" value="<%=index%>" />
<input type="hidden" id="content" name="content"/>
<input type="hidden" id="imageurl" name="imageurl" value="<%=url%>"/>
<div class="toptable">
	<div id="tabs-content-1">
		<table class="e8_tblForm" height="100%" >
			<tr>
				<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(28050,user.getLanguage())%><!-- 模板名称 --></td>
				<td class="e8_tblForm_field">
					<input type="text" style="width:80%;" id="name" name="name" value="<%=name%>" onBlur="checkinput('name','namespan');"/>
					<span id="namespan"><%if(name.equals("")){%><IMG src="/images/BacoError_wev8.gif" align="absMiddle"><%}%></span>
				</td>
			</tr>
			<tr>
				<td class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(125504,user.getLanguage())%><!-- 是否启用 --></td>
				<td class="e8_tblForm_field">
					<input type="checkbox" id="enable" name="enable" <%if("true".equalsIgnoreCase(enable)){%>checked="checked"<%}%> value="1"/>
		        </td>
			</tr>
			<tr>
				<td class="e8_tblForm_label" width="20%" style="vertical-align: top;"><!-- 模板预览图片 --><div class="e8_label_desc"></div></td><!-- 图标 -->
				<td class="e8_tblForm_field">
					<div style="position: relative;">
						<INPUT type="file" name="picpath" id="picpath" value="<%=Util.null2String(url) %>" onchange="preview();">
						<div class="slide-upload-div"><%=SystemEnv.getHtmlLabelName(125080,user.getLanguage())%><!-- 选择图片 --></div>
					</div>
						
					<div class="slide-preview" id="slide-preview">
		            	<img id="previewImg" <%if(Util.null2String(url).trim().equals("")){%> style="display: none;" <%}else{%> src="<%=Util.null2String(url) %>" <%}%>>
		            </div>
				</td>
			</tr>
			<tr>
				<td class="e8_tblForm_label" width="20%" style="vertical-align: top;"><%=SystemEnv.getHtmlLabelName(433,user.getLanguage())%></td><!-- 描述 -->
				<td class="e8_tblForm_field">
					<textarea name="descriptions" id="descriptions" style="font-family: 'Microsoft YaHei', Arial;width: 80%;height:135px;overflow:auto;"><%=Util.null2String(desc) %></textarea>
				</td>
			</tr>
		</table>
	</div>
	
	<div id="tabs-content-2" style="visibility: hidden;">
		<textarea id="editcontent" name="editcontent" style="width: 80%;height:250px;"><%=content%></textarea>
	</div>
</div>
</form>
 </body>
</html>