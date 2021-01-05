<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.*"%>
<% 
	User user = (User)session.getAttribute("weaver_user");
	String url = (String)session.getAttribute("url");
	String clientkey = (String)session.getAttribute("clientkey");
	String clientserial = (String)session.getAttribute("clientserial");
%>
<html>
	<head>
		<script language="JavaScript">
                //验证海泰key
                function checkusb2(){
	                try{
	                   var form1= document.getElementById("form1");
	                   var rndtext = document.getElementsByName("rnd")[0];
	                   var serial = document.getElementById("serial");
	                    rnd = Math.round(Math.random()*1000000000);
	                    var returnstr = getUserPIN();
	                    if(returnstr != undefined && returnstr != ""){
	                        //form1.username.value= returnstr;
	                        var randomKey = getRandomKey(rnd);
	                        //alert(randomKey);
	                        rndtext.value=rnd;
	                        serial.value=randomKey;
	                    }else{
	                        rndtext.value=0;
	                        serial.value=0;
	                    }
	                }catch(err){
	                   rndtext.value=0;
	                   serial.value=0
	                }
	                form1.submit();
	            }
        </script>
		<OBJECT id="htactx" name="htactx"
			classid=clsid:FB4EE423-43A4-4AA9-BDE9-4335A6D3C74E
			codebase="HTActX.cab#version=1,0,0,1" style="HEIGHT: 0px; WIDTH: 0px"></OBJECT>
		<form name="form1" id="form1" action="/messager/eimforward.jsp"
			method="post">
			<INPUT type=hidden name="rnd" id="rndtext">
			<INPUT type=hidden name="serial" id="serial">
			<INPUT type=hidden name="clientkey" value="<%=clientkey%>">
			<INPUT type=hidden name="clientserial" value="<%=clientserial%>">
			<INPUT type=hidden name="url" value="<%=url%>">
		</form>
	<script language="javascript">
	function getUserPIN(){
	  try{
	  	var vbsserial="";
	  	var hCard = htactx.OpenDevice(1);//打开设备
	  	if(hCard==0){
	  		alert("请确认您已经正确地安装了驱动程序并插入了usb令牌")
	  		return vbsserial;
	  	}
	  	
	  	try{
		  	vbsserial = htactx.GetUserName(hCard)//获取用户名
		  	htactx.CloseDevice(hCard)
		  	return vbsserial;
		  }catch(e){
		  	alert("请确认您已经正确地安装了驱动程序并插入了usb令牌2");
		  	htactx.CloseDevice(hCard);
		  	return vbsserial;
		  }
	  }catch(e){
	  	alert("请确认您已经正确地安装了驱动程序并插入了usb令牌");
	  	htactx.CloseDevice(hCard);
	  	return vbsserial;
	  }
	}
	
	function getRandomKey(randnum){
		try{
			var hCard = htactx.OpenDevice(1);//打开设备
			if(hCard == 0 ){
				alert("请确认您已经正确地安装了驱动程序并插入了usb令牌4");
				return "";
			}
			try{
				var Digest = htactx.HTSHA1(randnum, (""+randnum).length);
				Digest = Digest+"04040404" //对SHA1数据进行补码
				htactx.VerifyUserPin(hCard, "<%=user.getPwd()%>") //校验口令
		   	var EnData = htactx.HTCrypt(hCard, 0, 0, Digest, Digest.length)//DES3加密SHA1后的数据
		   	htactx.CloseDevice(hCard);
		   	return EnData;
		  }catch(e){
		  	alert("请确认您已经正确地安装了驱动程序并插入了usb令牌5");
		  	htactx.CloseDevice(hCard);
		  	return "";
		  }
		}catch(e){
			alert("请确认您已经正确地安装了驱动程序并插入了usb令牌4");
			return "";
		}
	}
	</script>
	</head>
	<body onload="javascript:checkusb2();">
	</body>
</html>


