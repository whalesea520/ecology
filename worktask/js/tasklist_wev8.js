/**
设置任务完成
**/
function setComplete(checkbox,tasklistid){

	  //包含子任务的计划需确认子任务完成 方可点击完成操作
	  var childtaskpro = $(checkbox).closest("tr").find(".taskprocessval"); 
      if(childtaskpro.length > 0 && childtaskpro.html() !== '100%'){
	          changeCheckboxStatus(checkbox,false);
		      window.top.Dialog.alert("提示:子任务未完全完成!");  
			  return;
		}
      var msg = "",iscomplete=0;
	  if(checkbox.checked){
	      msg = "提示:是否确认完成?";
          iscomplete = 1;
	  }else{
	      msg = "提示:是否取消完成?";
		  iscomplete = 0;
	  }
      window.top.Dialog.confirm(msg,function(){
		  var senddata = {};
          senddata["iscomplete"] = iscomplete;
          senddata["tasklistid"] = tasklistid;
	      $.ajax({
				  type: "POST",
				  url:"/worktask/pages/taskcomplete.jsp",
				  dataType:'json',
				  data:senddata,
				  success:function(data){
					  if(data.success === '1'){
						  //更新进度条
						  var clotable = $(checkbox).closest("table");
						  var checklen = clotable.find("input:checked").length;
						  var checkalllen = clotable.find("input[type='checkbox']").length
						  var percentage = (checklen*100/checkalllen).toFixed(0)+'%';
						  var th = clotable.find(".reqprocess").parent();
						  th.html("<input type='hidden' name='reqpercent' value='"+percentage+"'>");
						  tasklistviews.generatorReqProcessBar();
						  window.top.Dialog.alert("数据更新成功!");
					   }
					  else
						  window.top.Dialog.alert("数据操作失败!");  
				  }
		 });
	  },function(){
	      if(checkbox.checked)
		     changeCheckboxStatus(checkbox,false);
		  else
             changeCheckboxStatus(checkbox,true);
	  });

}
var tasklistviews = (function($doc,$){
	

	
	 return{
		//移除加载图标
		removeLoadingItem:function(){
		   $(".loadingicon").remove();
	    }, 
    	//添加加载图标	 
 	    addLoadingItem:function(){
		    var loadingicon = "<div class='loadingicon' > <image src='/express/task/images/loading1_wev8.gif'> </div>";
		    $(".tasklistspanel").append(loadingicon);
	    }, generatorPanels:function(reqtasklists){
		  var reqinfo,reqtasklist,tablestr=[];
		  if(reqtasklists.length === 0){
			  $(".tasklistspanel").html("<div class='remindinfo'>"+SystemEnv.getHtmlNoteName(4024,languageid)+"!</div>");
			  return;
		  }
		  //遍历数据集合
		  for(var i = 0, len = reqtasklists.length; i<len; i++){
			  reqinfo = reqtasklists[i].requestinfo,
			  reqtasklist = reqtasklists[i].tasklists;
			  tablestr.push(this.generatorPanel(reqinfo, reqtasklist));
		  }
	      $(".tasklistspanel").html(tablestr.join(""));
	      this.generatorReqProcessBar();
	      this.generatorTaskProcessBar();
	      $(".tasklistspanel").jNice();
	      
	   //生成一个数据块
	   },generatorPanel:function(reqinfo,reqtasklist){
		   var table = [] ,tr ,headcls = '',reqpercent ,reqpercentstr = '' ,finish = 0, ischecked ,isdisabled ,cuid=$("#cuid").val();
		   //计算该任务百分比
		   for(var i=0, len=reqtasklist.length; i<len; i++){
			   if(reqtasklist[i].complete === "1"){
				   finish++;
			   }
		   }
		   if(reqtasklist.length>0){
			   reqpercent = (finish*100/reqtasklist.length).toFixed(0)+'%';
			   reqpercentstr = "<input type='hidden' name='reqpercent' value='"+reqpercent+"'>";
		   }
		   
		   table.push("<div class='taskpanel'><table class='tasktable'><colgroup><col width='25%'><col  width='25%'><col  width='25%'><col  width='25%'></colgroup>");
		   if(reqinfo.status === '8'){
			   headcls = "class = 'overtimeremind' ";
		   }
		   tr = "<thead><tr "+headcls+"><th>"+reqinfo.taskname+"</th><th>"+reqinfo.planenddate+"</th><th>"+reqinfo.liableperson+"</th><th>"+reqpercentstr+"</th></tr></thead>";
		   table.push(tr);
		   table.push("<tbody>");
		   for(var i=0, len=reqtasklist.length; i<len; i++){
			   ischecked = "",percenstr="" ,isdisabled = "";
			   if(reqtasklist[i].complete === "1"){
				   ischecked = "checked = 'checked'";
			   }
			   if(~~reqtasklist[i].reqids>0){
				   var percent = (~~reqtasklist[i].hascomplete*100/~~reqtasklist[i].reqids).toFixed(0)+'%';
				   percenstr = "<input type='hidden' name='taskpercent' value='"+percent+"'>";
			   }
			   if(reqtasklist[i].liableid !== cuid){
				   isdisabled = "disabled";
			   }
			   if(i === len-1)
			     tr = "<tr class='rowlast'><td><input type='checkbox' onclick='setComplete(this,\""+reqtasklist[i].listid+"\");' "+ischecked+" "+isdisabled+">"+reqtasklist[i].name+"</td><td>"+reqtasklist[i].enddate+"</td><td>"+reqtasklist[i].liableperson+"</td><td>"+percenstr+"</td></tr>"
			   else
				 tr = "<tr><td><input type='checkbox' onclick='setComplete(this,\""+reqtasklist[i].listid+"\");' "+ischecked+" "+isdisabled+">"+reqtasklist[i].name+"</td><td>"+reqtasklist[i].enddate+"</td><td>"+reqtasklist[i].liableperson+"</td><td>"+percenstr+"</td></tr>"
			   table.push(tr);	
		   }
		   table.push("</tbody>");
		   table.push("</table></div>");
		   return table.join("");
	   //生成进度条
	   },generatorReqProcessBar:function(){
		   var reqitems = $("input[name='reqpercent']"), current, th ,processstr="",tpwidth, itemvalue;
		   for(var i=0,len=reqitems.length;i<len;i++){
			   current = $(reqitems[i]);
			   itemvalue = current.val();
			   th = current.parent();
			   tpwidth = th.width()-30;
			   tpwidth = ~~(itemvalue.replace("%",""))*tpwidth/100;
			   processstr = "<div class='reqprocess' style='width:"+tpwidth+"px;'></div><div class='processval'>"+itemvalue+"</div>";
			   th.html(processstr);   
		   }
	   },//生成任务进度条
	   generatorTaskProcessBar:function(){
		   var taskitems = $("input[name='taskpercent']"), current, tr ,processstr="",tpwidth, itemvalue;
		   for(var i=0,len=taskitems.length;i<len;i++){
			   current = $(taskitems[i]);
			   itemvalue = current.val();
			   tr = current.parent();
			   tpwidth = tr.width()-30;
			   tpwidth = ~~(itemvalue.replace("%",""))*tpwidth/100;
			   processstr = "<div class='taskprocess' style='width:"+tpwidth+"px;'></div><div class='taskprocessval'>"+itemvalue+"</div>";
			   tr.html(processstr);   
		   }
		}
		
	}
	
})(document,jQuery);