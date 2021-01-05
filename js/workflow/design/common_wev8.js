//检查页面Form表单的各项输入是否符合要求
function checkFormRule(frm){
  try{
    var oAll = frm.all;
    var oItem, s, r;
    for(i = 0; i<oAll.length; i++){
      oItem = oAll[i];
      s = oItem.tagName.toLowerCase(); 
      if(s == "input"||s == "select"){
        if("rule" in oItem){
          r = new RegExp(oItem.rule);
          if(!r.test(oItem.value)){
            alert(oItem.msg);
            oItem.focus();
            if(s == "input") oItem.select();
            return false;
          }
        }
      }
    }
    return true;
  }
  catch(e){
    alert(e);
    return false;
  }
}

//打开模式窗口
function vmlOpenWin(url,arg,w,h){
  return showModalDialog(url, arg, "dialogWidth:"+w+"px; dialogHeight:"+h+"px; status:0;help:no")
}

//字符串处理增强函数，去掉空格
String.prototype.trim = function(){
  return this.replace(/(^\s*)|(\s*$)/g, "");
}

//表格中的单元格合并函数
function mergecell(tb){
  var iRowCnt = tb.rows.length;
  if(iRowCnt <= 1) return;
	var iPreIndex=1;
	var sPreText=tb.rows(iPreIndex).cells(0).innerText;
	var sCurText="";
	for(var i=2;i<iRowCnt;i++){
		sCurText=tb.rows(i).cells(0).innerText;
		if(sCurText==sPreText){//需要合并
			tb.rows(iPreIndex).cells(0).rowSpan++;
			tb.rows(i).deleteCell(0);
		}
		else{
			iPreIndex=i;
			sPreText=sCurText;
		}
	}
}

/**
 * 数组复制
 * @param {} flag 'Proc':节点 'Step': '出口'
 * @return {}
 */
 Array.prototype.clone = function(flag){
	 var tmp=new Array();
	 switch(flag){
	 	case 'Proc':
	 		for(var i=0; i<this.length;i++){
			 	var _proc = new TProc(this[i].Flow,this[i].ID);
			 	_proc.clone(this[i]);
			 	tmp[i] = _proc;
		 	}
		 	break;
	 	case 'Step':
	 		for(var i=0; i<this.length;i++){
			 	var _step = new TStep(this[i].Flow,this[i].ID);
			 	_step.clone(this[i]);
			 	tmp[i] = _step;
			}
			break;
	 	case 'Point':
	 		for(var i=0; i<this.length;i++){
			 	var _piont = new TPoint(this[i].Step);
			 	_piont.clone(this[i]);
			 	tmp[i] = _piont;
			}
			break;
	 }
	 return tmp; 
}

/**
 * 快速排序（升序）
 * @param {} array 数组（Proc对象）
 * @param {} lo0
 * @param {} hi0
 * @param {} flag 'X':横向Proc排序。 'Y':纵向Proc排序
 */
function quickSort(array, lo0, hi0,flag) {
		var lo = lo0;
		var hi = hi0;

		if (lo >= hi)
			return;

		// 确定指针方向的逻辑变量
		var transfer = true;

		while (lo != hi) {
			if(flag=="X"){
				if (parseInt(array[lo].X) > parseInt(array[hi].X)) {
					// 交换数字
					var temp = array[lo];
					array[lo] = array[hi];
					array[hi] = temp;
					// 决定下标移动，还是上标移动
					transfer = (transfer == true) ? false : true;
				}
			}else if(flag=="Y"){
				if (parseInt(array[lo].Y) > parseInt(array[hi].Y)) {
					// 交换数字
					var temp = array[lo];
					array[lo] = array[hi];
					array[hi] = temp;
					// 决定下标移动，还是上标移动
					transfer = (transfer == true) ? false : true;
				}
				
			}
			// 将指针向前或者向后移动
			if (transfer)
				hi--;
			else
				lo++;

		}
		// 将数组分开两半，确定每个数字的正确位置
		lo--;
		hi++;
		quickSort(array, lo0, lo,flag);
		quickSort(array, hi, hi0,flag);
}

function changePtToPx(Points){
	var pointAry = Points.split(',')
	var _Points = '';
	for(var i=0;i<pointAry.length;i++){
		if(pointAry[i].indexOf('pt')!=-1){
			_Points += parseInt(parseInt(pointAry[i])*4/3)+',' 
		}else{
			_Points+= parseInt(pointAry[i])+','
		}
	}
	
	if(_Points.length>0){
		_Points = _Points.substring(0,_Points.length-1);
	}
	
	return _Points;
}







