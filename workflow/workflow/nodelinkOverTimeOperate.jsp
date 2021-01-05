<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="weaver.general.*"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<%
	String id = Util.null2String(request.getParameter("id")).trim();
	String operate = Util.null2String(request.getParameter("operate"));
	String haspasstime = Util.null2String(request.getParameter("haspasstime"));
	String linkid = Util.null2String(request.getParameter("linkid"));
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	int selectnodepass = Util.getIntValue(request.getParameter("selectnodepass"), 1);
	int nodepasshour = Util.getIntValue(request.getParameter("nodepasshour"), 0);
	int nodepassminute = Util.getIntValue(request.getParameter("nodepassminute"), 0);
	String datefield = Util.null2String(request.getParameter("datefield"));
	String timefield = Util.null2String(request.getParameter("timefield"));
	
	String remindname = Util.null2String(request.getParameter("remindname"));
	String remindtype = Util.null2String(request.getParameter("remindtype"));
	int remindhour = Util.getIntValue(request.getParameter("remindhour"), 0);
	int remindminute = Util.getIntValue(request.getParameter("remindminute"), 0);
	String repeatremind = Util.null2String(request.getParameter("repeatremind"));
	int repeathour = Util.getIntValue(request.getParameter("repeathour"), 0);
	int repeatminute = Util.getIntValue(request.getParameter("repeatminute"), 0);
	String FlowRemind = Util.null2String(request.getParameter("FlowRemind"));
	String MsgRemind = Util.null2String(request.getParameter("MsgRemind"));
	String MailRemind = Util.null2String(request.getParameter("MailRemind"));
	String ChatsRemind = Util.null2String(request.getParameter("ChatsRemind"));
	String InfoCentreRemind = Util.null2String(request.getParameter("InfoCentreRemind"));
	int CustomWorkflowid = Util.getIntValue(request.getParameter("CustomWorkflowid"), 0);
	String isnodeoperator = Util.null2String(request.getParameter("isnodeoperator"));
	String iscreater = Util.null2String(request.getParameter("iscreater"));
	String ismanager = Util.null2String(request.getParameter("ismanager"));
	String isother = Util.null2String(request.getParameter("isother"));
	String remindobjectids = Util.null2String(request.getParameter("remindobjectids"));
	
	if("add".equals(operate)) {
		String sql = "insert into workflow_nodelinkOverTime (linkid, workflowid, remindname, remindtype, remindhour, remindminute, repeatremind, repeathour, repeatminute, FlowRemind, MsgRemind, MailRemind, ChatsRemind, InfoCentreRemind, CustomWorkflowid, isnodeoperator, iscreater, ismanager, isother, remindobjectids) "
				+ " values(" + linkid + ", " + workflowid + ", '" + remindname.replace("'", "''") + "', " + remindtype + ", " + remindhour + ", " + remindminute + ", " + repeatremind + ", " + repeathour + ", " + repeatminute + ", '" + FlowRemind + "', '" + MsgRemind + "', '" + MailRemind + "', '" + ChatsRemind + "', '" + InfoCentreRemind + "', " + CustomWorkflowid
				+ ", '" + isnodeoperator + "', '" + iscreater + "', '" + ismanager + "', '" + isother + "', '" + remindobjectids.replace("'", "''") + "') ";
		if(rs.executeSql(sql)) {
			sql = "select * from workflow_nodelinkOverTime where linkid=" + linkid + " and workflowid=" + workflowid + " and remindname='" + remindname.replace("'", "''") + "' and remindtype=" + remindtype + " and remindhour=" + remindhour + " and remindminute=" + remindminute
				+ " and repeatremind=" + repeatremind + " and repeathour=" + repeathour+ " and repeatminute=" + repeatminute + " and FlowRemind='" + FlowRemind + "' and MsgRemind='" + MsgRemind + "' and MailRemind='" + MailRemind + "' "
				+ " and ChatsRemind='" + ChatsRemind + "' and InfoCentreRemind='" + InfoCentreRemind + "' and CustomWorkflowid=" + CustomWorkflowid + " and isnodeoperator='" + isnodeoperator + "' and iscreater='" + iscreater + "' "
				+ " and ismanager='" + ismanager + "' and isother='" + isother + "' "
				+ " order by id desc ";
			rs.executeSql(sql);
			if(rs.next()) {
				id = Util.null2String(rs.getString("id"));
			}
			if("0".equals(haspasstime)) { // 之前未设置超时时间，保存一次
				sql = "update workflow_nodelink set selectnodepass=" + selectnodepass + ", nodepasshour=" + nodepasshour + ", nodepassminute=" + nodepassminute + ", datefield='" + datefield.replace("'", "''") + "', timefield='" + timefield.replace("'", "''") + "' where id=" + linkid;
				rs.executeSql(sql);
			}
			sql = "update workflow_currentoperator set lastRemindDatetime = '0_2000-01-01 00:00:00' where workflowid <> 1 and isremark = '0' and lastRemindDatetime is null "
				+ " and (isreminded = '1' or isreminded_csh = '1') and nodeid = (select nodeid from workflow_nodelink where id=" + linkid + ")";
			rs.executeSql(sql); // 更新升级之前的记录，给出一个初始的上次提醒时间
		}
		out.clear();
		out.print(id);
	}else if("edit".equals(operate)) {
		String sql = "update workflow_nodelinkOverTime set remindname='" + remindname.replace("'", "''") + "', remindtype=" + remindtype + ", remindhour=" + remindhour + ", remindminute=" + remindminute
				+ ", repeatremind=" + repeatremind + ", repeathour=" + repeathour+ ", repeatminute=" + repeatminute + ", FlowRemind='" + FlowRemind + "', MsgRemind='" + MsgRemind + "', MailRemind='" + MailRemind + "' "
				+ ", ChatsRemind='" + ChatsRemind + "', InfoCentreRemind='" + InfoCentreRemind + "', CustomWorkflowid=" + CustomWorkflowid + ", isnodeoperator='" + isnodeoperator + "', iscreater='" + iscreater + "' "
				+ ", ismanager='" + ismanager + "', isother='" + isother + "', remindobjectids='" + remindobjectids.replace("'", "''") + "' "
				+ " where id=" + id;
		if(rs.executeSql(sql)) {
			sql = "update workflow_currentoperator set lastRemindDatetime = '" + id + "_2000-01-01 00:00:00' where workflowid <> 1 and isremark = '0' and lastRemindDatetime is null "
				+ " and (isreminded = '1' or isreminded_csh = '1') and nodeid = (select nodeid from workflow_nodelink where id=" + linkid + ")";
			rs.executeSql(sql); // 更新升级之前的记录，给出一个初始的上次提醒时间
			
			int CustomWorkflowid_old = Util.getIntValue(request.getParameter("CustomWorkflowid_old"), 0);
			if(CustomWorkflowid != CustomWorkflowid_old) { // 修改过触发的流程，删去原字段设置
				rs.executeSql("delete from workflow_nodelinkOTField where overTimeId=" + id);
			}
		}
		out.clear();
		out.print(id);
	}else if("delete".equals(operate)) {
		rs.executeSql("delete from workflow_nodelinkOverTime where id in (" + id + ")");
	}else if("setField".equals(operate)) {
		rs.executeSql("delete from workflow_nodelinkOTField where overTimeId=" + id);
		String[] toFieldIds = request.getParameterValues("toFieldId");
		for(int i = 0; i < toFieldIds.length; i++) {
			int toFieldId = Util.getIntValue(toFieldIds[i], 0);
			int fromFieldId = Util.getIntValue(Util.null2String(request.getParameter("fromFieldId_" + toFieldId)), 0);
			String toFieldName = Util.null2String(request.getParameter("toFieldName_" + toFieldId));
			int toFieldGroupid = Util.getIntValue(Util.null2String(request.getParameter("toFieldGroupid_" + toFieldId)), 0);
			if(toFieldId == 0 || fromFieldId == 0) {
				continue;
			}
			String sql = "insert into workflow_nodelinkOTField(overTimeId, toFieldId, toFieldName, toFieldGroupid, fromFieldId) values(" + id + ", " + toFieldId + ", '" + toFieldName + "', " + toFieldGroupid + ", " + fromFieldId + ") ";
			rs.executeSql(sql);
		}
%>
		<script type="text/javascript">
			parent.getDialog(window).close();
		</script>
<%
	}
%>