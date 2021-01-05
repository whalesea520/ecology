
/*
 * My97 DatePicker Ver 4.0 Prerelease
 * SITE: http://dp.my97.net
 * BLOG: http://blog.csdn.net/my97/
 * MAIL: smallcarrot@163.com
 */
var $dp, WdatePicker;
(function () {
	var $ = {
		    $wdate:true, 
		    $dpPath:"", 
			position:{}, 
			lang:"auto", 
			skin:"default", 
			dateFmt:"yyyy-MM-dd", 
			realDateFmt:"yyyy-MM-dd", 
			realTimeFmt:"HH:mm:ss", 
			realFullFmt:"%Date %Time", 
			minDate:"1900-01-01 00:00:00", 
			maxDate:"2099-12-31 23:59:59", 
			startDate:"", 
			alwaysUseStartDate:false, 
			yearOffset:1911, 
			isShowWeek:false, 
			highLineWeekDay:true, 
			isShowClear:true, 
			isShowToday:false, 
			isShowOthers:true, 
			readOnly:false, 
			errDealMode:0,
			autoPickDate:null, 
			qsEnabled:false, 
			disabledDates:null, 
			disabledDays:null, 
			opposite:false, 
			onpicking:null, 
			onpicked:null, 
			onclearing:null, 
			oncleared:null, 
			eCont:null, 
			vel:null, 
			errMsg:"", 
			quickSel:[], 
			has:{}};
	WdatePicker = Q;
	var T = window, M = "document", G = "documentElement", A = "getElementsByTagName", R, _, P, F, Y;
	switch (navigator.appName) {
	  case "Microsoft Internet Explorer":
		P = true;
		break;
	  case "Opera":
		Y = true;
		break;
	  default:
		F = true;
		break;
	}
	R = T;
	while (R.parent[M] != R[M] && R.parent[M][A]("frameset").length == 0) {
		R = R.parent;
	}
	_ = I();
	if ($.$wdate) {
		J(_ + "skin/WdatePicker_wev8.css");
	}
	var K = (R.$dp && R.$dp.status == 3);
	if (!R.$dp || K) {
		$dp = O({ff:F, ie:P, opera:Y, el:null, win:T, status:K ? 2 : 1, defMinDate:$.minDate, defMaxDate:$.maxDate, $:function ($) {
			return (typeof $ == "string") ? this.win[M].getElementById($) : $;
		}, $D:function ($, _) {
			return this.$DV(this.$($).value, _);
		}, $DV:function (_, $) {
			if (_ != "") {
				this.dt = $dp.cal.splitDate(_, $dp.cal.dateFmt);
				if ($) {
					for (var A in $) {
						if (this.dt[A] === undefined) {
							this.errMsg = "invalid property:" + A;
						}
						this.dt[A] += $[A];
					}
				}
				if (this.dt.refresh()) {
					return this.dt;
				}
			}
			return "";
		}, show:function () {
			$dp.dd.style.display = "block";
		}, hide:function () {
			$dp.dd.style.display = "none";
		}, attachEvent:C});
		if (!K) {
			X(R, function () {
				Q(null, true);
			});
		}
	} else {
		$dp = R.$dp;
	}
	if (!T[M].docMD) {
		C(T[M], "onmousedown", B);
		T[M].docMD = true;
	}
	if (!R[M].docMD) {
		C(R[M], "onmousedown", B);
		R[M].docMD = true;
	}
	C(T, "onunload", function () {
		$dp.hide();
		R.$dp.status = 3;
	});
	function O(_) {
		R.$dp = R.$dp || {};
		for (var $ in _) {
			R.$dp[$] = _[$];
		}
		return R.$dp;
	}
	function C(A, $, _) {
		if (P) {
			A.attachEvent($, _);
		} else {
			var B = $.replace(/on/, "");
			_._ieEmuEventHandler = function ($) {
				return _($);
			};
			A.addEventListener(B, _._ieEmuEventHandler, false);
		}
	}
	function I() {
		var _, A, $ = document.getElementsByTagName("script");
		for (var B = 0; B < $.length; B++) {
			_ = $[B].src.substring(0, $[B].src.toLowerCase().indexOf("wdatepicker_wev8.js"));
			if (_) {
				break;
			}
		}
		return _;
	}
	function D(F) {
		var E, C;
		if (F.substring(0, 1) != "/" && F.indexOf("://") == -1) {
			E = R.location.href;
			C = location.href;
			if (E.indexOf("?") > -1) {
				E = E.substring(0, E.indexOf("?"));
			}
			if (C.indexOf("?") > -1) {
				C = C.substring(0, C.indexOf("?"));
			}
			var _ = "", D = "", A = "", H, G, B = "";
			for (H = 0; H < Math.max(E.length, C.length); H++) {
				if (E.charAt(H).toLowerCase() != C.charAt(H).toLowerCase()) {
					G = H;
					while (E.charAt(G) != "/") {
						if (G == 0) {
							break;
						}
						G -= 1;
					}
					_ = E.substring(G + 1, E.length);
					_ = _.substring(0, _.lastIndexOf("/"));
					D = C.substring(G + 1, C.length);
					D = D.substring(0, D.lastIndexOf("/"));
					break;
				}
			}
			if (_ != "") {
				for (H = 0; H < _.split("/").length; H++) {
					B += "../";
				}
			}
			if (D != "") {
				B += D + "/";
			}
			F = B + F;
		}
		$.$dpPath = F;
	}
	function J(C, $, D) {
		var B = T[M], E = B[A]("HEAD").item(0), _ = B.createElement("link");
		_.href = C;
		_.rel = "stylesheet";
		_.type = "text/css";
		if ($) {
			_.title = $;
		}
		if (D) {
			_.charset = D;
		}
		E.appendChild(_);
	}
	function V($, _) {
		$.onload = $.onreadystatechange = function () {
			if (this.readyState && this.readyState != "complete") {
				return;
			}
			_();
		};
	}
	function X(_, $) {
		var B = _.document, D = false;
		F();
		if ((/WebKit|KHTML|MSIE/i).test(navigator.userAgent)) {
			C();
		}
		function E(_) {
			if (!D) {
				D = true;
				A();
				$(_);
			}
		}
		function G($) {
			return typeof B[$] != "undefined";
		}
		function C() {
			if (B.body !== null && B.getElementsByTagName) {
				if (G("fileSize")) {
					try {
						B.documentElement.doScroll("left");
						E("documentready");
					}
					catch ($) {
					}
				}
				if (G("readyState") && (/loaded|complete/).test(B.readyState)) {
					E("readyState");
				}
			}
			if (!D) {
				setTimeout(C, 10);
			}
		}
		function A() {
			if (typeof B.removeEventListener == "function") {
				B.removeEventListener("DOMContentLoaded", E, false);
			}
		}
		function F() {
			if (typeof B.addEventListener == "function") {
				B.addEventListener("DOMContentLoaded", E, false);
			}
			//var $ = _.onload;
			//_.onload = function (_) {
			//	if (typeof $ == "function") {
			//		$();
			//	}
			//	E(_ || this.event);
			//};
		}
	}
	function E($) {
		$ = $ || R;
		var B = 0, _ = 0;
		while ($ != R) {
			var D = $.parent[M][A]("iframe");
			for (var F = 0; F < D.length; F++) {
				try {
					if (D[F].contentWindow == $) {
						var E = S(D[F]);
						B += E.left;
						_ += E.top;
						break;
					}
				}
				catch (C) {
				}
			}
			$ = $.parent;
		}
		return {"leftM":B, "topM":_};
	}
	function S(C) {
		if (P) {
			return C.getBoundingClientRect();
		} else {
			var E = null, _ = C.offsetTop, D = C.offsetLeft, B = C.offsetWidth, A = C.offsetHeight;
			while (C = C.offsetParent) {
				_ += C.offsetTop;
				D += C.offsetLeft;
				if (C.tagName.toLowerCase() == "body") {
					E = C.ownerDocument.defaultView;
				}
			}
			var $ = W(E);
			D -= $.left;
			_ -= $.top;
			B += D;
			A += _;
			return {"left":D, "top":_, "right":B, "bottom":A};
		}
	}
	function L($) {
		$ = $ || R;
		var _ = $[M];
		_ = _[G] && _[G].clientHeight && _[G].clientHeight <= _.body.clientHeight ? _[G] : _.body;
		return {"width":_.clientWidth, "height":_.clientHeight};
	}
	function W($) {
		$ = $ || R;
		var B = $[M], A = B[G], _ = B.body;
		B = (A && A.scrollTop != null && (A.scrollTop > _.scrollLeft || A.scrollLeft > _.scrollLeft)) ? A : _;
		return {"top":B.scrollTop, "left":B.scrollLeft};
	}
	function B(_) {
		src = _ ? (_.srcElement || _.target) : null;
		if ($dp && $dp.dd && $dp.dd.style.display == "block" && src != $dp.el) {
			var A = $dp.el, B = $dp.cal, $ = $dp.el[$dp.elProp];
			if ($ != null) {
				$dp.$w.hideSel();
				if ($ != "" && !$dp.readOnly) {
					B.date.loadFromDate(B.splitDate($, B.dateFmt));
				}
				if ($ == "" || (B.isDate(B.date) && B.isTime(B.date) && B.checkValid(B.date))) {
					B.mark(true);
					if ($ != "") {
						B.update();
					} else {
						B.setRealValue("");
					}
					$dp.hide();
				} else {
					B.mark(false);
				}
			} else {
				$dp.hide();
			}
		}
	}
	var N = [];
	function U() {
		$dp.status = 2;
		if (N.length > 0) {
			var $ = N.shift();
			$.el = {innerHTML:""};
			$.eCont = $dp.$($.eCont);
			$.autoPickDate = true;
			$.qsEnabled = false;
			H($);
		}
	}
	function Q(C, $) {
		$dp.win = T;
		C = C || {};
		if ($) {
			H({el:{innerHTML:""}}, true);
		} else {
			if (C.eCont) {
				N.push(C);
			} else {
				if ($dp.status != 2) {
					return;
				}
				var B, A = _();
				if (A) {
					B = A.srcElement || A.target;
					A.cancelBubble = true;
				}
				C.el = $dp.$(C.el || B);
				if (!C.el || C.el && C.el.disabled || (C.el == $dp.el && $dp.dd.style.display != "none" && $dp.dd.style.left != "-1970px")) {
					return;
				}
				H(C);
			}
		}
		function _() {
			if (F) {
				func = _.caller;
				while (func != null) {
					var $ = func.arguments[0];
					if ($ && ($ + "").indexOf("Event") >= 0) {
						return $;
					}
					func = func.caller;
				}
				return null;
			}
			return event;
		}
	}
	function H(G, A) {
		for (var F in $) {
			if (F.substring(0, 1) != "$") {
				$dp[F] = $[F];
			}
		}
		for (F in G) {
			if ($dp[F] === undefined) {
				$dp.errMsg = "invalid property:" + F;
			} else {
				$dp[F] = G[F];
			}
		}
		$dp.elProp = $dp.el && $dp.el.nodeName == "INPUT" ? "value" : "innerHTML";
		if ($dp.el[$dp.elProp] == null) {
			return;
		}
		if ($dp.lang == "auto") {
			$dp.lang = P ? navigator.browserLanguage.toLowerCase() : navigator.language.toLowerCase();
		}
		if (!$dp.dd || $dp.eCont || ($dp.lang && $dp.realLang && $dp.realLang.name != $dp.lang)) {
			if ($dp.dd && !$dp.eCont) {
				R[M].body.removeChild($dp.dd);
			}
			if ($.$dpPath == "") {
				D(_);
			}
			var B = "<iframe src=\"" + $.$dpPath + "My97DatePicker.jsp\" frameborder=\"0\" border=\"0\" scrolling=\"no\"></iframe>";
			if ($dp.eCont) {
				$dp.eCont.innerHTML = B;
				V($dp.eCont.childNodes[0], U);
			} else {
				$dp.dd = R[M].createElement("DIV");
				$dp.dd.style.cssText = "position:absolute;z-index:19700";
				$dp.dd.innerHTML = B;
				R[M].body.appendChild($dp.dd);
				V($dp.dd.childNodes[0], U);
				if (A) {
					$dp.dd.style.left = $dp.dd.style.top = "-1970px";
				} else {
					$dp.show();
					C();
				}
			}
		} else {
			if ($dp.cal) {
				$dp.show();
				$dp.cal.init();
				C();
			}
		}
		function C() {
			var F = $dp.position.left, B = $dp.position.top, G = S($dp.el), $ = E(T), C = L(R), A = W(R), D = $dp.dd.offsetHeight, _ = $dp.dd.offsetWidth;
			if (isNaN(B)) {
				if (B == "above" || (B != "under" && (($.topM + G.bottom + D > C.height) && ($.topM + G.top - D > 0)))) {
					B = A.top + $.topM + G.top - D - 3;
				} else {
					B = A.top + $.topM + G.bottom;
				}
				B += P ? -1 : 1;
			} else {
				B += A.top + $.topM;
			}
			if (isNaN(F)) {
				F = A.left + Math.min($.leftM + G.left, C.width - _ - 5) - (P ? 2 : 0);
			} else {
				F += A.left + $.leftM;
			}
			$dp.dd.style.top = B + "px";
			$dp.dd.style.left = F + "px";
		}
	}
})();

