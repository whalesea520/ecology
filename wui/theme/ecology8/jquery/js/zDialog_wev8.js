
var IMAGESPATH = '/wui/theme/ecology8/skins/default/rightbox/'; //图片路径配置
//var IMAGESPATH = 'http://www.5-studio.com/wp-content/uploads/2009/11/'; //图片路径配置
/*************************一些公用方法和属性****************************/
var isInternetExplorer = navigator.userAgent.indexOf('MSIE') != -1;
var isIE6 = navigator.userAgent.indexOf('MSIE 6.0') != -1;
var isIE8 = !!window.XDomainRequest && !!document.documentMode;
var console=window.console;
if(isInternetExplorer)
	try{ document.execCommand('BackgroundImageCache',false,true); }catch(e){}

var $id = function (id) {
    return typeof id == "string" ? document.getElementById(id) : id;
};
//if (!$) var $ = $id;


//IE兼容性问题
String.prototype.trim = function () {
	return this.replace(/^\s+|\s+$/g,'');
};

Array.prototype.remove = function (s, dust) { //如果dust为ture，则返回被删除的元素
    if (dust) {
        var dustArr = [];
        for (var i = 0; i < this.length; i++) {
            if (s == this[i]) {
                dustArr.push(this.splice(i, 1)[0]);
            }
        }
        return dustArr;
    }
    for (var i = 0; i < this.length; i++) {
        if (s == this[i]) {
            this.splice(i, 1);
        }
    }
    return this;
}

var $topWindow = function () {
    var parentWin = window;
    var isCurrentPop=((typeof isCurrentPop)=="undefind")?false:true; //是否从当前窗口弹出
    if(!isCurrentPop){
	    while (parentWin != parentWin.parent) {
	        if (parentWin.parent.document.getElementsByTagName("FRAMESET").length > 0) break;
	        parentWin = parentWin.parent;
	    }
    }
    return parentWin;
};
var $bodyDimensions = function (win) {
    win = win || window;
    var doc = win.document;
    var cw = doc.compatMode == "BackCompat" ? doc.body.clientWidth : doc.documentElement.clientWidth;
    var ch = doc.compatMode == "BackCompat" ? doc.body.clientHeight : doc.documentElement.clientHeight;
    var sl = Math.max(doc.documentElement.scrollLeft, doc.body.scrollLeft);
    var st = Math.max(doc.documentElement.scrollTop, doc.body.scrollTop); //考虑滚动的情况
    var sw = Math.max(doc.documentElement.scrollWidth, doc.body.scrollWidth);
    var sh = Math.max(doc.documentElement.scrollHeight, doc.body.scrollHeight); //考虑滚动的情况
    var w = Math.max(sw, cw); //取scrollWidth和clientWidth中的最大值
    var h = Math.max(sh, ch); //IE下在页面内容很少时存在scrollHeight<clientHeight的情况
    return {
        "clientWidth": cw,
        "clientHeight": ch,
        "scrollLeft": sl,
        "scrollTop": st,
        "scrollWidth": sw,
        "scrollHeight": sh,
        "width": w,
        "height": h
    }
};

var fadeEffect = function(element, start, end, speed, callback){//透明度渐变：start:开始透明度 0-100；end:结束透明度 0-100；speed:速度1-100
	if(!element.effect)
		element.effect = {fade:0, move:0, size:0};
	clearInterval(element.effect.fade);
	var speed=speed||20;
	element.effect.fade = setInterval(function(){
		start = start < end ? Math.min(start + speed, end) : Math.max(start - speed, end);
		element.style.opacity =  start / 100;
		element.style.filter = "alpha(opacity=" + start + ")";
		if(start == end){
			clearInterval(element.effect.fade);
			if(callback)
				callback.call(element);
		}
	}, 20);
};

/*************************弹出框类实现****************************/
var topWin = $topWindow();
var topDoc = topWin.document;
var Dialog = function (currentwin) {
    /****以下属性以大写开始，可以在调用show()方法前设置值****/
    this.ID = null;
    this.Width = null;
    this.Height = null;
    this.URL = null;
	this.OnLoad=null;
    this.InnerHtml = ""
    this.InvokeElementId = ""
    this.Top = "50%";
    this.Left = "50%";
    this.Title = "";
    this.OKEvent = null; //点击确定后调用的方法
    this.CancelEvent = null; //点击取消及关闭后调用的方法
    this.ShowButtonRow = false;
    this.MessageIcon = "window_wev8.gif";
    this.MessageTitle = "";
    this.Message = "";
    this.ShowMessageRow = false;
    this.Modal = true;
    this.Drag = true;
    this.AutoClose = null;
    this.ShowCloseButton = true;
	this.Animator = true;
	this.PaddingAble = false;
	this.maxiumnable = false;//是否可以最大化窗口
	this.DefaultMax = false;//默认打开最大化
	this.checkDataChange = false;//关闭时是否需要检查数据是否更改
	this.isIframe = true;//dialog中tab页的结构是否为iframe结构,默认为iframe结构
	this.hideDraghandle = false;//是否隐藏拖拽区域，默认不隐藏
	this.opacity = -1;
	this.__e8shadowiframe__ = null;
    /****以下属性以小写开始，不要自行改变****/
    this.dialogDiv = null;
	this.bgDiv=null;
    this.parentWindow = null;
    this.innerFrame = null;
    this.innerWin = null;
    this.innerDoc = null;
    this.zindex = 90000;
    this.cancelButton = null;
    this.okButton = null;
    this.e8SepLine = null;
    this.okLabel = SystemEnv.getHtmlNoteName(3451);
    this.cancelLabel = SystemEnv.getHtmlNoteName(3516);
    this.textAlign = "center";
	this.custombtnjson = null;
	this.oriWidth = null;
	this.oriHeight = null;
	this.oriLeft = null;
	this.oriTop = null;
	this.maxState = false;
	this.browserConfig = null;
	this.dataChange = false;
	this.initData = null;
	this.finalData = null;
	this.normalDialog = true;
	//added by wcd 2015-10-21
	this._callBack = null;
	
    if (arguments.length > 0 && typeof(arguments[0]) == "string") { //兼容旧写法
        this.ID = arguments[0];
    } else if (arguments.length > 0 && typeof(arguments[0]) == "object") {
        Dialog.setOptions(this, arguments[0])
    }
	if(!this.ID)
        //this.ID = topWin.Dialog._Array.length + "";
        this.ID = new Date().getTime();
    
    this.currentWindow = currentwin;
    this.flashs = null;
    this.callbackfun = null;
    this.callbackfunParam = null;
    this.closeHandle = null;
    this.callbackfunc4CloseBtn = null;
    this.dialogtitleclass = "zDialogTitleTRClass";
};
Dialog._Array = [];
Dialog.bgDiv = null;
Dialog.setOptions = function (obj, optionsObj) {
    if (!optionsObj) return;
    for (var optionName in optionsObj) {
        obj[optionName] = optionsObj[optionName];
    }
};
Dialog.attachBehaviors = function () {
    if (isInternetExplorer) {
        document.attachEvent("onkeydown", Dialog.onKeyDown);
        window.attachEvent('onresize', Dialog.resetPosition);
    } else {
        document.addEventListener("keydown", Dialog.onKeyDown, false);
        window.addEventListener('resize', Dialog.resetPosition, false);
    }
};
Dialog.prototype.attachBehaviors = function () {
    if (this.Drag && topWin.Drag) topWin.Drag.init(topWin.$id("_Draghandle_" + this.ID), topWin.$id("_DialogDiv_" + this.ID)); //注册拖拽方法
    if (!isInternetExplorer && this.URL) { //非ie浏览器下在拖拽时用一个层遮住iframe，以免光标移入iframe失去拖拽响应
        var self = this;
        topWin.$id("_DialogDiv_" + this.ID).onDragStart = function () {
            topWin.$id("_Covering_" + self.ID).style.display = ""
        }
        topWin.$id("_DialogDiv_" + this.ID).onDragEnd = function () {
            topWin.$id("_Covering_" + self.ID).style.display = "none"
        }
    }
};
Dialog.prototype.displacePath = function () {
    if (this.URL.substr(0, 7) == "http://" || this.URL.substr(0, 1) == "/" || this.URL.substr(0, 11) == "javascript:") {
        return this.URL;
    } else {
        var thisPath = this.URL;
        var locationPath = window.location.href;
        locationPath = locationPath.substring(0, locationPath.lastIndexOf('/'));
        while (thisPath.indexOf('../') >= 0) {
            thisPath = thisPath.substring(3);
            locationPath = locationPath.substring(0, locationPath.lastIndexOf('/'));
        }
        return locationPath + '/' + thisPath;
    }
};
Dialog.prototype.setPosition = function () {
    var bd = $bodyDimensions(topWin);
    var thisTop = this.Top,
        thisLeft = this.Left,
		thisdialogDiv=this.getDialogDiv();
    if (typeof this.Top == "string" && this.Top.substring(this.Top.length - 1, this.Top.length) == "%") {
        var percentT = this.Top.substring(0, this.Top.length - 1) * 0.01;
        thisTop = bd.clientHeight * percentT - thisdialogDiv.offsetHeight * percentT + bd.scrollTop;
    }
    if (typeof this.Left == "string" && this.Left.substring(this.Left.length - 1, this.Left.length) == "%") {
        var percentL = this.Left.substring(0, this.Left.length - 1) * 0.01;
        thisLeft = bd.clientWidth * percentL - thisdialogDiv.scrollWidth * percentL + bd.scrollLeft;
    }
    thisdialogDiv.style.top = Math.round(thisTop) + "px";
    thisdialogDiv.style.left = Math.round(thisLeft) + "px";
};
Dialog.setBgDivSize = function () {
    var bd = $bodyDimensions(topWin);
	if(Dialog.bgDiv){
			if(isIE6){
				Dialog.bgDiv.style.height = bd.clientHeight + "px";
				Dialog.bgDiv.style.top=bd.scrollTop + "px";
				Dialog.bgDiv.childNodes[0].style.display = "none";//让div重渲染,修正IE6下尺寸bug
				Dialog.bgDiv.childNodes[0].style.display = "";
			}else{
				Dialog.bgDiv.style.height = bd.scrollHeight + "px";
			}
		}
};
Dialog.resetPosition = function () {
    Dialog.setBgDivSize();
    for (var i = 0, len = topWin.Dialog._Array.length; i < len; i++) {
        topWin.Dialog._Array[i].setPosition();
    }
};
Dialog.prototype.create = function () {
    var bd = $bodyDimensions(topWin);
    if (typeof(this.OKEvent)== "function") this.ShowButtonRow = true;
    if (!this.Width) this.Width = Math.round(bd.clientWidth * 4 / 10);
    if(this.Width<400 && this.normalDialog) this.Width = 400;
    if (!this.Height) this.Height = Math.round(this.Width / 2);
    if(this.Height<300 && this.normalDialog)this.Height = 300;
    if (this.MessageTitle || this.Message) this.ShowMessageRow = true;
    var DialogDivWidth = this.Width + 13 + 13;
    var DialogDivHeight = this.Height + 33 + 13 + (this.ShowButtonRow ? 40 : 0) + (this.ShowMessageRow ? 50 : 0);

    if (DialogDivWidth > bd.clientWidth) this.Width = Math.round(bd.clientWidth - 26);
    if (DialogDivHeight > bd.clientHeight) this.Height = Math.round(bd.clientHeight - 46 - (this.ShowButtonRow ? 40 : 0) - (this.ShowMessageRow ? 50 : 0));
    var html = '\
    <div id="_LoadDiv_'+this.ID+'" style="position:absolute;display:none;width: 100%;height: 100%;"></div>\
  <table id="_DialogTable_' + this.ID + '"  width="' + (this.Width + 26) + '" cellspacing="0" cellpadding="0"  style=" font-size:12px; line-height:1.4;">\
    <tr id="_Draghandle_' + this.ID + '" style="' + (this.Drag ? "cursor: move;" : "")+(this.hideDraghandle ? "display:none;" : "") + '" class="' + this.dialogtitleclass + '">\
      <td height="30px;" style="background-color:#4f81bd;"><div style="float: left;color:#fff;"><span style="width:10px;display:inline-block;"></span><span id="_Title_' + this.ID + '" style="font-size:13px;height:30px;line-height:30px;"> ' +  this.Title  + '</span></div>\
        <div onclick="Dialog.getInstance(\'' + this.ID + '\').cancelButton.onclick.apply(Dialog.getInstance(\'' + this.ID + '\').cancelButton,[]);" onmouseout="this.style.backgroundImage=\'url(/images/ecology8/16_close_wev8.png)\'" onmouseover="this.style.backgroundImage=\'url(/images/ecology8/16_close2_wev8.png)\'" style="font-family:Verdana!important;\
        				margin: 10px 8px 0; font-size:8px!important;position: relative; cursor: pointer; float: right; height: 16px; width: 16px;background-image: url(/images/ecology8/16_close_wev8.png);' + (this.ShowCloseButton ? "" : "display:none;") + '"></div>';
        if(this.maxiumnable){				
			html += '\
			<div id="_maxBtn_'+this.ID+'" onclick="Dialog.getInstance(\'' + this.ID + '\').maxOrRecoveryWindow(this);" onmouseout="Dialog.getInstance(\'' + this.ID + '\').mouseOut(this);" onmouseover="Dialog.getInstance(\'' + this.ID + '\').mouseOver(this);" style="font-family:Verdana!important;\
		margin: 10px 8px 0; font-size:8px!important;position: relative; cursor: pointer; float: right; height: 16px; width: 16px;background-image: url(/images/ecology8/max_wev8.png);' + (this.ShowCloseButton ? "" : "display:none;") + '"></div>';
		}
		html += '</td>\
    </tr>\
    <tr valign="top">\
      <td align="center" style="border:1px solid #BCBCBC;"><table width="100%" cellspacing="0" cellpadding="0" border="0" bgcolor="#ffffff">\
          <tr id="_MessageRow_' + this.ID + '" style="' + (this.ShowMessageRow ? "" : "display:none") + '">\
            <td valign="top" height="50"><table width="100%" cellspacing="0" cellpadding="0" border="0" id="_MessageTable_' + this.ID + '">\
                <tr>\
                  <td width="50" height="50" align="center"></td>\
                  <td align="left" style="line-height: 16px;"><div id="_MessageTitle_' + this.ID + '" style="font-weight:bold">' + this.MessageTitle + '</div>\
                    <div id="_Message_' + this.ID + '">' + this.Message + '</div></td>\
                </tr>\
              </table></td>\
          </tr>\
          <tr>\
            <td valign="top" align="center">\
            <div id="_Container_' + this.ID + '" style="position: relative; width: ' + (this.Width+24) + 'px; height: ' + this.Height + 'px;"';
            if(this.PaddingAble){
            	html+=' class="dialogPadding"';
            }
            html+='>\
                <div style="position: absolute; height: 100%; width: 100%; display: none; background-color:#fff; opacity: 0.5;" id="_Covering_' + this.ID + '">&nbsp;</div>\
	' + (function (obj) {
        if (obj.InnerHtml) return obj.InnerHtml;
        if (obj.URL) return '<iframe width="100%" height="100%" frameborder="0" style="border:none 0;overflow:hidden;" allowtransparency="true" id="_DialogFrame_' + obj.ID + '" src="' + obj.displacePath() + '"></iframe>';
        return "";
    })(this) + '\
              </div></td>\
          </tr>\
          <tr id="_ButtonRow_' + this.ID + '" style="' + (this.ShowButtonRow ? "" : "display:none") + '">\
            <td height="36"><div id="_DialogButtons_' + this.ID + '" style="border-top: 1px solid #DADEE5; padding: 8px 20px; text-align:'+this.textAlign+' ; background-color:#f6f6f6;">\
            	' + (this.custombtnjson != null ? '<input type="button" class="zd_btn_submit2" style="padding: 0px 18px 0px 18px;" value='+this.custombtnjson.name+' id="_CustomButtonOK_' + this.ID + '" onclick="customClickEvent(\'' + this.ID + '\');"/>'  : '') + '\
                <input type="button" class="zd_btn_submit" style="padding: 0px 18px 0px 18px;" value='+this.okLabel+' id="_ButtonOK_' + this.ID + '"/>\
                <span id="_e8SepLine_' + this.ID + '" class="e8_sep_line">|</span>\
                <input type="button" class="zd_btn_cancle" style="padding: 0px 18px 0px 18px;" value='+this.cancelLabel+' onclick="Dialog.getInstance(\'' + this.ID + '\').closeByHand();" id="_ButtonCancel_' + this.ID + '"/>\
              </div></td>\
          </tr>\
        </table></td>\
    </tr>\
  </table>\
</div>\
'
    var div = topWin.$id("_DialogDiv_" + this.ID);
    if (!div) {
        div = topDoc.createElement("div");
        div.id = "_DialogDiv_" + this.ID;
        try{
        topDoc.getElementsByTagName("BODY")[0].appendChild(div);
        }catch(e1){
            jQuery("body")[0].appendChild(div);
        }
        //jQuery(topDoc).append(div);
    }
    div.style.position = "absolute";
    div.style.left = "-9999px";
    div.style.top = "-9999px";
    div.innerHTML = html;
    if (this.InvokeElementId) {
    	var win = this.currentWindow || window;
        var element = win.$id(this.InvokeElementId);
        element.style.position = "";
        element.style.display = "";
        /*if (isInternetExplorer) {
            var fragment = topDoc.createElement("div");
            fragment.innerHTML = element.outerHTML;
            element.outerHTML = "";
            topWin.$id("_Covering_" + this.ID).parentNode.appendChild(fragment)
        } else {
        */
            topWin.$id("_Covering_" + this.ID).parentNode.appendChild(element)
        //}
    }
    this.parentWindow = window;
    if (this.URL) {
        if (topWin.$id("_DialogFrame_" + this.ID)) {
            this.innerFrame = topWin.$id("_DialogFrame_" + this.ID);
        };
        var self = this;
        innerFrameOnload = function () {
            try {
				self.innerWin = self.innerFrame.contentWindow;
				self.innerWin.parentDialog = self;
                self.innerDoc = self.innerWin.document;
                if (!self.Title && self.innerDoc && self.innerDoc.title) {
                    if (self.innerDoc.title) topWin.$id("_Title_" + self.ID).innerHTML = self.innerDoc.title;
                };
            } catch(e) {
                if (console && console.log) console.log("可能存在访问限制，不能获取到iframe中的对象。")
            }
            if (typeof(self.OnLoad)== "function")self.OnLoad();
        };
        if (this.innerFrame.attachEvent) {
            this.innerFrame.attachEvent("onload", innerFrameOnload);
        } else {
            this.innerFrame.onload = innerFrameOnload;
        };
    };
    topWin.$id("_DialogDiv_" + this.ID).dialogId = this.ID;
    topWin.$id("_DialogDiv_" + this.ID).dialogInstance = this;
    this.attachBehaviors();
    this.okButton = topWin.$id("_ButtonOK_" + this.ID);
    this.e8SepLine = topWin.$id("_e8SepLine_"+this.ID);
    this.cancelButton = topWin.$id("_ButtonCancel_" + this.ID);
	div=null;
};
Dialog.prototype.setSize = function (w, h) {
    if (w && +w > 20) {
        this.Width = +w;
        topWin.$id("_DialogTable_" + this.ID).width = this.Width + 26;
        topWin.$id("_Container_" + this.ID).style.width = this.Width + "px";
    }
    if (h && +h > 10) {
        this.Height = +h;
        topWin.$id("_Container_" + this.ID).style.height = this.Height + "px";
    }
    this.setPosition();
};

Dialog.prototype.setTitle = function (fnum, scount) {
   topWin.$id("_Title_" + this.ID).innerHTML = "批量导入：（"+fnum+"/"+scount+"）";
};

Dialog.prototype.setDlgTitle = function (titleName) {
   topWin.$id("_Title_" + this.ID).innerHTML =titleName;
};


Dialog.prototype.setLoadDiv = function () {
   $loadDiv = $("<div />");
   $loadDiv.attr("id","loadingdiv");
   $loadDivTop = $("<div />");
   $loadDivTop.css("display","block");
   $loadDivTop.css("z-index","99");
   $loadDivTop.css("position","absolute");
   $loadDivTop.css("width","100%");
   $loadDivTop.css("height","100%");
   $loadDivTop.css("text-align","center");

   $loadImg = $("<img />");
   $loadImg.attr("src","/rdeploy/crm/image/loading.gif");
   $loadImg.css("padding-top","211px");
   $loadImg.css("z-index","999");
   $loadDivTop.append($loadImg);
   
   $loadDivDown = $("<div />");
   $loadDivDown.css("display","block");
   $loadDivDown.css("z-index","94");
   $loadDivDown.css("position","absolute");
   $loadDivDown.css("width","100%");
   $loadDivDown.css("height","100%");
   $loadDivDown.css("opacity","0.1");
   $loadDivDown.css("background-color","rgb(51, 51, 51)");
   $loadDiv.append($loadDivTop).append($loadDivDown);
   console.log(topWin.$id("_DialogDiv_" + this.ID));
   topWin.$id("_LoadDiv_" + this.ID).innerHTML = $loadDiv.html();
};

Dialog.prototype.setLoadDivHide = function () {
   topWin.$id("_LoadDiv_" + this.ID).innerHTML = '';
};

Dialog.prototype.mouseOut = function(obj){
	if(this.maxState){//最大化状态
		jQuery(obj).css("background-image","url(/images/ecology8/recovery_wev8.png)");
	}else{
		jQuery(obj).css("background-image","url(/images/ecology8/max_wev8.png)");
	}
}

Dialog.prototype.mouseOver = function(obj){
	if(this.maxState){//最大化状态
		jQuery(obj).css("background-image","url(/images/ecology8/recovery2_wev8.png)");
	}else{
		jQuery(obj).css("background-image","url(/images/ecology8/max2_wev8.png)");
	}
}

//最大化或者还原窗口
Dialog.prototype.maxOrRecoveryWindow = function(obj){
	var a = jQuery("#_Container_"+this.ID);
	if(!this.maxState){
		if(!this.oriWidth){
			this.oriTop = a.closest("div#_DialogDiv_"+this.ID).offset().top;
			this.oriLeft = a.closest("div#_DialogDiv_"+this.ID).offset().left;
			this.oriWidth = a.closest("div#_DialogDiv_"+this.ID).width();
			this.oriHeight = a.closest("div#_DialogDiv_"+this.ID).height();
		}
		a.closest("div#_DialogDiv_"+this.ID).css("top",0);
		a.closest("div#_DialogDiv_"+this.ID).css("left",0);
		a.width(jQuery(window).width());
		if (!!this.dialogtitleclass) {
			a.height(jQuery(window).height() - $("#_Draghandle_" + this.ID).height());	
		} else {
			a.height(jQuery(window).height()-30);		
		}
		
		this.maxState = true;
		jQuery(obj).css("background-image","url(/images/ecology8/recovery_wev8.png)");
	}else{
		a.closest("div#_DialogDiv_"+this.ID).css("top",this.oriTop);
		a.closest("div#_DialogDiv_"+this.ID).css("left",this.oriLeft);
		a.width(this.oriWidth);
		a.height(this.oriHeight-30);
		this.maxState = false;
		jQuery(obj).css("background-image","url(/images/ecology8/max_wev8.png)");
	}
	try{
		//resizeDialog();
	}catch(e){}
}

Dialog.prototype.callback = function(datas,otherdatas){
	if(!this.browserConfig){
		//added by wcd 2015-10-21
		try{if(!!this._callBack) this._callBack(datas);}catch(e){if(window.console)console.log(e+"-->/wui/theme/ecology8/jquery/js/zDialog.js-->callback()");}
		if(window.console){
			console.log("浏览框配置信息为空！");
		}
		return false;
	}
	var _event = this.browserConfig._event;
	var _target = this.browserConfig._target;
	var linkUrl = this.browserConfig.linkUrl;
	var e8os = this.browserConfig.e8os;
	var isAdd = this.browserConfig.isAdd;
	var fieldid = this.browserConfig.fieldid;
	var isMustInput = this.browserConfig.isMustInput;
	var params = this.browserConfig.params;
	var userCallBack = this.browserConfig.options._callback;
	var name = this.browserConfig.options.name;
	var hasInput = this.browserConfig.options.hasInput;
	var wuiUtil = this.browserConfig.wuiUtil;
	var __callback = this.browserConfig.__callback;
	var _writeBackData = this.browserConfig._writeBackData;
	var idKey = this.browserConfig.options.idKey;
	var nameKey = this.browserConfig.options.nameKey;
	var isSingle = this.browserConfig.isSingle;
	var needHidden = this.browserConfig.options.needHidden;
	var __document = this.browserConfig.__document;
	if (datas){
		var ids = wuiUtil.getJsonValueByIndex(datas,0);
		if(idKey){
    		ids = datas[idKey];
    	}
    	if(!ids){
    		ids = "";
    	}else{
    		ids = ""+ids;
    	}
	    if (ids!= ""){
	    	try{
				//qc 204823 自定义浏览按钮，数据库中保存值（带空格，不带空格）
		    	//ids = ids.replace(/ /g,"");
		    	ids = ids.replace(/[\n\r]/g,"");
		    }catch(e){}
	    	try{
	    		ids = trim(ids);
	    	}catch(e){
	    		try{
	    			ids = ids.trim();
	    		}catch(e){}
	    	}
	    	var names = wuiUtil.getJsonValueByIndex(datas,1);
	    	if(nameKey){
	    		names = datas[nameKey];
	    	}
	    	try{
	    		if(datas.tag){
	    			ids = datas.id;
	    			names = datas.path;
	    		}
	    	}catch(e){}
	    	var idArr = ids.split(",");
	    	if(names){
	    		try{
	    			names = trim(names);
	    		}catch(e){
	    			names = names.trim();
	    		}
	    	}
	    	var nameArr = null;
	    	names = names.replace(/<\/a>(__|,)/g,"</a>~~WEAVERSplitFlag~~");//qc370946英文逗号问题
	    	if(!isSingle){
	    		if(names.indexOf("~~WEAVERSplitFlag~~")>-1){//300363，新的分隔符
					nameArr = names.split("~~WEAVERSplitFlag~~");
				}else{//300363，原来的分隔符
					nameArr = names.split(",");
				}
	    	}else{
	    		nameArr = names.split("~~WEAVERSplitFlag~~");
	    	}
			
			
	    	var showNames = "";
	    	for(var i=0;i<idArr.length;i++){
		    	var showname = "<a href='#"+idArr[i]+"' onclick='return false;'>"+nameArr[i]+"</a>";
		    	if(!!linkUrl&&linkUrl!="#"){
		    		if(linkUrl.toLowerCase().indexOf("javascript:")>-1){
		    			var pre = linkUrl.substring(0,linkUrl.indexOf("$"));
						var after = linkUrl.substring(linkUrl.lastIndexOf("$")+1,linkUrl.length);
						showname = "<a href='"+pre+idArr[i]+after+";' onclick='pointerXY(event);'>"+nameArr[i]+"</a>";
		    		}else{
		    			if(linkUrl.match(/#id#/)){
			    			var _linkUrl = linkUrl.replace(/#id#/g,idArr[i]);
			    			showname = "<a href=\""+_linkUrl+"\" target='_blank'>"+nameArr[i]+"</a>";
			    		}else{
			    			if(linkUrl.match(/=$/) || linkUrl.match(/#$/)){
			    				showname = "<a href=\""+linkUrl+idArr[i]+"\" target='_blank' >"+nameArr[i]+"</a>";
			    			}else{
			    				showname = "<a href=\""+linkUrl+"?id="+idArr[i]+"\" target='_blank' >"+nameArr[i]+"</a>";
			    			}
			    		}
		    		}	
		    	}
				showNames += showname;
			}
			var newData = {id:ids,name:showNames};
			var _window = this.currentWindow;
			if(!_window)_window = window;
			if(isAdd){
				_writeBackData(fieldid,isMustInput,newData,{hasInput:hasInput,isSingle:isSingle,replace:false});
			}else{
				if(e8os.length==0){
					e8os = jQuery("#"+fieldid,_window.document).closest("div.e8_os");
				}
				if(needHidden==false){
					if(__document){
						e8os = jQuery(__document.body);
					}else{
						e8os = jQuery(document.body);
					}
				}
				e8os.find("#"+fieldid+"span").html(showNames);
				e8os.find("#"+fieldid).val(ids);
				e8os.find("#"+fieldid+"spanimg").html("");
			}
		}
		else{
				var _window = this.currentWindow;
				if(!_window)_window = window;
				if(isAdd){
					_writeBackData(fieldid,isMustInput,datas,false,isSingle,false);
				}else{
					if(e8os.length==0){
						e8os = jQuery("#"+fieldid,_window.document).closest("div.e8_os");
					}
					if(needHidden==false){
						e8os = jQuery(document.body);
					}
					e8os.find("#"+fieldid+"span").html("");
					e8os.find("#"+fieldid).val("");
					if(isMustInput==2){
						e8os.find("#"+fieldid+"spanimg").html("<img align='absmiddle' src='/images/BacoError_wev8.gif'>");
					}
				}
		}
		if(!!userCallBack){
			try{
				userCallBack(_event,datas,fieldid,params,_target,otherdatas);
			}catch(e){
				if(window.console)console.log(e+"-->/wui/theme/ecology8/jquery/js/zDialog.js-->callback()");
			}
		}
		if(__callback){
			__callback(name,fieldid,isMustInput,hasInput,this.browserConfig.options);
		}
	}
	this.close();
};

Dialog.prototype.showShadowIframe = function(){
	this.__e8shadowiframe__="__e8shadowiframe__"+(parseInt(Math.random()*1000000000));
	//alert(this.__e8shadowiframe__);
	if(this.__e8shadowiframe__ && this.Modal){
		var __e8shadowiframe__ = jQuery("#"+this.__e8shadowiframe__);
		if(__e8shadowiframe__.length==0){
			__e8shadowiframe__ = jQuery("<iframe>",{
				id:this.__e8shadowiframe__,
				name:this.__e8shadowiframe__,
				frameborder:"0",
				css:{
					"position":"absolute",
					"left":0,
					"top":0,
					"z-index":2,
					"width":"100%",
					"height":"100%",
					"filter":"alpha(opacity=0)",
					"opacity":"0",
					"src":"#"
				}
			});
			jQuery(document.body).append(__e8shadowiframe__);
		}else{
			__e8shadowiframe__.css("display","block");
		}
	}
}

Dialog.prototype.hideShadowIframe = function(){
	if(this.__e8shadowiframe__){
		jQuery("#"+this.__e8shadowiframe__).remove();
	}
}

Dialog.prototype.show = function () {
    this.create();
    var bgdiv = Dialog.getBgdiv(),
	thisdialogDiv=this.getDialogDiv();
	this.showShadowIframe();
    this.zindex = thisdialogDiv.style.zIndex = parseInt(Dialog.bgDiv.style.zIndex) + 1;
    if (topWin.Dialog._Array.length > 0) {
        this.zindex = thisdialogDiv.style.zIndex = parseInt(topWin.Dialog._Array[topWin.Dialog._Array.length - 1].zindex) + 2;
    } else {
        var topWinBody = topDoc.getElementsByTagName(topDoc.compatMode == "BackCompat" ? "BODY" : "HTML")[0];
        topWinBody.styleOverflow = topWinBody.style.overflow;
        topWinBody.style.overflow = "hidden";
        bgdiv.style.display = "none";
    }
    topWin.Dialog._Array.push(this);
    if (this.Modal) {
        bgdiv.style.zIndex = parseInt(topWin.Dialog._Array[topWin.Dialog._Array.length - 1].zindex) - 1;
        Dialog.setBgDivSize();
		if(bgdiv.style.display == "none"){
			if(this.Animator){
				var bgMask=topWin.$id("_DialogBGMask");
				bgMask.style.opacity = 0;
				bgMask.style.filter = "alpha(opacity=0)";
        		bgdiv.style.display = "";
        		if(this.opacity!=-1){
        			fadeEffect(bgMask,this.opacity,this.opacity*100);
        		}else{
					fadeEffect(bgMask,0,40,isIE6?20:10);
        		}
				bgMask=null;
			}else{
        		bgdiv.style.display = "";
			}
		}
    }
    this.setPosition();
    if (this.CancelEvent) {
        this.cancelButton.onclick = this.CancelEvent;
        if(this.ShowButtonRow)this.cancelButton.focus();
    }
    if (this.OKEvent) {
        this.okButton.onclick = this.OKEvent;
        if(this.ShowButtonRow)this.okButton.focus();
    }
    if (this.AutoClose && this.AutoClose > 0) this.autoClose();
    this.opened = true;	bgdiv=null;
	
	//隐藏flash元素
	if (!!this.flashs && this.flashs.length > 0) {
		for (var z=0; z<this.flashs.length; z++) {
			jQuery(this.flashs[z]).hide();
		}
	}
	
	if(this.DefaultMax){
		jQuery("#_maxBtn_"+this.ID).trigger("click");
	}
	if(this.checkDataChange){
		//当指定的url加载好之后获取所有的input和select元素的初始值，用于当用户关闭dialog框时进行修改性判断
		this.getPageData(this,"initData",0);
	}
	setBtnHoverClass();
};

Dialog.prototype.getPageData = function($dialog,memkey,count){
	try{
		if(count>50){
			if(window.console){
				console.log("/wui/theme/ecology8/jquery/js/zDialog.js---超时退出...");
			}
			return;
		}
		var _document = document;
		if($dialog.isIframe){
			_document = jQuery($dialog.innerFrame.contentWindow.document).find("iframe.flowFrame:first").get(0).contentWindow.document;
		}else{
			_document = $dialog.innerFrame.contentWindow.document;
		}
		var elements = jQuery("input,select",_document);
		if(elements.length==0){
			throw "没有找到元素...";
		}
		var initData = "";
		elements.each(function(){
			var type = jQuery(this).attr("type");
			if(!type||type=="text"||type=="password"||type=="hidden"){
				initData+=","+jQuery(this).val();
			}
		});
		var textareas = jQuery("textarea",_document);
		textareas.each(function(){
			initData+=","+jQuery(this).val();
		});
		var checkboxs = jQuery(":checkbox",_document)
		checkboxs.each(function(){
			initData+=","+jQuery(this).attr("checked");
		});
		$dialog[memkey] = initData;
		if(window.console)
			console.log(initData);
	}catch(e){
		count++;
		window.setTimeout(function(){
			$dialog.getPageData($dialog,memkey,count);
		},1000);
	}
};



Dialog.prototype.closeManual = function(dialog){
	if(!dialog)dialog=this;
	var thisdialogDiv=dialog.getDialogDiv();
	try {
		if (!!this.callbackfunc4CloseBtn)
		{
			this.callbackfunc4CloseBtn();
		}
	} catch (e) {}
    if (dialog == topWin.Dialog._Array[topWin.Dialog._Array.length - 1]) {
        var isTopDialog = topWin.Dialog._Array.pop();
    } else {
        topWin.Dialog._Array.remove(dialog)
    }
    if (dialog.InvokeElementId) {
    	var win = dialog.currentWindow || window;
        var innerElement = win.$id(dialog.InvokeElementId);
        innerElement.style.display = "none";
        if (isInternetExplorer) {
            //ie下不能跨窗口拷贝元素，只能跨窗口拷贝html代码
            var fragment = document.createElement("div");
            fragment.innerHTML = innerElement.outerHTML;
            innerElement.outerHTML = "";
            document.getElementsByTagName("BODY")[0].appendChild(fragment)
        } else {
            document.getElementsByTagName("BODY")[0].appendChild(innerElement)
        }

    }
    //if(window.console && console.log)console.log(topWin.Dialog._Array);
    if (topWin.Dialog._Array.length > 0) {
        if (dialog.Modal && isTopDialog) Dialog.bgDiv.style.zIndex = parseInt(topWin.Dialog._Array[topWin.Dialog._Array.length - 1].zindex) - 1;
    } else {
        Dialog.getBgdiv().style.zIndex = "90000";
        Dialog.getBgdiv().style.display = "none";
        var topWinBody = topDoc.getElementsByTagName(topDoc.compatMode == "BackCompat" ? "BODY" : "HTML")[0];
        if (topWinBody.styleOverflow != undefined) topWinBody.style.overflow = topWinBody.styleOverflow;
    }
    if (isInternetExplorer) {
    	try{
			/*****释放引用，以便浏览器回收内存**/
			thisdialogDiv.dialogInstance=null;
			//if(this.innerFrame)this.innerFrame.detachEvent("onload", innerFrameOnload);
			dialog.innerFrame=null;
			dialog.parentWindow=null;
			dialog.bgDiv=null;
			if (dialog.CancelEvent){dialog.cancelButton.onclick = null;};
			if (dialog.OKEvent){dialog.okButton.onclick = null;};
			topWin.$id("_DialogDiv_" + dialog.ID).onDragStart=null;
			topWin.$id("_DialogDiv_" + dialog.ID).onDragEnd=null;
			topWin.$id("_Draghandle_" + dialog.ID).onmousedown=null;
			topWin.$id("_Draghandle_" + dialog.ID).root=null;
			/**end释放引用**/
	        thisdialogDiv.outerHTML = "";
			//CollectGarbage();
		}catch(e){
			if(window.console)console.log(e,"/wui/theme/ecology8/jquery/js/zDialog.js#closeManual()");
		}
    } else {
        var RycDiv = topWin.$id("_RycDiv");
        if (!RycDiv) {
            RycDiv = topDoc.createElement("div");
            RycDiv.id = "_RycDiv";
        }
        try{
        	RycDiv.appendChild(thisdialogDiv);
        }catch(e){
        	if(window.console)console.log(e,"zDialog.js#closeManaul()");
        }
        RycDiv.innerHTML = "";
		RycDiv=null;
    }
	thisdialogDiv=null; 
	//解决firefox下窗口无法关闭问题
	jQuery("#_DialogDiv_"+dialog.ID, window.top.document).remove();
    dialog.closed = true;
    
    //显示flash元素
	if (!!dialog.flashs && dialog.flashs.length > 0) {
		for (var z=0; z<dialog.flashs.length; z++) {
			jQuery(dialog.flashs[z]).show();
		}
	}
    dialog.maxState = false;
    this.hideShadowIframe();
};
/*
Dialog.prototype.close = function(){
	this.closeManual();
}
*/
Dialog.prototype.close = function(datas,otherdatas){
	try {
		if (!!this.callbackfun && !!datas) {
			this.callbackfun(this.callbackfunParam, datas,otherdatas);
		}
	} catch (e) {}
	
	try {
		//dialog关闭事件
		if (!!this.closeHandle) {
			this.closeHandle();
		}
	} catch (e) {}
	this.closeManual();
}

Dialog.prototype.closeByHand = function () {
	var $dialog = this;
	if(this.checkDataChange){
		this.getPageData(this,"finalData",0);
		if(this.finalData && this.initData && this.finalData!=this.initData){
			this.dataChange = true;
		}else{
			this.dataChange = false;
		}
	}
	if(this.dataChange){//第一版暂时取消该提示
		top.Dialog.confirm(SystemEnv.getHtmlNoteName(3570),function(){
			$dialog.dataChange = false;
			try {
				//dialog关闭事件
				if (!!this.closeHandle) {
					this.closeHandle();
				}
			} catch (e) {}
			$dialog.closeManual($dialog);
		},function(){
			return false;
		});
	}else{
		try {
			//dialog关闭事件
			if (!!this.closeHandle) {
				this.closeHandle();
			}
		} catch (e) {}
		this.closeManual();
	}
};


Dialog.prototype.autoClose = function () {
    if (this.closed) {
        clearTimeout(this._closeTimeoutId);
        return;
    }
    this.AutoClose -= 1;
    //topWin.$id("_Title_" + this.ID).innerHTML = this.AutoClose + " 秒后自动关闭";
    if (this.AutoClose <= 0) {
        this.close();
    } else {
        var self = this;
        this._closeTimeoutId = setTimeout(function () {
            self.autoClose();
        },
        1000);
    }
};
Dialog.getInstance = function (id) {
    var dialogDiv = topWin.$id("_DialogDiv_" + id);
    if (!dialogDiv){ 
    	if(window.console)
    	console.log("/wui/theme/ecology8/jquery/js/zDialog.js-->getInstance-->没有取到对应ID的弹出框页面对象");
    }
	try{
    	return dialogDiv.dialogInstance;
	}finally{
		dialogDiv = null;
	}
};
Dialog.prototype.addButton = function (id, txt, func) {
    topWin.$id("_ButtonRow_" + this.ID).style.display = "";
    this.ShowButtonRow = true;
    var button = topDoc.createElement("input");
    button.id = "_Button_" + this.ID + "_" + id;
    button.type = "button";
    button.style.cssText = "margin-right:5px";
    button.value = txt;
    button.onclick = func;
    var input0 = topWin.$id("_DialogButtons_" + this.ID).getElementsByTagName("INPUT")[0];
    input0.parentNode.insertBefore(button, input0);
    return button;
};
Dialog.prototype.removeButton = function (btn) {
    var input0 = topWin.$id("_DialogButtons_" + this.ID).getElementsByTagName("INPUT")[0];
    input0.parentNode.removeChild(btn);
};
Dialog.getBgdiv = function () {
    if (Dialog.bgDiv) {
    	jQuery(Dialog.bgDiv).unbind("contextmenu").bind("contextmenu",function(e){
    		e.preventDefault();
    		e.stopPropagation();
    		return false;
    	});
    	return Dialog.bgDiv;
    }
    var bgdiv = topWin.$id("_DialogBGDiv");
    if (!bgdiv) {
        bgdiv = topDoc.createElement("div");
        bgdiv.id = "_DialogBGDiv";
        bgdiv.style.cssText = "position:absolute;left:0px;top:0px;width:100%;height:100%;z-index:1001";
        var bgIframeBox = '<div style="position:relative;width:100%;height:100%;">';
		var bgIframeMask = '<div id="_DialogBGMask" style="position:absolute;background-color:#333;opacity:0.4;filter:alpha(opacity=40);width:100%;height:100%;"></div>';
		var bgIframe = isIE6?'<iframe src="about:blank" style="filter:alpha(opacity=0);" width="100%" height="100%"></iframe>':'';
		bgdiv.innerHTML=bgIframeBox+bgIframeMask+bgIframe+'</div>';
        try{
        topDoc.getElementsByTagName("BODY")[0].appendChild(bgdiv);
        }catch(e1){
            jQuery("body")[0].appendChild(bgdiv);
        }
        if (isIE6) {
            var bgIframeDoc = bgdiv.getElementsByTagName("IFRAME")[0].contentWindow.document;
            bgIframeDoc.open();
            bgIframeDoc.write("<body style='background-color:#333' oncontextmenu='return false;'></body>");
            bgIframeDoc.close();
			bgIframeDoc=null;
        }
    }
    Dialog.bgDiv = bgdiv;
    jQuery(Dialog.bgDiv).unbind("contextmenu").bind("contextmenu",function(e){
   		e.preventDefault();
   		e.stopPropagation();
   		return false;
   	});
	bgdiv=null;
    return Dialog.bgDiv;
};
Dialog.prototype.getDialogDiv = function () {
	var dialogDiv=topWin.$id("_DialogDiv_" + this.ID)
	if(!dialogDiv){
		if(window.console)
			console.log("获取弹出层页面对象出错！");
	}
	try{
		return dialogDiv;
	}finally{
		dialogDiv = null;
	}
};

Dialog.prototype.getContainer = function(){
	var container = topWin.$id("_Container_"+this.ID);
	return container;
}

Dialog.onKeyDown = function (event) {
    if (event.shiftKey && event.keyCode == 9) { //shift键
        if (topWin.Dialog._Array.length > 0) {
            stopEvent(event);
            return false;
        }
    }
    if (event.keyCode == 27) { //ESC键
        Dialog.close();
    }
};
Dialog.close = function (id) {
    if (topWin.Dialog._Array.length > 0) {
        var diag = topWin.Dialog._Array[topWin.Dialog._Array.length - 1];
        diag.cancelButton.onclick.apply(diag.cancelButton, []);
    }
};
Dialog.alert = function (msg, func, w, h,m,_options) {
    var w = w || 300,
        h = h || 80,
        m=m==false?false:true;
    var options = jQuery.extend({
    	isIframe:false,
    	_window:window,
		_autoClose:null  //自动关闭的时间
    },_options);
	var diag =null;
    if(window.top.Dialog&&!options.isIframe){
    	diag=new window.top.Dialog({
	        Width: w,
	        Height: h,
	        normalDialog:false,
	        Modal:m
	    });
    }else{
    	diag=new Dialog({
	        Width: w,
	        Height: h,
	        normalDialog:false,
	        Modal:m
	    });
    }
	if(options._autoClose && options._autoClose > 0){  //自动关闭
		diag.AutoClose = options._autoClose;
	}
    diag.ShowButtonRow = true;
    diag.Title = SystemEnv.getHtmlNoteName(3571);
    diag.Modal = m;
    diag.CancelEvent = function () {
        diag.close();
        if (func) func();
    };
    if(options.isIframe){
    	diag.URL="/systeminfo/alert.jsp?id="+this.ID;
    }else{
	    diag.InnerHtml = '<table height="100%" border="0" align="center" cellpadding="10" cellspacing="0">\
			<tr><td align="right"><img id="Icon_' + this.ID + '" src="' + IMAGESPATH + 'icon_alert_wev8.png" style="margin-right:10px;" width="26" height="26" align="absmiddle"></td>\
				<td align="left" id="Message_' + this.ID + '" style="font-size:9pt">' + msg + '</td></tr>\
		</table>';
	}
    diag.show();
    diag.getDialogDiv().style.zIndex = 99999;
   	//jQuery(diag.getDialogDiv()).css({"overflow-y":"auto","overflow-x":"hidden"});
   	
    //diag.okButton.parentNode.style.textAlign = "right";
    jQuery(diag.getContainer()).css("overflow-y","auto");
    diag.okButton.style.display = "none";
    diag.e8SepLine.style.display = "none";
    diag.cancelButton.value = SystemEnv.getHtmlNoteName(3451);
    diag.cancelButton.focus();
    jQuery("#"+diag.cancelButton.id).removeClass("btn").addClass("btn_submit");
};
Dialog.confirm = function (msg, funcOK, funcCal, w, h,m, custombtnjson, btnoklabel, btncancellabel, win, flashs) {
    var w = w || 300,
        h = h || 80,
        m=m==false?false:true;
    
    var diag = new Dialog({
        Width: w,
        Height: h,
        Modal:m,
        PaddingAble:true,
        normalDialog:false,
        custombtnjson:custombtnjson
    });
    
    if (!!btnoklabel) {
    	diag.okLabel = btnoklabel;
    }
    
    if (!!btncancellabel) {
    	diag.cancelLabel = btncancellabel;
    }
    
    if (!!win) {
    	diag.currentWindow = win;
    }
    if (!!flashs) {
    	diag.flashs = flashs;
    }
    
    diag.ShowButtonRow = true;
    diag.Title = SystemEnv.getHtmlNoteName(3572);
    diag.Modal = m;
    diag.CancelEvent = function () {
        diag.close();
        if (funcCal) {
            funcCal();
        }
    };
    
    diag.OKEvent = function () {
        diag.close();
        if (funcOK) {
            funcOK();
        }
    };
    
    diag.InnerHtml = '<table height="100%" border="0" align="center" cellpadding="10" cellspacing="0">\
		<tr><td align="right"><img id="Icon_' + this.ID + '" src="' + IMAGESPATH + 'icon_query_wev8.png" style="margin-right:10px;" width="26" height="26" align="absmiddle"></td>\
			<td align="left" id="Message_' + this.ID + '" style="font-size:9pt">' + msg + '</td></tr>\
	</table>';
    diag.show();
    diag.okButton.parentNode.style.textAlign = "center";
    //jQuery(diag.getDialogDiv()).css({"overflow-y":"auto","overflow-x":"hidden"});
    jQuery(diag.getContainer()).css("overflow-y","auto");
    diag.okButton.focus();
};
Dialog.open = function (arg) {
    var diag = new Dialog(arg);
    diag.show();
    return diag;
};

if (isInternetExplorer) {
    window.attachEvent("onload", Dialog.attachBehaviors);
} else {
    window.addEventListener("load", Dialog.attachBehaviors, false);
}

function getDialog(win){
	var allFrame = document.getElementsByTagName("iframe");
    for(var i=0;i<allFrame.length;i++){
    	var tempFrame = allFrame[i];
    	if (!!tempFrame && tempFrame.contentWindow == win) {
    		var tempIds = allFrame[i].id.split("_");
    		if (tempIds.length > 0) {
    			return Dialog.getInstance(tempIds[tempIds.length - 1]);
    		}
    	}
	}
	return null;
}


function setBtnHoverClass(){
	jQuery(".zd_btn_submit").hover(function(){
		jQuery(this).addClass("zd_btn_submit_hover");
	},function(){
		jQuery(this).removeClass("zd_btn_submit_hover");
	});
	
	jQuery(".zd_btn_submit2").hover(function(){
		jQuery(this).addClass("zd_btn_submit2_hover");
	},function(){
		jQuery(this).removeClass("zd_btn_submit2_hover");
	});
	
	jQuery(".zd_btn_cancle").hover(function(){
		jQuery(this).addClass("zd_btn_cancleHover");
	},function(){
		jQuery(this).removeClass("zd_btn_cancleHover");
	});

	
	jQuery(".zd_btn_submit,.zd_btn_submit2,.zd_btn_cancle")
	.live("mousedown", function () {
		jQuery(this).addClass("e8_btn_mousedown");
	}).live("mouseup", function () {
		jQuery(this).removeClass("e8_btn_mousedown");
	});
}


jQuery(document).ready(function(){
	setBtnHoverClass();	
});

function getParentWindow(win) {
	var dialogwin = getDialog(win);
	if (!!dialogwin) {
		return dialogwin.currentWindow;
	}
	return null;
}

function customClickEvent(dialogid) {
	var cceDialog = Dialog.getInstance(dialogid);
	cceDialog.custombtnjson.click();
	Dialog.getInstance(dialogid).close();
}

/*合并--->/wui/theme/ecology8/jquery/js/zDrag.js*/

var Drag={
    "obj":null,
	"init":function(handle, dragBody, e){
		if (e == null) {
			handle.onmousedown=Drag.start;
		}
		handle.root = dragBody;

		if(isNaN(parseInt(handle.root.style.left)))handle.root.style.left="0px";
		if(isNaN(parseInt(handle.root.style.top)))handle.root.style.top="0px";
		handle.root.onDragStart=new Function();
		handle.root.onDragEnd=new Function();
		handle.root.onDrag=new Function();
		if (e !=null) {
			var handle=Drag.obj=handle;
			e=Drag.fixe(e);
			var top=parseInt(handle.root.style.top);
			var left=parseInt(handle.root.style.left);
			handle.root.onDragStart(left,top,e.pageX,e.pageY);
			handle.lastMouseX=e.pageX;
			handle.lastMouseY=e.pageY;
			document.onmousemove=Drag.drag;
			document.onmouseup=Drag.end;
		}
	},
	"start":function(e){
		var handle=Drag.obj=this;
		e=Drag.fixEvent(e);
		var top=parseInt(handle.root.style.top);
		var left=parseInt(handle.root.style.left);
		//alert(left)
		handle.root.onDragStart(left,top,e.pageX,e.pageY);
		handle.lastMouseX=e.pageX;
		handle.lastMouseY=e.pageY;
		document.onmousemove=Drag.drag;
		document.onmouseup=Drag.end;
		return false;
	},
	"drag":function(e){
		e=Drag.fixEvent(e);
							
		var handle=Drag.obj;
		var mouseY=e.pageY;
		var mouseX=e.pageX;
		var top=parseInt(handle.root.style.top);
		var left=parseInt(handle.root.style.left);
		
		if(document.all){Drag.obj.setCapture();}else{e.preventDefault();};//作用是将所有鼠标事件捕获到handle对象，对于firefox，以用preventDefault来取消事件的默认动作：

		var currentLeft,currentTop;
		currentLeft=left+mouseX-handle.lastMouseX;
		currentTop=top+(mouseY-handle.lastMouseY);
		//if(currentLeft<0)currentLeft=0;
		var _dialogDiv = jQuery(handle).closest("div");
		if(currentLeft<0-_dialogDiv.width()+100){
			currentLeft = 0-_dialogDiv.width()+100;
		}
		if(currentTop<0)currentTop=0;
		if(currentLeft>jQuery(window).width()-100)currentLeft = jQuery(window).width()-100;
		if(currentTop>jQuery(window).height()-80)currentTop = jQuery(window).height()-80;
		handle.root.style.left=currentLeft +"px";
		handle.root.style.top=currentTop+"px";
		handle.lastMouseX=mouseX;
		handle.lastMouseY=mouseY;
		handle.root.onDrag(currentLeft,currentTop,e.pageX,e.pageY);
		return false;
	},
	"end":function(){
		if(document.all){Drag.obj.releaseCapture();};//取消所有鼠标事件捕获到handle对象
		document.onmousemove=null;
		document.onmouseup=null;
		Drag.obj.root.onDragEnd(parseInt(Drag.obj.root.style.left),parseInt(Drag.obj.root.style.top));
		Drag.obj=null;
	},
	"fixEvent":function(e){//格式化事件参数对象
		var sl = Math.max(document.documentElement.scrollLeft, document.body.scrollLeft);
		var st = Math.max(document.documentElement.scrollTop, document.body.scrollTop);
		if(typeof e=="undefined")e=window.event;
		if(typeof e.layerX=="undefined")e.layerX=e.offsetX;
		if(typeof e.layerY=="undefined")e.layerY=e.offsetY;
		if(typeof e.pageX == "undefined")e.pageX = e.clientX + sl - document.body.clientLeft;
		if(typeof e.pageY == "undefined")e.pageY = e.clientY + st - document.body.clientTop;
		return e;
	}
};

