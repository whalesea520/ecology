
var fillSplash = function(datas)
{
	//$("#workPlanArrayIdView").value = this.calendarItem.arrayId;
	var viewBox=$("#editBox");
	viewBox.find("#workPlanArrayIdView").val(datas["id"][0].$$);
	viewBox.find("#workPlanTypeView").html(datas["workPlanTypeName"][0].$$);
	viewBox.find("#planNameView").html( datas["planName"][0].$$);
	viewBox.find("#urgentLevelView").html( datas["urgentLevelName"][0].$$);
	viewBox.find("#remindTypeView").html( datas["remindTypeName"][0].$$);
	viewBox.find("#remindTimeView").html( datas["remindTimeDescription"][0].$$);
	viewBox.find("#executeIdView").html( datas["executeName"][0].$$);
	viewBox.find("#beginDateView").html( datas["startDate"][0].$$);
	viewBox.find("#beginTimeView").html( datas["startTime"][0].$$);
	viewBox.find("#endDateView").html( datas["endDate"][0].$$);
	viewBox.find("#endTimeView").html( datas["endTime"][0].$$);
	viewBox.find("#descriptionView").html( datas["desc"][0].$$);
	viewBox.find("#crmIdView").html( datas["crmIdName"][0].$$);
	viewBox.find("#docIdView").html( datas["docIdName"][0].$$);
	viewBox.find("#projectIdView").html( datas["projectIdName"][0].$$);
	viewBox.find("#taskIdView").html( datas["taskIdName"][0].$$);
	viewBox.find("#requestIdView").html( datas["requestIdName"][0].$$);
	viewBox.find("#meetingIdView").html( datas["meetingIdName"][0].$$);

	
	//已归档或已结束的日程，不能有以下按钮
	var editshareLevel = (datas["shareLevel"][0].$$ > 1);
	var texecuteLevel = (datas["executeId"][0].$$.indexOf(texecuteId)>-1);
	if(editshareLevel&&(datas["status"][0].text == 0))
	{
		$("#eidtCalendarButtonView").show();
		$("#deleteCalendarButtonView").show();
	}
	if((texecuteLevel||editshareLevel)&&(datas["status"][0].text == 0))
	{
		$("#overCalendarButtonView"). show();
	}
	var canShare = datas["canShare"][0].$$;
	if("true" == canShare)
	{
		$("#shareCalendarButtonView").show();
	}
};
function loadShareInfo(calid){
	var param={
			"method":"getCalendarShare",
			"id":calid
	};
	
	$.post("/workplan/calendar/data/getData.jsp?method=getCalendarShare",param,function(data){
		curTable=$("#workPlanShareListTable")[0];
		for(j=curTable.rows.length-1;j>1;j--){
			curTable.deleteRow(j);
		}
		for(var i=0;i< data.data.length;i++){
			item=data.data[i];
			var curRow=$("#workPlanShareListTable")[0].insertRow(-1);
			var oDiv1=document.createElement("div");
			oDiv1.innerHTML=item.shareTypeName;
			curRow.insertCell(-1).appendChild(oDiv1);
			var oDiv2=document.createElement("div");
			oDiv2.innerHTML=item.shareContent;
			curRow.insertCell(-1).appendChild(oDiv2);
			var oDiv3=document.createElement("div");
			oDiv3.innerHTML="<a href=\"javascript:void(0)\" onclick=\"deleteShare('"+item.shareId+"',event)\">删除</a>";
			curRow.insertCell(-1).appendChild(oDiv3);
		}
	},"json");
}
function deleteShare(shareId,e){
	var param={
			"method":"deleteCalendarShare",
			"id":shareId
	};
	$.post("/workplan/calendar/data/getData.jsp",param,function(data){
		if(data.IsSuccess){
			curTable=$("#workPlanShareListTable")[0];
			var index=$(e.target||e.srcElement).parents("tr")[0].rowIndex;
			curTable.deleteRow(index);
		}else{
			alert("删除失败");
		}
	},"json");
}
function initEdit(datas){
	var viewBox=$("#editBox");
	viewBox.find("#workplanId").val(datas["id"][0].$$);
	viewBox.find("#workPlanType").val(datas["workPlanTypeName"][0].$$);
	viewBox.find("#planName").val( datas["planName"][0].$$);
	viewBox.find("#urgentLevel").val( datas["urgentLevelName"][0].$$);
	viewBox.find("#remindType").val( datas["remindTypeName"][0].$$);
	viewBox.find("#remindTime").val( datas["remindTimeDescription"][0].$$);
	viewBox.find("#executeId").val( datas["executeName"][0].$$);
	viewBox.find("#beginDate").val( datas["startDate"][0].$$);
	viewBox.find("#selectBeginDateSpan").html(datas["startDate"][0].$$);
	viewBox.find("#beginTime").val( datas["startTime"][0].$$);
	viewBox.find("#selectBeginTimeSpan").html( datas["startTime"][0].$$);
	viewBox.find("#endDate").val( datas["endDate"][0].$$);
	viewBox.find("#endDateSpan").html( datas["endDate"][0].$$);
	viewBox.find("#endTime").val( datas["endTime"][0].$$);
	viewBox.find("#endTimeSpan").html( datas["endTime"][0].$$);
	viewBox.find("#description").val( datas["desc"][0].$$);
	viewBox.find("#crmIDsspan").html( datas["crmIdName"][0].$$);
	viewBox.find("#crmIDs").val( datas["relatedCustomer"][0].$$);
	viewBox.find("#docIDsspan").html( datas["docIdName"][0].$$);
	viewBox.find("#docIDs").val( datas["relatedDocument"][0].$$);
	viewBox.find("#projectIDsspan").html( datas["projectIdName"][0].$$);
	viewBox.find("#projectIDs").val( datas["relatedProject"][0].$$);
	viewBox.find("#taskId").val( datas["taskIdName"][0].$$);
	viewBox.find("#requestId").val( datas["requestIdName"][0].$$);
	viewBox.find("#meetingId").val( datas["meetingIdName"][0].$$);
}

var cleanSplashForView = function()
{
	$("#workPlanTypeView").empty();
	$("#planNameView").empty();
	$("#urgentLevelView").empty();
	$("#remindTypeView").empty();
	$("#remindTimeView").empty();
	$("#executeIdView").empty();
	$("#beginDateView").empty();
	$("#beginTimeView").empty();
	$("#endDateView").empty();
	$("#endTimeView").empty();
	$("#descriptionView").empty();
	$("#crmIdView").empty();
	$("#docIdView").empty();
	$("#projectIdView").empty();
	$("#taskIdView").empty();
	$("#requestIdView").empty();
	$("#meetingIdView").empty();
	
	$("#eidtCalendarButtonView").hide();
	$("#overCalendarButtonView").hide();
	$("#deleteCalendarButtonView").hide();
	$("#shareCalendarButtonView").hide();
};

function WorkPlanEvent(datas){
	this.id=datas.id;
	this.canShare=datas.canShare;
	this.type=datas.type;
	this.planName=datas.planName;
	this.itemName=datas.itemName;
	this.color=datas.color;
	this.urgent=datas.urgent;
	this.remindType=datas.remindType;
	this.remindBeforeStart=datas.remindBeforeStart;
	this.remindBeforeStartMinute=datas.remindBeforeStartMinute;
	this.remindBeforeStartHour=datas.remindBeforeStartHour;
	this.remindBeforeEnd=datas.remindBeforeEnd;
	this.remindBeforeEndMinute=datas.remindBeforeEndMinute;
	this.remindBeforeEndHour=datas.remindBeforeEndHour;
	this.executeId=datas.executeId;
	this.startDate=datas.startDate;
	this.startTime=datas.startTime;
	this.endDate=datas.endDate;
	this.endTime=datas.endTime;
	this.desc=datas.desc;
	this.description=datas.description;
	this.relatedCustomer=datas.relatedCustomer;
	this.relatedDocument=datas.relatedDocument;
	this.relatedProject=datas.relatedProject;
	this.relatedWorkFlow=datas.relatedWorkFlow;
	this.relatedTask=datas.relatedTask;
	this.relatedMeeting=datas.relatedMeeting;
	this.status=datas.status;
	this.shareLevel=datas.shareLevel;
	this.exchangeCount=datas.exchangeCount;
	this.workPlanTypeName=datas.workPlanTypeName;
	this.workPlanType=datas.type;
	this.urgentLevelName=datas.urgentLevelName;
	this.remindTypeName=datas.remindTypeName;
	this.remindTimeDescription=datas.remindTimeDescription;
	this.executeName=datas.executeName;
	this.crmIdName=datas.crmIdName;
	this.docIdName=datas.docIdName;
	this.projectIdName=datas.projectIdName;
	this.taskIdName=datas.taskIdName;
	this.requestIdName=datas.requestIdName;
	this.meetingIdName=datas.meetingIdName;
		WorkPlanEvent.prototype.disableAll=function(){
			$("#editBox input").attr("disabled",true);
			$("#editBox select").attr("disabled",true);
			$("#editBox textarea").attr("disabled",true);
			$("#editBox button").hide();
			
		};
		WorkPlanEvent.prototype.enableAll=function(){
			$("#editBox input").attr("disabled",false);
			$("#editBox select").attr("disabled",false);
			$("#editBox textarea").attr("disabled",false);
			$("#editBox button").show();
			
		};
		WorkPlanEvent.prototype.FillWorkPlanView=function(){
			if(this.shareLevel<=1){
				this.disableAll();
			}else{
				this.enableAll();
			}
			workPlanTypeInfo=this.getWorkTypeList(this.type, workPanTypeList);
			if(workPlanTypeInfo.disable||this.shareLevel<2){
				$("#workPlanTypeSelect").attr("disabled",true);
			}else{
				$("#workPlanTypeSelect").attr("disabled",false);
				$("#workPlanTypeSelect").html("");
				
			}
			if(workPlanTypeInfo.list&&workPlanTypeInfo.list.length>0){
				for(var i=0;i<workPlanTypeInfo.list.length;i++){
					$("#workPlanTypeSelect").append("<option value='"+workPlanTypeInfo.list[i].id+"' "+(this.workPlanType==workPlanTypeInfo.list[i].id?"selected":"")+">"+workPlanTypeInfo.list[i].name+"</option>");
				}
			}
			
			var viewBox=$("#editBox");
			viewBox.find("#workplanId").val(this.id);
			viewBox.find("#workPlanType").val(this.workPlanType);
			
			viewBox.find("#planName").val( this.planName.replace(/<[^>]+>/g,""));
			viewBox.find("#urgentLevel").val( this.urgent);
			viewBox.find("#remindType").val( this.remindType);
			viewBox.find("#remindTime").val( this.remindTimeDescription);
			viewBox.find("#executeId").val( this.executeId);
			viewBox.find("#beginDate").val( this.startDate);
			viewBox.find("#beginDateSpan").html(this.startDate);
			viewBox.find("#beginTime").val( this.startTime);
			viewBox.find("#beginTimeSpan").html( this.startTime);
			viewBox.find("#endDate").val( this.endDate);
			viewBox.find("#endDateSpan").html( this.endDate);
			viewBox.find("#endTime").val( this.endTime);
			viewBox.find("#endTimeSpan").html( this.endTime);
			viewBox.find("#description").val( this.description.replace(/<[^>]+>/g,""));
			viewBox.find("#crmIDsspan").html( this.crmIdName);
			viewBox.find("#crmIDs").val( this.relatedCustomer);
			viewBox.find("#docIDsspan").html( this.docIdName);
			viewBox.find("#docIDs").val( this.relatedDocument);
			viewBox.find("#projectIDsspan").html(this.projectIdName );
			viewBox.find("#projectIDs").val( this.relatedProject);
			viewBox.find("#taskId").val( this.relatedTask);
			viewBox.find("#requestIDs").val( this.relatedWorkFlow);
			viewBox.find("#requestIDsspan").html(this.requestIdName);
			viewBox.find("#meetingId").val( this.requestIdName);
			viewBox.find("#memberIDs").val(this.executeId);
			viewBox.find("#memberIDsspan").html(this.executeName);
			viewBox.find("#remindDateBeforeStart").val(this.remindBeforeStartHour);
			viewBox.find("#remindTimeBeforeStart").val(this.remindBeforeStartMinute);
			viewBox.find("#remindDateBeforeEnd").val(this.remindBeforeEndHour);
			viewBox.find("#remindTimeBeforeEnd").val(this.remindBeforeEndMinute);
			if(""==this.remindType||"1"==this.remindType){
				$("#remindInfo").hide();
				viewBox.find("#remindType").val( 1);
			}else{
				$("#remindInfo").show();
				if(this.remindBeforeStart=="1"){
					$("#remindBeforeStart").attr("checked","checked");
				}else{
					$("#remindBeforeStart").attr("checked","");
				}
				if(this.remindBeforeEnd=="1"){
					$("#remindBeforeEnd").attr("checked","checked");
				}else{
					$("#remindBeforeEnd").attr("checked","");
				}
			}
			if(this.planName){
				$("#planName").next().hide();
			}else{
				$("#planName").next().show();
			}
			if(this.description){
				$("#description").next().hide();
			}else{
				$("#description").next().show();
			}
		};
		WorkPlanEvent.prototype.clearWorkPlanView=function (){
			$("#workPlanTypeSelect").html("");
			$("#workPlanTypeSelect").attr("disabled",false);
			for(var i=0;i<workPlanTypeForNewList.length;i++){
				$("#workPlanTypeSelect").append("<option value='"+workPlanTypeForNewList[i].id+"'>"+workPlanTypeForNewList[i].name+"</option>");
			}
			var viewBox=$("#editBox");
			viewBox.find("#workplanId").val("0");
			viewBox.find("#workPlanType").val("0");
			viewBox.find("#planName").val( "");
			viewBox.find("#urgentLevel").val("1")
			viewBox.find("#remindType").val( "1");
			viewBox.find("#remindTimeBeforeStart").val("10");
			viewBox.find("#remindTimeBeforeEnd").val("10");
			viewBox.find("#remindDateBeforeStart").val("0");
			viewBox.find("#remindDateBeforeEnd").val("0");
			viewBox.find("#executeId").val( "");
			viewBox.find("#beginDate").val( "");
			viewBox.find("#beginDateSpan").html("");
			viewBox.find("#beginTime").val( "");
			viewBox.find("#beginTimeSpan").html( "");
			viewBox.find("#endDate").val( "");
			viewBox.find("#endDateSpan").html("");
			viewBox.find("#endTime").val( "");
			viewBox.find("#endTimeSpan").html( "");
			viewBox.find("#description").val("");
			viewBox.find("#crmIDsspan").empty( );
			viewBox.find("#crmIDs").val( "");
			viewBox.find("#docIDsspan").html( "");
			viewBox.find("#docIDs").val( "");
			viewBox.find("#projectIDsspan").html(this.projectIdName );
			viewBox.find("#projectIDs").val("");
			viewBox.find("#projectIDsspan").empty();
			viewBox.find("#taskId").val( "");
			viewBox.find("#requestIDsspan").empty();
			viewBox.find("#requestIDs").val( "");
			viewBox.find("#meetingId").val( "");
			viewBox.find("#planName").next().show();
			viewBox.find("#description").next().show();
			viewBox.find("#memberIDs").val("");
			viewBox.find("#memberIDsspan").html("<img align='absMiddle' src='/images/BacoError_wev8.gif'>");
			$("#remindBeforeStart").attr("checked","");
			$("#remindBeforeEnd").attr("checked","");
			//清空浏览按钮及对应隐藏域
			viewBox.find(".Browser").siblings("span").html("");
			viewBox.find(".Browser").siblings("input[type='hidden']").val("");
			viewBox.find(".e8_os").find("input[type='hidden']").val("");
			viewBox.find(".e8_outScroll .e8_innerShow span").html("");
			
		};
		WorkPlanEvent.prototype.saveWorkPlanEvent=function(datas){
			
		};
		WorkPlanEvent.prototype.setEditStatus=function(status){
			
			
		};
		WorkPlanEvent.prototype.generateData=function(datas){
			datas.id=$("#workplanId").val();
			datas.workPlanType=$("#workPlanType").val();
			datas.planName=encodeURIComponent($("#planName").val());
			datas.type=$("#workPlanType").val();
			datas.description=encodeURIComponent($("#description").val());
			datas.beginDate=$("#beginDate").val();
			datas.beginTime=$("#beginTime").val();
			datas.endDate=$("#endDate").val();
			datas.endTime=$("#endTime").val();
			datas.crmIDs=$("input[name=crmIDs]").val();
			datas.docIDs=$("input[name=docIDs]").val();
			datas.projectIDs=$("input[name=projectIDs]").val();
			datas.remindType=$("select[name=remindType]").val();
			datas.requestIDs=$("input[name=requestIDs]").val();
			datas.memberIDs=$("input[name=memberIDs]").val();
			datas.urgentLevel=$("#urgentLevel").val();
			if($("input[name=remindBeforeEnd]").attr("checked")){
				datas.remindBeforeEnd=$("input[name=remindBeforeEnd]").val();
				datas.remindTimesBeforeEnd=$("input[name=remindTimeBeforeEnd]").val();
				datas.remindDateBeforeEnd=$("input[name=remindDateBeforeEnd]").val();
			}
			if($("input[name=remindBeforeStart]").attr("checked")){
				datas.remindBeforeStart=$("input[name=remindBeforeStart]").val();
				datas.remindTimesBeforeStart=$("input[name=remindTimeBeforeStart]").val();
				datas.remindDateBeforeStart=$("input[name=remindDateBeforeStart]").val();
			}
			return datas;
		};
		WorkPlanEvent.prototype.getWorkTypeList =function(type,list){
			var newList=[];
			var result={};
			if(type>=1&&type<=6){
			   result.disable=true;
			}
			for(var i=0;i<list.length;i++){
				if(result.disable){
				   if(type==list[i].id)
				      newList.push(list[i]);
				}else{
				   if(list[i].id==0||list[i].id>=7)
				      newList.push(list[i]);
				}
			}
			
			result.list=newList
			return result;
		};
		WorkPlanEvent.prototype.FillWorkPlanViewSplash=function(){
			$("#workplanIdView").val(this.id);
			$("#workplanTypeView").html(this.workPlanTypeName);
			$("#planNameView").html(this.planName);
			$("#descriptionView").html(this.description.split("\n").join("<br/>"));
			$("#memberView").html(this.executeName);
			$("#urgentLevelView").html(this.urgentLevelName);
			$("#remindTypeName").html(this.remindTypeName);
			if(parseInt(this.remindType)>1){
				$("#remindTypeView").show();
				$("#remindTimeDescriptionView").html(this.remindTimeDescription);
			}else{
				$("#remindTypeView").hide();
				$("#remindTimeDescriptionView").html("");
			}
			$("#beginDateTimeView").html(this.startDate+" "+this.startTime);
			$("#endDateTimeView").html(this.endDate+" "+ this.endTime);
			$("#crmView").html(this.crmIdName);
			$("#docView").html(this.docIdName);
			$("#projectView").html(this.projectIdName);
			$("#requestView").html(this.requestIdName);
		};
		WorkPlanEvent.prototype._fillWorkplanShareTable=function(){
			WorkPlanEvent.prototype.canShare;
		};
}
 
 