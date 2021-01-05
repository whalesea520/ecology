$(document).ready(function(){
	$("#password").focus();
	$("#ok").click(function(){
		window.onbeforeunload=null;
		$("#message").html("");
		var password = $.trim($("#password").val());
		
		if(password == "") {
			$("#message").html("提示: 密码不能为空！");
			$("#password").select();
			$("#password").focus(); 
			return;
		}
		
		$.ajax({
		   type: "POST",
		   url: "/login.do?date="+(new Date()).valueOf(),
		   data: "password="+$("#password").val(),
		   error: function(){
		   	 alert( "Error : 页面出错请重试！");
		   },
		   success: function(message){
		   	 if(message == "error") {
		   	 	$("#message").html( "错误: 密码不正确，请重新输入！" );
		   	 	$("#password").select();
		   	 	$("#password").focus();
		   	 	return;
		   	 }
		   	 if(message == "default") {
		   		 var r =confirm("是否修改初始密码?(建议修改密码)");
		   		 if(r==true){
		   		    window.location.href="/jsp/index.jsp?operation=changepassword";
		   		 }else{
		   			window.location.href="/jsp/index.jsp";
		   		 }
		   	 } else {
	   				window.location.href="/jsp/index.jsp";
		   	 }
		     
		   }
		});
	});
});