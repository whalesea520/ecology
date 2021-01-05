/**
 * 点击编辑弹出HTML的dialog
 */
function diagHTML(id) {
	var diag = new window.top.Dialog();
	diag.Width = 800;
	diag.Height = 400;
	diag.Title = "阶段内容";
	
	diag.OnLoad=function(){ 
		//设置内容高度
		var currWind = diag.innerFrame.contentWindow;
//        var html = jQuery("#"+id).val();
        var html = jQuery("#"+id+"span").html();
		currWind.ue.ready(function() {
//			currWind.ue.setContent(html);
			currWind.ue.execCommand('insertHtml', html);
			currWind.ue.setDisabled();
		});
	};

	diag.URL = "/govern/content/contentHTML.jsp";
	diag.OKEvent =function(){
		diag.close();
	};
	diag.CancelEvent=function(){
		diag.close();
	};
	diag.show();
	
}


/**
* 编辑页面初始化
*/
function initEditHtml(field) {	
	jQuery("textarea[id^="+field+"_]").each(function(){	
			var $input = jQuery(this);
			$input.attr("readonly",true);
			$input.hide();
			var htmlTem = unescapeHTML($input.val());
			var index = $input.attr("id").substring($input.attr("id").indexOf("_")+1);	
			jQuery("#"+field+"_"+index+"span").wrapAll('<div style="max-height:100px;overflow:auto;overflow-x:hidden;word-wrap: break-word;"></div>');
			jQuery("#"+field+"_"+index+"span").html(htmlTem);
			//2.设置 可编辑按钮
			var $parent = $input.parent();
			var $button = jQuery("<input class='e8_btn_top_first' style='float:right;margin-right:5px;' type='button' onclick='javascript:diagHTML(\""+field+"_"+index+"\");' id='"+field+"_"+index+"btn' value='查看' />");
			$parent.find("input[type=button]").remove();
			$parent.append($button);
		});
}

/**
* 编辑页面初始化
*/
function initEditHtml1(field) {	
	jQuery("input[id^="+field+"_]").each(function(){	
			var $input = jQuery(this);
			$input.attr("readonly",true);
			$input.hide();
			var htmlTem = unescapeHTML($input.val());
			var index = $input.attr("id").substring($input.attr("id").indexOf("_")+1);	
			jQuery("#"+field+"_"+index+"span").wrapAll('<div style="max-height:100px;overflow:auto;overflow-x:hidden;word-wrap: break-word;"></div>');
			jQuery("#"+field+"_"+index+"span").html(htmlTem);
			var $parent = $input.parent();
			var $button = jQuery("<input class='e8_btn_top_first' style='float:right;margin-right:5px;' type='button' onclick='javascript:diagHTML(\""+field+"_"+index+"\");' id='"+field+"_"+index+"btn' value='查看' />");
			$parent.find("input[type=button]").remove();
			$parent.append($button);
		});
}

/**
 * @function unescapeHTML 还原html脚本 < > & " '
 * @param a -
 *            字符串
 */
function unescapeHTML(a){
    	a = "" + a;
    	return a.replace(/&lt;/g, "<").replace(/&gt;/g, ">").replace(/&amp;/g, "&").replace(/&quot;/g, '"').replace(/&apos;/g, "'");
	}

