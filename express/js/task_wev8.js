
document.onkeydown=keyListener;  //事件监听
document.onkeyup=keyListener3;   //事件监听
function keyListener(e){
    e = e ? e : event;   
    if(e.keyCode == 13){
    	var target=$.event.fix(e).target;
    	//列表标题回车事件
    	if($(target).hasClass("disinput")){
    		var name = $(target).attr("title");
	    	//$(foucsobj).parent().parent().removeClass("td_select td_blur td_hover").addClass("td_blur");
			//document.onkeydown=null;
			//document.onkeyup=null;
	    	//$(foucsobj).unbind("blur");
	    	//$(foucsobj).blur();   
	    	//doAddOrUpdate(foucsobj,1);
    		/*
			if($(target).attr("id")=="" || typeof($(target).attr("id"))=="undefined"){
				if($(target).val()==""){
					return;
				}
				if($(target).hasClass("definput")){
					addItem(1,1);
				}else{
					addItem(0,1);
				}
			}else{
				addItem(0,1);
			}
			*/
    		doAddOrUpdate($(target),1);
    		stopBubble(e);
    	}
    	//明细内容回车事件
    	if($(target).hasClass("input_def")){
    		$(foucsobj2).blur();  
    	}
    	if($(target).attr("id")=="tag" && $(target).val()!=""){
			selectUpdate("tag",$(target).val(),$(target).val(),"str");
			$(target).blur();
		}

    	//ctrl+enter 直接提交反馈
		if($("div.feedback_def").hasClass("feedback_focus") && (event.ctrlKey)){
			doFeedback();
			$("#content").blur();
		}
    		stopBubble(e);
		return false;
    }    
}
function keyListener3(e){
    e = e ? e : event;   
    var target=$.event.fix(e).target;
    //修改列表标题时同步明细标题
	if($(target).hasClass("disinput")){
	    if($(foucsobj).attr("id")==$("#taskid").val()){
		    var nameobj = document.getElementById("name");
		    if(nameobj != null){
		    	if (!$.browser.msie) $("#name").height(0);
		    	$("#name").val($(foucsobj).val()).attr("title",$(foucsobj).val()).height(nameobj.scrollHeight);
			}
		}
	}
	//修改明细标题时同步列表标题
	if($(target).attr("id")=="name"){
		$("#"+taskid).val($(foucsobj2).val()).attr("title",$(foucsobj2).val());  
    }
    //临时保存反馈内容
	if($(target).attr("id")=="content"){
		deffeedback = $(target).html();
    }
}
//新建任务
function addItem(def,focus,position){
	if(foucsobj==null){
		$("table.datalist").first().find("input.definput").focus();
		return;
	}else{
		var newtr = $("<tr class='item_tr' _tasktype='1'>"
				  + "<td class='td_blank'><div>&nbsp;</div></td>"
				  + "<td class='checkbox'></td>"
				  + "<td><div id='' class='div_m_date' title=''>&nbsp;</div></td>"
				  + "<td class='item_att'>&nbsp;</td>"
				  + "<td class='item_td'><div contenteditable='true' onfocus='doClickItem(this)' onblur='doBlurItem(this)' class='disinput addinput "+((def==1)?"definput":"")+"' type='text'  _tasktype='1' name='' value='"+((def==1)?"新建任务":"")+"' id=''></div></td>"
				  + "<td class='item_count'>&nbsp;</td>"
				  + "<td><div id='' class='div_today' title=''>&nbsp;</div></td>"
				  + "<td class='item_hrm'>&nbsp;</td>"
				  + "</tr>");
		//if(foucsobj.length>0){
			if(position==1)		  
				$(foucsobj).parent().parent().before(newtr);
			else
				$(foucsobj).parent().parent().after(newtr);
		//}else{
		//	$("#datalist0 tr:first").after(newtr);
		//}
	}
	if(focus==1 || focus ==0) newtr.click().find("div.disinput").focus();
	/**
	newtr.bind("mouseover",function(){
		$(this).addClass("tr_hover");
	}).bind("mouseout",function(){
		$(this).removeClass("tr_hover");
	}).bind("click",function(){
		$(".item_tr").removeClass("tr_select tr_blur");
		$(this).addClass("tr_select");

	});*/
}
//刷新明细部分
function refreshDetail(taskid,hrmid){
	$("#detailFrame").attr("src","TaskView.jsp?operation=view&taskType=1&taskid="+taskid+"&creater="+hrmid);
}

//修改状态
function changestatus(obj){
	var _taskid = $(obj).attr("_taskid");
	if(_taskid=="" || typeof(_taskid)=="undefined") return;
	var _status = $(obj).attr("_status");
	if(_status==1){
		_status = 2;
	}else{
		_status = 1;
	}
	$.ajax({
		type: "post",
	    url: "/express/task/data/Operation.jsp",
	    data:{"operation":"edit_status","taskId":_taskid,"status":_status}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    success: function(data){ 
	    	reSetStatus(_taskid,_status,1);
		}
    });
}


function reSetStatus(taskid,_status,refresh){
	var obj = $("#status_"+taskid);
	//if(searchstatus!=0){
		//obj.parent().parent().hide();
	//}else{
		if(_status==1){
			obj.attr("_status",_status).attr("title","设置为完成").removeClass("status2 status2_hover status3 status3_hover").addClass("status1");
	    }else if(_status==2){
	    	obj.attr("_status",_status).attr("title","设置为进行中").removeClass("status1 status1_hover status3 status3_hover").addClass("status2");
		}else if(_status==3){
	    	obj.attr("_status",_status).attr("title","设置为进行中").removeClass("status1 status1_hover status2 status2_hover").addClass("status3");
		}
		if(detailid==taskid && refresh==1){
			refreshDetail(taskid);
			//$("#detaildiv").append(loadstr);
			//$("#detaildiv").load("DetailView.jsp?taskId="+taskid+"&status="+_status);
		}
	//}
	if(searchstatus!=0){
		if(_status!=searchstatus){
			obj.parent().parent().hide();
		}else{
			obj.parent().parent().show();
		}
	}
	setIndex();//重置序号
}
//执行下一个任务显示
function showNext(taskid){
	var deltr = $("#"+taskid).parent().parent();
	var next = deltr.next("tr").find("input.disinput");
	if($(next).attr("id")==""){
		$("#detaildiv").html("");
	}else{
		defaultname = $(next).val();
		detailid = $(next).attr("id");
		$("#detaildiv").append(loadstr);
		$("#detaildiv").load("DetailView.jsp?taskId="+$(next).attr("id"));
	}
	
}
function URLencode(sStr) 
{
    return escape(sStr).replace(/\+/g, '%2B').replace(/\"/g,'%22').replace(/\'/g, '%27').replace(/\//g,'%2F');
}
