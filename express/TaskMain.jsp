
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="weaver.general.TimeUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="UsrTemplate" class="weaver.systeminfo.template.UserTemplate" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%
	SimpleDateFormat dateFormat=new SimpleDateFormat("yyyy-MM-dd");
	Cookie cookies[]=request.getCookies();
	String viewWidth="0";
	String detailWidth="0";
	for(int i=0;i<cookies.length;i++){
		if(cookies[i].getName().equals("task_viewWidth")){
			viewWidth=cookies[i].getValue();
			if(!detailWidth.equals("0")) break;
		}else if(cookies[i].getName().equals("task_detailWidth")){
			detailWidth=cookies[i].getValue();
			if(!viewWidth.equals("0")) break;
		}
	}
	viewWidth=viewWidth.equals("0")?"450":viewWidth;
	detailWidth=detailWidth.equals("0")?"711":detailWidth;
	
	String todaydate=TimeUtil.getCurrentDateString();    //今天日期
	String tomorrowdate=TimeUtil.dateAdd(todaydate,1);   //明天日期
	String afterTomorrowdate=TimeUtil.dateAdd(todaydate,2);   //明天日期
	
    String viewType=Util.null2String(request.getParameter("viewType"));//查看类型
    viewType=viewType.equals("")?"aff":viewType;
    String hrmid=Util.null2String(request.getParameter("hrmid"));//被查看人id
    String mainlineid=Util.null2String(request.getParameter("mainlineid"));//被查看主线id
    String labelid=Util.null2String(request.getParameter("labelid"));//被查看标签id
    String keyword=Util.null2String(request.getParameter("keyword"));//查询关键字
    String operator=Util.null2String(request.getParameter("operator"));//查询关键字
    String userid=user.getUID()+"";
    hrmid=hrmid.equals("")?userid:hrmid;
    String hrmName=resourceComInfo.getLastname(hrmid);
    String labelName = "";
    
    String detailsrc="viewUpdate.jsp";
    if(viewType.equals("viewhrm")){
       detailsrc="/blog/viewBlog.jsp?from=express&blogid="+hrmid;
    }else if(viewType.equals("mainline")){
       rs.executeSql("select * from Task_mainline where id =" + mainlineid);
       while(rs.next()){
       	labelName = rs.getString("name");
    	}
       detailsrc="DetailMainline.jsp?mainlineid="+mainlineid+"&operator="+operator;
    }else if(viewType.equals("label")){
       rs.executeSql("select * from task_label where id =" + labelid);
        while(rs.next()){
       	labelName = rs.getString("name");
    	}
       detailsrc="DetailLabel.jsp?labelid="+labelid+"&operator="+operator;   
   }else if(viewType.equals("workcenter")){
	   if(operator.equals("remind")){
		   detailsrc="ViewRemind.jsp";
	   }else if(operator.equals("msg")){
		   detailsrc="ViewMsg.jsp";
	   }
   }else if(viewType.equals("mainlineset") || viewType.equals("labelset")){
	   detailsrc="";
   }
   //读取主线id
   String mainID = Util.null2String(request.getParameter("mainLineId"));
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<link rel="stylesheet" href="/express/css/base_wev8.css" />
		<script language="javascript" src="/js/jquery/jquery_wev8.js"></script>
		<script src="/express/js/util_wev8.js"></script>
		<script src="/express/js/task_wev8.js"></script>
		
		<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDialog_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology7/jquery/js/zDrag_wev8.js"></script>
		
		<style type="text/css">
			html,body{-webkit-text-size-adjust:none;margin: 0px;overflow: hidden;}
			*{font-size: 12px;font-family: Arial,'微软雅黑';outline:none;}
			
			 tr.header td{height: 23px;text-align: center;vertical-align: middle;}
			.datalist{width:100%;table-layout: fixed;}
			.datalist td{empty-cells:show;height: 28px;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;
				padding-left: 0px;background-color: #fff;border-bottom: 1px #EFEFEF solid;border-top: 1px #ffffff solid;}
			.datalist tr{cursor: pointer;}
			.datalist tr.tr_blank{height: 0px !important;}
			.datalist tr.tr_blank td{height: 0px !important;border-width: 0px !important;}
			
			.scroll1{overflow-y: auto;overflow-x: hidden;
				SCROLLBAR-DARKSHADOW-COLOR: #ffffff;
			  	SCROLLBAR-ARROW-COLOR: #EAEAEA;
			  	SCROLLBAR-3DLIGHT-COLOR: #EAEAEA;
			  	SCROLLBAR-SHADOW-COLOR: #E0E0E0 ;
			  	SCROLLBAR-HIGHLIGHT-COLOR: #ffffff;
			  	SCROLLBAR-FACE-COLOR: #ffffff;}
			
			.disinput{border: 0px;background: none;height:28px;line-height:28px;cursor: pointer;}
			.addinput{color: #C0C0C0;font-style: italic;}
			.drop_list{position: absolute;width: 100px;text-align:left;z-index: 999;top: 83px;left: 803px;
						background: #fff;border: 1px #CACACA solid;display: none;
						border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;
						box-shadow:0px 0px 3px #CACACA;-moz-box-shadow:0px 0px 3px #CACACA;-webkit-box-shadow:0px 0px 3px #CACACA;
    					behavior:url(/express/css/PIE2.htc);}
			::-webkit-scrollbar-track-piece{
				background-color:#E2E2E2;
				-webkit-border-radius:0;
			}
			::-webkit-scrollbar{
				width:12px;
				height:8px;
			}
			::-webkit-scrollbar-thumb{
				height:50px;
				background-color:#CDCDCD;
				-webkit-border-radius:1px;
				outline:0px solid #fff;
				outline-offset:-2px;
				border: 0px solid #fff;
			}
			::-webkit-scrollbar-thumb:hover{
				height:50px;
				background-color:#BEBEBE;
				-webkit-border-radius:1px;
			}
		    
		    input[type="checkbox"]{width:11px; height: 11px;}
		    .labelstr{empty-cells:show;word-break: keep-all;white-space: nowrap;overflow: hidden;text-overflow:ellipsis;color: #999999;width:60px;}
		    
		    .loading{position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background: url(/express/task/images/bg_ahp_wev8.png) repeat;display: none;}
		    .loading div{position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background:url(/express/task/images/loading1_wev8.gif) center no-repeat}
		</style>
		<!--[if IE]> 
		<style type="text/css">
			.disinput{line-height: 28px !important;height: 28px !important;}
			.input_inner{line-height: 26px !important;}
		</style>
		<![endif]-->
	</head>
	<body>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<div id="taskmain">
			<input type="hidden" id="userid" value='<%=userid %>'/>
			<input type="hidden" id="hrmid" value='<%=hrmid %> '/>
			<input type="hidden" id="viewType" value='<%=viewType %>' />
			<!-- 中心视图 -->
			<div id="view" style="width:<%=viewWidth%>px;">
					<div id="listtitle">
					  <%
					  //查看主线
					  if(viewType.equals("mainline")) {%>
					     <span style="margin-left: 15px;"><span style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(30882,user.getLanguage())%>：</span><span id="main_name"><%=labelName%></span></span><!-- 主线 -->
					  <%}else if(viewType.equals("label")) {%>
					     <span style="margin-left: 15px;"><span style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(176,user.getLanguage())%>：</span><span id="label_name"><%=labelName%></span></span><!-- 标签 -->
					  <%}else if(viewType.equals("search")){%>
					     <span style="margin-left: 15px;"><span style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>：</span>"<%=keyword%>"</span><!-- 搜索 -->
					  <%}else if(viewType.equals("mainlineset")){%>
					     <span style="margin-left: 15px;"><span style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(30883,user.getLanguage())%></span></span><!-- 主线设置 -->
					  <%}else if(viewType.equals("labelset")){%>
					     <span style="margin-left: 15px;"><span style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(30884,user.getLanguage())%></span></span><!-- 标签设置 -->
					   <%}else{ %>
						<div id="micon">
						     <img src="<%=resourceComInfo.getMessagerUrls(hrmid)%>" width="25px"/>
						</div>
						<div id="mtitle">
							<%
							   String title=resourceComInfo.getLastname(hrmid);
							   if(viewType.equals("workcenter")||viewType.equals("viewhrm"))
								   title+="的工作中心";
							   else if(viewType.equals("attTask"))
								   title+="关注的事";
							   else if(viewType.equals("attFeedback"))
								   title+="所有关注的反馈";
							   else if(viewType.equals("allFeedback"))
								   title+="所有反馈的事";
							%>
						    <span id="viewTitle"><%=title%></span>
						    <span id="mdept"><%=departmentComInfo.getDepartmentname(resourceComInfo.getDepartmentID(hrmid))%></span>
						</div>
						<div id="reminddiv" style="width:100px;position: absolute;right:95px;top: 8px;cursor: pointer;color: red;background: yellow;display: none;padding:3px;"></div>
					    <div id="timeview">
					         <div class="btn_operate" style="width: 60px;display:<%=viewType.equals("workcenter")||viewType.equals("viewhrm")?"":"none"%>" id="timeView" onclick="showTimeView()"><%=SystemEnv.getHtmlLabelName(30885,user.getLanguage())%></div><!-- 时间视图 -->
					    </div>
					  <%} %>  
					</div>
					<div id="listoperate">
						<%if(!viewType.equals("mainlineset")&&!viewType.equals("labelset")){%>
						<div id="changesort" class="main_btn menuitem1" style="width:70px;">
							<span style="padding-left:17px;">
						       <input id="choseAll" type="checkbox"/><%=SystemEnv.getHtmlLabelName(556,user.getLanguage())%><!-- 全选 -->
						    </span>
						</div>
						<div id="changestatus" _moduleType="aff" class="main_btn menuitem1" onclick="showMenu(this,'statusbtn',event)">
							<span id="taskType"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span><!-- 全部 -->
							<img class="marrow" src="/express/images/express_maintask_pull_wev8.png"/>
						</div>
						
						<div id="filter" class="main_btn menuitem1" style="display:none;" onclick="showFiterSort(this,event)">
							<span id="changeFilter1"><%=SystemEnv.getHtmlLabelName(30886,user.getLanguage())%></span><!-- 过滤 -->
							<img class="marrow" src="/express/images/express_maintask_pull_wev8.png"/>
						</div>
					
					    <div id="doOperate" class="main_btn menuitem2" onclick="showMenu(this,'operate',event)">
							<span id="changeOperate"><%=SystemEnv.getHtmlLabelName(104,user.getLanguage())%></span><!-- 操作 -->
							<img class="marrow" src="/express/images/express_maintask_pull_wev8.png"/>
						</div>
					
						<div id="create" class="main_btn menuitem2" onclick="showMenu(this,'newCreate',event)">
							<span id="changeNew"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></span> <!-- 新建 -->
							<img class="marrow" src="/express/images/express_maintask_pull_wev8.png"/>
						</div>
						<%}else{%>
						    <div id="addOperate" class="main_btn menuitem2" onclick="">
						        <span style="font-weight: bold;font-size: 14px;">+</span>
								<span id="changeOperate"><%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%></span><!-- 新建 -->
						</div>
						<%}%> 
					</div>
					<div id="statusbtn" class="drop_list" style="width:78px; height: 180px; ">
						<div>
						    <div id="module_aff" class="btn_add_type choose_type" onclick="doChangeStatus(this,'aff')" _type="aff"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></div><!-- 全部 -->
						    <div id="module_task" class="btn_add_type" onclick="doChangeStatus(this,'task')" _type="task"><%=SystemEnv.getHtmlLabelName(1332,user.getLanguage())%></div><!-- 任务 -->
							<div id="module_wf" class="btn_add_type" onclick="doChangeStatus(this,'wf')" _type="wf"><%=SystemEnv.getHtmlLabelName(18015,user.getLanguage())%></div><!-- 流程 -->
							<div id="module_meeting" class="btn_add_type" onclick="doChangeStatus(this,'meeting')" _type="meeting"><%=SystemEnv.getHtmlLabelName(2103,user.getLanguage())%></div><!-- 会议 -->
							<div id="module_doc" class="btn_add_type" onclick="doChangeStatus(this,'doc')" _type="doc"><%=SystemEnv.getHtmlLabelName(58,user.getLanguage())%></div><!-- 文档 -->
							<div id="module_cowork" class="btn_add_type" onclick="doChangeStatus(this,'cowork')" _type="cowork"><%=SystemEnv.getHtmlLabelName(17855,user.getLanguage())%></div><!-- 协作 -->
							<div id="module_email" class="btn_add_type" onclick="doChangeStatus(this,'email')" _type="email"><%=SystemEnv.getHtmlLabelName(71,user.getLanguage())%></div><!-- 邮件 -->
						</div>
					</div>
					<img style="display: none;"/>
					<div id="wfFilter"  class="drop_list filterdiv">
    					<div>
    					    <div class="btn_add_type <%=viewType.equals("attTask")||viewType.equals("attFeedback")?"choose_type":"" %>" onclick="doFilter(this)" _type="1"><%=SystemEnv.getHtmlLabelName(30887,user.getLanguage())%></div><!-- 全部事宜 -->
    						<div class="btn_add_type <%=viewType.equals("attTask")||viewType.equals("attFeedback")?"":"choose_type" %>" onclick="doFilter(this)" _type="0"><%=SystemEnv.getHtmlLabelName(30888,user.getLanguage())%></div><!-- 代办事宜 -->
							<div class="btn_add_type" onclick="doFilter(this)" _type="2"><%=SystemEnv.getHtmlLabelName(17991,user.getLanguage())%></div><!-- 已办事宜 -->
							<div class="btn_add_type" onclick="doFilter(this)" _type="3"><%=SystemEnv.getHtmlLabelName(17992,user.getLanguage())%></div><!-- 办结事宜 -->
						</div>
					</div>
					
					<div id="taskFilter" class="drop_list filterdiv">
    					<div>
    						<div style="" class="btn_add_type <%=viewType.equals("attTask")||viewType.equals("attFeedback")?"choose_type":"" %>" onclick="doFilter(this)" _type="1"><%=SystemEnv.getHtmlLabelName(30889,user.getLanguage())%></div><!-- 全部任务 -->
							<div class="btn_add_type <%=viewType.equals("attTask")||viewType.equals("attFeedback")?"":"choose_type" %>" onclick="doFilter(this)" _type="0"><%=SystemEnv.getHtmlLabelName(30890,user.getLanguage())%></div><!-- 参与的任务 -->
							<div class="btn_add_type" onclick="doFilter(this)" _type="2"><%=SystemEnv.getHtmlLabelName(30891,user.getLanguage())%></div><!-- 负责的任务 -->
							<div class="btn_add_type" onclick="doFilter(this)" _type="3"><%=SystemEnv.getHtmlLabelName(30892,user.getLanguage())%></div><!-- 创建的任务 -->
							<div class="btn_add_type" onclick="doFilter(this)" _type="4"><%=SystemEnv.getHtmlLabelName(30893,user.getLanguage())%></div><!-- 分享的任务 -->
							<div class="btn_add_type" onclick="doFilter(this)" _type="5"><%=SystemEnv.getHtmlLabelName(15289,user.getLanguage())%></div><!-- 已完成任务 -->
							<div class="btn_add_type" onclick="doFilter(this)" _type="6"><%=SystemEnv.getHtmlLabelName(30894,user.getLanguage())%></div><!-- 已撤销任务 -->
						</div>
					</div>
					
					<div id="coworkFilter" class="drop_list filterdiv">
    					<div>
    						<div class="btn_add_type choose_type" onclick="doFilter(this)" _type="0"><%=SystemEnv.getHtmlLabelName(30895,user.getLanguage())%></div><!-- 参与的协作 -->
							<div class="btn_add_type" onclick="doFilter(this)" _type="2"><%=SystemEnv.getHtmlLabelName(30896,user.getLanguage())%></div><!-- 未读的协作 -->
							<div class="btn_add_type" onclick="doFilter(this)" _type="3"><%=SystemEnv.getHtmlLabelName(30897,user.getLanguage())%></div><!-- 隐藏的协作 -->
						</div>
					</div>
					
					<div id="docFilter" class="drop_list filterdiv">
    					<div>
    						<div class="btn_add_type" onclick="doFilter(this)" _type="1"><%=SystemEnv.getHtmlLabelName(30897,user.getLanguage())%></div><!-- 全部文档 -->
    						<div class="btn_add_type choose_type" onclick="doFilter(this)" _type="0"><%=SystemEnv.getHtmlLabelName(1212,user.getLanguage())%></div><!-- 我的文档 -->
						</div>
					</div>
					
					<div id="newCreate"  class="drop_list" style="height: 150px;">
						<div class="btn_add_type" onclick="addTask(1)"  ><%=SystemEnv.getHtmlLabelName(15266,user.getLanguage())%></div><!-- 新建任务 -->
						<div class="btn_add_type"  onclick="addTask(2)" ><%=SystemEnv.getHtmlLabelName(16392,user.getLanguage())%></div><!-- 新建流程 -->
						<div class="btn_add_type"  onclick="addTask(3)" ><%=SystemEnv.getHtmlLabelName(27411,user.getLanguage())%></div><!-- 新建协作 -->
						<div class="btn_add_type"  onclick="addTask(4)"><%=SystemEnv.getHtmlLabelName(2029,user.getLanguage())%></div><!-- 新建邮件 -->
						<div class="btn_add_type" onclick="addTask(5)" ><%=SystemEnv.getHtmlLabelName(30899,user.getLanguage())%></div><!-- 上传文档 -->
						<div class="btn_add_type" onclick="addTask(6)" ><%=SystemEnv.getHtmlLabelName(15008,user.getLanguage())%></div><!-- 新建会议 -->
					</div>
					
					<div id="operate"  class="drop_list">
						<div class="btn_add_type"  onclick="remindTask()"><%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%></div><!-- 提醒 -->
						<div class="btn_add_type"  onclick="attTask()"><%=SystemEnv.getHtmlLabelName(25436,user.getLanguage())%></div><!-- 关注 -->
					</div>
					
					<div id="listview">
						<!-- 数据列表 -->
						<div id="list" class="scroll1">
                        </div>
                        <div id="loading1" class="loading" align='center'>
						   <div></div>
						</div>
                    </div>			
					
			</div>
			
			<div id="dragdiv" style="left:<%=(Integer.parseInt(viewWidth)-3)%>" title="<%=SystemEnv.getHtmlLabelName(30900,user.getLanguage())%>"></div><!-- 按下鼠标拖动改变宽度 -->
			
			<!-- 明细视图 -->
			<div id="detail" style="width:<%=detailWidth%>px;">
				<div id="detaildiv">
				     <iframe style="height: 100%;width: 100%;" scrolling="yes" frameborder="0" id="detailFrame" name="detailFrame" src="<%=detailsrc%>" ></iframe>
				</div>
				<div id="loading2" class="loading" align='center'>
				   <div></div>
				</div>
			</div>
		</div>
		<input type="hidden" id="userid" value="<%=userid %>" />
		<input type="viewType" id="viewType" value="<%=viewType %>" />
		<script type="text/javascript">
			
			var loadstr = "<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background: url(/express/task/images/bg_ahp_wev8.png) repeat;' align='center'>"
					+"<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background:url(/express/task/images/loading1_wev8.gif) center no-repeat'></div></div>";

			var datatype = 0;//数据类型 默认时间安排
            var foucsobj = null;  //选择的列
            
            var viewType="<%=viewType%>";
            var mainlineid="<%=mainlineid%>";
            var labelid="<%=labelid%>";
            var hrmid="<%=hrmid%>";
            var keyword="<%=keyword%>";
            
            
            var viewTypeSel=0;//当前选择模块
			//初始事件绑定
			$(document).ready(function(e){
			
				$("div.btn_add_type").bind("mouseover",function(){
					$("div.btn_add_type").removeClass("btn_add_type_over");
					$(this).addClass("btn_add_type_over");
				}).bind("mouseout",function(){
					$(this).removeClass("btn_add_type_over");
				});

				$("div.main_btn").bind("mouseover",function(){
					$(this).css("color","#004080");
				}).bind("mouseout",function(){
					$(this).css("color","#786571");
				});
				//新建任务或者标签
				$("#addOperate").bind("click",function(e){
					var obj = $(".disinput").last();
					if($(obj).attr("value") == "" || $(obj).attr("value") == "新建主线" || $(obj).attr("value") == "新建标签"){
						$(obj).attr("value","");
						foucsobj = $(obj);
						$("tr.item_tr").removeClass("tr_select tr_blur");
						$(".disinput").last().parent().parent().addClass("tr_select");
						$(obj).focus();
					}else{
					$(".disinput").attr("id","");
					if(viewType == "mainlineset"){
						var newtr = $("<tr class='item_tr'>"+
									"<td width='23px' class='td_move'><div>&nbsp;</div></td>"+
									"<td width='18px'></td>"+
									"<td width='18px'></td>"+
									"<td width='18px'></td>"+
									"<td class='item_td'><input   _itemType='mainline' class='disinput  definput' type='text' name=''  title=''  value=''/></td>"+
									"<td width='60px' class='item_count'></td>"+
									"<td width='45px'></td>"+
									"<td width='40px' class='item_hrm' title=''></td>"+"</tr>");
						}else{
							var newtr = $("<tr class='item_tr'>"+
								"<td width='23px' class='td_move'><div>&nbsp;</div></td>"+
								"<td width='18px'></td>"+
								"<td width='18px'></td>"+
								"<td width='18px'></td>"+
								"<td class='item_td'><input    _itemType='label' class='disinput  definput' type='text' name=''  title=''  value=''/></td>"+
								"<td width='60px' class='item_count'></td>"+
								"<td width='45px'></td>"+
								"<td width='40px' class='item_hrm' title=''></td>"+"</tr>");
							}
						$("tr.item_tr").removeClass("tr_select tr_blur");
						$(".disinput").last().parent().parent().after(newtr);
						foucsobj = $(".disinput").last();
						$(".disinput").last().parent().parent().addClass("tr_select");
						$(".disinput").last().attr("value","").focus();
					}
					stopBubble(e);
				});
				//阻止重复新建任务或者标签
				$(".item_tr").live("click",function(){
					$(".item_tr").each(function(){
						$(this).attr("id","");
					});	
					$(this).attr("id","select_tr");
				});
				
				//$("div.leftmenu")[0].click();
				datatype ="0";
				loadList(); //加载数据
				
				setPosition();

				//列表页中事件绑定
				$("tr.item_tr").live("mouseover",function(){
					$(this).addClass("tr_hover");
				}).live("mouseout",function(){
					$(this).removeClass("tr_hover");
				}).live("click",function(e){
					var target=$.event.fix(e).target;
					if(!$(target).hasClass("status") && !$(target).hasClass("item_att") && !$(target).parent().hasClass("item_hrm")){
						$("tr.item_tr").removeClass("tr_select tr_blur");
						$(this).addClass("tr_select");
						doClickItem($(this).find(".disinput"));
					}
				});

				$("div.disinput").live("keyup",function(event) {
					var keyCode = event.keyCode;
					if (keyCode == 40) {//向下
						moveUpOrDown(1,$(this));
					} else if (keyCode == 38) {//向上
						moveUpOrDown(2,$(this));
					} 
				});

				//添加、取消标记
				$(".item_att").live("click",function(event) {
					var attobj = $(this);
					var itemtr=jQuery(this).parents("tr:first");
					var taskId = itemtr.attr("_taskid");
					var taskType = itemtr.attr("_tasktype");
					var creater = itemtr.attr("_creater");
					var _special = $(this).attr("_special");
					var userid = $("#userid").attr("value");
					if(_special==0){
				    	attobj.removeClass("item_att0").addClass("item_att1").attr("_special",1).attr("title","取消关注");
				    	addAttention(taskId,taskType,_special,creater);
					}else{
						attobj.removeClass("item_att1").addClass("item_att0").attr("_special",0).attr("title","标记关注");
				    	addAttention(taskId,taskType,_special,creater);
					}
					//卡片上关注
					var attentionBtn=$("#detailFrame").contents().find("#attention");
				    if(attentionBtn.length>0){
				        if(_special==0)
				          document.getElementById('detailFrame').contentWindow.changeAttention(1,taskId,taskType);
				    	else{
				          document.getElementById('detailFrame').contentWindow.changeAttention(0,taskId,taskType);
				         }
				    }
				});
                
                //标记任务日期
                $(".div_date").live("click",function(event) {
					markDate(this);
					return false; //阻止冒泡事件
				});
				
				//全选/全不选
				$("#choseAll").bind("click",function(){
					$('[name = check_items]:checkbox').attr("checked",this.checked);
					if(this.checked){
					   $('[name = check_items]:checkbox').addClass("check_input_show").removeClass("check_input");
					}else{
					   $('[name = check_items]:checkbox').addClass("check_input").removeClass("check_input_show");
					}
				});
				
				//主复选框与子复选框联动
				$('[name=check_items]:checkbox').live("click",function(){
					var flag = true;
					$('[name=check_items]:checkbox').each(function(){
						if(!this.checked){
							flag = false;
						}
					});
					$("#choseAll").attr('checked',flag);
					
					//return false; //阻止冒泡事件
				});
				$(".tag_input").bind("click",function(e){
					stopBubble(e);
				});
				
					
				});

			var resizeTimer = null;  
			$(window).resize(function(){
				//if(resizeTimer) clearTimeout(resizeTimer);  
				//resizeTimer = setTimeout("setPosition()",100);  
				setPosition();
			});

			//隐藏下拉菜单
			$(document).bind("click",function(e){
			    $(".drop_list").hide();
			});
			//修改任务标题同步
			$(".disinput").live("keyup",function(){
				var newName = $(this).html();
				var taskid = $(this).attr("id");
				$(this).attr("title",newName)
				document.getElementById('detailFrame').contentWindow.changeDetailName(newName,taskid);
			});
			
			//切换状态
			function doChangeStatus(obj,moduleType){
				var typeName =jQuery(obj).text();
				
			    jQuery("#taskType").html(typeName);
				jQuery("#statusbtn").find(".choose_type").removeClass("choose_type");
				jQuery(obj).addClass("choose_type");
				jQuery("#changestatus").attr("_moduleType",moduleType);
				if(moduleType=="wf"||moduleType=="cowork"||moduleType=="task"||moduleType=="doc")
				   $("#filter").show();
				else
				   $("#filter").hide();   
				loadList(moduleType);
			}
			
			function showMenu(obj,target,e){
				$(".drop_list").hide();
				
				$("#"+target).css({
					"left":$(obj).position().left+"px",
					"top":"67px"
				}).show();
				
				stopBubble(e);
			}
			
			//新建按钮单击事件
			function addTask(taskType){
				//$("#detaildiv").append(loadstr).load("TaskView.jsp?operation=new&taskType="+taskType);
				if(taskType==1){
					foucsobj=$("#datalist0 .item_tr:first").find(".disinput");
					addItem(0,1,1);
				}else if(taskType==5){
					showDocUploadbox();
				}else{
					beforeLoading();
					$("#detailFrame").attr("src","TaskView.jsp?operation=new&taskType="+taskType);
					afterLoading();//iframe加载完成后隐藏loading
				}
			}
			
			//显示过滤下拉菜单
			function showFiterSort(obj,e){
			    var moduleType=$("#changestatus").attr("_moduleType");
				showMenu(obj,moduleType+"Filter",e);
			}
			
			//选择过滤条件
			function doFilter(obj){
			   $(obj).parent().find(".choose_type").removeClass("choose_type");
			   $(obj).addClass("choose_type");
			   var filterType=$(obj).attr("_type");
			   var moduleType=$("#statusbtn").find(".choose_type").attr("_type");
			   loadList(moduleType,filterType);
			}
			
			//重置过滤项参数
			function resetFilter(){
			   $(".filterdiv").each(function(){
			      $this=$(this);
			      $this.find(".choose_type").removeClass("choose_type");
			      $this.find("div[_type='0']").addClass("choose_type");
			   });
			}
			
			//不刷新整个页面，直接显示中间列表
			function showView(userName,_viewType,_hrmid,_keyword){
			
				viewType=_viewType;
				hrmid=_hrmid;
				keyword=_keyword;
				
				resetFilter(); //重置原视图中过滤项
				
				var title=userName;
				if(viewType=="workcenter"||viewType=="viewhrm"){
					title+="的工作中心";
				}else if(viewType=="attTask"){
				   title+="关注的事";
			   	}else if(viewType=="attFeedback"){
				   title+="所有关注的反馈";
			   	}else if(viewType=="allFeedback"){
				   title+="所有反馈的事";
				}else if(viewType=="search"){
				   title="搜索<span>\""+keyword+"\"</span>";
				}
				
				//修改标题   
				$("#viewTitle").html(title);
			    if(viewType=="workcenter"||viewType=="viewhrm")
			    	$("#timeView").show();
			    else
			    	$("#timeView").hide();	
			    
				doChangeStatus($("#statusbtn div[_type='aff']")[0],'aff');	
			}
			
			//加载列表部分
			function loadList(moduleType,filterType,dateType){
			
			    moduleType=moduleType||"aff";
			    if(viewType=="workcenter"||viewType=="viewhrm")
			       filterType=filterType||"0"; //参与的
			    else
			       filterType=filterType||"1"; //全部
			       
			    if(moduleType=="aff"&&dateType==0) resetFilter();  //当选择的是全部是重置 过滤项
			       
			    dateType=dateType||"0";        // 0 表示今天事务 1表示明天事务 2 表示将要进行
				var url="ListView.jsp?viewType="+viewType+"&moduleType="+moduleType+"&mainlineid="+mainlineid+"&labelid="+labelid+"&hrmid="+hrmid+"&keyword="+keyword+"&filterType="+filterType+"&dateType="+dateType;
				//alert(url);
				if(viewType=="mainlineset") //主线设置
				    url="MainlineList.jsp?viewType="+viewType;
				else if(viewType=="labelset") 
				    url="MainlineList.jsp?viewType="+viewType;  
				
				$("#loading1").show();
				$.ajax({
					type: "post",
				    url: url,
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){ 
				        
				        if(dateType==0){
				    	   $("#list").html(getListTitle(moduleType,filterType));
				    	   //加载明天 将要
				    	   $("#sorttitle1").click();
				    	   $("#sorttitle2").click();
				    	}   
				    	$("#datalist"+dateType+" tbody").append(data.responseText);
				    	$("#sorttitle"+dateType).attr("_isload",1).css("color","#000").find("img").hide();
				    	setItemWidth(dateType);
				    	setIndex();
				    	//scrollLoad(); 滚动加载
				    	if(viewType=="mainlineset"||viewType=="labelset"){
				    	   $("#datalist0").find(".item_tr:first").click();
				    	}
				    	$("#loading1").hide();
					}
			     });
			}
			
			function setAllItemWidth(){
				setItemWidth(0);
				setItemWidth(1);
				setItemWidth(2);
			}
			
			function setItemWidth(dateType){
			
				$("#datalist"+dateType+" div.itemTitleDiv").each(function(i,n){
		    		var $this=$(this);
		    		var width=$this.width()+1;
		    		var tdWidth=$this.parent("td").width();
		    		var _width=parseFloat($this.attr("_width"));
		    		var tasktype=$this.attr("_tasktype");
		    		
		    		if(_width)
		    			width=_width;
		    		else
		    			$this.attr("_width",width);
		    		
		    		if($this.hasClass("newinput")||$this.hasClass("fbinput")){
		    			
		    			if(tasktype=="1"){
		    				var contenteditable=$this.attr("contenteditable");
		    				if(contenteditable=="true") //任务处于可编辑状态时不需要省略
		    					$this.css("text-overflow","clip");
		    			}
		    			
		    			
		    			
		    			var img=$this.parent("td").find("img");
			    		if(width+30>tdWidth) {
			    			$this.width(tdWidth-30);
			    			if(img.length==0&&tasktype!="8")
			    				$this.after("<img src='/images/"+($this.hasClass("newinput")?"BDNew_wev8.gif":"BDNew2_wev8.gif")+"' style='position:absolute;top:8px;left:"+(tdWidth-30)+"px;'>");
			    			else{
			    				img.css("left",tdWidth-30);
			    			}	
			    		}else{
			    			if(img.length==0&&tasktype!="8")
			    				$this.after("<img src='/images/"+($this.hasClass("newinput")?"BDNew_wev8.gif":"BDNew2_wev8.gif")+"' style='position:absolute;top:8px;left:"+(width+10)+"px;'>");
			    			else
			    				img.css("left",width+10);
			    			$this.width(width);	
			    		}
		    		}else{
		    			$this.width(tdWidth);
		    		}	
	    		})
			}
			
			function getListTitle(moduleType,filterType){
			
			   var dataType=new Array("今天事务","明天事务","将要进行");
			   var datetitle=new Array("标记时间或开始时间小于等于今天的事务以及今天正在进行或还未进行的会议","标记时间为明天的事务以及开始时间为明天的任务、会议","标记时间为大于后天的事务以及开始时间大于后天的任务、会议");
			   var htmlstr="";
			   if((viewType=="workcenter"||viewType=="viewhrm")&&(moduleType=="aff"||moduleType=="task"||(moduleType=="wf"&&filterType==0)||moduleType=="meeting")){
			       for(var i=0;i<dataType.length;i++){
			          htmlstr+='<div  id="sorttitle'+i+'" _isload="0" _dateType="'+i+'" class="sorttitle" style="color:#0080FF" title="点击收缩" onclick="showList(this)"><div class="sorticon"></div><div class="sorthead" title="'+datetitle[i]+'">'+dataType[i]+'&nbsp;<img style="display:none" src="/images/loading2_wev8.gif" align="absmiddle"></div></div>'
		                      +'<table id="datalist'+i+'" class="datalist" cellpadding="0" cellspacing="0" border="0" _datetype="'+i+'">'
		                      +'<tr class="tr_blank">'
							  +'	<td style="width:23px;"></td>'
							  +'	<td style="width:18px;"></td>'
							  +'	<td style="width:18px;"></td>'
							  +'	<td style="width:18px;"></td>'
							  +'	<td></td>'
							  +'	<td style="width:60px;"></td>'
							  +'	<td style="width:30px;"></td>'
							  +'	<td style="width:40px;"></td>'
							  +'</tr>'
		                      +'</table>';
			       }
			   }else{
			         htmlstr+='<table id="datalist0" class="datalist" cellpadding="0" cellspacing="0" border="0" _datetype="0">'
			                  +'<tr class="tr_blank">'
							  +'	<td style="width:23px;"></td>'
							  +'	<td style="width:18px;"></td>'
							  +'	<td style="width:18px;"></td>'
							  +'	<td style="width:18px;"></td>'
							  +'	<td></td>'
							  +'	<td style="width:60px;"></td>'
							  +'	<td style="width:30px;"></td>'
							  +'	<td style="width:40px;"></td>'
							  +'</tr>'
		                      +'</table>';
			   }
			   return htmlstr;
			}
			
			//替换ajax传递特殊符号
			function filter(str){
				str = str.replace(/\+/g,"%2B");
			    str = str.replace(/\&/g,"%26");
				return str;	
			}
			
			var speed = 200;
			var w1=<%=viewWidth%>;
			var w2;
			//设置各部分内容大小及位置
			function setPosition(){
				var width = $("#taskmain").width();
				w2 = width-w1+1;
				$("#detail").animate({ width:w2 },speed,null,function(){
					
					$("#view").animate({ width:w1 },speed,null,function(){
						//$("#view").animate({ left:196 },speed,null,function(){});
					});
				});
				$("#dragdiv").css("left",w1-3);
				if(!$(parent.document).find("#divmenu").is(":hidden")){
					addCookie("task_detailWidth",w2,365*24*60*60*1000); //添加cookie
					addCookie("task_viewWidth",w1,365*24*60*60*1000);   //添加cookie
				}
				$("#detaildiv").height($("#detail").height());
			}
			
			document.onmousedown=click;
			document.oncontextmenu = new Function("return false;")
			function click(e) {
				if (document.all) {
					if (event.button==2||event.button==3) {
						oncontextmenu='return false';
					}
				}
				if (document.layers) {
					if (e.which == 3) {
						oncontextmenu='return false';
					}
				}
			}
			if (document.layers) {
				document.captureEvents(Event.MOUSEDOWN);
			}

			//显示时间视图
			function showTimeView(){
				$("#mainFrame" ,parent.document).attr("src","/express/calendar/WorkPlanView.jsp?viewType="+viewType+"&hrmid="+hrmid)
			}
			
			//标记任务时间
			function markDate(obj){  
				
			    var itemtr=jQuery(obj).parents("tr:first");
			    var tasktype=itemtr.attr("_tasktype");
			    var taskid=itemtr.attr("_taskid");
			    var isCanMark=jQuery(obj).attr("_isCanMark");
			    var dateType=itemtr.attr("_dateType");
			    
				if(isCanMark=="0"){ //不可以修改标记时间
					if(tasktype=="3") alert("会议不可以修改时间");
					if(tasktype=="1") alert("任务负责人才可以修改时间");
					return ;
			    }
			    //$lang.clearStr="clear";
			    var isShowClear=false;
			    if(tasktype!=1 && tasktype!=2 && tasktype!=3)
			       isShowClear=true;
			        
			    WdatePicker({
				    isShowClear:isShowClear,  //是否显示清空按钮
					isShowOK:false,           //是否显示确定按钮
					//startDate:"2012-10-12", //设置选中日期
					el:$(obj).find("div")[0],
				    onpicked:function(dp){
						var returnvalue = dp.cal.getDateStr();
						if(new Date(returnvalue.replace(/\-/g, "\/"))<new Date("<%=todaydate%>".replace(/\-/g, "\/"))){
						   alert("标记时间不能小于今天(<%=todaydate%>)");
						   return;
						}
						doAjax("TaskOperation.jsp?operation=markdate",{taskid:taskid,tasktype:tasktype,taskdate:returnvalue},function(data){
						     $(obj).addClass("div_date_show");
						     $(obj).attr("title",returnvalue);
						     
						    if(returnvalue=="<%=todaydate%>"){          //移动到今天
						    	if(dateType==0) return ;
						    	if($("#datalist0").children().children().last().hasClass("item_tr")){
						    		 itemtr.appendTo(jQuery("#datalist0"));
						    	}else{
							       jQuery("#datalist0").children().children().last().before(itemtr);
						    	}
							}else if(returnvalue=="<%=tomorrowdate%>"){ //移动到明天
								if(dateType==1) return ;
							   if($.trim($("#datalist1").children().children().last().children().eq(1).html()) == "暂时没有数据"){
							   		$("#datalist1").children().children().last().remove();
							   }
							   if($("#datalist1").find(".td_blank").length>0) //当处于任务模块下，包含新建项时
							   	  $("#datalist1").find(".td_blank").parent().before(itemtr);
							   else	  	
							   	  itemtr.appendTo(jQuery("#datalist1"));
							}else{
								if(dateType==2) return ;
								if($.trim($("#datalist2").children().children().last().children().eq(1).html()) == "暂时没有数据"){
									$("#datalist2").children().children().last().remove();
								}
								//移动到将要
								if($("#datalist2").find(".td_blank").length>0) //当处于任务模块下，包含新建项时
							   	  $("#datalist2").find(".td_blank").parent().before(itemtr);
							    else	  	                                      
							   	  itemtr.appendTo(jQuery("#datalist2"));                                     
							}  
							
							setIndex();//设置序号
						});
						jQuery(obj).html("");
					},oncleared:function(dp){
					    $.post("TaskOperation.jsp?operation=cleardate",{taskid:taskid,tasktype:tasktype},function(){
					        var moduleType=$("#changestatus").attr("_moduleType");
						    if(moduleType!="cowork"&&moduleType!="doc"&&moduleType!="email"){
							    itemtr.fadeOut(1000);
							    itemtr.remove();
							    setIndex();
						    }else
						        $(obj).removeClass("div_date_show").attr("title","未标记时间");
					    });
					}
			  });
			}
			
			 //阻止事件冒泡函数
			 function stopBubble(e)
			 {
			     if (e && e.stopPropagation){
			         e.stopPropagation()
			     }else{
			         window.event.cancelBubble=true
			     }
			}
			//加载消息
			function loadMessage(){
			    $("#detailFrame").attr("src","/express/ViewMsg.jsp");
			}
			//加载提醒
			function loadRemind(){
			    $("#detailFrame").attr("src","/express/ViewRemind.jsp");
			}
			//加载主线
			function loadDetailMainline(){
			    beforeLoading();
			    $("#detailFrame").attr("src","/express/task/data/DetailView.jsp");
			    afterLoading();
			}
			
			function beforeLoading(){
			    $("#loading2").show();
			}
			
			function afterLoading1(){
			    var iframe=$("#detailFrame")[0];
				if (iframe.attachEvent){
				    iframe.attachEvent("onload", function(){
				        $("#loading2").hide();
				    });
				} else {
				    iframe.onreadystatechange = function(){
				    	
				        if (iframe.readyState == "complete"|| iframe.readyState == "loaded"){
				             $("#loading2").hide();
				        }
				    };
				}
			}
			
			function afterLoading(){
			    var iframe=$("#detailFrame")[0];
				if (iframe.attachEvent){   
					 iframe.attachEvent("onload", function(){        
					 	$("#loading2").hide();   
				     });
			    }else {   
					iframe.onload = function(){      
					 $("#loading2").hide();  
				    };
				}
			}
			
			function remindTask(){
			   beforerequest(2);
			   $('[name="check_items"]:checkbox').each(function(){
			   		if(this.checked){
			   			var inputObj = $(this).parent().parent().children().eq(4).children();
			   			var taskid = $(inputObj).attr("id");
			   			var userid = $("#userid").attr("value");
			   			var tasktype =$(inputObj).attr("_tasktype");
			   			var creater = $(this).parent().parent().attr("_creater");
			   			if(userid == creater){
			   				userid="0";
			   			}
			   			 $.ajax({
				    		type: "post",
			  				url:"/express/TaskOperation.jsp",
			  				data:{'taskId':taskid,'taskType':tasktype,'operation':"addRemind",'creater':creater,'remarktype':'1','userid':userid},
			  				contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			  		 		complete: function(data){
    			 }
	    	});	
			  		 }
			   });
			   afterrequest(2);
			}
			function attTask(){
			   beforerequest(3);
			   $('[name="check_items"]:checkbox').each(function(){
			   		if(this.checked){
			   			var inputObj = $(this).parent().parent().children().eq(4).children();
			   			var taskid = $(inputObj).attr("id");
			   			var tasktype =$(inputObj).attr("_tasktype");
			   			var creater = $(this).parent().parent().attr("_creater");
			   			var userid = $("#userid").attr("value");
				   			$(this).parent().parent().children().eq(3).children().removeClass("item_att0").addClass("item_att1").attr("_special",1).attr("title","取消关注");
				   			addAttention(taskid,tasktype,0,creater);
			  		 }
			   });
			   afterrequest(3);
			}
			function markdateTask(obj){
			   WdatePicker({
			        el:$(obj).find("div")[0],
				    isShowClear:false,        //是否显示清空按钮
					isShowOK:false,           //是否显示确定按钮
					//startDate:"2012-10-12", //设置选中日期
				    onpicked:function(dp){
						var returnvalue = dp.cal.getDateStr();
						if(new Date(returnvalue.replace(/\-/g, "\/"))<new Date("<%=todaydate%>".replace(/\-/g, "\/"))){
						   alert("标记时间不能小于今天(<%=todaydate%>)");
						   return;
						}
						beforerequest(3);
						afterrequest(4);
					}
			  });
			  return false; //阻止冒泡事件
			}
			
			//请求之前提醒
	  	function beforerequest(type){
                var t="Loading data...";
                switch(type)
                {
                    case 1:
                        t="正在分享任务，请稍等……"; //正在保存，请稍等...
                        break;
                    case 2:   
                        t="正在发送提醒，请稍等……"; //正在发表微博，请稍等……
                        break;                   
                    case 3:  
                        t="正在发送请求，请稍等……"; //正在删除，请稍等...
                        break;   
                    case 4:    
                        t="<%=SystemEnv.getHtmlLabelName(25008,user.getLanguage())%>";                                   
                        break;
                }
                $("#reminddiv").html(t).show();    
        }
        //请求完成后提醒
	    function afterrequest(type){
                switch(type)
                {
                    case 1:
                        $("#reminddiv").html("分享成功!"); //保存成功！
                        
                    case 2:
                        $("#reminddiv").html("提醒成功!");
                        break;
                    case 3:
                        $("#reminddiv").html("关注成功!");
                        break;
                    case 4:
                        $("#reminddiv").html("时间标记成功!");
                    break;
                }     
                window.setTimeout(function(){ $("#reminddiv").hide();},3000);         
               
         }
         //checkbox 选择框事件
         function checkOnClick(obj,e){
            if(obj.checked)
               $(obj).addClass("check_input_show").removeClass("check_input");
            else
               $(obj).addClass("check_input").removeClass("check_input_show");   
            stopBubble(e);
         }
         
         //设置序号
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
		
		 //添加cookie
		 function addCookie(objName,objValue,objHours){//添加cookie
				var str = objName + "=" + escape(objValue);
				if(objHours > 0){//为0时不设定过期时间，浏览器关闭时cookie自动消失
					var date = new Date();
					date.setTime(date.getTime() + objHours);
					str += "; expires=" + date.toGMTString();
				}
				document.cookie = str;
		  }
		  //读取cookie
		  function getCookie(objName){//获取指定名称的cookie的值
				var arrStr = document.cookie.split("; ");
				for(var i = 0;i < arrStr.length;i ++){
				   var temp = arrStr[i].split("=");
				   if(temp[0] == objName) return unescape(temp[1]);
				}
		  }
		  
		  //展开、收缩列表
		  function showList(obj){
		    var isload=$(obj).attr("_isload");
		    if(isload=="0"){
		       var moduleType=$("#statusbtn").find(".choose_type").attr("_type");
		       var dateType=$(obj).attr("_dateType");
		       $(obj).find("img").show();
		       loadList(moduleType,null,dateType);
		       //$(obj).find("img").hide();
		       $(obj).attr("_isload","1");
		    }else{
				if($(obj).next("table").css("display")=="none"){
					$(obj).next("table").show();
					$(obj).css("color","#000").attr("title","点击收缩");
				}else{
					$(obj).next("table").hide();
					$(obj).css("color","#0080FF").attr("title","点击展开");
				}
			}
		  }
		  
		  function getListMore(obj){
		      var total=parseInt($(obj).attr("_total"));
		      var pagesize=parseInt($(obj).attr("_pagesize"));
		      var pageindex=parseInt($(obj).attr("_pageindex"));
		      var viewType=$(obj).attr("_viewType");
		      var moduleType=$(obj).attr("_moduleType");
		      var datalist=$(obj).attr("_datalist");
		      var totalpage=parseInt($(obj).attr("_totalpage"));
		      var sqlwhere=$(obj).attr("_sqlwhere");
		      var querystr=$(obj).attr("_querystr");
		      var dateType=$(obj).attr("_dateType");
		      var filterType=$(obj).attr("_filterType");
		      
		      if(pageindex<=totalpage){
		          $(obj).html('<img src="/images/loading2_wev8.gif" align="absmiddle">&nbsp;正在加载数据...');
		          $.post("ListView.jsp?operation=listmore&viewType="+viewType+"&moduleType="+moduleType+"&pageindex="+pageindex+"&pagesize="+pagesize+"&sqlwhere="+sqlwhere+"&"+querystr+"&dateType="+dateType+"&filterType="+filterType,{total:total},function(data){
		             if(moduleType=="task")
		                $(obj).parents("tr:first").prev().before(data);
		             else
		                $(obj).parents("tr:first").before(data);  
		                
		             setItemWidth(dateType); //设置宽度   
		             
		             if(pageindex==totalpage)
		                $(obj).parents("tr:first").hide();
		             else   
		                $(obj).attr("_pageindex",Number(pageindex)+1);
		             $(obj).html('更多&nbsp;<img src="/blog/images/more_down_wev8.png" align="absmiddle">');
		             setIndex();   
		          });
		      }
		         
		  }
		  function addAttention(taskId,taskType,special,creater){
		  	$.ajax({
				type: "post",
			    url: "/express/task/data/Operation.jsp",
			    data:{"operation":"set_special",'taskId':taskId,'taskType':taskType,"special":special,"creater":creater,remindType:2}, 
			    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			    complete: function(data){
			    }
			});
		  }
		  
		  
		  //标题点击事件
			function doClickItem(obj){
				
				$(obj).removeClass("newinput").removeClass("fbinput");
				$(obj).next("img").remove();
				
				if($(obj).attr("id")=="" && typeof($(obj).attr("id"))=="undefined") return;//重复点击时不会加载
				foucsobj = obj;
				if($(obj).attr("id")=="" || typeof($(obj).attr("id"))=="undefined"){
					$(obj).removeClass("addinput").html("");
				}else{
				    var itemType=$(obj).attr("_itemType") //数据项类型
				    
				    beforeLoading();
				    if(itemType == "label"){
				    	
				    }
				    if(itemType=="mainline"){
						var mainlineid=$(obj).attr("id")
						if(viewType == "labelset"){
							$("#detailFrame").attr("src","/express/DetailLabel.jsp?labelid="+mainlineid);
						}else{
							$("#detailFrame").attr("src","DetailMainline.jsp?mainlineid="+mainlineid);
						}
					}else{
					
					    var item_tr=$(obj).parents("tr:first");
						var taskType=item_tr.attr("_taskType");
						var taskid=item_tr.attr("_taskid");
						var creater=item_tr.attr("_creater");
						if(taskType=="8"){ //查看人员
						   window.location.href="TaskMain.jsp?viewType=viewhrm&hrmid="+taskid;
						}else{
						   $("#detailFrame").attr("src","TaskView.jsp?operation=view&taskType="+taskType+"&taskid="+taskid+"&creater="+creater);
						}
					}
					afterLoading();//iframe加载完成后隐藏loading
				}
			}
			
			//标题失去焦点事件
			function doBlurItem(obj){
				var tasktype=$(obj).parents("tr:first").attr("_tasktype");
				if(tasktype=="1"){
				   doAddOrUpdate(obj);
				}
			}
		  
		    //键盘上下移动事件
			function moveUpOrDown(d,cobj){
				var inputs = $("div.disinput");
				var len = inputs.length;
				var showobj;
				if(len>1){
					for(var i=0;i<len;i++){
						if($(inputs[i]).attr("_tasktype")==cobj.attr("_tasktype")&&$(inputs[i]).attr("_taskid")==cobj.attr("_taskid")){
							if(d==2){
								if(i==0) i=len;
								showobj = $(inputs[i-1]);
							}
							if(d==1){
								if(i==(len-1)) i=-1;
								showobj = $(inputs[i+1]);
							}

							showobj.parent().parent().click();
							
							var obj = showobj.get(0);
						    if (obj.createTextRange) {//IE浏览器
						       var range = obj.createTextRange();
						       range.moveStart("character", showobj.val().length);
						       range.collapse(true);
						       range.select();
						    } else {//非IE浏览器
						       obj.setSelectionRange(showobj.val().length, showobj.val().length);
						       obj.focus();
						    }
							return;
						}
					}
				}
			}
		  
		     //执行新建或编辑
			function doAddOrUpdate(obj,enter){
				var taskid = $(obj).attr("id");
				var taskname = encodeURI($(obj).html());
				if(taskid=="" || typeof(taskid)=="undefined"){//新建
					if($(obj).html()=="" || $(obj).html()=="新建任务"){
						if($(obj).hasClass("definput")){
							$(obj).addClass("addinput").html("新建任务");
						}else{
							$(obj).parent().parent().remove();
							foucsobj = null;
						}
					}else{
						var _datetype = $(obj).parents("table.datalist").attr("_datetype");
						var sorttype=2;
						$.ajax({
							type: "post",
						    url: "/express/task/data/Operation.jsp",
						    data:{"operation":"add","taskName":filter(taskname),"sorttype":sorttype,"datetype":_datetype,"principalid":"<%=hrmid%>"}, 
						    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						    complete: function(data){ 
						    	data=$.trim(data.responseText);
						    	$(obj).attr("id",data);
						    	$(obj).attr("title",$(obj).html());
						    	
						    	var divstatus = $(obj).parent().parent().find(".checkbox");
						    	divstatus.html('<input name="check_items" type="checkbox" class="check_input" onclick="checkOnClick(this,event)">');
								
								var taskdate="";
								if(_datetype=="0") taskdate="<%=todaydate%>";
								else if(_datetype=="1") taskdate="<%=tomorrowdate%>";
								else if(_datetype=="2") taskdate="<%=afterTomorrowdate%>";
								
						    	var divdate = $(obj).parent().parent().find("div.div_m_date");
						    	divdate.addClass("div_date").addClass("div_date_show").attr("title",taskdate).attr("_taskdate",taskdate);
						    	
						    	$(obj).parent().parent().find(".item_hrm").html("<a href=javascript:viewHrm('<%=hrmid%>',1)><%=hrmName%></a>").attr("title","责任人");
						    	var divtoday = $(obj).parent().parent().find("div.div_today");
						    	divtoday.attr("id","today_"+data);
						    	
						    	$(obj).parents("tr:first").attr("_taskid",data).attr("_creater","<%=userid%>");
			
						    	//按日期分类显示时新建今天数据时显示今天标记
						    	//if(sorttype==2 && _datetype==1){
						    		divtoday.html("任务").attr("title","任务");
						    	//}
						    	//显示标记关注图标
						    	$(obj).parent().parent().find("td.item_att").addClass("item_att0").attr("_special",0).attr("title","标记关注");
			
								if((foucsobj!=null && ($(foucsobj).attr("id")=="" || typeof($(foucsobj).attr("id"))=="undefined")) || $(foucsobj).attr("id")==data){
									refreshDetail(data,<%=hrmid%>);
								}
							}
					    });
						$(obj).removeClass("addinput definput").parent().prevAll("td.td_blank").addClass("td_move").removeClass("td_blank");
						if(enter==1){
						  /*
							if($(obj).hasClass("definput")){
								addItem(1,enter);
							}else{
								addItem(0,enter);
							}
						  */
						  $(obj).attr("onblur","");	
						}
						var moduleType=$("#statusbtn").find(".choose_type").attr("_type");
						//增加默认新增
						if($(obj).parents("table.datalist").find("div.definput").length==0){
						   if(moduleType=="task")  {
								addItem(1,0); //在任务模块下才添加 默认新建
						   }else
						   		addItem(0,1);	
						}else
							addItem(0,1); //在任务模块下才添加 默认新建
						setIndex();//重置序号
					}
					
				}else{//编辑
					if(enter==1) addItem(0,1);
					if($(obj).html()==$(obj).attr("_defaultname")) return;
					if($(obj).html()==""){
						$(obj).html($(obj).attr("_defaultname")).attr("title",$(obj).attr("_defaultname"));
						if($(obj).attr("id")==$("#taskid").val()){
					    	$("#name").val($(obj).attr("_defaultname"));
						}
						return;
					}
					$(obj).attr("title",$(obj).html());
					$.ajax({
						type: "post",
					    url: "/express/task/data/Operation.jsp",
					    data:{"operation":"edit_name","taskId":taskid,"taskName":filter(taskname)}, 
					    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
					    complete: function(data){ 
						    
						}
				    });
				}
			}
		  function viewHrm(creator,tasktype){
		     if(tasktype!="6")
		        window.location.href="TaskMain.jsp?viewType=viewhrm&hrmid="+creator;
		  }
		  function srcToNull(){
		  	$("#detailFrame").attr("src","");
		  }
		  
		  function showSharebox(tasktype,taskid,creater){
		  		var newDialog = new Dialog();
		        newDialog.Width = 400;
				newDialog.Height = 300;
				newDialog.Modal = true;
				newDialog.ShowCloseButton=true;
				newDialog.Title = "添加分享";
				newDialog.ShowButtonRow=true;
				newDialog.OKEvent = function(){
					var sharevalue=$(newDialog.innerFrame.contentWindow.document).find("#sharerid_val").val();
					$.post("TaskOperation.jsp?operation=addShare&taskid="+taskid+"&tasktype="+tasktype+"&sharevalue="+sharevalue+"&creater="+creater,function(data){
					    newDialog.close();
					});
				};//点击确定后调用的方法
				newDialog.URL ="TaskShare.jsp?taskid=541";
				newDialog.show();
		  }
		  
		  function showDocUploadbox(tasktype,taskid,creater){
		  		var newDialog = new Dialog();
		        newDialog.Width = 400;
				newDialog.Height = 250;
				newDialog.Modal = true;
				newDialog.ShowCloseButton=true;
				newDialog.Title = "上传文档";
				newDialog.ShowButtonRow=true;
				newDialog.OKEvent = function(){
					newDialog.innerFrame.contentWindow.uploadFile();
				};//点击确定后调用的方法
				
				newDialog.CancelEvent=function(){
					$(newDialog.innerFrame).contents().find("#uploadDiv").html("");
					newDialog.close();
				}
				
				newDialog.URL ="TaskDocUpload.jsp";
				newDialog.show();
		  }
		  
		  /*拖动效果*/
		  	var   isResizing=false;   
			function   Resize_mousemove(event,obj){   
			      if(!isResizing)   return   ;   
			      
			      $("#dragdiv").css("left",event.clientX);
			      var width = $("#taskmain").width();
				  w1 = event.clientX+3+1;
				  w2 = width-w1+1;
				  $("#detail").animate({ width:w2 },0,null,function(){
						$("#view").animate({ width:w1 },0,null,function(){
							setAllItemWidth();
						});
				  });
				  if(!$(parent.document).find("#divmenu").is(":hidden")){
					  addCookie("task_detailWidth",w2,365*24*60*60*1000); //添加cookie
					  addCookie("task_viewWidth",w1,365*24*60*60*1000);   //添加cookie
				  }
			  }   
		  
	        $("#dragdiv").mousedown(function(){
	        	if("<%=isIE%>"=="true")
			        this.setCapture();
	            isResizing=true;
	         }).mouseup(function(){
	         	if("<%=isIE%>"=="true")
			        this.releaseCapture();
	            isResizing=false;
	         }).mousemove(function(e){
	         	Resize_mousemove(e);
	         });
	         
	        $(document).mousemove(function(e){
	            Resize_mousemove(e);
	        }).mouseup(function(){
	        	isResizing=false;
	        });
			 
			jQuery("#detailFrame").bind("load",function(){
		         jQuery("#detailFrame").contents().find("body").mouseup(function(){
	        			isResizing=false;
	       		 });
		    })
		 /*拖动效果*/ 
		</script>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
        <SCRIPT language="javascript"  src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	</body>
</html>
