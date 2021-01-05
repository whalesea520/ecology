<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="weaver.hrm.*" %>
<%
User user = HrmUserVarify.getUser (request , response) ;
%>
<!DOCTYPE HTML>
<html>
    <head>
        <meta http-equiv="cache-control" content="max-age">
        <meta http-equiv="expires" content="0">
        <title>查看图片</title>
        
        <script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
        <!-- 图片浏览处理库 -->
        <script src="/social/js/drageasy/drageasy.js"></script>
        <script type="text/javascript" src="/social/js/bootstrap/js/bootstrap.js"></script>
        <script type="text/javascript" src="/social/im/js/IMUtil_wev8.js"></script>
        <script type="text/javascript" src="/social/js/imcarousel/imcarousel.js"></script>
        
        <style type="text/css">
            .can-drag {
            	-webkit-app-region: drag;
            }
            .no-drag {
                -webkit-app-region: no-drag;
            }
            body{
                overflow: hidden;
            }
        </style>
    </head>
    <body>
        <!-- 文件下载 -->
        <iframe id="downloadFrame" style="display: none"></iframe>
        
        
        <script>
        	from = 'pc';
        	var languageid = '<%=user.getLanguage()%>';
            $(function() {
                window.Electron.ipcRenderer.on('plugin-imageView-htmlFile', function(event, args){
                    if(args && args != 'null') {
                        var win = window.Electron.currentWindow;
                        var userHost = window.Electron.ipcRenderer.sendSync('global-getHost');
                        $body = $('body');
                        var sizeArr = win.getSize();
                        $body.css('width', sizeArr[0]).css('height', sizeArr[1]);
                        var imgIndex = args.imgIndex, imgSrc;
                        for(var i = 0; i < args.imgSrcArray.length; i++) {
                        	imgSrc = args.imgSrcArray[i];
                        	if(imgSrc.indexOf("/") !== 0 && imgSrc.indexOf("data:") === 0) {
                        		continue;
                        	}
                            args.imgSrcArray[i] = userHost + imgSrc;
                        }
                        
                        var handlers = {
                            onImgLoad : function(){
                                $('.pcDragArea').addClass('can-drag');
                                $('.miniClose').addClass('no-drag');
                                $('#myCarousel').addClass('no-drag');
                                
                            },
                            onContainerLoad: function(){
                                //修复某些win10电脑无法打开图片的bug
                                if(!win.isFocused()){
                                    win.minimize();
                                    win.show();
                                }
                            	
                            },
                            languageid: languageid
                        };
                        IMCarousel.showImgScanner4Pool(true, args.imgSrcArray, imgIndex, null, null, handlers);
                    }
                });
            });
            
            function downloadImg(obj){
                IMCarousel.downloadImg(obj);
            }
            
            //下载附件
            function downloads(fileid){
            	$("#downloadFrame").attr("src","/weaver/weaver.file.FileDownload?fileid="+fileid+"&download=1");
            }
            
            function copyPcImg(dataURL){
			  	if(window.Electron) {
			  		copyImgElectron(dataURL);
			  	}
			  	// HERE TO ADD XP 
			  	
			  	function copyImgElectron(dataURL){
				  	const nativeImage = window.Electron.remote.nativeImage;
				    console.info(dataURL);
				    var oReq = new XMLHttpRequest();
					oReq.open("GET", dataURL, true);
					oReq.responseType = "arraybuffer";
					oReq.onload = function (oEvent) {
						var arraybuffer = oReq.response;  
						if (arraybuffer) {
							var byteArray = new Uint8Array(arraybuffer);
							var clipboard = window.Electron.remote.clipboard;
							var nImg = nativeImage.createFromBuffer(new Buffer(byteArray));
							clipboard.writeImage(nImg);
						}
				    }
				    oReq.send();
				  }
			  }
            
            //图片全屏预览
            var ImageReviewForPc = {
                show : function(imgIndex, imgSrcArray){
                    window.Electron.ipcRenderer.send('plugin-imageView-show', { imgIndex: imgIndex, imgSrcArray: imgSrcArray });
                },
                close: function(){
                    window.Electron.ipcRenderer.send('plugin-imageView-close');
                }
            };
        </script>
    </body>
</html>
