
var __weaverTableNamespace__ = (function(){
			
	var oriCols = null;
	var cloneCols = null;
	var moveflag = false;
	var targetnow;
	var _xTable = null;
	var cloneTable = null;
	var itemprefix = "item";
	var contentTable = null;
	var backgroundColor = null;
	
	var xTableWidth = 0;

	var pageId = "";
	var pageWidthUnit = "%";
	var minwidth = 4;
	var fromFrommode = false;
	var pagewidth = 0;
	
	function init(_table){
		if(typeof _table === "string"){
			_xTable = jQuery(_table);
		}else{
			_xTable = _table;
		}
		contentTable = _xTable.find("div.table");
		pageId = jQuery("#pageId").val();
		if(jQuery("#pageWidthUnit").size()>0){
			pageWidthUnit = jQuery("#pageWidthUnit").val();
			fromFrommode = true;
			minwidth = 50;
			pagewidth = jQuery("#pageWidth").val();
		}
		if(pageWidthUnit=="") {
			pageWidthUnit = "%";
			fromFrommode = false;
			minwidth = 4;
		}
	}
	
	function resize(){
		var visibleH = 0;
		_xTable.siblings("div,span,table").each(function(){
			if(!jQuery(this).hasClass("nicescroll-rails") && !jQuery(this).css("position")=="absolute" && !jQuery(this).css("position")=="fixed")
				visibleH += jQuery(this).outerHeight();
		});
		visibleH += jQuery("div.e8_box").children("div.e8_boxhead").outerHeight();
		//contentTable.height(jQuery(window).height()-visibleH-79);
		var maxHeight = jQuery(window).height();
		var divContent = jQuery("div.zDialog_div_content")
		if(divContent.length>0){
			maxHeight = jQuery(divContent).height()-18;
			if(jQuery.browser.msie)maxHeight = maxHeight - 1;
			if(maxHeight<200)maxHeight = jQuery(window).height()-jQuery("div.zDialog_div_bottom").height();
		}
		contentTable.css("max-height",(maxHeight-visibleH-79)+"px");
		xTableWidth = _xTable.width();
	}

	function fixHeader(){				
		//if(!oriCols){
			var colgroup = _xTable.find("colgroup:first");
			var thead = _xTable.find("thead:first");
			var div = jQuery("#_cloneWeaverTableDiv");
			if(div.length>0){
				div.remove();
			}
			div = jQuery(document.createElement("div"));
			div.attr("id","_cloneWeaverTableDiv");
			var table = jQuery(document.createElement("table"));
			cloneTable = table;
			table.addClass("ListStyle").css("table-layout","fixed").attr("cellpadding","0").attr("cellspacing","0");
			var cloneColGroup = colgroup.clone();
			table.append(colgroup.clone());
			var cthead = thead.clone();
			jQuery(cthead).find("th").css("border-right","1px solid transparent");
			table.append(cthead);
			div.append(table);
			_xTable.before(div);
			thead.hide();
			resize();
			var horizrailenabled = contentTable.data("_horizrailenabled");
			if(horizrailenabled!==false){
				horizrailenabled = true;
			}
			contentTable.css("overflow","hidden");
			contentTable.perfectScrollbar({horizrailenabled:horizrailenabled});
			jQuery(window).resize(function(){
				resize();
				contentTable.getNiceScroll().resize();
			});
			var cols = colgroup.find("col");
			oriCols = {};
			cols.each(function(idx,obj){
				var $col = jQuery(obj);
				var model = {};
				model.el = $col;
				model.index = idx+1;
				try{
					model.width = $col.attr("width");
				}catch(e){
					//model.width = $col.css("width");
				}
				model.systemid = $col.attr("_systemid");
				oriCols[itemprefix+$col.attr("_itemid")] = model;
			});
			var ccols = table.find("col");
			cloneCols = {};
			ccols.each(function(idx,obj){
				var $col = jQuery(obj);
				var model = {};
				model.el = $col;
				model.index = idx+1;
				try{
					model.width = $col.attr("width");
				}catch(e){
					model.width = $col.css("width");
				}
				cloneCols[itemprefix+$col.attr("_itemid")] = model;
			});
		/*}else{
			var thead = _xTable.find("thead:first");
			thead.hide();
			var colgroup = _xTable.find("colgroup:first");
			var cols = colgroup.find("col");
			oriCols = {};
			cols.each(function(idx,obj){
				var $col = jQuery(obj);
				var model = {};
				model.el = $col;
				model.index = idx+1;
				try{
					model.width = $col.attr("width");
				}catch(e){
					//model.width = $col.css("width");
				}
				oriCols[itemprefix+$col.attr("_itemid")] = model;
			});
		}*/
		table.jNice();
	}

	function getNextItem(target){
		var itemid = parseInt(target.attr("_itemid"));
		var nextitem = oriCols[itemprefix+(itemid+1)];
		if(!nextitem || !nextitem.systemid){
			return false;
		}
		return nextitem;
	}

	function refreshPreviewItems(){
		//设置高度
		var itemid = parseInt(targetnow.attr("_itemid"));
		var item = oriCols[itemprefix+itemid];
		var cloneitem = cloneCols[itemprefix+itemid];
		var nextitem = oriCols[itemprefix+(itemid+1)];
		if(!nextitem){
			return false;
		}
		var clonenextitem = cloneCols[itemprefix+(itemid+1)]
		var sumWidth = Math.round(parseInt(item.width.replace(/"+pageWidthUnit+"/g,""))+parseInt(nextitem.width.replace(/"+pageWidthUnit+"/g,"")));
		var _width =  parseInt(targetnow.attr("_width"));
		var width = fromFrommode?_width:Math.round(_width/xTableWidth*100);
		var nextwidth = sumWidth - width;
		if(nextwidth<minwidth){
			return false;
		}
		//console.log(_width+":"+xTableWidth+":"+sumWidth+"::"+width+"::"+nextwidth);
		item.width =width+pageWidthUnit;
		cloneitem.width = width+pageWidthUnit;
		nextitem.width = nextwidth+pageWidthUnit;
		clonenextitem.width = nextwidth+pageWidthUnit;
		cloneitem.el.css("width",width+pageWidthUnit).attr("width",width+pageWidthUnit);
		clonenextitem.el.css("width",nextwidth+pageWidthUnit).attr("width",nextwidth+pageWidthUnit);
		item.el.css("width",width+pageWidthUnit).attr("width",width+pageWidthUnit);
		nextitem.el.css("width",nextwidth+pageWidthUnit).attr("width",nextwidth+pageWidthUnit);
		return true;
	}

	function saveColumnWidth(){
		var itemid = parseInt(targetnow.attr("_itemid"));
		var item = oriCols[itemprefix+itemid];
		var nextitem = oriCols[itemprefix+(itemid+1)];
		if(!nextitem)return;
		
		var width = item.width;
		var nextwidth = nextitem.width;
		if(fromFrommode) {
			width = Math.round(parseInt(width.replace(/"+pageWidthUnit+"/g,"")));
			nextwidth = Math.round(parseInt(nextwidth.replace(/"+pageWidthUnit+"/g,"")));
			nextwidth = Math.round(nextwidth / pagewidth *100) +"%";
			width = Math.round(width / pagewidth *100) +"%";
		}
		jQuery.ajax({
			url:"/weaver/weaver.common.util.taglib.ShowColServlet?src=saveColWidth&timestap="+new Date().getTime(),
			dataType:"json",
			type:"get",
			data:{
				pageId:pageId,
				id:item.systemid,
				width:width,
				nextid:nextitem.systemid,
				nextwidth:nextwidth
			},
			beforeSend:function(){
				e8showAjaxTips("正在保存数据，请稍候...",true);	
			},
			complete:function(){
				e8showAjaxTips();	
			},
			success:function(data){
					if(data.result==0){
						top.Dialog.alert(data.msg);
					}
			},
			error:function(xhr,status,e){
				top.Dialog.alert("保存失败！");
			}
		});
	}

	function resizeColumnWidth(){
		cloneTable.delegate("th","mousemove",function(e){
			var target = jQuery(e.target);
			 if(target.nextAll().length==0 || target.prevAll().length==0||!target.attr("_systemid")|| !getNextItem(target)){
				return;
			  }
			var offset = target.offset();
			var range = 10;
			 if (!moveflag) {
				//拖拽列头
				//  console.log((offset.left+target.width())+"=="+(e.pageX-range)+"===="+(e.pageX+range))
				if ((offset.left + target.outerWidth()) > e.pageX - range && (offset.left + target.outerWidth()) < e.pageX + range) {
					target.css("cursor", "e-resize");
				} else {
					target.css("cursor", "default");
				}
			}
		});

		cloneTable.delegate("th","mousedown",function(e){
			  var target = jQuery(e.target);
			   if(target.nextAll().length==0 || target.prevAll().length==0||!target.attr("_systemid") || !getNextItem(target)){
				return;
			  }
				if (target.css("cursor") === 'e-resize') {
					targetnow = target;
					moveflag = true;
				}
		});

		cloneTable.delegate("th","mouseover",function(e){
			var target = jQuery(e.target);
			if(!backgroundColor) backgroundColor=target.css("background-color");
			if(target.nextAll().length==0 || target.prevAll().length==0||!target.attr("_systemid")|| !getNextItem(target)){
				return;
			 }
			 target.css("border-right","1px solid #C7C7C7").css("background-color","#F0F0F0");
		});

		cloneTable.delegate("th","mouseleave",function(e){
			var target = jQuery(e.target);
			 target.css("border-right","1px solid transparent").css("background-color",backgroundColor);
		});

		jQuery(document.body).mouseup(function (e) {
			
			if(moveflag){
				moveflag = false;
				cloneTable.find("th").css("cursor", "default");
				jQuery(document.body).css("cursor", "default");
				saveColumnWidth();
				e.preventDefault();
				e.stopPropagation();
			}

		});

		jQuery(document.body).bind('mousemove', function (e) {
			if (moveflag && (targetnow !== undefined)) {
				var widthnew = e.pageX - targetnow.offset().left;
				if (widthnew < 30){
					return;
				}
				cloneTable.find("th").css("cursor", "e-resize");
				jQuery(document.body).css("cursor", "e-resize");
				targetnow.attr("_width", widthnew);
				refreshPreviewItems();
				//resetContainerWidth();
				//e.preventDefault();
				//e.stopPropagation();
			}
		});
	}

	return {
		init:function(table){
			init(table);
		},
		fixHeader:function(){
			if(!pageId)return;
			fixHeader();
		},
		resizeColumnWidth:function(){
			if(!pageId)return;
			resizeColumnWidth();
		},
		getMoveFlag:function(){
			if(!pageId)return false;
			return moveflag;
		},
		getCurrentTarget:function(){
			if(!pageId)return null;
			return targetnow;
		},
		getContentTable:function(){
			return contentTable;
		},
		setHorizrailenabled:function(value){
			horizrailenabled = value;
		}
	}
})();