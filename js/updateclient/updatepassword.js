$(document).ready(function(){
				/*$("#oldpassword").focus();
				$("#oldpassword").blur(function(){
					$("#message1").html("");
					var password = $.trim($("#oldpassword").val());
					if(password == "") {
						$("#message1").html("密码不能为空！");
						$("#oldpassword").select();
						$("#oldpassword").focus(); 
						return;
					}
					$.ajax({
					   type: "POST",
					   url: "/change.do?date="+(new Date()).valueOf(),
					   data: "oldpassword="+$("#oldpassword").val(),
					   error: function(){
					   	 alert( "Error : 页面出错请重试！");
					   },
					   success: function(message){
					   	 if(message == "error") {
					   	 	$("#message1").html( "密码不正确，请重新输入！" );
					   	 	$("#oldpassword").select();
					   	 	$("#oldpassword").focus();
					   	 	return;
					   	 }
					   	 else if(message == "oldpasswordsuccess") {
					   		$("#message1").html( "<span><img src=\"/img/right.jpg\"></span>" );
					   	 	$("#newpassword").focus();
						   	
						 }
					   }
					});
				});
				$("#newpassword").blur(function(){
					$("#message2").html("");
					var newpassword = $.trim($("#newpassword").val());
					var confirmpassword = $.trim($("#confirmpassword").val());
					if(newpassword == "") {
						$("#message2").html("新密码不能为空！");
						$("#newpassword").select();
						$("#newpassword").focus(); 
						return;
					}
					else if(newpassword.length<3) {
						$("#message2").html("新密码长度小于3个字符！");
						$("#newpassword").select();
						$("#newpassword").focus(); 
						return;
					}
					else if(confirmpassword!=newpassword&&newpassword!=""&&confirmpassword!="") {
						$("#message3").html("新密码与确认密码不一致！");
						//$("#confirmpassword").select();
						//$("#confirmpassword").focus(); 
						return;
					};
					$("#confirmpassword").select();
					$("#confirmpassword").focus();
					
			   	});
			   	$("#confirmpassword").blur(function(){
					var newpassword = $.trim($("#newpassword").val());
					var confirmpassword = $.trim($("#confirmpassword").val());
					if(confirmpassword == "") {
						$("#message3").html("确认密码不能为空！");
						$("#confirmpassword").select();
						$("#confirmpassword").focus();
						return;
					}
					else if(confirmpassword.length<3) {
						$("#message3").html("确认密码长度小于3个字符！");
						$("#confirmpassword").select();
						$("#confirmpassword").focus(); 
						return;
					}
					else if(confirmpassword!=newpassword&&newpassword!=""&&confirmpassword!="") {
						$("#message3").html("新密码与确认密码不一致！");
						//$("#confirmpassword").select();
						//$("#confirmpassword").focus(); 
						return;
					};
				});*/
				$("#ok").click(function(){
					var password = $.trim($("#oldpassword").val());
					var newpassword = $.trim($("#newpassword").val());
					var confirmpassword = $.trim($("#confirmpassword").val());
					if(password == "") {
						$("#message1").html("旧密码不能为空！");
						$("#oldpassword").select();
						$("#oldpassword").focus(); 
						return;
					}
					else
					{
						$("#message1").html("");
					}
					if(newpassword == "") {
						$("#message2").html("新密码不能为空！");
						$("#newpassword").select();
						$("#newpassword").focus(); 
						return;
					}
					else if(newpassword.length<3) {
						$("#message2").html("新密码长度小于3个字符！");
						$("#newpassword").select();
						$("#newpassword").focus(); 
						return;
					}
					else
					{
						$("#message2").html("");
					}
					if(confirmpassword == "") {
						$("#message3").html("确认密码不能为空！");
						$("#confirmpassword").select();
						$("#confirmpassword").focus();
						return;
					}
					else if(confirmpassword.length<3) {
						$("#message3").html("确认密码长度小于3个字符！");
						$("#confirmpassword").select();
						$("#confirmpassword").focus(); 
						return;
					}
					else
					{
						$("#message3").html("");
					}
					if(confirmpassword!=newpassword&&newpassword!=""&&confirmpassword!="") 
					{
						$("#message3").html("新密码与确认密码不一致！");
						return;
					}
					$.ajax({
					   type: "POST",
					   url: "/change.do",
					   data: "oldpassword="+$("#oldpassword").val()+
						   	 "&newpassword="+$("#newpassword").val()+
					   		 "&confirmpassword="+$("#confirmpassword").val(),
					   error: function(){
					   	 alert( "Error : 页面出错请重试！");
					   },
					   success: function(message){
						   if(message == "error") {
						   	 	$("#message1").html( "密码不正确，请重新输入！" );
						   	 	$("#oldpassword").select();
						   	 	$("#oldpassword").focus();
						   	 	return;
						   }
						   else if(message == "success") {
							   alert("修改成功!");
							   top.location.href="/jsp/index.jsp";
						   }
						   else if(message == "wrongfullength") {
							   $("#message2").html("输入的密码长度不在有效范围内，请重新输入！");
						   	   $("#newpassword").select();
						   	   $("#newpassword").focus();
						   	   return;
						   }
						   else if(message == "wrongful") {
							   $("#message2").html("输入的密码不合法，请重新输入！");
						   	   $("#newpassword").select();
						   	   $("#newpassword").focus();
						   	   return;
						   }
						   else if(message == "disaccord") {
						   	 	$("#message3").html("两次密码不一致，请重新输入！");
						   	 	$("#newpassword").select();
						   	 	$("#newpassword").focus();
						   	 	return;
						   }
					   }
					});
				});	
			});