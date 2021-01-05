(function(a) {
	function n(p, m) {
		function y(c) {
			return a.isArray(k.readonly) ? (c = a(".dwwl", x).index(c), k.readonly[c]) : k.readonly
		}
		function Q(a) {
			var c = "",
			p;
			for (p in U[a]) c += '<li class="dw-v" data-val="' + p + '" style="height:' + I + "px;line-height:" + I + 'px;"><div class="dw-i">' + U[a][p] + "</div></li>";
			return c
		}
		function i() {
			var a = document.body,
			c = document.documentElement;
			return Math.max(a.scrollHeight, a.offsetHeight, c.clientHeight, c.scrollHeight, c.offsetHeight)
		}
		function g(c) {
			b = a("li.dw-v", c).eq(0).index();
			d = a("li.dw-v", c).eq( - 1).index();
			w = a("ul", x).index(c);
			h = I;
			q = r
		}
		function A(a) {
			var c = k.headerText;
			return c ? "function" == typeof c ? c.call(O, a) : c.replace(/\{value\}/i, a) : ""
		}
		function l() {
			r.temp = R && (null !== r.val && r.val != E.val() || !E.val().length) || null === r.values ? k.parseValue(E.val() || "", r) : r.values.slice(0);
			r.setValue(!0)
		}
		function n(c, p, y, m) {
			K("validate", [x, p]);
			a(".dww ul", x).each(function(y) {
				var b = a(this),
				o = a('li[data-val="' + r.temp[y] + '"]', b),
				v = o.index(),
				e = y == p || void 0 === p;
				if (!o.hasClass("dw-v")) {
					for (var f = o,
					k = 0,
					d = 0; f.prev().length && !f.hasClass("dw-v");) f = f.prev(),
					k++;
					for (; o.next().length && !o.hasClass("dw-v");) o = o.next(),
					d++; (d < k && d && 2 !== m || !k || !f.hasClass("dw-v") || 1 == m) && o.hasClass("dw-v") ? v += d: (o = f, v -= k)
				}
				if (!o.hasClass("dw-sel") || e) r.temp[y] = o.attr("data-val"),
				a(".dw-sel", b).removeClass("dw-sel"),
				o.addClass("dw-sel"),
				r.scroll(b, y, v, c)
			});
			r.change(y)
		}
		function C() {
			function c() {
				a(".dwc", x).each(function() {
					f = a(this).outerWidth(!0);
					p += f;
					o = f > o ? f: o
				});
				f = p > y ? o: p;
				f = a(".dwwr", x).width(f + 1).outerWidth();
				Q = v.outerHeight()
			}
			if ("inline" != k.display) {
				var p = 0,
				o = 0,
				y = a(window).width(),
				m = window.innerHeight,
				b = a(window).scrollTop(),
				v = a(".dw", x),
				f,
				e,
				d,
				Q,
				j,
				g = {},
				F,
				s = void 0 === k.anchor ? E: k.anchor,
				m = m || a(window).height();
				if ("modal" == k.display) c(),
				d = (y - f) / 2,
				e = b + (m - Q) / 2;
				else if ("bubble" == k.display) {
					c();
					var h = s.offset(),
					r = a(".dw-arr", x),
					P = a(".dw-arrw-i", x),
					q = v.outerWidth();
					j = s.outerWidth();
					d = h.left - (v.outerWidth(!0) - j) / 2;
					d = d > y - q ? y - (q + 20) : d;
					d = 0 <= d ? d: 20;
					e = h.top - (v.outerHeight() + 3);
					e < b || h.top > b + m ? (v.removeClass("dw-bubble-top").addClass("dw-bubble-bottom"), e = h.top + s.outerHeight() + 3, F = e + v.outerHeight(!0) > b + m || h.top > b + m) : v.removeClass("dw-bubble-bottom").addClass("dw-bubble-top");
					e = e >= b ? e: b;
					b = h.left + j / 2 - (d + (q - P.outerWidth()) / 2);
					b > P.outerWidth() && (b = P.outerWidth());
					r.css({
						left: b
					})
				} else g.width = "100%",
				"top" == k.display ? e = b: "bottom" == k.display && (e = b + m - v.outerHeight(), e = 0 <= e ? e: 0);
				g.top = e;
				g.left = d;
				v.css(g);
				a(".dwo, .dw-persp", x).height(0).height(i());
				F && a(window).scrollTop(e + v.outerHeight(!0) - m)
			}
		}
		function K(c, p) {
			var b;
			p.push(r);
			a.each([V, m],
			function(a, o) {
				o[c] && (b = o[c].apply(O, p))
			});
			return b
		}
		function aa(a) {
			var c = +a.data("pos") + 1;
			e(a, c > d ? b: c, 1)
		}
		function ba(a) {
			var c = +a.data("pos") - 1;
			e(a, c < b ? d: c, 2)
		}
		var r = this,
		W = a.mobiscroll,
		O = p,
		E = a(O),
		X,
		Y,
		k = G({},
		Z),
		V = {},
		$,
		I,
		L,
		x,
		U = [],
		S = {},
		R = E.is("input"),
		T = !1;
		r.enable = function() {
			k.disabled = !1;
			R && E.prop("disabled", !1)
		};
		r.disable = function() {
			k.disabled = !0;
			R && E.prop("disabled", !0)
		};
		r.scroll = function(a, c, p, b, o, y) {
			function m() {
				clearInterval(S[c]);
				S[c] = void 0;
				a.data("pos", p).closest(".dwwl").removeClass("dwa")
			}
			var v = ($ - p) * I,
			e,
			y = y || M;
			a.attr("style", (b ? N + "-transition:all " + b.toFixed(1) + "s ease-out;": "") + (F ? N + "-transform:translate3d(0," + v + "px,0);": "top:" + v + "px;"));
			S[c] && m();
			b && void 0 !== o ? (e = 0, a.closest(".dwwl").addClass("dwa"), S[c] = setInterval(function() {
				e += 0.1;
				a.data("pos", Math.round((p - o) * Math.sin(e / b * (Math.PI / 2)) + o));
				e >= b && (m(), y())
			},
			100), K("onAnimStart", [c, b])) : (a.data("pos", p), y())
		};
		r.setValue = function(a, c, b, p) {
			p || (r.values = r.temp.slice(0));
			T && a && n(b);
			c && (L = k.formatResult(r.temp), r.val = L, R && E.val(L).trigger("change"))
		};
		r.validate = function(a, c) {
			n(0.2, a, !0, c)
		};
		r.change = function(c) {
			L = k.formatResult(r.temp);
			"inline" == k.display ? r.setValue(!1, c) : a(".dwv", x).html(A(L));
			c && K("onChange", [L])
		};
		r.hide = function(c) {
			if (!1 === K("onClose", [L])) return ! 1;
			a(".dwtd").prop("disabled", !1).removeClass("dwtd");
			E.blur();
			x && ("inline" != k.display && k.animate && !c ? (a(".dw", x).addClass("dw-" + k.animate + " dw-out"), setTimeout(function() {
				x.remove();
				x = null
			},
			350)) : (x.remove(), x = null), T = !1, a(window).unbind(".dw"))
			unbindTouchEvent();
		};
		r.changeWheel = function() {
			if (x) {
				var c = 0,
				b, p, o, y = arguments.length;
				for (b in k.wheels) for (p in k.wheels[b]) {
					if ( - 1 < a.inArray(c, arguments) && (U[c] = k.wheels[b][p], o = a("ul", x).eq(c), o.html(Q(c)), y--, !y)) {
						C();
						n();
						return
					}
					c++
				}
			}
		};
		r.show = function(b) {
			if (k.disabled || T) return ! 1;
			"top" == k.display && (k.animate = "slidedown");
			"bottom" == k.display && (k.animate = "slideup");
			l();
			K("onBeforeShow", [x]);
			var p = 0,
			m, d = "",
			i = "",
			h = "";
			k.animate && !b && (i = '<div class="dw-persp">', h = "</div>", d = "dw-" + k.animate + " dw-in");
			d = '<div class="' + k.theme + " dw-" + k.display + '">' + ("inline" == k.display ? '<div class="dw dwbg dwi"><div class="dwwr">': i + '<div class="dwo"></div><div class="dw dwbg ' + d + '"><div class="dw-arrw"><div class="dw-arrw-i"><div class="dw-arr"></div></div></div><div class="dwwr">' + (k.headerText ? '<div class="dwv"></div>': ""));
			for (b = 0; b < k.wheels.length; b++) {
				d += '<div class="dwc' + ("scroller" != k.mode ? " dwpm": " dwsc") + (k.showLabel ? "": " dwhl") + '"><div class="dwwc dwrc"><table cellpadding="0" cellspacing="0"><tr>';
				for (m in k.wheels[b]) U[p] = k.wheels[b][m],
				d += '<td><div class="dwwl dwrc dwwl' + p + '">' + ("scroller" != k.mode ? '<div class="dwwb dwwbp" style="height:' + I + "px;line-height:" + I + 'px;"><span>+</span></div><div class="dwwb dwwbm" style="height:' + I + "px;line-height:" + I + 'px;"><span>&ndash;</span></div>': "") + '<div class="dwl">' + m + '</div><div class="dww dwrc" style="height:' + k.rows * I + "px;min-width:" + k.width + 'px;"><ul>',
				d += Q(p),
				d += '</ul><div class="dwwo"></div></div><div class="dwwol"></div></div></td>',
				p++;
				d += "</tr></table></div></div>"
			}
			d += ("inline" != k.display ? '<div class="dwbc' + (k.button3 ? " dwbc-p": "") + '"><span class="dwbw dwb-s"><span class="dwb">' + k.setText + "</span></span>" + (k.button3 ? '<span class="dwbw dwb-n"><span class="dwb">' + k.button3Text + "</span></span>": "") + '<span class="dwbw dwb-c"><span class="dwb">' + k.cancelText + "</span></span></div>" + h: '<div class="dwcc"></div>') + "</div></div></div>";
			x = a(d);
			n();
			"inline" != k.display ? x.appendTo("body") : E.is("div") ? E.html(x) : x.insertAfter(E);
			T = !0;
			"inline" != k.display && (a(".dwb-s span", x).click(function() {
				if (r.hide() !== false) {
					r.setValue(false, true);
					K("onSelect", [r.val])
				}
				return false
			}), a(".dwb-c span", x).click(function() {
				r.hide() !== false && K("onCancel", [r.val]);
				return false
			}), k.button3 && a(".dwb-n span", x).click(k.button3), k.scrollLock && x.bind("touchmove",
			function(a) {
				a.preventDefault()
			}), a("input,select").each(function() {
				a(this).prop("disabled") || a(this).addClass("dwtd")
			}), a("input,select").prop("disabled", !0), C(), a(window).bind("resize.dw", C));
			x.delegate(".dwwl", "DOMMouseScroll mousewheel",
			function(c) {
				if (!y(this)) {
					c.preventDefault();
					var c = c.originalEvent,
					c = c.wheelDelta ? c.wheelDelta / 120 : c.detail ? -c.detail / 3 : 0,
					b = a("ul", this),
					p = +b.data("pos"),
					p = Math.round(p - c);
					g(b);
					e(b, p, c < 0 ? 1 : 2)
				}
			}).delegate(".dwb, .dwwb", J,
			function() {
				a(this).addClass("dwb-a")
			}).delegate(".dwwb", J,
			function(c) {
				var b = a(this).closest(".dwwl");
				if (!y(b) && !b.hasClass("dwa")) {
					c.preventDefault();
					c.stopPropagation();
					var p = b.find("ul"),
					o = a(this).hasClass("dwwbp") ? aa: ba;
					f = true;
					g(p);
					clearInterval(j);
					j = setInterval(function() {
						o(p)
					},
					k.delay);
					o(p)
				}
			}).delegate(".dwwl", J,
			function(b) {
				b.preventDefault();
				if (!y(this) && !f && k.mode != "clickpick") {
					s = true;
					t = a("ul", this);
					t.closest(".dwwl").addClass("dwa");
					c = +t.data("pos");
					g(t);
					v = S[w] !== void 0;
					B = z(b);
					o = new Date;
					u = B;
					r.scroll(t, w, c)
				}
			});
			K("onShow", [x, L]);
			X.init(x, r)
		};
		r.init = function(a) {
			X = G({
				defaults: {},
				init: M
			},
			W.themes[a.theme || k.theme]);
			Y = W.i18n[a.lang || k.lang];
			G(m, a);
			G(k, X.defaults, Y, m);
			r.settings = k;
			E.unbind(".dw");
			if (a = W.presets[k.preset]) V = a.call(O, r),
			G(k, V, m),
			G(H, V.methods);
			$ = Math.floor(k.rows / 2);
			I = k.height;
			void 0 !== E.data("dwro") && (O.readOnly = D(E.data("dwro")));
			T && r.hide();
			"inline" == k.display ? r.show() : (l(), R && k.showOnFocus && (E.data("dwro", O.readOnly), O.readOnly = !0, E.bind("focus.dw",
			function() {
				r.show()
				bindTouchEvent();
			})))
		};
		r.values = null;
		r.val = null;
		r.temp = null;
		r.init(m)
	}
	function l(a) {
		for (var c in a) if (void 0 !== m[a[c]]) return ! 0;
		return ! 1
	}
	function z(a) {
		var c = a.originalEvent,
		b = a.changedTouches;
		return b || c && c.changedTouches ? c ? c.changedTouches[0].pageY: b[0].pageY: a.pageY
	}
	function D(a) {
		return ! 0 === a || "true" == a
	}
	function A(a, c, b) {
		a = a > b ? b: a;
		return a < c ? c: a
	}
	function e(c, o, m, e, v) {
		var o = A(o, b, d),
		f = a("li", c).eq(o),
		i = w,
		e = e ? o == v ? 0.1 : Math.abs(0.1 * (o - v)) : 0;
		q.scroll(c, i, o, e, v,
		function() {
			q.temp[i] = f.attr("data-val");
			q.validate(i, m)
		})
	}
	function g(a, c, b) {
		return H[c] ? H[c].apply(a, Array.prototype.slice.call(b, 1)) : "object" === typeof c ? H.init.call(a, c) : a
	}
	var i = {},
	j, M = function() {},
	h,
	b,
	d,
	q,
	C = (new Date).getTime(),
	s,
	f,
	t,
	w,
	B,
	u,
	o,
	c,
	v,
	m = document.createElement("modernizr").style,
	F = l(["perspectiveProperty", "WebkitPerspective", "MozPerspective", "OPerspective", "msPerspective"]),
	N = function() {
		var a = ["Webkit", "Moz", "O", "ms"],
		c;
		for (c in a) if (l([a[c] + "Transform"])) return "-" + a[c].toLowerCase();
		return ""
	} (),
	G = a.extend,
	J = "touchstart mousedown",
	Z = {
		width: 70,
		height: 40,
		rows: 3,
		delay: 300,
		disabled: !1,
		readonly: !1,
		showOnFocus: !0,
		showLabel: !0,
		wheels: [],
		theme: "",
		headerText: "{value}",
		display: "modal",
		mode: "scroller",
		preset: "",
		lang: "en-US",
		setText: "Set",
		cancelText: "Cancel",
		scrollLock: !0,
		formatResult: function(a) {
			return a.join(" ")
		},
		parseValue: function(a, c) {
			var b = c.settings.wheels,
			o = a.split(" "),
			m = [],
			e = 0,
			d,
			v,
			f;
			for (d = 0; d < b.length; d++) for (v in b[d]) {
				if (void 0 !== b[d][v][o[e]]) m.push(o[e]);
				else for (f in b[d][v]) {
					m.push(f);
					break
				}
				e++
			}
			return m
		}
	},
	H = {
		init: function(a) {
			void 0 === a && (a = {});
			return this.each(function() {
				this.id || (C += 1, this.id = "scoller" + C);
				i[this.id] = new n(this, a)
			})
		},
		enable: function() {
			return this.each(function() {
				var a = i[this.id];
				a && a.enable()
			})
		},
		disable: function() {
			return this.each(function() {
				var a = i[this.id];
				a && a.disable()
			})
		},
		isDisabled: function() {
			var a = i[this[0].id];
			if (a) return a.settings.disabled
		},
		option: function(a, c) {
			return this.each(function() {
				var b = i[this.id];
				if (b) {
					var o = {};
					"object" === typeof a ? o = a: o[a] = c;
					b.init(o)
				}
			})
		},
		setValue: function(a, c, b, o) {
			return this.each(function() {
				var d = i[this.id];
				d && (d.temp = a, d.setValue(!0, c, b, o))
			})
		},
		getInst: function() {
			return i[this[0].id]
		},
		getValue: function() {
			var a = i[this[0].id];
			if (a) return a.values
		},
		show: function() {
			var a = i[this[0].id];
			if (a) return a.show()
		},
		hide: function() {
			return this.each(function() {
				var a = i[this.id];
				a && a.hide()
			})
		},
		destroy: function() {
			return this.each(function() {
				var c = i[this.id];
				c && (c.hide(), a(this).unbind(".dw"), delete i[this.id], a(this).is("input") && (this.readOnly = D(a(this).data("dwro"))))
			})
		}
	};
	
	function touchmoveEvent(a) {
		s && (a.preventDefault(), u = z(a), q.scroll(t, w, A(c + (B - u) / h, b - 1, d + 1)), v = !0)
	}
	
	function touchendEvent(m) {
		if (s) {
			m.preventDefault();
			var i = new Date - o,
			m = A(c + (B - u) / h, b - 1, d + 1),
			y;
			y = t.offset().top;
			300 > i ? (i = (u - B) / i, i = i * i / 0.0012, 0 > u - B && (i = -i)) : i = u - B;
			if (!i && !v) {
				y = Math.floor((u - y) / h);
				var g = a("li", t).eq(y);
				g.addClass("dw-hl");
				setTimeout(function() {
					g.removeClass("dw-hl")
				},
				200)
			} else y = Math.round(c - i / h);
			e(t, y, 0, !0, Math.round(m));
			s = !1;
			t = null
		}
		f && (clearInterval(j), f = !1);
		a(".dwb-a").removeClass("dwb-a")
	}
	
	function bindTouchEvent() {
		a(document).bind("touchmove mousemove", touchmoveEvent);
		a(document).bind("touchend mouseup",touchendEvent);
	}
	
	function unbindTouchEvent() {
		a(document).unbind("touchmove mousemove",touchmoveEvent);
		a(document).unbind("touchend mouseup",touchendEvent);
	}
	a.fn.mobiscroll = function(c) {
		G(this, a.mobiscroll.shorts);
		return g(this, c, arguments)
	};
	a.mobiscroll = a.mobiscroll || {
		setDefaults: function(a) {
			G(Z, a)
		},
		presetShort: function(a) {
			this.shorts[a] = function(c) {
				return g(this, G(c, {
					preset: a
				}), arguments)
			}
		},
		shorts: {},
		presets: {},
		themes: {},
		i18n: {}
	};
	a.scroller = a.scroller || a.mobiscroll;
	a.fn.scroller = a.fn.scroller || a.fn.mobiscroll
})(jQuery); (function(a) {
	a.mobiscroll.i18n.hu = a.extend(a.mobiscroll.i18n.hu, {
		setText: "OK",
		cancelText: "M\u00e9gse"
	})
})(jQuery); (function(a) {
	a.mobiscroll.i18n.de = a.extend(a.mobiscroll.i18n.de, {
		setText: "OK",
		cancelText: "Abbrechen"
	})
})(jQuery); (function(a) {
	a.mobiscroll.i18n.es = a.extend(a.mobiscroll.i18n.es, {
		setText: "Aceptar",
		cancelText: "Cancelar"
	})
})(jQuery); (function(a) {
	a.mobiscroll.i18n.fr = a.extend(a.mobiscroll.i18n.fr, {
		setText: "Termin\u00e9",
		cancelText: "Annuler"
	})
})(jQuery); (function(a) {
	a.mobiscroll.i18n.it = a.extend(a.mobiscroll.i18n.it, {
		setText: "OK",
		cancelText: "Annulla"
	})
})(jQuery); (function(a) {
	var n = {
		inputClass: "",
		invalid: [],
		rtl: !1,
		group: !1,
		groupLabel: "Groups"
	};
	a.mobiscroll.presetShort("select");
	a.mobiscroll.presets.select = function(l) {
		function z(a) {
			return a ? a.replace(/_/, "") : ""
		}
		function D() {
			var b, c = 0,
			d = {},
			m = [{}];
			e.group ? (e.rtl && (c = 1), a("optgroup", g).each(function(c) {
				d["_" + c] = a(this).attr("label")
			}), m[c] = {},
			m[c][e.groupLabel] = d, b = j, c += e.rtl ? -1 : 1) : b = g;
			m[c] = {};
			m[c][C] = {};
			a("option", b).each(function() {
				var b = a(this).attr("value");
				m[c][C]["_" + b] = a(this).text();
				a(this).prop("disabled") && s.push(b)
			});
			return m
		}
		var A = l.settings,
		e = a.extend({},
		n, A),
		g = a(this),
		i = g.val(),
		j = g.find('option[value="' + g.val() + '"]').parent(),
		M = j.index() + "",
		h = M,
		b,
		d = this.id + "_dummy";
		a('label[for="' + this.id + '"]').attr("for", d);
		var q = a('label[for="' + d + '"]'),
		C = void 0 !== e.label ? e.label: q.length ? q.text() : g.attr("name"),
		s = [],
		f = {},
		t,
		w,
		B = A.readonly;
		e.group && !a("optgroup", g).length && (e.group = !1);
		e.invalid.length || (e.invalid = s);
		e.group ? e.rtl ? (t = 1, w = 0) : (t = 0, w = 1) : (t = -1, w = 0);
		a("#" + d).remove();
		a("option", g).each(function() {
			f[a(this).attr("value")] = a(this).text()
		});
		var u = a('<input type="text" id="' + d + '" value="' + f[g.val()] + '" class="' + e.inputClass + '" readonly />').insertBefore(g);
		e.showOnFocus && u.focus(function() {
			l.show()
		});
		g.bind("change",
		function() { ! b && i != g.val() && l.setSelectVal([g.val()], true);
			b = false
		}).hide().closest(".ui-field-contain").trigger("create");
		l.setSelectVal = function(a, c, b) {
			i = a[0];
			if (e.group) {
				j = g.find('option[value="' + i + '"]').parent();
				h = j.index();
				l.temp = e.rtl ? ["_" + i, "_" + j.index()] : ["_" + j.index(), "_" + i];
				if (h !== M) {
					A.wheels = D();
					l.changeWheel(w);
					M = h + ""
				}
			} else l.temp = ["_" + i];
			l.setValue(true, c, b);
			if (c) {
				u.val(f[i]);
				a = i !== g.val();
				g.val(i);
				a && g.trigger("change")
			}
		};
		l.getSelectVal = function(a) {
			return z((a ? l.temp: l.values)[w])
		};
		return {
			width: 50,
			wheels: void 0,
			headerText: !1,
			anchor: u,
			formatResult: function(a) {
				return f[z(a[w])]
			},
			parseValue: function() {
				i = g.val();
				j = g.find('option[value="' + i + '"]').parent();
				h = j.index();
				return e.group && e.rtl ? ["_" + i, "_" + h] : e.group ? ["_" + h, "_" + i] : ["_" + i]
			},
			validate: function(b, c) {
				if (c === t) {
					h = z(l.temp[t]);
					if (h !== M) {
						j = g.find("optgroup").eq(h);
						h = j.index();
						i = (i = j.find("option").eq(0).val()) || g.val();
						A.wheels = D();
						if (e.group) {
							l.temp = e.rtl ? ["_" + i, "_" + h] : ["_" + h, "_" + i];
							l.changeWheel(w);
							M = h + ""
						}
					}
					A.readonly = B
				} else i = z(l.temp[w]);
				var d = a("ul", b).eq(w);
				a.each(e.invalid,
				function(c, b) {
					a('li[data-val="_' + b + '"]', d).removeClass("dw-v")
				})
			},
			onAnimStart: function(a) {
				if (a === t) A.readonly = [e.rtl, !e.rtl]
			},
			onBeforeShow: function() {
				A.wheels = D();
				if (e.group) l.temp = e.rtl ? ["_" + i, "_" + j.index()] : ["_" + j.index(), "_" + i]
			},
			onSelect: function(a) {
				u.val(a);
				b = true;
				g.val(z(l.values[w])).trigger("change");
				if (e.group) l.values = null
			},
			onCancel: function() {
				if (e.group) l.values = null
			},
			onChange: function(a) {
				if (e.display == "inline") {
					u.val(a);
					b = true;
					g.val(z(l.temp[w])).trigger("change")
				}
			},
			onClose: function() {
				u.blur()
			},
			methods: {
				setValue: function(b, c, d) {
					return this.each(function() {
						var m = a(this).mobiscroll("getInst");
						if (m) if (m.setSelectVal) m.setSelectVal(b, c, d);
						else {
							m.temp = b;
							m.setValue(true, c, d)
						}
					})
				},
				getValue: function(b) {
					var c = a(this).mobiscroll("getInst");
					if (c) return c.getSelectVal ? c.getSelectVal(b) : c.values
				}
			}
		}
	}
})(jQuery); (function(a) {
	var n = a.mobiscroll,
	l = new Date,
	z = {
		dateFormat: "mm/dd/yy",
		dateOrder: "mmddy",
		timeWheels: "hhiiA",
		timeFormat: "hh:ii A",
		startYear: l.getFullYear() - 100,
		endYear: l.getFullYear() + 20,
		monthNames: "January,February,March,April,May,June,July,August,September,October,November,December".split(","),
		monthNamesShort: "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec".split(","),
		dayNames: "Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday".split(","),
		dayNamesShort: "Sun,Mon,Tue,Wed,Thu,Fri,Sat".split(","),
		shortYearCutoff: "+10",
		monthText: "Month",
		dayText: "Day",
		yearText: "Year",
		hourText: "Hours",
		minuteText: "Minutes",
		secText: "Seconds",
		ampmText: "&nbsp;",
		nowText: "Now",
		showNow: !1,
		stepHour: 1,
		stepMinute: 1,
		stepSecond: 1,
		separator: " "
	},
	D = function(A) {
		function e(a, c, b) {
			return void 0 !== s[c] ? +a[s[c]] : void 0 !== b ? b: F[t[c]] ? F[t[c]]() : t[c](F)
		}
		function g(a, c) {
			return Math.floor(a / c) * c
		}
		function i(a) {
			var c = e(a, "h", 0);
			return new Date(e(a, "y"), e(a, "m"), e(a, "d", 1), e(a, "ap") ? c + 12 : c, e(a, "i", 0), e(a, "s", 0))
		}
		var j = a(this),
		l = {},
		h;
		if (j.is("input")) {
			switch (j.attr("type")) {
			case "date":
				h = "yy-mm-dd";
				break;
			case "datetime":
				h = "yy-mm-ddTHH:ii:ssZ";
				break;
			case "datetime-local":
				h = "yy-mm-ddTHH:ii:ss";
				break;
			case "month":
				h = "yy-mm";
				l.dateOrder = "mmyy";
				break;
			case "time":
				h = "HH:ii:ss"
			}
			var b = j.attr("min"),
			j = j.attr("max");
			b && (l.minDate = n.parseDate(h, b));
			j && (l.maxDate = n.parseDate(h, j))
		}
		var d = a.extend({},
		z, l, A.settings),
		q = 0,
		l = [],
		C = [],
		s = {},
		f,
		t = {
			y: "getFullYear",
			m: "getMonth",
			d: "getDate",
			h: function(a) {
				a = a.getHours();
				a = v && 12 <= a ? a - 12 : a;
				return g(a, N)
			},
			i: function(a) {
				return g(a.getMinutes(), G)
			},
			s: function(a) {
				return g(a.getSeconds(), J)
			},
			ap: function(a) {
				return c && 11 < a.getHours() ? 1 : 0
			}
		},
		w = d.preset,
		B = d.dateOrder,
		u = d.timeWheels,
		o = B.match(/D/),
		c = u.match(/a/i),
		v = u.match(/h/),
		m = "datetime" == w ? d.dateFormat + d.separator + d.timeFormat: "time" == w ? d.timeFormat: d.dateFormat,
		F = new Date,
		N = d.stepHour,
		G = d.stepMinute,
		J = d.stepSecond,
		D = d.minDate || new Date(d.startYear, 0, 1),
		H = d.maxDate || new Date(d.endYear, 11, 31, 23, 59, 59);
		h = h || m;
		if (w.match(/date/i)) {
			a.each(["y", "m", "d"],
			function(a, c) {
				f = B.search(RegExp(c, "i")); - 1 < f && C.push({
					o: f,
					v: c
				})
			});
			C.sort(function(a, c) {
				return a.o > c.o ? 1 : -1
			});
			a.each(C,
			function(a, c) {
				s[c.v] = a
			});
			b = {};
			for (j = 0; 3 > j; j++) if (j == s.y) {
				q++;
				b[d.yearText] = {};
				var p = D.getFullYear(),
				P = H.getFullYear();
				for (f = p; f <= P; f++) b[d.yearText][f] = B.match(/yy/i) ? f: (f + "").substr(2, 2)
			} else if (j == s.m) {
				q++;
				b[d.monthText] = {};
				for (f = 0; 12 > f; f++) p = B.replace(/[dy]/gi, "").replace(/mm/, 9 > f ? "0" + (f + 1) : f + 1).replace(/m/, f),
				b[d.monthText][f] = p.match(/MM/) ? p.replace(/MM/, '<span class="dw-mon">' + d.monthNames[f] + "</span>") : p.replace(/M/, '<span class="dw-mon">' + d.monthNamesShort[f] + "</span>")
			} else if (j == s.d) {
				q++;
				b[d.dayText] = {};
				for (f = 1; 32 > f; f++) b[d.dayText][f] = B.match(/dd/i) && 10 > f ? "0" + f: f
			}
			l.push(b)
		}
		if (w.match(/time/i)) {
			C = [];
			a.each(["h", "i", "s"],
			function(a, c) {
				a = u.search(RegExp(c, "i")); - 1 < a && C.push({
					o: a,
					v: c
				})
			});
			C.sort(function(a, c) {
				return a.o > c.o ? 1 : -1
			});
			a.each(C,
			function(a, c) {
				s[c.v] = q + a
			});
			b = {};
			for (j = q; j < q + 3; j++) if (j == s.h) {
				q++;
				b[d.hourText] = {};
				for (f = 0; f < (v ? 12 : 24); f += N) b[d.hourText][f] = v && 0 == f ? 12 : u.match(/hh/i) && 10 > f ? "0" + f: f
			} else if (j == s.i) {
				q++;
				b[d.minuteText] = {};
				for (f = 0; 60 > f; f += G) b[d.minuteText][f] = u.match(/ii/) && 10 > f ? "0" + f: f
			} else if (j == s.s) {
				q++;
				b[d.secText] = {};
				for (f = 0; 60 > f; f += J) b[d.secText][f] = u.match(/ss/) && 10 > f ? "0" + f: f
			}
			c && (s.ap = q++, j = u.match(/A/), b[d.ampmText] = {
				"0": j ? "AM": "am",
				1 : j ? "PM": "pm"
			});
			l.push(b)
		}
		A.setDate = function(a, c, b, d) {
			for (var m in s) this.temp[s[m]] = a[t[m]] ? a[t[m]]() : t[m](a);
			this.setValue(!0, c, b, d)
		};
		A.getDate = function(a) {
			return i(a)
		};
		return {
			button3Text: d.showNow ? d.nowText: void 0,
			button3: d.showNow ?
			function() {
				A.setDate(new Date, !1, 0.3, !0)
			}: void 0,
			wheels: l,
			headerText: function() {
				return n.formatDate(m, i(A.temp), d)
			},
			formatResult: function(a) {
				return n.formatDate(h, i(a), d)
			},
			parseValue: function(a) {
				var c = new Date,
				b, m = [];
				try {
					c = n.parseDate(h, a, d)
				} catch(e) {}
				for (b in s) m[s[b]] = c[t[b]] ? c[t[b]]() : t[b](c);
				return m
			},
			validate: function(c) {
				var b = A.temp,
				m = {
					y: D.getFullYear(),
					m: 0,
					d: 1,
					h: 0,
					i: 0,
					s: 0,
					ap: 0
				},
				f = {
					y: H.getFullYear(),
					m: 11,
					d: 31,
					h: g(v ? 11 : 23, N),
					i: g(59, G),
					s: g(59, J),
					ap: 1
				},
				i = !0,
				j = !0;
				a.each("y,m,d,ap,h,i,s".split(","),
				function(v, g) {
					if (s[g] !== void 0) {
						var h = m[g],
						F = f[g],
						q = 31,
						r = e(b, g),
						p = a("ul", c).eq(s[g]),
						l,
						A;
						if (g == "d") {
							l = e(b, "y");
							A = e(b, "m");
							F = q = 32 - (new Date(l, A, 32)).getDate();
							o && a("li", p).each(function() {
								var c = a(this),
								b = c.data("val"),
								m = (new Date(l, A, b)).getDay(),
								b = B.replace(/[my]/gi, "").replace(/dd/, b < 10 ? "0" + b: b).replace(/d/, b);
								a(".dw-i", c).html(b.match(/DD/) ? b.replace(/DD/, '<span class="dw-day">' + d.dayNames[m] + "</span>") : b.replace(/D/, '<span class="dw-day">' + d.dayNamesShort[m] + "</span>"))
							})
						}
						i && D && (h = D[t[g]] ? D[t[g]]() : t[g](D));
						j && H && (F = H[t[g]] ? H[t[g]]() : t[g](H));
						if (g != "y") {
							var N = a('li[data-val="' + h + '"]', p).index(),
							n = a('li[data-val="' + F + '"]', p).index();
							a("li", p).removeClass("dw-v").slice(N, n + 1).addClass("dw-v");
							g == "d" && a("li", p).removeClass("dw-h").slice(q).addClass("dw-h")
						}
						r < h && (r = h);
						r > F && (r = F);
						i && (i = r == h);
						j && (j = r == F);
						if (d.invalid && g == "d") {
							var k = [];
							d.invalid.dates && a.each(d.invalid.dates,
							function(a, c) {
								c.getFullYear() == l && c.getMonth() == A && k.push(c.getDate() - 1)
							});
							if (d.invalid.daysOfWeek) {
								var J = (new Date(l, A, 1)).getDay(),
								u;
								a.each(d.invalid.daysOfWeek,
								function(a, c) {
									for (u = c - J; u < q; u = u + 7) u >= 0 && k.push(u)
								})
							}
							d.invalid.daysOfMonth && a.each(d.invalid.daysOfMonth,
							function(a, c) {
								c = (c + "").split("/");
								c[1] ? c[0] - 1 == A && k.push(c[1] - 1) : k.push(c[0] - 1)
							});
							a.each(k,
							function(c, b) {
								a("li", p).eq(b).removeClass("dw-v")
							})
						}
						b[s[g]] = r
					}
				})
			},
			methods: {
				getDate: function(c) {
					var b = a(this).mobiscroll("getInst");
					if (b) return b.getDate(c ? b.temp: b.values)
				},
				setDate: function(c, b, m, d) {
					void 0 == b && (b = !1);
					return this.each(function() {
						var e = a(this).mobiscroll("getInst");
						e && e.setDate(c, b, m, d)
					})
				}
			}
		}
	};
	a.each(["date", "time", "datetime"],
	function(a, e) {
		n.presets[e] = D;
		n.presetShort(e)
	});
	n.formatDate = function(l, e, g) {
		if (!e) return null;
		var g = a.extend({},
		z, g),
		i = function(a) {
			for (var b = 0; h + 1 < l.length && l.charAt(h + 1) == a;) b++,
			h++;
			return b
		},
		j = function(a, b, d) {
			b = "" + b;
			if (i(a)) for (; b.length < d;) b = "0" + b;
			return b
		},
		n = function(a, b, d, e) {
			return i(a) ? e[b] : d[b]
		},
		h,
		b = "",
		d = !1;
		for (h = 0; h < l.length; h++) if (d)"'" == l.charAt(h) && !i("'") ? d = !1 : b += l.charAt(h);
		else switch (l.charAt(h)) {
		case "d":
			b += j("d", e.getDate(), 2);
			break;
		case "D":
			b += n("D", e.getDay(), g.dayNamesShort, g.dayNames);
			break;
		case "o":
			b += j("o", (e.getTime() - (new Date(e.getFullYear(), 0, 0)).getTime()) / 864E5, 3);
			break;
		case "m":
			b += j("m", e.getMonth() + 1, 2);
			break;
		case "M":
			b += n("M", e.getMonth(), g.monthNamesShort, g.monthNames);
			break;
		case "y":
			b += i("y") ? e.getFullYear() : (10 > e.getYear() % 100 ? "0": "") + e.getYear() % 100;
			break;
		case "h":
			var q = e.getHours(),
			b = b + j("h", 12 < q ? q - 12 : 0 == q ? 12 : q, 2);
			break;
		case "H":
			b += j("H", e.getHours(), 2);
			break;
		case "i":
			b += j("i", e.getMinutes(), 2);
			break;
		case "s":
			b += j("s", e.getSeconds(), 2);
			break;
		case "a":
			b += 11 < e.getHours() ? "pm": "am";
			break;
		case "A":
			b += 11 < e.getHours() ? "PM": "AM";
			break;
		case "'":
			i("'") ? b += "'": d = !0;
			break;
		default:
			b += l.charAt(h)
		}
		return b
	};
	n.parseDate = function(l, e, g) {
		var i = new Date;
		if (!l || !e) return i;
		var e = "object" == typeof e ? e.toString() : e + "",
		j = a.extend({},
		z, g),
		n = j.shortYearCutoff,
		g = i.getFullYear(),
		h = i.getMonth() + 1,
		b = i.getDate(),
		d = -1,
		q = i.getHours(),
		i = i.getMinutes(),
		D = 0,
		s = -1,
		f = !1,
		t = function(a) { (a = o + 1 < l.length && l.charAt(o + 1) == a) && o++;
			return a
		},
		w = function(a) {
			t(a);
			a = e.substr(u).match(RegExp("^\\d{1," + ("@" == a ? 14 : "!" == a ? 20 : "y" == a ? 4 : "o" == a ? 3 : 2) + "}"));
			if (!a) return 0;
			u += a[0].length;
			return parseInt(a[0], 10)
		},
		B = function(a, b, d) {
			a = t(a) ? d: b;
			for (b = 0; b < a.length; b++) if (e.substr(u, a[b].length).toLowerCase() == a[b].toLowerCase()) return u += a[b].length,
			b + 1;
			return 0
		},
		u = 0,
		o;
		for (o = 0; o < l.length; o++) if (f)"'" == l.charAt(o) && !t("'") ? f = !1 : u++;
		else switch (l.charAt(o)) {
		case "d":
			b = w("d");
			break;
		case "D":
			B("D", j.dayNamesShort, j.dayNames);
			break;
		case "o":
			d = w("o");
			break;
		case "m":
			h = w("m");
			break;
		case "M":
			h = B("M", j.monthNamesShort, j.monthNames);
			break;
		case "y":
			g = w("y");
			break;
		case "H":
			q = w("H");
			break;
		case "h":
			q = w("h");
			break;
		case "i":
			i = w("i");
			break;
		case "s":
			D = w("s");
			break;
		case "a":
			s = B("a", ["am", "pm"], ["am", "pm"]) - 1;
			break;
		case "A":
			s = B("A", ["am", "pm"], ["am", "pm"]) - 1;
			break;
		case "'":
			t("'") ? u++:f = !0;
			break;
		default:
			u++
		}
		100 > g && (g += (new Date).getFullYear() - (new Date).getFullYear() % 100 + (g <= ("string" != typeof n ? n: (new Date).getFullYear() % 100 + parseInt(n, 10)) ? 0 : -100));
		if ( - 1 < d) {
			h = 1;
			b = d;
			do {
				j = 32 - (new Date(g, h - 1, 32)).getDate();
				if (b <= j) break;
				h++;
				b -= j
			} while ( 1 )
		}
		q = new Date(g, h - 1, b, -1 == s ? q: s && 12 > q ? q + 12 : !s && 12 == q ? 0 : q, i, D);
		if (q.getFullYear() != g || q.getMonth() + 1 != h || q.getDate() != b) throw "Invalid date";
		return q
	}
})(jQuery); (function(a) {
	a.mobiscroll.i18n.hu = a.extend(a.mobiscroll.i18n.hu, {
		dateFormat: "dd.mm.yy",
		dateOrder: "ddmmyy",
		dayNames: "Vas\u00e1rnap,H\u00e9tf\u0151,Kedd,Szerda,Cs\u00fct\u00f6rt\u00f6k,P\u00e9ntek,Szombat".split(","),
		dayNamesShort: "Vas,H\u00e9t,Ked,Sze,Cs\u00fc,P\u00e9n,Szo".split(","),
		dayText: "Nap",
		hourText: "\u00d3ra",
		minuteText: "Perc",
		monthNames: "Janu\u00e1r,Febru\u00e1r,M\u00e1rcius,\u00c1prilis,M\u00e1jus,J\u00fanius,J\u00falius,Augusztus,Szeptember,Okt\u00f3ber,November,December".split(","),
		monthNamesShort: "Jan,Feb,M\u00e1r,\u00c1pr,M\u00e1j,J\u00fan,J\u00fal,Aug,Szep,Okt,Nov,Dec".split(","),
		monthText: "H\u00f3nap",
		secText: "M\u00e1sodperc",
		timeFormat: "HH:ii",
		timeWheels: "HHii",
		yearText: "\u00c9v",
		nowText: "Most"
	})
})(jQuery); (function(a) {
	a.mobiscroll.i18n.de = a.extend(a.mobiscroll.i18n.de, {
		dateFormat: "dd.mm.yy",
		dateOrder: "ddmmyy",
		dayNames: "Sonntag,Montag,Dienstag,Mittwoch,Donnerstag,Freitag,Samstag".split(","),
		dayNamesShort: "So,Mo,Di,Mi,Do,Fr,Sa".split(","),
		dayText: "Tag",
		hourText: "Stunde",
		minuteText: "Minuten",
		monthNames: "Januar,Februar,M\u00e4rz,April,Mai,Juni,Juli,August,September,Oktober,November,Dezember".split(","),
		monthNamesShort: "Jan,Feb,M\u00e4r,Apr,Mai,Jun,Jul,Aug,Sep,Okt,Nov,Dez".split(","),
		monthText: "Monat",
		secText: "Sekunden",
		timeFormat: "HH:ii",
		timeWheels: "HHii",
		yearText: "Jahr",
		nowText: "Jetzt"
	})
})(jQuery); (function(a) {
	a.mobiscroll.i18n.es = a.extend(a.mobiscroll.i18n.es, {
		dateFormat: "dd/mm/yy",
		dateOrder: "ddmmyy",
		dayNames: "Domingo,Lunes,Martes,Mi&#xE9;rcoles,Jueves,Viernes,S&#xE1;bado".split(","),
		dayNamesShort: "Do,Lu,Ma,Mi,Ju,Vi,S&#xE1;".split(","),
		dayText: "D&#237;a",
		hourText: "Horas",
		minuteText: "Minutos",
		monthNames: "Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre".split(","),
		monthNamesShort: "Ene,Feb,Mar,Abr,May,Jun,Jul,Ago,Sep,Oct,Nov,Dic".split(","),
		monthText: "Mes",
		secText: "Segundos",
		timeFormat: "HH:ii",
		timeWheels: "HHii",
		yearText: "A&ntilde;o",
		nowText: "Ahora"
	})
})(jQuery); (function(a) {
	a.mobiscroll.i18n.fr = a.extend(a.mobiscroll.i18n.fr, {
		dateFormat: "dd/mm/yy",
		dateOrder: "ddmmyy",
		dayNames: "&#68;imanche,Lundi,Mardi,Mercredi,Jeudi,Vendredi,Samedi".split(","),
		dayNamesShort: "&#68;im.,Lun.,Mar.,Mer.,Jeu.,Ven.,Sam.".split(","),
		dayText: "Jour",
		monthText: "Mois",
		monthNames: "Janvier,F\u00e9vrier,Mars,Avril,Mai,Juin,Juillet,Ao\u00fbt,Septembre,Octobre,Novembre,D\u00e9cembre".split(","),
		monthNamesShort: "Janv.,F\u00e9vr.,Mars,Avril,Mai,Juin,Juil.,Ao\u00fbt,Sept.,Oct.,Nov.,D\u00e9c.".split(","),
		hourText: "Heures",
		minuteText: "Minutes",
		secText: "Secondes",
		timeFormat: "HH:ii",
		timeWheels: "HHii",
		yearText: "Ann\u00e9e",
		nowText: "Maintenant"
	})
})(jQuery); (function(a) {
	a.mobiscroll.i18n.it = a.extend(a.mobiscroll.i18n.it, {
		dateFormat: "dd-mm-yyyy",
		dateOrder: "ddmmyy",
		dayNames: "Domenica,Luned&Igrave;,Merted&Igrave;,Mercoled&Igrave;,Gioved&Igrave;,Venerd&Igrave;,Sabato".split(","),
		dayNamesShort: "Do,Lu,Ma,Me,Gi,Ve,Sa".split(","),
		dayText: "Giorno",
		hourText: "Ore",
		minuteText: "Minuti",
		monthNames: "Gennaio,Febbraio,Marzo,Aprile,Maggio,Giugno,Luglio,Agosto,Settembre,Ottobre,Novembre,Dicembre".split(","),
		monthNamesShort: "Gen,Feb,Mar,Apr,Mag,Giu,Lug,Ago,Set,Ott,Nov,Dic".split(","),
		monthText: "Mese",
		secText: "Secondi",
		timeFormat: "HH:ii",
		timeWheels: "HHii",
		yearText: "Anno"
	})
})(jQuery); (function(a) {
	a.mobiscroll.themes.jqm = {
		defaults: {
			jqmBody: "c",
			jqmHeader: "b",
			jqmWheel: "d",
			jqmClickPick: "c",
			jqmSet: "b",
			jqmCancel: "c"
		},
		init: function(n, l) {
			var z = l.settings;
			a(".dw", n).removeClass("dwbg").addClass("ui-overlay-shadow ui-corner-all ui-body-a");
			a(".dwb-s span", n).attr("data-role", "button").attr("data-theme", z.jqmSet);
			a(".dwb-n span", n).attr("data-role", "button").attr("data-theme", z.jqmCancel);
			a(".dwb-c span", n).attr("data-role", "button").attr("data-theme", z.jqmCancel);
			a(".dwwb", n).attr("data-role", "button").attr("data-theme", z.jqmClickPick);
			a(".dwv", n).addClass("ui-header ui-bar-" + z.jqmHeader);
			a(".dwwr", n).addClass("ui-body-" + z.jqmBody);
			a(".dwpm .dww", n).addClass("ui-body-" + z.jqmWheel);
			"inline" != z.display && a(".dw", n).addClass("pop in");
			n.trigger("create");
			a(".dwo", n).click(function() {
				l.hide()
			})
		}
	}
})(jQuery); (function(a) {
	a.mobiscroll.themes.ios = {
		defaults: {
			dateOrder: "MMdyy",
			rows: 5,
			height: 30,
			width: 55,
			headerText: !1,
			showLabel: !1
		}
	}
})(jQuery); (function(a) {
	var n = {
		defaults: {
			dateOrder: "Mddyy",
			mode: "mixed",
			rows: 5,
			width: 70,
			height: 36,
			showLabel: !1
		}
	};
	a.mobiscroll.themes["android-ics"] = n;
	a.mobiscroll.themes["android-ics light"] = n
})(jQuery); (function(a) {
	a.mobiscroll.themes.android = {
		defaults: {
			dateOrder: "Mddyy",
			mode: "clickpick",
			height: 50
		}
	}
})(jQuery); (function(a) {
	a.mobiscroll.themes.wp = {
		defaults: {
			width: 70,
			height: 76,
			dateOrder: "mmMMddDDyy"
		},
		init: function(n) {
			var l, z;
			a(".dwwl", n).bind("touchstart mousedown DOMMouseScroll mousewheel",
			function() {
				l = !0;
				z = a(this).hasClass("wpa");
				a(".dwwl", n).removeClass("wpa");
				a(this).addClass("wpa")
			}).bind("touchmove mousemove",
			function() {
				l = !1
			}).bind("touchend mouseup",
			function() {
				l && z && a(this).removeClass("wpa")
			})
		}
	};
	a.mobiscroll.themes["wp light"] = a.mobiscroll.themes.wp
})(jQuery); (function(a) {
	var n = a.mobiscroll,
	l = {
		invalid: [],
		showInput: !0,
		inputClass: ""
	},
	z = function(n) {
		function A(b, c, d, m) {
			for (var f = 0; f < c;) {
				var i = a(".dwwl" + f, b),
				g = e(m, f, d);
				a.each(g,
				function(c, b) {
					a('li[data-val="' + b + '"]', i).removeClass("dw-v")
				});
				f++
			}
		}
		function e(a, c, b) {
			for (var d = 0,
			e = []; d < c;) {
				var f = a[d],
				i;
				for (i in b) if (b[i].key == f) {
					b = b[i].children;
					break
				}
				d++
			}
			for (d = 0; d < b.length;) b[d].invalid && e.push(b[d].key),
			d++;
			return e
		}
		function g(a, b, d) {
			var e = 0,
			f, g, h = [{}],
			j = t;
			if (b) for (f = 0; f < b; f++) h[f] = {},
			h[f][w[f]] = {};
			for (; e < a.length;) {
				h[e] = {};
				f = h[e];
				for (var b = w[e], l = j, n = {},
				p = 0; p < l.length;) n[l[p].key] = l[p++].value;
				f[b] = n;
				f = 0;
				for (b = void 0; f < j.length && void 0 === b;) {
					if (j[f].key == a[e] && (void 0 !== d && e <= d || void 0 === d)) b = f;
					f++
				}
				if (void 0 !== b && j[b].children) e++,
				j = j[b].children;
				else if ((g = i(j)) && g.children) e++,
				j = g.children;
				else break
			}
			return h
		}
		function i(a, b) {
			if (!a) return ! 1;
			for (var d = 0,
			e; d < a.length;) if (! (e = a[d++]).invalid) return b ? d - 1 : e;
			return ! 1
		}
		function j(b, c) {
			a(".dwc", b).css("display", "").slice(c).hide()
		}
		function z(a, b) {
			var d = [],
			e = t,
			f = 0,
			g = !1,
			j,
			h;
			if (void 0 !== a[f] && f <= b) {
				g = 0;
				j = a[f];
				for (h = void 0; g < e.length && void 0 === h;) e[g].key == a[f] && !e[g].invalid && (h = g),
				g++
			} else h = i(e, !0),
			j = e[h].key;
			g = void 0 !== h ? e[h].children: !1;
			for (d[f] = j; g;) {
				e = e[h].children;
				f++;
				if (void 0 !== a[f] && f <= b) {
					g = 0;
					j = a[f];
					for (h = void 0; g < e.length && void 0 === h;) e[g].key == a[f] && !e[g].invalid && (h = g),
					g++
				} else h = i(e, !0),
				h = !1 === h ? void 0 : h,
				j = e[h].key;
				g = void 0 !== h && i(e[h].children) ? e[h].children: !1;
				d[f] = j
			}
			return {
				lvl: f + 1,
				nVector: d
			}
		}
		function h(b) {
			var c = [];
			s = s > f++?s: f;
			b.children("li").each(function(b) {
				var d = a(this),
				e = d.clone();
				e.children("ul,ol").remove();
				var e = e.html().replace(/^\s\s*/, "").replace(/\s\s*$/, ""),
				f = d.data("invalid") ? !0 : !1,
				b = {
					key: d.data("val") || b,
					value: e,
					invalid: f,
					children: null
				},
				d = d.children("ul,ol");
				d.length && (b.children = h(d));
				c.push(b)
			});
			f--;
			return c
		}
		var b = a.extend({},
		l, n.settings),
		d = a(this),
		q,
		C = this.id + "_dummy",
		s = 0,
		f = 0,
		t = b.wheelArray || h(d),
		w = function(a) {
			var c = [],
			d;
			for (d = 0; d < a; d++) c[d] = b.labels && b.labels[d] ? b.labels[d] : d;
			return c
		} (s),
		B = [],
		u = function(a) {
			for (var b = [], d, e = !0, f = 0; e;) if (d = i(a), b[f++] = d.key, e = d.children) a = d.children;
			return b
		} (t),
		u = g(u, s);
		a("#" + C).remove();
		b.showInput && (q = a('<input type="text" id="' + C + '" value="" class="' + b.inputClass + '" readonly />').insertBefore(d), n.settings.anchor = q, b.showOnFocus && q.focus(function() {
			n.show()
		}));
		b.wheelArray || d.hide().closest(".ui-field-contain").trigger("create");
		return {
			width: 50,
			wheels: u,
			headerText: !1,
			onBeforeShow: function() {
				var a = n.temp;
				B = n.temp.slice(0);
				n.settings.wheels = g(a, s, s)
			},
			onSelect: function(a) {
				q && q.val(a)
			},
			onChange: function(a) {
				q && b.display == "inline" && q.val(a)
			},
			onClose: function() {
				q && q.blur()
			},
			onAnimStart: function(a) {
				for (var b = n.settings,
				d = s,
				e = []; d;) e[--d] = true;
				e[a] = false;
				b.readonly = e
			},
			validate: function(a, b) {
				var d = n.temp;
				if (b !== void 0 && B[b] != d[b]) {
					n.settings.wheels = g(d, null, b);
					var e = [],
					f = b,
					h = z(d, b);
					for (n.temp = h.nVector.slice(0); f < h.lvl;) e.push(f++);
					j(a, h.lvl);
					n.changeWheel.apply(null, Array.prototype.slice.call(e, 0));
					B = n.temp.slice(0);
					A(a, h.lvl, t, n.temp)
				} else {
					h = z(d, d.length);
					A(a, h.lvl, t, d);
					j(a, h.lvl)
				}
				n.settings.readonly = false
			}
		}
	};
	a.each(["list", "image", "treelist"],
	function(a, l) {
		n.presets[l] = z;
		n.presetShort(l)
	})
})(jQuery);