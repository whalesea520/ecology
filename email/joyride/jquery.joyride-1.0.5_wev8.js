/*
 * jQuery Joyride Plugin 1.0.5
 * www.ZURB.com/playground
 * Copyright 2011, ZURB
 * Free to use under the MIT license.
 * http://www.opensource.org/licenses/mit-license.php
*/

(function($) {
  $.fn.joyride = function(options) {

    // +++++++++++++++++++
    //   Defaults
    // +++++++++++++++++++
    var settings = {
      'tipLocation': 'bottom', // 'top' or 'bottom' in relation to parent（设置向导提示框与被提示目标的位置）
      'scrollSpeed': 300, // Page scrolling speed in milliseconds（设置页面自动滑动的速度，当被提示目标在可视区域外时，页面将自动滑动以显示）
      'timer': 0, // 0 = no timer, all other numbers = timer in milliseconds（设置向导自动‘下一步’提示的时间间隔）
      'startTimerOnClick': false, // true or false - true requires clicking the first button start the timer（设置自动提示计时开始的时间）
      'nextButton': true, // true or false to control whether a next button is used（设置‘下一步’按钮是否被显示，不显示则不能使用）
      'tipAnimation': 'pop', // 'pop' or 'fade' in each tip（提示框出现的动画效果）
      'tipAnimationFadeSpeed': 300, // when tipAnimation = 'fade' this is speed in milliseconds for the transition（提示框动画效果的持续时间）
      'cookieMonster': false, // true or false to control whether cookies are used
      'cookieName': 'JoyRide', // Name the cookie you'll use
      'cookieDomain': false, // Will this cookie be attached to a domain, ie. '.notableapp.com'
      'tipContainer': 'body', // Where will the tip be attached if not inline
      'inline': false, // true or false, if true the tip will be attached after the element
      'tipContent': '#joyRideTipContent', // What is the ID of the <ol> you put the content in（包含提示内容的元素ID）
      'postRideCallback': $.noop, // A method to call once the tour closes (canceled or complete)（当完成所有提示后将执行这个函数）
      'postStepCallback': $.noop// A method to call after each step（每完成一步提示就会执行一次该函数）
    
    };

    var options = $.extend(settings, options);

    return this.each(function() {

      if ($(options.tipContent).length === 0) return;

      $(options.tipContent).hide();
      var tempIndex=0;
      var bodyOffset = $(options.tipContainer).children('*').first().position(),
      tipContent = $(options.tipContent + ' li'),
      count = skipCount = 0,
      prevCount = -1,
      timerIndicatorInstance,
      timerIndicatorTemplate = '<div class="joyride-timer-indicator-wrap"><span class="joyride-timer-indicator"></span></div>';

      var tipTemplate = function(tipClass, index, buttonText, self) {
    	  tempIndex=index;
        return '<div class="joyride-tip-guide ' +
          tipClass + '" id="joyRidePopup' + index + '"><span class="joyride-nub"' +' id="zzl_'+tempIndex+'"></span><div class="joyride-content-wrapper">'+
          $(self).html() + buttonText + '<a href="#close" class="joyride-close-tip"></a>' +
          timerIndicatorInstance + '</div></div>';
      };

      var tipLayout = function(tipClass, index, buttonText, self) {
        if (index == 0 && settings.startTimerOnClick && settings.timer > 0 || settings.timer == 0) {
          timerIndicatorInstance = '';
        } else {
          timerIndicatorInstance = timerIndicatorTemplate;
        }

        if (!tipClass) {
          tipClass = '';
        }

        if (buttonText) {
          buttonText = '<a href="#" class="joyride-next-tip small nice radius yellow button">' + buttonText + '</a>'
        } else {
          buttonText = '';
        }

        if (settings.inline) {
          $(tipTemplate(tipClass, index, buttonText, self)).insertAfter('#' + $(self).data('id'));
        } else {
          $(options.tipContainer).append(tipTemplate(tipClass, index, buttonText, self));
        }
      };

      if(!settings.cookieMonster || !$.cookie(settings.cookieName)) {

      tipContent.each(function(index) {
        var buttonText = $(this).data('text'),
        tipClass = $(this).attr('class'),
        self = this;

        if (settings.nextButton && !buttonText) {
          buttonText = 'Next';
        }

        if (settings.nextButton || !settings.nextButton && settings.startTimerOnClick) {
          if ($(this).attr('class')) {
            tipLayout(tipClass, index, buttonText, self);
          } else {
            tipLayout(false, index, buttonText, self);
          }
        } else if (!settings.nextButton) {
          if ($(this).attr('class')) {
            tipLayout(tipClass, index, '', self);
          } else {
            tipLayout(false, index, '', self);
          }
        }
        $('#joyRidePopup' + index).hide();
      });
    }

      showNextTip = function() {
        var parentElementID = $(tipContent[count]).data('id'),
        parentElement = $('#' + parentElementID),
        opt = {};
        var _xuhao=$(parentElement).attr("_xuhao");
       // alert($('#zzl_'+_xuhao).parent().html());
        // Parse the options string
        $.each(($(tipContent[count]).data('options') || ':').split(';'),
          function (i, s) {
            var p = s.split(':');
            if (p.length == 2) {
              opt[$.trim(p[0])] = $.trim(p[1]);
            }
          }
        );

        var tipSettings = $.extend({}, settings, opt);

        while (parentElement.offset() === null) {
          count++;
          skipCount++;
          if ((tipContent.length - 1) > prevCount) {
            prevCount++;
          }
          parentElementID = $(tipContent[count]).data('id'),
          parentElement = $('#' + parentElementID);
        
          if ($(tipContent).length < count) {
            break;
          }
        }
        var windowHalf = Math.ceil($(window).height() / 2),
          currentTip = $('#joyRidePopup' + count),
          currentTipPosition = parentElement.offset(),
          currentParentHeight = parentElement.outerHeight(),
          currentTipHeight = currentTip.outerHeight(),
          nubHeight = Math.ceil(($('#zzl_'+_xuhao).outerHeight())/ 2)+14,
          tipOffset = 0;
      
       /* try{
        	alert("0--"+Math.ceil(($('#zzl_0').outerHeight())/ 2));
        }catch(e){}
        try{
        	alert("1--"+Math.ceil(($('#zzl_1').outerHeight())/ 2));
        }catch(e){}
        try{
        	alert("2---"+Math.ceil(($('#zzl_2').outerHeight())/ 2));
        }catch(e){}
        try{
        	alert("3--"+Math.ceil(($('#zzl_3').outerHeight())/ 2));
        }catch(e){}*/
       // alert($('#zzl_'+index).parent().html());
        // alert($('.joyride-nub').outerHeight());
       //  alert($('.joyride-nub').outerHeight()/2);

        if (currentTip.length === 0) {
          return;
        }

        if (count < tipContent.length) {
          if (settings.tipAnimation == "pop") {
            $('.joyride-timer-indicator').width(0);
            if (settings.timer > 0) {
              currentTip.show().children('.joyride-timer-indicator-wrap')
                .children('.joyride-timer-indicator')
                .animate({width: $('.joyride-timer-indicator-wrap')
                .width()}, settings.timer);
            } else {
              currentTip.show();
            }
          } else if (settings.tipAnimation == "fade") {
            $('.joyride-timer-indicator').width(0);
            if (settings.timer > 0) {
              currentTip.fadeIn(settings.tipAnimationFadeSpeed)
                .children('.joyride-timer-indicator-wrap')
                .children('.joyride-timer-indicator')
                .animate({width: $('.joyride-timer-indicator-wrap')
                .width()}, settings.timer);
            } else {
              currentTip.fadeIn(settings.tipAnimationFadeSpeed);
            }
          }

          // ++++++++++++++++++
          //   Tip Location
          // ++++++++++++++++++
          var nub = currentTip.children('.joyride-nub');
          var left = currentTipPosition.left - bodyOffset.left;
          nub.removeClass('bottom')
             .removeClass('top')
             .removeClass('right');

          // Update the tip position so it is in the same position
          // but the nub is right aligned.
          if ($(window).scrollLeft() + $(window).width() < left + currentTip.width()) {
            left -= (currentTip.width() - nub.offset().left * 2);
            nub.addClass("right");
          }

          if (Modernizr.mq('only screen and (max-width: 769px)')) {
            //If the user is "mobile"
            if (tipSettings.tipLocation.indexOf("top") != -1 ) {
              if (currentTipHeight >= currentTipPosition.top) {
                currentTip.offset({top: ((currentTipPosition.top + currentParentHeight + nubHeight) - bodyOffset.top)});
                nub.addClass('top').css({ left: left });
              } else {
                currentTip.offset({top: ((currentTipPosition.top) - (currentTipHeight + bodyOffset.top + nubHeight))});
                nub.addClass('bottom').css({ left: left });
              }
            } else {
              // Default is bottom alignment.
            	//alert("1left="+left);
              currentTip.offset({top: (currentTipPosition.top + currentParentHeight + nubHeight)});
              nub.addClass('top').css({ left: left });
            }
          } else {
            if (tipSettings.tipLocation == "top") {
              if (currentTipHeight >= currentTipPosition.top) {
                currentTip.offset({
                  top: ((currentTipPosition.top + currentParentHeight + nubHeight) - bodyOffset.top),
                  left: left
                });
                nub.addClass('top');
              } else {
                currentTip.offset({
                  top: ((currentTipPosition.top) - (currentTipHeight + bodyOffset.top + nubHeight)),
                  left: left
                });
                nub.addClass('bottom');
              }
            } else {
              // Default is bottom alignment.
            	//alert("2left="+left);
              currentTip.offset({
                top: (currentTipPosition.top + currentParentHeight + nubHeight),
                left: left
              });
              nub.addClass('top');
            }
          }

          // Default is left alignment.
          if (tipSettings.tipLocation.indexOf("right") != -1) {
            // Here we ignore the viewport alignment.
            currentTip.offset({left: (currentTipPosition.left - bodyOffset.left - currentTip.width() + parentElement.width())});
            currentTip.children('.joyride-nub').addClass('right');
          }

          // Animate Scrolling when tip is off screen
          tipOffset = Math.ceil(currentTip.offset().top - windowHalf);
          $("html, body").animate({
            scrollTop: tipOffset
          }, settings.scrollSpeed);

          if (count > 0) {
            if (skipCount > 0) {
              var hideCount = prevCount - skipCount;
              skipCount = 0;
            } else {
              var hideCount = prevCount;
            }
            if (settings.tipAnimation == "pop") {
              $('#joyRidePopup' + hideCount).hide();
            } else if (settings.tipAnimation == "fade") {
              $('#joyRidePopup' + hideCount).fadeOut(settings.tipAnimationFadeSpeed);
            }
          }

        // Hide the last tip when clicked
        } else if ((tipContent.length - 1) < count) {
          var hideCnt;
          if (skipCount > 0) {
            hideCount = prevCount - skipCount;
            skipCount = 0;
          } else {
            hideCount = prevCount;
          }
          if (settings.cookieMonster == true) {
            $.cookie(settings.cookieName, 'ridden', { expires: 365, domain: settings.cookieDomain });
          }
          if (settings.tipAnimation == "pop") {
            $('#joyRidePopup' + hideCount).fadeTo(0, 0);
          } else if (settings.tipAnimation == "fade") {
            $('#joyRidePopup' + hideCount).fadeTo(settings.tipAnimationFadeSpeed, 0);
          }
        }
        count++;
        if (prevCount < 0) {
          prevCount = 0;
        } else if ((tipContent.length - 1) > prevCount) {
          prevCount++;
        }
        if (settings.postStepCallback != $.noop) {
          settings.postStepCallback(prevCount);
        }
      }
      
    if (!settings.inline || !settings.cookieMonster || !$.cookie(settings.cookieName)) {
    
      $(window).resize(function () {
    	  if(prevCount<0){
    		 return;
    	  }
        var parentElementID = $(tipContent[prevCount]).data('id'),
          currentTipPosition = $('#' + parentElementID).offset(),
          currentParentHeight = $('#' + parentElementID).outerHeight(),
          currentTipHeight = $('#joyRidePopup' + prevCount).outerHeight(),
          nubHeight = Math.ceil($('.joyride-nub').outerHeight() / 2);
        
        if (Modernizr.mq('only screen and (max-width: 769px)')) {
          if (settings.tipLocation == "bottom") {
            $('#joyRidePopup' + prevCount).offset({
              top: (currentTipPosition.top + currentParentHeight + nubHeight),
              left: 0
            });
            $('#joyRidePopup' + prevCount).children('.joyride-nub').addClass('top').removeClass('bottom').css({ left: (currentTipPosition.left - bodyOffset.left) });
          } else if (settings.tipLocation == "top") {
            if (currentTipPosition.top <= currentTipHeight) {
              $('#joyRidePopup' + prevCount).offset({
                top: (currentTipPosition.top + nubHeight + currentParentHeight),
                left: 0
              });
              $('#joyRidePopup' + prevCount).children('.joyride-nub').addClass('top').removeClass('bottom').css({ left: (currentTipPosition.left - bodyOffset.left) });

            } else {
              $('#joyRidePopup' + prevCount).offset({
                top: ((currentTipPosition.top) - (currentTipHeight + nubHeight)),
                left: 0
              });
              $('#joyRidePopup' + prevCount).children('.joyride-nub').addClass('bottom').removeClass('top').css({ left: (currentTipPosition.left - bodyOffset.left) });
            }
          }
        } else {
        	
        	if(currentTipPosition.left>1000){
        		settings.tipLocation="";
        	}
     
          if (settings.tipLocation == "bottom") {
            $('#joyRidePopup' + prevCount).offset({
              top: (currentTipPosition.top + currentParentHeight + nubHeight),
              left: currentTipPosition.left
            });
            $('#joyRidePopup' + prevCount).children('.joyride-nub').addClass('top').removeClass('bottom').css({ left: '' });
          } else if (settings.tipLocation == "top") {
            if (currentTipPosition.top <= currentTipHeight) {
              $('#joyRidePopup' + prevCount).offset({
                top: (currentTipPosition.top + nubHeight + currentParentHeight),
                left: currentTipPosition.left
              });
              $('#joyRidePopup' + prevCount).children('.joyride-nub').addClass('top').removeClass('bottom').css({ left: '' });
            }
            else {
              $('#joyRidePopup' + prevCount).offset({
                top: ((currentTipPosition.top) - (currentTipHeight + nubHeight)),
                left: currentTipPosition.left
              });
              $('#joyRidePopup' + prevCount).children('.joyride-nub').addClass('bottom').removeClass('top').css({ left: '' });
            }
          }
        }
      });
      
    }

      // +++++++++++++++
      //   Timer
      // +++++++++++++++

      var interval_id = null,
      showTimerState = false;

      if (!settings.startTimerOnClick && settings.timer > 0){
       showNextTip();
       interval_id = setInterval(function() {showNextTip()}, settings.timer);
      } else {
       showNextTip();
      }
      var endTip = function(e, interval_id, cookie, self) {
        e.preventDefault();
        clearInterval(interval_id);
        if (cookie) {
           $.cookie(settings.cookieName, 'ridden', { expires: 365, domain: settings.cookieDomain });
        }
        //alert(settings.postRideCallback+"开始隐藏对象"+ $.noop);
       // alert(settings.postRideCallback != $.noop);
        $(self).parent().parent().hide();
        if (settings.postRideCallback != $.noop) {
        	try{
	        	if(e.srcElement){
	        		settings.postRideCallback(e.srcElement.getAttribute("href"));
	        	}else{
	        		settings.postRideCallback(e.target.getAttribute("href"));
	        	}
        	}catch(e){
        			settings.postRideCallback(e.target.getAttribute("href"));
        	}
        }
      }
      $('.joyride-close-tip').click(function(e) {
        endTip(e, interval_id, settings.cookieMonster, this);
      });

      // When the next button is clicked, show the next tip, only when cookie isn't present
      $('.joyride-next-tip').click(function(e) {
        e.preventDefault();
        if (count >= tipContent.length) {
          endTip(e, interval_id, settings.cookieMonster, this);
        }
        if (settings.timer > 0 && settings.startTimerOnClick) {
          showNextTip();
          clearInterval(interval_id);
          interval_id = setInterval(function() {showNextTip()}, settings.timer);
        } else if (settings.timer > 0 && !settings.startTimerOnClick){
          clearInterval(interval_id);
          interval_id = setInterval(function() {showNextTip()}, settings.timer);
        } else {
          showNextTip();
        }
      });
    });
  };

})(jQuery);
