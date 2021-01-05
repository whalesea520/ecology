var RongIMClient;
(function(RongIMClient) {
	var RongIMVoice = (function() {
		function RongIMVoice() {}
		RongIMVoice.init = function() {
			if (this.isIE) {
				var div = document.createElement("div");
				div.setAttribute("id", "flashContent");
				document.body.appendChild(div);
				var script = document.createElement("script");
				script.src = window.RongOpts["VOICE_SWFOBJECT"];
				var header = document.getElementsByTagName("head")[0];
				header.appendChild(script);
				setTimeout(function() {
					var swfVersionStr = "11.4.0";
					var flashvars = {};
					var params = {};
					params.quality = "high";
					params.bgcolor = "#ffffff";
					params.allowscriptaccess = "always";
					params.allowScriptAccess = "always";
					params.allowfullscreen = "true";
					var attributes = {};
					attributes.id = "player";
					attributes.name = "player";
					attributes.align = "middle";
					swfobject.embedSWF(window.RongOpts["VOICE_PLAY_SWF"], "flashContent", "1", "1", swfVersionStr, null, flashvars, params, attributes)
				}, 500)
			} else {
				var list = [window.RongOpts["VOICE_PCMDATA"], window.RongOpts["VOICE_LIBAMR"]];
				for (var i = 0, len = list.length; i < len; i++) {
					var script = document.createElement("script");
					script.src = list[i];
					document.head.appendChild(script)
				}
			}
			this.isInit = true
		};
		RongIMVoice.play = function(data, duration) {
			this.checkInit("play");
			var me = this;
			if (me.isIE) {
				me.thisMovie().doAction("init", data)
			} else {
				var key = data.substr(-10);
				if (this.element[key]) {
					this.element[key].play()
				}
				me.onCompleted(duration)
			}
		};
		RongIMVoice.stop = function(base64Data) {
			this.checkInit("stop");
			var me = this;
			if (me.isIE) {
				me.thisMovie().doAction("stop")
			} else {
				var key = base64Data.substr(-10);
				if (me.element[key]) {
					me.element[key].pause()
				}
			}
		};
		RongIMVoice.preLoaded = function(base64Data) {
			var reader = new FileReader(),
				blob = this.base64ToBlob(base64Data, "audio/amr"),
				str = base64Data.substr(-10),
				me = this;
			reader.onload = function() {
				var samples = new AMR({
					benchmark: true
				}).decode(reader.result);
				var audio = AMR.util.getWave(samples);
				me.element[str] = audio
			};
			reader.readAsBinaryString(blob)
		};
		RongIMVoice.palyVoice = function(base64Data) {
			var reader = new FileReader(),
				blob = this.base64ToBlob(base64Data, "audio/amr"),
				me = this;
			reader.onload = function() {
				var samples = new AMR({
					benchmark: true
				}).decode(reader.result);
				me.element = AMR.util.play(samples)
			};
			reader.readAsBinaryString(blob)
		};
		RongIMVoice.onprogress = function() {};
		RongIMVoice.checkInit = function(position) {
			if (!this.isInit) {
				throw new Error("RongIMVoice is not init,position:" + position)
			}
		};
		RongIMVoice.thisMovie = function() {
			return eval("window['player']")
		};
		RongIMVoice.onCompleted = function(duration) {
			var me = this;
			var count = 0;
			var timer = setInterval(function() {
				me.onprogress(count/duration);
				if (count >= duration) {
					clearInterval(timer)
				}
				count++;
			}, 1000);
			if (me.isIE) {
				me.thisMovie().doAction("play")
			}
		};
		RongIMVoice.base64ToBlob = function(base64Data, type) {
			var mimeType;
			if (type) {
				mimeType = {
					type: type
				}
			}
			base64Data = base64Data.replace(/^(.*)[,]/, "");
			var sliceSize = 1024;
			var byteCharacters = atob(base64Data);
			var bytesLength = byteCharacters.length;
			var slicesCount = Math.ceil(bytesLength / sliceSize);
			var byteArrays = new Array(slicesCount);
			for (var sliceIndex = 0; sliceIndex < slicesCount; ++sliceIndex) {
				var begin = sliceIndex * sliceSize;
				var end = Math.min(begin + sliceSize, bytesLength);
				var bytes = new Array(end - begin);
				for (var offset = begin, i = 0; offset < end; ++i, ++offset) {
					bytes[i] = byteCharacters[offset].charCodeAt(0)
				}
				byteArrays[sliceIndex] = new Uint8Array(bytes)
			}
			return new Blob(byteArrays, mimeType)
		};
		RongIMVoice.isIE = /Trident/.test(navigator.userAgent);
		RongIMVoice.element = {};
		RongIMVoice.isInit = false;
		return RongIMVoice
	})();
	RongIMClient.RongIMVoice = RongIMVoice;
	if ("function" === typeof require && "object" === typeof module && module && module.id && "object" === typeof exports && exports) {
		module.exports = RongIMVoice
	} else {
		if ("function" === typeof define && define.amd) {
			define("RongIMVoice", [], function() {
				return RongIMVoice
			})
		}
	}
})(RongIMClient || (RongIMClient = {}));