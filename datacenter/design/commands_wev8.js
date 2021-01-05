//Copyright (c) 2000 Microsoft Corporation.  All rights reserved.
//<script>
var g_WinDoc            =   window.document;
var g_WinDocAll         =   g_WinDoc.all;

function f_onCbMouseOut()
{
	event.cancelBubble=true;
	if( null != this.sticky )		// If it is sticky
	{
		if( true == this.buttondown )
		{
			return;
		};
	}
	this.className= (true == this.raised) ? "tbButtonRaise" : "tbButton";
	this.onmouseout=null;
}
function f_onCbMouseUp(obj)
{
	event.cancelBubble=true;
	if( null != this.sticky )
	{
		if( true == this.buttondown )
		{
			return;
		};
	}
	this.className= (true == this.raised) ? "tbButtonRaise" : "tbButton";
	this.onmouseup=null;
}
function onCbMouseDown(obj)
{
	obj.className="tbButtonDown";
	obj.onmouseout = f_onCbMouseOut;
	obj.onmouseup = f_onCbMouseUp;
}

function onCbClickEvent(obj, fNoEvent)
{
	if( null != event )
	{
		event.cancelBubble=true;
	}
	// Regular push button
	onCbClick(obj.id, true);
	return(false);
}

function onCbClick(szCommand, fState)
{
	//开始命令
	switch(szCommand.toUpperCase())
	{
		case "CMDFILENEW"://新建
			mnuFileNew_click();
			break;
		case "CMDFILEOPEN"://打开文件
			mnuFileOpen_click();
			break;
		case "CMDEXCELFILEOPEN"://打开EXCEL文件
			mnuExcelFileOpen_click();
			break;
		case "CMDWEBFILEOPEN"://打开远程文件
			mnuFileWebOpen_click();
			break;
		case "CMDWEBXMLFILEOPEN"://打开远程XML文件
			mnuXMLFileWebOpen_click();
			break;
		case "CMDSAVEDATAASSTRING": //输出为字符串
		    mnuSaveDataAsString_click();
			break;
		case "CMDFILESAVE"://保存文档
			mnuFileSave_click();
			break;
		case "CMDFILESAVEAS"://另存为
			mnuFileSaveAs_click();
			break;
		case "CMDFILEPRINTPAPERSET"://打印页设置文档
			mnuPrintPaperSet_click();
			break;
		case "CMDFILEPRINTSETUP"://打印设置文档
			mnuFilePrintSetup_click();
			break;
		case "CMDFILEPRINT"://打印文档
			mnuFilePrint_click();
			break;
		case "CMDFILEPRINTPREVIEW"://打印预览文档
			mnuFilePrintPreview_click();
			break;
		case "CMDEDITCUT"://剪切
		 	CellWeb1.OnCut();
			//mnuEditCut_click();
			break;
		case "CMDEDITCOPY"://复制
		 	CellWeb1.OnCopy();
			//mnuEditCopy_click();
			break;		
		case "CMDEDITPASTE"://粘贴
		 	CellWeb1.OnPaste();
			//mnuEditPaste_click();
			break;
		case "CMDEDITFIND"://查找
		    	mnuEditFind_click();
			break;
		case "CMDEDITUNDO"://撤消
		    	//mnuEditUndo_click();
			break;
		case "CMDEDITREDO"://重做
			//mnuEditRedo_click();
			break;
		case "CMDSHAPE3D"://设置单元3维显示
		    mnuShape3D_click();
			break;
		case "CMDROWLABEL"://设置行表头
		    mnuRowLabel_click();
			break;
		case "CMDCOLLABEL"://设置列表头
			mnuColLabel_click();
			break;
		case "CMDSTATWIZARD"://
			CellWeb1.OnStatWebWizard();
			break;
		case "CMDSORTDESCENDING"://降序排序
			cmdSortDescending_click();
			break;
		case "CMDFUNCTIONLIST"://函数列表
			mnuFunctionList_click();
			break;
		case "CMDUSERFUNCTIONGUIDE"://自定义函数向导
			mnuUserFunctionGuide_click();
			break;
		case "CMDFORMULASUMH"://水平求和
			cmdFormulaSumH_click();
			break;
		case "CMDFORMULASUMV"://垂直求和
			cmdFormulaSumV_click();
			break;
		case "CMDFORMULASUMHV"://双向求和
			cmdFormulaSumHV_click();
			break;
		case "CMDCHARTWZD"://图表向导
			mnuDataWzdChart_click();
			break;
		case "CMDINSERTPIC"://插入图片
			mnuFormatInsertPic_click();
			break;
		case "CMDINSERTCELLPIC"://插入单元图片
			mnuFormatInsertCellPic_click();
			break;
		case "CMDHYPERLINK"://超级链接
			mnuEditHyperlink_click();
			break;
		case "CMDFINANCEHEADERTYPE"://财务表头
			mnuFinanceHeader_click();
			break;		
		case "CMDFINANCETYPE"://财务表览
			mnuFinance_click();
			break;		
		case "CMDSHOWGRIDLINE"://显示/隐藏背景表格线
			with(CellWeb1){
				ShowGrid =!ShowGrid;
			}
			break;
		case "CMDSHOWHEADER"://显示/隐藏系统表头
			with(CellWeb1){
				ShowHeader = !ShowHeader;
                 	}
            		break;
		//***********************************************************			
		//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
		case "CMDBOLD"://设置粗体
		    	cmdBold_click();
			break;
		case "CMDITALIC"://设置斜体
			cmdItalic_click();
			break;
		case "CMDUNDERLINE"://设置下划线
			cmdUnderline_click();
			break;
		case "CMDBACKCOLOR"://设置背景色
			cmdBackColor_click();
			break;
		case "CMDFORECOLOR"://设置前景色
			cmdForeColor_click();
			break;
		case "CMDWORDWRAP"://设置自动折行
			cmdWordWrap_click();
			break;	
		case "CMDALIGNLEFT"://左对齐
			cmdAlignLeft_click();
			break;
		case "CMDALIGNCENTER"://居中对齐
			cmdAlignCenter_click();
			break;
		case "CMDALIGNRIGHT"://居右对齐
			cmdAlignRight_click();
			break;
		case "CMDALIGNTOP"://居上对齐
			cmdAlignTop_click();
			break;
		case "CMDALIGNMIDDLE"://垂直居中对齐
			cmdAlignMiddle_click();
			break;
		case "CMDALIGNBOTTOM"://居下对齐
			cmdAlignBottom_click();
			break;
		case "CMDDRAWBORDER"://画框线
			cmdDrawBorder_click();
			break;
		case "CMDERASEBORDER"://抹框线
			cmdEraseBorder_click();
			break;
		case "CMDCURRENCY"://货币符号
			cmdCurrency_click();
			break;
		case "CMDPERCENT"://百分号
			cmdPercent_click();
			break;		
		case "CMDTHOUSAND"://千分位
			cmdThousand_click();
			break;
		case "CMDABOUT"://关于超级报表插件
			cmdAbout_click();
			break;
		//***********************************************************			
		//^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
		case "CMDINSERTCOL"://插入列
		    	cmdInsertCol_click();
			break;
		case "CMDINSERTROW"://插入行
		    	cmdInsertRow_click();
			break;
		case "CMDINSERTCELL"://插入单元
			cmdInsertCell_click();
			break;
		case "CMDDELETECELL"://删除单元
		    	cmdDeleteCell_click();
			break;
		case "CMDDELETECOL"://删除列
			cmdDeleteCol_click();
			break;
		case "CMDDELETEROW"://删除行
			cmdDeleteRow_click();
			break;
		case "CMDMAXROWCOL"://设置表格行列数
			mnuMaxRowCol_click();
			break;
		case "CMDMERGECELL"://合并单元格
			mnuFormatMergeCell_click();
			break;
		case "CMDUNMERGECELL"://取消合并单元格
			mnuFormatUnMergeCell_click();
			break;
		case "CMDMERGEROW"://行组合
			cmdMergeRow_click();
			break;
		case "CMDMERGECOL"://列组合
			cmdMergeCol_click();
			break;
		case "CMDRECALCALL"://重算全表
			mnuFormulaReCalc_click();
			break;
		case "CMDFORMPROTECT"://整表保护
			mnuFormProtect_click();
			break;
		case "CMDREADONLY"://单元格只读
			mnuReadOnly_click();
			break;
		
	}
}

