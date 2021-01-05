
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.conn.RecordSet"%>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowRequestInfo" %>
<%@ page import="weaver.mobile.webservices.workflow.WorkflowBaseInfo" %>
<%@ page import="weaver.general.WorkFlowTransMethod" %>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="session"/>
<jsp:useBean id="workflowServiceImpl" class="weaver.mobile.webservices.workflow.WorkflowServiceImpl" scope="session"/>

<%
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
RecordSet rs = new RecordSet();
String actionkey = Util.null2String(request.getParameter("actionkey"));
String actionkeyagain = Util.null2String(request.getParameter("actionkeyagain"));
int pageNo = Util.getIntValue(request.getParameter("pageNo"),-1);
//System.out.println("pageNo = "+pageNo);
int pageSize = 10;
String [] sqlConditions = null;
int userid = user.getUID();
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
int usertype = 0;
if(logintype.equals("1")) usertype = 0;
if(logintype.equals("2")) usertype = 1;
int recordCount = 0;
WorkflowRequestInfo[] wriarrays = null;
if("requestview".equals(actionkey)){
	String viewtype = Util.null2String(request.getParameter("viewtype"));
	if(!"0".equals(viewtype)){
		sqlConditions = new String[]{" t1.workflowid in (select wb.id from workflow_base wb,workflow_type wt where wb.workflowtype=wt.id and wt.id=  "+viewtype+")"};
	}else{
		sqlConditions = new String[]{};
	}
	recordCount = workflowServiceImpl.getToDoWorkflowRequestCount(userid, true, sqlConditions);
	wriarrays = workflowServiceImpl.getToDoWorkflowRequestList(true,pageNo,pageSize,recordCount,userid,sqlConditions,0);
}else if("requesthandle".equals(actionkey)){
	String handlestatus = Util.null2String(request.getParameter("handlestatus"));
	String handletype = Util.null2String(request.getParameter("handletype"));
	if(!"0".equals(handlestatus) && !"0".equals(handletype)){
		if("1".equals(handlestatus)){
			sqlConditions = new String[]{" t1.currentnodetype!='3' and t1.workflowid in (select wb.id from workflow_base wb,workflow_type wt where wb.workflowtype=wt.id and wt.id=  "+handletype+") "};
		}else{
			sqlConditions = new String[]{" t1.currentnodetype='3' and t1.workflowid in (select wb.id from workflow_base wb,workflow_type wt where wb.workflowtype=wt.id and wt.id=  "+handletype+") "};
		}
	}else if("0".equals(handlestatus) && !"0".equals(handletype)){
		sqlConditions = new String[]{" t1.workflowid in (select wb.id from workflow_base wb,workflow_type wt where wb.workflowtype=wt.id and wt.id=  "+handletype+") "};
	}else if(!"0".equals(handlestatus) && "0".equals(handletype)){
		if("1".equals(handlestatus)){
			sqlConditions = new String[]{" t1.currentnodetype!='3' "};
		}else{
			sqlConditions = new String[]{" t1.currentnodetype='3' "};
		}
	}else{
		sqlConditions = new String[]{};
	}
	recordCount = workflowServiceImpl.getMyWorkflowRequestCount(userid, sqlConditions);
	wriarrays = workflowServiceImpl.getMyWorkflowRequestList(pageNo,pageSize,recordCount,userid,sqlConditions,0);
}else if("searchresult".equals(actionkey)){
	List<String> searchList = new ArrayList<String>();
	String requestname = Util.null2String(request.getParameter("requestname"));
	String typeid = Util.null2String(request.getParameter("typeid"));
	String createrid = Util.null2String(request.getParameter("createrid"));
	String createdatefrom = Util.null2String(request.getParameter("createdatefrom"));
	String createdateto = Util.null2String(request.getParameter("createdateto"));
	String wfstatu = Util.null2String(request.getParameter("wfstatu"));
	if(!"".equals(requestname)){
		searchList.add(" t1.requestname like '%"+requestname+"%' ");
	}
	if(!"".equals(typeid)){
		searchList.add(" t1.workflowid in (select wb.id from workflow_base wb,workflow_type wt where wb.workflowtype=wt.id and wt.id=  "+typeid+") ");
	}
	if(!"".equals(createrid)){
		searchList.add(" t1.creater = " + createrid + " and t1.creatertype = 0 ");
	}
	if(!"".equals(createdatefrom)){
		searchList.add(" t1.createdate >= '"+createdatefrom+"' ");
	}
	if(!"".equals(createdateto)){
		searchList.add(" t1.createdate <= '"+createdateto+"' ");
	}
	if("1".equals(wfstatu)){
		searchList.add(" t2.isremark in('0','1','5','8','9','7') ");
	}else if("2".equals(wfstatu)){
		searchList.add(" t2.isremark in('2','4') ");
	}
	sqlConditions = searchList.toArray(new String[searchList.size()]); 
	recordCount = workflowServiceImpl.getAllWorkflowRequestCount(userid, sqlConditions);
	wriarrays = workflowServiceImpl.getAllWorkflowRequestList(pageNo,pageSize,recordCount,userid,sqlConditions);
}

String rtnstring = "[";
for(int i = 0;i<wriarrays.length;i++){
	WorkflowBaseInfo wbi = wriarrays[i].getWorkflowBaseInfo();
	String conodeid = wriarrays[i].getCurrentNodeId();
	String isremark = wriarrays[i].getIsremark()+"";
	String requestname = "";
	String nodetitle = "";
	String requestnamenew = wriarrays[i].getRequestName();
	//System.out.println("isremark = "+isremark);
	rtnstring +="{";
	rtnstring += "\"createrid\":"+wriarrays[i].getCreatorId()+",";
	rtnstring += "\"createrurl\":\""+resourceComInfo.getMessagerUrls(wriarrays[i].getCreatorId())+"\",";
	rtnstring += "\"requestid\":\""+wriarrays[i].getRequestId()+"\",";
	if("requestview".equals(actionkey) && "again".equals(actionkeyagain)){
		//viewtype 用户类型
		//WorkFlowTransMethod wt = new WorkFlowTransMethod();
		String agentorbyagentid = "";
		String agenttype = "";
		String cisprocessed = "";
		String viewtype = "";
		boolean isprocessed = false;
		boolean canContinue = false;
		//System.out.println("isremark = " + isremark);
		rs.executeSql("select isprocessed, isremark, userid, nodeid ,viewtype,agenttype from workflow_currentoperator where requestid = " + wriarrays[i].getRequestId() + " and userid = " + userid + " and isremark = '"+isremark+"' order by receivedate , receivetime  ");
		while(rs.next()) {
			viewtype = Util.null2String(rs.getString("viewtype"));
			agenttype = Util.null2String(rs.getString("agenttype"));
			//isprocessed = rs.getString("isprocessed");
			String cuserid = userid +"";
			
			String isremark_tmp = Util.null2String(rs.getString("isremark"));
			String isprocessed_tmp = Util.null2String(rs
					.getString("isprocessed"));
			String userid_tmp = Util.null2String(rs.getString("userid"));
			if ((isremark_tmp.equals("0") && (isprocessed_tmp.equals("2") || isprocessed_tmp
					.equals("3")))
					|| isremark_tmp.equals("5")) {
				isprocessed = true;
			}
			// 如果是被抄送或转发，判断是否正是某节点的操作人，取最后一次
			if (("8".equals(isremark) || "9".equals(isremark) || "1"
					.equals(isremark))
					&& cuserid.equals(userid_tmp)
					&& "0".equals(isremark_tmp)
					&& canContinue == false) {
				int nodeid_tmp = Util.getIntValue(rs.getString("nodeid"), 0);
				if (nodeid_tmp != 0) {
					isremark = isremark_tmp;
					conodeid = "" + nodeid_tmp;
					canContinue = true;
				}
			}
			if (isprocessed == true && canContinue == true) {
				break;
			}
			
		}
		cisprocessed = isprocessed+"";
		//System.out.println("requestnamenew1 = "+requestnamenew);
		rtnstring += "\"requestname\":\""+requestnamenew+"\",";
		rtnstring += "\"viewtype\":\""+viewtype+"\",";
		rtnstring += "\"agenttype\":\""+agenttype+"\",";
		rtnstring += "\"isprocessed\":\""+cisprocessed+"\",";
	}else{
		if ("0".equals(isremark)) {
			rs.executeSql("select t1.requestname,t2.nodetitle from workflow_requestbase t1,workflow_flownode t2 where t1.requestid ="+wriarrays[i].getRequestId()+
					" and t1.workflowid = t2.workflowid and t2.workflowid="+ wbi.getWorkflowId() + 
					" and t2.nodeid=" + conodeid);
			//System.out.println("select nodetitle from workflow_flownode where workflowid="
			//		+ wbi.getWorkflowId() + " and nodeid=" + conodeid);
			if (rs.next()) {
				requestname = Util.null2String(rs.getString("requestname"));
				nodetitle = Util.null2String(rs.getString("nodetitle"));
			}
		}
		if (!"".equals(requestname) && !"null".equalsIgnoreCase(requestname)) {
			int index = requestnamenew.indexOf(requestname);
			if(index > -1){
				requestnamenew = requestnamenew.substring(requestname.length());
				if(!"".equals(requestnamenew) && !"null".equalsIgnoreCase(requestnamenew)){
					requestnamenew = "<B>" + requestnamenew + "</B>";
				}
			}
		}
		
		if (!"".equals(nodetitle) && !"null".equalsIgnoreCase(nodetitle)) {
			nodetitle = "（" + nodetitle + "）";
		}
		requestnamenew = nodetitle + requestname + requestnamenew;
		rtnstring += "\"requestname\":\""+requestnamenew+"\",";
	}
	rtnstring += "\"creatername\":\""+resourceComInfo.getResourcename(wriarrays[i].getCreatorId())+"\",";
	rtnstring += "\"creatertime\":\""+wriarrays[i].getCreateTime()+"\",";
	rtnstring += "\"wftypename\":\""+wbi.getWorkflowTypeName()+"\",";
	rtnstring += "\"recordCount\":\""+recordCount+"\"";
	rtnstring += "}";
	rtnstring += ",";
}

if(rtnstring.length() > 1){
	rtnstring = rtnstring.substring(0,rtnstring.length()-1);
}

rtnstring += "]";
//System.out.println("rtnstring = "+rtnstring);
rtnstring = rtnstring.replaceAll("\\\\", "\\\\\\\\");
response.setContentType("application/json; charset=UTF-8");
java.io.PrintWriter writer = response.getWriter();
writer.write(rtnstring);
writer.flush();
writer.close();
%>