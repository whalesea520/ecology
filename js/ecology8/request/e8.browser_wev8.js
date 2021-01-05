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
			id : null,
			addBtnClass:"e8_browserAdd",//新建按钮样式
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
			nameKey:null,
			idSplitFlag:null,
			nameSplitFlag:null,
			addBtnID:null,
			browserBtnID:null,
			addBtnLabel:null,
			language:7,
			browBtnDisabled:null,
			addBtnDisabled:null,
			hiddenNotAssign:0     //隐藏域是否不需要赋值, 1：不需要，   此参数会与needhidden结合使用 
		};
		var ROW_HEIGHT = 22;
		var browserBox=jQuery(this);
		var browserBoxId = browserBox.attr("id");
		if(!browserBoxId){
			browserBoxId = "bb_"+parseInt(Math.random()*1000000000);
			browserBox.attr("id",browserBoxId);
		}
		var browser="";
		var input="";
		var addBrow="";
		var js="";
		var body="";
		options=jQuery.extend(defaultOptions, options);
		var 	id		= options.id;
		if(!id){
			id = options.name;
		}
		var nameAndId=options.name;
		var inputID = id;
		if(options.index!=null){
			nameAndId+="_"+options.index;
			inputID += "_"+options.index;
		}
		
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
		var     hiddenNotAssign = options.hiddenNotAssign;
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
		var 	addBtnClass = options.addBtnClass;
		var addBtnLabel = options.addBtnLabel;
		var browserBtnID = options.browserBtnID;
		var addBtnID = options.addBtnID;
		var language = options.language;
		var idSplitFlag = options.idSplitFlag;
		var nameSplitFlag = options.nameSplitFlag
		var addBtnDisabled = options.addBtnDisabled;
		var browBtnDisabled = options.browBtnDisabled;
		if(!viewType){
			viewType = "0";
		}
		
		if(!language){
			language = "7";
		}
		
		if(!addBtnClass){
			addBtnClass = "e8_browserAdd";
		}
		
		if(!addBtnLabel){
			try{
				addBtnLabel = SystemEnv.getHtmlNoteName(3419,readCookie("languageidweaver"));
			}catch(e){
				addBtnLabel = "新建";
			}
		}
		if(!addBtnID){
			addBtnID = inputID+"_addbtn";
		}
		if(!browserBtnID){
			browserBtnID = inputID+"_browserbtn";
		}
		
		if(browserValue=="0" && !browserSpanValue){
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
		
		var sb = "{";
		sb +="browserBoxId:\'"+browserBoxId+"\'";
		if(!!beforeDelCallback){
			sb+=",beforeDelCallback:"+beforeDelCallback;
			if(!!beforeDelParams){
				sb+=",beforeDelParams:\'"+beforeDelParams+"\'";
			}
		}
		if(!!afterDelCallback){
			sb+=",afterDelCallback:"+afterDelCallback;
			if(!!afterDelParams){
				sb+=",afterDelParams:\'"+ afterDelParams+"\'";
			}
		}
		sb+="}"
		
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
		
		extraParams = json;//window.stringify(json);
		
		if(!linkUrl){
			linkUrl = "#";
		}
		if(!browserOnClick){
			var arguments = "";
			browserOnClick = "__browserNamespace__.showModalDialogForBrowser(event,'"+browserUrl+"','"+
					linkUrl+"','"+inputID+"',"+isSingle+","+isMustInput+",'"+_callbackParams+"'";
			browserOnClick += ",{name:'"+name+"',hasInput:"+hasInput+",zDialog:"+zDialog+",needHidden:"+needHidden+",dialogTitle:'"+options.tempTitle+"'";
			if(!!idKey){
				browserOnClick += ",idKey:'"+idKey+"'";
			}
			if(!!nameKey){
				browserOnClick += ",nameKey:'"+nameKey+"'";
			}
			if(!!getBrowserUrlFn){
				browserOnClick += ",getBrowserUrlFn:"+getBrowserUrlFn;
				if(!!getBrowserUrlFnParams){
					if(getBrowserUrlFnParams.indexOf("{")==0){
						browserOnClick += ",getBrowserUrlFnParams:"+getBrowserUrlFnParams;
					}else if(getBrowserUrlFnParams!="this"){
						browserOnClick += ",getBrowserUrlFnParams:'"+getBrowserUrlFnParams+"'";
					}else{
						browserOnClick += ",getBrowserUrlFnParams:"+getBrowserUrlFnParams;
					}
				}
			}
			if(!!browserDialogHeight){
				if(browserDialogHeight.toLowerCase().indexOf("px")==-1){
					browserDialogHeight = browserDialogHeight+"px";
				}
				arguments += "dialogHeight="+browserDialogHeight+";";
				browserOnClick += ",dialogHeight:'"+browserDialogHeight+"'";
			}
			if(!!browserDialogWidth){
				if(browserDialogWidth.toLowerCase().indexOf("px")==-1){
					browserDialogWidth = browserDialogWidth+"px";
				}
				arguments += "dialogWidth="+browserDialogWidth;
				browserOnClick += ",dialogWidth:'"+browserDialogWidth+"'";
			}
			if(!!arguments){
				browserOnClick += ",arguments:'"+arguments+"'";
			}
			if(!!_callback){
				browserOnClick +=",_callback:"+ _callback;
			}
			if(!!beforeDelCallback){
				browserOnClick+=",beforeDelCallback:"+beforeDelCallback;
				if(!!beforeDelParams){
					browserOnClick+=",beforeDelParams:\'"+beforeDelParams+"\'";
				}
			}
			if(!!afterDelCallback){
				browserOnClick+=",afterDelCallback:"+afterDelCallback;
				if(!!afterDelParams){
					browserOnClick+=",afterDelParams:\'"+ afterDelParams+"\'";
				}
			}
			browserOnClick+="})";
		}
		
		if(!addOnClick){
			addOnClick = "__browserNamespace__.showModalDialogForAdd(event,'"+addUrl+"','"+
			linkUrl+"','"+inputID+"',"+isSingle+","+isMustInput+",'"+_callbackForAddParams+"'";
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
		
		
		browser+="<div class='e8_os'";
		var hasStyle = false;
		var oriWidth = options.width;
		if(!!options.width){
			hasStyle = true;
			var width = options.width.toLowerCase();
			if(width.indexOf("px")==-1 && width.indexOf("%")==-1 && width.indexOf("auto")==-1){
				width = width+"px";
			}
			browser+=(" style='width:")+(width)+(";");
			if(width=="auto" || viewType=="1"){
				if(viewType=="1"){
					browser+=("min-width:120px;");
				}else{
					browser+=("min-width:210px;");
				}
			}
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
		
		/*buttons*/
		var buttons = "";
		if(hasBrowser==true||hasBrowser=="true"){
			if(isMustInput!="0"){
				if(isSingle=="false"||isSingle==false){
					buttons+="\n<div class='e8_innerShow e8_innerShow_button "+((hasAdd==true||hasAdd=="true")?"e8_innerShow_button_right50":"e8_innerShow_button_right30")+"' style='max-height:"+defaultRow*ROW_HEIGHT+"px;'"+">";
				}else{
					buttons+=("\n<div class='e8_innerShow e8_innerShow_button' style='max-height:"+100*ROW_HEIGHT+"px;'>");
				}
				buttons+="<span class='e8_spanFloat'>";
				buttons+="<span class='e8_browserSpan'><button class='e8_browflow'";
				if(browBtnDisabled){
					buttons+=(" disabled='disabled'");
				}
				buttons+=" type='button' id='"+browserBtnID+"' onclick=\""+browserOnClick+";";
				if(!zDialog){
					buttons+=("__callback('");
					buttons+=(name)+("','");
					buttons+=(inputID)+("',")+(isMustInput)+(",")+(hasInput)+(");");
				}
				buttons+=("\"></button></span>");
				if(!hasAdd||hasAdd!="true"){
					buttons+=("</span>");
				}
			}
		}
		
		
		
		if(hasAdd==true||hasAdd=="true"){
			buttons+="<span class='e8_browserSpan'><button ";
			if(addBtnDisabled){
					buttons+=(" disabled='disabled'");
				}
			buttons+=" class='"+addBtnClass+"' title='"+addBtnLabel+"' type='button' id='"+addBtnID+"' onclick=\""+addOnClick+";";
			if(!zDialog){
				buttons+=("__browserNamespace__.__callback('");
				buttons+=(name)+("','");
				buttons+=(inputID)+("',")+(isMustInput)+(",")+(hasInput)+(");");
			}
			buttons+=("\"></button></span></span>");
		}
		
		if((hasBrowser==true||hasBrowser=="true") && isMustInput!=0){
			buttons+=("</div>");
		}
		
		/*must input mark*/
		var mustMark = "";
		if(isMustInput!="0"){
			if(isSingle==false){
				mustMark+=("\n<div class='e8_innerShow e8_innerShowMust' style='max-height:")+(defaultRow*ROW_HEIGHT)+("px;'")+(">");
			}else{
				mustMark+=("\n<div class='e8_innerShow e8_innerShowMust'>");
			}
			mustMark+=("<span ");
			mustMark+=("name='")+(nameAndId)+("spanimg'  class='e8_spanFloat' id='")+(inputID)+("spanimg' ");
			mustMark+=(">");
			if(isMustInput=="2" && browserValue==""){
				mustMark+=("\n<img align='absmiddle' src='/images/BacoError_wev8.gif'>");
			}
			mustMark+=("</span></div>");
		}
		browser+=buttons;
		browser+=mustMark;
		
		/*content area*/
		var _margin = 0;
		if(isMustInput!="0"){
			_margin+=8;
		}
		if((hasBrowser==true||hasBrowser=="true") && isMustInput!="0"){
			_margin+=22;
		}
		if((hasAdd==true||hasAdd=="true") && isMustInput!="0"){
			_margin+=20;
		}
		browser+="<div class='e8_outScroll' id='out"+inputID+"div'";
		browser+=(" style='width:100%;margin-right:")+(_margin*-1)+("px;");
		browser+="'>";
		browser+="<div class='e8_innerShow e8_innerShowContent' id='innerContent"+inputID+"div'";
		if(options.isSingle==false||options.isSingle=="false"){
			browser+=" style='max-height:"+ROW_HEIGHT*options.defaultRow+"px;"
		}else{
			browser+=(" style='max-height:")+(100*ROW_HEIGHT)+("px;");
		}
		browser+=(" margin-right:")+(_margin)+("px;");
		browser+=" '>";
		browser+=("<div style='margin-left:")+(_margin+1)+("px;'")+(" id='inner")+(inputID)+("div'")+(" hasAdd=")+(hasAdd)+(" hasBrowser=")+(hasBrowser)+(">");
		
		if(options.hasBrowser==true){//显示浏览按钮
			if(needHidden!=false){
				browser+="<input type='hidden' value='"+browserValue+"' ";
				browser+=(" isSingle=")+(options.isSingle)+(" isMustInput=")+(isMustInput);
				browser+=" viewtype="+viewType+" onpropertychange=\""+onPropertyChange+"\" ";
				browser+=" temptitle='"+tempTitle+"' ";
				browser+="name='"+nameAndId+"' id='"+inputID+"' ";
				browser+="/>";
			}
			browser+="<span style='float:none;'";
			browser+="name='"+nameAndId+"span' id='"+inputID+"span' ";
			browser+=">";
			if(isMustInput=="2" && browserValue==""){
				//browser+=" <span class='e8_spanFloat'><img align='absmiddle' src='/images/BacoError_wev8.gif'></span>";
			}else{
				if(!!browserValue){
					var browserSpanValues = [];
					if(!nameSplitFlag){
						if(browserSpanValue.indexOf("__")!=-1){
							browserSpanValue = browserSpanValue.replace(/<\/a>(__|,)/g,"</a>~~weaversplit~~");
							browserSpanValues = browserSpanValue.split("~~weaversplit~~");
						}else if(browserSpanValue.indexOf("&nbsp;&nbsp;")!=-1){
							browserSpanValues = browserSpanValue.split("&nbsp;&nbsp;");
						}/*else if(browserSpanValue.indexOf("&nbsp;")!=-1){
							browserSpanValues = browserSpanValue.split("&nbsp;");
						}*/else if(browserSpanValue.match(/<\/a>(__|,)/)){
							browserSpanValue = browserSpanValue.replace(/<\/a>(__|,)/g,"</a>~~weaversplit~~");
							browserSpanValues = browserSpanValue.split("~~weaversplit~~");
						}
						
						if(browserSpanValues.length==0 && browserSpanValue.indexOf("__")!=-1){
							browserSpanValues = browserSpanValue.split("__");
						}
						if(browserSpanValues.length==0){
							browserSpanValues = browserSpanValue.split(",");
						}
					}else{
						browserSpanValues = browserSpanValue.split(nameSplitFlag);
					}
					var browserValues = [];
					if(idSplitFlag){
						 browserValues= browserValue.split(idSplitFlag);
					}else{
						if(browserValue.indexOf("__") >= 0){
							browserValues = browserValue.split("__");
						}else{
							 browserValues= browserValue.split(",");
						}
					}
					for(var i=0;i<browserSpanValues.length && i<browserValues.length;i++){
						browserSpanValue = browserSpanValues[i];
						var _browserValue = browserValues[i];
						var _linkUrl = linkUrl;
						var isclick = "";
						if(!!browserSpanValue){
							/*browser+="<span class='e8_showNameClass'>"+browserSpanValue+"<span id="
							+browserValue+" class='e8_delClass' onclick='del(event,this,"+isMustInput+","+needHidden+");'>&nbsp;x&nbsp;</span></span>";*/
							if(!browserSpanValue.match(/\s*a\s*\/\s*>/)){
								if(linkUrl.indexOf("#id#")!=-1||linkUrl.indexOf("$id$")!=-1){
									_linkUrl = linkUrl.replace(/[\$|#]id[\$|#]/g,browserValue);
								}else{
									if(linkUrl.match(/=$/) || linkUrl.match(/#$/)){
										_linkUrl += _browserValue;
										if(linkUrl.match(/#$/)){
											isclick = "onclick='return false;'";
										}
									}else{
										_linkUrl = _linkUrl + "?id="+_browserValue;
									}
								}
								browserSpanValue = "<a "+isclick+" href='"+_linkUrl+"'"+((linkUrl.toLowerCase().indexOf("javascript:")!=-1||linkUrl=="#")?"":" target=_blank")+">"+browserSpanValue+"</a>";
							}
							browser+=("<span class='e8_showNameClass "+((hasInput==true||hasInput=="true")?"'":"e8_showNameClassPadding'")+">")+(browserSpanValue);
							if((hasInput==true||hasInput=="true") && isMustInput && isMustInput!="0"){
								browser+=("<span id='")
								+(_browserValue)+("' class='e8_delClass' onclick=\"__browserNamespace__.del(event,this,")+(isMustInput)+(",")+(needHidden)+","+(sb)+(");\">x</span>");
							}
							if(completeUrl&&(completeUrl.indexOf("getajaxurl(256,")!=-1||completeUrl.indexOf("getajaxurl(257,")!=-1)&& isMustInput && isMustInput!="0"){
							     browser+=("<span id='")
								+(_browserValue)+("' class='e8_delClass' onclick=\"__browserNamespace__.del(event,this,")+(isMustInput)+(",")+(needHidden)+","+(sb)+(");\">x</span>");
							}
							browser+="</span>";
						}
					}
				}
			}
			browser+="</span>";
		}
		
		
		var inputNameAndId="";

		
		
		//输入框处理
		if((hasInput==true||hasInput=="true") && isMustInput!="0"){
			input+="<input onblur=\"__browserNamespace__.setAutocompleteOff(this);\" type= 'text' value='"+inputValue+"' issingle='"+isSingle+"' ";
			if(isSingle=="false"||isSingle==false){
				input+=("class='e8_browserInputMore' ");
			}else{
				input+=("class='e8_browserInput' ");
			}
			if(index!=null&&!index==("")){
				inputNameAndId+=(inputID)+("_")+(index)+("__");
			}else{
				inputNameAndId+=(inputID)+("__");
			}
			input+=("name='")+(inputNameAndId)+("' id='")+(inputNameAndId)+("' ");
			input+=(" onkeydown=\"__browserNamespace__.delByBS(event,'")+(inputNameAndId)+("',")+(isMustInput)+","+needHidden+","+(sb)+(");\" ");
			input+=(" onpropertychange='" + onPropertyChange + "' ");;
			input+="/>";
		}
		
		input+="</div>";
		input+="</div>";
		input+="</div>";
		input+="</div>";
		
		body+=browser+"\n"+input;
		browserBox.html(body);
		if(needHidden==false && hiddenNotAssign != 1){
			jQuery("#"+inputID).val(browserValue);
		}
		if((hasInput==true||hasInput=="true") && isMustInput!="0"){
			var _autoOptions = {};

			
			_autoOptions.nameAndId=inputID;
			_autoOptions.inputNameAndId=inputNameAndId;
			_autoOptions.isMustInput=isMustInput;
			_autoOptions.hasAdd=hasAdd;
			_autoOptions.isSingle=isSingle;
			_autoOptions.extraParams=extraParams;
			_autoOptions.row_height=ROW_HEIGHT;
			_autoOptions.linkUrl=linkUrl;
			_autoOptions.needHidden=needHidden;
			_autoOptions.sb=sb;
			_autoOptions.completeUrl=completeUrl;
			_autoOptions._callback=_callback;
			_autoOptions._callbackParams=_callbackParams;
			_autoOptions.type=type;
			_autoOptions.browserBox = browserBox;
			//format init data
			var _initOptions = {};
			_initOptions.nameAndId=inputID;
			_initOptions.name=name;
			_initOptions.isMustInput=isMustInput;
			_initOptions.hasInput=hasInput;
			_initOptions.browserBox = browserBox;
			window.setTimeout(function(){
				var _this = browserBox;
				if(isSingle=="false"||isSingle==false){
					//jQuery("#out"+nameAndId+"div").perfectScrollbar();
					browserBox.hover(function(){
						var innerInputDiv = _this.find("#input"+nameAndId+"div");
						if(!innerInputDiv.data("_perfect")){
							//_this.find("#out"+inputID+"div").perfectScrollbar();
							innerInputDiv.perfectScrollbar();
							innerInputDiv.data("_perfect",true);
						}
					},function(){});
				}
				browserBox.hover(function(){
						if(!_this.data("_autocomplete")){
							__browserNamespace__.hoverShowNameSpan(_this.find("span.e8_showNameClass"));
							__browserNamespace__.e8autocomplete(_autoOptions);
							__browserNamespace__.e8formatInitData(_initOptions);
							_this.data("_autocomplete",true);
						}
					},function(){});
				//__browserNamespace__.hoverShowNameSpan(".e8_showNameClass");
				//__browserNamespace__.e8autocomplete(_autoOptions);
			},500);
		}
		
		return js;
	}
})(jQuery);
