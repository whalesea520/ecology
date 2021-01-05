/*Hunk Zeng 2009-4-23*/
;(function($) { 
	$.fn.filetree = function(option) {
		var param = jQuery.extend({			
			file:'none',
			isSingle:'',
			call:null
		}, option);		


		$(this).each(function() {
			var $this = this;
			var fileObj = $(this);
			fileObj.nextAll("img").remove();
			fileObj.addClass("inputstyle");
			//this.scrollLeft+=this.offsetWidth;
			
			fileObj.css({width:'90%'});
			fileObj.keypress(function(e){window.event.keyCode=0;});
			var file=fileObj.val();

			var btn = $(document.createElement('img'));
			btn.attr('src', "/wui/theme/ecology8/skins/default/general/browser_wev8.png");
			btn.attr('disabled', fileObj.attr('disabled'));
			
			btn.css({cursor: 'pointer', padding:'0', margin: '0 0 0 5'});
			fileObj.after(btn);

			//fileObj.hide();
			
			btn.click(function(e){
				var isSingle = param.isSingle;
				var tempFile=param.file;
				var pos=tempFile.indexOf("/page/resource/userfile/");
				if(pos!=-1) tempFile=tempFile.substring(pos+24);
			
				//var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
				//var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
				//alert("/docs/DocBrowserMain.jsp?url=/page/maint/common/UserResourceBrowse.jsp?file="+tempFile)
				var dlg=new window.top.Dialog();//定义Dialog对象
				dlg.currentWindow = window;   
				dlg.Model=true;
				dlg.Width = top.document.body.clientWidth-100;
 				dlg.Height = top.document.body.clientHeight-100;
				
 				
				dlg.URL="/page/maint/common/CustomResourceMaint.jsp?isDialog=1&?file="+tempFile+"&isSingle="+isSingle;
				dlg.callbackfun=function(obj,datas){
					//console.log("============================="+datas);
					if (datas!=null&&datas.id!="false"){
						param.file=datas.id;
						obj.val(datas.id);
						//$($this).next().children("font").html(src);		
						if(param.call!=null){						
							var call=eval(param.call);
							call(datas.id);
						}
					}
				}
				dlg.callbackfunParam=fileObj;
				dlg.show();
				
				//var src = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/page/maint/common/UserResourceBrowse.jsp?file="+tempFile,"","addressbar=no;status=0;dialogHeight=550px;dialogWidth=550px;dialogLeft="+iLeft+";dialogTop="+iTop+";resizable=0;center=1;");
				//src="/images/homepage/imgmode1_wev8.gif";
				//console.log("============================="+src);
				

				//if (src!=null&&src!="false"){
				//	param.file=src;
				//	fileObj.val(src);
				//	//$($this).next().children("font").html(src);		
				//	if(param.call!=null){						
				//		var call=eval(param.call);
				//		call(src);
				//	}
				//}
			});					
		});
	};
})(jQuery);