<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>
<%@taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RdeployTransMethod" class="weaver.rdeploy.hrm.RdeployTransMethod" scope="page" />
<jsp:useBean id="RdeployHrmSetting" class="weaver.rdeploy.hrm.RdeployHrmSetting" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";

String modename = SystemEnv.getHtmlLabelName(125212,user.getLanguage());
String modeurl = "/middlecenter/index.jsp";
String sumcomId = RdeployTransMethod.createSubByCompany();

boolean isadmin = true;

if(!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)){
    isadmin =false;
}

int uid = user.getUID();

String adminId = Util.null2String(RdeployHrmSetting.getSettingInfo("admin"));
//String adminId = "64228";
boolean canRe =false;
if(adminId.equals(uid+"") || uid == 1){
    canRe=true;
}
//canRe = true;
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
  	<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
  	<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
  	<script language="javascript" src="/rdeploy/assets/js/jquery.easing.1.3.js"></script>
  	<style>
  		.thisBack{
  			background-color: #F1F5F8;
  		}
  		.thisBack:hover{
  			background-color: #DAE3EA;
  		}
  	</style>
  </head>
  <body  style="overflow: hidden;">
  	<!-- 顶部 -->
  	<%--
	<jsp:include page="/rdeploy/indexTop.jsp" flush="false">
		<jsp:param name="modename" value="<%=modename %>"/>
		<jsp:param name="modeurl" value="<%=modeurl %>"/>
	</jsp:include>  
   --%>
<div id="context" style="position: absolute;width: 380px;height: 100%	;z-index: 4; border: 2px solid #e9e9e2;left: 100%;background-color: white;display: ;">
  <div style="width: 100%;height: 48px;background-color: #e9f2f2;"> 
  	<span style="float: left;padding-left: 20px;font-size: 14px;color: #526268;margin-top: 13px;"><%=SystemEnv.getHtmlLabelName(22836 ,user.getLanguage())%></span>
  	<span style="float: right;margin-right: 20px;margin-top: 13px;"><a href="javascript:closeInfo()"><img  src="/rdeploy/assets/img/hrm/deleteDept.png" width="12px;" onclick=""/></a></span>
  </div>
  <div id="resourceInfo" style="width: 380px;">
  	<table width="320px" style="font-size: 13px;margin-left: 30px;">
  	  <tr >
  	  	<td width="100%" align="center" style="padding: 40px 0 10px 0;">
  	  		<img id="image" src="" width="80px" onError="/messager/images/icon_m_wev8.jpg"/>
  	  		<div style="background:url('/rdeploy/assets/img/hrm/bighead.png');position: absolute;top:90px;left:150px;height:80px;width:80px;"></div>
  	  	</td>
  	  </tr>
  	  <tr >
  	    <td align="center" ><span style="color: #313131;" id="name" align="center"></span><span id="sex" style="color: #526268;padding-left: 7px;"></span></td>
  	  </tr>
  	  <tr id="sta">
  	    <td align="center" style="padding: 10px 0 0px 0px;"><span style="color: #526268;" id="states" align="center"></span></td>
  	  </tr>
  	  <tr >
  	    <td></td>
  	  </tr>
  	  <tr id="dept" style="border-bottom: 1px solid #e9f2f2;">
  	    <td align="left" style="color: #526268;padding: 20px 0 5px 0px;border-bottom: 1px solid #e9e9e2;"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><span id="depName" style="margin-left: 50px;color: #313131;"></span></td>
  	  </tr>
  	  <tr id="job" style="border-bottom: 1px solid #e9f2f2;">
  	    <td align="left" style="color: #526268;padding: 30px 0 5px 0;border-bottom: 1px solid #e9e9e2;"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%><span id="jobName" style="margin-left: 50px;color: #313131;"></span></td>
  	  </tr>
  	  <tr id="manager" style="border-bottom: 1px solid #e9f2f2;">
  	    <td align="left" style="color: #526268;padding: 30px 0 5px 0;border-bottom: 1px solid #e9e9e2;"><%=SystemEnv.getHtmlLabelName(15709 ,user.getLanguage())%><span id="managerName" style="margin-left: 24px;color: #313131;"></span></td>
  	  </tr>
  	  <tr id="mob" style="border-bottom: 1px solid #e9f2f2;">
  	    <td align="left" style="color: #526268;padding: 30px 0 5px ;border-bottom: 1px solid #e9e9e2;"><%=SystemEnv.getHtmlLabelName(125213,user.getLanguage())%><span id="mobile" style="margin-left: 50px;color: #313131;"></span></td>
  	  </tr>
  	  <tr id="pho" style="border-bottom: 1px solid #e9f2f2;">
  	    <td align="left" style="color: #526268;padding: 30px 0 5px 0;border-bottom: 1px solid #e9e9e2;"><%=SystemEnv.getHtmlLabelName(125214 ,user.getLanguage())%><span id="phone" style="margin-left: 50px;color: #313131;"></span></td>
  	  </tr>
  	  <tr id="eml" style="border-bottom: 1px solid #e9f2f2;">
  	    <td align="left" style="color: #526268;padding: 30px 0 5px 0;border-bottom: 1px solid #e9e9e2;"><%=SystemEnv.getHtmlLabelName(20869,user.getLanguage())%><span id="email" style="margin-left: 50px;color: #313131;"></span></td>
  	  </tr>
  	  
  	</table>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="width: 380px;">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    	<% if(isadmin){%>
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>" class="e8_btn_cancel" id="hrmedit" onclick="editHrmInfo()">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(125210,user.getLanguage())%>" id="operate" class="e8_btn_cancel" onclick="freeze()">
		    		<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" id="deloperate" style="display: none" class="e8_btn_cancel" onclick="deleteHrmResource()">
		    	<% }else{%>
		    	   <input type="button" value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>" style="display: none;" id="hrmedit" class="e8_btn_cancel" onclick="editHrmInfo()">
		    	   <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="operate" class="e8_btn_cancel" onclick="closeInfo()">
		    	<% }%>
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<div id="zDialog_div_bottom2" class="zDialog_div_bottom" style="width: 380px;display: none">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    	   <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="operate2" class="e8_btn_cancel" onclick="closeInfo()">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	<div id="zDialog_div_bottom3" class="zDialog_div_bottom" style="width: 380px;display: none">
		<wea:layout type="2col">
	    	<wea:group context="">
		    	<wea:item type="toolbar">
		    	   <input type="button" value="<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>"  id="hrmedit1" class="e8_btn_cancel" onclick="editHrmInfo()">
		    	   <input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="operate1" class="e8_btn_cancel" onclick="closeInfo()">
		    	</wea:item>
		   	</wea:group>
	  	</wea:layout>
	</div>
	
  </div>
</div>

<input type="hidden" id="hrmSId"/>
<input type="hidden" id="operateVal"/>
<div style="display: none;">
<brow:browser viewType="0"  name="resourceid" browserValue=""
  	    				   browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
						   hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='1'
						   completeUrl="/data.jsp" width="420px" dialogWidth="600px"
						   _callback="onDepartmentAdd" afterDelCallback=""
						   browserSpanValue="">
			</brow:browser>

</div>
		  <div style="text-align: center; width:100%;height: 50px;background-color: #F1F5F8;padding-top: -6px;border-bottom: 1px solid #d0dbe0;" onclick="closeInfo()">
			  <div style="width: 820px;float: right;">
				<span class="dbtn" style="float: right;margin: 7px;">
					<input type="text" class="rdeploycommoninputclass" height="" id="searchName" style="width:160px;height:30px; "/>
					<span id="searchBox" class="" style="position:relative ; right: 5px;padding: 9px 0 2.3px 8px;height: 38px;width: 40px; background-color:#FFFFFF ;top: 5px;border: 1px solid #e9e9e2;border-left: 0px;" onclick="search()" onmouseover="addBackColor()" onmouseout="removeBackColor()">
						<img id="searchImg" class="" src="/images/ecology8/request/search-input_wev8.png" >
					</span>
				</span>
			  	<span class="dbtn thisBack" id="inadvancedmode" style="margin: 7px;color: #1CA5EB;" onclick="doInvitationResource()">
			  		<img src="/rdeploy/assets/img/hrm/inv.png" width="16px" height="16px" align="absMiddle"><%=SystemEnv.getHtmlLabelName(125215,user.getLanguage())%>
			  	</span>
			  	<% if(isadmin){%>
			  	<span class="dbtn thisBack" id="inadvancedmode" style="margin: 7px;color: #357E22;" onclick="doHrmImport()">
			  		<img src="/rdeploy/assets/img/hrm/import.png" width="14px" height="14px" align="absMiddle"><%=SystemEnv.getHtmlLabelName(26601,user.getLanguage())%>
			  	</span>
			  	<span class="dbtn thisBack" id="inadvancedmode" onclick="doAdd()" style="margin: 7px;color: #3A72C7;">
			  		<img src="/rdeploy/assets/img/add.png" width="14px" height="14px" align="absMiddle" ><%=SystemEnv.getHtmlLabelName(125217,user.getLanguage())%>
			  	</span>
			  	<%} %>
			 </div>
			 
		 </div>
<script language="JavaScript">
var loginUserId = "<%=uid%>";
var adminId = "<%=adminId%>";
//if (window.jQuery.client.browser == "Firefox"||window.jQuery.client.browser == "Chrome") {
//		jQuery(document).ready(function () {
//			jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
//			window.onresize = function () {
//				jQuery("#leftframe,#middleframe,#contentframe").height(jQuery("#leftframe").parent().height());
//			};
//		});
//	}

    function onDepartmentAdd(e,datas,name){
    window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(125218,user.getLanguage())%>"+datas.name+"?",function(){
		if(datas.id !=""){
			 $.ajax({
				 data:{"id":datas.id,"language":"<%=user.getLanguage()%>"},
				 type: "post",
				 cache:false,
				 url:"transfermanager.jsp",
				 dataType: 'json',
				 async:true,
				 success:function(data){
				   if(data.success =="1"){
				      if(loginUserId !="1"){
					      window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125219,user.getLanguage())%>'+datas.name+'，<%=SystemEnv.getHtmlLabelName(125220,user.getLanguage())%>',null,null,null,null,{_autoClose:3});
					      setTimeout("logout()",500);
					      return;
				      }
					  window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125219,user.getLanguage())%>'+datas.name+'',null,null,null,null,{_autoClose:3});
				   }
				}	
			   });
		}
		
	  });
	}

    function logout(){
    	window.location.href = "/login/Logout.jsp";
    }

    function deleteHrmResource(){
      contentframe.deleteOpt(2,jQuery("#hrmSId").val());
    }

	document.onkeydown=function(event){
            var e = event || window.event || arguments.callee.caller.arguments[0];
            if(e && e.keyCode==27){ // 按 Esc 
                //要做的事情
              }
            if(e && e.keyCode==113){ // 按 F2 
                 //要做的事情
               }            
             if(e && e.keyCode==13){ // enter 键
                 search();
            }
        }; 
	
	function jsReloadTree(){
		document.getElementById('leftframe').contentWindow.initTree(); 
	}
	
	var selectDepId = "";
	function setDepId(id){
		selectDepId = id;
	}
	var dialog = new window.top.Dialog();
	
	function closeDialog(){
		if(dialog)
			dialog.close();
	}
	
	function doAdd(){
		if(dialog==null){
			dialog = new window.top.Dialog();
		}
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(1421,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%>";
	    dialog.URL = "hrm/RdResourceAdd.jsp";
		dialog.Width = 400;
		dialog.Height = 260;
		dialog.Drag = true;
		dialog.textAlign = "center";
		dialog.normalDialog = false;
		dialog.show();
	}
	function doHrmImport(){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26601,user.getLanguage())%>";
	  dialog.URL = "hrm/HrmImportFile.jsp";
		dialog.Width = 450;
		dialog.Height = 275;
		dialog.Drag = true;
		dialog.textAlign = "center";
		dialog.show();
	}
	
	function doHrmImportFieldSetting(){
		if(dialog) dialog.close();
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26601,user.getLanguage())%>";
	    dialog.URL = "hrm/HrmImportFieldSetting.jsp";
		dialog.Width = 655;
		dialog.Height = 455;
		dialog.Drag = true;
		dialog.textAlign = "center";
		dialog.show();
	}
	
	function doHrmImportView(){
		if(dialog) dialog.close();
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(26601,user.getLanguage())%>";
	  dialog.URL = "hrm/HrmImportView.jsp";
		dialog.Width = 655;
		dialog.Height = 555;
		dialog.Drag = true;
		dialog.textAlign = "center";
		dialog.show();
	}
	function showInfo(){
		var dialog1;
		if(dialog1==null){
			dialog1 = new window.top.Dialog();
		} 
		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125221,user.getLanguage())%>',null,null,null,null,{_autoClose:3});
		dialog.close();
	}
	
	function search(){
	  
	  jQuery("#contentframe").attr("src","HrmResourceList.jsp?name="+jQuery("#searchName").val().trim());
	}
	
	function addBackColor(){
	  jQuery("#searchBox").css("background-color","#d7d9e0");
	  jQuery("#searchImg").attr("src","/rdeploy/assets/img/hrm/search.png");
	  jQuery("#searchImg").attr("width","16");
	}
	function removeBackColor(){
	  jQuery("#searchBox").css("background-color","#FFFFFF");
	  jQuery("#searchImg").attr("src","/images/ecology8/request/search-input_wev8.png");
	}
	
var resourceInfo="";

var wWidth= window.parent.innerWidth;
	
function floatTo(){
	$("#context").animate({ 
	  left: wWidth-380
	},{ 
	  duration: 500, 
	  easing: "swing", 
	  complete: easeInOutBack1
	}); 
	//$("#context").animate({ 
	//    left:[wWidth-380, 'easeInOutBack'],
	//},1000); 
	
}
function easeInOutBack1(){
	getInfo();
}

function getInfo(){
	if(resourceInfo == null){
		setTimeOut("getInfo()",200);
	}else{
		jQuery("#resourceInfo").css("display","");
		insertValue();
	}
}

var thisType;
function insertValue(){
		jQuery("#image").attr("src",resourceInfo.messageUrl);
		var thisName = resourceInfo.name;
		if(resourceInfo.isadmin){
		    thisName+=" <%=SystemEnv.getHtmlLabelName(125208,user.getLanguage())%>";
		}else{
			if(resourceInfo.lastlogindate == ""){
				thisName+=" <%=SystemEnv.getHtmlLabelName(125209,user.getLanguage())%>";
			}
		}
		jQuery("#name").html(thisName);
		if(resourceInfo.sex!=""){
			jQuery("#sex").html(resourceInfo.sex=='0'?'(<%=SystemEnv.getHtmlLabelName(28473,user.getLanguage())%>)':'(<%=SystemEnv.getHtmlLabelName(125223 ,user.getLanguage())%>)');
			jQuery("#sex").css("display","");
		}else{
			jQuery("#sex").css("display","none");
		}
		if(resourceInfo.states!="" && resourceInfo.states=="<%=SystemEnv.getHtmlLabelName(125210,user.getLanguage())%>"){
			jQuery("#states").html(resourceInfo.states);
			jQuery("#sta").css("display","");
		}else{
			jQuery("#sta").css("display","none");
		}
		if(resourceInfo.depName!=""){
			jQuery("#depName").html(resourceInfo.depName);
			jQuery("#dept").css("display","");
		}else{
			jQuery("#dept").css("display","none");
		}
		if(resourceInfo.jobName!=""){
			jQuery("#jobName").html(resourceInfo.jobName);
			jQuery("#job").css("display","");
		}else{
			jQuery("#job").css("display","none");
		}
		if(resourceInfo.managerName!=""){
			jQuery("#managerName").html(resourceInfo.managerName);
			jQuery("#manager").css("display","");
		}else{
			jQuery("#manager").css("display","none");
		}
		if(resourceInfo.mobile!=""){
			jQuery("#mobile").html(resourceInfo.mobile);
			jQuery("#mob").css("display","");
		}else{
			jQuery("#mob").css("display","none");
		}
		if(resourceInfo.phone!=""){
			jQuery("#phone").html(resourceInfo.phone);
			jQuery("#pho").css("display","");
		}else{
			jQuery("#pho").css("display","none");
		}
		if(resourceInfo.email!=""){
			jQuery("#email").html(resourceInfo.email);
			jQuery("#eml").css("display","");
		}else{
			jQuery("#eml").css("display","none");
		}
		<% if(isadmin){%>
		<% 
		if(canRe){
		//if(true){
		%>
		  if(jQuery("#hrmSId").val() == adminId){
		  //if(jQuery("#hrmSId").val() == "64228"){
		 	jQuery("#operate").val("<%=SystemEnv.getHtmlLabelName(125222 ,user.getLanguage())%>");
			jQuery("#operateVal").val("transfer");
			jQuery("#operate").attr("disabled","");
			jQuery("#deloperate").hide();
			$("#deloperate").prev().hide();
			$("#zDialog_div_bottom2").hide();
			$("#zDialog_div_bottom3").hide();
			$("#zDialog_div_bottom").show();
			return;
		 }
		<%}%>
		
		if(resourceInfo.isadmin){
			if(loginUserId == "1"){
			  $("#zDialog_div_bottom3").show();
			  return;
			}
		    $("#zDialog_div_bottom").hide();
			$("#zDialog_div_bottom2").show();
		    return;
		}else{
		    $("#zDialog_div_bottom2").hide();
		    $("#zDialog_div_bottom3").hide();
			$("#zDialog_div_bottom").show();
		}
		
		if(resourceInfo.lastlogindate == ""){
			//if(resourceInfo.canSend == "2"){
			//	jQuery("#operate").val("发送激活短信");
			//	jQuery("#operateVal").val("sendMsg");
			//	jQuery("#operate").attr("disabled","");
			//}else if(resourceInfo.canSend == "1"){
				//jQuery("#operate").val("已发送激活短信");
				//jQuery("#operate").attr("disabled","disabled");
				//jQuery("#operate").attr("class","e8_btn_cancel");
			//}
			jQuery("#operate").val("<%=SystemEnv.getHtmlLabelName(125224,user.getLanguage())%>");
			jQuery("#operateVal").val("sendMsg");
			jQuery("#operate").attr("disabled","");
			jQuery("#deloperate").show();
			$("#deloperate").prev().show();
		}else{
			if(resourceInfo.status=="7"){
				jQuery("#operate").val("<%=SystemEnv.getHtmlLabelName(125225,user.getLanguage())%>");
				jQuery("#operateVal").val("unfreeze");
				
			}else{
				jQuery("#operate").val("<%=SystemEnv.getHtmlLabelName(125210,user.getLanguage())%>");
				jQuery("#operateVal").val("freeze");
			}
			if(resourceInfo.type == "4"){
				jQuery("#deloperate").show();
				$("#deloperate").prev().show();
		  		
			}else{
				jQuery("#deloperate").hide();
				$("#deloperate").prev().hide();
			}
		}
		<%}else{%>
		 if(jQuery("#hrmSId").val() == loginUserId){
		 	jQuery("#hrmedit").show();
		 	$("#hrmedit").next().show();
		 }else{
		 	jQuery("#hrmedit").hide();
		 	$("#hrmedit").next().hide();
		 }
		<%}%>
}



function closeInfo(){
	jQuery("#context").hide();
	jQuery("#context").css("left",wWidth);
}

function init(id){
	resourceInfo ="";
	if(jQuery("#hrmSId").val() != id || jQuery("#context").css("display") == "none"){
		jQuery("#context").show();
		jQuery("#context").css("left","100%");
		jQuery("#resourceInfo").css("display","none");
		jQuery("#hrmSId").val(id);
		floatTo();
	}
}

function editHrmInfo(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	dialog.Width = 600;
	dialog.Height = 580;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(125226,user.getLanguage())%>";
	url = "hrm/RdResourceEdit.jsp?id="+jQuery("#hrmSId").val();
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}


function editSuccess(id,depid){
  dialog.close();
  if(thisType == "2"&&depid !=""){
	   closeInfo();
	   contentframe._table.reLoad();
	   return;
	}
  $.ajax({
		 data:{"id":id,"language":"<%=user.getLanguage()%>"},
		 type: "post",
		 cache:false,
		 url:"RdResourceShow.jsp",
		 dataType: 'json',
		 async:true,
		 success:function(data){
		  resourceInfo=data;
		  insertValue();
		}	
	   });
	contentframe._table.reLoad();
}
var state;



function freeze(){
	var opt = jQuery("#operateVal").val();
	
	if(opt =="transfer"){
		//window.top.Dialog.confirm("将管理员权限移交给其他成员后，您将不再是管理员",function(){
			$("#resourceid_browserbtn").click();
		   // return;
	  // });
	   return;
	}
	if(opt =="sendMsg"){
		dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		var url = "";
		dialog.Width = 600;
		dialog.Height = 390;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(125224,user.getLanguage())%>";
		url = "hrm/RdSendMsgPage.jsp?id="+jQuery("#hrmSId").val();
		dialog.Drag = true;
		dialog.URL = url;
		dialog.show();
	   return;
	}

	var msg = "";
	if(opt =="freeze"){
		msg = "<%=SystemEnv.getHtmlLabelName(125197,user.getLanguage())%>";
	}
	if(opt =="unfreeze"){
		msg = "<%=SystemEnv.getHtmlLabelName(125199,user.getLanguage())%>";
	}
	window.top.Dialog.confirm(msg,function(){
		 $.ajax({
		 data:{"id":jQuery("#hrmSId").val(),"state":state,"method":opt,"type":"2"},
		 type: "post",
		 cache:false,
		 url:"RdResourceOptAjax.jsp",
		 dataType: 'json',
		 async:false,
		 success:function(data){
		 	if(data.result){
		 		jQuery("#context").hide();
			 	contentframe._table.reLoad();
		 	}else{
		 		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83912,user.getLanguage())%>',null,null,null,null,{_autoClose:3});
		 	}
		}	
	   });
	});
}


function doInvitationResource(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	dialog.Width = 600;
	dialog.Height = 390;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(125227,user.getLanguage())%>";
	url = "hrm/RdInvitationResource.jsp";
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
</script>   
<div style="position:absolute;width:100%;top:50px;bottom:0px;">
<TABLE width=100% id=oTable1 height=100% cellpadding="0px" cellspacing="0px">

  <TBODY>
<tr><td  height=100% id=oTd1 name=oTd1 width="246px" style="border-right:0px;padding-top: 0px;" >
<IFRAME name=leftmenuframe id=leftmenuframe src="HrmCompany_left.jsp?subcomid=<%=sumcomId %>&deptid=&nodeid=&rightStr=HrmResourceAdd:Add" style="vertical-align: top;" width="100%" height="100%" frameborder=no scrolling=no>
</IFRAME>
</td>
<td height=95% id=oTd2 name=oTd2 width="*" id="tdcontent" valign="top" >
<IFRAME name=contentframe id=contentframe  src="HrmResourceList.jsp?subCompanyId=<%=sumcomId %>" width="100%" height="100%" style="vertical-align: top;border-left:  1px solid #e9f2f2;"  frameborder=no scrolling=no>
</IFRAME>
</td>
</tr>
  </TBODY>
</TABLE>
</div>



  </body>
</html>
