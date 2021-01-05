<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="net.sf.json.JSONObject"%>
<jsp:useBean id="baseBean" class="weaver.general.BaseBean" scope="page"/>
<%

	String countSql = "select count(t1.id) as amount ";
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
	int userid = user.getUID();
	String sql1 = "from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.creater<>"+userid
			+" and (t1.principalid = "+userid
			+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
			//+" or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")"
			+")"
			+" and not exists (select 1 from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+")";
		
	String sql2 = "from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null)"	
			+" and (t1.creater = "+userid+" or t1.principalid = "+userid
			+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+")"
			+" or exists (select 1 from TM_TaskSharer ts where ts.taskid=t1.id and ts.sharerid="+userid+")"
			+")"
			+" and "+func1+"((select "+createdt+" from TM_TaskFeedback t3 where t3.taskid=t1.id and t3.hrmid<>"+userid+"),'')"
			+" > "+func1+"((select "+operatedt+" from TM_TaskLog t2 where t2.taskid=t1.id and t2.type=0 and t2.operator="+userid+"),'')";
	String currentdate = TimeUtil.getCurrentDateString();		
	String sql3 = "from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.status=1"
			+" and (t1.principalid = "+userid
			+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+"))"
			+" and exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.tododate<>'1' and tt.userid="+userid+" and tt.tododate<='"+currentdate+"')"
			;
	String sql4 = "from TM_TaskInfo t1 where (t1.deleted=0 or t1.deleted is null) and t1.status=1"
			+" and (t1.principalid = "+userid
			+" or exists (select 1 from TM_TaskPartner tp where tp.taskid=t1.id and tp.partnerid="+userid+"))"
			+" and exists(select 1 from TM_TaskTodo tt where tt.taskid=t1.id and tt.tododate<>'1' and tt.userid="+userid+" and tt.tododate='"+TimeUtil.dateAdd(currentdate,1)+"')"
			;
	String[] sqls = {sql1,sql2,sql3,sql4};
	String operate = Util.null2String(request.getParameter("operate"));
	if(operate.equals("getCount")){
		baseBean.writeLog(sql2);
		int newcount = 0;
		int fbcount = 0;
		int todaycount = 0;
		int tomorrowcount = 0;
		rs.executeSql(countSql+sql1);
		if(rs.next()){
			newcount = rs.getInt(1);
		}
		rs.executeSql(countSql+sql2);
		if(rs.next()){
			fbcount = rs.getInt(1);
		}
		rs.executeSql(countSql+sql3);
		if(rs.next()){
			todaycount = rs.getInt(1);
		}
		rs.executeSql(countSql+sql4);
		if(rs.next()){
			tomorrowcount = rs.getInt(1);
		}
		JSONObject json = new JSONObject();
		json.put("newcount",newcount);
		json.put("fbcount",fbcount);
		json.put("todaycount",todaycount);
		json.put("tomorrowcount",tomorrowcount);
		//baseBean.writeLog(json.toString());
		out.print(json.toString());
	}else if(operate.equals("getTaskList")){
		int index = Util.getIntValue(request.getParameter("index"),1);
		int eid = Util.getIntValue(request.getParameter("eid"),0);
		if(index>4)index=1;
		int perpage = Util.getIntValue(request.getParameter("perpage"),5);
		String selSql = sqls[index-1];
		try{
			int iTotal = 0;
			rs.executeSql(countSql+selSql);
			if(rs.next()){
				iTotal = rs.getInt(1);
			}
			if(iTotal>0){
				int creater = Util.getIntValue(request.getParameter("creater"),0);
				int principalid = Util.getIntValue(request.getParameter("principalid"),0);
				int begindate = Util.getIntValue(request.getParameter("begindate"),0);
				int enddate = Util.getIntValue(request.getParameter("enddate"),0);
				String findSql = " t1.id,t1.name,t1.status,t1.creater,t1.principalid,t1.begindate,t1.enddate,t1.createdate,"+
				"t1.createtime,(select count(tfb.id) from TM_TaskFeedback tfb where tfb.taskid=t1.id) as fbcount ";
				if(perpage==0) perpage = 5;
				int totalpage = iTotal / perpage;
				if(iTotal % perpage >0) totalpage += 1;
				int pagenum=1;
				int iNextNum = pagenum * perpage;
				int ipageset = perpage;
				if(iTotal - iNextNum + perpage < perpage) ipageset = iTotal - iNextNum + perpage;
				if(iTotal < perpage) ipageset = iTotal;
				if(rs.getDBType().equals("oracle")){
					selSql = "select A.*,rownum rn from (select "+findSql+selSql+
					" order by t1.createdate desc,t1.createtime desc) A where rownum<="+perpage;
				}else{
					selSql = "select top " + ipageset +" A.* from (select top "+ iNextNum+findSql+selSql
					+" order by t1.createdate desc,t1.createtime desc) A order by A.createdate,A.createtime";
					selSql = "select top " + ipageset +" B.* from (" + selSql + ") B order by B.createdate desc,B.createtime desc";
				}
				rs.executeSql(selSql);
				int width = 100;
				if(creater==1){
					width = width-12;
				}
				if(principalid==1){
					width = width-12;
				}
				if(begindate==1){
					width = width-12;
				}
				if(enddate==1){
					width = width-12;
				}
%>
		<table class="taskListTable">
		<tr>
			<th width="<%=width%>%"><%=SystemEnv.getHtmlLabelName(24986, user.getLanguage())%></th>
			<%if(creater==1){ %>
				<th width="12%"><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></th>
			<%} %>
			<%if(principalid==1){ %>
				<th width="12%"><%=SystemEnv.getHtmlLabelName(84043, user.getLanguage())%></th>
			<%} %>
			<%if(begindate==1){ %>
				<th width="12%"><%=SystemEnv.getHtmlLabelName(740, user.getLanguage())%></th>
			<%} %>
			<%if(enddate==1){ %>
				<th width="12%"><%=SystemEnv.getHtmlLabelName(741, user.getLanguage())%></th>
			<%} %>
		</tr>
		<%		ResourceComInfo rc = new ResourceComInfo();
				while(rs.next()){
					String lastName = rc.getLastname(rs.getString("creater"));
					String princName = rc.getLastname(rs.getString("principalid"));
					int fbCount = Util.getIntValue(rs.getString("fbcount"),0);
		%>
		<tr>
			<td width="<%=width%>%" title="<%=rs.getString("name") %>">
				<a href="/workrelate/task/data/Main.jsp?taskid=<%=rs.getString("id") %>" 
				target="_blank"><font class="font"><%=rs.getString("name") %>&nbsp;(<%=fbCount %>)</font></a>
			</td>
			<%if(creater==1){ %>
				<td width="12%" title="<%=lastName %>"><%=lastName %></td>
			<%} %>
			<%if(principalid==1){ %>
				<td width="12%" title="<%=princName %>"><%=princName %></td>
			<%} %>
			<%if(begindate==1){ %>
				<td width="12%" title="<%=rs.getString("begindate") %>"><%=rs.getString("begindate") %></td>
			<%} %>
			<%if(enddate==1){ %>
				<td width="12%" title="<%=rs.getString("enddate") %>"><%=rs.getString("enddate") %></td>
			<%} %>
		</tr>
	<%}%>
		</table>
		<input type="hidden" id="taskTotal_<%=eid %>" value="<%=iTotal%>"/>
	<%}else{ 
			out.print("<div class='taskTips'>"+SystemEnv.getHtmlLabelName(84044, user.getLanguage())+"</div>");
		}
	%>	
<%
		}catch(Exception e){
			out.print("<div class='taskTips'>"+SystemEnv.getHtmlLabelName(83976, user.getLanguage())+"</div>");
		}
	}
%>