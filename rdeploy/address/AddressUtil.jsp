
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<script>


  function launchOn(){
  	return $("#launchIco").hasClass('launchOn');
  }
  
  function updateSelectedCnt(){
  	var headsDispane = $("#displaypane").find(".userHeadsDis");
  	var selectedCnt = headsDispane.find(".headCellItem").length;
	$("#imMainbox .imTopTitle").html("已选择("+selectedCnt+")");
  }
  
  //移出单人
  function removeCurCell(obj) {
  	$(obj).parent().remove();
  	updateSelectedCnt();
  }
  //处理item点击
  function doItemClick(obj){
  	var targettype = $(obj).attr("_targettype");
  	var targetid = $(obj).attr("_targetid");
  	if(launchOn()){
  		addPersonToPane(obj, targettype);
  	}else{
  		clearUpheadCells();
  		var targettype = $(obj).attr("_targettype");
  		if(targettype == "0")
  			showPersonInfo(targetid, obj);
  		else if(targettype == "1")
  			showDiscussInfo(targetid, obj);
  	}
  	//切换样式
  	$(obj).parent().find('.chatItem').removeClass("chatActiveItem");
  	$(obj).addClass("chatActiveItem");
  	
  }
  //是否管理员
  function checkIfAdmin(){
  	return loginuserid=='1';
  }
  //管理员添加成员
  function doAddNewMember(){
  	if(!checkIfAdmin()){
  		doInvitationResource();
  		return;
  	}
	if(dialog==null){
		dialog = new window.top.Dialog();
	}
	dialog.currentWindow = window;
	dialog.Title = "新增人员";
    dialog.URL = "/rdeploy/hrm/RdResourceAdd.jsp";
	dialog.Width = 400;
	dialog.Height = 260;
	dialog.Drag = true;
	dialog.textAlign = "center";
	dialog.normalDialog = false;
	dialog.show();
  }
  //邀请成员
  function doInvitationResource(){
	dialog = new window.top.Dialog();
	dialog.currentWindow = window;
	var url = "";
	dialog.Width = 600;
	dialog.Height = 390;
	dialog.Title = "邀请成员加入";
	url = "/rdeploy/hrm/RdInvitationResource.jsp";
	dialog.Drag = true;
	dialog.URL = url;
	dialog.show();
}
//显示人员名片
function showPersonInfo(targetid, obj){
  var dispane = $("#displaypane");
  dispane.find(".dis").hide();
  $("#imMainbox .imTopTitle").html("详细信息");
  $("#imMainbox .clearConfirmBtn").hide();
  $("#imMainbox .addComfirmBtn").hide();
  
  dispane.find(".personInfoCard").load("/rdeploy/address/AddressPCard.jsp?resourceid="+targetid);
  dispane.find(".personInfoDis").attr("_targetid", targetid).show();
}
//显示群名片
function showDiscussInfo(targetid, obj){
	var dispane = $("#displaypane");
	dispane.find(".dis").hide();
	$("#imMainbox .imTopTitle").html("详细信息");
  	$("#imMainbox .clearConfirmBtn").hide();
  	$("#imMainbox .addComfirmBtn").hide();
  	
  	dispane.find(".groupInfoCard").load("/rdeploy/address/AddressGCard.jsp?targetid="+targetid);
  	dispane.find(".groupInfoDis").attr("_targetid", targetid).show();
}

//取消发起群聊
function cancelLaunchDisc() {
	var dispane = $("#displaypane");
  	dispane.find(".dis").hide();
  	$("#imMainbox .imTopTitle").html("详细信息");
  	$("#imMainbox .clearConfirmBtn").hide();
  	$("#imMainbox .addComfirmBtn").hide();
  	dispane.find(".noInfoDis").show();
  	clearUpheadCells();
}
//发起群聊
function confirmLaunchDisc() {
	var headsDispane = $("#displaypane").find(".userHeadsDis");
	var cells = headsDispane.find(".headCellItem");
	if(cells.length > 0){
		var cell;
		var ids = [], names = [];
		for(var i = 0; i < cells.length; ++i){
			cell = $(cells[i]);
			ids.push(cell.attr("_targetid"));
			names.push(cell.find(".mname").html());
		}
	}
	openGroupChat(ids, names);
}
//打开群聊窗口
function openGroupChat(ids, names) {
	var data = {id: ids.join(","), name: names.join(",")};
	parentWin.DiscussUtil.addDiscussCallback(event, data, '','');
	jumpToModel("message");
}
//打开单聊窗口
function openP2PChat(targetid, current) {
	var targetname = current.attr("_targetname");
	var targethead = current.attr("_targethead");
	var targettype = '0';
	jumpToModel("message");
	parentWin.ChatUtil.setCurDiscussInfo(targetid, targettype);
	parentWin.showIMChatpanel(targettype, targetid,targetname,targethead);
}
//打开个人聊天窗口
function openIMChat(obj, targettype) {
	var targetid = $(obj).parent().attr("_targetid");
	var modelstr = "message";
	if(""!=targetid){
		//打开会话窗口
		var targetName='', targetHead='';
		var disPane = $(obj).parents(".displayPane");
		if(targettype == '0'){
			targetName = disPane.find("#outTbl").data("targetName");
			targetHead = disPane.find("#outTbl").data("targetHead");
		}else{
			targetName = disPane.find(".dsName").html();
			targetHead = disPane.find(".dsHead img").attr("src");
		}
		if(targettype == '1'){
			parentWin.ChatUtil.getDiscussionInfo(targetid, false, function(discuss){
				if(!!discuss){
					parentWin.ChatUtil.setCurDiscussInfo(targetid, targettype);
					parentWin.showIMChatpanel(targettype, targetid,targetName,targetHead);
					//窗口跳转
					jumpToModel(modelstr);
				}
			})
		}else if(targettype == '0'){
			parentWin.ChatUtil.setCurDiscussInfo(targetid, targettype);
			parentWin.showIMChatpanel(targettype, targetid,targetName,targetHead);
			//窗口跳转
			jumpToModel(modelstr);
		}
		
	}
}
//导航跳转
function jumpToModel(modelstr){
	var parentDoc = $(window.parent.document);
	var navblock = parentDoc.find("#navblock");
	var nava = navblock.find("input[value='"+modelstr+"']").parent();
	var oldselectedele = navblock.find("ul li a.selected");
    oldselectedele.removeClass("selected");
    oldselectedele.find("img").hide();
    oldselectedele.find("img").eq(0).show();
    
    nava.removeClass("slt");
    nava.addClass("selected");
    nava.find("img").hide();
    nava.find("img").eq(1).show();
    
    if(modelstr=="message"){
    	parentDoc.find("#messagediv").show();
   		parentDoc.find("#mainFrame").hide();
    }else{
    	parentDoc.find("#messagediv").hide();
    	parentDoc.find("#mainFrame").show();
    	
    	parentDoc.showmodel(modelstr);
    }
}
//刷新组织列表
function refreshHrmList(){
	$("#imMainbox .imToptab .activeitem").click();
}
//获取树下的所有人员
function getAllPersonList(root, target, callback){
	$.post("/rdeploy/address/AddressOperation.jsp?operation=getAllPersonList&root="+root+"&target="+target, 
	function(response){
		callback(response);
	})
}
//清空选择的头像
function clearUpheadCells(){
	var headsDispane = $("#displaypane").find(".userHeadsDis");
	headsDispane.empty();
	$("#imMainbox .imTopTitle").html("已选择(0)");
	$("#imMainbox .addComfirmBtn").hide();
}
//添加具体人员头像到显示面板
function addPersonToPaneBase(targetid, targetName, targetHead){
	var dispane = $("#displaypane");
	dispane.find(".dis").hide();
	var headsDispane = dispane.find(".userHeadsDis");
	
	var temp = $("#headCellTemp").clone();
	temp.find(".mhead").attr("src", targetHead);
	temp.find(".mname").html(targetName);
	temp.attr({"_targetid": targetid, "id":"cellhead_"+targetid}).show();
	checkToAppend(temp, headsDispane, targetid);
	
	updateSelectedCnt();
	$("#imMainbox .clearConfirmBtn").show();
	$("#imMainbox .addComfirmBtn").show();
	dispane.find(".userHeadsDis").show();
}
//添加头像到显示面板
 function addPersonToPane(obj, targettype) {
 	var targetid=$(obj).attr("_targetid");
	var targetName=$(obj).attr("_targetName");
	var targetHead=$(obj).attr("_targetHead");
	var dispane = $("#displaypane");
	dispane.find(".dis").hide();
	var headsDispane = dispane.find(".userHeadsDis");
	
	if("0" == targettype){
		var temp = $("#headCellTemp").clone();
		temp.find(".mhead").attr("src", targetHead);
		temp.find(".mname").html(targetName);
		temp.attr({"_targetid": targetid, "id":"cellhead_"+targetid}).show();
		checkToAppend(temp, headsDispane, targetid);
	}else if("1" == targettype){
		parentWin.ChatUtil.getDiscussionInfo(targetid, true, function(discuss){
			var memberIds=discuss.getMemberIdList();
			var memberid;
			for(var i=memberIds.length-1;i>=0;i--){
				memberid = parentWin.getRealUserId(memberIds[i]);
				var headCell= getHeadCell(targetid, memberid);
				checkToAppend(headCell, headsDispane, memberid);
			}
			updateSelectedCnt();
		});
	}
	updateSelectedCnt();
	$("#imMainbox .clearConfirmBtn").show();
	$("#imMainbox .addComfirmBtn").show();
	dispane.find(".userHeadsDis").show();
 }
function checkToAppend(cell, dispane, id) {
	if(dispane.find("#cellhead_"+id).length <= 0){
		cell.appendTo(dispane);
	}
}
function getHeadCell(targetid, memberid) {
	var memberinfo=parentWin.getUserInfo(memberid);
	var temp = $("#headCellTemp").clone();
	temp.find(".mhead").attr("src", memberinfo.userHead);
	temp.find(".mname").html(memberinfo.userName);
	temp.attr({"_targetid": targetid, "id":"cellhead_"+memberid}).show();
	return temp;
}
//加载最近
function loadRecent(){
	$('#recentListdiv .dataloading').hide();
	loadIMDataList('recent');
}


/*SocialUtil.jsp重构*/
//初始化顶部
  function initIMNavTop(){
  
  	$(".imToptab .tabitem").bind("click",function(){
  		
  			$(".imToptab .activeitem").removeClass("activeitem");
  			var target=$(this).attr("_target");
  			
  			$(this).addClass("activeitem");
  			
  			$(".leftMenus .leftMenudiv").hide();
  			$("#"+target+"Listdiv").show();
  			
  			if(target=="contact"){
  				$("#imConTabs").show();
  				loadIMDataList("dept");
  			}else{
  				$("#imConTabs").hide();
  				loadIMDataList(target);
  			}
  			
  			
  			
  	});
  	$(".imToptab .tabitem:first").click();
  }	
  var M_HINT = "  姓名/首字母/移动电话";  //感觉这里要做标签的规范
  var M_SMS = "无搜索结果";	  //默认显示的提示
  //获取搜索关键字
  function getKeyword() {
  	var keyword = $.trim($("#searchResultListDiv>.imSearchInputdiv").val());
  	try {
  		if(keyword == undefined || keyword == '' || keyword == M_HINT)
  			throw "未输入搜索关键字";	//同样要坐标签的规范
  			
  		return keyword;
  	}catch(err){
  		return undefined;
  	}
  }
  
  //校验关键字合法性
  function checkValid(keyword) {
  	var keyword = $.trim(keyword);
  	//TODO 这里校验关键字是否非法字符
  	if(keyword == undefined || keyword == ''){
  		return false;
  	}
  	if(keyword != preKeyword){
  		console && console.log("校验关键字[" + keyword + "]合法");
  	}
  	return true;
  }
  
  var preKeyword = undefined;		//上一个搜索的关键字
  var searchTimer = undefined;		//搜索定时器
  //搜索联系人
  function doSearch(keyword) {
  	window.clearTimeout(searchTimer);
  	searchTimer = window.setTimeout(function(){
  		doRealSearch(keyword);
  	}, 400);
  }
  
  //处理上下键
  function doHandleKeyUpdown(evt){
  	if(!evt) evt = window.event;
  	if(evt.keyCode != 38 && evt.keyCode != 40 && 
  		evt.keyCode != 13 && evt.keyCode != 10){
  		return false;
  	}
  	var searchList = $("#imSearchList");
  	var current = searchList.find(".chatActiveItem");
  	if(evt.keyCode == 13 || evt.keyCode == 10){
  		if(current.length > 0){
  			current.click();
  			return true;
  		}
  		return false;
  	}
  	
  	var items = searchList.find(".chatItem");
  	if(evt.keyCode == 38){  //up
  		if(current.length <= 0){
	  		if(items.length > 0){
	  			current = searchList.find(".chatItem:visible:last");
	  			var top = current.offset().top;
	  			searchList.scrollTop(top);
	  			var page = (top + current.outerHeight()) / (searchList.height());
	  			searchList.data("page", page);
	  			searchList.find(".chatItem:visible:last").addClass("chatActiveItem");
	  		}
	  	}else{
	  		var prev = current.prevAll(".chatItem:visible").first();
	  		if(prev.length > 0){
	  			current.removeClass("chatActiveItem");
	  			var top = ajustItemTop(current);
	  			prev.addClass("chatActiveItem");
	  		}
	  	}
  		
  	}else if(evt.keyCode == 40){  //down
  		if(current.length <= 0){
	  		if(items.length > 0){
	  			current = searchList.find(".chatItem:first");
	  			var top = ajustItemTop(current);
	  			searchList.find(".chatItem:visible:first").addClass("chatActiveItem");
	  		}
	  	}else{
	  		var next = current.nextAll(".chatItem:visible").first();
	  		current.removeClass("chatActiveItem");
	  		if(next.length > 0){
	  			var top = ajustItemTop(current);
	  			next.addClass("chatActiveItem");
	  		}
	  		//到底部再移动到首位
	  		else if(items.length > 0){
	  			current = searchList.find(".chatItem:first");
	  			var top = searchList.scrollTop(0);
	  			searchList.data("page", 0);
	  			searchList.find(".chatItem:visible:first").addClass("chatActiveItem");
	  		}
	  	}
  	}
  	return true;
  }
  //获取元素的绝对位置
  function ajustItemTop(domElement){
  	var item = $(domElement);
  	var top = item.position().top;
  	var container = $(domElement).parent();
  	var conHt = container.height();
  	var itemHt = item.outerHeight();
  	//console.log("top:" + top+"父窗口:"+conHt+"条目："+itemHt);
  	if(top > conHt - itemHt){
  		top = conHt - itemHt;
  		//alert("top:"+top);
  		var page = container.data("page");
  		if(page == undefined) page = 0;
  		page++;
  		container.scrollTop(conHt*page);
  		//alert(conHt*page);
  		container.data("page", page);
  	}
  	if(top < 0){
  		top = 0;
  		var page = container.data("page");
  		if(page == undefined) page = 0;
  		if(page > 0) page--;
  		container.scrollTop(conHt*page);
  		container.data("page", page);
  	}
  	return top;
  }
  //搜索
  function doRealSearch(keyword){
  	if(keyword == ''){		//搜索的关键字为空则执行清空动作
  	//	showResultDiv(0);
  		clearHistorySearch();
  		return;
  	}
  	var keyword = $.trim(keyword);
  	if(keyword == ''){
  		//清空？
  	}
  	if(checkValid(keyword)){
  		if(keyword != preKeyword){
  			preKeyword = keyword;
	 		console && console.log("搜索: " + keyword);
	 		loadIMDataList("tempSearch");
  		}
 	}
  }
  
  //清空历史搜索
  function clearHistorySearch() {
  	$("#searchResultListDiv>.imSearchList").empty();
  	preKeyword = undefined;
  }
  
  function changeLaunchState(obj) {
  	var launchIco = $(obj).find('.launchIco');
  	if(launchIco.hasClass("launchHover")){
  		launchIco.removeClass("launchHover")
  	}
  	if(!launchIco.hasClass('launchOn')){
  		launchIco.addClass('launchOn');
  	}else{
  		launchIco.removeClass('launchOn');
  	}
  }
  
  //显示并搜索最近联系人
  function showResultDiv(bDisplay) {
  	if(bDisplay){
  		$("#searchResultListDiv").show();
  		var target = "tempSearch";
  		$("#searchResultListDiv>.imSearchInputdiv").focus().val(preKeyword==undefined?'':preKeyword).select();
  		$("#searchResultListDiv>.imSearchClose").bind("click", function(){
  			showResultDiv(0);
  			//这里还要清空历史搜索
  			clearHistorySearch();
  		});
  		//这里暂时不用加载联系人
  		//添加事件监听器
  		$(document).bind('click.tempsearch', function(e){
  			var target = $(e.target || e.srcElement);
  			if(getKeyword() != undefined){
  			//	$("#searchResultListDiv>.imSearchInputdiv").select();
  			//	对搜索结果做隐藏
  				showResultDiv(0);
  				$(".imSearchdiv").find(".imInputdiv").val(preKeyword==undefined?'':preKeyword);
  			}else if(target.attr('class') != 'imInputdiv') showResultDiv(0);
  		});
  		$("#searchResultListDiv").bind('click', function(e){
  			e.stopPropagation();
  		});
  	}else{
  		$("#searchResultListDiv").css({display:'none', position:'absolute'});
  		$("#searchResultListDiv>.imSearchClose").unbind("click");
  		$(document).unbind('.tempsearch');
  		$("#searchResultListDiv").unbind('click');
  		$(".imSearchdiv").find(".imInputdiv").val(M_HINT);
  	}
  }
  
  //显示最近联系人列表
  function dropRecent(evt, searchbox) {
  	var search = $(searchbox);
  	var hint = search.val();
  	if(hint == M_HINT)		
  		search.val(preKeyword==undefined?'':preKeyword);
  	//显示遮罩
  	showResultDiv(1);
  }
  
  //搜索结果为空时的显示
  function showEmptyResultDiv(bShow, containerId, sms, _margin_top_px) {
  	var oContainer = $("#" + containerId);
  	var default_px = 200;
  	if(bShow) {
	  	//隐藏所有的子元素
	  	oContainer.find('._hiddeit').hide();
	  	oContainer.append('<div class=\"_removeit\" style=\"' +
	  	 'background: url(\'/social/images/search_empty_wev8.png\') no-repeat center;' +
	  	 'background-size:58px 58px;' +
	  	 'background-position:center center;' +
	  	 'width:100%;height:60px;' +
	  	 'margin-top: ' + (_margin_top_px==undefined?default_px:_margin_top_px) + 'px;' +
	  	 'text-align: center;' +
	  	 '\"></div>');
	  	oContainer.append('<div class=\"_removeit\" style=\"' +
	  	'text-align:center;' +
	  	'width:100%;height:20px;' + 
	  	'line-height:20px;' +
	  	'font-size:14px;' +
	  	'font-family:\'微软雅黑\', Verdana, Arial, Tahoma;' +
	  	'color: #b1c2c5;' +
	  	'\">' + (sms == undefined?M_SMS:sms) + '</div>');
  	}else{
  		oContainer.remove('._removeit');
  		oContainer.find('._hiddeit').show();
  	}
  }
  
</script>