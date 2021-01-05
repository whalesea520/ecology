<%@ page language="java" contentType="application/json; charset=utf-8"%><%@ page
	import="java.util.*"%><%@ page import="weaver.hrm.*"%><%@ page
	import="weaver.systeminfo.*"%><%@ page import="weaver.general.*"%><%@ page
	import="weaver.workflow.layout.RequestDisplayInfo"%><%@page
	import="weaver.conn.RecordSet"%>
<%@page import="weaver.workflow.layout.WorkflowPicDisplayData"%>
<%@page import="com.alibaba.fastjson.JSONObject"%>
<%
    User user = HrmUserVarify.getUser(request, response);
    int workflowid = Util.getIntValue(request.getParameter("wfid"), 0);
    int requestid = Util.getIntValue(request.getParameter("requestid"), -1);
    //查询formid isBill isCust id workflowname
    String isBill = "";
    String formid = "";
    String isCust = "";
    String workflowname = "";
    RecordSet rst = new RecordSet();
    if (workflowid == 0) {
        // 查询请求的相关工作流基本信息
        rst.executeProc("workflow_Requestbase_SByID", requestid + "");
        if (rst.next()) {
            workflowid = Util.getIntValue(rst.getString("workflowid"), 0);
        }
    }
    //查询该工作流的表单id，是否是单据（0否，1是），帮助文档id
    rst.executeProc("workflow_Workflowbase_SByID", workflowid + "");
    if (rst.next()) {
        formid = Util.null2String(rst.getString("formid"));
        isCust = Util.null2String(rst.getString("isCust"));
        workflowname = Util.null2String(rst.getString("workflowname"));
        isBill = "" + Util.getIntValue(rst.getString("isbill"), 0);
    }

    WorkflowPicDisplayData wfPicDisplayData = new WorkflowPicDisplayData();
    wfPicDisplayData.setWorkflowid(workflowid);
    wfPicDisplayData.setRequestid(requestid);
    wfPicDisplayData.setFormid(Util.getIntValue(formid));
    wfPicDisplayData.setIsbill(Util.getIntValue(isBill));
    wfPicDisplayData.setWorkflowname(workflowname);
    wfPicDisplayData.setUser(user);

    Map<String, Object> wfdata = wfPicDisplayData.getDisplayData();
    //JSONObject jo = JSONObject.fromObject(wfdata);
    //String str = JSONObject.toJSONString(wfdata);
    response.getWriter().write(JSONObject.toJSONString(wfdata));
%>