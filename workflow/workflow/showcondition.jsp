<!DOCTYPE html>
<%@ page import="weaver.general.Util" %>
<%@ page import="java.util.*,weaver.general.GCONST" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="OverTimeInfo" class="weaver.workflow.node.NodeOverTimeInfo" scope="page" />
<jsp:useBean id="bb" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="GetShowCondition" class="weaver.workflow.workflow.GetShowCondition" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<link rel="stylesheet" type="text/css" href="/css/xpSpin_wev8.css">
<!--For Spin Button-->
<SCRIPT type="text/javascript" src="/js/jquery/plugins/spin/jquery.spin_wev8.js"></script>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>

<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<style>
.shortw{width:60px !important;}
</style>


</HEAD>
<%
String overtimeset = bb.getPropValue(GCONST.getConfigFile() , "ecology.overtime");   
int conid = Util.getIntValue(request.getParameter("id"),0);

String isbill = Util.null2String(request.getParameter("isbill"));
String haspost = Util.null2String(request.getParameter("haspost"));
String isclear = Util.null2String(request.getParameter("isclear"));

int formid = Util.getIntValue(request.getParameter("formid"),0);
int design = Util.getIntValue(request.getParameter("design"),0);

//add by sean for TD3074
int fromBillManagement = Util.getIntValue(request.getParameter("fromBillManagement"),0);
int fromself = Util.getIntValue(request.getParameter("fromself"),0);
int linkid = Util.getIntValue(request.getParameter("linkid"),0);
String[] checkcons = request.getParameterValues("check_con");
conid = linkid;//赋值
String nodeid = "";

//workflowid
String workflowid = "";
rs.executeSql("select workflowid,nodeid from workflow_nodelink where id = " + linkid);
while(rs.next()){
	workflowid = Util.null2String(rs.getString("workflowid"));
	nodeid = Util.null2String(rs.getString("nodeid"));
}

WfRightManager wfrm = new WfRightManager();
boolean haspermission = wfrm.hasPermission3(Util.getIntValue(workflowid), 0, user, WfRightManager.OPERATION_CREATEDIR);
if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
    response.sendRedirect("/notice/noright.jsp") ;
    return ;
}

ArrayList ids = new ArrayList();
ArrayList colnames = new ArrayList();
ArrayList opts = new ArrayList();
ArrayList values = new ArrayList();
ArrayList names = new ArrayList();
ArrayList opt1s = new ArrayList();
ArrayList value1s = new ArrayList();

ArrayList seclevel_opts = new ArrayList();
ArrayList seclevel_values = new ArrayList();
ArrayList seclevel_opt1s = new ArrayList();
ArrayList seclevel_value1s = new ArrayList();
ids.clear();
colnames.clear();
opt1s.clear();
names.clear();
value1s.clear();
opts.clear();
values.clear();
seclevel_opts.clear();
seclevel_values.clear();
seclevel_opt1s.clear();
seclevel_value1s.clear();
//add by mackjoe at 2006-04-13 增加超时提醒功能
int NodePassHour=Util.getIntValue(request.getParameter("nodepasshour"),0);    //节点超时小时
int NodePassMinute=Util.getIntValue(request.getParameter("nodepassminute"),0); //节点超时分钟

String dateField=Util.null2String(request.getParameter("datefield"));      //日期字段
String timefield=Util.null2String(request.getParameter("timefield"));      //时间字段

String IsRemind=Util.null2String(request.getParameter("isremind"));      //是否消息提醒
int RemindHour=Util.getIntValue(request.getParameter("remindhour"),0);      //提前提醒小时
int RemindMinute=Util.getIntValue(request.getParameter("remindminute"),0);    //提前提醒分钟
String FlowRemind=Util.null2String(request.getParameter("FlowRemind"));    //工作流提醒;
String MsgRemind=Util.null2String(request.getParameter("MsgRemind"));     // 短信提醒;
String MailRemind=Util.null2String(request.getParameter("MailRemind"));    // 邮件提醒
String ChatsRemind=Util.null2String(request.getParameter("ChatsRemind"));     // 微信提醒(QC:98106);
String IsNodeOperator=Util.null2String(request.getParameter("isnodeoperator")); //提醒节点操作本人
String IsCreater=Util.null2String(request.getParameter("iscreater"));       //提醒创建人
String IsManager=Util.null2String(request.getParameter("ismanager"));       //提醒节点操作人经理
String IsOther=Util.null2String(request.getParameter("isother"));         //提醒指定对象
String RemindObjectIds=Util.null2String(request.getParameter("remindobjectids"));  //提醒的指定对象

int selectnodepass = Util.getIntValue(request.getParameter("selectnodepass"),1);

String InfoCentreRemind = Util.null2String(request.getParameter("InfoCentreRemind")); //消息中心提醒
int CustomWorkflowid=Util.getIntValue(request.getParameter("CustomWorkflowid"),0);     // 消息提醒中心

/********超时后提醒 start**********************/

String IsRemind_csh=Util.null2String(request.getParameter("isremind_csh"));      //是否消息提醒
int RemindHour_csh=Util.getIntValue(request.getParameter("remindhour_csh"),0);      //提前提醒小时
int RemindMinute_csh=Util.getIntValue(request.getParameter("remindminute_csh"),0);    //提前提醒分钟
String FlowRemind_csh=Util.null2String(request.getParameter("FlowRemind_csh"));    //工作流提醒;
String MsgRemind_csh=Util.null2String(request.getParameter("MsgRemind_csh"));     // 短信提醒;
String MailRemind_csh=Util.null2String(request.getParameter("MailRemind_csh"));    // 邮件提醒
String ChatsRemind_csh=Util.null2String(request.getParameter("ChatsRemind_csh"));     // 微信提醒(QC:98106);
String IsNodeOperator_csh=Util.null2String(request.getParameter("isnodeoperator_csh")); //提醒节点操作本人
String IsCreater_csh=Util.null2String(request.getParameter("iscreater_csh"));       //提醒创建人
String IsManager_csh=Util.null2String(request.getParameter("ismanager_csh"));       //提醒节点操作人经理
String IsOther_csh=Util.null2String(request.getParameter("isother_csh"));         //提醒指定对象
String RemindObjectIds_csh=Util.null2String(request.getParameter("remindobjectids_csh"));  //提醒的指定对象

String InfoCentreRemind_csh = Util.null2String(request.getParameter("InfoCentreRemind_csh")); //消息中心提醒
int CustomWorkflowid_csh=Util.getIntValue(request.getParameter("CustomWorkflowid_csh"),0);     // 消息提醒中心

String remindobjectnames_csh=OverTimeInfo.getResourceNameByResouceid(RemindObjectIds_csh);
/********超时后提醒 end************************/


String IsAutoFlow=Util.null2String(request.getParameter("isautoflow"));        //是否超时处理
String FlowNextOperator=Util.null2String(request.getParameter("flownextoperator"));   //自动流转至下一操作者
String FlowObjectIds=Util.null2String(request.getParameter("flowobjectids"));      //指定流程干预对象
String ProcessorOpinion=Util.null2String(request.getParameter("ProcessorOpinion"));      //处理意见
String remindobjectnames=OverTimeInfo.getResourceNameByResouceid(RemindObjectIds);
String flowobjectnames=OverTimeInfo.getResourceNameByResouceid(FlowObjectIds);

String flowobjectreject=Util.null2String(request.getParameter("flowobjectrejectids"));      //流程退回
String flowobjectsubmit=Util.null2String(request.getParameter("flowobjectsubmitids"));      //流程提交

String flowobjectrejectnames = OverTimeInfo.getNodeName(flowobjectreject);
String flowobjectsubmitnames = OverTimeInfo.getNodeName(flowobjectsubmit);


String sqlwherePara = Util.null2String(request.getParameter("sqlwhere"));
String sqlwherecnPara = Util.null2String(request.getParameter("sqlwherecn"));

String sqlwhere ="";
//add by xhheng @20050205 for TD 1537
String sqlwherecn="";

GetShowCondition.setSqlWhere(request,user);
sqlwhere = GetShowCondition.getsqlwhere();
sqlwherecn = GetShowCondition.getsqlwherecn();
ids = GetShowCondition.getids();
colnames = GetShowCondition.getcolnames();
opts = GetShowCondition.getopts();
values = GetShowCondition.getvalues();
names = GetShowCondition.getnames();
opt1s = GetShowCondition.getopt1s();
value1s = GetShowCondition.getvalue1s();
seclevel_opts = GetShowCondition.getseclevel_opts();
seclevel_values = GetShowCondition.getseclevel_values();
seclevel_opt1s = GetShowCondition.getseclevel_opt1s();
seclevel_value1s = GetShowCondition.getseclevel_value1s();

if(Util.null2String(request.getParameter("comefrom")).equals("1")){
	if(!sqlwhere.equals(""))
		sqlwhere = sqlwhere.substring(3);
//add by xhheng @20050205 for TD 1537
  if(!sqlwherecn.equals(""))
    sqlwherecn = sqlwherecn.substring(3);
}else{
	// modify by sean for TD3074
	if(fromBillManagement==1||design==1){
		/*
		rs.executeSql("select condition , conditioncn , nodepasstime  from workflow_nodelink where id="+linkid) ;
		if(rs.next()){
			sqlwhere = Util.null2String(rs.getString("condition"));
			sqlwherecn = Util.null2String(rs.getString("conditioncn"));
		}
		*/
		 //调整字段后新的读取方式开始
			 String strSql = "select condition , conditioncn , nodepasstime  from workflow_nodelink where id="+linkid;
			 weaver.conn.ConnStatement statement=new weaver.conn.ConnStatement();
		   	 statement.setStatementSql(strSql, false);
		   	 statement.executeQuery();
			if(statement.next()){
			  	 if(rs.getDBType().equals("oracle"))
			  	 {
				  		oracle.sql.CLOB theclob = statement.getClob("condition"); 
				  		String readline = "";
				        StringBuffer clobStrBuff = new StringBuffer("");
				        if(theclob!=null){
							java.io.BufferedReader clobin = new java.io.BufferedReader(theclob.getCharacterStream());
							while ((readline = clobin.readLine()) != null) clobStrBuff = clobStrBuff.append(readline);
							clobin.close() ;
						}
				        sqlwhere = clobStrBuff.toString();
				        
				        oracle.sql.CLOB theclob2 = statement.getClob("conditioncn"); 
				  		String readline2 = "";
				        StringBuffer clobStrBuff2 = new StringBuffer("");
				        if(theclob2!=null){
							java.io.BufferedReader clobin2 = new java.io.BufferedReader(theclob2.getCharacterStream());
							while ((readline2 = clobin2.readLine()) != null) clobStrBuff2 = clobStrBuff2.append(readline2);
							clobin2.close() ;
						}
				        sqlwherecn = clobStrBuff2.toString();
			  	  }else{
			  		  sqlwhere=statement.getString("condition");
			  		  sqlwherecn=statement.getString("conditioncn");
			  }
			}
		  	//调整字段后新的读取方式结束
	}else{
			sqlwhere = Util.null2String((String)request.getSession(true).getAttribute("por"+conid+"_con"));
		   //add by xhheng @20050205 for TD 1537
		   sqlwherecn = Util.null2String((String)request.getSession(true).getAttribute("por"+conid+"_con_cn"));
	}
}

//String operatortype = Util.null2String(request.getParameter("operatortype"));
/*if(!sqlwhere.equals("")){
    if(!sqlwherePara.equals("")){
        if(operatortype.equals("and")){
            sqlwhere = "("+sqlwherePara+") and ("+sqlwhere+")";
            sqlwherecn = "("+sqlwherecnPara+") "+SystemEnv.getHtmlLabelName(18760,user.getLanguage())+" ("+sqlwherecn+")";
        }else{
            sqlwhere = "(("+sqlwherePara+") or ("+sqlwhere+"))";
            sqlwherecn = "(("+sqlwherecnPara+") "+SystemEnv.getHtmlLabelName(21695,user.getLanguage())+" ("+sqlwherecn+"))";
        }
    }
}else{
    sqlwhere = sqlwherePara;
    sqlwherecn = sqlwherecnPara;
}*/

if(haspost.equals("1")){
	request.getSession(true).setAttribute("por"+conid+"_con",sqlwhere);
  //add by xhheng @20050205 for TD 1537
  request.getSession(true).setAttribute("por"+conid+"_con_cn",sqlwherecn);
	if (!overtimeset.equals("")) {
	    
	    RecordSet rs5 = new RecordSet();
	    rs5.executeSql("select condition , conditioncn , nodepasstime  from workflow_nodelink where id="+linkid);
	    
	    if (rs5.next()) {
	        sqlwhere = Util.null2String(rs5.getString("condition"));
	        sqlwherecn = Util.null2String(rs5.getString("conditioncn"));
	    }
    OverTimeInfo.init();
    OverTimeInfo.setCondition(sqlwhere);
    OverTimeInfo.setConditionCn(sqlwherecn);
    OverTimeInfo.setIsRemind(IsRemind);
    OverTimeInfo.setNodePassHour(NodePassHour);
    OverTimeInfo.setNodePassMinute(NodePassMinute);
    OverTimeInfo.setDateField(dateField);
    OverTimeInfo.setTimeField(timefield);
    
    OverTimeInfo.setRemindHour(RemindHour);
    OverTimeInfo.setRemindMinute(RemindMinute);
    OverTimeInfo.setFlowRemind(FlowRemind);
    OverTimeInfo.setMsgRemind(MsgRemind);
    OverTimeInfo.setMailRemind(MailRemind);
    OverTimeInfo.setChatsRemind(ChatsRemind);//微信提醒(QC:98106)
    OverTimeInfo.setIsNodeOperator(IsNodeOperator);
    OverTimeInfo.setIsCreater(IsCreater);
    OverTimeInfo.setIsManager(IsManager);
    OverTimeInfo.setIsOther(IsOther);
    OverTimeInfo.setRemindObjectIds(RemindObjectIds);
    
    OverTimeInfo.setSelectnodepass(selectnodepass);
    OverTimeInfo.setIsRemind_csh(IsRemind_csh);
    OverTimeInfo.setRemindHour_csh(RemindHour_csh);
    OverTimeInfo.setRemindMinute_csh(RemindMinute_csh);
    OverTimeInfo.setFlowRemind_csh(FlowRemind_csh);
    OverTimeInfo.setMsgRemind_csh(MsgRemind_csh);
    OverTimeInfo.setMailRemind_csh(MailRemind_csh);
    OverTimeInfo.setChatsRemind_csh(ChatsRemind_csh);//微信提醒(QC:98106)
    OverTimeInfo.setIsNodeOperator_csh(IsNodeOperator_csh);
    OverTimeInfo.setIsCreater_csh(IsCreater_csh);
    OverTimeInfo.setIsManager_csh(IsManager_csh);
    OverTimeInfo.setIsOther_csh(IsOther_csh);
    OverTimeInfo.setRemindObjectIds_csh(RemindObjectIds_csh);
    
    OverTimeInfo.setIsAutoFlow(IsAutoFlow);
    OverTimeInfo.setFlowNextOperator(FlowNextOperator);
    OverTimeInfo.setFlowObjectIds(FlowObjectIds);
    OverTimeInfo.setProcessorOpinion(ProcessorOpinion);    
    
    OverTimeInfo.setFlowobjectreject(flowobjectreject);
    OverTimeInfo.setFlowobjectsubmit(flowobjectsubmit);
    
    OverTimeInfo.setCustomWorkflowid(CustomWorkflowid);
    OverTimeInfo.setInfoCentreRemind(InfoCentreRemind);
    
    OverTimeInfo.setCustomWorkflowid_csh(CustomWorkflowid_csh);
    OverTimeInfo.setInfoCentreRemind_csh(InfoCentreRemind_csh);
    
    OverTimeInfo.updateOverTimeInfo(linkid);
	}
    // add by sean for TD3074
 /*   boolean isOracle = rs.getDBType().equals("oracle");
	if(fromBillManagement==1||design==1||fromself==1){
		String savenode = "update workflow_nodelink set condition=?,conditioncn=?,nodepasstime=? where id=?";
		if(isOracle)
		    savenode = "update workflow_nodelink set condition=empty_clob(),conditioncn=empty_clob(),nodepasstime=? where id=?";
		ConnStatement statement = new ConnStatement();
		try{
			if(!isOracle){
			  statement.setStatementSql(savenode);
			  statement.setString(1 , sqlwhere);
			  statement.setString(2 , sqlwherecn);
			  statement.setFloat(3 , -1F);
			  statement.setInt(4 , linkid);
			}else{
			  statement.setStatementSql(savenode);
			  statement.setFloat(1 , -1F);
			  statement.setInt(2 , linkid);
			}
			  statement.executeUpdate();
		   if(isOracle){
				String sql = "select condition,conditioncn from workflow_nodelink where id = " +linkid;
                statement.setStatementSql(sql, false);
                statement.executeQuery();
                statement.next();
                oracle.sql.CLOB theclob = statement.getClob(1);
                oracle.sql.CLOB theclob2 = statement.getClob(2);

                char[] contentchar = sqlwhere.toCharArray();
                java.io.Writer contentwrite = theclob.getCharacterOutputStream();
                contentwrite.write(contentchar);
                contentwrite.flush();
                contentwrite.close();
                
                char[] contentchar2 = sqlwherecn.toCharArray();
                java.io.Writer contentwrite2 = theclob2.getCharacterOutputStream();
                contentwrite2.write(contentchar2);
                contentwrite2.flush();
                contentwrite2.close();
			 }
		  }
		catch(Exception e) {
			  throw e ;
		}
		finally {
			  try { statement.close();}catch(Exception ex) {}
		}
	}

*/

}else{
    //add by mackjoe at 2006-04-13 增加超时提醒功能
	 if (!overtimeset.equals("")){
    OverTimeInfo.init();
    OverTimeInfo.getNodelinkOverTimeInfo(linkid);
    NodePassHour=OverTimeInfo.getNodePassHour();    //节点超时小时
    NodePassMinute=OverTimeInfo.getNodePassMinute(); //节点超时分钟
    dateField = OverTimeInfo.getDateField();   //节点超时日期字段
    timefield = OverTimeInfo.getTimeField();   //节点超时时间字段
    
    IsRemind=OverTimeInfo.getIsRemind();      //是否消息提醒
    RemindHour=OverTimeInfo.getRemindHour();      //提前提醒小时
    RemindMinute=OverTimeInfo.getRemindMinute();    //提前提醒分钟
    FlowRemind=OverTimeInfo.getFlowRemind();    //工作流提醒;
    MsgRemind=OverTimeInfo.getMsgRemind();     // 短信提醒;
    MailRemind=OverTimeInfo.getMailRemind();    //邮件提醒
    ChatsRemind=OverTimeInfo.getChatsRemind();     // 微信提醒(QC:98106);
    IsNodeOperator=OverTimeInfo.getIsNodeOperator(); //提醒节点操作本人
    IsCreater=OverTimeInfo.getIsCreater();       //提醒创建人
    IsManager=OverTimeInfo.getIsManager();       //提醒节点操作人经理
    IsOther=OverTimeInfo.getIsOther();         //提醒指定对象
    RemindObjectIds=OverTimeInfo.getRemindObjectIds();  //提醒的指定对象
    
    selectnodepass = OverTimeInfo.getSelectnodepass();
    
    InfoCentreRemind = OverTimeInfo.getInfoCentreRemind();
    CustomWorkflowid = OverTimeInfo.getCustomWorkflowid();
    
    /******超时后提醒start******/
    IsRemind_csh=OverTimeInfo.getIsRemind_csh();      //是否消息提醒
    RemindHour_csh=OverTimeInfo.getRemindHour_csh();      //提前提醒小时
    RemindMinute_csh=OverTimeInfo.getRemindMinute_csh();    //提前提醒分钟
    FlowRemind_csh=OverTimeInfo.getFlowRemind_csh();    //工作流提醒;
    MsgRemind_csh=OverTimeInfo.getMsgRemind_csh();     // 短信提醒;
    MailRemind_csh=OverTimeInfo.getMailRemind_csh();    //邮件提醒
    ChatsRemind_csh=OverTimeInfo.getChatsRemind_csh();
    IsNodeOperator_csh=OverTimeInfo.getIsNodeOperator_csh(); //提醒节点操作本人
    IsCreater_csh=OverTimeInfo.getIsCreater_csh();       //提醒创建人
    IsManager_csh=OverTimeInfo.getIsManager_csh();       //提醒节点操作人经理
    IsOther_csh=OverTimeInfo.getIsOther_csh();         //提醒指定对象
    RemindObjectIds_csh=OverTimeInfo.getRemindObjectIds_csh();  //提醒的指定对象
    remindobjectnames_csh=OverTimeInfo.getResourceNameByResouceid(RemindObjectIds_csh);
    
    InfoCentreRemind_csh = OverTimeInfo.getInfoCentreRemind_csh();
    CustomWorkflowid_csh = OverTimeInfo.getCustomWorkflowid_csh();

    /******超时后提醒end******/
    
    IsAutoFlow=OverTimeInfo.getIsAutoFlow();        //是否超时处理
    FlowNextOperator=OverTimeInfo.getFlowNextOperator();   //自动流转至下一操作者
    FlowObjectIds=OverTimeInfo.getFlowObjectIds();      //指定流程干预对象
    ProcessorOpinion=OverTimeInfo.getProcessorOpinion();//处理意见
    flowobjectreject = OverTimeInfo.getFlowobjectreject();
    flowobjectsubmit = OverTimeInfo.getFlowobjectsubmit();
    flowobjectrejectnames = OverTimeInfo.getNodeName(flowobjectreject);
	flowobjectsubmitnames = OverTimeInfo.getNodeName(flowobjectsubmit);
    remindobjectnames=OverTimeInfo.getResourceNameByResouceid(RemindObjectIds);
    flowobjectnames=OverTimeInfo.getResourceNameByResouceid(FlowObjectIds);
	 }
}
int maxBeforeHour = 0; // 已设置的最大超时前提醒小时
int maxBeforeMinute = 0; // 已设置的最大超时前提醒分钟
rs.executeSql("select * from workflow_nodelinkOverTime where remindtype = 0 and linkid=" + linkid + " order by remindhour desc, remindminute desc ,id");
if(rs.next()) {
	maxBeforeHour = Util.getIntValue(Util.null2String(rs.getString("remindhour")), 0);
	maxBeforeMinute = Util.getIntValue(Util.null2String(rs.getString("remindminute")), 0);
}
if(isclear.equals("1")){
	request.getSession(true).setAttribute("por"+conid+"_con","");
  //add by xhheng @20050205 for TD 1537
  request.getSession(true).setAttribute("por"+conid+"_con_cn","");
  
  
  OverTimeInfo.init();
  RecordSet rs5 = new RecordSet();
  rs5.executeSql("select condition , conditioncn , nodepasstime  from workflow_nodelink where id="+linkid);
  
  if (rs5.next()) {
      OverTimeInfo.setCondition(rs5.getString("condition"));
      OverTimeInfo.setConditionCn(Util.null2String(rs5.getString("conditioncn")));
  }
  OverTimeInfo.updateOverTimeInfo(linkid);
  // add by sean for TD3074
  rs.executeSql("delete from workflow_nodelinkOverTime where linkid=" + linkid); // 清除所有超时提醒
	if(fromBillManagement==1||design==1){
		String sql = "update workflow_nodelink  set nodepasstime = -1  where id="+linkid;
		if(rs.getDBType().equals("oracle"))
            sql = "update workflow_nodelink set nodepasstime = -1 where id="+linkid;
		rs.executeSql(sql);
	}

}
boolean showovertimeset=OverTimeInfo.getIsCreateOrReject(linkid);
%>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript">
function onShowRuleBrowser(inputid, spanid) {
	var result = window.showModalDialog("/workflow/ruleDesign/ruleBrowser.jsp", window);
	if (!!result) {
		if (result.id == "") {
			jQuery("#mappingb").hide();
		} else {
			jQuery("#mappingb").show();
		}
 		jQuery("#" + inputid).val(result.id);
		jQuery("#" + spanid).html("<a href='#"+result.id+"'>"+result.name+"</a>");
	}
}

function showMapping(event,data,name,paras){
	if($("#ruleid").val()!=""){
		jQuery("#mappingb").show();
	}
}

function _userDelCallback(text,name){
	jQuery("#mappingb").hide();
}

function doReturnSpanHtml(obj){
	var t_x = obj.substring(0, 1);
	if(t_x == ','){
		t_x = obj.substring(1, obj.length);
	}else{
		t_x = obj;
	}
	return t_x;
}

function btnok_onclick(){
	 $G("haspost").value = "1";
	 document.SearchForm.submit();
}

function btnclear_onclick(){
	 $G("isclear").value = "1";
	 document.SearchForm.submit();
}


function onShowBrowser(id,url){
	url= url+"?selectedids="+$("input[name=con"+id+"_value]").val()
	datas = window.showModalDialog(url);
	if(datas){
	     if(datas.id!=""){
	    	 spanNameHtml=doReturnSpanHtml(datas.name);
			$("#con"+id+"_valuespan").html(spanNameHtml);
			$("input[name=con"+id+"_value]").val(doReturnSpanHtml(datas.id));
			$("input[name=con"+id+"_name]").val(spanNameHtml);
	    }else{
	    	$("#con"+id+"_valuespan").html("");
			$("input[name=con"+id+"_value]").val("");
			$("input[name=con"+id+"_name]").val("");
		}
	}
}

function changelevel(tmpindex){
	document.SearchForm.check_con[tmpindex*1].checked = true;
}

function callbackMeth(event,datas,name,paras){
	if(datas.id!=""){
		setChecked(name,true);
	}else{
		setChecked(name,false);
	}
}

function setChecked(name,checked){
	var obj;
	if(name=="CustomWorkflowid"){
		obj = $("#InfoCentreRemind")
		obj.attr("checked",checked);		
	}else if(name=="remindobjectids"){
		obj = $("#isother");
		obj.attr("checked",checked);
	}else if(name=="CustomWorkflowid_csh"){
		obj = $("#InfoCentreRemind_csh");
		obj.attr("checked",checked);
	}else if(name=="remindobjectids_csh"){
		obj = $("#isother_csh");
		obj.attr("checked",checked);
	}
	if(obj){
		if(checked){
			obj.next().addClass("jNiceChecked");
		}else{
			obj.next().removeClass("jNiceChecked");
		}
	}	
}

function getRejectUrlFun(){
    return "/systeminfo/BrowserMain.jsp?url=/workflow/request/RejectNodeSet2.jsp?workflowid=<%=workflowid%>&nodeid=<%=nodeid%>";
}

function getSubmitUrlFun(){
    return "/systeminfo/BrowserMain.jsp?url=/workflow/request/SubmitNodeSet.jsp?workflowid=<%=workflowid%>&nodeid=<%=nodeid%>";
}

function callbackRadio(event,datas,name,paras){
	var checkIndex;
	if(name=="flowobjectids"){
		checkIndex="0";
	}else if(name=="flowobjectrejectids"){
		checkIndex="3";
	}else if(name=="flowobjectsubmitids"){
		checkIndex="4";
	}
	if(datas.id!=""&&checkIndex!=""){
    	$("input[name=flownextoperator]").each(function(){
    		if($(this).val()==checkIndex){
    			$(this).attr("checked",true).next().addClass("jNiceChecked");
    		}else{
    			$(this).attr("checked",false).next().removeClass("jNiceChecked");
    		}	    		
    	});
    	clickFlownextoperator();
	}
}

function submitData(obj){
	var selectnodepass = $("#selectnodepass").val();
 	if( (selectnodepass==1 && ($G("nodepassminute").value>0 || SearchForm.nodepasshour.value>0)) || (selectnodepass==2 &&SearchForm.datefield.value!='')){
	}else{
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32454,user.getLanguage())%>");
		return;
	}
    if(SearchForm.isautoflow.checked){
        if(!document.all("flownextoperator")[0].checked && !document.all("flownextoperator")[1].checked 
         && !document.all("flownextoperator")[2].checked  && !document.all("flownextoperator")[3].checked ){
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18869,user.getLanguage())%>");
            return;
        }
		var flowobjectids = document.getElementById("flowobjectids").value;
		var flowobjectrejectids = document.getElementById("flowobjectrejectids").value;
		var flowobjectsubmitids = document.getElementById("flowobjectsubmitids").value;
		if(document.all("flownextoperator")[1].checked && flowobjectids==""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32702,user.getLanguage())%>");
            return;
		}
		if(document.all("flownextoperator")[2].checked && flowobjectrejectids==""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32772,user.getLanguage())%>");
            return;
		}
		if(document.all("flownextoperator")[3].checked && flowobjectsubmitids==""){
			window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32773,user.getLanguage())%>");
            return;
		}
	}
    if(checkremindhour()){
    	enableAllmenu();
	    obj.disabled = true;
		btnok_onclick();
    }
}

function submitClear(){
	enableAllmenu();
	btnclear_onclick();
}

function changejNice(type,list){
	for(var i = 0;i<list.length;i++){
		var objName = list[i];
		if(type===0){
			$("input[name="+objName+"]").next().removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled");
		}else{
			$("input[name="+objName+"]").next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
		}
	}
}

/**
 * liuzy 控制显示隐藏
 */
function changeCheck(remind){
	var selectnodepass = $("#selectnodepass").val();
	var name_obj=null
    if(remind==1){
    	name_obj=$("[name='isremind']")
    }else if(remind==2){
    	name_obj=$("[name='isremind_csh']");
    }else if(remind==3){
    	name_obj=$("[name='isautoflow']");
    }
    if(name_obj.attr("checked")){
        if( (selectnodepass==1 && ($G("nodepassminute").value>0 || SearchForm.nodepasshour.value>0)) || (selectnodepass==2 &&SearchForm.datefield.value!='')){
            name_obj.closest("tbody").find("tr:gt(0)").css("display","");
        }else{
        	window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32454,user.getLanguage())%>");
        	//name_obj.attr("checked",false).next().removeClass("jNiceChecked");
			jQuery(name_obj).trigger("checked", false);
        }
    }else{
        name_obj.closest("tbody").find("tr:gt(0)").css("display","none");
    }
}

function checkremindhour(){
	if(<%=maxBeforeHour %> == 0 && <%=maxBeforeMinute %> == 0){
    	return true;
    }
    var rehour = "<%=maxBeforeHour %>";
    rehour=rehour==""?0:parseInt(rehour);
    
    var nodehour=SearchForm.nodepasshour.value;
    nodehour=nodehour==""?0:parseInt(nodehour);
    
    if(!rehour>0){
        rehour=0;
    }
    if(!nodehour>0){
        nodehour=0;
    }
    
    var selectnodetype = SearchForm.selectnodepass.value;
    
    if(rehour>nodehour && selectnodetype!='2'){
        //SearchForm.remindhour.value="";
        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125905,user.getLanguage())%>");
        SearchForm.nodepasshour.focus();
        return false;
    }else{
	    if(rehour==nodehour&& parseInt("<%=maxBeforeMinute %>")>parseInt($G("nodepassminute").value)  && selectnodetype!='2'){
	        //$G("remindminute").value=$G("nodepassminute").value;
	        window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(125905,user.getLanguage())%>");
	        $G("nodepassminute").focus();
	        return false;
	    }
    }
    return true;
}

function checkdatefield(o){
	var datefield = document.getElementById("datefield").value;
	if(datefield==""){
	    //document.getElementById("timefield").value = "";
	    //document.getElementById("datefield").focus();
	    jQuery("#datefieldSpan").show();
	}else {
		jQuery("#datefieldSpan").hide();
	}
	
}
function setSelectTitle(obj)
{
	var options = obj.options;
	for(var i = 0;i<options.length;i++)
	{
		var option = options[i];
		if(option.selected)
		{
			obj.title=option.title;
		}
	}
}

function selectnodepasstype(){
	var type = $("[name='selectnodepass']").val();
	if(type=="1"){
	    $("#nodepasstable").css("display","block");
	    $("#fieldtable").css("display","none");
	}else{
	    $("#nodepasstable").css("display","none");
	    $("#fieldtable").css("display","block");
	}
}

var parentWin = null;
var dialog = null;
try {
	parentWin = parent.parent.getParentWindow(parent);
	dialog = parent.parent.getDialog(parent);
	//dialog = parent.parent.parent.getDialog(parent.window);
} catch (e) {
}


if ("<%=haspost%>" == "1"){
//add by xhheng @20050205 for TD 1537,用";"隔离英中文sqlwhere\
if(dialog){
	dialog.close();
}
    <%if(sqlwhere.equals("")){%>
   		window.parent.parent.returnValue = "";
    <%}else{%>
		window.parent.parent.returnValue = "<%=xssUtil.put(sqlwhere)+";"+xssUtil.put(sqlwherecn)%>";
	<%}if(design==1){%>
		window.parent.design_callback("showcondition","true");
	<%}else{%>
		//window.parent.parent.close();
		//window.parent.close();
	<%}%>
}
if ("<%=isclear%>" == "1"){
	//window.parent.returnValue = "";
	var returnjson  = "";
	
	if(dialog){
		try{
	        dialog.callback(returnjson);
	    }catch(e){}
		try{
	     	dialog.close(returnjson);
	 	}catch(e){}
	}
	<%if(design==1){%>
		window.parent.returnValue = "";
		window.parent.design_callback("showcondition","false");
	<%}else{%>
		window.parent.returnValue = "";
		//window.parent.parent.close();
		//window.parent.close();
	<%}%>
}

jQuery(document).ready(function(){
   jQuery(".spin").each(function(){
      var $this=jQuery(this);
      var min=$this.attr("min");
      var max=$this.attr("max");
      $this.spin({max:max,min:min});
      $this.blur(function(){
          var value=$this.val();
          if(isNaN(value))
            $this.val(0);
          else{
            value =parseInt(value); 
            if(value>59)
               $this.val(59);
            else if(value<0)
               $this.val(0);
            else
               $this.val(value); 
               
           if($this.val()=='NaN')
               $this.val(0);                         
          }  
      });
   });
   selectnodepasstype();
   changeCheck(1);
   changeCheck(2);
   changeCheck(3);
   checkdatefield();
   clickFlownextoperator();
});

function onShowBrowser2(id,type1,url){
  id1 = window.showModalDialog(url,window);
  if(id1){
    if(wuiUtil.getJsonValueByIndex(id1,0)!= ""){
       ids = doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1,0));
       names =wuiUtil.getJsonValueByIndex(id1,1);
       //descs =wuiUtil.getJsonValueByIndex(id1,2);
	   if(type1 == 161){
	     names=names.substr(1);
	     $G("con"+id+"_valuespan").innerHTML = "<a title='"+ids+"'>"+names+"</a>&nbsp;";
	     $G("con"+id+"_value").value=ids;
	     $G("con"+id+"_name").value=names;
      }
	if(type1==224){
		$G("con"+id+"_valuespan").innerHTML = names;
		$G("con"+id+"_value").value=ids;
		$G("con"+id+"_name").value=names;
	}
	if(type1==226||type1==227){
		$G("con"+id+"_valuespan").innerHTML = names;
		$G("con"+id+"_value").value=ids;
		$G("con"+id+"_name").value=names;
	}
    if(type1 == 162){
       sHtml = "";
       var idsArray=ids.split(",");
       var namesArray=names.split(",");
       //var descArray=descs.split(",");
       for(var i=0;i<idsArray.length;i++){
         if(idsArray[i]!="")
            sHtml = sHtml+"<a title='"+ids[i]+"' >"+namesArray[i]+"</a>&nbsp;";
       }
       $G("con"+id+"_valuespan").innerHTML = sHtml;
       $G("con"+id+"_value").value=doReturnSpanHtml(wuiUtil.getJsonValueByIndex(id1,0));
       $G("con"+id+"_name").value=wuiUtil.getJsonValueByIndex(id1,1);
    }
   }else{
	    $G("con"+id+"_valuespan").innerHTML ="";
	    $G("con"+id+"_value").value="";
	    $G("con"+id+"_name").value="";
   }
  }
}

function setCheckBox(name){
	if(name.indexOf("InfoCentreRemind_csh")!=-1){
		document.getElementById("InfoCentreRemind_csh").checked = true;	
	}else{
		document.getElementById("InfoCentreRemind").checked = true;
		$("#InfoCentreRemind").next().addClass("jNiceChecked");
	}
}

var diag_rulemapping = null;

function ruleMapping(ruleid, linkid, formid, isbill) {
	var url ="/workflow/ruleDesign/ruleMapping.jsp?ismodal=1&ruleid=" + ruleid + "&linkid=" + linkid + "&formid=" + formid + "&isbill=" + isbill + "&date=" + new Date().getTime();
	var result = window.showModalDialog(url, window);
}
</script>

<BODY>



<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:submitData(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(199,user.getLanguage())+",javascript:document.SearchForm.reset(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(15504,user.getLanguage())+",javascript:submitClear(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" onclick="submitData(this)" />
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="showcondition.jsp" method="post">
<input type="hidden" value="<%=design%>" name="design">
<input type="hidden" value="0" name="fromself">
<input type="hidden" value="<%=conid%>" name="id">
<input type="hidden" value="<%=formid%>" name="formid">
<input type=hidden name=isbill value="<%=isbill%>">
<input type=hidden name=workflowid value="<%=workflowid%>">
<input type=hidden name=haspost value="">
<input type=hidden name=isclear value="">
<input type=hidden name=comefrom value="1">
<input type=hidden name=fromBillManagement value="<%=fromBillManagement%>">
<input type=hidden name=linkid value="<%=linkid%>">
<input type=hidden name=sqlwhere value="<%=xssUtil.put(sqlwhere)%>">
<input type=hidden name=sqlwherecn value="<%=xssUtil.put(sqlwherecn)%>">
<!-- 
<input type=hidden name=operatortype value="and">
 -->
<%
	int ruleid = 0;
	String ruleName = "";
	String ruledesc = "";
%>
<wea:layout type="2col">
	<% if (!overtimeset.equals("") && !showovertimeset){	%>
	<wea:group context='<%=SystemEnv.getHtmlLabelNames("22942,33508",user.getLanguage())%>'>
		<wea:item >
          	<%=SystemEnv.getHtmlLabelName(33856,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<div style="float:left;">
	          	<select id="selectnodepass" name="selectnodepass" onchange="selectnodepasstype()">
	          		<option value="1" <%if(selectnodepass==1){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(32340,user.getLanguage())%></option>
	          		<option value="2" <%if(selectnodepass==2){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(32341,user.getLanguage())%></option>
	          	</select>	
          	</div>
          	<div style="width:50px!important;height:1px;float:left;"></div>
          	<div id="nodepasstable" style="float:left;display:none;">
				<%=SystemEnv.getHtmlLabelName(2068,user.getLanguage())%>
				<input type="text" class="shortw" name="nodepasshour"  id ="nodepasshour" value="<%if(NodePassHour>0){%><%=NodePassHour%><%}%>" onKeyPress="ItemCount_KeyPress()" onBlur='checkcount1(this);if(this.value<0) this.value="";'><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%>&nbsp;&nbsp;
				<input type="text" class="shortw spin height " onkeypress="ItemCount_KeyPress()" onblur="checkNum(this);" id="nodepassminute" name="nodepassminute"  min="0" max="59" value="<%=NodePassMinute%>"><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%>
				<script type="text/javascript">
				function checkNum(obj) {
					var mintue = obj.value;
					if(isNaN(mintue)) { 
						obj.value = 0;
					}
				}
				</script>
			</div>	
			<div id="fieldtable" style="float: left; display: none;">
			<%=SystemEnv.getHtmlLabelName(22941,user.getLanguage())%>
			<select id="datefield" name="datefield" onchange="checkdatefield('date')" style="width:100px;" >
				<option value=""></option>
				 <% 
				 	String sqlo = "";
				 	if("1".equals(isbill)){
				 		sqlo = "select distinct b.id,b.billid,b.fieldname,b.fieldlabel,h.labelname,h.languageid from workflow_billfield b,HtmlLabelInfo h where b.fieldlabel=h.indexid and (detailtable is null or detailtable='') and b.type=2 and b.fieldhtmltype=3 and billid="+formid+" and h.languageid="+user.getLanguage();
				 	}else{
				 		 sqlo = "select fieldname,h.fieldlable as labelname from workflow_formfield,(select distinct id,fieldname,type,fieldhtmltype,fielddbtype,description from workflow_formdict) a,workflow_fieldlable h "+
								" where workflow_formfield.fieldid = h.fieldid and h.formid=workflow_formfield.formid and h.langurageid="+user.getLanguage()+" and workflow_formfield.formid=" + formid+ " and type=2 and fieldhtmltype=3 and "+
				     			" (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and a.id=workflow_formfield.fieldid order by workflow_formfield.fieldorder"; 
				 	}
				
				 	rs.executeSql(sqlo);
				 	String fieldname = "";
				 	while(rs.next()){
				 		String select = "";
				 		fieldname = rs.getString("fieldname");
				 		if(dateField.equals(fieldname)){
				 			select = " selected=\"selected\" ";
				 		}
				 		out.println("<option value=\""+fieldname+"\" "+select+">"+rs.getString("labelname")+"</option>");
				 	}
				 %>
			</select>
			<span id="datefieldSpan">
				<img align="absmiddle" src="/images/BacoError_wev8.gif" />
			</span>
			&nbsp;&nbsp;&nbsp;&nbsp;
			<%=SystemEnv.getHtmlLabelName(22942,user.getLanguage())%>
    		<select id="timefield" name="timefield" onclick="checkdatefield('time')"  style="width:100px;" >
    	  		<option value=""></option>
    	    	<% 
    	    	sqlo = "";
    	    	if("1".equals(isbill)){
    	    		sqlo = "select distinct b.id,b.billid,b.fieldname,b.fieldlabel,h.labelname,h.languageid from workflow_billfield b,HtmlLabelInfo h where b.fieldlabel=h.indexid and (detailtable is null or detailtable='') and b.type=19 and b.fieldhtmltype=3 and billid="+formid+" and h.languageid="+user.getLanguage();
    	    	}else{
    	    		sqlo = "select fieldname,h.fieldlable as labelname from workflow_formfield,(select distinct id,fieldname,type,fieldhtmltype,fielddbtype,description from workflow_formdict) a,workflow_fieldlable h "+
					 		" where workflow_formfield.fieldid = h.fieldid and h.formid=workflow_formfield.formid and h.langurageid="+user.getLanguage()+" and workflow_formfield.formid=" + formid+ " and type=19 and fieldhtmltype=3 and "+
					        " (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and a.id=workflow_formfield.fieldid order by workflow_formfield.fieldorder";						    
    	    	}
    	    	
    	    	rs.executeSql(sqlo);
    	    	fieldname = "";
    	    	while(rs.next()){
    	    		String select = "";
    	    		fieldname = rs.getString("fieldname");
    	    		if(timefield.equals(fieldname)){
    	    			select = " selected=\"selected\" ";
    	    		}
    	    		//System.out.println("<option value=\""+fieldname+"\" "+select+">"+rs.getString("labelname")+"</option>");
    	    		out.println("<option value=\""+fieldname+"\" "+select+">"+rs.getString("labelname")+"</option>");
    	    	}
    	    %>
    		</select>
    		&nbsp;&nbsp;
			<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(125746, user.getLanguage()) %>">
				<img src="/images/tooltip_wev8.png" align="absMiddle" />
			</span>
    		</div>
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(18848,user.getLanguage())%>' attributes="{'itemAreaDisplay':''}">
		<wea:item><%=SystemEnv.getHtmlLabelName(18848,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" name="isautoflow" value="1" <%=IsAutoFlow.equals("1")?"checked":"" %> onclick="changeCheck(3)" tzCheckbox="true"> 		
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("18848,599",user.getLanguage()) %></wea:item>
		<wea:item>
			<span style="float: left;">
			<input type="radio"  id="flownextoperator" name="flownextoperator"  value="1" onclick="clickFlownextoperator()" <%if(FlowNextOperator.equals("1")){%>checked<%}%> ><%=SystemEnv.getHtmlLabelName(18849,user.getLanguage())%>
	        </span>
		</wea:item>
		<wea:item></wea:item>
		<wea:item>
			<span style="float: left; width: 150px;">
				<input type="radio" id="flownextoperator"  name="flownextoperator" value="0" onclick="clickFlownextoperator()" <%if(FlowNextOperator.equals("0")){%>checked<%}%> ><%=SystemEnv.getHtmlLabelName(18847,user.getLanguage())%>
			</span>
			<brow:browser name="flowobjectids" viewType="0" hasBrowser="true" hasAdd="false" 
	        		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
	                _callback="callbackRadio" isMustInput="2" isSingle="false" hasInput="true"
	                completeUrl="/data.jsp"  width="150px" browserValue='<%=FlowObjectIds %>' browserSpanValue='<%=flowobjectnames %>' />     
	         <input type=hidden name="flowobjectnames" value="<%=flowobjectnames%>">
		</wea:item>
		<wea:item> </wea:item>
		<wea:item>
			<span style="float: left; width: 150px;">
				<input type="radio" id="flownextoperator"  name="flownextoperator" value="3" onclick="clickFlownextoperator()"
				<%if(FlowNextOperator.equals("3")){%>checked<%}%> ><%=SystemEnv.getHtmlLabelName(31855,user.getLanguage())%>
	        </span>
	        <brow:browser name="flowobjectrejectids" viewType="0" hasBrowser="true" hasAdd="false" 
	                getBrowserUrlFn="getRejectUrlFun" _callback="callbackRadio"
	                isMustInput="2" isSingle="true" hasInput="false"
	                completeUrl="/data.jsp"  width="150px" browserValue='<%=flowobjectreject%>' browserSpanValue='<%=flowobjectrejectnames%>' />
	       	<input type=hidden name="flowobjectrejectnames" value="<%=flowobjectrejectnames%>">     	
		</wea:item>
		<wea:item> </wea:item>
		<wea:item>
			<span style="float: left; width: 150px;">
	        	<input type="radio" id="flownextoperator"  name="flownextoperator" value="4" onclick="clickFlownextoperator()"
	        	<%if(FlowNextOperator.equals("4")){%>checked<%}%> ><%=SystemEnv.getHtmlLabelName(31856,user.getLanguage())%>
	        </span>
	        <brow:browser name="flowobjectsubmitids" viewType="0" hasBrowser="true" hasAdd="false" 
	                getBrowserUrlFn="getSubmitUrlFun" _callback="callbackRadio"
	                isMustInput="2" isSingle="true" hasInput="false"
	                completeUrl="/data.jsp"  width="150px" browserValue='<%=flowobjectsubmit%>' browserSpanValue='<%=flowobjectsubmitnames%>' />
	        <input type=hidden name="flowobjectsubmitnames" value="<%=flowobjectsubmitnames%>">	  
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(21662,user.getLanguage()) %></wea:item>
		<wea:item>
			<input type=text class=InputStyle name="ProcessorOpinion" id ="ProcessorOpinion" maxlength="100" size="55" value="<%=ProcessorOpinion%>" >
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(18842,user.getLanguage())%>' attributes="{'itemAreaDisplay':''}">
		<wea:item type="groupHead">
			<input type="button" class="addbtn" title="<%=SystemEnv.getHtmlLabelName(611, user.getLanguage()) %>" onclick="editOverTime()" />
			<input type="button" class="delbtn" title="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage()) %>" onclick="multiDelete()" />
		</wea:item>
		<%
			String backfields = "id,linkid,workflowid,remindname,remindtype,remindhour,remindminute,repeatremind,repeathour,repeatminute,FlowRemind,MsgRemind,MailRemind,ChatsRemind,InfoCentreRemind,CustomWorkflowid,isnodeoperator,iscreater,ismanager,isother,remindobjectids"
							+ ",(case remindtype when 1 then (remindhour * 60 + remindminute) else -(remindhour * 60 + remindminute) end) as minute";
			String sqlWhere = " where linkid=" + linkid;
			String tableString = "<table id=\"nodelinkOverTimeTable\" name=\"nodelinkOverTimeTable\" instanceid=\"nodelinkOverTimeTable\" pageId=\"" + PageIdConst.WF_NODELINKOVERTIMETABLE + "\" tabletype=\"checkbox\" pagesize=\"" + PageIdConst.getPageSize(PageIdConst.WF_NODELINKOVERTIMETABLE, user.getUID()) + "\">"
								+ "<sql backfields=\"" + backfields + "\" sqlform=\"workflow_nodelinkOverTime\" sqlwhere=\"" + sqlWhere + "\" sqlprimarykey=\"id\" sqlorderby=\"remindtype,minute,id\" sqlsortway=\"ASC\" />"
								+ "<head>"
								+ " <col width=\"15%\" name=\"remindname\" text=\"" + SystemEnv.getHtmlLabelName(125613, user.getLanguage()) + "\" column=\"remindname\" orderkey=\"remindname\" transmethod=\"weaver.workflow.workflow.NodelinkOverTimeUtil.getRemindName\" otherpara=\"column:id\"></col>"
								+ " <col width=\"20%\" name=\"remindtime\" text=\"" + SystemEnv.getHtmlLabelName(785, user.getLanguage()) + "\" column=\"remindtype\" orderkey=\"remindtype,minute\" transmethod=\"weaver.workflow.workflow.NodelinkOverTimeUtil.getRemindTime\" otherpara=\"column:remindhour+column:remindminute+" + user.getLanguage() + "\"></col>"
								+ " <col width=\"15%\" name=\"repeatremindtime\" text=\"" + SystemEnv.getHtmlLabelName(125614, user.getLanguage()) + "\" column=\"repeatremind\" transmethod=\"weaver.workflow.workflow.NodelinkOverTimeUtil.getRepeatRemindTime\" otherpara=\"column:repeathour+column:repeatminute+" + user.getLanguage() + "\"></col>"
								+ " <col width=\"25%\" name=\"remindmode\" text=\"" + SystemEnv.getHtmlLabelName(18713, user.getLanguage()) + "\" column=\"FlowRemind\" transmethod=\"weaver.workflow.workflow.NodelinkOverTimeUtil.getRemindMode\" otherpara=\"column:MsgRemind+column:MailRemind+column:ChatsRemind+column:InfoCentreRemind+" + user.getLanguage() + "\"></col>"
								+ " <col width=\"25%\" name=\"remindperson\" text=\"" + SystemEnv.getHtmlLabelName(15793, user.getLanguage()) + "\" column=\"isnodeoperator\" transmethod=\"weaver.workflow.workflow.NodelinkOverTimeUtil.getRemindPerson\" otherpara=\"column:iscreater+column:ismanager+column:isother+" + user.getLanguage() + "\"></col>"
								+ "</head>"
								+ "<operates width=\"20%\">"
								+ " <operate href=\"javascript:editOverTime()\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"1\"/>"
								+ " <operate href=\"javascript:doDelete()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"2\"/>"
								+ "</operates>"	
								+ "</table>";
		%>
		<wea:item attributes="{'isTableList':'true'}">
			<input type="hidden" name="pageId" id="pageId" value="<%=PageIdConst.WF_NODELINKOVERTIMETABLE %>" />
			<wea:SplitPageTag isShowTopInfo="false" tableString="<%=tableString %>" mode="run" />
		</wea:item>
	</wea:group>
	<%}%>
	</wea:layout>
</FORM></BODY>
<script type="text/javascript">
function editOverTime(id) {
	var selectnodepass = jQuery("#selectnodepass").val(); // 超时时间来源
	var nodepasshour = jQuery("#nodepasshour").val();
	var nodepassminute = jQuery("#nodepassminute").val();
	var datefield = jQuery("#datefield").val();
	var timefield = jQuery("#timefield").val();
	
	if((selectnodepass == 1 && (nodepassminute > 0 || nodepasshour > 0)) || (selectnodepass == 2 && datefield != '')) {
		var url = "/workflow/workflow/nodelinkOverTimeEditTab.jsp";
		var title = "<%=SystemEnv.getHtmlLabelName(125630, user.getLanguage()) %>";
		if(id) {
			url += "?id=" + id;
			title = "<%=SystemEnv.getHtmlLabelName(125631, user.getLanguage()) %>";
		}else {
			url += "?linkid=<%=linkid %>&workflowid=<%=workflowid %>&selectnodepass=" + selectnodepass + "&nodepasshour=" + nodepasshour + "&nodepassminute=" + nodepassminute + "&datefield=" + datefield + "&timefield=" + timefield;
		}
		var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.Title = title;
		dialog.Width = 900;
		dialog.Height = 550;
		dialog.Drag = true;
		dialog.maxiumnable = true;
		dialog.URL = url;
		dialog.show();
	}else {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(32454, user.getLanguage()) %>");
	}
}

function multiDelete() {
	var ids = _xtable_CheckedCheckboxId();
	if(ids == "") {
		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84534, user.getLanguage()) %>");
	}else {
		doDelete(ids + "-1");
	}
}

function doDelete(ids) {
	window.top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(83600, user.getLanguage()) %>", function() {
		jQuery.ajax({
			type: "POST",
			url: "/workflow/workflow/nodelinkOverTimeOperate.jsp",
			data: {
				"id" : ids,
				"operate" : "delete"
			},
			async: false,
			success: function(data) {
				window.location.reload();
			}
		});
	});
}

function clickFlownextoperator() {
	jQuery("input[name=flownextoperator]").each(function() {
		var obj = jQuery(this);
		var val = obj.val();

		var span = "";
		if(val == 0) {
			span = "flowobjectidsspanimg";
		}else if(val == 3) {
			span = "flowobjectrejectidsspanimg";
		}else if(val == 4) {
			span = "flowobjectsubmitidsspanimg";
		}

		if(span != "") {
			if(obj.attr("checked")) {
				jQuery("#" + span).show();
			}else {
				jQuery("#" + span).hide();
			}
		}
	});
}
</script>
</HTML>
