/**
 * 属性缓存，首先存控件的，可以层级关系
 * 如spreadjs，先存（gridUID），然后cell_p;再其他单元格的扩展属性；
 * @return {Object}
 */
function scpCache() {
    var cache = {};
    return {
        /**
         * 将数据添加到缓存里面
         * @param key   键
         * @param value  值
         */
        addCache:function (key, value) {
            //如果缓存中没有该值，直接将值置于缓存中
            if (!(key  in  cache)) {
                cache[key] = value;
            } else {
                delete  cache[key];
                cache[key] = value;
            }
        },
        //判断缓存中是否有该键值对
        isInCache:function (key) {
            if (key  in  cache)
                return true;
            return false;

        },
        /**
         * 移除缓存中的数据
         * @param key  键
         */
        removeCache:function (key) {
            //清除缓存中的数据
            if (key  in cache) {
                delete  cache[key];
            }

        },
        //移除所有缓存中的数据
        removeAllCache:function ()
        {
        	for(key in cache)
        		delete  cache[key];
        },
        /**
         * 根据键值获取缓存中的值
         * @param key  键
         */
        getCacheValue:function (key) {
            if (key in  cache)
                return cache[key];
            return "";

        },
        /**
         * 返回cache对象
         */
        getCache:function () {
            return cache;
        },
        /**
         * 返回cache对象的大小
         */
        getCacheSize:function()
        {
        	var i=0;
        	for(key in cache)
        		i++;
        	return i;
        }

    }

};
var forBug_copyvalue = "";
var scpmanager = new scpCache();
//设置全局变量,属性管理器
function registerscp(obj,id) {
	if (!scpmanager.isInCache(id)) {
		var control = controlEncapsulation(obj,id);	//封装控件
		var table_o = {};
	    table_o.id = id;
	    var table_p = new etable(table_o);
	    control.setDataObj(table_p);
		scpmanager.addCache(id, control);
	}
}

/**
 * 控件封装 主要是用于 解决 明细 存储
 */
function controlEncapsulation(o, tabid) {
    //判断控件选中与否
    var tabidentity = tabid;
    var dataobj = undefined;
    var formula = undefined;
    return {
        /**
         * 获取控件信息
         * @return {*}
         */
        getControl:function () {
            return o;
        },
        setControl:function (obj) {
            o = obj;
        },
        setDataObj:function (obj) {
            dataobj = obj;
        },
        getDataObj:function () {
            return dataobj;
        },
        getControlId:function () {
            return o.attr("excelid");
        },
        setOneFormula:function (key,value) {
        	formula[key] = value;
        },
        getFormulas:function () {
        	return formula;
        },
        delOneFormula:function(key) {
        	delete formula[key];
        },
        getOneFormula:function (key) {
        	return formula[key];
        },
        initFormulas:function()
        {
        	formula = {};
        }
    }
}

/**
 * get/set ActiveExcelId 获取当前操作的Excel设计面板
 */
var activeExcelid;  ///全局
function  getActiveExcelId()
{
    return activeExcelid;
}
function setActiveExcelId(excelid)
{
	activeExcelid = excelid;
}
function bindSpreadEvent4Formula(spread)
{
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
		       			restr += ","+sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1);
		       			restr += ":"+sheet.getValue(0,ac+cc-1,$.wijmo.wijspread.SheetArea.colHeader)+(ar+rc);
	       			}else{
	       				restr = sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1);
		       			restr += ":"+sheet.getValue(0,ac+cc-1,$.wijmo.wijspread.SheetArea.colHeader)+(ar+rc);
		       		}
        		}else{
        			var ar = sels[i].row;
        			var ac = sels[i].col;
        			if(!!restr)
        				restr += ","+sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1);
        			else
        				restr = sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1);
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
       			restr = sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1);
       			restr += ":"+sheet.getValue(0,ac+cc-1,$.wijmo.wijspread.SheetArea.colHeader)+(ar+rc)
       		}else{
       			var ar = sels[0].row;
       			var ac = sels[0].col;
   				restr = sheet.getValue(0,ac,$.wijmo.wijspread.SheetArea.colHeader)+(ar+1);
       		}
        }
        $(window.top.formula_dialog.innerDoc).find("#selectcellTxt").val(restr);
        //console.dir(restr);
    });
}
//绑定表格事件
function  bindSpreadEvent(spread)
{
    spread.useWijmoTheme = false;
    var sheet = spread.getActiveSheet();
    sheet.canUserDragDrop(false);
    sheet.canUserDragFill(false);
    spread.canUserEditFormula(false);
    spread.allowUndo(false);
    var curcanvas = $(sheet._getCanvas());
	if(!!spread.backgroundImage())	
	{
		jQuery(".excelHeadContent").find("[name=clearBgImg]").removeClass("shortBtn_disabled").addClass("shortBtn");;
		//jQuery(".excelHeadContent").find("[name=clearBgImg]").show();
		var st = setTimeout(function(){
 			clearTimeout(st);
  			var canvas = $(sheet._getCanvas());
  			canvas.css("background-position", "40px 20px");
 		},200);
	}	  						  		
	sheet.addKeyMap($.wijmo.wijspread.Key.del, false, false, false, false, excelBaseOperat.cleanContentBxFace);
    /*sheet.bind($.wijmo.wijspread.Events.EnterCell,function(event,data){
        var cellid = data.row + "," + data.col;
       
    });*/

    //监听横向滚动条
    sheet.bind($.wijmo.wijspread.Events.LeftColumnChanged,function(event,data){
    	if(!spread.backgroundImage())return;
    	var oldLeftCol = data.oldLeftCol;
    	var newLeftCol = data.newLeftCol;
    	var cw = 0;
    	for(var i=0;i<Math.abs(newLeftCol-oldLeftCol);i++)
    		if(newLeftCol-oldLeftCol > 0)
    			cw += sheet.getColumnWidth(oldLeftCol + i ,$.wijmo.wijspread.SheetArea.viewport);
    		else
    			cw += sheet.getColumnWidth(newLeftCol + i,$.wijmo.wijspread.SheetArea.viewport);
    	var oldposition = curcanvas.css("background-position-x");
    	if(oldposition.indexOf("px")) oldposition = parseFloat(oldposition.split("px")[0]);
    	var newposition;
   		if(newLeftCol-oldLeftCol > 0)
   			newposition = oldposition - cw;
   		else
   			newposition = oldposition + cw;
   		curcanvas.css("background-position-x",newposition+"px");
    });
    //监听纵向滚动条
    sheet.bind($.wijmo.wijspread.Events.TopRowChanged,function(event,data){
    	if(!spread.backgroundImage())return;
    	//先判断是否有背景图
    	var oldTopRow = data.oldTopRow;
    	var newTopRow = data.newTopRow;
		var rh = 0;
    	for(var i=0;i<Math.abs(newTopRow-oldTopRow);i++)
    		if(newTopRow-oldTopRow > 0)
    			rh += sheet.getRowHeight(oldTopRow + i ,$.wijmo.wijspread.SheetArea.viewport);
    		else
    			rh += sheet.getRowHeight(newTopRow + i,$.wijmo.wijspread.SheetArea.viewport);
    	var oldposition = curcanvas.css("background-position-y");
    	if(oldposition.indexOf("px")) oldposition = parseFloat(oldposition.split("px")[0]);
    	var newposition;
   		if(newTopRow-oldTopRow > 0)
   			newposition = oldposition - rh;
   		else
   			newposition = oldposition + rh;
   		curcanvas.css("background-position-y",newposition+"px");
    });
    
    //编辑前事件
    sheet.bind($.wijmo.wijspread.Events.EditStarting, function (event, data) {
        if(isAutoCompleteKeyDown>0){
        	isAutoCompleteKeyDown = 0;
        	prevTimeInputvalue = "";
        	sheet.addKeyMap($.wijmo.wijspread.Key.up, false, false, false, false, $.wijmo.wijspread.SpreadActions.navigationUp);
			sheet.addKeyMap($.wijmo.wijspread.Key.down, false, false, false, false, $.wijmo.wijspread.SpreadActions.navigationDown);
			sheet.addKeyMap($.wijmo.wijspread.Key.left, false, false, false, false, $.wijmo.wijspread.SpreadActions.navigationLeft);
			sheet.addKeyMap($.wijmo.wijspread.Key.right, false, false, false, false, $.wijmo.wijspread.SpreadActions.navigationRight);
			sheet.addKeyMap($.wijmo.wijspread.Key.enter, false, false, false, false, $.wijmo.wijspread.SpreadActions.navigationDown);
        }	
    });
    
    //编辑后事件
    sheet.bind($.wijmo.wijspread.Events.EditEnd, function (event, data) {
    	if(data.editingText != null){
    		if(data.row === sheet.getRowCount()-1)
    			excelBaseOperat.insertRowandCol4LastFace("row");
    		if(data.col === sheet.getColumnCount()-1)
    			excelBaseOperat.insertRowandCol4LastFace("col");
	        //如果有自动换行符，则自动把改单元格设置为自动换行
			if(data.editingText.search(/\r\n|\r|\n/) > -1){
				sheet.getCell(data.row,data.col,sheet.sheetArea).wordWrap(true);
				jQuery("div[name=autowrap]").attr("down","on").addClass("shortBtnHover");
			}
			
			//重置事件和公共变量 ===  Start === 
       		sheet.addKeyMap($.wijmo.wijspread.Key.up, false, false, false, false, $.wijmo.wijspread.SpreadActions.navigationUp);
			sheet.addKeyMap($.wijmo.wijspread.Key.down, false, false, false, false, $.wijmo.wijspread.SpreadActions.navigationDown);
			sheet.addKeyMap($.wijmo.wijspread.Key.left, false, false, false, false, $.wijmo.wijspread.SpreadActions.navigationLeft);
			sheet.addKeyMap($.wijmo.wijspread.Key.right, false, false, false, false, $.wijmo.wijspread.SpreadActions.navigationRight);
			sheet.addKeyMap($.wijmo.wijspread.Key.enter, false, false, false, false, $.wijmo.wijspread.SpreadActions.navigationDown);
			isAutoCompleteKeyDown = 0;
           	prevTimeInputvalue = "";
           	
           	//重置事件和公共变量 ===  End === 
           	var control = scpmanager.getCacheValue(getActiveExcelId());
			var dataobj = control.getDataObj();
           	//如果该单元格 已经存在 并且 是非Txt的，那么不能再设置了
       		var cellid = data.row + "," + data.col;
	        if(dataobj.ecs != undefined){
	        	//console.dir(dataobj.ecs);
	            if(dataobj.ecs[cellid] != undefined){
	            	if(dataobj.ecs[cellid].etype === celltype.FNAME || dataobj.ecs[cellid].etype === celltype.FCONTENT
                		|| dataobj.ecs[cellid].etype === celltype.NNAME || dataobj.ecs[cellid].etype === celltype.NADVICE 
                		|| dataobj.ecs[cellid].etype === celltype.LINKTEXT || dataobj.ecs[cellid].etype === celltype.IMAGE);
                	else{
                		var cell = {};
						cell.evalue = data.editingText;
						setCellProperties(cellid,celltype.TEXT,cell);
					}
				}else{
					var cell = {};
					cell.evalue = data.editingText;
					setCellProperties(cellid,celltype.TEXT,cell);
				}
			}
		}

    });
    //单元格点击事件
    sheet.bind($.wijmo.wijspread.Events.CellClick, function (event, data) {
    	spreadCellClick(data);		//改变相关样式选中状态
    	setOperatCellREM(data);		//改变字段属性选中状态
    	controlInsertLimits();
    });
    
    //单元格选中
    sheet.bind($.wijmo.wijspread.Events.SelectionChanged,function(event,data){
    	if($(".excelHeadTable").find("div[name=formatrush]").is(".shortBtnHover")){
    		sheet.setIsProtected(false);
    		$.wijmo.wijspread.SpreadActions.paste.call(sheet,"style");
    	}else{
	    	var cellid = data.sheet._activeRowIndex + "," + data.sheet._activeColIndex;
			var control = scpmanager.getCacheValue(getActiveExcelId());
			var dataobj = control.getDataObj();
			if(sheet._clipboardHelper.isCutting){
	    		sheet.setIsProtected(false);
	   		}else{
				if(dataobj.ecs != undefined){
		            if(dataobj.ecs[cellid] != undefined){
		                if(dataobj.ecs[cellid].etype === celltype.DETAIL || dataobj.ecs[cellid].etype === celltype.DE_TITLE
		                	|| dataobj.ecs[cellid].etype === celltype.DE_TAIL || dataobj.ecs[cellid].etype === celltype.DE_BTN
		                	|| dataobj.ecs[cellid].etype === celltype.FNAME || dataobj.ecs[cellid].etype === celltype.FCONTENT
		                	|| dataobj.ecs[cellid].etype === celltype.NNAME || dataobj.ecs[cellid].etype === celltype.NADVICE){
		                	sheet.setIsProtected(true);
		                }else{
		                    sheet.setIsProtected(false);
		                }
		            }else
		                sheet.setIsProtected(false);
		        }
	        }
        }
    });
	
	//单元格 双击事件
	sheet.bind($.wijmo.wijspread.Events.CellDoubleClick,function(event, data){
		if(isEditFormulaing) return;
		var cellid = data.row + "," + data.col;
		var control = scpmanager.getCacheValue(getActiveExcelId());
		var dataobj = control.getDataObj();
		
        if(dataobj.ecs != undefined){
            if(dataobj.ecs[cellid] != undefined){
            	if(dataobj.ecs[cellid].etype === celltype.DETAIL){	
            		//open setDetailTable window
            		sheet.setIsProtected(true);
            		openDetailWin(dataobj.ecs[cellid].edetail);
            	}else if(dataobj.ecs[cellid].formula){
            		sheet.setIsProtected(true);
            		excelBaseOperat.openFormulaWinFace(dataobj.ecs[cellid].formula);
            	}else if(dataobj.ecs[cellid].etype === celltype.FNAME || dataobj.ecs[cellid].etype === celltype.NNAME
            		|| dataobj.ecs[cellid].etype === celltype.FCONTENT || dataobj.ecs[cellid].etype === celltype.NADVICE){
            		sheet.setIsProtected(true);
            		if(dataobj.ecs[cellid].financial){
		           		var fdialog = new window.top.Dialog();
						fdialog.currentWindow = window;
						var url = "/workflow/exceldesign/excelSetFinancial.jsp?financial="+dataobj.ecs[cellid].financial;
						fdialog.Title = "财务格式设置";
						fdialog.Width = 450;
						fdialog.Height = 220;
						fdialog.Drag = true; 	
						fdialog.normalDialog = false;
						fdialog.URL = url;
						fdialog.show();
						fdialog.callbackfun = function (paramobj, result) {
							if(dataobj.ecs[cellid].financial.indexOf("1-") >= 0)
								dataobj.ecs[cellid].financial = "1"+result;
							else if(dataobj.ecs[cellid].financial.indexOf("2-") >= 0)
								dataobj.ecs[cellid].financial = "2"+result;
						}
					}
           		}
            }
        }
	});
	var prevTimeInputvalue = "";
	//用于监听单元格输入变化，"$","^","#","%"这些关键字符输入时联想方法；
	sheet.bind($.wijmo.wijspread.Events.EditChange,function(event, data){
		var isNotSame = false;
		if(data.editingText != prevTimeInputvalue)
			prevTimeInputvalue =data.editingText;
		else
			isNotSame = true;
		if(isAutoCompleteKeyDown>0 && isNotSame)
			return;
		if(data.editingText != null){
			//获取检索值
			var filterVal='';
			if(data.editingText.length>1){
				filterVal=data.editingText.substr(1).toLowerCase();
			}
			//1、输入“#”+字母，可筛选主表字段的“字段名”填充；
			if(data.editingText.substring(0,1) === "#"){
				var autoCompleteHtml;
				if(isDetail === "on")
					autoCompleteHtml = getDetailFieldHtml(2,filterVal,detailIdenty);
				else
				 	autoCompleteHtml = getMainFieldHtml(2,filterVal);	
				showAutoCompleteDiv(autoCompleteHtml);
				sheet.addKeyMap($.wijmo.wijspread.Key.up, false, false, false, false, null);
				sheet.addKeyMap($.wijmo.wijspread.Key.down, false, false, false, false, null);
				sheet.addKeyMap($.wijmo.wijspread.Key.left, false, false, false, false, null);
				sheet.addKeyMap($.wijmo.wijspread.Key.right, false, false, false, false, null);
				sheet.addKeyMap($.wijmo.wijspread.Key.enter, false, false, false, false, autoCompleteEnterKeyDown);
			}
			//2、输入“$”+字母，可筛选主表字段的“表单内容”填充；
			if(data.editingText.substring(0,1) === "$"){
				var autoCompleteHtml;
				if(isDetail === "on")
					autoCompleteHtml = getDetailFieldHtml(3,filterVal,detailIdenty);
				else
					autoCompleteHtml = getMainFieldHtml(3,filterVal);
				showAutoCompleteDiv(autoCompleteHtml);
				sheet.addKeyMap($.wijmo.wijspread.Key.up, false, false, false, false, null);
				sheet.addKeyMap($.wijmo.wijspread.Key.down, false, false, false, false, null);
				sheet.addKeyMap($.wijmo.wijspread.Key.left, false, false, false, false, null);
				sheet.addKeyMap($.wijmo.wijspread.Key.right, false, false, false, false, null);
				sheet.addKeyMap($.wijmo.wijspread.Key.enter, false, false, false, false, autoCompleteEnterKeyDown);
			}
			//3、输入“%”+字母，可筛选流程“节点名称”填充；
			if(data.editingText.substring(0,1) === "%"){
				var autoCompleteHtml = getNodeHtml(2,filterVal);
				showAutoCompleteDiv(autoCompleteHtml);
				sheet.addKeyMap($.wijmo.wijspread.Key.up, false, false, false, false, null);
				sheet.addKeyMap($.wijmo.wijspread.Key.down, false, false, false, false, null);
				sheet.addKeyMap($.wijmo.wijspread.Key.left, false, false, false, false, null);
				sheet.addKeyMap($.wijmo.wijspread.Key.right, false, false, false, false, null);
				sheet.addKeyMap($.wijmo.wijspread.Key.enter, false, false, false, false, autoCompleteEnterKeyDown);
			}
			//4、输入“^”+字母，可筛选“流转意见”填充。
			if(data.editingText.substring(0,1) === "^"){
				var autoCompleteHtml = getNodeHtml(3,filterVal);
				showAutoCompleteDiv(autoCompleteHtml);
				sheet.addKeyMap($.wijmo.wijspread.Key.up, false, false, false, false, null);
				sheet.addKeyMap($.wijmo.wijspread.Key.down, false, false, false, false, null);
				sheet.addKeyMap($.wijmo.wijspread.Key.left, false, false, false, false, null);
				sheet.addKeyMap($.wijmo.wijspread.Key.right, false, false, false, false, null);
				sheet.addKeyMap($.wijmo.wijspread.Key.enter, false, false, false, false, autoCompleteEnterKeyDown);
			}
		}
	});
	
	function autoCompleteEnterKeyDown()
	{
		var gcEditingInput = jQuery("textArea[gcuielement=gcEditingInput]");
		var currentTarget = gcEditingInput.parent("div").find(".ac_results ul li.selected");
		var targetid = "";
   		if($(currentTarget).attr("_fieldid"))
   			targetid |=$(currentTarget).attr("_fieldid");
   		if($(currentTarget).attr("_nodeid"))
   			targetid |= $(currentTarget).attr("_nodeid");
   		
   		var flag = $(currentTarget).attr("_flag");
       	var _txt = $(currentTarget).text();
       	var _htmltype,_type,_dbtype= "";
       	if(flag === celltype.FCONTENT)
       	{
	       	_htmltype = $(currentTarget).children("[name=fieldtype]").val();
	       	_type = $(currentTarget).children("[name=fieldtypedetail]").val();
	       	_dbtype = $(currentTarget).children("[name=fielddbtype]").val();
       	}
      	var fieldhave = getFieldAttrHave(targetid,flag);
      	if(isDetail === "on")
      		fieldhave = parentWin_Main.getFieldAttrHave(targetid,flag);
       	if(!!fieldhave){
			gcEditingInput.val("");
			gcEditingInput.parent("div").find(".ac_results").remove();
		}else{
		 	setExcelBxValue(null,targetid,flag,_txt,_htmltype,_type,_dbtype);
		 	gcEditingInput.val(_txt);
		}
		sheet.moveActiveCell();
	}
	var isCutting;
	var srcRange;
	sheet.bind($.wijmo.wijspread.Events.ClipboardChanged, function (sender, args){
		isCutting = sheet._clipboardHelper.isCutting;
		srcRange = sheet.getSelections()[0];
		forBug_copyvalue = args.copyData;
		//console.dir(srcRange);
	});
	//黏贴的逻辑还是比较复杂的，考虑到倍数问题，费脑子
	sheet.bind($.wijmo.wijspread.Events.ClipboardPasted, function (sender, args){
		var isstyle=false;
		if($(".excelHeadTable").find("div[name=formatrush]").is(".shortBtnHover"))
			isstyle = true;
		var control = scpmanager.getCacheValue(getActiveExcelId());
		var dataobj = control.getDataObj();
		if(dataobj.ecs == undefined) return;
		var desRange = args.cellRange;
		//console.dir(desRange);
		if(srcRange.col == -1) srcRange.col = 0;	//说明选了整行
		if(srcRange.row == -1) srcRange.row = 0;	//整列
		if(desRange.row == -1 ) desRange.row = 0;
		if(desRange.col == -1) desRange.col = 0;
		
		if(desRange.colCount == -1) desRange.colCount = sheet.getColumnCount();
		if(desRange.rowCount == -1) desRange.rowCount = sheet.getRowCount();
		if(desRange.row+desRange.rowCount >= sheet.getRowCount()-1)
   			excelBaseOperat.insertRowandCol4LastFace("row");
   		if(desRange.col+desRange.colCount >= sheet.getColumnCount()-1)
   			excelBaseOperat.insertRowandCol4LastFace("col");
		
		var rowMulti = desRange.rowCount / srcRange.rowCount;	//复制品是原生品的行/列倍数
		var colMulti = desRange.colCount / srcRange.colCount;
		//console.log("行倍数："+rowMulti+"   列倍数："+colMulti);
		var srcarr = new Array();
		var showcantcopy = false;
		var alreadyCutAry = new Array();
       	for(var x = 0,x_x = 0; x<(srcRange.rowCount*rowMulti);x++){
       		if(x_x==srcRange.rowCount)
       			x_x = 0;
       		for(var y=0,y_y = 0;y<(srcRange.colCount*colMulti);y++){
       			try{
       				if(y_y == srcRange.colCount)
        				y_y = 0;
        			var src_r=srcRange.row+x_x;
        			var src_c=srcRange.col+y_y;
        			y_y++;
        			//console.log("源："+src_r+","+src_c);
        			var des_r = (desRange.row+x);
        			var des_c = (desRange.col+y);
        			//console.log("目的："+des_r+","+des_c);
        			if(dataobj.ecs[src_r+","+src_c] == undefined || dataobj.ecs[src_r+","+src_c] === "")
        				continue;
        			var src_cell_pro = dataobj.ecs[src_r+","+src_c];
        			if(!!src_cell_pro){
        				srcarr.push(src_cell_pro);
        				if(!isstyle){	//非格式刷
        					restoreCellProperties(des_r+","+des_c);
	        				var des_cell_pro = {};
	        				$.extend(true,des_cell_pro, src_cell_pro);
	        				//dataobj.ecs[des_r+","+des_c] = des_cell_pro;
	        				des_cell_pro.id=des_r+","+des_c;
	        				//if(des_cell_pro.etype === celltype.FNAME || des_cell_pro.etype === celltype.FCONTENT
	        				//	|| des_cell_pro.etype === celltype.NNAME ||　des_cell_pro.etype === celltype.NADVICE)
	        					alreadyCutAry.push(des_cell_pro);
	        			}else{
	        				var cell = {};
	        				var eborder = src_cell_pro.eborder;
							var efont = src_cell_pro.efont;
							var enumbric = src_cell_pro.enumbric;	//数值样式
							var ealign = src_cell_pro.ealign;
							var ebgcolor = src_cell_pro.ebgcolor;
							var etxtindent = src_cell_pro.etxtindent;
							cell.eborder = eborder;
							cell.efont = efont;
							cell.enumbric = enumbric;
							cell.ealign = ealign;
							if(!ebgcolor) ebgcolor = "transparent";
							cell.ebgcolor = ebgcolor;
							cell.etxtindent = etxtindent;
							setCellProperties(des_r+","+des_c,"",cell);
	        			}
        			}
        			
       			}catch(ex){
       				 alert(ex.message);
       			}
       		}
       		x_x++;
       	}
       	
       	//如果是剪切，需要干掉源单元格自定属性；
		if(isCutting){
			for(var z=0;z<srcarr.length;z++){
				var srcid = srcarr[z].id;
				//restoreCellProperties(srcid);
				delete dataobj.ecs[srcid];
			}
			for(var ii=0;ii<alreadyCutAry.length;ii++){
				dataobj.ecs[alreadyCutAry[ii].id] = alreadyCutAry[ii];
				if(dataobj.ecs[alreadyCutAry[ii].id].etype === celltype.FNAME || dataobj.ecs[alreadyCutAry[ii].id].etype === celltype.FCONTENT
				|| dataobj.ecs[alreadyCutAry[ii].id].etype === celltype.NNAME || dataobj.ecs[alreadyCutAry[ii].id].etype === celltype.NADVICE)
				{
					setFieldAttrHave(dataobj.ecs[alreadyCutAry[ii].id].efieldid,dataobj.ecs[alreadyCutAry[ii].id].etype,1);
				}
			}
		}else{
			for(var ii=0;ii<alreadyCutAry.length;ii++){
				dataobj.ecs[alreadyCutAry[ii].id] = alreadyCutAry[ii];
				if(dataobj.ecs[alreadyCutAry[ii].id].etype === celltype.FNAME || dataobj.ecs[alreadyCutAry[ii].id].etype === celltype.FCONTENT
				|| dataobj.ecs[alreadyCutAry[ii].id].etype === celltype.NNAME || dataobj.ecs[alreadyCutAry[ii].id].etype === celltype.NADVICE)
				{
					dataobj.ecs[alreadyCutAry[ii].id].etype = "";
					sheet.getCell(alreadyCutAry[ii].id.split(",")[0],alreadyCutAry[ii].id.split(",")[1],$.wijmo.wijspread.SheetArea.viewport).value("");
					sheet.getCell(alreadyCutAry[ii].id.split(",")[0],alreadyCutAry[ii].id.split(",")[1],$.wijmo.wijspread.SheetArea.viewport).backgroundImage(null);
					sheet.getCell(alreadyCutAry[ii].id.split(",")[0],alreadyCutAry[ii].id.split(",")[1],$.wijmo.wijspread.SheetArea.viewport).textIndent(alreadyCutAry[ii].etxtindent);
				}
			}
		}
		//黏贴完判断是否不能编辑的单元格，如果是，保护起来
		var ac = sheet.getActiveColumnIndex();
		var ar = sheet.getActiveRowIndex();
		if(dataobj.ecs)
		if(dataobj.ecs[ar+","+ac])
	 	if(dataobj.ecs[ar+","+ac].etype === celltype.DETAIL || dataobj.ecs[ar+","+ac].etype === celltype.DE_TITLE
               	|| dataobj.ecs[ar+","+ac].etype === celltype.DE_TAIL || dataobj.ecs[ar+","+ac].etype === celltype.DE_BTN
               	|| dataobj.ecs[ar+","+ac].etype === celltype.FNAME || dataobj.ecs[ar+","+ac].etype === celltype.FCONTENT
               	|| dataobj.ecs[ar+","+ac].etype === celltype.NNAME || dataobj.ecs[ar+","+ac].etype === celltype.NADVICE
               	|| dataobj.ecs[ar+","+ac].formula)
        {	
        	sheet.setIsProtected(true);
        }
		if(showcantcopy)
			window.top.Dialog.alert("复制单元格中包含已有字段或标签，这些单元格将不被复制！");
		if(isstyle){
			$(".excelHeadTable").find("div[name=formatrush]").removeAttr("down").removeClass("shortBtnHover");
	   		if(sheet._clipboardHelper){
	   			sheet._clipboardHelper.fromSheet = null;
	   			sheet.isCutting = false;
	   			sheet.range = null;
			}
		}
	});
	/*
    sheet.bind($.wijmo.wijspread.Events.DragDropBlockCompleted, function (event, data) {
        spreadDragDropBlockCompletedAndPaste(data,true);
    });
    sheet.bind($.wijmo.wijspread.Events.DragDropBlock,function(event,data){
        spreadDragFillBlock(data);
    });
    sheet.bind($.wijmo.wijspread.Events.ClipboardPasted, function (e, args) {
        spreadClipboardPasted(args);
    });
    sheet.bind($.wijmo.wijspread.Events.DragFillBlockCompleted, function (event, data) {
        spreadDragFillBlockCompleted(data);
    });
    sheet.bind($.wijmo.wijspread.Events.DragFillBlock, function (event, data) {
        spreadDragFillBlock(data);
    });*/
}

//还原属性，上边操作栏，右侧字段栏属性
function restoreCellProperties(cellid)
{
	var control = scpmanager.getCacheValue(getActiveExcelId());
	var dataobj = control.getDataObj();
	if(dataobj)
	if(dataobj.ecs)
	if(dataobj.ecs[cellid]){
		if(dataobj.ecs[cellid].etype === celltype.FNAME || dataobj.ecs[cellid].etype === celltype.FCONTENT
			|| dataobj.ecs[cellid].etype === celltype.NNAME || dataobj.ecs[cellid].etype === celltype.NADVICE)
			setFieldAttrHave(dataobj.ecs[cellid].efieldid,dataobj.ecs[cellid].etype,0);
		else if(dataobj.ecs[cellid].etype === celltype.DETAIL)
			delete haveDetailMap[dataobj.ecs[cellid].edetail];
		else if(dataobj.ecs[cellid].etype === celltype.DE_TITLE)
		{
			$(".excelHeadContent").find("[name=de_title]").attr("alreadyHave","0");
			$(".excelHeadContent").find("[name=de_title]").addClass("shortBtn").removeClass("shortBtn_disabled");
		}else if(dataobj.ecs[cellid].etype === celltype.DE_TAIL)
		{
			$(".excelHeadContent").find("[name=de_tail]").attr("alreadyHave","0");
			$(".excelHeadContent").find("[name=de_tail]").addClass("shortBtn").removeClass("shortBtn_disabled");
		}else if(dataobj.ecs[cellid].etype === celltype.DE_BTN)
		{
			$(".excelHeadContent").find("[name=de_btn]").attr("alreadyHave","0");
			$(".excelHeadContent").find("[name=de_btn]").addClass("shortBtn").removeClass("shortBtn_disabled");
		}
			
	}
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
	       	var _htmltype,_type,_dbtype= "";
	       	if(flag === celltype.FCONTENT){
		       	_htmltype = $(this).children("[name=fieldtype]").val();
		       	_type = $(this).children("[name=fieldtypedetail]").val();
		       	_dbtype = $(this).children("[name=fielddbtype]").val();
	       	}
	       	var fieldhave = getFieldAttrHave(targetid,flag);
	       	if(isDetail === "on")
	       		fieldhave = parentWin_Main.getFieldAttrHave(targetid,flag);
       		if(!!fieldhave){
				gcEditingInput.val("");
				gcEditingInput.parent("div").find(".ac_results").remove();
				//if(flag === celltype.FCONTENT)
				//	window.top.Dialog.alert("字段已存在");
				//else if(flag === celltype.FNAME)
				//	window.top.Dialog.alert("标签已存在");
				//else if(flag === celltype.NNAME)
				//	window.top.Dialog.alert("节点名称已存在");
				//else if(flag === celltype.NADVICE)
				//	window.top.Dialog.alert("流转意见已存在");
			}else{
		       	setExcelBxValue(evt,targetid,flag,_txt,_htmltype,_type,_dbtype);
		       	gcEditingInput.val(_txt);
	       	}
		});
		gcEditingInput.unbind("keydown",autoCompleteKeyDown);
		gcEditingInput.bind("keydown",autoCompleteKeyDown);
	}
}
var isAutoCompleteKeyDown = 0;
//绑定事件
function autoCompleteKeyDown(e)
{
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

var detailFormulaTempAry = new Array();
//打开明细设计器 窗口
function openDetailWin(edetail){
	var dlg=new window.top.Dialog();//定义Dialog对象
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
	dlg.callbackfunc4CloseBtn=function(){
		for(var i=0;i<detailFormulaTempAry.length;i++){	//肯定是明细
			var parentControl = parentWin_Main.scpmanager.getCacheValue(parentWin_Main.getActiveExcelId());
			parentControl.delOneFormula(detailFormulaTempAry[i]);
		}
	}
}
//单元格点击事件扩展
function spreadCellClick(data){
    var cell=data.sheet.getCell(data.row,data.col,data.sheetArea);
    var value=cell.value();
    var cell_style = data.sheet.getStyle(data.row, data.col, $.wijmo.wijspread.SheetArea.viewport);
    var isbold = 0;
   	var isitalic = 0;
   	var fontsize = "9pt";
   	var fontfamliy = "Microsoft YaHei";
   	var hAlign = -1;
   	var vAlign = -1;
   	var wordWrap = false;
    if(!!cell_style){    	
    	if(!!cell_style.hAlign)
    		hAlign = cell_style.hAlign;
    	if(!!cell_style.vAlign)
    		vAlign = cell_style.vAlign;
   		var cell_font = cell_style.font;
    	if(!!cell_font){
    		if(cell_font.indexOf("bold")>=0)
    			isbold = 1;
    		if(cell_font.indexOf("italic")>=0)
    			isitalic = 1;
    		if(cell_font.indexOf("pt"))
				fontsize = cell_font.match(/\d+pt/g);
			else if(cell_font.indexOf("px"))
				fontsize = cell_font.match(/\d+px/g);
    		if(cell_font.indexOf("SimSun") >=0)fontfamliy = "SimSun";
            else if(cell_font.indexOf("SimHei") >=0)fontfamliy = "SimHei";
            else if(cell_font.indexOf("Microsoft YaHei") >=0)fontfamliy = "Microsoft YaHei";
            else if(cell_font.indexOf("KaiTi") >=0)fontfamliy = "KaiTi";
           	else if(cell_font.indexOf("YouYuan") >=0)fontfamliy = "YouYuan";
            else if(cell_font.indexOf("Arial") >=0)fontfamliy = "Arial";
            else if(cell_font.indexOf("FangSong") >=0)fontfamliy = "FangSong";
    	}
    	if(!!cell_style.wordWrap)
    		wordWrap = cell_style.wordWrap;
    }
    setHeadOperatPanelByCellStyle(isbold,isitalic,fontsize,fontfamliy,hAlign,vAlign,wordWrap);
}

//根据单元格的样式 反向设置操作栏
function setHeadOperatPanelByCellStyle(isbold,isitalic,fontsize,fontfamliy,hAlign,vAlign,wordWrap)
{
	var formatPanel = jQuery(".excelHeadContent").find(".s_format");
	//字体设置
	if(isbold == 1) formatPanel.find("div[name=blodfont]").addClass("shortBtnHover").attr("down","on");
	else formatPanel.find("div[name=blodfont]").removeClass("shortBtnHover").removeAttr("down");
	if(isitalic == 1)formatPanel.find("div[name=italicfont]").addClass("shortBtnHover").attr("down","on");
	else formatPanel.find("div[name=italicfont]").removeClass("shortBtnHover").removeAttr("down");
	formatPanel.find("select").selectbox("detach");
	formatPanel.find("#fontsize").val(fontsize);
	formatPanel.find("#fontfamily").val(fontfamliy);
	formatPanel.find("select").selectbox("attach");
	var fontsize_sb = formatPanel.find("#fontfamily").attr("sb");
	formatPanel.find("#sbHolderSpan_"+fontsize_sb).css("width","100%");
	var fontsize_sb = formatPanel.find("#fontsize").attr("sb");
	formatPanel.find("#sbHolderSpan_"+fontsize_sb).css("width","100%");
	//垂直对齐
	if(vAlign == 0){
		formatPanel.find("div[name=topAlign]").addClass("shortBtnHover").attr("down","on");
		formatPanel.find("div[name=middelAlign]").removeClass("shortBtnHover").removeAttr("down");
		formatPanel.find("div[name=bottomAlign]").removeClass("shortBtnHover").removeAttr("down");
	}else if(vAlign == 1){
		formatPanel.find("div[name=topAlign]").removeClass("shortBtnHover").removeAttr("down");
		formatPanel.find("div[name=middelAlign]").addClass("shortBtnHover").attr("down","on");
		formatPanel.find("div[name=bottomAlign]").removeClass("shortBtnHover").removeAttr("down");
	}else if(vAlign == 2){
		formatPanel.find("div[name=topAlign]").removeClass("shortBtnHover").removeAttr("down");
		formatPanel.find("div[name=middelAlign]").removeClass("shortBtnHover").removeAttr("down");
		formatPanel.find("div[name=bottomAlign]").addClass("shortBtnHover").attr("down","on");
	}else{
		formatPanel.find("div[name=topAlign]").removeClass("shortBtnHover").removeAttr("down");
		formatPanel.find("div[name=middelAlign]").removeClass("shortBtnHover").removeAttr("down");
		formatPanel.find("div[name=bottomAlign]").removeClass("shortBtnHover").removeAttr("down");
	}
	//水平对齐
	if(hAlign == 0){
		formatPanel.find("div[name=leftAlign]").addClass("shortBtnHover").attr("down","on");
		formatPanel.find("div[name=centerAlign]").removeClass("shortBtnHover").removeAttr("down");
		formatPanel.find("div[name=rightAlign]").removeClass("shortBtnHover").removeAttr("down");
	}else if(hAlign == 1){
		formatPanel.find("div[name=leftAlign]").removeClass("shortBtnHover").removeAttr("down");
		formatPanel.find("div[name=centerAlign]").addClass("shortBtnHover").attr("down","on");
		formatPanel.find("div[name=rightAlign]").removeClass("shortBtnHover").removeAttr("down");
	}else if(hAlign == 2){
		formatPanel.find("div[name=leftAlign]").removeClass("shortBtnHover").removeAttr("down");
		formatPanel.find("div[name=centerAlign]").removeClass("shortBtnHover").removeAttr("down");
		formatPanel.find("div[name=rightAlign]").addClass("shortBtnHover").attr("down","on");
	}else{
		formatPanel.find("div[name=leftAlign]").removeClass("shortBtnHover").removeAttr("down");
		formatPanel.find("div[name=centerAlign]").removeClass("shortBtnHover").removeAttr("down");
		formatPanel.find("div[name=rightAlign]").removeClass("shortBtnHover").removeAttr("down");
	}
	//自动换行
	if(wordWrap) formatPanel.find("div[name=autowrap]").addClass("shortBtnHover").attr("down","on");
	else formatPanel.find("div[name=autowrap]").removeClass("shortBtnHover").removeAttr("down");
}


/*
 *	右边拖拽后 / 双击 单元格赋值 和联想输入时
 *	@param 
 *		 targetid 字段或者节点ID
 *		 flag 字段或者节点
 *		 txt 列表文本值
 *		 htmltype	大类型
 *		 type 		小类型
 *		 dbtype		数据库类型
 */
function setExcelBxValue(e,targetid,flag,txt,htmltype,type,dbtype)
{
	var control = scpmanager.getCacheValue(getActiveExcelId());
   	var excelDiv = control.getControl();
   	//jQuery(excelDiv).focus().select();
    var ss = jQuery(excelDiv).wijspread("spread");
    var sheet = ss.getActiveSheet();
	var c = sheet.getActiveColumnIndex();
	var r = sheet.getActiveRowIndex();
	var sel = sheet.getSelections()[0];
	var ac = sel.row;
	var ar = sel.col;
	if(r === sheet.getRowCount()-1)
		excelBaseOperat.insertRowandCol4LastFace("row");
	if(c === sheet.getColumnCount()-1)
		excelBaseOperat.insertRowandCol4LastFace("col");
	if(ac ==undefined || ar === undefined)	//如果拖动没有拖到单元格内，直接return掉;
		return;
	var fieldhave = getFieldAttrHave(targetid,flag);
	if(isDetail === "on")
		fieldhave = parentWin_Main.getFieldAttrHave(targetid,flag);
	if(!!fieldhave){
		return;
	}
		
	setFieldAttrHave(targetid,flag,1);
	
	sheet.isPaintSuspended(true);
	sheet.getCell(r,c,sheet.sheetArea).value(txt);
	sheet.getCell(r,c,sheet.sheetArea).backgroundImage(null);
	sheet.getCell(r,c,sheet.sheetArea).textIndent(0);
	//特殊处理：标题
	if(targetid == -1)	
		htmltype = "1";
	else if(targetid == -4)
		htmltype = "2";
	else if(targetid == -2 || targetid == -3)
		htmltype = "8";
	
	//根据类型设置单元格是只读/编辑/必填/ 控件类型，下拉框/输入框/等等
	if(flag === celltype.FCONTENT){
		var targetstatus = getFieldAttr(targetid);
		var de_canAdd;
		if(isDetail==="on"){
			de_canAdd = $("#dtladd").is(":checked");
			if(de_canAdd)
			if(whichlayout === "1" || nodetype === "3")
				de_canAdd = false;
			targetstatus = parentWin_Main.getFieldAttr(targetid);
			if(!de_canAdd) targetstatus = "1";
			parentWin_Main.setFieldAttr(targetid,"1");
		}
		if(targetstatus==="0"){
			if(isDetail==="on"){
				if(de_canAdd){
					parentWin_Main.setFieldAttr(targetid,"2");
					targetstatus = "2";
				}else{
					parentWin_Main.setFieldAttr(targetid,"1");
					targetstatus = "1";
				}
			}else{
		 		setFieldAttr(targetid,"2");	//如果字段本身是不显示状态，那么设置为显示(编辑)状态
		 		targetstatus = "2";
		 		if(targetid+"" === "-1"){
		 			setFieldAttr(targetid,"3");
		 			targetstatus = "3";
	 			}
		 	}
		}else if(targetstatus==="2"){
			if(targetid+"" === "-1"){
	 			targetstatus = "3";
	 			setFieldAttr(targetid,"3");
	 			targetstatus = "3";
 			}
		}
		if((whichlayout === "1" || nodetype === "3") && !isDetail){
			targetstatus = "1";
			setFieldAttr(targetid,"1");
		}
		var _controltype = "";
		if(htmltype==="3"){
			if(type==="2")	_controltype = controltype.DATE;
			else if(type==="19")_controltype = controltype.TIME;
			else _controltype=controltype.BROWSER;
		}	else if(htmltype==="1")_controltype=controltype.TEXT;
		else if(htmltype==="2")_controltype=controltype.TEXTAREA;
		else if(htmltype==="4")_controltype=controltype.CHECKBOX;
		else if(htmltype==="5")_controltype=controltype.SELECT;
		else if(htmltype==="6")_controltype=controltype.AFFIX;
		else if(htmltype==="7")_controltype=controltype.LINK;
		else if(htmltype==="8")_controltype=controltype.RADIO;
		if(_controltype!=""){
			var imgsrc = "/workflow/exceldesign/image/controls/"+_controltype+targetstatus+"_wev8.png";//图的名称很重要
			sheet.getCell(r,c,sheet.sheetArea).backgroundImage(imgsrc);
			sheet.getCell(r,c,sheet.sheetArea).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
			sheet.getCell(r,c,sheet.sheetArea).textIndent(2.5);
		}
	}
	sheet.isPaintSuspended(false);
	sheet.setIsProtected(true);
	
	var fieldPanel = jQuery(".excelHeadContent").find(".s_filed");
	fieldPanel.find("[name=fieldpro],[name=morepro]").removeClass("shortBtn").addClass("shortBtn_disabled");
	fieldPanel.find("[name=justread],[name=canwrite],[name=required]").removeClass("shortBtn").removeClass("shortBtnHover").addClass("shortBtn_disabled");
	if(whichlayout === "0" && nodetype !== "3"){	//打印模板、mobile模板、归档节点，不让设置只读必填编辑属性
		if(flag === celltype.FCONTENT){
			fieldPanel.find("[name=justread],[name=canwrite],[name=required]").removeClass("shortBtn_disabled").addClass("shortBtn");
			fieldPanel.find("[name=fieldpro],[name=morepro]").removeClass("shortBtn_disabled").addClass("shortBtn");
		}
	}
	
	restoreCellProperties(r+","+c);
	var cell = {};
	cell.efieldid = targetid;
	cell.efieldtype = _controltype;
	setCellProperties(r+","+c,flag,cell);
}

//根据数遍所在的位置获取 活动单元格
function getBxbyMousePosition(e){
	var excelHeadHeight = 92+40;
	var excelDiv = jQuery("#excelDiv");
	var ss = excelDiv.wijspread("spread");
	var sheet = ss.getActiveSheet();
    
    var sheetRange = sheet.hitTest(e.clientX, e.clientY-excelHeadHeight, true)
	var c = sheetRange.col;
	var r = sheetRange.row;
	if(sheetRange.colViewportIndex == -1 || sheetRange.rowViewportIndex == -1){
		if(sheetRange.colViewportIndex == -1 && sheetRange.rowViewportIndex == -1)
			rightMenuSelectCase = "all";
		else if(sheetRange.colViewportIndex == -1)
			rightMenuSelectCase = "row";
		else if(sheetRange.rowViewportIndex == -1)
			rightMenuSelectCase = "col";
	}else{
		rightMenuSelectCase = "nor";
	}
	
	var selections = sheet.getSelections();
	if(selections.length>1)		return;
	var selection = selections[0];
	var mincol = selection.col;
	var maxcol = selection.col + selection.colCount - 1;
	var minrow = selection.row;
	var maxrow = selection.row + selection.rowCount - 1;
	
	if ((c >= mincol && c <= maxcol) && (r >= minrow && r <= maxrow));
	else {
		sheet.isPaintSuspended(true);
		sheet.addSelection(r, c,1,1);
		var span = sheet.getSpan(r,c,$.wijmo.wijspread.SheetArea.viewport);
		if(span){	//如果是合并单元格，需要找到合并单元格的源
			r = span.row;
			c = span.col;
		}
		sheet.setActiveCell(r, c);
		sheet.isPaintSuspended(false);
	}
}
var rightMenuSelectCase = "nor";
/**
 * 系统单元格类型
 * @type {Object}
 */
var  celltype={

    "TEXT":"tx",
    "DETAIL":"dt",
    "FORMULA":"fm",
    "FNAME":"Fname",		//字段名
    "FCONTENT":"Fcontent",	//表单内容
	"NNAME":"Nname",		//节点名称
	"NADVICE":"Nadvice",	//流转意见
	"IMAGE":"image",		//图片
	"DE_TITLE":"de_title",	//表头标识
	"DE_TAIL":"de_tail",	//表尾标识
	"DE_BTN":"de_btn",
	"LINKTEXT":"lktxt"		//链接
};

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
	"RADIO":"radio"
};

function  undefined2Empty(data)
{
	if(data===undefined)
		return "";
	return data;
}
//table 组件属性
var etable = function (o) {
    var p = {};
    p.id = undefined2Empty(o.id);
    p.title = undefined2Empty(o.title);
    p.ecs = undefined2Empty(o.ecs);  //缓存map
    return p;
}
//单元格 属性 作为参考， 并未用到
var ecell = function (o) {
    var p = {};
    p.id = undefined2Empty(o.id);
    p.etype = undefined2Empty(o.etype);     	//单元格类型
    p.evalue = undefined2Empty(o.evalue); 		//实际值
    p.etext = undefined2Empty(o.etext);      	//展示值
    p.enumbric = undefined2Empty(o.enumbric);	//数值样式
    p.ealign = undefined2Empty(o.ealign);		//对齐样式
    p.efont = undefined2Empty(o.efont);			//字体样式
    p.eborder = undefined2Empty(o.eborder);		//边框样式  只是标识是否有边框
    p.ebgfill = undefined2Empty(o.ebgfill);		//背景样式
    p.efieldid = undefined2Empty(o.efieldid);	//字段ID
    p.edetail = undefined2Empty(o.edetail);		//明细表
    p.ebgcolor = undefined2Empty(o.ebgcolor);	//背景色
    p.etxtindent = undefined2Empty(o.etxtindent);//缩进
    p.financial = undefined2Empty(o.financial);	//财务格式
    p.formula = undefined2Empty(o.formula);
    return p;
}

/**
 * 设置数据列属性
 * @param bxid 【单元格ID】
 * @param type 【数据列属性对象】
 */
function setCellProperties(bxid, type, cell_pro) {
	var control = scpmanager.getCacheValue(getActiveExcelId());
	
	//获取整个表格属性类
    var dataobj = control.getDataObj();
	//如果表格未操作过，则创建table缓存，用来存放单元格属性；
    if (dataobj.ecs === undefined ||  ""===dataobj.ecs)
        dataobj.ecs = {};
    var cell_obj;
    if(dataobj.ecs[bxid] == undefined ||  ""===dataobj.ecs[bxid]){
        var cell_o = {};
        //把传过来的ID赋给单元格；
        cell_o.id = bxid;
        if(type != "")
        	cell_o.etype = type;
        
        var cell_p = new ecell(cell_o);
        dataobj.ecs[bxid] = cell_p;
        cell_obj = dataobj.ecs[bxid];
    }else{
        dataobj.ecs[bxid].id = bxid;
        if(type != "")
       		dataobj.ecs[bxid].etype = type;
        cell_obj = dataobj.ecs[bxid];
    }
    
    if(!!cell_pro){
    	//数值样式
     	if(cell_pro.enumbric)
     		cell_obj.enumbric = cell_pro.enumbric;
     	if(cell_pro.ealign){	//对齐
			if(!cell_obj.ealign){
				cell_obj.ealign = cell_pro.ealign;
			}else{
	     		if(!!cell_pro.ealign.a_valign || cell_pro.ealign.a_valign==0)
	     			cell_obj.ealign.a_valign = cell_pro.ealign.a_valign;
	     		if(!!cell_pro.ealign.a_halign || cell_pro.ealign.a_halign==0)
	     			cell_obj.ealign.a_halign = cell_pro.ealign.a_halign;
	     		if(!!cell_pro.ealign.a_wrap || cell_pro.ealign.a_wrap==false)
	     			cell_obj.ealign.a_wrap = cell_pro.ealign.a_wrap;
	     		if(!!cell_pro.ealign.a_mergen)
	     			cell_obj.ealign.a_mergen = cell_pro.ealign.a_mergen;
	     		if(!!cell_pro.ealign.a_indent)
	     			cell_obj.ealign.a_indent = cell_pro.ealign.a_indent;
   			}
   		}
   		if(cell_pro.efont)
   			cell_obj.efont = cell_pro.efont;
   		if(cell_pro.efieldid){
   			cell_obj.efieldid = cell_pro.efieldid;
   			cell_obj.efieldtype = cell_pro.efieldtype;
		}
   		if(cell_pro.edetail)
   			cell_obj.edetail = cell_pro.edetail;
   		if(cell_pro.eborder)
   			cell_obj.eborder = cell_pro.eborder;
   		if(cell_pro.ebgcolor){
   			cell_obj.ebgcolor = cell_pro.ebgcolor;
   			if(cell_pro.ebgcolor === "transparent")
   			delete cell_obj.ebgcolor;
		}
   		if(cell_pro.evalue)
   			cell_obj.evalue = cell_pro.evalue;
   		if(cell_pro.etxtindent || cell_pro.etxtindent == 0)
   			cell_obj.etxtindent = cell_pro.etxtindent;
   		if(cell_pro.financial)
   			cell_obj.financial = cell_pro.financial;
   		if(cell_pro.formula)
   			cell_obj.formula = cell_pro.formula;
    }
    //if(console)
    	//console.dir(cell_obj);
}

//插入明细 功能操作，不带业务
function doInsertDetail(action,whichmenu)
{
	var imgsrc = "/workflow/exceldesign/image/shortBtn/detail/detailTable_wev8.png";
	var excelDiv = scpmanager.getCacheValue(getActiveExcelId()).getControl();
	var ss = $(excelDiv).wijspread("spread");
	var sheet = ss.getActiveSheet();
	var c = sheet.getActiveColumnIndex();
	var r = sheet.getActiveRowIndex();
	var cell = sheet.getCell(r,c,sheet.sheetArea);
	sheet.isPaintSuspended(true);
	cell.backgroundImage(imgsrc);
	cell.backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
	cell.textIndent(3);
	sheet.isPaintSuspended(false);
	cell.value("明细表"+action.split("_")[1]);
	restoreCellProperties(r+","+c);
	var _cell = {};
	_cell.edetail = action;
	setCellProperties(r+","+c,celltype.DETAIL,_cell);
	haveDetailMap[action]="on";
	if(r === sheet.getRowCount()-1)
		excelBaseOperat.insertRowandCol4LastFace("row");
	if(c === sheet.getColumnCount()-1)
		excelBaseOperat.insertRowandCol4LastFace("col");
	//$("#excelRightMenu").children("li[action="+action+"]").children("span.title").text($("#excelRightMenu").children("li[action="+action+"]").children("span.title")+"(已添加)");
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

function shrinkClick(){
	var obj=jQuery(".shrinkBtn");
	var excelDiv = scpmanager.getCacheValue(getActiveExcelId()).getControl();
	var ss = $(excelDiv).wijspread("spread");
	
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

//在模板tab中的iframe 点击编辑切换tab
function changeTab4SameModeid()
{	
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

//导入
function importExcel(allSheeJson)
{
	try{
		if(scpmanager)
			scpmanager.removeAllCache();
		var excelDiv = jQuery("#excelDiv");
		var excelid = excelDiv.attr("excelid");
		jQuery(".s_module").removeClass("current");
		jQuery(".s_format").addClass("current");
		jQuery(".excelBody").show();
		jQuery(".excelHeadBG").show();
		jQuery(".excelSet").show();
		jQuery(".moduleContainer").hide();
		jQuery(".excelHeadContent").children(".s_format").show();
		registerscp(excelDiv,excelid); //注册主表设计器缓存
		if(excelBaseOperat.importExcelFace(allSheeJson))
			excelBaseOperat.resumeTable(null,"main");
		
	}catch(e)
	{
		window.top.Dialog.alert("无法解析导入的文件，请确认");
	}
}

function getFieldREM(){
	var control = scpmanager.getCacheValue(getActiveExcelId());
	var excelDiv = control.getControl();
	var dataobj = control.getDataObj();
	var ss = jQuery(excelDiv).wijspread("spread");
   	var sheet = ss.getActiveSheet();
   	var sels = sheet.getSelections();
   	var isfield = false; 
	var istitlefield = false;
	var isspecial = false;

   	for (var n = 0; n < sels.length; n++) {
		var sel = excelBaseOperat.getCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
		for (var i = 0; i < sel.rowCount; i++) {
			for (var j = 0; j < sel.colCount; j++) {
				var ar = i + sel.row;
				var ac = j + sel.col;
				if(dataobj)
				if(dataobj.ecs)
				if(dataobj.ecs[ar+","+ac])
				if(dataobj.ecs[ar+","+ac].etype === celltype.FCONTENT){
					if(dataobj.ecs[ar+","+ac].efieldid+"" === "-1"){
						istitlefield = true;
					}else if(dataobj.ecs[ar+","+ac].efieldid+"" === "-4"){
						isspecial = true;
					}else{
						if($("a[_flag="+celltype.FCONTENT+"][_fieldid="+dataobj.ecs[ar+","+ac].efieldid+"]").children("[name=fieldtype]").val()==="7"){
							isspecial = true;
						}else{
							isfield = true;
						}
					}
				}
			}
		}
	}
	return isfield+","+istitlefield+","+isspecial;
}

function setOperatCellREM(data){
    var control = scpmanager.getCacheValue(getActiveExcelId());
	var excelDiv = control.getControl();
	var dataobj = control.getDataObj();
    var fieldPanel = jQuery(".excelHeadContent").find(".s_filed");
    
	fieldPanel.find("[name=justread],[name=canwrite],[name=required]")
		.removeClass("shortBtn").removeClass("shortBtnHover").addClass("shortBtn_disabled");
	fieldPanel.find("[name=fieldpro],[name=morepro]")
		.removeClass("shortBtn").addClass("shortBtn_disabled");
	if(whichlayout == "0" && nodetype!="3"){	//非归档节点显示模板
		var _menu_rem = getFieldREM();
		var isfield = (_menu_rem.split(",")[0]==="true")?true:false;
		var istitlefield = (_menu_rem.split(",")[1]==="true")?true:false;
		var isspecial = (_menu_rem.split(",")[2]==="true")?true:false;
		if(isfield || istitlefield || isspecial){
			fieldPanel.find("[name=justread]").removeClass("shortBtn_disabled").addClass("shortBtn");
			if(isfield)
				fieldPanel.find("[name=canwrite]").removeClass("shortBtn_disabled").addClass("shortBtn");
			if(isfield || istitlefield)
				fieldPanel.find("[name=required]").removeClass("shortBtn_disabled").addClass("shortBtn");
		}
		
		var isSingle = excelBaseOperat.getIsChooseSingleCell();
		if(isSingle){
			if(dataobj)
			if(dataobj.ecs)
			if(dataobj.ecs[data.row+","+data.col])
			if(dataobj.ecs[data.row+","+data.col].etype === celltype.FCONTENT){
				setFieldAttrHover(dataobj.ecs[data.row+","+data.col].efieldid);
				fieldPanel.find("[name=fieldpro]").removeClass("shortBtn_disabled").addClass("shortBtn");
				fieldPanel.find("[name=morepro]").removeClass("shortBtn_disabled").addClass("shortBtn");
			}
		}
	}
}

function setFieldAttrHover(fieldid){
	var fieldPanel = jQuery(".excelHeadContent").find(".s_filed");
	var fieldattr = getFieldAttr(fieldid);
	if(fieldattr+"" === "1"){
		fieldPanel.find("[name='justread']").addClass("shortBtnHover");
	}else if(fieldattr+"" === "2"){
		fieldPanel.find("[name='canwrite']").addClass("shortBtnHover");
	}else if(fieldattr+"" === "3"){
		fieldPanel.find("[name='required']").addClass("shortBtnHover");
	}
}

function controlInsertLimits(){
	var isSingle = excelBaseOperat.getIsChooseSingleCell();
	var insertPanel = jQuery(".excelHeadContent").find(".s_insert");
	if(isSingle){
		insertPanel.find("[name='linktext'],[name='formula']").removeClass("shortBtn_disabled").addClass("shortBtn");
	}else{
		insertPanel.find("[name='linktext'],[name='formula']").removeClass("shortBtn").addClass("shortBtn_disabled");
	}
}

function setFormatrushNor(){
	jQuery(".excelHeadContent").find("div[name=formatrush]").attr("down","");
  	jQuery(".excelHeadContent").find("div[name=formatrush]").removeClass("shortBtnHover");
}

//初始化加载某模板
function initModuleTab(){
	var layouttype=wfinfo.layouttype;
	if(layouttype=='1'){
		clickModuleMenu('print');
	}else if(layouttype=='2'){
		clickModuleMenu('mobile');
	}else{
		clickModuleMenu('show');
	}
	//绑定click事件
	var leftMenu = jQuery(".moduleLeftMenu").find(".moduleLeftBtn");
	leftMenu.click(function(){
		if($(this).is("#import"))
		{
			var _ioDialog = new window.top.Dialog();
			_ioDialog.currentWindow = window;
			var url = "/workflow/exceldesign/excelImport.jsp?nodeid="+wfinfo.nodeid+"&wfid="+wfinfo.wfid+"&formid="+wfinfo.formid+"&isbill="+wfinfo.isbill+"&layouttype="+wfinfo.layouttype+"&modeid="+wfinfo.modeid+"&isform="+wfinfo.isform;
				_ioDialog.Title = "模板导入";
			_ioDialog.Width = 500;
			_ioDialog.Height = 340;
			_ioDialog.Drag = true; 	
			_ioDialog.URL = url;
			_ioDialog.show();
			
		}else if($(this).is("#export"))
		{
			var allsheetJson = excelBaseOperat.saveExcel2Json("export");
			$("[name=exportJson]").val(allsheetJson);
			exportForm.submit();
		}
		if($(this).is(".current") || $(this).is("#import") || $(this).is("#export"))	return;
		var preMenuName=jQuery(".moduleLeftMenu").find("div.current").attr("id");
		jQuery(".moduleLeftMenu").find("div#"+preMenuName)
			.removeClass("current").removeClass(preMenuName+"Btn_down")
			.find("div#triangle-left").remove();
		clickModuleMenu($(this).attr("id"));
	});
}
		
function clickModuleMenu(menuname){
	var leftClickMenu=jQuery(".moduleLeftMenu").find("div#"+menuname);
	var magicTriangle = jQuery("<div id='triangle-left'></div>");
	leftClickMenu.addClass("current").addClass(menuname+"Btn_down").append(magicTriangle);
	
	//iframe加载
	var iframeObj=$("iframe#showModule");
	var iframeurl = "/workflow/exceldesign/showModule.jsp?wfid="+wfinfo.wfid+"&formid="+wfinfo.formid+"&isbill="+wfinfo.isbill+"&isform="+wfinfo.isform+"&modeid="+wfinfo.modeid;
	if(menuname==="show"){		//模板
		iframeObj.attr("src",iframeurl+"&layouttype=0");
	}else if(menuname==="print"){
		iframeObj.attr("src",iframeurl+"&layouttype=1");
	}else if(menuname==="mobile"){
		iframeObj.attr("src",iframeurl+"&layouttype=2");
	}else{
		iframeObj.attr("src","");
	}
}

function compareObject(o1,o2){
  	if(typeof o1 != typeof o2)return false;
  	if(typeof o1 == 'object'){
	    for(var o in o1){
	      	if(typeof o2[o] == 'undefined')return false;
	      	if(!compareObject(o1[o],o2[o]))return false;
	    }
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
				window.top.Dialog.confirm("你目前已与服务器断开连接了，是否需要保存到本地？！",
					function(){
						var allsheetJson = excelBaseOperat.saveExcel2Json("export");
						storage.clear();
						storage.setItem(storageKey,allsheetJson);
						parentDialog.close();
				},function(){parentDialog.close();});
				return false;
			}
		});
	}
}
//关闭前提醒
function closeDesignWin(ct){
	try{
		var str1 = "";
		var str2 = "";
		if(isDetail === "on"){	
			str1 = excelBaseOperat.saveDetail2Json(detailIdenty,"save2Confirm");
			str1 = "{"+str1+"}";
			str2 = parentWin_Main.getJson();
		}else{
			str1 = excelBaseOperat.saveExcel2Json("save2Confirm");
			str2 = getJson();
		}
		//如果str1为空，那说明表格都没动过，直接跳过
		if(!str1) {
			if(ct==="close")
				parentDialog.close();
			else
				return true;
		}else{	//如果表格动过了
			var str1Json = JSON.parse(str1);
			var str2Json;	//但是隐藏域里的内容为空了，因此肯定动过了，要提示
			if(!str2){
				if(isDetail === "on"){	//明细表
					if(str1==="{}")
						parentDialog.close();
					else
						window.top.Dialog.confirm("模板内容更改且尚未保存，确定离开吗？",
						function(){
							parentDialog.close();
						});
				}else{	//主表
					//默认生成的；
					str2 = "{\"eformdesign\":{\"eattr\":{\"formname\":\""+$("#layoutname").val()+"\",\"wfid\":\""+wfinfo.wfid+"\",\"nodeid\":\""+wfinfo.nodeid+"\",\"formid\":\""+wfinfo.formid+"\",\"isbill\":\""+wfinfo.isbill+"\"},\"etables\": {}}}";
					if(str1 === str2){
						if(ct==="close")
							parentDialog.close();
						else
							return true;
					}else{
						if(ct==="close"){
							window.top.Dialog.confirm("模板内容更改且尚未保存，确定离开吗？",
							function(){
								parentDialog.close();
							});
						}else{
							return false;
						}
					}
				}
			}else{
			//如果 这是dialog 还没有close掉，说明，str1和str2都有内容
				str2Json = JSON.parse(str2);
				var issame = false;
				if(isDetail === "on")
					issame = compareObject(str1Json["detail_"+detailIdenty],str2Json.eformdesign.etables["detail_"+detailIdenty]);
				else
					issame = compareObject(str1Json.eformdesign.etables,str2Json.eformdesign.etables);	
				
				if(!issame){	//如果比较出来不同
					if(ct==="close"){
						window.top.Dialog.confirm("模板内容更改且尚未保存，确定离开吗？",
						function(){
							parentDialog.close();
						});
					}else{
						return false;
					}
				}else{
					if(ct==="close")
						parentDialog.close();
				}
			}
		}
		return true;
	}catch(e){	//报错后关闭不了的问题
		if(ct==="close")
			parentDialog.close();
		else
			return true;
	}
}
