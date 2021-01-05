if(typeof(Mobile_NS) == 'undefined'){
	Mobile_NS = {};
}

Mobile_NS.LocationBack = function(){
	this.cookieName = "Mobile_Locations";
};

Mobile_NS.LocationBack.prototype.writeLocationInCookie = function(){
	var l = Mobile_NS_ReadCookie(this.cookieName);
	if(!l){
		l = location.href;
	}else{
		l += "|" + location.href;
	}
	Mobile_NS_WriteCookie(this.cookieName, l);
};

Mobile_NS.LocationBack.prototype.getBackLocation = function(){
	var l = Mobile_NS_ReadCookie(this.cookieName);
	if(!l){
		return "";
	}
	
	var url = "";
	var lArr = l.split("|");
	if(lArr.length > 1){
		url = lArr[lArr.length - 2];
		lArr.pop();
		lArr.pop();
	}else{
		lArr.pop();
	}
	var newL = "";
	for(var i = 0; i < lArr.length; i++){
		newL += lArr[i];
		if(i != (lArr.length - 1)){
			newL += "|";
		}
	}
	Mobile_NS_WriteCookie(this.cookieName, newL);
	
	return url;
};

Mobile_NS.LocationBack.prototype.doLocationBack = function(){
	var l = this.getBackLocation();
	if(l == ""){
		return "BACK";
	}else{
		location.href = l;
		return "1";
	}
};

Mobile_NS.LocationBack.prototype.removeLastLocation = function(){
	var l = Mobile_NS_ReadCookie(this.cookieName);
	if(!l){
		return;
	}
	var lArr = l.split("|");
	lArr.pop();
	
	var newL = "";
	for(var i = 0; i < lArr.length; i++){
		newL += lArr[i];
		if(i != (lArr.length - 1)){
			newL += "|";
		}
	}
	Mobile_NS_WriteCookie(this.cookieName, newL);	
};

Mobile_NS.LocationBack.prototype.clearLocation = function(){
	Mobile_NS_DelCookie(this.cookieName);
};

//写cookie
function Mobile_NS_WriteCookie(name, value){
    document.cookie = name + "="+ escape (value);
};

//读cookie
function Mobile_NS_ReadCookie(name){
	var b = document.cookie;
    var e = name + "=";
    var d = b.indexOf("; " + e);
    if (d == -1) {
        d = b.indexOf(e);
        if (d != 0) {
            return null;
        }
    } else {
        d += 2
    }
    var a = document.cookie.indexOf(";", d);
    if (a == -1) {
        a = b.length
    }
    return unescape(b.substring(d + e.length, a))
};

//删除cookie
function Mobile_NS_DelCookie(name){
	var date = new Date();   
	date.setTime(date.getTime() - 10000);   
	document.cookie = name + "=a; expires=" + date.toGMTString();
};