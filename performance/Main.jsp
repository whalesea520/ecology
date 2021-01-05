<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.TimeUtil" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="OperateUtil" class="weaver.gp.util.OperateUtil" scope="page" />
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
	
	//查询待审核方案个数
	int auditamount = 0;
	String sql = "select count(t1.id) as amount"
		+" from GP_AccessProgram t1,GP_AccessProgramAudit t2 "
		+" where t1.id=t2.programid and t2.userid="+user.getUID();
	rs.executeSql(sql);
	if(rs.next()){
		auditamount = Util.getIntValue(rs.getString(1),0);
	}
	
	//查询未设置方案个数
	int[] amounts = OperateUtil.getNoProgramCount(user.getUID()+"");
	int amount1 = amounts[0];
	int amount2 = amounts[1];
	int amount3 = amounts[2];
	int amount4 = amounts[3];
	int nosetamount = amount1+amount2+amount3+amount4;
	
	
	//查找待评分成绩
	int score = 0;
	rs.executeSql("select count(*) from GP_AccessScore t,HrmResource h where t.userid=h.id and h.status in (0,1,2,3) and h.loginid is not null "+((!"oracle".equals(rs.getDBType()))?" and h.loginid<>'' ":"")+" and t.isvalid=1 and (t.status=0 or t.status=2) and t.operator=" + userid + " and t.startdate<='" + currentdate + "' and t.enddate>='"+currentdate+"'");
	if (rs.next())
		score = Util.getIntValue(rs.getString(1), 0);

	//查找待审批成绩
	int audit_s = 0;
	rs.executeSql("select count(*) from GP_AccessScore t,HrmResource h where t.userid=h.id and h.status in (0,1,2,3) and h.loginid is not null "+((!"oracle".equals(rs.getDBType()))?" and h.loginid<>'' ":"")+" and t.isvalid=1 and t.status=1 and exists(select 1 from GP_AccessScoreAudit aa where aa.scoreid=t.id and aa.userid=" + userid + ") and t.startdate<='" + currentdate + "' and t.enddate>='"+currentdate+"'");
	if (rs.next())
		audit_s = Util.getIntValue(rs.getString(1), 0);
	int scount = score+audit_s;
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>e-cology执行力平台 - 绩效考核</title>
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
					<jsp:param value="2" name="maintype"/>
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
					<div id="mineleft" class="leftmenu leftmenu_select" _url="/performance/access/ResultFrame.jsp?showsub=0">
						<div class="cond_txt" title="我的计划报告">考核成绩</div>
						<div id="icon1_1" class="cond_icon"></div>
					</div>
					<div class="leftmenu" _url="/performance/access/AccessFrame.jsp?showsub=0">
						<div class="cond_txt" title="绩效考核评分">考核评分</div>
						<div id="" class="cond_icon" <%if(scount>0){ %>style="background:none" 
							title="<%=scount %>个待评分或审批绩效考核"<%} %>><%if(scount>0){ %><%=scount %><%} %></div>
					</div>
					<!-- 
					<div class="leftmenu" _url="/performance/program/ProgramMain.jsp" _nosub="1">
						<div class="cond_txt" title="绩效考核方案设置">考核方案</div>
						<div id="icon1_3" class="cond_icon"></div>
					</div>
					 -->
					<div class="leftmenu" _url="/performance/program/ProgramFrame.jsp?showsub=0">
						<div class="cond_txt" title="我的考核方案设置">我的考核方案</div>
						<div id="" class="cond_icon"></div>
					</div>
					<div class="leftmenu" _url="/performance/program/ProgramAudit.jsp" _nosub="1">
						<div class="cond_txt" title="待审绩效考核方案">待审核方案</div>
						<div id="" class="cond_icon" <%if(auditamount>0){ %>style="background:none" 
							title="<%=auditamount %>个待审批考核方案"<%} %>><%if(auditamount>0){ %><%=auditamount %><%} %></div>
					</div>
					<div class="leftmenu" _url="/performance/program/ProgramList.jsp" _nosub="1">
						<div class="cond_txt" title="绩效考核方案设置查询">方案设置查询</div>
						<div id="" class="cond_icon" <%if(nosetamount>0){ %>style="background:none"
							title="<%=nosetamount %>个考核方案未设置"<%} %>><%if(nosetamount>0){ %><%=nosetamount %><%} %></div>
					</div>
					<div class="leftmenu" _url="/performance/base/BaseMain.jsp" _nosub="1">
						<div class="cond_txt" title="绩效考核基础设置">考核设置</div>
						<div id="icon1_4" class="cond_icon"></div>
					</div>
					<div class="leftmenu" _url="/performance/report/ReportFrame.jsp?showsub=0">
						<div class="cond_txt" title="绩效考核报表查询">考核报表</div>
						<div id="icon1_5" class="cond_icon"></div>
					</div>
					<div class="leftmenu" _url="/performance/gpreport/GPReport.jsp">
						<div class="cond_txt" title="考核执行分析">考核执行分析</div>
						<div id="icon1_6" class="cond_icon"></div>
					</div>
					<div class="leftmenu" _url="/performance/gpreport/ScoreReport.jsp">
						<div class="cond_txt" title="考核结果分析">考核结果分析</div>
						<div id="icon1_7" class="cond_icon"></div>
					</div>
					<div class="leftmenu" _url="/workrelate/reportshare/ReportShare.jsp">
						<div class="cond_txt" title="考考核结果分析共享设置">考核结果分析共享设置</div>
						<div id="icon1_8" class="cond_icon"></div>
					</div>
				</div>
				<%if(hassub){%>
				<div class="lefttitle subdiv">
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
				<iframe id="dataframe" src="/performance/access/ResultFrame.jsp?showsub=0" style="width: 100%;height:100%;" scrolling="auto" frameborder="0"></iframe>
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

				/**
			    var iframe1 = document.getElementById("dataframe");
				if (iframe1.attachEvent){ 
					iframe1.attachEvent("onload", function(){ 
						setOrg();
					}); 
				} else { 
					iframe1.onload = function(){ 
						setOrg()
					}; 
				} */
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
				//searchList(id,name);
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
