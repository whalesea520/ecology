
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.conn.*,weaver.workflow.request.*,weaver.general.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%!
private int getWorkFlowID(String customerid){
	RecordSet rs = new RecordSet();
	rs.executeSql("select type from crm_customerinfo where id = " + customerid);
	if (rs.next()){
		String type = Util.null2String(rs.getString("type"));
		RecordSet rs1 = new RecordSet();
		String sql = "select contacterworkflowid from CRM_CustomerType where id=" + type;
		rs1.executeSql(sql);
		if (rs1.next())
		    return rs1.getInt("contacterworkflowid");
	}
	return 0;
}

private int getBillID(String title,String name,String customer,String email,String tel,String mobile,String fax,String responsibility,String remark){
	RecordSet rs = new RecordSet();
	String sql = "insert into bill_Contacter(title,name,customer,email,tel,mobile,fax,responsibility,remark) values(" +
		  "" + title + "" + "," +
		  "'" + name + "'" + "," +
		  "" + customer + "" + "," +
		  "'" + email + "'" + "," +
		  "'" + tel + "'" + "," +
		  "'" + mobile + "'" + "," +
		  "'" + fax + "'" + "," +
		  "'" + responsibility + "'" + "," +
		  "'" + remark + "'" + "" +
		  ")";
	rs.executeSql(sql);
	sql="select max(id) as id from bill_Contacter where name='" + name + "' and customer = " + customer ;
	rs.executeSql(sql);
	rs.next();
	return rs.getInt("id");
}

private int getCustomerManager(String customer) {
	RecordSet rs = new RecordSet();
	rs.executeSql("select manager from crm_customerinfo where id = " + customer);
	if (rs.next()){
		return Util.getIntValue(rs.getString("manager"));
	}
	return 0;
}

private int NewFlow(int workflowid,int billid,int manager) {
    boolean flagbool = false;
    
    RecordSet rs = new RecordSet();
    
    User user = getUserfromDB(manager);
    
    char flag = Util.getSeparator();
    
    int isbill = 1;
    int formid = 0;
    int nodeid = 0;
    int lastnodeid = 0;
    String lastnodetype = "";
    String workflowtype = "";
    String messageType = "";
    String nodetype = "0";
    String status = "";
    int passedgroups = 0;
    int totalgroups = 0;
    int creater = user.getUID();
    int creatertype = 0;
    String requestname = SystemEnv.getHtmlLabelName(136,7)+SystemEnv.getHtmlLabelName(572,7)+SystemEnv.getHtmlLabelName(129,7);
    int lastoperator = 0;
    int lastoperatortype = 1;
    String lastoperatedate = "";
    String lastoperatetime = "";
    int deleted = 0;
    float nodepasstime = -1;
    float nodelefttime = -1;
    String docids = "";
    String crmids = "";
    String hrmids = "";
    String prjids = "";
    String cptids = "";
    String requestlevel = "0";
    int isremark = 0;
    String iscreate = "1";
    String remark = "";
    String src = "submit";
    String Procpara = "";
    int operatorgroup = 0;
    String createdate = "";
    String createtime = "";
    String currentdate = "";
    String currenttime = "";
    
    //获得新的请求id
    RequestIdUpdate requestIdUpdate = new RequestIdUpdate();
    //int requestid = requestIdUpdate.getRequestNewId();
	int rvalue[] = requestIdUpdate.getRequestNewId();
	int requestid = rvalue[0];
    if (requestid > 0) {
    	RecordSet rs0 = new RecordSet();
        rs0.executeProc("workflow_Workflowbase_SByID", workflowid + "");
        if (rs0.next()) {
            formid = rs0.getInt("formid");
            workflowtype = rs0.getString("workflowtype");
            messageType = rs0.getString("messageType");
        }
        rs.executeProc("workflow_CreateNode_Select", workflowid + "");
        if (rs.next())
            nodeid = rs.getInt(1);

        RecordSet rs1 = new RecordSet();
        flagbool = rs1.executeSql("insert into workflow_form (requestid,billformid,billid) values(" + requestid + "," + formid + "," + billid + ")");
        Calendar today = Calendar.getInstance();
        currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
        currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                Util.add0(today.get(Calendar.SECOND), 2);
        createdate = currentdate;
        createtime = currenttime;

        if (flagbool) {
            Procpara = "" + requestid + flag + workflowid + flag + lastnodeid + flag + lastnodetype + flag
                    + nodeid + flag + nodetype + flag + status + flag + passedgroups + flag + totalgroups
                    + flag + requestname + flag + creater + flag + createdate + flag + createtime + flag
                    + lastoperator + flag + lastoperatedate + flag + lastoperatetime + flag + deleted + flag
                    + creatertype + flag + lastoperatortype + flag + nodepasstime + flag + nodelefttime + flag
                    + docids + flag + crmids + flag + hrmids + flag + prjids + flag + cptids + flag + messageType;
            
            flagbool = rs.executeProc("workflow_Requestbase_Insert", Procpara);
            if (!flagbool) return -1;
            flagbool = rs.executeProc("workflow_Rbase_UpdateLevel", "" + requestid + flag + requestlevel);
            if (!flagbool) {
                DeleteByid(requestid);
                return -1;
            }
            Procpara = "" + requestid + flag + creater + flag + operatorgroup + flag + workflowid + flag
                    + workflowtype + flag + creatertype + flag + isremark + flag + nodeid
                    + flag + -1 + flag + "0" + flag + -1+ flag + 0;
            flagbool = rs.executeProc("workflow_CurrentOperator_I", Procpara);
            if (!flagbool) {
                DeleteByid(requestid);
                return -1;
            }
        }
        // 开始节点自动赋值操作
        try {
            RequestCheckAddinRules requestCheckAddinRules = new RequestCheckAddinRules();
            requestCheckAddinRules.resetParameter();
            requestCheckAddinRules.setRequestid(requestid);
            requestCheckAddinRules.setObjid(nodeid);
            requestCheckAddinRules.setObjtype(1);               // 1: 节点自动赋值 0 :出口自动赋值
            requestCheckAddinRules.setIsbill(isbill);
            requestCheckAddinRules.setFormid(formid);
            requestCheckAddinRules.checkAddinRules();
            //获得下一个节点
            RequestManager rm = new RequestManager();
            rm.setSrc(src);
            rm.setIscreate(iscreate);
            rm.setRequestid(requestid);
            rm.setWorkflowid(workflowid);
            rm.setWorkflowtype(workflowtype);
            rm.setIsremark(isremark);
            rm.setFormid(formid);
            rm.setIsbill(isbill);
            rm.setBillid(billid);
            rm.setNodeid(nodeid);
            rm.setNodetype(nodetype);
            rm.setRequestname(requestname);
            rm.setRequestlevel(requestlevel);
            rm.setRemark(remark);
            rm.setMessageType(messageType);
            
            rm.setUser(user);
            
            rm.setDocids(docids);
            rm.setCrmids(crmids);
            rm.setHrmids(hrmids);
            rm.setPrjids(prjids);
            rm.setCptids(cptids);
            flagbool = rm.flowNextNode();
            if (!flagbool) {
                DeleteByid(requestid);
                return -1;
            }
            updateBudgetBill(billid, requestid);
            if (rm.getNextNodetype().equals("3")) {
            	rs0 = new RecordSet();
            	String sql="insert into CRM_CustomerContacter(fullname,title,jobtitle,email,phoneoffice,fax,customerid,remark) (select name,title,responsibility,email,tel,fax,customer,remark from bill_FnaBudget where id="+ billid + ")" ;
            	rs0.executeSql(sql);
            }
        } catch (Exception erca) {
            erca.printStackTrace();
            DeleteByid(requestid);
            return -1;
        }
    }

    return requestid;
}

private boolean DeleteByid(int requestid) {
    boolean flagbool = false;
    RecordSet rs = new RecordSet();
    String sql = "delete from workflow_currentoperator where requestid =" + requestid;
    rs.executeSql(sql);
    sql = "delete from workflow_form where requestid=" + requestid;
    rs.executeSql(sql);
    sql = "delete from workflow_requestLog where requestid=" + requestid;
    rs.executeSql(sql);
    sql = "delete from workflow_requestViewLog where id=" + requestid;
    rs.executeSql(sql);
    sql = "delete from workflow_requestbase where requestid=" + requestid;
    rs.executeSql(sql);
    flagbool = true;
    return flagbool;
}

private void updateBudgetBill(int billid, int requestid) {
    RecordSet rs = new RecordSet();
    String sql = "update bill_Contacter set requestid=" + requestid + " where id=" + billid;
    rs.executeSql(sql);
}

private User getUserfromDB(int id) {
    RecordSet rs = new RecordSet() ;
    User user = new User() ;
    rs.executeSql("select * from hrmresource where id = " + id);
    if(rs.next()) {
  	  user.setUid(rs.getInt("id"));
      user.setLoginid(rs.getString("loginid"));
      user.setFirstname(rs.getString("firstname"));
      user.setLastname(rs.getString("lastname"));
      user.setAliasname(rs.getString("aliasname"));
      user.setTitle(rs.getString("title"));
      user.setTitlelocation(rs.getString("titlelocation"));
      user.setSex(rs.getString("sex"));
      user.setLanguage(Util.getIntValue(rs.getString("systemlanguage"),0));
      user.setTelephone(rs.getString("telephone"));
      user.setMobile(rs.getString("mobile"));
      user.setMobilecall(rs.getString("mobilecall"));
      user.setEmail(rs.getString("email"));
      user.setCountryid(rs.getString("countryid"));
      user.setLocationid(rs.getString("locationid"));
      user.setResourcetype(rs.getString("resourcetype"));
      user.setStartdate(rs.getString("startdate"));
      user.setEnddate(rs.getString("enddate"));
      user.setContractdate(rs.getString("contractdate"));
      user.setJobtitle(rs.getString("jobtitle"));
      user.setJobgroup(rs.getString("jobgroup"));
      user.setJobactivity(rs.getString("jobactivity"));
      user.setJoblevel(rs.getString("joblevel"));
      user.setSeclevel(rs.getString("seclevel"));
      user.setUserDepartment(Util.getIntValue(rs.getString("departmentid"),0));
      user.setUserSubCompany1(Util.getIntValue(rs.getString("subcompanyid1"),0));
      user.setUserSubCompany2(Util.getIntValue(rs.getString("subcompanyid2"),0));
      user.setUserSubCompany3(Util.getIntValue(rs.getString("subcompanyid3"),0));
      user.setUserSubCompany4(Util.getIntValue(rs.getString("subcompanyid4"),0));
      user.setManagerid(rs.getString("managerid"));
      user.setAssistantid(rs.getString("assistantid"));
      user.setPurchaselimit(rs.getString("purchaselimit"));
      user.setCurrencyid(rs.getString("currencyid"));
      user.setLastlogindate(rs.getString("lastlogindate"));
	  user.setLogintype("1");
	}
	return user ;
}
%>


<%
String title = Util.null2String(request.getParameter("title"));
String name = Util.null2String(request.getParameter("name"));
String customer = Util.null2String(request.getParameter("customer"));
String email = Util.null2String(request.getParameter("email"));
String tel = Util.null2String(request.getParameter("tel"));
String mobile = Util.null2String(request.getParameter("mobile"));
String fax = Util.null2String(request.getParameter("fax"));
String responsibility = Util.null2String(request.getParameter("responsibility"));
String remark = Util.null2String(request.getParameter("remark"));
String method = Util.null2String(request.getParameter("method"));

if(method.equals("application"))
{
	int workflowid = getWorkFlowID(customer);
	int billid = getBillID(title,name,customer,email,tel,mobile,fax,responsibility,remark);
	int manager = getCustomerManager(customer);
	if(workflowid==0||billid==0||manager==0||NewFlow(workflowid,billid,manager)<0){
		response.sendRedirect("ContacterApplication.jsp?msg=20884");
		return;
	}
	response.sendRedirect("ContacterApplication.jsp?msg=20894");
	return;
}
%>