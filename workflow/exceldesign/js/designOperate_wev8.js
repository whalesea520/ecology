/**
 * JS实现replaceAll方法
 */
String.prototype.replaceAll = function (str1,str2){
	var str    = this;
	var result   = str.replace(eval("/"+str1+"/gi"),str2);
	return result;
}

/**
 * 模板保存、恢复等相关操作方法封装
 */
var formOperate=(function (){

   	/**
   	 * 拼接指定窗口的datajson串，适用于主表、标签页、明细表
   	 */
	function joinDataStrBySymbol(symbol){
		if(!globalData.hasCache(symbol))
			return "";
		var excelDiv;
		//由于拼接datajson需要用到对应的sheet面板内容，故每次拼接需将sheetjson恢复在隐藏的面板中，只用于保存
		if(symbol.indexOf("detail_") > -1){
			excelDiv = jQuery("#excelDiv");
		}else{
			excelDiv = jQuery("#excelDiv_hidden");
			var sheetJson = globalSheet.getCacheValue(symbol+"_sheet");
			onlyResumePanel(excelDiv, sheetJson);	
		}
		
		var ss = excelDiv.wijspread("spread");
		var sheet = ss.getActiveSheet();
		var spans = sheet.getSpans();		//获取合并单元格
		var dataobj = globalData.getCacheValue(symbol);
   		var ecs = globalData.getCacheValue(symbol).ecs;
   		//给ecs添加合并单元格信息
   		for(var item in ecs){
   			var id_x = item.split(",")[0];
			var id_y = item.split(",")[1];
			var rowspan = 1;
			var colspan = 1;
			//获取合并单元格信息
			for (var i = 0; i < spans.length; i++) {
				if ((spans[i].row + "") == id_x && (spans[i].col + "") == id_y) {
					rowspan = spans[i].rowCount;
					colspan = spans[i].colCount;
					break;
				}
			}
			ecs[item].rowspan = rowspan;
			ecs[item].colspan = colspan;
   		}
   		//计算最大行数、列数
   		var maxCell = getMaxCell(sheet, ecs);
   		var rowcount = parseInt(maxCell.split(",")[0]);
 		var columncount = parseInt(maxCell.split(",")[1]);
 		
		var save2Json = "";
   		if(symbol === "main"){
   			save2Json += "\"emaintable\":{";
   		}else{
   			save2Json += "\""+symbol+"\":{";
   		}
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
			var cw = sheet.getColumnWidth(i, $.wijmo.wijspread.SheetArea.colHeader);
			if(ispercent.indexOf("%") >0)
				cw = ispercent.substring(ispercent.indexOf("(")+1,ispercent.indexOf(")"));
			save2Json += "\"col_"+i+"\":\""+cw+"\"";
			save2Json += (columncount-i>0)?",":"";
		}
		save2Json +="},"
		
		//保存行列自定义属性
		if(dataobj.rowattrs && !jQuery.isEmptyObject(dataobj.rowattrs))
			save2Json += "\"rowattrs\":"+JSON.stringify(dataobj.rowattrs)+",";
		if(dataobj.colattrs && !jQuery.isEmptyObject(dataobj.colattrs))
			save2Json += "\"colattrs\":"+JSON.stringify(dataobj.colattrs)+",";
		
		//浮动图片
		if(sheet._floatingObjectArray){
			var floatpic = JSON.stringify((sheet._floatingObjectArray).toJSON());
			if(floatpic)
				save2Json += "\"floatingObjectArray\":"+floatpic+",";
		}
		if(ss.backgroundImage()){
			save2Json += "\"backgroundImage\":\""+ss.backgroundImage()+"\",";
		}
		//单元格
		save2Json += "\"ec\":[";
		var ecs2Json = "";
		var edtitlerow = 0;
		var edtailrow = 0;
		for(var item in ecs){
			//坐标拆分
			var id_x = item.split(",")[0];
			var id_y = item.split(",")[1];
			var ecObj = ecs[item];
			var etype = ecObj.etype;
			if(etype === celltype.DE_TITLE)
				edtitlerow = id_x;
			else if(etype === celltype.DE_TAIL)
				edtailrow = id_x;
			etype = transformerEtype(etype);
			ecs2Json += joinSingleCellStr(sheet, id_x, id_y, ecObj, etype);
			ecs2Json += ",";
		}
		ecs2Json = ecs2Json.substring(0,ecs2Json.lastIndexOf(","));
		save2Json += ecs2Json;
		save2Json += "]";		//对应 ec: [
		if(symbol.indexOf("detail_") > -1){
			save2Json += ",";
			save2Json += "\"edtitleinrow\":\""+edtitlerow+"\",";
			save2Json += "\"edtailinrow\":\""+edtailrow+"\",";
			save2Json += "\"seniorset\":\""+(detailOperate.hasOpenSeniorSet()?1:0)+"\"";	//中间不可有任何空格，用于主表保存判断
		}
		save2Json += "}";		//对应 emaintable：{
		return save2Json;
	}
	//获取最多单元格
	function getMaxCell(sheet, ecs){
   		var maxrow = 0;
   		var maxcol = 0;
   		for(var item in ecs){
   			var ecObj = ecs[item];
   			if(ecObj.etype === celltype.DE_TITLE || ecObj.etype === celltype.DE_TAIL)
   				continue;
   			var r = parseInt(item.split(",")[0]);
   			var c = parseInt(item.split(",")[1]);
   			var cur_row = r + parseInt(ecObj.rowspan) - 1;
   			var cur_col = c + parseInt(ecObj.colspan) - 1;
   			if((cur_row > maxrow || cur_col > maxcol) && (!ecObj.etype || ecObj.etype === celltype.TEXT)){
   				//过滤掉空内容单元格,空内容单元格包含(边框/背景色/自定义属性)才认为是有效单元格，无效单元格直接删除
   				var celltext = jQuery.trim(sheet.getCell(r, c, $.wijmo.wijspread.SheetArea.viewport).text());
   				if(celltext === ""){
   					var borderStr = parseCellBorderStr(sheet, r, c, ecObj);
   					var _style = sheet.getStyle(r, c, $.wijmo.wijspread.SheetArea.viewport);
   					if(_style == null)	_style = new $.wijmo.wijspread.Style();
   					if(borderStr === "" && !_style.backColor && jQuery.isEmptyObject(ecObj.attrs)){
   						delete ecs[item];
   						continue;
   					}
   				}
   			}
   			if(cur_row > maxrow)
   				maxrow = cur_row;
   			if(cur_col > maxcol)
   				maxcol = cur_col;
   		}
		//解决在内容列后设置空列(一列或连续多列)且宽度为%情况，此列应作为生效列处理
   		for(var i=0; i<3 ; i++){
   			var colheadvalue = sheet.getValue(0, maxcol+1,$.wijmo.wijspread.SheetArea.colHeader);
   			if(colheadvalue.indexOf("%") > -1)
   				maxcol++;
			else
				break;
   		}
   		if(window.console)	console.log("最大行："+maxrow+"  最大列："+maxcol);
   		return maxrow+","+maxcol;
   	}
   	
   	/**
   	 * 拼接多内容窗口的datajson串，只适用于多内容面板
   	 */
   	function joinMcDataStr(mcpoint){
   		if(!globalData.hasCache(mcpoint) || !globalSheet.hasCache(mcpoint+"_sheet"))
			return "";
		var dataobj = globalData.getCacheValue(mcpoint);
		var sheetjson = globalSheet.getCacheValue(mcpoint+"_sheet");
		//将dataobj缓存转为datajson串，需先将内容恢复到面板
		var mc_ss = jQuery("#excelDiv_mc").wijspread("spread");
		var mc_sheet = mc_ss.getActiveSheet();
		var mc_sheetjson = JSON.parse(sheetjson);
		mc_sheet.isPaintSuspended(true);
		mc_ss.fromJSON(mc_sheetjson);
    	mc_sheet.isPaintSuspended(false);
    	mc_sheet = mc_ss.getActiveSheet();
    	var mc_datastr = "\""+mcpoint+"\":{";
    	mc_datastr += "\"rowcount\":\""+mc_sheet.getRowCount()+"\",";
    	mc_datastr += "\"colcount\":\"2\",";
    	mc_datastr += "\"ec\":["
    	var ecs = dataobj.ecs;
    	var ecs2Json = "";
    	for(var r=0; r<mc_sheet.getRowCount(); r++){
    		var id_x = r;
    		var id_y = 0;
    		if(ecs[id_x+","+id_y]){
	    		var celltext = mc_sheet.getCell(id_x,id_y,$.wijmo.wijspread.SheetArea.viewport).text();
	    		var ecObj = ecs[id_x+","+id_y];
	    		if(jQuery.trim(celltext) != "" || !jQuery.isEmptyObject(ecObj.attrs)){
		    		var etype = ecObj.etype;
		    		etype = transformerEtype(etype);
					ecs2Json += joinSingleCellStr(mc_sheet, id_x, id_y, ecObj, etype);
					ecs2Json += ",";
	    		}
    		}
			id_y = 1;	//拼接换行信息
			if(ecs[id_x+","+id_y] && ecs[id_x+","+id_y].etype === celltype.BR){
				var ecObj_br = ecs[id_x+","+id_y];
				ecs2Json += "{";
				ecs2Json += "\"id\":\""+id_x+","+id_y+"\",";
				ecs2Json += "\"etype\":\""+transformerEtype(ecObj_br.etype)+"\",";
				ecs2Json += "\"brsign\":\""+ecObj_br.brsign+"\"";
				ecs2Json += "},";
			}
    	}
    	ecs2Json = ecs2Json.substring(0,ecs2Json.lastIndexOf(","));
    	mc_datastr += ecs2Json;
    	mc_datastr += "]";
    	mc_datastr += "}";
    	return mc_datastr;
   	}
   	
   	/**
   	 * 拼接单个单元格串
   	 */
   	function joinSingleCellStr(sheet, id_x, id_y, ecObj, etype){
   		var ecs2Json = "";
   		ecs2Json += "{";
		ecs2Json += "\"id\":\""+id_x+","+id_y+"\",";
		if(ecObj.colspan)
			ecs2Json += "\"colspan\":\""+ecObj.colspan+"\",";
		if(ecObj.rowspan)
			ecs2Json += "\"rowspan\":\""+ecObj.rowspan+"\",";
		ecs2Json += "\"etype\":\""+(!!etype ? etype : 0)+"\",";
		//etype 已转换成数字，不同单元格类型保存不同属性
		if(etype === "2" || etype === "3" || etype === "4" || etype === "5" || etype === "6"
			|| etype === "11" || etype === "18" || etype === "19") {
			ecs2Json += "\"field\":\""+ecObj.efieldid+"\",";		//字段ID，流程节点ID(不可变更顺序紧跟etype后面，流程导入替换用到)
			if(!!ecObj.efieldtype)
				ecs2Json += "\"fieldtype\":\""+ecObj.efieldtype+"\",";		//字段ID，流程节点ID
		}else if(etype === "7"){
			ecs2Json += "\"detail\":\""+ecObj.edetail+"\",";		//明细表			
		}else if(etype === "12"){	//标签页信息保存
			if(ecObj.tab)
				ecs2Json += "\"tab\":"+JSON.stringify(ecObj.tab)+",";
		}else if(etype === "13"){	//多内容字段
			ecs2Json += "\"mcpoint\":\""+ecObj.mcpoint+"\",";
		}else if(etype === "15" || etype === "16" || etype === "17"){	//门户元素、Iframe区域、扫描码
			if(ecObj.jsonparam)
				ecs2Json += "\"jsonparam\":"+JSON.stringify(ecObj.jsonparam)+",";
		}
		//自定义属性
		if(ecObj.attrs && !jQuery.isEmptyObject(ecObj.attrs))	
			ecs2Json += "\"attrs\":"+JSON.stringify(ecObj.attrs)+",";
		//单元格格式化
		if(etype === "3" && ecObj.enumbric){
			ecs2Json += "\"format\":{";
			ecs2Json += (ecObj.enumbric.n_set)?"\"numberType\":\""+ecObj.enumbric.n_set+"\",":"\"numberType\":\"-1\",";
			ecs2Json += (ecObj.enumbric.n_decimals)?"\"decimals\":\""+ecObj.enumbric.n_decimals+"\",":"\"decimals\":\"-1\",";
			ecs2Json += (ecObj.enumbric.n_us)?"\"thousands\":\""+ecObj.enumbric.n_us+"\",":"\"thousands\":\"-1\",";
			ecs2Json += (ecObj.enumbric.n_target)?"\"formatPattern\":\""+ecObj.enumbric.n_target+"\"":"\"formatPattern\":\"-1\"";
			ecs2Json += "},";
		}
		//财务格式
		if(ecObj.financial)
			ecs2Json += "\"financial\":\""+ecObj.financial+"\",";
		//公式
		if(etype === "3" && ecObj.formula)
			ecs2Json += "\"formula\":\""+ecObj.formula+"\",";
		
		//************样式保存（字体、缩进、背景色） begin**********
		//原有保存采用从datajson读缓存方式，新方式采用从当前sheet读可视化样式,保证两JSON样式同步
		var userNewWay = true;
		if(userNewWay){
			var _style = sheet.getStyle(id_x, id_y, $.wijmo.wijspread.SheetArea.viewport);
			if(!!_style){
				ecs2Json += "\"font\":{"+parseCellStyleStr(_style)+"},";
				if(_style.textIndent){
					var _textIndent = _style.textIndent;
					var isAlignLeft = (!_style.hAlign || _style.hAlign === $.wijmo.wijspread.HorizontalAlign.left);
					if(isAlignLeft && baseOperate.judgeCellDefaultRetractFace(ecObj))
						_textIndent = _textIndent-2.5;
					if(_textIndent > 0)
						ecs2Json += "\"etxtindent\":\""+_textIndent+"\",";
				}
				if(_style.backColor)
					ecs2Json += "\"backgroundColor\":\""+_style.backColor+"\",";
			}
		}
		//************样式保存（字体、缩进、背景色） end**********
		//************边框保存 begin*************
		var borderStr = parseCellBorderStr(sheet, id_x, id_y, ecObj);
		if(borderStr !== "")
			ecs2Json += "\"eborder\":["+borderStr+"],";
		//************边框保存 end*************
		var celltext = sheet.getCell(id_x,id_y,$.wijmo.wijspread.SheetArea.viewport).text();
		celltext = replaceCellText(celltext);
		ecs2Json += "\"evalue\":\""+celltext+"\"";
		ecs2Json += "}";	//对应 ec 中第一个{
		return ecs2Json;
   	}
   	
   	/**
   	 * 解析单元格字体、居中等样式
   	 */
   	function parseCellStyleStr(_style){
   		var stylestr = "";
   		if(!!_style.font){
   			var cellfont = _style.font;
   			if(cellfont.indexOf("bold") > -1)
   				stylestr += "\"bold\":\"true\",";
   			if(cellfont.indexOf("italic") > -1)
   				stylestr += "\"italic\":\"true\",";
   			if(cellfont.indexOf("pt") > -1)
   				stylestr += "\"font-size\":\""+cellfont.match(/\d+pt/g)+"\",";
   			var cellfontfamily = baseOperate.getCellFontFamilyFace(cellfont);
   			if(cellfontfamily !== "")
   				stylestr += "\"font-family\":\""+cellfontfamily+"\",";
   		}
   		if(!!_style.foreColor)
   			stylestr += "\"color\":\""+_style.foreColor+"\",";
   		if(!!_style.textDecoration){
   			if(_style.textDecoration === 1)
   				stylestr += "\"underline\":\"true\",";
   			else if(_style.textDecoration === 2)
   				stylestr += "\"deleteline\":\"true\",";
   			else if(_style.textDecoration === 3){
   				stylestr += "\"underline\":\"true\",";
   				stylestr += "\"deleteline\":\"true\",";
   			}
   		}
   		if(_style.hAlign){
   			if(_style.hAlign === $.wijmo.wijspread.HorizontalAlign.left)
   				stylestr += "\"text-align\":\"left\",";
   			else if(_style.hAlign === $.wijmo.wijspread.HorizontalAlign.center)
   				stylestr += "\"text-align\":\"center\",";
   			else if(_style.hAlign === $.wijmo.wijspread.HorizontalAlign.right)
   				stylestr += "\"text-align\":\"right\",";
   		}
		if(_style.vAlign){
			if(_style.vAlign === $.wijmo.wijspread.VerticalAlign.top)
				stylestr += "\"valign\":\"top\",";
			else if(_style.vAlign === $.wijmo.wijspread.VerticalAlign.center)
				stylestr += "\"valign\":\"middle\",";
			else if(_style.vAlign === $.wijmo.wijspread.VerticalAlign.bottom)
				stylestr += "\"valign\":\"bottom\",";
		}	
		if(stylestr.length >0 && stylestr.substring(stylestr.length-1) === ",")
			stylestr = stylestr.substring(0, stylestr.length-1);
   		return stylestr;
   	}
   	
   	/**
   	 * 解析单元格边框样式，生成串
   	 */
   	function parseCellBorderStr(sheet, id_x, id_y, ecObj){
   		var borderStr = "";
		var topborder = sheet.getCell(id_x,id_y,$.wijmo.wijspread.SheetArea.viewport).borderTop();
		if(topborder && topborder.style != 0)
			borderStr += "{\"kind\":\"top\",\"style\":\""+topborder.style+"\",\"color\":\""+topborder.color+"\"},";
		var leftborder = sheet.getCell(id_x,id_y,$.wijmo.wijspread.SheetArea.viewport).borderLeft();
		if(leftborder && leftborder.style != 0) 
			borderStr += "{\"kind\":\"left\",\"style\":\""+leftborder.style+"\",\"color\":\""+leftborder.color+"\"},";
		var rightborder;
		if(ecObj.colspan > 1)
			rightborder = sheet.getCell(id_x,(parseInt(id_y)+ecObj.colspan-1)+"",$.wijmo.wijspread.SheetArea.viewport).borderRight();
		else
			rightborder = sheet.getCell(id_x,id_y,$.wijmo.wijspread.SheetArea.viewport).borderRight();
		if(rightborder && rightborder.style != 0)
			borderStr += "{\"kind\":\"right\",\"style\":\""+rightborder.style+"\",\"color\":\""+rightborder.color+"\"},";
		var bottomborder;
		if(ecObj.rowspan > 1)
			bottomborder = sheet.getCell((parseInt(id_x)+ecObj.rowspan-1)+"",id_y,$.wijmo.wijspread.SheetArea.viewport).borderBottom();
		else
			bottomborder = sheet.getCell(id_x,id_y,$.wijmo.wijspread.SheetArea.viewport).borderBottom();
		if(bottomborder && bottomborder.style != 0)
			borderStr += "{\"kind\":\"bottom\",\"style\":\""+bottomborder.style+"\",\"color\":\""+bottomborder.color+"\"},";
		if(borderStr.length > 0 && borderStr.substring(borderStr.length-1) === ",")
			borderStr = borderStr.substring(0, borderStr.length-1);
		return borderStr;
   	}
	
	/**
	 * 模板窗口保存
	 */
	function saveLayoutWindow(flag){
		if(flag != "save2Confirm"){		//模板校验明细是否全为高级模式
			var existSeniorSetDetail = false;
			var notOpenDetailIndex = "";
			for(var symbol in globalData.getCache()){
				if(symbol.indexOf("detail_") > -1){
					var detail_datastr = globalData.getCacheValue(symbol);
					if(detail_datastr.indexOf("\"seniorset\":\"1\"") > -1){
						existSeniorSetDetail = true;
					}else{
						if(notOpenDetailIndex === "")
							notOpenDetailIndex = symbol.replace("detail_", "");
					}
				}
			}
			if(existSeniorSetDetail && notOpenDetailIndex !== ""){
	    		window.top.Dialog.alert("<font style=\"color:red;font-size:14px\">模板不合法，请调整模板！</font></br>原因：明细表"+notOpenDetailIndex+"未启用高级定制");
	    		return;
			}
		}
		if(flag === "saveLayout"){
			if(!check_form(LayoutForm,"layoutname"))
				return;
			//模板名称不可重复
			var layoutname = "$["+jQuery("#layoutname").val()+"]$";
			if(jQuery("#otherslayoutname").val().indexOf(layoutname) > -1){
				window.top.Dialog.alert("当前模板名称已被使用，请修改模板名称再保存！");
				return;
			}
			if(storage.getItem(storageKey))
				storage.removeItem(storageKey);
			__displayloaddingblock();
		}
		//===============  拼接控件sheetjson  begin ==========
		var cur_symbol = globalData.getCacheValue("symbol");
		if(cur_symbol === "main"){
			saveCurrentSheet("main");
		}else if(cur_symbol.indexOf("tab_") > -1){
			tabOperate.saveTabInfoFace();
		}
    	var allSheetJsonStr = "";
    	if(flag != "save2Confirm"){
	    	allSheetJsonStr += "{";
	    	for(var key in globalSheet.getCache()){
				allSheetJsonStr += "\""+key+"\":";
				allSheetJsonStr += globalSheet.getCacheValue(key);
				allSheetJsonStr += ",";
	    	}
	    	allSheetJsonStr = allSheetJsonStr.substring(0,allSheetJsonStr.lastIndexOf(","));
	    	allSheetJsonStr+="}";
			$("#pluginjson").val(allSheetJsonStr);
		}
		//===============  拼接控件sheetjson  end ==========
		
		//===============  拼接数据datajson  begin ==========
    	var save2Json = "{";
        	save2Json += "\"eformdesign\":{";
        	save2Json += "\"eattr\":{";
        	save2Json += "\"formname\":\""+replaceCellText(jQuery("#layoutname").val())+"\",";
        	save2Json += "\"wfid\":\""+jQuery("#wfid").val()+"\",";
        	save2Json += "\"nodeid\":\""+jQuery("#nodeid").val()+"\",";
        	save2Json += "\"formid\":\""+jQuery("#formid").val()+"\",";
        	save2Json += "\"isbill\":\""+jQuery("#isbill").val()+"\"";
        	save2Json += "},";
        	save2Json += "\"etables\": {";
        	for(var key in globalSheet.getCache()){
        		var symbol = key.replace("_sheet", "");
        		var dataJsonStr = "";
        		if(symbol === "main" || symbol.indexOf("tab_") > -1){	//拼接主表及标签页
        			dataJsonStr = joinDataStrBySymbol(symbol);
        		}else if(symbol.indexOf("detail_") > -1){		//拼接明细
        			dataJsonStr = globalData.getCacheValue(symbol);
        		}else if(symbol.indexOf("mc_") > -1){			//拼接多字段
        			dataJsonStr = joinMcDataStr(symbol);
        		}
        		if(dataJsonStr != "")
        			save2Json += dataJsonStr+",";
        	}
        	save2Json = save2Json.substring(0, save2Json.lastIndexOf(","));
            save2Json += "}";			   //对应 etables：{	
            //如果有公式，需要拼接公式信息
            if(formulaObj.getFormulas()){
	            save2Json += ",\"formula\":";
	            save2Json += formulaOperate.saveFormulasFace();
            }
            save2Json += "}";		//对应 eformdesign：{
        save2Json += "}";			//对应 json 开始的{
        //if(window.console)	console.log(save2Json);
        if(flag != "save2Confirm")
   	 		$("#datajson").val(save2Json);
   	 	//===============  拼接数据datajson  end ==========
       	
        //保存、预览
        if(flag == "saveLayout"){
        	saveLayout();
        }else if(flag == "preViewLayout"){
        	preViewLayout();
        }else if(flag === "export"){
        	var exportFile = "{\"dataobj\":"+save2Json+",\"sheetobj\":"+allSheetJsonStr+"}";
        	return exportFile;
        }else if(flag==="save2Confirm"){
        	return save2Json;
        }
	}

	/**
	 * 明细窗口保存
	 */
	function saveDetailWindow(d_identy, flag){
    	var detail2Json = joinDataStrBySymbol("detail_"+d_identy);
    	if(flag === "save2Confirm")
    		return detail2Json;
    	else{
    		var verifyresult = detailOperate.verifyDetailTemplateFace();
    		if(verifyresult != "pass"){
    			window.top.Dialog.alert("<font style=\"color:red;font-size:14px\">模板不合法，请调整模板！</font></br>原因："+verifyresult);
    			return;
    		}
        	//存放到主表缓存中
        	if(!!detail2Json){
        		parentWin_Main.globalData.addCache("detail_"+d_identy, detail2Json);	//保存自定义属性 json
				var ss = jQuery("#excelDiv").wijspread("spread");
	        	var detail_sheetJson = JSON.stringify(ss.toJSON());
	        	parentWin_Main.globalSheet.addCache("detail_"+d_identy+"_sheet", detail_sheetJson);	//保存组件生成的 json
	        }
	        //给主界面的明细权限赋值
	        var detailAttr=getGroupAttr();
	        $("#detailgroupattr"+(parseInt(d_identy)-1),parentWin_Main.document).val(detailAttr);
    		detailFormulaTempAry.length = 0;
        	var _dialog = parent.getDialog(window);
        	_dialog.close();
    	}
	}
	
	/**
	 * 保存当前编辑主表/标签页Sheet（dataobj在globaldata中为全局对象不需处理；sheetjson需重新放入globalsheet）
	 */
	function saveCurrentSheet(cur_symbol){
		var ss = jQuery("#excelDiv").wijspread("spread");
		var cur_sheetJson = JSON.stringify(ss.toJSON());
    	globalSheet.addCache(cur_symbol+"_sheet", cur_sheetJson);
	}
	
	/**
	 * 加载模板时先序列化缓存
	 */
	function resumeLayoutCache(sheetJson, dataJson){
    	if(!sheetJson || !dataJson)
    		return false;
    	sheetJson = sheetJson.replace(new RegExp("#title_br_replacestr#","gm"),"&#13;");
    	dataJson = dataJson.replace(new RegExp("#title_br_replacestr#","gm"),"&#13;");
    	
    	sheetJson = JSON.parse(sheetJson);	//为了循环转成json
    	for(var skey in sheetJson){		    //转成字符串加入globalSheet缓存
    		globalSheet.addCache(skey, JSON.stringify(sheetJson[skey]));
    	}
    	dataJson = JSON.parse(dataJson);
    	for(var dkey in dataJson.eformdesign.etables){	//转成字符串加入globalData缓存
    		if(dkey === "emaintable"){
    			globalData.addCache("main", JSON.stringify(dataJson.eformdesign.etables[dkey]));
    		}else if(dkey.indexOf("tab_") > -1 || dkey.indexOf("mc_") > -1){
    			globalData.addCache(dkey, JSON.stringify(dataJson.eformdesign.etables[dkey]));
    		}else if(dkey.indexOf("detail_") > -1){
    			globalData.addCache(dkey, "\""+dkey+"\":"+JSON.stringify(dataJson.eformdesign.etables[dkey]));
    		}
    	}
    	if(dataJson.eformdesign.formula)
        	formulaOperate.resumeFormulasFace(dataJson.eformdesign.formula);
    	return true;
	}
	
	/**
	 * 序列号datajson
	 */
	function serialDataJson(symbol){
		var dataJson;
		if(symbol === "main" || symbol.indexOf("tab_") > -1 || symbol.indexOf("mc_") > -1){
			dataJson = globalData.getCacheValue(symbol);
			dataJson = JSON.parse(dataJson);
		}else if(symbol.indexOf("detail_") > -1){
			var detail_datajson = JSON.parse("{"+parentWin_Main.globalData.getCacheValue(symbol)+"}");
   			dataJson = detail_datajson[symbol];
   			//明细高级定制,兼容历史模板
			if(jQuery.isEmptyObject(dataJson.seniorset) || dataJson.seniorset === "0"){
				jQuery("#openSeniorSet").attr("checked", false).attr("disabled", false).next().removeClass("jNiceCheckbox_disabled").removeClass("jNiceChecked_disabled").addClass("jNiceCheckbox");
				jQuery(".belSeniorSet").hide();
			}
		}
		initDataobj(symbol);		//初始化缓存
		var dataobj = globalData.getCacheValue(symbol);
		//恢复行列自定义属性
		if(!jQuery.isEmptyObject(dataJson.rowattrs))
			dataobj.rowattrs = dataJson.rowattrs;
		if(!jQuery.isEmptyObject(dataJson.colattrs))
			dataobj.colattrs = dataJson.colattrs;
		//恢复单元格属性
		var ecs = dataJson.ec;
		for(var i=0; i<ecs.length; i++){
			resumeCell(symbol, ecs[i]);
		}
	}
	
	//恢复一个单元格
	function resumeCell(symbol, cell_obj){
		var etype = reverseTransformerEtype(cell_obj.etype);
		if(etype === celltype.DE_TITLE || etype === celltype.DE_TAIL 
			|| etype === celltype.DE_BTN || etype === celltype.DE_CHECKALL 
			|| etype === celltype.DE_CHECKSINGLE || etype === celltype.DE_SERIALNUM){
			$(".excelHeadContent").find("[name='"+etype+"']").addClass("shortBtn_disabled").removeClass("shortBtn");
		}else if(etype === celltype.FNAME || etype === celltype.FCONTENT || etype === celltype.NNAME 
			|| etype === celltype.NADVICE || etype === celltype.SUMFNAME || etype === celltype.SUMFCONTENT){
			setFieldAttrHave(cell_obj.field,etype,1);
		}else if(etype === celltype.DETAIL){
			haveDetailMap[cell_obj.detail]="on";
		}else if(etype === celltype.TAB && symbol === "main"){
			var tab_obj = cell_obj.tab;
			for(var key in tab_obj){
				if(key.indexOf("order_") == -1)
					continue;
				var tab_id = tab_obj[key].substring(0, tab_obj[key].indexOf(","));
				var curTabIndex = parseInt(tab_id.replace("tab_",""));
    			if(curTabIndex > existMaxTabIndex)
    				existMaxTabIndex = curTabIndex;
			}
		}else if(etype === celltype.MC){
			var curMcIndex = parseInt(cell_obj.mcpoint.replace("mc_", ""));
			if(curMcIndex > existMaxMcIndex)
				existMaxMcIndex = curMcIndex;
		}
		
		var bxid = cell_obj.id;
		var enumbric;
		if(!jQuery.isEmptyObject(cell_obj.format)){
			enumbric = {};
			enumbric.n_set = cell_obj.format.numberType;
			enumbric.n_decimals = cell_obj.format.decimals;
			enumbric.n_us = cell_obj.format.thousands;
			enumbric.n_target = cell_obj.format.formatPattern;
		}
		var cell = {};
		cell.etype = etype;
		cell.id = bxid;
		cell.enumbric = enumbric;
		if(!jQuery.isEmptyObject(cell_obj.field))
			cell.efieldid = cell_obj.field;
		if(!jQuery.isEmptyObject(cell_obj.fieldtype))
			cell.efieldtype = cell_obj.fieldtype;
		if(!jQuery.isEmptyObject(cell_obj.detail) && etype === celltype.DETAIL)
			cell.edetail = cell_obj.detail;
		if(!jQuery.isEmptyObject(cell_obj.financial))
			cell.financial = cell_obj.financial;
		if(!jQuery.isEmptyObject(cell_obj.formula))
			cell.formula = cell_obj.formula;
		if(!jQuery.isEmptyObject(cell_obj.tab) && etype === celltype.TAB)
			cell.tab = cell_obj.tab;
		if(!jQuery.isEmptyObject(cell_obj.mcpoint) && etype === celltype.MC)
			cell.mcpoint = cell_obj.mcpoint;
		if(!jQuery.isEmptyObject(cell_obj.brsign) && etype === celltype.BR)
			cell.brsign = cell_obj.brsign;
		if(!jQuery.isEmptyObject(cell_obj.attrs))
			cell.attrs = cell_obj.attrs;
		if(!jQuery.isEmptyObject(cell_obj.jsonparam))
			cell.jsonparam = cell_obj.jsonparam;
		setCellProperties(bxid, etype, cell, symbol);
	}
	
	/**
	 * 恢复指定窗口，包括画布恢复sheetjson、以及字段名称图片处理等
	 */
	function resumeSheetData(symbol, excelDiv){
		var sheetJson;
		if(isDetail === "on")
			sheetJson = parentWin_Main.globalSheet.getCacheValue(symbol+"_sheet");
		else
			sheetJson = globalSheet.getCacheValue(symbol+"_sheet");
		onlyResumePanel(excelDiv, sheetJson);
    	
		var ss = excelDiv.wijspread("spread");
		var sheet = ss.getActiveSheet();
		sheet.isPaintSuspended(true);
    	var ecs = globalData.getCacheValue(symbol).ecs;
    	for(var cellid in ecs){
    		var r = cellid.split(",")[0];
			var c = cellid.split(",")[1];
			var etype = ecs[cellid].etype;
			//处理面板恢复特殊字符Bug
			var efieldid = ecs[cellid].efieldid;
			//更新节点名称
			if(etype === celltype.NNAME || etype === celltype.NADVICE){
				if(jQuery("input#wfnode"+efieldid).length > 0)
					sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).value(jQuery("input#wfnode"+efieldid).val());
			}
			//处理字段图片及名称
			if(etype === celltype.FNAME || etype === celltype.FCONTENT || etype === celltype.SUMFNAME || etype === celltype.SUMFCONTENT){
				if(judgeFieldExist(efieldid)){
					sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).value(getFieldName(efieldid));
					if(etype === celltype.FCONTENT){
						if(formulaOperate.judgeCellContainFormulaFace(symbol, cellid))
							sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).value(sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).value()+" (fx)");
						var fieldattr = parseInt(getFieldAttr(efieldid));
						if(wfinfo.layouttype === "1")	//打印模式图片变灰
							fieldattr = 1;
						//根据字段属性获取对应图片
						var bgimage = getCellFieldImage(ecs[cellid], fieldattr);
						sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).backgroundImage(bgimage);
					}else if(etype === celltype.SUMFNAME || etype === celltype.SUMFCONTENT){
						sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).value(sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).value()+"(合计)");
					}
				}else{		//不存在的字段清除内容及属性，用于formid不同时模板导入
					baseOperate.cleanCellTextFace(sheet, ecs[cellid], r, c);
				}
			}
    	}
    	sheet.isPaintSuspended(false);
    	baseOperate.bindSpreadEventFace(ss);	
    	baseOperate.spreadCellClickFace();
	}
	
	/**
	 * 根据sheetjson只恢复面板
	 */
	function onlyResumePanel(excelDiv, sheetJson){
		var ss = excelDiv.wijspread("spread");
		var sheet = ss.getActiveSheet();
		//先清除已有面板的背景图
		baseOperate.clearBgImgFace(excelDiv);
		
		sheet.isPaintSuspended(true);
       	sheetJson = JSON.parse(sheetJson);
		ss.fromJSON(sheetJson);
		ss.tabStripVisible(false);
    	sheet.isPaintSuspended(false);
	}
	
	/**
	 * 初始化窗口的缓存,删除字符串缓存，初始化JSON缓存
	 */
	function initDataobj(symbol){
		if(globalData.hasCache(symbol))
			globalData.removeCache(symbol);
		var init_dataobj = {};
		init_dataobj.ecs = {};
		globalData.addCache(symbol, init_dataobj);
	}
	
   	function replaceCellText(s){
   		s = s.replace(new RegExp("\\\\","gm"),"\\\\");
   		s = s.replace(new RegExp("\"","gm"),"\\\"");
   		//s = s.replace(new RegExp("/","gm"),"\\/");
   		//s = s.replace(new RegExp("'","gm"),"\\\'");
		s = s.replace(new RegExp("\n","gm"),"\\n");
		s = s.replace(new RegExp("\r","gm"),"\\r");
		s = s.replace(new RegExp("\t","gm"),"\\t");
		s = s.replace(new RegExp("\v","gm"),"\\v");
		s = s.replace(new RegExp("\f","gm"),"\\f");
		return s;
   	}
   	
   	function importTemplate(allJsonObj){
   		if(globalSheet)
			globalSheet.removeAllCache();
		if(globalData)
			globalData.removeAllCache();
   		jQuery(".s_module").removeClass("current");
		jQuery(".s_format").addClass("current");
		jQuery(".excelBody").show();
		jQuery(".excelHeadBG").show();
		jQuery(".excelSet").show();
		jQuery(".moduleContainer").hide();
		jQuery(".excelHeadContent").children(".s_format").show();
		//需先退出标签页编辑窗口
		if($(".tabdiv").css("display") != "none")
			tabOperate.controlTabAreaFace("hide");
    	var sheetJson;
    	var dataJson;
		for(var key in allJsonObj){
       		if(key === "sheetobj"){
       			sheetJson = JSON.stringify(allJsonObj[key]);
       		}else if(key === "dataobj"){
       			dataJson = JSON.stringify(allJsonObj[key]);
       		}
       	}
       	if(resumeLayoutCache(sheetJson, dataJson))
       		formOperate.resumeWindowFace("main");
   	}

   	
    return {
    	//保存整个模板
        saveLayoutWindowFace: function(flag){
        	return saveLayoutWindow(flag);
        },
        //保存明细窗口
        saveDetailWindowFace: function(d_identy, flag){
        	return saveDetailWindow(d_identy, flag);
        },
        //保存当前编辑的主表/标签页Sheet
        saveCurrentSheetFace: function(cur_symbol){
        	saveCurrentSheet(cur_symbol);
        },
        //恢复模板缓存
        resumeLayoutCacheFace: function(){
	    	var sheetJson = getSheetJson();
    		var dataJson = getDataJson();
        	return resumeLayoutCache(sheetJson, dataJson);
        },
        //恢复界面
        resumeWindowFace: function(symbol){
        	globalData.addCache("symbol", symbol);
        	if(symbol === "main"){		//恢复主面板时，需同时恢复标签页及多内容
	        	resetFieldAttrHaveMap();
	        	for(var key in globalData.getCache()){
	        		if(key === "main" || key.indexOf("tab_") > -1 || key.indexOf("mc_") > -1){
	        			serialDataJson(key);
	        		}
	        	}
        	}else if(symbol.indexOf("detail_") > -1){
        		serialDataJson(symbol);
        	}
        	resumeSheetData(symbol, jQuery("#excelDiv"));
        },
        //用于主界面<--->Tab页间切换，不处理dataobj
        switchWindowFace: function(symbol){
        	globalData.addCache("symbol", symbol);
        	resumeSheetData(symbol, jQuery("#excelDiv"));
        },
        //用于主面板-->多内容面板,只恢复面板内容及相应处理
        switchEditMCFace: function(mcpoint){
        	resumeSheetData(mcpoint, jQuery("#excelDiv_mc"));
        },
        //初始化指定窗口缓存
        initWindowFace: function(symbol){
        	globalData.addCache("symbol", symbol);
        	initDataobj(symbol);
        },
        //根据sheetjson只恢复面板内容
        onlyResumePanelFace: function(excelDiv, sheetJson){
        	onlyResumePanel(excelDiv, sheetJson);
        },
        //模板导入、本地缓存导入
        importTemplateFace: function(allJson, type){
        	try{
				var allJsonObj = JSON.parse(allJson);
				if(type === "impTemplate"){
					if(allJsonObj.dataobj.eformdesign.eattr.formid == $("#formid").val()){
						importTemplate(allJsonObj);
					}else{
						window.top.Dialog.confirm("导入文件中表单与当前编辑模板表单不一致,请确认是否继续？", function(){
							importTemplate(allJsonObj);
						});
					}
				}else if(type === "impCache"){
					importTemplate(allJsonObj);
				}
			}catch(e){
				window.top.Dialog.alert("导入失败，请确认");
			}
        }
        
    };
})();

/**
 * 标签页相关操作方法封装
 */
var tabOperate = (function (){
	
	//单元格插入标签页
	function insertTabPage(){
		var imgsrc = "/workflow/exceldesign/image/rightBtn/tabsmall_wev8.png";
		var sheet = getCurrentSheet();
		var c = sheet.getActiveColumnIndex();
		var r = sheet.getActiveRowIndex();
		setCellTextImage(sheet, r, c, "标签页", imgsrc);
				
		restoreCellProperties("", r+","+c);
		var _cell = {};
		var _tab = {};
		_cell.tab = _tab;
		_tab.name = "标签页";
		_tab.defshow = "0";
		_tab.style = "-1";
		_tab.areaheight = "1";
		_tab.order_1 = getNextTabSymbol() + "," + "标签页1";
		setCellProperties(r+","+c, celltype.TAB, _cell);
		baseOperate.controlDiscriptionAreaFace();
		baseOperate.autoExtendRowColFace(sheet, r, c);
	}
	
	function getNextTabSymbol(){
		existMaxTabIndex++;
		return "tab_"+existMaxTabIndex; 
	}
	
	//页面初始化绑定Tab的相关事件
	function bindTabEvent(){
		$(".tabdiv .tab_turnleft").click(function(){
			var scrollleft = $(".tabdiv .tab_head").scrollLeft() - 80;
			$(".tabdiv .tab_head").scrollLeft(scrollleft);
		});
		$(".tabdiv .tab_turnright").click(function(){
			var scrollleft = $(".tabdiv .tab_head").scrollLeft() + 80;
			var diffWidth = getTotalWidth() - $(".tabdiv .tab_head").width();
			if(scrollleft > diffWidth)
				scrollleft = diffWidth;
			$(".tabdiv .tab_head").scrollLeft(scrollleft);
		});
		$(".tabdiv .tab_add").click(function(){
			var hasTabLength = $(".tabdiv .tab_head").find(".t_sel,.t_unsel").size()+1;
			append_SingleTab(getNextTabSymbol(), "标签页"+hasTabLength, false, false);
			apply_TabStyle();
		});
		var areaheight_input = $("#areaheightspan #areaheight");
		areaheight_input.blur(function(){
			if(isNaN($(this).val())){
				$(this).val("300");
			}else{
				if($(this).val()==="" || parseInt($(this).val()) <= 0)
					$(this).val("300");
			}
		});
		$(".tabdiv #areaselect").change(function(){
			var selVal = $(this).val();
			if(selVal === "1"){
				$("#areaheightspan").hide();
			}else if(selVal === "2"){
				$("#areaheightspan").show();
				if(areaheight_input.val() === "")
					areaheight_input.val("300");
			}
		});
		$(".tabdiv .canceltab").click(function(){
			saveTabInfo();		//保存标签页相关信息
			controlTabArea("hide");
			formOperate.switchWindowFace("main");	//恢复主表
		});
		var tabstyle_obj = $("div.tabdiv #tabstyle");
		$(".tabdiv .changeskin").click(function(){
			var dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			var url = "/workflow/exceldesign/tabStyleChoose.jsp?tabstyle="+tabstyle_obj.val();
			dialog.Title = "选择标签页样式";
			dialog.Width = 1000;
			dialog.Height = 600;
			dialog.Drag = true;
			dialog.URL = url;
			dialog.callbackfun = function(paramobj,datas){
				if(datas.styleid){
					$(".tabdiv #tabstyle").val(datas.styleid);
					if(datas.divstyle)
						tabStyleCache.addCache(datas.styleid, datas.divstyle);
					apply_TabStyle();
				}
			}
			dialog.show();
		});
	}
	
	//双击主字段打开Tab编辑窗口
	function switchEditTab(maincellid){
		var dataobj_main = globalData.getCacheValue("main");
		if(!dataobj_main.ecs[maincellid] || !dataobj_main.ecs[maincellid].tab)
			return;
		controlTabArea("show");
		var tab_obj = dataobj_main.ecs[maincellid].tab;
		//生成顶部Tab页,先清空重置
		$(".tabdiv .t_area").children().remove();
		$(".tabdiv #maincellid").val(maincellid);
		if(tab_obj.name)
			$(".tabdiv #tabname").val(tab_obj.name);
		if(tab_obj.style){
			$(".tabdiv #tabstyle").val(tab_obj.style);
			add_TabStyle(tab_obj.style);		//获取标签页样式
		}
		var defshow = 0;
		var defshow_tabid = "";
		if(tab_obj.defshow)
			defshow = parseInt(tab_obj.defshow);
		if(tab_obj.areaheight){
			if(tab_obj.areaheight === "1"){
				var option = $(".tabdiv #areaselect").find("option[value='1']");
				$(".tabdiv #areaselect").selectbox("change", option.attr("value"), option.html());
			}else{
				var option = $(".tabdiv #areaselect").find("option[value='2']");
				$(".tabdiv #areaselect").selectbox("change", option.attr("value"), option.html());
				$(".tabdiv #areaheight").val(tab_obj.areaheight.split(",")[1]);
			}
		}
		for(var key in tab_obj){
			if(key.indexOf("order_") == -1)
				continue;
			var curIndex = parseInt(key.replace("order_",""))
			var value = tab_obj[key];
			var idx = value.indexOf(",");
			var isfirst = curIndex == 1 ? true : false;
			var isshow =  false;
			if(curIndex-1 == defshow){
				defshow_tabid = value.substring(0, idx);
				isshow = true;
			}
			append_SingleTab(value.substring(0, idx), value.substring(idx+1), isfirst, isshow);
		}
		setDefaultTab(defshow);
		apply_TabStyle();
		$(".tabdiv .tab_head").find("div#"+defshow_tabid).click();	//显示Tab页的Sheet
	}
	
	/**
	 * 添加单一标签项
	 * id标签页ID
	 * text标签页名称
	 * isfirst true是否第一个标签页，第一个不生成分隔线
	 * isshow true代表选中标签
	 */
	function append_SingleTab(t_id, t_text, isfirst, isshow){
		var tab_template = jQuery(".tabdiv #tab_template").clone();
		var singleTab = tab_template.find(".t_unsel");
		singleTab.attr("id", t_id).attr("title", t_text+"(ID:"+t_id+")");
		singleTab.find("span").text(t_text);
		if(isfirst)
			tab_template.find(".t_sep").remove();
		if(isshow){
			singleTab.add(singleTab.children()).each(function(){
				$(this).attr("class", $(this).attr("class").replace("_unsel", "_sel"));
			});
		}
		$(".tabdiv .t_area").append(tab_template.children());
		bindEvent_SingleTab(singleTab);
	}
	
	//保存标签页相关信息
	function saveTabInfo(){
		var dataobj_main = globalData.getCacheValue("main");
		var cellid = $(".tabdiv #maincellid").val();
		if(!dataobj_main.ecs[cellid] || !dataobj_main.ecs[cellid].tab)
			return;
		//将Tab页信息写入主表的JSON中
		var tabOperArea = jQuery(".tabdiv .tab_head").find(".t_sel,.t_unsel");
		var tab_obj = {};
		tab_obj.name = $(".tabdiv #tabname").val();
		tab_obj.style = $(".tabdiv #tabstyle").val();
		if($(".tabdiv #areaselect").val() === "1"){
			tab_obj.areaheight = "1";
		}else if($(".tabdiv #areaselect").val() === "2"){
			tab_obj.areaheight = "2,"+$(".tabdiv #areaheight").val();
		}
		tabOperArea.each(function(index){
			if($(this).find("img").size() > 0)	//默认选中
				tab_obj.defshow = index;
			tab_obj["order_"+(index+1)] = $(this).attr("id")+","+$(this).find("span").text();
		});
		dataobj_main.ecs[cellid].tab = tab_obj;
		//保存当前的标签页sheet
		formOperate.saveCurrentSheetFace(globalData.getCacheValue("symbol"));	
	}
	
	
	//================标签页样式应用 begin==========
	var tabStyleCache = new scpCache();
	function add_TabStyle(styleid){
		if(tabStyleCache.hasCache(styleid))
			return;
		jQuery.ajax({
			type: "post",
			url: "/workflow/exceldesign/tabStyleOperation.jsp",
			data: {method:"selectone", styleid:styleid},
			dataType: "JSON",
			success: function(msg){
				msg = jQuery.trim(msg);
				var stylejson = {};
				//生成自定义标签页样式
				if(msg === "none"){
					if(styleid>0)	styleid = -1;
					var sysStyle = tabPage.sysStyleFace();
					var sysDefault = tabPage.sysDefaultFace();
					jQuery.extend(true, stylejson, sysDefault, sysStyle["style"+styleid]);
				}else{
					stylejson = JSON.parse(msg);
				}
				var tabStyle = tabPage.getDivStyle_ByStyleFace(stylejson);
				tabStyleCache.addCache(styleid, tabStyle);
			}
		});
	}
	
	function apply_TabStyle(){
		var cur_styleid = $(".tabdiv #tabstyle").val();
		if(!tabStyleCache.hasCache(cur_styleid)){		//异步等待
			window.setTimeout(function(){
				apply_TabStyle();
			},100);
			return;
		}else{
			tabPage.applyDivStyleFace($(".tabdiv .tab_head"), tabStyleCache.getCacheValue(cur_styleid));
			//必须等样式应用完才能算宽度
			controlTabHeadCss();
		}
	}
	//================标签页样式应用 end==========
	
	//给LI绑定单击、双击、右键事件
	function bindEvent_SingleTab(singleTab){
		singleTab.bind({
			click: function(){
				var cur_symbol = globalData.getCacheValue("symbol");
				if(singleTab.attr("id") == cur_symbol)
					return;
				formOperate.saveCurrentSheetFace(cur_symbol);
				showTabWindow(singleTab);
			},
			dblclick: function(){
				modifyTabName(singleTab);
			}
		});
		singleTab.contextMenu({
			menu : 'tabRightMenu',
			button: 3,		//3: right click
			onPopup : function(el,e) {
				var tabOperArea = jQuery(".tabdiv .tab_head").find(".t_sel,.t_unsel");
				var curIndex = Math.floor((el.index()+1)/2);
				$('#tabRightMenu').html("");
				var menuJson = "{";
					menuJson += "\"children\": [{";
					menuJson += "\"title\" : \"重命名\",";
					menuJson += "\"icon\": \"rmodifyname\",";
					menuJson += "\"action\": \"modifyname\"";
					menuJson += "}";
				if(tabOperArea.size() > 1){
					menuJson += ",{";
					menuJson += "\"title\" : \"删除标签\",";
					menuJson += "\"icon\": \"rdeletetab\",";
					menuJson += "\"action\": \"deletetab\"";
					menuJson += "}";
				}
					menuJson += ",{";
					menuJson += "\"title\" : \"设为默认标签\",";
					menuJson += "\"icon\": \"rsetdefault\",";
					menuJson += "\"action\": \"setdefault\"";
					menuJson += "}";
				if(tabOperArea.size() > 1){
					menuJson += ",{";
					menuJson += "\"title\" : \"\"";
					menuJson += "}";
				}
				if(curIndex != 0){
					menuJson += ",{";
					menuJson += "\"title\" : \"前移\",";
					menuJson += "\"icon\": \"rmovefront\",";
					menuJson += "\"action\": \"movefront\"";
					menuJson += "}";
				}
				if(curIndex != tabOperArea.size()-1){
					menuJson += ",{";
					menuJson += "\"title\" : \"后移\",";
					menuJson += "\"icon\": \"rmovebehind\",";
					menuJson += "\"action\": \"movebehind\"";
					menuJson += "}";
				}
				if(curIndex != 0){
					menuJson += ",{";
					menuJson += "\"title\" : \"移至最前\",";
					menuJson += "\"icon\": \"rmostfront\",";
					menuJson += "\"action\": \"mostfront\"";
					menuJson += "}";
				}
				if(curIndex != tabOperArea.size()-1){
					menuJson += ",{";
					menuJson += "\"title\" : \"移至最后\",";
					menuJson += "\"icon\": \"rmostbehind\",";
					menuJson += "\"action\": \"mostbehind\"";
					menuJson += "}";
				}
				menuJson += "]}";
				menuJson = JSON.parse(menuJson); 
				$('#tabRightMenu').mac('menu', menuJson);
			},
			offset: { x: 0, y: 0 }
		}, function(action, el, pos) {
			var curIndex = Math.floor((el.index()+1)/2);
			if(action === "modifyname"){
				modifyTabName(el);
			}else if(action === "deletetab"){
				window.top.Dialog.confirm("确定要删除【"+el.find("span").text()+"】及其包含的所有内容吗？",function(){
					if(curIndex === 0)
						el.add(el.next()).remove();
					else
						el.add(el.prev()).remove();
					var tabsymbol = el.attr("id");
					deleteSingleTabCache(tabsymbol);
					if(globalData.getCacheValue("symbol") === tabsymbol){
						showTabWindow(jQuery(".tabdiv .tab_head").find(".t_sel,.t_unsel").eq(0));
					}
					if(el.find("img").size() >0 ){
						setDefaultTab(0);
					}
					controlTabHeadCss();
					var scrollleft = $(".tabdiv .tab_head").scrollLeft();
					var diffWidth = getTotalWidth() - $(".tabdiv .tab_head").width();
					if(scrollleft > diffWidth)
						scrollleft = diffWidth;
					$(".tabdiv .tab_head").scrollLeft(scrollleft);
				});
			}else if(action === "setdefault"){
				setDefaultTab(curIndex);
			}else if(action === "movefront" || action === "mostfront"){
				var tabObj = el;
				var sepObj = el.prev();
				var setIndex = 0;
				if(action === "movefront")
					setIndex = curIndex-1;
				tabObj.add(sepObj).remove();
				jQuery(".tabdiv .tab_head").find(".t_sel,.t_unsel").eq(setIndex).before(tabObj).before(sepObj);
				bindEvent_SingleTab(el);
			}else if(action === "movebehind" || action === "mostbehind"){
				var tabObj = el;
				var sepObj = el.next();
				var setIndex = jQuery(".tabdiv .tab_head").find(".t_sel,.t_unsel").size()-2;
				if(action === "movebehind")
					setIndex = curIndex;
				tabObj.add(sepObj).remove();
				jQuery(".tabdiv .tab_head").find(".t_sel,.t_unsel").eq(setIndex).after(tabObj).after(sepObj);
				bindEvent_SingleTab(el);
			}
		});
	}
	
	//显示某个Tab页内容
	function showTabWindow(singleTab){
		var tab_head = jQuery(".tabdiv .tab_head");
		var cur_sel = tab_head.find(".t_sel");
		cur_sel.add(cur_sel.children()).each(function(){
			$(this).attr("class", $(this).attr("class").replace("_sel", "_unsel"));
		});
		singleTab.add(singleTab.children()).each(function(){
			$(this).attr("class", $(this).attr("class").replace("_unsel", "_sel"));
		});
		apply_TabStyle();
		var tabsymbol = singleTab.attr("id");
		if(globalSheet.hasCache(tabsymbol+"_sheet")){		//存在则恢复Tab
			formOperate.switchWindowFace(tabsymbol);
		}else{
			//先清除已有面板的背景图
			baseOperate.clearBgImgFace();
			initSpreadGrid(jQuery("#excelDiv"), "0");		//初始化空Tab页
			formOperate.initWindowFace(tabsymbol);
		}
	}
	
	//删除某个标签页缓存、同时恢复属性
	function deleteSingleTabCache(tabsymbol){
		var ecs = globalData.getCacheValue(tabsymbol).ecs;
		//还原字段已使用、明细已添加等
		for(var cellid in ecs){
			restoreCellProperties(tabsymbol, cellid);
		}
		//移除缓存
		globalData.removeCache(tabsymbol);
		globalSheet.removeCache(tabsymbol+"_sheet");
	}
	
	//设置默认标签页
	function setDefaultTab(defindex){
		var tabOperArea = jQuery(".tabdiv .tab_head").find(".t_sel,.t_unsel");
		tabOperArea.find("img").remove();
		tabOperArea.eq(defindex).find("span").before("<img class=\"defaultimg\" src=\"/workflow/exceldesign/image/shortBtn/tab/defaulttab_wev8.png\" />");
	}
	
	//标签页重命名
	function modifyTabName(singleTab){
		var spanObj = singleTab.find("span");
		var spanText = spanObj.text();
		var t_middle = spanObj.parent();
		var inputObj = jQuery("<input type='text' style='border:1px solid #b2b7c6; width:"+(spanObj.width()+30)+"px'/>");
		spanObj.remove();
		t_middle.append(inputObj);
		inputObj.val(spanText).focus();
		
		inputObj.bind("blur",function(){
			var curVal = inputObj.val();
			if(jQuery.trim(curVal) == ""){
				//window.top.Dialog.alert("标签项名称不能为空！");
				curVal = spanText;
			}
			inputObj.remove();
			t_middle.append("<span>"+curVal+"</span>");
			singleTab.attr("title", curVal+"(ID:"+singleTab.attr("id")+")");
			controlTabHeadCss();
		});
	}
	
	//控制tab区域显示及隐藏
	function controlTabArea(flag){
		var tabarea_height = $(".tabdiv").height() + $(".tabSplitLine").height();
		if(flag === "show"){
			$("table.s_insert").find("[name='tabpage']").hide();
			$(".tabdiv").add(".tabSplitLine").show();
			$(".tabdiv .tab_bottomleft").width($(".tab_bottom").width()-$(".tabdiv .tab_bottomright").width());
			$("#excelDiv").height($("#excelDiv").height() - tabarea_height);
			$(".excelSet").height($(".excelSet").height() - tabarea_height);
			$(".tableBody").height($(".tableBody").height() - tabarea_height);
			//选中格式栏、隐藏样式栏
			$(".editor_nav .s_format").click();
			$(".editor_nav .s_style").hide();
		}else if(flag === "hide"){
			$("table.s_insert").find("[name='tabpage']").show();
			$(".tabdiv").add(".tabSplitLine").hide();
			$("#excelDiv").height($("#excelDiv").height() + tabarea_height);
			$(".excelSet").height($(".excelSet").height() + tabarea_height);
			$(".tableBody").height($(".tableBody").height() + tabarea_height);
			//显示样式栏
			$(".editor_nav .s_style").show();
		}
		var ss = jQuery("#excelDiv").wijspread("spread");
		ss._doResize();
	}
	
	//控制标签页头部样式
	function controlTabHeadCss(){
		var totalWidth = getTotalWidth();
		var maxWidth = $(".tabdiv .tab_bottomleft").width()-20-50-20;
		if(totalWidth > maxWidth){
			$(".tabdiv .tab_head").width(maxWidth);
			$(".tabdiv .tab_turnleft").css("visibility", "visible");
			$(".tabdiv .tab_turnright").css("display", "block");
		}else{
			$(".tabdiv .tab_head").width(totalWidth+"px");
			$(".tabdiv .tab_turnleft").css("visibility", "hidden");
			$(".tabdiv .tab_turnright").css("display", "none");
		}
	}
	
	function getTotalWidth(){
		var totalWidth = 35;
		$(".tabdiv .t_area").children().each(function(){
			totalWidth += $(this).width();
		});
		return totalWidth;
	}
	
	
	return {
		//单元格插入标签页
		insertTabPageFace: function(){
			insertTabPage();
		},
		//绑定标签页相应事件
		bindTabEventFace: function(){
			bindTabEvent();
		},
		//双击打开编辑标签页
		switchEditTabFace: function(maincellid){
			switchEditTab(maincellid);
		},
		//保存标签页信息写入主表的dataobj
		saveTabInfoFace: function(){
			saveTabInfo();
		},
		//控制tab区域显示及隐藏
		controlTabAreaFace: function(flag){
			controlTabArea(flag);
		},
		//根据主表cellid删除标签页所有缓存
		deleteTabCache: function(tab_obj){
			for(var key in tab_obj){
				if(key.indexOf("order_") == -1)
					continue;
				var value = tab_obj[key];
				var tabsymbol = value.substring(0, value.indexOf(","));
				deleteSingleTabCache(tabsymbol);
			}
		},
		//公式选择时获取所有存在标签项，excelUploadFormula.js公式调用
		getTabListFace: function(){
			var tabList = {};
			var maincellid_editing = "";
			if(jQuery(".excelHeadBG .tabdiv").css("display") != "none"){
				maincellid_editing = jQuery(".tabdiv #maincellid").val();
				jQuery(".tabdiv .t_area").find(".t_sel,.t_unsel").each(function(){
					tabList[jQuery(this).attr("id")] = jQuery(this).find("span").text();
				});
			}
			var main_ecs = globalData.getCacheValue("main").ecs;
			for(var item in main_ecs){
				if(main_ecs[item].etype === celltype.TAB && item !== maincellid_editing){
					var tab_obj = main_ecs[item].tab;
					for(key in tab_obj){
						if(key.indexOf("order_") > -1){
							var value = tab_obj[key];
							var idx = value.indexOf(",");
							tabList[value.substring(0, idx)] = value.substring(idx+1);
						}
					}
				}
			}
			return tabList;
		}
	}
	
})();

/**
 * 多字段相关操作方法封装
 */
var mcOperate = (function (){
	
	/**
	 * 点击插入多字段（空单元格直接弹出多内容面板、含内容单元格把字段内容自动置于多内容面板内部）
	 */
	function insertMoreContent(){
		var sheet = getCurrentSheet();
		var c = sheet.getActiveColumnIndex();
		var r = sheet.getActiveRowIndex();
		var cellid = r+","+c;
		//判断是覆盖单元格/扩充成多字段
		var dataobj = getCurrentDataObj();
		var celltext = sheet.getCell(r, c, $.wijmo.wijspread.SheetArea.viewport).text();
		var opertarget = judgeCellOperTarget(dataobj, celltext, r, c);
		var mcCellArr = new Array();
		if(opertarget === 1){
			restoreCellProperties("", cellid);
		}else if(opertarget === 2){
			var curCellObj = $.extend(true, {}, dataobj.ecs[r+","+c]);;
			delete dataobj.ecs[r+","+c];
			curCellObj.celltext = celltext;
			curCellObj.imgsrc = sheet.getCell(r, c, $.wijmo.wijspread.SheetArea.viewport).backgroundImage();
			curCellObj._style = sheet.getStyle(r, c, $.wijmo.wijspread.SheetArea.viewport);
			mcCellArr.push(curCellObj);
		}else{		//单元格已经是多字段单元格，不允许再插入
			return;
		}
		setCellToMC(sheet, r, c);
		if(opertarget === 1){
			editMoreContent(cellid, true);
		}else if(opertarget === 2){
			editMoreContent(cellid, extendOpenMcPanel);
			appendCellArrToPanel(mcCellArr);
			if(!extendOpenMcPanel)	//未打开面板，需自动保存面板信息
				confirmEdit(extendOpenMcPanel);
		}
	}
	
	/**
	 * 拖拽操作多字段
	 * opertarget:2，扩展字段为多内容字段; opertarget:3，内容追加至多字段面板
	 */
	function operMoreContent(opertarget, mcCellArr){
		var sheet = getCurrentSheet();
		var c = sheet.getActiveColumnIndex();
		var r = sheet.getActiveRowIndex();
		if(opertarget === 2){
			setCellToMC(sheet, r, c);
		}
		editMoreContent(r+","+c, extendOpenMcPanel);
		appendCellArrToPanel(mcCellArr);
		if(!extendOpenMcPanel)	//未打开面板，需自动保存面板信息
			confirmEdit(extendOpenMcPanel);
	}
	
	function setCellToMC(sheet, r, c){
		var imgsrc = "/workflow/exceldesign/image/shortBtn/morecontent/more_wev8.png";
		setCellTextImage(sheet, r, c, "多内容", imgsrc);
		setCellProperties(r+","+c, celltype.MC, {"mcpoint": getNextMcSymbol()});
		baseOperate.controlDiscriptionAreaFace();
	}
	
	function getNextMcSymbol(){
		existMaxMcIndex++;
		return "mc_"+existMaxMcIndex;
	}
	
	function editMoreContent(cellid, needShowPanel){
		var dataobj = getCurrentDataObj();
		var mcpoint = "";
		if(dataobj.ecs && dataobj.ecs[cellid] && dataobj.ecs[cellid].mcpoint)
			mcpoint = dataobj.ecs[cellid].mcpoint;
		if(mcpoint === "")
			return;
		jQuery("input#mcpoint").val(mcpoint);
		if(needShowPanel){
			//窗口定位、显示
			var location = locateMcSheet(cellid);
			jQuery("div#mcDiv").css({"top":location.split(",")[0]+"px", "left":location.split(",")[1]+"px"});
			panelControl('show');
		}
		isEditMoreContent = true;
		//面板恢复
		var isinit = globalSheet.hasCache(mcpoint+"_sheet") ? false : true;
		var mc_ss = jQuery("#excelDiv_mc").wijspread("spread");
		var mc_sheet = mc_ss.getActiveSheet();
		//窗口内容恢复
		if(isinit){
			globalData.addCache(mcpoint, {"ecs": {}});
			mc_sheet.isPaintSuspended(true);
			mc_ss.fromJSON(initJSON_moreContent);
	    	mc_sheet.isPaintSuspended(false);
	    	baseOperate.bindSpreadEventFace(mc_ss);
	    	//面板初始化时每行第二列需添加换行标示
			mc_sheet = mc_ss.getActiveSheet();
			for(var r=0; r<mc_sheet.getRowCount(); r++){
				setCellToBr(r);
			}
		}else{
			formOperate.switchEditMCFace(mcpoint);
		}
		//隐藏行头列头
		mc_sheet = mc_ss.getActiveSheet();
		mc_sheet.setColumnHeaderVisible(false);
		mc_sheet.setRowHeaderVisible(false);
	}
	
	function locateMcSheet(cellid){
		var sheet = getCurrentSheet();
		//计算绝对定位top
		var top = 0;
		var topRow = sheet.getViewportTopRow(1);		//当前显示的第一行
		var cellRow = parseInt(cellid.split(",")[0]);
		var maxTopVal = jQuery("div#excelDiv").height()-jQuery("div#mcDiv").height();
		while(true){
			top = 20;
			for(var i=topRow; i<=cellRow; i++){
				top += parseFloat(sheet.getRowHeight(i, $.wijmo.wijspread.SheetArea.rowHeader));
			}
			topRow++;
			if(top < maxTopVal || cellRow < topRow)		
				break;
			//整体上移一行再次计算
			sheet.showRow(topRow, $.wijmo.wijspread.VerticalPosition.top);
		}
		//计算绝对定位left
		var left = 0;
		var leftCol = sheet.getViewportLeftColumn(1);
		var cellCol = parseInt(cellid.split(",")[1]);
		var maxLeftVal = jQuery("div#excelDiv").width()-jQuery("div#mcDiv").width();
		while(true){
			left = 40;
			for(var i=leftCol; i<cellCol; i++){
				left += parseFloat(sheet.getColumnWidth(i, $.wijmo.wijspread.SheetArea.colHeader));
			}
			leftCol++;
			if(left < maxLeftVal || cellCol < leftCol)	
				break;
			//整体左移一列再次计算
			sheet.showColumn(leftCol, $.wijmo.wijspread.HorizontalPosition.left);
		}
		return top+","+left;
	}
	
	//追加单元格数组至多内容面板
	function appendCellArrToPanel(cellarr){
		var mc_sheet = getCurrentSheet();
		var mc_dataobj = getCurrentDataObj();
		var beginRow = countLastNullRow(mc_sheet);
		var setCol = 0;
		mc_sheet.isPaintSuspended(true);
		for(var i=0; i<cellarr.length; i++){
			var setRow = beginRow + i;
			//最后行自动扩充
			baseOperate.autoExtendRowColFace(mc_sheet, setRow, setCol);
			//根据数组信息追加单元格
			var cellObj = cellarr[i];
			delete cellObj.formula;
			var _cell = mc_sheet.getCell(setRow, setCol, $.wijmo.wijspread.SheetArea.viewport);
			_cell.value(cellObj.celltext);
			delete cellObj.celltext;
			if(cellObj.imgsrc){
				_cell.backgroundImage(cellObj.imgsrc);
				_cell.backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
				delete cellObj.imgsrc;
			}
			if(cellObj._style){		//单元格样式设置，缓存不用处理（字体、字体颜色、背景色、缩进）
				var _cellstyle = mc_sheet.getStyle(setRow, setCol, $.wijmo.wijspread.SheetArea.viewport);
                if(_cellstyle == undefined)
                    _cellstyle = new $.wijmo.wijspread.Style();
                _cellstyle.font = cellObj._style.font;
                _cellstyle.foreColor = cellObj._style.foreColor;
                _cellstyle.backColor = cellObj._style.backColor;
                _cellstyle.textIndent = cellObj._style.textIndent;
                delete cellObj._style;
			}
			delete mc_dataobj.ecs[setRow+","+setCol];
			cellObj.id = setRow+","+setCol;
			mc_dataobj.ecs[setRow+","+setCol] = cellObj;
		}
		mc_sheet.isPaintSuspended(false);
	}
	
	//计算多字段面板最后空行
	function countLastNullRow(mc_sheet){
		var c = 0;
		var notNullRow = -1;
		for(var r=0; r<mc_sheet.getRowCount(); r++){
			var celltext = mc_sheet.getCell(r, c, $.wijmo.wijspread.SheetArea.viewport).text();
			if(!!celltext)
				notNullRow = r;
		}
		notNullRow++;
		return notNullRow;
	}
	
	function confirmEdit(needHidePanel){
		//dataobj缓存不用处理，模板保存时拼接；sheetjson串重新放入缓存中
		var mcpoint = jQuery("input#mcpoint").val();
		var mc_ss = jQuery("#excelDiv_mc").wijspread("spread");
        var mc_sheetjson = JSON.stringify(mc_ss.toJSON());
        globalSheet.addCache(mcpoint+"_sheet", mc_sheetjson);
        //多字段内容拼接作为主面板单元格内容
        var mc_sheet = jQuery("#excelDiv_mc").wijspread("spread").getActiveSheet();
        var shortname = "";
        var shouldClean = true;
        for(var r=0; r<mc_sheet.getRowCount(); r++){
        	var curtext = mc_sheet.getCell(r, 0, $.wijmo.wijspread.SheetArea.viewport).text();
        	if(jQuery.trim(curtext) != ""){
        		shortname += curtext+"; "
        		shouldClean = false;
        	}
        }
        if(shouldClean){
        	cleanPanelAndCell();
        }else{
        	var sheet = jQuery("#excelDiv").wijspread("spread").getActiveSheet();
	        var ar = sheet.getActiveRowIndex();
	    	var ac = sheet.getActiveColumnIndex();
	    	sheet.getCell(ar, ac, $.wijmo.wijspread.SheetArea.viewport).value(shortname);
        }
    	//隐藏面板
    	if(needHidePanel)
    		panelControl('hide');
		isEditMoreContent = false;
		baseOperate.controlDiscriptionAreaFace();
	}
	
	function cleanPanel(){
		window.top.Dialog.confirm(_excel_reminder_6,function(){
			cleanPanelAndCell();
			panelControl('hide');
			isEditMoreContent = false;
   		});
	}
	
	function cleanPanelAndCell(){
		var mcpoint = jQuery("input#mcpoint").val();
		cleanMcPanelCache(mcpoint);
		var symbol = globalData.getCacheValue("symbol");
		var main_dataobj = globalData.getCacheValue(symbol);
		var main_sheet = jQuery("#excelDiv").wijspread("spread").getActiveSheet();
        var ar = main_sheet.getActiveRowIndex();
    	var ac = main_sheet.getActiveColumnIndex();
    	baseOperate.cleanCellTextFace(main_sheet, main_dataobj.ecs[ar+","+ac], ar, ac);
		main_sheet.setIsProtected(false);
	}
	
	function cleanMcPanelCache(mcpoint){
		if(globalData.hasCache(mcpoint)){
			var ecs = globalData.getCacheValue(mcpoint).ecs;
			for(var cellid in ecs){
				restoreCellProperties(mcpoint, cellid);
			}
		}
		//移除缓存
		globalData.removeCache(mcpoint);
		globalSheet.removeCache(mcpoint+"_sheet");
	}
	
	function panelControl(flag){
		var curSymbol = globalData.getCacheValue("symbol");
		var excelMasking = jQuery("div#excelMasking");
		var tabHeadMasking = jQuery("div#tabHeadMasking");
		var mcDiv = jQuery("div#mcDiv");
		var headArea = $(".editor_nav").find(".s_detail,.s_style,.s_module");
		var mc_hide = $(".excelHeadBG").find("td[target='mc_hide'],div[target='mc_hide']");
		var mc_splithide = $("table.s_format").find("td[target='mc_splithide']");
		if(flag === 'show'){
			var headHeight = $(".editor_nav").height()+$(".excelHeadBG").height();
			excelMasking.css({"width":$("#excelDiv").width(), "height":$("#excelDiv").height()});
			if(curSymbol === "main")
				excelMasking.css("top", headHeight);
			else if(curSymbol.indexOf("tab_") > -1){
				excelMasking.css("top", headHeight+$("div.tabdiv").height());
				tabHeadMasking.css({"height":$("div.tabdiv").height(), "top":headHeight});
				tabHeadMasking.show();
			}
			excelMasking.show();
			mcDiv.show();
			$(".editor_nav .s_format").click();
			headArea.hide();
			mc_hide.hide();
			mc_splithide.removeClass("splitTHead");
		}else if(flag === 'hide'){
			excelMasking.hide();
			tabHeadMasking.hide();
			mcDiv.hide();
			headArea.show();
			if(curSymbol.indexOf("tab_") > -1)
				$("table.s_insert").find("[name='tabpage']").hide();
			mc_hide.show();
			mc_splithide.addClass("splitTHead");
		}
		jQuery("div[name='formulaClear']").hide();
	}
	
	function setCellToBr(r){
		var mc_sheet = getCurrentSheet();
		var mc_dataobj = getCurrentDataObj();
		var c = 1;
		var imgSrc = "/workflow/exceldesign/image/shortBtn/morecontent/wrap_wev8.png";
		mc_sheet.getCell(r, c,$.wijmo.wijspread.SheetArea.viewport).backgroundImage(imgSrc);
		mc_sheet.getCell(r, c,$.wijmo.wijspread.SheetArea.viewport).backgroundImageLayout($.wijmo.wijspread.ImageLayout.Center);
		var cellobj = {};
		cellobj.etype = celltype.BR;
		cellobj.brsign = "N";
		if(mc_dataobj && mc_dataobj.ecs)
			mc_dataobj.ecs[r+","+c] = cellobj;
	}
	
	function switchCellBrSign(r){
		var mc_sheet = getCurrentSheet();
		var mc_dataobj = getCurrentDataObj();
		var c = 1;
		var brsign;
		if(mc_dataobj && mc_dataobj.ecs && mc_dataobj.ecs[r+","+c])
			brsign = mc_dataobj.ecs[r+","+c].brsign;
		else
			return;
		var imgSrc;
		if(brsign === "Y"){
			imgSrc = "/workflow/exceldesign/image/shortBtn/morecontent/wrap_wev8.png";
			mc_dataobj.ecs[r+","+c].brsign = "N";
		}else if(brsign === "N"){
			imgSrc = "/workflow/exceldesign/image/shortBtn/morecontent/wrap_hot_wev8.png";
			mc_dataobj.ecs[r+","+c].brsign = "Y";
		}
		mc_sheet.getCell(r, c,$.wijmo.wijspread.SheetArea.viewport).backgroundImage(imgSrc);
		mc_sheet.getCell(r, c,$.wijmo.wijspread.SheetArea.viewport).backgroundImageLayout($.wijmo.wijspread.ImageLayout.Center);
	}
	
	return {
		//插入多字段
		insertMoreContentFace: function(){
			insertMoreContent();
		},
		//拖拽操作多字段
		operMoreContentFace: function(opertarget, mcCellArr){
			operMoreContent(opertarget, mcCellArr);
		},
		//打开编辑多字段窗口
		editMoreContentFace: function(cellid){
			editMoreContent(cellid, true);
		},
		//窗口点击确定接口
		confirmFace: function(){
			confirmEdit(true);
		},
		//窗口点击清除接口
		cleanFace: function(){
			cleanPanel();
		},
		//删除整个多内容缓存，恢复字段
		deleteMcCache: function(mcpoint){
			cleanMcPanelCache(mcpoint);
		},
		//转换单元格为换行单元格
		setCellToBrFace: function(r){
			setCellToBr(r);
		},
		//双击/右键切换单元格换行符
		switchCellBrSignFace: function(r){
			switchCellBrSign(r);
		}
	}
})();

/**
 * 插入项 相关操作方法封装
 */
var insertOperate = (function(){
	
	function insertScriptCode(){
    	var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/exceldesign/excelUploadCode.jsp";
		dialog.Title = "插入代码";
		dialog.Width = $(window).width()-300;
		dialog.Height = $(window).height()-200;
		dialog.maxiumnable = true;
		dialog.Drag = true; 	
		dialog.URL = url;
		dialog.show();
	}
	
	function insertLink(){
		var dataobj = getCurrentDataObj();
    	var sheet = getCurrentSheet();
    	var ar = sheet.getActiveRowIndex();		///当前活动单元格
    	var ac = sheet.getActiveColumnIndex();
    	var urlParams = "";
    	if(dataobj && dataobj.ecs && dataobj.ecs[ar+","+ac]){
    		var cellobj = dataobj.ecs[ar+","+ac];
    		var etype = cellobj.etype;
    		if(etype===celltype.LINKTEXT){
    			urlParams += "?srcdeal="+cellobj.efieldtype;
    			urlParams += "&srcfile="+encodeURIComponent(cellobj.efieldid);
    		}else if(etype==="" || etype===celltype.TEXT){
			}else{
				window.top.Dialog.alert("单元格内非文本,禁止插入链接!");
				return;
			}
		}
    	var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/exceldesign/excelUploadLink.jsp"+urlParams;
		dialog.Title = "插入链接";
		dialog.Width = 500;
		dialog.Height = 340;
		dialog.Drag = true; 	
		dialog.URL = url;
		dialog.show();
		dialog.callbackfun = function (paramobj, result) {
			if(!result) return;
			var djson = result;
			var cell = sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport);
			if(cell.value() === null || cell.value() === "")
				cell.value(djson.srcfile);
		  	sheet.getCell(ar, ac,$.wijmo.wijspread.SheetArea.viewport).textDecoration($.wijmo.wijspread.TextDecorationType.Underline);
			var celljson = {};
			celljson.efieldid = djson.srcfile;
			celljson.efieldtype = djson.srcdeal;
			setCellProperties(ar+","+ac, celltype.LINKTEXT, celljson);
			baseOperate.autoExtendRowColFace(sheet, ar, ac);
		}
	}
	
	function portalDesign(target){
		if(target == "insert" && parseInt(wfinfo.modeid) <= 0){
			window.top.Dialog.alert("模板需先保存，才允许插入门户元素！");
			return;
		}
		var dataobj = getCurrentDataObj();
		var sheet = getCurrentSheet();
		var r = sheet.getActiveRowIndex();
		var c = sheet.getActiveColumnIndex();
		var cellid = r+","+c;
		
		var hpid = "";
		if(target == "setting" && dataobj.ecs[cellid].jsonparam && dataobj.ecs[cellid].jsonparam.hpid)
			hpid = dataobj.ecs[cellid].jsonparam.hpid;
		var url = "/homepage/maint/HomepageForWorkflow.jsp?isSetting=true&hpid="+hpid;
		var paramStr = "&wfid="+wfinfo.wfid+"&nodeid="+wfinfo.nodeid+"&formid="+wfinfo.formid
				+"&isbill="+wfinfo.isbill+"&moduleid="+wfinfo.modeid+"&layouttype="+wfinfo.layouttype;
		paramStr += "&layoutname="+encodeURI(jQuery("#workflowname").val()+"-"+jQuery("#layoutname").val());
		if(window.console)	console.log("门户元素链接:"+url+paramStr);
		
		var dialog=new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Model=true;
		dialog.maxiumnable=true;
		dialog.Width = $(window.top).width()-60;
		dialog.Height = $(window.top).height()-80;
		dialog.hideDraghandle = false;
		dialog.URL= url+paramStr;
		dialog.Title="设置元素";
		dialog.callbackfun = function(paramobj, datas){
			if(target == "insert"){
				restoreCellProperties("", cellid);
				baseOperate.autoExtendRowColFace(sheet, r, c);
			}
			var imgsrc = "/workflow/exceldesign/image/controls/portal_wev8.png";
			var celltext = "门户元素";
			if(!!datas.elements)
				celltext += " ("+datas.elements+")";
			setCellTextImage(sheet, r, c, celltext, imgsrc);
			
			setCellProperties(cellid, celltype.PORTAL, {"jsonparam": datas});
			baseOperate.controlDiscriptionAreaFace();
		}
		dialog.CancelEvent = function(){
	 		dialog.innerFrame.contentWindow.closeDialogCallback();
		};
		dialog.show();
	}
	
	function deletePortalElm(hpid){
		/*$.post(
			"/homepage/maint/HomepageForWorkflowOperation.jsp",
			{method:"delHpInfo", hpid:hpid},
			function (data) {
			}
		);*/
	}
	
	function iframeDesign(target){
		var dataobj = getCurrentDataObj();
		var sheet = getCurrentSheet();
		var r = sheet.getActiveRowIndex();
		var c = sheet.getActiveColumnIndex();
		var cellid = r+","+c;
		var url = "/workflow/exceldesign/setIframe.jsp?firstParam=1";
		if(target == "setting" && dataobj.ecs[cellid].jsonparam){
			var jsonparam = dataobj.ecs[cellid].jsonparam;
			for(var key in jsonparam){
				url += "&"+key+"="+encodeURIComponent(jsonparam[key]);
			}
		}
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "插入Iframe区域";
		dialog.Width = 700;
		dialog.Height = 500;
		dialog.maxiumnable = false;
		dialog.URL = url;
		dialog.callbackfun = function (paramobj, datas) {
			if(target == "insert"){
				restoreCellProperties("", cellid);
				baseOperate.autoExtendRowColFace(sheet, r, c);
			}
			var imgsrc = "/workflow/exceldesign/image/controls/iframeArea_wev8.png";
			setCellTextImage(sheet, r, c, "Iframe区域", imgsrc);
			
			setCellProperties(cellid, celltype.IFRAME, {"jsonparam":datas});
		};
		dialog.show();
	}
	
	function scanCodeDesign(target){
		var dataobj = getCurrentDataObj();
		var sheet = getCurrentSheet();
		var r = sheet.getActiveRowIndex();
		var c = sheet.getActiveColumnIndex();
		var cellid = r+","+c;
		var url = "/workflow/exceldesign/setScanCode.jsp?formid="+wfinfo.formid+"&isbill="+wfinfo.isbill;
		if(target == "setting" && dataobj.ecs[cellid].jsonparam){
			var jsonparam = dataobj.ecs[cellid].jsonparam;
			for(var key in jsonparam){
				url += "&"+key+"="+jsonparam[key];
			}
		}
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "插入二维/条形码";
		dialog.Width = 700;
		dialog.Height = 500;
		dialog.maxiumnable = false;
		dialog.URL = url;
		dialog.callbackfun = function (paramobj, datas) {
			if(target == "insert"){
				restoreCellProperties("", cellid);
				baseOperate.autoExtendRowColFace(sheet, r, c);
			}
			if(datas.codetype){
				var setText = datas.codetype=="1" ? "二维码" : "条形码";
				var imgsrc = "/workflow/exceldesign/image/controls/scanCode_"+datas.codetype+"_wev8.png";
				setCellTextImage(sheet, r, c, setText, imgsrc);
			}
			setCellProperties(cellid, celltype.SCANCODE, {"jsonparam":datas});
		};
		dialog.show();
	}
	
	return {
		//插入代码块
		insertScriptCodeFace: function(){
			insertScriptCode();
		},
		//插入链接
		insertLinkFace: function(){
			insertLink();
		},
		//门户元素设置(target：insert-插入，setting-设置)
		portalDesignFace: function(target){
			portalDesign(target);
		},
		//删除门户元素
		deletePortalElmFace: function(hpid){
			deletePortalElm(hpid);
		},
		//iframe区域设置(target：insert-插入，setting-设置)
		iframeDesignFace: function(target){
			iframeDesign(target);
		},
		//扫描码设置(target：insert-插入，setting-设置)
		scanCodeDesignFace: function(target){
			scanCodeDesign(target);
		}
	}
})();

/**
 * 公式方法封装、改造，支持插入/删除行列位移
 * 公式信息全部存储formulaObj中，结构改为key-srcformulatxt，且srcformulatxt串单元格必须带标示(main.)
 * 单元格dataobj[cellid].formula值只放"y"，标志单元格设置有公式
 */
var formulaOperate = (function(){
	
	//模板打开恢复公式,需处理历史公式数据
	function resumeFormulas(formulaJson){
		for(var __key in formulaJson){
			var formulaStr = formulaJson[__key].srcformulatxt;
			var formulaStr_manage = manageHistorySrcFormula(__key, formulaStr);
			if(window.console) console.log("resumeFormulas: "+__key+" | "+formulaStr+" | "+formulaStr_manage);
    		formulaObj.setOneFormula(__key, formulaStr_manage);
    	}
	}
	
	//历史数据处理，针对改造前公式src串含未带标示D4单元格信息替换成symbol.D4,区域不处理
	//正则表达式-反向否定预查，(?<!\.)写的报错，why？。。。故使用占位符替换
	function manageHistorySrcFormula(__key, formulaStr){
		var reg = /((main|tab_\d+|detail_\d+)\.)?[a-zA-Z]+\d+:((main|tab_\d+|detail_\d+)\.)?[a-zA-Z]+\d+|((main|tab_\d+|detail_\d+)\.)?[a-zA-Z]+\d+/g;
		var add_symbol = __key.substring(0,__key.indexOf(".")).toLowerCase();
		var cellrang = formulaStr.match(reg);
		if(cellrang != null){
			var cellrang_new = new Array();
			for(var i = 0; i < cellrang.length; i++){
				formulaStr = formulaStr.replace(cellrang[i], "placeholder_"+i);
				if(cellrang[i].indexOf(".") > -1)
					cellrang_new.push(cellrang[i]);
				else
					cellrang_new.push(add_symbol+"."+cellrang[i]);
			}
			for(var i = 0; i < cellrang_new.length; i++){
				formulaStr = formulaStr.replace("placeholder_"+i, cellrang_new[i]);
			}
		}
		return formulaStr;
	}
	
	//模板保存拼接公式，生成formulatxt、cellrange、destcell等信息
	function saveFormulas(){
		var reg = /(MAIN|TAB_\d+|DETAIL_\d+)\.[A-Z]+\d+/g;
		var formulas = formulaObj.getFormulas();
		//先预览/导出模板，再点模板保存。多次公式保存会异常，新建公式对象避免此问题
		var formulaObj_new = new formulaEncapsulation();
		for(var __key in formulas){
			var formulaStr = formulas[__key].trim();
			var _formulaJson = {};
			_formulaJson.srcformulatxt = formulaStr;
			_formulaJson.formulatxt = replaceFormula(formulaStr);
			_formulaJson.cellrange = _formulaJson.formulatxt.match(reg);
			_formulaJson.destcell = __key.replace("FORMULA", "");
			//入库json仍需要destfield，用于计算赋值字段为只读时入库保存
			_formulaJson.destfield = calculateDestfield(_formulaJson.destcell);
			formulaObj_new.setOneFormula(__key, _formulaJson);
		}
		return JSON.stringify(formulaObj_new.getFormulas());
	}
	
	//根据公式赋值单元格计算赋值字段ID
	function calculateDestfield(destcell){
		var destfield = "";
		try{
			var symbol = destcell.split(".")[0].toLowerCase();
			var cellletter = destcell.split(".")[1];
			var row = parseInt(cellletter.match(/\d+$/)[0])-1;
			var col = cellletter.match(/^[a-zA-Z]+/)[0];
			col = parseInt(morecharToInt(col))-1;
			var cellid = row+","+col;
			if(symbol === "main" || symbol.indexOf("tab_") > -1){
				var dataobj = globalData.getCacheValue(symbol);
				if(dataobj && dataobj.ecs && dataobj.ecs[cellid] && dataobj.ecs[cellid].etype == celltype.FCONTENT)
					destfield = dataobj.ecs[cellid].efieldid;
			}else if(symbol.indexOf("detail_") > -1){
				var detailjson = JSON.parse("{"+globalData.getCacheValue(symbol)+"}");
				detailjson = detailjson[symbol];
				if(detailjson && detailjson.ec)
				for(var len = 0; len<detailjson.ec.length; len++){
					var ecObj = detailjson.ec[len];
					if(ecObj.id == cellid && ecObj.etype === transformerEtype(celltype.FCONTENT)){
						destfield = ecObj.field;
						break;
					}
				}
			}
		}catch(e){}
		return destfield;
	}
	
	//弹窗插入公式
	function openFormulaWin(){
		var _dobj = getCurrentDataObj();
		var sheet = getCurrentSheet();
      	var ar = sheet.getActiveRowIndex();		///当前活动单元格
      	var ac = sheet.getActiveColumnIndex();
      	var cellletter = getColHeader(sheet, ac)+(ar+1);
		if(_dobj.ecs && _dobj.ecs[ar+","+ac] && _dobj.ecs[ar+","+ac].etype === celltype.FCONTENT){
		}else{
			window.top.Dialog.alert("非字段单元格，不支持公式设置！");
			return;
		}
       	isEditFormulaing = true;
       	
      	var _formulaObj = isDetail==="on" ? parentWin_Main.formulaObj : formulaObj;
		var curSymbol = globalData.getCacheValue("symbol").toUpperCase();
		var __key = curSymbol+".FORMULA"+cellletter;
		var paramtxt = ""
		if(_formulaObj.getFormulas() && _formulaObj.getOneFormula(__key))
			paramtxt = _formulaObj.getOneFormula(__key);
		paramtxt = encodeURIComponent(paramtxt)
		
		var formula_dialog = new window.top.Dialog();
		formula_dialog.currentWindow = window;
		window.top.formula_dialog = formula_dialog;
		var url = "/workflow/exceldesign/excelUploadFormula.jsp?isDetail="+isDetail+"&detailIdenty="+detailIdenty+"&paramtxt="+paramtxt;
		formula_dialog.Title = "插入公式";
		formula_dialog.Width = 630;
		formula_dialog.Height = 550;
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
			sheet = getCurrentSheet();
			var dataObj = getCurrentDataObj();
			var formulaStr = jQuery.trim(result.formula);
			//公式清除
			if(!formulaStr){
				_formulaObj.delOneFormula(__key);
				controlFormulaSign(sheet, ar, ac, "remove");
				if(dataObj.ecs[ar+","+ac].formula)
					delete dataObj.ecs[ar+","+ac].formula;
				return;
			}
			//公式保存
			try{
				sheet.isPaintSuspended(true);
				_formulaObj.setOneFormula(__key, formulaStr);
				controlFormulaSign(sheet, ar, ac, "add");
				sheet.isPaintSuspended(false);
				//理论上明细点击关闭应去掉明细设置的公式，暂未实现
				//if(isDetail === "on")
				//	detailFormulaTempAry.push(__key);
				setCellProperties(ar+","+ac,"",{"formula":"y"});
			}catch(e){
				window.top.Dialog.alert(e.message);
			}
		}
	}
	
	//插入/删除行列，需对公式位移
	function formulaOffset_changeRC(rc, opreation, activenum, movenum){
   		var symbol = globalData.getCacheValue("symbol")+".";
   		var	keyHead = symbol.toUpperCase()+"FORMULA";
   		var reg = eval("/"+symbol+"[A-Z]+\\d+/g");
   		
   		var _formulaObj = isDetail==="on" ? parentWin_Main.formulaObj : formulaObj;
   		var _formulaObj_new = new formulaEncapsulation();
   		for(var __key in _formulaObj.getFormulas()){
   			var formulaStr = jQuery.trim(_formulaObj.getOneFormula(__key));
   			_formulaObj.delOneFormula(__key);
   			var __key_offset = __key;
   			if(__key.indexOf(keyHead) > -1){	//__key需位移
   				var cellletter = __key.replace(keyHead, "");
   				var cellletter_offset = getCellletter_offset(rc, opreation, activenum, movenum, cellletter);
   				__key_offset = keyHead+cellletter_offset;
   			}
   			var formulaStr_offset = formulaStr;
   			if(formulaStr.match(reg)){	//公式串需位移
   				//需使用占位符两次替换，避免(B18,B19)增加行时被替换成(B20,B20)
   				var cellrange = formulaStr.match(reg);
   				var cellrange_new = new Array();
   				for(var i=0; i<cellrange.length; i++){
   					formulaStr_offset = formulaStr_offset.replace(cellrange[i], "placeholder_"+i);
   					var cellletter = cellrange[i].replace(symbol, "");
   					var cellletter_offset = symbol + getCellletter_offset(rc, opreation, activenum, movenum, cellletter);
   					cellrange_new.push(cellletter_offset);
   				}
   				for(var i=0; i<cellrange_new.length; i++){
   					formulaStr_offset = formulaStr_offset.replace("placeholder_"+i, cellrange_new[i]);
   				}
   			}
   			_formulaObj_new.setOneFormula(__key_offset, formulaStr_offset);
   		}
   		jQuery.extend(true, _formulaObj.getFormulas(), _formulaObj_new.getFormulas());
	}
	
	//公式串位移计算
	function getCellletter_offset(rc, opreation, activenum, movenum, cellletter){
		var row = parseInt(cellletter.match(/\d+$/)[0]);
		var col = cellletter.match(/^[a-zA-Z]+/)[0];
		col = morecharToInt(col);
		if(rc == "row" && row > activenum){
        	if(opreation == "insert"){
        		row = row+movenum;
        	}else if(opreation == "delete"){
        		row = row-movenum;
        	}
        }else if(rc == "col" && col > activenum){
        	if(opreation == "insert"){
        		col = col+movenum;
        	}else if(opreation == "delete"){
        		col = col-movenum;
        	}
        }
        col = moreIntToChar(parseInt(col)-1);
        if(window.console)	console.log(rc+"-"+opreation+"-"+activenum+"-"+movenum+" | "+cellletter+"  -->  "+col+row);
        return col+row;
	}

	//删除单元格需删除公式
	function deleteCellFormula(cellid, symbol){
		if(typeof symbol === "undefined" || !symbol)
			symbol = globalData.getCacheValue("symbol");
		var r = parseInt(cellid.split(",")[0]);
		var c = parseInt(cellid.split(",")[1]);
		var sheet = getCurrentSheet();
		var cellletter = getColHeader(sheet, c)+(r+1);
		var __key = symbol.toUpperCase()+".FORMULA"+cellletter;
		var _formulaObj = isDetail==="on" ? parentWin_Main.formulaObj : formulaObj;
		_formulaObj.delOneFormula(__key);
		var dataObj = globalData.getCacheValue(symbol);
		if(dataObj.ecs[cellid] && dataObj.ecs[cellid].formula)
			delete dataObj.ecs[cellid].formula;
	}
	
	//公式选择时绑定表格事件
	function bindSpreadEvent4Formula(spread){
		var sheet = spread.getActiveSheet();
		sheet.bind($.wijmo.wijspread.Events.SelectionChanged,function(event,data){
	        var sels = sheet.getSelections();
	        var restr = "";
	        if(sels && sels.length > 1){
	        	for(var i=0;i<sels.length;i++){
	        		var rc = sels[i].rowCount;
	        		var cc = sels[i].colCount;
	        		if(rc > 1 || cc > 1){
	        			var ar = sels[i].row;
	        			var ac = sels[i].col;
		       			if(ac < 1) ac = 0;
		       			if(ar < 1) ar = 0;
		       			if(!!restr){
			       			restr += ","+getColHeader(sheet, ac)+(ar+1);
			       			restr += ":"+getColHeader(sheet, ac+cc-1)+(ar+rc);
		       			}else{
		       				restr = getColHeader(sheet, ac)+(ar+1);
			       			restr += ":"+getColHeader(sheet, ac+cc-1)+(ar+rc);
			       		}
	        		}else{
	        			var ar = sels[i].row;
	        			var ac = sels[i].col;
	        			if(!!restr)
	        				restr += ","+getColHeader(sheet, ac)+(ar+1);
	        			else
	        				restr = getColHeader(sheet, ac)+(ar+1);
	        		}
	        	}
	        }else if(sels && sels.length == 1){
	        	var rc = sels[0].rowCount;
	       		var cc = sels[0].colCount;
	       		if(rc > 1 || cc > 1){
	       			ac = sels[0].col;
	       			ar = sels[0].row;
	       			if(ac < 1) ac = 0;
	       			if(ar < 1) ar = 0;
	       			restr = getColHeader(sheet, ac)+(ar+1);
	       			restr += ":"+getColHeader(sheet, ac+cc-1)+(ar+rc)
	       		}else{
	       			var ar = sels[0].row;
	       			var ac = sels[0].col;
	   				restr = getColHeader(sheet, ac)+(ar+1);
	       		}
	        }
	        $(window.top.formula_dialog.innerDoc).find("#selectcellTxt").val(restr);
	    });
	}
	
	//分析单元格区域
	function analyzeCellRange(cellrang){
		var startcell = cellrang.split(":")[0];
		var endcell = cellrang.split(":")[1];
		var start_col = startcell.match(/^[a-zA-Z]+/)[0];
		start_col = morecharToInt(start_col)-1;
		var start_row = parseInt(startcell.substring(startcell.match(/^[a-zA-Z]+/)[0].length,startcell.length))-1;
		var end_col = endcell.match(/^[a-zA-Z]+/)[0];
		end_col = morecharToInt(end_col)-1;
		var end_row = parseInt(endcell.substring(endcell.match(/^[a-zA-Z]+/)[0].length,endcell.length))-1;
		var s_cell = 0;
		var e_cell = 0;
		if(parseInt(start_row) + parseInt(start_col) < parseInt(end_row) + parseInt(end_col)){
			s_cell = start_row + "," + start_col;
			e_cell = end_row + "," + end_col;
		}else{
			s_cell = end_row + "," + end_col;
			e_cell = start_row + "," + start_col;
		}
		return s_cell+";"+e_cell;
	}
	
	//增加、删除单元格(fx)标示
	function controlFormulaSign(sheet, r, c, operflag){
		var celltext = sheet.getCell(r, c, $.wijmo.wijspread.SheetArea.viewport).value();
		if(operflag === "add"){
			if(!!celltext){
				if(celltext.length>5 && celltext.substring(celltext.length-5)==" (fx)"){
				}else{
					celltext = celltext+" (fx)";
				}
			}else{
				celltext = " (fx)";
			}
		}else if(operflag === "remove"){
			if(celltext.length>5 && celltext.substring(celltext.length-5)==" (fx)")
				celltext = celltext.substring(0, celltext.length-5);
		}
		sheet.getCell(r, c, $.wijmo.wijspread.SheetArea.viewport).value(celltext);
	}

	//判断单元格是否包含公式
	function judgeCellContainFormula(symbol, cellid){
		if(typeof symbol === "undefined" || !symbol)
			symbol = globalData.getCacheValue("symbol");
		var r = parseInt(cellid.split(",")[0]);
		var c = parseInt(cellid.split(",")[1]);
		var cellletter = moreIntToChar(c)+(r+1);
		var __key = symbol.toUpperCase()+".FORMULA"+cellletter;
		var _formulaObj = isDetail==="on" ? parentWin_Main.formulaObj : formulaObj;
		return __key in _formulaObj.getFormulas();
	}
	
	//字母转数字
	function morecharToInt(value){
		var rtn = 0;
		var powIndex = 0;
		for (var i = value.length - 1; i >= 0; i--){
       		var tmpInt = value[i].charCodeAt();
       		tmpInt -= 64;
			rtn += Math.pow(26, powIndex) * tmpInt;
            powIndex++;           
       	}
		return rtn;
	}
	
	//数字转字母(最多支持到两位ZZ)
	function moreIntToChar(value){
		var colname = "";
		var first = Math.floor(value/26);
		var second = value%26;
		if(first > 0)
			colname += String.fromCharCode(64 + first);
		colname += String.fromCharCode(65 + second);
		return colname;
	}
	
	//获取列头
	function getColHeader(sheet, col){
		var colheader = sheet.getValue(0, col, $.wijmo.wijspread.SheetArea.colHeader);
		if(colheader.indexOf("%") > -1){
			if(colheader.indexOf(" (") > -1)
				return colheader.substring(0, colheader.indexOf(" ("));
		}else{
			return colheader;
		}			
	}
	
	//公式字符串替换
	function replaceFormula(formulatxt){
		formulatxt = formulatxt.replace(/main./ig, "MAIN.");
		formulatxt = formulatxt.replace(/(tab_)(\d)+\./ig, "TAB_$2.");
		formulatxt = formulatxt.replace(/(detail_)(\d)+\./ig, "DETAIL_$2.");
		formulatxt = formulatxt.replace(/SUM(\s)*\(/ig, "EXCEL_SUM(");
		formulatxt = formulatxt.replace(/AVERAGE(\s)*\(/ig, "EXCEL_AVERAGE(");
		formulatxt = formulatxt.replace(/ABS(\s)*\(/ig, "EXCEL_ABS(");
		formulatxt = formulatxt.replace(/ROUND(\s)*\(/ig, "EXCEL_ROUND(");
		formulatxt = formulatxt.replace(/MAX(\s)*\(/ig, "EXCEL_MAX(");
		formulatxt = formulatxt.replace(/MIN(\s)*\(/ig, "EXCEL_MIN(");
		formulatxt = formulatxt.replace(/IF(\s)*\(/ig, "EXCEL_IF(");
		return formulatxt;
	}
	
	
	return {
		//模板打开恢复公式
		resumeFormulasFace: function(formulaStr){
			resumeFormulas(formulaStr);
		},
		//模板保存拼接公式
		saveFormulasFace: function(){
			return saveFormulas();
		},
		//插入公式
		openFormulaWinFace: function(){
			openFormulaWin();
		},
		//插入/删除行列，公司需相应位移
		formulaOffset_changeRCFace: function(rc, opreation, activenum, movenum){
			formulaOffset_changeRC(rc, opreation, activenum, movenum);
		},
		//删除单元格需删除公式
		deleteCellFormulaFace: function(cellid, symbol){
			deleteCellFormula(cellid, symbol);
		},
		//公式选择时绑定表格事件
		bindSpreadEvent4FormulaFace: function(spread){
			bindSpreadEvent4Formula(spread);
		},
		//分析单元格区域
		analyzeCellRangeFace: function(cellrang){
			return analyzeCellRange(cellrang);
		},
		//判断单元格是否包含公式
		judgeCellContainFormulaFace: function(symbol, cellid){
			return judgeCellContainFormula(symbol, cellid);
		},
		//数字转字母
		moreIntToCharFace: function(value){
			return moreIntToChar(value);
		}
	}
	
})();

/**
 * 明细高级定制相关操作方法封装
 */
var detailOperate = (function(){
	
	function doInsertDetail(action){
		var imgsrc = "/workflow/exceldesign/image/shortBtn/detail/detailTable_wev8.png";
		var sheet = getCurrentSheet();
		var r = sheet.getActiveRowIndex();
		var c = sheet.getActiveColumnIndex();
		setCellTextImage(sheet, r, c, "明细表"+action.split("_")[1], imgsrc);
		restoreCellProperties("", r+","+c);
		setCellProperties(r+","+c, celltype.DETAIL, {"edetail":action});
		haveDetailMap[action]="on";
		baseOperate.controlDiscriptionAreaFace();
		baseOperate.autoExtendRowColFace(sheet, r, c);
	}
	
	function openDetailWin(edetail){
		var dlg=new window.top.Dialog();
		dlg.currentWindow = window;
		dlg.Model=true;
		dlg.maxiumnable=true;
		dlg.Width = $(window.top).width()-60;
		dlg.Height = $(window.top).height()-80;
		dlg.hideDraghandle = true;
		
		var detaillimit=$("input[name='detailgroupattr"+(parseInt(edetail.replace('detail_',''))-1)+"']").val();
		var detailNum = getDetailNum();
		var url="/workflow/exceldesign/excelMain.jsp?isDetail=on&d_identy="+edetail+"&d_num="+detailNum+
				"&formid="+$("#formid").val()+"&isbill="+$("#isbill").val()+
				"&nodeid="+$("#nodeid").val()+"&layouttype="+$("#layouttype").val()+"&detaillimit="+detaillimit;
		dlg.URL= url;
		dlg.Title="新版流程模式设计器";
		dlg.show();
	}

   	function addDetailRowMark(obj){
    	var sheet = getCurrentSheet();
    	var sel = sheet.getSelections();
    	var objname = $(obj).attr("name");
    	if(objname === celltype.DE_TITLE && sheet.getActiveRowIndex() == 0){
    		window.top.Dialog.alert("第一行之前不能加入表头标识！");
    		return;
    	}else if(objname === celltype.DE_TAIL && sheet.getActiveRowIndex() == sheet.getRowCount()-1){
    		window.top.Dialog.alert("最后一行之后不能加入表尾标识！");
    		return;
    	}
    	var insertRowIndex = sheet.getActiveRowIndex();
    	if(objname === celltype.DE_TAIL){
    		var _span = sheet.getSpan(sheet.getActiveRowIndex(), sheet.getActiveColumnIndex(), $.wijmo.wijspread.SheetArea.viewport);
    		if(_span)
    			insertRowIndex = insertRowIndex+(_span.rowCount-1);
    		insertRowIndex++;
    	}
    	sheet.isPaintSuspended(true);
    	baseOperate.insertDetailRowMarkFace(insertRowIndex);
    	var canMerge = true;	//合并三行，第二行插表头标识，则新插入的行存在合并单元格，addSpan会导致设计器整体失效
    	for(var i=0; i<sheet.getColumnCount(); i++){
    		if(sheet.getSpan(insertRowIndex, i, $.wijmo.wijspread.SheetArea.viewport)){
    			canMerge = false;
    			break;
    		}
    	}
    	if(canMerge){
    		//合并单元格、添加样式及文字
	   		sheet.addSpan(insertRowIndex, 0, 1, sheet.getColumnCount());
	   		var cellvalue = (objname === celltype.DE_TITLE) ? "表头标识" : "表尾标识";
	   		setRowMarkStyle(sheet, insertRowIndex, cellvalue);
	   		//设置单元格属性
   			setCellProperties(insertRowIndex+",0", objname);
   			$(obj).addClass("shortBtn_disabled").removeClass("shortBtn");
   		}
    	sheet.setSelection(insertRowIndex, 0, 1, sheet.getColumnCount());
   		sheet.isPaintSuspended(false);
   	}
   	
   	function setRowMarkStyle(sheet, row, cellvalue){
   		sheet.getCell(row, 0, $.wijmo.wijspread.SheetArea.viewport).value(cellvalue);
   		var _style = new $.wijmo.wijspread.Style();
		_style.backColor = "#eeeeee";
   		sheet.setStyle(row, 0, _style, $.wijmo.wijspread.SheetArea.viewport);
   	}
   	
   	function addDetailCellMark(obj){
		var objname = $(obj).attr("name");
		var imgsrc = "/workflow/exceldesign/image/shortBtn/detail/"+objname+"_wev8.png";
		var sheet = getCurrentSheet();
		var r = sheet.getActiveRowIndex();
		var c = sheet.getActiveColumnIndex();
		restoreCellProperties("", r+","+c);
		var cvalue = "";
		if(objname === celltype.DE_CHECKALL)
			cvalue = "全选";
		else if(objname === celltype.DE_CHECKSINGLE)
			cvalue = "选中";
		else if(objname === celltype.DE_SERIALNUM)
			cvalue = "序号";
		setCellTextImage(sheet, r, c, cvalue, imgsrc);
		//设置单元格属性；
   		setCellProperties(r+","+c, objname);
   		$(obj).addClass("shortBtn_disabled").removeClass("shortBtn");
   		baseOperate.autoExtendRowColFace(sheet, r, c);
		sheet.setSelection(r, c, 1, 1);		//解决添加后直接删除无效问题
   	}
   	
   	function clickOpenSeniorSet(){
   		if(jQuery("#openSeniorSet").attr("checked")){
   			jQuery("#openSeniorSet").attr("checked",false).next().removeClass("jNiceChecked");
   			var allowInit = false;
   			var mark = getHeadTailMark();
   			var exist = existSeniorElements();
   			if(!exist && mark.headRow && mark.tailRow && mark.tailRow-mark.headRow === 2)
   				allowInit = true;
   			
   			var dialog = new window.top.Dialog();
			dialog.currentWindow = window;
			dialog.Title = "信息确认";
			dialog.Width = 460;
			dialog.Height = 200;
			dialog.Drag = true; 	
			dialog.URL = "/workflow/exceldesign/seniorSetConfirm.jsp?allowInit="+allowInit;
			dialog.callbackfun = function(paramobj, retstr){
				retstr = jQuery.trim(retstr);
				if(!!retstr && retstr === "true")		//自动初始化
					autoExtendToSenior(mark);
				jQuery("#openSeniorSet").attr("checked",true).next().addClass("jNiceChecked");
				jQuery(".belSeniorSet").show();
			};
			dialog.show();
   		}else{
   			jQuery(".belSeniorSet").hide();
   		}
   	}
   	
   	//针对历史单行模板自动初始化行头、序号、合计等
   	function autoExtendToSenior(mark){
   		var sheet = getCurrentSheet();
   		var dataobj = getCurrentDataObj();
   		sheet.isPaintSuspended(true);
   		//插两列
   		sheet.setSelection(0, 0, 1, 2);
   		baseOperate.insertRowColsFace("col");
   		//处理第一行
   		var firstCellStyle = sheet.getStyle(0, 2, $.wijmo.wijspread.SheetArea.viewport);
   		if(firstCellStyle == null)	firstCellStyle = new $.wijmo.wijspread.Style();
   		var firstCellStyleNew = firstCellStyle.clone();
   		firstCellStyleNew.backgroundImage = null;
   		sheet.setStyle(0, 0, firstCellStyleNew.clone(), $.wijmo.wijspread.SheetArea.viewport);
   		setCellProperties("0,0", "");
   		sheet.setStyle(0, 1, firstCellStyleNew.clone(), $.wijmo.wijspread.SheetArea.viewport);
   		setCellProperties("0,1", "");
   		//处理表头行,合并单元格情况只取合并源单元格样式
   		var headFirstCellRow = mark.headRow-1;
   		var headFirstCellCol = 2;
   		var _span = sheet.getSpan(headFirstCellRow, headFirstCellCol, $.wijmo.wijspread.SheetArea.viewport);
   		if(_span){	//合并单元格取源
   			headFirstCellRow = _span.row;
   			headFirstCellCol = _span.col;
   		}
   		var headRow = mark.headRow-1;
   		var headCellStyle = sheet.getStyle(headFirstCellRow, headFirstCellCol, $.wijmo.wijspread.SheetArea.viewport);
   		if(headCellStyle == null)	headCellStyle = new $.wijmo.wijspread.Style();
   		sheet.setSelection(headRow, 0, 1, 1);
   		sheet.setStyle(sheet.getActiveRowIndex(), sheet.getActiveColumnIndex(), headCellStyle.clone(), $.wijmo.wijspread.SheetArea.viewport);
   		addDetailCellMark(jQuery("div[name='de_checkall']"));
   		sheet.setSelection(headRow, 1, 1, 1);
   		sheet.setStyle(sheet.getActiveRowIndex(), sheet.getActiveColumnIndex(), headCellStyle.clone(), $.wijmo.wijspread.SheetArea.viewport);
   		sheet.getCell(headRow, 1, $.wijmo.wijspread.SheetArea.viewport).value("序号");
   		setCellProperties(headRow+","+1, celltype.TEXT);
   		//处理字段行，不存在合并情况
   		var fieldRow = mark.tailRow-1;
   		var fieldCellStyle = sheet.getStyle(fieldRow, 2, $.wijmo.wijspread.SheetArea.viewport);
   		if(fieldCellStyle == null)	fieldCellStyle = new $.wijmo.wijspread.Style();
   		sheet.setSelection(fieldRow, 0, 1, 1);
   		sheet.setStyle(sheet.getActiveRowIndex(), sheet.getActiveColumnIndex(), fieldCellStyle.clone(), $.wijmo.wijspread.SheetArea.viewport);
   		addDetailCellMark(jQuery("div[name='de_checksingle']"));
   		sheet.setSelection(fieldRow, 1, 1, 1);
   		sheet.setStyle(sheet.getActiveRowIndex(), sheet.getActiveColumnIndex(), fieldCellStyle.clone(), $.wijmo.wijspread.SheetArea.viewport);
   		addDetailCellMark(jQuery("div[name='de_serialnum']"));
   		//check框、序号居中显示
   		sheet.getCells(fieldRow, 0, fieldRow, 1, $.wijmo.wijspread.SheetArea.viewport).vAlign($.wijmo.wijspread.VerticalAlign.center);
   		sheet.getCells(fieldRow, 0, fieldRow, 1, $.wijmo.wijspread.SheetArea.viewport).hAlign($.wijmo.wijspread.VerticalAlign.center);
   		//合并表头、表尾标识
   		sheet.addSpan(mark.headRow, 0, 1, sheet.getColumnCount()+2);
   		setRowMarkStyle(sheet, mark.headRow, "表头标识");
   		sheet.addSpan(mark.tailRow, 0, 1, sheet.getColumnCount()+2);
   		setRowMarkStyle(sheet, mark.tailRow, "表尾标识");
   		//生成合计行
   		var sumfield = jQuery(".tableBody").find("tr[name='_sumfield']");
		var needCreateSumRow = false;
   		sumfield.each(function(){
   			var sumfieldid = jQuery(this).find("a[_flag='SumFcontent']").attr("_fieldid");
   			if(fieldAttrHaveMap["Fcontent+"+sumfieldid] === "1"){
   				needCreateSumRow = true;
   				return true;
   			}
   		});
   		if(needCreateSumRow){
   			if(sheet.getRowCount() > mark.tailRow+1){		//避免影响已存在的行，还是插入行稳妥		
   				sheet.setSelection(mark.tailRow+1, 0, 1, sheet.getColumnCount());
    			baseOperate.insertRowColsFace("row");
   			}else{		//扩充行
   				baseOperate.autoExtendRowColFace(sheet, mark.tailRow, 0);
   			}
   			var dataobj = getCurrentDataObj()
   			var sumRow = mark.tailRow+1;
   			for(var i=0; i<sheet.getColumnCount(); i++){
   				var headCellStyle = sheet.getStyle(headRow, i, $.wijmo.wijspread.SheetArea.viewport);
   				if(headCellStyle == null)	headCellStyle = new $.wijmo.wijspread.Style();
   				var sumCellStyle = headCellStyle.clone();
   				sumCellStyle.backgroundImage = null;
   				sumCellStyle.textIndent = 0;
   				sheet.setStyle(sumRow, i, sumCellStyle.clone(), $.wijmo.wijspread.SheetArea.viewport);
   				if(i === 0){
   				}else if(i === 1){
   					sheet.addSpan(sumRow, 0, 1, 2);
					sheet.getCell(sumRow, 0, $.wijmo.wijspread.SheetArea.viewport).value("合计");
					setCellProperties(sumRow+","+0, celltype.TEXT);
   				}else{
   					if(dataobj.ecs[fieldRow+","+i] && dataobj.ecs[fieldRow+","+i].efieldid){
   						var fieldid = dataobj.ecs[fieldRow+","+i].efieldid;
   						sheet.setSelection(sumRow, i, 1, 1);
   						setCellProperties(sumRow+","+i, "");
   						sumfield.find("a[_flag='SumFcontent'][_fieldid='"+fieldid+"']").click();
						var sumCellStyle = sheet.getStyle(sumRow, i, $.wijmo.wijspread.SheetArea.viewport);
   						sumCellStyle.foreColor = "#ff0000";
   						sheet.setStyle(sumRow, i, sumCellStyle.clone(), $.wijmo.wijspread.SheetArea.viewport);
   					}
   				}
   			}
   		}
   		sheet.setSelection(0, 0, 1, 1);
   		sheet.isPaintSuspended(false);
   	}
   	
   	//模板校验合法
   	function verifyDetailTemplate(){
   		var mark = getHeadTailMark();
   		if(!mark.headRow)
   			return "表头标识不存在";
   		if(!mark.tailRow)
   			return "表尾标识不存在";
   		if(mark.headRow >= mark.tailRow)
   			return "表头标识必须处于表尾标识之前行";
   		var dataobj = getCurrentDataObj();
   		if(jQuery("#openSeniorSet").attr("checked")){		//高级模式
   			for(var item in dataobj.ecs){
   				var etype = dataobj.ecs[item].etype;
   				var currow = parseInt(item.split(",")[0]);
   				if(etype === celltype.DE_CHECKALL && currow >= mark.headRow)
   					return "明细行全选标识必须处于表头标识之前行";
   				if(etype === celltype.DE_CHECKSINGLE && (currow <= mark.headRow || currow >= mark.tailRow))
   					return "明细行选中标识必须处于表头标识与表尾标识之间";
   				if(etype === celltype.DE_SERIALNUM && (currow <= mark.headRow || currow >= mark.tailRow))
   					return "行序号标识必须处于表头标识与表尾标识之间";
   				if((etype === celltype.SUMFNAME || etype === celltype.SUMFCONTENT) && currow > mark.headRow && currow < mark.tailRow)
   					return "合计字段及标签不可处于表头标识与表尾标识之间行";
   			}
   		}else{
   			for(var item in dataobj.ecs){
   				var etype = dataobj.ecs[item].etype;
   				var currow = parseInt(item.split(",")[0]);
   				if(etype === celltype.DE_CHECKALL || etype === celltype.DE_CHECKSINGLE || etype === celltype.DE_SERIALNUM
   					|| etype === celltype.SUMFNAME || etype === celltype.SUMFCONTENT)
   					return "模板未启用高级定制却含有明细高级定制项";
   			}
   		}
   		return "pass";
   	}
   	
	function getHeadTailMark(){
   		var dataobj = getCurrentDataObj();
   		var mark = {};
   		for(var item in dataobj.ecs){
   			if(dataobj.ecs[item].etype === celltype.DE_TITLE)
   				mark.headRow = parseInt(item.split(",")[0]);
   			else if(dataobj.ecs[item].etype === celltype.DE_TAIL)
   				mark.tailRow = parseInt(item.split(",")[0]);
   		}
   		return mark;
   	}
   	
   	function existSeniorElements(){
   		var dataobj = getCurrentDataObj();
   		for(var item in dataobj.ecs){
   			var etype = dataobj.ecs[item].etype;
   			if(etype === celltype.DE_CHECKALL || etype === celltype.DE_CHECKSINGLE 
   				|| etype === celltype.DE_SERIALNUM || etype === celltype.SUMFNAME || etype === celltype.SUMFCONTENT){
   				return true;
   			}
   		}
   		return false;
   	}
   	//初始化明细模板
   	function initDetailTemplate(){
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Width = 810;
		dialog.Height = 570;
		dialog.maxiumnable=true;
		dialog.hideDraghandle = true;
		var url = "/workflow/exceldesign/excelInitModule.jsp?fromwhere=initdetail&detailindex="+detailIdenty;
   		url += "&wfid="+wfinfo.wfid+"&nodeid="+wfinfo.nodeid+"&formid="+wfinfo.formid+"&isbill="+wfinfo.isbill+"&layouttype="+wfinfo.layouttype;
		if(!jQuery("#dtladd").is(":checked") && !jQuery("#dtledit").is(":checked"))
			url += "&viewonly=1";
		dialog.URL = url;
		dialog.show();
		dialog.callbackfun = function(paramobj, datas){
			var styleissys = datas.styleissys;
			var styleid = datas.styleid;
			var fieldinfo = datas.fieldinfo;
			var isSysStyle = styleissys === "sys";
			jQuery.ajax({
				type : "post",
				url : "/workflow/exceldesign/excelStyleOperation.jsp",
				data : {method:(isSysStyle?"searchsysone":"searchone"), styleid:styleid},
				dataType : "JSON",
				success : function(res){
					var bordercolor,labelbgcolor,fieldbgcolor;
					var stylejson = JSON.parse(res);
					if(isSysStyle){
						bordercolor = stylejson["bordercolor"];
						labelbgcolor = stylejson["labelbgcolor"];
						fieldbgcolor = stylejson["fieldbgcolor"];
					}else{
						bordercolor = stylejson["detail_border"];
						labelbgcolor = stylejson["detail_label_bgcolor"];
						fieldbgcolor = stylejson["detail_field_bgcolor"];
					}
					var sheet = getCurrentSheet();
					sheet.isPaintSuspended(true);
					//先清空已有面板内容
					sheet.setSelection(0, 0, 1, 1);
					baseOperate.insertRowColsFace("row");
					sheet.setSelection(1, 0, sheet.getRowCount()-1, sheet.getColumnCount());
					baseOperate.deleteRowColsFace("row");
					sheet.setSelection(0, 0, 1, 1);
					for(var r=0; r<3; r++){
						baseOperate.insertRowColsFace("row");
					}
					//绘制低级定制模板
					var tableBody = jQuery(".tableBody");
					var fieldindex = 0;
					for(var i=0; i<fieldinfo.length; i++){
						var fieldid = fieldinfo[i].fieldid;
						var fieldattr = parseInt(fieldinfo[i].fieldattr);
						setFieldAttr(fieldid, fieldattr);
						if(fieldattr === 0)
							continue;
						//第一行设置含对象
						setCellProperties(0+","+fieldindex, "");
						//第二行设置标签
						var _labelstyle = new $.wijmo.wijspread.Style();
						_labelstyle.backColor = labelbgcolor;
						sheet.setStyle(1, fieldindex, _labelstyle, $.wijmo.wijspread.SheetArea.viewport);
						sheet.getCell(1, fieldindex, $.wijmo.wijspread.SheetArea.viewport).hAlign($.wijmo.wijspread.HorizontalAlign.center);
						sheet.getCell(1, fieldindex, $.wijmo.wijspread.SheetArea.viewport).vAlign($.wijmo.wijspread.VerticalAlign.center);
						sheet.setSelection(1, fieldindex, 1, 1);
						tableBody.find("a[_flag='Fname'][_fieldid='"+fieldid+"']").click();
						//第三行设置字段
						var _fieldstyle = new $.wijmo.wijspread.Style();
						_fieldstyle.backColor = fieldbgcolor;
						sheet.setStyle(2, fieldindex, _fieldstyle, $.wijmo.wijspread.SheetArea.viewport);
						sheet.getCell(2, fieldindex, $.wijmo.wijspread.SheetArea.viewport).hAlign($.wijmo.wijspread.HorizontalAlign.left);
						sheet.getCell(2, fieldindex, $.wijmo.wijspread.SheetArea.viewport).vAlign($.wijmo.wijspread.VerticalAlign.center);
						sheet.setSelection(2, fieldindex, 1, 1);
						tableBody.find("a[_flag='Fcontent'][_fieldid='"+fieldid+"']").click();
						//设置列宽
						sheet.setColumnWidth(fieldindex, 120, $.wijmo.wijspread.SheetArea.viewport);
						fieldindex++;
					}
					//设置边框
					var lineBorder = new $.wijmo.wijspread.LineBorder(bordercolor, $.wijmo.wijspread.LineStyle.thin);
					sheet.setBorder(new $.wijmo.wijspread.Range(0, 0, 0, fieldindex), lineBorder, {top:true})
					sheet.setBorder(new $.wijmo.wijspread.Range(1, 0, 2, fieldindex), lineBorder, {all:true})
					//删除空列
					sheet.setSelection(0, fieldindex, 1, sheet.getColumnCount());
					baseOperate.deleteRowColsFace("col");
					//设置表头表尾、按钮
					sheet.setSelection(0, fieldindex-1, 1, 1);
					jQuery(".excelHeadContent").find("[name='de_btn']").click();
					sheet.setSelection(2, sheet.getColumnCount(), 1, 1);
					jQuery(".excelHeadContent").find("[name='de_title']").click();
					sheet.setSelection(3, sheet.getColumnCount(), 1, 1);
					jQuery(".excelHeadContent").find("[name='de_tail']").click();
					//转换为高级定制模式
					if(jQuery("#openSeniorSet").is(":checked")){
						var mark = getHeadTailMark();
						autoExtendToSenior(mark);
					}
					sheet.isPaintSuspended(false);
				}
			});
		}
   	}
   		
	
	return {
		//单元格插入明细表
		doInsertDetailFace: function(action){
			return doInsertDetail(action);
		},
		//双击打开明细设计器窗口
		openDetailWinFace: function(edetail){
			return openDetailWin(edetail);
		},
		//添加表头表尾
		addDetailRowMarkFace: function(obj){
			return addDetailRowMark(obj);
		},
		//添加按钮、全选、单选、序号等
		addDetailCellMarkFace: function(obj){
			return addDetailCellMark(obj);
		},
		//启用、关闭高级定制
		clickOpenSeniorSetFace: function(){
			return clickOpenSeniorSet();
		},
		//模板校验合法性
		verifyDetailTemplateFace: function(){
			return verifyDetailTemplate();
		},
		//判断是否是高级定制
		hasOpenSeniorSet: function(){
			if(jQuery("#openSeniorSet").attr("checked"))
				return true;
			else 
				return false;
		},
		//初始化明细模板
		initDetailTemplateFace: function(){
			return initDetailTemplate();
		}
	}
	
})();


//=================设计器全局缓存结构*** begin========
var globalSheet = new scpCache();		//控件JSON存储缓存
var globalData = new scpCache();		//datajson存储缓存，对于主表及Tab页存封装的dataobj对象，对于明细存字符串
var formulaObj = new formulaEncapsulation();	//主表特有，存储整个表单所有公式

/**
 * JSON格式属性缓存
 */
function scpCache(){
    var cache = {};
    return {
        //将数据添加到缓存里面
        addCache: function(key, value){
            if(!(key in cache)){
                cache[key] = value;
            }else {
                delete  cache[key];
                cache[key] = value;
            }
        },
        //移除缓存中的数据
        removeCache: function(key){
            if(key in cache) {
                delete cache[key];
            }
        },
        //移除缓存中的所有数据
        removeAllCache: function(){
        	for(key in cache)
        		delete cache[key];
        },
        //判断缓存中是否有该键值对
        hasCache: function(key){
            if(key in cache)
                return true;
            return false;
        },
        //根据键值获取缓存中的值
        getCacheValue: function(key){
            if(key in  cache)
                return cache[key];
            return "";
        },
        //返回cache对象
        getCache: function(){
            return cache;
        },
        //返回cache对象的大小
        getCacheSize: function(){
        	var i=0;
        	for(key in cache)
        		i++;
        	return i;
        }
    }
};

/**
 * formula公式对象封装
 */
function formulaEncapsulation(){
	var formula = {};
	return {
		setOneFormula: function(key, value){
			formula[key] = value;
		},
		getOneFormula: function(key){
			return formula[key];
		},
		delOneFormula: function(key){
			delete formula[key];
		},
		getFormulas: function(){
			return formula;
		},
		clearFormulas: function(){
			formula = {};
		}
	}
}
//=================设计器全局缓存结构*** end========

/**
 * 获取当前编辑Sheet,对当前面板的操作都应通过此方法获取
 */
function getCurrentSheet(){
	var excelDiv = isEditMoreContent ? jQuery("#excelDiv_mc") : jQuery("#excelDiv");
	var ss = excelDiv.wijspread("spread");
	var sheet = ss.getActiveSheet();
	return sheet;
}

/**
 * 获取当前编辑面板对应的dataobj,对当前面板的操作都应通过此方法获取
 */
function getCurrentDataObj(){
	if(isEditMoreContent){
		var mcpoint = jQuery("input#mcpoint").val();
		if(mcpoint !=="" && globalData.hasCache(mcpoint))
			return globalData.getCacheValue(mcpoint);
	}else{
		var symbol = globalData.getCacheValue("symbol");
		if(globalData.hasCache(symbol))
			return globalData.getCacheValue(symbol)
	}
	return null;
}

//全局变量
var forBug_copyvalue = "";
var isEditFormulaing = false;	//是否正在编辑公式
var detailFormulaTempAry = new Array();
var isAutoCompleteKeyDown = 0;
var existMaxTabIndex = 0;		//已存在的最大 标签页序号
var existMaxMcIndex = 0;		//已存在的最大 多内容序号
var isEditMoreContent = false;		//当前编辑多内容面板的标示

/**
 * 单元格-存储内容类型
 */
var celltype={
    "TEXT":"tx",
    "FNAME":"Fname",		//字段名
    "FCONTENT":"Fcontent",	//表单内容
	"NNAME":"Nname",		//节点名称
	"NADVICE":"Nadvice",	//流转意见
	"IMAGE":"image",		//图片
	"DETAIL":"dt",			//明细表
	"DE_TITLE":"de_title",	//表头标识
	"DE_TAIL":"de_tail",	//表尾标识
	"DE_BTN":"de_btn",		//明细按钮
	"LINKTEXT":"lktxt",		//链接
	"TAB":"tab",			//Tab页
	"MC":"morecontent",		//多内容
	"BR":"br",				//换行
	"PORTAL":"portal",		//门户元素
	"IFRAME":"iframe",		//iframe区域
	"SCANCODE":"scancode",	//扫描码
	"SUMFNAME":"SumFname",		//合计字段标签
	"SUMFCONTENT":"SumFcontent",	//合计字段
	"DE_CHECKALL":"de_checkall",//选中所有
	"DE_CHECKSINGLE":"de_checksingle",	//选中单行
	"DE_SERIALNUM":"de_serialnum"	//序号
};

//保存方法转换etype
function transformerEtype(etype){
	if(etype === celltype.TEXT)			//文本
	 	return "1";
	else if(etype === celltype.FNAME)	//字段名
		return "2";
	else if(etype === celltype.FCONTENT)//表单内容
		return "3";
	else if(etype === celltype.NNAME)	//节点名
		return "4";
	else if(etype === celltype.NADVICE)	//流转意见
		return "5";
	else if(etype === celltype.IMAGE)	//图片
		return "6";
	else if(etype === celltype.DETAIL)	//明细
		return "7";
	else if(etype === celltype.DE_TITLE)//表头标识
		return "8";
	else if(etype === celltype.DE_TAIL)	//表尾标识
		return "9";
	else if(etype === celltype.DE_BTN)	//明细增删按妞
		return "10";
	else if(etype === celltype.LINKTEXT)//链接
		return "11";
	else if(etype === celltype.TAB)		//标签页
		return "12";
	else if(etype === celltype.MC)		//多内容
		return "13";
	else if(etype === celltype.BR)		//换行符
		return "14";
	else if(etype === celltype.PORTAL)	//门户元素
		return "15";
	else if(etype === celltype.IFRAME)	//iframe区域
		return "16";
	else if(etype === celltype.SCANCODE)//扫描码
		return "17";
	else if(etype === celltype.SUMFNAME)
		return "18";
	else if(etype === celltype.SUMFCONTENT)
		return "19";
	else if(etype === celltype.DE_CHECKALL)
		return "20";
	else if(etype === celltype.DE_CHECKSINGLE)
		return "21";
	else if(etype === celltype.DE_SERIALNUM)
		return "22";
}

//恢复的时候反向转换etype
function reverseTransformerEtype(etype){
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
	else if(etype === "12")
		return celltype.TAB;
	else if(etype === "13")
		return celltype.MC;
	else if(etype === "14")
		return celltype.BR;
	else if(etype === "15")
		return celltype.PORTAL;
	else if(etype === "16")
		return celltype.IFRAME;
	else if(etype === "17")
		return celltype.SCANCODE;
	else if(etype === "18")
		return celltype.SUMFNAME;
	else if(etype === "19")
		return celltype.SUMFCONTENT;
	else if(etype === "20")
		return celltype.DE_CHECKALL;
	else if(etype === "21")
		return celltype.DE_CHECKSINGLE;
	else if(etype === "22")
		return celltype.DE_SERIALNUM;
}

/**
 * 单元格为字段时，字段类型(控制图片)
 */
var controltype={
	"TEXT":"text",
	"SELECT":"select",
	"BROWSER":"browser",
	"CHECKBOX":"checkbox",
	"DATE":"date",
	"TIME":"time",
	"AFFIX":"affix",
	"LINK":"link",
	"TEXTAREA":"textarea",
	"RADIO":"radio",
	"POSITION":"position"
};

function transControlType(_fieldtype, _fieldtypedetail){
	var _controltype = "";
	if(_fieldtype==="3"){
		if(_fieldtypedetail==="2")
			_controltype = controltype.DATE;
		else if(_fieldtypedetail==="19")
			_controltype = controltype.TIME;
		else 
			_controltype=controltype.BROWSER;
	}else if(_fieldtype==="1")
		_controltype=controltype.TEXT;
	else if(_fieldtype==="2")
		_controltype=controltype.TEXTAREA;
	else if(_fieldtype==="4")
		_controltype=controltype.CHECKBOX;
	else if(_fieldtype==="5")
		_controltype=controltype.SELECT;
	else if(_fieldtype==="6")
		_controltype=controltype.AFFIX;
	else if(_fieldtype==="7")
		_controltype=controltype.LINK;
	else if(_fieldtype==="8")
		_controltype=controltype.RADIO;
	else if(_fieldtype==="9")
		_controltype=controltype.POSITION;
	return _controltype;
}

/**
 * 单元格检索下拉div
 */
function showAutoCompleteDiv(autoCompleteHtml){
	var gcEditingInput = jQuery("textArea[gcuielement=gcEditingInput]");
	//如果页面已存在，那么不再往下处理；
	isAutoCompleteKeyDown = 0;
	gcEditingInput.parent("div").find(".ac_results").remove();
	if(!!autoCompleteHtml){
		var autoCompleteDiv = $("<div style=\"width:175px\"></div>");
		var autoCompleteDiv_html = $("<ul>"+autoCompleteHtml+"</ul>");
		autoCompleteDiv.html(autoCompleteDiv_html);
		autoCompleteDiv.addClass("ac_results");
		gcEditingInput.parent("div").append(autoCompleteDiv);
		gcEditingInput.parent("div").find(".ac_results ul li").eq(0).addClass("selected");	//默认选中第一个
		gcEditingInput.parent("div").find(".ac_results ul li").bind("mousedown",function(evt){
			var targetid = "";
       		if($(this).attr("_fieldid"))
       			targetid |=$(this).attr("_fieldid");
       		if($(this).attr("_nodeid"))
       			targetid |= $(this).attr("_nodeid");
       		var flag = $(this).attr("_flag");
	       	var _txt = $(this).text();
	       	var _fieldtype,_fieldtypedetail;
	       	if(flag === celltype.FCONTENT){
		       	_fieldtype = $(this).children("[name=fieldtype]").val();
		       	_fieldtypedetail = $(this).children("[name=fieldtypedetail]").val();
	       	}
	       	var fieldhave = getFieldAttrHave(targetid,flag);
       		if(!!fieldhave){
				gcEditingInput.val("");
				gcEditingInput.parent("div").find(".ac_results").remove();
			}else{
		       	setExcelBxValue(evt,targetid,flag,_txt,_fieldtype,_fieldtypedetail);
		       	gcEditingInput.val(_txt);
	       	}
		});
		gcEditingInput.unbind("keydown",autoCompleteKeyDown);
		gcEditingInput.bind("keydown",autoCompleteKeyDown);
	}
}

//绑定事件
function autoCompleteKeyDown(e){
	var ctrlKey = e.ctrlKey,
        shiftKey = e.shiftKey,
        altKey = e.altKey,
        metaKey = e.metaKey,
        modifyKey = ctrlKey || shiftKey || altKey || metaKey,
        keyCode = e.keyCode;
	if(!modifyKey){
		if(keyCode == 37 || keyCode == 38 || keyCode == 39 || keyCode== 40)
			isAutoCompleteKeyDown ++;
		if(keyCode == 38 || keyCode == 40 ){
			var gcEditingInput = jQuery("textArea[gcuielement=gcEditingInput]");
			var currentTarget = gcEditingInput.parent("div").find(".ac_results ul li.selected");
			currentTarget.removeClass("selected");
			if(keyCode == 40 ){ //向下
				var nextTarget = currentTarget.next();
				if(!nextTarget || nextTarget.length == 0)
					gcEditingInput.parent("div").find(".ac_results ul li").eq(0).addClass("selected");
				else
					nextTarget.addClass("selected");
			}else if(keyCode == 38){	//向上
				var prevTarget = currentTarget.prev();
				if(!prevTarget || prevTarget.length == 0)
					gcEditingInput.parent("div").find(".ac_results ul li").eq(7).addClass("selected");
				else
					prevTarget.addClass("selected");
			}
			e.preventDefault();
           	e.stopPropagation();
		}
	}
}

/*
 *	右边拖拽后 / 双击 单元格赋值 和联想输入时
 *	@param 
 *		 targetid 字段或者节点ID
 *		 flag 字段或者节点
 *		 txt 列表文本值
 *		 _fieldtype		大类型
 *		 _fieldtypedetail 	小类型
 */
function setExcelBxValue(e, targetid, flag, txt, _fieldtype, _fieldtypedetail){
	if(baseOperate.judgeRangeHasAreaFace("hover")){
		window.top.Dialog.confirm(_excel_reminder_4, function(){
			setExcelBxValueFun(e, targetid, flag, txt, _fieldtype, _fieldtypedetail);
		});
	}else{
		setExcelBxValueFun(e, targetid, flag, txt, _fieldtype, _fieldtypedetail);
	}
}
function setExcelBxValueFun(e, targetid, flag, txt, _fieldtype, _fieldtypedetail){
    var sheet = getCurrentSheet();
	var c = sheet.getActiveColumnIndex();
	var r = sheet.getActiveRowIndex();
	var sel = sheet.getSelections()[0];
	if(sel.row == undefined || sel.col === undefined)	//如果拖动没有拖到单元格内，直接return掉;
		return;
	if(isEditMoreContent && c != 0)			//多字段面板只允许设置第一列
		return;
	var fieldhave = getFieldAttrHave(targetid,flag);
	if(!!fieldhave)
		return;
		
	baseOperate.autoExtendRowColFace(sheet, r, c);
	setFieldAttrHave(targetid, flag, 1);

	var _controltype = "";
	var imgsrc = "";
	if(flag === celltype.FCONTENT){			//处理字段相关(字段属性、字段类型、图片)
		//设置字段属性
		var setfieldattr = getFieldAttr(targetid);
		if(wfinfo.layouttype == "1" || wfinfo.nodetype == "3"){	//打印模式、归档节点
			setfieldattr = "1";
		}else{
			if(isDetail==="on"){
				if($("#dtladd").is(":checked") || $("#dtledit").is(":checked")){
					if(setfieldattr == "0")
						setfieldattr = "2";
				}else{
					setfieldattr = "1";
				}
			}else{
				if(setfieldattr == "0")
					setfieldattr = "2";
				if(targetid == -1 && setfieldattr == "2")
					setfieldattr = "3";
			}
		}
		//获取字段图标
		if(targetid == -1)
			_fieldtype = "1";
		else if(targetid == -4)
			_fieldtype = "2";
		else if(targetid == -2 || targetid == -3 || targetid == -5)
			_fieldtype = "8";
		_controltype = transControlType(_fieldtype, _fieldtypedetail);
		if(_controltype===controltype.LINK || _controltype===controltype.POSITION)
			setfieldattr = 1;
		//设置隐藏域
		setFieldAttr(targetid, setfieldattr);
		if(_controltype != "")
			imgsrc = "/workflow/exceldesign/image/controls/"+_controltype+setfieldattr+"_wev8.png";
	}else if(flag === celltype.SUMFCONTENT){
		imgsrc = "/workflow/exceldesign/image/shortBtn/detail/detailSumField_wev8.png";
	}
	//判断是覆盖单元格/扩充成多字段
	var dataobj = getCurrentDataObj();
	var celltext = sheet.getCell(r, c, $.wijmo.wijspread.SheetArea.viewport).text();
	var opertarget = judgeCellOperTarget(dataobj, celltext, r, c);
	if(opertarget === 1){		//替换单元格内容
		restoreCellProperties("", r+","+c);
		sheet.setIsProtected(true);
		setCellTextImage(sheet, r, c, txt, imgsrc);
		var cell = {};
		cell.efieldid = targetid;
		if(_controltype != "")
			cell.efieldtype = _controltype;
		setCellProperties(r+","+c, flag, cell);
		//控制操作权限
		baseOperate.controlOperLimitsFace(r, c);
		sheet.setSelection(r, c, 1, 1);		//解决添加后直接删除无效问题
	}else{
		var mcCellArr = new Array();
		if(opertarget === 2){		//合并内容成多字段
			var curCellObj = $.extend(true, {}, dataobj.ecs[r+","+c]);
			delete dataobj.ecs[r+","+c];
			formulaOperate.deleteCellFormulaFace(r+","+c, globalData.getCacheValue("symbol"));
			curCellObj.celltext = celltext.replace("(fx)", "");
			curCellObj.imgsrc = sheet.getCell(r, c, $.wijmo.wijspread.SheetArea.viewport).backgroundImage();
			curCellObj._style = sheet.getStyle(r, c, $.wijmo.wijspread.SheetArea.viewport);
			mcCellArr.push(curCellObj);
		}
		var addCellObj = {};
		addCellObj.etype = flag;
		addCellObj.efieldid = targetid;
		if(_controltype != "")
			addCellObj.efieldtype = _controltype;
		addCellObj.celltext = txt;
		addCellObj.imgsrc = imgsrc;
		if(imgsrc !== ""){
			addCellObj._style = new $.wijmo.wijspread.Style();
			addCellObj._style.textIndent = 2.5;
		}
		mcCellArr.push(addCellObj);
		mcOperate.operMoreContentFace(opertarget, mcCellArr);
	}
}

/**
 * 获取单元格操作标示、
 * 1:替换单元格内容
 * 2:合并内容变成多字段单元格
 * 3:将内容追加到多内容面板中
 */
function judgeCellOperTarget(dataobj, celltext, row, col){
	if(isAutoExtendMoreContent && isDetail !== "on" && !isEditMoreContent && jQuery.trim(celltext) !== ""){
		if(dataobj.ecs && dataobj.ecs[row+","+col]){
			var etype = dataobj.ecs[row+","+col].etype;
			if(etype === celltype.TEXT || etype === celltype.FNAME || etype === celltype.FCONTENT
				||etype === celltype.NNAME || etype === celltype.NADVICE || etype === celltype.LINKTEXT)
				return 2;
			else if(etype === celltype.MC)
				return 3;
		}
	}
	return 1;
}

/**
 * 还原属性、清除缓存等
 */
function restoreCellProperties(symbol, cellid){
	if(symbol === ""){		//缺省则取当前编辑面板标示
		if(isEditMoreContent)
			symbol = jQuery("input#mcpoint").val();
		else
			symbol = globalData.getCacheValue("symbol");
	}
	if(!globalData.hasCache(symbol))
		return;
	formulaOperate.deleteCellFormulaFace(cellid, symbol);	//单元格内容变更自动清除公式
	var dataobj = globalData.getCacheValue(symbol);
	if(!dataobj.ecs || !dataobj.ecs[cellid])
		return;
	var etype = dataobj.ecs[cellid].etype;
	if(etype === celltype.DE_TITLE || etype === celltype.DE_TAIL 
			|| etype === celltype.DE_BTN || etype === celltype.DE_CHECKALL 
			|| etype === celltype.DE_CHECKSINGLE || etype === celltype.DE_SERIALNUM){
		$(".excelHeadContent").find("[name='"+etype+"']").addClass("shortBtn").removeClass("shortBtn_disabled");
	}else if(etype === celltype.FNAME || etype === celltype.FCONTENT || etype === celltype.NNAME 
		|| etype === celltype.NADVICE || etype === celltype.SUMFNAME || etype === celltype.SUMFCONTENT){		//字段及节点，还原存在的属性
		setFieldAttrHave(dataobj.ecs[cellid].efieldid, etype, 0);
	}else if(etype === celltype.DETAIL){	//明细表，还原存在的属性及删除缓存
		var detailid = dataobj.ecs[cellid].edetail;
		delete dataobj.ecs[cellid].edetail;
		globalData.removeCache(detailid);
		globalSheet.removeCache(detailid+"_sheet");
		delete haveDetailMap[detailid];
	}else if(etype === celltype.TAB && symbol === "main"){	//标签页，删除缓存
		tabOperate.deleteTabCache(dataobj.ecs[cellid].tab);
		delete dataobj.ecs[cellid].tab;
	}else if(etype === celltype.MC){		//多内容
		mcOperate.deleteMcCache(dataobj.ecs[cellid].mcpoint);
		delete dataobj.ecs[cellid].mcpoint;
	}else if(etype === celltype.PORTAL || etype === celltype.IFRAME || etype === celltype.SCANCODE){
		if(etype === celltype.PORTAL && dataobj.ecs[cellid].jsonparam && dataobj.ecs[cellid].jsonparam.hpid)
			insertOperate.deletePortalElmFace(dataobj.ecs[cellid].jsonparam.hpid);
		delete dataobj.ecs[cellid].jsonparam;
	}
}

/**
 * 设置数据列属性
 * @param bxid 【单元格ID】
 * @param type 【数据列属性对象】
 */
function setCellProperties(bxid, type, cell_pro, symbol) {
	if(typeof symbol == "undefined"){
		if(isEditMoreContent)
			symbol = jQuery("input#mcpoint").val();
		else
			symbol = globalData.getCacheValue("symbol");
	}
	if(!globalData.hasCache(symbol))
		return;
	var dataobj = globalData.getCacheValue(symbol);
    if(!!!dataobj.ecs[bxid])
    	dataobj.ecs[bxid] = {};
    dataobj.ecs[bxid].id = bxid;
    if(type != "")
    	dataobj.ecs[bxid].etype = type;
    var cell_obj = dataobj.ecs[bxid];
    if(!!cell_pro){
   		if(cell_pro.efieldid){
   			cell_obj.efieldid = cell_pro.efieldid;
   			cell_obj.efieldtype = cell_pro.efieldtype;
		}
   		if(cell_pro.edetail)
   			cell_obj.edetail = cell_pro.edetail;
   		if(cell_pro.enumbric)
     		cell_obj.enumbric = cell_pro.enumbric;
   		if(cell_pro.financial)
   			cell_obj.financial = cell_pro.financial;
   		if(cell_pro.formula)
   			cell_obj.formula = cell_pro.formula;
   		if(cell_pro.tab)
   			cell_obj.tab = cell_pro.tab;
   		if(cell_pro.mcpoint)
   			cell_obj.mcpoint = cell_pro.mcpoint;
   		if(cell_pro.brsign)
   			cell_obj.brsign = cell_pro.brsign;
   		if(cell_pro.attrs)
   			cell_obj.attrs = cell_pro.attrs;
   		if(cell_pro.jsonparam)
   			cell_obj.jsonparam = cell_pro.jsonparam;
    }
}

/**
 * 设置单元格内容/图片
 */
function setCellTextImage(sheet, r, c, celltext, cellimg){
	sheet.isPaintSuspended(true);
	var cell = sheet.getCell(r, c, $.wijmo.wijspread.SheetArea.viewport);
	cell.value(celltext);
	cell.wordWrap(true);
	if(!!cellimg){
		cell.backgroundImage(cellimg);
		cell.backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
		cell.textIndent(2.5);
	}else{
		cell.backgroundImage(null);
		cell.textIndent(0);
	}
	sheet.isPaintSuspended(false);
}

/**
 * 获取单元格字段图片
 */
function getCellFieldImage(cellobj, fieldattr){
	var bgimage= "";
	try{
		var efieldid = parseInt(cellobj.efieldid);	//字段ID
		if(typeof fieldattr == "undefined")
			fieldattr = getFieldAttr(efieldid);
		if(fieldattr == 0){
			bgimage = "/workflow/exceldesign/image/controls/fieldNotShow_wev8.png";
		}else{
			if(efieldid == -4)		//签字意见字段只读
				return "/workflow/exceldesign/image/controls/textarea1_wev8.png";
			if(efieldid == -1 && fieldattr == 2)	//标题字段可编辑则必填
				fieldattr = 3;
			if(wfinfo.layouttype === "1" || wfinfo.nodetype === "3")	//打印和归档图片置灰
				fieldattr = 1;
			if(cellobj.efieldtype===controltype.LINK)
				fieldattr = 1;
			if(!!cellobj.financial){
				if(cellobj.financial.indexOf("2-") > -1)
					bgimage = "/workflow/exceldesign/image/controls/finance"+fieldattr+"_wev8.png";
				else if(cellobj.financial == "3")
					bgimage = "/workflow/exceldesign/image/controls/financeUpper_wev8.png";
				else if(cellobj.financial == "4")
					bgimage = "/workflow/exceldesign/image/controls/thousands_wev8.png";
			}else{
				bgimage = "/workflow/exceldesign/image/controls/"+cellobj.efieldtype+fieldattr+"_wev8.png";
			}
		}
	}catch(e){}
	return bgimage;
}

//loading效果
function __displayloaddingblock() {
	try {
		var pTop= parent.document.body.offsetHeight/2+parent.document.body.scrollTop - 50 + jQuery(".e8_boxhead", parent.document).height()/2 ;
		var pLeft= parent.document.body.offsetWidth/2 - (217/2);
		jQuery("#submitloaddingdiv").css({"top":pTop, "left":pLeft, "display":"inline-block;"});
		jQuery("#submitloaddingdiv").show();
		jQuery("#submitloaddingdiv_out").show();
	} catch (e) {}
}

//控制头部插入标签页权限
function controlInsertTab(){
	if(globalData.getCacheValue("symbol") === "main"){
		jQuery("table.s_insert").find("[name='tabpage']").show();
	}else{
		jQuery("table.s_insert").find("[name='tabpage']").hide();
	}
}

//明细表移动
function moveDetailUl(flag){
	var obj=$("ul.detail_ul");
	var ul_left=parseInt(obj.css("left"));
	var li_width=76;
	if(flag==='left'){
		if(ul_left>=-10)	return;
		obj.css("left",(ul_left+li_width)+"px");
	}else if(flag==='right'){
		var excess_width=(obj.find("li").size()-5)*li_width;
		if(ul_left<=-excess_width) return;
		obj.css("left",(ul_left-li_width)+"px");
	}
}

//缩放属性窗口
function shrinkClick(){
	var obj=jQuery(".shrinkBtn");
	var ss = jQuery("#excelDiv").wijspread("spread");
	
	if(obj.hasClass("hideShrinkBtn")){			//隐藏属性窗口
		unbindShrinkEvent();
		jQuery(".excelSet").hide();
		obj.removeClass("hideShrinkBtn").addClass("showShrinkBtn");
		$("div.excelBody").css("width",($(window).width()-10)+"px");
	}else if(obj.hasClass("showShrinkBtn")){		//展开属性窗口
		bindShrinkEvent();
		jQuery(".excelSet").show();
		obj.removeClass("showShrinkBtn").addClass("hideShrinkBtn");
		$("div.excelBody").css("width",($(window).width()-230)+"px");
	}
 	ss._doResize();
}

function bindShrinkEvent(){
	$(".shrinkBtn").css("top",(($(".excelSet").height()-$(".shrinkBtn").height())/2+130)+"px")
			.css("right",$(".excelSet").width()+"px");
	$(".excelSet").add(".shrinkBtn").bind("mousemove",function(){
		$(".shrinkBtn").show();
	}).bind("mouseout",function(){
		$(".shrinkBtn").hide();
	});
}

function unbindShrinkEvent(){
	$(".shrinkBtn").css("top",(($(".excelSet").height()-$(".shrinkBtn").height())/2+130)+"px")
			.css("right","0px").show();
	$(".excelSet").add(".shrinkBtn").unbind("mousemove").unbind("mouseout");
}


//在模板tab中的iframe 点击编辑切换tab
function changeTab4SameModeid(){
	var currentTab = jQuery(".excel_opitem").parent(".nav").find(".current");
	var formatTab = currentTab.next();
	currentTab.removeClass("current");
	formatTab.addClass("current");
	jQuery(".excelHeadContent").children("table").hide();
	jQuery(".excelBody").show();
	jQuery(".excelHeadBG").show();
	jQuery(".excelSet").show();
	jQuery(".moduleContainer").hide();
	jQuery(".excelHeadContent").children(".s_format").show();
}

function setFormatrushNor(){
	jQuery(".excelHeadContent").find("div[name=formatrush]").attr("down","");
  	jQuery(".excelHeadContent").find("div[name=formatrush]").removeClass("shortBtnHover");
}

function compareObject(o1,o2){
  	if(typeof o1 != typeof o2)return false;
  	if(typeof o1 == 'object'){
	    for(var o in o1){
	      	if(typeof o2[o] == 'undefined')return false;
	      	if(!compareObject(o1[o],o2[o]))return false;
	    }
	    return true;
  	}else if(typeof o1 == 'function'){
  		return true;
  	}else{
    	return o1 === o2;
  	}
}
		
//检查 服务器是否断开 ，明细先不检测了
function checkServer(func,param){
	if(isDetail === "on"){
		func(param);
	}else{
		jQuery.ajax({
			type:"POST",
			url:"/workflow/exceldesign/excelCheckServer.jsp",
			timeout:10000,
			success:function(res){
				//...;
				func(param);
				return true;
			},
			error:function(XMLHttpRequest, textStatus, errorThrown){
				window.top.Dialog.confirm("你目前已与服务器断开连接了，是否需要保存到本地？",function(){
					var allsheetJson = formOperate.saveLayoutWindowFace("export");
					storage.clear();
					storage.setItem(storageKey, allsheetJson);
					parentDialog.close();
				},function(){
					parentDialog.close();
				});
				return false;
			}
		});
	}
}

function judgeDesignHasModify(){
	var hasModify = false;
	try{
		var str1 = "", str2 = "";
		if(isDetail === "on"){	
			str1 = formOperate.saveDetailWindowFace(detailIdenty,"save2Confirm");
			if(parentWin_Main.globalData.hasCache("detail_"+detailIdenty))
				str2 = parentWin_Main.globalData.getCacheValue("detail_"+detailIdenty)
		}else{
			str1 = formOperate.saveLayoutWindowFace("save2Confirm");
			str2 = getDataJson();
		}
		if(str1 != ""){
			if(str2 == ""){
				hasModify = true;
			}else{
				if(isDetail === "on"){
					str1 = "{"+str1+"}";
					str2 = "{"+str2+"}";
				}
				var str1Json = JSON.parse(str1);
				var str2Json = JSON.parse(str2);
				var issame = false;
				if(isDetail === "on")
					issame = compareObject(str1Json["detail_"+detailIdenty], str2Json["detail_"+detailIdenty]);
				else
					issame = compareObject(str1Json.eformdesign.etables, str2Json.eformdesign.etables);
				//交换位置再比较一次,针对只对模板进行删除操作
				if(issame){
					if(isDetail === "on")
						issame = compareObject(str2Json["detail_"+detailIdenty], str1Json["detail_"+detailIdenty]);
					else
						issame = compareObject(str2Json.eformdesign.etables, str1Json.eformdesign.etables);
				}
				hasModify = !issame;
			}
		}
	}catch(e){
		
	}
	return hasModify;
}

//关闭前提醒
function closeDesignWin(ct){
	if(judgeDesignHasModify()){
		window.top.Dialog.confirm("模板内容尚未保存，确定离开吗？", function(){
			parentDialog.close();
		});
	}else{
		parentDialog.close();
	}
}


//保存过的模板在外部重新设置字段属性，外部字段属性不影响模板，然再保存，模板中的属性覆盖外部字段属性的设置
var haveDetailMap = {};		//表格中已插入的明细表集合
var fieldAttrHaveMap = {};	//表格中已插入的字段集合

/**
 * 异步初始化全局变量
 */
function initGlobalData(){
	var wfid=$("#wfid").val();
	var formid=$("#formid").val();
	var nodeid=$("#nodeid").val();
	var isbill=$("#isbill").val();
	if(mainFields==null){
		jQuery.ajax({
			type:"POST",
			url:"excelAjaxData.jsp?src=getMainFields&wfid="+wfid+"&formid="+formid+"&nodeid="+nodeid+"&isbill="+isbill,
			success:function(res){
				mainFields=eval('('+res+')');
			}
		});
	} 
	if(detailFields==null){
		jQuery.ajax({
			type:"POST",
			url:"excelAjaxData.jsp?src=getDetailFields&wfid="+wfid+"&formid="+formid+"&nodeid="+nodeid+"&isbill="+isbill,
			success:function(res){
				detailFields=eval('('+res+')');
			}
		});
	}
	if(WfNodes==null){
		jQuery.ajax({
			type:"POST",
			url:"excelAjaxData.jsp?src=getWfNodes&wfid="+wfid+"&formid="+formid+"&nodeid="+nodeid+"&isbill="+isbill,
			success:function(res){
				WfNodes=eval('('+res+')');
			}
		});
	}
}

/**
 * 新建表单字段
 */
function addFormField(){
	var dlg=new window.top.Dialog();//定义Dialog对象
	dlg.currentWindow=window;
	dlg.Model=true;
	dlg.maxiumnable=false;
	dlg.Width=1150;
	dlg.Height=600;
    dlg.URL="/workflow/field/addfield0.jsp?formid="+jQuery("#formid").val()+"&dialog=1&fromWFCode=exceldesign";  
	dlg.Title="添加字段";
	dlg.callbackfun = function(paramobj,datas){
		if(datas){
			if(datas.returnValue=="success"){
				mainFields=null;
				detailFields=null;
				initGlobalData();
				tabChangeExpend('mf');
				if(datas.curfieldid!=null&&datas.tableIndex!=null){
					try{
						var curfieldid=datas.curfieldid;
						var fieldids=jQuery("#fieldids").val();
						if(fieldids.substr(fieldids.length-1)!=",")	
							fieldids += ",";
						fieldids += curfieldid;
						jQuery("#fieldids").val(fieldids);
						var hiddenDivObj=jQuery("#hiddenAttrDiv");
						hiddenDivObj.append('<input type="hidden" id="fieldattr'+curfieldid+'" fieldname="'+datas.fieldlabelname+'" nodetype="'+datas.tableIndex+'" name="fieldattr'+curfieldid+'" value="0" />');
						hiddenDivObj.append('<input type="hidden" id="fieldsql'+curfieldid+'" name="fieldsql'+curfieldid+'" value="" />');
						hiddenDivObj.append('<input type="hidden" id="caltype'+curfieldid+'" name="caltype'+curfieldid+'" value="0" />');
						hiddenDivObj.append('<input type="hidden" id="othertype'+curfieldid+'" name="othertype'+curfieldid+'" value="0" />');
						hiddenDivObj.append('<input type="hidden" id="transtype'+curfieldid+'" name="transtype'+curfieldid+'" value="0" />');
					}catch(e){}
				}
			}
		}
	}
　　 dlg.show();
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

/**
 * tableHead绑定click、初始化加载
 */
function operTableHead(){
	$(".tableHead").children("div[name]").click(function(){
		if($(this).is(".current"))
			return;
		$(".tableHead").children("div").removeClass("current");
		$(this).addClass("current");
		tabChangeExpend($(this).attr("name"));
	});
    //默认选择字段Tab
    tabChangeExpend('mf');
}

/**
 * tab切换事件
 */
function tabChangeExpend(obj_name){
	jQuery("[name='searchVal']").val("");
	var _tbody=$(".tableBody tbody");
	if(obj_name === "mf"){
		//避免mainFields异步未初始化完成
		if(mainFields==null){
			window.setTimeout(function(){
				tabChangeExpend(obj_name);
			},100);
			return;
		}
		var _html=getMainFieldHtml(1);
		_tbody.find("tr[class!='thead']").remove();
		_tbody.append(_html);
		_tbody.find(".thead td").eq(0).text("标签");
		_tbody.find(".thead td").eq(1).text("字段");
		$(".addmf").show();
	}else if(obj_name === "wn"){
		//避免WfNodes异步未初始化完成
		if(WfNodes==null){
			window.setTimeout(function(){
				tabChangeExpend(obj_name);
			},100);
			return;
		}
		var _html=getNodeHtml(1);
		_tbody.find("tr[class!='thead']").remove();
		_tbody.append(_html);
		_tbody.find(".thead td").eq(0).text("节点名称");
		_tbody.find(".thead td").eq(1).text("流转意见");
		$(".addmf").hide();
	}
	addMiddleBorder();
	bindTrEvent();
}

/**
 * 搜索字段、节点
 */
function searchTable(){
	var obj_name=$(".tableHead").find("div.current").attr("name");
	var searchVal=$("[name='searchVal']").val();
	if(searchVal.length>0){
		searchVal=searchVal.toLowerCase();
	}
	var _tbody=$(".tableBody tbody");
	if(obj_name==="mf"){
		var _html=getMainFieldHtml(1,searchVal);
		_tbody.find("tr[class!='thead']").remove();
		_tbody.append(_html);
	}else if(obj_name==="wn"){
		var _html=getNodeHtml(1,searchVal);
		_tbody.find("tr[class!='thead']").remove();
		_tbody.append(_html);
	}
	addMiddleBorder();
	bindTrEvent();
}

/**
 * tr绑定事件
 */
function bindTrEvent(){
	//注册拖动、双击事件
	$(".tableBody").find("table tr td").not(".thead td").find("a").draggable({
       	appendTo:"body",
       	helper:"clone",
       	cursor:"default",
       	zIndex:999999,
       	drag:function(e){
       		//拖动时，需要跟右键一样，寻找单元格准确位置
       		baseOperate.mouseLocateCellFace(e, "drag");
       	},
       	stop:function(e){
       		var targetid = "";
       		if($(this).attr("_fieldid"))
       			targetid |=$(this).attr("_fieldid");
       		if($(this).attr("_nodeid"))
       			targetid |= $(this).attr("_nodeid");
       		var flag = $(this).attr("_flag");
	       	var _txt = $(this).text();
	       	var _fieldtype,_fieldtypedetail;
	       	if(flag === celltype.FCONTENT){
		       	_fieldtype = $(this).children("[name=fieldtype]").val();
		       	_fieldtypedetail = $(this).children("[name=fieldtypedetail]").val();
	       	}
	       	setExcelBxValue(e,targetid,flag,_txt,_fieldtype,_fieldtypedetail);
		}
    }).click(function(e){
    	var targetid = "";
       		if($(this).attr("_fieldid"))
       			targetid |=$(this).attr("_fieldid");
       		if($(this).attr("_nodeid"))
       			targetid |= $(this).attr("_nodeid");
		var flag = $(this).attr("_flag");
		var _txt = $(this).text();
       	var _fieldtype = $(this).children("[name=fieldtype]").val();
       	var _fieldtypedetail = $(this).children("[name=fieldtypedetail]").val();
	   	setExcelBxValue(e,targetid,flag,_txt,_fieldtype,_fieldtypedetail);
    });
    var _multiLangConfig = [
		{label:"<img src='/images/ecology8/simplized_wev8.png' style='vertical-align:middle;'/>",languageId:7,name:"zhcn"},
		{label:"<img src='/images/ecology8/en_wev8.png' style='vertical-align:middle;'/>",languageId:8,name:"en"},
		{label:"<img src='/images/ecology8/tranditional_wev8.png' style='vertical-align:middle;'/>",languageId:9,name:"twcn"}
	];
    $(".tableBody").find("table tr[name=_fieldtrinexceldesign]").hover(function(event){
    	$(".tableBody").find("table tr[name=_fieldtrinexceldesign]").removeClass("current");
    	$(".tableBody").find("table tr[name=_fieldtrinexceldesign]").children().find("div[name=editfieldImg]").remove();
    	var obj = this;
    	if(!$(obj).is(".current"))
			$(obj).addClass("current");
		var editimg = $("<div name=editfieldImg style=position:absolute;cursor:pointer;><img width=16 height=16 src='/workflow/exceldesign/image/rightBtn/edit2_wev8.png' ></div>");
		$(this).children().eq(1).append(editimg);
		var _ow = obj.offsetWidth;
		var _oh = obj.offsetHeight;
		editimg.css("top",($(obj).offset().top + (_oh/2-8))+"px");
		editimg.css("left",($(obj).offset().left + _ow -24) +"px");
		$(obj).attr("target","no");
		
		editimg.on("click",function(){
			$(obj).attr("target","on");
			$(obj).addClass("current");
			$("div[name=editfieldDiv]").find("[name=fieldid],#cnlabel,#enlabel,#twlabel").val("");
			$("div[name=editfieldDiv]").show();
			$(".tableBody").find("table tr[name=_fieldtrinexceldesign]").children().find("div[name=editfieldImg]").remove();
			$("div[name=editfieldDiv]").css("top",(0-$(".tableBody").children("table").height())+"px");
			$("div[name=editfieldDiv1]").css("height",($(".tableBody").children("table").height())+"px");
			$("div[name=editfieldDiv]").find("div[name=editfieldCry]").css("top",(obj.offsetTop+obj.offsetHeight)+"px");
			var formid=$("#formid").val();
			var isbill = $("#isbill").val();
			var fieldid = $(obj).children().eq(1).children("a").attr("_fieldid");
			$("div[name=editfieldDiv]").find("[name=fieldid]").val(fieldid);
			$.ajax({
				url : "/workflow/exceldesign/excelGetFieldOperat.jsp",
				type : "post",
				data : {formid:formid,isbill:isbill,fieldid:fieldid,method:"getfield",isDetail:isDetail},
				dataType:"JSON",
				success : function do4Success(msg){
					msg = jQuery.trim(msg);
					if(!msg)return;
					var result = JSON.parse(msg);
					$("div[name=editfieldDiv]").find("#cnlabel").val(result._cn);
					$("div[name=editfieldDiv]").find("#enlabel").val(result._en);
					$("div[name=editfieldDiv]").find("#twlabel").val(result._tw);
				}
			});
		});
    },function(){
    	var obj = this;
    	if($(obj).attr("target") === "on") return;
    	$(obj).removeClass("current");
    	$(this).children().find("div[name=editfieldImg]").remove();
    });
	
}

function saveEditFieldName(){
	var formid=$("#formid").val();
	var isbill=$("#isbill").val();
	var _cn = $("div[name=editfieldDiv]").find("#cnlabel").val();
	var _en = $("div[name=editfieldDiv]").find("#enlabel").val();
	var _tw = $("div[name=editfieldDiv]").find("#twlabel").val();
	var fieldid = $("div[name=editfieldDiv]").find("[name=fieldid]").val();
	if(!_cn){ window.top.Dialog.alert("必要信息不完整！");return;}
	
	$.ajax({
		url : "/workflow/exceldesign/excelGetFieldOperat.jsp",
		type : "post",
		data : {formid:formid,isbill:isbill,fieldid:fieldid,method:"savefield",_cn:_cn,_en:_en,_tw:_tw},
		dataType:"JSON",
		success : function do4Success(msg){
			msg = jQuery.trim(msg);
			if(!msg)	return;
			jQuery("div[name=editfieldDiv]").hide();
			jQuery(".tableBody").find("a[_flag='Fname'][_fieldid='"+fieldid+"'] span").text(_cn);
			var FContentObj = jQuery(".tableBody").find("a[_flag='Fcontent'][_fieldid='"+fieldid+"']");
			FContentObj.attr("title",_cn+"(ID:"+fieldid+")");
			FContentObj.find("[name='fieldname']").val(_cn);
			FContentObj.find("span").text(_cn);
			if(isDetail === "on"){
				jQuery(".tableBody").find("tr[name='_sumfield']").find("a[_fieldid='"+fieldid+"']").text(_cn+"(合计)");
				jQuery("input#fieldattr"+fieldid, parentWin_Main.document).attr("fieldname", _cn);
				//解决字段名称编辑后-返回-再打开名称未被修改Bug
				parentWin_Main.detailFields=null;
				parentWin_Main.initGlobalData();
			}else{
				jQuery("input#fieldattr"+fieldid).attr("fieldname", _cn);
			}
	   		var dataobj = getCurrentDataObj();
			var sheet = getCurrentSheet();
			if(dataobj && dataobj.ecs){
				for(var cellid in dataobj.ecs){
					var cellobj = dataobj.ecs[cellid];
					if(cellobj.efieldid+"" ===  fieldid+""){
						var ar = cellobj.id.split(",")[0];
						var ac = cellobj.id.split(",")[1];
						if(cellobj.etype === celltype.FNAME || cellobj.etype === celltype.FCONTENT){
							if(cellobj.etype === celltype.FCONTENT && cellobj.formula)
								sheet.getCell(ar, ac, $.wijmo.wijspread.SheetArea.viewport).value(_cn+" (fx)");
							else
								sheet.getCell(ar, ac, $.wijmo.wijspread.SheetArea.viewport).value(_cn);
						}else if(isDetail === "on" && (cellobj.etype === celltype.SUMFNAME || cellobj.etype === celltype.SUMFCONTENT)){
							sheet.getCell(ar, ac, $.wijmo.wijspread.SheetArea.viewport).value(_cn+"(合计)");
						}
					}
				}
			}
		}
	});
}

function cancelEditFieldName(){
	$("div[name=editfieldDiv]").hide();
}

/**
 * 解析JSON，拼接主字段的html
 * @param {} flag	1为右侧选择框；2为单元格下拉字段名；3为单元格下拉表单内容
 * @param {} fieltVal	过滤值
 */
function getMainFieldHtml(flag,filterVal){
	var _html='';
	var j=0;
	var tabValue=mainFields.tabValue;
	for(var i=0;i<tabValue.length;i++){
		var fieldid=tabValue[i].fieldid;
		var fieldname=tabValue[i].fieldname;
		var fieldnamepy=tabValue[i].fieldnamepy;
		var fieldtype=tabValue[i].fieldtype;
		var fieldtypedetail=tabValue[i].fieldtypedetail;
		var fielddbtype=tabValue[i].fielddbtype;
		if(!!filterVal){
			if(fieldname.toLowerCase().indexOf(filterVal)==-1&&fieldnamepy.toLowerCase().indexOf(filterVal)==-1){
				continue;
			}
		}
		if(flag===1){
			var havecss1 = "";
			if(fieldAttrHaveMap["Fname+"+fieldid] === "1")
				havecss1 = "style=\"color:#aeaeae;\"";
			var havecss2 = "";
			if(fieldAttrHaveMap["Fcontent+"+fieldid] === "1")
				havecss2 = "style=\"color:#aeaeae;\"";
			
			if(fieldid>0)
				_html += '<tr name="_fieldtrinexceldesign"><td class="rightBorder">';
			else
				_html += '<tr><td class="rightBorder">';
			_html += '<a _flag="Fname" '+havecss1+' _fieldid="'+fieldid+'">';
			_html += '<span>'+fieldname+'</span></a></td>';
			_html += '<td><a _flag="Fcontent" '+havecss2+' _fieldid="'+fieldid+'" title="'+fieldname+'(ID:'+fieldid+')">';
			_html += '<input type="hidden" name="fieldname" value="'+fieldname+'" />';
			_html += '<input type="hidden" name="fieldtype" value="'+fieldtype+'" />';
			_html += '<input type="hidden" name="fieldtypedetail" value="'+fieldtypedetail+'" />';
			_html += '<input type="hidden" name="fielddbtype" value="'+fielddbtype+'" />';
			_html += '<span>'+fieldname+'</span></a></td>';
			_html += '</tr>';
		}else{
			j++;
			if(j===9)	break;
			var className=(j%2==1?"ac_even":"ac_odd");
			var _flag='';
			if(flag===2)	_flag="Fname";
			if(flag===3) 	_flag="Fcontent";
			_html += '<li class="'+className+'" title="'+fieldname+'" _flag="'+_flag+'" _fieldid="'+fieldid+'">';
			if(flag===3){
				_html += '<input type="hidden" name="fieldname" value="'+fieldname+'" />';
				_html += '<input type="hidden" name="fieldtype" value="'+fieldtype+'" />';
				_html += '<input type="hidden" name="fieldtypedetail" value="'+fieldtypedetail+'" />';
				_html += '<input type="hidden" name="fielddbtype" value="'+fielddbtype+'" />';
			}
			_html += fieldname+'</li>';
		}
	}
	return _html;
}

/**
 * 解析JSON，拼接节点的html
 * @param {} flag	1为右侧选择框；2为单元格下拉节点名称；3为单元格下拉流转意见
 * @param {} fieltVal	过滤值
 */
function getNodeHtml(flag,filterVal){
	var _html='';
	var j=0;
	var nodes=WfNodes.nodes;
	for(var i=0;i<nodes.length;i++){
		var nodeid=nodes[i].nodeid;
		var nodename=nodes[i].nodename;
		var nodenamepy=nodes[i].nodenamepy;
		if(!!filterVal){
			if(nodename.toLowerCase().indexOf(filterVal)==-1&&nodenamepy.toLowerCase().indexOf(filterVal)==-1){
				continue;
			}
		}
		if(flag===1){
			var havecss1 = "";
			if(fieldAttrHaveMap["Nname+"+nodeid] === "1")
				havecss1 = "style=\"color:#aeaeae;\"";
			var havecss2 = "";
			if(fieldAttrHaveMap["Nadvice+"+nodeid] === "1")
				havecss2 = "style=\"color:#aeaeae;\"";
				
			_html += '<tr><td class="rightBorder">';
			_html += '<a _flag="Nname" '+havecss1+' _nodeid="'+nodeid+'">'+nodename+'</a></td>';
			_html += '<td><a _flag="Nadvice" '+havecss2+' _nodeid="'+nodeid+'">'+nodename+'</a></td>';
			_html += '</tr>';
		}else{
			j++;
			if(j===9)	break;
			var className=(j%2==1?"ac_even":"ac_odd");
			var _flag='';
			if(flag===2)	_flag="Nname";
			if(flag===3) 	_flag="Nadvice";
			_html += '<li class="'+className+'" title="'+nodename+'" _flag="'+_flag+'" _nodeid="'+nodeid+'">';
			_html += nodename+'</li>';
		}
	}
	return _html;
}

/**
 * 设置字段属性（0:不显示,1:显示,2:可编辑,3:必填）
 */
function setFieldAttr(fieldid,fieldattr){
	if(isDetail === "on")
		$("#fieldattr"+fieldid, parentWin_Main.document).val(fieldattr);
	else
		$("#fieldattr"+fieldid).val(fieldattr);
}

function resetFieldAttrHaveMap(){
	if(!!fieldAttrHaveMap){
		fieldAttrHaveMap = {};
		$(".tableBody").find("a[_flag=Fname],a[_flag=Fcontent],a[_flag=Nname],a[_flag=Nadvice]").removeAttr("style");
		$("input[id^=fieldattr]").removeAttr("havefname").removeAttr("havefcontent");
	}
}

function setFieldAttrHave(fieldid,type,ishave){
	if(type === celltype.FNAME || type === celltype.FCONTENT || type === celltype.SUMFNAME || type === celltype.SUMFCONTENT){
		var _fieldattrObj = $("#fieldattr"+fieldid);
		if(isDetail === "on")
			_fieldattrObj = $("#fieldattr"+fieldid, parentWin_Main.document);
		var _fieldObj = $("[_flag="+type+"][_fieldid="+fieldid+"]");
		if(ishave == 0){
			_fieldattrObj.removeAttr("have"+type);
			if(type === celltype.SUMFNAME || type === celltype.SUMFCONTENT)
				_fieldObj.css("color","#ff0000");
			else
				_fieldObj.css("color","#464646");
			delete fieldAttrHaveMap[type+"+"+fieldid];
		}else if(ishave == 1){
			_fieldattrObj.attr("have"+type, ishave);
			if(type === celltype.SUMFNAME || type === celltype.SUMFCONTENT)
				_fieldObj.css("color","#ffa6a1");
			else
				_fieldObj.css("color","#aeaeae");
			fieldAttrHaveMap[type+"+"+fieldid] = "1";
		}
	}else if(type === celltype.NNAME ||　type === celltype.NADVICE){
		var _nodeObj = $("[_flag="+type+"][_nodeid="+fieldid+"]");
		if(ishave == 0){
			_nodeObj.css("color","#464646").removeAttr("have"+type);
			delete fieldAttrHaveMap[type+"+"+fieldid];
		}else if(ishave == 1){
			_nodeObj.css("color","#aeaeae").attr("have"+type,ishave);
			fieldAttrHaveMap[type+"+"+fieldid] = "1";
		}
	}
}

function getFieldAttrHave(fieldid, type){
	if(type === celltype.FNAME || type === celltype.FCONTENT || type === celltype.SUMFNAME || type === celltype.SUMFCONTENT){
		var _fieldattrObj = $("#fieldattr"+fieldid);
		if(isDetail === "on")
			_fieldattrObj = $("#fieldattr"+fieldid, parentWin_Main.document);
		return _fieldattrObj.attr("have"+type);
	}else if(type === celltype.NNAME ||　type === celltype.NADVICE){
		return $("[_flag="+type+"][_nodeid="+fieldid+"]").attr("have"+type);
	}
}

function judgeFieldExist(fieldid){
	if(isDetail === "on"){
		if($("#hiddenAttrDiv #fieldattr"+fieldid, parentWin_Main.document).size() > 0)
			return true;
	}else{
		if($("#hiddenAttrDiv #fieldattr"+fieldid).size() > 0)
			return true;
	}
	return false;
}

function getFieldName(fieldid){
	if(isDetail === "on"){
		return $("#fieldattr"+fieldid, parentWin_Main.document).attr("fieldname");
	}else{
		return $("#fieldattr"+fieldid).attr("fieldname");
	}
}

/**
 * 获取隐藏域字段属性（0:不显示,1:显示,2:可编辑,3:必填）
 */
function getFieldAttr(fieldid){
	if(isDetail === "on"){
		return $("#fieldattr"+fieldid, parentWin_Main.document).val();
	}else{
		return $("#fieldattr"+fieldid).val();
	}
}

/**
 * 隐藏域get/set方法
 */
function getDataJson(){
	return $("#datajson").text();		//不能用.html,.html会将&<>转译
}

function getSheetJson(){
	return $("#pluginjson").text();
}

function getDetailNum(){
	return $("#detailnum").val();
}

function setCodeHtml(scripts){
	$("#scripts").val(scripts);
}

function getCodeHtml(){
	return $("#scripts").val();
}

/**
 * 表单提交后台保存
 */
function saveLayout(){
	if(wfinfo.layouttype === "0" && wfinfo.isactive === "1"){
		//将模板中不存在的字段属性全部置为不显示
		jQuery("#hiddenAttrDiv").find("[id^=fieldattr]").each(function(){
			var nodetype = parseInt($(this).attr("nodetype"));
			if($(this).val() !== "0"){
				if(nodetype === -1){	//主表字段根据隐藏域属性判断
					if($(this).attr("havefcontent") != "1")
						$(this).val("0");
				}else{		//明细表可能未打开就保存，故从缓存判断
					var detail_symbol = "detail_"+(nodetype+1);
					if(globalData.hasCache(detail_symbol)){
						var detail_datajson_str = globalData.getCacheValue(detail_symbol);
						var field_str = "\"etype\":\"3\",\"field\":\""+$(this).attr("id").replace("fieldattr","")+"\"";
						if(detail_datajson_str.indexOf(field_str) == -1)
							$(this).val("0");
					}else{
						$(this).val("0");
					}
				}
			}
		});
		//明细表未放在模板中，取消勾选允许新增明细/必须新增明细等配置项
		jQuery("input[type='hidden'][name^=detailgroupattr]").each(function(){
			var detail_idx = jQuery(this).attr("name").replace("detailgroupattr","");
			var detail_symbol = "detail_"+(parseInt(detail_idx)+1);
			if(!globalData.hasCache(detail_symbol)){
				var new_val = jQuery(this).val().replaceAll("1", "0");
				jQuery(this).val(new_val);
			}
		});
	}
	$("#LayoutForm").attr("action","excelLayoutSave.jsp?operation=saveExcel").attr("target","_self").attr("enctype","multipart/form-data");
	$("#LayoutForm").submit();
}

/**
 * 表单预览功能
 */
function preViewLayout(){
	$("#LayoutForm").attr("action","excelPreView.jsp").attr("target","_blank");
	$("#LayoutForm").submit();
}


/*********明细表右侧属性页面引用的JS***********/


/**
 * 明细表加载字段
 */
function loadDetailTable(idx){
	var _tbody=$(".tableBody tbody");
	//避免detailFields异步未初始化完成
	if(parentWin_Main.detailFields==null){
		window.setTimeout(function(){
			loadDetailTable(idx);
		},100);
		return;
	}
	var _html=getDetailFieldHtml(1,'',idx);
	_tbody.find("tr[class!='thead']").remove();
	_tbody.append(_html);
	addMiddleBorder();
	bindTrEvent();
}

/**
 * 搜索明细表字段
 */
function searchDetailTable(idx){
	var searchVal=$("[name='searchVal']").val();
	if(searchVal.length>0){
		searchVal=searchVal.toLowerCase();
	}
	var _tbody=$(".tableBody tbody");
	var _html=getDetailFieldHtml(1,searchVal,idx);
	_tbody.find("tr[class!='thead']").remove();
	_tbody.append(_html);
	addMiddleBorder();
	bindTrEvent();
}

/**
 * 添加属性table的中间线
 */
function addMiddleBorder(){
	if($(".tableBody table").height()<$(".tableBody").height()){
		var diff=$(".tableBody").height()-$(".tableBody table").height();
		$(".tableBody table").append('<tr style="height:'+diff+'px"><td class="rightBorder"></td><td></td></tr>');
	}
}

/**
 * 解析JSON，拼接对应明细字段的html
 * @param {} flag	1为右侧选择框；2为单元格下拉字段名；3为单元格下拉表单内容
 * @param {} fieltVal	过滤值
 * @param {} detailIndex 所属明细表,从1开始
 */
function getDetailFieldHtml(flag,filterVal,detailIndex){
	var _html='';
	var j=0;
	var detailValue=parentWin_Main.detailFields["detail_"+detailIndex];
	for(var i=0;i<detailValue.length;i++){
		var fieldid=detailValue[i].fieldid;
		var fieldname=detailValue[i].fieldname;
		var fieldnamepy=detailValue[i].fieldnamepy;
		var fieldtype=detailValue[i].fieldtype;
		var fieldtypedetail=detailValue[i].fieldtypedetail;
		var fielddbtype=detailValue[i].fielddbtype;
		if(!!filterVal){
			if(fieldname.toLowerCase().indexOf(filterVal)==-1&&fieldnamepy.toLowerCase().indexOf(filterVal)==-1){
				continue;
			}
		}
		if(flag===1){
			var _fieldattrobj = $("#fieldattr"+fieldid, parentWin_Main.document);
			var havecss1 = "";
			if(fieldAttrHaveMap["Fname+"+fieldid] === "1")
				havecss1 = "style=\"color:#aeaeae;\"";
			else	//解决明细未点返回保存，而是点关闭按钮后，隐藏域里的属性任然在的问题
				_fieldattrobj.removeAttr("haveFname");
			var havecss2 = "";
			if(fieldAttrHaveMap["Fcontent+"+fieldid] === "1")
				havecss2 = "style=\"color:#aeaeae;\"";
			else
				_fieldattrobj.removeAttr("haveFcontent");
			
			_html += '<tr name="_fieldtrinexceldesign"><td class="rightBorder">';
			_html += '<a _flag="Fname" '+havecss1+' _fieldid="'+fieldid+'">';
			_html += '<span>'+fieldname+'</span></a></td>';
			_html += '<td><a _flag="Fcontent" '+havecss2+' _fieldid="'+fieldid+'" title="'+fieldname+'(ID:'+fieldid+')">';
			_html += '<input type="hidden" name="fieldname" value="'+fieldname+'" />';
			_html += '<input type="hidden" name="fieldtype" value="'+fieldtype+'" />';
			_html += '<input type="hidden" name="fieldtypedetail" value="'+fieldtypedetail+'" />';
			_html += '<input type="hidden" name="fielddbtype" value="'+fielddbtype+'" />';
			_html += '<span>'+fieldname+'</span></a></td>';
			_html += '</tr>';
			//生成合计字段TR
			var issumfield = detailValue[i].issumfield;
			if(!!issumfield && issumfield == "y"){
				var color1 = "#ff0000";
				if(fieldAttrHaveMap["SumFname+"+fieldid] === "1")
					color1 = "#ffa6a1";
				else
					_fieldattrobj.removeAttr("haveSumFname");
				var color2 = "#ff0000";
				if(fieldAttrHaveMap["SumFcontent+"+fieldid] === "1")
					color2 = "#ffa6a1";
				else
					_fieldattrobj.removeAttr("haveSumFcontent");
				
				_html += '<tr name="_sumfield" class="belSeniorSet" ';
				if(!detailOperate.hasOpenSeniorSet())
					_html += ' style="display:none" ';
				_html += '><td class="rightBorder">';
				_html += '<a _flag="SumFname" class="hoverred" style="color:'+color1+';" _fieldid="'+fieldid+'">'+fieldname+'(合计)</a></td>';
				_html += '<td><a _flag="SumFcontent" class="hoverred" style="color:'+color2+';" _fieldid="'+fieldid+'">'+fieldname+'(合计)</a></td>';
				_html += '</tr>';
			}
		}else{
			j++;
			if(j===9)	break;
			var className=(j%2==1?"ac_even":"ac_odd");
			var _flag='';
			if(flag===2)	_flag="Fname";
			if(flag===3) 	_flag="Fcontent";
			_html += '<li class="'+className+'" title="'+fieldname+'" _flag="'+_flag+'" _fieldid="'+fieldid+'">';
			if(flag===3){
				_html += '<input type="hidden" name="fieldname" value="'+fieldname+'" />';
				_html += '<input type="hidden" name="fieldtype" value="'+fieldtype+'" />';
				_html += '<input type="hidden" name="fieldtypedetail" value="'+fieldtypedetail+'" />';
				_html += '<input type="hidden" name="fielddbtype" value="'+fielddbtype+'" />';
			}
			_html += fieldname+'</li>';
		}
	}
	return _html;
}

/**
 * 返回时获得明细权限
 */
function getGroupAttr(){
	var groupattr="";
	if($("#dtladd").attr("checked")){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if($("#dtledit").attr("checked")){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if($("#dtldel").attr("checked")){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if($("#dtlhide").attr("checked")){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if($("#dtldef").attr("checked")){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if($("#dtlned").attr("checked")){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if($("#dtlmul").attr("checked")){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if($("#dtlprintserial").attr("checked")){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if($("#dtlallowscroll").attr("checked")){
		groupattr += "1";
	}else{
		groupattr += "0";
	}
	if(!!$("#dtl_defrow").val()){
		groupattr += "*"+$("#dtl_defrow").val();
	}else{
		groupattr += "*0";
	}
	return groupattr;
}

function onNotEdit(obj){
	if($(obj).is(":checked"))
		$(".excelHeadContent").find("div[name=canwrite],div[name=required]").addClass("shortBtn_disabled").removeClass("shortBtn");
	else
		$(".excelHeadContent").find("div[name=canwrite],div[name=required]").addClass("shortBtn").removeClass("shortBtn_disabled");
}

function changeInputState(obj,inputName){
	var inputobj=$("input[name='"+inputName+"']");
	if(obj.checked){
		inputobj.attr("disabled",false);
	}else{
		inputobj.attr("disabled",true);
	}
}

function checkChange(){
	var obj=$("#dtladd")
	if(obj.attr("checked")){
   		jQuery("[name=dtlned]").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
   		jQuery("[name=dtldef]").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
   		if(jQuery("[name=dtldef]").attr("checked")){
   			jQuery("[name=dtl_defrow]").attr("disabled",false);
		}
   		jQuery("[name=dtlmul]").attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
	}else{
    	jQuery("[name=dtlned]").attr("disabled",true).attr("checked",false).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled");
   		jQuery("[name=dtldef]").attr("disabled",true).attr("checked",false).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled");
   		jQuery("[name=dtl_defrow]").attr("disabled",true);
   		jQuery("[name=dtlmul]").attr("disabled",true).attr("checked",false).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled");
    }
}

function linkhelp(){
	var url = "http://www.e-cology.com.cn/formmode/apps/ktree/viewdocument.jsp?newDate=1432796806228&versionid=1&functionid=20837&tabid=2";
	window.open(url);
}

//Input只能输入数字
function ItemCount_KeyPress() {
	var evt = getEvent();
	var keyCode = evt.which ? evt.which : evt.keyCode;
	if(!((keyCode>=48) && (keyCode<=57))){
		if(evt.keyCode){
			evt.keyCode = 0;evt.returnValue=false;     
		} else {
			evt.which = 0;evt.preventDefault();
		}
	}
}

function getEvent() {
	if (window.ActiveXObject) {
		return window.event;// 如果是ie
	}
	func = getEvent.caller;
	while (func != null) {
		var arg0 = func.arguments[0];
		if (arg0) {
			if ((arg0.constructor == Event || arg0.constructor == MouseEvent)
					|| (typeof (arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
				return arg0;
			}
		}
		func = func.caller;
	}
	return null;
}

function checkRequired(obj,spanid){
	var tmpvalue = obj.value;
	while(tmpvalue.indexOf(" ") >= 0){
		tmpvalue = tmpvalue.replace(" ", "");
	}
	if(tmpvalue != ""){
		while(tmpvalue.indexOf("\r\n") >= 0){
			tmpvalue = tmpvalue.replace("\r\n", "");
		}
		if(tmpvalue != ""){
			$(obj).siblings("#"+spanid).html("");
		}else{
			$(obj).siblings("#"+spanid).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		}
	}else{
		$(obj).siblings("#"+spanid).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	}
}
