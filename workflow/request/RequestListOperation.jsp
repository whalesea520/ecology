<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.mobile.webservices.workflow.bill.BatchSubmitAction"%>
<%@ page import="weaver.general.Util,java.net.*,weaver.workflow.field.FieldComInfo"%>
<%@ page import="java.util.*" %>
<%@ page import="weaver.WorkPlan.WorkPlanLogMan" %>
<%@ page import="java.text.DecimalFormat" %>
<%@ page import="weaver.general.*" %>
<%@ page import="weaver.workflow.request.RequestManager" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.general.GCONST"%>
<%@page import="weaver.hrm.attendance.domain.*"%>
<%@page import="weaver.workflow.request.RequestOperationLogManager"%>
<%@page import="weaver.workflow.request.RequestOperationLogManager.RequestOperateEntityTableNameEnum"%>
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page" />
<jsp:useBean id="DocManager" class="weaver.docs.docs.DocManager" scope="page" />
<jsp:useBean id="WorkPlanViewer" class="weaver.WorkPlan.WorkPlanViewer" scope="page"/>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="HrmScheduleDiffUtil" class="weaver.hrm.report.schedulediff.HrmScheduleDiffUtil" scope="page"/>
<jsp:useBean id="HrmAnnualManagement" class="weaver.hrm.schedule.HrmAnnualManagement" scope="page"/>
<jsp:useBean id="HrmPaidSickManagement" class="weaver.hrm.schedule.HrmPaidSickManagement" scope="page"/>
<jsp:useBean id="HrmPaidLeaveManager" class="weaver.hrm.attendance.manager.HrmPaidLeaveManager" scope="page"/>
<jsp:useBean id="Requestlog" class="weaver.workflow.request.RequestLog" scope="page"/>
<jsp:useBean id="basebean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="fnaBudgetControl" class="weaver.fna.maintenance.FnaBudgetControl" scope="page" />

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%

/*用户验证*/
User user = HrmUserVarify.getUser (request , response) ;
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
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

String src = "submit";
String iscreate = "0";
int isremark = 0;
//添加支持批注内容从前台传递

String remark = Util.null2String(request.getParameter("remark"));
remark = remark.replaceAll("\\r\\n", "<br>");
remark = remark.replaceAll("\\r", "<br>");
remark = remark.replaceAll("\\n", "<br>");

if(remark.equals("")) {
	remark = Util.null2String(request.getAttribute("remark"));
}

if(remark.equals("")) remark = "\n"+username+" "+currentdate+" "+currenttime;
String workflowtype = "";
int formid = -1;
int isbill = -1;
int billid = -1;
String messageType = "";
int nodeid = -1;
String nodetype = "";
String requestname = "";
String requestlevel = "";

//modify by xhheng @20050524 for TD 2023
String requestidlist=Util.null2String(request.getParameter("multiSubIds"));
String wfid = Util.null2String(request.getParameter("workflowid"));
String wftypes = "";

String method = Util.null2String(request.getParameter("method"));
String wftype=Util.null2String(request.getParameter("wftype"));
int flowAll=Util.getIntValue(Util.null2String(request.getParameter("flowAll")), 0);
int flowNew=Util.getIntValue(Util.null2String(request.getParameter("flowNew")), 0);
String viewcondition = Util.null2String(request.getParameter("viewcondition"));
String [] requestids=Util.TokenizerString2(requestidlist,",");


//对应一人多岗批量提交无法提交次账号流程的问题
String belongtoUseridList = request.getParameter("belongtoUserids");
String [] belongtoUserids=Util.TokenizerString2(belongtoUseridList,",");

for (int i=0; i<requestids.length; i++){
    String f_weaver_belongto_userid = "";
    if(i < belongtoUserids.length){
        f_weaver_belongto_userid = belongtoUserids[i];
    }

    //如果使用次账号，则使用次账号登录
    if(f_weaver_belongto_userid != null && f_weaver_belongto_userid != "" && !f_weaver_belongto_userid.equals(user.getUID())){
        user = HrmUserVarify.getUser (request , response,f_weaver_belongto_userid,"0") ;
        userid = user.getUID();
    }else{
        user = HrmUserVarify.getUser (request , response) ;
        userid = user.getUID();
    }
    //用户验证
    if(user==null) {
        response.sendRedirect("/login/Login.jsp");
        return;
    }
    
    RequestManager = new RequestManager();
    int requestid = Util.getIntValue(requestids[i],-1) ;
    
     /*----------xwj for td3098 20051202 begin -----*/
    src = "submit";
    isremark = 0;
    RecordSet.executeSql("select min(isremark) from workflow_currentoperator where requestid = " + requestid + " and userid = "+user.getUID());
    if(RecordSet.next()){
    int isremarkCheck = RecordSet.getInt(1);
    if(isremarkCheck==1){
    src = "save";
    isremark = 1;
    }
    }
    
    RecordSet.executeSql("select isremark,isreminded,preisremark,id,groupdetailid,nodeid,(CASE WHEN isremark=9 THEN '7.5' ELSE isremark END) orderisremark from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" order by orderisremark,id ");
    boolean istoManagePage=false;   //add by xhheng @20041217 for TD 1438
    while(RecordSet.next())	{
        String t_isremark = Util.null2String(RecordSet.getString("isremark")) ;
        int tmpnodeid=Util.getIntValue(RecordSet.getString("nodeid"));
        //modify by mackjoe at 2005-09-29 td1772 转发特殊处理，转发信息本人未处理一直需要处理即使流程已归档
        if( t_isremark.equals("1")||t_isremark.equals("5") || t_isremark.equals("7")|| t_isremark.equals("9") ||(t_isremark.equals("0")  && !nodetype.equals("3")) ) {
          //modify by xhheng @20041217 for TD 1438
          if (t_isremark.equals("9")) {
              isremark = 9;
          }
          break;
        }
    }

    
    //判断当前流程是否还为当前操作者的待办事宜
    //判断当前流程是否还为当前操作者的待办事宜
    if(RecordSet.getDBType().equals("sqlserver")){
	    RecordSet.executeSql("select t1.requestid from workflow_requestbase t1, workflow_currentoperator t2 " +
		"where t1.requestid = t2.requestid and t2.userid = "+user.getUID()+" and t2.usertype = 0 and (isnull(t1.currentstatus, -1) = -1 or (isnull(t1.currentstatus, -1) = 0 and t1.creater = "+user.getUID()+")) "+
		"and t2.isremark in ('0', '1', '5', '8', '9', '7') and t2.islasttimes = 1 and t1.requestid = " + requestid);
	    if(!RecordSet.next()){
	    	continue;
	    }
    }else{
	    RecordSet.executeSql("select t1.requestid from workflow_requestbase t1, workflow_currentoperator t2 " +
   		"where t1.requestid = t2.requestid and t2.userid = "+user.getUID()+" and t2.usertype = 0 and (nvl(t1.currentstatus, -1) = -1 or (nvl(t1.currentstatus, -1) = 0 and t1.creater = "+user.getUID()+")) "+
   		"and t2.isremark in ('0', '1', '5', '8', '9', '7') and t2.islasttimes = 1 and t1.requestid = " + requestid);
   	    if(!RecordSet.next()){
   	    	continue;
   	    }
    }
    //System.out.println("2:流程" + i + "时间:" + (new Date().getTime() - d1.getTime()));
    /*----------xwj for td3098 20051202 end -----*/
    
    int workflowid=-1;

    if(requestid!=-1 ){
    boolean isStart = false;
    int currentnodeid = 0 ;
    RecordSet.executeSql("select currentnodeid,currentnodetype,requestname,requestlevel,workflowid,status from workflow_requestbase where requestid="+requestid);
    if(RecordSet.next()){
      requestname = RecordSet.getString("requestname");
      requestlevel = RecordSet.getString("requestlevel");
      workflowid = RecordSet.getInt("workflowid");
      currentnodeid = RecordSet.getInt("currentnodeid");
      isStart = (RecordSet.getString("status")!=null && !"".equals(RecordSet.getString("status")));
    }
    //System.out.println("3:流程" + i + "时间:" + (new Date().getTime() - d1.getTime()));
    nodeid=WFLinkInfo.getCurrentNodeid(requestid,userid,Util.getIntValue(logintype,1));               //节点id
    nodetype=WFLinkInfo.getNodeType(nodeid);         //节点类型  0:创建 1:审批 2:实现 3:归档    
    boolean isTrack = true;
    RecordSet.executeSql("select workflowtype,formid,isbill,messageType,isModifyLog from workflow_base where id="+workflowid);
    if(RecordSet.next()){
      workflowtype = RecordSet.getString("workflowtype");
      formid = RecordSet.getInt("formid");
      isbill = RecordSet.getInt("isbill");
      //billid = RecordSet.getInt("formid");
      messageType = RecordSet.getString("messageType");
      isTrack = (RecordSet.getString("ismodifylog")!=null && "1".equals(RecordSet.getString("ismodifylog")));
    }
    //System.out.println("4:流程" + i + "时间:" + (new Date().getTime() - d1.getTime()));
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
	//System.out.println("5:流程" + i + "时间:" + (new Date().getTime() - d1.getTime()));
    if( src.equals("") || workflowid == -1 || formid == -1 || isbill == -1 || nodeid == -1 || nodetype.equals("") ) {
        response.sendRedirect("/notice/RequestError.jsp");
        return ;
    }

    if (isremark == 9) {
        
        RequestOperationLogManager rolm = new RequestOperationLogManager(requestid);
        int optLogid = -1;
        //强制收回
        int wfcuroptid = -1;
        RecordSet.executeSql("select id from workflow_currentoperator where requestid=" + requestid + " and userid=" + userid + " and usertype=" + usertype + " and isremark=9");
        if (RecordSet.next()) {
            wfcuroptid = Util.getIntValue(RecordSet.getString(1));
            optLogid = rolm.getOptLogID(RequestOperationLogManager.RequestOperateEntityTableNameEnum.CURRENTOPERATOR.getId(), wfcuroptid, 0);
        }
        
        char flag = Util.getSeparator();
       	RecordSet.executeProc("workflow_CurOpe_UbySendNB", "" + requestid + flag + userid + flag + usertype+flag+isremark);
       	
        String isfeedback="";
        String isnullnotfeedback="";    
        RecordSet.executeSql("select isfeedback,isnullnotfeedback from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
        if(RecordSet.next()){
        	isfeedback=Util.null2String(RecordSet.getString("isfeedback"));
            isnullnotfeedback=Util.null2String(RecordSet.getString("isnullnotfeedback"));
        }
        
        String ifchangstatus=Util.null2String(basebean.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));
        if (!ifchangstatus.equals("")&&isfeedback.equals("1")&&((isnullnotfeedback.equals("1")&&!Util.replace(remark, "\\<script\\>initFlashVideo\\(\\)\\;\\<\\/script\\>", "", 0, false).equals(""))||!isnullnotfeedback.equals("1"))){
            RecordSet.executeSql("update workflow_currentoperator set viewtype =-1  where needwfback='1' and requestid=" + requestid + " and userid<>" + userid + " and viewtype=-2");

        }
        String curnodetype = "";
        RecordSet.executeSql("select currentnodetype from workflow_Requestbase where requestid="+requestid);
        if(RecordSet.next()) curnodetype = Util.null2String(RecordSet.getString(1));
        if(curnodetype.equals("3"))//归档流程转发后，转发人或抄送人提交后到办结事宜。

        	RecordSet.executeSql("update workflow_currentoperator set iscomplete=1 where userid="+userid+" and usertype="+usertype+" and requestid="+requestid);        

        //Requestlog.setRequest(fu) ;
        Requestlog.saveLog(workflowid,requestid,nodeid,"9",remark,user) ;
        
        //抄送需要提交  时， 添加 强制收回支持
        RecordSet.executeSql("select logid from workflow_requestlog where requestid = " + requestid + " and nodeid = " + nodeid + " and operator=" + user.getUID() + " and operatortype=" + usertype + " and logtype = '9' order by operatedate, operatetime");
        if (RecordSet.next()) {
            int newlogid = RecordSet.getInt(1);
            if (newlogid > 0) {
                //向之前的日志中添加本条提交的记录， 方便在强制收回的时候能够收回
                rolm.addDetailLog(optLogid, RequestOperationLogManager.RequestOperateEntityTableNameEnum.REQUESTLOG.getId(), newlogid, 0, "", "", "");
            }
        }
        
        continue;
    }
    
	int requestKey = 0;
    RecordSet.executeSql("select id from workflow_currentoperator where requestid="+requestid+" and nodeid='"+nodeid+"' and userid="+userid+" and usertype="+usertype+" order by isremark,id");
    if(RecordSet.next()){
    	requestKey = RecordSet.getInt("id");
    }
    
    int lastnodeid = 0; // 上一次退回操作的节点id
    if(isremark == 0) {
	    String sql_isreject = " select a.nodeid lastnodeid, a.logtype from workflow_requestlog a, workflow_nownode b where a.requestid = b.requestid and a.destnodeid = b.nownodeid "
	    	+ " and b.requestid=" + requestid + " and a.destnodeid=" + nodeid + " and a.nodeid != " + nodeid + " order by a.logid desc";
	    RecordSet.executeSql(sql_isreject);
	    while(RecordSet.next()) {
	    	String logtype = Util.null2String(RecordSet.getString("logtype"));
	    	if("3".equals(logtype)) {
	    		lastnodeid = Util.getIntValue(Util.null2String(RecordSet.getString("lastnodeid")), 0);
	    		break;
	    	}
	    	if("0".equals(logtype) || "2".equals(logtype) || "e".equals(logtype) || "i".equals(logtype) || "j".equals(logtype)){
	    		break;
	    	}
	    }
	    if(lastnodeid != 0&&!new weaver.workflow.request.WFLinkInfo().isCanSubmitToRejectNode(requestid,currentnodeid,lastnodeid)){
	    	lastnodeid = 0 ;
	    }
	    if(lastnodeid != 0) {
	    	String isSubmitDirectNode = ""; // 上一次退回操作的节点是否启用退回后再提交直达本节点
	    	RecordSet.executeSql("select * from workflow_flownode where workflowid=" + workflowid + " and nodeid=" + lastnodeid);
	    	if(RecordSet.next()) {
	    		isSubmitDirectNode = Util.null2String(RecordSet.getString("isSubmitDirectNode"));
	    	}
	    	if(!"1".equals(isSubmitDirectNode)) { // 如果不启用
	    		lastnodeid = 0;
			}
	    }
    }
    
    //System.out.println("6:流程" + i + "时间:" + (new Date().getTime() - d1.getTime()));
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
	RequestManager.setSubmitToNodeid(lastnodeid);
    
    /**Start 批量提交时也必须做节点附加操作 by alan on 2009-04-23**/
    if(!src.equals("save")){
		try {
			 //由于objtype为"1: 节点自动赋值",不为"0 :出口自动赋值"，不用改变除状态外的文档相关信息，故可不用给user、clienIp、src赋值  fanggsh TD5121			
			weaver.workflow.request.RequestCheckAddinRules requestCheckAddinRules = new weaver.workflow.request.RequestCheckAddinRules();
			requestCheckAddinRules.resetParameter();
			//add by cyril on 2008-07-28 for td:8835 事务无法开启查询,只能传入
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
			requestCheckAddinRules.setRequestManager(RequestManager);
			requestCheckAddinRules.setUser(user);
			requestCheckAddinRules.checkAddinRules();
		} catch (Exception e) {
			response.sendRedirect("/notice/RequestError.jsp");
	        return ;
		}
	}
    //System.out.println("7:流程" + i + "时间:" + (new Date().getTime() - d1.getTime()));
    /**End 批量提交时也必须做节点附加操作 by alan on 2009-04-23**/
	//TD10974 处理流程批量提交的时候，文档、客户、资产、项目无法附权下一节点操作者的问题 Start
	int docRightByOperator=0;
	rs.execute("select docRightByOperator from workflow_base where id="+workflowid);
	if(rs.next()){
		docRightByOperator=Util.getIntValue(rs.getString("docRightByOperator"),0);
	}
	String maintable = "workflow_form";
	if (isbill == 1) {
		rs.execute("select tablename from workflow_bill where id = " + formid);
		if(rs.next()){
			maintable = Util.null2String(rs.getString("tablename"));
		}
		rs.executeProc("workflow_billfield_Select", formid + "");
	} else {
		rs.executeSql("select t2.fieldid,t2.fieldorder,t2.isdetail,t1.fieldlable,t1.langurageid from workflow_fieldlable t1,workflow_formfield t2 where t1.formid=t2.formid and t1.fieldid=t2.fieldid and (t2.isdetail<>'1' or t2.isdetail is null)  and t2.formid="+formid+"  and t1.langurageid="+user.getLanguage()+" order by t2.fieldorder");
	}	
	//System.out.println("8:流程" + i + "时间:" + (new Date().getTime() - d1.getTime()));
    ArrayList fieldidList = new ArrayList();
    ArrayList fieldnameList = new ArrayList();
    ArrayList fielddbtypeList = new ArrayList();
    ArrayList fieldhtmltypeList = new ArrayList();
    ArrayList fieldtypeList = new ArrayList();
    String fieldnames = "";
    String fieldid = "";
    String fieldname = "";
    String fielddbtype = "";
    String fieldhtmltype = "";
    String fieldtype = "";
    FieldComInfo fieldComInfo = new FieldComInfo();
    String hrmids = "";
    String crmids = "";
    String prjids = "";
    String docids = "";
    String cptids = "";
    boolean hasmanager=false;
    char separarorFlag = Util.getSeparator();
	while (rs.next()) {
		if (isbill == 1) {
			String viewtype = Util.null2String(rs.getString("viewtype"));   // 如果是单据的从表字段,不进行操作

			if (viewtype.equals("1")) continue;
			fieldid = Util.null2String(rs.getString("id"));
			fieldname = Util.null2String(rs.getString("fieldname"));
			fielddbtype = Util.null2String(rs.getString("fielddbtype"));
			fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
			fieldtype = Util.null2String(rs.getString("type"));
		} else {
			fieldid = Util.null2String(rs.getString(1));
			fieldname = Util.null2String(fieldComInfo.getFieldname(fieldid));
			fielddbtype = Util.null2String(fieldComInfo.getFielddbtype(fieldid));
			fieldhtmltype = Util.null2String(fieldComInfo.getFieldhtmltype(fieldid));
			fieldtype = Util.null2String(fieldComInfo.getFieldType(fieldid));
		}
        if(fieldname.toLowerCase().equals("manager")){
            hasmanager=true;
        }
		fieldidList.add(fieldid);
		fieldnameList.add(fieldname);
		fielddbtypeList.add(fielddbtype);
		fieldhtmltypeList.add(fieldhtmltype);
		fieldtypeList.add(fieldtype);
		fieldnames = fieldnames + fieldname + ",";
	}
	//System.out.println("9:流程" + i + "时间:" + (new Date().getTime() - d1.getTime()));
    if(hasmanager){
        String beagenter=""+userid;
        //获得被代理人
        RecordSet.executeSql("select agentorbyagentid from workflow_currentoperator where usertype=0 and isremark='0' and requestid="+requestid+" and userid="+userid+" and nodeid="+nodeid+" order by id desc");
        if(RecordSet.next()){
          int tembeagenter=RecordSet.getInt(1);
          if(tembeagenter>0) beagenter=""+tembeagenter;
        }
        String tmpmanagerid = ResourceComInfo.getManagerID(beagenter);
        rs2.executeSql("update " + maintable + " set manager="+tmpmanagerid+" where requestid=" + requestid);
    }
	if(fieldnames.length() > 0){
		fieldnames = fieldnames.substring(0, fieldnames.length()-1);
		rs2.execute("select " + fieldnames + " from " + maintable + " where requestid=" + requestid);
		if(rs2.next()){
			for(int j=0; j<fieldidList.size(); j++){
				fieldid = Util.null2String((String)fieldidList.get(j));
				fieldname = Util.null2String((String)fieldnameList.get(j));
				fielddbtype = Util.null2String((String)fielddbtypeList.get(j));
				fieldhtmltype = Util.null2String((String)fieldhtmltypeList.get(j));
				fieldtype = Util.null2String((String)fieldtypeList.get(j));
				if (fieldhtmltype.equals("3") && (fieldtype.equals("1") || fieldtype.equals("17"))) { // 人力资源字段
					String tempvalueid="";
					tempvalueid = Util.null2String(rs2.getString(fieldname));
					if (!tempvalueid.equals("")) hrmids += "," + tempvalueid;
				} else if (fieldhtmltype.equals("3") && (fieldtype.equals("7") || fieldtype.equals("18"))) {   // 客户字段
					String tempvalueid ="";
					tempvalueid = Util.null2String(rs2.getString(fieldname));
					if (!tempvalueid.equals("")) crmids += "," + tempvalueid;
				} else if (fieldhtmltype.equals("3") && (fieldtype.equals("8")|| fieldtype.equals("135"))) {                             // 项目字段
					String tempvalueid ="";
					tempvalueid = Util.null2String(rs2.getString(fieldname));
					if (!tempvalueid.equals("")) prjids += "," + tempvalueid;
				} else if (fieldhtmltype.equals("3") && (fieldtype.equals("9") || fieldtype.equals("37"))) {  // 文档字段
					String tempvalueid ="";
					tempvalueid = Util.null2String(rs2.getString(fieldname));
					if (!tempvalueid.equals("")) docids += "," + tempvalueid;
					//跟随文档关联人赋权

					if(docRightByOperator==1){
						//在Workflow_DocSource表中删除当前字段被删除的文档
						if (!tempvalueid.equals("")){
							rs1.execute("delete from Workflow_DocSource where requestid =" + requestid + " and fieldid =" + fieldid + " and docid not in (" + tempvalueid + ")");
						}else{
							rs1.execute("delete from Workflow_DocSource where requestid =" + requestid + " and fieldid =" + fieldid);
						}
						//在Workflow_DocSource表中添加当前字段新增加的文档
						String[] mdocid=Util.TokenizerString2(tempvalueid,",");
						for(int cx=0;cx<mdocid.length; cx++){
							if(mdocid[cx]!=null && !mdocid[cx].equals("")){
								rs1.executeProc("Workflow_DocSource_Insert",""+requestid + separarorFlag + nodeid + separarorFlag + fieldid + separarorFlag + mdocid[cx] + separarorFlag + userid + separarorFlag + "1");//由于usertype不一致，这里的usertype直接指定为1，只处理内部用户
							}
						}
					}
				} else if (fieldhtmltype.equals("3") && fieldtype.equals("23")) {                           // 资产字段
					String tempvalueid ="";
					tempvalueid = Util.null2String(rs2.getString(fieldname));
					if (!tempvalueid.equals("")) cptids += "," + tempvalueid;
				}
			}
			if (!hrmids.equals("")) hrmids = hrmids.substring(1);
			if (!crmids.equals("")) crmids = crmids.substring(1);
			if (!prjids.equals("")) prjids = prjids.substring(1);
			if (!docids.equals("")) docids = docids.substring(1);
			if (!cptids.equals("")) cptids = cptids.substring(1);
			RequestManager.setHrmids(hrmids);
			RequestManager.setCrmids(crmids);
			RequestManager.setPrjids(prjids);
			RequestManager.setDocids(docids);
			RequestManager.setCptids(cptids);
		}
	}
	//TD10974 End
	//System.out.println("10:流程" + i + "时间:" + (new Date().getTime() - d1.getTime()));
  if (formid != 180){
    boolean flowstatus = RequestManager.flowNextNode() ;
    //System.out.println("11:流程" + i + "时间:" + (new Date().getTime() - d1.getTime()));
    if (flowstatus) {
                //added by mackjoe at 2007-01-10 TD5567
                //增加文档,项目,客户批量审批处理
                if (RequestManager.getNextNodetype().equals("3") && isbill == 1) {
                    //文档
                    if (formid == 28) {
                        RecordSet.executeSql("update bill_Approve set status='1' where requestid=" + requestid);
                        RecordSet.executeSql("select approveid from bill_Approve where requestid=" + requestid);
                        if(RecordSet.next()){
							String approveid=Util.null2String(RecordSet.getString("approveid"));
							int intapproveid=Util.getIntValue(approveid,0);
							RecordSet.executeSql("select max(b.id) from DocDetail a,DocDetail b where a.docEditionId=b.docEditionId and a.docEditionId>0 and a.id="+intapproveid);
							if(RecordSet.next()){
								intapproveid=Util.getIntValue(RecordSet.getString(1),intapproveid);
								if(intapproveid>0){
									approveid=""+intapproveid;
								}
							}
                            DocManager.approveDocFromWF("approve", approveid, currentdate, currenttime, userid + "");
                        }
                    }
                    //项目
                    if (formid == 74) {
                        RecordSet.executeSql("select approveid from Bill_ApproveProj where requestid=" + requestid);
                        if(RecordSet.next()){
                            char flag = 2 ;
                            String approveid=RecordSet.getString("approveid");
                            RecordSet.executeProc("Prj_Plan_Approve",approveid);
                            String tmpsql="update prj_taskprocess set isactived=2 where prjid="+approveid ;
                            RecordSet.executeSql(tmpsql);
                            tmpsql = "update Prj_ProjectInfo set status = 5 where id = "+ approveid;
                            RecordSet.executeSql(tmpsql);

                            //更新工作计划中该项目的经理的时间Begin
                            String begindate01 = "";
                            String enddate01 = "";

                            RecordSet.executeProc("Prj_TaskProcess_Sum",""+approveid);
                            if(RecordSet.next() && !RecordSet.getString("workday").equals("")){

                                if(!RecordSet.getString("begindate").equals("x")) begindate01 = RecordSet.getString("begindate");
                                if(!RecordSet.getString("enddate").equals("-")) enddate01 = RecordSet.getString("enddate");

                            }
                            if (!begindate01.equals("")){
                                RecordSet.executeSql("update workplan set status = '0',begindate = '" + begindate01 + "',enddate = '" + enddate01 + "' where type_n = '2' and projectid = '" + approveid + "' and taskid = -1");
                            }
                            //更新工作计划中该项目的经理的时间End

                            //添加工作计划Begin
                            String para = "";
                            String workid = "";
                            String manager="";
                            String TaskID="";
                            RecordSet.executeProc("Prj_ProjectInfo_SelectByID",approveid);
                            if (RecordSet.next()){
                                manager=RecordSet.getString("manager");
                            }

                            tmpsql = "SELECT * FROM Prj_TaskProcess WHERE prjid = " + approveid + " and isdelete<>'1' order by id";
                            RecordSet.executeSql(tmpsql);

                            while (RecordSet.next()) {
                                TaskID = RecordSet.getString("id");
                                para = "2"; //type_n
                                para +=flag+Util.toScreen(RecordSet.getString("subject"),user.getLanguage());
                                para +=flag+Util.toScreen(RecordSet.getString("hrmid"),user.getLanguage());
                                para +=flag+Util.toScreen(RecordSet.getString("begindate"),user.getLanguage());
                                para +=flag+""; //BeginTime
                                para +=flag+Util.toScreen(RecordSet.getString("enddate"),user.getLanguage());
                                para +=flag+""; //EndTime
                                para +=flag+Util.toScreen(RecordSet.getString("content"),user.getLanguage());
                                para +=flag+"0";//requestid
                                para +=flag+approveid;//projectid
                                para +=flag+"0";//crmid
                                para +=flag+"0";//docid
                                para +=flag+"0";//meetingid
                                para +=flag+"0";//status;
                                para +=flag+"1";//isremind;
                                para +=flag+"0";//waketime;
                                para +=flag+manager;//createid;
                                para +=flag+currentdate;
                                para +=flag+currenttime;
                                para +=flag+"0";
                                para += flag + "0";			//taskid
                                para += flag + "1";	//urgent level
                                para += flag + "0";	//agentId level

                                RecordSet1.executeProc("WorkPlan_Insert",para);
                                if (RecordSet1.next()) workid = RecordSet1.getString("id");

                                //write "add" of view log
                                String[] logParams = new String[] {workid,
                                                            WorkPlanLogMan.TP_CREATE,
                                                            String.valueOf(userid),
                                                            request.getRemoteAddr()};
                                WorkPlanLogMan logMan = new WorkPlanLogMan();
                                logMan.writeViewLog(logParams);
                                //end

                                RecordSet1.executeSql("update workplan set taskid = " + TaskID + " where id =" + workid);
                                WorkPlanViewer.setWorkPlanShareById(workid);
                            }
                            //添加工作计划End
                        }
                    }
                    //客户
                    if (formid == 79) {
                        String sql= "select approveid,approvevalue,approvetype from bill_ApproveCustomer where requestid="+requestid;
                        RecordSet.executeSql(sql);
                        String approveid="";
                        String approvetype="";
                        String approvevalue="";
                        if(RecordSet.next()){
                            approveid=RecordSet.getString("approveid");
                            approvetype=RecordSet.getString("approvetype");
                            approvevalue = RecordSet.getString("approvevalue");
                        }
                        //更改单据的状态，1：已经归档

                        RecordSet.executeSql("update bill_ApproveCustomer set status=1 where requestid="+requestid);
                        RecordSet.executeProc("CRM_CustomerInfo_SelectByID",approveid);
                        RecordSet.first();
                        String statusTemp = RecordSet.getString("status");
                        String Manager2 = RecordSet.getString("manager");
                        String name = RecordSet.getString("name");
                        String ProcPara="";
                        char flag = 2 ;
                        String fieldName="";
                        if(approvetype.equals("1")){
                            ProcPara = approveid;
                            ProcPara += flag+approvevalue;
                            ProcPara += flag+"1";

                            RecordSet.executeProc("CRM_CustomerInfo_Approve",ProcPara);

                            ProcPara = approveid;
                            ProcPara += flag+"a";
                            ProcPara += flag+"0";
                            ProcPara += flag+"a";
                            ProcPara += flag+currentdate;
                            ProcPara += flag+currenttime;
                            ProcPara += flag+""+user.getUID();
                            ProcPara += flag+""+user.getLogintype();
                            ProcPara += flag+request.getRemoteAddr();
                            RecordSet.executeProc("CRM_Log_Insert",ProcPara);

                            fieldName = SystemEnv.getHtmlLabelName(23247,user.getLanguage());

                            ProcPara = approveid+flag+"1"+flag+"0"+flag+"0";
                            ProcPara += flag+fieldName+flag+currentdate+flag+currenttime+flag+statusTemp+flag+approvevalue;
                            ProcPara += flag+""+user.getUID()+flag+""+user.getLogintype()+flag+request.getRemoteAddr();
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
                            ProcPara += flag+"0";
                            ProcPara += flag+"p";
                            ProcPara += flag+currentdate;
                            ProcPara += flag+currenttime;
                            ProcPara += flag+""+user.getUID();
                            ProcPara += flag+""+user.getLogintype();
                            ProcPara += flag+request.getRemoteAddr();
                            RecordSet.executeProc("CRM_Log_Insert",ProcPara);

                            fieldName = SystemEnv.getHtmlLabelName(23249,user.getLanguage());

                            ProcPara = approveid+flag+"1"+flag+"0"+flag+"0";
                            ProcPara += flag+fieldName+flag+currentdate+flag+currenttime+flag+statusTemp+flag+approvevalue;
                            ProcPara += flag+""+user.getUID()+flag+""+user.getLogintype()+flag+request.getRemoteAddr();
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
                PoppupRemindInfoUtil.updatePoppupRemindInfo(userid, 0, (logintype).equals("1") ? "0" : "1", requestid); //add by sean for td3999
int takisremark = -1;
int handleforwardid = -1;
String zsql = "select * from workflow_currentoperator where requestid= "+ requestid + "and nodeid = "+ nodeid +" and userid = "+ userid;
RecordSet.executeSql(zsql);
if(RecordSet.next()){
takisremark = Util.getIntValue(RecordSet.getString("takisremark"));
handleforwardid = Util.getIntValue(RecordSet.getString("handleforwardid"));
}
if(takisremark==2){
  
RecordSet.executeSql("update workflow_requestlog set logtype='b' where  requestid= "+ requestid + " and nodeid = "+ nodeid +" and operator = "+ userid);
}
if(handleforwardid>0){
RecordSet.executeSql("update workflow_requestlog set logtype='j' where  requestid= "+ requestid + "and nodeid = "+ nodeid +" and operator = "+ userid);
}
if(takisremark!=2 && handleforwardid<0){

  boolean logstatus = RequestManager.saveRequestLog();
}

String taksql = "select * from workflow_currentoperator where requestid= "+ requestid + "and nodeid = "+ nodeid +" and userid = "+ userid +" and takisremark = 2";
RecordSet.executeSql(taksql);
if(RecordSet.next()){
			String taksql1 = "select count(*) as cou from workflow_currentoperator where requestid= "+ requestid + "and nodeid = "+ nodeid +" and takisremark = 2 and isremark=1";
			RecordSet.executeSql(taksql1);
		if(RecordSet.next()){
			if(RecordSet.getInt("cou")==0){
				String taksql2 = "select * from workflow_currentoperator where requestid= "+ requestid + "and nodeid = "+ nodeid +" and isremark = 0 and takisremark = -2";
RecordSet.executeSql(taksql2);
if(RecordSet.next()){
	
String uptaksql2 = "update workflow_currentoperator set takisremark=0 where requestid= "+ requestid + "and nodeid = "+ nodeid +" and isremark = 0 and takisremark = -2";
RecordSet.executeSql(uptaksql2);
				}
			}
		}
}
/*
				RecordSet.execute("select * from workflow_currentoperator where requestid = " + requestid + "and workflowid = " +workflowid+ "and userid = "+ userid + "and nodeid = "+nodeid+"and takisremark = 2 ");
				if(RecordSet.next()){
				int tkisremark = RecordSet.getInt("isremark");
				if(tkisremark ==2){
				RecordSet.execute("update workflow_currentoperator set takisremark = 0 where requestid = " + requestid + "and workflowid = " +workflowid+  "and nodeid = "+nodeid+"and takisremark = -2 ");
				}
				}*/
				
            }
    //System.out.println("12:流程" + i + "时间:" + (new Date().getTime() - d1.getTime()));
  }
  
  //请假申请单
  if (formid == 180 && isbill == 1) {
	 
	  String sql = "";
	  int urger=Util.getIntValue((String)session.getAttribute(user.getUID()+"_"+requestid+"urger"),0);
	  HrmScheduleDiffUtil.setUser(user);
	  HrmScheduleDiffUtil.setForSchedule(true);
	
	  //add by chengfeng.han 2011-7-28 td20647 
	  int isagentCreater = Util.getIntValue((String)session.getAttribute(workflowid+"isagent"+user.getUID()));
	  int beagenter = Util.getIntValue((String)session.getAttribute(workflowid+"beagenter"+user.getUID()),0);
	  RequestManager.setIsagentCreater(isagentCreater);
	  RequestManager.setBeAgenter(beagenter);
	  //end

      sql = "select resourceid from Bill_BoHaiLeave where requestid = " + requestid;
      RecordSet.executeSql(sql);
      RecordSet.next();
      String workflowcreater = RecordSet.getString("resourceid");    

      sql = "select * from Bill_BoHaiLeave where requestid = " + requestid;
      RecordSet.executeSql(sql);
      RecordSet.next();
    
      if("submit".equalsIgnoreCase(src) && RequestManager.getIsremark()==0){
  		//TD15253 控制结束日期（时间）不能在开始日期（时间之前） Start
  	
  	    String fromDateAll = Util.null2String(RecordSet.getString("fromDate")).trim();
  	    String fromTimeAll = Util.null2String(RecordSet.getString("fromTime")).trim();
  	    String toDateAll = Util.null2String(RecordSet.getString("toDate")).trim();
  	    String toTimeAll = Util.null2String(RecordSet.getString("toTime")).trim();
  	    if(!"".equals(fromDateAll) && !"".equals(toDateAll)){//开始、结束日期都不能为空，否则不判断
  	    	if("".equals(fromTimeAll)){
  	    		fromTimeAll = "00:00:00";
  	    	}else if(fromTimeAll.length() == 5){
  	    		fromTimeAll = fromTimeAll + ":00";
  	    	}
  	    	if("".equals(toTimeAll)){
  	    		toTimeAll = "23:59:59";
  	    	}else if(toTimeAll.length() == 5){
  	    		toTimeAll = toTimeAll + ":00";
  	    	}
  	    	
  	    	long leaveTimesAll = TimeUtil.timeInterval(fromDateAll+" "+fromTimeAll, toDateAll+" "+toTimeAll);
  	    	
  	    	if(leaveTimesAll < 0){//结束日期（时间）在开始之前
  	    		basebean.writeLog("requestid="+requestid+"&message=24569");
                continue;

  	    	}
  	    }
      }
  	//TD15253 控制结束日期（时间）不能在开始日期（时间之前） End

    String leaveType = RecordSet.getString("newLeaveType");
    String otherLeaveType = RecordSet.getString("otherLeaveType");
    ArrayList annualsql = new ArrayList();//存放销假的sql语句
    float leavedaysAll = 0;//存放本次请假天数，用于更新Bill_BoHaiLeave
//如果用户请假类型为年假，则检查，年假时间是否大于可请年假时间，如果大于则不允许提交
if(src.equals("submit")&&!nodetype.equals("3")&&leaveType.equals(String.valueOf(HrmAttVacation.L6))) {
    
    String fromDate = RecordSet.getString("fromDate");
    String fromTime = RecordSet.getString("fromTime");
    String toDate = RecordSet.getString("toDate");
    String toTime = RecordSet.getString("toTime"); 
    
    String creater = RecordSet.getString("resourceid");
    
	int subcompanyid1=user.getUserSubCompany1();
    RecordSet.executeSql("select b.subcompanyid1 from hrmresource a,hrmdepartment b where a.departmentid=b.id and a.id="+creater);
    if(RecordSet.next()){
		subcompanyid1=Util.getIntValue(RecordSet.getString("subcompanyid1"),-1);
		if(subcompanyid1<=0){
			subcompanyid1=user.getUserSubCompany1();
		}
	}

      //本次请假时间
      String leavetime = HrmScheduleDiffUtil.getTotalWorkingDays(fromDate,fromTime,toDate,toTime,subcompanyid1);
      
      Calendar today = Calendar.getInstance() ; 
      String thisyear = Util.add0(today.get(Calendar.YEAR),4);
      String lastyear = Util.add0(today.get(Calendar.YEAR)-1,4);
      //可请年假总时间
      String allannualtime = "";
      //上一年剩余年假天数
      String lastyearannualtime = "";
      //今天剩余年假天数
      String thisyearannualtime = "";
      
      try{
          String tempvalue = HrmAnnualManagement.getUserAannualInfo(workflowcreater,currentdate);
          thisyearannualtime = Util.TokenizerString2(tempvalue,"#")[0];
          lastyearannualtime = Util.TokenizerString2(tempvalue,"#")[1];
          allannualtime = Util.TokenizerString2(tempvalue,"#")[2];    
      }catch(Exception e){
          
      }
      
      float leavedays = Util.getFloatValue(leavetime,0);//本次请假时间
      leavedaysAll = leavedays;
      float allannualdays = Util.getFloatValue(allannualtime,0);//用户剩余年假时间
      float lastyearannualdays = Util.getFloatValue(lastyearannualtime,0);
      float thisyearannualdays = Util.getFloatValue(thisyearannualtime,0);
      DecimalFormat   df   =   new   DecimalFormat("0.##");
         
      if(allannualdays<leavedays){
         //response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message=182");
         out.print("<script>wfforward('/workflow/request/ViewRequest.jsp?requestid="+requestid+"&message=182');</script>");
         return ;
      }else{
         //销假sql，先请上一年年假，再请当前年年假
         if(leavedays<lastyearannualdays){
           sql = "update hrmannualmanagement set annualdays = (annualdays - " + leavedays + ") where annualyear = " + lastyear + " and resourceid = " + creater;     
           annualsql.add(sql);
         }else{
           sql = "update hrmannualmanagement set annualdays = 0 where annualyear = " + lastyear + " and resourceid = " + creater;
           annualsql.add(sql);
           sql = "update hrmannualmanagement set annualdays = (annualdays - " + Util.getFloatValue(df.format(leavedays - lastyearannualdays),0) + ") where annualyear = " + thisyear + " and resourceid = " + creater;
           annualsql.add(sql);
         }                   
      }
}else if(src.equals("submit")&&!nodetype.equals("3")&&leaveType.equals(String.valueOf(HrmAttVacation.L12))) {//带薪病假
    
    String fromDate = RecordSet.getString("fromDate");
    String fromTime = RecordSet.getString("fromTime");
    String toDate = RecordSet.getString("toDate");
    String toTime = RecordSet.getString("toTime"); 
    
    String creater = RecordSet.getString("resourceid");

  	int subcompanyid1=user.getUserSubCompany1();
      RecordSet.executeSql("select b.subcompanyid1 from hrmresource a,hrmdepartment b where a.departmentid=b.id and a.id="+creater);
      if(RecordSet.next()){
  		subcompanyid1=Util.getIntValue(RecordSet.getString("subcompanyid1"),-1);
  		if(subcompanyid1<=0){
  			subcompanyid1=user.getUserSubCompany1();
  		}
  	}	
      //本次请假时间
      String leavetime = HrmScheduleDiffUtil.getTotalWorkingDays(fromDate,fromTime,toDate,toTime,subcompanyid1);
      
      Calendar today = Calendar.getInstance() ; 
      
      String thisyear = Util.add0(today.get(Calendar.YEAR),4);
      String lastyear = Util.add0(today.get(Calendar.YEAR)-1,4);
    //可请带薪病假总时间
      String allpsltime = "";
      //上一年剩余带薪病假天数
      String lastyearpsltime = "";
      //今年剩余带薪病假天数
      String thisyearpsltime = "";
      
      try{
          String tempvalue = HrmPaidSickManagement.getUserPaidSickInfo(workflowcreater,currentdate);
          thisyearpsltime = Util.TokenizerString2(tempvalue,"#")[0];
          lastyearpsltime = Util.TokenizerString2(tempvalue,"#")[1];
          allpsltime = Util.TokenizerString2(tempvalue,"#")[2];    
      }catch(Exception e){
          
      }
      
      float leavedays = Util.getFloatValue(leavetime,0);//本次请假时间
      leavedaysAll = leavedays;
      float allpsldays = Util.getFloatValue(allpsltime,0);//用户剩余带薪病假时间
      float lastyearpsldays = Util.getFloatValue(lastyearpsltime,0);
      float thisyearpsldays = Util.getFloatValue(thisyearpsltime,0);
      DecimalFormat   df   =   new   DecimalFormat("0.##");
         
      if(allpsldays<leavedays){
          basebean.writeLog("requestid="+requestid+"&message=183");
          continue;
      }else{
          //销假sql，先请上一年带薪病假，再请当前年带薪病假
          if(leavedays<lastyearpsldays){
            sql = "update HrmPSLManagement set psldays = (psldays - " + leavedays + ") where pslyear = " + lastyear + " and resourceid = " + creater;
            annualsql.add(sql);
          }else{
            sql = "update HrmPSLManagement set psldays = 0 where pslyear = " + lastyear + " and resourceid = " + creater;
            annualsql.add(sql);
            sql = "update HrmPSLManagement set psldays = (psldays - " + Util.getFloatValue(df.format(leavedays - lastyearpsldays),0) + ") where pslyear = " + thisyear + " and resourceid = " + creater;
            annualsql.add(sql);
          }                   
      }
  }else{//计算请假天数
  	String fromDate = RecordSet.getString("fromDate");
  	String fromTime = RecordSet.getString("fromTime");
  	String toDate = RecordSet.getString("toDate");
  	String toTime = RecordSet.getString("toTime");
      
  	String resourceId = RecordSet.getString("resourceid");
      String sqlHrmResource = "select locationid from HrmResource where id ="+resourceId;
  	RecordSet.executeSql(sqlHrmResource);
  	String locationid = "";
  	if (RecordSet.next()){
  	   locationid=RecordSet.getString("locationid");
  	}
  	String sqlHrmLocations = "select countryid from HrmLocations where id="+locationid;
  	RecordSet.executeSql(sqlHrmLocations);
  	String countryId = "";
  	if (RecordSet.next()){
  	   countryId =  RecordSet.getString("countryid");
  	}
	User tmpUser = User.getUser(Util.getIntValue(resourceId),0);
	HrmScheduleDiffUtil.setUser(tmpUser);
  	HrmScheduleDiffUtil.setForSchedule(true);

  	int subcompanyid1=user.getUserSubCompany1();
      RecordSet.executeSql("select b.subcompanyid1 from hrmresource a,hrmdepartment b where a.departmentid=b.id and a.id="+resourceId);
      if(RecordSet.next()){
  		subcompanyid1=Util.getIntValue(RecordSet.getString("subcompanyid1"),-1);
  		if(subcompanyid1<=0){
  			subcompanyid1=user.getUserSubCompany1();
  		}
  	}
  	//本次请假时间
  	String leavetime = HrmScheduleDiffUtil.getTotalWorkingDays(fromDate,fromTime,toDate,toTime,subcompanyid1);
  	float leavedays = Util.getFloatValue(leavetime,0);//本次请假时间
      leavedaysAll = leavedays;
  }
  if(("submit".equalsIgnoreCase(src)||"save".equalsIgnoreCase(src)) && RequestManager.getIsremark()==0){
  	sql = "update Bill_BoHaiLeave set leaveDays="+leavedaysAll+" where requestid="+requestid;
  	RecordSet.executeSql(sql);
  }
  boolean flowstatus = RequestManager.flowNextNode() ;
  if( !flowstatus ) {
          basebean.writeLog("requestid="+requestid+"&message=2");
          continue;
  }

  //如果流程归档了，则使年假生效，在用户可请年假减去当前本次请的年假
  sql = "select currentnodetype from workflow_requestbase where requestid = " + requestid;
  RecordSet.executeSql(sql);
  RecordSet.next();
  String currentnodetype = RecordSet.getString("currentnodetype");

  if(src.equals("submit")&&!nodetype.equals("3")&&currentnodetype.equals("3")) {
      
      sql = "select * from Bill_BoHaiLeave where requestid = " + requestid;
      RecordSet.executeSql(sql);
      RecordSet.next();
      String fromDate = RecordSet.getString("fromDate");
      String fromTime = RecordSet.getString("fromTime");
      String toDate = RecordSet.getString("toDate");
      String toTime = RecordSet.getString("toTime"); 
      String creater = RecordSet.getString("resourceid");

  	int subcompanyid1=user.getUserSubCompany1();
      RecordSet.executeSql("select b.subcompanyid1 from hrmresource a,hrmdepartment b where a.departmentid=b.id and a.id="+creater);
      if(RecordSet.next()){
  		subcompanyid1=Util.getIntValue(RecordSet.getString("subcompanyid1"),-1);
  		if(subcompanyid1<=0){
  			subcompanyid1=user.getUserSubCompany1();
  		}
  	}	
      //本次请假时间
      String leavetime = HrmScheduleDiffUtil.getTotalWorkingDays(fromDate,fromTime,toDate,toTime,subcompanyid1);
      
      Calendar today = Calendar.getInstance() ; 
      
      String thisyear = Util.add0(today.get(Calendar.YEAR),4);
      String lastyear = Util.add0(today.get(Calendar.YEAR)-1,4);
      
      float leavedays = Util.getFloatValue(leavetime,0);//本次请假时间
      DecimalFormat   df   =   new   DecimalFormat("0.##");
      
    //通过HrmAnnualLeaveInfo的status进行年假的记录1代表未进入年假 2代表准备扣减年假 3代表销上一年年假 4代表先销上一年年假，再销当前年年假
      sql = "delete from HrmAnnualLeaveInfo where requestid = " + requestid;
      RecordSet.executeSql(sql);
      sql = "insert into HrmAnnualLeaveInfo (requestid,resourceid,startdate,starttime,enddate,endtime,leavetime,occurdate,leavetype,otherleavetype,status) values ("+requestid+","+creater+",'"+fromDate+"','"+fromTime+"','"+toDate+"','"+toTime+"','"+leavedays+"','"+currentdate+"','"+leaveType+"','"+otherLeaveType+"',1)";
      RecordSet.executeSql(sql);
      
    RecordSet.executeSql("select * from Bill_BoHaiLeave where requestid = "+requestid);
    RecordSet.next();
    String confirmNewLeavetype = RecordSet.getString("newLeaveType");
    if(!leaveType.equals(confirmNewLeavetype)) leaveType = confirmNewLeavetype;
    if(leaveType.equals(String.valueOf(HrmAttVacation.L6))){
          //可请年假总时间
          String allannualtime = "";
          //上一年剩余年假天数
          String lastyearannualtime = "";
          //今天剩余年假天数
          String thisyearannualtime = "";
          
          try{
              String tempvalue = HrmAnnualManagement.getUserAannualInfo(workflowcreater,currentdate);
              thisyearannualtime = Util.TokenizerString2(tempvalue,"#")[0];
              lastyearannualtime = Util.TokenizerString2(tempvalue,"#")[1];
              allannualtime = Util.TokenizerString2(tempvalue,"#")[2];    
          }catch(Exception e){
              
          }
        RecordSet.executeSql("update HrmAnnualLeaveInfo set status=2 where requestid = " + requestid);
          float allannualdays = Util.getFloatValue(allannualtime,0);//用户剩余年假时间
          float lastyearannualdays = Util.getFloatValue(lastyearannualtime,0);
          float thisyearannualdays = Util.getFloatValue(thisyearannualtime,0);
        //销假sql，先销上一年年假，再销当前年年假
        if(leavedays<lastyearannualdays){
		RecordSet.executeSql("update HrmAnnualLeaveInfo set status=3 where requestid = " + requestid);
           sql = "update hrmannualmanagement set annualdays = (annualdays - " + leavedays + ") where annualyear = " + lastyear + " and resourceid = " + creater;     
           RecordSet.executeSql(sql);
        }else{
       	RecordSet.executeSql("update HrmAnnualLeaveInfo set status=4 where requestid = " + requestid);
           sql = "update hrmannualmanagement set annualdays = 0 where annualyear = " + lastyear + " and resourceid = " + creater;
           RecordSet.executeSql(sql);
           sql = "update hrmannualmanagement set annualdays = (annualdays - " + Util.getFloatValue(df.format(leavedays - lastyearannualdays),0) + ") where annualyear = " + thisyear + " and resourceid = " + creater;
           RecordSet.executeSql(sql);
        }
    }else if(leaveType.equals(String.valueOf(HrmAttVacation.L12))){//带薪病假
          //可请带薪病假总时间
          String allannualtime = "";
          //上一年剩余带薪病假天数
          String lastyearannualtime = "";
          //今年剩余带薪病假天数
          String thisyearannualtime = "";
          
          try{
              String tempvalue = HrmPaidSickManagement.getUserPaidSickInfo(workflowcreater,currentdate);
              thisyearannualtime = Util.TokenizerString2(tempvalue,"#")[0];
              lastyearannualtime = Util.TokenizerString2(tempvalue,"#")[1];
              allannualtime = Util.TokenizerString2(tempvalue,"#")[2];    
          }catch(Exception e){
              
          }
          float allannualdays = Util.getFloatValue(allannualtime,0);//用户剩余带薪病假时间
          float lastyearannualdays = Util.getFloatValue(lastyearannualtime,0);
          float thisyearannualdays = Util.getFloatValue(thisyearannualtime,0);
          //销假sql，先销上一年年假，再销当前年年假，如果年假小于0，则年假在本年上增加年假
          if(leavedays<0){
       	     sql = "update HrmPSLManagement set psldays = (psldays - " + leavedays + ") where pslyear = " + thisyear + " and resourceid = " + creater;     
                RecordSet.executeSql(sql);  
       	  }else if(leavedays<lastyearannualdays){
                sql = "update HrmPSLManagement set psldays = (psldays - " + leavedays + ") where pslyear = " + lastyear + " and resourceid = " + creater;     
                RecordSet.executeSql(sql);
             }else{
                sql = "update HrmPSLManagement set psldays = 0 where pslyear = " + lastyear + " and resourceid = " + creater;
                RecordSet.executeSql(sql);
                sql = "update HrmPSLManagement set psldays = (psldays - " + Util.getFloatValue(df.format(leavedays - lastyearannualdays),0) + ") where pslyear = " + thisyear + " and resourceid = " + creater;
                RecordSet.executeSql(sql);
          }
	} else if(leaveType.equals(String.valueOf(HrmAttVacation.L13))){//调休
		HrmPaidLeaveManager.paidLeaveDeduction(creater, fromDate, fromTime, toDate, toTime);
        }
  	  }
  		boolean logstatus = RequestManager.saveRequestLog() ;
    }
    //System.out.println("13:流程" + i + "时间:" + (new Date().getTime() - d1.getTime()));
  }
    //下一节点为归档节点,若有抄送无需提交的记录，
    if("3".equals(RequestManager.getNextNodetype())){
        rs.executeUpdate("update workflow_currentoperator set isremark = '4' where isremark = '8' and requestid = ? and nodeid = ? and userid = ?",RequestManager.getRequestid(),RequestManager.getNextNodeid(),user.getUID());
    }
    
  //系统表单批量执行
    try{
    	BatchSubmitAction batchSubmitAction = new BatchSubmitAction();
        batchSubmitAction.setRequestId(requestid);
        batchSubmitAction.batchSubmit();
    }catch(Exception e){
    	response.sendRedirect("/notice/RequestError.jsp");
    	return;
    }
    
}

int isfrommobile = Util.getIntValue(Util.null2String(request.getParameter("isfrommobile")));
if (isfrommobile == 1) {
    response.getWriter().write("{\"result\":1}");
    return;
}

String pagefromtype = Util.null2String(request.getParameter("pagefromtype"));
if ("1".equals(pagefromtype)) {
    response.getWriter().write("1");
    return;
}

if(method.equals("reqeustByWfTypeAndComplete")){
	response.sendRedirect("/workflow/search/WFSearchTemp.jsp?method="+method+"&wftype="+wftype+"&flowAll="+flowAll+"&flowNew="+flowNew+"&viewScope=doing&complete=0&numberType=flowAll&viewcondition="+viewcondition);
}else if(method.equals("reqeustbywfidNode")){
	response.sendRedirect("/workflow/search/WFSearchTemp.jsp?method="+method+"&workflowid="+wfid+"&flowAll="+flowAll+"&flowNew="+flowNew+"&viewScope=doing&complete=0&numberType=flowAll&viewcondition="+viewcondition);
}else{
	response.sendRedirect("/workflow/search/WFSearchTemp.jsp?method=all&viewScope=doing&complete=0&wftypes="+wftypes+"&flowAll="+flowAll+"&flowNew="+flowNew+"&viewcondition="+viewcondition);
}
%>