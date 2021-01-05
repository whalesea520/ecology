
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.request.WFPathUtil"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.conn.*" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page import="java.net.URLEncoder" %>
<jsp:useBean id="RecordSetlog3" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_fna" class="weaver.conn.RecordSet" scope="page" />
<%-- added by xwj for td2891--%>
<%@page import = "weaver.general.TimeUtil"%>
<%@ page import="weaver.workflow.request.ComparatorUtilBean"%>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="java.util.Hashtable" %>
<%@ page import="weaver.general.BaseBean" %>

<%@ page import="java.util.*" %>
<%@ page import="weaver.hrm.*" %>
<%@ page import="weaver.systeminfo.*" %>
<%@ page import="weaver.general.*" %>
<%@ page import="ln.LN"%>
<%@ page import="weaver.hrm.settings.RemindSettings" %>
<%@ page import="org.apache.commons.logging.Log"%>
<%@ page import="org.apache.commons.logging.LogFactory"%>
<%@ page import="weaver.workflow.workflow.TestWorkflowCheck" %>
<%@ page import="weaver.systeminfo.template.UserTemplate"%>
<%@ page import="weaver.systeminfo.setting.*" %>

<jsp:useBean id="WFLinkInfo" class="weaver.workflow.request.WFLinkInfo" scope="page" />
<jsp:useBean id="RequestDefaultComInfo" class="weaver.system.RequestDefaultComInfo" scope="page" />
<jsp:useBean id="FieldInfo" class="weaver.workflow.mode.FieldInfo" scope="page" />
<!--added by xwj for td2891-->
<jsp:useBean id="rsCheckUserCreater" class="weaver.conn.RecordSet" scope="page" />
<%-- added by xwj for td2891--%>
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="rssign" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RequestSignatureManager" class="weaver.workflow.request.RequestSignatureManager" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="RecordSetLog" class="weaver.conn.RecordSet" scope="page" />
<%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog1" class="weaver.conn.RecordSet" scope="page" />
<%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog2" class="weaver.conn.RecordSet" scope="page" />
<%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="requestNodeFlow" class="weaver.workflow.request.RequestNodeFlow" scope="page" />
<jsp:useBean id="RequestUseTempletManager" class="weaver.workflow.request.RequestUseTempletManager" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="RequestLogOperateName" class="weaver.workflow.request.RequestLogOperateName" scope="page"/>
<jsp:useBean id="shareManager" class="weaver.share.ShareManager" scope="page" />
<jsp:useBean id="TexttoPDFManager" class="weaver.workflow.request.TexttoPDFManager" scope="page" />
<jsp:useBean id="rs_meeting" class="weaver.conn.RecordSet" scope="page" />
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>


<script type="text/javascript" src="/js/ecology8/weaverautocomplete/weaverautocomplete_wev8.js"></script>

<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<!-- 这里需要引入工作流专用的文件上传js，否则没有对工作流做特殊处理的内容 -->
<script type="text/javascript" src="/js/swfupload/fileprogressBywf_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/workflowshowpaperchange_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/css/ecology8/request_wev8.css" />
<script type="text/javascript" src="/js/odoc/common/commonjs.js"></script>
<!-- 
<link type="text/css" rel="stylesheet" href="/js/ecology8/weaverautocomplete/css/weaverautocomplete_wev8.css">
<link rel="stylesheet" type="text/css" href="/wui/common/js/ckeditor/skins/kama/editor1_wev8.css" />
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowshow_wev8.css" />
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowcop_wev8.css" />

<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />
 -->
<%

FileUpload fu = new FileUpload(request);
String f_weaver_belongto_userid=fu.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=fu.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();                   //当前用户id
//System.out.println("-ms1-userid-89--==================="+userid);
int requestid = Util.getIntValue(request.getParameter("requestid"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
String nodetype= Util.null2String(request.getParameter("nodetype"));
String isremark=Util.null2String(request.getParameter("isremark"));
String isOldWf=Util.null2String(request.getParameter("isOldWf"));
String topage = Util.null2String(request.getParameter("topage")) ;        //返回的页面

String newReportUserId=Util.null2String(request.getParameter("newReportUserId"));
String newCrmId=Util.null2String(request.getParameter("newCrmId"));
boolean isOldWf_ = false;
if(isOldWf.trim().equals("true")) isOldWf_=true;
String creatername="";               //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
String username = "";

if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());
int workflowid=Util.getIntValue(request.getParameter("workflowid"),0);           //工作流id
String currentdate= Util.null2String(request.getParameter("currentdate"));
String currenttime= Util.null2String(request.getParameter("currenttime"));
String needcheck= "";
int usertype_wfvwt = user.getLogintype().equals("1")?0:1;

/**流程存为文档是否要签字意见**/
boolean fromworkflowtodoc = Util.null2String((String)session.getAttribute("urlfrom_workflowtodoc_"+requestid)).equals("true");
boolean ReservationSign = false;
RecordSet.executeSql("select * from workflow_base where id = " + workflowid);
if(RecordSet.next()) ReservationSign = (RecordSet.getInt("keepsign")==2);
if(fromworkflowtodoc&&ReservationSign){
	return;
}

/**检查是否为会议流程**/
boolean isMeetingWf=false;
rs_meeting.execute("select wb.custompage,wb.custompage4Emoble from workflow_base wb join meeting_bill mb on mb.billid=wb.formid where mb.billid<>85 and mb.defined=1 and wb.id="+workflowid);
if(rs_meeting.next()){
	isMeetingWf=true;
}

/**检查是否是启用的费控流程  开始**/
boolean isFnaWf = false;
boolean isEnableFnaWf = false;
String sqlFnaWfSet = "select a.enable from fnaFeeWfInfo a where a.workflowid = "+workflowid;
rs_fna.executeSql(sqlFnaWfSet);
if(rs_fna.next()){
	isFnaWf = true;
	if(rs_fna.getInt("enable") == 1){
		isEnableFnaWf = true;
	}
}
String ecology7_FnaWfIds = Util.null2String(new String(Util.null2String(new BaseBean().getPropValue("Ecology7_FnaWf", "ecology7_FnaWfIds")).getBytes("ISO-8859-1"), "gbk")).trim();
boolean haveWorkflowBaseCustompage = false;
if((","+ecology7_FnaWfIds+",").indexOf(","+workflowid+",") >= 0 && workflowid > 0){
	haveWorkflowBaseCustompage = true;
}
/**检查是否是启用的费控流程  结束**/
%>
<jsp:include page="WorkflowViewWT.jsp" flush="true">
	<jsp:param name="requestid" value="<%=requestid%>" />
	<jsp:param name="userid" value="<%=user.getUID()%>" />
	<jsp:param name="usertype" value="<%=usertype_wfvwt%>" />
	<jsp:param name="languageid" value="<%=user.getLanguage()%>" />
</jsp:include>
<%

String isSignMustInput="0";
String isHideInput="0";
rssign.execute("select issignmustinput,ishideinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(rssign.next()){
	isSignMustInput = ""+Util.getIntValue(rssign.getString("issignmustinput"), 0);
	isHideInput = ""+Util.getIntValue(rssign.getString("ishideinput"), 0);
}

String needconfirm="";
String isannexupload_edit="";
String annexdocCategory_edit="";
String isSignDoc_edit="";
String isSignWorkflow_edit="";
String showDocTab_edit="";
String showWorkflowTab_edit="";
String showUploadTab_edit="";
RecordSetLog.execute("select needAffirmance,isannexupload,annexdocCategory,isSignDoc,isSignWorkflow,showDocTab,showWorkflowTab,showUploadTab,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSetLog.next()){
    needconfirm=Util.null2o(RecordSetLog.getString("needAffirmance"));
    isannexupload_edit=Util.null2String(RecordSetLog.getString("isannexupload"));
    annexdocCategory_edit=Util.null2String(RecordSetLog.getString("annexdocCategory"));
    isSignDoc_edit=Util.null2String(RecordSetLog.getString("isSignDoc"));
    isSignWorkflow_edit=Util.null2String(RecordSetLog.getString("isSignWorkflow"));
    showDocTab_edit=Util.null2String(RecordSetLog.getString("showDocTab"));
    showWorkflowTab_edit=Util.null2String(RecordSetLog.getString("showWorkflowTab"));
    showUploadTab_edit=Util.null2String(RecordSetLog.getString("showUploadTab"));
}

    String billtablename = "";
    int operatorsize = 0;
    int formid=Util.getIntValue(request.getParameter("formid"),0);
    int isbill=Util.getIntValue(request.getParameter("isbill"),0);
    int billid=Util.getIntValue(request.getParameter("billid"),0);
    int creater = Util.getIntValue(request.getParameter("creater"),0);
    int creatertype =Util.getIntValue(request.getParameter("creatertype"),0);

//TD4262 增加提示信息  开始

    String ismode= Util.null2String(request.getParameter("ismode"));
//TD4262 增加提示信息  结束
    String  fromFlowDoc=Util.null2String(request.getParameter("fromFlowDoc"));  //是否从流程创建文档而来
    String isworkflowdoc = Util.getIntValue(request.getParameter("isworkflowdoc"),0)+"";//是否为公文


    int usertype = (user.getLogintype()).equals("1") ? 0 : 1;
    //creatername=ResourceComInfo.getResourcename(""+creater);
	if(creatertype==1){  
		creatername=CustomerInfoComInfo.getCustomerInfoname(""+creater);
	}else{
		creatername=ResourceComInfo.getResourcename(""+creater);
	}
    boolean hasnextnodeoperator = false;
    Hashtable operatorsht = new Hashtable();
    String intervenoruserids="";
	String intervenoruseridsType="";
    String intervenorusernames="";
    int nextnodeid=nodeid;
    
    
    String operationpage = "";
    if(isbill == 1){
	    RecordSet.executeProc("bill_includepages_SelectByID",formid+"");
	    if(RecordSet.next()) {
	        operationpage = Util.null2String(RecordSet.getString("operationpage"));
	    }
    }
if(isremark.equals("5")){
if (isbill == 1) {
			RecordSet.executeSql("select tablename from workflow_bill where id = " + formid); // 查询工作流单据表的信息

			if (RecordSet.next())
				billtablename = RecordSet.getString("tablename");          // 获得单据的主表

}
//查询节点操作者

        requestNodeFlow.setRequestid(requestid);
		requestNodeFlow.setNodeid(nodeid);
		requestNodeFlow.setNodetype(nodetype);
		requestNodeFlow.setWorkflowid(workflowid);
		requestNodeFlow.setUserid(userid);
		requestNodeFlow.setUsertype(usertype);
		requestNodeFlow.setCreaterid(creater);
		requestNodeFlow.setCreatertype(creatertype);
		requestNodeFlow.setIsbill(isbill);
		requestNodeFlow.setBillid(billid);
		requestNodeFlow.setBilltablename(billtablename);
		requestNodeFlow.setRecordSet(RecordSet);
		hasnextnodeoperator = requestNodeFlow.getNextNodeOperator();

		if(hasnextnodeoperator){
			operatorsht = requestNodeFlow.getOperators();
            nextnodeid=requestNodeFlow.getNextNodeid();
            operatorsize = operatorsht.size();
            if(operatorsize > 0){

                TreeMap map = new TreeMap(new ComparatorUtilBean());
				Enumeration tempKeys = operatorsht.keys();
				try{
				while (tempKeys.hasMoreElements()) {
					String tempKey = (String) tempKeys.nextElement();
					ArrayList tempoperators = (ArrayList) operatorsht.get(tempKey);
					map.put(tempKey,tempoperators);
				}
				}catch(Exception e){}
				Iterator iterator = map.keySet().iterator();
				while(iterator.hasNext()) {
				String operatorgroup = (String) iterator.next();
				ArrayList operators = (ArrayList) operatorsht.get(operatorgroup);
				for (int i = 0; i < operators.size(); i++) {
				    String operatorandtype = (String) operators.get(i);
						String[] operatorandtypes = Util.TokenizerString2(operatorandtype, "_");
						String opertor = operatorandtypes[0];
						String opertortype = operatorandtypes[1];
						String opertorsigntype = operatorandtypes[3];
						if(opertorsigntype.equals("-3")||opertorsigntype.equals("-4")) continue;
                        intervenoruserids+=opertor+",";
						intervenoruseridsType +=opertortype+",";
                        if("0".equals(opertortype)){
						intervenorusernames += "<A href='javaScript:openhrm("+opertor+");' onclick='pointerXY(event);'>"+ResourceComInfo.getResourcename(opertor)+"</A>&nbsp;";
						}else{
						intervenorusernames += CustomerInfoComInfo.getCustomerInfoname(opertor)+" ";
						}

				}
                }
        }
        }
    if(intervenoruserids.length()>1){
        intervenoruserids=intervenoruserids.substring(0,intervenoruserids.length()-1);
		intervenoruseridsType=intervenoruseridsType.substring(0,intervenoruseridsType.length()-1);
    }
    needcheck+=",Intervenorid";
    if(isremark.equals("5"))  needcheck="";
%>
<iframe id="workflownextoperatorfrm" frameborder=0 scrolling=no src=""  style="display:none;"></iframe>
<%}
%>
<!--TD4262 增加提示信息  开始-->
<%
    if(ismode.equals("1")){
%>
<div id="divFavContent16332" style="display:none">
    <!--工作流信息保存错误-->
    <table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
        <tr height="22">
            <td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(16332,user.getLanguage())%></td>
        </tr>
    </table>
</div>
<div id="divFavContent16333" style="display:none">
    <!--工作流下一节点或下一节点操作者错误-->
    <table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
        <tr height="22">
            <td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(16333,user.getLanguage())%></td>
        </tr>
    </table>
</div>
<div id="divFavContent18978" style="display:none">
    <!--正在提交流程，请稍等....-->
    <table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
        <tr height="22">
            <td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%></td>
        </tr>
    </table>
</div>
<div id="divFavContent18979" style="display:none">
    <!--正在保存流程，请稍等....-->
    <table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
        <tr height="22">
            <td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%></td>
        </tr>
    </table>
</div>
<div id="divFavContent18980" style="display:none">
    <!--正在退回流程，请稍等....-->
    <table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
        <tr height="22">
            <td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18980,user.getLanguage())%></td>
        </tr>
    </table>
</div>
<div id="divFavContent18984" style="display:none">
    <!--正在删除流程，请稍等....-->
    <table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
        <tr height="22">
            <td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18984,user.getLanguage())%></td>
        </tr>
    </table>
</div>
<%
    }else{
%>
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%;display:none' valign='top'> </div>
<%
    }
%>
<!--TD4262 增加提示信息  结束-->
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%;display:none' valign='top'> </div>
<iframe id="checkReportDataForm" frameborder=0 scrolling=no src="javascript:false"  style="display:none"></iframe>
<iframe id="showtipsinfoiframe" name="showtipsinfoiframe" frameborder=0 scrolling=no src="javascript:false"  style="display:none"></iframe>
<input type=hidden name="divcontent" value="">
<input type=hidden name="content" value="">
<!--
<table width="100%">
<tr>
<td width="50%"  valign="top">-->
<input type=hidden name="isremark" value="<%=isremark%>">
<!-- added by pony on 2006-05-11 for TD4264 begin -->
<input type=hidden name="requestid" value="<%=requestid%>">
<input type=hidden name="nodeid" value="<%=nodeid%>">
<input type=hidden name="nodetype" value="<%=nodetype%>">
<input type=hidden name="workflowid" value="<%=workflowid%>">
<input type=hidden name="currentdate" value="<%=currentdate%>">
<input type=hidden name="currenttime" value="<%=currenttime%>">
<input type=hidden name="formid" value="<%=formid%>">
<input type=hidden name="isbill" value="<%=isbill%>">
<input type=hidden name="billid" value="<%=billid%>">
<input type=hidden name="creater" value="<%=creater%>">
<input type=hidden name="creatertype" value="<%=creatertype%>">
<input type=hidden name="ismode" value="<%=ismode%>">
<input type=hidden name="workflowRequestLogId" value="-1">
<input type=hidden name="RejectNodes" value="">
<input type=hidden name="RejectToNodeid" value="">
<input type=hidden name="RejectToType" id='RejectToType' value="0">
<input type=hidden name="SubmitToNodeid" value="">

<!--流程干预信息-->
<%if(isremark.equals("5")){%>
<table>
    <!-- modify by xhheng @20050308 for TD 1692 -->
    <COLGROUP>
    <COL width="20%">
    <COL width="80%">
    <tr>
        <td colspan="2"><b><%=SystemEnv.getHtmlLabelName(18913,user.getLanguage())%></b></td>
    </tr>
    <TR class=spacing>
        <TD class=line1 colSpan=2></TD>
    </TR>
    <tr>
        <td><%=SystemEnv.getHtmlLabelName(18914,user.getLanguage())%></td>
        <td class=field>
            <select class=inputstyle  id="submitNodeId" name=submitNodeId  onChange='nodechange(this.value)'>
                <%
                 WFNodeMainManager.setWfid(workflowid);
                 WFNodeMainManager.selectWfNode();
                 while(WFNodeMainManager.next()){
                    int tmpid = WFNodeMainManager.getNodeid();
                    if(tmpid==nodeid) continue;
                    String tmpname = WFNodeMainManager.getNodename();
                    String tmptype = WFNodeMainManager.getNodetype();
                 %>
                <option value="<%=tmpid%>_<%=tmptype%>" <%if(nextnodeid==tmpid){%>selected<%}%>><%=tmpname%></option>
                <%}%>
            </select>
        </td>
    </tr>
    <TR class=spacing  style="height:1px;">
        <TD class=line2 colSpan=2></TD>
    </TR>
    <tr>
        <td><%=SystemEnv.getHtmlLabelName(18915,user.getLanguage())%></td>
        <td class=field><span id="Intervenoridspan">
            <%if(intervenoruserids.equals("")){%>
            <button type=button  class=Browser onclick="onShowMutiHrm('Intervenoridspan','Intervenorid')" ></button>
            <%}%>
            <%=intervenorusernames%>
            <%if(intervenorusernames.equals("")){%>
            <img src='/images/BacoError_wev8.gif' align=absmiddle>
            <%}%>
            </span>
            <input type=hidden name="IntervenoridType" value="<%=intervenoruseridsType%>">
            <input type=hidden name="Intervenorid" id="Intervenorid" value="<%=intervenoruserids%>">
        </td>
    </tr>
    <TR class=spacing  style="height:1px;">
        <TD class=line2 colSpan=2></TD>
    </TR>
</table>
<%}%>


<%
         boolean IsBeForwardCanSubmitOpinion="true".equals(session.getAttribute(userid+"_"+requestid+"IsBeForwardCanSubmitOpinion"))?true:false;
         rssign.execute("select isview from workflow_nodeform where fieldid=-4 and nodeid="+nodeid);
		 int isview_ = 0;
		 if(rssign.next()){
			isview_ = Util.getIntValue(rssign.getString("isview"), 0);
		 }
         String isFormSignature=null;
         
         int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
         int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
         RecordSet.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight  from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
         if(RecordSet.next()){
         	isFormSignature = Util.null2String(RecordSet.getString("isFormSignature"));
         	formSignatureWidth= Util.getIntValue(RecordSet.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
         	formSignatureHeight= Util.getIntValue(RecordSet.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
         }
         int isUseWebRevision_t = Util.getIntValue(new weaver.general.BaseBean().getPropValue("weaver_iWebRevision","isUseWebRevision"), 0);
         if(isUseWebRevision_t != 1){
         	isFormSignature = "";
         }
         
         //html模式下，如果签字意见在模板中显示，此处则不显示

	  Boolean hasRemark = true;
	 try{
		hasRemark = (Boolean)session.getAttribute("req_"+requestid+"_"+nodeid+"_"+userid);
	 }catch(Exception e){
		 hasRemark = true;
	 }
	 if(hasRemark==null)hasRemark = true;
         if(IsBeForwardCanSubmitOpinion && (!"2".equals(ismode) || isview_!=1 || (isview_==1 && isremark.equals("5")) || !hasRemark)){
		session.removeAttribute("req_"+requestid+"_"+nodeid+"_"+userid);
        int annexmainId=0;
         int annexsubId=0;
         int annexsecId=0;

         if("1".equals(isannexupload_edit) && annexdocCategory_edit!=null && !annexdocCategory_edit.equals("")){
            annexmainId=Util.getIntValue(annexdocCategory_edit.substring(0,annexdocCategory_edit.indexOf(',')));
            annexsubId=Util.getIntValue(annexdocCategory_edit.substring(annexdocCategory_edit.indexOf(',')+1,annexdocCategory_edit.lastIndexOf(',')));
            annexsecId=Util.getIntValue(annexdocCategory_edit.substring(annexdocCategory_edit.lastIndexOf(',')+1));
          }
         int annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
         if(annexmaxUploadImageSize<=0){
            annexmaxUploadImageSize = 5;
         }
         char flag1 = Util.getSeparator();
         RecordSet.executeProc("workflow_RequestLog_SBUser",""+requestid+flag1+""+userid+flag1+""+usertype+flag1+"1");
         String myremark = "" ;
         String annexdocids = "" ;
         String signdocids="";
         String signworkflowids="";
		 int workflowRequestLogId=-1;
         if(RecordSet.next()){
            myremark = Util.null2String(RecordSet.getString("remark"));
            annexdocids=Util.null2String(RecordSet.getString("annexdocids"));
			workflowRequestLogId=Util.getIntValue(RecordSet.getString("requestLogId"),-1);
			signdocids=Util.null2String(RecordSet.getString("signdocids"));
			signworkflowids=Util.null2String(RecordSet.getString("signworkflowids"));
         }
         String signdocname="";
        String signworkflowname="";
        ArrayList templist=Util.TokenizerString(signdocids,",");
        for(int i=0;i<templist.size();i++){
            signdocname+="<a href='/docs/docs/DocDsp.jsp?isrequest=1&id="+templist.get(i)+"' target='_blank'>"+docinf.getDocname((String)templist.get(i))+"</a> ";
        }
        templist=Util.TokenizerString(signworkflowids,",");
        int tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
        for(int i=0;i<templist.size();i++){
                tempnum++;
                session.setAttribute("resrequestid" + tempnum, "" + templist.get(i));
            signworkflowname+="<a style=\"cursor:pointer\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&isrequest=1&requestid="+templist.get(i)+"&wflinkno="+tempnum+"')\">"+wfrequestcominfo.getRequestName((String)templist.get(i))+"</a> ";
        }
        session.setAttribute("slinkwfnum", "" + tempnum);
        session.setAttribute("haslinkworkflow", "1");


         //String workflowPhrases[] = WorkflowPhrase.getUserWorkflowPhrase(""+userid);
        //add by cyril on 2008-09-30 for td:9014
   		boolean isSuccess  = RecordSet.executeProc("sysPhrase_selectByHrmId",""+userid); 
   		String workflowPhrases[] = new String[RecordSet.getCounts()];
   		String workflowPhrasesContent[] = new String[RecordSet.getCounts()];
   		int x = 0 ;
   		if (isSuccess) {
   			while (RecordSet.next()){
   				workflowPhrases[x] = Util.null2String(RecordSet.getString("phraseShort"));
   				workflowPhrasesContent[x] = Util.toHtml(Util.null2String(RecordSet.getString("phrasedesc")));
   				x ++ ;
   			}
   		}
   		//end by cyril on 2008-09-30 for td:9014
         /*----------xwj for td3034 20051118 begin ------*/
         %>
         
         <%@ include file="/workflow/request/WorkflowSignInput.jsp" %>
<!-- 
        </tr>
        <tr style="height:1px;">
            <td class=Line2 colSpan=2></td>
        </tr>
         -->
        <%
}else{ 
	 String workflowRequestLogId = "";
		String signdocids = "";
		String signdocname = "";
		String signworkflowids = "";
		String signworkflowname = "";
		
		String annexdocids = "";
		String fieldannexuploadname = "";
		char flag1 = Util.getSeparator();
		RecordSet.executeProc("workflow_RequestLog_SBUser",""+requestid+flag1+""+userid+flag1+""+usertype+flag1+"1");
		//RecordSet.executeProc("workflow_RequestLog_SBUser",""+requestid+flag1+""+userid+flag1+""+user.getType()+flag1+"1");

        if(RecordSet.next()){
            annexdocids=Util.null2String(RecordSet.getString("annexdocids"));
			signdocids=Util.null2String(RecordSet.getString("signdocids"));
			signworkflowids=Util.null2String(RecordSet.getString("signworkflowids"));
        }
        //System.out.println("annexdocids = " + annexdocids);
        DocImageManager docImageManager = new DocImageManager();
        if(!annexdocids.equals("") && annexdocids != null){
        	String annexdocidsarray[]=Util.TokenizerString2(annexdocids,",");
        	for(String annexid:annexdocidsarray){
        		docImageManager.resetParameter();
        	    docImageManager.setDocid(Integer.parseInt(annexid));
        	    docImageManager.selectDocImageInfo();  
        	    if (docImageManager.next()) {
	        	    if(fieldannexuploadname.equals("")){
	        			fieldannexuploadname = docImageManager.getImagefilename();
	        		}else{
	        			fieldannexuploadname += "////~~weaversplit~~////"+docImageManager.getImagefilename();
	        		}
        	    }
        	}
        }
       // System.out.println("fieldannexuploadname = " + fieldannexuploadname);
        //out.println("annexdocids:"+annexdocids+" signdocids:"+signdocids+" signworkflowids:"+signworkflowids);
		String myremark = "";
		int annexmainId=0;
	    int annexsubId=0;
	    int annexsecId=0;
	    int annexmaxUploadImageSize = 0;
		if("1".equals(isannexupload_edit)){
			RecordSetLog.execute("select annexdocCategory from workflow_base where id="+workflowid);
	        //String annexdocCategory_add=(String)session.getAttribute(userid+"_"+workflowid+"annexdocCategory");
	        String annexdocCategory_add = "";
	        if(RecordSetLog.next()){
	        	annexdocCategory_add = Util.null2String(RecordSetLog.getString("annexdocCategory"));
	        }
		    //out.println("isannexupload_edit:"+isannexupload_edit+" annexdocCategory_add:"+annexdocCategory_add); 
	        if("1".equals(isannexupload_edit) && annexdocCategory_add!=null && !annexdocCategory_add.equals("")){
	            annexmainId=Util.getIntValue(annexdocCategory_add.substring(0,annexdocCategory_add.indexOf(',')));
	            annexsubId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.indexOf(',')+1,annexdocCategory_add.lastIndexOf(',')));
	            annexsecId=Util.getIntValue(annexdocCategory_add.substring(annexdocCategory_add.lastIndexOf(',')+1));
	          }
	         annexmaxUploadImageSize=Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+annexsecId),5);
	         if(annexmaxUploadImageSize<=0){
	            annexmaxUploadImageSize = 5;
	         }
	     }
		
		
		boolean isSuccess  = RecordSetLog.executeProc("sysPhrase_selectByHrmId",""+userid);
		String workflowPhrases[] = new String[RecordSetLog.getCounts()];
		String workflowPhrasesContent[] = new String[RecordSetLog.getCounts()];
		int m = 0 ;
		if (isSuccess) {
			while (RecordSetLog.next()){
				workflowPhrases[m] = Util.null2String(RecordSetLog.getString("phraseShort"));
				workflowPhrasesContent[m] = Util.toHtml(Util.null2String(RecordSetLog.getString("phrasedesc")));
				m ++ ;
			}
		}
%>
	<% if ("1".equals(isSignWorkflow_edit) || "1".equals(isannexupload_edit) || "1".equals(isannexupload_edit)) {
	%>
		    <div class='signbottommenu' style="left: 0px;width: 100%;display: none;">
                                     <%
                                     //相关附件
                                     if ("1".equals(isannexupload_edit)) {                  
                                     %>        
                                                          
                                     <div id="signAnnexupload" style="">
                                         <%
                                             if (annexsecId < 1) {
                                         %>
                                         <%=SystemEnv.getHtmlLabelName(21418, user.getLanguage()) + SystemEnv.getHtmlLabelName(15808, user.getLanguage())%>!
                                     <%
                                     } else {
                                     %>
                                     <script type="text/javascript">
                                     var signannexParam = {
                                                   annexmainId :"<%=annexmainId%>",
                                                   annexsubId : "<%=annexsubId%>",
                                                   annexsecId : "<%=annexsecId%>",
                                                   userid : "<%=userid%>",
                                                   logintype : "<%=logintype%>",
                                                   annexmaxUploadImageSize : <%=annexmaxUploadImageSize%>,
                                                   userlanguage:"<%=user.getLanguage()%>",
                                                   field_annexupload: '<%=annexdocids %>'
                                      };
                                      </script>
                                      <span class="signResourceBlockClass" style="margin-left:15px;margin-right:15px;">
	                                         <span class="signAnnexupload" onclick="showSignResourceCenter('signAnnexuploadCount');"
	                                                title="<%=SystemEnv.getHtmlLabelName(22194, user.getLanguage())%>">
	                                         </span> 
	                                         <div class="signAnnexupload_span" id="signAnnexuploadCount" style="word-break: break-all;word-wrap: break-word;margin-left:40px;">
	                                         </div>
                                      </span>
                                      <input class=InputStyle type=hidden size=60 id="field-annexupload" name="field-annexupload" value="<%=annexdocids%>">
                                         <input type=hidden id="field_annexupload_del_id" value="">
                                         <input type="hidden" name="field-annexupload-name" id="field-annexupload-name" value="<%=fieldannexuploadname%>">
                                         <input type="hidden" name="field-annexupload-count" id="field-annexupload-count" value="">
                                         <input type="hidden" name="field-annexupload-request" id="field-annexupload-request" value="<%=requestid%>">
                                         <input type="hidden" name="field-cancle" id="field-cancle" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage())%>">
                                         <input type="hidden" name="field-add-name" id="field-add-name" value="<%=SystemEnv.getHtmlLabelName(18890, user.getLanguage()) + SystemEnv.getHtmlLabelName(19812, user.getLanguage())%>">
                                         <input type=hidden name='annexmainId' id='annexmainId' value=<%=annexmainId%>>
                                         <input type=hidden name='annexsubId' id='annexsubId' value=<%=annexsubId%>>
                                         <input type=hidden name='annexsecId' id='annexsecId' value=<%=annexsecId%>>
                                         <input type=hidden name='fileuserid' id='fileuserid' value=<%=userid%>>
                                         <input type=hidden name='fileloginyype' id='fileloginyype' value=<%=logintype%>>
                                      
                                     <%
                                         }
                                     %>
     								</div>  
                        
                                     <%
                                     }
                                     //相关文档
                                     if ("1".equals(isSignDoc_edit)) {
                                     %>
                                     <div id="signDoc" style="left: 0px;width: 100%">
                                         <input type="hidden" id="signdocids" name="signdocids"
                                             value="<%=signdocids%>">
                                         <span class="signResourceBlockClass" style="margin-left:15px;margin-right:15px;"> <span
                                             class="signDoc"
                                             onclick="onShowSignBrowser4signinput('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?isrequest=1&id=','signdocids','signdocspan',37, 'signDocCount')"
                                             title="<%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%>">
                                          </span>
                                          <div class="signDoc_span" id="signDocCount" style="word-break: break-all;word-wrap: break-word;margin-left:40px;">
	                                         </div> 
                                         </span>
                                         <span id="signdocspan"></span> 
                                      </div>
                                     <%
                                         }
                                     %>
                                     <%
                                         //相关流程
                                     if ("1".equals(isSignWorkflow_edit)) {
                                     %>
                                     <div id="signWorkflow" style="left: 0px;width:100%">
                                         <input type="hidden" id="signworkflowids"
                                             name="signworkflowids" value="<%=signworkflowids%>">
                                         <span class="signResourceBlockClass" style="margin-left:15px;margin-right:15px;"> <span
                                             class="signWorkflow"
                                             onclick="onShowSignBrowser4signinput('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?isrequest=1&requestid=','signworkflowids','signworkflowspan',152, 'signWorkflowCount')"
                                             title="<%=SystemEnv.getHtmlLabelName(1044, user.getLanguage())%>">
                                         </span> 
                                         <div class="signWorkflow_span" id="signWorkflowCount" style="word-break: break-all;word-wrap: break-word;margin-left:40px;">
	                                        </div>
                                         </span>
                                         <span id="signworkflowspan"></span> 
                                       </div>
                                     <%
                                         }
                                     %>
           </div>
         <script type="text/javascript">
				function onShowSignBrowser4signinput(url, linkurl, inputname, spanname, type1, countEleID) {
				    var tmpids = jQuery("#" + inputname).val();
				    var url;
				     if (type1 === 37) {
				       // url = "/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=(Util.getIntValue(user.getLogintype()) - 1)%>&url=" + url + "?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=(Util.getIntValue(user.getLogintype()) - 1)%>&documentids=" + tmpids;
					   url = "/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=(Util.getIntValue(user.getLogintype()) - 1)%>&url=" + url + "?documentids=" + tmpids + uescape("&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=(Util.getIntValue(user.getLogintype()) - 1)%>");
				    } else {
				        url = "/systeminfo/BrowserMain.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=(Util.getIntValue(user.getLogintype()) - 1) %>&url=" + url + "?resourceids=" + tmpids + uescape("&f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=(Util.getIntValue(user.getLogintype()) - 1)%>");
				    }
				    var dialog = new window.top.Dialog();
				    dialog.currentWindow = window;
				    dialog.callbackfunParam = null;
				    dialog.URL = url;
				    dialog.callbackfun = function (paramobj, id1) {
				        if (id1) {
				            if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
				                var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
				                var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
				                var sHtml = "";
				                resourceids = resourceids.substr(0);
				                resourcename = resourcename.substr(0);
				                jQuery("#" + inputname).val(resourceids);
				                var resourceidArray = resourceids.split(",");
				                var resourcenameArray = resourcename.split(",");
					
					            for (var _i = 0; _i < resourceidArray.length; _i++) {
					                var curid = resourceidArray[_i];
					                var curname = resourcenameArray[_i];
					                if (type1 === 37) {			              
					                   // sHtml = sHtml + "<a href='javascript:void 0' onclick=\"parent.addDocReadTag('" + curid + "');parent.openFullWindowHaveBar('/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&id=" + curid + "&isrequest=1&requestid=<%=Util.getIntValue(requestid+"",0) <= 0 ? "{#[currentRequestid]#}" : requestid %>')\" title='" + curname + "' style=\"color:#123885;\">" + curname + "</a>&nbsp;&nbsp;";
									    sHtml = sHtml + "<a href='/docs/docs/DocDsp.jsp?id=" + curid + "&isrequest=1&requestid=<%=Util.getIntValue(requestid+"",0) <= 0 ? "{#[currentRequestid]#}" : requestid %>'  title='" + curname + "' style=\"color:#123885;\" target=\"_blank;\" >" + curname + "</a>&nbsp;&nbsp;";
					                } else {
					                	sHtml += "<a href='/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid="+curid+"&isrequest=1' target='_blank' style=\"color:#123885;\">"+curname+ "</a>&nbsp;&nbsp;";
					                }
					            }
					            jQuery("#" + countEleID).html(sHtml);
					            var editorid = "remark"; 
					            UE.getEditor(editorid).setContent(" &nbsp;" + sHtml, true);
					            
					            try {
					            	var _targetobj;
									var _targetobjimg = "";
									var _targetobjClass = "";
				            		if (type1 == 152) { //相关流程
				            			_targetobj = jQuery(".edui-for-wfwfbutton").children("div").children("div").children("div").children(".edui-metro");
				            			_targetobjClass = "wfres_3";
				            		} else {
				            			_targetobj = jQuery(".edui-for-wfdocbutton").children("div").children("div").children("div").children(".edui-metro");
				            			_targetobjClass = "wfres_2";
				            		}
					            	if (resourceidArray.length != 0) {
					            		_targetobj.addClass(_targetobjClass + "_slt");
					            		_targetobj.removeClass(_targetobjClass);
					            	} else {
					            		_targetobj.addClass(_targetobjClass);
					            		_targetobj.removeClass(_targetobjClass + "_slt");
					            	}
					            } catch (e) {}
				            } else {
				                jQuery("#" + inputname).val("");
				                if (!! countEleID) {
				                    jQuery("#" + countEleID).children("Table").find("TD[class=signcountClass_center]").html("0");
				                    jQuery("#" + countEleID).hide();
				                }
				                
				                try {
					            	var _targetobj;
									var _targetobjimg = "";
									var _targetobjClass = "";
				            		if (type1 == 152) { //相关流程
				            			_targetobj = jQuery(".edui-for-wfwfbutton").children("div").children("div").children("div").children(".edui-metro");
				            			_targetobjClass = "wfres_3";
				            		} else {
				            			_targetobj = jQuery(".edui-for-wfdocbutton").children("div").children("div").children("div").children(".edui-metro");
				            			_targetobjClass = "wfres_2";
				            		}
				            		_targetobj.addClass(_targetobjClass);
					                _targetobj.removeClass(_targetobjClass + "_slt");
					            } catch (e) {}
				            }
				        }
				    } ;
				    dialog.Height = 620 ;
				    if (type1 === 37) {
				    dialog.Title = "<%=SystemEnv.getHtmlLabelName(857,user.getLanguage())%>";
				    }else{
				    dialog.Title = "<%=SystemEnv.getHtmlLabelName(22105,user.getLanguage())%>";
					    if(jQuery.browser.msie){
							dialog.Height = 570;
						}else{
							dialog.Height = 570;
						}
				    }
				    
				    dialog.Drag = true;
				    dialog.show();
				}
				function showSignResourceCenter(sgid) {
				    if ( !! typeof(signannexParam)) {
				        var param = "annexmainId=" + signannexParam.annexmainId + "&annexsubId=" + signannexParam.annexsubId + "&annexsecId=" + signannexParam.annexsecId + "&userid=" + signannexParam.userid + "&logintype=" + signannexParam.logintype + "&annexmaxUploadImageSize=" + signannexParam.annexmaxUploadImageSize + "&userlanguage=" + signannexParam.userlanguage + "&field_annexupload=" + jQuery("#field-annexupload").val() + "&field_annexupload_del_id=" + jQuery("#field_annexupload_del_id").val();
				        var url = "/workflow/request/workflowSignAnnexUpload.jsp?" + param;
				        dialog = new window.top.Dialog();
				        dialog.currentWindow = window;
				        dialog.Title = "<%=SystemEnv.getHtmlLabelName(17616,user.getLanguage())%>";
				        dialog.Width = 500;
				        dialog.Height = 300;
				        dialog.URL = url;
				        dialog.callbackfun = function (paramobj, id1) {
				        	if (id1) {
					           if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
					                var ids = jQuery.trim(wuiUtil.getJsonValueByIndex(id1, 0));
					                var names = jQuery.trim(wuiUtil.getJsonValueByIndex(id1, 1));
									var siezes = jQuery.trim(wuiUtil.getJsonValueByIndex(id1, 2));
									var splitchar = "////~~weaversplit~~////";
									var idArray = ids.split(splitchar);
						            var nameArray = names.split(splitchar);
						            var sizeArray = siezes.split(splitchar);
						            var sHtml = "";
						            var sHtml2 = "";
						            for (var _i = 0; _i < idArray.length; _i++) {
						                var curid = jQuery.trim(idArray[_i]);
						                var curname = jQuery.trim(nameArray[_i]);
						                var cursize = jQuery.trim(sizeArray[_i])
						          		sHtml += "<a href='javascript:void(0);' onclick=\"parent.openFullWindowHaveBar('/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&id=" + curid + "&isrequest=1&requestid=<%=requestid %>&desrequestid=0')\" style=\"color:#123885;\">" + curname + "</a>&nbsp;&nbsp;";
						                sHtml2 += "<a href='javascript:void(0);' onclick=\"parent.openFullWindowHaveBar('/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&id=" + curid + "&isrequest=1&requestid=<%=requestid %>&desrequestid=0')\" style=\"color:#123885;\">" + curname + "</a>&nbsp;&nbsp;<br>";
						            }
									var editorid = "remark"; 
									try{
										UE.getEditor(editorid).setContent("&nbsp;" + sHtml, true);			
									}catch(e){
										jQuery("#signAnnexuploadCount").html(sHtml2);
									}
					            }
					            try {
				           			var _targetobj = jQuery(".edui-for-wfannexbutton").children("div").children("div").children("div").children(".edui-metro");
					            	if (document.getElementById("field-annexupload").value != '') {
					            		_targetobj.addClass("wfres_1_slt");
					            		_targetobj.removeClass("wfres_1");
					            	} else {
					            		_targetobj.addClass("wfres_1");
					            		_targetobj.removeClass("wfres_1_slt");
					            	}
					            } catch (e) {}				            
					        }
				        };
				        dialog.show();
				    }				
				}
			</script>
                             
	<%}%>
<%}%>
<!--流转意见展示-->

<input type="hidden" id="isdialog" name="isdialog" value="1"/>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<%if(showDocTab_edit.equals("1")){} %>
<%if(showWorkflowTab_edit.equals("1")){}%>
<%if(showUploadTab_edit.equals("1")){}
%>

<!--以下删除签字意见字段 by ben 2007-3-16-->
<%
    boolean hasUseTempletSucceed=false;
    boolean isUseTempletNode=false;
    //boolean hasSignatureSucceed=false;
    if("1".equals(fromFlowDoc)||"1".equals(isworkflowdoc)){
    	hasUseTempletSucceed=RequestUseTempletManager.ifHasUseTempletSucceed(requestid);
    	isUseTempletNode=RequestUseTempletManager.ifIsUseTempletNode(requestid,user.getUID(),user.getLogintype());
    	//hasSignatureSucceed=RequestSignatureManager.ifHasSignatureSucceed(requestid,nodeid,user.getUID(),Util.getIntValue(user.getLogintype(),1));
    }
    %>
<input type="hidden" name="temphasUseTempletSucceed" id="temphasUseTempletSucceed" value="<%=hasUseTempletSucceed%>"/>
<input type="hidden" name="isUseTempletNode" id="isUseTempletNode" value="<%=isUseTempletNode%>"/>
        
<script language="javascript">

function isSign(fg) {
	queryData({"url":"/workflow/request/signatureCount.jsp","requestId":"<%=requestid %>","nodeId":"<%=nodeid %>","userId":"<%=user.getUID() %>","loginType":"<%=user.getLogintype() %>"},function(paramsObj,msg){
		fg.flag = msg[0].signatureCount;
	})
}

<%
    if(ismode.equals("1")){
%>
//TD4262 增加提示信息  开始

var oPopup;
try{
    oPopup = window.createPopup();
}catch(e){}
//TD4262 增加提示信息  结束

<%
    }
%>

    function doRemark_n(obj)
    <!-- 点击被转发的提交按钮,点击抄送的人员提交 -->
	
    {
enableAllmenu();
var ischeckok="true";
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
				    ischeckok="false";
					displayAllmenu();	
			    }
		    }
<%
		}
	}
%>
if(ischeckok=="true"){	
	if ("<%=needconfirm%>"=="1")
	{
    if (!confirm("<%=SystemEnv.getHtmlLabelName(19990,user.getLanguage())%>")){
		displayAllmenu();
        return; 
	}
	}
	
        try
        {
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoRemark").click();
        }
        catch(e)
        {                
			if(checktimeok()) 
			{
		        $GetEle("frmmain").isremark.value='<%=isremark%>';
		        $GetEle("frmmain").src.value='save';
		                        
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201

//保存签章数据
<%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
						try{  
					        if(typeof(eval("SaveSignature"))=="function"){
					             if(SaveSignature()){

						            //TD4262 增加提示信息  开始

									<%
									    if(ismode.equals("1")){
									%>
							            
						                            contentBox = $GetEle("divFavContent18978");
						                            showObjectPopup(contentBox)
									<%
									    
									    }else{
									%>
								       
						                            var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
						                            showPrompt(content);
									        
									<%
									    }
									%>
						                            //TD4262 增加提示信息  结束
						                             $GetEle("frmmain").action="RequestRemarkOperation.jsp";
						                            //附件上传
						                            StartUploadAll();
						                            checkuploadcomplet();
						                        }else{
													if(isDocEmpty==1){
														alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
														isDocEmpty=0;
													}else{
														alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
													}
													displayAllmenu();
													return ;
												}
					        }
					    }catch(e){
					        //TD4262 增加提示信息  开始

									<%
									    if(ismode.equals("1")){
									%>
							            
						                            contentBox = $GetEle("divFavContent18978");
						                            showObjectPopup(contentBox)
									<%
									    
									    }else{
									%>
								       
						                            var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
						                            showPrompt(content);
									        
									<%
									    }
									%>
						                            //TD4262 增加提示信息  结束
						                             $GetEle("frmmain").action="RequestRemarkOperation.jsp";
						                            //附件上传
						                            StartUploadAll();
						                            checkuploadcomplet();
					    }
	                    
<%}else{%>

            //TD4262 增加提示信息  开始

			<%
			    if(ismode.equals("1")){
			%>
	            
                        contentBox = $GetEle("divFavContent18978");
                        showObjectPopup(contentBox)
			<%
			    
			    }else{
			%>
		       
                        var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
                        showPrompt(content);
			        
			<%
			    }
			%>
                        //TD4262 增加提示信息  结束
                        $GetEle("frmmain").action="RequestRemarkOperation.jsp";
                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}%>
            }else{
	            displayAllmenu();
                return; 
            }
        }
}
displayAllmenu();
	}
	function checkNodesNum()
	{
		var nodenum = 0;
		try
		{
		<%
		int checkdetailno = 0;
		//
		if(isbill>0)
		{
			if(formid==7||formid==156 || formid==157 || formid==158 || formid==159)
			{
				%>
				try{
				   	var rowneed = $GetEle('rowneed').value;
				   	var nodesnum = $GetEle('nodesnum').value;
				   	nodesnum = nodesnum*1;
				   	if(rowneed=="1")
				   	{
				   		if(nodesnum>0)
				   		{
				   			nodenum = 0;
				   		}
				   		else
				   		{
				   			nodenum = 1;
				   		}
				   	}
				   	else
				   	{
				   		nodenum = 0;
				   	}
			   	}catch(e){}
			   	<%
			}
			else
			{
			    //单据
			    RecordSet.execute("select tablename,title from Workflow_billdetailtable where billid="+formid+" order by orderid");
			    //System.out.println("select tablename,title from Workflow_billdetailtable where billid="+formid+" order by orderid");
			    while(RecordSet.next())
			    {
	   	%>
	   	try{
		   	var rowneed = $GetEle('rowneed<%=checkdetailno%>').value;
		   	var nodesnum = $GetEle('nodesnum<%=checkdetailno%>').value;
		   	nodesnum = nodesnum*1;
		   	if(rowneed=="1")
		   	{
		   		if(nodesnum>0)
		   		{
		   			nodenum = 0;
		   		}
		   		else
		   		{
		   			nodenum = '<%=checkdetailno+1%>';
		   		}
		   	}
		   	else
		   	{
		   		nodenum = 0;
		   	}
		   	if(nodenum>0)
		   	{
		   		return nodenum;
		   	}
	   	}catch(e){}
	   	<%
			   		checkdetailno ++;
			    }
			}
		}
		else
		{
		 	int checkGroupId=0;
		    RecordSet formrs=new RecordSet();
			formrs.execute("select distinct groupId from Workflow_formfield where formid="+formid+" and isdetail='1' order by groupid");
		    while (formrs.next())
		    {
		    	checkGroupId=formrs.getInt(1);
		    	%>
		    	try{
			       	var rowneed = $GetEle('rowneed<%=checkGroupId%>').value;
			       	var nodesnum = $GetEle('nodesnum<%=checkGroupId%>').value;
			       	nodesnum = nodesnum*1;
			       	if(rowneed=="1")
			       	{
			       		if(nodesnum>0)
			       		{
			       			nodenum = 0;
			       		}
			       		else
			       		{
			       			nodenum = <%=checkGroupId+1%>;
			       		}
			       	}
			       	else
			       	{
			       		nodenum = 0;
			       	}
			       	if(nodenum>0)
				   	{
				   		return nodenum;
				   	}
				}catch(e){}
		       	<%
		    }
	    }
	    //多明细循环结束

		%>
		}
		catch(e)
		{
			nodenum = 0;
		}
		return nodenum;
	}
    function doSave_n(obj){
    	enableAllmenu();
		//var nodenum = checkNodesNum();
		var nodenum = 0;
    	if(nodenum>0)
    	{
    		displayAllmenu();
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		return false;
    	}
		//点击保存按钮
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSave").click();
        }catch(e){
            var ischeckok="";
            try{
			  if(check_form($GetEle("frmmain"), "requestname"))
              ischeckok="true";
            }catch(e){
              ischeckok="false";
            }
            if(ischeckok=="false"){
                if(check_form($GetEle("frmmain"),'<%=needcheck%>'))
                    ischeckok="true";
            }
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
               //保存时不校验签字意见必填
			   // if(!check_form($GetEle("frmmain"),'remarkText10404')){
			   //    ischeckok="false";
			   // }
		    }
<%
		}
	}
%>
            if(ischeckok=="true"){
                objSubmit=obj;
                CkeditorExt.updateContent();
                if(checktimeok()&&checkReportData("save")) {
                }else{
                    displayAllmenu();
					return;
                }
            }else{
            	displayAllmenu();
				return;
            }
        }
	}


    function doRemark()
    <!-- 点击被转发的提交按钮 -->
	
    {    
var ischeckok="true";
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>
if(ischeckok=="true"){	
	if ("<%=needconfirm%>"=="1")
	{
	if (!confirm("<%=SystemEnv.getHtmlLabelName(19990,user.getLanguage())%>"))
    return false;
	}

        try
        {
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoRemark").click();
        }
        catch(e)
        {                
			if(checktimeok()) 
			{
		        $GetEle("frmmain").isremark.value='1';
		        $GetEle("frmmain").src.value='save'; 		                        
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201


//保存签章数据
<%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
						try{  
					        if(typeof(eval("SaveSignature"))=="function"){
					              if(SaveSignature()){
						            //TD4262 增加提示信息  开始

									<%
									    if(ismode.equals("1")){
									%>
							            
						                            contentBox = $GetEle("divFavContent18978");
						                            showObjectPopup(contentBox)
									<%
									    
									    }else{
									%>
								       
						                            var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
						                            showPrompt(content);
									        
									<%
									    }
									%>
						                            //TD4262 增加提示信息  结束
						
						                            //附件上传
						                            StartUploadAll();
						                            checkuploadcomplet();
						                        }else{
													if(isDocEmpty==1){
														alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
														//自动跳到签字意见锚点
														window.location.hash = "#fsUploadProgressannexuploadSimple";//重置锚点,否则,下次将不能定位

														window.location.hash = null;
														jQuery("#remarkShadowDiv").hide();
														jQuery("#signrighttool").css("display","");
														jQuery(".signaturebyhand").css("display","");
														isDocEmpty=0;
													}else{
														alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
													}
													displayAllmenu();
													return ;
												}
					        }
					    }catch(e){
					        //TD4262 增加提示信息  开始

									<%
									    if(ismode.equals("1")){
									%>
							            
						                            contentBox = $GetEle("divFavContent18978");
						                            showObjectPopup(contentBox)
									<%
									    
									    }else{
									%>
								       
						                            var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
						                            showPrompt(content);
									        
									<%
									    }
									%>
						                            //TD4262 增加提示信息  结束
						
						                            //附件上传
						                            StartUploadAll();
						                            checkuploadcomplet();
					    }
	                    
<%}else{%>
            //TD4262 增加提示信息  开始

			<%
			    if(ismode.equals("1")){
			%>
	            
                        contentBox = $GetEle("divFavContent18978");
                        showObjectPopup(contentBox)
			<%
			    
			    }else{
			%>
		       
                        var content="<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>";
                        showPrompt(content);
			        
			<%
			    }
			%>
                        //TD4262 增加提示信息  结束

                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}%>
            }
        }
}
	}

    function doSave(){//点击保存按钮
    	enableAllmenu();
    	//var nodenum = checkNodesNum();
    	var nodenum = 0;
    	if(nodenum>0)
    	{
    		displayAllmenu();
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		return false;
    	}
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSave").click();
        }catch(e){
            var ischeckok="";
            try{
			 if(check_form($GetEle("frmmain"), "requestname"))
              ischeckok="true";
            }catch(e){
              ischeckok="false";
            }
            if(ischeckok=="false"){
                if(check_form($GetEle("frmmain"),'<%=needcheck%>'))
                    ischeckok="true";
            }
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
	            getRemarkText_log();
	            
	            //保存时不验证签字意见必填
			    //if(!check_form($GetEle("frmmain"),'remarkText10404')){
				//    ischeckok="false";
			    //}
		    }
<%
		}
	}
%>
            if(ischeckok=="true"){
                objSubmit="";
                CkeditorExt.updateContent();
                if(checktimeok()&&checkReportData("save")) {
                }else{
                    displayAllmenu();
				    return;
                }
            }else{
            	displayAllmenu();
				return;
            }
        }
	}

    function doAffirmance(obj){          <!-- 提交确认 -->
		enableAllmenu();
    	var nodenum = checkNodesNum();
    	if(nodenum>0)
    	{
            displayAllmenu();
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		return false;
    	}
		
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSave").click();
        }catch(e){
            var ischeckok="";
            try{
            	var needCheckStr = $GetEle("needcheck").value+$GetEle("inputcheck").value;
				if(!!needCheckStr && jQuery("input#edesign_layout").length>0)
					needCheckStr = viewattrOperator.filterHideField(needCheckStr);
            	if(check_form($GetEle("frmmain"),needCheckStr))
              		ischeckok="true";
            }catch(e){
              ischeckok="false";
            }
            if(ischeckok=="false"){
            	var needCheckStr = '<%=needcheck%>';
            	if(!!needCheckStr && jQuery("input#edesign_layout").length>0)
					needCheckStr = viewattrOperator.filterHideField(needCheckStr);
                if(check_form($GetEle("frmmain"),needCheckStr))
                    ischeckok="true";
            }
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>
            if(ischeckok=="true"){
                objSubmit=obj;
                CkeditorExt.updateContent();
                if(checktimeok()&&checkReportData("Affirmance")) {
                }else{
					displayAllmenu();
					return;
				}
            }else{
				displayAllmenu();
				return;
			}
        }
	}
    

	/*	
	 *	用来给用户自定义检查数据，在流程提交或者保存的时候执行该函数，

	 *	如果检查通过返回true，否则返回false
	 *	用户在使用html模板的时候，通过重写这个方法，来达到检查特殊数据的需求

	 */
	/*function checkCustomize(){
		return true;
	}*/
	
	//在启用的费控流程中会重写该方法

	function fnaifoverJson_doSubmit(obj){
		return doSubmitE8(obj);
	}
	function meeting_doSubmit(obj){
		return doSubmitE8(obj);
	}
	function doSubmit(obj){			<!-- 点击提交 -->
	<%if(isEnableFnaWf || (haveWorkflowBaseCustompage && !isFnaWf)){//如果是启用的费控流程%>
		return fnaifoverJson_doSubmit(obj);
	<%}else if(isMeetingWf){%>
		return meeting_doSubmit(obj);
	<%}else{%>
		return doSubmitE8(obj);
	<%}%>
	}
    
    function doSubmitE8(obj){					//点击提交
			$G('RejectToNodeid').value = '';
    var isuseTemplate = $GetEle("temphasUseTempletSucceed").value;
		try{
			if(!checkCustomize()){
				displayAllmenu();
				return false;
			}
		}catch(e){
			if(window.console)console.log(e);
		}
		try{
			if(!checkCarSubmit()){ // add by QC209437 2016-08-18
				displayAllmenu();
				return false;
			}
		}catch(e){
			if(window.console)console.log(e);
		}
    	enableAllmenu();
    	var nodenum = checkNodesNum();
    	if(nodenum>0)
    	{
    		displayAllmenu();
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		return false;
    	}
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoSubmit").click();
        }catch(e){
      //modify by xhheng @20050328 for TD 1703
      //明细部必填check，通过try $GetEle("needcheck")来检查,避免对原有无明细单据的修改

        var ischeckok="";
        try{
        var checkstr=$GetEle("needcheck").value+$GetEle("inputcheck").value+',<%=needcheck%>';
        if(<%=isremark%>==5){
            checkstr="";
        }
        if(!!checkstr && jQuery("input#edesign_layout").length>0)
			checkstr = viewattrOperator.filterHideField(checkstr);
        if(check_form($GetEle("frmmain"),checkstr))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
        	var needCheckStr = '<%=needcheck%>';
			if(!!needCheckStr && jQuery("input#edesign_layout").length>0)
				needCheckStr = viewattrOperator.filterHideField(needCheckStr);
          	if(check_form($GetEle("frmmain"), needCheckStr))
            	ischeckok="true";
        }
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
		}else{
%>
            if(ischeckok=="true"){
	            getRemarkText_log();
			    if(!check_form($GetEle("frmmain"),'remarkText10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>
        if(ischeckok=="true"){
    		if (("<%=needconfirm%>"=="1")&&("<%=nodetype%>"!="0"))
    		{
    		if (!confirm("<%=SystemEnv.getHtmlLabelName(19990,user.getLanguage())%>")){
    			displayAllmenu();
	            return false;
    		}
    		}
			<%
			if("1".equals(fromFlowDoc)||"1".equals(isworkflowdoc)){
				//if(!hasUseTempletSucceed){
			%>
				if(isuseTemplate == 'false'){
					if($GetEle("createdoc")){
					if(window.confirm("<%=SystemEnv.getHtmlLabelName(21252,user.getLanguage())%>")){
					   //parent.resetbanner(1,1);
					   $GetEle("createdoc").click();
					   return false;
					}else{
						displayAllmenu();
					   return false;
					}
					}
					}
			<%
			}
			%>
			var fg = {};
			isSign(fg);
			if(!fg.flag && !window.confirm("<%=SystemEnv.getHtmlLabelName(23043,user.getLanguage())%>")){
				displayAllmenu();
				return false;
			}

            objSubmit=obj;
            CkeditorExt.updateContent();
            if(checktimeok()&&checkReportData("submit")) {
            }else{
            	displayAllmenu();
				return;
            }
        }else{
        	displayAllmenu();
			return;
        }
        }
	}

		function doReject(){				//点击退回
			$G('SubmitToNodeid').value = '';

<%
	if(isSignMustInput.equals("1") || isSignMustInput.equals("2")){
	    if("1".equals(isFormSignature)){
		}else{
%>
	            getRemarkText_log();
			    if(!check_form(document.frmmain,'remarkText10404')){
				    return false;
			    }
<%
		}
	}
%>
		var isuseTemplate = $GetEle("temphasUseTempletSucceed").value;
		var _isUseTempletNode = $GetEle("isUseTempletNode").value;
		enableAllmenu();
		
		<%
		if("1".equals(fromFlowDoc)||"1".equals(isworkflowdoc)){
			//if(isUseTempletNode&&hasUseTempletSucceed){
		%>
			if(_isUseTempletNode == 'true'&&isuseTemplate== 'true'){
				if(window.confirm("<%=SystemEnv.getHtmlLabelName(22985,user.getLanguage())%>")){
				   //parent.resetbanner(1,1);
				   $GetEle("createdoc").click();
				   return;
				}else{
				   displayAllmenu();
				   return;
				}
				}
		<%
			
		}
		%>
		
		if ("<%=needconfirm%>"=="1")
		{
		    top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(19991,user.getLanguage())%>",sureReject,function(){
			        displayAllmenu();
			        return false;
		        });
		}else{
			sureReject()
		}
    }
    function sureReject(){
       try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoReject").click();
        }catch(e){
            if(onSetRejectNode()){
	            showtipsinfo(<%=requestid%>,<%=workflowid%>,<%=nodeid%>,<%=isbill%>,1,<%=billid%>,"","reject","<%=ismode%>","divFavContent18980","<%=SystemEnv.getHtmlLabelName(18980,user.getLanguage())%>");
            }else{
            	displayAllmenu();
				return;
            }
        }
    }

	function doReopen(){        <!-- 点击重新激活 -->
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoReopen").click();
        }catch(e){
            $GetEle("frmmain").src.value='reopen';
            $GetEle("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
            jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201
            checkuploadcomplet();
        }
	}

	function doDelete(){        <!-- 点击删除 -->
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $GetEle("planDoDelete").click();
        }catch(e){
            if(confirm("<%=SystemEnv.getHtmlLabelName(16667,user.getLanguage())%>")) {
                $GetEle("frmmain").src.value='delete';
                $GetEle("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201

                //TD4262 增加提示信息  开始

<%
    if(ismode.equals("1")){
%>
	            contentBox = $GetEle("divFavContent18984");
                showObjectPopup(contentBox)
<%
    }else{
%>
		       var content="<%=SystemEnv.getHtmlLabelName(18984,user.getLanguage())%>";
		       showPrompt(content);
<%
    }
%>
                //TD4262 增加提示信息  结束

                checkuploadcomplet();
		
            }
        }
    }
//加常用短语

function onAddPhrase(phrase){
	if(phrase!=null && phrase!=""){
		$GetEle("remarkSpan").innerHTML = "";
		try{
			var remarkHtml = FCKEditorExt.getHtml("remark");
			var remarkText = FCKEditorExt.getText("remark");
			if(remarkText==null || remarkText==""){
				FCKEditorExt.setHtml(phrase,"remark");
			}else{
				FCKEditorExt.setHtml(remarkHtml+phrase,"remark");
			}
		}catch(e){}
	}
	$G("phraseselect").options[0].selected = true;
}
//xwj for td3665 20060227
function doDrawBack(obj){
	if("<%=needconfirm%>"=="1"&&!confirm("<%=SystemEnv.getHtmlLabelName(24703,user.getLanguage())%>")){
		return false;
	}else{
	var ischeckok="true";
	<%
		if(isSignMustInput.equals("1")){
		    if("1".equals(isFormSignature)){
			}else{
	%>
	            if(ischeckok=="true"){
	            	getRemarkText_log();
				    if(!check_form($GetEle("frmmain"),'remarkText10404')){
					    ischeckok="false";
				    }
			    }
	<%
			}
		}
	%>
			if(ischeckok=="true"){	
				jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
				obj.disabled=true;
				$GetEle("frmmain").action="/workflow/workflow/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&flag=ov&fromflow=1";
				//附件上传
			    StartUploadAll();
		        checkuploadcomplet();
		}
	}
}
function doRetract(obj){
jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
obj.disabled=true;
document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&flag=rb&requestid=<%=requestid%>" //xwj for td3665 20060224
}
function nodechange(value){
    var nodeids=value.split("_");
    var selnodeid=nodeids[0];
    var selnodetype=nodeids[1];
    if(selnodetype==0){
        $GetEle("Intervenorid").value="<%=creater%>";
		$GetEle("IntervenoridType").value="<%=creatertype%>";
        $GetEle("Intervenoridspan").innerHTML="<A href='javaScript:openhrm(<%=creater%>);' onclick='pointerXY(event);'><%=creatername%></a>";
    }else{
    rightMenu.style.display="none";
    $GetEle("workflownextoperatorfrm").src="/workflow/request/WorkflowNextOperator.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&requestid=<%=requestid%>&isremark=<%=isremark%>&workflowid=<%=workflowid%>"+
            "&formid=<%=formid%>&isbill=<%=isbill%>&billid=<%=billid%>&creater=<%=creater%>&creatertype=<%=creatertype%>&nodeid="+selnodeid+"&nodetype="+selnodetype;
    }
}



//TD4262 增加提示信息  开始

//提示窗口

<%
    if(ismode.equals("1")){
%>
function showObjectPopup(contentBox){
  try{
    var iX=document.body.offsetWidth/2-50;
	var iY=document.body.offsetHeight/2+document.body.scrollTop-50;

	var oPopBody = oPopup.document.body;
    oPopBody.style.border = "1px solid #8888AA";
    oPopBody.style.backgroundColor = "white";
    oPopBody.style.position = "absolute";
    oPopBody.style.padding = "0px";
    oPopBody.style.zindex = 150;

    oPopBody.innerHTML = contentBox.innerHTML;

    oPopup.show(iX, iY, 180, 22, document.body);
  }catch(e){}
}
<%
    }else{
%>
function showPrompt(content)
{
	 var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串

	 var isOpera = userAgent.indexOf("Opera") > -1;
	 var pTop=0;
	 //if (userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera){
		pTop= document.body.offsetHeight/2 - (parent.document.body.offsetHeight/2 - document.body.offsetHeight/2) - 55;
	 //}else{
		//pTop= document.body.offsetHeight/2+jQuery(document).scrollTop()-50;
	 //}
	 //alert("document.body.offsetHeight = "+document.body.offsetHeight);
	 //alert("parent.document.body.offsetHeight = "+parent.document.body.offsetHeight);
     var showTableDiv  = $GetEle('_xTable');
     jQuery(showTableDiv).css("display", "");
     var message_table_Div = document.createElement("div")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = $GetEle("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     //var pTop= document.body.offsetHeight/2+jQuery(document.documentElement).scrollTop()-50;
     var pLeft= document.body.offsetWidth/2-55;
     message_table_Div.style.position="fixed"
     jQuery(message_table_Div).css("top", pTop);
     jQuery(message_table_Div).css("left", pLeft);

     message_table_Div.style.zIndex=1002;
     var oIframe = document.createElement('iframe');
     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'fixed';
    
     jQuery(oIframe).css("top", pTop);
     jQuery(oIframe).css("left", pLeft);
     
     oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
     oIframe.style.width = parseInt(message_table_Div.offsetWidth);
     oIframe.style.height = parseInt(message_table_Div.offsetHeight);
     oIframe.style.display = 'block';
}
<%
    }
%>
//TD4262 增加提示信息  结束
var showTableDiv  = $GetEle('divshowreceivied');
var oIframe = document.createElement('iframe');
function showreceiviedPopup(content){
	var pTop= document.body.offsetHeight/2 + document.body.scrollTop - 50;
	var pLeft= document.body.offsetWidth/2 - 50;
	
	jQuery(showTableDiv).css("display", "");
 
	jQuery(showTableDiv).append("<div id=\"message_Div\" class=\"xTable_message\"></div>");
	jQuery("#message_Div").css("display", "inline");
	jQuery("#message_Div").html(content);
	jQuery("#message_Div").css("position", "absolute");
	jQuery("#message_Div").css("top", pTop);
	jQuery("#message_Div").css("left", pLeft);
	jQuery("#message_Div").css("zIndex", 1002);
	jQuery(oIframe).attr("id", "HelpFrame");
	jQuery(showTableDiv).append(oIframe);
	jQuery(oIframe).attr("frameborder", 0);
	jQuery(oIframe).css("position", "absolute");
	jQuery(oIframe).css("top", pTop);
	jQuery(oIframe).css("left", pLeft);
	jQuery(oIframe).css("zIndex", parseInt(jQuery("#message_Div").css("zIndex")) - 1);
	jQuery(oIframe).css("width", parseInt(jQuery("#message_Div")[0].offsetWidth));
	jQuery(oIframe).css("height", parseInt(jQuery("#message_Div")[0].offsetHeight));
	jQuery(oIframe).css("display", "block");
}
function displaydiv_1()
{
	if(WorkFlowDiv.style.display == ""){
		WorkFlowDiv.style.display = "none";
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>";
	}
	else{
		WorkFlowDiv.style.display = "";
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:pointer;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></span>";

	}
}

function ajaxinit(){
    var ajax=false;
    try {
        ajax = new ActiveXObject("Msxml2.XMLHTTP");
    } catch (e) {
        try {
            ajax = new ActiveXObject("Microsoft.XMLHTTP");
        } catch (E) {
            ajax = false;
        }
    }
    if (!ajax && typeof XMLHttpRequest!='undefined') {
    ajax = new XMLHttpRequest();
    }
    return ajax;
}
function showallreceivedforsign(requestid,viewLogIds,operator,operatedate,operatetime,returntdid,logtype,destnodeid){
    showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
    var ajax=ajaxinit();
    ajax.open("POST", "/workflow/request/WorkflowReceiviedPersons.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("requestid="+requestid+"&viewnodeIds="+viewLogIds+"&operator="+operator+"&operatedate="+operatedate+"&operatetime="+operatetime+"&returntdid="+returntdid+"&logtype="+logtype+"&destnodeid="+destnodeid);
    //获取执行状态

    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里

        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            $GetEle(returntdid).innerHTML = ajax.responseText;
            }catch(e){}
            showTableDiv.style.display='none';
            oIframe.style.display='none';
        } 
    } 
}

function accesoryChanage(obj,maxUploadImageSize){
    var objValue = obj.value;
    if (objValue=="") return ;
    var fileLenth;
    try {
        var oFile=$GetEle("oFile");
        oFile.FilePath=objValue;
        fileLenth= oFile.getFileSize();
    } catch (e){
        //alert("<%=SystemEnv.getHtmlLabelName(20253,user.getLanguage())%>");
		if(e.message=="<%=SystemEnv.getHtmlLabelName(83411,user.getLanguage())%>"||e.message=="<%=SystemEnv.getHtmlLabelName(83411,user.getLanguage())%>"){
			alert("<%=SystemEnv.getHtmlLabelName(21015,user.getLanguage())%> ");
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21090,user.getLanguage())%> ");
		}
        createAndRemoveObj(obj);
        return  ;
    }
    if (fileLenth==-1) {
        createAndRemoveObj(obj);
        return ;
    }
    var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
    if(parseFloat(maxUploadImageSize)<=0)
    {
    	if(uploadImageMaxSize)
    		maxUploadImageSize = uploadImageMaxSize;
    		
    }
    if (fileLenthByM>maxUploadImageSize) {
     	alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%>"+maxUploadImageSize+"M<%=SystemEnv.getHtmlLabelName(20256 ,user.getLanguage())%>");
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    tempObjonchange=obj.onchange;
    outerHTML="<input name="+objName+" class=InputStyle type=file size=50 >";
    $GetEle(objName).outerHTML=outerHTML;
    $GetEle(objName).onchange=tempObjonchange;
}
function addannexRow(accname,maxsize)
  {
  	//区分两种添加方式
  	var uploadspan = "";
  	var checkMaxUpload = 0;
  	if(uploadImageMaxSize&&accname!="field-annexupload")
  	{
  		maxsize = uploadImageMaxSize;
  		uploadspan = "uploadspan";
  	}
  	else
  	{
  		checkMaxUpload = maxsize;
  	}
    $GetEle(accname+'_num').value=parseInt($GetEle(accname+'_num').value)+1;
    ncol = $GetEle(accname+'_tab').cols;
    oRow = $GetEle(accname+'_tab').insertRow(-1);
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1);

      switch(j) {
        case 0:
          var oDiv = document.createElement("div");
          oCell.colSpan=3;
          var sHtml = "<input class=InputStyle  type=file size=50 name='"+accname+"_"+$GetEle(accname+'_num').value+"' onchange='accesoryChanage(this,"+checkMaxUpload+")'><span id='"+uploadspan+"'>(<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>)</span> ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  }
  
  
function onChangeSharetypeNew(obj,delspan,delid,showid,names,ismand,Uploadobj){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(84051,user.getLanguage())%>"+names+"<%=SystemEnv.getHtmlLabelName(84498,user.getLanguage())%>", function(){
		var _tgtobjtr = jQuery(obj).closest("tr");
	    var _tgtobjtrhtml = _tgtobjtr.html();
	    _tgtobjtr.html("");
        _tgtobjtr.hide();
	    _tgtobjtr.html(_tgtobjtrhtml);
		var fieldid=delid.substr(0,delid.indexOf("_"));
	    var linknum=delid.substr(delid.lastIndexOf("_")+1);
		var fieldidnum=fieldid+"_idnum_1";
		var fieldidspan=fieldid+"span";
	    var delfieldid=fieldid+"_id_"+linknum;
	    if($GetEle(delspan).style.visibility=='visible'){
	      $GetEle(delspan).style.visibility='hidden';
	      $GetEle(delid).value='0';
		  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)+1;
	        var tempvalue=$GetEle(fieldid).value;
	          if(tempvalue==""){
	              tempvalue=$GetEle(delfieldid).value;
	          }else{
	              tempvalue+=","+$GetEle(delfieldid).value;
	          }
		     $GetEle(fieldid).value=tempvalue;
	    }else{
	      $GetEle(delspan).style.visibility='visible';
	      $GetEle(delid).value='1';
		  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)-1;
	        var tempvalue=$GetEle(fieldid).value;
	        var tempdelvalue=","+$GetEle(delfieldid).value+",";
	          if(tempvalue.substr(0,1)!=",") tempvalue=","+tempvalue;
	          if(tempvalue.substr(tempvalue.length-1)!=",") tempvalue+=",";
	          tempvalue=tempvalue.substr(0,tempvalue.indexOf(tempdelvalue))+tempvalue.substr(tempvalue.indexOf(tempdelvalue)+tempdelvalue.length-1);
	          if(tempvalue.substr(0,1)==",") tempvalue=tempvalue.substr(1);
	          if(tempvalue.substr(tempvalue.length-1)==",") tempvalue=tempvalue.substr(0,tempvalue.length-1);
		     $GetEle(fieldid).value=tempvalue;
	    }
		if (ismand=="1"){
			if ($GetEle(fieldidnum).value=="0"){
			    $GetEle(fieldid).value="";
			    var swfuploadid=fieldid.replace("field","");
			    //alert("swfuploadid = "+swfuploadid);
			    var fieldidnew = "field"+swfuploadid;
			    var fieldidspannew = "field_"+swfuploadid+"span";
			    //alert("fieldidspannew = "+fieldidspannew);
			    var linkrequired=$GetEle("oUpload_"+swfuploadid+"_linkrequired");
			    $GetEle(fieldidspannew).innerHTML="";
		        if(Uploadobj.getStats().files_queued==0){
					$GetEle(fieldidspannew).innerHTML="（<%=SystemEnv.getHtmlLabelName(18019, user.getLanguage())%>）";
					var checkstr_=$GetEle("needcheck").value+",";
					if(checkstr_.indexOf("field"+fieldidnew+",")<0) $GetEle("needcheck").value=checkstr_+fieldidnew;
		        }
		        if(linkrequired && linkrequired.value=="false"){
		        	$GetEle(fieldidspannew).innerHTML="";
		        }
		  	}else{
		  	 var swfuploadid=fieldid.replace("field","");
		  	 //alert("swfuploadid = "+swfuploadid);
		     var fieldidspannew = "field_"+swfuploadid+"span";
			 $GetEle(fieldidspannew).innerHTML="";
		  	}
		}else{//add by td78113
			var swfuploadid=fieldid.replace("field","");
		    var fieldidnew = "field"+swfuploadid;
		    var fieldidspannew = "field_"+swfuploadid+"span";
			if(jQuery("#"+fieldidnew).attr("viewtype")=="1"){
				if(Uploadobj.getStats().files_queued==0){
					$GetEle(fieldidspannew).innerHTML="（<%=SystemEnv.getHtmlLabelName(18019, user.getLanguage())%>）";
					var checkstr_=$GetEle("needcheck").value+",";
					if(checkstr_.indexOf("field"+fieldidnew+",")<0) $GetEle("needcheck").value=checkstr_+fieldidnew;
			    }
			}
		    
		  	displaySWFUploadError(fieldid);
		}
		
		////
		var leaveNum = jQuery("#"+fieldid).val();
		if(leaveNum == "" || leaveNum == null){
			var upid = fieldid.substr(5);
			jQuery("#field_upload_"+upid).attr("disabled","disabled");
		}
	}, function () {}, 320, 90,true);
  }

 function onChangeSharetype(delspan,delid,ismand,Uploadobj){
	fieldid=delid.substr(0,delid.indexOf("_"));
    linknum=delid.substr(delid.lastIndexOf("_")+1);
	fieldidnum=fieldid+"_idnum_1";
	fieldidspan=fieldid+"span";
    delfieldid=fieldid+"_id_"+linknum;
    if($GetEle(delspan).style.visibility=='visible'){
      $GetEle(delspan).style.visibility='hidden';
      $GetEle(delid).value='0';
	  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)+1;
        var tempvalue=$GetEle(fieldid).value;
          if(tempvalue==""){
              tempvalue=$GetEle(delfieldid).value;
          }else{
              tempvalue+=","+$GetEle(delfieldid).value;
          }
	     $GetEle(fieldid).value=tempvalue;
    }else{
      $GetEle(delspan).style.visibility='visible';
      $GetEle(delid).value='1';
	  $GetEle(fieldidnum).value=parseInt($GetEle(fieldidnum).value)-1;
        var tempvalue=$GetEle(fieldid).value;
        var tempdelvalue=","+$GetEle(delfieldid).value+",";
          if(tempvalue.substr(0,1)!=",") tempvalue=","+tempvalue;
          if(tempvalue.substr(tempvalue.length-1)!=",") tempvalue+=",";
          tempvalue=tempvalue.substr(0,tempvalue.indexOf(tempdelvalue))+tempvalue.substr(tempvalue.indexOf(tempdelvalue)+tempdelvalue.length-1);
          if(tempvalue.substr(0,1)==",") tempvalue=tempvalue.substr(1);
          if(tempvalue.substr(tempvalue.length-1)==",") tempvalue=tempvalue.substr(0,tempvalue.length-1);
	     $GetEle(fieldid).value=tempvalue;
    }
	//alert($GetEle(fieldidnum).value);
	if (ismand=="1")
	  {
	if ($GetEle(fieldidnum).value=="0")
	  {
	    $GetEle(fieldid).value="";
	    var swfuploadid=fieldid.replace("field","");
	  //alert("swfuploadid = "+swfuploadid);
	    var fieldidspannew = "field_"+swfuploadid+"span";
	    var fieldidnew = "field"+swfuploadid;
	    var linkrequired=$GetEle("oUpload_"+swfuploadid+"_linkrequired");
	    $GetEle(fieldidspannew).innerHTML="";
        if(Uploadobj.getStats().files_queued==0){
        	$GetEle(fieldidspannew).innerHTML="（<%=SystemEnv.getHtmlLabelName(18019, user.getLanguage())%>）";
			var checkstr_=$GetEle("needcheck").value+",";
			if(checkstr_.indexOf("field"+fieldidnew+",")<0) $GetEle("needcheck").value=checkstr_+fieldidnew;
        }
        if(linkrequired && linkrequired.value=="false"){
        	$GetEle(fieldidspannew).innerHTML="";
        }
	  }
	  else
	  {
		  var swfuploadid=fieldid.replace("field","");
		  	 //alert("swfuploadid = "+swfuploadid);
		  var fieldidspannew = "field_"+swfuploadid+"span";
		 $GetEle(fieldidspannew).innerHTML="";
	  }
	  }else{//add by td78113
		  var swfuploadid=fieldid.replace("field","");
		    var fieldidnew = "field"+swfuploadid;
		    var fieldidspannew = "field_"+swfuploadid+"span";
			if(jQuery("#"+fieldidnew).attr("viewtype")=="1"){
				if(Uploadobj.getStats().files_queued==0){
					$GetEle(fieldidspannew).innerHTML="（<%=SystemEnv.getHtmlLabelName(18019, user.getLanguage())%>）";
					var checkstr_=$GetEle("needcheck").value+",";
					if(checkstr_.indexOf("field"+fieldidnew+",")<0) $GetEle("needcheck").value=checkstr_+fieldidnew;
			    }
			}
	  	displaySWFUploadError(fieldid);
	  }
  }
function checkReportData(src){
		var reportUserId="";
		var crmId="";
		var year="";
		var month="";
		var day="";
		var date="";
		var checkReportDataReturnflag = false;
        <%if(!newReportUserId.equals("")&&!newCrmId.equals("")){%>
        if($GetEle("<%=newReportUserId%>")!=null){
			reportUserId=$GetEle("<%=newReportUserId%>").value;
		}
        if($GetEle("<%=newCrmId%>")!=null){
			crmId=$GetEle("<%=newCrmId%>").value;
		}
        if($GetEle("year")!=null){
			year=$GetEle("year").value;
		}
		if($GetEle("month")!=null){
			month=$GetEle("month").value;
		}
		if($GetEle("day")!=null){
			day=$GetEle("day").value;
		}
		if($GetEle("date")!=null){
			date=$GetEle("date").value;
		}
		StrData="requestid=<%=requestid%>&formid=<%=formid%>&reportUserId="+reportUserId+"&crmId="+crmId+"&year="+year+"&month="+month+"&day="+day+"&date="+date+"&src="+src;
        if($GetEle("checkReportDataForm")!=null){
			$GetEle("checkReportDataForm").src="checkReportDataForm.jsp?"+StrData;
		}else{
            checkReportDataReturnflag = checkReportDataReturn(0,"","",src);
        }
        <%}else{%>
        checkReportDataReturnflag = checkReportDataReturn(0,"","",src);
        <%}%>
        if(checkReportDataReturnflag === true){
	        return true;
	    }
	}
function checkReportDataReturn(ret,thedate,dspdate,src){

		if(ret==1||ret==2){
			displayAllmenu();
			alert(dspdate+" "+"<%=SystemEnv.getHtmlLabelName(20775,user.getLanguage())%>");
			return false;
		}
		if(src=="save"){
                    $GetEle("frmmain").src.value='save';
                    jQuery($GetEle("flowbody")).attr("onbeforeunload", "");


            //保存签章数据
            <%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
            			try{  
					        if(typeof(eval("SaveSignature_save"))=="function"){
					               //保存时不验证必填
                                    if(SaveSignature_save()||!SaveSignature_save()){
<%
    if(ismode.equals("1")){
%>
                                        contentBox = $GetEle("divFavContent18979");
                                        showObjectPopup(contentBox)
<%
    }else{
%>
                                        var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                                        showPrompt(content);
<%
    }
%>
                                        if(objSubmit!=""){
                                        	objSubmit.disabled=true;
                                        }
                                        //附件上传
                                        StartUploadAll();
                                        checkuploadcomplet();
                                    }else{
                                        if(isDocEmpty==1){              
                                        	alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
										    //自动跳到签字意见锚点
											window.location.hash = "#fsUploadProgressannexuploadSimple";//重置锚点,否则,下次将不能定位

											window.location.hash = null;
											jQuery("#remarkShadowDiv").hide();
											jQuery("#signrighttool").css("display","");
											jQuery(".signaturebyhand").css("display","");
											isDocEmpty=0;
                                        }else{
                                        	alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
                                        }
	                                    displayAllmenu();
                                        return ;
                                    }
					        }
					    }catch(e){
					        <%
    if(ismode.equals("1")){
%>
                                        contentBox = $GetEle("divFavContent18979");
                                        showObjectPopup(contentBox)
<%
    }else{
%>
                                        var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                                        showPrompt(content);
<%
    }
%>
                                        if(objSubmit!=""){
                                        	objSubmit.disabled=true;
                                        }
                                        //附件上传
                                        StartUploadAll();
                                        checkuploadcomplet();
					    }
                                   
            <%}else{%>
<%
    if(ismode.equals("1")){
%>
                                    contentBox = $GetEle("divFavContent18979");
                                    showObjectPopup(contentBox)
<%
    }else{
%>
                                    var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                                    showPrompt(content);
<%
    }
%>
                                    if(objSubmit!=""){
                                    	objSubmit.disabled=true;
                                    }
                                    //附件上传
                                    StartUploadAll();
                                    checkuploadcomplet();
            <%}%>

		}else if(src=="submit"){
            showtipsinfo(<%=requestid%>,<%=workflowid%>,<%=nodeid%>,<%=isbill%>,0,<%=billid%>,objSubmit,"submit","<%=ismode%>","divFavContent18978","<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>");
		}else if(src=="Affirmance"){
                $GetEle("frmmain").src.value='save';
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231

            <%
                        topage = URLEncoder.encode(topage) ;
                        String url = URLEncoder.encode("ViewRequest.jsp?isaffirmance=1&reEdit=0&f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+usertype+"&fromFlowDoc="+fromFlowDoc+"&topage="+topage);
                        %>
                        var isSubmitDirect = "";
                        if($G("SubmitToNodeid")) {
                            if($G("SubmitToNodeid").value != "") {
                            	isSubmitDirect = "1";
                            }
                     	}
                $GetEle("frmmain").topage.value="<%=url%>" + "%26isSubmitDirect%3D" + isSubmitDirect;
//保存签章数据
            <%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
            			try{  
					        if(typeof(eval("SaveSignature"))=="function"){
					              if(SaveSignature()){

<%
    if(ismode.equals("1")){
%>
                                        contentBox = $GetEle("divFavContent18979");
                                        showObjectPopup(contentBox)
<%
    }else{
%>
                                        var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                                        showPrompt(content);
<%
    }
%>
                                        //TD4262 增加提示信息  结束
                                        if(objSubmit!=""){
                                        	objSubmit.disabled=true;
                                        }
                                        //附件上传
                                        StartUploadAll();
                                        checkuploadcomplet();
                                    }else{
	                                    if(isDocEmpty==1){
	                                    	alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
                                        	//自动跳到签字意见锚点
											window.location.hash = "#fsUploadProgressannexuploadSimple";//重置锚点,否则,下次将不能定位

											window.location.hash = null;
											jQuery("#remarkShadowDiv").hide();
											jQuery("#signrighttool").css("display","");
											jQuery(".signaturebyhand").css("display","");
                                        	isDocEmpty=0;
                                        }else{
                                        	alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
                                        }
	                                    displayAllmenu();
                                        return ;
                                    }
					        }
					    }catch(e){
					        <%
    if(ismode.equals("1")){
%>
                                        contentBox = $GetEle("divFavContent18979");
                                        showObjectPopup(contentBox)
<%
    }else{
%>
                                        var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                                        showPrompt(content);
<%
    }
%>
                                        //TD4262 增加提示信息  结束
                                        if(objSubmit!=""){
                                        	objSubmit.disabled=true;
                                        }
                                        //附件上传
                                        StartUploadAll();
                                        checkuploadcomplet();
					    }
                                    
            <%}else{%>
<%
    if(ismode.equals("1")){
%>
                                    contentBox = $GetEle("divFavContent18979");
                                    showObjectPopup(contentBox)
<%
    }else{
%>
                                    var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                                    showPrompt(content);
<%
    }
%>
                                    //TD4262 增加提示信息  结束
                                    if(objSubmit!=""){
                                    	objSubmit.disabled=true;
                                    }
                                    //附件上传
                                    StartUploadAll();
                                    checkuploadcomplet();
            <%}%>
		}
		return true;
	}

function showtipsinfo(requestid,workflowid,nodeid,isbill,isreject,billid,obj,src,ismode,divcontent,content){
		var nowtarget = frmmain.target;
		var nowaction = frmmain.action;

		$GetEle("divcontent").value=divcontent;
		$GetEle("content").value=content;
		$GetEle("src").value=src;
		<%if("".equals(operationpage)){%>
		    frmmain.target = "showtipsinfoiframe";
		<%}%>
        try{
	        if(!jQuery(frmmain).find('#isFirstSubmit')[0]){
	            jQuery(frmmain).append("<input type='hidden' name='isFirstSubmit' id='isFirstSubmit' value =''>");  
	        }
	        jQuery(frmmain).find('#isFirstSubmit').val('0');
		}catch(e){
            if(!jQuery(frmmain).find('id=["isFirstSubmit"]')[0]){
                jQuery(frmmain).append("<input type='hidden' name='isFirstSubmit' id='isFirstSubmit' value =''>");  
            }
            jQuery(frmmain).find('id=["isFirstSubmit"]').val('0');
		}
		/*
			frmmain.action = "/workflow/request/WorkflowTipsinfo.jsp";
			frmmain.submit();
	
			frmmain.target = nowtarget;
			frmmain.action = nowaction;
		*/	
    	showtipsinfoReturn("", src, ismode, divcontent, content, "");
}


function showtipsinfoReturn(returnvalue,src,ismode,divcontent,content,messageLabelName){

	obj="";
            try{
                if(messageLabelName!=""){
					alert(messageLabelName);
					return ;
				}
            }catch(e){}
            try{
                tipsinfo=returnvalue;
                if(tipsinfo!=""){
                    if(confirm(tipsinfo)){
                        $GetEle("frmmain").src.value=src;
                        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");


                        //保存签章数据
                        <%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
                        try{  
					        if(typeof(eval("SaveSignature"))=="function"){
					              if(SaveSignature(src)){
		                                if(ismode=="1"){
		                                    contentBox = $GetEle(divcontent);
		                                    showObjectPopup(contentBox)
		                                   }else{
		                                    showPrompt(content);
		                                }
		                                if(obj!=""){
		                                    obj.disabled=true;
		                                }
		                                //附件上传
		                                //StartUploadAll();
		                                //checkuploadcomplet();
                           				doctopdfandsubmit();
		                            }else{
									if(isDocEmpty==1){
										alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
										//自动跳到签字意见锚点
										window.location.hash = "#fsUploadProgressannexuploadSimple";//重置锚点,否则,下次将不能定位

										window.location.hash = null;
										jQuery("#remarkShadowDiv").hide();
										jQuery("#signtabtoolbar").css("display","");
										jQuery("#signrighttool").css("display","");
										jQuery(".signaturebyhand").css("display","");
										isDocEmpty=0;
									}else{
										alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
									}
										displayAllmenu();
		                                return ;
		                            }
					        }
					    }catch(e){
					        if(ismode=="1"){
		                                    contentBox = $GetEle(divcontent);
		                                    showObjectPopup(contentBox)
		                                   }else{
		                                    showPrompt(content);
		                                }
		                                if(obj!=""){
		                                    obj.disabled=true;
		                                }
		                                //附件上传
		                                //StartUploadAll();
		                                //checkuploadcomplet(); 
                           				doctopdfandsubmit();
					    }
                            
                        <%}else{%>
                            if(ismode=="1"){
                                contentBox = $GetEle(divcontent);
                                showObjectPopup(contentBox)
                            }else{
                                showPrompt(content);
                            }
                            if(obj!=""){
                                obj.disabled=true;
                            }
                            //附件上传
                            //StartUploadAll();
                            //checkuploadcomplet();
                           	doctopdfandsubmit();
                        <%}%>
                    }else{
						displayAllmenu();
						hiddenPrompt();
                        return ;
					}
                }else{
                    $GetEle("frmmain").src.value=src;
                        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");


                        //保存签章数据
                        <%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){ %>
                        try{  
					        if(typeof(eval("SaveSignature"))=="function"){
					              if(SaveSignature(src)){
                                if(ismode=="1"){
                                    contentBox = $GetEle(divcontent);
                                    showObjectPopup(contentBox)
                                }else{
                                    showPrompt(content);
                                }
                                if(obj!=""){
                                    obj.disabled=true;
                                }
                                //附件上传
                                //StartUploadAll();
                                //checkuploadcomplet();
                           		doctopdfandsubmit();
                            }else{
                                if(isDocEmpty==1){
                                	alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
									//自动跳到签字意见锚点
									window.location.hash = "#fsUploadProgressannexuploadSimple";//重置锚点,否则,下次将不能定位

									window.location.hash = null;
									jQuery("#remarkShadowDiv").hide();
									jQuery("#signtabtoolbar").css("display","");
									jQuery("#signrighttool").css("display","");
									jQuery(".signaturebyhand").css("display","");                                	
                                	isDocEmpty=0;
                                }else{
                                	alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
                                }
                                displayAllmenu();
                                return ;
                            }
					        }
					    }catch(e){
					        if(ismode=="1"){
                                    contentBox = $GetEle(divcontent);
                                    showObjectPopup(contentBox)
                                }else{
                                    showPrompt(content);
                                }
                                if(obj!=""){
                                    obj.disabled=true;
                                }
                                //附件上传
                                //StartUploadAll();
                                //checkuploadcomplet(); 
                           		doctopdfandsubmit();
					    }
                            
                        <%}else{%>
                            if(ismode=="1"){
                                contentBox = $GetEle(divcontent);
                                showObjectPopup(contentBox)
                            }else{
                                showPrompt(content);
                            }
                            if(obj!=""){
                                obj.disabled=true;
                            }
                            //附件上传
                           	doctopdfandsubmit();
                        <%}%>
                }
            }catch(e){}
}



<%
int currentnodeid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"currentnodeid"),0);

Map  texttoPDFMap=TexttoPDFManager.getTexttoPDFMap(requestid, workflowid, currentnodeid,0);
boolean	showSignatureAPI="1".equals((String)texttoPDFMap.get("showSignatureAPI"))?true:false;
boolean	isSavePDF="1".equals((String)texttoPDFMap.get("isSavePDF"))?true:false;
boolean	isSaveDecryptPDF="1".equals((String)texttoPDFMap.get("isSaveDecryptPDF"))?true:false;

	//attachmentList=(List)texttoPDFMap.get("attachmentList");
String isTexttoPDF="0";
if(isSavePDF||isSaveDecryptPDF){
isTexttoPDF="1";
}
String pdffieldid=Util.null2String((String)texttoPDFMap.get("pdffieldid"));
String pdfdocId=Util.null2String((String)texttoPDFMap.get("pdfdocId"));
String versionId=Util.null2String((String)texttoPDFMap.get("versionId"));
int operationtype=Util.getIntValue((String)texttoPDFMap.get("operationtype"),0);
String decryptpdffieldid=Util.null2String((String)texttoPDFMap.get("decryptpdffieldid"));
%>
function doctopdfandsubmit(){

	if("<%=isTexttoPDF%>"=="1"&&"<%=operationtype%>"=="1"){
	    document.getElementById("showtipsinfoiframe").src="/docs/docs/DocEditExt.jsp?id=<%=pdfdocId%>&fromFlowDocsubm=1&fromFlowDoc=1&requestid=<%=requestid%>&workflowid=<%=workflowid%>&fromFlowDocsubm=1";

	}else{
		StartUploadAll();
		checkuploadcomplet();
	}
}

function doctopdfandsubmitReturn(returnvalue,pdfDocId,DecryptpdfDocId){
	if(returnvalue==1){
		if(pdfDocId>0){
	    document.getElementById("field<%=pdffieldid%>").value=pdfDocId;
		}
		if(DecryptpdfDocId>0){
	    document.getElementById("field<%=decryptpdffieldid%>").value=DecryptpdfDocId;
		}
		StartUploadAll();
		checkuploadcomplet();
	}else{
	    //姝ｆ枃杞琍DF寮傚父锛屾槸鍚︿緷鐒舵彁浜ゆ祦绋嬶紵
	    if(confirm("<%=SystemEnv.getHtmlLabelName(125968 ,user.getLanguage())%>?")){
		    StartUploadAll();
		    checkuploadcomplet();
	    }else{
		    displayAllmenu();
		    return ;
	    }
	}
}
function doStop(obj){
	//您确定要暂停当前流程吗?
	if(confirm("<%=SystemEnv.getHtmlLabelName(26156,user.getLanguage())%>?")){
		jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
		enableAllmenu();
		document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&flag=stop&requestid=<%=requestid%>" //xwj for td3665 20060224
	}
	else
	{
		displayAllmenu();
		return false;
	}
}
function doCancel(obj){
	//您确定要撤销当前流程吗?
	if(confirm("<%=SystemEnv.getHtmlLabelName(26157,user.getLanguage())%>?")){
		jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
		enableAllmenu();
		document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&flag=cancel&requestid=<%=requestid%>" //xwj for td3665 20060224
	}
	else
	{
		displayAllmenu();
		return false;
	}
}
function doRestart(obj)
{
	//您确定要启用当前流程吗?
	if(confirm("<%=SystemEnv.getHtmlLabelName(26158,user.getLanguage())%>?")){
		jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
		enableAllmenu();
		document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&flag=restart&requestid=<%=requestid%>" //xwj for td3665 20060224
	}
	else
	{
		displayAllmenu();
		return false;
	}
}
</script>
<!--
<script type="text/javascript">
//---------------------------------------
// 此script元素内德code均是从vbscript转换而来
//---------------------------------------
//<!--
function onShowBrowser(id, url, linkurl, type1, ismand) {
	if (type1 == 2 || type1 == 19) {
		id1 = window.showModalDialog(url, "", "dialogHeight:320px;dialogwidth:275px");

		$GetEle("field" + id + "span").innerHTML = id1;
		$GetEle("field" + id).value = id1;
	} else {
		if (type1 != 162 && type1 != 171 && type1 != 152 && type1 != 142
				&& type1 != 135 && type1 != 17 && type1 != 18 && type1 != 27
				&& type1 != 37 && type1 != 56 && type1 != 57 && type1 != 65
				&& type1 != 165 && type1 != 166 && type1 != 167 && type1 != 168
				&& type1 != 4 && type1 != 167 && type1 != 164 && type1 != 169
				&& type1 != 170) {
			id1 = window.showModalDialog(url);
		} else {
			if (type1 == 135) {
				var tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?projectids=" + tmpids);
			} else if (type1 == 4 || type1 == 167 || type1 == 164
					|| type1 == 169 || type1 == 170) {
				var tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?selectedids=" + tmpids);
			} else if (type1 == 37) {
				var tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?documentids=" + tmpids);
			} else if (type1 == 142) {
				var tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?receiveUnitIds=" + tmpids);
			} else if (type1 == 162) {
				var tmpids = $GetEle("field" + id).value;
				url = url + "&beanids=" + tmpids;
				url = url.substring(0, url.indexOf("url=") + 4) + url.substr(url.indexOf("url=") + 4);
				id1 = window.showModalDialog(url);
			} else if (type1 == 165 || type1 == 166 || type1 == 167
					|| type1 == 168) {
				var index = id.indexOf("_");
				if (index != -1) {
					var tmpids = uescape("?isdetail=1&isbill=<%=isbill%>&fieldid="
							+ id.substring(0, index) + "&resourceids="
							+ $GetEle("field" + id).value);
					id1 = window.showModalDialog(url + tmpids);
				} else {
					var tmpids = uescape("?fieldid=" + id
							+ "&isbill=<%=isbill%>&resourceids="
							+ $GetEle("field" + id).value);
					id1 = window.showModalDialog(url + tmpids);
				}
			} else {
				var tmpids = $GetEle("field" + id).value;
				id1 = window.showModalDialog(url + "?resourceids=" + tmpids);
			}
		}
		if (id1) {
			if (type1 == 171 || type1 == 152 || type1 == 142 || type1 == 135
					|| type1 == 17 || type1 == 18 || type1 == 27 || type1 == 37
					|| type1 == 56 || type1 == 57 || type1 == 65
					|| type1 == 166 || type1 == 168 || type1 == 170) {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
					var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
					var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
					var sHtml = "";
					resourceids = resourceids.substr(1);
					resourcename = resourcename.substr(1);
					$GetEle("field" + id).value = resourceids;
					
					var resourceidArray = resourceids.split(",");
					var resourcenameArray = resourcename.split(",");
					
					for (var _i=0; _i<resourceidArray.length; _i++) {
						var curid = resourceidArray[_i];
						var curname = resourcenameArray[_i];
						
						if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
							sHtml = sHtml + "<a href=javaScript:openhrm(" + curid + "); onclick='pointerXY(event);'>" + curname + "</a>&nbsp";
						} else {
							sHtml = sHtml + "<a href=" + linkurl + curid + ">" + curname + "</a>&nbsp";
						}
					}
					
					$GetEle("field" + id + "span").innerHTML = sHtml;
				} else {
					if (ismand == 0) {
						$GetEle("field" + id + "span").innerHTML = "";
					} else {
						$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
					}
					$GetEle("field" + id).value = "";
				}

			} else {
				if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
					if (linkurl == "") {
						$GetEle("field" + id + "span").innerHTML = wuiUtil.getJsonValueByIndex(id1, 1);
					} else {
						if (linkurl == "/hrm/resource/HrmResource.jsp?id=") {
							$GetEle("field" + id + "span").innerHTML = "<a href=javaScript:openhrm(" 
									+ wuiUtil.getJsonValueByIndex(id1, 0)
									+ "); onclick='pointerXY(event);'>"
									+ wuiUtil.getJsonValueByIndex(id1, 1) + "</a>&nbsp";
						} else {
							$GetEle("field" + id + "span").innerHTML = "<a href="
									+ linkurl + wuiUtil.getJsonValueByIndex(id1, 0) + ">" + wuiUtil.getJsonValueByIndex(id1, 1) + "</a>";
						}

					}
					$GetEle("field" + id).value = wuiUtil.getJsonValueByIndex(id1, 0);
				} else {
					if (ismand == 0) {
						$GetEle("field" + id + "span").innerHTML = "";
					} else {
						$GetEle("field" + id + "span").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
					}
					$GetEle("field" + id).value = "";
				}
			}
		}
	}
}

function onShowSignBrowserFormSignature(url, linkurl, inputname, spanname, type1) {
	var tmpids = $GetEle(inputname).value;
	if (type1 == 37) {
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url
				+ "?documentids=" + tmpids);
	} else {
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=" + url
				+ "?resourceids=" + tmpids);
	}
	if (id1) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";
			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);
			$GetEle(inputname).value = resourceids;
			
			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");
			
			
			for (var _i=0; _i<resourceidArray.length; _i++) {
				var curid = resourceidArray[_i];
				var curname = resourcenameArray[_i];
				
				sHtml = sHtml + "<a href=" + linkurl + curid
						+ " target='_blank'>" + curname + "</a>&nbsp";
			}
			$GetEle(spanname).innerHTML = sHtml;

		} else {
			$GetEle(spanname).innerHTML = "";
			$GetEle(inputname).value = "";
		}
	}
}

function onShowMutiHrm(spanname, inputename) {
	tmpids = $GetEle(inputename).value;
	id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="
					+ tmpids);
	if (id1) {
		if (wuiUtil.getJsonValueByIndex(id1, 0) != "") {
			var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
			var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
			var sHtml = "";
			resourceids = resourceids.substr(1);
			resourcename = resourcename.substr(1);
			
			$GetEle(inputename).value = resourceids;
			var resourceidArray = resourceids.split(",");
			var resourcenameArray = resourcename.split(",");
			for (var _i=0; _i<resourceidArray.length; _i++) {
				var curid = resourceidArray[_i];
				var curname = resourcenameArray[_i];
				
				sHtml = sHtml + "<A href='javaScript:openhrm(" + curid
						+ ");' onclick='pointerXY(e);'>" + curname
						+ "</a>&nbsp";
			}
			
			$GetEle(spanname).innerHTML = sHtml;

		} else {
			$GetEle(spanname).innerHTML = "<button type=button  class=Browser onclick=onShowMutiHrm('Intervenorspan','Intervenorid') ></button><img src='/images/BacoError_wev8.gif' align=absmiddle>";
			$GetEle(inputename).value = "";
		}
	}
}

</script>
-->
<!-- 
<style type="text/css">
TABLE.ListStyle tbody tr td {
	padding: 4px 5px 0px 5px!important;
}
</style>
 -->
<script type="text/javascript" src="/js/jquery/plugins/client/jquery.client_wev8.js"></script>
<script type="text/javascript" src="/js/wfsp_wev8.js"></script>

<%@ include file="/workflow/request/WorkflowViewSignShow.jsp" %>
<script type="text/javascript">
function checkCarSubmit(){
	var flag = false;
	jQuery.ajax({
	    type:"post",
		url: "/cpt/car/CarSetDataOperation.jsp?action=getData",
		data: {workflowid:'<%=workflowid%>'},
		async: false, 
		dataType: "json",
		success: function(returndata){
			if(returndata&&returndata.length>0){
				var iscontinue = returndata[0].iscontinue;
				var remindtype = returndata[0].remindtype; 
				if(iscontinue=='yes'){
					var field627 = returndata[0].field627; //车辆
					var field628 = returndata[0].field628; //司机
					var field629 = returndata[0].field629; //用车人
					var field634 = returndata[0].field634; //开始日期
					var field635 = returndata[0].field635; //开始时间
					var field636 = returndata[0].field636; //结束日期
					var field637 = returndata[0].field637; //结束时间
					var field638 = returndata[0].field638; //撤销
					
					field627 = jQuery("#field"+field627).val();
					field634 = jQuery("#field"+field634).val();
					field635 = jQuery("#field"+field635).val();
					field636 = jQuery("#field"+field636).val();
					field637 = jQuery("#field"+field637).val();
					jQuery.ajax({
					    type:"post",
						url: "/cpt/car/CarSetDataOperation.jsp?action=checkData",
						data: {field627:field627,field634:field634,field635:field635,field636:field636,field637:field637,workflowid:'<%=workflowid%>',requestid:'<%=requestid%>'},
						async: false, 
						dataType: "json",
						success: function(returnjson){
							if(returnjson&&returnjson.length>0){
								iscontinue = returnjson[0].iscontinue;
								if(iscontinue=="no"){
									if(remindtype=="0"){ //提醒不做处理
									    if(confirm("<%=SystemEnv.getHtmlLabelName(128307,user.getLanguage())%>")==true){
									        flag = true;
									    }else{
									        flag = false;
									    }
									}else{//禁止提交
										alert("<%=SystemEnv.getHtmlLabelName(128308,user.getLanguage())%>");
										flag = false;
									}
								}else{
									flag = true;
								}
							}
						}
					});
				}else{
					flag = true;
				}
			}
		}
	});
	return flag;
}
</script>