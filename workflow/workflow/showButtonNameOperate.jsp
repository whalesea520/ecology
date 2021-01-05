<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.rtx.RTXConfig" %>
<%@ page import="weaver.file.Prop,weaver.general.GCONST" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<!-- 微信提醒(QC:98106) -->
<jsp:useBean id="WechatPropConfig" class="weaver.wechat.util.WechatPropConfig" scope="page"/>
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session"/>
<jsp:useBean id="multiLangFilter" class="weaver.filter.MultiLangFilter" scope="page" />
<%@ include file="/systeminfo/init_wev8.jsp" %>

<HTML><HEAD>
<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<script type='text/javascript' src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
</HEAD>
<body>
<%
int wfid = Util.getIntValue(request.getParameter("wfid"),0);
WfRightManager wfrm = new WfRightManager();
boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
if (!HrmUserVarify.checkUserRight("WorkflowManage:All", user) && !haspermission) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}

RTXConfig rtxconfig = new RTXConfig();
String temV = rtxconfig.getPorp(rtxconfig.CUR_SMS_SERVER_IS_VALID);
boolean valid = false;
if (temV != null && temV.equalsIgnoreCase("true")) {
	valid = true;
} else {
	valid = false;
}
Prop prop = Prop.getInstance();
String ifchangstatus=Util.null2String(prop.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));
String overtimeset = Util.null2String(prop.getPropValue(GCONST.getConfigFile() , "ecology.overtime"));

int design = Util.getIntValue(request.getParameter("design"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
String nodeType = "";
String isbill = "";
int formid=0;
WFManager.setWfid(wfid);
WFManager.getWfInfo();
//formid = WFManager.getFormid();
//isbill = WFManager.getIsBill();
String isFree = WFManager.getIsFree();
String submitName = Util.null2String(request.getParameter("submitName"));
String submitName7 = "";
String submitName8 = "";
String submitName9 = "";
String subnobackName7 = "";
String subnobackName8 = "";
String subnobackName9 = "";
String subbackName7 = "";
String subbackName8 = "";
String subbackName9 = "";
String forwardName = Util.null2String(request.getParameter("forwardName"));
String forwardName7 = "";
String forwardName8 = "";
String forwardName9 = "";
String saveName = Util.null2String(request.getParameter("saveName"));
String saveName7 = "";
String saveName8 = "";
String saveName9 = "";
String rejectName = Util.null2String(request.getParameter("rejectName"));
String rejectName7 = "";
String rejectName8 = "";
String rejectName9 = "";

String forhandName = Util.null2String(request.getParameter("forhandName"));
String forhandName7 = "";  //转办
String forhandName8 = "";
String forhandName9 = "";
String forhandnobackName7 = "";
String forhandnobackName8 = "";
String forhandnobackName9 = "";
String forhandbackName7 = "";
String forhandbackName8 = "";
String forhandbackName9 = "";
String hasforhandback = Util.null2String(request.getParameter("hasforhandback"));
String hasforhandnoback = Util.null2String(request.getParameter("hasforhandnoback"));
int forhandbackCtrl = Util.getIntValue(Util.null2String(request.getParameter("forhandbackCtrl")), 0);

String takingOpName = Util.null2String(request.getParameter("takingOpName"));
String takingOpName7 = "";  //意见征询
String takingOpName8 = "";
String takingOpName9 = "";



String takingOpinionsName = Util.null2String(request.getParameter("takingOpinionsName"));
String takingOpinionsName7 = "";  //
String takingOpinionsName8 = "";
String takingOpinionsName9 = "";
String takingOpinionsnobackName7 = "";  //回复
String takingOpinionsnobackName8 = "";
String takingOpinionsnobackName9 = "";
String takingOpinionsbackName7 = "";  
String takingOpinionsbackName8 = "";
String takingOpinionsbackName9 = "";
String hastakingOpinionsback = "";
String hastakingOpinionsnoback = "";
int takingOpinionsbackCtrl = Util.getIntValue(Util.null2String(request.getParameter("takingOpinionsbackCtrl")), 0);

String forsubName = Util.null2String(request.getParameter("forsubName")); //被转发人提交批注
String forsubName7 = ""; //被转发人提交批注
String forsubName8 = "";
String forsubName9 = "";
String forsubnobackName7 = "";
String forsubnobackName8 = "";
String forsubnobackName9 = "";
String forsubbackName7 = "";
String forsubbackName8 = "";
String forsubbackName9 = "";
String ccsubName = Util.null2String(request.getParameter("ccsubName"));
String ccsubName7 = "";
String ccsubName8 = "";
String ccsubName9 = "";
String ccsubnobackName7 = "";
String ccsubnobackName8 = "";
String ccsubnobackName9 = "";
String ccsubbackName7 = "";
String ccsubbackName8 = "";
String ccsubbackName9 = ""; 
String newOverTimeName = Util.null2String(request.getParameter("newOverTimeName"));
String newOverTimeName7 = "";
String newOverTimeName8 = "";
String newOverTimeName9 = "";
String hasovertime = Util.null2String(request.getParameter("hasovertime"));
String sync_overTime = Util.null2String(request.getParameter("sync_overTime"));
String sync_submit = Util.null2String(request.getParameter("sync_submit"));
String sync_submitDirect = Util.null2String(request.getParameter("sync_submitDirect"));
String sync_forward = Util.null2String(request.getParameter("sync_forward"));
String sync_save = Util.null2String(request.getParameter("sync_save"));
String sync_reject = Util.null2String(request.getParameter("sync_reject"));
String sync_forhand = Util.null2String(request.getParameter("sync_forhand"));
String sync_takingOp = Util.null2String(request.getParameter("sync_takingOp"));
String sync_forsub = Util.null2String(request.getParameter("sync_forsub"));
String sync_ccsub = Util.null2String(request.getParameter("sync_ccsub"));
String sync_takingOpinions = Util.null2String(request.getParameter("sync_takingOpinions"));
String hasnoback = "";
String hasback = "";
int subbackCtrl = Util.getIntValue(Util.null2String(request.getParameter("subbackCtrl")), 0);
String hasfornoback = "";
String hasforback = "";
int forsubbackCtrl = Util.getIntValue(Util.null2String(request.getParameter("forsubbackCtrl")), 0);
String hasccnoback = "";
String hasccback = "";
int ccsubbackCtrl = Util.getIntValue(Util.null2String(request.getParameter("ccsubbackCtrl")), 0);
int isshowinwflog = 1;
String isSubmitDirect = Util.null2String(request.getParameter("isSubmitDirect"));
String submitDirectName = Util.null2String(request.getParameter("submitDirectName"));
String submitDirectName7 = "";
String submitDirectName8 = "";
String submitDirectName9 = "";
int IsHandleForward = Util.getIntValue(request.getParameter("IsHandleForward"), 0); // 允许转办
int IsTakingOpinions = Util.getIntValue(request.getParameter("IsTakingOpinions"), 0); // 征求意见
int IsWaitForwardOpinion = Util.getIntValue(request.getParameter("IsWaitForwardOpinion"), 0); // 征求意见，被转发人提交后转发人才可提交
boolean forwardEnable = false;
int IsFreeWorkflow = Util.getIntValue(request.getParameter("IsFreeWorkflow"), 0);
String freewfsetcurname = Util.null2String(request.getParameter("freewfsetcurname"));
String freewfsetcurnamecn = "";
String freewfsetcurnameen = "";
String freewfsetcurnametw = "";
String Freefs = Util.null2String(request.getParameter("Freefs"));
int sync_freewf = Util.getIntValue(request.getParameter("sync_freewf"), 0);
boolean enableMultiLang = Util.isEnableMultiLang();

int flag = 0;

String src = Util.null2String(request.getParameter("src"));

if(src.equals("")){
	RecordSet.executeSql("select * from workflow_nodecustomrcmenu where wfid="+wfid+" and nodeid="+nodeid);
	//System.out.println("select * from workflow_nodecustomrcmenu where wfid="+wfid+" and nodeid="+nodeid);
	if(RecordSet.next()){
		submitName7 = Util.null2String(RecordSet.getString("submitName7"));
		submitName8 = Util.null2String(RecordSet.getString("submitName8"));
		submitName9 = Util.null2String(RecordSet.getString("submitName9"));
		forwardName7 = Util.null2String(RecordSet.getString("forwardName7"));
		forwardName8 = Util.null2String(RecordSet.getString("forwardName8"));
		forwardName9 = Util.null2String(RecordSet.getString("forwardName9"));
		saveName7 = Util.null2String(RecordSet.getString("saveName7"));
		saveName8 = Util.null2String(RecordSet.getString("saveName8"));
		saveName9 = Util.null2String(RecordSet.getString("saveName9"));
		rejectName7 = Util.null2String(RecordSet.getString("rejectName7"));
		rejectName8 = Util.null2String(RecordSet.getString("rejectName8"));
		rejectName9 = Util.null2String(RecordSet.getString("rejectName9"));
		forsubName7 = Util.null2String(RecordSet.getString("forsubName7"));
		forsubName8 = Util.null2String(RecordSet.getString("forsubName8"));
		forsubName9 = Util.null2String(RecordSet.getString("forsubName9"));
		forhandName7 = Util.null2String(RecordSet.getString("forhandName7"));
		forhandName8 = Util.null2String(RecordSet.getString("forhandName8"));
		forhandName9 = Util.null2String(RecordSet.getString("forhandName9"));
		takingOpName7 = Util.null2String(RecordSet.getString("takingOpName7"));  //征询意见
		takingOpName8 = Util.null2String(RecordSet.getString("takingOpName8"));
		takingOpName9 = Util.null2String(RecordSet.getString("takingOpName9"));
		takingOpinionsName7 = Util.null2String(RecordSet.getString("takingOpinionsName7")); //回复
		takingOpinionsName8 = Util.null2String(RecordSet.getString("takingOpinionsName8"));
		takingOpinionsName9 = Util.null2String(RecordSet.getString("takingOpinionsName9"));
		ccsubName7 = Util.null2String(RecordSet.getString("ccsubName7"));
		ccsubName8 = Util.null2String(RecordSet.getString("ccsubName8"));
		ccsubName9 = Util.null2String(RecordSet.getString("ccsubName9"));
		hasnoback = Util.null2String(RecordSet.getString("hasnoback"));
		hasback = Util.null2String(RecordSet.getString("hasback"));
		subbackCtrl = Util.getIntValue(Util.null2String(RecordSet.getString("subbackCtrl")), 0);
		hasforhandback = Util.null2String(RecordSet.getString("hasforhandback"));
		hasforhandnoback = Util.null2String(RecordSet.getString("hasforhandnoback"));
		forhandbackCtrl = Util.getIntValue(Util.null2String(RecordSet.getString("forhandbackCtrl")), 0);
		hastakingOpinionsback = Util.null2String(RecordSet.getString("hastakingOpinionsback"));
		hastakingOpinionsnoback = Util.null2String(RecordSet.getString("hastakingOpinionsnoback"));
		takingOpinionsbackCtrl = Util.getIntValue(Util.null2String(RecordSet.getString("takingOpinionsbackCtrl")), 0);
		hasfornoback = Util.null2String(RecordSet.getString("hasfornoback"));
		hasforback = Util.null2String(RecordSet.getString("hasforback"));
		forsubbackCtrl = Util.getIntValue(Util.null2String(RecordSet.getString("forsubbackCtrl")), 0);
		hasccnoback = Util.null2String(RecordSet.getString("hasccnoback"));
		hasccback = Util.null2String(RecordSet.getString("hasccback"));
		ccsubbackCtrl = Util.getIntValue(Util.null2String(RecordSet.getString("ccsubbackCtrl")), 0);
        newOverTimeName7 = Util.null2String(RecordSet.getString("newOverTimeName7"));
		newOverTimeName8 = Util.null2String(RecordSet.getString("newOverTimeName8"));
		newOverTimeName9 = Util.null2String(RecordSet.getString("newOverTimeName9"));
        hasovertime = Util.null2String(RecordSet.getString("hasovertime"));
        isSubmitDirect = Util.null2String(RecordSet.getString("isSubmitDirect"));
        submitDirectName7 = Util.null2String(RecordSet.getString("submitDirectName7"));
        submitDirectName8 = Util.null2String(RecordSet.getString("submitDirectName8"));
        submitDirectName9 = Util.null2String(RecordSet.getString("submitDirectName9"));
        //isshowinwflog = 1;
    	submitName = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{submitName7, submitName8, submitName9}) : submitName7;
    	forhandName = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{forhandName7, forhandName8, forhandName9}) : forhandName7;
    	forwardName = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{forwardName7, forwardName8, forwardName9}) : forwardName7;
		saveName = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{saveName7, saveName8, saveName9}) : saveName7;
		rejectName = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{rejectName7, rejectName8, rejectName9}) : rejectName7;
		takingOpName = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{takingOpName7, takingOpName8, takingOpName9}) : takingOpName7;
		newOverTimeName = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{newOverTimeName7, newOverTimeName8, newOverTimeName9}) : newOverTimeName7;
		forsubName = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{forsubName7, forsubName8, forsubName9}) : forsubName7;
		ccsubName = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{ccsubName7, ccsubName8, ccsubName9}) : ccsubName7;
		takingOpinionsName = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{takingOpinionsName7, takingOpinionsName8, takingOpinionsName9}) : takingOpinionsName7;
		submitDirectName = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{submitDirectName7, submitDirectName8, submitDirectName9}) : submitDirectName7;
	}
	rs1.executeQuery("select * from workflow_flownode where workflowid = ? and nodeid = ?", wfid, nodeid);
	if(rs1.next()){
		nodeType = Util.null2String(rs1.getString("nodeType"));
		forwardEnable = Util.null2String(rs1.getString("IsPendingForward")).equals("1") || Util.null2String(rs1.getString("IsAlreadyForward")).equals("1") || Util.null2String(rs1.getString("IsSubmitForward")).equals("1");
		IsHandleForward = Util.getIntValue(rs1.getString("IsHandleForward"), 0);
		IsTakingOpinions = Util.getIntValue(rs1.getString("IsTakingOpinions"), 0); // 征求意见
		IsWaitForwardOpinion = Util.getIntValue(rs1.getString("IsWaitForwardOpinion"), 0);
		IsFreeWorkflow = Util.getIntValue(rs1.getString("IsFreeWorkflow"), 0);
		freewfsetcurnamecn = Util.null2String(rs1.getString("freewfsetcurnamecn"));
        freewfsetcurnameen = Util.null2String(rs1.getString("freewfsetcurnameen"));
        freewfsetcurnametw = Util.null2String(rs1.getString("freewfsetcurnametw"));
        Freefs = Util.null2String(rs1.getString("Freefs"));
        freewfsetcurname = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{freewfsetcurnamecn, freewfsetcurnameen, freewfsetcurnametw}) : freewfsetcurnamecn;
	}
}else {
	submitName7 = submitName;
	submitName8 = submitName;
	submitName9 = submitName;
	forhandName7 =forhandName;
	forhandName8 = forhandName;
	forhandName9 = forhandName;
	forwardName7 = forwardName;
	forwardName8 = forwardName;
	forwardName9 = forwardName;
	saveName7 = saveName;
	saveName8 = saveName;
	saveName9 = saveName;
	rejectName7 = rejectName;
	rejectName8 = rejectName;
	rejectName9 = rejectName;
	takingOpName7 = takingOpName;
	takingOpName8 = takingOpName;
	takingOpName9 = takingOpName;
	freewfsetcurnamecn = freewfsetcurname;
	freewfsetcurnameen = freewfsetcurname;
	freewfsetcurnametw = freewfsetcurname;
	newOverTimeName7 = newOverTimeName;
	newOverTimeName8 = newOverTimeName;
	newOverTimeName9 = newOverTimeName;
	forsubName7 = forsubName;
	forsubName8 = forsubName;
	forsubName9 = forsubName;
	ccsubName7 = ccsubName;
	ccsubName8 = ccsubName;
	ccsubName9 = ccsubName;
	takingOpinionsName7 = takingOpinionsName;
	takingOpinionsName8 = takingOpinionsName;
	takingOpinionsName9 = takingOpinionsName;
	submitDirectName7 = submitDirectName;
	submitDirectName8 = submitDirectName;
	submitDirectName9 = submitDirectName;
}

if("".equals(ifchangstatus)) {
	// 提交/批准
	subbackCtrl = 0;
	hasnoback = "";
	hasback = "";
	// 转办
	forhandbackCtrl = 0;
	hasforhandnoback = "";
	hasforhandback = "";
	// 转发接收人批注
	forsubbackCtrl = 0;
	hasfornoback = "";
	hasforback = "";
	// 抄送接收人批注
	ccsubbackCtrl = 0;
	hasccnoback = "";
	hasccback = "";
	// 意见征询接收人回复
	takingOpinionsbackCtrl = 0;
	hastakingOpinionsnoback = "";
	hastakingOpinionsback = "";
}else {
	// 提交/批准
	if(1 == subbackCtrl) { // 统一不需反馈
		hasnoback = "1";
		hasback = "";
		subnobackName7 = submitName7;
		subnobackName8 = submitName8;
		subnobackName9 = submitName9;
	}else {
		if(2 == subbackCtrl) { // 操作者选择
			hasnoback = "1";
		}else {
			hasnoback = "";
		}
		hasback = "1";
		subbackName7 = submitName7;
		subbackName8 = submitName8;
		subbackName9 = submitName9;
	}
	// 转办
	if(1 == forhandbackCtrl) { // 统一不需反馈
		hasforhandnoback = "1";
		hasforhandback = "";
		forhandnobackName7 = forhandName7;
		forhandnobackName8 = forhandName8;
		forhandnobackName9 = forhandName9;
	}else {
		if(2 == forhandbackCtrl) { // 操作者选择
			hasforhandnoback = "1";
		}else {
			hasforhandnoback = "";
		}
		hasforhandback = "1";
		forhandbackName7 = forhandName7;
		forhandbackName8 = forhandName8;
		forhandbackName9 = forhandName9;
	}
	// 转发接收人批注
	if(1 == forsubbackCtrl) { // 统一不需反馈
		hasfornoback = "1";
		hasforback = "";
		forsubnobackName7 = forsubName7;
		forsubnobackName8 = forsubName8;
		forsubnobackName9 = forsubName9;
	}else {
		if(2 == forsubbackCtrl) { // 操作者选择
			hasfornoback = "1";
		}else {
			hasfornoback = "";
		}
		hasforback = "1";
		forsubbackName7 = forsubName7;
		forsubbackName8 = forsubName8;
		forsubbackName9 = forsubName9;
	}
	// 抄送接收人批注
	if(1 == ccsubbackCtrl) { // 统一不需反馈
		hasccnoback = "1";
		hasccback = "";
		ccsubnobackName7 = ccsubName7;
		ccsubnobackName8 = ccsubName8;
		ccsubnobackName9 = ccsubName9;
	}else {
		if(2 == ccsubbackCtrl) { // 操作者选择
			hasccnoback = "1";
		}else {
			hasccnoback = "";
		}
		hasccback = "1";
		ccsubbackName7 = ccsubName7;
		ccsubbackName8 = ccsubName8;
		ccsubbackName9 = ccsubName9;
	}
	// 意见征询接收人回复
	if(1 == takingOpinionsbackCtrl) { // 统一不需反馈
		hastakingOpinionsnoback = "1";
		hastakingOpinionsback = "";
		takingOpinionsnobackName7 = takingOpinionsName7;
		takingOpinionsnobackName8 = takingOpinionsName8;
		takingOpinionsnobackName9 = takingOpinionsName9;
	}else {
		if(2 == takingOpinionsbackCtrl) { // 操作者选择
			hastakingOpinionsnoback = "1";
		}else {
			hastakingOpinionsnoback = "";
		}
		hastakingOpinionsback = "1";
		takingOpinionsbackName7 = takingOpinionsName7;
		takingOpinionsbackName8 = takingOpinionsName8;
		takingOpinionsbackName9 = takingOpinionsName9;
	}
}
if("1".equals(isFree)) {
	IsFreeWorkflow = 1;
}

String isTriDiffWorkflow=null;
RecordSet.executeSql("select isTriDiffWorkflow from workflow_base where id="+wfid);
if(RecordSet.next()){
	isTriDiffWorkflow=Util.null2String(RecordSet.getString("isTriDiffWorkflow"));
}
if(!"1".equals(isTriDiffWorkflow)){
	isTriDiffWorkflow="0";
}
if("1".equals(hasnoback) || !"".equals(submitName7) || !"".equals(submitName8) || !"".equals(submitName9) // 提交/批准
	|| "1".equals(isSubmitDirect) // 提交至退回节点
	|| !"".equals(forwardName7) || !"".equals(forwardName8) || !"".equals(forwardName9) // 转发
	|| !"".equals(saveName7) || !"".equals(saveName8) || !"".equals(saveName9) // 保存
	|| !"".equals(rejectName7) || !"".equals(rejectName8) || !"".equals(rejectName9) // 退回
	|| 1 == IsHandleForward // 转办
	|| 1 == IsTakingOpinions || 1 == IsWaitForwardOpinion // 意见征询
	|| "1".equals(hasovertime) // 超时设置
	|| (1 == IsFreeWorkflow && !"1".equals(isFree)) // 流转设定
	|| "1".equals(hasfornoback) || !"".equals(forsubName7) || !"".equals(forsubName8) || !"".equals(forsubName9) // 转发接收人批注
	|| "1".equals(hasccnoback) || !"".equals(ccsubName7) || !"".equals(ccsubName8) || !"".equals(ccsubName9) // 抄送接收人批注
	|| "1".equals(hastakingOpinionsnoback) || !"".equals(takingOpinionsName7) || !"".equals(takingOpinionsName8) || !"".equals(takingOpinionsName9) // 意见征询接收人回复
) {
	flag = 1;
}
if(src.equals("save")){
   if( "1".equals(sync_takingOp)){
	   String sql = "update workflow_flownode set IsBeForwardModify= (select  IsBeForwardModify from  workflow_flownode  where nodeid=? and workflowid=?) where workflowid=" + wfid;
	   RecordSet.executeQuery(sql,nodeid,wfid);
   }
	String i_sql = "";
	RecordSet.executeSql("select * from workflow_nodecustomrcmenu where wfid=" + wfid + " and nodeid=" + nodeid);
	if(RecordSet.next()) { // update
		String sub_sql = ""; // 反馈控制为操作者选择时不更新不需反馈的按钮名称
		if(2 != subbackCtrl) { // 提交/批准
			sub_sql += " , subnobackName7='" + Util.toHtml100(subnobackName7) + "', subnobackName8='" + Util.toHtml100(subnobackName8) + "', subnobackName9='" + Util.toHtml100(subnobackName9) + "' ";
		}else {
			subnobackName7 = Util.null2String(RecordSet.getString("subnobackName7"));
			subnobackName8 = Util.null2String(RecordSet.getString("subnobackName8"));
			subnobackName9 = Util.null2String(RecordSet.getString("subnobackName9"));
		}
		if(2 != forhandbackCtrl) { //转办
			sub_sql += " , forhandnobackName7='" + Util.toHtml100(forhandnobackName7) + "', forhandnobackName8='" + Util.toHtml100(forhandnobackName8) + "', forhandnobackName9='" + Util.toHtml100(forhandnobackName9) + "' ";
		}else {
			forhandnobackName7 = Util.null2String(RecordSet.getString("forhandnobackName7"));
			forhandnobackName8 = Util.null2String(RecordSet.getString("forhandnobackName8"));
			forhandnobackName9 = Util.null2String(RecordSet.getString("forhandnobackName9"));
		}
		if(2 != forsubbackCtrl) { // 转发接收人批注
			sub_sql += " , forsubnobackName7='" + Util.toHtml100(forsubnobackName7) + "', forsubnobackName8='" + Util.toHtml100(forsubnobackName8) + "', forsubnobackName9='" + Util.toHtml100(forsubnobackName9) + "' ";
		}else {
			forsubnobackName7 = Util.null2String(RecordSet.getString("forsubnobackName7"));
			forsubnobackName8 = Util.null2String(RecordSet.getString("forsubnobackName8"));
			forsubnobackName9 = Util.null2String(RecordSet.getString("forsubnobackName9"));
		}
		if(2 != ccsubbackCtrl) { // 抄送接收人批注
			sub_sql += " , ccsubnobackName7='" + Util.toHtml100(ccsubnobackName7) + "', ccsubnobackName8='" + Util.toHtml100(ccsubnobackName8) + "', ccsubnobackName9='" + Util.toHtml100(ccsubnobackName9) + "' ";
		}else {
			ccsubnobackName7 = Util.null2String(RecordSet.getString("ccsubnobackName7"));
			ccsubnobackName8 = Util.null2String(RecordSet.getString("ccsubnobackName8"));
			ccsubnobackName9 = Util.null2String(RecordSet.getString("ccsubnobackName9"));
		}
		if(2 != takingOpinionsbackCtrl) { // 意见征询接收人回复
			sub_sql += " , takingOpinionsnobackName7='" + Util.toHtml100(takingOpinionsnobackName7) + "', takingOpinionsnobackName8='" + Util.toHtml100(takingOpinionsnobackName8) + "', takingOpinionsnobackName9='" + Util.toHtml100(takingOpinionsnobackName9) + "' ";
		}else {
			takingOpinionsnobackName7 = Util.null2String(RecordSet.getString("takingOpinionsnobackName7"));
			takingOpinionsnobackName8 = Util.null2String(RecordSet.getString("takingOpinionsnobackName8"));
			takingOpinionsnobackName9 = Util.null2String(RecordSet.getString("takingOpinionsnobackName9"));
		}
		i_sql = "update workflow_nodecustomrcmenu set "
			+ " submitName7='" + Util.toHtml100(submitName7) + "', submitName8='" + Util.toHtml100(submitName8) + "', submitName9='" + Util.toHtml100(submitName9) + "', subbackName7='" + Util.toHtml100(subbackName7) + "', subbackName8='" + Util.toHtml100(subbackName8) + "', subbackName9='" + Util.toHtml100(subbackName9) + "', hasnoback='" + hasnoback + "', hasback = '" + hasback + "', subbackCtrl=" + subbackCtrl // 提交/批准
			+ " , submitDirectName7='" + Util.toHtml100(submitDirectName7) + "', submitDirectName8='" + Util.toHtml100(submitDirectName8) + "', submitDirectName9='" + Util.toHtml100(submitDirectName9) + "', isSubmitDirect='" + isSubmitDirect + "' " // 提交至退回节点
			+ " , forwardName7='" + Util.toHtml100(forwardName7) + "', forwardName8='" + Util.toHtml100(forwardName8) + "', forwardName9='" + Util.toHtml100(forwardName9) + "' " // 转发
			+ " , saveName7='" + Util.toHtml100(saveName7) + "', saveName8='" + Util.toHtml100(saveName8) + "', saveName9='" + Util.toHtml100(saveName9) + "' " // 保存
			+ " , rejectName7='" + Util.toHtml100(rejectName7) + "', rejectName8='" + Util.toHtml100(rejectName8) + "', rejectName9='" + Util.toHtml100(rejectName9) + "' " // 退回
			+ " , forhandName7='" + Util.toHtml100(forhandName7) + "', forhandName8='" + Util.toHtml100(forhandName8) + "', forhandName9='" + Util.toHtml100(forhandName9) + "', forhandbackName7='" + Util.toHtml100(forhandbackName7) + "', forhandbackName8='" + Util.toHtml100(forhandbackName8) + "', forhandbackName9='" + Util.toHtml100(forhandbackName9) + "', hasforhandnoback='" + hasforhandnoback + "', hasforhandback='" + hasforhandback + "', forhandbackCtrl=" + forhandbackCtrl // 转办
			+ " , takingOpName7='" + Util.toHtml100(takingOpName7) + "', takingOpName8='" + Util.toHtml100(takingOpName8) + "', takingOpName9='" + Util.toHtml100(takingOpName9) + "' " // 意见征询
			+ " , newOverTimeName7='" + Util.toHtml100(newOverTimeName7) + "', newOverTimeName8='" + Util.toHtml100(newOverTimeName8) + "', newOverTimeName9='" + Util.toHtml100(newOverTimeName9) + "', hasovertime='" + hasovertime + "' " // 超时设置
			+ " , forsubName7='" + Util.toHtml100(forsubName7) + "', forsubName8='" + Util.toHtml100(forsubName8) + "', forsubName9='" + Util.toHtml100(forsubName9) + "', forsubbackName7='" + Util.toHtml100(forsubbackName7) + "', forsubbackName8='" + Util.toHtml100(forsubbackName8) + "', forsubbackName9='" + Util.toHtml100(forsubbackName9) + "', hasfornoback='" + hasfornoback + "', hasforback = '" + hasforback + "', forsubbackCtrl=" + forsubbackCtrl // 转发接收人批注
			+ " , ccsubName7='" + Util.toHtml100(ccsubName7) + "', ccsubName8='" + Util.toHtml100(ccsubName8) + "', ccsubName9='" + Util.toHtml100(ccsubName9) + "', ccsubbackName7='" + Util.toHtml100(ccsubbackName7) + "', ccsubbackName8='" + Util.toHtml100(ccsubbackName8) + "', ccsubbackName9='" + Util.toHtml100(ccsubbackName9) + "', hasccnoback='" + hasccnoback + "', hasccback = '" + hasccback + "', ccsubbackCtrl=" + ccsubbackCtrl // 抄送接收人批注
			+ " , takingOpinionsName7='" + Util.toHtml100(takingOpinionsName7) + "', takingOpinionsName8='" + Util.toHtml100(takingOpinionsName8) + "', takingOpinionsName9='" + Util.toHtml100(takingOpinionsName9) + "', takingOpinionsbackName7='" + Util.toHtml100(takingOpinionsbackName7) + "', takingOpinionsbackName8='" + Util.toHtml100(takingOpinionsbackName8) + "', takingOpinionsbackName9='" + Util.toHtml100(takingOpinionsbackName9) + "', hastakingOpinionsnoback='" + hastakingOpinionsnoback + "', hastakingOpinionsback = '" + hastakingOpinionsback + "', takingOpinionsbackCtrl=" + takingOpinionsbackCtrl // 意见征询接收人回复
			+ sub_sql
			+ " where wfid=" + wfid + " and nodeid=" + nodeid;
	}else { // insert
		i_sql = "insert into workflow_nodecustomrcmenu (wfid, nodeid "
			+ " , submitName7, submitName8, submitName9, subnobackName7, subnobackName8, subnobackName9, subbackName7, subbackName8, subbackName9, hasnoback, hasback, subbackCtrl " // 提交/批准
			+ " , submitDirectName7, submitDirectName8, submitDirectName9, isSubmitDirect " // 提交至退回节点
			+ " , forwardName7, forwardName8, forwardName9 " // 转发
			+ " , saveName7, saveName8, saveName9 " // 保存
			+ " , rejectName7, rejectName8, rejectName9 " // 退回
			+ " , forhandName7, forhandName8, forhandName9, forhandnobackName7, forhandnobackName8, forhandnobackName9, forhandbackName7, forhandbackName8, forhandbackName9, hasforhandnoback, hasforhandback, forhandbackCtrl " // 转办
			+ " , takingOpName7, takingOpName8, takingOpName9 " // 意见征询
			+ " , newOverTimeName7, newOverTimeName8, newOverTimeName9, hasovertime " // 超时设置
			+ " , forsubName7, forsubName8, forsubName9, forsubnobackName7, forsubnobackName8, forsubnobackName9, forsubbackName7, forsubbackName8, forsubbackName9, hasfornoback, hasforback, forsubbackCtrl " // 转发接收人批注
			+ " , ccsubName7, ccsubName8, ccsubName9, ccsubnobackName7, ccsubnobackName8, ccsubnobackName9, ccsubbackName7, ccsubbackName8, ccsubbackName9, hasccnoback, hasccback, ccsubbackCtrl " // 抄送接收人批注
			+ " , takingOpinionsName7, takingOpinionsName8, takingOpinionsName9, takingOpinionsnobackName7, takingOpinionsnobackName8, takingOpinionsnobackName9, takingOpinionsbackName7, takingOpinionsbackName8, takingOpinionsbackName9, hastakingOpinionsnoback, hastakingOpinionsback, takingOpinionsbackCtrl " // 意见征询接收人回复
			+ " ) values(" + wfid + ", " + nodeid
			+ " , '" + Util.toHtml100(submitName7) + "', '" + Util.toHtml100(submitName8) + "', '" + Util.toHtml100(submitName9) + "', '" + Util.toHtml100(subnobackName7) + "', '" + Util.toHtml100(subnobackName8) + "', '" + Util.toHtml100(subnobackName9) + "', '" + Util.toHtml100(subbackName7) + "', '" + Util.toHtml100(subbackName8) + "', '" + Util.toHtml100(subbackName9) + "', '" + hasnoback + "', '" + hasback + "', " + subbackCtrl // 提交/批准
			+ " , '" + Util.toHtml100(submitDirectName7) + "', '" + Util.toHtml100(submitDirectName8) + "', '" + Util.toHtml100(submitDirectName9) + "', '" + isSubmitDirect + "' " // 提交至退回节点
			+ " , '" + Util.toHtml100(forwardName7) + "', '" + Util.toHtml100(forwardName8) + "', '" + Util.toHtml100(forwardName9) + "' " // 转发
			+ " , '" + Util.toHtml100(saveName7) + "', '" + Util.toHtml100(saveName8) + "', '" + Util.toHtml100(saveName9) + "' " // 保存
			+ " , '" + Util.toHtml100(rejectName7) + "', '" + Util.toHtml100(rejectName8) + "', '" + Util.toHtml100(rejectName9) + "' " // 退回
			+ " , '" + Util.toHtml100(forhandName7) + "', '" + Util.toHtml100(forhandName8) + "', '" + Util.toHtml100(forhandName9) + "', '" + Util.toHtml100(forhandnobackName7) + "', '" + Util.toHtml100(forhandnobackName8) + "', '" + Util.toHtml100(forhandnobackName9) + "', '" + Util.toHtml100(forhandbackName7) + "', '" + Util.toHtml100(forhandbackName8) + "', '" + Util.toHtml100(forhandbackName9) + "', '" + hasforhandnoback + "', '" + hasforhandback + "', " + forhandbackCtrl // 转办
			+ " , '" + Util.toHtml100(takingOpName7) + "', '" + Util.toHtml100(takingOpName8) + "', '" + Util.toHtml100(takingOpName9) + "' " // 意见征询
			+ " , '" + Util.toHtml100(newOverTimeName7) + "', '" + Util.toHtml100(newOverTimeName8) + "', '" + Util.toHtml100(newOverTimeName9) + "', '" + hasovertime + "' " // 超时设置
			+ " , '" + Util.toHtml100(forsubName7) + "', '" + Util.toHtml100(forsubName8) + "', '" + Util.toHtml100(forsubName9) + "', '" + Util.toHtml100(forsubnobackName7) + "', '" + Util.toHtml100(forsubnobackName8) + "', '" + Util.toHtml100(forsubnobackName9) + "', '" + Util.toHtml100(forsubbackName7) + "', '" + Util.toHtml100(forsubbackName8) + "', '" + Util.toHtml100(forsubbackName9) + "', '" + hasfornoback + "', '" + hasforback + "', " + forsubbackCtrl // 转发接收人批注
			+ " , '" + Util.toHtml100(ccsubName7) + "', '" + Util.toHtml100(ccsubName8) + "', '" + Util.toHtml100(ccsubName9) + "', '" + Util.toHtml100(ccsubnobackName7) + "', '" + Util.toHtml100(ccsubnobackName8) + "', '" + Util.toHtml100(ccsubnobackName9) + "', '" + Util.toHtml100(ccsubbackName7) + "', '" + Util.toHtml100(ccsubbackName8) + "', '" + Util.toHtml100(ccsubbackName9) + "', '" + hasccnoback + "', '" + hasccback + "', " + ccsubbackCtrl // 抄送接收人批注
			+ " , '" + Util.toHtml100(takingOpinionsName7) + "', '" + Util.toHtml100(takingOpinionsName8) + "', '" + Util.toHtml100(takingOpinionsName9) + "', '" + Util.toHtml100(takingOpinionsnobackName7) + "', '" + Util.toHtml100(takingOpinionsnobackName8) + "', '" + Util.toHtml100(takingOpinionsnobackName9) + "', '" + Util.toHtml100(takingOpinionsbackName7) + "', '" + Util.toHtml100(takingOpinionsbackName8) + "', '" + Util.toHtml100(takingOpinionsbackName9) + "', '" + hastakingOpinionsnoback + "', '" + hastakingOpinionsback + "', " + takingOpinionsbackCtrl // 意见征询接收人回复
			+ " ) ";
	}
	RecordSet.executeSql(i_sql);
	String u_sql = "update workflow_flownode set "
				+ " IsHandleForward='" + IsHandleForward + "' " // 转办
				+ " , IsTakingOpinions='" + IsTakingOpinions + "', IsWaitForwardOpinion='" + IsWaitForwardOpinion + "' " // 意见征询
				+ " , IsFreeWorkflow='" + IsFreeWorkflow + "', freewfsetcurnamecn='" + Util.toHtml100(freewfsetcurnamecn) + "', freewfsetcurnameen='" + Util.toHtml100(freewfsetcurnameen) + "', freewfsetcurnametw='" + Util.toHtml100(freewfsetcurnametw) +"', Freefs='" + Freefs + "' " // 流转设定
				+ " where workflowId=" + wfid + " and nodeId=" + nodeid;
	RecordSet.executeSql(u_sql);
	
	// 新建流程/短信/微信
	int menuNum = Util.getIntValue(Util.null2String(request.getParameter("menuNum")), 0);
	String delids = Util.null2String(request.getParameter("delids")).trim();
	while(delids.startsWith(",")) {
		delids = delids.substring(1).trim();
	}
	if(!"".equals(delids)) {
		RecordSet.executeSql("delete from workflow_nodeCustomNewMenu where id in(" + delids + ") ");
	}
	for(int i = 0; i < menuNum; i++) {
		int menuType = Util.getIntValue(request.getParameter("menuType_" + i), -1);
		if(menuType < 0) {
			continue;
		}
		int id = Util.getIntValue(request.getParameter("id_" + i), 0);
		int enable = Util.getIntValue(request.getParameter("enable_" + i), 0);
		String newName = Util.null2String(request.getParameter("newName_" + i));
		String newName7 = newName;
		String newName8 = newName;
		String newName9 = newName;
		int workflowid = 0;
		if(menuType == 0) {
			workflowid = Util.getIntValue(request.getParameter("workflowid_" + i), 0);
		}
		String sync = Util.null2String(request.getParameter("sync_" + i));
		
		String sql = "";
		if(id > 0) { // update
			sql = "update workflow_nodeCustomNewMenu set enable=" + enable + ", newName7='" + Util.toHtml100(newName7) + "', newName8='" + Util.toHtml100(newName8) + "', newName9='" + Util.toHtml100(newName9) + "', workflowid=" + workflowid + " where id=" + id;
		}else { // insert
			sql = "insert into workflow_nodeCustomNewMenu(wfid, nodeid, menuType, enable, newName7, newName8, newName9, workflowid) values(" + wfid + ", " + nodeid + ", " + menuType + ", " + enable + ", '" + Util.toHtml100(newName7) + "', '" + Util.toHtml100(newName8) + "', '" + Util.toHtml100(newName9) + "', " + workflowid + ") ";
		}
		RecordSet.executeSql(sql);

		if("1".equals(sync)) { // 新建流程/短信/微信 同步到所有节点
			String customMessage = "";
			int fieldid = 0;
			String usecustomsender = "";
			if(id > 0) {
				rs1.executeSql("select * from workflow_nodeCustomNewMenu where id=" + id);
				if(rs1.next()) {
					customMessage = Util.null2String(rs1.getString("customMessage"));
					fieldid = Util.getIntValue(rs1.getString("fieldid"), 0);
					usecustomsender = Util.null2String(rs1.getString("usecustomsender"));
				}
			}
			rs1.execute("select nodeid from workflow_flownode fn where nodeid != " + nodeid + " and workflowid=" + wfid + " order by nodeid");
			while(rs1.next()) {
				int t_nodeid = Util.getIntValue(rs1.getString("nodeid"), 0);
				if(t_nodeid > 0){
					rs1.execute("insert into workflow_nodeCustomNewMenu(wfid, nodeid, menuType, enable, newName7, newName8, newName9, workflowid, customMessage, fieldid, usecustomsender) values(" + wfid + ", " + t_nodeid + ", " + menuType + ", " + enable + ", '" + Util.toHtml100(newName7) + "', '" + Util.toHtml100(newName8) + "', '" + Util.toHtml100(newName9) + "', " + workflowid + ", '" + Util.toHtml100(customMessage) + "', " + fieldid + ", '" + Util.toHtml100(usecustomsender) + "') ");
				}
			}
		}
	}
	
	// 同步到所有节点
    if("1".equals(sync_submit) // 提交/批准
    	|| "1".equals(sync_submitDirect) // 提交至退回节点
		|| "1".equals(sync_forward) // 转发
		|| "1".equals(sync_save) // 保存
		|| "1".equals(sync_reject) // 退回
		|| "1".equals(sync_forhand) // 转办
		|| "1".equals(sync_takingOp) // 意见征询
		|| "1".equals(sync_overTime) // 超时设置
		|| 1 == sync_freewf // 流转设定
		|| "1".equals(sync_forsub) // 转发接收人批注
		|| "1".equals(sync_ccsub) // 抄送接收人批注
		|| "1".equals(sync_takingOpinions) // 意见征询接收人回复
	) {
		String sync_sql = "";
		if("1".equals(sync_submit)) { // 提交/批准
			sync_sql += ", submitName7='" + Util.toHtml100(submitName7) + "', submitName8='" + Util.toHtml100(submitName8) + "', submitName9='" + Util.toHtml100(submitName9) + "', subbackName7='" + Util.toHtml100(subbackName7) + "', subbackName8='" + Util.toHtml100(subbackName8) + "', subbackName9='" + Util.toHtml100(subbackName9) + "', subnobackName7='" + Util.toHtml100(subnobackName7) + "', subnobackName8='" + Util.toHtml100(subnobackName8) + "', subnobackName9='" + Util.toHtml100(subnobackName9) + "', hasnoback='" + hasnoback + "', hasback = '" + hasback + "', subbackCtrl=" + subbackCtrl;
		}
		if("1".equals(sync_submitDirect)) { // 提交至退回节点
			sync_sql += ", submitDirectName7='" + Util.toHtml100(submitDirectName7) + "', submitDirectName8='" + Util.toHtml100(submitDirectName8) + "', submitDirectName9='" + Util.toHtml100(submitDirectName9) + "', isSubmitDirect='" + isSubmitDirect + "' ";
		}
		if("1".equals(sync_forward)) { // 转发
			sync_sql += ", forwardName7='" + Util.toHtml100(forwardName7) + "', forwardName8='" + Util.toHtml100(forwardName8) + "', forwardName9='" + Util.toHtml100(forwardName9) + "' ";
		}
		if("1".equals(sync_save)) { // 保存
			sync_sql += ", saveName7='" + Util.toHtml100(saveName7) + "', saveName8='" + Util.toHtml100(saveName8) + "', saveName9='" + Util.toHtml100(saveName9) + "' ";
		}
		if("1".equals(sync_reject)) { // 退回
			sync_sql += ", rejectName7='" + Util.toHtml100(rejectName7) + "', rejectName8='" + Util.toHtml100(rejectName8) + "', rejectName9='" + Util.toHtml100(rejectName9) + "' ";
			RecordSet.executeSql("select * from workflow_flownode where workflowid=" + wfid + " and nodeid=" + nodeid);
			if(RecordSet.next()) {
				String isrejectremind = Util.null2String(RecordSet.getString("isrejectremind"));
				String ischangrejectnode = Util.null2String(RecordSet.getString("ischangrejectnode"));
				int isselectrejectnode = Util.getIntValue(RecordSet.getString("isselectrejectnode"), 0);
				String isSubmitDirectNode = Util.null2String(RecordSet.getString("isSubmitDirectNode"));
				String rejectableNodes = Util.null2String(RecordSet.getString("rejectableNodes")).trim();
				RecordSet.executeSql("update workflow_flownode set isrejectremind='" + isrejectremind + "', ischangrejectnode='" + ischangrejectnode + "', isselectrejectnode=" + isselectrejectnode + ", rejectableNodes='" + rejectableNodes + "' where workflowid=" + wfid + " and nodeid != " + nodeid);
				RecordSet.executeSql("update workflow_flownode set isSubmitDirectNode='" + isSubmitDirectNode + "' where workflowid=" + wfid + " and nodeid not in(select id from workflow_nodebase a where a.id = workflow_flownode.nodeid and a.IsFreeNode = '1') and nodeid != " + nodeid);
			}
		}
		if("1".equals(sync_forhand)) { // 转办 
			sync_sql += ", forhandName7='" + Util.toHtml100(forhandName7) + "', forhandName8='" + Util.toHtml100(forhandName8) + "', forhandName9='" + Util.toHtml100(forhandName9) + "', forhandbackName7='" + Util.toHtml100(forhandbackName7) + "', forhandbackName8='" + Util.toHtml100(forhandbackName8) + "', forhandbackName9='" + Util.toHtml100(forhandbackName9) + "', forhandnobackName7='" + Util.toHtml100(forhandnobackName7) + "', forhandnobackName8='" + Util.toHtml100(forhandnobackName8) + "', forhandnobackName9='" + Util.toHtml100(forhandnobackName9) + "', hasforhandnoback='" + hasforhandnoback + "', hasforhandback='" + hasforhandback + "', forhandbackCtrl=" + forhandbackCtrl;
			RecordSet.executeSql("update workflow_flownode set IsHandleForward='" + IsHandleForward + "' where workflowId=" + wfid);
		}
		if("1".equals(sync_takingOp)) { // 意见征询
			sync_sql += ", takingOpName7='" + Util.toHtml100(takingOpName7) + "', takingOpName8='" + Util.toHtml100(takingOpName8) + "', takingOpName9='" + Util.toHtml100(takingOpName9) + "' ";
			RecordSet.executeSql("update workflow_flownode set IsTakingOpinions='" + IsTakingOpinions + "', IsWaitForwardOpinion='" + IsWaitForwardOpinion + "' where workflowId=" + wfid);
		}
		if("1".equals(sync_overTime)) { // 超时设置 
			sync_sql += ", newOverTimeName7='" + Util.toHtml100(newOverTimeName7) + "', newOverTimeName8='" + Util.toHtml100(newOverTimeName8) + "', newOverTimeName9='" + Util.toHtml100(newOverTimeName9) + "', hasovertime='" + hasovertime + "' ";
		}
		if(1 == sync_freewf) { // 流转设定
		    RecordSet.executeSql("update workflow_flownode set Freefs='"+Freefs+"',IsFreeWorkflow='"+IsFreeWorkflow+"',freewfsetcurnamecn='"+Util.toHtml100(freewfsetcurnamecn)+"',freewfsetcurnameen='"+Util.toHtml100(freewfsetcurnameen)+"',freewfsetcurnametw='"+Util.toHtml100(freewfsetcurnametw)+"' where EXISTS(select 1 from workflow_nodebase a where (a.nodeattribute is null or a.nodeattribute!='1') and a.id=workflow_flownode.nodeid) and (nodetype is null or nodetype!='3') and workflowId="+wfid);
		}
		if("1".equals(sync_forsub)) { // 转发接收人批注
			sync_sql += ", forsubName7='" + Util.toHtml100(forsubName7) + "', forsubName8='" + Util.toHtml100(forsubName8) + "', forsubName9='" + Util.toHtml100(forsubName9) + "', forsubbackName7='" + Util.toHtml100(forsubbackName7) + "', forsubbackName8='" + Util.toHtml100(forsubbackName8) + "', forsubbackName9='" + Util.toHtml100(forsubbackName9) + "', forsubnobackName7='" + Util.toHtml100(forsubnobackName7) + "', forsubnobackName8='" + Util.toHtml100(forsubnobackName8) + "', forsubnobackName9='" + Util.toHtml100(forsubnobackName9) + "', hasfornoback='" + hasfornoback + "', hasforback = '" + hasforback + "', forsubbackCtrl=" + forsubbackCtrl;
		}
		if("1".equals(sync_ccsub)) { // 抄送接收人批注
			sync_sql += ", ccsubName7='" + Util.toHtml100(ccsubName7) + "', ccsubName8='" + Util.toHtml100(ccsubName8) + "', ccsubName9='" + Util.toHtml100(ccsubName9) + "', ccsubbackName7='" + Util.toHtml100(ccsubbackName7) + "', ccsubbackName8='" + Util.toHtml100(ccsubbackName8) + "', ccsubbackName9='" + Util.toHtml100(ccsubbackName9) + "', ccsubnobackName7='" + Util.toHtml100(ccsubnobackName7) + "', ccsubnobackName8='" + Util.toHtml100(ccsubnobackName8) + "', ccsubnobackName9='" + Util.toHtml100(ccsubnobackName9) + "', hasccnoback='" + hasccnoback + "', hasccback = '" + hasccback + "', ccsubbackCtrl=" + ccsubbackCtrl;
		}
		if("1".equals(sync_takingOpinions)) { // 意见征询接收人回复
			sync_sql += ", takingOpinionsName7='" + Util.toHtml100(takingOpinionsName7) + "', takingOpinionsName8='" + Util.toHtml100(takingOpinionsName8) + "', takingOpinionsName9='" + Util.toHtml100(takingOpinionsName9) + "', takingOpinionsbackName7='" + Util.toHtml100(takingOpinionsbackName7) + "', takingOpinionsbackName8='" + Util.toHtml100(takingOpinionsbackName8) + "', takingOpinionsbackName9='" + Util.toHtml100(takingOpinionsbackName9) + "', takingOpinionsnobackName7='" + Util.toHtml100(takingOpinionsnobackName7) + "', takingOpinionsnobackName8='" + Util.toHtml100(takingOpinionsnobackName8) + "', takingOpinionsnobackName9='" + Util.toHtml100(takingOpinionsnobackName9) + "', hastakingOpinionsnoback='" + hastakingOpinionsnoback + "', hastakingOpinionsback = '" + hastakingOpinionsback + "', takingOpinionsbackCtrl=" + takingOpinionsbackCtrl;
		}
		if(!"".equals(sync_sql)) {
			sync_sql = sync_sql.substring(1);
			rs1.execute("select nodeid from workflow_flownode fn where nodeid not in (select nodeid from workflow_nodecustomrcmenu rm where rm.wfid="+wfid+") and workflowid="+wfid);
			while(rs1.next()){
				int t_nodeid = Util.getIntValue(rs1.getString("nodeid"), 0);
				if(t_nodeid > 0){
					RecordSet.execute("insert into workflow_nodecustomrcmenu (wfid, nodeid, subbackCtrl, forhandbackCtrl, forsubbackCtrl, ccsubbackCtrl, takingOpinionsbackCtrl) values(" + wfid + ", " + t_nodeid + ", 0, 0, 0, 0, 0)");
				}
			}
			RecordSet.execute("update workflow_nodecustomrcmenu set " + sync_sql + " where wfid=" + wfid);
		}
	}
    
    String subwfSetTableName="Workflow_SubwfSet";
	if("1".equals(isTriDiffWorkflow)){
		subwfSetTableName="Workflow_TriDiffWfDiffField";
	}

	List subwfSetIdList=new ArrayList();
	RecordSet.executeSql("select id from "+subwfSetTableName+" where mainWorkflowId="+wfid+" and triggerNodeId="+nodeid+" and triggerType='2'");
	while(RecordSet.next()){
		subwfSetIdList.add(Util.null2String(RecordSet.getString("id")));
	}

	int subwfSetId=0;
	int buttonNameId=0;
	String triSubwfName7=null;
	String triSubwfName8=null;
	String triSubwfName9=null;
	for(int i=0;i<subwfSetIdList.size();i++){
		subwfSetId=Util.getIntValue((String)subwfSetIdList.get(i),0);
		if(subwfSetId<=0){
			continue;
		}

		buttonNameId = Util.getIntValue(request.getParameter("buttonNameId_"+subwfSetId),0);
		String triSubwfName = Util.null2String(request.getParameter("triSubwfName_" + subwfSetId));
		triSubwfName7 = triSubwfName;
		triSubwfName8 = triSubwfName;
		triSubwfName9 = triSubwfName;

		if(!triSubwfName7.equals("")||!triSubwfName8.equals("")||!triSubwfName9.equals("")){
			flag=1;
		}
		
		if(buttonNameId>0){
			RecordSet.executeSql("update Workflow_TriSubwfButtonName set triSubwfName7='"+triSubwfName7+"',triSubwfName8='"+triSubwfName8+"',triSubwfName9='"+triSubwfName9+"'  where id="+buttonNameId);
		}else if(!triSubwfName7.equals("")||!triSubwfName8.equals("")||!triSubwfName9.equals("")){
			RecordSet.executeSql("insert into Workflow_TriSubwfButtonName(workflowId,nodeId,subwfSetTableName,subwfSetId,triSubwfName7,triSubwfName8,triSubwfName9) values("+wfid+","+nodeid+",'"+subwfSetTableName+"',"+subwfSetId+",'"+triSubwfName7+"','"+triSubwfName8+"','"+triSubwfName9+"')");
		}
	}
	
	RecordSet.executeSql("update workflow_nodecustomrcmenu set isshowinwflog="+isshowinwflog+" where wfid="+wfid);
}

	int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
    int subCompanyId= -1;
    int operatelevel=0;
    if(detachable==1){
        if(request.getParameter("subCompanyId")==null){
            subCompanyId=Util.getIntValue(String.valueOf(session.getAttribute("managefield_subCompanyId")),-1);
        }else{
            subCompanyId=Util.getIntValue(request.getParameter("subCompanyId"),-1);
        }
        if(subCompanyId == -1){
            subCompanyId = user.getUserSubCompany1();
        }
        session.setAttribute("managefield_subCompanyId",String.valueOf(subCompanyId));
        operatelevel= CheckSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(),"WorkFlowTitleSet:All",subCompanyId);
    }else{
        if(HrmUserVarify.checkUserRight("WorkFlowTitleSet:All", user))
            operatelevel=2;
    }

    int rowsum = 0;
    
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(21737,user.getLanguage()) ;
    String needfav = "";
    String needhelp = "";
%>

<%
if(design==0) {
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%
}
%>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSave(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:closeWindow(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<div class="zDialog_div_content">
<style type="text/css">
.InputStyle {
	width: 95% !important;
}
#addRowPanel{
	width: auto;
	height: auto;
	padding-top: 5px;
	padding-bottom: 5px;
	border: 1px solid #DADADA;
	position: absolute;
	z-index: 5;
	cursor: pointer;
	background-color: #F9F9F9;
	display: none;
}
#addRowPanel li{
	list-style: none;
	height: 25px;
	line-height : 25px;
	text-align: center;
	color: #2F2F2F;
	padding-left: 10px;
	padding-right: 10px;
}
#addRowPanel li:hover{
	background-color: #4E82BE;
	color: white;
}
</style>
<div id="addRowPanel">
	<li onclick="addRow(0)"><%=SystemEnv.getHtmlLabelName(16392, user.getLanguage()) %></li>
	<li onclick="addRow(1)"><%=SystemEnv.getHtmlLabelName(16444, user.getLanguage()) %></li>
	<% if(WechatPropConfig.isUseWechat()) { %>
		<li onclick="addRow(2)"><%=SystemEnv.getHtmlLabelName(32818, user.getLanguage()) %></li>
	<% } %>
</div>
<FORM NAME=SearchForm id=SearchForm STYLE="margin-bottom:0" action="showButtonNameOperate.jsp" method="post">
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="" name="src">
<input type="hidden" value="<%=nodeid%>" name="nodeid">
<input type="hidden" value="<%=design%>" name="design">
<input type="hidden" id="isshowinwflog" name="isshowinwflog" value="1" />
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top"  onclick="javascript:onSave();"/>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 

<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(126318,user.getLanguage()) %>'>
		<wea:item type="groupHead">
 		  	<button class=addbtn type=button onclick="togglePanel(event, this)"></button>
		  	<button class=delbtn type=button onclick="delRow(event)"></button>
		</wea:item>
		<wea:item attributes="{'isTableList':'true'}">
		    <TABLE class=ListStyle cellspacing=0 id="buttonNameTable">
			    <COLGROUP>
					<COL width="5%">
					<COL width="15%">
					<COL width="10%">
					<COL width="15%">
					<% if(!"".equals(ifchangstatus)){ %>
					<COL width="15%">
					<% } %>
					<COL width="25%">
					<COL width="15%">
				</COLGROUP>
			    <TR class="header">
					<TD>
						<input type="checkbox" name="check_menuAll" onclick="changeCheck(this, 'check_menu')" />
					</TD>
			        <TD><%=SystemEnv.getHtmlLabelName(21560,user.getLanguage())%></TD>
			        <TD>
			        	<input type="checkbox" name="enable_all" onclick="changeCheck(this, 'enable_')" /><%=SystemEnv.getHtmlLabelName(18095, user.getLanguage()) %>
			        </TD>
				    <TD><%=SystemEnv.getHtmlLabelName(17607, user.getLanguage()) %></TD>
					<% if(!"".equals(ifchangstatus)){ %>
					<TD><%=SystemEnv.getHtmlLabelName(126321, user.getLanguage()) %></TD>
					<% } %>
					<TD><%=SystemEnv.getHtmlLabelName(32383, user.getLanguage()) %></TD>
					<TD>
						<input type="checkbox" name="sync_all" onclick="changeCheck(this, 'sync_')" /><%=SystemEnv.getHtmlLabelName(21738, user.getLanguage()) %>
					</TD>
			    </TR>    
			    <TR>
			    	<TD></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(615,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(142,user.getLanguage())%></TD>
				    <TD><input type="checkbox" checked disabled ></TD>
				    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="submitName" value="<%=submitName %>"></TD>
					<% if(!"".equals(ifchangstatus)){ %>
						<TD>
							<select name="subbackCtrl" style="width: 60%;" onchange="changeBackCtrl('subbackCtrlButton', this)">
								<option value="0" <% if(0 == subbackCtrl) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(21761, user.getLanguage()) %></option>
								<option value="1" <% if(1 == subbackCtrl) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(21762, user.getLanguage()) %></option>
								<option value="2" <% if(2 == subbackCtrl) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(126324, user.getLanguage()) %></option>
							</select>
							<button type="button" class=Browser1 id="subbackCtrlButton" onclick="onShowBackButtonNameBrowser('sub')" style="vertical-align: middle;<% if(2 != subbackCtrl) { %>display: none;<% } %>"></button>
						</TD>
					<% } %>
					<TD></TD>
					<TD>
						<input type="checkbox" name="sync_submit" id="sync_submit" value="1" />
					</TD>
			    </TR>
				<tr class='Spacing' style="height:1px!important;"><td colspan=7 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
				<TR>
			    	<TD></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(126507, user.getLanguage()) %></TD>
				    <TD>
				    	<input type="checkbox" name="isSubmitDirect" id="enable_isSubmitDirect" value="1" <% if("1".equals(isSubmitDirect)) { %> checked="checked" <% } %> />
				    	<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(126514, user.getLanguage()) %>">
							<img src="/images/tooltip_wev8.png" align="absMiddle" />
						</span>
				    </TD>
				    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="submitDirectName" value="<%=submitDirectName %>"></TD>
					<% if(!"".equals(ifchangstatus)){ %>
						<TD></TD>
					<% } %>
					<TD></TD>
					<TD>
						<input type="checkbox" name="sync_submitDirect" id="sync_submitDirect" value="1" />
					</TD>
			    </TR>
				<tr class='Spacing' style="height:1px!important;"><td colspan=7 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
			    <TR>
			    	<TD></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(6011,user.getLanguage())%></TD>
				    <TD><input type="checkbox" <%=forwardEnable?"checked":""%> disabled ></TD>
				    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="forwardName" value="<%=forwardName %>"></TD>
					<% if(!"".equals(ifchangstatus)){ %>
					<TD></TD>
					<% } %>
					<TD>
						<a href="javascript:onForward()"><%=SystemEnv.getHtmlLabelName(33484, user.getLanguage()) %></a>
					</TD>
					<TD>
						 <input type="checkbox"   name="sync_forward" id="sync_forward" value="1" />
					</TD>
			    </TR>
			    <tr class='Spacing' style="height:1px!important;"><td colspan=7 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
			    <TR>
			    	<TD></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%></TD>
				    <TD><input type="checkbox" checked disabled ></TD>
				    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="saveName" value="<%=saveName %>"></TD>
					<% if(!"".equals(ifchangstatus)){ %>
					<TD></TD>
					<% } %>
					<TD></TD>
					<TD>
						<input type="checkbox" name="sync_save" id="sync_save" value="1" />
					</TD>
			    </TR>
			    <tr class='Spacing' style="height:1px!important;"><td colspan=7 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr> 
			    <TR>
			    	<TD></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(236,user.getLanguage())%></TD>
				    <TD><input type="checkbox" checked disabled ></TD>
				    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="rejectName" value="<%=rejectName %>"></TD>
					<% if(!"".equals(ifchangstatus)){ %>
					<TD></TD>
					<% } %>
					<TD>
						<a href="javascript:onReject()"><%=SystemEnv.getHtmlLabelName(84508, user.getLanguage()) %></a>
					</TD>
					<TD>
						<input type="checkbox" name="sync_reject" id="sync_reject" value="1" />
					</TD>
			    </TR>
			    <tr class='Spacing' style="height:1px!important;"><td colspan=7 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr> 
<!--=================================================================转办=======================================================================================-->
				<TR>
					<TD></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(23745,user.getLanguage())%></TD>
				    <TD>
				    	<input type="checkbox" name="IsHandleForward" id="enable_IsHandleForward" value="1" <% if(IsHandleForward == 1) { %> checked="checked" <% } %> />
				    </TD>
				    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="forhandName" value="<%=forhandName %>"></TD>
					<% if(!"".equals(ifchangstatus)){ %>
						<TD>
							<select name="forhandbackCtrl" style="width: 60%;" onchange="changeBackCtrl('forhandbackCtrlButton', this)">
								<option value="0" <% if(0 == forhandbackCtrl) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(21761, user.getLanguage()) %></option>
								<option value="1" <% if(1 == forhandbackCtrl) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(21762, user.getLanguage()) %></option>
								<option value="2" <% if(2 == forhandbackCtrl) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(126324, user.getLanguage()) %></option>
							</select>
							<button type="button" class=Browser1 id="forhandbackCtrlButton" onclick="onShowBackButtonNameBrowser('forhand')" style="vertical-align: middle;<% if(2 != forhandbackCtrl) { %>display: none;<% } %>"></button>
						</TD>
					<% } %>
					<TD></TD>
					<TD>
						<input type="checkbox" name="sync_forhand" id="sync_forhand" value="1" />
					</TD>
			    </TR>
				<tr class='Spacing' style="height:1px!important;"><td colspan=7 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
<!--===========================================================征询意见================================================================================-->
			<TR>
					<TD></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(82578,user.getLanguage())%></TD>
				    <TD>
				    	<input type="checkbox" name="IsTakingOpinions" id="enable_IsTakingOpinions" value="1" <% if(IsTakingOpinions == 1 || IsWaitForwardOpinion == 1) { %> checked="checked" <% } %> onclick="checkClick(this)" />
				    	<INPUT type="hidden" id="IsWaitForwardOpinion" name="IsWaitForwardOpinion" value="<%=(IsTakingOpinions == 1) ? "1" : "" %>" />
				    </TD>
				    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="takingOpName" value="<%=takingOpName %>"></TD>
					<% if(!"".equals(ifchangstatus)){ %>
					<TD></TD>
					<% } %>
					<TD>
						<a href="javascript:onTakingOp()"><%=SystemEnv.getHtmlLabelName(126632, user.getLanguage()) %></a>
					</TD>
					<TD>
						<input type="checkbox" name="sync_takingOp" id="sync_takingOp" value="1" />
					</TD>
			    </TR>
			    <tr class='Spacing' style="height:1px!important;"><td colspan=7 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr> 
			<% if(!"".equals(overtimeset)) { %>
				<TR>
					<TD></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(18818, user.getLanguage()) %></TD>
				    <TD>
				    	<input type="checkbox" name="hasovertime" id="enable_hasovertime" value="1" <% if("1".equals(hasovertime)) { %> checked="checked" <% } %> />
				    	<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(126393, user.getLanguage()) %>">
							<img src="/images/tooltip_wev8.png" align="absMiddle" />
						</span>
				    </TD>
				    <TD class=Field>
				    	<INPUT class=InputStyle maxLength=10 size=14 name="newOverTimeName" value="<%=newOverTimeName %>">
				    </TD>
					<% if(!"".equals(ifchangstatus)){ %>
					<TD></TD>
					<% } %>
					<TD></TD>
					<TD>
						<input type="checkbox" name="sync_overTime" id="sync_overTime" value="1" />
					</TD>
			    </TR>
			    <tr class='Spacing' style="height:1px!important;"><td colspan=7 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
			<% } %>
		    <% if(!"3".equals(nodeType) && GCONST.getFreeFlow() && new weaver.workflow.request.WFLinkInfo().getNodeAttribute(nodeid) != 1) { %>
			    <TR>
					<TD></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(21781, user.getLanguage()) %></TD>
				    <TD>
				    	<input type="checkbox" name="IsFreeWorkflow" id="enable_IsFreeWorkflow" value="1" <% if("1".equals(isFree)) { %> checked="checked" disabled="disabled" <% }else if(IsFreeWorkflow == 1) { %> checked="checked" <% } %> />
				    	<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(126389, user.getLanguage()) %>">
							<img src="/images/tooltip_wev8.png" align="absMiddle" />
						</span>
				    </TD>
				    <TD class=Field>
				    	<INPUT class=InputStyle maxLength=10 size=14 name="freewfsetcurname" value="<%=freewfsetcurname %>">
				    </TD>
					<% if(!"".equals(ifchangstatus)){ %>
					<TD></TD>
					<% } %>
					<TD>
						<%=SystemEnv.getHtmlLabelName(82298, user.getLanguage()) %>：
						<select name="Freefs" id="Freefs">
							<option value=""><%=SystemEnv.getHtmlLabelName(15083,user.getLanguage())%></option>
							<option value="1" <%if(Freefs.equals("1")) {%>selected <%} %>><%=SystemEnv.getHtmlLabelName(82299,user.getLanguage())%></option>
							<option value="2" <%if(Freefs.equals("2")) {%>selected <%} %>><%=SystemEnv.getHtmlLabelName(82300,user.getLanguage())%></option>
						</select>
					</TD>
					<TD>
						<input type="checkbox" name="sync_freewf" id="sync_freewf" value="1" <% if("1".equals(isFree)) { %> disabled="disabled" <% } %> />
					</TD>
			    </TR>
			    <tr class='Spacing' style="height:1px!important;"><td colspan=7 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
		    <% } %>
<!--==============================================================触发子流程===============================================================================-->
			<%
                StringBuffer sb=new StringBuffer();
				if("1".equals(isTriDiffWorkflow)){
					sb.append("  select  ab.id as subwfSetId,c.id as buttonNameId,c.triSubwfName7,c.triSubwfName8,c.triSubwfName9 from ")
					  .append(" ( ")
					  .append("  select a.triggerType,b.nodeType,b.nodeId,a.triggerTime,a.fieldId ,a.id ")
					  .append("    from Workflow_TriDiffWfDiffField a,workflow_flownode b ")
					  .append("   where a.triggerNodeId=b.nodeId ")
					  .append("     and a.mainWorkflowId=b.workflowId ")
					  .append("     and a.mainWorkflowId=").append(wfid)
					  .append("     and a.triggerNodeId=").append(nodeid)
					  .append("     and a.triggerType='2' ")
					  .append(" )ab left join  ")
					  .append(" ( ")
					  .append("   select *  ")
					  .append("     from Workflow_TriSubwfButtonName ")
					  .append("    where workflowId=").append(wfid)
					  .append("      and nodeId=").append(nodeid)
					  .append("      and subwfSetTableName='Workflow_TriDiffWfDiffField' ")
					  .append(" )c on ab.id=c.subwfSetId ")
					  .append(" order by ab.triggerType asc,ab.nodeType asc,ab.nodeId asc,ab.triggerTime asc,ab.fieldId asc ,ab.id asc ")
					  ;
				}else{
					sb.append("  select  ab.id as subwfSetId,c.id as buttonNameId,c.triSubwfName7,c.triSubwfName8,c.triSubwfName9 from ")
					  .append(" ( ")
					  .append("  select a.triggerType,b.nodeType,b.nodeId,a.triggerTime,a.subWorkflowId ,a.id ")
					  .append("    from Workflow_SubwfSet a,workflow_flownode b ")
					  .append("   where a.triggerNodeId=b.nodeId ")
					  .append("     and a.mainWorkflowId=b.workflowId ")
					  .append("     and a.mainWorkflowId=").append(wfid)
					  .append("     and a.triggerNodeId=").append(nodeid)
					  .append("     and a.triggerType='2' ")
					  .append(" )ab left join  ")
					  .append(" ( ")
					  .append("   select *  ")
					  .append("     from Workflow_TriSubwfButtonName ")
					  .append("    where workflowId=").append(wfid)
					  .append("      and nodeId=").append(nodeid)
					  .append("      and subwfSetTableName='Workflow_SubwfSet' ")
					  .append(" )c on ab.id=c.subwfSetId ")
					  .append(" order by ab.triggerType asc,ab.nodeType asc,ab.nodeId asc,ab.triggerTime asc,ab.subWorkflowId asc,ab.id asc ")
					  ;
				}
				int subwfSetId=0;
				int buttonNameId=0;
				String triSubwfName7=null;
				String triSubwfName8=null;
				String triSubwfName9=null;
				String trClass="datalight";
				int indexId=0;
				RecordSet.executeSql(sb.toString());
				while(RecordSet.next()){
					subwfSetId=Util.getIntValue(RecordSet.getString("subwfSetId"),0);
					buttonNameId=Util.getIntValue(RecordSet.getString("buttonNameId"),0);
					triSubwfName7=Util.null2String(RecordSet.getString("triSubwfName7"));
					triSubwfName8=Util.null2String(RecordSet.getString("triSubwfName8"));
					triSubwfName9=Util.null2String(RecordSet.getString("triSubwfName9"));
					String triSubwfName = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{triSubwfName7, triSubwfName8, triSubwfName9}) : triSubwfName7;

					indexId++;
			%>
				<TR class="<%=trClass%>">
					<TD><input name="buttonNameId_<%=subwfSetId%>" type=hidden value="<%=buttonNameId%>"></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(22064,user.getLanguage())+indexId%></TD>
				    <TD><input type="checkbox" checked disabled ></TD>
				    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="triSubwfName_<%=subwfSetId%>" value="<%=triSubwfName %>"></TD>
					<% if(!"".equals(ifchangstatus)){ %>
						<TD></TD>
					<% } %>
					<TD></TD>
					<TD></TD>
			    </TR>
			    <tr class='Spacing' style="height:1px!important;"><td colspan=7 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr> 
			<%
				}
			%>
		    <%
		    	RecordSet.executeSql("select * from workflow_nodeCustomNewMenu where wfid=" + wfid + " and nodeid=" + nodeid + " order by id");
		    	while(RecordSet.next()) {
		    		int menuType = Util.getIntValue(RecordSet.getString("menuType"), -1);
		    		if(menuType < 0 || (2 == menuType && !WechatPropConfig.isUseWechat())) {
		    			continue;
		    		}
		    		int id = Util.getIntValue(RecordSet.getString("id"), 0);
		    		int enable = Util.getIntValue(RecordSet.getString("enable"), 0);
		    		String newName7 = Util.null2String(RecordSet.getString("newName7"));
		    		String newName8 = Util.null2String(RecordSet.getString("newName8"));
		    		String newName9 = Util.null2String(RecordSet.getString("newName9"));
		    		String newName = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{newName7, newName8, newName9}) : newName7;
			%>
					<TR>
						<TD>
							<input type="checkbox" name="check_menu" id="check_menu_<%=rowsum %>" value="<%=id %>" />
						</TD>
					    <TD>
							<% if(0 == menuType) { // 新建流程 %>
								<%=SystemEnv.getHtmlLabelName(16392, user.getLanguage()) %>
							<% }else if(1 == menuType) { // 新建短信 %>
								<%=SystemEnv.getHtmlLabelName(16444, user.getLanguage()) %>
							<% }else if(2 == menuType) { // 新建微信 %>
								<%=SystemEnv.getHtmlLabelName(32818, user.getLanguage()) %>
							<% } %>
							<input type="hidden" name="id_<%=rowsum %>" value="<%=id %>" />
							<input type="hidden" name="menuType_<%=rowsum %>" value="<%=menuType %>" />
					    </TD>
					    <TD>
					    	<input type="checkbox" name="enable_<%=rowsum %>" id="enable_<%=rowsum %>" value="1" <% if(1 == enable) { %> checked="checked" <% } %> />
					    </TD>
					    <TD class=Field>
					    	<INPUT class=InputStyle maxLength=10 size=14 name="newName_<%=rowsum %>" value="<%=newName %>">
					    </TD>
						<% if(!"".equals(ifchangstatus)){ %>
						<TD></TD>
						<% } %>
						<TD>
							<%
								if(0 == menuType) { // 新建流程
									int workflowid = Util.getIntValue(RecordSet.getString("workflowid"), 0);
							%>
								<span style="float: left"><%=SystemEnv.getHtmlLabelName(34067, user.getLanguage()) %>：&nbsp;</span>
								<brow:browser name='<%="workflowid_"+rowsum %>' viewType="0" hasBrowser="true" hasAdd="false"
									browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp" isMustInput="2" isSingle="true" hasInput="true"
									completeUrl="/data.jsp?type=workflowBrowser" width="150px" browserValue="<%=Util.null2String(workflowid) %>" browserSpanValue="<%=WorkflowComInfo.getWorkflowname(Util.null2String(workflowid)) %>" />
							<% }else { %>
								<a href="javascript:onShowDetail(<%=id %>, <%=menuType %>, <%=rowsum %>)"><%=SystemEnv.getHtmlLabelName(19342, user.getLanguage()) %></a>
							<% } %>
						</TD>
						<TD>
							<input type="checkbox" name="sync_<%=rowsum %>" id="sync_<%=rowsum %>" value="1">
						</TD>
				    </TR>
				    <tr class='Spacing' style="height:1px!important;"><td colspan=7 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
   			<%
   					rowsum++;
   				}
		    	if(rowsum > 0) {
		    		flag = 1;
		    	}
   			%>
		</TABLE>
		<input type="hidden" name="menuNum" id="menuNum" value="<%=rowsum %>" />
		<input type="hidden" name="delids" id="delids" value="" />
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(126319,user.getLanguage()) %>'>
		<wea:item attributes="{'isTableList':'true'}">
		    <TABLE class=ListStyle cellspacing=0>
			    <COLGROUP>
					<COL width="25%">
					<COL width="15%">
					<COL width="20%">
					<% if(!"".equals(ifchangstatus)){ %>
					<COL width="20%">
					<% } %>
					<COL width="20%">
				</COLGROUP>
			    <TR class="header">
					<TD><%=SystemEnv.getHtmlLabelName(126451, user.getLanguage()) %></TD>
			        <TD><%=SystemEnv.getHtmlLabelName(126452, user.getLanguage()) %></TD>
					<TD><%=SystemEnv.getHtmlLabelName(17607, user.getLanguage()) %></TD>
					<% if(!"".equals(ifchangstatus)){ %>
					<TD><%=SystemEnv.getHtmlLabelName(126321, user.getLanguage()) %></TD>
					<% } %>
					<TD>
						<input type="checkbox" name="sync_other_all" onclick="changeCheck(this, 'syncOther_')" /><%=SystemEnv.getHtmlLabelName(21738, user.getLanguage()) %>
					</TD>
			    </TR>  
<!--==========================================================转发接收人批注================================================================================-->
				<TR>
					<TD><%=SystemEnv.getHtmlLabelName(24965, user.getLanguage()) %></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(1006,user.getLanguage())%></TD>
				    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="forsubName" value="<%=forsubName %>"></TD>
					<% if(!"".equals(ifchangstatus)){ %>
						<TD>
							<select name="forsubbackCtrl" onchange="changeBackCtrl('forsubbackCtrlButton', this)">
								<option value="0" <% if(0 == forsubbackCtrl) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(21761, user.getLanguage()) %></option>
								<option value="1" <% if(1 == forsubbackCtrl) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(21762, user.getLanguage()) %></option>
								<option value="2" <% if(2 == forsubbackCtrl) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(126324, user.getLanguage()) %></option>
							</select>
							<button type="button" class=Browser1 id="forsubbackCtrlButton" onclick="onShowBackButtonNameBrowser('forsub')" style="vertical-align: middle;<% if(2 != forsubbackCtrl) { %>display: none;<% } %>"></button>
						</TD>
					<% } %>
					<TD>
						<input type="checkbox" name="sync_forsub" id="syncOther_forsub" value="1" />
					</TD>
			    </TR>
				<tr class='Spacing' style="height:1px!important;"><td colspan=5 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
<!--==============================================抄送====================================================================================================-->
				<TR>
					<TD><%=SystemEnv.getHtmlLabelName(126453, user.getLanguage()) %></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(1006,user.getLanguage())%></TD>
				    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="ccsubName" value="<%=ccsubName %>"></TD>
					<% if(!"".equals(ifchangstatus)){ %>
						<TD>
							<select name="ccsubbackCtrl" onchange="changeBackCtrl('ccsubbackCtrlButton', this)">
								<option value="0" <% if(0 == ccsubbackCtrl) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(21761, user.getLanguage()) %></option>
								<option value="1" <% if(1 == ccsubbackCtrl) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(21762, user.getLanguage()) %></option>
								<option value="2" <% if(2 == ccsubbackCtrl) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(126324, user.getLanguage()) %></option>
							</select>
							<button type="button" class=Browser1 id="ccsubbackCtrlButton" onclick="onShowBackButtonNameBrowser('ccsub')" style="vertical-align: middle;<% if(2 != ccsubbackCtrl) { %>display: none;<% } %>"></button>
						</TD>
					<% } %>
					<TD>
						<input type="checkbox" name="sync_ccsub" id="syncOther_ccsub" value="1" />
					</TD>
			    </TR>
				<tr class='Spacing' style="height:1px!important;"><td colspan=5 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
<!--==========================================================征询意见回复================================================================================-->
				<TR>
					<TD><%=SystemEnv.getHtmlLabelName(126454, user.getLanguage()) %></TD>
				    <TD><%=SystemEnv.getHtmlLabelName(117,user.getLanguage())%></TD>
				    <TD class=Field><INPUT class=InputStyle maxLength=10 size=14 name="takingOpinionsName" value="<%=takingOpinionsName %>"></TD>
					<% if(!"".equals(ifchangstatus)){ %>
						<TD>
							<select name="takingOpinionsbackCtrl" onchange="changeBackCtrl('takingOpinionsbackCtrlButton', this)">
								<option value="0" <% if(0 == takingOpinionsbackCtrl) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(21761, user.getLanguage()) %></option>
								<option value="1" <% if(1 == takingOpinionsbackCtrl) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(21762, user.getLanguage()) %></option>
								<option value="2" <% if(2 == takingOpinionsbackCtrl) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(126324, user.getLanguage()) %></option>
							</select>
							<button type="button" class=Browser1 id="takingOpinionsbackCtrlButton" onclick="onShowBackButtonNameBrowser('takingOpinions')" style="vertical-align: middle;<% if(2 != takingOpinionsbackCtrl) { %>display: none;<% } %>"></button>
						</TD>
					<% } %>
					<TD>
						<input type="checkbox" name="sync_takingOpinions" id="syncOther_takingOpinions" value="1" />
					</TD>
			    </TR>
				<tr class='Spacing' style="height:1px!important;"><td colspan=5 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
			</TABLE>		
		</wea:item>
	</wea:group>
</wea:layout>
</form>
</div>
<script language=javascript>
	var dialog = parent.parent.getDialog(parent);
	var parentWin = parent.parent.getParentWindow(parent);
	$(document).ready(function(){
  		resizeDialog(document);
  		jQuery(document).bind("click.autoHide", function(e) {
			jQuery("#addRowPanel").hide();
		});
  		jQuery("span[class='e8tips']").wTooltip({
  	  		html : true
  	  	});
	});
</script>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeWindow();">
	    </wea:item>
		</wea:group>
	</wea:layout>
</div>	
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</body>
</html>

<script language=javascript>
jQuery(document).ready(function(){
	jQuery(".liststyle").find("tr[class=Spacing]:last").find("td").removeClass("paddingLeft18").addClass("paddingLeft0");
});

function onSave(){
	enableAllmenu();
	if(checkWFid()){
		checkClick(document.getElementById("enable_IsTakingOpinions"));
		jQuery("[name='src']").val("save");
		if(jQuery("#sync_forward").attr("checked")){
		    //如果勾选了转发同步按钮 需同步功能管理里的设置
            jQuery.get('showNodeAttrOperate.jsp',
                {src:"save",wfid:<%=wfid%>,nodeid:<%=nodeid%>,design:0,setType:'forward',saveType:1});
		}
		document.SearchForm.submit();
	}else{
		displayAllmenu();
	}
}
function onChangeBackName(obj){
	var td_checkbox = obj.parentElement.parentElement.children(0).children(0);
	td_checkbox.checked = true;
}
function checkWFid(){
	var returnValue = true;
	jQuery("input[name^='workflowid_'][type='hidden']").each(function() {
		var workflowid_ = jQuery(this).val();
		if(workflowid_ == null || workflowid_ == "" || workflowid_ == "0") {
			returnValue = false;
		}
	});
	if(!returnValue) {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage())%>");
	}
	return returnValue;
}

<%if(src.equals("save")){	%>
		closeWindow();
<%}	%>

function closeWindow(){
	var design="<%=design %>";
	if(design=='1'){		//工作流图形化打开
		//window.parent.parent.design_callback('showButtonNameOperate','<%=flag==1?true:false %>');
		parentWin.design_callback('showButtonNameOperate','<%=flag==1?true:false %>');
	}else{
		parentWin.setSpanInner('<%=nodeid %>','<%=flag %>','buttonName');
	}
	dialog.close();
}

function onShowWorkFlow(inputname, spanname){
	retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp");
	if (retValue!=null){
		if (retValue.id!= ""){
			$G(spanname).innerHTML = retValue.name;
			$G(inputname).value = retValue.id;
		}else{ 
			$G(inputname).value = "";
			$G(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		}
	}
	if($G(inputname).value == null || $G(inputname).value == "" || $G(inputname).value == "0"){
		$G(spanname).innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
	}
}

function changeBackCtrl(buttonId, obj) {
	if(obj.value == 2) {
		jQuery("#" + buttonId).show();
	}else {
		jQuery("#" + buttonId).hide();
	}
}
function onShowBackButtonNameBrowser(type) {
	var buttonName = "";
	if("sub" == type) {
		buttonName = "submitName";
	}else if("forhand" == type) {
		buttonName = "forhandName";
	}else if("forsub" == type) {
		buttonName = "forsubName";
	}else if("ccsub" == type) {
		buttonName = "ccsubName";
	}else if("takingOpinions" == type) {
		buttonName = "takingOpinionsName";
	}
	if("" != buttonName) {
		var backName = "";
		var obj_multilang = jQuery("input[name=__multilangpre_" + buttonName + "]");
		if(obj_multilang.length > 0) {
			backName = obj_multilang.val();
		}
		var backName7 = jQuery("input[name=" + buttonName + "]").val();

		var backDialog = new window.top.Dialog();
		backDialog.currentWindow = window;
		var url = "/workflow/workflow/showButtonNameBack.jsp?wfid=<%=wfid %>&nodeid=<%=nodeid %>&type=" + type + "&backName7=" + encodeURIComponent(backName7) + "&backName=" + encodeURIComponent(backName);
		backDialog.Title = "<%=SystemEnv.getHtmlLabelName(126331, user.getLanguage()) %>";
		backDialog.Width = 600;
		backDialog.Height = 370;
		backDialog.Drag = true;
		backDialog.maxiumnable = false;
		backDialog.URL = url;
		backDialog.show();
	}
}
function onShowBackButtonNameBrowserCallback() {
	location.reload();
}
function onForward() {
	var forwardDialog = new window.top.Dialog();
	forwardDialog.currentWindow = window;
	var url = "/workflow/workflow/showNodeAttrOperate.jsp?setType=forward&wfid=<%=wfid %>&nodeid=<%=nodeid %>";
	forwardDialog.Title = "<%=SystemEnv.getHtmlLabelName(33484,user.getLanguage())%>";
	forwardDialog.Width = 600;
	forwardDialog.Height = 500;
	forwardDialog.Drag = true;
	forwardDialog.maxiumnable = false;
	forwardDialog.URL = url;
	forwardDialog.show();
}
function onReject() {
	var rejectDialog = new window.top.Dialog();
	rejectDialog.currentWindow = window;
	var url = "/workflow/workflow/showButtonNameReject.jsp?wfid=<%=wfid %>&nodeid=<%=nodeid %>";
	rejectDialog.Title = "<%=SystemEnv.getHtmlLabelName(84508,user.getLanguage())%>";
	rejectDialog.Width = 600;
	rejectDialog.Height = 370;
	rejectDialog.Drag = true;
	rejectDialog.maxiumnable = false;
	rejectDialog.URL = url;
	rejectDialog.show();
}
function onTakingOp() {
	var takingOpDialog = new window.top.Dialog();
	takingOpDialog.currentWindow = window;
	var url = "/workflow/workflow/showButtonNameTakingOp.jsp?wfid=<%=wfid %>&nodeid=<%=nodeid %>";
	takingOpDialog.Title = "<%=SystemEnv.getHtmlLabelName(126632,user.getLanguage())%>";
	takingOpDialog.Width = 600;
	takingOpDialog.Height = 370;
	takingOpDialog.Drag = true;
	takingOpDialog.maxiumnable = false;
	takingOpDialog.URL = url;
	takingOpDialog.show();
}
function checkClick(obj) {
	if(obj.checked) {
		$("#IsWaitForwardOpinion").val("1");
	}else {
		$("#IsWaitForwardOpinion").val("0");
	}
}
function onShowDetail(id, menuType, rowindex) {
	var enable = jQuery("#enable_" + rowindex).attr("checked") ? 1 : 0;
	var buttonName = "newName_" + rowindex;
	var newName = "";
	var obj_multilang = jQuery("input[name=__multilangpre_" + buttonName + "]");
	if(obj_multilang.length > 0) {
		newName = obj_multilang.val();
	}
	var newName7 = jQuery("input[name=" + buttonName + "]").val();

	var title = "";
	if(1 == menuType) {
		title = "<%=SystemEnv.getHtmlLabelName(126431, user.getLanguage()) %>";
	}else if(2 == menuType) {
		title = "<%=SystemEnv.getHtmlLabelName(126432, user.getLanguage()) %>";
	}
	var backDialog = new window.top.Dialog();
	backDialog.currentWindow = window;
	var url = "/workflow/workflow/showButtonNameDetail.jsp?wfid=<%=wfid %>&nodeid=<%=nodeid %>&id=" + id + "&menuType=" + menuType + "&enable=" + enable + "&newName7=" + encodeURIComponent(newName7) + "&newName=" + encodeURIComponent(newName);
	backDialog.Title = title;
	backDialog.Width = 600;
	backDialog.Height = 370;
	backDialog.Drag = true;
	backDialog.maxiumnable = false;
	backDialog.URL = url;
	backDialog.show();
}
function changeCheck(obj, name) {
	var checked = jQuery(obj).attr("checked");
	var nextObj = jQuery("input[id^='" + name + "']").attr("checked", checked).next();
	if(checked) {
		nextObj.addClass("jNiceChecked");
	}else{
		nextObj.removeClass("jNiceChecked");
	}
}
function togglePanel(evt, obj) {
	evt.cancelBubble = true;
	evt.stopPropagation();
	var position = jQuery(obj).position();
	var width = jQuery("#addRowPanel").width();
	jQuery("#addRowPanel").css({left:position.left+25-width, top:position.top+25}).toggle();
}
function addRow(menuType) {
	var rowindex = jQuery("#menuNum").val();
	var oTable = document.getElementById("buttonNameTable");
	var oRow = oTable.insertRow(-1);
	for(var j = 0; j < 7; j++) {
		if(j == 4 && <%="".equals(ifchangstatus) %>) {
			continue;
		}
		var oCell = oRow.insertCell(-1);
		var sHtml = "";
		switch(j) {
			case 0:
				sHtml = "<input type=\"checkbox\" name=\"check_menu\" id=\"check_menu_" + rowindex + "\" value=\"0\" />";
				break;
			case 1:
				if(0 == menuType) { // 新建流程
					sHtml = "<%=SystemEnv.getHtmlLabelName(16392, user.getLanguage()) %>";
				}else if(1 == menuType) { // 新建短信
					sHtml = "<%=SystemEnv.getHtmlLabelName(16444, user.getLanguage()) %>";
				}else if(2 == menuType) { // 新建微信
					sHtml = "<%=SystemEnv.getHtmlLabelName(32818, user.getLanguage()) %>";
				}
				sHtml += "<input type=\"hidden\" name=\"id_" + rowindex + "\" value=\"0\" />";
				sHtml += "<input type=\"hidden\" name=\"menuType_" + rowindex + "\" value=\"" + menuType + "\" />";
				break;
			case 2:
				sHtml = "<input type=\"checkbox\" name=\"enable_" + rowindex + "\" id=\"enable_" + rowindex + "\" value=\"1\" />";
				break;
			case 3:
				sHtml = "<INPUT class=InputStyle maxLength=10 size=14 name=\"newName_" + rowindex + "\" value=\"\">";
				break;
			case 4:
				sHtml = "";
				break;
			case 5:
				if(0 == menuType) { // 新建流程
					sHtml = "<span style=\"float: left\"><%=SystemEnv.getHtmlLabelName(34067, user.getLanguage()) %>：&nbsp;</span><span id=\"workflowidSpan_" + rowindex + "\"></span>";
				}else {
					sHtml = "<a href=\"javascript:onShowDetail(0, " + menuType + ", " + rowindex + ")\"><%=SystemEnv.getHtmlLabelName(19342, user.getLanguage()) %></a>";
				}
				break;
			case 6:
				sHtml = "<input type=\"checkbox\" name=\"sync_" + rowindex + "\" id=\"sync_" + rowindex + "\" value=\"1\">";
				break;
		}
		jQuery(oCell).append(sHtml);
	}
	jQuery(oTable).append("<tr class='Spacing' style=\"height:1px!important;\"><td colspan=7 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>");
	if(0 == menuType) {
		jQuery("#workflowidSpan_" + rowindex).e8Browser({
			name: "workflowid_" + rowindex,
			viewType: "0",
			hasBrowser: true,
			browserUrl: "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp",
			isMustInput: "2",
			isSingle: true,
			hasInput: true,
			completeUrl: "/data.jsp?type=workflowBrowser",
			width: "150px"
		});
	}
	jQuery("#menuNum").val(rowindex * 1 + 1);
	jQuery("body").jNice();
}
function delRow(evt) {
	evt.cancelBubble = true;
	evt.stopPropagation();
	
	var ids = jQuery("input[name='check_menu']:checked");
	if(ids.length > 0) {
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097, user.getLanguage()) %>", function() {
			jQuery(ids).each(function() {
				var val = jQuery(this).val();
				if(val != 0) {
					jQuery("#delids").val(jQuery("#delids").val() + "," + val);
				}
				var parentTR = jQuery(this).closest("tr");
				jQuery(parentTR).next("tr").remove();
				jQuery(parentTR).remove();
			});
		}, function() {}, 320, 90, true);
	}else {
		top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(22686, user.getLanguage()) %>');
		return;
	}
}
</script>
