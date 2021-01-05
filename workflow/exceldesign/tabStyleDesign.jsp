<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="net.sf.json.JSONObject" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String opertype = Util.null2String(request.getParameter("opertype"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	int styleid = Util.getIntValue(request.getParameter("styleid"), -1);
	String stylename="",image_bg="",image_sep="",image_sepwidth="1",
		sel_bgleft="",sel_bgleftwidth="10",sel_bgmiddle="",sel_bgright="",sel_bgrightwidth="10",
		sel_color="#000000",sel_fontsize="12",sel_family="微软雅黑",sel_bold="",sel_italic="",
		unsel_bgleft="",unsel_bgleftwidth="10",unsel_bgmiddle="",unsel_bgright="",unsel_bgrightwidth="10",
		unsel_color="#000000",unsel_fontsize="12",unsel_family="微软雅黑",unsel_bold="",unsel_italic="";
	if("add".equals(opertype) && "".equals(isclose)){
		image_bg = "/workflow/exceldesign/image/systab/1_image_bg.png";
		image_sep = "/workflow/exceldesign/image/systab/1_image_sep.png";
		sel_bgleft = "/workflow/exceldesign/image/systab/1_sel_bgleft.png";
		sel_bgmiddle = "/workflow/exceldesign/image/systab/1_sel_bgmiddle.png";
		sel_bgright = "/workflow/exceldesign/image/systab/1_sel_bgright.png";
		unsel_bgleft = "/workflow/exceldesign/image/systab/1_unsel_bgleft.png";
		unsel_bgmiddle = "/workflow/exceldesign/image/systab/1_unsel_bgmiddle.png";
		unsel_bgright = "/workflow/exceldesign/image/systab/1_unsel_bgright.png";
	}
	if(styleid > 0){
		String sql = "select * from workflow_tabstyle where styleid="+styleid;
		rs.executeSql(sql);
		if(rs.next()){
			stylename = Util.null2String(rs.getString("stylename"));
			image_bg = Util.null2String(rs.getString("image_bg"));
			image_sep = Util.null2String(rs.getString("image_sep"));
			image_sepwidth = Util.null2String(rs.getString("image_sepwidth"));
			
			sel_bgleft = Util.null2String(rs.getString("sel_bgleft"));
			sel_bgleftwidth = Util.null2String(rs.getString("sel_bgleftwidth"));
			sel_bgmiddle = Util.null2String(rs.getString("sel_bgmiddle"));
			sel_bgright = Util.null2String(rs.getString("sel_bgright"));
			sel_bgrightwidth = Util.null2String(rs.getString("sel_bgrightwidth"));
			sel_color = Util.null2String(rs.getString("sel_color"));
			sel_fontsize = Util.null2String(rs.getString("sel_fontsize"));
			sel_family = Util.null2String(rs.getString("sel_family"));
			sel_bold = Util.null2String(rs.getString("sel_bold"));
			sel_italic = Util.null2String(rs.getString("sel_italic"));
			
			unsel_bgleft = Util.null2String(rs.getString("unsel_bgleft"));
			unsel_bgleftwidth = Util.null2String(rs.getString("unsel_bgleftwidth"));
			unsel_bgmiddle = Util.null2String(rs.getString("unsel_bgmiddle"));
			unsel_bgright = Util.null2String(rs.getString("unsel_bgright"));
			unsel_bgrightwidth = Util.null2String(rs.getString("unsel_bgrightwidth"));
			unsel_color = Util.null2String(rs.getString("unsel_color"));
			unsel_fontsize = Util.null2String(rs.getString("unsel_fontsize"));
			unsel_family = Util.null2String(rs.getString("unsel_family"));
			unsel_bold = Util.null2String(rs.getString("unsel_bold"));
			unsel_italic = Util.null2String(rs.getString("unsel_italic"));
		}
	}
	//生成返回JSON串
	JSONObject stylejson = new JSONObject();
	if("on".equals(isclose)){
		stylejson.put("styleid", styleid);
		stylejson.put("stylename", stylename);
		stylejson.put("image_bg", image_bg);
		stylejson.put("image_sep", image_sep);
		stylejson.put("image_sepwidth", image_sepwidth);
		
		stylejson.put("sel_bgleft", sel_bgleft);
		stylejson.put("sel_bgleftwidth", sel_bgleftwidth);
		stylejson.put("sel_bgmiddle", sel_bgmiddle);
		stylejson.put("sel_bgright", sel_bgright);
		stylejson.put("sel_bgrightwidth", sel_bgrightwidth);
		stylejson.put("sel_color", sel_color);
		stylejson.put("sel_fontsize", sel_fontsize);
		stylejson.put("sel_family", sel_family);
		stylejson.put("sel_bold", sel_bold);
		stylejson.put("sel_italic", sel_italic);

		stylejson.put("unsel_bgleft", unsel_bgleft);
		stylejson.put("unsel_bgleftwidth", unsel_bgleftwidth);
		stylejson.put("unsel_bgmiddle", unsel_bgmiddle);
		stylejson.put("unsel_bgright", unsel_bgright);
		stylejson.put("unsel_bgrightwidth", unsel_bgrightwidth);
		stylejson.put("unsel_color", unsel_color);
		stylejson.put("unsel_fontsize", unsel_fontsize);
		stylejson.put("unsel_family", unsel_family);
		stylejson.put("unsel_bold", unsel_bold);
		stylejson.put("unsel_italic", unsel_italic);
	}
%>
<HTML>
<HEAD>
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/spectrum/spectrum_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/js/ecology8/spectrum/spectrum_wev8.css"/>
<script type="text/javascript" src="/js/jquery/plugins/filetree/jquery.filetree_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/workflow/exceldesign/css/tabPage_wev8.css"/>	
<script type="text/javascript">
if("<%=isclose %>" === "on"){
	var dialog = parent.getDialog(window);
	var returnStr = '<%=stylejson.toString() %>';
	dialog.close(returnStr);
}

var dialog;
jQuery(document).ready(function(){
	dialog = window.top.getDialog(window);
	jQuery("input[type='text'][r_id][r_attr]").each(function(){
		setStyleValue($(this).attr("r_id"), $(this).attr("r_attr"), $(this).val());
	});
	jQuery("input[type='checkbox'][r_id][r_attr]").each(function(){
		checkboxDynamic($(this));
		$(this).click(function(){
			checkboxDynamic($(this));
		});
	});
	jQuery("input[type='text'][name$='width'][r_id][r_attr]").blur(function(){
		setStyleValue($(this).attr("r_id"), $(this).attr("r_attr"), $(this).val());
	});

	//下拉递增插件
	$("input[target=_number").spinner({
        min: 8,
        max: 36,
        step: 1,
        change:function(){
        	setStyleValue($(this).attr("r_id"), $(this).attr("r_attr"), $(this).val());
        }
    });
    //颜色选择插件
    $("input[target=_color]").spectrum({
        showPalette:true,
        showInput:true,
        preferredFormat:"hex",
        clickoutFiresChange: false,
        chooseText:"<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>",
        cancelText:"<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>",
        palette:[
            ["#000000", "#434343", "#666666", "#999999", "#b7b7b7", "#cccccc", "#d9d9d9", "#efefef", "#f3f3f3", "#ffffff"],
            ["#980000", "#ff0000", "#ff9900", "#ffff00", "#00ff00", "#00ffff", "#4a86e8", "#0000ff", "#9900ff", "#ff00ff"],
            ["#e6b8af", "#f4cccc", "#fce5cd", "#fff2cc", "#ecead3", "#d9ead3", "#c9daf8", "#cfe2f3", "#d9d2e9", "#ead1dc"],
            ["#dd7e6b", "#ea9999", "#f9cb9c", "#ffe599", "#b6d7a8", "#a2c4c9", "#a4c2f4", "#9fc5e8", "#b4a7d6", "#d5a6bd"],
            ["#cc4125", "#e06666", "#f6b26b", "#ffd966", "#93c47d", "#76a5af", "#6d9eeb", "#6fa8dc", "#8e7cc3", "#c27ba0"],
            ["#a61c00", "#cc0000", "#e69138", "#f1c232", "#6aa84f", "#45818e", "#3c78d8", "#3d85c6", "#674ea7", "#a64d79"],
            ["#85200c", "#990000", "#b45f06", "#bf9000", "#38761d", "#134f5c", "#1155cc", "#0b5394", "#351c75", "#741b47"],
            ["#5b0f00", "#660000", "#783f04", "#7f6000", "#274e13", "#0c343d", "#1c4587", "#073763", "#20124d", "#4c1130"]
        ],
        change:function(color){
        	var inputObj = $(this).closest("td").children().eq(0);
        	inputObj.val("#"+color.toHex());
        	setStyleValue(inputObj.attr("r_id"), inputObj.attr("r_attr"), inputObj.val());
        }
    });
    //文件树选择、处理所有filetree插件
	$(".filetree").each(function(){
		var r_id = $(this).attr("r_id");
		var r_attr = $(this).attr("r_attr");
		var value = $(this).val();
	
		/*
		//处理图片链接
		value = getStyleValue(r_id,r_attr);
		var posTemp=value.indexOf("url(");
		if(posTemp!=-1){
			var posTemp2=value.indexOf(")",posTemp);
			if(posTemp2!=-1){
				value=value.substring(posTemp+4,posTemp2);
			}
		}
		var pos=value.indexOf("http://");			
		if(pos!=-1){
			var pos2=value.indexOf("/",pos+7);							
			value=value.substring(pos2);
		}
		pos=value.indexOf("//");							
		if(pos!=-1){
			var pos2=value.indexOf("/",pos+2);
			var pos3=value.indexOf("\")",pos2);
			value=value.substring(pos2,pos3);
		}
		value=value.replace(/"/g, "");
		this.value = value;
		*/
		
		$(this).filetree({
			file: value,
			call: function(result){
				setStyleValue(r_id, r_attr, result);
			}
		});
	});
});

function getStyleValue(r_id, r_attr){
	var returnVal = "";
	returnVal = jQuery("div."+r_id).css(r_attr);
	return returnVal;
}

function checkboxDynamic(obj){
	var r_id = obj.attr("r_id");
	var r_attr= obj.attr("r_attr");
	var cssval = "";
	if(obj.attr("checked")){
		if(r_attr === "font-weight")	cssval = "bold";
		if(r_attr === "font-style")		cssval = "italic";
	}else{
		cssval = "normal";
	}
	setStyleValue(r_id, r_attr, cssval);
}

function setStyleValue(r_id, r_attr, cssval){
	if(r_attr === "background-image"){
		cssval = "url('"+cssval+"')";
	}else if(r_attr === "font-size" || r_attr === "width"){
		cssval = cssval+"px";
	}
	var obj = jQuery("div."+r_id);
	obj.css('cssText', obj[0].style.cssText+";"+r_attr+':'+cssval+'!important;');
}

function saveStyleDesign(){
	if(check_form(weaverform,"stylename")){
		document.weaverform.submit();
	}
}

function clostStyleDesign(){
	dialog.close();
}

function setFont(obj, inputname){
	var inputobj = $(obj).parent().find("input[name='"+inputname+"']");
	var dlg = new window.top.Dialog();
	dlg.currentWindow = window;   //传入当前window
	dlg.Width = 560;
	dlg.Height = 300;
	dlg.maxiumnable=true;
	dlg.callbackfun = function(paramobj,datas){
		var tempid = datas;
		if(tempid){
			if(tempid.name){
				inputobj.val(tempid.name);
			}else{
				inputobj.val("");
			}
			setStyleValue(inputobj.attr("r_id"), inputobj.attr("r_attr"), inputobj.val());
		}
	};
	dlg.Modal = true;
	dlg.Title = "<%=SystemEnv.getHtmlLabelName(16189,user.getLanguage())%>"; 
	dlg.URL = "/systeminfo/BrowserMain.jsp?url=/page/maint/style/FontSelect.jsp?isDialog=1";
	dlg.show();
}

function checkWidth(vthis){
	var value = $(vthis).val();
	var name = $(vthis).closest("td").prev().text()+":<%=SystemEnv.getHtmlLabelName(203, user.getLanguage())%>";
	if(isNaN(value) || value.indexOf(".")>-1 || parseInt(value)<0){
		window.top.Dialog.alert(name+"<%=SystemEnv.getHtmlLabelName(129033, user.getLanguage())%>");
		$(vthis).val("");
	}
}

</script>
<style>
.leftSetContent{
	width:55%; background:#fff; height:100%
}
.rightShowContent{
	position:absolute; top:10px; left:540px;
}
.setFontImg{
	cursor:pointer; position:relative; top:6px; padding:0px; margin:0px;
}
.colorpickContainer .sp-preview {
	margin-right:0px; border:none; width:17px; height:22px;
}
.colorpickContainer .sp-replacer {
	padding: 0px; border:none; background:#fff;
}
.colorpickContainer .sp-dd{
	display:none;
}
.colorpickContainer .sp-preview, .sp-alpha, .sp-thumb-el {
	background-image:url("/workflow/exceldesign/image/shortBtn/format/BackgroundColor_wev8.png"); background-repeat: no-repeat;
}
.colorpickContainer .sp-preview-inner {
	top:18px; height:4px;
}
.style_outside{
	margin-top:20px; width:320px;
}
</style>
</HEAD>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:saveStyleDesign(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage()) + ",javascript:clostStyleDesign(),_self}";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(129034, user.getLanguage())%>"/>
</jsp:include> 
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" onclick="saveStyleDesign();" class="e8_btn_top" id="btnok">
	      	<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<div class="zDialog_div_content" style="background:#ebeef0">
<form name="weaverform" action="/workflow/exceldesign/tabStyleOperation.jsp" type="post">
	<input type="hidden" name="styleid" value="<%=styleid %>"  />
	<input type="hidden" name="opertype" value="<%=opertype %>" />
	<input type="hidden" name="method" value="save" />
	<div class="leftSetContent">
		<div style="margin-left:30px;padding-top: 15px;color:#5f708d">
			<span><%=SystemEnv.getHtmlLabelName(19621, user.getLanguage())%></span>
			<span style="padding-left:15px;">
				<input type="text" name="stylename" style="width:180px;" value="<%=stylename %>" onblur="checkMaxLength(this)" onChange="checkinpute8(this,'stylenamespan')" maxlength="200" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>200(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"></input>
				<span id="stylenamespan"><img <%="".equals(stylename)?"":"style='display:none'" %> src="/images/BacoError_wev8.gif" align="absMiddle"></span>
			</span>
		</div>
		<div style="width:100%">
			<wea:layout type="menu2col" attributes="{'cw1':'23%','cw2':'77%'}">
				<!--选中状态 -->
				<wea:group context="<%=SystemEnv.getHtmlLabelName(129036, user.getLanguage())%>">
					<wea:item><%=SystemEnv.getHtmlLabelName(33440, user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(22986, user.getLanguage())%></wea:item>
					<wea:item>	
						<input class="filetree" type="text" name="sel_bgleft" value="<%=sel_bgleft %>" 
							r_id="t_sel_left" r_attr="background-image" style="width:70% !important"/>
						<%=SystemEnv.getHtmlLabelName(203, user.getLanguage())%>&nbsp;<input type="text" name="sel_bgleftwidth" value="<%=sel_bgleftwidth %>" onBlur="checkWidth(this)"
							r_id="t_sel_left" r_attr="width" max_width="50" style="width:30px !important"/>px&nbsp;
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(33440, user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(16330, user.getLanguage())%></wea:item>
					<wea:item>	
						<input class="filetree" type="text" name="sel_bgmiddle" value="<%=sel_bgmiddle %>" 
							r_id="t_sel_middle" r_attr="background-image" style="width:70% !important"/>&nbsp;
						<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(129035, user.getLanguage())%>">
							<img src="/images/tooltip_wev8.png" align="absMiddle">
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(33440, user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(22988, user.getLanguage())%></wea:item>
					<wea:item>	
						<input class="filetree" type="text" name="sel_bgright" value="<%=sel_bgright %>" 
							r_id="t_sel_right" r_attr="background-image" style="width:70% !important"/>
						<%=SystemEnv.getHtmlLabelName(203, user.getLanguage())%>&nbsp;<input type="text" name="sel_bgrightwidth" value="<%=sel_bgrightwidth %>" onBlur="checkWidth(this)"
							r_id="t_sel_right" r_attr="width" max_width="50" style="width:30px !important"/>px&nbsp;
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %></wea:item>
					<wea:item attributes="{'colspan':'3'}">
						<input type="text" name="sel_color" value="<%=sel_color %>" readonly r_id="t_sel_middle" r_attr="color"></input> &nbsp;
						<span class="colorpickContainer" >
							<input type="text" name="sel_color_picker" target="_color"  value="<%=sel_color %>"></input>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(16197,user.getLanguage()) %></wea:item>
					<wea:item attributes="{'colspan':'3'}">
						<input type="text" name="sel_fontsize" value="<%=sel_fontsize %>" target="_number" readonly
							r_id="t_sel_middle" r_attr="font-size" style="border:none!important; height:20px; width:30px;" ></input>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(16189,user.getLanguage()) %></wea:item>
					<wea:item>
						<input type="text" name="sel_family" value="<%=sel_family %>" readonly r_id="t_sel_middle" r_attr="font-family" />
						<IMG onclick="setFont(this,'sel_family')" class="setFontImg" src="/images/ecology8/request/search-input_wev8.png" width="16" height="18" />
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1014,user.getLanguage()) %></wea:item>
					<wea:item>
						<%=SystemEnv.getHtmlLabelName(23002,user.getLanguage()) %>
						<input type="checkbox" name="sel_bold" <%="1".equals(sel_bold)?"checked":"" %> r_id="t_sel_middle" r_attr="font-weight"/>
						<%=SystemEnv.getHtmlLabelName(23003,user.getLanguage()) %>
						<input type="checkbox" name="sel_italic" <%="1".equals(sel_italic)?"checked":"" %> r_id="t_sel_middle" r_attr="font-style"/>
					</wea:item>
				</wea:group>
				<!-- 未选中状态 -->
				<wea:group context="<%=SystemEnv.getHtmlLabelName(129037, user.getLanguage())%>">
					<wea:item><%=SystemEnv.getHtmlLabelName(33440, user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(22986, user.getLanguage())%></wea:item>
					<wea:item>	
						<input class="filetree" type="text" name="unsel_bgleft" value="<%=unsel_bgleft %>" 
							r_id="t_unsel_left" r_attr="background-image" style="width:70% !important"/>
						<%=SystemEnv.getHtmlLabelName(203, user.getLanguage())%>&nbsp;<input type="text" name="unsel_bgleftwidth" value="<%=unsel_bgleftwidth %>" onBlur="checkWidth(this)"
							r_id="t_unsel_left" r_attr="width" max_width="50" style="width:30px !important"/>px&nbsp;
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(33440, user.getLanguage())%>-</wea:item>
					<wea:item>	
						<input class="filetree" type="text" name="unsel_bgmiddle" value="<%=unsel_bgmiddle %>" 
							r_id="t_unsel_middle" r_attr="background-image" style="width:70% !important"/>&nbsp;
						<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(129035, user.getLanguage())%>">
							<img src="/images/tooltip_wev8.png" align="absMiddle">
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(33440, user.getLanguage())%>-<%=SystemEnv.getHtmlLabelName(22988, user.getLanguage())%></wea:item>
					<wea:item>	
						<input class="filetree" type="text" name="unsel_bgright" value="<%=unsel_bgright %>" 
							r_id="t_unsel_right" r_attr="background-image" style="width:70% !important"/>
						<%=SystemEnv.getHtmlLabelName(203, user.getLanguage())%>&nbsp;<input type="text" name="unsel_bgrightwidth" value="<%=unsel_bgrightwidth %>" onBlur="checkWidth(this)"
							r_id="t_unsel_right" r_attr="width" max_width="50" style="width:30px !important"/>px&nbsp;
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %></wea:item>
					<wea:item attributes="{'colspan':'3'}">
						<input type="text" name="unsel_color" value="<%=unsel_color %>" readonly r_id="t_unsel_middle" r_attr="color"></input> &nbsp;
						<span class="colorpickContainer" >
							<input type="text" name="unsel_color_picker" target="_color"  value="<%=unsel_color %>"></input>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(16197,user.getLanguage()) %></wea:item>
					<wea:item attributes="{'colspan':'3'}">
						<input type="text" name="unsel_fontsize" value="<%=unsel_fontsize %>" target="_number" readonly
							r_id="t_unsel_middle" r_attr="font-size" style="border:none!important; height:20px; width:30px;" ></input>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(16189,user.getLanguage()) %></wea:item>
					<wea:item>
						<input type="text" name="unsel_family" value="<%=unsel_family %>" readonly r_id="t_unsel_middle" r_attr="font-family" />
						<IMG onclick="setFont(this,'unsel_family')" class="setFontImg" src="/images/ecology8/request/search-input_wev8.png" width="16" height="18" />
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(1014,user.getLanguage()) %></wea:item>
					<wea:item>
						<%=SystemEnv.getHtmlLabelName(23002,user.getLanguage()) %>
						<input type="checkbox" name="unsel_bold" <%="1".equals(unsel_bold)?"checked":"" %> r_id="t_unsel_middle" r_attr="font-weight"/>
						<%=SystemEnv.getHtmlLabelName(23003,user.getLanguage()) %>
						<input type="checkbox" name="unsel_italic" <%="1".equals(unsel_italic)?"checked":"" %> r_id="t_unsel_middle" r_attr="font-style"/>
					</wea:item>
				</wea:group>
				<!-- 其他 -->
				<wea:group context='<%=SystemEnv.getHtmlLabelNames("375",user.getLanguage()) %>'>
					<wea:item><%=SystemEnv.getHtmlLabelNames("128091,334",user.getLanguage()) %></wea:item>
					<wea:item>	
						<input class="filetree" type="text" name="image_bg" value="<%=image_bg %>" readonly 
							r_id="t_area" r_attr="background-image" style="width:70% !important"/>&nbsp;
						<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(129038, user.getLanguage())%>">
							<img src="/images/tooltip_wev8.png" align="absMiddle">
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(128092, user.getLanguage())%></wea:item>
					<wea:item>	
						<input class="filetree" type="text" name="image_sep" value="<%=image_sep %>" readonly 
							r_id="t_sep" r_attr="background-image" style="width:70% !important"/>
						<%=SystemEnv.getHtmlLabelName(203, user.getLanguage())%>&nbsp;<input type="text" name="image_sepwidth" value="<%=image_sepwidth %>" onBlur="checkWidth(this)"
							r_id="t_sep" r_attr="width" max_width="10" style="width:30px !important"/>px&nbsp;
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
	</div>
	<div class="rightShowContent">
		<div style="color:#394a71; font-size:14px;">
			<%=SystemEnv.getHtmlLabelName(22974,user.getLanguage())%><!--预览区-->
		</div>
		<div class="style_outside">
			<div class="t_area">
				<div class="t_sel">
					<div class="t_sel_left norepeat"></div>
					<div class="t_sel_middle xrepeat lineheight30"><%=SystemEnv.getHtmlLabelName(128091, user.getLanguage())%>1</div>
					<div class="t_sel_right norepeat"></div>
				</div>
				<div class="t_sep norepeat"></div>
				<div class="t_unsel">
					<div class="t_unsel_left norepeat"></div>
					<div class="t_unsel_middle xrepeat lineheight30"><%=SystemEnv.getHtmlLabelName(128091, user.getLanguage())%>2</div>
					<div class="t_unsel_right norepeat"></div>
				</div>
				<div class="t_sep norepeat"></div>
				<div class="t_unsel">
					<div class="t_unsel_left norepeat"></div>
					<div class="t_unsel_middle xrepeat lineheight30"><%=SystemEnv.getHtmlLabelName(128091, user.getLanguage())%>3</div>
					<div class="t_unsel_right norepeat"></div>
				</div>
			</div>
		</div>
	</div>
</form>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="clostStyleDesign();">			    	
			</wea:item>
		</wea:group>
	</wea:layout>      
</div>
</BODY>
</HTML>
