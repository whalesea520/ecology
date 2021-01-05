//切换美化checkbox是否选中
function changeCheckboxStatus4tzCheckBox(obj, checked) {
	jQuery(obj).attr("checked", checked);
	if (obj.checked) {
		jQuery(obj).next("span.tzCheckBox").addClass("checked");
	} else {
		jQuery(obj).next("span.tzCheckBox").removeClass("checked");
	}
}
//切换美化checkbox是否只读
function disOrEnableCheckbox4tzCheckBox(obj, disabled) {
	jQuery(obj).attr("disabled", disabled);
	if(!disabled){
		jQuery(obj).attr("disabled","");
		jQuery(obj).removeAttr("disabled");
	}
}
function fnaRound2(v,e){
	if(v==null||v==""||isNaN(v)){
		v = 0.00;
	}
	return fnaRound(v,e);
}

function fnaRound(v,e){
	var t=1; 
	for(;e>0;t*=10,e--); 
	for(;e<0;t/=10,e++); 
	return Math.round(v*t)/t; 
}
function uescape(url){
    return escape(url);
}
function URLencode(sStr) {
	return escape(sStr).replace(/\+/g, '%2B').replace(/\"/g,'%22').replace(/\'/g, '%27').replace(/\//g,'%2F');
}
function null2String(s){
	if(!s){
		return "";
	}
	return s;
}var diag = null;
function closeDialog(){
	if(diag)diag.close();
}
function openDialog(_url, _title, _w, _h){
	diag = new window.top.Dialog();
	diag.currentWindow = window;
	diag.URL = _url;
	diag.Title = _title;
	diag.Width = _w;
	diag.Height = _h;
	
	diag.isIframe=false;
	
	diag.show();
}


var dbByteLength = 2;
/*
 * 限制输入时，只允许输入指定类型的数字，内含绑定传入控件的以下事件：onkeypress、onkeyup、onmouseout、onblur
 * */
function controlNumberCheck(obj, isDouble, pointLength, allowNegative, maxlength){
	Event.observe(obj.id, "keypress", function(){numberCheck(obj, isDouble, pointLength, allowNegative, maxlength)}, false);
	Event.observe(obj.id, "keyup", function(){numberCheck2(obj, isDouble, pointLength, allowNegative, maxlength)}, false);
	Event.observe(obj.id, "mouseout", function(){numberCheck2(obj, isDouble, pointLength, allowNegative, maxlength)}, false);
	Event.observe(obj.id, "blur", function(){numberCheck2(obj, isDouble, pointLength, allowNegative, maxlength)}, false);
}
function controlNumberCheck_jQuery(id, isDouble, pointLength, allowNegative, maxlength){
	$("#"+id).bind("keypress", function(){numberCheck(document.getElementById(id), isDouble, pointLength, allowNegative, maxlength)});
	$("#"+id).bind("keyup", function(){numberCheck2(document.getElementById(id), isDouble, pointLength, allowNegative, maxlength)});
	$("#"+id).bind("mouseout", function(){numberCheck2(document.getElementById(id), isDouble, pointLength, allowNegative, maxlength)});
	$("#"+id).bind("blur", function(){numberCheck2(document.getElementById(id), isDouble, pointLength, allowNegative, maxlength)});
}
/*限制输入时，只允许输入指定类型的数字
 * onkeypress*/
function numberCheck(obj, isDouble, pointLength, allowNegative, maxlength){
	var s=document.selection.createRange();
	s.setEndPoint("StartToStart",obj.createTextRange());
	var key = event.keyCode;
	if ((key < 48 || key > 57) && key != 45 && key != 46 && key != 8 && key != 46) {
		event.keyCode='';
		return false;
	}else{
		if(document.selection.createRange().text == obj.value){
			obj.value = '';
		}
		if(key == 45 && !allowNegative){
			event.keyCode='';
			return false;
		}
		var objs = obj.value.split('-');
		if(key == 45 && allowNegative && objs.length > 1){
			event.keyCode='';
			return false;
		}
		if(key == 45 && allowNegative && obj.value.length > 0 && s.text.length > 0){
			event.keyCode='';
			return false;
		}
		if(key == 46 && !isDouble){
			event.keyCode='';
			return false;
		}
		objs = obj.value.split('.');
		if(key == 46 && objs.length > 1){
			event.keyCode='';
			return false;
		}
		if(objs.length > 1 && objs[1].length == pointLength){
			if(obj.value.length-s.text.length <= pointLength){
				event.keyCode='';
				return false;
			}
		}
		var pcz = 0;
		if(objs[0].split('')[0] == '-'){
			pcz+=1;
		}
		if(key != 45 && key != 46 && objs.length > 1 && obj.value.length-s.text.length > pointLength && objs[0].length >= maxlength+pcz){
			event.keyCode='';
			return false;
		}
		if(key != 45 && key != 46 && objs.length == 1 && objs[0].length >= maxlength+pcz){
			event.keyCode='';
			return false;
		}
		return true;
	}
}
/*输入后，限制输入的值，只允许输入指定类型的数字
 * onkeyup&&onmouseout
 * onblur*/
function numberCheck2(obj, isDouble, pointLength, allowNegative, maxlength){
	if(obj.value != ''){
		if(!(allowNegative && obj.value == '-')){
			if (isNaN(obj.value)) {
				obj.value = '';
				return false;
			}
			if(!allowNegative && obj.value.substr(0, 1) == '-'){
				obj.value = '';
				return false;
			}
			var objs = obj.value.split('.');
			var pcz = 0;
			if(objs[0].split('')[0] == '-'){
				pcz+=1;
			}
			if(objs[0].length > maxlength+pcz){
				obj.value = '';
				return false;
			}
			if(isDouble && objs.length > 1 && objs[1].length > pointLength){
				obj.value = '';
				return false;
			}
			if(!isDouble && objs.length > 1){
				obj.value = '';
				return false;
			}
		}else{
			
		}
	}
}