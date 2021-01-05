/// <reference path="jquery_wev8.js"/>
/*
* resizable
* version: 1.0.0 (05/15/2009)
* @ jQuery v1.2.*
*
* Licensed under the GPL:
*   http://gplv3.fsf.org
*
* Copyright 2008, 2009 Jericho [ thisnamemeansnothing[at]gmail.com ] 
*/
//(function($) {
    $.extend($.fn, {
        getCss: function(key) {
            var v = parseInt(this.css(key));
            if (isNaN(v))
                return false;
            return v;
        }
    });
    $.fn.resizable = function(opts) {
        var ps = $.extend({
            handler: null,
            min: { width: 0, height: 0 },
            max: { width: $(document).width(), height: $(document).height() },
            onResize: function() { },
            onStop: function() { }
        }, opts);
        var resize = {
            resize: function(e) {
                var resizeData = e.data.resizeData;

                var w = Math.min(Math.max(e.pageX - resizeData.offLeft + resizeData.width, resizeData.min.width), ps.max.width);
                var h = Math.min(Math.max(e.pageY - resizeData.offTop + resizeData.height, resizeData.min.height), ps.max.height);
                resizeData.target.css({
                    width: w,
                    height: h
                });
                resizeData.onResize(e);
            },
            stop: function(e) {
                e.data.resizeData.onStop(e);

                document.body.onselectstart = function() { return true; }
                e.data.resizeData.target.css('-moz-user-select', '');

                $().unbind('mousemove', resize.resize)
                    .unbind('mouseup', resize.stop);
            }
        }
        return this.each(function() {
            var me = this;
            var handler = null;
            if (typeof ps.handler == 'undefined' || ps.handler == null)
                handler = $(me);
            else
                handler = (typeof ps.handler == 'string' ? $(ps.handler, this) : ps.handle);
            handler.bind('mousedown', { e: me }, function(s) {
                var target = $(s.data.e);
                var resizeData = {
                    width: target.width() || target.getCss('width'),
                    height: target.height() || target.getCss('height'),
                    offLeft: s.pageX,
                    offTop: s.pageY,
                    onResize: ps.onResize,
                    onStop: ps.onStop,
                    target: target,
                    min: ps.min,
                    max: ps.max
                }

                document.body.onselectstart = function() { return false; }
                target.css('-moz-user-select', 'none');

                $().bind('mousemove', { resizeData: resizeData }, resize.resize)
                    .bind('mouseup', { resizeData: resizeData }, resize.stop);
            });
        });
    }
//})(jQuery); 