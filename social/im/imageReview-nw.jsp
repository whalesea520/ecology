<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
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

            body {
                overflow: hidden;
            }
        </style>
    </head>

    <body>
        <!-- 文件下载 -->
        <iframe id="downloadFrame" style="display: none"></iframe>
        <script>
            from = 'pc';
            var imggui = window.require('nw.gui');
            var imgnode_path = window.require('path');
            var imgGLOBAL_INFOS = imggui.global.GLOBAL_INFOS;
            var imgDialog = window.require('nw-dialog');
            imgDialog.setContext(document.getElementById("downloadFrame").contentWindow.document);
            function pluginImageViewHtmlFile(data) {
                    if (data && data != 'null') {
                        var win = imggui.Window.get();
                        var userHost = imgGLOBAL_INFOS.currentHost;
                        $body = $('body');
                        $body.css('width', win.width).css('height', win.height);
                        var imgIndex = data.imgIndex;
                        for (var i = 0; i < data.imgSrcArray.length; i++) {
                            imgSrc = data.imgSrcArray[i];
                            if (imgSrc.indexOf("/") !== 0 && imgSrc.indexOf("data:") === 0) {
                                continue;
                            }
                            imgSrc = userHost + imgSrc;
                            imgSrc = imgSrc.substring(imgSrc.lastIndexOf(userHost), imgSrc.length);
                            data.imgSrcArray[i] = imgSrc;
                        }
                        var handlers = {
                            onImgLoad: function () {
                                $('.pcDragArea').addClass('can-drag');
                                $('.miniClose').addClass('no-drag');
                                $('#myCarousel').addClass('no-drag');

                            },
                            onContainerLoad: function () {
                                win.show();
                            }
                        };
                        IMCarousel.showImgScanner4Pool(true, data.imgSrcArray, imgIndex, null, null, handlers);
                    }
                };
            function downloadImg(obj) {
                IMCarousel.downloadImg(obj);
            }
            //下载附件
            function downloads(fileid) {
                var downUrl = imggui.global.GLOBAL_INFOS.currentHost + "/weaver/weaver.file.FileDownload?fileid=" + fileid + "&download=1";
                if (window.opener.PcDownloadUtils.DownloadItems[downUrl]) {
                    alert('该文件正在下载');
                    return;
                }
                var date = new Date();
                var str = date.getTime();
                imgDialog.saveFileDialog(str + '.jpg', '.jpg', function (filepn) {
                    if (filepn) {
                        var dlObj = {
                            url: downUrl,
                            filePath: filepn,
                            ext: '.jpg'
                        };
                        window.opener.PcDownloadUtils.creatNewDownload(dlObj);
                        window.opener.PcDownloadUtils.DownloadItems[downUrl] = true;
                    }
                });

            }
            // 复制图片
            function copyPcImg(dataURL){
			  	if(window.nw) {
			  		copyImgNw(dataURL);
			  	}
			  	 function copyImgNw(dataURL){
				  	var oReq = new XMLHttpRequest();
					oReq.open("GET", dataURL, true);
					oReq.responseType = "blob";
					oReq.onload = function (oEvent) {
						var blob = oReq.response;  
						if (blob) {
							var reader = new FileReader();
							var base64Data = "";
							reader.addEventListener("load", function () {
							    base64Data = reader.result;
							    if(base64Data){
									try{
										var nwgui = window.require('nw.gui');
										var clipboard = nwgui.Clipboard.get();
										var type='png';
										if(base64Data.indexOf('jpg') != -1) {
											base64Data = base64Data.replace(/data:image\/jpg;/, "data:image/jpeg;");
										}
										if(base64Data.indexOf('jpeg') != -1) {
											type="jpeg";
										}
										clipboard.set(base64Data, type);
									}catch(e) {}
								}
							  }, false);
							  
							reader.readAsDataURL(blob);
						}
				    }
				    oReq.send();
				  }
			  }
             //图片全屏预览
            var ImageReviewForPc = {
                close: function(){	               
                    imggui.Window.get().close();
                }
            };
        </script>
    </body>
</html>
