/*
 * Loading css file dynamicly when need to batch css attribute after dom loaded.
 * 2015-10-26 wb 
 */
var dynamicLoading = {
	    css: function(path) {
			if(!path || path.length === 0){
				throw new Error('argument "path" is required !');
			}
			var head = document.getElementsByTagName('head')[0];
	        var link = document.createElement('link');
	        link.href = path;
	        link.rel = 'stylesheet';
	        link.type = 'text/css';
	        head.appendChild(link);
	 	}
	}