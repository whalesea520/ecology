$.fn.getHexColor=function(id,property){ 
  var rgb=$(id).css(property); 
  if($.browser.msie&&$.browser.version>8||$.browser.mozilla||$.browser.webkit){ 
    rgb=rgb.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/); 
    function hex(x){ 
      return ("0"+parseInt(x).toString(16)).slice(-2); 
    } 
    rgb="#"+hex(rgb[1])+hex(rgb[2])+hex(rgb[3]); 
  } 
  return rgb; 
} 
var excelBaseOperat=(function (){
	/**
     * 设置样式
     * @param o 【spreadjs div】
     * @param styleWay 【样式属性】
     * @param param1 【其他参数】
     */
    function setMjiStyle(o, styleWay, param1) {
    	var control = scpmanager.getCacheValue(getActiveExcelId());
       	var excelDiv = control.getControl();
       	var dataobj = control.getDataObj();
        
        var ss = jQuery(excelDiv).wijspread("spread");
        var sheet = ss.getActiveSheet();
        try {
            sheet.isPaintSuspended(true);
            var addBold = true;
            var addItalic = true;
            var selections = sheet.getSelections();
            for (var index=0;index<selections.length;index++) {
                var range = getActualCellRange(selections[index], sheet.getRowCount(), sheet.getColumnCount());
                var fs_style = sheet.getStyle(range.row, range.col, $.wijmo.wijspread.SheetArea.viewport);
                //根据第一个区域的第一个单元格判断是加粗还是取消加粗、是加斜体还是取消斜体
            	if(index==0){
            		if(fs_style != undefined && fs_style.font != undefined){
		            	if(styleWay == "bold" && fs_style.font.indexOf("bold") > -1){
		            		addBold = false;
		            	}
		            	if(styleWay == "italic" && fs_style.font.indexOf("italic") > -1){
		            		addItalic = false;
		            	}
            		}
            	}
                for (var i = 0; i < range.rowCount; i++) {
                    for (var j = 0; j < range.colCount; j++) {
                    	if (dataobj.ecs === undefined ||  ""===dataobj.ecs)
							dataobj.ecs = {};
						var r = i + range.row;
						var c = j + range.col;
				           
						var cell = {};
				 		if(undefined != dataobj.ecs[r+","+c] && "" != dataobj.ecs[r+","+c]){
				           	cell = dataobj.ecs[r+","+c];
				           	if("" == cell.efont)	cell.efont = {};
						}else
				           	cell.efont = {};
                        var fontstr;
                        var _style = sheet.getStyle(i + range.row, j + range.col, $.wijmo.wijspread.SheetArea.viewport);
                        if (_style == undefined) {
                            _style = new $.wijmo.wijspread.Style();
                        }
                        if (styleWay == "bgcolor"){
                            _style.backColor = param1;
                            cell.ebgcolor = param1;
                            if(param1 === "transparents")param1 = null;
                            if(!param1){
                            	delete _style.backColor;
                            }
                            if(r === sheet.getRowCount()-1)
								insertRowandCol4Last("row");
							if(c === sheet.getColumnCount()-1)
								insertRowandCol4Last("col");
                        }else if (styleWay == "fontcolor"){
                            _style.foreColor = param1;
                            if(!cell.efont)cell.efont={};
                            cell.efont.f_color = param1;
                            if(!param1){
                            	delete _style.foreColor;
                            }
                        }else if (styleWay == "fontfamliy"){
                            if(_style.font == undefined)
                                 _style.font = "9pt " + param1;
                            else{
                                if(_style.font.indexOf("SimSun") >=0){
                                    _style.font = _style.font.replace("SimSun",param1);
                                }else if(_style.font.indexOf("SimHei") >=0){
                                    _style.font = _style.font.replace("SimHei",param1);
                                }else if(_style.font.indexOf("Microsoft YaHei") >=0){
                                    _style.font = _style.font.replace("Microsoft YaHei",param1);
                                }else if(_style.font.indexOf("KaiTi") >=0){
                                    _style.font = _style.font.replace("KaiTi",param1);
                                }else if(_style.font.indexOf("YouYuan") >=0){
                                    _style.font = _style.font.replace("YouYuan",param1);
                                }else if(_style.font.indexOf("FangSong") >=0){
                                	_style.font = _style.font.replace("FangSong",param1);
                                }else if(_style.font.indexOf("Arial") >=0){
                                    _style.font = _style.font.replace("Arial",param1);
                                }else if(_style.font.indexOf("times New Roman") >=0){
                                    _style.font = _style.font.replace("times New Roman",param1);
                                }else if(_style.font.indexOf("Verdana") >=0){
                                    _style.font = _style.font.replace("Verdana",param1);
                                }
                            }
                            if(!cell.efont)		cell.efont={};
                            cell.efont.f_family = param1;
                        }else if (styleWay == "fontsize"){
                            if(_style.font == undefined)
                                _style.font = param1 + " Microsoft YaHei";
                            else{
                                _style.font = _style.font.replace((/\d+pt/g),param1);
                            }
                            if(!cell.efont)cell.efont={};
                            cell.efont.f_size = param1;
                        }else if(styleWay == "bold"){
                        	if(!cell.efont)		cell.efont={};
							if(_style == undefined || _style.font == undefined){
								if(addBold){
									_style.font = "bold 9pt Microsoft YaHei";
                                    cell.efont.f_bold = true;
								}
							}else{
								if(addBold && _style.font.indexOf("bold") == -1){
									if(_style.font.indexOf("italic") > -1){
										_style.font = _style.font.replace("italic","italic bold");
									}else{
										_style.font = "bold " + _style.font;
									}
									cell.efont.f_bold = true;
								}
								if(!addBold && _style.font.indexOf("bold") > -1){
									_style.font = _style.font.replace("bold ","");
                                    cell.efont.f_bold = false;
								}
							}
                        }else if(styleWay == "italic"){
                        	if(!cell.efont)		cell.efont={};
                        	if(_style == undefined || _style.font == undefined){
								if(addItalic){
									_style.font = "italic 9pt Microsoft YaHei";
                                    cell.efont.f_italic = true;
								}
							}else{
								if(addItalic && _style.font.indexOf("italic") == -1){
									_style.font = "italic " + _style.font;
                                    cell.efont.f_italic = true;
								}
								if(!addItalic && _style.font.indexOf("italic") > -1){
									_style.font = _style.font.replace("italic ","");
                                    cell.efont.f_italic = false;
								}
							}
                        }
                        sheet.setStyle(i + range.row, j + range.col, _style, $.wijmo.wijspread.SheetArea.viewport);
                       	setCellProperties(r+","+c,"",cell);
                    }
                }
            }
            sheet.isPaintSuspended(false);
        }
        catch (ex) {
            window.top.Dialog.alert(ex.message);
        }
    }
    
	
	//获取表格 矩阵 并返回
	function getActualCellRange(cellRange, rowCount, columnCount) {
	    if (cellRange.row == -1 && cellRange.col == -1) {
	        return new $.wijmo.wijspread.Range(0, 0, rowCount, columnCount);
	    }
	    else if (cellRange.row == -1) {
	        return new $.wijmo.wijspread.Range(0, cellRange.col, rowCount, cellRange.colCount);
	    }
	    else if (cellRange.col == -1) {
	        return new $.wijmo.wijspread.Range(cellRange.row, 0, cellRange.rowCount, columnCount);
	    }
	
	    return cellRange;
	}
	
	//设置 操作栏 按钮状态
	function setBtnStatus(btn)
	{
		if(jQuery(btn).attr("down") === "on")
        {
        	jQuery(btn).attr("down","");
        	jQuery(btn).removeClass("shortBtnHover");
        	return false;
       	}
        else 
        {
        	jQuery(btn).attr("down","on");
        	jQuery(btn).addClass("shortBtnHover");
        	return true;
       	}
	}
	
	function numbricalBx(numberJson){
		var control = scpmanager.getCacheValue(getActiveExcelId());
       	var excelDiv = control.getControl();
       	var excelData = control.getDataObj();
       	
		var n_set = numberJson.n_set;
		if(n_set === "1"){ //如果没有单元格自定义属性，那么n_set =1 就是说明数值tab中没有设置过，直接return掉
			if(!excelData)return;
			if(!excelData.ecs)return;
		}
       	var n_decimals = "";
       	var n_us = "";
       	var n_target = "";
       	var formatStr = "";
       	if(n_set === "1"){	//常规 删除所有数字格式
       		formatStr = null;
       	}else if(n_set === "2"){	//数值
       		n_decimals = numberJson.n_decimals;
       		n_us = numberJson.n_us;
       		n_target = numberJson.n_target;
       		var _n_decimals = parseInt(n_decimals);
       		var decstr = "";
       		if(_n_decimals>0)
       		{
        		decstr = ".";
        		var i = 0;
        		while(i < _n_decimals)
        		{
        			decstr +="0";
        			i++;
        		}
       		}
       		if(n_us === "1")
       			formatStr = "#,##0"+decstr;
       		else
       			formatStr = "0"+decstr;
       		//下面还需要设置单元格的属性
       		//if("1"===n_target || "4"===n_target)
       		//	excelBaseOperat.setStyleInterface("fontcolor","#FF0000");
       		//else
       		//	excelBaseOperat.setStyleInterface("fontcolor","#000000");
       	}else if(n_set === "3" || n_set === "4" || n_set === "8"){
       		n_target = numberJson.n_target;
       	}else if(n_set === "5" || n_set === "6"){
       		n_decimals = numberJson.n_decimals;
       	}
       
		var spread = $(excelDiv).wijspread("spread");
        var sheet = spread.getActiveSheet();
		try {
			var selections = sheet.getSelections();
			for (var index = 0; index < selections.length; index++) {
				var range = getActualCellRange(selections[index], sheet.getRowCount(), sheet.getColumnCount());
               	for (var i = 0; i < range.rowCount; i++) {
                  	for (var j = 0; j < range.colCount; j++) {
						var r = range.row + i;
                   	 	var c = range.col + j;
                   	 	if(n_set === "1")
                   	 	{
	                   	 	if(!excelData.ecs[r+","+c])break;
	                   	 	if(!excelData.ecs[r+","+c].enumbric)break;
                   	 	}
                   	 	if(excelData && excelData.ecs[r+","+c] && excelData.ecs[r+","+c].enumbric)
                   	 		if(excelData.ecs[r+","+c].enumbric.n_set === n_set && excelData.ecs[r+","+c].enumbric.n_decimals===n_decimals
                   	 			&& excelData.ecs[r+","+c].enumbric.n_us===n_us && excelData.ecs[r+","+c].enumbric.n_target===n_target)break;
                   	 	sheet.getCell(r, c,$.wijmo.wijspread.SheetArea.viewport).formatter(new $.wijmo.wijspread.GeneralFormatter(formatStr));
                   	 	//sheet.getCells(range.row, range.col, range.row + range.rowCount - 1, range.col + range.colCount - 1, ).formatter(new $.wijmo.wijspread.GeneralFormatter(formatStr));
                       	var cell = {};
                       	var _enumbric = {};
                       	_enumbric.n_set = n_set;
                       	_enumbric.n_decimals = n_decimals;
                       	_enumbric.n_us = n_us;
                       	_enumbric.n_target = n_target;
                       	cell.enumbric = _enumbric;
                       	setCellProperties(r+","+c,"",cell);
                   	}
               	}
           	}
       	} catch (ex) {
           	window.top.Dialog.alert(ex.message);
		}
	}
	//对齐方式 封装
	function alignBx(alignJson,isdown)
	{
		var a_halign = "";
       	var a_valign = "";
       	a_halign = alignJson.a_halign;
       	a_valign = alignJson.a_valign;
		if(a_valign === "0")
			a_valign = $.wijmo.wijspread.VerticalAlign.top;
		else if(a_valign === "1")
		{
			a_valign = $.wijmo.wijspread.VerticalAlign.center;
			if(isdown == false)
				a_valign = $.wijmo.wijspread.VerticalAlign.top;
		}
		else if(a_valign === "2")
		{
			a_valign = $.wijmo.wijspread.VerticalAlign.bottom;
			if(isdown == false)
				a_valign = $.wijmo.wijspread.VerticalAlign.top;
		}
		else
			a_valign = null;
		if(a_halign === "0")
			a_halign = $.wijmo.wijspread.HorizontalAlign.left;
		else if(a_halign == "1")
		{
			a_halign = $.wijmo.wijspread.HorizontalAlign.center;
			if(isdown == false)
				a_halign = $.wijmo.wijspread.HorizontalAlign.left;
		}
		else if(a_halign == "2")
		{
			a_halign = $.wijmo.wijspread.HorizontalAlign.right;
			if(isdown == false)
				a_halign = $.wijmo.wijspread.HorizontalAlign.left;
		}
		else 
			a_halign = null;
		
		
		var control = scpmanager.getCacheValue(getActiveExcelId());
       	var excelDiv = control.getControl();
       	var dataobj = control.getDataObj();
		var spread = $(excelDiv).wijspread("spread");
        var sheet = spread.getActiveSheet();
        sheet.isPaintSuspended(true);
   		var sels = sheet.getSelections();
     	for (var index = 0; index < sels.length; index++) {
       	 	var sel = getActualCellRange(sels[index], sheet.getRowCount(), sheet.getColumnCount());
	   		if(!!a_valign || a_valign==0)
	   			sheet.getCells(sel.row, sel.col, sel.row + sel.rowCount - 1, sel.col + sel.colCount - 1, $.wijmo.wijspread.SheetArea.viewport).vAlign(a_valign);
	       	if(!!a_halign || a_halign==0)
	       		sheet.getCells(sel.row, sel.col, sel.row + sel.rowCount - 1, sel.col + sel.colCount - 1, $.wijmo.wijspread.SheetArea.viewport).hAlign(a_halign);
			
			for (var i = 0; i < sel.rowCount; i++) {
				for (var j = 0; j < sel.colCount; j++) {
					var r = sel.row + i;
                   	var c = sel.col + j;
                   	if(dataobj)
					if(dataobj.ecs)
					if(dataobj.ecs[r+","+c])
					{
						var txtindent = 0;
						if(!!dataobj.ecs[r+","+c].etxtindent)
							txtindent = parseFloat(dataobj.ecs[r+","+c].etxtindent);
						if((dataobj.ecs[r+","+c].etype === celltype.FCONTENT) && (!a_halign ||a_halign == $.wijmo.wijspread.HorizontalAlign.left))
							sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).textIndent(txtindent+2.5);
						else if(dataobj.ecs[r+","+c].etype === celltype.DETAIL && (!a_halign ||a_halign == $.wijmo.wijspread.HorizontalAlign.left))
							sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).textIndent(txtindent);
						else
							sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).textIndent(txtindent);
					}
                   	var cell = {};
                   	var _ealign = {};
                   	_ealign.a_valign = a_valign;
                   	_ealign.a_halign = a_halign;
                	cell.ealign = _ealign;
                   	setCellProperties(r+","+c,"",cell);
				}
			}
        }
		sheet.isPaintSuspended(false);
	}
	//自动换行封装
	function autowrapBx(wrap)
	{
		var control = scpmanager.getCacheValue(getActiveExcelId());
       	var excelDiv = control.getControl();
		var spread = $(excelDiv).wijspread("spread");
        var sheet = spread.getActiveSheet();
        
        sheet.isPaintSuspended(true);
        var sels = sheet.getSelections();
        for (var index = 0; index < sels.length; index++) {
            var sel = getActualCellRange(sels[index], sheet.getRowCount(), sheet.getColumnCount());
            sheet.getCells(sel.row, sel.col, sel.row + sel.rowCount - 1, sel.col + sel.colCount - 1, $.wijmo.wijspread.SheetArea.viewport).wordWrap(wrap);
            for (var i = 0; i < sel.rowCount; i++) {
				for (var j = 0; j < sel.colCount; j++) {
					var r = sel.row + i;
                   	var c = sel.col + j;
                   	var cell = {};
                   	var _ealign = {};
                   	_ealign.a_wrap = wrap;
                	cell.ealign = _ealign;
                   	setCellProperties(r+","+c,"",cell);
				}
			}
        }
        sheet.isPaintSuspended(false);
	}
	//合并单元格
	function mergenBx()
	{
		var control = scpmanager.getCacheValue(getActiveExcelId());
       	var excelDiv = control.getControl();
   		var dataobj = control.getDataObj();
		var spread = $(excelDiv).wijspread("spread");
        var sheet = spread.getActiveSheet();
       	var sels = sheet.getSelections();
       	var merAry = new Array();
       	for(var index=0;index<sels.length;index++)
       	{
       		var sel = getActualCellRange(sels[index], sheet.getRowCount(), sheet.getColumnCount());
       		for (var i = 0; i < sel.rowCount; i++) {
				for (var j = 0; j < sel.colCount; j++) {
					var r = sel.row + i;
                   	var c = sel.col + j;
                   	if(dataobj)
					if(dataobj.ecs)
					if(dataobj.ecs[r+","+c])
					if(dataobj.ecs[r+","+c].etype)
						merAry.push(dataobj.ecs[r+","+c]);
				}
			}
			if(merAry && merAry.length > 1)
	       	{
	       		window.top.Dialog.confirm(_excel_reminder_2,function(){
	       			_mergenBx(merAry,sel);
	       		});
	       	}else
	       		_mergenBx(merAry,sel);
       	}
	}
	
	function _mergenBx(merAry,sel)
	{
		var control = scpmanager.getCacheValue(getActiveExcelId());
       	var excelDiv = control.getControl();
   		var dataobj = control.getDataObj();
		var spread = $(excelDiv).wijspread("spread");
        var sheet = spread.getActiveSheet();
		if(!!merAry && merAry.length > 0){
			var _old_cell = merAry[0];
			var _old_row = _old_cell.id.split(",")[0];
			var _old_col = _old_cell.id.split(",")[1];
			var _old_value = sheet.getCell(_old_row,_old_col,$.wijmo.wijspread.SheetArea.viewport).value();
			var _old_img = sheet.getCell(_old_row,_old_col,$.wijmo.wijspread.SheetArea.viewport).backgroundImage();
			var _old_txtin = sheet.getCell(_old_row,_old_col,$.wijmo.wijspread.SheetArea.viewport).textIndent();
			var _old_style = sheet.getStyle(_old_row,_old_col, $.wijmo.wijspread.SheetArea.viewport);
			sheet.getCell(sel.row, sel.col,$.wijmo.wijspread.SheetArea.viewport).value(_old_value);
			sheet.getCell(sel.row, sel.col,$.wijmo.wijspread.SheetArea.viewport).backgroundImage(_old_img);
			if(_old_img)
				sheet.getCell(sel.row, sel.col,$.wijmo.wijspread.SheetArea.viewport).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
			sheet.getCell(sel.row, sel.col,$.wijmo.wijspread.SheetArea.viewport).textIndent(_old_txtin);
			sheet.setStyle(sel.row,sel.col, _old_style, $.wijmo.wijspread.SheetArea.viewport);
			if(dataobj)
			if(dataobj.ecs){
				dataobj.ecs[sel.row+","+sel.col] = merAry[0]; 
				dataobj.ecs[sel.row+","+sel.col].id = sel.row+","+sel.col;
			}
			sheet.addSpan(sel.row, sel.col, sel.rowCount, sel.colCount,$.wijmo.wijspread.SheetArea.viewport);
		}else{
			sheet.addSpan(sel.row, sel.col, sel.rowCount, sel.colCount,$.wijmo.wijspread.SheetArea.viewport);
		}
		var st = setTimeout(function (){
			//清除合并后活动单元格以外的其他的单元格
			for (var i = 0; i < sel.rowCount; i++) {
				for (var j = 0; j < sel.colCount; j++) {
					if(i == 0 && j == 0) continue;
					var r = sel.row + i;
	               	var c = sel.col + j;
	               	if(sheet._dataModel.dataTable[r])
	               	if(sheet._dataModel.dataTable[r][c])
	               	{
		               	delete sheet._dataModel.dataTable[r][c];
						if(dataobj)
						if(dataobj.ecs)
						if(dataobj.ecs[r+","+c])
							delete dataobj.ecs[r+","+c];
					}
				}
			}
			//如果有边框，需要重新画下外围边框
			if(dataobj)
			if(dataobj.ecs)
			if(dataobj.ecs[sel.row+","+sel.col])
			if(dataobj.ecs[sel.row+","+sel.col].eborder)
			{
				sheet.isPaintSuspended(true);
				var _topborder = sheet.getCell(sel.row, sel.col, $.wijmo.wijspread.SheetArea.viewport).borderTop();
		        var _leftborder = sheet.getCell(sel.row, sel.col, $.wijmo.wijspread.SheetArea.viewport).borderLeft();
		        var _rightborder = sheet.getCell(sel.row, sel.col, $.wijmo.wijspread.SheetArea.viewport).borderRight();
		        var _bottomborder = sheet.getCell(sel.row, sel.col, $.wijmo.wijspread.SheetArea.viewport).borderBottom();
	            sheet.setBorder(sel, _leftborder, {
	               	left: true
	            });
	            sheet.setBorder(sel, _rightborder, {
	               	right: true
	            });
	            sheet.setBorder(sel, _bottomborder, {
	               	bottom: true
	            });
	            sheet.setBorder(sel, _topborder, {
	               	top: true
	            });
	            sheet.isPaintSuspended(false);
            }
			clearTimeout(st);
		},100);
	}
	
	//拆分单元格
	function splitBx(){
		var control = scpmanager.getCacheValue(getActiveExcelId());
       	var excelDiv = control.getControl();
		var spread = $(excelDiv).wijspread("spread");
        var sheet = spread.getActiveSheet();
        var sels = sheet.getSelections();
        sheet.isPaintSuspended(true);
        for(var index=0; index<sels.length; index++) {
            var sel = getActualCellRange(sels[index], sheet.getRowCount(), sheet.getColumnCount());
            for (var i = 0; i < sel.rowCount; i++) {
                for (var j = 0; j < sel.colCount; j++) {
					var r = sel.row + i;
	               	var c = sel.col + j;
                    sheet.removeSpan(r, c);
                    if(i == 0 && j == 0) continue;
                    var _cell_val = sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).value();
                    if(!!_cell_val)		continue;
	               	if(sheet._dataModel.dataTable[r])
	               	if(sheet._dataModel.dataTable[r][c]){
		               	delete sheet._dataModel.dataTable[r][c];
					}
                }
            }
        }
        sheet.isPaintSuspended(false);
	}
	
	//切换顶部tab页
	function initOperatTabPanel(obj){
		jQuery(".excelBody").show();
		jQuery(".excelHeadBG").show();
		jQuery(".excelSet").show();
		jQuery(".moduleContainer").hide();
		jQuery(".maxwin,.restore").show();
		if(jQuery(obj).is(".s_format"))
			jQuery(".excelHeadContent").children(".s_format").show();
		else if(jQuery(obj).is(".s_insert"))
			jQuery(".excelHeadContent").children(".s_insert").show();
		else if(jQuery(obj).is(".s_filed"))
			jQuery(".excelHeadContent").children(".s_filed").show();
		else if(jQuery(obj).is(".s_detail"))
			jQuery(".excelHeadContent").children(".s_detail").show();
		else if(jQuery(obj).is(".s_style"))
			jQuery(".excelHeadContent").children(".s_style").show();
		else if(jQuery(obj).is(".s_module")){
			jQuery(".excelBody").hide();
			jQuery(".excelHeadBG").hide();
			jQuery(".excelSet").hide();
			jQuery(".moduleContainer").show();
			jQuery(".maxwin,.restore").hide();
			if(!jQuery("#showModule").attr("src")){
				initModuleTab();
			}
		}
	}
	
	function openStyleWin(){
   		//打开 单元格属性 窗口
   		var control = scpmanager.getCacheValue(getActiveExcelId());
   		var excelDiv = control.getControl();
   		var spread = $(excelDiv).wijspread("spread");
        var sheet = spread.getActiveSheet();
        var sel = sheet.getSelections();
        var bxsize = 1;
        if(sel.length >1)
        	bxsize = 2;
        else if(sel.length == 1){
        	if(sel[0].rowCount > 1 || sel[0].colCount > 1)
        		bxsize = 2;
        }
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/exceldesign/excelSFContainer.jsp?bxsize="+bxsize;
		dialog.Title = "设置单元格格式";
		dialog.Width = 500;
		dialog.Height = 450;
		dialog.Drag = true; 	
		dialog.URL = url;
		dialog.show();
		dialog.callbackfun = function (paramobj, result) {
			if( !result ) return;
			setPro4NumberTab(result.numberJson);
			setPro4AlignTab(result.alignJson);
			setPro4FontTab(result.fontJson);
			setPro4BorderTab(result.borderJson);
			setPro4BgfillTab(result.bgfillJson);
		};
   	}
   	
   	//根据单元格属性页的 数值tab页 设置单元格自定义属性
	function setPro4NumberTab(numberJson){
		if(!numberJson) return;
      	excelBaseOperat.setNumbricBxFace(numberJson);
	}
	//根据单元格属性页的 对齐tab页 设置单元格自定义属性
	function setPro4AlignTab(alignJson)
	{
	  	if(!alignJson)
	  		return;
	  	var a_mergen = alignJson.a_mergen;
	  	excelBaseOperat.setMerSplbxFace(a_mergen);
	  	excelBaseOperat.setAlignBxFace(alignJson);
	  	var a_wrap = alignJson.a_autowrap;
	  	excelBaseOperat.setAutoWrapBxFace(a_wrap);
	}
	//根据单元格属性页的 字体tab页 设置单元格自定义属性
    function setPro4FontTab(fontJson)
    {
    	//console.dir(fontJson);
    	if(!fontJson)
    		return;
    	var f_size = "9pt";
    	var f_color = "#000";
    	var f_family = "Microsoft YaHei";
    	var f_style = "";
    	var f_bold = false;
    	var f_italic = false;
    	var f_underline = "";
    	var f_deleteline = "";
    	if(fontJson.f_size)
    		f_size = fontJson.f_size;
    	if(fontJson.f_color)
    		f_color = fontJson.f_color;
    	if(fontJson.f_family)
    		f_family = fontJson.f_family;
    	if(fontJson.f_underline)
    		f_underline = fontJson.f_underline;
    	if(fontJson.f_deleteline)
    		f_deleteline = fontJson.f_deleteline;
		var textDecoration  = $.wijmo.wijspread.TextDecorationType.None;
    	if(f_deleteline)
    		textDecoration |= $.wijmo.wijspread.TextDecorationType.LineThrough;
    	if(f_underline)	
    		textDecoration |= $.wijmo.wijspread.TextDecorationType.Underline;
    		
    		
    	f_style = fontJson.f_style;
    	if(f_style){
	    	if(f_style === "1"){
	    		f_italic = true;
	    		f_bold = false;
	   		}else if(f_style==="2"){
	    		f_italic = false;
	    		f_bold = true;
	   		}else if(f_style==="3"){
	   			f_italic = true;
	    		f_bold = true;
	   		}
	   	}
   		
   		var control = scpmanager.getCacheValue(getActiveExcelId());
       	var excelDiv = control.getControl();
        var ss = jQuery(excelDiv).wijspread("spread");
        var sheet = ss.getActiveSheet();
        try {
            var sels = sheet.getSelections();
            for(var index=0; index<sels.length; index++) {
                var sel = getActualCellRange(sels[index], sheet.getRowCount(), sheet.getColumnCount());
                sheet.isPaintSuspended(true);
                for (var i = 0; i < sel.rowCount; i++) {
                    for (var j = 0; j < sel.colCount; j++) {
                    	var fontstr;
                    	var r = sel.row + i;
                   		var c = sel.col + j;
                        var _style = sheet.getStyle(i + sel.row, j + sel.col, $.wijmo.wijspread.SheetArea.viewport);
                        if (_style == undefined) {
                            _style = new $.wijmo.wijspread.Style();
                        }
                        if (f_color)
                            _style.foreColor = f_color;
                        if (f_family && f_size){
                        	_style.font = (f_italic?"italic ":"")+(f_bold?"bold ":"")+f_size+" "+f_family;
                        }
                        
                        sheet.setStyle(i + sel.row, j + sel.col, _style, $.wijmo.wijspread.SheetArea.viewport);
                        sheet.getCell(r, c,$.wijmo.wijspread.SheetArea.viewport).textDecoration(textDecoration);
                        var cell = {};
	                   	var _efont = {};
	                   	_efont.f_color = f_color;
	                   	_efont.f_family = f_family;
	                   	_efont.f_size = f_size;
	                   	_efont.f_italic = f_italic;
	                   	_efont.f_bold = f_bold;
	                   	_efont.f_underline = f_underline;
	                   	_efont.f_deleteline = f_deleteline;
	                	cell.efont = _efont;
	                   	setCellProperties(r+","+c,"",cell);
                    }
                }
                sheet.isPaintSuspended(false);
			}
		}catch (ex) {
           	window.top.Dialog.alert(ex.message);
		}
    }
    
    //根据单元格属性页的 字体tab页 设置单元格边框
    function setPro4BorderTab(borderJson)
    {
    	if(!borderJson)
    		return;
    	var control = scpmanager.getCacheValue(getActiveExcelId());
   		var excelDiv = control.getControl();
   		var ss = jQuery(excelDiv).wijspread("spread");
       	var sheet = ss.getActiveSheet();
     	var sels = sheet.getSelections();
     	try{
	     	sheet.isPaintSuspended(true);
	     	for (var n = 0; n < sels.length; n++) {
				var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
				sheet.setBorder(sel, null, {all:true});
				if(!!borderJson.b_top){
					var lineBorder = new $.wijmo.wijspread.LineBorder(borderJson.b_top.bordercolor, parseInt(borderJson.b_top.borderstyle));
					sheet.setBorder(sel, lineBorder, { top:true });
				}
				if(!!borderJson.b_bottom){
					var lineBorder = new $.wijmo.wijspread.LineBorder(borderJson.b_bottom.bordercolor, parseInt(borderJson.b_bottom.borderstyle));
					sheet.setBorder(sel, lineBorder, { bottom:true });
				}
				if(!!borderJson.b_left){
					var lineBorder = new $.wijmo.wijspread.LineBorder(borderJson.b_left.bordercolor, parseInt(borderJson.b_left.borderstyle));
					sheet.setBorder(sel, lineBorder, { left:true });
				}
				if(!!borderJson.b_right){
					var lineBorder = new $.wijmo.wijspread.LineBorder(borderJson.b_right.bordercolor, parseInt(borderJson.b_right.borderstyle));
					sheet.setBorder(sel, lineBorder, { right:true });
				}
				if(!!borderJson.b_horize){
					var lineBorder = new $.wijmo.wijspread.LineBorder(borderJson.b_horize.bordercolor, parseInt(borderJson.b_horize.borderstyle));
					sheet.setBorder(sel, lineBorder, { innerHorizontal:true });
				}
				if(!!borderJson.b_vertic){
					var lineBorder = new $.wijmo.wijspread.LineBorder(borderJson.b_vertic.bordercolor, parseInt(borderJson.b_vertic.borderstyle));
					sheet.setBorder(sel, lineBorder, { innerVertical:true });
				}
				if(borderJson.b_top || borderJson.b_bottom || borderJson.b_left
					|| borderJson.b_right || borderJson.b_horize || borderJson.b_vertic){
					//设置自定义属性，标识单元格是有边框的；无论什么边框，在保存的时候会去取
		            for (var i = 0; i < sel.rowCount; i++) {
	                    for (var j = 0; j < sel.colCount; j++) {
	                    	var r = sel.row + i;
	                   		var c = sel.col + j;
			       	 		var cell = {};
							cell.eborder = true;
							setCellProperties(r+","+c,"",cell);
						}
					}
				}
	     	}
	     	sheet.isPaintSuspended(false);
		}catch (ex) {
            window.top.Dialog.alert(ex.message);
        }
    }
    
    function setPro4BgfillTab(bgfillJson)
    {
    	if(!bgfillJson)
    		return;
    	setMjiStyle(null,"bgcolor",bgfillJson.backgroundcolor);
    }
    
    //保存方法转换etype
    function transformerEtype(etype)
    {
    	if(etype === celltype.TEXT)	//文本
    	 	return "1";
    	else if(etype === celltype.FNAME)	//字段名
    		return "2";
    	else if(etype === celltype.FCONTENT)	//表单内容
    		return "3";
    	else if(etype === celltype.NNAME)	//节点名
    		return "4";
    	else if(etype === celltype.NADVICE)	//流转意见
    		return "5";
    	else if(etype === celltype.IMAGE)	//图片
    		return "6";
    	else if(etype === celltype.DETAIL)	//明细
    		return "7";
    	else if(etype === celltype.DE_TITLE)	//表头标识
    		return "8";
    	else if(etype === celltype.DE_TAIL)	//表尾标识
    		return "9";
    	else if(etype === celltype.DE_BTN)	//明细增删按妞
    		return "10";
    	else if(etype === celltype.LINKTEXT)	//链接
    		return "11";
    }
    
    //恢复的时候反向转换etype
    function reverseTransformerEtype(etype)
    {
    	if(etype === "1")	//文本
    	 	return celltype.TEXT;
    	else if(etype === "2")	//字段名
    		return celltype.FNAME;
    	else if(etype === "3")	//表单内容
    		return celltype.FCONTENT;
    	else if(etype === "4")	//节点名
    		return celltype.NNAME;
    	else if(etype === "5")	//流转意见
    		return celltype.NADVICE;
    	else if(etype === "6")	//图片
    		return celltype.IMAGE;
    	else if(etype === "7")	//明细
    		return celltype.DETAIL;
    	else if(etype === "8")	//表头标识
    		return celltype.DE_TITLE;
    	else if(etype === "9")	//表尾标识
    		return celltype.DE_TAIL;
    	else if(etype === "10")	//明细增删按妞
    		return celltype.DE_BTN;
    	else if(etype === "11")
    		return celltype.LINKTEXT;
    }
   	
   	function getMaxCell(ecs){
   		var maxrow = 0;
   		var maxcol = 0;
   		for(var item in ecs){
   			var ecObj = ecs[item];
   			if(ecObj.etype === celltype.DE_TITLE || ecObj.etype === celltype.DE_TAIL)
   				continue;
   			var cur_row = parseInt(item.split(",")[0]) + parseInt(ecObj.rowspan) - 1;
   			var cur_col = parseInt(item.split(",")[1]) + parseInt(ecObj.columnspan) - 1;
   			if(cur_row > maxrow)
   				maxrow = cur_row;
   			if(cur_col > maxcol)
   				maxcol = cur_col;
   		}
   		return maxrow+","+maxcol;
   	}
   	
   	//剪切
   	function doCCP(action){
   		var control = scpmanager.getCacheValue(getActiveExcelId());
   		var excelDiv = control.getControl();
   		var ss = jQuery(excelDiv).wijspread("spread");
       	var sheet = ss.getActiveSheet();
       	sheet.isPaintSuspended(true);
       	if(action === "cut")
       		$.wijmo.wijspread.SpreadActions.cut.call(sheet);
       	else if(action === "copy")
       		$.wijmo.wijspread.SpreadActions.copy.call(sheet);
       	else if(action === "paste")
       		$.wijmo.wijspread.SpreadActions.paste.call(sheet);
       			
       	sheet.isPaintSuspended(false);
   	}
   	
   	function insertRowCols(flag){
		var excelDiv = scpmanager.getCacheValue(getActiveExcelId()).getControl();
		var ss = $(excelDiv).wijspread("spread");
		var sheet = ss.getActiveSheet();
        var sel = sheet.getSelections();
        if (sel.length > 0) {
            sel = getActualCellRange(sel[sel.length - 1], sheet.getRowCount(), sheet.getColumnCount());
        }
        if(flag=="row"){
	        if(sel.rowCount==0)sel.rowCount=1;
	        sheet.addRows(sheet.getActiveRowIndex(), sel.rowCount);
	        setecsid4rcOpreation("row","insert",sheet.getActiveRowIndex(),sel.rowCount);
        }else if(flag=="col"){
	        if(sel.colCount==0)sel.colCount=1;
	        sheet.addColumns(sheet.getActiveColumnIndex(), sel.colCount);
	        setecsid4rcOpreation("col","insert",sheet.getActiveColumnIndex(),sel.colCount);
        }
   	}
   	
   	function deleteRowCols(flag){
		var excelDiv = scpmanager.getCacheValue(getActiveExcelId()).getControl();
		var ss = $(excelDiv).wijspread("spread");
        var sheet = ss.getActiveSheet();
        var selections = sheet.getSelections();
        if(selections.length<1)		
        	return;
        var sortArr = new Array();
        var selJson = {};
        for(var i=0; i<selections.length; i++){
        	var sel = getActualCellRange(selections[i], sheet.getRowCount(), sheet.getColumnCount());
        	if(flag=="row"){
	        	sortArr.push(sel.row);
	        	selJson[sel.row] = sel;
        	}else if(flag=="col"){
        		sortArr.push(sel.col);
	        	selJson[sel.col] = sel;
        	}
        }
        sortArr = bubbleSort(sortArr);		//从后往前删除
        for(var i=0; i<sortArr.length; i++){
        	var sel = selJson[sortArr[i]];
	        if(flag=="row"){
	        	sheet.deleteRows(sel.row, sel.rowCount);
	        	setecsid4rcOpreation("row","delete",sel.row,sel.rowCount);
        	}else if(flag=="col"){
        		sheet.deleteColumns(sel.col, sel.colCount);
	        	setecsid4rcOpreation("col","delete",sel.col,sel.colCount);
        	}
        }
   	}
   	
   	function bubbleSort(arr){
   		for(var i=0; i<arr.length-1; i++){
   			for(var j=0; j<arr.length-1-i; j++){
   				if(arr[j]<arr[j+1]){
   					var temp = arr[j];
   					arr[j] = arr[j+1];
   					arr[j+1] = temp;
   				}
   			}
   		}
   		return arr;
   	}
   	
   	// 插入/删除行/列 导致的自定义属性位移
   	function setecsid4rcOpreation(rc,opreation,activenum,movenum){
	    var control = scpmanager.getCacheValue(getActiveExcelId());
	    var dataobj = control.getDataObj();
	
	    if(dataobj != undefined && dataobj.ecs != undefined){
	        var toArr = new Array();
	        for(var item in dataobj.ecs){
	            var newid;
	            var itemrow = parseInt(item.split(",")[0]);
	            var itemcol = parseInt(item.split(",")[1]);
	            if(rc == "row"){
	                if(opreation == "insert"){
	                    if(itemrow >= activenum){
	                        var extendobj = {};
	                        newid = (itemrow + movenum) + "," + itemcol;
	                        $.extend(true,extendobj,dataobj.ecs[item]);
	                        extendobj.id = newid;
	                        delete dataobj.ecs[item];
	                        toArr.push(extendobj);
	                    }
	                }else if(opreation == "delete"){
	                    if(itemrow >= activenum && itemrow <= (activenum + movenum - 1)){
	                    	if(dataobj.ecs[item].etype === celltype.DE_TITLE){
								$(".excelHeadContent").find("[name=de_title]").attr("alreadyHave","0");
								$(".excelHeadContent").find("[name=de_title]").addClass("shortBtn").removeClass("shortBtn_disabled");
							}else if(dataobj.ecs[item].etype === celltype.DE_TAIL){
								$(".excelHeadContent").find("[name=de_tail]").attr("alreadyHave","0");
								$(".excelHeadContent").find("[name=de_tail]").addClass("shortBtn").removeClass("shortBtn_disabled");
							}else if(dataobj.ecs[item].etype === celltype.DE_BTN){
								$(".excelHeadContent").find("[name=de_btn]").attr("alreadyHave","0");
								$(".excelHeadContent").find("[name=de_btn]").addClass("shortBtn").removeClass("shortBtn_disabled");
							}else if(dataobj.ecs[item].etype === celltype.FNAME || dataobj.ecs[item].etype === celltype.FCONTENT
								|| dataobj.ecs[item].etype === celltype.NNAME || dataobj.ecs[item].etype === celltype.NADVICE){
								setFieldAttrHave(dataobj.ecs[item].efieldid,dataobj.ecs[item].etype,0);
							}else if(dataobj.ecs[item].etype === celltype.DETAIL){
								delete haveDetailMap[dataobj.ecs[item].edetail];
							}
	                        delete dataobj.ecs[item];
	                    }else if(itemrow > (activenum + movenum - 1)){
	                        var extendobj = {};
	                        newid = (itemrow - movenum) + "," + itemcol;
	                        $.extend(true,extendobj,dataobj.ecs[item]);
	                        extendobj.id = newid;
	                        delete dataobj.ecs[item];
	                        toArr.push(extendobj);
	                    }
	                }
	            }else if(rc == "col"){
	                if(opreation == "insert"){
	                    if(itemcol >= activenum){
	                        var extendobj = {};
	                        newid = itemrow + "," + (itemcol + movenum);
	                        $.extend(true,extendobj,dataobj.ecs[item]);
	                        extendobj.id = newid;
	                        delete dataobj.ecs[item];
	                        toArr.push(extendobj);
	                    }
	                }else if(opreation == "delete"){
	                    if(itemcol >= activenum && itemcol <= (activenum + movenum - 1)){
	                    	if(dataobj.ecs[item].etype === celltype.DE_TITLE){
								$(".excelHeadContent").find("[name=de_title]").attr("alreadyHave","0");
								$(".excelHeadContent").find("[name=de_title]").addClass("shortBtn").removeClass("shortBtn_disabled");
							}else if(dataobj.ecs[item].etype === celltype.DE_TAIL){
								$(".excelHeadContent").find("[name=de_tail]").attr("alreadyHave","0");
								$(".excelHeadContent").find("[name=de_tail]").addClass("shortBtn").removeClass("shortBtn_disabled");
							}else if(dataobj.ecs[item].etype === celltype.DE_BTN){
								$(".excelHeadContent").find("[name=de_btn]").attr("alreadyHave","0");
								$(".excelHeadContent").find("[name=de_btn]").addClass("shortBtn").removeClass("shortBtn_disabled");
							}else if(dataobj.ecs[item].etype === celltype.FNAME || dataobj.ecs[item].etype === celltype.FCONTENT
								|| dataobj.ecs[item].etype === celltype.NNAME || dataobj.ecs[item].etype === celltype.NADVICE){
								setFieldAttrHave(dataobj.ecs[item].efieldid,dataobj.ecs[item].etype,0);
							}else if(dataobj.ecs[item].etype === celltype.DETAIL){
								delete haveDetailMap[dataobj.ecs[item].edetail];
							}
	                        delete dataobj.ecs[item];
	                    }else if(itemcol > (activenum + movenum - 1)){
	                        var extendobj = {};
	                        newid = itemrow + "," + (itemcol - movenum);
	                        $.extend(true,extendobj,dataobj.ecs[item]);
	                        extendobj.id = newid;
	                        delete dataobj.ecs[item];
	                        toArr.push(extendobj);
	                    }
	                }
	            }
	        }
	        for (var i=0; i < toArr.length; i++){
	            dataobj.ecs[toArr[i].id] = toArr[i];
	        }
	        toArr.length = 0;
	    }
	}
	
	//清除单元格 1：样式:2：内容:3：全部
	function cleanCell(type){
		var control = scpmanager.getCacheValue(getActiveExcelId());
   		var excelDiv = control.getControl();
   		var dataobj = control.getDataObj();
   		try{
      		var ss = jQuery(excelDiv).wijspread("spread");
          	var sheet = ss.getActiveSheet();
          	var sels = sheet.getSelections();
          	sheet.isPaintSuspended(true);
			for (var n = 0; n < sels.length; n++) {
				var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
				for (var i = 0; i < sel.rowCount; i++) {
					for (var j = 0; j < sel.colCount; j++) {
						var r = sel.row + i;
              			var c = sel.col + j;
	                 	if(type==1 || type==3)
							sheet.setStyle(r, c, null, $.wijmo.wijspread.SheetArea.viewport);
						if(type==2 || type==3){
							sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).value("");
							sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).backgroundImage(null);
							sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).textIndent(0);
						}
						if(dataobj)
						if(dataobj.ecs)
						if(dataobj.ecs[r+","+c]){
							if(type==1 || type==3){
		                   		delete dataobj.ecs[r+","+c].enumbric;
		                   		delete dataobj.ecs[r+","+c].efont;
		                   		delete dataobj.ecs[r+","+c].eborder;
		                   		delete dataobj.ecs[r+","+c].ebgcolor;
		                   		delete dataobj.ecs[r+","+c].ealign
		                   		delete dataobj.ecs[r+","+c].ebgfill;
		                   		if(type == 1){
		                   			if(dataobj.ecs[r+","+c].etype===celltype.FCONTENT){
		                   				var imgsrc = "/workflow/exceldesign/image/controls/"+dataobj.ecs[r+","+c].efieldtype+getFieldAttr(dataobj.ecs[r+","+c].efieldid)+"_wev8.png";//图的名称很重要
		                   				if(isDetail === "on")
		                   					imgsrc = "/workflow/exceldesign/image/controls/"+dataobj.ecs[r+","+c].efieldtype+parentWin_Main.getFieldAttr(dataobj.ecs[r+","+c].efieldid)+"_wev8.png";//图的名称很重要
		                   				sheet.getCell(r,c,sheet.sheetArea).backgroundImage(imgsrc);
										sheet.getCell(r,c,sheet.sheetArea).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
										sheet.getCell(r,c,sheet.sheetArea).textIndent(3);
		                   			}else if(dataobj.ecs[r+","+c].etype===celltype.DETAIL){
		                   				var imgsrc = "/workflow/exceldesign/image/shortBtn/detail/detailTable_wev8.png";
		                   				sheet.getCell(r,c,sheet.sheetArea).backgroundImage(imgsrc);
										sheet.getCell(r,c,sheet.sheetArea).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
										sheet.getCell(r,c,sheet.sheetArea).textIndent(3);
		                   			}else if(dataobj.ecs[r+","+c].etype===celltype.DE_TITLE || dataobj.ecs[r+","+c].etype===celltype.DE_TAIL){
		                   				 var _style = new $.wijmo.wijspread.Style();
		                   				 _style.backColor = "#eeeeee";
		                   				 sheet.setStyle(r, c, _style, $.wijmo.wijspread.SheetArea.viewport);
		                   			}else if(dataobj.ecs[r+","+c].etype===celltype.DE_BTN){
		                   				var imgsrc = "/workflow/exceldesign/image/shortBtn/detail/de_btn_wev8.png";
		                   				sheet.getCell(r,c,sheet.sheetArea).backgroundImage(imgsrc);
										sheet.getCell(r,c,sheet.sheetArea).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
		                   			}
		                   		}
		                   	}
		                   	if(type==2 || type==3){
		                   		if(type==2){
		                   			if(dataobj.ecs[r+","+c].etype===celltype.DE_TITLE || dataobj.ecs[r+","+c].etype===celltype.DE_TAIL
		                   				|| dataobj.ecs[r+","+c].etype === celltype.DE_BTN || dataobj.ecs[r+","+c].etype === celltype.DETAIL){
		                   				sheet.setStyle(r, c, null, $.wijmo.wijspread.SheetArea.viewport);
		                   				if(dataobj.ecs[r+","+c].etype === celltype.DE_TITLE){
											$(".excelHeadContent").find("[name=de_title]").attr("alreadyHave","0");
											$(".excelHeadContent").find("[name=de_title]").addClass("shortBtn").removeClass("shortBtn_disabled");
										}else if(dataobj.ecs[r+","+c].etype === celltype.DE_TAIL){
											$(".excelHeadContent").find("[name=de_tail]").attr("alreadyHave","0");
											$(".excelHeadContent").find("[name=de_tail]").addClass("shortBtn").removeClass("shortBtn_disabled");
										}else if(dataobj.ecs[r+","+c].etype === celltype.DE_BTN){
											$(".excelHeadContent").find("[name=de_btn]").attr("alreadyHave","0");
											$(".excelHeadContent").find("[name=de_btn]").addClass("shortBtn").removeClass("shortBtn_disabled");
										}else if(dataobj.ecs[r+","+c].etype === celltype.DETAIL){
											delete haveDetailMap[dataobj.ecs[r+","+c].edetail];
										}
		                   			} 
		                   		}
		                   		if(dataobj.ecs[r+","+c].etype === celltype.FNAME || dataobj.ecs[r+","+c].etype === celltype.FCONTENT
									|| dataobj.ecs[r+","+c].etype === celltype.NNAME || dataobj.ecs[r+","+c].etype === celltype.NADVICE){
									setFieldAttrHave(dataobj.ecs[r+","+c].efieldid,dataobj.ecs[r+","+c].etype,0);
								}
		                   		dataobj.ecs[r+","+c].etype="";
		                   		delete dataobj.ecs[r+","+c].edetail;
		                   		delete dataobj.ecs[r+","+c].efieldid;
		                   		sheet.setIsProtected(false);
	                   		}
                  		}
					}
				}
			}
			sheet.isPaintSuspended(false);
		}catch(ex){
			window.top.Dialog.alert(ex.message);
		}
	}
	
	function clearFinancial(){
		var control = scpmanager.getCacheValue(getActiveExcelId());
		var excelDiv = control.getControl();
		var dataobj = control.getDataObj();
		var ss = jQuery(excelDiv).wijspread("spread");
    	var sheet = ss.getActiveSheet();
    	var sels = sheet.getSelections();
    	sheet.isPaintSuspended(true);
		for (var n = 0; n < sels.length; n++) {
			var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
			for (var i = 0; i < sel.rowCount; i++) {
				for (var j = 0; j < sel.colCount; j++) {
					var ar = sel.row+i;
					var ac = sel.col+j;
					if(dataobj)
					if(dataobj.ecs)
					if(dataobj.ecs[ar+","+ac]){
						if(!!dataobj.ecs[ar+","+ac].financial){
							if(dataobj.ecs[ar+","+ac].etype === celltype.FCONTENT){
								var _targetstatus = "";
								var _controltype = "";
								if(isDetail === "on")
									_targetstatus = parentWin_Main.getFieldAttr(dataobj.ecs[ar+","+ac].efieldid);
								else
									_targetstatus = getFieldAttr(dataobj.ecs[ar+","+ac].efieldid);
								var htmltype = $("a[_flag=Fcontent][_fieldid="+dataobj.ecs[ar+","+ac].efieldid+"]").children("[name=fieldtype]").val();
								var fieldtype = $("a[_flag=Fcontent][_fieldid="+dataobj.ecs[ar+","+ac].efieldid+"]").children("[name=fieldtypedetail]").val();
								if(htmltype==="3"){
									if(fieldtype==="2")	_controltype = controltype.DATE;
									else if(fieldtype==="19")_controltype = controltype.TIME;
									else _controltype=controltype.BROWSER;
								}	else if(htmltype==="1")_controltype=controltype.TEXT;
								else if(htmltype==="2")_controltype=controltype.TEXTAREA;
								else if(htmltype==="4")_controltype=controltype.CHECKBOX;
								else if(htmltype==="5")_controltype=controltype.SELECT;
								else if(htmltype==="6")_controltype=controltype.AFFIX;
								else if(htmltype==="7")_controltype=controltype.LINK;
								else if(htmltype==="8")_controltype=controltype.RADIO;
								var imgsrc = "/workflow/exceldesign/image/controls/"+_controltype+_targetstatus+"_wev8.png";//图的名称很重要
								sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImage(imgsrc);
        						delete dataobj.ecs[ar+","+ac].financial;
       						}else if(dataobj.ecs[ar+","+ac].etype === celltype.FNAME){
       							sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImage(null);
       							if(dataobj.ecs[ar+","+ac].etxtindent)
       								sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).textIndent(dataobj.ecs[ar+","+ac].etxtindent);
       							else
       								sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).textIndent(0);
       							delete dataobj.ecs[ar+","+ac].financial;
       						}
   						}
    				}
				}
			}
		}
		sheet.isPaintSuspended(false);
	}
	
	//表格保存封装
	function saveTable2Json(key)
	{
		var control = scpmanager.getCacheValue(getActiveExcelId());
   		var excelDiv = control.getControl();
   		var ss = jQuery(excelDiv).wijspread("spread");
   		var sheet = ss.getActiveSheet();
   		var tableData = control.getDataObj();
   		//console.log(JSON.stringify(tableData));
   		var ecs = tableData.ecs;
   		if(!ecs) return "";
   		
   		var spans = sheet.getSpans();		//获取合并单元格
   		//给ecs添加合并单元格信息
   		for(var item in ecs){
   			var id_x = item.split(",")[0];
			var id_y = item.split(",")[1];
			var rowspan = 1;
			var columnspan = 1;
			//获取合并单元格信息
			for (var i = 0; i < spans.length; i++) {
				if ((spans[i].row + "") == id_x && (spans[i].col + "") == id_y) {
					rowspan = spans[i].rowCount;
					columnspan = spans[i].colCount;
					break;
				}
			}
			ecs[item].rowspan = rowspan;
			ecs[item].columnspan = columnspan;
   		}
   		//计算最大行数、列数
   		var maxCell = getMaxCell(ecs);
   		var rowcount = parseInt(maxCell.split(",")[0]);	//之后需要替换成寻找对象中最大[行/列]数方法;
 		var columncount = parseInt(maxCell.split(",")[1]);
 		
 		var rowspan = 1;
		var columnspan = 1;
		var edtitlerow = 0;
		var edtailrow = 0;
		var save2Json = "";
   		if(key.indexOf("main")>=0)
   		{
   			save2Json += "\"emaintable\":{";
   		}else if(key.indexOf("detail")>=0)
   			save2Json += "\""+key+"\":{";
   		//行头
   		save2Json +="\"rowheads\":{"
		for (var i = 0; i <= rowcount; i++) {
			save2Json += "\"row_"+i+"\":\""+sheet.getRowHeight(i, $.wijmo.wijspread.SheetArea.rowHeader)+"\"";
			save2Json += (rowcount-i>0)?",":"";
		}
		save2Json +="},"
		
		//列头
		save2Json += "\"colheads\":{"
		for (var i = 0; i <= columncount; i++) {
			var ispercent = sheet.getValue(0,i,$.wijmo.wijspread.SheetArea.colHeader);
			var cw = sheet.getColumnWidth(i, $.wijmo.wijspread.SheetArea.colHeader)
			if(ispercent.indexOf("%") >0)
				cw = ispercent.substring(ispercent.indexOf("(")+1,ispercent.indexOf(")"));
			save2Json += "\"col_"+i+"\":\""+cw+"\"";
			save2Json += (columncount-i>0)?",":"";
		}
		save2Json +="},"
		
		//浮动图片
		if(sheet._floatingObjectArray)
		{
			var floatpic = JSON.stringify((sheet._floatingObjectArray).toJSON());
			if(floatpic)
				save2Json += "\"floatingObjectArray\":"+floatpic+",";
		}
		if(ss.backgroundImage())
		{
			save2Json += "\"backgroundImage\":\""+ss.backgroundImage()+"\",";
		}
		//单元格
		save2Json += "\"ec\":[";
		if(""!=ecs)
		{
			var ecs2Json = "";
			for(var item in ecs)
			{
				//坐标拆分
				var id_x = item.split(",")[0];
				var id_y = item.split(",")[1];
				var ecObj = ecs[item];
				var etype = ecObj.etype;
				rowspan = 1;
				columnspan = 1;
				//获取合并单元格信息
				for (var i = 0; i < spans.length; i++) {
					if ((spans[i].row + "") == id_x && (spans[i].col + "") == id_y) {
						rowspan = spans[i].rowCount;
						columnspan = spans[i].colCount;
						break;
					}
				}
				if(etype === celltype.DE_TITLE)
					edtitlerow = id_x;
				else if(etype === celltype.DE_TAIL)
					edtailrow = id_x;
				etype = transformerEtype(etype);
				ecs2Json += "{";
				ecs2Json += "\"id\":\""+item+"\",";
				if(ecObj.ebgcolor)
					ecs2Json += "\"backgroundColor\":\""+ecObj.ebgcolor+"\",";
				ecs2Json += "\"colspan\":\""+columnspan+"\",";
				ecs2Json += "\"rowspan\":\""+rowspan+"\",";
				ecs2Json += (etype)?"\"etype\":\""+etype+"\",":"\"etype\":\"\",";
				//因etype 已转换成数字，所以4种表格类型需要用到field
				//字段，表单内容，节点，流转意见
				if(etype === "2" || etype === "3" || etype === "4" || etype === "5" || etype === "11" || etype === "6") 
				{
					ecs2Json += "\"field\":\""+ecObj.efieldid+"\",";		//字段ID，流程节点ID
					if(etype === "3" || etype === "5" || etype === "11" || etype === "6")
						ecs2Json += "\"fieldtype\":\""+ecObj.efieldtype+"\",";		//字段ID，流程节点ID
					if(etype === "3" && false)	//目前这个功能是没用的
					{
						var style4img = sheet.getStyle(id_x,id_y, $.wijmo.wijspread.SheetArea.viewport);
						style4img = style4img.backgroundImage;
						var fieldattr = 0;
						if(style4img.indexOf("1") >= 0)
							fieldattr = "1";
						else if(style4img.indexOf("2") >= 0)
							fieldattr = "2";
						else if(style4img.indexOf("3") >= 0)
							fieldattr = "3";
						
						if(isDetail === "on")
							parentWin_Main.fieldAttrMap["fieldattr"+ecObj.efieldid] = fieldattr;
						else
							fieldAttrMap["fieldattr"+ecObj.efieldid] = fieldattr;
							
					}
				}else if(etype === "7")
				{
					ecs2Json += "\"detail\":\""+ecObj.edetail+"\",";		//明细表			
				}
				ecs2Json += "\"font\":{";		//字体设置
				if(ecObj.efont)
				{
					ecs2Json += (ecObj.efont.f_italic)?"\"italic\":\"true\",":"\"italic\":\"false\",";
					ecs2Json += (ecObj.efont.f_bold)?"\"bold\":\"true\",":"\"bold\":\"false\",";
					ecs2Json += (ecObj.efont.f_size)?"\"font-size\":\""+ecObj.efont.f_size+"\",":"\"font-size\":\"\",";
					ecs2Json += (ecObj.efont.f_family)?"\"font-family\":\""+ecObj.efont.f_family+"\",":"\"font-family\":\"\",";
					ecs2Json += (ecObj.efont.f_color)?"\"color\":\""+ecObj.efont.f_color+"\",":"\"color\":\"\",";
					ecs2Json += (ecObj.efont.f_underline)?"\"underline\":\"true\",":"\"underline\":\"false\",";
					ecs2Json += (ecObj.efont.f_deleteline)?"\"deleteline\":\"true\"":"\"deleteline\":\"false\"";
				}
				if(ecObj.ealign)
				{
					if(ecObj.efont)
						ecs2Json += ",";
					var text_align = "";
					if(ecObj.ealign.a_halign)	//非要前台转，哎
					{
						if(ecObj.ealign.a_halign == 0)
							text_align = "left";
						else if(ecObj.ealign.a_halign == 1)
						 	text_align = "center";
						else if(ecObj.ealign.a_halign == 2)
							text_align = "right";
					}
					ecs2Json += "\"text-align\":\""+text_align+"\",";
					var valign = "";
					if(ecObj.ealign.a_valign)
					{
						if(ecObj.ealign.a_valign == 0)
							valign = "top";
						else if(ecObj.ealign.a_valign == 1)
						 	valign = "middle";
						else if(ecObj.ealign.a_valign == 2)
							valign = "bottom";
					}
					ecs2Json += "\"valign\":\""+valign+"\",";
					//ecs2Json += (ecObj.ealign.indent)?"\"indent\":\""+ecObj.ealign.indent+"\",":"\"indent\":\"\",";
					ecs2Json += (ecObj.ealign.a_wrap)?"\"autoWrap\":\""+ecObj.ealign.a_wrap+"\"":"\"autoWrap\":\"\"";
				}
				ecs2Json += "},";	//对应 font :{
				ecs2Json += "\"format\":{";	//数值格式
				if(ecObj.enumbric)
				{
					ecs2Json += (ecObj.enumbric.n_set)?"\"numberType\":\""+ecObj.enumbric.n_set+"\",":"\"numberType\":\"-1\",";
					ecs2Json += (ecObj.enumbric.n_decimals)?"\"decimals\":\""+ecObj.enumbric.n_decimals+"\",":"\"decimals\":\"-1\",";
					ecs2Json += (ecObj.enumbric.n_us)?"\"thousands\":\""+ecObj.enumbric.n_us+"\",":"\"thousands\":\"-1\",";
					ecs2Json += (ecObj.enumbric.n_target)?"\"formatPattern\":\""+ecObj.enumbric.n_target+"\"":"\"formatPattern\":\"-1\"";
				}
				ecs2Json += "},";	//对应 format:{
				if(ecObj.etxtindent)
				{
					ecs2Json += "\"etxtindent\":\""+ecObj.etxtindent+"\",";
				}
				if(ecObj.financial)
				{
					ecs2Json += "\"financial\":\""+ecObj.financial+"\",";
				}
				if(ecObj.formula)
				{
					ecs2Json += "\"formula\":\""+ecObj.formula+"\",";
				}
				ecs2Json += "\"eborder\":[";
				var topborder = sheet.getCell(id_x,id_y,$.wijmo.wijspread.SheetArea.viewport).borderTop();
				if(topborder) ecs2Json += "{\"kind\":\"top\",\"style\":\""+topborder.style+"\",\"color\":\""+topborder.color+"\"}";
				var leftborder = sheet.getCell(id_x,id_y,$.wijmo.wijspread.SheetArea.viewport).borderLeft();
				if(leftborder){ 
					if(topborder) ecs2Json +=",";
					ecs2Json += "{\"kind\":\"left\",\"style\":\""+leftborder.style+"\",\"color\":\""+leftborder.color+"\"}";
				}
				var rightborder
				if(columnspan > 1)
					 rightborder = sheet.getCell(id_x,(parseInt(id_y)+columnspan-1)+"",$.wijmo.wijspread.SheetArea.viewport).borderRight();
				else
					rightborder = sheet.getCell(id_x,id_y,$.wijmo.wijspread.SheetArea.viewport).borderRight();
				if(rightborder){
					if(topborder || leftborder) ecs2Json +=",";
					ecs2Json += "{\"kind\":\"right\",\"style\":\""+rightborder.style+"\",\"color\":\""+rightborder.color+"\"}";
				}
				var bottomborder 
				if(rowspan > 1)
					bottomborder = sheet.getCell((parseInt(id_x)+rowspan-1)+"",id_y,$.wijmo.wijspread.SheetArea.viewport).borderBottom();
				else
					bottomborder = sheet.getCell(id_x,id_y,$.wijmo.wijspread.SheetArea.viewport).borderBottom();
				if(bottomborder) {
					if(topborder || leftborder || rightborder) ecs2Json +=",";
					ecs2Json += "{\"kind\":\"bottom\",\"style\":\""+bottomborder.style+"\",\"color\":\""+bottomborder.color+"\"}";
				}
				ecs2Json += "],";	//对应 eborder：[
				ecs2Json += "\"evalue\":\""+sheet.getCell(id_x,id_y,$.wijmo.wijspread.SheetArea.viewport).text()+"\"";
				ecs2Json += "},";	//对应 ec 中第一个{
			}
			ecs2Json = ecs2Json.substring(0,ecs2Json.lastIndexOf(","));
			save2Json += ecs2Json;
		}
		save2Json += "]";		//对应 ec: [
		if(edtitlerow != 0 && edtailrow!=0)
		{
			save2Json +=",";
			save2Json +="\"edtitleinrow\":\""+edtitlerow+"\",";
			save2Json +="\"edtailinrow\":\""+edtailrow+"\"";
		}
		save2Json += "}";		//对应 emaintable：{
		save2Json = StringReplace2SaveJson(save2Json);
		return save2Json;
	}
	
	
	//恢复一个单元格 封装
	function resumeCell(cell_obj)
	{
		var etype = reverseTransformerEtype(cell_obj.etype);
		if(etype === celltype.DE_TITLE)
		{
			$(".excelHeadContent").find("[name=de_title]").attr("alreadyHave","1");
			$(".excelHeadContent").find("[name=de_title]").addClass("shortBtn_disabled").removeClass("shortBtn");
		}else if(etype === celltype.DE_TAIL)
		{
			$(".excelHeadContent").find("[name=de_tail]").attr("alreadyHave","1");
			$(".excelHeadContent").find("[name=de_tail]").addClass("shortBtn_disabled").removeClass("shortBtn");
		}else if(etype === celltype.DE_BTN)
		{
			$(".excelHeadContent").find("[name=de_btn]").attr("alreadyHave","1");
			$(".excelHeadContent").find("[name=de_btn]").addClass("shortBtn_disabled").removeClass("shortBtn");
		}else if(etype === celltype.FNAME || etype === celltype.FCONTENT
			|| etype === celltype.NNAME || etype === celltype.NADVICE)
		{
			setFieldAttrHave(cell_obj.field,etype,1);
			//if(etype === celltype.FCONTENT || etype === celltype.NADVICE)
			//if(nodetype === "3" || whichlayout === "1");
				//setCellImageRead(cell_obj.field);
		}else if(etype === celltype.DETAIL)
		{
			haveDetailMap[cell_obj.detail]="on";
		}
		
		var bxid = cell_obj.id;
		var eborder;
		if(!jQuery.isEmptyObject(cell_obj.eborder) && cell_obj.eborder.length >0)
			eborder = true;
		
		var efont;
		var ealign;
		if(!jQuery.isEmptyObject(cell_obj.font))
		{
			//只要有其中一个，那么就有这个对象
			if(!jQuery.isEmptyObject(cell_obj.font.bold))
			{
				efont = {};
				efont.f_bold = cell_obj.font.bold;
				if(efont.f_bold === "true") efont.f_bold = true;else efont.f_bold =false;
				efont.f_color = cell_obj.font.color;
				efont.f_italic = cell_obj.font.italic;
				if(efont.f_italic === "true") efont.f_italic = true;else efont.f_italic =false;
				efont.f_size = cell_obj.font["font-size"];	//中划线会影响json
				efont.f_family = cell_obj.font["font-family"];
				efont.f_underline = cell_obj.font.underline;
				if(efont.f_underline === "true") efont.f_underline = true;else efont.f_underline =false;
				efont.f_deleteline = cell_obj.font.deleteline;
				if(efont.f_deleteline === "true") efont.f_deleteline = true;else efont.f_deleteline =false;
			}
			if(!jQuery.isEmptyObject(cell_obj.font["text-align"]))
			{
				ealign = {};
				if(cell_obj.font["text-align"] === "left")
					ealign.a_halign = 0;
				else if(cell_obj.font["text-align"] === "center")
					ealign.a_halign = 1;
				else if(cell_obj.font["text-align"] === "right")
					ealign.a_halign = 2;	
				if(cell_obj.font.valign === "top")
					ealign.a_valign = 0;
				else if(cell_obj.font.valign === "middle")
					ealign.a_valign = 1;
				else if(cell_obj.font.valign === "bottom")
					ealign.a_valign = 2;
				if(cell_obj.font.indent)
					ealign.indent = cell_obj.font.indent;
				if(cell_obj.font.autoWrap)
				{
					ealign.a_wrap = cell_obj.font.autoWrap;
					if(ealign.a_wrap === "true") ealign.a_wrap = true;else ealign.a_wrap =false;
				}
			}
			
		}
		var enumbric;
		if(!jQuery.isEmptyObject(cell_obj.format))
		{
			enumbric = {};
			enumbric.n_set = cell_obj.format.numberType;
			enumbric.n_decimals = cell_obj.format.decimals;
			enumbric.n_us = cell_obj.format.thousands;
			enumbric.n_target = cell_obj.format.formatPattern;
		}
		var efieldid;
		if(!jQuery.isEmptyObject(cell_obj.field))
			efieldid = cell_obj.field;
		var efieldtype;
		if(!jQuery.isEmptyObject(cell_obj.fieldtype))
			efieldtype = cell_obj.fieldtype;
		var edetail;
		if(!jQuery.isEmptyObject(cell_obj.detail))
			edetail = cell_obj.detail;
			
		var ebgcolor;
		if(!jQuery.isEmptyObject(cell_obj.backgroundColor))
			ebgcolor = cell_obj.backgroundColor;
		var etxtindent;
		if(!jQuery.isEmptyObject(cell_obj.etxtindent))
			etxtindent = cell_obj.etxtindent;
		var financial;
		if(!jQuery.isEmptyObject(cell_obj.financial))
			financial = cell_obj.financial;
		var formula;
		if(!jQuery.isEmptyObject(cell_obj.formula))
			formula = cell_obj.formula;
		var cell = {};
		cell.etype = etype;
		cell.id = bxid;
		cell.eborder = eborder;
		cell.efont = efont;
		cell.ealign = ealign;
		cell.enumbric = enumbric;
		cell.efieldid = efieldid;
		cell.efieldtype = efieldtype;
		cell.edetail = edetail;
		cell.ebgcolor = ebgcolor;
		cell.etxtindent = etxtindent;
		cell.financial = financial;
		cell.formula = formula;
		setCellProperties(bxid,etype,cell);
	}
	//设置 字段 必填 只读 编辑
	function setFieldPro(filltype)
	{
		var control = scpmanager.getCacheValue(getActiveExcelId());
   		var excelDiv = control.getControl();
   		var dataobj = control.getDataObj();
   		if (dataobj.ecs === undefined ||  ""===dataobj.ecs)	//单元格自定义属性都没有，那还要做什么呢？
   			return;
   		var ss = jQuery(excelDiv).wijspread("spread");
       	var sheet = ss.getActiveSheet();
       	var sels = sheet.getSelections();
       	sheet.isPaintSuspended(true);
       	for (var n = 0; n < sels.length; n++) {
			var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
			for (var i = 0; i < sel.rowCount; i++) {
				for (var j = 0; j < sel.colCount; j++) {
					var r = i + sel.row;
					var c = j + sel.col;
					if(!dataobj.ecs[r+","+c]) continue;	//如果单元格没有自定义属性，下面就不需要做什么了
					if(dataobj.ecs[r+","+c].etype === celltype.FCONTENT || dataobj.ecs[r+","+c].etype === celltype.NADVICE)
					{
						var efiledid = parseInt(dataobj.ecs[r+","+c].efieldid);
						if(efiledid == -4) continue;		//排除签字意见
						if(efiledid == -1 && filltype == 2) {	//标题字段特殊处理
							setFieldAttr(efiledid,3);
							var imgsrc = "/workflow/exceldesign/image/controls/"+dataobj.ecs[r+","+c].efieldtype+3+"_wev8.png";
							sheet.getCell(r,c,sheet.sheetArea).backgroundImage(imgsrc);
							sheet.getCell(r,c,sheet.sheetArea).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
						}else
						{
							if(isDetail === "on")
								parentWin_Main.setFieldAttr(efiledid,filltype);
							else
								setFieldAttr(efiledid,filltype);
							var imgsrc = "";
							if(dataobj.ecs[r+","+c].financial)
								imgsrc = "/workflow/exceldesign/image/controls/finance"+filltype+"_wev8.png";
							else
								imgsrc = "/workflow/exceldesign/image/controls/"+dataobj.ecs[r+","+c].efieldtype+filltype+"_wev8.png";
							sheet.getCell(r,c,sheet.sheetArea).backgroundImage(imgsrc);
							sheet.getCell(r,c,sheet.sheetArea).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
						}
					}
				}
			}
		}
       	sheet.isPaintSuspended(false);
	}
   	
   	function getDetailMenuJson()
   	{
   		var detailMenuStr = "";
		var detaiMenuJson; 
		if(!isDetail)
		{
			detailMenuStr += "{";
			detailMenuStr += "\"children\": [";
			var detailnum = getDetailNum();
			for(var i=1;i<=parseInt(detailnum);i++){
				detailMenuStr += "{";
				detailMenuStr += "\"title\" : \"明细表"+i+"\",";
				detailMenuStr += "\"icon\":\"rmenudetail\",";
				detailMenuStr += "\"action\":\"detail_"+i+"\"";
				detailMenuStr += "}";
				if(i<parseInt(detailnum))detailMenuStr += ",";
			}
			detailMenuStr += "]";
			detailMenuStr += "}";
			//console.log(detailMenuStr);
			detaiMenuJson = JSON.parse(detailMenuStr); 
		}
		return detaiMenuJson;
   	}
   	
   	//设置行高列宽
   	function setRChw(rc)
   	{
   		var control = scpmanager.getCacheValue(getActiveExcelId());
   		var excelDiv = control.getControl();
   		var ss = jQuery(excelDiv).wijspread("spread");
       	var sheet = ss.getActiveSheet();
       	var sel = sheet.getSelections();
       	if (sel.length > 0) {
            sel = getActualCellRange(sel[sel.length - 1], sheet.getRowCount(), sheet.getColumnCount());
        }
        var defaultvar = 0;
        var iscolpercent = false;
        if(rc === "r")
        {
        	for(var i=0;i < sel.rowCount; i++)
        	{
        		if(i==0)defaultvar = sheet.getRowHeight(sel.row+i,$.wijmo.wijspread.SheetArea.viewport);
        		else{
        			if(sheet.getRowHeight(sel.row+i,$.wijmo.wijspread.SheetArea.viewport) != defaultvar)
        			{	
        				defaultvar = -1;
        				break;
        			}
        		}
        	}
        }else if(rc === "c")
        {
        	for(var i=0;i < sel.colCount; i++)
        	{
        		var colheadtxt = sheet.getValue(0,sel.col+i,$.wijmo.wijspread.SheetArea.colHeader);
        		if(colheadtxt.indexOf("%") >0)
        		{
        			iscolpercent = true;
        			break;
       			}
        	}
        	if(iscolpercent)
        	{
        		for(var i=0;i < sel.colCount; i++)
	        	{
	        		var colheadtxt = sheet.getValue(0,sel.col+i,$.wijmo.wijspread.SheetArea.colHeader);
	        		if(colheadtxt.indexOf("%") < 0)
	        		{
	        			defaultvar = -1;
	        			break;
        			}
        			colheadtxt = colheadtxt.split(" ")[1];
	        		if(i==0) defaultvar = parseInt(colheadtxt.substring(1,colheadtxt.lastIndexOf(")")));
	        		else {
	        			if(defaultvar != parseInt(colheadtxt.substring(1,colheadtxt.lastIndexOf(")"))))
	        			{
	        				defaultvar = -1;
	        				break;
	        			}
	        		}
	        	}
        	}else
        	{
	        	for(var i=0;i < sel.colCount; i++)
	        	{
	        		if(i==0)defaultvar = sheet.getColumnWidth(sel.col+i,$.wijmo.wijspread.SheetArea.viewport);
	        		else{
	        			if(sheet.getColumnWidth(sel.col+i,$.wijmo.wijspread.SheetArea.viewport) != defaultvar)
	        			{	
	        				defaultvar = -1;
	        				break;
	        			}
	        		}
	        	}
        	}
        }
   		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/exceldesign/excelSetRChw.jsp?isrc="+rc+"&defaultvar="+defaultvar+"&iscolpercent="+iscolpercent;
		if(rc==="r")
			dialog.Title = "设置行高";
		else
			dialog.Title = "设置列宽";
		dialog.Width = 200;
		dialog.Height = 150;
		dialog.normalDialog = false;
		dialog.Drag = true; 	
		dialog.URL = url;
		dialog.show();
		dialog.callbackfun = function (paramobj, result) {
			if( !result ) return;
			var djson = result;
			try{
				
	           	sheet.isPaintSuspended(true);
	            
	            if(rc === "r")
	            	for(var x=0;x<sel.rowCount;x++)
	            		sheet.setRowHeight(sel.row+x,djson.value,$.wijmo.wijspread.SheetArea.viewport);
	            else
	            {
	            	if(djson.type === "1")
	            	{
		            	for(var y=0;y<sel.colCount;y++)
		            	{
		            		sheet.setColumnWidth(sel.col+y,djson.value,$.wijmo.wijspread.SheetArea.viewport);
		            		var colheadtxt = sheet.getValue(0,sel.col+y,$.wijmo.wijspread.SheetArea.colHeader);
	            			if(colheadtxt.indexOf("%") >0)
	            				colheadtxt = colheadtxt.split(" ")[0];
	            			sheet.setValue(0, sel.col+y, colheadtxt, $.wijmo.wijspread.SheetArea.colHeader);
	            		}
	            	}else
	            	{
	            		for(var y=0;y<sel.colCount;y++)
	            		{
	            			var colheadtxt = sheet.getValue(0,sel.col+y,$.wijmo.wijspread.SheetArea.colHeader);
	            			if(colheadtxt.indexOf("%") >0)
	            				colheadtxt = colheadtxt.split(" ")[0];
	            			sheet.setValue(0, sel.col+y, colheadtxt+" ("+djson.value+"%)", $.wijmo.wijspread.SheetArea.colHeader);
	            		}
	            	}
	       		}
	           	sheet.isPaintSuspended(false);
           	}catch (ex) {
	            window.top.Dialog.alert(ex.message);
	        }
		}
   	}
   	
   	function drawborder()
   	{
   		var borderval = $(".excelHeadContent").find("[name=bordertype]").val();
		var bordercolor = $(".excelHeadContent").find(".bordercolorvalue").val();
		var borderstyle = parseInt($(".excelHeadContent").find("[name=borderline]").val());
		//alert(borderval+","+bordercolor+":"+borderstyle);
		var whichborder = "";
             	switch (borderval)
             	{
                 	case "1":
                     	whichborder="bottom";
                     	break;
                 	case "2":
                     	whichborder="top";
                     	break;
                 	case "3":
                     	whichborder="left";
                     	break;
                 	case "4":
                     	whichborder="right";
                     	break;
                 	case "5":
                     	break;
                 	case "6":
                     	whichborder="all";
                     	break;
                 	case "7":
                     	whichborder="outline";
                     	break;
                 	case "8":
                     	whichborder="inside";
                     	break;
                 	case "9":
                     	whichborder="hinside";
                     	break;
                 	case "10":
                     	whichborder="vinside";
                     	break;
		}
		var control = scpmanager.getCacheValue(getActiveExcelId());
      		var excelDiv = control.getControl();
      		var ss = jQuery(excelDiv).wijspread("spread");
          	var sheet = ss.getActiveSheet();
        var lineBorder = new $.wijmo.wijspread.LineBorder(bordercolor, borderstyle);
        var sels = sheet.getSelections();
        sheet.isPaintSuspended(true);
        for (var n = 0; n < sels.length; n++) {
            var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
            var haveborder = false;
            if(whichborder != "")
            {
                sheet.setBorder(sel, lineBorder, {
                              left: whichborder == "left",
                              right:whichborder == "right",
                              top:whichborder == "top",
                              bottom:whichborder == "bottom",
                              all:whichborder == "all",
                              outline:whichborder == "outline",
                              inside:whichborder == "inside",
                              innerHorizontal: whichborder == "hinside",
                              innerVertical: whichborder == "vinside"
                          });
				haveborder = true;
            }else
            {
                sheet.setBorder(sel, null, {all:true});
                haveborder = false;
            }
            //设置自定义属性，标识单元格是有边框的；无论什么边框，在保存的时候会去取
            for (var i = 0; i < sel.rowCount; i++) {
                   for (var j = 0; j < sel.colCount; j++) {
                   	var r = sel.row + i;
                 			var c = sel.col + j;
	       	 		var cell = {};
					cell.eborder = haveborder;
					setCellProperties(r+","+c,"",cell);
					if(r === sheet.getRowCount()-1)
						insertRowandCol4Last("row");
					if(c === sheet.getColumnCount()-1)
						insertRowandCol4Last("col");
				}
			}
        }
        sheet.isPaintSuspended(false);
   	}
   	
   	function StringReplace2SaveJson(s){
   		s = s.replace(new RegExp("\\\\","gm"),"\\\\");
   		//s = s.replace(new RegExp("/","gm"),"\\/");
   		//s = s.replace(new RegExp("'","gm"),"\\\'");
		s = s.replace(new RegExp("\n","gm"),"\\n");
		s = s.replace(new RegExp("\r","gm"),"\\r");
		s = s.replace(new RegExp("\t","gm"),"\\t");
		s = s.replace(new RegExp("\v","gm"),"\\v");
		s = s.replace(new RegExp("\f","gm"),"\\f");
		return s;
   	}
   	
   	function getMenuJson(){
		var menuStr = "{";
			menuStr += "\"children\": [{";
		if(whichlayout == "0" && nodetype!="3"){	//非归档节点显示模板
	   		var _menu_rem = getFieldREM();
			var isfield = (_menu_rem.split(",")[0]==="true")?true:false;
			var istitlefield = (_menu_rem.split(",")[1]==="true")?true:false;
			var isspecial = (_menu_rem.split(",")[2]==="true")?true:false;
			if(isfield || istitlefield || isspecial){
				menuStr += "\"title\" : \"只读\",";
				menuStr += "\"icon\": \"rmenuread\",";
				menuStr += "\"action\": \"readonly\"";
				menuStr += "},{";
				if(isfield){
					menuStr += "\"title\" : \"编辑\",";
					menuStr += "\"icon\": \"rmenuedit\",";
					menuStr += "\"action\": \"canedit\"";
					menuStr += "},{";
				}
				if(isfield || istitlefield){
					menuStr += "\"title\" : \"必填\",";
					menuStr += "\"icon\": \"rmenurequired\",";
					menuStr += "\"action\": \"required\"";
					menuStr += "},{";
					menuStr += "\"title\" : \"\"";
					menuStr += "},{";
				}
			}
		}
			menuStr += "\"title\" : \"剪切\",";
			menuStr += "\"icon\": \"rmenucut\",";
			menuStr += "\"action\": \"cut\"";
			menuStr += "},{";
			menuStr += "\"title\" : \"复制\",";
			menuStr += "\"icon\": \"rmenucopy\",";
			menuStr += "\"action\": \"copy\"";
			menuStr += "},{";
			menuStr += "\"title\" : \"粘贴\",";
			menuStr += "\"icon\": \"rmenupaste\",";
			menuStr += "\"action\": \"paste\"";
			menuStr += "},{";
			menuStr += "\"title\" : \"\"";
			menuStr += "},{";
			if(rightMenuSelectCase === "row")
			{
				menuStr += "\"title\" : \"插入行\",";
				menuStr += "\"icon\":\"rmenuinsertrow\",";
				menuStr += "\"action\":\"insertrow\"";
				menuStr += "},";
				menuStr += "{";
				menuStr += "\"title\" : \"删除行\",";
				menuStr += "\"icon\":\"rmenudelrow\",";
				menuStr += "\"action\":\"deleterow\"";
				menuStr += "},{";
			}else if(rightMenuSelectCase === "col")
			{
				menuStr += "\"title\" : \"插入列\",";
				menuStr += "\"icon\":\"rmenuinsertcol\",";
				menuStr += "\"action\":\"insertcol\"";
				menuStr += "},";
				menuStr += "{";
				menuStr += "\"title\" : \"删除列\",";
				menuStr += "\"icon\":\"rmenudelcol\",";
				menuStr += "\"action\":\"deletecol\"";
				menuStr += "},{";
			}else if(rightMenuSelectCase === "nor")
			{
				menuStr += "\"title\" : \"插入\",";
				menuStr += "\"icon\": \"rmenuinsert\",";
				menuStr += "\"action\":\"\",";
				menuStr += "\"submenuWidth\":130,";
				menuStr += "\"children\": [";
				menuStr += "{";
				menuStr += "\"title\" : \"插入行\",";
				menuStr += "\"icon\":\"rmenuinsertrow\",";
				menuStr += "\"action\":\"insertrow\"";
				menuStr += "},";
				menuStr += "{";
				menuStr += "\"title\" : \"插入列\",";
				menuStr += "\"icon\":\"rmenuinsertcol\",";
				menuStr += "\"action\":\"insertcol\"";
				menuStr += "}";
				menuStr += "]";
				menuStr += "},{";
				menuStr += "\"title\" : \"删除\",";
				menuStr += "\"icon\": \"rmenudel\",";
				menuStr += "\"action\":\"\",";
				menuStr += "\"submenuWidth\":130,";
				menuStr += "\"children\": [";
				menuStr += "{";
				menuStr += "\"title\" : \"删除行\",";
				menuStr += "\"icon\":\"rmenudelrow\",";
				menuStr += "\"action\":\"deleterow\"";
				menuStr += "},";
				menuStr += "{";
				menuStr += "\"title\" : \"删除列\",";
				menuStr += "\"icon\":\"rmenudelcol\",";
				menuStr += "\"action\":\"deletecol\"";
				menuStr += "}";
				menuStr += "]";
				menuStr += "},{";
			}
			menuStr += "\"title\" : \"清除内容\",";
			menuStr += "\"icon\": \"rmenucleanc\",";
			menuStr += "\"action\":\"cleanContent\"";
			menuStr += "},{";
			menuStr += "\"title\" : \"\"";
			menuStr += "},{";
			menuStr += "\"title\" : \"单元格格式\",";
			menuStr += "\"icon\": \"rmenupro\",";
			menuStr += "\"action\":\"setStyle\"";
			menuStr += "},{";
			menuStr += "\"title\" : \"行高\",";
			menuStr += "\"icon\": \"rmenurh\",";
			menuStr += "\"action\":\"setrowheight\"";
			menuStr += "},{";
			menuStr += "\"title\" : \"列宽\",";
			menuStr += "\"icon\": \"rmenucw\",";
			menuStr += "\"action\":\"setcolwidth\"";
			menuStr += "},{";
			menuStr += "\"title\" : \"清除格式\",";
			menuStr += "\"icon\": \"rmenucleans\",";
			menuStr += "\"action\":\"cleanStyle\"";
			menuStr += "}";
			if(isDetail != 'on' ){			//主表
				var detailnum = getDetailNum();
				if(parseInt(detailnum)>0){
					menuStr += ",{";
					menuStr += "\"title\" : \"\"";
					menuStr += "}";
					menuStr += ",";
					menuStr += "{";
					menuStr += "\"title\" : \"插入明细\",";
					menuStr += "\"icon\": \"rmenuindetail\",";
					menuStr += "\"submenuWidth\": 130,";
					menuStr += "\"children\": [";
					for(var i=1;i<=parseInt(detailnum);i++){
						menuStr += "{";
						menuStr += "\"title\" : \"明细表"+i+"\",";
						menuStr += "\"icon\":\"rmenudetail\",";
						menuStr += "\"action\":\"detail_"+i+"\"";
						menuStr += "}";
						if(i<parseInt(detailnum))menuStr += ",";
					}
					menuStr += "]";
					menuStr += "}";
				}
			}
		menuStr += "]}";
		var menuJson = JSON.parse(menuStr); 
		return menuJson;
   	}
   	
   	function __displayloaddingblock() {
		try {
			var pTop= parent.document.body.offsetHeight/2+parent.document.body.scrollTop - 50 + jQuery(".e8_boxhead", parent.document).height()/2 ;
    			var pLeft= parent.document.body.offsetWidth/2 - (217/2);
    			
			//var __top = (jQuery(document.body).height())/2 - 40;
			//var __left = (jQuery(document.body).width() - parseInt(157))/2
			jQuery("#submitloaddingdiv").css({"top":pTop, "left":pLeft, "display":"inline-block;"});
			jQuery("#submitloaddingdiv").show();
			jQuery("#submitloaddingdiv_out").show();
		} catch (e) {}
	}
	
	
	function cellRetract(type){
		var control = scpmanager.getCacheValue(getActiveExcelId());
   		var excelDiv = control.getControl();
   		var dataobj = control.getDataObj();
   		var ss = jQuery(excelDiv).wijspread("spread");
       	var sheet = ss.getActiveSheet();
       	sheet.isPaintSuspended(true);
       	var sels = sheet.getSelections();
		for (var n = 0; n < sels.length; n++) {
			var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
			for (var i = 0; i < sel.rowCount; i++) {
				for (var j = 0; j < sel.colCount; j++) {
					if (dataobj.ecs === undefined ||  ""===dataobj.ecs)
						dataobj.ecs = {};
					var r = i + sel.row;
					var c = j + sel.col;
						
					var curTextIndent=sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).textIndent();
					if(!curTextIndent) curTextIndent = 0;
					var cell = {};
					if(type === "left")
					{
						if(!!dataobj.ecs[r+","+c] 
								&& (dataobj.ecs[r+","+c].etype === celltype.DETAIL 
								|| dataobj.ecs[r+","+c].etype === celltype.DE_TITLE
								|| dataobj.ecs[r+","+c].etype === celltype.DE_BTN
								|| dataobj.ecs[r+","+c].etype === celltype.DE_TAIL)) continue;
						else{
							if(curTextIndent < 100)
							{
								sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).textIndent(curTextIndent+0.5);
								cell.etxtindent = curTextIndent+0.5;
							}
							if(!!dataobj.ecs[r+","+c] && (dataobj.ecs[r+","+c].etype === celltype.FCONTENT ))
								cell.etxtindent = cell.etxtindent-2.5;
						}
					}
					else	//减少缩进量
					{
						if(curTextIndent > 0)
						{
							if(!!dataobj.ecs[r+","+c] 
								&& (dataobj.ecs[r+","+c].etype === celltype.DETAIL 
								|| dataobj.ecs[r+","+c].etype === celltype.DE_TITLE
								|| dataobj.ecs[r+","+c].etype === celltype.DE_BTN
								|| dataobj.ecs[r+","+c].etype === celltype.DE_TAIL)) continue;
							else
							{
								if(!!dataobj.ecs[r+","+c] && (dataobj.ecs[r+","+c].etype === celltype.FCONTENT ))
								{
									if(curTextIndent > 2.5)
									{
										sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).textIndent(curTextIndent-0.5);
										cell.etxtindent = curTextIndent-0.5;
										cell.etxtindent = cell.etxtindent-2.5;
									}
								}else
								{
									sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).textIndent(curTextIndent-0.5);
									cell.etxtindent = curTextIndent-0.5;
								}
							}
						}
					}
					
	                
                   	setCellProperties(r+","+c,"",cell);
				}
			}
		}
		sheet.isPaintSuspended(false);
       	
	}
	
	//绑定样式右键菜单
	function bindStyleRightMenu(obj){
		jQuery(obj).contextMenu({
			menu : 'styleRightMenu',
			button: 3,//3: right click, 1: left click
			onPopup : function(el,e) {
				try{
	 				e.stopPropagation();
	 				e.preventDefault();
				}catch(er){
					window.event.cancelBubble = true;
					return false;
				}
				$("#styleRightMenu").html("");
				$(".typeContainer").find(".styleselected").removeClass("styleselected");
					$(el).addClass("styleselected");
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
				$('#styleRightMenu').mac('menu', menuJson);
			},
			offset: { x: 0, y: 0 }
		}, function(action, el, pos) {
			if(action === "editstyle"){	//编辑
				var style_dialog = new window.top.Dialog();
				style_dialog.currentWindow = window;
				var url = "/workflow/exceldesign/excelStyleDesign.jsp?styleid="+$(el).attr("target").split("styleid")[1];
				style_dialog.Title = "编辑表单样式";
				style_dialog.Width = 790;
				style_dialog.Height = 520;
				style_dialog.Drag = true; 	
				style_dialog.URL = url;
				style_dialog.show();
				style_dialog.callbackfun = function (paramobj, result) {
					if(!result)return;
					var styleid = result.styleid;
					var isadd = result.isadd;
					$.ajax({
						url : "/workflow/exceldesign/excelStyleOperation.jsp",
						type : "post",
						data : {styleid:styleid,method:"searchone"},
						dataType:"JSON",
						success : function do4Success(msg){
							try{
								msg = jQuery.trim(msg);
								var result = JSON.parse(msg);
								var _name = "e_style_"+($(".s_style .typeContainer").children().length+1);
								var cloneObj = el;
								$(cloneObj).find("div[name^=_label],div[name^=_field]").css("border-color",result.main_border);
								$(cloneObj).find("div[name^=_label]").css("background",result.main_label_bgcolor);
								$(cloneObj).find("div[name^=_field]").css("background",result.main_field_bgcolor);
								$(cloneObj).attr("name",_name).attr("title",result.stylename).attr("target","cus_2styleid"+result.styleid);
								$(cloneObj).find("input[name='_css']")
									.attr("_border_color",result.main_border)
									.attr("_label_background",result.main_label_bgcolor)
									.attr("_field_background",result.main_field_bgcolor)
									.attr("_detail_border",result.detail_border)
									.attr("_detail_label_bgcolor",result.detail_label_bgcolor)
									.attr("_detail_field_bgcolor",result.detail_field_bgcolor);
							}catch(e){
								window.top.Dialog.alert(e.message);
							}
						}
					});
				}
			}else if(action === "delstyle"){	//删除
				var styleid = $(el).attr("target").split("styleid")[1];
				$.ajax({
					url : "/workflow/exceldesign/excelStyleOperation.jsp",
					type : "post",
					data : {styleid:styleid,method:"deleteone"},
					dataType:"JSON",
					success : function do4Success(msg){
						$(".typeContainer").find(".styleselected").remove();
					}
				});
				$(".typeContainerFather").perfectScrollbar("update");
			}
		});
	}
	
	//重新设置样式
	function setStylebycustom(obj){
		var styleJson;
		styleJson = {};
		var css_obj = jQuery(obj).find("input[name='_css']");
		if($(obj).is("[target^=sys]")){	//橙色
			styleJson.main_border = css_obj.attr("_border_color");
			styleJson.main_label_bgcolor = css_obj.attr("_background");
			styleJson.main_field_bgcolor = "";
			styleJson.detail_border = css_obj.attr("_border_color");
			styleJson.detail_label_bgcolor = css_obj.attr("_background");
			styleJson.detail_field_bgcolor = "";
			_setStyleBycjson("sys",styleJson);
		}else if($(obj).is("[target^=cus]")){	//自定义样式
			styleJson.main_border = css_obj.attr("_border_color");
			styleJson.main_label_bgcolor = css_obj.attr("_label_background");
			styleJson.main_field_bgcolor = css_obj.attr("_field_background");
			styleJson.detail_border = css_obj.attr("_detail_border");
			styleJson.detail_label_bgcolor = css_obj.attr("_detail_label_bgcolor");
			styleJson.detail_field_bgcolor = css_obj.attr("_detail_field_bgcolor");
			_setStyleBycjson("cus",styleJson);
		}
	}
	
	function _setStyleBycjson(isys,cjson){
		var control = scpmanager.getCacheValue(getActiveExcelId());
   		var excelDiv = control.getControl();
   		var dataobj = control.getDataObj();
   		var ss = jQuery(excelDiv).wijspread("spread");
       	var sheet = ss.getActiveSheet();
       	sheet.isPaintSuspended(true);
       	//主表
		if(true) //isys === "sys"
		{
			if(dataobj)
			if(dataobj.ecs)
			for(var cellid in dataobj.ecs)
			{
				var r = parseInt(cellid.split(",")[0]);
				var c = parseInt(cellid.split(",")[1])
				if(dataobj.ecs[cellid].etype === celltype.FNAME || dataobj.ecs[cellid].etype === celltype.NNAME || dataobj.ecs[cellid].etype === celltype.DETAIL)
				{
					var lineBorder = new $.wijmo.wijspread.LineBorder(cjson.main_border, parseInt("1"));
					var sel = new $.wijmo.wijspread.Range(r, c, 1, 1);
					sheet.setBorder(sel, lineBorder, {all:true});
				 	var _style = sheet.getStyle(r, c, $.wijmo.wijspread.SheetArea.viewport);
                    if (_style == undefined) {
                        _style = new $.wijmo.wijspread.Style();
                    }
                    _style.backColor = cjson.main_label_bgcolor;
                    sheet.setStyle(r, c, _style, $.wijmo.wijspread.SheetArea.viewport);
                    dataobj.ecs[cellid].eborder = true;
				    dataobj.ecs[cellid].ebgcolor = cjson.main_label_bgcolor;
                    var spans = sheet.getSpans(new $.wijmo.wijspread.Range(r, c, 1, 1));
                    if(!!spans && spans.length > 0)
                   	{
                   		if (spans[0])
                        {
                           	for (var i = 0; i < spans[0].rowCount; i++) {
                   				for (var j = 0; j < spans[0].colCount; j++) {
                   					r = spans[0].row + i;
                   					c = spans[0].col + j;
                   					var lineBorder = new $.wijmo.wijspread.LineBorder(cjson.main_border, parseInt("1"));
									var sel = new $.wijmo.wijspread.Range(r, c, 1, 1);
									sheet.setBorder(sel, lineBorder, {all:true});
								 	var _style = sheet.getStyle(r, c, $.wijmo.wijspread.SheetArea.viewport);
				                    if (_style == undefined) {
				                        _style = new $.wijmo.wijspread.Style();
				                    }
				                    _style.backColor = cjson.main_label_bgcolor;
				                    sheet.setStyle(r, c, _style, $.wijmo.wijspread.SheetArea.viewport);
                   				}
              				}
                        }
                   	}
				}else if(dataobj.ecs[cellid].etype === celltype.FCONTENT || dataobj.ecs[cellid].etype === celltype.NADVICE)
				{
					var lineBorder = new $.wijmo.wijspread.LineBorder(cjson.main_border, parseInt("1"));
					var sel = new $.wijmo.wijspread.Range(r, c, 1, 1);
					sheet.setBorder(sel, lineBorder, {all:true});
					if(cjson.main_field_bgcolor　|| cjson.main_border)
					{
					 	var _style = sheet.getStyle(r, c, $.wijmo.wijspread.SheetArea.viewport);
	                   	if (_style == undefined) {
	                       	_style = new $.wijmo.wijspread.Style();
	                   	}
	                   	_style.backColor = cjson.main_field_bgcolor;
	                   	sheet.setStyle(r, c, _style, $.wijmo.wijspread.SheetArea.viewport);
	                   	dataobj.ecs[cellid].eborder = true;
				        dataobj.ecs[cellid].ebgcolor = cjson.main_field_bgcolor;
                    }
                    var spans = sheet.getSpans(new $.wijmo.wijspread.Range(r, c, 1, 1));
                    if(!!spans && spans.length > 0)
                   	{
                   		if (spans[0])
                        {
                           	for (var i = 0; i < spans[0].rowCount; i++) {
                   				for (var j = 0; j < spans[0].colCount; j++) {
                   					r = spans[0].row + i;
                   					c = spans[0].col + j;
                   					var lineBorder = new $.wijmo.wijspread.LineBorder(cjson.main_border, parseInt("1"));
									var sel = new $.wijmo.wijspread.Range(r, c, 1, 1);
									sheet.setBorder(sel, lineBorder, {all:true});
								 	var _style = sheet.getStyle(r, c, $.wijmo.wijspread.SheetArea.viewport);
				                    if (_style == undefined) {
				                        _style = new $.wijmo.wijspread.Style();
				                    }
				                    _style.backColor = cjson.main_field_bgcolor;
				                    sheet.setStyle(r, c, _style, $.wijmo.wijspread.SheetArea.viewport);
                   				}
              				}
                        }
                   	}
				}
			}
		}
		///=====明细表====>
		if(scpmanager.getCache())
		{
			for(var sckey in scpmanager.getCache())
			{
				if(sckey.indexOf("detail") >= 0)
				{
					//spread json
					if(sckey.indexOf("sheet") >= 0);
					else
					//dataobj
					{
						if(scpmanager.getCacheValue(sckey))
						{
							var sheetJson = scpmanager.getCacheValue(sckey+"_sheet");
							sheetJson = JSON.parse(sheetJson);
							var detailSheetECS;
							if(sheetJson.sheets.Sheet1.data)
								if(sheetJson.sheets.Sheet1.data.dataTable)
									detailSheetECS = sheetJson.sheets.Sheet1.data.dataTable;
							var detail_num_json = JSON.parse("{"+scpmanager.getCacheValue(sckey)+"}");
							var detail_dataobj = detail_num_json[sckey];
							if(detail_dataobj)
							if(detail_dataobj.ec)
							for(var cellid = 0; cellid<detail_dataobj.ec.length;cellid++)
							{
								var r = parseInt(detail_dataobj.ec[cellid].id.split(",")[0]);
								var c = parseInt(detail_dataobj.ec[cellid].id.split(",")[1]);
								if(detail_dataobj.ec[cellid].etype === transformerEtype(celltype.FNAME) || detail_dataobj.ec[cellid].etype === transformerEtype(celltype.FCONTENT))
								{
									if(detail_dataobj.ec[cellid].etype === transformerEtype(celltype.FNAME))
									{
										detail_dataobj.ec[cellid].backgroundColor = cjson.detail_label_bgcolor;
										//sheetjson
										if(!detailSheetECS[r][c].style)
											detailSheetECS[r][c].style = {};
										detailSheetECS[r][c].style.backColor = cjson.detail_label_bgcolor;
									}
									else
									{
										detail_dataobj.ec[cellid].backgroundColor = cjson.detail_field_bgcolor;
										//sheetjson
										if(!detailSheetECS[r][c].style)
											detailSheetECS[r][c].style = {};
										detailSheetECS[r][c].style.backColor = cjson.detail_field_bgcolor;
									}
									
									//边框
									var boderAry = new Array();
									var boderTopObj = {};
									boderTopObj.color = cjson.detail_border;
									boderTopObj.kind = "top";
									boderTopObj.style = "1";
									var boderLeftObj = {};
									boderLeftObj.color = cjson.detail_border;
									boderLeftObj.kind = "left";
									boderLeftObj.style = "1";
									var boderRightObj = {};
									boderRightObj.color = cjson.detail_border;
									boderRightObj.kind = "right";
									boderRightObj.style = "1";
									var boderBottomObj = {};
									boderBottomObj.color = cjson.detail_border;
									boderBottomObj.kind = "bottom";
									boderBottomObj.style = "1";
									boderAry.push(boderTopObj);
									boderAry.push(boderLeftObj);
									boderAry.push(boderRightObj);
									boderAry.push(boderBottomObj);
									detail_dataobj.ec[cellid].eborder = boderAry;
									
									//sheetjson
									if(!detailSheetECS[r][c].style)
										detailSheetECS[r][c].style = {};
									if(!detailSheetECS[r][c].style.borderBottom)
										detailSheetECS[r][c].style.borderBottom = {};
									if(!detailSheetECS[r][c].style.borderLeft)
										detailSheetECS[r][c].style.borderLeft = {};
									if(!detailSheetECS[r][c].style.borderRight)
										detailSheetECS[r][c].style.borderRight = {};
									if(!detailSheetECS[r][c].style.borderTop)
										detailSheetECS[r][c].style.borderTop = {};
									detailSheetECS[r][c].style.borderTop.color = cjson.detail_border;
									detailSheetECS[r][c].style.borderTop.style = 1;
									detailSheetECS[r][c].style.borderRight.color = cjson.detail_border;
									detailSheetECS[r][c].style.borderRight.style = 1;
									detailSheetECS[r][c].style.borderLeft.color = cjson.detail_border;
									detailSheetECS[r][c].style.borderLeft.style = 1;
									detailSheetECS[r][c].style.borderBottom.color = cjson.detail_border;
									detailSheetECS[r][c].style.borderBottom.style = 1;
								}
							}
							var detail_num_str = "\""+sckey+"\":"+JSON.stringify(detail_dataobj);
							var sheet_num_str = JSON.stringify(sheetJson)
							scpmanager.addCache(sckey,detail_num_str);
							scpmanager.addCache(sckey+"_sheet",sheet_num_str);
						}
					}
				}
			}
		}
		sheet.isPaintSuspended(false);
	}
	
	//字母转数字
	function morecharToInt(value)
	{
		var rtn = 0;
		var powIndex = 0;
		for (var i = value.length - 1; i >= 0; i--)
       	{
       		var tmpInt = value[i].charCodeAt();
       		tmpInt -= 64;
			rtn += Math.pow(26, powIndex) * tmpInt;
            powIndex++;           
       	}
		return rtn;
	}
	String.prototype.replaceAll = function (str1,str2){
  		var str    = this;     
  		var result   = str.replace(eval("/"+str1+"/gi"),str2);
  		return result;
	}
	function replaceFormula(formulatxt)
	{
		formulatxt = formulatxt.replaceAll("SUM","EXCEL_SUM");
		formulatxt = formulatxt.replaceAll("AVERAGE","EXCEL_AVERAGE");
		formulatxt = formulatxt.replaceAll("ABS","EXCEL_ABS");
		formulatxt = formulatxt.replaceAll("ROUND","EXCEL_ROUND");
		formulatxt = formulatxt.replaceAll("IF","EXCEL_IF");
		return formulatxt;
	}
	
	//打开公式设置窗口
	function openFormulaWin(){
		var control = scpmanager.getCacheValue(getActiveExcelId());
		var excelDiv = control.getControl();
		var _dobj = control.getDataObj();
		var ss = jQuery(excelDiv).wijspread("spread");
		var sheet = ss.getActiveSheet();
      	var ar = sheet.getActiveRowIndex();		///当前活动单元格
      	var ac = sheet.getActiveColumnIndex();
      	
      	var canSetFormula = false;
      	if(_dobj)
		if(_dobj.ecs)
		if(_dobj.ecs[ar+","+ac])
		if(_dobj.ecs[ar+","+ac].etype === celltype.FCONTENT){
			canSetFormula = true;
		}
		if(!canSetFormula){
			window.top.Dialog.alert("非字段单元格，不支持公式设置！");
			return;
		}
       	isEditFormulaing = true;
       	var formula_dialog = new window.top.Dialog();
		formula_dialog.currentWindow = window;
		window.top.formula_dialog = formula_dialog;
		var paramtxt = ""
		if(isDetail === "on"){
			control = parentWin_Main.scpmanager.getCacheValue(parentWin_Main.getActiveExcelId());
			if(control.getFormulas() && control.getOneFormula("DETAIL_"+detailIdenty+".FORMULA"+sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1)))
				paramtxt = control.getOneFormula("DETAIL_"+detailIdenty+".FORMULA"+sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1)).srcformulatxt;
		}else{
			if(control.getFormulas() && control.getOneFormula("MAIN.FORMULA"+sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1)))
				paramtxt = control.getOneFormula("MAIN.FORMULA"+sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1)).srcformulatxt;
		}
		paramtxt = encodeURIComponent(paramtxt)
		var url = "/workflow/exceldesign/excelUploadFormula.jsp?isDetail="+isDetail+"&detailIdenty="+detailIdenty+"&paramtxt="+paramtxt;
		formula_dialog.Title = "插入公式";
		formula_dialog.Width = 620;
		formula_dialog.Height = 450;
		formula_dialog.Drag = true; 	
		formula_dialog.Modal = true; 	
		formula_dialog.normalDialog = false;
		formula_dialog.URL = url;
		formula_dialog.show();
		formula_dialog.closeHandle = function () {
			$("#formulaMasking1").hide();
			$("#formulaMasking2").hide();
			isEditFormulaing = false;	
           	sheet.setSelection(ar,ac,1,1);
		};
		formula_dialog.callbackfunc4CloseBtn=function(){		//点击关闭按钮，应还原之前的状态
			formula_dialog.callbackfunc4CloseBtn = null;
			formula_dialog.innerWin.setFormula(false);
		}
		formula_dialog.callbackfun=function(paramobj, result){
			formula_dialog.callbackfunc4CloseBtn = null;
			control = scpmanager.getCacheValue(getActiveExcelId());
			excelDiv = control.getControl();
			ss = jQuery(excelDiv).wijspread("spread");
			sheet = ss.getActiveSheet();
			var dataObj = control.getDataObj();
			if(!result.formula){
				if(!dataObj.ecs[ar+","+ac].formula)
				return;
				var ___key = ""
				if(isDetail === "on"){
					___key = "DETAIL_"+detailIdenty+".FORMULA"+sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1);
					var parentControl = parentWin_Main.scpmanager.getCacheValue(parentWin_Main.getActiveExcelId());
					parentControl.delOneFormula(___key);
				}else{
					___key = "MAIN.FORMULA"+sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1)
					control.delOneFormula(___key);
				}
				var _cell_new_val = sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).value();
				_cell_new_val = _cell_new_val.substring(0,_cell_new_val.length-5);
				sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).value(_cell_new_val);
				delete dataObj.ecs[ar+","+ac].formula;
				return;
			}
			
			var formulaStr = result.formula;
			var cellrang = result.cellrang;
			var cellOnesAry = new Array();
			var ecsFormul = {};
			var ecsAry = new Array;
			
			var formulatxt = formulaStr;
			try{
				if(!!cellrang){
					for(var i=0;i<cellrang.length;i++){
						//带冒号的区域性单元格
						var cellid;
						if(cellrang[i].match(/[a-zA-Z]+\d+:[a-zA-Z]+\d+/g)){
							var startcell = cellrang[i].split(":")[0];
							var endcell = cellrang[i].split(":")[1];
							var start_col = startcell.match(/^[a-zA-Z]+/)[0];
							start_col = morecharToInt(start_col)-1;
							var start_row = parseInt(startcell.substring(startcell.match(/^[a-zA-Z]+/)[0].length,startcell.length))-1;
							var end_col = endcell.match(/^[a-zA-Z]+/)[0];
							end_col = morecharToInt(end_col)-1;
							var end_row = parseInt(endcell.substring(endcell.match(/^[a-zA-Z]+/)[0].length,endcell.length))-1;
							var s_cell = 0;
							var e_cell = 0;
							if(parseInt(start_row) + parseInt(start_col) < parseInt(end_row) + parseInt(end_col))
							{
								s_cell = start_row + "," + start_col;
								e_cell = end_row + "," + end_col;
							}else{
								s_cell = end_row + "," + end_col;
								e_cell = start_row + "," + start_col;
							}
							var cellstr = "";
							for(var x=0;x<=parseInt(e_cell.split(",")[0])-parseInt(s_cell.split(",")[0]);x++)
							{
								for(var y=0;y<=parseInt(e_cell.split(",")[1])-parseInt(s_cell.split(",")[1]);y++)
								{
									var _r = parseInt(s_cell.split(",")[0])+x;
									var _c = parseInt(s_cell.split(",")[1])+y;
									cellid = _r+","+_c;
									if(dataObj)
									if(dataObj.ecs)
									if(dataObj.ecs[cellid])
									{
										if(dataObj.ecs[cellid].etype === celltype.FCONTENT)
										{
											var celltemp = "";
											if(isDetail === "on")
												celltemp = "DETAIL_"+detailIdenty+"."+sheet.getValue(0,_c,$.wijmo.wijspread.SheetArea.colHeader)+(_r+1);
											else
												celltemp = "MAIN."+sheet.getValue(0,_c,$.wijmo.wijspread.SheetArea.colHeader)+(_r+1);
											ecsAry.push(celltemp);
											if(cellstr === "")
												cellstr = celltemp;
											else
												cellstr += ","+celltemp;
										}
									}
								}
							}
							formulatxt = formulatxt.replace(cellrang[i],cellstr);
						}else if(cellrang[i].match(/detail_[\d+]\.[a-zA-Z]+\d+|main\.[a-zA-Z]+\d+/g)){
							ecsAry.push((cellrang[i]+"").toUpperCase());
						}else	//单个单元格
						{
							var startcell = cellrang[i];
							var start_col = startcell.match(/^[a-zA-Z]+/)[0];
							start_col = morecharToInt(start_col)-1;
							var start_row = startcell.substring(startcell.match(/^[a-zA-Z]+/)[0].length,startcell.length);
							cellid = (parseInt(start_row)-1) + "," + start_col;
							if(dataObj)
							if(dataObj.ecs)
							if(dataObj.ecs[cellid])
							{
								if(dataObj.ecs[cellid].etype === celltype.FCONTENT)
								{
									var celltemp = "";
									if(isDetail === "on")
										celltemp = "DETAIL_"+detailIdenty+"."+startcell;
									else
										celltemp = "MAIN."+startcell;
									ecsAry.push(celltemp);
								}
							}
							if(cellOnesAry && cellOnesAry.contains(cellrang[i])) continue;
							formulatxt = formulatxt.replaceAll(cellrang[i],celltemp);
							if(formulatxt.indexOf(".MAIN.") || formulatxt.indexOf(".DETAIL_"+detailIdenty+"."))
							{
								if(formulatxt.indexOf(".MAIN.")){
									formulatxt = formulatxt.replaceAll("\\.MAIN\\.",".");}
								else{
									formulatxt = formulatxt.replaceAll("\\.DETAIL_"+detailIdenty+"\\.",".");}
							}
							cellOnesAry.push(cellrang[i]);
						}
					
					}
				}
				
				var _tempformula = {};
				_tempformula.srcformulatxt = $.trim(formulaStr);
				_tempformula.formulatxt = replaceFormula($.trim(formulatxt).toUpperCase());
				_tempformula.cellrange = ecsAry;
				
				sheet.isPaintSuspended(true);
				if(isDetail === "on")
				{
					var parentControl = parentWin_Main.scpmanager.getCacheValue(parentWin_Main.getActiveExcelId());
					if(sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).value())
					{
						if(parentControl.getFormulas() && parentControl.getOneFormula("DETAIL_"+detailIdenty+".FORMULA"+sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1)));
						else
						{
							var cell_new_val = sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).value()+" (fx)"
							sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).value(cell_new_val);
						}
					}else
						sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).value(" (fx)");
					var formula = parentControl.getFormulas();
					if(!formula) parentControl.initFormulas();
					_tempformula.desttabel = "DETAIL_"+detailIdenty;
					_tempformula.destcell = "DETAIL_"+detailIdenty+"."+sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1);
					parentControl.setOneFormula("DETAIL_"+detailIdenty+".FORMULA"+sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1),_tempformula);
					//console.dir(parentControl.getFormulas());
					detailFormulaTempAry.push(_tempformula.destcell);
				}
				else
				{
					if(sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).value())
					{
						if(control.getFormulas() && control.getOneFormula("MAIN.FORMULA"+sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1)));
						else
						{	
							var cell_new_val = sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).value()+" (fx)"
							sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).value(cell_new_val);
						}
					}else
						sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).value(" (fx)");
					var formula = control.getFormulas();
					if(!formula) control.initFormulas();
					_tempformula.desttabel = "MAIN";
					_tempformula.destcell = "MAIN."+sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1);
					control.setOneFormula("MAIN.FORMULA"+sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1),_tempformula);
					//console.dir(control.getFormulas());
				}
				sheet.isPaintSuspended(false);
				var cell = {};
				cell.formula = _tempformula.destcell;
				setCellProperties(ar+","+ac,"",cell);
			}catch(e){
			 window.top.Dialog.alert(e.message);
			}
		}
	}
   	
   	function insertRowandCol4Last(isrc){
   		var control = scpmanager.getCacheValue(getActiveExcelId());
   		var excelDiv = control.getControl();
   		var ss = excelDiv.wijspread("spread");
		var sheet = ss.getActiveSheet();
		if(isrc === "row")
        	sheet.addRows(sheet.getRowCount(), 5);
        else if(isrc === "col")
        	sheet.addColumns(sheet.getColumnCount(), 5);
   	}
   	
   	function changeTable4Op(tabletype,currentTableSheetJson){
   		var control = scpmanager.getCacheValue(getActiveExcelId());
		var excelDiv = control.getControl();
		var ss = jQuery(excelDiv).wijspread("spread");
  		var sheet = ss.getActiveSheet();
  		var sheetJson;
   		if(isDetail === "on"){
   			if(tabletype+"" === detailIdenty+"")
   				sheetJson = JSON.parse(currentTableSheetJson);
   			else{	//主表
   				sheetJson = parentWin_Main.scpmanager.getCacheValue("main_sheet");
   				sheetJson = JSON.parse(sheetJson);
   			}
   			try{
	   			sheet.isPaintSuspended(true);
	       		ss.fromJSON(sheetJson);
	       		sheet.isPaintSuspended(false);
	       		sheet = ss.getActiveSheet();
	       		sheet.setIsProtected(true);
	       		bindSpreadEvent4Formula(ss);
       		}catch(e){
       			window.top.Dialog.alert(e.message);
       		}
   		}else{
   			if(tabletype === "main"){
   				sheetJson = JSON.parse(currentTableSheetJson);
   			}else{
   				var sjkey = "detail_"+tabletype+"_sheet";	//缓存中获取组件生成的json字符串的key;
        		sheetJson = scpmanager.getCacheValue(sjkey);
	       		sheetJson = JSON.parse(sheetJson);
        		if(!sheetJson){
        			window.top.Dialog.alert("选择的明细表尚未设计!",function(){$(window.top.Dialog.getBgdiv()).css("z-index",(parseInt($(window.top.Dialog.getBgdiv()).css("z-index")) - 2)+"");});
        			return;
        		}
   			}
   			try{
	   			sheet.isPaintSuspended(true);
	       		ss.fromJSON(sheetJson);
	       		sheet.isPaintSuspended(false);
	       		sheet = ss.getActiveSheet();
	       		sheet.setIsProtected(true);
	       		bindSpreadEvent4Formula(ss);
       		}catch(e){
       			window.top.Dialog.alert(e.message);
       		}
   		}
   	}
   	
   	function isChooseSingleCell(){
    	var control = scpmanager.getCacheValue(getActiveExcelId());
    	var excelDiv = control.getControl();
    	var ss = jQuery(excelDiv).wijspread("spread");
    	var sheet = ss.getActiveSheet();
        var sels = sheet.getSelections();
        var isSingle = true;
        if(sels.length > 1){
        	isSingle = false;
        }else{
        	var signleCellLength = 0;
        	var range = getActualCellRange(sels[0], sheet.getRowCount(), sheet.getColumnCount());
        	for (var i = 0; i < range.rowCount; i++) {
        		for (var j = 0; j < range.colCount; j++) {
        			var r = range.row + i;
           	 		var c = range.col + j;
           	 		var spans = sheet.getSpan(r,c,$.wijmo.wijspread.SheetArea.viewport);
           	 		if(spans==null){
           	 			signleCellLength++;
           	 		}else{
           	 			if(spans.row==r && spans.col==c)
           	 				signleCellLength++;
           	 		}
        		}
        	}
        	if(signleCellLength>1)	isSingle = false;
        }
        return isSingle;
   	}
   	
   	
    return {
    	initOperatTab:function ()
    	{
    		jQuery(".excel_opitem").click(function(){
    			if(jQuery(this).is(".current"))
    				return;
    			else{
    				jQuery(this).parent(".nav").find(".current").removeClass("current");
    				jQuery(this).addClass("current");
    				jQuery(".excelHeadContent").children("table").hide();
    				initOperatTabPanel(this);
   				}
    		});
    	},
    	initStyleTab:function ()
    	{
    		var e_style_1 = $(".s_style").find("div[name=e_style_1]");
    		//初始化样式2
			var e_style_2 = $(e_style_1).clone();
			$(e_style_2).find("div[name^=_label],div[name^=_field]").css("border-color","#edd5f8");
			$(e_style_2).find("div[name^=_label]").css("background","#f7e8fc");
			$(e_style_2).attr("name","e_style_2").attr("target","sys_2");
			$(e_style_2).find("input[name='_css']")
				.attr("_border_color","#edd5f8").attr("_background","#f7e8fc");
			$(".typeContainer").append(e_style_2);
			
			//初始化样式3
			var e_style_3 = $(e_style_1).clone();
			$(e_style_3).find("div[name^=_label],div[name^=_field]").css("border-color","#f8d5d5");
			$(e_style_3).find("div[name^=_label]").css("background","#fce8e8");
			$(e_style_3).attr("name","e_style_3").attr("target","sys_3");
			$(e_style_3).find("input[name='_css']")
				.attr("_border_color","#f8d5d5").attr("_background","#fce8e8");
			$(".typeContainer").append(e_style_3);
			
			//初始化样式4
			var e_style_4 = $(e_style_1).clone();
			$(e_style_4).find("div[name^=_label],div[name^=_field]").css("border-color","#c1edcd");
			$(e_style_4).find("div[name^=_label]").css("background","#e8fced");
			$(e_style_4).attr("name","e_style_4").attr("target","sys_4");
			$(e_style_4).find("input[name='_css']")
				.attr("_border_color","#c1edcd").attr("_background","#e8fced");
			$(".typeContainer").append(e_style_4);
			
			//初始化样式5
			var e_style_5 = $(e_style_1).clone();
			$(e_style_5).find("div[name^=_label],div[name^=_field]").css("border-color","#d5e7f8");
			$(e_style_5).find("div[name^=_label]").css("background","#e8f2fc");
			$(e_style_5).attr("name","e_style_5").attr("target","sys_5");
			$(e_style_5).find("input[name='_css']")
				.attr("_border_color","#d5e7f8").attr("_background","#e8f2fc");
			$(".typeContainer").append(e_style_5);
			
			//初始化样式6
			var e_style_6 = $(e_style_1).clone();
			$(e_style_6).find("div[name^=_label],div[name^=_field]").css("border-color","#ebedad");
			$(e_style_6).find("div[name^=_label]").css("background","#fcfce8");
			$(e_style_6).attr("name","e_style_6").attr("target","sys_6");
			$(e_style_6).find("input[name='_css']")
				.attr("_border_color","#ebedad").attr("_background","#fcfce8");
			$(".typeContainer").append(e_style_6);
			
			$(".typeContainer").find("div[name^=e_style_]").on("click",function() {
				$(".typeContainer").find(".styleselected").removeClass("styleselected");
				if($(this).is(".current"))
					return;
				$(".typeContainer").find(".current").removeClass("current");
				$(this).addClass("current");
				setStylebycustom(this);
			})
			$.ajax({
				url : "/workflow/exceldesign/excelStyleOperation.jsp",
				type : "post",
				data : {method:"searchall"},
				dataType:"JSON",
				success : function do4Success(msg){
					try{
						msg = jQuery.trim(msg);
						var result = JSON.parse(msg);
						for(var key in result){
							var _name = "e_style_"+($(".s_style .typeContainer").children().length+1);
							var cloneObj = $(e_style_1).clone();
							$(cloneObj).find("div[name^=_label],div[name^=_field]").css("border-color",result[key].main_border);
							$(cloneObj).find("div[name^=_label]").css("background",result[key].main_label_bgcolor);
							$(cloneObj).find("div[name^=_field]").css("background",result[key].main_field_bgcolor);
							$(cloneObj).attr("name",_name).attr("title",result[key].stylename).attr("target","cus_2"+key);
							$(cloneObj).find("input[name='_css']")
								.attr("_border_color",result[key].main_border)
								.attr("_label_background",result[key].main_label_bgcolor)
								.attr("_field_background",result[key].main_field_bgcolor)
								.attr("_detail_border",result[key].detail_border)
								.attr("_detail_label_bgcolor",result[key].detail_label_bgcolor)
								.attr("_detail_field_bgcolor",result[key].detail_field_bgcolor);
							$(".typeContainer").append(cloneObj);
							$(cloneObj).on("click",function() {
								//if($(this).is(".current"))
								//	return;
								$(".typeContainer").find(".styleselected").removeClass("styleselected");
								$(".typeContainer").find(".current").removeClass("current");
								$(this).addClass("current");
								setStylebycustom(this);
							});
							bindStyleRightMenu(cloneObj);
						}
					}catch(e){
						window.top.Dialog.alert(e.message)
					}
				}
			});
			//新建样式
			$(".s_style").find(".morenewBtn").click(function(){
				var style_dialog = new window.top.Dialog();
				style_dialog.currentWindow = window;
				var url = "/workflow/exceldesign/excelStyleDesign.jsp";
				style_dialog.Title = "新建表单样式";
				style_dialog.Width = 790;
				style_dialog.Height = 520;
				style_dialog.Drag = true; 	
				style_dialog.URL = url;
				style_dialog.show();
				style_dialog.callbackfun = function (paramobj, result) {
					if(!result)return;
					var styleid = result.styleid;
					var isadd = result.isadd;
					$.ajax({
						url : "/workflow/exceldesign/excelStyleOperation.jsp",
						type : "post",
						data : {styleid:styleid,method:"searchone"},
						dataType:"JSON",
						success : function do4Success(msg){
							try{
								msg = jQuery.trim(msg);
								var result = JSON.parse(msg);
								var _name = "e_style_"+($(".s_style .typeContainer").children().length+1);
								var cloneObj = $(e_style_1).clone();
								$(cloneObj).find("div[name^=_label],div[name^=_field]").css("border-color",result.main_border);
								$(cloneObj).find("div[name^=_label]").css("background",result.main_label_bgcolor);
								$(cloneObj).find("div[name^=_field]").css("background",result.main_field_bgcolor);
								$(cloneObj).attr("name",_name).attr("title",result.stylename).attr("target","cus_2styleid"+result.styleid);
								$(cloneObj).find("input[name='_css']")
									.attr("_border_color",result.main_border)
									.attr("_label_background",result.main_label_bgcolor)
									.attr("_field_background",result.main_field_bgcolor)
									.attr("_detail_border",result.detail_border)
									.attr("_detail_label_bgcolor",result.detail_label_bgcolor)
									.attr("_detail_field_bgcolor",result.detail_field_bgcolor);
								$(cloneObj).on("click",function() {
									//if($(this).is(".current"))
									//	return;
									$(".typeContainer").find(".current").removeClass("current");
									$(this).addClass("current");
									setStylebycustom(this);
								})
								$(".typeContainer").append(cloneObj);
								$(".typeContainerFather").perfectScrollbar("update");
								bindStyleRightMenu(cloneObj);
							}catch(e){
								window.top.Dialog.alert(e.message);
							}
						}
					});
				}
			});
    	},
    	initModuleTab:function (){
    		
    	},
        initHeadSetPanel:function (operatpanel,excelDiv){
        	var detailnum = getDetailNum();
			if(!detailnum){
				$("div[name=mainDetail]").addClass("shortBtn_disabled").addClass("disabled").removeClass("shortBtn");
				$("div[name=mainDetail]").children().eq(2).remove();
			}		
        	//============格式 栏  START===============
        	//字体样式设置
        	operatpanel.find("[name=fontfamily]").change(function(){
        		setMjiStyle(excelDiv, "fontfamliy", $(this).val());
        	});
        	//字体大小设置
        	operatpanel.find("[name=fontsize]").change(function(){
        		setMjiStyle(excelDiv, "fontsize", $(this).val());
        	});
        	//粗体设置
       	 	operatpanel.find("[name=blodfont]").click(function () {
                setMjiStyle(excelDiv, "bold");
                setBtnStatus(this);
            });
            //斜体设置
            operatpanel.find("[name=italicfont]").click(function () {
                setMjiStyle(excelDiv, "italic");
                setBtnStatus(this);
            });
            //表格线样式
        	operatpanel.find("#borderline").msDropDown({childWidth:"110px"});
        	//表格画法
			operatpanel.find("#bordertype").msDropDown({childWidth:"100px"});
			//取色器初始化 边框颜色/字体颜色/背景颜色
			operatpanel.find("[name=colorpick4bx]").spectrum({
                showPalette:true,
                chooseText:"确定",
                cancelText:"取消",
                clearText:"清除",
                clickoutFiresChange: false,
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
                show: function(color) {
                	
                },
                change: function(color) {
                	if(color === "transparents")
                	{
                		setMjiStyle(excelDiv,$(this).attr("id"),null); 
                		$(this).find(".pickcolordiv").css("background","#000000");
                		$(this).find(".pickcolordiv").find("input[type='hidden']").val("#000000");  
                		return;
               		}       
                	$(this).find(".pickcolordiv").css("background",color.toHexString());
                    $(this).find(".pickcolordiv").find("input[type='hidden']").val(color.toHexString());  
                    if($(this).attr("id") != "bordercolor")    //去除边框颜色
                    	setMjiStyle(excelDiv,$(this).attr("id"),color.toHexString());   
                    //else
                    	//drawborder();    
                }
            });
            //画边框
            /*operatpanel.find("#borderline").parent().parent().find(".ddChild li").click(function(){
				drawborder();
			});*/
			operatpanel.find("#bordertype").parent().parent().find(".ddChild li").click(function(){
				drawborder();
			});
			
			//单元格属性
			operatpanel.find("[name=excelPro]").click(function(){
        		openStyleWin();
        	});
            
        	//顶端对齐
        	operatpanel.find("[name=topAlign]").click(function(){
        		operatpanel.find("[name=middelAlign]").removeAttr("down").removeClass("shortBtnHover");
        		operatpanel.find("[name=bottomAlign]").removeAttr("down").removeClass("shortBtnHover");
        		var isdown = setBtnStatus(this);
        		alignBx({"a_valign":"0"},isdown);
        	});
        	//垂直居中
        	operatpanel.find("[name=middelAlign]").click(function(){
        		operatpanel.find("[name=topAlign]").removeAttr("down").removeClass("shortBtnHover");
        		operatpanel.find("[name=bottomAlign]").removeAttr("down").removeClass("shortBtnHover");
        		var isdown = setBtnStatus(this);
        		alignBx({"a_valign":"1"},isdown);
        	});
        	//底部对齐
        	operatpanel.find("[name=bottomAlign]").click(function(){
        		operatpanel.find("[name=topAlign]").removeAttr("down").removeClass("shortBtnHover");
        		operatpanel.find("[name=middelAlign]").removeAttr("down").removeClass("shortBtnHover");
        		var isdown = setBtnStatus(this);
        		alignBx({"a_valign":"2"},isdown);
        	});
        	//左对齐
        	operatpanel.find("[name=leftAlign]").click(function(){
        		operatpanel.find("[name=centerAlign]").removeAttr("down").removeClass("shortBtnHover");
        		operatpanel.find("[name=rightAlign]").removeAttr("down").removeClass("shortBtnHover");
        		var isdown = setBtnStatus(this);
        		alignBx({"a_halign":"0"},isdown);
        		
        	});
        	//居中对齐
        	operatpanel.find("[name=centerAlign]").click(function(){
        		operatpanel.find("[name=leftAlign]").removeAttr("down").removeClass("shortBtnHover");
        		operatpanel.find("[name=rightAlign]").removeAttr("down").removeClass("shortBtnHover");
        		var isdown = setBtnStatus(this);
        		alignBx({"a_halign":"1"},isdown);
        	});
        	//右对齐
        	operatpanel.find("[name=rightAlign]").click(function(){
        		operatpanel.find("[name=leftAlign]").removeAttr("down").removeClass("shortBtnHover");
        		operatpanel.find("[name=centerAlign]").removeAttr("down").removeClass("shortBtnHover");
        		var isdown = setBtnStatus(this);
        		alignBx({"a_halign":"2"},isdown);
        	});
        	// 左缩进
        	operatpanel.find("[name=leftretract]").click(function(){
        		cellRetract("left");
        	});
        	
        	// 右缩进
        	operatpanel.find("[name=rightretract]").click(function(){
        		cellRetract("right");
        	});
        	
        	//合并单元格
        	operatpanel.find("[name=mergenBx]").click(function(){
				mergenBx();
           	});
           	
           	//拆分单元格
           	operatpanel.find("[name=splitBx]").click(function(){
                splitBx();
            });
            
            //插入行
			operatpanel.find("[name=insertrow]").click(function () {
				insertRowCols("row");
			});
			
			//插入列
			operatpanel.find("[name=insertcol]").click(function () {
				insertRowCols("col");
            });
            
            //删除行
            operatpanel.find("[name=deleterow]").click(function () {
            	deleteRowCols("row")
            });
            
            //删除列
            operatpanel.find("[name=deletecol]").click(function () {
            	deleteRowCols("col");
            });
            //自动换行
			operatpanel.find("[name=autowrap]").click(function () {
				setBtnStatus(this);
				var wrap = false;
        		if(!!$(this).attr("down"))
        			if($(this).attr("down") === "on")
        				wrap =true;
				autowrapBx(wrap);
			});
			//财务表头
			operatpanel.find("[name=financialhead]").click(function () {
            	var control = scpmanager.getCacheValue(getActiveExcelId());
        		var excelDiv = control.getControl();
        		var dataobj = control.getDataObj();
        		var ss = jQuery(excelDiv).wijspread("spread");
            	var sheet = ss.getActiveSheet();
            	var ar = sheet.getActiveRowIndex();
            	var ac = sheet.getActiveColumnIndex();
            	if(dataobj)
            	if(dataobj.ecs)
            	if(dataobj.ecs[ar+","+ac]){
            		if(dataobj.ecs[ar+","+ac].etype === celltype.FNAME){
            			var url = "/workflow/exceldesign/excelSetFinancial.jsp?financial="+dataobj.ecs[ar+","+ac].financial;
            			var fdialog = new window.top.Dialog();
						fdialog.currentWindow = window;
						fdialog.Title = "财务格式设置";
						fdialog.Width = 450;
						fdialog.Height = 220;
						fdialog.Drag = true; 	
						fdialog.normalDialog = false;
						fdialog.URL = url;
						fdialog.show();
						fdialog.callbackfun = function (paramobj, result) {
	            			sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImage("/workflow/exceldesign/image/controls/financeTitle_wev8.png");
            				sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
            				sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).textIndent(2.5);
							dataobj.ecs[ar+","+ac].financial = "1"+result;
						}
            		}else{
            			window.top.Dialog.alert("非标签单元格不能设置财务表头");
            		}
            	}else{
           			window.top.Dialog.alert("非标签单元格不能设置财务表头");
           		}
			});
			//财务表览
			operatpanel.find("[name=financialsheet]").click(function () {
				var control = scpmanager.getCacheValue(getActiveExcelId());
        		var excelDiv = control.getControl();
        		var dataobj = control.getDataObj();
        		var ss = jQuery(excelDiv).wijspread("spread");
            	var sheet = ss.getActiveSheet();
            	var ar = sheet.getActiveRowIndex();
            	var ac = sheet.getActiveColumnIndex();
            	if(dataobj)
            	if(dataobj.ecs)
            	if(dataobj.ecs[ar+","+ac]){
            		if(dataobj.ecs[ar+","+ac].etype === celltype.FCONTENT){
            			var fdialog = new window.top.Dialog();
						fdialog.currentWindow = window;
						var url = "/workflow/exceldesign/excelSetFinancial.jsp?financial="+dataobj.ecs[ar+","+ac].financial;
						fdialog.Title = "财务格式设置";
						fdialog.Width = 450;
						fdialog.Height = 220;
						fdialog.Drag = true; 	
						fdialog.normalDialog = false;
						fdialog.URL = url;
						fdialog.show();
						fdialog.callbackfun = function (paramobj, result) {
			            	var status = "";
	            			if(isDetail === "on")
	            				status = parentWin_Main.getFieldAttr(dataobj.ecs[ar+","+ac].efieldid);
	            			else
	            				status = getFieldAttr(dataobj.ecs[ar+","+ac].efieldid)
	           				var imgsrc = "/workflow/exceldesign/image/controls/finance"+status+"_wev8.png";//图的名称很重要
	            			sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImage(imgsrc);
	            			sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
							dataobj.ecs[ar+","+ac].financial = "2"+result;
						}
            		}else{
            			window.top.Dialog.alert("非字段单元格不能设置财务表览");
            		}
            	}else{
           			window.top.Dialog.alert("非字段单元格不能设置财务表览");
           		}
			});
			//金额大写
			operatpanel.find("[name=financialupper]").click(function () {
				var control = scpmanager.getCacheValue(getActiveExcelId());
        		var excelDiv = control.getControl();
        		var dataobj = control.getDataObj();
        		var ss = jQuery(excelDiv).wijspread("spread");
            	var sheet = ss.getActiveSheet();
            	//var ar = sheet.getActiveRowIndex();
            	//var ac = sheet.getActiveColumnIndex();
            	var sels = sheet.getSelections();
            	for (var n = 0; n < sels.length; n++) {
					var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
					for (var i = 0; i < sel.rowCount; i++) {
						for (var j = 0; j < sel.colCount; j++) {
							var ar = sel.row+i;
							var ac = sel.col+j;
							if(dataobj)
							if(dataobj.ecs)
							if(dataobj.ecs[ar+","+ac])
							{
								if(dataobj.ecs[ar+","+ac].etype === celltype.FCONTENT)
								{
									sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImage("/workflow/exceldesign/image/controls/financeUpper_wev8.png");
            						sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
            						dataobj.ecs[ar+","+ac].financial = "3";
           						}
            				}
						}
					}
				}
			});
			//千分位
			operatpanel.find("[name=n_us]").click(function () {
				var control = scpmanager.getCacheValue(getActiveExcelId());
        		var excelDiv = control.getControl();
        		var dataobj = control.getDataObj();
        		var ss = jQuery(excelDiv).wijspread("spread");
            	var sheet = ss.getActiveSheet();
            	var sels = sheet.getSelections();
            	sheet.isPaintSuspended(true);
				for (var n = 0; n < sels.length; n++) {
					var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
					for (var i = 0; i < sel.rowCount; i++) {
						for (var j = 0; j < sel.colCount; j++) {
							var ar = sel.row+i;
							var ac = sel.col+j;
							if(dataobj)
							if(dataobj.ecs)
							if(dataobj.ecs[ar+","+ac])
							{
								if(dataobj.ecs[ar+","+ac].etype === celltype.FCONTENT)
								{
									sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImage("/workflow/exceldesign/image/controls/thousands_wev8.png");
            						sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
            						dataobj.ecs[ar+","+ac].financial = "4";
           						}
            				}
						}
					}
				}
				sheet.isPaintSuspended(false);
			});
			//清除内容
			operatpanel.find("[name=cleancontent]").click(function () {
				cleanCell(2);
			});
			//清除格式
			operatpanel.find("[name=cleanstyle]").click(function () {
				cleanCell(1);
			});
			//清除全部
            operatpanel.find("[name=cleanall]").click(function () {
				cleanCell(3);
			});
			//清除财务格式
            operatpanel.find("[name=cleanfinance]").click(function () {
            	clearFinancial();
            });
			//显示 网格线
			operatpanel.find("[name=showgridline]").click(function () {
				setBtnStatus(this);
				var ishow = false;
        		if(!!$(this).attr("down"))
        			if($(this).attr("down") === "on")
        				ishow =true;
        		var control = scpmanager.getCacheValue(getActiveExcelId());
        		var excelDiv = control.getControl();
        		var ss = jQuery(excelDiv).wijspread("spread");
            	var sheet = ss.getActiveSheet();
            	sheet.setGridlineOptions({ showHorizontalGridline: ishow, showVerticalGridline: ishow });
            	sheet.invalidateLayout();
    			sheet.repaint();
			});
			//显示 行列头
			operatpanel.find("[name=showthead]").click(function () {
				setBtnStatus(this);
				var ishow = false;
        		if(!!$(this).attr("down"))
        			if($(this).attr("down") === "on")
        				ishow =true;
        		var control = scpmanager.getCacheValue(getActiveExcelId());
        		var excelDiv = control.getControl();
        		var ss = jQuery(excelDiv).wijspread("spread");
            	var sheet = ss.getActiveSheet();
            	sheet.isPaintSuspended(true);
        		sheet.setRowHeaderVisible(ishow);
        		sheet.setColumnHeaderVisible(ishow);
        		sheet.isPaintSuspended(false);
        		
   			});
   			//格式刷
   			operatpanel.find("[name=formatrush").click(function () {
				setBtnStatus(this);
				var control = scpmanager.getCacheValue(getActiveExcelId());
        		var excelDiv = control.getControl();
        		var ss = jQuery(excelDiv).wijspread("spread");
       		 	var sheet = ss.getActiveSheet();
       		 	var sels = sheet.getSelections();
       		 	$.wijmo.wijspread.SpreadActions.copy.call(sheet);
                	/*var render = sheet._render,
                            ctx = render._getCtx(),
                            layout = sheet._getSheetLayout(),
                            viewportRect = layout.viewportRect(1, 1),
                   			indicatorRect = render._getPaintingRects(1, 1, [sels[0]], viewportRect)[0];
                   			//sheet.isPaintSuspended(true);
                   			 var selection = sheet._selectionModel;
                         for (var index = 0, len = selection.length; index < len; index++)
                        {
                            selection.push(selection[index])
                        }
                  	render.paintDashRect(ctx, indicatorRect, "#3c78d8");*/
                  	//sheet.isPaintSuspended(false);
			});
            //============格式 栏  END===============
            
            //============插入 栏  START===============
            //添加图片
            operatpanel.find("[name=linkpic]").click(function () {
            	dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				var url = "/workflow/exceldesign/excelUploadImg.jsp";
				dialog.Title = "插入图片";
				dialog.Width = 500;
				dialog.Height = 340;
				dialog.Drag = true; 	
				dialog.URL = url;
				dialog.show();
				dialog.callbackfun = function (paramobj, result) {
					if(!result) return;
					var imgtype = result.type;
					var imgSrc = result.value; 
					var control = scpmanager.getCacheValue(getActiveExcelId());
	        		var excelDiv = control.getControl();
	        		var dataobj = control.getDataObj();
	        		var ss = jQuery(excelDiv).wijspread("spread");
	            	var sheet = ss.getActiveSheet();
	            	var ar = sheet.getActiveRowIndex();		///当前活动单元格
	            	var ac = sheet.getActiveColumnIndex();
	            	sheet.isPaintSuspended(true); 
	            	if(imgtype === "1")
	            	{
		            	if(dataobj)
						if(dataobj.ecs)
						if(dataobj.ecs[ar+","+ac]){
							if(dataobj.ecs[ar+","+ac].etype === celltype.TEXT || dataobj.ecs[ar+","+ac].etype === "" 
								|| dataobj.ecs[ar+","+ac].etype === celltype.IMAGE);
							else
							{
								window.top.Dialog.alert("单元格内非文本,禁止插入图片!");
								sheet.isPaintSuspended(false); 
								return;
							}
						}
						var cell = {};
						cell.efieldid=imgSrc;
						cell.efieldtype = imgtype;
						setCellProperties(ar+","+ac,celltype.IMAGE,cell);
						if(ar === sheet.getRowCount()-1)
    						insertRowandCol4Last("row");
    					if(ac === sheet.getColumnCount()-1)
    						insertRowandCol4Last("col");
					  	sheet.getCell(ar, ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImage(imgSrc);
					  	sheet.getCell(ar, ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
				  	}else if(imgtype === "2")
				  	{
				  		ss.backgroundImage(imgSrc);
				  		ss.backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
				  		if(imgSrc)
				  			operatpanel.find("[name=clearBgImg]").removeClass("shortBtn_disabled").addClass("shortBtn");
				  			//operatpanel.find("[name=clearBgImg]").show();
				  	}else if(imgtype === "3")
				  	{
				  		var sels = sheet.getSelections();
				  		var startrow = 0;
				  		var startcol = 0;
				  		var endrow = 0;
				  		var endcol = 0;
				  		if(sels.length>0)
				  		{
				  			var sel = getActualCellRange(sels[0], sheet.getRowCount(), sheet.getColumnCount());
				  			startrow = sel.row;
				  			startcol = sel.col;
				  			endrow = sel.row + sel.rowCount;
				  			endcol = sel.col + sel.colCount;
				  		}
				  		var pic = sheet.addPicture("picture" + new Date().valueOf(), imgSrc, startrow, startcol, endrow, endcol); 
				  		//选择浮动图切换
						//pic.isSelected(true);
						pic.isVisible(false);
						var st = setTimeout(function(){
							pic.height(pic.getOriginalHeight());
							pic.width(pic.getOriginalWidth());
							
							pic.isVisible(true);
							clearTimeout(st);
						},100);
				  	}
				  	sheet.isPaintSuspended(false); 
				  	if(imgtype === "2")
				  	{
				  		var st = setTimeout(function(){
				  			clearTimeout(st);
					  		var canvas = $(sheet._getCanvas());
					  		var _scrollTopRow = sheet._scrollTopRow;
					  		var _scrollLeftCol = sheet._scrollLeftCol;
					  		var _scrollHideRowHeight = 0;
					  		var _scrollHideColWidth = 0;
					  		for(var tr =0; tr<_scrollTopRow;tr++)
					  			_scrollHideRowHeight += sheet._getActualRowHeight(tr);
					  		for(var tc =0; tc<_scrollLeftCol;tc++)
					  			_scrollHideColWidth += sheet._getActualColumnWidth(tc);
					  		_scrollHideRowHeight = _scrollHideRowHeight > 0 ? 20 - _scrollHideRowHeight : 20;
					  		_scrollHideColWidth = _scrollHideColWidth > 0 ? 40 - _scrollHideColWidth : 40;
					  		var _postion = _scrollHideColWidth + "px " + _scrollHideRowHeight+"px";
					  		canvas.css("background-position", _postion);
				  		},200);
				  	}
				}
            	//var imgSrc = "/workflow/exceldesign/css/cobalt/images/wijmo-ui-icons_000000_240x112_wev8.png"; 
            	//浮动图片 start=============
	            /*if (imgSrc !== "") { 
	                var spread = excelDiv.wijspread("spread"); 
	                var sheet = spread.getActiveSheet(); 
	                sheet.isPaintSuspended(true); 
	                sheet.addPicture("picture" + new Date().valueOf(), imgSrc, 1, 1, 5, 5); 
	                sheet.isPaintSuspended(false); 
	            }*/ 
	            //浮动图片 end=============
				/*if (imgSrc !== "") {
		            var ss = excelDiv.wijspread("spread");
	                var sheet = ss.getActiveSheet();
	                var sels = sheet.getSelections();
	               	for (var index = 0; index < sels.length; index++) {
			           	var selRange = sels[index];
			           	if (selRange.col < 0 && selRange.row < 0) {
			           		sheet.getColumns(selRange.col, selRange.col + selRange.colCount - 1).backgroundImage(imgSrc);
			           		sheet.getColumns(selRange.col, selRange.col + selRange.colCount - 1).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
			           	} else if (selRange.col < 0) {
			           		sheet.getRows(selRange.row, selRange.row + selRange.rowCount - 1).backgroundImage(imgSrc);
			           		sheet.getRows(selRange.row, selRange.row + selRange.rowCount - 1).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
			           	} else if (selRange.row < 0) {
			           		sheet.getColumns(selRange.col, selRange.col + selRange.colCount - 1).backgroundImage(_alimgSrcigntype);
			           		sheet.getColumns(selRange.col, selRange.col + selRange.colCount - 1).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
			           	} else {
			           		sheet.getCells(selRange.row, selRange.col, selRange.row + selRange.rowCount - 1, selRange.col + selRange.colCount - 1).backgroundImage(imgSrc);
			           		sheet.getCells(selRange.row, selRange.col, selRange.row + selRange.rowCount - 1, selRange.col + selRange.colCount - 1).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
			           	}
					}
				}*/
            });
            //插入链接
            operatpanel.find("[name=linktext]").click(function () {
            	if($(this).is(".shortBtn_disabled"))	return;
				var control = scpmanager.getCacheValue(getActiveExcelId());
        		var excelDiv = control.getControl();
        		var dataobj = control.getDataObj();
        		var ss = jQuery(excelDiv).wijspread("spread");
            	var sheet = ss.getActiveSheet();
            	var ar = sheet.getActiveRowIndex();		///当前活动单元格
            	var ac = sheet.getActiveColumnIndex();
            	if(dataobj)
				if(dataobj.ecs)
				if(dataobj.ecs[ar+","+ac]){
					if(dataobj.ecs[ar+","+ac].etype === celltype.TEXT || dataobj.ecs[ar+","+ac].etype ==="" 
						|| dataobj.ecs[ar+","+ac].etype === celltype.LINKTEXT);
					else{
						window.top.Dialog.alert("单元格内非文本,禁止插入链接!");
						return;
					}
				}
            	var dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				var url = "/workflow/exceldesign/excelUploadLink.jsp";
				dialog.Title = "插入链接";
				dialog.Width = 500;
				dialog.Height = 340;
				dialog.Drag = true; 	
				dialog.URL = url;
				dialog.show();
				dialog.callbackfun = function (paramobj, result) {
					if(!result) return;
					var djson = result;
					var cell = {};
					if(sheet.getCell(ar,ac,sheet.sheetArea).value() === null || sheet.getCell(ar,ac,sheet.sheetArea).value() === ""){
						sheet.getCell(ar,ac,sheet.sheetArea).value(djson.srcfile);
						cell.evalue=djson.srcfile;
					}
					var textDecoration = $.wijmo.wijspread.TextDecorationType.Underline;
				  	sheet.getCell(ar, ac,$.wijmo.wijspread.SheetArea.viewport).textDecoration(textDecoration);
					cell.efieldid = djson.srcfile;
					cell.efieldtype = djson.srcdeal;
					setCellProperties(ar+","+ac,celltype.LINKTEXT,cell);
				}
            });
            //插入代码
            operatpanel.find("[name=linkcode]").click(function () {
            	dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				var url = "/workflow/exceldesign/excelUploadCode.jsp";
				dialog.Title = "插入代码";
				dialog.Width = $(window).width()-300;
				dialog.Height = $(window).height()-200;
				dialog.Drag = true; 	
				dialog.URL = url;
				dialog.show();
            });
            //插入公式
            operatpanel.find("[name=formula]").click(function () {
    			if($(this).is(".shortBtn_disabled"))	return;
            	openFormulaWin();
            });
            //清除背景图
            operatpanel.find("[name=clearBgImg]").click(function () {
            	if($(this).is(".shortBtn_disabled")) return ;
            	var control = scpmanager.getCacheValue(getActiveExcelId());
        		var excelDiv = control.getControl();
        		var ss = jQuery(excelDiv).wijspread("spread");
            	ss.backgroundImage(null);
		  		ss.backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
		  		$(this).removeClass("shortBtn").addClass("shortBtn_disabled");
            });
           	//============插入 栏  END===============
           	//============字段属性 栏  START===============
           	//只读
           	operatpanel.find("[name=justread]").click(function () {
           		if($(this).is(".shortBtn_disabled")) return ;
           		operatpanel.find("[name=canwrite]").removeClass("shortBtnHover");
           		operatpanel.find("[name=required]").removeClass("shortBtnHover");
           		$(this).addClass("shortBtnHover");
           		setFieldPro(1);
           	});
           	//编辑
           	operatpanel.find("[name=canwrite]").click(function () {
           		if($(this).is(".shortBtn_disabled")) return ;
           		operatpanel.find("[name=justread]").removeClass("shortBtnHover");
           		operatpanel.find("[name=required]").removeClass("shortBtnHover");
           		$(this).addClass("shortBtnHover");
           		setFieldPro(2);
           	});
           	//必填
           	operatpanel.find("[name=required]").click(function () {
           		if($(this).is(".shortBtn_disabled")) return ;
           		operatpanel.find("[name=justread]").removeClass("shortBtnHover");
           		operatpanel.find("[name=canwrite]").removeClass("shortBtnHover");
           		$(this).addClass("shortBtnHover");
           		setFieldPro(3);
           	});
           	//字段属性
           	operatpanel.find("[name=fieldpro]").click(function () {
           		if($(this).is(".shortBtn_disabled")) return ;
           		var control = scpmanager.getCacheValue(getActiveExcelId());
        		var excelDiv = control.getControl();
        		var dataobj = control.getDataObj();
        		var ss = jQuery(excelDiv).wijspread("spread");
            	var sheet = ss.getActiveSheet();
            	var ar = sheet.getActiveRowIndex();		///当前活动单元格
            	var ac = sheet.getActiveColumnIndex();
            	var efieldid = dataobj.ecs[ar+","+ac].efieldid;
           		//打开 单元格属性 窗口
				dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				var url = "/workflow/exceldesign/excel_fieldattr.jsp?efieldid="+efieldid+"&isDetail="+isDetail;
				dialog.Title = "字段属性";
				dialog.Width = 600;
				dialog.Height = 600;
				dialog.Drag = true; 	
				dialog.URL = url;
				dialog.show();
           	});
           	//更多属性
           	operatpanel.find("[name=morepro]").click(function () {
           		if($(this).is(".shortBtn_disabled")) return ;
           		var control = scpmanager.getCacheValue(getActiveExcelId());
        		var excelDiv = control.getControl();
        		var dataobj = control.getDataObj();
        		var ss = jQuery(excelDiv).wijspread("spread");
            	var sheet = ss.getActiveSheet();
            	var ar = sheet.getActiveRowIndex();		///当前活动单元格
            	var ac = sheet.getActiveColumnIndex();
            	var efieldid = dataobj.ecs[ar+","+ac].efieldid;
           		dialog = new window.top.Dialog();
				dialog.currentWindow = window;
				var url = "/workflow/exceldesign/excel_fieldattrMore.jsp?efieldid="+efieldid+"&isDetail="+isDetail;
				dialog.Title = "更多属性";
				dialog.Width = 500;
				dialog.Height = 600;
				dialog.Drag = true; 	
				dialog.URL = url;
				dialog.show();
           	});
           	//============字段属性 栏  END===============
           	//============明细 栏  START===============
           	//明细表头
			operatpanel.find("[name=de_title]").click(function () {
				if($(this).is(".shortBtn_disabled"))
					return;
				$(this).attr("alreadyHave","0");
				$(this).addClass("shortBtn_disabled").removeClass("shortBtn");
				var control = scpmanager.getCacheValue(getActiveExcelId());
        		var excelDiv = control.getControl();
        		var dataobj = control.getDataObj();
        		var ss = jQuery(excelDiv).wijspread("spread");
            	var sheet = ss.getActiveSheet();
            	var sel = sheet.getSelections();
            	
            	var ar = sheet.getActiveRowIndex();
            	var ac = sheet.getActiveColumnIndex();
            	if(ar == 0)
            	{
            		window.top.Dialog.alert("第一行之前不能加入表头标识！");
            		$(this).removeAttr("alreadyHave");
					$(this).addClass("shortBtn").removeClass("shortBtn_disabled");
            		return;
            	}
            	sheet.isPaintSuspended(true);
            	sheet.addRows(sheet.getActiveRowIndex(), 1);
                setecsid4rcOpreation("row","insert",sheet.getActiveRowIndex(),1);//插入行
                //选中行
                sheet.setSelection(sheet.getActiveRowIndex(),0,1,sheet.getColumnCount());
                //合并单元格
                sel = getActualCellRange(sel[sel.length - 1], sheet.getRowCount(), sheet.getColumnCount());
           		sheet.addSpan(sel.row, sel.col, sel.rowCount, sel.colCount);
           		//添加文字
           		sheet.getCell(sheet.getActiveRowIndex(),sheet.getActiveColumnIndex(),$.wijmo.wijspread.SheetArea.viewport).value("表头标识");
           		var style = new $.wijmo.wijspread.Style();
				style.backColor = "#eeeeee";
           		sheet.setStyle(sheet.getActiveRowIndex(),sheet.getActiveColumnIndex(), style, $.wijmo.wijspread.SheetArea.viewport);
           		sheet.isPaintSuspended(false);
           		//设置单元格属性；
           		setCellProperties(sheet.getActiveRowIndex()+","+sheet.getActiveColumnIndex(),celltype.DE_TITLE);
            		
			});
			//明细表尾
			operatpanel.find("[name=de_tail]").click(function () {
				if($(this).is(".shortBtn_disabled"))
					return;
				$(this).attr("alreadyHave","0");
				$(this).addClass("shortBtn_disabled").removeClass("shortBtn");
				var control = scpmanager.getCacheValue(getActiveExcelId());
        		var excelDiv = control.getControl();
        		var dataobj = control.getDataObj();
        		var ss = jQuery(excelDiv).wijspread("spread");
            	var sheet = ss.getActiveSheet();
            	var sel = sheet.getSelections();
            	
            	var ar = sheet.getActiveRowIndex();
            	var ac = sheet.getActiveColumnIndex();
            	if(ar == sheet.getRowCount()-1)
            	{
            		window.top.Dialog.alert("最后一行之后不能加入表尾标识！");
            		return;
            	}
            	sheet.isPaintSuspended(true);
            	sheet.setSelection(sheet.getActiveRowIndex()+1,0,1,sheet.getColumnCount());
            	sheet.addRows(sheet.getActiveRowIndex(), 1);
                setecsid4rcOpreation("row","insert",sheet.getActiveRowIndex(),1);//插入行
                //选中行
                sheet.setSelection(sheet.getActiveRowIndex(),0,1,sheet.getColumnCount());
                //合并单元格
                sel = getActualCellRange(sel[sel.length - 1], sheet.getRowCount(), sheet.getColumnCount());
           		sheet.addSpan(sel.row, sel.col, sel.rowCount, sel.colCount);
           		//添加文字
           		sheet.getCell(sheet.getActiveRowIndex(),sheet.getActiveColumnIndex(),$.wijmo.wijspread.SheetArea.viewport).value("表尾标识");
           		var style = new $.wijmo.wijspread.Style();
				style.backColor = "#eeeeee";
           		sheet.setStyle(sheet.getActiveRowIndex(),sheet.getActiveColumnIndex(), style, $.wijmo.wijspread.SheetArea.viewport);
           		sheet.isPaintSuspended(false);
           		//设置单元格属性；
           		setCellProperties(sheet.getActiveRowIndex()+","+sheet.getActiveColumnIndex(),celltype.DE_TAIL);
			});
			//添加删除 按钮
			operatpanel.find("[name=de_btn]").click(function () {
				if($(this).is(".shortBtn_disabled"))
					return;
				$(this).attr("alreadyHave","0");
				$(this).addClass("shortBtn_disabled").removeClass("shortBtn");
				var imgsrc = "/workflow/exceldesign/image/shortBtn/detail/de_btn_wev8.png";
				var excelDiv = scpmanager.getCacheValue(getActiveExcelId()).getControl();
				var ss = $(excelDiv).wijspread("spread");
				var sheet = ss.getActiveSheet();
				var c = sheet.getActiveColumnIndex();
				var r = sheet.getActiveRowIndex();
				var cell = sheet.getCell(r,c,sheet.sheetArea);
				sheet.isPaintSuspended(true);
				cell.backgroundImage(imgsrc);
				cell.backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
				sheet.isPaintSuspended(false);
				//设置单元格属性；
           		setCellProperties(sheet.getActiveRowIndex()+","+sheet.getActiveColumnIndex(),celltype.DE_BTN);
			});
			
			//初始化明细菜单
			operatpanel.find("[name=mainDetail]").contextMenu({
				menu : 'mainDetailMenu',
				button: 1,//3: right click, 1: left click
				onPopup : function(el,e) {
					var detaiMenuJson = getDetailMenuJson();
					$("#mainDetailMenu").html("");
					$('#mainDetailMenu').mac('menu', detaiMenuJson);
				},
				//location: 'mouse',
				anchor: 'el',
				offset: { x: 14, y: 70 }
			}, function(action, el, pos) {
				doInsertDetail(action,"tm");
				return false;
			});
			//============明细 栏  END===============
			
        },
        
        //初始化右键菜单
        initRightClick:function()
        {
        	//初始化右键菜单
			jQuery("#excelDiv").contextMenu({
				menu : 'excelRightMenu',
				button: 3,//3: right click, 1: left click
				onPopup : function(el,e) {
					if(isEditFormulaing){$(el).addClass("disabled"); return;}
					else $(el).removeClass("disabled");
					try{
		 				e.stopPropagation();
		 				e.preventDefault();
					}catch(er){
						window.event.cancelBubble = true;
						return false;
					}
					var bx = getBxbyMousePosition(e);
					$("#excelRightMenu").html("");
					var menuJson = getMenuJson();
					$('#excelRightMenu').mac('menu', menuJson);
				},
				//location: 'mouse',
				offset: { x: 0, y: 0 }
			}, function(action, el, pos) {
				if(action === "setStyle"){
					openStyleWin();
				}else if(action.indexOf("detail")>=0){
					doInsertDetail(action,"rm");
				}else if(action === "cut" || action === "copy" || action === "paste"){
					doCCP(action);
				}else if(action === "cleanContent"){	
					cleanCell(2);
				}else if(action === "cleanStyle"){
					cleanCell(1);
				}else if(action === "insertrow"){
					insertRowCols("row");
				}else if(action === "insertcol"){
					insertRowCols("col");
				}else if(action === "deleterow"){
					deleteRowCols("row");
				}else if(action === "deletecol"){
					deleteRowCols("col");
				}else if(action === "setrowheight"){
					setRChw("r")
				}else if(action === "setcolwidth"){
					setRChw("c");
				}else if(action === "readonly"){
					//只读
	           		jQuery(".excelHeadContent").find("[name=canwrite]").removeClass("shortBtnHover");
	           		jQuery(".excelHeadContent").find("[name=required]").removeClass("shortBtnHover");
           			jQuery(".excelHeadContent").find("[name=justread]").addClass("shortBtnHover");
           			setFieldPro(1);
       			}else if(action === "canedit"){
           			//编辑
           			jQuery(".excelHeadContent").find("[name=justread]").removeClass("shortBtnHover");
           			jQuery(".excelHeadContent").find("[name=required]").removeClass("shortBtnHover");
           			jQuery(".excelHeadContent").find("[name=canwrite]").addClass("shortBtnHover");
       				setFieldPro(2);
           		}else if(action === "required"){
           			//必填
	           		jQuery(".excelHeadContent").find("[name=justread]").removeClass("shortBtnHover");
           			jQuery(".excelHeadContent").find("[name=canwrite]").removeClass("shortBtnHover");
           			jQuery(".excelHeadContent").find("[name=required]").addClass("shortBtnHover");
           			setFieldPro(3);
				}
				return false;
			});
        },
        saveDetail2Json:function(d_identy,flag)
        {
        	
        	var detail2Json = saveTable2Json("detail_"+d_identy);
        	//detail2Json = StringReplace2SaveJson(detail2Json);
        	if(flag === "save2Confirm")
        		return detail2Json;
        	else
        	{
	        	//console.log(detail2Json);
	        	//存放到主表缓存中
	        	if(!!detail2Json)
	        	{
	        		parentWin_Main.scpmanager.addCache("detail_"+d_identy, detail2Json);	//保存自定义属性 json
		        	var excelDiv = scpmanager.getCacheValue(getActiveExcelId()).getControl();
					var ss = $(excelDiv).wijspread("spread");
					var sheet = ss.getActiveSheet();
		        	var sheetJson = JSON.stringify(ss.toJSON());
		        	parentWin_Main.scpmanager.addCache("detail_"+d_identy+"_sheet", sheetJson);	//保存组件生成的 json
		        }
		        //给主界面的明细权限赋值
		        var detailAttr=getGroupAttr();
		        $("#detailgroupattr"+(parseInt(d_identy)-1),parentWin_Main.document).val(detailAttr);
        		detailFormulaTempAry.length = 0;
	        	var _dialog = parent.getDialog(window);
	        	_dialog.close();
        	}
        	
        },
        //保存
        saveExcel2Json:function(flag)
        {
        	if(flag === "save2Confirm" || flag === "export" || check_form(LayoutForm,"layoutname")){
        		if(flag === "saveLayout")
        		{
        			if(storage.getItem(storageKey))
        				storage.removeItem(storageKey);
        			__displayloaddingblock();
       			}
        		var formname = jQuery("#layoutname").val();
	        	var wfid=$("#wfid").val();
				var formid=$("#formid").val();
				var nodeid=$("#nodeid").val();
				var isbill=$("#isbill").val();
				
	        	var save2Json = "{";
	        	
		        	save2Json += "\"eformdesign\":{";
		        	save2Json += "\"eattr\":{";
		        	save2Json += "\"formname\":\""+formname+"\",";
		        	save2Json += "\"wfid\":\""+wfid+"\",";
		        	save2Json += "\"nodeid\":\""+nodeid+"\",";
		        	save2Json += "\"formid\":\""+formid+"\",";
		        	save2Json += "\"isbill\":\""+isbill+"\"";
		        	save2Json += "},";
		        	save2Json += "\"etables\": {";
		        	for(var key in scpmanager.getCache()){
		        		if(key.indexOf("sheet")>=0)
		        			continue;
		        		//如果明细在前面怎么办？理论上应该不会的，如果以后出现明细在前面，那么这里的逻辑需要修改
		        		if(key.indexOf("main")>=0)
		            		save2Json += saveTable2Json(key);	//保存主表
		            	else if(key.indexOf("detail")>=0){
		            		save2Json +=",";
		            		save2Json += scpmanager.getCacheValue(key);
	            		}
		            }
		            //如果有明细，需要拼接明细信息
		            save2Json += "}";			   //对应 etables：{	
		            if(scpmanager.getCacheValue(getActiveExcelId()).getFormulas())
		            {
			            save2Json += ",\"formula\":";
			            save2Json += JSON.stringify(scpmanager.getCacheValue(getActiveExcelId()).getFormulas());
		            }
		            save2Json += "}";		//对应 eformdesign：{
	            save2Json += "}";			//对应 json 开始的{
	            //console.log(save2Json);
	            //save2Json = StringReplace2SaveJson(save2Json);
	            if(flag != "save2Confirm")
           	 		setJSON(save2Json);
           	 	
	            var excelDiv = scpmanager.getCacheValue(getActiveExcelId()).getControl();
				var ss = $(excelDiv).wijspread("spread");
				var sheet = ss.getActiveSheet();
	        	var sheetJson = JSON.stringify(ss.toJSON());
	        	scpmanager.addCache("main_sheet", sheetJson);
	        	//把所有主表。明细表的json都拼起来
	        	var allSheetJsonStr = "";
	        	if(flag != "save2Confirm")
	        	{
		        	allSheetJsonStr+="{";
		        	for(var skey in scpmanager.getCache())
		        	{
		        		if(skey.indexOf("_sheet")>0)
		        		{
		        			allSheetJsonStr += "\""+skey+"\":";
		        			var sjstr = scpmanager.getCacheValue(skey);
		        			allSheetJsonStr+=sjstr;
		        			allSheetJsonStr += ",";
		        		}
		        	}
		        	allSheetJsonStr = allSheetJsonStr.substring(0,allSheetJsonStr.lastIndexOf(","));
		        	allSheetJsonStr+="}";
	        		setSheetJson(allSheetJsonStr);
        		}
           	}
            //保存、预览
            if(flag=='saveLayout'){
            	//保存时，把字段隐藏域的 只读、编辑、必填属性 重新根据
            	//$("input[id^=fieldattr][type=hidden]").val("0");
            	for(var ikey in fieldAttrMap)
            	{
            		$("#"+ikey).val(fieldAttrMap[ikey]);
            	}
            	saveLayout();
            }else if(flag=='preViewLayout'){
            	preViewLayout();
            }else if(flag==="export")
            {
            	var exportFile = "{\"dataobj\":"+save2Json+",\"sheetobj\":"+allSheetJsonStr+"}";
            	return exportFile;
            }else if(flag==="save2Confirm")
            {
            	return save2Json;
            }
        },
        //恢复主表，并且把自定义属性和控件json结构都序列化好
        readResumeMainTable:function()
        {
        	var sheetJson = getSheetJson();	//在excelSet.js中
        	var dataJson = getJson();
        	if(!sheetJson || sheetJson === "" || !dataJson || dataJson === "")
        		return;
        	sheetJson = JSON.parse(sheetJson);	//为了循环转成json
        	for(var skey in sheetJson)
        	{
        		//加入缓存中还要转成 字符串，为了保持一致
        		scpmanager.addCache(skey,JSON.stringify(sheetJson[skey]));
        	}
        	dataJson = JSON.parse(dataJson);
        	if(!!dataJson)
        	{
	        	for(var dkey in dataJson.eformdesign.etables)
	        	{
	        		//明细就直接加入缓存中了
	        		if(dkey.indexOf("detail")>=0)
	        			scpmanager.addCache(dkey,"\""+dkey+"\":"+JSON.stringify(dataJson.eformdesign.etables[dkey]));
	        		else
	        		{
	        			//主表需要处理
	        			var mainTable = dataJson.eformdesign.etables[dkey];
	        			var ecs = mainTable.ec;
	        			if(!ecs) break;
			        	for(var i=0;i<ecs.length;i++)
			        	{	
			        		//恢复单元格，并返回该单元格 的自定义属性
			        		resumeCell(ecs[i]);
			        	}
	        		}
	        	}
	        	var control = scpmanager.getCacheValue(getActiveExcelId());
	        	if(dataJson.eformdesign.formula)
	        	{
	        		control.initFormulas();
		        	for(var fkey in dataJson.eformdesign.formula)
		        	{
		        		control.setOneFormula(fkey,dataJson.eformdesign.formula[fkey]);
		        	}
	        	}
        	}
        	//console.dir(scpmanager.getCache());
        },
        //打开恢复
        resumeTable:function(dataObj,d_identy)
        {
        	var control = scpmanager.getCacheValue(getActiveExcelId());
       		var excelDiv = control.getControl();
       		var ss = jQuery(excelDiv).wijspread("spread");
           	var sheet = ss.getActiveSheet();
           	sheet.isPaintSuspended(true);
           	
           	var sjkey = d_identy+"_sheet";	//缓存中获取组件生成的json字符串的key;
        	var sheetJson = scpmanager.getCacheValue(sjkey);
        	if(isDetail === "on")
        		sheetJson = parentWin_Main.scpmanager.getCacheValue(sjkey);
        	sheetJson = JSON.parse(sheetJson);
        	ss.fromJSON(sheetJson);
        	sheet.isPaintSuspended(false);
            
       		if(d_identy === "main"){
       			dataObj = control.getDataObj();
       			resetFieldAttrHaveMap();
       			if(dataObj)
       			if(dataObj.ecs){
       				sheet = ss.getActiveSheet();
       				for(var mk in dataObj.ecs){
       					var r = mk.split(",")[0];
						var c = mk.split(",")[1];
       					if(dataObj.ecs[mk].etype === celltype.FNAME || dataObj.ecs[mk].etype === celltype.FCONTENT
							|| dataObj.ecs[mk].etype === celltype.NNAME || dataObj.ecs[mk].etype === celltype.NADVICE){
							setFieldAttrHave(dataObj.ecs[mk].efieldid,dataObj.ecs[mk].etype,1);

							if(dataObj.ecs[mk].etype === celltype.FNAME || dataObj.ecs[mk].etype === celltype.FCONTENT)
								sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).value($("#fieldattr"+dataObj.ecs[mk].efieldid).attr("fieldname"));
						}
						if(dataObj.ecs[mk].formula && dataObj.ecs[mk].etype === celltype.FCONTENT){
							sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).value(sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).value()+" (fx)");
						}
       				}
       				var _ac = sheet.getActiveColumnIndex();
					var _ar = sheet.getActiveRowIndex(); 
					if(dataObj)
					if(dataObj.ecs[_ar+","+_ac])
					if(dataObj.ecs[_ar+","+_ac].etype === celltype.FCONTENT){
						var fieldPanel = jQuery(".excelHeadContent").find(".s_filed");
						fieldPanel.find("[name=fieldpro]").removeClass("shortBtn").addClass("shortBtn_disabled");
						fieldPanel.find("[name=morepro]").removeClass("shortBtn").addClass("shortBtn_disabled");
						fieldPanel.find("[name=justread]").removeClass("shortBtnHover").addClass("shortBtn_disabled");
						fieldPanel.find("[name=canwrite]").removeClass("shortBtnHover").addClass("shortBtn_disabled");
						fieldPanel.find("[name=required]").removeClass("shortBtnHover").addClass("shortBtn_disabled");
						if(whichlayout === "1" || whichlayout === "2" || nodetype === "3")	//打印模板、mobile模板、归档节点，不让设置只读必填编辑属性
						{
							fieldPanel.find("[name=justread]").addClass("shortBtn_disabled").removeClass("shortBtn").removeClass("shortBtnHover");
							fieldPanel.find("[name=canwrite]").addClass("shortBtn_disabled").removeClass("shortBtn").removeClass("shortBtnHover");
							fieldPanel.find("[name=required]").addClass("shortBtn_disabled").removeClass("shortBtn").removeClass("shortBtnHover");
							if(dataObj.ecs[_ar+","+_ac].etype === celltype.FCONTENT)
							{
								fieldPanel.find("[name=fieldpro]").removeClass("shortBtn_disabled").addClass("shortBtn");
								fieldPanel.find("[name=morepro]").removeClass("shortBtn_disabled").addClass("shortBtn");
							}
						}else{
							if(dataObj.ecs[_ar+","+_ac].etype === celltype.FCONTENT){
								fieldPanel.find("[name=justread]").removeClass("shortBtn_disabled");
								fieldPanel.find("[name=canwrite]").removeClass("shortBtn_disabled");
								fieldPanel.find("[name=required]").removeClass("shortBtn_disabled");
								fieldPanel.find("[name=fieldpro]").removeClass("shortBtn_disabled").addClass("shortBtn");
								fieldPanel.find("[name=morepro]").removeClass("shortBtn_disabled").addClass("shortBtn");
							}
						}
					}
       			}
       		}
       		
           	
           	bindSpreadEvent(ss);
            ss.tabStripVisible(false);
        	
        	//只有恢复明细时需要处理自定义属性json
        	if(d_identy.indexOf("detail")>=0){
        		dataObj = dataObj[d_identy];
	        	var ecs = dataObj.ec;
	        	sheet = ss.getActiveSheet();
	        	for(var i=0;i<ecs.length;i++)
	        	{	
	        		//恢复单元格，并返回该单元格 的自定义属性
	        		resumeCell(ecs[i]);
	        		var __etype = reverseTransformerEtype(ecs[i].etype);
	        		if(ecs[i] && (__etype === celltype.FNAME || __etype === celltype.FCONTENT
							|| __etype === celltype.NNAME || __etype === celltype.NADVICE))
					{
						var r = ecs[i].id.split(",")[0];
						var c = ecs[i].id.split(",")[1];
						sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).value($(parentWin_Main.document).find("#fieldattr"+ecs[i].field).attr("fieldname"));
						var _ac = sheet.getActiveColumnIndex();
						var _ar = sheet.getActiveRowIndex(); 
						
						if(ecs[i].id === _ar+","+_ac && reverseTransformerEtype(ecs[i].etype) === celltype.FCONTENT)
						{
							var fieldPanel = jQuery(".excelHeadContent").find(".s_filed");
							fieldPanel.find("[name=fieldpro]").removeClass("shortBtn").addClass("shortBtn_disabled");
							fieldPanel.find("[name=morepro]").removeClass("shortBtn").addClass("shortBtn_disabled");
							fieldPanel.find("[name=justread]").removeClass("shortBtnHover").addClass("shortBtn_disabled");
							fieldPanel.find("[name=canwrite]").removeClass("shortBtnHover").addClass("shortBtn_disabled");
							fieldPanel.find("[name=required]").removeClass("shortBtnHover").addClass("shortBtn_disabled");
							if(whichlayout === "1" || whichlayout === "2" || nodetype === "3")	//打印模板、mobile模板、归档节点，不让设置只读必填编辑属性
							{
								fieldPanel.find("[name=justread]").addClass("shortBtn_disabled").removeClass("shortBtn").removeClass("shortBtnHover");
								fieldPanel.find("[name=canwrite]").addClass("shortBtn_disabled").removeClass("shortBtn").removeClass("shortBtnHover");
								fieldPanel.find("[name=required]").addClass("shortBtn_disabled").removeClass("shortBtn").removeClass("shortBtnHover");
								if(reverseTransformerEtype(ecs[i].etype) === celltype.FCONTENT)
								{
									fieldPanel.find("[name=fieldpro]").removeClass("shortBtn_disabled").addClass("shortBtn");
									fieldPanel.find("[name=morepro]").removeClass("shortBtn_disabled").addClass("shortBtn");
								}
							}else
							{
								if(ecs[i].etype === celltype.FCONTENT)
								{
									fieldPanel.find("[name=justread]").removeClass("shortBtn_disabled");
									fieldPanel.find("[name=canwrite]").removeClass("shortBtn_disabled");
									fieldPanel.find("[name=required]").removeClass("shortBtn_disabled");
									fieldPanel.find("[name=fieldpro]").removeClass("shortBtn_disabled").addClass("shortBtn");
									fieldPanel.find("[name=morepro]").removeClass("shortBtn_disabled").addClass("shortBtn");
								}
							}
						}
					}
					if(ecs[i] && (__etype === celltype.FCONTENT) &&　ecs[i].formula)
					{
						sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).value(sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).value()+ " (fx)");
					}
	        	}
        	}	
        	
        	
        	
        	//如果是归档节点和打印模式，所有图片变灰色
        	if(nodetype === "3" || whichlayout === "1")
        	{
       			ss = jQuery(excelDiv).wijspread("spread");
       			sheet = ss.getActiveSheet();
       			sheet.isPaintSuspended(true);
       			
       			if(d_identy.indexOf("detail")>=0)
       			{
       				if(dataObj)
       				if(dataObj.ec)
       				{
       					for(var i=0;i<dataObj.ec.length;i++)
       					{
       						if(!dataObj.ec[i].id) continue;
		   					var etype = dataObj.ec[i].etype;
		   					if(reverseTransformerEtype(etype) === celltype.FCONTENT || reverseTransformerEtype(etype) === celltype.NADVICE)
		   					{
								var r = dataObj.ec[i].id.split(",")[0];
								var c = dataObj.ec[i].id.split(",")[1];
								var cellstyle = sheet.getStyle(r,c,$.wijmo.wijspread.SheetArea.viewport);
								if(!cellstyle) continue;
								var bgimage = cellstyle.backgroundImage;
								if(!bgimage) continue;
								if(bgimage.indexOf("1") >= 0) continue;
								bgimage = bgimage.replace(new RegExp("2","gm"),"1");
	   							bgimage = bgimage.replace(new RegExp("3","gm"),"1");
								sheet.getCell(r,c,sheet.sheetArea).backgroundImage(bgimage);
							}
       					}
       				}
       			}
       			else
       			{
	        		if(dataObj)
		   			if(dataObj.ecs)
		   			{
		   				for(var cellid in dataObj.ecs)
		   				{
		   					if(!cellid) continue;
		   					var etype = dataObj.ecs[cellid].etype;
		   					var r = cellid.split(",")[0];
							var c = cellid.split(",")[1];
		   					if(etype === celltype.FCONTENT || etype === celltype.NADVICE)
		   					{
								var cellstyle = sheet.getStyle(r,c,$.wijmo.wijspread.SheetArea.viewport);
								if(!cellstyle) continue;
								var bgimage = cellstyle.backgroundImage;
								if(!bgimage) continue;
								if(bgimage.indexOf("1") >= 0) continue;
								bgimage = bgimage.replace(new RegExp("2","gm"),"1");
	   							bgimage = bgimage.replace(new RegExp("3","gm"),"1");
								sheet.getCell(r,c,sheet.sheetArea).backgroundImage(bgimage);
							}
		   				}
		   			}
	   			}
	   			sheet.isPaintSuspended(false);
   			}
        	
        	
        },
        //获取当前操作的sheet中的活动单元格的扩展属性
        getActiveCellDataObj:function()
        {
        	var control = scpmanager.getCacheValue(getActiveExcelId());
        	var excelDiv = control.getControl();
        	var ss = jQuery(excelDiv).wijspread("spread");
            var sheet = ss.getActiveSheet();
            var r = sheet.getActiveRowIndex();
            var c = sheet.getActiveColumnIndex();
            var dataObj = control.getDataObj();
            if(!dataObj) return null;
            if(!dataObj.ecs) return null;
        	return dataObj.ecs[r+","+c];
        },
        //获取活动单元格的边框样式
        getActiveCellBorder:function()
        {
        	var control = scpmanager.getCacheValue(getActiveExcelId());
        	var excelDiv = control.getControl();
        	var ss = jQuery(excelDiv).wijspread("spread");
            var sheet = ss.getActiveSheet();
            var r = sheet.getActiveRowIndex();
            var c = sheet.getActiveColumnIndex();
            var fbx_style = {};
                fbx_style = sheet.getStyle(r, c, $.wijmo.wijspread.SheetArea.viewport);
            if(!fbx_style) return null;
            if(fbx_style.borderLeft) return fbx_style.borderLeft;
            else if(fbx_style.borderTop) return fbx_style.borderTop;
            else if(fbx_style.borderRight) return fbx_style.borderRight;
            else if(fbx_style.borderBottom) return fbx_style.borderBottom;
        },
        getAllCellBorder:function()
        {
        	var control = scpmanager.getCacheValue(getActiveExcelId());
        	var excelDiv = control.getControl();
        	var ss = jQuery(excelDiv).wijspread("spread");
            var sheet = ss.getActiveSheet();
            var sels = sheet.getSelections();
            var range = getActualCellRange(sels[0], sheet.getRowCount(), sheet.getColumnCount());
            if(range.rowCount > 1 || range.colCount > 1)
            {
            	return {
            		left:sheet.getStyle(range.row, range.col, $.wijmo.wijspread.SheetArea.viewport).borderLeft,
            		right:sheet.getStyle(range.row+range.rowCount-1, range.col, $.wijmo.wijspread.SheetArea.viewport).borderRight,
            		top:sheet.getStyle(range.row, range.col, $.wijmo.wijspread.SheetArea.viewport).borderTop,
            		bottom:sheet.getStyle(range.row, range.col+range.colCount-1, $.wijmo.wijspread.SheetArea.viewport).borderBottom
            	};
            }else
            {
            	var fbx_style = {};
            	fbx_style = sheet.getStyle(range.row, range.col, $.wijmo.wijspread.SheetArea.viewport);
            	return {left:fbx_style.borderLeft,top:fbx_style.borderTop,right:fbx_style.borderRight,bottom:fbx_style.borderBottom};
            }
        },
        //设置表格样式接口
        //@type 包括字体，字体大小，粗细，颜色等
        setStyleInterface:function(type,param1)
        {
        	var control = scpmanager.getCacheValue(getActiveExcelId());
        	var excelDiv = control.getControl();
        	setMjiStyle(excelDiv,type,param1);
        },
        //选取表格选中框区域接口;
        getCellRange:function(cellRange, rowCount, columnCount)
        {
        	return getActualCellRange(cellRange, rowCount, columnCount);
        },
        //设置对齐方式接口
        setAlignBxFace:function(alignJson)
        {
        	alignBx(alignJson);
        },
        //自动换行接口
        setAutoWrapBxFace:function(wrap)
        {
        	autowrapBx(wrap);
        },
        //获取是否合并单元格
        getIsMergenBxFace:function()
        {
        	var control = scpmanager.getCacheValue(getActiveExcelId());
        	var excelDiv = control.getControl();
        	var ss = jQuery(excelDiv).wijspread("spread");
            var sheet = ss.getActiveSheet();
            var sels = sheet.getSelections();
            var range = getActualCellRange(sels[0], sheet.getRowCount(), sheet.getColumnCount());
            var ismergenBx = true;
            for (var i = 0; i < range.rowCount; i++) {
            	if(!ismergenBx)break;
				for (var j = 0; j < range.colCount; j++) {
					var r = range.row + i;
               	 	var c = range.col + j;
					var spans = sheet.getSpan(r,c,$.wijmo.wijspread.SheetArea.viewport);
					if(spans==null){
						ismergenBx=false;
						break;
					}
				}
			}
			return ismergenBx;
        },
        getIsChooseSingleCell:function()
        {
			return isChooseSingleCell();
        },
        //合并/拆分单元格 接口
        setMerSplbxFace:function(mors)
        {
        	if(mors)
        		mergenBx();
        	else if(mors == false)
        		splitBx();
        	else{
        		//do nothing;
        	}
        },
        //数字 设置类型 接口
        setNumbricBxFace:function(numberJson)
        {
        	numbricalBx(numberJson);
        },
        setBorderBxFace:function(borderJson)
        {
        	
        },
        //清除内容接口
        cleanContentBxFace:function()
        {
        	cleanCell(2);
        },
        openFormulaWinFace:function()
        {
        	openFormulaWin();
        },
        insertRowandCol4LastFace:function(isrc)
        {
        	insertRowandCol4Last(isrc);
        },
        importExcelFace:function(allJson)
        {
        	var asj = JSON.parse(allJson);
        	try{
        		var crtformid = $("#formid").val();
        		if(asj.dataobj.eformdesign.eattr.formid != crtformid)
        		{
        			window.top.Dialog.alert("该文件中引用的表单与当前流程表单不一致，不能导入！");
        			return false;
        		}
        	}catch(e)
        	{
        		window.top.Dialog.alert("无法解析导入的文件，请确认");
        		return false;
        	}
			for(var ajskey in asj)
	       	{
	       		if(ajskey === "dataobj")
	       		{
	       			var dataJson = asj[ajskey];
	       			for(var dkey in dataJson.eformdesign.etables)
		        	{
		        		//明细就直接加入缓存中了
		        		if(dkey.indexOf("detail")>=0)
		        			scpmanager.addCache(dkey,"\""+dkey+"\":"+JSON.stringify(dataJson.eformdesign.etables[dkey]));
		        		else
		        		{
		        			//主表需要处理
		        			var mainTable = dataJson.eformdesign.etables[dkey];
		        			var ecs = mainTable.ec;
		        			if(!ecs) break;
				        	for(var i=0;i<ecs.length;i++)
				        	{	
				        		//恢复单元格，并返回该单元格 的自定义属性
				        		resumeCell(ecs[i]);
				        	}
		        		}
		        	}
	       		}else if(ajskey === "sheetobj")
	       		{
	       			var sheetJson = asj[ajskey];
	       			for(var skey in sheetJson)
		        	{
		        		//加入缓存中还要转成 字符串，为了保持一致
		        		scpmanager.addCache(skey,JSON.stringify(sheetJson[skey]));
		        	}
	       		}
	       	}
	       	return true;
        },
        changeTable4OpFace:function(tabletype,currentTableSheetJson)
        {
        	changeTable4Op(tabletype,currentTableSheetJson);
        },
        getCurrentSheetJsonFace:function()
        {
        	var excelDiv = scpmanager.getCacheValue(getActiveExcelId()).getControl();
			var ss = $(excelDiv).wijspread("spread");
			var sheetJson = JSON.stringify(ss.toJSON()); 
			return sheetJson;
        },
        setCurrentSheetJsonFace:function(sheetJson,islocked){
        	if(!sheetJson)return;
        	var excelDiv = scpmanager.getCacheValue(getActiveExcelId()).getControl();
			var ss = $(excelDiv).wijspread("spread");
			var sheet = ss.getActiveSheet();
			
			sheet.isPaintSuspended(true);
       		sheetJson = JSON.parse(sheetJson);
       		ss.fromJSON(sheetJson);
       		sheet.isPaintSuspended(false);
       		sheet = ss.getActiveSheet();
       		if(islocked){
       			sheet.setIsProtected(true);
       			bindSpreadEvent4Formula(ss);
       		}
       		else
       			bindSpreadEvent(ss);
        }
    };
})();
