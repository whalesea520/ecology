var LS=function(e){function t(r){if(n[r])return n[r].exports;var o=n[r]={exports:{},id:r,loaded:!1};return e[r].call(o.exports,o,o.exports,t),o.loaded=!0,o.exports}var n={};return t.m=e,t.c=n,t.p="",t(0)}([function(e,t,n){"use strict";function r(e){return e&&e.__esModule?e:{"default":e}}var o=n(1),i=r(o),s=window.LS||{};s.load=function(){function e(e){var i=e.arr[e.index];if(window.localStorage){var s=window.localStorage.getItem(i.name+i.type+i.url),a=window.localStorage.getItem(i.name+i.type+i.url+"?v");o||null==s||0==s.length||a!==i.version?r(e):(e.arr[e.index].text=s,t(e))}else n(e)}function t(t){var n,r=t.arr[t.index],o=document.head||document.getElementsByTagName("head")[0]||document.documentElement.firstElementChild,i=document.body||document.getElementsByTagName("body")[0];if("css"==r.type?(n=document.createElement("style"),n.type="text/css",n.innerHTML=r.text,o.appendChild(n)):"js"==r.type&&(n=document.createElement("script"),n.charset="utf-8",n.type="text/javascript",n.innerHTML=r.text,r.inHead&&"true"==r.inHead?o.appendChild(n):i.appendChild(n)),"fastclick"==r.name&&FastClick.attach(document.body),t.index<t.arr.length-1){var s=t.index;t.index=s+1,e(t)}}function n(e){var t,r=e.arr[e.index],o=document.head||document.getElementsByTagName("head")[0]||document.documentElement.firstElementChild,i=document.body||document.getElementsByTagName("body")[0];if("css"==r.type?(t=document.createElement("link"),t.rel="stylesheet",t.type="text/css",t.href=r.url,o.appendChild(t)):"js"==r.type&&(t=document.createElement("script"),t.charset="utf-8",t.type="text/javascript",t.src=r.url,r.inHead&&"true"==r.inHead?o.appendChild(t):i.appendChild(t)),e.index<e.arr.length-1){var s=e.index;e.index=s+1,n(e)}}function r(n){var r=n.arr[n.index],o=r.url+"?"+Math.random();fetch(o,{method:"get",mode:"no-cors",headers:{"Content-Type":"application/x-www-form-urlencoded;charset=utf-8","Cache-Control":"no-cache",Pragma:"no-cache",Expires:"0"},credentials:"include"}).then(function(e){if(e.ok)return e.text()}).then(function(o){if(o)n.arr[n.index].text=o,window.localStorage.setItem(r.name+r.type+r.url,n.arr[n.index].text),window.localStorage.setItem(r.name+r.type+r.url+"?v",r.version),t(n);else if(console.log("服务器繁忙，请稍后再试"),n.index<n.arr.length-1){var i=n.index;n.index=i+1,e(n)}})["catch"](function(e){console.log(e)})}var o=!1,s=function(){var t=[],n={arr:arguments[0]?t.concat(arguments[0]):t,index:0};o=!!arguments[1],e(n)};return s}(),e.exports=s},function(e,t){!function(){"use strict";function e(e){if("string"!=typeof e&&(e=e.toString()),/[^a-z0-9\-#$%&'*+.\^_`|~]/i.test(e))throw new TypeError("Invalid character in header field name");return e.toLowerCase()}function t(e){return"string"!=typeof e&&(e=e.toString()),e}function n(e){this.map={};var t=this;e instanceof n?e.forEach(function(e,n){n.forEach(function(n){t.append(e,n)})}):e&&Object.getOwnPropertyNames(e).forEach(function(n){t.append(n,e[n])})}function r(e){return e.bodyUsed?fetch.Promise.reject(new TypeError("Already read")):void(e.bodyUsed=!0)}function o(e){return new fetch.Promise(function(t,n){e.onload=function(){t(e.result)},e.onerror=function(){n(e.error)}})}function i(e){var t=new FileReader;return t.readAsArrayBuffer(e),o(t)}function s(e){var t=new FileReader;return t.readAsText(e),o(t)}function a(){return this.bodyUsed=!1,this._initBody=function(e){if(this._bodyInit=e,"string"==typeof e)this._bodyText=e;else if(p.blob&&Blob.prototype.isPrototypeOf(e))this._bodyBlob=e;else if(p.formData&&FormData.prototype.isPrototypeOf(e))this._bodyFormData=e;else{if(e)throw new Error("unsupported BodyInit type");this._bodyText=""}},p.blob?(this.blob=function(){var e=r(this);if(e)return e;if(this._bodyBlob)return fetch.Promise.resolve(this._bodyBlob);if(this._bodyFormData)throw new Error("could not read FormData body as blob");return fetch.Promise.resolve(new Blob([this._bodyText]))},this.arrayBuffer=function(){return this.blob().then(i)},this.text=function(){var e=r(this);if(e)return e;if(this._bodyBlob)return s(this._bodyBlob);if(this._bodyFormData)throw new Error("could not read FormData body as text");return fetch.Promise.resolve(this._bodyText)}):this.text=function(){var e=r(this);return e?e:fetch.Promise.resolve(this._bodyText)},p.formData&&(this.formData=function(){return this.text().then(c)}),this.json=function(){return this.text().then(function(e){return JSON.parse(e)})},this}function d(e){var t=e.toUpperCase();return m.indexOf(t)>-1?t:e}function u(e,t){if(t=t||{},this.url=e,this.credentials=t.credentials||"omit",this.headers=new n(t.headers),this.method=d(t.method||"GET"),this.mode=t.mode||null,this.referrer=null,("GET"===this.method||"HEAD"===this.method)&&t.body)throw new TypeError("Body not allowed for GET or HEAD requests");this._initBody(t.body)}function c(e){var t=new FormData;return e.trim().split("&").forEach(function(e){if(e){var n=e.split("="),r=n.shift().replace(/\+/g," "),o=n.join("=").replace(/\+/g," ");t.append(decodeURIComponent(r),decodeURIComponent(o))}}),t}function l(e){var t=new n,r=e.getAllResponseHeaders().trim().split("\n");return r.forEach(function(e){var n=e.trim().split(":"),r=n.shift().trim(),o=n.join(":").trim();t.append(r,o)}),t}function f(){return y&&!/^(get|post|head|put|delete|options)$/i.test(this.method)?(this.usingActiveXhr=!0,new ActiveXObject("Microsoft.XMLHTTP")):new XMLHttpRequest}function h(e,t){t||(t={}),this._initBody(e),this.type="default",this.url=null,this.status=t.status,this.ok=this.status>=200&&this.status<300,this.statusText=t.statusText,this.headers=t.headers instanceof n?t.headers:new n(t.headers),this.url=t.url||""}if(!self.fetch){n.prototype.append=function(n,r){n=e(n),r=t(r);var o=this.map[n];o||(o=[],this.map[n]=o),o.push(r)},n.prototype["delete"]=function(t){delete this.map[e(t)]},n.prototype.get=function(t){var n=this.map[e(t)];return n?n[0]:null},n.prototype.getAll=function(t){return this.map[e(t)]||[]},n.prototype.has=function(t){return this.map.hasOwnProperty(e(t))},n.prototype.set=function(n,r){this.map[e(n)]=[t(r)]},n.prototype.forEach=function(e){var t=this;Object.getOwnPropertyNames(this.map).forEach(function(n){e(n,t.map[n])})};var p={blob:"FileReader"in self&&"Blob"in self&&function(){try{return new Blob,!0}catch(e){return!1}}(),formData:"FormData"in self},m=["DELETE","GET","HEAD","OPTIONS","POST","PUT"],y=!("undefined"==typeof window||!window.ActiveXObject||window.XMLHttpRequest&&(new XMLHttpRequest).dispatchEvent);a.call(u.prototype),a.call(h.prototype),self.Headers=n,self.Request=u,self.Response=h,self.fetch=function(e,t){var n;return n=u.prototype.isPrototypeOf(e)&&!t?e:new u(e,t),new fetch.Promise(function(e,t){function r(){return"responseURL"in i?i.responseURL:/^X-Request-URL:/m.test(i.getAllResponseHeaders())?i.getResponseHeader("X-Request-URL"):void 0}function o(){if(4===i.readyState){var n=1223===i.status?204:i.status;if(n<100||n>599)return void t(new TypeError("Network request failed"));var o={status:n,statusText:i.statusText,headers:l(i),url:r()},s="response"in i?i.response:i.responseText;e(new h(s,o))}}var i=f();"cors"===n.credentials&&(i.withCredentials=!0),i.onreadystatechange=o,self.usingActiveXhr||(i.onload=o,i.onerror=function(){t(new TypeError("Network request failed"))}),i.open(n.method,n.url,!0),"responseType"in i&&p.blob&&(i.responseType="blob"),n.headers.forEach(function(e,t){t.forEach(function(t){i.setRequestHeader(e,t)})}),i.send("undefined"==typeof n._bodyInit?null:n._bodyInit)})},fetch.Promise=self.Promise,self.fetch.polyfill=!0}}()}]);