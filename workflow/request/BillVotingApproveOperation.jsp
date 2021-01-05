<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.fna.budget.BudgetApproveWFHandler"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*,java.text.SimpleDateFormat" %>
<%@ page import="java.sql.Timestamp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="DocViewer" class="weaver.docs.docs.DocViewer" scope="page"/>
<jsp:useBean id="CrmViewer" class="weaver.crm.CrmViewer" scope="page"/>
<jsp:useBean id="PrjViewer" class="weaver.proj.PrjViewer" scope="page"/>
<%@ page import="weaver.file.FileUpload" %>
<%
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
String test = Util.null2String(fu.getParameter("test"));
String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = 1;
int billid = Util.getIntValue(fu.getParameter("billid"),1);
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
String nodetype = Util.null2String(fu.getParameter("nodetype"));
String requestname = Util.fromScreen(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(fu.getParameter("remark"));

String votingid = Util.null2String(fu.getParameter("votingid"));//获取网上调查ID
if(workflowid == -1) {
	workflowid = Util.getIntValue(fu.getParameter("approvewfid"));
}
String viewvoting = Util.null2String(fu.getParameter("viewvoting"));
String smsAlertsType = "";
if("1".equals(viewvoting) && !"".equals(votingid)) {//从网上调查触发进来


	String sql = "select t2.id, t2.formid, t2.workflowtype, t2.messageType,t2.smsAlertsType, t3.nodeid "
			+ "from workflow_base t2 , workflow_flownode t3 "
			+ "where t2.id = t2.id and t2.id = t3.workflowid and t2.id = "+workflowid+" and t3.nodetype='0' ";
	rs.executeSql(sql);
	if(rs.next()) {
		formid = Util.getIntValue(rs.getString("formid"), 0);
		workflowid = Util.getIntValue(rs.getString("id"), 0);
		workflowtype = rs.getString("workflowtype");
		nodeid = Util.getIntValue(rs.getString("nodeid"), 0);
		messageType = rs.getString("messageType");
		smsAlertsType = rs.getString("smsAlertsType");
	}
	if(messageType.equals("1"))messageType=smsAlertsType;
	rs.executeSql("select subject from voting where id ="+votingid);
	if(rs.next()) {
		requestname = ""+SystemEnv.getHtmlLabelName(24095,user.getLanguage())+"-"+rs.getString(1);
	}
	
}
if(src.equals("") || workflowid == -1 || formid == -1 || nodeid == -1) {
	//response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");	
    return ;
}

RequestManager.setSrc(src);
RequestManager.setIscreate(iscreate);
RequestManager.setRequestid(requestid);
RequestManager.setWorkflowid(workflowid);
RequestManager.setWorkflowtype(workflowtype);
RequestManager.setIsremark(isremark) ;
RequestManager.setFormid(formid);
RequestManager.setIsbill(isbill);
RequestManager.setBillid(billid);
RequestManager.setNodeid(nodeid);
RequestManager.setNodetype(nodetype);
RequestManager.setRequestname(requestname);
RequestManager.setRequestlevel(requestlevel);
RequestManager.setRemark(remark);
RequestManager.setRequest(fu);
RequestManager.setUser(user);
RequestManager.setMessageType(messageType);

boolean savestatus = RequestManager.saveRequestInfo();
requestid = RequestManager.getRequestid();

if("1".equals(iscreate) && !"".equals(votingid)) {
	rs.executeSql("update bill_VotingApprove set votingname="+votingid+" where requestid ="+requestid);//加入调查单据表信息


}
if(!savestatus) {
    if( requestid != 0 ) {
        String message=RequestManager.getMessage();
        if(!"".equals(message)){
			out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message="+message+"');</script>");
            return ;
        }
    	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
		out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1');</script>");
        return ;
    } else {
    	//response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
        out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
        return ;
    }
}

boolean flowstatus = RequestManager.flowNextNode() ;
if(!flowstatus) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
	return ;
}
if(flowstatus) {
	boolean logstatus = RequestManager.saveRequestLog() ;
}
char flag = 2;
if ("".equals(votingid)){
		rs.executeSql("select votingname from bill_VotingApprove where requestid="+requestid);	   
		if (rs.next())  votingid = rs.getString("votingname");
}
//审批通过更新网上调查状态


if(RequestManager.getNextNodetype().equals("3") && src.equals("submit")) {
    
	/***获取表单字段id**/
	String fieldid = "";
	String votingtmp = "";
	rs.executeSql("select id from workflow_billfield where billid ="+formid);
	if(rs.next()) fieldid = Util.null2String(rs.getString(1));
	if(!"".equals(fieldid)) {
		votingtmp = Util.null2String(fu.getParameter("field"+fieldid));//获取审批通过后的调查id
	}
	
	if(!"".equals(votingtmp)) votingid = votingtmp;
	
	if(!"".equals(votingid)) {
		Date newdate = new Date();
	    long datetime = newdate.getTime();
	    Timestamp timestamp = new Timestamp(datetime);
	    String CurrentDate = (timestamp.toString()).substring(0, 4) + "-" + (timestamp.toString()).substring(5, 7) + "-" + (timestamp.toString()).substring(8, 10);
	    String CurrentTime = (timestamp.toString()).substring(11, 13) + ":" + (timestamp.toString()).substring(14, 16) + ":" + (timestamp.toString()).substring(17, 19);
	    String userid = user.getUID() + "";
		
	    //增加相关文档,项目,客户,流程共享 added by mackjoe at 2007-01-23 td5558
	    int docids = 0;
	    int crmids = 0;
	    int projids = 0;
	    rs.executeSql("select a.docid,a.crmid,a.projid,a.requestid,b.* from voting a,votingshare b where a.id=b.votingid and a.id=" + votingid);
	    while (rs.next()) {
	        docids = Util.getIntValue(rs.getString("docid"));
	        crmids = Util.getIntValue(rs.getString("crmid"));
	        projids = Util.getIntValue(rs.getString("projid"));
	        String sharetype = Util.null2String(rs.getString("sharetype"));
	        String seclevel = Util.null2String(rs.getString("seclevel"));
	        String rolelevel = Util.null2String(rs.getString("rolelevel"));
	        String resourceid = Util.null2String(rs.getString("resourceid"));
	        String subcompanyid = Util.null2String(rs.getString("subcompanyid"));
	        String departmentid = Util.null2String(rs.getString("departmentid"));
	        String roleid = Util.null2String(rs.getString("roleid"));
	        String foralluser = Util.null2String(rs.getString("foralluser"));
	        String ProcPara = "";
	        if (docids > 0) {
	            ProcPara = docids + "";
	            ProcPara += flag + sharetype;
	            ProcPara += flag + seclevel;
	            ProcPara += flag + rolelevel;
	            ProcPara += flag + "1";
	            ProcPara += flag + resourceid;
	            ProcPara += flag + subcompanyid;
	            ProcPara += flag + departmentid;
	            ProcPara += flag + roleid;
	            ProcPara += flag + foralluser;
	            ProcPara += flag + "0";              //  crmid
	            rs.executeProc("DocShare_IFromDocSecCategory", ProcPara);
	        }
	        if (crmids > 0 && !sharetype.equals("2")) {
	            if(sharetype.equals("3"))  sharetype="2";
	            if(sharetype.equals("4"))  sharetype="3";
	            if(sharetype.equals("5"))  sharetype="4";
	            ProcPara = crmids+"";
	            ProcPara += flag+sharetype;
	            ProcPara += flag+seclevel;
	            ProcPara += flag+rolelevel;
	            ProcPara += flag+"1";
	            ProcPara += flag+resourceid;
	            ProcPara += flag+departmentid;
	            ProcPara += flag+roleid;
	            ProcPara += flag+foralluser;
	            rs.executeProc("CRM_ShareInfo_Insert",ProcPara);
	        }
	        if (projids > 0 && !sharetype.equals("2")) {
	            if(sharetype.equals("3"))  sharetype="2";
	            if(sharetype.equals("4"))  sharetype="3";
	            if(sharetype.equals("5"))  sharetype="4";
	            ProcPara = projids+"";
	            ProcPara += flag+sharetype;
	            ProcPara += flag+seclevel;
	            ProcPara += flag+rolelevel;
	            ProcPara += flag+"1";
	            ProcPara += flag+resourceid;
	            ProcPara += flag+departmentid;
	            ProcPara += flag+roleid;
	            ProcPara += flag+foralluser;
	
	            rs.executeProc("Prj_ShareInfo_Insert",ProcPara);
	        }
	    }
	    if (docids > 0) DocViewer.setDocShareByDoc(""+docids);
	    if (crmids > 0) CrmViewer.setCrmShareByCrm(""+crmids);
	    if (projids > 0) PrjViewer.setPrjShareByPrj(""+projids);
	
	    rs.executeProc("Voting_UpdateStatus", votingid + flag + "1");
	    String sql = "update voting set approverid=" + userid + ",approvedate='" + CurrentDate + "',approvetime='" + CurrentTime + "' where id=" + votingid;
	    rs.executeSql(sql);	    
	}
} else if (src.equals("reject")){
		rs.executeProc("Voting_UpdateStatus", votingid + flag + "0");	
} else if(!RequestManager.getNextNodetype().equals("3") && src.equals("submit")) {
		rs.executeProc("Voting_UpdateStatus", votingid + flag + "3");	
}
if("1".equals(viewvoting) && !"".equals(votingid)) {
	//response.sendRedirect("/voting/VotingView.jsp?isfromworkflow=1&votingid="+votingid);
    out.print("<script>wfforward('/voting/VotingView.jsp?votingid="+votingid+"');</script>");
	return;
}
//response.sendRedirect("/workflow/request/RequestView.jsp");

 //原来是 wfforward89644 此方法，由于本次要求统一处理 操作者相同直接打开流程，不是直接关闭
//out.print("<script>wfforward89644('/workflow/request/RequestView.jsp');</script>");
%><%@ include file="/workflow/request/RedirectPage.jsp" %> 
