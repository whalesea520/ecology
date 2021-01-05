<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.TimeUtil" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	String userid = user.getUID()+"";
	String currentdate = TimeUtil.getCurrentDateString();
	//读取title
	//UsrTemplate.getTemplateByUID(user.getUID(), user.getUserSubCompany1());
	//String templateTitle = UsrTemplate.getTemplateTitle();
	
	boolean hassub = false;
	int hrmHeight = 0;
	//查询下属人员
	//rs.executeSql("select count(id) as amount from hrmresource where loginid<>'' and loginid is not null and (status =0 or status = 1 or status = 2 or status = 3) and managerid=" + user.getUID());
	//if(rs.next()) hrmHeight = Util.getIntValue(rs.getString(1),0)*26;
	//if(hrmHeight>0) hassub = true;
	int subcount = weaver.workrelate.util.TransUtil.getsubcount(userid);
	if(subcount>0){
		hrmHeight = subcount*26;
		hassub = true;
	}
	
	//查找待审批总结计划
	int audit_c = 0;
	rs.executeSql("select count(t.id) from PR_PlanReport t,HrmResource h where t.userid=h.id and h.status in (0,1,2,3) and h.loginid is not null "+((!"oracle".equals(rs.getDBType()))?" and h.loginid<>'' ":"")+" and t.isvalid=1 and t.status=1 and exists(select 1 from PR_PlanReportAudit aa where aa.planid=t.id and aa.userid=" + userid + ") and t.startdate<='" + currentdate + "' and t.enddate>='"+currentdate+"'");
	if (rs.next())
		audit_c = Util.getIntValue(rs.getString(1), 0);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>e-cology执行力平台 - 计划报告</title>
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8" />
		<link rel="stylesheet" href="/workrelate/css/ui/jquery.ui.all.css" />
		<link rel="stylesheet" href="main.css?1" />
		<script language="javascript" src="/workrelate/js/jquery-1.8.3.min.js"></script>
		<script src="/workrelate/js/util.js"></script>
		
		<link rel="stylesheet" href="/workrelate/css/perfect-scrollbar.css" rel="stylesheet" />
      	<script language="javascript" src="/workrelate/js/jquery.mousewheel.js"></script>
      	<script language="javascript" src="/workrelate/js/perfect-scrollbar.js"></script>
      	
      	<link type='text/css' rel='stylesheet'  href='/secondwev/tree/js/treeviewAsync/eui.tree.css'/>
		<script language='javascript' type='text/javascript' src='/secondwev/tree/js/treeviewAsync/jquery.treeview.js'></script>
		<script language='javascript' type='text/javascript' src='/secondwev/tree/js/treeviewAsync/jquery.treeview.async.js'></script>
      	<link type='text/css' rel='stylesheet'  href='/workrelate/css/common.css'/>
		<style type="text/css">
		</style>
		<!--[if IE]> 
		<style type="text/css">
			.disinput,.subdisinput{line-height: 28px !important;height: 28px !important;}
			.input_inner{line-height: 26px !important;}
		</style>
		<![endif]-->
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body>
		<div id="main">
			<!-- 左侧菜单 -->
			<div id="divmenu" style="width: 246px;height: 100%;" >
				<jsp:include page="/workrelate/Menu.jsp">
					<jsp:param value="3" name="maintype"/>
				</jsp:include>
				<!-- search -->
				<div style="width: 225px;height: 26px;;margin-top: 5px;margin-bottom: 10px;margin-left: 13px;position: relative;display: none;">
					<label for="objname" class="overlabel">按任务名称、标签或人员搜索</label>
					<input type="text" id="objname" name="objname" class="input_inner" />
				</div>
				
				<div class="lefttitle lefttitle_select" style="height: 20px;">
					<div class="lefttxt"></div>
				</div>
				<div id="mine">
					<div id="mineleft" class="leftmenu leftmenu_select" _url="/workrelate/plan/data/PlanFrame.jsp?showsub=0">
						<div class="cond_txt" title="我的计划报告">我的报告</div>
						<div id="icon1_1" class="cond_icon"></div>
					</div>
					<div class="leftmenu" _url="/workrelate/plan/data/AuditFrame.jsp?showsub=0">
						<div class="cond_txt" title="计划报告审批">报告审批</div>
						<div id="icon1_2" class="cond_icon" <%if(audit_c>0){ %>style="background:none" 
							title="<%=audit_c %>个待审批计划报告"<%} %>><%if(audit_c>0){ %><%=audit_c %><%} %></div>
					</div>
					<div class="leftmenu" _url="/workrelate/plan/data/ResultFrame.jsp?showsub=0">
						<div class="cond_txt" title="计划报告查询">报告查询</div>
						<div id="icon1_3" class="cond_icon"></div>
					</div>
					<div class="leftmenu" _url="/workrelate/plan/program/ProgramFrame.jsp?showsub=0">
						<div class="cond_txt" title="计划报告模板设置">模板设置</div>
						<div id="icon1_4" class="cond_icon"></div>
					</div>
					<div class="leftmenu" _url="/workrelate/plan/base/BaseFrame.jsp" _nosub="1">
						<div class="cond_txt" title="计划报告基础设置">基础设置</div>
						<div id="icon1_5" class="cond_icon"></div>
					</div>
					<div id="mineleft" class="leftmenu" _url="/workrelate/plan/report/RReport.jsp">
                        <div class="cond_txt" title="我的计划报告">报告报表</div>
                        <div id="icon1_0" class="cond_icon"></div>
                    </div>
				</div>
				<%if(hassub){%>
				<div class="lefttitle subdiv" style="">
					<div class="lefttxt">选择下属</div>
				</div>
				<div id="hrmdiv" class="scroll2 subdiv" style="width: 100%;">
					<div id="itemdiv2inner" style="width: auto;height: 100%;position: relative;">
					</div>
				</div>
				<%} %>
			</div>
			
			<!-- 中心视图 -->
			<div id="view" style="width:auto;height:100%;position: absolute;top: 0px;left:242px;right: 0px;bottom: 1px;z-index: 3;background: #fff;">
				<iframe id="dataframe" src="/workrelate/plan/data/PlanFrame.jsp?showsub=0" style="width: 100%;height:100%;" scrolling="auto" frameborder="0"></iframe>
			</div>
			
		</div>
		<script type="text/javascript">
			$.ajaxSetup ({
			    cache: false //关闭AJAX相应的缓存
			});

			//初始事件绑定
			$(document).ready(function(){

				//隐藏主题页面的左侧菜单
				hideLeftMenu();

				$("#divmenu").bind("mouseenter",function(){
					showMenu();
				}).bind("mouseleave",function(){
					hideMenu();
				});

				$("div.leftmenu").bind("mouseover",function(){
					$("div.leftmenu").removeClass("leftmenu_over");
					$(this).addClass("leftmenu_over");
				}).bind("mouseout",function(){
					$(this).removeClass("leftmenu_over");
				}).bind("click",function(){
					$("div.leftmenu").removeClass("leftmenu_select leftmenu_over");
					$("span.org_select").removeClass("org_select");
					$(this).addClass("leftmenu_select");
					var _url = $(this).attr("_url");
					$("#dataframe").attr("src",_url);
					if($(this).attr("_nosub")=="1"){
						$("div.subdiv").hide();
					}else{
						$("div.subdiv").show();
					}
				});


				//$("div.leftmenu")[0].click();
				//if(inittaskid=="") $("#detaildiv").append(loadstr).load("DefaultView.jsp");
				hrmHeight = <%=hrmHeight%>;//$("#hrmdiv").height();
				
				setPosition();
				$("div.scroll2").perfectScrollbar();
				<%if(hassub){%>
			  	//下属人员树初始化
			    $("#hrmdiv").addClass("hrmOrg"); 
			    $("#itemdiv2inner").treeview({
			        url:"/secondwev/tree/hrmOrgTree.jsp",
			        root:"hrm|<%=user.getUID()%>"
			    });

			  	//树形搜索中点击直接展开搜索并展开下属
				$("span.file,span.folder").live("click",function() {
					
				}).live("mouseover",function(){
					$(this).addClass("org_hover").parent("li").addClass("hover");
				}).live("mouseout",function(){
					$(this).removeClass("org_hover").parent("li").removeClass("hover");
				});
			    <%}%>

			});
			var resizeTimer = null;  
			$(window).resize(function(){
				if(resizeTimer) clearTimeout(resizeTimer);  
				resizeTimer = setTimeout("setPosition()",100);  
			});
			var speed = 200;
			function setPosition(){
				var width = $("#main").width();
				if(width>1000){// 窗口宽度大于1220时 右侧视图不会浮动在左侧菜单上
					
					width -= 246; 
					$("#view").animate({ width:width },speed,null,function(){
						$("#view").animate({ left:246 },speed,null,function(){
						});
					});
					
				}else{
					width -= 40; 
					$("#view").animate({ width:width },speed,null,function(){
						$("#view").animate({ left:30 },speed,null,function(){	
						});
					});
				}

				//$("#hrmdiv").height($("#main").height()-301-30-26);
				//$("#hrmdiv").height($("#main").height()-$("div.leftmenu").length*26-50-26*2-10-5);
				var lheight = $("#main").height()-$("#topmenu").height()-$("#mine").height()- $("div.lefttitle").length*30-10+10;
				$("#hrmdiv").height(lheight);
			}
			// 显示左侧菜单
			function showMenu(){
				if($(window).width()<=1000){
					$("#view").stop().animate({ left:246 },speed,null,function(){});
					// clearTimeout(aa);
				}
			}
			// 遮挡左侧菜单
			function hideMenu(){
				// 判断宽度 以及搜索框是否显示
				if($(window).width()<=1000){
					// aa = setTimeout(doHide,100);
					doHide();
				}
			}
			function doHide(){
				$("#view").stop().animate({ left:30 },speed,null,function(){});
			}
			function doClick(id,type,obj,name){
				var frames = document.getElementById("dataframe").contentWindow.frames;
				if(frames.length>1){
					frames[0].doClick(id,type,null);
				}else{
					return;
				}
				//if(dataframe.pageLeft==null) return;
				
				//$("div.leftmenu").removeClass("leftmenu_select leftmenu_over");
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
				//$("div.leftmenu").removeClass("leftmenu_select leftmenu_over");
				//dataframe.pageLeft.doClick(id,type,null);
				$("div.scroll2").perfectScrollbar("update");
			}
			function setOrg(){
				var frames = dataframe.window.frames;
				if(frames.length>1 && frames[0].document.body.clientWidth>0){
					dataframe.window.frames[1].document.body.click();
				}
			}
		</script>
	</body>
</html>
