
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.hrm.resource.ResourceComInfo" %>
<%@ page import="weaver.workflow.msg.PoppupRemindInfoUtil" %>
<%@ page import="java.util.*,java.sql.Timestamp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />

<%
	String creatertype = request.getParameter("creatertype");
	String createrid = request.getParameter("createrid");
	String workflowid = request.getParameter("workflowid");
	String agent = request.getParameter("agent");
	String beagenter = request.getParameter("beagenter");

	String loginid = "";
	String password = "";

	ResourceComInfo rci = new ResourceComInfo();
	PoppupRemindInfoUtil priu = new PoppupRemindInfoUtil();

	if ( creatertype != null && creatertype.trim().equals("1") ) {
	  	loginid = rci.getLoginID(createrid);
	    password = rci.getPWD(createrid);
    } else {
        RecordSet.execute("select portalloginid,portalpassword from crm_customerinfo where id=" + createrid);
        if (RecordSet.next()) {
            loginid = Util.null2String(RecordSet.getString("portalloginid"));
            password = Util.null2String(RecordSet.getString("portalpassword"));
        }
    }
    if (!loginid.equals("")) {
        String para = priu.encrypt("/workflow/request/AddRequest.jsp"
        		+ "?fromtest=1"
				+ "&workflowid=" + workflowid
				+ "&createrid=" + createrid
				+ "&isagent=" + agent
				+ "&beagenter=" + beagenter
				+ "&isovertime=0"
				+ "#" + loginid 
				+ "#" + password);

        String forwardPage = "/login/VerifyRtxLogin.jsp?para=" + para + "&logintype=" + creatertype ;
        session.setAttribute("istest", "1");
        
        request.getRequestDispatcher(forwardPage).forward(request, response);
    }

%>