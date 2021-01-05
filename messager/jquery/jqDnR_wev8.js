/*
 * jqDnR - Minimalistic Drag'n'Resize for jQuery.
 * 
 * Copyright (c) 2007 Brice Burgess <bhb@iceburg.net>, http://www.iceburg.net
 * Licensed under the MIT License:
 * http://www.opensource.org/licenses/mit-license.php
 * 
 * $Version: 2007.08.19 +r2
 */

(function($) {
	$.fn.jqDrag = function(h,option) {
		return i(this, h, 'd');
	};
	$.fn.jqResize = function(h, option) {
		return i(this, h, 'r', null,option);
	};
	$.jqDnR = {
		dnr : {},
		e : 0,
		drag : function(v) {
			if (M.k == 'd')
				E.css({
					left : M.X + v.pageX - M.pX,
					top : M.Y + v.pageY - M.pY
				});
			else {
				var p = M.option;
				//alert(Math.max(v.pageX - M.pX + M.W, 0)+"%$%"+f(p.minWidth))
				//alert(p.minWidth)
				if(Math.max(v.pageX - M.pX + M.W, 0)>parseInt(p.minWidth)){
					E.css({
						width : Math.max(v.pageX - M.pX + M.W, 0)
					});
				}
				
				if(Math.max(v.pageY - M.pY + M.H, 0)>parseInt(p.minHeight)){
					E.css({
						height : Math.max(v.pageY - M.pY + M.H, 0)
					});
				}

			}
			return false;
		},
		stop : function() {
			//取消透明设置
			//E.css('opacity', M.o);
			$(document.body).unbind('mousemove', J.drag).unbind('mouseup', J.stop);
		}
	};
	var J = $.jqDnR, M = J.dnr, E = J.e, i = function(e, h, k, p,option) {
		return e.each(function() {
			h = (h) ? $(h, e) : e;
			h.bind('mousedown', {
				e : e,
				k : k
			}, function(v) {
				var d = v.data, p = {};
				E = d.e;
				// attempt utilization of dimensions plugin to fix IE issues
				if (E.css('position') != 'relative') {
					try {
						E.position(p);
					} catch (e) {
					}
				}
				M = {
					X : p.left || f('left') || 0,
					Y : p.top || f('top') || 0,
					W : f('width') || E[0].scrollWidth || 0,
					H : f('height') || E[0].scrollHeight || 0,
					pX : v.pageX,
					pY : v.pageY,
					k : d.k,
					o : 1,
					option:option
				};
				//取消透明设置
				/*E.css({
					opacity : 0.8
				});*/
				//alert($(this).html())
				//alert($().html())
				$(document.body).mousemove($.jqDnR.drag).mouseup($.jqDnR.stop);
				return false;
			});
		});
	}, f = function(k) {
		return parseInt(E.css(k)) || false;
	};
})(jQuery);