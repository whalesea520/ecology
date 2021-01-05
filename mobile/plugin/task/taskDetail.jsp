<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.URLDecoder"%>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.conn.*"%>
<%@page import="weaver.file.FileUpload"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.docs.docs.DocImageManager"%>
<jsp:useBean id="rc" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<%
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragrma","no-cache");
	response.setDateHeader("Expires",0);
	request.setCharacterEncoding("UTF-8");
	
	FileUpload fu = new FileUpload(request);
	
	String clienttype = Util.null2String((String)fu.getParameter("clienttype"));
	String clientlevel = Util.null2String((String)fu.getParameter("clientlevel"));
	String module=Util.null2String((String)fu.getParameter("module"));
	String scope=Util.null2String((String)fu.getParameter("scope"));
	
	String param = "clienttype="+clienttype+"&clientlevel="+clientlevel+"&module="+module+"&scope="+scope;
	
	int ifFb = Util.getIntValue(fu.getParameter("ifFb"),0);
	int taskId = Util.getIntValue(fu.getParameter("taskId"),0);
	int hrmid = Util.getIntValue(fu.getParameter("hrmid"),0);
	if(taskId==0){
		rs.executeSql("select taskid,subuserid from TM_TaskView where userid="+user.getUID());
		if(rs.next()){
			taskId = Util.getIntValue(rs.getString("taskid"),0);
			hrmid = Util.getIntValue(rs.getString("subuserid"),0);
		}
	}else{
		rs.execute("update TM_TaskView set taskid="+taskId+",subuserid="+hrmid+" where userid="+user.getUID());
	}
	if(taskId==0){
		return ;
	}
	int right = cmutil.getRight(taskId+"",user);
	if(right==0){
		String parentid = this.getParentid(taskId+"");//递归查找最顶级任务的ID
		if(!parentid.equals("")){
			rs.executeSql("select showallsub from TM_TaskInfo where id="+parentid);
			if(rs.next()){
				int showallsub = Util.getIntValue(rs.getString(1));
				if(showallsub==1){
					int pright = cmutil.getRight(parentid,user);
					if(pright>0) right = 1;
				}
			}
		}
		if(right==0){
			response.sendRedirect("/mobile/plugin/task/NoRight.jsp?taskId="+taskId+"&"+param);
			return;
		}
	}
	boolean canedit = false;
	if(right==2){
		canedit = true;
	}
	String sql = "select * from TM_TaskInfo where id="+taskId+" and (deleted=0 or deleted is null)";
	rs.executeSql(sql);
	if(rs.getCounts()==0) return;
	rs.next();
	String name = Util.toScreen(rs.getString("name"),user.getLanguage());
	String lev = Util.null2String(rs.getString("lev"));
	String status = Util.null2String(rs.getString("status"));
	String statusstr = "进行中";
	if(status.equals("2")) statusstr = "完成";
	if(status.equals("3")) statusstr = "撤销";
	String remark = Util.toHtml(Util.null2String(rs.getString("remark")));
	String risk = Util.convertDbInput(Util.null2String(rs.getString("risk")));
	String difficulty = Util.convertDbInput(Util.null2String(rs.getString("difficulty")));
	String assist = Util.convertDbInput(Util.null2String(rs.getString("assist")));
	String tag = Util.toScreen(rs.getString("tag"),user.getLanguage());
	String principalid = Util.null2String(rs.getString("principalid"));
	String begindate = Util.null2String(rs.getString("begindate"));
	String enddate = Util.null2String(rs.getString("enddate"));
	String taskids = Util.null2String(rs.getString("taskids"));
	String goalids = Util.null2String(rs.getString("goalids"));
	String docids = Util.null2String(rs.getString("docids"));
	String wfids = Util.null2String(rs.getString("wfids"));
	String meetingids = Util.null2String(rs.getString("meetingids"));
	String crmids = Util.null2String(rs.getString("crmids"));
	String projectids = Util.null2String(rs.getString("projectids"));
	String fileids = Util.null2String(rs.getString("fileids"));
	String creater = Util.null2String(rs.getString("creater"));
	String createdate = Util.null2String(rs.getString("createdate"));
	String createtime = Util.null2String(rs.getString("createtime"));
	String viewdate = Util.null2String(rs.getString("viewdate"));
	String parentid = Util.null2String(rs.getString("parentid"));
	String parentname = "";
	String tododate = Util.null2String(rs.getString("tododate"));
	int showallsub = Util.getIntValue(rs.getString("showallsub"),0);
	if(!parentid.equals("") && !parentid.equals("0")) showallsub = 0;
	//判断是否关注
	int special = 0;
	rs.executeSql("select * from TM_TaskSpecial tts where tts.taskid="+taskId+" and tts.userid="+user.getUID());
	if(rs.next()){
		special = 1;
	}
	
	//记录日志
	String currentDate = TimeUtil.getCurrentDateString();
	String currentTime = TimeUtil.getOnlyCurrentTimeString();
	rs.executeSql("insert into TM_TaskLog (taskid,type,operator,operatedate,operatetime,operatefiled,operatevalue)"
		+" values("+taskId+",0,"+user.getUID()+",'"+currentDate+"','"+currentTime+"','','')");
%>
<!DOCTYPE html>
<html>
<head>
	<meta HTTP-EQUIV="pragma" CONTENT="no-cache">
	<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate">
	<meta HTTP-EQUIV="expires" CONTENT="0">
	
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="author" content="Weaver E-Mobile Dev Group" />
	<meta name="description" content="Weaver E-mobile" />
	<meta name="keywords" content="weaver,e-mobile" />
	<meta name="viewport" content="width=device-width,minimum-scale=1.0, maximum-scale=1.0" />
	<title></title>
	<script type='text/javascript' src='/mobile/plugin/task/js/jquery-1.8.3.js'></script>
	<script type='text/javascript' src='/mobile/plugin/task/js/task.js'></script>
	<!-- 多行文本框自动更改高度 -->
	<script type='text/javascript' src='/mobile/plugin/task/js/jquery.textarea.autoheight.js'></script>
	<!--弹出框-->
	<script type="text/javascript" src="/js/mylibs/asyncbox/AsyncBox.v1.4.js"></script>
	<link rel="stylesheet" href="/js/mylibs/asyncbox/skins/ZCMS/asyncbox.css" />
	<link rel="stylesheet" href="/mobile/plugin/task/css/task.css" />
	<!-- 遮罩层 -->
	<script type='text/javascript' src='/mobile/plugin/task/js/showLoading/js/jquery.showLoading.js'></script>
	<link rel="stylesheet" href="/mobile/plugin/task/js/showLoading/css/showLoading.css" />
	<style type="text/css">
		<%if("".equals(clienttype)||clienttype.equals("Webclient")){%>
			#header{display: block;}
			#showFbDiv{top:40px;}
		<%}%>
	</style>
<%@ include file="/secondwev/common/head.jsp" %>
	</head>
<body id="body">
	<table class="taskTable" cellpadding="0" cellspacing="0">
		<tr>
			<td width="100%" height="100%" valign="top" align="left">
				<div id="topmain" class="topmain">
					<div id="header">
							<table style="width: 100%;height: 40px;table-layout:fixed;">
								<tr>
									<td width="60" align="left" valign="middle">
										<div class="taskTopBtn" onclick="doLeftButton()">返回</div>
									</td>
									<td align="center" valign="middle" class="taskDetailTitle">
										<%=name %>
									</td>
									<td width="10%" align="right" valign="middle" style="padding-right:5px;">
									&nbsp;
									</td>
								</tr>
							</table>
					</div>
				</div>
				<div id="tabblank" class="tabblank"></div>
				<div id="list" class="list">
					<div id="maininfo" class="taskDetail" align="center">
						<div class="dtitle"><div class="dtxt">基本信息</div><div class="pullDown pullUp"></div></div>
						<table class="datatable">
							<COLGROUP><COL width="25%"><COL width="75%"></COLGROUP>
								<TBODY>		
								<tr>
									<td class="title">名称</TD>
									<td class="data">
								  		<div class="div_show task_name"><%=name %></div>
								  	</td>
								</tr>
								<tr>
									<td class="title">状态</TD>
									<td id="tdstatus" class="data"><div class="div_show"><%=statusstr %></div></td>
								</tr>
								<tr>
									<td class="title">责任人</TD>
									<td class="data">
										<div class="div_show"><%=rc.getLastname(principalid) %></div>
								  	</td>
								</tr>
								<tr <%
								rs.executeSql("select partnerid from TM_TaskPartner where taskid="+taskId);
								if(rs.getCounts()==0){ %>style="display: none;"<%} %>>
									<td class="title">参与人</TD>
									<td class="data">
										<%
											String partnerid_val = ",";
											String partnerid = "";
											while(rs.next()){
												partnerid = Util.null2String(rs.getString(1));
												if(!partnerid.equals("0") && !partnerid.equals("")){
												
										%>
										<div class="txtlink">
											<div style="float: left;"><%=rc.getLastname(partnerid) %></div>
										</div>
										<% 		} 
											}
										%>
								  	</td>
								</tr>
								<tr <%if(begindate.equals("")){ %>style="display: none;"<%} %>>
									<td class="title">开始日期</TD>
									<td class="data"><%=begindate %></td>
								</tr>
								<tr <%if(enddate.equals("")){ %>style="display: none;"<%} %>>
									<td class="title">结束日期</TD>
									<td class="data"><%=enddate %></td>
								</tr>
							</TBODY>
				  		</table>
				  		<div class="dtitle" type="subTask"><div class="dtxt">下级任务</div><div class="pullDown"></div></div>
				  		<table class="subdatalist hideTable" id="subTaskTable">
				  			<colgroup><col width='*'/><col width='50px'/></colgroup>
				  			<tr id="subTaskLoadingTr" style="display:none;"><td class="fbLoadingTd" colspan="2">加载中...</td></tr>
				  		</table>	
				  		<div class="dtitle"><div class="dtxt">辅助信息</div><div class="pullDown"></div></div>
				  		<table class="datatable hideTable">
				  			<COLGROUP><COL width="25%"><COL width="75%"></COLGROUP>
				  			<%
				  			boolean ifHasFz = false;
				  			if(!parentid.equals("")&& !parentid.equals("0")){ ifHasFz = true;%>		
						  		<tr>
									<td class="title">上级任务</TD>
									<td class="data">
										<div class="div_show"><%=cmutil.getTaskNameForMobile(parentid) %></div>
								  	</td>
								</tr>
						  	<% }%>
						  	<%if(!lev.equals("")&&!lev.equals("0")){ ifHasFz = true;%>
						  		<tr>
									<td class="title">紧急程度</TD>
									<td class="data">
										<div class="div_show">
								  			<%if("1".equals(lev)){%>
								  			重要紧急
								  			<%}else if("2".equals(lev)){%>
								  			重要不紧急
								  			<%}else if("3".equals(lev)){%>
								  			不重要紧急
								  			<%}else if("4".equals(lev)){%>
								  			不重要不紧急
								  			<%}%>
							  			</div>
								  	</td>
								</tr>
							<%} %>
							<%if(!tag.equals("")){ ifHasFz = true;%>
								<tr>
									<td class="title">任务标签</TD>
									<td class="data">
								  		<%
											List tagList = Util.TokenizerString(tag,",");
											if(tag.equals("")) tag = ",";
											for(int i=0;i<tagList.size();i++){
												if(!"0".equals(tagList.get(i)) && !"".equals(tagList.get(i))){
										%>
										<div class="txtlink">
											<div style="float: left;"><%=tagList.get(i) %></div>
										</div>
										<% 		} 
											}
										%>
								  	</td>
								</tr>
							<%} %>	
							<%if(!remark.equals("")){ ifHasFz = true;%>
								<tr>
								  	<td class="title">描述</TD>
								  	<td class="data">
								  		<div class="div_show"><%=remark %></div>
								  	</td>
								</tr>
							<%} %>	
							<%if(!risk.equals("")){ ifHasFz = true;%>
								<tr>
								  	<td class="title">风险点</TD>
								  	<td class="data">
								  		<div class="div_show"><%=risk %></div>
								  	</td>
								</tr>
							<%} %>	
							<%if(!difficulty.equals("")){ ifHasFz = true;%>
								<tr>
								  	<td class="title">难度点</TD>
								  	<td class="data">
								  		<div class="div_show"><%=difficulty %></div>
								  	</td>
								</tr>
							<%} %>	
							<%if(!assist.equals("")){ ifHasFz = true;%>
								<tr>
								  	<td class="title">需协助点</TD>
								  	<td class="data">
								  		<div class="div_show"><%=assist %></div>
								  	</td>
								</tr>
							<%} %>
							<%if(!ifHasFz){ %>	
								<tr><td><div class='taskTips'>没有辅助信息</div></td></tr>
							<%} %>
				  		</table>
				  		<div class="dtitle"><div class="dtxt">相关信息</div><div class="pullDown"></div></div>
				  		<table class="datatable hideTable">
							<COLGROUP><COL width="25%"><COL width="75%"></COLGROUP>
							<TBODY>
								<%
								boolean ifHasRelate = false;
								if(!taskids.equals("")&&!taskids.equals(",")){ifHasRelate=true; %>
								<tr>
									<td class="title">相关任务</TD>
									<td class="data">
										<%
											List taskidList = Util.TokenizerString(taskids,",");
											if(taskids.equals("")) taskids = ",";
											for(int i=0;i<taskidList.size();i++){
												if(!"0".equals(taskidList.get(i)) && !"".equals(taskidList.get(i))){
										%> 
										<div class="txtlink">
											<div style="float: left;"><%=cmutil.getTaskNameForMobile((String)taskidList.get(i)) %></div>
										</div>
										<% 		} 
											}
										%>
								  	</td>
								</tr>
								<%} %>
								<%
								  	//查找关联此任务的其他任务
								  	rs2.executeSql("select id from TM_TaskInfo where (deleted=0 or deleted is null) and taskids like '%,"+taskId+",%' order by id desc");
								  	if(rs2.getCounts()>0){
								  		ifHasRelate = true;
								%>
								<tr>
									<td class="title">被关联任务</td>
									<td class="data">
								  		<%	while(rs2.next()){ %>	
								  			<%=cmutil.getTaskNameForMobile(Util.null2String(rs2.getString(1))) %>
								  		<%	} %>
								  	</td>
								</tr>
								<%}%>
								<%if(!docids.equals("")&&!docids.equals(",")){ifHasRelate=true; %>
								<tr>
									<td class="title">相关文档</TD>
									<td class="data">
										<div class="txtlink">
											<div style="float: left;"><%=cmutil.getDocNameForMobile(docids) %></div>
										</div>
								  	</td>
								</tr>
								<%} %>
								<%if(!wfids.equals("")&&!wfids.equals(",")){ifHasRelate=true; %>
								<tr>
									<td class="title">相关流程</TD>
									<td class="data">
										<div class="txtlink">
											<div style="float: left;"><%=cmutil.getRequestNameForMobile(wfids) %></div>
										</div>
								  	</td>
								</tr>
								<%} %>
								<%if(!crmids.equals("")&&!crmids.equals(",")){ifHasRelate=true; %>
								<tr>
									<td class="title">相关客户</TD>
									<td class="data">
										<div class="txtlink">
											<div style="float: left;"><%=cmutil.getCustomerForMobile(crmids) %></div>
										</div>
								  	</td>
								</tr>
								<%} %>
								<%if(!projectids.equals("")&&!projectids.equals(",")){ifHasRelate=true; %>
								<tr>
									<td class="title">相关项目</TD>
									<td class="data">
										<div class="txtlink">
											<div style="float: left;"><%=cmutil.getProjectForMobile(projectids) %></div>
										</div>
								  	</td>
								</tr>
								<%} %>
								<%if(!fileids.equals("")&&!fileids.equals(",")){ifHasRelate=true; %>
								<tr>
									<td class="title">相关附件</TD>
									<td id="filetd" class="data">
										<div class='txtlink'>
											<div style='float: left;'>
												<%=cmutil.getFileNameForMobile(fileids) %>
											</div>
										</div>
									</td>
								</tr>
								<%} %>
								<%if(!ifHasRelate){ %>	
								<tr><td><div class='taskTips'>没有相关信息</div></td></tr>
								<%} %>
							</TBODY>
						</table>
				  		<div class="dtitle noHide">
				  			<div class="dtxt clickDtxt" type="1">任务反馈</div>
				  			<div class="dtxt" type="2">操作日志</div>
				  		</div>
				  		<table class="datatable" id="feedbacktable">
				  			<tr id="fbLoadingTr" style="display:none;"><td class="fbLoadingTd">加载中...</td></tr>
				  		</table>
				  		<table class="datatable" style="display:none;" id="logtable">
				  			<tr id="logLoadingTr" style="display:none;"><td class="fbLoadingTd">加载中...</td></tr>
				  		</table>
					</div>					
				</div>
				<div id="tabblankBottom" class="tabblank" style="height:50px;"></div>
		</td>
	</tr>
	</table>
	<!-- 底部操作按钮START -->
	<div id="taskBottom" class="detailBottom">
		<table class="bottomTable">
			<colgroup>
				<%if(canedit){ %>
					<col width="25%" /><col width="25%" /><col width="25%" /><col width="25%" />
				<%}else{ %>
					<col width="50%" /><col width="50%" />
				<%} %>
			</colgroup>
			<tr>
				<td type="2" id="taskFbTd" class="taskFbTd">反馈</td>
				<td type="1" special="<%=special %>" class="<%if(special==0){ %>taskFav<%}else{ %>taskFavOk<%} %>">
				<%if(special==0){out.print("关注");}else{out.print("取消关注");} %>	
				</td>
				<%if(canedit){ %>
				<td type="3" status="<%=status %>" 
					<%if(status.equals("1")){ %>
						class="taskComplete"
					<%}else{ %>
						class="taskCompleteOk"
					<%} %>">
					<%if(status.equals("1")){//status为1表示当前状态是进行中 %>
						完成
					<%}else{ %>
						取消完成
					<%} %>
				</td>
				<td type="4" status="4" class="taskDel">删除</td>
				<%} %>
			</tr>
		</table>
	</div>
	<!-- 底部操作按钮END -->
	
	<!-- 反馈界面START -->
	<div id="showFbDiv">
		<table width="100%">
			<tr>
				<td class="data" align="center">
					<textarea id="fbContent"></textarea>
					<input type="hidden" id="replyid"/>
				</td>
			</tr>
			<tr id="fbOperateTr">
				<td>
					<div class="fbOperate">
						<div onclick="doFeedback()" class="btn_feedback" title="Ctrl+Enter">提交</div>
						<div onclick="doCancel()" class="btn_feedback" style="margin-left: 10px;">取消</div>
						<div id="fbrelatebtn" class="fb_extra" _status="0">附加信息</div>
					</div>
					<div class="feedrelate">
					<table class="datatable" align="center">
						<TBODY>
							<tr>
								<td class="title" width="100">相关文档</TD>
								<td class="data" width="*">
							  		<div class="txtlink" id="docDiv"></div>
									<div onclick="selectData('docId','docDiv',1,'listDocument')" class="btn_browser"></div>
							  		<input type="hidden" id="docId" value=""/>
							  	</td>
							</tr>
							<tr>
								<td class="title">相关流程</TD>
								<td class="data">
							  		<div class="txtlink" id="wfDiv"></div>
									<div onclick="selectData('wfId','wfDiv',1,'listWorkflowRequest')" class="btn_browser"></div>
							  		<input type="hidden" id="wfId" value=""/>
							  	</td>
							</tr>
							<tr>
								<td class="title">相关客户</TD>
								<td class="data">
							  		<div class="txtlink" id="crmDiv"></div>
									<div onclick="selectData('crmId','crmDiv',1,'listCustomer')" class="btn_browser"></div>
							  		<input type="hidden" id="crmId" value=""/>
							  	</td>
							</tr>
							<tr>
								<td class="title">相关项目</TD>
								<td class="data">
							  		<div class="txtlink" id="prjDiv"></div>
									<div onclick="selectData('prjId','prjDiv',1,'listProject')" class="btn_browser"></div>
							  		<input type="hidden" id="prjId" value=""/>
							  	</td>
							</tr>
							<!-- 
							<tr>
								<td class="title">相关附件</TD>
								<td class="data">
							  		<input type="file" />
							  	</td>
							</tr>
							 -->
						</TBODY>
					</table>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<!-- 反馈界面 END-->
	<script type="text/javascript">
		var param = "<%=param%>";
		var isFbStatus = false;//标记当前是否处于反馈状态，用来改变顶部左侧返回按钮返回的位置
		var scrollTop = 0;//记录反馈之前页面的滚动高度
		var pageNum = 1;//记录当前显示的反馈记录的页数
		var totalPage = 1;//记录当前反馈的总页数
		var pageNumForLog = 0;//记录日志显示页数
		var totalPageForLog = 1;//记录日志总记录数
		var ifLoadMore = false;//是否正在加载更多
		var scrollType = 1;//滚动的时候加载反馈记录还是日志记录
		$(document).ready(function(){
			$("#tabblank").height($("#topmain").height());//占位fixed出来的空间
			$("#tabblankBottom").height($("#taskBottom").height());//占位fixed出来的空间
			
			$("textarea").textareaAutoHeight({minHeight:80});
			
			$("#fbrelatebtn").click(function(){//附加信息
				var _status = $(this).attr("_status");
				if(_status==0){
					$("div.feedrelate").show();
					$(this).attr("_status",1).css("background", "url('/mobile/plugin/task/images/fb_up.png') right no-repeat");
				}else{
					$("div.feedrelate").hide();
					$(this).attr("_status",0).css("background", "url('/mobile/plugin/task/images/fb_down.png') right no-repeat");
				}
			});
			$("#taskBottom .bottomTable tr td").click(function(){//下方按钮点击事件
				var type = $(this).attr("type");
				if(type==1){//添加关注
					addFav($(this));
				}else if(type==2){//反馈
					showFb();
				}else if(type==3){//标记完成、进行
					<%if(canedit){%>
					var status = $(this).attr("status");
					if(status==1){//为1表示当前状态是进行中，进行的操作时标记完成
						setFinish($(this),2);
					}else if(status==2){
						setFinish($(this),1);
					}
					<%}%>
				}else if(type==4){//删除任务
					<%if(canedit){%>
					setFinish($(this),4);
					<%}%>
				}
			});
			$("#fbContent").bind("focus",function(){
				$(this).addClass("feedback_focus");
			}).bind("blur",function(){
				$(this).removeClass("feedback_focus");
			});
			if(<%=ifFb%>==1){//触发反馈事件
				showFb();
			}
			//进入触发一次加载反馈事件
			getMoreFb();
			//滚动到底部触发加载更多反馈事件
			$(window).scroll(function() { 
			 	var totalheight = parseFloat($(window).height()) + parseFloat($(window).scrollTop()); 
				if ($(document).height()-2<= totalheight) {  // 说明滚动条已达底部
					if(!isFbStatus){//在反馈界面不执行
						if(scrollType==1)
							getMoreFb();
						else
							getMoreLog();	
					}	
				}
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
			//任务反馈和操作日志内容切换
			$("div.noHide .dtxt").click(function(){
				$("div.noHide .dtxt").removeClass("clickDtxt");
				$(this).addClass("clickDtxt");
				if($(this).attr("type")==1){//任务反馈
					$("#logtable").hide();
					$("#feedbacktable").show();
					scrollType = 1;
				}else if($(this).attr("type")==2){
					$("#feedbacktable").hide();
					$("#logtable").show();
					scrollType = 2;
					if(pageNumForLog==0){//
						pageNumForLog++;
						getMoreLog();
					}
				}
			});
		});
		
		function showFb(){//点击反馈操作
			scrollTop = $(window).scrollTop();
			$(window).scrollTop(0);
			//$("#body").css("overflow","hidden");//隐藏滚动条
			$("#showFbDiv").css("height",$(document).height()).show();//计算遮罩层高度并显示
			$("#fbContent").focus();//文本框获取焦点
			isFbStatus = true;
			
		}
		
		function doReply(id){//对反馈进行回复
			$("#replyid").val(id);
			showFb();
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
			    data:{"taskid":<%=taskId%>,"status":status}, 
			    dataType:"json",
			    success:function(data){
			    	if(data.status==0){
			    		if(status==1){//标记进行
			    			$("#tdstatus .div_show").html("进行中");
			    			obj.html("完成");
			    			obj.attr("status",1).attr("class","taskComplete");
			    		}else if(status==2){//标记完成
			    			$("#tdstatus .div_show").html("完成");
			    			obj.html("取消完成");
			    			obj.attr("status",2).attr("class","taskCompleteOk");
			    			$("#feedbacktable").prepend(data.str);
			    		}else if(status==4){//删除
			    			location.href="/mobile/plugin/task/taskMain.jsp?"+param;
			    		}
			    	}else{
			    		alert(data.msg);
			    	}
			    },
			    complete: function(data){
			    	hideLoading();
				}
		    });
		}
		
		function addFav(obj){//添加关注
			showLoading();
			var special = obj.attr("special");
			$.ajax({
				type: "post",
			    url: "/mobile/plugin/task/favOperation.jsp",
			    data:{"taskid":<%=taskId%>,"special":special}, 
			    dataType:"json",
			    success:function(data){
			    	if(data.status==0){
			    		if(special==0){
			    			obj.html("取消关注");
			    			obj.attr("special",1);
			    			obj.attr("class","taskFavOk");
			    		}else{
			    			obj.attr("class","taskFav");
			    			obj.html("关注");
			    			obj.attr("special",0);
			    		}
			    	}else{
			    		alert(data.msg);
			    	}
			    },
			    complete: function(data){
			    	hideLoading();
				}
		    });
		}
		
		function doCancel(){//点击取消输入反馈内容
			//重置输入内容的文本框
			$("#fbContent").val("");
			//重置相关附件等内容
			$("#docDiv").html("");
			$("#docId").val("");
			$("#wfDiv").html("");
			$("#wfId").val("");
			$("#crmDiv").html("");
			$("#crmId").val("");
			$("#prjDiv").html("");
			$("#prjId").val("");
			//重置反馈的样式
			$("#taskFbTd").attr("class","taskFbTd");
			//隐藏弹出的DIV
			$("#showFbDiv").hide();
			//显示出滚动条
			//$("#body").css("overflow","auto");
			//情况回复的ID
			$("#replyid").val("");
			//重置是否处于输入反馈内容状态
			isFbStatus = false;
			//重置滚动条到之前的位置
			$(window).scrollTop(scrollTop);
		}
		function doFeedback(){
			var content = $.trim($("#fbContent").val());
			if(content==""){
				$("#fbContent").focus();
				return ;
			}
			showLoading();
			var docids = $("#docId").val();
			var wfids = $("#wfId").val();
			var crmIds = $("#crmId").val();
			var prjIds = $("#prjId").val();
			var fileIds = "";
			var replyid = $("#replyid").val();
			$.ajax({
				type: "post",
			    url: "/mobile/plugin/task/saveFb.jsp",
			    data:{"taskId":'<%=taskId%>',"content":content,"docids":docids,"wfids":wfids,"crmids":crmIds,
			    "projectids":prjIds,"fileids":fileIds,"replyid":replyid}, 
			    dataType:"json",
			   	success:function(data){
			   		if(data.status==0){
			   			$("#feedbacktable").prepend(data.result);
			   			doCancel();
			   		}else{
			   			alert(data.msg);
			   		}
			   	},
			    complete: function(data){
			    	hideLoading();
				}
		    });
		}
		function toDocument(docid){//查看文档
			location = "/mobile/plugin/2/view.jsp?detailid="+docid+"&"+param+"&fromTask=true";
		}
		function toRequest(id){//查看流程
			location = '/mobile/plugin/1/view.jsp?requestid='+id+'&'+param+"&fromTask=true";
		}
		function toCustomer(id){//客户
			location = '/mobile/plugin/crm/CrmView.jsp?id='+id+'&'+param+"&fromTask=true";
		}
		function toProject(id){
			
		}
		function toDownload(fid,fname) {//附件
			window.open("/download.do?download=1&fileid="+fid+"&filename="+fname,'_blank');
		}
		function toTask(id){
			location = '/mobile/plugin/task/taskDetail.jsp?taskId='+id+'&'+param;
		}
		function getMoreFb(){//获取更多反馈信息
			if(ifLoadMore) return;
			if(totalPage<pageNum) return;
			ifLoadMore = true;
			$("#fbLoadingTr").show();
			$("#feedbacktable").showLoading();
			$.ajax({
				type: "post",
			    url: "/mobile/plugin/task/getMoreFb.jsp",
			    data:{"pageNum":pageNum,"taskId":"<%=taskId%>"}, 
			    success:function(data){
			    	$("#fbLoadingTr").before(data);
			    	if(pageNum==1){
			    		totalPage = $("#fbTotalPage").val();
			    	}
			    	pageNum++;//页数加1
			    	ifLoadMore = false;
			    },
			    complete: function(){ 
			    	$("#feedbacktable").hideLoading();
			    	$("#fbLoadingTr").hide();
				}
		    });
		}
		function getMoreLog(){
			if(ifLoadMore) return;
			if(totalPageForLog<pageNumForLog) return;
			ifLoadMore = true;
			$("#logLoadingTr").show();
			$("#logtable").showLoading();
			$.ajax({
				type: "post",
			    url: "/mobile/plugin/task/getMoreLog.jsp",
			    data:{"pageNum":pageNumForLog,"taskId":"<%=taskId%>"}, 
			    success:function(data){
			    	$("#logLoadingTr").before(data);
			    	if(pageNumForLog==1){
			    		totalPageForLog = $("#logTotalPage").val();
			    	}
			    	pageNumForLog++;//页数加1
			    	ifLoadMore = false;
			    },
			    complete: function(){ 
			    	$("#logtable").hideLoading();
			    	$("#logLoadingTr").hide();
				}
		    });
		}
		
		function showSubTask(){
			$("#subTaskLoadingTr").show();
			$("#subTaskTable").showLoading();
			$.ajax({
				type: "post",
			    url: "/mobile/plugin/task/getSubTask.jsp",
			    data:{"taskId":"<%=taskId%>","showallsub":"<%=showallsub%>"}, 
			    success:function(data){
			    	$("#subTaskLoadingTr").before(data);
			    },
			    complete: function(){ 
			    	$("#subTaskTable").hideLoading();
			    	$("#subTaskLoadingTr").hide();
				}
		    });
		}
		
		var selField;
		function selectData(rID,rField,isMuti,method){//选择人员入口
			//$("#body").css("overflow","auto");
			var params = encodeURI('&returnIdField='+rID+'&returnShowField='+rField+'&isMuti='+isMuti+'&method='+method);
			showDialog('/mobile/plugin/browser.jsp',params);
			selField = rField;
		}
		function showDialog(url, data){//选择人员弹出框
			var top = ($( window ).height()-150)/2;
			var width = window.innerWidth > 480 ? 480 : window.innerWidth - 20;
			$.open({
				id : "selectionWindow",
				url : url,
				data: "r=" + (new Date()).getTime() + data,
				title : "请选择",
				width : width,
				height : 155,
				scrolling:'yes',
				top: top,
				callback : function(action, returnValue){}
			}); 
			$.reload('selectionWindow', url + "?r=" + (new Date()).getTime() + data);
		}
		function closeDialog() {//选择完人员回调函数
			//$("#"+selField).offset().top
			$(window).scrollTop($("#"+selField).offset().top-100);
			$.close("selectionWindow");
		}
		
		function getDialogId() {
			return "selectionWindow";
		}
	
		function getLeftButton(){ 
			return "1,<%=SystemEnv.getHtmlLabelName(1290,user.getLanguage()) %>";
		}
		function getRightButton(){ 
			return "1, ";
		}
		function doRightButton(){
			return "1";
		}
		function doLeftButton(){
			if(isFbStatus){
				doCancel();
			}else{
				window.location = "/mobile/plugin/task/taskMain.jsp?"+param+"&hrmid=<%=hrmid%>";
			}
			return "1";
		}
	</script>
</body>
</html>
<%!
	private String getParentid(String taskid) throws Exception{
		RecordSet rs = new RecordSet();
		rs.executeSql("select parentid from TM_TaskInfo where parentid<>'' and parentid is not null and parentid<>0 and id="+taskid);
		if(rs.next()){
			taskid = Util.null2String(rs.getString(1));
			if(!taskid.equals("")) taskid = this.getParentid(taskid);
		}
		return taskid;
	}
%>