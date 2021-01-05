<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.User"%>
<%@ page import="weaver.systeminfo.SystemEnv"%>

<%@ include file="/systeminfo/init_wev8.jsp" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<link href="css/MutilMenu.css" rel="stylesheet" type="text/css"/>
		<link href="css/style.css" rel="stylesheet" type="text/css"/>
		<link href="css/color1.css" rel="stylesheet" type="text/css"/>	
		<link href="css/stepnew.css" rel="stylesheet" type="text/css"/>
		<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
		<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
	</head>
	<body oncontextmenu="return false;">

		<div id="menu">
			<div id="mainStep">
				<span id="show" onClick="showMainStep(1)" class="selected item show">
					<span class="stepicon"></span>
					<span class="steptext"><%=SystemEnv.getHtmlLabelName(128587, user.getLanguage()) %></span><!-- 设置向导 -->
				</span>
				<span id="set" onClick="showMainStep(2)" class="item set">
					<span class="stepicon"></span>
					<span class="steptext"><%=SystemEnv.getHtmlLabelName(128590, user.getLanguage()) %></span><!-- 导出导入 -->
				</span>
			</div>
		</div>
		
		<div id="content" style="overflow: auto;">
			<div id="sub_steps">
				<table style="width: 100%;height: 100%;">
					<col width="120px;"/>
					<col width="*"/>
				<tr>
				<td>
					<!-- 一级菜单 -->
					<div id="subStep" class="subStepMenu">
						<div class="menuleft">
						</div>
						<div class="menumain">
							<div class="menuitem">
								<div class="menuicon">1</div>
								<div class="menutext"><%=SystemEnv.getHtmlLabelName(128591, user.getLanguage()) %></div><!-- 设置全局参数 -->
							</div>
							
							<div class="menuitem">
								<div class="menuicon">2</div>
								<div class="menutext"><%=SystemEnv.getHtmlLabelName(128592, user.getLanguage()) %></div><!-- 新建预算期间 -->
							</div>
							
							<div class="menuitem">
								<div class="menuicon">3</div>
								<div class="menutext"><%=SystemEnv.getHtmlLabelName(128593, user.getLanguage()) %></div><!-- 设置成本中心 -->
							</div>
							
							<div class="menuitem">
								<div class="menuicon">4</div>
								<div class="menutext"><%=SystemEnv.getHtmlLabelName(128594, user.getLanguage()) %></div><!-- 设置预算科目 -->
							</div>
							
							<div class="menuitem">
								<div class="menuicon">5</div>
								<div class="menutext"><%=SystemEnv.getHtmlLabelName(128595, user.getLanguage()) %></div><!-- 设置预算控制方案 -->
							</div>
							
							<div class="menuitem">
								<div class="menuicon">6</div>
								<div class="menutext"><%=SystemEnv.getHtmlLabelName(128630, user.getLanguage()) %></div><!-- 启用电子报账流程 -->
							</div>
							
							<div class="menuitem">
								<div class="menuicon">7</div>
								<div class="menutext"><%=SystemEnv.getHtmlLabelName(128597, user.getLanguage()) %></div><!-- 设置预算编制权限 -->
							</div>
							
							<div class="menuitem">
								<div class="menuicon">8</div>
								<div class="menutext"><%=SystemEnv.getHtmlLabelName(128598, user.getLanguage()) %></div><!-- 编制预算 -->
							</div>
							
						</div>
					</div>
				</td>
				<td>	
				<!--后台设置-->
				<div id="subStep-1" class="subStep">
					<!-- 设置全局参数 - 按客户实际需求设置预算模块的通用参数：预算维度、费控逻辑、预算编制方式等开关 -->
					<div class="StepTitle"><%=SystemEnv.getHtmlLabelName(128599, user.getLanguage()) %></div>
					<iframe id="subStepiframe1" src="" width="100%" height="100%" frameborder="0" align="top"></iframe>
				</div>

				<div id="subStep-2" class="subStep">
					<!-- 新建预算期间 - 生成当前年度的预算期间，系统默认按当前年度生成全年预算期间，如会计期间不是按自然月划分的话，也可在此处修改 -->
					<div class="StepTitle"><%=SystemEnv.getHtmlLabelName(128600, user.getLanguage()) %></div>
					<iframe id="subStepiframe2" src="" width="100%" height="100%" frameborder="0" align="top"></iframe>
				</div>
				
				<div id="subStep-3" class="subStep">
					<!-- 设置成本中心 - 如果启用了成本中心预算编制维度，则在此页面按客户实际情况对成本中心进行初始化与维护 -->
					<div class="StepTitle"><%=SystemEnv.getHtmlLabelName(128601, user.getLanguage()) %></div>
					<iframe id="subStepiframe3" src="" width="100%" height="100%" frameborder="0" align="top"></iframe>
				</div>
				<div id="subStep-4" class="subStep">
					<!-- 设置预算科目 - 系统可以为客户初始化一套常用预算科目，此外，客户也可以在此页面针对自己的需求进一步调整 -->
					<div class="StepTitle"><%=SystemEnv.getHtmlLabelName(128602, user.getLanguage()) %></div>
					<iframe id="subStepiframe4" src="" width="100%" height="100%" frameborder="0" align="top"></iframe>
				</div>

				<div id="subStep-5" class="subStep">
					<!-- 设置预算控制方案 - 系统安装完成后，默认为全局强控，也可在此页面按需配置 -->
					<div class="StepTitle"><%=SystemEnv.getHtmlLabelName(128603, user.getLanguage()) %></div>
					<iframe id="subStepiframe5" src="" width="100%" height="100%" frameborder="0" align="top"></iframe>
				</div>
				<div id="subStep-6" class="subStep">
					<!-- 搭建网上报销流程 - 请按客户实际业务需求搭建相应的网上报销流程 -->
					<div class="StepTitle"><%=SystemEnv.getHtmlLabelName(128604, user.getLanguage()) %></div>
					<iframe id="subStepiframe6" src="" width="100%" height="100%" frameborder="0" align="top"></iframe>
				</div>
				<div id="subStep-7" class="subStep">
					<!-- 设置预算编制权限 - 系统安装完成后，默认财务人员可以编制所有维度的预算数据，如需单独赋权，可在此处进行配置 -->
					<div class="StepTitle"><%=SystemEnv.getHtmlLabelName(128605, user.getLanguage()) %></div>
					<iframe id="subStepiframe7" src="" width="100%" height="100%" frameborder="0" align="top"></iframe>
				</div>
				<div id="subStep-8" class="subStep">
					<!-- 编制预算 - 当前登录人员依据相应编制权限，开始对预算进行编制，预算编制完成并生成生效版本后，即可进行网上报销了 -->
					<div class="StepTitle"><%=SystemEnv.getHtmlLabelName(128606, user.getLanguage()) %></div>
					<iframe id="subStepiframe8" src="" width="100%" height="100%" frameborder="0" align="top"></iframe>
				</div>
				
				</td>
				</tr>
				</table>
			</div>
			
			<div id="mainStep-1">
				<iframe id="mainStepiframe1" src="/fna/batch/FnaGlobalExpImp.jsp" width="100%" height="100%" frameborder="0" align="top" scrolling="no" style="overflow: hidden;"></iframe>
			</div>
		</div>
	
	
		<script type="text/javascript">

			/**
			* add by fmj,左侧的后台设置步骤事件
			*/
		    jQuery(document).ready(function(){

				//默认选中后台设置步骤的第一步
		    	var firstitem = jQuery("#subStep .menumain .menuitem:eq(0)");
		    	firstitem.addClass("selected");
		    	showStepContent(1);	
		    	jQuery("#sub_steps .subStep").hide();
		    	jQuery("#sub_steps .subStep:eq(0)").show();

		    	showMainStep(1);
			    
				jQuery("#subStep .menumain .menuitem").each(function(i){
					var $this = jQuery(this);
					var _html = $this.find(".menutext").html();
					if(!!_html){
						$this.attr("title",_html);
					}
					
					////每个步骤的事件
					$this.bind("click",function(){
						//添加选中的样式
						jQuery("#subStep .menumain .menuitem").removeClass("selected");
						$this.addClass("selected");

						//显示右侧的div
						showStepContent(i+1);
						jQuery("#sub_steps .subStep").hide();
						jQuery("#sub_steps .subStep:eq(" + i +")").show();
					});
				});
			 });

		
			function showMainStep(index){
				if(index==1){
					jQuery("#show").addClass("selected");
					jQuery("#set").removeClass("selected");
					showSubStep();
				}else if(index==2){
					jQuery("#show").removeClass("selected");
					jQuery("#set").addClass("selected");
					hideSubStep();
				}
			}
			
			function showSubStep(){//显示后台设置
				jQuery("div[id^='mainStep-']").hide();//隐藏集成演示
				/**jQuery("#subStep").show();
				//默认显示第一步
				jQuery("#img").find("a:first").trigger("click");
				jQuery(".num").css("position","absolute");*/

				jQuery("#sub_steps").show();
				//showScrollBar();
			}
			/*
			jQuery(window).resize(function() {
				showScrollBar();
			});
			*/
			
			function showScrollBar(){
				var steprightwidth = jQuery("body").width()-180;//body宽度-集成演示和后台设置的宽度150，margin的宽度30
				
				var stepsumwidth = 0;
				jQuery(".ul1 li").each(function(){
					stepsumwidth += jQuery(this).width();
				})
				if(stepsumwidth>steprightwidth){//步骤宽度大于右侧宽度，则显示滚动条
					var subStepwidth=steprightwidth;
					var img_bagwidth=steprightwidth;
					var imgwidth = steprightwidth-50;
					jQuery("#subStep").css("width",subStepwidth+"px");
					jQuery("#img_bag").css("width",subStepwidth+"px");
					jQuery("#img").css("width",imgwidth+"px");
					jQuery("#menu").css("min-width",jQuery("body").width()+"px");
					jQuery("#scrollBar").show();
					jQuery(".scrollbtn").show();
				}else{//步骤宽度小于右侧屏幕宽度
					var subStepwidth=stepsumwidth;
					var img_bagwidth=stepsumwidth;
					var imgwidth=stepsumwidth;
					jQuery("#subStep").css("width",subStepwidth+"px");
					jQuery("#img_bag").css("width",subStepwidth+"px");
					jQuery("#img").css("width",imgwidth+"px");
					jQuery("#menu").css("min-width",jQuery("body").width()+"px");
					jQuery("#scrollBar").hide();
					jQuery(".scrollbtn").hide();
				}				
			}
			
			function showDetailStep(obj){//显示具体的操作步骤
				var index = jQuery(obj).find(".icon").text();
				jQuery("div[id^='subStep-']").hide();//隐藏所有设置步骤
				jQuery("#subStep-"+index).show();//显示选中的步骤
				//控制选中状态
				jQuery("#img").find("li").removeClass("selected");//删除所有选中状态
				jQuery(obj).parent().addClass("selected");//添加选中状态
				showStepContent(index);
			}
			
			function hideSubStep(){//显示集成演示
				jQuery("div[id^='mainStep-']").show();//显示集成演示
				/*jQuery("#subStep").hide();
				jQuery("div[id^='subStep-']").hide();//隐藏所有设置步骤*/

				jQuery("#sub_steps").hide();
			}
			
			function showStepContent(stepIndex){

				stepIndex = 1*stepIndex;
				if(stepIndex>0){
					
					switch(stepIndex){
						case 1:
							var url = "/fna/budget/FnaSystemSetEdit.jsp";
							setStepIframe("subStepiframe"+stepIndex,url);
							break;
						case 2:
							var url = "/fna/maintenance/FnaTab.jsp?_fromURL=FnaYearsPeriods";
							setStepIframe("subStepiframe"+stepIndex,url);
							break;
						case 3:
							var url = "/fna/costCenter/CostCenter.jsp";
							setStepIframe("subStepiframe"+stepIndex,url);
							break;
						case 4:
							var url = "/fna/maintenance/FnaBudgetfeeType.jsp";
							setStepIframe("subStepiframe"+stepIndex,url);
							break;
						case 5:
							var url = "/fna/budget/FnaControlSchemeSet.jsp";
							setStepIframe("subStepiframe"+stepIndex,url);
							break;
						case 6:
							var url = "/workflow/workflow/managewf_frm.jsp";
							setStepIframe("subStepiframe"+stepIndex,url);
							break;
						case 7:
							var url = "/fna/budget/FnaLeftRuleSet/ruleSet.jsp";
							setStepIframe("subStepiframe"+stepIndex,url);
							break;
						case 8:
							var url = "/fna/budget/FnaBudget.jsp";
							setStepIframe("subStepiframe"+stepIndex,url);
							break;
						default:
							break;
					}
				}
			}
			
			function setFrameHeight(){
				var _h = jQuery(this).height() - jQuery("#mainStep").height() - 10;
				jQuery("#content").attr("height",_h+"px");
				jQuery("#content").height(_h);

				jQuery("#mainStep-1").attr("height",(_h-2)+"px");
				jQuery("#mainStep-1").height((_h-2));
				
				//alert("_h="+_h+";"+jQuery("#content").height());
			}
			
			
			function setStepIframe(fid,url){
				if(jQuery("#"+fid).attr("src")==""){
					var height = "700px";

					jQuery("#"+fid).attr("overflow","hidden");
					jQuery("#"+fid).attr("scrolling","no");
					jQuery("#"+fid).attr("height",height);
					jQuery("#"+fid).attr("onload",setFrameHeight());
					jQuery("#"+fid).attr("src",url);
				}
			}
			
			jQuery(document).ready(function() {
				//jQuery("div[id^='subStep-']").hide();			
			});
		
		</script>
		
		
	</body>
</html>

