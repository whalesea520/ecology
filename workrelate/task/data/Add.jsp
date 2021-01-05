<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="RequestComInfo" class="weaver.workflow.request.RequestComInfo" scope="page" />
<jsp:useBean id="DocComInfo" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<%@ include file="/workrelate/task/util/CommInfo.jsp"%>
<%
	String taskId = Util.null2String(request.getParameter("taskId"));
	boolean canedit = true;

	String name = "";
	String level = "";
	String remark = Util.convertDbInput(request.getParameter("remark"));
	String risk = Util.convertDbInput(request.getParameter("risk"));
	String difficulty = Util.convertDbInput(request.getParameter("difficulty"));
	String assist = Util.convertDbInput(request.getParameter("assist"));
	String tag = Util.toScreen(request.getParameter("tag"),user.getLanguage());
	String principalid = Util.null2String(request.getParameter("principalid"));
	if(principalid.equals("")) principalid = user.getUID()+"";
	String begindate = Util.null2String(request.getParameter("begindate"));
	String enddate = Util.null2String(request.getParameter("enddate"));
	String taskids = Util.null2String(request.getParameter("taskids"));
	String goalids = Util.null2String(request.getParameter("goalids"));
	String docids = Util.null2String(request.getParameter("docids"));
	String wfids = Util.null2String(request.getParameter("requestids"));
	String meetingids = Util.null2String(request.getParameter("meetingids"));
	String crmids = Util.null2String(request.getParameter("crmids"));
	String projectids = Util.null2String(request.getParameter("projectids"));
	String fileids = Util.null2String(request.getParameter("fileids"));
	String parentid = Util.null2String(request.getParameter("parentid"));
	String parentname = Util.null2String(request.getParameter("pName"));;
	String tododate = Util.null2String(request.getParameter("tododate"));
	String todo = "4";
	
	String eid = Util.null2String(request.getParameter("eid"));
	
	boolean showgoal = weaver.workrelate.util.TransUtil.isgoal();
	
	if(!wfids.equals("")){
		name = RequestComInfo.getRequestname(wfids);
		if(!wfids.startsWith(",")) wfids = "," + wfids;
		if(!wfids.endsWith(",")) wfids += ",";
	}else if(!docids.equals("")){
		name = DocComInfo.getDocname(docids);
		if(!docids.startsWith(",")) docids = "," + docids;
		if(!docids.endsWith(",")) docids += ",";
	}else if(!crmids.equals("")){
		name = CustomerInfoComInfo.getCustomerInfoname(crmids);
		if(!crmids.startsWith(",")) crmids = "," + crmids;
		if(!crmids.endsWith(",")) crmids += ",";
	}
	//zhw 2013-07-29 saveType:0原有的新增功能,1:从门户任务元素的创建,2:任务界面点击标题新建
	int saveType = Util.getIntValue(request.getParameter("saveType"),0);
	String sorttype = Util.fromScreen3(request.getParameter("sorttype"), user.getLanguage());
	String datetype = Util.fromScreen3(request.getParameter("datetype"), user.getLanguage());
	if(sorttype.equals("5")&&!datetype.equals("")){
		todo = datetype;
	}
	String currentDate = TimeUtil.getCurrentDateString();
	String yesterday = TimeUtil.dateAdd(currentDate,-1);
	String tomorrow = TimeUtil.dateAdd(currentDate,1);
	if(sorttype.equals("2")){
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
	if(sorttype.equals("3")){
		level = datetype;
	}
	if(level.equals("5")) level="0";
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>新建任务</title>
		<link rel="stylesheet" href="/workrelate/css/ui/jquery.ui.all.css" />
		<link rel="stylesheet" href="../css/main.css" />
		<script language="javascript" src="/workrelate/js/jquery-1.8.3.min.js"></script>
		<script language="javascript" src="../js/jquery.fuzzyquery.min.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/jquery.overlabel_wev8.js"></script>
		<script src="/workrelate/js/jquery.ui.core.js"></script>
		<script src="/workrelate/js/jquery.ui.widget.js"></script>
		<script src="/workrelate/js/jquery.ui.datepicker.js"></script>
		<script src="/workrelate/js/jquery.textarea.autoheight.js"></script>
		<script src="/workrelate/js/util.js"></script>
		<script language="javascript" src="/js/init_wev8.js"></script>
		<link rel="stylesheet" href="/workrelate/css/perfect-scrollbar.css" rel="stylesheet" />
      	<script language="javascript" src="/workrelate/js/jquery.mousewheel.js"></script>
      	<script language="javascript" src="/workrelate/js/perfect-scrollbar.js"></script>
		<style type="text/css">
			#main{width: 100%;height: 100%;position: absolute;top: 0px;left: 0px;right: 0px;bottom: 0px;}
			.addtitle{width:auto;line-height:40px;float: left;
				margin-left: 10px;font-weight: bold;font-size: 14px;
			}
			.btn_operate_add{margin-top:10px;margin-right: 5px;width:90px;
						text-align: center;line-height: 18px;cursor: pointer;float: left;
						color:#808080;margin-left: 3px;margin-bottom: 0px;
						border: 1px #D2D2D2 solid;}
			.btn_hover_add{
				background:#eee;
			}			
			<%if(saveType==10){ %>
				.addtitle{
					color:#fff;
				}
				.btn_operate_add{
					color:#fff;border:1px solid #fff;
				}
				.btn_hover_add{
					background:#2d71bd;
				}
			<%}%>
			.operatepanel{width: auto;height: 40px;float: right;margin-right: 5px;}
			*{font-family: '微软雅黑'}
			.input_def{overflow: hidden;resize:none;word-break:break-all;}
			.input_def{word-wrap:break-word;word-break:break-all;width: 90%;height:23px;line-height: 23px;border: 1px #fff solid;padding-left: 0px;border-radius: 0px;-moz-border-radius: 0px;-webkit-border-radius: 0px;}
			.input_over{border:0px;border-bottom: 1px #F0F0F0 solid;background: none;}
			.input_focus{border:0px;border-bottom: 1px #1A8CFF solid;background: none;box-shadow:0px 0px 0px #1A8CFF;-moz-box-shadow:0px 0px 0px #1A8CFF;-webkit-box-shadow:0px 0px 0px #1A8CFF;}
			
			.content_def{width: 90%;min-height:0px;height:24px;line-height: 24px;resize:none;overflow: hidden;word-break:break-all;background: none;
				border:0px;border-bottom: 1px #fff solid;padding: 0px;padding-left: 0px;border-radius: 0px;-moz-border-radius: 0px;-webkit-border-radius: 0px;text-align: left;}
			.content_def p{padding: 0px;margin: 0px;}
			.content_over{border:0px;border-bottom: 1px #fff solid;background: none;}
			.content_focus{border:0px;border-bottom: 1px #1A8CFF solid;background: none;box-shadow:0px 0px 0px #1A8CFF;-moz-box-shadow:0px 0px 0px #1A8CFF;-webkit-box-shadow:0px 0px 0px #1A8CFF;}
			.btn_cancel{
				width: 16px; 
				height: 16px; 
				margin-top:12px;
				margin-bottom: 0px; 
				margin-left:10px; 
				float: right; 
				position: relative; 
				cursor: pointer; 
				background-image: url("../images/16_close.png");
			}
		</style>
		<!--[if IE]> 
		<style type="text/css">
			.input_def{line-height: 180% !important;}
		</style>
		<![endif]-->
	<%@ include file="/secondwev/common/head.jsp" %>
	</head>
	<body>
		<form id="form1" name="form1" action="Operation.jsp" method="post">
		<input type="hidden" id="operation" name="operation" value="add"/>
		<input type="hidden" id="sorttype" name="sorttype" value="5"/>
		<input type="hidden" id="relateadd" name="relateadd" value="1"/>
		<input type="hidden" id="datetype" name="datetype" value=""/>
		<input type="hidden" id="saveType" name="saveType" value="0"/>
		<input type="hidden" id="lev" name="lev" value="<%=level %>"/>
		<input type="hidden" id="eid" name="eid" value="<%=eid %>"/>
		<div id="main">
		<div id="rightinfo" style="width: 100%;height: 100%;position: relative;">
			<div style="width: 100%;height: 40px;position: relative;overflow:hidden;
				<%if(saveType==1){ %>background:#fcfcfc !important;<%}else{ %>background:#fcfcfc !important;<%} %>
			">
				<%if(saveType!=1){ %>
				<div class="addtitle">
					新建任务
				</div>
				<%} %>
				<div id="operatepanel" class="operatepanel">
					<%if(saveType==0){%>
						<div class="btn_operate_add" onclick="doSubmit(0)">保存</div>
					<%}else if(saveType==1){ %>
						<div class="btn_operate_add" onclick="doSubmit(1)">保存</div>
						<div class="btn_operate_add" onclick="doSubmit(2)">保存并新建</div>
						<div class="btn_operate_add" onclick="doSubmit(3)">保存并完善详情</div>
					<%}else if(saveType==2){ %>
						<div class="btn_operate_add" onclick="doSubmit(4)">保存</div>
						<div class="btn_operate_add" onclick="doSubmit(5)">保存并新建</div>
					<%}%>
					<%if(saveType==1){ %>
					<!-- <div class="btn_cancel" onclick="doCancel()" title="点击关闭"></div> -->
					<%} %>
				</div>
			</div>
			<div id="maininfo" style="width:100%;height: auto;border-top:1px #E8E8E8 solid;position: relative;overflow: hidden;" class="scroll1" align="center">
				<div id="dtitle0" class="dtitle" title="点击收缩"><div class="dtxt">基本信息</div></div>
				<div style="min-height:230px">
				<table class="datatable contenttable" cellpadding="0" cellspacing="0" border="0" align="center">
					<colgroup><col width="20%" /><col width="80%" /></colgroup>
					<tbody>		
						<tr>
							<td class="title">名称</td>
							<td class="data">
						  		<input type="text" class="input_def" id="taskName" name="taskName" style="font-weight: bold;font-size: 16px;" value="<%=name %>"/>
						  	</td>
						</tr>
						<tr>
							<td class="title">标记todo</td>
							<td id="todo_td" class="data" style="padding-top: 2px;padding-left: 5px;">
							  	<a id="todo1" class="slink <%if("1".equals(todo)){%>sdlink<%}%>" href="javascript:setTodo(1)">今天</a>
							  	<a id="todo2" class="slink <%if("2".equals(todo)){%>sdlink<%}%>" href="javascript:setTodo(2)">明天</a>
							  	<a id="todo3" class="slink <%if("3".equals(todo)){%>sdlink<%}%>" href="javascript:setTodo(3)">即将</a>
							  	<a id="todo4" class="slink <%if("4".equals(todo)){%>sdlink<%}%>" href="javascript:setTodo(4)">不标记</a>
							  	<a id="todo5" class="slink <%if("5".equals(todo)){%>sdlink<%}%>" href="javascript:setTodo(5)">备注</a>
						  		<input type="hidden" id="todo" name="todo" value="<%=todo %>"/>
						  	</td>
						</tr>
				  		<tr>
							<td class="title">上级任务</td>
							<td class="data">
								<input type="hidden" id="parentid_val" name="parentid" value="<%=parentid %>"/>
						  		<input id="parentid" class="add_input" _init="1" _searchwidth="150" _searchtype="ptask"/>
						  		<div class="btn_add"></div>
						  	</td>
						</tr>
						<tr>
						  	<td class="title">描述</td>
						  	<td class="data">
						  		<textarea class="content_def" id="remark" name="remark" style=""><%=remark %></textarea>
						  	</td>
						</tr>
						<tr>
							<td class="title">责任人</td>
							<td class="data">
								<input type="hidden" id="principalid_val" name="principalid" value="<%=principalid %>"/>
								<div class="txtlink showcon txtlink<%=principalid %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
									<%if(!principalid.equals("0") && !principalid.equals("")){ %>
									<div style="float: left;"><%=cmutil.getHrm(principalid) %></div>
									<%} %>
								</div>
						  		<input id="principalid" class="add_input" _init="1" _searchwidth="80" _searchtype="hrm"/>
						  		<div class="btn_add"></div>
						  		<div class="btn_browser browser_hrm" onClick="onShowHrm('principalid')"></div>
						  	</td>
						</tr>
						<tr>
							<td class="title">参与人</td>
							<td class="data">
						  		<input id="partnerid" class="add_input" _init="1" _searchwidth="80" _searchtype="hrm"/>
						  		<div class="btn_add"></div>
						  		<div class="btn_browser browser_hrm" onclick="onShowHrms('partnerid')"></div>
						  		<input type="hidden" id="partnerid_val" name="partnerid" value=","/>
						  	</td>
						</tr>
						<tr>
							<td class="title">结束日期</td>
							<td class="data">
								<input type="text" class="input_def" style="width: 100px;" id="enddate" name="enddate" value="<%=enddate %>" size="30"/>
							</td>
						</tr>
					</tbody>
		  		</table>
		  		</div>
		  		<div <%if(saveType==1) {%>style="display:none;"<%} %>>
		  		<div id="dtitle1" class="dtitle" title="点击收缩"><div class="dtxt">相关信息</div></div>
		  		<div style="min-height:230px;">
		  		<table id="relateTable"  class="datatable contenttable" cellpadding="0" cellspacing="0" border="0" align="center">
					<colgroup><col width="20%"/><col width="80%"/></colgroup>
					<tbody>
						<tr>
							<td class="title">相关任务</td>
							<td class="data">
						  		<input id="taskids" class="add_input" _init="1" _searchwidth="160" _searchtype="task"/>
						  		<div class="btn_add"></div>
						  		<input type="hidden" id="taskids_val" name="taskids" value=","/>
						  	</td>
						</tr>
						
						<%if(showgoal){ %>
						<tr>
							<td class="title">相关目标</td>
							<td class="data">
						  		<input id="goalids" class="add_input" _init="1" _searchwidth="160" _searchtype="goal"/>
						  		<div class="btn_add"></div>
						  		<input type="hidden" id="goalids_val" name="goalids" value=","/>
						  	</td>
						</tr>
						<%} %>
						
						<tr>
							<td class="title">相关文档</td>
							<td class="data">
								<%
									List docidList = Util.TokenizerString(docids,",");
									if(docids.equals("")) docids = ",";
									for(int i=0;i<docidList.size();i++){
										if(!"0".equals(docidList.get(i)) && !"".equals(docidList.get(i))){
								%>
								<div class="txtlink txtlink<%=docidList.get(i) %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
									<div style="float: left;"><%=cmutil.getDocName((String)docidList.get(i)) %></div>
									<%if(canedit){ %>
									<div class="btn_del" onclick="delItem('docids','<%=docidList.get(i) %>')"></div>
									<div class="btn_wh"></div>
									<%} %>
								</div>
								<% 		} 
									}
								%>
						  		<input id="docids" class="add_input" _init="1" _searchwidth="160" _searchtype="doc"/>
						  		<div class="btn_add"></div>
						  		<div class="btn_browser browser_doc" onclick="onShowDoc('docids')"></div>
						  		<input type="hidden" id="docids_val" name="docids" value="<%=docids %>"/>
						  	</td>
						</tr>
						<tr>
							<td class="title">相关流程</td>
							<td class="data">
								<%
									List wfidList = Util.TokenizerString(wfids,",");
									if(wfids.equals("")) wfids = ",";
									for(int i=0;i<wfidList.size();i++){
										if(!"0".equals(wfidList.get(i)) && !"".equals(wfidList.get(i))){
								%>
								<div class="txtlink txtlink<%=wfidList.get(i) %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
									<div style="float: left;"><%=cmutil.getRequestName((String)wfidList.get(i)) %></div>
									<%if(canedit){ %>
									<div class="btn_del" onclick="delItem('wfids','<%=wfidList.get(i) %>')"></div>
									<div class="btn_wh"></div>
									<%} %>
								</div>
								<% 		} 
									}
								%>
						  		<input id="wfids" class="add_input" _init="1" _searchwidth="160" _searchtype="wf"/>
						  		<div class="btn_add"></div>
						  		<div class="btn_browser browser_wf" onclick="onShowWF('wfids')"></div>
						  		<input type="hidden" id="wfids_val" name="wfids" value="<%=wfids %>"/>
						  	</td>
						</tr>
						<tr>
							<td class="title">相关客户</td>
							<td class="data">
								<%
									List crmidList = Util.TokenizerString(crmids,",");
									if(crmids.equals("")) crmids = ",";
									for(int i=0;i<crmidList.size();i++){
										if(!"0".equals(crmidList.get(i)) && !"".equals(crmidList.get(i))){
								%>
								<div class="txtlink txtlink<%=crmidList.get(i) %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
									<div style="float: left;"><%=cmutil.getCustomer((String)crmidList.get(i)) %></div>
									<%if(canedit){ %>
									<div class="btn_del" onclick="delItem('crmids','<%=crmidList.get(i) %>')"></div>
									<div class="btn_wh"></div>
									<%} %>
								</div>
								<% 		} 
									}
								%>
						  		<input id="crmids" class="add_input" _init="1" _searchwidth="160" _searchtype="crm"/>
						  		<div class="btn_add"></div>
						  		<div class="btn_browser browser_crm" onclick="onShowCRM('crmids')"></div>
						  		<input type="hidden" id="crmids_val" name="crmids" value="<%=crmids %>"/>
						  	</td>
						</tr>
						<tr>
							<td class="title">相关项目</td>
							<td class="data">
								<%
									List projectidList = Util.TokenizerString(projectids,",");
									if(projectids.equals("")) projectids = ",";
									for(int i=0;i<projectidList.size();i++){
										if(!"0".equals(projectidList.get(i)) && !"".equals(projectidList.get(i))){
								%>
								<div class="txtlink txtlink<%=projectidList.get(i) %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
									<div style="float: left;"><%=cmutil.getProject((String)projectidList.get(i)) %></div>
									<%if(canedit){ %>
									<div class="btn_del" onclick="delItem('projectids','<%=projectidList.get(i) %>')"></div>
									<div class="btn_wh"></div>
									<%} %>
								</div>
								<% 		} 
									}
								%>
						  		<input id="projectids" class="add_input" _init="1" _searchwidth="160" _searchtype="proj"/>
						  		<div class="btn_add"></div>
						  		<div class="btn_browser browser_proj" onclick="onShowProj('projectids')"></div>
						  		<input type="hidden" id="projectids_val" name="projectids" value="<%=projectids %>"/>
						  	</td>
						</tr>
						<tr>
							<td class="title">相关附件</td>
							<td id="filetd" class="data">
								<%if(canupload){ %>
						  		<div id="uploadDiv" class="upload" mainId="<%=mainid %>" subId="<%=subid %>" secId="<%=docsecid %>" maxsize="<%=maxsize %>"></div>
						  		<%}else{ %>
						  		<font color="red">未设置附件上传目录!</font>
						  		<%} %>
							</td>
						</tr>
					</tbody>
				</table>
				</div>
				</div>
				<%if(saveType!=1) {%>
					<div style="width: 100%;height:60px;">&nbsp;</div>
				<%} %>
			</div>
			
			<div id="dftitle" _index="" class="dtitle" onclick="showdtitle()" style="position: absolute;top: 41px;left: 0px;display: none;">
				<div id="dfhead" class="dtxt"></div>
			</div>
		</div>
		</div>
		</form>
<script language="javascript">
	var tempval = "";
	var tempbdate = "<%=begindate%>";
	var tempedate = "<%=enddate%>";
	var uploader;
	$(document).ready(function(){
		$("#dtitle1").click(function(){
			$("#relateTable").toggle();
		});
		
		if('<%=parentid%>'!=""){
			var tempText = transName("parentid","<%=parentid%>","<%=parentname%>");
			$("#parentid").before(tempText);
		}
		
		$("textarea").textareaAutoHeight({ minHeight:20 });
		//var textarea= document.getElementById("taskName"); 
		//$("#taskName").height(textarea.scrollHeight);
		
		//日期控件绑定
		$.datepicker.setDefaults( {
			"dateFormat": "yy-mm-dd",
			"dayNamesMin": ['日','一', '二', '三', '四', '五', '六'],
			"monthNamesShort": ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'],
			"changeMonth": true,
			"changeYear": true} );
		$( "#begindate" ).datepicker({
			"onSelect":function(){
				if($("#begindate").val()!="" && $("#enddate").val()!="" && !compdate($("#begindate").val(),$("#enddate").val())){
					alert("开始日期不能大于结束日期!");
					$("#begindate").val(tempbdate);
					return;
				}else{
					tempbdate = $("#begindate").val();
				}
			}
		}).datepicker("setDate","<%=begindate%>");
		$( "#enddate" ).datepicker().datepicker("setDate","<%=enddate%>");

		//分类信息收缩展开动作绑定
		/**
		$("div.dtitle").bind("click",function(){
			if($(this).attr("_click")!=0){
				var table = $(this).next("table.contenttable");
				table.toggle();
				if(table.css("display")=="none"){
					$(this).attr("title","点击展开");
				}else{
					$(this).attr("title","点击收缩");
				}
			}
		});
		*/

		//表格行背景效果及操作按钮控制绑定
		$("table.datatable").find("tr").bind("click mouseenter",function(){
			$(".btn_add").hide();$(".btn_browser").hide();
			$(this).addClass("tr_over");
			$(this).find(".input_def").addClass("input_over");
			$(this).find("div.content_def").addClass("content_over");
			if($(this).find("input.add_input").css("display")=="none"){
				$(this).find("div.btn_add").show();
				$(this).find("div.btn_browser").show();
			}
		}).bind("mouseleave",function(){
			$(this).removeClass("tr_over");
			$(this).find(".input_def").removeClass("input_over");
			$(this).find("div.content_def").removeClass("content_over");
			if($(this).find("input.add_input").css("display")=="none"){
				$(this).find("div.btn_add").hide();
				$(this).find("div.btn_browser").hide();
			}
		});

		//输入添加按钮事件绑定
		$("div.btn_add").bind("click",function(){
			$(this).hide();
			$(this).nextAll("div.btn_browser").hide();
			$(this).prevAll("div.showcon").hide();
			$(this).prevAll("input.add_input").show().focus();
			$(this).prevAll("div.btn_select").show()
		});

		//单行文本输入框事件绑定
		$(".input_def").bind("mouseover",function(){
			$(this).addClass("input_over");
		}).bind("mouseout",function(){
			$(this).removeClass("input_over");
		}).bind("focus",function(){
			$(this).addClass("input_focus");
			tempval = $(this).val();
			//document.onkeydown=keyListener2;
			if($(this).attr("id")=="name"){
				//document.onkeyup=keyListener4;
			}
		}).bind("blur",function(){
			$(this).removeClass("input_focus");
			//doUpdate(this,1);
			//document.onkeydown=null;
			//document.onkeyup=null;
		});
		$("#tag").bind("focus",function(){
			foucsobj2 = this;
			//document.onkeydown=keyListener2;
		}).bind("blur",function(){
			//document.onkeydown=null;
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
			//doUpdate(this,2);
		});

		$("div.btn_operate_add").bind("mouseover",function(){
			$(this).addClass("btn_hover_add");
		}).bind("mouseout",function(){
			$(this).removeClass("btn_hover_add");
		});

		//联想输入框事件绑定
		$("input.add_input").bind("focus",function(){
			if($(this).attr("_init")==1){
				$(this).FuzzyQuery({
					url:"/workrelate/task/data/GetData.jsp",
					record_num:5,
					filed_name:"name",
					searchtype:$(this).attr("_searchtype"),
					divwidth: $(this).attr("_searchwidth"),
					updatename:$(this).attr("id"),
					updatetype:"str",
					currentid:"<%=taskId%>"
				});
				$(this).attr("_init",0);
			}
		}).bind("blur",function(e){
			if($(this).attr("id")=="tag" && $(this).val()!=""){
				var target=$.event.fix(e).target;
				//alert($(target).attr("id"));
				//selectUpdate("tag",$(this).val(),$(this).val(),"str");
			}else{
				$(this).val("");
			}
			$(this).hide();
			$(this).nextAll("div.btn_add").show();
			$(this).nextAll("div.btn_browser").show();
			$(this).prevAll("div.showcon").show();
			//document.onkeydown=null;
		});

		$("#maininfo").scroll(function(){
			var tp = 0;
			for(var i=1;i>-1;i--){//设置标题（相关信息等）始终显示在当前页面
				if(tp>=0){
					tp = $("#dtitle"+i).position().top;
					if(tp<0){
						$("#dfhead").html($("#dtitle"+i).children("div.dtxt").html());
						$("#dftitle").attr("_index",i).show();
					}
				}
			}
			if(tp>=0) $("#dftitle").hide();
		});
		
		bindUploaderDiv($("#uploadDiv"),"relatedacc","");


		$('#maininfo').perfectScrollbar({"wheelSpeed": 40,"suppressScrollX":true});
		setHeight();

	});
	$(document).bind("click",function(e){
		var target=$.event.fix(e).target;
		if($(target).parents(".fuzzyquery_main_div").length==0 && $("#tag").val()!=""){
			selectUpdate("tag",$("#tag").val(),$("#tag").val(),"str");
		}
		if($("#tag").val()!="") $("#tag").val("");
	});
	
	function setHeight(){
		$("#maininfo").height($("#main").height()-40);
		//$('#maininfo').perfectScrollbar("update");
	}
	$(window).resize(function(){
		setHeight();
	});
	function doSubmit(type){
		var name = $("#taskName").val();
		if(name==""){
			alert("任务名称不能为空！");
			$("#taskName").focus();
			return;
		}
		showload();
		$("#saveType").val(type);
		submitform();
	}
	function submitform(){
		var oUploader=window[jQuery("#uploadDiv").attr("oUploaderIndex")];	
		try{
			if(oUploader.getStats().files_queued==0) //如果没有选择附件则直接提交
				exeFeedback();
	   		else 
	     		oUploader.startUpload();
		}catch(e) {
			exeFeedback();
		}	
	}
	function exeFeedback(){
		jQuery("#datetype").val(jQuery("#todo").val());
		jQuery("#form1").submit();
	}
	function showload(){
		jQuery("#operatepanel").html("<img src='../images/loading2.gif' style='margin-top:10px;margin-right:10px;' align='absMiddle'/>");
	}
	
	function doCancel(){
		if(<%=saveType==1%>){
			parent.closeShadowBox();
		}
	}
	function setTodo(value){
		$("#todo_td").children(".slink").removeClass("sdlink");
		$("#todo"+value).addClass("sdlink");
		$("#todo").val(value);
	}
	function setLevel(value){
		$("#level_td").children(".slink").removeClass("sdlink");
		$("#level"+value).addClass("sdlink");
		$("#lev").val(value);
	}
	
	document.onkeydown=keyListener;
	function keyListener(e){
	    e = e ? e : event;   
	    if(e.keyCode == 13){
	    	var target=$.event.fix(e).target;
	    	if($(target).attr("id")=="tag" && $(target).val()!=""){
				selectUpdate("tag",$(target).val(),$(target).val(),"str");
				$(target).blur();
			}
	    }    
	}
	//选择内容后执行更新
	function selectUpdate(fieldname,id,name,type){
		if(id==null || typeof(id)=="undefined") return;
		var addtxt = "";
		var addids = "";
		var addvalue = "";
		if(fieldname == "principalid"){
			if(id==$("#"+fieldname+"_val").val()){
				return;
			}else{
				$("#"+fieldname+"_val").val(id);
			}
			addtxt = transName(fieldname,id,name);
			addids = id;
		}else if(fieldname == "parentid"){
			if(id==$("#"+fieldname+"_val").val()){
				return;
			}else{
				$("#"+fieldname+"_val").val(id);
				//$("#showsubtr").hide();
			}
			addtxt = transName(fieldname,id,name);
			addids = id;
		}else{
			var ids = id.split(",");
			var names = name.split(",");
			var vals = $("#"+fieldname+"_val").val();
			for(var i=0;i<ids.length;i++){
				if(vals.indexOf(","+ids[i]+",")<0 && $.trim(ids[i])!=""){
					addids += ids[i] + ",";
					addvalue += ids[i] + ",";
					addtxt += transName(fieldname,ids[i],names[i]);
				}
			}
			$("#"+fieldname+"_val").val(vals+addids);
			if(fieldname != "partnerid" && fieldname != "sharerid") addids = vals+addids;
		}
		if(fieldname == "principalid" || fieldname=="parentid") $("#"+fieldname).prev("div.txtlink").remove();
		$("#"+fieldname).before(addtxt);
		if(!startWith(fieldname,"_")){
			if(fieldname != "partnerid" && fieldname != "sharerid" && fieldname != "principalid" && fieldname != "parentid" && addvalue=="") return;
			//exeUpdate(fieldname,addids,type,"",addvalue);
		}
	}
	function delItem(fieldname,fieldvalue){
		$("#"+fieldname).prevAll("div.txtlink"+fieldvalue).remove();
		if(fieldname=="docids"||fieldname=="wfids"||fieldname=="meetingids"||fieldname=="crmids"||fieldname=="projectids"||fieldname=="taskids"||fieldname=="goalids"||fieldname=="tag"||startWith(fieldname,"_") || fieldname=="partnerid"){
			var vals = $("#"+fieldname+"_val").val();
			var _index = vals.indexOf(","+fieldvalue+",")
			if(_index>-1 && $.trim(fieldvalue)!=""){
				vals = vals.substring(0,_index+1)+vals.substring(_index+(fieldvalue+"").length+2);
				$("#"+fieldname+"_val").val(vals);
				if(!startWith(fieldname,"_")){
					//exeUpdate(fieldname,vals,'str',fieldvalue);
				}
			}
		}else{
			//exeUpdate(fieldname,fieldvalue,'del');
		}
	}
	function transName(fieldname,id,name){
		var delname = fieldname;
		if(startWith(fieldname,"_")) fieldname = fieldname.substring(1);
		var restr = "";
		if(fieldname=="principalid" || fieldname=="parentid"){
			restr += "<div class='txtlink showcon txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
		}else{
			restr += "<div class='txtlink txtlink"+id+"' onmouseover='showdel(this)' onmouseout='hidedel(this)'>";
		}
		restr += "<div style='float: left;'>";
			
		if(fieldname=="principalid" || fieldname=="partnerid" || fieldname=="sharerid"){
			restr += "<a href='/hrm/resource/HrmResource.jsp?id="+id+"' target='_blank'>"+name+"</a>";
		}else if(fieldname=="docids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/docs/docs/DocDsp.jsp?id="+id+"') >"+name+"</a>";
		}else if(fieldname=="wfids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid="+id+"') >"+name+"</a>";
		}else if(fieldname=="crmids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/CRM/data/ViewCustomer.jsp?log=n&CustomerID="+id+"') >"+name+"</a>";
		}else if(fieldname=="projectids"){
			restr += "<a href=javaScript:openFullWindowHaveBar('/proj/process/ViewTask.jsp?taskrecordid="+id+"') >"+name+"</a>";
		}else if(fieldname=="taskids" || fieldname=="parentid"){
			restr += "<a href=javaScript:refreshDetail("+id+") >"+name+"</a>";
		}else if(fieldname=="goalids"){
			restr += "<a href=javaScript:showGoal("+id+") >"+name+"</a>";
		}else if(fieldname=="tag"){
			restr += name;
		}
		
		restr +="</div>";
		if(fieldname!="principalid"){
			restr +="<div class='btn_del' onclick=\"delItem('"+delname+"','"+id+"')\"></div>";
			restr +="<div class='btn_wh'></div>";
		}
		restr +="</div>";
		return restr;
	}
	function onShowHrm(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'add');
	    }
	}
	function onShowHrms(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'add');
	    }
	}
	function onShowDoc(fieldname) {
	    var datas = window.showModalDialog("/docs/DocBrowserMain.jsp?url=/docs/docs/MutiDocBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'str');
	    }
	}
	function onShowWF(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'str');
	    }
	}
	function onShowCRM(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'str');
	    }
	}
	function onShowProj(fieldname) {
	    var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/proj/data/MultiTaskBrowser.jsp");
	    if (datas) {
		    var fieldvalue = "";
		    if(datas.id=="") fieldvalue=0;
		    selectUpdate(fieldname,datas.id,datas.name,'str');
	    }
	}
	//显示删除按钮
	function showdel(obj){
		$(obj).find("div.btn_del").show();
		$(obj).find("div.btn_wh").hide();
	}
	//隐藏删除按钮
	function hidedel(obj){
		$(obj).find("div.btn_del").hide();
		$(obj).find("div.btn_wh").show();
	}
	if(<%=saveType%>!=0)
		$("#relateTable").hide();
</script>
<%@ include file="/workrelate/task/util/uploader.jsp" %>
</body>
</html>