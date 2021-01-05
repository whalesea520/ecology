  
   //唯一标识uuid对象
   function UUID() {
     this.id = this.createUUID();
	}
	UUID.prototype.valueOf = function () {
		return this.id;
	}
	UUID.prototype.toString = function () {
		return this.id;
	}
    UUID.prototype.createUUID = function () {
		var dg = new Date(1582, 10, 15, 0, 0, 0, 0);
		var dc = new Date();
		var t = dc.getTime() - dg.getTime();
		var h = '-';
		var tl = UUID.getIntegerBits(t, 0, 31);
		var tm = UUID.getIntegerBits(t, 32, 47);
		var thv = UUID.getIntegerBits(t, 48, 59) + '1'; // version 1, security version is 2
		var csar = UUID.getIntegerBits(UUID.rand(4095), 0, 7);
		var csl = UUID.getIntegerBits(UUID.rand(4095), 0, 7);
		var n = UUID.getIntegerBits(UUID.rand(8191), 0, 7) +
			UUID.getIntegerBits(UUID.rand(8191), 8, 15) +
			UUID.getIntegerBits(UUID.rand(8191), 0, 7) +
			UUID.getIntegerBits(UUID.rand(8191), 8, 15) +
			UUID.getIntegerBits(UUID.rand(8191), 0, 15); // this last number is two octets long
		return tl + h + tm + h + thv + h + csar + csl + h + n;
	}
	UUID.getIntegerBits = function (val, start, end) {
		var base16 = UUID.returnBase(val, 16);
		var quadArray = new Array();
		var quadString = '';
		var i = 0;
		for (i = 0; i < base16.length; i++) {
			quadArray.push(base16.substring(i, i + 1));
		}
		for (i = Math.floor(start / 4); i <= Math.floor(end / 4); i++) {
			if (!quadArray[i] || quadArray[i] == '') quadString += '0';
			else quadString += quadArray[i];
		}
		return quadString;
	}
	UUID.returnBase = function (number, base) {
		var convert = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
		if (number < base) var output = convert[number];
		else {
			var MSD = '' + Math.floor(number / base);
			var LSD = number - MSD * base;
			if (MSD >= base) var output = this.returnBase(MSD, base) + convert[LSD];
			else var output = convert[MSD] + convert[LSD];
		}
		return output;
	}
	UUID.rand = function (max) {
		return Math.floor(Math.random() * max);
}


  /** * 对Date的扩展，将 Date 转化为指定格式的String * 月(M)、日(d)、12小时(h)、24小时(H)、分(m)、秒(s)、周(E)、季度(q)
    可以用 1-2 个占位符 * 年(y)可以用 1-4 个占位符，毫秒(S)只能用 1 个占位符(是 1-3 位的数字) * eg: * (new
    Date()).pattern("yyyy-MM-dd hh:mm:ss.S")==> 2006-07-02 08:09:04.423      
 * (new Date()).pattern("yyyy-MM-dd E HH:mm:ss") ==> 2009-03-10 二 20:09:04      
 * (new Date()).pattern("yyyy-MM-dd EE hh:mm:ss") ==> 2009-03-10 周二 08:09:04      
 * (new Date()).pattern("yyyy-MM-dd EEE hh:mm:ss") ==> 2009-03-10 星期二 08:09:04      
 * (new Date()).pattern("yyyy-M-d h:m:s.S") ==> 2006-7-2 8:9:4.18      
 */        
Date.prototype.pattern = function (fmt) { //author: meizz 
    var o = {
        "M+": this.getMonth() + 1, //月份 
        "d+": this.getDate(), //日 
        "h+": this.getHours(), //小时 
        "m+": this.getMinutes(), //分 
        "s+": this.getSeconds(), //秒 
        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
        "S": this.getMilliseconds() //毫秒 
    };
    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}

//添加任务清单
$(".addwt").click(function(){
	 var cdate = new Date().pattern("yyyy-MM-dd");
	 var tasklist = {
			 tasklistcontent : '',
			 tasklistenddate : cdate,
			 userid : '',
			 username : '',
			 id : ''
			 
	 };
	 //默认添加当前日期
	 addTask(tasklist);
	 //更新滚动条
    $('.worktask_detailinfo').perfectScrollbar('update');
});

function addTask(tasklist){
	  
	  var cdate = new Date().pattern("yyyy-MM-dd");
	  var htmlarray = [],tr;
	  htmlarray.push("<tr>");
	  htmlarray.push("<td width='3%'><input type='checkbox' ><input type='hidden' name='tasklistid'  value='"+(tasklist.tasklistid===undefined?'':tasklist.tasklistid)+"'></td>");
	  htmlarray.push("<td width='46%' ><input type='text' name='tasklistcontent' placeholder='"+SystemEnv.getHtmlNoteName(3607,languageid)+"' value='"+tasklist.tasklistcontent+"'/></td>");
	  htmlarray.push("<td width='25%'><img src='../images/datepic_wev8.png' title='"+SystemEnv.getHtmlNoteName(3614,languageid)+"' class='datepic' onclick='addDatePicker(this);'><span>"+tasklist.tasklistenddate+"</span><input value='"+tasklist.tasklistenddate+"' type='hidden' name='tasklistenddate'/></td>");
	  htmlarray.push("<td width='25%'><img src='../images/user_wev8.png' title='"+SystemEnv.getHtmlNoteName(3613,languageid)+"' style='cursor: pointer;'><span class='chargername resourceselection'></span></td>");
	  htmlarray.push("</tr>");
	  tr = $(htmlarray.join(""));
     //美化表单元素
	  $(".listbody").find("table").append(tr);
	  //美化check框
	  tr.jNice();
	  //为input添加placeholder属性
	  tr.find("input[type='text']").placeholder();
	  var browcontainer = tr.find(".chargername");
	  generatorResourceBrow(browcontainer,tasklist.userid,tasklist.username);
	  
}

/**
 * 添加只读任务清单
 * @param tasklist
 * @return
 */
function addViewTask(tasklist,userid,status){
      //1 为任务只读。 check disabled  关联任务不展示
	  var istaskview = $("#istaskview").val();
	  status = status+"";
	  var cdate = new Date().pattern("yyyy-MM-dd");
	  var htmlarray = [],tr;
	  htmlarray.push("<tr>");
      if(tasklist.userid !== userid+'' || (tasklist.userid === userid+''  &&  status !== '6' &&  status !== '7' &&  status !== '8' &&  status !== '11' ) ||  status === '10'  ){
         if(tasklist.complete==='1' )
           htmlarray.push("<td width='3%'><input name='taskcheck' type='checkbox' checked='checked' disabled><input type='hidden' name='tasklistid'  value='"+(tasklist.tasklistid===undefined?'':tasklist.tasklistid)+"'></td>");
	     else
		   htmlarray.push("<td width='3%'><input name='taskcheck' type='checkbox' disabled><input type='hidden' name='tasklistid'  value='"+(tasklist.tasklistid===undefined?'':tasklist.tasklistid)+"'></td>");
	  }else{
         if(tasklist.complete==='1')
		    htmlarray.push("<td width='3%'><input name='taskcheck'  type='checkbox' checked='checked' onclick='setComplete(this,\""+tasklist.tasklistid+"\");' ><input type='hidden' name='tasklistid'  value='"+(tasklist.tasklistid===undefined?'':tasklist.tasklistid)+"'></td>");
	     else
            htmlarray.push("<td width='3%'><input name='taskcheck'   type='checkbox'  onclick='setComplete(this,\""+tasklist.tasklistid+"\");' ><input type='hidden' name='tasklistid'  value='"+(tasklist.tasklistid===undefined?'':tasklist.tasklistid)+"'></td>");
	  }
	  var titlecolor = "#242424";
	  if(tasklist.complete==='1' ){
	     titlecolor = "#4197EA";
	  }
	  htmlarray.push("<td width='*' ><div><div style='display:inline-block;width:165px;vertical-align: middle;margin-right: 15px;color:"+titlecolor+"'>"+(tasklist.tasklistcontent===''?SystemEnv.getHtmlNoteName(3607,languageid):tasklist.tasklistcontent)+"</div><div class='potal'  style='vertical-align: middle;display:inline-block;position:relative;width:40px;height:40px;text-align: center;'><div id='"+tasklist.tasklistid+"' style='width:40px;height:40px;position: absolute;'></div><div class='percentage' style='top:30%;position: relative;'></div></div></div></td>");
	  htmlarray.push("<td width='20%' title='"+SystemEnv.getHtmlNoteName(3614,languageid)+"'><img src='../images/datepic_wev8.png' style='display:none' class='datepic' '><span>"+tasklist.tasklistenddate+"</span><input value='"+tasklist.tasklistenddate+"' type='hidden' name='tasklistenddate'/></td>");
	  if(tasklist.userid === userid+''  && ( status === '6' ||  status === '7' || status == '8')  &&  status !== '10' &&  status !== '9'  )
	     htmlarray.push("<td width='155px'><img src='../images/user_wev8.png' style='display:none'><span class='chargername resourceselection' title='"+SystemEnv.getHtmlNoteName(3613,languageid)+"' style='margin-left:0px;width: 45px;padding-top: 3px;padding-left: 17px;'></span><span style='float: right;margin-right: 14px;'><img title='"+SystemEnv.getHtmlNoteName(3609,languageid)+"' onclick=\"addNewWt('"+tasklist.tasklistid+"')\" src='../images/addnewwt_wev8.png' class='addnewwt'><img onclick=\"showListDetail(this,'"+tasklist.tasklistid+"')\" class='histaskstatus' title='"+SystemEnv.getHtmlNoteName(3610,languageid)+"' src='../images/taskstatus_wev8.png'></span></td>");
	  else
         htmlarray.push("<td width='155px'><img src='../images/user_wev8.png' style='display:none'><span class='chargername resourceselection' title='"+SystemEnv.getHtmlNoteName(3613,languageid)+"' style='margin-left:0px;width: 45px;padding-left: 17px;'></span></td>");
	  htmlarray.push("</tr>");
	  tr = $(htmlarray.join(""));
      //美化表单元素
	  $(".listbody").find("table").append(tr);
	  //美化check框
	  tr.jNice();
	  //为input添加placeholder属性
	  tr.find("input[type='text']").placeholder();
	  var browcontainer = tr.find(".chargername");
	  generatorResourceBrow(browcontainer,tasklist.userid,tasklist.username);
      
	  addDutChart(tasklist.tasklistid); 
//	  var chartdata = [{country: "完成",visits: "2218"},{country: "未完成",visits: "632"}];
 //     createChart(tasklist.tasklistid,chartdata,["#2792ff","#edf0f5"]);
	
}

/*添加环形图*/
function   addDutChart(tasklistid){
  if((tasklistid in taskliststatus) && taskliststatus[tasklistid].length>0){
      //获取所有的数据
	  var items = taskliststatus[tasklistid],uncomplete = 0,complete = 0, percent ,percentage = "0%",chartdatas=[],chartdata,colors=[];
	  for(var i=0,len=items.length;i<len;i++){
	     //考虑 任务没有 任务清单情况
	     if(items[i].uncomplete =='0' && items[i].hascomplete=='0'){
	        if(items[i].status =='10'){//任务已完成
	          complete++;
	        }else{
	          uncomplete++;
	        }
	     }else{
	        uncomplete += ~~items[i].uncomplete;
		    complete += ~~items[i].hascomplete;
	     }
		  
      }
	   chartdata = {};
	   chartdata["country"] = SystemEnv.getHtmlNoteName(3615,languageid);
       chartdata["visits"] = uncomplete+"";
	   chartdatas.push(chartdata);

	   chartdata = {};
	   chartdata["country"] = SystemEnv.getHtmlNoteName(3616,languageid);
       chartdata["visits"] = complete+"";
	   chartdatas.push(chartdata);
       
	   percent = complete/(uncomplete+complete);
	   percentage = (complete*100/(uncomplete+complete)).toFixed(0)+"%";
       
	   //根据完成情况确定颜色
	   if(percent === 0){
	     colors = ["#edf0f5","#edf0f5"];
	   }else if(percent === 1){
	     colors = ["#7ed24e","#7ed24e"];
	   }else {
	     colors = ["#edf0f5","#2792ff"];
	   }
     //设置百分比
     $("#"+tasklistid).parent().find(".percentage").html(percentage);
     //生成环形图
	 createChart(tasklistid,chartdatas,colors);


  }


}

//刷新进度任务图
function  refreshTaskProcess(tasklistid,reqid){
     
	 if((tasklistid in taskliststatus) && taskliststatus[tasklistid].length>0){
          	  var items = taskliststatus[tasklistid], itemsnew=[];
              for(var i=0, len=items.length; i<len ;i++){
			       if(items[i].requestid !== reqid){
				       itemsnew.push(items[i]);
				   }
			  }
			  taskliststatus[tasklistid] = itemsnew;
			  //仍需生成进度圈
			  if(itemsnew.length>0){
			       addDutChart(tasklistid);   
			  }else{
                   $("#"+tasklistid).parent().remove();
			  }
	 }

}



/**
设置任务完成
**/
function setComplete(checkbox,tasklistid){
	  //包含子任务的计划需确认子任务完成 方可点击完成操作
      if(checkbox.checked && (tasklistid in taskliststatus) && taskliststatus[tasklistid].length>0){
	       var items = taskliststatus[tasklistid] , flag = true;
		   for(var i=0, len=items.length;i<len;i++){
		      if(~~items[i].uncomplete !== 0){
			     flag = false;
				 break;
			  }
		   }
		   if(!flag){
              changeCheckboxStatus(checkbox,false);
		      window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3619,languageid)+"!");  
			  return;
		   }
	  }

      var msg = "",iscomplete=0;
	  if(checkbox.checked){
	      msg = SystemEnv.getHtmlNoteName(3612,languageid);
          iscomplete = 1;
	  }else{
	      msg = SystemEnv.getHtmlNoteName(3618,languageid);
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
						  //window.top.Dialog.alert("数据更新成功!");
						  //alert(1);
						  //判断是否需要 刷新 worktaskdetailpage 界面
						  //if($("#retasklistid").val() != ""){
						     parent.window.WorkTaskDetailRefresh();
						  //}
					      setProcess();
					  }
					  else
						  window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3617,languageid)+"!");  
				  }
		 });
	  },function(){
	      if(checkbox.checked)
		     changeCheckboxStatus(checkbox,false);
		  else
             changeCheckboxStatus(checkbox,true);
	  });

}

//关联新任务
function  addNewWt(tasklistid){

     //var piframe = $(parent.document.body).find("#worktaskdetailpage");
    // piframe.attr("src","/worktask/pages/worktask.jsp?wtid=-1&tasklistid="+tasklistid);
    parent.window.onChildEditTask("","-1",tasklistid,"");

}


//设置进度条
function  setProcess(){
     var elements = $("input[name='taskcheck']"),reqstatus = $("#request_status").val();
	 var count = 0 ,len = elements.length , widthper = "0%";
	 for(var i=0;i<len;i++){
	     if(elements[i].checked)
	        count++;
	 }
	 //没有任务清单情况下
	 if(count==len && len==0){
		 if(reqstatus === '10' || reqstatus === '9'){//已完成
	        widthper = "100%";
	     }else{
	        widthper = "0%";
	     }
	 }else{
	    widthper = (count*100/len).toFixed(0)+'%';
	 }
     
     $("#worktaskdesign	.processnow").css("width",widthper);
     $("#worktaskdesign	.processnow").attr("title",SystemEnv.getHtmlNoteName(3616,languageid)+" : "+widthper);
     $("#worktaskdesign	.taskprocess").attr("title",SystemEnv.getHtmlNoteName(3616,languageid)+" : "+widthper);
}

//删除任务清单
$(".deletewt").click(function(){
	var checkedItem = $(".worktasklist .listbody").find(".jNiceChecked");
	if(checkedItem.length === 0){
 	   window.top.Dialog.alert(SystemEnv.getHtmlNoteName(3608,languageid)+"!");
 	   return;
    }
    window.top.Dialog.confirm(SystemEnv.getHtmlNoteName(3611,languageid),function(){
       $(".worktasklist .listbody").find(".jNiceChecked").parents("tr").remove()
   });
   
   //更新滚动条
   $('.worktask_detailinfo').perfectScrollbar('update');
});

var istasklogsget = false;
$(".tabheader li").click(function(){
	//移除选中的tab样式
   $(".tabheader li").removeClass("firsttabselected").removeClass("tabselected");
   $(".worktasktabs .panel").hide();
   var current = $(this);
   var tabpanel = current.attr("tabitem");
   $("#"+tabpanel).show();
   if(current.prev("li").length===0){
       current.addClass("firsttabselected");
   }else{
       current.addClass("tabselected");
   }

   if(tabpanel === 'taskexchange'){
       $(".taskexchangesearch").show();
   }else{
       $(".taskexchangesearch").hide();
   }
    //第一次需获取日志
   if(tabpanel === 'tasklog' &&  !istasklogsget){
	       var requestid = $("input[name='requestid']").val();
		   var senddata = {};
		   var loadingimg = $("<image style='position:absolute;left:48%;top:100px;' src='/express/task/images/loading1_wev8.gif'>");
		   $("#tasklog").append(loadingimg);
           senddata["requestid"] = requestid;
		   $.ajax({
					  type: "POST",
					  url:"/worktask/pages/tasklogs.jsp",
					  dataType:'json',
					  data:senddata,
					  success:function(logs){
                        var tables = [],tr;
					    tables.push("<table>");
						tables.push("<colgroup><col width='30%'><col width='50%'><col></colgroup>");
						for(var i=logs.length-1; i >= 0 ; i--){
						   tr="<tr><td>"+logs[i].taskuser+"</td><td>"+logs[i].taskdate+" "+logs[i].tasktime+"</td><td>"+logs[i].taskstatus+"</td></tr>";
						   tables.push(tr);
						}
                        tables.push("</table>")
                        $("#tasklog").html(tables.join(""));
						istasklogsget =  true;
						 //更新滚动条
   						$('.worktask_detailinfo').perfectScrollbar('update');
                   }
			});
   }
  
});


/*初始化tab页**/
function initTabs(pageType){
 var tabheader = $(".tabheader");
 if(pageType===0){
   //只展示相关资源和任务提醒tab页 
    tabheader.find("li[tabitem='taskexchange']").remove();
    tabheader.find("li[tabitem='tasklog']").remove();
    $("#taskexchange").remove();
	$("#tasklog").remove();
	tabheader.find("li[tabitem='taskremind']").trigger("click");
 }else{
    tabheader.find("li[tabitem='taskexchange']").trigger("click");
 }

}


//swf上传对象
var swfu;

function initSwfUpload(uuid) {
	var language = "7";
	var btnwidth = language==8?86:35;
	var settings = {
		flash_url : "/js/swfupload/swfupload.swf",
		upload_url: "/worktask/pages/taskfileupload.jsp?docfiletype=1",
		post_params:{"method":"uploadFile"},
		use_query_string : true,//要传递参数用到的配置
		file_size_limit : "100 MB",
		file_types : "*.*",
		file_types_description : "All Files",
		file_upload_limit : 50,
		file_queue_limit : 0,
		custom_settings : {
			progressTarget : "fsUploadProgress_"+uuid,
			cancelButtonId : "btnCancel"
		},
		debug: false,
		button_image_url : "",
		button_placeholder_id : uuid,
		button_width: 150,
		button_height: 38,
		button_text: '<span class="button">'+SystemEnv.getHtmlNoteName(3776,languageid)+'(100MB)</span>',
		button_text_style: ".button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt;color:#1d76a4 } ",
		button_text_top_padding: 3,
		button_text_left_padding: 32,
		button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
		button_cursor: SWFUpload.CURSOR.HAND,
	    file_queued_handler : fileQueued,
	    file_queue_error_handler : fileQueueError,
	    file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){		
		if (numFilesSelected > 0) {		
               var process = jQuery("#fsUploadProgress_"+uuid);
			   if(process.length===0){
				   process=$("<div  id='fsUploadProgress_"+uuid+"'></div>");
				   $(".fileprocess").append(process);
			   }
			   process.show();
			   this.startUpload();
		}
	},
	upload_start_handler : uploadStart,
	upload_progress_handler : uploadProgress,
	upload_error_handler : uploadError,	
	upload_success_handler : function (file, server_data) {
		var fileid = jQuery.trim(server_data);
		var file="<span class='filecontainer' ><input type='hidden' value='"+fileid+"'><span class='middlehelper'></span><a class='filedes' target='_blank' href='/weaver/weaver.file.FileDownload?fileid="+fileid+"' > "+file.name+" </a><span class='fileclose'>X</span></span>";
		$(".fileitems").append($(file));
		//更新附件id
		setFileids();
	},
	upload_complete_handler : function(){
		 var process = jQuery("#fsUploadProgress_"+uuid);
		 process.html("");
	},
	queue_complete_handler : function(){
	
	}	// Queue plugin event
	};
	
	swfu = new SWFUpload(settings);
}

function initSwfUploadForEx(uuid) {
	var language = "7";
	var btnwidth = language==8?86:35;
	var settings = {
		flash_url : "/js/swfupload/swfupload.swf",
		upload_url: "/worktask/pages/taskfileupload.jsp?docfiletype=1",
		post_params:{"method":"uploadFile"},
		use_query_string : true,//要传递参数用到的配置
		file_size_limit : "100 MB",
		file_types : "*.*",
		file_types_description : "All Files",
		file_upload_limit : 50,
		file_queue_limit : 0,
		custom_settings : {
			progressTarget : "fsUploadProgress_"+uuid,
			cancelButtonId : "btnCancel"
		},
		debug: false,
		button_image_url : "",
		button_placeholder_id : uuid,
		button_width: 150,
		button_height: 38,
		button_text: '<span class="button">'+SystemEnv.getHtmlNoteName(3776,languageid)+'(100MB)</span>',
		button_text_style: ".button { font-family: Helvetica, Arial, sans-serif; font-size: 12pt;color:#1d76a4 } ",
		button_text_top_padding: 3,
		button_text_left_padding: 32,
		button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,
		button_cursor: SWFUpload.CURSOR.HAND,
	    file_queued_handler : fileQueued,
	    file_queue_error_handler : fileQueueError,
	    file_dialog_complete_handler : function(numFilesSelected, numFilesQueued){		
		if (numFilesSelected > 0) {		
               var process = jQuery("#fsUploadProgress_"+uuid);
			   if(process.length===0){
				   process=$("<div  id='fsUploadProgress_"+uuid+"'></div>");
				   $(".exchangeres .relfileprocess").append(process);
			   }
			   process.show();
			   this.startUpload();
			   //给确定  取消按钮添加遮罩
			   showMask();
			   
		}
	},
	upload_start_handler : uploadStart,
	upload_progress_handler : uploadProgress,
	upload_error_handler : uploadError,	
	upload_success_handler : function (file, server_data) {
		var fileid = jQuery.trim(server_data);
		var file="<span class='relfilecontainer' ><input type='hidden' value='"+fileid+"'><span class='middlehelper'></span><a class='relfiledes' target='_blank' href='/weaver/weaver.file.FileDownload?fileid="+fileid+"' > "+file.name+" </a><span class='fileclose'>X</span></span>";
		$(".exchangeres .relfileitems").append($(file));
        resetFileids();
	},
	upload_complete_handler : function(){
		 var process = jQuery("#fsUploadProgress_"+uuid);
		 process.html("");
	},
	queue_complete_handler : function(){
		 //清除遮罩 
		 clearMask();
	}	// Queue plugin event
	};
	
	swfu = new SWFUpload(settings);
}

//附件上传过程,需对确定取消操作做遮罩处理
function showMask(){
	var  maskparent = $(diag.okButton).parent();
	maskparent.css("position","relative");
	var  maskpos = maskparent.offset();
	var  maskitem = $("<div class='maskitem' style='position:absolute;z-index:1000000;'></div>");
	maskitem.css("width",maskparent.outerWidth()+'px');
	maskitem.css("height",maskparent.outerHeight()+'px');
	maskitem.css("left",'0px');
	maskitem.css("top",'0px');
	maskparent.append(maskitem);
}

//附件完成上传则需将遮罩去除
function clearMask(){
	$(".maskitem").remove();
}


//提示信息
function showPrompt(){
     $("#worktaskmsg").show();
}
