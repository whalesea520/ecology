/**
* 此函数用于检查页面控件中数据是否改动
* created by cyril on 2008-06-05
*/
var tagFlag = "ecology_verify_";//生成的前辍,不能为空
var tagArrFlag = "arr_"+tagFlag;
var tagArrIndex = "index_"+tagArrFlag;
var tagArrContext = "";
//以下创建标签
function createTags() {
	var tagsBuffer = '';
	tagArrContext = '';
	//检查input项
	var f_incheckbox = '';
	var f_inupload = '';
	var f_inputs = document.getElementsByTagName('input');
	for(i=0; i<f_inputs.length; i++) {

		/*如果是request目录下的页面，并且页面中控件的名字不以field开始，则跳过*/
		if( _checkExcp(jQuery(f_inputs[i]).attr('name'))){ 
			continue;
		}

		try{
			if(f_inputs[i].name.indexOf(tagFlag)==-1) {
				if((f_inputs[i].type=='text' || f_inputs[i].type=='hidden')) {
					controlArr(f_inputs[i].name);//判断是否多个控件同名
					tagsBuffer += f_inputs[i].name+'<input type="text" name="'+tagFlag+f_inputs[i].name+'" value="'+escape(f_inputs[i].value)+'">';
				}
				else if(f_inputs[i].type=='radio' && f_inputs[i].checked==true) {
					tagsBuffer += f_inputs[i].name+'<input type="radio" name="'+tagFlag+f_inputs[i].name+'" value="'+escape(f_inputs[i].value)+'" checked="true">';
				}
				else if(f_inputs[i].type=='checkbox') {
					if(f_inputs[i].checked) {
						f_incheckbox = ' checked="true" ';
					}
					else {
						 f_incheckbox = '';
					}
					tagsBuffer += f_inputs[i].name+'<input type="checkbox" name="'+tagFlag+f_inputs[i].name+'" value="'+escape(f_inputs[i].value)+'"'+f_incheckbox+'>';
				}
			}
		}
		catch(e){
			//do nothing
		}
	}
	//检查textarea项
	var f_textarea = document.getElementsByTagName('textarea');
	for(i=0; i<f_textarea.length; i++) {
		try{
			if(f_textarea[i].name.indexOf(tagFlag)==-1) {
				controlArr(f_textarea[i].name);//判断是否多个控件同名
				tagsBuffer += f_textarea[i].name+'<textarea name="'+tagFlag+f_textarea[i].name+'">'+escape(f_textarea[i].value)+'</textarea>';
			}
		}
		catch(e) {
			//do nothing
		}
	}
	
	//检查select项
	var f_select = document.getElementsByTagName('select');
	for(i=0; i<f_select.length; i++) {
		try{
			if(f_select[i].name.indexOf(tagFlag)==-1) {
				controlArr(f_select[i].name);//判断是否多个控件同名
				tagsBuffer += f_select[i].name+'<input type="text" name="'+tagFlag+f_select[i].name+'" value="'+escape(f_select[i].value)+'">';
			}
		}
		catch(e) {
			//do nothing 
		}
	}
	
	//将多个控件引入
	tagsBuffer += tagArrContext;
	var div_box;
	if($GetEle(tagFlag+'DIV')==null){
		div_box = document.createElement('DIV');
		div_box.id = tagFlag+'DIV';
	}
	else
		div_box = $GetEle(tagFlag+'DIV');
	div_box.style.display = 'none';
	try {
		if(typeof(debug)!=true) {
			debug = false;
		}
		if(typeof(debug)==true) {
			div_box.style.display = '';
			div_box.style.background='#ff0099';
		}
	}
	catch(e) {
		//do nothing
		debug = false;
	}
 	div_box.innerHTML = tagsBuffer;
 	if($GetEle(tagFlag+'DIV')==null)
 		document.body.appendChild(div_box);
}

//创建多个控件名称相同的
function controlArr(cname) {
	var inputs = document.getElementsByName(cname);
	if(inputs.length>1 && tagArrContext.indexOf(tagArrFlag+cname)==-1) {
		tagArrContext += '<input type="text" name="'+tagArrFlag+cname+'" value="'+inputs.length+'">';
		tagArrContext += '<input type="text" name="'+tagArrIndex+cname+'" value="0">';
	}
}
jQuery(function () {
	createTags();
});

//复位多控件下标
function resetControlArr() {
	var arrIndexs = document.getElementsByTagName('input');
	for(i=0; i<arrIndexs.length; i++) {
		if(arrIndexs[i].name.indexOf(tagArrIndex)!=-1) {
			arrIndexs[i].value = 0;
		}
	}
}

//检查多个控件名称相同的
function checkControlArr(cname) {
	var cindex = 0;
	var inputs = document.getElementsByName(cname);
	if(inputs.length>1 && $GetEle(tagArrFlag+cname)!=null) {
		var input_index = $GetEle(tagArrIndex+cname);
		cindex = input_index.value;
		if((cindex*1+1)>($GetEle(tagArrFlag+cname).value*1)) {
			return -1;
		}
		input_index.value = cindex*1+1;
	}
	return cindex;
}

function _checkExcp(name) {
	/*如果是request目录下的页面，并且页面中控件的名字不以field开始，则跳过*/
	if (!!!name) {
		return true;
	}
	
	if( name.indexOf('remark') == -1
		&& name.indexOf('requestname') == -1
		&& name.indexOf('requestlevel') == -1
		&& name.indexOf('messageType') == -1
		&& name.indexOf('field') != 0 
		&& window.location.href.indexOf('/workflow/request') >= 0 ){
		return true;
	}
	return false;
}

//以下检查是否改动
function checkDataChange() {
//debug = true;
	resetControlArr();//将多控件下标复位
	//检查input项
	var f_incheckbox = '';
	var f_inupload = '';
	var f_inputs = document.getElementsByTagName('input');
	for(i=0; i<f_inputs.length; i++) {
		
		/*如果是request目录下的页面，并且页面中控件的名字不以field开始，则跳过*/
		if( _checkExcp(jQuery(f_inputs[i]).attr('name'))){
			continue;
		}
		/*
		var regex = /^field\d+_\d__$/g;
		if (!!regex.exec(jQuery(f_inputs[i]).attr('name'))) {
			continue;
		}
		*/
		
		try{
			if(f_inputs[i].name.indexOf(tagFlag)==-1 && f_inputs[i].name != undefined && f_inputs[i].name != "") {
				if(f_inputs[i].type=='text' || f_inputs[i].type=='hidden' || f_inputs[i].type==null) {
					var f_inputs_index = checkControlArr(f_inputs[i].name);
					if(document.getElementsByName(tagFlag+f_inputs[i].name).length==0 || f_inputs_index==-1) {
						if(debug==true)
							alert('new INPUT:'+f_inputs[i].name+'['+f_inputs_index+']');
						if(f_inputs[i].name.indexOf("allPage") == -1 && f_inputs[i].name.indexOf("allItem") == -1 && f_inputs[i].name.indexOf("currentPageCnt") == -1 && f_inputs[i].name.indexOf("maxrequestlogid") == -1 && f_inputs[i].parentNode.parentNode.parentNode.parentNode.id.indexOf('insertObjectContainer') == -1 && f_inputs[i].parentNode.parentNode.parentNode.parentNode.id!='insertObjectContainer_remark')//判断FCKEditor
							return false;
					} else if(f_inputs[i] != undefined && f_inputs[i].name != undefined && f_inputs[i].name != '' && f_inputs[i].value!=unescape(document.getElementsByName(tagFlag+f_inputs[i].name)[f_inputs_index].value)) {
						if(debug==true)
							alert('INPUT:'+f_inputs[i].name+'['+f_inputs_index+']="'+f_inputs[i].value+'"<====>"'+unescape(document.getElementsByName(tagFlag+f_inputs[i].name)[f_inputs_index].value)+'"');
					 	return false;
					}
				} else if(f_inputs[i].type=='radio' && f_inputs[i].checked==true) {
					if(document.getElementsByName(tagFlag+f_inputs[i].name).length==0) {
						if(debug==true)
							alert('new RADIO:'+f_inputs[i].name);
						if(f_inputs[i].parentNode.parentNode.parentNode.parentNode.id.indexOf('insertObjectContainer') == -1 && f_inputs[i].parentNode.parentNode.parentNode.parentNode.id!='insertObjectContainer_remark')//判断FCKEditor
							return false;
					}
					else if(document.getElementsByName(tagFlag+f_inputs[i].name).length==1 && f_inputs[i].value!=unescape(document.getElementsByName(tagFlag+f_inputs[i].name)[0].value)) {
						if(debug==true)
							alert('RADIO:'+f_inputs[i].name+'='+f_inputs[i].value+'<====>'+unescape(document.getElementsByName(tagFlag+f_inputs[i].name)[0].value));
					 	return false;
					}
				}
				else if(f_inputs[i].type=='checkbox') {
					var f_checkbox_index = checkControlArr(f_inputs[i].name);
					if(document.getElementsByName(tagFlag+f_inputs[i].name).length==0 || f_checkbox_index==-1) {
						if(debug==true)
							alert('new CHECKBOX:'+f_inputs[i].name+'['+f_checkbox_index+']');
						return false;
					}
					else if(document.getElementsByName(tagFlag+f_inputs[i].name).length>0 && f_inputs[i].checked!=document.getElementsByName(tagFlag+f_inputs[i].name)[f_checkbox_index].checked) {
						if(debug==true)
							alert('CHECKBOX:'+f_inputs[i].name+'['+f_checkbox_index+']="'+f_inputs[i].checked+'"<====>"'+document.getElementsByName(tagFlag+f_inputs[i].name)[f_checkbox_index].checked+'"');
						return false;
					}
				}
				//特别检查附件上传项
				if(f_inputs[i].name.indexOf('_num')!=-1 && f_inputs[i].name!=f_inupload) {
					f_inupload = f_inputs[i].name;
					var f_upload_name = f_inputs[i].name.substring(0,f_inputs[i].name.indexOf('_num'));
					for(j=1; j<=f_inputs[i].value; j++) {
						if(document.getElementsByName(f_upload_name+'_'+j)[0].value.length>0) {
							if(debug==true)
								alert('FILEUPLOAD:'+f_upload_name+'_'+j);
							return false;
						}
					}
				}
			}
		}
		catch(e){
			//do nothing
		}
	}
	//检查textarea项
	var f_textarea = document.getElementsByTagName('textarea');
	for(i=0; i<f_textarea.length; i++) {
		try{
			if(f_textarea[i].name.indexOf(tagFlag)==-1) {
				var f_textarea_index = checkControlArr(f_textarea[i].name);
				if(document.getElementsByName(tagFlag+f_textarea[i].name).length==0 || f_textarea_index==-1) {
					if(debug==true)
						alert('new textarea:'+f_textarea[i].name+'['+f_textarea_index+']');
					return false;
				}
				else if(document.getElementsByName(tagFlag+f_textarea[i].name).length>0 && f_textarea[i].value!=unescape(document.getElementsByName(tagFlag+f_textarea[i].name)[f_textarea_index].value)) {
					if(debug==true)
						alert('textarea:'+f_textarea[i].name+'['+f_textarea_index+']="'+f_textarea[i].value+'"<====>"'+unescape(document.getElementsByName(tagFlag+f_textarea[i].name)[f_textarea_index].value)+'"');
				 	return false;
				}
			}
		}
		catch(e) {
			//do nothing
		}
	}
	
	//检查select项
	var f_select = document.getElementsByTagName('select');
	for(i=0; i<f_select.length; i++) {
		/*如果是request目录下的页面，并且页面中控件的名字不以field开始，则跳过*/
		if( _checkExcp(jQuery(f_inputs[i]).attr('name'))){ 
			continue;
		}
		
		try{
			if(f_select[i].name.indexOf(tagFlag)==-1) {
				var f_select_index = checkControlArr(f_select[i].name);
				if((f_select[i].name.indexOf('pageSizeSeldiv_pager_') < 0  && document.getElementsByName(tagFlag+f_select[i].name).length==0) || f_select_index==-1) {
					if(debug==true)
						alert('new SELECT:'+f_select[i].name+'['+f_select_index+']');
					return false;
				}
				else if(document.getElementsByName(tagFlag+f_select[i].name).length>0 && f_select[i].value!=unescape(document.getElementsByName(tagFlag+f_select[i].name)[f_select_index].value)) {
					if(debug==true)
						alert('SELECT:'+f_select[i].name+'['+f_select_index+']="'+f_select[i].value+'"<====>"'+unescape(document.getElementsByName(tagFlag+f_select[i].name)[f_select_index].value)+'"');
				 	return false;
				}
			}
		}
		catch(e) {
			//do nothing 
		}
	}
	return true;
}

//特殊类型的input补充,如完成%比的控件,JS无法自行读到,因为使用了<!-- -->标签注释
function difInput(cname,cvalue) {
	try {
		var difBuffer = '';
		var cobj = document.getElementsByName(cname);
		controlArr(cname);//判断是否多个控件同名
		for(i=0; i<cobj.length; i++) {
			difBuffer += cname+'<input type="text" name="'+tagFlag+cname+'" value="'+escape(cobj[i].value+cvalue)+'">';
		}
		if($GetEle(tagFlag+'DIV')==null)
			alert(SystemEnv.getHtmlNoteName(3509,readCookie("languageidweaver")));
		$GetEle(tagFlag+'DIV').innerHTML += difBuffer;
	}
	catch(e) {
	}
}