
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.conn.RecordSet"%>
<%
//System.out.println("=====================");
/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
	RecordSet rs = new RecordSet();
	int mpid = Util.getIntValue(request.getParameter("id"));
	String mpids = Util.null2String(request.getParameter("ids"));
	//System.out.println(mpids);
	
	if (!"".equals(mpids)) {
	    String[] ids = Util.TokenizerStringNew(mpids, ",");
	    for (int i=0; i<ids.length; i++) {
	        String id = ids[i];
	        RuleBusiness.deleteRuleMapping(Integer.parseInt(id));	        
	    }
	} else {
	    RuleBusiness.deleteRuleMapping(mpid);	        
	}
	
	response.sendRedirect("/workflow/ruleDesign/ruleMappingList.jsp");
	//return;
%>

