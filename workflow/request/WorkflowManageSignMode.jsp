
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.workflow.request.WFPathUtil"%> 

<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browserTag" prefix="brow"%>

<%@ page import="weaver.general.Util,weaver.general.BaseBean" %>
<%@ page import="weaver.general.AttachFileUtil" %>
<%@ page import="weaver.conn.*" %>
<%@ page import="java.util.*" %>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%--@ page import="java.sql.Timestamp" --%>

<jsp:useBean id="RecordSetlog3" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>
<%@page import = "weaver.general.TimeUtil"%>
<%@ page import="weaver.workflow.request.ComparatorUtilBean"%>
<!--added by xwj for td2891-->
<jsp:useBean id="rsCheckUserCreater" class="weaver.conn.RecordSet" scope="page" /> <%-- added by xwj for td2891--%>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<!--jsp:useBean id="RequestCheckUser" class="weaver.workflow.request.RequestCheckUser" scope="page"/-->
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<!--jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" /-->
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="docinf" class="weaver.docs.docs.DocComInfo" scope="page" />
<jsp:useBean id="wfrequestcominfo" class="weaver.workflow.workflow.WorkflowRequestComInfo" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />
<jsp:useBean id="WorkflowPhrase" class="weaver.workflow.sysPhrase.WorkflowPhrase" scope="page"/>
<jsp:useBean id="RecordSetLog" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog1" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<jsp:useBean id="RecordSetLog2" class="weaver.conn.RecordSet" scope="page" /><%--xwj for td2140  2005-07-25 --%>
<!--jsp:useBean id="RecordSetOld" class="weaver.conn.RecordSet" scope="page" /--> <%-- xwj for td2104 on 20050802--%>
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="requestNodeFlow" class="weaver.workflow.request.RequestNodeFlow" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="page"/>
<jsp:useBean id="RequestUseTempletManager" class="weaver.workflow.request.RequestUseTempletManager" scope="page" />
<jsp:useBean id="RequestSignatureManager" class="weaver.workflow.request.RequestSignatureManager" scope="page" />
<jsp:useBean id="TexttoPDFManager" class="weaver.workflow.request.TexttoPDFManager" scope="page" />


<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<!--
移动到 /css/ecology8/requestIframe2_wev8.css 中

<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<link type="text/css" rel="stylesheet" href="/js/ecology8/weaverautocomplete/css/weaverautocomplete_wev8.css">
 -->
<script type="text/javascript" src="/js/ecology8/weaverautocomplete/weaverautocomplete_wev8.js"></script>


<script type="text/javascript" src="/js/swfupload/swfupload_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/swfupload.queue_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/fileprogress_wev8.js"></script>
<script type="text/javascript" src="/js/swfupload/handlers_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/workflowshowpaperchange_wev8.js"></script>
<script type="text/javascript" src="/js/odoc/common/commonjs.js"></script>
<!--
移动到 /css/ecology8/requestIframe2_wev8.css 中

<link rel="stylesheet" type="text/css" href="/wui/common/js/ckeditor/skins/kama/editor1_wev8.css" />
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowshow_wev8.css" />
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowcop_wev8.css" />

<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />
-->
<!-- ie8/ie9问题 -->
<link rel="stylesheet" href="/css/ecology8/requestIframe2_wev8.css" type="text/css" />
<%

/*用户验证*/
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
User user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
int userid=user.getUID();                   //当前用户id
if(user==null) {
    response.sendRedirect("/login/Login.jsp");
    return;
}
//TD9892
BaseBean bb_workflowMSmode = new BaseBean();
int urm_workflowMSmode = 1;
try{
	urm_workflowMSmode = Util.getIntValue(bb_workflowMSmode.getPropValue("systemmenu", "userightmenu"), 1);
}catch(Exception e){}

int requestid = Util.getIntValue(request.getParameter("requestid"),0);
int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
String nodetype= Util.null2String(request.getParameter("nodetype"));
String isremark=Util.null2String(request.getParameter("isremark"));
String isOldWf=Util.null2String(request.getParameter("isOldWf"));

boolean isOldWf_ = false;
if(isOldWf.trim().equals("true")) isOldWf_=true;
String creatername="";
// 操作的用户信息

//int userid=user.getUID();                   //当前用户id
String logintype = user.getLogintype();     //当前用户类型  1: 类别用户  2:外部用户
String username = "";

if(logintype.equals("1"))
	username = Util.toScreen(ResourceComInfo.getResourcename(""+userid),user.getLanguage()) ;
if(logintype.equals("2"))
	username = Util.toScreen(CustomerInfoComInfo.getCustomerInfoname(""+userid),user.getLanguage());
int workflowid=Util.getIntValue(request.getParameter("workflowid"),0);           //工作流id



int currentnodeid=Util.getIntValue((String)session.getAttribute(userid+"_"+requestid+"currentnodeid"),0);
Map  texttoPDFMap=TexttoPDFManager.getTexttoPDFMap(requestid, workflowid, currentnodeid,0);
boolean	showSignatureAPI="1".equals((String)texttoPDFMap.get("showSignatureAPI"))?true:false;
boolean	isSavePDF="1".equals((String)texttoPDFMap.get("isSavePDF"))?true:false;
boolean	isSaveDecryptPDF="1".equals((String)texttoPDFMap.get("isSaveDecryptPDF"))?true:false;
String isTexttoPDF="0";
if(isSavePDF||isSaveDecryptPDF){
	isTexttoPDF="1";
}
String pdffieldid=Util.null2String((String)texttoPDFMap.get("pdffieldid"));
String pdfdocId=Util.null2String((String)texttoPDFMap.get("pdfdocId"));
String versionId=Util.null2String((String)texttoPDFMap.get("versionId"));
int operationtype=Util.getIntValue((String)texttoPDFMap.get("operationtype"),0);
String decryptpdffieldid=Util.null2String((String)texttoPDFMap.get("decryptpdffieldid"));




String currentdate= Util.null2String(request.getParameter("currentdate"));
String currenttime= Util.null2String(request.getParameter("currenttime"));
String needcheck="";
String needconfirm="";
String isSignDoc_edit="";
String isSignWorkflow_edit="";
String isannexupload_edit="";
String annexdocCategory_edit="";
RecordSetLog.execute("select needAffirmance,isannexupload,annexdocCategory,isSignDoc,isSignWorkflow from workflow_base where id="+workflowid);
if(RecordSetLog.next()){
    needconfirm=Util.null2o(RecordSetLog.getString("needAffirmance"));
    isannexupload_edit=Util.null2String(RecordSetLog.getString("isannexupload"));
    annexdocCategory_edit=Util.null2String(RecordSetLog.getString("annexdocCategory"));
    isSignDoc_edit=Util.null2String(RecordSetLog.getString("isSignDoc"));
    isSignWorkflow_edit=Util.null2String(RecordSetLog.getString("isSignWorkflow"));
}
String isSignMustInput="0";
String isHideInput="0";
RecordSetLog.execute("select issignmustinput,ishideinput from workflow_flownode where workflowid="+workflowid+" and nodeid="+nodeid);
if(RecordSetLog.next()){
	isSignMustInput = ""+Util.getIntValue(RecordSetLog.getString("issignmustinput"), 0);
	isHideInput = ""+Util.getIntValue(RecordSetLog.getString("ishideinput"), 0);
}

/**流程存为文档是否要签字意见**/
boolean fromworkflowtodoc = Util.null2String((String)session.getAttribute("urlfrom_workflowtodoc_"+requestid)).equals("true");
boolean ReservationSign = false;
RecordSet.executeSql("select * from workflow_base where id = " + workflowid);
if(RecordSet.next()) ReservationSign = (RecordSet.getInt("keepsign")==2);
if(fromworkflowtodoc&&ReservationSign){
	return;
}
/**流程存为文档是否要签字意见**/

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
<br>

<!--TD4262 增加提示信息  开始-->

<%
    if(ismode.equals("1")){
%>

<div id="divFavContent16332" style="display:none"><!--工作流信息保存错误-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(16332,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>

<div id="divFavContent16333" style="display:none"><!--工作流下一节点或下一节点操作者错误-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(16333,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>


<div id="divFavContent18978" style="display:none"><!--正在提交流程，请稍等....-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>

<div id="divFavContent18979" style="display:none"><!--正在保存流程，请稍等....-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>

<div id="divFavContent18980" style="display:none"><!--正在退回流程，请稍等....-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18980,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>

<div id="divFavContent18984" style="display:none"><!--正在删除流程，请稍等....-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(18984,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>

<div id="divFavContent24676" style="display:none"><!--流程数据已更改，请核对后再处理！-->
	<table cellspacing="0" cellpadding="0" border="0" width="100%" height="100%">
		<tr height="22">
			<td style="font-size:9pt"><%=SystemEnv.getHtmlLabelName(24676,user.getLanguage())%>
			</td>
		</tr>
	</table>
</div>
<%
    }else{
%>
<div id='_xTable' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<%
    }
%>
<!--TD4262 增加提示信息  结束-->
<div id='divshowreceivied' style='background:#FFFFFF;padding:3px;width:100%' valign='top'>
</div>
<iframe id="checkReportDataForm" frameborder=0 scrolling=no src="javascript:false"  style="display:none"></iframe>
<iframe id="showtipsinfoiframe" name="showtipsinfoiframe" frameborder=0 scrolling=no src="javascript:false"  style="display:none"></iframe>
<input type=hidden name="divcontent" value="">
<input type=hidden name="content" value="">

<table width="100%" id=t_sign>
<tr>
<td width="50%"  valign="top">
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
<input type=hidden name="RejectNodes" value="">
<input type=hidden name="RejectToNodeid" value="">
<input type=hidden name="RejectToType" id='RejectToType' value="0">
<input type=hidden name="SubmitToNodeid" value="">
<%
//模板中是否设置签字字段，如果设置了按模板模式显示，如果没有设置按以前模式显示
RecordSet.executeSql("select * from workflow_modeview where formid="+formid+" and nodeid="+nodeid+" and fieldid=-4");
String hasSign = "0";
if(RecordSet.next()){hasSign="1";}
%>
<%if(hasSign.equals("0")){%>
<input type=hidden name="workflowRequestLogId" value="-1">
<%}%>
<!-- added end. -->
<%--added by xwj for td 2104 on 2005-08-1 begin--%>
  <table class="viewform">
        <!-- modify by xhheng @20050308 for TD 1692 -->
         <COLGROUP>
         <COL width="20%">
         <COL width="80%">
         <%if(isremark.equals("5")){%>
         <tr><td colspan="2"><b><%=SystemEnv.getHtmlLabelName(18913,user.getLanguage())%></b></td></tr>
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
	<TR class=spacing>
            <TD class=line2 colSpan=2></TD>
        </TR>
         <tr>
             <td><%=SystemEnv.getHtmlLabelName(18915,user.getLanguage())%></td>
             <td class=field>
                 <span id="Intervenoridspan">
                     <%if(intervenoruserids.equals("")){%>
                     <button class=Browser onclick="onShowMutiHrm('Intervenoridspan','Intervenorid')" ></button>
                     <%}%><%=intervenorusernames%><%if(intervenorusernames.equals("")){%><img src='/images/BacoError_wev8.gif' align=absmiddle><%}%></span>
					 <input type=hidden name="IntervenoridType" value="<%=intervenoruseridsType%>">
                 <input type=hidden name="Intervenorid" id="Intervenorid" value="<%=intervenoruserids%>">
             </td>
         </tr>
	<TR class=spacing>
            <TD class=line2 colSpan=2></TD>
        </TR>
         <%
         }
         %>
         
         </table>
        </td>
        </tr>
        </table>
         <%
boolean IsBeForwardCanSubmitOpinion="true".equals(session.getAttribute(userid+"_"+requestid+"IsBeForwardCanSubmitOpinion"))?true:false;
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
if(hasSign.equals("0")&&IsBeForwardCanSubmitOpinion){
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
         if(RecordSet.next())
         {
            myremark = Util.null2String(RecordSet.getString("remark"));
            myremark = Util.StringReplace(myremark,"&lt;br&gt;","\n");
            annexdocids=Util.null2String(RecordSet.getString("annexdocids"));
			workflowRequestLogId=Util.getIntValue(RecordSet.getString("requestLogId"),-1);
			signdocids=Util.null2String(RecordSet.getString("signdocids"));
			signworkflowids=Util.null2String(RecordSet.getString("signworkflowids"));
         }
         //System.err.println("workflowmanagesignmode--->workflowRequestLogId:"+workflowRequestLogId);
         String signdocname="";
        String signworkflowname="";
        ArrayList templist=Util.TokenizerString(signdocids,",");
        for(int i=0;i<templist.size();i++){
            signdocname+="<a href='/docs/docs/DocDsp.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&isrequest=1&id="+templist.get(i)+"' target='_blank'>"+docinf.getDocname((String)templist.get(i))+"</a> ";
        }
        templist=Util.TokenizerString(signworkflowids,",");
        int tempnum = Util.getIntValue(String.valueOf(session.getAttribute("slinkwfnum")));
        for(int i=0;i<templist.size();i++){
                tempnum++;
                session.setAttribute("resrequestid" + tempnum, "" + templist.get(i));
            signworkflowname+="<a style=\"cursor:hand\" onclick=\"openFullWindowHaveBar('/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid="+userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&isrequest=1&requestid="+templist.get(i)+"&wflinkno="+tempnum+"')\">"+wfrequestcominfo.getRequestName((String)templist.get(i))+"</a> ";
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
         <%
       
}else{%>
         <script defer>
             function funcremark_log() {
             }
         </script>
<%}%>
        
        
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
<script language="javascript">
function isSign(fg) {
	queryData({"url":"/workflow/request/signatureCount.jsp","requestId":"<%=requestid %>","nodeId":"<%=nodeid %>","userId":"<%=user.getUID() %>","loginType":"<%=user.getLogintype() %>"},function(paramsObj,msg){
		fg.flag = msg[0].signatureCount;
	})
}
</script>
<input type="hidden" name="temphasUseTempletSucceed" id="temphasUseTempletSucceed" value="<%=hasUseTempletSucceed%>"/>
<input type="hidden" name="isUseTempletNode" id="isUseTempletNode" value="<%=isUseTempletNode%>"/>

<%--added by xwj for td 2104 on 2005-08-1 end--%>
<!--以下删除签字意见字段 by ben 2007-3-16-->

		           <%
boolean isLight = false;
int nLogCount=0;

/*--  xwj for td2104 on 20050802 B E G I N --*/
String viewLogIds = "";
ArrayList canViewIds = new ArrayList();
String viewNodeId = "-1";
String tempNodeId = "-1";
String singleViewLogIds = "-1";
char procflag=Util.getSeparator();
//RecordSetLog.executeSql("select distinct nodeid from workflow_currentoperator where requestid="+requestid+" and userid="+user.getUID());

if(nodeid>0){
viewNodeId = ""+nodeid;
RecordSetLog1.executeSql("select viewnodeids from workflow_flownode where workflowid=" + workflowid + " and nodeid="+viewNodeId);
if(RecordSetLog1.next()){
singleViewLogIds = RecordSetLog1.getString("viewnodeids");
}

if("-1".equals(singleViewLogIds)){//全部查看
RecordSetLog2.executeSql("select nodeid from workflow_flownode where workflowid= " + workflowid+" and exists(select 1 from workflow_nodebase where id=workflow_flownode.nodeid and (requestid is null or requestid="+requestid+"))");
while(RecordSetLog2.next()){
tempNodeId = RecordSetLog2.getString("nodeid");
if(!canViewIds.contains(tempNodeId)){
canViewIds.add(tempNodeId);
}
}
}
else if(singleViewLogIds == null || "".equals(singleViewLogIds)){//全部不能查看

}
else{//查看部分
String tempidstrs[] = Util.TokenizerString2(singleViewLogIds, ",");
for(int i=0;i<tempidstrs.length;i++){
if(!canViewIds.contains(tempidstrs[i])){
canViewIds.add(tempidstrs[i]);
}
}
}
}
if(canViewIds.size()>0){
for(int a=0;a<canViewIds.size();a++)
{
viewLogIds += (String)canViewIds.get(a) + ",";
}
viewLogIds = viewLogIds.substring(0,viewLogIds.length()-1);
}
else{
viewLogIds = "-1";
}
//RecordSet.executeProc("workflow_RequestLog_SNSave",""+requestid + procflag + "17,18");

/*----added by xwj for td2891 begin-----*/
//工作流id已经从页面获得到了，不需要从数据库中取，屏蔽掉。 mackjoe at 2006-06-12 td4491
/*
String tempWorkflowid = "-1";
String  sqlTemp ="select workflowid from workflow_requestbase where requestid ="+requestid;
RecordSet.executeSql(sqlTemp);
RecordSet.next();
tempWorkflowid = RecordSet.getString("workflowid");
*/
String sqlTemp = "select nodeid from workflow_flownode where workflowid = "+workflowid+" and nodetype = '0'";
RecordSet.executeSql(sqlTemp);
RecordSet.next();
String creatorNodeId = RecordSet.getString("nodeid");
/*----added by xwj for td2891 end-----*/
/*----added by chujun for td8883 start ----*/
WFManager.setWfid(workflowid);
WFManager.getWfInfo();
String orderbytype = Util.null2String(WFManager.getOrderbytype());
String orderby = "desc";
if("2".equals(orderbytype)){
	orderby = "asc";
}

/*----added by chujun for td8883 end ----*/
String viewNodeIdSQL = "select  t1.*, t2.nodename from workflow_requestlog t1,workflow_nodebase t2 "+
" where t1.requestid="+requestid+" and t1.nodeid=t2.id and t1.logtype != '1' " +
" and t1.nodeid in ("+ viewLogIds +") order by operatedate "+orderby+",operatetime "+orderby+"";
RecordSet.executeSql(viewNodeIdSQL);
/*--  xwj for td2104 on 20050802 E N D --*/

String lineNTdOne="";
String lineNTdTwo="";


%>

<%-- 该段代码已被屏蔽，现删除 --%>

  <script language="javascript">

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
    <!-- 点击被转发的提交按钮 -->
	
    {   

var ischeckok="true";
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
			 if("1".equals(hasSign)){
	    %>
	     if(ischeckok=="true"){
	        var wcell = frmmain.ChinaExcel;
	        var temprow4=wcell.GetCellUserStringValueRow("qianzi");
       	    var tempcol4=wcell.GetCellUserStringValueCol("qianzi");
       	    if(wcell.GetCellValue(temprow4,tempcol4) == ""){
       	         alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
       	         ischeckok="false";
       	    }
		  }
	    <%
	      }
		}else{
%>
            if(ischeckok=="true"){
            	if(!check_form(document.frmmain,'remarkText10404') || !check_form(document.frmmain,'remark')){
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
            $G("planDoRemark").click();
        }
        catch(e)
        {                
			if(checktimeok()) 
			{
		        document.frmmain.isremark.value='1';
		        document.frmmain.src.value='save';
		        
           		<%--added by xwj for td2104 on 2005-08-01--%>
                <%--$G("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;--%>
                
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201


            	//保存签章数据
<%if("1".equals(isFormSignature)&&"0".equals(hasSign)){%>
						try{  
					        if(typeof(eval("SaveSignature"))=="function"){
					               if(SaveSignature()){
					            //TD4262 增加提示信息  开始

								<%
								    if(ismode.equals("1")){
								%>
						            
					                             contentBox = $G("divFavContent18978");
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
					                            document.frmmain.action="RequestRemarkOperation.jsp";
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
						            
					                             contentBox = $G("divFavContent18978");
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
					                            document.frmmain.action="RequestRemarkOperation.jsp";
					                            //附件上传
					                            StartUploadAll();
					                            checkuploadcomplet();
					    }
	                   
<%}else{%>
            //TD4262 增加提示信息  开始

			<%
			    if(ismode.equals("1")){
			%>
	            
                        contentBox = $G("divFavContent18978");
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
                        document.frmmain.action="RequestRemarkOperation.jsp";
                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}%>
				obj.disabled=true;
            }
        }
}
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
				
				var rowneed=frmmain.ChinaExcel.GetCellUserStringValueRow("detail0_isneed");
				var head=frmmain.ChinaExcel.GetCellUserStringValueRow("detail0_head");
				var end=frmmain.ChinaExcel.GetCellUserStringValueRow("detail0_end");
			   	var nodesnum = end-head-2;
			   	nodesnum = nodesnum*1;
			   	if(rowneed>0)
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
	   	var rowneed=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=checkdetailno%>_isneed");
		var head=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=checkdetailno%>_head");
		var end=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=checkdetailno%>_end");
	   	var nodesnum = end-head-2;
	   	nodesnum = nodesnum*1;
	   	nodesnum = nodesnum*1;
	   	if(rowneed>0)
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
	   	<%
	   				checkdetailno ++;		
			    }
			}
		}
		else
		{
		 	int checkGroupId=0;
		 	RecordSet.execute("select distinct groupId from Workflow_formfield where formid="+formid+" and isdetail='1' order by groupid");
		    while (RecordSet.next())
		    {
		    	checkGroupId=RecordSet.getInt(1);
		    	%>
		       	var rowneed=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=checkGroupId%>_isneed");
				var head=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=checkGroupId%>_head");
				var end=frmmain.ChinaExcel.GetCellUserStringValueRow("detail<%=checkGroupId%>_end");
				var nodesnum = end-head-2;
		       	nodesnum = nodesnum*1;
		       	if(rowneed>0)
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
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		displayAllmenu();
    		return false;
    	}
		<!-- 点击保存按钮 -->
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $G("planDoSave").click();
        }catch(e){
            try{
            frmmain.ChinaExcel.EndCellEdit(true);
            }catch(e1){}
            var ischeckok="";
            try{
	  		  if(check_form(document.frmmain, "requestname"))
              ischeckok="true";
            }catch(e){
              ischeckok="false";
            }
            if(ischeckok=="false"){
                if(check_form(document.frmmain,'<%=needcheck%>'))
                    ischeckok="true";
            }
			if(ischeckok=="true"){
					if(("<%=formid%>"=="85" || "<%=formid%>"=="163") && "<%=isbill%>"=="1"){
						  if(!checkmeetingtimeok()){
						  	  displayAllmenu();
							  return;
						  }
					}
			}
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
			 if("1".equals(hasSign)){
	    %>
	     if(ischeckok=="true"){
	        var wcell = frmmain.ChinaExcel;
	        var temprow4=wcell.GetCellUserStringValueRow("qianzi");
       	    var tempcol4=wcell.GetCellUserStringValueCol("qianzi");
       	    if(wcell.GetCellValue(temprow4,tempcol4) == ""){
       	         alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
       	         ischeckok="false";
       	    }
		  }
	    <%
	      }
		}else{
%>
            if(ischeckok=="true"){
                //保存时不验证签字意见必填
			    //if(!check_form(document.frmmain,'remarkText10404')){
				//    ischeckok="false";
			    //}
		    }
<%
		}
	}
%>

            if(ischeckok=="true"){
                objSubmit=obj;
                FCKEditorExt.updateContent();
                if(checktimeok()&&checkReportData("save")) {
                }else {
	             	 displayAllmenu();
	             	 return;
	            }
             } else {
             	 displayAllmenu();
             	 return;
             }
        }
	}


    function doRemark()
    <!-- 点击被转发的提交按钮,点击抄送的人员提交 -->
	
    {    

var ischeckok="true";
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
			 if("1".equals(hasSign)){
	    %>
	     if(ischeckok=="true"){
	        var wcell = frmmain.ChinaExcel;
	        var temprow4=wcell.GetCellUserStringValueRow("qianzi");
       	    var tempcol4=wcell.GetCellUserStringValueCol("qianzi");
       	    if(wcell.GetCellValue(temprow4,tempcol4) == ""){
       	         alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
       	         ischeckok="false";
       	    }
		  }
	    <%
	      }
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form(document.frmmain,'remarkText10404')){
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
            $G("planDoRemark").click();
        }
        catch(e)
        {                
			if(checktimeok()) 
			{
		        document.frmmain.isremark.value='<%=isremark%>';
		        document.frmmain.src.value='save';
		        
           		<%--added by xwj for td2104 on 2005-08-01--%>
                <%--$G("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;--%>
                
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201


document.frmmain.action="RequestRemarkOperation.jsp";
//保存签章数据
<%if("1".equals(isFormSignature)&&"0".equals(hasSign)){%>
						try{  
					        if(typeof(eval("SaveSignature"))=="function"){
					              if(SaveSignature()){
						            //TD4262 增加提示信息  开始

									<%
									    if(ismode.equals("1")){
									%>
							            
						                            contentBox = $G("divFavContent18978");
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
							            
						                            contentBox = $G("divFavContent18978");
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
                        contentBox = $G("divFavContent18978");
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

    function doSave(){          <!-- 点击保存按钮 -->
    	enableAllmenu();
    	//var nodenum = checkNodesNum();
    	var nodenum = 0;
    	if(nodenum>0)
    	{
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		displayAllmenu();
    		return false;
    	}
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $G("planDoSave").click();
        }catch(e){
            try{
            frmmain.ChinaExcel.EndCellEdit(true);
            }catch(e1){}
            var ischeckok="";
            try{
			 if(check_form(document.frmmain, "requestname"))
              ischeckok="true";
            }catch(e){
              ischeckok="false";
            }
            if(ischeckok=="false"){
                if(check_form(document.frmmain,'<%=needcheck%>'))
                    ischeckok="true";
            }
			if(ischeckok=="true"){
					if(("<%=formid%>"=="85" || "<%=formid%>"=="163") && "<%=isbill%>"=="1"){
						  if(!checkmeetingtimeok()){
						  	  displayAllmenu();
							  return;
						  }
					}
			}
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
			 if("1".equals(hasSign)){
	    %>
	     if(ischeckok=="true"){
	        var wcell = frmmain.ChinaExcel;
	        var temprow4=wcell.GetCellUserStringValueRow("qianzi");
       	    var tempcol4=wcell.GetCellUserStringValueCol("qianzi");
       	    if(wcell.GetCellValue(temprow4,tempcol4) == ""){
       	         //保存时不验证签字意见必填
       	         //alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
       	         //ischeckok="false";
       	    }
		  }
	    <%
	      }
		}else{
%>
            if(ischeckok=="true"){
	            getRemarkText_log();
	            //保存时不验证签字意见必填
			    //if(!check_form(document.frmmain,'remarkText10404')){
			    //	    ischeckok="false";
			    //}
		    }
<%
		}
	}
%>


            if(ischeckok=="true"){
                objSubmit="";
                FCKEditorExt.updateContent();
                if(checktimeok()&&checkReportData("save")) {
                } else {
	             	 displayAllmenu();
	             	 return;
	            }
             } else {
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
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		displayAllmenu();
    		return false;
    	}
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $G("planDoSave").click();
        }catch(e){
            try{
            frmmain.ChinaExcel.EndCellEdit(true);
            }catch(e1){}
            var ischeckok="";
            try{
             if(check_form(document.frmmain,$G("needcheck").value+$G("inputcheck").value))
              ischeckok="true";
            }catch(e){
              ischeckok="false";
            }
            if(ischeckok=="false"){
                if(check_form(document.frmmain,'<%=needcheck%>'))
                    ischeckok="true";
            }
			if(ischeckok=="true"){
					if(("<%=formid%>"=="85" || "<%=formid%>"=="163") && "<%=isbill%>"=="1"){
						  if(!checkmeetingtimeok()){
						  	  displayAllmenu();
							  return;
						  }
					}
			}
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
			 if("1".equals(hasSign)){
	    %>
	     if(ischeckok=="true"){
	        var wcell = frmmain.ChinaExcel;
	        var temprow4=wcell.GetCellUserStringValueRow("qianzi");
       	    var tempcol4=wcell.GetCellUserStringValueCol("qianzi");
       	    if(wcell.GetCellValue(temprow4,tempcol4) == ""){
       	         alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
       	         ischeckok="false";
       	    }
		  }
	    <%
	      }
		}else{
%>
            if(ischeckok=="true"){
			    if(!check_form(document.frmmain,'remarkText10404')){
				    ischeckok="false";
			    }
		    }
<%
		}
	}
%>


            if(ischeckok=="true"){
                objSubmit=obj;
                FCKEditorExt.updateContent();
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

    function doSubmit(obj){        <!-- 点击提交 -->
    	enableAllmenu();
			$G('RejectToNodeid').value = '';
    	var nodenum = checkNodesNum();
    	var isuseTemplate = $G("temphasUseTempletSucceed").value;
    	if(nodenum>0)
    	{
    		alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+nodenum+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
    		displayAllmenu();
    		return false;
    	}
        try{
            frmmain.ChinaExcel.EndCellEdit(true);
            }catch(e1){}
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $G("planDoSubmit").click();
        }catch(e){
      //modify by xhheng @20050328 for TD 1703
      //明细部必填check，通过try $G("needcheck")来检查,避免对原有无明细单据的修改

        var ischeckok="";
        try{
        var checkstr=$G("needcheck").value+$G("inputcheck").value+',<%=needcheck%>';
        if(<%=isremark%>==5){
            checkstr="";
        }
        if(check_form(document.frmmain,checkstr))
          ischeckok="true";
        }catch(e){
          ischeckok="false";
        }
        if(ischeckok=="false"){
          if(check_form(document.frmmain,'<%=needcheck%>'))
            ischeckok="true";
        }
		if(ischeckok=="true"){
				if(("<%=formid%>"=="85" || "<%=formid%>"=="163") && "<%=isbill%>"=="1"){
					  if(!checkmeetingtimeok()){
					  	  displayAllmenu();
						  return;
					  }
				}
		}
<%
	if(isSignMustInput.equals("1")){
	    if("1".equals(isFormSignature)){
			 if("1".equals(hasSign)){
	    %>
	     if(ischeckok=="true"){
	        var wcell = frmmain.ChinaExcel;
	        var temprow4=wcell.GetCellUserStringValueRow("qianzi");
       	    var tempcol4=wcell.GetCellUserStringValueCol("qianzi");
       	    if(wcell.GetCellValue(temprow4,tempcol4) == ""){
       	         alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
       	         ischeckok="false";
       	    }
		  }
	    <%
	      }
		}else{
%>
            if(ischeckok=="true"){
	            getRemarkText_log();
			    if(!check_form(document.frmmain,'remarkText10404')){
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
	    		if (!confirm("<%=SystemEnv.getHtmlLabelName(19990,user.getLanguage())%>")) {
	    			displayAllmenu();
	            	return false; 
	            }
    		}

			<%
			if("1".equals(fromFlowDoc)||"1".equals(isworkflowdoc)){

			%>
				if (isuseTemplate == 'false'){
					if($G("createdoc")){
					if(window.confirm("<%=SystemEnv.getHtmlLabelName(21252,user.getLanguage())%>")){
					   //parent.resetbanner(1,1);
					   $G("createdoc").click();
					   displayAllmenu();
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
            FCKEditorExt.updateContent();
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

	function doReject(){//点击退回
		$G('SubmitToNodeid').value = '';
		enableAllmenu();
<%
	if(isSignMustInput.equals("1") || isSignMustInput.equals("2")){
	    if("1".equals(isFormSignature)){
			 if("1".equals(hasSign)){
	    %>
	        var wcell = frmmain.ChinaExcel;
	        var temprow4=wcell.GetCellUserStringValueRow("qianzi");
       	    var tempcol4=wcell.GetCellUserStringValueCol("qianzi");
       	    if(wcell.GetCellValue(temprow4,tempcol4) == ""){
       	         alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
				 displayAllmenu();
       	         return false;
       	    }
	    <%
	      }
		}else{
%>

	            getRemarkText_log();
			    if(!check_form(document.frmmain,'remarkText10404')){
				    displayAllmenu();
				    return false;
			    } else {
			    	if(!check_form(document.frmmain,'remark')){
					    displayAllmenu();
					    return false;
				    }
				 }
<%
		}
	}
%>
		var isuseTemplate = $G("temphasUseTempletSucceed").value;
		var _isUseTempletNode = $G("isUseTempletNode").value;
		if ("<%=needconfirm%>"=="1"){
			if (!confirm("<%=SystemEnv.getHtmlLabelName(19991,user.getLanguage())%>")){
				displayAllmenu();
	        	return false;
			}
		}

		<%
		if("1".equals(fromFlowDoc)||"1".equals(isworkflowdoc)){

		%>
			if(_isUseTempletNode == 'true'&&isuseTemplate== 'true'){
				if(window.confirm("<%=SystemEnv.getHtmlLabelName(22985,user.getLanguage())%>")){
				   //parent.resetbanner(1,1);
				   $G("createdoc").click();
				   displayAllmenu();
				   return;
				}else{
					displayAllmenu();
				   return;
				}
			}
		<%
			
		}
		%>

		try{
			frmmain.ChinaExcel.EndCellEdit(true);
		}catch(e1){}
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $G("planDoReject").click();
        }catch(e){
            if(onSetRejectNode()){
            showtipsinfo(<%=requestid%>,<%=workflowid%>,<%=nodeid%>,<%=isbill%>,1,<%=billid%>,"","reject","<%=ismode%>","divFavContent18980","<%=SystemEnv.getHtmlLabelName(18980,user.getLanguage())%>");
            } else {
            	displayAllmenu();
       	         return false;
            }
        }
    }

	function doReopen(){        <!-- 点击重新激活 -->
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $G("planDoReopen").click();
        }catch(e){
            document.frmmain.src.value='reopen';
            $G("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
            jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201
            //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
        }
	}

	function doDelete(){        <!-- 点击删除 -->
        try{
            //为了对《工作安排》流程作特殊的处理，请参考MR1010
            $G("planDoDelete").click();
        }catch(e){
            if(confirm("<%=SystemEnv.getHtmlLabelName(16667,user.getLanguage())%>")) {
                document.frmmain.src.value='delete';
                $G("remark").value += "\n<%=username%> <%=currentdate%> <%=currenttime%>" ;
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201

                //TD4262 增加提示信息  开始

<%
    if(ismode.equals("1")){
%>
	            contentBox = $G("divFavContent18984");
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

                //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
            }
        }
    }
//添加常用短语
function onAddPhrase(phrase){
	if(phrase!=null && phrase!=""){
		$G("remarkSpan").innerHTML = "";
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
			 if("1".equals(hasSign)){
	    %>
	     if(ischeckok=="true"){
	        var wcell = frmmain.ChinaExcel;
	        var temprow4=wcell.GetCellUserStringValueRow("qianzi");
       	    var tempcol4=wcell.GetCellUserStringValueCol("qianzi");
       	    if(wcell.GetCellValue(temprow4,tempcol4) == ""){
       	         alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
       	         ischeckok="false";
       	    }
		  }
	    <%
	      }
			}else{
	%>
	            if(ischeckok=="true"){
	            	getRemarkText_log();
				    if(!check_form(document.frmmain,'remarkText10404')){
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
				document.frmmain.action="/workflow/workflow/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&flag=ov&fromflow=1";
				//附件上传
			    StartUploadAll();
		        checkuploadcomplet();
		}
	}
}
function doRetract(obj){
jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
obj.disabled=true;
document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&flag=rb&requestid=<%=requestid%>" //xwj for td3665 20060224
}
function nodechange(value){
    var nodeids=value.split("_");
    var selnodeid=nodeids[0];
    var selnodetype=nodeids[1];
    if(selnodetype==0){
        $G("Intervenorid").value="<%=creater%>";
		$GetEle("IntervenoridType").value="<%=creatertype%>";
        $G("Intervenoridspan").innerHTML="<A href='javaScript:openhrm(<%=creater%>);' onclick='pointerXY(event);'><%=creatername%></a>";
    }else{
    <%if(urm_workflowMSmode==1){%>
    rightMenu.style.display="none";
    <%}%>
    $G("workflownextoperatorfrm").src="/workflow/request/WorkflowNextOperator.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&requestid=<%=requestid%>&isremark=<%=isremark%>&workflowid=<%=workflowid%>"+
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

    oPopup.show(iX, iY, 200, 22, document.body);
  }catch(e){}
}
<%
    }else{
%>
function showPrompt(content)
{
     var showTableDiv  = $G('_xTable');
     var message_table_Div = document.createElement("<div>")
     message_table_Div.id="message_table_Div";
     message_table_Div.className="xTable_message";
     showTableDiv.appendChild(message_table_Div);
     var message_table_Div  = $G("message_table_Div");
     message_table_Div.style.display="inline";
     message_table_Div.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_table_Div.style.position="absolute"
     message_table_Div.style.posTop=pTop;
     message_table_Div.style.posLeft=pLeft;

     message_table_Div.style.zIndex=1002;
     var oIframe = document.createElement('iframe');
     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_table_Div.style.zIndex - 1;
     oIframe.style.width = parseInt(message_table_Div.offsetWidth);
     oIframe.style.height = parseInt(message_table_Div.offsetHeight);
     oIframe.style.display = 'block';
}
<%
    }
%>
//TD4262 增加提示信息  结束
var showTableDiv  = $G('divshowreceivied');
var oIframe = document.createElement('iframe');
function showreceiviedPopup(content){
    showTableDiv.style.display='';
    var message_Div = document.createElement("<div>");
     message_Div.id="message_Div";
     message_Div.className="xTable_message";
     showTableDiv.appendChild(message_Div);
     var message_Div1  = $G("message_Div");
     message_Div1.style.display="inline";
     message_Div1.innerHTML=content;
     var pTop= document.body.offsetHeight/2+document.body.scrollTop-50;
     var pLeft= document.body.offsetWidth/2-50;
     message_Div1.style.position="absolute"
     message_Div1.style.posTop=pTop;
     message_Div1.style.posLeft=pLeft;

     message_Div1.style.zIndex=1002;

     oIframe.id = 'HelpFrame';
     showTableDiv.appendChild(oIframe);
     oIframe.frameborder = 0;
     oIframe.style.position = 'absolute';
     oIframe.style.top = pTop;
     oIframe.style.left = pLeft;
     oIframe.style.zIndex = message_Div1.style.zIndex - 1;
     oIframe.style.width = parseInt(message_Div1.offsetWidth);
     oIframe.style.height = parseInt(message_Div1.offsetHeight);
     oIframe.style.display = 'block';
}
function displaydiv_1()
{
	if(WorkFlowDiv.style.display == ""){
		WorkFlowDiv.style.display = "none";
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></span>";
	}
	else{
		WorkFlowDiv.style.display = "";
		//WorkFlowspan.innerHTML = "<a href='javascript:void(0);' onClick=displaydiv_1() target=_self><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></a>";
		WorkFlowspan.innerHTML = "<span style='cursor:hand;color: blue; text-decoration: underline' onClick='displaydiv_1()' ><%=SystemEnv.getHtmlLabelName(15154,user.getLanguage())%></span>";

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
function showallreceived(operator,operatedate,operatetime,returntdid,viewLogIds,logtype,destnodeid){
    showreceiviedPopup("<%=SystemEnv.getHtmlLabelName(19205,user.getLanguage())%>");
    var ajax=ajaxinit();
    ajax.open("POST", "/workflow/request/WorkflowReceiviedPersons.jsp", true);
    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
    ajax.send("requestid=<%=requestid%>&viewnodeIds=<%=viewLogIds%>&operator="+operator+"&operatedate="+operatedate+"&operatetime="+operatetime+"&returntdid="+returntdid+"&logtype="+logtype+"&destnodeid="+destnodeid);
    //获取执行状态

    ajax.onreadystatechange = function() {
        //如果执行状态成功，那么就把返回信息写到指定的层里

        if (ajax.readyState == 4 && ajax.status == 200) {
            try{
            $G(returntdid).innerHTML = ajax.responseText;
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
        var oFile=$G("oFile");
        oFile.FilePath=objValue;
        fileLenth= oFile.getFileSize();
    } catch (e){
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
    if (fileLenthByM>maxUploadImageSize) {
     	alert("<%=SystemEnv.getHtmlLabelName(20254,user.getLanguage())%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,user.getLanguage())%>"+maxUploadImageSize+"M<%=SystemEnv.getHtmlLabelName(20256 ,user.getLanguage())%>");
        createAndRemoveObj(obj);
    }
}

function createAndRemoveObj(obj){
    objName = obj.name;
    tempObjonchange=obj.onchange;
    outerHTML="<input name="+objName+" class=InputStyle type=file size=50 >";
    $G(objName).outerHTML=outerHTML;
    $G(objName).onchange=tempObjonchange;
}
function addannexRow(accname,maxsize)
  {
    $G(accname+'_num').value=parseInt($G(accname+'_num').value)+1;
    ncol = $G(accname+'_tab').cols;
    oRow = $G(accname+'_tab').insertRow(-1);
    for(j=0; j<ncol; j++) {
      oCell = oRow.insertCell(-1);

      switch(j) {
        case 0:
          var oDiv = document.createElement("div");
          oCell.colSpan=3;
          var sHtml = "<input class=InputStyle  type=file size=50 name='"+accname+"_"+$G(accname+'_num').value+"' onchange='accesoryChanage(this,"+maxsize+")'> (<%=SystemEnv.getHtmlLabelName(18976,user.getLanguage())%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,user.getLanguage())%>) ";
          oDiv.innerHTML = sHtml;
          oCell.appendChild(oDiv);
          break;
      }
    }
  }

 function onChangeSharetype(delspan,delid,ismand,Uploadobj){
	fieldid=delid.substr(0,delid.indexOf("_"));
    linknum=delid.substr(delid.lastIndexOf("_")+1);
	fieldidnum=fieldid+"_idnum_1";
	fieldidspan=fieldid+"span";
    delfieldid=fieldid+"_id_"+linknum;
    if($G(delspan).style.visibility=='visible'){
      $G(delspan).style.visibility='hidden';
      $G(delid).value='0';
	  $G(fieldidnum).value=parseInt($G(fieldidnum).value)+1;
        var tempvalue=$G(fieldid).value;
          if(tempvalue==""){
              tempvalue=$G(delfieldid).value;
          }else{
              tempvalue+=","+$G(delfieldid).value;
          }
	     $G(fieldid).value=tempvalue;
    }else{
      $G(delspan).style.visibility='visible';
      $G(delid).value='1';
	  $G(fieldidnum).value=parseInt($G(fieldidnum).value)-1;
        var tempvalue=$G(fieldid).value;
        var tempdelvalue=","+$G(delfieldid).value+",";
          if(tempvalue.substr(0,1)!=",") tempvalue=","+tempvalue;
          if(tempvalue.substr(tempvalue.length-1)!=",") tempvalue+=",";
          tempvalue=tempvalue.substr(0,tempvalue.indexOf(tempdelvalue))+tempvalue.substr(tempvalue.indexOf(tempdelvalue)+tempdelvalue.length-1);
          if(tempvalue.substr(0,1)==",") tempvalue=tempvalue.substr(1);
          if(tempvalue.substr(tempvalue.length-1)==",") tempvalue=tempvalue.substr(0,tempvalue.length-1);
	     $G(fieldid).value=tempvalue;
    }
	//alert($G(fieldidnum).value);
	if (ismand=="1")
	  {
	if ($G(fieldidnum).value=="0")
	  {
	    $G(fieldid).value="";
        if(Uploadobj.getStats().files_queued==0){
		$G(fieldidspan).innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
        }
	  }
	  else
	  {
		 $G(fieldidspan).innerHTML="";
	  }
	  }
  }

function checkReportData(src){
        var reportUserId="";
		var crmId="";
		var year="";
		var month="";
		var day="";
		var date="";
        if($G("reportUserIdInputName")!=null){
			var reportUserIdInputName=$G("reportUserIdInputName").value;
            reportUserId=$G(reportUserIdInputName).value;
        }
        if($G("crmIdInputName")!=null){
			var crmIdInputName=$G("crmIdInputName").value
		    crmId=$G(crmIdInputName).value;
		}
        if($G("year")!=null){
			year=$G("year").value;
		}
		if($G("month")!=null){
			month=$G("month").value;
		}
		if($G("day")!=null){
			day=$G("day").value;
		}
		if($G("date")!=null){
			date=$G("date").value;
		}
        if(reportUserId=="" || crmId==""){
            checkReportDataReturn(0,"","",src);
        }else{
            StrData="requestid=<%=requestid%>&formid=<%=formid%>&reportUserId="+reportUserId+"&crmId="+crmId+"&year="+year+"&month="+month+"&day="+day+"&date="+date+"&src="+src;
            if($G("checkReportDataForm")!=null){
                $G("checkReportDataForm").src="checkReportDataForm.jsp?"+StrData;
            }else{
                checkReportDataReturn(0,"","",src);
            }
        }
	}
function checkReportDataReturn(ret,thedate,dspdate,src){

		if(ret==1||ret==2){
			alert(dspdate+" "+"<%=SystemEnv.getHtmlLabelName(20775,user.getLanguage())%>");
			return false;
		}
		if(src=="save"){
                    document.frmmain.src.value='save';
                    jQuery($GetEle("flowbody")).attr("onbeforeunload", "");


            <%if("1".equals(isFormSignature)&&"0".equals(hasSign)){ %>
            			try{  
					        if(typeof(eval("SaveSignature_save"))=="function"){
					              //保存时不验证必填
	                    if(SaveSignature_save()||!SaveSignature_save()){
			<%
			    if(ismode.equals("1")){
			%>
                            contentBox = $G("divFavContent18979");
                            showObjectPopup(contentBox)
<%
    }else{
%>
                            var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                            showPrompt(content);
<%
    }
%>
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
                            contentBox = $G("divFavContent18979");
                            showObjectPopup(contentBox)
<%
    }else{
%>
                            var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                            showPrompt(content);
<%
    }
%>
                            //附件上传
                            StartUploadAll();
                            checkuploadcomplet();
					    }
            			
<%}else{%>
<%
    if(ismode.equals("1")){
%>
                        contentBox = $G("divFavContent18979");
                        showObjectPopup(contentBox)
<%
    }else{
%>
                        var content="<%=SystemEnv.getHtmlLabelName(18979,user.getLanguage())%>";
                        showPrompt(content);
<%
    }
%>
                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}%>
            if(objSubmit!=""){
					objSubmit.disabled=true;
				}
        }else if(src=="submit"){
            showtipsinfo(<%=requestid%>,<%=workflowid%>,<%=nodeid%>,<%=isbill%>,0,<%=billid%>,objSubmit,"submit","<%=ismode%>","divFavContent18978","<%=SystemEnv.getHtmlLabelName(18978,user.getLanguage())%>");
		}else if(src=="Affirmance"){
                document.frmmain.src.value='save';
                jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3425 20051231

                var isSubmitDirect = "";
                if($G("SubmitToNodeid")) {
                    if($G("SubmitToNodeid").value != "") {
                    	isSubmitDirect = "1";
                    }
             	}
                document.frmmain.topage.value="ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&isaffirmance=1&reEdit=0&fromFlowDoc=<%=fromFlowDoc%>&isSubmitDirect=" + isSubmitDirect;
                <%if("1".equals(isFormSignature)&&"0".equals(hasSign)){%>
                		try{  
					        if(typeof(eval("SaveSignature"))=="function"){
					              if(SaveSignature()){
<%
    if(ismode.equals("1")){
%>
                            contentBox = $G("divFavContent18979");
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
                            contentBox = $G("divFavContent18979");
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
                            //附件上传
                            StartUploadAll();
                            checkuploadcomplet();
					    }
	                    
<%}else{%>
<%
    if(ismode.equals("1")){
%>
                        contentBox = $G("divFavContent18979");
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
                        //附件上传
                        StartUploadAll();
                        checkuploadcomplet();
<%}%>
				if(objSubmit!=""){
					objSubmit.disabled=true;
				}
		}
	}

function showtipsinfo(requestid,workflowid,nodeid,isbill,isreject,billid,obj,src,ismode,divcontent,content){

		var nowtarget = frmmain.target;
		var nowaction = frmmain.action;

		$G("divcontent").value=divcontent;
		$G("content").value=content;
		$G("src").value=src;
		
		<%
        //当前为节点操作者 & 下一节点出口包含出口提示信息时
        if ("0".equals(isremark) && WFPathUtil.hasNodeLinkTips(workflowid + "", nodeid + "")) {
        %>
		frmmain.target = "showtipsinfoiframe";
		frmmain.action = "/workflow/request/WorkflowTipsinfo.jsp";
		frmmain.submit();

		frmmain.target = nowtarget;
		frmmain.action = nowaction;
		
		<%
        } else {
        %>
        showtipsinfoReturn("", src, ismode, divcontent, content, "");
        <%
        }
        %>
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
                        document.frmmain.src.value=src;
                        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");

                        //保存签章数据
                        <%if("1".equals(isFormSignature)&&"0".equals(hasSign)){ %>
                        	try{  
						        if(typeof(eval("SaveSignature"))=="function"){
						              if(SaveSignature(src)){
                                if(ismode=="1"){
                                    contentBox = $G(divcontent);
                                    showObjectPopup(contentBox)
                                }else{
                                    showPrompt(content);
                                }

                                //附件上传
								doctopdfandsubmit();
                                //StartUploadAll();
                                //checkuploadcomplet();
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
                                    contentBox = $G(divcontent);
                                    showObjectPopup(contentBox)
                                }else{
                                    showPrompt(content);
                                }

                                //附件上传
								doctopdfandsubmit();
                                //StartUploadAll();
                                //checkuploadcomplet();
						    }
                            
                        <%}else{%>
                            if(ismode=="1"){
                                contentBox = $G(divcontent);
                                showObjectPopup(contentBox)
                            }else{
                                showPrompt(content);
                            }

                            //附件上传
							doctopdfandsubmit();
                            //StartUploadAll();
                            //checkuploadcomplet();
                        <%}%>
                    }
                }else{
                    document.frmmain.src.value=src;
                    jQuery($GetEle("flowbody")).attr("onbeforeunload", "");


                    //保存签章数据
                <%if("1".equals(isFormSignature)&&"0".equals(hasSign)){ %>
                		try{  
					        if(typeof(eval("SaveSignature"))=="function"){
					               if (SaveSignature(src)) {
                        if (ismode == "1") {
                            contentBox = $G(divcontent);
                            showObjectPopup(contentBox)
                        } else {
                            showPrompt(content);
                        }

                        //附件上传
						doctopdfandsubmit();
                        //tartUploadAll();
                        //checkuploadcomplet();
                    } else {
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
                        return;
                    }
					        }
					    }catch(e){
					        if (ismode == "1") {
                            contentBox = $G(divcontent);
                            showObjectPopup(contentBox)
                        } else {
                            showPrompt(content);
                        }

                        //附件上传
						doctopdfandsubmit();
                        //StartUploadAll();
                        //checkuploadcomplet();
					    }
                   
                <%}else{%>
                    if (ismode == "1") {
                        contentBox = $G(divcontent);
                        showObjectPopup(contentBox)
                    } else {
                        showPrompt(content);
                    }

                    //附件上传
					doctopdfandsubmit();
                    //StartUploadAll();
                    //checkuploadcomplet();
                <%}%>
                }
            }catch(e){}
}

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
		document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&flag=stop&requestid=<%=requestid%>" //xwj for td3665 20060224
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
		document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&flag=cancel&requestid=<%=requestid%>" //xwj for td3665 20060224
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
		document.location.href="/workflow/workflow/wfFunctionManageLink.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&flag=restart&requestid=<%=requestid%>" //xwj for td3665 20060224
	}
	else
	{
		displayAllmenu();
		return false;
	}
}
</script>

<SCRIPT LANGUAGE=VBS>
sub onShowBrowser(id,url,linkurl,type1,ismand)
	if type1= 2 or type1 = 19 then
		id1 = window.showModalDialog(url,,"dialogHeight:320px;dialogwidth:275px")

		document.getElementById("field"+id+"span").innerHtml = id1
		document.getElementById("field"+id).value=id1
	else
		if type1 <> 152 and type1 <> 17 and type1 <> 18 and type1<>27 and type1<>37 and type1<>56 and type1<>57 and type1<>65 and type1<>4 and type1<>167 and type1<>164 and type1<>169 and type1<>170 then
			id1 = window.showModalDialog(url)
		elseif type1=4 or type1=167 or type1=164 or type1=169 or type1=170 then
            tmpids = document.getElementById("field"+id).value
			id1 = window.showModalDialog(url&"?selectedids="&tmpids)
		else
			tmpids = document.getElementById("field"+id).value
			id1 = window.showModalDialog(url&"?resourceids="&tmpids)
		end if
		if NOT isempty(id1) then
			if type1 = 152 or type1 = 17 or type1 = 18 or type1=27 or type1=37 or type1=56 or type1=57 or type1=65 then
				if id1(0)<> ""  and id1(0)<> "0"  then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.getElementById("field"+id).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
					if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							sHtml = sHtml&"<a href=javaScript:openhrm("&curid&"); onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
						else
							sHtml = sHtml&"<a href="&linkurl&curid&">"&curname&"</a>&nbsp"
					end if
					wend
					if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
						sHtml = sHtml&"<a href=javaScript:openhrm("&resourceids&"); onclick='pointerXY(event);'>"&resourcename&"</a>&nbsp"
					else
						sHtml = sHtml&"<a href="&linkurl&resourceids&">"&resourcename&"</a>&nbsp"
					end if
					document.getElementById("field"+id+"span").innerHtml = sHtml

				else
					if ismand=0 then
						document.getElementById("field"+id+"span").innerHtml = empty
					else
						document.getElementById("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.getElementById("field"+id).value=""
				end if

			else
			   if  id1(0)<>""  and id1(0)<> "0"  then
			        if linkurl = "" then
						document.getElementById("field"+id+"span").innerHtml = id1(1)
					else
						if linkurl = "/hrm/resource/HrmResource.jsp?id=" then
							document.getElementById("field"+id+"span").innerHtml = "<a href=javaScript:openhrm("&id1(0)&"); onclick='pointerXY(event);'>"&id1(1)&"</a>&nbsp"
						else
							document.getElementById("field"+id+"span").innerHtml = "<a href="&linkurl&id1(0)&">"&id1(1)&"</a>"
						end if
						
					end if
					document.getElementById("field"+id).value=id1(0)
				else
					if ismand=0 then
						document.getElementById("field"+id+"span").innerHtml = empty
					else
						document.getElementById("field"+id+"span").innerHtml ="<img src='/images/BacoError_wev8.gif' align=absmiddle>"
					end if
					document.getElementById("field"+id).value=""
				end if
			end if
		end if
	end if
end sub
sub getDate(i)
	returndate = window.showModalDialog("/systeminfo/Calendar.jsp",,"dialogHeight:320px;dialogwidth:275px")
	document.getElementById("datespan"&i).innerHtml= returndate
	document.getElementById("dff0"&i).value=returndate
end sub
sub onShowMutiHrm(spanname,inputename)
		tmpids = document.getElementById(inputename).value
		id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="&tmpids)
		    if (Not IsEmpty(id1)) then
				if id1(0)<> "" then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.getElementById(inputename).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<A href='javaScript:openhrm("&curid&");' onclick='pointerXY(event);'>"&curname&"</a>&nbsp"
					wend
					sHtml = "<button class=Browser onclick=onShowMutiHrm('Intervenoridspan','Intervenorid') ></button>"&sHtml&"<A href='javaScript:openhrm("&resourceids&");' onclick='pointerXY(event);'>"&resourcename&"</a>"
					document.getElementById(spanname).innerHtml = sHtml

				else
					document.getElementById(spanname).innerHtml ="<button class=Browser onclick=onShowMutiHrm('Intervenoridspan','Intervenorid') ></button><img src='/images/BacoError_wev8.gif' align=absmiddle>"
					document.getElementById(inputename).value=""
				end if
			end if
end sub
sub onShowSignBrowser(url,linkurl,inputname,spanname,type1)
    tmpids = document.getElementById(inputname).value
    if type1=37 then
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="&url&"?documentids="&tmpids)
    else
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="&url&"?resourceids="&tmpids)
    end if
        if NOT isempty(id1) then
		   if id1(0)<> ""  and id1(0)<> "0"  then
					resourceids = id1(0)
					resourcename = id1(1)
					sHtml = ""
					resourceids = Mid(resourceids,2,len(resourceids))
					document.getElementById(inputname).value= resourceids
					resourcename = Mid(resourcename,2,len(resourcename))
					while InStr(resourceids,",") <> 0
						curid = Mid(resourceids,1,InStr(resourceids,",")-1)
						curname = Mid(resourcename,1,InStr(resourcename,",")-1)
						resourceids = Mid(resourceids,InStr(resourceids,",")+1,Len(resourceids))
						resourcename = Mid(resourcename,InStr(resourcename,",")+1,Len(resourcename))
						sHtml = sHtml&"<a href="&linkurl&curid&" target='_blank'>"&curname&"</a>&nbsp"
					wend
					sHtml = sHtml&"<a href="&linkurl&resourceids&" target='_blank'>"&resourcename&"</a>&nbsp"
					document.getElementById(spanname).innerHtml = sHtml

		else
				    document.getElementById(spanname).innerHtml = empty
					document.getElementById(inputname).value=""
        end if
      end if
end sub
</script>