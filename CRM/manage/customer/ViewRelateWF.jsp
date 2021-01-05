
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/page/maint/common/initNoCache.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="OperateUtil" class="weaver.crm.util.OperateUtil" scope="page" />
<jsp:useBean id="WorkFlowTransMethod" class="weaver.general.WorkFlowTransMethod" scope="page" />
<link rel="stylesheet" href="../css/Base_wev8.css" />
<link rel="stylesheet" href="../css/Contact_wev8.css" />
<%
	String userid = user.getUID()+"";
	String customerid = Util.null2String(request.getParameter("customerid"));
	if(!OperateUtil.checkRight(customerid,user.getUID()+"",1,1)){
		out.println("暂无权限查看此客户！");
	    return;
	}
%>
		<div class="listtitle">拜访记录</div>
		<table class="viewlist" cellpadding="0" cellspacing="0" border="0">
			<colgroup><col width="44%"/><col width="10%"/><col width="17%"/><col width="17%"/><col width="12%"/></colgroup>
		    <tbody>
		<%
			//外出/出差流程
			String sql = "select t1.requestid,t1.requestname,t1.currentnodeid,t2.resourceId as hrm,t2.fromDate,t2.fromTime,t2.toDate,t2.toTime"
					+" from workflow_requestbase t1,Bill_BoHaiEvection t2 where t1.requestid=t2.requestid and t1.workflowid=207 and (t1.deleted=0 or t1.deleted is null) and (t1.deleted <> 1 or t1.deleted is null or t1.deleted='')"
					+" and convert(varchar,t2.field_1531677550)='"+customerid+"'"
					+" and exists(select 1 from workflow_currentoperator t3 where t1.requestid=t3.requestid and t3.userid=" + userid + " and t3.isremark in ('2','4','0','1','9','7'))"
					+" order by t1.createdate desc,t1.createtime desc";
			rs.executeSql(sql);
			if(rs.getCounts()>0){
				while(rs.next()){
		%>
				<tr>
					<td>
						<a href="javascript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid=<%=rs.getString("requestid") %>')">
							<%=Util.toScreen(rs.getString("requestname"),user.getLanguage()) %>
						</a>
					</td>
					<td>
						<a href="/hrm/resource/HrmResource.jsp?id=<%=rs.getString("hrm") %>" target="_blank"><%=ResourceComInfo.getLastname(rs.getString("hrm")) %></a>
					</td>
					<td>
						<%=Util.null2String(rs.getString("fromDate"))+" "+Util.null2String(rs.getString("fromTime")) %>
					</td>
					<td>
						<%=Util.null2String(rs.getString("toDate"))+" "+Util.null2String(rs.getString("toTime")) %>
					</td>
					<td><%=WorkFlowTransMethod.getCurrentNode(rs.getString("currentnodeid")) %></td>
				</tr>
		<%		} 
			}else{
		%>
				<tr><td class="nodata" colspan="5">暂无相关记录</td></tr>
		<%	} %>
			</tbody>
		</table>
		
		<div class="listtitle">费用发生记录</div>
		<table class="viewlist" cellpadding="0" cellspacing="0" border="0">
			<colgroup><col width="44%"/><col width="10%"/><col width="17%"/><col width="17%"/><col width="12%"/></colgroup>
		    <tbody>
		<%
			//费用报销流程
			sql = "select t1.requestid,t1.requestname,t1.currentnodeid,t2.resourceId as hrm,t2.occurdate,t2.amount"
					+" from workflow_requestbase t1,bill_HrmFinance t2 where t1.requestid=t2.requestid and t1.workflowid=60 and (t1.deleted=0 or t1.deleted is null) and (t1.deleted <> 1 or t1.deleted is null or t1.deleted='')"
					+" and t2.field_1772107054='"+customerid+"'"
					+" and exists(select 1 from workflow_currentoperator t3 where t1.requestid=t3.requestid and t3.userid=" + userid + " and t3.isremark in ('2','4','0','1','9','7'))"
					+" order by t1.createdate desc,t1.createtime desc";
			rs.executeSql(sql);
			if(rs.getCounts()>0){
				while(rs.next()){
		%>
				<tr>
					<td>
						<a href="javascript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid=<%=rs.getString("requestid") %>')">
							<%=Util.toScreen(rs.getString("requestname"),user.getLanguage()) %>
						</a>
					</td>
					<td>
						<a href="/hrm/resource/HrmResource.jsp?id=<%=rs.getString("hrm") %>" target="_blank"><%=ResourceComInfo.getLastname(rs.getString("hrm")) %></a>
					</td>
					<td>
						<%=Util.null2String(rs.getString("occurdate")) %>
					</td>
					<td>
						<%=Util.null2String(rs.getString("amount")) %>
					</td>
					<td><%=WorkFlowTransMethod.getCurrentNode(rs.getString("currentnodeid")) %></td>
				</tr>
		<%		} 
			}else{
		%>
				<tr><td class="nodata" colspan="5">暂无相关记录</td></tr>
		<%	} %>
			</tbody>
		</table>
		
		<div class="listtitle">礼品申请记录</div>
		<table class="viewlist" cellpadding="0" cellspacing="0" border="0">
			<colgroup><col width="44%"/><col width="10%"/><col width="10%"/><col width="14%"/><col width="10%"/><col width="12%"/></colgroup>
		    <tbody>
		<%
			//日常商务礼品申领
			sql = "select t1.requestid,t1.requestname,t1.currentnodeid,t2.resource_n as hrm,t2.date6,t3.desc1,t3.integer1"
					+" from workflow_requestbase t1,workflow_form t2,workflow_formdetail t3 where t1.requestid=t2.requestid and t1.requestid=t3.requestid and t1.workflowid=233 and (t1.deleted=0 or t1.deleted is null) and (t1.deleted <> 1 or t1.deleted is null or t1.deleted='')"
					+" and ','+convert(varchar,t3.muticrm)+',' like '%,"+customerid+",%'"
					+" and exists(select 1 from workflow_currentoperator t3 where t1.requestid=t3.requestid and t3.userid=" + userid + " and t3.isremark in ('2','4','0','1','9','7'))"
					+" order by t1.createdate desc,t1.createtime desc";
			//System.out.println(sql);
			rs.executeSql(sql);
			if(rs.getCounts()>0){
				while(rs.next()){
		%>
				<tr>
					<td>
						<a href="javascript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid=<%=rs.getString("requestid") %>')">
							<%=Util.toScreen(rs.getString("requestname"),user.getLanguage()) %>
						</a>
					</td>
					<td>
						<a href="/hrm/resource/HrmResource.jsp?id=<%=rs.getString("hrm") %>" target="_blank"><%=ResourceComInfo.getLastname(rs.getString("hrm")) %></a>
					</td>
					<td>
						<%=Util.null2String(rs.getString("date6")) %>
					</td>
					<td>
						<%=Util.null2String(rs.getString("desc1")) %>
					</td>
					<td>
						<%=Util.null2String(rs.getString("integer1")) %>
					</td>
					<td><%=WorkFlowTransMethod.getCurrentNode(rs.getString("currentnodeid")) %></td>
				</tr>
		<%		} 
			}else{
		%>
				<tr><td class="nodata" colspan="6">暂无相关记录</td></tr>
		<%	} %>
			</tbody>
		</table>
		
		<div class="listtitle">合同审批记录</div>
		<table class="viewlist" cellpadding="0" cellspacing="0" border="0">
			<colgroup><col width="44%"/><col width="10%"/><col width="34%"/><col width="12%"/></colgroup>
		    <tbody>
		<%
			//三类合同审批流程
			sql = "select t.requestid,t.requestname,t.createdate,t.createtime,t.currentnodeid,t.hrm,t.money from ("
					+"select t1.requestid,t1.requestname,t1.createdate,t1.createtime,t1.currentnodeid,t2.sqr as hrm,t2.htzje as money"
					+" from workflow_requestbase t1,formtable_main_24 t2 where t1.requestid=t2.requestid and t1.workflowid=270 and (t1.deleted=0 or t1.deleted is null) and (t1.deleted <> 1 or t1.deleted is null or t1.deleted='')"
					+" and t2.crm = '"+customerid+"'"
					+" and exists(select 1 from workflow_currentoperator t3 where t1.requestid=t3.requestid and t3.userid=" + userid + " and t3.isremark in ('2','4','0','1','9','7'))"
					+" union all"
					+" select t1.requestid,t1.requestname,t1.createdate,t1.createtime,t1.currentnodeid,t2.sqr as hrm,t2.htzje as money"
					+" from workflow_requestbase t1,formtable_main_26 t2 where t1.requestid=t2.requestid and t1.workflowid=272 and (t1.deleted=0 or t1.deleted is null) and (t1.deleted <> 1 or t1.deleted is null or t1.deleted='')"
					+" and convert(varchar,t2.khmc) = '"+customerid+"'"
					+" and exists(select 1 from workflow_currentoperator t3 where t1.requestid=t3.requestid and t3.userid=" + userid + " and t3.isremark in ('2','4','0','1','9','7'))"
					+" union all"
					+" select t1.requestid,t1.requestname,t1.createdate,t1.createtime,t1.currentnodeid,t2.sqr as hrm,t2.htzje as money"
					+" from workflow_requestbase t1,formtable_main_25 t2 where t1.requestid=t2.requestid and t1.workflowid=271 and (t1.deleted=0 or t1.deleted is null) and (t1.deleted <> 1 or t1.deleted is null or t1.deleted='')"
					+" and convert(varchar,t2.khmc) = '"+customerid+"'"
					+" and exists(select 1 from workflow_currentoperator t3 where t1.requestid=t3.requestid and t3.userid=" + userid + " and t3.isremark in ('2','4','0','1','9','7'))"
					+") t"
					+" order by t.createdate desc,t.createtime desc";
			//System.out.println(sql);
			rs.executeSql(sql);
			if(rs.getCounts()>0){
				while(rs.next()){
		%>
				<tr>
					<td>
						<a href="javascript:openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?requestid=<%=rs.getString("requestid") %>')">
							<%=Util.toScreen(rs.getString("requestname"),user.getLanguage()) %>
						</a>
					</td>
					<td>
						<a href="/hrm/resource/HrmResource.jsp?id=<%=rs.getString("hrm") %>" target="_blank"><%=ResourceComInfo.getLastname(rs.getString("hrm")) %></a>
					</td>
					<td>
						<%=Util.null2String(rs.getString("money")) %>
					</td>
					<td><%=WorkFlowTransMethod.getCurrentNode(rs.getString("currentnodeid")) %></td>
				</tr>
		<%		} 
			}else{
		%>
				<tr><td class="nodata" colspan="4">暂无相关记录</td></tr>
		<%	} %>
			</tbody>
		</table>


