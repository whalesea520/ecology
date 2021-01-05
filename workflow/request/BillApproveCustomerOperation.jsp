
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,
                 java.sql.Timestamp"%>
<%@page import="weaver.workflow.workflow.WFManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.file.FileUpload" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetX" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<%--客户审批参数存储类--%>
<jsp:useBean id="ApproveCustomerParameter" class="weaver.workflow.request.ApproveCustomerParameter" scope="session"/>

<%
FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user= HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码

    String ProcPara = "";
    char flag = 2;
    boolean isoracle = (RecordSet.getDBType()).equals("oracle");
    String src = Util.null2String(fu.getParameter("src"));
    String iscreate = Util.null2String(fu.getParameter("iscreate"));
    int requestid = Util.getIntValue(fu.getParameter("requestid"),-1);
    int workflowid = Util.getIntValue(fu.getParameter("workflowid"),-1);
    String workflowtype = Util.null2String(fu.getParameter("workflowtype"));
    String isfromcus = Util.null2String(fu.getParameter("isfromcus"));

    int isremark = Util.getIntValue(fu.getParameter("isremark"),-1);
    int formid = Util.getIntValue(fu.getParameter("formid"),-1);
    int isbill = Util.getIntValue(fu.getParameter("isbill"),-1);
    int billid = Util.getIntValue(fu.getParameter("billid"),-1);
    int nodeid = Util.getIntValue(fu.getParameter("nodeid"),-1);
    String nodetype = Util.null2String(fu.getParameter("nodetype"));
    String requestname = Util.fromScreen(fu.getParameter("requestname"),user.getLanguage());
    String requestlevel = Util.fromScreen(fu.getParameter("requestlevel"),user.getLanguage());
    String messageType =  Util.fromScreen(fu.getParameter("messageType"),user.getLanguage());
    String remark = Util.null2String(fu.getParameter("remark"));
    String crmids = "" ;
    String projectids = "" ;

    String isneedsave = Util.null2String(fu.getParameter("isneedsave")); //是否需要执行保存节点的操作
    String isfromcrm = Util.null2String(fu.getParameter("isfromcrm")); //是否是从客户页面提交的请求

		String fieldName = "";		// added by xys for TD2031
		
    Date newdate = new Date() ;
    long datetime = newdate.getTime() ;
    Timestamp timestamp = new Timestamp(datetime) ;
    String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
    String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

    if(src.equals("submit")&&iscreate.equals("1")&& ApproveCustomerParameter.getNodetype()!=null) {//新建request时
        workflowid=ApproveCustomerParameter.getWorkflowid();
        formid=ApproveCustomerParameter.getFormid();
        requestname=ApproveCustomerParameter.getRequestname();
        nodeid=ApproveCustomerParameter.getNodeid();
        nodetype=ApproveCustomerParameter.getNodetype();
    }
    if(isfromcrm.equals("1")){
        String logintype = user.getLogintype();
        int operatortype=0;
        if(logintype.equals("1")) operatortype = 0;
        if(logintype.equals("2")) operatortype = 1;
        RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
        if(RecordSet.next()){
            workflowid=RecordSet.getInt("workflowid");
            nodeid=RecordSet.getInt("currentnodeid");
            nodetype=RecordSet.getString("currentnodetype");
            requestname=RecordSet.getString("requestname");

        }

        //~~~~~~~~~~~~~~get billformid & billid~~~~~~~~~~~~~~~~~~~~~
        RecordSet.executeProc("workflow_form_SByRequestid",requestid+"");
        if(RecordSet.next()){
            formid=RecordSet.getInt("billformid");
            billid=RecordSet.getInt("billid");
        }

        RecordSet.executeSql("select isremark from workflow_currentoperator where requestid="+requestid+" and userid="+user.getUID()+" and usertype = "+operatortype + " and isremark in ('1','0') " );
        if(RecordSet.next())	{
            isremark=Util.getIntValue(RecordSet.getString(1),0);
        }
    }

    isbill=1;
    if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
	    //response.sendRedirect("/notice/RequestError.jsp");
		out.print("<script>wfforward('/notice/RequestError.jsp');</script>");
	    return ;
    }


    if(remark.trim().equals("")){
        remark = "<br>"+ResourceComInfo.getLastname(user.getUID()+"")+" "+CurrentDate;
    }

    WFManager wfManager = new WFManager();
    wfManager.setWfid(workflowid);
    wfManager.getWfInfo();
    messageType = wfManager.getMessageType();
	if(messageType.equals("1"))messageType = wfManager.getSmsAlertsType();

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
    RequestManager.setBilltablename("bill_ApproveCustomer");


    boolean savestatus = true;
    if(!isneedsave.equals("notneedsave")){
        savestatus = RequestManager.saveRequestInfo() ;
        requestid = RequestManager.getRequestid() ;

        if( !savestatus ) {
            if( requestid != 0 ) {

                String message=RequestManager.getMessage();
                if(!"".equals(message)){
        			out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message="+message+"');</script>");
                    return ;
                }

                //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1");
                out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=1');</script>");
        		return ;
            }
            else {
                //response.sendRedirect("/workflow/request/RequestView.jsp?message=1");
                out.print("<script>wfforward('/workflow/request/RequestView.jsp?message=1');</script>");
                return ;
            }
        }
    }


    String approveid= "" ;
    String managerid = "";
    String approvetype= "" ;
    String approvevalue = "";
    String approvedesc = "";
    String gopage = "" ;
    String backpage = "" ;
    String seclevel = "";
    gopage = ApproveCustomerParameter.getGopage();

    if(src.equals("submit")&&iscreate.equals("1")) {//新建request时
        billid = RequestManager.getBillid() ;
        approveid=ApproveCustomerParameter.getApproveid()+"";
        managerid = ApproveCustomerParameter.getManagerid() + "";
        approvetype=ApproveCustomerParameter.getApprovetype()+"";
        gopage=ApproveCustomerParameter.getGopage();
        backpage=ApproveCustomerParameter.getBackpage();

        approvedesc = ApproveCustomerParameter.getRequestname();
        approvevalue = ApproveCustomerParameter.getApprovevalue();
        seclevel = ApproveCustomerParameter.getSeclevel();
        
        gopage = ApproveCustomerParameter.getGopage();

        String updateclause="set ";
        updateclause+= "approveid="+approveid+",approvetype="+approvetype+",approvevalue="+approvevalue+",approvedesc='"+approvedesc+"',managerid="+managerid+",status='0'";
        updateclause="update bill_ApproveCustomer "+updateclause+" where id = "+billid;
        //System.out.println("updateclause = " + updateclause);
        RecordSet.executeSql(updateclause);
    }else{
        String sql = "select approveid,managerid from bill_ApproveCustomer where id="+billid;
        RecordSet.executeSql(sql);
        if(RecordSet.next()){
            approveid = RecordSet.getString("approveid");
        }

    }
    RequestManager.setCrmids(approveid);


    boolean flowstatus = RequestManager.flowNextNode() ;
    if( !flowstatus ) {
        //response.sendRedirect("/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2");
		out.print("<script>wfforward('/workflow/request/ManageRequest.jsp?requestid="+requestid+"&message=2');</script>");
        return ;
    }
    boolean logstatus = RequestManager.saveRequestLog() ;

    if(src.equals("submit")&&iscreate.equals("1")) {
        if(RequestManager.getNextNodetype().equals("3")){
            approveid=ApproveCustomerParameter.getApproveid()+"";
            approvetype=ApproveCustomerParameter.getApprovetype()+"";

            approvevalue = ApproveCustomerParameter.getApprovevalue();

            //更改单据的状态，1：已经归档
            RecordSet.executeSql("update bill_ApproveCustomer set status=1 where id="+RequestManager.getBillid());

            RecordSet.executeProc("CRM_CustomerInfo_SelectByID",approveid);
            RecordSet.first();
            String statusTemp = RecordSet.getString("status");
            String Manager2 = RecordSet.getString("manager");
            String name = RecordSet.getString("name");
            if(approvetype.equals("1")){
                ProcPara = approveid;
                ProcPara += flag+approvevalue;
                ProcPara += flag+"1";

                RecordSet.executeProc("CRM_CustomerInfo_Approve",ProcPara);

                ProcPara = approveid;
                ProcPara += flag+"a";
                //ProcPara += flag+"a";
                ProcPara += flag+"0";
                ProcPara += flag+"a";
                ProcPara += flag+CurrentDate;
                ProcPara += flag+CurrentTime;
                //ProcPara += flag+user.getUID();
                ProcPara += flag+""+user.getUID();
                ProcPara += flag+user.getLogintype();
                ProcPara += flag+fu.getRemoteAddr();
                RecordSet.executeProc("CRM_Log_Insert",ProcPara);

                fieldName = SystemEnv.getHtmlLabelName(23247,user.getLanguage());

                ProcPara = approveid+flag+"1"+flag+"0"+flag+"0";
                ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+statusTemp+flag+approvevalue;
                //ProcPara += flag+user.getUID()+flag+user.getLogintype()+flag+fu.getRemoteAddr();
                ProcPara += flag+""+user.getUID()+flag+user.getLogintype()+flag+fu.getRemoteAddr();
                RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
            }else if(approvetype.equals("2")){
                ProcPara = approveid;
                ProcPara += flag+approvevalue;

                RecordSet.executeProc("CRM_CustomerInfo_Portal",ProcPara);
                String PortalLoginid = "";
                String PortalPassword = "";

                if(approvevalue.equals("2")){//批准开放客户门户，客户可通过登录OA根据权限创建流程
                    if (approveid.length()<5){
                        PortalLoginid = "U" + Util.add0(Util.getIntValue(approveid),5);
                    }else{
                        PortalLoginid = "U" + approveid;
                    }

                    //PortalPassword = Util.getPortalPassword();
                    RecordSet.executeSql("SELECT PortalPassword FROM CRM_CustomerInfo WHERE id ="+approveid);
		            RecordSet.next();
					PortalPassword = Util.null2String(RecordSet.getString("PortalPassword"));

                    ProcPara = approveid;
                    ProcPara += flag+PortalLoginid;
                    ProcPara += flag+PortalPassword;

                    RecordSet.executeProc("CRM_CustomerInfo_PortalPasswor",ProcPara);
                }
                ProcPara = approveid;
                ProcPara += flag+"p";
                //ProcPara += flag+"p";
                ProcPara += flag+"0";
                ProcPara += flag+"p";
                ProcPara += flag+CurrentDate;
                ProcPara += flag+CurrentTime;
                //ProcPara += flag+user.getUID();
                ProcPara += flag+""+user.getUID();
                ProcPara += flag+user.getLogintype();
                ProcPara += flag+fu.getRemoteAddr();
                RecordSet.executeProc("CRM_Log_Insert",ProcPara);
                fieldName = SystemEnv.getHtmlLabelName(23249,user.getLanguage());

                ProcPara = approveid+flag+"1"+flag+"0"+flag+"0";
                ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+statusTemp+flag+approvevalue;
                //ProcPara += flag+user.getUID()+flag+user.getLogintype()+flag+fu.getRemoteAddr();
                ProcPara += flag+""+user.getUID()+flag+user.getLogintype()+flag+fu.getRemoteAddr();
                RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
            }else if(approvetype.equals("3")){
                String PortalLoginid = "";
                String PortalPassword = "";

                if(approvevalue.equals("2")){
                    if (approveid.length()<5){
                        PortalLoginid = "U" + Util.add0(Util.getIntValue(approveid),5);
                    }else{
                        PortalLoginid = "U" + approveid;
                    }

                    PortalPassword = Util.getPortalPassword();

                    ProcPara = approveid;
                    ProcPara += flag+PortalLoginid;
                    ProcPara += flag+PortalPassword;

                    RecordSet.executeProc("CRM_CustomerInfo_PortalPasswor",ProcPara);
                }
            }
        }
    }
    if(src.equals("submit")&&iscreate.equals("0")) {
        if(RequestManager.getNextNodetype().equals("3")){
            String sql= "select approveid,approvevalue,approvetype from bill_ApproveCustomer where id="+billid;
            RecordSet.executeSql(sql);
            if(RecordSet.next()){
                approveid=RecordSet.getString("approveid");
                approvetype=RecordSet.getString("approvetype");

                approvevalue = RecordSet.getString("approvevalue");
            }
            //更改单据的状态，1：已经归档
            RecordSet.executeSql("update bill_ApproveCustomer set status=1 where id="+RequestManager.getBillid());
            RecordSet.executeProc("CRM_CustomerInfo_SelectByID",approveid);
            RecordSet.first();
            String statusTemp = RecordSet.getString("status");
            String Manager2 = RecordSet.getString("manager");
            String name = RecordSet.getString("name");

            if(approvetype.equals("1")){
                ProcPara = approveid;
                ProcPara += flag+approvevalue;
                ProcPara += flag+"1";

                RecordSet.executeProc("CRM_CustomerInfo_Approve",ProcPara);

                ProcPara = approveid;
                ProcPara += flag+"a";
                //ProcPara += flag+"a";
                ProcPara += flag+"0";
                ProcPara += flag+"a";
                ProcPara += flag+CurrentDate;
                ProcPara += flag+CurrentTime;
                //ProcPara += flag+user.getUID();
                ProcPara += flag+""+user.getUID();
                ProcPara += flag+user.getLogintype();
                ProcPara += flag+fu.getRemoteAddr();
                RecordSet.executeProc("CRM_Log_Insert",ProcPara);
                fieldName = SystemEnv.getHtmlLabelName(23247,user.getLanguage());

                ProcPara = approveid+flag+"1"+flag+"0"+flag+"0";
                ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+statusTemp+flag+approvevalue;
                //ProcPara += flag+user.getUID()+flag+user.getLogintype()+flag+fu.getRemoteAddr();
                 ProcPara += flag+""+user.getUID()+flag+user.getLogintype()+flag+fu.getRemoteAddr();
                RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
            }else if(approvetype.equals("2")){
                ProcPara = approveid;
                ProcPara += flag+approvevalue;

                RecordSet.executeProc("CRM_CustomerInfo_Portal",ProcPara);
                if(approvevalue.equals("3")){//冻结
                	//冻结的客户门户
                	//RecordSetM.executeSql("delete from workflow_createrlist where usertype = 1 and  userid ="+approveid);
                	//System.out.println("冻结了该客户门户"+approveid);
                }
                
                String PortalLoginid = "";
                String PortalPassword = "";

                if(approvevalue.equals("2")){
                    if (approveid.length()<5){
                        PortalLoginid = "U" + Util.add0(Util.getIntValue(approveid),5);
                    }else{
                        PortalLoginid = "U" + approveid;
                    }

                  //  PortalPassword = Util.getPortalPassword();
					RecordSet.executeSql("SELECT PortalPassword FROM CRM_CustomerInfo WHERE id ="+approveid);
		            RecordSet.next();
					PortalPassword = Util.null2String(RecordSet.getString("PortalPassword"));
					
                    ProcPara = approveid;
                    ProcPara += flag+PortalLoginid;
                    ProcPara += flag+PortalPassword;

                    RecordSet.executeProc("CRM_CustomerInfo_PortalPasswor",ProcPara);
                  //门户激活即可更新流程路径设置中是门户工作流程的创建节点具有权限的人员信息
                    //begin
                    //RecordSetM.executeSql("delete from workflow_createrlist where usertype = 1 and  userid ="+approveid);
                  	String Procpara = "";
                   
            		//end
                }
                ProcPara = approveid;
                ProcPara += flag+"p";
                //ProcPara += flag+"p";
                ProcPara += flag+"0";
                ProcPara += flag+"p";
                ProcPara += flag+CurrentDate;
                ProcPara += flag+CurrentTime;
                //ProcPara += flag+user.getUID();
                ProcPara += flag+""+user.getUID();
                ProcPara += flag+user.getLogintype();
                ProcPara += flag+fu.getRemoteAddr();
                RecordSet.executeProc("CRM_Log_Insert",ProcPara);
                fieldName = SystemEnv.getHtmlLabelName(23249,user.getLanguage());

                ProcPara = approveid+flag+"1"+flag+"0"+flag+"0";
                ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+statusTemp+flag+approvevalue;
                //ProcPara += flag+user.getUID()+flag+user.getLogintype()+flag+fu.getRemoteAddr();
                ProcPara += flag+""+user.getUID()+flag+user.getLogintype()+flag+fu.getRemoteAddr();
                RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
            }else if(approvetype.equals("3")){
                String PortalLoginid = "";
                String PortalPassword = "";

                if(approvevalue.equals("2")){
                    if (approveid.length()<5){
                        PortalLoginid = "U" + Util.add0(Util.getIntValue(approveid),5);
                    }else{
                        PortalLoginid = "U" + approveid;
                    }

                    PortalPassword = Util.getPortalPassword();

                    ProcPara = approveid;
                    ProcPara += flag+PortalLoginid;
                    ProcPara += flag+PortalPassword;

                    RecordSet.executeProc("CRM_CustomerInfo_PortalPasswor",ProcPara);
                }
            }
        }
    }
    if(src.equals("delete")&&iscreate.equals("0")) {
        String sql="delete from bill_ApproveCustomer where id = "+billid;
        //System.out.println("updateclause = " + updateclause);
        RecordSet.executeSql(sql);
    }
    String tmpNodeType = RequestManager.getNextNodetype();
    if( tmpNodeType.equals("1") ) {
        String sql = "update bill_ApproveCustomer set status='2' where id="+billid;
        RecordSet.executeSql(sql);
    }else if( tmpNodeType.equals("2") ) {
        String sql = "update bill_ApproveCustomer set status='3' where id="+billid;
        RecordSet.executeSql(sql);
    }else if( tmpNodeType.equals("0") ) {
        String sql = "update bill_ApproveCustomer set status='0' where id="+billid;
        RecordSet.executeSql(sql);
    }

    if(gopage!=null&&!gopage.equals("")){
        ApproveCustomerParameter.resetParameter();
        response.sendRedirect(gopage);
    }

    //response.sendRedirect("/workflow/request/RequestView.jsp");
 
%><%@ include file="/workflow/request/RedirectPage.jsp" %> 