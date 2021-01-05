// Glide LIB

// - added Ceil to correct a error that make one pixel jump at the end
// - added Window object to handdle glide (pos&size) of windows

function winInit( x, y, w, h ) {
	this.obj="window"
	if (w!=null && h!=null) this.WHsize(w,h);
	if (x!=null && y!=null) this.XYmove(x,y);
}

//------------ ALL

function winGlideTo() {

if ( arguments.length == 6 ) this.XYglideTo(arguments[0],arguments[1],arguments[2],arguments[3],arguments[4],arguments[5]);              //(startSpeedXY,endSpeedXY,endx,endy,angleinc,speed)
if ( arguments.length == 7 ) this.XYglideTo(arguments[0],arguments[1],arguments[2],arguments[3],arguments[4],arguments[5],arguments[6]); //(startSpeedXY,endSpeedXY,endx,endy,angleinc,speed, fnXY)

if ( arguments.length == 10 ) this.XYWHglideTo(arguments[0],arguments[1],arguments[2],arguments[3],arguments[4],arguments[5],arguments[6],arguments[7],arguments[8],arguments[9],arguments[10]);              		   //(startSpeedXY,endSpeedXY,endx,endy, startSpeedWH,endSpeedWH,endw,endh,angleinc,speed)
if ( arguments.length == 11 ) this.XYWHglideTo(arguments[0],arguments[1],arguments[2],arguments[3],arguments[4],arguments[5],arguments[6],arguments[7],arguments[8],arguments[9],arguments[10],arguments[11]); 		   //(startSpeedXY,endSpeedXY,endx,endy, startSpeedWH,endSpeedWH,endw,endh,angleinc,speed,fn)

}

function winXYWHglideTo( startSpeedXY,endSpeedXY,endx,endy, startSpeedWH,endSpeedWH,endw,endh,angleinc,speed,fn) {
	this.XYglideTo(startSpeedXY,endSpeedXY,endx,endy,angleinc,speed)
	this.WHglideTo(startSpeedWH,endSpeedWH,endw,endh,angleinc,speed,fn)
}

function winXYmove(x,y) {
	this.moveTo( Math.ceil( x ), Math.ceil( y ) )
	this.x = x;
	this.y = y;
}

function winWHsize(w,h) {
	this.resizeTo( Math.ceil( w ), Math.ceil( h ) )
	this.w = w;
	this.h = h;
}

//------------ POS

function winXYGlideTo(startSpeed,endSpeed,endx,endy,angleinc,speed,fn) {
	if (endx==null) endx = this.x
	if (endy==null) endy = this.y
	var distx = endx-this.x
	var disty = endy-this.y
	this.XYglideStart(startSpeed,endSpeed,endx,endy,distx,disty,angleinc,speed,fn)
}

function winXYGlideStart(startSpeed,endSpeed,endx,endy,distx,disty,angleinc,speed,fn) {
	if (this.XYglideActive) return
	if (endx==this.x) var slantangle = 90
	else if (endy==this.y) var slantangle = 0
	else var slantangle = Math.abs(Math.atan(disty/distx)*180/Math.PI)
	if (endx>=this.x) {
		if (endy>this.y) slantangle = 360-slantangle
	}
	else {
		if (endy>this.y) slantangle = 180+slantangle
		else slantangle = 180-slantangle
	}
	slantangle *= Math.PI/180
	var amplitude = Math.sqrt(Math.pow(distx,2) + Math.pow(disty,2))
	if (!fn) fn = null
	this.XYglideActive = true
	if (startSpeed == "fast") {
		if (endSpeed=="fast") this.XYglide(1,amplitude/2,0,90,this.x,this.y,slantangle,endx,endy,distx,disty,angleinc,speed,fn)
		else this.XYglide(0,amplitude,0,90,this.x,this.y,slantangle,endx,endy,distx,disty,angleinc,speed,fn)
	}
	else {
		if (endSpeed=="fast") this.XYglide(0,amplitude,-90,0,this.x+distx,this.y+disty,slantangle,endx,endy,distx,disty,angleinc,speed,fn)
		else this.XYglide(0,amplitude/2,-90,90,this.x+distx/2,this.y+disty/2,slantangle,endx,endy,distx,disty,angleinc,speed,fn)
	}
}

function winXYGlide(type,amplitude,angle,endangle,centerX,centerY,slantangle,endx,endy,distx,disty,angleinc,speed,fn) {
	if (angle < endangle && this.XYglideActive) {
		angle += angleinc
		var u = amplitude*Math.sin(angle*Math.PI/180)
		var x = centerX + u*Math.cos(slantangle)
		var y = centerY - u*Math.sin(slantangle)
		this.XYmove( x, y )
		this.XYonGlide()
		if (this.XYglideActive) setTimeout(this.obj+'.XYglide('+type+','+amplitude+','+angle+','+endangle+','+centerX+','+centerY+','+slantangle+','+endx+','+endy+','+distx+','+disty+','+angleinc+','+speed+',\''+fn+'\')',speed)
		else this.XYonGlideEnd()
	}
	else {
		if (type==1) this.XYglide(0,amplitude,-90,0,this.x+distx/2,this.y+disty/2,slantangle,endx,endy,distx,disty,angleinc,speed,fn)
		else {
			this.XYglideActive = false
			this.XYmove(endx,endy)
			this.XYonGlide()
			this.XYonGlideEnd()
			eval(fn)
		}
	}
}

//------------ SIZE

function winWHGlideTo(startSpeed,endSpeed,endx,endy,angleinc,speed,fn) {
	if (endx==null) endx = this.w
	if (endy==null) endy = this.h
	var distx = endx-this.w
	var disty = endy-this.h
	this.WHglideStart(startSpeed,endSpeed,endx,endy,distx,disty,angleinc,speed,fn)
}

function winWHGlideStart(startSpeed,endSpeed,endx,endy,distx,disty,angleinc,speed,fn) {
	if (this.WHglideActive) return
	if (endx==this.w) var slantangle = 90
	else if (endy==this.h) var slantangle = 0
	else var slantangle = Math.abs(Math.atan(disty/distx)*180/Math.PI)
	if (endx>=this.w) {
		if (endy>this.h) slantangle = 360-slantangle
	}
	else {
		if (endy>this.h) slantangle = 180+slantangle
		else slantangle = 180-slantangle
	}
	slantangle *= Math.PI/180
	var amplitude = Math.sqrt(Math.pow(distx,2) + Math.pow(disty,2))
	if (!fn) fn = null
	this.WHglideActive = true
	if (startSpeed == "fast") {
		if (endSpeed=="fast") this.WHglide(1,amplitude/2,0,90,this.w,this.h,slantangle,endx,endy,distx,disty,angleinc,speed,fn)
		else 		      this.WHglide(0,amplitude,0,90,this.w,this.h,slantangle,endx,endy,distx,disty,angleinc,speed,fn)
	}
	else {
		if (endSpeed=="fast") this.WHglide(0,amplitude,-90,0,this.w+distx,this.h+disty,slantangle,endx,endy,distx,disty,angleinc,speed,fn)
		else 	              this.WHglide(0,amplitude/2,-90,90,this.w+distx/2,this.h+disty/2,slantangle,endx,endy,distx,disty,angleinc,speed,fn)
	}
}

function winWHGlide(type,amplitude,angle,endangle,centerX,centerY,slantangle,endx,endy,distx,disty,angleinc,speed,fn, wfn) {
	if ( wfn==null && angle < endangle && this.WHglideActive) {
		angle += angleinc
		var u = amplitude*Math.sin(angle*Math.PI/180)
		var w = centerX + u*Math.cos(slantangle)
		var h = centerY - u*Math.sin(slantangle)
		this.WHsize( w, h )
		this.WHonGlide()
		if (this.WHglideActive) setTimeout(this.obj+'.WHglide('+type+','+amplitude+','+angle+','+endangle+','+centerX+','+centerY+','+slantangle+','+endx+','+endy+','+distx+','+disty+','+angleinc+','+speed+',\''+fn+'\')',speed)
		else this.WHonGlideEnd()
	}
	else {
		if (type==1) this.WHglide(0,amplitude,-90,0,this.w+distx/2,this.h+disty/2,slantangle,endx,endy,distx,disty,angleinc,speed,fn)
		else {
			this.WHglideActive = false
			this.WHsize(endx,endy)
			this.WHonGlide()
			this.WHonGlideEnd()
			if (this.XYglideActive == false) eval(fn)
			else 			         setTimeout(this.obj+'.WHglide('+type+','+amplitude+','+angle+','+endangle+','+centerX+','+centerY+','+slantangle+','+endx+','+endy+','+distx+','+disty+','+angleinc+','+speed+',\''+fn+'\',\''+1+'\')',speed)
		}
	}
}

// For windows

window.WinInit      = winInit

window.glideTo      = winGlideTo
window.XYWHglideTo  = winXYWHglideTo

window.move         = winXYmove
window.XYmove       = winXYmove
window.XYglideTo    = winXYGlideTo
window.XYglideStart = winXYGlideStart
window.XYglide      = winXYGlide
window.XYonGlide    = new Function()
window.XYonGlideEnd = new Function()

window.size         = winWHsize
window.WHsize       = winWHsize
window.WHglideTo    = winWHGlideTo
window.WHglideStart = winWHGlideStart
window.WHglide      = winWHGlide
window.WHonGlide    = new Function()
window.WHonGlideEnd = new Function()

// For DynLayers

DynLayer.prototype.glideTo      = winGlideTo;
DynLayer.prototype.XYWHglideTo  = winXYWHglideTo


DynLayer.prototype.XYmove       = winXYmove
DynLayer.prototype.XYglideTo    = winXYGlideTo
DynLayer.prototype.XYglideStart = winXYGlideStart
DynLayer.prototype.XYglide      = winXYGlide
DynLayer.prototype.XYonGlide    = new Function()
DynLayer.prototype.XYonGlideEnd = new Function()

DynLayer.prototype.WHsize       = winWHsize
DynLayer.prototype.WHglideTo    = winWHGlideTo
DynLayer.prototype.WHglideStart = winWHGlideStart
DynLayer.prototype.WHglide      = winWHGlide
DynLayer.prototype.WHonGlide    = new Function()
DynLayer.prototype.WHonGlideEnd = new Function()

