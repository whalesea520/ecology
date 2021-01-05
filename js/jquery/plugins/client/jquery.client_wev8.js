(function() {
	
	var BrowserDetect = {
		init: function () {
			this.browser = this.searchString(this.dataBrowser) || "An unknown browser";
			this.version = this.searchVersion(navigator.userAgent)
				|| this.searchVersion(navigator.appVersion)
				|| "an unknown version";
			this.OS = this.searchString(this.dataOS) || "an unknown OS";
		},
		searchString: function (data) {
			for (var i=0;i<data.length;i++)	{
				var dataString = data[i].string;
				var dataProp = data[i].prop;
				this.versionSearchString = data[i].versionSearch || data[i].identity;
				if (dataString) {
					if (dataString.indexOf(data[i].subString) != -1)
						return data[i].identity;
				}
				else if (dataProp)
					return data[i].identity;
			}
		},
		searchVersion: function (dataString) {
			var index = dataString.indexOf(this.versionSearchString);
			if (index == -1) return;
			return parseFloat(dataString.substring(index+this.versionSearchString.length+1));
		},
		getOsVersion:function(){
			return this.version;
		},
		getBrowserVersion:function() {
			var browserInfo = {browser:"", version: ""};
			var ua = navigator.userAgent.toLowerCase(); 
			if (window.ActiveXObject) {
			    browserInfo.browser = "IE";
			    browserInfo.version = ua.match(/msie ([\d.]+)/)[1];
			} else if (document.getBoxObjectFor) { 
			    browserInfo.browser = "FF";
			    browserInfo.version = ua.match(/firefox\/([\d.]+)/)[1];
			} else if (/chrome/i.test(ua) && /webkit/i.test(ua) && /mozilla/i.test(ua)) {  //window.MessageEvent && !document.getBoxObjectFor) {
			    browserInfo.browser = "Chrome";
			    browserInfo.version = ua.match(/chrome\/([\d.]+)/)[1];
			} else if (/webkit/i.test(ua) && !(/chrome/i.test(ua) && /webkit/i.test(ua) && /mozilla/i.test(ua))) {
			    browserInfo.browser = "Safari";
			    browserInfo.version = ua.match(/version\/([\d.]+)/)[1];
			} else if (window.opera) { 
			    browserInfo.browser = "Opera";
			    browserInfo.version = ua.match(/opera.([\d.]+)/)[1];
			} else if (window.openDatabase) { 
			    browserInfo.browser = "";
			    browserInfo.version = ua.match(/version\/([\d.]+)/)[1]; 
			}
			return browserInfo;
		},
		dataBrowser: [
			{
				string: navigator.userAgent,
				subString: "Chrome",
				identity: "Chrome"
			},
			{ 	string: navigator.userAgent,
				subString: "OmniWeb",
				versionSearch: "OmniWeb/",
				identity: "OmniWeb"
			},
			{
				string: navigator.vendor,
				subString: "Apple",
				identity: "Safari",
				versionSearch: "Windows NT"
			},
			{
				prop: window.opera,
				identity: "Opera"
			},
			{
				string: navigator.vendor,
				subString: "iCab",
				identity: "iCab"
			},
			{
				string: navigator.vendor,
				subString: "KDE",
				identity: "Konqueror"
			},
			{
				string: navigator.userAgent,
				subString: "Firefox",
				identity: "Firefox"
			},
			{
				string: navigator.vendor,
				subString: "Camino",
				identity: "Camino"
			},
			{		// for newer Netscapes (6+)
				string: navigator.userAgent,
				subString: "Netscape",
				identity: "Netscape"
			},
			{
				string: navigator.userAgent,
				subString: "MSIE",
				identity: "Explorer",
				versionSearch: "Windows NT"
			},
			{
				string: navigator.userAgent,
				subString: "Gecko",
				identity: "Mozilla",
				versionSearch: "Windows NT "
			},
			{ 		// for older Netscapes (4-)
				string: navigator.userAgent,
				subString: "Mozilla",
				identity: "Netscape",
				versionSearch: "Windows NT "
			}
		],
		dataOS : [
			{
				string: navigator.platform,
				subString: "Win",
				identity: "Windows"
			},
			{
				string: navigator.platform,
				subString: "Mac",
				identity: "Mac"
			},
			{
				string: navigator.userAgent,
				subString: "iPhone",
				identity: "iPhone/iPod"
		    },
		    {
				string: navigator.userAgent,
				subString: "iPad",
				identity: "iPad"
		    },
		    {
				string: navigator.userAgent,
				subString: "Android",
				identity: "Android"
		    },
			{
				string: navigator.platform,
				subString: "Linux",
				identity: "Linux"
			}
		]
	
	};
	
	BrowserDetect.init();
	
	window.jQuery.client = { os : BrowserDetect.OS, browser : BrowserDetect.browser ,version: BrowserDetect.version,getOsVersion:BrowserDetect.getOsVersion, browserVersion:BrowserDetect.getBrowserVersion()};
	
})();