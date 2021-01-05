/** 主页面部分 */
function checknew(){
	$.ajax({
		type: "post",
	    url: "Operation.jsp",
	    data:{"operation":"check_new"}, 
	    complete: function(data){
			$("#checknew").html($.trim(data.responseText));
			setnew();
		}
    });
}
function setnew(){
	var mynew = 0;
	var index = 0;
	for(var i=2;i<10;i++){
		index = i;
		if(i==7) index=8;
		if(i==8) index=9;
		if(i==9){
			mynew=parseInt(newMap.get("mine"+i));
			break;
		}
		var amount = parseInt(newMap.get("mine"+i));
		if(amount>0){
			if(i==3 || i==4) mynew += amount;
			var title = amount+"条未读或有新反馈的任务";
			if(i==2 || i==8) title = amount+"条有新反馈的任务";
			if(i==7) title = amount+"条已完成有新反馈的任务";
			$("#icon1_"+index).html(amount).removeClass("cond_icon10").addClass("cond_icon11 cond_icon_count").attr("title",title);
		}else{
			$("#icon1_"+index).html("").removeClass("cond_icon11 cond_icon_count").addClass("cond_icon10").attr("title","");
		}
	}
	if(parseInt(mynew)>0){
		$("#icon1_1").html(mynew).removeClass("cond_icon10").addClass("cond_icon11 cond_icon_count").attr("title",mynew+"条未读或有新反馈的任务");
	}else{
		$("#icon1_1").html("").removeClass("cond_icon11 cond_icon_count").addClass("cond_icon10").attr("title","");
	}
}

var resizeTimer = null;  
$(window).resize(function(){
	if(resizeTimer) clearTimeout(resizeTimer);  
	resizeTimer = setTimeout("setPosition()",100);  
});

// 控制状态分类下拉菜单的控制
$(document).bind("click",function(e){
	var target=$.event.fix(e).target;
	if(!$(target).hasClass("topItem")&&!$(target).hasClass("refDiv")
			&&!$(target).hasClass("topText")&&!$(target).hasClass("imgdown")
			&&!$(target).hasClass("add_more_info")){
		$(".refDiv").hide();
	}
	if($(target).parents(".logdiv").length<=0&&!$(target).hasClass("viewLogDiv")&&!$(target).hasClass("logdiv")){
		$("#logdiv").hide().attr("status",0);
	}
	setClickExec(target);
	
	if(!$(target).hasClass("relbtn") && $("#reltrfileids").length>0){
		setRelate("fileids");
	}
});
function setClickExec(target){
	var tid = getVal($(target).attr("id"));
	$("input.add_input").each(function(){
		if(tid!=$(this).attr("id") && $(this).css("display")!="none"
			&& $(this).nextAll("div.btn_browser").get(0)!=$(target).get(0)
			&& $(this).nextAll("div.btn_add").get(0)!=$(target).get(0)
			&& this!=$(target).get(0)
			){
			
			
			var _type = getVal($(this).parents("tr:first").attr("_type"));
			if(!$(target).hasClass("relbtn") && !$(target).hasClass("item_ep")){
				$(this).hide();
				//$(this).nextAll("div.btn_add").show();
				$(this).nextAll("div.btn_browser").hide();
				$(this).prevAll("div.showcon").show();
				
				if(_type!="" && ($("#fuzzyquery_query_div").length==0 || $("#fuzzyquery_query_div").css("display")=="none") 
						&& !$(target).hasClass("add_input")){
					//alert(11);
					setRelate(_type);
				}
				
				if($(this).parent("#divsubpid").length>0){
					$("#divsubpid").hide();
					editsubid = "";
				}
			
			}else{
				var _type2 = getVal($(target).attr("_type"));
				if(_type2!=_type){
					setRelate(_type);
				}
				
			}
		}
	});
}

function hideSearch(){
	$("#fuzzyquery_query_div").slideUp("fast",function() {});
}
// 显示状态下拉菜单
function showChangeStatus(){
	$("#statusbtn").css({
		"left":$("#changestatus").position().left+"px",
		"top":"67px"
	}).show();
}
// 切换状态
function doChangeStatus(obj,status){
	if(statuscond==status){
		return;
	}else{
		statuscond=status;
		$("#statusTopDiv").find(".topText").html($(obj).html());
		$("#statusDiv").hide();
		loadList();
	}
}
// 显示分类下拉菜单
function showChangeSort(){
	$("#sortbtn").css({
		"left":$("#changesort").position().left+"px",
		"top":"67px"
	}).show();
}
// 切换分类
function doChangeSort(obj,status){
	if(sortcond==status){
		return;
	}else{
		$("#todoDiv").hide();
		sortcond=status;
		$("#todoText").html($(obj).html());
		if(status==5){
			statuscond=1;
			$("#statusTopDiv").hide();
			$("#statusTopDiv").find(".topText").html("进行中");
		}else{
			$("#statusTopDiv").show();
		}
		setPosition();
		loadList();
	}
}
// 加载列表部分
function loadList(){
	var date = new Date();
	listloadststus = date;
	$("#listview").append(loadstr);// .load("ListView.jsp?status="+statuscond+"&sorttype="+sortcond+"&condtype="+condtype+"&hrmid="+hrmid+"&tag="+tag);
	$.ajax({
		type: "post",
	    url: "ListView.jsp?"+new Date().getTime(),
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    data:{"status":statuscond,"sorttype":sortcond,"condtype":condtype,"hrmid":hrmid,"tag":encodeURI(tag),"viewId":viewId,"taskid":inittaskid}, 
	    complete: function(data){ 
		    if(listloadststus==date){
		    	$("#listview").html(data.responseText);
		    	if(inittaskid!=""){
		    		foucsobj = $("#"+inittaskid);
		    		loadDetail(inittaskid);
		    		inittaskid = "";
		    	}
		    	if(condtype==1){
		    		foucsobj = null;
		    	}else{
		    		/**
			    	if($("#"+detailid).length>0){
			    		defaultname = $("#"+detailid).val();
			    		$("#"+detailid).attr("_defaultname",$("#"+detailid).val());
	
			    		if(!$("#"+detailid).parent().parent().hasClass("tr_select") && getVal($(foucsobj).attr("id"))!=""){
			    			$(".item_tr").removeClass("tr_select tr_blur");
			    			$("#"+detailid).removeClass("newinput").parent().parent().addClass("tr_select");
			    			
			    			var objcount = $("#"+detailid).parent().nextAll("td.item_count");
			    			var _fbcount = objcount.attr("_fbcount");
			    			if(parseInt(_fbcount)>0){
			    				objcount.removeClass("item_count_new").attr("title",_fbcount+"条反馈");
			    			}
			    			foucsobj = $("#"+detailid);
			    		}
			    	}*/
		    	}
			}
		}
    });
}
// 加载明细部分
function loadDetail(id,name){
	var upload = document.getElementById("uploadDiv");
	if(upload!=null) upload.innerHTML = "";
	var fbupload = document.getElementById("fbUploadDiv");
	if(fbupload!=null) fbupload.innerHTML = "";
	//if($("#mainiframe").length>0) $("#mainiframe").attr("src","");
	
	defaultname = name;
	detailid = id;
	detailloadstatus = id;
	if($("#"+id).length>0){
		foucsobj = $("#"+id);
	}else{
		foucsobj = null;
	}
	
	$("#detaildiv").html("").append(loadstr);// .load("DetailView.jsp?taskId="+id);
	$.ajax({
		type: "post",
	    url: "DetailView.jsp",
	    data:{"taskId":id}, 
	    complete: function(data){ 
		    if(detailloadstatus==id){
		    	$("#detaildiv").html(data.responseText);
			}
		}
    });
	$("#objname").blur();
	$(".item_tr").removeClass("tr_select tr_blur");
	$("#item_tr_"+id).addClass("tr_select");
}
// 通过搜索框查询某人时执行的加载列表部分
function searchList(id,name){
	if(id==0) id="";
	datatype = 1;
	condtype = 0;
	hrmid = id;
	tag = "";
	$("#hrmTopDiv").find(".topText").html(name);
	$("#hrmdiv").hide();
	loadList();
	loadDefault(id);
}
function loadDefault(id){
	detailid = "";
	focusobj = null;
	var upload = document.getElementById("uploadDiv");
	if(upload!=null) upload.innerHTML = "";
	var fbupload = document.getElementById("fbUploadDiv");
	if(fbupload!=null) fbupload.innerHTML = "";
	$.ajax({
		type: "post",
	    url: "DefaultView.jsp",
	    data:{"hrmid":hrmid}, 
	    complete: function(data){ 
		    if(hrmid==id){
		    	$("#detaildiv").html(data.responseText);
			}
		}
    });
}
// 替换ajax传递特殊符号
function filter(str){
	str = str.replace(/\+/g,"%2B");
    str = str.replace(/\&/g,"%26");
	return str;	
}
var speed = 200;
var w1;
var w2;
// 设置各部分内容大小及位置
function setPosition(){
	$("#detaildiv").height($("#detail").height());//-11
	$("#listview").height($("#main").height()-40);
	var width = $("#view").width();
	var minWidth = 568;
	if($("#statusTopDiv").is(":hidden")){
		minWidth = 500;
	}
	if(width<minWidth){
		$("#searchDiv").css({
			"border-left":"1px solid #e4e4e4"
		});
	}else{
		$("#searchDiv").css({
			"border-left":"0px"
		});
	}
}
function doClick(id,type,obj,name){
	$("span.org_select").removeClass("org_select");
	var _title = name;
	if(obj!=null){
		$(obj).parent().addClass("org_select");
	}else{
		$("#itemdiv2").find("li").each(function(){
			var liid = $(this).attr("id");
			if(liid.split("|").length>1){
				if(liid.split("|")[1]==id){
					$(this).children("span").addClass("org_select");
					return;
				}
			}
		});
	}
	searchList(id,name);
}
// var aa;
// 显示左侧菜单
function showMenu(){
	if($(window).width()<=1220){
		$("#view").stop().animate({ left:246 },speed,null,function(){});
		// clearTimeout(aa);
	}
	$("#addbtn").hide();
}
// 遮挡左侧菜单
function hideMenu(){
	// 判断宽度 以及搜索框是否显示
	if($(window).width()<=1220 && ($("#fuzzyquery_query_div").length==0 || $("#fuzzyquery_query_div").css("display")=="none")){
		// aa = setTimeout(doHide,100);
		doHide();
	}
}
function doHide(){
	$("#view").stop().animate({ left:30 },speed,null,function(){});
	$("#addbtn").hide();
}

/** 原列表部分 */

// 设置序号
function setIndex(){
	$("table.datalist").each(function(){
		var index=1;
		$(this).find(".showIndex").each(function(){
			if($(this).parent().parent().parent().css("display")!="none"){
				$(this).html(index+".");
			    index++;
			}
		});
	});
}

// 键盘上下移动事件
function moveUpOrDown(d,cobj){
	var inputs = $("input.disinput");
	var len = inputs.length;
	var showobj;
	if(len>1){
		for(var i=0;i<len;i++){
			if($(inputs[i]).attr("_index")==cobj.attr("_index")){
				if(d==2){
					if(i==0) i=len;
					showobj = $(inputs[i-1]);
				}
				if(d==1){
					if(i==(len-1)) i=-1;
					showobj = $(inputs[i+1]);
				}
				
				// showobj.focus();
				
				var obj = showobj.get(0);
			    if (obj.createTextRange) {// IE浏览器
			       var range = obj.createTextRange();
			       range.moveStart("character", showobj.val().length);
			       range.collapse(true);
			       range.select();
			    } else {// 非IE浏览器
				    
			       obj.setSelectionRange(showobj.val().length, showobj.val().length);
			       obj.focus();
			    }

			    showobj.parent().parent().click();
				return;
			}
		}
	}
}
// 标题点击事件
var autoNum = 1;
function doClickItem(obj,quickfb){
	foucsobj = obj;
	if($(obj).attr("id")=="" || typeof($(obj).attr("id"))=="undefined"){
		tr_taskid = "";
		if($(obj).hasClass("addinput")) {
			$(obj).removeClass("addinput").val("");
		}
		var _datetype = $(obj).parents("table.datalist").attr("_datetype");
		var pid = getVal($(obj).attr("_pid"));
		var pName = "";
		if(pid!=""){
			pName = $("#"+pid).val();
		}
		var iframeSrc = "Add.jsp?sorttype="+sorttype+"&datetype="+_datetype+"&parentid="+pid+"&pName="+pName+"&saveType=2"
		var height = $(window).height();
		//alert("windowHeight---"+height);
		$("#detaildiv").height(height);
		$("tr.item_tr").removeClass("tr_select tr_blur");
		//$(obj).parent().parent().parent().addClass("tr_select");
		$("#detaildiv").html("<iframe src='"+iframeSrc+"' id='rightIframe' width='100%' height='"+height+"' border='0' frameborder='no'></iframe>");
		return;
	}
}
//右边新建任务后模拟点击任务操作
function doCloneClick(ctaskid,taskName,dutyMan,ifNew,endDate,todoType,levVal){
	loadList();
	loadDetail(ctaskid);
}
// 标题失去焦点事件
function doBlurItem(obj){
	doAddOrUpdate(obj);
}
//执行新建或编辑
function doAddOrUpdate(obj,enter){
	var ctaskid = $(obj).attr("id");
	var taskname = encodeURI($(obj).val());
	if(ctaskid=="" || typeof(ctaskid)=="undefined"){// 新建
		var pid = getVal($(obj).attr("_pid"));
		if($(obj).val()=="" || $(obj).val()=="新建任务"){
			if($(obj).hasClass("definput")){
				$(obj).addClass("addinput").val("新建任务");
			}
		}else{
			var _datetype = $(obj).parents("table.datalist").attr("_datetype");
			$.ajax({
				type: "post",
			    url: "Operation.jsp",
			    data:{"operation":"add","taskName":filter(taskname),"sorttype":sorttype,"datetype":_datetype,"principalid":principalid,"parentid":pid,"tag":filter(encodeURI(tag))}, 
			    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			    complete: function(data){ 
			    	data=$.trim(data.responseText);
			    	ctaskid = data.split("$")[0];
			    	$(obj).attr("id",ctaskid)
			    		.attr("title",$(obj).val())
			    		.attr("_pid",pid);
			    	
			    	var trobj = $(obj).parent().parent().parent();
			    	trobj.attr("id","item_tr_"+ctaskid).attr("_taskid",ctaskid).removeClass("item_tr_blank");
					if((foucsobj!=null && ($(foucsobj).attr("id")=="" || typeof($(foucsobj).attr("id"))=="undefined")) || $(foucsobj).attr("id")==ctaskid){
						loadDetail(ctaskid);
					}
					loadList();
				}
		    });
		}
		
	}else{
		
	}
}
// 下级任务标题点击事件
function doClickSubItem(obj){
	$(obj).parent().addClass("subtr_border2");
	if($(obj).attr("id")=="" || typeof($(obj).attr("id"))=="undefined"){
		if($(obj).hasClass("subaddinput")) $(obj).removeClass("subaddinput").val("");
	}else{
		//refreshDetail($(obj).attr("id"));
	}
}
// 下级任务标题失去焦点事件
function doBlurSubItem(obj){
	$(obj).parent().removeClass("subtr_border2");
	doAddOrUpdateSub(obj);
}
//执行新建或编辑下级任务
function doAddOrUpdateSub(obj,enter){
	var subtaskid = $(obj).attr("id");
	var taskname = encodeURI($(obj).val());
	if(taskname==""||taskname=="新建下级任务"){
		$(obj).addClass("subaddinput").val("新建下级任务");
		return;
	}
	if(subtaskid=="" || typeof(subtaskid)=="undefined"){// 新建
		var pid = getVal($(obj).attr("_pid"));
		if($(obj).val()=="" || $(obj).val()=="新建下级任务"){
			if(pid==""){
				$(obj).addClass("subaddinput").val("新建下级任务");
			}
		}else{
			if(pid=="") pid = taskid;
			var _datetype = $(obj).parents("table.datalist").attr("_datetype");
			$.ajax({
				type: "post",
			    url: "Operation.jsp",
			    data:{"operation":"add","taskName":filter(taskname),"sorttype":sorttype,"datetype":_datetype,"principalid":$("#principalid_val").val(),"parentid":pid,"tag":filter(encodeURI(tag))}, 
			    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			    complete: function(data){ 
			    	data=$.trim(data.responseText);
			    	subtaskid = data.split("$")[0];
			    	$(obj).attr("id","sub_"+subtaskid)
			    		  .attr("title",$(obj).val())
			    	      .attr("_defaultname",$(obj).val())
			    	      .attr("_pid",pid);
			    	var trobj = $(obj).parent().parent();
			    	trobj.attr("id","subitem_tr_"+subtaskid).attr("_taskid",subtaskid).removeClass("subitem_tr_blank");
			    	loadList();
			    	loadDetail(pid);
				}
		    });
		}
	}else{
	}
}


document.onkeydown=keyListener;
document.onkeyup=keyListener3;
function keyListener(e){
    e = e ? e : event;   
    if(e.keyCode == 13){
    	var target=$.event.fix(e).target;
    	// 列表标题回车事件
    	if($(target).hasClass("disinput")){
			if($(target).attr("id")=="" || typeof($(target).attr("id"))=="undefined"){
				if($(target).val()==""){
					return;
				}else{
					doAddOrUpdate(target);
				}
			}
    	}
    	// 下级列表标题回车事件
    	if($(target).hasClass("subdisinput")){
    		doAddOrUpdateSub(target);
    	}
    	// 明细内容回车事件
    	if($(target).hasClass("input_def")){
    		$(foucsobj2).blur();  
    	}
    	if($(target).attr("id")=="tag" && $(target).val()!=""){
			selectUpdate("tag",$(target).val(),$(target).val(),"str");
			$(target).blur();
		}

    	// ctrl+enter 直接提交反馈
		if($("div.feedback_def").hasClass("feedback_focus") && (event.ctrlKey)){
			doFeedback();
			$("#content").blur();
		}
    	
		//setClickExec(target);
		
    }    
}
function setClickExec2(){
	var _type = getVal($(this).parents("tr:first").attr("_type"));
	$("input.add_input").each(function(){
		$(this).hide();
		$(this).nextAll("div.btn_browser").hide();
		$(this).prevAll("div.showcon").show();
		
		if(_type!="" && ($("#fuzzyquery_query_div").length==0 || $("#fuzzyquery_query_div").css("display")=="none")){
			//alert(11);
			setRelate(_type);
		}
		
		if($(this).parent("#divsubpid").length>0){
			$("#divsubpid").hide();
			editsubid = "";
		}
	});	
}

function keyListener3(e){
    e = e ? e : event;   
    var target=$.event.fix(e).target;
    // 修改列表标题时同步明细标题
  	if($(target).hasClass("disinput")){
	    if($(foucsobj).attr("id")==$("#taskid").val()){
		    var nameobj = document.getElementById("name");
		    if(nameobj != null){
		    	if (!$.browser.msie) $("#name").height(0);
		    	$("#name").val($(foucsobj).val()).attr("title",$(foucsobj).val()).height(nameobj.scrollHeight);
			}
		}
  	}
  	// 修改明细标题时同步列表标题
  	//if($(target).attr("id")=="name"){
  	//	$("#"+taskid).val($(foucsobj2).val()).attr("title",$(foucsobj2).val());  
    //}
    // 临时保存反馈内容
  	if($(target).attr("id")=="content"){
  		deffeedback = $(target).html();
    }
  	
}
// 添加新建任务
function addItem(def,focus){
	var newtr = null;
	if(foucsobj==null){
		$("table.datalist").first().find("input.definput").focus();
		return;
	}else{
		var pid = getVal($(foucsobj).attr("_pid"));
		var cid = getVal($(foucsobj).attr("id"));
		
		if(pid!="" && cid!="") pid = cid;
		var newstr = "<tr id='' class='item_tr item_tr_blank' _taskid=''>";
		if(pid==""){
			newstr += "<td class='td_blank'><div>&nbsp;</div></td>";
		}
		newstr	+= "<td width='20px'>"
			+ "	<div id='' class='status' _taskid='' _status='1' title='' onclick='changestatus(this)'>&nbsp;</div>"
			+ "	<div id='' class='div_todo' style='display:none' onclick='showTodo2(this)' title='' _val='' _taskid=''>&nbsp;</div>"
			+ "</td>"
			+ "<td class='item_td'><input onfocus='doClickItem(this)' onblur='doBlurItem(this)' _pid='"+pid+"' class='disinput addinput "+((def==1)?"definput":"")+"' type='text' name='' value='"+((def==1)?"新建任务":"")+"' id='' _index="+(index++)+"/></td>"
			+ "<td class='item_count'>&nbsp;</td>"
			+ "<td style='text-align: center;'><div id='' class='div_enddate' title=''>&nbsp;</div></td>"
			+ "<td class='item_hrm'>&nbsp;</td>"
			+ "</tr>";
		/**
		var newstr = "<tr id='' class='item_tr'>"
				  + "<td class='"+((sorttype==2||sorttype==3||sorttype==5)?"td_blank":"")+"'><div>&nbsp;</div></td>"
				  + "<td width='20px'><div id='' class='status' _taskid='' _status='1' title='' onclick='changestatus(this)'>&nbsp;</div></td>";
		if(statuscond==1 && sortcond!=4){
			newstr += "<td width='20px'><div id='' class='div_todo' style='display:none' onclick='showTodo2(this)' title='' _val='' _taskid=''>&nbsp;</div></td>";
		}
		
		newstr	 += "<td class='item_td' "+((statuscond!=1 || sortcond==4)?"colspan='2'":"")+"><input onfocus='doClickItem(this)' onblur='doBlurItem(this)' _pid='"+pid+"' class='disinput addinput "+((def==1)?"definput":"")+"' type='text' name='' value='"+((def==1)?"新建任务":"")+"' id='' _index="+(index++)+"/></td>"
				  + "<td class='item_count'>&nbsp;</td>"
				  + "<td style='text-align: center;'><div id='' class='div_enddate' title=''>&nbsp;</div></td>"
				  + "<td class='item_hrm'>&nbsp;</td>"
				  + "</tr>";
		*/
		if(pid=="" && cid!=""){
			newtr = $(newstr);
			$(foucsobj).parent().parent().after(newtr);
			
		}else{
			newstr += "<tr class='subtable_tr subitem_tr_blank'><td colspan='5' style='padding:0px;padding-left:20px;border:0px;height:auto'><table class='subdatalist' cellpadding='0' cellspacing='0' border='0' align='center'>"
				+"<colgroup><col width='20px'/><col width='*'/><col width='22px'/><col width='40px'/><col width='40px'/></colgroup></table></td></tr>";
			newtr = $(newstr);
			if(cid==""){
				$(foucsobj).parent().parent().after(newtr);
			}else{
				$(foucsobj).parent().parent().next("tr.subtable_tr").find(".subdatalist:first").append(newtr);
				//$(foucsobj).parent().parent().next("tr.subtable_tr").after(newtr);
			}
			newtr.click().find("input.disinput").focus();
		}
		
	}
	if(focus==1) newtr.click().find("input.disinput").focus();
}
// 添加新建下级任务
function addSubItem(parentid){
	var pid = getVal(parentid);
	var newtr = $("<tr class='subitem_tr subitem_tr_blank'>"
			 + "<td>"
			 + "	<div id='' class='status'>&nbsp;</div>"
			 + "	<div id='' class='div_todo_d' style='display:none' onclick='showTodo3(this)' title='' _val='' _taskid=''>&nbsp;</div>"
			 + "</td>"
			 + "<td class='item_td'><input onfocus='doClickSubItem(this)' onblur='doBlurSubItem(this)' class='subdisinput subaddinput subdefinput' type='text' name='' value='新建下级任务' id='' _pid='"+pid+"'/></td>"
			 + "<td class='item_hrm'></td>"
			 //+ "<td class='item_view'></td>"
			 //+ "<td class='item_add'></td>"
			 + "</tr>" 
			 + "<tr class='subtable_tr'><td colspan='3' style='padding:0px;padding-left:20px;border:0px;height:auto'><table class='subdatalist' cellpadding='0' cellspacing='0' border='0' align='center'><colgroup><col width='20px'/><col width='*'/><col width='50px'/></colgroup></table></td></tr>");
	if(pid==""){
		$("#subdatalist").append(newtr);
		newtr.click().find("input.subdisinput").focus();
	}else if(pid==taskid){
		$("#subdatalist").find("tr.subitem_tr:last").find("input.subdisinput").focus();
	}else{
		$("#sub_"+parentid).parent().parent().next("tr.subtable_tr").find(".subdatalist:first").append(newtr);
		newtr.click().find("input.subdisinput").focus();
	}
	
}
// 读取列表更多记录
function getListMore(obj){
	var _datalist = $(obj).attr("_datalist");
	var _currentpage = parseInt($(obj).attr("_currentpage"))+1;
	var _pagesize = $(obj).attr("_pagesize");
	var _total = $(obj).attr("_total");
	var _index = $(obj).attr("_index");
	var _excludeids = $(obj).attr("_excludeids");
	var date = new Date();
	listindexstatus[_index] = date;
	$(obj).html("<img src='/workrelate/task/images/loading3.gif' align='absMiddle' style='margin-top:6px;'/>");
	$.ajax({
		type: "post",
	    url: "Operation.jsp",
	    data:{"operation":"get_more","currentpage":_currentpage,"pagesize":_pagesize,"total":_total,"index":_index,"excludeids":_excludeids,"status":statuscond,"sorttype":sortcond}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(data){ 
	    	if(listindexstatus[_index]==date){
		    	var records = $.trim(data.responseText);
		    	//alert(records);
		    	$("#"+_datalist).find("tr").last().show().before(records);
		    	setIndex();
		    	$("#listscroll").append($("#"+_datalist).find("div.operatediv"));
		    	// alert(_total+"-"+_currentpage*_pagesize)
		    	if(_currentpage*_pagesize>=_total){
		    		$(obj).remove().prev("div.listicon").hide();
			    }else{
			    	$(obj).attr("_currentpage",_currentpage).html("更多");
				}
	    	}
		}
    });
}


// 刷新明细部分
function refreshDetail(taskid,quickfb){
	//if($("#mainiframe").length>0) $("#mainiframe").attr("src","");
	var upload = document.getElementById("uploadDiv");
	if(upload!=null) upload.innerHTML = "";
	var fbupload = document.getElementById("fbUploadDiv");
	if(fbupload!=null) fbupload.innerHTML = "";
	//alert($("#mainiframe").length>0);
	
	detailloadstatus = taskid;
	if(detailid!=taskid){
		$("#detaildiv").html("").append(loadstr);
		// $("#detaildiv").load("DetailView.jsp?taskId="+taskid);
		// $("#detaildiv").html("").append(loadstr);//.load("DetailView.jsp?taskId="+taskid);
	}
	$.ajax({
		type: "post",
	    url: "DetailView.jsp",
	    data:{"taskId":taskid,"quickfb":getVal(quickfb)}, 
	    complete: function(data){ 
		    if(detailloadstatus==taskid){
		    	detailid = taskid;
		    	$("#detaildiv").html(data.responseText);
			}
		}
    });
	$(".item_tr").removeClass("tr_select tr_blur");
	$("#item_tr_"+taskid).addClass("tr_select");
}
function quickfb(obj){
	var _taskid = $(obj).parent().attr("_taskid");
	doClickItem($("#"+_taskid),1);
}

// 修改状态
function changestatus(obj){
	var _taskid = $(obj).parent().attr("_taskid");
	if(_taskid=="" || typeof(_taskid)=="undefined") return;
	var _status = $(obj).attr("_status");
	if(_status==1){
		_status = 2;
	}else{
		_status = 1;
	}
	$.ajax({
		type: "post",
	    url: "Operation.jsp",
	    data:{"operation":"edit_status","taskId":_taskid,"status":_status}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    success: function(data){ 
	    	reSetStatus(_taskid,_status,1);
		}
    });
}
function reSetStatus(taskid,_status,refresh){
	var sobj = $("#status_"+taskid);
	if(_status==1){
		if(sobj.length>0) sobj.removeClass("status2 status2_hover status3 status3_hover").addClass("status1");
    }else if(_status==2){
    	if(sobj.length>0) sobj.removeClass("status1 status1_hover status3 status3_hover").addClass("status2");
	}else if(_status==3){
		if(sobj.length>0) sobj.removeClass("status1 status1_hover status2 status2_hover").addClass("status3");
	}
	if(detailid==taskid && refresh==1){
		refreshDetail(taskid);
	}
	if(searchstatus!=0){
		if(_status!=searchstatus){
			if(getVal($("#"+taskid).attr("_pid"))==""){
				$("#item_tr_"+taskid).hide();
			}
		}else{
			$("#item_tr_"+taskid).show();
		}
	}
	setIndex();// 重置序号
}

/**原明细页面*/
$(document).bind("click",function(e){
	var target=$.event.fix(e).target;
	if($(target).parents(".fuzzyquery_main_div").length==0 && $("#tag").val()!=""){
		selectUpdate("tag",$("#tag").val(),$("#tag").val(),"str");
		
	}
	if($("#tag").val()!="") $("#tag").val("");
});

function uploadFile(){
	uploader.startUpload();
}
function doSaveAfterAccUpload(){
	
	var index = $("#uploadDiv").attr("_index");
	var fieldvalue = $("#relateAccDocids_"+index).val();
	exeUpdate("fileids",fieldvalue,"add");
	$("#fsUploadProgress_"+index).html("");
}
function setFBP(){
	var maininfo = document.getElementById("maininfo");
	var hh = $("#fbbottom").offset().top-($("#main").height()-26);
	if(hh>0){
		maininfo.scrollTop += hh+10;
	}
}

//显示删除按钮
function showdel(obj){
	//if($(obj).parent().parent().attr("_type")=="tag"){
		$(obj).addClass("txtlink_hover");
	//}
	$(obj).find("div.btn_del").show();
	$(obj).find("div.btn_wh").hide();
}
//隐藏删除按钮
function hidedel(obj){
	//if($(obj).parent().parent().attr("_type")=="tag"){
		$(obj).removeClass("txtlink_hover");
	//}
	$(obj).find("div.btn_del").hide();
	$(obj).find("div.btn_wh").show();
}

//回车事件方法
function keyListener2(e){
    e = e ? e : event;   
    if(e.keyCode == 13){    
    	$(foucsobj2).blur();   
    }    
}
//同步名称方法
function keyListener4(e){
    e = e ? e : event;   
    $("#"+taskid).val($(foucsobj2).val()).attr("title",$(foucsobj2).val());  
}
//输入框保存方法
function doUpdate(obj,type){
	var fieldname = $(obj).attr("id");
	var fieldvalue = "";
	if(type==1){
		//alert($(obj).val());
		if($(obj).val()==tempval) return;
		fieldvalue = $(obj).val();
	}
	if(type==2){
		if($(obj).html()==tempval) return;
		fieldvalue = $(obj).html();
	}
	
	if(fieldname=="name"){
		if($.trim(fieldvalue)==""){
			$("#div_"+taskid).html(oldname);
			$(obj).val(oldname);
			return;
		}
		$("#div_"+taskid).html(fieldvalue);
	}
	exeUpdate(fieldname,fieldvalue,"str");
}
//删除选择性内容
function delItem(fieldname,fieldvalue){
	if(fieldname=="parentid"){
		if(!confirm("确定删除上级任务？")) return;
	}
	$("#"+fieldname).prevAll("div.txtlink"+fieldvalue).remove();
	if(fieldname=="docids"||fieldname=="wfids"||fieldname=="meetingids"||fieldname=="crmids"||fieldname=="projectids"||fieldname=="taskids"||fieldname=="goalids"||fieldname=="tag"||startWith(fieldname,"_")){
		var vals = $("#"+fieldname+"_val").val();
		var _index = vals.indexOf(","+fieldvalue+",")
		if(_index>-1 && $.trim(fieldvalue)!=""){
			vals = vals.substring(0,_index+1)+vals.substring(_index+(fieldvalue+"").length+2);
			$("#"+fieldname+"_val").val(vals);
			if(!startWith(fieldname,"_")){
				exeUpdate(fieldname,vals,'str',fieldvalue);
			}
		}
	}else{
		exeUpdate(fieldname,fieldvalue,'del');
	}
	if(fieldname == "principalid") $("#"+taskid).parent().nextAll("td.item_hrm").html("");//设置列表中责任人
	if(fieldname == "parentid"){
		$("#showsubtr").show();
		//if(sortcond==4) loadList();
	}
	setRelate(fieldname);
}
//选择内容后执行更新
function selectUpdate(fieldname,id,name,type){
	if(id==null || typeof(id)=="undefined") return;
	var addtxt = "";
	var addids = "";
	var addvalue = "";
	if(fieldname == "principalid"){
		if(id==$("#"+fieldname+"_val").val()){
			return;
		}else{
			$("#"+fieldname+"_val").val(id);
			//设置列表中责任人
			if($("#zrr_"+taskid).length>0){
				$("#zrr_"+taskid).html(name);
			}
		}
		addtxt = transName(fieldname,id,name);
		addids = id;
	}else if(fieldname == "subprincipalid"){
		if(id==$("#subprincipalid_"+editsubid).val()){
			return;
		}else{
			addtxt = transName(fieldname,id,name);
			addids = id;
			
			$("#subprincipalid_"+editsubid).val(id).prev("a").before(addtxt).remove();
			
			//设置列表中责任人
			if($("#"+editsubid).length>0){
				$("#"+editsubid).parent().nextAll("td.item_hrm").html("<a href='/hrm/resource/HrmResource.jsp?id="+id+"' target='_blank'>"+name+"</a>");
			}
		}
		
	}else if(fieldname == "parentid"){
		if(id==$("#"+fieldname+"_val").val()){
			return;
		}else{
			$("#"+fieldname+"_val").val(id);
			$("#showsubtr").hide();
		}
		addtxt = transName(fieldname,id,name);
		addids = id;
	}else{
		var ids = id.split(",");
		var names = name.split(",");
		var vals = $("#"+fieldname+"_val").val();
		for(var i=0;i<ids.length;i++){
			if(vals.indexOf(","+ids[i]+",")<0 && $.trim(ids[i])!=""){
				addids += ids[i] + ",";
				addvalue += ids[i] + ",";
				addtxt += transName(fieldname,ids[i],names[i]);
			}
		}
		$("#"+fieldname+"_val").val(vals+addids);
		if(fieldname != "partnerid" && fieldname != "sharerid") addids = vals+addids;
	}
	if(fieldname == "principalid" || fieldname=="parentid") $("#"+fieldname).prev("div.txtlink").remove();
	if(fieldname != "subprincipalid") $("#"+fieldname).before(addtxt);
	if(!startWith(fieldname,"_")){
		if(fieldname != "partnerid" && fieldname != "sharerid" && fieldname != "principalid" && fieldname != "parentid" && fieldname != "subprincipalid" && addvalue=="") return;
		exeUpdate(fieldname,addids,type,"",addvalue);
	}
	setRelate(fieldname);
	setClickExec2();
}
//执行编辑
function exeUpdate(fieldname,fieldvalue,fieldtype,delvalue,addvalue){
	if(typeof(delvalue)=="undefined") delvalue = "";
	if(typeof(addvalue)=="undefined") addvalue = "";
	var exetaskid = taskid;
	var exefieldname = fieldname;
	if(fieldname=="subprincipalid") {
		exetaskid = editsubid;
		exefieldname = "principalid";
	}
	$.ajax({
		type: "post",
	    url: "Operation.jsp",
	    data:{"operation":"edit_field","taskId":exetaskid,"fieldname":exefieldname,"fieldvalue":filter(encodeURI(fieldvalue)),"fieldtype":fieldtype,"delvalue":encodeURI(delvalue),"addvalue":encodeURI(addvalue)}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(data){ 
		    var txt = $.trim(data.responseText);
		    var log = txt;
	    	if(fieldname=="fileids"){
	    		$("#filetd").find(".txtlink").remove();
	    		$("#filetd").prepend(txt.split("$")[1]);
	    		log = txt.split("$")[0];
	    		setRelate("fileids");
		    }
	    	if(fieldname!="subprincipalid"){
	    		$("#logdiv").prepend(log);
	    	}
	    	
	    	if(fieldname=="parentid" && sortcond==4) loadList();//层级视图下更改上级任务时刷新列表
		}
    });
}
function resetLevel(taskid,level){
	if(sorttype==3){
		var obj = $("#item_tr_"+taskid);
		$($($("table.datalist")[level-1]).find(".definput")[0]).parent().parent().parent().before(obj);
	}
}
//修改紧急程度
function setLevel(id){
	exeUpdate("level",id,"int");
	//设置列表中位置
	if(sorttype==3){
		var obj = $("#item_tr_"+taskid);
		$($($("table.datalist")[id-1]).find(".definput")[0]).parent().parent().parent().before(obj);
	}
}
//修改是否开发所有子任务
function setShowallsub(id){
	if($("#showallsub"+id).hasClass("sdlink")) return;
	$("#showallsub"+id).parent("td").find("a.slink").removeClass("sdlink");
	$("#showallsub"+id).addClass("sdlink");//.attr("href","###");
	exeUpdate("showallsub",id,"int");
}
//调整日期
function resetSort(enddate,newTaskId){
	var begindate = $("#begindate").val();
	if(getVal(enddate)=="")
		enddate = $("#enddate").val();
	if(getVal(newTaskId)=="")
		newTaskId = taskid;
	var datetype = 0;
	if(enddate==""){
		datetype = 5;
	}else if(enddate!="" && compdatedays(enddate,currentdate)>0){
		datetype = 1;
	}else if(enddate!="" && enddate==currentdate){
		datetype = 2;
	}else if(enddate!="" && enddate==tomorrow){
		datetype = 3;
	}else if(enddate!="" && compdatedays(tomorrow,enddate)>0){
		datetype = 4;
	}
	$("#enddate_"+newTaskId).html(convertdate(enddate)).attr("title",enddate);
	if(sorttype!=2) return; 
	var obj = $("#item_tr_"+newTaskId);
	$($($("table.datalist")[datetype-1]).find("input.definput")[0]).parent().parent().parent().before(obj);
	setIndex();
}
function resetTodo(todotaskid,todotype,todoname){
	if(sorttype!=5 || principalid!=userid) return; 
	var table = $("#"+todotaskid).parents("table.datalist")[0];
	if($(table).attr("_datetype")!=todotype){
		var obj = $("#item_tr_"+todotaskid);
		$($($("table.datalist")[todotype-1]).find("input.definput")[0]).parent().parent().parent().before(obj);
	}
	setIndex();
}
function setRelate(_type){
	if($("#reltr"+_type).length>0){
		if($("#reltr"+_type).find("div.txtlink").length==0){
			$("#reltr"+_type).hide();
			if($("#relbtn"+_type).length>0) $("#relbtn"+_type).show();
		}
		if(_type=="parentid"){
			if($("#reltr"+_type).find("a").length==0){
				$("#reltr"+_type).hide();
				if($("#relbtn"+_type).length>0) $("#relbtn"+_type).show();
			}
		}
	}
}
function convertdate(datestr){
	datestr = getVal(datestr);
	if(datestr!="") datestr = datestr.substring(5).replace("-",".");
	return datestr;
}
function showFeedback(){
	$("#content").focus();
}
//反馈
function doFeedback(){
	if($("#content").html()==""||$("#content").html()=="<br>"){
		alert("请输入内容!");
		return;
	}
	try{
		var oUploader=window[$("#fbUploadDiv").attr("oUploaderIndex")];
		if(oUploader.getStats().files_queued==0){ //如果没有选择附件则直接提交
			exeFeedback();  //提交
		}else{ 
				oUploader.startUpload();
		}
	}catch(e) {
		exeFeedback();
  	}
}
function exeFeedback(){
	$("div.btn_feedback").hide();
	$("#submitload").show();
	$.ajax({
		type: "post",
	    url: "Operation.jsp",
	    data:{"operation":"add_feedback","taskId":taskid,"content":filter(encodeURI($("#content").html()))
			,"docids":$("#_docids_val").val(),"wfids":$("#_wfids_val").val(),"crmids":$("#_crmids_val").val(),"projectids":$("#_projectids_val").val()
			,"fileids":$("input[name=fbfileids]").val(),"replyid":$("#replyid").val()}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(data){ 
		    /**
	    	data=$.trim(data.responseText);
	    	if(data!=""){
	    		$("#feedbacktable").prepend(data);
		    }*/
		    if(data!=""){
		    	var txt = $.trim(data.responseText);
		    	$("#replyTr").after(txt.split("$")[0]);
		    	$("#logdiv").prepend(txt.split("$")[1]);
		    }
		    
	    	$("#submitload").hide();
	    	deffeedback = "";
	    	doCancel();
	    	var fbobj = $("#"+taskid).parent().nextAll("td.item_count:first");
	    	if(fbobj.length>0){
				var fbcount = $(fbobj).html();
				if(fbcount==""||fbcount=="&nbsp;"){
					$(fbobj).html("(1)").attr("title","1条反馈");
				}else{
					$(fbobj).html("("+(parseInt(fbcount.replace("(","").replace(")",""))+1)+")").attr("title",(parseInt(fbcount.substring(1,fbcount.length-1))+1)+"条反馈");
				}
		    }
		}
    });
}
//取消反馈
function doCancel(){
	var replyid = $("#replyid").val();
	if(replyid!=""){
		$("#replyid").val("");
		$("#fbtd").append($("#fbmain"));
	}
	
	$("#_crmids_val").val("");$("#_docids_val").val("");$("#_wfids_val").val("");$("#_projectids_val").val("");$("input[name=fbfileids]").val("");

	$("div.feedback_def").html("").removeClass("feedback_focus");
	$("div.btn_feedback").hide();
	if($("#fbrelatebtn").attr("_status")==1){$("#fbrelatebtn").click();}
	$("#fbrelatebtn").hide();
}
//获取反馈记录
function getFeedbackRecord(lastid){
	$("#gettr").children("td").html("<img src='/workrelate/task/images/loading3.gif' align='absMiddle' />");
	$.ajax({
		type: "post",
	    url: "Operation.jsp",
	    data:{"operation":"get_feedback","taskId":taskid,"lastId":lastid,"viewdate":"<%=viewdate%>"}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(data){ 
	    	data=$.trim(data.responseText);
	    	$("#gettr").before(data).remove();
		}
    });
}
//获取剩余日志记录
function getLogRecord(lastid){
	$("#getlog").html("<img src='/workrelate/task/images/loading3.gif' align='absMiddle' />");
	$.ajax({
		type: "post",
	    url: "Operation.jsp",
	    data:{"operation":"get_log","taskId":taskid,"lastId":lastid}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(data){ 
	    	data=$.trim(data.responseText);
	    	$("#getlog").before(data).remove();
		}
    });
}
//快捷删除任务 zhw20140723
var delTaskid= "";
function quickDel(taskid){
	delTaskid = taskid;
	doOperate(4);
}

//状态设置
function doOperate(status){
	var tid = taskid;
	if(status==4){
		if(!confirm("确定删除此任务?")){
			return;
		}
		if(delTaskid!=""){
			tid = delTaskid;
		}
	}
	$.ajax({
		type: "post",
	    url: "Operation.jsp",
	    data:{"operation":"edit_status","taskId":tid,"status":status}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(data){ 
		    var txt = $.trim(data.responseText);
	    	var ss = txt.split("$")
		    $("#logdiv").prepend(ss[0]);
		    if(ss.length>1){
		    	$("#replyTr").after(ss[1]);
			}
		    if(status==4) {
		    	delTaskid = "";
		    }
		}
    });

	if(status==1){
		$("#div_complete").show();
		$("#div_doing").hide();
		$("#tdstatus").html("进行中");
    }else if(status==2){
    	$("#div_complete").hide();
    	$("#div_doing").show();
    	$("#tdstatus").html("完成");
	}else if(status==3){
    	$("div.btn_operate").hide();
    	$("div.btn_revoke").show();
    	$("#tdstatus").html("撤销");
	}else{
		if(getVal($("#"+tid).attr("_pid"))!=""){
			loadList();
		}else{
			if($(foucsobj).attr("id")==tid) foucsobj=null;
			$("#item_tr_"+tid).remove();
		}
		var upload = document.getElementById("uploadDiv");
		if(upload!=null) upload.innerHTML = "";
		if(tid==taskid){
			$("#detaildiv").append(loadstr).load("DefaultView.jsp");
		}
	}
	reSetStatus(tid,status,0);
}
function showop(obj,classname,txt){
	$(obj).removeClass(classname);//.html(txt);
}
function hideop(obj,classname,txt){
	$(obj).addClass(classname);//.html(txt);
}
function showTodo(){
	$('#dtodopanel').show();
}
function showTodo2(obj){
	var todotype = $(obj).attr("_todotype");
	var todotaskid = $(obj).attr("_taskid");
	var t = $(obj).offset().top+$(obj).height();
	var ph = $('#ltodopanel').height();
	var wh = $(window).height();
	if(ph+t>wh) t = t - ph - $(obj).height();
	var l = $(obj).position().left;
	//alert(t+"-"+l);
	$('#ltodopanel').css({"top":t,"left":l}).attr("_todotype",todotype).attr("_taskid",todotaskid).show();
}
function showTodo3(obj){
	var todotype = $(obj).attr("_todotype");
	var todotaskid = $(obj).attr("_taskid");
	var t = $(obj).offset().top+$(obj).height();
	var ph = $('#stodopanel').height();
	var wh = $(window).height();
	if(ph+t>wh) t = t - ph - $(obj).height();
	var l = $(obj).position().left;
	//alert(t+"-"+l);
	$('#stodopanel').css({"top":t,"left":l}).attr("_todotype",todotype).attr("_taskid",todotaskid).show();
}
function showtitle(){
	var _index = $("#floattitle").attr("_index");
	var scrollh = $(this).scrollTop;
	var tp = $("#sorttitle"+_index).position().top;
	var tp0 = $("#sorttitle0").position().top;
	$("#listscroll").scrollTop((tp0-tp)*-1+1);
}
function showdtitle(){
	var _index = $("#dftitle").attr("_index");
	var scrollh = $(this).scrollTop;
	var tp = $("#dtitle"+_index).position().top;
	var tp0 = $("#dtitle0").position().top;
	$("#maininfo").scrollTop((tp0-tp)*-1+1);
}
function onShowHrm(fieldname) {
    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
    if (datas) {
	    var fieldvalue = "";
	    if(datas.id=="") fieldvalue=0;
	    selectUpdate(fieldname,datas.id,datas.name,'add');
    }
}
function onShowHrms(fieldname) {
    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
    if (datas) {
    	if(fieldname=="share"){
    		if(datas.id!=""){
    			doShare(datas);
    		}
    		return;
    	}
	    var fieldvalue = "";
	    if(datas.id=="") fieldvalue=0;
	    selectUpdate(fieldname,datas.id,datas.name,'add');
    }
}
function doShare(datas){
	var taskname = "";
	if($("#name").length>0){
		taskname = $("#name").val();
	}else{
		taskname = $("#task_share_name").html();
	}
	top.IM_Ext.imCustomerShare (taskid,taskname,datas.id,"task")
	alert("分享成功");
}
function onShowDoc(fieldname) {
    var datas = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp");
    if (datas) {
	    var fieldvalue = "";
	    if(datas.id=="") fieldvalue=0;
	    selectUpdate(fieldname,datas.id,datas.name,'str');
    }
}
function onShowWF(fieldname) {
    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp");
    if (datas) {
	    var fieldvalue = "";
	    if(datas.id=="") fieldvalue=0;
	    selectUpdate(fieldname,datas.id,datas.name,'str');
    }
}
function onShowCRM(fieldname) {
    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp");
    if (datas) {
	    var fieldvalue = "";
	    if(datas.id=="") fieldvalue=0;
	    selectUpdate(fieldname,datas.id,datas.name,'str');
    }
}
function onShowProj(fieldname) {
    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp");
    if (datas) {
	    var fieldvalue = "";
	    if(datas.id=="") fieldvalue=0;
	    selectUpdate(fieldname,datas.id,datas.name,'str');
    }
}
function transName(fieldname,id,name){
	var delname = fieldname;
	if(startWith(fieldname,"_")) fieldname = fieldname.substring(1);
	var restr = "";
	if(fieldname=="subprincipalid"){
		return "<a href='/hrm/resource/HrmResource.jsp?id="+id+"' target='_blank'>"+name+"</a>";
	}
	
	if(fieldname=="principalid" || fieldname=="parentid"){
		restr += "<div class='txtlink showcon txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
	}else{
		restr += "<div class='txtlink txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
	}
	restr += "<div style='float: left;'>";
		
	if(fieldname=="principalid" || fieldname=="partnerid" || fieldname=="sharerid"){
		restr += "<a href='/hrm/resource/HrmResource.jsp?id="+id+"' target='_blank'>"+name+"</a>";
	}else if(fieldname=="docids"){
		restr += "<a href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+id+"') >"+name+"</a>";
	}else if(fieldname=="wfids"){
		restr += "<a href=javaScript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid="+id+"') >"+name+"</a>";
	}else if(fieldname=="crmids"){
		restr += "<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+id+"') >"+name+"</a>";
	}else if(fieldname=="projectids"){
		restr += "<a href=javaScript:openFullWindowHaveBar('/proj/process/ViewTask.jsp?taskrecordid="+id+"') >"+name+"</a>";
	}else if(fieldname=="taskids" || fieldname=="parentid"){
		restr += "<a href=javaScript:refreshDetail("+id+") >"+name+"</a>";
	}else if(fieldname=="goalids"){
		restr += "<a href=javaScript:showGoal("+id+") >"+name+"</a>";
	}else if(fieldname=="tag"){
		restr += name;
	}
	
	restr +="</div>";
	if(fieldname!="principalid"){
		restr +="<div class='btn_del' onclick=\"delItem('"+delname+"','"+id+"')\"></div>";
		restr +="<div class='btn_wh'></div>";
	}
	restr +="</div>";
	return restr;
}
function showPlan(plandetailid){
	openWin("/workrelate/plan/data/DetailView.jsp?plandetailid="+plandetailid);
	
}
function openWin(url,showw,showh){
	if(showw==null || typeof(showw)=="undefined") showw = 500;
	if(showh==null || typeof(showh)=="undefined") showh = 600;
	var redirectUrl = url ;
	var height = screen.height;
	var width = screen.width;
	var top = (height-showh)/2-40;
	var left = (width-showw)/2;
	var szFeatures = "top="+top+"," ; 
	szFeatures +="left="+left+"," ;
	szFeatures +="width="+showw+"," ;
	szFeatures +="height="+showh+"," ; 
	szFeatures +="directories=no," ;
	szFeatures +="status=yes," ;
	szFeatures +="menubar=no," ;
  	szFeatures +="scrollbars=yes," ;
	szFeatures +="resizable=yes" ; //channelmode
 	window.open(redirectUrl,"",szFeatures) ;
}