Ext.ns("Ext.ux");
Ext.ux.iconMgr = function(f) {
	var iconBase = '/images';
	var c = " \n\r .{0} {  background-image: url({1}) !important; }";
	this.styleSheetNum = document.styleSheets.length;
	var b = "TDGi_iconMgr_" + Ext.id();
	var e = Ext.get(Ext.util.CSS.createStyleSheet("/* TDG-i.iconMgr stylesheet */\n", b));
	var d = "_wev8.gif";
	var a = new Ext.data.JsonStore( {
	autoLoad : false,
	fields : [ {
	name : "name",
	mapping : "name"
	}, {
	name : "cssRule",
	mapping : "cssRule"
	}, {
	name : "styleBody",
	mapping : "styleBody"
	} ]
	});
	return {
		getIcon : function(j) {
			var i = "tdgi_icon_" + Ext.id();
			var h = iconBase + "/silk/" + j + d;
			var g = String.format(c, i, h);
			var l = a.findBy(function(n, m) {
				if (n.data.name == j) {
					return (m)
				}
			});
			if (l < 0) {
				a.add(new Ext.data.Record( {
				name : j,
				cssRule : i,
				styleTxt : g
				}));
				var k = Ext.get(b);
				if (!Ext.isIE) {
					k.dom.sheet.insertRule(g, k.dom.sheet.cssRules.length)
				} else {
					document.styleSheets[b].cssText += g
				}
				Ext.util.CSS.refreshCache();
				return (i)
			} else {
				return (a.getAt(l).data.cssRule)
			}
		}
	}
}();
Ext.ux.iconBrowser = function() {
	var h;
	var e;
	var b;
	var f = "../../../images";
	var g = "icons_wev8.js";
	var d = f + "/silk";
	var c = (Ext.isIE6) ? "_wev8.gif" : "_wev8.png";
	var a = Ext.id();
	return {
	init : function() {
		if (!h) {
			var j = new Ext.data.SimpleStore( {
			url : g,
			autoLoad : true,
			id : "name",
			fields : [ "icon" ],
			listeners : {
				load : function() {
					h.body.unmask()
				}
			}
			});
			e = new Ext.DataView( {
			itemSelector : "div.iconwrap",
			style : "overflow:auto",
			multiSelect : false,
			store : j,
			border : true,
			trackOver : true,
			overClass : "x-grid3-row-alt",
			tpl : new Ext.XTemplate('<tpl for=".">', '<div class="iconwrap" style="float: left;padding: 4px 4px 0px 4px;" id="' + Ext.idSeed + '_{icon}">', '<div style=""><img src="' + d + "/{icon}" + c + '" class="thumb-img"></div>', "</div>", "</tpl>"),
			listeners : {
			mouseenter : function(l, m, n, k) {
				Ext.fly(h.topToolbar.items.items[2].el).update("" + j.getAt(m).data.icon)
			},
			mouseleave : function(l, m, n, k) {
				Ext.fly(h.topToolbar.items.items[2].el).update("&nbsp;")
			}
			}
			});
			var i = new Ext.form.TextField( {
			width : 150,
			emptyText : "Type to filter...",
			enableKeyEvents : true,
			listeners : {
				keyup : {
				buffer : 200,
				fn : function() {
					var k = this.getValue();
					var l = 0;
					j.filterBy(function(m, o) {
						var n = new RegExp(".*" + k + ".*");
						if (m.data.icon.match(n) != null) {
							return (true)
						} else {
							return (false)
						}
					})
				}
				}
			}
			});
			h = new Ext.Window( {
			height : 400,
			width : 400,
			minHeight : 350,
			minWidth : 350,
			layout : "fit",
			closeAction : "hide",
			title : "TDG-i icon browser",
			items : e,
			buttons : [ {
			text : "OK",
			handler : this.hide,
			scope : this
			} ],
			listeners : {
				render : {
				delay : 50,
				fn : function() {
					h.body.mask("Working...", "x-mask-loading")
				}
				}
			},
			tbar : [ i, "-", "" ]
			})
		}
	},
	hide : function() {
		h.hide()
	},
	show : function() {
		this.init();
		h.show()
	}
	}
}();