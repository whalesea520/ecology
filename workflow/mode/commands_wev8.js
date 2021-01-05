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
		    	mnuEditUndo_click();
			break;
		case "CMDEDITREDO"://重做
			mnuEditRedo_click();
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
		case "SETCCINCELLS":	
			cmdSetCCInCells_click();
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
		case "CMDDRAWCOLOR":
			CellWeb1.OnSetLineStyle();
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
function cellregedit(){
    MenuOcx.Login("上海泛微网络技术有限公司","4f203da914960b091b0d58b2cff7ec44",0);
    CellWeb1.Login("泛微软件","891e490cd34e3e33975b1b7e523e8b32","上海泛微网络技术有限公司");
}

//获得本机插件版本
function mnuCurrentVer_click(){
    var language=readCookie("languageidweaver");
    try{
        var version=CellWeb1.GetCurrentVersion();
        /*if(language==8){
            alert("Your local host version number is "+version);
        }
        else if(language==9){
            alert("您本機的插件版本為"+version);
        }
        else{
            alert("您本机的插件版本为"+version);
        }
		*/
		alert(SystemEnv.getHtmlNoteName(3461,language)+version);
    }catch(e){
        /*if(language==8){
            alert("Your version is so old that can't support the function,please install new version!");
        }
		else if(language==9){
            alert("您的版本太低不支持該功能，請安裝新版本插件！");
        }        
        else{
            alert("您的版本太低不支持该功能，请安装新版本插件！");
        }*/
		alert(SystemEnv.getHtmlNoteName(3462,language));
    }
}

//获得模版文件版本
function getTabFileVer(){
    try{
    return CellWeb1.GetCurrentFileVersion();
    }catch(e){
        return 0;
    }
}

//获得本机插件版本
function getCurrentVer(){
    try{
    return CellWeb1.GetCurrentVersion();
    }catch(e){
        return 0;
    }
}

//获得系统插件版本
function mnuSystemVer_click(){
    var language=readCookie("languageidweaver");
    try{
    var version=CellVersion.value;
    if(version!=""){
        /*if(language==8){
            alert("Server version is "+version);
        }
        else if(language==9){
            alert("服務器的插件版本為"+version);
        }
        else{
            alert("服务器的插件版本为"+version);
        }*/
		alert(SystemEnv.getHtmlNoteName(3463,language)+version);
    }else{
       /* if(language==8){
            alert("Your version is so old that can't support the function,please install new version!");
        }
        else if(language==9){
            alert("您的版本太低不支持該功能，請安裝新版本插件！");
        }
        else{
            alert("您的版本太低不支持该功能，请安装新版本插件！");
        }*/
		alert(SystemEnv.getHtmlNoteName(3462,language));
    }
    }catch(e){
        /*if(language==8){
            alert("Your version is so old that can't support the function,please install new version!");
        }
        else if(language==9){
            alert("您的版本太低不支持該功能，請安裝新版本插件！");
        }
        else{
            alert("您的版本太低不支持该功能，请安装新版本插件！");
        }*/
		alert(SystemEnv.getHtmlNoteName(3462,language));
    }
}

function showCheckPopup(content){
    var showTableDiv  = document.getElementById('divshowCheck');
    var oIframe = document.createElement('iframe');
    showTableDiv.style.display='';
    var message_Div = document.createElement("<div>");
     message_Div.id="message_Div";
     message_Div.className="xTable_message";
     showTableDiv.appendChild(message_Div);
     var message_Div1  = document.getElementById("message_Div");
     message_Div1.style.display="inline";
     message_Div1.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_Div1.style.position="absolute"
     message_Div1.style.posTop=pTop;
     message_Div1.style.posLeft=pLeft;

     message_Div1.style.zIndex=1002;

     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_Div1.style.zIndex - 1;
     oIframe.style.width = parseInt(message_Div1.offsetWidth);
     oIframe.style.height = parseInt(message_Div1.offsetHeight);
     oIframe.style.display = 'block';
    return oIframe;
}

function hideCheckPopup(oIframe){
    var showTableDiv  = document.getElementById('divshowCheck');
    showTableDiv.style.display='none';
    oIframe.style.display='none';
}

//模板格式检查
function mnuStyleCheck_click(){
    var language=readCookie("languageidweaver");
    var oIframe;
    /*if(language==8){
        oIframe=showCheckPopup("Checking templet format,Please wait...");
    }
    else if(language==9){
        oIframe=showCheckPopup("正在檢查模板格式，請稍等...");
    }
    else{
        oIframe=showCheckPopup("正在检查模板格式，请稍等...");
    }*/
	oIframe=showCheckPopup(SystemEnv.getHtmlNoteName(3464,language));
    var endrow=CellWeb1.GetMaxRow();
    var endcol=CellWeb1.GetMaxCol();
    var hasadd=0;
    var hasdel=0;
    var hassel=0;
    var hashead=0;
    var hasend=0;
    var hasprintbegin=0;
    var hasprintend=0;
    var returnstr="";
    for(var i=0;i<=endrow;i++){
        for(var j=0;j<=endcol;j++){
            var userstring=CellWeb1.GetCellUserStringValue(i,j);
            if(userstring!=null && userstring!=""){
                //检查字段是否更改过
                try{
                    var fieldid=parent.fieldlist.document.getElementById(userstring).id;
                }catch(e){
                    /*if(language==8){
                        returnstr+=i+" line of "+j+" related fields have already been deleted or change ,Please delete!\n";
                    }
                    else if(language==9){
                        returnstr+=i+"行"+j+"列關聯的字段已經被刪除或改變，請用‘X’刪除！\n";
                    }
                    else{
                        returnstr+=i+"行"+j+"列关联的字段已经被删除或改变，请用‘X’删除！\n";
                    }*/
					var msg = SystemEnv.getHtmlNoteName(3465,language);
					if(!msg){
							msg = SystemEnv.getHtmlNoteName(3465,7);
					}
					returnstr += i+msg.replace(/#\{j\}/,j)+"\n";
                }
                if(userstring.indexOf("_add")>0){
                    hasadd+=1;
                }
                if(userstring.indexOf("_del")>0){
                    hasdel+=1;
                }
                if(userstring.indexOf("_head")>0){
                    hashead+=1;
                }
                if(userstring.indexOf("_end")>0){
                    hasend+=1;
                }
                if(userstring.indexOf("_sel")>0){
                    hassel+=1;
                }
                if(userstring.indexOf("_isprintbegin")>0){
                    hasprintbegin+=1;
                }
                if(userstring.indexOf("_isprintend")>0){
                    hasprintend+=1;
                }
            }
        }
    }
    //标签成对检查
    if(hasadd!=hasdel){
        /*if(language==8){
            returnstr+="add,delete butten is not pairs!\n";
        }
        else if(language==9){
            returnstr+="增加、刪除按鈕不成對！\n";
        }
        else{
            returnstr+="增加、删除按钮不成对！\n";
        }*/
		returnstr += SystemEnv.getHtmlNoteName(3466,language)+"\n";
    }
    if(hashead!=hasend){
        /*if(language==8){
            returnstr+="【head label】,【end label】 is not pairs!\n";
        }
        else if(language==9){
            returnstr+="【表頭標識】、【表尾標識】不成對！\n";
        }
        else{
            returnstr+="【表头标识】、【表尾标识】不成对！\n";
        }*/
		returnstr += SystemEnv.getHtmlNoteName(3467,language)+"\n";
    }
    if(hasprintbegin!=hasprintend){
        /*if(language==8){
            returnstr+="【begining of hiding the detail which is null】,【ending of hiding the detail which is null】 is not pairs!\n";
        }
        else if(language==9){
            returnstr+="【空明細隱藏標識頭】、【空明細隱藏標識尾】不成對！\n";
        }	
        else{
            returnstr+="【空明细隐藏标识头】、【空明细隐藏标识尾】不成对！\n";
        }*/
		returnstr += SystemEnv.getHtmlNoteName(3468,language)+"\n";
    }
    if(hasadd>0 || hasdel>0){
        if((hasadd>0 && hasadd!=hashead) || (hasdel>0 && hasdel!=hashead)){
            /*if(language==8){
                returnstr+="Lack【head label】!\n";
            }
            else if(language==9){
                returnstr+="缺少【表頭標識】！\n";
            }
            else{
                returnstr+="缺少【表头标识】！\n";
            }*/
			returnstr += SystemEnv.getHtmlNoteName(3469,language)+"\n";
        }
        if((hasadd>0 && hasadd!=hassel) || (hasdel>0 && hasdel!=hassel)){
            /*if(language==8){
                returnstr+="Lack【SelectCombo label】!\n";
            }
            else if(language==9){
                returnstr+="缺少【選擇框標籤】！\n";
            }
            else{
                returnstr+="缺少【选择框标签】！\n";
            }*/
			returnstr += SystemEnv.getHtmlNoteName(3470,language)+"\n";
        }
        if((hasadd>0 && hasadd!=hasend) || (hasdel>0 && hasdel!=hasend)){
            /*if(language==8){
                returnstr+="Lack【end label】!\n";
            }
            else if(language==9){
                returnstr+="缺少【表尾標識】！\n";
            }
            else{
                returnstr+="缺少【表尾标识】！\n";
            }*/
			returnstr += SystemEnv.getHtmlNoteName(3471,language)+"\n";
        }
    }
    if(returnstr==""){
        /*if(language==8){
            returnstr="No found error format!";
        }
        else if(language==9){
            returnstr="無發現錯誤格式！";
        }
        else{
            returnstr="无发现错误格式！";
        }*/
		returnstr += SystemEnv.getHtmlNoteName(3472,language)+"\n";
    }
	/*
    if(language==8){
        returnstr="Result:\n"+returnstr;
    }
    else if(language==9)
    {
    	returnstr="檢查結果:\n"+returnstr;
    }
    else{
        returnstr="检查结果:\n"+returnstr;
    }*/
	returnstr = SystemEnv.getHtmlNoteName(3473,language)+"\n"+returnstr;
    alert(returnstr);
    hideCheckPopup(oIframe);
    CellWeb1.GetFocus();
}

//帮助
function mnuShowHelp_click(){
    var redirectUrl = "CellHelp.html" ;
    var szFeatures = "directories=no," ;
    szFeatures +="status=yes," ;
    szFeatures +="menubar=no," ;
    szFeatures +="scrollbars=yes," ;
    szFeatures +="resizable=yes" ; //channelmode
    var popWin=window.open(redirectUrl,"CellHelp",szFeatures) ;
    CellWeb1.GetFocus();
    popWin.focus();
}

function showRightMenu(){
    var startrow=CellWeb1.GetSelectRegionStartRow();
    var endrow=CellWeb1.GetSelectRegionEndRow();
    var startcol=CellWeb1.GetSelectRegionStartCol();
    var endcol=CellWeb1.GetSelectRegionEndCol();
    for(var i=startrow;i<=endrow;i++){
        for(var j=startcol;j<=endcol;j++){
            var userstring=CellWeb1.GetCellUserStringValue(i,j);
            if(userstring!=null && userstring!="" && userstring.indexOf("_add")<0 && userstring.indexOf("_del")<0 && userstring.indexOf("_head")<0 && userstring.indexOf("_end")<0 && userstring.indexOf("_sel")<0&& userstring.indexOf("_showKeyword")<0&& userstring.indexOf("_isprintbegin")<0&& userstring.indexOf("_isprintend")<0&& userstring.indexOf("_createCodeAgain")<0){
                showPopup();
                break;
            }
        }
    }
}
