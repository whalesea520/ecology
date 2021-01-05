
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

String selecttaskstatus = Util.null2String(request.getParameter("selecttaskstatus"));

//获取 动态新闻
Map<String,Map<String,String>> newsmap = taskManager.getNewsOfToday(user.getManagerid(),rs,user);
//获取 任务完成情况数据
Map<String,String> completeChartData = taskManager.getUserTaskCompleteChartData(taskuser,rs);
  
%> 
<HTML>
<HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/jquery.mousewheel_wev8.js"></script>
<link rel="stylesheet" href="/worktask/css/common_wev8.css" type="text/css" />
<link rel="stylesheet" href="/worktask/css/powerFloat_wev8.css" type="text/css" />
<link rel="stylesheet" href="/worktask/css/taskmain_wev8.css" type="text/css" />
<script type="text/javascript" src="/worktask/js/jquery.textSlider_wev8.js"></script>
<script src="/js/highcharts/highcharts_wev8.js"></script>
<style>

.highcharts-container{
  margin-left: 2px;
}

</style>

<script type="text/javascript">

$(document).ready(function(){
    
    $("#rightMenuIframe").load(function(){   
         //隐藏所有
	   for(var i=0;i<=6;i++){
	     $(window.frames["rightMenuIframe"].document).find("#menuItemDivId"+i).hide();
	   }
	   
	   $(".taskstatusobj").each(function(){
			 if($(this).hasClass("taskcurrentselect")){
	           rightMenuControll($(this))			    
			 }      
		});
    });   

    
    //计算 tasklistdetail 高度
    $("#taskstatuslist").css("height",($(window.top.document.body).height()-112)+'px');
    $('#taskstatuslist').perfectScrollbar();
    //计算 tasklist 高度
    //$("#tasklist").css("height",($(window.top.document.body).height()-114)+'px');
    //计算 tasklistdetail 高度
    $("#tasklistdetail").css("height",($(window.top.document.body).height()-165)+'px');
    $('#tasklistdetail').perfectScrollbar();
    
    //计算 图表 高度
     $("#chartdata").css("height",($(window.top.document.body).height()-420)+'px');
    var taskselect;
    if('<%=selecttaskstatus%>' !=''){//选中上次刷新前 选中的
        var selecttaskstatus = $("#<%=selecttaskstatus%>");
        $("#tasklisttypenum").html(selecttaskstatus.children().eq(2).html());
		$("#tasklisttypenum").css("background",selecttaskstatus.children().eq(2).css("background-image"));
		$("#tasklisttypename").html(selecttaskstatus.children().eq(1).html());
	    loadtasklistdata("<%=tasktype%>","<%=taskuser%>",selecttaskstatus.attr("taskstatus"),"","");
	    taskselect = true;
	    $(".taskstatusobj").removeClass("taskselect");
		$(".taskstatusobj").removeClass("taskcurrentselect");
		$(".taskstatusobj").addClass("taskunselect");
		selecttaskstatus.removeClass("taskunselect");
		selecttaskstatus.addClass("taskselect");
   		selecttaskstatus.addClass("taskcurrentselect");
   	    selecttaskstatus.find(".taskstatusobjimg").attr("src",selecttaskstatus.find(".taskstatusobjimg").attr("src").replace("_wev8.png","_01_wev8.png"));
        
    }else{
	    //触发默认选中
	     $(".taskstatusobj").each(function(){
			 if($(this).children().eq(2).html() != 0){
			    $("#tasklisttypenum").html($(this).children().eq(2).html());
				$("#tasklisttypenum").css("background",$(this).children().eq(2).css("background-image"));
				$("#tasklisttypename").html($(this).children().eq(1).html());
			    loadtasklistdata("<%=tasktype%>","<%=taskuser%>",$(this).attr("taskstatus"),"","");
			    taskselect = true;
			    $(".taskstatusobj").removeClass("taskselect");
				$(".taskstatusobj").removeClass("taskcurrentselect");
				$(".taskstatusobj").addClass("taskunselect");
				$(this).removeClass("taskunselect");
				$(this).addClass("taskselect");
		   		$(this).addClass("taskcurrentselect");
		   	    $(this).find(".taskstatusobjimg").attr("src",$(this).find(".taskstatusobjimg").attr("src").replace("_wev8.png","_01_wev8.png"));
			    return false;
			 }
		});
	}
    if(!taskselect){//都没选中，选中第一个
       $(".taskstatusobj").first().removeClass("taskunselect");
       $(".taskstatusobj").first().addClass("taskselect");
    }
    
    //状态 鼠标移动事件
    $(".taskstatusobj").mouseover(function(){
         if(!$(this).hasClass("taskcurrentselect")){
            if($(this).find(".taskstatusobjimg").attr("src") != undefined){
				$(this).find(".taskstatusobjimg").attr("src",$(this).find(".taskstatusobjimg").attr("src").replace("_wev8.png","_01_wev8.png"));
			}
		    
		 }         
         $(this).removeClass("taskunselect");
	     $(this).addClass("taskselect");
	});
	//状态鼠标移出事件
	$(".taskstatusobj").mouseout(function(){
	   if(!$(this).hasClass("taskcurrentselect")){
		    $(this).removeClass("taskselect");
		    $(this).addClass("taskunselect");
		    if($(this).find(".taskstatusobjimg").attr("src") != undefined){
				 $(this).find(".taskstatusobjimg").attr("src",$(this).find(".taskstatusobjimg").attr("src").replace("_01_wev8.png","_wev8.png"));
			}
		   
	   }
	   
	});
	
    // 状态点击事件
	$(".taskstatusobj").click(function(){
	    $(".taskstatusobj").each(function(){
			  $(this).removeClass("taskselect");
			  $(this).removeClass("taskcurrentselect");
			  $(this).addClass("taskunselect");
			  //$(this).children().eq(2).delay(800).show(0);
			  if($(this).find(".taskstatusobjimg").attr("src") != undefined){
			     $(this).find(".taskstatusobjimg").attr("src",$(this).find(".taskstatusobjimg").attr("src").replace("_01",""));
			  }
		});
		$(this).removeClass("taskunselect");
	    $(this).addClass("taskselect");
	    $(this).addClass("taskcurrentselect");
	    if($(this).find(".taskstatusobjimg").attr("src") != undefined){
			$(this).find(".taskstatusobjimg").attr("src",$(this).find(".taskstatusobjimg").attr("src").replace("_wev8.png","_01_wev8.png"));
		}
	    //$(this).children().eq(2).delay(800).hide(0);
	    

	   $("#tasklisttypenum").html($(this).children().eq(2).html());
	   $("#tasklisttypenum").css("background",$(this).children().eq(2).css("background-image"));
	   
	   $("#tasklisttypename").html($(this).children().eq(1).html());
	   
	   var taskordercolumn="";
		$(".floatorder_list_ul li").each(function(){
			if($(this).hasClass("floatorder_liselected")){
			    taskordercolumn = $(this).attr("colname");
			    return false;
			 }
		});
		$("#worktasksearchnameinput").val("");	
		
		rightMenuControll($(this));
	    
	    loadtasklistdata("<%=tasktype%>","<%=taskuser%>",$(this).attr("taskstatus"),taskordercolumn,"");
	});
	
	
	//今日完成提示
	//$("#completetoday").powerFloat({
		//targetMode: "remind",
		//targetAttr: "placeholder",
	//});
	//今日截止提示
	//$("#closetoday").powerFloat({
		//targetMode: "remind",
		//targetAttr: "placeholder",
	//});
	//@me 提示
	//$("#mentionme").powerFloat({
		//targetMode: "remind",
		//targetAttr: "placeholder",
	//});
	
	<% if(newsmap.size()>5){ %>
	   $("#scrollDiv").textSlider({line:4,speed:2500,timer:6000});
	<%}%>
	
	
	//初始化 图表数据
	$('#chartdata').highcharts({
          chart: {
            type: 'line'
            //type: 'line'
        },
        title: {
            text: '<%=SystemEnv.getHtmlLabelName(83807,user.getLanguage())%>',
            style: {
              color: '#000',
              fontSize: '15px',
            }
        },
        xAxis: {
             categories: [<%=completeChartData.get("categories") %>]
        },
         plotOptions: {
            area: {
                dataLabels: {
                    enabled: true
                },
                enableMouseTracking: false
            }
        },
        series: [{
            name: '<%=SystemEnv.getHtmlLabelName(22069,user.getLanguage())%>',
            data: [<%=completeChartData.get("values") %>]
        }]
    });
    
    //任务排序开始========================
	$("#worktaskorder").powerFloat({
		width: 110,
		target: $("#floatorder_list"),
		hoverHold: true,
		offsets: {
			x: -70,
			y: 1
		}
	});
	
	$(".floatorder_list_ul li").click(function(){
	    var taskstatus;
	    //触发选中
	     $(".taskstatusobj").each(function(){
			if($(this).hasClass("taskcurrentselect")){
			    taskstatus = $(this).attr("taskstatus");
			    return false;
			 }
		});
		
		$(".floatorder_list_ul li").removeClass("floatorder_liselected");
		$(this).addClass("floatorder_liselected");
		
		var taskname = "";
		if($("#worktasksearchnameinput").val() != "" && $("#worktasksearchnameinput").val().trim() != ""){
		   taskname = $("#worktasksearchnameinput").val();
		} 
		
		//alert($(this).attr("colname"));
	    loadtasklistdata("<%=tasktype%>","<%=taskuser%>",taskstatus,$(this).attr("colname"),"taskname="+taskname);
	});
	
	$("#worktaskorder").mouseover(function(){
         $(this).removeClass("worktaskorderunselect");
	     $(this).addClass("worktaskorderselect");
	});
	
	$("#worktaskorder").mouseout(function(){
	    $(this).removeClass("worktaskorderselect");
	    $(this).addClass("worktaskorderunselect");
	});
	
	$(".floatorder_list_ul").mouseover(function(){
         $("#worktaskorder").removeClass("worktaskorderunselect");
	     $("#worktaskorder").addClass("worktaskorderselect");
	});
	
	$(".floatorder_list_ul").mouseout(function(){
	    $("#worktaskorder").removeClass("worktaskorderselect");
	    $("#worktaskorder").addClass("worktaskorderunselect");
	});
	
	//任务排序结束========================
	
	//任务查询开始 ========================
	$("#worktasksearchimg").mouseover(function(){
         $("#worktasksearchname").css("visibility","visible");
         $("#worktasksearchname").css("width","50px");
         $("#worktasksearchname").animate({width:'+100px'}, "200");
         $("#worktasksearchnameinput").focus();
	});
	$("#worktasksearchnameimg").mouseover(function(){
         $("#worktasksearchname").css("visibility","visible");
         $("#worktasksearchnameinput").focus();
	});
	$("#worktasksearchname").mouseover(function(){
	     $("#worktasksearchname").css("visibility","visible");
         $("#worktasksearchnameinput").focus();
	});
	$("#worktasksearchname").focusout(function(){
	    if($("#worktasksearchnameinput").val() ==""){
	      $("#worktasksearchname").css("visibility","hidden");
	    }
	});
	
	//input 绑定 enter 事件
	$("#worktasksearchnameinput").bind('keypress',function(event){
	     if(event.keyCode == "13"){
	         tasklistsearch();	        
	     }	
	});
	$("#worktasksearchnameimg").bind('click',function(event){
	      tasklistsearch();	   
	});
	//任务查询结束=========================
	
	
	$(document).bind('click',function(ev){ 
		  var ev=ev||window.event;
		  var element=ev.target||ev.srcElement;  
		  if(element.id=='taskstatuslist' || element.id=='tasklisttitle' || element.id=='tasklistdetail'){
		      var worktaskdetail = $('#worktaskdetail',window.parent.document);
			  if (worktaskdetail.hasClass('visible')){
			     	worktaskdetail.animate({"right":"-525px"}, "1000").removeClass('visible');
			  } 
			  var childedittask = $('#childedittask',window.parent.document);
			  if (childedittask.hasClass('visible')){
			     	childedittask.animate({"right":"-525px"}, "1000").removeClass('visible');
			  } 
		  }
		 
    }); 
    
});


//任务列表搜索
function tasklistsearch(){	         
     var taskstatus="";
    //触发选中
     $(".taskstatusobj").each(function(){
		if($(this).hasClass("taskcurrentselect")){
		    taskstatus = $(this).attr("taskstatus");
		    return false;
		 }
	});
	
	var taskordercolumn="";
	$(".floatorder_list_ul li").each(function(){
		if($(this).hasClass("floatorder_liselected")){
		    taskordercolumn = $(this).attr("colname");
		    return false;
		 }
	});
    loadtasklistdata("<%=tasktype%>","<%=taskuser%>",taskstatus,taskordercolumn,"taskname="+encodeURIComponent($("#worktasksearchnameinput").val()));
}


function loadtasklistdata(tasktype,taskuser,taskstatus,orderstyle,filterstr){
   //弹出提示框
   $("#loadmsg").css("width",$("#tasklist").css("width"));
   $("#loadmsg").css("height",$("#tasklist").css("height"));
   //$("#loadmsg").css("line-height",$("#tasklist").css("height"));
   $("#loadmsg").html("<image src='/express/task/images/loading1_wev8.gif'>").show();    
   //alert("/worktask/task/taskoperation.jsp?method=gettasklistdata&tasktype="+tasktype+"&taskuser="+taskuser+"&taskstatus="+taskstatus+"&"+filterstr+"&orderstyle="+orderstyle+"&etime=<%=TimeUtil.getOnlyCurrentTimeString() %>");
   $.ajax({
          type: "POST",
          url: "/worktask/task/taskoperation.jsp?method=gettasklistdata&tasktype="+tasktype+"&taskuser="+taskuser+"&taskstatus="+taskstatus+"&"+filterstr+"&orderstyle="+orderstyle+"&etime=<%=TimeUtil.getOnlyCurrentTimeString() %>",
          timeout: 20000,
          dataType: 'json',
          success: function (datas) {
             
             //处理 标题前 checkbox 是否显示
             var checkboxdisplay="";
             if(taskstatus == '4' || taskstatus=='10' ){ 
                 checkboxdisplay = "none";
             }
             var tasklist = $("#tasklistdetail");
             var currentuserid = "<%=user.getUID() %>";
             //去掉 taskobjlist
             $(".taskobjlist").remove();
             var urgencytip = "<%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>";
             var attentiontip = "<%=SystemEnv.getHtmlLabelName(26939,user.getLanguage()) %>";
             var attentionimg = "";
             //标题的字体粗，主要用在 验证 审批，区分真需要自己审批的
             var titlefontweight = "";
             for (var row in  datas) {
                var taskobjlist = $("<div id='task"+datas[row].requestid+"' status='"+datas[row].status+"' approverequest='"+datas[row].approverequest+"' taskid='"+datas[row].taskid+"' requestid='"+datas[row].requestid+"'></div>");
                taskobjlist.addClass("taskobjlist");
                taskobjlist.appendTo(tasklist);
                
                urgencytip = "<%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%>";
                var taskobjlisturgency = $("<div title='"+urgencytip+"' style='width:8px;height:8px;float: left;'></div>");
                if(datas[row].urgency==2){
                   urgencytip="<%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%>";
                   taskobjlisturgency = $("<div title='"+urgencytip+"' style='width:8px;height:8px;float: left;background: url(/worktask/images/025_wev8.png)'></div>");
                }else if(datas[row].urgency==1){
                   urgencytip="<%=SystemEnv.getHtmlLabelName(15533,user.getLanguage()) %>";
                   taskobjlisturgency = $("<div title='"+urgencytip+"' style='width:8px;height:8px;float: left;background: url(/worktask/images/026_wev8.png)'></div>");
                }
                taskobjlisturgency.appendTo(taskobjlist);

                var taskobjlisttop = $("<div></div>");
                taskobjlisttop.addClass("taskobjlisttop");
                taskobjlisttop.appendTo(taskobjlist);
                
                //taskstatus == 5,6,7 8 11 进行中 已延期 即将延期
                checkboxdisplay = "";
                if(taskstatus=='5,6,7' || taskstatus=='8' || taskstatus=='11'){
                   if(datas[row].taskcompletecount != datas[row].tasklisttotalcount){
                      //任务清单未完成
                      checkboxdisplay = "none";
                   }
                }
                titlefontweight = "";
                // 待审批
                if(taskstatus == '2'){
                   if(datas[row].approveuserid != currentuserid){
                      //审批人不是 当前人，不展示
                      checkboxdisplay = "none";
                   }else{
                      titlefontweight = ";font-weight: bold;";
                   }
                }
                 // 待验证
                if(taskstatus == '9'){
                   if(datas[row].checkor != currentuserid){
                      //验证人不是 当前人，不展示
                      checkboxdisplay = "none";
                   }else{
                      titlefontweight = ";font-weight: bold;";
                   }
                }
                 // 已完成 已取消 待验证 标志完成
                if(taskstatus == '10' || taskstatus == '4' || taskstatus == '5,6,7' || taskstatus == '8' || taskstatus == '9' || taskstatus == '11' || taskstatus == '13' || taskstatus=='14'){
                      checkboxdisplay = "none";
                }
     
                //如果当前人 不是 本人 ，都不展示 checkbox 。主要是在下属情况
                if("<%=user.getUID() %>" != "<%=taskuser%>"){
                   checkboxdisplay = "none";
                }
                var taskobjlisttop_title = $("<div title='"+datas[row].taskname+"' style='"+titlefontweight+"'><input type='checkbox' class='requestids'  approverequest='"+datas[row].approverequest+"' taskid='"+datas[row].taskid+"' value='"+datas[row].requestid+"' style='display:"+checkboxdisplay+"'/> &nbsp;&nbsp;"+datas[row].taskname+"</div>");
                taskobjlisttop_title.addClass("taskobjlisttop_title");
                taskobjlisttop_title.appendTo(taskobjlisttop);
                var taskobjlisttop_creater  = $("<div><span title='<%=SystemEnv.getHtmlLabelName(882,user.getLanguage()) %>'> <a href='javascript:openhrm("+datas[row].creater+")' onclick='pointerXY(event);'>"+datas[row].creatername+"</a></span></div>");
                taskobjlisttop_creater.addClass("taskobjlisttop_creater");
                taskobjlisttop_creater.appendTo(taskobjlisttop);
                
                var taskobjlistbottom = $("<div></div>");
                taskobjlistbottom.addClass("taskobjlistbottom");
                taskobjlistbottom.appendTo(taskobjlist);
                
                var taskobjlistbottom_person = $("<div> <span title='<%=SystemEnv.getHtmlLabelName(2097,user.getLanguage()) %>'> <img src='/worktask/images/001_wev8.png' align='absmiddle'>&nbsp;<a href='javascript:openhrm("+datas[row].liableperson+")' style='color:#888'  onclick='pointerXY(event);'>"+datas[row].liablepersonname+"</a></span>&nbsp;<span title='<%=SystemEnv.getHtmlLabelName(22326,user.getLanguage()) %>' style='color:#888' >"+datas[row].planenddate+"</span></div>");
                taskobjlistbottom_person.addClass("taskobjlistbottom_person");
                taskobjlistbottom_person.appendTo(taskobjlistbottom);
                attentiontip = "<%=SystemEnv.getHtmlLabelName(26939,user.getLanguage()) %>";
                attentionimg = "/worktask/images/002_wev8.png"
                if(datas[row].attention==1){
                     attentionimg = "/worktask/images/002_01_wev8.png"
                     attentiontip="<%=SystemEnv.getHtmlLabelName(24957,user.getLanguage()) %>";
                }
                var taskobjlistbottom_complete = $("<div><span title='<%=SystemEnv.getHtmlLabelName(22069,user.getLanguage()) %>' style='color:#888' > <img src='/worktask/images/003_wev8.png' align='absmiddle'>&nbsp;"+datas[row].taskcompletecount+"/"+datas[row].tasklisttotalcount+" </span>&nbsp;&nbsp;&nbsp;<img class='attentionimg' requestid='"+datas[row].requestid+"' status='"+datas[row].attention+"' title='"+attentiontip+"' src='"+attentionimg+"' align='absmiddle'></div>");
                taskobjlistbottom_complete.addClass("taskobjlistbottom_complete");
                taskobjlistbottom_complete.appendTo(taskobjlistbottom);
             }
             $("#loadmsg").delay(500).hide(0);
             
             $('#tasklistdetail').perfectScrollbar('update');
             jQuery('body').jNice(); 
             $(".taskobjlist").mouseover(function(){
		         $(this).removeClass("tasklistunselect");
			     $(this).addClass("tasklistselect");
			});
			
			$(".taskobjlist").mouseout(function(){
			   if(!$(this).hasClass("taskcurrentselect")){
			    $(this).removeClass("tasklistselect");
			    $(this).addClass("tasklistunselect");
			   }
			});
			
			//添加 关注 操作 开始=========================
			$(".attentionimg").click(function(event){
			    var requestid = $(this).attr("requestid");
			    var status =  $(this).attr("status");
			    var method = "addattention";
			    if(status == 1) method = "delattention";
			    var obj = $(this);
			    event.stopPropagation();    //  阻止事件冒泡
				$.ajax({
			          type: "POST",
			          url: "/worktask/task/taskoperation.jsp?method="+method+"&requestid="+requestid,
			          timeout: 20000,
			          dataType: 'json',
			          success: function (datas) {
			             if(datas==1 && status==0){
			                obj.attr("src","/worktask/images/002_01_wev8.png");
			                obj.attr("status","1");
			                obj.attr("title","<%=SystemEnv.getHtmlLabelName(24957,user.getLanguage()) %>");
			             }else if(datas==1 && status==1){
			                obj.attr("src","/worktask/images/002_wev8.png");
			                obj.attr("status","0");
			                obj.attr("title","<%=SystemEnv.getHtmlLabelName(26939,user.getLanguage()) %>");
			             }			
			          }, fail: function () {
			              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage()) %>!");
			          }
			    });
			});
			//添加 关注 操作 结束=========================
			
				// 具体的 任务 点击事件
				$(".taskobjlist").click(function(){ 
				    var worktaskdetail = $('#worktaskdetail',window.parent.document); 
					var wtstatus = $(this).attr("status");
					var wtrequstid = $(this).attr("requestid");
					var wttaskid = $(this).attr("taskid");
				    if (worktaskdetail.hasClass('visible')){
				        if($("#worktaskdetailpage",window.parent.document).attr("src").indexOf("?wtid="+$(this).attr("taskid")+"&requestid="+$(this).attr("requestid"))<0){
							//$("#worktaskdetailmsg").show();
				            //$("#worktaskdetailpage").attr("src","/worktask/pages/worktask.jsp?wtid="+$(this).attr("taskid")+"&requestid="+$(this).attr("requestid"));
							 parent.resetWorkTaskFrameSrc(wtstatus,wtrequstid,wttaskid);
					    }				        
				    } else {
				       // worktaskdetail.animate({"right":"0px"}, "1000").addClass('visible');
						if($("#worktaskdetailpage",window.parent.document).attr("src").indexOf("?wtid="+$(this).attr("taskid")+"&requestid="+$(this).attr("requestid"))<0){
							//$("#worktaskdetailmsg").show();
							worktaskdetail.animate({"right":"0px"}, 500,function(){
								 //$("#worktaskdetailpage").attr("src","/worktask/pages/worktask.jsp?wtid="+$(this).attr("taskid")+"&requestid="+$(this).attr("requestid"));
								 parent.resetWorkTaskFrameSrc(wtstatus,wtrequstid,wttaskid);
							}).addClass('visible');
					    }else{
						    worktaskdetail.animate({"right":"0px"}, 500).addClass('visible');
						}
				    }
				    //隐藏 childedittask div
				     $('#childedittask',window.parent.document).animate({"right":"-525px"}, "1000").removeClass('visible');
				});
				
				//阻止冒泡事件 开始========================
				$(".taskobjlistbottom_person").find("a").click(function(event){
				    event.stopPropagation();    //  阻止事件冒泡
				});
				$(".taskobjlisttop_creater").find("a").click(function(event){
				    event.stopPropagation();    //  阻止事件冒泡
				});
				$(".taskobjlisttop_title").find(".jNiceWrapper").click(function(event){
				    event.stopPropagation();    //  阻止事件冒泡
				});
				//阻止冒泡事件 结束=========================

          }, fail: function () {
              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(127889,user.getLanguage())%>!");
          }
    });
     
}


// 控制 右键菜单 显示 隐藏
function rightMenuControll(jobj){
   var status = jobj.attr("taskstatus");
   var frameobj = $(window.frames["rightMenuIframe"].document);
   //隐藏所有
   for(var i=0;i<=7;i++){
     frameobj.find("#menuItemDivId"+i).hide();
   }

   $("#rightMenuIframe").css("height","120px");
   //未提交、被退回
   if(status == '1' || status == '3' ){
     frameobj.find("#menuItemDivId0").show();
     frameobj.find("#menuItemDivId1").show();
     //设置高度，解决 有时 右键高度不够
     $("#rightMenuIframe").css("height","140px");
   }
   
   //待审批
   if(status == '2' ){
     frameobj.find("#menuItemDivId2").show();
     frameobj.find("#menuItemDivId3").show();
     frameobj.find("#menuItemDivId4").show();
     //设置高度，解决 有时 右键高度不够
     $("#rightMenuIframe").css("height","160px");
   }
   
   //进行中 已延期  即将延期
   if(status == '5,6,7' || status == '8' || status == '11'){
     //frameobj.find("#menuItemDivId5").show();
   }
   
   //待验证
   if(status == '9' ){
     //frameobj.find("#menuItemDivId6").show();
     //frameobj.find("#menuItemDivId7").show();
   }
}

//返回 当前选中的 任务状态id
function getSelectTaskStatusObjId(){
     var objid="";
    //触发选中
     $(".taskstatusobj").each(function(){
		if($(this).hasClass("taskcurrentselect")){
		    objid = $(this).attr("id");
		    return false;
		 }
	});
	
	return objid;
}


//返回 被选中的 checkbox 值为 requestid
function getSelectRequestids(){
    var requestids = "";
    $(".requestids").each(function(){
		if($(this).attr("checked")==true){
		   requestids = requestids + $(this).val() +",";
		}
	});
	//去掉最后一个逗号
	if(requestids != ""){
	   requestids = requestids.substring(0,requestids.length-1);
	}
	
	return requestids;
}

//返回 被选中的 checkbox 值为 requestid 对应的 taskids
function getSelectRequestidTaskIdStr(){
    var str = "";
    $(".requestids").each(function(){
		if($(this).attr("checked")==true){
		   str = str + "&taskid_"+$(this).val()+"="+$(this).attr("taskid");
		}
	});
	
	return str;
}

//返回 被选中的 checkbox 值为 requestid 对应的 approverequestids
function getSelectRequestidApproveRequestStr(){
    var str = "";
    $(".requestids").each(function(){
		if($(this).attr("checked")==true){
		   str = str + "&approverequest_"+$(this).val()+"="+$(this).attr("approverequest");
		}
	});
	
	return str;
}

//批量删除
function doDel(){
   ajaxoperate("deltask","","");
} 

//批量提交
function OnSubmit(){
   var paramstr = getSelectRequestidTaskIdStr(); 
   ajaxoperate("submittask",paramstr,"");
} 

//批量批准
function OnApprove(){
   var paramstr = getSelectRequestidTaskIdStr(); 
   var paramstr02 = getSelectRequestidApproveRequestStr();
   ajaxoperate("approvetask",paramstr,paramstr02);
}

//批量退回
function OnReject(){
   var paramstr = getSelectRequestidTaskIdStr();//主要用于提交
   var paramstr02 = getSelectRequestidApproveRequestStr();
   ajaxoperate("rejecttask",paramstr,paramstr02);
}

//批量取消
function OnCancel(){
   var paramstr = getSelectRequestidTaskIdStr();//主要用于提交
   var paramstr02 = getSelectRequestidApproveRequestStr();
   ajaxoperate("canceltask",paramstr,paramstr02);
}

//批量通过 --验证
function OnCheckSuccess(){
   var paramstr = getSelectRequestidTaskIdStr();//主要用于提交
   var paramstr02 = getSelectRequestidApproveRequestStr();
   ajaxoperate("canceltask",paramstr,paramstr02);
}

//批量退回 --验证
function OnCheckBack(){
   var paramstr = getSelectRequestidTaskIdStr();//主要用于提交
   var paramstr02 = getSelectRequestidApproveRequestStr();
   ajaxoperate("canceltask",paramstr,paramstr02);
}


//ajax op
function ajaxoperate(method,taskidparam,approverequestidparam){
     var requestids = getSelectRequestids();
     
     if(requestids===''){
		 window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(19689, user.getLanguage())%>");
		  return;
	 }
     //alert("/worktask/task/taskoperation.jsp?method="+method+"&requestids="+requestids+paramstr);
     
	 window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(83070, user.getLanguage())%>',function(){
	 
	 //弹出提示框
	 $("#loadmsg").css("width",$("#tasklist").css("width"));
	 $("#loadmsg").css("height",$("#tasklist").css("height"));
	 //$("#loadmsg").css("line-height",$("#tasklist").css("height"));
	 $("#loadmsg").html("<%=SystemEnv.getHtmlLabelName(20204, user.getLanguage())%>").show(); 
	 
		   $.ajax({
		          type: "POST",
		          url: "/worktask/task/taskoperation.jsp?method="+method+"&requestids="+requestids+taskidparam+approverequestidparam,
		          timeout: 20000,
		          dataType: 'json',
		          success: function (datas) {
		             if(datas==1){
		                //移出这些任务
		                var ids = requestids.split(',');
		                for(var i=0; i<ids.length;i++){
		                   $("#task"+ids[i]).remove();
		                }
		                //改变 左侧 任务数字
		                $(".taskstatusobj").each(function(){
							  if($(this).hasClass("taskcurrentselect")){
							    $(this).children().eq(2).html($(this).children().eq(2).html()-ids.length);
							  }
					   });
		                 $("#loadmsg").delay(500).hide(0);
		                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30700,user.getLanguage()) %>!");
		             }else{
		                window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage()) %>!");
		             }			
		          }, fail: function () {
		              window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30651,user.getLanguage()) %>!");
		          }
		   });
	 });
} 

</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16539, user.getLanguage());
String needfav = "1";
String needhelp = "";
%>

<%@ include file="/systeminfo/TopTitle_wev8.jsp"%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp"%>
<%

	//提交
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20839, user.getLanguage()) +SystemEnv.getHtmlLabelName(615, user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+ SystemEnv.getHtmlLabelName(20839, user.getLanguage()) +SystemEnv.getHtmlLabelName(23777, user.getLanguage())+ ",javascript:doDel(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
	
	//批准
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20839, user.getLanguage()) +SystemEnv.getHtmlLabelName(142, user.getLanguage())+",javaScript:OnApprove(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	//退回
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20839, user.getLanguage()) +SystemEnv.getHtmlLabelName(236, user.getLanguage())+",javaScript:OnReject(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	//取消
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20839, user.getLanguage()) +SystemEnv.getHtmlLabelName(201, user.getLanguage())+",javaScript:OnCancel(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	
	//完成  反馈
	RCMenu += "{"+SystemEnv.getHtmlLabelName(127891, user.getLanguage())+",javaScript:OnComplete(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;

	//验证通过
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20839, user.getLanguage()) +SystemEnv.getHtmlLabelName(15376, user.getLanguage())+",javaScript:OnCheckSuccess(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	//验证退回
	RCMenu += "{"+SystemEnv.getHtmlLabelName(20839, user.getLanguage()) +SystemEnv.getHtmlLabelName(236, user.getLanguage())+",javaScript:OnCheckBack(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;

%>
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
			
			<input type="button" name="newBtn" onclick="OnNew();" class="e8_btn_top" value="<%= SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"/>
			<span title="<%=SystemEnv.getHtmlLabelName(82753,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
	</tbody>
</table>
</form>


<div id="floatorder_list" >
   <ul class="floatorder_list_ul">
     <li colname="liableperson"> <%=SystemEnv.getHtmlLabelNames("18222,2097", user.getLanguage()) %></li>
     <li colname="creater"><%=SystemEnv.getHtmlLabelNames("18222,882", user.getLanguage()) %></li>
     <li colname="planenddate" ><%=SystemEnv.getHtmlLabelNames("18222,22326", user.getLanguage()) %></li>
     <li colname="urgency" ><%=SystemEnv.getHtmlLabelNames("18222,15534", user.getLanguage()) %></li>
   </ul>
</div>

<table class="taskmaintable" style="table-layout:fixed;" cellpadding="0" cellspacing="0">
  <col align="center" width="110px" />
  <col align="center" width="*"/>
  <col align="center" width="420px"/>
  <tr>
     <td style="vertical-align: top;width:110px" > 
            <!-- 任务状态开始 -->
			<div id="taskstatuslist">
			  <%
			    String taskcount = "0";
			  %>
			  
			  <div class="<%= !"0".equals(taskcount)?"taskstatusobj taskunselect":"taskstatusobj taskselect taskcurrentselect" %>" id="taskstatusobj05" taskstatus="5,6,7">
		         <div style="height:30px"><img class="taskstatusobjimg" src="/worktask/images/008_wev8.png"></div>
		         <div><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage()) %></div>
		  
		          <%
				    //获取 进行中 任务数据,会默认展示
				    taskcount = taskManager.getTaskTypeCount(tasktype,"5,6,7",taskuser,rs);
				  %>
		         	<div class="taskstatusnum05 taskstatusnum" style="<%if("0".equals(taskcount)){%> display:none<%} %>"> <%=taskcount %> </div>
		         
		      </div>
		      <div class="taskstatusline"></div>
		      
			  <% 
			    //获取 即将结束 任务数据
			    taskcount = taskManager.getTaskTypeCount(tasktype,"11",taskuser,rs);
			    
			  %>
			    <div class="taskstatusobj taskselect taskunselect" id="taskstatusobj11" taskstatus="11">
			         <div style="height:30px"><img class="taskstatusobjimg" src="/worktask/images/009_wev8.png"></div>
			         <div><%=SystemEnv.getHtmlLabelName(31075,user.getLanguage()) %></div>
			         <div class="taskstatusnum11 taskstatusnum" style="<%if("0".equals(taskcount)){%> display:none<%} %>"> <%=taskcount %> </div>
			    </div>
			    <div class="taskstatusline"></div>

			  <%
			    //获取 已延期 任务数据
			    taskcount = taskManager.getTaskTypeCount(tasktype,"8",taskuser,rs);
			    //if(!"0".equals(taskcount)){
			  %>
				    <div class="taskstatusobj taskunselect" id="taskstatusobj08" taskstatus="8">
				         <div style="height:30px"><img class="taskstatusobjimg" src="/worktask/images/010_wev8.png"></div>
				         <div><%=SystemEnv.getHtmlLabelName(32556,user.getLanguage()) %></div>
				         	<div class="taskstatusnum08 taskstatusnum" style="<%if("0".equals(taskcount)){%> display:none<%} %>"> <%=taskcount %> </div>
				         
				    </div>
			   <div class="taskstatusline"></div>
			   <%
			    //获取 待验证 任务数据
			    taskcount = taskManager.getTaskTypeCount(tasktype,"9",taskuser,rs);
			    if(!"0".equals(taskcount)){
			  %>
				    <div class="taskstatusobj taskunselect " id="taskstatusobj09" taskstatus="9">
				         <div style="height:30px"><img class="taskstatusobjimg" src="/worktask/images/011_wev8.png"></div>
				         <div><%=SystemEnv.getHtmlLabelName(21982,user.getLanguage()) %></div>
				         <div class="taskstatusnum09 taskstatusnum"> <%=taskcount %> </div>
				         
				    </div>
				    <div class="taskstatusline"></div>
			   <%} %>
			   
			   
			   <%
			    //获取 待审批 任务数据
			    taskcount = taskManager.getTaskTypeCount(tasktype,"2",taskuser,rs);
			    if(!"0".equals(taskcount)){
			   %>
				    <div class="taskstatusobj taskunselect" id="taskstatusobj02" taskstatus="2">
				         <div style="height:30px"><img class="taskstatusobjimg" src="/worktask/images/012_wev8.png"></div>
				         <div><%=SystemEnv.getHtmlLabelName(2242,user.getLanguage()) %></div>
				         <div class="taskstatusnum02 taskstatusnum"> <%=taskcount %> </div>
				    </div>
				    <div class="taskstatusline"></div>
			   <%} %>
			   
			   <%
			    //获取 未提交 任务数据
			    taskcount = taskManager.getTaskTypeCount(tasktype,"1",taskuser,rs);
			    if(!"0".equals(taskcount)){
			   %>
				    <div class="taskstatusobj taskunselect" id="taskstatusobj01" taskstatus="1">
				         <div style="height:30px"><img class="taskstatusobjimg" src="/worktask/images/013_wev8.png"></div>
				         <div><%=SystemEnv.getHtmlLabelName(32555,user.getLanguage()) %></div>
				         <div class="taskstatusnum01 taskstatusnum"> <%=taskcount %> </div>
				         
				    </div>
				    <div class="taskstatusline"></div>
			   <%} %>
			   
			    <%
			    //获取 被退回任务数据
			    taskcount = taskManager.getTaskTypeCount(tasktype,"3",taskuser,rs);
			    if(!"0".equals(taskcount)){
			   %>
				    <div class="taskstatusobj taskunselect" id="taskstatusobj03" taskstatus="3">
				         <div style="height:30px"><img class="taskstatusobjimg" src="/worktask/images/014_wev8.png"></div>
				         <div><%=SystemEnv.getHtmlLabelName(21983,user.getLanguage()) %></div>
				         <div class="taskstatusnum03 taskstatusnum"> <%=taskcount %> </div>
				         
				    </div>
				    <div class="taskstatusline"></div>
			   <%} %>
			   
			   <%
			    //获取 已取消 任务数据
			    taskcount = taskManager.getTaskTypeCount(tasktype,"4",taskuser,rs);
			    if(!"0".equals(taskcount)){
			   %>
				    <div class="taskstatusobj taskunselect" id="taskstatusobj04" taskstatus="4">
				         <div style="height:30px"><img class="taskstatusobjimg" src="/worktask/images/015_wev8.png"></div>
				         <div><%=SystemEnv.getHtmlLabelName(20114,user.getLanguage()) %></div>
				         <div class="taskstatusnum04 taskstatusnum"> <%=taskcount %> </div>
				         
				    </div>
				    <div class="taskstatusline"></div>
			   <%} %>
			   
			   
			   <%
			    //获取 已完成 任务数据
			    taskcount = taskManager.getTaskTypeCount(tasktype,"10",taskuser,rs);
			    if(!"0".equals(taskcount)){
			   %>
				    <div class="taskstatusobj taskunselect" id="taskstatusobj10" taskstatus="10">
				         <div style="height:30px"><img class="taskstatusobjimg" src="/worktask/images/016_wev8.png"></div>
				         <div><%=SystemEnv.getHtmlLabelName(1961,user.getLanguage()) %></div>
				         <div class="taskstatusnum10 taskstatusnum"> <%=taskcount %> </div>
				         
				    </div>
				    <div class="taskstatusline"></div>
			   <%} %>
			</div>
			<!-- 任务状态结束 -->
     </td>
     <td width="*" style="vertical-align: top;white-space:nowrap;overflow:hidden;word-break:keep-all;" > 
         <!-- 任务列表开始 -->
			<div id="tasklist" style="width: 100%;overflow: hidden">
			    <div id="loadmsg"><image src="/express/task/images/loading1_wev8.gif"></div>
			    <div id="tasklisttitle"> 
			          <table style="width:100%;height:50px;">
		                  <col align="center" width="150px" />
						  <col align="center" width="*"/>
						  <col align="center" width="120px"/>
						  <tr style="height:50px">
						      <td>
							          <span id="worktasksearch" title="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage()) %>"><img id="worktasksearchimg" src="/images/ecology8/request/search-input_wev8.png" align='absmiddle'/> </span>
							          <span id="worktasksearchname"> 
							              <input type="text" id="worktasksearchnameinput" style="width:120px;height:28px" name="taskname" /> 
							              <span id="worktasksearchnameimg" title='<%=SystemEnv.getHtmlLabelName(527,user.getLanguage()) %>' style="position: relative;top: 0px;right: 33px;height: 28px;display: inline-block;width: 30px;cursor: pointer;"><img  src="/images/ecology8/request/search-input_wev8.png" align='absmiddle'/><span>
							          </span>
						      </td>
						      <td>
						            <span id="tasklisttypenum" style='display:none'> 0 </span>&nbsp;
			          				<span id="tasklisttypename"><%=SystemEnv.getHtmlLabelName(1960,user.getLanguage()) %></span>
						      </td>
						      <td>
						             <div style="width:100%;">
							              <div id="worktaskorder" title="<%=SystemEnv.getHtmlLabelName(338,user.getLanguage()) %>" class="worktaskorderunselect"><img src='/worktask/images/004_wev8.png' align='absmiddle'/></div>
							          </div>
						      </td>
						  </tr>
			          
			          </table>
			    </div>
			    
			    <div id="tasklistdetail" >
	
			    </div>

			</div>	
        <!-- 任务列表结束 -->
     </td>
     <td style="vertical-align: top;width: 420px"> 
          <!-- 任务统计开始 -->
            
			<div id="taskstatisticslist">
			    <div id="taskstatisticslist_top">
			          <div class="taskstatusobj taskstatisticslistobj" id="completetoday" taskstatus="12" placeholder="<%=SystemEnv.getHtmlLabelName(83827,user.getLanguage()) %>">
			               <% taskcount = taskManager.getTaskTypeCount(tasktype,"12",taskuser,rs);%>
			              <div class="taskstatisticslistobj_img"  style="color: rgb(43, 197, 195)">
				              <img src="/worktask/images/005_wev8.png" align="absmiddle">  
				              <span class="taskstatisticslistobj_txt"><%=taskcount    %></span>
			              </div>
			              <div style="color: rgb(43, 197, 195);height: 40px;line-height: 40px;"><%=SystemEnv.getHtmlLabelName(83837,user.getLanguage()) %></div>
			              <div style="display:none" class="taskstatusnum12 taskstatusnum"> <%=taskcount %> </div>
			    	  </div>
			    	  <div class="taskstatisticslist_line"> </div>
			     
					  <div class="taskstatusobj taskstatisticslistobj" id="closetoday" taskstatus="13" placeholder="<%=SystemEnv.getHtmlLabelName(83829,user.getLanguage()) %>">
				              <% taskcount = taskManager.getTaskTypeCount(tasktype,"13",taskuser,rs);%>
				              <div class="taskstatisticslistobj_img" style="color: rgb(249, 134, 43);">
				                      <img src="/worktask/images/006_wev8.png" align="absmiddle">  <span class="taskstatisticslistobj_txt"><%=taskcount %></span>
				              </div>
				              <div style="color: rgb(249, 134, 43);height: 40px;line-height: 40px;"><%=SystemEnv.getHtmlLabelName(83835,user.getLanguage()) %></div>
				              <div style="display:none" class="taskstatusnum13 taskstatusnum"> <%=taskcount %> </div>
					    </div>
					    <div class="taskstatisticslist_line"> </div>
					    <div class="taskstatusobj taskstatisticslistobj" id="mentionme" taskstatus="14" placeholder="<%=SystemEnv.getHtmlLabelName(83831,user.getLanguage()) %>">
					              <% taskcount = taskManager.getTaskTypeCount(tasktype,"14",taskuser,rs);%>
					              <div class="taskstatisticslistobj_img" style="color: rgb(187, 153, 248);">
					              <img src="/worktask/images/007_wev8.png" align="absmiddle">  <span class="taskstatisticslistobj_txt"><%=taskcount %></span></div>
					              <div style="color: rgb(187, 153, 248);height: 40px;line-height: 40px;"><%=SystemEnv.getHtmlLabelName(83834,user.getLanguage()) %></div>
					              <div style="display:none" class="taskstatusnum14 taskstatusnum"> <%=taskcount %> </div>
					    </div>
			    </div>
			    
                <div id="scrollDiv">
                    <div style="text-align: center;width: 90%;border-bottom: 1px solid #f2f2f2;margin: 0px auto;font-size: 15px;height: 24px;"><%=SystemEnv.getHtmlLabelName(83833,user.getLanguage()) %></div>
					<div class="scrollText">
					  <ul style="margin-top: 0px;">
					     <% 
					         
					         
					         if(newsmap.size()>0){
					        	 for(Map.Entry<String,Map<String,String>> news : newsmap.entrySet()){	 
					     %>
					         <li><div style="float:left;width:55px"><%=news.getValue().get("liablepersonname") %> </div>
						         <div style="float: left;width: 190px;height: 25px;overflow: hidden;"><%=news.getValue().get("taskname") %>  </div>
						         <div style="float:right;width: 32px">  <%=news.getValue().get("wttime") %></div><div style="float:right;width: 62px"><%=news.getValue().get("typename") %> </div>
					         </li>
					     <%  		 
					        	 }
					         }else{
					     %>
					         <li><%=SystemEnv.getHtmlLabelName(84082,user.getLanguage())%> </li>
					     <%} %>
					     
					  </ul>
					</div>
			     </div>
			     
			     <div id="chartdata">
			          
			    </div>
			     
			</div>		

		 <!-- 任务统计结束 -->
     </td>
  </tr>
</table>

		
</BODY>
<script type="text/javascript" src="/worktask/js/jquery-powerFloat-min_wev8.js"></script>	
<script language=javascript>
function submitData() {
  if(check_form(weaverA,"name")){
    weaverA.submit();
  }
}

function MainCallback(){
	dialog.close();
	_table.reLoad();
}
</script>

	