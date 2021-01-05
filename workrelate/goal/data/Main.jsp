<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<%
	//读取title
	//UsrTemplate.getTemplateByUID(user.getUID(), user.getUserSubCompany1());
	//String templateTitle = UsrTemplate.getTemplateTitle();
	
	String taskid = Util.null2String(request.getParameter("taskid"));
	String goalid = Util.null2String(request.getParameter("goalid"));
	int showdetail = Util.getIntValue(request.getParameter("showdetail"),0);
	if(!goalid.equals("")) taskid = goalid;
	
	boolean hassub = false;
	int hrmHeight = 0;
	//查询下属人员
	int subcount = weaver.workrelate.util.TransUtil.getsubcount(user.getUID()+"");
	//rs.executeSql("select count(id) as amount from hrmresource where loginid<>'' and loginid is not null and (status =0 or status = 1 or status = 2 or status = 3) and managerid=" + user.getUID());
	if(subcount>0) hrmHeight = Util.getIntValue(rs.getString(1),0)*26;
	if(hrmHeight>0) hassub = true;
	
	int year = Integer.parseInt(TimeUtil.getCurrentDateString().substring(0,4));
	int month = Integer.parseInt(TimeUtil.getCurrentDateString().substring(5,7));
	int season = Integer.parseInt(TimeUtil.getCurrentSeason());
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>e-cology执行力平台 - 目标管理</title>
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
		<link rel="stylesheet" href="/workrelate/css/ui/jquery.ui.all.css" />
		<link rel="stylesheet" href="../css/main.css?2" />
		<script language="javascript" src="/workrelate/js/jquery-1.8.3.min.js"></script>
		<script language="javascript" src="../js/jquery.fuzzyquery.min.js?1"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>
		<script src="/workrelate/js/jquery.ui.core.js"></script>
		<script src="/workrelate/js/jquery.ui.widget.js"></script>
		<script src="/workrelate/js/jquery.ui.datepicker.js"></script>
		<script src="/workrelate/js/jquery.dragsort.js"></script>
		<script src="/workrelate/js/jquery.textarea.autoheight.js"></script>
		<script src="/workrelate/js/util.js"></script>
		<script language="javascript" src="/js/init_wev8.js"></script>
		<link rel="stylesheet" href="/workrelate/css/perfect-scrollbar.css" rel="stylesheet" />
      	<script language="javascript" src="/workrelate/js/jquery.mousewheel.js"></script>
      	<script language="javascript" src="/workrelate/js/perfect-scrollbar.js"></script>
      	
      	<link type='text/css' rel='stylesheet'  href='/secondwev/tree/js/treeviewAsync/eui.tree.css'/>
		<script language='javascript' type='text/javascript' src='/secondwev/tree/js/treeviewAsync/jquery.treeview.js'></script>
		<script language='javascript' type='text/javascript' src='/secondwev/tree/js/treeviewAsync/jquery.treeview.async.js'></script>
      	<link type='text/css' rel='stylesheet'  href='/workrelate/css/common.css?1'/>
		<style type="text/css">
			<%if(showdetail==1){%>
				#detail{width:100% !important;z-index: 10000 !important;}
				#detaildiv{border: 0px !important;}
			<%}%>
		</style>
		<!--[if IE]> 
		<style type="text/css">
			.disinput,.subdisinput{line-height: 28px !important;height: 28px !important;}
			.input_inner{line-height: 26px !important;}
			input,textarea{font-family: '微软雅黑';}
		</style>
		<![endif]-->
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body>
		<div id="main">
			<!-- 左侧菜单 -->
			<div id="divmenu" style="width: 248px;height: 100%;" >
				<jsp:include page="/workrelate/Menu.jsp">
					<jsp:param value="1" name="maintype"/>
				</jsp:include>
				<!-- search -->
				<div class="search">
					<label for="objname" class="overlabel">按目标名称、类型或人员搜索</label>
					<input type="text" id="objname" name="objname" class="input_inner" />
				</div>
				
				<div class="lefttitle lefttitle_select" style="">
					<div class="lefttxt">本人</div>
					<div style="width: auto;height: 16px;position: absolute;right: 5px;top: 10px;">
						<%if(HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user)){ %>
						<div style="width: 16px;height: 16px;background: url('../images/setting.png');cursor: pointer;
							float:right;margin-right: 5px;" title="设置" onclick="openFullWindowHaveBar('/workrelate/goal/right/Right_Main.jsp')"></div>
						<%} %>
						<%if(cmutil.getGoalMaint(user.getUID()+"")[0]==2){ %>
						<div style="width: 16px;height: 16px;background: url('../images/import.png');cursor: pointer;
							float:right;margin-right: 5px;" title="导入" onclick="openFullWindowHaveBar('/workrelate/goal/import/GoalImport.jsp')"></div>
					<%} %>
					</div>
					
					
				</div>
				<div id="mine">
					
					<div id="mineleft" class="leftmenu" _datatype="0" _condtype="1" _hrmid="" _tag="">
						<div class="cond_txt" title="我负责的目标">我的目标</div>
						<div id="icon1_1" class="cond_icon"></div>
					</div>
					<div class="leftmenu" _datatype="0" _condtype="2" _hrmid="2" _tag="">
						<div class="cond_txt" title="公司目标">公司目标</div>
						<div id="icon1_2" class="cond_icon"></div>
					</div>
					<div class="leftmenu" _datatype="0" _condtype="3" _hrmid="" _tag="">
						<div class="cond_txt" title="我创建的所有目标">我创建的目标</div>
						<div id="icon1_2" class="cond_icon"></div>
					</div>
					<div class="leftmenu" _datatype="0" _condtype="4" _hrmid="" _tag="">
						<div class="cond_txt" title="我参与的所有目标">我参与的目标</div>
						<div id="icon1_4" class="cond_icon"></div>
					</div>
					<div class="leftmenu" _datatype="0" _condtype="6" _hrmid="" _tag="">
						<div class="cond_txt" title="我标记为关注的所有目标">我关注的目标</div>
						<div id="icon1_5" class="cond_icon"></div>
					</div>
					<div class="leftmenu" _datatype="0" _condtype="5" _hrmid="" _tag="">
						<div class="cond_txt" title="别人分享给我的所有目标">分享给我的目标</div>
						<div id="icon1_6" class="cond_icon"></div>
					</div>
					<div class="leftmenu" _datatype="0" _condtype="0" _hrmid="" _tag="">
						<div class="cond_txt" title="我能够看到的所有目标">所有目标</div>
						<div id="icon1_7" class="cond_icon"></div>
					</div>
				</div>
				<%if(hassub){%>
				<div class="lefttitle" style="">
					<div class="lefttxt">下属</div>
				</div>
				<div id="hrmdiv" class="scroll2" style="width: 100%;">
					<div id="itemdiv2inner" style="width: auto;height: 100%;position: relative;">
					</div>
				</div>
				<%} %>
			</div>
			
			<!-- 中心视图 -->
			<div id="view" style="width:auto;height:100%;position: absolute;top: 0px;left:252px;right: 460px;bottom: 1px;z-index: 3">
				<div style="position: absolute;width: auto;height: auto;top:0px;bottom:0px;left:0px;right:0px;background: #fff;border-right: 1px #BFC5CC solid;border-top: 0px #BFC5CC solid;border-left: 1px #BFC5CC solid;">
					<div style="width: 100%;height: 40px;position: relative;border-bottom: 1px #EFEFEF solid;">
						<div id="micon" style="float: left;margin-left: 14px;margin-top: 7px;width: 25px;height: 25px;background: url('../images/title_icon_0.png') no-repeat;"></div>
						<div id="mtitle" style="float: left;margin-left: 7px;line-height: 38px;font-size: 16px;font-weight: bold;font-family: 微软雅黑"></div>
						<div id="sortname" style="float: left;margin-left: 8px;margin-right: 4px;margin-top: 7px;line-height: 28px;font-family: 微软雅黑;">
							--
						</div>
						<div id="mainoperate4" class="poperate" _menuid="menupanel4" style="width:42px"><%=year %>年</div>
						<div id="mainoperate5" class="poperate" _menuid="menupanel5" style="display:none;width:32px"><%=month %>月</div>
						<div id="mainoperate6" class="poperate" _menuid="menupanel6" style="display:none;width:32px"><%=season %>季度</div>
						<div id="mainoperate7" class="poperate" style="display:none;width:32px;cursor:default;"></div>
						
						
						<div id="mainoperate2" class="mainoperate" style="display: none;" _menuid="menupanel2" title="">进行中</div>
						<div id="mainoperate3" class="mainoperate"  _menuid="menupanel3" title="点击切换周期">年度</div>
						<div id="mainoperate1" class="mainoperate"  _menuid="menupanel1" title="点击切换视图">层级</div>
						<div id="menupanel1" class="menupanel" style="width:70px;">
							<div class="menutitle">视图</div>
							<div id="sorttype_level" class="btn_add_type" onclick="doChangeSort(this,4)" _val="层级">层级视图</div>
							<div class="btn_add_type" onclick="doChangeSort(this,3)" _val="分类">分类视图</div>
							<div class="btn_add_type" onclick="doChangeSort(this,1)" _val="列表">列表视图</div>
							<!-- div id="sorttype_level" class="btn_add_type" onclick="doChangeSort(this,4)">层级视图</div -->
						</div>
						<div id="menupanel3" class="menupanel" style="width:60px;">
							<div class="menutitle">周期</div>
							<div class="btn_add_type" onclick="doChangePeriod(this,1)">月度</div>
							<div class="btn_add_type" onclick="doChangePeriod(this,2)">季度</div>
							<div class="btn_add_type" onclick="doChangePeriod(this,3)">年度</div>
							<div class="btn_add_type" onclick="doChangePeriod(this,4)">三年</div>
							<div class="btn_add_type" onclick="doChangePeriod(this,5)">五年</div>
							<div class="btn_add_type" onclick="doChangePeriod(this,0)">全部</div>
						</div>
						<div id="menupanel2" class="menupanel" style="width: 60px;">
							<div class="menutitle">状态</div>
							<div class="btn_add_type" onclick="doChangeStatus(this,1)">进行中</div>
							<div class="btn_add_type" onclick="doChangeStatus(this,2)">已完成</div>
							<div class="btn_add_type" onclick="doChangeStatus(this,3)">已撤销</div>
							<div class="btn_add_type" onclick="doChangeStatus(this,0)">全部</div>
						</div>
						<div id="menupanel4" class="menupanel" style="width: 60px;">
							<div class="menutitle">年份</div>
							<% 
								for(int i=2014;i<(year+4);i++){ %>
								<div class="btn_add_type" onclick="doChangeYear(this,<%=i %>)"><%=i %></div>
							<%	} %>
						</div>
						<div id="menupanel5" class="menupanel" style="width: 60px;">
							<div class="menutitle">月份</div>
							<%for(int i=1;i<13;i++){ %>
							<div class="btn_add_type" onclick="doChangeMonth(this,<%=i %>)"><%=i %>月</div>
							<%} %>
						</div>
						<div id="menupanel6" class="menupanel" style="width: 60px;">
							<div class="menutitle">季度</div>
							<div class="btn_add_type" onclick="doChangeSeason(this,1)">1季度</div>
							<div class="btn_add_type" onclick="doChangeSeason(this,2)">2季度</div>
							<div class="btn_add_type" onclick="doChangeSeason(this,3)">3季度</div>
							<div class="btn_add_type" onclick="doChangeSeason(this,4)">4季度</div>
						</div>
						<div id="help" style="width: 24px;height: 24px;position: absolute;right: 10px;top: 8px;background: url('../images/icon_help.png') no-repeat;cursor: pointer;z-index:1001;display: none;" title="提示"></div>
					</div>
					<div style="width: 100%;height: 26px;background: url('../images/title_bg_01.png') repeat-x;position: relative;display: none;">
						<div id="changesort" class="main_btn" style="width: 70px;text-align: center;position: absolute;left: 22px;line-height: 26px;top: 0px;border-right: 1px #E4E4E4 solid;border-left: 1px #E4E4E4 solid;color: #786571;cursor: pointer;
							background: url('../images/pull.png') right no-repeat;"
							onclick="showChangeSort()" title="分类显示">
							<div style="float: left;margin-left: 8px;font-family: 微软雅黑;">分类:</div>
							<div class="c_img" style="float:left;width:20px;height:26px;background:url('../images/date.png') center no-repeat;" title="日期"></div>
						</div>
						<div id="changestatus" class="main_btn" style="width: 70px;text-align: center;position: absolute;left: 92px;line-height: 26px;top: 0px;border-right: 1px #E4E4E4 solid;color: #786571;cursor: pointer;
							background: url('../images/pull.png') right no-repeat;"
							onclick="showChangeStatus()" title="状态">
							<div style="float: left;margin-left: 8px;font-family: 微软雅黑;">状态:</div><div class="c_img" style="float:left;width:20px;height:26px;background:url('../images/ing.png') center no-repeat;" title="进行中"></div>
						</div>
						<div id="doadd" class="main_btn" style="width: 60px;text-align: center;position: absolute;right: 0px;line-height: 26px;top: 0px;border-left: 1px #E4E4E4 solid;color: #786571;cursor: pointer;"
							onclick="addItem(0,1)" title="新建">
							<div class="c_img" style="float:left;width:20px;height:26px;background:url('../images/New.png') center no-repeat;margin-left: 5px;" title="新建"></div>
							<div style="float: left;margin-left: 2px;font-family: 微软雅黑;">新建</div>
						</div>
					</div>
					<div id="listview"  style="width: 100%;height: auto;position: relative;"></div>
					
					<div id="ltodopanel" class="ltodopanel" _todotype="">
						<div class="ltodotitle">标记为我的todo</div>
						<div class="ltodoitem" _val="1">今天</div>
						<div class="ltodoitem" _val="2">明天</div>
						<div class="ltodoitem" _val="3">即将</div>
						<div class="ltodoitem" _val="4">不标记</div>
						<div class="ltodoitem" _val="5">备忘</div>
					</div>
				</div>
			</div>
			
			<!-- 明细视图 -->
			<div id="detail" style="width:0px;height:100%;position: absolute;top: 0px;right: 0px;bottom: 1px;z-index: 2;">
				<div id="detaildiv" style="position: absolute;width: auto;height: auto;top:0px;bottom:0px;left:0px;right:0px;background: #fff;border-left: 1px #BFC5CC solid;overflow: hidden;">
				</div>
			</div>
		</div>
		<div id="checknew"></div>
		<script type="text/javascript">
			$.ajaxSetup ({
			    cache: false //关闭AJAX相应的缓存
			});
			var showdetail = <%=showdetail%>;
			
			var userid = "<%=user.getUID()%>";
			var inittaskid = "<%=taskid%>";
			var newMap = new Map();
			var loadstr = "<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background: url(../images/bg_ahp.png) repeat;' align='center'>"
					+"<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background:url(../images/loading1.gif) center no-repeat'></div></div>";

			var statuscond = 1;//默认状态为进行中
			var periodcond = 3;//默认周期未年度
			var periody = <%=year%>;
			var periodm = <%=month%>;
			var periods = <%=season%>;
			var sortcond = 4;//视图类型 默认层级
			<%if(!taskid.equals("")){%>sortcond=3;<%}%>
			var condtype = 1;//默认为我的目标
			var hrmid = "";
			var tag = "";

			var hrmHeight = 0;
			var tagHeight = 0;
					
			var datatype = 0;//数据类型 默认时间安排

			var deffeedback = "";

			var leveltitle = new Array("未设置紧急程度","重要紧急","重要不紧急","不重要紧急","不重要不紧急");

			var listloadststus = 0;
			var detailloadstatus = 0;

			//列表中使用变量
			var defaultname = "";
			var foucsobj = null;
			var detailid = "";
			var currentdate = "<%=TimeUtil.getCurrentDateString()%>";
			var yesterday = "<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),-1)%>";
			var tomorrow = "<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),1)%>";
			var nextweek = "<%=TimeUtil.dateAdd(TimeUtil.getCurrentDateString(),7)%>";
			var olddatetype = null;
			var principalid = "";
			var tag = "";
			var dragstatus = 0;

			//明细中使用变量
			var tempval = "";
			var tempbdate = "";
			var tempedate = "";
			var uploader;
			var oldname = "";
			var foucsobj2 = null;
			var taskid = "";

			var init=1;

			var createmain = false;

			//初始事件绑定
			$(document).ready(function(){

				//隐藏主题页面的左侧菜单
				hideLeftMenu();

				$("#help").bind("mouseover",function(){
					var left = $(this).offset().left-$("#help_content").width()-2;
					$("#help_content").css("left",left).show();
				}).bind("mouseout",function(){
					$("#help_content").hide();
				});
				
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
					datatype = $(this).attr("_datatype");
					var oldct = condtype;
					condtype = $(this).attr("_condtype");
					hrmid = $(this).attr("_hrmid");
					tag = $(this).attr("_tag");
					var mtitle = $($(this).find("div")[0]).html();
					$("#mtitle").html(mtitle);
					$("#micon").css("background","url('../images/title_icon_"+datatype+".png') no-repeat");

					var sortname = "层级";
					<%if(!taskid.equals("")){%>sortname="分类";<%}%>
					$("#mainoperate1").show();
					if(condtype==1 || condtype==2){//我的目标 公司目标 有层级视图
						$("#sorttype_level").show();
						if(condtype==2){//公司目标不能切换视图 只显示层级视图
							sortcond=4;
							$("#mainoperate1").hide();
							sortname = "层级";
						}
					}else{//其他菜单没有层级视图
						$("#sorttype_level").hide();
						if(sortcond==4){
							sortcond=3;
							sortname = "分类";
						}
					}
					if(sortcond==4){
						statuscond=1;
						if(oldct!=sortcond) $("#mainoperate1").css("right","5px").html(sortname);
						$("#mainoperate2").hide();
					}else{
						$("#mainoperate2").css("cursor","pointer").attr("title","点击切换状态");
						if(oldct!=sortcond) $("#mainoperate1").css("right","70px").html(sortname);
						$("#mainoperate2").show();
					}
					
					if(init==0){
						setPosition(1);
					}
				});

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

				//搜索框事件绑定
				$("#objname").FuzzyQuery({
					url:"/workrelate/goal/data/GetData.jsp",
					record_num:5,
					filed_name:"name",
					searchtype:'search',
					divwidth: 400,
					updatename:'objname',
					updatetype:''
				});

				$("label.overlabel").overlabel();

				$("#objname").blur(function(e){
					$(this).val("");
					$("label.overlabel").css("text-indent",0);
				});

				$("div.leftmenu")[0].click();
				if(inittaskid=="") $("#detaildiv").append(loadstr).load("DefaultView.jsp");

				hrmHeight = <%=hrmHeight%>;//$("#hrmdiv").height();
				tagHeight = $("#tagdiv").height();

				init=0;
				setPosition(1);

				//列表页中事件绑定
				$("tr.item_tr").live("mouseenter",function(){
					if(dragstatus==0){
						$(this).addClass("tr_hover");
						var t = $(this).position().top + $("#listscroll").scrollTop();
						//alert($(this).position().top+"-"+$("#listscroll").scrollTop);
						if(t>=0){
							var _taskid = getVal($(this).attr("_taskid"));
							if(_taskid!="") $("#operate_"+_taskid).css("top",t).show();
						}
					}
					
				}).live("mouseleave",function(){
					$(this).removeClass("tr_hover");
					var _taskid = getVal($(this).attr("_taskid"));
					if(_taskid!="") $("#operate_"+_taskid).hide();
				}).live("click",function(e){
					var target=$.event.fix(e).target;
					if(!$(target).hasClass("status") && !$(target).hasClass("item_att") && !$(target).hasClass("div_todo") && !$(target).parent().hasClass("item_hrm")){
						$("tr.item_tr").removeClass("tr_select tr_blur");
						$(this).addClass("tr_select");
						doClickItem($(this).find(".disinput"));
					}
				});
				$("div.operatediv").live("mouseenter",function(){
					var _taskid = getVal($(this).attr("_taskid"));
					if(_taskid!="") $("#item_tr_"+_taskid).addClass("tr_hover");
					$(this).show();
				}).live("mouseleave",function(){
					var _taskid = getVal($(this).attr("_taskid"));
					if(_taskid!="") $("#item_tr_"+_taskid).removeClass("tr_hover");
					$(this).hide();
				});
				//下级目标列表页中事件绑定
				$("tr.subitem_tr").live("mouseover",function(){
					$(this).addClass("tr_sub_hover");
				}).live("mouseout",function(){
					$(this).removeClass("tr_sub_hover");
				}).live("click",function(e){
					var target=$.event.fix(e).target;
					if(!$(target).hasClass("status") && !$(target).hasClass("item_att") && !$(target).parent().hasClass("item_hrm") && !$(target).parent().hasClass("item_view") && !$(target).parent().hasClass("item_add")){
						$("tr.subitem_tr").removeClass("tr_sub_select tr_blur");
						$(this).addClass("tr_sub_select");
						doClickSubItem($(this).find(".subdisinput"));
					}
				});

				$("div.status_do").live("mouseover",function(){
					var _status = $(this).attr("_status");
					$(this).addClass("status"+_status+"_hover");
				}).live("mouseout",function(){
					var _status = $(this).attr("_status");
					$(this).removeClass("status"+_status+"_hover");
				});

				$("input.disinput").live("keyup",function(event) {
					var keyCode = event.keyCode;
					if (keyCode == 40) {//向下
						moveUpOrDown(1,$(this));
					} else if (keyCode == 38) {//向上
						moveUpOrDown(2,$(this));
					} 
				});
				/**
				$("td.item_att").live("click",function(event) {
					var attobj = $(this);
					var _special = $(this).attr("_special");
					var taskid = "";
					if(_special==0 || _special==1){
						taskid = $(this).parent().find("input.disinput").attr("id");
						if(_special==0){
					    	attobj.removeClass("item_att0").addClass("item_att1").attr("_special",1).attr("title","取消关注");
					    	$("#div_att_"+taskid).removeClass("div_att0").addClass("div_att1").attr("_special",1).attr("title","取消关注");
						}else{
							attobj.removeClass("item_att1").addClass("item_att0").attr("_special",0).attr("title","标记关注");
							$("#div_att_"+taskid).removeClass("div_att1").addClass("div_att0").attr("_special",0).attr("title","标记关注");
						}
						$.ajax({
							type: "post",
						    url: "/workrelate/task/data/Operation.jsp",
						    data:{"operation":"set_special","taskid":taskid,"special":_special}, 
						    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						    complete: function(data){
						    	if((foucsobj!=null && ($(foucsobj).attr("id")=="" || typeof($(foucsobj).attr("id"))=="undefined")) || $(foucsobj).attr("id")==taskid){
						    		$("#logdiv").prepend(data.responseText);
								}
							}
					    });
					}
				});
				*/
				$("div.item_att").live("click",function(event) {
					var attobj = $(this);
					var _special = $(this).attr("_special");
					var taskid = "";
					if(_special==0 || _special==1){
						taskid = $(this).parent().attr("_taskid");
						if(_special==0){
					    	attobj.html("取消关注").attr("_special",1).attr("title","取消关注");
					    	$("#div_att_"+taskid).removeClass("div_att0").addClass("div_att1").attr("_special",1).attr("title","取消关注");
						}else{
							attobj.html("添加关注").attr("_special",0).attr("title","添加关注");
							$("#div_att_"+taskid).removeClass("div_att1").addClass("div_att0").attr("_special",0).attr("title","标记关注");
						}
						$.ajax({
							type: "post",
						    url: "/workrelate/goal/data/Operation.jsp",
						    data:{"operation":"set_special","taskid":taskid,"special":_special}, 
						    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						    complete: function(data){
						    	if((foucsobj!=null && ($(foucsobj).attr("id")=="" || typeof($(foucsobj).attr("id"))=="undefined")) || $(foucsobj).attr("id")==taskid){
						    		$("#logdiv").prepend(data.responseText);
								}
							}
					    });
					}
				});
				$("div.operatebtn").live("mouseover",function(){
					$(this).addClass("operatebtn_hover");
				}).live("mouseout",function(){
					$(this).removeClass("operatebtn_hover");
				});

				$("div.mainoperate,div.poperate").bind("click",function(){
					if($(this).attr("id")=="mainoperate2" && sortcond==5) return;
					var _menuid = getVal($(this).attr("_menuid"));
					if(_menuid!=""){
						var l = $(this).position().left+$(this).width()-$("#"+_menuid).width();
						$("#"+_menuid).css({
							"left":l+"px",
							"top":"5px"
						}).show();
					}
				}).bind("mouseover",function(){
					if($(this).hasClass("poperate")){
						if(getVal($(this).attr("_menuid"))!="") $(this).addClass("poperate_hover");
					}
					if($(this).hasClass("mainoperate")) $(this).addClass("mainoperate_hover");
				}).bind("mouseout",function(){
					if($(this).hasClass("poperate")){
						if(getVal($(this).attr("_menuid"))!="") $(this).removeClass("poperate_hover");
					}
					if($(this).hasClass("mainoperate")) $(this).removeClass("mainoperate_hover");
				});
				
				$("div.div_todo").live("mouseover",function(){
					$(this).addClass("div_todo_hover");
				}).live("mouseout",function(){
					$(this).removeClass("div_todo_hover");
				});

				//标记按钮事件绑定
				$("div.ltodoitem").bind("mouseover",function(){
					$(this).addClass("ltodoitem_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("ltodoitem_hover");
				}).bind("click",function(){
					var val = $(this).attr("_val");
					var todotype = $("#ltodopanel").attr("_todotype");
					var todotaskid = $("#ltodopanel").attr("_taskid");
					var todoname = "";
					if(val!=todotype){
						if(val==4) todoname="标记todo";
						else todoname = $(this).html();
						//$("#todo_"+todotaskid).attr("_val",val).attr("title",todoname);

						$.ajax({
							type: "post",
						    url: "/workrelate/goal/data/Operation.jsp",
						    data:{"operation":"edit_field","taskId":todotaskid,"fieldname":5,"fieldvalue":val}, 
						    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
						    complete: function(data){
						    	resetTodo(todotaskid,val,todoname);
						    	if(todotaskid==detailid){
									refreshDetail(todotaskid);
								}
							}
					    });
					}
				});
				$("div.listmore").live("mouseover",function(){
					$(this).addClass("listmore_hover");
				}).live("mouseout",function(){
					$(this).removeClass("listmore_hover");
				});

				$("div.scroll2").perfectScrollbar();
				//$('#listview').perfectScrollbar();
				
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

				//checknew();
				//setInterval(checknew,300000);
				//$('.scroll1').jScrollPane();

			});
		</script>
		<script src="../js/main.js?2"></script>
	</body>
</html>
