Ext.lib.Ajax._queue=[];Ext.lib.Ajax._activeRequests=0;Ext.lib.Ajax.abort=function(d,e,b){if(this.isCallInProgress(d)){d.conn.abort();window.clearInterval(this.poll[d.tId]);delete this.poll[d.tId];if(b){delete this.timeout[d.tId]}this.handleTransactionResponse(d,e,true);return true}else{for(var c=0,a=this._queue.length;c<a;c++){if(this._queue[c].o.tId==d.tId){this._queue.splice(c,1);break}}return false}};Ext.lib.Ajax.asyncRequest=function(e,b,d,a){var c=this.getConnectionObject();if(!c){return null}else{this._queue.push({o:c,method:e,uri:b,callback:d,postData:a});this._processQueue();return c}};Ext.lib.Ajax._processQueue=function(){var a=this._queue[0];if(a&&this._activeRequests<2){a=this._queue.shift();this._asyncRequest(a.o,a.method,a.uri,a.callback,a.postData)}};Ext.lib.Ajax._asyncRequest=function(c,e,b,d,a){this._activeRequests++;c.conn.open(e,b,true);if(this.useDefaultXhrHeader){if(!this.defaultHeaders["X-Requested-With"]){this.initHeader("X-Requested-With",this.defaultXhrHeader,true)}}if(a&&this.useDefaultHeader){this.initHeader("Content-Type",this.defaultPostHeader)}if(this.hasDefaultHeaders||this.hasHeaders){this.setHeader(c)}this.handleReadyState(c,d);c.conn.send(a||null)};Ext.lib.Ajax.releaseObject=function(a){a.conn=null;a=null;this._activeRequests--;this._processQueue()};