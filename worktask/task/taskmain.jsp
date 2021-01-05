
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ include file="/systeminfo/init_wev8.jsp"%>
<jsp:useBean id="taskManager" class="weaver.worktask.request.TaskManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
//任务类型
String tasktype = Util.null2String(request.getParameter("tasktype"));
//任务对象
String taskuser = Util.null2String(request.getParameter("taskuser"));
  
%> 

<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/worktask/css/common_wev8.css" type="text/css" />
<link rel="stylesheet" href="/worktask/css/taskmain_wev8.css" type="text/css" />


<style>

#worktasklist{
  height: 100%;
  width: 100%;
  line-height: 100%;
}

#worktasklistmsg{
  width: 100%;
height: 100%;
top: 0;
left: 0;
background: #fff;
position: absolute;
text-align: center;
padding-top: 100px;
font-size: 14px;
font-weight: bold;
display:none
}

</style>


</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16539, user.getLanguage());
String needfav = "1";
String needhelp = "";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp"%>

<BODY style="overflow: hidden;">
<form action="" name="frmmain" id="frmmain">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<colgroup>
		<col width="30%"/>
		<col width="*"/>
	</colgroup>
	<tbody>
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" onclick="viewSubOrdinaryTasks();" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(83802,user.getLanguage())%>"/>
			<input type="button" name="newBtn" onclick="OnNew();" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
	</tbody>
</table>
</form>

<div id="worktasklist">
   <iframe id="worktasklistpage" frameborder="no" border="0" width="100%" height="100%" src="/worktask/task/tasklist.jsp?tasktype=<%=tasktype %>&taskuser=<%=taskuser %>"></iframe>
    <div id="worktasklistmsg"></div>
</div>


<div id="worktaskdetail">
    <iframe id="worktaskdetailpage" frameborder="no" border="0" width="100%" height="100%" src=""></iframe>
    <div id="worktaskdetailmsg"> <image src="/express/task/images/loading1_wev8.gif"> </div>
</div>

<div id="childedittask" >
    <iframe id="childedittaskpage" frameborder="no" border="0" width="100%" height="100%" src=""></iframe>
    <div id="childedittaskmsg"> <image src="/express/task/images/loading1_wev8.gif"> </div>
</div>
		
</BODY>
<script type="text/javascript" src="/worktask/js/jquery-powerFloat-min_wev8.js"></script>	
<script language=javascript>

$(document).ready(function(){
   
	$(document).bind('click',function(ev){ 
		  var ev=ev||window.event;
		  var element=ev.target||ev.srcElement;  
		  if(element.id=='taskstatuslist' || element.id=='tasklisttitle' || element.id=='tasklistdetail'){
		      var worktaskdetail = $('#worktaskdetail');
			  if (worktaskdetail.hasClass('visible')){
			     	worktaskdetail.animate({"right":"-525px"}, "1000").removeClass('visible');
			  } 
			  var childedittask = $('#childedittask');
			  if (childedittask.hasClass('visible')){
			     	childedittask.animate({"right":"-525px"}, "1000").removeClass('visible');
			  } 
		  }
		 
    }); 
    
    // iframe 加载成功
    $("#worktaskdetailpage").load(function(){   
         $("#worktaskdetailmsg").hide();
	});   
	
	// iframe 加载成功
    $("#childedittaskpage").load(function(){   
         $("#childedittaskmsg").hide();
	});   
	
	// iframe 加载成功
    $("#worktasklistpage").load(function(){   
         $("#worktasklistmsg").hide();
	});  
	
});

//新建  /worktask/pages/worktask.jsp?wtid=**
//更新  /worktask/pages/worktask.jsp?wtid=**&requestid=**
//其它操作 /worktask/pages/worktaskoperate.jsp?wtid=**&requestid=**
function resetWorkTaskFrameSrc(wtstatus,wtrequestid,wttaskid){
    //alert(wtstatus+"==taskid="+wttaskid+"==requestid="+wtrequestid);
    if($("#worktaskdetailpage").attr("src") !='' && $("#worktaskdetailpage").attr("src").indexOf("worktask.jsp")>0  && typeof document.getElementById("worktaskdetailpage").contentWindow.taskContentsChange === 'function'){
       //alert($("#worktaskdetailpage").attr("src"));
       //alert(document.getElementById("worktaskdetailpage").contentWindow.taskContentsChange());
       if(document.getElementById("worktaskdetailpage").contentWindow.taskContentsChange()){
            window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(83801,user.getLanguage())%>',function(){
			       resetWorkTaskFrameSrc2(wtstatus,wtrequestid,wttaskid);
			       return false;
			});
       }else{
          resetWorkTaskFrameSrc2(wtstatus,wtrequestid,wttaskid);
       }
    }else{
       resetWorkTaskFrameSrc2(wtstatus,wtrequestid,wttaskid);
    }
    
}


function resetWorkTaskFrameSrc2(wtstatus,wtrequestid,wttaskid){
   $("#worktaskdetailmsg").show();
   var taskpage = "";
   if(wtstatus == '1' || wtstatus == '3'){//未提交 被退回
	   taskpage = "/worktask/pages/worktask.jsp?wtid="+wttaskid+"&requestid="+wtrequestid;
	}else if(wtstatus == '5,6,7' || wtstatus >= 2){
	   taskpage = "/worktask/pages/worktaskoperate.jsp?wtid="+wttaskid+"&requestid="+wtrequestid;
	}else{
	   taskpage = "/worktask/pages/worktask.jsp?wtid=-1";
	}
	$("#worktaskdetailpage").attr("src",taskpage);

	//如果 wtrequestid 不为空，标志查看 记录日志
	$.ajax({
		  type: "POST",
		  url: "/worktask/task/taskoperation.jsp?method=viewtask&requestid="+wtrequestid,
		  timeout: 20000,
		  dataType: 'json',
		  success: function (datas) {
			if(datas !=='' && datas=='14'){
			   var mcount = $("#mentionme").find(".taskstatisticslistobj_txt").html();
			   if(mcount>=1) mcount = mcount -1;
			   $("#mentionme").find(".taskstatisticslistobj_txt").html(mcount);
			}
		  }, fail: function () {
			  window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage()) %>");
		  }
	});
}

/**
* 查看下级任务清单  
**/
function  viewSubOrdinaryTasks(){
  　         var dlg=new window.top.Dialog();//定义Dialog对象
      dlg.Model=true;
　　　dlg.Width=1000;//定义长度
　　　dlg.Height=600;
　　　dlg.URL="/worktask/pages/subOrdinoryTasks.jsp";
　　　dlg.Title='<%= SystemEnv.getHtmlLabelNames("83802,491",user.getLanguage())%>';
　　　dlg.show();
}


//新建
function OnNew(){
   var worktaskdetail = $('#worktaskdetail'); 
	
   if (worktaskdetail.hasClass('visible')){
		if($("#worktaskdetailpage").attr("src").indexOf("?wtid=0&requestid=")<0){
			//$("#worktaskdetailmsg").show();
			 resetWorkTaskFrameSrc(0,"",-1);
		}				        
	} else {
	   // worktaskdetail.animate({"right":"0px"}, "1000").addClass('visible');
		if($("#worktaskdetailpage").attr("src").indexOf("?wtid=0&requestid=")<0){
			//$("#worktaskdetailmsg").show();
			worktaskdetail.animate({"right":"0px"}, 500,function(){
				 resetWorkTaskFrameSrc(0,"",-1);
			}).addClass('visible');
		}else{
			worktaskdetail.animate({"right":"0px"}, 500).addClass('visible');
		}
	}
	
	$('#childedittask').animate({"right":"-525px"}, "1000").removeClass('visible');
}


//处理 任务关联子任务、编辑任务
function onChildEditTask(requestid, wtid ,retasklistid,wtstatus){
   var childedittask = $('#childedittask'); 
   
    var taskpage = "";
	if(wtstatus == '1' || wtstatus == '3'){//未提交 被退回
	   taskpage = "/worktask/pages/worktask.jsp?requestid="+requestid+"&wtid="+wtid+"&tasklistid="+retasklistid;
	}else if(wtstatus == '5,6,7' || wtstatus > 2){
	   taskpage = "/worktask/pages/worktaskoperate.jsp?wtid="+wtid+"&requestid="+requestid+"&tasklistid="+retasklistid;;
	}else{
	   taskpage = "/worktask/pages/worktask.jsp?wtid=-1&requestid="+requestid+"&tasklistid="+retasklistid;
	}
   
   if (childedittask.hasClass('visible')){
		if($("#childedittaskpage").attr("src").indexOf("?wtid=0&requestid=")<0){
			$("#childedittaskmsg").show();
			 //resetWorkTaskFrameSrc(0,"",-1);
			 $("#childedittaskpage").attr("src",taskpage);
		}				        
	} else {
	   // worktaskdetail.animate({"right":"0px"}, "1000").addClass('visible');
		if($("#childedittaskpage").attr("src").indexOf("?wtid=0&requestid=")<0){
			$("#childedittaskmsg").show();
			childedittask.animate({"right":"0px"}, 500,function(){
				 $("#childedittaskpage").attr("src",taskpage);
			}).addClass('visible');
		}else{
			childedittask.animate({"right":"0px"}, 500).addClass('visible');
		}
	}
}

//处理 任务关联子任务、编辑任务
function onEditTask(requestid, wtid ,retasklistid){
   var childedittask = $('#childedittask'); 
   
    var taskpage = "";
    taskpage = "/worktask/pages/worktask.jsp?wtid="+wtid+"&requestid="+requestid+"&tasklistid="+retasklistid;
   
   if (childedittask.hasClass('visible')){
		if($("#childedittaskpage").attr("src").indexOf("?wtid=0&requestid=")<0){
			$("#childedittaskmsg").show();
			 //resetWorkTaskFrameSrc(0,"",-1);
			 $("#childedittaskpage").attr("src",taskpage);
		}				        
	} else {
	   // worktaskdetail.animate({"right":"0px"}, "1000").addClass('visible');
		if($("#childedittaskpage").attr("src").indexOf("?wtid=0&requestid=")<0){
			$("#childedittaskmsg").show();
			childedittask.animate({"right":"0px"}, 500,function(){
				 $("#childedittaskpage").attr("src",taskpage);
			}).addClass('visible');
		}else{
			childedittask.animate({"right":"0px"}, 500).addClass('visible');
		}
	}
}

//刷新worktasklist
function taskListRefresh(){
     $("#worktasklistmsg").show();
     var selecttaskstatus = "";
     if(typeof document.getElementById("worktasklistpage").contentWindow.getSelectTaskStatusObjId === 'function'){
         selecttaskstatus = document.getElementById("worktasklistpage").contentWindow.getSelectTaskStatusObjId();
     }
     $('#worktasklistpage').attr('src', "/worktask/task/tasklist.jsp?tasktype=<%=tasktype %>&taskuser=<%=taskuser %>&selecttaskstatus="+selecttaskstatus);
}


//关闭 任务详细
function hideLeftTaskPanel(panelid){
    var panel = $('#'+panelid);
    if (panel.hasClass('visible')){
     	panel.animate({"right":"-525px"}, "1000").removeClass('visible');
    } 
}

//关闭 childEditTask div
function childEditTaskClose(){
    $('#childedittask').animate({"right":"-525px"}, "1000").removeClass('visible');
}

//刷新 worktaskdetail iframe 内容
function WorkTaskDetailRefresh(){
    //alert($('#worktaskdetailpage').attr('src'));
    $('#worktaskdetailpage').attr('src', $('#worktaskdetailpage').attr('src'));
}


//关闭 任务详细
function workTaskDetailCloseForDel(){
   $('#worktaskdetail').animate({"right":"-525px"}, "1000").removeClass('visible');
   $('#worktaskdetailpage').attr('src', "");
}

//关闭 任务详细
function workTaskDetailPageReload(url){
   $('#worktaskdetailpage').attr('src', url);
}

</script>

	