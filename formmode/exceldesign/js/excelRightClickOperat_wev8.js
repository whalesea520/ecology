var rightClickOperat=(function (){
	
	var dialog = window.top.getDialog(parent);
	var parentWin = parent.parent.getParentWindow(parent);
	// 页面全局变量，存储改变的设置信息
	var numberJson;		
	var alignJson;
	var fontJson;
	var borderJson;
	var bgfillJson;
	
	//数值Tab 页 设置统一方法
	function onSetNumber(obj){
		var n_set = "1";
		var n_decimals = "";
		var n_us = "";
		var n_target = "";
		var numberTab = jQuery(".numberTab");
		var n_set = numberTab.find(".leftClassify .fmlist ul li.current").attr("target");
		if(n_set === "2"){
			n_decimals = $("#n_decimals").val();
			n_us = $("#n_us").is(":checked")?"1":"0";
			n_target = numberTab.find(".rightSetting .numerical .fmlist ul li.current").attr("pro_index");
		}else if(n_set === "3")
			n_target = numberTab.find(".rightSetting .date .fmlist ul li.current").attr("pro_index");
		else if(n_set === "4")
			n_target = numberTab.find(".rightSetting .time .fmlist ul li.current").attr("pro_index");
		else if(n_set === "5")
			n_decimals = $("#p_decimals").val();
		else if(n_set === "6")
			n_decimals = $("#s_decimals").val();
		else if(n_set === "8")
			n_target = numberTab.find(".rightSetting .special .fmlist ul li.current").attr("pro_index");
		numberJson = {n_set:n_set,n_decimals:n_decimals,n_us:n_us,n_target:n_target};
	}
	
	//对齐Tab 页 设置 统一方法
	function onSetAlign(obj){
		var a_halign = $("#halign").val();
		var a_valign = $("#valign").val();
		var a_autowrap = $("#autowrap").is(":checked");
		var a_mergen = $("#mergebox").is(":checked");
		alignJson = {a_halign:a_halign,a_valign:a_valign,a_autowrap:a_autowrap,a_mergen:a_mergen};
	}
	
	//字体Tab 页 设置 统一方法
	function onSetFont(obj){
		obj = jQuery(obj);
		var f_family = "";
		var f_size = "";
		var f_color = "";
		var f_style = "";
		var f_underline = "";
		var f_deleteline = "";
		if(!fontJson)fontJson={};
		var objId = obj.attr("id");
		if(objId === "fontfamily"){
			f_family = $("#fontfamily").val();
			fontJson.f_family = f_family;
		}else if(objId === "fontStyle"){
			f_style = $("#fontStyle").val();
			fontJson.f_style = f_style;
		}else if(objId === "fontSize"){
			f_size = $("#fontSize").val();
			fontJson.f_size = f_size;
		}else if(objId === "fontcolor"){
			f_color = obj.children("[name=_fontcolor]").val();
			fontJson.f_color = f_color;
		}else if(objId === "underline"){
			f_underline = $("#underline").is(":checked");
			fontJson.f_underline = f_underline;
		}else if(objId === "deleteline"){
			f_deleteline = $("#deleteline").is(":checked");
			fontJson.f_deleteline = f_deleteline;
		}
		//fontJson={f_family:f_family,f_size:f_size,f_color:f_color,f_style:f_style,f_underline:f_underline,f_deleteline:f_deleteline}
		setFontPreviewShow(fontJson);
	}
	//设置字体预览
	function setFontPreviewShow(fontJson){
		jQuery("#fontshow").css("color",fontJson.f_color).css("font-size",fontJson.f_size);
		document.getElementById("fontshow").style.cssText+="font-family:"+(fontJson.f_family?fontJson.f_family:"Arial")+"!important;";
		var fontstr = jQuery("#fontshow").parent().html();
		jQuery(".fontPreview").html("");
		var tempstr = "";
		tempstr = (fontJson.f_underline?"<u>":"")+(fontJson.f_deleteline?"<del>":"")+fontstr+(fontJson.f_deleteline?"</del>":"")+(fontJson.f_underline?"</u>":"");
		if(fontJson.f_style === "0");
		else if(fontJson.f_style === "1"){
			tempstr ="<i>"+tempstr+"</i>";
		}else if(fontJson.f_style === "2"){
			tempstr = "<strong>"+tempstr+"</strong>";
		}else if(fontJson.f_style === "3")
			tempstr = "<i><strong>"+tempstr+"</strong></i>";
		
		jQuery(".fontPreview").html(tempstr);
	}
	
	//边框Tab 页 设置统一方法
	function onSetBorder(obj){
		var b_top;
		var b_horize;
		var b_bottom;
		var b_left;
		var b_vertic;
		var b_right;
		if(!!borderJson){
			if(!!borderJson.b_top)b_top=borderJson.b_top;
			if(!!borderJson.b_horize)b_horize=borderJson.b_horize;
			if(!!borderJson.b_bottom)b_bottom=borderJson.b_bottom;
			if(!!borderJson.b_left)b_left=borderJson.b_left;
			if(!!borderJson.b_vertic)b_vertic=borderJson.b_vertic;
			if(!!borderJson.b_right)b_right=borderJson.b_right;
		}
		if($(obj).is(".opBtn_s")){
			if($(obj).is(".opBtn_down"))
				$(obj).removeClass("opBtn_down").removeAttr("down").removeAttr("t_value").removeAttr("t_color");
			else{
				$(obj).addClass("opBtn_down").attr("down","on").attr("t_value",$(".borderTab .fmlist ul li.current").attr("value"))
					.attr("t_color",$(".borderTab [name=_bordercolor]").val());
			}
		}
		var border = $(".borderTab .fmlist ul li.current").attr("target")+" "+$(".borderTab [name=_bordercolor]").val();
		//多选单元格
		if(bxsize > 1){
			if($(obj).is("#borderTop") || $(obj).is("[name='outside']") || $(obj).is("[name='nonside']")){
				if($("#borderTop").is(".opBtn_down")){
					$("[name=onebx],[name=twobx]").css("border-top",border);
					b_top = {borderval:"top",bordercolor:$("#borderTop").attr("t_color"),borderstyle:$("#borderTop").attr("t_value")};
				}else{
					$("[name=onebx],[name=twobx]").css("border-top","");
					b_top = null;
				}
			}
			if($(obj).is("#borderBottom") || $(obj).is("[name='outside']") || $(obj).is("[name='nonside']")){
				if($("#borderBottom").is(".opBtn_down")){
					$("[name=thrbx],[name=forbx]").css("border-bottom",border);
					b_bottom = {borderval:"bottom",bordercolor:$("#borderBottom").attr("t_color"),borderstyle:$("#borderBottom").attr("t_value")};
				}else {
					$("[name=thrbx],[name=forbx]").css("border-bottom","");
					b_bottom = null;
				}
			}
			if($(obj).is("#borderLeft") || $(obj).is("[name='outside']") || $(obj).is("[name='nonside']")){
				if($("#borderLeft").is(".opBtn_down")){
					$("[name=thrbx],[name=onebx]").css("border-left",border);
					b_left = {borderval:"left",bordercolor:$("#borderLeft").attr("t_color"),borderstyle:$("#borderLeft").attr("t_value")};
				}else{
					$("[name=thrbx],[name=onebx]").css("border-left","");
					b_left = null;
				}
			}
			if($(obj).is("#borderRight") || $(obj).is("[name='outside']") || $(obj).is("[name='nonside']")){
				if($("#borderRight").is(".opBtn_down")){
					$("[name=twobx],[name=forbx]").css("border-right",border);
					b_right = {borderval:"right",bordercolor:$("#borderRight").attr("t_color"),borderstyle:$("#borderRight").attr("t_value")};
				}else{
					$("[name=twobx],[name=forbx]").css("border-right","");
					b_right = null;
				}
			}
			if($(obj).is("#borderHorize") || $(obj).is("[name='innside']") || $(obj).is("[name='nonside']")){
				if($("#borderHorize").is(".opBtn_down")){
					$("[name=onebx],[name=twobx]").css("border-bottom",border);
					$("[name=thrbx],[name=forbx]").css("border-top",border);
					b_horize = {borderval:"hinside",bordercolor:$("#borderHorize").attr("t_color"),borderstyle:$("#borderHorize").attr("t_value")};
				}else{
					$("[name=onebx],[name=twobx]").css("border-bottom","");
					$("[name=thrbx],[name=forbx]").css("border-top","");
					b_horize = null;
				}
			}
			if($(obj).is("#borderVertic") || $(obj).is("[name='innside']") || $(obj).is("[name='nonside']")){
				if($("#borderVertic").is(".opBtn_down")){
					$("[name=thrbx],[name=onebx]").css("border-right",border);
					$("[name=twobx],[name=forbx]").css("border-left",border);
					b_vertic = {borderval:"vinside",bordercolor:$("#borderVertic").attr("t_color"),borderstyle:$("#borderVertic").attr("t_value")};
				}else {
					$("[name=thrbx],[name=onebx]").css("border-right","");
					$("[name=twobx],[name=forbx]").css("border-left","");
					b_vertic = null;
				}
			}
		}else if(bxsize == 1){
			if($(obj).is("#borderTop") || $(obj).is("[name='outside']") || $(obj).is("[name='nonside']")){
				if($("#borderTop").is(".opBtn_down")){
					$("[name=onebx]").css("border-top",border);
					b_top = {borderval:"top",bordercolor:$("#borderTop").attr("t_color"),borderstyle:$("#borderTop").attr("t_value")};
				}else{
					$("[name=onebx]").css("border-top","");
					b_top = null;
				}
			}
			if($(obj).is("#borderBottom") || $(obj).is("[name='outside']") || $(obj).is("[name='nonside']")){
				if($("#borderBottom").is(".opBtn_down")){
					$("[name=onebx]").css("border-bottom",border);
					b_bottom = {borderval:"bottom",bordercolor:$("#borderBottom").attr("t_color"),borderstyle:$("#borderBottom").attr("t_value")};
				}else{
					$("[name=onebx]").css("border-bottom","");
					b_bottom = null;
				}
			}
			if($(obj).is("#borderLeft") || $(obj).is("[name='outside']") || $(obj).is("[name='nonside']")){
				if($("#borderLeft").is(".opBtn_down")){
					$("[name=onebx]").css("border-left",border);
					b_left = {borderval:"left",bordercolor:$("#borderLeft").attr("t_color"),borderstyle:$("#borderLeft").attr("t_value")};
				}else {
					$("[name=onebx]").css("border-left","");
					b_left = null;
				}
			}
			if($(obj).is("#borderRight") || $(obj).is("[name='outside']") || $(obj).is("[name='nonside']")){
				if($("#borderRight").is(".opBtn_down")){
					$("[name=onebx]").css("border-right",border);
					b_right = {borderval:"right",bordercolor:$("#borderRight").attr("t_color"),borderstyle:$("#borderRight").attr("t_value")};
				}else {
					$("[name=onebx]").css("border-right","");
					b_right = null;
				}
			}
		}
		var bordershow = jQuery(".opDrawShow").html();
		jQuery(".opDrawShow").html("");
		jQuery(".opDrawShow").html(bordershow);
		borderJson = {b_top:b_top,b_bottom:b_bottom,b_left:b_left,b_right:b_right,b_horize:b_horize,b_vertic:b_vertic}
	}
	
	//设置背景
	function onSetBgfill(obj){
		var color = obj.attr("data-color");
		bgfillJson = {backgroundcolor:color};
	}
	
	//初始布局后根据选中 “活动单元格”的样式给各组件赋值;
    function initPanelElementVal(){
    	var cellDataObj = parentWin.baseOperate.getActiveCellDataObj();
		//设置数字面板
		if(cellDataObj && cellDataObj.enumbric && cellDataObj.enumbric.n_set){
			var n_set = cellDataObj.enumbric.n_set;
	       	var n_decimals = cellDataObj.enumbric.n_decimals;
	       	var n_us = cellDataObj.enumbric.n_us;
	       	var n_target = cellDataObj.enumbric.n_target;
	       	$(".numberTab .leftClassify ul li[target=1]").removeClass("current");
	       	$(".numberTab .rightSetting .numberlist[target=1]").hide();
	       	$(".numberTab .leftClassify ul li[target="+n_set+"]").addClass("current");
	       	$(".numberTab .rightSetting .numberlist[target="+n_set+"]").show();
			if(n_set === "2"){
				if(n_decimals != "")
		       		$("#n_decimals").val(n_decimals);
		       	if(n_us != "" && n_us==="1"){
			       	$("#n_us").attr("checked",true).next().addClass("jNiceChecked");
			       	//changeCheckboxStatus($("#n_us"),n_us==="1"?true:false);
		       	}
	       		if(n_target != ""){
			       	$(".numerical .fmlist ul li[pro_index=2]").removeClass("current");
			       	$(".numerical .fmlist ul li[pro_index="+n_target+"]").addClass("current");
		       	}
	       	}else if(n_set === "3"){
	       		if(n_target != ""){
		       		$(".date .fmlist ul li[pro_index=1]").removeClass("current");	
		       		$(".date .fmlist ul li[pro_index="+n_target+"]").addClass("current");	
		       	}
	       	}else if(n_set === "4"){
	       		$(".time .fmlist ul li[pro_index=1]").removeClass("current");	
	       		$(".time .fmlist ul li[pro_index="+n_target+"]").addClass("current");	
	       	}else if(n_set === "5"){
	       		if(n_decimals != "")
	       			$("#p_decimals").val(n_decimals);
	       	}else if(n_set === "6"){
	       		if(n_decimals != "")
	       			$("#s_decimals").val(n_decimals);
	       	}else if(n_set === "8"){
	       		$(".special .fmlist ul li[pro_index=1]").removeClass("current");	
	       		$(".special .fmlist ul li[pro_index="+n_target+"]").addClass("current");	
	       	}
		}
		var cellStyle = parentWin.baseOperate.getActiveCellStyle();
		//设置对齐模板
		$(".alignTab select").selectbox("detach");
		$("#halign").val(cellStyle.halign);
		$("#valign").val(cellStyle.valign);
		$(".alignTab select").selectbox("attach");
    	var hasmergen = parentWin.baseOperate.getIsMergenBxFace();
	    if(hasmergen)
			$("#mergebox").attr("checked",true).next().addClass("checked");
		//设置字体模板
		var fontfamliy = cellStyle.fontfamliy;
		var fontsize = cellStyle.fontsize;
		var fontcolor = cellStyle.fontcolor ? cellStyle.fontcolor : "";
		var isunderline = cellStyle.isunderline;
		var isdeleteline = cellStyle.isdeleteline;
		var fontstyle = "0";
		if(!cellStyle.isbold && cellStyle.isitalic)
			fontstyle = "1";
		else if(cellStyle.isbold && !cellStyle.isitalic)
			fontstyle = "2";
		else if(cellStyle.isbold && cellStyle.isitalic)
			fontstyle = "3";
		$(".fontTab select").selectbox("detach");
		$("#fontfamily").val(fontfamliy);
		$("#fontSize").val(fontsize);
		$("#fontStyle").val(fontstyle);
		$(".fontTab select").selectbox("attach");
		if(!!fontcolor){
			$(".fontTab [name=_fontcolor]").val(fontcolor);
			$("#fontcolor").css("background", fontcolor);
		}
		if(isunderline)
			$("#underline").attr("checked", true).next().addClass("checked");
		if(isdeleteline)
			$("#deleteline").attr("checked", true).next().addClass("checked");
		fontJson={"f_family":fontfamliy, "f_size":fontsize, "f_color":fontcolor, "f_style":fontstyle, "f_underline":isunderline, "f_deleteline":isdeleteline};
		setFontPreviewShow(fontJson);	//底部预览
		//设置边框面板
		setPanelBorder();
		//设置填充模板
        if(cellStyle.bgcolor)
			$(".sp-palette").find(".sp-thumb-el[data-color='"+cellStyle.bgcolor+"']").addClass("sp-thumb-active");
	}
	
	//反向设置 边框面板
	function setPanelBorder(){
		var borderMap = parentWin.baseOperate.getActiveCellBorder();
		if(!borderMap) return;
		var borderMap2 = parentWin.baseOperate.getAllCellBorder();
		if(borderMap2.left){
		 	$(".borderTab").find(".fmlist ul li.current").removeClass("current");
			$(".borderTab").find(".fmlist ul li[value="+borderMap2.left.style+"]").addClass("current");
			$(".borderTab").find("#bordercolor").css("background",borderMap2.left.color);
			$(".borderTab").find("#bordercolor").children("input[name=_bordercolor]").val(borderMap2.left.color);
			$("#borderLeft").trigger("click");
	 	}
		if(borderMap2.right){
			$(".borderTab").find(".fmlist ul li.current").removeClass("current");
			$(".borderTab").find(".fmlist ul li[value="+borderMap2.right.style+"]").addClass("current");
			$(".borderTab").find("#bordercolor").css("background",borderMap2.right.color);
			$(".borderTab").find("#bordercolor").children("input[name=_bordercolor]").val(borderMap2.right.color);
			$("#borderRight").trigger("click");
			if(bxsize > 1)
				$("#borderVertic").trigger("click");
		} 
		if(borderMap2.top){
			$(".borderTab").find(".fmlist ul li.current").removeClass("current");
			$(".borderTab").find(".fmlist ul li[value="+borderMap2.top.style+"]").addClass("current");
			$(".borderTab").find("#bordercolor").css("background",borderMap2.top.color);
			$(".borderTab").find("#bordercolor").children("input[name=_bordercolor]").val(borderMap2.top.color);
			$("#borderTop").trigger("click");
		}
		if(borderMap2.bottom){
			$(".borderTab").find(".fmlist ul li.current").removeClass("current");
			$(".borderTab").find(".fmlist ul li[value="+borderMap2.bottom.style+"]").addClass("current");
			$(".borderTab").find("#bordercolor").css("background",borderMap2.bottom.color);
			$(".borderTab").find("#bordercolor").children("input[name=_bordercolor]").val(borderMap2.bottom.color);
			$("#borderBottom").trigger("click");
			if(bxsize > 1)
				$("#borderHorize").trigger("click");
		}
		$(".borderTab").find(".fmlist ul li.current").removeClass("current");
		$(".borderTab").find(".fmlist ul li[value="+borderMap.style+"]").addClass("current");
		$(".borderTab").find("#bordercolor").css("background",borderMap.color);
		$(".borderTab").find("#bordercolor").children("input[name=_bordercolor]").val(borderMap.color);
	}
	
    return {
    	initSetFormatPanel:function(){
    		//数字tab页 分类切换
			$(".numberTab .leftClassify ul li").click(function(){
				if($(this).is(".current"))
					return;
				$(".numberTab .leftClassify ul li").each(function(){
					$(this).removeClass("current");
				});
				$(this).addClass("current");
				//先隐藏所有的分类 具体设置div
				$(".rightSetting").children("div").hide();
				if($(this).attr("target") === "1")	//常规
					$(".rightSetting .general").show();
				else if($(this).attr("target") === "2")//数值
					$(".rightSetting .numerical").show();
				else if($(this).attr("target") === "3")//日期
					$(".rightSetting .date").show();
				else if($(this).attr("target") === "4")//时间
					$(".rightSetting .time").show();
				else if($(this).attr("target") === "5")//百分比
					$(".rightSetting .percent").show();
				else if($(this).attr("target") === "6")//科学记数
					$(".rightSetting .science").show();
				else if($(this).attr("target") === "7")//文本
					$(".rightSetting .textversion").show();
				else if($(this).attr("target") === "8")//特殊
					$(".rightSetting .special").show();
			});
			
			$("[name=decimals").spinner({
	            min: 0,
	            max: 30,
	            step: 1,
	            start: 2,
	            numberFormat: "C",
	            change:function(){
	            	onSetNumber(this);
	            }
	        });
	        
	        $(".numberTab .rightSetting ul li").click(function(){
				if($(this).is(".current"))
					return;
				$(this).closest(".fmlist").find("ul li").each(function(){
					$(this).removeClass("current");
				});
				$(this).addClass("current");
				onSetNumber(this);
			});
			$(".borderTab .fmlist ul li").click(function(){
				if($(this).is(".current"))
					return;
				$(this).closest(".fmlist").find("ul li").each(function(){
					$(this).removeClass("current");
				});
				$(this).addClass("current");
			});
			
			jQuery(".formatTab").find("[name=colorpick4bx]").spectrum({
                showPalette:true,
                chooseText:"确定",
                cancelText:"取消",
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
                show: function() {
                },
                hide: function(color) {
                    $(this).css("background",color.toHexString());
                    $(this).find("[type=hidden]").val(color.toHexString());
                    if($(this).is("#fontcolor"))
                    	onSetFont(this);
                    else if($(this).is("#bordercolor"))
                    	onSetBorder(this);
                }
            }).click(function(){
            	$(this).spectrum("set", $(this).find("[type=hidden]").val());
            });
            //根据活动单元格的样式给各组件赋值;
            initPanelElementVal();
	       		
	       	//取色器初始化 
			jQuery(".bgfillTab").find("[name=colorpick4bx]").spectrum({
                showPalette:true,
                flat:true,
                showPaletteOnly:true,
                togglePaletteOnly:true,
                togglePaletteMoreText:"更多颜色",
                togglePaletteLessText:"更多颜色",
                palette:[
                   ["#000000", "#434343", "#666666", "#999999", "#b7b7b7", "#cccccc", "#d9d9d9", "#efefef", "#f3f3f3", "#ffffff"],
                   ["#980000", "#ff0000", "#ff9900", "#ffff00", "#00ff00", "#00ffff", "#4a86e8", "#0000ff", "#9900ff", "#ff00ff"],
                   ["#e6b8af", "#f4cccc", "#fce5cd", "#fff2cc", "#d9ead3", "#d9ead3", "#c9daf8", "#cfe2f3", "#d9d2e9", "#ead1dc"],
                   ["#dd7e6b", "#ea9999", "#f9cb9c", "#ffe599", "#b6d7a8", "#a2c4c9", "#a4c2f4", "#9fc5e8", "#b4a7d6", "#d5a6bd"],
                   ["#cc4125", "#e06666", "#f6b26b", "#ffd966", "#93c47d", "#76a5af", "#6d9eeb", "#6fa8dc", "#8e7cc3", "#c27ba0"],
                   ["#a61c00", "#cc0000", "#e69138", "#f1c232", "#6aa84f", "#45818e", "#3c78d8", "#3d85c6", "#674ea7", "#a64d79"],
                   ["#85200c", "#990000", "#b45f06", "#bf9000", "#38761d", "#134f5c", "#1155cc", "#0b5394", "#351c75", "#741b47"],
                   ["#5b0f00", "#660000", "#783f04", "#7f6000", "#274e13", "#0c343d", "#1c4587", "#073763", "#20124d", "#4c1130"]
               ]
            });
    	},
    	//保存格式
    	onsavesetting:function (obj){
			onSetNumber(obj);	//调用设置数值tab页统一设置方法
			onSetAlign(obj);	//对齐tab页
			
			var returnjson = {numberJson:numberJson,alignJson:alignJson,fontJson:fontJson,borderJson:borderJson,bgfillJson:bgfillJson};
			if(dialog){
				dialog.close(returnjson);
			}
		},
		oncancelsetting:function(obj){
			if(dialog){
				dialog.close();
			}
		},
		//设置字体方法
		onSetFontFace:function(obj){
			onSetFont(obj);
		},
		//设置边框 接口
		onSetBorderFace:function(obj){
			onSetBorder(obj)
		},
		onSetBgfillFace:function(obj){
			onSetBgfill(obj);
		}
    };
})();
