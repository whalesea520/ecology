<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util"%>
<%@page import="com.weaver.formmodel.util.NumberHelper"%>
<%@page import="com.weaver.formmodel.util.StringHelper"%>
<%@page import="java.util.zip.ZipEntry"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="java.io.BufferedInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.util.zip.ZipInputStream"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.file.AESCoder"%>
<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="com.sun.image.codec.jpeg.JPEGCodec"%>
<%@page import="com.sun.image.codec.jpeg.JPEGImageDecoder"%>
<%@page import="java.io.ByteArrayInputStream"%>
<%@page import="java.io.ByteArrayOutputStream"%>
<%
	String imgSrc = Util.null2String(request.getParameter("imgSrc")).trim();
	String imgSrcActive = Util.null2String(request.getParameter("imgSrcActive")).trim();
	if("".equals(imgSrc)){
		return;
	}
	
	int imgIndexActive = 0;
	JSONArray items = new JSONArray();
	String[] imgArr = imgSrc.split("\\|");
	for(int imgIdx = 0; imgIdx < imgArr.length; imgIdx++){
		String imgPath = imgArr[imgIdx];

		if(imgPath.equals(imgSrcActive)){
		   imgIndexActive = imgIdx;
		}

		String fileid = "";

		boolean isID = false;
		int sIndex;
		if((sIndex = imgPath.indexOf("/weaver/weaver.file.FileDownload?fileid=")) != -1){
			int eIndex = imgPath.indexOf("&", sIndex);
			if(eIndex == -1){
				eIndex = imgPath.length();
			}
			fileid = imgPath.substring(sIndex + "/weaver/weaver.file.FileDownload?fileid=".length(), eIndex);
			isID = true;
		}else if(imgPath.matches("^[-+]?(([0-9]+)([.]([0-9]+))?|([.]([0-9]+))?)$")){
			fileid = imgPath;
			imgPath = "/weaver/weaver.file.FileDownload?fileid=" + fileid;
			isID = true;
		}
		boolean isUrl = !isID && !imgPath.equals("");
		
		InputStream inStream = null;
		String imagefiletype = "";
		if(isID){
			String sql = "select t1.imagefilename,t1.filerealpath,t1.iszip,t1.isencrypt,t1.imagefiletype , t1.imagefileid, t1.imagefile,t1.isaesencrypt,t1.aescode,t2.imagefilename as realname,t1.TokenKey,t1.StorageStatus,t1.comefrom,t1.fileSize as filesize from ImageFile t1 left join DocImageFile t2 on t1.imagefileid = t2.imagefileid where t1.imagefileid = "+fileid;
			RecordSet rs = new RecordSet();
			rs.execute(sql);
			if(rs.next()){
				String filerealpath = Util.null2String(rs.getString("filerealpath"));
				String iszip = Util.null2String(rs.getString("iszip"));
				String isaesencrypt = Util.null2o(rs.getString("isaesencrypt"));
				String aescode = Util.null2String(rs.getString("aescode"));
				imagefiletype = Util.null2String(rs.getString("imagefiletype"));
				
				ZipInputStream zin = null;
				File thefile = new File(filerealpath);
				if (iszip.equals("1")) {
					zin = new ZipInputStream(new FileInputStream(thefile));
					if (zin.getNextEntry() != null) inStream = new BufferedInputStream(zin);
					
				} else{
					inStream = new BufferedInputStream(new FileInputStream(thefile));
					
				}
				
				if(isaesencrypt.equals("1")){
					inStream = AESCoder.decrypt(inStream, aescode); 
				}
				
			}
		}else if(isUrl){
			String realPath = request.getSession().getServletContext().getRealPath(imgPath);
			File file = new File(realPath);
			if(!file.exists() || !file.isFile()){
				return;
			}
			inStream = new BufferedInputStream(new FileInputStream(file));
		}
		
		/*使用ByteArrayOutputStream读取inStream,相当于缓存复制一份inStream。下面用的时候不能因为try中的代码干扰catch中的代码*/
		ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
		byte[] buffer = new byte[1024];
		int len;
		while ((len = inStream.read(buffer)) > -1 ) {
			byteArrayOutputStream.write(buffer, 0, len);
		}
		byteArrayOutputStream.flush();	  

		BufferedImage inputBufImage = null;
		try{
			inputBufImage = ImageIO.read(new ByteArrayInputStream(byteArrayOutputStream.toByteArray()));
		}catch(Exception ex){
			JPEGImageDecoder decoder = JPEGCodec.createJPEGDecoder(new ByteArrayInputStream(byteArrayOutputStream.toByteArray()));
			inputBufImage = decoder.decodeAsBufferedImage();
		}
		
		int width = inputBufImage.getWidth();
		int height = inputBufImage.getHeight();
		
		JSONObject item = new JSONObject();
		item.put("src", imgPath);
		item.put("w", width);
		item.put("h", height);

		items.add(item);
	}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes, minimum-scale=1.0, maximum-scale=1.0">
<link rel="stylesheet" href="/mobilemode/js/photoSwipe/css/photoswipe_wev8.css"> 
<link rel="stylesheet" href="/mobilemode/js/photoSwipe/css/default-skin/default-skin_wev8.css"> 
<script src="/mobilemode/js/photoSwipe/js/photoswipe.min_wev8.js"></script> 
<script src="/mobilemode/js/photoSwipe/js/photoswipe-ui-default.min_wev8.js"></script> 
<script src="/mobilemode/js/zepto/zepto.min_wev8.js"></script> 
<script src="/mobilemode/js/hammer/hammer.min_wev8.js"></script> 
<style type="text/css">
html,body{
	margin: 0px;
	padding: 0px;
	background-color: #000;
}
.my-gallery {
  width: 100%;
  float: left;
}
.my-gallery img {
  width: 100%;
  height: auto;
}
.my-gallery figure {
  display: block;
  float: left;
  margin: 0 5px 5px 0;
  width: 150px;
}
.my-gallery figcaption {
  display: none;
}
.pswp__button--close{
  background: url(/mobilemode/js/photoSwipe/css/default-skin/default-skin_wev8.png) no-repeat;
  background-size: 20px 20px;
  width: 44px;
  height: 44px;
  background-position: 10px center;
  position: relative;
  cursor: pointer;
  float: left;
  -webkit-appearance: none;
  display: block;
  border: 0;
  padding: 0;
  margin: 0;
   -webkit-transition: opacity 0.2s;
          transition: opacity 0.2s;
  -webkit-box-shadow: none;
          box-shadow: none;
}
</style>
</head>
<body>
<div class="pswp" tabindex="-1" role="dialog" aria-hidden="true">
	<div class="pswp__bg"></div>
	<div class="pswp__scroll-wrap">
		<div class="pswp__container">
		  <div class="pswp__item"></div>
		  <div class="pswp__item"></div>
		  <div class="pswp__item"></div>
		</div>
    	
    	<div class="pswp__ui pswp__ui--hidden">
        	<div class="pswp__top-bar">
               <button class="pswp__button--close" title="Close (Esc)"></button>
               <div class="pswp__counter"></div>
               <div class="pswp__preloader">
                  <div class="pswp__preloader__icn">
                    <div class="pswp__preloader__cut">
                      <div class="pswp__preloader__donut"></div>
                    </div>
                  </div>
               </div>
       	 	</div>
            <div class="pswp__share-modal pswp__share-modal--hidden pswp__single-tap">
               <div class="pswp__share-tooltip"></div> 
            </div>
            <div class="pswp__caption">
               <div class="pswp__caption__center"></div>
            </div>
      	</div>
     </div>
</div>

<script type="text/javascript">
var cWidth = document.body.clientWidth;
var cHeight= document.body.clientHeight;
var openPhotoSwipe = function() {
    var pswpElement = document.querySelectorAll('.pswp')[0];
    var items = <%=items.toString()%>;
    var imgIndexActive = <%=imgIndexActive%>;
    var options = {
        history : false,
        focus : false,
        showAnimationDuration : 0,
        hideAnimationDuration : 0,
        captionAndToolbarOpacity : 0.1,
		maxSpreadZoom: 4,
        index : imgIndexActive, //显示图片位置
        loop : false  //相册是否自动循环
    };
    var pSwp = new PhotoSwipe( pswpElement, PhotoSwipeUI_Default, items, options);
    pSwp.init();
    //图片加载完成时添加事件
    pSwp.listen('imageLoadComplete', function(index, item) { 
    	pressImgForSave();
    });
};
document.addEventListener('DOMContentLoaded', openPhotoSwipe, false);

function pressImgForSave(){
	if(!(typeof(top.isRunInEmobile) == "function" && top.isRunInEmobile())){
		return;
	}
	$("img").each(function(){
		var $imgEle = $(this);
		var flag = $imgEle.attr("data-press-save-event");
		if(flag == "1"){
			return;
		}
		$imgEle.attr("data-press-save-event", "1");
		var mc = new Hammer($imgEle[0], {
			recognizers: [
	      		[Hammer.Press,{ time : 500 }]
	      	]
		});
	    
		mc.on('press', function(ev) {
			var imgSrc = $(ev.target).attr("src");
			if(imgSrc == null || imgSrc == ""){
				return;
			}
			top.addDialogCover([
	      		{id : "a", menuText : "<div style='text-align: center;margin-left: -18px;font-size: 18px;color: #017afd;'>保存图片</div>", callback : function(){
					location = "emobile:saveImage:"+imgSrc+":111";
	      		}}
	      	]);
		});	
	});
}

function doClose(){
	if(top && typeof(top.doHistoryBack) == "function"){
		top.doHistoryBack();
	}
}
</script>

</body>
</html>