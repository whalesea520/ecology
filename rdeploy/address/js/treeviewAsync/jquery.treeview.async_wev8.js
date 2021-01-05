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
			$strSpan = $("<span />");
			$strSpan.html(strSpan);
			if (this.href) {
				var strTarget="_blank";
				if (this.target) strTarget=this.target;
				strSpan="<a href='#' style='' onclick='window.open(\""+this.href+"\","+strTarget+");event.cancelBubble = true; return false;'>" + this.text + "</a>";
				$strSpan.empty();
				$strSpan.html(strSpan);
			}
			
			if (this.onclick) {
				//alert(this.onclick);
				strSpan="<a href='#' style='word-break:break-all' onclick=\""+this.onclick+";event.cancelBubble = true; return false;\">" + this.text + "</a>";
				$strSpan.empty();
				$strSpan.html(strSpan);
			}
			
			var current = $("<li/>").attr("id", this.id || "").append($strSpan).appendTo(parent);
			if(this.target == "hrmGroup" && this.id != "allGroup" && this.id != "publicGroup")
			{
				$strSpan.hover(function() {
                    hrmGroupOnmouseOver(escape($(this).parent().attr('id')), $(this).parent());
                },
                function() {
                    hrmGroupOnmouseOut(escape($(this).parent().attr('id')));
                });
			}
			else if(this.target == "hrmOrg")
			{
				$strSpan.hover(function() {
                    hrmOrgOnmouseOver(escape($(this).parent().attr('id')), $(this).parent());
                },
                function() {
                   hrmOrgOnmouseOut(escape($(this).parent().attr('id')));
                });
			}
			if (this.hasOwnProperty("hasEditRight")) {
				current.attr("_hasEditRight", this.hasEditRight);
			}
			if(this.classtag) {
				current.addClass(this.classtag);
			}
			if(this.targetname){
				current.attr("_targetname",this.targetname);
			}
			if(this.targethead){
				current.attr("_targethead",this.targethead);
			}
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