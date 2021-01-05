<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<%@ include file="/workrelate/goal/util/uploader.jsp" %>
<%@ page import="weaver.docs.docs.DocImageManager"%>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.workrelate.util.CommonTransUtil"%>
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="cmutil" class="weaver.workrelate.util.CommonTransUtil" scope="page"/>
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SecCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<%
	String userid = user.getUID()+"";
	String taskId = Util.null2String(request.getParameter("taskId"));
	int quickfb = Util.getIntValue(request.getParameter("quickfb"),0);
	int right = cmutil.getGoalRight(taskId,user);
	if(right==0){
		String parentid = this.getParentid(taskId);
		if(!parentid.equals("")){
			rs.executeSql("select showallsub from GM_GoalInfo where id="+parentid);
			if(rs.next()){
				int showallsub = Util.getIntValue(rs.getString(1));
				if(showallsub==1){
					right = cmutil.getGoalRight(parentid,user);
				}
			}
		}
		if(right==0){
			response.sendRedirect("NoRight.jsp?taskId="+taskId);
			return;
		}
	}
	boolean create = cmutil.getGoalMaint(userid)[1]==1?true:false;
	boolean cancreate = false;
	boolean canedit = false;
	if(right==2){
		canedit = true;
		cancreate = true;
	}
	if(!cancreate){
		if(create){
			//参与人可创建下级任务
			rs.executeSql("select id from GM_GoalPartner tp where tp.goalid="+taskId+" and tp.partnerid="+user.getUID());
			if(rs.next()) cancreate = true;
		}
	}
	String sqlstr = "";
	if("oracle".equals(rs.getDBType())){
		sqlstr = "select id,name,attribute,cate,status,remark,target,tunit,result,runit,rate,period,principalid,begindate,enddate,goalids,taskids,docids,wfids,meetingids,crmids,projectids,fileids,creater,createdate,createtime,parentid,showallsub,showorder"
			+",nvl((select distinct 1 from GM_GoalSpecial tts where tts.goalid=GM_GoalInfo.id and tts.userid="+user.getUID()+"),0) as special"
			+",(select v.viewdate from (select CONCAT(CONCAT(operatedate,' '),operatetime) as viewdate,goalid from GM_GoalLog where type=0 and operator="+user.getUID()+" order by operatedate desc,operatetime desc) v where v.goalid=GM_GoalInfo.id and rownum=1) as viewdate"
			+" from GM_GoalInfo where id="+taskId+" and (deleted=0 or deleted is null)";
	}else{
		sqlstr = "select id,name,attribute,cate,status,remark,target,tunit,result,runit,rate,period,principalid,begindate,enddate,goalids,taskids,docids,wfids,meetingids,crmids,projectids,fileids,creater,createdate,createtime,parentid,showallsub,showorder"
			+",isnull((select distinct 1 from GM_GoalSpecial tts where tts.goalid=GM_GoalInfo.id and tts.userid="+user.getUID()+"),0) as special"
			+",(select top 1 tlog.operatedate+' '+tlog.operatetime from GM_GoalLog tlog where tlog.goalid=GM_GoalInfo.id and tlog.type=0 and tlog.operator="+user.getUID()+" order by tlog.operatedate desc,tlog.operatetime desc) as viewdate"
			//+",(select tt.tododate from GM_GoalTodo tt where tt.goalid=GM_GoalInfo.id and tt.userid="+user.getUID()+") as tododate"
			+" from GM_GoalInfo where id="+taskId+" and (deleted=0 or deleted is null)";
	}
	rs.executeSql(sqlstr);
	if(rs.getCounts()==0) return;
	rs.next();
	String name = Util.toScreen(rs.getString("name"),user.getLanguage());
	String attribute = Util.null2String(rs.getString("attribute"));
	String cate = Util.null2String(rs.getString("cate"));
	String status = Util.null2String(rs.getString("status"));
	String statusstr = "进行中";
	if(status.equals("2")) statusstr = "完成";
	if(status.equals("3")) statusstr = "撤销";
	String remark = Util.convertDbInput(Util.null2String(rs.getString("remark")));
	String target = Util.null2String(rs.getString("target"));
	String tunit = Util.null2String(rs.getString("tunit"));
	String result = Util.null2String(rs.getString("result"));
	String runit = Util.null2String(rs.getString("runit"));
	String rate = Util.null2String(rs.getString("rate"));
	String tag = Util.null2String(rs.getString("tag"));
	String period = Util.null2String(rs.getString("period"));
	String principalid = Util.null2String(rs.getString("principalid"));
	String begindate = Util.null2String(rs.getString("begindate"));
	String enddate = Util.null2String(rs.getString("enddate"));
	String goalids = Util.null2String(rs.getString("goalids"));
	String taskids = Util.null2String(rs.getString("taskids"));
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
	String showorder = Util.null2String(rs.getString("showorder"));
	
	boolean showplan = weaver.workrelate.util.TransUtil.isplan();
	boolean showtask = weaver.workrelate.util.TransUtil.istask();
	StaticObj staticobj = StaticObj.getInstance();
	String docsecid = Util.null2String((String)staticobj.getObject("gmdocsecid"));
	if("".equals(docsecid) || "0".equals(docsecid)){
		String sql = "select * from GM_BaseSetting";
		rs.executeSql(sql);
		if(rs.next()){
			docsecid = Util.null2String(rs.getString("docsecid"));  
		}
		staticobj.putObject("gmdocsecid",docsecid);
	}
	boolean canupload = false;
	String subid = "";
	String mainid = "";
	String maxsize = "0";
	if(!docsecid.equals("")&&!docsecid.equals("0")){
		subid = SecCategoryComInfo.getSubCategoryid(docsecid);
		mainid = SubCategoryComInfo.getMainCategoryid(subid);
		rs.executeSql("select maxUploadFileSize from DocSecCategory where id=" + docsecid);
		if(rs.next()) maxsize = Util.null2String(rs.getString(1));
		canupload = true;
	}
%>
<div id="rightinfo" style="width: 100%;height: 100%;position: relative;overflow: hidden;">
	<input type="hidden" id="taskid" name="taskid" value="<%=taskId %>"/>
	<div style="width: 100%;height: 40px;position: relative;overflow:hidden;
	background:-webkit-gradient(linear, 0 0, 0 bottom, from(#F2F2F2), to(#F6F6F6)) !important;
    	background:-moz-linear-gradient(#F2F2F2, #D7D7D7) !important;
    	-pie-background:linear-gradient(#F2F2F2, #D7D7D7) !important;background: #F2F2F2 !important;">
		<div style="position: absolute;top: 8px;left:0px;height: 23px;width: 100%;">
			<div style="position: absolute;top: 0px;left: 0px;height: 100%;z-index: 5;">
				<div id="div_att_<%=taskId %>" class="div_att div_att<%=special %>" title="<%if(special==0){%>添加关注<%}else{%>取消关注<%}%>" _special="<%=special %>"></div>
			<%if(canedit){ 
			%>
				<div class="btn_operate " <%if(!status.equals("1")){ %>style="display: none"<%} %> onmouseover="hideop(this,'btn_hover','完成')" onmouseout="showop(this,'btn_hover','完成')" onclick="doOperate(2)" title="设置为完成">完成</div>
				<div class="btn_operate " <%if(!status.equals("1")){ %>style="display: none"<%} %> onmouseover="hideop(this,'btn_hover','撤销')" onmouseout="showop(this,'btn_hover','撤销')" onclick="doOperate(3)" title="设置为撤销">撤销</div>
				<div class="btn_operate btn_complete" onmouseover="showop(this,'btn_complete','进行中')" onmouseout="hideop(this,'btn_complete','已完成')" <%if(!status.equals("2")){ %>style="display: none"<%} %> onclick="hideop(this,'btn_complete','已完成');doOperate(1)" title="设置为进行中">已完成</div>
				<div class="btn_operate btn_revoke" onmouseover="showop(this,'btn_revoke','进行中')" onmouseout="hideop(this,'btn_revoke','已撤销')" <%if(!status.equals("3")){ %>style="display: none"<%} %> onclick="hideop(this,'btn_revoke','已撤销');doOperate(1)" title="设置为进行中">已撤销</div>
				<div class="btn_operate btn_delete" onmouseover="hideop(this,'btn_hover','删除')" onmouseout="showop(this,'btn_hover','删除')" onclick="doOperate(4)" title="删除任务">删除</div>
			<%} %>
				<div class="btn_operate btn_delete" onmouseover="hideop(this,'btn_hover','反馈')" onmouseout="showop(this,'btn_hover','反馈')" onclick="showFeedback()" title="任务反馈">反馈</div>
				<%if(!canedit){%><div style="float: left;font-style: italic;margin-top: 3px;color: #B2B2B2;margin-left: 3px;">(不具有编辑权限)</div><%} %>
			</div>
			<div class="createinfo" title="创建人:<%=ResourceComInfo.getLastname(creater) %> 创建时间:<%=createdate %> <%=createtime %>"><%=cmutil.getHrm(creater) %> <%=createdate %> <%=createtime %></div>
		</div>
	</div>
	<div id="dcatepanel" class="todopanel">
		<div class="todotitle">目标类型</div>
		<div class="todoitem" _val="1">财务效益类</div>
		<div class="todoitem" _val="2">客户运营类</div>
		<div class="todoitem" _val="3">内部经营类</div>
		<div class="todoitem" _val="4">学习成长类</div>
		<div class="todoitem" _val="5">备忘类</div>
	</div>
	<div id="maininfo" style="width:100%;height: auto;position:absolute;top:40px;left:0px;bottom:0px;border-top:1px #E8E8E8 solid;" class="scroll1" align="center">
		<div id="dtitle0" class="dtitle" title="点击收缩"><div class="dtxt">基本信息</div></div>
		<table class="datatable contenttable" cellpadding="0" cellspacing="0" border="0" align="center">
			<COLGROUP><COL width="20%"><COL width="80%"></COLGROUP>
				<TBODY>		
				<tr>
					<td class="title">名称</TD>
					<td class="data">
						<%if(canedit){ %>
				  			<textarea class="input_def" id="name" style="font-weight: bold;font-size: 16px;overflow: hidden;resize:none;"><%=name %></textarea>
				  		<%}else{ %>
				  			<div class="div_show" style="line-height: 23px;font-weight: bold;font-size: 16px;height: auto;overflow: hidden;"><%=name %></div>
				  		<%} %>
				  	</td>
				</tr>
				<%if(!parentid.equals("")){ 
		  			rs2.executeSql("select id,name,principalid,status from GM_GoalInfo where (deleted=0 or deleted is null) and id="+parentid);
		  			if(rs2.next()){
		  				parentname = Util.null2String(rs2.getString("name"));
		  			}
				}
		  		%>
		  		<tr>
					<td class="title">上级目标</TD>
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
				<tr>
					<td class="title">类型</TD>
					<td class="data" style="padding-top: 2px;padding-left: 5px;">
						<%if(canedit){ %>
				  			<div id="cate" class="content_def" onclick="showCate()" style="cursor: pointer;width: 100px;"><%=cate %></div>
				  		<%}else{ %>
				  			<div id="cate" class="div_show"><%=cate %></div>
				  		<%} %>
					</td>
				</tr>
				<tr>
					<td class="title">状态</TD>
					<td id="tdstatus" class="data" style="padding-left: 5px;">
						<div class="div_show"><%=statusstr %></div>
					</td>
				</tr>
				<tr>
				  	<td class="title">描述</TD>
				  	<td class="data">
				  		<%if(canedit){ %>
				  			<div class="content_def" contenteditable="true" id="remark"><%=remark %></div>
				  		<%}else{ %>
				  			<div class="div_show"><%=remark %></div>
				  		<%} %>
				  	</td>
				</tr>
				<tr>
				  	<td class="title">目标值(单位)</TD>
				  	<td class="data">
				  		<%if(canedit){ %>
				  			<input type="text" class="input_def" id="target" name="target" value="<%=target %>" style="width:100px;"
				  				onkeypress="ItemNum_KeyPress('target')" onblur="checknumber('target')" maxlength="5"/>
				  			<input type="text" class="input_def" id="tunit" name="tunit" value="<%=tunit %>" style="width:50px;"/>
				  		<%}else{ %>
				  			<div class="div_show"><%=target %><%=tunit %></div>
				  		<%} %>
				  	</td>
				</tr>
				<tr>
				  	<td class="title">完成值(单位)</TD>
				  	<td class="data">
				  		<%if(canedit){ %>
				  			<input type="text" class="input_def" id="result" name="result" value="<%=result %>" style="width:100px;"
				  				onkeypress="ItemNum_KeyPress('result')" onblur="checknumber('result')" maxlength="5"/>
				  			<input type="text" class="input_def" id="runit" name="runit" value="<%=runit %>" style="width:50px;"/>
				  		<%}else{ %>
				  			<div class="div_show"><%=result %><%=runit %></div>
				  		<%} %>
				  	</td>
				</tr>
				<tr>
				  	<td class="title">完成率</TD>
				  	<td class="data">
				  		<%if(canedit){ %>
				  			<div class="content_def" contenteditable="true" id="rate"><%=rate %></div>
				  		<%}else{ %>
				  			<div class="div_show"><%=rate %></div>
				  		<%} %>
				  	</td>
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
				<tr>
					<td class="title">参与人</TD>
					<td class="data">
						<%
							String partnerid_val = ",";
							String partnerid = "";
							int maxp = 3;
							int count = 0;
							if("oracle".equals(rs.getDBType())){
								sqlstr = "select partnerid from GM_GoalPartner where goalid="+taskId+" and rownum<="+(maxp+1);
							}else{
								sqlstr = "select distinct top "+(maxp+1)+" partnerid from GM_GoalPartner where goalid="+taskId;
							}
							rs.executeSql(sqlstr);
							while(rs.next()){
								count++;
								if(count>maxp) break;
								partnerid = Util.null2String(rs.getString(1));
								if(!partnerid.equals("0") && !partnerid.equals("")){
									partnerid_val += partnerid + ",";
								
						%>
						<div class="txtlink txtlink<%=partnerid %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
							<div style="float: left;"><%=cmutil.getHrm(partnerid) %></div>
							<%if(canedit){ %>
							<div class="btn_del" onclick="delItem('partnerid','<%=partnerid %>')"></div>
							<div class="btn_wh"></div>
							<%}else{ %>
							<div class="btn_wh2"></div>
							<%} %>
						</div>
						<% 		} 
							}
							if(count>maxp){
						%>
						<div id="showallp" class="showallp"><a href="javascript:showallp('<%=taskId %>')">显示全部</a></div>
						<%} %>
						<%if(canedit){ %>
				  		<input id="partnerid" name="partnerid" class="add_input" _init="1" _searchwidth="80" _searchtype="hrm"/>
				  		<div class="btn_add"></div>
				  		<div class="btn_browser browser_hrm" onClick="onShowHrms('partnerid')"></div>
				  		<input type="hidden" id="partnerid_val" value="<%=partnerid_val %>"/>
				  		<%} %>
				  	</td>
				</tr>
				<tr>
					<td class="title">分享给</TD>
					<td class="data">
						<%
							String sharerid_val = ",";
							String sharerid = "";
							rs.executeSql("select sharerid from GM_GoalSharer where goalid="+taskId);
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
				<tr>
					<td class="title">周期</TD>
					<td class="data" style="padding-top: 2px;padding-left: 5px;">
						<%if(canedit){ %>
					  		<a id="period1" class="slink <%if("1".equals(period)){%>sdlink<%}%>" href="javascript:setPeriod(1)">月度</a>
					  		<a id="period2" class="slink <%if("2".equals(period)){%>sdlink<%}%>" href="javascript:setPeriod(2)">季度</a>
					  		<a id="period3" class="slink <%if("3".equals(period)){%>sdlink<%}%>" href="javascript:setPeriod(3)">年度</a>
					  		<a id="period4" class="slink <%if("4".equals(period)){%>sdlink<%}%>" href="javascript:setPeriod(4)">三年</a>
					  		<a id="period5" class="slink <%if("5".equals(period)){%>sdlink<%}%>" href="javascript:setPeriod(5)">五年</a>
				  		<%}else{ %>
				  			<%if("1".equals(period)){%>月度<%}%>
				  			<%if("2".equals(period)){%>季度<%}%>
				  			<%if("3".equals(period)){%>年度<%}%>
				  			<%if("4".equals(period)){%>三年<%}%>
				  			<%if("5".equals(period)){%>五年<%}%>
				  		<%} %>
				  	</td>
				</tr>
				<!-- 
				<tr>
					<td class="title">开始日期</TD>
					<td class="data">
						<%if(canedit){ %>
						<input type="text" class="input_def" style="width: 100px;" id="begindate" name="begindate" value="<%=begindate %>" size="30"/>
						<%}else{ %>
							<%=begindate %>
						<%} %>
					</td>
				</tr>
				 -->
				<tr>
					<td class="title">结束日期</TD>
					<td class="data">
						<%if(canedit){ %>
						<input type="text" class="input_def" style="width: 100px;" id="enddate" name="enddate" value="<%=enddate %>" size="30"/>
						<%}else{ %>
							<%=enddate %>
						<%} %>
					</td>
				</tr>
				<tr>
					<td class="title">排序</TD>
					<td class="data">
						<%if(canedit){ %>
						<input type="text" class="input_def" style="width: 100px;" id="showorder" name="showorder" value="<%=showorder %>" size="10"/>
						<%}else{ %>
							<%=showorder %>
						<%} %>
					</td>
				</tr>
				<!-- 
				<tr id="showsubtr" <%if(!parentid.equals("") && !parentid.equals("0")){ %> style="display: none;" <%} %>>
					<td class="title" title="选择是否开放所有下级目标的查看权限">开放下级目标</TD>
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
				-->
				</TBODY>
  		</table>
  		<div id="dtitle1" class="dtitle" title="点击收缩"><div class="dtxt">下级目标</div></div>
  		<table id="subdatalist" class="subdatalist contenttable" cellpadding="0" cellspacing="0" border="0" align="center">
  			<colgroup><col width="20px"/><col width="*"/><col width="50px"/><col width="30px"/><col width="20px"/></colgroup>
  			<%
  				StringBuffer sql = new StringBuffer();
  				sql.append("select count(t1.id) from GM_GoalInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.parentid="+taskId);
  				if(showallsub==0 && cmutil.getGoalMaint(userid)[0]==0){
  				sql.append(" and (t1.principalid="+userid+" or t1.creater="+userid
  					+ " or exists (select 1 from GM_GoalPartner tp where tp.goalid=t1.id and tp.partnerid="+userid+")"
  					+ " or exists (select 1 from GM_GoalSharer ts where ts.goalid=t1.id and ts.sharerid="+userid+")"
  					+ " or exists (select 1 from HrmResource hrm where (hrm.id=t1.principalid or hrm.id=t1.creater) and hrm.managerstr like '%,"+userid+",%')"
  					+ " or exists (select 1 from HrmResource hrm,GM_GoalPartner tp where tp.goalid=t1.id and hrm.id=tp.partnerid and hrm.managerstr like '%,"+userid+",%')"
  					+ ")");
  				}
  				rs2.executeSql(sql.toString());
  				if(rs2.next()&&rs2.getInt(1)>0){
  			%>
  				<tr><td id="showsub" colspan="5" style="padding-left: 20px;"><a href="javascript:showAllSub()" style="font-style: italic;">显示下级目标</a></td></tr>
  			<%} %>
  			<%if(cancreate){ %>
  			<tr class='subitem_tr'>
  				<td></td>
				<td class='item_td'><input onfocus='doClickSubItem(this)' onblur='doBlurSubItem(this)' class='subdisinput subaddinput subdefinput' type='text' name='' value='新建下级目标' id='' _pid=''/></td>
				<td class='item_hrm'>&nbsp;</td>
				<td class='item_view'></td>
				<td class='item_add'></td>
			</tr>
			<tr class='subtable_tr'><td colspan='5' style='padding:0px;padding-left:20px;border:0px;height:auto'><table class='subdatalist' cellpadding='0' cellspacing='0' border='0' align='center'><colgroup><col width='20px'/><col width='*'/><col width='50px'/><col width='30px'/><col width='20px'/></colgroup></table></td></tr>
			<%} %>
  		</table>
  		<div id="dtitle2" class="dtitle" title="点击收缩"><div class="dtxt">相关信息</div></div>
  		<table class="datatable contenttable" cellpadding="0" cellspacing="0" border="0" align="center">
			<COLGROUP><COL width="20%"><COL width="80%"></COLGROUP>
			<TBODY>
				<tr id="reltrgoalids" <%if(goalids.equals("")){ %>style="display: none;"<%} %> _type="goalids">
					<td class="title">相关目标</TD>
					<td class="data">
						<%
							List goalidList = Util.TokenizerString(goalids,",");
							if(goalids.equals("")) goalids = ",";
							for(int i=0;i<goalidList.size();i++){
								if(!"0".equals(goalidList.get(i)) && !"".equals(goalidList.get(i))){
						%> 
						<div class="txtlink txtlink<%=goalidList.get(i) %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
							<div style="float: left;"><%=cmutil.getGoalName((String)goalidList.get(i)) %></div>
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
				  	//查找关联此目标的其他目标
				  	rs2.executeSql("select id from GM_GoalInfo where (deleted=0 or deleted is null) and goalids like '%,"+taskId+",%' order by id desc");
				  	if(rs2.getCounts()>0){
				%>
				<tr>
					<td class="title" title="关联了此目标的其他目标">被关联目标</td>
					<td class="data">
				  	<%	while(rs2.next()){ %>	
				  		<%=cmutil.getGoalName(Util.null2String(rs2.getString(1))) %>
				  	<%	} %>
				  	</td>
				</tr>
				<%			
				  	}
				%>
				
				<%if(showtask){ %>
				<tr id="reltrtaskids" <%if(taskids.equals("")){ %>style="display: none;"<%} %> _type="taskids">
					<td class="title">相关任务</TD>
					<td class="data">
						<%
							List taskidList = Util.TokenizerString(taskids,",");
							if(taskids.equals("")) taskids = ",";
							for(int i=0;i<taskidList.size();i++){
								if(!"0".equals(taskidList.get(i)) && !"".equals(taskidList.get(i))){
						%> 
						<div class="txtlink txtlink<%=taskidList.get(i) %>" onmouseover="showdel(this)" onmouseout="hidedel(this)">
							<div style="float: left;"><%=cmutil.getTaskName2((String)taskidList.get(i)) %></div>
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
				  	//查找关联此目标的任务
				  	rs2.executeSql("select id from TM_TaskInfo where (deleted=0 or deleted is null) and goalids like '%,"+taskId+",%' order by id desc");
				  	if(rs2.getCounts()>0){
				%>
				<tr>
					<td class="title" title="关联了此目标的任务">被关联任务</td>
					<td class="data">
				  	<%	while(rs2.next()){ %>	
				  		<%=cmutil.getTaskName2(Util.null2String(rs2.getString(1))) %>
				  	<%	} %>
				  	</td>
				</tr>
				<%			
				  	}
				%>
				<%} %>
				<tr id="reltrdocids" <%if(docids.equals("")){ %>style="display: none;"<%} %> _type="docids">
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
				<tr id="reltrwfids" <%if(wfids.equals("")){ %>style="display: none;"<%} %> _type="wfids">
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
				<tr id="reltrcrmids" <%if(crmids.equals("")){ %>style="display: none;"<%} %> _type="crmids">
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
				<tr id="reltrprojectids" <%if(projectids.equals("")){ %>style="display: none;"<%} %> _type="projectids">
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
						rs2.executeSql("select id,name from PR_PlanReportDetail where goalids like '%,"+taskId+",%'");
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
				<%	}} %>
				<tr id="reltrfileids" <%if(fileids.equals("")){ %>style="display: none;"<%} %> _type="fileids">
					<td class="title">相关附件</TD>
					<td id="filetd" class="data">
						<%
							List fileidList = Util.TokenizerString(fileids,",");
							//if(fileids.equals("")) fileids = ",";
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
								<a href="javaScript:openFullWindowHaveBar('/workrelate/goal/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&taskId=<%=taskId %>')"><%=docImagefilename %></a>
								&nbsp;<a href='/workrelate/goal/util/ViewDoc.jsp?id=<%=fileidList.get(i) %>&taskId=<%=taskId %>&fileid=<%=docImagefileid %>'>下载(<%=docImagefileSize/1000 %>K)</a>
								&nbsp;<%=weaver.workrelate.util.TransUtil.getReviewLink(docImagefilename, docImagefileid, user.getLanguage(), user,1,(String)fileidList.get(i),taskId,"") %>
							</div>
							<%if(canedit){ %>
							<div class='btn_del' onclick="delItem('fileids','<%=fileidList.get(i) %>')"></div>
							<div class='btn_wh'></div>
							<%} %>
						</div>
						<% 		} 
							}
						%>
						<%if(canedit){ 
						    if(canupload){ %>
				  		    	<div id="uploadDiv" class="upload" mainId="<%=mainid %>" subId="<%=subid %>" secId="<%=docsecid %>" maxsize="<%=maxsize %>"></div>
					  		<%}else{ %>
					  			<font color="red">未设置附件上传目录!</font>
					  		<%} %>
				  		<!--  <div id="uploadDiv" class="upload" mainId="82" subId="357" secId="1108" maxsize="60"></div>-->
				  		<%} %>
					</td>
				</tr>
				<%if(canedit){ %>
				<tr>
					<td colspan="2" class="data">
						<div id="relbtngoalids" class="relbtn" _type="goalids" <%if(!goalids.equals(",")){ %>style="display: none;"<%} %> title="添加相关目标">目标</div>
						<%if(showtask){ %>
						<div id="relbtntaskids" class="relbtn" _type="taskids" <%if(!taskids.equals(",")){ %>style="display: none;"<%} %> title="添加相关任务">任务</div>
						<%} %>
						<div id="relbtndocids" class="relbtn" _type="docids" <%if(!docids.equals(",")){ %>style="display: none;"<%} %> title="添加相关文档">文档</div>
						<div id="relbtnwfids" class="relbtn" _type="wfids" <%if(!wfids.equals(",")){ %>style="display: none;"<%} %> title="添加相关流程">流程</div>
						<div id="relbtncrmids" class="relbtn" _type="crmids" <%if(!crmids.equals(",")){ %>style="display: none;"<%} %> title="添加相关客户">客户</div>
						<div id="relbtnprojectids" class="relbtn" _type="projectids" <%if(!projectids.equals(",")){ %>style="display: none;"<%} %> title="添加相关项目">项目</div>
						<div id="relbtnfileids" class="relbtn" _type="fileids" <%if(!fileids.equals("")){ %>style="display: none;"<%} %> title="添加相关附件">附件</div>
					</td>
				</tr>
				<%} %>
			</TBODY>
		</table>
		<div id="dtitle3" class="dtitle" _click="0"><div class="dtxt">反馈信息</div><div style="width:12px;height:12px;line-height:12px;font-size:14px;color:#BFBFC4;border:1px #E6E6E8 dashed;float: right;cursor: pointer;margin-right: 8px;margin-top: 5px;font-family:微软雅黑;overflow: hidden;" title="反馈" onclick="showFeedback()">+</div></div>
  		<table id="feedbacktable" style="width: 100%;margin: 0px auto;text-align: left;" cellpadding="0" cellspacing="0" border="0">
				<%
					int feedbackcount = 0;
					String lastid = "";
					rs.executeSql("select count(*) from GM_GoalFeedback where goalid="+taskId);
					if(rs.next()){
						feedbackcount = Util.getIntValue(rs.getString(1),0);
					}
					boolean hasnewfb = false;
					if(feedbackcount>0){
						if("oracle".equals(rs.getDBType())){
							sqlstr = "select * from (select id,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime from GM_GoalFeedback where goalid=" + taskId +" order by createdate desc,createtime desc) t where rownum<=3";
						}else{
							sqlstr = "select top 3 id,content,hrmid,docids,wfids,crmids,projectids,meetingids,fileids,createdate,createtime from GM_GoalFeedback where goalid=" + taskId +" order by createdate desc,createtime desc";
						}
						
						rs.executeSql(sqlstr);
						while(rs.next()){
							lastid = Util.null2String(rs.getString("id"));
							
				%>
				<tr>
					<td class="data fbdata" >
						<div class="feedbackshow">
							<div class="feedbackinfo"><%=cmutil.getHrm(rs.getString("hrmid")) %> <%=Util.null2String(rs.getString("createdate")) %> <%=Util.null2String(rs.getString("createtime")) %>
								<%if(!viewdate.equals("") && !(user.getUID()+"").equals(rs.getString("hrmid")) && TimeUtil.timeInterval(viewdate,Util.null2String(rs.getString("createdate"))+" "+Util.null2String(rs.getString("createtime")))>0){
									hasnewfb = true;
								%>
					 			<font style="color: red;margin-left: 5px;font-style: italic;font-size: 11px;cursor: pointer;" title="新反馈">new</font><%} %>
							</div>
							<div class="feedbackrelate">
								<div><%=Util.convertDB2Input(rs.getString("content")) %></div>
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
						<a href="javascript:getFeedbackRecord(<%=lastid %>)" style="margin-left: 20px;line-height: 25px;font-style: italic;font-weight: bold;float: left;">
							显示剩余<%=lastcount %>条记录
						</a>
					</td>
				</tr>
				<%		
						
					}
					
				%>
				
				<tr>
					<td class="data">
						<div class="feedback_def" style="margin-left: 20px;margin-top: 5px;" contenteditable="true" id="content"></div>
						<div onclick="doFeedback()" class="btn_feedback" title="Ctrl+Enter">提交</div>
						<div onclick="doCancel()" class="btn_feedback" style="margin-left: 10px;">取消</div>
						<div id="submitload" style="float:left;margin-top: 5px;margin-left: 20px;display: none;"><img src='/images/loadingext.gif' align=absMiddle /></div>
						<div id="fbrelatebtn" style="width:58px;line-height:18px;float:right;margin-top: 5px;margin-right:25px;display: none;
							background: url('../images/btn_down.png') right no-repeat;color: #004080;cursor: pointer;" _status="0">附加信息</div>
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
								  		<%if(canupload){ %>
								  		<div id="fbUploadDiv" class="upload" mainId="<%=mainid %>" subId="<%=subid %>" secId="<%=docsecid %>" maxsize="<%=maxsize %>"></div>
								  		<%}else{ %>
								  		<font color="red">未设置附件上传目录!</font>
								  		<%} %>
								  		<!--  <div id="fbUploadDiv" class="upload" mainId="82" subId="357" secId="1108" maxsize="60"></div>-->
								  	</td>
								</tr>
							</TBODY>
						</table>
						<div id="fbbottom" style="width: 1px;height: 1px;"></div>
					</td>
				</tr>
		</table>
		<div id="dtitle4" class="dtitle" _click="0"><div class="dtxt">操作日志</div></div>
  		<div id="logdiv" style="width: 100%;text-align: left;overflow: hidden;">
			<jsp:include page="Operation.jsp">
				<jsp:param value="get_toplog" name="operation"/>
				<jsp:param value="<%=taskId %>" name="taskId"/>
			</jsp:include>
		</div>
		
	</div>
	
	<div id="dftitle" _index="" class="dtitle" onclick="showdtitle()" style="position: absolute;top: 40px;left: 0px;display: none;background: #EEEEEE;">
		<div id="dfhead" class="dtxt"></div>
	</div>
</div>
<script language=javascript defer>
	
</script>
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

		//添加查看日志
		$.ajax({
			type: "post",
		    url: "/workrelate/goal/data/Operation.jsp",
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
				if(getVal($("#begindate").val())!="" && getVal($("#enddate").val())!="" && !compdate($("#begindate").val(),$("#enddate").val())){
					alert("开始日期不能大于结束日期!");
					$("#begindate").val(tempbdate);
					return;
				}else{
					tempbdate = $("#begindate").val();
					doUpdate(this,1);
					resetSort();
				}
			}
		}).datepicker("setDate","<%=begindate%>");
		$( "#enddate" ).datepicker({
			"onSelect":function(){
				if(getVal($("#begindate").val())!="" && getVal($("#enddate").val())!="" && !compdate($("#begindate").val(),$("#enddate").val())){
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

		//表格行背景效果及操作按钮控制绑定
		$("table.datatable").find("tr").bind("click mouseenter",function(){
			$(".btn_add").hide();//$(".btn_browser").hide();
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
					url:"/workrelate/goal/data/GetData.jsp",
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
			//document.onkeydown=null;

			var _type = getVal($(this).parents("tr:first").attr("_type"));
			if(_type!="" && $("#fuzzyquery_query_div").length==0){
				setRelate(_type);
			}*/
		});

		//反馈信息内容样式
		$("#feedbacktable").find(".data").live("mouseover",function(){
			$(this).css("background-color","#F7FBFF");
		}).live("mouseout",function(){
			$(this).css("background-color","#fff");
		});

		//反馈附加信息按钮事件绑定
		$("#fbrelatebtn").bind("click",function(){
			var _status = $(this).attr("_status");
			if(_status==0){
				$("table.feedrelate").show();
				$(this).attr("_status",1).css("background", "url('../images/btn_up.png') right no-repeat");
			}else{
				$("table.feedrelate").hide();
				$(this).attr("_status",0).css("background", "url('../images/btn_down.png') right no-repeat");
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
				    url: "/workrelate/goal/data/Operation.jsp",
				    data:{"operation":"set_special","taskid":<%=taskId%>,"special":_special}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){
				    	$("#logdiv").prepend(data.responseText);
					}
			    });
			}
		});
		//标记按钮事件绑定
		$("div.todoitem").bind("mouseover",function(){
			$(this).addClass("todoitem_hover");
		}).bind("mouseout",function(){
			$(this).removeClass("todoitem_hover");
		}).bind("click",function(){
			var type = $(this).attr("_val");
			var val = $(this).html();
			var todotype = $("#div_todo_<%=taskId %>").attr("_todotype");
			var oldcate = $("#cate").html();
			if(val!=oldcate){
				$("#cate").html(val);
				$.ajax({
					type: "post",
				    url: "/workrelate/goal/data/Operation.jsp",
				    data:{"operation":"edit_field","taskId":"<%=taskId %>","fieldname":"cate","fieldvalue":filter(encodeURI(val)),"fieldtype":"str"}, 
				    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
				    complete: function(data){
				    	$("#logdiv").prepend(data.responseText);
				    	resetCate(taskid,type);
					}
			    });
			}
		});

		$("div.relbtn").bind("mouseover",function(){
			$(this).addClass("relbtn_hover");
		}).bind("mouseout",function(){
			$(this).removeClass("relbtn_hover");
		}).bind("click",function(){
			var _type = $(this).attr("_type");
			$(this).hide();
			$("#reltr"+_type).show().find("input.add_input").show().focus();
			$("#reltr"+_type).find("div.btn_browser").show();
		});

		$("#maininfo").scroll(function(){
			var tp = 0;
			for(var i=4;i>-1;i--){
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
		<%if(canedit && canupload){%>
		bindUploaderDiv($("#uploadDiv"),"relatedacc","<%=taskId%>");
		<%}%>
		<%if(canupload){%>
		bindUploaderDiv($("#fbUploadDiv"),"fbfileids","");
		<%}%>

		$('#maininfo').perfectScrollbar({"wheelSpeed": 40,"suppressScrollX":true});

		<%if(quickfb==1){%>showFeedback();<%}%>
	});

	function showAllSub(){
		$("#showsub").html("<img src='../images/loading3.gif' style='margin-top:4px;' />");
		$.ajax({
			type: "post",
		    url: "/workrelate/goal/data/Operation.jsp",
		    data:{"operation":"get_allsub","taskid":"<%=taskId%>","showallsub":"<%=showallsub%>","create":"<%=create?"1":"0"%>"}, 
		    contentType : "application/x-www-form-urlencoded;charset=UTF-8",
		    complete: function(data){
		    	$("#showsub").parent("tr").after(jQuery.trim(data.responseText)).remove();
			}
	    });
	}
</script>
<%!
	public String getFileDoc(String ids,String taskId,User user) throws Exception{
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
		            returnstr += "<a href=javaScript:openFullWindowHaveBar('/workrelate/goal/util/ViewDoc.jsp?id="+docid+"&taskId="+taskId+"') >"+docImagefilename+"</a>";
		            returnstr += "&nbsp;<a href='/workrelate/goal/util/ViewDoc.jsp?id="+docid+"&taskId="+taskId+"&fileid="+docImagefileid+"'>下载("+docImagefileSize/1000+"K)</a>";
		            returnstr += "&nbsp;"+ weaver.workrelate.util.TransUtil.getReviewLink(docImagefilename, docImagefileid, user.getLanguage(), user,1,docid,taskId,"")+"&nbsp;&nbsp;";
				}
			}
		}
		return returnstr;
	}
	public String getSubTask(String maintaskid,User user,int type,int showallsub,boolean create) throws Exception{
		String userid = user.getUID()+"";
		StringBuffer res = new StringBuffer();
		boolean editsub = false;
		boolean cancreate = false;
		RecordSet rs = new RecordSet();
		CommonTransUtil cmutil = new CommonTransUtil();
		StringBuffer sql = new StringBuffer();
		sql.append("select t1.id,t1.name,t1.principalid,t1.status from GM_GoalInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.parentid="+maintaskid);
		if(showallsub==0 && cmutil.getGoalMaint(userid)[0]==0){
			sql.append(" and (t1.principalid="+userid+" or t1.creater="+userid
				+ " or exists (select 1 from GM_GoalPartner tp where tp.goalid=t1.id and tp.partnerid="+userid+")"
				+ " or exists (select 1 from GM_GoalSharer ts where ts.goalid=t1.id and ts.sharerid="+userid+")"
				+ " or exists (select 1 from HrmResource hrm where (hrm.id=t1.principalid or hrm.id=t1.creater) and hrm.managerstr like '%,"+userid+",%')"
				+ " or exists (select 1 from HrmResource hrm,GM_GoalPartner tp where tp.goalid=t1.id and hrm.id=tp.partnerid and hrm.managerstr like '%,"+userid+",%')"
				+ ")");
		}
		sql.append(" order by t1.id");
		rs.executeSql(sql.toString());
		//if(rs.getCounts()>0){
			if(type==2) res.append("<tr class='subtable_tr'><td colspan='5' style='padding:0px;padding-left:20px;border:0px;height:auto'><table class='subdatalist' cellpadding='0' cellspacing='0' border='0' align='center'><colgroup><col width='20px'/><col width='*'/><col width='50px'/><col width='30px'/><col width='20px'/></colgroup>");
			while(rs.next()){
				cancreate = false;
				editsub = cmutil.getGoalRight(rs.getString("id"),user)==2?true:false;
				if(!editsub){
					if(create){
						RecordSet rs2 = new RecordSet();
						rs2.executeSql("select id from GM_GoalPartner tp where tp.goalid="+rs.getString("id")+" and tp.partnerid="+userid);
						if(rs2.next()) cancreate = true;
					}
				}else{
					cancreate = true;
				}
				res.append("<tr class='subitem_tr'>");
				res.append("<td><div class='status status"+rs.getString("status")+"'>&nbsp;</div></td>");
				res.append("<td class='item_td'>");
				res.append("	<input "+((!editsub)?"readonly='readonly'":"")+" onfocus='doClickSubItem(this)' onblur='doBlurSubItem(this)'");
				res.append("		class='subdisinput' type='text' name='' id='sub_"+rs.getString("id")+"' _pid='"+maintaskid+"' _createsub='"+(cancreate?1:0)+"' title='"+Util.null2String(rs.getString("name"))+"'");
				res.append("		value='"+Util.null2String(rs.getString("name"))+"' _defaultname='"+Util.null2String(rs.getString("name"))+"'/>");
				res.append("</td>");
				res.append("<td class='item_hrm' title='责任人'>"+this.getHrmLink(rs.getString("principalid"))+"</td>");
				res.append("<td class='item_view'><a href='javascript:refreshDetail("+rs.getString("id")+")'>查看</a></td>");
				res.append("<td class='item_add'>");
				if(cancreate) res.append("<div class='subadd' title='建立下级目标' onclick='addSubItem("+rs.getString("id")+")'>+</div>");
				res.append("</td>");
				res.append("</tr>");
				res.append(this.getSubTask(rs.getString("id"),user,2,showallsub,editsub));
			}
			if(type==2) res.append("</table></td></tr>");
		//}
		
		return res.toString();
	}
	public String getHrmLink(String id) throws Exception{
		String returnstr = "";
		if(!"".equals(id) && !"0".equals(id)){
			ResourceComInfo rc = new ResourceComInfo();
			returnstr = "<a href=javascript:searchList("+id+",'"+rc.getLastname(id)+"')>"+rc.getLastname(id)+"</a>";
		}else{
			returnstr = "&nbsp;";
		}
		return returnstr;
	}
	public String getParentid(String taskid) throws Exception{
		RecordSet rs = new RecordSet();
		rs.executeSql("select parentid from GM_GoalInfo where "+((!"oracle".equals(rs.getDBType()))?" parentid<>'' and ":"")+"  parentid is not null and parentid<>0 and id="+taskid);
		if(rs.next()){
			taskid = Util.null2String(rs.getString(1));
			if(!taskid.equals("")) taskid = this.getParentid(taskid);
		}
		return taskid;
	}
%>
