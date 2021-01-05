/*
 * Lightweight RTE - jQuery Plugin, version 1.2
 * Copyright (c) 2009 Andrey Gayvoronsky - http://www.gayvoronsky.com
 */
jQuery.fn.rte = function(options, editors) {
	if(!editors || editors.constructor != Array)
		editors = new Array();
		
	$(this).each(function(i) {
		var id = (this.id) ? this.id : editors.length;
		editors[id] = new lwRTE (this, options || {});
	});
	
	return editors;
}

var lwRTE_resizer = function(textarea) {
	this.drag = false;
	this.rte_zone = $(textarea).parents('.rte-zone');
}

lwRTE_resizer.mousedown = function(resizer, e) {
	resizer.drag = true;
	resizer.event = (typeof(e) == "undefined") ? window.event : e;
	resizer.rte_obj = $(".rte-resizer", resizer.rte_zone).prev().eq(0);
	$('body', document).css('cursor', 'se-resize');
	return false;
}

lwRTE_resizer.mouseup = function(resizer, e) {
	resizer.drag = false;
	$('body', document).css('cursor', 'auto');
	return false;
}

lwRTE_resizer.mousemove = function(resizer, e) {
	if(resizer.drag) {
		e = (typeof(e) == "undefined") ? window.event : e;
		var w = Math.max(1, resizer.rte_zone.width() + e.screenX - resizer.event.screenX);
		var h = Math.max(1, resizer.rte_obj.height() + e.screenY - resizer.event.screenY);
		resizer.rte_zone.width(w);
		resizer.rte_obj.height(h);
		resizer.event = e;
	}
	return false;
}

lwRTELang=function(languageid){
	if(languageid==8)//en
		var RTELang={
			sourceEditor:'Source editor',
			visualEditor:'visual Editor',
			Bold:'bold',
			italic:'italic',
			orderedList:'orderedList',
			unorderedList:'unorderedList',
			color:'color',
			image:'image',
			link:'link',
			unlink:'unlink',
			removeFormat:'removeFormat',
			word:'word',
			clear:'clear',
			clearDocument:'Clear Document?',
			ok:'Ok',
			cancel:'Cancel',
			tip:'Title',
			view:'view',
			link_URL:'URL',
			link_createLink:'Create link',
			link_noTextTip:'Please select the text to create link！',
			link_noURLTip:'Please enter URL！',
			link_title:'Create link',
			image_title:'Insert image',
			image_upload:'Upload',
			image_noURLTip:'Enter URL of image to view',
			image_noImgTip:'Please select the image to upload',
			image_URL:'URL',
			color_title:'Set color for text'
			
		}
	else if(languageid==9){//中文繁体
		var RTELang={
			sourceEditor:'源碼編輯',
			visualEditor:'可視編輯',
			bold:'粗體',
			italic:'斜體',
			orderedList:'列表排序',
			unorderedList:'項目排序',
			color:'字體顏色',
			image:'圖片',
			link:'鏈接',
			unlink:'取消鏈接',
			removeFormat:'清除格式',
			word:'word文檔',
			clear:'清空',
			clearDocument:'清除內容？',
			ok:'確定',
			cancel:'取消',
			view:'預覽',
			tip:'提示',
			link_URL:'鏈接地址',
			link_createLink:'創建鏈接',
			link_noTextTip:'請選擇需要創建鏈接的文字！',
			link_noURLTip:'請輸入鏈接地址！',
			link_title:'創建鏈接',
			image_title:'插入圖片',
			image_upload:'上傳',
			image_noURLTip:'請輸入圖片地址',
			image_noImgTip:'請選擇圖片',
			image_URL:'圖片地址',
			color_title:'設置文本顏色'
		}
	}else{ //默认为中文
		var RTELang={
			sourceEditor:'源码编辑',
			visualEditor:'可视编辑',
			bold:'粗体',
			italic:'斜体',
			orderedList:'列表排序',
			unorderedList:'项目排序',
			color:'字体颜色',
			image:'图片',
			link:'链接',
			unlink:'取消链接',
			removeFormat:'清除格式',
			word:'word文档',
			clear:'清空',
			clearDocument:'清除内容？',
			ok:'确定',
			cancel:'取消',
			view:'预览',
			tip:'提示',
			link_URL:'链接地址',
			link_createLink:'创建链接',
			link_noTextTip:'请选择需要创建链接的文字！',
			link_noURLTip:'请输入链接地址！',
			link_title:'创建链接',
			image_title:'插入图片',
			image_upload:'上传',
			image_noURLTip:'请输入图片地址',
			image_noImgTip:'请选择图片',
			image_URL:'图片地址',
			color_title:'设置文本颜色'
		}
	}	
	return RTELang;
}

var rteLang=lwRTELang(languageid);

var lwRTE = function (textarea, options) {
	this.css		= [];
	this.css_class	= options.frame_class || '';
	this.base_url	= options.base_url || '';
	this.width		= options.width || $(textarea).width() || '100%';
	this.height		= options.height || $(textarea).height() || 350;
	this.iframe		= null;
	this.iframe_doc	= null;
	this.textarea	= null;
	this.event		= null;
	this.range		= null;
	this.toolbars	= {rte: '', html : ''};
	this.languageid   = options.languageid;
	this.controls	= {rte: {disable: {hint: rteLang.sourceEditor}}, html: {enable: {hint: rteLang.visualEditor}}};
	
	$.extend(this.controls.rte, options.controls_rte || {});
	$.extend(this.controls.html, options.controls_html || {});
	$.extend(this.css, options_wev8.css || {});

	if(document.designMode || document.contentEditable) {
		$(textarea).wrap($('<div></div>').addClass('rte-zone').width(this.width));		
		$('<div class="rte-resizer"><a href="#"></a></div>').insertAfter(textarea);

		var resizer = new lwRTE_resizer(textarea);
		
		$(".rte-resizer a", $(textarea).parents('.rte-zone')).mousedown(function(e) {
			$(document).mousemove(function(e) {
				return lwRTE_resizer.mousemove(resizer, e);
			});

			$(document).mouseup(function(e) {
				return lwRTE_resizer.mouseup(resizer, e)
			});

			return lwRTE_resizer.mousedown(resizer, e);
		});

		this.textarea	= textarea;
		this.enable_design_mode();
	}
}

lwRTE.prototype.editor_cmd = function(command, args) {
	this.iframe.contentWindow.focus();
	try {
		this.iframe_doc.execCommand(command, false, args);
	} catch(e) {
	}
	this.iframe.contentWindow.focus();
}

lwRTE.prototype.get_toolbar = function() {
	var editor = (this.iframe) ? $(this.iframe) : $(this.textarea);
	return (editor.prev().hasClass('rte-toolbar')) ? editor.prev() : null;
}

lwRTE.prototype.activate_toolbar = function(editor, tb) {
	var old_tb = this.get_toolbar();

	if(old_tb)
		old_tb.remove();

	$(editor).before($(tb).clone(true));
}
	
lwRTE.prototype.enable_design_mode = function() {
	var self = this;

	// need to be created this way
	self.iframe	= document.createElement("iframe");
	self.iframe.frameBorder = 0;
	self.iframe.frameMargin = 0;
	self.iframe.framePadding = 0;
	self.iframe.width = '100%';
	self.iframe.height = self.height || '100%';
	self.iframe.src	= "javascript:void(0);";

	if($(self.textarea).attr('class'))
		self.iframe.className = $(self.textarea).attr('class');

	if($(self.textarea).attr('id'))
		self.iframe.id = $(self.textarea).attr('id');

	if($(self.textarea).attr('name'))
		self.iframe.title = $(self.textarea).attr('name');

	var content	= $(self.textarea).val();

	$(self.textarea).hide().after(self.iframe).remove();
	self.textarea	= null;
	
	var css = '';
	
	for(var i in self_wev8.css)
		css += "<link type='text/css' rel='stylesheet' href='" + self.css[i] + "' />";

	var base = (self.base_url) ? "<base href='" + self.base_url + "' />" : '';
	var style = (self.css_class) ? "class='" + self.css_class + "'" : '';

	// Mozilla need this to display caret
	/*if($.trim(content) == '')
		content	= '<br>';*/

	var doc = "<html><head>" + base + css + "</head><body " + style + " style='padding:5px'>" + content + "</body></html>";

	self.iframe_doc	= self.iframe.contentWindow.document;

	try {
		self.iframe_doc.designMode = 'on';
	} catch ( e ) {
		// Will fail on Gecko if the editor is placed in an hidden container element
		// The design mode will be set ones the editor is focused
		$(self.iframe_doc).focus(function() { self.iframe_doc.designMode(); } );
	}

	self.iframe_doc.open();
	self.iframe_doc.write(doc);
	self.iframe_doc.close();

	if(!self.toolbars.rte)
		self.toolbars.rte	= self.create_toolbar(self.controls.rte);

	self.activate_toolbar(self.iframe, self.toolbars.rte);

	$(self.iframe).parents('form').submit( 
		function() { self.disable_design_mode(true); }
	);

	$(self.iframe_doc).mouseup(function(event) { 
		if(self.iframe_doc.selection)
			self.range = self.iframe_doc.selection.createRange();  //store to restore later(IE fix)

		self.set_selected_controls( (event.target) ? event.target : event.srcElement, self.controls.rte); 
	});

	$(self.iframe_doc).blur(function(event){ 
		if(self.iframe_doc.selection) 
			self.range = self.iframe_doc.selection.createRange(); // same fix for IE as above
	});
	$(self.iframe_doc).keyup(function(event) {
		if(event.keyCode==13){//换行时替换掉<P>&nbsp;</P> <p> </p>
			var html=$('body', self.iframe_doc).html();
			html=html.replace(/<P>&nbsp;<\/P>/g, "<br>");
			html=html.replace(/<P>/g, "");
			html=html.replace(/<\/P>/g,"");
			$('body', self.iframe_doc).html(html);
		}
		self.set_selected_controls( self.get_selected_element(), self.controls.rte);
		 });
	// Mozilla CSS styling off
	if(!$.browser.msie)
		self.editor_cmd('styleWithCSS', false);
}
    
lwRTE.prototype.disable_design_mode = function(submit) {
	var self = this;

	self.textarea = (submit) ? $('<input type="hidden" />').get(0) : $('<textarea></textarea>').width('100%').height(self.height).get(0);

	if(self.iframe.className)
		self.textarea.className = self.iframe.className;

	if(self.iframe.id)
		self.textarea.id = self.iframe.id;
		
	if(self.iframe.title)
		self.textarea.name = self.iframe.title;
	
	$(self.textarea).val($('body', self.iframe_doc).html());
	$(self.iframe).before(self.textarea);

	if(!self.toolbars.html)
		self.toolbars.html	= self.create_toolbar(self.controls.html);

	if(submit != true) {
		$(self.iframe_doc).remove(); //fix 'permission denied' bug in IE7 (jquery cache)
		$(self.iframe).remove();
		self.iframe = self.iframe_doc = null;
		self.activate_toolbar(self.textarea, self.toolbars.html);
	}
}
    
lwRTE.prototype.toolbar_click = function(obj, control) {
	var fn = control.exec;
	var args = control.args || [];
	var is_select = (obj.tagName.toUpperCase() == 'SELECT');
	
	$('.rte-panel', this.get_toolbar()).remove();

	if(fn) {
		if(is_select)
			args.push(obj);

		try {
			fn.apply(this, args);
		} catch(e) {

		}
	} else if(this.iframe && control.command) {
		if(is_select) {
			args = obj.options[obj.selectedIndex].value;

			if(args.length <= 0)
				return;
		}

		this.editor_cmd(control.command, args);
	}
}
	
lwRTE.prototype.create_toolbar = function(controls) {
	var self = this;
	var tb = $("<div></div>").addClass('rte-toolbar').width('100%').append($("<ul></ul>")).append($("<div></div>").addClass('clear'));
	var obj, li;
	
	for (var key in controls){
		if(controls[key].separator) {
			li = $("<li></li>").addClass('separator');
		} else {
			if(controls[key].init) {
				try {
					controls[key].init.apply(controls[key], [this]);
				} catch(e) {
				}
			}
			
			if(controls[key].select) {
				obj = $(controls[key].select)
					.change( function(e) {
						self.event = e;
						self.toolbar_click(this, controls[this.className]); 
						return false;
					});
			} else {
				//alert(controls[key].title);
				var title=controls[key].title;
				if(title==undefined)
				   title='bold';
				obj = $("<a href='#'></a>")
					.attr('title', (controls[key].hint) ? controls[key].hint :title)
					.attr('rel', key)
					.click( function(e) {
						self.event = e;
						self.toolbar_click(this, controls[this.rel]); 
						return false;
					})
			}

			li = $("<li></li>").append(obj.addClass(key));
		}

		$("ul",tb).append(li);
	}

	$('.enable', tb).click(function() {
		self.enable_design_mode();
		return false; 
	});

	$('.disable', tb).click(function() {
		self.disable_design_mode();
		return false; 
	});

	return tb.get(0);
}

lwRTE.prototype.create_panel = function(title, width) {
	var self = this;
	var tb = self.get_toolbar();

	if(!tb)
		return false;

	$('.rte-panel', tb).remove();
	var drag, event;
	var left = self.event.pageX;
	var top = self.event.pageY;
	
	var panel	= $('<div></div>').hide().addClass('rte-panel').css({left: left, top: top});
	$('<div></div>')
		.addClass('rte-panel-title')
		.html(title)
		.append($("<a class='close' href='#'>X</a>")
		.click( function() { panel.remove(); return false; }))
		.mousedown( function() { drag = true; return false; })
		.mouseup( function() { drag = false; return false; })
		.mousemove( 
			function(e) {
				if(drag && event) {
					left -= event.pageX - e.pageX;
					top -=  event.pageY - e.pageY;
					panel.css( {left: left, top: top} ); 
				}

				event = e;
				return false;
			} 
		)
		.appendTo(panel);

	if(width)
		panel.width(width);

	tb.append(panel);
	return panel;
}

lwRTE.prototype.get_content = function() {
	return (this.iframe) ? $('body', this.iframe_doc).html() : $(this.textarea).val();
}
//文本域获得输入焦点
lwRTE.prototype.set_focus = function() {
	try{
		this.iframe.contentWindow.focus();  //可视模式下
	}catch(e){
		this.textarea.focus();              //源码模式下
	}	
}

lwRTE.prototype.set_content = function(content) {
	(this.iframe) ? $('body', this.iframe_doc).html(content) : $(this.textarea).val(content);
}

lwRTE.prototype.set_selected_controls = function(node, controls) {
	var toolbar = this.get_toolbar();
    
	if(!toolbar)
		return false;
		
	var key, i_node, obj, control, tag, i, value;

	try {
		for (key in controls) {
			control = controls[key];
			obj = $('.' + key, toolbar);

			obj.removeClass('active');

			if(!control.tags)
				continue;

			i_node = node;
			do {
				if(i_node.nodeType != 1)
					continue;
                
				tag	= i_node.nodeName.toLowerCase();
				if($.inArray(tag, control.tags) < 0 )
					continue;

				if(control.select) {
					obj = obj.get(0);
					if(obj.tagName.toUpperCase() == 'SELECT') {
						obj.selectedIndex = 0;

						for(i = 0; i < obj.options.length; i++) {
							value = obj.options[i].value;
							if(value && ((control.tag_cmp && control.tag_cmp(i_node, value)) || tag == value)) {
								obj.selectedIndex = i;
								break;
							}
						}
					}
				} else
					obj.addClass('active');
			}  while(i_node = i_node.parentNode)
		}
	} catch(e) {
	}
	
	return true;
}

lwRTE.prototype.get_selected_element = function () {
	var node, selection, range;
	var iframe_win	= this.iframe.contentWindow;
	
	if (iframe_win.getSelection) {
		try {
			selection = iframe_win.getSelection();
			range = selection.getRangeAt(0);
			node = range.commonAncestorContainer;
		} catch(e){
			return false;
		}
	} else {
		try {
			selection = iframe_win.document.selection;
			range = selection.createRange();
			node = range.parentElement();
		} catch (e) {
			return false;
		}
	}
	return node;
}

lwRTE.prototype.get_selection_range = function() {
	var rng	= null;
	var iframe_window = this.iframe.contentWindow;
	this.iframe.focus();
	
	if(iframe_window.getSelection) {
		rng = iframe_window.getSelection().getRangeAt(0);
		if($.browser.opera) { //v9.63 tested only
			var s = rng.startContainer;
			if(s.nodeType === Node.TEXT_NODE)
				rng.setStartBefore(s.parentNode);
		}
	} else {
		this.range.select(); //Restore selection, if IE lost focus.
		rng = this.iframe_doc.selection.createRange();
	}

	return rng;
}

lwRTE.prototype.get_selected_text = function() {
	var iframe_win = this.iframe.contentWindow;

	if(iframe_win.getSelection)	
		return iframe_win.getSelection().toString();

	//this.range.select(); //Restore selection, if IE lost focus.
	return iframe_win.document.selection.createRange().text;
};

lwRTE.prototype.get_selected_html = function() {
	var html = null;
	var iframe_window = this.iframe.contentWindow;
	var rng	= this.get_selection_range();

	if(rng) {
		if(iframe_window.getSelection) {
			var e = document.createElement('div');
			e.appendChild(rng.cloneContents());
			html = e.innerHTML;		
		} else {
			html = rng.htmlText;
		}
	}

	return html;
};
	
lwRTE.prototype.selection_replace_with = function(html) {
	var rng	= this.get_selection_range();
	var iframe_window = this.iframe.contentWindow;

	if(!rng)
		return;
	
	this.editor_cmd('removeFormat'); // we must remove formating or we will get empty format tags!

	if(iframe_window.getSelection) {
		rng.deleteContents();
		rng.insertNode(rng.createContextualFragment(html));
		this.editor_cmd('delete');
	} else {
		this.editor_cmd('delete');
		rng.pasteHTML(html);
	}
}



