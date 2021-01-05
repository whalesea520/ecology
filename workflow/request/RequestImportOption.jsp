
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,java.net.*"%>
<%@ page import="weaver.file.FileUpload" %>
<%@page import="weaver.hrm.User"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestImport" class="weaver.workflow.request.RequestImport" scope="session"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DateUtil" class="weaver.general.DateUtil" scope="page" />
<%


	
	String username = user.getUsername();
    FileUpload fu = new FileUpload(request);
	String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");
	String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");
	user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;
	int userid = user.getUID();
	String usertype="0";
	if(user.getLogintype().equals("2")) usertype="1";
    String src = Util.null2String(fu.getParameter("src"));
    int imprequestid = Util.getIntValue(fu.getParameter("imprequestid"),-1);
    int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
    String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
    int formid = Util.getIntValue(fu.getParameter("formid"),-1);
    int isbill = Util.getIntValue(fu.getParameter("isbill"),1);
    int newmodeid = Util.getIntValue(fu.getParameter("newmodeid"),-1);
    int ismode = Util.getIntValue(fu.getParameter("ismode"),-1);
    int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
    String nodetype = Util.null2String(fu.getParameter("nodetype"));
    String isfrom = Util.null2String(fu.getParameter("isfrom"));
    String requestname = "";
    if("fromcreate".equals(isfrom)){
    	requestname = Util.fromScreen3(fu.getParameter("requestname"),user.getLanguage());
    }
    //流程导入时标题不导入，重新生成标题
    if("".equals(requestname)){
    	//requestname = DateUtil.getWFTitle(""+workflowid,""+userid,""+username);
    	RecordSet.executeSql("SELECT requestname FROM workflow_requestbase WHERE requestid="+imprequestid);
    	if(RecordSet.next()){
    		requestname = RecordSet.getString("requestname");
        }
    }
    //String requestname=DateUtil.getWFTitle(""+workflowid,""+userid,""+username);
    String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
    //String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
    //String chatsType =  Util.fromScreen(fu.getParameter("chatsType"), user.getLanguage());//微信提醒(QC:98106)
    RecordSet.executeSql("select smsAlertsType,chatsAlertType from workflow_base where id = " + workflowid);
    String messageType =  "";
    String chatsType =  "";//微信提醒(QC:98106)
    if(RecordSet.next()){
    	messageType = RecordSet.getString("smsAlertsType");
    	chatsType = RecordSet.getString("chatsAlertType");
    }
    int isagentCreater = Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()));
    int beagenter = Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+user.getUID()),0);
    if( !src.equals("import") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
        out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
        return ;
    }
    RequestImport.setImprequestid(imprequestid);
    RequestImport.setNewworkflowid(workflowid);
    RequestImport.setNewworkflowtype(workflowtype);
    RequestImport.setNewformid(formid);
    RequestImport.setNewisbill(isbill);
    RequestImport.setNewnodeid(nodeid);
    RequestImport.setNewnodetype(nodetype);
    RequestImport.setNewrequestname(requestname);
    RequestImport.setNewrequestlevel(requestlevel);
    RequestImport.setNewmessageType(messageType);
    RequestImport.setNewchatsType(chatsType);//微信提醒(QC:98106)
    RequestImport.setNewisagent(isagentCreater);
    RequestImport.setNewbeagenter(beagenter);
    RequestImport.setNewuserid(user.getUID());
    RequestImport.setNewusertype((user.getLogintype()).equals("1") ? 0 : 1);
    RequestImport.setNewmodeid(newmodeid);
    RequestImport.setIsmode(ismode);
    int newrequestid=RequestImport.Import();
    if(newrequestid>0){
    	if("fromcreate".equals(isfrom)){
    	    //response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+newrequestid+"&isovertime=0");
        	out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid="+newrequestid+"&isovertime=0');</script>");
	        return ;
    	}else{
        	out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&requestid="+newrequestid+"');</script>");
	        return ;
    	}
        	//out.print("<script>openFullWindowHaveBarForWFList('/workflow/request/ViewRequest.jsp?requestid="+newrequestid+"&isovertime=0',"+newrequestid+");</script>");
    }else{
        out.print("<script>alert('"+SystemEnv.getHtmlLabelName(84515,user.getLanguage())+"');wfforward('/workflow/request/AddRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&workflowid="+workflowid+"&isagent="+isagentCreater+"&beagenter="+beagenter+"');</script>");
        return ;
    }
%>