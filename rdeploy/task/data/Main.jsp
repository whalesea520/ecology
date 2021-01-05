<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.TimeUtil"%>
<jsp:useBean id="UsrTemplate" class="weaver.systeminfo.template.UserTemplate" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<%
	String taskid = Util.null2String(request.getParameter("taskid"));
	boolean hassub = false;
	int hrmHeight = 0;
	//查询下属人员
	int subcount = weaver.workrelate.util.TransUtil.getsubcount(user.getUID()+"");
	if(subcount>0) hrmHeight = subcount*26;
	if(hrmHeight>0) hassub = true;
	if(hrmHeight>0 && hrmHeight<26*2) hrmHeight = 26*2;
	//获取数据库记录的视图
	int MENU_TYPE = 1;//我的任务、我负责的任务等
	int LIST_TYPE = 5;//列表视图、个人todo视图等
	int STATUS = 1;//状态 进行中 已完成等
	int showDetail = Util.getIntValue(request.getParameter("showDetail"),1);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>e-cology执行力平台 - 任务管理</title>
		<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE9" />
		<link rel="stylesheet" href="/workrelate/css/ui/jquery.ui.all.css" />
		<link rel="stylesheet" href="../css/main.css?2" />
		<script language="javascript" src="/workrelate/js/jquery-1.8.3.min.js"></script>
		<script language="javascript" src="/workrelate/task/js/jquery.fuzzyquery.min.js"></script>
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
      	<link type='text/css' rel='stylesheet'  href='../css/common.css'/>
		<!--[if IE]> 
		<style type="text/css">
			.disinput,.subdisinput{line-height: 28px !important;height: 28px !important;}
			input,textarea{font-family: '微软雅黑';}
			.input_inner{line-height: 26px !important;}
			#levelTd input{
				margin-top:10px;
			}
		</style>
		<![endif]-->
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body>
		<div id="main" style="width: 100%;height: 100%;position: absolute;top: 0px;left: 0px;right: 0px;bottom: 0px;">
			<!-- 中心视图 -->
			<div id="view" style="width:45%;height:100%;position: absolute;
				top: 0px;left:0px;bottom: 1px;z-index: 3;<%if(showDetail==0){%>display:none;<%} %>">
				<div style="position: absolute;width: auto;height: auto;top:0px;bottom:0px;left:0px;right:0px;background: #fff;">
					<div style="position:relative;margin-left:10px;overflow: hidden;min-height:45px;">
						<%if(hassub){%>
						<div class="topItem" id="hrmTopDiv" ref="hrmdiv" style="80px;">
							<div class="topText">本人的任务</div>
							<div class="imgdown"></div>	
						</div>
						<%} %>
						<div class="topItem" ref="myTaskDiv" id="myTaskTopDiv" style="<%if(hassub){%>border-left:none;<%}%>width:90px;">
							<div class="topText">我的任务</div>
							<div class="imgdown"></div>	
						</div>
						<div class="topItem" id="todoTopDiv" ref="todoDiv" style="border-left:none;width:100px;">
							<div class="topText" id="todoText">Todolist视图</div>
							<div class="imgdown"></div>	
						</div>
						<div class="topItem" id="statusTopDiv" ref="statusDiv" style="border-left:none;width:60px;<%if(LIST_TYPE==5){ %>display: none;<%} %>">
							<div class="topText">进行中</div>
							<div class="imgdown"></div>	
						</div>
						<div class="topItem" id="searchDiv" ref="" style="border-left:none;min-width:180px;">
							<div class="topText"><input type="text" id="objname" name="objname" 
								placeholder="任务名称/标签/人员"	class="searchInput"/></div>
							<div class="imgSearch"></div>	
						</div>
					</div>
					<div id="hrmdiv" class="scroll2 refDiv">
						<div id="itemdiv2inner" style="width: auto;height: 100%;position: relative;"></div>
					</div>
					<div id="myTaskDiv" class="refDiv">
						<div class="btn_add_type" _condtype="1" id="myTask">待办的</div>
						<div class="btn_add_type" _condtype="3">负责的</div>
						<div class="btn_add_type" _condtype="4">参与的</div>
						<div class="btn_add_type" _condtype="6">关注的</div>
						<div class="btn_add_type" _condtype="2">创建的</div>
						<div class="btn_add_type" _condtype="8">分配的</div>
						<div class="btn_add_type" _condtype="5">分享的</div>
						<div class="btn_add_type" _condtype="9">所有任务</div>
						<div class="btn_add_type" _condtype="7">有新反馈</div>
					</div>
					<div id="todoDiv" class="refDiv">
						<div class="btn_add_type" onclick="doChangeSort(this,5)">Todolist视图</div>
						<div class="btn_add_type" onclick="doChangeSort(this,2)">到期日视图</div>
						<div class="btn_add_type" onclick="doChangeSort(this,3)">紧急程度视图</div>
						<div class="btn_add_type" onclick="doChangeSort(this,1)">列表视图</div>
						<div id="sorttype_level" class="btn_add_type" onclick="doChangeSort(this,4)">层级视图</div>
					</div>
					<div id="statusDiv" class="refDiv">
						<div class="btn_add_type" onclick="doChangeStatus(this,1)">进行中</div>
						<div class="btn_add_type" onclick="doChangeStatus(this,2)">已完成</div>
						<div class="btn_add_type" onclick="doChangeStatus(this,3)">已撤销</div>
						<div class="btn_add_type" onclick="doChangeStatus(this,0)">全部</div>
					</div>
					<div id="listview"  style="width: 100%;height: auto;position: relative;"></div>
				</div>
			</div>
			<!-- 明细视图 -->
			<div id="detail" style="height:100%;position:absolute;top:0px;bottom: 1px;z-index: 2;background:#f7f7f7;<%if(showDetail==0){%>left:0px;width:100%;<%}else{ %>right:0px;width:55%;<%}%>">
				<div id="detaildiv" style="position: absolute;width: auto;height: auto;top:0px;bottom:0px;left:0px;right:0px;background: #f7f7f7;overflow: hidden;">
				</div>
			</div>
		</div>
		<div id="checknew"></div>
		<script type="text/javascript">
			$.ajaxSetup ({
			    cache: false //关闭AJAX相应的缓存
			});
			var userid = "<%=user.getUID()%>";
			var inittaskid = "<%=taskid%>";
			var newMap = new Map();
			var loadstr = "<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background: url(/workrelate/task/images/bg_ahp.png) repeat;' align='center'>"
					+"<div style='position: absolute;top: 0px;bottom: 0px;left: 0px;right: 0px;background:url(/workrelate/task/images/loading1.gif) center no-repeat'></div></div>";

			var viewId = 0;
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
			var tr_taskid = "";
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
				$(".topItem").live("click",function(){//顶部菜单
					var ref = $(this).attr("ref");	
					if(ref!=""){
						var l = $(this).position().left;
						var w = $(this).width();
						if(ref=="hrmdiv") w= 276;
						$("#"+ref).css("left",l+9).css("width",w+6);
						if(ref=="todoDiv2"){
							$("#"+ref).css("top","42px");
						}
						if($("#"+ref).is(":hidden")){
							$(".refDiv").hide();
							$("#"+ref).show();
						}else{
							$("#"+ref).hide();
						}
					}
				});
				
				$("#searchDiv").bind("mouseover",function(){
					$(this).find(".imgSearch").addClass("imgSearch_hover");
				}).bind("mouseleave",function(){
					$(this).find(".imgSearch").removeClass("imgSearch_hover");
				})
				
				$(".btn_add_type").live("mouseover",function(){
					$(this).addClass("btn_add_type_hover");
				}).live("mouseout",function(){
					$(this).removeClass("btn_add_type_hover");
				});

				$("#myTaskDiv").find(".btn_add_type").bind("click",function(){
					datatype = 0;
					var oldct = condtype;
					condtype = $(this).attr("_condtype");
					hrmid = "";
					tag = "";
					var mtitle = $(this).html();
					$("#myTaskTopDiv").find(".topText").html(mtitle);
					$("#myTaskDiv").hide();
					if(condtype==7){
						sortcond=1;
						$("div.mainoperate").hide();
					}else{
						if(oldct==7){
							 sortcond=5;
						}
					}
					if(condtype==1){
						$("#sorttype_level").show();
					}else{
						$("#sorttype_level").hide();
						if(sortcond==4){
							sortcond=5;
							$("#todoTopDiv").find(".topText").html("Todolist视图");
						}
					}
					loadList();
					if(inittaskid==""){
						hrmid = <%=user.getUID()%>;
						loadDefault(hrmid);
					}
				});
				//触发左边列表点击事件
				$("#myTask").click();
				//搜索框事件绑定
				$("#objname").FuzzyQuery({
					url:"/workrelate/task/data/GetData.jsp",
					record_num:5,
					filed_name:"name",
					searchtype:'search',
					divwidth:200,
					updatename:'objname',
					updatetype:''
				});
				$("#objname").blur(function(e){
					$(this).val("");
				});
				hrmHeight = <%=hrmHeight%>;
				$("#hrmdiv").height(hrmHeight);
				setPosition();
				//列表页中事件绑定
				$("tr.item_tr").live("click",function(e){
					var tr_taskid_new = $(this).attr("_taskid");
					if(tr_taskid==tr_taskid_new){
						//return;
					}
					$("tr.item_tr").removeClass("tr_select tr_blur");
					$(this).addClass("tr_select");
					tr_taskid = tr_taskid_new;
					refreshDetail(tr_taskid);
				}).live("mouseenter",function(){
					$(this).addClass("tr_hover");
				}).live("mouseleave",function(){
					$(this).removeClass("tr_hover");
				});
				//下级任务列表页中事件绑定
				$("tr.subitem_tr").live("click",function(e){
					var tr_taskid_new = $(this).attr("_taskid");
					if(tr_taskid_new!=""){
						loadDetail(tr_taskid_new);
					}
				}).live("mouseover",function(){
					var taskid = $(this).attr("_taskid");
					if(taskid!=""){
						$(this).addClass("tr_sub_hover");
					}else{
						$(this).find(".newInputDiv").addClass("subtr_border1");
					}
				}).live("mouseleave",function(){
					var taskid = $(this).attr("_taskid");
					if(taskid!=""){
						$(this).removeClass("tr_sub_hover");
					}else{
						$(this).find(".newInputDiv").removeClass("subtr_border1");
					}
				});
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
				$("div.listmore").live("mouseover",function(){
					$(this).addClass("listmore_hover");
				}).live("mouseout",function(){
					$(this).removeClass("listmore_hover");
				});
				$("div.scroll2").perfectScrollbar();
				<%if(hassub){%>
			  	//下属人员树初始化
			    $("#hrmdiv").addClass("hrmOrg"); 
			    $("#itemdiv2inner").treeview({
			        url:"/secondwev/tree/hrmOrgTree.jsp",
			        root:"hrm|<%=user.getUID()%>"
			    });
			    $("#itemdiv2inner").prepend('<li id="hrm|0" class=""><span class="person file"><a href="#" style="word-break:break-all" onclick="doClick(0,4,this,\'本人任务\');return false;">本人任务</a></span></li>');
			  	//树形搜索中点击直接展开搜索并展开下属
				$("span.file,span.folder").live("mouseover",function(){
					$(this).addClass("btn_add_type_hover").parent("li").addClass("btn_add_type_hover");
					$(this).find("a").addClass("whiteA");
				}).live("mouseout",function(){
					$(this).removeClass("btn_add_type_hover").parent("li").removeClass("btn_add_type_hover");
					$(this).find("a").removeClass("whiteA");
				});
			    <%}%>
			});
		</script>
		<script src="../js/main.js?2"></script>
	</body>
</html>