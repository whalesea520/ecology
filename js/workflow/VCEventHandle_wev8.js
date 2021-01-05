/*
 * VCEventHandle.js Version:1.1 
 * 本插件提供对流程HTML模式下用户绑定onpropertychange事件的支持，支持所有浏览器。
 * 事件执行机制与原生类似。在非IE下，事件触发可能会存在延迟(最大为500毫秒)，IE下使用的是远程事件机制。
 * <font color="red">注意：本插件仅供流程HTML模式调用，不提供对其他功能的支持， 请不要将此插件修改为全局插件</font>
 * Made by CC Tsai
 * Last update time : 2015-04-23
*/
var __bindPropertyChangefn = {};
var __bindPropertyChangefnArray = {};
var __propertyEleValMap = new Map(); 
(function ($) {
	$.fn.bindPropertyChange = function (funobj) {
		return this.each(function () {
			var $this = $(this);
			//获取元素id，或者name
			var thisid = $this.attr('id');
			
			//支持对单个元素多次绑定start
			var __pcfarray = __bindPropertyChangefnArray[thisid];
			if (!!!__pcfarray) {
				__pcfarray = new Array();
				__bindPropertyChangefnArray[thisid] = __pcfarray;
			}
			__pcfarray.push(funobj);
			//支持对单个元素多次绑定end
			
			//test
			var isIE = false;
			try {
				isIE = $.client.browser == 'Explorer' ? true : false;
			} catch (e) {
			}
			
			if (isIE) {
				//保存原值
				__propertyEleValMap.put(thisid, $this.val());
				//保存事件
				/*
				__bindPropertyChangefn[thisid] = function (target) {
					var __newVal4e = jQuery(target).val();
					var __oldVal4e = __propertyEleValMap.get(thisid);
					if (__newVal4e != __oldVal4e) {
						__propertyEleValMap.put(thisid, __newVal4e);
						funobj(target);
					}
				};
				*/
				
				//保存事件
				__bindPropertyChangefn[thisid] = function (target) {
					var __newVal4e = jQuery(target).val();
					var __oldVal4e = __propertyEleValMap.get(thisid);
					if (__newVal4e != __oldVal4e) {
						__propertyEleValMap.put(thisid, __newVal4e);
						var __vcfnarray = __bindPropertyChangefnArray[thisid];
						for (var i97=0; i97<__vcfnarray.length; i97++) {
							try {
								__vcfnarray[i97](target);
							} catch (__e97) {}
						}
					}
				};
			} else {
				//__bindPropertyChangefn[thisid] = funobj;
				__bindPropertyChangefn[thisid] = function (target) {
					var __vcfnarray = __bindPropertyChangefnArray[thisid];
					for (var i97=0; i97<__vcfnarray.length; i97++) {
						try {
							__vcfnarray[i97](target);
						} catch (__e97) {}
					}
				};
			}
			
			
			//调用事件方法，并把当前对象作为参数传递过去
			var crtpcstr = '__bindPropertyChangefn[\'' + thisid + '\'](document.getElementById(\'' +  thisid + '\'))';
			var pcstr = '';
			var attrname = '';
			if (isIE) {
				attrname = 'onpropertychange';
			} else {
				attrname = '_listener';
			}
			pcstr = this.getAttribute(attrname);
			if (!!!pcstr) pcstr = '';
			if (pcstr.indexOf(crtpcstr) == -1) {
				if (pcstr === '') {
					pcstr = crtpcstr;
				} else {
					pcstr += ';' + crtpcstr;
				}
				this.setAttribute(attrname, pcstr);
			}
			
			if (!isIE) {
				loadListener();
			}
		});
	};
})(jQuery);