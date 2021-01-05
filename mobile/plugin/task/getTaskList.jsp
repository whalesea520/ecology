<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ page import="weaver.general.*"%>
<%@page import="weaver.file.FileUpload"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />

<%
	try{
		request.setCharacterEncoding("UTF-8");
		FileUpload fu = new FileUpload(request);
		int pageNum = Util.getIntValue(fu.getParameter("pageNum"),1);
		int i = Util.getIntValue(fu.getParameter("itemType"),0);
		
		String userid = user.getUID()+"";
		String principalid = userid;
		String func1 = "";
		String operatedt = "";
		String createdt = "";
		if(!"oracle".equals(rs.getDBType())){
			func1 = "isnull";
			operatedt = "max(operatedate+' '+operatetime)";
			createdt = "max(createdate+' '+createtime)";
		}else{
			func1 = "nvl";
			operatedt = "max(CONCAT(CONCAT(operatedate,' '),operatetime))";
			createdt = "max(CONCAT(CONCAT(createdate,' '),createtime))";
		}
		
		String	basesql = " t1.id,t1.name,t1.status,t1.creater,t1.principalid,t1.lev,t1.begindate,t1.enddate,t1.createdate,t1.createtime,t1.showallsub "
				+",(select count(tfb.id) from TM_TaskFeedback tfb where tfb.taskid=t1.id) as fbcount"
				+",(select "+operatedt+" from TM_TaskLog tlog where tlog.taskid=t1.id and tlog.type=0 and tlog.operator="+userid+") as lastviewdate"
				+",(select "+createdt+" from TM_TaskFeedback fb where fb.taskid=t1.id and fb.hrmid<>"+userid+") as lastfbdate"
				+","+func1+"((select distinct 1 from TM_TaskSpecial tts where tts.taskid=t1.id and tts.userid="+userid+"),0) as special"
				+",(select max(tt.tododate) from TM_TaskTodo tt where tt.taskid=t1.id and tt.userid="+user.getUID()+") as tododate"
				+",(select "+operatedt+" from TM_TaskLog tlog where tlog.taskid=t1.id and tlog.type not in (0,11,12)) as lastoperatedate"
				+" from TM_TaskInfo t1 "
				+" where (t1.deleted=0 or t1.deleted is null)";

		
		String countsql = "select count(t1.id) as amount from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)";
		String typewhere = "";
		StringBuffer sqlwhere = new StringBuffer();
		String currentdate = TimeUtil.getCurrentDateString();
		int sorttype = Util.getIntValue(fu.getParameter("listType"),5);//todo
		int status = Util.getIntValue(fu.getParameter("status"),1);//进行中
		String condtype = Util.null2String(fu.getParameter("menuType"));//我负责的
		String selTag = Util.null2String(fu.getParameter("SELTAG"));
		
		if(condtype.equals("-1")){
			condtype = "1";
		}
		if(sorttype==-1){
			sorttype = 5;
		}
		if(status==-1){
			status = 0;
		}
		
		if(sorttype==5) status=1;//Todolist视图是显示进行中
		int hrmid = Util.getIntValue(fu.getParameter("hrmid"),0);//下属任务的ID
		
		if(condtype.equals("7")){//已完成新反馈
			status=2;//新完成的任务 状态为完成
			sorttype=1;//列表展示
		}
		if(condtype.equals("1")){//本人相关的任务
			sqlwhere.append(" and (t1.principalid="+userid
			+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+"))");
		}else if(condtype.equals("2")){//本人创建的任务
			sqlwhere.append(" and t1.creater="+userid);
		}else if(condtype.equals("3")){//本人负责的任务
			sqlwhere.append(" and t1.principalid="+userid);
		}else if(condtype.equals("4")){//本人参与的任务
			sqlwhere.append(" and exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")");
		}else if(condtype.equals("5")){//被分享的任务
			sqlwhere.append(" and exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")");
		}else if(condtype.equals("6")){//标记关注的任务
			sqlwhere.append(" and exists (select 1 from TM_TaskSpecial special where special.taskid=t1.id and special.userid="+userid+")");
		}else if(condtype.equals("7")){//已完成新反馈的任务
			sqlwhere.append(" and t1.status=2 and (t1.principalid="+user.getUID()+" or t1.creater="+user.getUID()
			+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+user.getUID()+")"
			+ " or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+user.getUID()+")"
			+ " or exists (select 1 from TM_TaskSpecial special where special.taskid=t1.id and special.userid="+userid+")"
			+ ")");
			sqlwhere.append(" and ("+func1+"((select "+createdt+" from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+"),'')"
				+">"+func1+"((select "+operatedt+" from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+"),''))");
		}else if(condtype.equals("8")){//我分配的任务
			sqlwhere.append(" and t1.creater="+userid+" and t1.principalid<>"+userid);
		}else if(condtype.equals("0")){//能查看的所有任务
			sqlwhere.append(" and (t1.principalid="+user.getUID()+" or t1.creater="+user.getUID()
			+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+user.getUID()+")"
			+ " or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+user.getUID()+")"
			+ " or exists (select 1 from HrmResource hrm where (hrm.id=t1.principalid or hrm.id=t1.creater) and hrm.managerstr like '%,"+user.getUID()+",%')"
			+ " or exists (select 1 from HrmResource hrm,TM_TaskPartner tp where tp.taskid=t1.id and hrm.id=tp.partnerid and hrm.managerstr like '%,"+user.getUID()+",%')"
			+ ")");
			if(hrmid!=0){
				principalid = hrmid+"";
				sqlwhere.append(" and (t1.principalid="+hrmid 
				+ " or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+hrmid+"))");
			}
		}
		if(status>0) sqlwhere.append(" and t1.status="+status);
		if(sorttype==4) sqlwhere.append(" and (t1.parentid='' or t1.parentid is null)");
		if(!selTag.equals("")){
			sqlwhere.append(" and (t1.tag like '%,"+selTag+",%' or t1.name like '%"+selTag+"%')");
		}
		String[] datetype = {""};
		int _pagesize = 5;
		String disPlay = "";
		if(sorttype==1){//列表
			_pagesize = 10;
			disPlay = "display:none;";
		}else if(sorttype==2){//到日期
			datetype = new String[]{"已延期","今天到期","明天到期","以后到期","无到期日"};
		}else if(sorttype==3){//紧急程度
			datetype = new String[]{"重要紧急","重要不紧急","不重要紧急","不重要不紧急","未设置"};
		}else if(sorttype==5){//Todolist
			datetype = new String[]{"今天","明天","即将","不标记","备忘"};
		}
		
		if(sorttype==2){//到日期
			if(i==0){
				typewhere = " and t1.enddate<>'' and t1.enddate is not null and t1.enddate<'"+currentdate+"'";
			}else if(i==1){
				typewhere = " and t1.enddate='"+currentdate+"'";
			}else if(i==2){
				typewhere = " and t1.enddate='"+TimeUtil.dateAdd(currentdate,1)+"'";
			}else if(i==3){
				typewhere = " and t1.enddate<>'' and t1.enddate is not null and t1.enddate>'"+TimeUtil.dateAdd(currentdate,1)+"'";
			}else{
				typewhere = " and (t1.enddate='' or t1.enddate is null)";
			}
		}else if(sorttype==3){//紧急程度
			if(i==4){
				typewhere = " and (t1.lev=0 or t1.lev is null)";
			}else{
				typewhere = " and t1.lev="+(i+1);
			}
		}else if(sorttype==5){//Todolist
			if(i==0){
				typewhere = " and exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.tododate<>'1' and tt.userid="+principalid+" and tt.tododate<='"+currentdate+"')";
			}else if(i==1){
				typewhere = " and exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.tododate<>'1' and tt.userid="+principalid+" and tt.tododate='"+TimeUtil.dateAdd(currentdate,1)+"')";
			}else if(i==2){
				typewhere = " and exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.tododate<>'1' and tt.userid="+principalid+" and tt.tododate>'"+TimeUtil.dateAdd(currentdate,1)+"')";
			}else if(i==3){
				typewhere = " and not exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.userid="+principalid+")";
			}else if(i==4){
				typewhere = " and exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.tododate='1' and tt.userid="+principalid+")";
			}
		}
		int iTotal = 0; 
		rs.executeSql(countsql+sqlwhere.toString()+typewhere);
		if(rs.next()){
			iTotal = rs.getInt(1);
		}
		String orderby1 = " order by lastoperatedate desc";
		String orderby2 = " order by lastoperatedate asc";
		String orderby3 = " order by lastoperatedate desc";
		
		int viewId = Util.getIntValue(fu.getParameter("viewId"),0);
		if(pageNum==1&&i==0){
			//将视图记忆到数据库中
			String viewdate = TimeUtil.getCurrentTimeString();
			String sql = "";
			if(viewId==0){//数据库没有记录
				sql = "insert into TM_TaskView (userid,menutype,listtype,status,viewdate,taskid,seltag,subuserid) values"
				+" ("+userid+","+condtype+","+sorttype+","+status+",'"+viewdate+"',0,'"+selTag+"',0)";
			}else{
				sql = "update TM_TaskView set menutype="+condtype+",listtype="+sorttype+",status="
				+status+",viewdate='"+viewdate+"',seltag='"+selTag+"' where id="+viewId;
			}
			rs.execute(sql);
			if(viewId==0){
				rs.execute("select id from TM_TaskView where userid="+user.getUID());
				if(rs.next()){
					viewId = rs.getInt("id");
				}
			}
		}
		
%>
<%if(pageNum==1&&i==0){ %>
	<input type="hidden" id="viewId" value="<%=viewId %>"/>
<%} %>
<%if(pageNum==1){ %>
<div class="itemDiv">
	<div class="itemTitle" style="<%=disPlay %>>" id="itemTitle<%=i%>">
		<%=datetype[i] %>
		<div class="titleCreate" itemType="<%=i%>">&nbsp;</div>
	</div>
	<div id="itemContent<%=i%>">
<%} %>
<%		
		int totalpage = 0;
		if(iTotal>0){
			totalpage = iTotal / _pagesize;
			if(iTotal % _pagesize >0) totalpage += 1;
			int iNextNum = pageNum * _pagesize;
			int ipageset = _pagesize;
			if(iTotal - iNextNum + _pagesize < _pagesize) ipageset = iTotal - iNextNum + _pagesize;
			if(iTotal < _pagesize) ipageset = iTotal;
			String querysql = basesql+sqlwhere.toString()+typewhere;
			String sql = "";
			int dcount = 0;
			if(rs.getDBType().equals("oracle")){
				sql = "select " + querysql+ orderby3;
				sql = "select A.*,rownum rn from (" + sql + ") A where rownum <= " + (iNextNum-dcount);
				sql = "select B.* from (" + sql + ") B where rn > " + (iNextNum -dcount - _pagesize);
			}else{
				sql = "select top " + ipageset +" A.* from (select top "+ (iNextNum-dcount) + querysql+ orderby3 + ") A "+orderby2;
				sql = "select top " + ipageset +" B.* from (" + sql + ") B "+orderby1;
			}
			//System.out.println(sql);
			rs.executeSql(sql);
			ResourceComInfo rc = new ResourceComInfo();
			while(rs.next()){
				boolean canEdit = false;
				String dutyMan = rc.getLastname(rs.getString("principalid"));
				String createMan = rc.getLastname(rs.getString("creater"));
				String name = rs.getString("name");
				String id = rs.getString("id");
				String _principalid = Util.null2String(rs.getString("principalid"));
				String _createrid = Util.null2String(rs.getString("creater"));
				if(_principalid.equals(userid) || _createrid.equals(userid)) 
					canEdit = true; 
				else 
					canEdit = false;
				int _status = rs.getInt("status");
				String statustitle = "";
				if(canEdit){
					if(_status==1){
						statustitle = "标记完成";
					}else if(_status==2 || _status==3){
						statustitle = "标记进行";
					}
				}
				int special = Util.getIntValue(rs.getString("special"),0);
				//判断是否未读
				boolean isnew = false;boolean noreadfb = false;
				String lastviewdate = Util.null2String(rs.getString("lastviewdate"));//最后查看时间
				String lastfbdate = Util.null2String(rs.getString("lastfbdate"));//最后反馈时间
				if(_createrid.equals(userid)){
					isnew = false;
				}else{
					if(lastviewdate.equals("")){
						isnew = true;
					}else{
						isnew = false;
					}
				}
				if(!lastfbdate.equals("")){
					if(lastviewdate.equals("") || TimeUtil.dateInterval(lastviewdate,lastfbdate)>0){
						noreadfb = true;
					}else{
						noreadfb = false;
					}
				}else{
					noreadfb = false;
				}
%>
			<div class="listitem"  id="listItem<%=id%>">
				<table class="listTable" taskId="<%=id%>" id="listTable_<%=id %>" ifFb="0">
					<tr>
						<td colspan="3" title="<%=name %>" class="showNameTd <%if(isnew){%>newNameTd<%}%>">
							<%=name %>
						</td>
						<td width="30"><span <%if(noreadfb){%>class='item_count_new'<%}%>>(<%=rs.getString("fbcount") %>)</span></td>
						<td width="24"><img src="/mobile/plugin/task/images/icon.png" height="12" width="12"></td>
					</tr>
				</table>
				<div id='operate_<%=id %>' ifShow="1" class='operatediv' _taskid='<%=id%>'>
					<%if(canEdit){ %>
					<div class='operatebtn item_del' taskid="<%=id %>">删&nbsp;&nbsp;除</div>
					<%} %>
					<div class='operatebtn item_fb' taskid="<%=id %>">反&nbsp;&nbsp;馈</div>
					<div class='operatebtn item_att' taskid="<%=id %>" special="<%=special %>"><%if(special==0){%>添加关注<%}else{%>取消关注<%}%></div>
					<%if(canEdit){ %>
						<div class='operatebtn item_status' status='<%=_status%>' taskid="<%=id %>"><%=statustitle%></div>
					<%} %>
				</div>
			</div>
			<script>
				touch.on(document.getElementById("listItem<%=id%>"),'touchstart', function(e){
					//e.preventDefault();
				});
				//touch.on(document.getElementById("listItem<%=id%>"),'swipestart', function(e){
				//	e.preventDefault();
				//});
				touch.on(document.getElementById("listItem<%=id%>"),"swipeleft swiperight", function(e){
					swipe(e,<%=id%>);
				});
				
			</script>
		<%}%>
		<%if(pageNum==1){ %>
		<input type="hidden" id="pageNum_<%=sorttype %>_<%=condtype %>_<%=i %>" value="<%=pageNum%>"/>
		<input type="hidden" id="totalPage_<%=sorttype %>_<%=condtype %>_<%=i %>" value="<%=totalpage%>"/>
		<%} %>
		<%}else{
			out.println("<div class='taskTips'>暂无任务</div>");
		}
%>	
<%if(pageNum==1){ %>
</div>
<%if(totalpage>pageNum){ %>
	<div class="showMoreTask" itemType="<%=i%>" id="showMoreTask_<%=sorttype %>_<%=condtype %>_<%=i %>">更多</div>
<%} %>	
</div>
<%}%>
<%
	}catch(Exception e){
		out.print("<div class='taskTips'>数据加载失败,请稍后再试</div>");
	}
%>