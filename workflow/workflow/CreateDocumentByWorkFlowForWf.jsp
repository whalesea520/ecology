<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>

<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>

<%@ page import="org.apache.commons.lang.StringUtils"%>

<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.Prop" %>
<%@ page import="weaver.workflow.workflow.WfRightManager"%>
<%@ page import="weaver.workflow.workflow.UserWFOperateLevel" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="WeaverEditTableUtil" class="weaver.docs.util.WeaverEditTableUtil" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="mainCategoryComInfo" class="weaver.docs.category.MainCategoryComInfo" scope="page" />
<jsp:useBean id="subCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="secCategoryComInfo" class="weaver.docs.category.SecCategoryComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ktm" class="weaver.general.KnowledgeTransMethod" scope="page" />
<jsp:useBean id="wfmm" class="weaver.workflow.workflow.WFMainManager" scope="page" />
<jsp:useBean id="BaseBean" class="weaver.general.BaseBean" scope="page" />
<jsp:useBean id="manageDetachComInfo" class="weaver.hrm.moduledetach.ManageDetachComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />

<%@ include file="/systeminfo/init_wev8.jsp" %>

<%
    int workflowId = Util.getIntValue(request.getParameter("wfid"),-1);
    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
    int subCompanyID= Util.getIntValue(Util.null2String(session.getAttribute(workflowId+"subcompanyid")),-1);
    boolean haspermission = wfrm.hasPermission3(workflowId, 0, user, WfRightManager.OPERATION_CREATEDIR);
	String rightStr = "WorkflowManage:All";
	if (!HrmUserVarify.checkUserRight(rightStr, user) && !haspermission) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
    int operateLevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subCompanyID,user,haspermission,rightStr);
    if(operateLevel < 1){
        response.sendRedirect("/notice/noright.jsp");
        return;
    }

    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(19331,user.getLanguage());
    String needfav = "";
    String needhelp = "";
    
    String formID = request.getParameter("formid");
    String isbill = request.getParameter("isbill");
    if(StringUtils.isBlank(formID) || StringUtils.isBlank(isbill)) {
        RecordSet.executeSql("select formid,isbill from workflow_base where id="+workflowId);
        if(RecordSet.next()){
            formID = Util.null2String(RecordSet.getString("formid"));
            isbill = Util.null2String(RecordSet.getString("isbill"));
        }
    }
    isbill = "1".equals(isbill) ? "1" : "0";
    String isDialog = Util.null2String(request.getParameter("isdialog"));
    int tabIndex = Util.getIntValue(request.getParameter("tabIndex"),1);
	int docPropId_Trace=0;
    RecordSet.executeSql("select id from TraceProp where workflowId="+workflowId);
    if(RecordSet.next()){
        docPropId_Trace = Util.getIntValue(RecordSet.getString("id"),0);	  
    }
    
    String ifVersion = "0";
    int titleFieldId = 0;
    int keywordFieldId = 0;
    int officalType = 0;
    RecordSet.executeSql("select ifVersion,titleFieldId,keywordFieldId,officaltype from workflow_base where id=" +workflowId);
    if(RecordSet.next()){
        officalType = Util.getIntValue(RecordSet.getString("officaltype"),0);
        ifVersion = Util.null2String(RecordSet.getString("ifVersion"));
        titleFieldId = Util.getIntValue(RecordSet.getString("titleFieldId"),0);
        keywordFieldId = Util.getIntValue(RecordSet.getString("keywordFieldId"),0);
    }
    boolean canBeSet=true;
    if("1".equals(isbill)){
        canBeSet=false;
        String createPage="";
        String managePage="";
        String viewPage="";
        String operationPage="";
        RecordSet.executeSql("select createPage,managePage,viewPage,operationPage from workflow_bill where id= " + formID);
        if(RecordSet.next()){
            createPage=Util.null2String(RecordSet.getString("createPage"));
            managePage=Util.null2String(RecordSet.getString("managePage"));
            viewPage=Util.null2String(RecordSet.getString("viewPage"));
            operationPage=Util.null2String(RecordSet.getString("operationPage"));
        }
        if(createPage.equals("")&&managePage.equals("")&&viewPage.equals("")&&operationPage.equals("")){
            canBeSet=true;
        }
    }
    // 流程创建文档 相关配置
    String status = "0";
    int flowCodeField = -1;
    int flowDocField = -1;
    int documentTitleField = -1;
    int flowDocCatField = -1;
    int useTempletNode = -1;
    String printNodes = "";
    String printNodesName="";
    String newTextNodes = "";
    String uploadPDF = "";
    String onlyCanAddWord = "";// 只能选择WORD文档
    String defaultView = "";
    String mainCategory = "-1";
    String subCategory = "-1";
    String secCategory = "-1";
    String isCompellentMark = "0";
    String isCancelCheck = "0";
    String signatureNodes = "";
    String signatureNodesName = "";
    String isWorkflowDraft = "";
    String isHideTheTraces = "";
    String defaultDocType = "";
    int extfile2doc = 0;
    String openTextDefaultNode = ""; // 默认打开正文的节点
    String cleanCopyNodes="";
    String cleanCopyNodesName="";			
    String isTextInForm = "";
    RecordSet.executeSql("SELECT * FROM workflow_createdoc WHERE workFlowID=" + workflowId);
    if(RecordSet.next()) {
        openTextDefaultNode = RecordSet.getString("openTextDefaultNode");
        status = RecordSet.getString("status");
        flowCodeField = RecordSet.getInt("flowCodeField");
        flowDocField = RecordSet.getInt("flowDocField");
        documentTitleField = RecordSet.getInt("documentTitleField");
        flowDocCatField = RecordSet.getInt("flowDocCatField");
        useTempletNode = RecordSet.getInt("useTempletNode");
        printNodes = Util.null2String(RecordSet.getString("printNodes"));
        uploadPDF = Util.null2String(RecordSet.getString("uploadPDF"));
        newTextNodes = Util.null2String(RecordSet.getString("newTextNodes"));
        onlyCanAddWord = Util.null2String(RecordSet.getString("onlyCanAddWord"));
        signatureNodes = Util.null2String(RecordSet.getString("signatureNodes"));
        isWorkflowDraft = Util.null2String(RecordSet.getString("isWorkflowDraft"));
        defaultDocType = Util.null2String(RecordSet.getString("defaultDocType"));
        isHideTheTraces = Util.null2String(RecordSet.getString("isHideTheTraces"));
        defaultView = RecordSet.getString("defaultView");
        isCompellentMark = Util.null2String(RecordSet.getString("iscompellentmark"));
        isCancelCheck = Util.null2String(RecordSet.getString("iscancelcheck"));
        if("-1||-1||-1".equals(defaultView)) {
            defaultView = "";
        } else {	
            try {
                List defaultViewList = null;
                if(defaultView.indexOf("||")!=-1){
                    defaultViewList = Util.TokenizerString(defaultView, "||");
                }else{
                    defaultViewList = Util.TokenizerString(defaultView, ",");
                }
                mainCategory = (String)defaultViewList.get(0);
                subCategory = (String)defaultViewList.get(1);
                secCategory = (String)defaultViewList.get(2);
                defaultView = secCategoryComInfo.getAllParentName(secCategory,true);
            } catch(Exception e) {
                defaultView = secCategoryComInfo.getAllParentName(defaultView,true);
            }
        }
        extfile2doc = Util.getIntValue(RecordSet.getString("extfile2doc"), 0);
        cleanCopyNodes = Util.null2String(RecordSet.getString("cleanCopyNodes"));
        isTextInForm = Util.null2String(RecordSet.getString("isTextInForm"));			
    }
    List<String> tempStringList = new ArrayList<String>();
    // 默认打开正文的节点
    String openTextDefaultNodes = "";
    if(StringUtils.isNotBlank(openTextDefaultNode)) {
        String[] ids = openTextDefaultNode.split(",");
        for(String id : ids) {
            RecordSet.executeSql("SELECT id,nodename FROM  workflow_nodebase where id = " + id);
            if(RecordSet.next()) {
                tempStringList.add(StringUtils.trimToEmpty(RecordSet.getString("nodename")));
            }
        }
        openTextDefaultNodes = StringUtils.join(tempStringList, ",");
    }
    if(tempStringList.size() > 0) {
        tempStringList = new ArrayList<String>();
    }
    /**清稿节点**/
    if(StringUtils.isNotBlank(cleanCopyNodes)){		
        String[] ids = cleanCopyNodes.split(",");
        for(String id : ids) {
            RecordSet.executeSql("SELECT id,nodename FROM  workflow_nodebase where id = " + id);
            if(RecordSet.next()) {
                tempStringList.add(StringUtils.trimToEmpty(RecordSet.getString("nodename")));
            }
        }
        cleanCopyNodesName = StringUtils.join(tempStringList, ",");
    }
    
    Map docPropIdMap=new HashMap();
    String tempSelectItemId=null;
    String tempDocPropId=null;
    RecordSet.executeSql("SELECT id,selectItemId FROM Workflow_DocProp where workflowId="+workflowId+" and objId=-1");
    while(RecordSet.next()){
        tempSelectItemId=Util.null2String(RecordSet.getString("selectItemId"));
        tempDocPropId=Util.null2String(RecordSet.getString("id"));
        if(StringUtils.isNotBlank(tempSelectItemId)){
            docPropIdMap.put(tempSelectItemId,tempDocPropId);
        }
    }
    int docPropIdDefault = Util.getIntValue((String)docPropIdMap.get("-1"),-1);
    
%>

<HTML>
    <HEAD>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
		<link type="text/css" href="/js/tabs/css/e8tabs6_wev8.css" rel="stylesheet" />
        <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
        <script language="javascript" src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
		<script language="javascript" src="/js/ecology8/request/e8.browser_wev8.js"></script>
		<style type="text/css">
			.magic-line{
				top:21px!important;
			}
		</style>
        <script type="text/javascript">
            var wfJavaParamsObj = {
                workflowId : <%=workflowId %>,
                formId : "<%=formID %>",
                isBill : "<%=isbill %>",
                subCompanyId : <%=subCompanyID %>,
                docPropId_Trace : <%=docPropId_Trace %>,
                tabIndex : <%=tabIndex %>,
                docPropIdDefault : <%=docPropIdDefault %>,
                msg_82 : "<%=SystemEnv.getHtmlLabelName(82, user.getLanguage()) %>",
                msg_86 : "<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>",
                msg_93 : "<%=SystemEnv.getHtmlLabelName(93, user.getLanguage()) %>",
                msg_149 : "<%=SystemEnv.getHtmlLabelName(149, user.getLanguage()) %>",
                msg_19373 : "<%=SystemEnv.getHtmlLabelName(19373, user.getLanguage()) %>",
                msg_23036 : "<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage()) %>",
                msg_21449 : "<%=SystemEnv.getHtmlLabelName(21449, user.getLanguage()) %>",
                msg_25126 : "<%=SystemEnv.getHtmlLabelName(25126, user.getLanguage()) %>",
                msg_33338 : "<%=SystemEnv.getHtmlLabelName(33338, user.getLanguage()) %>",
                msg_28052 : "<%=SystemEnv.getHtmlLabelName(28052, user.getLanguage()) %>",
                msg_33331 : "<%=SystemEnv.getHtmlLabelName(33331, user.getLanguage()) %>",
                msg_33408 : "<%=SystemEnv.getHtmlLabelName(33408, user.getLanguage()) %>",
                msg_19831 : "<%=SystemEnv.getHtmlLabelName(19831, user.getLanguage()) %>",
                msg_33410 : "<%=SystemEnv.getHtmlLabelName(33410, user.getLanguage()) %>",
                msg_33409 : "<%=SystemEnv.getHtmlLabelName(33409, user.getLanguage()) %>",
                msg_33113 : "<%=SystemEnv.getHtmlLabelName(33113, user.getLanguage()) %>",
                msg_18758 : "<%=SystemEnv.getHtmlLabelName(18758, user.getLanguage()) %>",
                msg_22878 : "<%=SystemEnv.getHtmlLabelName(22878, user.getLanguage()) %>",
                msg_33405 : "<%=SystemEnv.getHtmlLabelName(33405, user.getLanguage()) %>",
                msg_33400 : "<%=SystemEnv.getHtmlLabelName(33400, user.getLanguage()) %>",
                msg_33197 : "<%=SystemEnv.getHtmlLabelName(33197, user.getLanguage()) %>",
                msg_30747 : "<%=SystemEnv.getHtmlLabelName(30747, user.getLanguage()) %>",
                msg_33325 : "<%=SystemEnv.getHtmlLabelName(33325, user.getLanguage()) %>",
                msg_32568 : "<%=SystemEnv.getHtmlLabelName(32568, user.getLanguage()) %>",
                msg_32568 : "<%=SystemEnv.getHtmlLabelName(16344, user.getLanguage()) %>",
                msg_33592 : "<%=SystemEnv.getHtmlLabelName(33592, user.getLanguage()) %>",
                msg_83473 : "<%=SystemEnv.getHtmlLabelName(83473, user.getLanguage()) %>",
                msg_83409 : "<%=SystemEnv.getHtmlLabelName(83409, user.getLanguage()) %>",
                msg_129500 : "<%=SystemEnv.getHtmlLabelName(129500, user.getLanguage()) %>",
                msg_33435 : "<%=SystemEnv.getHtmlLabelName(33435, user.getLanguage()) %>"
                
            };
        </script>
        <script type="text/javascript" src="/js/odoc/workflow/workflow/CreateDocumentByWorkFlowForWf.js"></script>
		<script type="text/javascript">
			function onLog(){
				_onViewLog(220, wfJavaParamsObj.workflowId);
			}
			function selectCurrent(obj){
				jQuery("ul").children("li").removeClass("current");
				jQuery(obj).parent("li").addClass("current");
			}
			function openOrClose(obj){
				if(obj.checked){
					jQuery(".wfcontent").show();
				}else{
					//jQuery(".wfcontent").hide();
				}
			}
			var __tabIndex = wfJavaParamsObj.tabIndex;
			
			function registerClickEventForOffical(ifrm,_document){
				if(ifrm){
					_document = ifrm.contentWindow.document;
				}
				if(!_document)_document = document;
				jQuery("#wfBaseInfoTab").unbind("click").bind("click",function(){
					jQuery(".wfOfficalDoc",_document).hide();
					jQuery("#wfBaseInfo",_document).show();
					__tabIndex = 1;
					jQuery("#tabIndex").val(__tabIndex);
					selectCurrent(this);
					return false;
				});

				jQuery(".weihu").unbind("click").bind("click",function(){
					jQuery("#wfBaseInfoTab").click();
				});
				
				jQuery("#wfTaoHongTab").unbind("click").bind("click",function(){
					if(jQuery("#pathCategoryDocument").val()!=""){
					jQuery(".wfOfficalDoc",_document).hide();
					jQuery("#wfTaoHong",_document).show();
					__tabIndex = 2;
					jQuery("#tabIndex").val(__tabIndex);
                        selectCurrent(this);
					}else{
                        window.top.Dialog.alert(wfJavaParamsObj.msg_19373);
					}
					return false;
				});
				
				jQuery("#wfEditMouldTab").unbind("click").bind("click",function(){
					if(jQuery("#pathCategoryDocument").val()!=""){
					jQuery(".wfOfficalDoc",_document).hide();
					jQuery("#wfEditMould",_document).show();
					__tabIndex = 3;
					jQuery("#tabIndex").val(__tabIndex);
                        selectCurrent(this);
					}else{
                        window.top.Dialog.alert(wfJavaParamsObj.msg_19373);
					}
					return false;
				});
				
				jQuery("#wfDocPropTab").unbind("click").bind("click",function(){
					if(jQuery("#pathCategoryDocument").val()!=""){
					jQuery(".wfOfficalDoc",_document).hide();
					jQuery("#wfDocProp",_document).show();
					__tabIndex = 4;
					jQuery("#tabIndex").val(__tabIndex);
					selectCurrent(this);
					}else{
					window.top.Dialog.alert(wfJavaParamsObj.msg_19373);
					}
					return false;
				});
				
				jQuery("#wfSignatureTab").unbind("click").bind("click",function(){
					jQuery(".wfOfficalDoc",_document).hide();
					jQuery("#wfSignature",_document).show();
					__tabIndex = 5;
					jQuery("#tabIndex").val(__tabIndex);
					selectCurrent(this);
					return false;
				});
				
				jQuery("#wfPrintTab").unbind("click").bind("click",function(){
					jQuery(".wfOfficalDoc",_document).hide();
					jQuery("#wfPrint",_document).show();
					__tabIndex = 6;
					jQuery("#tabIndex").val(__tabIndex);
					selectCurrent(this);
					return false;
				});
				
				jQuery("#wfTraceTab").unbind("click").bind("click",function(){
					jQuery(".wfOfficalDoc",_document).hide();
					jQuery("#wfTrace",_document).show();
					__tabIndex = 7;
					jQuery("#tabIndex").val(__tabIndex);
					selectCurrent(this);
					return false;
				});
				
				jQuery("#wfActionTab").unbind("click").bind("click",function(){
					jQuery(".wfOfficalDoc",_document).hide();
					jQuery("#wfAction",_document).show();
					__tabIndex = 8;
					jQuery("#tabIndex").val(__tabIndex);
					selectCurrent(this);
					return false;
				});

				jQuery("#wfPDFTab").unbind("click").bind("click",function(){
					jQuery(".wfOfficalDoc",_document).hide();
					jQuery("#wfPDF",_document).show();
					__tabIndex = 9;
					jQuery("#tabIndex").val(__tabIndex);
					selectCurrent(this);
					return false;
				});

				jQuery("#wfTracePropTab").unbind("click").bind("click",function(){
					jQuery(".wfOfficalDoc",_document).hide();
					jQuery("#wfTraceProp",_document).show();
					__tabIndex = 10;
					jQuery("#tabIndex").val(__tabIndex);
					selectCurrent(this);
					return false;
				});
				
			}
            
            jQuery(function(){
				jQuery('.e8_box').Tabs({
			    	getLine:1,
			    	image:false,
			    	needLine:false,
			    	needTopTitle:false,
			    	needInitBoxHeight:false
			    });
			    registerClickEventForOffical();
				jQuery(".wfcontent").show();
                
                jQuery(".e8tips").wTooltip({html:true});
                if(jQuery("#documentLocation").val()!=-1){
                    loadMould(jQuery("#documentLocation").val(),true);
                }
                
                if(jQuery("#documentEditLocation").val()!=-1){
                    loadEditMould(jQuery("#documentLocation").val(),true);
                }
                
                if(jQuery("#documentPropLocation").val()!=-1){
                    loadProp(jQuery("#documentLocation").val(),true);
                }
                initDefaultDocProp(true);
			});
            
		</script>
    </HEAD>
<BODY>
<%if(!isDialog.equals("0")){ %>
<div class="zDialog_div_content">
<%} %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type=button class="e8_btn_top" onclick="saveCreateDocument(this)" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"></input>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
    RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:saveCreateDocument(this),_self}";
    RCMenuHeight += RCMenuHeightStep;
    RCMenu += "{"+SystemEnv.getHtmlLabelName(83,user.getLanguage())+",javascript:onLog(),_top} " ;
    RCMenuHeight += RCMenuHeightStep ;
%>

<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM name="createDocumentByWorkFlow" method="post" action="CreateDocumentByWorkFlowOperation.jsp" >
	<iframe id="chooseDisplayAttributeForm" frameborder=0 scrolling=no src="javascript:false"  style="display:none"></iframe>
    <wea:layout needImportDefaultJsAndCss="false">
        <wea:group context='<%=SystemEnv.getHtmlLabelNames("19331,68",user.getLanguage())%>'>
            <wea:item><%=SystemEnv.getHtmlLabelNames("19331",user.getLanguage())%></wea:item>
            <wea:item>
                <input onclick="openOrClose(this);" class=inputstyle tzCheckbox="true" type="checkbox" name="show" value="0" <% if(!canBeSet) { %> disabled <% } if("1".equals(status)) {%> checked <% } %> >
            </wea:item>
        </wea:group>
    </wea:layout>
    <div class="wfcontent" style="position:relative;<%=status.equals("1")?"":"display:none;" %>">
        <div class=" demo2" id="seccategorybox" style="width:auto;border-bottom:1px solid rgb(127,180,233);padding-left:26px;height:33px!important;position:relative!important;">
            <ul class="tab_menu" style="width:825px!important;">
              <li class="<%=tabIndex==1?"current":"" %>">
                <a href="#" id="wfBaseInfoTab" onclick="return false;">
                    <%=SystemEnv.getHtmlLabelName(16484,user.getLanguage())%>
                </a>
            </li>
            <li class="<%=tabIndex==2?"current":"" %>">
                <a href="#" id="wfTaoHongTab" onclick="return false;">
                    <%=SystemEnv.getHtmlLabelName(33316,user.getLanguage())%>
                </a>
            </li>
            <li class="<%=tabIndex==3?"current":"" %>">
                <a href="#" id="wfEditMouldTab" onclick="return false;">
                    <%=SystemEnv.getHtmlLabelNames("16449,30747",user.getLanguage())%>
                </a>
            </li>
            <li class="<%=tabIndex==4?"current":"" %>">
                <a href="#" id="wfDocPropTab" onclick="return false;">
                    <%=SystemEnv.getHtmlLabelNames("33197,30747",user.getLanguage())%>
                </a>
            </li>
            <li class="<%=tabIndex==5?"current":"" %>">
                <a href="#" id="wfSignatureTab" onclick="return false;">
                    <%=SystemEnv.getHtmlLabelName(16473,user.getLanguage())%>
                </a>
            </li>
            <li class="<%=tabIndex==6?"current":"" %>">
                <a href="#" id="wfPrintTab" onclick="return false;">
                    <%=SystemEnv.getHtmlLabelName(20756,user.getLanguage())%>
                </a>
            </li>
            <li class="<%=tabIndex==7?"current":"" %>">
                <a href="#" id="wfTraceTab" onclick="return false;">
                    <%=SystemEnv.getHtmlLabelName(33317,user.getLanguage())%>
                </a>
            </li>
            <li class="<%=tabIndex==8?"current":"" %>">
                <a href="#" id="wfActionTab" onclick="return false;">
                    <%=SystemEnv.getHtmlLabelName(33085,user.getLanguage())%>
                </a>
            </li>
             <li class="<%=tabIndex==9?"current":"" %>">
                <a href="#" id="wfPDFTab" onclick="return false;">
                    <%=SystemEnv.getHtmlLabelName(125964,user.getLanguage())%>
                </a>
            </li>
            <li class="<%=tabIndex==10?"current":"" %>">
                <a href="#" id="wfTracePropTab" onclick="return false;">
                    <%=SystemEnv.getHtmlLabelName(129067,user.getLanguage())%>
                </a>
            </li>
            </ul>
            <div id="rightBox" class="e8_rightBox">
            </div>
            <div class="tab_box" style="display:none;">
                <div>
                </div>
            </div>
        </div>
        
        <jsp:include page="/workflow/workflow/createDoc_wf_base.jsp">
           <jsp:param name="workflowId" value="<%=workflowId %>" />
           <jsp:param name="formId" value="<%=formID %>" />
           <jsp:param name="isBill" value="<%=isbill %>" />
           <jsp:param name="titleFieldId" value="<%=titleFieldId %>" />
           <jsp:param name="cleanCopyNodes" value="<%=cleanCopyNodes %>" />
           <jsp:param name="cleanCopyNodesName" value="<%=cleanCopyNodesName %>" />
           <jsp:param name="openTextDefaultNode" value="<%=openTextDefaultNode %>" />
           <jsp:param name="openTextDefaultNodes" value="<%=openTextDefaultNodes %>" />
           <jsp:param name="keywordFieldId" value="<%=keywordFieldId %>" />
           <jsp:param name="isTextInForm" value="<%=isTextInForm %>" />
           <jsp:param name="defaultDocType" value="<%=defaultDocType %>" />
           <jsp:param name="extfile2doc" value="<%=extfile2doc %>" />
           <jsp:param name="isWorkflowDraft" value="<%=isWorkflowDraft %>" />
           <jsp:param name="ifVersion" value="<%=ifVersion %>" />
           <jsp:param name="onlyCanAddWord" value="<%=onlyCanAddWord %>" />
           <jsp:param name="uploadPDF" value="<%=uploadPDF %>" />
           <jsp:param name="newTextNodes" value="<%=newTextNodes %>" />
           <jsp:param name="flowCodeField" value="<%=flowCodeField %>" />
           <jsp:param name="flowDocCatField" value="<%=flowDocCatField %>" />
           <jsp:param name="defaultView" value="<%=defaultView %>" />
           <jsp:param name="documentTitleField" value="<%=documentTitleField %>" />
           <jsp:param name="flowDocField" value="<%=flowDocField %>" />
           <jsp:param name="tabIndex" value="<%=tabIndex %>" />
        </jsp:include>
        <jsp:include page="/workflow/workflow/createDoc_wf_th.jsp">
            <jsp:param name="workflowId" value="<%=workflowId %>" />
            <jsp:param name="formId" value="<%=formID %>" />
            <jsp:param name="isBill" value="<%=isbill %>" />
            <jsp:param name="tabIndex" value="<%=tabIndex %>" />
            <jsp:param name="flowDocCatField" value="<%=flowDocCatField %>" />
            <jsp:param name="useTempletNode" value="<%=useTempletNode %>" />
            <jsp:param name="secCategory" value="<%=secCategory %>" />
            <jsp:param name="canBeSet" value="<%=canBeSet %>" />
        </jsp:include>
        <jsp:include page="/workflow/workflow/createDoc_wf_editMould.jsp">
            <jsp:param name="workflowId" value="<%=workflowId %>" />
            <jsp:param name="formId" value="<%=formID %>" />
            <jsp:param name="isBill" value="<%=isbill %>" />
            <jsp:param name="tabIndex" value="<%=tabIndex %>" />
            <jsp:param name="secCategory" value="<%=secCategory %>" />
            <jsp:param name="flowDocCatField" value="<%=flowDocCatField %>" />
        </jsp:include>
        <jsp:include page="/workflow/workflow/createDoc_wf_printNode.jsp">
            <jsp:param name="workflowId" value="<%=workflowId %>" />
            <jsp:param name="formId" value="<%=formID %>" />
            <jsp:param name="isBill" value="<%=isbill %>" />
            <jsp:param name="tabIndex" value="<%=tabIndex %>" />
            <jsp:param name="printNodes" value="<%=printNodes %>" />
        </jsp:include>
        <jsp:include page="/workflow/workflow/createDoc_wf_signatureNode.jsp">
            <jsp:param name="workflowId" value="<%=workflowId %>" />
            <jsp:param name="formId" value="<%=formID %>" />
            <jsp:param name="isBill" value="<%=isbill %>" />
            <jsp:param name="tabIndex" value="<%=tabIndex %>" />
            <jsp:param name="signatureNodes" value="<%=signatureNodes %>" />
        </jsp:include>
        <jsp:include page="/workflow/workflow/createDoc_wf_trace.jsp">
            <jsp:param name="workflowId" value="<%=workflowId %>" />
            <jsp:param name="formId" value="<%=formID %>" />
            <jsp:param name="isBill" value="<%=isbill %>" />
            <jsp:param name="tabIndex" value="<%=tabIndex %>" />
            <jsp:param name="isCompellentMark" value="<%=isCompellentMark %>" />
            <jsp:param name="isCancelCheck" value="<%=isCancelCheck %>" />
            <jsp:param name="isHideTheTraces" value="<%=isHideTheTraces %>" />
        </jsp:include>
            
        <input type=hidden id='workFlowID' name='workFlowID' value=<%=workflowId %> />
        <input type=hidden id='formID' name='formID' value=<%=formID %> />
        <input type=hidden id='isbill' name='isbill' value=<%=isbill %> />
        <input type=hidden id='isdialog' name='isdialog' value=<%=isDialog %> />     
        <input type=hidden id='tabIndex' name='tabIndex' value=<%=tabIndex %> />                                 
        <input type=hidden id='mainCategoryDocument' name='mainCategoryDocument' value="<%=mainCategory %>" />
        <input type=hidden id='subCategoryDocument' name='subCategoryDocument' value="<%=subCategory %>" />
        <input type=hidden id='secCategoryDocument' name='secCategoryDocument' value="<%=secCategory %>" />   
    </div>
</FORM>

<jsp:include page="/workflow/workflow/createDoc_wf_toPdf.jsp">
    <jsp:param name="workflowId" value="<%=workflowId %>" />
    <jsp:param name="formId" value="<%=formID %>" />
    <jsp:param name="isBill" value="<%=isbill %>" />
    <jsp:param name="tabIndex" value="<%=tabIndex %>" />
</jsp:include>

<div class="wfcontent" style="<%=status.equals("1")?"":"display:none;" %>">
    <jsp:include page="/workflow/workflow/createDoc_wf_action.jsp">
        <jsp:param name="workflowId" value="<%=workflowId %>" />
        <jsp:param name="formId" value="<%=formID %>" />
        <jsp:param name="isBill" value="<%=isbill %>" />
        <jsp:param name="tabIndex" value="<%=tabIndex %>" />
    </jsp:include>
    <jsp:include page="/workflow/workflow/createDoc_wf_docProp.jsp">
        <jsp:param name="workflowId" value="<%=workflowId %>" />
        <jsp:param name="formId" value="<%=formID %>" />
        <jsp:param name="isBill" value="<%=isbill %>" />
        <jsp:param name="tabIndex" value="<%=tabIndex %>" />
        <jsp:param name="secCategory" value="<%=secCategory %>" />
        <jsp:param name="flowDocCatField" value="<%=flowDocCatField %>" />
        <jsp:param name="useTempletNode" value="<%=useTempletNode %>" />
        <jsp:param name="isDialog" value="<%=isDialog %>" />
        <jsp:param name="defaultView" value="<%=defaultView %>" />
    </jsp:include>
    <jsp:include page="/workflow/workflow/createDoc_wf_traceContent.jsp">
        <jsp:param name="workflowId" value="<%=workflowId %>" />
        <jsp:param name="formId" value="<%=formID %>" />
        <jsp:param name="isBill" value="<%=isbill %>" />
        <jsp:param name="tabIndex" value="<%=tabIndex %>" />
        <jsp:param name="isDialog" value="<%=isDialog %>" />
    </jsp:include>
</div>
<%if(!isDialog.equals("0")){ %>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
				<wea:item type="toolbar">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand();">
				</wea:item>
			</wea:group>
		</wea:layout>
</div>
<script type="text/javascript">
    jQuery(document).ready(function(){
        try{
            var current = jQuery("li.current",parent.document);
            var id = current.children("a").attr("id").replace(/Tab/g,"");
            jQuery(".wfOfficalDoc").hide();
            jQuery("#"+id).show();
            var _document = document;
            parent.registerClickEventForOffical(null,_document);
        }catch(e){
            jQuery(".wfOfficalDoc").hide();
            jQuery("#baseInfo").show();
        }
        resizeDialog(document);
    });
</script>
<%} %>

</BODY>
</HTML>
