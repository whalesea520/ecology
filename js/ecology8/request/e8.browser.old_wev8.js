/**
* 浏览按钮 for ecology8
* created on 2013-11-11
*/
(function (jQuery) {
	jQuery.fn.e8Browser = function (options) {
		var defaultOptions={
			hasBrowser : true,//是否显示浏览按钮 
			browserUrl : null,//浏览按钮URL
			getBrowserUrlFn:null,//动态获取browserUrl的方法
			getBrowserUrlFnParams:null,//getBrowserUrlFn的参数
			browserOnClick : null,//浏览按钮的onclick事件js
			hasInput : null,//是否显示输入框
			isAutoComplete : false,//是否自动补齐
			autoComplete : null,//自动补齐查询URL
			hasAdd : false,//是否显示增加按钮
			addUrl : null,//自动增加按钮URL
			addOnClick : null,//自动增加按钮onclick事件js
			name : null,//浏览按钮名称
			isMustInput : "0",//是否必填
			browserValue : "",//浏览按钮value
			browserSpanValue : null,//浏览按钮显示value
			inputValue : "",//文本输入框的value
			onPropertyChange : "",//浏览按钮的onpropertychange属性
			viewType : null,//浏览按钮的viewtype属性
			tempTitle : "",//浏览按钮中文描述
			isSingle : null,//单选或者是多选
			linkUrl : null,//显示文字链接
			type : null,//字段类型
			index:null,
			completeUrl:null,
			linkUrl:null,
			width : "",//元素宽度
			extraParams:"",
			_callback:"",
			_callbackParams:"",
			_callbackForAdd:"",
			_callbackForAddParams:"",
			dialogHeight:"",
			dialogWidth:"",
			browserDialogHeight:"",
			browserDialogWidth:"",
			zDialog:true,
			beforeDelCallback:null,
			beforeDelParams:{},
			afterDelCallback:null,
			afterDelParams:{},
			needHidden:true,
			defaultRow:3,
			display:'',
			idKey:null,
			nameKey:null
			
		};
		var ROW_HEIGHT = 26;
		var browserBox=jQuery(this);
		var browser="";
		var input="";
		var addBrow="";
		var js="";
		var body="";
		options=jQuery.extend(defaultOptions, options);
		
		var nameAndId=options.name;
		if(options.index!=null){
			nameAndId+="_"+options.index;
		}
		var  e8browserIsHrm = function(type){
			if(type==4||type==17){
				return "javascript:openhrm($id$);";
			}
			return "";
		}
		
		browser+="<div class='e8_os'";
		var hasStyle = false;
		if(!!options.width){
			hasStyle = true;
			var width = options.width.toLowerCase();
			if(width.indexOf("px")==-1 && width.indexOf("%")==-1){
				width = width+"px";
			}
			browser+=(" style='width:")+(width)+(";");
		}
		if(!!options.display){
			if(hasStyle){
				browser+=("display:")+(display)+(";");
			}else{
				browser+=(" style='display:")+(display)+(";");
			}
			hasStyle = true;
		}
		if(hasStyle){
			browser+=("' ");
		}
		browser+=(">\n");
		browser+="<div class='e8_outScroll' id='out"+nameAndId+"div'";
		if(options.isSingle==false||options.isSingle=="false"){
			browser+=" style='max-height:"+ROW_HEIGHT*options.defaultRow+"px;'"
		}else{
			browser+=(" style='max-height:")+(ROW_HEIGHT)+("px;'");
		}
		browser+=">";
		browser+="<div style='width:100%;' class='e8_innerShow' id='inner"+nameAndId+"div'";
		if(!!options.width && !options.width.match(/%/)){
			options.width = options.width.toLowerCase();
			if(options.width.toLowerCase().indexOf("px")!=-1){
				options.width = options.width.replace(/px/, "");
			}
			browser+=" style='width:"+options.width+"'";
		}
		browser+=" >";
		
		
		var 	hasBrowser	 = options.	hasBrowser	;
		var 	browserUrl	 = options.	browserUrl	;
		var 	browserOnClick	 = options.	browserOnClick	;
		var 	hasInput	 = options.	hasInput	;
		var 	isAutoComplete	 = options.	isAutoComplete	;
		var 	autoComplete	 = options.	autoComplete	;
		var 	hasAdd	 = options.	hasAdd	;
		var 	addUrl	 = options.	addUrl	;
		var 	addOnClick	 = options.	addOnClick	;
		var 	name	 = options.	name	;
		var 	isMustInput	 = options.	isMustInput	;
		var 	browserValue	 = options.	browserValue	;
		var 	browserSpanValue	 = options.	browserSpanValue	;
		var 	inputValue	 = options.	inputValue	;
		var 	onPropertyChange	 = options.	onPropertyChange	;
		var 	viewType	 = options.	viewType	;
		var 	tempTitle	 = options.	tempTitle	;
		var 	isSingle	 = options.	isSingle	;
		var 	linkUrl	 = options.	linkUrl	;
		var 	type	 = options.	type	;
		var 	completeUrl	 = options.	completeUrl	;
		var 	linkUrl	 = options.	linkUrl	;
		var 	index	 = options.	index	;
		var 	width	 = options.	width	;
		var     extraParams = options.extraParams;
		var 	_callback = options._callback;
		var 	_callbackForAdd = options._callbackForAdd;
		var 	needHidden = options.needHidden;
		var		defaultRow = options.defaultRow;
		var		_callbackForAddParams = options._callbackForAddParams;
		var 	_callbackParams = options._callbackParams;
		var	    dialogHeight = options.dialogHeight;
		var 	dialogWidth = options.dialogWidth;
		var		browserDialogHeight = options.browserDialogHeight;
		var		browserDialogWidth = options.browserDialogWidth;
		var		zDialog = options.zDialog;
		var		beforeDelCallback = options.beforeDelCallback;
		var		beforeDelParams = options.beforeDelParams;
		var		afterDelCallback = options.afterDelCallback;
		var		afterDelParams = options.afterDelParams;
		var		getBrowserUrlFn = options.getBrowserUrlFn;
		var 	getBrowserUrlFnParams = options.getBrowserUrlFnParams;
		var		idKey = options.idKey;
		var		nameKey = options.nameKey;
		
		if(browserValue=="0"){
			browserValue="";
		}
		
		if(needHidden!=false){
			needHidden = true;
		}
		
		if(!defaultRow){
			defaultRow = 3;
		}
		
		if(!!!_callbackForAdd){
			_callbackForAdd = null;
		}
		
		if(hasInput==null){
			hasInput=e8browserHasInput(type);
		}
		
		if(isSingle==null){
			isSingle=e8browserIsSingle(type);
		}
		
		if(isSingle!=false){
			isSingle = true;
		}
		
		if(isMustInput!="0"&&isMustInput!="1"&&isMustInput!="2"){
			isMustInput = "0";
		}
		
		var sb = {};
		if(!beforeDelCallback){
			sb.beforeDelCallback = beforeDelCallback;
			if(!beforeDelParams){
				sb.beforeDelParams = beforeDelParams;
			}
		}
		
		if(!afterDelCallback){
			sb.afterDelCallback = afterDelCallback;
			if(!afterDelParams){
				sb.afterDelParams = afterDelParams;
			}
		}
		
		var json = {};
		if(!!extraParams){
			extraParams = extraParams.replace(/'/g,"\"");
			try{
				json = jQuery.parseJSON(b)
			}catch(e){
				json = {};
			}
		}
		json._exclude = "getNameAndIdVal";
		
		extraParams = window.stringify(json);
		
		if(!linkUrl){
			linkUrl = "#";
		}
		if(!browserOnClick){
			var arguments = "";
			browserOnClick = "showModalDialogForBrowser(event,'"+browserUrl+"','"+
					linkUrl+"','"+nameAndId+"',"+isSingle+","+isMustInput+",'"+_callbackParams+"'";
			browserOnClick += ",{name:'"+name+"',hasInput:"+hasInput+",zDialog:"+zDialog;
			if(!!idKey){
				browserOnClick += ",idKey:"+idKey;
			}
			if(!!nameKey){
				browserOnClick += ",nameKey:"+nameKey;
			}
			if(!!getBrowserUrlFn){
				browserOnClick += ",getBrowserUrlFn:"+getBrowserUrlFn;
				if(!!getBrowserUrlFnParams){
					browserOnClick += ",getBrowserUrlFnParams:"+getBrowserUrlFnParams;
				}
			}
			if(!!browserDialogHeight){
				if(browserDialogHeight.toLowerCase().indexOf("px")==-1){
					browserDialogHeight = browserDialogHeight+"px";
				}
				arguments += "dialogHeight="+browserDialogHeight+";";
				browserOnClick += ",dialogHeight:"+browserDialogHeight;
			}
			if(!!browserDialogWidth){
				if(browserDialogWidth.toLowerCase().indexOf("px")==-1){
					browserDialogWidth = browserDialogWidth+"px";
				}
				arguments += "dialogWidth="+browserDialogWidth;
				browserOnClick += ",dialogWidth:"+browserDialogWidth;
			}
			if(!!arguments){
				browserOnClick += ",arguments:'"+arguments+"'";
			}
			if(!!_callback){
				browserOnClick +=",_callback:"+ _callback;
			}
			browserOnClick+="})";
		}
		
		if(!addOnClick){
			addOnClick = "showModalDialogForAdd(event,'"+addUrl+"','"+
			linkUrl+"','"+nameAndId+"',"+isSingle+","+isMustInput+",'"+_callbackForAddParams+"'";
			var arguments = "";
			addOnClick += ",{name:'"+name+"',hasInput:"+hasInput+",zDialog:"+zDialog;
			if(!!idKey){
				addOnClick += ",idKey:"+idKey;
			}
			if(!!nameKey){
				addOnClick += ",nameKey:"+nameKey;
			}
			if(!!dialogHeight){
				if(dialogHeight.toLowerCase().indexOf("px")==-1){
					dialogHeight = dialogHeight+"px";
				}
				arguments += "dialogHeight="+dialogHeight+";";
				addOnClick += ",dialogHeight:"+dialogHeight;
			}
			if(!!dialogWidth){
				if(dialogWidth.toLowerCase().indexOf("px")==-1){
					dialogWidth = dialogWidth+"px";
				}
				arguments += "dialogWidth="+dialogWidth;
				addOnClick += ",dialogWidth:"+dialogWidth;
			}
			if(!!arguments){
				addOnClick += ",arguments:'"+arguments+"'";
			}
			if(!!_callbackForAdd){
				addOnClick +=",_callback:"+ _callbackForAdd;
			}
			addOnClick+="})";
		}

		
		if(options.hasBrowser==true){//显示浏览按钮
			if(needHidden!=false){
				browser+="<input type='hidden' value='"+browserValue+"' ";
				browser+=" viewtype="+viewType+" onpropertychange=\""+onPropertyChange+"\" ";
				browser+=" temptitle='"+tempTitle+"' ";
				browser+="name='"+nameAndId+"' id='"+nameAndId+"' ";
				browser+="/>";
			}
			browser+="<span ";
			browser+="name='"+nameAndId+"span' id='"+nameAndId+"span' ";
			browser+=">";
			if(isMustInput=="2" && browserValue==""){
				//browser+=" <span class='e8_spanFloat'><img align='absmiddle' src='/images/BacoError_wev8.gif'></span>";
			}else{
				if(!!browserValue){
					var browserSpanValues = browserSpanValue.split("__");
					var browserValues = browserValue.split(",");
					for(var i=0;i<browserSpanValues.length && i<browserValues.length;i++){
						browserSpanValue = browserSpanValues[i];
						browserValue = browserValues[i];
						var _linkUrl = linkUrl;
						if(!!browserSpanValue){
							/*browser+="<span class='e8_showNameClass'>"+browserSpanValue+"<span id="
							+browserValue+" class='e8_delClass' onclick='del(event,this,"+isMustInput+","+needHidden+");'>&nbsp;x&nbsp;</span></span>";*/
							if(!browserSpanValue.match(/\s*a\s*\/\s*>/)){
								if(linkUrl.indexOf("#id#")!=-1||linkUrl.indexOf("$id$")!=-1){
									_linkUrl = linkUrl.replace(/[\$|#]id[\$|#]/g,browserValue);
								}else{
									if(linkUrl.match(/=$/) || linkUrl.match(/#$/)){
										_linkUrl += browserValue;
									}else{
										_linkUrl = _linkUrl + "?id="+browserValue;
									}
								}
								browserSpanValue = "<a href='"+_linkUrl+"'"+((linkUrl.toLowerCase().indexOf("javascript:")||linkUrl=="#")?"":" target=_blank")+">"+browserSpanValue+"</a>";
							}
							browser+=("<span class='e8_showNameClass'>")+(browserSpanValue);
							if(hasInput==true){
								browser+=("<span id='")
								+(browserValue)+("' class='e8_delClass' onclick='del(event,this,")+(isMustInput)+(",")+(needHidden)+","+stringify(sb)+(");'>&nbsp;x&nbsp;</span>");
							}
							browser+="</span>";
						}
					}
				}
			}
			browser+="</span>";
		}
		
		if(isSingle=="false"||isSingle==false){
			js+="<script type='text/javascript'>\n\t";
			js+="\njQuery(document).ready(function(){\n\t\t";
			js+="jQuery('#out"+nameAndId+"div').perfectScrollbar();\n\t";
			js+="\n});";
			js+="<\/script>\n";
		}
		
		var inputNameAndId="";
		
		if(false && width.indexOf("%")>-1){
			js+="<script type='text/javascript'>\n\t";
			js+="function changeDivWidth"+(nameAndId)+("(){\n");
			width = width.replace(/\D/g,"");
			js+="\nvar outerWidth = jQuery('#out"+(nameAndId)+("div').closest('td').width();");
			js+="\nvar innerWidth=parseInt("+(width)+(")/100*outerWidth;");
			js+="\njQuery('#inner"+(nameAndId)+("div').width(innerWidth);");
			js+="\n}";
			js+="window.changeFunctions.push(changeDivWidth"+(nameAndId)+(");");
			js+="jQuery(document).ready(function(){\n\t\t";
			js+="changeDivWidth"+(nameAndId)+"();";
			js+="\n});\n<\/script>\n";
		}
		
		
		//输入框处理
		if(hasInput==true && isMustInput!="0"){
			js+="<script type='text/javascript'>\n\t";
			js+="jQuery(document).ready(function(){\n\t\t";
			input+="<input onblur=\"jQuery(this).hide();jQuery(this).val('');\" type= 'text' value='"+inputValue+"' issingle='"+isSingle+"' ";
			if(isSingle=="false"||isSingle==false){
				input+=("class='e8_browserInputMore' ");
			}else{
				input+=("class='e8_browserInput' ");
			}
			if(index!=null&&!index==("")){
				inputNameAndId+=(name)+("_")+(index)+("s");
			}else{
				inputNameAndId+=(name)+("__");
			}
			input+=("name='")+(inputNameAndId)+("' id='")+(inputNameAndId)+("' ");
			input+=(" onkeydown=\"delByBS(event,'")+(inputNameAndId)+("',")+(isMustInput)+","+needHidden+","+stringify(sb)+(");\" ");
			//js+="jQuery('#out"+(nameAndId)+("div').hover(function(){/*jQuery('#")+(inputNameAndId)+("').show();\njQuery('#")+(inputNameAndId)+("').focus();*/},function(){/*jQuery('#")+(inputNameAndId)+("').hide();*/});");
			js+="jQuery('#out"+(nameAndId)+("div').bind('click',function(){setInputPosition('#")+inputNameAndId+"','out"+nameAndId+"div','"+hasAdd+"');\njQuery('#"+(inputNameAndId)+("').show();\njQuery('#")+(inputNameAndId)+("').focus();});");
			js+=("\nvar _container = window;\nif(jQuery('.zDialog_div_content').length>0){_container='.zDialog_div_content';};\njQuery(_container).scroll(function(){setInputPosition('#")+(inputNameAndId)+("','out")+(nameAndId)+("div','")+(hasAdd)+("');});\n");
			js+="\njQuery('#"+(inputNameAndId)+("').autocomplete(\"");
			js+=(completeUrl)+("\",{\nselectFirst: false,\nautoFill:false,\ndataType:'json',");
			if(isSingle==false){
				js+="\nmultiple: true,\nmultipleSeparator:' ',";
			}
			if(!!extraParams){
				js += "\nextraParams:"+extraParams+",";
			}
			js+="\ndivID:'inner"+(nameAndId)+"div',";
			js+=("\nnameAndId:'")+(nameAndId)+("',");
			if(isSingle=="false"||isSingle==false){
				js+="\nfixHeight:"+ROW_HEIGHT+",";
			}
			js+="\nparse:function(data){\n";
			js+="return jQuery.map(data,function(row){\n";
			js+="return {data:row,\nvalue:row.id,\nresult:row.name}\n";
			js+="});\n},";
			js+="\nformatItem:function(row,i,max){\n";
			js+="return row.name;\n},";
			js+="\nformatResult:function(row){\n";
			js+="return [row.id,row.name];\n}\n";
			js+="});";
			js+="\n";
			js+="jQuery('#"+(inputNameAndId)+("').result(function(event,data,formatted){\n");
			js+="var showName = '';\n";
			js+=("\nvar maxWidth = getMaxWidth('#inner")+(nameAndId)+("div',")+(isSingle)+(");");
			if(!(e8browserIsHrm(type)=="")){
				linkUrl = e8browserIsHrm(type);
			}
			if(linkUrl.toLowerCase().indexOf("javascript:")>-1){
				var pre = linkUrl.substring(0,linkUrl.indexOf("$"));
				var after = linkUrl.substring(linkUrl.lastIndexOf("$")+1,linkUrl.length);
				js+="showName = \"<a style='max-width:\"+maxWidth+\"px;' href='"+(pre)+("\"+formatted+\"")+(after)+(";' onclick='pointerXY(event);'>\"+data.name+\"</a>\";\n");
			}else if(linkUrl=="" || linkUrl=="#"){
				js+="showName=\"<a style='max-width:\"+maxWidth+\"px;' href='#\"+data.id+\"' onclick='return false;'>\"+data.name+\"</a>\";\n";
			}else{
				if(linkUrl.match(/#id#/)){
					//var _linkUrl = linkUrl.replace(/#id#/g,data.id);
					js+="var _linkUrl=\""+linkUrl+"\";\n";
					js+="_linkUrl = _linkUrl.replace(/#id#/g,data.id);\n";
					js+="showName = \"<a style='max-width:\"+maxWidth+\"px;' href='\"+_linkUrl+\"' target='_blank'>\"+data.name+\"</a>\";\n";
				}else{
					if(linkUrl.match(/=$/)){
						js+="showName = \"<a style='max-width:\"+maxWidth+\"px;' href='"+(linkUrl)+("\"+formatted+\"")+("' target='_blank'>\"+data.name+\"</a>\";\n");
					}else{
						js+="showName = \"<a style='max-width:\"+maxWidth+\"px;' href='"+(linkUrl)+"?id="+("\"+formatted+\"")+("' target='_blank'>\"+data.name+\"</a>\";\n");
					}
				}
			}
			js+="var newSpan = \"<span class='e8_showNameClass'>\"+showName+"+("\"<span class='e8_delClass' id='\"+formatted+\"' ");
			js+="onclick='del(event,this,"+(isMustInput)+","+needHidden+","+stringify(sb)+(");'>&nbsp;x&nbsp;</span></span>\"\n");
			js+="var html = jQuery('#"+(nameAndId)+("span').html();\n");
			js+="jQuery('#"+(nameAndId)+("spanimg').html('');\n");
			js+="if(html==null || html.toLowerCase().indexOf('<img')>-1){\n";
			js+="html = '';\n}\n";
			if(isSingle=="false"||isSingle==false){
				js+="var hidden = jQuery('#"+(nameAndId)+("').val()\n");
				js+="if((','+hidden+',').indexOf(','+formatted+',')<0){\n";
				js+="jQuery('#"+(nameAndId)+("').val(hidden?(hidden+','+formatted):formatted);\n");
				js+="\njQuery('#"+(nameAndId)+("span').html(html+newSpan)");
				js+="}";
			}else{
				js+="jQuery('#"+(nameAndId)+("').val(formatted);\n");
				js+="jQuery('#"+(nameAndId)+("span').html(newSpan);");
				js+=(";\nsetInputWidth('#inner")+(nameAndId)+("div','#")+(inputNameAndId)+("','#")+(nameAndId)+("span');\n");
			}
			if(!!_callback){
				js += "_callback(e,data,'"+nameAndId+"');"
			}
			js+=("\nsetInputPosition('#")+(inputNameAndId)+("','out")+(nameAndId)+("div','")+(hasAdd)+("');\n");
			js+=("\njQuery('#")+("out")+(nameAndId)+("div'")+(").perfectScrollbar('update');\n");
			js+=("\nvar innerHeight = jQuery('#")+("inner")+(nameAndId)+("div'")+(").height();\n");
			js+=("\nvar scrollHeight = jQuery('#")+("out")+(nameAndId)+("div'")+(").height();\n");
			js+=("\njQuery('#")+("out")+(nameAndId)+("div'")+(").scrollTop(innerHeight-scrollHeight);\n");
			js+="\njQuery('#"+(inputNameAndId)+("').val('').show().focus();");
			js+="\n});";
			js+="\n});";
			js+="<\/script>";
			input+="/>";
		}
		
		if(isSingle==false||isSingle=="false"){
			browser+=("</div>");
			browser+=("</div>");
		}else{
			input+="</div>";
			input+="</div>";
		}
		
		var multiText="";//(isSingle==false||isSingle=="false")?("style='margin-top:"+(ROW_HEIGHT*defaultRow/2-11)+"px';"):"";
		if(hasBrowser==true||hasBrowser=="true"){
			if(isMustInput!="0"){
				if(isSingle=="false"||isSingle==false){
					input+="\n<div class='e8_innerShow e8_innerShow_button' style='max-height:"+defaultRow*ROW_HEIGHT+"px;'"+">";
				}else{
					input+=("\n<div class='e8_innerShow e8_innerShow_button'>");
				}
				input+="<span class='e8_spanFloat'>";
				input+="<button class='Browser e8_browflow'"+(multiText)+" type='button' onclick=\""+browserOnClick+";";
				if(!zDialog){
					input+=("__callback('");
					input+=(name)+("','");
					input+=(nameAndId)+("',")+(isMustInput)+(",")+(hasInput)+(");");
				}
				input+=("\"></button>");
				if(!hasAdd||hasAdd!="true"){
					input+=("</span>");
				}
			}
		}
		
		//format init data
		js+=("<script type='text/javascript'>\n\t");
		js+=("function formatInitData")+(nameAndId)+("(){\n");
		js+=("__callback('");
		js+=(name)+("','");
		js+=(nameAndId)+("',")+(isMustInput)+(",")+(hasInput)+(");\n");
		js+=("}");
		js+=("\njQuery(document).ready(function(){\n\t\t");
		js+=("\nvar span = jQuery('#")+(nameAndId)+("span');\n");
		js+=("if(span.width()<=0){\n");
		js+=("window.changeFunctions.push(formatInitData")+(nameAndId)+(");\n");
		js+=("}else{\n");
		js+=("formatInitData")+(nameAndId)+("()");
		js+=("\n}\n});");
		js+=("<\/script>");
		
		if(hasAdd==true||hasAdd=="true"){
			addBrow+="<button class='e8_browserAdd'"+(multiText)+" type='button' onclick=\""+addOnClick+";";
			if(!zDialog){
				addBrow+=("__callback('");
				addBrow+=(name)+("','");
				addBrow+=(nameAndId)+("',")+(isMustInput)+(",")+(hasInput)+(");");
			}
			addBrow+=("\"></button></span>");
		}
		addBrow+=("</div>");
		if(isMustInput!="0"){
			addBrow+=("</div>");
			if(isSingle==false){
				addBrow+=("\n<div class='e8_innerShow' style='max-height:")+(defaultRow*ROW_HEIGHT)+("px;'")+(">");
			}else{
				addBrow+=("\n<div class='e8_innerShow'>");
			}
			addBrow+=("<span ");
			addBrow+=("name='")+(nameAndId)+("spanimg'  class='e8_spanFloat' id='")+(nameAndId)+("spanimg' ");
			addBrow+=(">");
			if(isMustInput=="2" && browserValue==""){
				addBrow+=("\n<img align='absmiddle' src='/images/BacoError_wev8.gif'>");
			}
			addBrow+=("</span></div>");
		}
		body+=browser+"\n"+input+"\n"+addBrow;
		browserBox.html(body);
		//document.write(js);
		var divScript = jQuery("<div style='display:none'></div>");
		divScript.get(0).innerHTML = js;
		browserBox.append(divScript);
		console.log(divScript.get(0));
		return js;
	}
})(jQuery);
