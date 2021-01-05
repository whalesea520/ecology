
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.conn.RecordSet"%>
<%
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
	RecordSet rs = new RecordSet();
	int ruleid = Util.getIntValue(request.getParameter("ruleid"));
	String from = Util.null2String(request.getParameter("from"));
	String typeids = Util.null2String(request.getParameter("typeids"));
	if(!"".equals(from) && from.equals("ruleManager") && !"".equals(typeids)){
		typeids = typeids.substring(0,typeids.length()-1);
		String[] tempids = Util.TokenizerString2(typeids, ",");
		for(String tempid : tempids){
			RuleBusiness.deleteRule(Util.getIntValue(tempid));
		}
	  }else{
	    RuleBusiness.deleteRule(ruleid);
	  }
	response.sendRedirect("/workflow/ruleDesign/ruleList.jsp");
	//return;
%>

