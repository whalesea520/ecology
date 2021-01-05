/*!
 * jQuery Selectbox plugin 0.2
 *
 * Copyright 2011-2012, Dimitar Ivanov (http://www.bulgaria-web-developers.com/projects/javascript/selectbox/)
 * Licensed under the MIT (http://www.opensource.org/licenses/mit-license.php) license.
 * 
 * Date: Tue Jul 17 19:58:36 2012 +0300
 */
(function ($, undefined) {
	var PROP_NAME = 'selectbox',
		FALSE = false,
		TRUE = true;
	/**
	 * Selectbox manager.
	 * Use the singleton instance of this class, $.selectbox, to interact with the select box.
	 * Settings for (groups of) select boxes are maintained in an instance object,
	 * allowing multiple different settings on the same page
	 */
	function Selectbox() {
		this._state = [];
		this._defaults = { // Global defaults for all the select box instances
			classHolder: "sbHolder",
			classHolderDisabled: "sbHolderDisabled",
			classSelector: "sbSelector",
			classOptions: "sbOptions",
			classGroup: "sbGroup", 
			classSub: "sbSub",
			classDisabled: "sbDisabled",
			classToggleOpen: "sbToggleOpen",
			classToggle: "sbToggle",
			classFocus: "sbFocus",
			speed: 200,
			effect: "slide", // "slide" or "fade"
			onChange: null, //Define a callback function when the selectbox is changed
			onOpen: null, //Define a callback function when the selectbox is open
			onClose: null //Define a callback function when the selectbox is closed
		};
	}
	
	$.extend(Selectbox.prototype, {
		/**
		 * Is the first field in a jQuery collection open as a selectbox
		 * 
		 * @param {Object} target
		 * @return {Boolean}
		 */
		_isOpenSelectbox: function (target) {
			if (!target) {
				return FALSE;
			}
			var inst = this._getInst(target);
			return inst.isOpen;
		},
		/**
		 * Is the first field in a jQuery collection disabled as a selectbox
		 * 
		 * @param {HTMLElement} target
		 * @return {Boolean}
		 */
		_isDisabledSelectbox: function (target) {
			if (!target) {
				return FALSE;
			}
			var inst = this._getInst(target);
			return inst.isDisabled;
		},
		
		/**
		 * Disable the selectbox.
		 * 
		 * @param {HTMLElement} target
		 */
		_disableSelectbox: function (target) {
			var inst = this._getInst(target);
			if (!inst || inst.isDisabled) {
				return FALSE;
			}
			$("#sbHolder_" + inst.uid).addClass(inst.settings.classHolderDisabled);
			inst.isDisabled = TRUE;
			$.data(target, PROP_NAME, inst);
		},
		
		/**
		 * Attach the select box to a jQuery selection.
		 * 
		 * @param {HTMLElement} target
		 * @param {Object} settings
		 */
		_attachSelectbox: function (target, settings) {
			if (this._getInst(target)) {
				return FALSE;
			}
			var $target = $(target),
				self = this,
				inst = self._newInst($target),
				sbHolder, sbSelector, sbToggle, sbOptions, sbPerfectBar,
				s = FALSE, optGroup = $target.find("optgroup"), opts = $target.find("option"), olen = opts.length;
				
			$target.attr("sb", inst.uid);
			
			var disabled = $target.attr("disabled");


			var tarwidth=$target.width();
			if(!tarwidth){
				tarwidth = $target.css("width");
			}else{
				if(tarwidth<30){
					tarwidth = "60%";
				}else{
					tarwidth = ""+(tarwidth-4);
				}
			}
            if(!tarwidth || tarwidth=="0px")
            	tarwidth="120";

            var targetname=$target.attr("name");
            var display=$target.css("display")==='none'?'none':'inline-block' ;
				
			$.extend(inst.settings, self._defaults, settings);
			self._state[inst.uid] = FALSE;

            if(display==='none')
                $target.attr("ishide",'1');

			$target.hide();
			
			function closeOthers() {
				var key, sel,
					uid = this.attr("id").split("_")[1];
				for (key in self._state) {
					if (key !== uid) {
						if (self._state.hasOwnProperty(key)) {
							sel = $("select[sb='" + key + "']")[0];
							if (sel) {
								self._closeSelectbox(sel);
							}
						}
					}
				}
			}
			
			var sbHolderCss={};
            sbHolderCss.width="100%";
            sbHolderCss.display=display;
      
	        if($target.css("float")!=='none')
            sbHolderCss.float=$target.css("float");
   			
   			var _tarwidth = "";
   			if(!!tarwidth && tarwidth.indexOf("%")==-1 && tarwidth.indexOf("px")==-1){
   				_tarwidth = tarwidth+"px";
   			}else{
   				_tarwidth = tarwidth;
   			}
   			
   			sbHolderSpan = $("<span>", {
				"id": "sbHolderSpan_" + inst.uid,
				"css":{
					"display":display,
					"width":'100%',
					"float":$target.css("float")||"none"
				}
			});

			sbHolder = $("<div>", {
				"id": "sbHolder_" + inst.uid,
				"class": inst.settings.classHolder+"  weatable_"+targetname+" holderitem",
				"tabindex": $target.attr("tabindex"),
				"css":sbHolderCss
			});
			
			if(disabled){
				sbHolder.addClass(inst.settings.classHolderDisabled);
				inst.isDisabled = TRUE;
				$.data(target, PROP_NAME, inst);
			}
			
			sbPerfectBar = $("<div>", {
				"css":{
				 "width":"100%",
                 "display":"none",
                 "id":"sbPerfectBar_"+inst.uid
				},
				"class":"sbPerfectBar"
			});
			
			sbSelector = $("<a>", {
				"id": "sbSelector_" + inst.uid,
				"href": "#",
				"class": inst.settings.classSelector,
				"css":{
				 "width":(tarwidth-30)+"px"
				}
			});
			
			sbSelector.bind("click",function(e){
				e.preventDefault();
				closeOthers.apply($(this), []);
				var uid = $(this).attr("id").split("_")[1];
				if (self._state[uid]  &&  $("#sbOptions_"+uid).is(":visible")) {
					self._closeSelectbox(target);
				} else {
					self._openSelectbox(target);
				}
			});
			
			sbToggle = $("<a>", {
				"id": "sbToggle_" + inst.uid,
				"href": "#",
				"class": inst.settings.classToggle
			});
			
			sbToggle.bind("click",function(e){
				e.preventDefault();
				closeOthers.apply($(this), []);
				var uid = $(this).attr("id").split("_")[1];
				if (self._state[uid]  ||  $(".sbOptions_"+uid).is(":visible"))  {
					self._closeSelectbox(target);
				} else {
					self._openSelectbox(target);
				}
			});
			
			sbToggle.appendTo(sbHolder);

			sbOptions = $("<ol>", {
				"id": "sbOptions_" + inst.uid,
				"class": inst.settings.classOptions,
				"css": {
					"display": "inline-block",
					"width":'100%'
				}
			});
			
			$target.children().each(function(i) {
				var that = $(this), li, config = {};
				if (that.is("option")) {
					getOptions(that);
				} else if (that.is("optgroup")) {
					li = $("<li>");
					$("<span>", {
						"text": that.attr("label")
					}).addClass(inst.settings.classGroup).appendTo(li);
					li.appendTo(sbOptions);
					if (that.is(":disabled")) {
						config.disabled = true;
					}
					config.sub = true;
					getOptions(that.find("option"), config);
				}
			});
			
			function getOptions () {
				var sub = arguments[1] && arguments[1].sub ? true : false,
					disabled = arguments[1] && arguments[1].disabled ? true : false;
				arguments[0].each(function (i) {
					var that = $(this),
						li = $("<li>"),
						child;
					if (that.is(":selected")) {
						sbSelector.text(that.text());
						sbSelector.attr("title",that.text());
						s = TRUE;
					}
					if (i === olen - 1) {
						li.addClass("last");
					}
					if (!that.is(":disabled") && !disabled) {
						child = $("<a>", {
							"href": "#" + that.val(),
							"rel": that.val(),
							"title":that.text()
						}).text(that.text()).bind("mousedown.sb", function (e) {
							var evt = e || window.event;
							evt.preventDefault();
							var t = sbToggle,
							 	$this = $(this),
								uid = t.attr("id").split("_")[1];
							self._changeSelectbox(target, $this.attr("rel"), $this.text());
							self._closeSelectbox(target);
							evt.stopPropagation();
						}).bind("mouseover.sb", function () {
							var $this = $(this);
							$this.parent().siblings().find("a").removeClass(inst.settings.classFocus);
							$this.addClass(inst.settings.classFocus);
						}).bind("mouseout.sb", function () {
							$(this).removeClass(inst.settings.classFocus);
						});
						if (sub) {
							child.addClass(inst.settings.classSub);
						}
						if (that.is(":selected")) {
							child.addClass(inst.settings.classFocus);
						}
						child.appendTo(li);
					} else {
						child = $("<span>", {
							"text": that.text()
						}).addClass(inst.settings.classDisabled);
						if (sub) {
							child.addClass(inst.settings.classSub);
						}
						child.appendTo(li);
					}
					li.appendTo(sbOptions);
				});
			}
			
			if (!s) {
				sbSelector.text(opts.first().text());
				sbSelector.attr("title",opts.first().text());
			}

			$.data(target, PROP_NAME, inst);
			
			sbHolder.data("uid", inst.uid).bind("keydown.sb", function (e) {
				try{
				var key = e.charCode ? e.charCode : e.keyCode ? e.keyCode : 0,
					$this = $(this),
					uid = $this.data("uid"),
					inst = $this.siblings("select[sb='"+uid+"']").data(PROP_NAME),
					trgt = $this.siblings(["select[sb='", uid, "']"].join("")).get(0),
					$f = $this.find("ol").find("a." + inst.settings.classFocus);
				switch (key) {
					case 37: //Arrow Left
					case 38: //Arrow Up
						if ($f.length > 0) {
							var $next;
							$("a", $this).removeClass(inst.settings.classFocus);
							$next = $f.parent().prevAll("li:has(a)").eq(0).find("a");
							if ($next.length > 0) {
								$next.addClass(inst.settings.classFocus).focus();
								$("#sbSelector_" + uid).text($next.text());
								$("#sbSelector_" + uid).attr("title",$next.text());
							}
						}
						break;
					case 39: //Arrow Right
					case 40: //Arrow Down
						var $next;
						$("a", $this).removeClass(inst.settings.classFocus);
						if ($f.length > 0) {
							$next = $f.parent().nextAll("li:has(a)").eq(0).find("a");
						} else {
							$next = $this.find("ol").find("a").eq(0);
						}
						if ($next.length > 0) {
							$next.addClass(inst.settings.classFocus).focus();
							$("#sbSelector_" + uid).text($next.text());
							$("#sbSelector_" + uid).attr("title",$next.text());
						}
						break;				
					case 13: //Enter
						if ($f.length > 0) {
							self._changeSelectbox(trgt, $f.attr("rel"), $f.text());
						}
						self._closeSelectbox(trgt);
						break;
					case 9: //Tab
						if (trgt) {
							var inst = self._getInst(trgt);
							if (inst/* && inst.isOpen*/) {
								if ($f.length > 0) {
									self._changeSelectbox(trgt, $f.attr("rel"), $f.text());
								}
								self._closeSelectbox(trgt);
							}
						}
						var i = parseInt($this.attr("tabindex"), 10);
						if (!e.shiftKey) {
							i++;
						} else {
							i--;
						}
						$("*[tabindex='" + i + "']").focus();
						break;
					case 27: //Escape
						self._closeSelectbox(trgt);
						break;
				}
				e.stopPropagation();
				return false;
			}catch(e){
			}
			}).delegate("a", "mouseover", function (e) {
				$(this).addClass(inst.settings.classFocus);
			}).delegate("a", "mouseout", function (e) {
				$(this).removeClass(inst.settings.classFocus);	
			});
			
			sbSelector.appendTo(sbHolder);
			sbOptions.appendTo(sbPerfectBar);
			var outDiv = jQuery("<div></div>").css({
				"overflow":"visible",
			    "z-index": "10002",
				"position": "absolute",
				"left": "0",
				"top":"1"
			});
			outDiv.css("top","1px");
			sbPerfectBar.appendTo(outDiv);
			outDiv.appendTo(document.body);	
			sbHolder.appendTo(sbHolderSpan);		
			sbHolderSpan.insertAfter($target);
			try{
				sbPerfectBar.perfectScrollbar();
			}catch(e){
				if(window.console)console.log("/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js");
			}
			
			$("html").live('mousedown', function(e) {
				e.stopPropagation();          
				$("select").selectbox('close'); 
			});
			$([".", inst.settings.classHolder, ", .", inst.settings.classSelector].join("")).mousedown(function(e) {    
				e.stopPropagation();
			});
		},
		/**
		 * Remove the selectbox functionality completely. This will return the element back to its pre-init state.
		 * 
		 * @param {HTMLElement} target
		 */
		_detachSelectbox: function (target) {
			var inst = this._getInst(target);
			if (!inst) {
				return FALSE;
			}
			$("#sbHolderSpan_" + inst.uid).remove();
			$("#sbOptions_"+inst.uid).parent().parent().remove();
			$.data(target, PROP_NAME, null);
			$(target).show();			
		},
		
		/**
		* Hide the selecbox
		*/
		_hideSelectbox: function (target){
			var inst = this._getInst(target);
			if (!inst) {
				return FALSE;
			}
			$("#sbHolderSpan_" + inst.uid).hide();
			$("#sbOptions_"+inst.uid).parent().parent().hide();
		},
		
		/**
		*Show the selecbox
		*/
		_showSelectbox:function(target){
			var inst = this._getInst(target);
			if (!inst) {
				return FALSE;
			}
			$("#sbHolderSpan_" + inst.uid).css("display","inline-block");
			$("#sbHolder_" + inst.uid).show();
			$("#sbOptions_"+inst.uid).parent().parent().show();
		},
		
		/**
		*toggle the selectbox
		*/
		_toggleSelectbox:function(target){
			var inst = this._getInst(target);
			if (!inst) {
				return FALSE;
			}
			$("#sbHolderSpan_" + inst.uid).toggle();
			$("#sbHolder_" + inst.uid).show();
			$("#sbOptions_"+inst.uid).parent().parent().toggle();
		},
		
		/**
		 * Change selected attribute of the selectbox.
		 * 
		 * @param {HTMLElement} target
		 * @param {String} value
		 * @param {String} text
		 */
		_changeSelectbox: function (target, value, text) {
			var onChange,
				inst = this._getInst(target);
			if (inst) {
				onChange = this._get(inst, 'onChange');
				$("#sbSelector_" + inst.uid).text(text);
				$("#sbSelector_" + inst.uid).attr("title",text);
			}
			value = value.replace(/\'/g, "\\'");
			if(!value){
				$(target).find("option:first").attr("selected", TRUE);
			}else{
				$(target).find("option[value='" + value + "']").attr("selected", TRUE);
			}
			if (inst && onChange) {
				onChange.apply((inst.input ? inst.input[0] : null), [value, inst]);
			} else if (inst && inst.input) {
				inst.input.trigger('change');
			}
		},
		/**
		 * Enable the selectbox.
		 * 
		 * @param {HTMLElement} target
		 */
		_enableSelectbox: function (target) {
			var inst = this._getInst(target);
			if (!inst || !inst.isDisabled) {
				return FALSE;
			}
			$("#sbHolder_" + inst.uid).removeClass(inst.settings.classHolderDisabled);
			inst.isDisabled = FALSE;
			$.data(target, PROP_NAME, inst);
		},
		/**
		 * Get or set any selectbox option. If no value is specified, will act as a getter.
		 * 
		 * @param {HTMLElement} target
		 * @param {String} name
		 * @param {Object} value
		 */
		_optionSelectbox: function (target, name, value) {
			var inst = this._getInst(target);
			if (!inst) {
				return FALSE;
			}
			//TODO check name
			inst[name] = value;
			$.data(target, PROP_NAME, inst);
		},
		/**
		 * Call up attached selectbox
		 * 
		 * @param {HTMLElement} target
		 */
		_openSelectbox: function (target) {
			var inst = this._getInst(target);
			//if (!inst || this._state[inst.uid] || inst.isDisabled) {
			if (!inst || inst.isOpen || inst.isDisabled) {
				return;
			}
			var	el = $("#sbOptions_" + inst.uid);
			var parent = el.parent("div"),
			viewportHeight = parseInt($(window).height(), 10),
			offset = $("#sbHolder_" + inst.uid).offset(),
			position= $("#sbHolder_" + inst.uid).position(),
			width = $("#sbHolder_" + inst.uid).width(),
			scrollTop = $(window).scrollTop(),
			height = parent.prev().height(),
			diff = viewportHeight - (offset.top - scrollTop) - height / 2,
			optionsHeight = el.children("li").length*30,
			topHeight = offset.top,
			bottomHeight = viewportHeight-(offset.top-scrollTop) - $("#sbHolder_" + inst.uid).height()-1,
			maxHeight = bottomHeight,
			upDirect = false;
			if(bottomHeight>optionsHeight || bottomHeight>topHeight){
				//maxHeight = bottomHeight-5;
				if(bottomHeight>186)
				maxHeight=186;
				else
                maxHeight=bottomHeight-5;
			}else{
				maxHeight = 186;
				upDirect = true;
			}
			onOpen = this._get(inst, 'onOpen');
			//var parents = $("#sbHolder_" + inst.uid).parents(".LayoutTable");
			//var maxHeight = parents.eq(parents.length-1).height()-height;
			//if(!maxHeight||maxHeight<0)maxHeight = diff-height;
			/*if(diff<parent.height()&&(offset.top>=maxHeight)||diff<offset.top){
				height = 0-parent.height()-1;
			}else{
				//maxHeight = maxHeight - offset.top-3;
				if(maxHeight<30){
					//maxHeight = diff-height;
				//	height = 0-parent.height()-1;
				}
			}*/
			var _top = (offset.top+ $("#sbHolder_" + inst.uid).height()+1);
			el.parent("div").show();
			var elHeight = el.children("li:visible:first").height()*el.children("li:visible").length;
			if(upDirect){
                 if(elHeight>maxHeight)
				 {
                    _top = offset.top - maxHeight-1;
				 }
				 else
				 {
					 _top = offset.top - elHeight-1;
					 maxHeight=elHeight;
			     }
			}
			//if(maxHeight>310){maxHeight=186;}
			
			//if(_top<0)_top=offset.top-maxHeight;

			parent.css({
				"maxHeight": maxHeight + "px",
				"top": _top + "px",
				"left":(offset.left)+"px",
				"width":width
			});
			//inst.settings.effect === "fade" ? el.parent("div").fadeIn(inst.settings.speed) : el.parent("div").slideDown(inst.settings.speed);
			try{
				parent.perfectScrollbar("update");
			}catch(e){
				if(window.console)console.log("/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js");
			}
			$("#sbToggle_" + inst.uid).addClass(inst.settings.classToggleOpen);
			this._state[inst.uid] = TRUE;
			inst.isOpen = TRUE;
			if (onOpen) {
				onOpen.apply((inst.input ? inst.input[0] : null), [inst]);
			}
			$.data(target, PROP_NAME, inst);
		},
		/**
		 * Close opened selectbox
		 * 
		 * @param {HTMLElement} target
		 */
		_closeSelectbox: function (target) {
			var inst = this._getInst(target);
			//if (!inst || !this._state[inst.uid]) {
			if (!inst || !inst.isOpen) {
				return;
			}
			var onClose = this._get(inst, 'onClose');
			//inst.settings.effect === "fade" ? $("#sbOptions_" + inst.uid).parent("div").fadeOut(inst.settings.speed) : $("#sbOptions_" + inst.uid).parent("div").slideUp(inst.settings.speed);
			$("#sbOptions_" + inst.uid).parent("div").hide();
			$("#sbToggle_" + inst.uid).removeClass(inst.settings.classToggleOpen);
			this._state[inst.uid] = FALSE;
			inst.isOpen = FALSE;
			if (onClose) {
				onClose.apply((inst.input ? inst.input[0] : null), [inst]);
			}
			$.data(target, PROP_NAME, inst);
			var obj = inst.input;
			if(obj.length>0&&typeof(inst.input.get(0).onblur)=="function"){
				inst.input.get(0).onblur();
			}
		},
		/**
		 * Create a new instance object
		 * 
		 * @param {HTMLElement} target
		 * @return {Object}
		 */
		_newInst: function(target) {
			var id = target[0].id.replace(/([^A-Za-z0-9_-])/g, '\\\\$1');
			return {
				id: id, 
				input: target, 
				uid: Math.floor(Math.random() * 99999999),
				isOpen: FALSE,
				isDisabled: FALSE,
				settings: {}
			}; 
		},
		/**
		 * Retrieve the instance data for the target control.
		 * 
		 * @param {HTMLElement} target
		 * @return {Object} - the associated instance data
		 * @throws error if a jQuery problem getting data
		 */
		_getInst: function(target) {
			try {
				return $.data(target, PROP_NAME);
			}
			catch (err) {
				throw 'Missing instance data for this selectbox';
			}
		},
		/**
		 * Get a setting value, defaulting if necessary
		 * 
		 * @param {Object} inst
		 * @param {String} name
		 * @return {Mixed}
		 */
		_get: function(inst, name) {
			return inst.settings[name] !== undefined ? inst.settings[name] : this._defaults[name];
		}
	});

	/**
	 * Invoke the selectbox functionality.
	 * 
	 * @param {Object|String} options
	 * @return {Object}
	 */
	$.fn.selectbox = function (options) {
		
		var otherArgs = Array.prototype.slice.call(arguments, 1);
		if (typeof options == 'string' && options == 'isDisabled') {
			return $.selectbox['_' + options + 'Selectbox'].apply($.selectbox, [this[0]].concat(otherArgs));
		}
		
		if (options == 'option' && arguments.length == 2 && typeof arguments[1] == 'string') {
			return $.selectbox['_' + options + 'Selectbox'].apply($.selectbox, [this[0]].concat(otherArgs));
		}
		return this.each(function() {
			if(jQuery(this).hasClass("_pageSize") || jQuery(this).attr("multiple") || jQuery(this).attr("notBeauty")){
				
			}else{
				typeof options == 'string' ?
					$.selectbox['_' + options + 'Selectbox'].apply($.selectbox, [this].concat(otherArgs)) :
					$.selectbox._attachSelectbox(this, options);
			}
		});
	};
	
	$.selectbox = new Selectbox(); // singleton instance
	$.selectbox.version = "0.2";
})(jQuery);

function beautySelect(selector){
	if(!selector)selector="select[class!=_pageSize]";
	try{
		jQuery(selector).selectbox({
			effect: "slide",
			onOpen: function(inst){
				 var optionsItems=jQuery(this).next().find(".sbOptions");
	             var selectValue=jQuery(this).val();
	
	             optionsItems.find("a").removeClass("selectorfontstyle");
	
	             var item=optionsItems.find("a[href='#"+selectValue+"']");
	
	             item.addClass("selectorfontstyle");
	
			}
		});
		jQuery(window).resize(function(){
			jQuery("select").selectbox("close");
		});
		jQuery(window).scroll(function(e){
			jQuery("select").selectbox("close");
		});
		jQuery(".zDialog_div_content").scroll(function(e){
			jQuery("select").selectbox("close");
			var evt = e||window.event;
			evt.stopPropagation();
	    	evt.preventDefault();
		});
	}catch(e){if(window.console)console.log(e+"-->jquery.selectbox-0.2.js-->beautySelect");}
}