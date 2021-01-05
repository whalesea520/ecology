var _multiLangEditBox = null;
var _multiLangEditHandler = null;
var _multiLangEditObj = null;
var _multiLangEditIsEdit = false;
var _multiLangEditTimeoutHandler = null;
/*var _multiLangConfig = [
	{label:"<img src='/images/ecology8/simplized_wev8.png' style='vertical-align:middle;'/>",languageId:7,name:"zhcn"},
	{label:"<img src='/images/ecology8/en_wev8.png' style='vertical-align:middle;'/>",languageId:8,name:"en"},
	{label:"<img src='/images/ecology8/tranditional_wev8.png' style='vertical-align:middle;'/>",languageId:9,name:"twcn"}
];*/
function _needShowMultilang(srcObject){
	var result = true;
	var blur =  null;
	try{
		blur = srcObject.getAttributeNode("onblur").value;
	}catch(e){}
	if(blur){
		result = result && (blur.indexOf("checknumber")==-1 && blur.indexOf("checkinput_char_num_ul")==-1&&blur.indexOf("checkPlusnumber1")==-1);
		if(!result)return result;
	}
	var keypress = null;
	try{
		keypress = srcObject.getAttributeNode("onkeypress").value;
	}catch(e){}
	if(keypress){
		result = result && (keypress.indexOf("ItemNum_KeyPress")==-1) && (keypress.indexOf("ItemCount_KeyPress")==-1);
		if(!result)return result;
	}
	var change = null;
	try{
		change = srcObject.getAttributeNode("onchange").value;
		if(!result)return result;
	}catch(e){}
	if(change){
		result = result && (change.indexOf("checkPositiveNumber")==-1);
		if(!result)return result;
	}
	var noMultiLang = null;
	try{
		noMultiLang = jQuery(srcObject).attr("_noMultiLang");
	}catch(e){}
	if(noMultiLang){
		result = false;
		return false;
	}
	var result = result && srcObject.tagName == "INPUT" && (srcObject.type == "text" || !srcObject.type)  && (jQuery(srcObject).attr("name").indexOf("level")==-1)
		&&  jQuery(srcObject).attr("name")!="inputt4" && jQuery(srcObject).attr("name")!="inputt0" && (jQuery(srcObject).attr("id").indexOf("_XTABLE_GOPAGE_")==-1)
		&& (jQuery(srcObject).attr("name").indexOf("_CN")==-1)&& (jQuery(srcObject).attr("name").indexOf("_En")==-1)&& (jQuery(srcObject).attr("name").indexOf("_TW")==-1)
		&& jQuery(srcObject).closest("div.advancedSearchDiv").length==0 &&  !jQuery(srcObject).hasClass("searchInput") && !jQuery(srcObject).hasClass("_pageSizeInput")
		&& !jQuery(srcObject).hasClass("ac_input") && !jQuery(srcObject).hasClass("spin")&& (jQuery(srcObject).attr("name").indexOf("keyword")==-1 && jQuery(srcObject).closest("div#e8QuerySearchArea").length==0)
	return result;
}
function _getMultiLang(_box,inputObj){
	var table = jQuery("<table>").addClass("LayoutTable");
	for(var i=0;i<_multiLangConfig.length;i++){
		var tr =  jQuery("<tr>").addClass("multiLangTR");
		var _multiLangObj = _multiLangConfig[i];
		var td1 = jQuery("<td>").addClass("fieldlang").css({
				"width":"24px",
				"padding-left":"5px",
				"background-color":"#fff"
			});
		td1.html(_multiLangObj.label);
		tr.append(td1);
		var td2 = jQuery("<td>").addClass("fieldlang").css({
				"padding-left":"5px",
				"background-color":"#fff",
				"width":"100%"
		});
		var _input = jQuery("<input>").attr("type","text").attr("name","_multiLang_"+_multiLangObj.name)
			.attr("id","_multiLang_"+_multiLangObj.languageId).attr("languageId",_multiLangObj.languageId).css({
				"width":"90%",
				"border-left":"none",
				"border-top":"none",
				"border-right":"none",
				"border-bottom":"1px solid #e9e9e2"
		}).addClass("InputStyle");
		
		
		if(_multiLangObj.languageId==7){
			_input.bind("change",function(){
			
				jQuery("#_multiLang_9",_multiLangEditBox).val(Traditionalized(jQuery(this).val()));
			});
		}else if(_multiLangObj.languageId==9){
			_input.bind("change",function(){
			
				if(jQuery("#_multiLang_7").val()){
					jQuery("#_multiLang_7",_multiLangEditBox).val(Simplized(jQuery(this).val()));
				}
			});
		}
		td2.append(_input);
		tr.append(td2);
		table.append(tr);
	}
	var tr3 =  jQuery("<tr>").addClass("intervalTR e8ToolBar");
	var td3 = jQuery("<td colspan=2>").css({
			"text-align":"center",
			"height":"30px",
			"line-height":"30px",
			"width":"100%",
			"background-color":"rgb(248,248,248)",
			"border-top":"1px solid rgb(225,225,225)"
	});
	var okBtn = jQuery("<input type='button' style='height:22px;line-height:12px; width:60px!important;' class='e8_btn_submit' value='确定'></input>").hover(function(){
		jQuery(this).addClass("e8_submit_btnHover");
	},function(){
		jQuery(this).removeClass("e8_submit_btnHover");
	}).bind("click",function(){
		if (_multiLangEditBox)
        _multiLangEditBox.css( {
            "display" : "none"
        });
		if (!_multiLangEditIsEdit) {
			return;
		}
		var inputs = _multiLangEditBox.find("input");
		var v = null;

		var langs= new Array();
		var flag=false;
		
		for(var i=0;i<_multiLangConfig.length;i++){

			var _multiLangObj = _multiLangConfig[i];

			langs[i]=_multiLangObj.languageId;

			if(_multiLangEditCurLang == langs[i]){
				continue;
			}
			if(_multiLangConfig.length>2){
				if(langs[i]!=9&&jQuery("#_multiLang_"+langs[i],_multiLangEditBox).val()!=""){
					flag=true;
					break;
				}
			}else{
				if(jQuery("#_multiLang_"+langs[i],_multiLangEditBox).val()!=""){
					flag=true;
					break;
				}
			}
		}
		
		if (flag)
		{
			v = LANG_CONTENT_PREFIX;
			var _multiLangObj;
			for(var i=0;i<_multiLangConfig.length-1;i++){
				_multiLangObj= _multiLangConfig[i];
				langs[i]=_multiLangObj.languageId;
				if(langs[i]<"10"){
					v = v + langs[i]+" "+jQuery("#_multiLang_"+langs[i],_multiLangEditBox).val()+LANG_CONTENT_SPLITTER1;
				}else{
					v = v + langs[i]+jQuery("#_multiLang_"+langs[i],_multiLangEditBox).val()+LANG_CONTENT_SPLITTER1;
				}
			}
			_multiLangObj = _multiLangConfig[_multiLangConfig.length-1];
			var temp = _multiLangObj.languageId;
			if(temp<"10"){
		
				v = v +temp+" "+jQuery("#_multiLang_"+temp,_multiLangEditBox).val()+LANG_CONTENT_SUFFIX;
			}else{
				v = v +temp+jQuery("#_multiLang_"+temp,_multiLangEditBox).val()+LANG_CONTENT_SUFFIX;
			}
		}
		else {

			v = jQuery("#_multiLang_"+_multiLangEditCurLang,_multiLangEditBox).val();	
		}
			
		var strs= new Array();
		var multiprename = "";
		strs = _multiLangEditObj.attr("name").split(".");
		if(strs.length>1){
			for (i=0;i<strs.length-1 ;i++ ) 
			{ 
				multiprename  = multiprename + strs[i]+"\\.";
			} 
				multiprename  = multiprename + strs[strs.length-1];
		}else{
			multiprename = _multiLangEditObj.attr("name");
		}
		jQuery("#__multilangpre_"+multiprename+_multiLangEditObj.attr("rnd_lang_tag")).attr("value",v);	
		
		_multiLangEditObj.attr("value", jQuery("#_multiLang_"+_multiLangEditCurLang,_multiLangEditBox).val());
		
		_multiLangEditObj.trigger("change");
		

		_multiLangEditIsEdit = false;	
	});
	var cancelBtn = jQuery("<input type='button' style='height:22px;line-height:12px;width:60px!important;' class='e8_btn_cancel' value='取消'></input>").hover(function(){
		jQuery(this).addClass("e8_btn_cancel_btnHover");
	},function(){
		jQuery(this).removeClass("e8_btn_cancel_btnHover");
	}).bind("click",function(){
			if (_multiLangEditBox)
				_multiLangEditBox.css( {
					"display" : "none"
				});
			_multiLangEditIsEdit = false;	
	});
	var sepLine = jQuery("<span>",{
		"class":"e8_sep_line"
	}).html("|");
	td3.append(okBtn).append(sepLine).append(cancelBtn);
	tr3.append(td3);
	table.append(tr3);
	return table;
}
function registerMultiLanguageEvent(){
	jQuery("input").live("mouseover",function(e) {
    if(_multiLangEditIsEdit || _multiLangEditDisabled) return;
    var srcObject = null;
	if(jQuery.browser.msie){
		e = window.event;
		srcObject = e.srcElement;
	}else{
		srcObject = e.target;
	}
    if (_needShowMultilang(srcObject)) {

        var $this = jQuery(srcObject);
        _multiLangEditObj = $this;
        if (!_multiLangEditBox) {
            _multiLangEditBox = jQuery("<div>",{
				"id":"multilangeditbox",
				"css":{
					"position":"absolute",
					"z-index":"999",
					"background":"#fff",
					"display":"none",
					"left":0,
					"top":0,
					"overflow":"visible",
					"border":"solid 1px rgb(225,225,225)",
					"width":$this.width()+"px"
				}
			});

			jQuery(window).bind("resize",function(){
				if(_multiLangEditBox.css("display")!="none"){
					 var pos = _multiLangEditObj.offset();
					 _multiLangEditBox.css( {
					   "top" : pos.top + 23,
					   "left" : pos.left,
					   "width":$this.width()+"px"
				   });
				}
			});
			
			_multiLangEditBox.append(_getMultiLang(_multiLangEditBox,$this));
            _multiLangEditBox.appendTo(jQuery("body"));
            
            _multiLangEditBox.bind("mouseover", function(e) {
				if(window.event){
					window.event.cancelBubble = true;
					return false;
				}else{
					e.stopPropagation();
				}
            });
            _multiLangEditBox.bind("mouseout", function(e) {
                if(window.event){
					window.event.cancelBubble = true;
					return false;
				}else{
					e.stopPropagation();
				}
            });
            _multiLangEditBox.bind("click", function(e) {
                if(window.event){
					window.event.cancelBubble = true;
					return false;
				}else{
					e.stopPropagation();
				}
            });
        }

		if(_multiLangEditHandler){
			var name = _multiLangEditObj.attr("name");
			var hasCN = jQuery(_multiLangEditObj).next("input[name='"+name+"']").val();
			var hasSet = jQuery(_multiLangEditObj).next("input[name='"+LANG_INPUT_PREFIX+name+"']").val();
			if(!hasSet){
				hasSet = jQuery("input[name='"+LANG_INPUT_PREFIX+name+"']",_multiLangEditBox).val();
			}
			var title = "未设置多语言";
			var imageurl="/images/ecology8/multiNoSet_wev8.png";
			if(hasSet&&hasSet!=""&&hasCN!=hasSet){
				imageurl="/images/ecology8/MultiSet_wev8.png";
				title = "已设置多语言";
			}
			_multiLangEditHandler.css("background-image","url("+imageurl+")").attr("title",title);
		}

        if (!_multiLangEditHandler) {
            //_multiLangEditHandler = jQuery("<div id='multilangedithandler' style='position:absolute;z-index:999;background:#fff;display:none;left:0px;top:0px;width:20px;height:20px;border:solid 1px red'>M</div>");
			var name = _multiLangEditObj.attr("name");
			var hasCN = jQuery(_multiLangEditObj).next("input[name='"+name+"']").val();
			var hasSet = jQuery(_multiLangEditObj).next("input[name='"+LANG_INPUT_PREFIX+name+"']").val();
			if(!hasSet){
				hasSet = jQuery("input[name='"+LANG_INPUT_PREFIX+name+"']",_multiLangEditBox).val();
			}
			var title = "未设置多语言";
			var imageurl="/images/ecology8/multiNoSet_wev8.png";
			if(hasSet&&hasSet!=""&&hasCN!=hasSet){
				imageurl="/images/ecology8/MultiSet_wev8.png";
				title = "已设置多语言";
			}
			_multiLangEditHandler = jQuery("<div>",{
				id:"multilangedithandler",
				css:{
					"position":"absolute",
					"z-index":"999",
					"background-image":"url("+imageurl+")",
					"background-position":"50% 50%",
					"display":"none",
					"left":"0px",
					"top":"0px",
					"width":"18px",
					"border":"none",
					"height":"22px",
					"background-repeat":"no-repeat",
					"cursor":"pointer"
				},
				title:title
			});
            _multiLangEditHandler.appendTo(jQuery("body"));

            _multiLangEditHandler.bind("click", function(e) {
               var $self = jQuery(_multiLangEditObj);
				   if(!$self.attr("name")){
				   		$self.attr("name",$self.attr("id"));
				   }
               if(!$self.attr("name")) return;
               if(!$self.attr("rnd_lang_tag")){
               		$self.attr("rnd_lang_tag",__multiLangRand__());
               }
               var valueObj = document.getElementById(LANG_INPUT_PREFIX+$self.attr("name")+$self.attr("rnd_lang_tag"));
               if(!valueObj){
            	   var $valueObj = jQuery("<input id='"+LANG_INPUT_PREFIX+$self.attr("name")+$self.attr("rnd_lang_tag")+"' name='"+LANG_INPUT_PREFIX+$self.attr("name")+"' type=hidden style='display:none' value=''>").insertAfter($self);
               }else{
            	   var $valueObj = jQuery(valueObj);
               }
              
               var pos = $self.offset();
               _multiLangEditIsEdit = true;
                _multiLangEditHandler.css( {
                    "display" : "none"
                });
                _multiLangEditBox.css( {
                   "top" : pos.top + 23,
                   "left" : pos.left
               });
				
				 _multiLangEditBox.css( {
					"display" : "block"
				});
                				
                var inputs = _multiLangEditBox.find("input[type!='button']");
                inputs.attr("value","");
				 try{
						inputs.eq(0).attr("size", $self.attr("size"));
						inputs.eq(2).attr("size", $self.attr("size"));
					 }
				catch(e){}
                var v = $valueObj.attr("value");
                var curv = $self.attr("value");
                if (v && v.indexOf(LANG_CONTENT_PREFIX) != -1) {
                    var to = v.lastIndexOf(LANG_CONTENT_SUFFIX);
                    var langs = v.substring(4, to);
                    var langA = langs.split(LANG_CONTENT_SPLITTER1);
					for(var i=0;i<langA.length;i++){
							var id = langA[i].substring(0,2);
							jQuery("#_multiLang_"+id,_multiLangEditBox).val(langA[i].substring(2));
					}
					
					/*
                    if (langA[0]){
                        inputs.eq(0).attr("value",_multiLangEditCurLang=='7'?curv:langA[0].substring(2));
                    }else{
                        inputs.eq(0).attr("value",_multiLangEditCurLang=='7'?curv:"");
                    }
                    
                    if (langA[1]){
                        inputs.eq(1).attr("value",_multiLangEditCurLang=='8'?curv:langA[1].substring(2));
                    }else{
                        inputs.eq(1).attr("value",_multiLangEditCurLang=='8'?curv:"");
                    }
                    
                    if (langA[2]){
                        inputs.eq(2).attr("value",_multiLangEditCurLang=='9'?curv:langA[2].substring(2));
                    }else{
                        inputs.eq(2).attr("value",_multiLangEditCurLang=='9'?curv:"");
                    }
					*/
                    
                } else {
					if(_multiLangEditCurLang == '7'||_multiLangEditCurLang == '9'){
						jQuery("#_multiLang_"+_multiLangEditCurLang,_multiLangEditBox).val(curv);
						jQuery("#_multiLang_"+_multiLangEditCurLang,_multiLangEditBox).trigger("change");
		 			}else{
		      			jQuery("#_multiLang_"+_multiLangEditCurLang,_multiLangEditBox).val(curv);		 
		 		}               
                }
				if(window.event){
					window.event.cancelBubble = true;
					return false;
				}else{
					e.stopPropagation();
				}
            });
        }
        var pos = $this.offset();
        _multiLangEditHandler.css( {
            "top" : pos.top,
            "left" : pos.left + $this.width() - 20
        });
        _multiLangEditHandler.css( {
            "display" : "block"
        }).bind("mouseover",function(){
			window.clearTimeout(_multiLangEditTimeoutHandler);
		}).bind("mouseout",function(){
			 _multiLangEditHandler.css( {
                "display" : "none"
            });
		});
       /* _multiLangEditTimeoutHandler = window.setTimeout(function() {
            _multiLangEditHandler.css( {
                "display" : "none"
            });
        }, 1500);*/

		}
	}).live("mouseout",function(){
		if(_multiLangEditHandler){
			 _multiLangEditTimeoutHandler = window.setTimeout(function() {
				_multiLangEditHandler.css( {
					"display" : "none"
				});
			}, 1500);
		}
	});

	jQuery("body").live("click",function(e) {
		if (_multiLangEditBox)
			_multiLangEditBox.css( {
				"display" : "none"
			});
		 _multiLangEditIsEdit = false;
	});
}

registerMultiLanguageEvent();

function __multiLangRand__(){
 
  var text="";
  var possible="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
  for(var i=0;i<10;i++) text+=possible.charAt(Math.floor(Math.random()*possible.length));
  return text;
 
}