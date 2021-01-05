// DynLAYER LIB
// www.microbians.com / Gabriel Suchowolski power[z]one - powerz@microbians.com
//
// Distributed under the terms of the GNU Library General Public License
//
// This routins are modifications based on Steinman DynAPI,
// so please... better use the original one.
// http://www.dansteinman.com/dynduo/
// 
// - added DIVs Array copy to regenerate on NS with RESIZE FIX LIB
// - added better code for load content on a DIV

// BrowserCheck Object
function BrowserCheck() {
	var b = navigator.appName
	if (b=="Netscape") this.b = "ns"
	else if (b=="Microsoft Internet Explorer") this.b = "ie"
	else this.b = b
	this.version = navigator.appVersion
	this.v = parseInt(this.version)
	this.ns = (this.b=="ns" && this.v>=4)
	this.ns4 = (this.b=="ns" && this.v==4)
	this.ns5 = (this.b=="ns" && this.v==5)
	this.ie = (this.b=="ie" && this.v>=4)
	this.ie4 = (this.version.indexOf('MSIE 4')>0)
	this.ie5 = (this.version.indexOf('MSIE 5')>0)
	this.min = (this.ns||this.ie)
}
is = new BrowserCheck()

// DynLayer Main Functions
function DynLayer(id,nestref,frame) {
	if (!DynLayer.set && !frame) DynLayerInit()
	this.frame = frame || self
	if (is.ns) {
		if (is.ns4) {
			if (!frame) {
				if (!nestref) var nestref = DynLayer.nestRefArray[id]
				if (!DynLayerTest(id,nestref)) return
				this.css = (nestref)? eval("document."+nestref+".document."+id) : document.layers[id]
			}
			else this.css = (nestref)? eval("frame.document."+nestref+".document."+id) : frame.document.layers[id]
			this.elm = this.event = this.css
			this.doc = this.css.document
		}
		if (is.ns5) {
			this.elm = document.getElementById(id)
			this.css = this.elm.style
			this.doc = document
		}
		this.x = this.css.left
		this.y = this.css.top
		this.w = this.css.clip.width
		this.h = this.css.clip.height
	}
	else if (is.ie) {
		this.elm = this.event = this.frame.document.all[id]
		this.css = this.frame.document.all[id].style
		this.doc = document
		this.x = this.elm.offsetLeft
		this.y = this.elm.offsetTop
		this.w = (is.ie4)? this.css.pixelWidth : this.elm.offsetWidth
		this.h = (is.ie4)? this.css.pixelHeight : this.elm.offsetHeight
	}

	this.clipt = this.clipValues('t')
	this.clipr = this.clipValues('r')
	this.clipb = this.clipValues('b')
	this.clipl = this.clipValues('l')

	this.id = id
	this.nestref = nestref
	this.obj = id + "DynLayer"
	eval(this.obj + "=this")
	this.name = this.id.substring(0, this.id.lastIndexOf("Div"))

	this.SCROLLobj = null
	this.link      = ""
}

function DynLayerMoveTo(x,y) {
	if (x!=null) {
		this.x = x
		if (is.ns) this.css.left = Math.ceil( this.x )
		else this.css.pixelLeft  = Math.ceil( this.x )
	}
	if (y!=null) {
		this.y = y
		if (is.ns) this.css.top = Math.ceil( this.y )
		else this.css.pixelTop  = Math.ceil( this.y )
	}
}

function DynLayerResizeTo(w,h, clip) {
	if (w!=null) {
		this.w = w
		if (is.ns) this.css.clip.width = Math.ceil( this.w )
		else 	   this.css.pixelWidth = Math.ceil( this.w )
	}
	if (h!=null) {
		this.h = h
		if (is.ns) this.css.clip.height = Math.ceil( this.h )
		else 	   this.css.pixelHeight = Math.ceil( this.h )
	}
	if (clip == null) this.clipTo(0, Math.ceil( this.w ), Math.ceil( this.h ),0);
}

function DynLayerMoveBy(x,y) {
	this.moveTo(this.x+x,this.y+y)
}

function DynLayerShow() {
	this.css.visibility = (is.ns)? "show" : "visible"
}

function DynLayerHide() {
	this.css.visibility = (is.ns)? "hide" : "hidden"
}

function DynLayerisVisible() {
	     if ( is.ns && this.css.Visibility == "hide"  ) return false
	else if ( is.ie && this.css.Visibility == "hidden" ) return false
	else return true
}

DynLayer.prototype.resizeTo  = DynLayerResizeTo
DynLayer.prototype.moveTo    = DynLayerMoveTo
DynLayer.prototype.moveBy    = DynLayerMoveBy
DynLayer.prototype.show      = DynLayerShow
DynLayer.prototype.hide      = DynLayerHide
DynLayer.prototype.isVisible = DynLayerisVisible
DynLayerTest = new Function('return true')

// DynLayerInit Function
function DynLayerInit(nestref) {
	if (!DynLayer.set) DynLayer.set = true
	if (is.ns) {
		if (nestref) ref = eval('document.'+nestref+'.document')
		else {nestref = ''; ref = document;}
		for (var i=0; i<ref.layers.length; i++) {
			var divname = ref.layers[i].name
			DynLayer.nestRefArray[divname] = nestref
			var index = divname.indexOf("Div")
			if (index > 0) {
				eval(divname.substr(0,index)+' = new DynLayer("'+divname+'","'+nestref+'")')
				DynLayer.DynLayerobj.i++;
				eval('DynLayer.DynLayerobj['+ DynLayer.DynLayerobj.i +']=' + divname.substr(0,index) )
				DynLayer.DynLayercrt[DynLayer.DynLayerobj.i]= false;
			}
			if (ref.layers[i].document.layers.length > 0) {
				DynLayer.refArray[DynLayer.refArray.length] = (nestref=='')? ref.layers[i].name : nestref+'.document.'+ref.layers[i].name
			}
		}
		if (DynLayer.refArray.i < DynLayer.refArray.length) {
			DynLayerInit(DynLayer.refArray[DynLayer.refArray.i++])
		}
	}
	else if (is.ie) {
		for (var i=0; i<document.all.tags("DIV").length; i++) {
			var divname = document.all.tags("DIV")[i].id
			var index = divname.indexOf("Div")
			if (index > 0) {
				eval(divname.substr(0,index)+' = new DynLayer("'+divname+'")')
				DynLayer.DynLayerobj.i++;
				eval('DynLayer.DynLayerobj['+ DynLayer.DynLayerobj.i +']=' + divname.substr(0,index) )
				DynLayer.DynLayercrt[DynLayer.DynLayerobj.i]= false;
			}
		}
	}
	return true
}

DynLayer.DynLayerobj = new Array()
DynLayer.DynLayercrt = new Array()
DynLayer.DynLayerobj.i = 0

DynLayer.nestRefArray = new Array()
DynLayer.refArray = new Array()
DynLayer.refArray.i = 0
DynLayer.set = false

// Clip Methods
function DynLayerClipInit(clipTop,clipRight,clipBottom,clipLeft) {
	if (is.ie) {
		if (arguments.length==4) this.clipTo(clipTop,clipRight,clipBottom,clipLeft)
		else if (is.ie4) this.clipTo(0,this.css.pixelWidth,this.css.pixelHeight,0)
	}
}
function DynLayerClipTo(t,r,b,l) {
	if (t==null) t = this.clipValues('t')
	if (r==null) r = this.clipValues('r')
	if (b==null) b = this.clipValues('b')
	if (l==null) l = this.clipValues('l')
	if (is.ns) {
		this.css.clip.top = t
		this.css.clip.right = r
		this.css.clip.bottom = b
		this.css.clip.left = l
	}
	else if (is.ie) this.css.clip = "rect("+t+"px "+r+"px "+b+"px "+l+"px)"

	this.clipt = t
	this.clipr = r
	this.clipb = b
	this.clipl = l
}
function DynLayerClipBy(t,r,b,l) {
	this.clipTo(this.clipValues('t')+t,this.clipValues('r')+r,this.clipValues('b')+b,this.clipValues('l')+l)
}
function DynLayerClipValues(which) {
	if (is.ie && this.css.clip ) var clipv = this.css.clip.split("rect(")[1].split(")")[0].split("px")
	if (is.ns) {
		if (which=="t") return this.css.clip.top
		if (which=="r") return this.css.clip.right
		if (which=="b") return this.css.clip.bottom
		if (which=="l") return this.css.clip.left
	}
	else {
		if (this.css.clip) {
			if (which=="t") return Number(clipv[0])
			if (which=="r") return Number(clipv[1])
			if (which=="b") return Number(clipv[2])
			if (which=="l") return Number(clipv[3])
		}
		else {
			if (which=="t") return 0
			if (which=="r") return this.w
			if (which=="b") return this.h
			if (which=="l") return 0
		}
	}
}
DynLayer.prototype.clipInit = DynLayerClipInit
DynLayer.prototype.clipTo = DynLayerClipTo
DynLayer.prototype.clipBy = DynLayerClipBy
DynLayer.prototype.clipValues = DynLayerClipValues

// Write Method
function DynLayerWrite(html) {
	if (is.ns) {
		if (html != "" ) {
			this.doc.open()
			this.doc.clear()
			this.doc.write(html)
			this.doc.close()
		}
		else {
			this.doc.open()
			this.doc.clear()
			this.doc.write("<body></body>")
			this.doc.close()
		}
	}
	else if (is.ie) {
		this.event.innerHTML = html
	}
}
DynLayer.prototype.write = DynLayerWrite

// DynLayer Load power[Z]one's Method v.20

var DynLayerLoadSTILL = 0;

function DynLayerLoad(url,fn, ncpy) {
	this.url=url
	if ( DynLayerLoadSTILL == 0 || is.ie) {
		DynLayerLoadSTILL++
		this.onread = fn;
		this.onload = this.onLoadHanddler
		if (is.ie) this.write("<font size=1 face=verdana><b>&nbsp;l o a d i n g . . . </b></font>");
		if (is.ns) {
			this.doc.clear()
			this.elm.onload = this.onLoadHanddler
			this.elm.load(url,this.w)
		}
		else if (is.ie) { 
			this.createIFRAME()
			this.loadDocument(url, ncpy)
		}
	}
	else {
		setTimeout( this.obj+'.load("'+url+'","'+fn+'",'+ncpy+')', 20 );
	}
}

DynLayerENLACES = new Array()

function regenerateLINKARRAYonNS(nselobj) {
	var nsel = eval(nselobj)
	if ( nsel.doc.links.length ){
		delete DynLayerENLACES
		DynLayerENLACES = new Array()
		if ( nsel.doc.links.length >0) {
			var ll=nsel.doc.links.length
			for (var i=0; i<ll; i++) {
				DynLayerENLACES[i]=nsel.doc.links[i].href
				nsel.doc.links[i].href=""
			}
	
			for (var i=0; i<ll; i++) {
				nsel.doc.links[i].href=DynLayerENLACES[i]
			}
		}
	}
	else {
		setTimeout( "regenerateLINKARRAYonNS('"+nselobj+"')" ,  20)
	}
}

function DynLayeronLoadHanddler(doc, ncpy) {
	this.onload = null
	if (is.ie) { 
		if (ncpy != true) this.write(doc)
		eval(this.onread)
		DynLayerLoadSTILL--;
	} else {
		var nsel = eval(this.id.substring(0, this.id.lastIndexOf("Div")))
		if (ncpy == true) eval( "nsel.write('')");
		regenerateLINKARRAYonNS(nsel.obj)
		setTimeout( nsel.onread , 20);
		setTimeout( "DynLayerLoadSTILL--;", 30);
     	}
}

function DynLayercreateIFRAME() {
	this.frameName = this.id + 'bufferframe'
	var destFrame = document.frames[this.frameName]
	if (destFrame==null) {
		var html = '';
		html += '<IFRAME ID="' + this.frameName + '"';
    		html += ' NAME="' + this.frameName + '"';
		html += ' STYLE="position: absolute; left: -10px; top: -10px; visibility:none; width:0; height:0; "';
    		html += ' SRC="about:blank">';
    		html += '<\/IFRAME>';
    		document.body.insertAdjacentHTML('beforeEnd', html);
	}
}

function DynLayerloadDocument(url, ncpy) {
  if (url)
    	this.url = url
  	this.loaded = false
  	this.document = null
	var ifrWin = document.frames[this.frameName]
  	
	var html = ''
  	html += '<HTML>'
	html += '<HEAD><meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><\/HEAD>'
  	html += '<BODY ONLOAD=\''
  	html += 'var fl = parent.' + this.name + ';'
  	html += 'fl.loaded = true;'
  	html += 'fl.document = window.frames["loader"].document;'
  	if (ncpy) html += 'fl.onload(fl.document.body.innerHTML,'+ncpy+');'
	else      html += 'fl.onload(fl.document.body.innerHTML);'
  	html += 'document.location.replace("about:blank")'
 	html += '\'>'
  	html += '<IFRAME id="loader" name="loader" SRC="' + this.url + '">'
  	html += '<\/IFRAME>'
  	html += '<\/BODY>'
  	html += '<\/HTML>'
  	ifrWin.document.open();
  	ifrWin.document.write(html);
  	ifrWin.document.close();
}

DynLayer.prototype.load           = DynLayerLoad
DynLayer.prototype.createIFRAME   = DynLayercreateIFRAME
DynLayer.prototype.loadDocument   = DynLayerloadDocument
DynLayer.prototype.onLoadHanddler = DynLayeronLoadHanddler


// DynLayer set-get zIndex / POWERZONE 
function DynLayerSetz(zIndex) {
	this.css.zIndex = zIndex
}

function DynLayerGetz(zIndex) {
	return this.css.zIndex
}

DynLayer.prototype.SetzIndex = DynLayerSetz
DynLayer.prototype.GetzIndex = DynLayerGetz

// DynLayer Set Background Method
// changes the background (the layer must be clipped)
// POWERZONE // Corrected ins NS doc by elm for work ok in NS4

hexa = new Array();
for(var i = 0; i < 10; i++) hexa[i] = i;
hexa[10]="a"; hexa[11]="b"; hexa[12]="c";
hexa[13]="d"; hexa[14]="e"; hexa[15]="f";
function hex(i) {
         if (i <= 0)   return "00";
    else if (i >= 255) return "ff";
    else return "" + hexa[Math.floor(i/16)] + hexa[i%16];
}

function DynLayerSetbg(color) {
	if (is.ns) this.elm.bgColor         = color
	else       this.css.backgroundColor = color
}

function DynLayerSetbgRGB(r,g,b) {
	var hr = hex(r); 
	var hg = hex(g); 
	var hb = hex(b);
	this.setbg("#"+hr+hg+hb)
}

DynLayer.prototype.setbg    = DynLayerSetbg
DynLayer.prototype.setbgRGB = DynLayerSetbgRGB

// Preload IMG
function preload(imgObj,imgSrc) {
	if (document.images) {
		eval(imgObj+' = new Image()')
		eval(imgObj+'.src = "'+imgSrc+'"')
	}
}

// DynLayer ChangeImage Method swaps an image in the layer
// v.2.0 added a control to no chage the conection
function DynLayerImg(imgName,imgObj) {
	var ELimg   = eval(imgObj)
	var HTMLimg = this.elm.document.images[imgName]
	if ( ELimg && ELimg.src && ELimg.src.toString() != HTMLimg.src.toString() ) {
		HTMLimg.src = ELimg.src
	}
}
function DynLayerImgURL(imgName,imgURL) {
	var HTMLimg = this.elm.document.images[imgName]
	HTMLimg.src = imgURL
}

DynLayer.prototype.img    = DynLayerImg
DynLayer.prototype.imgURL = DynLayerImgURL


// DynLayer GetRelative Methods
// retrieves the real location of a relatively positioned layer
function DynLayerGetRelativeX() {
	return (is.ns)? this.css.pageX : this.elm.offsetLeft
}
function DynLayerGetRelativeY() {
	return (is.ns)? this.css.pageY : this.elm.offsetTop
}
DynLayer.prototype.getRelativeX = DynLayerGetRelativeX
DynLayer.prototype.getRelativeY = DynLayerGetRelativeY

// DynLayer GetContent Width/Height Methods
// retrieves the total width/height of the contents of the layer when they are not known
function DynLayerUpdateSize() {
	this.updateWidth()
	this.updateHeight()
}

function DynLayerUpdateHeight() {
	this.h = this.getContentHeight()
}

function DynLayerUpdateWidth() {
	this.w = this.getContentWidth()
}

DynLayer.prototype.updateSize   = DynLayerUpdateSize
DynLayer.prototype.updateHeight = DynLayerUpdateHeight
DynLayer.prototype.updateWidth  = DynLayerUpdateWidth

function DynLayerGetContentWidth() {
	return (is.ns)? this.doc.width : this.elm.scrollWidth
}
function DynLayerGetContentHeight() {
	return (is.ns)? this.doc.height : this.elm.scrollHeight
}
DynLayer.prototype.getContentWidth = DynLayerGetContentWidth
DynLayer.prototype.getContentHeight = DynLayerGetContentHeight

// Basic Flash Write function / power[Z]one

function DynLayerpintaflashHTML(name, archivo, w, h, bg) {
	if (is.ie)  {
        	this.write('<object id="'+ name +'" classid="clsid:D27CDB6E-AE6D-11cf-96B8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=4,0,0,0" WIDTH="'+ w +'" HEIGHT="'+ h +'"><PARAM NAME=movie VALUE="'+ archivo +'"><PARAM NAME=quality VALUE=high><PARAM NAME=menu    VALUE=false><PARAM NAME=loop VALUE=false><PARAM NAME=BGCOLOR VALUE="'+bg+'"><param NAME=WMODE VALUE=opaque></object>');
	} else {
		this.write('<EMBED name='+ name +' SRC="'+ archivo +'" WIDTH='+ w +' HEIGHT='+ h +' swliveconnect=true MENU=true QUALITY=high LOOP=no TYPE="application/x-shockwave-flash" PLUGINSPAGE="http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash" PLAY=true BGCOLOR="'+bg+'"></EMBED>');
	}
}

DynLayer.prototype.writeFlash = DynLayerpintaflashHTML

function DynLayergetObject(objectname) {
	return is.ie ? eval(this.name+".doc."+objectname) : eval(this.name+".doc.embeds['"+objectname+"']");
}

DynLayer.prototype.getObject = DynLayergetObject