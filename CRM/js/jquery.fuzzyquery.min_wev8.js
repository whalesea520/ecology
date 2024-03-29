﻿(function($) {
	$.fn.FuzzyQuery = function(options) {
		var defaults = {
			record_num: 10,
			filed_name: "name",
			searchtype: "hrm",
			currentid:""
		};
		this.options = $.extend(defaults, options);
		this.selectedRowIndex = -1;
		var me = this;
		this._filed_name = this.options.filed_name;
		var _recordNum = this.options.record_num;
		var searchtype = this.options.searchtype;
		var divwidth = this.options.divwidth;
		var updatename = this.options.updatename;
		var updatetype = this.options.updatetype;
		var currentid = this.options.currentid;
		var operate = this.options.operate;
		this.createUrl = function() {
			var url = this.options.url;
			if (url.indexOf("?") < 0) {
				url += "?record_num=" + _recordNum
			} else {
				url += "&record_num=" + _recordNum
			}
			for (var p in this.options.params) {
				url += "&" + p + "=" + this.options.params[p]
			}
			return url
		};
		this.blur(function() {
			if (me.show_panel) {
				setTimeout(function() {
					me.show_panel.hide()
				},
				50)
			}
			$(me).nextAll(".btn_add").hide();$(me).nextAll(".btn_browser").hide();
		});
		this.keydown(function(event) {
			this.oldValue = this.value
		});
		this.keyup(function(event) {
			var keyCode = event.keyCode;
			if (keyCode == 40) {
				me.next_row()
			} else if (keyCode == 38) {
				me.previous_row()
			} else if (keyCode == 13) {
				me.confirm_row()
			} else {
				if (this.oldValue != this.value) {
					me.startQuery();
					me.get(0).row_data = undefined;
					this.selected = false
				}
			}
		});
		this.startQuery = function() {
			if (this.options.data) {
				this.screening_LocalData();
				this.createQueryPanel()
			} else {
				var me = this;
				if(this.val()!=""){
					me.createLoadPanel();
					var url = this.createUrl();
					var keyword = this.val().replace(/\+/g,"%2B").replace(/\&/g,"%26");
					url += "&key_word=" + keyword + "&searchtype=" + searchtype + "&currentid=" + currentid;
					$.ajax({
						url: url,
						async: true,
						cache: false,
						complete: function(XMLHttpRequest, textStatus) {
							var callbackStr = XMLHttpRequest.responseText;
							if(callbackStr.replace(/^\s*|\s*$/,'')!=""){
								//alert(callbackStr);
								var rows = eval("(" + callbackStr + ")");
								me.valid_data = rows;
								me.createQueryPanel();
							}else{
								me.valid_data = null;
								me.createQueryPanel();
							}
						}
					})
				}else{
					if(me.show_panel != null){
						me.show_panel.hide();
					}
				}
				
			}
		};
		this.screening_LocalData = function() {
			var _c_value = this.val();
			var _maxNum = this.options.record_num;
			var _t_data = this.options.data;
			var _valid_data = [];
			var _t_obj;
			for (var i = 0; i < _t_data.length; i++) {
				if (_valid_data.length >= _maxNum) {
					break
				}
				_t_obj = _t_data[i];
				if (_t_obj[this._filed_name].indexOf(_c_value) >= 0) {
					_valid_data.push(_t_obj)
				}
			}
			this.valid_data = _valid_data
		};
		this.createLoadPanel = function() {
			this.selectedRowIndex = -1;
			var me = this;
			var div;
			if (!this.show_panel) {
				div = $("<div/>");
				div.attr("id", "fuzzyquery_query_div");
				div.addClass("fuzzyquery_query_div");
				var top = $("#"+updatename).offset().top;
				div.show = function() {
					me.bindQueryAnimation(true);
					me.switchDisplayFloor(true)
				};
				div.hide = function() {
					me.bindQueryAnimation(false);
					me.switchDisplayFloor(false)
				}
			} else {
				div = this.show_panel;
				div.html("")
			}
			this.show_panel = div;
			var top = $("#"+updatename).offset().top;
			var num = 1;
			var _valid_data = this.valid_data;
			if(_valid_data!=null){num = _valid_data.length;}
			if((top+num*24)>$("#main").height()){
				//this.show_panel.css("top","auto");
				//this.show_panel.css("bottom",$("#main").height()-$("#"+updatename).offset().top);
				
				this.show_panel.css("top",$("#"+updatename).offset().top-num*24+4);
				this.show_panel.css("bottom","auto");
			}else{
				this.show_panel.css("top",$("#"+updatename).offset().top+$("#"+updatename).height()+4);
				this.show_panel.css("bottom","auto");
			}
			this.show_panel.css({"width":divwidth,"left":$("#"+updatename).offset().left});
			$("body").get(0).appendChild(div.get(0));
			this.show_panel.show();
			var tab = $("<table>");
			tab.addClass("fuzzyquery_query_tab");
			var div2 = $("<div/>");
			div2.addClass("fuzzyquery_main_div");
			div2.addClass("fuzzyquery_load");
			div2.append(tab);
			div.append(div2);
			$("body").append(div);
		};
		this.createQueryPanel = function() {
			this.selectedRowIndex = -1;
			var me = this;
			var _valid_data = this.valid_data;
			var div;
			if (!this.show_panel) {
				div = $("<div/>");
				div.attr("id", "fuzzyquery_query_div");
				div.addClass("fuzzyquery_query_div");
				//div.css({"width":divwidth,"top":$("#"+updatename).offset().top + 25,"left":$("#"+updatename).offset().left});
				
				div.show = function() {
					me.bindQueryAnimation(true);
					me.switchDisplayFloor(true)
				};
				div.hide = function() {
					me.bindQueryAnimation(false);
					me.switchDisplayFloor(false)
				}
			} else {
				div = this.show_panel;
				div.html("")
			}
			this.show_panel = div;
			
			var top = $("#"+updatename).offset().top;
			var num = 1;
			if(_valid_data!=null){num = _valid_data.length;}
			if((top+num*24)>$("#main").height()){
				//this.show_panel.css("top","auto");
				//this.show_panel.css("bottom",$("#main").height()-$("#"+updatename).offset().top);
				
				this.show_panel.css("top",$("#"+updatename).offset().top-num*24+4);
				this.show_panel.css("bottom","auto");
			}else{
				this.show_panel.css("top",$("#"+updatename).offset().top+$("#"+updatename).height()+4);
				this.show_panel.css("bottom","auto");
			}
			this.show_panel.css({"width":divwidth,"left":$("#"+updatename).offset().left});
			//if (_valid_data.length <= 0) {
			//	div.html("");
			//	div.hide();
			//	return
			//}
			$("body").get(0).appendChild(div.get(0));
			//div.width(this.outerWidth(true));
			//div.get(0).style.left = this.position().left -2;
			//div.get(0).style.top = this.position().top + this.outerHeight(true) -3;
			this.show_panel.show();
			if (_valid_data == null) {
				div.html("<div style='height:20px;line-height:22px;color:#C0C0C0;padding-left:10px;'>无</div>");
				$("body").append(div);
				return;
			}
			var tab = $("<table cellspacing='0' cellpadding='0' border='0'>");
			if(searchtype=="search" || searchtype=="search1"){
				tab.addClass("fuzzyquery_query_tab2");
			}else{
				tab.addClass("fuzzyquery_query_tab");
			}
			
			var div2 = $("<div/>");
			div2.addClass("fuzzyquery_main_div");
			div2.append(tab);
			div.append(div2);
			$("body").append(div);
			var obj, tr, td;
			for (var i = 0; i < _valid_data.length; i++) {
				obj = _valid_data[i];
				tr = $("<tr/>");
				
					tr.attributes = obj.attributes || {};
					tr.attr("field_text", obj[this._filed_name]);
					tr.attr("field_value", obj[this._filed_name]);
					tr.attr("id", "str"+obj["id"]);
					
					if(updatename=="objname" && searchtype=="search" && obj["type"]==1){
						tr.attr("title", obj[this._filed_name]+"-->"+obj["crmname"]);
					}else{
						tr.attr("title", obj[this._filed_name]);
					}
					tr.get(0).row_data = obj;
					td = $("<td>" + obj[this._filed_name] + "</td>");
					
					if(updatename=="objname" && searchtype=="search" && obj["type"]==1){
						td = $("<td>" + obj[this._filed_name]+"--><font style='color:#B3B3B3;font-family:微软雅黑'>"+obj["crmname"]+"</font</td>");
					}else{
						td = $("<td>" + obj[this._filed_name] + "</td>");
					}
					
					tr.append(td);
					if(searchtype=="task"||searchtype=="search"||searchtype=="search1"){
						td = $("<td class='t_status'>" + obj["status"] + "</td>");
						tr.append(td);
					}
					tr.hover(function() {
						me.selectedRowIndex = this.rowIndex;
						$(this).addClass("fuzzyquery_query_row_hover")
					},
					function() {
						$(this).removeClass("fuzzyquery_query_row_hover")
					});
					tr.bind("click",
					function() {
						var _row_data = this.row_data;
						me.val(_row_data[me._filed_name]);
						//alert(_row_data["id"]);
						//$("#hrmId").val(_row_data["id"]);
						me.get(0).row_data = _row_data;
						me.show_panel.hide();
						me[0].selected = true;
						this.selectedRowIndex = -1;
						//alert(_row_data["type"]);
						//searchDetail(_row_data["type"],_row_data["id"]);
						if(updatename=="objname"){
							if(searchtype=="subhrm"){
								doClick(_row_data["id"],null,null,_row_data["name"],_row_data["ismanager"]);
							}else{
								if(_row_data["type"]==2){
									searchList(_row_data["id"],_row_data["name"],_row_data["ismanager"]);
								}else{
									//loadDetail(_row_data["id"],_row_data["name"]);
									searchDetail(_row_data["id"],_row_data["crmid"],_row_data["lastdate"],_row_data["name"]);
								}
							}
							
						}else if(updatename=="agent"||updatename=="manager"||operate=="select"){
							//me.val(_row_data["name"]);
							doSelectUpdate(updatename,_row_data["id"],_row_data["name"]);
						}else{
							selectUpdate(updatename,_row_data["id"],_row_data["name"],updatetype);
						}
						me.blur();
					});
				tab.append(tr)
			}
				
			//this.createUnderstratum(div)
		};
		this.createUnderstratum = function(p) {
			var iframe;
			if (!this.iframe_floor) {
				iframe = $("<iframe src='javascript:void(0);'></iframe>");
				this.iframe_floor = iframe;
				$("body").append(iframe)
			} else {
				iframe = this.iframe_floor;
				iframe.css("display:", "block")
			}
			iframe.addClass("fuzzyquery-floor");
			iframe.height(p.height());
			//iframe.width(p.width());
			//iframe.get(0).style.top = this.offset().top + this.outerHeight(true);
			//iframe.get(0).style.left = this.offset().left
		};
		this.switchDisplayFloor = function(isShow) {
			if (!this.iframe_floor) {
				return
			}
			var displayStr = isShow ? "block": "none";
			this.iframe_floor.css("display", displayStr)
		};
		this.previous_row = function() {
			if (!this.show_panel || !this.show_panel.children()) {
				return
			}
			var _tab = this.show_panel.children();
			var _rows = _tab.find("tr");
			if (this.selectedRowIndex <= 0) {
				this.selectedRowIndex = _rows.length
			}
			_rows.each(function(i) {
				$(this).removeClass("fuzzyquery_query_row_hover")
			});
			var _c_row = _rows[this.selectedRowIndex - 1];
			while($(_c_row).attr("id")==""){
				this.selectedRowIndex--;
				if (this.selectedRowIndex <= 0) {
					this.selectedRowIndex = _rows.length
				}
				_c_row = _rows[this.selectedRowIndex - 1];
			}
			$(_c_row).addClass("fuzzyquery_query_row_hover");
			this.selectedRow = _c_row;
			//this.val($(_c_row).attr("field_value"));
			//$("#hrmId").val($(_c_row).attr("id"));//设置ID
			this.get(0).selected = true;
			this.selectedRowIndex--;
			
			if(updatename=="tag"){
				me.val($(_c_row).children().html());
			}
			/**
			while($(_c_row).offset().top<95){
				var st = $(".fuzzyquery_main_div").attr("scrollTop");
				$(".fuzzyquery_main_div").attr("scrollTop",st-20);
			}
			while($(_c_row).offset().top>256){
				var st = $(".fuzzyquery_main_div").attr("scrollTop");
				$(".fuzzyquery_main_div").attr("scrollTop",st+20);
			}*/
		};
		this.next_row = function() {
			if (!this.show_panel || !this.show_panel.children()) {
				return
			}
			var _tab = this.show_panel.children();
			var _rows = _tab.find("tr");
			if (this.selectedRowIndex >= _rows.length - 1) {
				this.selectedRowIndex = -1
			}
			_rows.each(function(i) {
				$(this).removeClass("fuzzyquery_query_row_hover")
			});
			var _c_row = _rows[this.selectedRowIndex + 1];
			while($(_c_row).attr("id")==""){
				this.selectedRowIndex++;
				if (this.selectedRowIndex >= _rows.length - 1) {
					this.selectedRowIndex = -1
				}
				_c_row = _rows[this.selectedRowIndex + 1];
			}
			$(_c_row).addClass("fuzzyquery_query_row_hover");
			this.selectedRow = _c_row;
			//this.val($(_c_row).attr("field_value"));
			//$("#hrmId").val($(_c_row).attr("id"));//设置ID
			this.get(0).selected = true;
			this.selectedRowIndex++;
			
			if(updatename=="tag"){
				me.val($(_c_row).children().html());
			}
			/**
			while($(_c_row).offset().top>256){
				var st = $(".fuzzyquery_main_div").attr("scrollTop");
				$(".fuzzyquery_main_div").attr("scrollTop",st+20);
			}
			while($(_c_row).offset().top<95){
				var st = $(".fuzzyquery_main_div").attr("scrollTop");
				$(".fuzzyquery_main_div").attr("scrollTop",st-20);
			}*/
			//alert($(_c_row).offset().top);
			//alert($(".fuzzyquery_main_div").attr("scrollTop"));
		};
		this.confirm_row = function() {
			if (!this.show_panel) {
				return
			}
			var _tab = this.show_panel.children();
			var _rows = _tab.find("tr");
			if (_rows.length <= 0 || !_rows[this.selectedRowIndex]) {
				return
			}
			var _row_data = _rows[this.selectedRowIndex].row_data;
			//this.val(_row_data[this._filed_name]);
			//$("#hrmId").val(_row_data["id"]);//设置ID
			this.get(0).row_data = _row_data;
			this.get(0).selected = true;
			this.selectedRowIndex = -1;
			this.show_panel.hide()
			
			if(updatename=="objname"){
				if(searchtype=="subhrm"){
					doClick(_row_data["id"],null,null,_row_data["name"],_row_data["ismanager"]);
				}else{
					if(_row_data["type"]==2){
						searchList(_row_data["id"],_row_data["name"],_row_data["ismanager"]);
					}else{
						//loadDetail(_row_data["id"],_row_data["name"]);
						searchDetail(_row_data["id"],_row_data["crmid"],_row_data["lastdate"],_row_data["name"]);
					}
				}
			}else if(updatename=="agent"||updatename=="manager"||operate=="select"){
				//me.val(_row_data["name"]);
				doSelectUpdate(updatename,_row_data["id"],_row_data["name"]);
			}else{
				selectUpdate(updatename,_row_data["id"],_row_data["name"],updatetype);
			}
			me.blur();
		};
		this.bindQueryAnimation = function(show) {
			var animation = this.options.animation || "slide";
			if (animation == "slide") {
				this.bind_slide(show)
			} else if (animation == "fade") {
				bind_fade(show)
			}
		};
		this.bind_slide = function(show) {
			if (show) {
				this.show_panel.slideDown("fast",
				function() {})
			} else {
				this.show_panel.slideUp("fast",
				function() {})
			}
		};
		this.bind_fade = function(show) {
			var me = this;
			if (show) {
				this.show_panel.fadeIn("fast",
				function() {
					alert(this.c_left)
				})
			} else {
				this.show_panel.fadeOut("fast",
				function() {})
			}
		}
	}
})(jQuery);