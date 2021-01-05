/* Copyright (c) 2012, 2014 Hyunje Alex Jun and other contributors
 * Licensed under the MIT License
 */
(function (factory) {
  'use strict';

  if (typeof define === 'function' && define.amd) {
    // AMD. Register as an anonymous module.
    define(['jquery'], factory);
  } else if (typeof exports === 'object') {
    // Node/CommonJS
    factory(require('jquery'));
  } else {
    // Browser globals
    factory(jQuery);
  }
})(function ($) {
  'use strict';

  function int(x) {
    if (typeof x === 'string') {
      return parseInt(x, 10);
    } else {
      return ~~x;
    }
  }

  var defaultSettings = {
    wheelSpeed: 0,
    wheelPropagation: false,
    minScrollbarLength: 50,
    maxScrollbarLength: null,
    useBothWheelAxes: false,
    useKeyboard: true,
    suppressScrollX: false,
    suppressScrollY: false,
    scrollXMarginOffset: 0,
    scrollYMarginOffset: 0,
    includePadding: false
  };

  var incrementingId = 0;
  var eventClassFactory = function () {
    var id = incrementingId++;
    return function (eventName) {
      var className = '.perfect-scrollbar-' + id;
      if (typeof eventName === 'undefined') {
        return className;
      } else {
        return eventName + className;
      }
    };
  };

  var isWebkit = 'WebkitAppearance' in document.documentElement.style;

  $.fn.perfectScrollbar = function (option) {
  	try{
  		if(option==="update" || option==="resize"){
  			try{
  				$(this).getNiceScroll().resize();
  			}catch(e){
  				if(window.console)console.log(e,"perfect-scrollbar_wev8.js");
  			}
  			return;
  		}else if(option==="getScrollObj"){
  			return $(this).getNiceScroll();
  		}else if(option==="getScrollTop"){
  			try{
  				var nice = $(this).getNiceScroll().eq(0);
  				return nice.getScrollTop();
  			}catch(e){
  				if(window.console)console.log(e,"perfect-scrollbar_wev8.js");
  			}
  		}else if(option==="hide"){
  			$(this).getNiceScroll().hide();
  		}else if(option==="show"){
  			$(this).getNiceScroll().show();
  		}else if(option==="toggle"){
  			$(this).getNiceScroll().toggle();
  		}else if(option==="remove"){
  			$(this).getNiceScroll().remove();
  		}else if(option==="stop"){
  			$(this).getNiceScroll().stop();
  		}else if(option==="doScrollPos"){
  			$(this).getNiceScroll().doScrollPos();
  		}
 		option = jQuery.extend({
 			cursorwidth:8,
 			cursorborder:"none",
 			cursorcolor:"#999",
 			hidecursordelay:0,
 			zindex:10001,
 			horizrailenabled:false
 		},option);
		return $(this).niceScroll(option);    
	}catch(e){
		if(window.console)console.log(e,"perfect-scrollbar_wev8.js");
	}
  };
});
