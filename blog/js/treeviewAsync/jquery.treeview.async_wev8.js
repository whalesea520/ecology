/*
 * Async Treeview 0.1 - Lazy-loading extension for Treeview
 * 
 * http://bassistance.de/jquery-plugins/jquery-plugin-treeview/
 *
 * Copyright (c) 2007 J枚rn Zaefferer
 *
 * Dual licensed under the MIT and GPL licenses:
 *   http://www.opensource.org/licenses/mit-license.php
 *   http://www.gnu.org/licenses/gpl.html
 *
 * Revision: $Id$
 *
 */

;(function($) {

function load(settings, root, child, container) {
	$.getJSON(settings.url, {root: root}, function(response) {
		function createNode(parent) {
			var strSpan="<span>" + this.text + "</span>";
			if (this.href) {
				var strTarget="_blank";
				if (this.target) strTarget=this.target;
				strSpan="<span><a href='javascript:void(0)' style='' onclick='window.open(\""+this.href+"\","+strTarget+");event.cancelBubble = true; return false;'>" + this.text + "</a></span>";
			}
			
			if (this.onclick||this.ondblclick) {
				//alert(this.onclick);
				var click = "";
				if(this.onclick){
					click = "onclick=\""+this.onclick+";return false;\""; 
				}
				if(this.ondblclick){
					click +=" ondblclick=\""+this.ondblclick+";return false;\""; 
				}
				strSpan="<span><a href='javascript:void(0)' style='word-break:break-all' "+click+">" + this.text + "</a></span>";
			}
			
			
			
			var current = $("<li/>").attr("id", this.id || "").html(strSpan).appendTo(parent);
			if (this.classes) {
				current.children("span").addClass(this.classes);
			}
			if (this.expanded) {
				current.addClass("open");
			}
			if (this.hasChildren || this.children && this.children.length) {
				current.children("span").addClass("folder");
				var branch = $("<ul/>").appendTo(current);
				if (this.hasChildren) {
					current.addClass("hasChildren");
					createNode.call({
						text:"placeholder",
						id:"placeholder",
						children:[]
					}, branch);
				}
				if (this.children && this.children.length) {
					$.each(this.children, createNode, [branch])
				}
				
			} else {
				if (this.isFolder) {
					current.children("span").addClass("folder");
				} else {				
					current.children("span").addClass("file");
				}
			}
		}
		$.each(response, createNode, [child]);
        $(container).treeview({add: child});
    });
}

var proxied = $.fn.treeview;
$.fn.treeview = function(settings) {
	if (!settings.url) {
		return proxied.apply(this, arguments);
	}
	var container = this;
	load(settings, "source", this, container);
	var userToggle = settings.toggle;
	return proxied.call(this, $.extend({}, settings, {
		collapsed: true,
		toggle: function() {			
			var $this = $(this);
			if ($this.hasClass("hasChildren")) {
				var childList = $this.removeClass("hasChildren").find("ul");
				childList.empty();
				load(settings, this.id, childList, container);
			}
			
			if (userToggle) {
				userToggle.apply(this, arguments);
			}
		}
	}));
};

})(jQuery);