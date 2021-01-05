<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="org.codehaus.xfire.client.Client"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RdeployHrmSetting" class="weaver.rdeploy.hrm.RdeployHrmSetting" scope="page" />
<%@page import="java.net.URL"%>
<HTML>
<HEAD>

<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="/js/ecology8/jNice/jNice/jquery.jNice_wev8.js"></script>
<link rel="stylesheet" href="/js/ecology8/jNice/jNice/jNice_wev8.css" type="text/css" />
<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>	
  	<script language="javascript" src="/rdeploy/assets/js/jquery.easing.1.3.js"></script>


<style>
	.e8_os{
	  height:32px; 
	}
	.e8_innerShowContent{
	  height: 32px;
	  padding: 13px 0 0 7px;
	}
	
	.e8_spanFloat{
	  padding: 12px 0 0 0;
	}
	.e8_browflow{
		
	}
	
	.back:hover{
	  background-color: #325fd4;
	}
	.inbtn:hover{
	  background-color: #325fd4!important;
	}
	.thisBack{
  			background-color: #eef2f5;
  			border: 1px solid #e0e6ec;
  		}
  		.thisBack:hover{
  			background-color: #e2e9f0;
  			border: 1px solid #ced7e0;
  		}
</style>
</head>
<%! 

public String QueryString(String ip,String host) {
	String ret = "{}";
	String url = "http://" + host + "/services/HrmService?wsdl";
	try {
	    LN ln = new LN();
		Client client = new Client(new URL(url));
		Object[] results = client.invoke("getMobileHost",
				//new Object[] { ln.getCid()});
				new Object[] { 306});
		//System.out.println(results.toString());
		ret = (String) results[0];	
	} catch (Exception e) {
	    //e.printStackTrace();
		//writeLog("调用webservice接口发生异常:url="+url+e.getMessage());
		return "{}";
	}
	return ret;
}
%>
<%
String uid= user.getUID()+"";
String mobilephone= user.getMobile();
String name= user.getLastname();
//String other= request.getSession().getAttribute("rd_other").toString();
String language= Util.null2String(request.getParameter("language"));
String red= Util.null2String(request.getParameter("red"));

String fromLogin = Util.null2String(request.getParameter("fromLogin"));

String subcomid = Util.null2String(RdeployHrmSetting.getSettingInfo("subcom"));


String subcomName = SubCompanyComInfo.getSubCompanyname(subcomid);

int id = user.getUID();
boolean getadd = true;
String hostadd = RdeployHrmSetting.getSettingInfo("hostadd");


String address = QueryString("",hostadd);

if("{}".equals(address)|| "0".equals(address)|| "".equals(address)){
    address=" "+SystemEnv.getHtmlLabelName(125259,user.getLanguage());
    getadd =false;
}
%>

<BODY style="background-color:#F1F5F8;overflow:hidden;">
<div style="width: 100%;height: 60px;background-color: #4A79EF;text-align: center;">
<center>
  <div style="width: 380px;">
	<div  style="height:50px; width: 100px;padding: 15px 30px 0 50px;position: relative;float: left;">
		<span style="height:100px;width:30px;">
			<img width="100px" height="30px" align="AbsMiddle" src="/rdeploy/assets/img/logo.png" />
		</span>
	</div>
	<div style=" font-size: 17px;color: #FFFFFF;height:42px;padding: 18px 10px 0 0;position: relative;float: left;">
	  <%=SystemEnv.getHtmlLabelName(125273,user.getLanguage())%>
	</div>
	</div>
</center>
</div>

<form action="RdResourceOperation.jsp" name="frmMain" method="post">
<input name="method" type="hidden" value="newuseredit">
<input name="id" type="hidden" value="<%=uid %>">
<div style="width: 100%;padding: 60px 0 0 0;text-align: center;">	
<center>
<div style="background-color: #FFFFFF;width:1070px;height: 509px; ">
<table width="500px">
  <tr>
   <td align="center" colspan="3"  style="padding: 45px 0 0px 0; color: #69696a;font-size: 18px; ">
    <% if("1".equals(fromLogin)){ %>
     <span style="margin: 0 10px 0 0;padding-left: 5px;color: #797979;"><%=SystemEnv.getHtmlLabelName(125289,user.getLanguage())%></span> 
    <% }else{%>
     <img width="35px" height="35px" align="AbsMiddle" src="/rdeploy/assets/img/hrm/success.png" />
   	 <span style="margin: 0 10px 0 0;padding-left: 5px;"><%=SystemEnv.getHtmlLabelName(125290,user.getLanguage())%></span>
   	 <%} %> 
   </td>
 </tr>
  <tr id="mob" style="">
	  	<td align="right" style="padding-top: 30px;color:#536165;font-size: 14px; " width="100px"><%=SystemEnv.getHtmlLabelName(125291,user.getLanguage())%> </td>
  	    <td align="left" style="color: #526268;padding: 37px 0 5px 20px;">
	  	     <table>
	      	 	<tr>
	      	 		<td width="25px"><input type="radio" id="man" name="sex" checked=""  value="0"/></td>
	      	 		<td width="40px" style="font-size: 14px;color:#556266;"><%=SystemEnv.getHtmlLabelName(28473,user.getLanguage())%></td>
	      	 		<td width="25px"><input type="radio" id="girl" name="sex" checked=""  value="1"/></td>
	      	 		<td width="30px" style="font-size: 14px;color:#556266;"><%=SystemEnv.getHtmlLabelName(125223,user.getLanguage())%></td>
      	 		</tr>
	      	 </table>
  	    </td>
  	    <td>
  	    </td>
  	  </tr>
  <tr id="mob" style="">
	  	<td align="right" style="padding-top: 18px;color:#536165;font-size: 14px; " width="100px"><%=SystemEnv.getHtmlLabelName(125238,user.getLanguage())%> </td>
  	    <td align="left" style="color: #526268;padding: 5px 0 5px 10px;">
	  	     <span style="position: absolute;padding: 0 0 0 20px;color:#536165;font-size: 14px;"><%=mobilephone %></span>
  	    </td>
  	    <td>
  	    </td>
  	  </tr>
  <tr id="mob" style="">
	  	<td align="right" style="padding-top: 13px;color:#536165;font-size: 14px;" width="100px"><%=SystemEnv.getHtmlLabelName(413,user.getLanguage())%> </td>
  	    <td align="left" style="color: #526268;padding: 22px 0 5px 20px;">
	  	    <INPUT class=inputstyle style="width: 291px;height: 45px;line-height:45px;" type=text maxLength=20 size=30 name=name id="name" value="<%=name %>"  >
  	    </td>
  	    <td>
  	      
  	    </td>
  	  </tr>
   <tr>
  <tr id="dept" style="">
	  	<td align="right" style="padding-top: 15px;color:#536165;font-size: 14px;" width="100px"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></td>
  	    <td align="left" style="color: #526268;padding: 12px 0 5px 20px;">
	  	    
  	    <brow:browser viewType="0"  name="departmentid" browserValue=""
  	    				   browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids="
						   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						   completeUrl="/data.jsp?type=4" width=" 320px" 
						   browserSpanValue="">
			</brow:browser>
			 <div style="width: 349px;font-size: 24px;padding: 5px 0 0 10px;"><a style="float: right;width: 30px;color: #536467;" href="javascript:addDept()"><img src="/rdeploy/assets/img/hrm/plus.png" width="18px" height="18px" align="absMiddle"><a></div>
  	    </td>
  	    <td>
  	    
  	    </td>
  	  </tr>
  		<tr>
	  	<td align="right" style="padding-top: 28px;color:#536165;font-size: 14px;" width="100px"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></td>
  	    <td align="left" style="color: #526268;padding: 27px 0 5px 20px;">
	  	    <brow:browser viewType="0" name="jobtitle" browserValue="" 
						   getBrowserUrlFn="onShowJobtitle" dialogWidth="600px"
						   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						  width=" 320px" browserSpanValue="">
		    </brow:browser>
		    <div style="width: 349px;font-size: 24px;padding: 5px 0 0 10px;"><a style="float: right;width: 30px;color: #536467;" href="javascript:addJobile()"><img src="/rdeploy/assets/img/hrm/plus.png" width="18px" height="18px" align="absMiddle"><a></div>
  	    </td>
  	    <td>
  	    
  	    </td>
  	  </tr>
   <tr>
     <td colspan="3" align="center" style="padding: 20px 0 0 0;">
       <div  id="dosubmit" onclick="doAdd()" class="inbtn" style="background-color:#4A79EF;margin:0 0 0 38px;width: 293px;text-align: center;height: 30px;font-size: 14px;padding-top: 12px;color: white;cursor:pointer;">
			 <%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>
		</div>
		
		<div style="height: 20px;padding: 10px 0 0 10px;"><a href="javascript:floatTo()" style="color: #4b78ee;font-size: 14px;"><%=SystemEnv.getHtmlLabelName(125294,user.getLanguage())%></a></div>
     </td>
   </tr>
</table>
</div>
</center>
</div> 
</form>

<div id="context" style="width: 100%;padding: 60px 0 0 0;text-align: center;position: absolute;z-index: 4;display: none;top: 569px;">	
<center>
<div style="background-color: #FFFFFF;width:1070px;height: 509px; ">
<span style="float: right;margin-right: 20px;margin-top: 13px;"><a href="javascript:closeInfo()"><img  src="/rdeploy/assets/img/hrm/x.png" width="12px;" onclick=""/></a></span>
<table >
 <tr>
   <td>
    
   </td>
 </tr>
  <tr>
   <td  align="center" style="padding: 30px 0 10px 0; color: #4A79EF;font-size: 56px;">
   	 <img src="/rdeploy/assets/img/hrm/logo.png" width="218px" height="60px" align="absMiddle" >
   </td>
 </tr>
   <tr>
     <td align="center">
     	<div style="width: 425px;height: 28px; padding: 3px 0 0 0;font-size: 16px;color: #797979;">
     		<%=SystemEnv.getHtmlLabelName(125295,user.getLanguage())%><span style="padding-left: 15px;"><%=SystemEnv.getHtmlLabelName(125296,user.getLanguage())%></span>
     	</div>
     	<img src="/rdeploy/assets/img/hrm/dowload.png"  align="absMiddle" >
     </td>
   </tr>
   <tr>
     <td align="left">
       <div style="padding: 10px 0 20px 0; ">
		 <div style="width: 425px;height: 28px; padding: 7px 0 0 80px;font-size: 14px;color: #797979;"><%=SystemEnv.getHtmlLabelName(125297,user.getLanguage())%></div>
		 <div style="width: auto;height: 28px; padding: 7px 0 0 80px;font-size: 14px;color: #797979;">
		 <%=SystemEnv.getHtmlLabelName(125298,user.getLanguage())%>
		 <%if(getadd){ %>
		 <%=address %>
		 <span class="dbtn thisBack" id="inadvancedmode" style="margin: -8px 0 0 0;color: #797979;padding:0px 10px;font-size: 13px;" onclick="sendToMobile()">
			  	<%=SystemEnv.getHtmlLabelName(125299,user.getLanguage())%>
	     </span>
	     <% }else{%>
	        <span style="color: #4A79EF;"><%=address %></span>
	     <%} %>
		 </div>
		 <div style="width: 425px;height: 28px; padding: 7px 0 0 80px;font-size: 14px;color: #797979;"><%=SystemEnv.getHtmlLabelName(125300,user.getLanguage())%></div>
	   </div>
     </td>
   </tr>
</table>
</div>
</center>
</div> 
<script language=javascript>

function closeInfo(){
	jQuery("#context").hide();
	jQuery("#context").css("top","509px");
}
var wHeight= window.parent.innerHeight;

function floatTo(){
$("#context").show();
$("#context").animate({ 
	  top: 60
	},{ 
	  duration: 500, 
	  easing: "swing"
	  //complete: easeInOutBack1
	});
}
var languageid = "<%=language%>";

jQuery(document).ready(function(){
	jQuery('body').jNice(); 
	jQuery("#man").trigger("checked","");
});

function onShowJobtitle(){
	var url="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/JobTitlesBrowser.jsp?fromPage=add";
	return url;
}

function getCompleteUrl(){
	var url= "/data.jsp?type=hrmjobtitles";
  return url;	
}

function addJobile(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "RdAddJob.jsp?deptid="+jQuery("input[name=departmentid]").val();
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(125302,user.getLanguage())%>";
	dialog.normalDialog = false;
	dialog.Width = 400;
	dialog.Height = 223;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
function addDept(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	dialog.URL = "RdDeptAdd.jsp?supName=<%=subcomName%>&subcompanyid1=<%=subcomid %>&supdepid=0&method=add&from=1";
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(125303,user.getLanguage())%>";
	dialog.normalDialog = false;
	dialog.Width = 400;
	dialog.Height = 223;
	dialog.Drag = true;
	dialog.show();
}



function doAdd(){
	
	if($("#name").val() == ""){
	  $("#name").css("border","1px solid red");
	   $("#msg").html("<%=SystemEnv.getHtmlLabelName(125256,user.getLanguage())%>");
	  return;
	}
	//if(jQuery("input[name=departmentid]").val() != ""){
	//	$("#msg").html("部门不能为空!");
	//	return;
	//}
	//if(jQuery("input[name=departmentid]").val() != "" && jQuery("input[name=jobtitle]").val() == ""){
	//	$("#msg").html("岗位不能为空!");
	//	return;
	//}
    frmMain.submit();
}

	var depName ="";
	var supDepName = "<%=subcomName%>";

function getdepName(){
	return depName;
}
function setdepName(name){
	depName=name;
}
function getSupdepName(){
	return supDepName;
}

function getNewDeptId(id,name){
  _writeBackData('departmentid','1',{'id':id,'name':name},{'hasInput':true});
  jQuery("#job").show();
}


var send = true;
function sendToMobile(){
  if(send){
    $.ajax({
		 data:{"id":"<%=id%>","method":"sendMsg","content":"<%=SystemEnv.getHtmlLabelName(125304,user.getLanguage())%><%=address %>"},
		 type: "post",
		 cache:false,
		 url:"RdResourceOptAjax.jsp",
		 dataType: 'json',
		 async:false,
		 success:function(data){
		 	if(data.result){
				jQuery("#sendBefore").hide();
				jQuery("#sendAfter").show();
		 		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125305,user.getLanguage())%>',null,null,null,null,{_autoClose:3});
		 		send =false;
		 	}else{
		 		if(data.reason =="1"){
			 		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125306 ,user.getLanguage())%>',null,null,null,null,{_autoClose:3});
			 		jQuery("#sendBefore").hide();
				    jQuery("#sendAfter").show();
				    send =false;
		 		}else{
			 		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125307,user.getLanguage())%>',null,null,null,null,{_autoClose:3});
		 		}
		 	}
		}	
	   });
  }
}

</script>




</BODY>
</HTML>

