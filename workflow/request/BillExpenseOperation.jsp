<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page import="weaver.general.Util"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="java.util.ArrayList" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetStart" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetBED"class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetBHF"class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetBED1"class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page"/>
<jsp:useBean id="WFNodeDtlFieldManager" class="weaver.workflow.workflow.WFNodeDtlFieldManager" scope="page"/>
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
String crmids = "" ;
String projectids = "" ;

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
RequestManager.setIsbill(isbill) ;
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

DecimalFormat df=new DecimalFormat("0.000");

if( src.equals("save") || src.equals("submit") ) {      // 修改细表和主表信息

	String expenseapplytype = "" ;              // 报销类型
	int resourceid = 0;
	String occurdate = "";
	RecordSetBED1.executeSql(" select a.resourceid, a.debitledgeid , a.realamount , a.occurdate, a.departmentid from bill_HrmFinance a where a.requestid = " + requestid );
	if(RecordSetBED1.next()){
		resourceid = RecordSetBED1.getInt("resourceid");
		occurdate = Util.null2String(RecordSetBED1.getString("occurdate")).trim();
        expenseapplytype = Util.null2String( RecordSetBED1.getString("debitledgeid") ).trim() ;
	}
    char flag=Util.getSeparator() ;
    double feesumcount = 0 ;
    double realfeesumcount = 0 ;
    int accessorycount = 0 ;
    String ismode="";
    int showdes=0;
    int modeid=0;
    RecordSet.executeSql("select ismode,showdes,printdes from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
    if(RecordSet.next()){
        ismode=Util.null2String(RecordSet.getString("ismode"));
        showdes=Util.getIntValue(Util.null2String(RecordSet.getString("showdes")),0);
    }
    if(ismode.equals("1") && showdes!=1){
        RecordSet.executeSql("select id from workflow_nodemode where isprint='0' and workflowid="+workflowid+" and nodeid="+nodeid);
        if(RecordSet.next()){
            modeid=RecordSet.getInt("id");
        }else{
            RecordSet.executeSql("select id from workflow_formmode where isprint='0' and formid="+formid+" and isbill='"+isbill+"'");
            if(RecordSet.next()){
                modeid=RecordSet.getInt("id");
            }
        }
    }

    ArrayList detaileditfields=FieldInfo.getSaveDetailFields(formid,isbill,workflowid,nodeid,new ArrayList());
    WFNodeDtlFieldManager.setNodeid(nodeid);
    WFNodeDtlFieldManager.setGroupid(0);
    WFNodeDtlFieldManager.selectWfNodeDtlField();
    String dtldelete = WFNodeDtlFieldManager.getIsdelete();
    if(detaileditfields.size()>0||dtldelete.equals("1")||iscreate.equals("1")){
    if(modeid<1){//普通模式
        if( !iscreate.equals("1") ) RecordSet.executeProc("Bill_ExpenseDetail_Delete",""+billid);
        else {
            requestid = RequestManager.getRequestid() ;
            billid = RequestManager.getBillid() ;
            RecordSet.executeProc("Bill_ExpenseDetail_Delete",""+billid);
        }
        if(src.equals("submit")){
            //删除提交失败产生的垃圾数据
            String deletesql="delete from FnaExpenseInfo where requestid="+requestid;
            RecordSet.executeSql( deletesql ) ;
         }

        int rowsum = -1;
		if("2".equals(ismode)){//html模式 QC29615
			rowsum = Util.getIntValue(Util.null2String(fu.getParameter("indexnum0")));
		}else{
			rowsum = Util.getIntValue(Util.null2String(fu.getParameter("indexnum")));
		}

        for(int i=0;i<rowsum;i++) {
            String relatedate = "";
            String feetypeid = "";
            String detailremark = "";
            int accessory = 0;
            String relatedcrm = "";
            String relatedproject = "";
            double feesum= 0;
            double realfeesum = 0;
            String invoicenum = "";
            String relaterequest = ""; 
            
			if("2".equals(ismode)){
		        relatedate = Util.null2String(fu.getParameter("field428_"+i));
		        feetypeid = Util.null2String(fu.getParameter("field367_"+i));
		        detailremark = Util.toHtmltextarea(Util.htmlFilter4UTF8(fu.getParameter("field368_"+i)));
		        accessory = Util.getIntValue(fu.getParameter("field369_"+i),0);
		        relatedcrm = Util.null2String(fu.getParameter("field67_"+i));
		        relatedproject = Util.null2String(fu.getParameter("field68_"+i));
		        feesum= Util.getDoubleValue(fu.getParameter("field163_"+i),0);
		        realfeesum = Util.getDoubleValue(fu.getParameter("field370_"+i),0);
		        invoicenum = Util.null2String(fu.getParameter("field429_"+i));
		    	relaterequest = Util.null2String(fu.getParameter("field665_"+i));

	            if(Util.null2String(fu.getParameter("field370_"+i)).trim().equals("")){
	            	realfeesum = feesum;
	            }
			}else{
				relatedate = Util.null2String(fu.getParameter("relatedate_"+i));
		    	feetypeid = Util.null2String(fu.getParameter("feetypeid_"+i));
		    	detailremark = Util.toHtmltextarea(Util.htmlFilter4UTF8(fu.getParameter("detailremark_"+i)));
		    	accessory = Util.getIntValue(fu.getParameter("accessory_"+i),0);
		    	relatedcrm = Util.null2String(fu.getParameter("relatedcrm_"+i));
		    	relatedproject = Util.null2String(fu.getParameter("relatedproject_"+i));
		    	feesum= Util.getDoubleValue(fu.getParameter("feesum_"+i),0);
		    	realfeesum = Util.getDoubleValue(fu.getParameter("realfeesum_"+i),0);
		    	invoicenum = Util.null2String(fu.getParameter("invoicenum_"+i));
		    	relaterequest = Util.null2String(fu.getParameter("relaterequest_"+i));

	            if(Util.null2String(fu.getParameter("realfeesum_"+i)).trim().equals("")){
	            	realfeesum = feesum;
	            }
			}
			
			if(realfeesum==0){
				realfeesum = feesum;
			}

			if("".equals(relatedate)&&"".equals(feetypeid)&&"".equals(detailremark)&&accessory==0&&"".equals(relatedcrm)&&"".equals(relatedproject)&&feesum==0&&realfeesum==0
					&&"".equals(invoicenum)&&"".equals(relaterequest)){
				continue;
			}
			
            feesumcount += feesum ;
            realfeesumcount += realfeesum ;
            accessorycount += accessory ;

            if( !relatedcrm.equals("") ) crmids += "," + relatedcrm ;
            if( !relatedproject.equals("") ) projectids += "," + relatedproject ;

            String para = ""+billid + flag + relatedate + flag + feetypeid + flag + detailremark + flag +
                ""+accessory + flag + relatedcrm + flag + relatedproject + flag + df.format(feesum) + flag + df.format(realfeesum) + flag + invoicenum + flag + i+flag + relaterequest;//modify by xhheng @ 20050304 for TDID 1257

            RecordSet.executeProc("Bill_ExpenseDetail_Insert",para);

            if (src.equals("submit")&&resourceid>0) {
                 String insertsql = "insert into FnaExpenseInfo (organizationtype,organizationid,occurdate,amount,subject,status,type,requestid,relatedprj,relatedcrm,description) values (" + 3 + "," + resourceid + ",'" + occurdate + "',"
                         + df.format(realfeesum) + "," + feetypeid + ",0,1," + requestid +","+Util.getIntValue(relatedproject, 0)+","+Util.getIntValue(relatedcrm, 0)+ ",'"+StringEscapeUtils.escapeSql(detailremark)+"')";
                 //System.out.println(insertsql);
                 RecordSetBED1.executeSql(insertsql);
            }
        }
        if( !crmids.equals("") ) crmids = crmids.substring(1) ;
        if( !projectids.equals("") ) projectids = projectids.substring(1) ;

        String updatesql = "amount=" + df.format(feesumcount) ;
        updatesql += ",realamount=" + df.format(realfeesumcount) ;
        updatesql += ",accessory=" + accessorycount ;
        if( iscreate.equals("1") ) {
            updatesql += ",basictype='1',detailtype='1',status='0'" ;
            updatesql += ",name ='" + Util.fromScreen2(requestname,user.getLanguage())+"'";
            updatesql += ",billid =" + billid;
        }
        updatesql = " update Bill_HrmFinance set " + updatesql + " where id = " + billid ;
        RecordSet.executeSql( updatesql ) ;
    }else{
        requestid = RequestManager.getRequestid() ;
        billid = RequestManager.getBillid() ;

        if(src.equals("submit")){
            //删除提交失败产生的垃圾数据
            String deletesql = "delete from FnaExpenseInfo where requestid=" + requestid;
            RecordSet.executeSql(deletesql);
        }
        RecordSet.executeSql("select a.relatedate, a.feesum, a.realfeesum, a.feetypeid \n" +
        		" from Bill_ExpenseDetail a \n" +
        		" join bill_hrmfinance b on a.expenseid = b.id \n" +
        		" where b.requestid = "+requestid);
        while (RecordSet.next()) {
            String relatedate = Util.null2String(RecordSet.getString("relatedate")).trim();
            double feesum = Util.getDoubleValue(RecordSet.getString("feesum"), 0.00);
            double realfeesum = Util.getDoubleValue(RecordSet.getString("realfeesum"), 0.00);
            String feetypeid = Util.null2String(RecordSet.getString("feetypeid")).trim();
            String relatedproject = Util.null2String(RecordSet.getString("relatedproject")).trim();
            String relatedcrm = Util.null2String(RecordSet.getString("relatedcrm")).trim();
            String detailremark = Util.null2String(RecordSet.getString("detailremark")).trim();
            int accessory = Util.getIntValue(RecordSet.getString("accessory"), 0);
			
			if(realfeesum==0){
				realfeesum = feesum;
			}

            feesumcount += feesum ;
            realfeesumcount += realfeesum ;
            accessorycount += accessory ;

            if( !relatedcrm.equals("") ) crmids += "," + relatedcrm ;
            if( !relatedproject.equals("") ) projectids += "," + relatedproject ;

            if (src.equals("submit")&&resourceid>0) {
                 String insertsql = "insert into FnaExpenseInfo (organizationtype,organizationid,occurdate,amount,subject,status,type,requestid,relatedprj,relatedcrm,description) values (" + 3 + "," + resourceid + ",'" + relatedate + "',"
                         + df.format(realfeesum) + "," + feetypeid + ",0,1," + requestid +","+Util.getIntValue(relatedproject, 0)+","+Util.getIntValue(relatedcrm, 0)+ ",'"+StringEscapeUtils.escapeSql(detailremark)+"')";
                 //System.out.println(insertsql);
                 RecordSetBED1.executeSql(insertsql);
            }
        }
        if( !crmids.equals("") ) crmids = crmids.substring(1) ;
        if( !projectids.equals("") ) projectids = projectids.substring(1) ;

        String updatesql = "amount=" + df.format(feesumcount) ;
        updatesql += ",realamount=" + df.format(realfeesumcount) ;
        updatesql += ",accessory=" + accessorycount ;
        if( iscreate.equals("1") ) {
            updatesql += ",basictype='1',detailtype='1',status='0'" ;
            updatesql += ",name ='" + Util.fromScreen2(requestname,user.getLanguage())+"'";
            updatesql += ",billid =" + billid;
        }
        updatesql = " update Bill_HrmFinance set " + updatesql + " where id = " + billid ;
        RecordSet.executeSql( updatesql ) ;
    }
    }
}

boolean flowstatus = RequestManager.flowNextNode() ;
if( !flowstatus ) {
	//response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
	out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"');</script>");
	return ;
}

boolean logstatus = RequestManager.saveRequestLog() ;

// 相关客户和相关项目更新
if( src.equals("save") || src.equals("submit") ) {      // 修改细表和主表信息
    if( !crmids.equals("") || !projectids.equals("") ) {
        String updatesql = " update workflow_requestbase set crmids = '" + crmids + "' , prjids = '" +
                           projectids + "' where requestid = " + requestid ;
        RecordSet.executeSql( updatesql ) ;
    }
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
if (RequestManager.getNextNodetype().equals("3")) {
    String deletesql="delete from FnaExpenseInfo where requestid="+requestid;
    RecordSet.executeSql( deletesql ) ;
}

if( src.equals("delete") ) {           //  修改 bill_HrmFinance 表的状态
    RecordSet.executeProc("bill_HrmFinance_UpdateStatus",""+billid + Util.getSeparator() + "2");
}
else if( src.equals("active") ) {
    if( RequestManager.getNextNodetype().equals("3")) 
        RecordSet.executeProc("bill_HrmFinance_UpdateStatus",""+billid + Util.getSeparator() + "1");
    else
        RecordSet.executeProc("bill_HrmFinance_UpdateStatus",""+billid + Util.getSeparator() + "0");
}
else if( RequestManager.getNextNodetype().equals("3")) {
    RecordSet.executeProc("bill_HrmFinance_UpdateStatus",""+billid + Util.getSeparator() + "1");
    
    Calendar today = Calendar.getInstance();
    String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

    char flag=Util.getSeparator() ;
    String feetypeid = "" ;
    String resourceid = "" ;
    String departmentid = "" ;
    String crmid = "" ;
    String projectid = "" ;
    String amount = "" ;
    String description = "" ;
    String occurdate = currentdate ;
    String releatedid = "" + requestid ;
    String releatedname = requestname ;
    String iscontractid = "0"; 
	String feesum ="";
    double tempamount = 0;

    String expenseapplytype = "" ;              // 报销类型
    double realamount = 0 ;

    RecordSetBED.executeSql(" select a.resourceid, a.debitledgeid , a.realamount , a.occurdate, a.departmentid , b.* from bill_HrmFinance a , Bill_ExpenseDetail b where a.id = b.expenseid and a.id = " + billid );

    while( RecordSetBED.next() ) {
        feetypeid = Util.null2String( RecordSetBED.getString("feetypeid") ) ;
        resourceid = Util.null2String( RecordSetBED.getString("resourceid") ) ;
        crmid = Util.null2String( RecordSetBED.getString("relatedcrm") ) ;
        projectid = Util.null2String( RecordSetBED.getString("relatedproject") ) ;
        amount = Util.null2String( RecordSetBED.getString("realfeesum") ) ;
        occurdate = Util.null2String( RecordSetBED.getString("occurdate") ) ;
        description = Util.null2String( RecordSetBED.getString("detailremark") ) ;
        departmentid = Util.null2String(RecordSetBED.getString("departmentid"));
		feesum = Util.null2String( RecordSetBED.getString("feesum") ) ;

        expenseapplytype = Util.null2String( RecordSetBED.getString("debitledgeid") ) ;
        realamount = Util.getDoubleValue(RecordSetBED.getString("realamount")) ;
		tempamount = Util.getDoubleValue(amount);
		if(tempamount<=0) amount = feesum;

        String para = feetypeid + flag + resourceid + flag + departmentid + flag + crmid + flag + 
			projectid + flag + df.format(Util.getDoubleValue(amount, 0.00)) + flag + description + flag + occurdate + 
            flag + releatedid + flag + releatedname + flag +iscontractid ;

        RecordSet.executeProc("FnaAccountLog_Insert",para);
    }

    if( expenseapplytype.equals("4") ) {
        double loanamount = 0 ;

        RecordSet.executeSql("select sum(amount) from fnaloaninfo where organizationtype=3 and organizationid="+resourceid);
        RecordSet.next();
        loanamount=Util.getDoubleValue(RecordSet.getString(1),0);
        
        if( loanamount != 0 && realamount != 0) {
            String loantypeid = "3" ;
            crmid = "" ;
            projectid = "" ;
            description = "" ;
            String credenceno = "" ;
            String returndate = "" ;
            String dealuser = "" ;

            if( realamount  < loanamount ) loanamount = realamount ;

            String para = loantypeid + flag + resourceid + flag + departmentid + flag + crmid + flag + 
			projectid + flag + ""+df.format(loanamount) + flag + description + flag + credenceno + flag +
            occurdate + flag + releatedid + flag + releatedname + flag + returndate + flag + dealuser;

            boolean success = RecordSet.executeProc("FnaLoanLog_Insert",para);
        	if(success){
        		String sql = "insert into fnaloaninfo(loantype,organizationtype,organizationid,relatedcrm,relatedprj,amount,occurdate,requestid,remark,debitremark,processorid) "+
        			" values(3,3,'"+resourceid+"','"+crmid+"','"+projectid+"','"+df.format(loanamount * -1)+"','"+StringEscapeUtils.escapeSql(occurdate)+"', "+
        			" '"+StringEscapeUtils.escapeSql(releatedid)+"','"+StringEscapeUtils.escapeSql(description)+"','"+StringEscapeUtils.escapeSql(credenceno)+"','"+StringEscapeUtils.escapeSql(dealuser)+"')";
        		RecordSet.executeSql(sql);
       		}        	
        }

        //String deletesql="delete from FnaExpenseInfo where requestid="+requestid;
        //RecordSet.executeSql( deletesql ) ;
    }
}

 
%><%@ include file="/workflow/request/RedirectPage.jsp" %> 
<%
/*
String basictype="1";       // 1 因公流出 2 因公流入 3 因私流出 4 因私流入 /
String detailtype="1"; 

1-1 费用报销
2-1 收入
3-1 私人借款
4-1 私人还款

报销类型
<option value="1">现金</option>
<option value="2">支票</option>
<option value="3">汇票</option>
<option value="4">冲销借款</option>
<option value="5">其它(请说明)</option>

*/
%>
