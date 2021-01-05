<%@ page import="weaver.general.Util,java.net.*,weaver.workflow.field.FieldComInfo"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.workflow.request.RequestManager" %>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="WorkPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="WFUrgerManager" class="weaver.workflow.request.WFUrgerManager" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%
// 操作的用户信息

int userid=user.getUID();                   //当前用户id
int usertype = 0;                           //用户在工作流表中的类型 0: 内部 1: 外部
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
String username = "";

if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());

String dateSql = "";
if(rs.getDBType().equalsIgnoreCase("oracle")){
	dateSql = "select to_char(sysdate,'yyyy-mm-dd') as currentdate, to_char(sysdate,'hh24:mi:ss') as currenttime from dual";
}else{
	dateSql = "select convert(char(10),getdate(),20) as currentdate, convert(char(8),getdate(),108) as currenttime";
}
String currentdate = "";
String currenttime = "";
rs.execute(dateSql);
if(rs.next()){
	currentdate = Util.null2String(rs.getString(1));
	currenttime = Util.null2String(rs.getString(2));
}else{
	Calendar today = Calendar.getInstance();
	currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
			Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
			Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

	currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
			Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
			Util.add0(today.get(Calendar.SECOND), 2) ;
}

String src = "supervise";
String iscreate = "0";
int isremark = 0;
String remark = "\n"+Util.null2String(request.getParameter("remark"));
remark = remark.replaceAll("\n","<br>").replaceFirst("<br>","");
//System.err.println("remark:"+remark);
String workflowtype = "";
int formid = -1;
int isbill = -1;
int billid = -1;
String messageType = "";
int nodeid = -1;
String nodetype = "";
String requestname = "";
String requestlevel = "";

String requestidlist=Util.null2String(request.getParameter("reqids"));
String wftypes = "";
String [] requestids=Util.TokenizerString2(requestidlist,",");

for (int i=0; i<requestids.length; i++){
    RequestManager = new RequestManager();
    int requestid = Util.getIntValue(requestids[i],-1) ;
    WFUrgerManager.setLogintype(Util.getIntValue(logintype,1));
    WFUrgerManager.setUserid(userid);
    ArrayList wftypesTree=WFUrgerManager.getWorkflowTreeUrger();
    //想要获取临时表，还必须得到树，这神逻辑
    String tmpTableName = WFUrgerManager.getTmpTableName();
  //System.out.println("tmpTableName:"+tmpTableName);
    //判断当前流程是否还为当前操作者的可督办流程

    String sqlelma = "";
    if(RecordSet.getDBType().equals("sqlserver")){
	    sqlelma =" select  t1.requestid from ( select  t1.requestid from "+
	    		 " (select requestid,max(receivedate+' '+receivetime) as receivedatetime from workflow_currentoperator group by requestid) t2, " +
	    		 " workflow_requestbase t1  "+
	    		 " where (t1.currentnodetype is null or t1.currentnodetype<>'3') "+
	    		 " and t1.requestid=t2.requestid and t1.deleted<>1  " +
	    		 " and (isnull(t1.currentstatus,-1) = -1 or (isnull(t1.currentstatus,-1)=0 and t1.creater=1)) ) t1   ";
	    
    }else{
    	sqlelma =" select  t1.requestid from ( select  t1.requestid from "+
				 " (select requestid,max(receivedate||' '||receivetime) as receivedatetime from workflow_currentoperator group by requestid) t2, " +
				 " workflow_requestbase t1  "+
				 " where (t1.currentnodetype is null or t1.currentnodetype<>'3') "+
				 " and t1.requestid=t2.requestid and t1.deleted<>1  " +
				 " and (nvl(t1.currentstatus,-1) = -1 or (nvl(t1.currentstatus,-1)=0 and t1.creater=1)) ) t1   ";
    }
    
    if(tmpTableName != null) {
    	sqlelma += " ,(Select requestId from "+tmpTableName+") t2 ";
    	sqlelma += " where t1.requestid=t2.requestid and t1.requestid="+requestid;
	} else {
		sqlelma += " where t1.requestid="+requestid;
	}
    
  //System.out.println("sqlelma:"+sqlelma);
    RecordSet.execute(sqlelma);
    if(!RecordSet.next()){
    	continue;
    }
	
    /*----------xwj for td3098 20051202 end -----*/
    
    int workflowid=-1;
  //System.out.println("requestid:"+requestid);
    if(requestid!=-1 ){
    boolean isStart = false;
    RecordSet.executeSql("select currentnodeid,currentnodetype,requestname,requestlevel,workflowid,status from workflow_requestbase where requestid="+requestid);
    if(RecordSet.next()){
      requestname = RecordSet.getString("requestname");
      requestlevel = RecordSet.getString("requestlevel");
      workflowid = RecordSet.getInt("workflowid");
      isStart = (RecordSet.getString("status")!=null && !"".equals(RecordSet.getString("status")));
    }
    nodeid=WFLinkInfo.getCurrentNodeid(requestid,userid,Util.getIntValue(logintype,1));               //节点id
    nodetype=WFLinkInfo.getNodeType(nodeid);         //节点类型  0:创建 1:审批 2:实现 3:归档    
    boolean isTrack = true;
    RecordSet.executeSql("select workflowtype,formid,isbill,messageType,isModifyLog from workflow_base where id="+workflowid);
    if(RecordSet.next()){
      workflowtype = RecordSet.getString("workflowtype");
      formid = RecordSet.getInt("formid");
      isbill = RecordSet.getInt("isbill");
      messageType = RecordSet.getString("messageType");
      isTrack = (RecordSet.getString("ismodifylog")!=null && "1".equals(RecordSet.getString("ismodifylog")));
    }
	if(isbill == 1){
		RecordSet.execute("select tablename from workflow_bill where id="+formid);
		if(RecordSet.next()){
			String tablename = Util.null2String(RecordSet.getString(1));
			if(!"".equals(tablename)){
				RecordSet.execute("select id from "+tablename+" where requestid="+requestid);
				if(RecordSet.next()){
					billid = RecordSet.getInt("id");
				}
			}else{
				continue;
			}
		}
	}
    if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
        response.sendRedirect("/notice/RequestError.jsp");
        return ;
    }

	int requestKey = 0;
    RecordSet.executeSql("select id from workflow_currentoperator where requestid="+requestid+" and nodeid='"+nodeid+"' and userid="+userid+" and usertype="+usertype+" order by isremark,id");
    if(RecordSet.next()){
    	requestKey = RecordSet.getInt("id");
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
	RequestManager.setRequestKey(requestKey);
	boolean flowstatus = RequestManager.flowNextNode() ;
  }
}

response.sendRedirect("/workflow/search/WFSuperviseSignature.jsp?isclose=1");

%>