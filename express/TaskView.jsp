
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.docs.docs.DocImageManager"%>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.task.CommonTransUtil" scope="page"/>
<html>
<head>
<script language="javascript" src="/js/jquery/jquery-1.4.2.min_wev8.js"></script>
<script language="javascript" src="/express/js/jquery.fuzzyquery.min_wev8.js"></script>
<script type='text/javascript' src='/blog/js/autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/blog/js/autocomplete/demo/localdata_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/blog/js/autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" href="/express/css/base_wev8.css" />
</head>
<body>
<%
    String operation=Util.null2String(request.getParameter("operation"));//操作类型
    String taskId = Util.null2String(request.getParameter("taskid"));//任务id
	String taskType=Util.null2String(request.getParameter("taskType"));//任务类型
	String creater=Util.null2String(request.getParameter("creater")); //任务对象创建人
	String userid=""+user.getUID();  //当前操作人id
	
    int attention = 0;
    int remind = 0;
    String sql = "SELECT * FROM Task_attention WHERE(userid="+userid+" AND tasktype="+taskType+" AND taskid="+taskId+")";
    rs.executeSql(sql);
    if(rs.getCounts()>0){
    	attention = 1;
    }
    rs.executeSql("select * from Task_msg where (senderid = "+userid+"AND receiverid ="+creater+" and tasktype="+taskType+" and taskid="+taskId+")");
	if(rs.getCounts() >0){
		remind = 1;
	}
	if(creater.equals(userid)){
		remind = 2;
	}
	
	String taskid=Util.null2String(request.getParameter("taskid"));
	//operation="view";
	//taskType="4";
    String detailsrc="";
    if(operation.equals("view")){
	    if(taskType.equals("1"))       //任务
	    	detailsrc="/express/task/data/DetailView.jsp?taskid="+taskid;
	    else if(taskType.equals("2"))  //流程
	    	detailsrc="/workflow/request/ViewRequest.jsp?requestid="+taskid+"&isovertime=0";
	    else if(taskType.equals("3"))  //会议
	    	detailsrc="/meeting/data/ProcessMeeting.jsp?meetingid="+taskid;
	    else if(taskType.equals("4"))  //文档
	    	detailsrc="/docs/docs/DocDsp.jsp?fromFlowDoc=&blnOsp=false&topage=&pstate=sub&id="+taskid;
	    else if(taskType.equals("5"))  //协作
	    	detailsrc="/cowork/viewCowork.jsp?id="+taskid;
	    else if(taskType.equals("6"))  //邮件
	        detailsrc="/email/MailView.jsp?folderId=0&id="+taskid;
    }else if(operation.equals("new")){
    	if(taskType.equals("2")){
    		detailsrc="/workflow/request/RequestType.jsp?";
    	}
    	if(taskType.equals("3")){
    		detailsrc="/cowork/AddCoWork.jsp";
    	}
    	if(taskType.equals("4")){
    		detailsrc="/email/MailAdd.jsp";
    	}
    	if(taskType.equals("5")){
    		detailsrc="/docs/docs/DocList.jsp?";
    	}
    	if(taskType.equals("6")){
    		detailsrc="/meeting/data/AddMeeting_left.jsp";
    	}
    }
	
%>
<div id="rightinfo" style="width: 100%;height: 100%;position: absolute;overflow: hidden;left: 0;top: 0;right: 0;bottom: 0">
	<input type="hidden"  id="taskid" name="taskid" value="<%=taskid %>"/>
	<input type="hidden" id="taskType" name="taskType" value="<%=taskType %>"/>
	<input type="hidden" id="userid" name="taskCreate" value="<%=userid %>"/>
	<input type="hidden" id="taskCreate" name="taskCreate" value="<%=creater %>"/>
	<input type="hidden" id="operation" name="operation" value="<%=operation %>"/>
	<div style="height: 40px;border-bottom:1px #E8E8E8 solid;display:<%=operation.equals("view")?"":"none"%>">
	  <div style="padding-top: 8px;margin-left:8px;">
	  	 <div class="btn_operate" style="width: 45px;height:20px;float:left;" _type="<%=attention%>" id="attention" title="<%=attention==0?"添加关注":"取消已关注"%>"><%=attention==0?"关注":"已关注"%></div>
	     <%if(taskType.equals("1")||taskType.equals("2")||taskType.equals("4")||taskType.equals("5")){%>
		     <div class="btn_operate" style="width: 45px;height:20px;float:left;" id="share" title="分享" onclick="showShare(event)">分享</div>
		     <div class="btn_operate" style="width: 45px;height:20px;float:left;" id="tagView" title="标签" onclick="showTag(event)">标签 <img style="margin-left:2px; margin-bottom:2px;" src="/express/images/express_maintask_pull_wev8.png"/></div>
		     <div class="btn_operate" style="width: 45px;height:20px;float:left;" id="mianLineView" title="主线" onclick="showMainLine(event)">主线 <img style="margin-left:2px; margin-bottom:2px;" src="/express/images/express_maintask_pull_wev8.png"/></div>
	     <%} %>
	     <%
	     	if(!taskType.equals("6")){
	     		if(remind == 0){ %>
	 	  	   <div class="btn_operate" style="width: 45px;height20px;float: left;"  _type="0" id="remind" title="提醒">提醒</div>
	 	  	 <%} %>
	 	  	   <%if(remind == 1){ %>
	 	  	   <div class="btn_operate" style="width: 45px;height20px;float: left;"  _type="1" id="remind" title="已提醒">已提醒</div>
	 	  	 <%}
	 	  	 }
	 	  	  %>
	     
	  
	  </div>
	</div>
	<div id="maininfo" style="width:100%;height:100%;">
         <iframe id="iframedetailsrc" src="<%=detailsrc%>" style="height:100%;width:100%;" frameborder="0" scrolling="auto"></iframe>
    </div>
</div>
<div id="createTag" class="task_drop_list" style="width:120px; height:auto; ">
		<div>
		<%
			rs.executeSql("SELECT t.name,t.id FROM task_label t  left JOIN Task_labelTask m  ON t.id = m.labelid WHERE (m.tasktype="+taskType+" AND m.taskid="+taskid+" and m.userid= "+userid+")");
			while(rs.next()){%>
			<div class="btn_add_type">	
				<div  style="white-space:nowrap; text-overflow:ellipsis; -o-text-overflow:ellipsis;overflow: hidden;" _type="1"  id="<%=rs.getInt("id") %>"  title="<%=rs.getString("name") %>"><%=rs.getString("name") %></div>
				<img style="float:right; margin-top:-15px; clear: both;" class="del_img" src="/express/images/item_del_wev8.png"/>
			</div>
		<%}
		 %>
			<div  style="margin-top: 10px; margin-left: 15px; margin-bottom: 8px;">
			  <input id="label_input" name="label_input" class="tag_input"/> 
			</div>
		</div>
</div>
<div id="choseMainLine" class="task_drop_list" style="width:120px; height: auto ; ">
		<div>
		<%
			rs.executeSql("SELECT t.name,t.id FROM Task_mainline t  left JOIN Taks_mainlineTask m  ON t.id = m.mainlineid WHERE (m.tasktype="+taskType+" AND m.taskid="+taskid+")");
			while(rs.next()){%>	
			<div class="btn_add_type">
				<div style="white-space:nowrap; text-overflow:ellipsis; -o-text-overflow:ellipsis;overflow: hidden;" _type="2" id="<%=rs.getInt("id") %>"  title="<%=rs.getString("name") %>"><%=rs.getString("name") %>&nbsp; </div>
			<%if(creater.equals(userid)){%>
				<img style="float:right; margin-top:-15px; clear: both;" class="del_img"  src="/express/images/item_del_wev8.png"/>
			<% } %>	
			</div>
		<%	}	
		 %>
		 <%if(!creater.equals(userid) && rs.getCounts() == 0){
			 %>
			 <div class="btn_add_type">
				<div style="white-space:nowrap; text-overflow:ellipsis; -o-text-overflow:ellipsis;overflow: hidden;" _type="0" id="0"  title="">未建主线 </div>
			</div>
		<%
		 }
		%>
		 
		 
		 
		 <%if(creater.equals(userid)){ %>
			<div  style="margin-top: 10px; margin-left: 15px; margin-bottom: 8px;">
			   <input id="main_input"   name="main_input" class="tag_input" style="width: 80px;"/> 
			</div>
		<%} %>
		</div>
</div>

<div id="shareTask" class="task_drop_list" style="width:100px; height: auto ">
		<div>
			<div class="btn_add_type" onclick="" >吴凡中&nbsp; <img class="del_img"  src="/express/images/item_del_wev8.png"/></div>
			<div  style="margin-top: 10px; margin-left: 15px; margin-bottom: 8px;"><input id="share_input" class="tag_input" /> </div>
		</div>
</div>
<script>
  $(document).ready(function(){
  
  
  	  var tasktype = $("#taskType").attr("value");
  	  var operation = $("#operation").attr("value");
  	  
  	 $(".del_img").hide();
     //$("#maininfo").height($("#detaildiv").height()-<%=operation.equals("view")?40:0%>);
     $("#maininfo").height($("#rightinfo").height()-<%=operation.equals("view")?40:0%>);
     $("#iframedetailsrc").height($("#maininfo").height());
     //alert($("#iframedetailsrc").height());
     
     $("div.btn_add_type").live("mouseover",function(){
			$("div.btn_add_type").removeClass("btn_add_type_over");
			$(this).addClass("btn_add_type_over");
			$(this).children().show();
		}).bind("mouseout",function(){
			$(this).removeClass("btn_add_type_over");
			$(this).children().eq(1).hide();
	});
	
	
	//添加关注
	$("#attention").bind("click",function(){
		var special = jQuery(this).attr("_type");
		if(special == "0"){
			$('#select_tr', parent.document).find(".item_att").removeClass("item_att0").addClass("item_att1").attr("title","取消关注").attr("_special","1");
		}
		if(special == "1"){
			$('#select_tr', parent.document).find(".item_att").removeClass("item_att1").addClass("item_att0").attr("title","标记关注").attr("_special","0");
		}
		var taskId = jQuery("#taskid").attr("value");
		var taskType = jQuery("#taskType").attr("value");
		var careate  = jQuery("#taskCreate").attr("value");
		var userid  = jQuery("#userid").attr("value");
		if(userid == careate){
			return;
		}
		$.ajax({
				type: "post",
			    url: "/express/task/data/Operation.jsp",
			    data:{"operation":"set_special",'taskId':taskId,'taskType':taskType,"special":special}, 
			    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			    complete: function(data){
			        if(special==0){
			    	   $("#attention").html("已关注").attr("title","取消关注");
				       $("#attention").attr("_type","1");
				    }else{
				       $("#attention").html("关注").attr("title","添加关注");
				       $("#attention").attr("_type","0");
				    }
			    }
		});
   		if((userid != careate) && special==0){
   			 $.ajax({
    			type: "post",
  					url:"/express/TaskOperation.jsp",
  					data:{'taskId':taskId,'taskType':taskType,'operation':"addRemind",'creater':careate,'remarktype':'2'},
  					contentType : "application/x-www-form-urlencoded;charset=UTF-8",
  		 			complete: function(data){
   				 }
   			});	
   		}
	});
		//添加提醒
	$("#remind").bind("click",function(){
			var type = jQuery(this).attr("_type");
			var taskId = jQuery("#taskid").attr("value");
			var taskType = jQuery("#taskType").attr("value");
			var careate  = jQuery("#taskCreate").attr("value");
			var userid  = jQuery("#userid").attr("value");
			if(type == 0){
			 $.ajax({
	    		type: "post",
   				url:"/express/TaskOperation.jsp",
   				data:{'taskId':taskId,'taskType':taskType,'operation':"addRemind",'creater':careate,'remarktype':'1'},
   				contentType : "application/x-www-form-urlencoded;charset=UTF-8",
   		 		complete: function(data){
   		 			$("#remind").html("已提醒");
    			 }
	    	});	
		}
	});
	
	//删除标签和主线
	$(".del_img").live("click",function(e){
		var obj = jQuery(this).parent().children().eq(0);
		var parent_obj = jQuery(this).parent().parent().parent();
		var labeltype = jQuery(obj).attr("_type");
		var id = jQuery(obj).attr("id");
		var taskid = $("#taskid").attr("value");
		var tasktype = $("#taskType").attr("value");
		var taskCreate = $("#taskCreate").attr("value");
		var userid = $("#userid").attr("value");
		if(userid != taskCreate && labeltype=="2"){
			return;
		}
		$.ajax({
			type: "post",
		    url: "/express/TaskOperation.jsp",
		    data:{"operation":"del_Label",'id':id,'type':labeltype,'taskid':taskid,'tasktype':tasktype}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    success: function(data){
		    	jQuery(obj).remove();
		    	jQuery(parent_obj).show();
		    	$("#select_tr" ,parent.document).children().eq(5).children().first().children().each(function(){
		    		if($(this).attr("id")== "labelstr"+id && $(this).attr("_type") == labeltype){
		    			$(this).remove();
		    		}
		    	});
				$.ajax({
					type: "post",
				    url: "/express/TaskOperation.jsp",
				    data:{"operation":"getLableName",'taskId':taskid,'taskType':tasktype}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    success: function(data){
				    	var newdata = $.trim(data).substring(0,$.trim(data).length/2);
				    	$("#select_tr" ,parent.document).children().eq(5).children().attr("title",newdata);
					}
			    });
				}
	    });
	});
	//将任务加入标签或者主线
	$(".btn_add_type").live("click",function(){
		var id = $(this).attr("id");
		var type  = $(this).attr("_type");
		var taskid = $("#taskid").attr("value");
		var tasktype = $("#taskType").attr("value");
		$.ajax({
	    		type: "post",
	    		url:"/express/TaskOperation.jsp",
	    		data:{'id':id ,'type':type,'operation':"add_label_main",'taskid':taskid,'tasktype':tasktype},
	    		contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    		 complete: function(data){
	    		 }
	    	});
		
	});
	$(".tag_input").bind("click",function(e){
		stopBubble(e);
	});
	//添加标签事件绑定
	$("#label_add").bind("keydown",function(e){
		var taskId = $("#taskid").attr("value");
		var taskType = $("#taskType").attr("value");
		e = e ? e : event;   
	    if(e.keyCode == 13){
	    	var label_name = $("#label_add").val();
	    	$.ajax({
	    		type: "post",
	    		url:"/express/TaskOperation.jsp",
	    		data:{'labei_name':encodeURI(label_name),'taskId':taskId ,'taskType':taskType,'operation':"addLabel"},
	    		contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    		 complete: function(data){
	    		 }
	    	});
	   }    
	});
	
	//检查是否关注
		//添加主线事件绑定
	$("#main_input1").bind("keydown",function(e){
		var taskId = $("#taskid").attr("value");
		var taskType = $("#taskType").attr("value");
		e = e ? e : event;   
	    if(e.keyCode == 13){
	    	var label_name = $("#main_input").val();
	    	$.ajax({
	    		type: "post",
	    		url:"/express/TaskOperation.jsp",
	    		data:{'labei_name':encodeURI(label_name),'taskId':taskId ,'taskType':taskType,'operation':"addMain"},
	    		contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    		 complete: function(data){
	    		 }
	    	});
	   }    
	});
	
	//输入框联提示事件
    $("#main_input").FuzzyQuery({
		url:"/express/task/data/GetData.jsp",
		param:{iscreate:1},
		record_num:5,
		filed_name:"name",
		searchtype:'mainline',
		divwidth: 120,
		updatename:'main_input',
		updatetype:'',
		intervalTop:2,
		result:function(data){
		  var taskid = $("#taskid").attr("value");
		  var tasktype = $("#taskType").attr("value");
		  var taskCreate = $("#taskCreate").attr("value");
		  var userid = $("#userid").attr("value");
		  if(userid != taskCreate){
		  	return;
		  }
		  var mainid = data["id"];
		  var parentObj = $("#select_tr" ,parent.document).children().eq(5).children();
		  var labelName =  $(parentObj).html();
		  var labelTitle = $(parentObj).attr("title");
		  var name = data["name"];
		  if(mainid != 0){
		  	$.ajax({
	    		type: "post",
	    		url:"/express/TaskOperation.jsp",
	    		data:{'taskid':taskid ,'tasktype':tasktype,'operation':"add_label_main",'type':'2','id':mainid},
	    		contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    		success: function(data){
	    			$("#main_input").val("");
	    			if($.trim(data) =="1"){
	    				 addTag(name,mainid,"main_input",2);
		    			  var newLabelTitle = labelTitle+name+" " ;
						  var newlabelName = labelName + "<span id='labelstr"+mainid+"' _type='2'>"+name+"</span>&nbsp;&nbsp;"
						  $(parentObj).attr("title",newLabelTitle);
						  $(parentObj).html(newlabelName);
	    			}
	    		 }
	    	});
		  }
		  //新建主线
		  if(mainid == 0){
		  		var name = data["name"];
		  		var mainname = name.substring(3,name.length-1); 
		  		$.ajax({
		    		type: "post",
		    		url:"/express/TaskOperation.jsp",
		    		data:{'labei_name':encodeURI(mainname),'taskId':taskid ,'taskType':tasktype,'operation':"addMain"},
		    		contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    		 success: function(data){
		    		 	$("#main_input").val("");
						var id = data;
		    			 addTag(mainname,id,"main_input",2);
		    			 var newLabelTitle = labelTitle+mainname+" " ;
					  	var newlabelName = labelName + "<span id='labelstr"+id+"' _type='2'>"+mainname+"</span>&nbsp;&nbsp;"
					  	$(parentObj).attr("title",newLabelTitle);
					  	$(parentObj).html(newlabelName);
		    		 }
		    	});
		  }
		}
	});
	
	    $("#label_input").FuzzyQuery({
			url:"/express/task/data/GetData.jsp",
			param:{iscreate:1},
			record_num:5,
			filed_name:"name",
			searchtype:'labelline',
			divwidth: 120,
			updatename:'label_input',
			updatetype:'',
			intervalTop:2,
			result:function(data){
			  var taskid = $("#taskid").attr("value");
			  var tasktype = $("#taskType").attr("value");
			  var mainid = data["id"];
			  var name = data["name"];
			  var parentObj = $("#select_tr" ,parent.document).children().eq(5).children();
			  var labelName =  $(parentObj).html();
		 	  var labelTitle = $(parentObj).attr("title");
			  var newLabelTitle = labelTitle+data["name"]+" " ;
			  $(parentObj).attr("title",newLabelTitle);
			  var newlabelName = labelName + "<span id='labelstr"+mainid+"' _type='1'>"+data["name"]+"</span>&nbsp;&nbsp;"
			  $(parentObj).html(newlabelName);
			  if(mainid != 0){
			  	$.ajax({
		    		type: "post",
		    		url:"/express/TaskOperation.jsp",
		    		data:{'taskid':taskid ,'tasktype':tasktype,'operation':"add_label_main",'type':'1','id':mainid},
		    		contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    		 success: function(data){
		    		 	$("#label_input").val("");
		    		 	if($.trim(data)=="1"){
		    		 		addTag(name,mainid,"label_input",1);
		    		 		var newLabelTitle = labelTitle+name+"  " ;
						  	$(parentObj).attr("title",newLabelTitle);
						  	var newlabelName = labelName + "<span id='labelstr"+mainid+"' _type='1'>"+name+"</span>&nbsp;&nbsp;"
						  	$(parentObj).html(newlabelName);
		    		 	}
					  }
		    	});
			  }
			  //新建
			  if(mainid == 0){
			  		var name = data["name"];
			  		var mainname = name.substring(3,name.length-1); 
			  		$.ajax({
			    		type: "post",
			    		url:"/express/TaskOperation.jsp",
			    		data:{'labei_name':encodeURI(mainname),'taskId':taskid ,'taskType':tasktype,'operation':"addLabel"},
			    		contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			    		success: function(data){
			    				$("#label_input").val("");
			    		 		addTag(mainname,data,"label_input",1);
			    		 		var newLabelTitle = labelTitle+mainname+"  " ;
								 $(parentObj).attr("title",newLabelTitle);
								  var newlabelName = labelName + "<span id='labelstr"+mainid+"' _type='1'>"+mainname+"</span>"
								  $(parentObj).html(newlabelName);
					    		 }
			    	});
			  }
			}
		});
	  });
	  
  function addTag(name,id,objid,type){
  	$("#"+objid).parent().before("<div class='btn_add_type'>" +	
								"<div  style='white-space:nowrap; text-overflow:ellipsis; -o-text-overflow:ellipsis;overflow: hidden;' _type='"+type+"'  id='"+id+"'  title='"+name+"'>"+name+"</div>"+
								"<img style='float:right; margin-top:-15px; clear: both;' class='del_img' src='/express/images/item_del_wev8.png'/>"+
								"</div>");
 	$(".del_img").hide();
  }
 //显示标签下拉菜单
  function showTag(e){
  	$("#createTag").css({
     		"left":$("#tagView").position().left+"px",
			"top":"27px"
     }).show();
     $("#choseMainLine").hide();
     $("#shareTask").hide();
     stopBubble(e);
  }
  //显示主线下拉菜单
  function showMainLine(e){
  	$("#choseMainLine").css({
     		"left":$("#mianLineView").position().left+"px",
			"top":"27px"
     }).show();
		$("#createTag").hide();
		$("#shareTask").hide();
     stopBubble(e);
    }
   //显示分享下拉菜单
  function showShare(e){
     window.parent.window.showSharebox(<%=taskType%>,<%=taskid%>,<%=creater%>);
    }
   
     
    //阻止事件冒泡函数
  function stopBubble(e)
	{
	   if (e && e.stopPropagation){
	     e.stopPropagation()
	 }
	 else{
			 window.event.cancelBubble=true
		}
	}
		//控制下拉菜单的控制
	$(document).bind("click",function(e){
		$("#choseMainLine").hide();
		$("#createTag").hide();
		$("#newCreate").hide();
		$("#operate").hide();
		$("#shareTask").hide();
	});
	function changeAttention(type,id,tasktype){
		var taskid = $("#taskid").attr("value");
		var taskT = $("#taskType").attr("value");
		if(id == taskid && taskT == tasktype){
			if(type =="1"){
		
			$("#attention").html("已关注").attr("title","取消已关注").attr("_type","1");
			}else{
			$("#attention").html("关注").attr("title","添加关注").attr("_type","0");
		}
		}
		
	}
	
	function taskCallBack(tasktype,status){
	   var taskid="<%=taskid%>";
	   $.post("TaskOperation.jsp?operation=checkwfstatus&taskid="+taskid,function(data){
	   	   var foucsobj=window.parent.window.foucsobj;
	   	   var focustr=$(foucsobj).parents("tr:first");
	       var isTask=$.trim(data);
	       //alert(status);
	       if(isTask=="0"){ //如果不在代办中
	           //alert("流程处理成功");
	           if(status!="8"){ //8为流程抄送
		           focustr.next().find(".disinput").click();
		       }    
		           focustr.remove();
		           parent.window.setIndex();
	           //}else
	           //	   focustr.attr("status","8");
	       }    
	   });
	}
	function changeDetailName(name,taskid){
		document.getElementById('iframedetailsrc').contentWindow.changeDetailName(name,taskid);
	}
</script>
</body>
</html>
