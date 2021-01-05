<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.BaseBean"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ include file="/page/maint/common/initNoCache.jsp" %>

<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragrma","no-cache");
	response.setDateHeader("Expires",0);
	
	BaseBean bb = new BaseBean();
	if(Util.getIntValue(bb.getPropValue("workrelate_task","status"),0)!=1
		&&Util.getIntValue(bb.getPropValue("workrelate","istask"),0)!=1){
		out.print("<table width='100%'><tr><td align='center'>您的系统未开启任务管理模块<br/>请联系泛微服务人员</td></tr></table>");
		return;
	}
	
	String clienttype = Util.null2String((String)request.getParameter("clienttype"));
	String clientlevel = Util.null2String((String)request.getParameter("clientlevel"));
	String module=Util.null2String((String)request.getParameter("module"));
	String scope=Util.null2String((String)request.getParameter("scope"));
	
	int MENU_TYPE = Util.getIntValue(request.getParameter("MENUTYPE"),-1);
	int LIST_TYPE = Util.getIntValue(request.getParameter("LIST_TYPE"),-1);
	int STATUS = Util.getIntValue(request.getParameter("STATUS"),-1);
	int viewId = 0;
	String SELTAG = "";
	rs.executeSql("select * from TM_TaskView where userid="+user.getUID());
	if(rs.next()){
		viewId = Util.getIntValue(rs.getString("id"),0);
		if(MENU_TYPE<0||MENU_TYPE>8){
			MENU_TYPE = Util.getIntValue(rs.getString("menutype"),1);
		}
		if(LIST_TYPE<0){
			LIST_TYPE = Util.getIntValue(rs.getString("listtype"),5);
		}
		if(STATUS<0){
			STATUS = Util.getIntValue(rs.getString("status"),0);
		}
		SELTAG = Util.null2String(rs.getString("seltag"));
	}else{
		MENU_TYPE = 1;
		LIST_TYPE = 5;
		STATUS = 0;
	}
	if(LIST_TYPE==5) STATUS = 1;//todo视图查进行中
	String param = "clienttype="+clienttype+"&clientlevel="+clientlevel+"&module="+module+"&scope="+scope;
	//查询是否有下属
	boolean hassub = false;
	rs.executeSql("select count(id) as amount from hrmresource where loginid<>'' and loginid is not null and (status =0 or status = 1 or status = 2 or status = 3) and managerid=" + user.getUID());
	int count = 0;
	if(rs.next()){
		 count = Util.getIntValue(rs.getString(1),0);
	 }
	if(count>0) hassub = true;
	int hrmid = Util.getIntValue(request.getParameter("hrmid"),0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
	<meta http-equiv="Cache-Control" content="no-cache,must-revalidate"/>
	<meta http-equiv="Pragma" content="no-cache"/>
	<meta http-equiv="Expires" content="0"/>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/mobile/plugin/task/js/jquery-1.8.3.js'></script>
	<script type='text/javascript' src='/mobile/plugin/task/js/task.js'></script>
	<!-- 触摸事件JS  -->
	<script type='text/javascript' src='/mobile/plugin/task/js/touch-0.2.14.js'></script>
	<!-- 遮罩层 -->
	<script type='text/javascript' src='/mobile/plugin/task/js/showLoading/js/jquery.showLoading.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/task/js/showLoading/css/showLoading.css" />
	
	<link rel="stylesheet" href="/mobile/plugin/task/css/task.css" />
	
	<style type="text/css">
		<%if("".equals(clienttype)||clienttype.equals("Webclient")){%>
			#header{display: block;}
			.taskSelectDiv{top:40px;}
			.floattitle{top:40px;}
		<%}%>
	</style>
<%@ include file="/secondwev/common/head.jsp" %>
	</head>
<body id="body">
	<table class="taskTable" cellpadding="0" cellspacing="0">
		<tr>
			<td valign="top">
				<div id="topmain" class="topmain"><!-- 顶部 -->
					<div id="header">
						<table style="width: 100%;height: 40px;">
							<tr>
								<td width="10%" align="left" valign="middle" style="padding-left:5px;">
									<div class="taskTopBtn" onclick="doLeftButton()">返回</div>
								</td>
								<td align="center" valign="middle">
									<div id="title">任务</div>
								</td>
								<td width="10%" align="right" valign="middle" style="padding-right:5px;">
									<div id="rightBtn" class="taskTopBtn" onclick="doRightButton()">筛选</div>
								</td>
							</tr>
						</table>
					</div>
				</div>
				<div id="tabblank" class="tabblank"></div><!-- 站位顶部导航FIXED的空白 -->
				<!-- 状态选择和搜索框 START -->
				<div class="taskSelectDiv" id="taskSelectDiv">
					<table width="100%" height="100%">
						<tr>
							<td width="5"></td>
							<td width="82" id="tsTd1">
							<div id="statusShow" class="statusShow">
								<%if(STATUS==0){ %>
								&nbsp;&nbsp;&nbsp;全部
								<%}else if(STATUS==1){ %>
								&nbsp;&nbsp;&nbsp;进行中
								<%}else if(STATUS==2){ %>
								&nbsp;&nbsp;&nbsp;已完成
								<%}else if(STATUS==3){ %>
								&nbsp;&nbsp;&nbsp;已撤销
								<%} %>
							</div></td>
							<td width="*" id="tdTd2" style="position:relative;overflow:hidden;height:28px;">
								<div class="selInput">
								<input type="text" id="selTag" value="<%=SELTAG %>" placeholder="请输入名称或标签搜索"/>
								</div>
								<div class="selBtn">&nbsp;</div>
							</td>
							<td width="5"></td>
						</tr>
					</table>
				</div>
				<div id="statusSel" class="statusSel">
					<div class="statusSelOpn" status="0">&nbsp;&nbsp;&nbsp;全部</div>
					<div class="statusSelOpn" status="1">&nbsp;&nbsp;&nbsp;进行中</div>
					<div class="statusSelOpn" status="2">&nbsp;&nbsp;&nbsp;已完成</div>
					<!-- <div class="statusSelOpn" status="3">&nbsp;&nbsp;&nbsp;已撤销</div>-->
				</div>
				<!-- 状态选择和搜索框 END -->
				<div id="tabSelBlank" class="tabblank"></div><!-- 站位顶部搜索FIXED的空白 -->
				<div id="list" class="list"><!-- 数据展示 -->
					<div class="listItemTypeDiv" id="itemType0"><div class="loadTips">&nbsp;</div></div>
					<div class="listItemTypeDiv" id="itemType1"><div class="loadTips">&nbsp;</div></div>
					<div class="listItemTypeDiv" id="itemType2"><div class="loadTips">&nbsp;</div></div>
					<div class="listItemTypeDiv" id="itemType3"><div class="loadTips">&nbsp;</div></div>
					<div class="listItemTypeDiv" id="itemType4"><div class="loadTips">&nbsp;</div></div>
					<div class="optDiv">
						
					</div>
				</div>
				<!-- 浮动今天、明天标题 -->
				<div class="floattitle" id="floattitle">
					<div class="itemTitle" id="itemTitle_Float"></div>
				</div>
		</td>
	</tr>
	</table>
	<!-- 右上筛选菜单点击弹出部分 START-->
	<div class="taskMenu" id="taskMenu">
		<table class="bottomTable">
			<tr><td menuType="1">我的任务</td></tr>
			<%if(hassub){ %>
			<tr><td menuType="-2">下属任务</td></tr>
			<%} %>
			<tr><td menuType="3">我负责的</td></tr>
			<tr><td menuType="4">我参与的</td></tr>
			<tr><td menuType="6">我关注的</td></tr>
			<tr><td menuType="2">我创建的</td></tr>
			<tr><td menuType="8">我分配的</td></tr>
			<tr><td menuType="5">分享给我的</td></tr>
			<tr><td menuType="0">所有任务</td></tr>
			<tr><td menuType="7">已完成新反馈</td></tr>
		</table>
	</div>
	<!-- 右上筛选菜单点击弹出部分END -->
	
	<!-- 可拖动DIV和点击后弹出的视图选择DIV START -->
	<div class="dragDiv" id="target"></div>
	<div class="listType" id="listType">
		<table cellpadding="0" cellspacing="0">
			<tr>
				<td colspan="3" align="center"><span listType="5" class="todoSpan">TodoList</span></td>
			</tr>
			<tr>
				<td align="center"><span listType="2" class="dateSpan">到期视图</span></td>
				<td align="center"><span listType="-1" class="newSpan">&nbsp;</span></td>
				<td align="center"><span listType="3" class="levSpan">重要紧急</span></td>
			</tr>
			<tr>
				<td colspan="3" align="center" valign="top"><span listType="1" class="listSpan">列表视图</span></td>
			</tr>
		</table>
	</div>
	<!-- 可拖动DIV和点击后弹出的视图选择DIV END -->
	
	<script type="text/javascript">
		var param = "<%=param%>";
		var viewId = "<%=viewId%>";
		var HRMID = "<%=hrmid%>";
		var MENU_TYPE = "<%=MENU_TYPE%>";//我的任务
		var LIST_TYPE = "<%=LIST_TYPE%>";//todo
		var STATUS = "<%=STATUS%>";//任务状态
		var SELTAG = "<%=SELTAG%>";//搜索关键字
		var TOP_TITLE = 0;
		<%if("".equals(clienttype)||clienttype.equals("Webclient")){%>
			TOP_TITLE = 40;
		<%}%>
		getMenus();
		$(document).ready(function(){
		
			$("#tabblank").height($("#topmain").height());//占位fixed出来的空间
			
			$("#taskMenu .bottomTable tr td").each(function(){//初始化按钮点击样式
				if($(this).attr("menuType")==MENU_TYPE){
					$(this).addClass("click");
					return false;
				}
			});
			
			$("#taskBottom .bottomTable tr td").each(function(){//初始化按钮点击样式
				if($(this).attr("listType")==LIST_TYPE){
					$(this).addClass("click");
					return false;
				}
			});
			
			$(".listTable").live("click",function(e){//任务点击跳转详细页面
				var taskId = $(this).attr("taskId");
				showLoading();
				location.href="/mobile/plugin/task/taskDetail.jsp?taskId="+taskId+"&"+param+"&ifFb="+$(this).attr("ifFb")+"&hrmid="+HRMID;
			});
			
			$("#taskMenu .bottomTable tr td").click(function(){//menuType点击事件
				$("#taskMenu .bottomTable tr td").removeClass("click");
				$(this).addClass("click");
				var menuType = $(this).attr("menuType");
				if(menuType==MENU_TYPE) return;
				if(menuType==-1){//新建任务
					createTask("");
				}else if(menuType==-2){//查看下属任务
					location.href="/mobile/plugin/task/subList.jsp?"+param;
				}else{//切换条件查询任务
					HRMID = "0";
					MENU_TYPE = menuType;
					getTaskList();
				}
			});
			
			$("#taskBottom .bottomTable tr td").click(function(){//listType点击事件
				$("#taskBottom .bottomTable tr td").removeClass("click");
				$(this).addClass("click");
				var listType = $(this).attr("listType");
				if(listType==LIST_TYPE) return;
				LIST_TYPE = listType;
				if(listType==5)STATUS = 1;//点击todo将状态置为1
				getTaskList();
			});
			changeStatusShow();//是否显示状态选择
			
			getTaskList();//页面加载自动触发一次加载更多事件 加载我的todo任务
			
			$(window).scroll(function(){//滚动时候自动固定标题
				if(LIST_TYPE!=1){
					var scroll = $(document).scrollTop();
					if(scroll>0){
						for(var i=0;i<5;i++){
							var tp = $("#itemTitle"+i).offset().top;
							if(tp<(scroll+TOP_TITLE)){
								$("#itemTitle_Float").html($("#itemTitle"+i).html());
								$("#floattitle").show();
							}
						}
					}else{
						$("#floattitle").hide();
					}
				}
				//固定搜索框
				//$("#taskSelectDiv").css("top",scroll+selTop);
			});
			$(".showMoreTask").live("click",function(){//加载更多
				var itemType = $(this).attr("itemType");
				var pageNumStr = "pageNum_"+LIST_TYPE+"_"+MENU_TYPE+"_"+itemType;
				var pageNum = $("#"+pageNumStr).val();
				getData(itemType,pageNum);
				
			});
			
			$(".titleCreate").live("click",function(){//创建任务点击
				var itemType = parseInt($(this).attr("itemType"))+1;
				createTask(itemType);
			});
			
			$("div.statusSelOpn").bind("mouseover",function(){//状态选项点击触发
				$(this).addClass("statusSelOpn_hover");
			}).bind("mouseout",function(){
				$(this).removeClass("statusSelOpn_hover");
			}).bind("click",function(){
				var status = $(this).attr("status");
				if(status==STATUS){
					$("#statusSel").hide();
					return;
				}
				STATUS = status;
				$("#statusShow").html($(this).html());
				getTaskList();
			});
			
			$("#statusShow").bind("click",function(){//显示状态选择
				var _t = 33;
				<%if("".equals(clienttype)||clienttype.equals("Webclient")){%>
					_t = 73;
				<%}%>
				var _l = $("#statusShow").position().left;
				$("#statusSel").css({"top":_t,"left":_l}).show();
			});
			
			$("div.selBtn").click(function(){//输入关键字查询
				var selTag = $.trim($("#selTag").val());
				SELTAG = selTag;
				getTaskList();
			});
			//搜索框绑定事件
			$("#selTag").bind("focus",function(){
				$("div.selInput").addClass("selInputFocus");
				$("div.selBtn").addClass("selInputFocus");
				//$("#taskSelectDiv").css("position","absolute");
			}).bind("blur",function(){
				$("div.selInput").removeClass("selInputFocus");
				$("div.selBtn").removeClass("selInputFocus");
				//$("#taskSelectDiv").css("position","fixed");
			}).keyup(function(event) {
				var keyCode = event.keyCode;
				if (keyCode == 13) {
					var selTag = $.trim($("#selTag").val());
					SELTAG = selTag;
					getTaskList();
					$("#selTag").blur();
				}
			});
			
			//可拖动按钮
			var dx, dy,offx,offy;var dragged = false;
			touch.on('#target', 'touchstart', function(ev){
				$("#target").addClass("dragClick");
				ev.preventDefault();
			});
			touch.on('#target', 'touchend', function(ev){
				if(dragged) return;
				$(this).hide();
				var width = $(".taskTable").width();
				$("#listType").css("width",width-40)
				.css("top",($(window).height()-$("#listType").height())/2)
				.css("left","20px").show();
			});
			touch.on('#target', 'drag', function(ev){
				dx = dx || 0;
				dy = dy || 0;
				offx = dx + ev.x;
				offy = dy + ev.y;
				var dHeight = document.body.clientHeight-150;
				if(Math.abs(offy)>dHeight) offy = 0-dHeight;
				if(offy>0) offy = 0;
				this.style.webkitTransform = "translate3d(" + offx + "px," + offy + "px,0)";
				if(Math.abs(offx)>10||Math.abs(offy)>10)
					dragged = true;
			});
			touch.on('#target', 'dragend', function(ev){
				this.style.webkitTransform = "translate3d(0px," + offy + "px,0)";
				$("#target").removeClass("dragClick");
				dx = 0;
				dy = ev.y;
   				dragged = false;
			});
			
			$("#listType table td span").click(function(){
				var listType = $(this).attr("listType");
				if(listType==-1){//新建任务
					createTask("");
					return;
				}
				if(listType==LIST_TYPE) return;
				LIST_TYPE = listType;
				if(listType==5)STATUS = 1;//点击todo将状态置为1
				getTaskList();
			});
			//删除
			$("div.item_del").live("click",function(){
				setFinish($(this),4);
			});
			//反馈
			$("div.item_fb").live("click",function(){
				$("#listTable_"+$(this).attr("taskid")).attr("ifFb",1).click();
			});
			//关注
			$("div.item_att").live("click",function(){
				addFav($(this));
			});
			//完成
			$("div.item_status").live("click",function(){
				var status = $(this).attr("status");
				if(status==1){//为1表示当前状态是进行中，进行的操作时标记完成
					setFinish($(this),2);
				}else if(status==2){
					setFinish($(this),1);
				}
			});
			
		});
		
		function addFav(obj){//添加关注
			showLoading();
			var special = obj.attr("special");
			$.ajax({
				type: "post",
			    url: "/mobile/plugin/task/favOperation.jsp",
			    data:{"taskid":obj.attr("taskid"),"special":special}, 
			    dataType:"json",
			    success:function(data){
			    	if(data.status==0){
			    		if(special==0){
			    			obj.html("取消关注").attr("special",1);
			    		}else{
			    			obj.html("添加关注").attr("special",0);
			    		}
			    		//$("#operate_"+obj.attr("taskid")).animate({right:"-280px"},300).attr("ifShow",1);
			    	}else{
			    		alert(data.msg);
			    	}
			    },
			    complete: function(data){
			    	hideLoading();
				}
		    });
		}
		
		function setFinish(obj,status){//改变状态，标记完成、进行中、删除
			if(status==4){
				if(!confirm("确定删除此任务?")){
					return;
				}
			}
			showLoading();
			$.ajax({
				type: "post",
			    url: "/mobile/plugin/task/changeStatus.jsp",
			    data:{"taskid":obj.attr("taskid"),"status":status}, 
			    dataType:"json",
			    success:function(data){
			    	if(data.status==0){
			    		if(status==1){//标记进行
			    			obj.html("标记完成");
			    			obj.attr("status",1);
			    		}else if(status==2){//标记完成
			    			obj.html("标记进行");
			    			obj.attr("status",2);
			    		}else if(status==4){//删除
			    			$("#listItem"+obj.attr("taskid")).remove();
			    		}
			    		//$("#operate_"+obj.attr("taskid")).animate({right:"-280px"},300).attr("ifShow",1);
			    	}else{
			    		alert(data.msg);
			    	}
			    },
			    complete: function(data){
			    	hideLoading();
				}
		    });
		}
		
		function createTask(itemType){//创建任务跳转
			showLoading();
			location.href="/mobile/plugin/task/taskAdd.jsp?sorttype="+LIST_TYPE+"&datetype="+itemType+"&"+param;
		}
		
		function getTaskList(){//查询任务数据
			if(LIST_TYPE!=1){
				for(var i=0;i<5;i++){
					getData(i,0);
				}
			}else{
				$(".listItemTypeDiv").hide();
				getData(0,0);
			}
			$("#floattitle").hide();
			changeStatusShow();//切换是否显示状态选择
		}
		
		function getData(itemType,pageNum){//加载任务列表具体处理方法
			$("#itemType"+itemType).show().showLoading();
			pageNum = parseInt(pageNum)+1;
			$.ajax({
				url:"/mobile/plugin/task/getTaskList.jsp",
				data:{"pageNum":pageNum,"menuType":MENU_TYPE,"listType":LIST_TYPE,
				"itemType":itemType,"status":STATUS,"SELTAG":SELTAG,"viewId":viewId,"hrmid":HRMID},
				type:"post",
				success:function(data){
					if(pageNum==1)
						$("#itemType"+itemType).html(data);
					else
						$("#itemContent"+itemType).append(data);
					var pageNumStr = "pageNum_"+LIST_TYPE+"_"+MENU_TYPE+"_"+itemType;
					var totalPageStr = "totalPage_"+LIST_TYPE+"_"+MENU_TYPE+"_"+itemType;
					var showMoreStr = "showMoreTask_"+LIST_TYPE+"_"+MENU_TYPE+"_"+itemType;
					var totalPage = $("#"+totalPageStr).val();
					if(totalPage<=pageNum){
						$("#"+showMoreStr).hide();
					}
					$("#"+pageNumStr).val(pageNum);
					if(pageNum==1&&itemType==0)
						viewId = $("#viewId").val();
				},
				error:function(data){
					$("#list").html("<div class='taskTips'>列表加载失败,请稍后再试</div>");
				},
				complete:function(){
					$("#itemType"+itemType).hideLoading();
				}
			});
		}
		
		function changeStatusShow(){//显示和隐藏状态选项
			if(LIST_TYPE==5){
				$("#tsTd1").css("width","0").hide();
			}else{
				$("#tsTd1").css("width","82").show();
			}
		}
		
		var startX = 0,startY = 0;
		function swipestart(e,taskid){
			//$("#listItem"+taskid).append("start");
		}
		
		function swipe(e,taskid){
			if(e.type=="swipeleft"){
				$(".operatediv").each(function(){//向左滑动隐藏原来的
					if($(this).attr("ifShow")==2&&$(this).attr("_taskid")!=taskid){
						$(this).animate({right:"-280px"},300).attr("ifShow",1);
						return false;
					}
				});
				if($("#operate_"+taskid).attr("ifShow")==1){
					$("#operate_"+taskid).animate({right:"0px"},300).attr("ifShow",2);
				}
			}else if(e.type=="swiperight"){
				$(".operatediv").animate({right:"-280px"},300).attr("ifShow",1);
			}
		}
	
		function getLeftButton(){ 
			return "1,<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>";
		}
		function getRightButton(){ 
			return "1,筛选";
		}
		function doRightButton(){
			$("#taskMenu").toggle();
			return "1";
		}
		function doLeftButton(){
			if(HRMID!=0)
				location.href="/mobile/plugin/task/subList.jsp?"+param;
			else	
				window.location = "/home.do";
			return "1";
		}
		$(document).bind("click",function(e){
			var target=$.event.fix(e).target;
			if($(target).attr("id")!="rightBtn"){
				$("#taskMenu").hide();
			}
			if($(target).attr("id")!="statusShow"){
				$("#statusSel").hide();
			}
			if($(target).attr("id")!="listType"&&$(target).attr("id")!="target"){
				$("#listType").hide();
				$("#target").removeClass("dragClick").show();
			}
		});
		//绑定右侧菜单
		function getMenus(){
			var menuStr='['+
	        '{"title":"我的任务","url":"/mobile/plugin/task/taskMain.jsp?MENUTYPE=1","target":"_self","icon":"/mobile/plugin/task/images/myTask.png"},';
	        <%if(hassub){ %>
	        	menuStr += '{"title":"下属任务","url":"/mobile/plugin/task/subList.jsp","target":"_self","icon":"/mobile/plugin/task/images/myFinish.png"},'
	        <%}%>
	        menuStr+='{"title":"我负责的","url":"/mobile/plugin/task/taskMain.jsp?MENUTYPE=3","target":"_self","icon":"/mobile/plugin/task/images/myDuty.png"},'+
	        '{"title":"我参与的","url":"/mobile/plugin/task/taskMain.jsp?MENUTYPE=4","target":"_self","icon":"/mobile/plugin/task/images/myPartn.png"},'+
	        '{"title":"我关注的","url":"/mobile/plugin/task/taskMain.jsp?MENUTYPE=6","target":"_self","icon":"/mobile/plugin/task/images/myFav.png"},'+
	        '{"title":"我创建的","url":"/mobile/plugin/task/taskMain.jsp?MENUTYPE=2","target":"_self","icon":"/mobile/plugin/task/images/myCreate.png"},'+
	        '{"title":"我分配的","url":"/mobile/plugin/task/taskMain.jsp?MENUTYPE=8","target":"_self","icon":"/mobile/plugin/task/images/myAssign.png"},'+
	        '{"title":"分享给我的","url":"/mobile/plugin/task/taskMain.jsp?MENUTYPE=5","target":"_self","icon":"/mobile/plugin/task/images/myShare.png"},'+
	        '{"title":"所有任务","url":"/mobile/plugin/task/taskMain.jsp?MENUTYPE=0","target":"_self","icon":"/mobile/plugin/task/images/myAll.png"},'+
	        '{"title":"已完成新反馈","url":"/mobile/plugin/task/taskMain.jsp?MENUTYPE=7","target":"_self","icon":"/mobile/plugin/task/images/myFinish.png"}'+
	        ']';
			return menuStr;               
		}
	</script>
</body>
</html>