/**
* 明细表上下标
*/
function addEditButton(field,index) {

	var field0 = field +"_" + index  ;
	var $input = jQuery("#"+field0);
	$input.attr("readonly",true);
	$input.hide();
	//2.设置 可编辑按钮
	var $parent = $input.parent();
	var $button = jQuery("<input class='e8_btn_top_first' style='float:right;margin-right:5px;' type='button' onclick='javascript:diagHTML(\""+field+"_"+index+"\");' id='"+field+"_"+index+"btn' value='编辑' />");
	$parent.find("input[type=button]").remove();
	$parent.append($button);
}


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
        var html = dal(jQuery("#"+id).val());
		currWind.ue.ready(function() {
//			currWind.ue.setContent(html);
			currWind.ue.execCommand('insertHtml', html);
		});
	};

	diag.URL = "/govern/content/contentHTML.jsp";
	diag.OKEvent =function(){
		//获取到HTML
		var currWind = diag.innerFrame.contentWindow;
		var html="";
		currWind.ue.ready(function() {
			html = currWind.ue.getContent();
		});
		jQuery("span[id="+id+"span]").wrapAll('<div style="max-height:100px;overflow:auto;overflow-x:hidden;word-wrap: break-word;"></div>');
		jQuery("span[id="+id+"span]").html(html);
		
		var html0 = jQuery("span[id="+id+"span]").html();
		jQuery("#"+id).val(html0);
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
			var index = $input.attr("id").substring($input.attr("id").indexOf("_")+1);	
			jQuery("#"+field+"_"+index+"span").wrapAll('<div style="max-height:100px;overflow:auto;overflow-x:hidden;word-wrap: break-word;"></div>');
			jQuery("#"+field+"_"+index+"span").html(dal($input.val()));
			$input.val(dal($input.val()));
			
			//2.设置 可编辑按钮
			var $parent = $input.parent();
			var $button = jQuery("<input class='e8_btn_top_first' style='float:right;margin-right:5px;' type='button' onclick='javascript:diagHTML(\""+field+"_"+index+"\");' id='"+field+"_"+index+"btn' value='编辑' />");
			$parent.find("input[type=button]").remove();
			$parent.append($button);
		});
}

function dal(html){
		var reg1 = new RegExp('</span','ig');
		var reg2 = new RegExp('</p','ig');
		var reg3 = new RegExp('</strong','ig');
		var reg4 = new RegExp('</span>>','ig');
		var reg5 = new RegExp('</p>>','ig');
		var reg6 = new RegExp('</strong>>','ig');
		html = html.replace(reg1,"</span>");
		html = html.replace(reg2,"</p>");
		html = html.replace(reg3,"</strong>");
		html = html.replace(reg4,"</span>");
		html = html.replace(reg5,"</p>");
		html = html.replace(reg6,"</strong>");
		return  html;
}