function onNewDoc(fieldid) {
	frmmain.action = "RequestOperation.jsp";
	frmmain.method.value = "docnew_"+fieldid;
	frmmain.isMultiDoc.value = fieldid;
	document.frmmain.src.value = "save";
	//附件上传
	StartUploadAll();
	checkuploadcomplet();
}
function parse_Float(i){
	try{
		i = parseFloat(i);
		if((i+"")==("NaN")){
			return 0;
		}else{
			return i;
		}
	}catch(e){
		return 0;
	}
}
function toPrecision(aNumber,precision){
	if(aNumber === null || aNumber === "")
		return "";
	var temp1 = Math.pow(10,precision);
	if(aNumber.toString().indexOf(",") > -1)
		aNumber = aNumber.toString().replace(/,/g,"");		//处理千分位计算
	var temp2 = new Number(aNumber);

	var returnVal = isNaN(Math.round(temp1*temp2) /temp1)?0:Math.round(temp1*temp2) /temp1;
	try{
		if(String(returnVal).indexOf("e")>=0)return returnVal;
	}catch(e){}
	var valInt = (returnVal.toString().split(".")[1]+"").length;
	if(valInt != precision){
	    var lengInt = precision-valInt;
		//判断添加小数位0的个数
		if(lengInt == 1){
			returnVal += "0";
		}else if(lengInt == 2){
			returnVal += "00";
		}else if(lengInt == 3){
			returnVal += "000";
		}else if(lengInt < 0){
			var returnValStr = returnVal.toString();
			if(returnValStr.indexOf(".") > -1){	//四舍五入
				returnVal = parseFloat(returnValStr).toFixed(precision);
			}else{
				if(precision == 1){
					returnVal += ".0";
				}else if(precision == 2){
					returnVal += ".00";
				}else if(precision == 3){
					returnVal += ".000";
				}else if(precision == 4){
					returnVal += ".0000";
				}
			}
		}		
	}
	return  returnVal;
}

function getObjectName(obj,indexChar){
	var tempStr = obj.name.toString();
	return tempStr.substring(0,tempStr.indexOf(indexChar)>=0?tempStr.indexOf(indexChar):tempStr.length);
}
//TD4262 增加提示信息  开始


//提示窗口
function showPrompt(content){

	var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
	var isOpera = userAgent.indexOf("Opera") > -1;
	var pTop=0;
	//if (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera){
		pTop= document.body.offsetHeight/2 - (parent.document.body.offsetHeight/2 - document.body.offsetHeight/2) - 55;
	//}else{
		//pTop= document.body.offsetHeight/2+jQuery(document).scrollTop()-50;
	//}
	var showTableDiv  = document.getElementById('_xTable');
	var message_table_Div = document.createElement("div")
	message_table_Div.id="message_table_Div";
	message_table_Div.className="xTable_message";
	showTableDiv.appendChild(message_table_Div);
	var message_table_Div  = document.getElementById("message_table_Div");
	message_table_Div.style.display="inline";
	message_table_Div.innerHTML=content;
	
	var pLeft= document.body.offsetWidth/2-55;
	//message_table_Div.style.position="absolute"
	//message_table_Div.style.top=pTop;
	//message_table_Div.style.left=pLeft;

	message_table_Div.style.zIndex=1002;
	
	/*var oIframe = document.createElement('iframe');
	oIframe.id = 'HelpFrame';
	showTableDiv.appendChild(oIframe);
	oIframe.frameborder = 0;
	oIframe.style.position = 'absolute';
	oIframe.style.top = pTop;
	oIframe.style.left = pLeft;
	oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
	oIframe.style.width = parseInt(message_table_Div.offsetWidth);
	oIframe.style.height = parseInt(message_table_Div.offsetHeight);
	oIframe.style.display = 'block';*/
	
    var top = pTop;   
    var left = pLeft;   
    jQuery("#_xTable").css( { position : 'fixed', 'top' : top, 'left' : left } ).show();  
	
}
//TD4262 增加提示信息  结束
function createAndRemoveObj(obj){
	objName = obj.name;
	tempObjonchange=obj.onchange;
	outerHTML="<input name="+objName+" class=InputStyle type=file size=60 >";
	document.getElementById(objName).outerHTML=outerHTML;
	document.getElementById(objName).onchange=tempObjonchange;
}
function DateCompare(YearFrom, MonthFrom, DayFrom,YearTo, MonthTo,DayTo){
	YearFrom  = parseInt(YearFrom,10);
	MonthFrom = parseInt(MonthFrom,10);
	DayFrom = parseInt(DayFrom,10);
	YearTo	= parseInt(YearTo,10);
	MonthTo   = parseInt(MonthTo,10);
	DayTo = parseInt(DayTo,10);
	if(YearTo<YearFrom){
		return false;
	}else{
		if(YearTo==YearFrom){
			if(MonthTo<MonthFrom){
				return false;
			}else{
				if(MonthTo==MonthFrom){
					if(DayTo<DayFrom)
					return false;
					else
					return true;
				}
				else
				return true;
			}
		}else{
			return true;
		}
	}
}
function onAddPhrase(phrase){
	if(phrase!=null && phrase!=""){
		document.getElementById("remarkSpan").innerHTML = "";
		try{
			var remarkHtml = FCKEditorExt.getHtml("remark");
			var remarkText = FCKEditorExt.getText("remark");
			if(remarkText==null || remarkText==""){
				FCKEditorExt.setHtml(phrase,"remark");
			}else{
				FCKEditorExt.setHtml(remarkHtml+phrase,"remark");
			}
		}catch(e){}
	}
}
//主表中金额转换字段调用
function numberToFormat(index){
	if(document.getElementById("field_lable"+index).value != ""){
		var floatNum = floatFormat(document.getElementById("field_lable"+index).value);
       	var val = numberChangeToChinese(floatNum)
       	if(val == ""){
       		alert(msgWarningJinEConvert);
            document.getElementById("field"+index).value = "";
            document.getElementById("field_lable"+index).value = "";
            document.getElementById("field_chinglish"+index).value = "";
       	} else {
	        document.getElementById("field"+index).value = floatNum;
	        document.getElementById("field_lable"+index).value = milfloatFormat(floatNum);
       		document.getElementById("field_chinglish"+index).value = val;
       	}
	}else{
		document.getElementById("field"+index).value = "";
		document.getElementById("field_chinglish"+index).value = "";
	}
}
function numberToFormatForReadOnly(index){
	if($GetEle("field"+index).value!=""){
		$GetEle("field"+index+"span").innerHTML=milfloatFormat($GetEle("field"+index).value);
		$GetEle("field"+index+"ncspan").innerHTML=numberChangeToChinese($GetEle("field"+index).value);
	}else{
		$GetEle("field"+index+"span").innerHTML="";
		$GetEle("field"+index+"ncspan").innerHTML="";
	}
}
function FormatToNumber(index){
	var elm = $GetEle("field_lable"+index);
	var n = getLocation(elm);
	if(document.getElementById("field_lable"+index).value != ""){
		document.getElementById("field_lable"+index).value = document.getElementById("field"+index).value;
	}else{
		document.getElementById("field"+index).value = "";
		document.getElementById("field_chinglish"+index).value = "";
	}
	setLocation(elm,n);
}
//明细表中金额转换字段调用
function numberToChinese(index){
	if($G("field_lable"+index).value != ""){
		var floatNum = floatFormat(document.getElementById("field_lable"+index).value);
		var val = numberChangeToChinese(floatNum);
		if(val == ""){
			alert(msgWarningJinEConvert);
			document.getElementById("field_lable"+index).value = "";
			document.getElementById("field"+index).value = "";
		}else{
			document.getElementById("field_lable"+index).value = val;
			document.getElementById("field"+index).value = floatNum;
		}
	} else {
		document.getElementById("field"+index).value = "";
	}
}
function ChineseToNumber(index){
	if(document.getElementById("field_lable"+index).value != ""){
		document.getElementById("field_lable"+index).value = chineseChangeToNumber(document.getElementById("field_lable"+index).value);
		document.getElementById("field"+index).value = document.getElementById("field_lable"+index).value;
	}else{
		document.getElementById("field"+index).value = "";
	}
}
function uescape(url){
	return escape(url);
}
function formatTable(t){
	//整体使用try，是防止明细字段设置有问题的时候添加、删除行出现不规则时发生整理table高度出错的问题


	try{
		if(t.innerHTML.indexOf('detailFieldTable') < 0){
			return;
		}
		var datarow ;
		for(i = 0; i < t.rows.length; i++){
			tablerow = t.rows[i];
			if(tablerow.cells[0] && tablerow.cells[0].firstChild && tablerow.cells[0].firstChild.id && tablerow.cells[0].firstChild.id.indexOf('detailFieldTable') == 0){
				datarow = t.rows[i];
			}
		}
		if(datarow == null){
			return;
		}
		var rowheight = new Array();
		tablecount = datarow.cells.length;
		rowcount = datarow.cells[0].firstChild.rows.length;
		equalrowcount=0;
		if(rowcount > 10){
			caldelay = 10000;
		}
		for(i=0; i<rowcount; i++){
			equalcount = 0;
			for(j=0; j<tablecount; j++){
				otable = datarow.cells[j].firstChild;
				orows = otable.rows;
				if(j>0 && orows[i].clientHeight==datarow.cells[j-1].firstChild.rows[i].clientHeight){
					equalcount++;
				}
				if(!rowheight[i]){
					rowheight[i] = orows[i].clientHeight;
				}else if(rowheight[i] < orows[i].clientHeight){
					rowheight[i] = orows[i].clientHeight;
				}
			}
			if (equalcount == tablecount-1){
				equalrowcount++;
			}
		}
		if(equalrowcount==rowcount){
			return;
		}
		for (i = 0; i < datarow.cells.length; i++) {
			otable = datarow.cells[i].firstChild;
			orows = otable.rows;
			for (j = 0; j < orows.length; j++) {
				//alert(orows[j].cells[0].tagName);
				orows[j].cells[0].style.height = rowheight[j];
			}
		}
	}catch(e){}
}

var detailtables = null;
var initBatchNum = 200;
var intervalTime = 100;
var rowProcessing = false;
var isProcessing  = false;
function formatTableNew(isFirst){
		detailtables = jQuery("table[name^='oTable'][class!='excelDetailTable']");
		var tables = [];
		for(var j=0;j<detailtables.length;j++){
			tables[j] = detailtables.eq(j).find("table[id^='detailFieldTable']");
			for(var i=0; i<tables[j].length; i++){
				tables[j][i].__cols = tables[j].eq(i).find("td.detailfield");
			}
			formatTableCall(tables[j],detailtables.eq(j).attr("name"),isFirst);
			//formatTableInit(tables[j],0,initBatchNum);
		}
}

function formatTableNewInit(){
		isProcessing = true;
		detailtables = jQuery("table[name^='oTable'][class!='excelDetailTable']");
		var tables = [];
		for(var j=0;j<detailtables.length;j++){
			tables[j] = detailtables.eq(j).find("table[id^='detailFieldTable']");
			for(var i=0; i<tables[j].length; i++){
				tables[j][i].__cols = tables[j].eq(i).find('td.detailfield');
			}
			//formatTableCall(tables[j],detailtables.eq(j).attr("name"));
			formatTableInit(tables[j],0,initBatchNum);
		}
}



function formatTableInit(tables,fromIndex, toIndex){
	if(tables[0]){
	var rows = tables[0].__cols.length;
	var shiftH = 0;
	
	for(var i=fromIndex; i<toIndex && i<rows; i++){
		var curMaxH = 20;
		for(var j=0; j<tables.length; j++){
			var curH = tables[j].__cols.eq(i).height()+shiftH;

			if(curH > curMaxH){
				curMaxH = curH;
			}
		}
		for(var j=0; j<tables.length; j++){
			tables[j].__cols.eq(i).height(curMaxH);
		}
		
		}
	}

	if(toIndex > rows){
		window.setTimeout(function(){isProcessing = false;},100);
		return;
	}

	window.setTimeout(function(){
		formatTableInit(tables,fromIndex + initBatchNum, toIndex + initBatchNum);
	},10);
}

function startFormatTableNew(){
	if(isProcessing){
		window.setTimeout(function(){startFormatTableNew()},100);
	}else{
		formatTableNew(true);
	}
}

function formatTableCall(tables, oTable,isFirst){
	var hasChg = false;
	if(!rowProcessing){
		var _shiftH = 2;
	for(var i=0; i<tables.length && !isFirst; i++){
		var chgH = tables.eq(i).height();
		if(tables[i].__curH!=null && (chgH > (tables[i].__curH+_shiftH)||chgH<(tables[i].__curH-_shiftH))){
			//if(window.console) console.log(i+"::"+chgH+"::"+tables[i].__curH);
			//alert(i+"::"+chgH+"::"+tables[i].__curH);
			hasChg = true;
			break;
		}else if(tables[i].__curH==null){
			tables[i].__curH = chgH;
		}
	}
}
	if(hasChg && !rowProcessing){
		try{
			__formatTable(tables,oTable);
		}catch(e){
			//if(window.console) console.log('e::'+e);
			window.setTimeout(function(){
				formatTableCall(tables,oTable,false);
			},intervalTime);
		}
	}else{
		//if(console) console.log('=======');
		window.setTimeout(function(){
			formatTableCall(tables,oTable,false);
		},intervalTime);
	}
}

function __formatTable(tables,oTable){
	//if(window.console) console.log('begin set height');
	var start = new Date().getTime();

	var viewHeight = document.body.clientHeight > 2000 ? 2000:document.body.clientHeight;
	var viewWidth = 1000;
	var topE = null;
	var bottomE = null;
	var viewCol = null;
	
	for(var j=20; j<viewWidth; j=j+50){
		var isBreak = false;
		for(var i=0; i<viewHeight; i=i+5){
			var e = document.elementFromPoint(j,i);
			if(e){
				var jqe = jQuery(e);
				if(window.console){
					//console.log(e.tagName+' oTable::'+oTable+'  oTable::'+jqe.parents("table[name=^'"+oTable+"']").length+"   detaileTable::"+jqe.parent("table[name^='detailTable']").length);
				}
				if(jqe.parents("table[name='"+oTable+"']").length>0 && jqe.parents("table[id^='detailFieldTable']").length>0){
					//e.style.background = 'red';
					//alert(j+"::"+i+"::"+e.tagName);
					jqe = jqe.closest('td.detailfield');
					if(jqe.length>0){
						topE = jqe[0];
						isBreak = true;
						break;
					}
				}
			}
		}

		for(var i=viewHeight; i>0; i=i-5){
			var e = document.elementFromPoint(j,i);
			if(e){
				var jqe = jQuery(e);
				if(jqe.parents("table[name='"+oTable+"']").length>0 && jqe.parents("table[id^='detailFieldTable']").length>0){
					jqe = jqe.closest('td.detailfield');
					if(jqe.length>0){
						bottomE = jqe[0];
						isBreak = true;
						break;
					}
				}
			}
		}
		if(isBreak) {
			viewCol = jqe.parents('table').eq(0);
			break;
		}
	}
	//topE.style.background = 'red';
	//bottomE.style.background = 'red';
	//alert(topE+":"+bottomE);
	if(viewCol){
		var viewColTds = viewCol.find('td.detailfield');
		var topIndex = 0;
		var bottomIndex = 0;
		var leftIndex = 0;

		var i=0;
		for(; i<viewColTds.length; i++){
			if(viewColTds[i] === topE){
				topIndex = i;
				break;
			}
		}
		for(; i<viewColTds.length; i++){
			if(viewColTds[i] === bottomE){
				bottomIndex = i;
				break;
			}
		}

		for(var i=0; i<tables.length; i++){
			if(viewCol[0] === tables[i]){
				leftIndex = i;
			}
		}

		//alert(topIndex + ":" + bottomIndex + ":" + leftIndex);
		//if(window.console)console.log(topIndex + ":" + bottomIndex + ":" + leftIndex);

		//if(window.console) console.log('time1='+(new Date().getTime() - start));
		start = new Date().getTime();

		for(var i=0; i<tables.length; i++){
			tables[i].__cols = tables.eq(i).find('td.detailfield');
		}

		//if(window.console) console.log('time2='+(new Date().getTime() - start));
		start = new Date().getTime();


		var shiftH = 0;

		for(var i=topIndex; i<=bottomIndex; i++){

			var curMaxH = tables[0].__cols[i].___maxH;
			if(curMaxH==null)curMaxH=1;
			var isRowChg = false;
			var curMaxHColIndex = 0;
			for(var j=0; j<tables.length; j++){
				//tables[j].__cols.eq(i).height(20);
				var curH = tables[j].__cols.eq(i).height()+shiftH;
				//var curH = tables[j].__cols.eq(i).outerHeight();
				if(window.console)console.log("curH:"+curH+"; curMaxH:"+curMaxH+";  isRowChg:"+isRowChg + "; j:"+j);
				if(curH > curMaxH){
					if(curMaxH != 0){
						isRowChg = true;
						curMaxHColIndex = j;
					}
					curMaxH = curH;
				}
			}

			//if(window.console) console.log('isRowChg:'+isRowChg+"; curMaxHColIndex:"+curMaxHColIndex+"; topIndex:"+topIndex+"; bottomIndex:"+bottomIndex);
			
			if(isRowChg){
				//tables[curMaxHColIndex].__cols.eq(i).height(30);
				tables[0].__cols[i].___maxH = tables[curMaxHColIndex].__cols.eq(i).height()+shiftH;
				tables[0].__cols[i].___isChg = true;
			}else{
				tables[0].__cols[i].___maxH = curMaxH;
				tables[0].__cols[i].___isChg = false;
			}
		}

		//if(window.console) console.log('time3='+(new Date().getTime() - start));
		start = new Date().getTime();

		//alert('chgIndex='+chgIndex);

		var firstWidth = 20;

		for(var i=topIndex; i<=bottomIndex; i++){
			for(var j=leftIndex; j<tables.length && j<=leftIndex+firstWidth; j++){
				if(tables[0].__cols[i].___isChg){
					//if(window.console) console.log('Change Height('+i+','+j+') to:'+tables[0].__cols[i].___maxH);
					tables[j].__cols.eq(i).height(tables[0].__cols[i].___maxH);
				}
			}
		}
		//if(window.console) console.log('time4='+(new Date().getTime() - start));
		start = new Date().getTime();
	}

	window.setTimeout(function(){

		var __leftIndex = leftIndex;
		var __firstWidth = firstWidth;
		
		var __topIndex = topIndex;
		var __bottomIndex = bottomIndex;
		var __tablesLength = tables.length;
	
		for(var i=__topIndex; i<=__bottomIndex; i++){
			for(var j=0; j<__tablesLength; j++){
				if(j<__leftIndex || j>__leftIndex+__firstWidth){
					if(tables[0].__cols[i].___isChg){
						tables[j].__cols.eq(i).height(tables[0].__cols[i].___maxH);
					}
				}
			}
		}

		for(var i=0; i<tables.length; i++){
			tables[i].__curH = tables.eq(i).height();
		}

		window.setTimeout(function(){
			formatTableCall(tables,oTable,false);
		},intervalTime);

	},10);

	//if(window.console) console.log('time4='+(new Date().getTime() - start));
	start = new Date().getTime();
}


function changeFormSplitPage(tabCount){
	//div的隐藏和显示
	jQuery("div[name^=formsplitdiv]").hide();
	jQuery("#formsplitdiv"+tabCount).show();
	//按钮的class改变
	jQuery("td[name^=formsplitspan]").attr("class","formSplitSpanOut");
	jQuery("#formsplitspan"+tabCount).attr("class","formSplitSpanIn");

}
function changeTo1000(svalue){
	var rvalue = "";
	var re;
	if(svalue.indexOf(".")<0){
        re = /(\d{1,3})(?=(\d{3})+($))/g;
    }else{
        re = /(\d{1,3})(?=(\d{3})+(\.))/g;
	}
    rvalue = svalue.replace(re,"$1,");
	return rvalue;
}

//保留n位有效数字，系统默认保留4位，如果没有小数点或小数点后全为0，则不保留小数点
//result:带格式化的浮点数
//n:需保留的小数位数
//round:是否需要四舍五入
//zero:如果为0，是否保留小数位，默认为否
function doFormatNumber(result,n,round,zero)
{
	var intNum,floatNum;
	try{
		if(n==null||n==undefined){
			n = 4;
		}
		if(round==null||round==undefined){
			round=true;
		}
		if(zero==null||zero==undefined){
			zero = false;
		}
		if(result.toString().indexOf(".")==-1){
			return result;
		}
		intNum = result.toString().split(".")[0];
		floatNum = result.toString().split(".")[1];
		if(n==0){
			if(round && Number(floatNum.charAt(0))>=5){
				return Number(intNum)+1;
			}else{
				return intNum;
			}
		}
		if(floatNum.length<=n){
			if(zero)return result;
			var str = floatNum.replace(new RegExp("0","gm"),"");
			if(str==""){
				return intNum;
			}
			for(var i=floatNum.length-1;i>0;i--){
			if(floatNum.charAt(i)!=0){
				break;
			}else{
				floatNum = floatNum.substring(0,i);
			}
		}
			return intNum+"."+floatNum;
		}
		
		if(round && Number(floatNum.charAt(n))>=5){
			if(floatNum.substring(0,n).match(/^9+$/)!=null){
				intNum = (Number(intNum)+1).toString();
				floatNum = "";
			}else{
				floatNum = (Number(floatNum.substring(0,n))+1).toString();
				for(var i=floatNum.length;i<n;i++){
					floatNum = "0"+floatNum;
				}
			}				
		}else{
			floatNum = floatNum.substring(0,n);
		}
		if(!zero){
			str = floatNum.substring(0,n).replace(new RegExp("0","gm"),"");
			if(str==""){
				return intNum;
			}
			for(var i=n-1;i>0;i--){
				if(floatNum.charAt(i)!=0){
					break;
				}else{
					floatNum = floatNum.substring(0,i);
				}
			}
		}
		return intNum+"."+floatNum;
	}catch(e){
		return result.toString();
	}
}
function toFix(Number,decimalnum){
	var x=1;
	var temp_NUmber;
	//Number = Number.toFixed(decimalnum+1);
	for(var i=0; i<decimalnum; i++){
		x = x*10;
	}
	if(!isFinite(Number) || isNaN(Number)){

	temp_NUmber=0;
	}else{
	temp_NUmber  = Number>0?parseInt((Number*x+0.5),10)/x:parseInt((Number*x-0.5),10)/x;
	}
	//if(window.console)console.log("----2-temp_NUmber--"+temp_NUmber);
	return temp_NUmber.toFixed(decimalnum);
}

function changeToThousandsVal(_sourcevalue){
	var sourcevalue = _sourcevalue.toString();
	if(null != sourcevalue && 0 != sourcevalue){
	     if(sourcevalue.indexOf(".")<0)
	        re = /(\d{1,3})(?=(\d{3})+($))/g;
	     else
	        re = /(\d{1,3})(?=(\d{3})+(\.))/g;
        if(window.console)console.log("sourcevalue = "+sourcevalue+" reg = "+re+" result = "+sourcevalue.replace(re,"$1,"));
		return sourcevalue.replace(re,"$1,");
	}else{
		return sourcevalue;
	}
}




