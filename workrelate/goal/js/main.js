/** 主页面部分 */
function checknew(){
	/**
	$.ajax({
		type: "post",
	    url: "/workrelate/goal/data/Operation.jsp",
	    data:{"operation":"check_new"}, 
	    complete: function(data){
			$("#checknew").html($.trim(data.responseText));
			setnew();
		}
    });
    */
}
function setnew(){
	var mynew = false;
	for(var i=2;i<7;i++){
		var amount = parseInt(newMap.get("mine"+i));
		if(amount>0){
			if(i<6) mynew = true;
			$("#icon1_"+i).html(amount).removeClass("cond_icon10").addClass("cond_icon11 cond_icon_count").attr("title",amount+"条新目标或新反馈");
		}else{
			$("#icon1_"+i).html("").removeClass("cond_icon11 cond_icon_count").addClass("cond_icon10").attr("title","");
		}
	}
	if(mynew){
		$("#icon1_1").removeClass("cond_icon10").addClass("cond_icon11").attr("title","有新目标或新反馈");
	}else{
		$("#icon1_1").removeClass("cond_icon11").addClass("cond_icon10").attr("title","");
	}
	
	var camount = parseInt(newMap.get("mine7"));
	if(camount>0){
		$("#icon1_8").html(camount).removeClass("cond_icon10").addClass("cond_icon11 cond_icon_count").attr("title",camount+"条新完成目标");
	}else{
		$("#icon1_8").html("").removeClass("cond_icon11 cond_icon_count").addClass("cond_icon10").attr("title","");
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
	for(var i=1;i<7;i++){
		if($(target).attr("_menuid")!=("menupanel"+i)){
			$("#menupanel"+i).hide();
		}
	}
	if($(target).attr("id")!="cate"){
		$("#dcatepanel").hide();
	}
	if(!$(target).hasClass("div_todo")){
		$("#ltodopanel").hide();
	}
	
	var tid = getVal($(target).attr("id"));
	$("input.add_input").each(function(){
		if(tid!=$(this).attr("id") && $(this).css("display")!="none"
			&& $(this).nextAll("div.btn_browser").get(0)!=$(target).get(0)
			&& $(this).nextAll("div.btn_add").get(0)!=$(target).get(0)
			&& this!=$(target).get(0)
			){
			
			
			var _type = getVal($(this).parents("tr:first").attr("_type"));
			if(!$(target).hasClass("relbtn")){
			
				$(this).hide();
				//$(this).nextAll("div.btn_add").show();
				$(this).nextAll("div.btn_browser").hide();
				$(this).prevAll("div.showcon").show();
				
				if(_type!="" && ($("#fuzzyquery_query_div").length==0 || $("#fuzzyquery_query_div").css("display")=="none") 
						&& !$(target).hasClass("add_input")){
					//alert(11);
					setRelate(_type);
				}
			
			}else{
				var _type2 = getVal($(target).attr("_type"));
				if(_type2!=_type){
					setRelate(_type);
				}
				
			}
		}
	});
	if(!$(target).hasClass("relbtn") && $("#reltrfileids").length>0){
		setRelate("fileids");
	}
	
});

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
		$("#mainoperate2").html($(obj).html());
		//$("#changestatus").children(".c_img").css("background-image","url('"+$(obj).find("img").attr("src")+"')")
		//.attr("title",$(obj).find("img").attr("title"));
		loadList();
	}
}
//切换周期
function doChangePeriod(obj,period){
	if(periodcond==period){
		return;
	}else{
		var sortname = "";
		if(period==1){
			$("div.poperate").hide();
			$("#mainoperate4,#mainoperate5").show();
		}else if(period==2){
			$("div.poperate").hide();
			$("#mainoperate4,#mainoperate6").show();
		}else if(period==3){
			$("div.poperate").hide();
			$("#mainoperate4").show();
		}else if(period==4){
			$("div.poperate").hide();
			$("#mainoperate7").html("三年").show();
		}else if(period==5){
			$("div.poperate").hide();
			$("#mainoperate7").html("五年").show();
		}else if(period==0){
			$("div.poperate").hide();
			$("#mainoperate7").html("全部").show();
		}
		//$("#sortname").html("--"+sortname);
		periodcond=period;
		$("#mainoperate3").html($(obj).html());
		//$("#changestatus").children(".c_img").css("background-image","url('"+$(obj).find("img").attr("src")+"')")
		//.attr("title",$(obj).find("img").attr("title"));
		loadList();
	}
}
//切换年份
function doChangeYear(obj,value){
	if(periody==value){
		return;
	}else{
		periody=value;
		$("#mainoperate4").html($(obj).html()+"年");
		loadList();
	}
}
//切换月份
function doChangeMonth(obj,value){
	if(periodm==value){
		return;
	}else{
		periodm=value;
		$("#mainoperate5").html($(obj).html());
		loadList();
	}
}
//切换季度
function doChangeSeason(obj,value){
	if(periods==value){
		return;
	}else{
		periods=value;
		$("#mainoperate6").html($(obj).html());
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
		sortcond=status;
		var sortname = $(obj).attr("_val");
		//$("#sortname").html("--"+$(obj).html());
		if(status==4){
			statuscond=1;
			//$("#mainoperate2").html("进行中").css("cursor","default").attr("title","");
			
			$("#mainoperate1").css("right","5px").html(sortname);
			$("#mainoperate2").hide();
		}else{
			$("#mainoperate2").css("cursor","pointer").attr("title","点击切换状态");
			
			$("#mainoperate1").css("right","70px").html(sortname);
			$("#mainoperate2").show();
		}
		setPosition(1);
	}
}
// 加载列表部分
function loadList(load,id,name){
	var date = new Date();
	listloadststus = date;
	$("#listview").append(loadstr);// .load("ListView.jsp?status="+statuscond+"&sorttype="+sortcond+"&condtype="+condtype+"&hrmid="+hrmid+"&tag="+tag);
	$.ajax({
		type: "post",
	    url: "ListView.jsp?"+new Date().getTime(),
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    data:{"status":statuscond,"sorttype":sortcond,"condtype":condtype,"hrmid":hrmid,"tag":encodeURI(tag)
			,"period":periodcond,"periody":periody,"periodm":periodm,"periods":periods}, 
	    complete: function(data){ 
		    if(listloadststus==date){
		    	$("#listview").html(data.responseText);
		    	if(inittaskid!=""){
		    		foucsobj = $("#"+inittaskid);
		    		refreshDetail(inittaskid);
		    		inittaskid = "";
		    	}
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
		    	}
		    	if(load==1 && id!=null && typeof(id)!="undefined"){
		    		loadDetail(id,name);
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
	defaultname = name;
	detailid = id;
	detailloadstatus = id;
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
	if($("#"+id).length>0){
		// $("#"+id).parent().parent().click();
		$("#"+id).attr("_defaultname",$("#"+id).val());
		if(!$("#"+id).parent().parent().hasClass("tr_select")){
			$(".item_tr").removeClass("tr_select tr_blur");
			$("#"+id).parent().parent().addClass("tr_select");
		}
	}else{
		$(".item_tr").removeClass("tr_select tr_blur");
	}
}
// 通过搜索框查询某人时执行的加载列表部分
function searchList(id,name){
	$("div.leftmenu").removeClass("leftmenu_select leftmenu_over");
	datatype = 1;
	condtype = 0;
	hrmid = id;
	tag = "";
	$("#mtitle").html(name);
	$("#micon").css("background","url('../images/title_icon_"+datatype+".png') no-repeat");
	loadList();
	$("div.mainoperate").show();
	if(sortcond==5) $("#mainoperate2").hide();
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
function setPosition(load,id,name){
	var width = $("#main").width();
	if(showdetail==1){
		//$("#detail").css({"width":width,"z-index":100});
		//$("#detaildiv").css({"border":"0px"});
		if(load==1) loadList(load,id,name);
	}else{
	
	if(width>1220){// 窗口宽度大于1220时 右侧视图不会浮动在左侧菜单上
		
		width -= 246; 
		w1 = Math.round(width*5/9)+1;
		w2 = width-w1+1;
		if(sortcond==4){
			w1 = width;
			w2 = 0;
		}
		$("#detail").animate({ width:w2 },speed,null,function(){
			
			$("#view").animate({ width:w1 },speed,null,function(){
				$("#view").animate({ left:246 },speed,null,function(){
					if(load==1) loadList(load,id,name);
				});
			});
		});
		
	}else{
		width -= 30; 
		w1 = Math.round(width*5/9)+1;
		w2 = width-w1+1;
		if(sortcond==4){
			w1 = width;
			w2 = 0;
		}
		$("#detail").animate({ width:w2 },speed,null,function(){
			
			$("#view").animate({ width:w1 },speed,null,function(){
				$("#view").animate({ left:30 },speed,null,function(){	
					if(load==1) loadList(load,id,name);
				});
			});
		});
	}
	}

	// $("#addbtn").hide();
	/**
	var lheight = $("#main").height()-301-52-30;
	var selecth = Math.round(($("#main").height()-301-30)/2)-26;
	if(hrmHeight<selecth){
		$("#tagdiv").height(lheight-hrmHeight);
		$("#hrmdiv").height(hrmHeight);
	}else{
		if(tagHeight<selecth){
			if((tagHeight+hrmHeight)<lheight){
				$("#hrmdiv").height(hrmHeight);
				$("#tagdiv").height(tagHeight);
			}else{
				$("#hrmdiv").height(lheight-tagHeight);
				$("#tagdiv").height(tagHeight);
			}
		}else{
			$("#hrmdiv").height(selecth);
			$("#tagdiv").height(selecth);
		}
	}*/
	//$("#hrmdiv").height($("#main").height()-170-26);
	var lheight = $("#main").height()-$("#topmenu").height()-$("#search").height()-$("#mine").height()- $("div.lefttitle").length*30-40;
	$("#hrmdiv").height(lheight);

	$("#detaildiv").height($("#detail").height());//-11
	$("#listview").height($("#main").height()-40);
	//$("#listscroll").height($("#main").height()-40);
	
	//$('#listview').perfectScrollbar("update");
	//$("div.scroll2").perfectScrollbar("update");
}
function doClick(id,type,obj,name){
	$("div.leftmenu").removeClass("leftmenu_select leftmenu_over");
	$("span.org_select").removeClass("org_select");
	
	$("#mine").removeClass("leftitem_click");
	$("#sub").addClass("leftitem_click");
	$("div.menuall").removeClass("leftmenu").hide();

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
		$("#sub").removeClass("leftitem_click");
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
		$(this).find(".td_move").each(function(){
			if($(this).parent().css("display")!="none"){
				$(this).children().html(index);
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
function doClickItem(obj,quickfb){
	$(obj).removeClass("newinput");
	var objcount = $(obj).parent().nextAll("td.item_count");
	var _fbcount = objcount.attr("_fbcount");
	if(parseInt(_fbcount)>0){
		objcount.removeClass("item_count_new").attr("title",_fbcount+"条反馈");
	}
	
	if($(foucsobj).attr("id")==$(obj).attr("id") && $(obj).attr("id")!="" && typeof($(obj).attr("id"))!="undefined"){
		if(getVal(quickfb)==1) showFeedback();
		return;// 重复点击时不会加载
	}
	foucsobj = obj;

	if($(obj).attr("id")=="" || typeof($(obj).attr("id"))=="undefined"){
		if($(obj).hasClass("addinput")) $(obj).removeClass("addinput").val("");
	}else{
		refreshDetail($(obj).attr("id"),quickfb);
	}

	// $(obj).unbind("blur").bind("blur",function(){doBlurItem(this);});
	// document.onkeydown=keyListener;
	// document.onkeyup=keyListener3;
}
// 标题失去焦点事件
function doBlurItem(obj){
	// $(obj).parent().parent().addClass("tr_blur");
	doAddOrUpdate(obj);
	// document.onkeydown=null;
	// document.onkeyup=null;
}
//执行新建或编辑
function doAddOrUpdate(obj,enter){
	var ctaskid = $(obj).attr("id");
	var taskname = encodeURI($(obj).val());
	if(ctaskid=="" || typeof(ctaskid)=="undefined"){// 新建
		var pid = getVal($(obj).attr("_pid"));
		if($(obj).val()=="" || $(obj).val()=="新建目标"){
			if($(obj).hasClass("definput")){
				$(obj).addClass("addinput").val("新建目标");
			}else{
				$(obj).parent().parent().remove();
				foucsobj = null;
			}
		}else{
			var _datetype = $(obj).parents("table.datalist").attr("_datetype");
			$.ajax({
				type: "post",
			    url: "/workrelate/goal/data/Operation.jsp",
			    data:{"operation":"add","taskName":filter(taskname),"sorttype":sorttype,"datetype":_datetype,"principalid":principalid,"parentid":pid,"tag":filter(encodeURI(tag))
					,"period":periodcond,"periody":periody,"periodm":periodm,"periods":periods}, 
			    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			    complete: function(data){ 
			    	data=$.trim(data.responseText);
			    	ctaskid = data.split("_")[0];
			    	$(obj).attr("id",ctaskid)
			    		.attr("title",$(obj).val())
			    		.attr("_pid",pid);
			    	
			    	var trobj = $(obj).parent().parent();
			    	trobj.attr("id","item_tr_"+ctaskid).attr("_taskid",ctaskid).removeClass("item_tr_blank");
			    	
			    	//设置反馈数
			    	var fbobj = $(obj).parent().nextAll("td.item_count:first");
			    	if(fbobj.length>0){
			    		$(fbobj).html("(1)").attr("title","1条反馈");
				    }
			    	
			    	//设置状态
			    	var divstatus = trobj.find("div.status");
			    	if(divstatus.length>0){
			    		divstatus.attr("id","status_"+ctaskid).addClass("status1");
			    	}
			    	
			    	//设置负责人
			    	trobj.find(".item_hrm").html(data.split("_")[1]).attr("title","责任人");
			    	
			    	//设置到期日
			    	var divenddate = trobj.find("div.div_enddate");
		    		if(divenddate.length>0){
		    			var enddate = divenddate.attr("title");
		    			if(sorttype==2){
						    if(_datetype==1){
						    	enddate = yesterday;
							}else if(_datetype==2){
						    	enddate = currentdate;
							}else if(_datetype==3){
						    	enddate = tomorrow;
							}else if(_datetype==4){
						    	enddate = nextweek;
							}
		    			}
					    divenddate.attr("id","enddate_"+ctaskid).html(convertdate(enddate)).attr("title",enddate);
		    		}
			    	//设置todo
		    		var divtodo = trobj.find("div.div_todo");
		    		if(divtodo.length>0){
		    			var todoname = "标记todo";
		    			if(sorttype==5){
							if(_datetype==1){
								todoname = "今天";
							}else if(_datetype==2){
								todoname = "明天";
							}else if(_datetype==3){
								todoname = "即将";
							}
		    			}
						divtodo.attr("id","todo_"+ctaskid).attr("_taskid",ctaskid).attr("_val",_datetype).attr("title",todoname);
		    		}
			    		
			    	//设置操作
		    		var opstr = "<div id='operate_"+ctaskid+"' class='operatediv' _taskid='"+ctaskid+"'>"
		    			+"<div class='operatebtn item_fb' onclick='quickfb(this)'>反馈</div>"
		    			+"<div class='operatebtn item_att' _special='0' title='添加关注'>添加关注</div>"
		    			+"<div class='operatebtn item_status' _status='1' onclick='changestatus(this)' title='标记完成'>标记完成</div>"
		    			+"</div>";
		    		$("#listscroll").append(opstr);
			    	
			    	// 显示标记关注图标
			    	//$(obj).parent().parent().find("td.item_att").addClass("item_att0").attr("_special",0).attr("title","标记关注");

					if((foucsobj!=null && ($(foucsobj).attr("id")=="" || typeof($(foucsobj).attr("id"))=="undefined")) || $(foucsobj).attr("id")==ctaskid){
						refreshDetail(ctaskid);
					}
				}
		    });
			$(obj).removeClass("addinput definput");
			var blankobj = $(obj).parent().prevAll("td.td_blank");
			if(sorttype==2 || sorttype==3 || sorttype==5){
				blankobj.addClass("td_move td_drag").removeClass("td_blank");
				if(sorttype==5 && principalid!=userid) blankobj.removeClass("td_drag");
			}else{
				blankobj.addClass("td_move").removeClass("td_blank");
			}
			
			if(enter==1){
				if(pid!="") addItem(0,1);
				else{
					if($(obj).hasClass("definput")){
						addItem(1,enter);
					}else{
						addItem(0,enter);
					}
				}
			}
			// 增加默认新增
			if($($(obj).parents("table.datalist")[0]).find("input.definput").length==0){
				addItem(1,0);
			}
			setIndex();// 重置序号
		}
		
	}else{// 编辑
		if(enter==1) addItem(0,1);
		if($(obj).val()==$(obj).attr("_defaultname")) return;
		if($(obj).val()==""){
			$(obj).val($(obj).attr("_defaultname")).attr("title",$(obj).attr("_defaultname"));
			if($(obj).attr("id")==$("#taskid").val()){
		    	$("#name").val($(obj).attr("_defaultname"));
			}
			return;
		}
		$(obj).attr("title",$(obj).val());
		$.ajax({
			type: "post",
		    url: "/workrelate/goal/data/Operation.jsp",
		    data:{"operation":"edit_name","taskId":ctaskid,"taskName":filter(taskname)}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
		    	if($(obj).attr("id")==$("#taskid").val()){
		    		$("#name").val($(obj).val());
		    		$("#logdiv").prepend(data.responseText);
		    	}
			}
	    });
	}
}
// 下级目标标题点击事件
function doClickSubItem(obj){

	if($(obj).attr("id")=="" || typeof($(obj).attr("id"))=="undefined"){
		if($(obj).hasClass("subaddinput")) $(obj).removeClass("subaddinput").val("");
	}else{
		//refreshDetail($(obj).attr("id"));
	}
}
// 下级目标标题失去焦点事件
function doBlurSubItem(obj){
	// $(obj).parent().parent().addClass("tr_blur");
	doAddOrUpdateSub(obj);
}
//执行新建或编辑下级目标
function doAddOrUpdateSub(obj,enter){
	var subtaskid = $(obj).attr("id");
	var taskname = encodeURI($(obj).val());
	if(subtaskid=="" || typeof(subtaskid)=="undefined"){// 新建
		var pid = getVal($(obj).attr("_pid"));
		if($(obj).val()=="" || $(obj).val()=="新建下级目标"){
			if(pid==""){
				$(obj).addClass("subaddinput").val("新建下级目标");
			}else{
				$(obj).parent().parent().next("tr").remove();
				$(obj).parent().parent().remove();
			}
		}else{
			if(pid=="") pid = taskid;
			var _datetype = $(obj).parents("table.datalist").attr("_datetype");
			$.ajax({
				type: "post",
			    url: "/workrelate/goal/data/Operation.jsp",
			    data:{"operation":"add","taskName":filter(taskname),"sorttype":sorttype,"datetype":_datetype,"principalid":$("#principalid_val").val(),"parentid":pid,"tag":filter(encodeURI(tag))
					,"period":periodcond,"periody":periody,"periodm":periodm,"periods":periods,"cate":filter(encodeURI($("#cate").html()))}, 
			    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			    complete: function(data){ 
			    	data=$.trim(data.responseText);
			    	subtaskid = data.split("_")[0];
			    	$(obj).attr("id","sub_"+subtaskid)
			    		  .attr("title",$(obj).val())
			    	      .attr("_defaultname",$(obj).val())
			    	      .attr("_pid",pid);
			    	$(obj).parent().parent().find(".item_hrm").html(data.split("_")[1]).attr("title","责任人")
			    		.next(".item_view").html("<a href='javascript:refreshDetail("+subtaskid+")'>查看</a>")
			    		.next(".item_add").html("<div class='subadd' title='建立下级目标' onclick='addSubItem("+subtaskid+")'>+</div>");
			    	
			    	loadList();
				}
		    });
			$(obj).removeClass("subaddinput subdefinput");
			if(pid==taskid && $("input.subdefinput").length==0) addSubItem("");
		}
		
	}else{// 编辑
		//if(enter==1) addItem(0,1);
		var subid = subtaskid.split("_")[1];
		if($(obj).val()==$(obj).attr("_defaultname")) return;
		if($(obj).val()==""){
			$(obj).val($(obj).attr("_defaultname")).attr("title",$(obj).attr("_defaultname"));
			return;
		}
		$(obj).attr("title",$(obj).val());
		$.ajax({
			type: "post",
		    url: "/workrelate/goal/data/Operation.jsp",
		    data:{"operation":"edit_name","taskId":subid,"taskName":filter(taskname)}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){ 
		    	if($("#"+subid).length>0){
		    		$("#"+subid).val($(obj).val());
		    	}
			    //$("#logdiv").prepend(data.responseText);
			}
	    });
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
	    	// $(foucsobj).parent().parent().removeClass("td_select
			// td_blur td_hover").addClass("td_blur");
			// document.onkeydown=null;
			// document.onkeyup=null;
	    	// $(foucsobj).unbind("blur");
	    	// $(foucsobj).blur();
	    	// doAddOrUpdate(foucsobj,1);
    		if(!createmain) return;
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
    	}
    	// 下级列表标题回车事件
    	if($(target).hasClass("subdisinput")){
    		var targetid = getVal($(target).attr("id"));
    		var createsub = getVal($(target).attr("_createsub"));
			if(targetid=="" && $(target).val()==""){
				return;
			}else{
				if(targetid!=""){
					targetid = targetid.split("_")[1];
					addSubItem(targetid);
				}else{
					var pid = getVal($(target).attr("_pid"));
					addSubItem(pid);
				}
			}
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
    	 
    }    
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
  	if($(target).attr("id")=="name"){
  		$("#"+taskid).val($(foucsobj2).val()).attr("title",$(foucsobj2).val());  
    }
    // 临时保存反馈内容
  	if($(target).attr("id")=="content"){
  		deffeedback = $(target).html();
    }
}
// 添加新建目标
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
			+ "<td class='item_td'><input onfocus='doClickItem(this)' onblur='doBlurItem(this)' _pid='"+pid+"' class='disinput addinput "+((def==1)?"definput":"")+"' type='text' name='' value='"+((def==1)?"新建目标":"")+"' id='' _index="+(index++)+"/></td>"
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
		
		newstr	 += "<td class='item_td' "+((statuscond!=1 || sortcond==4)?"colspan='2'":"")+"><input onfocus='doClickItem(this)' onblur='doBlurItem(this)' _pid='"+pid+"' class='disinput addinput "+((def==1)?"definput":"")+"' type='text' name='' value='"+((def==1)?"新建目标":"")+"' id='' _index="+(index++)+"/></td>"
				  + "<td class='item_count'>&nbsp;</td>"
				  + "<td style='text-align: center;'><div id='' class='div_enddate' title=''>&nbsp;</div></td>"
				  + "<td class='item_hrm'>&nbsp;</td>"
				  + "</tr>";
		*/
		if(pid=="" && cid!=""){
			newtr = $(newstr);
			$(foucsobj).parent().parent().after(newtr);
			
		}else{
			newstr += "<tr class='subtable_tr'><td colspan='5' style='padding:0px;padding-left:20px;border:0px;height:auto'><table class='subdatalist' cellpadding='0' cellspacing='0' border='0' align='center'>"
				+"<colgroup><col width='20px'/><col width='*'/><col width='22px'/><col width='40px'/><col width='40px'/></colgroup></table></td></tr>";
			newtr = $(newstr);
			if(cid==""){
				$(foucsobj).parent().parent().after(newtr);
			}else{
				$(foucsobj).parent().parent().next("tr.subtable_tr").find(".subdatalist:first").append(newtr);
			}
			newtr.click().find("input.disinput").focus();
		}
		
	}
	if(focus==1) newtr.click().find("input.disinput").focus();
	/**
	 * newtr.bind("mouseover",function(){
	 * $(this).addClass("tr_hover"); }).bind("mouseout",function(){
	 * $(this).removeClass("tr_hover"); }).bind("click",function(){
	 * $(".item_tr").removeClass("tr_select tr_blur");
	 * $(this).addClass("tr_select");
	 * 
	 * });
	 */
}
// 添加新建下级目标
function addSubItem(parentid){
	var pid = getVal(parentid);
	var newtr = $("<tr class='subitem_tr'>"
			 + "<td></td>"
			 +"<td class='item_td'><input onfocus='doClickSubItem(this)' onblur='doBlurSubItem(this)' class='subdisinput subaddinput subdefinput' type='text' name='' value='新建下级目标' id='' _pid='"+pid+"'/></td>"
			 +"<td class='item_hrm'></td>"
			 +"<td class='item_view'></td>"
			 +"<td class='item_add'></td>"
			 +"</tr>" 
			 +"<tr class='subtable_tr'><td colspan='5' style='padding:0px;padding-left:20px;border:0px;height:auto'><table class='subdatalist' cellpadding='0' cellspacing='0' border='0' align='center'><colgroup><col width='20px'/><col width='*'/><col width='50px'/><col width='30px'/><col width='20px'/></colgroup></table></td></tr>");
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
	$(obj).html("<img src='../images/loading3.gif' align='absMiddle' style='margin-top:3px;'/>");
	$.ajax({
		type: "post",
	    url: "/workrelate/goal/data/Operation.jsp",
	    data:{"operation":"get_more","currentpage":_currentpage,"pagesize":_pagesize,"total":_total,"index":_index,"excludeids":_excludeids,"status":statuscond,"sorttype":sortcond}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(data){ 
	    	var records = $.trim(data.responseText);
	    	//alert(records);
	    	$("#"+_datalist).find("tr").last().before(records);
	    	setIndex();
	    	// alert(_total+"-"+_currentpage*_pagesize)
	    	if(_currentpage*_pagesize>=_total){
	    		$(obj).hide().prev("div.listicon").hide();
		    }else{
		    	$(obj).attr("_currentpage",_currentpage).html("更多");
			}
		}
    });
}


// 刷新明细部分
function refreshDetail(taskid,quickfb){
	var upload = document.getElementById("uploadDiv");
	if(upload!=null) upload.innerHTML = "";
	var fbupload = document.getElementById("fbUploadDiv");
	if(fbupload!=null) fbupload.innerHTML = "";

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
		    	$("#detaildiv").html(data.responseText);
			}
		}
    });
		
	if($("#"+taskid).length>0){
		
		defaultname = $("#"+taskid).val();
		$("#"+taskid).attr("_defaultname",$("#"+taskid).val());
		detailid = taskid;

		if(!$("#"+taskid).parent().parent().hasClass("tr_select") && getVal($(foucsobj).attr("id"))!=""){
			$(".item_tr").removeClass("tr_select tr_blur");
			$("#"+taskid).removeClass("newinput").parent().parent().addClass("tr_select");
			
			var objcount = $("#"+taskid).parent().nextAll("td.item_count");
			var _fbcount = objcount.attr("_fbcount");
			if(parseInt(_fbcount)>0){
				objcount.removeClass("item_count_new").attr("title",_fbcount+"条反馈");
			}
			foucsobj = $("#"+taskid);
		}
	}else{
		foucsobj = null;
		$(".item_tr").removeClass("tr_select tr_blur");
		detailid = "";
	}
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
	    url: "/workrelate/goal/data/Operation.jsp",
	    data:{"operation":"edit_status","taskId":_taskid,"status":_status}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    success: function(data){ 
	    	reSetStatus(_taskid,_status,1);
		}
    });
}
function reSetStatus(taskid,_status,refresh){
	var sobj = $("#status_"+taskid);
	var pobj = $("#operate_"+taskid).children("div.item_status");
	var dobj = $("#todo_"+taskid);
	// if(searchstatus!=0){
		// obj.parent().parent().hide();
	// }else{
		if(_status==1){
			sobj.removeClass("status2 status2_hover status3 status3_hover").addClass("status1");
			pobj.attr("_status",_status).html("标记完成").attr("title","标记完成");
			dobj.addClass("div_todo");
	    }else if(_status==2){
	    	sobj.removeClass("status1 status1_hover status3 status3_hover").addClass("status2");
	    	pobj.attr("_status",_status).html("标记进行").attr("title","标记进行");
	    	dobj.removeClass("div_todo");
		}else if(_status==3){
			sobj.removeClass("status1 status1_hover status2 status2_hover").addClass("status3");
	    	pobj.attr("_status",_status).html("标记进行").attr("title","标记进行");
	    	dobj.removeClass("div_todo");
		}
		if(detailid==taskid && refresh==1){
			refreshDetail(taskid);
			// $("#detaildiv").append(loadstr);
			// $("#detaildiv").load("DetailView.jsp?taskId="+taskid+"&status="+_status);
		}
	// }
	if(searchstatus!=0){
		if(_status!=searchstatus){
			if(getVal($("#"+taskid).attr("_pid"))==""){
				sobj.parent().parent().hide();
				$("#operate_"+taskid).hide();
			}
		}else{
			sobj.parent().parent().show();
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
	$(obj).find("div.btn_del").show();
	$(obj).find("div.btn_wh").hide();
}
//隐藏删除按钮
function hidedel(obj){
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
		if($(obj).val()==tempval) return;
		fieldvalue = $(obj).val();
	}
	if(type==2){
		if($(obj).html()==tempval) return;
		fieldvalue = $(obj).html();
	}
	if(fieldname=="name"){
		if($.trim(fieldvalue)==""){
			$("#"+taskid).val(oldname);
			$(obj).val(oldname);
			return;
		}
		$("#"+taskid).val(fieldvalue);
	}
	exeUpdate(fieldname,fieldvalue,"str");
}
//删除选择性内容
function delItem(fieldname,fieldvalue){
	if(fieldname=="parentid"){
		if(!confirm("确定删除上级目标？")) return;
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
				setRelate(fieldname);
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
			$("#"+taskid).parent().nextAll("td.item_hrm").html("<a href='/hrm/resource/HrmResource.jsp?id="+id+"' target='_blank'>"+name+"</a>");
		}
		addtxt = transName(fieldname,id,name);
		addids = id;
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
	if($("#"+fieldname).prev("#showallp").length>0){
		$("#showallp").before(addtxt);
	}else{
		$("#"+fieldname).before(addtxt);
	}
	
	if(!startWith(fieldname,"_")){
		if(fieldname != "partnerid" && fieldname != "sharerid" && fieldname != "principalid" && fieldname != "parentid" && addvalue=="") return;
		exeUpdate(fieldname,addids,type,"",addvalue);
		setRelate(fieldname);
	}
}
//执行编辑
function exeUpdate(fieldname,fieldvalue,fieldtype,delvalue,addvalue){
	if(typeof(delvalue)=="undefined") delvalue = "";
	if(typeof(addvalue)=="undefined") addvalue = "";
	$.ajax({
		type: "post",
	    url: "/workrelate/goal/data/Operation.jsp",
	    data:{"operation":"edit_field","taskId":taskid,"fieldname":fieldname,"fieldvalue":filter(encodeURI(fieldvalue)),"fieldtype":fieldtype,"delvalue":encodeURI(delvalue),"addvalue":encodeURI(addvalue)}, 
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
	    	$("#logdiv").prepend(log);
	    	
	    	if(fieldname=="parentid" && sortcond==4) loadList();//层级视图下更改上级目标时刷新列表
		}
    });
}
//修改紧急程度
function setLevel(id){
	if($("#level"+id).hasClass("sdlink")) return;
	$("#level"+id).parent("td").find("a.slink").removeClass("sdlink");
	$("#level"+id).addClass("sdlink");//.attr("href","###");
	exeUpdate("level",id,"int");
	//设置列表中图标
	$("#level_"+taskid).css("background","url('../images/level_0"+id+".png') center no-repeat").attr("title",leveltitle[id]);
	//设置列表中位置
	if(sorttype==3){
		var obj = $("#"+taskid).parent().parent();
		//var newtr = $("<tr class='item_tr tr_select'>"+obj.html()+"</tr>");
		//newtr.find("#"+taskid).val($("#"+taskid).val());//此处需要重新设置一下标题
		$($($("table.datalist")[id-1]).find(".definput")[0]).parent().parent().before(obj);
		//obj.remove();
	}
}
//修改周期
function setPeriod(id){
	if($("#period"+id).hasClass("sdlink")) return;
	$("#period"+id).parent("td").find("a.slink").removeClass("sdlink");
	$("#period"+id).addClass("sdlink");//.attr("href","###");
	exeUpdate("period",id,"int");
	//设置列表中图标
	//$("#period"+taskid).css("background","url('../images/level_0"+id+".png') center no-repeat").attr("title",leveltitle[id]);
	//设置列表中位置
	if(periodcond!=id && periodcond!=0){
		$("#"+taskid).parent().parent().hide();
		$("#operate_"+taskid).hide();
	}else{
		$("#"+taskid).parent().parent().show();
	}
}
//修改是否开发所有子目标
function setShowallsub(id){
	if($("#showallsub"+id).hasClass("sdlink")) return;
	$("#showallsub"+id).parent("td").find("a.slink").removeClass("sdlink");
	$("#showallsub"+id).addClass("sdlink");//.attr("href","###");
	exeUpdate("showallsub",id,"int");
}
//调整日期
function resetSort(){
	var begindate = $("#begindate").val();
	var enddate = $("#enddate").val();
	//alert(enddate);
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
	$("#enddate_"+taskid).html(convertdate(enddate)).attr("title",enddate);
	if(sorttype!=2) return; 
	var table = $("#"+taskid).parents("table.datalist")[0];
	if($(table).attr("_datetype")!=datetype){
		var obj = $("#"+taskid).parent().parent();
		$($($("table.datalist")[datetype-1]).find("input.definput")[0]).parent().parent().before(obj);
		/**
		var value = $("#"+taskid).val();
		//var newtr = $("<tr class='item_tr tr_select'>"+obj.html()+"</tr>");
		var newstr = "<tr id='item_tr_"+todotaskid+"' class='item_tr";
		if(obj.hasClass("tr_select")) newstr += " tr_select";
		newstr += "' _taskid='"+todotaskid+"'>"+obj.html()+"</tr>";
		var newtr = $(newstr);
		$($($("table.datalist")[datetype-1]).find("input.definput")[0]).parent().parent().before(newtr);
		obj.remove();
		$("#"+taskid).val(value).attr("_defaultname",value);
		*/
	}
	setIndex();
}
function resetTodo(todotaskid,todotype,todoname){
	if($("#todo_"+todotaskid).length>0){
		$("#todo_"+todotaskid).attr("_val",todotype).attr("title",todoname);
	}
	if(sorttype!=5 || principalid!=userid) return; 
	var table = $("#"+todotaskid).parents("table.datalist")[0];
	if($(table).attr("_datetype")!=todotype){
		var obj = $("#"+todotaskid).parent().parent();
		$($($("table.datalist")[todotype-1]).find("input.definput")[0]).parent().parent().before(obj);
		/**
		var value = $("#"+todotaskid).val();
		var newstr = "<tr id='item_tr_"+todotaskid+"' class='item_tr";
		if(obj.hasClass("tr_select")) newstr += " tr_select";
		newstr += "' _taskid='"+todotaskid+"'>"+obj.html()+"</tr>";
		var newtr = $(newstr);
		//obj.remove();
		//$("#"+todotaskid).val(value).attr("_defaultname",value);
		*/
	}
	setIndex();
}
function resetCate(todotaskid,todotype){

	if(sorttype!=3) return; 
	var table = $("#"+todotaskid).parents("table.datalist")[0];
	if($(table).attr("_datetype")!=todotype){
		var obj = $("#"+todotaskid).parent().parent();
		$($($("table.datalist")[todotype-1]).find("input.definput")[0]).parent().parent().before(obj);
		/**
		var value = $("#"+todotaskid).val();
		var newstr = "<tr id='item_tr_"+todotaskid+"' class='item_tr";
		if(obj.hasClass("tr_select")) newstr += " tr_select";
		newstr += "' _taskid='"+todotaskid+"'>"+obj.html()+"</tr>";
		var newtr = $(newstr);
		//obj.remove();
		//$("#"+todotaskid).val(value).attr("_defaultname",value);
		*/
	}
	setIndex();
}
function setRelate(_type){
	if($("#reltr"+_type).find("div.txtlink").length==0){
		$("#reltr"+_type).hide();
		$("#relbtn"+_type).show();
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
	    url: "/workrelate/goal/data/Operation.jsp",
	    data:{"operation":"add_feedback","taskId":taskid,"content":filter(encodeURI($("#content").html())),"docids":$("#_docids_val").val(),"wfids":$("#_wfids_val").val(),"crmids":$("#_crmids_val").val(),"projectids":$("#_projectids_val").val(),"fileids":$("input[name=fbfileids]").val()}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(data){ 
		    /**
	    	data=$.trim(data.responseText);
	    	if(data!=""){
	    		$("#feedbacktable").prepend(data);
		    }*/
		    if(data!=""){
		    	var txt = $.trim(data.responseText);
		    	$("#feedbacktable").prepend(txt.split("$")[0]);
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
	$("#_crmids_val").val("");$("#_docids_val").val("");$("#_wfids_val").val("");$("#_projectids_val").val("");$("input[name=fbfileids]").val("");

	$("div.feedback_def").html("").removeClass("feedback_focus");
	$("div.btn_feedback").hide();
	if($("#fbrelatebtn").attr("_status")==1){$("#fbrelatebtn").click();}
	$("#fbrelatebtn").hide();
}
//获取反馈记录
function getFeedbackRecord(lastid){
	$("#gettr").children("td").html("<img src='../images/loading3.gif' align='absMiddle' />");
	$.ajax({
		type: "post",
	    url: "/workrelate/goal/data/Operation.jsp",
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
	$("#getlog").html("<img src='../images/loading3.gif' align='absMiddle' />");
	$.ajax({
		type: "post",
	    url: "/workrelate/goal/data/Operation.jsp",
	    data:{"operation":"get_log","taskId":taskid,"lastId":lastid}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(data){ 
	    	data=$.trim(data.responseText);
	    	$("#getlog").before(data).remove();
		}
    });
}

//状态设置
function doOperate(status){
	if(status==4){
		if(!confirm("确定删除此目标?")){
			return;
		}
	}
	$.ajax({
		type: "post",
	    url: "/workrelate/goal/data/Operation.jsp",
	    data:{"operation":"edit_status","taskId":taskid,"status":status}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(data){ 
		    var txt = $.trim(data.responseText);
	    	var ss = txt.split("$")
		    $("#logdiv").prepend(ss[0]);
		    if(ss.length>1){
		    	$("#feedbacktable").prepend(ss[1]);
			}
		    if(status==4) loadList();
		}
    });

	if(status==1){
		$("div.btn_operate").show();
		$("div.btn_complete").hide();
		$("div.btn_revoke").hide();
		$("#tdstatus").html("进行中");
    }else if(status==2){
    	$("div.btn_operate").hide();
    	$("div.btn_complete").show();
    	$("#tdstatus").html("完成");
	}else if(status==3){
    	$("div.btn_operate").hide();
    	$("div.btn_revoke").show();
    	$("#tdstatus").html("撤销");
	}else{
		if(getVal($(foucsobj).attr("_pid"))!=""){
			loadList();
		}else{
			if($(foucsobj).attr("id")==taskid) foucsobj=null;
			$("#"+taskid).parent().parent().remove();
		}
		var upload = document.getElementById("uploadDiv");
		if(upload!=null) upload.innerHTML = "";
		$("#detaildiv").append(loadstr).load("DefaultView.jsp");
	}
	$("div.btn_delete").show();

	reSetStatus(taskid,status,0);
}
function showop(obj,classname,txt){
	$(obj).removeClass(classname);//.html(txt);
}
function hideop(obj,classname,txt){
	$(obj).addClass(classname);//.html(txt);
}
function showCate(){
	var t = $("#cate").offset().top;
	var l = $("#cate").position().left;
	$('#dcatepanel').css({"top":t,"left":l}).show();
	//$('#dtodopanel').show();
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
function showallp(tid){
	$("#showallp").html("<img src='../images/loading3.gif' style='margin-top:4px;' />");
	$.ajax({
		type: "post",
	    url: "/workrelate/goal/data/Operation.jsp",
	    data:{"operation":"get_allp","taskid":tid,"status":status}, 
	    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
	    complete: function(data){ 
		    var txt = $.trim(data.responseText);
	    	$("#showallp").prevAll("div.txtlink").remove();
	    	$("#showallp").before(txt).remove();
		}
    });
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
	    var fieldvalue = "";
	    if(datas.id=="") fieldvalue=0;
	    selectUpdate(fieldname,datas.id,datas.name,'add');
    }
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
	}else if(fieldname=="goalids" || fieldname=="parentid"){
		restr += "<a href=javaScript:refreshDetail("+id+") >"+name+"</a>";
	}else if(fieldname=="taskids"){
		restr += "<a href=javaScript:showTask("+id+") >"+name+"</a>";
	}else if(fieldname=="tag"){
		restr += name;
	}
	
	restr +="</div>";
	if(fieldname!="principalid"){
		restr += "<div class='btn_del' onclick=\"delItem('"+delname+"','"+id+"')\"></div>";
		restr += "<div class='btn_wh'></div>";
	}
	restr += "</div>";
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