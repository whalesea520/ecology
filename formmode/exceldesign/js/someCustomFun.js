
jQuery(document).ready(function(){
	_bindAddEvent(0, 4, 17);
	_hideDetailTitleColumn(0, 1, 17);
	window.setTimeout(function(){
		_hideDetailFieldColumn(0, 4, 17);
		_hideDetailRequired(0);
	},200);
	_adjustDetailSumStyle(0, 1, 1);
});


/**
 * detailIdx 第一个明细表，从0开始
 * rowid 行，从0开始
 * colid 列，从0开始
 */
function _hideDetailTitleColumn(detailIdx, rowid, colid){
	var classname = "detail"+detailIdx+"_"+rowid+"_"+colid;
	jQuery("#oTable"+detailIdx+" td."+classname).html("");
}

function _hideDetailFieldColumn(detailIdx, rowid, colid){
	var classname = "detail"+detailIdx+"_"+rowid+"_"+colid;
	jQuery("#oTable"+detailIdx+" td."+classname).children().css("display", "none");
}

function _bindAddEvent(detailIdx, rowid, colid){
	var classname = "detail"+detailIdx+"_"+rowid+"_"+colid;
	var addButton = jQuery("[name='addbutton"+detailIdx+"']");
	addButton.attr("onclick", "");
	addButton.unbind("click").bind("click", function(){
		addRow0(0);
		_hideDetailFieldColumn(detailIdx, rowid, colid);
		_hideDetailRequired(0);
		return false;
	});
}


/**
 * 调整明细合计样式。合计样式默认取表头标示所在行上一行样式
 * 可通过此JS调整调整,以头部某个单元格样式应用给合计样式
 * detailIdx 第几个明细表，从0计数
 * applyCellRow 应用单元格行(若是合并单元格，取合并区域左上角单元格行)
 * applyCellCol 应用单元格列(若是合并单元格，取合并区域左上角单元格列)
 */
function _adjustDetailSumStyle(detailIdx, applyCellRow, applyCellCol){
	var applyCellClass = "detail"+detailIdx+"_"+applyCellRow+"_"+applyCellCol;
	jQuery("table#oTable"+detailIdx+">tfoot>tr:last-child").children().each(function(){
		$(this).removeAttr("class").addClass(applyCellClass);
	});
}


/**
 * 隐藏明细必填标示
 */
function _hideDetailRequired(detailIdx){
	jQuery("table#oTable"+detailIdx).find("img").each(function(){
		if($(this).attr("src").indexOf("BacoError_wev8.gif") > -1)
			$(this).remove();
	})
}