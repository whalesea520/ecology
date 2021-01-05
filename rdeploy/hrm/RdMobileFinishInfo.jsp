<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="JobtitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<HTML>
<HEAD> 
<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
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

User user =(User) request.getSession().getAttribute("_rdverifyloginuser");
if(user == null){
    response.sendRedirect("/rdeploy/hrm/RdMobileLogin.jsp");
}


int uid= user.getUID();

String mobile = ResourceComInfo.getMobile(uid+"");

String name = ResourceComInfo.getLastname(uid+"");

String deptid =  ResourceComInfo.getDepartmentID(uid+"");

String deptname = DepartmentComInfo.getDepartmentname(deptid);

String jobid = ResourceComInfo.getJobTitle(uid+"");

String jobname = JobtitlesComInfo.getJobTitlesname(jobid);

int language= user.getLanguage();


%>
<BODY style="padding: 0 0 0 0;margin: 0 0 0 0;">
<div style="border-top: 5px solid #41b4f4;width: 100%;float: left;"></div>
<form action="RdResourceOperation.jsp" name="frmMain" method="post" >
<input name="method" type="hidden"  value="mobilefinishinfo">
<input name="language" type="hidden" value="<%=language %>">
<input  type="hidden" name ="id" value="<%=uid %>">
<div style="width: 100%;padding: 0 0 0 0;text-align: center;height: 100%;">	
<center>
<div style="background-color: #FFFFFF; height: 100%;">
<table width="90%" >
  <tr>
   <td align="center" colspan="3"  style="padding: 77px 0 0px 0; color: #000000;font-size: 30px; ">
   	 <span style="margin: 0 10px 0 0;padding-left: 5px; "><%=SystemEnv.getHtmlLabelName(125254,user.getLanguage())%></span> 
   </td>
 </tr>
  <tr>
   <td align="center" colspan="3"  style="padding: 37px 0 0px 0; color: #000000;font-size: 30px; ">
   	 <span style="margin: 0 10px 0 0;padding-left: 5px; ">
   	   <img id="boyUnselect" src="/rdeploy/assets/img/hrm/boyUnselect.png" onclick="$('#boySelect').show();$('#sex').val('0');$(this).hide();$('#girlSelect').hide();$('#girlUnselect').show();"  align="absMiddle" >
   	   <img id="boySelect" src="/rdeploy/assets/img/hrm/boySelect.png" style="display: none;"  align="absMiddle" >
   	 </span> 
   	 <span style="margin: 0 10px 0 0;padding-left: 5px; ">
   	   <img id="girlUnselect" src="/rdeploy/assets/img/hrm/girlUnselect.png" onclick="$('#girlSelect').show();$('#sex').val('1');$(this).hide();$('#boySelect').hide();$('#boyUnselect').show();"  align="absMiddle" >
   	   <img id="girlSelect" src="/rdeploy/assets/img/hrm/girlSelect.png" style="display: none;"  align="absMiddle" >
   	 </span> 
   	 <input type="hidden" name="sex" id="sex" value="">
   </td>
 </tr>
  <tr id="mob" style="">
  	    <td align="center" style="color: #526268;padding: 32px 0 5px 10px;">
  	    <span style="position: absolute;color:#a2a2a2;width:50;height: 50px;margin: 25px;text-align: left;font-size: 30px;" >
	  	     	<img src="/rdeploy/assets/img/hrm/phonum.png"  align="absMiddle" >
	  	     </span>
	  	     <span id="phoMsg" style="position: absolute;color:#a2a2a2;width:auto;height: 38px;margin: 25px 0 0 100px;text-align: left;font-size: 30px;display: <%="".equals(mobile)?"":"none" %>" onclick="$(this).css('display','none');$('#mobilephone').focus();"><%=SystemEnv.getHtmlLabelName(125238,user.getLanguage())%></span>
	  	    <INPUT class=inputstyle style="width: 100%;height: 93px;line-height:92px;color:#556266;border: 0px solid #a2a2a2;padding-left: 100px;background-color: #f3f3f3;font-size: 30px;" type=text   name=mobilephone id="mobilephone" value="<%=mobile %>"  onfocus="$('#phoMsg').hide();" onblur="if(this.value==''){$('#phoMsg').css('display','')}else{$(this).css('border','0px solid #ff817f');}">
  	    </td>
  	  </tr>
  <tr id="mob" style="">
  	    <td align="center" style="color: #526268;padding: 27px 0 5px 10px;">
  	    <span style="position: absolute;color:#a2a2a2;width:50;height: 50px;margin: 25px;text-align: left;font-size: 30px;" >
	  	     	<img src="/rdeploy/assets/img/hrm/name.png"  align="absMiddle" >
	  	     </span>
  	    <span id="nameMsg" style="position: absolute;color:#a2a2a2;width:auto;height: 38px;margin: 25px 0 0 100px;text-align: left;font-size: 30px;display: <%="".equals(name)?"":"none" %>" onclick="$(this).hide();$('#name').focus();"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%></span>
	  	    <INPUT class=inputstyle style="width: 100%;height: 93px;line-height:92px;color:#556266;border: 0px solid #a2a2a2;padding-left: 100px;background-color: #f3f3f3;font-size: 30px;" type="text" maxLength=20 size=30 name=name id="name" value="<%=name %>"    onfocus="$('#nameMsg').hide()" onblur="if(this.value==''){$('#nameMsg').css('display','');}else{$(this).css('border','0px solid #ff817f');}">
  	    </td>
  	  </tr>
   <tr>
  <tr id="mob" style="">
  	    <td align="center" style="color: #526268;padding: 27px 0 5px 10px;">
  	    <span style="position: absolute;color:#a2a2a2;width:50;height: 50px;margin: 25px;text-align: left;font-size: 30px;" >
	  	     	<img src="/rdeploy/assets/img/hrm/dept.png"  align="absMiddle" >
	  	     </span>
  	    <span id="deptMsg" style="position: absolute;color:#a2a2a2;width:auto;height: 38px;margin: 25px 0 0 100px;text-align: left;font-size: 30px;display: <%="".equals(deptname)?"":"none" %>" onclick="$(this).hide();$('#dept').focus();"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></span>
	  	    <INPUT class=inputstyle style="width:100%;height: 93px;line-height:92px;color:#556266;border: 0px solid #a2a2a2;padding-left: 100px;background-color: #f3f3f3;font-size: 30px;" type="text" maxLength=20 size=30 name=dept id="dept" value="<%=deptname %>"  onkeydown="getDeptMessage(this.value)" onkeyup="getDeptMessage(this.value)"  onfocus="$('#deptMsg').hide()" onblur="if(this.value==''){$('#deptMsg').css('display','');}else{$(this).css('border','0px solid #ff817f');}setTimeout('hideDeptSelect()',100) ">
	  	    <input type="hidden" name="deptid" id="deptid" value="<%=deptid %>">
	  	    <div id="deptSelectDiv" style="position: absolute;width: 90%;display: none;">
		  	    <div id="e8_autocomplete_div" style="display: ; left: 100px;position: relative;   overflow-y: hidden;width: 80%;max-height: 220px;max-width: 80%;float: left" class="ac_results" tabindex="5003">
					<div></div>
					<ul id="thisDeptShow">
					</ul>
				</div>
			</div>
  	    </td>
  	  </tr>
   <tr>
  <tr id="jobdiv" style="display: none;">
  	    <td align="center" style="color: #526268;padding: 27px 0 5px 10px;">
  	    <span style="position: absolute;color:#a2a2a2;width:50;height: 50px;margin: 25px;text-align: left;font-size: 30px;" >
	  	     	<img src="/rdeploy/assets/img/hrm/job.png"  align="absMiddle" >
	  	     </span>
  	    <span id="jobMsg" style="position: absolute;color:#a2a2a2;width:auto;height: 38px;margin: 25px 0 0 100px;text-align: left;font-size: 30px;display: <%="".equals(jobname)?"":"none" %>" onclick="$(this).hide();$('#password1').focus();"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></span>
	  	    <INPUT class=inputstyle style="width: 100%;height: 93px;line-height:92px;color:#556266;border: 0px solid #a2a2a2;padding-left: 100px;background-color: #f3f3f3;font-size: 30px;" type="text" maxLength=20 size=30 name=job id="job" value="<%=jobname %>"  onkeydown="getJobMessage(this.value)" onkeyup="getJobMessage(this.value)"   onfocus="$('#jobMsg').hide()" onblur="if(this.value==''){$('#jobMsg').css('display','');}else{$(this).css('border','0px solid #ff817f');}setTimeout('hideJobSelect()',100)">
	  	    <input type="hidden" name="jobid" id="jobid" value="<%=jobid %>">
	  	     <div id="jobSelectDiv" style="position: absolute;width: 90%;display: none;">
		  	    <div id="e8_autocomplete_div" style="display: ; left: 100px;position: relative;   overflow-y: hidden;width: 80%;max-height: 220px;max-width: 80%;float: left" class="ac_results" tabindex="5003">
					<div></div>
					<ul id="thisJobShow">
					</ul>
				</div>
			</div>
  	    </td>
  	  </tr>
   <tr>
   <tr>
     <td align="center" style="padding: 20px 0 5px 10px;">
       <div id="showMsg" style="height: 50px;font-size: 30px;width: 100%;text-align: center;color:red; ">&nbsp;</div>
     </td>
   </tr>
   <tr>
     <td  align="center" style="padding: 18px 0 5px 10px;">
       <div  id="dosubmit" onclick="doAdd()"   style="background-color:#41b4f4;padding:27px 0 0 0;width: 100%;text-align: center;height: 63px;font-size: 30px;;color: white;cursor:pointer;">
			 <%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%>
		</div>
     </td>
   </tr>
</table>
</div>
</center>
</div> 
</form>
<script language=javascript>
var iscommit = false;
function doAdd(){
   if(iscommit){
   	 return;
   }
	
	if($("#sex").val() == ""){
       $("#showMsg").html("<%=SystemEnv.getHtmlLabelName(125255,user.getLanguage())%>");
	  return;
	}
	var mobilephone = $("#mobilephone").val();
	if(mobilephone == ""){
	  $("#mobilephone").css("border","1px solid #ff817f");
       $("#showMsg").html("<%=SystemEnv.getHtmlLabelName(125252,user.getLanguage())%>");
	  return;
	}
	var myreg = /^1\d{10}$/g; 
    if(!myreg.test(mobilephone)) 
     { 
     $("#mobilephone").css("border","1px solid #ff817f");
       $("#showMsg").html("<%=SystemEnv.getHtmlLabelName(125253,user.getLanguage())%>");
       $("#mobilephone").focus();
       return; 
     }
     var name = $("#name").val();
	if(name == ""){
	  $("#name").css("border","1px solid #ff817f");
       $("#showMsg").html("<%=SystemEnv.getHtmlLabelName(125256,user.getLanguage())%>");
	  return;
	}
	if($("#password1").val() == ""){
	  $("#password1").css("border","1px solid #ff817f");
       $("#showMsg").html("<%=SystemEnv.getHtmlLabelName(125249,user.getLanguage())%>");
	  return;
	}
	var dataP = {"nameStr":"","mobile":""};
     //if("<%=name%>" != name ){
     //	dataP.nameStr = name;
     
    // }
     if("<%=mobile%>" != mobilephone ){
     	dataP.mobile = mobilephone;
		$.ajax({
				 data:dataP,
				 type: "post",
				 cache:false,
				 url:"checkdatas.jsp",
				 dataType: 'json',
				 success:function(data){
				 	if(data.mobileExist == "1"){
				 	 	 $("#showMsg").html('<%=SystemEnv.getHtmlLabelName(125267,user.getLanguage())%>');
				 	 	 return;
			 	 	}
					 //if(data.success == "0"){
						   $("#dosubmit").attr('disabled',"true");
						    $("#dosubmit").css('background-color',"#b7bfc5");
						   iscommit =true;
						   frmMain.submit();
					 //}else{
					 //	  $("#showMsg").html('当前姓名已被使用！');
				 	 //	 return;
					// }
				}	
		   });
     }else{
       $("#dosubmit").attr('disabled',"true");
	   $("#dosubmit").css('background-color',"#b7bfc5");
	   iscommit =true;
	   frmMain.submit();
     }
}

setInterval('getDeptMessage($("#dept").val())',300);

var inputValue = "<%=deptname %>";
function getDeptMessage(obj){
   //obj = $("#dept").val();
   if(obj == inputValue)
   {
     return;
   }else{
      inputValue = obj;
   }
   $("#deptid").val('');
   if(obj==''){
	   $("#deptSelectDiv").css("display","none");
	   $("#jobdiv").css("display","none");
	   $("#job").val('');
  		$("#jobtid").val('');
  		$('#jobMsg').css('display','')
	   return;
   }else{
      $("#jobdiv").css("display","");
   }
   $.ajax({
		 data:{"q":obj,"limit":300,"_exclude":"6","timestamp":""},
		 type: "post",
		 cache:false,
		 url:"/data.jsp?type=4",
		 dataType: 'json',
		 success:function(data){
		 	 if(data.length == 0){
		 	 	$("#deptSelectDiv").css("display","none");
		 	 	return;
		 	 }else{
		 	 	var html_='';
		 	 	for(var i = 0; i<data.length&&i<3;i++){
		 	 	   
		 	 	   html_+='<li class="ac_even " onclick="clickli('+data[i].id+',\''+data[i].name+'\')"   style="font-size: 28px;line-height: 70px;height:  70px;" _title="'+data[i].name+'  |  '+data[i].subcompanyname+'" title="'+data[i].name+'  |  '+data[i].subcompanyname+'">'+data[i].name+'</li>';
		 	 	}
		 	 	$("#thisDeptShow").html(html_);
		 	 	
		 	 	$("#deptSelectDiv").css("display","");
		 	 }
		}	
   });
}

function clickli(id,name){
  inputValue = name;
  $("#dept").val(name);
  $("#deptid").val(id);
}

function hideDeptSelect(){
 $('#deptSelectDiv').hide();
}

var inputValue2 = "<%=jobname %>";
function getJobMessage(obj){
   //obj = $("#job").val();
   if(obj == inputValue2 || $("#deptid").val() =='')
   {
     return;
   }else{
      inputValue2 = obj;
   }
   $("#jobid").val('');
   if(obj==''){
	   $("#jobSelectDiv").hide();
	   return;
   }
   	var url= "/data.jsp?type=hrmjobtitles";
			url+="&whereClause= jobdepartmentid="+$("#deptid").val()+" and ";
   $.ajax({
		 data:{"q":obj,"limit":300,"_exclude":"6","timestamp":""},
		 type: "post",
		 cache:false,
		 url:url,
		 dataType: 'json',
		 success:function(data){
		 	 if(data.length == 0){
		 	 	$("#jobSelectDiv").css("display","none");
		 	 	return;
		 	 }else{
		 	 	var html_='';
		 	 	for(var i = 0; i<data.length&&i<3;i++){
		 	 	   
		 	 	   html_+='<li class="ac_even " onclick="clickli2('+data[i].id+',\''+data[i].name+'\')"   style="font-size: 28px;line-height: 70px;height:  70px;" _title="'+data[i].name+'  |  '+data[i].departmentname+'" title="'+data[i].name+'  |  '+data[i].departmentname+'">'+data[i].name+'</li>';
		 	 	}
		 	 	$("#thisJobShow").html(html_);
		 	 	
		 	 	$("#jobSelectDiv").css("display","");
		 	 }
		}	
   });
}

function clickli2(id,name){
  inputValue2 = name;
  $("#job").val(name);
  $("#jobid").val(id);
}

function hideJobSelect(){
 $('#jobSelectDiv').hide();
}
</script>




</BODY>
</HTML>

