
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.workflow.transfer.PermissionTransferMgr"%>
<%
	//System.out.println("=====================");
	/*用户验证*/
	User user = HrmUserVarify.getUser (request , response) ;
	if(user==null) {
	    response.sendRedirect("/login/Login.jsp");
	    return;
	}
	int optflag = Util.getIntValue(request.getParameter("optflag"), 0);
	String gids = Util.null2String(request.getParameter("gids"));
	int rlcobjid = Util.getIntValue(request.getParameter("rlcobjid"), 0);
	String objtype = Util.null2String(request.getParameter("objtype"));
	String objid= Util.null2String(request.getParameter("objid"));
	 
	
	if ("".equals(gids)) {
		return;
	}
	boolean result = false;
	//替换
	if (optflag == 0) {
	    result = PermissionTransferMgr.transfer(gids, rlcobjid,objtype,objid);
	    
	} else if (optflag == 1) { //复制 
	    result = PermissionTransferMgr.copy(gids, rlcobjid,objtype,objid);
	} else if (optflag == 2) { //删除
		  result = PermissionTransferMgr.delete(gids,objtype,objid);
	}
	if (result) {
	    response.getWriter().write("1");    
	} else {
	    response.getWriter().write("0");
	}
	
%>


