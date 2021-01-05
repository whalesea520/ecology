/*Ext.urlEncode = function(o) {
    if (!o) {
        return "";
    }
    var buf = [];
    for (var key in o) {
        var ov = o[key], k = encodeURIComponent(key);
        var type = typeof ov;
        if (type == 'undefined') {
            buf.push(k, "=&");
        }else if(type=="number"){
        	 buf.push(k, "=", ov, "&");
        }else if (type != "function" && type != "object") {
            buf.push(k, "=", encodeURIComponent(ov), "&");
        } else if (Ext.isArray(ov)) {
            if (ov.length) {
                for (var i = 0, len = ov.length; i < len; i++) {
                    buf.push(k, "=", encodeURIComponent(ov[i] === undefined
                            ? ''
                            : ov[i]), "&");
                }
            } else {
                buf.push(k, "=&");
            }
        } else if (type == "object") {
        	
            for (var okey in ov) {
                if (ov.hasOwnProperty(okey)) {
                    var rk = encodeURIComponent(k + '[' + okey + ']');
                    buf.push(rk, "=", encodeURIComponent(ov[okey]), "&");
                }
            }
        }
    }
    buf.pop();
   return buf.join("");
} 
*/

Ext.urlEncode =  function(o, pre){
	var undef, buf = [], key, e = encodeURIComponent;
	
	for(key in o){
		undef = !Ext.isDefined(o[key]);		

		Ext.each(undef ? key : o[key], function(val, i){
			if(typeof val == "number") {
				val=""+val
			}
			var tmp= (val != key || !undef) ? e(val) : "";
			//alert("val:"+val+"  key:"+key+"  undef:"+undef+"  e(val):"+e(val))

			buf.push("&", e(key), "=", tmp);
		});	

	}
	if(!pre){
		buf.shift();
		pre = "";
	}
	return pre + buf.join('');
}
