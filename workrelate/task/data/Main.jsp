<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="UsrTemplate" class="weaver.systeminfo.template.UserTemplate" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	//读取title
	UsrTemplate.getTemplateByUID(user.getUID(), user.getUserSubCompany1());
	String templateTitle = UsrTemplate.getTemplateTitle();
	
	String taskid = Util.null2String(request.getParameter("taskid"));
	
	boolean hassub = false;
	int hrmHeight = 0;
	//查询下属人员
	int subcount = weaver.workrelate.util.TransUtil.getsubcount(user.getUID()+"");
	//rs.executeSql("select count(id) as amount from hrmresource where loginid<>'' and loginid is not null and (status =0 or status = 1 or status = 2 or status = 3) and managerid=" + user.getUID());
	if(subcount>0) hrmHeight = subcount*26;
	if(hrmHeight>0) hassub = true;
	if(hrmHeight>0 && hrmHeight<26*2) hrmHeight = 26*2;
	//获取数据库记录的视图
	int MENU_TYPE = 1;//我的任务、我负责的任务等
	int LIST_TYPE = 5;//列表视图、个人todo视图等
	int STATUS = 0;//状态 进行中 已完成等
	int viewId = 0;//数据库记录的视图ID
	String SELTAG = "";//搜索关键字
	rs.executeSql("select * from TM_TaskView where userid="+user.getUID());
	if(rs.next()){
		viewId = Util.getIntValue(rs.getString("id"),0);
		MENU_TYPE = Util.getIntValue(rs.getString("menutype"),1);
		LIST_TYPE = Util.getIntValue(rs.getString("listtype"),5);
		if(LIST_TYPE==0) LIST_TYPE = 5;
		STATUS = Util.getIntValue(rs.getString("status"),0);
		SELTAG = Util.null2String(rs.getString("seltag"));
		if(taskid.equals("")){
			taskid = Util.null2String(rs.getString("taskid"));
			if(taskid.equals("0")) taskid = "";
		}
	}
	if(LIST_TYPE==5) STATUS = 1;//todo视图查进行中
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>e-cology执行力平台 - 任务管理</title>
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
		<link rel="stylesheet" href="/workrelate/css/ui/jquery.ui.all.css" />
		<link rel="stylesheet" href="../css/main.css?2" />
		<script language="javascript" src="/workrelate/js/jquery-1.8.3.min.js"></script>
		<script language="javascript" src="../js/jquery.fuzzyquery.min.js"></script>
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
      	<link type='text/css' rel='stylesheet'  href='/workrelate/css/common.css'/>
		<style type="text/css">
		</style>
		<!--[if IE]> 
		<style type="text/css">
			.disinput,.subdisinput{line-height: 28px !important;height: 28px !important;}
			input,textarea{font-family: '微软雅黑';}
			.input_inner{line-height: 26px !important;}
		</style>
		<![endif]-->
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body>
		<div id="main" style="width: 100%;height: 100%;position: absolute;top: 0px;left: 0px;right: 0px;bottom: 0px;">
			<!-- 左侧菜单 -->
			<div id="divmenu" style="width: 248px;height: 100%;" >
				<jsp:include page="/workrelate/Menu.jsp">
					<jsp:param value="4" name="maintype"/>
				</jsp:include>
				<!-- search -->
				<div class="search">
					<label for="objname" class="overlabel">按任务名称、类型或人员搜索</label>
					<input type="text" id="objname" name="objname" class="input_inner" />
				</div>
				
				<div class="lefttitle lefttitle_select" style="">
					<div class="lefttxt">本人</div>
					<%if(HrmUserVarify.checkUserRight("GP_BaseSettingMaint", user)){ %>
					<div style="width: auto;height: 16px;position: absolute;right: 5px;top: 10px;">
						<div style="width: 16px;height: 16px;background: url('/workrelate/goal/images/setting.png');cursor: pointer;
							float:right;margin-right: 5px;" title="设置" onclick="openFullWindowForXtable('/workrelate/task/data/BaseSetting.jsp')"></div>
					</div>
					<%} %>
				</div>
				<div id="mine">
					<div id="mineleft" class="leftmenu leftmenu1" _datatype="0" _condtype="1" _hrmid="" _tag="">
						<div class="cond_txt" title="包括我负责的任务、我参与的任务">我的任务</div>
						<div id="icon1_1" class="cond_icon"></div>
					</div>
					<div class="leftmenu leftmenu3" _datatype="0" _condtype="3" _hrmid="" _tag="">
						<div class="cond_txt" title="我负责的所有任务">我负责的任务</div>
						<div id="icon1_3" class="cond_icon"></div>
					</div>
					<div class="leftmenu leftmenu4" _datatype="0" _condtype="4" _hrmid="" _tag="">
						<div class="cond_txt" title="我参与的所有任务">我参与的任务</div>
						<div id="icon1_4" class="cond_icon"></div>
					</div>
					<div class="leftmenu leftmenu6" _datatype="0" _condtype="6" _hrmid="" _tag="">
						<div class="cond_txt" title="我标记为关注的所有任务">我关注的任务</div>
						<div id="icon1_5" class="cond_icon"></div>
					</div>
					<div class="leftmenu leftmenu2" _datatype="0" _condtype="2" _hrmid="" _tag="">
						<div class="cond_txt" title="我创建的所有任务">我创建的任务</div>
						<div id="icon1_2" class="cond_icon"></div>
					</div>
					<div class="leftmenu leftmenu8" _datatype="0" _condtype="8" _hrmid="" _tag="">
						<div class="cond_txt" title="我分配的所有任务">我分配的任务</div>
						<div id="icon1_9" class="cond_icon"></div>
					</div>
					<div class="leftmenu leftmenu5" _datatype="0" _condtype="5" _hrmid="" _tag="">
						<div class="cond_txt" title="别人分享给我的所有任务">分享给我的任务</div>
						<div id="icon1_6" class="cond_icon"></div>
					</div>
					<div class="leftmenu leftmenu0" _datatype="0" _condtype="0" _hrmid="" _tag="">
						<div class="cond_txt" title="我能够看到的所有任务">所有任务</div>
						<div id="icon1_7" class="cond_icon"></div>
					</div>
					<div class="leftmenu leftmenu7" _datatype="0" _condtype="7" _hrmid="" _tag="">
						<div class="cond_txt" title="已完成并且有新反馈的任务">已完成新反馈任务</div>
						<div id="icon1_8" class="cond_icon"></div>
					</div>
					<div class="leftmenu" _datatype="0" _condtype="9" _hrmid="" _tag="">
						<div class="cond_txt" title="任务执行分析">任务执行分析</div>
						<div id="icon1_10" class="cond_icon"></div>
					</div>
				</div>
				<%if(hassub){%>
				<div class="lefttitle">
					<div class="lefttxt">下属</div>
				</div>
				<div id="hrmdiv" class="scroll2" style="width: 100%;">
					<div id="itemdiv2inner" style="width: auto;height: 100%;position: relative;">
					</div>
				</div>
				<%} %>
				<div class="lefttitle" style="">
					<div class="lefttxt">标签</div>
				</div>
				<div id="tagdiv" class="scroll2" style="width: 100%;">
					<%
						boolean hastag = false;
						String tags = "";
						String tag = "";
						String history = ",";
						rs.executeSql("select t1.tag from TM_TaskInfo t1 where (t1.deleted =0 or t1.deleted is null)"
								+ " and (t1.principalid="+user.getUID()+" or t1.creater="+user.getUID()
								+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+user.getUID()+")"
								+ " or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+user.getUID()+")"
								+ " or exists (select 1 from HrmResource hrm where (hrm.id=t1.principalid or hrm.id=t1.creater) and hrm.managerstr like '%,"+user.getUID()+",%')"
								+ " or exists (select 1 from HrmResource hrm,TM_TaskPartner tp where tp.taskid=t1.id and hrm.id=tp.partnerid and hrm.managerstr like '%,"+user.getUID()+",%')"
								+ ")"
								+"order by createdate desc,createtime desc");
						while(rs.next()){
							tag = Util.null2String(rs.getString("tag"));
							if(!tag.equals("")) tags += tag;
						}
						List tagList = Util.TokenizerString(tags,",");
						for(int i=0;i<tagList.size();i++){
							tag = (String)tagList.get(i);
							if(!tag.equals("") && history.indexOf(","+tag+",")<0){
								history += tag + ",";
								hastag = true;
					%>
					<div class="leftmenu" _datatype="2" _condtype="0" _tag="<%=tag %>">
						<div class="cond_txt" title="包含标签[<%=tag %>]的任务"><%=tag %></div>
						<div class="cond_icon cond_icon30"></div>
					</div>
					<%		}	
						} 
					%>
					<%if(!hastag){ %>
					<div style="color: #818181;font-style: italic;line-height: 22px;">暂无标签</div>
					<%} %>
				</div>
				
				
			</div>
			
			<!-- 中心视图 -->
			<div id="view" style="width:auto;height:100%;position: absolute;top: 0px;left:252px;right: 460px;bottom: 1px;z-index: 3">
				<div style="position: absolute;width: auto;height: auto;top:0px;bottom:0px;left:0px;right:0px;background: #fff;border-right: 1px #BFC5CC solid;border-top: 0px #BFC5CC solid;border-left: 1px #BFC5CC solid;">
					<div style="width: 100%;height: 40px;position: relative;border-bottom: 1px #EFEFEF solid;">
						<div id="micon" style="float: left;margin-left: 14px;margin-top: 7px;width: 25px;height: 25px;background: url('../images/title_icon_0.png') no-repeat;"></div>
						<div id="mtitle" style="float: left;margin-left: 7px;line-height: 38px;font-size: 16px;font-weight: bold;font-family: 微软雅黑"></div>
						<div id="sortname" style="float: left;margin-left: 8px;margin-top: 7px;line-height: 28px;font-family: 微软雅黑;">
						<%if(LIST_TYPE==5){ %>
							--个人Todolist视图
						<%}else if(LIST_TYPE==2){ %>
							--到期日分类视图
						<%}else if(LIST_TYPE==3){ %>
							--紧急程度分类视图
						<%}else if(LIST_TYPE==1){ %>
							--列表视图
						<%}else if(LIST_TYPE==4){ %>
							--层级视图
						<%} %>
						</div>
						<div id="mainoperate2" class="mainoperate" 
						<%if(LIST_TYPE==5){ %>style="display: none;" <%} %>
						_menuid="menupanel2" title="">
							<%if(STATUS==0){ %>
								全部
							<%}else if(STATUS==1){ %>
								进行中
							<%}else if(STATUS==2){ %>
								已完成
							<%}else if(STATUS==3){ %>
								已撤销
							<%} %>
						</div>
						<div id="mainoperate1" class="mainoperate"  _menuid="menupanel1" title="点击切换视图">视图</div>
						<div id="menupanel1" class="menupanel">
							<div class="menutitle">视图</div>
							<div class="btn_add_type" onclick="doChangeSort(this,5)">个人Todolist视图</div>
							<div class="btn_add_type" onclick="doChangeSort(this,2)">到期日分类视图</div>
							<div class="btn_add_type" onclick="doChangeSort(this,3)">紧急程度分类视图</div>
							<div class="btn_add_type" onclick="doChangeSort(this,1)">列表视图</div>
							<div id="sorttype_level" class="btn_add_type" onclick="doChangeSort(this,4)">层级视图</div>
						</div>
						<div id="menupanel2" class="menupanel" style="width: 60px;">
							<div class="menutitle">状态</div>
							<div class="btn_add_type" onclick="doChangeStatus(this,1)">进行中</div>
							<div class="btn_add_type" onclick="doChangeStatus(this,2)">已完成</div>
							<!-- 
							<div class="btn_add_type" onclick="doChangeStatus(this,3)">已撤销</div>
							 -->
							<div class="btn_add_type" onclick="doChangeStatus(this,0)">全部</div>
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
					
					<div id="ltodopanel" class="ltodopanel" _todotype="" style="display: none;">
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
			<div id="detail" style="width:460px;height:100%;position: absolute;top: 0px;right: 0px;bottom: 1px;z-index: 2;">
				<div id="detaildiv" style="position: absolute;width: auto;height: auto;top:0px;bottom:0px;left:0px;right:0px;background: #fff;border-left: 1px #BFC5CC solid;overflow: hidden;">
				</div>
				
				<div id="stodopanel" class="dtodopanel" _todotype="" style="display: none;">
					<div class="ltodotitle">标记为我的todo</div>
					<div class="ltodoitem" _val="1">今天</div>
					<div class="ltodoitem" _val="2">明天</div>
					<div class="ltodoitem" _val="3">即将</div>
					<div class="ltodoitem" _val="4">不标记</div>
					<div class="ltodoitem" _val="5">备忘</div>
				</div>
			</div>
		</div>
		<div id="help_content" style="width:420px;height:380px;position: absolute;top: 26px;z-index: 10;display: none;padding-top:3px;padding-bottom:3px;
			line-height:20px;overflow: hidden;background-color: #FBFDFF;
			border: 1px #53A9FF solid;border-radius: 4px;-moz-border-radius: 4px;-webkit-border-radius: 4px;
			box-shadow:0px 0px 2px #53A9FF;-moz-box-shadow:0px 0px 2px #53A9FF;-webkit-box-shadow:0px 0px 2px #53A9FF;">
			<p>01.&nbsp;&nbsp;在列表中任何位置回车或点击新建按钮都可新建任务</p>
<p>02.&nbsp;&nbsp;列表中新建或编辑任务时输入任务名称后回车或切换鼠标焦点即可保存</p> 
<p>03.&nbsp;&nbsp;列表中通过↑↓键可上下切换任务</p> 
<p>04.&nbsp;&nbsp;具有编辑权限的任务可通过拖动序号进行改变时间或紧急程度</p> 
<p>05.&nbsp;&nbsp;具有编辑权限的任务可通过列表中的快捷按钮改变任务的状态</p> 
<p>06.&nbsp;&nbsp;可通过【分类】切换列表的分类显示规则，默认按日期分类显示</p> 
<p>07.&nbsp;&nbsp;可通过【状态】切换列表中相应状态的记录，默认为进行中</p> 
<p>08.&nbsp;&nbsp;可通过列表中的关注按钮对任务进行“添加关注”或“取消关注”操作</p> 
<p>09.&nbsp;&nbsp;新任务或有新反馈的任务会排列在列表的最前面并有相应的样式提醒</p> 
<p>10.&nbsp;&nbsp;搜索框中可按任务的名称或标签搜索任务，或者搜索某个人员的相关任务</p> 
<p>11.&nbsp;&nbsp;本人有相关的新任务或新反馈时左侧菜单的图标会自动变为红色进行提醒</p> 
<p>12.&nbsp;&nbsp;任务反馈可通过Ctrl+Enter快捷键进行提交</p> 
<p>13.&nbsp;&nbsp;任务中涉及到系统中相关信息(流程、文档等)都可通过输入名称联想或浏
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;览按钮进行选择，其中系统人员可根据名字拼音首字母缩写进行联想匹配</p> 
<p style="color: red;font-size: 14px;font-weight: bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;使用IE9或Chrome浏览器进行访问效果更佳</p> 

		</div>
		<div id="checknew"></div>
		<script type="text/javascript">
			$.ajaxSetup ({
			    cache: false //关闭AJAX相应的缓存
			});
			var userid = "<%=user.getUID()%>";
			var inittaskid = "<%=taskid%>";
			var newMap = new Map();
			var loadstr = "<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background: url(../images/bg_ahp.png) repeat;' align='center'>"
					+"<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background:url(../images/loading1.gif) center no-repeat'></div></div>";

			var viewId = <%=viewId%>;
			var statuscond = <%=STATUS%>;//默认状态为进行中
			var sortcond = <%=LIST_TYPE%>;//默认分类
			var condtype = <%=MENU_TYPE%>;//默认为我的任务
			var hrmid = "";
			var tag = "";

			var hrmHeight = 0;
			var tagHeight = 0;
					
			var datatype = 0;//数据类型 默认时间安排

			var deffeedback = "";

			var leveltitle = new Array("未设置紧急程度","重要紧急","重要不紧急","不重要紧急","不重要不紧急");

			var listloadststus = 0;
			var detailloadstatus = 0;
			var listindexstatus = new Array(5);

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
			var editsubid = "";

			//明细中使用变量
			var tempval = "";
			var tempbdate = "";
			var tempedate = "";
			var uploader;
			var oldname = "";
			var foucsobj2 = null;
			var taskid = "";

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
					if(condtype!=9){
						$("#mtitle").html(mtitle);
					}
					$("#micon").css("background","url('../images/title_icon_"+datatype+".png') no-repeat");

					if(condtype==7){
						sortcond=1;
						$("div.mainoperate").hide();
						$("#sortname").html("");
					}else if(condtype==9){
						openFullWindowHaveBar('/workrelate/task/report/TaskReport.jsp');
						return;
					}else{
						if(oldct==7){
							 sortcond=5;
							 //$("#mainoperate1").css("right","5px");
							 $("#sortname").html("--个人Todolist视图");
						}
						$("div.mainoperate").show();
					}

					if($(this).attr("id")=="mineleft"){
						$("#sorttype_level").show();
					}else{
						$("#sorttype_level").hide();
						if(sortcond==4){
							sortcond=5;
							$("#sortname").html("--个人Todolist视图");
						}
						$("#changesort").children(".c_img").css("background-image","url('../images/date.png')")
						.attr("title","日期");
					}
					if(sortcond==5){
						$("#mainoperate2").hide();
					}
					
					loadList();
					if(inittaskid==""){
						hrmid = <%=user.getUID()%>;
						loadDefault(hrmid);
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
					url:"/workrelate/task/data/GetData.jsp",
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
				//触发左边列表点击事件
				$("div.leftmenu"+condtype).click();
				//$("div.leftmenu")[0].click();
				//if(inittaskid=="") $("#detaildiv").append(loadstr).load("DefaultView.jsp");

				hrmHeight = <%=hrmHeight%>;//$("#hrmdiv").height();
				tagHeight = $("#tagdiv").height();
				setPosition();

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
					if(!$(target).hasClass("status") && !$(target).hasClass("item_att") && !$(target).hasClass("item_status") && !$(target).hasClass("div_todo") && !$(target).parent().hasClass("item_hrm")){
						$("tr.item_tr").removeClass("tr_select tr_blur");
						$(this).addClass("tr_select");
						doClickItem($(this).find(".disinput"));
					}
				});
				$("div.operatediv").live("mouseenter",function(){
					var _taskid = getVal($(this).attr("_taskid"));
					if(_taskid!=""){
						if($(this).hasClass("doperatediv")){
							$("#subitem_tr_"+_taskid).addClass("tr_sub_hover");
						}else{
							$("#item_tr_"+_taskid).addClass("tr_hover");
						}
					}
					
					$(this).show();
				}).live("mouseleave",function(){
					var _taskid = getVal($(this).attr("_taskid"));
					if(_taskid!="") $("#item_tr_"+_taskid).removeClass("tr_hover");
					$(this).hide();
				});
				//下级任务列表页中事件绑定
				$("tr.subitem_tr").live("mouseover",function(){
					$(this).addClass("tr_sub_hover");
					var _taskid = getVal($(this).attr("_taskid"));
					if(editsubid!=_taskid){
						var t = $(this).position().top + $("#maininfo").scrollTop();
						if(_taskid!="") $("#doperate_"+_taskid).css("top",t).show();
					}
				}).live("mouseout",function(){
					$(this).removeClass("tr_sub_hover");
					var _taskid = getVal($(this).attr("_taskid"));
					if(_taskid!="") $("#doperate_"+_taskid).hide();
				}).live("click",function(e){
					var target=$.event.fix(e).target;
					if(!$(target).hasClass("status") && !$(target).hasClass("item_att") && !$(target).hasClass("item_status") && !$(target).hasClass("div_todo_d") && !$(target).parent().hasClass("item_hrm") && !$(target).parent().hasClass("item_view") && !$(target).parent().hasClass("item_add")){
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
				$("div.operatebtn").live("mouseover",function(){
					$(this).addClass("operatebtn_hover");
				}).live("mouseout",function(){
					$(this).removeClass("operatebtn_hover");
				});

				$("div.mainoperate").bind("click",function(){
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
					$(this).addClass("mainoperate_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("mainoperate_hover");
				});

				
				$("div.div_todo").live("mouseover",function(){
					$(this).addClass("div_todo_hover");
				}).live("mouseout",function(){
					$(this).removeClass("div_todo_hover");
				});
				$("div.div_todo_d").live("mouseover",function(){
					$(this).addClass("div_todo_d_hover");
				}).live("mouseout",function(){
					$(this).removeClass("div_todo_d_hover");
				});

				//标记按钮事件绑定
				$("div.ltodoitem").bind("mouseover",function(){
					$(this).addClass("ltodoitem_hover");
				}).bind("mouseout",function(){
					$(this).removeClass("ltodoitem_hover");
				}).bind("click",function(){
					var val = $(this).attr("_val");
					var todotype = $(this).parent().attr("_todotype");
					var todotaskid = $(this).parent().attr("_taskid");
					var todoname = "";
					if(val!=todotype){
						if(val==4) todoname="标记todo";
						else todoname = $(this).html();
						//$("#todo_"+todotaskid).attr("_val",val).attr("title",todoname);

						$.ajax({
							type: "post",
						    url: "/workrelate/task/data/Operation.jsp",
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

				checknew();
				setInterval(checknew,300000);
				//$('.scroll1').jScrollPane();

			});

		</script>
		<script src="../js/main.js?4"></script>
	</body>
</html>
