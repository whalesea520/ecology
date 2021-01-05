var baseOperate=(function (){
	
	/**
	 * 绑定设计器操作按钮事件
	 */
	function bindOperateBtnEvent(operatpanel,excelDiv){
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
		operatpanel.find("[class='selectforcolor']").spectrum({
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
            	var pickcolordiv = $(this).parent().find(".pickcolordiv");
            	if(color === "transparents"){
                	if($(this).attr("target") != "bordercolor")    //去除边框颜色
                		setMjiStyle(excelDiv, $(this).attr("target"), null);
           		}else{
           			pickcolordiv.css("background", color.toHexString());
                	pickcolordiv.find("input[type='hidden']").val(color.toHexString());  
                	if($(this).attr("target") != "bordercolor")    //去除边框颜色
                		setMjiStyle(excelDiv, $(this).attr("target"), color.toHexString());
           		}   
            }
        });
        operatpanel.find("[class='showforcolor'][target!='bordercolor']").click(function(){
        	var color = $(this).find(".pickcolordiv").find("input[type='hidden']").val();
        	setMjiStyle(excelDiv, $(this).attr("target"), color);
        });
		operatpanel.find("#bordertype").parent().parent().find(".ddChild li").click(function(){
			drawborder();
		});
		//格式刷
		operatpanel.find("[name=formatrush").click(function(){
			setBtnStatus(this);
   		 	var sheet = getCurrentSheet();
   		 	var sels = sheet.getSelections();
   		 	$.wijmo.wijspread.SpreadActions.copy.call(sheet);
		});
		//单元格属性
		operatpanel.find("[name=excelPro]").click(function(){
    		openStyleWin();
    	});
    	//顶端对齐
    	operatpanel.find("[name=topAlign]").click(function(){
    		if(jQuery(this).attr("down") === "on")	return;
    		operatpanel.find("[name=middelAlign],[name=bottomAlign]").removeAttr("down").removeClass("shortBtnHover");
    		setBtnStatus(this);
    		alignBx({"a_valign":"0"});
    	});
    	//垂直居中
    	operatpanel.find("[name=middelAlign]").click(function(){
    		if(jQuery(this).attr("down") === "on")	return;
    		operatpanel.find("[name=topAlign],[name=bottomAlign]").removeAttr("down").removeClass("shortBtnHover");
    		setBtnStatus(this);
    		alignBx({"a_valign":"1"});
    	});
    	//底部对齐
    	operatpanel.find("[name=bottomAlign]").click(function(){
    		if(jQuery(this).attr("down") === "on")	return;
    		operatpanel.find("[name=topAlign],[name=middelAlign]").removeAttr("down").removeClass("shortBtnHover");
    		setBtnStatus(this);
    		alignBx({"a_valign":"2"});
    	});
    	//左对齐
    	operatpanel.find("[name=leftAlign]").click(function(){
    		if(jQuery(this).attr("down") === "on")	return;
    		operatpanel.find("[name=centerAlign],[name=rightAlign]").removeAttr("down").removeClass("shortBtnHover");
    		setBtnStatus(this);
    		alignBx({"a_halign":"0"});
    		
    	});
    	//居中对齐
    	operatpanel.find("[name=centerAlign]").click(function(){
    		if(jQuery(this).attr("down") === "on")	return;
    		operatpanel.find("[name=leftAlign],[name=rightAlign]").removeAttr("down").removeClass("shortBtnHover");
    		setBtnStatus(this);
    		alignBx({"a_halign":"1"});
    	});
    	//右对齐
    	operatpanel.find("[name=rightAlign]").click(function(){
    		if(jQuery(this).attr("down") === "on")	return;
    		operatpanel.find("[name=leftAlign],[name=centerAlign]").removeAttr("down").removeClass("shortBtnHover");
    		setBtnStatus(this);
    		alignBx({"a_halign":"2"});
    	});
    	// 左缩进
    	operatpanel.find("[name=leftretract]").click(function(){
    		cellRetract("increase");
    	});
    	// 右缩进
    	operatpanel.find("[name=rightretract]").click(function(){
    		cellRetract("reduce");
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
			setFinancial_head();
		});
		//财务表览
		operatpanel.find("[name=financialsheet]").click(function () {
			setFinancial_field();
		});
		//金额大写
		operatpanel.find("[name=financialupper]").click(function () {
			setFinancial_upper();
		});
		//千分位
		operatpanel.find("[name=n_us]").click(function () {
			setFinancial_thousands();
		});
		//清除格式
		operatpanel.find("[name=cleanstyle]").click(function () {
			cleanCell(1);
		});
		//清除内容
		operatpanel.find("[name=cleancontent]").click(function () {
			cleanCellContent();
		});
		//清除全部
        operatpanel.find("[name=cleanall]").click(function () {
			cleanCellAll();
		});
		//清除财务格式
        operatpanel.find("[name=cleanfinance]").click(function () {
        	clearFinancial();
        });
		//显示 网格线
		operatpanel.find("[name=showgridline]").click(function () {
			showGridLine(this);
		});
		//显示 行列头
		operatpanel.find("[name=showthead]").click(function () {
			showExcelHead(this);
		});
        //============格式 栏  END===============
        
        //============插入 栏  START===============
		//插入代码
        operatpanel.find("[name=linkcode]").click(function () {
        	insertOperate.insertScriptCodeFace();
        });
        //添加图片
        operatpanel.find("[name=linkpic]").click(function () {
        	addPic();
        });
        //清除背景图
        operatpanel.find("[name=clearBgImg]").click(function () {
        	if($(this).is(".shortBtn_disabled")) 	return;
        	clearBgImg();
        });
        //插入链接
        operatpanel.find("[name=linktext]").click(function () {
        	if($(this).is(".shortBtn_disabled"))	return;
        	insertOperate.insertLinkFace();
        });
        //插入公式
        operatpanel.find("[name=formula]").click(function () {
			if($(this).is(".shortBtn_disabled"))	return;
        	formulaOperate.openFormulaWinFace();
        });
        //插入标签页
        operatpanel.find("[name=tabpage]").click(function () {
        	if($(this).is(".shortBtn_disabled"))	return;
        	tabOperate.insertTabPageFace();
        });
        //插入多内容
        operatpanel.find("[name=morecontent]").click(function(){
        	if($(this).is(".shortBtn_disabled"))	return;
        	mcOperate.insertMoreContentFace();
        });
        //插入iframe区域
        operatpanel.find("[name=iframearea]").click(function(){
        	if($(this).is(".shortBtn_disabled"))	return;
        	insertOperate.iframeDesignFace("insert");
        });
        //插入二维/条形码
        operatpanel.find("[name=scancode]").click(function(){
        	if($(this).is(".shortBtn_disabled"))	return;
        	insertOperate.scanCodeDesignFace("insert");
        });
        //插入门户元素
        operatpanel.find("[name=portalelm]").click(function(){
        	if($(this).is(".shortBtn_disabled"))	return;
        	insertOperate.portalDesignFace("insert");
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
       		set_Fieldpro();
       	});
       	//更多属性
       	operatpanel.find("[name=morepro]").click(function () {
       		if($(this).is(".shortBtn_disabled")) return ;
       		set_Morepro();
       	});
       	//============字段属性 栏  END===============
       	
       	//============明细 栏  START===============
		//初始化明细菜单
		operatpanel.find("[name=mainDetail]").contextMenu({
			menu : 'mainDetailMenu',
			button: 1,//3: right click, 1: left click
			onPopup : function(el,e) {
				var detaiMenuJson = getDetailMenuJson();
				$("#mainDetailMenu").html("");
				$('#mainDetailMenu').mac('menu', detaiMenuJson);
				window.setTimeout(function(){	//明细大量情况
					var menuobj = $('#mainDetailMenu');
					if(parseInt(menuobj.css("top").replace("px","")) < 1)
						menuobj.css("top","115px").css("height","600px").css("overflow-y","auto");
				},100);
			},
			//location: 'mouse',
			anchor: 'el',
			offset: { x: 14, y: 70 }
		}, function(action, el, pos) {
			detailOperate.doInsertDetailFace(action);
			return false;
		});
		//明细初始化
		operatpanel.find("[name=de_initdetail]").click(function () {
			if($(this).is(".shortBtn_disabled"))	return;
			detailOperate.initDetailTemplateFace();
		});
       	//明细表头、表尾
		operatpanel.find("[name=de_title],[name=de_tail]").click(function () {
			if($(this).is(".shortBtn_disabled"))	return;
			detailOperate.addDetailRowMarkFace(this);
		});
		//添加删除按钮、全选、单选、序号等
		operatpanel.find("[name=de_btn],[name=de_checkall],[name=de_checksingle],[name=de_serialnum]").click(function () {
			if($(this).is(".shortBtn_disabled"))	return;
			detailOperate.addDetailCellMarkFace(this);
		});
		//============明细 栏  END===============
		
		//绑定顶部tab切换事件
		jQuery(".excel_opitem").click(function(){
			if(jQuery(this).is(".current"))
				return;
			else{
				jQuery(this).parent(".nav").find(".current").removeClass("current");
				jQuery(this).addClass("current");
				jQuery(".excelHeadContent").children("table").hide();
				jQuery(".excelBody").show();
				jQuery(".excelHeadBG").show();
				jQuery(".excelSet").show();
				jQuery(".moduleContainer").hide();
				jQuery(".maxwin,.restore").show();
				if(jQuery(this).is(".s_format"))
					jQuery(".excelHeadContent").children(".s_format").show();
				else if(jQuery(this).is(".s_insert"))
					jQuery(".excelHeadContent").children(".s_insert").show();
				else if(jQuery(this).is(".s_filed"))
					jQuery(".excelHeadContent").children(".s_filed").show();
				else if(jQuery(this).is(".s_detail"))
					jQuery(".excelHeadContent").children(".s_detail").show();
				else if(jQuery(this).is(".s_style"))
					jQuery(".excelHeadContent").children(".s_style").show();
				else if(jQuery(this).is(".s_module")){
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
		});
    }
    
    /**
     * 初始化加载某模板
     */
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
			if($(this).is("#import")){
				var _ioDialog = new window.top.Dialog();
				_ioDialog.currentWindow = window;
				var url = "/workflow/exceldesign/excelImport.jsp?nodeid="+wfinfo.nodeid+"&wfid="+wfinfo.wfid+"&formid="+wfinfo.formid+"&isbill="+wfinfo.isbill+"&layouttype="+wfinfo.layouttype+"&modeid="+wfinfo.modeid+"&isform="+wfinfo.isform;
					_ioDialog.Title = "模板导入";
				_ioDialog.Width = 500;
				_ioDialog.Height = 340;
				_ioDialog.Drag = true; 	
				_ioDialog.URL = url;
				_ioDialog.show();
				
			}else if($(this).is("#export")){
				var allsheetJson = formOperate.saveLayoutWindowFace("export");
				$("[name=exportJson]").text(allsheetJson);
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
	//模板列表切换
	function clickModuleMenu(menuname){
		var leftClickMenu=jQuery(".moduleLeftMenu").find("div#"+menuname);
		var magicTriangle = jQuery("<div id='triangle-left'></div>");
		leftClickMenu.addClass("current").addClass(menuname+"Btn_down").append(magicTriangle);
		
		//iframe加载
		var iframeObj=$("iframe#showModule");
		var iframeurl = "/workflow/exceldesign/showModule.jsp?wfid="+wfinfo.wfid+"&formid="+wfinfo.formid+"&isbill="+wfinfo.isbill;
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
	
	/**
	 * 初始化面板右键菜单
	 */
	function initPanelRightMenu(){
		jQuery("#excelDiv,#excelDiv_mc").contextMenu({
			menu : 'excelRightMenu',
			button: 3,//3: right click, 1: left click
			onPopup : function(el,e) {
				if(isEditFormulaing){
					$(el).addClass("disabled"); 
					return;
				}else
					$(el).removeClass("disabled");
				try{
	 				e.stopPropagation();
	 				e.preventDefault();
				}catch(er){
					window.event.cancelBubble = true;
					return false;
				}
				var bx = mouseLocateCell(e, "rightBtn");
				$("#excelRightMenu").html("");
				if(isEditMoreContent){		//多字段第一列才允许右键
					var sheet = getCurrentSheet();
					var sel = sheet.getSelections()[0];
					var ac = sel.col;
					if(ac != 0){
						$('#excelRightMenu').mac('menu', null);
						return;
					}
				}
				var menuJson = getMenuJson();
				$('#excelRightMenu').mac('menu', menuJson);
			},
			//location: 'mouse',
			offset: { x: 0, y: 0 }
		}, function(action, el, pos) {
			if(action === "setStyle"){
				openStyleWin();
			}else if(action.indexOf("detail")>=0){
				detailOperate.doInsertDetailFace(action);
			}else if(action === "cut" || action === "copy" || action === "paste"){
				doCCP(action);
			}else if(action === "cleanStyle"){
				cleanCell(1);
			}else if(action === "cleanContent"){	
				cleanCellContent();
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
			}else if(action === "customAttr"){
				setCustomAttr();
			}else if(action === "moveup"){
				cellMoveUpDown("up");
			}else if(action === "movedown"){
				cellMoveUpDown("down");
			}
			return false;
		});
    }
	
	/**
	 * 绑定表格事件
	 */
	function bindSpreadEvent(spread){
	    spread.useWijmoTheme = false;
	    var sheet = spread.getActiveSheet();
	    sheet.canUserDragDrop(false);
	    sheet.canUserDragFill(false);
	    spread.canUserEditFormula(false);
	    spread.allowUndo(false);
	    if(!isEditMoreContent){		//滚动条不滚动背景图片
		    var curcanvas = $(sheet._getCanvas());
			if(!!spread.backgroundImage()){
				jQuery(".excelHeadContent").find("[name=clearBgImg]").removeClass("shortBtn_disabled").addClass("shortBtn");;
				var st = setTimeout(function(){
		 			clearTimeout(st);
		  			var canvas = $(sheet._getCanvas());
		  			canvas.css("background-position", "40px 20px");
		 		},200);
			}	  						  		
		
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
	    }
	    
	    //Delete按键删除内容
	    sheet.addKeyMap($.wijmo.wijspread.Key.del, false, false, false, false, cleanCellContent);
	    
	    //编辑前事件
	    sheet.bind($.wijmo.wijspread.Events.EditStarting, function (event, data) {
			sheet.getCell(data.row,data.col,$.wijmo.wijspread.SheetArea.viewport).wordWrap(true);
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
	    		autoExtendRowCol(sheet, data.row, data.col);
		        //如果有自动换行符，则自动把改单元格设置为自动换行
				if(data.editingText.search(/\r\n|\r|\n/) > -1){
					sheet.getCell(data.row,data.col,$.wijmo.wijspread.SheetArea.viewport).wordWrap(true);
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
				var dataobj = getCurrentDataObj();
	           	//如果该单元格 已经存在 并且 是非Txt的，那么不能再设置了
	       		var cellid = data.row + "," + data.col;
	            if(dataobj.ecs[cellid] != undefined){
	            	if(dataobj.ecs[cellid].etype === celltype.FNAME || dataobj.ecs[cellid].etype === celltype.FCONTENT
                		|| dataobj.ecs[cellid].etype === celltype.NNAME || dataobj.ecs[cellid].etype === celltype.NADVICE 
                		|| dataobj.ecs[cellid].etype === celltype.LINKTEXT || dataobj.ecs[cellid].etype === celltype.IMAGE);
                	else{
						setCellProperties(cellid, celltype.TEXT);
					}
				}else{
					setCellProperties(cellid, celltype.TEXT);
				}
			}
			//需延时执行，解决单元格输入80%变为小数Bug
			window.setTimeout(function(){
				sheet.getCell(data.row, data.col).formatter("General");
				sheet.setValue(data.row, data.col, data.editingText);
			},10);
	    });
	    
	    //单元格点击事件
	    sheet.bind($.wijmo.wijspread.Events.CellClick, function (event, data) {
	    	spreadCellClick();		//改变相关样式选中状态、相关操作权限
	    });
	    
	    //单元格选中
	    sheet.bind($.wijmo.wijspread.Events.SelectionChanged,function(event,data){
	    	if($(".excelHeadTable").find("div[name=formatrush]").is(".shortBtnHover")){		//格式刷执行
	    		sheet.setIsProtected(false);
	    		$.wijmo.wijspread.SpreadActions.paste.call(sheet,"style");
	    	}else{
	    	//单击是先触发click再触发选中事件，上移下移会触发选中事件不触发单击事件
	    	sheet.setIsProtected(judgeNeedLockSheet(sheet.getActiveRowIndex(), sheet.getActiveColumnIndex()));
	    	}
	    });
		
		//单元格 双击事件
		sheet.bind($.wijmo.wijspread.Events.CellDoubleClick,function(event, data){
			if(isEditFormulaing) return;
			var cellid = data.row + "," + data.col;
			var dataobj = getCurrentDataObj();
			sheet.setIsProtected(judgeNeedLockSheet(data.row, data.col));
            if(dataobj.ecs[cellid] != undefined){
            	var etype = dataobj.ecs[cellid].etype;
            	if(etype === celltype.DETAIL){	
            		detailOperate.openDetailWinFace(dataobj.ecs[cellid].edetail);
            	}else if(etype === celltype.TAB){
            		tabOperate.switchEditTabFace(cellid);
            	}else if(etype === celltype.MC){
            		mcOperate.editMoreContentFace(cellid);
            	}else if(etype === celltype.BR){
            		mcOperate.switchCellBrSignFace(data.row);
            	}else if(etype === celltype.PORTAL){
            		insertOperate.portalDesignFace("setting");
            	}else if(etype === celltype.IFRAME){
            		insertOperate.iframeDesignFace("setting");
            	}else if(etype === celltype.SCANCODE){
            		insertOperate.scanCodeDesignFace("setting");
            	}else if(dataobj.ecs[cellid].formula){
            		formulaOperate.openFormulaWinFace();
            	}else if(etype === celltype.FNAME || etype === celltype.FCONTENT){
            		if(dataobj.ecs[cellid].financial){
            			var financialStr = dataobj.ecs[cellid].financial;
            			if(financialStr.indexOf("1-") == -1 && financialStr.indexOf("2-") == -1)
            				return;
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
				if(data.editingText.substring(0,1) === "#" || data.editingText.substring(0,1) === "$"
					|| data.editingText.substring(0,1) === "%" || data.editingText.substring(0,1) === "^"){
					var autoCompleteHtml;
					//1、输入“#”+字母，可筛选主表字段的“字段名”填充；
					if(data.editingText.substring(0,1) === "#"){
						if(isDetail === "on")
							autoCompleteHtml = getDetailFieldHtml(2,filterVal,detailIdenty);
						else
						 	autoCompleteHtml = getMainFieldHtml(2,filterVal);	
					}
					//2、输入“$”+字母，可筛选主表字段的“表单内容”填充；
					if(data.editingText.substring(0,1) === "$"){
						if(isDetail === "on")
							autoCompleteHtml = getDetailFieldHtml(3,filterVal,detailIdenty);
						else
							autoCompleteHtml = getMainFieldHtml(3,filterVal);
					}
					//3、输入“%”+字母，可筛选流程“节点名称”填充；
					if(data.editingText.substring(0,1) === "%"){
						autoCompleteHtml = getNodeHtml(2,filterVal);
					}
					//4、输入“^”+字母，可筛选“流转意见”填充。
					if(data.editingText.substring(0,1) === "^"){
						autoCompleteHtml = getNodeHtml(3,filterVal);
					}
					showAutoCompleteDiv(autoCompleteHtml);
					sheet.addKeyMap($.wijmo.wijspread.Key.up, false, false, false, false, null);
					sheet.addKeyMap($.wijmo.wijspread.Key.down, false, false, false, false, null);
					sheet.addKeyMap($.wijmo.wijspread.Key.left, false, false, false, false, null);
					sheet.addKeyMap($.wijmo.wijspread.Key.right, false, false, false, false, null);
					sheet.addKeyMap($.wijmo.wijspread.Key.enter, false, false, false, false, autoCompleteEnterKeyDown);
				}
			}
		});
		
		function autoCompleteEnterKeyDown(){
			var gcEditingInput = jQuery("textArea[gcuielement=gcEditingInput]");
			var currentTarget = gcEditingInput.parent("div").find(".ac_results ul li.selected");
			var targetid = "";
	   		if($(currentTarget).attr("_fieldid"))
	   			targetid |=$(currentTarget).attr("_fieldid");
	   		if($(currentTarget).attr("_nodeid"))
	   			targetid |= $(currentTarget).attr("_nodeid");
	   		
	   		var flag = $(currentTarget).attr("_flag");
	       	var _txt = $(currentTarget).text();
	       	var _fieldtype,_fieldtypedetail;
	       	if(flag === celltype.FCONTENT){
		       	_fieldtype = $(currentTarget).children("[name=fieldtype]").val();
		       	_fieldtypedetail = $(currentTarget).children("[name=fieldtypedetail]").val();
	       	}
	      	var fieldhave = getFieldAttrHave(targetid,flag);
	       	if(!!fieldhave){
				gcEditingInput.val("");
				gcEditingInput.parent("div").find(".ac_results").remove();
			}else{
			 	setExcelBxValue(null,targetid,flag,_txt,_fieldtype,_fieldtypedetail);
			 	gcEditingInput.val(_txt);
			}
			sheet.moveActiveCell();
		}
		
		//剪切板改变
		var isCutting;
		var srcRange;
		sheet.bind($.wijmo.wijspread.Events.ClipboardChanged, function (sender, args){
			isCutting = sheet._clipboardHelper.isCutting;
			srcRange = sheet.getSelections()[0];
			forBug_copyvalue = args.copyData;
		});
		
		//黏贴的逻辑还是比较复杂的，考虑到倍数问题，费脑子
		sheet.bind($.wijmo.wijspread.Events.ClipboardPasted, function (sender, args){
			var isstyle=false;
			if($(".excelHeadTable").find("div[name=formatrush]").is(".shortBtnHover"))
				isstyle = true;
			var dataobj = getCurrentDataObj();
			var desRange = args.cellRange;
			if(desRange.row == -1 ) desRange.row = 0;
			if(desRange.col == -1) desRange.col = 0;
			if(desRange.colCount == -1) desRange.colCount = sheet.getColumnCount();
			if(desRange.rowCount == -1) desRange.rowCount = sheet.getRowCount();
			if(srcRange == null){	//外部拷贝
				for(var i = 0; i<desRange.rowCount; i++){
					for(var j = 0; j<desRange.colCount; j++){
						var cellid = (desRange.row+i)+","+(desRange.col+j);
						if(!dataobj.ecs[cellid] || !dataobj.ecs[cellid].etype || dataobj.ecs[cellid].etype === celltype.TEXT){
							setCellProperties(cellid, celltype.TEXT);
						}
					}
				}
				return;
			}
			if(srcRange.col == -1) srcRange.col = 0;	//说明选了整行
			if(srcRange.row == -1) srcRange.row = 0;	//整列
			autoExtendRowCol(sheet, desRange.row+desRange.rowCount-1, desRange.col+desRange.colCount-1);
			
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
	        					restoreCellProperties("", des_r+","+des_c);
		        				var des_cell_pro = {};
		        				$.extend(true,des_cell_pro, src_cell_pro);
		        				des_cell_pro.id=des_r+","+des_c;
	        					alreadyCutAry.push(des_cell_pro);
		        			}else{
								setCellProperties(des_r+","+des_c, "");
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
					delete dataobj.ecs[srcid];
				}
				for(var ii=0;ii<alreadyCutAry.length;ii++){
					dataobj.ecs[alreadyCutAry[ii].id] = alreadyCutAry[ii];
					var etype = dataobj.ecs[alreadyCutAry[ii].id].etype;
					if(etype === celltype.FNAME || etype === celltype.FCONTENT || etype === celltype.NNAME || etype === celltype.NADVICE){
						setFieldAttrHave(dataobj.ecs[alreadyCutAry[ii].id].efieldid,dataobj.ecs[alreadyCutAry[ii].id].etype,1);
					}
				}
			}else{
				for(var ii=0;ii<alreadyCutAry.length;ii++){
					dataobj.ecs[alreadyCutAry[ii].id] = alreadyCutAry[ii];
					var etype = dataobj.ecs[alreadyCutAry[ii].id].etype;
					if(etype === celltype.FNAME || etype === celltype.FCONTENT || etype === celltype.NNAME || etype === celltype.NADVICE
						|| etype === celltype.DETAIL || etype === celltype.MC || etype === celltype.BR){
						dataobj.ecs[alreadyCutAry[ii].id].etype = "";
						sheet.getCell(alreadyCutAry[ii].id.split(",")[0],alreadyCutAry[ii].id.split(",")[1],$.wijmo.wijspread.SheetArea.viewport).value("");
						sheet.getCell(alreadyCutAry[ii].id.split(",")[0],alreadyCutAry[ii].id.split(",")[1],$.wijmo.wijspread.SheetArea.viewport).backgroundImage(null);
						sheet.getCell(alreadyCutAry[ii].id.split(",")[0],alreadyCutAry[ii].id.split(",")[1],$.wijmo.wijspread.SheetArea.viewport).textIndent(0);
					}
				}
			}
			//黏贴完判断是否不能编辑的单元格，如果是，保护起来
	        sheet.setIsProtected(judgeNeedLockSheet(sheet.getActiveRowIndex(), sheet.getActiveColumnIndex()));
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
	}
	
	/**
	 * 设置 操作栏 按钮状态
	 */
	function setBtnStatus(btn){
		if(jQuery(btn).attr("down") === "on"){
        	jQuery(btn).attr("down","");
        	jQuery(btn).removeClass("shortBtnHover");
        	return false;
       	}else {
        	jQuery(btn).attr("down","on");
        	jQuery(btn).addClass("shortBtnHover");
        	return true;
       	}
	}
	
	/**
	 * 鼠标定位单元格，拖拽/右键
	 */
 	var rightMenuSelectCase = "nor";
	function mouseLocateCell(e, target){
		var top = jQuery("div.editor_nav").height()+jQuery("div.excelHeadBG").height();
		var left = 0;
		if($("div.tabdiv").css("display") != "none"){
			top += $("div.tabdiv").height();
		}
		if(isEditMoreContent){
			left += parseInt(jQuery("#mcDiv").css("left").replace("px",""));
			top += parseInt(jQuery("#mcDiv").css("top").replace("px",""));
		}
		var sheet = getCurrentSheet();
	    var sheetRange = sheet.hitTest(e.clientX-left, e.clientY-top, true);
		var c = sheetRange.col;
		var r = sheetRange.row;
		if(target === "rightBtn"){
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
		}else if(target === "drag"){
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

	/**
	 * 获取表格 矩阵 并返回
	 */
	function getActualCellRange(cellRange, rowCount, columnCount) {
	    if (cellRange.row == -1 && cellRange.col == -1) {
	        return new $.wijmo.wijspread.Range(0, 0, rowCount, columnCount);
	    }else if (cellRange.row == -1) {
	        return new $.wijmo.wijspread.Range(0, cellRange.col, rowCount, cellRange.colCount);
	    }else if (cellRange.col == -1) {
	        return new $.wijmo.wijspread.Range(cellRange.row, 0, cellRange.rowCount, columnCount);
	    }
	    return cellRange;
	}
	
	/**
	 * 是否只选中单一单元格
	 */
   	function isChooseSingleCell(){
    	var sheet = getCurrentSheet();
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
   	
   	/**
   	 * 判断是否需要锁定sheet，单元格不可编辑
   	 */
   	function judgeNeedLockSheet(r, c){
		var dataobj = getCurrentDataObj();
   		var etype = "";
   		if(dataobj.ecs && dataobj.ecs[r+","+c] && dataobj.ecs[r+","+c].etype)
   			etype = dataobj.ecs[r+","+c].etype;
   		var lock = true;
   		if(etype === "" || etype === celltype.TEXT || etype === celltype.IMAGE || etype === celltype.LINKTEXT)
   			lock = false;
   		return lock;
	}
   	
   	/**
   	 * 判断所选区域是否包含标签页或者明细表
   	 * target:hover覆盖操作鼠标拖拽字段等；target:clean清除操作删除行清除内容等
   	 */
   	function judgeRangeHasArea(target){
   		var dataobj = getCurrentDataObj();
   		var sheet = getCurrentSheet();
      	var sels = sheet.getSelections();
		for (var n = 0; n < sels.length; n++) {
			var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
			for (var i = 0; i < sel.rowCount; i++) {
				for (var j = 0; j < sel.colCount; j++) {
					var r = sel.row + i;
          			var c = sel.col + j;
          			if(dataobj && dataobj.ecs && dataobj.ecs[r+","+c]){
          				var etype = dataobj.ecs[r+","+c].etype;
          				if(etype === celltype.DETAIL || etype === celltype.TAB
          					|| etype === celltype.PORTAL || etype === celltype.IFRAME || etype === celltype.SCANCODE)
          					return true;
          				else if(etype === celltype.MC){
          					if(target === "clean" || (target === "hover" && !isAutoExtendMoreContent))
          						return true;
          				}
          			}
				}
			}
		}
		return false;
   	}
   	
   	/**
   	 * 判断单元格是否含图片，默认含缩进2.5
   	 */
   	function judgeCellDefaultRetract(cellobj){
   		var etype = cellobj.etype;
   		if(etype === celltype.FCONTENT || etype === celltype.DETAIL || etype === celltype.TAB 
			|| etype === celltype.MC || etype === celltype.PORTAL 
			|| etype === celltype.IFRAME || etype === celltype.SCANCODE || etype === celltype.DE_BTN 
			|| etype === celltype.DE_CHECKALL || etype === celltype.DE_CHECKSINGLE
			|| etype === celltype.DE_SERIALNUM || etype === celltype.SUMFCONTENT
			|| (etype === celltype.Fname && !!cellobj.financial)){
   			return true;
   		}else
   			return false;
   	}
   	   	
   	/**
	 * 获取Sheet第一个选中区域第一个单元格ID
	 */
	function getSelectedCellid(){
		var sheet = getCurrentSheet();
		var sels = sheet.getSelections();
		var range = getActualCellRange(sels[0], sheet.getRowCount(), sheet.getColumnCount());
		var cellobj = {};
		cellobj.row = range.row;
		cellobj.col = range.col;
		return cellobj;
	}
	
	/**
	 * 设置样式、字体、背景色、加粗、斜体
	 */
	function setMjiStyle(o, styleWay, param1) {
	   	var dataobj = getCurrentDataObj();
	    var sheet = getCurrentSheet();
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
						var r = i + range.row;
						var c = j + range.col;
	                    var _style = sheet.getStyle(r, c, $.wijmo.wijspread.SheetArea.viewport);
	                    if(_style == undefined)
	                        _style = new $.wijmo.wijspread.Style();
	                    
	                    if(styleWay == "bgcolor"){
	                        _style.backColor = param1;
	                        if(param1 === "transparents")
	                        	delete _style.backColor;
	                    }else if (styleWay == "fontcolor"){
	                        _style.foreColor = param1;
	                        if(!param1)
	                        	delete _style.foreColor;
	                    }else if (styleWay == "fontfamliy"){
	                        if(_style.font == undefined)
	                             _style.font = "9pt " + param1;
	                        else{
	                        	var fontfamily = getCellFontFamily(_style.font);
	                        	if(fontfamily == "")
	                        		_style.font = "9pt " + param1;
	                        	else
	                        		_style.font = _style.font.replace(fontfamily, param1);
	                        }
	                    }else if (styleWay == "fontsize"){
	                        if(_style.font == undefined)
	                            _style.font = param1 + " Microsoft YaHei";
	                        else
	                            _style.font = _style.font.replace((/\d+pt/g),param1);
	                    }else if(styleWay == "bold"){
							if(_style.font == undefined){
								if(addBold)
									_style.font = "bold 9pt Microsoft YaHei";
							}else{
								if(addBold && _style.font.indexOf("bold") == -1){
									if(_style.font.indexOf("italic") > -1)
										_style.font = _style.font.replace("italic","italic bold");
									else
										_style.font = "bold " + _style.font;
								}
								if(!addBold && _style.font.indexOf("bold") > -1)
									_style.font = _style.font.replace("bold ","");
							}
	                    }else if(styleWay == "italic"){
	                    	if(_style.font == undefined){
								if(addItalic)
									_style.font = "italic 9pt Microsoft YaHei";
							}else{
								if(addItalic && _style.font.indexOf("italic") == -1)
									_style.font = "italic " + _style.font;
								if(!addItalic && _style.font.indexOf("italic") > -1)
									_style.font = _style.font.replace("italic ","");
							}
	                    }
	                    sheet.setStyle(r, c, _style, $.wijmo.wijspread.SheetArea.viewport);
	                    setCellProperties(r+","+c, "");
	                }
	            }
	        }
	        sheet.isPaintSuspended(false);
	    }catch (ex) {
	        window.top.Dialog.alert(ex.message);
	    }
	}
	
	/**
	 * 获取单元格当前字体
	 */
	function getCellFontFamily(cellfont){
		var fontfamily = "";
		jQuery(".excelHeadContent #fontfamily").find("option").each(function(){
			var val = jQuery(this).val();
			if(cellfont.indexOf(val) > -1){
				fontfamily = val;
				return false;
			}
		});
		return fontfamily;
	}
	
	/**
	 * 对齐方式 封装
	 */
	function alignBx(alignJson){
		//垂直对齐
	   	var a_valign = alignJson.a_valign;
		if(a_valign === "0")
			a_valign = $.wijmo.wijspread.VerticalAlign.top;
		else if(a_valign === "1")
			a_valign = $.wijmo.wijspread.VerticalAlign.center;
		else if(a_valign === "2")
			a_valign = $.wijmo.wijspread.VerticalAlign.bottom;
		else
			a_valign = null;
		//水平对齐	
		var a_halign = alignJson.a_halign;
		if(a_halign === "0")
			a_halign = $.wijmo.wijspread.HorizontalAlign.left;
		else if(a_halign == "1")
			a_halign = $.wijmo.wijspread.HorizontalAlign.center;
		else if(a_halign == "2")
			a_halign = $.wijmo.wijspread.HorizontalAlign.right;
		else 
			a_halign = null;
		
	   	var dataobj = getCurrentDataObj();
	    var sheet = getCurrentSheet();
	    sheet.isPaintSuspended(true);
		var sels = sheet.getSelections();
	 	for (var index = 0; index < sels.length; index++) {
	   	 	var sel = getActualCellRange(sels[index], sheet.getRowCount(), sheet.getColumnCount());
	   	 	//设置垂直对齐
	   		if(a_valign != null)
	   			sheet.getCells(sel.row, sel.col, sel.row + sel.rowCount - 1, sel.col + sel.colCount - 1, $.wijmo.wijspread.SheetArea.viewport).vAlign(a_valign);
	       	//设置水平对齐
	       	if(a_halign != null){
				for (var i = 0; i < sel.rowCount; i++) {
					for (var j = 0; j < sel.colCount; j++) {
						var r = sel.row + i;
		               	var c = sel.col + j;
		               	var _style = sheet.getStyle(r, c, $.wijmo.wijspread.SheetArea.viewport);
						if(_style == undefined)
	                        _style = new $.wijmo.wijspread.Style();
		               	var cellHAlign = $.wijmo.wijspread.HorizontalAlign.left;
						if(_style.hAlign)	cellHAlign = _style.hAlign;
						if(dataobj.ecs[r+","+c] && cellHAlign != a_halign){		//对齐方式不一致才需要调整缩进
							var hasDefaultRetract = judgeCellDefaultRetract(dataobj.ecs[r+","+c]);
							if(a_halign === $.wijmo.wijspread.HorizontalAlign.left && hasDefaultRetract)
								sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).textIndent(2.5);
							else
								sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).textIndent(0);
						}
						sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).hAlign(a_halign);
					}
				}
	       	}
	    }
		sheet.isPaintSuspended(false);
	}
	
	/**
	 * 增加/减少 缩进
	 */
	function cellRetract(type){
   		var dataobj = getCurrentDataObj();
       	var sheet = getCurrentSheet();
       	sheet.isPaintSuspended(true);
       	var sels = sheet.getSelections();
		for (var n = 0; n < sels.length; n++) {
			var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
			for (var i = 0; i < sel.rowCount; i++) {
				for (var j = 0; j < sel.colCount; j++) {
					var r = i + sel.row;
					var c = j + sel.col;
					if(!!!dataobj.ecs[r+","+c])
						continue;
					var etype = dataobj.ecs[r+","+c].etype;
					if(etype===celltype.DETAIL || etype===celltype.DE_TITLE || etype===celltype.DE_TAIL || etype===celltype.DE_BTN)
						continue;
						
					var _style = sheet.getStyle(r, c, $.wijmo.wijspread.SheetArea.viewport);
					if(_style == undefined)
						_style = new $.wijmo.wijspread.Style();
					var curTextIndent = _style.textIndent ? _style.textIndent : 0;
					if(curTextIndent < 0)	curTextIndent = 0;
					var hasDefaultRetract = judgeCellDefaultRetract(dataobj.ecs[r+","+c]);
					var isAlignLeft = (!_style.hAlign || _style.hAlign === $.wijmo.wijspread.HorizontalAlign.left);
					if(type === "increase" && curTextIndent<100){		//增加缩进量
						curTextIndent = curTextIndent + 0.5;
						sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).textIndent(curTextIndent);
					}else if(type === "reduce" && curTextIndent>0){	//减少缩进量
						curTextIndent = curTextIndent - 0.5;
						if(isAlignLeft && hasDefaultRetract){
							if(curTextIndent >= 2.5)
								sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).textIndent(curTextIndent);
						}else{
							sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).textIndent(curTextIndent);
						}
					}
				}
			}
		}
		sheet.isPaintSuspended(false);
	}
	
	/**
	 * 边框设置
	 */
	function drawborder(){
   		var borderval = $(".excelHeadContent").find("[name=bordertype]").val();
		var bordercolor = $(".excelHeadContent").find(".bordercolorvalue").val();
		var borderstyle = parseInt($(".excelHeadContent").find("[name=borderline]").val());
		var whichborder = "";
     	switch (borderval){
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
      	var sheet = getCurrentSheet();
        var lineBorder = new $.wijmo.wijspread.LineBorder(bordercolor, borderstyle);
        var sels = sheet.getSelections();
        sheet.isPaintSuspended(true);
        for (var n = 0; n < sels.length; n++) {
            var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
            if(whichborder != ""){
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
	            setAreaHaveProperties(sel);
            }else{
                sheet.setBorder(sel, null, {all:true});
            }
        }
        sheet.isPaintSuspended(false);
   	}
   	
   	/**
   	 * 设置某区域所有单元格包含属性，即单元格赋值默认的dataobj
   	 */
   	function setAreaHaveProperties(sel){
   		for (var i = 0; i < sel.rowCount; i++) {
			for (var j = 0; j < sel.colCount; j++) {
				var r = sel.row + i;
				var c = sel.col + j;
				setCellProperties(r+","+c, "");
			}
		}
   	}
	
	/**
	 * 自动换行封装
	 */
	function autowrapBx(wrap){
	    var sheet = getCurrentSheet();
	    sheet.isPaintSuspended(true);
	    var sels = sheet.getSelections();
	    for (var index = 0; index < sels.length; index++) {
	        var sel = getActualCellRange(sels[index], sheet.getRowCount(), sheet.getColumnCount());
	        sheet.getCells(sel.row, sel.col, sel.row + sel.rowCount - 1, sel.col + sel.colCount - 1, $.wijmo.wijspread.SheetArea.viewport).wordWrap(wrap);
	    }
	    sheet.isPaintSuspended(false);
	}
	
	/**
	 * 合并单元格
	 */
	function mergenBx(){
		var dataobj = getCurrentDataObj();
	    var sheet = getCurrentSheet();
	   	var sels = sheet.getSelections();
	   	var sels_cache = new Array();	//_mergenBx过程中setActiveCell会导致getSelections()区域改变，故加缓存解决多区域合并单元格
	   	var needConfirm = false;
	   	for(var index=0;index<sels.length;index++){
	   		var sel = getActualCellRange(sels[index], sheet.getRowCount(), sheet.getColumnCount());
	   		var merAry = new Array();
	   		sels_cache.push(sel);
	   		for (var i = 0; i < sel.rowCount; i++) {
				for (var j = 0; j < sel.colCount; j++) {
					var r = sel.row + i;
	               	var c = sel.col + j;
					if(dataobj.ecs && dataobj.ecs[r+","+c] && dataobj.ecs[r+","+c].etype)
						merAry.push(dataobj.ecs[r+","+c]);
				}
			}
			if(merAry && merAry.length > 1)
				needConfirm = true;
	   	}
	   	if (needConfirm) {
	   		window.top.Dialog.confirm(_excel_reminder_2,function(){
	       		mergenBx_AllArea(sels_cache);
	       	});
	   	} else {
	   		mergenBx_AllArea(sels_cache);
	   	}
	}
	//多个区域合并单元格
	function mergenBx_AllArea(sels_cache){
		var dataobj = getCurrentDataObj();
		var sheet = getCurrentSheet();
		for (var index=0; index<sels_cache.length; index++) {
	   		var sel = sels_cache[index];
	   		var merAry = new Array();
	   		var isSingleMergenCell = true;		//是否仅为一个已合并单元格
	   		for (var i = 0; i < sel.rowCount; i++) {
				for (var j = 0; j < sel.colCount; j++) {
					var r = sel.row + i;
	               	var c = sel.col + j;
					if(dataobj.ecs && dataobj.ecs[r+","+c] && dataobj.ecs[r+","+c].etype)
						merAry.push(dataobj.ecs[r+","+c]);
					var spans = sheet.getSpan(r,c,$.wijmo.wijspread.SheetArea.viewport);
					if (spans == null)
						isSingleMergenCell = false;
				}
			}
			if(!isSingleMergenCell)		//非单一合并单元格才需要执行合并逻辑
				_mergenBx(merAry, sel);
	   	}
	}
	//单个合并单元格
	function _mergenBx(merAry,sel){
		var dataobj = getCurrentDataObj();
	    var sheet = getCurrentSheet();
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
			if(dataobj && dataobj.ecs){
				dataobj.ecs[sel.row+","+sel.col] = merAry[0]; 
				dataobj.ecs[sel.row+","+sel.col].id = sel.row+","+sel.col;
			}
			sheet.addSpan(sel.row, sel.col, sel.rowCount, sel.colCount,$.wijmo.wijspread.SheetArea.viewport);
		}else{
			sheet.addSpan(sel.row, sel.col, sel.rowCount, sel.colCount,$.wijmo.wijspread.SheetArea.viewport);
			if(dataobj && dataobj.ecs)
				setCellProperties(sel.row+","+sel.col, "");
		}
		//先合并单元格，不失去焦点，直接插入明细表或字段，会出现插入无效Bug，故合并完后重新设置下ActiveCell
		sheet.setActiveCell(null, null);
		sheet.setActiveCell(sel.row, sel.col);
		//var st = setTimeout(function (){
			//清除合并后活动单元格以外的其他的单元格
			for (var i = 0; i < sel.rowCount; i++) {
				for (var j = 0; j < sel.colCount; j++) {
					if(i == 0 && j == 0) continue;
					var r = sel.row + i;
	               	var c = sel.col + j;
	               	if(sheet._dataModel.dataTable[r] && sheet._dataModel.dataTable[r][c]){
		               	delete sheet._dataModel.dataTable[r][c];
						if(dataobj && dataobj.ecs && dataobj.ecs[r+","+c]){
							restoreCellProperties("", r+","+c);
							delete dataobj.ecs[r+","+c];
						}
					}
				}
			}
			//如果有边框，需要重新画下外围边框
			sheet.isPaintSuspended(true);
			var _topborder = sheet.getCell(sel.row, sel.col, $.wijmo.wijspread.SheetArea.viewport).borderTop();
	        var _leftborder = sheet.getCell(sel.row, sel.col, $.wijmo.wijspread.SheetArea.viewport).borderLeft();
	        var _rightborder = sheet.getCell(sel.row, sel.col, $.wijmo.wijspread.SheetArea.viewport).borderRight();
	        var _bottomborder = sheet.getCell(sel.row, sel.col, $.wijmo.wijspread.SheetArea.viewport).borderBottom();
            sheet.setBorder(sel, _leftborder, {left: true});
            sheet.setBorder(sel, _rightborder, {right: true});
            sheet.setBorder(sel, _bottomborder, {bottom: true});
            sheet.setBorder(sel, _topborder, {top: true});
            sheet.isPaintSuspended(false);
		//	clearTimeout(st);
		//},100);
	}
	
	/**
	 * 拆分单元格
	 */
	function splitBx(){
	    var sheet = getCurrentSheet();
	    var sels = sheet.getSelections();
	    sheet.isPaintSuspended(true);
	    for(var index=0; index<sels.length; index++) {
	        var sel = getActualCellRange(sels[index], sheet.getRowCount(), sheet.getColumnCount());
	        for (var i = 0; i < sel.rowCount; i++) {
	            for (var j = 0; j < sel.colCount; j++) {
					var r = sel.row + i;
	               	var c = sel.col + j;
	                sheet.removeSpan(r, c);
	                /*if(i == 0 && j == 0) continue;
	                var _cell_val = sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).value();
	                if(!!_cell_val)		continue;
	               	if(sheet._dataModel.dataTable[r])
	               	if(sheet._dataModel.dataTable[r][c]){
		               	delete sheet._dataModel.dataTable[r][c];
					}*/
	            }
	        }
	    }
	    sheet.isPaintSuspended(false);
	}
   	
	/**
	 * 添加财务表头
	 */
	function setFinancial_head(){
		var dataobj = getCurrentDataObj();
    	var sheet = getCurrentSheet();
    	var ar = sheet.getActiveRowIndex();
    	var ac = sheet.getActiveColumnIndex();
    	if(dataobj && dataobj.ecs && dataobj.ecs[ar+","+ac]){
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
	}
	
	/**
	 * 添加财务表览
	 */
	function setFinancial_field(){
		var dataobj = getCurrentDataObj();
    	var sheet = getCurrentSheet();
    	var ar = sheet.getActiveRowIndex();
    	var ac = sheet.getActiveColumnIndex();
    	if(dataobj && dataobj.ecs && dataobj.ecs[ar+","+ac]){
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
	            	var status = getFieldAttr(dataobj.ecs[ar+","+ac].efieldid);
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
	}
	
	/**
	 * 添加财务-千分位
	 */
	function setFinancial_thousands(){
		var dataobj = getCurrentDataObj();
    	var sheet = getCurrentSheet();
    	var sels = sheet.getSelections();
    	sheet.isPaintSuspended(true);
		for (var n = 0; n < sels.length; n++) {
			var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
			for (var i = 0; i < sel.rowCount; i++) {
				for (var j = 0; j < sel.colCount; j++) {
					var ar = sel.row+i;
					var ac = sel.col+j;
					if(dataobj && dataobj.ecs && dataobj.ecs[ar+","+ac]){
						if(dataobj.ecs[ar+","+ac].etype === celltype.FCONTENT){
							sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImage("/workflow/exceldesign/image/controls/thousands_wev8.png");
    						sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
    						dataobj.ecs[ar+","+ac].financial = "4";
   						}
    				}
				}
			}
		}
		sheet.isPaintSuspended(false);
	}
	
	/**
	 * 添加财务-金额大写
	 */
	function setFinancial_upper(){
		var dataobj = getCurrentDataObj();
    	var sheet = getCurrentSheet();
    	var sels = sheet.getSelections();
    	for (var n = 0; n < sels.length; n++) {
			var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
			for (var i = 0; i < sel.rowCount; i++) {
				for (var j = 0; j < sel.colCount; j++) {
					var ar = sel.row+i;
					var ac = sel.col+j;
					if(dataobj && dataobj.ecs && dataobj.ecs[ar+","+ac]){
						if(dataobj.ecs[ar+","+ac].etype === celltype.FCONTENT){
							sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImage("/workflow/exceldesign/image/controls/financeUpper_wev8.png");
    						sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
    						dataobj.ecs[ar+","+ac].financial = "3";
   						}
    				}
				}
			}
		}
	}
	
	/**
	 * 清除内容接口
	 */
	function cleanCellContent(){
		if(judgeRangeHasArea("clean")){
			window.top.Dialog.confirm(_excel_reminder_3, function(){
				cleanCell(2);
			});
		}else{
			cleanCell(2);
		}
	}
	
	/**
	 * 清除全部接口
	 */
	function cleanCellAll(){
		if(judgeRangeHasArea("clean")){
			window.top.Dialog.confirm(_excel_reminder_3, function(){
				cleanCell(3);
			});
		}else{
			cleanCell(3);
		}
	}

	/**
   	 * 清除单元格格式 1：样式:2：内容:3：全部
   	 */
	function cleanCell(type){
   		var dataobj = getCurrentDataObj();
   		var sheet = getCurrentSheet();
   		try{
          	var sels = sheet.getSelections();
          	sheet.isPaintSuspended(true);
			for (var n = 0; n < sels.length; n++) {
				var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
				for (var i = 0; i < sel.rowCount; i++) {
					for (var j = 0; j < sel.colCount; j++) {
						var r = sel.row + i;
              			var c = sel.col + j;
              			if(isEditMoreContent && c != 0)		//多字段内容清除操作只针对第一列
              				continue;
						if(dataobj && dataobj.ecs && dataobj.ecs[r+","+c]){
							if(type == 1){
								sheet.setStyle(r, c, null, $.wijmo.wijspread.SheetArea.viewport);
								delete dataobj.ecs[r+","+c].enumbric;
		                   		if(dataobj.ecs[r+","+c].etype === celltype.DE_TITLE || dataobj.ecs[r+","+c].etype===celltype.DE_TAIL){
		                   			var _style = new $.wijmo.wijspread.Style();
	                   				_style.backColor = "#eeeeee";
	                   				sheet.setStyle(r, c, _style, $.wijmo.wijspread.SheetArea.viewport);
		                   		}else{		//清除格式时设计器添加图片不能清除掉
		                   			var etype = dataobj.ecs[r+","+c].etype;
		                   			var imgsrc = "";
		                   			if(etype === celltype.FNAME && dataobj.ecs[r+","+c].financial)
		                   				imgsrc = "/workflow/exceldesign/image/controls/financeTitle_wev8.png";
		                   			else if(etype === celltype.FCONTENT)
		                   				imgsrc = getCellFieldImage(dataobj.ecs[r+","+c]);
		                   			else if(etype === celltype.DETAIL)
		                   				imgsrc = "/workflow/exceldesign/image/shortBtn/detail/detailTable_wev8.png";
		                   			else if(etype === celltype.TAB)
		                   				imgsrc = "/workflow/exceldesign/image/rightBtn/tabsmall_wev8.png";
		                   			else if(etype === celltype.MC)
		                   				imgsrc = "/workflow/exceldesign/image/shortBtn/morecontent/more_wev8.png";
		                   			else if(etype === celltype.PORTAL)
		                   				imgsrc = "/workflow/exceldesign/image/controls/portal_wev8.png";
		                   			else if(etype === celltype.IFRAME)
		                   				imgsrc = "/workflow/exceldesign/image/controls/iframeArea_wev8.png";
		                   			else if(etype === celltype.SCANCODE){
		                   				if(dataobj.ecs[r+","+c].jsonparam && dataobj.ecs[r+","+c].jsonparam.codetype)
		                   					imgsrc = "/workflow/exceldesign/image/controls/scanCode_"+dataobj.ecs[r+","+c].jsonparam.codetype+"_wev8.png";
		                   			}else if(etype === celltype.DE_BTN || etype === celltype.DE_CHECKALL
		                   				|| etype === celltype.DE_CHECKSINGLE || etype === celltype.DE_SERIALNUM){
		                   				imgsrc = "/workflow/exceldesign/image/shortBtn/detail/"+etype+"_wev8.png";
		                   			}else if(etype === celltype.SUMFCONTENT){
		                   				imgsrc = "/workflow/exceldesign/image/shortBtn/detail/detailSumField_wev8.png";
		                   			}
		                   			if(imgsrc != ""){
		                   				var cell = sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport);
		                   				cell.backgroundImage(imgsrc);
										cell.backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
										cell.textIndent(2.5);
		                   			}
		                   		}
							}else if(type == 2){
								cleanCellText(sheet, dataobj.ecs[r+","+c], r, c);
	                   			if(dataobj.ecs[r+","+c].etype === celltype.DE_TITLE || dataobj.ecs[r+","+c].etype === celltype.DE_TAIL)
	                   				sheet.setStyle(r, c, null, $.wijmo.wijspread.SheetArea.viewport);
	                   			sheet.setIsProtected(false);
							}else if(type == 3){
								sheet.setStyle(r, c, null, $.wijmo.wijspread.SheetArea.viewport);
								sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).value("");
								sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).backgroundImage(null);
								sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).textIndent(0);
								restoreCellProperties("", r+","+c);
								delete dataobj.ecs[r+","+c];
								sheet.setIsProtected(false);
							}
							if(type == 2 || type == 3){		//删除单元格上公式
								formulaOperate.deleteCellFormulaFace(r+","+c);
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
   	
	/**
	 * 清除指定单元格内容
	 */
	function cleanCellText(sheet, cellobj, r, c){
		sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).value("");
		sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).backgroundImage(null);
		sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).textIndent(0);
		restoreCellProperties("", r+","+c);
		cellobj.etype = "";
   		delete cellobj.efieldid;
   		delete cellobj.efieldtype;
		delete cellobj.formula;
		delete cellobj.financial;
   		delete cellobj.edetail;
   		delete cellobj.tab;
   		delete cellobj.mcpoint;
   		delete cellobj.jsonparam;
	}
	
	/**
	 * 清除财务格式
	 */
	function clearFinancial(){
		var dataobj = getCurrentDataObj();
    	var sheet = getCurrentSheet();
    	var sels = sheet.getSelections();
    	sheet.isPaintSuspended(true);
		for (var n = 0; n < sels.length; n++) {
			var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
			for (var i = 0; i < sel.rowCount; i++) {
				for (var j = 0; j < sel.colCount; j++) {
					var ar = sel.row+i;
					var ac = sel.col+j;
					if(dataobj && dataobj.ecs && dataobj.ecs[ar+","+ac]){
						if(!!dataobj.ecs[ar+","+ac].financial){
							delete dataobj.ecs[ar+","+ac].financial;
							if(dataobj.ecs[ar+","+ac].etype === celltype.FCONTENT){
								var imgsrc = getCellFieldImage(dataobj.ecs[ar+","+ac]);
								sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImage(imgsrc);
       						}else if(dataobj.ecs[ar+","+ac].etype === celltype.FNAME){
       							sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImage(null);
       							sheet.getCell(ar,ac,$.wijmo.wijspread.SheetArea.viewport).textIndent(0);
       						}
   						}
    				}
				}
			}
		}
		sheet.isPaintSuspended(false);
	}
	
	/**
	 * 显示网格线
	 */
	function showGridLine(obj){
		setBtnStatus(obj);
		var ishow = false;
		if(!!$(obj).attr("down"))
			if($(obj).attr("down") === "on")
				ishow =true;
    	var sheet = getCurrentSheet();
    	sheet.setGridlineOptions({ showHorizontalGridline: ishow, showVerticalGridline: ishow });
    	sheet.invalidateLayout();
		sheet.repaint();
	}
	
	/**
	 * 显示行、列头
	 */
	function showExcelHead(obj){
		setBtnStatus(obj);
		var ishow = false;
		if(!!$(obj).attr("down"))
			if($(obj).attr("down") === "on")
				ishow =true;
    	var sheet = getCurrentSheet();
    	sheet.isPaintSuspended(true);
		sheet.setRowHeaderVisible(ishow);
		sheet.setColumnHeaderVisible(ishow);
		sheet.isPaintSuspended(false);
	}
	
	/**
	 * 插入图片
	 */
	function addPic(){
    	var dialog = new window.top.Dialog();
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
    		var dataobj = getCurrentDataObj();
    		var ss = jQuery("#excelDiv").wijspread("spread");
			var sheet = ss.getActiveSheet();
        	var ar = sheet.getActiveRowIndex();		///当前活动单元格
        	var ac = sheet.getActiveColumnIndex();
        	sheet.isPaintSuspended(true); 
        	if(imgtype === "1"){
				if(dataobj && dataobj.ecs && dataobj.ecs[ar+","+ac] && dataobj.ecs[ar+","+ac].etype){
					if(dataobj.ecs[ar+","+ac].etype === celltype.TEXT || dataobj.ecs[ar+","+ac].etype === "" 
						|| dataobj.ecs[ar+","+ac].etype === celltype.IMAGE);
					else{
						window.top.Dialog.alert("单元格内非文本,禁止插入图片!");
						sheet.isPaintSuspended(false); 
						return;
					}
				}
				var cell = {};
				cell.efieldid=imgSrc;
				cell.efieldtype = imgtype;
				setCellProperties(ar+","+ac,celltype.IMAGE,cell);
				autoExtendRowCol(sheet, ar, ac);
			  	sheet.getCell(ar, ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImage(imgSrc);
			  	sheet.getCell(ar, ac,$.wijmo.wijspread.SheetArea.viewport).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
		  	}else if(imgtype === "2"){
				addBgImg(imgSrc);
		  	}else if(imgtype === "3"){
		  		var sels = sheet.getSelections();
		  		var startrow = 0;
		  		var startcol = 0;
		  		var endrow = 0;
		  		var endcol = 0;
		  		if(sels.length>0){
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
		  	if(imgtype === "2"){
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
	}
	
	/**
	 * 添加背景图
	 */
	function addBgImg(imgSrc){
		var ss = jQuery("#excelDiv").wijspread("spread");
		ss.backgroundImage(imgSrc);
  		ss.backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
  		if(imgSrc)
  			jQuery(".excelHeadContent").find("[name=clearBgImg]").removeClass("shortBtn_disabled").addClass("shortBtn");
	}
	
	/**
	 * 清除背景图,参数excelDiv不传则默认为主面板
	 */
	function clearBgImg(excelDiv){
		if(typeof excelDiv == "undefined")
			excelDiv = jQuery("#excelDiv");
		var ss = excelDiv.wijspread("spread");
    	ss.backgroundImage(null);
  		ss.backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
  		if(excelDiv.attr("id") == "excelDiv")
  			jQuery(".excelHeadContent").find("[name=clearBgImg]").removeClass("shortBtn").addClass("shortBtn_disabled");
	}
	
	
	
	/**
	 * 获取当前选中的自定义属性
	 */
	function getCurrentAttrs(){
		var attrs = {};
		var dataobj = getCurrentDataObj();
		if(rightMenuSelectCase == "row" || rightMenuSelectCase == "col"){
			var sheet = getCurrentSheet();
			var sels = sheet.getSelections();
        	var sel = getActualCellRange(sels[0], sheet.getRowCount(), sheet.getColumnCount());
        	if(rightMenuSelectCase == "row"){
	        	var firstRow = sel.row;
	        	if(dataobj && dataobj.rowattrs && dataobj.rowattrs["row_"+firstRow])
	        		attrs = dataobj.rowattrs["row_"+firstRow];
        	}else if(rightMenuSelectCase == "col"){
        		var firstCol = sel.col;
        		if(dataobj && dataobj.colattrs && dataobj.colattrs["col_"+firstCol])
        			attrs = dataobj.colattrs["col_"+firstCol];
        	}
		}else if(rightMenuSelectCase == "nor"){
			var cellid = getSelectedCellid();
			var r = cellid.row;
			var c = cellid.col;
			var dataobj = getCurrentDataObj();
			if(dataobj && dataobj.ecs && dataobj.ecs[r+","+c] && dataobj.ecs[r+","+c].attrs)
				attrs = dataobj.ecs[r+","+c].attrs;
		}
		return attrs;
	}
	
	/**
	 * 设置自定义属性
	 */
	function setCustomAttr(){
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/exceldesign/setCustomAttr.jsp?isDetail="+isDetail+"&locatetarget="+rightMenuSelectCase;
		dialog.Title = "设置自定义属性";
		dialog.Width = 400;
		dialog.Height = 500;
		dialog.Drag = true; 	
		dialog.URL = url;
		dialog.callbackfun=function(paramobj, result){
			var sheet = getCurrentSheet();
			var dataobj = getCurrentDataObj();
			var sels = sheet.getSelections();
			if(rightMenuSelectCase === "row"){
				if(typeof dataobj.rowattrs == "undefined")
					dataobj.rowattrs = {};
				var rowattrs = dataobj.rowattrs;
				for(var n = 0; n < sels.length; n++){
		        	var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
		        	for(var i = 0; i<sel.rowCount; i++) {
		        		var r = sel.row + i;
		        		if(jQuery.isEmptyObject(result)){
		        			delete rowattrs["row_"+r];
		        			sheet.getCell(r, 0, $.wijmo.wijspread.SheetArea.rowHeader).foreColor(null);
		        		}else{
		        			rowattrs["row_"+r] = result;
		        			sheet.getCell(r, 0, $.wijmo.wijspread.SheetArea.rowHeader).foreColor("#cc0000");
		        		}
		        	}
		        }
			}else if(rightMenuSelectCase === "col"){
				if(typeof dataobj.colattrs == "undefined")
					dataobj.colattrs = {};
				var colattrs = dataobj.colattrs;
				for(var n = 0; n < sels.length; n++){
		        	var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
		        	for(var i = 0; i<sel.colCount; i++) {
		        		var c = sel.col + i;
		        		if(jQuery.isEmptyObject(result)){
		        			delete colattrs["col_"+c];
		        			sheet.getCell(0, c, $.wijmo.wijspread.SheetArea.colHeader).foreColor(null);
		        		}else{
		        			colattrs["col_"+c] = result;
		        			sheet.getCell(0, c, $.wijmo.wijspread.SheetArea.colHeader).foreColor("#cc0000");
		        		}
		        	}
		        }
			}else if(rightMenuSelectCase === "nor"){
				for(var n = 0; n < sels.length; n++){
					var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
					for(var i = 0; i < sel.rowCount; i++){
						for(var j = 0; j < sel.colCount; j++){
							var r = sel.row + i;
							var c = sel.col + j;
		          			if(dataobj && dataobj.ecs){
		          				if(dataobj.ecs[r+","+c])
		          					delete dataobj.ecs[r+","+c].attrs;
		          				if(!jQuery.isEmptyObject(result))
		          					setCellProperties(r+","+c, "", {"attrs": result});
		          				//同步属性Tip信息
		          				addCellAttrTip(r, c, result);
		          			}
						}
					}
				}
				controlDiscriptionArea();
			}
		}
		dialog.show();
	}
	
	/**
	 * 添加单元格属性Tip
	 */
	function addCellAttrTip(r, c, attrs){
		var tipheight = 0;
		var tiptext = "";
		//var isfirst = true;
		if(!jQuery.isEmptyObject(attrs)){
			for(key in attrs){
				if(key === "hide"){
					if(attrs[key] === "y"){
						//tiptext += "<div class=showtip1>隐藏内容 : 是</div>";
						tiptext += "隐藏内容 : 是"+"\n";
						tipheight += 30;
					}
				}else{
					/*if(isfirst){
						tiptext += "<div class=showtip1>自定义属性 : </div>";
						tipheight += 30;
						isfirst = false;
					}*/
					//tiptext += "<div class=showtip2>"+key+" : "+attrs[key]+"</div>";
					tiptext += key+" : "+attrs[key]+"\n";
					tipheight += 22;
				}
			}
		}
		var tipinfo = {};
		tipinfo.row = r;
		tipinfo.col = c;
		tipinfo.text = tiptext;
		tipinfo.height = tipheight;
		//tipinfo.model = $.wijmo.wijspread.DisplayMode.AlwaysShown;
		tipinfo.showModel = $.wijmo.wijspread.DisplayMode.HoverShown;
		controlCellTip(tipinfo);
	}
	
	/**
	 * 显示tip
	 */
	function controlCellTip(tipinfo){
		var sheet = getCurrentSheet();
		var comment = new $.wijmo.wijspread.Comment(); 
        comment.text(tipinfo.text); 
        comment.displayMode(tipinfo.model); 
        comment.location(new $.wijmo.wijspread.Point(50, -50)); 
        comment.height((tipinfo.height<50?(tipinfo.height+20):tipinfo.height)); 
        comment.showShadow(true); 
        comment.backColor(tipinfo.bgcolor?tipinfo.bgcolor:"yellow"); 
        comment.fontStyle("normal");
        if(tipinfo.height > 0)
        	sheet.setComment(tipinfo.row, tipinfo.col, comment);
        else
        	sheet.setComment(tipinfo.row, tipinfo.col, null);
	}
	
	/**
	 * 设置 字段 必填 只读 编辑
	 */
	function setFieldPro(fieldattr){
   		var dataobj = getCurrentDataObj();
   		if (dataobj.ecs === undefined ||  ""===dataobj.ecs)	//单元格自定义属性都没有，那还要做什么呢？
   			return;
       	var sheet = getCurrentSheet();
       	var sels = sheet.getSelections();
       	sheet.isPaintSuspended(true);
       	for (var n = 0; n < sels.length; n++) {
			var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
			for (var i = 0; i < sel.rowCount; i++) {
				for (var j = 0; j < sel.colCount; j++) {
					var r = i + sel.row;
					var c = j + sel.col;
					if(!dataobj.ecs[r+","+c]) continue;	//如果单元格没有自定义属性，下面就不需要做什么了
					if(dataobj.ecs[r+","+c].etype === celltype.FCONTENT){
						var efiledid = parseInt(dataobj.ecs[r+","+c].efieldid);
						setFieldAttr(efiledid,fieldattr);
						var imgsrc = getCellFieldImage(dataobj.ecs[r+","+c], fieldattr);
						sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).backgroundImage(imgsrc);
						sheet.getCell(r,c,$.wijmo.wijspread.SheetArea.viewport).backgroundImageLayout($.wijmo.wijspread.ImageLayout.None);
					}
				}
			}
		}
       	sheet.isPaintSuspended(false);
	}
   	
	/**
	 * 设置字段属性
	 */
	function set_Fieldpro(){
		var dataobj = getCurrentDataObj();
    	var sheet = getCurrentSheet();
    	var ar = sheet.getActiveRowIndex();		///当前活动单元格
    	var ac = sheet.getActiveColumnIndex();
    	var efieldid = dataobj.ecs[ar+","+ac].efieldid;
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/exceldesign/excel_fieldattr.jsp?efieldid="+efieldid+"&isDetail="+isDetail;
		dialog.Title = "字段属性";
		dialog.Width = 600;
		dialog.Height = 600;
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	}
	
	/**
	 * 设置更多属性
	 */
	function set_Morepro(){
		var dataobj = getCurrentDataObj();
    	var sheet = getCurrentSheet();
    	var ar = sheet.getActiveRowIndex();		///当前活动单元格
    	var ac = sheet.getActiveColumnIndex();
    	var efieldid = dataobj.ecs[ar+","+ac].efieldid;
   		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/exceldesign/excel_fieldattrMore.jsp?efieldid="+efieldid+"&isDetail="+isDetail;
		dialog.Title = "更多属性";
		dialog.Width = 500;
		dialog.Height = 600;
		dialog.Drag = true; 	
		dialog.URL = url;
		dialog.show();
	}
	 
	/**
	 * 明细点击下拉菜单
	 */
   	function getDetailMenuJson(){
   		var detailMenuStr = "";
		var detaiMenuJson; 
		if(!isDetail){
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
			detaiMenuJson = JSON.parse(detailMenuStr); 
		}
		return detaiMenuJson;
   	}
   	
   	/**
   	 * 样式初始化
   	 */
   	function initStyleTab(){
		var e_style_1 = $(".s_style").find("div[name=e_style_1]");
		//初始化样式2
		var e_style_2 = $(e_style_1).clone();
		$(e_style_2).find("div[name^=_label],div[name^=_field]").css("border-color","#dcc68f");
		$(e_style_2).find("div[name^=_label]").css("background","#fbf7e7");
		$(e_style_2).attr("name","e_style_2").attr("target","sys_2");
		$(e_style_2).find("input[name='_css']")
			.attr("_border_color","#dcc68f").attr("_label_background","#fbf7e7");
		$(".typeContainer").append(e_style_2);
		
		//初始化样式3
		var e_style_3 = $(e_style_1).clone();
		$(e_style_3).find("div[name^=_label],div[name^=_field]").css("border-color","#8acc97");
		$(e_style_3).find("div[name^=_label]").css("background","#e7fdec");
		$(e_style_3).attr("name","e_style_3").attr("target","sys_3");
		$(e_style_3).find("input[name='_css']")
			.attr("_border_color","#8acc97").attr("_label_background","#e7fdec");
		$(".typeContainer").append(e_style_3);
		
		//初始化样式4
		var e_style_4 = $(e_style_1).clone();
		$(e_style_4).find("div[name^=_label],div[name^=_field]").css("border-color","#dba8a8");
		$(e_style_4).find("div[name^=_label]").css("background","#fce9e8");
		$(e_style_4).attr("name","e_style_4").attr("target","sys_4");
		$(e_style_4).find("input[name='_css']")
			.attr("_border_color","#dba8a8").attr("_label_background","#fce9e8");
		$(".typeContainer").append(e_style_4);
		
		//初始化样式5
		var e_style_5 = $(e_style_1).clone();
		$(e_style_5).find("div[name^=_label],div[name^=_field]").css("border-color","#c3a2d4");
		$(e_style_5).find("div[name^=_label]").css("background","#f6eafb");
		$(e_style_5).attr("name","e_style_5").attr("target","sys_5");
		$(e_style_5).find("input[name='_css']")
			.attr("_border_color","#c3a2d4").attr("_label_background","#f6eafb");
		$(".typeContainer").append(e_style_5);
		
		//初始化样式6
		var e_style_6 = $(e_style_1).clone();
		$(e_style_6).find("div[name^=_label],div[name^=_field]").css("border-color","#d7db9b");
		$(e_style_6).find("div[name^=_label]").css("background","#fcfde8");
		$(e_style_6).attr("name","e_style_6").attr("target","sys_6");
		$(e_style_6).find("input[name='_css']")
			.attr("_border_color","#d7db9b").attr("_label_background","#fcfde8");
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
						var cloneObj = $(e_style_1).clone();
						manageCusStyle(cloneObj, result[key], true);
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
				$.ajax({
					url : "/workflow/exceldesign/excelStyleOperation.jsp",
					type : "post",
					data : {styleid:styleid,method:"searchone"},
					dataType:"JSON",
					success : function do4Success(msg){
						try{
							msg = jQuery.trim(msg);
							var result = JSON.parse(msg);
							var cloneObj = $(e_style_1).clone();
							manageCusStyle(cloneObj, result, true);
							$(".typeContainerFather").perfectScrollbar("update");
						}catch(e){
							window.top.Dialog.alert(e.message);
						}
					}
				});
			}
		});
   	}
   	
   		
	/**
	 * 显示自定义样式
	 */
   	function manageCusStyle(cloneObj, result, needAppend){
   		var _name = "e_style_"+($(".s_style .typeContainer").children().length+1);
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
		if(needAppend){
			$(cloneObj).on("click",function() {
				$(".typeContainer").find(".current").removeClass("current");
				$(this).addClass("current");
				setStylebycustom(this);
			});
			$(".typeContainer").append(cloneObj);
			bindStyleRightMenu(cloneObj);
		}
   	}
   	
   	/**
   	 * 绑定样式右键菜单
   	 */
	function bindStyleRightMenu(obj){
		jQuery(obj).contextMenu({
			menu : 'styleRightMenu',
			button: 3,	//3: right click, 1: left click
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
				menuJson += "},";
				menuJson += "{";
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
					$.ajax({
						url : "/workflow/exceldesign/excelStyleOperation.jsp",
						type : "post",
						data : {styleid:styleid,method:"searchone"},
						dataType:"JSON",
						success : function do4Success(msg){
							try{
								msg = jQuery.trim(msg);
								var result = JSON.parse(msg);
								var cloneObj = el;
								manageCusStyle(cloneObj, result, false);
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
   	
	/**
	 * 点击样式应用到当前窗体
	 */
	function setStylebycustom(obj){
		var styleJson;
		styleJson = {};
		var css_obj = jQuery(obj).find("input[name='_css']");
		if($(obj).is("[target^=sys]")){			//系统样式
			styleJson.main_border = css_obj.attr("_border_color");
			styleJson.main_label_bgcolor = css_obj.attr("_label_background");
			styleJson.main_field_bgcolor = "";
			styleJson.detail_border = css_obj.attr("_border_color");
			styleJson.detail_label_bgcolor = css_obj.attr("_label_background");
			styleJson.detail_field_bgcolor = "";
			_setStyleBycjson(styleJson);
		}else if($(obj).is("[target^=cus]")){	//自定义样式
			styleJson.main_border = css_obj.attr("_border_color");
			styleJson.main_label_bgcolor = css_obj.attr("_label_background");
			styleJson.main_field_bgcolor = css_obj.attr("_field_background");
			styleJson.detail_border = css_obj.attr("_detail_border");
			styleJson.detail_label_bgcolor = css_obj.attr("_detail_label_bgcolor");
			styleJson.detail_field_bgcolor = css_obj.attr("_detail_field_bgcolor");
			_setStyleBycjson(styleJson);
		}
	}
	//样式应用
	function _setStyleBycjson(cjson){
		if(globalData.getCacheValue("symbol") !== "main")
			return;
		for(var skey in globalData.getCache()){
			if(skey === "main" || skey.indexOf("tab_") >-1){
				var ss;
				var dataobj = globalData.getCacheValue(skey);
				var ecs = dataobj.ecs;
				if(skey === "main"){
					ss = jQuery("#excelDiv").wijspread("spread");
				}else if(skey.indexOf("tab_") >-1){		//恢复sheetjson到隐藏面板，再应用样式
					if(!globalSheet.hasCache(skey+"_sheet"))
						continue;
					var sheetjson = globalSheet.getCacheValue(skey+"_sheet");
					var excelDiv_hidden = jQuery("#excelDiv_hidden");
					formOperate.onlyResumePanelFace(excelDiv_hidden, sheetjson);
					ss = excelDiv_hidden.wijspread("spread");
				}
				var sheet = ss.getActiveSheet();
				sheet.isPaintSuspended(true);
				for(var cellid in ecs){
					var r = parseInt(cellid.split(",")[0]);
					var c = parseInt(cellid.split(",")[1]);
					var applyStyle = {};
					if(ecs[cellid].etype === celltype.FNAME || ecs[cellid].etype === celltype.NNAME 
						|| ecs[cellid].etype === celltype.DETAIL){
						applyStyle = {border: cjson.main_border, bgcolor: cjson.main_label_bgcolor};
					}else if(ecs[cellid].etype === celltype.FCONTENT || ecs[cellid].etype === celltype.NADVICE){
						applyStyle = {border: cjson.main_border, bgcolor: cjson.main_field_bgcolor};	
					}else{
						continue;
					}
					var lineBorder = new $.wijmo.wijspread.LineBorder(applyStyle.border, parseInt("1"));
					var sel = new $.wijmo.wijspread.Range(r, c, 1, 1);
					sheet.setBorder(sel, lineBorder, {all:true});
					if(applyStyle.bgcolor　|| applyStyle.border){
					 	var _style = sheet.getStyle(r, c, $.wijmo.wijspread.SheetArea.viewport);
			            if (_style == undefined) {
			                _style = new $.wijmo.wijspread.Style();
			            }
			            _style.backColor = applyStyle.bgcolor;
			            sheet.setStyle(r, c, _style, $.wijmo.wijspread.SheetArea.viewport);
					}
		            var spans = sheet.getSpans(new $.wijmo.wijspread.Range(r, c, 1, 1));
		            if(!!spans && spans.length > 0){
		           		if (spans[0]){
		                   	for (var i = 0; i < spans[0].rowCount; i++) {
		           				for (var j = 0; j < spans[0].colCount; j++) {
		           					r = spans[0].row + i;
		           					c = spans[0].col + j;
		           					var lineBorder = new $.wijmo.wijspread.LineBorder(applyStyle.border, parseInt("1"));
									var sel = new $.wijmo.wijspread.Range(r, c, 1, 1);
									sheet.setBorder(sel, lineBorder, {all:true});
								 	var _style = sheet.getStyle(r, c, $.wijmo.wijspread.SheetArea.viewport);
				                    if (_style == undefined) {
				                        _style = new $.wijmo.wijspread.Style();
				                    }
				                    _style.backColor = applyStyle.bgcolor;
				                    sheet.setStyle(r, c, _style, $.wijmo.wijspread.SheetArea.viewport);
		           				}
		      				}
		                }
		           	}
				}
				sheet.isPaintSuspended(false);
				if(skey.indexOf("tab_") >-1){		//修改后的sheetjson重新写入缓存
					var cur_sheetJson = JSON.stringify(ss.toJSON());
    				globalSheet.addCache(skey+"_sheet", cur_sheetJson);
				}
			}else if(skey.indexOf("detail_") > -1){		//应用明细样式
				if(!globalSheet.hasCache(skey+"_sheet"))
					continue;
				var sheetJson = globalSheet.getCacheValue(skey+"_sheet");
				sheetJson = JSON.parse(sheetJson);
				var detailSheetECS;
				if(sheetJson.sheets.Sheet1.data && sheetJson.sheets.Sheet1.data.dataTable)
					detailSheetECS = sheetJson.sheets.Sheet1.data.dataTable;
					
				var detail_num_json = JSON.parse("{"+globalData.getCacheValue(skey)+"}");
				var detail_dataobj = detail_num_json[skey];
				if(detail_dataobj && detail_dataobj.ec)
				for(var cellid = 0; cellid<detail_dataobj.ec.length;cellid++){
					var r = parseInt(detail_dataobj.ec[cellid].id.split(",")[0]);
					var c = parseInt(detail_dataobj.ec[cellid].id.split(",")[1]);
					//边框处理
					if(detail_dataobj.ec[cellid].etype === transformerEtype(celltype.FNAME) 
						|| detail_dataobj.ec[cellid].etype === transformerEtype(celltype.FCONTENT)){
						if(!detailSheetECS[r][c].style)	
							detailSheetECS[r][c].style = {};
						//datajson
						var boderAry = new Array();
						boderAry.push({color:cjson.detail_border, kind:"top", style:"1"});
						boderAry.push({color:cjson.detail_border, kind:"left", style:"1"});
						boderAry.push({color:cjson.detail_border, kind:"right", style:"1"});
						boderAry.push({color:cjson.detail_border, kind:"bottom", style:"1"});
						detail_dataobj.ec[cellid].eborder = boderAry;
						//sheetjson
						detailSheetECS[r][c].style.borderTop = {color:cjson.detail_border, style:1};
						detailSheetECS[r][c].style.borderRight = {color:cjson.detail_border, style:1};
						detailSheetECS[r][c].style.borderLeft = {color:cjson.detail_border, style:1};
						detailSheetECS[r][c].style.borderBottom = {color:cjson.detail_border, style:1};
					}
					//背景色处理
					if(detail_dataobj.ec[cellid].etype === transformerEtype(celltype.FNAME)){
						detail_dataobj.ec[cellid].backgroundColor = cjson.detail_label_bgcolor;
						detailSheetECS[r][c].style.backColor = cjson.detail_label_bgcolor;
					}else if(detail_dataobj.ec[cellid].etype === transformerEtype(celltype.FCONTENT)){
						detail_dataobj.ec[cellid].backgroundColor = cjson.detail_field_bgcolor;
						detailSheetECS[r][c].style.backColor = cjson.detail_field_bgcolor;
					}
				}
				var detail_num_str = "\""+skey+"\":"+JSON.stringify(detail_dataobj);
				var sheet_num_str = JSON.stringify(sheetJson)
				globalData.addCache(skey,detail_num_str);
				globalSheet.addCache(skey+"_sheet",sheet_num_str);
			}
		}
	}
	
   	/**
   	 * 右键单元格菜单
   	 */
   	function getMenuJson(){
		var menuStr = "{";
			menuStr += "\"children\": [";
		if(rightMenuSelectCase === "nor" && wfinfo.layouttype == "0" && wfinfo.isactive == "1" && wfinfo.nodetype != "3"){	//非归档节点显示模板
	   		var _menu_rem = getFieldREM();
			var isfield = (_menu_rem.split(",")[0]==="true")?true:false;
			var istitlefield = (_menu_rem.split(",")[1]==="true")?true:false;
			var isspecial = (_menu_rem.split(",")[2]==="true")?true:false;
			var ispostion =  (_menu_rem.split(",")[3]==="true")?true:false;
			if(isfield || istitlefield || isspecial){
				menuStr += "{";
				menuStr += "\"title\" : \"只读\",";
				menuStr += "\"icon\": \"rmenuread\",";
				menuStr += "\"action\": \"readonly\"";
				menuStr += "},";
				if(!isDetail || (isDetail==="on" && ($("#dtladd").is(":checked") || $("#dtledit").is(":checked")))){
					if(isfield){
						menuStr += "{";
						menuStr += "\"title\" : \"编辑\",";
						menuStr += "\"icon\": \"rmenuedit\",";
						menuStr += "\"action\": \"canedit\"";
						menuStr += "},";
					}
					if((isfield && !ispostion) || istitlefield){
						menuStr += "{";
						menuStr += "\"title\" : \"必填\",";
						menuStr += "\"icon\": \"rmenurequired\",";
						menuStr += "\"action\": \"required\"";
						menuStr += "},";
						menuStr += "{";
						menuStr += "\"title\" : \"\"";
						menuStr += "},";
					}
				}
			}
		}
			menuStr += "{";
			menuStr += "\"title\" : \"剪切\",";
			menuStr += "\"icon\": \"rmenucut\",";
			menuStr += "\"action\": \"cut\"";
			menuStr += "},";
			menuStr += "{";
			menuStr += "\"title\" : \"复制\",";
			menuStr += "\"icon\": \"rmenucopy\",";
			menuStr += "\"action\": \"copy\"";
			menuStr += "},";
			menuStr += "{";
			menuStr += "\"title\" : \"粘贴\",";
			menuStr += "\"icon\": \"rmenupaste\",";
			menuStr += "\"action\": \"paste\"";
			menuStr += "},";
			menuStr += "{";
			menuStr += "\"title\" : \"\"";
			menuStr += "},";
			menuStr += "{";
			menuStr += "\"title\" : \"单元格格式\",";
			menuStr += "\"icon\": \"rmenupro\",";
			menuStr += "\"action\":\"setStyle\"";
			menuStr += "},";
			menuStr += "{";
			menuStr += "\"title\" : \"清除内容\",";
			menuStr += "\"icon\": \"rmenucleanc\",";
			menuStr += "\"action\":\"cleanContent\"";
			menuStr += "},";
			menuStr += "{";
			menuStr += "\"title\" : \"清除格式\",";
			menuStr += "\"icon\": \"rmenucleans\",";
			menuStr += "\"action\":\"cleanStyle\"";
			menuStr += "},";
			menuStr += "{";
			menuStr += "\"title\" : \"\"";
			menuStr += "},";
			if(isEditMoreContent || rightMenuSelectCase === "row"){
				menuStr += "{";
				menuStr += "\"title\" : \"插入行\",";
				menuStr += "\"icon\":\"rmenuinsertrow\",";
				menuStr += "\"action\":\"insertrow\"";
				menuStr += "},";
				menuStr += "{";
				menuStr += "\"title\" : \"删除行\",";
				menuStr += "\"icon\":\"rmenudelrow\",";
				menuStr += "\"action\":\"deleterow\"";
				menuStr += "},";
			}else if(rightMenuSelectCase === "col"){
				menuStr += "{";
				menuStr += "\"title\" : \"插入列\",";
				menuStr += "\"icon\":\"rmenuinsertcol\",";
				menuStr += "\"action\":\"insertcol\"";
				menuStr += "},";
				menuStr += "{";
				menuStr += "\"title\" : \"删除列\",";
				menuStr += "\"icon\":\"rmenudelcol\",";
				menuStr += "\"action\":\"deletecol\"";
				menuStr += "},";
			}else if(rightMenuSelectCase === "nor"){
				menuStr += "{";
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
				menuStr += "},";
				menuStr += "{";
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
				menuStr += "},";
			}
			if(isEditMoreContent){
				var sheet = getCurrentSheet();
				var sel = sheet.getSelections()[0];
				if(sel.row != 0){
					menuStr += "{";
					menuStr += "\"title\" : \"上移\",";
					menuStr += "\"icon\": \"rmenumoveup\",";
					menuStr += "\"action\":\"moveup\"";
					menuStr += "},";
				}
				if(sel.row+sel.rowCount < sheet.getRowCount()){
					menuStr += "{";
					menuStr += "\"title\" : \"下移\",";
					menuStr += "\"icon\": \"rmenumovedown\",";
					menuStr += "\"action\":\"movedown\"";
					menuStr += "},";
				}
			}else{
				menuStr += "{";
				menuStr += "\"title\" : \"行高\",";
				menuStr += "\"icon\": \"rmenurh\",";
				menuStr += "\"action\":\"setrowheight\"";
				menuStr += "},";
				menuStr += "{";
				menuStr += "\"title\" : \"列宽\",";
				menuStr += "\"icon\": \"rmenucw\",";
				menuStr += "\"action\":\"setcolwidth\"";
				menuStr += "},";
			}
			if(!isEditMoreContent && rightMenuSelectCase === "nor" && isDetail != "on" ){			//非明细窗口
				var detailnum = getDetailNum();
				if(parseInt(detailnum)>0){
					menuStr += "{";
					menuStr += "\"title\" : \"\"";
					menuStr += "},";
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
						if(i<parseInt(detailnum))
							menuStr += ",";
					}
					menuStr += "]";
					menuStr += "},";
				}
			}
			if(rightMenuSelectCase === "row" || (rightMenuSelectCase === "col" && isDetail==="on") || rightMenuSelectCase === "nor"){
				menuStr += "{";
				menuStr += "\"title\" : \"\"";
				menuStr += "},";
				menuStr += "{";
				if(rightMenuSelectCase === "row")
					menuStr += "\"title\" : \"行自定义属性\",";
				else if(rightMenuSelectCase === "col" && isDetail==="on")
					menuStr += "\"title\" : \"列自定义属性\",";
				else
					menuStr += "\"title\" : \"自定义属性\",";
				menuStr += "\"icon\": \"rmenuattr\",";
				menuStr += "\"action\":\"customAttr\"";
				menuStr += "},";
			}
		menuStr = menuStr.substring(0, menuStr.lastIndexOf(","));
		menuStr += "]}";
		var menuJson = JSON.parse(menuStr); 
		return menuJson;
   	}
   	
	/**
	 * 右键单元格属性设置
	 */
	function openStyleWin(){
	    var sheet = getCurrentSheet();
	    var sel = sheet.getSelections();
	    var bxsize = 1;
	    if(sel.length >1)
	    	bxsize = 2;
	    else if(sel.length == 1){
	    	if(sel[0].rowCount > 1 || sel[0].colCount > 1)
	    		bxsize = 2;
	    }
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "/workflow/exceldesign/excelSFContainer.jsp?bxsize="+bxsize+"&isEditMoreContent="+isEditMoreContent;
		dialog.Title = "设置单元格格式";
		dialog.Width = 500;
		dialog.Height = 460;
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
      	numbricalBx(numberJson);
	}
	function numbricalBx(numberJson){
       	var excelData = getCurrentDataObj();
       	var sheet = getCurrentSheet();
       	if(!excelData || !excelData.ecs)
			return;

		var n_set = numberJson.n_set;
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
       		if(_n_decimals>0){
        		decstr = ".";
        		var i = 0;
        		while(i < _n_decimals){
        			decstr +="0";
        			i++;
        		}
       		}
       		if(n_us === "1")
       			formatStr = "#,##0"+decstr;
       		else
       			formatStr = "0"+decstr;
       	}else if(n_set === "3" || n_set === "4" || n_set === "8"){
       		n_target = numberJson.n_target;
       	}else if(n_set === "5" || n_set === "6"){
       		n_decimals = numberJson.n_decimals;
       	}
		try {
			var selections = sheet.getSelections();
			for (var index = 0; index < selections.length; index++) {
				var range = getActualCellRange(selections[index], sheet.getRowCount(), sheet.getColumnCount());
               	for (var i = 0; i < range.rowCount; i++) {
                  	for (var j = 0; j < range.colCount; j++) {
						var r = range.row + i;
                   	 	var c = range.col + j;
                   	 	if(excelData.ecs[r+","+c]){
                   	 		if(n_set === "1" || n_set === "7"){		//常规/文本
                   	 			delete excelData.ecs[r+","+c].enumbric;
                   	 		}else{
                   	 			var cell = {};
		                       	var _enumbric = {};
		                       	_enumbric.n_set = n_set;
		                       	_enumbric.n_decimals = n_decimals;
		                       	_enumbric.n_us = n_us;
		                       	_enumbric.n_target = n_target;
		                       	cell.enumbric = _enumbric;
		                       	setCellProperties(r+","+c,"",cell);
		                       	//设计器面板格式化
		                       	//sheet.getCell(r, c,$.wijmo.wijspread.SheetArea.viewport).formatter(new $.wijmo.wijspread.GeneralFormatter(formatStr));
                   	 		}
                   	 	}
                   	}
               	}
           	}
       	} catch (ex) {
           	window.top.Dialog.alert(ex.message);
		}
	}
	//根据单元格属性页的 对齐tab页 设置单元格自定义属性
	function setPro4AlignTab(alignJson){
	  	if(!alignJson)
	  		return;
    	if(alignJson.a_mergen == "1")
    		splitBx();
    	else if(alignJson.a_mergen == "2")
    		mergenBx();
	  	alignBx(alignJson);
	  	/*var a_wrap = alignJson.a_autowrap;
	  	autowrapBx(a_wrap);*/
	}
	//根据单元格属性页的 字体tab页 设置单元格自定义属性
    function setPro4FontTab(fontJson){
    	if(!fontJson)
    		return;
    	var f_size = "9pt";
    	var f_color = "#000";
    	var f_family = "Microsoft YaHei";
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
    		
    	var f_style = fontJson.f_style;
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
        var sheet = getCurrentSheet();
        try {
            var sels = sheet.getSelections();
            for(var index=0; index<sels.length; index++) {
                var sel = getActualCellRange(sels[index], sheet.getRowCount(), sheet.getColumnCount());
                sheet.isPaintSuspended(true);
                for (var i = 0; i < sel.rowCount; i++) {
                    for (var j = 0; j < sel.colCount; j++) {
                    	var r = sel.row + i;
                   		var c = sel.col + j;
                        var _style = sheet.getStyle(i + sel.row, j + sel.col, $.wijmo.wijspread.SheetArea.viewport);
                        if (_style == undefined)
                            _style = new $.wijmo.wijspread.Style();
                        if (f_color)
                            _style.foreColor = f_color;
                        if (f_family && f_size)
                        	_style.font = (f_italic?"italic ":"")+(f_bold?"bold ":"")+f_size+" "+f_family;
                        
                        sheet.setStyle(i + sel.row, j + sel.col, _style, $.wijmo.wijspread.SheetArea.viewport);
                        sheet.getCell(r, c,$.wijmo.wijspread.SheetArea.viewport).textDecoration(textDecoration);
	                   	setCellProperties(r+","+c, "");
                    }
                }
                sheet.isPaintSuspended(false);
			}
		}catch (ex) {
           	window.top.Dialog.alert(ex.message);
		}
    }
    //根据单元格属性页的 字体tab页 设置单元格边框
    function setPro4BorderTab(borderJson){
    	if(!borderJson)
    		return;
       	var sheet = getCurrentSheet();
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
				if(!!borderJson.b_top || !!borderJson.b_bottom || !!borderJson.b_left || !!borderJson.b_right || !!borderJson.b_horize || !!borderJson.b_vertic){
					setAreaHaveProperties(sel);
				}
	     	}
	     	sheet.isPaintSuspended(false);
		}catch (ex) {
            window.top.Dialog.alert(ex.message);
        }
    }
    //根据单元格属性页的 填充tab页 设置背景色
    function setPro4BgfillTab(bgfillJson){
    	if(!bgfillJson)
    		return;
    	setMjiStyle(null,"bgcolor",bgfillJson.backgroundcolor);
    }
   	
    /**
   	 * 设置行高列宽
   	 */
   	function setRChw(rc){
       	var sheet = getCurrentSheet();
       	var selections = sheet.getSelections();
       	var sel;
       	if(selections.length > 0)
            sel = getActualCellRange(selections[0], sheet.getRowCount(), sheet.getColumnCount());
        var defaultvar = 0;
        var iscolpercent = false;
        if(rc === "r"){
        	for(var i=0;i < sel.rowCount; i++){
        		if(i==0)defaultvar = sheet.getRowHeight(sel.row+i,$.wijmo.wijspread.SheetArea.viewport);
        		else{
        			if(sheet.getRowHeight(sel.row+i,$.wijmo.wijspread.SheetArea.viewport) != defaultvar){
        				defaultvar = -1;
        				break;
        			}
        		}
        	}
        }else if(rc === "c"){
        	for(var i=0;i < sel.colCount; i++){
        		var colheadtxt = sheet.getValue(0,sel.col+i,$.wijmo.wijspread.SheetArea.colHeader);
        		if(colheadtxt.indexOf("%") >0){
        			iscolpercent = true;
        			break;
       			}
        	}
    		for(var i=0;i < sel.colCount; i++){
    			if(iscolpercent){
	        		var colheadtxt = sheet.getValue(0,sel.col+i,$.wijmo.wijspread.SheetArea.colHeader);
	        		if(colheadtxt.indexOf("%") < 0){
	        			defaultvar = -1;
	        			break;
        			}
        			colheadtxt = colheadtxt.split(" ")[1];
        			colheadtxt = jQuery.trim(colheadtxt.substring(1,colheadtxt.lastIndexOf(")"))).replace("%","");
	        		if(i==0) 
	        			defaultvar = colheadtxt;
	        		else {
	        			if(defaultvar != colheadtxt){
	        				defaultvar = -1;
	        				break;
	        			}
	        		}
    			}else{
        			if(i==0)
	        			defaultvar = sheet.getColumnWidth(sel.col+i,$.wijmo.wijspread.SheetArea.viewport);
	        		else{
	        			if(sheet.getColumnWidth(sel.col+i,$.wijmo.wijspread.SheetArea.viewport) != defaultvar){	
	        				defaultvar = -1;
	        				break;
	        			}
	        		}
    			}
        	}
        }
   		var dialog = new window.top.Dialog();
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
	           	for(var index = 0; index<selections.length; index++){
	            	var sel = selections[index];
	            	if(rc === "r"){
		            	for(var x=0; x<sel.rowCount; x++){
		            		sheet.setRowHeight(sel.row+x,djson.value,$.wijmo.wijspread.SheetArea.viewport);
		            	}
	            	}else{
		            	for(var y=0; y<sel.colCount; y++){
		            		var colheadtxt = sheet.getValue(0,sel.col+y,$.wijmo.wijspread.SheetArea.colHeader);
	            			if(colheadtxt.indexOf("%") >0)
	            				colheadtxt = colheadtxt.split(" ")[0];
		            		if(djson.type === "1"){		//像素
			            		sheet.setColumnWidth(sel.col+y,djson.value,$.wijmo.wijspread.SheetArea.viewport);
		            			sheet.setValue(0, sel.col+y, colheadtxt, $.wijmo.wijspread.SheetArea.colHeader);
		            		}else{
		            			sheet.setValue(0, sel.col+y, colheadtxt+" ("+djson.value+"%)", $.wijmo.wijspread.SheetArea.colHeader);
		            		}
	            		}
	       			}
	           	}
	           	sheet.isPaintSuspended(false);
           	}catch (ex) {
	            window.top.Dialog.alert(ex.message);
	        }
		}
   	}
   	    
    /**
     * 剪切
     */
   	function doCCP(action){
       	var sheet = getCurrentSheet();
       	sheet.isPaintSuspended(true);
       	if(action === "cut")
       		$.wijmo.wijspread.SpreadActions.cut.call(sheet);
       	else if(action === "copy")
       		$.wijmo.wijspread.SpreadActions.copy.call(sheet);
       	else if(action === "paste")
       		$.wijmo.wijspread.SpreadActions.paste.call(sheet);
       	sheet.isPaintSuspended(false);
   	}
   	
   	/**
   	 * 最后行/列内容修改，自动扩充
   	 */
   	function autoExtendRowCol(sheet, row, col){
   		if(row === sheet.getRowCount()-1)
			insertRowandCol4Last("row");
		if(col === sheet.getColumnCount()-1)
			insertRowandCol4Last("col");
   	}
   	
   	/**
   	 * 插入3行/2列
   	 */
   	function insertRowandCol4Last(isrc){
		var sheet = getCurrentSheet();
		if(isEditMoreContent){
			if(isrc === "row"){
				sheet.addRows(sheet.getRowCount(), 1);
				mcOperate.setCellToBrFace(sheet.getRowCount()-1);
			}
		}else{
			if(isrc === "row")
	        	sheet.addRows(sheet.getRowCount(), 3);
			else if(isrc === "col")
	        	sheet.addColumns(sheet.getColumnCount(), 2);
		}
   	}
   	
   	/**
   	 * 插入行、插入列
   	 */
   	function insertRowCols(flag){
		var sheet = getCurrentSheet();
        var sel = sheet.getSelections();
        if (sel.length > 0) {
            sel = getActualCellRange(sel[sel.length - 1], sheet.getRowCount(), sheet.getColumnCount());
        }
        if(flag=="row"){
	        if(sel.rowCount==0)sel.rowCount=1;
	        sheet.addRows(sheet.getActiveRowIndex(), sel.rowCount);
	        offsetChangeRowCol("row","insert",sheet.getActiveRowIndex(),sel.rowCount);
	        //多内容面板第二列自动置为换行标记
	        if(isEditMoreContent){
	        	for(var r=0; r<sel.rowCount; r++){
					mcOperate.setCellToBrFace(sel.row+r);
				}
	        }
        }else if(flag=="col"){
	        if(sel.colCount==0)sel.colCount=1;
	        sheet.addColumns(sheet.getActiveColumnIndex(), sel.colCount);
	        offsetChangeRowCol("col","insert",sheet.getActiveColumnIndex(),sel.colCount);
        }
   	}
   	
   	/**
   	 * 删除行、删除列接口
   	 */
   	function deleteRowCols(flag){
   		if(judgeRangeHasArea("clean")){
   			window.top.Dialog.confirm(_excel_reminder_3, function(){
   				deleteRowColsFun(flag);
   			});
   		}else{
   			deleteRowColsFun(flag);
   		}
   	}
   	
   	/**
   	 * 删除行、删除列实现
   	 */
   	function deleteRowColsFun(flag){
   		var sheet = getCurrentSheet();
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
	        	offsetChangeRowCol("row","delete",sel.row,sel.rowCount);
        	}else if(flag=="col"){
        		sheet.deleteColumns(sel.col, sel.colCount);
	        	offsetChangeRowCol("col","delete",sel.col,sel.colCount);
        	}
        }
   	}
   	
   	//冒泡排序
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
	
	/**
	 * 插入/删除行列 导致的自定义属性位移
	 */
   	function offsetChangeRowCol(rc,opreation,activenum,movenum){
	    var dataobj = getCurrentDataObj();
        var toArr = new Array();
        var deleteFormulaArr = new Array();
        for(var item in dataobj.ecs){
            var newid;
            var itemrow = parseInt(item.split(",")[0]);
            var itemcol = parseInt(item.split(",")[1]);
            if(rc == "row"){
                if(opreation == "insert"){
                    if(itemrow >= activenum){
                        var extendobj = {};
                        newid = (itemrow + movenum) + "," + itemcol;
                        $.extend(true, extendobj, dataobj.ecs[item]);
                        extendobj.id = newid;
                        delete dataobj.ecs[item];
                        toArr.push(extendobj);
                    }
                }else if(opreation == "delete"){
                    if(itemrow >= activenum && itemrow <= (activenum + movenum - 1)){
                    	restoreCellProperties("", item);
                        delete dataobj.ecs[item];
                        deleteFormulaArr.push(itemrow+","+itemcol);
                    }else if(itemrow > (activenum + movenum - 1)){
                        var extendobj = {};
                        newid = (itemrow - movenum) + "," + itemcol;
                        $.extend(true, extendobj, dataobj.ecs[item]);
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
                        $.extend(true, extendobj, dataobj.ecs[item]);
                        extendobj.id = newid;
                        delete dataobj.ecs[item];
                        toArr.push(extendobj);
                    }
                }else if(opreation == "delete"){
                    if(itemcol >= activenum && itemcol <= (activenum + movenum - 1)){
                    	restoreCellProperties("", item);
                        delete dataobj.ecs[item];
                        deleteFormulaArr.push(itemrow+","+itemcol);
                    }else if(itemcol > (activenum + movenum - 1)){
                        var extendobj = {};
                        newid = itemrow + "," + (itemcol - movenum);
                        $.extend(true, extendobj, dataobj.ecs[item]);
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
        if(rc == "col"){
        	//当列宽设置为%时，删除列、新增列会导致列号混乱
        	var sheet = getCurrentSheet();
        	var colCount = sheet.getColumnCount();
        	for(var col=0; col<colCount; col++){
        		var colname = formulaOperate.moreIntToCharFace(col);
        		var colheader = sheet.getValue(0, col, $.wijmo.wijspread.SheetArea.colHeader);
				if(colheader.indexOf("%") > -1){
					if(colheader.indexOf(" (") > -1)
						colname += colheader.substring(colheader.indexOf(" ("));
				}
				sheet.setValue(0, col, colname, $.wijmo.wijspread.SheetArea.colHeader);
        	}
        }
        try{
        	//删除公式
        	for(var i=0; i<deleteFormulaArr.length; i++){
        		formulaOperate.deleteCellFormulaFace(deleteFormulaArr[i]);
        	}
        	//公式位移
        	formulaOperate.formulaOffset_changeRCFace(rc,opreation,activenum,movenum);
        }catch(e){}
        try{
        	//行、列自定义属性位移
        	offsetAttrs_changeRC(rc,opreation,activenum,movenum);
        }catch(e){}
	}
	
	/**
	 * 插入/删除行列多行/列自定义属性进行相应位移
	 */
	function offsetAttrs_changeRC(rc,opreation,activenum,movenum){
		var dataobj = getCurrentDataObj();
		if(rc == "row" && !jQuery.isEmptyObject(dataobj.rowattrs)){
			var rowattrs = dataobj.rowattrs;
			var setJson = {};
			for(var __key in rowattrs){
				var curRow = parseInt(__key.replace("row_", ""));
				if(curRow < activenum)
					continue;
				var extendobj = {};
				jQuery.extend(true, extendobj, rowattrs[__key]);
				if(opreation == "insert"){
					setJson[""+(curRow+movenum)] = extendobj;
				}else if(opreation == "delete"){
					if(curRow > (activenum+movenum-1))
						setJson[""+(curRow-movenum)] = extendobj;
				}
		        delete rowattrs[__key];
			}
			//将位移后属性添加到行属性中
			for(var __row in setJson){
				rowattrs["row_"+__row] = setJson[__row];
			}
		}else if(rc == "col" && isDetail === "on" && !jQuery.isEmptyObject(dataobj.colattrs)){
			var colattrs = dataobj.colattrs;
			var setJson = {};
			for(var __key in colattrs){
				var curCol = parseInt(__key.replace("col_", ""));
				if(curCol < activenum)
					continue;
				var extendobj = {};
				jQuery.extend(true, extendobj, colattrs[__key]);
				if(opreation == "insert"){
					setJson[""+(curCol+movenum)] = extendobj;
				}else if(opreation == "delete"){
					if(curCol > (activenum+movenum-1))
						setJson[""+(curCol-movenum)] = extendobj;
				}
		        delete colattrs[__key];
			}
			//将位移后属性添加到列属性中
			for(var __col in setJson){
				colattrs["col_"+__col] = setJson[__col];
			}
		}
	}
	
	/**
	 * 多字段面板，上移下移
	 */
	function cellMoveUpDown(target){
		var sheet = getCurrentSheet();
        var selections = sheet.getSelections();
        if(selections.length != 1)		//只能单选区域移动
        	return;
        var sel = getActualCellRange(selections[0], sheet.getRowCount(), sheet.getColumnCount());
        var dataobj = getCurrentDataObj();
        if(dataobj && dataobj.ecs){
	        var ecs = dataobj.ecs;
	        var operArr = new Array();
			//先将被覆盖单元格存储起来
	        var hoverCell = {};
	        hoverCell.col = "0";
	        if(target === "up"){
	    		hoverCell.row = sel.row-1;
	    		hoverCell.newrow = hoverCell.row+sel.rowCount;
	        }else if(target === "down"){
	        	hoverCell.row = sel.row+sel.rowCount;
        		hoverCell.newrow = hoverCell.row-sel.rowCount;
	        }
	        hoverCell.text = sheet.getCell(hoverCell.row, hoverCell.col, $.wijmo.wijspread.SheetArea.viewport).text();
	        hoverCell.style = sheet.getStyle(hoverCell.row, hoverCell.col, $.wijmo.wijspread.SheetArea.viewport);
	        if(ecs[hoverCell.row+","+hoverCell.col]){
	        	var hoverEc = {};
	        	jQuery.extend(true, hoverEc, ecs[hoverCell.row+","+hoverCell.col]);
	        	hoverCell.ec = hoverEc;
	        	delete ecs[hoverCell.row+","+hoverCell.col];
	        }
	        operArr.push(hoverCell);
	        //将移动单元格存储起来
	        for(var i=0; i<sel.rowCount; i++){
	        	var moveCell = {};
	        	moveCell.row = sel.row+i;
	        	moveCell.col = "0";
	        	if(target === "up")
	        		moveCell.newrow = moveCell.row-1;
	        	else if(target === "down")
	        		moveCell.newrow = moveCell.row+1;
	        	moveCell.text = sheet.getCell(moveCell.row, moveCell.col, $.wijmo.wijspread.SheetArea.viewport).text();
	        	moveCell.style = sheet.getStyle(moveCell.row, moveCell.col, $.wijmo.wijspread.SheetArea.viewport);
	        	if(ecs[moveCell.row+","+moveCell.col]){
	        		var moveEc = {};
	        		jQuery.extend(true, moveEc, ecs[moveCell.row+","+moveCell.col]);
	        		moveCell.ec = moveEc;
	        		delete ecs[moveCell.row+","+moveCell.col];
	        	}
	        	operArr.push(moveCell);
	        }
	        //操作数组处理
	        for(var i=0; i<operArr.length; i++){
	        	var operObj = operArr[i];
	        	sheet.getCell(operObj.newrow, operObj.col, $.wijmo.wijspread.SheetArea.viewport).value(operObj.text);
	        	sheet.setStyle(operObj.newrow, operObj.col, operObj.style, $.wijmo.wijspread.SheetArea.viewport);
	        	if(operObj.ec){
	        		var operObj_ec = operObj.ec;
	        		operObj_ec.id = operObj.newrow+","+operObj.col;
	        		dataobj.ecs[operObj_ec.id] = operObj_ec;
	        	}
	        }
        }
	}
	
	/**
	 * 点击单元格---改变相关样式选中状态、相关操作权限
	 */
	function spreadCellClick(){
		try{		//恢复模板时可能无选中单元格，需try...catch
			var cellid = getSelectedCellid();
			var row = cellid.row;
			var col = cellid.col;
			var cellstyle = buildCellStyle(row, col);
		    setHeadOperatPanelByCellStyle(cellstyle);
			//控制字段属性栏、插入栏;右下角显示相应说明信息
		    controlOperLimits(row, col);
		}catch(e){}
	}
	
	/**
	 * 拼接单元格样式信息
	 */
	function buildCellStyle(row, col){
		var retstyle = {};
		var sheet = getCurrentSheet();
	    var _style = sheet.getStyle(row, col, $.wijmo.wijspread.SheetArea.viewport);
	   	var fontsize = "9pt";
	   	var fontfamliy = "Microsoft YaHei";
	   	var hAlign = 0;
	   	var vAlign = 0;
	    if(!!_style){    	
	    	if(!!_style.hAlign)
	    		hAlign = _style.hAlign;
	    	if(!!_style.vAlign)
	    		vAlign = _style.vAlign;
	    	if(!!_style.foreColor)
	    		retstyle.fontcolor = _style.foreColor;
	    	if(!!_style.backColor)
	    		retstyle.bgcolor = _style.backColor;
			if(!!_style.textDecoration){
	    		if(_style.textDecoration === 1)
	    			retstyle.isunderline = true;
	   			else if(_style.textDecoration === 2)
	   				retstyle.isdeleteline = true;
	   			else if(_style.textDecoration === 3){
	   				retstyle.isunderline = true;
	   				retstyle.isdeleteline = true;
	   			}
			}
	   		var cellfont = _style.font;
	    	if(!!cellfont){
	    		if(cellfont.indexOf("bold") > -1)
	    			retstyle.isbold = true;
	    		if(cellfont.indexOf("italic") > -1)
	    			retstyle.isitalic = true;
	    		if(cellfont.indexOf("pt") > -1)
					fontsize = cellfont.match(/\d+pt/g);
				else if(cellfont.indexOf("px") > -1)
					fontsize = cellfont.match(/\d+px/g);
				fontfamliy = getCellFontFamily(cellfont);
	    	}
	    }
	    retstyle.fontsize = fontsize;
	    retstyle.fontfamliy = fontfamliy;
	    retstyle.halign = hAlign;
	    retstyle.valign = vAlign;
	    return retstyle;
	}
	
	//反向设置样式操作栏
	function setHeadOperatPanelByCellStyle(cellstyle){
		var formatPanel = jQuery(".excelHeadContent").find(".s_format");
		//字体设置
		if(cellstyle.isbold) 
			formatPanel.find("div[name=blodfont]").addClass("shortBtnHover").attr("down","on");
		else 
			formatPanel.find("div[name=blodfont]").removeClass("shortBtnHover").removeAttr("down");
		if(cellstyle.isitalic)
			formatPanel.find("div[name=italicfont]").addClass("shortBtnHover").attr("down","on");
		else 
			formatPanel.find("div[name=italicfont]").removeClass("shortBtnHover").removeAttr("down");
		formatPanel.find("select").selectbox("detach");
		formatPanel.find("#fontsize").val(cellstyle.fontsize);
		formatPanel.find("#fontfamily").val(cellstyle.fontfamliy);
		formatPanel.find("select").selectbox("attach");
		var fontfamily_sb = formatPanel.find("#fontfamily").attr("sb");
		formatPanel.find("#sbHolderSpan_"+fontfamily_sb).css("width","100%");
		var fontsize_sb = formatPanel.find("#fontsize").attr("sb");
		formatPanel.find("#sbHolderSpan_"+fontsize_sb).css("width","100%");
		//垂直对齐
		formatPanel.find("div[name=topAlign],div[name=middelAlign],div[name=bottomAlign]").removeClass("shortBtnHover").removeAttr("down");
		if(cellstyle.valign == 0)
			formatPanel.find("div[name=topAlign]").addClass("shortBtnHover").attr("down","on");
		else if(cellstyle.valign == 1)
			formatPanel.find("div[name=middelAlign]").addClass("shortBtnHover").attr("down","on");
		else if(cellstyle.valign == 2)
			formatPanel.find("div[name=bottomAlign]").addClass("shortBtnHover").attr("down","on");
		//水平对齐
		formatPanel.find("div[name=leftAlign],div[name=centerAlign],div[name=rightAlign]").removeClass("shortBtnHover").removeAttr("down");
		if(cellstyle.halign == 0)
			formatPanel.find("div[name=leftAlign]").addClass("shortBtnHover").attr("down","on");
		else if(cellstyle.halign == 1)
			formatPanel.find("div[name=centerAlign]").addClass("shortBtnHover").attr("down","on");
		else if(cellstyle.halign == 2)
			formatPanel.find("div[name=rightAlign]").addClass("shortBtnHover").attr("down","on");
	}
	
	/**
	 * 点击单元格---反向控制字段属性栏;右下角显示相应说明信息
	 */
	function controlOperLimits(row, col){
		var dataobj = getCurrentDataObj();
	    var fieldPanel = jQuery(".excelHeadContent").find(".s_filed");
	    var insertPanel = jQuery(".excelHeadContent").find(".s_insert");
	    
		fieldPanel.find("[name=justread],[name=canwrite],[name=required]")
			.removeClass("shortBtn").removeClass("shortBtnHover").addClass("shortBtn_disabled");
		fieldPanel.find("[name=fieldpro],[name=morepro]")
			.removeClass("shortBtn").addClass("shortBtn_disabled");
		var isSingle = isChooseSingleCell();
		if(wfinfo.layouttype == "0" && wfinfo.isactive == "1" && wfinfo.nodetype != "3"){	//非归档节点显示模板
			var _menu_rem = getFieldREM();
			var isfield = (_menu_rem.split(",")[0]==="true")?true:false;
			var istitlefield = (_menu_rem.split(",")[1]==="true")?true:false;
			var isspecial = (_menu_rem.split(",")[2]==="true")?true:false;
			var ispostion =  (_menu_rem.split(",")[3]==="true")?true:false;
			if(isfield || istitlefield || isspecial){
				fieldPanel.find("[name=justread]").removeClass("shortBtn_disabled").addClass("shortBtn");
				if(!isDetail || (isDetail==="on" && ($("#dtladd").is(":checked") || $("#dtledit").is(":checked")))){
					if(isfield)
						fieldPanel.find("[name=canwrite]").removeClass("shortBtn_disabled").addClass("shortBtn");
					if((isfield &&!ispostion) || istitlefield)
						fieldPanel.find("[name=required]").removeClass("shortBtn_disabled").addClass("shortBtn");
				}
			}
			if(isSingle){
				if(dataobj.ecs[row+","+col] && dataobj.ecs[row+","+col].etype === celltype.FCONTENT){
					setFieldAttrHover(dataobj.ecs[row+","+col].efieldid);
					fieldPanel.find("[name=fieldpro]").removeClass("shortBtn_disabled").addClass("shortBtn");
					fieldPanel.find("[name=morepro]").removeClass("shortBtn_disabled").addClass("shortBtn");
				}
			}
		}
		var insertObj = insertPanel.find("[name='linktext'],[name='formula'],[name='tabpage'],[name='morecontent'],[name='portalelm'],[name='iframearea'],[name='scancode']");
		if(isSingle){
			insertObj.removeClass("shortBtn_disabled").addClass("shortBtn");
			if(dataobj.ecs[row+","+col]){
				var etype = dataobj.ecs[row+","+col].etype;
				if(etype === celltype.DETAIL || etype === celltype.TAB || etype === celltype.MC 
					|| etype === celltype.PORTAL || etype === celltype.IFRAME || etype === celltype.SCANCODE)
					insertObj.removeClass("shortBtn").addClass("shortBtn_disabled");
			}
		}else{
			insertObj.removeClass("shortBtn").addClass("shortBtn_disabled");
		}
        controlDiscriptionArea();
	}
	
	/**
	 * 选中单一单元格时，右下角显示相应说明信息
	 */
	function controlDiscriptionArea(){
		if(isDetail === "on")
			return;
		var totalDiscription = "";
		var isSingle = isChooseSingleCell();
        if(isSingle){
			var sheet = getCurrentSheet();
			var dataobj = getCurrentDataObj();
			var r = sheet.getActiveRowIndex();
			var c = sheet.getActiveColumnIndex();
			var cellid = r+","+c;
	    	if(dataobj && dataobj.ecs && dataobj.ecs[cellid]){
	    		var etype = dataobj.ecs[cellid].etype;
	    		var attrs = dataobj.ecs[cellid].attrs;
	    		var attrHtml = "", fieldHtml = "", cellTextHtml = "", declareHtml = "";
	    		
	    		if(!jQuery.isEmptyObject(attrs)){
	    			for(var key in attrs){
	    				if(key === "hide"){
	    					if(attrs[key] === "y")
	    						attrHtml += "<span>隐藏内容 : 是</span></br>";
	    				}else{
	    					attrHtml += "<span>"+key+" : "+attrs[key]+"</span></br>";
	    				}
	    			}
	    		}
	    		if(etype === celltype.FCONTENT){
	    			fieldHtml += "<span>ID : field"+dataobj.ecs[cellid].efieldid+"</span></br>";
	    		}
	    		if(etype === celltype.MC || etype === celltype.PORTAL){
	    			cellTextHtml = sheet.getCell(r, c, $.wijmo.wijspread.SheetArea.viewport).text();
	    		}
	    		if(etype === celltype.DETAIL)
	    			declareHtml += "明细表区域，";
	    		else if(etype === celltype.TAB)
	    			declareHtml += "标签页区域，";
	    		else if(etype === celltype.MC)
	    			declareHtml += "多内容区域，";
	    		if(etype === celltype.DETAIL || etype === celltype.TAB ||etype === celltype.MC){
	    			declareHtml += _excel_reminder_5;
	    		}
	    		//拼装右下角显示信息
	    		if(attrHtml !== ""){
	    			totalDiscription += "<span class=\"disAreaHead\">单元格属性</span></br>";
	    			totalDiscription += attrHtml+"</br>";
	    		}
	    		if(fieldHtml !== ""){
	    			totalDiscription += "<span class=\"disAreaHead\">字段信息</span></br>";
	    			totalDiscription += fieldHtml+"</br>";
	    		}
	    		if(cellTextHtml !== ""){
	    			totalDiscription += "<span class=\"disAreaHead\">单元格内容</span></br>";
	    			totalDiscription += "<span>"+cellTextHtml+"</span></br></br>";
	    		}
	    		if(declareHtml !== ""){
	    			totalDiscription += "<span class=\"disAreaHead\">说明</span></br>";
	    			totalDiscription += "<span>"+declareHtml+"</span></br>";
	    		}
	    	}
        }
        //显示说明信息
        var obj = $("div[name=somethingdiv]").find("tr.groupHeadHide").find(".hideBlockDiv");
        if(totalDiscription === ""){
	    	jQuery(".discriptionArea").html("");
	    	if(obj.attr("_status") === "0"){
	    		obj.click();
	    	}
        }else{
        	jQuery(".discriptionArea").html(totalDiscription);
        	if(obj.attr("_status") === "1"){
        		obj.click();
        	}
        }
	}
	
	/**
	 * 字段属性选中
	 */
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

	/**
	 * 字段属性权限判断
	 */
	function getFieldREM(){
		var dataobj = getCurrentDataObj();
	   	var sheet = getCurrentSheet();
	   	var sels = sheet.getSelections();
	   	var isfield = false; 
		var istitlefield = false;
		var isspecial = false;
		var isposition =false;
	
	   	for (var n = 0; n < sels.length; n++) {
			var sel = getActualCellRange(sels[n], sheet.getRowCount(), sheet.getColumnCount());
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
							var _fieldtype = $("a[_flag="+celltype.FCONTENT+"][_fieldid="+dataobj.ecs[ar+","+ac].efieldid+"]").children("[name=fieldtype]").val();
							if(_fieldtype==="7"){
								isspecial = true;
						    }else if(_fieldtype==="9"){
								  isfield = true;
								 isposition =true;
							}else{
								isfield = true;
							}
						}
					}
				}
			}
		}
		return isfield+","+istitlefield+","+isspecial+","+isposition;
	}
	
	
   	
	return {
		
		//==========页面初始化相关JS======
		//绑定按钮操作事件
		bindOperateBtnEventFace: function(operatpanel,excelDiv){
			bindOperateBtnEvent(operatpanel,excelDiv);
		},
		//初始化面板右键菜单
		initPanelRightMenuFace: function(){
			initPanelRightMenu();
		},
		//初始化样式列表
    	initStyleTabFace:function (){
    		initStyleTab();
    	},
        
        //=========excelRightClickOperat_wev8.js相关接口  begin=========
        //获取当前操作的sheet中的活动单元格的扩展属性
        getActiveCellDataObj:function(){
            var sheet = getCurrentSheet();
            var r = sheet.getActiveRowIndex();
            var c = sheet.getActiveColumnIndex();
            var dataObj = getCurrentDataObj();
            if(dataObj && dataObj.ecs && dataObj.ecs[r+","+c])
            	return dataObj.ecs[r+","+c];
            else
            	return null;
        },
        //获取当前活动单元格样式
        getActiveCellStyle:function(){
        	var sheet = getCurrentSheet();
            return buildCellStyle(sheet.getActiveRowIndex(), sheet.getActiveColumnIndex())
        },
        //获取活动单元格的边框样式
        getActiveCellBorder:function(){
            var sheet = getCurrentSheet();
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
        getAllCellBorder:function(){
            var sheet = getCurrentSheet();
            var sels = sheet.getSelections();
            var range = getActualCellRange(sels[0], sheet.getRowCount(), sheet.getColumnCount());
            if(range.rowCount > 1 || range.colCount > 1){
            	return {
            		left:sheet.getStyle(range.row, range.col, $.wijmo.wijspread.SheetArea.viewport).borderLeft,
            		right:sheet.getStyle(range.row+range.rowCount-1, range.col, $.wijmo.wijspread.SheetArea.viewport).borderRight,
            		top:sheet.getStyle(range.row, range.col, $.wijmo.wijspread.SheetArea.viewport).borderTop,
            		bottom:sheet.getStyle(range.row, range.col+range.colCount-1, $.wijmo.wijspread.SheetArea.viewport).borderBottom
            	};
            }else{
            	var fbx_style = {};
            	fbx_style = sheet.getStyle(range.row, range.col, $.wijmo.wijspread.SheetArea.viewport);
            	return {left:fbx_style.borderLeft,top:fbx_style.borderTop,right:fbx_style.borderRight,bottom:fbx_style.borderBottom};
            }
        },
        //=========excelRightClickOperat_wev8.js相关接口   end=========
        
        //=========excelUploadFormula.js公式相关接口	  begin=======
        changeTable4OpFace:function(panelsymbol, currentTableSheetJson){
        	var ss = jQuery("#excelDiv").wijspread("spread");
	  		var sheet = ss.getActiveSheet();
	  		var sheetJson;
	   		if(isDetail === "on"){
	   			if(panelsymbol.indexOf("detail_") > -1)
	   				sheetJson = JSON.parse(currentTableSheetJson);
	   			else{		//主表或标签页
	   				sheetJson = parentWin_Main.globalSheet.getCacheValue(panelsymbol+"_sheet");
	   				sheetJson = JSON.parse(sheetJson);
	   			}
	   		}else{
	   			if(panelsymbol === globalData.getCacheValue("symbol")){
	   				sheetJson = JSON.parse(currentTableSheetJson);
	   			}else{
	        		sheetJson = globalSheet.getCacheValue(panelsymbol+"_sheet");
	        		if(!sheetJson){
	        			window.top.Dialog.alert("选择的面板尚未设计!",function(){
	        				$(window.top.Dialog.getBgdiv()).css("z-index",(parseInt($(window.top.Dialog.getBgdiv()).css("z-index")) - 2)+"");
	        			});
	        			return;
	        		}
	        		sheetJson = JSON.parse(sheetJson);
	   			}
	   		}
			try{
	   			sheet.isPaintSuspended(true);
	       		ss.fromJSON(sheetJson);
	       		sheet.isPaintSuspended(false);
	       		sheet.setIsProtected(true);
	       		formulaOperate.bindSpreadEvent4FormulaFace(ss);
	   		}catch(e){
	   			window.top.Dialog.alert(e.message);
	   		}
        },
        getCurrentSheetJsonFace:function(){
			var ss = jQuery("#excelDiv").wijspread("spread");
			var sheetJson = JSON.stringify(ss.toJSON()); 
			return sheetJson;
        },
        setCurrentSheetJsonFace:function(sheetJson, islocked){
        	if(!sheetJson)return;
			var ss = jQuery("#excelDiv").wijspread("spread");
			var sheet = ss.getActiveSheet();
			
			sheet.isPaintSuspended(true);
       		sheetJson = JSON.parse(sheetJson);
       		ss.fromJSON(sheetJson);
       		sheet.isPaintSuspended(false);
       		sheet = ss.getActiveSheet();
       		if(islocked){
       			sheet.setIsProtected(true);
       			formulaOperate.bindSpreadEvent4FormulaFace(ss);
       		}else
       			bindSpreadEvent(ss);
        },
        //=========excelUploadFormula.js相关接口	  end=======
        
        //绑定表格事件
        bindSpreadEventFace: function(spread){
        	bindSpreadEvent(spread);
        },
        //右键点击获取单元格接口
        mouseLocateCellFace: function(e, target){
        	mouseLocateCell(e, target);
        },
        //点击单元格样式选中接口
        spreadCellClickFace: function(){
        	spreadCellClick();
        },
        //控制操作栏权限
        controlOperLimitsFace: function(row, col){
        	controlOperLimits(row, col);
        },
        //控制右下角显示说明
        controlDiscriptionAreaFace: function(){
        	controlDiscriptionArea();
        },
        //选取表格选中框区域接口
        getCellRange: function(cellRange, rowCount, columnCount){
        	return getActualCellRange(cellRange, rowCount, columnCount);
        },
        //判断选中是否为单一单元格
        getIsChooseSingleCell: function(){
			return isChooseSingleCell();
        },
        //判断是否包含标签页或明细表
        judgeRangeHasAreaFace: function(target){
        	return judgeRangeHasArea(target);
        },
        //判断是否包含默认图标
        judgeCellDefaultRetractFace: function(cellobj){
        	return judgeCellDefaultRetract(cellobj);
        },
        //根据单元格样式获取字体
        getCellFontFamilyFace: function(cellfont){
        	return getCellFontFamily(cellfont);
        },
        //自动插入行列接口
        autoExtendRowColFace: function(sheet, row, col){
        	autoExtendRowCol(sheet, row, col);
        },
        //插入行列接口
        insertRowColsFace: function(flag){
        	insertRowCols(flag);
        },
        //删除行列接口
        deleteRowColsFace: function(flag){
        	deleteRowColsFun(flag);
        },
        //插入表头表尾标示行，只插一行
        insertDetailRowMarkFace: function(insertRowIndex){
        	if(insertRowIndex <= 0)	return;
        	var sheet = getCurrentSheet();
        	sheet.addRows(insertRowIndex, 1);
	        offsetChangeRowCol("row", "insert", insertRowIndex, 1);
        },
        //清除背景图接口
        clearBgImgFace: function(excelDiv){
        	clearBgImg(excelDiv);
        },
        //清除单元格内容接口
        cleanCellTextFace: function(sheet, cellobj, r, c){
        	cleanCellText(sheet, cellobj, r, c);
        },
        //获取当前区域自定义属性
        getCurrentAttrsFace: function(){
        	return getCurrentAttrs();
        }
	};
})();