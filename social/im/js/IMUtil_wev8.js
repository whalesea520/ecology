
//通用方法
var IMUtil = {
	//设定
	settings: {
		hrmurl: '/hrm/HrmTab.jsp?_fromURL=HrmResource&id=',
		TIMEOUT: 2147483647,
		WORDMAXLEN: 2000
	},
	//缓存
	cache: {
		isWindowFocus: 1,
		loadTimerId : null,
		//光标位置缓存
		cursorPos: 0
	},
	//支持
	support: {
		isIE: (typeof isIE == 'function') ? isIE() : !jQuery.support.style
	},
	//获取数据对象的长度
	getObjectLen: function(obj){
		var cnt = 0;
		if(typeof obj == 'object'){
			for(var i in obj){
				if(i != 'remove')
					cnt++;
			}
		}
		return cnt;
	},
	//空格过滤
	escSpace: function(str) {
		var reg = /&nbsp;/g;
		var reg_r = / /g;
		return str.replace(reg, ' ').replace(reg_r, '&nbsp;');
	},
	//去除&nbsp;
	cleanNbsp: function(content){
		return content.replace(/&nbsp;/ig, ' ');
	},
	//去除换行符
	cleanBR: function(content){
		return content.replace(/<br>/ig, '');
	},
	//给网址包装超链接
	httpHtml: function(str) {
		var htmlRegex = /<[^>]+>|&nbsp;|\s+|<br>|\n/g;//存在表情，要进行分段处理
		var strHtml = str.split(htmlRegex);
		var strHtmllength = strHtml.length;
		var strRegex =  "((https|http|ftp|rtsp|mms)?://)?"//前缀
					+"((([a-z0-9]([a-z0-9\\-]{0,61}[a-z0-9])?\\.)+"//域名识别
					+"(cn|aero|arpa|biz|com|coop|edu|gov|info|int|jobs|mil|museum|name|nato|net|org|pro|travel))"//二级域名识别
					+"|(((25[0-5]|2[0-4]\\d|[01]?\\d\\d?)($|(?!\\.$)\\.)){3}((25[0-5]|2[0-4]\\d|[01]?\\d\\d?)($|(?!\\.$)))))"//ip识别
					+"(:[0-9]{1,5})?"//端口
					+ "(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&%\$#\=~_\-]+))*"; //后缀
		var regex=new RegExp(strRegex,"gi");
		if(!regex.test(str.replace(htmlRegex,''))){ return str;}
		strHtml = IMUtil.matchAll(strHtml,regex);
		strHtml = IMUtil.unique(strHtml);
		strHtml = strHtml.sort(function(a,b){
			if(a.length>b.length){
				return 1;
			}else{
				return -1;
			}
		});
		$.each(strHtml,function(index,item){
			if(item.trim()!=""&&item.indexOf("&nbsp;")==-1){
				//这里其实可以考虑不用再匹配的，不过匹配也不影响
				var stmp = item.replace(regex,function(m){return '<a onclick="openUrlFromEmessge(\''+m+'\',1)" href="javascript:;">'+m+'</a>';});
				try{
					if(item.indexOf("?")>= 0){
						item = item.replace(/\?/gm,"\\?");
					}
					var replaceTemp = new RegExp(item,"gm");
					str = str.replace(replaceTemp,stmp);					
				}catch(e){
					
				}
				
			}
		})	 
		return str;
	},
	// 判断数组中是否包含某元素
	contains: function(array, e) {
		var i = array.length;  
	    while (i--) {  
	        if (array[i] === e) {  
	            return true;  
	        }  
	    }  
	    return false;  
	},
	//获取字符串或者数组中符合regex的字符串组合
	matchAll:function(array,regex){
		var arrayType = typeof array;
		var r =[];
		if(arrayType =="string"){
			r = array.match(regex);
		}else if(arrayType == "object"){
			for(var i=0;i<array.length;i++){
				r.push.apply(r,array[i].match(regex));
			}
		}
		return r;
	},
	//数组去重，效率高，占空间，适用：number，string类型的Array
	unique:function(array){
		  var n = {}, r = [], len = array.length, val, type;
			for (var i = 0; i < len; i++) {
				val = array[i];
				type = typeof val;
				if (!n[val]) {
					n[val] = [type];
					r.push(val);
				} else if (n[val].indexOf(type) < 0) {
					n[val].push(type);
					r.push(val);
				}
			}
			return r;
	},
	//取A数组 - B数组的补集合部分  最坏的时间复杂度比较高
	residual:function(arrayA,arrayB){
		var r = [],lenA = arrayA.length,lenB = arrayB.length,val;
		if(lenA<lenB){
			for (var i = 0; i < lenA; i++) {
				val = arrayA[i];
				if (arrayB.indexOf(val)<0) {
					r.push(val);
				}
			}
		}else{
			for (var i = 0; i < lenB; i++) {
				val = arrayB[i];
				if (arrayA.indexOf(val)>=0) {
					arrayA = IMUtil.removeArray(arrayA,val);
				}
			}
			r = arrayA;
		}
		return r;
	},
	//取A B数组的交集部分
	intersection : function(arrayA,arrayB){
		var r = [],lenA = arrayA.length,lenB = arrayB.length,val;
		if(lenA >= lenB){
			for (var i = 0; i < lenB; i++) {
				val = arrayB[i];
				if (arrayA.indexOf(val)>=0) {
					r.push(val);
				}
			}
		}else{
			r =IMUtil.intersection(arrayB,arrayA);
		}
		return r;
	},
	//移除某个特定值的元素
	removeArray:function(array,str){
		var len  = array.length;
		if(len>0){
			var index  = array.indexOf(str);
			if(index >= 0){
				array.splice(index,1);
				array = IMUtil.removeArray(array,str);
			}			
		}
		return array;
	},
	//显示加载效果
	 showLoading: function(oBox, oStyle, gif, iDuration, fnCallback){
	 	if(!gif) gif = "/social/images/loading_small_wev8.gif";
	 	var imgwrapdiv = $("<div id='cloading'></div>");
	 	var img = $("<img src='"+gif+"'/>");
	 	imgwrapdiv.css({
	 		"position": "fixed",
	 		"zIndex": "10000",
	 		"display": "block",
	 		"textAlign": "center"
	 	});
	 	imgwrapdiv.css(oStyle);
	 	imgwrapdiv.append(img);
	 	imgwrapdiv.appendTo($(oBox));
		IMUtil.cache.loadTimerId = window.setTimeout(function(){
			IMUtil.shutLoading();
			IMUtil._docallback(fnCallback);
		}, iDuration);
	},
	//关闭加载效果
	shutLoading: function(){
		var loadingdiv =$("#cloading"); 
		if(loadingdiv.length == 0){
			loadingdiv = $(top.document.body).find("#cloading");
		}
		loadingdiv.css('display','none').remove();
		window.clearTimeout(IMUtil.cache.loadTimerId);
		IMUtil.cache.loadTimerId = null;
	},
	//处理回调
	_docallback: function(fn){
		if(fn && fn instanceof Function){
			fn();
		}
	},
	//获取元素在网页中的相对位置
	getPageOffset: function(oj){
		if(oj instanceof jQuery){
			oj = oj[0];
		}
		var pos = oj.getBoundingClientRect();
		//console && console.log("pos:",pos);
		return {
			'width' : oj.offsetWidth,
			'height' : oj.offsetHeight,
			'left' : oj.offsetLeft,
			'top' : oj.offsetTop
		};
	},
	//获取元素的定位
	getDomCord: function(obj, isRelative){
		var top = 0,left = 0;
		if(isRelative){
			top = $(obj).position().top;
			left = $(obj).position().left;
		}else{
			top = $(obj).offset().top;
			left = $(obj).offset().left;
		}
		return {top: top, left: left, width: $(obj).width(), height: $(obj).height()};
	},
	//获取元素的纵坐标（相对于窗口）
	getTop: function (e){
		var offset=e.offsetTop;
		if(e.offsetParent!=null) offset+=IMUtil.getTop(e.offsetParent);
		return offset;
	},
	//获取元素的横坐标（相对于窗口）
	getLeft: function (e){
		var offset=e.offsetLeft;
		if(e.offsetParent!=null) offset+=IMUtil.getLeft(e.offsetParent);
		return offset;
	},
	//根据模板获取层
	getLayer: function(oStyle, classname){
		var left = oStyle.left;
		var top = oStyle.top;
		var width = oStyle.width;
		var height = oStyle.height;
		var div = $("<div class=\"" + classname + "\"></div>");
		div.css({
			'left' : left,
			'top' : top,
			'width' : width,
			'height' : height
		});
		return div;
		
	},
	//在光标处插入文本
	//bug!!如果有滚动条会晃动；光标定位不准确（br!!!!!!!）
	insertHtmlAtPos: function(editableDom, pos, replaceText, isTag){
		$(editableDom).find('.deleteTag').remove();
		var divobj =$(editableDom).find('div');
		for(var i =0;i<divobj.length;i++){
			var tempdiv = $(divobj[i]);
			tempdiv.before("<br>"+tempdiv.text());
			tempdiv.remove();
		}
		if(divobj.length>0){
			pos = IMUtil.getCursorPos(editableDom);
			IMUtil.cache.cursorPos = pos;
		}
		var cHtml = $(editableDom).html();
		cHtml = this.htmlDecode(cHtml);
		//缓存编辑内容
		if(cHtml.length > 0){
			ChatUtil.cache.chatContents.push(cHtml);
		}
		//将空格都转成&nbsp处理,你按下的第一个空格真的是>> <<!!!;
		if(!IMUtil.hasTag(editableDom)){
			cHtml = cHtml.replace(/\s/gim, '&nbsp;');
		}
		var prev = cHtml.replace(/\s/gim, '&nbsp;').substring(0, pos).replace(/&nbsp;/gim, ' ');
		// 如果标签未闭合说明位置计算不对，需要重新计算
		var next = cHtml.replace(/\s/gim, '&nbsp;').substring(pos, cHtml.replace(/\s/gim, '&nbsp;').length).replace(/&nbsp;/gim, ' ');;
		var rtEncoded = replaceText;
		//插入内容的本身不是标签，必须要进行语义化处理
		if(!isTag){
		 	rtEncoded = rtEncoded.replace(/</g, "&lt;"); 
	    	rtEncoded = rtEncoded.replace(/>/g, "&gt;");
		}
		cHtml = prev + rtEncoded + next;
		$(editableDom).html(this.htmlEncode(cHtml));
		var rtEncoded = rtEncoded.replace(/&/gim, '&amp;').replace(/\s/gim, '&nbsp;')
		var len = rtEncoded.length;
		// console.warn("rtEncoded:"+rtEncoded);
		// console.warn("rtEncoded_len:"+rtEncoded.length);
		IMUtil.movePosByOffset(editableDom, 'next', len);
	},
	//是否含有表情标签和@
	hasTag: function(obj){
		var cns = obj.childNodes;
		for(var i = 0; i < cns.length; ++i){
			var tagName = cns[i].tagName;
			if(tagName && (tagName.toUpperCase() == 'B' || tagName.toUpperCase() == 'A' || tagName.toUpperCase() == 'SPAN'))
				return true;
		}
		return false;
	},
	// 检查a.b,span标签是否闭合
	checkTagUnClosed: function(tagHtml){
		return tagHtml.indexOf("<") != -1 && tagHtml.indexOf("/>") == -1 || 
			tagHtml.indexOf("<a") != -1 && tagHtml.indexOf("/a>") == -1 || 
			tagHtml.indexOf("<span") != -1 && tagHtml.indexOf("/span>") == -1;
	},
	//标签转义
	htmlEncode: function(str){
		var s = str;
		if(!s) return s;
	    if (str.length == 0) return ""; 
	    s = s.replace(/\r/gm, '');
	    s = s.replace(/\n/gm, '<br>');
	    s = s.replace(/&nbsp;/gim, ' ');
	    s = s.replace(/\&/g, "&amp;");
	    s = s.replace(/\s/gim, '&nbsp;');
	    s = s.replace(/</g, "&lt;"); 
	    s = s.replace(/>/g, "&gt;"); 
	    s = s.replace(/&lt;br&gt;/gim, "<br>"); 
	    return s; 
	},
	//标签转义
	htmlDecode: function(str){
		var s = str;
		if(!s) return s;
	    if (str.length == 0) return ""; 
	    s = s.replace(/&nbsp;/gim, ' ');
	    s = s.replace(/&amp;/g, "&");
	    s = s.replace(/&lt;/g, "<"); 
	    s = s.replace(/&gt;/g, ">"); 
	    return s; 
	},
	//清除选择的内容
	clearSelected: function(obj){
		//将清除前的内容缓存下来
		var cHtml = $(obj).html();
		if(cHtml.length > 0){
			ChatUtil.cache.chatContents.push(cHtml);
		}
		//低版本IE
		if(document.selection) {
			document.selection.clear();
		}
		//FF？
		else if(obj.selectionStart) { 
			var range = document.createRange();
			var startPos = obj.selectionStart;
			var endPos = obj.selectionEnd;
			var ih = obj.innerHtml;
			var tempstr = ih.substring(0, startPos) + ih.substring(endPos, ih.length);
			obj.innerHtml = tempstr
		} else if(window.getSelection) {
			var sel = window.getSelection();
			if(sel != null){
				var ranCnt = sel.rangeCount;
				for(var i = 0; i < ranCnt; ++i){
					sel.getRangeAt(i).deleteContents();
				}
			}
		}
	},
	//获取光标位置
	getCursorPos: function(obj){
		var curTs = new Date().getTime();
		var groupName = "getCursorPos:"+curTs;
		// console.group(groupName);
		var pos = 0;
		if(document.selection) { // IE
			var allRange = document.body.createTextRange();
			allRange.moveToElementText($(obj).get(0));
			$(obj).focus();
			var ran = document.selection.createRange();
			ran.setEndPoint("StartToStart",allRange);
			var ranText = ran.htmlText;
			//alert(ranText);
			//转换\r \n \t \s 
			ranText = ranText.
				replace(/\r/gim, '').
				replace(/\n/gim, '<br>').
				replace(/\t/gim, '&nbsp;&nbsp;').
				replace(/\s/gim, '&nbsp;');
			pos = ranText.length;
		}
		//对于可输入标签直接读取selectionStart属性，但是div无效！！
		else if(obj.selectionStart) { 
			var range = document.createRange();
			pos = obj.selectionStart;
		} else {
			var sel = window.getSelection();
			var range = document.createRange();
			var childs = obj.childNodes;
			//client.log("focusOffset:"+sel.focusOffset, "anchorOffset:"+sel.anchorOffset, "focusNode:",sel.focusNode);
			if(childs.length > 0){
				sel.extend(sel.focusNode, sel.focusOffset);
				range.setStart(obj, 0);
				range.setEnd(sel.focusNode, sel.focusOffset);
			}else{
				range.selectNodeContents(obj);
			}
			sel.removeAllRanges();
			sel.addRange(range);
			sel.collapse(obj, obj.childNodes.length);
			var cnodes = range.cloneContents().childNodes;
			var len = 0;
			for(var i = 0; i < cnodes.length; ++i){
				var node = cnodes[i];
				var nodeTagName = node.tagName;
				if(nodeTagName && nodeTagName.toUpperCase() == 'BR'){
					len += 4;
				}
				else if(nodeTagName && (nodeTagName.toUpperCase() == 'A' || 
						nodeTagName.toUpperCase() == 'B' || 
						nodeTagName.toUpperCase() == 'SPAN')){
					var tagHtml =  node.outerHTML;
					tagHtml = tagHtml.replace(/\s/g, '&nbsp;');
					len += tagHtml.length;
					// console.warn(tagHtml);
				}
				else{
					//client.log("内容：",node, "长度：",node.length);
					var text = node.textContent;
					//含有&的情况
					text = text.replace(/&/g, '&amp;');
					//含有空格的情况
					text = text.replace(/\s/g, '&nbsp;');
					len += text.length;
					// console.warn(text);
				}
			}
			pos = len;
		}
		// console.warn('[pos]:'+pos);
		// console.groupEnd();
		return pos;
	},
	//光标移动偏移量
	movePosByOffset: function(obj, direction, len) {
		obj.focus(); 
		if(direction == 'prev'){
			len = -len;
		}
		var curPos = IMUtil.cache.cursorPos;
		// console.warn("movePosByOffset:"+IMUtil.cache.cursorPos);
		var cHtml = obj.innerHTML;
		cHtml = this.htmlDecode(cHtml);
		var inserHtml = cHtml;
		var prev,next;
		$(obj).html("");
		if(len > 0){
			var insertedHtml = cHtml.replace(/&/g, '&amp;').replace(/\s/gim, '&nbsp;');
			// console.warn("insertedHtml:"+insertedHtml);
			// console.warn("insertedHtml_length:"+insertedHtml.length);
			inserHtml = insertedHtml.substring(curPos, curPos+len).replace(/&nbsp;/gim, ' ').replace(/&amp;/gim, '&');
			// console.warn("insertedHtml_substr:"+inserHtml);
			prev = insertedHtml.substring(0, curPos).replace(/&nbsp;/gim, ' ').replace(/&amp;/gim, '&');
			IMUtil.htmlAppend(obj, [prev, inserHtml]);
			//$(obj).append(prev).append(inserHtml);
			IMUtil.moveToEndPos(obj);
			next = insertedHtml.substring(curPos+len, insertedHtml.length).replace(/&nbsp;/gim, ' ').replace(/&amp;/gim, '&');
			IMUtil.htmlAppend(obj, next);
			//$(obj).append(next)
		}else{
			var insertedHtml = cHtml.replace(/\s/gim, '&nbsp;');
			inserHtml = insertedHtml.substring(curPos+len, curPos).replace(/&nbsp;/gim, ' ');
			prev = insertedHtml.substring(0, curPos+len).replace(/&nbsp;/gim, ' ');
			IMUtil.htmlAppend(obj, prev);
			IMUtil.moveToEndPos(obj);
			next = insertedHtml.substring(curPos, insertedHtml.length).replace(/&nbsp;/gim, ' ');
			IMUtil.htmlAppend(obj, [inserHtml, next]);
			//$(obj).append(inserHtml).append(next);
		}
		var newCurPos = curPos+len;
		IMUtil.cache.cursorPos = newCurPos;
	},
	//追加标签
	htmlAppend: function(domObj, htmls){
		var $domObj = $(domObj);
		if(typeof htmls == 'object'){
			for(var i = 0; i < htmls.length; i++){
				var tmpHtml = IMUtil.checkTagFormat(htmls[i]); 
				$domObj.append(tmpHtml);
			}
		}else if(typeof htmls == 'string'){
			var tmpHtml = IMUtil.checkTagFormat(htmls); 
			$domObj.append(tmpHtml);
		}
		return domObj;
	},
	//检查标签格式是否合法(粘贴乱码预留方案)
	checkTagFormat: function(htmls){
		var _self = this;
		htmls = _self.htmlEncode(htmls);
		// 判断是否包含闭合标签B,A,SPAN
		var reg = new RegExp("&lt;(a|b|span)(.+?)&gt;(@.+|)&lt;/\\1&gt;", "igm"), tmpHtml=htmls;
		if(reg.test(htmls)) {
			tmpHtml = htmls.replace(reg, function(x) {
				return _self.htmlDecode(x); 
			});
		}else{
			tmpHtml = tmpHtml.replace(/&nbsp;/gim, ' ');
			tmpHtml = tmpHtml.replace(/&amp;/gim, '&');
		}
		return tmpHtml;
	},
	//修正光标位置(粘贴乱码预留方案)
	reviseCursorPos: function(obj){
		
	},
	//光标移动到开头
	moveToHeadPos: function(obj){
		obj.focus(); 
		var len = obj.innerHTML.length; 
		/* IE*/
		if (document.selection) { 
			var sel = document.selection.createRange(); 
			sel.moveStart('character',0); 
			sel.collapse(); 
			sel.select(); 
		} 
		/*通用chrome, FF*/
		else{                                                 
			var sel = window.getSelection();
			var range = document.createRange();
			range.setStart(obj, 0);
			range.collapse(false);
			sel.removeAllRanges();
			sel.addRange(range);
		} 
	},
	//光标移动到结尾(some problem!)
	moveToEndPos: function(obj) {
		obj.focus(); 
		var len = obj.innerHTML.length; 
		/* IE*/
		if (document.selection) { 
			var sel = document.selection.createRange(); 
			sel.moveStart('character',len); 
			sel.collapse(); 
			sel.select(); 
		} 
		/*通用chrome, FF*/
		else{                                                 
			var sel = window.getSelection();
			var range = document.createRange();
			range.selectNodeContents(obj);
			range.collapse(false);
			sel.removeAllRanges();
			sel.addRange(range);
		}
	},
	//判断窗口是否是激活状态
	isWindowActive: function(_win){
		if(typeof from != 'undefined' && from == 'pc' && typeof isCurrentWindowFocused == 'function'){
			return isCurrentWindowFocused();
		}else{
			return IMUtil.cache.isWindowFocus;
		}
	},
	//桌面通知
	Notif: {
		//默认设定
		defaults: {
			bufferSize: 3,
			delay: 5000
		},
		//notification对象队列
		notifqueue: [],
		//清理notification缓存队列
		clearEarlyNotifs: function() {
			while(IMUtil.Notif.notifqueue.length > IMUtil.Notif.defaults.bufferSize){
				IMUtil.Notif.notifqueue.shift().close();
			}
		},
		//跳转到聊天窗口
		goChatWin: function(_win, realTargetid) {
			//判断是否嵌入在iframe里
			var imAddress=$("#addressdiv",parent.document);
			if(imAddress.length==1){ //如果是在主窗口就弹出窗口
				//window.open('/social/im/SocialIMMain.jsp');
				_win.top.focus();
				_win.top.showIMdiv(1);
				//var immsgdiv=$("#immsgdiv",parent.document);
			}else{
				_win.focus();
			}
			if(realTargetid instanceof Array){
				for(var i = 0; i < realTargetid.length; ++i){
					var conversationid = "conversation_" + realTargetid[i];
					var chatitem = $('#recentListdiv #' + conversationid);
					//showConverChatpanel(chatitem);
					chatitem.click();//模拟鼠标事件
				}
			}else{
				var conversationid = "conversation_" + realTargetid;
				var chatitem = $('#recentListdiv #' + conversationid);
				//showConverChatpanel(chatitem);
				chatitem.click();//模拟鼠标事件
			}
			
		},
		//桌面通知
		notify: function(targetName,content,iconUrl, params) {
			/*
			if(targetType==1)
  				iconUrl="/social/images/head_group.png";
			var title = "你有一条新消息";
	  		if(targetType == 0 && targetType != ''){	//单聊
	  			title = "来自联系人[" + targetName + "]的消息" ;
	  		}else if(targetType == 1){
	  			title = "来自群[" + targetName + "]的消息";
	  		}else if(params.msgcount){
	  			title = "通知";
	  			content = "您有"+params.msgcount+"条新消息";
	  		}
			*/
			var title = params.title;
			IMUtil.Notif.clearEarlyNotifs();
			var notification = undefined;
			if (window.webkitNotifications) {
			    //chrome老版本
			    if (window.webkitNotifications.checkPermission() == 0) {
			        notification = window.webkitNotifications.createNotification(iconUrl, title, content);
			        notification.display = params.display;
			        notification.replaceId = params.replaceId ? params.replaceId : 'Meteoric';
			        notification.show();
			    } else {
			        window.webkitNotifications.requestPermission($jy.notify);
			    }
			}
	     	else if("Notification" in window){
	         	// 判断是否有权限
	         	if (Notification.permission === "granted") {
	             	notification = new Notification(title, {
	                 	"icon": iconUrl,
	                 	"body": content
	            	});
	         	}
	         	//如果没权限，则请求权限
	         	else if (Notification.permission !== 'denied') {
	             	Notification.requestPermission(function(permission) {
	                 	if (!('permission' in Notification)) {
	                    	Notification.permission = permission;
	                 	}
	                 	//如果接受请求
	                 	if (permission === "granted") {
	                     	notification = new Notification(title, {
	                         	"icon": iconUrl,
	                         	"body": content
	                     	});
	                 	}
	             	});
	         	}
	     	}
	     	if(notification){  //超时关闭
	     		notification.onerror = params.onerror;
		        notification.onclose = params.onclose;
		        notification.onclick = params.onclick ? params.onclick : function(){this.close();}
		        notification.onshow = params.onshow;
	     		IMUtil.Notif.notifqueue.push(notification);//入队
	     		var delay = params.delay ? params.delay : IMUtil.Notif.defaults.delay;
	     		window.setTimeout(function(){
	     			notification.close();
	     		}, delay);
	     	}
		}
	},
	imPerfectScrollbar:function(targetObj){
		var scrollbar, scrollbarid, scrollbarids=[];
		for(var i = 0; i < targetObj.length; ++i){
			scrollbar = $(targetObj[i]).perfectScrollbar();
			var scrollbarid=scrollbar.rail.attr("id");
	  		$(targetObj[i]).attr("_scrollbarid",scrollbarid);
	  		$("#"+scrollbarid).addClass("chatListScrollbar").css({"z-index":1000, "height":0});
	  		scrollbarids.push(scrollbarid);
		}
  		return scrollbarids;
	},
	bindLoadMoreHandler: function(targetObj, handler){
		targetObj = $(targetObj);
		targetObj.bind('mousewheel', function(event,delta, deltax, deltay){
	    	var scrollTop = $(this).perfectScrollbar("getScrollTop");
	    	var delta = IMUtil.getDeltaValue(event);
	    	var dir = delta > 0 ? 'Up' : 'Down',
	            vel = Math.abs(delta);
	        var scrollH = targetObj[0].scrollHeight;
	        var listH = targetObj[0].offsetHeight;
	        if(dir == 'Down' && scrollTop <= scrollH - listH && scrollTop >= scrollH - listH - 40){
	        	if(typeof handler === 'function'){
	        		handler(targetObj);
	        	}
	        }
	        return false;
	    });
	},
	showPerfectScrollbar:function(targetObj){
		var scrollbarid=targetObj.attr("_scrollbarid");
	  	$(".chatListScrollbar").css({"z-index":"1000"});
	  	$("#"+scrollbarid).css({"z-index":"1001"});
	},
	showIMScrollbar:function(isShow, targetObj){
		targetObj.each(function(){
			var scrollbarid = $(this).attr("_scrollbarid");
			if(!!isShow){
				$("#"+scrollbarid).show();
			}else{
				$("#"+scrollbarid).hide();
			}
			
		});
	},
	removeIMScrollbar:function(targetObj){
		targetObj.each(function(){
			var scrollbarid = $(this).attr("_scrollbarid");
			$("#"+scrollbarid).remove();
		});
	},
	//获取指定元素绑定的滚动条
	findBindScrollers: function(selectors, callback){
		var $elems = $(selectors), scrollers=[], scrollid;
		$elems.each(function(){
			scrollid = $(this).attr('_scrollbarid');
			scrollers.push($('#'+scrollid));
		});
		callback(scrollers);
	},
	//获取delta
	getDeltaValue : function(event) {
		var delta = 0;
	    if (!event) event = window.event;
	    if (event.wheelDelta) {
	        delta = event.wheelDelta/120; 
	        if (window.opera) delta = -delta;
	    } else if (!isNaN(event.detail)) {
	        delta = -(event.detail || 0)/3;
	    }else{
	    	event = event.originalEvent;
	    	if(!isNaN(event.wheelDelta)){
	    		delta = event.wheelDelta/120;
	    	}
	    	//DOMMouseScroll for Firefox 
	    	else if(!isNaN(event.detail)){
	    		delta = -(event.detail || 0)/3;
	    	}
	    }
	    return delta;
	},
	//拼接资源的url
	getShareUrl: function(shareid, sharetype){
		var uri = '';
		switch(sharetype){
		case 'CUSTOM_SHARE_MSG_TYPE_DOCUMENT': //文档
			uri = '/workflow/request/ViewRequest.jsp?requestid=' + shareid;
		break;
		case 'CUSTOM_SHARE_MSG_TYPE_WORKFLOW': //流程
			uri = '/docs/docs/DocDsp.jsp?id=' + shareid
		break;
		}
		return uri;
	},
	//获取fileid
	getFileidInUrl: function(url) {
		var tag = "fileid=";
		var start = url.indexOf(tag);
		if(start == -1)
			return '';
		var len = url.length,pos = start + tag.length,charary=[];
		while(pos < len){
			if(url.charAt(pos) == '&'){
				break;
			}
			charary.push(url.charAt(pos));
			pos++;
		}
		return charary.join(''); 
	},
	//判断是否支持css3
	supportCss3: function(style){
		var prefix = ['webkit', 'Moz', 'ms', 'o'], 
		i, 
		humpString = [], 
		htmlStyle = document.documentElement.style, 
		_toHumb = function (string) { 
			return string.replace(/-(\w)/g, function ($0, $1) { 
				return $1.toUpperCase(); 
			}); 
		}; 
		 
		for (i in prefix) 
			humpString.push(_toHumb(prefix[i] + '-' + style)); 
		 
		humpString.push(_toHumb(style)); 
		 
		for (i in humpString) 
			if (humpString[i] in htmlStyle) return true; 
		 
		return false; 
	},
	//打开滑动窗口
	//关闭群设置
	doHideSlideDiv: function(obj, callbacks){
		var target = obj,discussSetdiv;
		if(!(obj instanceof jQuery)){
			target = $(obj);
		}
		if(target.attr('class') == 'imSlideDiv')
			discussSetdiv = target;
		else if(target[0] == document){
			discussSetdiv = target.find("#imSlideDiv");
		}else
			discussSetdiv = target.parents('.imSlideDiv').first();
		discussSetdiv.animate({
				'width': '0px'
			}, 200, function(){
                $(this).css("display", "none");
                
                // pc端对拖拽特殊处理
                if(typeof from != 'undefined' && from == 'pc') {
                    DragUtils.restoreDrags(); 
                }
                if(callbacks && callbacks.afterhide){
					callbacks.afterhide();
				}
            }).
			unbind('.discussSet');
		$(document).unbind('.slidedivhide');
		if(callbacks && callbacks.beforehide){
			callbacks.beforehide();
		}
	},
	//群设置
	doShowSlideDiv: function(width, callbacks) {
        // pc端对拖拽特殊处理
        if(typeof from != 'undefined' && from == 'pc') {
            DragUtils.closeDrags();
        }
        
		var slidediv = $('#imSlideDiv');
		slidediv.css("display", "block").animate({
			'width': width
		}, 400, function(){
			if(callbacks && callbacks.onshow){
				callbacks.onshow();
			}
		}).
		bind('click.slideDiv', function(e){
			e.stopPropagation();
		});
		$(document).bind('click.slidedivhide', function(e){
			var target = $(e.target || e.srcElement);
			var pas = target.parents('.imSlideDiv');
			var isDialogdiv = IMUtil.isDialogdiv(target);
			if(isDialogdiv || pas.length > 0 || target.attr('class') == 'imSetting' || slidediv.width() === 0){
				return;
			}
			IMUtil.doHideSlideDiv(slidediv, callbacks);
		});
		
	},
	//判断是否是dialog的div
	isDialogdiv: function(target) {
		var dbd = $('#_DialogBGDiv')
		if(dbd.is(':visible')){
			return true;
		}
		var id = target.attr('id');
		if(id && (id.indexOf('_DialogDiv') != -1 || id.indexOf('_DialogBGDiv') != -1)){
			return true;
		}
		var diadiv = target.parents('div');
		if(diadiv && diadiv.length > 0){
			var divid = diadiv.first().attr('id');
			if(divid && (divid.indexOf('_DialogDiv_') == 0 || divid.indexOf('_DialogButtons') == 0)){
				return true;
			}
		}
		return false;
	},
	guid:function () {
	    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
	        var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
	        var uuid=v.toString(16).replace(/-/,"");
	        return uuid;
	    });
	},
	//睡眠
	sleep: function(millisec) {
		var now = new Date();       
		var exitTime = now.getTime() + millisec;      
		while (true) {    
			now = new Date();          
			if (now.getTime() > exitTime)    
				return;       
		}
	},
	addGroupBook: function(discussid,resourceids,opt){
	    var tempArray = resourceids.split(',');
	    for(var i = 0 ;i<tempArray.length;i++){
	       var temp = getRealUserId(tempArray[i]);
	       tempArray[i] = temp;
	    }
		var url=getPostUrl("/social/im/SocialIMOperation.jsp?operation=addOrDelGroupBook");
		var isopenfire = (IS_BASE_ON_OPENFIRE && IS_BASE_ON_OPENFIRE == true) ? 1 : 0;
		$.post(url,{"discussid":discussid,"opt":opt,"resourceids":tempArray.join(','), 'isopenfire':isopenfire},function(data){
            if(ChatUtil.isFromPc()){
                if(WindowDepartUtil.isAllowWinDepart()){
                    var win = window.Electron.ipcRenderer.sendSync('plugin-getWinIdInfo');
                    var id = window.Electron.currentWindow.id;
                    if(win.chatwinid === id && typeof ClientUtil !== 'undefined'){
                        ClientUtil.loadIMDataList();
                    }else{
                        loadIMDataList("discuss");
                    }
                }else{
                    loadIMDataList("discuss");
                }           
            }else{
               loadIMDataList("discuss");
            }
		})
	},
	addConversation: function(targetid,targetname){
		var senderid = M_USERID;
		var isopenfire = (IS_BASE_ON_OPENFIRE && IS_BASE_ON_OPENFIRE == true) ? 1 : 0;
		$.post("/social/im/SocialIMOperation.jsp?operation=addConversation",{"targetid":targetid,"targetname":targetname,"senderid":senderid,"isopenfire":isopenfire,targettype:"1"},function(){
		});

	},
	//统计字符串中指定字符的个数
	countSubStr: function(str, target) {
		var temp=str, pos, cnt=0;
		while((pos = temp.indexOf(target)) != -1){
			cnt++;
			temp = temp.substring(pos+target.length);
		}
		return cnt;
	},
	//为body动态加载js
	loadScripts: function(opts, $windoc){
		var container = $windoc;
		var opt={};
		for(var i = 0; i < opts.length; ++i){
			opt = opts[i];
			$("<script></script>").attr({'src':opt.url,'type':'text/javascript'}).appendTo(container);
		}
	},
	//加载js到缓存
	cacheLoad: function(url, handlers){
		jQuery.ajax({
		      url: url,
		      dataType: "script",
		      cache: true,
		      success: handlers.success
		});
	},
	//获取隐藏元素尺寸
	getHiddenDomSize: function(domEle){
		var w,h;
		var dp = domEle.style.position,
		dt = domEle.style.top,
		dv = domEle.style.visibility,
		dd = domEle.style.display;
		
		
		domEle.style.position = "absolute";
		domEle.style.top = "-3000px";
		domEle.style.visibility = "hidden";
		domEle.style.display = "block";
		w = $(domEle).width();
		h = $(domEle).height();
		
		domEle.style.position = dp;
		domEle.style.top = dt;
		domEle.style.visibility = dv;
		domEle.style.display = dd;
		
		return {width: w, height: h};
	},
	//获取字符串字节长度
	getStrLen: function(str){
		var myLen = 0, i = 0;
		var maxstrlen = IMUtil.settings.WORDMAXLEN;
		for(; (i < str.length)&&(myLen <= maxstrlen*2); i++){
			if(str.charCodeAt(i)>0&&str.charCodeAt(i)<128)
				myLen++;
			else
				myLen+=2;
		}
		return myLen;
	},
	//获取图片的uri
	getImgUri: function(imgbase64, weburi){
		var imguri = "";
		if(imgbase64 == '(null)' || imgbase64 == 'null' || imgbase64 == ''){
			imguri = weburi;
		}else{
			imguri = "data:image/jpg;base64,"+imgbase64;
		}
		return imguri;
	},
	//打开连接
	doOpenLink: function(url, name){
	if(ChatUtil.isFromPc()&&WindowDepartUtil.isAllowWinDepart()){
	   var shell = window.Electron.remote.shell;
       PcExternalUtils.openUrlByLocalApp(url,0);
	}else{
	   window.open(url,name);
	}
	
	},
	//图片的base64串到类型数组的转换
	base64ToTypedArray: function(base64){
		var binary_string =  window.atob(base64);
	    var len = binary_string.length;
	    var bytes = new Uint8Array( len );
	    for (var i = 0; i < len; i++)        {
	        bytes[i] = binary_string.charCodeAt(i);
	    }
	    return bytes;
	},
	// 根据blobdata获取图片的url
	getImgUrlFromBlob: function(blobData, Cb){
		var fileReader = new FileReader;
		var rFilter = /^(?:image\/bmp|image\/cis\-cod|image\/gif|image\/ief|image\/jpeg|image\/jpeg|image\/jpeg|image\/pipeg|image\/png|image\/svg\+xml|image\/tiff|image\/x\-cmu\-raster|image\/x\-cmx|image\/x\-icon|image\/x\-portable\-anymap|image\/x\-portable\-bitmap|image\/x\-portable\-graymap|image\/x\-portable\-pixmap|image\/x\-rgb|image\/x\-xbitmap|image\/x\-xpixmap|image\/x\-xwindowdump)$/i;;
		if(fileReader){
			var src = '';
			if(rFilter.test(blobData.type)){
				fileReader.readAsDataURL(blobData);
			}
			fileReader.onload = function(oFREvent){
				src = oFREvent.target.result;
				if(typeof Cb === 'function') {
					Cb(src);
				}
			};
		}
	},
	// 图片转canvas对象
	imageToCanvas: function(src, obj, cb){
		var img = new Image();
		img.src = src;
		img.onload = function(){
			var that = this;
		  	// 默认按比例压缩
		  	var w = that.width, h = that.height, scale = w / h;
		  	if(scale>1){
		  		obj.maxWidth = obj.maxWidth||obj.maxHeight;
				// 指定最大宽度
				if(obj.maxWidth < w) {
					w = obj.maxWidth;
					h = w /scale;
				}
		  	}else{
		  		obj.maxHeight = obj.maxHeight||obj.maxWidth;
					// 指定最大高度
				if(obj.maxHeight && obj.maxHeight < h) {
					h = obj.maxHeight;
					w = h * scale;
				}
		  	}
		   	w = obj.width || w;
		   	h = obj.height || h;
		   	
		  	//生成canvas
		  	var canvas = document.createElement('canvas');
		  	var ctx = canvas.getContext('2d');
		  	// 创建属性节点
		  	var anw = document.createAttribute("width");
		  	anw.nodeValue = w;
		  	var anh = document.createAttribute("height");
		  	anh.nodeValue = h;
		  	canvas.setAttributeNode(anw);
		  	canvas.setAttributeNode(anh); 
		  	ctx.drawImage(that, 0, 0, w, h);
		  	cb && cb(canvas);
		 }
	},
	// 利用canvas压缩图片
	compressImg: function(src, options, cb){
		console.log("compressed image.!");
		// var w = options? (options.width || 240) : 240;
		this.imageToCanvas(src, options, function(canvas) {
			var defaultQuality = 0.2;
			var quality = options? (options.quality || defaultQuality) : defaultQuality;
			var base64 = canvas.toDataURL('image/jpeg', quality );
			var base64 = base64.replace(/^data:image\/\w+;base64,/, "");
			cb && cb(base64);
		});
	},
	//判断控件是否获得焦点
	isFocus: function(elem){
		if(document.activeElement == elem) {
			return true;
		}else{
			return false;
		}
	},
	//读取cookie
	readCookie: function(name){
		var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)");
		if(arr=document.cookie.match(reg))
			return unescape(arr[2]);
		else
			return null;
	},
	//设置cookie
	setCookie: function(name, value, days){
		var Days = !!days?days:30;
		var exp = new Date();
		exp.setTime(exp.getTime() + Days*24*60*60*1000);
		document.cookie = name + "="+ escape (value) + ";expires=" + exp.toGMTString();
	},
	//删除cookie
	delCookie: function(name){
		var exp = new Date();
		exp.setTime(exp.getTime() - 1);
		var cval=getCookie(name);
		if(cval!=null)
		document.cookie= name + "="+cval+";expires="+exp.toGMTString();
	},
	//刷新
	refresh: function(_win){
		if(!_win){
			_win = window;
		}
		_win.location.reload()
	},
	//粘贴
	doPaste: function(obj, evt, domId){
		document.execCommand('paste');
		evt.preventDefault();
		evt.stopPropagation();
		evt.cancelBubble = false;
	},
	//分割字符串, 返回数组
	niceSplit: function(str, delim){
		var reg = new RegExp("((\\"+delim+")+)(\\1)+","gim");
		str = str.replace(reg, '$1');
		if(str.indexOf(delim) == 0) {
			str = str.substring(1,str.length);
		}
		if(str.lastIndexOf(delim) == str.length - 1) {
			str = str.substring(0,str.length - 1);
		}
		if(str.indexOf(delim) == -1){
			if("" === str){
				return new Array();
			}
			return new Array(str);
		}
		return str.split(delim);
	},
	getFormatTimeByMillis: function(millis){
		if(!/^[0-9]+$/.test(millis)) return;
		var date = new Date();
		date.setTime(millis);
		var dateString=date.pattern("yyyy-MM-dd HH:mm:ss");
		return dateString;
	},
	getFormatDateByMillis: function(millis){
		if(!/^[0-9]+$/.test(millis)) return;
		var date = new Date();
		date.setTime(millis);
		var dateString=date.pattern("yyyy-MM-dd");
		return dateString;
	},
	getFormatDateCustomByMillis: function(millis, fmtStr){
		if(!/^[0-9]+$/.test(millis)) return;
		var date = new Date();
		date.setTime(millis);
		var dateString=date.pattern(fmtStr);
		return dateString;
	},
	//是否存在顶层窗口
	hasTopDialog: function(){
		try{
			var diagAry = top.topWin.Dialog._Array
			var isExistTopDg = diagAry.length > 0;
		}catch(err){
			var isExistTopDg=false;
		}
		var isSlideDivShow = $('#imSlideDiv').is(':visible');
		var isHrmCardDivShow = $('#HelpFrame').is(':visible');
		return isExistTopDg || isSlideDivShow || isHrmCardDivShow;
	},
	// 处理编码为160的空格
	replaceSpace160: function(content){
		var arr = content.split('');
		for(var i = 0; i < arr.length; i++) {
			if(content.charCodeAt(i) == 160){
				arr[i] = String.fromCharCode(32);
			}
		}
		return arr.join('');
	}
};

//时间日期处理工具
var IMDateUtil = {
	getFormat: function(date){
		var myyear = date.getFullYear();     
		var mymonth = date.getMonth()+1;     
		var myweekday = date.getDate();      
			 
		if(mymonth < 10){     
			mymonth = "0" + mymonth;     
		}      
		if(myweekday < 10){     
			myweekday = "0" + myweekday;     
		}     
		return (myyear+"-"+mymonth + "-" + myweekday);      
	},
	/*
	 * 获取本周起始日期
	 * return YYYY-MM-DD
	 */
	getWeekStartDate: function(){
		var d = new Date;
		var w = d.getDay();
		var n = (w == 0 ? 7 : w) - 1;
		d.setDate(d.getDate() - n);
		
		return this.getFormat(d);
	},
	getWeekEndDate: function(){
		var d = new Date;
		var w = d.getDay();
		var n = (w == 0 ? 7 : w) - 1;
		d.setDate(d.getDate() - n + 6);
		
		return this.getFormat(d);
	},
	/*
	 * 获取本月起始日期
	 * return YYYY-MM-DD
	 */
	getMonthStartDate: function(){
		var d = new Date;
		d.setDate(1);
		return this.getFormat(d);
	},
	/*
	 * 获取本月结束日期
	 * return YYYY-MM-DD
	 */
	getMonthEndDate: function(){
		var d = new Date;
		d.setDate(this.getMonthDays());
		return this.getFormat(d);
	},
	/*
	 * 获取本季开始日期
	 * return YYYY-MM-DD
	 */
	getQuarterStartDate: function(){
		var d = new Date;
		d.setDate(1);
		d.setMonth(this.getQuarterStartMonth());
		return this.getFormat(d);
	},
	/*
	 * 获取本季结束日期
	 * return YYYY-MM-DD
	 */
	getQuarterEndDate: function(){
		var d = new Date;
		d.setMonth(this.getQuarterStartMonth() + 2);
		d.setDate(this.getMonthDays(d.getMonth()));
		return this.getFormat(d);
	},
	getQuarterStartMonth: function(){
		var d = new Date;
		var nowMonth = d.getMonth();
		var quarterStartMonth = 0;     
	    if(nowMonth<3){     
	       quarterStartMonth = 0;     
	    }     
	    if(2<nowMonth && nowMonth<6){     
	       quarterStartMonth = 3;     
	    }     
	    if(5<nowMonth && nowMonth<9){     
	       quarterStartMonth = 6;     
	    }     
	    if(nowMonth>8){     
	       quarterStartMonth = 9; 
	    }     
	    return quarterStartMonth; 
	},
	getYearStartDate: function(){
		var d = new Date;
		d.setDate(1);
		d.setMonth(0);
		return this.getFormat(d);
	},
	getYearEndDate: function(){
		var d = new Date;
		d.setDate(31);
		d.setMonth(11);
		return this.getFormat(d);
	},
	/*
	 * 获取当前月份天数
	 */
	getMonthDays: function(month){
		var d = new Date;
		var dd = new Date;
		d.setDate(1);
		dd.setDate(1);
		if(month){
			d.setMonth(month);
			dd.setMonth(month);
		}
		dd.setMonth(dd.getMonth() + 1);
		var days = (dd - d)/(1000*60*60*24); 
		return days;
	}
};
// web worker 
var WebWorker = {
	workers: [],
	// 判断是否支持web worker
	supportWebWorker: function(){
		return typeof(Worker)!=="undefined";
	},
	// 启动web worker对象
	startWorker: function(id, targetjs, params, cb){
		if(!this.supportWebWorker()){
			throw new Error('does not support web workers...');
		}
		var w = this.workers[id] = new Worker(targetjs);
		if(typeof params !== 'undefined') {
			w.postMessage([params]);
		}
		w.onmessage = function(event){
			if(typeof cb !== 'undefined') {
				cb(event.data[0]);
			}
		}
	},
	// 停止web worker
	stopWorker: function(id){
		if(this.workers[id] instanceof Worker) {
			this.workers[id].terminate();
		}	
	}
};
//扩展
jQuery.fn.extend({
	autoHideArray:{},
	autoHide: function(excludeSelectors, callback){
		var obj = this;
		if(!this.autoHideArray[excludeSelectors]){
			this.autoHideArray[excludeSelectors] = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
				var r = Math.random()*16|0, v = c == 'x' ? r : (r&0x3|0x8);
				var uuid=v.toString(16).replace(/-/,"");
				return uuid;
			});
		}
		var autoHideGUID = this.autoHideArray[excludeSelectors];
		$(obj).bind('click', function(e){
			e.stopPropagation();
		});
		$(document).unbind('click.autoHide'+autoHideGUID).bind('click.autoHide'+autoHideGUID, function(e){
			var flag = true;
			var srcdom = e.target || e.srcElement;
			if(typeof excludeSelectors == 'string'){
				var excludeDoms = $(excludeSelectors);
				for(var i=0;i<excludeDoms.length;i++){
					if(excludeDoms[i] == srcdom){
						flag = false;
					}
				}
			}
			//直接传入dom对象
			else {
				if(excludeSelectors == srcdom){
					flag = false;
				}
			}
			if(flag){
				$(obj).hide();
				if(typeof callback == 'function'){
					callback();
				}
			}
		});
	}		
});


