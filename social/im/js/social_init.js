	// 兼容性探测
	(function() {
	    var method;
	    var methods = new Array(
	        'assert', 'clear', 'count', 'debug', 'dir', 'dirxml', 'error',
	        'exception', 'group', 'groupCollapsed', 'groupEnd', 'info', 'log',
	        'markTimeline', 'profile', 'profileEnd', 'table', 'time', 'timeEnd',
	        'timeStamp', 'trace', 'warn'
	    );
	    var length = methods.length;
	    var console = (window.console = window.console || {});
	    while (length--) {
	        method = methods[length];
	        // Only stub undefined methods.
	        if (!console[method]) {
	            console[method] = function(){};
	        }
	    }
	}(window));
	//event对象
	try{
	var browserName = $.client.browserVersion.browser;             //浏览器名称
	var browserVersion = parseInt($.client.browserVersion.version);//浏览器版本
	if(browserName != "IE"){
		var im_event = getEvent();
	}
	
	//语言环境
	Env = {languageid: window.languageid || readCookie("languageidweaver"), language_loc: {"7": "zh-CN", "8": "en", "9": "zh-TW"}}
	if (!Array.prototype.indexOf) {
		Array.prototype.indexOf = function(item, i) {  
			i || (i = 0);  
			var length = this.length;  
			if (i < 0) i = length + i;  
			for (; i < length; i++)  
				if (this[i] === item) return i;  
			return -1;  
		};  
	}
	//Array对象扩展
	if (!Array.prototype.forEach) {
	  	Array.prototype.forEach = function(arr,func) {
	  		return function(arr, func) {
	          for (var i = 0, len = arr.length; i < len; i++) {
	              func.call(arr, arr[i], i, arr)
	          }
	      	}
	  	};
	}
	if (!Array.prototype.unique) {
	  	Array.prototype.unique = function() {
	  		var obj = {},arr = this;
			for(var len = arr.length, i = len - 1;i >= 0; --i){
			  var value = arr[i];
			  if(typeof obj[value] === 'undefined'){
			    obj[value] = i;
			  }else{
			  	arr.splice(obj[value], 1);
				for(var j = i; j < arr.length; j++){
					obj[arr[j]] = j;
				}
			  }
			}
			return arr;
	  	};
	}
	if (!Array.prototype.removeValues) {
	  	Array.prototype.removeValues = function(arr) {
	  		var obj = {},arr0 = this;
			if(typeof arr === 'array' || typeof arr === 'object') {
				for(var i = 0; i < arr.length; ++i){
					obj[arr[i]] = 1;
				}
			}else{
				obj[arr] = 1;
			}
			for(var len = arr0.length, j = len - 1;j >= 0; --j){
				if(obj[arr0[j]]) {
					arr0.splice(j, 1);
				}
			}
			return arr0;
	  	};
	}
	}catch(err){
	   Env = {languageid: window.languageid, language_loc: {"7": "zh-CN", "8": "en", "9": "zh-TW"}}; 
	}
	// jquery插件初始化
	$(function(){
		//加载i18n配置
	  	jQuery.i18n.properties({
	         name : 'strings', 
	         path : '/social/i18n/',
	         mode : 'map', 
	         language : Env.language_loc[Env.languageid],
	         cache: false,
	         callback : function() {
	             console.log("i18n配置成功加载！");
	             if(typeof window.social_i18n === 'undefined'){
			         window.social_i18n = function(propname){
			             var reg_text = $.i18n.prop(propname);
			             if(arguments.length > 1){
			             	 for(var i = 1; i < arguments.length; ++i){
				             	reg_text = reg_text.replace(/\$\{([0-9]+)\}/, arguments[i]);
				             }
			             }
			             return reg_text;
			         }
			     }
	         }
	     });
	     
	});
	
	//全局公共变量
	var SOCIAL_GLOBAL = {
	      OnlineStatus : {
	           //保存获取过的人员的状态
	           M_ONLINESTATUS : new Array(),
			   //保存获取过状态的ID
			   M_ALLUSERSTATUS : new Array(),
			   //保存组织架构人员树地址信息 （可以废除）
			   M_ORG_TREE : new Array(),
			   //保存常用组人员树地址信息（可以废除）
			   M_PUBLICGROUP_TREE : new Array(),
			   M_PRIVATEGROUP_TREE : new Array(),
			   //保存常用组和组织架构人员数叶子节点，
               M_ORGGROUP_TREE : new Object(),
			   //在线状态设置
			   TOP_ONLINESTATUS : new Array(),
			   LEFT_ONLINESTATUS : new Array(),
			   RIGHT_ONLINESTATUS : new Array(),
			   //判断是否改变了状态
               M_IS_CHANGESTATUS : new Array(),
	           init : function (){
	                this.TOP_ONLINESTATUS['away']='/social/images/userStatus/top/away.png';
				    this.TOP_ONLINESTATUS['online']='/social/images/userStatus/top/online.png';
				    this.TOP_ONLINESTATUS['busy']='/social/images/userStatus/top/busy.png';
				    this.LEFT_ONLINESTATUS['away']='/social/images/userStatus/left/away.png';
				    this.LEFT_ONLINESTATUS['online']='/social/images/userStatus/left/mobileOnline.png';
				    this.LEFT_ONLINESTATUS['busy']='/social/images/userStatus/left/busy.png';
				    this.RIGHT_ONLINESTATUS['away']='/social/images/userStatus/right/away.png';
				    this.RIGHT_ONLINESTATUS['online']='/social/images/userStatus/right/mobileOnline.png';
				    this.RIGHT_ONLINESTATUS['busy']='/social/images/userStatus/right/busy.png';
	           }
	      },
	      // 离线消息缓冲池
	      OfflineMsgPool: new Array(),
	      // 已接收的 离线消息量
	      ReceivedOfflineMsgCount: 0,
	      // 空闲计数
	      idleCount: 0,
	      // 时间处理间隔
	      MilisThrehold: 30,
	      // 离线消息监听器
	      offlineMsgHandler: null
	};
	
	SOCIAL_GLOBAL.OnlineStatus.init();
	