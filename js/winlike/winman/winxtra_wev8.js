
/* WinLIKE 1.5.03 (c) 1998-2007 by CEITON technologies GmbH - www.ceiton.com
   all rights reserved - patent pending */
b_ = null;
a_ = true;
F_ = false;

function recognizeWinLIKE_(a, b, c, d) {
	try {
		if (b && b.parent && b.parent.c_) {
			return b.parent;
		}
	}
	catch (p_) {
	}
	if (a.c_) {
		return a;
	} else {
		try {
			for (c = 0; c < a.frames.length; c++) {
				d = recognizeWinLIKE_(a.frames[c]);
				if (a.frames[c] && d) {
					return d;
				}
			}
		}
		catch (p_) {
		}
	}
}
function getWindowNumber_() {
	if (recognizeWinLIKE_(top, self).cf_ >= 1.1) {
		return parseInt(frameElement.id.slice(1));
	} else {
		return document.getElementsByTagName("BODY")[0].name;
	}
}
function actionWinLIKE_(a, event, b, c) {
	b = recognizeWinLIKE_(top, self);
	if (b) {
		c = b.document.getElementById("8_");
		if (c) {
			c.innerHTML = a;
			c.fireEvent ? c.fireEvent("onclick") : c.onclick();
		}
	}
}
function registerWinLIKE_(a, b, c) {
	b = recognizeWinLIKE_(top, self);
	if (a) {
		b.S_.push(a);
		b.b6_(a.document, a);
	} else {
		if (b.cf_ < 1.1) {
			c = g1_();
			document.getElementsByTagName(b.C_)[0].style.left = c;
			b.cE_(b_, a_, c);
		}
	}
}
function formfocusWinLIKE_(a, b) {
	if (!recognizeWinLIKE_(top, self).WinLIKE.ie) {
		return;
	}
	a = document.getElementsByTagName("input");
	for (b = 0; b < a.length; b++) {
		if (!a[b].readOnly && a[b].type != "hidden") {
			try {
				a[b].focus();
			}
			catch (p_) {
			}
			break;
		}
	}
}
function g1_() {
	return Math.round(10000 * Math.random());
}
fc_ = new Array();
function submitWinLIKE_(a, b, c, d, e, f) {
	b = recognizeWinLIKE_(top, "top");
	b.l_ ? c = a.srcElement : c = a.target;
	if (!c || c == "undefined") {
		c = document.getElementById(a);
		d = a_;
	}
	if (c.tagName != "FORM") {
		e = c;
		if (c == b.document || c == document) {
			return;
		}
		c = c.form;
		f = a_;
	}
	el_ = c.action;
	nr = document.getElementsByTagName(b.C_)[0].name;
	eu_ = b.__[nr];
	eI_ = c.target;
	!c.id ? c.id = g1_() : 0;
	ev_ = c.id;
	switch (fc_[ev_]) {
	  case 1:
		fc_[ev_] = 0;
		return;
	  case 2:
		b.l_ ? fc_[ev_] = 3 : fc_[ev_] = 4;
		return F_;
	  case 3:
		fc_[ev_] = 4;
		return;
	  case 4:
		fc_[ev_] = 0;
		return;
	  case 5:
		fc_[ev_] = 0;
		return F_;
	}
	if (eI_) {
		eH_ = b.J_(eI_);
		if (eH_) {
			eJ_ = b.__[eH_];
			if (b.fh_(eH_) == 0) {
				if (eJ_.es_) {
					if (f) {
						fc_[ev_] = 5;
						return F_;
					} else {
						fc_[ev_] = 0;
						return;
					}
				}
			}
			if (!eJ_.es_ || eJ_.Del || !eJ_.cG_) {
				b.c_.openaddress(b._B_ + "?", b_, eI_, eH_);
				eH_ = b.J_(eI_);
				eJ_ = b.__[eH_];
				b.__[eH_].dd_ = a_;
			}
			if (eJ_.es_) {
				f ? fc_[ev_] = 1 : document.getElementById(ev_).submit();
				b.eE_(el_, nr, eI_);
			} else {
				eJ_.b3_ = nr;
				if (f) {
					ew_ = g1_();
					e.d0_ = ew_;
					eJ_.d0_ = ew_;
					eJ_.aY_ = e.name;
					fc_[ev_] = 2;
				} else {
					eJ_.b2_ = ev_;
				}
				eJ_.d7_ = el_;
				eJ_.d1_ = nr;
			}
			eJ_.Mn ? b.fO_(eH_) : 0;
			b.fA_(eH_);
			eJ_.du_ = a_;
			if (!d) {
				return F_;
			}
		} else {
			return a_;
		}
	} else {
		aR_ = 0;
		if (b.fh_(nr) == 0) {
			aR_ = a_;
		}
		if (aR_ && !d) {
			return F_;
		} else {
			if (!aR_) {
				eu_.du_ = a_;
				b.eE_(el_, nr, eI_);
				d ? document.getElementById(ev_).submit() : 0;
			}
		}
	}
}

