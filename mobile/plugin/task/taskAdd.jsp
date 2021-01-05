<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.general.*"%>
<%@page import="weaver.file.FileUpload"%>
<%@ page import="java.net.URLDecoder"%>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<%
	request.setCharacterEncoding("UTF-8");
	FileUpload fu = new FileUpload(request);
	String clienttype = Util.null2String((String)fu.getParameter("clienttype"));
	String clientlevel = Util.null2String((String)fu.getParameter("clientlevel"));
	String module=Util.null2String((String)fu.getParameter("module"));
	String scope=Util.null2String((String)fu.getParameter("scope"));
	
	String param = "clienttype="+clienttype+"&clientlevel="+clientlevel+"&module="+module+"&scope="+scope;
	String level = "";
	String principalid = user.getUID()+"";
	String dutyMan = user.getLastname();
	String enddate = "";
	String todo = "4";
	
	//视图判断和默认值
	String sorttype = Util.fromScreen3(fu.getParameter("sorttype"), user.getLanguage());
	String datetype = Util.fromScreen3(fu.getParameter("datetype"), user.getLanguage());
	if(sorttype.equals("5")&&!datetype.equals("")){
		todo = datetype;
	}
	String currentDate = TimeUtil.getCurrentDateString();
	String yesterday = TimeUtil.dateAdd(currentDate,-1);
	String tomorrow = TimeUtil.dateAdd(currentDate,1);
	if(sorttype.equals("2")){//到期日视图
		if(datetype.equals("1")){
			enddate = yesterday;
		}else if(datetype.equals("2")){
			enddate = currentDate;
		}else if(datetype.equals("3")){
			enddate = tomorrow;
		}else if(datetype.equals("4")){
			enddate = TimeUtil.dateAdd(tomorrow,1);
		}else if(datetype.equals("5")){
			enddate = "";
		}
	}
	if(sorttype.equals("3")){//紧急程度视图
		level = datetype;
	}
	if(level.equals("5")) level="0";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		<meta name="author" content="Weaver E-Mobile Dev Group" />
		<meta name="description" content="Weaver E-mobile" />
		<meta name="keywords" content="weaver,e-mobile" />
		<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
		<script type='text/javascript' src='/mobile/plugin/task/js/jquery-1.8.3.js'></script>
		<!-- ajax提交form表单 -->
		<script type='text/javascript' src='/mobile/plugin/task/js/jquery.form.js'></script>
		<script type='text/javascript' src='/mobile/plugin/task/js/task.js'></script>
		<!-- 多行文本框自动更改高度 -->
		<script type='text/javascript' src='/mobile/plugin/task/js/jquery.textarea.autoheight.js'></script>
		<!--弹出框-->
		<script type="text/javascript" src="/js/mylibs/asyncbox/AsyncBox.v1.4.js"></script>
		<link rel="stylesheet" href="/js/mylibs/asyncbox/skins/ZCMS/asyncbox.css" />
		<!--日期时间控件-->
		<link rel="stylesheet" href="/js/mylibs/mobiscroll/mobiscroll.min.css" />
		<script type="text/javascript" src="/js/mylibs/mobiscroll/mobiscroll.min.js"></script>
		<!-- 遮罩层 -->
		<script type='text/javascript' src='/mobile/plugin/task/js/showLoading/js/jquery.showLoading.js'></script>
		<link rel="stylesheet" href="/mobile/plugin/task/js/showLoading/css/showLoading.css" />
		
		<link rel="stylesheet" href="/mobile/plugin/task/css/task.css" />
		<link rel="stylesheet" href="/mobile/plugin/task/css/add.css" />
		<style type="text/css">
			<%if("".equals(clienttype)||clienttype.equals("Webclient")){%>
				#header{display: block;}
			<%}%>
			.subLink{
				line-height:26px;
				border-bottom: 1px solid #f0f0f0;
				color:blue;
				cursor:pointer;
				width:50px;
				height:26px;
			}
			#userChooseDiv{
				position:fixed;
			    left: 100%;
			    top: 0px;
			    width: 100%;
			    height: 100%;
			    z-index: 99999;
			}
			body.hrmshow #userChooseDiv{
				left:0;
			}
			#userChooseFrame{
				width: 100%;
			    height: 100%;
			}
		</style>
		<title>新建任务</title>
	</head>
	<body id="body">
		<form id="form1" name="form1" action="/mobile/plugin/task/addOperation.jsp" method="post">
		<input type="hidden" id="operation" name="operation" value="add"/>
		<input type="hidden" id="sorttype" name="sorttype" value="5"/>
		<input type="hidden" id="relateadd" name="relateadd" value="1"/>
		<input type="hidden" id="datetype" name="datetype" value=""/>
		<input type="hidden" id="lev" name="lev" value="<%=level %>"/>
		<table class="taskTable" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="top">
					<div id="topmain" class="topmain"><!-- 顶部 -->
						<div id="header">
							<table style="width: 100%;height: 40px;">
								<tr>
									<td width="10%" align="left" valign="middle" style="padding-left:5px;">
										<div class="taskTopBtn" onclick="doBack()">返回</div>
									</td>
									<td align="center" valign="middle">
										<div id="title">任务</div>
									</td>
									<td width="10%" align="right" valign="middle" style="padding-right:5px;">
										<div id="rightBtn" class="taskTopBtn" onclick="doSubmit()">保存</div>
									</td>
								</tr>
							</table>
						</div>
					</div>
					<div id="tabblank" class="tabblank"></div><!-- 站位顶部导航FIXED的空白 -->
					<div class="list"><!-- 数据展示 -->
						<div id="dtitle0" class="dtitle"><div class="dtxt">基本信息</div><div class="pullDown"></div></div>
						<table class="datatable">
							<colgroup><col width="25%" /><col width="75%" /></colgroup>
							<tbody>		
								<tr>
									<td class="title">名称</td>
									<td class="data">
								  		<input type="text" class="input_def" id="taskName" name="taskName" value=""/>
								  	</td>
								</tr>
								<tr>
									<td class="title">标记todo</td>
									<td id="todo_td" class="data" style="padding-top: 2px;padding-left: 5px;">
									  	<a id="todo1" class="slink <%if("1".equals(todo)){%>sdlink<%}%>" href="javascript:setTodo(1)">今天</a>
									  	<a id="todo2" class="slink <%if("2".equals(todo)){%>sdlink<%}%>" href="javascript:setTodo(2)">明天</a>
									  	<a id="todo3" class="slink <%if("3".equals(todo)){%>sdlink<%}%>" href="javascript:setTodo(3)">即将</a>
									  	<a id="todo4" class="slink <%if("4".equals(todo)){%>sdlink<%}%>" href="javascript:setTodo(4)">不标记</a>
									  	<a id="todo5" class="slink <%if("5".equals(todo)){%>sdlink<%}%>" href="javascript:setTodo(5)">备忘</a>
								  		<input type="hidden" id="todo" name="todo" value="<%=todo %>"/>
								  	</td>
								</tr>
								<tr>
								  	<td class="title">描述</td>
								  	<td class="data">
								  		<textarea class="content_def" id="remark" name="remark"></textarea>
								  	</td>
								</tr>
								<tr>
									<td class="title">责任人</td>
									<td class="data">
										<div class="txtlink" id="dutyMan"><%=dutyMan %></div>
										<div onclick="selectUser('dutyManId','dutyMan',0)" class="btn_browser"></div>
										<input type="hidden" id="dutyManId" name="principalid" value="<%=principalid %>" />
								  	</td>
								</tr>
								<tr>
									<td class="title">参与人</td>
									<td class="data">
										<div class="txtlink" id="partenr"></div>
										<div onclick="selectUser('partnerid','partenr',1)" class="btn_browser"></div>
										<input type="hidden" id="partnerid" name="partnerid" value="" />
								  	</td>
								</tr>
								<tr>
									<td class="title">结束日期</td>
									<td class="data">
										<input type="text" class="scroller_date input_def" name="enddate" id="enddate" value="<%=enddate %>" readonly="readonly" />
									</td>
								</tr>
							</tbody>
				  		</table>
				  		<div id="dtitle0" class="dtitle"><div class="dtxt">下级任务</div><div class="pullDown"></div></div>
						<table class="datatable">
							<tr>
								<td class="data" id="subTaskTd">
									<div>
										<table width="100%">
											<tr>
												<td width="*"><input type="text" placeholder="新建下级任务" class="input_def subTask" name="subTask"/></td>
												<td width="50">
													<div class="subLink" id="subMan_0_name" hid_id="subMan_0_id">
														<span keyid="<%=principalid %>"><%=dutyMan %></span>
													</div>
													<input type="hidden" id="subMan_0_id" name="subMan" value="<%=principalid %>" />
												</td>
											</tr>
										</table>
									</div>
								</td>
							</tr>
						</table>
						<table class="datatable">
							<tr>
								<td align="center" style="padding-top:20px;">
									<table width="100%">
										<tr>
											<td width="50%" align="center">
											<div onclick="doSubmit()" style="float:right;margin-right:20px;" class="btn_feedback2">提交</div></td>
											<td width="50%" align="center"><div onclick="doBack()"  style="float:left;margin-left:20px;" class="btn_feedback2">取消</div></td>
										</tr>
									</table>
								</td>
							</tr>
						</table>
					</div>
			</td>
		</tr>
		</table>
		</form>
		
		<div id="userChooseDiv">
			<iframe id="userChooseFrame" src="/mobile/plugin/plus/browser/hrmBrowser.jsp" frameborder="0" scrolling="auto">
			</iframe>
		</div>
	<script language="javascript">
	var param = "<%=param%>";
	$(document).ready(function(){
	
		$("#tabblank").height($("#topmain").height());//占位fixed出来的空间
		$('.scroller_date').mobiscroll().date({//日历控件初始化
			theme: "Jquery Mobile",
            mode: "Scroller",
            display: "bottom",
	        preset: 'date',
	        dateFormat:'yy-mm-dd',
	        endYear:2050,
	        nowText:'今天',
	        setText:'确定',
	        cancelText:'取消',
	        monthText:'月',
	        yearText:'年',
	        dayText:'日',
	        showNow:true,
	        dateOrder: 'yymmdd'
	    });  
	    //控制多行文本框自动伸缩
	    $("textarea").textareaAutoHeight({minHeight:24});
	    //单行文本输入框事件绑定
		$(".input_def").bind("mouseover",function(){
			$(this).addClass("input_over");
		}).bind("mouseout",function(){
			$(this).removeClass("input_over");
		}).bind("focus",function(){
			$(this).addClass("input_focus");
		}).bind("blur",function(){
			$(this).removeClass("input_focus");
		});
		//多行文本输入框事件绑定
		$(".content_def").bind("mouseover",function(){
			$(this).addClass("content_over");
		}).bind("mouseout",function(){
			$(this).removeClass("content_over");
		}).bind("focus",function(){
			$(this).addClass("content_focus");
			tempval = $(this).html();
		}).bind("blur",function(){
			$(this).removeClass("content_focus");
		});
		//点击展示隐藏的标签页内容
		$(".dtitle").click(function(){
			if(!$(this).hasClass("noHide")){
				$(this).next().toggle();
				if($(this).find(".pullDown").hasClass("pullUp")){
					$(this).find(".pullDown").removeClass("pullUp");
				}else{
					$(this).find(".pullDown").addClass("pullUp");
				}
			}
			if($(this).attr("type")=="subTask"){//如果是第一次展开下级任务则加载一次
				showSubTask();
				$(this).attr("type","");//再次点击不在加载
			}	
		});
		//下级任务绑定
		var subIndex = 1;
		$(".subTask").live("blur",function(){
			var value = $.trim($(this).val());
			if(value!=""&&$(this).hasClass("default_subTask")){//有内容则将默认标记去除
				$(this).removeClass("default_subTask");
			}
			if(value!=""&&$(".default_subTask").length<=0){//有内容并且没有默认输入框 新增一个
				var name = "subMan_"+subIndex+"_name";
				var id = "subMan_"+subIndex+"_id";
				subIndex++;
				var temp = '<div><table width="100%"><tr>'+
				'<td width="*"><input type="text" placeholder="新建下级任务" class="input_def subTask default_subTask" name="subTask"/></td>'+
				'<td width="50"><div class="subLink" id="'+name+'" hid_id="'+id+'">'+
				'<span keyid="<%=principalid %>"><%=dutyMan %></span></div>'+
				'<input type="hidden" id="'+id+'" name="subMan" value="<%=principalid %>" />'+
				'</td></tr></table></div>';
				$("#subTaskTd").append(temp);
			}
		});
		//下级任务责任人选择事件
		$(".subLink").live("click",function(){
			var name = $(this).attr("id");
			var id = $(this).attr("hid_id");
			selectUser(id,name,0)
		});
	});
	function doSubmit(){//提交表单
		var name = $("#taskName").val();
		if(name==""){
			alert("任务名称不能为空！");
			$("#taskName").focus();
			return;
		}
		$("#datetype").val($("#todo").val());
		showLoading();
		$("#form1").ajaxSubmit({
			dataType:"json",
			success:function(data){
				if(data.status==0){
					window.location.href = "/mobile/plugin/task/taskMain.jsp?<%=param%>";
				}else{
					alert(data.msg);
				}
			},
			error:function(data){
				alert(data);
			},
			complete:function(){
				hideLoading();
			}
		});
	}
	function setTodo(value){//标记今天明天
		$("#todo_td").children(".slink").removeClass("sdlink");
		$("#todo"+value).addClass("sdlink");
		$("#todo").val(value);
	}
	function selectUser(rID,rField,isMuti){//选择人员入口
		<%if("".equals(clienttype)||clienttype.equals("Webclient")){%>
			top._BrowserWindow = window;
			$("#userChooseFrame")[0].contentWindow.resetBrowser({
				"fieldId" : rID,
				"fieldSpanId" : rField,
				"browserType" : (isMuti == "1") ? "1" : "2",
				"selectedIds" : $("#" + rID).val()
			});
			$(document.body).addClass("hrmshow");
		<%}else{%>
			var selids = $("#"+rID).val();
			var url = 'emobile:Browser:HRMRESOURCE:'+isMuti+':'+selids+':setBrowserData:'+rID+':'+rField+':请选择';
			showDialog2(url);
		<%}%>
	}
	function onBrowserBack(){
		$(document.body).removeClass("hrmshow");
	};
	
	function onBrowserOk(result){
		var fieldId = result["fieldId"];
		var fieldSpanId = result["fieldSpanId"];
		var idValue = result["idValue"];
		var nameValue = result["nameValue"];
		$("#"+fieldId).val(idValue);
		$("#"+fieldSpanId).html(nameValue);
		$(document.body).removeClass("hrmshow");
	};
	
	function showDialog2(url){//选择人员弹出框
		window.open(url);
	}

	function setBrowserData(fieldId,fieldSpan,rtnValues,rtnNames,param){
		if(param==0){
			$("#"+fieldSpan).html(rtnNames);
			$("#"+fieldId).val(rtnValues);
		}
	}
	function closeDialog() {//选择完人员回调函数
		$.close("selectionWindow");
	}
	
	function getDialogId() {
		return "selectionWindow";
	}
	
	function getLeftButton(){ 
		return "1,<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>";
	}
	function getRightButton(){ 
		return "1,保存";
	}
	function doRightButton(){
		doSubmit();
		return "1";
	}
	function doLeftButton(){
		doBack();
		return "1";
	}
	function doBack(){
		window.location = "/mobile/plugin/task/taskMain.jsp?"+param;
	}
</script>
</body>
</html>