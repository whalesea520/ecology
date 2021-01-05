<!DOCTYPE html>
<%@ page import="weaver.general.Util,weaver.general.GCONST" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="FlowExceptionHandle" class="weaver.workflow.request.FlowExceptionHandle" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="multiLangFilter" class="weaver.filter.MultiLangFilter" scope="page" />
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<%@ page import="weaver.odoc.workflow.workflow.beans.FormSignatueConfigInfo" %>
<jsp:useBean id="FormSignatureConfigUtil" class="weaver.odoc.workflow.workflow.utils.FormSignatureConfigUtil" scope="page" />
<HTML><HEAD>
<link REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/js/ecology8/weaverautocomplete/css/weaverautocomplete_wev8.css">
<LINK rel="stylesheet" type="text/css" href="/css/ereportstyle_wev8.css">
<script type="text/javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/weaverautocomplete/weaverautocomplete_wev8.js"></script>

</HEAD>
<body>
<%
	int wfid = Util.getIntValue(request.getParameter("wfid"),0);
	int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
	String settype = Util.null2String(request.getParameter("setType"));
	String navTitle = "";
	if(settype.equals("title"))
		navTitle = SystemEnv.getHtmlLabelName(33482,user.getLanguage());
	else if(settype.equals("sign") || settype.equals("forward")){
		String nodessql = "select nodename from workflow_nodebase where id = " + nodeid;   //显示节点的名称
		RecordSet.executeSql(nodessql);
		String titleName = SystemEnv.getHtmlLabelName(33483,user.getLanguage());
		if(settype.equals("forward")) {
			titleName = SystemEnv.getHtmlLabelName(33484,user.getLanguage());
		}
		if(RecordSet.next()){
			titleName = RecordSet.getString("nodename");	
		}
		navTitle = titleName;
	}
	else if(settype.equals("freewf"))
		navTitle = SystemEnv.getHtmlLabelName(33486,user.getLanguage());
	else if(settype.equals("subWorkflow"))
		navTitle = SystemEnv.getHtmlLabelName(21584,user.getLanguage());
	else if(settype.equals("exceptionhandle"))
		navTitle = FlowExceptionHandle.getNodeName(wfid, nodeid);
%>
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=navTitle %>"/>
</jsp:include>
<%
boolean freeflow=GCONST.getFreeFlow();    
int design = Util.getIntValue(request.getParameter("design"),0);
String nodetitle= Util.null2String(request.getParameter("nodetitle"));
int isFormSignature= Util.getIntValue(request.getParameter("isFormSignature"),0);
int IsPendingForward= Util.getIntValue(request.getParameter("IsPendingForward"),0);   //允许转发
int IsSubmitedOpinion= Util.getIntValue(request.getParameter("IsSubmitedOpinion"),0); //转发提交意见，被转发人在转发人提交前/后都可提交意见
boolean promptdiv = false;



int IsBeForward= Util.getIntValue(request.getParameter("IsBeForward"),0);  //被转发人是否可转发

int IsSubmitForward= Util.getIntValue(request.getParameter("IsSubmitForward"),0); //是否允许已办及办结事宜转发  ?? 
int IssynPending= Util.getIntValue(request.getParameter("IssynPending"),0);
int IssynAlready= Util.getIntValue(request.getParameter("IssynAlready"),0);
int IssynHandled= Util.getIntValue(request.getParameter("IssynHandled"),0);
int formSignatureWidth= Util.getIntValue(request.getParameter("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
int formSignatureHeight= Util.getIntValue(request.getParameter("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
String src = Util.null2String(request.getParameter("src"));
int issignmustinput = Util.getIntValue(request.getParameter("issignmustinput"), 0);
//子流程

int issynsubworkflow = Util.getIntValue(request.getParameter("issynsubworkflow"), 0);
//zn
int ishideinput = Util.getIntValue(request.getParameter("ishideinput"), 0);
int ishidearea = Util.getIntValue(request.getParameter("ishidearea"), 0);
int isfeedback = Util.getIntValue(request.getParameter("isfeedback"), 0);
int isnullnotfeedback = Util.getIntValue(request.getParameter("isnullnotfeedback"), 0);

int IssynFormSign= Util.getIntValue(request.getParameter("IssynFormSign"),0);//是否同步签字意见输入
int issynremark = Util.getIntValue(request.getParameter("issynremark"), 0);//是否同步签字意见显示
int issynresp = Util.getIntValue(request.getParameter("issynresp"), 0);//是否同步签字意见反馈
String signfieldids = Util.null2String(request.getParameter("signfieldids"));//签字意见所需显示字段
String viewnodeids = Util.null2String(request.getParameter("viewnodeids"));//签字意见所需显示字段
//qc 176363  闃叉鍏冪礌disabled鎺変箣鍚庡€间紶閫掍笉鍒扮殑闂
if(viewnodeids.trim().equals("")){
     viewnodeids = Util.null2String(request.getParameter("viewnodeidsForDisable"));
}
if(viewnodeids.trim().equals("-2")){
     viewnodeids = "";
}
String signfieldname = "";
String viewnodenames = "";

int IsBeForwardSubmit= Util.getIntValue(request.getParameter("IsBeForwardSubmit"),0); //转办（提交），被转发人可提交意见（转发人提交前被转发人可提交意见，否则只能查看，查看后就到已办或者办结中）

int IsBeForwardModify= Util.getIntValue(request.getParameter("IsBeForwardModify"),0); //转办（修改），(被转发人可修改表单)
int IsBeForwardPending= Util.getIntValue(request.getParameter("IsBeForwardPending"),0); //转发人提交后被转发人未查看停留在待办
int IsShowPendingForward=Util.getIntValue(request.getParameter("IsShowPendingForward"),0); //显示允许待办事宜转发
String PendingForward_Name7=Util.null2String(request.getParameter("PendingForward_Name7"));
String PendingForward_Name8=Util.null2String(request.getParameter("PendingForward_Name8"));
String PendingForward_Name9=Util.null2String(request.getParameter("PendingForward_Name9"));
int IsShowWaitForwardOpinion=Util.getIntValue(request.getParameter("IsShowWaitForwardOpinion"),0);
String WaitForwardOpinion_Name7=Util.null2String(request.getParameter("WaitForwardOpinion_Name7"));
String WaitForwardOpinion_Name8=Util.null2String(request.getParameter("WaitForwardOpinion_Name8"));
String WaitForwardOpinion_Name9=Util.null2String(request.getParameter("WaitForwardOpinion_Name9"));
int IsShowBeForward=Util.getIntValue(request.getParameter("IsShowBeForward"),0);
String BeForward_Name = Util.null2String(request.getParameter("BeForward_Name"));
String BeForward_Name7= "";
String BeForward_Name8= "";
String BeForward_Name9= "";
int IsShowSubmitedOpinion=Util.getIntValue(request.getParameter("IsShowSubmitedOpinion"),0);
String SubmitedOpinion_Name = Util.null2String(request.getParameter("SubmitedOpinion_Name"));
String SubmitedOpinion_Name7="";
String SubmitedOpinion_Name8="";
String SubmitedOpinion_Name9="";
int IsShowSubmitForward=Util.getIntValue(request.getParameter("IsShowSubmitForward"),0);
String SubmitForward_Name7=Util.null2String(request.getParameter("SubmitForward_Name7"));
String SubmitForward_Name8=Util.null2String(request.getParameter("SubmitForward_Name8"));
String SubmitForward_Name9=Util.null2String(request.getParameter("SubmitForward_Name9"));
int IsShowBeForwardSubmit=Util.getIntValue(request.getParameter("IsShowBeForwardSubmit"),0);
String BeForwardSubmit_Name7=Util.null2String(request.getParameter("BeForwardSubmit_Name7"));
String BeForwardSubmit_Name8=Util.null2String(request.getParameter("BeForwardSubmit_Name8"));
String BeForwardSubmit_Name9=Util.null2String(request.getParameter("BeForwardSubmit_Name9"));
int IsShowBeForwardModify=Util.getIntValue(request.getParameter("IsShowBeForwardModify"),0);
String BeForwardModify_Name7=Util.null2String(request.getParameter("BeForwardModify_Name7"));
String BeForwardModify_Name8=Util.null2String(request.getParameter("BeForwardModify_Name8"));
String BeForwardModify_Name9=Util.null2String(request.getParameter("BeForwardModify_Name9"));
int IsShowBeForwardPending=Util.getIntValue(request.getParameter("IsShowBeForwardPending"),0);
String BeForwardPending_Name7=Util.null2String(request.getParameter("BeForwardPending_Name7"));
String BeForwardPending_Name8=Util.null2String(request.getParameter("BeForwardPending_Name8"));
String BeForwardPending_Name9=Util.null2String(request.getParameter("BeForwardPending_Name9"));
//by sjh 81983 新增字段 转发功能需求改进

int IsBeForwardTodo = Util.getIntValue(request.getParameter("IsBeForwardTodo"),0);  //待办被转发人可转发

int IsShowBeForwardTodo = Util.getIntValue(request.getParameter("IsShowBeForwardTodo"),0); //待办被转发人可转发—显示

String BeForwardTodo_Name = Util.null2String(request.getParameter("BeForwardTodo_Name"));
String BeForwardTodo_Name7= ""; 
String BeForwardTodo_Name8= ""; 
String BeForwardTodo_Name9= ""; 

int IsBeForwardAlready = Util.getIntValue(request.getParameter("IsBeForwardAlready"),0);  //已办被转发人可转发

int IsShowBeForwardAlready = Util.getIntValue(request.getParameter("IsShowBeForwardAlready"),0); //已办被转发人可转发—显示

String BeForwardAlready_Name = Util.null2String(request.getParameter("BeForwardAlready_Name"));
String BeForwardAlready_Name7= ""; 
String BeForwardAlready_Name8= ""; 
String BeForwardAlready_Name9= ""; 

int IsAlreadyForward = Util.getIntValue(request.getParameter("IsAlreadyForward"),0);  //允许已办事宜转发
int IsShowAlreadyForward = Util.getIntValue(request.getParameter("IsShowAlreadyForward"),0); //允许已办事宜转发—显示

String AlreadyForward_Name7=Util.null2String(request.getParameter("AlreadyForward_Name7")); 
String AlreadyForward_Name8=Util.null2String(request.getParameter("AlreadyForward_Name8")); 
String AlreadyForward_Name9=Util.null2String(request.getParameter("AlreadyForward_Name9")); 

int IsBeForwardSubmitAlready = Util.getIntValue(request.getParameter("IsBeForwardSubmitAlready"),0);  //允许已办被转发人可提交意见

int IsShowBeForwardSubmitAlready = Util.getIntValue(request.getParameter("IsShowBeForwardSubmitAlready"),0); //允许已办被转发人可提交意见—显示

String BeForwardSubmitAlready_Name = Util.null2String(request.getParameter("BeForwardSubmitAlready_Name"));
String BeForwardSubmitAlready_Name7= ""; 
String BeForwardSubmitAlready_Name8= ""; 
String BeForwardSubmitAlready_Name9= ""; 

int IsBeForwardSubmitNotaries = Util.getIntValue(request.getParameter("IsBeForwardSubmitNotaries"),0);  //允许办结被转发人可提交意见

int IsShowBeForwardSubmitNotaries = Util.getIntValue(request.getParameter("IsShowBeForwardSubmitNotaries"),0); //允许办结被转发人可提交意见—显示

String BeForwardSubmitNotaries_Name = Util.null2String(request.getParameter("BeForwardSubmitNotaries_Name"));
String BeForwardSubmitNotaries_Name7= ""; 
String BeForwardSubmitNotaries_Name8= ""; 
String BeForwardSubmitNotaries_Name9= "";

/*子流程设置相关信息*/
String issubwfAllEnd = Util.null2String(request.getParameter("issubwfAllEnd"));
String subwfscope = Util.null2String(request.getParameter("subwfscope"));
String subwfdiffscope = Util.null2String(request.getParameter("subwfdiffscope"));
String issubwfremind = Util.null2String(request.getParameter("issubwfremind"));
String[] subwfremindtypes = request.getParameterValues("subwfremindtype");
String subwfremindtype = "";
for(int i = 0; subwfremindtypes != null && i < subwfremindtypes.length; i++){
	subwfremindtype += subwfremindtypes[i];
	if( i != subwfremindtypes.length - 1){
		subwfremindtype += ',';
	}
}


//int isRemarkLocation = 0;

String subwfremindoperator =  Util.null2String(request.getParameter("subwfremindoperator"));
String subwfremindobject = Util.null2String(request.getParameter("subwfremindobject"));
String subwfremindperson = Util.null2String(request.getParameter("subwfremindperson"));
String subwffreeforword = Util.null2String(request.getParameter("subwffreeforword"));
String subProcessSummary = Util.null2String(request.getParameter("subProcessSummary"));//子流程归档后汇总数据到主流程
/*流转异常设置*/
int isSynExceptionHandle =Util.getIntValue(request.getParameter("isSynExceptionHandle"), 0);
int useExceptionHandle = Util.getIntValue(request.getParameter("useExceptionHandle"), 0);
int exceptionHandleWay = Util.getIntValue(request.getParameter("exceptionHandleWay"));
int flowToAssignNode = Util.getIntValue(request.getParameter("flowToAssignNode"));
if(exceptionHandleWay == 2)		isSynExceptionHandle = 0;		//异常到指定节点不能同步到所有节点
/**当前节点操作者不可互相查看意见*/
int notseeeachother = Util.getIntValue(request.getParameter("notseeeachother"),0);

int nodetype=-1;
int nodeattribute=WFLinkInfo.getNodeAttribute(nodeid);
    int saveType = Util.getIntValue(request.getParameter("saveType"),0); // 转发进行同步操作
if(saveType==1){
    {
        //    wfid: 61
//    src: save
//    nodeid: 261
//    design: 0
//    setType: forward
        IssynPending=1;
        IssynHandled=1;
        IssynAlready=1;
        RecordSet.executeSql("select * from workflow_flownode where workflowId="+wfid+" and nodeId="+nodeid);
        if(RecordSet.next()){
            nodetitle = Util.toHtml2(Util.encodeAnd(Util.null2String(RecordSet.getString("nodetitle"))));
            isFormSignature = Util.getIntValue(RecordSet.getString("isFormSignature"),0);
            IsPendingForward = Util.getIntValue(RecordSet.getString("IsPendingForward"),0);
            IsBeForward = Util.getIntValue(RecordSet.getString("IsBeForward"),0);
            IsSubmitedOpinion = Util.getIntValue(RecordSet.getString("IsSubmitedOpinion"),0);
            IsSubmitForward = Util.getIntValue(RecordSet.getString("IsSubmitForward"),0);
            formSignatureWidth= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
            formSignatureHeight= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
            issignmustinput = Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
            //zn
            ishideinput = Util.getIntValue(RecordSet.getString("ishideinput"), 0);
            ishidearea = Util.getIntValue(RecordSet.getString("ishidearea"), 0);
            isfeedback = Util.getIntValue(RecordSet.getString("isfeedback"), 0);
            isnullnotfeedback = Util.getIntValue(RecordSet.getString("isnullnotfeedback"), 0);
            IsBeForwardSubmit = Util.getIntValue(RecordSet.getString("IsBeForwardSubmit"), 0);
            IsBeForwardModify = Util.getIntValue(RecordSet.getString("IsBeForwardModify"), 0);
            IsBeForwardPending = Util.getIntValue(RecordSet.getString("IsBeForwardPending"), 0);
            IsShowPendingForward = Util.getIntValue(RecordSet.getString("IsShowPendingForward"), 0);
            IsShowWaitForwardOpinion = Util.getIntValue(RecordSet.getString("IsShowWaitForwardOpinion"), 0);
            IsShowBeForward = Util.getIntValue(RecordSet.getString("IsShowBeForward"), 0);
            IsShowSubmitedOpinion = Util.getIntValue(RecordSet.getString("IsShowSubmitedOpinion"), 0);
            IsShowSubmitForward = Util.getIntValue(RecordSet.getString("IsShowSubmitForward"), 0);
            IsShowBeForwardSubmit = Util.getIntValue(RecordSet.getString("IsShowBeForwardSubmit"), 0);
            IsShowBeForwardModify = Util.getIntValue(RecordSet.getString("IsShowBeForwardModify"), 0);
            IsShowBeForwardPending = Util.getIntValue(RecordSet.getString("IsShowBeForwardPending"), 0);
            //by sjh 81983 新增字段
            IsBeForwardTodo = Util.getIntValue(RecordSet.getString("IsBeForwardTodo"), 0); //待办被转发人可转发

            IsBeForwardAlready = Util.getIntValue(RecordSet.getString("IsBeForwardAlready"), 0); //已办被转发人可转发

            IsAlreadyForward = Util.getIntValue(RecordSet.getString("IsAlreadyForward"), 0); //允许已办事宜转发
            IsBeForwardSubmitAlready = Util.getIntValue(RecordSet.getString("IsBeForwardSubmitAlready"), 0); //允许已办被转发人可提交意见

            IsBeForwardSubmitNotaries = Util.getIntValue(RecordSet.getString("IsBeForwardSubmitNotaries"), 0); //允许办结被转发人可提交意见

            IsShowBeForwardTodo = Util.getIntValue(RecordSet.getString("IsShowBeForwardTodo"), 0);
            IsShowBeForwardAlready = Util.getIntValue(RecordSet.getString("IsShowBeForwardAlready"), 0);
            IsShowAlreadyForward = Util.getIntValue(RecordSet.getString("IsShowAlreadyForward"), 0);
            IsShowBeForwardSubmitAlready = Util.getIntValue(RecordSet.getString("IsShowBeForwardSubmitAlready"), 0);
            IsShowBeForwardSubmitNotaries = Util.getIntValue(RecordSet.getString("IsShowBeForwardSubmitNotaries"), 0);
            //签字意见显示字段
            signfieldids=Util.null2String(RecordSet.getString("signfieldids"));
            //签字意见显示节点
            viewnodeids=Util.null2String(RecordSet.getString("viewnodeids"));
//        isRemarkLocation  = Util.getIntValue(RecordSet.getString("isRemarkLocation"),0);
            if("-1".equals(viewnodeids)){
                viewnodenames = SystemEnv.getHtmlLabelName(332,user.getLanguage());
            }else{
                String tempnodeids[] = Util.TokenizerString2(viewnodeids, ",");
                WFNodeMainManager.setWfid(wfid);
                WFNodeMainManager.selectWfNode();
                while(WFNodeMainManager.next()){
                    int tmpid = WFNodeMainManager.getNodeid();
                    String tmpname = WFNodeMainManager.getNodename();
                    String tmptype = WFNodeMainManager.getNodetype();
                    for(String tempnodeid:tempnodeids){
                        if(tempnodeid.equals(""+tmpid))
                            viewnodenames += ","+tmpname;
                    }
                }
                if(viewnodenames.length()>1){
                    viewnodenames=viewnodenames.substring(1);
                }
            }
            if(!"".equals(signfieldids)){
                if(signfieldids.contains("0")){
                    signfieldname=signfieldname.concat(SystemEnv.getHtmlLabelName(129433, user.getLanguage()) + ",");
                }
                if(signfieldids.contains("1")){
                    signfieldname=signfieldname.concat(SystemEnv.getHtmlLabelName(17482, user.getLanguage()) + ",");
                }
                if(signfieldids.contains("2")){
                    signfieldname=signfieldname.concat(SystemEnv.getHtmlLabelName(15070, user.getLanguage()) + ",");
                }
                if(signfieldids.contains("3")){
                    signfieldname=signfieldname.concat(SystemEnv.getHtmlLabelName(15390, user.getLanguage()) + ",");
                }
                if(signfieldids.contains("4")){
                    signfieldname=signfieldname.concat(SystemEnv.getHtmlLabelName(21663, user.getLanguage()) + ",");
                }
                if(signfieldids.contains("5")){
                    signfieldname=signfieldname.concat(SystemEnv.getHtmlLabelName(15502, user.getLanguage()) + ",");
                }
                if(signfieldids.contains("6")){
                    signfieldname=signfieldname.concat(SystemEnv.getHtmlLabelName(81454, user.getLanguage()));
                }
            }
         /*子流程设置相关信息*/
            issubwfAllEnd = Util.null2String(RecordSet.getString("issubwfAllEnd"));
            subwfscope = Util.null2String(RecordSet.getString("subwfscope"));
            subwfdiffscope = Util.null2String(RecordSet.getString("subwfdiffscope"));
            issubwfremind = Util.null2String(RecordSet.getString("issubwfremind"));
            subwfremindtype = Util.null2String(RecordSet.getString("subwfremindtype"));
            subwfremindoperator = Util.null2String(RecordSet.getString("subwfremindoperator"));
            subwfremindobject = Util.null2String(RecordSet.getString("subwfremindobject"));
            subwfremindperson = Util.null2String(RecordSet.getString("subwfremindperson"));
            subwffreeforword = Util.null2String(RecordSet.getString("subwffreeforword"));
            subProcessSummary = Util.null2String(RecordSet.getString("subProcessSummary"));
		/*流转异常设置*/
            useExceptionHandle = Util.getIntValue(RecordSet.getString("useExceptionHandle"), 0);
            exceptionHandleWay = Util.getIntValue(RecordSet.getString("exceptionHandleWay"));
            flowToAssignNode = Util.getIntValue(RecordSet.getString("flowToAssignNode"));
            /**当前节点操作者不可互相查看意见*/
            notseeeachother = Util.getIntValue(RecordSet.getString("notseeeachother"),0);
        }
        RecordSet.executeSql("select * from workflow_CustFieldName where workflowId="+wfid+" and nodeId="+nodeid);
        while(RecordSet.next()){
            String fieldname=Util.null2String(RecordSet.getString("fieldname"));
            int language=Util.getIntValue(RecordSet.getString("Languageid"),7);
            String CustFieldName=Util.toHtml2(Util.encodeAnd(Util.null2String(RecordSet.getString("CustFieldName"))));
            if(fieldname.equalsIgnoreCase("PendingForward")){
                if(language==8){
                    PendingForward_Name8 =CustFieldName;
                }else if(language==9){
                    PendingForward_Name9 = CustFieldName;
                }else{
                    PendingForward_Name7 = CustFieldName;
                }
            }
            if(fieldname.equalsIgnoreCase("WaitForwardOpinion")){
                if(language==8){
                    WaitForwardOpinion_Name8 =CustFieldName;
                }else if(language==9){
                    WaitForwardOpinion_Name9 = CustFieldName;
                }else{
                    WaitForwardOpinion_Name7 = CustFieldName;
                }
            }
            if(fieldname.equalsIgnoreCase("BeForward")){
                if(language==8){
                    BeForward_Name8 =CustFieldName;
                }else if(language==9){
                    BeForward_Name9 = CustFieldName;
                }else{
                    BeForward_Name7 = CustFieldName;
                }
            }
            if(fieldname.equalsIgnoreCase("SubmitedOpinion")){
                if(language==8){
                    SubmitedOpinion_Name8 =CustFieldName;
                }else if(language==9){
                    SubmitedOpinion_Name9 = CustFieldName;
                }else{
                    SubmitedOpinion_Name7 = CustFieldName;
                }
            }
            if(fieldname.equalsIgnoreCase("SubmitForward")){
                if(language==8){
                    SubmitForward_Name8 =CustFieldName;
                }else if(language==9){
                    SubmitForward_Name9 = CustFieldName;
                }else{
                    SubmitForward_Name7 = CustFieldName;
                }
            }
            if(fieldname.equalsIgnoreCase("BeForwardSubmit")){
                if(language==8){
                    BeForwardSubmit_Name8 =CustFieldName;
                }else if(language==9){
                    BeForwardSubmit_Name9 = CustFieldName;
                }else{
                    BeForwardSubmit_Name7 = CustFieldName;
                }
            }
            if(fieldname.equalsIgnoreCase("BeForwardModify")){
                if(language==8){
                    BeForwardModify_Name8 =CustFieldName;
                }else if(language==9){
                    BeForwardModify_Name9 = CustFieldName;
                }else{
                    BeForwardModify_Name7 = CustFieldName;
                }
            }
            if(fieldname.equalsIgnoreCase("BeForwardPending")){
                if(language==8){
                    BeForwardPending_Name8 =CustFieldName;
                }else if(language==9){
                    BeForwardPending_Name9 = CustFieldName;
                }else{
                    BeForwardPending_Name7 = CustFieldName;
                }
            }
            if(fieldname.equalsIgnoreCase("BeForwardTodo")){
                if(language==8){
                    BeForwardTodo_Name8 =CustFieldName;
                }else if(language==9){
                    BeForwardTodo_Name9 = CustFieldName;
                }else{
                    BeForwardTodo_Name7 = CustFieldName;
                }
            }
            if(fieldname.equalsIgnoreCase("BeForwardAlready")){
                if(language==8){
                    BeForwardAlready_Name8 =CustFieldName;
                }else if(language==9){
                    BeForwardAlready_Name9 = CustFieldName;
                }else{
                    BeForwardAlready_Name7 = CustFieldName;
                }
            }
            if(fieldname.equalsIgnoreCase("AlreadyForward")){
                if(language==8){
                    AlreadyForward_Name8 =CustFieldName;
                }else if(language==9){
                    AlreadyForward_Name9 = CustFieldName;
                }else{
                    AlreadyForward_Name7 = CustFieldName;
                }
            }
            if(fieldname.equalsIgnoreCase("BeForwardSubmitAlready")){
                if(language==8){
                    BeForwardSubmitAlready_Name8 =CustFieldName;
                }else if(language==9){
                    BeForwardSubmitAlready_Name9 = CustFieldName;
                }else{
                    BeForwardSubmitAlready_Name7 = CustFieldName;
                }
            }
            if(fieldname.equalsIgnoreCase("BeForwardSubmitNotaries")){
                if(language==8){
                    BeForwardSubmitNotaries_Name8 =CustFieldName;
                }else if(language==9){
                    BeForwardSubmitNotaries_Name9 = CustFieldName;
                }else{
                    BeForwardSubmitNotaries_Name7 = CustFieldName;
                }
            }
            boolean enableMultiLang = Util.isEnableMultiLang();
            SubmitedOpinion_Name = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{SubmitedOpinion_Name7, SubmitedOpinion_Name8, SubmitedOpinion_Name9}) : SubmitedOpinion_Name7;
            BeForwardTodo_Name  = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{BeForwardTodo_Name7, BeForwardTodo_Name8, BeForwardTodo_Name9}) : BeForwardTodo_Name7;
            BeForwardSubmitAlready_Name = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{BeForwardSubmitAlready_Name7, BeForwardSubmitAlready_Name8, BeForwardSubmitAlready_Name9}) : BeForwardSubmitAlready_Name7;
            BeForwardAlready_Name = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{BeForwardAlready_Name7, BeForwardAlready_Name8, BeForwardAlready_Name9}) : BeForwardAlready_Name7;
            BeForwardSubmitNotaries_Name = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{BeForwardSubmitNotaries_Name7, BeForwardSubmitNotaries_Name8, BeForwardSubmitNotaries_Name9}) : BeForwardSubmitNotaries_Name7;
            BeForward_Name = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{BeForward_Name7, BeForward_Name8, BeForward_Name9}) : BeForward_Name7;
        }
    }
}

if(src.equals("")){
	RecordSet.executeSql("select * from workflow_flownode where workflowId="+wfid+" and nodeId="+nodeid);
	if(RecordSet.next()){
		nodetitle = Util.toHtml2(Util.encodeAnd(Util.null2String(RecordSet.getString("nodetitle"))));
        isFormSignature = Util.getIntValue(RecordSet.getString("isFormSignature"),0);        
        IsPendingForward = Util.getIntValue(RecordSet.getString("IsPendingForward"),0);
        IsBeForward = Util.getIntValue(RecordSet.getString("IsBeForward"),0);
        IsSubmitedOpinion = Util.getIntValue(RecordSet.getString("IsSubmitedOpinion"),0);
        IsSubmitForward = Util.getIntValue(RecordSet.getString("IsSubmitForward"),0);
        formSignatureWidth= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
		formSignatureHeight= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
        nodetype=Util.getIntValue(RecordSet.getString("nodetype"));
        issignmustinput = Util.getIntValue(RecordSet.getString("issignmustinput"), 0);
        //zn
        ishideinput = Util.getIntValue(RecordSet.getString("ishideinput"), 0);
        ishidearea = Util.getIntValue(RecordSet.getString("ishidearea"), 0);
        isfeedback = Util.getIntValue(RecordSet.getString("isfeedback"), 0);
        isnullnotfeedback = Util.getIntValue(RecordSet.getString("isnullnotfeedback"), 0);
        IsBeForwardSubmit = Util.getIntValue(RecordSet.getString("IsBeForwardSubmit"), 0);
        IsBeForwardModify = Util.getIntValue(RecordSet.getString("IsBeForwardModify"), 0);
        IsBeForwardPending = Util.getIntValue(RecordSet.getString("IsBeForwardPending"), 0);
        IsShowPendingForward = Util.getIntValue(RecordSet.getString("IsShowPendingForward"), 0);
        IsShowWaitForwardOpinion = Util.getIntValue(RecordSet.getString("IsShowWaitForwardOpinion"), 0);
        IsShowBeForward = Util.getIntValue(RecordSet.getString("IsShowBeForward"), 0);
        IsShowSubmitedOpinion = Util.getIntValue(RecordSet.getString("IsShowSubmitedOpinion"), 0);
        IsShowSubmitForward = Util.getIntValue(RecordSet.getString("IsShowSubmitForward"), 0);
        IsShowBeForwardSubmit = Util.getIntValue(RecordSet.getString("IsShowBeForwardSubmit"), 0);
        IsShowBeForwardModify = Util.getIntValue(RecordSet.getString("IsShowBeForwardModify"), 0);
        IsShowBeForwardPending = Util.getIntValue(RecordSet.getString("IsShowBeForwardPending"), 0);
        //by sjh 81983 新增字段
        IsBeForwardTodo = Util.getIntValue(RecordSet.getString("IsBeForwardTodo"), 0); //待办被转发人可转发

        IsBeForwardAlready = Util.getIntValue(RecordSet.getString("IsBeForwardAlready"), 0); //已办被转发人可转发

        IsAlreadyForward = Util.getIntValue(RecordSet.getString("IsAlreadyForward"), 0); //允许已办事宜转发
        IsBeForwardSubmitAlready = Util.getIntValue(RecordSet.getString("IsBeForwardSubmitAlready"), 0); //允许已办被转发人可提交意见

        IsBeForwardSubmitNotaries = Util.getIntValue(RecordSet.getString("IsBeForwardSubmitNotaries"), 0); //允许办结被转发人可提交意见

        IsShowBeForwardTodo = Util.getIntValue(RecordSet.getString("IsShowBeForwardTodo"), 0);
        IsShowBeForwardAlready = Util.getIntValue(RecordSet.getString("IsShowBeForwardAlready"), 0);
        IsShowAlreadyForward = Util.getIntValue(RecordSet.getString("IsShowAlreadyForward"), 0);
        IsShowBeForwardSubmitAlready = Util.getIntValue(RecordSet.getString("IsShowBeForwardSubmitAlready"), 0);
        IsShowBeForwardSubmitNotaries = Util.getIntValue(RecordSet.getString("IsShowBeForwardSubmitNotaries"), 0);      
        //签字意见显示字段
        signfieldids=Util.null2String(RecordSet.getString("signfieldids"));
        //签字意见显示节点
        viewnodeids=Util.null2String(RecordSet.getString("viewnodeids"));
//        isRemarkLocation  = Util.getIntValue(RecordSet.getString("isRemarkLocation"),0); 
        if("-1".equals(viewnodeids)){
        	viewnodenames = SystemEnv.getHtmlLabelName(332,user.getLanguage());
        }else{
        	String tempnodeids[] = Util.TokenizerString2(viewnodeids, ",");
            WFNodeMainManager.setWfid(wfid);
    		WFNodeMainManager.selectWfNode(); 
    		while(WFNodeMainManager.next()){
    			int tmpid = WFNodeMainManager.getNodeid();
    			String tmpname = WFNodeMainManager.getNodename();
    			String tmptype = WFNodeMainManager.getNodetype();
    			for(String tempnodeid:tempnodeids){
    				if(tempnodeid.equals(""+tmpid))
    					viewnodenames += ","+tmpname;
    			}
    		}
    		if(viewnodenames.length()>1){
    			viewnodenames=viewnodenames.substring(1);
    		}
        }
        if(!"".equals(signfieldids)){
    		if(signfieldids.contains("0")){
    			signfieldname=signfieldname.concat(SystemEnv.getHtmlLabelName(129433, user.getLanguage()) + ",");
    		}
    		if(signfieldids.contains("1")){
    			signfieldname=signfieldname.concat(SystemEnv.getHtmlLabelName(17482, user.getLanguage()) + ",");
    		}
    		if(signfieldids.contains("2")){
    			signfieldname=signfieldname.concat(SystemEnv.getHtmlLabelName(15070, user.getLanguage()) + ",");
    		}
    		if(signfieldids.contains("3")){
    			signfieldname=signfieldname.concat(SystemEnv.getHtmlLabelName(15390, user.getLanguage()) + ",");
    		}
    		if(signfieldids.contains("4")){
    			signfieldname=signfieldname.concat(SystemEnv.getHtmlLabelName(21663, user.getLanguage()) + ",");
    		}
    		if(signfieldids.contains("5")){
    			signfieldname=signfieldname.concat(SystemEnv.getHtmlLabelName(15502, user.getLanguage()) + ",");
    		}
    		if(signfieldids.contains("6")){
    			signfieldname=signfieldname.concat(SystemEnv.getHtmlLabelName(81454, user.getLanguage()));
    		}
        }
         /*子流程设置相关信息*/
        issubwfAllEnd = Util.null2String(RecordSet.getString("issubwfAllEnd"));
		subwfscope = Util.null2String(RecordSet.getString("subwfscope"));
		subwfdiffscope = Util.null2String(RecordSet.getString("subwfdiffscope"));
		issubwfremind = Util.null2String(RecordSet.getString("issubwfremind"));
		subwfremindtype = Util.null2String(RecordSet.getString("subwfremindtype"));
		subwfremindoperator = Util.null2String(RecordSet.getString("subwfremindoperator"));
		subwfremindobject = Util.null2String(RecordSet.getString("subwfremindobject"));
		subwfremindperson = Util.null2String(RecordSet.getString("subwfremindperson"));
		subwffreeforword = Util.null2String(RecordSet.getString("subwffreeforword"));
		subProcessSummary = Util.null2String(RecordSet.getString("subProcessSummary"));
		/*流转异常设置*/
		useExceptionHandle = Util.getIntValue(RecordSet.getString("useExceptionHandle"), 0);
		exceptionHandleWay = Util.getIntValue(RecordSet.getString("exceptionHandleWay"));
		flowToAssignNode = Util.getIntValue(RecordSet.getString("flowToAssignNode"));
		/**当前节点操作者不可互相查看意见*/
		notseeeachother = Util.getIntValue(RecordSet.getString("notseeeachother"),0);
    }
    RecordSet.executeSql("select * from workflow_CustFieldName where workflowId="+wfid+" and nodeId="+nodeid);
	while(RecordSet.next()){
        String fieldname=Util.null2String(RecordSet.getString("fieldname"));
        int language=Util.getIntValue(RecordSet.getString("Languageid"),7);
        String CustFieldName=Util.toHtml2(Util.encodeAnd(Util.null2String(RecordSet.getString("CustFieldName"))));
        if(fieldname.equalsIgnoreCase("PendingForward")){
            if(language==8){
                PendingForward_Name8 =CustFieldName;
            }else if(language==9){
                PendingForward_Name9 = CustFieldName;
            }else{
                PendingForward_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("WaitForwardOpinion")){
            if(language==8){
                WaitForwardOpinion_Name8 =CustFieldName;
            }else if(language==9){
                WaitForwardOpinion_Name9 = CustFieldName;
            }else{
                WaitForwardOpinion_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("BeForward")){
            if(language==8){
                BeForward_Name8 =CustFieldName;
            }else if(language==9){
                BeForward_Name9 = CustFieldName;
            }else{
                BeForward_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("SubmitedOpinion")){
            if(language==8){
                SubmitedOpinion_Name8 =CustFieldName;
            }else if(language==9){
                SubmitedOpinion_Name9 = CustFieldName;
            }else{
                SubmitedOpinion_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("SubmitForward")){
            if(language==8){
                SubmitForward_Name8 =CustFieldName;
            }else if(language==9){
                SubmitForward_Name9 = CustFieldName;
            }else{
                SubmitForward_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("BeForwardSubmit")){
            if(language==8){
                BeForwardSubmit_Name8 =CustFieldName;
            }else if(language==9){
                BeForwardSubmit_Name9 = CustFieldName;
            }else{
                BeForwardSubmit_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("BeForwardModify")){
            if(language==8){
                BeForwardModify_Name8 =CustFieldName;
            }else if(language==9){
                BeForwardModify_Name9 = CustFieldName;
            }else{
                BeForwardModify_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("BeForwardPending")){
            if(language==8){
                BeForwardPending_Name8 =CustFieldName;
            }else if(language==9){
                BeForwardPending_Name9 = CustFieldName;
            }else{
                BeForwardPending_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("BeForwardTodo")){
            if(language==8){
                BeForwardTodo_Name8 =CustFieldName;
            }else if(language==9){
                BeForwardTodo_Name9 = CustFieldName;
            }else{
                BeForwardTodo_Name7 = CustFieldName;
            }
        }       
        if(fieldname.equalsIgnoreCase("BeForwardAlready")){
            if(language==8){
                BeForwardAlready_Name8 =CustFieldName;
            }else if(language==9){
                BeForwardAlready_Name9 = CustFieldName;
            }else{
                BeForwardAlready_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("AlreadyForward")){
            if(language==8){
                AlreadyForward_Name8 =CustFieldName;
            }else if(language==9){
                AlreadyForward_Name9 = CustFieldName;
            }else{
                AlreadyForward_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("BeForwardSubmitAlready")){
            if(language==8){
                BeForwardSubmitAlready_Name8 =CustFieldName;
            }else if(language==9){
                BeForwardSubmitAlready_Name9 = CustFieldName;
            }else{
                BeForwardSubmitAlready_Name7 = CustFieldName;
            }
        }
        if(fieldname.equalsIgnoreCase("BeForwardSubmitNotaries")){
            if(language==8){
                BeForwardSubmitNotaries_Name8 =CustFieldName;
            }else if(language==9){
                BeForwardSubmitNotaries_Name9 = CustFieldName;
            }else{
                BeForwardSubmitNotaries_Name7 = CustFieldName;
            }
        }        
        boolean enableMultiLang = Util.isEnableMultiLang();
        SubmitedOpinion_Name = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{SubmitedOpinion_Name7, SubmitedOpinion_Name8, SubmitedOpinion_Name9}) : SubmitedOpinion_Name7;
		BeForwardTodo_Name  = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{BeForwardTodo_Name7, BeForwardTodo_Name8, BeForwardTodo_Name9}) : BeForwardTodo_Name7;
		BeForwardSubmitAlready_Name = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{BeForwardSubmitAlready_Name7, BeForwardSubmitAlready_Name8, BeForwardSubmitAlready_Name9}) : BeForwardSubmitAlready_Name7;
		BeForwardAlready_Name = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{BeForwardAlready_Name7, BeForwardAlready_Name8, BeForwardAlready_Name9}) : BeForwardAlready_Name7;
		BeForwardSubmitNotaries_Name = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{BeForwardSubmitNotaries_Name7, BeForwardSubmitNotaries_Name8, BeForwardSubmitNotaries_Name9}) : BeForwardSubmitNotaries_Name7;
		BeForward_Name = enableMultiLang ? Util.toMultiLangScreenFromArray(new String[]{BeForward_Name7, BeForward_Name8, BeForward_Name9}) : BeForward_Name7;
    }
}else {
	SubmitedOpinion_Name7 = Util.processBody(SubmitedOpinion_Name, "7");
	SubmitedOpinion_Name8 = Util.processBody(SubmitedOpinion_Name, "8");
	SubmitedOpinion_Name9 = Util.processBody(SubmitedOpinion_Name, "9");
	BeForwardTodo_Name7 = Util.processBody(BeForwardTodo_Name, "7");
	BeForwardTodo_Name8 = Util.processBody(BeForwardTodo_Name, "8");
	BeForwardTodo_Name9 = Util.processBody(BeForwardTodo_Name, "9");
	BeForwardSubmitAlready_Name7 = Util.processBody(BeForwardSubmitAlready_Name, "7");
	BeForwardSubmitAlready_Name8 = Util.processBody(BeForwardSubmitAlready_Name, "8");
	BeForwardSubmitAlready_Name9 = Util.processBody(BeForwardSubmitAlready_Name, "9");
	BeForwardAlready_Name7 = Util.processBody(BeForwardAlready_Name, "7");
	BeForwardAlready_Name8 = Util.processBody(BeForwardAlready_Name, "8");
	BeForwardAlready_Name9 = Util.processBody(BeForwardAlready_Name, "9");
	BeForwardSubmitNotaries_Name7 = Util.processBody(BeForwardSubmitNotaries_Name, "7");
	BeForwardSubmitNotaries_Name8 = Util.processBody(BeForwardSubmitNotaries_Name, "8");
	BeForwardSubmitNotaries_Name9 = Util.processBody(BeForwardSubmitNotaries_Name, "9");
	BeForward_Name7 = Util.processBody(BeForward_Name, "7");
	BeForward_Name8 = Util.processBody(BeForward_Name, "8");
	BeForward_Name9 = Util.processBody(BeForward_Name, "9");
}


String ifchangstatus=Util.null2String(BaseBean.getPropValue(GCONST.getConfigFile() , "ecology.changestatus"));
//liuzy E8节点属性拆分为标题显示设置、签字意见设置、转发设置、自由流转设置

boolean hassetting=false;
if(!hassetting&&settype.equals("title")){
	if(!nodetitle.equals(""))
		hassetting=true;
}else if(!hassetting&&settype.equals("sign")){
	if(isFormSignature==1||issignmustinput>=1||ishideinput==1||ishidearea==1
	||(isfeedback==1&&ifchangstatus.equals("1")) || notseeeachother == 1) 
		hassetting=true;
}else if(!hassetting&&settype.equals("forward")){
	if(IsPendingForward==1||IsSubmitedOpinion==1||IsSubmitForward==1
	||IsBeForwardSubmit==1||IsBeForwardModify==1||IsBeForwardPending==1||IsShowPendingForward==1
	||IsShowWaitForwardOpinion==1||IsShowBeForward==1||IsShowSubmitedOpinion==1
	||IsShowSubmitForward==1||IsShowBeForwardSubmit==1||IsShowBeForwardModify==1
	||IsShowBeForwardPending==1||IsAlreadyForward==1) 
		hassetting=true;
}else if(!hassetting&&settype.equals("freewf")){
}else if(!hassetting&&settype.equals("subWorkflow")){		//子流程判断 liuzy
	if(issubwfAllEnd.equals("1")||issubwfremind.equals("1")||subwffreeforword.equals("1"))
		hassetting=true;
}else if(settype.equals("exceptionhandle")){		//流转异常处理 liuzy
	if(useExceptionHandle == 1)
		hassetting = true;
}
boolean needSyncNodes = false;		//用于流程图编辑时同步节点，勾选其它节点
if(settype.equals("exceptionhandle")){
	if(isSynExceptionHandle == 1)
		needSyncNodes = true;
}


boolean hasSubmitedOpinion = false;
boolean hasBeForwardSubmit = false;
boolean hasWaitForwardOpinion = false;
boolean hasBeForwardPending = false;
boolean hasShowSubmitedOpinion = false;
boolean hasShowBeForwardSubmit = false;
boolean hasShowWaitForwardOpinion = false;
boolean hasShowBeForwardPending = false;

if(IsSubmitedOpinion==1 || IsBeForwardPending==1 || (IsBeForwardModify!=1 && IsBeForwardSubmit!=1)) 
	hasWaitForwardOpinion=true;
	
if(IsSubmitedOpinion==1){
    hasBeForwardSubmit=true;
    hasWaitForwardOpinion = true;
    hasBeForwardPending=true;
}
if(IsBeForwardSubmit==1 || IsBeForwardPending==1)
	hasSubmitedOpinion = true;

if(IsBeForwardPending ==1) hasWaitForwardOpinion = true;

if(IsShowSubmitedOpinion==1 || IsShowBeForwardPending==1 || (IsShowBeForwardModify!=1 && IsShowBeForwardSubmit!=1)) 
	hasShowWaitForwardOpinion=true;
	
if(IsShowSubmitedOpinion==1){
    hasShowBeForwardSubmit=true;
    hasShowWaitForwardOpinion = true;
    hasShowBeForwardPending=true;
}
if(IsShowBeForwardSubmit==1 || IsShowWaitForwardOpinion==1 || IsShowBeForwardPending==1)
	hasShowSubmitedOpinion = true;

if(IsShowWaitForwardOpinion==1) hasShowBeForwardPending = true;
if(IsShowBeForwardPending ==1) hasShowWaitForwardOpinion = true;

if(IsPendingForward!=1){
	hasSubmitedOpinion = true;
	hasBeForwardSubmit = true;
	//hasWaitForwardOpinion = true;
	hasBeForwardPending = true;
	hasShowSubmitedOpinion = true;
	hasShowBeForwardSubmit = true;
	hasShowWaitForwardOpinion = true;
	hasShowBeForwardPending = true;
}
if(src.equals("save")){
	String setfiled = "";
	if(settype.equals("title")) 
		setfiled = " nodetitle='" + Util.toHtml100(nodetitle) +"' ";
	else if(settype.equals("sign"))
		setfiled =  " isFormSignature='" + isFormSignature +
					"',formSignatureWidth='" + formSignatureWidth +				
					"',signfieldids='" + signfieldids+		
					"',viewnodeids='" + viewnodeids+	
        			"',formSignatureHeight=" + formSignatureHeight +
        			",issignmustinput=" + issignmustinput +
        			",ishideinput=" + ishideinput +
        			",isfeedback=" + isfeedback+
        			",isnullnotfeedback=" + isnullnotfeedback+
        			",ishidearea=" + ishidearea + 
        			",notseeeachother='" + notseeeachother+"' ";//zn
	else if(settype.equals("forward"))
		setfiled =  " IsPendingForward='" + IsPendingForward +
			        "',IsBeForward='" + IsBeForward +
			        "',IsSubmitedOpinion='" + IsSubmitedOpinion +
			        "',IsSubmitForward='" + IsSubmitForward +
			        //"',isfeedback='" + isfeedback +
			        //"',isnullnotfeedback='"+isnullnotfeedback+
			        "',IsBeForwardSubmit ='"+ IsBeForwardSubmit+
			        "',IsBeForwardModify = '"+ IsBeForwardModify+
			        "',IsBeForwardPending = '"+ IsBeForwardPending+
			        "',IsShowPendingForward = '"+ IsShowPendingForward+
			        "',IsShowWaitForwardOpinion = '"+ IsShowWaitForwardOpinion+
			        "',IsShowBeForward = '"+ IsShowBeForward+
			        "',IsShowSubmitedOpinion = '"+ IsShowSubmitedOpinion+
			        "',IsShowSubmitForward = '"+ IsShowSubmitForward+
			        "',IsShowBeForwardSubmit = '"+ IsShowBeForwardSubmit+
			        "',IsShowBeForwardModify = '"+ IsShowBeForwardModify+
			        "',IsShowBeForwardPending = '"+ IsShowBeForwardPending+
				    "',IsBeForwardTodo = '"+ IsBeForwardTodo+
			        "',IsShowBeForwardTodo = '"+ IsShowBeForwardTodo+
			        "',IsBeForwardAlready = '"+ IsBeForwardAlready+
			        "',IsShowBeForwardAlready = '"+ IsShowBeForwardAlready+
			        "',IsAlreadyForward = '"+ IsAlreadyForward+
			        "',IsShowAlreadyForward = '"+ IsShowAlreadyForward+
			        "',IsBeForwardSubmitAlready = '"+ IsBeForwardSubmitAlready+
			        "',IsShowBeForwardSubmitAlready = '"+ IsShowBeForwardSubmitAlready+
			        "',IsBeForwardSubmitNotaries = '"+ IsBeForwardSubmitNotaries+
			        "',IsShowBeForwardSubmitNotaries = '"+ IsShowBeForwardSubmitNotaries+ "' ";   
	else if(settype.equals("freewf"))
		setfiled = "";
	else if(settype.equals("subWorkflow")){
		setfiled = "issubwfAllEnd='"+issubwfAllEnd
					+"',subwfscope='"+subwfscope
					+"',subwfdiffscope='"+subwfdiffscope
					+"',issubwfremind='"+issubwfremind
					+"',subProcessSummary='"+subProcessSummary
					+"',subwfremindtype='"+subwfremindtype
					+"',subwfremindoperator='"+subwfremindoperator
					+"',subwfremindobject='"+subwfremindobject
					+"',subwfremindperson='"+subwfremindperson
					+"',subwffreeforword='"+subwffreeforword+"' ";
    }else if(settype.equals("exceptionhandle")){
    	if(useExceptionHandle == 0)		exceptionHandleWay = 0;
    	if(exceptionHandleWay != 2)		flowToAssignNode = -1;
    	setfiled = "useExceptionHandle='"+useExceptionHandle
    				+"',exceptionHandleWay='"+exceptionHandleWay
    				+"',flowToAssignNode="+flowToAssignNode+" ";
    }
	//System.out.println("setfiled===="+setfiled);
	if(setfiled.equals("")) return;	// 理论上 setfiled 肯定不为空的
	
	if (("subWorkflow".equals(settype) && issynsubworkflow == 1)
		||("exceptionhandle".equals(settype) && isSynExceptionHandle == 1)) {
		//局部变量，仅在这里使用
		int temp_nodeid = 0;
		int temp_nodeattribute = 0;
		RecordSet2.executeSql("select nb.id,nb.nodeattribute from workflow_nodebase nb inner join workflow_flownode fn on nb.id=fn.nodeid where fn.workflowid="+wfid);
		while(RecordSet2.next()){
			temp_nodeattribute = Util.getIntValue(RecordSet2.getString("nodeattribute"), 0);
			//System.out.println("nodeattribute2===================="+nodeattribute2);
			if(temp_nodeattribute == 3 || temp_nodeattribute == 4 || temp_nodeattribute == 5){
				temp_nodeid = RecordSet2.getInt("id");
			}
		}
		RecordSet.executeSql("UPDATE workflow_flownode SET " + setfiled + " WHERE workflowId="+wfid+" and nodeid <> "+temp_nodeid);
	} else {		
    	RecordSet.executeSql("update workflow_flownode set " + setfiled + " where workflowId="+wfid+" and nodeId="+nodeid);
	}
	
    if(settype.equals("forward"))	//只有当转发设置时，才删除
    	RecordSet.executeSql("delete from workflow_CustFieldName where workflowId="+wfid+" and nodeId="+nodeid);
    if (!PendingForward_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'PendingForward',7,'"+Util.toHtml100(PendingForward_Name7)+"')");
    }
    if (!PendingForward_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'PendingForward',8,'"+Util.toHtml100(PendingForward_Name8)+"')");
    }
    if (!PendingForward_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'PendingForward',9,'"+Util.toHtml100(PendingForward_Name9)+"')");
    }
    if (!WaitForwardOpinion_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'WaitForwardOpinion',7,'"+Util.toHtml100(WaitForwardOpinion_Name7)+"')");
    }
    if (!WaitForwardOpinion_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'WaitForwardOpinion',8,'"+Util.toHtml100(WaitForwardOpinion_Name8)+"')");
    }
    if (!WaitForwardOpinion_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'WaitForwardOpinion',9,'"+Util.toHtml100(WaitForwardOpinion_Name9)+"')");
    }
    if (!BeForward_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForward',7,'"+Util.toHtml100(BeForward_Name7)+"')");
    }
    if (!BeForward_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForward',8,'"+Util.toHtml100(BeForward_Name8)+"')");
    }
    if (!BeForward_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForward',9,'"+Util.toHtml100(BeForward_Name9)+"')");
    }
    if (!SubmitedOpinion_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'SubmitedOpinion',7,'"+Util.toHtml100(SubmitedOpinion_Name7)+"')");
    }
    if (!SubmitedOpinion_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'SubmitedOpinion',8,'"+Util.toHtml100(SubmitedOpinion_Name8)+"')");
    }
    if (!SubmitedOpinion_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'SubmitedOpinion',9,'"+Util.toHtml100(SubmitedOpinion_Name9)+"')");
    }
    if (!SubmitForward_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'SubmitForward',7,'"+Util.toHtml100(SubmitForward_Name7)+"')");
    }
    if (!SubmitForward_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'SubmitForward',8,'"+Util.toHtml100(SubmitForward_Name8)+"')");
    }
    if (!SubmitForward_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'SubmitForward',9,'"+Util.toHtml100(SubmitForward_Name9)+"')");
    }
    if (!BeForwardSubmit_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardSubmit',7,'"+Util.toHtml100(BeForwardSubmit_Name7)+"')");
    }
    if (!BeForwardSubmit_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardSubmit',8,'"+Util.toHtml100(BeForwardSubmit_Name8)+"')");
    }
    if (!BeForwardSubmit_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardSubmit',9,'"+Util.toHtml100(BeForwardSubmit_Name9)+"')");
    }
    if (!BeForwardModify_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardModify',7,'"+Util.toHtml100(BeForwardModify_Name7)+"')");
    }
    if (!BeForwardModify_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardModify',8,'"+Util.toHtml100(BeForwardModify_Name8)+"')");
    }
    if (!BeForwardModify_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardModify',9,'"+Util.toHtml100(BeForwardModify_Name9)+"')");
    }
    if (!BeForwardPending_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardPending',7,'"+Util.toHtml100(BeForwardPending_Name7)+"')");
    }
    if (!BeForwardPending_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardPending',8,'"+Util.toHtml100(BeForwardPending_Name8)+"')");
    }
    if (!BeForwardPending_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardPending',9,'"+Util.toHtml100(BeForwardPending_Name9)+"')");
    }
    if (!BeForwardTodo_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardTodo',7,'"+Util.toHtml100(BeForwardTodo_Name7)+"')");
    }
    if (!BeForwardTodo_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardTodo',8,'"+Util.toHtml100(BeForwardTodo_Name8)+"')");
    }
    if (!BeForwardTodo_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardTodo',9,'"+Util.toHtml100(BeForwardTodo_Name9)+"')");
    }
    if (!BeForwardAlready_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardAlready',7,'"+Util.toHtml100(BeForwardAlready_Name7)+"')");
    }
    if (!BeForwardAlready_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardAlready',8,'"+Util.toHtml100(BeForwardAlready_Name8)+"')");
    }
    if (!BeForwardAlready_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardAlready',9,'"+Util.toHtml100(BeForwardAlready_Name9)+"')");
    }   
    if (!AlreadyForward_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'AlreadyForward',7,'"+Util.toHtml100(AlreadyForward_Name7)+"')");
    }
    if (!AlreadyForward_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'AlreadyForward',8,'"+Util.toHtml100(AlreadyForward_Name8)+"')");
    }
    if (!AlreadyForward_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'AlreadyForward',9,'"+Util.toHtml100(AlreadyForward_Name9)+"')");
    } 
    if (!BeForwardSubmitAlready_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardSubmitAlready',7,'"+Util.toHtml100(BeForwardSubmitAlready_Name7)+"')");
    }
    if (!BeForwardSubmitAlready_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardSubmitAlready',8,'"+Util.toHtml100(BeForwardSubmitAlready_Name8)+"')");
    }
    if (!BeForwardSubmitAlready_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardSubmitAlready',9,'"+Util.toHtml100(BeForwardSubmitAlready_Name9)+"')");
    }
    if (!BeForwardSubmitNotaries_Name7.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardSubmitNotaries',7,'"+Util.toHtml100(BeForwardSubmitNotaries_Name7)+"')");
    }
    if (!BeForwardSubmitNotaries_Name8.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardSubmitNotaries',8,'"+Util.toHtml100(BeForwardSubmitNotaries_Name8)+"')");
    }
    if (!BeForwardSubmitNotaries_Name9.equals("")) {
        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) values("+wfid+","+nodeid+",'BeForwardSubmitNotaries',9,'"+Util.toHtml100(BeForwardSubmitNotaries_Name9)+"')");
    }     
    if(IssynPending==1){
        RecordSet.executeSql("update workflow_flownode set IsPendingForward='"+IsPendingForward+
                "',IsSubmitedOpinion='"+IsSubmitedOpinion+
                "',IsBeForwardSubmit ='"+ IsBeForwardSubmit+
                "',IsBeForwardModify = '"+ IsBeForwardModify+
                "',IsBeForwardPending = '"+ IsBeForwardPending+
                "',IsShowPendingForward = '"+ IsShowPendingForward+
                "',IsShowWaitForwardOpinion = '"+ IsShowWaitForwardOpinion+
                "',IsShowSubmitedOpinion = '"+ IsShowSubmitedOpinion+
                "',IsShowBeForwardSubmit = '"+ IsShowBeForwardSubmit+
                "',IsShowBeForwardModify = '"+ IsShowBeForwardModify+
                "',IsShowBeForwardPending = '"+ IsShowBeForwardPending+
				"',IsBeForwardTodo = '"+ IsBeForwardTodo+
                "',IsShowBeForwardTodo = '"+ IsShowBeForwardTodo+
				"' where workflowId="+wfid);
        RecordSet.executeSql("delete from workflow_CustFieldName where (fieldname='PendingForward'" +
                " or fieldname='WaitForwardOpinion'" +
                " or fieldname='SubmitedOpinion'" +
                " or fieldname='BeForwardSubmit'" +
                " or fieldname='BeForwardModify'" +
                " or fieldname='BeForwardTodo'" +
                " or fieldname='BeForwardPending') and workflowId="+wfid);
	    if (!PendingForward_Name7.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'PendingForward',7,'"+Util.toHtml100(PendingForward_Name7)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!PendingForward_Name8.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'PendingForward',8,'"+Util.toHtml100(PendingForward_Name8)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!PendingForward_Name9.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'PendingForward',9,'"+Util.toHtml100(PendingForward_Name9)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!WaitForwardOpinion_Name7.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'WaitForwardOpinion',7,'"+Util.toHtml100(WaitForwardOpinion_Name7)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!WaitForwardOpinion_Name8.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'WaitForwardOpinion',8,'"+Util.toHtml100(WaitForwardOpinion_Name8)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!WaitForwardOpinion_Name9.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'WaitForwardOpinion',9,'"+Util.toHtml100(WaitForwardOpinion_Name9)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!SubmitedOpinion_Name7.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'SubmitedOpinion',7,'"+Util.toHtml100(SubmitedOpinion_Name7)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!SubmitedOpinion_Name8.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'SubmitedOpinion',8,'"+Util.toHtml100(SubmitedOpinion_Name8)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!SubmitedOpinion_Name9.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'SubmitedOpinion',9,'"+Util.toHtml100(SubmitedOpinion_Name9)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForwardSubmit_Name7.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardSubmit',7,'"+Util.toHtml100(BeForwardSubmit_Name7)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForwardSubmit_Name8.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardSubmit',8,'"+Util.toHtml100(BeForwardSubmit_Name8)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForwardSubmit_Name9.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardSubmit',9,'"+Util.toHtml100(BeForwardSubmit_Name9)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForwardModify_Name7.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardModify',7,'"+Util.toHtml100(BeForwardModify_Name7)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForwardModify_Name8.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardModify',8,'"+Util.toHtml100(BeForwardModify_Name8)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForwardModify_Name9.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardModify',9,'"+Util.toHtml100(BeForwardModify_Name9)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForwardPending_Name7.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardPending',7,'"+Util.toHtml100(BeForwardPending_Name7)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForwardPending_Name8.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardPending',8,'"+Util.toHtml100(BeForwardPending_Name8)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForwardPending_Name9.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardPending',9,'"+Util.toHtml100(BeForwardPending_Name9)+"' from workflow_flownode where workflowid="+wfid);
	    }
		if (!BeForwardTodo_Name7.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardTodo',7,'"+Util.toHtml100(BeForwardTodo_Name7)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForwardTodo_Name8.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardTodo',8,'"+Util.toHtml100(BeForwardTodo_Name8)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForwardTodo_Name9.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardTodo',9,'"+Util.toHtml100(BeForwardTodo_Name9)+"' from workflow_flownode where workflowid="+wfid);
	    }
    }
    if(IssynHandled==1){
        RecordSet.executeSql("update workflow_flownode set IsBeForward='"+IsBeForward+
                "',IsSubmitForward='"+IsSubmitForward+
                "',IsShowBeForward = '"+ IsShowBeForward+
                "',IsShowSubmitForward = '"+ IsShowSubmitForward+
				"',IsBeForwardSubmitNotaries = '"+ IsBeForwardSubmitNotaries+
                "',IsShowBeForwardSubmitNotaries = '"+ IsShowBeForwardSubmitNotaries+
				"' where workflowId="+wfid);
        RecordSet.executeSql("delete from workflow_CustFieldName where (fieldname='BeForward'" +
							 " or fieldname='SubmitForward' or fieldname='BeForwardSubmitNotaries') and workflowId="+wfid);
	    if (!BeForward_Name7.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForward',7,'"+Util.toHtml100(BeForward_Name7)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForward_Name8.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForward',8,'"+Util.toHtml100(BeForward_Name8)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForward_Name9.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForward',9,'"+Util.toHtml100(BeForward_Name9)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!SubmitForward_Name7.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'SubmitForward',7,'"+Util.toHtml100(SubmitForward_Name7)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!SubmitForward_Name8.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'SubmitForward',8,'"+Util.toHtml100(SubmitForward_Name8)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!SubmitForward_Name9.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'SubmitForward',9,'"+Util.toHtml100(SubmitForward_Name9)+"' from workflow_flownode where workflowid="+wfid);
	    }
		if (!BeForwardSubmitNotaries_Name7.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardSubmitNotaries',7,'"+Util.toHtml100(BeForwardSubmitNotaries_Name7)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForwardSubmitNotaries_Name8.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardSubmitNotaries',8,'"+Util.toHtml100(BeForwardSubmitNotaries_Name8)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForwardSubmitNotaries_Name9.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardSubmitNotaries',9,'"+Util.toHtml100(BeForwardSubmitNotaries_Name9)+"' from workflow_flownode where workflowid="+wfid);
	    }
    }
	if(IssynAlready==1){
        RecordSet.executeSql("update workflow_flownode set IsAlreadyForward='"+IsAlreadyForward+
                "',IsBeForwardAlready='"+IsBeForwardAlready+
                "',IsBeForwardSubmitAlready = '"+ IsBeForwardSubmitAlready+
                "',IsShowAlreadyForward = '"+ IsShowAlreadyForward+
                "',IsShowBeForwardAlready = '"+ IsShowBeForwardAlready+
                "',IsShowBeForwardSubmitAlready = '"+ IsShowBeForwardSubmitAlready+
            "' where workflowId="+wfid);
        RecordSet.executeSql("delete from workflow_CustFieldName where (fieldname='BeForwardAlready'" +
                " or fieldname='AlreadyForward' or fieldname='BeForwardSubmitAlready') and workflowId="+wfid);
	    if (!BeForwardAlready_Name7.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardAlready',7,'"+Util.toHtml100(BeForwardAlready_Name7)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForwardAlready_Name8.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardAlready',8,'"+Util.toHtml100(BeForwardAlready_Name8)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForwardAlready_Name9.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardAlready',9,'"+Util.toHtml100(BeForwardAlready_Name9)+"' from workflow_flownode where workflowid="+wfid);
	    }   
	    if (!AlreadyForward_Name7.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'AlreadyForward',7,'"+Util.toHtml100(AlreadyForward_Name7)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!AlreadyForward_Name8.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'AlreadyForward',8,'"+Util.toHtml100(AlreadyForward_Name8)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!AlreadyForward_Name9.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'AlreadyForward',9,'"+Util.toHtml100(AlreadyForward_Name9)+"' from workflow_flownode where workflowid="+wfid);
	    } 
	    if (!BeForwardSubmitAlready_Name7.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardSubmitAlready',7,'"+Util.toHtml100(BeForwardSubmitAlready_Name7)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForwardSubmitAlready_Name8.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardSubmitAlready',8,'"+Util.toHtml100(BeForwardSubmitAlready_Name8)+"' from workflow_flownode where workflowid="+wfid);
	    }
	    if (!BeForwardSubmitAlready_Name9.equals("")) {
	        RecordSet.executeSql("insert into workflow_CustFieldName(workflowId,nodeId,fieldname,Languageid,CustFieldName) select workflowid,nodeid,'BeForwardSubmitAlready',9,'"+Util.toHtml100(BeForwardSubmitAlready_Name9)+"' from workflow_flownode where workflowid="+wfid);
	    }
    } 

}
//签字意见输入部分同步
if(IssynFormSign==1){
    RecordSet.executeSql("update workflow_flownode set issignmustinput='"+issignmustinput+"',ishideinput='"+ishideinput+"',isFormSignature='"+isFormSignature+"',formSignatureWidth="+formSignatureWidth+",formSignatureHeight="+formSignatureHeight+" where workflowId="+wfid);
    FormSignatueConfigInfo formSignatueConfig = FormSignatureConfigUtil.getFormSignatureConfig(wfid,nodeid,user);
    formSignatueConfig.setSynchAllNodes(true);
    FormSignatureConfigUtil.saveFormSignatueConfig(formSignatueConfig);
}
//签字意见显示部分同步
if(issynremark==1){
	RecordSet.executeSql("update workflow_flownode set ishidearea='"+ishidearea+"',signfieldids='"+signfieldids+"',viewnodeids='"+viewnodeids+"',notseeeachother='"+notseeeachother+"' where workflowId="+wfid);
}
//签字意见反馈部分同步
if(issynresp == 1){
	RecordSet.executeSql("update workflow_flownode set isfeedback='"+isfeedback+"',isnullnotfeedback='"+isnullnotfeedback+"' where workflowId="+wfid);
}
%>

<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(68,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(21393,user.getLanguage()) ;
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
<FORM NAME=SearchForm STYLE="margin-bottom:0" action="showNodeAttrOperate.jsp" method="post">
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="" name="src">
<input type="hidden" value="<%=nodeid%>" name="nodeid">
<input type="hidden" value="<%=design%>" name="design">    
<input type="hidden" value="<%=settype%>" name="setType">    
<%
	String isUseWebRevision=BaseBean.getPropValue("weaver_iWebRevision","isUseWebRevision");
    if(isUseWebRevision==null||isUseWebRevision.trim().equals("")){
		isUseWebRevision="0";
	}
    
 %>
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top"  onclick="onSave();"/>&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 
<wea:layout type="2col" attributes="{'cw1':'30%','cw2':'70%','expandAllGroup':'true'}">
	<%if(settype.equals("title")){ %>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21668,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(21668,user.getLanguage())%></wea:item>
		<wea:item><input class=InputStyle maxLength=10 size=20 name="nodetitle" value = '<%=nodetitle%>'></wea:item>
	</wea:group>
	<!-- 签字意见部分 2014-09-15 改造zhy -->
	<%}else if(settype.equals("sign")){ %>
<%
	//签字意见输入
	String signinput=SystemEnv.getHtmlLabelName(33945,user.getLanguage());
	//签字意见显示
	String signshow=SystemEnv.getHtmlLabelName(33946,user.getLanguage());
	//签字意见反馈
	String signresp=SystemEnv.getHtmlLabelName(33947,user.getLanguage());
	//if(isUseWebRevision.equals("1")){
%>	
	<wea:group context='<%=signinput%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=inputstyle type="checkbox" name="IssynFormSign" value="1" >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33948,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="issignmustinput" id="issignmustinput" onchange="issignmustinputChanged()">
				<option value="0" <% if(0 == issignmustinput) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(127197, user.getLanguage()) %></option>
				<option value="1" <% if(1 == issignmustinput) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(127198, user.getLanguage()) %></option>
				<option value="2" <% if(2 == issignmustinput) { %> selected="selected" <% } %>><%=SystemEnv.getHtmlLabelName(127199, user.getLanguage()) %></option>
			</select>
		</wea:item>
		<wea:item><span class="ishideinput"><%=SystemEnv.getHtmlLabelName(33949,user.getLanguage())%></span></wea:item>
		<wea:item>
			<span class="ishideinput">
			<input class=inputstyle type="checkbox" tzCheckbox="true" id="ishideinput" onclick="ishideinputChanged();" name="ishideinput" value="1" <%if(ishideinput==1){%>checked<%}%> >
			</span>
		</wea:item>
		<%if(isUseWebRevision.equals("1")){%>
		<wea:item attributes="{'samePair':'isFormSignature'}"><%=SystemEnv.getHtmlLabelName(33950,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'isFormSignature'}">
			<input class=inputstyle type="checkbox" tzCheckbox="true" name="isFormSignature" value="1" onclick="showAttribute(this)" <%   if(isFormSignature==1) {%> checked <% } %> >
            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
            <span id="setFormSignatureConfig" <% if(isFormSignature != 1) { %>style="display: none" <% } %>>
                <a href="#" onclick="setFormSignatureConfig()" style="color:blue;TEXT-DECORATION:none">
                    <%=SystemEnv.getHtmlLabelNames("21750,68",user.getLanguage()) %>
                </a>
            </span>
		</wea:item>
		<%}%>
	</wea:group>	
	<wea:group context='<%=signshow%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=inputstyle type="checkbox" id="issynremark" name="issynremark" value="1" >
		</wea:item>	
		<wea:item><%=SystemEnv.getHtmlLabelName(33955,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=inputstyle type="checkbox" tzCheckbox="true" id="ishidearea" onclick="ishideareaChanged();" name="ishidearea" value="1" <%if(ishidearea==1){%>checked<%}%> >
		</wea:item>
		<wea:item attributes="{'samePair':'trsignfields'}"><%=SystemEnv.getHtmlLabelName(81579,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'trsignfields'}">
      		<input type=text readonly="readonly" size="100%" name="viewnodenames" id="viewnodenames" value="<%=viewnodenames%>" style="float: left;">
      		&nbsp;
			<%--qc 176363  闃叉鍏冪礌disabled鎺変箣鍚庝繚瀛樺€间紶閫掍笉鍒扮殑闂--%>
			<input type=hidden name="viewnodenamesForDisable" id="viewnodenamesForDisable" value="<%=viewnodenames%>">
			<input type=hidden name="viewnodeidsForDisable" id="viewnodeidsForDisable" value="<%=viewnodeids%>">
      		<input type=hidden name="viewnodeids" id="viewnodeids" value="<%=viewnodeids%>">
      		<button style="margin-top: 3px;" type=button  class=Browser  onclick="onShowBrowser('/workflow/workflow/wfNodeBrownser.jsp?wfid=<%=wfid%>&nodeid=<%=nodeid%>&action=dialog')"></button>
		</wea:item>
		<%--当前节点操作者不可互相查看意见 --%>
		<wea:item attributes="{'samePair':'trnotseeeachother'}"><%=SystemEnv.getHtmlLabelName(125042,user.getLanguage())%></wea:item>
		<wea:item  attributes="{'samePair':'trnotseeeachother'}">
			<input class=inputstyle type="checkbox" tzCheckbox="true" id="notseeeachother"  name="notseeeachother" value="1" <%if(notseeeachother == 1){%>checked<%}%>>
		</wea:item>
	</wea:group>
	<wea:group context='<%=signresp%>'>
	    <%
		if(ifchangstatus.equals("1")){
		%>
		<wea:item><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=inputstyle type="checkbox" id="issynresp" name="issynresp" value="1" >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33956,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=inputstyle  tzCheckbox="true" type="checkbox" id="isfeedback" name="isfeedback" value="1" <%if(isfeedback==1){%>checked<%}%> onclick="FeedbackChange(this,'isnullnotfeedback')">
		</wea:item>
		<wea:item attributes="{'samePair':'trfreeback','display':'none'}"><%=SystemEnv.getHtmlLabelName(33952,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'trfreeback','display':'none'}">
			<input class=inputstyle  tzCheckbox="true" type="checkbox" id="isnullnotfeedback" name="isnullnotfeedback" value="1" <%if(isfeedback==1&&isnullnotfeedback==1){%>checked<%}%> <%if(isfeedback!=1){%>disabled<%}%>>
		</wea:item>
		<%}%>		
	</wea:group>
	<!-- 签字意见部分 2014-09-15 改造END -->
	<%} else if(settype.equals("forward")){%>	
	<%
		String  groupShow = "{'samePair':'groupShow','groupDisplay':'none',itemAreaDisplay:'none'}";
		if("1".equals(IsPendingForward)) groupShow = "{'samePair':'groupShow','groupDisplay':'',itemAreaDisplay:'block'}";

	%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21751,user.getLanguage())%>'>
	
		<wea:item><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%></wea:item>
		<wea:item> 
			<input class=inputstyle type="checkbox" name="IssynPending" value="1" >
		</wea:item>
			

		
		<wea:item><%=SystemEnv.getHtmlLabelName(82369,user.getLanguage())%></wea:item>
		<wea:item> 
			<INPUT class=inputstyle type="checkbox" name="IsPendingForward"  tzcheckbox="true" value="1"  onclick="toShowGroup(this);CheckClick('IsPendingForward')" <%   if(IsPendingForward==1) {%> checked <% } %> >
			<!--span class="tzCheckBox checked"><span class="tzCBContent"></span><span class="tzCBPart"></span></span-->
		</wea:item>
		<%

			String itemShow1 = "{'isTableList':'true','samePair':'itemShow1','display':'none'}";
			if(1==IsPendingForward) {
				itemShow1 = "{'isTableList':'true','samePair':'itemShow1','display':''}";
			}

		 %>
			<wea:item attributes='<%=itemShow1%>'>
			<!--wea:item attributes="<%=itemShow1 %>"-->
			<TABLE class=ListStyle cellspacing=0>
			<COLGROUP>
				<COL width="15%">
				<COL width="25%">
				<COL width="60%">
			</COLGROUP>
			<TR class="header">
				<TD><nobr><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TD>
				<TD><nobr><%=SystemEnv.getHtmlLabelName(81768,user.getLanguage())%></TD>
				<TD><nobr><%=SystemEnv.getHtmlLabelName(126360,user.getLanguage())%></TD>
			</TR>
			
			<tr class='Spacing' style="height:1px!important;"><td colspan=3 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
			
	        <TR class='groupHeadHide'>
			<!--TD><INPUT class=inputstyle type="checkbox" name="IsShowSubmitedOpinion" value="1"  onclick="CheckClick('IsShowSubmitedOpinion')"  <%   if(IsShowSubmitedOpinion==1) {%> checked <% } %> <%if(hasShowSubmitedOpinion) {%> disabled<%}%>></TD-->
			<!--TD><INPUT class=inputstyle type="checkbox" name="IsShowSubmitedOpinion" value="1"  onclick="CheckClick('IsShowSubmitedOpinion')"  <%   if(IsPendingForward==1) {%> checked <% } %> <%if(IsPendingForward==0) {%> disabled<%}%>></TD-->
				<!--TD><INPUT class=inputstyle type="checkbox" name="IsShowSubmitedOpinion" value="1"  onclick="CheckClick('IsShowSubmitedOpinion')" checked ></TD-->
				<TD><INPUT class=inputstyle type="checkbox" name="IsSubmitedOpinion" value="1" onclick="CheckClick('IsSubmitedOpinion')" <%   if(IsSubmitedOpinion==1) {%> checked <% } %> ></TD>
		    	<!--TD><%=SystemEnv.getHtmlLabelName(21755,user.getLanguage())%></TD-->
				<TD><%=SystemEnv.getHtmlLabelName(81777,user.getLanguage())%></TD>
		    	<TD class=Field><INPUT class=InputStyle maxLength=10 size=16 name="SubmitedOpinion_Name" value="<%=SubmitedOpinion_Name %>" /></TD>
	        </TR>
	        <tr class='Spacing' style="height:1px!important;"><td colspan=3 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
	        <TR class='groupHeadHide'>
			 <!--TD><INPUT class=inputstyle type="checkbox" name="IsShowBeForwardTodo" value="1"  onclick="CheckClick('IsShowBeForwardTodo')" <%   if(IsShowBeForwardTodo==1) {%> checked <% } %> <%if(IsPendingForward!=1) {%> disabled<%}%>></TD-->
				<TD><INPUT class=inputstyle type="checkbox" name="IsBeForwardTodo" value="1" onclick="CheckClick('IsBeForwardTodo')" <%   if(IsBeForwardTodo==1) {%> checked <% } %>></TD>
			    <!--TD><%=SystemEnv.getHtmlLabelName(21754,user.getLanguage())%></TD-->
				<TD><%=SystemEnv.getHtmlLabelName(81776,user.getLanguage())%></TD>
			    <TD class=Field><INPUT class=InputStyle maxLength=10 size=16 name="BeForwardTodo_Name" value="<%=BeForwardTodo_Name %>" /></TD>
	        </TR>		    
			<tr class='Spacing' style="height:1px!important;"><td colspan=3 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
			</TABLE>		
		</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(31944,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=inputstyle type="checkbox" name="IssynAlready" value="1" >
		</wea:item>	
		<wea:item><%=SystemEnv.getHtmlLabelName(82369, user.getLanguage())%></wea:item>
		<!--TD><INPUT class=inputstyle type="checkbox" name="IsAlreadyForward" value="1" onclick="CheckClick('IsAlreadyForward')" <%   if(IsAlreadyForward==1) {%> checked <% } %> ></TD-->
		<wea:item> 
			<INPUT class=inputstyle type="checkbox" name="IsAlreadyForward" value="1" tzcheckbox="true" onclick="toShowGroup2(this),CheckClick('IsAlreadyForward')" <%   if(IsAlreadyForward==1) {%> checked <% } %> >

		</wea:item>
		<%

			String itemShow2 = "{'isTableList':'true','samePair':'itemShow2','display':'none'}";
			if(1==IsAlreadyForward) {
				itemShow2 = "{'isTableList':'true','samePair':'itemShow2','display':''}";
			}
		 %>
		<wea:item attributes='<%=itemShow2%>'>
	 <!--已办被转发人权限-->
			<TABLE class=ListStyle cellspacing=1>
				<COLGROUP>
					<COL width="15%">
					<COL width="25%">
					<COL width="60%">
				</COLGROUP>
				<TR class="header">
					<TD><nobr><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TD>
					<TD><nobr><%=SystemEnv.getHtmlLabelName(81768,user.getLanguage())%></TD>
					<TD><nobr><%=SystemEnv.getHtmlLabelName(126360,user.getLanguage())%></TD>
				</TR>
				<!--TR  class='groupHeadHide'>
					<!--TD><INPUT class=inputstyle type="checkbox" name="IsAlreadyForward" value="1" onclick="CheckClick('IsAlreadyForward')" <%   if(IsAlreadyForward==1) {%> checked <% } %> ></TD>
					<TD><%=SystemEnv.getHtmlLabelNames("115,34127", user.getLanguage())%></TD-->
					<!--TD><INPUT class=inputstyle type="checkbox" name="IsShowAlreadyForward" value="1"  disabled></TD>
					<TD><%=SystemEnv.getHtmlLabelName(81777,user.getLanguage())%></TD>
					<TD class=Field><INPUT class=InputStyle maxLength=10 size=16 name="AlreadyForward_Name7" value = "<%=AlreadyForward_Name7 %>" ></TD>
					<TD class=Field <%if(1!=GCONST.getENLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="AlreadyForward_Name8" value = "<%=AlreadyForward_Name8%>" ></TD>
					<TD class=Field <%if(1!=GCONST.getZHTWLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="AlreadyForward_Name9" value = "<%=AlreadyForward_Name9%>" ></TD>				
				</TR-->
				<tr class='Spacing' style="height:1px!important;"><td colspan=3 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
				<TR class='groupHeadHide'> 
					<TD><INPUT class=inputstyle type="checkbox" name="IsBeForwardSubmitAlready" value="1" onclick="CheckClick('IsBeForwardSubmitAlready')" <%   if(IsBeForwardSubmitAlready==1) {%> checked <% } %> ></TD>
					<!--TD><%=SystemEnv.getHtmlLabelName(22596,user.getLanguage())%></TD-->				
					<!--TD><INPUT class=inputstyle type="checkbox" name="IsShowBeForwardSubmitAlready" value="1"  <%   if(IsShowBeForwardSubmitAlready==1) {%> checked <% } %> <%if(IsAlreadyForward!=1) {%> disabled<%}%>></TD-->
					<TD><%=SystemEnv.getHtmlLabelName(81777,user.getLanguage())%></TD>
					<TD class=Field><INPUT class=InputStyle maxLength=10 size=16 name="BeForwardSubmitAlready_Name" value="<%=BeForwardSubmitAlready_Name %>" /></TD>
				</TR>
				<tr class='Spacing' style="height:1px!important;"><td colspan=3 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
				<TR class='groupHeadHide'>
					<TD><INPUT class=inputstyle type="checkbox" name="IsBeForwardAlready" value="1" onclick="CheckClick('IsBeForwardAlready')" <%   if(IsBeForwardAlready==1) {%> checked <% } %> ></TD>
					<!--TD><%=SystemEnv.getHtmlLabelName(21754,user.getLanguage())%></TD-->
					<!--TD><INPUT class=inputstyle type="checkbox" name="IsShowBeForwardAlready" value="1"  <%   if(IsShowBeForwardAlready==1) {%> checked <% } %> <%if(IsAlreadyForward!=1) {%> disabled<%}%>></TD-->
					<TD><%=SystemEnv.getHtmlLabelName(81776,user.getLanguage())%></TD>
					<TD class=Field><INPUT class=InputStyle maxLength=10 size=16 name="BeForwardAlready_Name" value="<%=BeForwardAlready_Name %>" /></TD>
				</TR>
				<tr class='Spacing' style="height:1px!important;"><td colspan=3 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
			</TABLE>		
		</wea:item>	
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(81824,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=inputstyle type="checkbox" name="IssynHandled" value="1" >
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(82369,user.getLanguage())%></wea:item>
		<wea:item> 
			<INPUT class=inputstyle type="checkbox" name="IsSubmitForward" value="1" tzcheckbox="true" onclick="toShowGroup3(this);CheckClick('IsSubmitForward')" <%   if(IsSubmitForward==1) {%> checked <% } %> >
			<!--TD><INPUT class=inputstyle type="checkbox" name="IsSubmitForward" value="1" onclick="CheckClick('IsSubmitForward')" <%   if(IsSubmitForward==1) {%> checked <% } %> ></TD>
				<TD><%=SystemEnv.getHtmlLabelName(34256,user.getLanguage())%></TD-->
			<!--span class="tzCheckBox checked"><span class="tzCBContent"></span><span class="tzCBPart"></span></span-->
		</wea:item>
<%

			String itemShow3 = "{'isTableList':'true','samePair':'itemShow3','display':'none'}";
			if(1==IsSubmitForward) {
				itemShow3 = "{'isTableList':'true','samePair':'itemShow3','display':''}";
			}

		 %>
		 <!--办结被转发人权限-->
		<wea:item attributes='<%=itemShow3%>'>
			<TABLE class=ListStyle cellspacing=0>
				<COLGROUP>
					<COL width="15%">
					<COL width="25%">
					<COL width="60%">
				</COLGROUP>
				<TR class="header">
				<TD><nobr><%=SystemEnv.getHtmlLabelName(18095,user.getLanguage())%></TD>
				<TD><nobr><%=SystemEnv.getHtmlLabelName(81768,user.getLanguage())%></TD>
				<TD><nobr><%=SystemEnv.getHtmlLabelName(126360,user.getLanguage())%></TD>
				</TR>
				<!--TR>
				<!--TD><INPUT class=inputstyle type="checkbox" name="IsSubmitForward" value="1" onclick="CheckClick('IsSubmitForward')" <%   if(IsSubmitForward==1) {%> checked <% } %> ></TD>
				<TD><%=SystemEnv.getHtmlLabelName(34256,user.getLanguage())%></TD-->
				<!--TD class=Field><INPUT class=InputStyle maxLength=10 size=16 name="SubmitForward_Name7" value = "<%=SubmitForward_Name7%>" ></TD>
				<TD class=Field <%if(1!=GCONST.getENLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="SubmitForward_Name8" value = "<%=SubmitForward_Name8%>" ></TD>
				<TD class=Field <%if(1!=GCONST.getZHTWLANGUAGE()){ %>style="display:none"<%}%>><INPUT class=InputStyle maxLength=20 size=16 name="SubmitForward_Name9" value = "<%=SubmitForward_Name9%>" ></TD>
				<TD><INPUT class=inputstyle type="checkbox" name="IsShowSubmitForward" value="1"  disabled></TD>
				</TR-->
				<tr class='Spacing' style="height:1px!important;"><td colspan=3 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
				<TR>
					<TD><INPUT class=inputstyle type="checkbox" name="IsBeForwardSubmitNotaries" value="1" onclick="CheckClick('IsBeForwardSubmitNotaries')" <%   if(IsBeForwardSubmitNotaries==1) {%> checked <% } %>  ></TD>
					<!--TD><%=SystemEnv.getHtmlLabelName(22596,user.getLanguage())%></TD-->
					<!--TD><INPUT class=inputstyle type="checkbox" name="IsShowBeForwardSubmitNotaries" value="1" <%   if(IsShowBeForwardSubmitNotaries==1) {%> checked <% } %> <%if(IsSubmitForward!=1) {%> disabled<%}%>></TD-->
					<TD><%=SystemEnv.getHtmlLabelName(81777,user.getLanguage())%></TD>
					<TD class=Field><INPUT class=InputStyle maxLength=10 size=16 name="BeForwardSubmitNotaries_Name" value="<%=BeForwardSubmitNotaries_Name %>" /></TD>
				</TR>
				<tr class='Spacing' style="height:1px!important;"><td colspan=3 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
				<TR>
					<TD><INPUT class=inputstyle type="checkbox" name="IsBeForward" value="1" onclick="CheckClick('IsBeForward')" <%   if(IsBeForward==1) {%> checked <% } %>></TD>
					<!--TD><%=SystemEnv.getHtmlLabelName(21754,user.getLanguage())%></TD-->
					<!--TD><INPUT class=inputstyle type="checkbox" name="IsShowBeForward" value="1"  <%   if(IsShowBeForward==1) {%> checked <% } %> <%if(IsSubmitForward!=1) {%> disabled<%}%>></TD-->
					<TD><%=SystemEnv.getHtmlLabelName(81776,user.getLanguage())%></TD>
					<TD class=Field><INPUT class=InputStyle maxLength=10 size=16 name="BeForward_Name" value="<%=BeForward_Name %>" /></TD>
				</TR>
				<tr class='Spacing' style="height:1px!important;"><td colspan=3 class='paddingLeft0'><div class='intervalDivClass'></div></td></tr>
			</TABLE>		
		</wea:item>
	</wea:group>	
	<%}else if(settype.equals("freewf")){ %>
	<%} else if(settype.equals("subWorkflow")){
	%>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(21584,user.getLanguage()) %>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=inputstyle type="checkbox" id="issynsubworkflow" name="issynsubworkflow" value="1" >
		</wea:item>	
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(28082,user.getLanguage()) %>
		</wea:item>
		<wea:item>
			<%
				String checked = "";
				if(issubwfAllEnd.equals("1")){
					checked = "checked";
				}
			%>
			<input type='checkbox' id='issubwfAllEnd' name='issubwfAllEnd' value='1' <%=checked %> tzCheckbox='true' onclick='issubwfAllEndChange(this)'/>
		</wea:item>
		
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(32803,user.getLanguage()) %>
		</wea:item>
		<%	
			String isTriDiffWorkflow = "";
			String formId = "";
			String isBill = "";
			RecordSet.executeSql("select formId,isBill,isTriDiffWorkflow from workflow_base where id="+wfid);
			if (RecordSet.next()) {
				formId = RecordSet.getString("formId");
				isBill = RecordSet.getString("isBill");
				isTriDiffWorkflow = RecordSet.getString("isTriDiffWorkflow");
			}

			String browserName = "";
			String browserValue = "";
			if ("1".equals(isTriDiffWorkflow)) {
				browserName = "subwfdiffscope";
				browserValue = subwfdiffscope;
			} else {
				browserName = "subwfscope";
				browserValue = subwfscope;
			}
			
			if("0".equals(isBill)){
				RecordSet.executeSql("select distinct groupId from workflow_formfield where formid=" + formId + "  and isdetail='1' order by groupId ");
				while(RecordSet.next()){
					promptdiv = true;
				}
			}else{
				RecordSet.executeSql(" SELECT id,tablename,orderid FROM Workflow_billdetailtable where billid = " + formId + " order by orderid");
				while(RecordSet.next()){
					promptdiv = true;
				}
			}
			
		%>
		<wea:item>
			<button onclick="subwfscopeBrowser();" class="Browser1" type="button"></button>
			<%if ("1".equals(issubwfAllEnd) && browserValue != null && !browserValue.isEmpty()) {%>
				<input type="hidden" id="subwfscope" name="<%=browserName%>" value="<%=browserValue%>" />
				<span id="subwfscopespan"><img border="0" width="16" height="17" src="/images/ecology8/checkright_wev8.png"></span>
			<%} else {%>
				<input type="hidden" id="subwfscope" name="<%=browserName%>" />
				<span id="subwfscopespan"><img align="absmiddle" src="/images/BacoError_wev8.gif"></span>
			<%}%>
		</wea:item>
		<!--20150811子流程归档后汇总数据到主流程  -->
		<%
			String  itemShowSub = "";
			 if ("1".equals(issubwfAllEnd) && browserValue != null && !browserValue.isEmpty()) {
				itemShowSub = "{'samePair':'itemShowSub','display':''}";
			}else{
				itemShowSub = "{'samePair':'itemShowSub','display':'none'}";
			}
		%>
		<wea:item attributes="<%=itemShowSub%>">
			<%=SystemEnv.getHtmlLabelName(125341,user.getLanguage()) %>
		</wea:item>
		<wea:item attributes="<%=itemShowSub%>">
			<%
				String subProcessSummaryChecked = "";
				if( subProcessSummary.equals("1") ){
					subProcessSummaryChecked = "checked";
				}
			%>
			<span>
			<input type='checkbox' id='subProcessSummary' name='subProcessSummary' value='1' <%=subProcessSummaryChecked %> tzCheckbox='true' onclick='subProcessSummaryChange(this)'/>
			</span>
			<span id="subProcessData" name="subProcessData" style="padding-left:30px;color:#2690e3;cursor:pointer;font-family:微软雅黑 !important;display:none" onclick="editWFSubList()" >
				<%=SystemEnv.getHtmlLabelName(125343,user.getLanguage()) %>
			</span>
		</wea:item>
	   <%
		String  _attributes = "{'samePair':'issubwfremindAtt','display':'none'}";
		if(issubwfAllEnd.equals("1")){
		    _attributes = "{'samePair':'issubwfremindAtt','display':''}";	
		}
		%>
		<wea:item attributes="<%=_attributes %>">
			<%=SystemEnv.getHtmlLabelName(32804,user.getLanguage()) %>
		</wea:item>
		<wea:item attributes="<%=_attributes %>">
			<%
				String issubwfremindChecked = "";
				if( issubwfremind.equals("1") ){
					issubwfremindChecked = "checked";
				}
			 %>
			<input type='checkbox' id='issubwfremind' name='issubwfremind' value='1' <%=issubwfremindChecked %> tzCheckbox='true' onclick='issubwfremindChange(this)'/>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(18713,user.getLanguage()) %>
		</wea:item>
		<wea:item>
			<%
				String subwfremindtype_sys = "";
				if(subwfremindtype.indexOf("sys") >= 0){
					subwfremindtype_sys = "checked";
				}
				
				String subwfremindtype_ml = "";
				if(subwfremindtype.indexOf("ml") >= 0){
					subwfremindtype_ml = "checked";
				}
				
				String subwfremindtype_sm = "";
				if(subwfremindtype.indexOf("sm") >= 0){
					subwfremindtype_sm = "checked";
				}
			 %>
			<span>
				<input type='checkbox' id='subwfremindtype_sys' name='subwfremindtype' value='sys' <%=subwfremindtype_sys %> tzCheckbox='true'/>
				<%=SystemEnv.getHtmlLabelName(18844,user.getLanguage()) %>
			</span>
			<span style='padding-left:10px;'>
				<input type='checkbox' id='subwfremindtype_ml' name='subwfremindtype' value='ml' <%=subwfremindtype_ml %> tzCheckbox='true'/>
				<%=SystemEnv.getHtmlLabelName(17586,user.getLanguage()) %>
			</span>
			<span style='padding-left:10px;'>
				<input type='checkbox' id='subwfremindtype_sm' name='subwfremindtype' value='sm' <%=subwfremindtype_sm %> tzCheckbox='true'/>
				<%=SystemEnv.getHtmlLabelName(18845,user.getLanguage()) %>
			</span>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(18013,user.getLanguage()) %>
		</wea:item>
		<wea:item>
			<%
				String subwfremindoperatorChecked = "";
				if( subwfremindoperator.equals("1") ){
					subwfremindoperatorChecked = "checked";
				}
				
				String subwfremindobjectChecked = "";
				if(subwfremindobject.equals("1")){
					subwfremindobjectChecked = "checked";
				}
				
				String[] subwfremindpersons = subwfremindperson.split(",");
				String browserSpanValue = "";
				for(int i = 0 ; i < subwfremindpersons.length; i++){
					RecordSet.executeSql("select lastname from hrmresource where id=" + subwfremindpersons[i]);
					if(RecordSet.next()){
						browserSpanValue += RecordSet.getString("lastname");
					}
					
					if( i != subwfremindpersons.length - 1){
						browserSpanValue += ",";
					}
				}
			 %>
			<span>
				<input type='checkbox' id='subwfremindoperator' name='subwfremindoperator' value='1' <%=subwfremindoperatorChecked %> tzCheckbox='true'/>
				<%=SystemEnv.getHtmlLabelName(18676,user.getLanguage()) %>
			</span>
			<span style='padding-left:5px;'>
				<input type='checkbox' id='subwfremindobject' name='subwfremindobject' value='1' <%=subwfremindobjectChecked %> tzCheckbox='true' onclick='subwfremindobjectChange(this)'/>
				<%=SystemEnv.getHtmlLabelName(18846,user.getLanguage()) %>
				<span id='hrmResourceSpan' style='display:inline-block;vertical-align:middle;padding-left:5px;'>
					<brow:browser viewType="0" name="subwfremindperson" browserValue='<%=subwfremindperson %>' 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
						hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2' 
						completeUrl="/data.jsp" width="150px" browserSpanValue='<%=browserSpanValue %>'> </brow:browser>
				</span>
			</span>
		</wea:item>
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(32805,user.getLanguage())%>
		</wea:item>
		<wea:item>
			<%
				String subwffreeforwordChecked = "";
				if( subwffreeforword.equals("1") ){
					subwffreeforwordChecked = "checked";
				}
			 %>
			<input type='checkbox' id='subwffreeforword' name='subwffreeforword' value='1' <%=subwffreeforwordChecked %> tzCheckbox='true'/>
		</wea:item>
	</wea:group>
	<%}else if(settype.equals("exceptionhandle")){ %>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(124779,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(21738,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=inputstyle type="checkbox" name="isSynExceptionHandle" value="1" <%=exceptionHandleWay==2?"disabled":"" %>>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(124778,user.getLanguage())%></wea:item>
		<wea:item>
		<% 
		if(nodeattribute==3 || nodeattribute==4 || nodeattribute==5){
		%>
			<span class="tzCheckBox_disabled"><span class="tzCBContent"></span><span class="tzCBPart_disabled"></span></span>
            <img align="absMiddle" id="ext-gen124" src="/images/remind_wev8.png" title="本节点为分叉流程关键的合并节点,不允许开启流程异常处理!"/>
		<%}else{%>
			<input class=inputstyle type="checkbox" tzCheckbox="true" name="useExceptionHandle" value="1" <%=useExceptionHandle==1?"checked":"" %> onclick="switchShowHandleWay(this);" />
		<%}%>
		</wea:item>
		<%
		String flowToAssignNodeVal = "";
		String flowToAssignNodeName = "";
		if(flowToAssignNode > 0){
			flowToAssignNodeVal = flowToAssignNode+"";
			RecordSet.executeSql("SELECT nodename FROM workflow_nodebase WHERE id="+flowToAssignNode);
			if(RecordSet.next())
				flowToAssignNodeName = Util.null2String(RecordSet.getString("nodename"));
		}
		String exceptiondiv = "{'samePair':'exceptiondiv','display':''}";
		if(useExceptionHandle != 1)
			exceptiondiv = "{'samePair':'exceptiondiv','display':'none'}";
		%>
		<wea:item attributes='<%=exceptiondiv %>'><%=SystemEnv.getHtmlLabelName(124780,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=exceptiondiv %>'>
			<input type="radio" name="exceptionHandleWay" value="1" <%=exceptionHandleWay<=1?"checked":"" %> />
			<%=SystemEnv.getHtmlLabelName(124781,user.getLanguage()) %>&nbsp;&nbsp;
			<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(124782,user.getLanguage()) %>">
				<img src="/images/tooltip_wev8.png" align="absMiddle">
			</span>
		</wea:item>
		<wea:item attributes='<%=exceptiondiv %>'></wea:item>
		<wea:item attributes='<%=exceptiondiv %>'>
			<span style="float:left; padding-right:30px;">
				<input type="radio" name="exceptionHandleWay" value="2" <%=exceptionHandleWay==2?"checked":"" %> />
				<%=SystemEnv.getHtmlLabelName(31856,user.getLanguage()) %>
			</span>
			<brow:browser name="flowToAssignNode" viewType="0" hasBrowser="true" hasAdd="false" 
                getBrowserUrlFn="getSubmitNodesUrlFun" _callback="callbackSubmitNodesBrowser"
                isMustInput="2" isSingle="true" hasInput="false" 
                completeUrl="/data.jsp"  width="150px" browserValue='<%=flowToAssignNodeVal %>' browserSpanValue='<%=flowToAssignNodeName %>'>
			</brow:browser>
		</wea:item>
		<wea:item attributes='<%=exceptiondiv %>'></wea:item>
		<wea:item attributes='<%=exceptiondiv %>'>
			<input type="radio" name="exceptionHandleWay" value="3" <%=exceptionHandleWay==3?"checked":"" %> />
			<%=SystemEnv.getHtmlLabelName(124953,user.getLanguage()) %>
		</wea:item>
	</wea:group>
	<%} %>
</wea:layout>
</form>
</div>
<script language=javascript>
	var dialog = parent.getDialog(window);
	jQuery(document).ready(function(){
  		resizeDialog(document);
  		issignmustinputChanged();
  		 if(jQuery("#ishideinput").is(":checked")){
			jQuery("#formSignatureWidth").removeAttr("disabled");
			jQuery("#formSignatureHeight").removeAttr("disabled");
   		}
   		if(jQuery("#ishidearea").is(":checked")){
   		    jQuery("#viewnodenames").attr("disabled","disabled");
   		    jQuery("#viewnodeids").attr("disabled","disabled");
   		    hideEle("trsignfields");
   		 	hideEle("trnotseeeachother");
   		}
   		if(jQuery("#isfeedback").is(":checked")){
   		    showEle("trfreeback");
   		    jQuery("#isnullnotfeedback").removeAttr("disabled");
   		}
   		<%if(ishideinput==1){%>
   			ishideinputChanged();
   		<%}%>

   		<%if(nodetype == 3){%>
   			hideEle("trnotseeeachother");
   		<%}%>
   		<%if(subProcessSummary.equals("1") ){%>
   			jQuery("#subProcessData").show();
   		<%}%>
   		
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

function onSave(){
	<%if("subWorkflow".equals(settype)){%>
	    if (!checkSubWorkflow()) {
	    	return;
	    }
	<%}%>
	<%if("exceptionhandle".equals(settype)){ %>
		if(jQuery("input:checked[name='exceptionHandleWay']").val() == "2"){
			if(!check_form(SearchForm,"flowToAssignNode")){
				return;
			}
		}
	<%}%>
<%if(settype.equals("sign") && isUseWebRevision.equals("1")){%>
    if(!document.all("isFormSignature").checked||check_form(document.SearchForm,'formSignatureWidth,formSignatureHeight')){
<%}%>
        document.all("src").value="save";
        document.SearchForm.submit();
<%if(settype.equals("sign") && isUseWebRevision.equals("1")){%>
    }
<%}%>
}

function showAttribute(obj){
    if(obj.checked) {
        jQuery("#setFormSignatureConfig").show();
    } else {
        jQuery("#setFormSignatureConfig").hide();
    }
}
function onClose(){
    dialog.close();
}

function showorhiddendiv(obj){
    if(obj.checked){
    	showEle("freewfdiv");
    }else{
        hideEle("freewfdiv");
    }
}

function changejNiceClass(disabledList,undisabledList,checkList,uncheckList){
	for(var i=0;i<disabledList.length;i++){
		var name = disabledList[i];
		$("input[name="+name+"]").next().removeClass("jNiceCheckbox").addClass("jNiceCheckbox_disabled");
	}
	
	for(var i=0;i<undisabledList.length;i++){
		var name = undisabledList[i];
		$("input[name="+name+"]").next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
	}	
	
	for(var i=0;i<checkList.length;i++){
		var name = checkList[i];
		$("input[name="+name+"]").next().addClass("jNiceChecked");
	}
	
	for(var i=0;i<uncheckList.length;i++){
		var name = uncheckList[i];
		$("input[name="+name+"]").next().removeClass("jNiceChecked");
	}			
}

  function CheckClick(checkname){
	var ischeck = $("input[name="+checkname+"]").attr("checked");
	var disabledList = new Array();
	var undisabledList = new Array();　
	var checkList = new Array();
	var uncheckList = new Array();
    if(checkname=="IsPendingForward"){
        if(ischeck){
        	 $("input[name=IsSubmitedOpinion]").trigger("disabled",false);
			$("input[name=IsSubmitedOpinion]").trigger("checked",true);  
        	$("input[name=IsBeForwardTodo]").trigger("disabled",false);
        	$("input[name=IsShowBeForwardTodo]").trigger("disabled",false);
         
        }else{
        	 $("input[name=IsSubmitedOpinion]").trigger("checked",false);
        	$("input[name=IsSubmitedOpinion]").trigger("disabled",true);   
			$("input[name=IsBeForwardTodo]").trigger("checked",false);
        	$("input[name=IsBeForwardTodo]").trigger("disabled",true);        	
        }
    }else if(checkname=="IsTakingOpinions"){ //征求意见(Z)
        if(ischeck){
			 $("#IsWaitForwardOpinion").val("1");
        }else{ 
			 $("#IsWaitForwardOpinion").val("0");
			
        }
    }else if(checkname=="IsAlreadyForward"){ //已办转发(Z)
        if(ischeck){
        	$("input[name=IsBeForwardSubmitAlready]").trigger("disabled",false);
			$("input[name=IsBeForwardSubmitAlready]").trigger("checked",true);	
        	$("input[name=IsBeForwardAlready]").trigger("disabled",false);

        }else{
			$("input[name=IsBeForwardSubmitAlready]").trigger("checked",false);	
        	$("input[name=IsBeForwardSubmitAlready]").trigger("disabled",true); 
			$("input[name=IsBeForwardAlready]").trigger("checked",false);
        	$("input[name=IsBeForwardAlready]").trigger("disabled",true);        	

        }
    }else if(checkname=="IsSubmitForward"){ //办结转发(Z)
        if(ischeck){
			 $("input[name=IsBeForwardSubmitNotaries]").trigger("disabled",false);
			$("input[name=IsBeForwardSubmitNotaries]").trigger("checked",true);
        	 $("input[name=IsBeForward]").trigger("disabled",false);
         }else{
			$("input[name=IsBeForwardSubmitNotaries]").trigger("checked",false);
        	$("input[name=IsBeForwardSubmitNotaries]").trigger("disabled",true);        	
         	$("input[name=IsBeForward]").trigger("checked",false);
        	$("input[name=IsBeForward]").trigger("disabled",true);      	

        }
    }
	
	changejNiceClass(disabledList,undisabledList,checkList,uncheckList);		
}


<%if(src.equals("save")){	%>
		closeWindow();
<%}%>

function closeWindow(){
	var design="<%=design %>";
	if(design=='1'){	//流程图编辑界面打开
		//window.parent.design_callback('showNodeAttrOperate_<%=Util.null2String(request.getParameter("setType")) %>','<%=hassetting%>');
		var parentWin = parent.getParentWindow(window);
		parentWin.design_callback('showNodeAttrOperate_<%=Util.null2String(request.getParameter("setType")) %>','<%=hassetting%>','<%=needSyncNodes %>');
	}
	dialog.close();
}

function FeedbackChange(obj,id){
    if(obj.checked){
        showEle("trfreeback");
        $("#"+id).removeAttr("disabled");
    }else{
   		$("#"+id).attr("disabled","disabled");
        hideEle("trfreeback");
    }
}

function issignmustinputChanged() {
	if (jQuery('#issignmustinput').val() > 0) {
		jQuery('.ishideinput').parent().parent().hide();
		jQuery('#ishideinput').removeAttr('checked');
		jQuery('#ishideinput').next('span.tzCheckBox').removeClass('checked');
	} else {
		jQuery('.ishideinput').parent().parent().show();
	}
}


function ishideinputChanged() {
	if (jQuery('#ishideinput').is(':checked')) {
		jQuery('#issignmustinput').parent().parent().hide();
		//jQuery('#issignmustinput').removeAttr('checked');
		//jQuery('#issignmustinput').next('span.tzCheckBox').removeClass('checked');
		jQuery("#issignmustinput").selectbox("detach");
		jQuery("#issignmustinput").val("0").change();
		beautySelect(jQuery("#issignmustinput"));
		hideEle("isFormSignature");
	} else {
		jQuery('#issignmustinput').parent().parent().show();
		showEle("isFormSignature");
	}
}

function ishideareaChanged(){
	if (jQuery('#ishidearea').is(':checked')){
	    $("#viewnodenames").attr("disabled","disabled");
   		$("#viewnodeids").attr("disabled","disabled");
		hideEle("trsignfields");
		hideEle("trnotseeeachother");
	} else {
	    $("#viewnodenames").removeAttr("disabled");
   		$("#viewnodeids").removeAttr("disabled");
		showEle("trsignfields");
		<%if(nodetype != 3){%>
		showEle("trnotseeeachother");
		<%}%>
	}
}

function onShowBrowser(url) {
	var dialog = new window.top.Dialog();
    dialog.currentWindow = window;
    dialog.callbackfunParam = null;
    dialog.URL = "/systeminfo/BrowserMain.jsp?url="+url;
    dialog.callbackfun = function (paramobj, id1) {
        if (id1) {
            if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
                var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
                var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
                var sHtml = "";
                resourceids = resourceids.substr(0);
                resourcename = resourcename.substr(0);
               	$G("viewnodeids").value=resourceids;
	        	$G("viewnodenames").value=resourcename;
            } else {
                $G("viewnodeids").value="";
	    		$G("viewnodenames").value="";
            }
        }
    } ;
    dialog.Title = "<%=SystemEnv.getHtmlLabelName(81579, user.getLanguage())%>";
    dialog.Height = 400 ;
    dialog.Drag = true;
    dialog.show();
}
function issubwfAllEndChange(me){
	var currentTr = jQuery(me).parent().parent();
	var nextTr1 = jQuery(currentTr).next();
	var nextTr2 = jQuery(nextTr1).next();

	var subwfscope = jQuery("#subwfscope").val();
	if( jQuery(me).attr('checked') ){
		showEle("issubwfremindAtt");
	
		jQuery(nextTr1).show();
		jQuery(nextTr2).show();
		if(subwfscope != null && subwfscope != ""){
			showEle("itemShowSub");
		}else{
			hideEle("itemShowSub");
		}
	}else{
		jQuery(nextTr1).hide();
		jQuery(nextTr2).hide();
		hideEle("itemShowSub");
		hideEle("issubwfremindAtt");
		
	}
}

function subProcessSummaryChange(me){
	var currentTr = jQuery(me).parent().parent();

	if( jQuery(me).attr('checked') ){
		jQuery("#subProcessData").show();
	}else{
		jQuery("#subProcessData").hide();
	}
}

function editWFSubList(){
	if(<%=promptdiv%>){
		var subwfscope = jQuery("#subwfscope").val();
		var dialog = new window.top.Dialog();
		 dialog.currentWindow = window;
		var url = "/workflow/workflow/wfSubProcessList.jsp?wfid=<%=wfid%>&nodeid=<%=nodeid%>&subwfscope="+subwfscope;
		dialog.URL = url;
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(125343,user.getLanguage())%>";
		dialog.Width = 850;
		dialog.Height = 650;
		dialog.normalDialog = false;
		dialog.Drag = true;
		dialog.show();
	}else{
		top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(125882, user.getLanguage())%>');
		return false;
	}
}

function issubwfremindChange(me){
	var currentTr = jQuery(me).parent().parent();
	var nextTr1 = jQuery(currentTr).next();
	var nextTr2 = jQuery(nextTr1).next();
	var nextTr3 = jQuery(nextTr2).next();
	var nextTr4 = jQuery(nextTr3).next();

	if( jQuery(me).attr('checked') ){
		jQuery(nextTr1).show();
		jQuery(nextTr2).show();
		jQuery(nextTr3).show();
		jQuery(nextTr4).show();
	}else{
		jQuery(nextTr1).hide();
		jQuery(nextTr2).hide();
		jQuery(nextTr3).hide();
		jQuery(nextTr4).hide();

		jQuery(nextTr2).find('[type=checkbox]').each(function(i, v){
			jQuery(v).removeAttr('checked');
			jQuery(v).next().attr('class', 'tzCheckBox');
		});
		jQuery(nextTr4).find('[type=checkbox]').each(function(i, v){
			jQuery(v).removeAttr('checked');
			jQuery(v).next().attr('class', 'tzCheckBox');
		});
	    _writeBackData('subwfremindperson', 2, {id:'',name:''});
	}
}

function subwfremindobjectChange(me){
	if( jQuery(me).attr('checked') ){
		jQuery('#hrmResourceSpan').show();
	}else{
		jQuery('#hrmResourceSpan').hide();
		 _writeBackData('subwfremindperson', 2, {id:'',name:''});
	}
}

function checkSubWorkflow() {
	if (jQuery('#issubwfAllEnd').is(':checked')) {
		if (!jQuery('#subwfscope').val()) {
			top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(30933, user.getLanguage())%>');
			return false;
		}
	}
	if (jQuery('#issubwfremind').is(':checked')) {
		if (!jQuery('#subwfremindtype_sys').is(':checked') && !jQuery('#subwfremindtype_ml').is(':checked') && !jQuery('#subwfremindtype_sm').is(':checked')) {
			top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(32807, user.getLanguage())%>');
			return false;
		}
		if (!jQuery('#subwfremindoperator').is(':checked') && !jQuery('#subwfremindobject').is(':checked')) {
			top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(32808, user.getLanguage())%>');
			return false;
		}
		if (jQuery('#subwfremindobject').is(':checked')) {
			if (!jQuery('#subwfremindperson').val()) {
				top.Dialog.alert('<%=SystemEnv.getHtmlLabelName(30933, user.getLanguage())%>');
				return false;
			}
		}
	}
	return true;
}

function subwfscopeBrowser() {
	var url = '/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowSubwfSetBrowser.jsp';
	var param = '?wfid=<%=wfid%>&selectedids=';
	var input = $G('subwfscope');
	var span = $G('subwfscopespan');
	var subwfscopeCallback = function(data) {
		var id = data.id;
		if (!!id && id.indexOf(',') == 0) {
			id = id.substring(1);
		}
		jQuery(input).val(id);
		if (!!id) {
			jQuery(span).html('<img border="0" width="16" height="17" src="/images/ecology8/checkright_wev8.png">');
			showEle("itemShowSub");
		} else {
			jQuery(span).html('<img align="absmiddle" src="/images/BacoError_wev8.gif">');
			hideEle("itemShowSub");
		}
	};
	onShowCommonDialogWindow(input, span, url, param, '<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>', null, null, subwfscopeCallback);
}

function toShowGroup(obj){
	var isChecked = obj.checked;
	if(isChecked){
		 showEle("itemShow1");
	 }else{
		 hideEle("itemShow1");
	}
}

function toShowGroup3(obj){
	var isChecked = obj.checked;
	if(isChecked){
		 showEle("itemShow3");

	}else{
		 hideEle("itemShow3");
	}
}
function toShowGroup2(obj){
	var isChecked = obj.checked;
	if(isChecked){
	  showEle("itemShow2");

	}else{
	  hideEle("itemShow2");
	}
}



jQuery(document).ready(function($){
	issubwfAllEndChange( '#issubwfAllEnd' );
	issubwfremindChange( '#issubwfremind' );
	subwfremindobjectChange( '#subwfremindobject');
});

/* 流转异常设置JS */
<%if("exceptionhandle".equals(settype)){ %>
jQuery(document).ready(function(){
	controlSubmitNodesImg();
	jQuery("[name='exceptionHandleWay']").click(function(){
		controlSubmitNodesImg();
		var synObj = jQuery("[name='isSynExceptionHandle']");
		if(jQuery(this).val() === "2"){
			synObj.attr("disabled",true).attr("checked",false).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled");
		}else{
			synObj.attr("disabled",false).next().removeClass("jNiceCheckbox_disabled").addClass("jNiceCheckbox");
		}
	});
});
<%} %>

function switchShowHandleWay(obj){
	if(obj.checked){
    	showEle("exceptiondiv");
    }else{
        hideEle("exceptiondiv");
    }
}

function controlSubmitNodesImg(){
	var submitnodeimg = jQuery("span#flowToAssignNodespanimg").find("img");
	if(submitnodeimg.size() >0){
		submitnodeimg.hide();
		if(jQuery("input:checked[name='exceptionHandleWay']").val() == "2"){
			if(jQuery("input[name='flowToAssignNode']").val() == "")
				submitnodeimg.show();
		}
	}
}

function getSubmitNodesUrlFun(){
    return "/systeminfo/BrowserMain.jsp?url=/workflow/request/SubmitNodeSet.jsp?fromWhere=exceptionHandle&workflowid=<%=wfid %>&nodeid=<%=nodeid %>";
}

function callbackSubmitNodesBrowser(event,datas,name,paras){
	if(datas.id != ""){
		var synObj = jQuery("[name='isSynExceptionHandle']");
		jQuery("input[name='exceptionHandleWay']").each(function(){
			if($(this).val() == "2"){
				synObj.attr("disabled",true).attr("checked",false).next().removeClass("jNiceCheckbox").removeClass("jNiceChecked").addClass("jNiceCheckbox_disabled");
				$(this).attr("checked",true).next().addClass("jNiceChecked");
			}else{
				$(this).attr("checked",false).next().removeClass("jNiceChecked");
			}
		});
	}else{		//清除
		window.setTimeout(controlSubmitNodesImg, 100);
	}
}

function onShowCommonDialogWindow(input, span, url, param, title, width, height, callback) {
	if (!title) {
		title = '<%=SystemEnv.getHtmlLabelName(18214, user.getLanguage())%>';
	}
	if (!width) {
		width = 600;
	}
	if (!height) {
		height = 600;
	}
	if (param && /=$/.test(param)) {
		param += jQuery(input).val();
	}
	var browserDialog = new top.Dialog();
	browserDialog.Width = width;
	browserDialog.Height = height;
	browserDialog.URL = url + escape(param);
	browserDialog.Title = title;
	browserDialog.checkDataChange = false;
	browserDialog.callback = function(data) {
		browserDialog.close();
		if (typeof(callback) === 'function') {
			callback(data);
		} else {
			var id = data.id;
			if (!!id && id.indexOf(',') == 0) {
				id = id.substring(1);
			}
			jQuery(input).val(id);
			var name = data.name;
			if (!!name && name.indexOf(',') == 0) {
				name = name.substring(1);
			}
			jQuery(span).html(name);
		}
	};
	browserDialog.show();
}

function setFormSignatureConfig(){
    var diag_vote;
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 850;
	diag_vote.Height = 800;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelNames("21750,68",user.getLanguage()) %>";
	diag_vote.URL = "/odoc/workflow/workflow/setFormSignatureConfig.jsp?workflowId=<%=wfid %>&nodeId=<%=nodeid %>";
	diag_vote.show();
}


</script>
