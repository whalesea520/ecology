
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util,
                 java.sql.Timestamp"%>
<%@ page import="weaver.file.FileUpload" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="wflinkinfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetM" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSetX" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="rst" class="weaver.conn.RecordSet" scope="page"/>
<%
	String isSuccess = "true";
    FileUpload fu = new FileUpload(request);
    char separator = Util.getSeparator() ;
    boolean isoracle = (RecordSet.getDBType()).equals("oracle");
    String operation = Util.null2String(fu.getParameter("operation"));
    String iscreate = "0";
    int requestid = -1;
    int workflowid = -1;
    String workflowtype =Util.null2String(fu.getParameter("workflowtype"));

    int isremark = -1;
    int formid = -1;
    int isbill = 1;
    int billid = -1;
    int nodeid = -1;
    String nodetype = "0";
    String requestname = "";
    String requestlevel = "";
    String remark = "";

	String fieldName = "";		// added by xys for TD2031
	String isneedsave = Util.null2String(request.getParameter("isneedsave")); //是否需要执行保存节点的操作
	if(operation.equals("approve")){
	String src = "submit";
    String[] requestids = request.getParameterValues("requestid");
    if(requestids==null){
        response.sendRedirect("ApproveCustomerList.jsp");
    }
    for(int i=0; i<requestids.length;i++){
        Date newdate = new Date() ;
        long datetime = newdate.getTime() ;
        Timestamp timestamp = new Timestamp(datetime) ;
        String CurrentDate = (timestamp.toString()).substring(0,4) + "-" + (timestamp.toString()).substring(5,7) + "-" +(timestamp.toString()).substring(8,10);
        String CurrentTime = (timestamp.toString()).substring(11,13) + ":" + (timestamp.toString()).substring(14,16) + ":" +(timestamp.toString()).substring(17,19);

        requestid = Util.getIntValue(requestids[i],0);
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
        RequestManager.setRequest(request) ;
        RequestManager.setUser(user) ;


        boolean flowstatus = RequestManager.flowNextNode() ;
        String approveid= "" ;
        String approvetype= "" ;
        String approvevalue = "";
        String approvedesc = "";
        String gopage = "" ;
        String backpage = "" ;
        String ProcPara = "";
        char flag = 2;
		if("".equals(RequestManager.getNextNodetype())){
			isSuccess = "false";
		}
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
                ProcPara += flag+request.getRemoteAddr();
                RecordSet.executeProc("CRM_Log_Insert",ProcPara);
                fieldName = SystemEnv.getHtmlLabelName(23247,user.getLanguage());

                ProcPara = approveid+flag+"1"+flag+"0"+flag+"0";
                ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+statusTemp+flag+approvevalue;
                //ProcPara += flag+user.getUID()+flag+user.getLogintype()+flag+request.getRemoteAddr();
                ProcPara += flag+""+user.getUID()+flag+user.getLogintype()+flag+request.getRemoteAddr();
                RecordSet.executeProc("CRM_Modify_Insert",ProcPara);
            }else if(approvetype.equals("2")){
                ProcPara = approveid;
                ProcPara += flag+approvevalue;

                RecordSet.executeProc("CRM_CustomerInfo_Portal",ProcPara);
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
                ProcPara += flag+request.getRemoteAddr();
                RecordSet.executeProc("CRM_Log_Insert",ProcPara);
                fieldName = SystemEnv.getHtmlLabelName(23249,user.getLanguage());

                ProcPara = approveid+flag+"1"+flag+"0"+flag+"0";
                ProcPara += flag+fieldName+flag+CurrentDate+flag+CurrentTime+flag+statusTemp+flag+approvevalue;
                //ProcPara += flag+user.getUID()+flag+user.getLogintype()+flag+request.getRemoteAddr();
                ProcPara += flag+""+user.getUID()+flag+user.getLogintype()+flag+request.getRemoteAddr();
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
		}else if(operation.equals("reject")) {
				String src = "reject";
				String[] requestids = request.getParameterValues("requestid");
				
				if(requestids==null){
        			response.sendRedirect("ApproveCustomerList.jsp");
    			}
    			String logintype = user.getLogintype();
    			int operatortype=0;
		        if(logintype.equals("1")) operatortype = 0;
		        if(logintype.equals("2")) operatortype = 1;
    			for(int i=0; i<requestids.length;i++){
        		requestid = Util.getIntValue(requestids[i],0);
        		
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
		        RequestManager.setRequest(request) ;
		        RequestManager.setUser(user) ;
		        
		        boolean savestatus = true;
			    if(!isneedsave.equals("notneedsave")){
			        savestatus = RequestManager.saveRequestInfo() ;
			        requestid = RequestManager.getRequestid() ;
		        }
		        boolean flowstatus = RequestManager.flowNextNode() ;
		        String tmpNodeType = RequestManager.getNextNodetype();
				if("".equals(tmpNodeType)){
					isSuccess = "false";
				}
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
			   }
			}
    response.sendRedirect("ApproveCustomerList.jsp?issuccess="+isSuccess);
 
%>