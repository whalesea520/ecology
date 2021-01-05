
<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="tempRecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="requestCheckAddinRules" class="weaver.workflow.request.RequestCheckAddinRules" scope="page" />

<%


String approveType = Util.null2String(request.getParameter("approveType"));
String srcInit = Util.null2String(request.getParameter("src"));

// 操作的用户信息
int userid=user.getUID();                   //当前用户id
int usertype = 0;                           //用户在工作流表中的类型 0: 内部 1: 外部
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
String userName = "";

if(logintype.equals("1"))
	userName = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	userName = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());


Calendar today = Calendar.getInstance();
String currentDate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
                     Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
                     Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

String currentTime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
                     Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
                     Util.add0(today.get(Calendar.SECOND), 2) ;

String src = srcInit;
String iscreate = "0";
int isremark = 0;
String remark = "\n"+userName+" "+currentDate+" "+currentTime;
String workflowtype = "";
int formid = -1;
int isbill = -1;
int billid = -1;
String messageType = "";
int nodeid = -1;
String nodetype = "";
String requestname = "";
String requestlevel = "";

String docIds="";
String crmIds="";
String hrmIds="";
String prjIds="";
String cptIds="";

String approveid= "" ;
String approvetype= "" ;

String Procpara = "" ;
char flag = 2 ;


String multiRequestId=Util.null2String(request.getParameter("multiRequestId"));
String [] requestids=Util.TokenizerString2(multiRequestId,",");

for (int i=0; i<requestids.length; i++){
    
    int requestid = Util.getIntValue(requestids[i],-1) ;
     /*----------xwj for td3098 20051202 begin -----*/
    src = srcInit;
    isremark = 0;
    RecordSet.executeSql("select min(isremark) from workflow_currentoperator where requestid = " + requestid + " and userid = "+user.getUID());
    if(RecordSet.next()){
		int isremarkCheck = RecordSet.getInt(1);
        if(isremarkCheck==1&&src.equals("submit")){
			src = "save";
			isremark = 1;
		}
	}
    
    /*----------xwj for td3098 20051202 end -----*/
    
    int workflowid=-1;

    if(requestid!=-1 ){

    RecordSet.executeSql("select billId from workflow_form where requestid="+requestid);
    if(RecordSet.next()){
		billid = RecordSet.getInt("billId");
    }

    //RecordSet.executeSql("select currentnodeid,currentnodetype,requestname,requestlevel,workflowid from workflow_requestbase where requestid="+requestid);
    RecordSet.executeSql("select currentnodeid,currentnodetype,requestname,requestlevel,workflowid,docIds,crmIds,hrmIds,prjIds,cptIds from workflow_requestbase where requestid="+requestid);
    if(RecordSet.next()){
      nodeid = RecordSet.getInt("currentnodeid");
      nodetype = RecordSet.getString("currentnodetype");
      requestname = RecordSet.getString("requestname");
      requestlevel = RecordSet.getString("requestlevel");
      workflowid = RecordSet.getInt("workflowid");
	  docIds = Util.null2String(RecordSet.getString("docIds"));
	  crmIds = Util.null2String(RecordSet.getString("crmIds"));
	  hrmIds = Util.null2String(RecordSet.getString("hrmIds"));
	  prjIds = Util.null2String(RecordSet.getString("prjIds"));
	  cptIds = Util.null2String(RecordSet.getString("cptIds"));
    }

    RecordSet.executeSql("select workflowtype,formid,isbill,messageType from workflow_base where id="+workflowid);
    if(RecordSet.next()){
      workflowtype = RecordSet.getString("workflowtype");
      formid = RecordSet.getInt("formid");
      isbill = RecordSet.getInt("isbill");
      //billid = RecordSet.getInt("formid");
      messageType = RecordSet.getString("messageType");
    }


    if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
        response.sendRedirect("/notice/RequestError.jsp");
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
    RequestManager.setRequest(request) ;
    RequestManager.setMessageType(messageType) ;
    RequestManager.setUser(user) ;

    //如果为批准工作流
    if(approveType.equals("")){
		RecordSet.executeProc("Bill_Approve_SelectByID",billid+"");
		if (RecordSet.next()) {
			approveid=RecordSet.getString("approveid");
			approvetype=RecordSet.getString("approvetype");
		}
		if (approvetype.equals("9")){    //文档 
		    int intapproveid=Util.getIntValue(approveid,0);
		    RecordSet.executeSql("select max(b.id) from DocDetail a,DocDetail b where a.docEditionId=b.docEditionId and a.docEditionId>0 and a.id="+intapproveid);
		    if(RecordSet.next()){
				intapproveid=Util.getIntValue(RecordSet.getString(1),intapproveid);
				if(intapproveid>0){
					approveid=""+intapproveid;
				}
		    }
			RequestManager.setDocids(approveid);
		}
		if (approvetype.equals("10"))    //客户
			RequestManager.setCrmids(approveid);
		if (approvetype.equals("11"))    //项目
			RequestManager.setPrjids(approveid);
	}

    if("1".equals(approveType)||"2".equals(approveType)){

			RequestManager.setDocids(docIds);
			RequestManager.setCrmids(crmIds);
			RequestManager.setHrmids(hrmIds);
			RequestManager.setPrjids(prjIds);
			RequestManager.setCptids(cptIds);
	}

//###################文档审批节点附加操作 td29590 start// #############################################################
		// 开始节点自动赋值操作(用在处理节点前，节点后等的赋值操作)
        String rejectbackflag = "";//退回时，当前节点的节点后附加操作是否触发。rejectbackflag=1，表示触发。
        //RecordSet tempRecordSet = new RecordSet(); 
        tempRecordSet.executeSql("select rejectbackflag from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
        if(tempRecordSet.next()){
        	rejectbackflag = Util.null2String(tempRecordSet.getString("rejectbackflag"));
        }

		if(!src.equals("save")&&(!src.equals("reject")||(src.equals("reject")&&!rejectbackflag.equals("1")))){//用于修改，保存也会执行节点后附加操作
//		rs.executeSql("select * from workflow_addinoperate  where workflowid="+workflowid+" and type=2 and customervalue='action.WorkflowToDoc' ");
//		tempRecordSet.executeSql("select * from workflow_addinoperate  where workflowid="+workflowid+" and isnode=1 and objid="+nodeid+" and ispreadd='0' and type=2 and customervalue='action.WorkflowToDoc' ");						
//		if(tempRecordSet.next())
//		 {
//			   isWorkFlowToDoc=true;
//		 }
		try {
			 //由于objtype为"1: 节点自动赋值",不为"0 :出口自动赋值"，不用改变除状态外的文档相关信息，故可不用给user、clienIp、src赋值  fanggsh TD5121			
			//RequestCheckAddinRules requestCheckAddinRules = new RequestCheckAddinRules();
			requestCheckAddinRules.resetParameter();
			//add by cyril on 2008-07-28 for td:8835 事务无法开启查询,只能传入
		    boolean isStart = true;	//流程是否已开始流转 by cyril
	        boolean isTrack = true; //功能开关,是否记录修改日志 by cyril
            requestCheckAddinRules.setTrack(isTrack);
            requestCheckAddinRules.setStart(isStart);
            requestCheckAddinRules.setNodeid(nodeid);
            //end by cyril on 2008-07-28 for td:8835
			requestCheckAddinRules.setRequestid(requestid);
			requestCheckAddinRules.setWorkflowid(workflowid);
			requestCheckAddinRules.setObjid(nodeid);
			requestCheckAddinRules.setObjtype(1);               // 1: 节点自动赋值 0 :出口自动赋值
			requestCheckAddinRules.setIsbill(isbill);
			requestCheckAddinRules.setFormid(formid);
			requestCheckAddinRules.setIspreadd("0");//xwj for td3130 20051123
			//requestCheckAddinRules.setRequestManager(this);
			requestCheckAddinRules.setRequestManager(RequestManager);
			requestCheckAddinRules.setUser(user);			
			requestCheckAddinRules.checkAddinRules();
		} catch (Exception erca) {
			////writeLog(erca);
			//RequestManager.saveRequestLog("1");
			RequestManager.saveRequestLog2();
			

            if(erca.getMessage().indexOf("workflow interface action error")>-1){
               RequestManager.writeLog(erca);
            }
		}
		}
//###################文档审批节点附加操作 td29590 end// #############################################################



    boolean flowstatus = RequestManager.flowNextNode() ;


    if( !flowstatus ) {
		RecordSet.writeLog("flowstatus="+flowstatus+"##requestid="+requestid);     
    }
    PoppupRemindInfoUtil.updatePoppupRemindInfo(userid,0,(logintype).equals("1") ? "0" : "1",requestid); 
    boolean logstatus = RequestManager.saveRequestLog() ;

    //审批类型为文档生效审批或文档失效审批时，更改文档审批工作流表(DocApproveWf)的数据。为批准工作流时不更改。
	if(approveType.equals("1")||approveType.equals("2")){
		RecordSet.executeSql("update DocApproveWf set status='1'  where requestId="+requestid);
	}else{//否则则为批准工作流
        //处理request且选择保存logtype=1
		if(src.equals("save")&&isremark==1){
			//记录签字意见
			//写DocApproveRemark表
            Procpara=approveid+flag+remark+flag+""+userid+flag+currentDate+flag+currentTime+flag+"2";
            RecordSet.executeProc("DocApproveRemark_Insert",Procpara);
		}

		if(src.equals("submit")){//处理request且选择提交logtype=2
		    //写DocApproveRemark表
		    if(nodetype.equals("0")) { // 认为是批注

                Procpara=approveid+flag+remark+flag+""+userid+flag+currentDate+flag+currentTime+flag+"2";
		    }else{
				Procpara=approveid+flag+remark+flag+""+userid+flag+currentDate+flag+currentTime+flag+"1";
			}
			RecordSet.executeProc("DocApproveRemark_Insert",Procpara);
			//DocManager.approveDocFromWF("approve",approveid,currentDate,currentTime,userid+""); 
			if(nodetype.equals("0")){
				RecordSet.executeSql("update DocDetail set docStatus='3'  where id="+approveid);
			}else if(RequestManager.getNextNodetype().equals("3") ){
				DocManager.approveDocFromWF("approve",approveid,currentDate,currentTime,userid+""); 
			}

		    if( RequestManager.getNextNodetype().equals("3") )    {
				RecordSet.executeProc("bill_Approve_UpdateStatus",""+billid+flag+"1");
		    }
		}

		if(src.equals("reject")){//处理request且选择退回logtype=3
		    //写DocApproveRemark表
			Procpara=approveid+flag+remark+flag+""+userid+flag+currentDate+flag+currentTime+flag+"0";
			RecordSet.executeProc("DocApproveRemark_Insert",Procpara);
			DocManager.approveDocFromWF("reject",approveid,currentDate,currentTime,userid+"");
		}

	}

  }
}

response.sendRedirect("/docs/docs/ApproveDocList.jsp?approveType="+approveType);

%>