
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="java.net.URLDecoder"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.workflow.ruleDesign.RuleBean"%>
<jsp:useBean id="WorkflowComminfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<%

User user = HrmUserVarify.getUser(request, response) ;
if (user == null ) return ;


RuleBusiness rulebusiness = new RuleBusiness();
int id = Util.getIntValue(request.getParameter("ruleid"), -1);
String reid = id+"";
String rulename = URLDecoder.decode(Util.null2String(request.getParameter("name")), "UTF-8");
String ruledesc = URLDecoder.decode(Util.null2String(request.getParameter("desc")), "UTF-8");
RuleBean rb = new RuleBean();
rb.setRulename(rulename);
rb.setRuledesc(ruledesc);
rb.setRulesrc("3");
rb.setFormid("-1");
rb.setLinkid("-1");
if (id > 0) {
	RecordSet.executeSql("select count(0) num from rule_base where rulename='"+rulename+"' and id!="+id);
	int num =0;
	if(RecordSet.first())
		 num = Util.getIntValue(RecordSet.getString("num"));
	if(num > 0)
	{
		response.getWriter().write("num");
		return;
	}
    RuleBusiness.updateRule(id, rb);
} else {
	RecordSet.executeSql("select count(0) num from rule_base where rulename='"+rulename+"'");
	int num =0;
	if(RecordSet.first())
		 num = Util.getIntValue(RecordSet.getString("num"));
	if(num > 0)
	{
		response.getWriter().write("num");
		return;
	}
	reid = RuleBusiness.newRule(rb);    
}
response.getWriter().write(reid);
%>
