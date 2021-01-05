<%@page import="weaver.fna.general.FnaCommon"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.fna.budget.WipeInfo"%>
<%@ page import="weaver.fna.budget.BudgetHandler"%>
<%@ page import="weaver.file.*" %>
<%@ page import="java.util.ArrayList" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetStart" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetBED"class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetBHF"class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page"/>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page"/>
<jsp:useBean id="FnaBudgetControlByBill" class="weaver.fna.maintenance.FnaBudgetControlByBill" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<%
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user= HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码

String src = Util.null2String(fu.getParameter("src"));
String iscreate = Util.null2String(fu.getParameter("iscreate"));
int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
int formid = Util.getIntValue(fu.getParameter("formid"),-1);
int isbill = 1;
int billid = Util.getIntValue(fu.getParameter("billid"),-1);
int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
String nodetype = Util.null2String(fu.getParameter("nodetype"));
String requestname = Util.fromScreen(fu.getParameter("requestname"),user.getLanguage());
String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
String remark = Util.null2String(fu.getParameter("remark"));
String topage=URLDecoder.decode(Util.null2String(fu.getParameter("topage")));  //返回的页面
int isovertime = Util.getIntValue(fu.getParameter("isovertime"),0);

if(requestid != -1){
	String sqlwhere = FnaCommon.getCanQueryRequestSqlCondition(user, "a", "a");
	String _sql = "select 1 from workflow_requestbase a where 1=1 "+sqlwhere+" and a.requestid = "+requestid;
	RecordSetStart.executeSql(_sql);
	if(RecordSetStart.getCounts()<1){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
}

if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
    //response.sendRedirect("/notice/RequestError.jsp");
    out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
    return ;
}


RequestManager.setSrc(src) ;
RequestManager.setIscreate(iscreate) ;
RequestManager.setRequestid(requestid) ;
RequestManager.setWorkflowid(workflowid) ;
RequestManager.setWorkflowtype(workflowtype) ;
RequestManager.setIsremark(isremark) ;
RequestManager.setFormid(formid) ;
RequestManager.setIsbill(1) ;
RequestManager.setBillid(billid) ;
RequestManager.setNodeid(nodeid) ;
RequestManager.setNodetype(nodetype) ;
RequestManager.setRequestname(requestname) ;
RequestManager.setRequestlevel(requestlevel) ;
RequestManager.setRemark(remark) ;
RequestManager.setRequest(fu) ;
RequestManager.setUser(user) ;
//add by chengfeng.han 2011-7-28 td20647 
int isagentCreater = Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()));
int beagenter = Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+user.getUID()),0);
RequestManager.setIsagentCreater(isagentCreater);
RequestManager.setBeAgenter(beagenter);
//end

//add by xhheng @ 2005/01/24 for 消息提醒 Request06
RequestManager.setMessageType(messageType) ;

boolean savestatus = RequestManager.saveRequestInfo() ;
requestid = RequestManager.getRequestid() ;
if( !savestatus ) {
    if( requestid != 0 ) {
        String message=RequestManager.getMessage();
        if(!"".equals(message)){
			out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message="+message+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");
            return ;
        }
        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
        out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");
        return ;
    }
    else {
        //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
        out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");
        return ;
    }
}
    String ismode = "";
    int showdes = 0;
    int modeid = 0;
    RecordSet.executeSql("select ismode,showdes,printdes from workflow_flownode where workflowid=" + workflowid + " and nodeid=" + nodeid);
    if (RecordSet.next()) {
        ismode = Util.null2String(RecordSet.getString("ismode"));
        showdes = Util.getIntValue(Util.null2String(RecordSet.getString("showdes")), 0);
    }
    if (ismode.equals("1") && showdes != 1) {
        RecordSet.executeSql("select id from workflow_nodemode where isprint='0' and workflowid=" + workflowid + " and nodeid=" + nodeid);
        if (RecordSet.next()) {
            modeid = RecordSet.getInt("id");
        } else {
            RecordSet.executeSql("select id from workflow_formmode where isprint='0' and formid=" + formid + " and isbill='" + isbill + "'");
            if (RecordSet.next()) {
                modeid = RecordSet.getInt("id");
            }
        }
    }

String remindmessage = "";//返回的提醒信息
String poststr = "";
    
if( src.equals("save") || src.equals("submit") ) {      // 修改细表和主表信息
    double amountsum = 0 ;
    double applyamountsum = 0 ;
    ArrayList detaileditfields=FieldInfo.getSaveDetailFields(formid,isbill,workflowid,nodeid,new ArrayList());
    WFNodeDtlFieldManager.setNodeid(nodeid);
    WFNodeDtlFieldManager.setGroupid(0);
    WFNodeDtlFieldManager.selectWfNodeDtlField();
    String dtldelete = WFNodeDtlFieldManager.getIsdelete();
    if(detaileditfields.size()>0||dtldelete.equals("1")||iscreate.equals("1")){
    if(modeid<1){
    if( !iscreate.equals("1") ) RecordSet.executeSql("delete from Bill_FnaWipeApplyDetail where id="+billid);
    else {
        requestid = RequestManager.getRequestid() ;
        billid = RequestManager.getBillid() ;
    }
    if(src.equals("submit")){

       String deletesql="delete from FnaExpenseInfo where requestid="+requestid;
       RecordSet.executeSql( deletesql ) ;
    }
    String crmids = "";
    String prjids = "";
    Hashtable fieldnameType_hs = new Hashtable();
    ArrayList fieldnameList = new ArrayList();
    RecordSet.execute("select fieldname, type from workflow_billfield where billid=158 and fieldhtmltype=3 and type in (7,18,8,135) and (viewtype is null or viewtype<>1)");
    while(RecordSet.next()){
    	String fieldname_tmp = Util.null2String(RecordSet.getString(1));
    	if("".equals(fieldname_tmp)){
    		continue;
    	}
    	String type_tmp = Util.null2String(RecordSet.getString(2));
    	fieldnameType_hs.put(fieldname_tmp, type_tmp);
    	fieldnameList.add(fieldname_tmp);
    }
    if(fieldnameList.size() <= 0){
    	RecordSet.execute("select * from Bill_FnaWipeApply where requestid="+requestid);
    	if(RecordSet.next()){
    		for(int i=0; i<fieldnameList.size(); i++){
    			String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));
    			String type_tmp = Util.null2String((String)fieldnameType_hs.get(fieldname_tmp));
    			String value_tmp = Util.null2String(RecordSet.getString(fieldname_tmp));
    			if(!"".equals(value_tmp)){
    				if("7".equals(type_tmp) || "18".equals(type_tmp)){		//客户字段
    					if(!"".equals(crmids)){
	    					crmids += (","+value_tmp);
    					}else{
    						crmids = value_tmp;
    					}
    				}else if("8".equals(type_tmp) || "135".equals(type_tmp)){		//项目字段
    					if(!"".equals(crmids)){
    						prjids += (","+value_tmp);
    					}else{
    						prjids = value_tmp;
    					}
    				}
    			}
    		}
    	}
    }
    int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("indexnum")));
    for(int i=0;i<rowsum;i++) {
        int organizationtype = Util.getIntValue(fu.getParameter("organizationtype_"+i),3);
		int organizationid = Util.getIntValue(fu.getParameter("organizationid_"+i),0);
        int relatedprj = Util.getIntValue(fu.getParameter("relatedprj_"+i),0);
        int relatedcrm = Util.getIntValue(fu.getParameter("relatedcrm_"+i),0);
        double amount= Util.getDoubleValue(fu.getParameter("amount_"+i),0);
        double applyamount= Util.getDoubleValue(fu.getParameter("applyamount_"+i),0);
        int attachcount= Util.getIntValue(fu.getParameter("attachcount_"+i),0);
        String subject = Util.null2String(fu.getParameter("subject_"+i));
        String budgetperiod = Util.null2String(fu.getParameter("budgetperiod_"+i));
        String description = Util.toHtml(fu.getParameter("description_"+i));
        //if(applyamount == 0 ) continue ;
        if(organizationid==0&&relatedprj==0&&relatedcrm==0&&amount==0&&applyamount==0&&subject.equals("")&&description.equals("")&&attachcount==0) {
             continue;
        }
        if(relatedcrm > 0){
        	if(!"".equals(crmids)){
				crmids += (","+relatedcrm);
			}else{
				crmids = ""+relatedcrm;
			}
        }
        if(relatedprj > 0){
        	if(!"".equals(prjids)){
        		prjids += (","+relatedprj);
			}else{
				prjids = ""+relatedprj;
			}
        }
        if(subject.equals(""))
        subject="0";
        applyamountsum+=applyamount;
        amountsum += amount ;
        String sql="insert into Bill_FnaWipeApplyDetail (id,organizationtype,organizationid,amount,subject,description,budgetperiod,relatedprj,relatedcrm,applyamount,attachcount,dsporder) values("+billid+","+ organizationtype +","+ organizationid+","
                     + amount+","+ subject +",'"+description+"','"+budgetperiod+"',"+relatedprj+","+relatedcrm+","+applyamount+","+attachcount+","+i+")";
        //System.out.println("sql:"+sql);
        RecordSet.executeSql(sql);
        
        
        double finalamount = 0;
        if(amount>0){
        	finalamount = amount;
        }else{
        	finalamount = applyamount;
        }
        boolean iscanfancontrol = FnaBudgetControlByBill.isFnaControl(workflowid,nodeid,organizationid, organizationtype);
		if(iscanfancontrol){
			poststr += "|"+subject+","+ organizationid+","+ budgetperiod+","+finalamount;
		}
        
        
        
        if (src.equals("submit")&&organizationid>0) {
                if(amount==0)
                    amount=applyamount;
                String insertsql = "insert into FnaExpenseInfo (organizationtype,organizationid,occurdate,amount,subject,status,type,requestid,relatedprj,relatedcrm,description) values (" + organizationtype + "," + organizationid  + ",'" + budgetperiod + "',"
                        + amount + "," + subject + ",0,2," + requestid +","+relatedprj+","+relatedcrm+",'"+description+ "')";
                //System.out.println(insertsql);
                RecordSet.executeSql(insertsql);


        }
	}
    String updatesql = "total=" + amountsum ;
    if(amountsum==0){
    	updatesql = "total = (select sum(applyamount) from Bill_FnaWipeApplyDetail where id = Bill_FnaWipeApply.id)";
    }else{
    	updatesql = "total = (select sum(amount) from Bill_FnaWipeApplyDetail where id = Bill_FnaWipeApply.id)";
    }    
    updatesql = " update Bill_FnaWipeApply set " + updatesql + " where id = " + billid ;
    RecordSet.executeSql( updatesql ) ;
    RequestManager.setCrmids(crmids);
    RequestManager.setPrjids(prjids);
    }else{
        requestid = RequestManager.getRequestid();
        billid = RequestManager.getBillid();
        if (src.equals("submit")) {
            String deletesql = "delete from FnaExpenseInfo where requestid=" + requestid;
            RecordSet.executeSql(deletesql);
        }
        RecordSet.executeSql("select * from Bill_FnaWipeApplyDetail where id=" + billid);
        while (RecordSet.next()) {
            int organizationtype = Util.getIntValue(RecordSet.getString("organizationtype"),3);
            int organizationid = Util.getIntValue(RecordSet.getString("organizationid"),0);
            String budgetperiod = Util.null2String(RecordSet.getString("budgetperiod"));
            double amount = Util.getDoubleValue(RecordSet.getString("amount"), 0);
            double applyamount = Util.getDoubleValue(RecordSet.getString("applyamount"), 0);
            String subject = Util.null2String(RecordSet.getString("subject"));
            int relatedprj = Util.getIntValue(RecordSet.getString("relatedprj"), 0);
            int relatedcrm = Util.getIntValue(RecordSet.getString("relatedcrm"), 0);
            String description = Util.toHtml(RecordSet.getString("description"));
            applyamountsum += applyamount;
            amountsum += amount;
            if (src.equals("submit")&&organizationid>0) {
                if (amount == 0) amount = applyamount;
                String insertsql = "insert into FnaExpenseInfo (organizationtype,organizationid,occurdate,amount,subject,status,type,requestid,relatedprj,relatedcrm,description) values (" + organizationtype + "," + organizationid + ",'" + budgetperiod + "',"
                        + amount + "," + subject + ",0,2," + requestid + "," + relatedprj + "," + relatedcrm + ",'" + description + "')";
                //System.out.println(insertsql);
                RecordSet1.executeSql(insertsql);
            }
            
            double finalamount = 0;
        	if(amount>0){
        		finalamount = amount;
        	}else{
        		finalamount = applyamount;
        	}
        	boolean iscanfancontrol = FnaBudgetControlByBill.isFnaControl(workflowid,nodeid,organizationid, organizationtype);
			if(iscanfancontrol){
				poststr += "|"+subject+","+ organizationid+","+ budgetperiod+","+finalamount;
			}
        	
        }
        String updatesql = "total=" + amountsum;
        if(amountsum==0){
        	updatesql = "total = (select sum(applyamount) from Bill_FnaWipeApplyDetail where id = Bill_FnaWipeApply.id)";
        }else{
        	updatesql = "total = (select sum(amount) from Bill_FnaWipeApplyDetail where id = Bill_FnaWipeApply.id)";
        }        
        updatesql = " update Bill_FnaWipeApply set " + updatesql + " where id = " + billid;
        RecordSet.executeSql(updatesql);
    }
    }else{
    	int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("indexnum")));
	    for(int i=0;i<rowsum;i++) {
	        int organizationtype = Util.getIntValue(fu.getParameter("organizationtype_"+i),3);
			int organizationid = Util.getIntValue(fu.getParameter("organizationid_"+i),0);
	        int relatedprj = Util.getIntValue(fu.getParameter("relatedprj_"+i),0);
	        int relatedcrm = Util.getIntValue(fu.getParameter("relatedcrm_"+i),0);
	        double amount= Util.getDoubleValue(fu.getParameter("amount_"+i),0);
	        double applyamount= Util.getDoubleValue(fu.getParameter("applyamount_"+i),0);
	        int attachcount= Util.getIntValue(fu.getParameter("attachcount_"+i),0);
	        String subject = Util.null2String(fu.getParameter("subject_"+i));
	        String budgetperiod = Util.null2String(fu.getParameter("budgetperiod_"+i));
	        String description = Util.toHtml(fu.getParameter("description_"+i));
	        if(organizationid==0&&relatedprj==0&&relatedcrm==0&&amount==0&&applyamount==0&&subject.equals("")&&description.equals("")&&attachcount==0) {
             	//continue ;
        	}
	       
	        double finalamount = 0;
	        if(amount>0){
	        	finalamount = amount;
	        }else{
	        	finalamount = applyamount;
	        }
	        boolean iscanfancontrol = FnaBudgetControlByBill.isFnaControl(workflowid,nodeid,organizationid, organizationtype);
			if(iscanfancontrol){
				poststr += "|"+subject+","+ organizationid+","+ budgetperiod+","+finalamount;
			}
		}
    }
    
    //预算控制
    if(poststr!=""){
  		poststr =poststr.substring(1);
		//返回的值
		String returnStr = FnaBudgetControlByBill.checkBudgetList(poststr,requestid,true, user.getLanguage());
		if(returnStr!=null && !returnStr.equals("")){
			remindmessage = returnStr;
		}
  	}
  	
}

if(!remindmessage.equals("")){
	String delesql="delete from FnaExpenseInfo where requestid="+requestid;
    RecordSet.executeSql( delesql ) ;
	session.setAttribute(requestid+"_"+1021,remindmessage);
	out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message=1021&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");
	return ;	
}


if (src.equals("reject")||src.equals("delete")) {
	if(src.equals("reject")){
		if(RequestManager.getNextNodetype().equals("0")){//退回到创建节点才删除费用
		    String deletesql="delete from FnaExpenseInfo where requestid="+requestid;
		    RecordSet.executeSql( deletesql ) ;
		}
	}else{
	    String deletesql="delete from FnaExpenseInfo where requestid="+requestid;
	    RecordSet.executeSql( deletesql ) ;
	}
}
boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");
	return ;
}

boolean logstatus = RequestManager.saveRequestLog() ;

if (RequestManager.getNextNodetype().equals("3")) {
        String sql="select wipetype,debitremark from Bill_FnaWipeApply where id="+billid;
        RecordSet.executeSql(sql);
        RecordSet.next();
        String debitremark=RecordSet.getString("debitremark");
        String wipetype=RecordSet.getString("wipetype");
        sql = "update FnaExpenseInfo set status=1,debitremark='"+debitremark+"' where requestid=" + requestid;
        RecordSet.executeSql(sql);
    if (wipetype.equals("4")) { //冲销方式, type=4
        if(modeid<1){
        int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("indexnum")));
        for (int i = 0; i < rowsum; i++) {
            int organizationtype = Util.getIntValue(fu.getParameter("organizationtype_"+i),3);
		int organizationid = Util.getIntValue(fu.getParameter("organizationid_"+i),0);
        int relatedprj = Util.getIntValue(fu.getParameter("relatedprj_"+i),0);
        int relatedcrm = Util.getIntValue(fu.getParameter("relatedcrm_"+i),0);
        double amount= Util.getDoubleValue(fu.getParameter("amount_"+i),-1);
        double applyamount= Util.getDoubleValue(fu.getParameter("applyamount_"+i),0);
        //int attachcount= Util.getIntValue(fu.getParameter("attachcount_"+i),0);
        String subject = Util.null2String(fu.getParameter("subject_"+i));
        String budgetperiod = Util.null2String(fu.getParameter("budgetperiod_"+i));
        String description = Util.toHtml(fu.getParameter("description_"+i));
        //if(applyamount == 0 ) continue ;
        if(organizationid<=0) {
             response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
             return ;
        }
        if(subject.equals(""))
        subject="0";
        if(amount==-1)
        amount=applyamount;


            ArrayList wipelist = new ArrayList(); //保存冲销数据
            WipeInfo wi = new WipeInfo();
            wi.setDate(budgetperiod);
            wi.setOrganizationtype(organizationtype);
            wi.setOrganizationid(organizationid);
            wi.setSubject(Integer.parseInt(subject));
            wi.setAmount(amount);
            wi.setRequestid(requestid);
            wi.setDescription(description);
            wi.setRelatedprj(relatedprj);
            wi.setRelatedcrm(relatedcrm);
            wipelist.add(wi);
            if (wipelist.size() > 0) //冲销处理
                BudgetHandler.writeOffProcess(wipelist,debitremark);
        }
        }else{
            RecordSet.executeSql("select * from Bill_FnaWipeApplyDetail where id=" + billid);
            while (RecordSet.next()) {
                int organizationtype = Util.getIntValue(RecordSet.getString("organizationtype"),3);
                int organizationid = Util.getIntValue(RecordSet.getString("organizationid"),0);
                String budgetperiod = Util.null2String(RecordSet.getString("budgetperiod"));
                double amount = Util.getDoubleValue(RecordSet.getString("amount"), -1);
                double applyamount = Util.getDoubleValue(RecordSet.getString("applyamount"), 0);
                String subject = Util.null2String(RecordSet.getString("subject"));
                int relatedprj = Util.getIntValue(RecordSet.getString("relatedprj"), 0);
                int relatedcrm = Util.getIntValue(RecordSet.getString("relatedcrm"), 0);
                String description = Util.toHtml(RecordSet.getString("description"));
                //if (applyamount == 0) continue;
                if (organizationid<=0) {
                    response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid=" + requestid + "&message=1");
                    return;
                }
                if (subject.equals(""))
                    subject = "0";
                if (amount == -1)
                    amount = applyamount;


                ArrayList wipelist = new ArrayList(); //保存冲销数据
                WipeInfo wi = new WipeInfo();
                wi.setDate(budgetperiod);
                wi.setOrganizationtype(organizationtype);
                wi.setOrganizationid(organizationid);
                wi.setSubject(Integer.parseInt(subject));
                wi.setAmount(amount);
                wi.setRequestid(requestid);
                wi.setDescription(description);
                wi.setRelatedprj(relatedprj);
                wi.setRelatedcrm(relatedcrm);
                wipelist.add(wi);
                if (wipelist.size() > 0) //冲销处理
                    BudgetHandler.writeOffProcess(wipelist, debitremark);
            }
        }
    }
}
//response.sendRedirect("/workflow/request/RequestView.jsp");

if( src.equals("save") || src.equals("submit") ) {      // 修改细表和主表信息
//这些操作的执行flowNextNode操作后执行
    String crmids="";
	String prjids="";

    String tempcrmids=null;
	String tempprjids=null;
	RecordSet.executeSql("select crmids,prjids from workflow_requestbase where requestid="+requestid) ;
	if(RecordSet.next()){
		tempcrmids=Util.null2String(RecordSet.getString("crmids"));
		tempprjids=Util.null2String(RecordSet.getString("prjids"));
		if(tempcrmids.equals("")){
			crmids="";
		}else{
			crmids=","+tempcrmids;
		}
		if(tempprjids.equals("")){
			prjids="";
		}else{
			prjids=","+tempprjids;
		}
	}
    if(modeid<1){
    int rowsum = Util.getIntValue(Util.null2String(fu.getParameter("indexnum")));
    for(int i=0;i<rowsum;i++) {
        int relatedprj = Util.getIntValue(fu.getParameter("relatedprj_"+i),0);
        int relatedcrm = Util.getIntValue(fu.getParameter("relatedcrm_"+i),0);
        if(relatedcrm>0&&(","+crmids+",").indexOf(","+relatedcrm+",")==-1){
			crmids+=","+relatedcrm;
		}
        if(relatedprj>0&&(","+prjids+",").indexOf(","+relatedprj+",")==-1){
			prjids+=","+relatedprj;
		}
	}
    }else{
        RecordSet.executeSql("select relatedprj,relatedcrm from Bill_FnaWipeApplyDetail where id="+billid) ;
	    while(RecordSet.next()){
            int relatedprj = Util.getIntValue(RecordSet.getString("relatedprj"), 0);
            int relatedcrm = Util.getIntValue(RecordSet.getString("relatedcrm"), 0);
            if (relatedcrm > 0 && ("," + crmids + ",").indexOf("," + relatedcrm + ",") == -1) {
                crmids += "," + relatedcrm;
            }
            if (relatedprj > 0 && ("," + prjids + ",").indexOf("," + relatedprj + ",") == -1) {
                prjids += "," + relatedprj;
            }
        }
    }
    if (!crmids.equals("")){
		crmids = crmids.substring(1);
	}
    if (!prjids.equals("")){
		prjids = prjids.substring(1);
	}
    RecordSet.executeSql( "update workflow_requestbase set crmids='"+crmids+"',prjids='"+prjids+"' where requestid="+requestid ) ;
}

WFManager.setWfid(workflowid);
WFManager.getWfInfo();
String isShowChart = Util.null2String(WFManager.getIsShowChart());
if(!topage.equals("")){
	if(topage.indexOf("RequestOperation.jsp") > 0 || topage.indexOf("/proj/process/ViewTask.jsp") == 0 || topage.indexOf("/proj/plan/ViewTask.jsp") == 0){
		session.setAttribute("topage_ForAllBill","");
	}
	if(topage.indexOf("?")!=-1){
		//response.sendRedirect(topage+"&requestid="+requestid);
		out.print("<script>wfforward('"+topage+"&requestid="+requestid+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");
		return;
	}else{
		//response.sendRedirect(topage+"?requestid="+requestid);
		out.print("<script>wfforward('"+topage+"?requestid="+requestid+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");
		return;

	}
}else{
	
 
	if(iscreate.equals("1")){
        if ("1".equals(isShowChart)) {
            //response.sendRedirect("/workflow/request/WorkflowDirection.jsp?requestid=" + requestid + "&workflowid=" + workflowid + "&isbill=" + isbill + "&formid=" + formid);
   		 	out.print("<script>wfforward('/workflow/request/WorkflowDirection.jsp?requestid=" + requestid + "&workflowid=" + workflowid + "&isbill=" + isbill + "&formid=" + formid+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");
		} else {
			%><%@ include file="/workflow/request/RedirectPage.jsp" %> 
			<%
	    
        }
	}else{
		if("delete".equals(src) && savestatus && flowstatus){
%>
            <SCRIPT LANGUAGE="JavaScript">
            alert("<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15242,user.getLanguage())%>");
            window.parent.close();
            </SCRIPT>
<%
		}else{
				String isShowPrompt="true";
				//response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1&isShowPrompt="+isShowPrompt+"&src="+src+"&isovertime="+isovertime);
				out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&fromoperation=1&updatePoppupFlag=1&isShowPrompt="+isShowPrompt+"&src="+src+"&isovertime="+isovertime+"&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");

		}
	}
}
%>

