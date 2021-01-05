
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.blog.BlogDao"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.general.TimeUtil"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="UsrTemplate" class="weaver.systeminfo.template.UserTemplate" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	//读取title
	UsrTemplate.getTemplateByUID(user.getUID(), user.getUserSubCompany1());
	String templateTitle = UsrTemplate.getTemplateTitle();
	String userid=user.getUID()+"";
	
	String newType = Util.null2String(request.getParameter("newType"));
	int remarkSum = 0;
	rs.executeSql("SELECT count(*) AS sum FROM task_msg where type=1 and receiverid = "+user.getUID());
	while(rs.next()){
		remarkSum = rs.getInt(1);
	}
	
	BlogDao blogDao = new BlogDao();
	Map count=blogDao.getReindCount(user); 
  	int remindCount=((Integer)count.get("remindCount")).intValue();           //提醒未查看数
	rs.executeSql("select count(*) from task_msg WHERE receiverid="+userid+" AND (type = 2 OR type=3)");
	int taskCount = 0;
	while(rs.next()){
		taskCount = rs.getInt(1);
	}
	int mesTotl = taskCount + remindCount;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
	<head>
		<title><%=templateTitle%> - <%=user.getUsername()%></title>
		<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
		<link rel="stylesheet" href="/express/css/base_wev8.css" />
		<script type="text/javascript" src="/wui/common/jquery/jquery.min_wev8.js"></script>
		<script language="javascript" src="/express/js/jquery.fuzzyquery.min_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>
		<script type="text/javascript" src="/express/js/jquery.poshytip_wev8.js"></script>
		<script src="/express/js/util_wev8.js"></script>
		<!-- ztree -->
		<link rel="stylesheet" href="/express/js/ztree/css/zTreeStyle/zTreeStyle_wev8.css" />
		<link rel="stylesheet" href="/express/css/tip-yellow_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/express/css/tip-darkgray_wev8.css" type="text/css" />
		<script src="/express/js/ztree/js/jquery.ztree.core-3.5_wev8.js"></script>
		
		<!-- 滚动条控件 -->
		<link rel="stylesheet" href="/express/js/jscrollpane/jquery.jscrollpane_wev8.css" />
		<script type="text/javascript" src="/express/js/jscrollpane/jquery.mousewheel_wev8.js"></script>
		<script type="text/javascript" src="/express/js/jscrollpane/jquery.jscrollpane.min_wev8.js"></script>
		<!-- treeview -->
		<link type='text/css' rel='stylesheet'  href='/blog/js/treeviewAsync/eui.tree_wev8.css'/>
		<script language='javascript' type='text/javascript' src='/blog/js/treeviewAsync/jquery.treeview_wev8.js'></script>
		<script language='javascript' type='text/javascript' src='/blog/js/treeviewAsync/jquery.treeview.async_wev8.js'></script>
		<!-- 滚动加载控件 -->
		<script src="/express/js/jquery.scrollpagination_wev8.js"></script>
		
		<script language=javascript src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<script language=javascript src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
		
		<style>
		       html,body{-webkit-text-size-adjust:none;margin: 0px;overflow: hidden;}
               *{font-size: 12px;font-family: Arial,'微软雅黑';outline:none;}
			   /*搜索*/
			   .search{width:180px;height: 25px;;margin-top: 5px;margin-bottom: 10px;margin-left: 10px;position: relative;background-color: #e6eff6;border: 1px #B4B4B4 solid;box-shadow:0px 0px 2px #B4B4B4;-moz-box-shadow:0px 0px 2px #B4B4B4;-webkit-box-shadow:0px 0px 2px #B4B4B4;
				border-radius: 4px;-moz-border-radius: 4px;-webkit-border-radius: 4px;}
			   .search div{float:left}	
			   .search input{height:23px;width:150px;margin:0px;border:0px;font-size:12px;background-color: #e6eff6;}
			   .search .btn{width:28px;height:23px;background-image: url('/express/images/search_btn_wev8.png');background-repeat: no-repeat;background-position: center center;cursor:pointer}
			  /*logo*/
			   .logo{width:100%;height:35px;color: #ffffff}	
			   .logo .logo1{font-size:24px;;margin-left:12px;float: left;margin-top:3px;}
			   .logo .logo2{font-size:12px;float: left;margin-top:5px;margin-left: 3px;}
			  /*头部信息*/
			   .hrm{margin-left: 10px;} 
			   .hrm .head_bg{height: 56px;width:56px;background-image: url('/express/images/head_icon_bg_wev8.png');float: left;}
			   .hrm img{margin-top: 4px;margin-left: 4px;border:0px;}
			   .hrm .info{float: left;margin-left: 7px;}
			   .hrm .name{color: #ffffff;float: left;background: url('/express/images/head_icon_arrow1_wev8.png') no-repeat;background-position: right center}
			  	.name:hover{color: #ffffff;text-decoration:underline;cursor:pointer;}
			   .hrm .blog{color: #cccccc;float: left;margin-left: 5px;cursor:pointer;}
			   .showLine{}
			   .showLine:hover{color: #ffffff;text-decoration:underline;}
			   .hrm .blog:hover{color: #ffffff;text-decoration:underline;}
			   .hrm .dept{color: #cccccc;clear: left;padding-top:3px;}
			   .hrm .msg{color: #cccccc;margin-top:3px;}
				
			   
			   #divmenu div{font-family: '微软雅黑' !important;}
			   label.overlabel {line-height:20px;position:absolute;top:3px;left:5px;color:#999;font-family: 微软雅黑;z-index:1;}
			   
			   .menu{margin-top: 10px;}
			   .menu .item{height: 28px;padding-left: 10px;}
			   .menu .active{background:url('/express/images/menu_bg_wev8.png');}
			   .workcenter{background: url('/express/images/work_center_wev8.png') no-repeat;background-position: left 5px;;padding-left:22px;float: left;padding-top: 5px;font-weight: bold;cursor:pointer;}
			   .workcenter:hover{text-decoration:underline;}
			   .atttask{background: url('/express/images/att_task_wev8.png') no-repeat;background-position: left 5px;padding-left:22px;float: left;padding-top: 5px;font-weight: bold;cursor:pointer;}
			   .atttask:hover{text-decoration:underline;}
			   .menu .count{float: right;padding-top: 5px;padding-right: 8px;}
			   .count:hover{text-decoration:underline;cursor:pointer;}
			   
			   .ztree li span.button.noline_open{background-image:url("/express/images/tree/t_close_arrow_wev8.png");background-position:8px center}
               .ztree li span.button.noline_close{background-image:url("/express/images/tree/t_open_arrow_wev8.png");background-position:8px center}
               .ztree li{margin-top:6px;}
               .ztree li a{color:#cccccc;}
               .ztree li a:hover{color:#ffffff;}
               
               .treeview ul{background:none !important}
               .hrmOrg,.hrmOrg a{color:#cccccc;}
               .hrmOrg a:hover,.hrmOrg a:active{color:#ffffff;}
               .hrmOrg span.subcompany{background:url('/express/images/tree/t_subcom_wev8.png') 0 0 no-repeat}
               .hrmOrg span.department{background:url('/express/images/tree/t_dept_wev8.png') 0 0 no-repeat}
               .hrmOrg span.person{background:url('/express/images/tree/t_person_wev8.png') 0 0 no-repeat}
               .hrmOrg span.company{background:url('/express/images/tree/t_company_wev8.png') 0 0 no-repeat}
               .treeview li.lastCollapsable,.treeview li.lastExpandable{
                 background:url('') right center no-repeat;
                }
                .treeview div.lastCollapsable-hitarea, .treeview div.lastExpandable-hitarea{
                  background-position:center center;
                }
               .treeview .hitarea{background:url('/express/images/tree/t_close_arrow_wev8.png') center center no-repeat}
               .treeview .expandable-hitarea{background:url('/express/images/tree/t_open_arrow_wev8.png') center center no-repeat}
               .treeview .hover{color:#ffffff;}
               
               .pull_down_item{width:100%;color:#ffffff;}
               .pull_down_item:hover{background:#000000}
               .label_item{background: url('/express/images/label_arrow_wev8.png') no-repeat;background-position: left center;height:24px;padding-left: 8px;line-height: 24px;margin-left:10px;color:#cccccc;cursor:pointer;}
               .label_item:hover{color:#ffffff;text-decoration:underline;}
               
               .tab{margin-top:5px;height:25px;background: url('/express/images/tab_bg_wev8.png');}
               .tab .item{height: 25px;width: 65px;float: left;cursor:pointer;}
               .tab .item_active{background: url('/express/images/tab_active_bg_wev8.png');color: #ffffff;font-weight: bold;cursor:default;}
               .tab .item div{margin-left:6px;padding-top: 3px;}
               
               .drop_list{position: absolute;width:60px;height: 125px;text-align:left;z-index: 999;top: 83px;left: 803px;
						background: #2090B8;border: 1px #CACACA solid;display: none;
						border-radius: 3px;-moz-border-radius: 3px;-webkit-border-radius: 3px;
						box-shadow:0px 0px 3px #CACACA;-moz-box-shadow:0px 0px 3px #CACACA;-webkit-box-shadow:0px 0px 3px #CACACA;
    					behavior:url(/express/css/PIE2.htc);opacity:0.8;}
               .btn_add_type{width: 80px;line-height: 25px;cursor: pointer;font-family: 微软雅黑;padding-left: 0px;padding-right:10px; color:#B4E4F2;white-space:nowrap; text-overflow:ellipsis; -o-text-overflow:ellipsis;overflow: hidden; }
				.btn_add_type img{margin-top: -1px;}
				.btn_add_type_over{background-color: #05608C;color: #FAFAFA;}
               
               #view{width:auto;height:auto;position: absolute;top: 6px;left:200px;right:5px;bottom:0px;}
               #view .leftround{position: absolute;width:3px;height:3px;top:0px;left:0px;background: url('/express/images/main_bg_topleft_wev8.png') no-repeat;z-index: 10}
               #view .rightround{position: absolute;width:3px;height:3px;top:0px;right:0px;background: url('/express/images/main_bg_topright_wev8.png') no-repeat;z-index: 10} 
			   #view .center{position: absolute;width: auto;height: auto;top:0px;bottom:0px;left:0px;right:0px;background: #fff;border-right: 1px #BFC5CC solid;}
			
			   #leftBlockHiddenContr {
				width:12px;position:absolute;left:200px;top:0px;bottom:0px;z-index:10;cursor:pointer;overflow:hidden;background-position:right center;
			   }
			   
			   #main{width: 100%;height: 100%;background: url('/express/images/bg_wev8.jpg') top left no-repeat;position: absolute;top: 0px;left: 0px;right: 0px;bottom: 0px;color: #ffffff}
			   #divmenu{width:200px;height: 100%;}
			   .clear{clear:both}
			</style>
	</head>
	<body>
	<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
	<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	
		<div id="main">
			<!-- 左侧菜单 -->
			<div id="divmenu">
				<div class="logo">
					<div class="logo1">ECOLOGY</div>
					<div class="logo2" >Express</div>
					<div style="float: right;">
						<img src="/wui/theme/ecology7/page/images/skin/skinSetting_wev8.png" align="absmiddle" title="<%=SystemEnv.getHtmlLabelName(27714, user.getLanguage())%>" style="height:16px;widht:16px;cursor:pointer;margin-top:8px;" onclick="javascript:showSkinListDialog();" id="themeQh"/></div>
					</div>
				<!-- search -->
				<div class="search">
					<div>
					   <label for="objname" class="overlabel"><%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%></label> <!-- 搜索 -->
					   <input type="text" id="objname"  title="输入你要搜索的内容" name="objname" onkeydown="opensearch(this,event)"/>
				    </div> 
				    <div class="btn" onclick="opensearch(this,event,true)"></div>
				</div>
				
				<div class="hrm" style="height:58px;">
				    <div class="head_bg">
				        <img src="<%=resourceComInfo.getMessagerUrls(userid)%>" width="48px"/>
				    </div>
				    <div class="info" style="width:125px;">
				       <div>
				       	<div class="name" style="float: left;">
				         	<div style=""><%=resourceComInfo.getLastname(userid)%></div>
						</div>
				        <div class="blog tips" title="<%=SystemEnv.getHtmlLabelName(367,user.getLanguage())+SystemEnv.getHtmlLabelName(26467,user.getLanguage())%>" onclick="showBlog()"><%=SystemEnv.getHtmlLabelName(26467,user.getLanguage())%></div> <!-- 微博 -->
				        <div class="blog" title="退出系统" style="margin-left:8px" onclick="javascript:if(window.confirm('<%=SystemEnv.getHtmlLabelName(16628,user.getLanguage())%>')) {window.location='/login/Logout.jsp';}" ><%=SystemEnv.getHtmlLabelName(1205,user.getLanguage())%></div> <!-- 退出 -->
				       	<div class="clear"></div>
				       </div>
				       <div class="dept"><%=departmentComInfo.getDepartmentname(resourceComInfo.getDepartmentID(userid))%></div>
				       <div class="msg"  style="cursor: pointer;">
				       	<span  onclick="showRemind()" class="showLine" title="<%=SystemEnv.getHtmlLabelName(30868,user.getLanguage())%>">
				        	<%=SystemEnv.getHtmlLabelName(26928,user.getLanguage())%>(<label id="remindNum"><%=remarkSum %></label>) <!-- 提醒 -->
				        </span>
				        &nbsp;&nbsp;
				        <span onclick="showMessage()" class="showLine" title="<%=SystemEnv.getHtmlLabelName(30869,user.getLanguage())%>">
				        	<%=SystemEnv.getHtmlLabelName(24532,user.getLanguage())%>(<label id="megNum"><%=mesTotl %></label>)<!-- 消息 -->
				       </span>
				       
				       </div> 
				    </div>
				</div>
				
				<div class="menu">
					<div class="item active">
					    <div class="workcenter" id="workcenter" title="<%=SystemEnv.getHtmlLabelName(30870,user.getLanguage())%>" _viewType="workcenter" style="float: left;" onclick="showMenuItem(this)"><%=SystemEnv.getHtmlLabelName(30871,user.getLanguage())%></div><!-- 工作中心 -->
					    <div class="count" title="<%=SystemEnv.getHtmlLabelName(30872,user.getLanguage())%>" onclick="showView('allFeedback')">(<span id="allFeedbackTotal">0</span>)</div>
						<div style="clear: both;"></div>
					</div>
					<div class="item">
					    <div class="atttask" title="<%=SystemEnv.getHtmlLabelName(30873,user.getLanguage())%>" _viewType="attTask" onclick="showMenuItem(this)"><%=SystemEnv.getHtmlLabelName(30874,user.getLanguage())%></div><!-- 关注的事 -->
					    <div  class="count" title="<%=SystemEnv.getHtmlLabelName(30875,user.getLanguage())%> " onclick="showView('attFeedback')">(<span id="attFeedbackTotal">0</span>)</div>
						<div style="clear: both;"></div>
					</div>
				</div>
				
				<div class="tab" id="hrmlist">
				     <div class="item" id="attention" tabtype="hrm" onclick="changeTab(this)"><div><%=SystemEnv.getHtmlLabelName(30876,user.getLanguage())%></div></div><!-- 关注的人 -->
				     <div class="item" id="canview"   tabtype="hrm" onclick="changeTab(this)"><div><%=SystemEnv.getHtmlLabelName(27545,user.getLanguage())%></div></div><!-- 可查看的 -->
				     <div class="item" id="hrmorg"    tabtype="hrm" onclick="changeTab(this)"><div><%=SystemEnv.getHtmlLabelName(25332,user.getLanguage())%></div></div> <!-- 组织结构 -->
					 <div style="clear: both;"></div>
				</div>
				<div id="hrmListdiv" class="scroll-pane" style="height: 200px;overflow: auto;"></div>
				
				<div class="tab" id="labellist" style="margin-top: 0px;">
				     <div class="item item_active" tabtype="mainLineList" onclick="changeTab(this)"><div><%=SystemEnv.getHtmlLabelName(30877,user.getLanguage())%></div></div><!-- 任务主线 -->
				     <div class="item" tabtype="labelList" onclick="changeTab(this)"><div><%=SystemEnv.getHtmlLabelName(30878,user.getLanguage())%></div></div><!-- 任务标签 -->
				     <div class="item" onclick="openSetting(this)"><div align="right"><img src="/express/images/setting_icon_wev8.png"/></div></div> 
				</div>
				
				
				<div class="scroll-pane" id="mainLineList" style="height: 200px;overflow: auto;"></div>
				<div class="scroll-pane" id="labelListdiv" style="height: 200px;overflow: auto; display: none;"></div>
				</div>
				
				<div id="leftBlockHiddenContr" title="<%=SystemEnv.getHtmlLabelName(30879,user.getLanguage())%>"></div>
				
				<!-- 中心视图 -->
				<div id="view">
					<div class="leftround"></div>
					<div class="rightround"></div>
					<div class="center">
						  <iframe style="height: 100%;width: 100%;" scrolling="no" frameborder="0" id="mainFrame" name="mainFrame" src="/express/TaskMain.jsp?viewType=workcenter" ></iframe>
					</div>
				</div>
		</div>
		
		
		
		<script type="text/javascript">
			/*
			$(function(){
				$('.tips').poshytip({
					className: 'tip-darkgray',
				});
				$('#objname').poshytip({
					className: 'tip-darkgray',
					showOn: 'focus',
					alignTo: 'target',
					alignX: 'center',
					alignY: 'bottom',
					offsetX: 0,
					offsetY: 5
				});
			});
			*/

			//加载提醒页面
			function showRemind(){
				var mainFrameSrc = $("#mainFrame").attr("src");
				var test = new RegExp("TaskMain.jsp","g");//创建正则表达式对象
				var result = mainFrameSrc.match(test);
				if(result == "TaskMain.jsp"){
					document.getElementById('mainFrame').contentWindow.loadRemind();
				}else{
					$("#mainFrame").attr("src","/express/TaskMain.jsp?viewType=workcenter&operator=remind");
				}
			}
				//加载消息页面
			function showMessage(){
					var mainFrameSrc = $("#mainFrame").attr("src");
					var test = new RegExp("TaskMain.jsp","g");//创建正则表达式对象
					var result = mainFrameSrc.match(test);
					if(result == "TaskMain.jsp"){
						document.getElementById('mainFrame').contentWindow.loadMessage();
					}else{
						$("#mainFrame").attr("src","/express/TaskMain.jsp?viewType=workcenter&operator=msg");
					}
			}
			//显示主线任务详细信息
			function showDetailMainLine(){
					$.ajax({
					url: "/express/DetailMainline.jsp", 
					data:{mainId:"6"},
					success: function(){
					
	     		 }});
					
			}
			
			var fuzzyObj;
			var totalpage=0; //总页数
			var pageindex=2; //第几页
			var isfinish=true;
			//初始事件绑定
			$(document).ready(function(){
			    var mainHeight=$("#main").height();
			    var scrollPaneHeight=(mainHeight-200-50)/2;
			    $('.scroll-pane').height(scrollPaneHeight);
			    $("#mainFrame").height($("#view").height());
                //初始化滚动条
                $('.scroll-pane').jScrollPane({
			        autoReinitialise: true  //内容改变后自动计算高度
			    }).bind('jsp-scroll-y',function(event, scrollPositionY, isAtTop, isAtBottom){
			        var targetlist=$(this).attr("id");
			        var jscroll=$(this).data('jsp');
			        var nScrollHight=jscroll.getContentHeight();
			        var nDivHight =scrollPaneHeight;  //div可见高度
                    var nScrollTop =scrollPositionY;  //当前滚动条所在位置
			        var isbottom=nScrollTop + nDivHight+20>= nScrollHight;   //是否到达底部
			        
			        if(isbottom&&targetlist=="hrmListdiv"){
				        var listtype=$("#hrmlist").find(".item_active").attr("id");
				        if(listtype!="hrmorg"){
				           if(totalpage>=pageindex&&isfinish){
				              isfinish=false;
				              $.post("/express/TaskOperation.jsp?operation="+listtype+"&pageindex="+pageindex,null,function(data){
				                 data=eval("("+data+")")
				                 var nodes=data.nodes;
				                 var treeObj = $.fn.zTree.getZTreeObj("hrmTree");
				                 //$.fn.zTree._z.view.addNodes(treeObj.setting,null, nodes);
				                 treeObj.addNodes(null, nodes);
				                 pageindex=pageindex+1;
				                 isfinish=true;
				              });
				           }
				        }
			        }
			    })
                //初始化结构树
                changeTab($("#attention")[0]);
                
                //绑定标签主线事件
                $(".label_item").live("click",function(){
                   var type=jQuery(this).attr("_type");
                   var objId = jQuery(this).attr("id");
                   if(type == "mainline"){
                  	 	$("#mainFrame").attr("src","/express/TaskMain.jsp?viewType="+type+"&mainlineid="+objId+"&operator=del");
                   }
                   if(type == "label"){
                    	$("#mainFrame").attr("src","/express/TaskMain.jsp?viewType="+type+"&labelid="+objId+"&operator=del");
                   }
                });
                
				//搜索框事件绑定
				fuzzyObj=$("#objname1").FuzzyQuery({
					url:"/express/task/data/GetData.jsp",
					record_num:10,
					filed_name:"name",
					searchtype:'search',
					divwidth: 400,
					updatename:'objname',
					updatetype:'',
					intervalTop:2,
					result:function(data){
					  //alert(data["id"]);
					  if(data["type"]==8){
					     var hrmid=data["id"]
					     $("#mainFrame").attr("src","/express/TaskMain.jsp?viewType=viewhrm&hrmid="+hrmid);
				      }else{
					     var taskid=data["id"];
					     var taskType=data["type"];
					     var creater=data["creater"];
					     $("#mainFrame").contents().find("#detailFrame").attr("src","TaskView.jsp?operation=view&taskType="+taskType+"&taskid="+taskid+"&creater="+creater);
				      }
					}
				});

				$("label.overlabel").overlabel();

				$(".name").bind("mousemove",function(e){
						$("#name_pulldown").css({
							"left":$(".name").position().left+"px",
							"top":"93px"
				}).show();
					
				});
				
				$(".name").bind("mouseleave",function(e){
						$("#name_pulldown").hide();
						
				});
				
				$("div.btn_add_type").bind("mouseover",function(){
						$("div.btn_add_type").removeClass("btn_add_type_over");
						$(this).addClass("btn_add_type_over");
					}).bind("mouseout",function(){
						$(this).removeClass("btn_add_type_over");
				});
			   
			    $.post("TaskOperation.jsp?operation=getTaskFeedbackTotal",null,function(data){
					data=eval("("+data+")");
			        $("#attFeedbackTotal").html(data.attFeedbackTotal);
			        $("#allFeedbackTotal").html(data.allFeedbackTotal);
			    });
			    //加载主线列表
			    $.post("TaskOperation.jsp?operation=getMainlineList",null,function(data){
			        $("#mainLineList").html(data);
			    });
			    //加载标签类表
			    $.post("/express/TaskOperation.jsp?operation=getLabelList",function(data){
			      	$("#labelListdiv").html(data);
			    });
			    
			    window.setInterval("checknew()",3*60*1000);
			    //checknew();
			});

			 //阻止事件冒泡函数
			 function stopBubble(e)
			 {
			     if (e && e.stopPropagation){
			         e.stopPropagation()
			         }
			     else{
			         window.event.cancelBubble=true
			 		}
			}

			function hideSearch(){
				$("#fuzzyquery_query_div").slideUp("fast",function() {});
			}
			
			//替换ajax传递特殊符号
			function filter(str){
				str = str.replace(/\+/g,"%2B");
			    str = str.replace(/\&/g,"%26");
				return str;	
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

			function showBlog(){
			    $("#mainFrame").attr("src","/blog/blogView.jsp?from=express");
			}
			function showMenuItem(obj){
			    jQuery(obj).parents(".menu").find(".active").removeClass("active");
			    jQuery(obj).parents(".item:first").addClass("active");
			    var _viewType=$(obj).attr("_viewType");
			    showView(_viewType);
			    //$("#mainFrame").attr("src",$(obj).attr("_url"));
			}
			
			function changeTab(obj){
			    if(jQuery(obj).hasClass("item_active")) return;
			    var tabtype=jQuery(obj).attr("tabtype"); //tab类型
			    var listtype=jQuery(obj).attr("id");     //列表类型
			    
			    if(tabtype=="hrm"){ //加载人员相关
			       jQuery(obj).parents("#hrmlist").find(".item_active").removeClass("item_active");
			       totalpage=0;
			       pageindex=2;
			       initTree(listtype);
			    }else{              //加载标签相关
			       jQuery(obj).parents("#labellist").find(".item_active").removeClass("item_active");
			      	if(tabtype ==("mainLineList")){
						   jQuery("#labelListdiv").hide();
			      		   jQuery("#mainLineList").show();
			      		
			      	}
			      	if(tabtype ==("labelList")){
			      		jQuery("#mainLineList").hide();
			      		jQuery("#labelListdiv").show();
			      	}
			    }
			    jQuery(obj).addClass("item_active");
			}
			
			function initTree(listtype){
			   if(jQuery("#hrmListdiv .jspPane").length>0)
			      jQuery("#hrmListdiv .jspPane").html("").append('<ul id="hrmTree" class="ztree" style="padding-top: 0px;"></ul>');
			   else
			      jQuery("#hrmListdiv").html("").append('<ul id="hrmTree" class="ztree" style="padding-top: 0px;"></ul>');   
			   if(listtype!="hrmorg"){   
				   var setting = {
						view: {
							showIcon: false,
							showLine: false
						},
						async: {
							enable: true,
							url: "/express/TaskOperation.jsp?operation="+listtype,
							autoParam: ["id"],
							dataFilter:function(treeId, parentNode, data){
							   totalpage=data.totalpage;
							   return data.nodes;
							}
						},
						callback:{
						   onClick:function(event, treeId, treeNode){
						       var treeObj = $.fn.zTree.getZTreeObj("hrmTree");
						       //treeObj.expandNode(treeNode, true, true, true);
						       //alert(treeNode.children);
						       if(!treeNode.children)
						          treeObj.reAsyncChildNodes(treeNode, "refresh");
						       else{
						          treeObj.expandNode(treeNode, !treeNode.open, false, true);    
						       }
						       $("#" + treeNode.tId + "_a").removeClass("curSelectedNode");
						       var hrmid=treeNode.id;
						       $("#mainFrame").attr("src","/express/TaskMain.jsp?viewType=viewhrm&hrmid="+hrmid);
						   }
						}
			       };
			       $.fn.zTree.init($("#hrmTree"), setting);
		       }else{
		           $("#hrmTree").removeClass("ztree").addClass("hrmOrg"); 
			       $("#hrmTree").treeview({
			          url:"/blog/hrmOrgTree.jsp"
			       }); 
			       
		       }
			}
			
			//查看人员
			function openBlog(id,type){
			   if(type==1)
			      $("#mainFrame").attr("src","/express/TaskMain.jsp?viewType=viewhrm&hrmid="+id);
			}
			
			function showView(viewType,keyword){
			
				var hrmid="<%=userid%>";
				var mainFrame=$("#mainFrame");
				var mViewType=mainFrame[0].contentWindow.viewType;
				
				if(isLeftAndRight()&&(mViewType=="workcenter"||mViewType=="attTask"||mViewType=="attFeedback"||mViewType=="allFeedback"||mViewType=="search"))
					mainFrame[0].contentWindow.showView("<%=resourceComInfo.getLastname(userid)%>",viewType,hrmid,keyword);
				else
					mainFrame.attr("src","/express/TaskMain.jsp?viewType="+viewType+"&keyword="+keyword);	
			}
			
			//是否是左右结构
			function isLeftAndRight(){
				return $("#mainFrame").contents().find("#detailFrame").length>0;
			}
			
			function opensearch(obj,e,isSearch){
			   var keyword=$("#objname").val();
			   if(keyword!=""&&((e.keyCode==13&&fuzzyObj.selectedRowIndex<0)||isSearch)){  //没有选择下拉内容的情况下
			      //$("#mainFrame").attr("src","/express/TaskMain.jsp?viewType=search&keyword="+keyword);
			      showView("search",keyword);
			   }
			}
			//打开主线、标签管理页面
			function openSetting(obj){
			    var type=$(obj).parent().find(".item_active").attr("tabtype");
			    var viewType="mainlineset" 
			    if(type=="labelList")
			        viewType="labelset";
			    document.getElementById('mainFrame').contentWindow.srcToNull();
			    $("#mainFrame").attr("src","/express/TaskMain.jsp?viewType="+viewType);
			}
			
			var newDialog = new Dialog();
			var newTimeout;
			//检查更新
			function checknew(){
			
			    newDialog.Width = 200;
				newDialog.Height = 100;
				newDialog.Modal = false;
				newDialog.ShowCloseButton=true;
				newDialog.Title = "新任务提醒";
				newDialog.Top="100%";
				newDialog.Left="100%";
				$.post("TaskOperation.jsp?operation=checknew",function(data){
					data=eval("("+data+")");
					if(data){
						
						$("#attFeedbackTotal").html(data.attFeedbackTotal); //关注的反馈数字
			        	$("#allFeedbackTotal").html(data.allFeedbackTotal);	//所有的反馈数字
						
						if(data.newstr!=""){
						    var newstr=data.newstr+"<div align='left'><a href='javascript:showNew()'>点击处理</a></div>";
							newDialog.InnerHtml =newstr;
							newDialog.show();
							newTimeout=setTimeout("newDialog.close()",30*1000);
						}
					}
				});
			}
			
			function showNew(){
				newDialog.close();
				clearTimeout(newTimeout);
			    showMenuItem($(".workcenter")[0]);
			}
			
			function showSkinListDialog(){
				var diag_xx = new Dialog();
				diag_xx.Width = 600;
				diag_xx.Height = 500;
				
				diag_xx.ShowCloseButton=true;
				diag_xx.Title = "<%=SystemEnv.getHtmlLabelName(27714, user.getLanguage())%>";//"主题中心";
				diag_xx.Modal = false;
			
				diag_xx.URL = "/wui/theme/ecology8/page/skinTabs.jsp";
				diag_xx.show();
			}
			
			//左侧区域隐藏按钮点击时触发
			jQuery("#leftBlockHiddenContr").bind("click", function() {
				leftBlockContractionOrExpand();
			});
			
			//左侧区域隐藏按钮
			var leftBlockHiddenContrFlag = 0;
			jQuery("#leftBlockHiddenContr").hover(function() {
				if (leftBlockHiddenContrFlag != -1) {
					jQuery(this).css("background", "url(/wui/theme/ecology7/skins/default/page/main/leftBlockContraction_wev8.png) no-repeat");
					jQuery(this).attr("title","隐藏左边栏");
				}
			}, function() {
				if (leftBlockHiddenContrFlag != -1) {
					jQuery(this).css("background", "none");
				}
			});
			
			/**
			 * 显示或者隐藏左侧区域
			 */
			function leftBlockContractionOrExpand(_this) {
				if (jQuery("#divmenu").css("display") == 'none') {
					jQuery("#divmenu").show();
					
					$("#view").css("left","200px");
					jQuery("#leftBlockHiddenContr").css("left","200px");
					jQuery("#leftBlockHiddenContr").css("background","");
					
					leftBlockHiddenContrFlag = 0;
				} else {
					jQuery("#divmenu").hide();
					
					$("#view").css("left","0");
					jQuery("#leftBlockHiddenContr").css("background", "url(/wui/theme/ecology7/skins/default/page/main/leftBlockExpand_wev8.png) no-repeat").css("left","0");
					jQuery("#leftBlockHiddenContr").attr("title","显示左边栏");
					leftBlockHiddenContrFlag = -1;
				}
			}
			
		</script>
		<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
        <SCRIPT language="javascript"  src="/js/JSDateTime/WdatePicker_wev8.js"></script>
	</body>
</html>
