<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%@ page import="weaver.hrm.resource.ResourceComInfo"%>
<%@ include file="/page/maint/common/initNoCache.jsp"%>
<%@ page import="net.sf.json.JSONObject"%>
<%
	try{
		int planType = Util.getIntValue(request.getParameter("planType"),0);
		int planDay = Util.getIntValue(request.getParameter("planDay"),0);
		int begindate = Util.getIntValue(request.getParameter("ifBegindate"),0);
		int enddate = Util.getIntValue(request.getParameter("ifEnddate"),0);
		int perpage = Util.getIntValue(request.getParameter("perpage"),5);
		int eid = Util.getIntValue(request.getParameter("eid"),0);
		int pagenum = Util.getIntValue(request.getParameter("pagenum"),1);
		
		
		String planid = Util.null2String(request.getParameter("planid"));
		String programid = Util.null2String(request.getParameter("programid"));
		int iTotal = 0;
		String fromSql = "";
		if(planid.equals("")){
			fromSql += " from PR_PlanReportDetail t1 where t1.programid=" + programid;//读取模板中的默认内容
		}else{
			fromSql += " from PR_PlanReportDetail t1 where t1.datatype=2 and t1.planid=" + planid;//读取已保存的内容
		}
		rs.executeSql("select count(*)"+fromSql);
		if(rs.next()){
			iTotal = rs.getInt(1);
		}
		if(iTotal>0){
			String findSql = " t1.id,t1.name,t1.cate,t1.begindate1,t1.enddate1,t1.days1,t1.days2,t1.showorder";
			//order by t1.showorder,t1.id
			if(perpage==0) perpage = 5;
			int totalpage = iTotal / perpage;
			if(iTotal % perpage >0) totalpage += 1;
			int iNextNum = pagenum * perpage;
			int ipageset = perpage;
			if(iTotal - iNextNum + perpage < perpage) ipageset = iTotal - iNextNum + perpage;
			if(iTotal < perpage) ipageset = iTotal;
			String selSql = "";
			if(rs.getDBType().equals("oracle")){
				selSql = "select A.*,rownum rn from (select "+findSql+fromSql+
				" order by t1.showorder,t1.id) A where rownum<="+perpage;
			}else{
				selSql = "select top " + ipageset +" A.* from (select top "+ iNextNum+findSql+fromSql
				+" order by t1.showorder,t1.id) A order by A.showorder desc,A.id desc";
				selSql = "select top " + ipageset +" B.* from (" + selSql + ") B order by B.showorder,B.id";
			}
			rs.executeSql(selSql);
			int width = 100;
			int cols = 1;
			if(planType==1){
				width = width-12;
				cols++;
			}
			if(begindate==1){
				width = width-12;
				cols++;
			}
			if(enddate==1){
				width = width-12;
				cols++;
			}
			if(planDay==1){
				width = width-12;
				cols++;
			}
%>
		<table class="planListTable">
		<tr>
			<%if(planType==1){ %>
				<th width="12%"><%=SystemEnv.getHtmlLabelName(455,user.getLanguage())%></th>
			<%} %>
			<th width="<%=width%>%"><%=SystemEnv.getHtmlLabelName(24986,user.getLanguage())%></th>
			<%if(begindate==1){ %>
				<th width="12%"><%=SystemEnv.getHtmlLabelName(740,user.getLanguage())%></th>
			<%} %>
			<%if(enddate==1){ %>
				<th width="12%"><%=SystemEnv.getHtmlLabelName(741,user.getLanguage())%></th>
			<%} %>
			<%if(planDay==1){ %>
				<th width="12%"><%=SystemEnv.getHtmlLabelName(33625,user.getLanguage())%></th>
			<%} %>
		</tr>
		<%		
				while(rs.next()){
					int id = Util.getIntValue(rs.getString("id"),0);
		%>
		<tr>
			<%if(planType==1){ %>
				<td width="12%" title="<%=rs.getString("cate")  %>"><%=rs.getString("cate") %></td>
			<%} %>
			<td width="<%=width%>%" title="<%=rs.getString("name") %>">
				<a href="javascript:;" onclick="parent.openDetail<%=eid %>('<%=id %>')"><font class="font"><%=rs.getString("name") %></font></a>
			</td>
			<%if(begindate==1){ %>
				<td width="12%" title="<%=rs.getString("begindate1") %>"><%=rs.getString("begindate1") %></td>
			<%} %>
			<%if(enddate==1){ %>
				<td width="12%" title="<%=rs.getString("enddate1") %>"><%=rs.getString("enddate1") %></td>
			<%} %>
			<%if(planDay==1){ %>
				<td width="12%" title="<%=rs.getString("days1") %>"><%=rs.getString("days1") %></td>
			<%} %>
		</tr>
	<%}%>
		<%if(totalpage>1){ %>
			<tr><td colspan="<%=cols%>" align="right" style="padding-right:10px;">
				<a href="/workrelate/plan/data/PlanView.jsp?planid=<%=planid %>" target="_blank">MORE</a>
			</td></tr>
		<%} %>
		</table>
		<input type="hidden" id="taskTotal_<%=eid %>" value="<%=iTotal%>"/>
	<%}else{ 
			out.print("<div class='planTips'>"+SystemEnv.getHtmlLabelName(83974,user.getLanguage())+"</div>");
		}
	%>	
<%
		}catch(Exception e){
			out.print("<div class='planTips'>"+SystemEnv.getHtmlLabelName(83976,user.getLanguage())+"</div>");
		}
%>