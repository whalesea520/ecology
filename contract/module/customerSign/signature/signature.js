window.onload=function(){
	//alert(window.location.search);
	var userId = window.location.search.split('=')[1];
	//console.log(userId);
	//设备的高度
	var deviceH = window.screen.height;
	$("#panel_title").css({width:deviceH,top:deviceH/2-21,right:-deviceH/2+19});
	//画布容器
	var conW = $("#panel_content").width();
	var conH = $("#panel_content").height(); 
	//console.log(conW+'----'+conH);
	$("#sign_canvas")[0].width = conW;
	$("#sign_canvas")[0].height = conH;
	//$("#sign_canvas").css();
	$("#panel_bottom").css({width:deviceH,top:deviceH/2-20,left:-deviceH/2+20});
	$("#mask .mask_sure").click(function(){
		$("#mask").hide();
	})
	
   var canvas = document.getElementsByTagName('canvas')[0];
   
   signaturePad = new SignaturePad(canvas);
  var  clearButton = document.getElementById('clear');
   var 	saveButton = document.getElementById('save');

   clearButton.addEventListener("click", function (event) {
		signaturePad.clear();
	});
	//保存为png
	saveButton.addEventListener("click", function (event) {
		if (signaturePad.isEmpty()) {
			//alert("签名不能为空！");
			$("#mask").show();
			$("#mask .mask_info").html("签名不能为空！");
		} else {
			//window.open(signaturePad.toDataURL());
			 var Pic = signaturePad.toDataURL();
			    Pic = Pic.replace(/^data:image\/(png|jpg);base64,/, "")
			   $("#save").attr('disabled',"true").css({background:'gray'});
			    // Sending the image data to Server
			    $.ajax({
			        type: 'POST',
			        url: '/contract/custom/sign.jsp',
			        data: {action:'add',type:'签字',user:userId,imageData: Pic },
			        dataType: 'json',
			        success: function (msg) {
			           // alert("新增签名成功！");
			            $("#mask").show();
						$("#mask .mask_info").html("新增签名成功！");
			            $('#save').removeAttr("disabled").css({background:'#038ef6'});
			        }
			    });
		}
	});
}