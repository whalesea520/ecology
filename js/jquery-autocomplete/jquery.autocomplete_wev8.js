/*
 * jQuery Autocomplete plugin 1.1
 *
 * Copyright (c) 2009 JZaefferer
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 *
 * Revision: $Id: jquery.autocomplete_wev8.js 15 2009-08-22 10:30:27Z joern.zaefferer $
 */

;(function($) {
	
$.fn.extend({
	autocomplete: function(urlOrData, options) {
		var isUrl = typeof urlOrData == "string";
		options = $.extend({}, $.Autocompleter.defaults, {
			url: isUrl ? urlOrData : null,
			data: isUrl ? null : urlOrData,
			delay: isUrl ? $.Autocompleter.defaults.delay : 10,
			max: options && !options.scroll ? 30 : 150
		}, options);
		
		// if highlight is set to false, replace it with a do-nothing function
		options.highlight = options.highlight || function(value) { return value; };
		
		// if the formatMatch option is not specified, then use formatItem for backwards compatibility
		options.formatMatch = options.formatMatch || options.formatItem;
		
		return this.each(function() {
			new $.Autocompleter(this, options);
		});
	},
	result: function(handler) {
		return this.bind("result", handler);
	},
	search: function(handler) {
		return this.trigger("search", [handler]);
	},
	flushCache: function() {
		return this.trigger("flushCache");
	},
	setOptions: function(options){
		return this.trigger("setOptions", [options]);
	},
	unautocomplete: function() {
		return this.trigger("unautocomplete");
	},
	isVisibleResults: function() {
		var temp = {};
		this.trigger("isVisibleResults", temp);
		return temp.isVisible;
	}
});

$.Autocompleter = function(input, options) {

	var KEY = {
		UP: 38,
		DOWN: 40,
		DEL: 46,
		TAB: 9,
		RETURN: 13,
		ESC: 27,
		COMMA: 188,
		PAGEUP: 33,
		PAGEDOWN: 34,
		BACKSPACE: 8
	};

	// Create $ object for input element
	var $input = $(input).attr("autocomplete", "off").addClass(options.inputClass);
	var $indicator = $input.parent().parent();

	var timeout;
	var previousValue = "";
	var cache = $.Autocompleter.Cache(options);
	var hasFocus = 0;
	var lastKeyPressCode;
	var config = {
		mouseDownOnSelect: false
	};
	var select = $.Autocompleter.Select(options, input, selectCurrent, config);
	
	var blockSubmit;
	
	// prevent form submit in opera when selecting with return key
	$.browser.opera && $(input.form).bind("submit.autocomplete", function() {
		if (blockSubmit) {
			blockSubmit = false;
			return false;
		}
	});
	
	// only opera doesn't trigger keydown multiple times while pressed, others don't work with keypress at all
	$input.bind(($.browser.opera ? "keypress" : "keydown") + ".autocomplete", function(event) {
		// a keypress means the input has focus
		// avoids issue where input had focus before the autocomplete was applied
		hasFocus = 1;
		// track last key pressed
		lastKeyPressCode = event.keyCode;
		switch(event.keyCode) {
		
			case KEY.UP:
				event.preventDefault();
				if ( select.visible() ) {
					select.prev();
				} else {
					//onChange(0, true);
				}
				break;
				
			case KEY.DOWN:
				event.preventDefault();
				if ( select.visible() ) {
					select.next();
				} else {
					//onChange(0, true);
				}
				break;
				
			case KEY.PAGEUP:
				event.preventDefault();
				if ( select.visible() ) {
					select.pageUp();
				} else {
					//onChange(0, true);
				}
				break;
				
			case KEY.PAGEDOWN:
				event.preventDefault();
				if ( select.visible() ) {
					select.pageDown();
				} else {
					//onChange(0, true);
				}
				break;
			
			// matches also semicolon
			case options.multiple && $.trim(options.multipleSeparator) == "," && KEY.COMMA:
			case KEY.TAB:
			case KEY.RETURN:
				if( selectCurrent() ) {
					// stop default to prevent a form submit, Opera needs special handling
					event.preventDefault();
					blockSubmit = true;
					return false;
				}
				break;
				
			case KEY.ESC:
				select.hide();
				break;
				
			default:
				clearTimeout(timeout);
				timeout = setTimeout(onChange, options.delay);
				break;
		}
	}).focus(function(){
		// track whether the field has focus, we shouldn't process any
		// results if the field no longer has focus
		hasFocus++;
		if (options.onlyusecache && !select.visible()) {
			onChange(0, true);
		}
	}).blur(function() {
		hasFocus = 0;
		previousValue = "";
		if (!config.mouseDownOnSelect) {
			hideResults();
		}
	}).click(function() {
		// show select when clicking in a focused field
		// if ( hasFocus++ > 1 && !select.visible() ) {
		if ((options.onlyusecache || hasFocus++ > 1) && !select.visible()) {
			onChange(0, true);
		}
	}).bind("search", function() {
		// TODO why not just specifying both arguments?
		var fn = (arguments.length > 1) ? arguments[1] : null;
		function findValueCallback(q, data) {
			var result;
			if( data && data.length ) {
				for (var i=0; i < data.length; i++) {
					if( data[i].result.toLowerCase() == q.toLowerCase() ) {
						result = data[i];
						break;
					}
				}
			}
			clearTimeout(timeout);
			timeout = setTimeout(function(){
				if( typeof fn == "function" ) fn(result);
				else $input.trigger("result", result && [result.data, result.value]);
			},options.delay);
		}
		$.each(trimWords($input.val()), function(i, value) {
			request(value, findValueCallback, findValueCallback);
		});
	}).bind("flushCache", function() {
		cache.flush();
	}).bind("setOptions", function() {
		$.extend(options, arguments[1]);
		// if we've updated the data, repopulate
		if ( "data" in arguments[1] )
			cache.populate();
	}).bind("unautocomplete", function() {
		select.unbind();
		$input.unbind();
		$(input.form).unbind(".autocomplete");
	}).bind("input", function() {   
        // support for inputing  chinese characters  in firefox 
		if(jQuery.browser.mozilla){
			clearTimeout(timeout);
			timeout = setTimeout(function(){onChange(0,true)},options.delay);
		}
    }).bind("hideResultsNow", function() {
    	hideResultsNow();
    }).bind("isVisibleResults", function(event, obj) {
    	obj.isVisible = select.visible();
    });

	function selectCurrent() {
		var selected = select.selected();
		if( !selected )
			return false;
		
		var v = selected.result;
		previousValue = v;
		
		if ( options.multiple ) {
			var words = trimWords($input.val());
			if ( words.length > 1 ) {
				var seperator = options.multipleSeparator.length;
				var cursorAt = $(input).selection().start;
				var wordAt, progress = 0;
				$.each(words, function(i, word) {
					progress += word.length;
					if (cursorAt <= progress) {
						wordAt = i;
						return false;
					}
					progress += seperator;
				});
				words[wordAt] = v;
				// TODO this should set the cursor to the right position, but it gets overriden somewhere
				//$.Autocompleter.Selection(input, progress + seperator, progress + seperator);
				v = words.join( options.multipleSeparator );
			}
			v += options.multipleSeparator;
		}
		$input.val(v);
		hideResultsNow();
		$input.trigger("result", [selected.data, selected.value]);
		return true;
	}
	
	function onChange(crap, skipPrevCheck) {
		//因为一按del键会导致下拉框数据隐藏不显示，所以这个地方单独判断
		if(!options.showAll){
			if( lastKeyPressCode == KEY.DEL ) {
				select.hide();
				return;
			}
		}
		var currentValue = $input.val();
		
		if (!skipPrevCheck && currentValue == previousValue )
			return;
		
		previousValue = currentValue;
		
		currentValue = lastWord(currentValue);
		if ( currentValue.length >= options.minChars) {
			$indicator.addClass(options.loadingClass);
			if (!options.matchCase)
				//currentValue = currentValue.toLowerCase();
			request(currentValue, receiveData, hideResultsNow);
		} else {
			stopLoading();
			select.hide();
		}
	};
	
	function trimWords(value) {
		if (!value)
			return [""];
		if (!options.multiple)
			return [$.trim(value)];
		return $.map(value.split(options.multipleSeparator), function(word) {
			return $.trim(value).length ? $.trim(word) : null;
		});
	}
	
	function lastWord(value) {
		if ( !options.multiple )
			return value;
		var words = trimWords(value);
		if (words.length == 1) 
			return words[0];
		var cursorAt = $(input).selection().start;
		if (cursorAt == value.length) {
			words = trimWords(value)
		} else {
			words = trimWords(value.replace(value.substring(cursorAt), ""));
		}
		return words[words.length - 1];
	}
	
	// fills in the input box w/the first match (assumed to be the best match)
	// q: the term entered
	// sValue: the first matching result
	function autoFill(q, sValue){
		// autofill in the complete box w/the first match as long as the user hasn't entered in more data
		// if the last user key pressed was backspace, don't autofill
		if( options.autoFill && (lastWord($input.val()).toLowerCase() == q.toLowerCase()) && lastKeyPressCode != KEY.BACKSPACE ) {
			// fill in the value (keep the case the user has typed)
			$input.val($input.val() + sValue.substring(lastWord(previousValue).length));
			// select the portion of the value not typed by the user (so the next character will erase)
			$(input).selection(previousValue.length, previousValue.length + sValue.length);
		}
	};

	function hideResults() {
		clearTimeout(timeout);
		timeout = setTimeout(hideResultsNow, 200);
	};

	function hideResultsNow() {
		var wasVisible = select.visible();
		select.hide();
		clearTimeout(timeout);
		stopLoading();
		if (options.mustMatch) {
			// call search and run callback
			$input.search(
				function (result){
					// if no value found, clear the input box
					if( !result ) {
						if (options.multiple) {
							var words = trimWords($input.val()).slice(0, -1);
							$input.val( words.join(options.multipleSeparator) + (words.length ? options.multipleSeparator : "") );
						}
						else {
							if (!options.onlyusecache || (!$input.is('.autoSelect_focus') && !$input.is('.autoSelect_a_focus'))) {
								//$input.val( "" );
								//$input.trigger("result", null);
							}
						}
					} else {
						if (options.onlyusecache && !$input.is('.autoSelect_focus') && !$input.is('.autoSelect_a_focus')) {
							$input.trigger('checkResult');
						}
					}
				}
			);
		}
	};

	function receiveData(q, data) {
		if ( data && data.length && hasFocus ) {
			stopLoading();
			select.display(data, q);
			autoFill(q, data[0].value);
			select.show();
		} else {
			hideResultsNow();
		}
	};

	function request(term, success, failure) {
		if (!options.matchCase)
			//term = term.toLowerCase();
		var data = cache.load(term);
		//showAll 只有请假类型调用的时候才会置为true  qc295905
		if(options.showAll){
			data = cache.load('');
		}
		
		// recieve the cached data
		if (options.onlyusecache && data && data.length) {
			success(term, data);
		// if an AJAX url has been supplied, try loading the data now
		//} else if( (typeof options.url == "string") && (options.url.length > 0) ){
		} else if(!options.onlyusecache && (typeof options.url == "string") && (options.url.length > 0) ){
			//动态url
			var ajaxurl = options.url;
			if (options.url.indexOf("javascript:") == 0) {
				var getAjaxurlFun = options.url.substring("javascript:".length, options.url.length);
				//为browser传递fieldId
				if (getAjaxurlFun.indexOf('getajaxurl') >= 0) {
					var inputId = $input.attr('id');
					var reg = /^(field([0-9]+)(_[0-9]+)?)__$/gi;
					if (reg.test(inputId)) {
						var fieldId = inputId.replace(reg, '$1');
						var getAjaxurlFunS = getAjaxurlFun.substring(0, getAjaxurlFun.lastIndexOf(')'));
						var getAjaxurlFunE = getAjaxurlFun.substring(getAjaxurlFun.lastIndexOf(')'));
						getAjaxurlFun = getAjaxurlFunS + ",'" + fieldId + "'" + getAjaxurlFunE;
					}
				}
				ajaxurl = eval(getAjaxurlFun);
			} else {
				//非动态url才从缓存中获取数据
				if (options.cacheLength>1 && data && data.length) {
					success(term, data);
					return;
				}
			}
			var extraParams = {
				timestamp: +new Date()
			};
			$.each(options.extraParams, function(key, param) {
				if(param=="getNameAndIdVal"){
					extraParams[key] = getNameAndIdVal(options.browserBox,options.nameAndId);
				}else{
					extraParams[key] = typeof param == "function" ? param(options.nameAndId) : param;
				}
			});
			
			$.ajax({
				// try to leverage ajaxQueue plugin to abort previous requests
				mode: "abort",
				// limit abortion to this input
				port: "autocomplete" + input.name,
				type:"post",
				dataType: options.dataType,
				url: ajaxurl,
				data: $.extend({
					q: lastWord(term),
					limit: options.max
				}, extraParams),
				success: function(data) {
					var parsed = options.parse && options.parse(data) || parse(data);
					cache.add(term, parsed);
					success(term, parsed);
				}
			});
		} else {
			// if we have a failure, we need to empty the list -- this prevents the the [TAB] key from selecting the last successful match
			select.emptyList();
			failure(term);
		}
	};
	
	function parse(data) {
		var parsed = [];
		var rows = data.split("\n");
		for (var i=0; i < rows.length; i++) {
			var row = $.trim(rows[i]);
			if (row) {
				row = row.split("|");
				parsed[parsed.length] = {
					data: row,
					value: row[0],
					result: options.formatResult && options.formatResult(row, row[0]) || row[0]
				};
			}
		}
		return parsed;
	};

	function stopLoading() {
		$indicator.removeClass(options.loadingClass);
	};

};

$.Autocompleter.defaults = {
	inputClass: "ac_input",
	resultsClass: "ac_results",
	loadingClass: "ac_loading",
	divID: null,
	nameAndId:null,
	minChars: 1,
	delay: 400,
	matchCase: false,
	matchSubset: true,
	matchContains: false,
	cacheLength: 1,
	max: 100,
	viewMax:5,
	mustMatch: false,
	extraParams: {},
	selectFirst: true,
	formatItem: function(row) { return row[0]; },
	formatMatch: null,
	autoFill: false,
	width: 0,
	multiple: false,
	multipleSeparator: ", ",
	highlight: function(value, term) {
		return value.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + term.replace(/([\^\$\(\)\[\]\{\}\*\.\+\?\|\\])/gi, "\\$1") + ")(?![^<>]*>)(?![^&;]+;)", "gi"), "<strong>$1</strong>");
	},
    scroll: false,
    fixHeight:0,
    scrollHeight: 180,
    onlyusecache: false
};

$.Autocompleter.Cache = function(options) {

	var data = {};
	var length = 0;
	
	function matchSubset(s, sub) {
		if (!options.matchCase) 
			s = s.toLowerCase();
		var i = s.indexOf(sub);
		if (options.matchContains == "word"){
			i = s.toLowerCase().search("\\b" + sub.toLowerCase());
		}
		if (i == -1) return false;
		return i == 0 || options.matchContains;
	};
	
	function add(q, value) {
		if (length > options.cacheLength){
			flush();
		}
		if (!data[q]){ 
			length++;
		}
		data[q] = value;
	}
	
	function populate(){
		if( !options.data ) return false;
		// track the matches
		var stMatchSets = {},
			nullData = 0;

		// no url was specified, we need to adjust the cache length to make sure it fits the local data store
		if( !options.url ) options.cacheLength = 1;
		
		// track all options for minChars = 0
		stMatchSets[""] = [];
		
		// loop through the array and create a lookup structure
		for ( var i = 0, ol = options.data.length; i < ol; i++ ) {
			var rawValue = options.data[i];
			// if rawValue is a string, make an array otherwise just reference the array
			rawValue = (typeof rawValue == "string") ? [rawValue] : rawValue;
			
			var value = options.formatMatch(rawValue, i+1, options.data.length);
			if ( value === false )
				continue;
				
			var firstChar = value.charAt(0).toLowerCase();
			// if no lookup array for this character exists, look it up now
			if( !stMatchSets[firstChar] ) 
				stMatchSets[firstChar] = [];

			// if the match is a string
			var row = {
				value: value,
				data: rawValue,
				result: options.formatResult && options.formatResult(rawValue) || value
			};
			
			// push the current match into the set list
			stMatchSets[firstChar].push(row);

			// keep track of minChars zero items
			if ( nullData++ < options.max ) {
				stMatchSets[""].push(row);
			}
		};

		// add the data items to the cache
		$.each(stMatchSets, function(i, value) {
			// increase the cache size
			options.cacheLength++;
			// add to the cache
			add(i, value);
		});
	}
	
	// populate any existing data
	setTimeout(populate, 25);
	
	function flush(){
		data = {};
		length = 0;
	}
	
	return {
		flush: flush,
		add: add,
		populate: populate,
		load: function(q) {
			if (!options.cacheLength || !length)
				return null;
			/* 
			 * if dealing w/local data and matchContains than we must make sure
			 * to loop through all the data collections looking for matches
			 */
			if( !options.url && options.matchContains ){
				// track all matches
				var csub = [];
				// loop through all the data grids for matches
				for( var k in data ){
					// don't search through the stMatchSets[""] (minChars: 0) cache
					// this prevents duplicates
					if( k.length > 0 ){
						var c = data[k];
						$.each(c, function(i, x) {
							// if we've got a match, add it to the array
							if (matchSubset(x.value, q)) {
								csub.push(x);
							}
						});
					}
				}				
				return csub;
			} else 
			// if the exact item exists, use it
			if (data[q]){
				return data[q];
			} else
			if (options.matchSubset) {
				for (var i = q.length - 1; i >= options.minChars; i--) {
					var c = data[q.substr(0, i)];
					if (c) {
						var csub = [];
						$.each(c, function(i, x) {
							if (matchSubset(x.value, q)) {
								csub[csub.length] = x;
							}
						});
						return csub;
					}
				}
			}
			return null;
		}
	};
};

$.Autocompleter.Select = function (options, input, select, config) {
	var CLASSES = {
		ACTIVE: "ac_over"
	};
	if (options.onlyusecache) {
		CLASSES = {
			ACTIVE: "as_over"
		};
	}
	
	var listItems,
		active = -1,
		data,
		term = "",
		needsInit = true,
		element,
		list;
	
	// Create results
	function init() {
		if (!needsInit)
			return;
		element = $("<div id='e8_autocomplete_div'/>")
		.hide()
		.addClass(options.resultsClass)
		.css("position", "absolute")
		.appendTo(document.body);
		list = $("<ul/>").appendTo(element).mouseover( function(event) {
			if(target(event).nodeName && target(event).nodeName.toUpperCase() == 'LI') {
	            active = $("li", list).removeClass(CLASSES.ACTIVE).index(target(event));
	            listItems.wTooltip("hide");
			    $(target(event)).addClass(CLASSES.ACTIVE);            
	        }
		}).click(function(event) {
			if (options.onlyusecache) {
				$(target(event)).addClass(CLASSES.ACTIVE);
				select();
				// TODO provide option to avoid setting focus again after selection? useful for cleanup-on-focus
				//input.focus();
				return false;
			} else {
				var evt = event||window.event;
				evt.stopPropagation();
				evt.preventDefault();
				return false;
			}
		}).mousedown(function() {
			config.mouseDownOnSelect = true;
		}).mouseup(function(event) {
			config.mouseDownOnSelect = false;
			if (!options.onlyusecache) {
				var evt = event||window.event;
				$(target(evt)).addClass(CLASSES.ACTIVE);
				select();
				// TODO provide option to avoid setting focus again after selection? useful for cleanup-on-focus
				//input.focus();
				evt.stopPropagation();
				evt.preventDefault();
				return false;
			}
		});
		
		if( options.width > 0 )
			element.css("width", options.width);
			
		needsInit = false;

		if (options.onlyusecache) {
			list.addClass('asOptions');
			list.css('display', 'inline-block');
		}
	}

	function target(event) {
		var element = event.target;
		while(element && element.tagName != "LI")
			element = element.parentNode;
		// more fun with IE, sometimes event.target is empty, just ignore it then
		if(!element)
			return [];
		return element;
	}

	function moveSelect(step) {
		listItems.slice(active, active + 1).removeClass(CLASSES.ACTIVE);
		listItems.slice(active, active + 1).wTooltip("hide");
		movePosition(step);
        var activeItem = listItems.slice(active, active + 1).addClass(CLASSES.ACTIVE);
       	var niceScroll = element.perfectScrollbar("getScrollObj");
       	if(niceScroll && niceScroll.length>0){
       		niceScroll.eq(0).scrollTop((active-options.viewMax)*(activeItem.height()+5));
       	}
        activeItem.wTooltip("show");
        if(options.scroll) {
            var offset = 0;
            listItems.slice(0, active).each(function() {
				offset += this.offsetHeight;
			});
            if((offset + activeItem[0].offsetHeight - list.scrollTop()) > list[0].clientHeight) {
                list.scrollTop(offset + activeItem[0].offsetHeight - list.innerHeight());
            } else if(offset < list.scrollTop()) {
                list.scrollTop(offset);
            }
        }
	};
	
	function movePosition(step) {
		active += step;
		if (active < 0) {
			active = listItems.size() - 1;
		} else if (active >= listItems.size()) {
			active = 0;
		}
	}
	
	function limitNumberOfItems(available) {
		return options.max && options.max < available
			? options.max
			: available;
	}
	
	function fillList() {
		try{
			listItems.wTooltip("hide");
		}catch(e){}
		list.empty();
		var max = limitNumberOfItems(data.length);
		for (var i=0; i < max; i++) {
			if (!data[i])
				continue;
			var formatted = options.formatItem(data[i].data, i+1, max, data[i].value, term);
			if ( formatted === false )
				continue;
			var li = $("<li/>").html( options.highlight(formatted, term) ).addClass(i%2 == 0 ? "ac_even" : "ac_odd").appendTo(list)[0];
			var detail = "";
			for(var key in data[i].data){
				try{
					if(key.toLowerCase()=="id"||key.toLowerCase()=="href"||key=="mainid"||key=="subid"||key=="tag"||key=="path2"||key=="path"||!data[i].data[key]){
						continue;
					}
					if(detail==""){
						detail = data[i].data[key];
					}else{
						detail += "  |  " + data[i].data[key];
					}
				}catch(e){}				
			}
			jQuery(li).attr("_title",detail);
			$.data(li, "ac_data", data[i]);
			jQuery(li).wTooltip({
				alignX: 'right',
				alignY: 'center',
				fade:false,
				slide:false,
				offsetX:0
			});
			if (options.onlyusecache && i == max - 1) {
				jQuery(li).height('auto');
				jQuery(li).addClass('last');
			}
		}
		listItems = list.find("li");
		if ( options.selectFirst ) {
			listItems.slice(0, 1).addClass(CLASSES.ACTIVE);
			active = 0;
		}
		// apply bgiframe if available
		if ( $.fn.bgiframe )
			list.bgiframe();
	}
	
	return {
		display: function(d, q) {
			init();
			data = d;
			term = q;
			fillList();
		},
		next: function() {
			moveSelect(1);
		},
		prev: function() {
			moveSelect(-1);
		},
		pageUp: function() {
			if (active != 0 && active - 8 < 0) {
				moveSelect( -active );
			} else {
				moveSelect(-8);
			}
		},
		pageDown: function() {
			if (active != listItems.size() - 1 && active + 8 > listItems.size()) {
				moveSelect( listItems.size() - 1 - active );
			} else {
				moveSelect(8);
			}
		},
		hide: function() {
			element && element.hide();
			listItems && listItems.removeClass(CLASSES.ACTIVE);
			try{
				listItems.wTooltip("hide");
			}catch(e){}
			active = -1;
		},
		visible : function() {
			return element && element.is(":visible");
		},
		current: function() {
			return this.visible() && (listItems.filter("." + CLASSES.ACTIVE)[0] || options.selectFirst && listItems[0]);
		},
		show: function() {
			var offsetTop = 0;
			var offsetLeft = 0;
			var height = 0;
			if(options.divID){
				if(typeof options.divID == "string"){
					if(options.divID.indexOf("#")==-1){
						options.divID="#"+options.divID;
					}
				}
				//var offset = $(options.divID).offset();
				offsetTop = $(options.divID).offset().top;
				offsetLeft = $(input).offset().left;
				//var width = $(options.divID).width()-2;
				height = $(options.divID).height()+options.fixHeight;
			}else{
				 offsetTop = $(input).offset().top;
				 offsetLeft = $(input).offset().left;
				//var width = $(input).width();
				 height = input.offsetHeight
			}
			element.css({
				/*width: typeof options.width == "string" || options.width > 0 ? options.width : width,*/
				top: offsetTop + height,
				left: offsetLeft-1
			}).show();

			if (options.onlyusecache) {
				list.css('height', list[0].scrollHeight > options.scrollHeight ? options.scrollHeight + 'px' : 'auto');
				if ((offsetTop + height + element.height()) > $(window).height()) {
					element.css('top', offsetTop - element.height());
				}
			}
			
			var _width = jQuery(window).width();
			if(offsetLeft+element.width()>_width && offsetLeft<=_width){
				element.css({
					left:_width-element.width()-30
				});
			}
			if(offsetLeft+element.width()>_width*0.9){
				jQuery(listItems).wTooltip("destroy");
				jQuery(listItems).wTooltip({
					alignX: 'left',
					alignY: 'center',
					fade:false,
					slide:false,
					offsetX:0
				});
			}
			var niceScroll = element.perfectScrollbar("getScrollObj");
			if(listItems.length>options.viewMax){
				if(niceScroll && niceScroll.length>0){
					element.perfectScrollbar("update");
					niceScroll.eq(0).scrollTop(0);
				}else{
					element.perfectScrollbar();
				}
			}else{
				element.perfectScrollbar("remove");
			}
			/*
			//var div = list.parent("div#innerDiv");
			//var outerDiv = list.closest("div#outerDiv");
			if(div.length==0){
				//outerDiv = jQuery("<div id=\"outerDiv\"/>");
				//outerDiv.height(options.scrollHeight);
				//list.wrap(outerDiv);
				//div = jQuery("<div id=\"innerDiv\"/>");
				//list.wrap(div);
				//div.height(list.height());
				//element.perfectScrollbar();
			}else{
				div.height(list.height());
				//element.perfectScrollbar("update");
			}*/
            if(options.scroll) {
                list.scrollTop(0);
                list.css({
					maxHeight: options.scrollHeight,
					overflow: 'auto'
				});
				
                if($.browser.msie && typeof document.body.style.maxHeight === "undefined") {
					var listHeight = 0;
					listItems.each(function() {
						listHeight += this.offsetHeight;
					});
					var scrollbarsVisible = listHeight > options.scrollHeight;
                    list.css('height', scrollbarsVisible ? options.scrollHeight : listHeight );
					if (!scrollbarsVisible) {
						// IE doesn't recalculate width when scrollbar disappears
						listItems.width( list.width() - parseInt(listItems.css("padding-left")) - parseInt(listItems.css("padding-right")) );
					}
                }
                
            }

			if ( options.selectFirst ) {
				listItems.slice(active, active+1).wTooltip("hide");
				listItems.slice(0, 1).wTooltip("show");
			}
		},
		selected: function() {
			var selected = listItems && listItems.filter("." + CLASSES.ACTIVE).removeClass(CLASSES.ACTIVE);
			return selected && selected.length && $.data(selected[0], "ac_data");
		},
		emptyList: function (){
			list && list.empty();
		},
		unbind: function() {
			element && element.remove();
		}
	};
};

$.fn.selection = function(start, end) {
	if (start !== undefined) {
		return this.each(function() {
			if( this.createTextRange ){
				var selRange = this.createTextRange();
				if (end === undefined || start == end) {
					selRange.move("character", start);
					selRange.select();
				} else {
					selRange.collapse(true);
					selRange.moveStart("character", start);
					selRange.moveEnd("character", end);
					selRange.select();
				}
			} else if( this.setSelectionRange ){
				this.setSelectionRange(start, end);
			} else if( this.selectionStart ){
				this.selectionStart = start;
				this.selectionEnd = end;
			}
		});
	}
	var field = this[0];
	if ( field.createTextRange ) {
		var range = document.selection.createRange(),
			orig = field.value,
			teststring = "<->",
			textLength = range.text.length;
		range.text = teststring;
		var caretAt = field.value.indexOf(teststring);
		field.value = orig;
		this.selection(caretAt, caretAt + textLength);
		return {
			start: caretAt,
			end: caretAt + textLength
		}
	} else if( field.selectionStart !== undefined ){
		return {
			start: field.selectionStart,
			end: field.selectionEnd
		}
	}
};

})(jQuery);


/*配套autocomplete插件合并--->/js/jquery-autocomplete/lib/jquery.ajaxQueue.js*/
/**
 * Ajax Queue Plugin
 * 
 * Homepage: http://jquery.com/plugins/project/ajaxqueue
 * Documentation: http://docs.jquery.com/AjaxQueue
 */

/**

<script>
$(function(){
	jQuery.ajaxQueue({
		url: "test.php",
		success: function(html){ jQuery("ul").append(html); }
	});
	jQuery.ajaxQueue({
		url: "test.php",
		success: function(html){ jQuery("ul").append(html); }
	});
	jQuery.ajaxSync({
		url: "test.php",
		success: function(html){ jQuery("ul").append("<b>"+html+"</b>"); }
	});
	jQuery.ajaxSync({
		url: "test.php",
		success: function(html){ jQuery("ul").append("<b>"+html+"</b>"); }
	});
});
</script>
<ul style="position: absolute; top: 5px; right: 5px;"></ul>

 */
/*
 * Queued Ajax requests.
 * A new Ajax request won't be started until the previous queued 
 * request has finished.
 */

/*
 * Synced Ajax requests.
 * The Ajax request will happen as soon as you call this method, but
 * the callbacks (success/error/complete) won't fire until all previous
 * synced requests have been completed.
 */


(function($) {
	
	var ajax = $.ajax;
	
	var pendingRequests = {};
	
	var synced = [];
	var syncedData = [];
	
	$.ajax = function(settings) {
		// create settings for compatibility with ajaxSetup
		settings = jQuery.extend(settings, jQuery.extend({}, jQuery.ajaxSettings, settings));
		
		var port = settings.port;
		
		switch(settings.mode) {
		case "abort": 
			if ( pendingRequests[port] ) {
				pendingRequests[port].abort();
			}
			return pendingRequests[port] = ajax.apply(this, arguments);
		case "queue": 
			var _old = settings.complete;
			settings.complete = function(){
				if ( _old )
					_old.apply( this, arguments );
				jQuery([ajax]).dequeue("ajax" + port );;
			};
		
			jQuery([ ajax ]).queue("ajax" + port, function(){
				ajax( settings );
			});
			return;
		case "sync":
			var pos = synced.length;
	
			synced[ pos ] = {
				error: settings.error,
				success: settings.success,
				complete: settings.complete,
				done: false
			};
		
			syncedData[ pos ] = {
				error: [],
				success: [],
				complete: []
			};
		
			settings.error = function(){ syncedData[ pos ].error = arguments; };
			settings.success = function(){ syncedData[ pos ].success = arguments; };
			settings.complete = function(){
				syncedData[ pos ].complete = arguments;
				synced[ pos ].done = true;
		
				if ( pos == 0 || !synced[ pos-1 ] )
					for ( var i = pos; i < synced.length && synced[i].done; i++ ) {
						if ( synced[i].error ) synced[i].error.apply( jQuery, syncedData[i].error );
						if ( synced[i].success ) synced[i].success.apply( jQuery, syncedData[i].success );
						if ( synced[i].complete ) synced[i].complete.apply( jQuery, syncedData[i].complete );
		
						synced[i] = null;
						syncedData[i] = null;
					}
			};
		}
		return ajax.apply(this, arguments);
	};
	
})(jQuery);
