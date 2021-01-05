(function(){
	function isRunInEmobile(){
		var ua = navigator.userAgent.toLowerCase();
		if(ua.match(/e-mobile/i) == "e-mobile"){
			return true;
	    }else{
	        return false;
	    }
	}
	
	function callbackRun(longitude, latitude){
		var position = {
				"coords" : {
					"longitude" : longitude,
					"latitude" : latitude
				}
		};
		if(typeof(window.lbsCallback) == "function"){
			window.lbsCallback.call(window, position);
		}
	}
	
	var requestCount = 0;
	var responseCount = 0;
	window.MLocation = {
		getCurrentPosition : function(callback, failback){
			window.lbsCallback = callback;
			if(isRunInEmobile()){
				requestCount++;
				location = "emobile:gps:getEmobileLBSResult";
			}else if(typeof(eb_GetLocation) == "function"){
				eb_GetLocation("getWxLbsResult");
			}else{
				navigator.geolocation.getCurrentPosition(callback,failback,{
					enableHighAcuracy: true,
					maximumAge: 3000
				});
			}
		}
	};
	
	
	window.getEmobileLBSResult = function(result){
		responseCount++;
		if(requestCount != responseCount){
			return;
		}
		if(result){
			var resultArr = result.split(",");
			if(resultArr.length >= 3){
				var longitude = resultArr[2];
				var latitude = resultArr[1];
				var gps = GPS.gcj_decrypt(latitude, longitude);
				longitude = gps.lon;
				latitude = gps.lat;
				callbackRun(longitude, latitude);
				/*
				var gpsPoint = new BMap.Point(longitude, latitude);
				BMap.Convertor.translate(gpsPoint, 0, function(point){
					var b_map = new BMap.Map("maper");
					b_map.clearOverlays();
					b_map.centerAndZoom(point, 18);
					b_map.addOverlay(new BMap.Marker(point));
					b_map.enableScrollWheelZoom();  
				});*/
			}
		}
	};
	
	window.getWxLbsResult = function(longitude, latitude){
		var gps = GPS.gcj_decrypt(latitude, longitude);
		longitude = gps.lon;
		latitude = gps.lat;
		callbackRun(longitude, latitude);
	};
	
	
})();

var GPS = {
    PI : 3.14159265358979324,
    x_pi : 3.14159265358979324 * 3000.0 / 180.0,
    delta : function (lat, lon) {
        // Krasovsky 1940
        //
        // a = 6378245.0, 1/f = 298.3
        // b = a * (1 - f)
        // ee = (a^2 - b^2) / a^2;
        var a = 6378245.0; //  a: 卫星椭球坐标投影到平面地图坐标系的投影因子。
        var ee = 0.00669342162296594323; //  ee: 椭球的偏心率。
        var dLat = this.transformLat(lon - 105.0, lat - 35.0);
        var dLon = this.transformLon(lon - 105.0, lat - 35.0);
        var radLat = lat / 180.0 * this.PI;
        var magic = Math.sin(radLat);
        magic = 1 - ee * magic * magic;
        var sqrtMagic = Math.sqrt(magic);
        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * this.PI);
        dLon = (dLon * 180.0) / (a / sqrtMagic * Math.cos(radLat) * this.PI);
        return {'lat': dLat, 'lon': dLon};
    },
    //GCJ-02 to WGS-84
    gcj_decrypt : function (gcjLat, gcjLon) {
        if (this.outOfChina(gcjLat, gcjLon))
            return {'lat': gcjLat, 'lon': gcjLon};
         
        var d = this.delta(gcjLat, gcjLon);
        return {'lat': gcjLat - d.lat, 'lon': gcjLon - d.lon};
    },
    outOfChina : function (lat, lon) {
        if (lon < 72.004 || lon > 137.8347)
            return true;
        if (lat < 0.8293 || lat > 55.8271)
            return true;
        return false;
    },
    transformLat : function (x, y) {
        var ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * Math.sqrt(Math.abs(x));
        ret += (20.0 * Math.sin(6.0 * x * this.PI) + 20.0 * Math.sin(2.0 * x * this.PI)) * 2.0 / 3.0;
        ret += (20.0 * Math.sin(y * this.PI) + 40.0 * Math.sin(y / 3.0 * this.PI)) * 2.0 / 3.0;
        ret += (160.0 * Math.sin(y / 12.0 * this.PI) + 320 * Math.sin(y * this.PI / 30.0)) * 2.0 / 3.0;
        return ret;
    },
    transformLon : function (x, y) {
        var ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * Math.sqrt(Math.abs(x));
        ret += (20.0 * Math.sin(6.0 * x * this.PI) + 20.0 * Math.sin(2.0 * x * this.PI)) * 2.0 / 3.0;
        ret += (20.0 * Math.sin(x * this.PI) + 40.0 * Math.sin(x / 3.0 * this.PI)) * 2.0 / 3.0;
        ret += (150.0 * Math.sin(x / 12.0 * this.PI) + 300.0 * Math.sin(x / 30.0 * this.PI)) * 2.0 / 3.0;
        return ret;
    }
};
