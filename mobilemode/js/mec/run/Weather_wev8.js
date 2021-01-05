if(typeof(Mobile_NS) == 'undefined'){
	Mobile_NS = {};
}

Mobile_NS.showCurrentCityWeather = function (theId,mecJson){
	Mobile_NS.getCurrentPosition(function(result){
	    var status = result["status"];
	    if(status == "1"){
	        var city = "Shanghai"; 
	        Mobile_NS.initWeather(theId,city);
	    }
	});
}

Mobile_NS.initWeather = function(theId,cityname,mecJson) {
	var baseYahooURL = "https://query.yahooapis.com/v1/public/yql?q=";
	var selectedCity = "shanghai";
	var placeholder = "";
	var unit = "c";
	if(typeof(cityname)=="string"&&cityname!=""){
		selectedCity = cityname;
	}else{
		if(mecJson){
			selectedCity = mecJson["city"];
		}else{
			var showCity = $("#weathercity_"+theId).val();
			if(typeof(showCity)=="string"&&showCity!=""){
				selectedCity = showCity; 
			}
		}
	}
	
	$("#weathercity_"+theId).val(selectedCity);
    getWoeid(selectedCity,theId);
    
    $("#weathercity_"+theId).keypress(function() {
        if (event.which == 13) {
            selectedCity = $("#weathercity_"+theId).val();
            getWoeid(selectedCity,theId);
            $("#weathercity_"+theId).blur();
        }
    });

    $("#weathercity_"+theId).focus(function(event) {
        placeholder = $("#weathercity_"+theId).val();
       $("#weathercity_"+theId).val("");
    });

    $("#weathercity_"+theId).blur(function(event) {
        if ($("#weathercity_"+theId).val() == "") {
            $("#weathercity_"+theId).val(placeholder);
        }
    });
    
    function getWoeid(weathercity,theId) {
    	var woeid =  WeatherCityCode[weathercity.toLowerCase()];
    	if(woeid&&!isNaN(woeid)){
    		getWeatherInfo(woeid,theId);
    	}else{
		    var woeidYQL = 'select woeid from geo.placefinder where text="' + weathercity + '"&format=json';
		    var jsonURL = baseYahooURL + woeidYQL;
		    showLoading(theId);
		    $.getJSON(jsonURL, function(data){
		    	woeidDownloaded(data,theId);
		    });
    	}
	}
    
    function showLoading(theId){
    	var weatherContainer = $("#weatherContainer_"+theId);
    	var city = $("#weathercity_"+theId);
    	var cityspan = $("#weathercity_"+theId+"_span");
    	var topDiv = city.parent();
    	var h = topDiv.height();
    	if(cityspan.length==0){
    		topDiv.append("<div style='color: white;padding-top:15px;va;font-size: 14px;display:none;' id='weathercity_"+theId+"_span' >正在加载天气...</div>");
    	}
    	var bot = $(".bot",weatherContainer);
    	var top = $(".top",weatherContainer);
    	bot.css("height",(bot.height()-20)+"px");
    	$("#weathercity_"+theId+"_span").css("height",(top.height()-30-15)+"px");;
    	$("#weathercity_"+theId+"_span").show();
    	$(".bot li img",weatherContainer).hide();
    	$(".bot li p",weatherContainer).hide();
    	$("#deg_"+theId).hide();
    	city.hide();
    	cityspan.show();
    }
    
    function hideLoading(theId){
    	var weatherContainer = $("#weatherContainer_"+theId);
    	var city = $("#weathercity_"+theId);
    	var cityspan = $("#weathercity_"+theId+"_span");
    	
    	var bot = $(".bot",weatherContainer);
    	bot.css("height","");
    	$(".bot li img",weatherContainer).show();
    	$(".bot li p",weatherContainer).show();
    	
    	$("#deg_"+theId).show();
    	city.show();
    	cityspan.hide();
    }
	
	function woeidDownloaded(data,theId) {
	    var woeid = null;
	    if (data.query.count <= 0) {
	        $("#weathercity_"+theId).val("No city found");
	        $("#deg_"+theId).html("");
	        setImage(999, $("#big_"+theId)[0]);
	        for (var i = 0; i <= 3; i++) {
	            $('#forecast' + i+"_"+theId).html("");
	            setImage(999, $("#forecastimg" + i+"_"+theId)[0]);
	            $('#forecastdeg' + i+"_"+theId).html("");
	        }
	        return;
	    } else if (data.query.count == 1) {
	        woeid = data.query.results.Result.woeid;
	    } else {
	        woeid = data.query.results.Result[0].woeid;
	    }
	    getWeatherInfo(woeid,theId);
	}
	
	function getWeatherInfo(woeid,theId) {
	    var weatherYQL = 'select * from weather.forecast where woeid=' + woeid + ' and u = "' + unit + '" &format=json';
	    var jsonURL = baseYahooURL + weatherYQL
	    $.getJSON(jsonURL,function(data){
	    	weaterInfoDownloaded(data,theId);
	    });
	}
	
	function weaterInfoDownloaded(data,theId) {
	    $("#weathercity_"+theId).val(data.query.results.channel.location.city);
	    $("#deg_"+theId).html(data.query.results.channel.item.condition.temp + "°" + unit.toUpperCase());
	    setImage(data.query.results.channel.item.condition.code, $("#big_"+theId)[0]);
	    for (var i = 0; i <= 3; i++) {
	        var fc = data.query.results.channel.item.forecast[i];
	        $('#forecast' + i+"_"+theId).html(fc.day);
	        setImage(fc.code, $("#forecastimg" + i+"_"+theId)[0]);
	        $('#forecastdeg' + i+"_"+theId).html((parseInt(fc.low) + parseInt(fc.high)) / 2 + " °" + unit.toUpperCase());
	    }
	    $("#weatherContainer_"+theId).find(".bot img").css("visibility","visible");
	    hideLoading(theId);
	}
	
	function setImage(code, image) {
	    image.src = "/mobilemode/images/weathericon/";
	    switch (parseInt(code)) {
	        case 0:
	            image.src += "Tornado.png"
	            break;
	        case 1:
	            image.src += "Cloud-Lightning.png"
	            break;
	        case 2:
	            image.src += "Wind.png"
	            break;
	        case 3:
	            image.src += "Cloud-Lightning.png"
	            break;
	        case 4:
	            image.src += "Cloud-Lightning.png"
	            break;
	        case 5:
	            image.src += "Cloud-Snow-Alt.png"
	            break;
	        case 6:
	            image.src += "Cloud-Rain-Alt.png"
	            break;
	        case 7:
	            image.src += "Cloud-Snow-Alt.png"
	            break;
	        case 8:
	            image.src += "Cloud-Drizzle-Alt.png"
	            break;
	        case 9:
	            image.src += "Cloud-Drizzle-Alt.png"
	            break;
	        case 10:
	            image.src += "Cloud-Drizzle-Alt.png"
	            break;
	        case 11:
	            image.src += "Cloud-Drizzle-Alt.png"
	            break;
	        case 12:
	            image.src += "Cloud-Drizzle-Alt.png"
	            break;
	        case 13:
	            image.src += "Cloud-Snow-Alt.png"
	            break;
	        case 14:
	            image.src += "Cloud-Snow-Alt.png"
	            break;
	        case 15:
	            image.src += "Cloud-Snow-Alt.png"
	            break;
	        case 16:
	            image.src += "Cloud-Snow-Alt.png"
	            break;
	        case 17:
	            image.src += "Cloud-Hail-Alt.png"
	            break;
	        case 18:
	            image.src += "Cloud-Hail-Alt.png"
	            break;
	        case 19:
	            image.src += "Cloud-Hail-Alt.png"
	            break;
	        case 20:
	            image.src += "Cloud-Fog.png"
	            break;
	        case 21:
	            image.src += "Cloud-Fog.png"
	            break;
	        case 22:
	            image.src += "Cloud-Fog.png"
	            break;
	        case 23:
	            image.src += "Cloud-Fog.png"
	            break;
	        case 24:
	            image.src += "Wind.png"
	            break;
	        case 25:
	            image.src += "Thermometer-Zero.png"
	            break;
	        case 26:
	            image.src += "Cloud.png"
	            break;
	        case 27:
	            image.src += "Cloud-Moon.png"
	            break;
	        case 28:
	            image.src += "Cloud.png"
	            break;
	        case 29:
	            image.src += "Cloud-Moon.png"
	            break;
	        case 30:
	            image.src += "Cloud-Sun.png"
	            break;
	        case 31:
	            image.src += "Moon.png"
	            break;
	        case 32:
	            image.src += "Sun.png"
	            break;
	        case 33:
	            image.src += "Moon.png"
	            break;
	        case 34:
	            image.src += "Sun.png"
	            break;
	        case 35:
	            image.src += "Cloud-Hail-Alt.png"
	            break;
	        case 36:
	            image.src += "Sun.png"
	            break;
	        case 37:
	            image.src += "Cloud-Lightning.png"
	            break;
	        case 38:
	            image.src += "Cloud-Lightning.png"
	            break;
	        case 39:
	            image.src += "Cloud-Lightning.png"
	            break;
	        case 40:
	            image.src += "Cloud-Rain.png"
	            break;
	        case 41:
	            image.src += "Cloud-Snow-Alt.png"
	            break;
	        case 42:
	            image.src += "Cloud-Snow-Alt.png"
	            break;
	        case 43:
	            image.src += "Cloud-Snow-Alt.png"
	            break;
	        case 44:
	            image.src += "Cloud.png"
	            break;
	        case 45:
	            image.src += "Cloud-Lightning.png"
	            break;
	        case 46:
	            image.src += "Cloud-Snow-Alt.png"
	            break;
	        case 47:
	            image.src += "Cloud-Lightning.png"
	            break;
	        case 3200:
	            image.src += "Moon-New.png"
	            break;
	        case 999:
	            image.src += "Compass.png"
	            break;
	        default:
	            image.src += "Moon-New.png"
	            break;
	    }
	}
}

