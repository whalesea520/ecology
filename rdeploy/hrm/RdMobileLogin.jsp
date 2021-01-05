<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<HTML>
<HEAD>
<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/js/select/script/jquery-1.8.3.min_wev8.js"></script>
<meta name="viewport" content="width=device-width, initial-scale=0.45,maximum-scale=0.45, minimum-scale=0.45" />
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

String comname = CompanyComInfo.getCompanyname("1");

String language= Util.null2String(request.getParameter("lg"));
String message= Util.null2String(request.getParameter("message"));
String id= Util.null2String(request.getParameter("uid"));
int languageId = 7;

if(!"".equals(id)){
	String sex = ResourceComInfo.getSexs(id);
	
	if(!"".equals(sex)){
	    response.sendRedirect("RdMobileChangeResult.jsp?uid="+id);
	}
	rs.executeSql(" select systemlanguage from HrmResource where id ="+id);
	rs.next();
	
	languageId = rs.getInt(1);
	
	if(languageId == 0 || languageId == -1 ){
	    languageId = 7;
	}
}

String mobile = ResourceComInfo.getMobile(id);
String msg = "";

if(!"".equals(message))
{
    msg = SystemEnv.getHtmlLabelName(32513  ,languageId);
}

%>
<BODY style="padding: 0 0 0 0;margin: 0 0 0 0;">
<div style="border-top: 5px solid #41b4f4;width: 33%;float: left;"></div>
<form action="RdVerifyLogin.jsp" name="frmMain" method="post" >
<input name="method" type="hidden" value="mobilelogin">
<input name="language" type="hidden" value="<%=language %>">
 <INPUT type=hidden name="logintype" value="1">
 <input type=hidden name="gopage1" value="/rdeploy/hrm/RdMobileChangePWD.jsp">
 <input type=hidden name="loginfile" value="/rdeploy/hrm/RdMobileLogin.jsp?type=1">
<div style="width: 100%;padding: 0 0 0 0;text-align: center;height: 100%;">	
<center>
<div style="background-color: #FFFFFF; height: 100%;">
<table width="100%" >
  <tr>
   <td align="center"   style="padding: 100px 0 0px 0; color: #41b4f4;font-size: 78px; ">
   	   <img src="/rdeploy/assets/img/hrm/ecology.png"  align="absMiddle" >
   </td>
 </tr>
  <tr>
   <td align="center"   style="padding: 50px 0 0px 0; color: #000000;font-size: 30px; ">
   	 <%=SystemEnv.getHtmlLabelName(125250,languageId)%><span style="margin: 0 10px 0 0;padding-left: 5px;color:116c96; "><%=comname %></span> 
   </td>
 </tr>
  <tr>
   <td align="center" colspan="3"  style="padding: 30px 0 0px 0; color: #000000;font-size: 30px; ">
   	 <span style="margin: 0 10px 0 0;padding-left: 5px; "><%=SystemEnv.getHtmlLabelName(125251,languageId)%></span> 
   </td>
 </tr>
  <tr id="mob" style="">
  	    <td align="center" style="color: #526268;padding: 72px 0 5px 10px;">
	  	     <span style="position: absolute;color:#a2a2a2;width:50;height: 50px;margin: 25px;text-align: left;font-size: 30px;" >
	  	     	<img src="/rdeploy/assets/img/hrm/phonum.png"  align="absMiddle" >
	  	     </span>
	  	     <span id="phoMsg" style="position: absolute;color:#a2a2a2;width:auto;height: 38px;margin: 25px 0 0 100px;text-align: left;font-size: 30px;display: <%="".equals(mobile)?"":"none" %>" onclick="$(this).css('display','none');$('#mobilephone').focus();"><%=SystemEnv.getHtmlLabelName(125238,languageId)%></span>
	  	    <INPUT class=inputstyle style="width: 90%;height: 93px;line-height:92px;color:#556266;border: 0px solid #a2a2a2;padding-left: 100px;background-color: #f3f3f3;font-size: 30px;vertical-align:middle;" type=text   name=loginid id="mobilephone" value="<%=mobile %>"  onfocus="$('#phoMsg').hide();" onblur="if(this.value==''){$('#phoMsg').css('display','')}else{$(this).css('border','0px solid #ff817f');}">
  	    </td>
  	  </tr>
  <tr id="mob" style="">
  	    <td align="center" style="color: #526268;padding: 34px 0 5px 10px;">
	  	     <span style="position: absolute;color:#a2a2a2;width:50;height: 50px;margin: 25px;text-align: left;font-size: 30px;" >
	  	     	<img src="/rdeploy/assets/img/hrm/pws.png"  align="absMiddle" >
	  	     </span>
  	    <span id="p1Msg" style="position: absolute;color:#a2a2a2;width:auto;height: 38px;margin: 25px 0 0 100px;text-align: left;font-size: 30px;" onclick="$(this).hide();$('#password1').focus();"><%=SystemEnv.getHtmlLabelName(125169,languageId)%></span>
	  	    <INPUT class=inputstyle style="width: 90%;height: 93px;line-height:92px;color:#556266;border: 0px solid #a2a2a2;padding-left: 100px;background-color: #f3f3f3;font-size: 30px;vertical-align:middle;" type="password" maxLength=20 size=30 name=userpassword id="password1" value=""    onfocus="$('#p1Msg').hide()" onblur="if(this.value==''){$('#p1Msg').css('display','');}else{$(this).css('border','0px solid #ff817f');}">
  	    </td>
  	  </tr>
   <tr>
   <tr>
     <td align="center" style="padding: 72px 0 5px 10px;">
       <div id="showMsg" style="height: 100px;font-size: 30px;width: 100%;text-align: center;color:red; "><%=msg %></div>
     </td>
   </tr>
   <tr>
     <td  align="center" style="padding: 32px 0 5px 10px;">
       <div  id="dosubmit" onclick="doAdd()"   style="background-color:#41b4f4;padding:27px 0 0 0;width: 90%;text-align: center;height: 63px;font-size: 30px;;color: white;cursor:pointer;">
			 <%=SystemEnv.getHtmlLabelName(125248,languageId)%>
		</div>
     </td>
   </tr>
</table>
</div>
</center>
</div> 
</form>
<script language=javascript>

function doAdd(){
	if($("#mobilephone").val() == ""){
	  $("#mobilephone").css("border","1px solid #ff817f");
	  //$("#mobilephone").css("height","47px");
	  //$("#mobilephone").css("width","293px");
	  //$("#mobilephone").css("border-left","2px solid #ff817f");
	  $("#showMsg").html("<%=SystemEnv.getHtmlLabelName(125252,languageId)%>");
	  return;
	}
	var myreg = /^1\d{10}$/g; 
    if(!myreg.test($("#mobilephone").val())) 
     { 
     $("#mobilephone").css("border","1px solid #ff817f");
     //$("#mobilephone").css("border-top","2px solid #ff817f");
	//  $("#mobilephone").css("border-left","2px solid #ff817f");
       $("#showMsg").html("<%=SystemEnv.getHtmlLabelName(125253,languageId)%>");
       $("#mobilephone").focus();
       return; 
     } 
	if($("#password1").val() == ""){
	  $("#password1").css("border","1px solid #ff817f");
	  //$("#password1").css("border-top","2px solid #ff817f");
	 // $("#password1").css("border-left","2px solid #ff817f");
       $("#showMsg").html("<%=SystemEnv.getHtmlLabelName(125249,languageId)%>");
	  return;
	}
   frmMain.submit();
}

</script>




</BODY>
</HTML>

