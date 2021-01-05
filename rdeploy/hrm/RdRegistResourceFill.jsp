<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>

<style>
	.e8_os{
	  height:35px; 
	}
	.e8_innerShowContent{
	  height: 30px;
	  padding: 7px 0 0 7px;
	}
	
	.e8_spanFloat{
	  padding: 5px 0 0 0;
	}
	.e8_browflow{
		
	}
	.inbtn:hover{
	  background-color: #325fd4!important;
	}
</style>
</head>

<%
String uid= Util.null2String(request.getParameter("uid"));

String comname = CompanyComInfo.getCompanyname("1");

String language= Util.null2String(request.getParameter("lg"));

int languageid= 7;

if(!"".equals(language)){
    languageid = Util.getIntValue(language,7);
}

%>
<BODY style="background-color:#F1F5F8; ">
<div style="width: 100%;height: 60px;background-color: #4A79EF;text-align: center;">
<center>
  <div style="width: 380px;">
	<div  style="height:50px; width: 100px;padding: 15px 30px 0 50px;position: relative;float: left;">
		<span style="height:100px;width:30px;">
			<img width="100px" height="30px" align="AbsMiddle" src="/rdeploy/assets/img/logo.png" />
		</span>
	</div>
	<div style=" font-size: 17px;color: #FFFFFF;height:42px;padding: 18px 10px 0 0;position: relative;float: left;">
	  <%=SystemEnv.getHtmlLabelName(125273 ,languageid)%>
	</div>
	</div>
</center>
</div>

<form action="RdResourceOperation.jsp" name="frmMain" method="post" >
<input name="method" type="hidden" value="newuser">
<input name="language" type="hidden" value="<%=language %>">
<div style="width: 100%;padding: 60px 0 0 0;text-align: center;">	
<center>
<div style="background-color: #FFFFFF;width:1070px;height: 509px; ">
<table width="500px">
  <tr>
   <td align="center" colspan="3"  style="padding: 40px 0 0px 0; color: #4979ee;font-size: 18px; ">
   	 <span style="margin: 0 10px 0 0;padding-left: 5px;"><%=SystemEnv.getHtmlLabelName(125280 ,languageid)%></span> 
   </td>
 </tr>
  <tr id="mob" style="display: none;">
	  	<td align="right" style="padding-top: 20px;color:#556266;font-size: 14px; " width="100px"><%=SystemEnv.getHtmlLabelName(125280 ,languageid)%> :</td>
  	    <td align="left" style="color: #526268;padding: 29px 0 5px 10px;">
  	    
  	    <span id="comMsg" style="position: absolute;color:#a2a2a2;width: 281px;height: 18px;margin: 14px;display: none;" onclick="$(this).hide();$('#comname').focus();"><%=SystemEnv.getHtmlLabelName(129302, user.getLanguage())%></span>
	  	    <INPUT class=inputstyle style="width: 291px;height: 45px;line-height:45px;color:#556266;border: 1px solid #a2a2a2;padding-left: 10px;" type=text   name=comname id="comname" value="<%=comname %>"  onfocus="$('#comMsg').hide()" onblur="if(this.value==''){$('#comMsg').show()}else{$('#comAlterr').hide()}">
	  	    <span id="comAlter" style="position: absolute;padding: 15px 0 0 20px;color:red;display: none;"><%=SystemEnv.getHtmlLabelName(129303, user.getLanguage())%></span>
  	    </td>
  	    <td>
  	    </td>
  	  </tr>
  <tr id="mob" style="">
	  	<td align="right" style="padding-top: 3px;color:#556266;font-size: 14px; " width="100px"><%=SystemEnv.getHtmlLabelName(125238 ,languageid)%> :</td>
  	    <td align="left" style="color: #526268;padding: 12px 0 5px 10px;">
	  	     <span id="phoMsg" style="position: absolute;color:#a2a2a2;width: 281px;height: 18px;margin: 14px;" onclick="$(this).hide();$('#mobilephone').focus();"><%=SystemEnv.getHtmlLabelName(125281 ,languageid)%></span>
	  	    <INPUT class=inputstyle style="width: 291px;height: 43px;line-height:42px;color:#556266;border: 1px solid #a2a2a2;padding-left: 10px;" type=text   name=loginid id="mobilephone" value=""  onfocus="$('#phoMsg').hide();" onblur="if(this.value==''){$('#phoMsg').show()}else{$('#phoneAlter').css('color','#a2a2a2');$('#phoneAlter').html('<%=SystemEnv.getHtmlLabelName(125282 ,languageid)%>');$(this).css('border','1px solid #a2a2a2');}">
	  	     <span id="phoneAlter" style="position: absolute;padding: 15px 0 0 20px;color:#a2a2a2;"><%=SystemEnv.getHtmlLabelName(125282 ,languageid)%></span>
  	    </td>
  	    <td>
  	    </td>
  	  </tr>
  <tr id="mob" style="">
	  	<td align="right" style="padding-top: 3px;color:#556266;font-size: 14px;" width="100px"><%=SystemEnv.getHtmlLabelName(413 ,languageid)%> :</td>
  	    <td align="left" style="color: #526268;padding: 12px 0 5px 10px;">
  	    	<span id="nameMsg" style="position: absolute;color:#a2a2a2;width: 281px;height: 18px;margin: 14px;" onclick="$(this).hide();$('#name').focus();"><%=SystemEnv.getHtmlLabelName(26919 ,languageid)%></span>
	  	    <INPUT class=inputstyle style="width: 291px;height: 43px;line-height:42px;color:#556266;border: 1px solid #a2a2a2;padding-left: 10px;" type=text maxLength=20 size=30 name=name id="name" value="" onfocus="$('#nameMsg').hide()" onblur="if(this.value==''){$('#nameMsg').show()}else{$('#nameAlter').hide();$(this).css('border','1px solid #a2a2a2');}">
	  	    <span id="nameAlter" style="position: absolute;padding: 15px 0 0 20px;color:red;display: none;"><%=SystemEnv.getHtmlLabelName(125256 ,languageid)%></span>
  	    </td>
  	    <td>
  	      
  	    </td>
  	  </tr>
   <tr>
  <tr id="mob" style="">
	  	<td align="right" style="padding-top: 3px;color:#556266;font-size: 14px;" width="100px"><%=SystemEnv.getHtmlLabelName(125283 ,languageid)%> :</td>
  	    <td align="left" style="color: #526268;padding: 12px 0 5px 10px;">
  	    <span id="p1Msg" style="position: absolute;color:#a2a2a2;width: 281px;height: 18px;margin: 14px;" onclick="$(this).hide();$('#password1').focus();"><%=SystemEnv.getHtmlLabelName(125283 ,languageid)%></span>
	  	    <INPUT class=inputstyle style="width: 291px;height: 43px;line-height:42px;color:#556266;border: 1px solid #a2a2a2;padding-left: 10px;" type="password" maxLength=20 size=30 name=userpassword id="password1" value=""  onkeydown="onkeyudp(this)" onkeyup="onkeyudp(this)"  onfocus="$('#p1Msg').hide()" onblur="if(this.value==''){$('#p1Msg').show();$('#pwd2').hide();}else{if($('#pwd2').css('display')=='none'){$('#pwd2').show();$('#password2').val('');$('#p2Msg').show();}$('#p1Alter').hide();$(this).css('border','1px solid #a2a2a2');}">
	  	    <span id="p1Alter" style="position: absolute;padding: 15px 0 0 20px;color:red;display: none;"><%=SystemEnv.getHtmlLabelName(125284 ,languageid)%></span>
  	    </td>
  	    <td>
  	    
  	    </td>
  	  </tr>
   <tr>
  <tr id="pwd2" style=" display: none;">
	  	<td align="right" style="padding-top: 3px;color:#556266;font-size: 14px;" width="100px"><%=SystemEnv.getHtmlLabelName(125285 ,languageid)%> :</td>
  	    <td align="left" style="color: #526268;padding: 12px 0 5px 10px;">
  	    <span id="p2Msg" style="position: absolute;color:#a2a2a2;width: 281px;height: 18px;margin: 14px;" onclick="$(this).hide();$('#password2').focus();"><%=SystemEnv.getHtmlLabelName(125286 ,languageid)%></span>
	  	    <INPUT  style="width: 291px;height: 43px;line-height:42px;color:#556266;border: 1px solid #a2a2a2;padding-left: 10px;" type="password" maxLength=20 size=30 name=password2 id="password2" value=""  onfocus="$('#p2Msg').hide()" onblur="if(this.value==''){$('#p2Msg').show()}else{$('#p2Alter').hide();$(this).css('border','1px solid #a2a2a2');}">
	  	    <span id="p2Alter" style="position: absolute;padding: 15px 0 0 20px;color:red;display: none;"><%=SystemEnv.getHtmlLabelName(125287 ,languageid)%></span>
  	    </td>
  	    <td>
  	    
  	    </td>
  	  </tr>
   <tr>
     <td colspan="3" align="center" style="padding: 12px 0 5px 23px;">
       <div  id="dosubmit" onclick="doAdd()" class="inbtn"  style="background-color:#4979ee;padding:12px 0 0 0;width: 291px;text-align: center;height: 30px;font-size: 14px;;color: white;cursor:pointer;">
			 <%=SystemEnv.getHtmlLabelName(615 ,languageid)%>
		</div>
     </td>
   </tr>
</table>
</div>
</center>
</div> 
</form>
<script language=javascript>

function onkeyudp(obj){
 if(obj.value ==''){
  $('#pwd2').hide();
 }else{
 	if($('#pwd2').css('display')=='none'){
 	  $('#pwd2').show();
 	  $('#password2').val('');
 	  $('#p2Msg').show();
     }
 }
}

function doAdd(){
	//if($("#comname").val() == ""){
	 // $("#comname").css("border","1px solid #ff817f");
	  //$("#mobilephone").css("height","47px");
	  //$("#mobilephone").css("width","293px");
	  //$("#mobilephone").css("border-left","2px solid #ff817f");
	 // $("#comAlter").html("请输入公司名！");
	 // $("#comAlter").show();
	 // return;
	//}
	if($("#mobilephone").val() == ""){
	  $("#mobilephone").css("border","1px solid #ff817f");
	  //$("#mobilephone").css("height","47px");
	  //$("#mobilephone").css("width","293px");
	  //$("#mobilephone").css("border-left","2px solid #ff817f");
	  $("#phoneAlter").html("<%=SystemEnv.getHtmlLabelName(125252 ,languageid)%>");
	  $("#phoneAlter").css("color","red");
	  return;
	}
	var myreg = /^1\d{10}$/g; 
    if(!myreg.test($("#mobilephone").val())) 
     { 
     $("#mobilephone").css("border","1px solid #ff817f");
     //$("#mobilephone").css("border-top","2px solid #ff817f");
	//  $("#mobilephone").css("border-left","2px solid #ff817f");
       $("#phoneAlter").html("<%=SystemEnv.getHtmlLabelName(125253 ,languageid)%>");
	   $("#phoneAlter").css("color","red");
       return; 
     } 
	if($("#name").val() == ""){
	  $("#name").css("border","1px solid #ff817f");
	  //$("#name").css("border-top","2px solid #ff817f");
	 // $("#name").css("border-left","2px solid #ff817f");
	   $("#nameAlter").html("<%=SystemEnv.getHtmlLabelName(125256 ,languageid)%>");
	   $("#nameAlter").show();
	  return;
	}
	if($("#password1").val() == ""){
	  $("#password1").css("border","1px solid #ff817f");
	  //$("#password1").css("border-top","2px solid #ff817f");
	 // $("#password1").css("border-left","2px solid #ff817f");
	   $("#p1Alter").show();
	  return;
	}
	if($("#password2").val() == ""){
	  $("#password2").css("border","1px solid #ff817f");
	   //$("#password2").css("border-top","2px solid #ff817f");
	  //$("#password2").css("border-left","2px solid #ff817f");
	  $("#p2Alter").html("<%=SystemEnv.getHtmlLabelName(125287 ,languageid)%>");
	   $("#p2Alter").css('display','');
	   $("#pwd2").show();
	  return;
	}
	if($("#password1").val() != $("#password2").val()){
	  $("#p2Alter").html("<%=SystemEnv.getHtmlLabelName(125288 ,languageid)%>");
	  $("#p2Alter").css('display','');
	  $("#pwd2").show();
	  return;
	}
	$.ajax({
		 data:{"nameStr":"","mobile":$("#mobilephone").val()},
		 type: "post",
		 cache:false,
		 url:"checkdatas.jsp",
		 dataType: 'json',
		 success:function(data){
		 	 if(data.mobileExist == "1"){
		 	 	  $("#phoneAlter").html('<%=SystemEnv.getHtmlLabelName(125267 ,languageid)%>');
	   			  $("#phoneAlter").css("color","#ff817f");
		 	 	 return;
		 	 }
		   //if(data.success == "0"){
			   $("#dosubmit").attr('disabled',"true");
			   $("#dosubmit").css('background-color',"red");
			   frmMain.submit();
		   //}else{
		    // $("#nameAlter").html("当前姓名已经使用！");
	   		// $("#nameAlter").show();
		   //}
		}	
   });
}

</script>




</BODY>
</HTML>

