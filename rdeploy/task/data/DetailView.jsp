<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ include file="/rdeploy/task/util/uploader.jsp" %>
<%@ page import="weaver.docs.docs.DocImageManager"%>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.file.Prop" %>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<%
	String taskId = Util.null2String(request.getParameter("taskId"));
	int quickfb = Util.getIntValue(request.getParameter("quickfb"),0);
	int right = cmutil.getRight(taskId,user);
	if(right==0){
		String parentid = this.getParentid(taskId);
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
			response.sendRedirect("NoRight.jsp?taskId="+taskId);
			return;
		}
	}
	boolean cancreate = false;
	boolean canedit = false;
	if(right==2){
		canedit = true;
		cancreate = true;
	}
	if(!cancreate){
		//参与人可创建下级任务
		rs.executeSql("select id from TM_TaskPartner tp where tp.taskid="+taskId+" and tp.partnerid="+user.getUID());
		if(rs.next()) cancreate = true;
	}
	
	String func1 = "";
	String operatedt = "";
	//String createdt = "";
	if(!"oracle".equals(rs.getDBType())){
		func1 = "isnull";
		operatedt = "max(operatedate+' '+operatetime)";
		//createdt = "max(createdate+' '+createtime)";
	}else{
		func1 = "nvl";
		operatedt = "max(CONCAT(CONCAT(operatedate,' '),operatetime))";
		//createdt = "max(CONCAT(CONCAT(createdate,' '),createtime))";
	}
	
	String sql = "select id,name,lev,status,remark,risk,difficulty,assist,tag,principalid,begindate,enddate,taskids,goalids,docids,wfids,meetingids,crmids,projectids,fileids,creater,createdate,createtime,parentid,showallsub"
			+","+func1+"((select distinct 1 from TM_TaskSpecial tts where tts.taskid=TM_TaskInfo.id and tts.userid="+user.getUID()+"),0) as special"
			+",(select "+operatedt+" from TM_TaskLog tlog where tlog.taskid=TM_TaskInfo.id and tlog.type=0 and tlog.operator="+user.getUID()+") as viewdate"
			+",(select max(tt.tododate) from TM_TaskTodo tt where tt.taskid=TM_TaskInfo.id and tt.userid="+user.getUID()+") as tododate"
			+" from TM_TaskInfo where id="+taskId+" and (deleted=0 or deleted is null)";
	
	rs.executeSql(sql);
	if(rs.getCounts()==0) return;
	rs.next();
	String name = Util.toScreen(rs.getString("name"),user.getLanguage());
	String lev = Util.null2String(rs.getString("lev"));
	String status = Util.null2String(rs.getString("status"));
	String statusstr = "进行中";
	if(status.equals("2")) statusstr = "完成";
	if(status.equals("3")) statusstr = "撤销";
	String remark = Util.convertDbInput(Util.null2String(rs.getString("remark")));
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
	int special = Util.getIntValue(rs.getString("special"),0);
	String viewdate = Util.null2String(rs.getString("viewdate"));
	String parentid = Util.null2String(rs.getString("parentid"));
	String parentname = "";
	String tododate = Util.null2String(rs.getString("tododate"));
	int showallsub = Util.getIntValue(rs.getString("showallsub"),0);
	if(!parentid.equals("") && !parentid.equals("0")) showallsub = 0;
	
	rs.executeSql("select partnerid from TM_TaskPartner where taskid="+taskId);
	//记住视图
	rs2.execute("update TM_TaskView set taskid="+taskId+" where userid="+user.getUID());
	boolean showplan = weaver.workrelate.util.TransUtil.isplan();
	boolean showgoal = weaver.workrelate.util.TransUtil.isgoal();
%>
<div id="rightinfo" style="width: 100%;height: 100%;position: relative;overflow: hidden;">
	<input type="hidden" id="taskid" name="taskid" value="<%=taskId %>"/>
	<div style="width:100%;height:55px;position: relative;overflow:hidden;
    	background: #F7F7F7 !important;">
		<div style="position: absolute;top: 0px;left: 0px;height: 100%;z-index: 5;right:10px;">
			<div class="taskDetailDivText">任务详细</div>
			<%
				//todo标记
				int todotype = 4;//todo标记  4：未标记 1：今天 2：明天 3：即将
				String todoname = "不标记";
				String currentdate = TimeUtil.getCurrentDateString();
				if(!tododate.equals("")){
					if(tododate.equals("1")){
						todotype = 5;
						todoname = "备忘";
					}else if(TimeUtil.dateInterval(tododate,currentdate)>=0){
						todotype = 1;
						todoname = "今天";
					}else if(tododate.equals(TimeUtil.dateAdd(currentdate,1))){
						todotype = 2;
						todoname = "明天";
					}else{
						todotype = 3;
						todoname = "即将";
					}
				}	
			%>
			<div class="topItem topItem2" id="todoTopDiv2" ref="todoDiv2" todotype="<%=todotype%>" style="width:80px;">
				<div class="topText"><%=todoname %></div>
				<div class="imgdown" style="margin-top:7px;"></div>	
			</div>
			<%if(canedit){ %>
				<div class="topItem2" title="标记为已完成" id="div_complete" style="margin-left:10px;<%if(status.equals("2")){%>display:none;<%} %>" 
					onclick="doOperate(2)">标记完成</div>
				<div class="doingDiv" title="设置为进行中" id="div_doing" style="<%if(status.equals("1")){%>display:none;<%} %>" 
					onclick="doOperate(1)"><div class="doingImg"></div><div style="float:left;">已完成</div></div>
			<%} %>
			<%if(canedit){ %><div class="topImg deleteDiv" onclick="doOperate(4)" title="删除"></div><%} %>
			<div class="topImg shareDiv" title="分享"></div>
			<div id="div_att_<%=taskId %>" class="topImg attDiv div_att<%=special %>" 
				title="<%if(special==0){%>添加关注<%}else{%>取消关注<%}%>" _special="<%=special %>"></div>
			<div class="topImg viewLogDiv" title="查看日志"></div>
		</div>
	</div>
	<div id="todoDiv2" class="refDiv">
		<div class="btn_add_type" _val="">标记todo</div>
		<div class="btn_add_type" _val="1">今天</div>
		<div class="btn_add_type" _val="2">明天</div>
		<div class="btn_add_type" _val="3">即将</div>
		<div class="btn_add_type" _val="4">不标记</div>
		<div class="btn_add_type" _val="5">备忘</div>
	</div>
	<div id="maininfo" style="height: auto;position:absolute;top:55px;left:10px;right:10px;bottom:0px;" class="scroll1" align="center">
		<div class="new_border">
		<div id="dtitle0" class="dtitle" title="点击收缩"><div class="dtxt">基本信息</div></div>
		<table class="datatable contenttable" cellpadding="0" cellspacing="0" align="center">
			<COLGROUP><COL width="20%"><COL width="80%"></COLGROUP>
				<TBODY>		
				<tr>
					<td class="title">名称</TD>
					<td class="data">
						<%if(canedit){ %>
				  			<textarea class="input_def" id="name" style="font-weight: bold;font-size: 16px;overflow: hidden;resize:none;"><%=name %></textarea>
				  		<%}else{ %>
				  			<div id="task_share_name" class="div_show" style="line-height: 23px;font-weight: bold;font-size: 16px;height: auto;overflow: hidden;"><%=name %></div>
				  		<%} %>
				  	</td>
				</tr>
				<%if(!parentid.equals("")){ 
		  			rs2.executeSql("select id,name,principalid,status from TM_TaskInfo where (deleted=0 or deleted is null) and id="+parentid);
		  			if(rs2.next()){
		  				parentname = Util.null2String(rs2.getString("name"));
		  			}
				}
		  		%>
		  		<tr id="reltrparentid" <%if(parentid.equals("0") || parentid.equals("")){ %>style="display: none;"<%} %> _type="parentid">
					<td class="title">上级任务</TD>
					<td class="data">
						<input type="hidden" id="parentid_val" value="<%=parentid %>"/>
						<div class="txtlink showcon txtlink<%=parentid %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
							<%if(!parentid.equals("0") && !parentid.equals("")){ %>
							<div style="float: left;"><a href="javascript:refreshDetail(<%=parentid %>)"><%=parentname %></a></div>
							<%if(canedit){ %>
							<div class="btn_del" onclick="delItem('parentid',<%=parentid %>)"></div>
							<div class="btn_wh"></div>
							<%} %>
							<%} %>
						</div>
						<%if(canedit){ %>
				  		<input id="parentid" name="parentid" class="add_input" _init="1" _searchwidth="150" _searchtype="ptask"/>
				  		<div class="btn_add"></div>
				  		<%} %>
				  	</td>
				</tr>
				<tr <%if(!canedit && ("".equals(lev)||"0".equals(lev))){ %> style="display: none;"<%} %>>
					<td class="title">紧急程度</TD>
					<td class="data" id="levelTd">
						<%if(canedit){ %>
							<div class="levelDiv"><input type="radio" value="1" <%if("1".equals(lev)){%>checked="checked"<%}%> name="levelRadio"/>非常高</div>
							<div class="levelDiv"><input type="radio" value="2" <%if("2".equals(lev)){%>checked="checked"<%}%> name="levelRadio"/>高</div>
							<div class="levelDiv"><input type="radio" value="3" <%if("3".equals(lev)){%>checked="checked"<%}%> name="levelRadio"/>中</div>
							<div class="levelDiv"><input type="radio" value="4" <%if("4".equals(lev)){%>checked="checked"<%}%> name="levelRadio"/>低</div>
				  		<%}else{ %>
				  			<%if("1".equals(lev)){%>非常高<%}%>
				  			<%if("2".equals(lev)){%>高<%}%>
				  			<%if("3".equals(lev)){%>中<%}%>
				  			<%if("4".equals(lev)){%>低<%}%>
				  		<%} %>
				  	</td>
				</tr>
				<tr>
					<td class="title">状态</TD>
					<td id="tdstatus" class="data" style="padding-left: 5px;"><%=statusstr %></td>
				</tr>
				<tr>
					<td class="title">责任人</TD>
					<td class="data">
						<input type="hidden" id="principalid_val" value="<%=principalid %>"/>
						<div class="txtlink showcon txtlink<%=principalid %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
							<%if(!principalid.equals("0") && !principalid.equals("")){ %>
							<div style="float: left;"><%=cmutil.getHrm(principalid) %></div>
							<%if(canedit && 1==2){ %>
							<div class="btn_del" onclick="delItem('principalid',<%=principalid %>)"></div>
							<div class="btn_wh"></div>
							<%} %>
							<%} %>
						</div>
						<%if(canedit){ %>
				  		<input id="principalid" name="principalid" class="add_input" _init="1" _searchwidth="80" _searchtype="hrm"/>
				  		<div class="btn_add"></div>
				  		<div class="btn_browser browser_hrm" onClick="onShowHrm('principalid')"></div>
				  		<%} %>
				  	</td>
				</tr>
				<tr id="reltrpartnerid" _type="partnerid">
					<td class="title">参与人</TD>
					<td class="data">
						<%
							String partnerid_val = ",";
							String partnerid = "";
							while(rs.next()){
								partnerid = Util.null2String(rs.getString(1));
								if(!partnerid.equals("0") && !partnerid.equals("")){
									partnerid_val += partnerid + ",";
								
						%>
						<div class="txtlink txtlink<%=partnerid %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
							<div style="float: left;"><%=cmutil.getHrm(partnerid) %></div>
							<%if(canedit){ %>
							<div class="btn_del" onclick="delItem('partnerid','<%=partnerid %>')"></div>
							<div class="btn_wh"></div>
							<%} %>
						</div>
						<% 		} 
							}
						%>
						<%if(canedit){ %>
				  		<input id="partnerid" name="partnerid" class="add_input" _init="1" _searchwidth="80" _searchtype="hrm"/>
				  		<div class="btn_add"></div>
				  		<div class="btn_browser browser_hrm" onClick="onShowHrms('partnerid')"></div>
				  		<input type="hidden" id="partnerid_val" value="<%=partnerid_val %>"/>
				  		<%} %>
				  	</td>
				</tr>
				<tr id="reltrsharerid" _type="sharerid">
					<td class="title">分享给</TD>
					<td class="data">
						<%
							String sharerid_val = ",";
							String sharerid = "";
							rs.executeSql("select sharerid from TM_TaskSharer where taskid="+taskId);
							while(rs.next()){
								sharerid = Util.null2String(rs.getString(1));
								if(!sharerid.equals("0") && !sharerid.equals("")){
									sharerid_val += sharerid + ",";
								
						%>
						<div class="txtlink txtlink<%=sharerid %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
							<div style="float: left;"><%=cmutil.getHrm(sharerid) %></div>
							<%if(canedit){ %>
							<div class="btn_del" onclick="delItem('sharerid','<%=sharerid %>')"></div>
							<div class="btn_wh"></div>
							<%} %>
						</div>
						<% 		} 
							}
						%>
						<%if(canedit){ %>
				  		<input id="sharerid" name="sharerid" class="add_input" _init="1" _searchwidth="80" _searchtype="hrm"/>
				  		<div class="btn_add"></div>
				  		<div class="btn_browser browser_hrm" onClick="onShowHrms('sharerid')"></div>
				  		<input type="hidden" id="sharerid_val" value="<%=sharerid_val %>"/>
				  		<%} %>
				  	</td>
				</tr>
				<tr <%if(begindate.equals("")){ %>style="display: none;"<%} %>>
					<td class="title">开始日期</TD>
					<td class="data">
						<%if(canedit){ %>
						<input type="text" class="input_def defhide" style="width: 100px;" id="begindate" name="begindate" value="<%=begindate %>" size="30" _defhide="1"/>
						<%}else{ %>
							<%=begindate %>
						<%} %>
					</td>
				</tr>
				<tr>
					<td class="title">结束日期</TD>
					<td class="data">
						<%if(canedit){ %>
						<input type="text" class="input_def" style="width: 100px;" id="enddate" name="enddate" value="<%=enddate %>" size="30" _defhide="1"/>
						<%}else{ %>
							<%=enddate %>
						<%} %>
					</td>
				</tr>
				<tr id="reltrtag" <%if(tag.equals("")){ %>style="display: none;"<%} %> _type="tag">
					<td class="title">任务标签</TD>
					<td class="data">
				  		<%
							List tagList = Util.TokenizerString(tag,",");
							if(tag.equals("")) tag = ",";
							for(int i=0;i<tagList.size();i++){
								if(!"0".equals(tagList.get(i)) && !"".equals(tagList.get(i))){
						%>
						<div class="txtlink txtlink<%=tagList.get(i) %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
							<div style="float: left;"><%=tagList.get(i) %></div>
							<%if(canedit){ %>
							<div class="btn_del" onclick="delItem('tag','<%=tagList.get(i) %>')"></div>
							<div class="btn_wh"></div>
							<%} %>
						</div>
						<% 		} 
							}
						%>
						<%if(canedit){ %>
				  		<input id="tag" name="tag" class="add_input" _init="1" _searchwidth="80" _searchtype="tag"/>
				  		<div class="btn_add"></div>
				  		<input type="hidden" id="tag_val" value="<%=tag %>"/>
				  		<%} %>
				  	</td>
				</tr>
				<tr <%if(remark.equals("")){ %>style="display: none;"<%} %>>
				  	<td class="title">描述</TD>
				  	<td class="data">
				  		<%if(canedit){ %>
				  			<div class="content_def defhide" tabindex="0" contenteditable="true" id="remark"><%=remark %></div>
				  		<%}else{ %>
				  			<div class="div_show"><%=remark %></div>
				  		<%} %>
				  	</td>
				</tr>
				<tr <%if(risk.equals("")){ %>style="display: none;"<%} %>>
				  	<td class="title">风险点</TD>
				  	<td class="data">
				  		<%if(canedit){ %>
				  			<div class="content_def defhide" contenteditable="true" id="risk"><%=risk %></div>
				  		<%}else{ %>
				  			<div class="div_show"><%=risk %></div>
				  		<%} %>
				  	</td>
				</tr>
				<tr <%if(difficulty.equals("")){ %>style="display: none;"<%} %>>
				  	<td class="title">难度点</TD>
				  	<td class="data">
				  		<%if(canedit){ %>
				  			<div class="content_def defhide" contenteditable="true" id="difficulty"><%=difficulty %></div>
				  		<%}else{ %>
				  			<div class="div_show"><%=difficulty %></div>
				  		<%} %>
				  	</td>
				</tr>
				<tr <%if(assist.equals("")){ %>style="display: none;"<%} %>>
				  	<td class="title">需协助点</TD>
				  	<td class="data">
				  		<%if(canedit){ %>
				  			<div class="content_def defhide" contenteditable="true" id="assist"><%=assist %></div>
				  		<%}else{ %>
				  			<div class="div_show"><%=assist %></div>
				  		<%} %>
				  	</td>
				</tr>
				
				<tr id="showsubtr" <%if(!parentid.equals("") && !parentid.equals("0")){ %> style="display: none;" <%} %>>
					<td class="title" title="选择是否开放所有下级任务的查看权限">开放下级任务</TD>
					<td class="data">
						<%if(canedit){ %>
					  		<a id="showallsub1" class="slink <%if(showallsub==1){%>sdlink<%}%>" href="javascript:setShowallsub(1)">是</a>
					  		<a id="showallsub0" class="slink <%if(showallsub==0){%>sdlink<%}%>" href="javascript:setShowallsub(0)">否</a>
				  		<%}else{ %>
				  			<%if(showallsub==1){%>是<%}%>
				  			<%if(showallsub==0){%>否<%}%>
				  		<%} %>
					</td>
				</tr>
				<!-- 隐藏字段 -->
  				<%if(canedit){ %>
				<tr class="reltr">
					<td class="data" colspan="2" align="left">
					<div style="position:relative;width:100%;">
						<div class="add_more_info" ref="main_info_div">添加更多信息</div>
						<div class="refDiv" id="main_info_div">
							<div id="relbtnparentid" class="relbtn" _type="parentid" <%if(!parentid.equals("")&&!parentid.equals("0")){ %>style="display: none;"<%} %> title="编辑上级任务">上级任务</div>
							<div id="relbtnpartnerid" class="relbtn" _type="partnerid" <%if(!partnerid_val.equals(",")){ %>style="display: none;"<%} %> title="添加参与人">参与人</div>
							<div id="relbtnsharerid" class="relbtn" _type="sharerid" <%if(!sharerid_val.equals(",")){ %>style="display: none;"<%} %> title="添加分享给">分享给</div>
							<div id="rb_begindate" class="relbtn" _field="begindate" <%if(!begindate.equals("")){ %>style="display: none;"<%} %> title="编辑开始日期">开始日期</div>
							<div id="relbtntag" class="relbtn" _type="tag" <%if(!tag.equals(",")){ %>style="display: none;"<%} %> title="添加标签">标签</div>
							<div id="rb_remark" class="relbtn" _field="remark" <%if(!remark.equals("")){ %>style="display: none;"<%} %> title="编辑描述">描述</div>
							<div id="rb_risk" class="relbtn" _field="risk" <%if(!risk.equals("")){ %>style="display: none;"<%} %> title="编辑风险点">风险点</div>
							<div id="rb_difficulty" class="relbtn" _field="difficulty" <%if(!difficulty.equals("")){ %>style="display: none;"<%} %> title="编辑难度点">难度点</div>
							<div id="rb_assist" class="relbtn" _field="assist" <%if(!assist.equals("")){ %>style="display: none;"<%} %> title="编辑需协助点">需协助点</div>
						</div>
					</div>
					</td>
				</tr>
				<%} %>
			</TBODY>
  		</table>
  		</div>
  		<div class="new_border" id="dtitle1_div">
  		<div id="dtitle1" class="dtitle" title="点击收缩"><div class="dtxt">下级任务</div></div>
  		<table id="subdatalist" class="subdatalist contenttable" cellpadding="0" cellspacing="0" border="0" align="center">
  			<colgroup><col width="*"/><col width="80px"/></colgroup>
  			<%String subtaskstr =  this.getSubTask(taskId,user,1,showallsub); %>
  			<%=subtaskstr %>
  			<%if(cancreate){ %>
  			<tr class='subitem_tr subitem_tr_blank' _taskid="">
				<td class='item_td' colspan="2">
					<div class="newInputDiv" style="margin-left:18px;margin-right:18px;">
					<input onfocus='doClickSubItem(this)' 
					onblur='doBlurSubItem(this)' class='subdisinput subaddinput subdefinput' 
						type='text' name='' value='新建下级任务' id='' _pid=''/>
					</div>			
				</td>
			</tr>
			<%}else if(subtaskstr.equals("")){ %>
			<tr><td colspan="2" style="color: #BEBEBE;font-style: italic;text-align: left;padding-left: 20px;">暂无下级任务</td></tr>	
			<%} %>
  		</table>
  		</div>
  		<div class="new_border" id="dtitle2_div">
  		<div id="dtitle2" class="dtitle" title="点击收缩"><div class="dtxt">相关信息</div></div>
  		<table id="reltable" class="datatable contenttable" cellpadding="0" cellspacing="0" border="0" align="center">
			<COLGROUP><COL width="20%"><COL width="80%"></COLGROUP>
			<TBODY>
				<tr id="reltrtaskids" <%if(taskids.equals("")||taskids.equals(",")){ %>style="display: none;"<%} %> _type="taskids">
					<td class="title">相关任务</TD>
					<td class="data">
						<%
							List taskidList = Util.TokenizerString(taskids,",");
							if(taskids.equals("")) taskids = ",";
							for(int i=0;i<taskidList.size();i++){
								if(!"0".equals(taskidList.get(i)) && !"".equals(taskidList.get(i))){
						%> 
						<div class="txtlink txtlink<%=taskidList.get(i) %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
							<div style="float: left;"><%=cmutil.getTaskName((String)taskidList.get(i)) %></div>
							<%if(canedit){ %>
							<div class="btn_del" onclick="delItem('taskids','<%=taskidList.get(i) %>')"></div>
							<div class="btn_wh"></div>
							<%} %>
						</div>
						<% 		} 
							}
						%>
						<%if(canedit){ %>
				  		<input id="taskids" name="taskids" class="add_input" _init="1" _searchwidth="160" _searchtype="task"/>
				  		<div class="btn_add"></div>
				  		<input type="hidden" id="taskids_val" value="<%=taskids %>"/>
				  		<%} %>
				  	</td>
				</tr>
				<%
				  	//查找关联此任务的其他任务
				  	rs2.executeSql("select id from TM_TaskInfo where (deleted=0 or deleted is null) and taskids like '%,"+taskId+",%' order by id desc");
				  	if(rs2.getCounts()>0){
				%>
				<tr>
					<td class="title" title="关联了此任务的其他任务">被关联任务</td>
					<td class="data">
				  		<%	while(rs2.next()){ %>	
				  			<%=cmutil.getTaskName(Util.null2String(rs2.getString(1))) %>
				  		<%	} %>
				  	</td>
				</tr>
				<%			
					}
				%>
				
				<%if(showgoal){ %>
				<tr id="reltrgoalids" <%if(goalids.equals("")||goalids.equals(",")){ %>style="display: none;"<%} %> _type="goalids">
					<td class="title">相关目标</TD>
					<td class="data">
						<%
							List goalidList = Util.TokenizerString(goalids,",");
							if(goalids.equals("")) goalids = ",";
							for(int i=0;i<goalidList.size();i++){
								if(!"0".equals(goalidList.get(i)) && !"".equals(goalidList.get(i))){
						%> 
						<div class="txtlink txtlink<%=goalidList.get(i) %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
							<div style="float: left;"><%=cmutil.getGoalName2((String)goalidList.get(i)) %></div>
							<%if(canedit){ %>
							<div class="btn_del" onclick="delItem('goalids','<%=goalidList.get(i) %>')"></div>
							<div class="btn_wh"></div>
							<%} %>
						</div>
						<% 		} 
							}
						%>
						<%if(canedit){ %>
				  		<input id="goalids" name="goalids" class="add_input" _init="1" _searchwidth="160" _searchtype="goal"/>
				  		<div class="btn_add"></div>
				  		<input type="hidden" id="goalids_val" value="<%=goalids %>"/>
				  		<%} %>
				  	</td>
				</tr>
				<%
				  	//查找关联此任务的目标
				  	rs2.executeSql("select id from GM_GoalInfo where (deleted=0 or deleted is null) and taskids like '%,"+taskId+",%' order by id desc");
				  	if(rs2.getCounts()>0){
				%>
				<tr>
					<td class="title" title="关联了此任务的目标">被关联目标</td>
					<td class="data">
				  		<%	while(rs2.next()){ %>	
				  			<%=cmutil.getGoalName2(Util.null2String(rs2.getString(1))) %>
				  		<%	} %>
				  	</td>
				</tr>
				<%			
					}
				%>
				<%} %>
				
				<tr id="reltrdocids" <%if(docids.equals("")||docids.equals(",")){ %>style="display: none;"<%} %> _type="docids">
					<td class="title">相关文档</TD>
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
						<%if(canedit){ %>
				  		<input id="docids" name="docids" class="add_input" _init="1" _searchwidth="160" _searchtype="doc"/>
				  		<div class="btn_add"></div>
				  		<div class="btn_browser browser_doc" onClick="onShowDoc('docids')"></div>
				  		<input type="hidden" id="docids_val" value="<%=docids %>"/>
				  		<%} %>
				  	</td>
				</tr>
				<tr id="reltrwfids" <%if(wfids.equals("")||wfids.equals(",")){ %>style="display: none;"<%} %> _type="wfids">
					<td class="title">相关流程</TD>
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
						<%if(canedit){ %>
				  		<input id="wfids" name="wfids" class="add_input" _init="1" _searchwidth="160" _searchtype="wf"/>
				  		<div class="btn_add"></div>
				  		<div class="btn_browser browser_wf" onClick="onShowWF('wfids')"></div>
				  		<input type="hidden" id="wfids_val" value="<%=wfids %>"/>
				  		<%} %>
				  	</td>
				</tr>
				<tr id="reltrcrmids" <%if(crmids.equals("")||crmids.equals(",")){ %>style="display: none;"<%} %> _type="crmids">
					<td class="title">相关客户</TD>
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
						<%if(canedit){ %>
				  		<input id="crmids" name="crmids" class="add_input" _init="1" _searchwidth="160" _searchtype="crm"/>
				  		<div class="btn_add"></div>
				  		<div class="btn_browser browser_crm" onClick="onShowCRM('crmids')"></div>
				  		<input type="hidden" id="crmids_val" value="<%=crmids %>"/>
				  		<%} %>
				  	</td>
				</tr>
				<tr id="reltrprojectids" <%if(projectids.equals("")||projectids.equals(",")){ %>style="display: none;"<%} %> _type="projectids">
					<td class="title">相关项目</TD>
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
						<%if(canedit){ %>
				  		<input id="projectids" name="projectids" class="add_input" _init="1" _searchwidth="160" _searchtype="proj"/>
				  		<div class="btn_add"></div>
				  		<div class="btn_browser browser_proj" onClick="onShowProj('projectids')"></div>
				  		<input type="hidden" id="projectids_val" value="<%=projectids %>"/>
				  		<%} %>
				  	</td>
				</tr>
				<%
					if(showplan){
						rs2.executeSql("select id,name from PR_PlanReportDetail where taskids like '%,"+taskId+",%'");
						if(rs2.getCounts()>0){
				%>
				<tr>
					<td class="title">相关计划</TD>
					<td class="data">
				<%
					
					while(rs2.next()){
				%>
					<a href="javascript:showPlan('<%=rs2.getString("id") %>')"><%=rs2.getString("name") %></a>&nbsp;&nbsp;
				<%	} %>
					</td>
				</tr>
				<%		}
					}
				%>
				<tr id="reltrfileids" <%if(fileids.equals("")||fileids.equals(",")){ %>style="display: none;"<%} %> _type="fileids">
					<td class="title">相关附件</TD>
					<td id="filetd" class="data">
						<%
							List fileidList = Util.TokenizerString(fileids,",");
							if(fileidList.equals("")) fileids = ",";
							for(int i=0;i<fileidList.size();i++){
								if(!"0".equals(fileidList.get(i)) && !"".equals(fileidList.get(i))){
									DocImageManager.resetParameter();
						            DocImageManager.setDocid(Integer.parseInt((String)fileidList.get(i)));
						            DocImageManager.selectDocImageInfo();
						            DocImageManager.next();
						            String docImagefileid = DocImageManager.getImagefileid();
						            int docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
						            String docImagefilename = DocImageManager.getImagefilename();
						%>
						<div class='txtlink txtlink<%=fileidList.get(i) %>' onmouseover='showdel(this)' onmouseout='hidedel(this)'>
							<div style='float: left;'>
								<a href="javaScript:openFullWindowHaveBar('/workrelate/task/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&taskId=<%=taskId %>')"><%=docImagefilename %></a>
								&nbsp;<a href='/workrelate/task/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&taskId=<%=taskId %>&fileid=<%=docImagefileid %>'>下载(<%=docImagefileSize/1000 %>K)</a>
								&nbsp;<%=weaver.workrelate.util.TransUtil.getReviewLink(docImagefilename, docImagefileid, user.getLanguage(), user,3,(String)fileidList.get(i),taskId,"") %>
							</div>
							<%if(canedit){ %>
							<div class='btn_del' onclick="delItem('fileids','<%=fileidList.get(i) %>')"></div>
							<div class='btn_wh'></div>
							<%} %>
						</div>
						<% 		} 
							}
						%>
						<%if(canedit){ %>
				  		<div id="uploadDiv" class="upload" mainId="82" subId="357" secId="1108" maxsize="60"></div>
				  		<%} %>
					</td>
				</tr>
				<%if(canedit){ %>
				<tr class="reltr">
					<td colspan="2" class="data">
					<div style="position:relative;width:100%;">
						<div class="add_more_info" ref="relate_info_div">添加相关信息</div>
						<div class="refDiv" id="relate_info_div">
							<%if(showgoal){ %>
							<div id="relbtngoalids" class="relbtn" _type="goalids" <%if(!goalids.equals(",")){ %>style="display: none;"<%} %> title="添加相关目标">目标</div>
							<%} %>
							<div id="relbtntaskids" class="relbtn" _type="taskids" <%if(!taskids.equals(",")){ %>style="display: none;"<%} %> title="添加相关任务">任务</div>
							<div id="relbtndocids" class="relbtn" _type="docids" <%if(!docids.equals(",")){ %>style="display: none;"<%} %> title="添加相关文档">文档</div>
							<div id="relbtnwfids" class="relbtn" _type="wfids" <%if(!wfids.equals(",")){ %>style="display: none;"<%} %> title="添加相关流程">流程</div>
							<div id="relbtncrmids" class="relbtn" _type="crmids" <%if(!crmids.equals(",")){ %>style="display: none;"<%} %> title="添加相关客户">客户</div>
							<div id="relbtnprojectids" class="relbtn" _type="projectids" <%if(!projectids.equals(",")){ %>style="display: none;"<%} %> title="添加相关项目">项目</div>
							<div id="relbtnfileids" class="relbtn" _type="fileids" <%if(!fileids.equals("")){ %>style="display: none;"<%} %> title="添加相关附件">附件</div>
						</div>
					</div>
						
					</td>
				</tr>
				<%} %>
			</TBODY>
		</table>
		</div>
		<div class="new_border">
		<div id="dtitle3" class="dtitle"><div class="dtxt">任务反馈</div></div>
  		<table id="feedbacktable" class="contenttable" style="width: 100%;margin: 0px auto;text-align: left;" cellpadding="0" cellspacing="0" border="0">
				<tr id="replyTr">
					<td id="fbtd" class="data">
					<div id="fbmain">
						<div class="feedback_def" contenteditable="true" id="content"></div>
						<div onclick="doFeedback()" class="btn_feedback" title="Ctrl+Enter">提交</div>
						<div onclick="doCancel()" class="btn_feedback" style="margin-left: 10px;">取消</div>
						<div id="submitload" style="float:left;margin-top: 5px;margin-left: 20px;display: none;"><img src='/images/loadingext_wev8.gif' align=absMiddle /></div>
						<div id="fbrelatebtn" style="width:58px;line-height:18px;float:right;margin-top: 5px;margin-right:50px;display: none;
							background: url('/workrelate/task/images/btn_down.png') right no-repeat;color: #004080;cursor: pointer;" _status="0">附加信息</div>
						<table class="datatable feedrelate" cellpadding="0" cellspacing="0" border="0" align="center" style="display: none">
							<COLGROUP><COL width="20%"><COL width="80%"></COLGROUP>
							<TBODY>
								<tr>
									<td class="title">相关文档</TD>
									<td class="data">
								  		<input id="_docids" name="_docids" class="add_input" _init="1" _searchwidth="160" _searchtype="doc"/>
								  		<div class="btn_add"></div>
								  		<div class="btn_browser browser_doc" onClick="onShowDoc('_docids')"></div>
								  		<input type="hidden" id="_docids_val" value=","/>
								  	</td>
								</tr>
								<tr>
									<td class="title">相关流程</TD>
									<td class="data">
								  		<input id="_wfids" name="_wfids" class="add_input" _init="1" _searchwidth="160" _searchtype="wf"/>
								  		<div class="btn_add"></div>
								  		<div class="btn_browser browser_wf" onClick="onShowWF('_wfids')"></div>
								  		<input type="hidden" id="_wfids_val" value=","/>
								  	</td>
								</tr>
								<tr>
									<td class="title">相关客户</TD>
									<td class="data">
								  		<input id="_crmids" name="_crmids" class="add_input" _init="1" _searchwidth="160" _searchtype="crm"/>
								  		<div class="btn_add"></div>
								  		<div class="btn_browser browser_crm" onClick="onShowCRM('_crmids')"></div>
								  		<input type="hidden" id="_crmids_val" value=","/>
								  	</td>
								</tr>
								<tr>
									<td class="title">相关项目</TD>
									<td class="data">
								  		<input id="_projectids" name="_projectids" class="add_input" _init="1" _searchwidth="160" _searchtype="proj"/>
								  		<div class="btn_add"></div>
								  		<div class="btn_browser browser_proj" onClick="onShowProj('_projectids')"></div>
								  		<input type="hidden" id="_projectids_val" value=","/>
								  	</td>
								</tr>
								<tr>
									<td class="title">相关附件</TD>
									<td class="data">
								  		<div id="fbUploadDiv" class="upload" mainId="82" subId="357" secId="1108" maxsize="60"></div>
								  	</td>
								</tr>
							</TBODY>
						</table>
						<input type="hidden" id="replyid" name="replyid" value=""/>
						<div id="fbbottom" style="width: 1px;height: 1px;"></div>
					</div>
					</td>
				</tr>
				<%
					int feedbackcount = 0;
					String lastid = "";
					String replyid = "";
					rs.executeSql("select count(*) from TM_TaskFeedback where taskid="+taskId);
					if(rs.next()){
						feedbackcount = Util.getIntValue(rs.getString(1),0);
					}
					boolean hasnewfb = false;
					if(feedbackcount>0){
						String fbsql = "select top 3 id,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime,replyid from TM_TaskFeedback where taskid=" + taskId +" order by createdate desc,createtime desc";
						if(rs.getDBType().equals("oracle")){
							fbsql = "select * from (select id,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime,replyid from TM_TaskFeedback where taskid=" + taskId +" order by createdate desc,createtime desc) t where rownum<=3";
						}
						rs.executeSql(fbsql);
						while(rs.next()){
							lastid = Util.null2String(rs.getString("id"));
							replyid = Util.null2String(rs.getString("replyid"));
				%>
				<tr>
					<td id="fbdata_<%=lastid %>" class="data fbdata" >
						<div id="feedbackshow_<%=lastid %>" class="feedbackshow">
							<div class="feedbackinfo">
							<div class="fbimg"><img src="<%=ResourceComInfo.getMessagerUrls(rs.getString("hrmid")) %>" width="43" height="43"/></div>
							<div class="fbuser"><%=ResourceComInfo.getLastname(rs.getString("hrmid")) %> </div>
							<div class="fbtime"><%=Util.null2String(rs.getString("createdate")) %> 
							<%=Util.null2String(rs.getString("createtime")) %>
							
								<%if(!viewdate.equals("") && !(user.getUID()+"").equals(rs.getString("hrmid")) && TimeUtil.timeInterval(viewdate,Util.null2String(rs.getString("createdate"))+" "+Util.null2String(rs.getString("createtime")))>0){
									hasnewfb = true;
								%>
					 			<font style="color: red;margin-left: 5px;font-style: italic;font-size: 11px;cursor: pointer;" title="新反馈">new</font><%} %>
							</div>	
							<div class="fboperate">
								<img class='fb_replyimg' src='/rdeploy/task/img/reply1.png'/><a href="javascript:doReply('<%=lastid %>')">回复</a>
								<%=this.getDelOperate(lastid,rs.getString("hrmid"),user.getUID()+"",Util.null2String(rs.getString("createdate")),Util.null2String(rs.getString("createtime"))) %>
							</div>
							</div>
							<div class="feedbackrelate">
								<div><%=Util.null2String(rs.getString("content")) %></div>
								<%if(!"".equals(rs.getString("docids"))){ %>
								<div class="relatetitle">相关文档：<%=cmutil.getDocName(rs.getString("docids")) %></div>
								<%} %>
								<%if(!"".equals(rs.getString("wfids"))){ %>
								<div class="relatetitle">相关流程：<%=cmutil.getRequestName(rs.getString("wfids")) %></div>
								<%} %>
								<%if(!"".equals(rs.getString("crmids"))){ %>
								<div class="relatetitle">相关客户：<%=cmutil.getCustomer(rs.getString("crmids")) %></div>
								<%} %>
								<%if(!"".equals(rs.getString("projectids"))){ %>
								<div class="relatetitle">相关项目：<%=cmutil.getProject(rs.getString("projectids")) %></div>
								<%} %>
								<%if(!"".equals(rs.getString("fileids"))){ %>
								<div class="relatetitle">相关附件：<%=this.getFileDoc(rs.getString("fileids"),taskId,user) %></div>
								<%} %>
							</div>
							<%
							  //读取回复信息
							  if(!replyid.equals("")){ 
								rs2.executeSql("select id,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime,replyid from TM_TaskFeedback where id="+replyid);
								if(rs2.next()){
							%>
							<div class="fbreply">
								<div class="feedbackinfo2">@ <%=cmutil.getHrm(rs2.getString("hrmid")) %> <%=Util.null2String(rs2.getString("createdate")) %> <%=Util.null2String(rs2.getString("createtime")) %></div>
								<div class="feedbackrelate2">
									<div><%=Util.null2String(rs2.getString("content")) %></div>
									<%if(!"".equals(rs2.getString("docids"))){ %>
									<div class="relatetitle2">相关文档：<%=cmutil.getDocName(rs2.getString("docids")) %></div>
									<%} %>
									<%if(!"".equals(rs2.getString("wfids"))){ %>
									<div class="relatetitle2">相关流程：<%=cmutil.getRequestName(rs2.getString("wfids")) %></div>
									<%} %>
									<%if(!"".equals(rs2.getString("crmids"))){ %>
									<div class="relatetitle2">相关客户：<%=cmutil.getCustomer(rs2.getString("crmids")) %></div>
									<%} %>
									<%if(!"".equals(rs2.getString("projectids"))){ %>
									<div class="relatetitle2">相关项目：<%=cmutil.getProject(rs2.getString("projectids")) %></div>
									<%} %>
									<%if(!"".equals(rs2.getString("fileids"))){ %>
									<div class="relatetitle2">相关附件：<%=this.getFileDoc(rs2.getString("fileids"),taskId,user) %></div>
									<%} %>
								</div>
							</div>
							<%	} %>
							<%} %>
						</div>
					</td>
				</tr>
				<%
						}
					}
					int lastcount = feedbackcount-3;
					if(lastcount>0){
				%>
				<tr id="gettr">
					<td class="data" align="center">
						<a href="javascript:getFeedbackRecord(<%=lastid %>)" style="margin-left:70px;line-height: 25px;font-style: italic;font-weight: bold;float: left;">
							显示剩余<%=lastcount %>条记录
						</a>
					</td>
				</tr>
				<%		
						
					}
					
				%>
		</table>
		</div>
		<div id="divsubpid" class="divsuboperate">
			<input id="subprincipalid" name="subprincipalid" class="add_input" _init="1" _searchwidth="80" _searchtype="hrm"/>
			<div class="btn_add"></div>
			<div class="btn_browser browser_hrm" onClick="onShowHrm('subprincipalid')"></div>
		</div>
		
	</div>
	
	<div id="dftitle" _index="" class="dtitle" onclick="showdtitle()" style="position: absolute;top: 40px;left: 0px;display: none;background: #EEEEEE;">
		<div id="dfhead" class="dtxt"></div>
	</div>
	
</div>
<div id="logdiv" class="logdiv" status="0">
	<jsp:include page="Operation.jsp">
		<jsp:param value="get_toplog" name="operation"/>
		<jsp:param value="<%=taskId %>" name="taskId"/>
	</jsp:include>
</div>
<script language="javascript">
	tempval = "";
	tempbdate = "<%=begindate%>";
	tempedate = "<%=enddate%>";
	uploader;
	oldname = "";
	foucsobj2 = null;
	taskid = <%=taskId%>;
	$(document).ready(function(){
		//如果第一次查看或有新反馈则重新检查新任务提醒
		<%if(viewdate.equals("") || hasnewfb){%>
			checknew();
		<%}%>

		<%if(partnerid_val.equals(",")){ %>$("#reltrpartnerid").hide();<%} %>
		<%if(sharerid_val.equals(",")){ %>$("#reltrsharerid").hide();<%} %> 
		<%if(!cancreate && subtaskstr.equals("")){ %>$("#dtitle1_div").hide();$("#dtitle1").hide().next("table").hide();$("#showsubtr").hide();<%}%>
		<%if(!canedit){ %>if($("#reltable").find("tr:visible").length<1){$("#dtitle2_div").hide();$("#dtitle2").hide().next("table").hide()}<%}%>
		
		$(".viewLogDiv").click(function(){
			var status = $("#logdiv").attr("status");
			if(status==0){//需要显示出来
				$("#logdiv").show().attr("status",1);
			}else{
				$("#logdiv").hide().attr("status",0);
			}
		});
		$(".viewLogDiv").bind("mouseover",function(){
			$(this).addClass("viewLogDiv_hover");
		}).bind("mouseleave",function(){
			$(this).removeClass("viewLogDiv_hover");
		});
		$(".deleteDiv").bind("mouseover",function(){
			$(this).addClass("deleteDiv_hover");
		}).bind("mouseleave",function(){
			$(this).removeClass("deleteDiv_hover");
		});
		$(".attDiv").bind("mouseover",function(){
			$(this).addClass("attDiv_hover");
		}).bind("mouseleave",function(){
			$(this).removeClass("attDiv_hover");
		});
		$(".shareDiv").bind("mouseover",function(){
			$(this).addClass("shareDiv_hover");
		}).bind("mouseleave",function(){
			$(this).removeClass("shareDiv_hover");
		});
		
		$(".shareDiv").click(function(){//分享
			onShowHrms("share");
		});
		
		$(".add_more_info").click(function(){
			var ref = $(this).attr("ref");
			var l = $(this).position().left;
			var t = $(this).position().top;
			var w = $(this).width();
			var h = $(this).height();
			$("#"+ref).css("left",l+18).css("top",t+h+2).css("width",w+18).css("borderTop","0");
			if($("#"+ref).is(":hidden")){
				$(".refDiv").hide();
				$("#"+ref).show();
			}else{
				$("#"+ref).hide();
			}
		});
		
		$("input[name='levelRadio']").change(function(){
			setLevel($(this).val());
		});
		//添加查看日志
		$.ajax({
			type: "post",
		    url: "/workrelate/task/data/Operation.jsp",
		    data:{"operation":"add_log","taskId":taskid}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){}
	    });
		
		<%if(canedit){%>
		$("#name").textareaAutoHeight({ minHeight:25 });
		var textarea= document.getElementById("name"); 
		//alert(textarea.clientHeight);
		$("#name").height(textarea.scrollHeight);
		
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
					doUpdate(this,1);
					resetSort();
				}
				if($.trim($("#begindate").val())==""){
					$("#begindate").parents("tr").hide();
					$("#rb_begindate").show();
				}
			}
		}).datepicker("setDate","<%=begindate%>");
		$( "#enddate" ).datepicker({
			"onSelect":function(){
				if($("#begindate").val()!="" && $("#enddate").val()!="" && !compdate($("#begindate").val(),$("#enddate").val())){
					alert("结束日期不能小于开始日期!");
					$("#enddate").val(tempedate);
					return;
				}else{
					tempedate = $("#enddate").val();
					doUpdate(this,1);
					resetSort();
				}
			}
		}).datepicker("setDate","<%=enddate%>");
		<%}%>

		//分类信息收缩展开动作绑定
		$("div.dtitle").bind("mouseover",function(){
			//$(this).addClass("dtitle_hover");
		}).bind("mouseout",function(){
			//$(this).removeClass("dtitle_hover");
		}).bind("click",function(){
			if($(this).attr("_click")!=0){
				var table = $(this).next("table.contenttable");
				table.toggle();
				if(table.css("display")=="none"){
					$(this).attr("title","点击展开").addClass("dtitle3");
				}else{
					$(this).attr("title","点击收缩").removeClass("dtitle3");
				}
			}
		});

		//表格行背景效果及操作按钮控制绑定
		$("table.datatable").find("tr").bind("click mouseenter",function(){
			$(".btn_add").hide();//$(".btn_browser").hide();
			//$(this).addClass("tr_over");
			//$(this).find(".input_def").addClass("input_over");
			//$(this).find("div.content_def").addClass("content_over");
			if($(this).find("input.add_input").css("display")=="none"){
				$(this).find("div.btn_add").show();
				$(this).find("div.btn_browser").show();
			}
		}).bind("mouseleave",function(){
			//$(this).removeClass("tr_over");
			//$(this).find(".input_def").removeClass("input_over");
			//$(this).find("div.content_def").removeClass("content_over");
			if($(this).find("input.add_input").css("display")=="none"){
				$(this).find("div.btn_add").hide();
				$(this).find("div.btn_browser").hide();
			}
		});

		//输入添加按钮事件绑定
		$("div.btn_add").bind("click",function(){
			$(this).hide();
			//$(this).nextAll("div.btn_browser").hide();
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
			foucsobj2 = this;
			//document.onkeydown=keyListener2;
			if($(this).attr("id")=="name"){
				oldname = $(this).val();
				//document.onkeyup=keyListener4;
			}
		}).bind("blur",function(){
			$(this).removeClass("input_focus");
			doUpdate(this,1);
			if($(this).attr("id")=="enddate") resetSort();
		});
		$("#tag").bind("focus",function(){
			foucsobj2 = this;
			//document.onkeydown=keyListener2;
		}).bind("blur",function(){
			//document.onkeydown=null;
		});
		//多行文本输入框事件绑定
		$("div.content_def").bind("mouseover",function(){
			$(this).addClass("content_over");
		}).bind("mouseout",function(){
			$(this).removeClass("content_over");
		}).bind("focus",function(){
			$(this).addClass("content_focus");
			tempval = $(this).html();
		}).bind("blur",function(){
			$(this).removeClass("content_focus");
			doUpdate(this,2);
		});
		$("div.feedback_def").bind("mouseover",function(){
			$(this).addClass("feedback_over");
		}).bind("mouseout",function(){
			$(this).removeClass("feedback_over");
		}).bind("focus",function(){
			$(this).html(deffeedback).addClass("feedback_focus");
			$("div.btn_feedback").show();
			$("#fbrelatebtn").show();
			setFBP();
		});

		$("div.btn_feedback").bind("mouseover",function(){
			$(this).addClass("btn_feedback_hover");
		}).bind("mouseout",function(){
			$(this).removeClass("btn_feedback_hover");
		})

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
			foucsobj2 = this;
			//document.onkeydown=keyListener2;
		}).bind("blur",function(e){
			if($(this).attr("id")=="tag" && $(this).val()!=""){
				var target=$.event.fix(e).target;
				//alert($(target).attr("id"));
				//selectUpdate("tag",$(this).val(),$(this).val(),"str");
			}else{
				$(this).val("");
			}
			/**
			$(this).hide();
			$(this).nextAll("div.btn_add").show();
			$(this).nextAll("div.btn_browser").show();
			$(this).prevAll("div.showcon").show();
			*/
			//document.onkeydown=null;
		});

		//反馈信息内容样式
		$("#feedbacktable").find(".data").live("mouseover",function(){
			if($(this).attr("id")!="fbtd"){
				$(this).css("background-color","#F7FBFF").find("div.fboperate").addClass("fboperate_hover")
				.find(".fb_delimg").attr("src","/rdeploy/task/img/del2.png");
				$(this).find("div.fboperate").find(".fb_replyimg").attr("src","/rdeploy/task/img/reply2.png");
			}
		}).live("mouseleave",function(){
			if($(this).attr("id")!="fbtd"){
				$(this).css("background-color","#fff").find("div.fboperate").removeClass("fboperate_hover")
				.find(".fb_delimg").attr("src","/rdeploy/task/img/del1.png");
				$(this).find("div.fboperate").find(".fb_replyimg").attr("src","/rdeploy/task/img/reply1.png");
			}
		});

		//反馈附加信息按钮事件绑定
		$("#fbrelatebtn").bind("click",function(){
			var _status = $(this).attr("_status");
			if(_status==0){
				$("table.feedrelate").show();
				$(this).attr("_status",1).css("background", "url('/workrelate/task/images/btn_up.png') right no-repeat");
			}else{
				$("table.feedrelate").hide();
				$(this).attr("_status",0).css("background", "url('/workrelate/task/images/btn_down.png') right no-repeat");
			}
			setFBP();
		});

		//关注按钮事件绑定
		$("#div_att_<%=taskId %>").bind("click",function(event) {
			var _special = $(this).attr("_special");
			if(_special==0 || _special==1){
				if(_special==0){
					$(this).removeClass("div_att0").addClass("div_att1").attr("_special",1).attr("title","取消关注");
					$("#operate_<%=taskId %>").children("div.item_att").html("取消关注").attr("_special",1).attr("title","取消关注");
				}else{
					$(this).removeClass("div_att1").addClass("div_att0").attr("_special",0).attr("title","添加关注");
					$("#operate_<%=taskId %>").children("div.item_att").html("添加关注").attr("_special",0).attr("title","添加关注");
				}
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"set_special","taskid":<%=taskId%>,"special":_special}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){
				    	$("#logdiv").prepend(data.responseText);
					}
			    });
			}
		});
		//标记按钮事件绑定
		$("#todoDiv2").find(".btn_add_type").bind("click",function(){
			var val = $(this).attr("_val");
			var todotype = $("#todoTopDiv2").attr("todotype");
			var todoname = "";
			if(val!=""&&val!=todotype){
				if(val==4) todoname="标记todo";
				else todoname = $(this).html();
				$("#todoTopDiv2").attr("todotype",val).find(".topText").html(todoname);
				$("#todoDiv2").hide();
				$.ajax({
					type: "post",
				    url: "Operation.jsp",
				    data:{"operation":"edit_field","taskId":"<%=taskId %>","fieldname":5,"fieldvalue":val}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){
				    	$("#logdiv").prepend(data.responseText);
				    	resetTodo(taskid,val,todoname);
					}
			    });
			}
		});

		$("#maininfo").scroll(function(){
		
		});

		//绑定隐藏字段显示按钮事件
		$("div.relbtn").bind("mouseover",function(){
			$(this).addClass("btn_add_type_hover");
		}).bind("mouseout",function(){
			$(this).removeClass("btn_add_type_hover");
		}).bind("click",function(){
			var _field = getVal($(this).attr("_field"));
			if(_field!=""){
				$(this).hide();
				$("#"+_field).parents("tr").show();
				$("#"+_field).focus();
			}
			var _type = getVal($(this).attr("_type"));
			if(_type!=""){
				$(this).hide();
				$("#reltr"+_type).show().find("input.add_input").show().focus();
				$("#reltr"+_type).find("div.btn_browser").show();
			}
		});
		$(document).bind("click",function(e){
			var target=$.event.fix(e).target;
			setFieldHide($(target).attr("id"));
		});
		
		bindUploaderDiv($("#uploadDiv"),"relatedacc","<%=taskId%>");
		bindUploaderDiv($("#fbUploadDiv"),"fbfileids","");

		$('#maininfo').perfectScrollbar({"wheelSpeed": 40,"suppressScrollX":true});
		$('#logdiv').perfectScrollbar({"wheelSpeed": 40,"suppressScrollX":true});
		<%if(quickfb==1){%>showFeedback();<%}%>
	});
	
	function doReply(fbid){
		$("#replyid").val(fbid);
		var fbmain = $("#fbmain");
		var fbshow = $("#fbdata_"+fbid);
		fbshow.append(fbmain);
		showFeedback();
	}
	function doDelFB(fbid){
		if(confirm("确定删除此反馈信息？")){
			$.ajax({
				type: "post",
			    url: "/workrelate/task/data/Operation.jsp",
			    data:{"operation":"del_feedback","taskId":"<%=taskId %>","fbid":fbid}, 
			    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			    complete: function(data){
			    	if($("#fbdata_"+fbid).find("#fbmain").length>0){
			    		doCancel();
			    	}
			    	$("#logdiv").prepend($.trim(data.responseText));
			    	$("#fbdata_"+fbid).parent("tr").remove();
				}
		    });
		}
	}

	function setFieldHide(targetid){
		$(".defhide").each(function(){
			var fieldid = $(this).attr("id");
			if(targetid != fieldid && targetid != "rb_"+fieldid){
				var fvalue = "";
				if($(this).is("div")){
					fvalue = $.trim($(this).html());
				}else{
					fvalue = $.trim($(this).val());
				}
				if(fvalue==""){
					$(this).parents("tr").hide();
					$("#rb_"+fieldid).show();
				} 
			}
		});
		
	}

	function doWechat(){
		if(confirm("确定发送微信提醒？")){
			$.ajax({
				type: "post",
			    url: "/workrelate/task/data/Operation.jsp",
			    data:{"operation":"wechatremind","taskId":"<%=taskId %>"}, 
			    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
			    complete: function(data){
			    	$("#logdiv").prepend($.trim(data.responseText));
			    	$("#wcbtn").remove();
				}
		    });
		}
	}

	function editSubHrm(edittaskid){
		editsubid = edittaskid;
		var trobj = $("#subitem_tr_"+edittaskid);
		var t = trobj.position().top + $("#maininfo").scrollTop();
		$("#doperate_"+edittaskid).hide();
		$("#divsubpid").css("top",t).show().find("input.add_input").show().focus().nextAll("div.btn_browser").show();
	}
</script>
<%!
	private String getFileDoc(String ids,String taskId,User user) throws Exception{
		String returnstr = "";
		String docid = "";
		String docImagefileid = "";
		int docImagefileSize = 0;
		String docImagefilename = "";
		DocImageManager DocImageManager = null;
		if(ids != null && !"".equals(ids)){
			List idList = Util.TokenizerString(ids, ",");
			for (int i = 0; i < idList.size(); i++) {
				docid = Util.null2String((String)idList.get(i));
				if(!docid.equals("")){
					DocImageManager = new DocImageManager();
					DocImageManager.resetParameter();
		            DocImageManager.setDocid(Integer.parseInt((String)idList.get(i)));
		            DocImageManager.selectDocImageInfo();
		            DocImageManager.next();
		            docImagefileid = DocImageManager.getImagefileid();
		            docImagefileSize = DocImageManager.getImageFileSize(Util.getIntValue(docImagefileid));
		            docImagefilename = DocImageManager.getImagefilename();
		            returnstr += "<a href=javaScript:openFullWindowHaveBar('/workrelate/task/util/ViewDoc.jsp?id="+docid+"&taskId="+taskId+"') >"+docImagefilename+"</a>";
		            returnstr += "&nbsp;<a href='/workrelate/task/util/ViewDoc.jsp?id="+docid+"&taskId="+taskId+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>";
		            returnstr += "&nbsp;"+ weaver.workrelate.util.TransUtil.getReviewLink(docImagefilename, docImagefileid, user.getLanguage(), user,3,docid,taskId,"")+"&nbsp;&nbsp;";
				}
			}
		}
		return returnstr;
	}
	private String getSubTask(String maintaskid,User user,int type,int showallsub) throws Exception{
		String userid = user.getUID()+"";
		StringBuffer res = new StringBuffer();
		boolean editsub = false;
		int cancreate = 0;
		RecordSet rs = new RecordSet();
		//CommonTransUtil cmutil = new CommonTransUtil();
		StringBuffer sql = new StringBuffer();
		sql.append("select t1.id,t1.name,t1.principalid,t1.status,t1.creater"
				+",(select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+") as cancreate"
				+",(select max(tt.tododate) from TM_TaskTodo tt where tt.taskid=t1.id and tt.userid="+userid+") as tododate"
				+" from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.parentid="+maintaskid);
		if(showallsub==0){
			sql.append(" and (t1.principalid="+userid+" or t1.creater="+userid
				+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
				+ " or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")"
				+ " or exists (select 1 from HrmResource hrm where (hrm.id=t1.principalid or hrm.id=t1.creater) and hrm.managerstr like '%,"+userid+",%')"
				+ " or exists (select 1 from HrmResource hrm,TM_TaskPartner tp where tp.taskid=t1.id and hrm.id=tp.partnerid and hrm.managerstr like '%,"+userid+",%')"
				+ ")");
		}
		sql.append(" order by t1.enddate,t1.id");
		rs.executeSql(sql.toString());
		//System.out.println(sql.toString());
		//if(rs.getCounts()>0){
			String currentdate = TimeUtil.getCurrentDateString();
			String _principalid = "";
			String _createrid = "";
			String taskid = "";
			String statustitle = "";
			int _status = 0;
			String tododate = "";
			int todotype = 4;
			String todoname = "";
			if(type==2) res.append("<tr class='subtable_tr'><td colspan='2' style='padding:0px;padding-left:20px;border:0px;height:auto'><table class='subdatalist' cellpadding='0' cellspacing='0' border='0' align='center'><colgroup><col width='*'/><col width='80px'/></colgroup>");
			while(rs.next()){
				_principalid = Util.null2String(rs.getString("principalid"));
				_createrid = Util.null2String(rs.getString("creater"));
				taskid = Util.null2String(rs.getString("id"));
				
				if(_principalid.equals(userid) || _createrid.equals(userid)) editsub = true; else editsub = false;
				//editsub = cmutil.getRight(rs.getString("id"),user)==2?true:false;
				if(!editsub){
					cancreate = Util.getIntValue(rs.getString("cancreate"),0);
				}else{
					cancreate = 1;
				}
				_status = rs.getInt("status");
				if(editsub){
					if(_status==1){
						statustitle = "标记完成";
					}else if(_status==2 || _status==3){
						statustitle = "标记进行";
					}
				}else{
					if(_status==1) _status=0;
				}
				tododate = Util.null2String(rs.getString("tododate"));
				todotype = 4;
				todoname = "标记todo";
				if(!tododate.equals("")){
					if(tododate.equals("1")){
						todotype = 5;
						todoname = "备忘";
					}else if(TimeUtil.dateInterval(tododate,currentdate)>=0){
						todotype = 1;
						todoname = "今天";
					}else if(tododate.equals(TimeUtil.dateAdd(currentdate,1))){
						todotype = 2;
						todoname = "明天";
					}else{
						todotype = 3;
						todoname = "即将";
					}
				}	
				
				res.append("<tr id='subitem_tr_"+taskid+"' class='subitem_tr' _taskid='"+taskid+"'>");
				res.append("<td class='item_td'><div class='subnamediv'>"+Util.null2String(rs.getString("name"))+"</div></td>");
				res.append("<td class='item_hrm' title='责任人'><div class='subzrrdiv'>"+this.getHrmLink(rs.getString("principalid")));
				res.append("</div></td>");
				res.append("</tr>");
				res.append(this.getSubTask(rs.getString("id"),user,2,showallsub));
			}
			if(type==2) res.append("</table></td></tr>");
		//}
		
		return res.toString();
	}
	private String getHrmLink(String id) throws Exception{
		String returnstr = "";
		if(!"".equals(id) && !"0".equals(id)){
			ResourceComInfo rc = new ResourceComInfo();
			returnstr = "<a href=javascript:searchList("+id+",'"+rc.getLastname(id)+"')>"+rc.getLastname(id)+"</a>";
		}else{
			returnstr = "&nbsp;";
		}
		return returnstr;
	}
	private String getParentid(String taskid) throws Exception{
		RecordSet rs = new RecordSet();
		rs.executeSql("select parentid from TM_TaskInfo where "+((!"oracle".equals(rs.getDBType()))?" parentid<>'' and ":"")+" parentid is not null and parentid<>0 and id="+taskid);
		if(rs.next()){
			taskid = Util.null2String(rs.getString(1));
			if(!taskid.equals("")) taskid = this.getParentid(taskid);
		}
		return taskid;
	}
	private String getDelOperate(String fbid,String hrmid,String userid,String createdate,String createtime){
		String returnstr = "";
		String currentdate = TimeUtil.getCurrentDateString();
		String currenttime = TimeUtil.getOnlyCurrentTimeString();
		long interval = TimeUtil.timeInterval(createdate+" "+createtime,currentdate+" "+currenttime)/60;
		if(hrmid.equals(userid) && interval<5){
			returnstr = "<img class='fb_delimg' src='/rdeploy/task/img/del1.png'/><a href=\"javascript:doDelFB('"+fbid+"')\">删除</a>&nbsp;&nbsp;";
		}
		return returnstr;
	}
%>
