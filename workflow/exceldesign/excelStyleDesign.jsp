
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<!--For Tab-->
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/spectrum/spectrum_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/js/ecology8/spectrum/spectrum_wev8.css"/>
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<%
	int styleid = Util.getIntValue(request.getParameter("styleid"),-1);
	String stylename = Util.null2String(request.getParameter("stylename"));
	String main_row_height = Util.null2String(request.getParameter("main_row_height"),"30");
	String main_lable_width = Util.null2String(request.getParameter("main_lable_width"),"");
	int main_label_width_select = Util.getIntValue(request.getParameter("main_label_width_select"),0);
	String main_field_width = Util.null2String(request.getParameter("main_field_width"),"");
	int main_field_width_select = Util.getIntValue(request.getParameter("main_field_width_select"),0);
	String main_border = Util.null2String(request.getParameter("main_border"));
	String main_label_bgcolor = Util.null2String(request.getParameter("main_label_bgcolor"));
	String main_field_bgcolor = Util.null2String(request.getParameter("main_field_bgcolor"));
	String detail_row_height = Util.null2String(request.getParameter("detail_row_height"),"30");
	String detail_col_width = Util.null2String(request.getParameter("detail_col_width"),"");
	int detail_col_width_select = Util.getIntValue(request.getParameter("detail_col_width_select"),0);
	String detail_border = Util.null2String(request.getParameter("detail_border"));
	String detail_label_bgcolor = Util.null2String(request.getParameter("detail_label_bgcolor"));
	String detail_field_bgcolor = Util.null2String(request.getParameter("detail_field_bgcolor"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	String isadd = Util.null2String(request.getParameter("isadd"));
	if(styleid != -1 && isclose.equals("")){
		String sql = " select * from excelStyleDec where id="+styleid;
		RecordSet.executeSql(sql);
		while(RecordSet.next()){
			stylename = Util.null2String(RecordSet.getString("stylename"));
			main_row_height = Util.null2String(RecordSet.getString("mainrowheight"),"30");
			main_lable_width = Util.null2String(RecordSet.getString("mainlblwidth"),"");
			main_label_width_select = Util.getIntValue(RecordSet.getString("mainlblwidthselect"),0);
			main_field_width = Util.null2String(RecordSet.getString("mainfieldwidth"),"");
			main_field_width_select = Util.getIntValue(RecordSet.getString("mainfieldwidthselect"),0);
			main_border = Util.null2String(RecordSet.getString("mainborder"));
			main_label_bgcolor = Util.null2String(RecordSet.getString("mainlblbgcolor"));
			main_field_bgcolor = Util.null2String(RecordSet.getString("mainfieldbgcolor"));
			detail_row_height = Util.null2String(RecordSet.getString("detailrowheight"),"30");
			detail_col_width = Util.null2String(RecordSet.getString("detailcolwidth"),"");
			detail_col_width_select = Util.getIntValue(RecordSet.getString("detailcolwidthselect"),0);
			detail_border = Util.null2String(RecordSet.getString("detailborder"));
			detail_label_bgcolor = Util.null2String(RecordSet.getString("detaillblbgcolor"));
			detail_field_bgcolor = Util.null2String(RecordSet.getString("detailfieldbgcolor"));
		}
		
	}
%>
<HTML><HEAD>
	<script type="text/javascript">
		var isclose = "<%=isclose%>";
		var dialog = window.top.getDialog(window);
		if(isclose === "on"){
			var option = {styleid:"<%=styleid%>",isadd:"<%=isadd%>"};
			dialog.close(option);
		}
		jQuery(document).ready(function(){
			$("#fragment-3").hide();
			$(".tab").find("li").bind("click",function(){
				var currentid = $(".selected").attr("href");
				$($(".selected").attr("href")).hide()
				$(".selected").removeClass("selected");
				$(this).addClass("selected");
				$($(this).attr("href")).show();
				if($(this).attr("href") === "#fragment-2"){
					$("div[name=e_style_1]").find("div[name^=_label],div[name^=_field]").css("border-color",$("[name=main_border]").val());
					$("div[name=e_style_1]").find("div[name^=_label]").css("background-color",$("[name=main_label_bgcolor]").val());
					$("div[name=e_style_1]").find("div[name^=_field]").css("background-color",$("[name=main_field_bgcolor]").val());
				}else{
					$("div[name=e_style_1]").find("div[name^=_label],div[name^=_field]").css("border-color",$("[name=detail_border]").val());
					$("div[name=e_style_1]").find("div[name^=_label]").css("background-color",$("[name=detail_label_bgcolor]").val());
					$("div[name=e_style_1]").find("div[name^=_field]").css("background-color",$("[name=detail_field_bgcolor]").val());
				}
			})
			resizeDialog(document);
			$("input[target=_number").spinner({
	            min: 1,
	            max: 1000,
	            step: 1,
	            start: 2,
	            numberFormat: "C",
	            change:function(){
	            	var vthis = $(this);
	            	var wringtype = getMsg(vthis);
	            	if(isNaN(vthis.val())){
	            		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(128031, user.getLanguage())%>"+wringtype+"<%=SystemEnv.getHtmlLabelName(19113, user.getLanguage())%>！");
	            		vthis.val("");
	            	}else{
	            		if(parseInt(vthis.val()) <= 0){
		            		window.top.Dialog.alert(wringtype+"<%=SystemEnv.getHtmlLabelName(128029, user.getLanguage())%>");
		            		vthis.val("");
		            	}
	            	}
	            	controlRequiredImg(vthis);
	            }
	        });
	        
	        $("input[target=_color]").spectrum({
                showPalette:true,
                clickoutFiresChange: false,
                chooseText:"<%=SystemEnv.getHtmlLabelName(826, user.getLanguage())%>",
                cancelText:"<%=SystemEnv.getHtmlLabelName(201, user.getLanguage())%>",
                showInput:true,
                preferredFormat:"hex",
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
                	$(this).closest("td").children().eq(0).val("#"+color.toHex());
                	if($(this).is("[name=main_border_picker]") || $(this).is("[name=detail_border_picker]"))
                	{
                		$("div[name=e_style_1]").find("div[name^=_label],div[name^=_field]").css("border-color","#"+color.toHex());
                	}else if($(this).is("[name=main_label_bgcolor_picker]") || $(this).is("[name=detail_label_bgcolor_picker]"))
                	{
                		$("div[name=e_style_1]").find("div[name^=_label]").css("background-color","#"+color.toHex());
                	}else if($(this).is("[name=main_field_bgcolor_picker]") || $(this).is("[name=detail_field_bgcolor_picker]"))
                	{
                		$("div[name=e_style_1]").find("div[name^=_field]").css("background-color","#"+color.toHex());
                	}
                }
            });
            
            $("div[name=e_style_1]").find("div[name=_label1]").css("border-color",$("[name=main_border]").val()).css("background",$("[name=main_label_bgcolor]").val());
	        $("div[name=e_style_1]").find("div[name=_field1]").css("border-color",$("[name=main_border]").val()).css("background",$("[name=main_field_bgcolor]").val());
		});
		
		function saveAsVersion(){
			if(check_form(weaverform,"stylename,main_row_height,main_lable_width,main_field_width,detail_row_height,detail_col_width")){
				var canSave = true;
				var msg = "";
				if(canSave && jQuery("[name='main_label_width_select']").val()=="2"){
					if(parseInt(jQuery("[name='main_lable_width']").val())>100){
						canSave = false;
						msg = getMsg(jQuery("[name='main_lable_width']"));
					}
				}
				if(canSave && jQuery("[name='main_field_width_select']").val()=="2"){
					if(parseInt(jQuery("[name='main_field_width']").val())>100){
						canSave = false;
						msg = getMsg(jQuery("[name='main_field_width']"));
					}
				}
				if(canSave && jQuery("[name='detail_col_width_select']").val()=="2"){
					if(parseInt(jQuery("[name='detail_col_width']").val())>100){
						canSave = false;
						msg = getMsg(jQuery("[name='detail_col_width']"));
					}
				}
				if(canSave)
					weaverform.submit();
				else
					window.top.Dialog.alert(msg+"<%=SystemEnv.getHtmlLabelName(128032, user.getLanguage())%>");
			}
		}
		
		// ***********************************************************************
		// 函数名 ：checkMaxLength（TD9084）

		// 机能概要 ：对指定字符串按字节长截取，超过时给出提示，超过部分去除
		// 参数说明 ：obj 输入框对象

		// 注意：对象的maxlength、alt须设定，alt为信息内容

		// 返回值 ：

		// ***********************************************************************
		function checkMaxLength(obj){
			var tmpvalue = obj.value;
			if(!tmpvalue){
				if($(obj).parent().find("img"))
					$(obj).parent().find("img").show();
			}else{
				if($(obj).parent().find("img"))
					$(obj).parent().find("img").hide();
			}
			var size = obj.maxLength;
			if(realLength(tmpvalue) > size){
				window.top.Dialog.alert(obj.alt);
				while(true){
					tmpvalue = tmpvalue.substring(0,tmpvalue.length-1);
					if(realLength(tmpvalue)<=size){
						obj.value = tmpvalue;
						return;
					}
				}
			}
		}
		
		/*
		 * Function: 取字符串字节长度 Document by by 2007-3-9
		 */
		function realLength(str) {
			var j=0;
			for (var i=0;i<=str.length-1;i++) {
				j=j+1;
				if ((str.charCodeAt(i))>127) {
					j=j+1;
				}
			}
			return j;
		}
		
		function getMsg(vthis){
			var msg = vthis.closest("div.showarea").attr("_areaname");
			msg += "-";
			msg += vthis.closest("td").prev().find("span").text();
			return msg;
		}
		
		function controlRequiredImg(vthis){
			if(jQuery.trim(vthis.val()) === ""){
				vthis.closest("td").find("img").show();
			}else{
				vthis.closest("td").find("img").hide();
			}
		}
	</script>
	
<style>
	#tab{
		border-bottom: 1px solid #bfc8d6;
		height: 36px;
		margin-bottom: 15px;
		background: #fbfefe;
	}
	
	.tab li{
		float: left;
		width: 112px;
		height: 36px;
		line-height:36px;
		color:#7683a0;
		background: #eff3f7;
		text-align: center;
		list-style: none;
		font-size:14px;
		cursor: pointer;
	}
	
	.selected{
		background:#ffffff!important;
		border-top: 2px solid #00a7ff;
	}
	.zDialog_div_content {
		background: #ebeef0;
	}
	.colorpickContainer .sp-preview {
		margin-right: 0px;
		border:none;
		width:17px;
		height:22px;
	}
	.colorpickContainer .sp-replacer {
		padding: 0px;
		border:none;
		background:#fff;
	}
	.colorpickContainer .sp-dd{
		display:none;
	}
	.colorpickContainer .sp-preview, .sp-alpha, .sp-thumb-el {
		background-image:url("/workflow/exceldesign/image/shortBtn/format/BackgroundColor_wev8.png");
		background-repeat: no-repeat;
	}
	.colorpickContainer .sp-preview-inner {
		top:18px;
		height:4px;
	}
</style>
</HEAD>
<BODY>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(30986, user.getLanguage()) + ",javascript:saveAsVersion(),_self}";
	RCMenuHeight += RCMenuHeightStep;
	%>
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="workflow"/>
	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(128988, user.getLanguage())%>"/>
	</jsp:include> 
	<table id="topTitle" cellpadding="0" cellspacing="0">
		<tr>
			<td></td>
			<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" onclick="saveAsVersion()" class="e8_btn_top" id="btnok">
		      	<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
			</td>
		</tr>
	</table> 
	<form name="weaverform" action="/workflow/exceldesign/excelStyleOperation.jsp" method="post">
	<input type="hidden" name="styleid" value="<%=styleid %>" >
	<input type="hidden" name="method" value="operat" >
	<div class="zDialog_div_content">
		
			<div class="leftSetContent" style="width:50%;background:#fff;height:100%">
				<div style="margin-left:30px;padding-top: 15px;color:#5f708d">
					<span><%=SystemEnv.getHtmlLabelName(19621, user.getLanguage())%></span>
					<span style="padding-left:15px;"><input type="text" name="stylename" style="width:180px;" value="<%=stylename %>" onblur="checkMaxLength(this)" maxlength="200" alt="<%=SystemEnv.getHtmlLabelName(20246,user.getLanguage())%>200(<%=SystemEnv.getHtmlLabelName(20247,user.getLanguage())%>)"></input><img <%=stylename.equals("")?"":"style='display:none'" %>src="/images/BacoError_wev8.gif" align="absMiddle"></span>
				</div>
				<div id="tab" style="margin-top:15px;">
					<ul class="tab">											
						<li class="selected"  href="#fragment-2"><span><%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%><!-- 主表 --></span></li>
						<li href="#fragment-3"><span><%=SystemEnv.getHtmlLabelName(19325,user.getLanguage())%><!-- 明细表 --></span></li>
					</ul>	
				</div>
				<div id="fragment-2" style="width: 100%;" class="showarea" _areaname="<%=SystemEnv.getHtmlLabelName(21778, user.getLanguage()) %>">
					<wea:layout type="menu2col">
						<wea:group context='<%=SystemEnv.getHtmlLabelName(61,user.getLanguage()) %>'><!-- 基本 -->
							<wea:item>
								<span class="left"><%=SystemEnv.getHtmlLabelName(23208,user.getLanguage())%></span><!-- 行高 -->
							</wea:item>
							<wea:item>
								<input type="text" name="main_row_height" style="border:none!important;height:20px;width:50px;" target="_number" value="<%=main_row_height %>" ></input>
								<img src="/images/BacoError_wev8.gif" align=absmiddle style="<%="".equals(main_row_height)?"":"display:none" %>" />
								<span style="padding-left:5px;"><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%>  [<%=SystemEnv.getHtmlLabelName(19206, user.getLanguage())%>:30] </span>
							</wea:item>
							<wea:item>
								<span class="left"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19509,user.getLanguage())%></span><!-- 标签列宽 -->
							</wea:item>
							<wea:item>
								<input type="text" name="main_lable_width" style="border:none!important;height:20px;width:50px;" target="_number" value="<%=main_lable_width %>"></input>
								<img src="/images/BacoError_wev8.gif" align=absmiddle style="<%="".equals(main_lable_width)?"":"display:none" %>" />
								<span><select name="main_label_width_select" onchange="mainlablewidthchange(this)">
									<option value="1" <%=main_label_width_select==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%></option>
									<option value="2" <%=main_label_width_select==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1464,user.getLanguage())%></option>
								</select></span>
							</wea:item>
							<wea:item>
								<span class="left"><%=SystemEnv.getHtmlLabelName(33331,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(19509,user.getLanguage())%></span><!-- 字段列宽 -->
							</wea:item>
							<wea:item>
								<input type="text" name="main_field_width" style="border:none!important;height:20px;width:50px;" target="_number" value="<%=main_field_width %>"></input>
								<img src="/images/BacoError_wev8.gif" align=absmiddle style="<%="".equals(main_field_width)?"":"display:none" %>" />
								<span><select name="main_field_width_select" onchange="mainfieldwidthchange(this)">
									<option value="1" <%=main_field_width_select==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%></option>
									<option value="2" <%=main_field_width_select==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1464,user.getLanguage())%></option>
								</select></span>
							</wea:item>
							
						</wea:group>
						<wea:group context='<%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %>'><!-- 颜色 -->
							<wea:item>
								<span class="left"><%=SystemEnv.getHtmlLabelName(128028, user.getLanguage())%><!-- 边框 --></span>
							</wea:item>
							<wea:item>
								<input type="text" name="main_border" readonly="true" value="<%=main_border.equals("")?"#808080":main_border %>"></input> &nbsp;
								<span class="colorpickContainer">
								<input type="text" name="main_border_picker" target="_color" value="<%=main_border.equals("")?"#808080":main_border %>"></input>
								</span>
							</wea:item>
							<wea:item>
								<span class="left"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22979,user.getLanguage())%><!-- 标签背景 --></span>
							</wea:item>
							<wea:item>
								<input type="text" name="main_label_bgcolor"  readonly="true" value="<%=main_label_bgcolor.equals("")?"#f8f8f8":main_label_bgcolor %>" ></input> &nbsp;
								<span class="colorpickContainer" >
								<input type="text" name="main_label_bgcolor_picker" target="_color"  value="<%=main_label_bgcolor.equals("")?"#f8f8f8":main_label_bgcolor %>"></input>
								</span>
							</wea:item>
							<wea:item>
								<span class="left"><%=SystemEnv.getHtmlLabelName(33331,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22979,user.getLanguage())%><!-- 字段背景 --></span>
							</wea:item>
							<wea:item>
								<input type="text" name="main_field_bgcolor" readonly="true" value="<%=main_field_bgcolor.equals("")?"#ffffff":main_field_bgcolor %>" ></input> &nbsp;
								<span class="colorpickContainer">
								<input type="text" name="main_field_bgcolor_picker" target="_color" value="<%=main_field_bgcolor.equals("")?"#ffffff":main_field_bgcolor %>" ></input>
								</span>
							</wea:item>
							
						</wea:group>
					</wea:layout>	
				</div>
				<div id="fragment-3" style="width: 100%;" class="showarea" _areaname="<%=SystemEnv.getHtmlLabelName(19325, user.getLanguage()) %>">
					<wea:layout type="menu2col">
						<wea:group context='<%=SystemEnv.getHtmlLabelName(61,user.getLanguage()) %>'><!-- 基本 -->
							<wea:item>
								<span class="left"><%=SystemEnv.getHtmlLabelName(23208,user.getLanguage())%></span><!-- 行高 -->
							</wea:item>
							<wea:item>
								<input type="text" name="detail_row_height" style="border:none!important;height:20px;width:50px;" target="_number" value="<%=detail_row_height %>"></input>
								<img src="/images/BacoError_wev8.gif" align=absmiddle style="<%="".equals(detail_row_height)?"":"display:none" %>" />
								<span style="padding-left:5px;"><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%>  [<%=SystemEnv.getHtmlLabelName(19206, user.getLanguage())%>:30] </span>
							</wea:item>
							<wea:item>
								<span class="left"><%=SystemEnv.getHtmlLabelName(19509,user.getLanguage())%></span><!-- 列宽 -->
							</wea:item>
							<wea:item>
								<input type="text" name="detail_col_width" style="border:none!important;height:20px;width:50px;" target="_number" value="<%=detail_col_width %>"></input>
								<img src="/images/BacoError_wev8.gif" align=absmiddle style="<%="".equals(detail_col_width)?"":"display:none" %>" />
								<span><select name="detail_col_width_select" onchange="detailcolwidthchange(this)">
									<option value="1" <%=detail_col_width_select==1?"selected":"" %>><%=SystemEnv.getHtmlLabelName(218,user.getLanguage())%></option>
									<option value="2" <%=detail_col_width_select==2?"selected":"" %>><%=SystemEnv.getHtmlLabelName(1464,user.getLanguage())%></option>
								</select></span>
							</wea:item>
							
						</wea:group>
						<wea:group context='<%=SystemEnv.getHtmlLabelName(495,user.getLanguage()) %>'><!-- 颜色 -->
							<wea:item>
								<span class="left"><%=SystemEnv.getHtmlLabelName(128028, user.getLanguage())%><!-- 边框 --></span>
							</wea:item>
							<wea:item>
								<input type="text" name="detail_border" readonly="true" value="<%=detail_border.equals("")?"#1c1c1c":detail_border %>"></input> &nbsp;
								<span class="colorpickContainer" >
								<input type="text" name="detail_border_picker" target="_color"  value="<%=detail_border.equals("")?"#1c1c1c":detail_border %>"></input>
								</span>
							</wea:item>
							<wea:item>
								<span class="left"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22979,user.getLanguage())%><!-- 标签背景 --></span>
							</wea:item>
							<wea:item>
								<input type="text" name="detail_label_bgcolor"  readonly="true" value="<%=detail_label_bgcolor.equals("")?"#f8f8f8":detail_label_bgcolor %>" ></input> &nbsp;
								<span class="colorpickContainer" >
								<input type="text" name="detail_label_bgcolor_picker" target="_color"  value="<%=detail_label_bgcolor.equals("")?"#f8f8f8":detail_label_bgcolor %>"></input>
								</span>
							</wea:item>
							<wea:item>
								<span class="left"><%=SystemEnv.getHtmlLabelName(33331,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(22979,user.getLanguage())%><!-- 字段背景 --></span>
							</wea:item>
							<wea:item>
								<input type="text" name="detail_field_bgcolor"  readonly="true" value="<%=detail_field_bgcolor.equals("")?"#ffffff":detail_field_bgcolor %>" ></input> &nbsp;
								<span class="colorpickContainer" >
								<input type="text" name="detail_field_bgcolor_picker" target="_color" value="<%=detail_field_bgcolor.equals("")?"#ffffff":detail_field_bgcolor %>"></input>
								</span>
							</wea:item>
							
						</wea:group>
					</wea:layout>		
				</div>
			</div>
			<div class="rightShowContent" style="width:330px;position: absolute;top: 0px;right: 40px;">	
				<div style="color:#394a71;padding-top:15px;margin-bottom:30px;"><%=SystemEnv.getHtmlLabelName(22974,user.getLanguage())%><!--预览区--></div>
				<div name="e_style_1" class="tylelement">
					<div name="_label1" style="width: 100px;height:31px;line-height:31px;float: left;border: 1px solid #f5e1c2;padding-left: 7px;background:#fcf6e8"><%=SystemEnv.getHtmlLabelName(31644, user.getLanguage())%></div>
					<div name="_field1" style="border: 1px solid #f5e1c2;padding-left: 115px;height:31px;line-height:31px;"><%=SystemEnv.getHtmlLabelName(33473, user.getLanguage())%></div>
					<div name="_label1" style="float: left;width: 100px;height:31px;line-height:31px;border: 1px solid #f5e1c2;padding-left: 7px;margin-top: -1px;background:#fcf6e8;"><%=SystemEnv.getHtmlLabelName(31644, user.getLanguage())%></div>
					<div name="_field1" style="border: 1px solid #f5e1c2;margin-top: -1px;padding-left: 115px;height:31px;line-height:31px;"><%=SystemEnv.getHtmlLabelName(33473, user.getLanguage())%></div>
					<div name="_label1" style="width: 155px;height:31px;line-height:31px;float: left;border: 1px solid #f5e1c2;padding-left: 10px;background:#fcf6e8;margin-top: -1px;"><%=SystemEnv.getHtmlLabelName(31644, user.getLanguage())%></div>
					<div name="_label1" style="border: 1px solid #f5e1c2;padding-left: 175px;margin-top: -1px;background:#fcf6e8;height:31px;line-height:31px;"><%=SystemEnv.getHtmlLabelName(31644, user.getLanguage())%></div>
					<div name="_field1" style="float: left;width: 155px;border: 1px solid #f5e1c2;padding-left: 10px;margin-top: -1px;height:31px;line-height:31px;"><%=SystemEnv.getHtmlLabelName(33473, user.getLanguage())%></div>
					<div name="_field1" style="border: 1px solid #f5e1c2;margin-top: -1px;padding-left: 175px;height:31px;line-height:31px;"><%=SystemEnv.getHtmlLabelName(33473, user.getLanguage())%></div>
				</div>
			</div>
		
	</div>
	</form>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{groupDisplay:none}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.close();">			    	
				</wea:item>
			</wea:group>
		</wea:layout>      
	</div>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
</BODY>
</HTML>
