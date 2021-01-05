
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="java.text.DateFormat"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="RdeployHrmSetting" class="weaver.rdeploy.hrm.RdeployHrmSetting" scope="page" />
<%

String onoff = RdeployHrmSetting.getSettingInfo("onoff");


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(357,user.getLanguage());
String needfav ="1";
String needhelp ="";
String name = Util.null2String(request.getParameter("name"));
int id = Util.getIntValue(request.getParameter("id"),0);
int subCompanyId = Util.getIntValue(request.getParameter("subCompanyId"),0);
int type = Util.getIntValue(request.getParameter("type"),0);
String ids = "";
if(id != 0){
 ids=id+"";
}
//int companyid=Util.getIntValue(SubCompanyComInfo.getCompanyid(""+id),0);

boolean isadmin = true;

if(!HrmUserVarify.checkUserRight("HrmResourceEdit:Edit", user)){
    isadmin =false;
}

%>

<HTML><HEAD>
<style>
.listImage{
   
}
.listImagetd{
	padding-left: 0px;
}

.ListStyle  td #resourceOpt {
	display: none;
}
.ListStyle .Selected .nameContent td {
	background:none!important;
}
.ListStyle .Selected .listImage {
	background:#fffcf0!important;
}

.thisBack{
	background-color: #F8F8F8;
}
.thisBack:hover{
	background-color: #DAE3EA;
}

</style>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/rdeploy/assets/css/index.css" rel="stylesheet" type="text/css">
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<script type="text/javascript">

jQuery(document).ready(function(){
	setTimeout("addOp()",100);
	//if(wHeight<600){
	var wHeight= window.parent.innerHeight;
	  $(".table").css("max-height",(wHeight-200)+"px");
	//}
});
function onBtnSearchClick(){
	jQuery("#searchfrm").submit();
}
var dialog = null;
function closeDialog(){
	if(dialog)
		dialog.close();
}

function openDialog(cmd,id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	if(cmd==null)cmd="";
	if(id==null)id="";
	var url = "";
	dialog.Width = 800;
	dialog.Height = 1000;
	dialog.maxiumnable=true;
	if(cmd=="editHrmResource"){
		dialog.Title = "<%=SystemEnv.getHtmlLabelNames("93,30042", user.getLanguage())%>";
		url = "/hrm/HrmTab.jsp?_fromURL=HrmResource&isdialog=1&isView=0&id="+id;
	}
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
var resourceInfo="";
function editHrmResource(id)
{	
	window.parent.resourceInfo= null;
	window.parent.init(id);
	window.parent.thisType = "<%=type %>";
	$.ajax({
		 data:{"id":id,"language":"<%=user.getLanguage()%>","type":"<%=type %>"},
		 type: "post",
		 cache:false,
		 url:"RdResourceShow.jsp",
		 dataType: 'json',
		 async:false,
		 success:function(data){
		  window.parent.resourceInfo=data;
		  //window.parent.easeInOutBack();
		}	
	   });
	//openFullWindowForXtable("/hrm/HrmTab.jsp?_fromURL=HrmResource&id="+id);
}


function editHrmInfo(){
  window.parent.editHrmInfo();
}
function onLog(id){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	var url = "";
	if(id && id!=""){
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=29 and relatedid=")%>&relatedid="+id;
	}else{
		url = "/docs/tabs/DocCommonTab.jsp?_fromURL=3&isdialog=1&secid=65&sqlwhere=<%=xssUtil.put("where operateitem=29")%>";
	}
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%>";
	dialog.Width = jQuery(window).width();
	dialog.Height = jQuery(window).height();
	dialog.Drag = true;
	dialog.maxiumnable = true;
	dialog.URL = url;
	dialog.show();
}

function addHrmResource(){
 	window.parent.parent.location.href="/hrm/resource/HrmResource_frm.jsp?departmentid=<%=id%>";
}

function setVirtualDepartment(){
	var resourceids = _xtable_CheckedCheckboxId();
	if(resourceids.match(/,$/)){
		resourceids = resourceids.substring(0,resourceids.length-1);
	}
	if(resourceids==null||resourceids==""){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(34095,user.getLanguage())%>");
		return;
	}
	
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "/hrm/HrmDialogTab.jsp?_fromURL=setDepartmentVirtual&isdialog=1&resourceids="+resourceids;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(34100,user.getLanguage())%>";
	dialog.Width = 500;
	dialog.Height = 203;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}



function addOp(){
		//if(jQuery(".table").html() != ""&& jQuery(".e8EmptyTR").html() == null){
		if(!_table.loading){
			
		    <% if(isadmin){%>
			if(jQuery("#optDiv").html() == null && jQuery(".e8EmptyTR").html() == null){
				jQuery(".table").after("<div class='xTable_info' id='optDiv'  style='width:100%;text-align:center;padding-top:10px;height:18px;color:#545454;font-size:13px;'><div id='showOpt' style='display:none;width:100%'><%=SystemEnv.getHtmlLabelName(125184,user.getLanguage())%>&nbsp;&nbsp;&nbsp;<a href='javascript:changeDept()' style='color:#4b78ee;'><%=SystemEnv.getHtmlLabelName(24277,user.getLanguage())%></a>、&nbsp;<a href='javascript:changeManage()' style='color:#4b78ee;'><%=SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></a></div></div>");
			}
			var wHeight= window.parent.innerHeight;
		    $(".table").css("max-height",(wHeight-200)+"px");
			
			//$(".ListStyle tr").click(function () {
			//	if($(this).attr("class") =="jNiceWrapper" || $(this).find(".jNiceChecked").html() != null || $(this).find(".jNiceChecked").html() == ''){
			//		return;
			//	}
			//	var id = $(this).find("input[name=chkInTableTag]").attr("checkboxid");
			//	editHrmResource(id);
			//});
			
			
			$(".jNiceWrapper").click(function () {
					var ids = _xtable_CheckedCheckboxId();
					if(ids != ""){
						$("#showOpt").show();
					}else{
						$("#showOpt").hide();
					}
			});
		<%}%>
			
			$(".e8_pageinfo").click(function () {
					setTimeout("addOp()",100);
			});
			
			$(".ListStyle tr").hover(function () {
				$(this).find("#resourceOpt").show();
			}, function () {
				$(this).find("#resourceOpt").hide();
			});
			
			
		}else{
			setTimeout("addOp()",100);
		}
}

setInterval('var wHeight= window.parent.innerHeight; $(".table").css("max-height",(wHeight-200)+"px");',500);



function changeDept(){
	var ids = _xtable_CheckedCheckboxId();
	if(ids == ""){
	   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125185,user.getLanguage())%>");
	   return;
	}
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "hrm/RdChangeDept.jsp?ids="+ids;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(125187,user.getLanguage())%>";
	dialog.normalDialog = false;
	dialog.Width = 400;
	dialog.Height = 223;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function changeManage(){
	var ids = _xtable_CheckedCheckboxId();
	if(ids == ""){
	   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125185,user.getLanguage())%>");
	   return;
	}
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "hrm/RdChangeManager.jsp?ids="+ids;
	dialog.Title = "<%=SystemEnv.getHtmlLabelName(27827,user.getLanguage())%>";
	dialog.normalDialog = false;
	dialog.Width = 400;
	dialog.Height = 223;
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}

function reloadTable(){
	_table.reLoad();
	setTimeout("addOp()",100);
	window.parent.closeInfo();
}

var ocState = "<%=onoff%>"; 
var changging = 1;
function openOrClose(){
	if(changging == 2){
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125190,user.getLanguage())%>");
		return ;
	}
	var ids = _xtable_CheckedCheckboxId();
	var unids = _xtable_unCheckedCheckboxId();
	if(ocState=="1"){
	  if(ids == "" && unids == ""){
	  	  changging =2;
			$.ajax({
				 data:{"id":"","language":"<%=user.getLanguage()%>"},
				 type: "post",
				 cache:false,
				 url:"changeonoff.jsp",
				 dataType: 'json',
				 async:false,
				 success:function(data){
				   if(data.success == "1"){
				 	jQuery("#close").show();
					jQuery("#open").hide();
					jQuery("#isOpen").hide();
					jQuery("#isClose").show();
					ocState="2";
					_table.reLoad();
					setTimeout("addOp()",100);
				   }else{
				   		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125191 ,user.getLanguage())%>");
				   }
				   changging =1;
				}	
			  });
			  
	  }else{
		window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(125192,user.getLanguage())%>",function(){
			changging =2;
			$.ajax({
				 data:{"id":"","language":"<%=user.getLanguage()%>"},
				 type: "post",
				 cache:false,
				 url:"changeonoff.jsp",
				 dataType: 'json',
				 async:false,
				 success:function(data){
				   if(data.success == "1"){
				 	jQuery("#close").show();
					jQuery("#open").hide();
					jQuery("#isOpen").hide();
					jQuery("#isClose").show();
					ocState="2";
					_table.reLoad();
					setTimeout("addOp()",100);
				   }else{
				   		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125191,user.getLanguage())%>");
				   }
				   changging =1;
				}	
			  });
		});
	  }
	}else{
	  if(ids == "" && unids == ""){
	  	changging =2;
				$.ajax({
					 data:{"id":"","language":"<%=user.getLanguage()%>"},
					 type: "post",
					 cache:false,
					 url:"changeonoff.jsp",
					 dataType: 'json',
					 async:false,
					 success:function(data){
					   if(data.success == "1"){
					 	jQuery("#close").hide();
						jQuery("#open").show();
						jQuery("#isOpen").show();
						jQuery("#isClose").hide();
						ocState="1";
						_table.reLoad();
						setTimeout("addOp()",1000);
					   }else{
					   		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125191,user.getLanguage())%>");
					   }
					   changging =1;
					}	
				  });
	  }else{
		  window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(125193 ,user.getLanguage())%>",function(){
			changging =2;
				$.ajax({
					 data:{"id":"","language":"<%=user.getLanguage()%>"},
					 type: "post",
					 cache:false,
					 url:"changeonoff.jsp",
					 dataType: 'json',
					 async:false,
					 success:function(data){
					   if(data.success == "1"){
					 	jQuery("#close").hide();
						jQuery("#open").show();
						jQuery("#isOpen").show();
						jQuery("#isClose").hide();
						ocState="1";
						_table.reLoad();
						setTimeout("addOp()",1000);
					   }else{
					   		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125191,user.getLanguage())%>");
					   }
					   changging =1;
					}	
				  });
		});
	}
  }
}

function pass(type,id){
	var msg = "";
	var thisId_;
	if(type =="1"){
		var ids = _xtable_CheckedCheckboxId();
		if(ids == ""){
		   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125185 ,user.getLanguage())%>");
		   return;
		}
		thisId_ = ids;
		//msg ="冻结后，选中人员将不能登录系统，是否确定冻结？";
	}else{
		thisId_=id;
		//msg ="冻结后，该人员将不能登录系统，是否确定冻结？";
	}
	//window.top.Dialog.confirm(msg,function(){
		 $.ajax({
		 data:{"id":thisId_,"state":"","method":"passOpt","type":type},
		 type: "post",
		 cache:false,
		 url:"RdResourceOptAjax.jsp",
		 dataType: 'json',
		 async:false,
		 success:function(data){
		 	if(data.result){
			 	reloadTable();
			 	_xtable_CleanCheckedCheckbox();
		 	}else{
		 		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83912,user.getLanguage())%>',null,null,null,null,{_autoClose:3});
		 	}
		}	
	   });
	//});
	
	
}

function refuse(type,id,obj){
		var msg = "";
	var thisId_;
	if(type =="1"){
		var ids = _xtable_CheckedCheckboxId();
		if(ids == ""){
		   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125185 ,user.getLanguage())%>");
		   return;
		}
		thisId_ = ids;
		msg ="<%=SystemEnv.getHtmlLabelName(125194,user.getLanguage())%>";
	}else{
		thisId_=id;
		msg ="<%=SystemEnv.getHtmlLabelName(125195 ,user.getLanguage())%>";
	}
	window.top.Dialog.confirm(msg,function(){
		 $.ajax({
		 data:{"id":thisId_,"state":"","method":"refuse","type":type},
		 type: "post",
		 cache:false,
		 url:"RdResourceOptAjax.jsp",
		 dataType: 'json',
		 async:false,
		 success:function(data){
		 	if(data.result){
			 	reloadTable();
			 	_xtable_CleanCheckedCheckbox();
		 	}else{
		 		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83912,user.getLanguage())%>',null,null,null,null,{_autoClose:3});
		 	}
		}	
	   });
	});
	
}

function freeze(type,id,obj){
	var msg = "";
	var thisId_;
	if(type =="1"){
		var ids = _xtable_CheckedCheckboxId();
		if(ids == ""){
		   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125185 ,user.getLanguage())%>");
		   return;
		}
		thisId_ = ids;
		msg ="<%=SystemEnv.getHtmlLabelName(125196,user.getLanguage())%>";
	}else{
		thisId_=id;
		msg ="<%=SystemEnv.getHtmlLabelName(125197,user.getLanguage())%>";
	}
	window.top.Dialog.confirm(msg,function(){
		 $.ajax({
		 data:{"id":thisId_,"state":"","method":"freeze","type":type},
		 type: "post",
		 cache:false,
		 url:"RdResourceOptAjax.jsp",
		 dataType: 'json',
		 async:false,
		 success:function(data){
		 	if(data.result){
			 	reloadTable();
		 		if(type =="1"){
			 		_xtable_CleanCheckedCheckbox();
		 		}else{
		 			$(obj).hide();
		 			$(obj).prev("#unfreeze").show();
		 		}
		 	}else{
		 		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83912,user.getLanguage())%>',null,null,null,null,{_autoClose:3});
		 	}
		}	
	   });
	});
	
}

function unfreeze(type,id,obj){
	var msg = "";
	var thisId_;
	if(type =="1"){
		var ids = _xtable_CheckedCheckboxId();
		if(ids == ""){
		   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125185 ,user.getLanguage())%>");
		   return;
		}
		thisId_ = ids;
		msg = "<%=SystemEnv.getHtmlLabelName(125198 ,user.getLanguage())%>";
	
	}else{
		thisId_=id;
		msg ="<%=SystemEnv.getHtmlLabelName(125199 ,user.getLanguage())%>";
	}
	window.top.Dialog.confirm(msg,function(){
		 $.ajax({
		 data:{"id":thisId_,"state":"","method":"unfreeze","type":type},
		 type: "post",
		 cache:false,
		 url:"RdResourceOptAjax.jsp",
		 dataType: 'json',
		 async:false,
		 success:function(data){
		 	if(data.result){
		 		reloadTable();
		 		if(type =="1"){
			 		_xtable_CleanCheckedCheckbox();
		 		}else{
		 			$(obj).hide();
		 			$(obj).next("#freeze").show();
		 		}
		 	}else{
		 		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83912,user.getLanguage())%>',null,null,null,null,{_autoClose:3});
		 	}
		}	
	   });
	});
}

function deleteOpt(type,id){
	var msg = "";
	var thisId_;
	if(type =="1"){
		var ids = _xtable_CheckedCheckboxId();
		if(ids == ""){
		   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125185 ,user.getLanguage())%>");
		   return;
		}
		thisId_ = ids;
		msg = "<%=SystemEnv.getHtmlLabelName(125200 ,user.getLanguage())%>";
	
	}else{
		thisId_=id;
		msg ="<%=SystemEnv.getHtmlLabelName(125201,user.getLanguage())%>";
	}
	window.top.Dialog.confirm(msg,function(){
		 $.ajax({
		 data:{"id":thisId_,"state":"","method":"deleteOpt","type":type},
		 type: "post",
		 cache:false,
		 url:"RdResourceOptAjax.jsp",
		 dataType: 'json',
		 async:false,
		 success:function(data){
		 	if(data.result){
			 	reloadTable();
			 	_xtable_CleanCheckedCheckbox();
		 	}else{
		 		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83912,user.getLanguage())%>',null,null,null,null,{_autoClose:3});
		 	}
		}	
	   });
	});
	
}

function clearOpt(){
	var ids = _xtable_CheckedCheckboxId();
	if(ids == ""){
	   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125185 ,user.getLanguage())%>");
	   return;
	}
	$.ajax({
		 data:{"id":ids,"state":"","method":"clearOpt","type":""},
		 type: "post",
		 cache:false,
		 url:"RdResourceOptAjax.jsp",
		 dataType: 'json',
		 async:false,
		 success:function(data){
		 	if(data.result){
		 		reloadTable();
		 		_xtable_CleanCheckedCheckbox();
		 	}else{
		 		window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(83912,user.getLanguage())%>',null,null,null,null,{_autoClose:3});
		 	}
		}	
	   });
	
}

</script>
</head>
<body style="margin: 1px 0 0 0;">
<%if(isadmin){ if(type == 3){%>
<div style="width: 100%;height: 45px;background-color: #f8f8f8;margin: 0 0 0 0;">
  <table width="100%" height="45px">
  	<tr>
  	 <td style=" color: #556266;padding: 0 0 0 30px;font-size: 13px;width: 100px;"><%=SystemEnv.getHtmlLabelName(125202,user.getLanguage())%></td>
  	 <td style=" text-align: left;">
  	 	<span class="dbtn" id="inadvancedmode"  onclick="openOrClose()" style="margin: 0px 30px 0 0;float: left;padding:0 0 0 5px;">
  	 		<% if("1".equals(onoff)){ %>
		  		<img id="close" src="/rdeploy/assets/img/hrm/close.png" style="display: none;" width="64px" height="30px" align="absMiddle" >
		  		<img id="open" src="/rdeploy/assets/img/hrm/open.png" width="64px" height="30px" align="absMiddle" >
	  		<%}else{ %>
		  		<img id="close" src="/rdeploy/assets/img/hrm/close.png"  width="64px" height="30px" align="absMiddle" >
		  		<img id="open" src="/rdeploy/assets/img/hrm/open.png" style="display: none;" width="64px" height="30px" align="absMiddle" >
	  		<%} %>
	  	</span> 
	  </td>
  	 <td style="">
  		<% if("1".equals(onoff)){ %>
  		<div id="isOpen">
	  	 	<span class="dbtn thisBack" id="inadvancedmode" onclick="refuse(1,-1)" style="margin: 0px 30px 0 0;color:#9099A2;">
		  		<img src="/rdeploy/assets/img/hrm/delete.png" width="14px" height="14px" align="absMiddle" ><%=SystemEnv.getHtmlLabelName(25659,user.getLanguage())%>
		  	</span>
	  	 	<span class="dbtn thisBack" id="inadvancedmode" onclick="pass(1,-1)" style="margin: 0px 15px 0 0;color:#3D71C5;">
		  		<img src="/rdeploy/assets/img/hrm/ok.png" width="14px" height="14px" align="absMiddle" ><%=SystemEnv.getHtmlLabelName(125203,user.getLanguage())%>
		  	</span>
	  	</div>
  		<div id="isClose" style="display: none;">
	  		<span class="dbtn thisBack" id="inadvancedmode" onclick="deleteOpt(1,-1)" style="margin: 0px 30px 0 0;color:#9099A2;">
		  		<img src="/rdeploy/assets/img/hrm/delete.png" width="14px" height="14px" align="absMiddle" ><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
		  	</span>
	  	 	<span class="dbtn thisBack" id="inadvancedmode" onclick="freeze(1,-1,this)" style="margin: 0px 15px 0 0;color:#B9742F;">
		  		<img src="/rdeploy/assets/img/hrm/freeze.png" width="14px" height="14px" align="absMiddle" ><%=SystemEnv.getHtmlLabelName(125204,user.getLanguage())%>
		  	</span>
	  	 	<span class="dbtn thisBack" id="inadvancedmode" onclick="clearOpt()" style="margin: 0px 15px 0 0;color:#3D71C5;">
		  		<img src="/rdeploy/assets/img/hrm/ok.png" width="14px" height="14px" align="absMiddle" ><%=SystemEnv.getHtmlLabelName(125205,user.getLanguage())%>
		  	</span>
	  	</div>
  		<%}else{ %>
  		<div id="isOpen" style="display: none;">
	  	 	<span class="dbtn thisBack" id="inadvancedmode" onclick="refuse(1,-1)" style="margin: 0px 30px 0 0;color:#9099A2;">
		  		<img src="/rdeploy/assets/img/hrm/delete.png" width="14px" height="14px" align="absMiddle" ><%=SystemEnv.getHtmlLabelName(25659,user.getLanguage())%>
		  	</span>
	  	 	<span class="dbtn thisBack" id="inadvancedmode" onclick="pass(1,-1)" style="margin: 0px 15px 0 0;color:#3D71C5;">
		  		<img src="/rdeploy/assets/img/hrm/ok.png" width="14px" height="14px" align="absMiddle" ><%=SystemEnv.getHtmlLabelName(125203,user.getLanguage())%>
		  	</span>
	  	</div>
  		<div id="isClose" >
	  		<span class="dbtn thisBack" id="inadvancedmode" onclick="deleteOpt(1,-1)" style="margin: 0px 30px 0 0;color:#9099A2;">
		  		<img src="/rdeploy/assets/img/hrm/delete.png" width="14px" height="14px" align="absMiddle" ><%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>
		  	</span>
	  	 	<span class="dbtn thisBack" id="inadvancedmode" onclick="freeze(1,-1,this)" style="margin: 0px 15px 0 0;color:#B9742F;">
		  		<img src="/rdeploy/assets/img/hrm/freeze.png" width="14px" height="14px" align="absMiddle" ><%=SystemEnv.getHtmlLabelName(125204,user.getLanguage())%>
		  	</span>
	  	 	<span class="dbtn thisBack" id="inadvancedmode" onclick="clearOpt()" style="margin: 0px 15px 0 0;color: #3D71C5;">
		  		<img src="/rdeploy/assets/img/hrm/ok.png" width="14px" height="14px" align="absMiddle" ><%=SystemEnv.getHtmlLabelName(125205,user.getLanguage())%>
		  	</span>
	  	</div>
  		<%} %>
  	 </td>
  	</tr>
  </table>
</div>
<%}} %>
<FORM name="searchfrm" id="searchfrm" method=post >

 <%
//姓名	编号	性别	直接上级	岗位	登录名	   安全级别	   显示顺序	
String backfields = "  r.id,r.lastlogindate, r.lastname,r.messagerurl,r.mobile,r.sex , r.jobtitle,  r.status,d.departmentname  "; 
String fromSql  = " from HrmResource r left join hrmdepartment d on r.departmentid=d.id ";
//String sqlWhere = " where departmentid in ("+DepartmentComInfo.getAllChildDepartId(""+id,""+id)+")";
String sqlWhere = " where 1=1 ";

if(!"".equals(name)){
    sqlWhere+=" and (r.lastname like '%"+name+"%' or r.mobile like '%"+name+"%' or r.pinyinlastname like '%"+name+"%')";
    if(!isadmin){
        sqlWhere+=" and lastlogindate is not null ";
    }
}
if(!"".equals(ids)){
    sqlWhere+=" and r.departmentid = "+ids+"  and r.status !=7";
    if(!isadmin){
        sqlWhere+=" and lastlogindate is not null ";
    }
}
String state="";
String isNoAllot = "";
if(type == 1){ //通过部门查找用户
    //sqlWhere += " and r.status in (0,1,2,3,8)";
    //sqlWhere += "  "; //缺少未激活判断
}else if(type == 2){ //未分配人员
    //isNoAllot= " and notallot = 1  or (r.departmentid =0 or r.departmentid is null)";
    isNoAllot= " and  (r.departmentid =0 or r.departmentid is null) and r.isnewuser is null";
}else if(type == 3){ //新用户
    sqlWhere += " and r.isnewuser is not null "; //缺少时间判断and createdate >= ''
    if(onoff == "2"){
        try{
	        Calendar calendar = Calendar.getInstance();
	        calendar.set(Calendar.DAY_OF_MONTH,Calendar.DAY_OF_MONTH-7);
	        DateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	        sqlWhere += " and r.createdate > '"+format.format(calendar.getTime())+"'"; 
        }catch(Exception e){
            
        }
    }
}else if(type == 4){ //失效用户
    sqlWhere += " and r.status =7 and r.isnewuser is null";
}
if(subCompanyId !=0){
    sqlWhere += " and r.subcompanyid1 = "+subCompanyId +"  and r.status !=7";
    if(!isadmin){
        sqlWhere+=" and lastlogindate is not null ";
    }
}
if(!"".equals(state)){
    
}
if(!"".equals(isNoAllot)){
    sqlWhere += " "+isNoAllot+" ";
}

String orderby = " r.dsporder " ;
String tableString = "";

//编辑    日志
//操作字符串
String  operateString= "";
operateString = "";
 
 	      tableString =" <table pageId=\""+PageIdConst.HRM_ResourceList+"\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.HRM_ResourceList,user.getUID(),PageIdConst.HRM)+"\" >"+
 			"	   <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"r.id\" sqlsortway=\"Asc\" sqlisdistinct=\"false\"/>";
 	if(type == 3 && isadmin){		
 		tableString+= operateString+
 	    "			<head>"+
 	    "				<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"id\" orderkey=\"lastname\" transmethod=\"weaver.rdeploy.hrm.RdeployTransMethod.getHrmEditHrmResourceName\"  otherpara=\"column:lastlogindate+"+user.getLanguage()+"\" />"+
 	    "				<col width=\"18%\" text=\""+SystemEnv.getHtmlLabelName(422,user.getLanguage())+"\" column=\"mobile\" transmethod=\"weaver.rdeploy.hrm.RdeployTransMethod.getHrmHrmResourceMobile\" otherpara=\"column:id\"    orderkey=\"mobile\"/>"+
 	    "				<col width=\"18%\" text=\""+SystemEnv.getHtmlLabelName(416,user.getLanguage())+"\" column=\"sex\" transmethod=\"weaver.rdeploy.hrm.RdeployTransMethod.getHrmHrmResourceSex\" otherpara=\"column:id\"  orderkey=\"sex\"/>"+
 	    "				<col width=\"18%\" text=\""+SystemEnv.getHtmlLabelName(27511,user.getLanguage())+"\" column=\"departmentname\" transmethod=\"weaver.rdeploy.hrm.RdeployTransMethod.getHrmHrmResourceDepartmentname\" otherpara=\"column:id\"  orderkey=\"departmentname\"/>"+
 	    "				<col width=\"11%\" text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitle\" transmethod=\"weaver.rdeploy.hrm.RdeployTransMethod.getHrmHrmResourceJobtitle\" otherpara=\"column:id\" orderkey=\"jobtitle\"/>"+
 	    "				<col width=\"14%\" text=\"\" column=\"id\" transmethod=\"weaver.rdeploy.hrm.RdeployTransMethod.getHrmHrmResourceOpt\"  otherpara=\""+user.getLanguage()+"\" />"+
 	    "			</head>"+
 	    " </table>";
 	}else{
 	   tableString+= operateString+
	    "			<head>"+
	    "				<col width=\"28%\" text=\""+SystemEnv.getHtmlLabelName(413,user.getLanguage())+"\" column=\"id\" orderkey=\"lastname\" transmethod=\"weaver.rdeploy.hrm.RdeployTransMethod.getHrmEditHrmResourceName\"  otherpara=\"column:lastlogindate+"+user.getLanguage()+"\" />"+
 	    "				<col width=\"18%\" text=\""+SystemEnv.getHtmlLabelName(422,user.getLanguage())+"\" column=\"mobile\" transmethod=\"weaver.rdeploy.hrm.RdeployTransMethod.getHrmHrmResourceMobile\" otherpara=\"column:id\"    orderkey=\"mobile\"/>"+
 	    "				<col width=\"18%\" text=\""+SystemEnv.getHtmlLabelName(416,user.getLanguage())+"\" column=\"sex\" transmethod=\"weaver.rdeploy.hrm.RdeployTransMethod.getHrmHrmResourceSex\" otherpara=\"column:id\"  orderkey=\"sex\"/>"+
 	    "				<col width=\"18%\" text=\""+SystemEnv.getHtmlLabelName(27511,user.getLanguage())+"\" column=\"departmentname\" transmethod=\"weaver.rdeploy.hrm.RdeployTransMethod.getHrmHrmResourceDepartmentname\" otherpara=\"column:id\"  orderkey=\"departmentname\"/>"+
 	    "				<col width=\"17%\" text=\""+SystemEnv.getHtmlLabelName(6086,user.getLanguage())+"\" column=\"jobtitle\" transmethod=\"weaver.rdeploy.hrm.RdeployTransMethod.getHrmHrmResourceJobtitle\" otherpara=\"column:id\" orderkey=\"jobtitle\"/>"+
	    "			</head>"+
	    " </table>";
 	    
 	}
%>
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.HRM_ResourceList %>"/>
<wea:SplitPageTag isShowTopInfo="false" tableString="<%=tableString%>" mode="run"  /> 
 </form>
</body>
</html>