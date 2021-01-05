<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.conn.RecordSet"%>
<%

int rulesrc = Util.getIntValue(request.getParameter("rulesrc"), 0);
int linkid = Util.getIntValue(request.getParameter("linkid"), 0);
//更新触发条件
String conditionss = Util.null2String(request.getParameter("conditionss"));
String conditionsscn = Util.null2String(request.getParameter("conditioncn"));

if (rulesrc > 0 && linkid > 0) {
    RecordSet rs = new RecordSet();
    if (rulesrc == 7) {
        rs.executeUpdate("update Workflow_SubwfSet set condition=?, conditioncn=? where id=" + linkid, conditionss, conditionsscn);
    } else {
        rs.executeUpdate("update Workflow_TriDiffWfDiffField set condition=?, conditioncn=?  where id=" + linkid, conditionss, conditionsscn);
    }
}

%>