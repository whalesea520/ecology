
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.GCONST" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.file.FileUpload" %>
<%@ page import="weaver.general.TimeUtil"%>
<%@ page import="weaver.workflow.request.RequestAnnexUpload,weaver.share.ShareinnerInfo" %>
<%@page import="weaver.workflow.request.RequestSignRelevanceWithMe"%>
<%@page import="weaver.workflow.request.RequestManager"%>
<%@page import="weaver.formmode.log.LogType"%>
<%@page import="weaver.workflow.request.WFPathUtil"%>
<%@page import="weaver.mobile.webservices.workflow.soa.RequestPreProcessing"%>
<%@page import="weaver.workflow.request.RequestOperationLogManager"%>
<%@page import="weaver.conn.BatchRecordSet" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%--td3641 xwj 20060214--%>
 <%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RequestAddShareInfo" class="weaver.workflow.request.RequestAddShareInfo" scope="page" />
<%--  added by xwj on 22005-08-01 for td2104  --%>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td3641 on 20060214 --%>
<jsp:useBean id="PoppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/><!--xwj for td3641 on 20060214-->
<jsp:useBean id="sendMail" class="weaver.workflow.request.MailAndMessage" scope="page"/><!--xwj for td3641 on 20060214-->
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page"/>
<jsp:useBean id="RemarkOperaterManager" class="weaver.workflow.request.RemarkOperaterManager" scope="page" />
<jsp:useBean id="RequestAddOpinionShareInfo" class="weaver.workflow.request.RequestAddOpinionShareInfo" scope="page" />
<jsp:useBean id="basebean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="WFForwardManager" class="weaver.workflow.request.WFForwardManager" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page" />
<jsp:useBean id="wfAgentCondition" class="weaver.workflow.request.wfAgentCondition" scope="page" />
<jsp:useBean id="remarkRight" class="weaver.workflow.request.RequestRemarkRight" scope="page" />
<%

//Date d1 = new Date();

//    System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>转发开始...");
FileUpload fu = new FileUpload(request);
String operate=Util.null2String(fu.getParameter("operate"));
String needwfback=Util.null2String(fu.getParameter("needwfback"));
String requestid=Util.null2String(fu.getParameter("requestid"));
RecordSet.executeSql("select * from workflow_requestbase where requestid ="+requestid);
int workflowid= -1;
String currnodetype0 = "";
int currnodeid0 = 0;
if(RecordSet.next()){
workflowid = Util.getIntValue(RecordSet.getString("workflowid")) ;
currnodetype0 = RecordSet.getString("currentnodetype");
currnodeid0 = RecordSet.getInt("currentnodeid");
}
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
String userid=user.getUID()+"";
//int workflowid=Util.getIntValue(fu.getParameter("workflowid"));
//int workflowid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"workflowid"),0);
String ifchangstatus=Util.null2String(basebean.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));
String forwardrightsql = "select * from workflow_base where id = "+ workflowid ;
String isforwardrights="";
RecordSet.executeSql(forwardrightsql);
if(RecordSet.next()){
isforwardrights = Util.null2String(RecordSet.getString("isforwardrights")) ;
}
char flag=Util.getSeparator() ;
String para="";
String usertype="0";//被转发人肯定为人力资源，因此类型默认为“0”TD9836
String remark = Util.null2String(fu.getParameter("remark"));
int forwardflag = Util.getIntValue(fu.getParameter("forwardflag"));
if(forwardflag!=2 && forwardflag!=3){
forwardflag = 1;  // 2 征求意见；3 转办 ；1 转发
}
String signdocids = Util.null2String(fu.getParameter("signdocids"));
String signworkflowids = Util.null2String(fu.getParameter("signworkflowids"));
String clientip=fu.getRemoteAddr();
int requestLogId = Util.getIntValue(fu.getParameter("workflowRequestLogId"),0);
String remarkLocation = Util.null2String(fu.getParameter("remarkLocation"));
String logintype = user.getLogintype();
//if(logintype.equals("2")){
//   usertype="1";
//}
String operatortype = "";
    
if(logintype.equals("1"))  operatortype = "0";
if(logintype.equals("2"))  operatortype = "1";

Calendar today = Calendar.getInstance();
String CurrentDate = "";
String CurrentTime = "";
try{
	rs.executeProc("GetDBDateAndTime", "");
	if(rs.next()){
		CurrentDate = rs.getString("dbdate");
		CurrentTime = rs.getString("dbtime");
	}
}catch(Exception e){
	CurrentDate = Util.add0(today.get(Calendar.YEAR), 4) + "-" +
		Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" +
		Util.add0(today.get(Calendar.DAY_OF_MONTH), 2) ;

	CurrentTime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" +
		Util.add0(today.get(Calendar.MINUTE), 2) + ":" +
		Util.add0(today.get(Calendar.SECOND), 2) ;
}                      
int currentnodeid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"nodeid"),0);
//加强性修改转发。




if(currentnodeid<1){
	rs.execute("select nodeid from workflow_currentoperator where usertype=0 and requestid="+requestid+" and userid = "+ userid + "order by id desc");
	if(rs.next()){
		currentnodeid = Util.getIntValue(rs.getString("nodeid"),0);
	}
}
//int workflowid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"workflowid"),0);
String requestname = Util.null2String((String)session.getAttribute(userid+"_"+requestid+"requestname"));
String currentnodetype_temp = "";
if (workflowid == 0) {
    int nodeid = WFLinkInfo.getCurrentNodeid(Util.getIntValue(requestid), Util.getIntValue(userid), Util.getIntValue(logintype,1));               //节点id
    String nodetype = WFLinkInfo.getNodeType(nodeid);
    
	RecordSet.executeProc("workflow_Requestbase_SByID",requestid+"");
	if(RecordSet.next()){
	    requestname = Util.null2String(RecordSet.getString("requestname")) ;
		workflowid = Util.getIntValue(RecordSet.getString("workflowid"),0);
		int currentnodeid_temp = Util.getIntValue(RecordSet.getString("currentnodeid"),0);
	    if(currentnodeid<1) currentnodeid = currentnodeid_temp;
		String nodetype_1 = Util.null2String(RecordSet.getString("currentnodetype"));
	    if(nodetype.equals("")) currentnodetype_temp = nodetype_1;
	}
}

String workflowtype=WorkflowComInfo.getWorkflowtype(workflowid+"");      
//all remark resource 
int detailnum=Util.getIntValue(fu.getParameter("totaldetail"),0);
Set resourceids = new LinkedHashSet();
ArrayList agenterids=new ArrayList();
String resourceid="";
int i=0;


String tmpid=Util.fromScreen(fu.getParameter("field5"),user.getLanguage());
if(!tmpid.equals("")){
    String[] tmpids=Util.TokenizerString2(tmpid,",");
    for(int m=0 ;m<tmpids.length;m++){
        resourceids.add(tmpids[m]);
    }
}
Set rightResourceidList = new HashSet();
rs.execute("select distinct userid from workflow_currentoperator where usertype=0 and requestid="+requestid);
while(rs.next()){
	int userid_tmp = Util.getIntValue(rs.getString("userid"), 0);
	if(resourceids.contains(""+userid_tmp) == false){
		rightResourceidList.add(""+userid_tmp);
	}
}

int wfcurrrid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"wfcurrrid"), 0);

if (wfcurrrid == 0) {
    RecordSet.executeSql("select isremark,isreminded,preisremark,id,groupdetailid,nodeid from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" order by isremark,id");
    boolean istoManagePage=false;   //add by xhheng @20041217 for TD 1438
    while(RecordSet.next())	{
        String isremark = Util.null2String(RecordSet.getString("isremark")) ;
        wfcurrrid=Util.getIntValue(RecordSet.getString("id"));
        int tmpnodeid=Util.getIntValue(RecordSet.getString("nodeid"));
        //modify by mackjoe at 2005-09-29 td1772 转发特殊处理，转发信息本人未处理一直需要处理即使流程已归档
        if( isremark.equals("1")||isremark.equals("5") || isremark.equals("7")|| isremark.equals("9") ||(isremark.equals("0")  && !currentnodetype_temp.equals("3")) ) {
          //modify by xhheng @20041217 for TD 1438
          break;
        }
        if(isremark.equals("8")){
            break;
        }
    }
}

String messageid="";
/* ---- xwj for td2104 on 20050802 begin-----  */	

//forwardflag : 2 征求意见；3 转办 ；1 转发
int rolmIsRemark = 2;
String src = "forward";
if(forwardflag == 2 || forwardflag == 3){
    rolmIsRemark = 0;
    if (forwardflag == 2) {
        src = "take";
    } else {
        src = "trans";
    }
}
RequestOperationLogManager rolm = new RequestOperationLogManager(Util.getIntValue(requestid)
        , currentnodeid
        , rolmIsRemark
        , user.getUID()
        , user.getType()
        , CurrentDate
        , CurrentTime
        , src);      
//开始记录日志

rolm.flowTransStartBefore();

if(operate.equals("save")&&wfcurrrid>0){
 List poppuplist=new ArrayList();

   /* --------------add by xwj for td3641 begin -----*/
       String tempHrmIds = "";//xwj td2302
       String receivedPersonids = "";
    String agentSQL = "";//xwj td2302
    boolean isbeAgent=false;
    String agenterId="";
    String beginDate="";
    String beginTime="";
   String endDate="";
   String endTime="";
   String currentDate="";
   String currentTime="";
   String agenttype = "";
   /* --------------add by xwj for td3641 end -----*/

    WFForwardManager.setForwardRight(fu,Util.getIntValue(requestid),workflowid,currentnodeid,Util.getIntValue(userid));
    int showorder = 1;    
	
	//是否运行优化的逻辑
    boolean isPfx = (forwardflag == 1 && !isforwardrights.equals("1"));
    List<String> insertUesrids = new ArrayList<String>();
    List<Integer> insertShowOrderids = new ArrayList<Integer>();
    //获取当前请求操作者的代理情况
    //在插入操作者迭代过程中在单独查询

    Map<String, String> operatorAgentInfo = wfAgentCondition.getAgentInfoByResouce(
            String.valueOf(workflowid)
            , tmpid
            , String.valueOf(requestid));
    //end by mackjoe

    RecordSet.executeSql("select max(showorder) as maxshow from workflow_currentoperator where nodeid = " + currentnodeid + " and isremark in ('0','1','4') and requestid = " + requestid);
    if (RecordSet.next()) {
        showorder = RecordSet.getInt("maxshow") + 1;
    }

    //统一查询出已存在的用户id
    List<String> existstOperators = new ArrayList<String>();
    if (forwardflag == 1) {
        String selectsql = "select userid, isremark,id from workflow_currentoperator where requestid=" + requestid + " and isremark in('0','1','5','7') and (" + Util.getSubINClause(tmpid, "userid", "IN") + ") and usertype=0 order by isremark";

        RecordSet.executeSql(selectsql);

        while (RecordSet.next()) {
            String exiUserid = Util.null2String(RecordSet.getString("userid"));
            if (existstOperators.indexOf(exiUserid) == -1) {
                existstOperators.add(exiUserid);
            }
        }
    }
    //需要批量插入的参数列表
    List<List<Object>> insertOperatorParamsList = new ArrayList<List<Object>>();
	//保存要插入的人员， 用于更新islasttimes
    List<String> insertOperatorIds = new ArrayList<String>();
	
    String forwardresourceids = "";
	for (Object resourceidObj : resourceids) {
       int BeForwardid=0;
	   isbeAgent=false;
      //modify by mackjoe at 2005-09-28 td2865
      resourceid=(String)resourceidObj;
	  boolean isexist=false;
	  if(forwardflag == 1){
		  /*
      String selectsql="select isremark,id from workflow_currentoperator where requestid="+requestid+" and isremark in('0','1','5','7') and userid="+resourceid+" and usertype=0 order by isremark";
      RecordSet.executeSql(selectsql);
      
      if(RecordSet.next()){
          isexist=true;
      }
	  */
	  if (existstOperators.indexOf(resourceid) != -1) {
              isexist = true;
          }
	  }
	  if (forwardflag != 1 || !isPfx) {
      //end by mackjoe
	  RecordSet.executeSql("select max(showorder) as maxshow from workflow_currentoperator where nodeid = " + currentnodeid + " and isremark in ('0','1','4') and requestid = "+ requestid);
		if(RecordSet.next()){
			showorder = RecordSet.getInt("maxshow") + 1;
		}
	  } else {
            //每次自增即可
            showorder++;
        }		
			/* -----------   xwj for td3641 begin -----------*/
			/*
                            agentSQL = " select * from workflow_agentConditionSet where workflowId="+ workflowid +" and bagentuid=" + resourceid + 
                     " and agenttype = '1' and isproxydeal='1' " +  
                     " and ( ( (endDate = '" + CurrentDate + "' and (endTime='' or endTime is null))" + 
                     " or (endDate = '" + CurrentDate + "' and endTime > '" + CurrentTime + "' ) ) " + 
                     " or endDate > '" + CurrentDate + "' or endDate = '' or endDate is null)" +
                     " and ( ( (beginDate = '" + CurrentDate + "' and (beginTime='' or beginTime is null))" + 
	             " or (beginDate = '" + CurrentDate + "' and beginTime < '" + CurrentTime + "' ) ) " + 
	             " or beginDate < '" + CurrentDate + "' or beginDate = '' or beginDate is null) order by agentbatch asc  ,id asc "; //agentSQL is added by xwj for td2302
                        
                         rs.execute(agentSQL);
                         
                         while(rs.next()){
                         	String agentid = rs.getString("agentid");
 							String conditionkeyid = rs.getString("conditionkeyid");
 							boolean isagentcond = wfAgentCondition.isagentcondite(""+ requestid, "" + workflowid, "" + resourceid,"" + agentid, "" + conditionkeyid);
 							 if(isagentcond){
 	                       		isbeAgent=true;
 	                       	 	agenterId=rs.getString("agentuid");
 	                       	 	beginDate=rs.getString("beginDate");
 	              			 	beginTime=rs.getString("beginTime");
 	                      	 	endDate=rs.getString("endDate");
 	                      	 	endTime=rs.getString("endTime");
 	                      	 	currentDate=TimeUtil.getCurrentDateString();
 	                       	 	currentTime=(TimeUtil.getCurrentTimeString()).substring(11,19);
 	                       	 	agenttype = rs.getString("agenttype");
 	                          	agenterids.add(agenterId);
                         		break;
 							 }
 						}
						*/
		agenterId = operatorAgentInfo.get(resourceid);
        if(agenterId != null && !agenterId.equals("")){
            agenterids.add(agenterId);
            isbeAgent = true;
        }
		
        if(!isexist){
			//仅对转发做处理，意见征询、转办，暂时不回涉及到大量的人员。

            if (isPfx) {
		if(isbeAgent){
		  //代理人

		   List<Object> insertSqlParamList = new ArrayList();
                    insertSqlParamList.add(resourceid);
                    insertSqlParamList.add("2"); //isremark
                    insertSqlParamList.add(agenterId);
                    insertSqlParamList.add("1"); //agenttype
                    insertSqlParamList.add(showorder);
                    insertSqlParamList.add(CurrentDate);
                    insertSqlParamList.add(CurrentTime);
                    insertSqlParamList.add("1");
                    insertOperatorParamsList.add(insertSqlParamList);

                    showorder++;

                    insertSqlParamList = new ArrayList();
                    insertSqlParamList.add(agenterId);
                    insertSqlParamList.add("1");
                    insertSqlParamList.add(resourceid);
                    insertSqlParamList.add("2");
                    insertSqlParamList.add(showorder);
                    insertSqlParamList.add(CurrentDate);
                    insertSqlParamList.add(CurrentTime);
                    insertSqlParamList.add("1");
                    insertOperatorParamsList.add(insertSqlParamList);

                    insertUesrids.add(agenterId);
                    insertShowOrderids.add(showorder);

		    //记录要插入的人员， 用于更新islasttimes
                    insertOperatorIds.add(resourceid);
                    insertOperatorIds.add(agenterId);
                }else{
                    List<Object> insertSqlParamList = new ArrayList();
                    insertSqlParamList.add(resourceid);
                    insertSqlParamList.add("1"); //isremark
                    insertSqlParamList.add(-1);
                    insertSqlParamList.add("0"); //agenttype
                    insertSqlParamList.add(showorder);
                    insertSqlParamList.add(CurrentDate);
                    insertSqlParamList.add(CurrentTime);
                    insertSqlParamList.add("1");
                    insertOperatorParamsList.add(insertSqlParamList);

                    insertUesrids.add(resourceid);
                    insertShowOrderids.add(showorder);

                    //记录要插入的人员， 用于更新islasttimes
                    insertOperatorIds.add(resourceid);
                }
            }
			
		if(isbeAgent) {
            //代理人

            if (forwardflag != 1 || !isPfx) {


			para=requestid+ flag +resourceid+ flag +"0"+ flag +workflowid+""+ flag +workflowtype+ flag+usertype+flag + "2" +
			flag + currentnodeid + flag + agenterId + flag + "1" + flag + showorder+flag+"-1";
			RecordSet.executeProc("workflow_CurrentOperator_I",para);	
			}
			if(forwardflag==3){
				//被代理人
				/*para=requestid+ flag +agenterId+ flag +"0"+ flag +workflowid+""+ flag +workflowtype+ flag+usertype+flag + "1" +
		flag + currentnodeid + flag + resourceid + flag + "2" + flag + showorder+flag+"-1";
		RecordSet.executeProc("workflow_CurrentOperator_I",para);*/
				 // para=requestid+ flag +agenterId+ flag +"0"+ flag +workflowid+""+ flag +workflowtype+ flag+usertype+flag + "0" +
		//flag + currentnodeid + flag + "-1" + flag + "2" + flag + showorder+flag+"-1";
				   para=requestid+ flag +agenterId+ flag +"0"+ flag +workflowid+""+ flag +workflowtype+ flag+usertype+flag + "0" +
		flag + currentnodeid + flag + resourceid + flag + "2" + flag + showorder+flag+"-1";
		RecordSet.executeProc("workflow_CurrentOperator_I",para);
           //agentSQL="select id from workflow_CurrentOperator where requestid="+requestid+" and userid="+agenterId+" and usertype="+usertype+" and isremark='1' and nodeid="+currentnodeid+" and showorder="+showorder+" order by id desc";
		      if(needwfback.equals("0")){
		 String needsql = "update workflow_currentoperator set needwfback = '0' where requestid="+requestid+" and userid="+agenterId+" and usertype="+usertype+" and isremark='0' and nodeid="+currentnodeid;
		   RecordSet.execute(needsql);
		  }
		   String ForwardHsql = "";
		  if(agenterId.equals(userid)){  //转办给自己时特殊处理
				 ForwardHsql = "update workflow_currentoperator set isremark = 2 where requestid="+requestid+" and userid="+userid+"and showorder<>"+showorder+" and usertype="+usertype+" and isremark='0' and nodeid="+currentnodeid;	
		  }else{
				 ForwardHsql = "update workflow_currentoperator set isremark = 2 where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" and isremark='0' and agentorbyagentid = '-1' and nodeid="+currentnodeid;
		  }
		   RecordSet.execute(ForwardHsql);
			   String IDsql = "select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" and isremark='2' and nodeid="+currentnodeid +" order by id desc";
			 RecordSet.execute(IDsql);
			 if(RecordSet.next()){
					 int id = RecordSet.getInt("id");
				// RecordSet.execute("update workflow_currentoperator set handleforwardid = "+ id +" where requestid="+requestid+" and userid="+resourceid+" and usertype="+usertype+" and isremark='0' and nodeid="+currentnodeid);
				int groupdetailid = RecordSet.getInt("groupdetailid");
				 int groupid = RecordSet.getInt("groupid");
				 RecordSet.execute("update workflow_currentoperator set handleforwardid = "+ id +" ,groupdetailid = "+ groupdetailid +" ,groupid = "+ groupid +" where requestid="+requestid+" and userid="+resourceid+" and usertype="+usertype+" and isremark='0' and nodeid="+currentnodeid);
			 }
			}else if(forwardflag==2){  //意见征询，设置标识位takisremark的值为 "2"
			String checkoperatorsql = "select 1 from workflow_currentoperator where requestid="+requestid+" and userid="+agenterId+" and usertype="+usertype+" and isremark='0' and nodeid="+currentnodeid;
		    RecordSet.execute(checkoperatorsql);
		    if(!RecordSet.next()){
			    para=requestid+ flag +agenterId+ flag +"0"+ flag +workflowid+""+ flag +workflowtype+ flag+usertype+flag + "1" +
			    flag + currentnodeid + flag + resourceid + flag + "2" + flag + showorder+flag+"-1";
		        RecordSet.executeProc("workflow_CurrentOperator_I",para);
		 String IDsql = "select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" and isremark='0' and nodeid="+currentnodeid;
			 RecordSet.execute(IDsql);
			 if(RecordSet.next()){
					// int id = RecordSet.getInt("id");
				// RecordSet.execute("update workflow_currentoperator set handleforwardid = "+ id +" where requestid="+requestid+" and userid="+resourceid+" and usertype="+usertype+" and isremark='0' and nodeid="+currentnodeid);
				int groupdetailid = RecordSet.getInt("groupdetailid");
				 int groupid = RecordSet.getInt("groupid");
		String Taksql = "update workflow_CurrentOperator set takisremark = 2 ,groupdetailid = "+ groupdetailid +" ,groupid = "+ groupid +" where requestid="+requestid+" and userid="+agenterId+" and  usertype="+usertype+" and showorder="+showorder+" and isremark='1' and nodeid="+currentnodeid;
			 
			 RecordSet.execute(Taksql);
			 //代理人、被代理人都要加被意见征询标识

			 //RecordSet.execute("update workflow_CurrentOperator set takisremark = 2 where requestid="+requestid+" and  agentorbyagentid ="+agenterId+" and  usertype="+usertype+" and showorder="+showorder+" and isremark='2' and nodeid="+currentnodeid);
			 }
			 String Taksql2 = "update workflow_CurrentOperator set takisremark = -2 where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" and isremark='0' and nodeid="+currentnodeid;
			 RecordSet.execute(Taksql2);
		    }
            agentSQL="select id from workflow_CurrentOperator where requestid="+requestid+" and userid="+agenterId+" and usertype="+usertype+" and isremark='1' and nodeid="+currentnodeid+" and showorder="+showorder+" order by id desc";
			}else if(!isPfx){
			//被代理人   agenttype 的问题？
			para=requestid+ flag +agenterId+ flag +"0"+ flag +workflowid+""+ flag +workflowtype+ flag+usertype+flag + "1" +
		flag + currentnodeid + flag + resourceid + flag + "2" + flag + showorder+flag+"-1";
		RecordSet.executeProc("workflow_CurrentOperator_I",para);
            agentSQL="select id from workflow_CurrentOperator where requestid="+requestid+" and userid="+agenterId+" and usertype="+usertype+" and isremark='1' and nodeid="+currentnodeid+" and showorder="+showorder+" order by id desc";
			}
		}
		else{
			if(forwardflag==3){  //handleforwardid
			para=requestid+ flag +resourceid+ flag +"0"+ flag +workflowid+""+ flag +workflowtype+ flag+usertype+flag + "0" +
		  flag + currentnodeid + flag + -1 + flag + "0" + flag + showorder+flag+"-1";
		  RecordSet.executeProc("workflow_CurrentOperator_I",para);
		  if(needwfback.equals("0")){
		 String needsql = "update workflow_currentoperator set needwfback = '0' where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" and isremark='0' and nodeid="+currentnodeid;
		   RecordSet.execute(needsql);
		  }
		  String ForwardHsql = "";
		  if(resourceid.equals(userid)){  //转办给自己时特殊处理
				ForwardHsql = "update workflow_currentoperator set isremark = 2 where requestid="+requestid+" and userid="+userid+"and showorder<>"+showorder+" and usertype="+usertype+" and isremark='0' and nodeid="+currentnodeid;	
		  }else{
				ForwardHsql = "update workflow_currentoperator set isremark = 2 where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" and isremark='0' and nodeid="+currentnodeid;
		  }
		   RecordSet.execute(ForwardHsql);
		    String IDsql = "select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" and isremark='2' and nodeid="+currentnodeid +" order by id desc";
			 RecordSet.execute(IDsql);
			 if(RecordSet.next()){   
				 int id = RecordSet.getInt("id");
				 int groupdetailid = RecordSet.getInt("groupdetailid");
				 int groupid = RecordSet.getInt("groupid");
				 RecordSet.execute("update workflow_currentoperator set handleforwardid = "+ id +" ,groupdetailid = "+ groupdetailid +" ,groupid = "+ groupid +" where requestid="+requestid+" and userid="+resourceid+" and usertype="+usertype+" and isremark='0' and nodeid="+currentnodeid);
			 }
			}else if(forwardflag==2){   //意见征询，设置标识位takisremark的值为 "2"
			    String checkoperatorsql = "select 1 from workflow_currentoperator where requestid="+requestid+" and userid="+resourceid+" and usertype="+usertype+" and isremark='0' and nodeid="+currentnodeid;
			    RecordSet.execute(checkoperatorsql);
			    if(!RecordSet.next()){
				    para=requestid+ flag +resourceid+ flag +"0"+ flag +workflowid+""+ flag +workflowtype+ flag+usertype+flag + "1" +
			        flag + currentnodeid + flag + -1 + flag + "0" + flag + showorder+flag+"-1";
			        RecordSet.executeProc("workflow_CurrentOperator_I",para);
				    String IDsql = "select * from workflow_currentoperator where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" and isremark='0' and nodeid="+currentnodeid;
				    RecordSet.execute(IDsql);
				    if(RecordSet.next()){   
					    //int id = RecordSet.getInt("id");
					    int groupdetailid = RecordSet.getInt("groupdetailid");
					    int groupid = RecordSet.getInt("groupid");
				        String Taksql = "update workflow_CurrentOperator set takisremark = 2, groupdetailid = "+ groupdetailid +" ,groupid = "+ groupid +" where requestid="+requestid+" and userid="+resourceid+" and usertype="+usertype+" and showorder="+showorder+" and isremark='1' and nodeid="+currentnodeid;
				        RecordSet.execute(Taksql);
				    }
				    String Taksql2 = "update workflow_CurrentOperator set takisremark = -2 where requestid="+requestid+" and userid="+userid+" and usertype="+usertype+" and isremark='0' and nodeid="+currentnodeid;
				    RecordSet.execute(Taksql2);
			    }
                agentSQL="select id from workflow_CurrentOperator where requestid="+requestid+" and userid="+resourceid+" and usertype="+usertype+" and isremark='1' and nodeid="+currentnodeid+" and showorder="+showorder+" order by id desc";	
			}else if(!isPfx){
			para=requestid+ flag +resourceid+ flag +"0"+ flag +workflowid+""+ flag +workflowtype+ flag+usertype+flag + "1" +
		  flag + currentnodeid + flag + -1 + flag + "0" + flag + showorder+flag+"-1";
		  RecordSet.executeProc("workflow_CurrentOperator_I",para);
            agentSQL="select id from workflow_CurrentOperator where requestid="+requestid+" and userid="+resourceid+" and usertype="+usertype+" and isremark='1' and nodeid="+currentnodeid+" and showorder="+showorder+" order by id desc";	
			}
		}
		if (forwardflag != 1 || !isPfx) {
            RecordSet.execute(agentSQL);
            if(RecordSet.next()){
                BeForwardid=RecordSet.getInt("id");
			}
        }
     }

    if(!isbeAgent){                 	 
    tempHrmIds += Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage()) + ",";
    receivedPersonids += Util.null2String(resourceid) + ",";
	  }
	  else{
	  tempHrmIds += Util.toScreen(ResourceComInfo.getResourcename(resourceid),user.getLanguage()) + "->"+ Util.toScreen(ResourceComInfo.getResourcename(agenterId),user.getLanguage())+ ",";
	  receivedPersonids += Util.null2String(resourceid) + ",";
	  }
	  	
	/* -----------   xwj for td3641 end -----------*/
	
	//流程测试状态下转发，不提醒被转发人 START
	int istest = 0;
	try{
		rs.execute("select isvalid from workflow_base where id="+workflowid);
		if(rs.next()){
			int isvalid_t = Util.getIntValue(rs.getString("isvalid"), 0);
			if(isvalid_t == 2){
				istest = 1;
			}
		}
	}catch(Exception e){
		e.printStackTrace();
	}
	
	if (istest != 1) {
        // 2004-05-19 刘煜修改， 在转发的时候加入对被转发人的工作流提醒（有新的工作流）, 被转发人肯定为人力资源，因此类型默认为“0”





       if(isbeAgent){
           forwardresourceids += "," + agenterId;
        // PoppupRemindInfoUtil.insertPoppupRemindInfo(Integer.parseInt(agenterId),0,"0",Integer.parseInt(requestid),requestname);//xwj for td3450 20060111
            Map map=new HashMap();
		    map.put("userid",""+Integer.parseInt(agenterId));
		    map.put("type","0");
		    map.put("logintype","0");
		    map.put("requestid",""+Integer.parseInt(requestid));
		    map.put("requestname",""+requestname);
		    map.put("workflowid","-1");
		    map.put("creater","");
		    poppuplist.add(map);
       }
       else{
           forwardresourceids += "," + resourceid;
           
    	    Map map=new HashMap();
  		    map.put("userid",""+Integer.parseInt(resourceid));
  		    map.put("type","0");
  		    map.put("logintype","0");
  		    map.put("requestid",""+Integer.parseInt(requestid));
  		    map.put("requestname",""+requestname);
  		    map.put("workflowid","-1");
  		    map.put("creater","");
  		    poppuplist.add(map);   
           //PoppupRemindInfoUtil.insertPoppupRemindInfo(Integer.parseInt(resourceid),0,"0",Integer.parseInt(requestid),requestname);//xwj for td3450 20060111
       }
	}
	PoppupRemindInfoUtil.setPoppuplist(poppuplist);
int IsSubmitedOpinion=0;     //待办提交后被转发人是否可提交意见
int IsBeForwardTodo=0;    //待办可转发





int IsBeForwardSubmitAlready =0;    //允许已办被转发人可提交意见





int IsBeForwardAlready =0;		//已办被转发人可转发





int IsBeForwardSubmitNotaries =0;    //允许办结被转发人可提交意见





int IsBeForward=0;            //办结被转发人是否可转发





int IsFromWFRemark = -1;	 //被转发状态





	//流程测试状态下转发，不提醒被转发人 END
		//WFForwardManager.SaveForward(Util.getIntValue(requestid),wfcurrrid,BeForwardid);
if(isforwardrights.equals("1")){
IsSubmitedOpinion=Util.getIntValue(fu.getParameter("IsSubmitedOpinion"),0);     //待办提交后被转发人是否可提交意见
IsBeForwardTodo=Util.getIntValue(fu.getParameter("IsBeForwardTodo"),0);    //待办可转发





IsBeForwardSubmitAlready =Util.getIntValue(fu.getParameter("IsBeForwardSubmitAlready"),0);    //允许已办被转发人可提交意见





IsBeForwardAlready =Util.getIntValue(fu.getParameter("IsBeForwardAlready"),0);		//已办被转发人可转发





IsBeForwardSubmitNotaries =Util.getIntValue(fu.getParameter("IsBeForwardSubmitNotaries"),0);    //允许办结被转发人可提交意见





IsBeForward=Util.getIntValue(fu.getParameter("IsBeForward"),0);            //办结被转发人是否可转发





IsFromWFRemark = Util.getIntValue(fu.getParameter("IsFromWFRemark"),-1); 
}
	//走优化的逻辑的话， 最后处理

	if (forwardflag != 1 || !isPfx) {
        WFForwardManager.SaveForward(Util.getIntValue(requestid),wfcurrrid,BeForwardid,forwardflag);
	}
		if(isforwardrights.equals("1")){
//int IsSubmitedOpinion=Util.getIntValue(fu.getParameter("IsSubmitedOpinion"),0);     //待办提交后被转发人是否可提交意见
//int IsBeForwardTodo=Util.getIntValue(fu.getParameter("IsBeForwardTodo"),0);    //待办可转发





//int IsBeForwardSubmitAlready =Util.getIntValue(fu.getParameter("IsBeForwardSubmitAlready"),0);    //允许已办被转发人可提交意见





//int IsBeForwardAlready =Util.getIntValue(fu.getParameter("IsBeForwardAlready"),0);		//已办被转发人可转发





//int IsBeForwardSubmitNotaries =Util.getIntValue(fu.getParameter("IsBeForwardSubmitNotaries"),0);    //允许办结被转发人可提交意见





//int IsBeForward=Util.getIntValue(fu.getParameter("IsBeForward"),0);            //办结被转发人是否可转发





		/*WFForwardManager.setIsSubmitedOpinion(IsSubmitedOpinion);
		WFForwardManager.setIsBeForwardTodo(IsBeForwardTodo);
		WFForwardManager.setIsBeForwardSubmitAlready(IsBeForwardSubmitAlready);
		WFForwardManager.setIsBeForwardAlready(IsBeForwardAlready);
		WFForwardManager.setIsBeForwardSubmitNotaries(IsBeForwardSubmitNotaries);
		WFForwardManager.setIsBeForward(IsBeForward);*/
		String wfSQL="select requestid from workflow_Forward where requestid="+requestid+" and Forwardid="+wfcurrrid+" and BeForwardid="+BeForwardid;
		RecordSet.execute(wfSQL);
if(RecordSet.next()){
		RecordSet.execute("update workflow_Forward set IsSubmitedOpinion="+IsSubmitedOpinion+",IsBeForwardTodo="+IsBeForwardTodo+",IsBeForwardSubmitAlready="+IsBeForwardSubmitAlready+",IsBeForward="+IsBeForward+",IsBeForwardAlready="+IsBeForwardAlready+",IsBeForwardSubmitNotaries="+IsBeForwardSubmitNotaries+",IsFromWFRemark="+IsFromWFRemark+" where requestid="+requestid+" and Forwardid="+wfcurrrid+" and BeForwardid="+BeForwardid);
	}
	  String sql_h="select currentnodetype from workflow_requestbase a where  a.requestid="+requestid;
            String currentnodetype = ""; 
			RecordSet.execute(sql_h);
			if(RecordSet.next()){
			  currentnodetype =RecordSet.getString("currentnodetype");
			}
			if(currentnodetype.equals("3")){
			String  sql_u ="update workflow_currentoperator  set iscomplete=1 where  requestid= "+requestid;
			RecordSet.execute(sql_u);
			}
}

	}
	
	//批量插入处理
    if (insertOperatorParamsList != null && !insertOperatorParamsList.isEmpty()) {
		//处理islasttimes
        rs.executeUpdate("update workflow_currentoperator set islasttimes=0 where requestid=" + requestid +
                " and (" + Util.getSubINClause(StringUtils.join(insertOperatorIds, ","), "userid", "IN") + ") and usertype = 0");

        //防止workflowtype的值为空

        String forwardSql = "insert into workflow_currentoperator " +
                "(requestid, userid, groupid, workflowid, workflowtype, usertype, isremark, nodeid, agentorbyagentid, agenttype, showorder, receivedate, receivetime, viewtype, iscomplete, islasttimes, groupdetailid, preisremark, needwfback)" +
                "values(" + requestid + ", ?, 0, " + workflowid + ", " + workflowtype + ", 0, ?, " + currentnodeid + ", ?, ?, ?, ?, ?, 0, 0, 1, -1, ?, '1')";
        BatchRecordSet rst = new BatchRecordSet();

        rst.executeBatchSql(forwardSql, insertOperatorParamsList);

        String sltCurrtIdSql = "select id, userid, usertype, showorder " +
                "from workflow_CurrentOperator " +
                "where requestid=" + requestid + " and isremark='1' and nodeid=" + currentnodeid + " and receivedate='" + CurrentDate + "' and receivetime='" + CurrentTime + "' order by id desc";
        rs.executeSql(sltCurrtIdSql);

        List<List<Object>> insertForwardParamsList = new ArrayList<List<Object>>();
        while (rs.next()) {
            int currtId = Util.getIntValue(rs.getString("id"));
            int currtUserId = Util.getIntValue(rs.getString("userid"));
            int currtShoworder = Util.getIntValue(rs.getString("showorder"));
            int insertUserIndex = insertUesrids.indexOf(currtUserId + "");
            int insertShowOrderIndex = insertShowOrderids.indexOf(currtShoworder);
            if (insertUserIndex != -1 && insertUserIndex == insertShowOrderIndex) {
                List<Object> forwardSqlParamList = new ArrayList();
                forwardSqlParamList.add(currtId);
                insertForwardParamsList.add(forwardSqlParamList);
                //防止一个人有多次记录的情况
                insertUesrids.remove(insertUserIndex);
                insertShowOrderids.remove(insertUserIndex);
            }
        }

        if (insertForwardParamsList != null && !insertForwardParamsList.isEmpty()) {
            WFForwardManager.insertForwardInfo(Util.getIntValue(requestid), wfcurrrid, insertForwardParamsList);
        }
    }
    //推送处理start
    WFPathUtil wfutil = new WFPathUtil();
    //有需要提醒的信息，才抛出处理
    if (PoppupRemindInfoUtil.getPoppuplist() != null && !PoppupRemindInfoUtil.getPoppuplist().isEmpty()) {
        wfutil.getFixedThreadPool().execute(PoppupRemindInfoUtil);
    }
	
	  //PoppupRemindInfoUtil.insertPoppupRemindInfo(poppuplist);

    //将代理人加入人员列表，用于发送邮件通知和设置共享





    for(i=0;i<agenterids.size();i++){
        resourceids.add(agenterids.get(i));
    }
    
	String isfeedback="";
    String isnullnotfeedback="";
	RecordSet.executeSql("select isfeedback,isnullnotfeedback from workflow_flownode where workflowid="+workflowid+" and nodeid="+currentnodeid);
	if(RecordSet.next()){
		isfeedback=Util.null2String(RecordSet.getString("isfeedback"));
        isnullnotfeedback=Util.null2String(RecordSet.getString("isnullnotfeedback"));
	}
	/*
	if (!ifchangstatus.equals("")&&isfeedback.equals("1")&&((isnullnotfeedback.equals("1")&&!Util.replace(remark, "\\<script\\>initFlashVideo\\(\\)\\;\\<\\/script\\>", "", 0, false).equals(""))||!isnullnotfeedback.equals("1")))
		{
		RecordSet.executeSql("update workflow_currentoperator set viewtype =-1  where needwfback='1' and requestid=" + requestid + " and userid<>" + userid + " and viewtype=-2");
		}*/

   //发送邮件





       sendMail.setForwardflag(forwardflag);
       sendMail.setRequest(fu);
       sendMail.sendMailAndMessage(Integer.parseInt(requestid),new ArrayList(resourceids),user);
	//加入LOG表信息





	  RecordSet.executeSql("select * from workflow_currentoperator where userid = " + userid + " and nodeid = " + currentnodeid + " and isremark in ('0','1','4') and requestid = "+ requestid+" order by showorder,receivedate,receivetime");
    int tempagentorbyagentid = -1;
    int tempagenttype = 0;
    if(RecordSet.next()){
    showorder =  RecordSet.getInt("showorder");
    tempagentorbyagentid = RecordSet.getInt("agentorbyagentid");
    tempagenttype = RecordSet.getInt("agenttype");
    if(tempagenttype<0) tempagenttype = 0;
    }
	String currentnodetype = "";
	RecordSet.executeSql("select currentnodetype from workflow_requestbase where requestid= "+requestid);
	if(RecordSet.next()){
		currentnodetype = RecordSet.getString("currentnodetype");
		if(currentnodetype.equals("3")){
			tempagentorbyagentid = -1;
			tempagenttype = 0;
		}
	}
    RequestAnnexUpload rau=new RequestAnnexUpload();
    rau.setRequest(fu);
    rau.setUser(user);
    String annexdocids=rau.AnnexUpload();
    String Procpara="";
	if(forwardflag==2){
       Procpara=requestid+"" + flag + workflowid+"" + flag + currentnodeid+"" + flag + "a" + flag 
    	+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag
    	//+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag 
    	+ clientip+flag+operatortype+flag+"0"+flag+tempHrmIds.trim() + flag + tempagentorbyagentid + flag + tempagenttype + flag + showorder+flag+annexdocids+flag+requestLogId+ flag + signdocids+flag+signworkflowids+flag+"0"+flag+"0"+flag+"0"+flag+receivedPersonids.trim()+flag+remarkLocation; //xwj for td1837 on 2005-05-12
    }
	if(forwardflag==3){
       Procpara=requestid+"" + flag + workflowid+"" + flag + currentnodeid+"" + flag + "h" + flag 
    	+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag
    	//+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag 
    	+ clientip+flag+operatortype+flag+"0"+flag+tempHrmIds.trim() + flag + tempagentorbyagentid + flag + tempagenttype + flag + showorder+flag+annexdocids+flag+requestLogId+ flag + signdocids+flag+signworkflowids+flag+"0"+flag+"0"+flag+"0"+flag+receivedPersonids.trim()+flag+remarkLocation; //xwj for td1837 on 2005-05-12
    }
	if(forwardflag==1){
       Procpara=requestid+"" + flag + workflowid+"" + flag + currentnodeid+"" + flag + "7" + flag 
    	+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag
    	//+ CurrentDate + flag + CurrentTime + flag + userid+"" + flag + remark + flag 
    	+ clientip+flag+operatortype+flag+"0"+flag+tempHrmIds.trim() + flag + tempagentorbyagentid + flag + tempagenttype + flag + showorder+flag+annexdocids+flag+requestLogId+ flag + signdocids+flag+signworkflowids+flag+"0"+flag+"0"+flag+"0"+flag+receivedPersonids.trim()+flag+remarkLocation; //xwj for td1837 on 2005-05-12
    }
    String currentString = new RequestManager().execRequestlog(Procpara,rs,flag,remark);
	
	//转办代理时，插入签字意见之后再更新。
	for(int j=0;j<agenterids.size();j++){
        String agentResourceid = (String)agenterids.get(j);
		if(forwardflag==3 && !agentResourceid.equals(userid) ){
			String ForwardHsqldc = "update workflow_currentoperator set isremark = 2 where requestid="+requestid+" and userid="+userid+" and usertype="+operatortype+" and isremark='0' and agenttype='2' and nodeid="+currentnodeid;
			RecordSet.execute(ForwardHsqldc);
		}
    }
	
	String configsql = "select notseeeachother from workflow_flownode where workflowid = " + workflowid + " and nodeid = " + currentnodeid;
    rs.executeSql(configsql);
    int notseeeachother = 0;
    if(rs.next()){
        notseeeachother = rs.getInt(1);
    }
  	if(!"".equals(currentString) && currentString.indexOf("~~current~~") > -1&& notseeeachother == 1){
  		String [] arraycurrent = Util.TokenizerString2(currentString, "~~current~~");
  		String currentdate = arraycurrent[0];
  		String currenttime = arraycurrent[1];
  		RequestSignRelevanceWithMe reqsignwm = new RequestSignRelevanceWithMe();
        reqsignwm.inertRelevanceInfo(workflowid+"", requestid, currentnodeid+"", "7", currentdate, currenttime, userid, remark, (("" != forwardresourceids) ? forwardresourceids.substring(1) : forwardresourceids));
        
        int nodeattr = WFLinkInfo.getNodeAttribute(currentnodeid);
        Set<String> branchNodeSet = new HashSet<String>();
        if(nodeattr == 2){   //分支中间节点
        	String branchnodes = "";
        	branchnodes = WFLinkInfo.getNowNodeids(Util.getIntValue(requestid,-1));
        	if(!"".equals(branchnodes)){
        		String [] strs = branchnodes.split(",");
        		for(int k = 0; k < strs.length; k++){
        			String nodestr = strs[k];
        			if(!"-1".equals(nodestr)){
        				branchNodeSet.add(nodestr);
        			}
        		}
        	}
        }
        /**日志的权限处理,start*/
        if(!"3".equals(currnodetype0) && (currentnodeid == currnodeid0 || branchNodeSet.contains(currentnodeid+""))){   //非归档节点，且是在当前节点上的转发操作



	        remarkRight.setRequestid(Util.getIntValue(requestid,-1));
	        remarkRight.setNodeid(currentnodeid);
	        remarkRight.setWorkflow_currentid(wfcurrrid);
	        String logtype = "7";
	        if(forwardflag == 2){   //征询
	        	logtype = "a";
	        }else if(forwardflag == 3){  //转办
	        	logtype = "h";
	        }else{  //转发
	        	logtype = "7";
	        }
	        String rightSql = " select logid from workflow_requestlog where workflowid = " + workflowid 
	        		        + " and nodeid = " + currentnodeid + " and logtype = '" + logtype + "' and requestid = " + requestid
	        		        + " and operatedate = '" + currentdate + "' and operatetime = '" + currenttime + "' and operator = " + userid;
	        RecordSet.executeSql(rightSql);
	        int logid = -1;
	        if(RecordSet.next()){
	        	logid = RecordSet.getInt("logid");
	        }
	        String receiversids = "";  //授予权限的人员



	        //这里将转发的接收人，以及接收人的代理人都授权，避免代理人收回代理权限时，还需要处理签字意见的权限问题
	        for(Object myuserid : resourceids){
	        	receiversids += "," + myuserid;
	        }
	        if(receiversids.length() > 0){
	        	receiversids = receiversids.substring(1);
	        }
	        remarkRight.saveRemarkRight(logid,receiversids);
        }
        /**日志的权限处理,end*/
  	}
  	
  	int nodeattr = WFLinkInfo.getNodeAttribute(currentnodeid);
	if(forwardflag == 3&&nodeattr==2){
		new RequestManager().CheckUserIsLasttimes(Util.getIntValue(requestid), currentnodeid, user);
	}
	
    /*RecordSet.executeProc("workflow_RequestLog_Insert",Procpara);
    if (RecordSet.next()) {
        String currentdate = RecordSet.getString(1);
        String currenttime = RecordSet.getString(2);
        
        RequestSignRelevanceWithMe reqsignwm = new RequestSignRelevanceWithMe();
        reqsignwm.inertRelevanceInfo(workflowid+"", requestid, currentnodeid+"", "7", currentdate, currenttime, userid, remark, forwardresourceids.substring(1));
    }*/
    
    if(requestLogId>0){//表单签章
    	RecordSet.executeSql("select imagefileid from workflow_formsignremark where requestlogid="+requestLogId);
    	RecordSet.next();
    	int imagefileid = Util.getIntValue(RecordSet.getString("imagefileid"),0);
    	if(imagefileid>0) remark=""+requestLogId;
    }
    if (!ifchangstatus.equals("")&&isfeedback.equals("1")&&((isnullnotfeedback.equals("1")&&!Util.replace(remark, "\\<script\\>initFlashVideo\\(\\)\\;\\<\\/script\\>", "", 0, false).equals(""))||!isnullnotfeedback.equals("1")))
    {
    	RecordSet.executeSql("update workflow_currentoperator set viewtype =-1  where needwfback='1' and requestid=" + requestid + " and userid<>" + userid + " and viewtype=-2");
    }

	//处理之前节点操作人对附件的权限 TD10577 Start
	String[] docids = Util.TokenizerString2(annexdocids, ",");
	for(int cx=0; i<docids.length; i++){
		int docid_tmp = Util.getIntValue(docids[cx]);
		for (Object rightResourceid_tmpObj : rightResourceidList) {
			int rightResourceid_tmp = Util.getIntValue((String)rightResourceid_tmpObj, 0);
			try{
				ShareinnerInfo shareInfo=new ShareinnerInfo();
				shareInfo.AddShare(docid_tmp, 1, rightResourceid_tmp, 10, 1, 1, rightResourceid_tmp, "ShareinnerDoc", 1);
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	//处理之前节点操作人对附件的权限 TD10577 End

    //保存签字意见提交人当前部门





    //String departmentid = Util.null2String(ResourceComInfo.getDepartmentID(""+userid));
    //if(!departmentid.equals("")) rs.executeSql("update workflow_requestlog set operatorDept="+departmentid+" where requestid="+requestid+" and nodeid="+currentnodeid+" and logtype='7' and operator="+userid+" and operatortype="+operatortype);  

    if(!signdocids.equals("")){
        RecordSet.executeSql("select docids from workflow_requestbase where requestid="+requestid);
        RecordSet.next();
        String newdocids = Util.null2String(RecordSet.getString("docids"));
        if(!newdocids.equals("")) newdocids = newdocids+","+signdocids;
        else newdocids = signdocids;
        RecordSet.executeSql("update workflow_requestbase set docids='"+newdocids+"' where requestid="+requestid);
    }
    RequestAddShareInfo.SetNextNodeID(currentnodeid);
	
	//处理模板为只读,转办后附件可以编辑

	String result = "";	
	String isEdit = "";
	String sql1 = "select * from workflow_nodeform  where nodeid = "+currentnodeid+" and exists (select 1 from workflow_billfield where workflow_nodeform.fieldid = workflow_billfield.id and workflow_billfield.fieldhtmltype='6' and type in(1,2))";
	RecordSet.executeSql(sql1);
	while(RecordSet.next()){
		isEdit = Util.null2String(RecordSet.getString("isedit"));
	}
	if("0".equals(isEdit) || "".equals(isEdit)){
		result = "false";
	}else{
		result = "true";
	}

    if(forwardflag == 1){
        RequestAddShareInfo.addShareInfo(requestid,new ArrayList(resourceids),"false", forwardflag == 2, "1".equals(WFForwardManager.getIsBeForwardModify())) ;
	}else{
		RequestAddShareInfo.addShareInfo(requestid,new ArrayList(resourceids), result, forwardflag == 2, "1".equals(WFForwardManager.getIsBeForwardModify())) ;
	}
    
    //added by pony on 2006-05-31 for Td4442
    RemarkOperaterManager.processRemark(workflowid,requestid,currentnodeid,user,fu);
    RequestAddOpinionShareInfo.processOpinionRemarkResourcesShare(workflowid,requestid,new ArrayList(resourceids),user,currentnodeid);
    //added end.
    //RecordSet.executeSql("update workflow_requestbase set lastoperator="+userid+",lastoperatortype="+usertype+",lastoperatedate='"+CurrentDate+"',lastoperatetime='"+CurrentTime+"' where requestid="+requestid);
  	if(currentnodetype.equals("3"))//如果流程已归档，不修改lastoperatedate和lastoperatetime的值





   	    RecordSet.executeSql("update workflow_requestbase set lastoperator="+userid+",lastoperatortype="+usertype+" where requestid="+requestid);
   	//else
   	    //RecordSet.executeSql("update workflow_requestbase set lastoperator="+userid+",lastoperatortype="+usertype+",lastoperatedate='"+CurrentDate+"',lastoperatetime='"+CurrentTime+"' where requestid="+requestid);
	//TD9144 弹出转发窗口，提交转发请求后，关闭该窗口，并刷新原页面




	// 查询当前请求的一些基本信息

//转办，意见征询红色点的变化
	if(forwardflag == 2||forwardflag == 3){
	    try{
		    RecordSet.executeQuery("select isbill,formid from workflow_base where id = ? ", workflowid);
		    if(RecordSet.next()){
		        int isbill = RecordSet.getInt("isbill");
		        int formid = RecordSet.getInt("formid");
	            RecordSet.executeProc("workflow_Requestbase_SByID", requestid + "");
	            if (RecordSet.next()) {
	                String oldformsignaturemd5 = Util.null2String(RecordSet.getString("formsignaturemd5"));
	                //if(tmpid.length() > 0){
	                   // String[] tmpids = Util.TokenizerString2(tmpid, ",");
	                    //for (Object tmpidObj : tmpids) {
	                       // int tmpuserid = Util.getIntValue((String)tmpidObj, 0);
	                       // if(tmpuserid > 0){
	                           // User userTemp = User.getUser(tmpuserid,Integer.valueOf(usertype));
	                            wfutil.getFixedThreadPool().execute(new RequestPreProcessing("0", workflowid, isbill, formid, Integer.valueOf(requestid), requestname, oldformsignaturemd5, currentnodeid, currentnodeid, false, "0", user, true));
	                       // }
	                    //}
	                //}
	                //推送处理end
	            }
		    }
	    }catch(Exception e){}
}


    //response.sendRedirect("/workflow/request/ViewRequest.jsp?requestid="+requestid);

}else{
    messageid="6";
}


//记录日志
rolm.flowTransSubmitAfter();
%>
<script language=javascript>
//关闭处理对话框





var forwardflag = <%=forwardflag%>
if($("#bodyiframe",window.parent.parent.document).length>0){		//流程处理界面转发
	var pwindow=window.parent.parent.document.getElementById("bodyiframe").contentWindow;
if(forwardflag==1){
	//alert("流程已转发成功");
	try {
		var pdialog = parent.parent.getDialog(window.parent);
		//var _document = $("#bodyiframe",window.parent.parent.document)[0].contentWindow.document;
		//jQuery("#lastOperateDate", _document).val("<%=CurrentDate %>");
		//jQuery("#lastOperateTime", _document).val("<%=CurrentTime %>");
		//jQuery("#lastOperator", _document).val("<%=user.getUID()%>");
		pdialog.close();
	} catch (e) {}
	//pwindow.parent.location.href="/workflow/request/ViewRequest.jsp?requestid=<%=requestid%>&message=<%=messageid%>";
	//刷新流转意见
	//pwindow.flipOver(-1);
	try {
		pwindow.jQuery("#oTDtype_0").children("a")[0].click();
		//pwindow.toggertab(0)
	} catch (e) {}
}else if(forwardflag==2){
	alert("<%=SystemEnv.getHtmlLabelName(84512,user.getLanguage())%>");
pwindow.parent.location.href="/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&message=<%=messageid%>";
	//刷新门户流程待办
	if(jQuery('#btnWfCenterReload',pwindow.parent.opener.document)[0]){
		pwindow.parent.opener.btnWfCenterReload.onclick();
	}
	//刷新流转意见
pwindow.flipOver(-1);
pwindow.parent.close();
pwindow.parent.opener._table.reLoad();
}else{
	alert("<%=SystemEnv.getHtmlLabelName(84513,user.getLanguage())%>");
pwindow.parent.location.href="/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&message=<%=messageid%>";
	//刷新门户流程待办
	if(jQuery('#btnWfCenterReload',pwindow.parent.opener.document)[0]){
		pwindow.parent.opener.btnWfCenterReload.onclick();
	}
	//刷新流转意见
	pwindow.flipOver(-1);
	pwindow.parent.close();
	pwindow.parent.opener._table.reLoad();
}
}else{		//流程列表行按钮转发





	try {
		var pdialog = parent.parent.getDialog(window.parent);
		pdialog.close();
	} catch (e) {}
	
	try {
		window.parent.parent.opener.parent.location.href = "/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&message=<%=messageid%>";
		window.parent.parent.close();
	} catch (e) {}
}
</script>