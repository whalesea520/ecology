var tabPage = (function(){
	var sysDefault = {
		"sel_bgleftwidth" : "10",
		"sel_bgrightwidth" : "10",
		"sel_fontsize" : "12",
		"unsel_bgleftwidth" : "10",
		"unsel_bgrightwidth" : "10",
		"unsel_fontsize" : "12"
	};
	
	var sysStyle = {
		"style-1" : {
			"styleid" : "-1",
			"stylename" : "系统样式一",
			"image_bg" : "/formmode/exceldesign/image/systab/4_image_bg.png",
			"image_sepwidth" : "1",
			"sel_bgleft" : "/formmode/exceldesign/image/systab/4_sel_bgleft.png",
			"sel_bgmiddle" : "/formmode/exceldesign/image/systab/4_sel_bgmiddle.png",
			"sel_bgright" : "/formmode/exceldesign/image/systab/4_sel_bgright.png",
			"unsel_bgleft" : "/formmode/exceldesign/image/systab/4_unsel_bgleft.png",
			"unsel_bgmiddle" : "/formmode/exceldesign/image/systab/4_unsel_bgmiddle.png",
			"unsel_bgright" : "/formmode/exceldesign/image/systab/4_unsel_bgleft.png"
		},
		"style-2" : {
			"styleid" : "-2",
			"stylename" : "系统样式二",
			"image_bg" : "/formmode/exceldesign/image/systab/2_image_bg.png",
			"image_sepwidth" : "1",
			"sel_bgleft" : "/formmode/exceldesign/image/systab/2_sel_bgleft.png",
			"sel_bgmiddle" : "/formmode/exceldesign/image/systab/2_sel_bgmiddle.png",
			"sel_bgright" : "/formmode/exceldesign/image/systab/2_sel_bgright.png",
			"unsel_bgleft" : "/formmode/exceldesign/image/systab/2_unsel_bgleft.png",
			"unsel_bgmiddle" : "/formmode/exceldesign/image/systab/2_unsel_bgmiddle.png",
			"unsel_bgright" : "/formmode/exceldesign/image/systab/2_unsel_bgright.png"
		},
		"style-3" : {
			"styleid" : "-3",
			"stylename" : "系统样式三",
			"image_bg" : "/formmode/exceldesign/image/systab/3_image_bg.png",
			"image_sepwidth" : "1",
			"sel_bgleft" : "/formmode/exceldesign/image/systab/3_sel_bgleft.png",
			"sel_bgmiddle" : "/formmode/exceldesign/image/systab/3_sel_bgmiddle.png",
			"sel_bgright" : "/formmode/exceldesign/image/systab/3_sel_bgleft.png",
			"unsel_bgleft" : "/formmode/exceldesign/image/systab/3_unsel_bgleft.png",
			"unsel_bgmiddle" : "/formmode/exceldesign/image/systab/3_unsel_bgmiddle.png",
			"unsel_bgright" : "/formmode/exceldesign/image/systab/3_unsel_bgleft.png"
		},
		"style-4" : {
			"styleid" : "-4",
			"stylename" : "系统样式四",
			"image_bg" : "/formmode/exceldesign/image/systab/1_image_bg.png",
			"image_sep" : "/formmode/exceldesign/image/systab/1_image_sep.png",
			"image_sepwidth" : "1",
			"sel_bgleft" : "/formmode/exceldesign/image/systab/1_sel_bgleft.png",
			"sel_bgmiddle" : "/formmode/exceldesign/image/systab/1_sel_bgmiddle.png",
			"sel_bgright" : "/formmode/exceldesign/image/systab/1_sel_bgright.png",
			"unsel_bgleft" : "/formmode/exceldesign/image/systab/1_unsel_bgleft.png",
			"unsel_bgmiddle" : "/formmode/exceldesign/image/systab/1_unsel_bgmiddle.png",
			"unsel_bgright" : "/formmode/exceldesign/image/systab/1_unsel_bgright.png"
		},
		"style-5" : {
			"styleid" : "-5",
			"stylename" : "系统样式五",
			"image_bg" : "/formmode/exceldesign/image/systab/5_image_bg.png",
			"image_sep" : "/formmode/exceldesign/image/systab/5_image_sep.png",
			"image_sepwidth" : "1",
			"sel_bgleft" : "/formmode/exceldesign/image/systab/5_sel_bgleft.png",
			"sel_bgmiddle" : "/formmode/exceldesign/image/systab/5_sel_bgmiddle.png",
			"sel_bgright" : "/formmode/exceldesign/image/systab/5_sel_bgright.png",
			"unsel_bgleft" : "/formmode/exceldesign/image/systab/5_unsel_bgleft.png",
			"unsel_bgmiddle" : "/formmode/exceldesign/image/systab/5_unsel_bgmiddle.png",
			"unsel_bgright" : "/formmode/exceldesign/image/systab/5_unsel_bgright.png"
		},
		"style-6" : {
			"styleid" : "-6",
			"stylename" : "系统样式六",
			"image_bg" : "/formmode/exceldesign/image/systab/6_image_bg.png",
			"image_sepwidth" : "1",
			"sel_bgleft" : "/formmode/exceldesign/image/systab/6_sel_bgleft.png",
			"sel_bgmiddle" : "/formmode/exceldesign/image/systab/6_sel_bgmiddle.png",
			"sel_bgright" : "/formmode/exceldesign/image/systab/6_sel_bgleft.png",
			"unsel_bgleft" : "/formmode/exceldesign/image/systab/6_unsel_bgleft.png",
			"unsel_bgmiddle" : "/formmode/exceldesign/image/systab/6_unsel_bgmiddle.png",
			"unsel_bgright" : "/formmode/exceldesign/image/systab/6_unsel_bgleft.png"
		}
	}
	
	
	function getDivStyle_ByStyle(stylejson){
		var t_area="",t_sep="";
		var t_sel_left="",t_sel_middle="",t_sel_right="";
		var t_unsel_left="",t_unsel_middle="",t_unsel_right="";
		if(stylejson.image_bg && stylejson.image_bg!="")
			t_area += "background-image:url('"+stylejson.image_bg+"') !important; ";
		if(stylejson.image_sep && stylejson.image_sep!="")
			t_sep += "background-image:url('"+stylejson.image_sep+"') !important; ";
		if(stylejson.image_sepwidth && stylejson.image_sepwidth!="")
			t_sep += "width:"+stylejson.image_sepwidth+"px !important; ";
			
		if(stylejson.sel_bgleft && stylejson.sel_bgleft!="")
			t_sel_left += "background-image:url('"+stylejson.sel_bgleft+"')!important; ";
		if(stylejson.sel_bgleftwidth && stylejson.sel_bgleftwidth!="")
			t_sel_left += "width:"+stylejson.sel_bgleftwidth+"px !important; ";
		if(stylejson.sel_bgmiddle && stylejson.sel_bgmiddle!="")
			t_sel_middle += "background-image:url('"+stylejson.sel_bgmiddle+"')!important; ";
		if(stylejson.sel_bgright && stylejson.sel_bgright!="")
			t_sel_right += "background-image:url('"+stylejson.sel_bgright+"')!important; ";
		if(stylejson.sel_bgrightwidth && stylejson.sel_bgrightwidth!="")
			t_sel_right += "width:"+stylejson.sel_bgrightwidth+"px !important; ";
		if(stylejson.sel_color && stylejson.sel_color!="")
			t_sel_middle += "color:"+stylejson.sel_color+"!important;";
		if(stylejson.sel_fontsize && stylejson.sel_fontsize!="")
			t_sel_middle += "font-size:"+stylejson.sel_fontsize+"px!important;";
		if(stylejson.sel_family && stylejson.sel_family!="")
			t_sel_middle += "font-family:"+stylejson.sel_family+"!important;";
		if(stylejson.sel_bold && stylejson.sel_bold=="1")
			t_sel_middle += "font-weight:bold!important;";
		if(stylejson.sel_italic && stylejson.sel_italic=="1")
			t_sel_middle += "font-style:italic!important;";
			
		if(stylejson.unsel_bgleft && stylejson.unsel_bgleft!="")
			t_unsel_left += "background-image:url('"+stylejson.unsel_bgleft+"')!important; ";
		if(stylejson.unsel_bgleftwidth && stylejson.unsel_bgleftwidth!="")
			t_unsel_left += "width:"+stylejson.unsel_bgleftwidth+"px !important; ";
		if(stylejson.unsel_bgmiddle && stylejson.unsel_bgmiddle!="")
			t_unsel_middle += "background-image:url('"+stylejson.unsel_bgmiddle+"')!important; ";
		if(stylejson.unsel_bgright && stylejson.unsel_bgright!="")
			t_unsel_right += "background-image:url('"+stylejson.unsel_bgright+"')!important; ";
		if(stylejson.unsel_bgrightwidth && stylejson.unsel_bgrightwidth!="")
			t_unsel_right += "width:"+stylejson.unsel_bgrightwidth+"px !important; ";
		if(stylejson.unsel_color && stylejson.unsel_color!="")
			t_unsel_middle += "color:"+stylejson.unsel_color+"!important;";
		if(stylejson.unsel_fontsize && stylejson.unsel_fontsize!="")
			t_unsel_middle += "font-size:"+stylejson.unsel_fontsize+"px!important;";
		if(stylejson.unsel_family && stylejson.unsel_family!="")
			t_unsel_middle += "font-family:"+stylejson.unsel_family+"!important;";
		if(stylejson.unsel_bold && stylejson.unsel_bold=="1")
			t_unsel_middle += "font-weight:bold!important;";
		if(stylejson.unsel_italic && stylejson.unsel_italic=="1")
			t_unsel_middle += "font-style:italic!important;";
			
		var divstyle = {};
		divstyle.t_area = t_area;
		divstyle.t_sep = t_sep;
		divstyle.t_sel_left = t_sel_left;
		divstyle.t_sel_middle = t_sel_middle;
		divstyle.t_sel_right = t_sel_right;
		divstyle.t_unsel_left = t_unsel_left;
		divstyle.t_unsel_middle = t_unsel_middle;
		divstyle.t_unsel_right = t_unsel_right;
		return divstyle;
	}
	
	function applyDivStyle(divobj, divstyle){
		for(var key in divstyle){
			divobj.find("div."+key).attr("style", divstyle[key]);
		}
	}
	
	//==========前台界面所需方法 begin==============
	function front_initEvent_sys(tabAreaClass, styleid){
		var stylejson = {};
		jQuery.extend(true, stylejson, sysDefault, sysStyle["style"+styleid]);
		front_bindEvent(tabAreaClass, stylejson);
	}
	
	function front_initEvent_cus(tabAreaClass, styleStr){
		var stylejson = JSON.parse(styleStr);
		front_bindEvent(tabAreaClass, stylejson);
	}
	
	function front_bindEvent(tabAreaClass, stylejson){
		//所需div对象
		var tab_top = jQuery("div."+tabAreaClass).find("div.tab_top");
		var tab_bottom = jQuery("div."+tabAreaClass).find("div.tab_bottom");
		var tab_head = jQuery("div."+tabAreaClass).find("div.tab_head");
		var tab_turnleft = jQuery("div."+tabAreaClass).find("div.tab_turnleft");
		var tab_turnright = jQuery("div."+tabAreaClass).find("div.tab_turnright");
		//样式json
		var divStyle = getDivStyle_ByStyle(stylejson);
		
		applyDivStyle(tab_head, divStyle);
		bindSwitchTabEvent(divStyle, tab_head, tab_bottom);
		//绑定移动事件
		tab_turnleft.click(function(){
			tab_head.scrollLeft(tab_head.scrollLeft() - 80);
		});
		tab_turnright.click(function(){
			tab_head.scrollLeft(tab_head.scrollLeft() + 80);
		});
		controlMoveBtn(tab_top, tab_head, tab_turnleft, tab_turnright);
		jQuery(window).resize(function(){
		   controlMoveBtn(tab_top, tab_head, tab_turnleft, tab_turnright);
		});
	}
	
	function bindSwitchTabEvent(divStyle, tab_head, tab_bottom){
		tab_head.find("div.t_sel,div.t_unsel").click(function(){
			if(jQuery(this).attr("class") === "t_sel")
				return;
			//恢复当前选中的标签样式及内容
			var cur_sel = tab_head.find(".t_sel");
			cur_sel.add(cur_sel.children()).each(function(){
				jQuery(this).attr("class", jQuery(this).attr("class").replace("_sel", "_unsel"));
			});
			applyDivStyle(cur_sel, divStyle);
			tab_bottom.find("#"+cur_sel.attr("id")+"_content").addClass("hideContent");
			//设置将要选中标签样式及内容
			var will_sel = jQuery(this);
			will_sel.add(will_sel.children()).each(function(){
				jQuery(this).attr("class", jQuery(this).attr("class").replace("_unsel", "_sel"));
			});
			applyDivStyle(will_sel, divStyle);
			jQuery("#"+will_sel.attr("id")+"_content").removeClass("hideContent");
		});
	}
	
	function controlMoveBtn(tab_top, tab_head, tab_turnleft, tab_turnright){
		var t_area = tab_head.find(".t_area");
		var totalWidth = 0;
		t_area.children().each(function(){
			totalWidth += jQuery(this).width();
		});
		if(totalWidth > tab_top.width()){
			if(tab_top.find(".tab_movebtn").size() >0){
				tab_top.find(".tab_movebtn").css("display", "block");
				tab_head.width(tab_top.width()-tab_turnleft.width()-tab_turnright.width());
			}else{
				tab_head.width(tab_top.width());
			}
			t_area.width(totalWidth+1);
		}else{
			tab_top.find(".tab_movebtn").css("display", "none");
			tab_head.width("100%");
			t_area.width("100%");
		}
	}
	//==========前台界面所需方法 end==============
	
	return {
		sysDefaultFace: function(){
			return sysDefault;
		},
		sysStyleFace: function(){
			return sysStyle;
		},
		getDivStyle_ByStyleFace: function(stylejson){
			return getDivStyle_ByStyle(stylejson);
		},
		applyDivStyleFace: function(divobj, divstyle){
			applyDivStyle(divobj, divstyle);
		},
		front_initEvent_sysFace: function(tabAreaClass, styleid){
			front_initEvent_sys(tabAreaClass, styleid);
		},
		front_initEvent_cusFace: function(tabAreaClass, styleStr){
			front_initEvent_cus(tabAreaClass, styleStr);
		}
		
	}
})();