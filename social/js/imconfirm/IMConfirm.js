/* ===================================================
 * IMConfirm.js v1.0.0
 * http://www.weaver.com.cn
 * ===================================================
 * Author: elvis.wang
 *
 * 说明：
 * 轻量级弹出框
 *
 * 修订历史：
 * 2015.8.18 创建 V1.0.0
 * ========================================================== */

(function($){
	//默认值
	var defaults = {
		style : {
			width: '45%',
			height: '60%',
			background: '#FFF',
			position: 'fixed',
			left: '33%',
			top: '20%',
			display: 'none',
			'border-radius': '5px',
			'z-index': 99999
		},
		classname: null,
		isModel : true,
		draggble: false,
		resizable: false,
		autohide: false,
		title: '标题',
		innerhtml: '<p>这是你自定义的区域</p>',
		buttons: [],
		titlemap: {
			'btn_ok' : '发送',
			'btn_cancel' : '取消'
		},
		clsmap: {
			'btn_cancel' : {
				/*background:'#CCC'*/
			}
		}
		
	};

	/*返回值*/
	var resultvalue = {
		choose: '-1'
	};

	$.fn.imconfirm = function(options){
		var elem = this;
		elem.options = options;
		elem.defaults = defaults;
		elem.resultvalue = resultvalue;
		var style = ('style' in options)? options.style : elem.defaults.style;
		var isModel = ('isModel' in options)? options.isModel : elem.defaults.isModel;
		var draggble= ('draggble' in options)? options.draggble : elem.defaults.draggble;
		var resizable= ('resizable' in options)? options.resizable : elem.defaults.resizable;
		var autohide= ('autohide' in options)? options.autohide : elem.defaults.autohide;
		var innerhtml= ('innerhtml' in options)? options.innerhtml : elem.defaults.innerhtml;
		var title = ('title' in options)? options.title : elem.defaults.title;
		var classname = ('classname' in options)? options.classname : elem.defaults.classname;
		var buttons = ('buttons' in options)? options.buttons : elem.defaults.buttons;
		var mb = elem.prev('.imMengban');
		/*显示对话框*/
		elem.imshow = function(){
			
			if(!style && !classname){
				elem.css(elem.defaults.style);
			}else if(classname && typeof(classname) == 'string') {
				elem.addClass(classname);
			}else if(style){
				elem.css(style);
			}
			if(isModel && (!mb || mb.length <= 0)){
				elem.before("<div class='imMengban'></div>");
				mb = elem.prev('.imMengban');
			}
			if(draggble){
				elem.attr('draggble', 'true');
			}
			elem.fadeIn();
			if(isModel){
				mb.fadeIn();
				if(autohide){
					mb.bind('click.mb', function(e){
						e = e || window.event;
						$(this).hide();
						elem.hide();
						e.stopPropagation();
					});	
				}else{
					mb.unbind('.mb');
				}
			}
			//初始化内部控件
			elem._initHead();
			elem._initInner();
			elem._initBtnGroup();
			if(('onshow' in elem.options))
				elem.options.onshow();
			elem.attr('showing', 'true');
		}
		/*关闭对话框*/
		elem.imclose = function(){
			elem.hide();
			if(isModel) mb.hide();
			if(('onclose' in elem.options))
				elem.options.onclose();
			elem.attr('showing', 'false');
		}
		/*加载效果*/
		elem.imtoast = function(){
			elem.find(".loader-container").show();
		}
		/*带文字的加载效果*/
		elem.imtoasttext = function(text){
			
		}
		/*初始化*/
		elem._initHead = function(){
			var head = elem.find('.imdlghead');
			if(head && head.length > 0){
				$(head.find('span')).html(title);
			}else{
				head = $("<div class=\"imdlghead\"></div>");
				var titlespan = "<span>" + title + "</span>";
				var iconClose = "<div class=\"iconClose\">×</div>";
				head.append(titlespan).append(iconClose);
				this.append(head);
				head.find('.iconClose').bind('click', function(){
					elem.imclose();
				});
			}
			if(draggble){
				head.css('cursor', 'all-scroll');
				//FIXME: 绑定拖动
			}else{}
		}
		
		elem._initInner = function(){
			var inner = elem.find('.inner');
			if(inner && inner.length > 0){
				inner.empty();
			}else{
				inner = $("<div class=\"inner\"></div>");
			}
			$(innerhtml).appendTo(inner);
			//加载toast显示区域
			var toastHtml = "<div class=\"loader-container\">"+
                            	"<div class=\"ball-spin la-2x\">"+
	                                "<div></div>"+
	                                "<div></div>"+
	                                "<div></div>"+
	                                "<div></div>"+
	                                "<div></div>"+
	                                "<div></div>"+
	                                "<div></div>"+
	                                "<div></div>"+
	                            "</div>"+
	                        "</div>";
	        inner.append(toastHtml);
			this.append(inner);
		}

		elem._initBtnGroup = function(){
			var btngroup = elem.find('.bntgroup');
			if(btngroup && btngroup.length > 0){
				btngroup.empty();
			}else{
				btngroup = $("<div class=\"bntgroup\"></div>");
			}
			var grouplayout = $("<div class=\"centerlayout\"></div>");
			grouplayout.appendTo(btngroup);
			var index = 1;
			for(var i = 0; i < buttons.length; ++i){
				var btn = buttons[i];
				for(var j in btn){
					var t = elem.defaults.titlemap[j];
					var cls = elem.defaults.clsmap[j];
					if(t){
						var b = $('<div class=\'' + j + '\' tabIndex=\'' + index + '\'>' + t + '</div>');
						b.appendTo(grouplayout);
						var fun = btn[j];
						b.data('handler', fun);
						b.bind('click', function(fun){elem._doSelect.call(this)});
						if(cls){
							b.css(cls);
						}
					}
					index++;
				}
			}
			//去除最后一个按钮的样式
			var lastdiv = grouplayout.find('div:last');
			lastdiv.addClass('clear');
			this.append(btngroup);
		}
		
		elem._doSelect = function(){
			var btn = $(this);
			var tabindex = btn.attr('tabIndex');
			var handler = btn.data('handler');
			var classname = btn.attr('class');
			elem.resultvalue['choose'] = tabindex;
			handler(elem.resultvalue);
			//elem.imclose();
		}
		
	}
	
})(jQuery)
