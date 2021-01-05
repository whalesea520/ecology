<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.text.*" %>
<%@ page import="weaver.general.Util,org.json.*" %>
<%@ page import="weaver.general.TimeUtil" %>
<%@ page import="weaver.general.SessionOper" %>
<%@ page import="weaver.hrm.performance.*" %>
<%@ page import="weaver.worktask.worktask.*" %>
<%@ page import="weaver.general.*" %>
<%@page import="weaver.workflow.workflow.GetShowCondition,weaver.hrm.resource.*"%>
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="recordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet_requestbase" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="recordSet_operator" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="BrowserComInfo" class="weaver.workflow.field.BrowserComInfo" scope="page" />
<jsp:useBean id="poppupRemindInfoUtil" class="weaver.workflow.msg.PoppupRemindInfoUtil" scope="page"/>
<jsp:useBean id="taskManager" class="weaver.worktask.request.TaskManager" scope="page"/>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%


int isRefash = Util.getIntValue(request.getParameter("isRefash"), 0);
int isfromworkflow = Util.getIntValue(request.getParameter("isfromworkflow"), 0);
//是否是 查看，只用于 任务监控。如果是查看，所有的操作按钮隐藏 关联任务按钮隐藏 反馈交流隐藏/关闭按钮
int istaskview = Util.getIntValue(request.getParameter("istaskview"), 0);
session.setAttribute("relaterequest", "new");
//权限判断，确定菜单 Start
boolean canView = false;
boolean canEdit = false;
boolean canBack = false;
boolean canCheck = false;
boolean canCancel = false;
boolean canDel = false;
boolean canApprove = false;
boolean canSubmit = false;
boolean canRemark = false;
boolean canToMould = false;

int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
int requestid_in = Util.getIntValue(request.getParameter("requestid"), 0);
int operatorid_in = Util.getIntValue(request.getParameter("operatorid"), 0);//用于判断来源
int operatorid = Util.getIntValue(request.getParameter("operatorid"), 0);

String retasklistid = Util.null2String(request.getParameter("tasklistid"));

//任务相关资源
Map<String,String>  taskResource = WorkTaskResourceUtil.getTaskResourceMap(requestid);
String worktaskName = "";
String worktaskStatusName = "";
boolean shouldReturn = false;
int wtid = 0;
int request_status = 0;
int operator_optstatus = 0;
int operator_type = 0;
int operator_userid = 0;
if(requestid != 0 || operatorid != 0){
	if(operatorid > 0){
		int requestid_tmp = 0;
		recordSet_operator.execute("select * from worktask_operator where id="+operatorid);
		if(recordSet_operator.next()){
			requestid_tmp = Util.getIntValue(recordSet_operator.getString("requestid"), 0);
			operator_optstatus = Util.getIntValue(recordSet_operator.getString("optstatus"), 0);
			operator_type = Util.getIntValue(recordSet_operator.getString("type"), 0);
			operator_userid = Util.getIntValue(recordSet_operator.getString("userid"), 0);
		}else{
			shouldReturn = true;
		}
		if(requestid_tmp == 0){
			response.sendRedirect("/notice/noright.jsp");
			return;
		}else{
			requestid = requestid_tmp;
			recordSet_requestbase.execute("select * from worktask_requestbase where requestid="+requestid);
			if(recordSet_requestbase.next()){
				wtid = Util.getIntValue(recordSet_requestbase.getString("taskid"), 0);
				request_status = Util.getIntValue(recordSet_requestbase.getString("status"), 0);
				int deleted = Util.getIntValue(recordSet_requestbase.getString("deleted"), 0);
				if(deleted == 1){
					response.sendRedirect("/notice/noright.jsp");
					return;
				}
			}else{
				shouldReturn = true;
			}
		}
	}else if(requestid > 0){
		recordSet_requestbase.execute("select * from worktask_requestbase where requestid="+requestid);
		if(recordSet_requestbase.next()){
			wtid = Util.getIntValue(recordSet_requestbase.getString("taskid"), 0);
			request_status = Util.getIntValue(recordSet_requestbase.getString("status"), 0);
			int deleted = Util.getIntValue(recordSet_requestbase.getString("deleted"), 0);
			if(deleted == 1){
				shouldReturn = true;
			}
			int liableperson_tmp = Util.getIntValue(recordSet_requestbase.getString("liableperson"), 0);//非单责任人，则把operatorid清为0
			if(liableperson_tmp!=0 && operatorid==0 && request_status>=6){
				recordSet_operator.execute("select * from worktask_operator where type=1 and userid="+liableperson_tmp+" and requestid="+requestid);
				if(recordSet_operator.next()){
					int operatorid_tmp = Util.getIntValue(recordSet_operator.getString("id"), 0);
					operator_optstatus = Util.getIntValue(recordSet_operator.getString("optstatus"), 0);
					operator_type = Util.getIntValue(recordSet_operator.getString("type"), 0);
					operatorid = operatorid_tmp;
				}else{
					shouldReturn = true;
				}
			}
		}else{
			shouldReturn = true;
		}
	}
}else{
	shouldReturn = true;
}
if(shouldReturn == true ){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

WTRequestManager wtRequestManager = new WTRequestManager(wtid);
wtRequestManager.setLanguageID(user.getLanguage());
wtRequestManager.setUserID(user.getUID());
int needcheck = Util.getIntValue(recordSet_requestbase.getString("needcheck"), 0);
int checkor = Util.getIntValue(recordSet_requestbase.getString("checkor"), 0);
if(needcheck == 0){
	checkor = 0;
}
int creater = Util.getIntValue(recordSet_requestbase.getString("creater"), 0);
int approverequest = Util.getIntValue(recordSet_requestbase.getString("approverequest"), 0);
Hashtable checkRight_hs = wtRequestManager.checkRight(requestid, request_status, operator_optstatus, creater, checkor, approverequest);
canView = (Util.null2String((String)checkRight_hs.get("canView"))).equalsIgnoreCase("true")?true:false;
canEdit = (Util.null2String((String)checkRight_hs.get("canEdit"))).equalsIgnoreCase("true")?true:false;
canBack = (Util.null2String((String)checkRight_hs.get("canBack"))).equalsIgnoreCase("true")?true:false;
canCheck = (Util.null2String((String)checkRight_hs.get("canCheck"))).equalsIgnoreCase("true")?true:false;
canCancel = (Util.null2String((String)checkRight_hs.get("canCancel"))).equalsIgnoreCase("true")?true:false;
canDel = (Util.null2String((String)checkRight_hs.get("canDel"))).equalsIgnoreCase("true")?true:false;
canApprove = (Util.null2String((String)checkRight_hs.get("canApprove"))).equalsIgnoreCase("true")?true:false;
canSubmit = (Util.null2String((String)checkRight_hs.get("canSubmit"))).equalsIgnoreCase("true")?true:false;
int nodetype = Util.getIntValue((String)checkRight_hs.get("nodetype"), -1);
//任务另存为模板
if(creater==user.getUID() || checkor==user.getUID()){
	canToMould = true;
}
if(operator_optstatus==2 && HrmUserVarify.checkUserRight("Worktask:remark", user) && resourceComInfo.getDepartmentID(""+operator_userid).equals(resourceComInfo.getDepartmentID(""+user.getUID()))){
	canRemark = true;
}
int usertype = 1;
if("1".equals(user.getLogintype())){
	usertype = 0;
}else if("2".equals(user.getLogintype())){
	usertype = 1;
}
//来自流程界面，特殊处理：具有流程查看权限，就能查看该计划任务
if(canView==false && isfromworkflow==1){
	int deswtrequestcount = Util.getIntValue(request.getParameter("deswtrequestcount"), 0);
	int wt_requestid = Util.getIntValue(request.getParameter("deswtrequestid"+deswtrequestcount), 0);
	if(wt_requestid == requestid_in){
		int sourceworkflowid = Util.getIntValue((String)session.getAttribute("sourceworkflowid"), 0);
		rs.executeSql("select requestid from workflow_currentoperator where userid="+user.getUID()+" and usertype="+usertype+" and requestid="+sourceworkflowid);
	    if(rs.next()){
        	canView = true;
	    }
	}
}
if(canView == false){
	response.sendRedirect("/notice/noright.jsp");
	return;
}



//权限判断，确定菜单 End
//处理worktask_operator的viewtype
if(operatorid!=0 && user.getUID()==operator_userid){
	rs.execute("update worktask_operator set viewtype=0 where id="+operatorid_in);
}
if(operatorid!=0 && user.getUID()==checkor){
	rs.execute("update worktask_operator set checkorviewtype=0 where id="+operatorid_in);
}
if(operatorid!=0 && user.getUID()==creater){
	rs.execute("update worktask_operator set createrviewtype=0 where id="+operatorid_in);
}
if(approverequest != 0){
	Calendar today = Calendar.getInstance();
	String currentdate = Util.add0(today.get(Calendar.YEAR), 4) + "-" + Util.add0(today.get(Calendar.MONTH) + 1, 2) + "-" + Util.add0(today.get(Calendar.DAY_OF_MONTH), 2);
	String currenttime = Util.add0(today.get(Calendar.HOUR_OF_DAY), 2) + ":" + Util.add0(today.get(Calendar.MINUTE), 2) + ":" + Util.add0(today.get(Calendar.SECOND), 2);
	rs.execute("update workflow_currentoperator set viewtype=-2, operatedate='"+currentdate+"', operatetime='"+currenttime+"' where requestid = " + approverequest + "  and userid ="+user.getUID()+" and usertype = "+usertype+" and viewtype<>-2 ");
	int iscomplete = 0;
	rs.execute("select currentnodetype from workflow_requestbase where requestid="+approverequest);
	if(rs.next()){
		int currentnodetype_tmp = Util.getIntValue(rs.getString(1), 0);
		if(currentnodetype_tmp == 3){
			iscomplete = 1;
		}
	}
	//由于没有抄送的提交按钮，所以2种抄送，都只要查看就认为操作过
	rs.execute("update workflow_currentoperator set iscomplete="+iscomplete+", isremark='2', preisremark='8' where isremark in ('8','9') and requestid = " + approverequest + "  and userid ="+user.getUID()+" and usertype = "+usertype);
	poppupRemindInfoUtil.updatePoppupRemindInfo(user.getUID(), 0, user.getLogintype().equals("1")?"0":"1", approverequest);
	poppupRemindInfoUtil.updatePoppupRemindInfo(user.getUID(), 1, user.getLogintype().equals("1")?"0":"1", approverequest);
	poppupRemindInfoUtil.updatePoppupRemindInfo(user.getUID(), 10, user.getLogintype().equals("1")?"0":"1", approverequest);
}
Hashtable worktaskStatus_hs = new Hashtable();
rs.execute("select * from SysPubRef where masterCode='WorkTaskStatus' and flag=1");
while(rs.next()){
	int detailCode_tmp = Util.getIntValue(rs.getString("detailCode"), 0);
	String worktaskStatusName_tmp = SystemEnv.getHtmlLabelName(Util.getIntValue(rs.getString("detailLabel")), user.getLanguage());
	worktaskStatus_hs.put("worktaskstatus_"+detailCode_tmp, worktaskStatusName_tmp);
	if(request_status == detailCode_tmp){
		worktaskStatusName = worktaskStatusName_tmp;
	}
}

Hashtable canCreateTasks_hs = wtRequestManager.getCanCreateTasks(false);

worktaskName = (String)canCreateTasks_hs.get("tasks_"+wtid);
String tasksSelectStr = (String)canCreateTasks_hs.get("tasksSelectStr");

Hashtable ret_hs_1 = wtRequestManager.getViewFieldInfo();
ArrayList textheightList = (ArrayList)ret_hs_1.get("textheightList");
ArrayList idList = (ArrayList)ret_hs_1.get("idList");
ArrayList fieldnameList = (ArrayList)ret_hs_1.get("fieldnameList");
ArrayList crmnameList = (ArrayList)ret_hs_1.get("crmnameList");
ArrayList ismandList = (ArrayList)ret_hs_1.get("ismandList");
ArrayList fieldhtmltypeList = (ArrayList)ret_hs_1.get("fieldhtmltypeList");
ArrayList typeList = (ArrayList)ret_hs_1.get("typeList");
ArrayList wttypeList = (ArrayList)ret_hs_1.get("wttypeList");
ArrayList iseditList = (ArrayList)ret_hs_1.get("iseditList");
ArrayList defaultvalueList = (ArrayList)ret_hs_1.get("defaultvalueList");
ArrayList defaultvaluecnList = (ArrayList)ret_hs_1.get("defaultvaluecnList");
ArrayList fieldlenList = (ArrayList)ret_hs_1.get("fieldlenList");
ArrayList issystemList = (ArrayList)ret_hs_1.get("issystemList");

int annexmaincategory = 0;
int annexsubcategory = 0;
int annexseccategory = 0;
rs.execute("select * from worktask_base where id="+wtid);
if(rs.next()){
	annexmaincategory = Util.getIntValue(rs.getString("annexmaincategory"), 0);
	annexsubcategory = Util.getIntValue(rs.getString("annexsubcategory"), 0);
	annexseccategory = Util.getIntValue(rs.getString("annexseccategory"), 0);
}
int maxUploadImageSize = 5;
maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexseccategory), 5);
if(maxUploadImageSize<=0){
	maxUploadImageSize = 5;
}

String liableperson = "",liablepersonname = "",enddate="",enddatetime="",taskcontent="",taskname="",checkorid="",checkorname="";
int urgency=0;
//已创建的任务
ResourceComInfo  rc = new ResourceComInfo();
recordSet_requestbase.execute("select *  from worktask_requestbase where requestid='"+requestid+"'");
if(recordSet_requestbase.next()){
	liableperson = Util.getIntValue(recordSet_requestbase.getString("liableperson"), 0)+"";
	liablepersonname = rc.getResourcename(liableperson+"");
	enddate =  recordSet_requestbase.getString("planenddate");
	enddatetime = recordSet_requestbase.getString("planendtime");
	taskcontent = recordSet_requestbase.getString("taskcontent");
	taskname = recordSet_requestbase.getString("taskname");
	checkorid = Util.getIntValue(recordSet_requestbase.getString("checkor"), 0)+"";
	checkorname = rc.getResourcename(checkor+"");
	urgency = recordSet_requestbase.getInt("urgency");
	approverequest = Util.getIntValue(recordSet_requestbase.getString("approverequest"),0);
}
if(!"".equals(taskcontent)){
	   taskcontent = taskcontent.replace("<br>","");
	   taskcontent = taskcontent.replace("&nbsp;"," ");
}


//根据浏览框id值获取具体的名称
GetShowCondition broconditions=new GetShowCondition();
 //多选按钮id
String browsermoreids=",17,18,37,257,57,65,194,240,135,152,162,166,168,170,";

%>


<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(istaskview != 1){
	if(canSubmit == true){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(15143, user.getLanguage())+",javaScript:OnSubmit(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}

	if(canApprove==true && nodetype==1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(142, user.getLanguage())+",javaScript:OnApprove(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
		RCMenu += "{"+SystemEnv.getHtmlLabelName(236, user.getLanguage())+",javaScript:OnReject(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}else if(canApprove==true && nodetype==2){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(615, user.getLanguage())+",javaScript:OnApprove(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	if(canBack==true && operatorid!=0){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(555, user.getLanguage())+",javaScript:OnExecute(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	if(canCheck==true && operatorid!=0 && request_status ==9){
		//验证通过
		RCMenu += "{"+SystemEnv.getHtmlLabelName(15376, user.getLanguage())+",javaScript:OnCheckSuccess(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
		//验证退回
		RCMenu += "{"+SystemEnv.getHtmlLabelName(236, user.getLanguage())+",javaScript:OnCheckBack(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	//待验证和完成状态无取消操作
	if(canCancel == true && request_status != 10 && request_status != 9){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(201, user.getLanguage())+",javaScript:OnCancel(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	if(canDel == true){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91, user.getLanguage())+",javaScript:OnDel(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	//待验证和完成状态无编辑操作
	if(request_status != 10 && request_status != 9 && (creater == user.getUID() || (user.getUID()+"").equals(liableperson))) {  //任务还未完成，并且当任务创建人或责任人是 当前用户 
		RCMenu += "{"+SystemEnv.getHtmlLabelName(93, user.getLanguage())+",javaScript:OnEdit(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
	
}
	RCMenu += "{"+SystemEnv.getHtmlLabelName(119, user.getLanguage())+",javaScript:OnShare(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(354, user.getLanguage())+",javaScript:OnRefresh(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;

%>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<!DOCTYPE html>
<html>
<head lang="en">
    <title></title>
    <link rel="stylesheet"  href="../css/worktaskcreate_wev8.css">
	<link rel="stylesheet"  href="../css/powerFloat_wev8.css">
	<style>
        .exchangeTemplate{
		  width:100%;
		  border-collapse: collapse;
		  table-layout: fixed;
		}

        .exchangeTemplate .middlehelper{
		   display: inline-block;
		   height:100%;
		}

		.exchangeTemplate  td{
		  /**border-bottom:1px solid #ccc;**/
		  padding : 7px 15px;
		}
        .exchangeTemplate .relfilecontainer{
		    display: inline-block;
			padding: 10px 5px;
			margin-right: 10px;
		}
		.exchangeTemplate .relfiledes{
		    vertical-align: middle;
			padding: 3px 5px;
			background: #eee;
			border-radius: 10px;
			margin-right: 3px;
		}
		.exchangeTemplate .fileclose{
		  cursor:pointer;
		}
		.exchangeTemplate .fileclose:hover{
		   color:#008ff3;
           cursor:pointer;
		}
		#worktaskdesign .exchangeAttach{
		  margin-right:10px;
		  cursor:pointer;
		} 
		#worktaskdesign .sendmsg{
		  cursor:pointer;
		}
		#worktaskdesign .rsall{
		  padding-top: 5px;
		  padding-bottom: 5px;
		}
        #worktaskdesign .rswrapper{
		   padding-top: 3px;
		}
		#worktaskdesign  .taskprocess{
		  width:100%;
		  height:2px;
		  background-color: #E48E73;
		}
		#worktaskdesign  .taskprocess .processnow{
		  height:100%;
		  background-color:#86D884;
		}

        #worktaskdesign .trace{
		  cursor:pointer;
		}

		#worktaskdesign .tracecontainer{
		    width: 230px;
			position: absolute;
			top: 32px;
			<% if(!"".equals(retasklistid)){ %>
			top: 55px;
			<%}%>
			z-index: 100;
			right: 0;
			background: #fff;
			border: 1px solid #e5e5e5;
			display:none;
			max-height: 450px;
			right: 50px;
			<% if(istaskview ==1){ %>
			right: 14px;
			<%}%>
		}
		#_xTable{
		   padding:0 !important;
		}
		#worktaskdesign .addnewwt{
		  cursor:pointer;
		}
		#worktaskdesign .histaskstatus{
		  cursor:pointer;
		}

		#worktaskdesign .tabheader{
		  position:relative;
		} 

		#worktaskdesign .tabheader .taskexchangesearch{
		  position:absolute;
		  right:5px;
		  top:5px;
		  width: 50px; 
		  height: 32px;
          cursor: pointer;
          border: 1px solid #F5F9FC;
		  background: url(/images/ecology8/request/search-input_wev8.png) 50% 50% no-repeat scroll;
		}

		#worktaskdesign .tabheader .taskexchangesearchchecked{
		   border: 1px solid #ccc;
		   border-bottom: none;
		}

      	 #worktaskdesign .seachcondition{
		    padding: 1px 0;
			position: absolute;
			background: #fff;
			z-index: 100;
			overflow: auto;
			display: none;
			height: 124px;
			border-bottom: 1px solid #f2f2f2;
			width:100%;
		}
		.tasklistitems {
		     width:360px;
		    position: absolute;
			right: 16px;
			border: 1px solid #f2f2f2;
			top: 199px;
			z-index: 1000;
			background: #fff;
		}
		.tasklistitems table{
		  table-layout: fixed;
          width: 100%;
		  border-collapse: collapse;
		}
		.tasklistitems table tr{
		  height:35px;
		   cursor: pointer;
		}
		.tasklistitems table td{
		  padding:4px 4px;
		}
		.tasklistitems .finished{
		  color:#8ECF57;
		}
		.tasklistitems table tr:hover{
		   background-color:#F5FBFB;
		}
		.wtshare{
		    position: fixed;
			right: 10px;
			bottom: 85px;
			font-size: 30px;
			background-color: #AEDBF8;
			color: #fff;
			height: 40px;
			cursor: pointer;
			line-height: 40px;
			width: 35px;
			border-radius: 10px;
			text-align: center;
			z-index: 10000;
		}

		.hritems{
		    position: absolute;
			bottom: 40px;
			list-style: none;
			background: #fff;
			z-index: 100001;
			border:1px solid #bde9ff
		}
		.hritems li{
		    padding: 3px 11px;
			height: 23px;
			line-height: 23px;
		}
		.hritems li:hover{
		    color: #fff;
			background: #08c;
			cursor: pointer;
		}
		.hritems  .hrmitemactive{
		    color: #fff;
			background: #08c;
			cursor: pointer;
		}
		#worktaskdesign .atcolor{
		  color:#428bca;
		}
		.realresource{
	    	padding: 3px 5px;
		}
		.rswrapper a{
		  color:#428bca;
		}
		#worktaskdesign .e8_innerShow {
		 border:none;
		}
	    #worktaskdesign .e8_innerShow  a{
		 color:#428bca;
		}
		#worktaskdesign .e8_outScroll{
		  border:none;
		}
		#worktaskdesign #taskresource .e8_showNameClass{
		  margin-right:8px;
		} 
		.removerelation{
		   cursor: pointer;
		   display: inline-block;
		   height: 20px;
		   width: 20px;
		   text-align: center;
		}
		
		.feedbackmore{
			   width: 100%;
				height: 28px;
				line-height: 28px;
				text-align: center;
				cursor: pointer;
				color: #4197EA;
		}
		
		.seachcondition .e8_outScroll{
		   border: 1px solid #f2f2f2 !important;
		}
		
		
	</style>
</head>
<body>


<form name="taskform" method="post" action="AddWorktask.jsp" enctype="multipart/form-data">

<input type="hidden" name="wtid" id="wtid" value="<%=wtid%>">
<input type="hidden" name="operationType">
<input type="hidden" id="needcheck" name="needcheck" value="wtid" >
<input type="hidden" id="functionPage" name="functionPage" value="AddWorktask.jsp" >
<input type="hidden" id="isRefash" name="isRefash" value="<%=isRefash%>" >
<input type="hidden" id="istemplate" name="istemplate" value="0" >
<input type="hidden" id="requestid" name="requestid" value="<%=requestid%>" >
<input type="hidden"  name="taskid_<%=requestid%>" value="<%=wtid%>" >
<input type="hidden" id="retasklistid"  name="retasklistid" value="<%=retasklistid%>" >
<input type="hidden" id="istaskview"  name="istaskview" value="<%=istaskview%>" >

<input type="hidden" id="request_status"  name="request_status" value="<%=request_status%>" >
<input type="hidden" id="approverequest"  name="approverequest" value="<%=approverequest%>" >


<div id="_xTable" style="background:#FFFFFF;padding:3px;width:100%;text-align: center;" valign="top">
</div>
<% if(istaskview != 1){ %>
	<div class='wtshare' onclick='OnShare();' title='<%=SystemEnv.getHtmlLabelName(31843,user.getLanguage())%>'  style='display:none'>
	     +
	</div>
<%} %>

<div id="worktaskdesign">

	
    <div class='taskprocess' title='<%=SystemEnv.getHtmlLabelName(22069,user.getLanguage())%>'>
	    <div class='processnow' title='<%=SystemEnv.getHtmlLabelName(22069,user.getLanguage())%>' ></div>
	</div>

	<% if(!"".equals(retasklistid)){ %>
	    <div class="remindmsg">
	       <%=SystemEnv.getHtmlLabelNames("31830,1332",user.getLanguage())%>：<%=taskManager.getRequestNameByTaskListID(retasklistid) %>
	    </div>
    <%} %>

    <div class="worktask_base">
        <div class="lf">
            <span class="middlehelper"></span>
            <img src="../images/user_wev8.png" title='<%=SystemEnv.getHtmlLabelName(16936,user.getLanguage())%>' style="cursor: pointer;" >
            <span class="dutyman resourceselection" style='margin-left:0px;'>
			        <!--责任人-->
					<brow:browser isMustInput="0" viewType="0" name='<%="field3_"+requestid%>'
						browserUrl="/hrm/resource/MutiResourceBrowser.jsp?selectedids=&resourceids="
						hasInput="true" isSingle="true" hasBrowser = "true" 
						completeUrl="/data.jsp?type=17"   browserValue='<%=liableperson+""%>' browserSpanValue='<%=liablepersonname%>' width="60px">
					 </brow:browser> 	
			</span>
            <span class="splitline"></span>

			<input type="hidden" viewtype="1"  id="field13_<%=requestid%>" name="field13_<%=requestid%>" value="<%=enddate%>">
			<input type="hidden" viewtype="1"  id="field14_<%=requestid%>" name="field14_<%=requestid%>" value="<%=enddatetime%>">

			<input type="hidden" viewtype="1"  id="wfenddate" name="wfenddate" value="<%=enddate%> <%=enddatetime%>">
            <img src="../images/datepic_wev8.png" class='datepic Calendar' >
            <span name='wfenddatespan' id='wfenddatespan'><%=enddate%> <%=enddatetime%></span>
        </div>
        <div class="rf">
            <span class="middlehelper"></span>
            <span class="topbutton" ></span>
            
            <% if( request_status >1){//非未提交 %>
             <span class="splitline"></span>
           	 <img src="../images/trace_wev8.png" title='<%=SystemEnv.getHtmlLabelName(83554,user.getLanguage())%>'  class="trace" style="cursor: pointer;margin-left:8px;" >
            <%} %>
            <% if(istaskview != 1){ %>
	            <span class="splitline"></span>
	            <img src="../images/closeitem_wev8.png" class="closeitem" style="cursor: pointer;"  title='<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>' >
	        <%} %>
        </div>
    </div>

    <div class="worktask_detailinfo">
          <div class="headinfo">
              <div class="lf">
                  <span class="middlehelper"></span>
                  <span id='urgelevelshow' style="border: 1px solid #f2f2f2;margin-left: 2px;" class="normal" title='<%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%>'><input type='hidden'  name='urgelevel'></span>
                  <img src="../images/urgelevel_wev8.png" class='urgelevel' style='display:none'>
                  <span style='padding-left:13px'><input type='text' placeholder='<%=SystemEnv.getHtmlLabelNames("33010,24986",user.getLanguage())%>' name='taskname' readonly="readonly" value='<%=taskname%>' style='width:350px;border:none;'/></span>
              </div>
              <div class="rf">
                  <span class="middlehelper"></span>
                  <% if(!"0".equals(checkorid)){ %>
	                  <img src="../images/user_wev8.png" title='<%=SystemEnv.getHtmlLabelName(22164,user.getLanguage())%>' style="cursor: pointer;" >
	                  <span class="resourceselection" style='margin-left:0px;'>
							<brow:browser viewType="0" name='<%="field2_"+requestid %>'
								browserUrl="/hrm/resource/MutiResourceBrowser.jsp?selectedids=&resourceids="
								hasInput="true" isSingle="true" hasBrowser = "true" isMustInput="0"
								completeUrl="/data.jsp?type=17"   browserValue='<%=checkorid+""%>' browserSpanValue='<%=checkorname%>' width="60px">
							 </brow:browser> 	
					 </span>
				  <%} %>
              </div>
          </div>
        <div class="fieldinfo taskcontent">
            <span class="middlehelper"></span>
            <span class='taskcontentdes'>
			   <!--计划任务-->
			   <textarea placeholder='<%=SystemEnv.getHtmlLabelNames("1332,81710",user.getLanguage())%>' class="taskcontentarea" readonly="readonly"  name='field7_<%=requestid%>'  style='width:100%;height:32px;overflow:auto;font-size:12px;border:none;resize: none;'><%=taskcontent%></textarea>
			</span>
        </div>

        <%
	
		 if(needcheck==1 && checkor!=0){
		 	needcheck = 1;
		 }
		 for(int i=0; i<idList.size(); i++){
		   
				  int issystem_temp = Util.getIntValue((String)issystemList.get(i), 0);
				  //系统自带字段不展示
				  if(issystem_temp == 1)
					  continue;
				    int textheight_tmp = Util.getIntValue((String)textheightList.get(i), 0);
					int fieldid_tmp = Util.getIntValue((String)idList.get(i), 0);
					String fieldname_tmp = Util.null2String((String)fieldnameList.get(i));
					String crmname_tmp = Util.null2String((String)crmnameList.get(i));
					String fieldhtmltype_tmp = Util.null2String((String)fieldhtmltypeList.get(i));
					String type_tmp = Util.null2String((String)typeList.get(i));
					int isedit_tmp = Util.getIntValue((String)iseditList.get(i), 0);
					int ismand_tmp = Util.getIntValue((String)ismandList.get(i), 0);
					String value_tmp = Util.null2String(recordSet_requestbase.getString(fieldname_tmp));//recordSet获取
					String fieldlen_tmp = Util.null2String((String)fieldlenList.get(i));
					int wttype = Util.getIntValue((String)wttypeList.get(i), 1);
					String showOtherCol = Util.null2String(new BaseBean().getPropValue("worktask","showOtherCol"));
					if(!showOtherCol.equals("1") && wttype != 1){
						continue;
					}
					if("16".equals(type_tmp) || "152".equals(type_tmp) || "171".equals(type_tmp)){
						if(!"".equals(value_tmp)){
							String[] tlinkwts = Util.TokenizerString2(value_tmp, ",");
							for(int dx=0; dx<tlinkwts.length; dx++){
								String tlinkwt = Util.null2o(tlinkwts[dx]);
								int tempnum = Util.getIntValue((String)(session.getAttribute("tlinkwtnum")), 0);
								tempnum++;
								session.setAttribute("retrequestid"+tempnum, tlinkwt);
								session.setAttribute("tlinkwfnum", ""+tempnum);
								session.setAttribute("haslinkworktask", "1");
								session.setAttribute("deswtrequestid"+tempnum, ""+requestid);
							}
						}
					}
					String sHtml = "";
					//完成按钮单独处理
					if(canBack==true && operatorid!=0){
						if(request_status != 9){
							if(wttype == 2){
								value_tmp = Util.null2String(recordSet_operator.getString(fieldname_tmp));//recordSet获取
								sHtml = wtRequestManager.getFieldCellWithValueExecute(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, 1, 0, value_tmp, requestid);
							}else if(wttype == 3){
								continue;
							}else{
								sHtml = wtRequestManager.getFieldCellWithValue(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, 0, 0, value_tmp, requestid);
							}
						}else{
							
						}
					}
					//验证按钮单独处理
					if(canCheck==true && operatorid!=0 && request_status ==9){
						if(wttype == 3){
							value_tmp = Util.null2String(recordSet_operator.getString(fieldname_tmp));//recordSet获取\
							sHtml = wtRequestManager.getFieldCellWithValueExecute(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, 1, 0, value_tmp, requestid);
						}else if(wttype == 2){
							value_tmp = Util.null2String(recordSet_operator.getString(fieldname_tmp));//recordSet获取
							sHtml = wtRequestManager.getFieldCellWithValue(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, 0, 0, value_tmp, requestid);
						}else{
							sHtml = wtRequestManager.getFieldCellWithValue(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, 0, 0, value_tmp, requestid);
						}
					}
					//完成按钮/验证按钮之外的情况下
					if(!((canCheck==true && operatorid!=0 && request_status ==9) || (canBack==true && operatorid!=0))){
						//在待审批的状态下单纯的显示属性字段
						if(canApprove){
							sHtml = wtRequestManager.getFieldCellWithValue(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, 0, 0, value_tmp, requestid);
						}else{
							if(wttype==1){
								sHtml = wtRequestManager.getFieldCellWithValue(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, 0, 0, value_tmp, requestid);
							}else{
								value_tmp = Util.null2String(recordSet_operator.getString(fieldname_tmp));//recordSet获取\
								sHtml = wtRequestManager.getFieldCellWithValueExecute(textheight_tmp,fieldid_tmp, fieldname_tmp, fieldlen_tmp, crmname_tmp, fieldhtmltype_tmp, type_tmp, 0, 0, value_tmp, requestid);
							}
						}
					}
				   %>
				    <div class="fieldinfo"><span class="middlehelper"></span>
			              <span class="label"><%=crmname_tmp %></span><span><%=sHtml %></span>
		            </div>
        <%} %>


    <div class="worktasklist">
       <div class="head">
           <div class="lf">
               <span class="middlehelper"></span>
               <span class="addpaddingbottom"><%=SystemEnv.getHtmlLabelNames("1332,491",user.getLanguage())%></span>
           </div>
           <div class="rf">
               <span class="middlehelper"></span>
           </div>
       </div>
       <div class="listbody">
            <table >
                 <colgroup>
                      <col width="5%">
					  <col width="*">
                      <col width="18%">
                      <col width="30%">
                 </colgroup>
                 <tbody >
                     
                 </tbody>
            </table>
       </div>
    </div>

           <%//提醒设置
					int remindtype = 0;
					int beforestart = 0;
					int beforestarttime = 0;
					int beforestarttype = 0;
					int beforestartper = 0;
					int beforeend = 0;
					int beforeendtime = 0;
					int beforeendtype = 0;
					int beforeendper = 0;
					int issubmitremind = 0;
					issubmitremind = Util.getIntValue(recordSet_requestbase.getString("issubmitremind"), 0);
					remindtype = Util.getIntValue(recordSet_requestbase.getString("remindtype"), 0);
					beforestart = Util.getIntValue(recordSet_requestbase.getString("beforestart"), 0);
					beforestarttime = Util.getIntValue(recordSet_requestbase.getString("beforestarttime"), 0);
					beforestarttype = Util.getIntValue(recordSet_requestbase.getString("beforestarttype"), 0);
					beforestartper = Util.getIntValue(recordSet_requestbase.getString("beforestartper"), 0);
					beforeend = Util.getIntValue(recordSet_requestbase.getString("beforeend"), 0);
					beforeendtime = Util.getIntValue(recordSet_requestbase.getString("beforeendtime"), 0);
					beforeendtype = Util.getIntValue(recordSet_requestbase.getString("beforeendtype"), 0);
					beforeendper = Util.getIntValue(recordSet_requestbase.getString("beforeendper"), 0);
					String startTimeType = "";
					String endTimeType = "";
					if(beforestarttype == 0){
						startTimeType = SystemEnv.getHtmlLabelName(1925,user.getLanguage());
					}else if(beforestarttype == 1){
						startTimeType = SystemEnv.getHtmlLabelName(391,user.getLanguage());
					}else{
						startTimeType = SystemEnv.getHtmlLabelName(15049,user.getLanguage());
					}
					if(beforeendtype == 0){
						endTimeType = SystemEnv.getHtmlLabelName(1925,user.getLanguage());
					}else if(beforeendtype == 1){
						endTimeType = SystemEnv.getHtmlLabelName(391,user.getLanguage());
					}else{
						endTimeType = SystemEnv.getHtmlLabelName(15049,user.getLanguage());
					}
		%>

    <div  class="worktasktabs">
	     <div class='headlinetop'></div>
         <ul class="tabheader">
             <li tabitem="taskexchange" ><%=SystemEnv.getHtmlLabelName(83556,user.getLanguage())%></li>
              <% if( !(("".equals(taskResource.get("docs")) || null==taskResource.get("docs"))  
            		  && ("".equals(taskResource.get("wfs")) || null==taskResource.get("wfs"))  
            		  && ("".equals(taskResource.get("custs")) || null==taskResource.get("custs")) 
            		  &&  ("".equals(taskResource.get("projs")) || null==taskResource.get("projs"))  
            		  && ("".equals(taskResource.get("attachs")) || null==taskResource.get("attachs")))  ) {%>
            		  <li tabitem="taskresource"><%=SystemEnv.getHtmlLabelName(22672,user.getLanguage())%></li>
              <% } %>
			 <% if(remindtype != 0) {%>
			    <li tabitem="taskremind"><%=SystemEnv.getHtmlLabelName(83558,user.getLanguage())%></li>
			 <%} %>
			 <li tabitem="tasklog"><%=SystemEnv.getHtmlLabelName(32061,user.getLanguage())%></li>
             <div class='taskexchangesearch' title='<%=SystemEnv.getHtmlLabelName(82529,user.getLanguage())%>'>
			     
			 </div>
		 </ul>
		 <div class='headlinebottom'></div>
         <div class='panel' id='taskexchange'>
              <div class='seachcondition' >
			        <table style="width: 100%" >
                         <tr style="height:40px">
                              <td style="text-align:right;width:130px"><%=SystemEnv.getHtmlLabelName(33368,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                              <td><input class="InputStyle" type="text" name="excontent" style="width: 300px;border: 1px solid #f2f2f2" /></td>
                         </tr>
                         <tr style="height:40px">
                             <td style="text-align:right;width:130px"><%=SystemEnv.getHtmlLabelName(33451,user.getLanguage())%>&nbsp;&nbsp;&nbsp;&nbsp;</td>
                             <td>
                                  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<brow:browser viewType="0" name="expersons"
											browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids=&resourceids="
											hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
											completeUrl="/data.jsp?type=17"   browserValue="" browserSpanValue="" width="300px"></brow:browser> 	
                              </td>
                         </tr>
                         <tr>
                             <td colspan='2' style="text-align:center">
                                  <input class="e8_btn_cancel searchitem"    type="button" value="<%=SystemEnv.getHtmlLabelName(527,user.getLanguage())%>"/>
									<input class="e8_btn_cancel cacellchitem"  type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/>
                             </td>
                         </tr>
                    </table>
			  </div>
		      <div class='feedbackcontainer' style='position:fixed;bottom:0;left:0;border-top:1px solid #f2f2f2;min-height: 34px;width: 100%;background: #fff;z-index: 999;<%if(istaskview==1){ %>display:none<%} %>' >
		           <div style='height:100%;height: 100%;overflow: auto;padding-left: 10px;padding-right: 10px;padding-top: 2px;' class='exmsgwrapper'>
				     <textarea placeholder='<%=SystemEnv.getHtmlLabelName(83596,user.getLanguage())%>' name='exmsg' id='exmsg' style='width:100%;height:38px;overflow: hidden;border: none;resize: none;font-size: 12px;' ></textarea>
				  </div>
			      <div style='width:100%;height:34px'>
				     <span class="middlehelper"></span>
					 <span><img src='../images/attach_wev8.png' class='exchangeAttach' title='<%=SystemEnv.getHtmlLabelName(22672,user.getLanguage())%>' ></span>
					 <span style="display: inline-block;float: right;padding-right: 10px;padding-bottom: 3px;"> <img src="../images/sendmsg_wev8.png"  class='sendmsg' title='<%=SystemEnv.getHtmlLabelName(22141,user.getLanguage())%>'></span>
				  </div>
				 
			  </div>
		       <ul>
                  <li>

                     <%=WorkTaskResourceUtil.getExchangeInfo(requestid,recordSet_requestbase,user)%>
                     
					 <!--
				     <div class='lcommentcontainer'>
						 <div class='lcommentinfo'>张三</div>
						 <div class='lcomment'>
							<img src="../images/chatblue_wev8.png" class='bluepoint'>
							<span  class='limgpointerholder'></span>
							<div class='lcommentdetail'>请尽快完成任务</div>
						 </div>
					 </div>

					 <div class='rcommentcontainer'>
						 <div class='rcommentinfo'>张三</div>
						 <div class='rcomment'>
							<img src="../images/chatgrey_wev8.png" class='greypoint'>
							<span  class='rimgpointerholder'></span>
							<div class='rcommentdetail'>请尽快完成任务</div>
						 </div>
					 </div>
                     -->
				  </li>
			   </ul>
               <div style='height:38px;'></div>
		 </div>
		 <div class='panel' id='taskresource'>
		  <% if( ("".equals(taskResource.get("docs")) || null==taskResource.get("docs"))  && ("".equals(taskResource.get("wfs")) || null==taskResource.get("wfs"))  && ("".equals(taskResource.get("custs")) || null==taskResource.get("custs")) &&  ("".equals(taskResource.get("projs")) || null==taskResource.get("projs"))  && ("".equals(taskResource.get("attachs")) || null==taskResource.get("attachs"))  ) {%>
                     <div style='text-align: left;padding: 10px;'><%=SystemEnv.getHtmlLabelName(83599,user.getLanguage())%></div>         

		  <% } %>
		   <div class='resourcecontainer'>
              <table >
			      <colgroup>
                      <col width="20%">
					  <col width="80%">
                  </colgroup>
                 <% if(!"".equals(taskResource.get("attachs"))  && null!=taskResource.get("attachs")) {%>
                 <tr>
				   <td><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%></td>
				   <td> 
				        <input type='hidden'  name='fileids' value='<%=taskResource.get("attachs")%>'>
						<div class='fileprocess'></div>
				        <div class='fileitems'></div>
				   </td>
				 </tr>
                <% } %>
			     <% 
				 if(!"".equals(taskResource.get("docs")) && null!=taskResource.get("docs")) {%>
				 <tr>
				    <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td><td> <brow:browser viewType="0" name="docids" browserValue='<%=taskResource.get("docs")%>' 
									browserUrl="/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docs/MutiDocBrowser.jsp?documentids="
									hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='0'
									completeUrl="/data.jsp?type=9" linkUrl="/docs/docs/DocDsp.jsp"
									language='<%=""+user.getLanguage() %>'
									temptitle='<%=SystemEnv.getHtmlLabelName(31519,user.getLanguage())%>'
									browserSpanValue='<%=taskResource.get("docspan")%>'></brow:browser></td>
				 </tr>
				 <% } %>
				  <% if(!"".equals(taskResource.get("wfs")) && null!=taskResource.get("wfs")) {%>
				 <tr>
                   <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
				   <td>
				       <brow:browser viewType="0" name="requestids" browserValue='<%=taskResource.get("wfs")%>' 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids="
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='0' 
						completeUrl="/data.jsp" linkUrl="/workflow/request/ViewRequest.jsp?requestid==#id#&id=#id#" 
						browserSpanValue='<%=taskResource.get("wfspan")%>'></brow:browser>
				   </td>
				 </tr>
				  <% } %>
				 
				 <% if(!"".equals(taskResource.get("custs")) && null!=taskResource.get("custs")) {%>
				  <tr>
				   <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
				   <td>
				       <brow:browser viewType="0" name="custids" browserValue='<%=taskResource.get("custs")%>' 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?splitflag=,"
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='0' 
						completeUrl="/data.jsp" linkUrl="/workflow/request/ViewRequest.jsp?requestid==#id#&id=#id#" 
						browserSpanValue='<%=taskResource.get("custspan")%>'></brow:browser>
				   </td>
				 </tr>
				  <% } %>
				  <% if(!"".equals(taskResource.get("projs")) && null!=taskResource.get("projs")) {%>
				  <tr>
				   <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
				   <td>
				       <brow:browser viewType="0" name="projids" browserValue='<%=taskResource.get("projs")%>' 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?splitflag=,"
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='0' 
						completeUrl="/data.jsp" linkUrl="/workflow/request/ViewRequest.jsp?requestid==#id#&id=#id#" 
						browserSpanValue='<%=taskResource.get("projspan")%>'></brow:browser>
				   </td>
				 </tr>
                <% } %>
				
			</table>
          </div>

		 </div>
		 <div class='panel' id='tasklog'>
		    
		 </div>
		 <div class='panel' id='taskremind'>
               
			   <div class='remindcontainer'>  
					<table class='remindtable'>
					  <colgroup>
						  <col width="20%">
						  <col width="80%">
                      </colgroup>
                      <tr>
					    <td><%=SystemEnv.getHtmlLabelName(18713,user.getLanguage())%></td>
						<td>
						    <span class="middlehelper"></span>
							<% if(remindtype == 0) {%>
							<INPUT type="radio" value="0" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 0) {%>checked<%}%> disabled><span><%=SystemEnv.getHtmlLabelName(19782,user.getLanguage())%></span>
							<% } %>
							<% if(remindtype == 1) {%>
							<INPUT type="radio" value="1" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 1) {%>checked<%}%> disabled><span><%=SystemEnv.getHtmlLabelName(17586,user.getLanguage())%></span>
							<% } %>
							<% if(remindtype == 2) {%>
							<INPUT type="radio" value="2" name="remindtype" id="remindtype" onclick="showRemindTime(this)" <%if (remindtype == 2) {%>checked<%}%> disabled><span><%=SystemEnv.getHtmlLabelName(18845,user.getLanguage())%></span>
						    <% } %>
						</td>
					 </tr>
					  <tr class='remindset'	>
							    <td><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15148,user.getLanguage())%></td>
								<td>
								      <span class="middlehelper"></span>
								     <input type="checkbox" name="issubmitremind" value="1" <% if(issubmitremind == 1) { %>checked<% } %>  disabled>
								</td>
					 </tr>
					 <tr style='display:none;'>
					    <td><%=SystemEnv.getHtmlLabelName(18177,user.getLanguage())%></td>
						<td>
						    <span class="middlehelper"></span>
							<INPUT type="checkbox" name="beforestart" value="1" <% if(beforestart == 1) { %>checked<% } %> disabled>
							<span><%=SystemEnv.getHtmlLabelName(19784,user.getLanguage())%></span>
							<INPUT class="InputStyle" type="text" name="beforestarttime"  id="beforestarttime" style="width:40px" size=5  value="<%= beforestarttime%>" onChange="inputChangeCheckBox('beforestarttime','beforestart')"/ disabled>
							<select name="beforestarttype" id="beforestarttype" onChange="onChangeStartTimeType(event)" style="display:'<%if(remindtype == 0) {%>none<%}%>'" disabled>
								<option value="0" <%if(beforestarttype == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
								<option value="1" <%if(beforestarttype == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
								<option value="2" <%if(beforestarttype == 2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
							</select>
                        </td>
					  </tr>
					  <tr style='display:none;'>
                        <td><%=SystemEnv.getHtmlLabelName(18080,user.getLanguage())%></td>
                        <td>
						    <span class="middlehelper"></span>
							<span><%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%></span>
							<INPUT class="InputStyle" type="text" name="beforestartper" id="beforestartper" style="width:40px" size=5  onChange="inputint('beforestartper')"  value="<%=beforestartper%>" disabled>
							<span id="beforestarttypespan" name="beforestarttypespan" ><%=startTimeType%></span>
					    </td>
					   </tr>
					   <tr class='remindset'> 
					     <td>
						    <%=SystemEnv.getHtmlLabelName(785,user.getLanguage())%>
						 </td>
                         <td>
						        <span class="middlehelper"></span>
								<INPUT type="checkbox" name="beforeend" id="beforeend" value="1" <% if(beforeend == 1) { %>checked<% } %> disabled>
								<span><%=SystemEnv.getHtmlLabelName(19785,user.getLanguage())%></span>
								<INPUT class="InputStyle" type="text" style="width:40px" name="beforeendtime" id="beforeendtime" size=5 value="<%= beforeendtime%>"  onChange="inputChangeCheckBox('beforeendtime','beforeend')" disabled>
								<select name="beforeendtype" id="beforeendtype" onChange="onChangeEndTimeType()" style="display:'<%if(remindtype == 0) {%>none<%}%>'" disabled>
									<option value="0" <%if(beforeendtype == 0){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1925,user.getLanguage())%></option>
									<option value="1" <%if(beforeendtype == 1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(391,user.getLanguage())%></option>
									<option value="2" <%if(beforeendtype == 2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15049,user.getLanguage())%></option>
								</select>
						 </td>
					   </tr>
					   <tr class='remindset'>
                         <td>
						    <%=SystemEnv.getHtmlLabelName(18080,user.getLanguage())%>
						 </td>
						 <td>
						     <span class="middlehelper"></span>
                             <span><%=SystemEnv.getHtmlLabelName(21977, user.getLanguage())%></span>
							 <INPUT class="InputStyle" type="text" name="beforeendper"  id="beforeendper" style="width:40px" size=5 onChange="inputint('beforeendper')" value="<%=beforeendper%>" disabled>
							 <span id="beforeendtypespan" name="beforeendtypespan"><%=endTimeType%></span>
						 </td>
					   </tr>
					</table>
				</div>
		 </div>
	</div>

</div>


<div class='tracecontainer' >

</div>

<div id='exchangeTb' style='display:none;'>
	 <table class='exchangeTemplate'>
			  <colgroup>
				  <col width="25%">
				  <col width="75%">
			  </colgroup>
			  <tr>
				 <td><%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%></td>
				 <td>
				     <input type='hidden'  name='relfileids' value=''>
					 <div class='relfileprocess'></div>
				     <div class='relfileitems'></div>
					 <div  style='border: 1px solid #E7E7E7;width: 150px;height: 25px;position:relative;border-radius: 3px;'><span class='relfileupload'></span></div>
				 </td>
			  </tr>
			  <tr>
				 <td><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%></td>
				 <td><span class='reldocs'></span></td>
			  </tr>
			  <tr>
				 <td><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%></td>
				 <td><span class='relwfs'></span></td>
			  </tr>
			  <tr>
				 <td><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%></td>
				 <td><span class='relcusts'></span></td>
			  </tr>
			  <tr>
				 <td><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%></td>
				 <td><span class='relprojs'></span></td>
			  </tr>
			  
	  </table>
</div>
</form>


 <div id="worktaskmsg" > <image src="/express/task/images/loading1_wev8.gif"> </div>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='../js/jquery-powerFloat-min_wev8.js'></script>
<script type='text/javascript' src='../js/jquery.workline_wev8.js'></script>
<script type='text/javascript' src='../js/jquery.expandable_wev8.js'></script>
<script src="/formmode/js/amcharts/amcharts_wev8.js" type="text/javascript"></script>
<script src="/formmode/js/amcharts/pie_wev8.js" type="text/javascript"></script>



<script>
   	function createChart(el,chartData,color){
		chart = new AmCharts.AmPieChart();
		chart.outlineAlpha = 1;
	    chart.dataProvider = chartData;
	    chart.titleField = "country";
	    chart.valueField = "visits";
	    chart.sequencedAnimation = false;
	    chart.startEffect = "easeInSine";
	    chart.colors=color
	    chart.innerRadius = "90%";
	    chart.startDuration = 0;
	  
	    chart.labelText = "";
	    chart.labelRadius = 2;
	    chart.labelsEnabled = true;
	    chart.balloonText = "";
	    chart.depth3D = 0;
	    chart.angle = 0;
	    chart.fontFamily = "Microsoft YaHei";
	    chart.fontSize = 11;
	    chart.marginTop = -10;
	    chart.marginLeft = -50;
	    chart.marginRight = -50;
	    chart.marginBottom = -10;
	    chart.gradientRatio = 5;
	    chart.write(el);
	}

</script>


<script language="javascript">

	 var requestid = <%=requestid%>;
	 //生成下拉框
     function getTaskSelectItems(){
		var items = [], value = '' ,opition;
	   var options = $("<%=tasksSelectStr.replaceAll("\"", "'")%>").find("option");
       for(var i=0,len=options.length;i<len;i++){
		  opition = $(options[i]); 
	      value = opition.attr("value");
		  if(value !== '0'){
		    items.push("<div wtid='"+value+"'>"+opition.html()+"</div>");
		  }else{
		    items.push("<div wtid='0'>"+SystemEnv.getHtmlLabelNames("149,22256", user.getLanguage())+"</div>");
		  }
	   }
	   return items;
	 }

    
    //设置紧急程度
    function  setUrge(status){
		  var  urgelevelshow =  $("#urgelevelshow"),urgeinput = urgelevelshow.find("input");
		  urgelevelshow.removeClass("normal").removeClass("important").removeClass("urge");
		  //正常
		  if(status === 0){
			 urgelevelshow.addClass("normal");
			 urgeinput.val(0);
			 urgelevelshow.attr("title",'<%=SystemEnv.getHtmlLabelName(225, user.getLanguage())%>');
		  //重要
		  }else if(status === 1){
			  urgelevelshow.addClass("important");
			  urgeinput.val(1);
			  urgelevelshow.attr("title",'<%=SystemEnv.getHtmlLabelName(25397, user.getLanguage())%>');
		  //紧急
		  }else if(status === 2){
			urgelevelshow.addClass("urge");
			urgeinput.val(2);
			urgelevelshow.attr("title",'<%=SystemEnv.getHtmlLabelName(2087, user.getLanguage())%>');
		  }	
		  if($("#floatBox_list").is(":visible"))
		     $(".urgelevel").trigger('click');
	
	}

	 /**
	生成任务清单人力资源浏览框
	**/
	function generatorResourceBrow(browcontainer,userid,username){
       var cuserid="",cusername="";
        if(userid ==='' && username === ''){
            cuserid = '<%=user.getUID()%>';
            cusername = '<%=user.getUsername()%>';
        }else{
           cuserid = userid;
           cusername = username;
        }
		browcontainer.e8Browser({
					name:'tasklistperson',
					viewType:"0",
					browserValue:cuserid,
					isMustInput:"0",
					browserSpanValue:cusername,
					hasInput:true,
					width:"50px",	
					linkUrl:"#",
					completeUrl:"/data.jsp?type=17",
					browserUrl:'/hrm/resource/MutiResourceBrowser.jsp?selectedids=&resourceids=',
					hasAdd:false,
					isSingle:true
		 });

	}

    /*根据条件生成浏览框*/
	function generatorBrowserByCondition(browcontainer,name,bvalue,bspanvalue,completeUrl,browserUrl){
		browcontainer.e8Browser({
					name:name,
					viewType:"0",
					browserValue:bvalue,
					isMustInput:"1",
					browserSpanValue:bspanvalue,
					hasInput:true,
					width:"250px",	
					linkUrl:"#",
					completeUrl:completeUrl,
					browserUrl:browserUrl,
					hasAdd:false,
					isSingle:true
		 });
	}

  
	function OnShare(){
		//location.href="/worktask/request/RequestShareSet.jsp?requestid=<%=requestid%>&wtid=<%=wtid%>";
		 var dlg=new window.top.Dialog();//定义Dialog对象
		// dialog.currentWindow = window;
	　　dlg.Model=false;
	　　dlg.Width=700;//定义长度
	　　dlg.Height=500;
	　　dlg.URL="/worktask/request/RequestShareList.jsp?requestid=<%=requestid%>&wtid=<%=wtid%>";
	　　dlg.Title='<%=SystemEnv.getHtmlLabelName(31843,user.getLanguage())%>';
		dlg.maxiumnable=false;
	　　dlg.show();
	}

</script>
<script language="javascript"  src="../js/jquery.placeholder_wev8.js"></script>
<script language="javascript"  defer="defer" src="/js/datetime_wev8.js"></script>
<script language="javascript"  src="/js/selectDateTime_wev8.js"></script>
<script language="javascript"  defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="javascript"  src="../js/worktask_wev8.js"></script>
<!--swfupload相关-->
<link href="/js/page/swfupload/default_wev8.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="/js/page/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/page/swfupload/handlers_wev8.js"></script>
<script>


//任务清单详细信息
var taskliststatus = <%=WorkTaskResourceUtil.getWorktaskRelationTaskAsJson(recordSet_requestbase,requestid+"",user)%> ; 



$(document).ready(function(){
     setTopButtonTitle();
    //计算 worktask_detaillist 高度
    $(".worktask_detailinfo").css("height",($(window.top.document.body).height()-145)+'px');
    $('.worktask_detailinfo').perfectScrollbar();	
    
     $(".closeitem").bind('click',function(ev){ 
          <% if(!"".equals(retasklistid)){ %>
		  	 parent.window.hideLeftTaskPanel("childedittask");	 
		  <%}else{%>
		     parent.window.hideLeftTaskPanel("worktaskdetail");	 
		  <%}%>
    }); 
    
    $('.taskcontentarea').css("height","38px");
    $('.taskcontentarea').expandable({interval:300,duration:'fast'});
    //alert(($('.taskcontentarea').css("height")-70));
     

	 //任务交流搜索事件
	 $(".taskexchangesearch").click(function(){
			   var searchcondition = $(".seachcondition");
			   var current = $(this);
			   if(searchcondition.is(":visible")) {
				  searchcondition.hide();
				  current.removeClass('taskexchangesearchchecked');
			   }else{
				  searchcondition.show(); 
				  current.addClass('taskexchangesearchchecked');
			   }
	 });
     //任务交流 查询取消
	 $(".cacellchitem").click(function(){
	      $(".seachcondition").hide();
          $(".taskexchangesearch").removeClass('taskexchangesearchchecked');
	});

     //根据内容显示交流意见
	 function  showExchangeByContents(contentstr){
	    var contentitems = $(".contentitem");
        var content,contentitem;
		for(var i=0,len=contentitems.length;i<len;i++){
			  contentitem = $(contentitems[i]);
		      content = contentitem.html();
			  if(content.indexOf(contentstr)>-1){
			     if(contentitem.hasClass("litem")){
				    contentitem.parents(".lcommentcontainer").show();
				 }else{
				    contentitem.parents(".rcommentcontainer").show();
				 }
			  }
		}
	 }
   //根据参与人显示交流意见
    function  showExchangeByExperson(expersons){
		expersons = expersons+",";
	    var persons = $("input[name='experson']");
        var content,personitem;
		//alert(persons.length);
		for(var i=0,len=persons.length;i<len;i++){
			  personitem = $(persons[i]);
		      content = personitem.val()+",";
			  if(expersons.indexOf(content)>-1){
			     if(personitem.hasClass("litem")){
				    personitem.parents(".lcommentcontainer").show();
				 }else{
				    personitem.parents(".rcommentcontainer").show();
				 }
			  }
		}
	 }
     //根据两个条件查询
     function  showExchangeByContentAndPerson(contentstr,expersons){
		  expersons = expersons+",";
	      var lcontainers = $(".lcommentcontainer"),rcontainers = $(".rcommentcontainer"),containers=[],container,content,person;
		  for(var i = 0,len=lcontainers.length;i<len;i++){
		      containers.push(lcontainers[i]);
		  }
		  for(var i = 0,len=rcontainers.length;i<len;i++){
		      containers.push(rcontainers[i]);
		  }
          for(var i=0,len=containers.length;i<len;i++){
		       container = $(containers[i]);
		       content = container.find(".contentitem").html();
               person = container.find("input[name='experson']").val()+",";
               if(content.indexOf(contentstr)>-1 && expersons.indexOf(person)>-1){
			       container.show();
			   }
		  }
	 
	 
	 }

     //隐藏所有交流意见
	 function hideAllExchange(){
	    $(".lcommentcontainer").hide();
	    $(".rcommentcontainer").hide();
	 }

     //展示所有
	 function showAllExchange(){
	    $(".lcommentcontainer").show();
	    $(".rcommentcontainer").show();
	 }
	
     //任务交流 查询
	 $(".searchitem").click(function(){
	      var excontent = $("input[name='excontent']").val();
		  var expersons = $("input[name='expersons']").val();
		  if(excontent === '' && expersons === ''){
		       showAllExchange();
		  }
		  if(excontent !== '' &&  expersons === ''){
		        hideAllExchange();
                showExchangeByContents(excontent);
		 }
		  if(excontent === '' &&  expersons !== ''){
		        hideAllExchange();
                showExchangeByExperson(expersons);
		  }
		  if(excontent !== '' &&  expersons !== ''){
		       hideAllExchange();
               showExchangeByContentAndPerson(excontent,expersons);
		  }
          $(".cacellchitem").trigger('click');
	 });
	 
	 //点击 其他地方需要隐藏的元素
	 $(document).bind('click',function(ev){ 
		  var ev=ev||window.event;
		  var element=ev.target||ev.srcElement;  
		  $(".hritems").hide();
		 
    }); 
    
});

//设置按钮标题，以及绑定事件
function setTopButtonTitle(){

    <%  if(canApprove==true && nodetype==1){ %>	
		$(".topbutton").html("<%=SystemEnv.getHtmlLabelName(142, user.getLanguage())%>");
		$(".topbutton").bind("click",function(){
		   OnApprove();
		});
		
	<%}else if(canApprove==true && nodetype==2){%>
		$(".topbutton").html("<%=SystemEnv.getHtmlLabelName(615, user.getLanguage())%>");
		$(".topbutton").bind("click",function(){
		   OnApprove();
		});
	<%}%>
	<%if(canBack==true && operatorid!=0){%>
		$(".topbutton").html("<%=SystemEnv.getHtmlLabelName(555, user.getLanguage())%>");
		$(".topbutton").bind("click",function(){
		   OnExecute();
		});
	<%}%>
	<%if(canCheck==true && operatorid!=0 && request_status ==9){%>		
		$(".topbutton").html("<%=SystemEnv.getHtmlLabelName(15376, user.getLanguage())%>");
		$(".topbutton").bind("click",function(){
		   OnCheckSuccess();
		});
	<%}%>
    
    if($(".topbutton").html()==""){
       $(".topbutton").next("span").hide();
       $(".topbutton").hide();
    }
}




//显示明细信息
function  showListDetail(currentitem,tasklistid){
    $(".tasklistitems").hide();
    if((tasklistid in taskliststatus) && taskliststatus[tasklistid].length>0){
		var offset = $(currentitem).offset();
		var container = $("<div class='tasklistitems' ><table><colgroup><col width='*'><col width='15%'><col width='10%'><col width='14%'><col width='8%'></colgroup><tbody></tbody></table></div>");
		container.css("top",(offset.top+25)+'px');
        var items = taskliststatus[tasklistid],tr;
		for(var i=0;i<items.length;i++){
		   tr = $("<tr><td title='"+items[i].taskname+"'>"+items[i].taskname+"<input type='hidden' name='reqid' value='"+items[i].requestid+"'><input type='hidden' name='taskid' value='"+items[i].taskid+"'><input type='hidden' name='status' value='"+items[i].status+"'><input type='hidden' name='wtlistid' value='"+tasklistid+"'></td><td>"+items[i].liableperson+"</td><td><span class='finished'>"+items[i].hascomplete+'</span>/'+(~~items[i].hascomplete+~~items[i].uncomplete)+"</td><td>"+(((items[i].uncomplete==='0' && items[i].hascomplete !='0') || items[i].status=='10')?'<span class=\"finished\"><%=SystemEnv.getHtmlLabelName(555,user.getLanguage())%></span>':'<span><%=SystemEnv.getHtmlLabelName(732,user.getLanguage())%></span>')+"</td><td><span title='<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>' style='display:none;cursor:pointer;' class='removerelation'>X</span></td></tr>");
           container.find("tbody").append(tr);
		}
		if(items.length==0){
		   tr = $("<tr><td title='<%=SystemEnv.getHtmlLabelName(83603,user.getLanguage())%>'><td colspan='5'><%=SystemEnv.getHtmlLabelName(83603,user.getLanguage())%></td></tr>");
           container.find("tbody").append(tr);
		}
		
		$(document.body).append(container);
		container.find("tr").hover(function(){
		     $(this).find(".removerelation").show();
		},function(){
		     $(this).find(".removerelation").hide();
		});
        var that = container;
		$(document.body).click(function(e){
        	var current = e.target;
        	var $this = $(current);
        	if(that[0] !== current  &&  !!!that.has($this).length &&  !$this.hasClass("histaskstatus")){
        		that.remove();
        	}
        });
        
        container.find("tr").click(function(e){
        	var requestid = $(this).find("input[name='reqid']").val();
        	var tasklistid = $(this).find("input[name='wtlistid']").val();
        	var taskid = $(this).find("input[name='taskid']").val();
        	var status = $(this).find("input[name='status']").val();
		    e.stopPropagation();
        	 parent.window.onChildEditTask(requestid,taskid,tasklistid,status);
        });
        
	//删除关联关系
         $(".removerelation").bind('click',function(e){ 
            e.stopPropagation();
	        var $this = $(this);
            window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("83023,27816",user.getLanguage())%>?',function(){
	            var senddata = {};
				var reqid = $this.parents("tr").find("input[name='reqid']").val(),tasklistid = $this.parents("tr").find("input[name='wtlistid']").val(), currentrequestid = $("#requestid").val();
                      senddata["requestid"] = reqid;
					  senddata["currentrequestid"] = currentrequestid;
                      senddata["tasklistid"] = tasklistid;
			    $.ajax({
					  type: "POST",
					  url:"/worktask/pages/taskrelationdrop.jsp",
					  dataType:'json',
					  data:senddata,
					  success:function(data){
						  if(data.success === '1'){
							   //刷新进度圈
                              refreshTaskProcess(tasklistid,reqid);
							  taskliststatus = data.itemsnew;
                              $this.parents("tr").remove();
							  $(".tasklistitems").hide();
						  }
						  else
							  window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelNames("563,30651",user.getLanguage())%>!');  
					  }
			    });
	        });
        }); 
  
	}else{
	   var offset = $(currentitem).offset();
		var container = $("<div class='tasklistitems' ><table><colgroup><col width='*'></colgroup><tbody></tbody></table></div>");
		container.css("top",(offset.top+25)+'px');
		var tr = $("<tr><td title='<%=SystemEnv.getHtmlLabelName(83603,user.getLanguage())%>' align='center'><%=SystemEnv.getHtmlLabelName(83607,user.getLanguage())%>\"+\"<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>!</td></tr>");
        container.find("tbody").append(tr);
        $(document.body).append(container);
        var that = container;
		$(document.body).click(function(e){
        	var current = e.target;
        	var $this = $(current);
        	if(that[0] !== current  &&  !!!that.has($this).length &&  !$this.hasClass("histaskstatus")){
        		that.remove();
        	}
        });
	}

}

//初始化页面
function initPage(){
  //设置紧急程度
   setUrge(<%=urgency%>);
  //初始化tab页
   initTabs(1);
  if(requestid === 0){
     initEndDate();
     $(".addwt").trigger('click');  	
  }else{
   //非创建页面   
    var workList = <%=wtRequestManager.getWorkTaskJsonListByRequestid(requestid+"")%>;
	if( workList.length === 0 ){
	  $(".worktasklist").remove();
	}
    //恢复工作清单信息
    for(var i=0;i<workList.length;i++){
      addViewTask(workList[i],<%=user.getUID()%>,<%=request_status%>);
    }
    //设置进度条
	setProcess();
    //生成附件清单
	var filelist = <%=(taskResource.get("attachsjson").equals("")?"[]":taskResource.get("attachsjson"))%> ; 
    for(var i=0;i<filelist.length;i++){
	    var file="<span class='filecontainer' ><input type='hidden' value='"+filelist[i].fileid+"'><span class='middlehelper'></span><a class='filedes' target='_blank' href='/weaver/weaver.file.FileDownload?fileid="+filelist[i].fileid+"' > "+filelist[i].filename+" </a></span>";
		$(".fileitems").append($(file));	
	}
	<%if (remindtype == 0) {%>
            $(".remindset").hide();
    <% } %>

    var tracelist = <%=WorkTaskResourceUtil.getWorktaskTraceAsJson(recordSet_requestbase,requestid+"",user)%> ; 
	//生成轨迹
	$(".tracecontainer").taskline(tracelist);
	$(".trace").click(function(){
	      $(".tracecontainer").show();
		  $(".tracecontainer").perfectScrollbar({horizrailenabled:false,zindex:1000});
	});

     //文本框自增长
//	 $("textarea[name='exmsg']").live("keyup keydown",function(e){
//		var h=$(this);
//		h.height(22).height(h[0].scrollHeight);
 ///    });

    $("textarea[name='exmsg']").expandable({interval:500});
    
    $("textarea[name='exmsg']").focus(function(){
		 $(".feedbackcontainer").css("border-top","1px solid rgb(118, 193, 237)");
	});
	$("textarea[name='exmsg']").focusout(function(){
		 $(".feedbackcontainer").css("border-top","1px solid #f2f2f2");
	});


	/*以下为input框自动联想*/
	(function($) {
    $.fn.getCursorPosition = function() {
        var input = this.get(0);
        if (!input) return; // No (input) element found
        if (document.selection) {
            // IE
           input.focus();
        }
        return 'selectionStart' in input ? input.selectionStart:'' || Math.abs(document.selection.createRange().moveStart('character', -input.value.length));
     }
   })(jQuery);

   /**
	* 按键按下
	* @param e
	*/
   function  keyup(e)
   {
	   var keycode= e.which;
	   var current;
	   e.stopPropagation();
	   if($(".hritems li").length===0)
		   return;
	   var hrmitems = $(".hritems li");
	   //向上
	   if(keycode===38)
	   {
		   var currentactive = jQuery("li.hrmitemactive");
		   var prev = currentactive.prev("li"); 
		   if(prev.length===0)
				prev = hrmitems.eq(hrmitems.length-1);
		   e.preventDefault();
		   currentactive.removeClass("hrmitemactive");
		   prev.addClass("hrmitemactive"); 
		}
	   //向下
	   else if(keycode===40)
	   {
		   var currentactive = jQuery("li.hrmitemactive"); 
		   var next = currentactive.next("li"); 
		   if(next.length===0)
			 next = hrmitems.eq(0);
		   e.preventDefault();
		   currentactive.removeClass("hrmitemactive");
		   next.addClass("hrmitemactive"); 
	   //enter选择
	   }else if(keycode===13)
	   {
		   
		   e.preventDefault();
		   var item = {};
		   var iteminfo=jQuery("li.hrmitemactive");
		   item["id"] = iteminfo.attr("value");
		   item["name"] = iteminfo.html();
		   var inputitem = $("textarea[name='exmsg']");
		   var inputval = inputitem.val();
		   inputval = inputval.substring(0,beginpos+1)+iteminfo.html()+inputval.substring(beginpos+seachstr.length+1);
		   inputitem.val(inputval);
		  // alert(inputitem.val());
		  // inputitem.focus();
		   $(".hritems").remove();
		   beginpos = -1;
		   selectItems.push(item);
		  // alert(iteminfo.html());
		   
	   }

   }
   //阻止输入框浏览器默认行为(即按向上箭头输入框光标会自动置于输入框的起始位置)
 //   $("textarea[name='exmsg']")[0].addEventListener("keydown", function(e) {
//		 e.stopPropagation();
  //      if ((e.keyCode === 38 || e.keyCode === 40 || e.keyCode===13) && $(".hritems").is(":visible"))  e.preventDefault();
		
	//}, false);
   
   $("textarea[name='exmsg']").keydown(function(e){
         e.stopPropagation();
        if ((e.keyCode === 38 || e.keyCode === 40 || e.keyCode===13) && $(".hritems").is(":visible"))  e.preventDefault();
   
   });


    //@开始位置
    var beginpos=-1;
	//搜索字符窜
	var seachstr="";
    //@操作
    $(".exmsgwrapper").keyup(function(e){
		 var keycode= e.which;
		 keyup(e);
		 if(keycode===38 || keycode===40){
		    return;
		 }
        // keyup(e);
		 e.stopPropagation();
		 e.preventDefault();  
         $(".lengthtemp").remove();
		 var inputitem = $("textarea[name='exmsg']");
         var val = inputitem.val();
		 var position = inputitem.getCursorPosition();
		// console.log("position1======>"+inputitem.caret());
		// console.log("val======>"+val);
         var lastchar , currentstr ; 
		 if(val !== ''){
			 val = val.substring(0,position);
			 lastchar = val.substring(val.length-1);
			// console.log("lastchar======>"+lastchar);
			// console.log("position======>"+position);
			 if(lastchar === '@'){
			    beginpos = val.length-1;
             }
			 if(position-1 < beginpos){
				 beginpos = -1;
                 $(".hritems").remove();
				 return;
			 }
			 if(lastchar !== '@' && beginpos>=0 ){
			   // console.log("查询字符窜==>"+val.substring(beginpos+1));
				seachstr = val.substring(beginpos+1);
				currentstr = seachstr;
               //延时请求发送 
				setTimeout(function(){
				      if(currentstr === seachstr && seachstr !== ' ' && seachstr !== ''){
						 // console.log("seachstr=====>"+seachstr);
					      var senddata = {};
						  senddata["q"] = seachstr;
						  senddata["limit"] = 5;
						  senddata["timestamp"] = new Date().toString();
						   $.ajax({
							  type: "POST",
							  url:"/data.jsp?type=17",
							  dataType:'json',
							  data:senddata,
							  success:function(datas){
								   $(".hritems").remove();
								   var inputval = inputitem.val();
								   var atbeforevalue = inputval.substring(0,beginpos+1);
                                   var currentn = atbeforevalue.lastIndexOf("\n");
								   //@之前换行符个数
								   var beforencount = 0;
								   if(atbeforevalue.match(/\n/g)!==null){
								      beforencount = atbeforevalue.match(/\n/g).length;
									}
								   //
								   var bottomheight = $(window).height()-inputitem.offset().top-beforencount*16;
								   inputval = inputval.substring(currentn+1,beginpos+1);
                                   inputval= inputval.replace(/\s/g, '&nbsp;')
								   var temp = $("<span class='lengthtemp' style='display:none;font-size:12px;'></span>").html( inputval );
			                       $(document.body).append(temp);
								   var size  = (datas.length > 5 ? 5 : datas.length);
								   var itemels = $("<ul class='hritems'></ul>"),liel;
								   itemels.css("left",(temp.width()+10)+'px');
								   itemels.css("bottom",(bottomheight)+'px');
								   for(var i=0;i<size;i++){
									   if(i===0)
								          liel = $("<li class='hrmitemactive' value='"+datas[i].id+"'>"+datas[i].name+"</li>");
									   else
                                          liel = $("<li value='"+datas[i].id+"'>"+datas[i].name+"</li>");
									   itemels.append(liel);
								   }
                                   $(document.body).append(itemels);
								   itemels.find("li").click(function(e){
								       e.preventDefault();
									   e.stopPropagation();
									   var item = {};
									   var iteminfo=$(this);
									   item["id"] = iteminfo.attr("value");
									   item["name"] = iteminfo.html();
									   var inputitem = $("textarea[name='exmsg']");
									   var inputval = inputitem.val();
									   inputval = inputval.substring(0,beginpos+1)+iteminfo.html()+inputval.substring(beginpos+seachstr.length+1);
									   inputitem.val(inputval);
									  // alert(inputitem.val());
									  // inputitem.focus();
									   $(".hritems").remove();
									   beginpos = -1;
									   selectItems.push(item);
								   });
							  }
							});
                            
					  }
				},400);

			 }
			
			 //1.获取位置 2.获取插入@的位置
			 //console.log(temp.width());
		 }
	});

  }
}

initPage();

function showRemindTime(obj){
	if("0" == obj.value){
		$(".remindset").hide();
	}else{
		$(".remindset").show();
	}
}

//展示更多交流信息
function feedBackMore(){
    $(".lcommentcontainer").show();
    $(".rcommentcontainer").show();
    $(".feedbackmore").hide();
}



$('input, textarea').placeholder();


var diag,selectinfos={},selectItems = [];;

/*设置相关资源值*/
function  setSelectInfos(inputname,spanname){
   var ids = $("input[name='"+inputname+"']").val();
   if(ids!==''){
		   var spans = $("#"+spanname).find("a"),spanvalues=[];
		   for(var i=0,len=spans.length;i<len;i++){
		       spanvalues.push($(spans[i]).html());
		   }
		   selectinfos[inputname] = ids;
		   selectinfos[spanname] = spanvalues.join(",");
    }else{
	       selectinfos[inputname] = '';
	       selectinfos[spanname] = '';
	}
}

$(".exchangeAttach").click(function(){    
    if(diag === undefined){
		var cloneitem = $("#exchangeTb").clone(); 
		cloneitem.find(".exchangeTemplate").addClass("exchangeres");
		diag = new Dialog();
		diag.normalDialog = false;
        diag.Width = 370;
        diag.Height = 240;
        diag.Title = "<%=SystemEnv.getHtmlLabelName(22672,user.getLanguage())%>";
        diag.InnerHtml= "<div style='height:100%;overflow:auto;'>"+cloneitem.html()+"</div>";
        diag.OKEvent = function(){
		  	var relfileitems =  $(".exchangeres .relfilecontainer");
			var relfiles = [],obj,current;
			for(var i=0,len=relfileitems.length;i<len;i++){
			   obj={},current=$(relfileitems[i]);
			   obj["fileid"] = current.find("input[type='hidden']").val();
               obj["filename"] = current.find(".relfiledes").html();
			   relfiles.push(obj);
			}
            selectinfos["fileids"] = $(".exchangeres").find("input[name='relfileids']").val();
            selectinfos["files"] = relfiles;
			setSelectInfos("reldocs","reldocsspan");
			setSelectInfos("relwfs","relwfsspan");
			setSelectInfos("relcusts","relcustsspan");
			setSelectInfos("relprojs","relprojsspan");
            
			getRealResourceEl();

			diag.close();
		};//点击确定后调用的方法
        diag.show();
		generatorBrowserByCondition($(".exchangeres").find(".reldocs"),'reldocs','','',"/data.jsp?type=9","/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docs/MutiDocBrowser.jsp?documentids=");
		generatorBrowserByCondition($(".exchangeres").find(".relwfs"),'relwfs','','',"/data.jsp?type=16","/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids=");
		generatorBrowserByCondition($(".exchangeres").find(".relcusts"),'relcusts','','',"/data.jsp?type=7","/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?splitflag=,");
		generatorBrowserByCondition($(".exchangeres").find(".relprojs"),'relprojs','','',"/data.jsp?type=8","/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?splitflag=,");
		var fileupload = $(".exchangeres .relfileupload"),fileuuid = new UUID();
        fileupload.attr("id",fileuuid);
        initSwfUploadForEx(fileuuid);
		$(".exchangeres .relfileitems").delegate(".fileclose","click",function(){
		     var self = $(this);
		     window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(82017,user.getLanguage())%>',function(){
			   self.parents(".relfilecontainer").remove();
			   resetFileids();
	    	 });
		});
	}else{
	   diag.show();
       if(selectinfos["reldocs"]!==undefined && selectinfos["reldocs"]!==''){
	      generatorBrowserByCondition($(".exchangeres").find(".reldocs"),'reldocs',selectinfos["reldocs"],selectinfos["reldocsspan"],"/data.jsp?type=9","/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docs/MutiDocBrowser.jsp?documentids=");
	   }else{
	      generatorBrowserByCondition($(".exchangeres").find(".reldocs"),'reldocs','','',"/data.jsp?type=9","/systeminfo/BrowserMain.jsp?mouldID=doc&url=/docs/docs/MutiDocBrowser.jsp?documentids=");
	   }
       if(selectinfos["relwfs"]!==undefined && selectinfos["relwfs"]!==''){
	      generatorBrowserByCondition($(".exchangeres").find(".relwfs"),'relwfs',selectinfos["relwfs"],selectinfos["relwfsspan"],"/data.jsp?type=16","/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids=");
	   }else{
	      generatorBrowserByCondition($(".exchangeres").find(".relwfs"),'relwfs','','',"/data.jsp?type=16","/systeminfo/BrowserMain.jsp?url=/workflow/request/MultiRequestBrowser.jsp?resourceids=");
	   }
	   if(selectinfos["relcusts"]!==undefined && selectinfos["relcusts"]!==''){
	      generatorBrowserByCondition($(".exchangeres").find(".relcusts"),'relcusts',selectinfos["relcusts"],selectinfos["relcustsspan"],"/data.jsp?type=7","/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?splitflag=,");
	   }else{
	      generatorBrowserByCondition($(".exchangeres").find(".relcusts"),'relcusts','','',"/data.jsp?type=7","/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?splitflag=,");
	   }
	   if(selectinfos["relprojs"]!==undefined && selectinfos["relprojs"]!==''){
	      generatorBrowserByCondition($(".exchangeres").find(".relprojs"),'relprojs',selectinfos["relprojs"],selectinfos["relprojsspan"],"/data.jsp?type=8","/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?splitflag=,");
	   }else{
	      generatorBrowserByCondition($(".exchangeres").find(".relprojs"),'relprojs','','',"/data.jsp?type=8","/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?splitflag=,");
	   }
       if(selectinfos["fileids"]!==undefined && selectinfos["fileids"]!==''){
		   $(".exchangeres").find("input[name='relfileids']").val(selectinfos["fileids"]);
		   var fileitems = selectinfos["files"];
		   for(var i=0;i<fileitems.length;i++){
		     var file="<span class='relfilecontainer' ><input type='hidden' value='"+fileitems[i].fileid+"'><span class='middlehelper'></span><a class='relfiledes' target='_blank' href='/weaver/weaver.file.FileDownload?fileid="+fileitems[i].fileid+"' > "+fileitems[i].filename+"     </a><span class='fileclose'>X</span></span>";
		      $(".exchangeres .relfileitems").append($(file));
		   }
	   }
	   var fileupload = $(".exchangeres .relfileupload"),fileuuid = new UUID();
       fileupload.attr("id",fileuuid);
       initSwfUploadForEx(fileuuid);

	   $(".exchangeres .relfileitems").delegate(".fileclose","click",function(){
		     var self = $(this);
		     window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(82017,user.getLanguage())%>',function(){
			   self.parents(".relfilecontainer").remove();
			   resetFileids();
	    	 });
		});
	}

});

//获取相关资源元素
function  getRealResourceEl(){

    var resource = [],ids,names,id,name,reldocstr="",relcuststr="",relwfstr="",relprojstr="",fileidstr="", senddata = {};;
	if(selectinfos["reldocs"]!==undefined && selectinfos["reldocs"]!==''){
		senddata["reldocs"] = selectinfos["reldocs"];
		ids = selectinfos["reldocs"].split(",");
		names = selectinfos["reldocsspan"].split(",");
		for(var i=0;i<ids.length;i++){
		  id = ids[i],name = names[i];
	      resource.push("<a href='javascript:void(0)'  linkid="+id+" linkType='doc' onclick=\"try{return openAppLink(this,"+id+");}catch(e){}\" ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:none !important;margin-right:8px;vertical-align: middle;'>"+name+"</a>&nbsp;");	  
		}
		if(ids.length > 0)
		  reldocstr = "<div class='rswrapper'><span class='middlehelper'></span><span class='title'><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>&nbsp;:&nbsp;</span>"+resource.join("")+"</div>";
    }
	
	if(selectinfos["relwfs"]!==undefined && selectinfos["relwfs"]!==''){
		resource = [];
		senddata["relwfs"] = selectinfos["relwfs"];
		ids = selectinfos["relwfs"].split(",");
		names = selectinfos["relwfsspan"].split(",");
		for(var i=0;i<ids.length;i++){
		  id = ids[i],name = names[i];
	      resource.push("<a href='javascript:void(0)'  linkid="+id+" linkType='workflow' onclick=\"try{return openAppLink(this,"+id+");}catch(e){}\" ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:none !important;margin-right:8px;vertical-align: middle;'>"+name+"</a>&nbsp;");	  
		}
		if(ids.length > 0)
		  relwfstr = "<div class='rswrapper'><span class='middlehelper'></span><span class='title'><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>&nbsp;:&nbsp;</span>"+resource.join("")+"</div>";
    }
	if(selectinfos["relcusts"]!==undefined && selectinfos["relcusts"]!==''){
		resource = [];
		senddata["relcusts"] = selectinfos["relcusts"];
		ids = selectinfos["relcusts"].split(",");
		names = selectinfos["relcustsspan"].split(",");
		for(var i=0;i<ids.length;i++){
		  id = ids[i],name = names[i];
	      resource.push("<a href='javascript:void(0)'  linkid="+id+" linkType='crm' onclick=\"try{return openAppLink(this,"+id+");}catch(e){}\" ondblclick='return false;'   style='cursor:pointer;text-decoration:none !important;margin-right:8px;vertical-align: middle;'>"+name+"</a>&nbsp");	 
		}
		if(ids.length > 0)
		  relcuststr = "<div class='rswrapper'><span class='middlehelper'></span><span class='title'><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%>&nbsp;:&nbsp;</span>"+resource.join("")+"</div>";
    }
	if(selectinfos["relprojs"]!==undefined && selectinfos["relprojs"]!==''){
		resource = [];
		senddata["relprojs"] = selectinfos["relprojs"];
		ids = selectinfos["relprojs"].split(",");
		names = selectinfos["relprojsspan"].split(",");
		for(var i=0;i<ids.length;i++){
		  id = ids[i],name = names[i];
	      resource.push("<a href='javascript:void(0)'  linkid="+id+" linkType='project' onclick=\"try{return openAppLink(this,"+id+");}catch(e){}\" ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:none !important;margin-right:8px;vertical-align: middle;'>"+name+"</a>&nbsp;");	  
		}
		if(ids.length > 0)
		  relprojstr = "<div class='rswrapper'><span class='middlehelper'></span><span class='title'><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%>&nbsp;:&nbsp;</span>"+resource.join("")+"</div>";
    }
    //相关附件
	 if(selectinfos["fileids"]!==undefined && selectinfos["fileids"]!==''){
		   resource = [];
		   senddata["fileids"] = selectinfos["fileids"];
		   var fileitems = selectinfos["files"];
		   for(var i=0;i<fileitems.length;i++){
		     resource.push("<a class='relfiledes' target='_blank' href='/weaver/weaver.file.FileDownload?fileid="+fileitems[i].fileid+"' > "+fileitems[i].filename+"</a>");
		   }
		   if(fileitems.length > 0)
		     fileidstr = "<div class='rswrapper'><span class='middlehelper'></span><span class='title'><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%>&nbsp;:&nbsp;</span>"+resource.join("")+"</div>";
	  }
     
	  var resourceitem =  $("<div class='realresource'>"+reldocstr+relwfstr+relcuststr+relprojstr+fileidstr+"</div>");
	  var feedbackcontainer = $(".feedbackcontainer");
      feedbackcontainer.find(".realresource").remove();     
	  feedbackcontainer.append(resourceitem);
}



//发送消息
$(".sendmsg").click(function(){
    
    var keys = [];
	for(var item in selectinfos){
	  if(selectinfos.hasOwnProperty(item))
		keys.push(item)
    }
	//反馈信息不能为空
	if(keys.length === 0  && $("textarea[name='exmsg']").val()==='')
	{
	   window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83624,user.getLanguage())%>");
	   return false;
	}

	var resource = [],ids,names,id,name,reldocstr="",relcuststr="",relwfstr="",relprojstr="",fileidstr="", senddata = {};;
	if(selectinfos["reldocs"]!==undefined && selectinfos["reldocs"]!==''){
		senddata["reldocs"] = selectinfos["reldocs"];
		ids = selectinfos["reldocs"].split(",");
		names = selectinfos["reldocsspan"].split(",");
		for(var i=0;i<ids.length;i++){
		  id = ids[i],name = names[i];
	      resource.push("<a href='javascript:void(0)'  linkid="+id+" linkType='doc' onclick=\"try{return openAppLink(this,"+id+");}catch(e){}\" ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:none !important;margin-right:8px;vertical-align: middle;'>"+name+"</a>&nbsp;");	  
		}
		if(ids.length > 0)
		  reldocstr = "<div class='rswrapper'><span class='middlehelper'></span><span class='title'><%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>&nbsp;:&nbsp;</span>"+resource.join("")+"</div>";
    }
	
	if(selectinfos["relwfs"]!==undefined && selectinfos["relwfs"]!==''){
		resource = [];
		senddata["relwfs"] = selectinfos["relwfs"];
		ids = selectinfos["relwfs"].split(",");
		names = selectinfos["relwfsspan"].split(",");
		for(var i=0;i<ids.length;i++){
		  id = ids[i],name = names[i];
	      resource.push("<a href='javascript:void(0)'  linkid="+id+" linkType='workflow' onclick=\"try{return openAppLink(this,"+id+");}catch(e){}\" ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:none !important;margin-right:8px;vertical-align: middle;'>"+name+"</a>&nbsp;");	  
		}
		if(ids.length > 0)
		  relwfstr = "<div class='rswrapper'><span class='middlehelper'></span><span class='title'><%=SystemEnv.getHtmlLabelName(1044,user.getLanguage())%>&nbsp;:&nbsp;</span>"+resource.join("")+"</div>";
    }
	if(selectinfos["relcusts"]!==undefined && selectinfos["relcusts"]!==''){
		resource = [];
		senddata["relcusts"] = selectinfos["relcusts"];
		ids = selectinfos["relcusts"].split(",");
		names = selectinfos["relcustsspan"].split(",");
		for(var i=0;i<ids.length;i++){
		  id = ids[i],name = names[i];
	      resource.push("<a href='javascript:void(0)'  linkid="+id+" linkType='crm' onclick=\"try{return openAppLink(this,"+id+");}catch(e){}\" ondblclick='return false;'   style='cursor:pointer;text-decoration:none !important;margin-right:8px;vertical-align: middle;'>"+name+"</a>&nbsp");	 
		}
		if(ids.length > 0)
		  relcuststr = "<div class='rswrapper'><span class='middlehelper'></span><span class='title'><%=SystemEnv.getHtmlLabelName(783,user.getLanguage())%>&nbsp;:&nbsp;</span>"+resource.join("")+"</div>";
    }
	if(selectinfos["relprojs"]!==undefined && selectinfos["relprojs"]!==''){
		resource = [];
		senddata["relprojs"] = selectinfos["relprojs"];
		ids = selectinfos["relprojs"].split(",");
		names = selectinfos["relprojsspan"].split(",");
		for(var i=0;i<ids.length;i++){
		  id = ids[i],name = names[i];
	      resource.push("<a href='javascript:void(0)'  linkid="+id+" linkType='project' onclick=\"try{return openAppLink(this,"+id+");}catch(e){}\" ondblclick='return false;'  unselectable='off' contenteditable='false' style='cursor:pointer;text-decoration:none !important;margin-right:8px;vertical-align: middle;'>"+name+"</a>&nbsp;");	  
		}
		if(ids.length > 0)
		  relprojstr = "<div class='rswrapper'><span class='middlehelper'></span><span class='title'><%=SystemEnv.getHtmlLabelName(782,user.getLanguage())%>&nbsp;:&nbsp;</span>"+resource.join("")+"</div>";
    }
    //相关附件
	 if(selectinfos["fileids"]!==undefined && selectinfos["fileids"]!==''){
		   resource = [];
		   senddata["fileids"] = selectinfos["fileids"];
		   var fileitems = selectinfos["files"];
		   for(var i=0;i<fileitems.length;i++){
		     resource.push("<a class='relfiledes' target='_blank' href='/weaver/weaver.file.FileDownload?fileid="+fileitems[i].fileid+"' > "+fileitems[i].filename+"</a>");
		   }
		   if(fileitems.length > 0)
		     fileidstr = "<div class='rswrapper'><span class='middlehelper'></span><span class='title'><%=SystemEnv.getHtmlLabelName(22194,user.getLanguage())%>&nbsp;:&nbsp;</span>"+resource.join("")+"</div>";
	  }

    var inputitem = $("textarea[name='exmsg']"); 
	var msg = inputitem.val();
    //换行替换
	msg = msg.replace(/\n/g, '<br/>');
	//空格替换
	msg = msg.replace(/\s/g, '&nbsp;');
   //替换@
	msg = replaceMsgWithAtItems(msg);
 
    var dnow = new Date();
    var cdate = dnow.pattern("yyyy-MM-dd");
    var ctime = dnow.pattern("hh:mm");
    //默认消息发送在右边	
    var msgitem =  $("<div class='rcommentcontainer'><div class='rcommentinfo'><%=user.getUsername()%></div><div class='rcomment'><img src='../images/chatgrey_wev8.png' class='greypoint'><span  class='rimgpointerholder'></span><div class='rcommentdetail'><div class='timeinfo'><span class='cdate'>"+cdate+"</span><span>"+ctime+"</span></div>"+msg+"<div class='rsall'>"+reldocstr+relwfstr+relcuststr+relprojstr+fileidstr+"</div></div></div></div>");
   
	//内容
    senddata["content"] = msg;
	//任务实例
	senddata["requestid"] = '<%=requestid%>';
	//任务类型id
	senddata["wtid"] = '<%=wtid%>';
    //发送日期
	senddata["cdate"] = cdate;
    //发送时间
	senddata["ctime"] = ctime;

	var atids = [];
	for(var i=0;i<selectItems.length;i++){
	    atids.push(selectItems[i].id);
	}
	//@信息
    senddata["atids"] = atids.join(",");

    $.ajax({
	  type: "POST",
	  url:"/worktask/pages/taskexchange.jsp",
	  dataType:'json',
	  data:senddata,
      success:function(data){
	      if(data.success === '1'){
			  //$("#taskexchange").find("li").before(msgitem);
			  $("#taskexchange").find("li").append(msgitem);
			  $('.worktask_detailinfo').perfectScrollbar('update');
			  $(".worktask_detailinfo").scrollTop(10000);
			  //$('.worktask_detailinfo').perfectScrollbar('update');
			  inputitem.height(38);
			  inputitem.val("");
              //清空附件信息
			  selectinfos={};
			  $(".feedbackcontainer").find(".realresource").remove();
              //清空@信息
			  selectItems = [];
		  }
		  else
			  window.top.Dialog.alert('<%=SystemEnv.getHtmlLabelNames("24532,22397",user.getLanguage())%>');  
	  }
	});

});

/*
 替换@操作为超链接
*/
function  replaceMsgWithAtItems(msg){
	//记录最终有效的@选项
	var itemsnew = [];
    for(var i=0;i<selectItems.length;i++){
	   if(msg.indexOf("@"+selectItems[i].name)>=0){
	      itemsnew.push(selectItems[i]);
	   }
	   msg = msg.replace(new RegExp("@"+selectItems[i].name,'g'),"<a href='javascript:openhrm("+selectItems[i].id+")' onclick='pointerXY(event);' class='atcolor' >@"+selectItems[i].name+"</a>");
	}
    selectItems = itemsnew;
  	return msg;
}


//打开应用连接
function openAppLink(obj,linkid){

    var linkType=jQuery(obj).attr("linkType");
    if(linkType=="doc")
        window.open("/docs/docs/DocDsp.jsp?id="+linkid);
    else if(linkType=="task")
        window.open("/proj/process/ViewTask.jsp?taskrecordid="+linkid);
    else if(linkType=="crm")
        window.open("/CRM/data/ViewCustomer.jsp?CustomerID="+linkid);
    else if(linkType=="workflow")
        window.open("/workflow/request/ViewRequest.jsp?requestid="+linkid);
    else if(linkType=="project")
        window.open("/proj/data/ViewProject.jsp?ProjID="+linkid);
    else if(linkType=="workplan")
        window.open("/workplan/data/WorkPlanDetail.jsp?workid="+linkid);
    return false;
}

/*重置id*/
function resetFileids(){

   var files = $(".exchangeres .relfilecontainer"),fileidel = $(".exchangeres").find("input[name='relfileids']");
   var fileids = [],fileid;
   for(var i=0,len=files.length;i<len;i++){
        fileid = $(files[i]).find("input[type='hidden']").val();
        fileids.push(fileid);
   }
   fileidel.val(fileids.join(",")); 

}

function afterBackBrowserData(event,datas,name){
   name = name.replace("field","");
   onChangeCheckor(name);
}




//保存计划任务
function OnSave(){
    //责任人,计划内容,计划截至日期
	document.all("needcheck").value = "field3_<%=requestid%>,field7_<%=requestid%>,field13_<%=requestid%>";
	if(check_form(document.taskform, document.all("needcheck").value) && checkWorkPlanRemind()){
		document.taskform.action = "/worktask/request/RequestOperation.jsp";
		document.taskform.operationType.value="save";
		showPrompt("<%=SystemEnv.getHtmlLabelName(22060,user.getLanguage())%>");
		doUpload();
	}
}
//提交
function OnSubmit(){
	document.taskform.action = "/worktask/request/RequestOperation.jsp";
	document.taskform.operationType.value="Submit";
	showPrompt("<%=SystemEnv.getHtmlLabelName(22061,user.getLanguage())%>");
	document.taskform.submit();
}

//检测计划提醒设置
function checkWorkPlanRemind(){
	//alert(document.frmmain.remindtype);
	if(document.taskform.remindtype[0].checked == false){
		if(document.taskform.beforestart.checked || document.taskform.beforeend.checked){
			return true;
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21978,user.getLanguage())%>");
			return false;
		}
	}else{
		document.taskform.beforestart.checked = false;
		document.taskform.beforeend.checked = false;
		document.taskform.beforestarttime.value = 0;
		document.taskform.beforeendtime.value = 0;
		document.taskform.beforestartper.value = 0;
		document.taskform.beforeendper.value = 0;
		return true;
	}
}

function OnCancel(){
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(83642,user.getLanguage())%>',function(){
	    document.taskform.action = "/worktask/request/RequestOperation.jsp";
		document.taskform.operationType.value="cancel";
		document.taskform.submit();	
	});

}

function OnApprove(){
	document.taskform.action = "/worktask/request/RequestOperation.jsp";
	document.taskform.operationType.value="approve";
	document.taskform.submit();
}

function OnReject(){
	document.taskform.action = "/worktask/request/RequestOperation.jsp";
	document.taskform.operationType.value="back";
	document.taskform.submit();
}

/*提交完成反馈*/
function OnExecute(){
         
        var elements = $("input[name='taskcheck']"),checkedall=true;
        for(var i=0;i<elements.length;i++)
		{
		  if(!elements[i].checked){
		       checkedall=false;
			   break;
		  }
		}
        if(!checkedall){
            window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(83653,user.getLanguage())%>");  
		    return ;
        }
		var form = $("form[name='taskform']");
		
		var liableperson  = $("<input name='liableperson_<%=requestid%>' type='hidden' value='<%=user.getUID()%>' />") ;
        form.append(liableperson);
		var finishStatus = $("<input name='field20_<%=requestid%>' type='hidden' value='0' />") ;
		form.append(finishStatus);
		var operatorid = $("<input name='operatorid' type='hidden' value='<%=operatorid%>' />") ;
        form.append(operatorid);
		document.taskform.action = "/worktask/request/RequestOperation.jsp";
		document.taskform.operationType.value="Execute";
		showPrompt("<%=SystemEnv.getHtmlLabelName(22061,user.getLanguage())%>");
		document.taskform.submit();
}

//验证通过
function OnCheckSuccess(){
        var form = $("form[name='taskform']");
        //将根据requestid来取得的值更改为具体字段checkresult的原因:根据不同计划类型取得的字段中,现在是每个类型都可以对应不同的字段,不像之前无论在哪个类型下设置都可以全部使用
        //所以checkresult这个字段只有在-1<默认类型>的时候存在,所以现在就需要将这个字段给提取出来单独使用
		var finishStatus = $("<input name='checkresult' type='hidden' value='2' />") ;
		form.append(finishStatus);
		var operatorid = $("<input name='operatorid' type='hidden' value='<%=operatorid%>' />") ;
        form.append(operatorid);
        document.taskform.action = "/worktask/request/RequestOperation.jsp";
		document.taskform.operationType.value="Check";
		showPrompt("<%=SystemEnv.getHtmlLabelName(22061,user.getLanguage())%>");
		document.taskform.submit();
}

//验证退回
function OnCheckBack(){
        var form = $("form[name='taskform']");
        //将根据requestid来取得的值更改为具体字段checkresult的原因:根据不同计划类型取得的字段中,现在是每个类型都可以对应不同的字段,不像之前无论在哪个类型下设置都可以全部使用
        //所以checkresult这个字段只有在-1<默认类型>的时候存在,所以现在就需要将这个字段给提取出来单独使用
		var finishStatus = $("<input name='checkresult' type='hidden' value='1' />") ;
		form.append(finishStatus);
		var operatorid = $("<input name='operatorid' type='hidden' value='<%=operatorid%>' />") ;
        form.append(operatorid);
        document.taskform.action = "/worktask/request/RequestOperation.jsp";
		document.taskform.operationType.value="Check";
		showPrompt("<%=SystemEnv.getHtmlLabelName(22061,user.getLanguage())%>");
		document.taskform.submit();
}


//删除
function OnDel(){
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(82017,user.getLanguage())%>',function(){
		document.taskform.action = "/worktask/request/RequestOperation.jsp";
		document.taskform.operationType.value="delete";
		showPrompt("<%=SystemEnv.getHtmlLabelName(83632,user.getLanguage())%>");
		document.taskform.submit();
	});
}

//取消
function OnCancel(){
	window.top.Dialog.confirm('<%=SystemEnv.getHtmlLabelName(83642,user.getLanguage())%>',function(){
		document.taskform.action = "/worktask/request/RequestOperation.jsp";
		document.taskform.operationType.value="cancel";
		showPrompt("<%=SystemEnv.getHtmlLabelName(83635,user.getLanguage())%>");
		document.taskform.submit();
	});
}

function doUpload(){

	jQuery(".uploadfield").each(function(){
		var oUploader=window[jQuery(this).attr("oUploaderIndex")];
		if(oUploader.getStats().files_queued != 0){ //判断是否需要上传
	     	 oUploader.startUpload(); 
	    }
	});
	doSaveAfterAccUpload();
}

function OnRefresh(){
    window.location.reload();
}


//编辑任务
function OnEdit(){
     //0001为固定的 tasklistid，标志 编辑任务
     if(window.parent.onEditTask){
        window.parent.onEditTask("<%=requestid%>","<%=wtid%>","0001");
     }else{
        onEditTask("<%=requestid%>","<%=wtid%>","0001");
     }
     
}

//处理 任务关联子任务、编辑任务
function onEditTask(requestid, wtid ,retasklistid){
   var childedittask = $('#childedittask'); 
   
    var taskpage = "";
    taskpage = "/worktask/pages/worktask.jsp?wtid="+wtid+"&requestid="+requestid+"&tasklistid="+retasklistid;
   
   window.location = taskpage;
}

function doSaveAfterAccUpload(){
	var isuploaded=true;
	jQuery(".uploadfield").each(function(){
		var oUploader=window[jQuery(this).attr("oUploaderIndex")];
		if(oUploader.getStats().files_queued != 0){ //判断上传是否完成
	     	 isuploaded=false; 
	    }
	});
	if(isuploaded){
		document.taskform.submit();
	}
}

</script>

</body>
</html>
