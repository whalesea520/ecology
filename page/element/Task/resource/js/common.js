window.onload = function() { 
	//Shadowbox.init();
};

function closeShadowBox(){
	Shadowbox.close();
}
function getCount(eid){
	$("#taskDiv_"+eid).showLoading();
	$.ajax({
		url:"/page/element/Task/getTaskList.jsp",
		data:{"operate":"getCount"},
		dataType:"json",
		success:function(data){
			var clickFlag = false;
			if(data.newcount>0){
				$("#tab1_1_"+eid).html(taskTabTag[0]+"(<span>"+data.newcount+"</span>)").click();
				clickFlag = true;
			}
			if(data.fbcount>0){
				$("#tab1_2_"+eid).html(taskTabTag[1]+"(<span>"+data.fbcount+"</span>)");
				if(!clickFlag){
					$("#tab1_2_"+eid).click();
					clickFlag = true;
				}
			}
			if(data.todaycount>0){
				$("#tab1_3_"+eid).html(taskTabTag[2]+"(<span>"+data.todaycount+"</span>)");
				if(!clickFlag){
					$("#tab1_3_"+eid).click();
					clickFlag = true;
				}
			}
			if(data.tomorrowcount>0){
				$("#tab1_4_"+eid).html(taskTabTag[3]+"(<span>"+data.tomorrowcount+"</span>)");
				if(!clickFlag){
					$("#tab1_4_"+eid).click();
					clickFlag = true;
				}
			}
			if(!clickFlag){
				$("#tab1_1_"+eid).click();
			}
		},
		complete:function(data){
			$("#taskDiv_"+eid).hideLoading();
		}
	});
}
function getTaskList(obj,index,eid,perpage,creater,principalid,begindate,enddate){
	$("#taskDiv_"+eid+" .tab1").removeClass("tab1_click");
	obj.addClass("tab1_click");
	$("#taskShow_"+eid).showLoading();
	$.ajax({
		url:"/page/element/Task/getTaskList.jsp",
		data:{"operate":"getTaskList","index":index,"perpage":perpage,"creater":creater,
		"principalid":principalid,"begindate":begindate,"enddate":enddate,"eid":eid},  			
		type:"post",
		success:function(data){
			$("#taskShow_"+eid).html(data);
			var total = 0;
			if($("#taskTotal_"+eid).length>0){
				total = $("#taskTotal_"+eid).val();
			}
			index = parseInt(index);
			if(total>0){
				$("#tab1_"+index+"_"+eid).html(taskTabTag[index-1]+"(<span>"+total+"</span>)");
			}else{
				$("#tab1_"+index+"_"+eid).html(taskTabTag[index-1]);
			}
		},
		complete:function(data){
			$("#taskShow_"+eid).hideLoading();
		}
	});
}