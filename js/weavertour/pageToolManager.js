/**
 * Created by lsj on 2015/4/1.
 */
var pageToolmanager = (function(){

    function  getShowView(item){
        var temp = "<div class='des_container'>"
            +"<h3 class='des_title'>"+item.title+"</h3>"
            +"<div class='des_describe'>"+item.describe+"</div>"
            +"</div>"
        return jQuery(temp);
    }

      return {
        initSliderTour:function(itemtoshow){
            //滑出导航
            var itemcurrent ,tempintem;
            for(var i=0; i<itemtoshow.length; i++){
                itemcurrent = $("#"+itemtoshow[i].itemid);
                if(itemcurrent.length > 0){
                    tempintem = getShowView(itemtoshow[i]);
                    itemcurrent.append(tempintem);
                    itemcurrent.css("overflow","hidden");
                    itemcurrent.hover(function(){
                    	jQuery(this).addClass("boxshaow");
                        jQuery(this).find(".des_container").animate({'right':'0'},1000);
                    },function(){
                    	jQuery(this).removeClass("boxshaow");
                        jQuery(this).find(".des_container").animate({'right':'-274px'},1000);
                    });
                }
            }
        //提示导航
        },initToolTipTour:function(tipItemToShow){
              //提示导航
              var  itemcurrent ,tempintem;
              if(typeof $.fn.tooltip !== 'function'){
            	  this.addToolTip();
              }
              for(var i=0; i<tipItemToShow.length; i++){
                  itemcurrent = $("#"+tipItemToShow[i].itemid);
                  if(itemcurrent.length > 0){
                      itemcurrent.append(" <div class='tooltip_description' style='display:none' title='"+tipItemToShow[i].title+"'>"+tipItemToShow[i].describe+"</div>");
                      itemcurrent.addClass("tooltip"+tipItemToShow[i].position);
                      itemcurrent.tooltip();
                  }
                  itemcurrent.hover(function(){
                      jQuery(this).addClass("boxshaow");
                  },function(){
                      jQuery(this).removeClass("boxshaow");
                  });
              }
        //分步导航
        },initStepsTour:function(steps){
        	  if(document.cookie.indexOf("weavertour=") >= 0)
        		  return;
              var WeaverTour = new window.WeaverTour(steps);
              WeaverTour.startTour();
              var date=new Date();
              date.setDate(date.getDate()+365);
              document.cookie='weavertour=1;expires='+date;  
        },addToolTip:function(){
            $.fn.tooltip = function(settings) {

                var config,
                    tooltip_map = {},
                    id_index = 1;

                 // Configuration setup
                 config = {
                    'dialog_content_selector' : 'div.tooltip_description',
                    'animation_distance' : 50,
                    'opacity' : 0.85,
                    'arrow_left_offset' : 70,
                    'arrow_right_offset' : 20,
                    'arrow_top_offset' : 50,
                    'arrow_height' : 20,
                    'arrow_width' : 20,
                    'animation_duration_ms' : 300,
                    'event_in':'mouseenter',
                    'event_out':'mouseleave',
                    'hover_in_delay' : 0,
                    'hover_out_delay' : 0
                 };

                 if (settings) {
                     $.extend(config, settings);
                 }

                 function _generateDomId() {
                     var time = (new Date()).getTime();
                     id_index += 1;
                     return id_index + "_" + time;
                 }

                 /**
                   * Creates the dialog box element
                   * and appends it to the body
                   **/
                  function _create(content_elm, target_elm) {
                    var header = ($(content_elm).attr("title")) ? "<h1>" + $(content_elm).attr("title") + "</h1>" : '',
                        dom_id = $(target_elm).attr('id'),
                        dialog_elm;

                    if ( !dom_id ) {
                        dom_id = _generateDomId();
                        $(target_elm).attr('id', dom_id);
                    }
                    else if ( tooltip_map[dom_id] ) { // there's a tooltip already assigned to this target element.
                        return  tooltip_map[dom_id];
                    }

                    dialog_elm = $(["<div class='jquery-gdakram-tooltip'>",
                        "<div class='up_arrow arrow'></div>",
                        "<div class='left_arrow arrow'></div>",
                        "<div class='right_arrow arrow'></div>",
                        "<div class='content'>" + header + $(content_elm).html() + "</div>",
                        "<div style='clear:both'></div>",
                        "<div class='down_arrow arrow'></div>",
                        "</div>"
                    ].join(""));
                    dialog_elm.appendTo("body");

                    $(dialog_elm).bind('mouseenter', function(){
                        $(this).attr('data-mouseenter', 1);
                    })
                    .bind('mouseleave', function(){
                        $(this).attr('data-mouseenter', 0);
                    });

                    tooltip_map[dom_id] = dialog_elm;
                    return dialog_elm;
                  }

                 /**
                  * Positions the dialog box based on the target
                  * element's location
                  **/
                 function _show(target_elm) {
                   var dialog_content = $(target_elm).find(config.dialog_content_selector),
                       dialog_box = _create(dialog_content, target_elm),
                       is_top_right = $(target_elm).hasClass("tooltiptopright"),
                       is_bottom_right = $(target_elm).hasClass("tooltipbottomright"),
                       is_left = $(target_elm).hasClass("tooltipleft"),
                       is_top = $(target_elm).hasClass("tooltiptop"),
                       is_bottom = $(target_elm).hasClass("tooltipbottom"),
                       has_position = is_top_right || is_bottom_right || is_top || is_bottom,
                       position,
                       target_elm_position = $(target_elm).offset();

                   // coming from the left
                   if (is_left) {
                       position = {
                         start : {
                           left : target_elm_position.left - config.animation_distance - $(dialog_box).outerWidth(),
                           top  : target_elm_position.top - ($(target_elm).outerHeight() / 2) + config.arrow_right_offset
                         },
                         end : {
                           left : target_elm_position.left - $(dialog_box).outerWidth() + $(dialog_box).find('.right_arrow').outerWidth(),
                           top  : target_elm_position.top - ($(target_elm).outerHeight() / 2) + config.arrow_right_offset
                         },
                         arrow_class : "div.right_arrow"
                       };
                   }
                   // coming from the top right
                   else if (is_top_right || (!has_position && (target_elm_position.top < $(dialog_box).outerHeight() && target_elm_position.top >= config.arrow_top_offset))) {
                     position = {
                       start : {
                         left : target_elm_position.left + $(target_elm).outerWidth() + config.animation_distance,
                         top  : target_elm_position.top + ($(target_elm).outerHeight() / 2) - config.arrow_top_offset
                       },
                       end : {
                         left : target_elm_position.left + $(target_elm).outerWidth(),
                         top  : target_elm_position.top + ($(target_elm).outerHeight() / 2) - config.arrow_top_offset
                       },
                       arrow_class : "div.left_arrow"
                     };
                   }
                   // coming from the bottom right
                   else if (is_bottom_right || (!has_position && (target_elm_position.left < config.arrow_left_offset + $(target_elm).outerWidth() && target_elm_position.top > $(dialog_box).outerHeight()))) {
                     position = {
                       start : {
                         left : target_elm_position.left + $(target_elm).outerWidth() + config.animation_distance,
                         top  : target_elm_position.top + ($(target_elm).outerHeight() / 2) + config.arrow_top_offset - $(dialog_box).outerHeight() + config.arrow_height
                       },
                       end : {
                         left : target_elm_position.left + $(target_elm).outerWidth(),
                         top  : target_elm_position.top + ($(target_elm).outerHeight() / 2) + config.arrow_top_offset - $(dialog_box).outerHeight() + config.arrow_height
                       },
                       arrow_class : "div.left_arrow"
                     };
                     $(dialog_box).find("div.left_arrow").css({ top: $(dialog_box).outerHeight() - (config.arrow_top_offset * 2) + "px" });
                   }
                   // coming from the top
                   else if (is_top || (!has_position &&(target_elm_position.top + config.animation_distance > $(dialog_box).outerHeight() && target_elm_position.left >= config.arrow_left_offset))) {
                     position = {
                       start : {
                         left : target_elm_position.left + ($(target_elm).outerWidth() / 2) - config.arrow_left_offset,
                         top  : target_elm_position.top - config.animation_distance - $(dialog_box).outerHeight()
                       },
                       end : {
                         left : target_elm_position.left + ($(target_elm).outerWidth() / 2) - config.arrow_left_offset,
                         top  : target_elm_position.top - $(dialog_box).outerHeight() + config.arrow_height
                       },
                       arrow_class : "div.down_arrow"
                     };
                   }
                   // coming from the bottom
                   else if (is_bottom || (!has_position &&(target_elm_position.top + config.animation_distance < $(dialog_box).outerHeight()))) {
                     position = {
                       start : {
                         left : target_elm_position.left + ($(target_elm).outerWidth() / 2) - config.arrow_left_offset,
                         top  : target_elm_position.top + $(target_elm).outerHeight() + config.animation_distance
                       },
                       end : {
                         left : target_elm_position.left + ($(target_elm).outerWidth() / 2) - config.arrow_left_offset,
                         top  : target_elm_position.top + $(target_elm).outerHeight()
                       },
                       arrow_class : "div.up_arrow"
                     };
                   }

                   // position and show the box
                   $(dialog_box).css({
                     top : position.start.top + "px",
                     left : position.start.left + "px",
                     opacity : config.opacity
                   });
                   $(dialog_box).find("div.arrow").hide();
                   $(dialog_box).find(position.arrow_class).show();

                   // begin animation
                   $(dialog_box).animate({
                     top : position.end.top,
                     left: position.end.left,
                     opacity : "toggle"
                   }, config.animation_duration_ms);

                 } // -- end _show function

                 /**
                  * Stop the animation (if any) and remove from dialog box from the DOM
                  */
                 function _hide(target_elm) {
                     var dom_id = $(target_elm).attr('id'),
                         dialog_elm = tooltip_map[dom_id];

                     if ( dialog_elm ) {
                         // user's still over the tooltip, will hide, once out of the tooltip.
                         if ( parseInt(dialog_elm.attr('data-mouseenter'), 10) ) {
                             setTimeout(function(){
                                 _hide(target_elm);
                             }, 500);
                         }
                         else {
                             dialog_elm.unbind();
                             dialog_elm.stop().remove();
                             delete tooltip_map[dom_id];
                         }
                     }
                 }


                 /**
                  * Apply interaction to all the matching elements
                  **/
                 this.each(function() {
                    var hoverTimer,
                        ele = this;

                    $(this).bind(config.event_in, function(){
                         clearTimeout(hoverTimer);
                         hoverTimer = setTimeout(function() { _show(ele); }, config.hover_in_delay );
                    })
                    .bind(config.event_out, function(){
                         clearTimeout(hoverTimer);
                         hoverTimer = setTimeout(function() {
                             _hide(ele);
                         }, config.hover_out_delay );
                    });
                 });

                 return this;
           };
        	        	
        }
     }
})();