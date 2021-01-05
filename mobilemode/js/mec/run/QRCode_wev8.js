if(typeof(Mobile_NS) == 'undefined'){
	Mobile_NS = {};
}

Mobile_NS.initQRCode = function(p){
	var theId = p["id"];
	var content = p["content"];
	var $qrcodeContainer = $("#qrcode" + theId);
	if(!content || content == ""){
		var htm = "<div class=\"Design_QCCode_Tip\">需设置二维码的内容以生成二维码</div>";
		$qrcodeContainer.html(htm);
	}else{
		$qrcodeContainer.find("*").remove();
		
		$qrcodeContainer.qrcode({  
			render : "canvas",    //设置渲染方式，有table和canvas，使用canvas方式渲染性能相对来说比较好  
            text : content,    
            width : p["width"],               //二维码的宽度  
            height : p["height"],              //二维码的高度  
            src: p["logo"],             //二维码中间的图片  
            imgWidth: p["logoWidth"],       //二维码图片的宽度
            imgHeight : p["logoHeight"]        //二维码图片的高度
		});  
	}
}