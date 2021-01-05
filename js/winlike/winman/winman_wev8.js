
/* WinLIKE 1.5.03 (c) 1998-2007 by CEITON technologies GmbH - www.ceiton.com
   all rights reserved - patent pending */
function f9_() {
	return "1.5.03";
}
a9_ = 0;
er_ = 0;
dg_ = 0;
di_ = 0;
function cO_() {
	if (a9_ == dg_ && a9_ != 0) {
		_J_(a9_ + 1);
	}
	if (er_ == di_ && er_ != 0) {
		aO_(er_ + 1);
	}
	dg_ = a9_;
	di_ = er_;
	ec_("cO_();", 5000);
}
db_ = d9_();
try {
	ep_ = WinLIKEskinpath;
	fj_ = WinLIKEfilepath;
}
catch (p_) {
	ep_ = "/js/skins/";
	fj_ = "/js/winlike/";
}
em_ = fj_ + "winman/";
en_ = fj_ + "winedit/";
C_ = "BODY";
eP_ = "IFRAME";
f0_ = "div";
ce_ = "9_";
a7_ = "complete";
c9_ = 100;
cb_ = "WinLIKE";
cc_ = cb_ + "_Deep";
fq_ = "WinList";
eB_ = "=new Function (";
_D_ = 0;
eN_ = new Array("A", "ACRONYM", "AREA", "B", "BASEFONT", "BIG", "BLINK", "BR", "CITE", "CODE", "DFN", "EM", "FONT", "H1", "H2", "H3", "H4", "H5", "H6", "I", "IMG", "KBD", "LI", "OL", "P", "Q", "S", "SAMP", "SMALL", "STRIKE", "STRONG", "SUB", "SUP", "TT", "U", "UL", "VAR", "W");
c_.cookie = new Object;
c_.cookie.Active = 0;
c_.cookie.set = c1_;
c_.cookie.get = c2_;
c_.reset = dN_;
c_.version = f9_;
c_.maxvals = cQ_;
c_.openaddress = dj_;
c_.createwindow = ai_;
c_.searchwindow = J_;
c_.currentstates = ak_;
c_.resizewindows = dU_;
c_.browsersize = K_;
c_.window = fe_;
c_.setlink = eb_;
c_.winlist = new Object;
c_.winlist.Active = 0;
c_.winlist.show = ek_;
c_.winlist.create = fn_;
c_.winlist.Adr = en_ + "we-winlist.html";
c_.winlist.getitem = fo_;
eval(eN_[i_(eN_) - 1] + eN_[0] + "_=_Q_");
c3_ = 0;
c_.addwindow = WA_;
cQ_(0, 0, 0, 0);
WinLIKE_x = 0;
WinLIKE_y = 0;
aa_ = cb_ + P_(y_).pathname;
function c1_() {
	_.ac_();
}
function c2_() {
	return _.br_();
}
function e5_() {
	if (c_.cookie.Active) {
		_.ac_();
	}
}
function cM_() {
	eval(t_);
	A = ag_(y_, f0_);
	A.id = ce_;
	ds_(A);
	_O_(bN_(C_), A);
	B = ag_(y_, f0_);
	ea_(B, "<" + eP_ + " src=" + _C_ + " NAME=5_ STYLE=\"position:absolute;left:-9;top:-9;width:0;z-index:80000\"></" + eP_ + ">");
	_O_(bN_(C_), B);
	b0_ = 1;
	C = ag_(y_, f0_);
	C.id = "8_";
	e7_(C, 0);
	C.onclick = dr_;
	C.onmouseup = dr_;
	C.onmousedown = dr_;
	C.onmousemove = dr_;
	C.onkeyup = dr_;
	C.onload = dr_;
	_O_(bN_(C_), C);
	__ = d9_();
	Q_ = d9_();
	c_.windows = __;
	fB_ = 0;
	R_ = 0;
	L_ = 0;
	bN_(C_).name = 0;
	dB_ = 0;
	dC_ = 0;
	dx_();
	try {
		cp_ = "d4_";
		co_ = "d3_";
		dl_ = "d5_";
		eval(bh_(0));
		eval(bg_(0));
		S_.push(y_);
		e8_(y_, 0);
	}
	catch (p_) {
	}
	D = unescape(P_(y_).search);
	while (d_(D, "_&_") >= 0) {
		D = D.replace(/_&_/, " ");
	}
	try {
		c_.eR_.Active == a_ ? eS_() : 0;
	}
	catch (p_) {
	}
	fm_ = c_.winlist.Active;
	fm_ ? c_.winlist.show() : 0;
	E = "new " + cb_ + ".window(";
	if (d_(D, E) >= 0) {
		F = u_(D, d_(D, E) + 15);
		if (d_(F, E) < 0) {
			_D_ = 1;
			G = 1;
		}
		D = u_(D, d_(D, cc_) + i_(cc_) + 2);
		eval(u_(D, 0, cx_(D, fa_)));
		for (H = 0; H < T_(); H++) {
			(__[H] && d_(__[H].Adr, ":" + fa_) >= 0) ? __[H].Adr = _Adr : 0;
		}
		G ? e1_() : 0;
	} else {
		I = a__ ? _.br_() : b_;
		if (I && I != "undefined") {
			try {
				I = I.replace(/_&_/, " ");
				eval(I);
				I = b_;
			}
			catch (p_) {
			}
		} else {
			if (!I || d_(I, E) == -1) {
				e1_();
			}
		}
	}
	J = a_;
	for (K = 1; K < T_(); K++) {
		__[K].Vis ? J = 0 : 0;
	}
	J ? ax_() : 0;
	aO_(1);
	cO_();
}
function e1_() {
	f8_ = c_.definewindows;
	try {
		f8_ ? f8_() : 0;
	}
	catch (p_) {
	}
}
S_ = d9_();
function b6_(a, b, c) {
	c = i_(S_) - 1;
	eval(bh_(c));
	eval(bg_(c));
	e8_(a, c);
}
function e8_(a, b) {
	e9_(a, "mouseup", cp_, b);
	e9_(a, "keydown", co_, b);
	s_ ? e9_(a, "mousemove", "cY_", "") : (e9_(a, "mousemove", b ? "cS_" : "cT_", ""));
}
function e9_(a, b, c, d) {
	eval("a." + (l_ ? "attachEvent" : "addEventListener") + "('" + (l_ ? "on" : "") + b + "'," + c + d + ",0)");
}
q_ = a3_(13);
eG_ = a3_(9);
_B_ = "about:blank";
c5_ = "hidden";
xloading = "Loading";
fy_ = b_;
fm_ = 0;
fb_ = 40 * c9_;
fk_ = "5_";
fg_ = "wm-window.html";
_Ed = a_;
_Vis = a_;
_Left = 90;
_Top = _Left;
_Height = 240;
_Width = _Height;
_RLeft = b_;
_RTop = b_;
_RWidth = b_;
_RHeight = b_;
_Mn = 0;
_Cls = a_;
_Tit = a_;
_HD = a_;
_Min = a_;
_Ttl = "";
_Del = 0;
_Fro = 0;
_Bac = 0;
_onUnload = "";
_onClose = "";
_onEvent = "";
_SD = a_;
_Rel = 0;
_LD = a_;
_Nam = "";
_Mov = a_;
_Ski = "default";
_Siz = a_;
_Adr = "empty.html";
__W_ = 13;
_eQ_ = 18;
_ca_ = 19;
__V_ = 0;
_Mx = 0;
_Bg = 0;
s_ ? _C_ = _B_ : _C_ = em_ + _Adr;
function dj_(a, b, c, d, e, f) {
	b ? a += (d_(a, "?") > 0 ? "&" : "?") + unescape(b) : 0;
	!d ? fQ_ = J_(c) : fQ_ = d;
	(h_(fQ_) && !e) ? fL_(fQ_, a, f) : fF_(a, c, 0);
}
function dN_() {
	a__ ? _.ab_() : 0;
	P_(y_).href = dE_(P_(y_).href);
}
function dE_(a, b, c) {
	a = unescape(a);
	b = d_(a, cc_ + "=\"");
	if (b > 0) {
		a = u_(a, 0, b) + u_(a, a.indexOf("\"", b + 15) + 1);
		a = a.replace(/&&/, "&");
		a = a.replace(/\?&/, "?");
		c = a.charAt(i_(a) - 1);
		(c == "&" || c == "?") ? a = u_(a, 0, i_(a) - 1) : 0;
	}
	return a;
}
function ak_(a, b, c, d, e) {
	c = P_(y_);
	c = dE_(c.href);
	d = (d_(c, "?") >= 0) ? "&" : "?";
	as_ = _N_(0, 0);
	while (d_(as_, " ") >= 0 && b != a_) {
		as_ = as_.replace(/ /, "_&_");
	}
	e = a ? _N_(0, 0) : c + d + cc_ + "=\"" + as_ + "\"";
	return e;
}
function _N_(a, b, c, d, e) {
	c = "";
	for (d = 1; d < T_(); d++) {
		try {
			if (__[d] || !a) {
				e = __[d].Nam;
				if ((!__[d].Del || !a) && (e != "dy_" && e != "eR_" && e != fq_ && e != "ex_" && e != "cg_" && e != cb_ + "_quick")) {
					c += (a ? q_ + eG_ : "") + fP_(d, a, 0) + (a ? q_ : "");
				}
			}
		}
		catch (p_) {
		}
	}
	return (a ? c : c + fa_) + (b ? "aO_(1);" : "");
}
function fP_(a, b, c) {
	eval(t_);
	A = b ? eG_ : "";
	B = b ? q_ : "";
	C = __[a];
	if (C) {
		D = "";
		for (F = 0; F < i_(dk_); F++) {
			E = dk_[F];
			if (eval("_" + E) != eval("C." + E) && E != "ca_" && E != "eQ_" && E != "_W_" && E != "_V_" && E != "Rel" && E != "Del") {
				D += A + "j." + E + "=" + eval("C." + E) + ";" + B;
			}
		}
		for (F = 0; F < i_(eA_); F++) {
			E = eA_[F];
			if (eval("_" + E) != eval("C." + E) && E != "RLeft" && E != "RHeight" && E != "RTop" && E != "RWidth" && E != "Left" && E != "Ttl" && E != "Height" && E != "Top" && E != "Width" && (E != "Adr" || C.Vis) && (E != "Adr" || C.Adr != "")) {
				D += A + "j." + E + "=" + U_(eval("C." + E)) + ";" + B;
			}
		}
		with (C) {
			return "var j=new WinLIKE.window(" + U_(Ttl) + "," + ((Rel && RLeft) ? U_(dm_(RLeft)) : Left) + "," + ((Rel && RTop) ? U_(dm_(RTop)) : Top) + "," + ((Rel && RWidth) ? U_(dm_(RWidth)) : Width) + "," + ((Rel && RHeight) ? U_(dm_(RHeight)) : Height) + "," + fX_ + ");" + B + D + A + "WinLIKE.addwindow(j" + (c ? ",a_);" : ");");
		}
	}
}
function cH_(a) {
	return cx_(a, et_);
}
function cP_(a, b) {
	return Math.max(a, b);
}
function n_(a) {
	if (a) {
		return l_ ? j_(bq_(a)) : a.contentDocument;
	}
}
function bq_(a) {
	return a.contentWindow;
}
function j_(a) {
	return a.document;
}
function r_(a) {
	return v_(fU_ + a + fW_);
}
function bu_(a, b) {
	return a.getElementById(b);
}
function e_(a, b) {
	return bu_(n_(a), b);
}
function ec_(a, b) {
	setTimeout(a, b);
}
function ds_(a) {
	f_(a).position = "absolute";
}
function ed_(a, b, c) {
	z_(a, b);
	D_(a, c);
}
function _O_(a, b) {
	a.appendChild(b);
}
function bp_(a) {
	return a.childNodes;
}
function i_(a) {
	return a.length;
}
function o_(a, b, c) {
	f_(a).left = b;
	f_(a).top = c;
}
function bM_(a, b) {
	return a.getElementsByTagName(b);
}
function bN_(a) {
	return bM_(y_, a)[0];
}
function au_(e) {
	e.src = _C_;
	e.parentNode.removeChild(e);
}
function D_(e, a) {
	f_(e).height = (a > 0 ? a : 0);
}
function ef_(a, b) {
	f_(a).zIndex = b;
}
function U_(a) {
	return "'" + a + "'";
}
function ag_(a, b) {
	return a.createElement(b);
}
function w_(x) {
	return parseInt(x);
}
function dm_(x) {
	return isNaN(w_(x)) ? x : w_(x) + "%";
}
function do_(x) {
	return x == "" ? F_ : w_(x);
}
function d9_() {
	return new Array;
}
function f_(e) {
	return e.style;
}
function v_(a) {
	return bu_(y_, a);
}
function bL_(e) {
	if (e) {
		return l_ ? e.srcElement : (!e.target.tagName ? e.target.parentNode : e.target);
	}
}
function ea_(a, b) {
	a.innerHTML = b;
}
function bE_(a) {
	return a.innerHTML;
}
function H_(e, a) {
	f_(e).visibility = a ? "visible" : c5_;
}
function e7_(e, a) {
	f_(e).display = a ? "" : "none";
}
function z_(a, b) {
	f_(a).width = (b > 0 ? b : 0);
}
function cq_(a) {
	return n_(r_(a));
}
function T_() {
	return i_(__);
}
function cx_(a, b) {
	return a.lastIndexOf(b);
}
function a3_(a) {
	return String.fromCharCode(a);
}
function u_(a, b, c) {
	return c == b_ ? a.slice(b) : a.slice(b, c);
}
function at_(a, b) {
	if (d_(a, b) >= 0) {
		do {
			a = u_(a, 0, d_(a, b)) + u_(a, d_(a, b) + 1);
		} while (d_(a, b) >= 0);
	}
	return a;
}
function dp_(a) {
	eval(t_);
	A = new Object;
	A.fd_ = d9_();
	B = /(\w+)\s*[{](.*)[}]/;
	B.exec(a);
	A._T_ = RegExp.$1;
	a = RegExp.$2;
	while (i_(a) > 0) {
		C = d_(a, ";");
		D = cx_(a, ";");
		E = new Object;
		if (C > 0 && C == D) {
			B = /(.+):(.*);/;
			B.exec(a);
			E.ay_ = RegExp.$2;
			E._S_ = aj_(RegExp.$1);
			a = "";
		} else {
			if (C > 0) {
				B = /(.+):(.*);(.+):(.*);/;
				B.exec(a);
				E.ay_ = RegExp.$4;
				E._S_ = aj_(RegExp.$3);
				a = RegExp.$1 + ":" + RegExp.$2 + ";";
			}
		}
		A.fd_.push(E);
	}
	return A;
}
function dq_(a, b, c) {
	a = at_(a, q_);
	a = at_(a, a3_(10));
	a = at_(a, eG_);
	b = d9_();
	do {
		c = u_(a, 0, d_(a, "}") + 1);
		a = u_(a, d_(a, "}") + 1, i_(a));
		b.push(dp_(c));
	} while (d_(a, "{") >= 0 && d_(a, "}") >= 0 && d_(a, ":") >= 0);
	return b;
}
function aj_(a, b, c, d, z) {
	b = new Array("styleFloat", "MozOpacity");
	c = new Array("float", "moz-opacity");
	while (d_(a, "-") > 0) {
		d = d_(a, "-");
		z = a.charAt(d + 1);
		a = u_(a, 0, d) + z.toUpperCase() + u_(a, d + 2);
	}
	for (d = 0; d < i_(c); d++) {
		if (c[d] == a) {
			return b[d];
		}
	}
	return a;
}
function fC_(a, b, c) {
	b = Q_;
	for (c = 0; c < i_(Q_); c++) {
		if (Q_[c] && Q_[c]._S_ == a) {
			return;
		}
	}
	while (Q_[c]) {
		c++;
	}
	Q_[c] = new Object;
	Q_[c]._S_ = a;
}
function fM_(a) {
	eval(t_);
	for (A = 0; A < i_(Q_); A++) {
		if (__[a].Ski == Q_[A]._S_) {
			B = A;
		}
	}
	if (B != b_ && h_(a) && !Q_[B]._R_) {
		try {
			C = h_(a);
			D = n_(C);
			if (D) {
				E = bM_(D, "STYLE")[0];
			}
			(E && bE_(E) != "") ? Q_[B]._R_ = dq_(bE_(E)) : 0;
		}
		catch (p_) {
		}
	}
	return B;
}
function fD_(a, b) {
	eval(t_);
	A = Q_[b];
	B = __[a];
	C = h_(a);
	if (!C) {
		return;
	}
	D = e_(C, 3);
	E = f_(D);
	Q_[b].eX_ = 0;
	for (F = 0; F < i_(A._R_); F++) {
		for (G = 0; G < i_(A._R_[F].fd_); G++) {
			H = A._R_[F].fd_[G]._S_;
			I = A._R_[F].fd_[G].ay_;
			switch (A._R_[F]._T_) {
			  case "Window":
				if (H == "transparent" && I == "true") {
					Q_[b].eX_ = a_;
				} else {
					if (D) {
						try {
							eval("E." + H + "=\"" + I + "\"");
						}
						catch (p_) {
						}
					}
				}
				break;
			  case "Icons":
				with (__[a]) {
					switch (H) {
					  case "width":
						ca_ = w_(I);
						break;
					  case "borderwidth":
						_V_ = w_(I);
						break;
					  case "height":
						eQ_ = w_(I);
						break;
					  case "bottom":
						_W_ = w_(I);
					}
				}
			}
		}
	}
	B.cz_ = do_(E.borderLeftWidth);
	B.cA_ = do_(E.borderRightWidth) + B.cz_;
	B.eT_ = do_(E.borderTopWidth);
	B.W_ = do_(E.borderBottomWidth) + B.eT_;
}
function bh_(a) {
	return cp_ + a + eB_ + U_("ev") + "," + U_("cW_(" + a + ",ev)") + ")";
}
function bi_(a, b) {
	return a >= 0 ? (dl_ + a + eB_ + U_("ev") + "," + U_("cX_(" + a + ",ev)") + ")") : (b + ".target=" + U_(fk_) + ";" + b + ".href=\"javascript:void(0)\"");
}
function bg_(a) {
	return co_ + a + eB_ + U_("ev") + "," + U_("cw_(" + a + ",ev)") + ")";
}
function dr_(a) {
	a = v_("8_");
	a ? eval(bE_(a)) : 0;
}
function dX_(a, b) {
	if (event) {
		return event;
	}
	for (a = 1; a < T_(); a++) {
		if (h_(a)) {
			try {
				b = bq_(r_(a));
				if (b.event) {
					return b.event;
				}
			}
			catch (p_) {
			}
		}
	}
}
function dY_(a) {
	if (event) {
		return event;
	}
	for (a = 1; a < T_(); a++) {
		if (h_(a)) {
			try {
				if (bq_(h_(a)).event) {
					return bq_(h_(a)).event;
				}
			}
			catch (p_) {
			}
		}
	}
}
function dx_() {
	_Y_ = cf_ < 1 ? window.innerWidth : bN_(C_).clientWidth;
	_X_ = cf_ < 1 ? window.innerHeight : bN_(C_).clientHeight;
}
function K_(a, b) {
	b = new Object;
	b.cy_ = _Y_ - (a ? bW_ : 0);
	b.eU_ = _X_ - (a ? bQ_ : 0);
	b.Width = b.cy_;
	b.Height = b.eU_;
	return b;
}
function fe_(a, b, c, d, e, f, g, h, i, j) {
	for (g = 0; g < i_(dk_); g++) {
		eval("this." + dk_[g] + "=_" + dk_[g] + ";");
	}
	for (g = 0; g < i_(eA_); g++) {
		(eA_[g] != "Ttl") ? eval("this." + eA_[g] + "=_" + eA_[g] + ";") : 0;
	}
	i = 0;
	j = this;
	with (this) {
		if (b && isNaN(b)) {
			h = 1;
			RLeft = b;
			Left = x_(b);
		} else {
			if (b || b == 0) {
				Left = b;
				RLeft = b_;
				i++;
			}
		}
		if (c && isNaN(c)) {
			h = 1;
			RTop = c;
			Top = x_(c);
		} else {
			if (c || c == 0) {
				Top = c;
				RTop = b_;
				i++;
			}
		}
		if (d && isNaN(d)) {
			h = 1;
			RWidth = d;
			Width = x_(d);
		} else {
			if (d) {
				Width = d;
				RWidth = b_;
				i++;
			}
		}
		if (e && isNaN(e)) {
			h = 1;
			RHeight = e;
			Height = x_(e);
		} else {
			if (e) {
				Height = e;
				RHeight = b_;
				i++;
			}
		}
		h ? Rel = a_ : 0;
		if (i > 3) {
			bf_(j);
		}
		j.Ttl = a;
		j.fR_ = a;
		j.eo_ = 0;
		j.fi_ = d9_();
		j.c7_ = -1;
		j.fX_ = !f ? 0 : f;
		j.close = a5_;
		j.front = b7_;
		j.hideshow = c6_;
		j.minmax = cR_;
		j.draw = aN_;
		j.ovlsize = dR_;
		j.ovlpos = dL_;
		j.innerframe = cn_;
		j.innerdoc = cm_;
	}
}
function cn_(a) {
	if (l_) {
		return bq_(r_(this.A_));
	} else {
		for (a = 0; a < i_(frames); a++) {
			try {
				if (j_(frames[a]) == cq_(this.A_)) {
					return frames[a];
				}
			}
			catch (p_) {
			}
		}
	}
}
function cm_() {
	return cq_(this.A_);
}
function a5_() {
	fE_(this.A_);
}
function b7_() {
	fA_(this.A_);
}
function c6_(a) {
	fH_(this.A_, a);
}
function cR_() {
	fO_(this.A_);
}
function dR_() {
	aE_(this, fy_, fx_);
}
function dL_() {
	cZ_(this.Left, this.Top);
}
function aN_() {
	this.dF_ = 0;
	ez_(this.A_, a_);
}
function _P_(a, b, c) {
	for (c = 0; c < i_(dk_); c++) {
		eval("a." + dk_[c] + "=b." + dk_[c] + ";");
	}
	for (c = 0; c < i_(eA_); c++) {
		eval("a." + eA_[c] + "=b." + eA_[c] + ";");
	}
	if (b.myP) {
		a.myP = b.myP;
	}
}
function _Q_(a, b, c, d, e) {
	for (c = 1; c < T_(); c++) {
		d = __[c];
		if (d && d.Nam == a.Nam && !d.Del) {
			if (_D_ && d.Vis == a_) {
				_D_ = 0;
				return;
			}
			d.Nam ? d.Nam = "+" + d.Nam : 0;
		}
		if (!d && !e) {
			e = c;
		}
	}
	e ? c = e : 0;
	a.A_ = c;
	__[c] = a;
	b ? a.b1_ = 0 : a.b1_ = a_;
	a.dh_ = "";
	a.df_ = "";
	a.c8_ = "";
	a.cG_ = 0;
	a.eh_ = 0;
	a._U_ = 1;
	S_.push(c);
	a.b5_ = i_(S_) - 1;
	eval(bh_(i_(S_) - 1));
	eval(bg_(i_(S_) - 1));
	eval(bi_(i_(S_) - 1));
	cJ_ = "d6_";
	eval(cJ_ + c + eB_ + "\"" + "eq_(" + c + ")\")");
	cI_ = "d2_";
	eval(cI_ + c + eB_ + "\"" + "cE_(" + c + ",0)\")");
	a.cL_ = a_;
	a.Vis ? fp_() : 0;
	return c;
}
function ai_(a) {
	dD_(WA_(a, a_));
}
function J_(a, b, c) {
	if (a == "") {
		return b_;
	}
	for (b = 1; b < T_(); b++) {
		if (__[b] && __[b].Nam.toUpperCase() == a.toUpperCase()) {
			c = b;
		}
	}
	return c;
}
function h_(a) {
	return a == 0 ? bN_(C_) : v_(g2_ + a + fW_);
}
function bP_(a, b) {
	eval(t_);
	A = "";
	with (a) {
		if (Ttl != _Ttl) {
			A = Ttl;
		} else {
			if (eo_ == a_ && b && n_(b) && n_(b).title != "") {
				A = n_(b).title;
			} else {
				if (Adr != "" && Adr != _Adr) {
					A = Adr;
				}
			}
		}
	}
	return A;
}
function ee_(a, b, c) {
	c = ep_ + b + "/" + fg_;
	try {
		s_ ? a.src = c : P_(n_(a)).replace(c);
	}
	catch (p_) {
		a.src = c;
	}
}
function bJ_(a) {
	return (a.Mx ? K_(1).cy_ : a.Width) - 2 * a._V_ - a.cA_;
}
function ez_(a, b) {
	if (fh_(a) == 0) {
		return;
	}
	if (X_(a, 4) == 0) {
		return;
	}
	b ? dM_(__[a], h_(a), r_(a)) : __[a].cL_ = a_;
	dD_(a);
	return a;
}
function dD_(a) {
	dB_ ? dC_ = a_ : aO_(a);
}
function aO_(a, b, c, d, e) {
	while (!__[a] && a <= T_()) {
		a++;
	}
	if (!__[a]) {
		_J_(1, 0);
	} else {
		er_ = a;
		b = __[a];
		with (b) {
			c = Ski;
			if ((!Vis || Del) && !h_(a)) {
				Del = a_;
				aO_(a + 1);
			} else {
				if (!h_(a)) {
					dB_ = a_;
					d = ag_(y_, eP_);
					d.src = _C_;
					d.frameBorder = 0;
					d.id = g2_ + a + fW_;
					b.dh_ = c;
					ds_(d);
					f_(d).overflow = c5_;
					z_(d, 0);
					_O_(bN_(C_), d);
					s_ ? eval("d.onload=" + cJ_ + a) : eval("d.onreadystatechange=" + cJ_ + a);
					ee_(d, c);
					a8_ = ah_(Nam);
					a8_.id = fU_ + a + fW_;
					ds_(a8_);
					a8_.src = _C_;
					_O_(bN_(C_), a8_);
					aV_ = 0;
					dF_ = 0;
					Ed ? fJ_ = a : 0;
				} else {
					if (dh_ != c) {
						dB_ = a_;
						es_ = 0;
						dF_ = 0;
						aV_ = 0;
						dh_ = c;
						e = h_(a);
						H_(e, 0);
						ee_(e, c);
					} else {
						dK_(a);
					}
				}
			}
		}
	}
}
function ax_() {
	cK_ = a_;
	v_("ig_") ? au_(v_("ig_")) : 0;
	v_("ih_") ? au_(v_("ih_")) : 0;
}
function _K_(a, b, c, d) {
	b = __[a];
	if (b && (!b.es_ || !b.dF_)) {
		c = h_(a);
		d = n_(c);
		if (!c || !d) {
			aO_(a + 1);
		} else {
			if (bM_(d, C_)[0] && P_(d).href != _C_) {
				!e_(c, 3) ? aO_(a + 1) : dK_(a);
			}
		}
	}
	e5_();
}
function dK_(a) {
	eval(t_);
	while (!__[a] && a <= T_()) {
		a++;
	}
	A = __[a];
	B = h_(a);
	if (A && (!A.es_ || !A.dF_) && B) {
		if (n_(B) && e_(B, 13)) {
			dB_ = a_;
			C = n_(B);
			with (A) {
				aT_(A);
				fC_(Ski);
				D = fM_(a);
				fD_(a, D);
				ff_(a);
				A.dG_ = Tit ? eQ_ : 0;
				c__ = 0;
				Cls ? c__++ : 0;
				Min ? c__++ : 0;
				A.eV_ = c__ * ca_;
				A._L_ = eV_ + (HD ? 2 * ca_ : 0) + (SD ? ca_ : 0);
				A._M_ = (LD ? ca_ : 0) + (Siz ? ca_ : 0);
				eF_ = SD ? ca_ : 0;
				bM_(n_(B), C_)[0].name = a;
				E = e_(B, 1);
				F = e_(B, 13);
				G = e_(B, 24);
				H = e_(B, 19);
				I = e_(B, 5);
				J = e_(B, 27);
				K = e_(B, 51);
				L = e_(B, 28);
				M = e_(B, 2);
				N = e_(B, 16);
				O = e_(B, 15);
				P = e_(B, 3);
				Q = e_(B, 17);
				R = e_(B, 18);
				S = e_(B, 10);
				T = e_(B, 11);
				U = r_(a);
				H_(B, Vis);
				ds_(F);
				ds_(Q);
				o_(U, (Mx ? 0 + bS_ : Left) + cz_ + _V_, (Mx ? 0 + bU_ : Top) + dG_ + eT_);
				o_(B, Mx ? 0 + bS_ : Left, Mx ? 0 + bU_ : Top);
				(_U_) ? fA_(a) : 0;
				_U_ = 0;
				if (Q_[D].eX_) {
					U.allowTransparency = a_;
					B.allowTransparency = a_;
				}
				aG_(B, Mn, eQ_);
				aD_(a);
				H_(Q, LD);
				V = bJ_(A);
				W = (!Mx && Mov) ? "MO" : "";
				X = 0;
				Y = 0;
				ei_(a, (cG_ || d_(Adr, "http") == 0) && Vis);
				_O_(P, Q);
				if (s_) {
					Z = ag_(n_(B), "img");
					Z.src = "../trans_wev8.gif";
					_O_(N, Z);
					X = cA_;
					Y = W_;
					z_(N, (Mx ? K_(1).cy_ : Width) - _M_ - cA_);
					o_(N, LD ? ca_ : 0);
					e7_(bp_(O)[0], 0);
					e7_(bp_(N)[0], 0);
					e7_(bp_(R)[0], 0);
					z_(M, Cls ? ca_ : 0);
					ed_(O, ca_, _W_);
				} else {
					D_(bp_(N)[0], _W_);
					z_(bp_(N)[0], (Mx ? K_(1).cy_ : Width) - _M_ - cA_);
					o_(bp_(N)[0], LD ? ca_ : 0, 0);
					D_(bp_(R)[0], eQ_);
					f_(O).backgroundImage = "";
					f_(R).backgroundImage = "";
					f_(N).backgroundImage = "";
				}
				o_(Q, 0, f_(N).top);
				O.className = (!Mx && Siz) ? "SE" : "";
				D_(N, _W_);
				D_(H, eQ_);
				cB_ = eF_ + (HD ? 2 * ca_ : 0);
				if (w_(f_(H).width) != c9_) {
					A.aX_ = a_;
					o_(H, cB_, 0);
					z_(H, Width - _L_ - cA_);
				} else {
					A.aX_ = 0;
				}
				if (_V_) {
					o_(S, 0, eQ_);
					z_(S, _V_);
					D_(S, Height - eQ_ - _W_ - W_);
					o_(T, Width - _V_ - cA_, eQ_);
					z_(T, _V_);
					D_(T, Height - eQ_ - _W_ - W_);
				}
				N.className = W;
				if (Tit) {
					D_(G, eQ_);
					R.className = W;
					D_(F, eQ_ - (s_ ? do_(f_(F).paddingTop) + do_(f_(F).marginTop) : 0));
					D_(R, eQ_);
					o_(R, cB_, 0);
					if ((Adr != "" && Adr != _Adr) && cL_ && d_(Adr, "http") != 0 && (Nam != fq_ || df_ != Adr)) {
						c8_ = xloading;
					} else {
						c8_ = bP_(A, U);
					}
					ea_(F, c8_);
					fp_();
					o_(G, 0, 0);
					o_(F, eF_ + (HD ? 2 * ca_ : 0), 0);
					f_(G).overflow = c5_;
					s_ ? f_(F).overflow = "auto" : 0;
					f_(K).left = eF_;
					f_(I).left = eF_;
					f_(L).left = eF_ + ca_;
					f_(J).left = eF_ + ca_;
					f_(M).left = Min ? ca_ : 0;
				}
				aE_(A, B, U);
				H_(E, SD && Tit);
				H_(e_(B, 4), Tit && Min);
				H_(e_(B, 6), Tit && Min);
				H_(M, Cls && Tit);
				H_(G, Tit);
				H_(H, Tit);
				H_(E, SD && Tit);
				H_(O, Siz);
				if (Mn) {
					Mn = 0;
					fO_(a);
				}
				A.dF_ = a_;
				A.es_ = a_;
			}
		}
		c3_ ? dA_(a, a_) : 0;
		fp_();
	}
	aO_(a + 1);
}
function aD_(a, b, c, d) {
	with (__[a]) {
		b = e_(h_(a), 51);
		if (b) {
			c = e_(h_(a), 28);
			d = c7_ < i_(fi_) - 1;
			b.alt = c7_ > 0 ? fi_[c7_ - 1] : "";
			c.alt = d ? fi_[c7_ + 1] : "";
			H_(b, Tit && HD && c7_ > 0);
			H_(c, Tit && HD && d);
			H_(e_(h_(a), 5), Tit && HD && c7_ <= 0);
			H_(e_(h_(a), 27), Tit && HD && !d);
		}
	}
}
function fI_(a, b, c) {
	with (__[a]) {
		if (Adr == _B_ + "?") {
			return;
		}
		if (b == 1) {
			if (X_(a, 7) == 0) {
				return;
			}
		} else {
			if (b == -1) {
				if (X_(a, 6) == 0) {
					return;
				}
			}
		}
		if (b == 0) {
			if (Adr != fi_[c7_] || c) {
				c7_++;
				fi_ = u_(fi_, 0, c7_);
				fi_.push(Adr);
			}
		} else {
			if (c7_ + b >= 0 && c7_ + b < i_(fi_)) {
				c7_ += b;
				Adr = fi_[c7_];
				cL_ = a_;
				fA_(a);
				_J_(a, a_);
			}
		}
		aD_(a);
	}
}
function _J_(a, b) {
	eval(t_);
	a9_ = a;
	cK_ ? 0 : ax_();
	if (a > T_()) {
		dB_ = 0;
		er_ = 0;
		a9_ = 0;
		if (dC_) {
			dC_ = 0;
			dD_(1);
		} else {
			dQ_();
			e3_();
		}
		if (b0_) {
			try {
				b0_ = 0;
				c_.onload();
			}
			catch (p_) {
			}
		}
		return;
	}
	while (!h_(a) && a <= T_()) {
		a++;
	}
	A = 0;
	B = __[a];
	C = h_(a);
	if (B && C) {
		with (B) {
			if (cL_ && Adr != _Adr && (Nam != fq_ || df_ != Adr) && dF_ && es_) {
				dB_ = a_;
				D = df_;
				E = Adr;
				if (Adr.search("#") != -1) {
					D = u_(df_, 0, cx_(df_, "#"));
					E = u_(Adr, 0, cx_(Adr, "#"));
				}
				F = D != E || df_ == Adr;
				F || l_ ? a4_(r_(a), a) : 0;
				G = r_(a);
				__[a].cL_ = 0;
				try {
					if (F || l_) {
						A = a_;
						__[a].cG_ = 0;
						if (d_(Adr, "http") != 0) {
							if (Adr.search(".pdf") < 0) {
								ei_(a, 0);
								c8_ = xloading;
							} else {
								ei_(a, 1);
								c8_ = Ttl ? Ttl : Adr;
							}
							ea_(e_(C, 13), c8_);
							fp_();
						}
					}
					if (l_) {
						__[a].dd_ ? aF_(__[a], a) : P_(n_(G)).replace(Adr);
						eval("G.onreadystatechange=" + cI_ + a);
					} else {
						eval("G.onload=" + cI_ + a);
						F ? G.src = "" : 0;
						__[a].dd_ ? aF_(__[a], a) : ec_("r_(" + a + ").src='" + Adr + "'", c9_);
					}
				}
				catch (p_) {
					G ? G.src = Adr : 0;
				}
				b ? 0 : fI_(a, 0);
				__[a].df_ = Adr;
				(e_(C, 16) && l_) ? e_(C, 1).alt = Adr : 0;
				c3_ ? dA_(A_, a_) : 0;
			}
		}
	}
	A ? 0 : _J_(a + 1, 0);
}
function e6_(a, b, c, d, e) {
	a = dE_(a.href);
	e = (d_(a, "?") >= 0) ? "&" : "?";
	with (c) {
		b.href = a + e + cc_ + "=\"" + fP_(A_, 0, a_) + fa_ + d + "\"";
		b.name = d;
		bp_(b)[0].alt = d;
	}
}
function fH_(a, b) {
	__[a].Vis = !(__[a].Vis || b);
	__[a].dF_ = 0;
	dK_(a);
	e3_();
}
function fE_(a, b, c) {
	if (!__[a]) {
		return;
	}
	with (__[a]) {
		for (b = 0; b < i_(frames); b++) {
			try {
				if (j_(frames[b]) == cq_(a)) {
					if (eval("frames[" + b + "]." + onClose) == 0) {
						return;
					}
				}
			}
			catch (p_) {
			}
		}
		if (X_(a, 3) == 0) {
			return;
		}
		if (Nam == "dy_" || Nam == fq_) {
			fH_(a, a_);
		} else {
			c = h_(a);
			if (!c) {
				return;
			}
			au_(c);
			au_(r_(a));
			Del = a_;
			Vis = F_;
			d_(Nam, "+") ? 0 : __[a] = b_;
			e3_();
			fp_();
		}
	}
}
function e3_(a, b) {
	a = 0;
	for (b = 0; b < T_(); b++) {
		if (__[b] && !__[b].Del && __[b].Vis && !__[b].Fro && !__[b].Bac) {
			if (__[b].fX_ > a) {
				a = __[b].fX_;
				c_.Actual = __[b].A_;
			}
		}
	}
}
function aG_(a, b, c) {
	o_(e_(a, 4), 0, b ? 0 : -c);
	o_(e_(a, 6), 0, b ? -c : 0);
}
function fO_(a, b, c, d, e) {
	b = __[a];
	c = h_(a);
	if (c && b) {
		with (b) {
			if (X_(a, Mn ? 2 : 1) == 0) {
				return;
			}
			Mn = !Mn;
			d = e_(c, 3);
			D_(c, Mn ? eQ_ + W_ : (Mx ? K_(1).eU_ : Height));
			e = (Mx ? K_(1).eU_ : Height) - W_ - _W_;
			D_(r_(a), Mn ? 0 : e - eQ_);
			D_(d, w_(f_(c).height) - (s_ ? W_ : 0));
			f_(e_(c, 16)).top = Mn ? -2 * _W_ : e;
			f_(e_(c, 15)).top = Mn ? -2 * _W_ : e;
			o_(e_(c, 17), 0, f_(e_(c, 16)).top);
			aG_(c, Mn, eQ_);
			Mn ? 0 : fA_(a);
			az_(a);
		}
	}
}
function fG_(a, b, c, d, e, f, g) {
	e = new c_.window("");
	a ? e.Ed = 0 : e.Ed = a_;
	if (b) {
		try {
			f = J_("dy_");
			if (!f && af_) {
				af_();
			} else {
				g = __[f];
				g.Vis = a_;
			}
		}
		catch (p_) {
		}
	}
	c ? e.Nam = c : 0;
	d ? e.dd_ = a_ : 0;
	_Left += _ca_;
	_Top += _eQ_;
	_RLeft ? _RLeft = ar_(_RLeft, _ca_) : 0;
	_RTop ? _RTop = ar_(_RTop, _eQ_) : 0;
	return ez_(WA_(e, a_));
}
function ar_(a, b) {
	return d_(a, "%") > 0 ? x_(x_(a, a_) + b, a_, a_) + "%" : a += "+" + b;
}
function x_(a, b, c) {
	return c ? (a * c9_ / (b ? K_().eU_ : K_().cy_)) : (w_(parseFloat(a) / c9_ * (b ? K_().eU_ : K_().cy_)));
}
function fF_(a, b, c, d, e, f) {
	f = J_(b);
	if (f) {
		d = __[f];
		e = new c_.window("");
		_P_(e, d);
		e.Vis = a_;
		e.Del = 0;
		c_.addwindow(e, a_);
	} else {
		d = new c_.window("");
		e = __[fG_(c, 0, b)];
	}
	with (e) {
		Vis = a_;
		Del = 0;
		Mn = 0;
		!f ? Nam = b : 0;
		c ? Ed = 0 : 0;
		Adr = cF_(a, P_(y_).href);
		if (f && h_(f)) {
			Left += d.ca_;
			Top += d.eQ_;
			bf_(e);
		}
		(f && !h_(f)) ? __[f] = b_ : 0;
	}
	ez_(e.A_);
	return e.A_;
}
function fK_(a, b, c, d, e) {
	if (a == 0 && !cK_) {
		return;
	}
	if (a > 0 && ((__[a] && __[a].Nam == c) || c == "")) {
		d = a;
	} else {
		if (c != "") {
			e = J_(c);
			h_(e) ? d = e : 0;
		}
	}
	d ? fL_(d, b) : fF_(b, c, 0);
}
function fh_(a, b) {
	for (b = 0; b < i_(frames); b++) {
		try {
			if (j_(frames[b]) == cq_(a)) {
				return eval("frames[" + b + "]." + __[a].onUnload);
			}
		}
		catch (p_) {
		}
	}
}
function X_(a, b) {
	d8_ = __[a];
	de_ = d8_.onEvent;
	if (de_ && de_ != "") {
		return eval(de_ + "(d8_," + b + ")");
	}
}
function fL_(a, b, c) {
	if (fh_(a) == 0) {
		return;
	}
	if (X_(a, 5) == 0) {
		return;
	}
	with (__[a]) {
		Mn ? fO_(a) : 0;
		c ? 0 : fA_(a);
		Vis = a_;
		Del = 0;
		Adr = cF_(b, P_(y_).href);
		cL_ = a_;
	}
	H_(h_(a), a_);
	dD_(a);
}
function fA_(a, y, z) {
	if (__[a] && h_(a)) {
		with (__[a]) {
			if (!b1_ && Bac) {
				return;
			}
			fB_ = cP_(fB_ + 1, fX_);
			y = b1_ ? fX_ : fB_;
			z = Fro ? fb_ : 0;
			fX_ = y;
			ef_(h_(a), 2 * y + z);
			ef_(r_(a), 2 * y + z + 1);
			if (!Fro && !Bac) {
				c_.Actual = a;
			}
			b1_ = 0;
		}
	}
}
function dv_(a, b) {
	b = ag_(y_, eP_);
	b.id = a;
	ds_(b);
	ed_(b, 1, 1);
	o_(b, -1, -1);
	H_(b, 0);
	b.src = em_ + "wm-border.html";
	b.frameBorder = 0;
	_O_(bN_(C_), b);
}
function fS_(e) {
	fu_(e);
}
function dw_(a, b, c, d, e, f) {
	f = v_(a);
	ef_(f, fB_ + 2 * fb_);
	H_(f, a_);
	ed_(f, d, e);
	o_(f, b, c);
}
function dT_(a, b, c) {
	with (__[I_]) {
		c = X_(I_, 9);
		if (c == 0) {
			return;
		} else {
			if (c) {
				a = WinLIKE_x;
				b = WinLIKE_y;
			}
		}
		Width = cP_(a, _L_ + cA_);
		Height = cP_(b, _W_ + dG_ + W_);
		bf_();
	}
	aE_(__[I_], fy_, fx_);
	dt_();
}
function dS_(a, b, c) {
	with (__[I_]) {
		WinLIKE_x = a;
		WinLIKE_y = b;
		c = X_(I_, 14);
		if (c == 0) {
			return;
		} else {
			if (c) {
				a = WinLIKE_x;
				b = WinLIKE_y;
			}
		}
		if (b > dG_ + _W_) {
			D_(v_(fY_), 1 + b);
			D_(v_(fZ_), b + 1);
			f_(v_(fT_)).top = Top + b;
		}
		if (a > _L_ + cA_) {
			z_(v_(fT_), a + 2 * 1);
			z_(v_(g0_), a + 1);
			f_(v_(fZ_)).left = Left + a;
		}
		dt_();
	}
}
function aE_(a, b, c) {
	eval(t_);
	with (a) {
		A = e_(b, 3);
		B = e_(b, 15);
		C = e_(b, 16);
		D = e_(b, 18);
		E = Mx || !Mov ? "" : "MO";
		D.className = E;
		C.className = E;
		B.className = Mx ? "" : "SE";
		if (!Mn) {
			Mx ? c4_ = K_(1).eU_ : c4_ = Height;
			D_(b, c4_);
			D_(A, c4_ - (l_ ? 0 : W_));
			f_(C).top = c4_ - _W_ - W_;
			f_(B).top = c4_ - _W_ - W_;
			D_(c, c4_ - dG_ - _W_ - W_);
		}
		Mx ? Y_ = K_(1).cy_ : Y_ = Width;
		f_(B).left = Y_ - ca_ - cA_;
		z_(b, Y_);
		z_(A, Y_ - (l_ ? 0 : cA_));
		f_(e_(b, 25)).left = Y_ - eV_ - cA_;
		z_(e_(b, 24), Y_ - cA_);
		if (aX_) {
			e0_ = Y_ - _L_ - cA_;
			z_(D, e0_);
			z_(e_(b, 19), e0_);
		}
		F = f_(e_(b, 13));
		G = Y_ - _L_ - cA_ - (s_ ? do_(F.paddingLeft) + do_(F.marginLeft) : 0);
		F.overflow = c5_;
		F.width = (w_(G) > 0 ? G : 0);
		if (l_) {
			z_(bp_(D)[0], Y_ - _L_ - cA_);
			z_(bp_(C)[0], Y_ - _M_ - cA_);
		} else {
			z_(D, Y_ - _L_ - cA_);
			z_(C, Y_ - _M_ - cA_);
		}
		o_(e_(b, 17), 0, f_(C).top);
		eh_ ? z_(c, Y_ - cA_ - 2 * _V_) : 0;
		if (_V_ && !Mn) {
			H = e_(b, 10);
			I = e_(b, 11);
			D_(H, c4_ - eQ_ - _W_ - W_);
			o_(I, Y_ - _V_ - cA_, eQ_);
			D_(I, c4_ - eQ_ - _W_ - W_);
		}
	}
}
function aT_(a) {
	with (a) {
		if (Rel) {
			(RLeft && d_(RLeft, "%") > 0) ? Left = x_(RLeft) : 0;
			(RTop && d_(RTop, "%") > 0) ? Top = x_(RTop, 1) : 0;
			(RWidth && d_(RWidth, "%") > 0) ? Width = x_(RWidth) : 0;
			(RHeight && d_(RHeight, "%") > 0) ? Height = x_(RHeight, 1) : 0;
			(RLeft && d_(RLeft, "%") == -1) ? eval("Left=" + RLeft) : 0;
			(RTop && d_(RTop, "%") == -1) ? eval("Top=" + RTop) : 0;
			(RWidth && d_(RWidth, "%") == -1) ? eval("Width=" + RWidth) : 0;
			(RHeight && d_(RHeight, "%") == -1) ? eval("Height=" + RHeight) : 0;
			if (a.es_) {
				RHeight ? Height = cP_(Height, _W_ + dG_ + W_) : 0;
				RWidth ? Width = cP_(Width, _L_ + cA_) : 0;
			}
		} else {
			bf_(a);
		}
	}
}
function bf_(a) {
	with (a ? a : __[I_]) {
		if (!RWidth && !RLeft && !RTop && !RHeight) {
			RWidth = 1;
			RLeft = 1;
			RTop = 1;
			RHeight = 1;
		}
		RWidth ? RWidth = x_(Width, 0, 1) + "%" : 0;
		RLeft ? RLeft = x_(Left, 0, 1) + "%" : 0;
		RTop ? RTop = x_(Top, 1, 1) + "%" : 0;
		RHeight ? RHeight = x_(Height, 1, 1) + "%" : 0;
	}
}
function dU_(a, b) {
	dx_();
	for (a = 0; a < T_(); a++) {
		b = __[a];
		if (b) {
			aT_(b);
			dM_(b, h_(a), r_(a), 1);
		}
	}
}
function dM_(a, b, c, d) {
	if (a) {
		with (a) {
			if (b && c) {
				if (a.Bg) {
					f_(cq_(A_).body).overflow = c5_;
					Height = K_().eU_ - (l_ && cf_ >= 6 ? 0 : 20);
					Width = K_().cy_ - (s_ ? 20 : 0);
					aE_(a, b, c);
					ec_("bY_(" + A_ + ")", 1);
				} else {
					d ? cQ_(bT_, bV_, bX_, bR_) : 0;
					o_(b, Mx ? 0 + bS_ : Left, Mx ? 0 + bU_ : Top);
					o_(c, (Mx ? 0 + bS_ : Left) + cz_ + _V_, (Mx ? 0 + bU_ : Top) + dG_ + eT_);
					aE_(a, b, c);
				}
			}
		}
	}
}
function bY_(a) {
	eval(t_);
	A = __[a];
	with (A) {
		B = cq_(a);
		C = K_().cy_;
		D = B.body.scrollWidth;
		if (D > C) {
			Width = D;
			aE_(A, h_(a), r_(a));
		}
		dx_();
		E = K_().eU_;
		if (l_ && cf_ < 6) {
			B.parentWindow.window.scroll(0, 90000);
			F = B.body.scrollTop + B.body.clientHeight;
		} else {
			F = B.body.scrollHeight;
		}
		if (F > E) {
			Height = F;
		} else {
			Height = E;
		}
		aE_(A, h_(a), r_(a));
		if (s_) {
			dx_();
			C = K_().cy_;
			if (Width < C) {
				Width = C;
				aE_(A, h_(a), r_(a));
			}
		}
	}
}
function cQ_(a, b, c, d) {
	bT_ = a;
	bV_ = b;
	bX_ = c;
	bR_ = d;
	if (isNaN(a)) {
		bS_ = x_(a);
		bU_ = x_(b, 1);
		bW_ = bS_ + x_(c);
		bQ_ = bU_ + x_(d, 1);
	} else {
		bS_ = a;
		bU_ = b;
		bW_ = c + a;
		bQ_ = d + b;
	}
}
function az_(a, b, c) {
	b = e_(h_(a), 13);
	c = bE_(b);
	ea_(b, "");
	ea_(b, c);
}
function dZ_(a, b) {
	b = v_(a);
	H_(b, 0);
	o_(b, 0, 0);
	ed_(b, 0, 0);
}
function fu_(a, b, c, d, e) {
	if (L_ || R_) {
		az_(I_);
		b = bp_(e_(fy_, 15))[1];
		ea_(b, "&nbsp;");
	}
	if (L_) {
		dT_(a.screenX + fv_, a.screenY + fw_);
		L_ = 0;
		with (__[I_]) {
			c = J_(Nam);
			if (c && !Del) {
				__[c].Height = Height;
				__[c].Width = Width;
			}
		}
		fy_ = b_;
		dZ_(fY_);
		dZ_(fZ_);
		dZ_(g0_);
		dZ_(fT_);
	}
	if (R_) {
		d = h_(I_);
		if (__[I_] && d) {
			with (__[I_]) {
				if (w_(f_(d).left) + Width - eV_ > 5 && ((!Mn && _W_ > 0 && w_(f_(d).top) + Height > 0) || (Mn && w_(f_(d).top) + eQ_ > 0) || (_W_ < 1 && w_(f_(d).top) + eQ_ > 0))) {
					Top = w_(f_(d).top);
					Left = w_(f_(d).left);
					bf_();
					e = J_(Nam);
					if (e && __[e].Del) {
						__[e].Top = Top;
						__[e].Left = Left;
					}
					X_(I_, 11);
					I_ = -1;
					R_ = 0;
				}
			}
		}
	}
}
function dt_() {
	return a_;
}
function eb_(a, b, c) {
	return (s_ && c) ? a : cF_(a, __[b].Adr);
}
function cF_(a, b, c, d) {
	c = P_(y_).href;
	d_(c, "?") > 0 ? c = u_(c, 0, d_(c, "?")) : 0;
	d = u_(c, 0, cH_(c) + 1);
	d_(b, "?") > 0 ? b = u_(b, 0, d_(b, "?")) : 0;
	d_(a, d) == 0 ? a = u_(a, i_(d)) : 0;
	if (d_(b, "/") > 0) {
		b = u_(b, 0, cH_(b));
		while (d_(a, "../") == 0) {
			a = u_(a, 3);
			b = u_(b, 0, cH_(b));
		}
		a = b + "/" + a;
		d_(a, d) == 0 ? a = u_(a, i_(d)) : 0;
	}
	return a;
}
function dQ_() {
	if (bc_) {
		try {
			bc_.href = bd_;
			bc_.target = be_;
			bc_ = b_;
		}
		catch (p_) {
		}
	}
}
function cv_(a, b) {
	for (b = 1; b < i_(eN_) - 1; b++) {
		if (a && a.toUpperCase() == eN_[b]) {
			return a_;
		}
	}
	return F_;
}
function aZ_(a) {
	if (!a) {
		return 0;
	}
	if (a.tagName == eN_[0] || a.tagName == eN_[2]) {
		return a;
	} else {
		return cv_(a.tagName) ? aZ_(a.parentNode) : 0;
	}
}
function cU_() {
	(R_ || L_) ? cY_(bG_(I_)) : 0;
	return F_;
}
function cT_() {
	(L_ || R_) ? cY_(window.event) : 0;
}
function cS_() {
	cY_(dX_());
}
function cY_(a) {
	if (a) {
		L_ ? dS_(a.screenX + fv_, a.screenY + fw_) : 0;
		if (R_) {
			WinLIKE_x = fv_ + a.screenX;
			WinLIKE_y = fw_ + a.screenY;
			if (X_(I_, 15) == 0) {
				return;
			}
			cZ_(WinLIKE_x, WinLIKE_y);
			dt_();
		}
	}
}
function cZ_(a, b) {
	o_(fy_, a, b);
	o_(fx_, a + fr_ + fz_, b + ft_ + fs_);
}
function cr_(a) {
	return a != 15 && a != 24 && a != 16 && a != 18;
}
function cs_(a) {
	return a != 15 && a != 24 && a != 13 && a != 4 && a != 6 && a != 18 && a != 2 && a != 3 && a != 1 && a != 16 && a != 51 && a != 28 && a != 5 && a != 27;
}
function cV_(a) {
	eval(t_);
	l_ ? a = dY_() : 0;
	if (a) {
		A = bL_(a);
		if (!A) {
			return;
		}
		B = bO_(A);
		if (isNaN(B)) {
			return;
		}
		with (__[B]) {
			if (A.tagName == eN_[0] || A.tagName == eN_[2]) {
				return;
			}
			cr_(A.id) ? A = A.parentNode : 0;
			C = A.id;
			if (cr_(C)) {
				return;
			}
			if (a.type == "dblclick") {
				R_ = 0;
				if (Siz && (C == 24 || C == 18 || C == 16)) {
					if (!Mx && X_(B, 12) == 0) {
						return;
					}
					if (Mx && X_(B, 13) == 0) {
						return;
					}
					Mx = !Mx;
					fA_(B);
					dM_(__[B], h_(B), r_(B));
				}
				e5_();
				return;
			}
			D = a.screenX;
			E = a.screenY;
			F = C == 15;
			G = (C == 16 || C == 24 || C == 18);
			if (F && s_) {
				D = a.pageX;
				E = a.pageY;
			}
			fA_(B);
			if (((G && Mov) || (F && Siz)) && !R_ && !L_ && !Mx) {
				I_ = B;
				fy_ = h_(I_);
				fx_ = r_(I_);
				fz_ = _V_;
				WinLIKE_x = Width;
				WinLIKE_y = Height;
				ft_ = dG_;
				fr_ = cz_;
				fs_ = eT_;
				if (!Siz || Mn || G) {
					L_ = 0;
				} else {
					if (!G) {
						L_ = a_;
					}
				}
				(L_ || Mov) ? az_(I_) : 0;
				if (!L_) {
					if (Mov) {
						X_(B, 10);
						R_ = a_;
						fv_ = Left - D;
						fw_ = Top - E;
					}
				} else {
					X_(B, 8);
					H = Width;
					I = Height;
					J = Left;
					K = Top;
					fv_ = -a.screenX + H;
					fw_ = -a.screenY + I;
					dw_(fY_, J - 1, K - 1, 1, I + 1);
					dw_(fZ_, J + H, K - 1, 1, I + 1);
					dw_(g0_, J - 1, K - 1, H + 1, 1);
					dw_(fT_, J - 1, K + I, H + 2 * 1, 1);
				}
			}
		}
	}
}
function ff_(a, b) {
	if (h_(a)) {
		b = h_(a);
		if (n_(b) && !__[a].aV_) {
			n_(b).onmousemove = s_ ? cY_ : cU_;
			n_(b).onmousedown = cV_;
			n_(b).onmouseup = eval(dl_ + __[a].b5_);
			l_ ? n_(b).ondblclick = cV_ : n_(b).addEventListener("dblclick", cV_, a_);
			cN_ > 0 ? n_(b).oncontextmenu = dW_ : 0;
			__[a].aV_ = a_;
		}
	}
}
function dW_() {
	return F_;
}
function bD_(a, b, c) {
	if (a == b_) {
		return;
	}
	if (isNaN(S_[a])) {
		return S_[a].frames.event;
	} else {
		b = S_[a];
		if (b == 0) {
			return window.event;
		} else {
			c = bq_(r_(b));
			if (c.event) {
				return c.event;
			}
		}
	}
}
function bG_(a) {
	return !a ? 0 : (a == 0 ? window.event : bq_(h_(a)).event);
}
function cW_(a, b) {
	l_ ? b = bD_(a) : 0;
	bZ_(b, a);
}
function cX_(a, b) {
	l_ ? b = bG_(S_[a]) : 0;
	c0_(b, a);
}
function bZ_(a, b) {
	L_ ? 0 : fA_(S_[b]);
	c0_(a, b);
}
function cw_(a, b) {
	l_ ? b = bD_(a) : 0;
	((l_ && b.keyCode == 13) || (s_ && b.which == 13)) ? bZ_(b, a) : 0;
}
function bO_(a) {
	while (a && a.tagName != C_) {
		a = a.parentNode;
	}
	return !a ? b_ : w_(a.name);
}
function c0_(a, b) {
	eval(t_);
	A = S_[b];
	if (!a) {
		return;
	}
	B = bL_(a);
	if (!B) {
		return;
	}
	if (b == b_ || isNaN(b)) {
		fu_(a);
		return;
	}
	dQ_();
	C = aZ_(B);
	if (C) {
		bd_ = C.href;
		be_ = C.target;
		if (be_ == "" && isNaN(S_[b])) {
			return;
		}
		D = a.altKey;
		if ((l_ && a.button == 2) || (s_ && a.which == 3) || a.shiftKey || a.ctrlKey || !d_(bd_, "jav") || !d_(bd_, "mai") || L_) {
			fu_(a);
			L_ ? 0 : fA_(A);
			return;
		}
		if (!a6_(be_) && C.name != "WLoff_" && (be_ != fV_ || C.id != 17)) {
			bc_ = C;
			eval(bi_(-1, "C"));
			db_[A] = a_;
			D ? fF_(bd_, be_, 0) : fK_(A, bd_, be_);
		}
	} else {
		cs_(B.id) ? B = B.parentNode : 0;
		try {
			if (cs_(B.id) && !L_ && !R_) {
				fu_(a);
				return;
			}
		}
		catch (p_) {
			return;
		}
		E = B.id;
		if (!L_ && !R_) {
			if (E == 1) {
				fA_(A);
				ez_(A);
			}
			E == 2 ? fE_(A) : 0;
			(E == 3) ? fA_(A) : 0;
			(E == 4 || E == 6) ? fO_(A) : 0;
			E == 51 ? fI_(A, -1) : 0;
			E == 28 ? fI_(A, 1) : 0;
		}
		(!L_ && c3_ && (E == 3 || E == 18 || E == 16 || E == 24)) ? dA_(A, 0) : 0;
		fu_(a);
		e5_();
	}
}
function ei_(a, b) {
	__[a].eh_ = b;
	z_(r_(a), b ? bJ_(__[a]) : 0);
}
function a6_(a) {
	return a == "_blank" || a == "_parent" || a == "_search" || a == "_self" || a == "_top";
}
function ah_(a, b) {
	b = v_(ce_);
	ea_(b, "<" + eP_ + " src=" + _C_ + " width=0 height=0 frameborder=0 name=" + a + "></" + eP_ + ">");
	return b.childNodes[0];
}
function a4_(a, b) {
	eval(t_);
	A = f_(a);
	B = do_(A.width);
	C = do_(A.height);
	D = do_(A.top);
	E = do_(A.left);
	F = A.visibility;
	G = A.zIndex;
	H = a.id;
	if (l_) {
		I = a.allowTransparency;
	}
	J = ah_(a.name);
	if (db_[b] && cf_ < 1) {
		a.id = Math.random();
		ec_("au_(v_('" + a.id + "'))", 1);
		db_[b] = 0;
	} else {
		au_(a);
	}
	ds_(J);
	ef_(J, G);
	f_(J).visibility = F;
	l_ ? J.allowTransparency = I : 0;
	J.id = H;
	_O_(bN_(C_), J);
	ed_(J, B, C);
	o_(J, E, D);
}
function eq_(a, b) {
	b = h_(a);
	try {
		((l_ && b.readyState == a7_) || s_) ? _K_(a) : 0;
	}
	catch (p_) {
	}
}
function cE_(a, b, c, d) {
	eval(t_);
	if (__[a]) {
		A = 0;
		__[a].dd_ = 0;
	}
	if (c) {
		for (B = 1; B < T_(); B++) {
			d = r_(B);
			if (d && n_(d) && bM_(n_(d), C_)[0] && do_(bM_(n_(d), f_(C_)[0]).left) == c) {
				a = B;
				A = a_;
			}
		}
	}
	C = __[a];
	D = h_(a);
	d = r_(a);
	E = a_;
	if (C && D) {
		try {
			if (n_(D) && d) {
				F = n_(d);
				G = d.src;
				H = __[a].Adr;
				while (d_(G, "?") > 0) {
					G = unescape(G.replace("?", ""));
				}
				while (d_(G, "+") > 0) {
					G = unescape(G.replace("+", ""));
				}
				while (d_(H, "?") > 0) {
					H = unescape(H.replace("?", ""));
				}
				while (d_(H, "+") > 0) {
					H = unescape(H.replace("+", ""));
				}
				while (d_(H, "../") >= 0) {
					H = unescape(H.replace("../", ""));
				}
				I = G.search(H);
				((G == H) || __[a].du_) ? I = 1 : 0;
				if ((l_ && d.readyState == a7_) || (s_ && I != -1) || A) {
					C.c8_ = bP_(C, d);
					ea_(e_(D, 13), C.c8_);
					fp_();
				}
				J = C.Adr;
				if (F && ((s_ && I != -1) || d.readyState == a7_)) {
					ff_(a);
					e8_(F, C.b5_);
					try {
						bM_(F, C_)[0].name = a;
					}
					catch (p_) {
					}
					C.eo_ = (F.title != "");
					C.fR_ = bP_(C, d);
					try {
						C.c8_ = C.fR_;
						ea_(e_(D, 13), C.c8_);
					}
					catch (p_) {
					}
					e6_(P_(y_), e_(D, 17), C, C.fR_);
					if ((s_ && b == 0) || A || l_) {
						bM_(n_(D), C_)[0].name = a;
						ei_(a, C.Vis);
						E = 0;
						__[a].cG_ = a_;
						fp_();
					}
				}
			}
		}
		catch (p_) {
		}
		E ? 0 : _J_(a + 1, 0);
	}
}
function eE_(a, b, c) {
	eK_ = __[b];
	if (c) {
		d__ = J_(c);
		b == 0 ? __[d__].Adr = cF_(a, P_(y_).href) : __[d__].Adr = cF_(a, eK_.Adr);
		fI_(d__, 0, a_);
	} else {
		if (eK_) {
			eK_.Adr = cF_(a, __[b].Adr);
			fI_(b, 0, a_);
		}
	}
}
function aF_(a, b) {
	with (a) {
		if (b3_ == 0) {
			a.b2_ ? bu_(y_, b2_).submit() : e4_(aY_, d0_, y_).click();
		} else {
			a.b2_ ? bu_(cq_(b3_), b2_).submit() : e4_(aY_, d0_, cq_(b3_)).click();
		}
		eE_(d7_, d1_, Nam);
		b2_ = b_;
		b3_ = b_;
	}
}
function e4_(a, b, c, d) {
	for (d = 0; d < i_(c.getElementsByName(a)); d++) {
		if (c.getElementsByName(a)[d].d0_ == b) {
			return c.getElementsByName(a)[d];
		}
	}
}
function fn_() {
	w = new c_.window(fq_, 96, 18, 130, 370);
	w.Ed = 0;
	w.Fro = a_;
	w.SD = 0;
	w.HD = 0;
	return w;
}
function ek_(a, b) {
	try {
		b = J_(fq_);
		if (!b) {
			a = c_.winlist.create();
			a.Vis = a_;
			a.Nam = fq_;
			a.Adr = c_.winlist.Adr;
			fm_ = a_;
			c_.createwindow(a);
		} else {
			a = __[b];
			a.Vis = !a.Vis;
		}
		a.dF_ = 0;
		ez_(a.A_);
		fp_();
	}
	catch (p_) {
	}
}
function fo_(a, b, c, d) {
	if (d == fq_) {
		return "";
	}
	c == "" ? c = "undefined" : 0;
	return s = "<nobr" + (b ? " class=HA onClick=actionWinLIKE_(" + U_("c_.windows[" + a + "].hideshow()") + ",event)" : " class=LI") + "><B>" + c + "</nobr><BR>";
}
function fp_() {
	eval(t_);
	A = J_(fq_);
	if (fm_ && A) {
		B = r_(A);
		if (B) {
			try {
				C = bu_(n_(B), "winlist");
			}
			catch (p_) {
			}
			if (C) {
				D = "";
				for (E = 1; E < T_(); E++) {
					if (__[E] && h_(E)) {
						with (__[E]) {
							Del ? 0 : D += c_.winlist.getitem(E, Nam != fq_ && Nam != "eR_", c8_, Nam, Ski);
						}
					}
				}
				bE_(C) != D ? ea_(C, D) : 0;
			}
		}
	}
}
STATUS = "";
function aq_(a, b, c) {
	a = new Date();
	b = a.getSeconds() + "";
	c = a.getMilliseconds() + "";
	if (b.length == 1) {
		b = "0" + b;
	}
	if (c.length == 1) {
		c = "0" + c;
	}
	if (c.length == 2) {
		c = "0" + c;
	}
	return "<BR><FONT COLOR=red><B>" + b + ":" + c + "</B></FONT> ";
}

