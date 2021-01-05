
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.*,java.util.*,weaver.hrm.*,weaver.systeminfo.*" %>
<%@ page import="weaver.workflow.datainput.DynamicDataInput"%>
<%@ page import="weaver.workflow.request.RevisionConstants" %>
<%@ page import="weaver.workflow.html.WFLayoutToHtml"%>
<%@ page import="weaver.workflow.html.FieldAttrManager"%>
<%@page import="weaver.workflow.workflow.WorkflowComInfo"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="wfNodeFieldManager" class="weaver.workflow.workflow.WFNodeFieldManager" scope="page" />
<jsp:useBean id="wfLayoutToHtml" class="weaver.workflow.html.WFLayoutToHtml" scope="page" />
<jsp:useBean id="rs_html" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet_nf1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs_fna" class="weaver.conn.RecordSet" scope="page" />

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DocImageManager" class="weaver.docs.docs.DocImageManager" scope="page" />

<jsp:useBean id="SecCategoryComInfo1" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="RequestManager" class="weaver.workflow.request.RequestManager" scope="page"/>
<jsp:useBean id="rs_meeting" class="weaver.conn.RecordSet" scope="page" />
<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<SCRIPT language="javascript" src="/workflow/request/js/requesthtml_wev8.js"></script>

<script type="text/javascript" src="/wui/common/jquery/plugin/Listener_wev8.js"></script>
<link type="text/css" rel="stylesheet" href="/js/ecology8/weaverautocomplete/css/weaverautocomplete_wev8.css">
<script type="text/javascript" src="../../js/weaver_wev8.js"></script>

<!--签字意见-->
<link rel="stylesheet" type="text/css" href="/css/ecology8/workflowsign_wev8.css" />
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<!-- browser 相关 -->
<script type="text/javascript" src="/js/workflow/wfbrow_wev8.js"></script>
<script type='text/javascript' src="/js/ecology8/request/autoSelect_wev8.js"></script>
<link type="text/css" href="/js/ecology8/base/jquery-ui_wev8.css" rel=stylesheet>
<script type="text/javascript" src="/js/ecology8/base/jquery-ui_wev8.js"></script>
<script type="text/javascript" src="/js/jquery-autocomplete/jquery.autocomplete_wev8.js"></script>
<script type="text/javascript">
window.__userid = '<%=request.getParameter("f_weaver_belongto_userid")%>';
window.__usertype = '<%=request.getParameter("f_weaver_belongto_usertype")%>';
</script>

<!-- onpropertychange事件支持 -->
<script type="text/javascript" src="/js/workflow/VCEventHandle_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/workflow/exceldesign/css/excelHtml_wev8.css" />
<script>
//用来给用户自定义检查数据，在流程提交或者保存的时候执行该函数，通过返回true，否则返回false
function checkCustomize(){
	return true;
}

//新表单设计器-联动format加载监听器----------此ready需先于calsum行列计算前执行，用于表览字段chrome下合计
var chromeOnPropListener = null;
jQuery(document).ready(function(){
	loadListener();
});

//加载监听器，页面打开调用一次；明细表添加调用一次，重置定时器监听的对象
function loadListener(){
	if(chromeOnPropListener==null){
		chromeOnPropListener = new Listener();
	}else{
		chromeOnPropListener.stop();
	}
	chromeOnPropListener.load("[_listener][_listener!='']");
	chromeOnPropListener.start(500,"_listener");
}
</script>
<%
response.setHeader("Pragma","No-Cache");   
response.setHeader("Cache-Control","No-Cache");   
response.setDateHeader("Expires",0);   
//User user = HrmUserVarify.getUser(request, response);
int languageid = Util.getIntValue(request.getParameter("languageid"), 7);
int isbill = Util.getIntValue(request.getParameter("isbill"), 0);
int formid = Util.getIntValue(request.getParameter("formid"), 0);
//tagtag资产借用,送修,归还
if(formid==220||formid==222||formid==224){
	session.setAttribute("cpt_sysformid", ""+formid);
}else{
	session.removeAttribute("cpt_sysformid");
}
int nodeid = Util.getIntValue(request.getParameter("nodeid"), 0);
int requestid = Util.getIntValue(request.getParameter("requestid"), 0);
String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
//int userid = Util.getIntValue(request.getParameter("userid"), 0);
int userid=user.getUID();                   //当前用户id 
int usertype = Util.getIntValue(request.getParameter("usertype"), 0);
int workflowid = Util.getIntValue(request.getParameter("workflowid"));
String workflowtype = Util.null2String(request.getParameter("workflowtype"));
String topage = Util.null2String(request.getParameter("topage"));
String docFlags = Util.null2String((String)session.getAttribute("requestAdd"+requestid));
int docfileid = Util.getIntValue(request.getParameter("docfileid"));	//新建文档的工作流字段
if(docFlags.equals("")){
	docFlags = Util.null2String((String)session.getAttribute("requestAdd"+userid));
}

wfLayoutToHtml.setRequest(request);
wfLayoutToHtml.setUser(user);
wfLayoutToHtml.setIscreate(1);
Hashtable ret_hs = wfLayoutToHtml.analyzeLayout();
Hashtable otherPara_hs = wfLayoutToHtml.getOtherPara_hs();
String wfformhtml = Util.null2String((String)ret_hs.get("wfformhtml"));
StringBuffer jsStr = wfLayoutToHtml.getJsStr();
String needcheck = wfLayoutToHtml.getNeedcheck();

StringBuffer htmlHiddenElementsb = wfLayoutToHtml.getHtmlHiddenElementsb();
out.println(htmlHiddenElementsb.toString());//把hidden的input输出到页面上
int hasRemark = Util.getIntValue((String)otherPara_hs.get("hasRemark"), 0);
String logintype = Util.null2String(request.getParameter("logintype"));
String username = Util.null2String((String)session.getAttribute(userid+"_"+logintype+"username"));
String docCategory=Util.null2String((String)otherPara_hs.get("docCategory"));
Map secMaxUploads = (HashMap)otherPara_hs.get("secMaxUploads");//封装选择目录的信息




Map secCategorys = (HashMap)otherPara_hs.get("secCategorys");
ArrayList uploadfieldids=(ArrayList)otherPara_hs.get("uploadfieldids");
int maxUploadImageSize_Para = Util.getIntValue((String)otherPara_hs.get("maxUploadImageSize"), -1);
int secid = Util.getIntValue(docCategory.substring(docCategory.lastIndexOf(",")+1),-1);
int maxUploadImageSize = -1;
if(maxUploadImageSize_Para > 0){
	maxUploadImageSize = maxUploadImageSize_Para;
}else{
	maxUploadImageSize = Util.getIntValue(SecCategoryComInfo1.getMaxUploadFileSize(""+secid),5);
}
if(maxUploadImageSize<=0){
	maxUploadImageSize = 5;
}
/*
 int uploadType = 0;
 String selectedfieldid = "";
 String result = RequestManager.getUpLoadTypeForSelect(workflowid);
 if(!result.equals("")){
 selectedfieldid = result.substring(0,result.indexOf(","));
 uploadType = Integer.valueOf(result.substring(result.indexOf(",")+1)).intValue();
 }
 */
 WorkflowComInfo workflowCominfo = new WorkflowComInfo();
 String selectedfieldid = String.valueOf(workflowCominfo.getSelectedCateLog(String.valueOf(workflowid)));
 int uploadType = workflowCominfo.getCatelogType(String.valueOf(workflowid));
 
//获得触发字段名
String selectfieldlable = "";
String selectfieldvalue = "";

if(uploadType==1 && !"".equals(selectedfieldid.trim())){
	
	String selectfieldsql = "";
	 if(isbill==1){
		 selectfieldsql = "SELECT bf.fieldlabel,bf.fieldname,b.tablename FROM workflow_billfield bf,workflow_bill b WHERE b.id=bf.billid AND bf.id="+selectedfieldid;
	 }else{
	 	 selectfieldsql = "select fl.fieldlable,fd.fieldname,'workflow_form' AS tablename  FROM workflow_fieldlable fl,workflow_formdict fd WHERE fl.fieldid=fd.id and fl.fieldid="+selectedfieldid+" AND fl.langurageid="+user.getLanguage()+" AND fl.formid="+formid;
	 }
 	 rs_html.executeSql(selectfieldsql);
 	 if(rs_html.next()){
 	    String _fieldlabel = rs_html.getString(1);
 	    String _fieldname = rs_html.getString("fieldname");
 	    String _tablename = rs_html.getString("tablename");
 		if(isbill==1){
 			selectfieldlable = SystemEnv.getHtmlLabelName(Util.getIntValue(_fieldlabel),user.getLanguage());
 		}else{
 			selectfieldlable = _fieldlabel;
 		}
 		rs_html.executeSql("SELECT selectvalue FROM workflow_SelectItem WHERE fieldid="+selectedfieldid+" AND isdefault='y' ORDER BY listorder ");
 		if(rs_html.next()){
 		  	selectfieldvalue = rs_html.getString(1).trim();
 		}
 	 }
}


DynamicDataInput ddi=new DynamicDataInput(workflowid+"");
String trrigerfield=ddi.GetEntryTriggerFieldName();
String trrigerdetailfield=ddi.GetEntryTriggerDetailFieldName();
int detailsum=0;
int titleFieldId=0;
int keywordFieldId=0;
String isSignDoc_add="";
String isSignWorkflow_add="";
int hrmResourceShow = 0;
RecordSet_nf1.execute("select titleFieldId,keywordFieldId,isSignDoc,isSignWorkflow,hrmResourceShow from workflow_base where id="+workflowid);
if(RecordSet_nf1.next()){
	titleFieldId=Util.getIntValue(RecordSet_nf1.getString("titleFieldId"),0);
    hrmResourceShow = Util.getIntValue(RecordSet_nf1.getString("hrmResourceShow"));
	keywordFieldId=Util.getIntValue(RecordSet_nf1.getString("keywordFieldId"),0);
	isSignDoc_add=Util.null2String(RecordSet_nf1.getString("isSignDoc"));
	isSignWorkflow_add=Util.null2String(RecordSet_nf1.getString("isSignWorkflow"));
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
<input type=hidden name ="uploadType" id="uploadType" value="<%=uploadType %>">
<input type=hidden name ="selectfieldvalue" id="selectfieldvalue" value="<%=selectfieldvalue %>">
<input type=hidden name="workflowRequestLogId" value="-1">
<%
String isSignMustInput="0";
String isHideInput="0";
String isFormSignature=null;
int formSignatureWidth=RevisionConstants.Form_Signature_Width_Default;
int formSignatureHeight=RevisionConstants.Form_Signature_Height_Default;
RecordSet_nf1.executeSql("select isFormSignature,formSignatureWidth,formSignatureHeight,issignmustinput,ishideinput from workflow_flownode where workflowId="+workflowid+" and nodeId="+nodeid);
if(RecordSet_nf1.next()){
	isFormSignature = Util.null2String(RecordSet_nf1.getString("isFormSignature"));
	formSignatureWidth= Util.getIntValue(RecordSet_nf1.getString("formSignatureWidth"),RevisionConstants.Form_Signature_Width_Default);
	formSignatureHeight= Util.getIntValue(RecordSet_nf1.getString("formSignatureHeight"),RevisionConstants.Form_Signature_Height_Default);
	isSignMustInput = ""+Util.getIntValue(RecordSet_nf1.getString("issignmustinput"), 0);
	isHideInput = ""+Util.getIntValue(RecordSet_nf1.getString("ishideinput"), 0);
}
int isUseWebRevision_t = Util.getIntValue(new weaver.general.BaseBean().getPropValue("weaver_iWebRevision","isUseWebRevision"), 0);
if(isUseWebRevision_t != 1){
	isFormSignature = "";
}


int formsignatureIndex = wfformhtml.indexOf(wfLayoutToHtml.HTML_FORMSIGNATURE_PLACEHOLDER);
//System.out.println("wfformhtml=" + wfformhtml);
String formsignatureafter = "";
if (formsignatureIndex != -1 && hasRemark == 1 && "1".equals(isFormSignature)) {
	out.println(wfformhtml.substring(0, formsignatureIndex));
	formsignatureafter = wfformhtml.substring(formsignatureIndex + wfLayoutToHtml.HTML_FORMSIGNATURE_PLACEHOLDER.length());
} else {
	out.println(wfformhtml); //把模板解析后的文本输出到页面上




}
//新表单设计器,添加样式
int wfversion=Util.getIntValue(Util.null2String(ret_hs.get("wfversion")),0);
if(wfversion==2){
	out.println(ret_hs.get("wfcss"));
}
if(hasRemark != 1){
    String workflowRequestLogId = "";
	String isSignDoc_edit=isSignDoc_add;
	String signdocids = "";
	String signdocname = "";
	String isSignWorkflow_edit = isSignWorkflow_add; 
	String signworkflowids = "";
	String signworkflowname = "";
	
	String isannexupload_edit = (String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
	String annexdocids = "";
	
	String myremark = "";
	int annexmainId=0;
    int annexsubId=0;
    int annexsecId=0;
    int annexmaxUploadImageSize = 0;
	if("1".equals(isannexupload_edit)){
        
        String annexdocCategory_add=(String)session.getAttribute(userid+"_"+workflowid+"annexdocCategory");
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
	
	
	boolean isSuccess  = RecordSet_nf1.executeProc("sysPhrase_selectByHrmId",""+userid);
	String workflowPhrases[] = new String[RecordSet_nf1.getCounts()];
	String workflowPhrasesContent[] = new String[RecordSet_nf1.getCounts()];
	int m = 0 ;
	if (isSuccess) {
		while (RecordSet_nf1.next()){
			workflowPhrases[m] = Util.null2String(RecordSet_nf1.getString("phraseShort"));
			workflowPhrasesContent[m] = Util.toHtml(Util.null2String(RecordSet_nf1.getString("phrasedesc")));
			m ++ ;
		}
	}
    %>
    <br>
    <br>
     <%@ include file="/workflow/request/WorkflowSignInput.jsp" %>
     <br>
     <br>
    <%
    
} else if (formsignatureIndex != -1 && hasRemark == 1 && "1".equals(isFormSignature)&&!isHideInput.equals("1")) {
 		int workflowRequestLogId=-1;
%>
		<jsp:include page="/workflow/request/WorkflowLoadSignature.jsp">
			<jsp:param name="workflowRequestLogId" value="<%=workflowRequestLogId%>" />
			<jsp:param name="isSignMustInput" value="<%=isSignMustInput%>" />
			<jsp:param name="formSignatureWidth" value="<%=formSignatureWidth%>" />
			<jsp:param name="formSignatureHeight" value="<%=formSignatureHeight%>" />
			<jsp:param name="isFromHtmlModel" value="1" />
            <jsp:param name="requestId" value="<%=requestid %>" />
            <jsp:param name="workflowId" value="<%=workflowid %>" />
            <jsp:param name="nodeId" value="<%=nodeid %>" />
		</jsp:include>
<%
	out.println(formsignatureafter);
}else{ 
	 String workflowRequestLogId = "";
		String isSignDoc_edit=isSignDoc_add;
		String signdocids = "";
		String signdocname = "";
		String isSignWorkflow_edit = isSignWorkflow_add; 
		String signworkflowids = "";
		String signworkflowname = "";
		
		String isannexupload_edit = (String)session.getAttribute(userid+"_"+workflowid+"isannexupload");
		String annexdocids = "";
		String fieldannexuploadname = "";
		String myremark = "";
		int annexmainId=0;
	    int annexsubId=0;
	    int annexsecId=0;
	    int annexmaxUploadImageSize = 0;
		if("1".equals(isannexupload_edit)){
	        
	        String annexdocCategory_add=(String)session.getAttribute(userid+"_"+workflowid+"annexdocCategory");
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
		
		
		boolean isSuccess  = RecordSet_nf1.executeProc("sysPhrase_selectByHrmId",""+userid);
		String workflowPhrases[] = new String[RecordSet_nf1.getCounts()];
		String workflowPhrasesContent[] = new String[RecordSet_nf1.getCounts()];
		int m = 0 ;
		if (isSuccess) {
			while (RecordSet_nf1.next()){
				workflowPhrases[m] = Util.null2String(RecordSet_nf1.getString("phraseShort"));
				workflowPhrasesContent[m] = Util.toHtml(Util.null2String(RecordSet_nf1.getString("phrasedesc")));
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
                                         <input type=hidden name='annexmaxUploadImageSize' id='annexmaxUploadImageSize' value=<%=annexmaxUploadImageSize%>>
                                         
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
                                                onclick="onShowSignBrowser4signinput('/docs/docs/MutiDocBrowser.jsp','/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&isrequest=1&id=','signdocids','signdocspan',37, 'signDocCount')"
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
                                                onclick="onShowSignBrowser4signinput('/workflow/request/MultiRequestBrowser.jsp','/workflow/request/ViewRequest.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&isrequest=1&requestid=','signworkflowids','signworkflowspan',152, 'signWorkflowCount')"
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
					                    sHtml = sHtml + "<a onclick=\"parent.addDocReadTag('" + curid + "');parent.openFullWindowHaveBar('/docs/docs/DocDsp.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&id=" + curid + "&isrequest=1&requestid=<%=Util.getIntValue(requestid+"",0) <= 0 ? "{#[currentRequestid]#}" : requestid %>')\" title='" + curname + "' style=\"color:#123885;\" href='javascript:void 0'>" + curname + "</a>&nbsp;&nbsp;";
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
				    dialog.Title = "<%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%>";
				    }else{
				    dialog.Title = "<%=SystemEnv.getHtmlLabelName(1044, user.getLanguage())%>";
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
				        dialog.Title = "<%=SystemEnv.getHtmlLabelName(17616, user.getLanguage())%>";
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

<!--TD4262 增加提示信息  开始-->
<div id='_xTable' style='background:#FFFFFF;padding:0px;width:100%' valign='top'>
</div>
<!--TD4262 增加提示信息  结束-->
<iframe id="selectChangeDetail" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="selectChange" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputform" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<iframe id="datainputformdetail" frameborder=0 scrolling=no src=""  style="display:none" ></iframe>
<iframe id="workflowKeywordIframe" frameborder=0 scrolling=no src=""  style="display:none"></iframe>

<input type=hidden name="workflowid" value="<%=workflowid%>">	   <!--工作流id-->
<input type=hidden name="workflowtype" value="<%=workflowtype%>">   <!--工作流类型-->
<input type=hidden name="nodeid" value="<%=nodeid%>">			   <!--当前节点id-->
<input type=hidden name="nodetype" value="0">					 <!--当前节点类型-->
<input type=hidden name="src">									<!--操作类型 save和submit,reject,delete-->
<input type=hidden name="iscreate" value="1">					 <!--是否为创建节点 是:1 否 0 -->
<input type=hidden name="formid" value="<%=formid%>">			   <!--表单的id-->
<input type=hidden name ="topage" value="<%=topage%>">			<!--创建结束后返回的页面-->
<input type=hidden name ="isbill" value="<%=isbill%>">			<!--是否单据 0:否 1:是-->
<input type=hidden name ="method">								<!--新建文档时候 method 为docnew-->
<input type=hidden name ="needcheck" value="<%=needcheck%>">
<input type=hidden name ="inputcheck" value="">

<input type=hidden name ="isMultiDoc" value=""><!--多文档新建-->

<input type=hidden name ="requestid" value="-1">
<input type=hidden name="rand" value="<%=System.currentTimeMillis()%>">
<input type=hidden name="needoutprint" value="">
<input type="hidden" name="htmlfieldids" id="htmlfieldids">
<iframe name="delzw" width=0 height=0 style="border:none;"></iframe>






<SCRIPT language="javascript">
var js_hrmResourceShow = "<%=hrmResourceShow%>";
function onShowSignBrowserHtml(url,linkurl,inputname,spanname,type1) {
    var tmpids = jQuery("#" + inputname).val();
    var url;
    var dialog = new window.top.Dialog();
    if (type1 === 37) {
        url = "/systeminfo/BrowserMain.jsp?url=" + url + "?documentids=" + tmpids;
        dialog.Title = "<%=SystemEnv.getHtmlLabelName(857, user.getLanguage())%>";
    } else {
        url = "/systeminfo/BrowserMain.jsp?url=" + url + "?resourceids=" + tmpids;
        dialog.Title = "<%=SystemEnv.getHtmlLabelName(1044, user.getLanguage())%>";
    }

    dialog.currentWindow = window;
    dialog.callbackfunParam = null;
    dialog.URL = url;
    dialog.callbackfun = function (paramobj, id1) {
        if (id1) {
		   if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
				var resourceids = wuiUtil.getJsonValueByIndex(id1, 0);
				var resourcename = wuiUtil.getJsonValueByIndex(id1, 1);
				var sHtml = ""
				$GetEle(inputname).value = resourceids;
				var resourceidArray = resourceids.split(",");
				var resourcenameArray = resourcename.split(",");
				for (var _i=0; _i<resourceidArray.length; _i++) {
					var curid = resourceidArray[_i];
					var curname = resourcenameArray[_i];
					sHtml += "<span class='e8_showNameClass'><a href='javascript:void(0);'   target='_blank'>"+curname+"</a>&nbsp;<span class='e8_delClass' onmouseover='javascript:showX(this)' onmouseout='javascript:hideX(this)' onclick='del(event,this,1,false,{});delVal("+inputname+","+curid+");' style='opacity: 0; visibility: visible;'>&nbsp;x&nbsp;</span></span>";			
				}
				$GetEle(spanname).innerHTML = sHtml;
		   } else {
			    $GetEle(spanname).innerHTML = "";
				$GetEle(inputname).value="";
		   }
       }
    } ;
    dialog.Height = 620 ;
    dialog.Drag = true;
    dialog.show();
}
function showX(obj){
  $(obj).css("opacity","1");
}
function hideX(obj){
  $(obj).css("opacity","0");
}
function delVal(inputname,val){
  alert($("#"+inputname).val());
  $("#"+inputname).val($(this).val().replace(val,""));
  alert($("#"+inputname).val());
}

var splitchar = "<%=WFLayoutToHtml.HTML_FIELDATTRSQL_SEPARATOR %>";

//字段属性联动依赖的全局对象
var wf__info = {
	"requestid": "0",
	"workflowid": "<%=workflowid %>",
	"nodeid": "<%=nodeid %>",
	"formid": "<%=formid %>",
	"isbill": "<%=isbill %>",
	"f_bel_userid": "<%=userid %>",
	"f_bel_usertype": "<%=usertype %>",
	"datassplit": "<%=FieldAttrManager.DATAS_SEPARATOR %>",
	"paramsplit": "<%=FieldAttrManager.PARAM_SEPARATOR %>",
	"valuesplit": "<%=FieldAttrManager.VALUE_SEPARATOR %>"
};

<%out.println(jsStr.toString());%>

function accesoryChanage(obj){
	var objValue = obj.value;
	if (objValue=="") return ;
	var fileLenth;
	try {
		File.FilePath=objValue;
		fileLenth= File.getFileSize();
	} catch (e){
		//alert('<%=SystemEnv.getHtmlLabelName(20253,languageid)%>');
		if(e.message=="Type mismatch"||e.message=="类型不匹配"){
			alert("<%=SystemEnv.getHtmlLabelName(21015,languageid)%> ");
		}else{
			alert("<%=SystemEnv.getHtmlLabelName(21090,languageid)%> ");
		}
		createAndRemoveObj(obj);
		return  ;
	}
	if (fileLenth==-1) {
		createAndRemoveObj(obj);
		return ;
	}
	var fileLenthByM = (fileLenth/(1024*1024)).toFixed(1)
	if (fileLenthByM><%=maxUploadImageSize%>) {
		alert("<%=SystemEnv.getHtmlLabelName(20254,languageid)%>"+fileLenthByM+"M,<%=SystemEnv.getHtmlLabelName(20255,languageid)%><%=maxUploadImageSize%>M<%=SystemEnv.getHtmlLabelName(20256 ,languageid)%>");
		createAndRemoveObj(obj);
	}
}

</script>
<SCRIPT language="javascript">
function checkNodesNumFun() {
     var returnValue =true;
	try {
		<%
		int checkdetailno = 0;
		if(isbill > 0) {
			if(formid==7||formid==156 || formid==157 || formid==158) {
		%>
				var rowneed = $G('rowneed').value;
				var nodesnum = $G('nodesnum').value;
				nodesnum = nodesnum*1;
				if(rowneed=="1") {
					if(nodesnum<=0) {
						 alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>1<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
					     returnValue = false;
					}
				}
		<%
			} else {
				rs_html.execute("select tablename,title from Workflow_billdetailtable where billid="+formid+" order by orderid");
				while(rs_html.next()) {
				      checkdetailno ++;
				}
	   	%>
	   	   var detailSum = <%=checkdetailno%>;
	   	   for(var i=0;i<detailSum;i++){
                  var rowneed = jQuery('#rowneed'+i).val();
		          var nodesnum = jQuery('#nodesnum'+i).val();
		          nodesnum = nodesnum*1;
			      if(rowneed == "1") {
			           if(nodesnum<=0) {
					       alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+(i+1)+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
					       returnValue = false;
					       break;
				        }
			      }
	   	   }
	   	<%	
			}
		} else {
	    %>
	    <%
		  int checkGroupId=0;
		  StringBuffer checkGroupIdStr=new StringBuffer();
		  rs_html.executeSql("select distinct groupId from Workflow_formfield where formid="+formid+" and isdetail='1' order by groupid");
		  while (rs_html.next()) {
			checkGroupId=rs_html.getInt(1);
			checkGroupIdStr.append(checkGroupId+",");
		  }
		  if(checkGroupIdStr.lastIndexOf(",")>=0){
		      checkGroupIdStr.delete(checkGroupIdStr.lastIndexOf(","),checkGroupIdStr.length());
		  }
	    %>
	      var checkGroupIdStr = '<%=checkGroupIdStr%>';
	      if(checkGroupIdStr != ''){ //判断组是否为空




	          if(checkGroupIdStr.indexOf(",")>=0){
	              var checkGroupIdArray = checkGroupIdStr.split(",");
	              for(var i=0;i<checkGroupIdArray.length;i++){
	                    var ga=checkGroupIdArray[i];
	                    var rowneed = $G('rowneed'+ga).value;
						var nodesnum = $G('nodesnum'+ga).value;
						nodesnum = nodesnum*1;
						if(rowneed=="1") {
							if(nodesnum<=0) {
								alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>"+(i+1)+"<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
							    returnValue = false;
							    break;
							}
						}
	              }
	          }else{ //只有一组的时候




	                var rowneed = $G('rowneed'+checkGroupIdStr).value;
					var nodesnum = $G('nodesnum'+checkGroupIdStr).value;
					nodesnum = nodesnum*1;
					if(rowneed=="1") {
						if(nodesnum<=0) {
							alert("<%=SystemEnv.getHtmlLabelName(24827,user.getLanguage())%>1<%=SystemEnv.getHtmlLabelName(24828,user.getLanguage())%>!");
						    returnValue = false;
						}
					}
	          }   
	       }
	<%
		}
	%>
	} catch(e) {
	}
	return returnValue;
}

function checkNodesNumFunForSave() {
	return true;
}

//默认大小
var uploadImageMaxSize = <%=maxUploadImageSize%>;
var uploaddocCategory="<%=docCategory%>";
//填充选择目录的附件大小信息




var selectValues = new Array();
var maxUploads = new Array();
var uploadCategorys=new Array();
function setMaxUploadInfo()
{
<%
if(secCategorys!=null&&secMaxUploads!=null&&secMaxUploads.size()>0)
{
	Set selectValues = secMaxUploads.keySet();

	for(Iterator i = selectValues.iterator();i.hasNext();)
	{
		String value = (String)i.next();
		String maxUpload = (String)secMaxUploads.get(value);
		String uplCategory=(String)secCategorys.get(value);
%>
		selectValues.push('<%=value%>');
		maxUploads.push('<%=maxUpload%>');
        uploadCategorys.push('<%=uplCategory%>');
<%
	}
}
%>
}


<%
Hashtable fieldvalue_hs = (Hashtable)otherPara_hs.get("fieldvalue_hs");
if(uploadType==1 && !selectedfieldid.equals("")){
	if(null!=fieldvalue_hs &&fieldvalue_hs.containsKey("inoperatevalue"+selectedfieldid)){
		selectfieldvalue = (String)fieldvalue_hs.get("inoperatevalue"+selectedfieldid);
	}
}

%>

setMaxUploadInfo();
//目录发生变化时，重新检测文件大小




function reAccesoryChanage()
{
	<%
	if(uploadfieldids!=null){
    for(int i=0;i<uploadfieldids.size();i++){
    %>
    checkfilesize(oUpload<%=uploadfieldids.get(i)%>,uploadImageMaxSize,uploaddocCategory);
    showmustinput(oUpload<%=uploadfieldids.get(i)%>);
    <%}}%>
    
    checkfilesize2();
}

function changeMaxUpload2(fieldid,derecorderindex){

   var uploadMaxFieldisedit = jQuery("#uploadMaxField").attr("isedit");
   
   if(!!uploadMaxFieldisedit && uploadMaxFieldisedit=="1"){
	    var selectfieldv = jQuery("#"+fieldid).val();
		for(var i = 0;i<selectValues.length;i++)
		{
			var value = selectValues[i];
			if(value == selectfieldv)
			{
				uploadImageMaxSize = parseFloat(maxUploads[i]);
                uploaddocCategory=uploadCategorys[i];
			}
		}
		jQuery("#selectfieldvalue").val(selectfieldv);	
		if(selectfieldv=="")
		{
			uploadImageMaxSize = 5;
			maxUploadImageSize = 5;
			uploaddocCategory="";
			//var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			var fieldlable = "<%=selectfieldlable%>";
			jQuery("span[id^='uploadspan']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
			});
		}else{
			maxUploadImageSize = uploadImageMaxSize;
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+uploadImageMaxSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
			});
		}
	}else{
   
    <%
	if(uploadType==1){
	    if(selectfieldvalue.equals("")){
	%>
			uploadImageMaxSize = 5;
			maxUploadImageSize = 5;
			uploaddocCategory = "";
			//var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			var fieldlable = "<%=selectfieldlable%>";
			
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
			});
	<%  }else{%>
	        for(var i = 0;i<selectValues.length;i++)
			{
				var value = selectValues[i];
				if(value == "<%=selectfieldvalue%>")
				{
					uploadImageMaxSize = parseFloat(maxUploads[i]);
	                uploaddocCategory=uploadCategorys[i];
				}
			}
			maxUploadImageSize = uploadImageMaxSize;
			jQuery("span[id^='uploadspan_"+derecorderindex+"']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+uploadImageMaxSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
			});
	<%
		}
	}
	%>
	
	}
}




	    
//选择目录时，改变对应信息
function changeMaxUpload(fieldid)
{
	var efieldid = $G(fieldid);
	if(efieldid)
	{
		var tselectValue = efieldid.value;
		for(var i = 0;i<selectValues.length;i++)
		{
			var value = selectValues[i];
			if(value == tselectValue)
			{
				uploadImageMaxSize = parseFloat(maxUploads[i]);
                uploaddocCategory=uploadCategorys[i];
			}
		}
		
		var oUploadArray = new Array();
		var oUploadfieldidArray = new Array();
		<%
		if(uploadfieldids!=null){
		   	for(int i=0;i<uploadfieldids.size();i++){
		   %>
		oUploadArray.push(oUpload<%=uploadfieldids.get(i)%>);
		oUploadfieldidArray.push("<%=uploadfieldids.get(i)%>");
		<%
			}
		}
		%>
		jQuery("#selectfieldvalue").val(tselectValue);
		if(tselectValue=="")
		{
			uploadImageMaxSize = 5;
			uploaddocCategory = "";
			attachmentDisabled(oUploadArray,true,oUploadfieldidArray);
			
			//var fieldlable = jQuery("#"+fieldid).attr("temptitle");
			var fieldlable = "<%=selectfieldlable%>";
			jQuery("span[id^='uploadspan']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
			});
		}else{
		    maxUploadImageSize = uploadImageMaxSize;
			jQuery("span[id^='uploadspan']").each(function(){
				var viewtype = jQuery(this).attr("viewtype");
				if(viewtype == 1){
				    jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+uploadImageMaxSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
				}else{
					jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+uploadImageMaxSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
				}
			});
			attachmentDisabled(oUploadArray,false,oUploadfieldidArray);
		}
	}
}


<%
if(uploadType==1){
%>

function initUploadMax(){
	try{
    	<%
    	if(selectfieldvalue.equals("")){
    	%>
		setTimeout(function(){
				var oUploadArray = new Array();
				var oUploadfieldidArray = new Array();
				<%
				if(uploadfieldids!=null){
				   	for(int i=0;i<uploadfieldids.size();i++){
				   %>
				   try{
					oUploadArray.push(oUpload<%=uploadfieldids.get(i)%>);
					oUploadfieldidArray.push("<%=uploadfieldids.get(i)%>");
				   }catch(e){}
				<%
					}
				}
				%>
				maxUploadImageSize = 5;
				uploadImageMaxSize = 5;
				uploaddocCategory = "";
				attachmentDisabled(oUploadArray,true,oUploadfieldidArray);
				
				var fieldlable = "<%=selectfieldlable%>";
				jQuery("span[id^='uploadspan']").each(function(){
					jQuery(this).html("<%=SystemEnv.getHtmlLabelName(125389,user.getLanguage())%> \""+fieldlable+"\"");
				});
			},2000);
		
		<%}else{%>
		
			for(var i = 0;i<selectValues.length;i++)
			{
				var value = selectValues[i];
				if(value == "<%=selectfieldvalue%>")
				{
					maxUploadImageSize = parseFloat(maxUploads[i]);
					uploadImageMaxSize = maxUploadImageSize;
                	uploaddocCategory=uploadCategorys[i];
				}
			}
			jQuery("span[id^='uploadspan']").each(function(){
				jQuery(this).html("<%=SystemEnv.getHtmlLabelName(83523,user.getLanguage())%>"+maxUploadImageSize+"<%=SystemEnv.getHtmlLabelName(83528,user.getLanguage())%>");
			});
		<%}%>
    	
    }catch(e){}
}

initUploadMax();
<%}%>


function addannexRow(accname,maxsize){
	//区分两种添加方式
	var uploadspan = "";
	var checkMaxUpload = 0;
	if(accname!="field-annexupload"){
		maxsize = <%=maxUploadImageSize%>;
		uploadspan = "uploadspan";
  	}else{
		checkMaxUpload = maxsize;
  	}
	$G(accname+'_num').value=parseInt($G(accname+'_num').value)+1;
	var ncol = $G(accname+'_tab').cols;
	var oRow = $G(accname+'_tab').insertRow(-1);
	for(j=0; j<ncol; j++){
		var oCell = oRow.insertCell(-1); 
		oCell.style.height=24;
		switch(j){
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
	 		case 0:
				var oDiv = document.createElement("div");
				var sHtml = "<input class=InputStyle  type=file size=60 name='"+accname+"_"+$G(accname+'_num').value+"' onchange='accesoryChanage(this,"+checkMaxUpload+")'> (<%=SystemEnv.getHtmlLabelName(18976,languageid)%>"+maxsize+"<%=SystemEnv.getHtmlLabelName(18977,languageid)%>) ";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
}

/*
function funcClsDateTime(){
	var onlstr = new clsDateTime();
}				

if (window.addEventListener){
    window.addEventListener("load", funcClsDateTime, false);
}else if (window.attachEvent){
    window.attachEvent("onload", funcClsDateTime);
}else{
    window.onload=funcClsDateTime;
}*/


function createDoc(fieldbodyid,docVlaue,tempDocView){
	
	/*
   for(i=0;i<=1;i++){
  		parent.$G("oTDtype_"+i).background="/images/tab2_wev8.png";
  		parent.$G("oTDtype_"+i).className="cycleTD";
  	}
  	parent.$G("oTDtype_1").background="/images/tab.active2_wev8.png";
  	parent.$G("oTDtype_1").className="cycleTDCurrent";
	*/
	try{
		var requestid=-1;
		if($G("requestid")!=null) requestid=$G("requestid").value;
		if(parseInt(requestid)>0){
			$G("iscreate").value="0";
		}
	}catch(e){
	}
	var _isagent = "";
    var _beagenter = "";
	if($G("_isagent")!=null) _isagent=$G("_isagent").value;
    if($G("_beagenter")!=null) _beagenter=$G("_beagenter").value;
  	frmmain.action = "RequestOperation.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=usertype%>&isagent="+_isagent+"&beagenter="+_beagenter+"&docView=1&docValue="+docVlaue;
    frmmain.method.value = "crenew_"+fieldbodyid ;
    frmmain.target="delzw";
    parent.delsave();
	if(check_form(document.frmmain,'requestname')){
		if($G("needoutprint")) $G("needoutprint").value = "1";//标识点正文




        document.frmmain.src.value='save';

//保存签章数据
<%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
						try{  
					        if(typeof(eval("SaveSignature_save"))=="function"){
					              if(SaveSignature_save()){
			                            //附件上传
			                            StartUploadAll();
			                            checkuploadcompletBydoc();
			                        }else{
										if(isDocEmpty==1){
											alert("\""+"<%=SystemEnv.getHtmlLabelName(17614,user.getLanguage())%>"+"\""+"<%=SystemEnv.getHtmlLabelName(21423,user.getLanguage())%>");
											isDocEmpty=0;
										}else{
											alert("<%=SystemEnv.getHtmlLabelName(21442,user.getLanguage())%>");
										}
										return ;
									}
					        }
					    }catch(e){
					        StartUploadAll();
			                checkuploadcompletBydoc();
					    }
	                 
<%}else{%>
                        //附件上传
                        StartUploadAll();
                        checkuploadcompletBydoc();
<%}%>

    }
}
function onNewDoc(fieldbodyid) {

	frmmain.action = "RequestOperation.jsp" ;
	frmmain.method.value = "docnew_"+fieldbodyid ;
	frmmain.isMultiDoc.value = fieldbodyid ;
	if(check_form(document.frmmain,'requestname')){
         //附件上传
         StartUploadAll();
		document.frmmain.src.value='save';
        jQuery($GetEle("flowbody")).attr("onbeforeunload", "");
		checkuploadcomplet();
	}
}


	function doSave(){			  <!-- 点击保存按钮 -->
		enableAllmenu();
    	//var nodenum = checkNodesNumFun();
    	var nodenum = checkNodesNumFunForSave();
    	if(!nodenum) {
			displayAllmenu();
    		return false;
    	}
	
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
		

<%
	if(isSignMustInput.equals("1")){
		if("1".equals(isFormSignature)){
		}else{
%>
			if(ischeckok=="true"){
			    //保存时不验证签字意见必填
				//if(!check_form(document.frmmain,'remarkText10404')){
				//	ischeckok="false";
				//}
			}
<%
		}
	}
%>
		if(ischeckok=="true"){
			CkeditorExt.updateContent();
			if(checktimeok()) {
					document.frmmain.src.value='save';
					jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201


//保存签章数据
<%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
						try{  
					        if(typeof(eval("SaveSignature_save"))=="function"){
					              //保存时不验证签字意见必填
						if(SaveSignature_save()||!SaveSignature_save()){
							//TD4262 增加提示信息  开始




							var content="<%=SystemEnv.getHtmlLabelName(18979,languageid)%>";
							showPrompt(content);
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




							var content="<%=SystemEnv.getHtmlLabelName(18979,languageid)%>";
							showPrompt(content);
							//TD4262 增加提示信息  结束
							//附件上传
							StartUploadAll();
							checkuploadcomplet();
					    }
                    
<%}else{%>
						//TD4262 增加提示信息  开始




						var content="<%=SystemEnv.getHtmlLabelName(18979,languageid)%>";
						showPrompt(content);
						//TD4262 增加提示信息  结束
						//附件上传
						StartUploadAll();
						checkuploadcomplet();
<%}%>
				}
			} else {
				displayAllmenu();
			}
	}

	
	
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
	
	function doSubmitE8(obj){			<!-- 点击提交 -->
		enableAllmenu();
	    var nodenum = checkNodesNumFun();
    	if(!nodenum) {
			displayAllmenu();
    		return false;
    	}
	
	  //modify by xhheng @20050328 for TD 1703
	  //明细部必填check，通过try $G("needcheck")来检查,避免对原有无明细单据的修改
		if(!checkCustomize()){
			displayAllmenu();
			return false;
		}
		// QC209437 added by 2016-08-15
		if(!checkCarSubmit()){
			displayAllmenu();
			return false;
		}
		
		var ischeckok="";
		try{
			var needCheckStr = $G("needcheck").value+$G("inputcheck").value;
			if(!!needCheckStr && jQuery("input#edesign_layout").length>0)
				needCheckStr = viewattrOperator.filterHideField(needCheckStr);
			if(check_form(document.frmmain, needCheckStr))
				ischeckok="true";
		}catch(e){
			ischeckok="false";
		}
		if(ischeckok=="false"){
			var needCheckStr = '<%=needcheck%>';
			if(!!needCheckStr && jQuery("input#edesign_layout").length>0)
				needCheckStr = viewattrOperator.filterHideField(needCheckStr);
			if(check_form(document.frmmain, needCheckStr))
				ischeckok="true";
		}

<%
	if(isSignMustInput.equals("1")){
		if("1".equals(isFormSignature)){
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
			CkeditorExt.updateContent();
			if(checktimeok()) {
				document.frmmain.src.value='submit';
				jQuery($GetEle("flowbody")).attr("onbeforeunload", "");//added by xwj for td3247 20051201

		if("<%=formid%>"==201){//资产报废单据明细中的资产报废数量大于库存数量，不能提交。




			nodesnum = $G("nodesnum").value;
			for(var tempindex1=0;tempindex1<nodesnum;tempindex1++){
				var capitalcount = $G("node_"+tempindex1+"_capitalcount").value*1;
				var fetchingnumber=$G("node_"+tempindex1+"_number").value*1;
				for(var tempindex2=0;tempindex2<nodesnum;tempindex2++){
					if(tempindex2!=tempindex1&&$G("node_"+tempindex1+"_capitalid").value==$G("node_"+tempindex2+"_capitalid").value){
						fetchingnumber = fetchingnumber*1 + $G("node_"+tempindex2+"_number").value*1;
					}
				}
				if(fetchingnumber>capitalcount){
					alert("<%=SystemEnv.getHtmlLabelName(15313,languageid)%><%=SystemEnv.getHtmlLabelName(15508,languageid)%><%=SystemEnv.getHtmlLabelName(1446,languageid)%>");
					displayAllmenu();
					return;
				}
			}
		}

//保存签章数据
<%if("1".equals(isFormSignature)&&!isHideInput.equals("1")){%>
					if(SaveSignature()){
							//TD4262 增加提示信息  开始




							var content="<%=SystemEnv.getHtmlLabelName(18978,languageid)%>";
							showPrompt(content);
							//TD4262 增加提示信息  结束

							obj.disabled=true;
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
<%}else{%>
						//TD4262 增加提示信息  开始




						var content="<%=SystemEnv.getHtmlLabelName(18978,languageid)%>";
						showPrompt(content);
						//TD4262 增加提示信息  结束

						obj.disabled=true;
						//附件上传
						StartUploadAll();
						checkuploadcomplet();
<%}%>
			}
		} else {
			displayAllmenu();
		}
	}

  setTimeout("doTriggerInit()",1500);
  function doTriggerInit(){
	  var tempS = "<%=trrigerfield%>";
	  datainput(tempS);
  }
  function getWFLinknum(wffiledname){
		if($G(wffiledname) != null){
			return $G(wffiledname).value;
		}else{
			return 0;
		}
	}
  function datainput(parfield){				<!--数据导入-->
	  //var xmlhttp=XmlHttp.create();
  try{
		if(event.propertyName && event.propertyName.toLowerCase() != "value"){
			return;
		}
		var src = event.srcElement || event.target; // 
		if(src.tagName.toLowerCase() == 'button'){
			return ;
		}
	}catch(e){}
	  var tempParfieldArr = parfield.split(",");
	  var tempdata = "";
      var temprand = $GetEle("rand").value ;
	  var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+parfield;
	  var tempdata = "";
	  for(var i=0;i<tempParfieldArr.length;i++){
	  	var tempParfield = tempParfieldArr[i];
		try{
	  	tempdata += $G(tempParfield).value+"," ;
		}catch(e){}
	  <%
	  if(!trrigerfield.trim().equals("")){
		  ArrayList Linfieldname=ddi.GetInFieldName();
		  ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
		  for(int i=0;i<Linfieldname.size();i++){
			  String temp=(String)Linfieldname.get(i);
	  %>
		  if($G("<%=temp.substring(temp.indexOf("|")+1)%>") && StrData.indexOf("&<%=temp%>=") === -1) StrData+="&<%=temp%>="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>").value);
	  <%
		  }
		  for(int i=0;i<Lcondetionfieldname.size();i++){
			  String temp=(String)Lcondetionfieldname.get(i);
	  %>
		  if($G("<%=temp.substring(temp.indexOf("|")+1)%>") && StrData.indexOf("&<%=temp%>=") === -1) StrData+="&<%=temp%>="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>").value);
	  <%
		  }
		  }
	  %>
	  }
	  StrData += "&trgv="+tempdata+"&rand="+temprand+"&tempflag="+Math.random();
	  StrData = StrData.replace(/\+/g,"%2B");
	  //$G("datainputform").src="DataInputFrom.jsp?"+StrData;
	  if($GetEle("datainput_"+parfield)){
		  	$GetEle("datainput_"+parfield).src = "DataInputFrom.jsp?"+StrData;
	  }else{
	  		createIframe("datainput_"+parfield);
	  		$GetEle("datainput_"+parfield).src = "DataInputFrom.jsp?"+StrData;
	  }
	  //xmlhttp.open("POST", "DataInputFrom.jsp", false);
	  //xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	  //xmlhttp.send(StrData);
  }
var defaultrows = 0;
var iframenameid = 0;
var temptime = 1;
var existArray = new Array();

function datainputdCreateIframe(iframenameid,StrData){
	  var iframe_datainputd = document.createElement("iframe");
      iframe_datainputd.id = "iframe_"+iframenameid;
	  iframe_datainputd.src = "";
	  iframe_datainputd.frameborder = "0";
	  iframe_datainputd.height = "0";
	  iframe_datainputd.scrolling = "no";
	  iframe_datainputd.style.display = "none";
	  document.body.appendChild(iframe_datainputd);
	  $GetEle("iframe_"+iframenameid).src="DataInputFromDetail.jsp?"+StrData;
}

Array.prototype.contains = function(obj){
  	var i = this.length;
  	while(i--){
  		if(this[i]===obj){
  			return true;
  		}
  	}
  	return false;
}
function datainputd(parfield){				<!--数据导入-->
	try{
		if(event.propertyName && event.propertyName.toLowerCase() != "value"){
			return;
		}
	}catch(e){}
  //var xmlhttp=XmlHttp.create();
  var tempParfieldArr = parfield.split(",");
	var StrData="id=<%=workflowid%>&formid=<%=formid%>&bill=<%=isbill%>&node=<%=nodeid%>&detailsum=<%=detailsum%>&trg="+parfield;

	for(var i=0;i<tempParfieldArr.length;i++){
      	var tempParfield = tempParfieldArr[i];
      	var indexid=tempParfield.substr(tempParfield.indexOf("_")+1);

  <%
	if(!trrigerdetailfield.trim().equals("")){
		ArrayList Linfieldname=ddi.GetInFieldName();
		ArrayList Lcondetionfieldname=ddi.GetConditionFieldName();
		for(int i=0;i<Linfieldname.size();i++){
			String temp=(String)Linfieldname.get(i);

  %>
		if($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)!=null) StrData+="&<%=temp%>="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value);

  <%
		}
		for(int i=0;i<Lcondetionfieldname.size();i++){
		  String temp=(String)Lcondetionfieldname.get(i);
  %>
			if($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid)) StrData+="&<%=temp%>="+escape($G("<%=temp.substring(temp.indexOf("|")+1)%>_"+indexid).value);
  <%
			}
		}
  %>
  }
		
	  iframenameid++;
	  StrData = StrData.replace(/\+/g,"%2B");
	  /*
      //$GetEle("datainputformdetail").src="DataInputFromDetail.jsp?"+StrData;
	  if(existArray.contains(parfield)){ //延时执行
	        if(temptime>defaultrows){
	        	temptime = 1;
	        }else{
	        	//temptime++;
	        }  
	    	window.setTimeout(function(){ 
			    datainputdCreateIframe(iframenameid,StrData); 
			},100*temptime); 
			
	  }else{
	  	existArray.push(parfield);
	  	datainputdCreateIframe(iframenameid,StrData)
	  } 
	  */
	  datainputdCreateIframe(iframenameid,StrData)
  //xmlhttp.open("POST", "DataInputFrom.jsp", false);
  //xmlhttp.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
  //xmlhttp.send(StrData);
}


if (window.addEventListener){
	window.addEventListener("load", showfieldpop, false);
}else if (window.attachEvent){
	window.attachEvent("onload", showfieldpop);
}else{
	window.onload=showfieldpop;
}

function changeChildField(obj, fieldid, childfieldid){
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=<%=isbill%>&selectedfieldid=<%=selectedfieldid%>&uploadType=<%=uploadType%>&isdetail=0&selectvalue="+obj.value;
    $G("selectChange").src = "SelectChange.jsp?"+paraStr;
    //alert($G("selectChange").src);
}
function doInitChildSelect(fieldid,pFieldid,finalvalue){
	try{
		var pField = $G("field"+pFieldid);
		if(pField != null){
			var pFieldValue = pField.value;
			if(pFieldValue==null || pFieldValue==""){
				return;
			}
			if(pFieldValue!=null && pFieldValue!=""){
				var field = $G("field"+fieldid);
			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&selectedfieldid=<%=selectedfieldid%>&uploadType=<%=uploadType%>&isdetail=0&selectvalue="+pFieldValue+"&childvalue="+finalvalue;
				var frm = document.createElement("iframe");
				frm.id = "iframe_"+pFieldid+"_"+fieldid+"_00";
				frm.style.display = "none";
			    document.body.appendChild(frm);
				$G("iframe_"+pFieldid+"_"+fieldid+"_00").src = "SelectChange.jsp?"+paraStr;
			}
		}
	}catch(e){}
}
function changeChildFieldDetail(obj, fieldid, childfieldid, rownum){
    var paraStr = "fieldid="+fieldid+"&childfieldid="+childfieldid+"&isbill=<%=isbill%>&selectvalue="+obj.value+"&isdetail=1&&rowindex="+rownum;
    $G("selectChangeDetail").src = "SelectChange.jsp?"+paraStr;
    //alert($G("selectChange").src);
}
function doInitDetailchildSelect(fieldid,pFieldid,rownum,childvalue){
	try{
		var pField = $G("field"+pFieldid+"_"+rownum);
		if(pField != null){
			var pFieldValue = pField.value;
			if(pFieldValue==null || pFieldValue==""){
				return;
			}
			if(pFieldValue!=null && pFieldValue!=""){
				var field = $G("field"+fieldid+"_"+rownum);
				var frm = document.createElement("iframe");
				frm.id = "iframe_"+pFieldid+"_"+fieldid+"_"+rownum;
				frm.style.display = "none";
			    document.body.appendChild(frm);
			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&selectvalue="+pFieldValue+"&isdetail=1&&rowindex="+rownum+"&childvalue="+childvalue;
				$G("iframe_"+pFieldid+"_"+fieldid+"_"+rownum).src = "SelectChange.jsp?"+paraStr;
			}
		}
	}catch(e){}
}
function doInitDetailchildSelectAdd(fieldid,pFieldid,rownum,childvalue){
	try{
		var pField = $G("field"+pFieldid+"_"+rownum);
		if(pField != null){
			var pFieldValue = pField.value;
			if(pFieldValue==null || pFieldValue==""){
				return;
			}
			if(pFieldValue!=null && pFieldValue!=""){
			
				var frm = document.createElement("iframe");
				frm.id = "iframe_"+pFieldid+"_"+fieldid+"_"+rownum;
				frm.style.display = "none";
			    document.body.appendChild(frm);
				
				var field = $G("field"+fieldid+"_"+rownum);
			    var paraStr = "fieldid="+pFieldid+"&childfieldid="+fieldid+"&isbill=<%=isbill%>&selectvalue="+pFieldValue+"&isdetail=1&&rowindex="+rownum+"&childvalue="+childvalue;
				$G("iframe_"+pFieldid+"_"+fieldid+"_"+rownum).src = "SelectChange.jsp?"+paraStr;
				
			}
		}
	}catch(e){}
}
</script>
<script language="javascript">
function getNumber(index){
	 if($GetEle("field"+index).value != ""){ 

	    $GetEle("field_lable"+index).value = floatFormat($GetEle("field"+index).value);
	 }
	 try{
	   var elm = $GetEle("field_lable"+index);
	   var n = getLocation(elm);
	   setLocation(elm,n);
	 }catch(e){}
}
function getNumber2(index){
	   if($GetEle("field"+index).value != ""){
		 $GetEle("field_lable"+index).value = floatFormat($GetEle("field"+index).value);
	   }
	}
//明细表中金额转换字段调用
function numberToChinese(index){
	if($G("field_lable"+index).value != ""){
		var floatNum = floatFormat($G("field_lable"+index).value);
		var val = numberChangeToChinese(floatNum);
		if(val == ""){
			alert("<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage())%>");
			$G("field_lable"+index).value = "";
			$G("field"+index).value = "";
		}else{
			$G("field_lable"+index).value = val;
			$G("field"+index).value = floatNum;
		}
	} else {
		$G("field"+index).value = "";
	}
}
var tableformatted = false;
var needformatted = true;
function formatTables(){
	if(needformatted){
		jQuery("table[name^='oTable']").each(function(i,n){
			tableformatted = true;
			formatTable(n);
		});
		jQuery("table[name^='oTable']").bind("resize",function(){
			formatTable(this);
		});
	}
}

jQuery(document).ready(function(){
	try{
		createTags();
	}catch(e){}
	<% String useNew = Util.null2String(new weaver.general.BaseBean().getPropValue("workflow_htmlNew","useNew"));
		  String fixHeight = Util.null2String(new weaver.general.BaseBean().getPropValue("workflow_htmlNew","fixHeight"));
		  if(fixHeight.equals("") || fixHeight.equals("0"))fixHeight = "49";
		if("1".equals(useNew)){
	%>
	window.setTimeout(function(){
		startFormatTableNew();
	},100);
	<%}else{%>
		formatTables();	
	<%}%>
});

var msgWarningJinEConvert = "<%=SystemEnv.getHtmlLabelName(31181,user.getLanguage())%>";
</script>
<script type="text/javascript" language="javascript" src="/js/datetime_wev8.js"></script>
<script type="text/javascript" language="javascript" src="/js/selectDateTime_wev8.js"></script>
<%
	if("1".equals(useNew)){
%>
<style type="text/css">
	Table.ListStyle  TBODY  TR TD{
		padding-top:2px;
		padding-bottom:2px;
	}
</style>
<%}else{%>
	<style type="text/css">
	Table.ListStyle  TBODY  TR TD.detailfield{
		height: <%=fixHeight+"px"%>;
	}
</style>
<%}%>
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
						data: {field627:field627,field634:field634,field635:field635,field636:field636,field637:field637,workflowid:'<%=workflowid%>'},
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