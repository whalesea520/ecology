<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.file.Prop" %>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
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
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>

<HTML>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(19331,user.getLanguage());
    String needfav = "";
    String needhelp = "";
    int workflowId = Util.getIntValue(request.getParameter("wfid"),-1);
	String formID = "";
    String isbill =  "";
	int docPropId_Trace=0;
	int tracesavesecid=0;

     // 设置是否使用二维条码
	 String isUse="0";
	 RecordSet.executeSql("select * from Workflow_BarCodeSet where workflowId="+workflowId);
	 if(RecordSet.next()){
        isUse = Util.null2String(RecordSet.getString("isUse"));
     }
%>
    <HEAD>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
        <script  src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
		<style type="text/css">
			select{
				/*width:300px!important;*/
			}
		</style>
		<script type="text/javascript">
			var dialog = null;
			var parentWin = null;
			try{
				dialog = parent.parent.getDialog(parent); 
				parentWin = parent.parent.getParentWindow(parent);
				parentWin._table.reLoad();
			}catch(e){}
			function onLog(){
				_onViewLog(220,<%=workflowId%>);
			}
		</script>
    </HEAD>
<BODY>
<div class="zDialog_div_content">

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

<%
	WfRightManager wfrm = new WfRightManager();
	boolean haspermission = wfrm.hasPermission3(workflowId, 0, user, WfRightManager.OPERATION_CREATEDIR);
    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
    int subCompanyID = -1;
    int operateLevel = 0;
    int docPropIdDefault = -1;
    
    String workflowname = WorkflowComInfo.getWorkflowname(""+workflowId);
    workflowname = Util.processBody(workflowname,user.getLanguage()+"");

    if(1 == detachable)
    {  

		RecordSet.executeSql("select subcompanyId from  Workflow_base where id="+workflowId);
		if(RecordSet.next()){
			subCompanyID = Util.getIntValue(RecordSet.getString("subcompanyId"),-1);
		}
		if(subCompanyID<=0){
			subCompanyID = user.getUserSubCompany1();
		}
        
        session.setAttribute("managefield_subCompanyId", String.valueOf(subCompanyID));
        
        operateLevel= checkSubCompanyRight.ChkComRightByUserRightCompanyId(user.getUID(), "WorkflowManage:All", subCompanyID);
    }
    else
    {
        if(HrmUserVarify.checkUserRight("WorkflowManage:All", user))
        {
            operateLevel=2;
        }
    }
    
    if(operateLevel<=0 && haspermission){
    	operateLevel = 2;
    }    

    if(operateLevel > 0)
    {
         formID = request.getParameter("formid");
         isbill = request.getParameter("isbill");

		if(formID==null||formID.trim().equals("")){
			formID=WorkflowComInfo.getFormId(""+workflowId);
		}
 		if(isbill==null||isbill.trim().equals("")){
			isbill=WorkflowComInfo.getIsBill(""+workflowId);
		}
		if(formID==null||formID.trim().equals("")||isbill==null||isbill.trim().equals("")){
			RecordSet.executeSql("select formid,isbill from workflow_base where id="+workflowId);
			if(RecordSet.next()){
				formID = Util.null2String(RecordSet.getString("formid"));
				isbill = Util.null2String(RecordSet.getString("isbill"));
			}
		}
		if(!"1".equals(isbill)){
			isbill="0";
		}

        String ifVersion = 	"0";
		int titleFieldId=0;
		int keywordFieldId=0;
		int officalType = 0;
        //RecordSet.executeSql("select ifVersion from workflow_base where id=" +workflowId);
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
		
		/*================单文档、多文档、附件上传字段=============*/
		String fieldSql = "";
		String fields = "<select name='fieldid' id='fieldid'>";
		String modes = "<select name='isnode' id='isnode' onchange='clearLinkOrNode(this)'>"+
			"<option value=1>"+SystemEnv.getHtmlLabelName(18010,user.getLanguage())+"</option>"+
			"<option value=0>"+SystemEnv.getHtmlLabelNames("15587,15610",user.getLanguage())+"</option>";
		String actions = "<select name='customervalue' id='customervalue'>"+
			"<option value=0>"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(220,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>"+
			"<option value=2>"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(19563,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>"+
			"<option value=3>"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(359,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>"+
			"<option value=5>"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(251,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>"+
			"<option value=6>"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(19564,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>"+
			"<option value=7>"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(15750,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>"+
			"<option value=8>"+SystemEnv.getHtmlLabelName(19561,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(15358,user.getLanguage())+"&quot;"+SystemEnv.getHtmlLabelName(602,user.getLanguage())+"</option>";
		
		String rejectTriggers = "<span id='rejectTriggerSpan'><input type='checkbox' name='isTriggerReject' id='isTriggerReject' checked value='1'/></span>";
		String linkOrNodes = "<span id='descript'></span><span name='objid' class='browser' completeUrl='javascript:getCompleteUrl(objid_#rowIndex#)' browserUrl='#' getBrowserUrlFn='getBrowserUrlFn' getBrowserUrlFnParams='#objid_#rowIndex#' isSingle=true linkUrl='#' hasInput=true viewType=0 isMustInput=2></span>";
		if("1".equals(isbill)){
			fieldSql = "select distinct t.id,t2.labelname from workflow_billfield t, HtmlLabelInfo t2 where billid = "+formID+" and ((type in (9,37) and fieldhtmltype=3) or fieldhtmltype=6) and t.fieldlabel = t2.indexid and t2.languageid="+user.getLanguage();
		}else{
			fieldSql = "select fieldid,fieldlable from workflow_fieldlable t where formid= "+formID+" and langurageid="+user.getLanguage()+" and fieldid in (select id from workflow_formdict where ((type in (9,37) and fieldhtmltype=3) or fieldhtmltype=6))";
		}
		
		RecordSet.executeSql(fieldSql);
		
		if(RecordSet.next()){
			RecordSet.beforFirst();
		}else{
			if("1".equals(isbill)){
				fieldSql = "select distinct t.id,t2.labelname from workflow_billfield t, HtmlLabelInfo t2 where billid = "+formID+" and ((type in (9,37) and fieldhtmltype=3) or fieldhtmltype=6) and t.fieldlabel = t2.indexid and t2.languageid=7";
			}else{
				fieldSql = "select fieldid,fieldlable from workflow_fieldlable t where formid= "+formID+" and languageid=7 and fieldid in (select id from workflow_formdict where ((type in (9,37) and fieldhtmltype=3) or fieldhtmltype=6))";
			}
		}
		while(RecordSet.next()){
			fields += "<option value="+RecordSet.getString(1)+">"+RecordSet.getString(2)+"</option>";
		}
		
		fields += "</select>";

        /*================ 编辑信息 ================*/
        String status = "0";
        int flowCodeField = -1;
        int flowDocField = -1;
		int documentTitleField = -1;
        int flowDocCatField = -1;
		int useTempletNode = -1;
		String printNodes = "";
		String printNodesName="";
		String newTextNodes = "";

        //只能选择WORD文档
        String onlyCanAddWord = "";
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
        
        RecordSet.executeSql("SELECT * FROM workflow_createdoc WHERE workFlowID = " + request.getParameter("wfid"));

        if(RecordSet.next())
        {
			openTextDefaultNode = RecordSet.getString("openTextDefaultNode");

            status = RecordSet.getString("wfstatus");
            
            flowCodeField = RecordSet.getInt("flowCodeField");
            
            flowDocField = RecordSet.getInt("flowDocField");

            documentTitleField = RecordSet.getInt("documentTitleField");
            
            flowDocCatField = RecordSet.getInt("flowDocCatField");

			useTempletNode = RecordSet.getInt("useTempletNode");
            
            printNodes = Util.null2String(RecordSet.getString("printNodes"));

            newTextNodes = Util.null2String(RecordSet.getString("newTextNodes"));
            
            //只能选择WORD文档
            onlyCanAddWord = Util.null2String(RecordSet.getString("onlyCanAddWord"));

			signatureNodes = Util.null2String(RecordSet.getString("signatureNodes"));

			isWorkflowDraft = Util.null2String(RecordSet.getString("isWorkflowDraft"));

			defaultDocType = Util.null2String(RecordSet.getString("defaultDocType"));

			isHideTheTraces = Util.null2String(RecordSet.getString("isHideTheTraces"));

            defaultView = RecordSet.getString("defaultView");

			isCompellentMark = Util.null2String(RecordSet.getString("iscompellentmark"));

			isCancelCheck = Util.null2String(RecordSet.getString("iscancelcheck"));

            if("-1||-1||-1".equals(defaultView))
            {
                defaultView = "";
            }
            else
            {	try{
	            	List defaultViewList = null;
	            	if(defaultView.indexOf("||")!=-1){
	            		defaultViewList = Util.TokenizerString(defaultView, "||");
	            	}else{
	            		defaultViewList = Util.TokenizerString(defaultView, ",");
	            	}
	            	mainCategory = (String)defaultViewList.get(0);
		            subCategory = (String)defaultViewList.get(1);
		            secCategory = (String)defaultViewList.get(2);
	                //defaultView = mainCategoryComInfo.getMainCategoryname(mainCategory) + "/" + subCategoryComInfo.getSubCategoryname(subCategory) + "/" + secCategoryComInfo.getSecCategoryname(secCategory);
	                defaultView = secCategoryComInfo.getAllParentName(secCategory,true);
            	}catch(Exception e){
            		defaultView = secCategoryComInfo.getAllParentName(defaultView,true);
            	}
            }
            extfile2doc = Util.getIntValue(RecordSet.getString("extfile2doc"), 0);
			cleanCopyNodes = Util.null2String(RecordSet.getString("cleanCopyNodes"));
			isTextInForm = Util.null2String(RecordSet.getString("isTextInForm"));			
        }

		// 默认打开正文的节点
		String openTextDefaultNodes = "";
		if(!"".equals(openTextDefaultNode)) {
			String[] ids = openTextDefaultNode.split(",");
			for(String id : ids) {
				RecordSet.executeSql("SELECT id,nodename FROM  workflow_nodebase where id = " + id);
				if(RecordSet.next()) {
					openTextDefaultNodes += Util.null2String(RecordSet.getString("nodename"))+",";
				}
			}
			if(openTextDefaultNodes.endsWith(",")) {
				openTextDefaultNodes = openTextDefaultNodes.substring(0,openTextDefaultNodes.length()-1);
			}
		}

        //打印节点

		if(!printNodes.equals("")){
			StringBuffer printNodesNameSb=new StringBuffer();
			printNodesNameSb.append(" select b.nodeName ")
				            .append(" from  workflow_flownode a,workflow_nodebase b ")
				            .append(" where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id ")
				            .append("   and a.workflowId=").append(workflowId)
				            .append("   and b.id in(").append(printNodes).append(") ")
				            .append(" order by a.nodeType asc,a.nodeId asc ")				
			;
			RecordSet.executeSql(printNodesNameSb.toString());
			while(RecordSet.next()){
				printNodesName+="，"+Util.null2String(RecordSet.getString("nodeName"));
			}
			if(!printNodesName.equals("")){
				printNodesName=printNodesName.substring(1);
			}
		}

        /**签章节点**/
		if(!signatureNodes.equals("")){
			StringBuffer signatureNodesNameSb=new StringBuffer();
			signatureNodesNameSb.append(" select b.nodeName ")
				            .append(" from  workflow_flownode a,workflow_nodebase b ")
				            .append(" where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id ")
				            .append("   and a.workflowId=").append(workflowId)
				            .append("   and b.id in(").append(signatureNodes).append(") ")
				            .append(" order by a.nodeType asc,a.nodeId asc ")				
			;
			RecordSet.executeSql(signatureNodesNameSb.toString());
			while(RecordSet.next()){
				signatureNodesName+="，"+Util.null2String(RecordSet.getString("nodeName"));
			}
			if(!signatureNodesName.equals("")){
				signatureNodesName=signatureNodesName.substring(1);
			}
		}

		/**清稿节点**/
		if(!cleanCopyNodes.equals("")){		
			String[] ids = cleanCopyNodes.split(",");
			for(String id : ids) {
				RecordSet.executeSql("SELECT id,nodename FROM  workflow_nodebase where id = " + id);
				if(RecordSet.next()) {
					cleanCopyNodesName += Util.null2String(RecordSet.getString("nodename"))+",";
				}
			}
			if(cleanCopyNodesName.endsWith(",")) {
				cleanCopyNodesName = cleanCopyNodesName.substring(0,cleanCopyNodesName.length()-1);
			}
		}
		
        Map docPropIdMap=new HashMap();
		String tempSelectItemId=null;
		String tempDocPropId=null;
		RecordSet.executeSql("SELECT id,selectItemId FROM Workflow_DocProp where workflowId="+workflowId+" and objId=-1");
		while(RecordSet.next()){
			tempSelectItemId=Util.null2String(RecordSet.getString("selectItemId"));
			tempDocPropId=Util.null2String(RecordSet.getString("id"));
			if(!(tempSelectItemId.trim().equals(""))){
				docPropIdMap.put(tempSelectItemId,tempDocPropId);
			}
		}
		docPropIdDefault=Util.getIntValue((String)docPropIdMap.get("-1"),-1);
                
        /*================ 显示字段查询基SQL ================*/
		String SQL = null;

		if("1".equals(isbill)){
			SQL = "select formField.id,fieldLable.labelName as fieldLable "
                    + "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
                    + "where fieldLable.indexId=formField.fieldLabel "
                    + "  and formField.billId= " + formID
                    + "  and formField.viewType=0 "
                    + "  and fieldLable.languageid =" + user.getLanguage();
		}else{
			SQL = "select formDict.ID, fieldLable.fieldLable "
                    + "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
                    + "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
                    + "and formField.formid = " + formID
                    + " and fieldLable.langurageid = " + user.getLanguage();
		}
                    
        int formDictID = -1;
		int tempNodeId = -1;

      String SQLWorkFlowCoding = null;
      if("1".equals(isbill)){
      	SQLWorkFlowCoding = SQL + " and formField.fieldHtmlType = '1' and formField.type = 1 order by formField.dspOrder";
      }else{
          SQLWorkFlowCoding = SQL + " and formDict.fieldHtmlType = '1' and formDict.type = 1 order by formField.fieldorder";
      }

	String isUseDefaultDocType = Util.null2String(BaseBean.getPropValue("weaver_defaultdoctype","ISUSEDEFAULTDOCTYPE"));
	String isUseBarCode = Util.null2String(BaseBean.getPropValue("weaver_barcode","ISUSEBARCODE"));	
	int flag = -1;  //防止数据库目录被删除,配置信息存在	
	String  completeUrlPrint = "/data.jsp?type=workflowNodeBrowser&wfid="+workflowId;
	String attributes = "{'groupOperDisplay':'none','samePair':'abbrtable','groupDisplay':'','itemAreaDisplay':''}"; 
	if(!"1".equals(status)){
		attributes = "{'groupOperDisplay':'none','samePair':'abbrtable','groupDisplay':'none','itemAreaDisplay':'none'}"; 
	}
%>
<FORM name="createDocumentByWorkFlow" method="post" action="CreateDocumentByWorkFlowOperation.jsp" >
<input type="hidden" name="setwfstatusfrom" id="setwfstatusfrom" value="1"/>
<INPUT type=hidden id='tabIndex' name='tabIndex' value="">     
	<iframe id="chooseDisplayAttributeForm" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<div id="wfBaseInfo" class="wfOfficalDoc" style="display:none;">
<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())+SystemEnv.getHtmlLabelName(68,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(18104,user.getLanguage())%></wea:item>
		<wea:item><%=workflowname%></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(25005,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=inputstyle tzCheckbox="true" type="checkbox" name="show" value="0" <% if(!canBeSet) { %> disabled <% } if("1".equals(status)) {%> checked <% } %> >
			<span class="e8tips" title="<%=SystemEnv.getHtmlLabelNames("32164,23167",user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33318,user.getLanguage())%></wea:item>
		<wea:item>
			<select class=inputstyle name="createDocument">
			<option value=-1></option>
			<%
			    String SQLCreateDocument = null;
			    if("1".equals(isbill)){
					SQLCreateDocument = SQL + " and formField.fieldHtmlType = '3' and formField.type = 9 order by formField.dspOrder";
				}else{
					SQLCreateDocument = SQL + " and formDict.fieldHtmlType = '3' and formDict.type = 9 order by formField.fieldorder";
				}
			
                RecordSet.executeSql(SQLCreateDocument);
                
                while(RecordSet.next()){
                    formDictID = RecordSet.getInt("ID");
			%>
			<option value=<%= formDictID %> <% if(formDictID == flowDocField) { %> selected <% } %> ><%= RecordSet.getString("fieldLable") %></option>
			<% }%>
			</select>
			<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21100,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>		
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(23038,user.getLanguage())%></wea:item>
		<wea:item>
	        <select class=inputstyle name="documentTitleField">
	            <option value=-1></option>
	            <option value=-3 <% if(documentTitleField == -3) { %> selected <% } %>><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></option>
	        <%                                                
	            RecordSet.executeSql(SQLWorkFlowCoding);
	            	            
	            while(RecordSet.next()){
	                formDictID = RecordSet.getInt("ID");
	        %>
	            <option value=<%= formDictID %> <% if(formDictID == documentTitleField) { %> selected <% } %> ><%= RecordSet.getString("fieldLable") %></option>
	        <%}%>
	        </select>
	        <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21101,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33319,user.getLanguage())%></wea:item>
		<wea:item>
			<% 
             	String pathCategoryDocumentURL = "/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp";
            %>
             <brow:browser name="pathCategoryDocument" viewType="0" hasBrowser="true" hasAdd="false" idKey="id" nameKey="path"
						browserUrl='<%=pathCategoryDocumentURL %>' isMustInput="2" isSingle="true" hasInput="true"
						temptitle='<%= SystemEnv.getHtmlLabelName(33319,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
						completeUrl="/data.jsp?type=categoryBrowser" _callback="onShowCatalogData" width="300px" browserValue='<%=defaultView%>' browserSpanValue='<%=defaultView%>' />
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelNames("690,19214", user.getLanguage())%></wea:item>
			<wea:item>
				<select class=inputstyle name="documentLocation" id="documentLocation" >
				    <option value=-1></option>
					<%
					String SQLDocumentLocation = null;
					if("1".equals(isbill)){
						SQLDocumentLocation = SQL + " and formField.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and isAccordToSubCom='0' and formField.ID = workflow_selectitem.fieldid and isBill='1' )order by formField.dspOrder";
					}else{
						SQLDocumentLocation = SQL + " and formDict.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and isAccordToSubCom='0' and formDict.ID = workflow_selectitem.fieldid and isBill='0') order by formField.fieldorder";
					}
	                               
	                RecordSet.executeSql(SQLDocumentLocation);  
	                while(RecordSet.next())
	                {
	                    formDictID = RecordSet.getInt("ID");
					%>
					 <option value=<%= formDictID %> <% if(formDictID == flowDocCatField) { flag = flowDocCatField; %> selected <% } %> ><%= RecordSet.getString("fieldLable") %></option>
					<%}%>
				</select>
				<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21102,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
			</wea:item>
	</wea:group>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(20824,user.getLanguage())%>'>	
		<wea:item><%=SystemEnv.getHtmlLabelName(33382,user.getLanguage())%></wea:item>
		<wea:item>
	        <select class=inputstyle name="workFlowCoding">
	            <option value=-1></option>
	        <%          
	            RecordSet.executeSql(SQLWorkFlowCoding);
	            
	            while(RecordSet.next()){
	                formDictID = RecordSet.getInt("ID");
	        %>
	            <option value=<%= formDictID %> <% if(formDictID == flowCodeField) { %> selected <% } %> ><%= RecordSet.getString("fieldLable") %></option>
	        <% } %>
	        </select>
	        <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21099,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33320,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=inputstyle tzCheckbox="true" type="checkbox" name="newTextNodes" value="1" <% if("1".equals(newTextNodes)){ %> checked <%} %>/>
            <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21635,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
		</wea:item>
		
        <wea:item><%=SystemEnv.getHtmlLabelName(131221,user.getLanguage())%></wea:item>
        <wea:item>
            <input class=inputstyle tzCheckbox="true" type="checkbox" name="onlyCanAddWord" value="1" <% if("1".equals(onlyCanAddWord)){ %> checked <%} %>/>
            <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(131222,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
        </wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33321,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=inputstyle tzCheckbox="true" type="checkbox" name="ifVersion"  value="1" <%if("1".equals(ifVersion)){%>checked<%}%> />
			<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21722,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33322,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=inputstyle tzCheckbox="true" type="checkbox" name="isWorkflowDraft"  value="1" <%if("1".equals(isWorkflowDraft)){%>checked<%}%> />
			<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21732,user.getLanguage())+"&nbsp;&nbsp;&nbsp;&nbsp;<font color='red'>"+SystemEnv.getHtmlLabelName(21733,user.getLanguage())+"</font>" %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(33324,user.getLanguage())%></wea:item>
		<wea:item>
			<input class="inputstyle" tzCheckbox="true" type="checkbox" id="extfile2doc" name="extfile2doc"  value="1" <%if(extfile2doc==1){%>checked<%}%> />
			<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(24009,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
		</wea:item>
		<%if(isUseDefaultDocType.equals("1")){%>
		<wea:item><%=SystemEnv.getHtmlLabelName(22358,user.getLanguage())%></wea:item>
		<wea:item>
	        <select class=inputstyle name="defaultDocType">
	            <option value=1 <% if(defaultDocType.equals("1")){%> selected <%}%> >Office Word</option>
	            <option value=2 <% if(defaultDocType.equals("2")){%> selected <% }%> ><%=SystemEnv.getHtmlLabelName(22359,user.getLanguage())%></option>
	        </select>		
		</wea:item>
		<%} %>	
		<wea:item><%=SystemEnv.getHtmlLabelName(382048,user.getLanguage())%></wea:item>
		<wea:item>
			<input class=inputstyle tzCheckbox="true" type="checkbox" name="isTextInForm"  value="1" <%if("1".equals(isTextInForm)){%>checked<%}%> />
			<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(382013,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(21516,user.getLanguage())%></wea:item>
		<wea:item>
			<select name="keywordFieldId" onchange="toggleTitleFieldId(this);">
				<option value=-1></option>
				<%
				    RecordSet.executeSql(SQLWorkFlowCoding);
				    while(RecordSet.next()){
					formDictID = RecordSet.getInt("ID");
				%>
				<option value=<%= formDictID %> <% if(formDictID == keywordFieldId) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
				<%}%>
			</select>
		</wea:item>	
		<%String attrs = "{'samePair':'titleFieldId','display':'"+((keywordFieldId==0||keywordFieldId<0)?"none":"")+"'}"; %>			
		<wea:item attributes='<%=attrs %>'><%=SystemEnv.getHtmlLabelName(19501,user.getLanguage())%></wea:item>
		<wea:item attributes='<%=attrs %>'>
			<select name="titleFieldId">
        		<option value=-1></option>
        		<option value=-3  <%if (titleFieldId==-3) {%>selected<%}%>><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></option>
		<%
		     RecordSet.executeSql(SQLWorkFlowCoding);
		     while(RecordSet.next()){
			 formDictID = RecordSet.getInt("ID");
		%>
        		<option value=<%= formDictID %> <% if(formDictID == titleFieldId) { %> selected <% } %> ><%= Util.null2String(RecordSet.getString("fieldLable")) %></option>
		<%}%>
    		</select>
		</wea:item>

		<!-- 默认打开正文的节点 -->	
		<wea:item><%=SystemEnv.getHtmlLabelName(128306,user.getLanguage())%></wea:item>
		<wea:item>
			<% 
				String setDefaultTabUrl="/data.jsp?type=fieldBrowser&wfid="+workflowId; 
				String chooseNodesUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/flowNodes.jsp?option=2&workflowId="+workflowId+"&oldNodeIds="+openTextDefaultNode;
			%>
			<brow:browser name="openTextDefaultNode" viewType="0" hasBrowser="true" hasAdd="false" 
				browserUrl='<%=chooseNodesUrl %>' isMustInput="1" isSingle="false" hasInput="true"
				completeUrl='<%=setDefaultTabUrl %>' isAutoComplete="false" width="300px" browserValue='<%=openTextDefaultNode%>' 
				browserSpanValue='<%=openTextDefaultNodes%>' nameSplitFlag="," />
		</wea:item>

		<!-- 清稿节点-->
		<wea:item><%=SystemEnv.getHtmlLabelName(129588,user.getLanguage())%></wea:item>
		<wea:item>
			<% 
				String setDefaultTabUrl="/data.jsp?type=fieldBrowser&wfid="+workflowId; 
				String chooseNodesUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/flowNodes.jsp?option=2&workflowId="+workflowId+"&oldNodeIds="+cleanCopyNodes+"&tilteName=129588";
			%>
			<brow:browser name="cleanCopyNodes" viewType="0" hasBrowser="true" hasAdd="false" 
				browserUrl='<%=chooseNodesUrl %>' isMustInput="1" isSingle="false" hasInput="true"
				completeUrl='<%=setDefaultTabUrl %>' isAutoComplete="false" width="300px" browserValue='<%=cleanCopyNodes%>' 
				browserSpanValue='<%=cleanCopyNodesName%>' nameSplitFlag="," />	
            <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(129892,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>					
		</wea:item>	

	</wea:group>
</wea:layout>
</div>
<div id="wfTaoHong" style="display:none;" class="wfOfficalDoc">
<input type="hidden" name="from" id="from" value="attachMould"/>

<script type="text/javascript">

//jQuery(document).ready(function(){
//	jQuery("#isUse").change(function(){
//		if(jQuery(this).attr("checked")) {
			//RecordSet.executeSql("UPDATE Workflow_BarCodeSet SET isUse = '1' WHERE workflowId ="+workflowId);			
//		} else {
			//RecordSet.executeSql("UPDATE Workflow_BarCodeSet SET isUse = '0' WHERE workflowId ="+workflowId);
//		}
//	});
//});

// 设置 【二维码设置】按钮  显示或隐藏
function openqr() {
	if(jQuery("#isUse").attr("checked")) {
		jQuery("#setqrCode").show();
	} else {
		jQuery("#setqrCode").hide();
	}
}

// 弹出 二维条码设置 页面
function setqrCode(){
	if(window.top.Dialog){
		diag_vote = new window.top.Dialog();
	} else {
		diag_vote = new Dialog();
	}
	diag_vote.currentWindow = window;
	diag_vote.Width = 850;
	diag_vote.Height = 750;
	diag_vote.Modal = true;
	diag_vote.maxiumnable = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(21449,user.getLanguage())%>";
	diag_vote.URL = "/workflow/workflow/WFSetqrCode.jsp?workflowId=<%=workflowId%>&formId=<%= formID %>&isBill=<%= isbill %>";
	diag_vote.show();
}

</script>


<% if(canBeSet){ //单据不允许配置     %>	
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(20229,user.getLanguage())%></wea:item>
			<wea:item>
		        <select class=inputstyle id="useTempletNode" name="useTempletNode" onchange="toggleGroup(this);">
		            <option value=-1></option>
		        <%
		            String sqlUseTempletNode =  " select b.id as nodeId,b.nodeName from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodetype!=3 and a.nodeId=b.id and  a.workFlowId= "+workflowId+"  order by a.nodeType,a.nodeId";	            
		            RecordSet.executeSql(sqlUseTempletNode);	            
		            while(RecordSet.next()){
		                tempNodeId = RecordSet.getInt("nodeId");
		        %>
		            <option value=<%= tempNodeId %> <% if(tempNodeId == useTempletNode) { %> selected <% } %> ><%= RecordSet.getString("nodeName") %></option>
		        <% } %>
		        </select>		
			</wea:item>
<% if(1 == Util.getIntValue(Prop.getPropValue("weaver_barcode", "ISUSEBARCODE"),0)) { %>
			<!-- 20160629 huangj 二维条码设置 -->
			<wea:item><%=SystemEnv.getHtmlLabelName(127769,user.getLanguage())%></wea:item> 
			<wea:item>
				<input type="checkbox" name="isUse" id="isUse" tzCheckbox="true" onclick="openqr()" value="1" <% if("1".equals(isUse)) {%> checked <%}%>>
				&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
				<span id="setqrCode" <% if(!"1".equals(isUse)) {%>style="display: none" <%} %>>
					<a href="#" onclick="setqrCode()" style="color:blue;TEXT-DECORATION:none">
						<%=SystemEnv.getHtmlLabelName(21449,user.getLanguage())%>
					</a>
				</span> 
			</wea:item>
<% } %>
		</wea:group>
		<%String groupAttrs = "{'groupDisplay':'"+(useTempletNode<=0?"none":"")+"','itemAreaDisplay':'"+(useTempletNode<=0?"none":"")+"','samePair':'defaultMouldSetting'}"; %>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33325,user.getLanguage())%>' attributes="<%=groupAttrs %>">
			<wea:item type="groupHead">
				<input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="attachRelative('defaultMouldList');"/>
				<input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="detachRelative('defaultMouldList');"/>
			</wea:item>
			<wea:item attributes="{'isTableList':'true'}">
				<% 
					String sql = "select 1 from workflow_mould where mouldType=0 and workflowid = "+workflowId;
					RecordSet.executeSql(sql);
					if(!RecordSet.next()){
						//将该子目录关联的文档插入到中间表中

						RecordSet.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMould docMould WHERE docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(3,7) AND docSecCategoryMould.mouldBind = 2 AND docSecCategoryMould.secCategoryID = " + secCategory);
						if(RecordSet.next()){
							RecordSet.beforFirst();
							while(RecordSet.next()){
								RecordSet.executeSql("insert into workflow_mould(workflowid,mouldId,mouldType,visible,seccategory) values("+workflowId+","+RecordSet.getString("ID")+",0,1,"+secCategory+")");
							}
						}else{
							RecordSet.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMould docMould WHERE docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(3,7) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + secCategory);
							while(RecordSet.next()){
								RecordSet.executeSql("insert into workflow_mould(workflowid,mouldId,mouldType,visible,seccategory) values("+workflowId+","+RecordSet.getString("ID")+",0,1,"+secCategory+")");
							}
						}
					}
					sql = "SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMould docMould WHERE docMould.ID in (select mouldid from workflow_mould where visible=1 and mouldType=0 and workflowid = "+workflowId+") and docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(3,7) AND docSecCategoryMould.mouldBind = 2 AND docSecCategoryMould.secCategoryID = " + secCategory;
					RecordSet.executeSql(sql);
					String ajaxDatas = "";
					if(RecordSet.next()){
						RecordSet.beforFirst();
					}else{
						RecordSet.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMould docMould WHERE docMould.ID in (select mouldid from workflow_mould where visible=1 and seccategory="+secCategory+" and mouldType=0 and workflowid = "+workflowId+") and docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(3,7) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + secCategory);
					}
					WeaverEditTableUtil.setWorkflowid(workflowId+"");
					ajaxDatas = WeaverEditTableUtil.getInitDatas("viewMould",user,RecordSet);
				%>
				<div id="defaultMouldList"></div>
				<script type="text/javascript">
						var group = null;
						jQuery(document).ready(function(){
                            <% if("1".equals(newTextNodes)) {%>jQuery("input[name='onlyCanAddWord']").parent().parent().hide();<%} %>
                            jQuery("input[name='newTextNodes']").click(function(){
                                if(jQuery("input[name='newTextNodes']")[0].checked){
                                    jQuery("input[name='onlyCanAddWord']").parent().parent().hide();
                                }else{
                                    jQuery("input[name='onlyCanAddWord']").parent().parent().show();
                                }
                            });
							var ajaxDatas = <%=ajaxDatas%>
							var items=[
								{width:"30%",colname:"<%=SystemEnv.getHtmlLabelNames("25126",user.getLanguage())%>",itemhtml:"<span type='span' name='defaultMould'></span>"},
								{width:"55%",colname:"<%=SystemEnv.getHtmlLabelNames("33338",user.getLanguage())%>",itemhtml:"<span type='span' name='operate'></span>"},
								{width:"15%",colname:"<%=SystemEnv.getHtmlLabelNames("149",user.getLanguage())%>",itemhtml:"<input type='radio' name='setDef' _normalraido='true' onclick='setDef()' />"}
								];
							var option = {
							    openindex:false,															
								basictitle:"",
								optionHeadDisplay:"none",
								colItems:items,
								container:"#defaultMouldList",
								toolbarshow:false,
								configCheckBox:true,
								usesimpledata:true,
								initdatas:ajaxDatas,
								addrowCallBack:setDef,
             					checkBoxItem:{"itemhtml":'<input name="mouldId" class="groupselectbox" type="checkbox" >',width:"5%"}
							};
							group=new WeaverEditTable(option);
							jQuery("#defaultMouldList").append(group.getContainer());
							});
					</script>
			</wea:item>
		</wea:group>
		<%String groupAttrsTaoH = "{'groupDisplay':'"+((useTempletNode<=0||flowDocCatField<=0)?"none":"")+"','itemAreaDisplay':'"+((useTempletNode<=0||flowDocCatField<=0)?"none":"")+"'}"; 
			%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>' attributes="<%=groupAttrsTaoH %>">
			<wea:item><%=SystemEnv.getHtmlLabelName(22755,user.getLanguage())%></wea:item>
			<wea:item>
				
					<%
					String SQLDocumentLocation = null;
					if("1".equals(isbill)){
						SQLDocumentLocation = SQL + " and formField.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and isAccordToSubCom='0' and formField.ID = workflow_selectitem.fieldid and isBill='1' )order by formField.dspOrder";
					}else{
						SQLDocumentLocation = SQL + " and formDict.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and isAccordToSubCom='0' and formDict.ID = workflow_selectitem.fieldid and isBill='0') order by formField.fieldorder";
					}
	                               
	                RecordSet.executeSql(SQLDocumentLocation);  
	                while(RecordSet.next())
	                { formDictID = RecordSet.getInt("ID");
							if(formDictID == flowDocCatField){
							flag = flowDocCatField;
							
						%>
						 <span><%= RecordSet.getString("fieldLable") %></span>&nbsp;
						<a href="#" class="weihu" onclick="return false;">
						<span class="middle e8_btn_top_first" ><%=SystemEnv.getHtmlLabelName(60,user.getLanguage()) %></span></a>
						<%}else{continue;}}%>
			</wea:item>
		</wea:group>
		<%String groupAttrs1 = "{'groupDisplay':'"+((useTempletNode<=0||flowDocCatField<=0)?"none":"")+"','itemAreaDisplay':'"+((useTempletNode<=0||flowDocCatField<=0)?"none":"")+"','samePair':'selectMouldSetting'}"; %>
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("23039,30747",user.getLanguage())%>' attributes="<%=groupAttrs1 %>">
			<wea:item attributes="{'isTableList':'true'}">
				<div id="defaultSelectMould"></div>
			</wea:item>
		</wea:group>
	</wea:layout>
	<%} %>
</div>
<div id="wfEditMould" style="display:none" class="wfOfficalDoc">	
	
<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33325,user.getLanguage())%>'>
			<wea:item type="groupHead">
				<input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="attachRelative('defaultEditMouldList');"/>
				<input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="detachRelative('defaultEditMouldList');"/>
			</wea:item>
			<wea:item attributes="{'isTableList':'true'}">
				<% 
					String sql = "select 1 from workflow_mould where mouldType=3 and workflowid = "+workflowId;
					RecordSet.executeSql(sql);
					if(!RecordSet.next()){
						//将该子目录关联的文档插入到中间表中

						RecordSet.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMouldFile docMould WHERE docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(4,8) AND docSecCategoryMould.mouldBind = 2 AND docSecCategoryMould.secCategoryID = " + secCategory);
						if(RecordSet.next()){
							RecordSet.beforFirst();
							while(RecordSet.next()){
								RecordSet.executeSql("insert into workflow_mould(workflowid,mouldId,mouldType,visible,seccategory) values("+workflowId+","+RecordSet.getString("ID")+",3,1,"+secCategory+")");
							}
						}else{
							RecordSet.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMouldFile docMould WHERE docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(4,8) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + secCategory);
							while(RecordSet.next()){
								RecordSet.executeSql("insert into workflow_mould(workflowid,mouldId,mouldType,visible,seccategory) values("+workflowId+","+RecordSet.getString("ID")+",3,1,"+secCategory+")");
							}
						}
					}
					sql = "SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMouldFile docMould WHERE docMould.ID in (select mouldid from workflow_mould where visible=1 and mouldType=3 and workflowid = "+workflowId+") and docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(4,8) AND docSecCategoryMould.mouldBind = 2 AND docSecCategoryMould.secCategoryID = " + secCategory;
					RecordSet.executeSql(sql);
					String ajaxDatas = "";
					if(RecordSet.next()){
						RecordSet.beforFirst();
					}else{
						RecordSet.executeSql("SELECT docMould.ID, docMould.mouldName FROM DocSecCategoryMould docSecCategoryMould, DocMouldFile docMould WHERE docMould.ID in (select mouldid from workflow_mould where visible=1 and seccategory="+secCategory+" and mouldType=3 and workflowid = "+workflowId+") and docSecCategoryMould.mouldID = docMould.ID AND docSecCategoryMould.mouldType in(4,8) AND docSecCategoryMould.mouldBind = 1 AND docSecCategoryMould.secCategoryID = " + secCategory);
					}
					WeaverEditTableUtil.setWorkflowid(workflowId+"");
					ajaxDatas = WeaverEditTableUtil.getInitDatas("editMould",user,RecordSet);
				%>
				<div id="defaultEditMouldList"></div>
				<script type="text/javascript">
						var editGroup = null;
						jQuery(document).ready(function(){
							var ajaxDatas = <%=ajaxDatas%>
							var items=[
								{width:"30%",colname:"<%=SystemEnv.getHtmlLabelNames("28052",user.getLanguage())%>",itemhtml:"<span type='span' name='defaultMould'></span>"},
								{width:"65%",colname:"<%=SystemEnv.getHtmlLabelNames("33338",user.getLanguage())%>",itemhtml:"<span type='span' name='operate'></span>"},
								{width:"15%",colname:"<%=SystemEnv.getHtmlLabelNames("149",user.getLanguage())%>",itemhtml:"<input type='radio' name='setDefEdit' _normalraido='true'  />"}
								];
							var option = {
								basictitle:"",
								optionHeadDisplay:"none",
								colItems:items,
								container:"#defaultEditMouldList",
								toolbarshow:false,
								configCheckBox:true,
								usesimpledata:true,
								openindex:false,
								addrowCallBack:setDefEdit,
								initdatas:ajaxDatas,
             					checkBoxItem:{"itemhtml":'<input name="mouldId" class="groupselectbox" type="checkbox" >',width:"5%"}
							};
							editGroup=new WeaverEditTable(option);
							jQuery("#defaultEditMouldList").append(editGroup.getContainer());
							});
					</script>
			</wea:item>
		</wea:group>
		<%String groupAttrsEdit = "{'groupDisplay':'"+(flowDocCatField<=0?"none":"")+"','itemAreaDisplay':'"+(flowDocCatField<=0?"none":"")+"'}"; 
			%>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(23039,user.getLanguage())%>' attributes="<%=groupAttrsEdit %>">
			<wea:item><%=SystemEnv.getHtmlLabelName(22755,user.getLanguage())%></wea:item>
			<wea:item>
				
					<%
					String SQLDocumentLocation = null;
					if("1".equals(isbill)){
						SQLDocumentLocation = SQL + " and formField.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and isAccordToSubCom='0' and formField.ID = workflow_selectitem.fieldid and isBill='1' )order by formField.dspOrder";
					}else{
						SQLDocumentLocation = SQL + " and formDict.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and isAccordToSubCom='0' and formDict.ID = workflow_selectitem.fieldid and isBill='0') order by formField.fieldorder";
					}
	                               
	                RecordSet.executeSql(SQLDocumentLocation);  
	                while(RecordSet.next())
	                {
	                    formDictID = RecordSet.getInt("ID");
						if(formDictID == flowDocCatField) { flag = flowDocCatField;
					%>
					 <span ><%= RecordSet.getString("fieldLable") %></span>&nbsp;
					 <a  href="#" class="weihu"> <span class="middle e8_btn_top_first" ><%=SystemEnv.getHtmlLabelName(60,user.getLanguage()) %></span></a>		
					<%}else{continue;}}%>
			
				
			</wea:item>
		</wea:group>
		<%String groupAttrs1 = "{'groupDisplay':'"+(flowDocCatField<=0?"none":"")+"','itemAreaDisplay':'"+(flowDocCatField<=0?"none":"")+"','samePair':'selectEditMouldSetting'}"; %>
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("23039,30747",user.getLanguage())%>' attributes="<%=groupAttrs1 %>">
			<wea:item attributes="{'isTableList':'true'}">
				<div id="editSelectMould"></div>
			</wea:item>
		</wea:group>
	</wea:layout>
	</div>
	
	<%
		StringBuffer printNodesSb=new StringBuffer();
		printNodesSb.append(" select a.nodeId,b.nodeName,a.nodeType ")
			.append(" from  workflow_flownode a,workflow_nodebase b ")
			.append(" where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id ")
			.append("   and a.workflowId=").append(workflowId)
			.append(" order by a.nodeType asc,a.nodeId asc ")				
			;
		RecordSet.executeSql(printNodesSb.toString());
	%>
	<div id="wfPrint" style="display:none" class="wfOfficalDoc">
		<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'2','cws':'30%,70%'}">	
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("15070",user.getLanguage())%></wea:item>
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("33332",user.getLanguage())%></wea:item>
				<%while(RecordSet.next()){ %>
					<wea:item><%=Util.null2String(RecordSet.getString("nodeName"))%></wea:item>
					<wea:item><input name="printNodes" <%=(","+printNodes+",").indexOf(Util.null2String(RecordSet.getString("nodeId")))!=-1?"checked":"" %> type="checkbox" tzCheckbox="true" value='<%=Util.null2String(RecordSet.getString("nodeId"))%>'/></wea:item>
				<%} %>
			</wea:group>
		</wea:layout>
	</div>
	<%
		StringBuffer printNodesSb2=new StringBuffer();
		printNodesSb2.append(" select a.nodeId,b.nodeName,a.nodeType ")
			.append(" from  workflow_flownode a,workflow_nodebase b ")
			.append(" where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id ")
			.append("   and a.workflowId=").append(workflowId)
			.append(" and a.nodeType!=3 ")
			.append(" order by a.nodeType asc,a.nodeId asc ")				
			;
		RecordSet.executeSql(printNodesSb2.toString());
	%>
	<div id="wfSignature" style="display:none" class="wfOfficalDoc">
		<wea:layout type="table" needImportDefaultJsAndCss="false" attributes="{'cols':'2','cws':'30%,70%'}">
			<wea:group context="" attributes="{'groupDisplay':'none'}">
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("15070",user.getLanguage())%></wea:item>
				<wea:item type="thead"><%=SystemEnv.getHtmlLabelNames("26472,21650",user.getLanguage())%></wea:item>
				<%while(RecordSet.next()){ %>
					<wea:item><%=Util.null2String(RecordSet.getString("nodeName"))%></wea:item>
					<wea:item><input name="signatureNodes" <%=(","+signatureNodes+",").indexOf(Util.null2String(RecordSet.getString("nodeId")))!=-1?"checked":"" %> type="checkbox" tzCheckbox="true" value='<%=Util.null2String(RecordSet.getString("nodeId"))%>'/></wea:item>
				<%} %>
			</wea:group>
		</wea:layout>
	</div>
	<div id="wfTrace" style="display:none" class="wfOfficalDoc">
		<wea:layout needImportDefaultJsAndCss="false">	
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(132414,user.getLanguage())%></wea:item>
				<wea:item>
					<input class=inputstyle tzCheckbox="true" type="checkbox" name="isCompellentMark" onclick="onchangeIsCompellentMark()" value="1" <%if("1".equals(isCompellentMark)){%>checked<%}%> />
					<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(21637,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(132415,user.getLanguage())%></wea:item>
				<wea:item>
			        <input class=inputstyle tzCheckbox="true" type="checkbox" id="isCancelCheck" name="isCancelCheck" onclick="onchangeIsCancelCheck()" value="1" <%if("1".equals(isCompellentMark)){%>disabled<%}%> <%if("1".equals(isCancelCheck)){%>checked<%}%>/>
				    <input type="hidden" name="isCancelCheckInput" value="<%if("1".equals(isCancelCheck)){%>1<%}else{%>0<%}%>" />	
				    <span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(132416,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(24443,user.getLanguage())%></wea:item>
				<wea:item>
					<input class=inputstyle tzCheckbox="true" type="checkbox" name="isHideTheTraces"  value="1" <%if("1".equals(isHideTheTraces)){%>checked<%}%> />
					<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(24444,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
	<div id="wfProcess" style="display:none" class="wfOfficalDoc">
		<wea:layout needImportDefaultJsAndCss="false" attributes="{'expandAllGroup':'true'}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(23775,user.getLanguage())%></wea:item>
			<wea:item>
				
					<select class=inputstyle name="officalType" id="officalType" onchange="initProcessDefine()">
					    <option value=-1></option>
						<option value=1 <% if(officalType == 1) {  %> selected <% } %> ><%= SystemEnv.getHtmlLabelName(26528,user.getLanguage()) %></option>
						<option value=2 <% if(officalType == 2) {  %> selected <% } %> ><%= SystemEnv.getHtmlLabelName(33682,user.getLanguage()) %></option>
						<option value=3 <% if(officalType == 3) {  %> selected <% } %> ><%= SystemEnv.getHtmlLabelName(33683,user.getLanguage()) %></option>
					</select>
				
			</wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("26528,33733",user.getLanguage())%>'>
			<wea:item attributes="{'isTableList':'true'}">
				<div id="processDefineDiv"></div>
			</wea:item>
		</wea:group>
		</wea:layout>
	</div>
<INPUT type=hidden id='workFlowID' name='workFlowID' value=<%= request.getParameter("wfid") %>>
<INPUT type=hidden id='formID' name='formID' value=<%= formID %>>
<INPUT type=hidden id='isbill' name='isbill' value=<%= isbill %>>                            
<input type=hidden id='mainCategoryDocument' name='mainCategoryDocument' value="<%= mainCategory %>">
<INPUT type=hidden id='subCategoryDocument' name='subCategoryDocument' value="<%= subCategory %>">
<INPUT type=hidden id='secCategoryDocument' name='secCategoryDocument' value="<%= secCategory %>">   
</FORM>


<div id="wfPDF"  style="display:none;" class="wfOfficalDoc">
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
<wea:group context='<%=SystemEnv.getHtmlLabelName(125964,user.getLanguage())%>'>
	
			<wea:item type="groupHead">
				<input type=button class="addbtn" onclick="addPDFSet(<%= formID %>,<%= isbill %>);"  title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>"></input>
				<input type=button class="delbtn" onclick="delPDFSet();"  title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>"></input>
			</wea:item>
	
		<wea:item attributes="{\"isTableList\":\"true\"}">
			 <%
				String sqlWhere = "workflowId="+workflowId;
				String intanceid="";			
				String tabletype = "checkbox";
				 String operateString ="";
			   operateString += "<operates width=\"20%\">";
		       operateString+=" <popedom column=\"id\" transmethod=\"weaver.splitepage.operate.SpopForDoc.getPDFOpt\"></popedom> ";
		       operateString+="     <operate href=\"javascript:editPDFSet()\"  text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>";
			   operateString+="     <operate href=\"javascript:delPDFSet2()\"  text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"1\"/>";
		       operateString+="</operates> ";
				String tableString=""+
				   "<table pageId=\"wf_pdf2\" instanceid=\""+intanceid+"\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.DOC_SECCATEGORDEAULTRIGHT,user.getUID(),PageIdConst.DOC)+"\" tabletype=\""+tabletype+"\">"+
				   "<sql backfields=\"*\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlform=\"workflow_texttopdfconfig\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" /> ";
				   tableString += operateString;
				   tableString += "<head>";
				   tableString += "<col width=\"20%\" transmethod=\"weaver.splitepage.operate.SpopForDoc.getNodename\"     text=\""+SystemEnv.getHtmlLabelName(19346,user.getLanguage())+"\" column=\"topdfnodeid\" otherpara=\""+user.getLanguage()+"\"  orderkey=\"topdfnodeid\"/>"+
						 "<col width=\"20%\" text=\""+SystemEnv.getHtmlLabelName(19347,user.getLanguage())+"\" column=\"operationtype\"  transmethod=\"weaver.splitepage.operate.SpopForDoc.getOperationtype\"  otherpara=\""+user.getLanguage()+"\"     orderkey=\"operationtype\"/>"+
						 "<col width=\"20%\"  column=\"checktype\" text=\""+SystemEnv.getHtmlLabelName(1025,user.getLanguage())+"\"  transmethod=\"weaver.splitepage.operate.SpopForDoc.getChecktype\"  otherpara=\""+user.getLanguage()+"\"     orderkey=\"checktype\"/>"+
					     "<col width=\"20%\" transmethod=\"weaver.splitepage.operate.SpopForDoc.getSavepath\" text=\""+SystemEnv.getHtmlLabelName(125966,user.getLanguage())+"\" column=\"catalogtype2\" otherpara=\""+user.getLanguage()+"+"+isbill+"+"+formID+"+column:pdfsavesecid+column:selectcatalog2\"  orderkey=\"catalogtype2\"/>"+
						 "<col width=\"20%\" transmethod=\"weaver.splitepage.operate.SpopForDoc.getPdffieldName\"  otherpara=\""+user.getLanguage()+"+"+isbill+"+"+formID+"\" text=\""+SystemEnv.getHtmlLabelName(125967,user.getLanguage())+"\" column=\"pdffieldid\"   orderkey=\"pdffieldid\"/>"+
				         "<col width=\"20%\" transmethod=\"weaver.splitepage.operate.SpopForDoc.getPdfdocstatus\" text=\""+SystemEnv.getHtmlLabelName(126111,user.getLanguage())+"\" column=\"pdfdocstatus\" otherpara=\""+user.getLanguage()+"+column:pdfdocstatus\"    orderkey=\"pdfdocstatus\"/>";
				
					
				 tableString+=		 
				   "</head>"+
				   "</table>";
				   
			%> 
			<input type="hidden" name="pageId" id="pageId" value="wf_pdf2"/>
			<wea:SplitPageTag isShowTopInfo="false" tableString='<%=tableString%>' mode="run"  />
		</wea:item>
	</wea:group>
</wea:layout>
</div>

<div id="wfAction" style="display:none" class="wfOfficalDoc">
	<wea:layout needImportDefaultJsAndCss="false">	
			<wea:group context='<%=SystemEnv.getHtmlLabelName(33407,user.getLanguage())%>'>
			<wea:item type="groupHead">
				<input type="button" class="addbtn" title="<%= SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onclick="groupAction.addRow();"/>
				<input type="button" class="delbtn" title="<%= SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onclick="deleteAction();"/>
			</wea:item>
			<wea:item attributes="{'isTableList':'true','colspan':'full'}">
				<div id="actionList"></div>
				<%  RecordSet.executeSql("select * from workflow_addinoperate where workflowid="+workflowId+" and type=1");
					String ajaxDatas = WeaverEditTableUtil.getInitDatas("actionList",user,RecordSet); 
				%>
				<script type="text/javascript">
					var groupAction = null;
					jQuery(document).ready(function(){
						var ajaxDatas = <%=ajaxDatas%>
						var items=[
							{width:"10%",colname:"<%=SystemEnv.getHtmlLabelNames("33331",user.getLanguage())%>",itemhtml:"<%=fields%>"},
							{width:"15%",colname:"<%=SystemEnv.getHtmlLabelNames("19831",user.getLanguage())%>",itemhtml:"<%=actions%>"},
							{width:"20%",colname:"<%=SystemEnv.getHtmlLabelNames("33408",user.getLanguage())%>",itemhtml:"<%=modes%>"},
							{width:"30%",colname:"<%=SystemEnv.getHtmlLabelNames("33410",user.getLanguage())%>",itemhtml:"<%=linkOrNodes%>"},
							{width:"20%",colname:"<input type='checkbox' onclick='checkAllRejectTrigger(this)'/><%=SystemEnv.getHtmlLabelNames("33409",user.getLanguage())%>",itemhtml:"<%=rejectTriggers%>"}
							];
						var option = {
							basictitle:"",
							optionHeadDisplay:"none",
							colItems:items,
							container:"#actionList",
							toolbarshow:false,
							openindex:true,
							configCheckBox:true,
							usesimpledata:true,
							initdatas:ajaxDatas,
							addrowCallBack:initRejectTriiger,
            				checkBoxItem:{"itemhtml":'<input name="actionChecbox" class="groupselectbox" type="checkbox" value=-1>',width:"5%"}
						};
						groupAction=new WeaverEditTable(option);
						jQuery("#actionList").append(groupAction.getContainer());
					});
					function deleteAction(){
						//top.Dialog.confirm("<%=SystemEnv.getHtmlLabelNames("15097",user.getLanguage())%>",function(){
							groupAction.deleteRows();
						//});
					}
					function getBrowserUrlFn(obj){
						var mode = jQuery(obj).closest("tr").children("td").eq(3).children("select").val();
						if(mode=="1"){
							return "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/WorkFlowNodeBrowser.jsp?wfid=<%=workflowId%>";
						}else{
							return "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/WorkFlowLinkBrowser.jsp?wfid=<%=workflowId%>";
						}
					}
					function getCompleteUrl(obj){
						var mode = jQuery(obj).closest("tr").children("td").eq(3).children("select").val();
						if(mode=="1"){
							return "/data.jsp?type=workflowNodeBrowser&wfid=<%=workflowId%>";
						}else{
							return "/data.jsp?type=WorkflowNodePortalBrowserMulti&wfid=<%=workflowId%>";
						}
					}
					function clearLinkOrNode(obj){
						var e8_os = jQuery(obj).closest("tr").children("td").eq(4).find("div.e8_os");
						var innerOs = jQuery(obj).closest("tr").children("td").eq(4).find("div.e8_innerShow");
						e8_os.find("input[type='hidden']").val("");
						e8_os.find("span.e8_showNameClass").remove();
						innerOs.find("span[name$='spanimg']").html("<img src='/images/BacoError_wev8.gif' align='absmiddle'/>");
						var span = jQuery(obj).closest("tr").children("td").eq(5).children("span");
						if(jQuery(obj).val()=="1"){
							span.show();
						}else{
							span.hide();
						}
					}
					
					function initRejectTriiger($this,tr){
						var checkbox = $this.children("td").eq(5).find("input[type='checkbox']");
						var isnode = $this.children("td").eq(3).find("select").val();
						if(isnode=="0"){
							checkbox.parent().parent().hide();
							return;
						}
						if(checkbox.val()=="1"){
						}else{
							changeCheckboxStatus(checkbox,false);
						}
					}
					
					function checkAllRejectTrigger(obj){
						var trs = jQuery(obj).closest("table").find("tbody").children("tr.contenttr");
						var checked = false;
						if(jQuery(obj).attr("checked")){
							checked = true;
						}
						trs.each(function(){
							var checkbox = jQuery(this).children("td").eq(5).find("input[type='checkbox']");
							changeCheckboxStatus(checkbox,checked);
						});
					}
				</script>
			</wea:item>
		</wea:group>
	</wea:layout>
</div>

<form name="docPropDetailForm" id="docPropDetailForm" method="post" action="WorkflowDocPropDetailOperation.jsp">
	<div id="wfDocProp" style="display:none" class="wfOfficalDoc">
		<wea:layout needImportDefaultJsAndCss="false" attributes="{'expandAllGroup':'true'}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(33328,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelName(33319,user.getLanguage())%></wea:item>
				<wea:item><%=defaultView%></wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(26608,user.getLanguage())%></wea:item>
				<% 
					RecordSet.executeSql("select isuser,e8number from DocSecCategory where id="+secCategory);
					String isuser = "";
					String number = "";
					if(RecordSet.next()){
						isuser = Util.null2String(RecordSet.getString("isuser"));
						number = Util.null2String(RecordSet.getString("e8number"));
					}
					String sql = "select * from DocSecCategoryDocProperty where isCustom = 1 and secCategoryId="+secCategory+" and fieldid in (select id from cus_formdict where fieldhtmltype=3 and type=1)";//单人力资源字段

					RecordSet.executeSql(sql);
				%>
				<wea:item>
					<select name="isuser" id="isuser">
						<option value=""></option>
						<%while(RecordSet.next()){ %>
							<option value="<%=RecordSet.getString("id") %>" <%=isuser.equals(RecordSet.getString("id"))?"selected":"" %>><%=ktm.getPropName(RecordSet.getString("id"),""+user.getLanguage(),false) %></option>
						<%} %>
					</select>
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(26609,user.getLanguage())%></wea:item>
				<% 
					sql = "select * from DocSecCategoryDocProperty where isCustom = 1 and secCategoryId="+secCategory+" and fieldid in (select id from cus_formdict where fieldhtmltype=1 and type=1)";//单行文本字段
					RecordSet.executeSql(sql);
				%>
				<wea:item>
					<select name="number" id="number">
						<option value=""></option>
						<%while(RecordSet.next()){ %>
							<option value="<%=RecordSet.getString("id") %>" <%=number.equals(RecordSet.getString("id"))?"selected":"" %>><%=ktm.getPropName(RecordSet.getString("id"),""+user.getLanguage(),false) %></option>
						<%} %>
					</select>
				</wea:item>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(33329,user.getLanguage())%>'>
				<wea:item attributes="{'isTableList':'true'}">
					<div id="docPropDetailDiv"></div>
				</wea:item>
			</wea:group>
			<%String groupAttrs =  "{'groupDisplay':'"+(flowDocCatField<=0?"none":"")+"','itemAreaDisplay':'"+(flowDocCatField<=0?"none":"")+"'}";  %>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(19214,user.getLanguage())%>' attributes="<%=groupAttrs %>">
			<wea:item><%=SystemEnv.getHtmlLabelName(22755,user.getLanguage())%></wea:item>
			<wea:item>
				
					<%
					String SQLDocumentLocation = null;
					if("1".equals(isbill)){
						SQLDocumentLocation = SQL + " and formField.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and isAccordToSubCom='0' and formField.ID = workflow_selectitem.fieldid and isBill='1' )order by formField.dspOrder";
					}else{
						SQLDocumentLocation = SQL + " and formDict.fieldHtmlType = '5' and not exists ( select * from workflow_selectitem where (docCategory is null or docCategory = '') and isAccordToSubCom='0' and formDict.ID = workflow_selectitem.fieldid and isBill='0') order by formField.fieldorder";
					}
	                               
	                RecordSet.executeSql(SQLDocumentLocation);  
	                while(RecordSet.next())
	                {
	                    formDictID = RecordSet.getInt("ID");
						if(formDictID == flowDocCatField) { flag = flowDocCatField;
					%>
					 <span ><%= RecordSet.getString("fieldLable") %></span>
					 <a  href="#" class="weihu"> <span class="middle e8_btn_top_first" ><%=SystemEnv.getHtmlLabelName(60,user.getLanguage()) %></span></a>		
					<%}else{continue;}}%>
				
				
			</wea:item>
		</wea:group>
		<%String groupAttrs2 = "{'groupDisplay':'"+((useTempletNode<=0||flowDocCatField<=0)?"none":"")+"','itemAreaDisplay':'none','samePair':'propSetting'}"; %>
		<wea:group context='<%=SystemEnv.getHtmlLabelNames("33403",user.getLanguage())%>' attributes="<%=groupAttrs2 %>">
			<wea:item attributes="{'isTableList':'true'}">
				<div id="selectPropDiv"></div>
			</wea:item>
		</wea:group>
		</wea:layout>
	</div>
</form>
<%
        int tracefieldid=0;
        int tracedocownertype=0;
        int tracedocownerfieldid=0;
        int tracedocowner=0;
        String tracesavesecidspan="";
        RecordSet.executeSql("select traceFieldId,traceSaveSecId,traceDocOwnerType,traceDocOwnerFieldId,traceDocOwner from workflow_base where id="+workflowId);
        if(RecordSet.next()){
		    tracefieldid = Util.getIntValue(RecordSet.getString("traceFieldId"),0);
		    tracesavesecid = Util.getIntValue(RecordSet.getString("traceSaveSecId"),0);
		    tracedocownertype = Util.getIntValue(RecordSet.getString("traceDocOwnerType"),0);
		    tracedocownerfieldid = Util.getIntValue(RecordSet.getString("traceDocOwnerFieldId"),0);
		    tracedocowner = Util.getIntValue(RecordSet.getString("traceDocOwner"),0);		  
        }
		String tracesavesecpath="-1,-1,"+tracesavesecid;
		String tracedocownerstr=""+tracedocowner;
		String tracedocownerspan = ResourceComInfo.getLastname(tracedocownerstr);

	    if(tracesavesecid>0){
			tracesavesecidspan = secCategoryComInfo.getAllParentName(String.valueOf(tracesavesecid),true);     
			tracesavesecidspan = tracesavesecidspan.replaceAll("<", "＜").replaceAll(">", "＞").replaceAll("&lt;", "＜").replaceAll("&gt;", "＞");
	   }

        RecordSet.executeSql("select id from TraceProp where workflowId="+workflowId);
        if(RecordSet.next()){
		    docPropId_Trace = Util.getIntValue(RecordSet.getString("id"),0);	  
        }

%>
<form name="tracePropDetailForm" id="tracePropDetailForm" method="post" action="WorkflowtracePropDetailOperation.jsp">
	<INPUT type=hidden id='isdialog' name='isdialog' value="1">        
	<div id="wfTraceProp"  style="display:none;" class="wfOfficalDoc">
		<wea:layout needImportDefaultJsAndCss="false" attributes="{'expandAllGroup':'true'}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(82751,user.getLanguage())%>'>
				<wea:item><%=SystemEnv.getHtmlLabelNames("32712",user.getLanguage())%></wea:item>
				<wea:item>
					<brow:browser name="tracesavesecpath" idKey="id" nameKey="path" viewType="0" hasBrowser="true" hasAdd="false" 
								browserUrl="/systeminfo/BrowserMain.jsp?url=/docs/category/MultiCategorySingleBrowser.jsp" isMustInput="1" isSingle="true" hasInput="true" language='<%=""+user.getLanguage() %>'
								temptitle='<%= SystemEnv.getHtmlLabelName(22220,user.getLanguage())%>'
								completeUrl="/data.jsp?type=categoryBrowser" _callback="onShowCatalogData_trace"  width="300px" browserValue='<%=tracesavesecpath%>' browserSpanValue='<%=tracesavesecidspan%>' />	    
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(129068,user.getLanguage())%></wea:item>
				<wea:item>
					<select id="tracedocownertype" name="tracedocownertype" onchange="onchangetracedocownertype(this.value)" style="float: left;">
						<option value="0"></option>
						<option value="1" <%if("1".equals(""+tracedocownertype)){out.println("selected");}%> ><%=SystemEnv.getHtmlLabelName(23122,user.getLanguage())%></option>
						<option value="2" <%if("2".equals(""+tracedocownertype)){out.println("selected");}%> ><%=SystemEnv.getHtmlLabelName(15549,user.getLanguage())%></option>
					</select>
					<span id="selecttracedocowner" name="selecttracedocowner" style="display:<%if(!"1".equals(""+tracedocownertype)){out.println("none");}%>">
						<brow:browser name="tracedocowner" viewType="0" hasBrowser="true" hasAdd="false" 
						temptitle='<%= SystemEnv.getHtmlLabelName(179,user.getLanguage())%>' language='<%=""+user.getLanguage() %>'
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" isMustInput="1" isSingle="true" hasInput="true"
						completeUrl="/data.jsp"  width="300px" browserValue='<%=tracedocownerstr%>' browserSpanValue='<%=tracedocownerspan%>' />
					</span>
					<select id="tracedocownerfieldid" name="tracedocownerfieldid" style="display:<%if(!"2".equals(""+tracedocownertype)){out.println("none");}%>">
						<%
						String sql_tmp = "";
						if("1".equals(isbill)){
							sql_tmp = "select formField.id,fieldLable.labelName as fieldLable "
									+ "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
									+ "where fieldLable.indexId=formField.fieldLabel "
									+ "  and formField.billId= " + formID
									+ "  and formField.viewType=0 "
									+ "  and fieldLable.languageid =" + user.getLanguage()
									+ " and formField.fieldHtmlType='3' and formField.type=1 order by formField.id";
						}else{
							sql_tmp = "select formDict.id, fieldLable.fieldLable "
									+ "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
									+ "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
									+ "and formField.formid = " + formID
									+ " and fieldLable.langurageid = " + user.getLanguage()
									+ " and formDict.fieldHtmlType='3' and formDict.type=1 order by formDict.id";
						}
						RecordSet.executeSql(sql_tmp);
						while(RecordSet.next()){
							String fieldid_tmp = Util.null2String(RecordSet.getString("id"));
							String fieldlabel_tmp = Util.null2String(RecordSet.getString("fieldLable"));
							String selectedStr = "";
							if(!"".equals(""+tracedocownerfieldid) && fieldid_tmp.equals(""+tracedocownerfieldid)){
								selectedStr = " selected ";
							}
							out.println("<option value=\""+fieldid_tmp+"\" "+selectedStr+">"+fieldlabel_tmp+"</option>\n");
						}%>
					</select>    	
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelNames("129070",user.getLanguage())%></wea:item>
				<wea:item>
					<select id="tracefieldid" name="tracefieldid" >
						<option value="0"></option>
						<%
						String sql_tmp = "";
						if("1".equals(isbill)){
							sql_tmp = "select formField.id,fieldLable.labelName as fieldLable "
									+ "from HtmlLabelInfo  fieldLable ,workflow_billfield  formField "
									+ "where fieldLable.indexId=formField.fieldLabel "
									+ "  and formField.billId= " + formID
									+ "  and formField.viewType=0 "
									+ "  and fieldLable.languageid =" + user.getLanguage()
									+ " and formField.fieldHtmlType='3' and formField.type=37 order by formField.id";
						}else{
							sql_tmp = "select formDict.id, fieldLable.fieldLable "
									+ "from workflow_fieldLable fieldLable, workflow_formField formField, workflow_formdict formDict "
									+ "where fieldLable.formid = formField.formid and fieldLable.fieldid = formField.fieldid and formField.fieldid = formDict.ID and (formField.isdetail<>'1' or formField.isdetail is null) "
									+ "and formField.formid = " + formID
									+ " and fieldLable.langurageid = " + user.getLanguage()
									+ " and formDict.fieldHtmlType='3' and formDict.type=37 order by formDict.id";
						}
						RecordSet.executeSql(sql_tmp);
						while(RecordSet.next()){
							String fieldid_tmp = Util.null2String(RecordSet.getString("id"));
							String fieldlabel_tmp = Util.null2String(RecordSet.getString("fieldLable"));
							String selectedStr = "";
							if(!"".equals(""+tracefieldid) && fieldid_tmp.equals(""+tracefieldid)){
								selectedStr = " selected ";
							}
							out.println("<option value=\""+fieldid_tmp+"\" "+selectedStr+">"+fieldlabel_tmp+"</option>\n");
						}%>
					</select>
					<span class="e8tips" title="<%=SystemEnv.getHtmlLabelName(128752,user.getLanguage()) %>"><img src="/images/tooltip_wev8.png" align="absMiddle"/></span>		
				</wea:item>
			</wea:group>
			<wea:group context='<%=SystemEnv.getHtmlLabelName(33329,user.getLanguage())%>'>
				<wea:item attributes="{'isTableList':'true'}">
					<div id="tracePropDetailDiv"></div>
				</wea:item>
			</wea:group>
		</wea:layout>
	</div>
</form>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom" style="display:none;">
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
				if(dialog){
					jQuery("#zDialog_div_bottom").show();
				}
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
<%
    }
    else
    {
        response.sendRedirect("/notice/noright.jsp");
        return;
    }
%>

<script type="text/javascript">
    var javaWorkflowId="<%=workflowId %>";
    var javaFormId="<%=formID %>";
    var javaIsBill="<%=isbill %>";
    var javaSubCompanyID="<%=subCompanyID %>";
    var javaDocPropIdDefault="<%=docPropIdDefault %>";
    var javaDocPropId_Trace="<%=docPropId_Trace %>";
    var javaTracesavesecid = "<%=tracesavesecid %>";
    var msg_93 = "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>";
    var msg_33113 = "<%=SystemEnv.getHtmlLabelName(33113,user.getLanguage())%>";
    var msg_33435 = "<%=SystemEnv.getHtmlLabelName(33435,user.getLanguage())%>";
    var msg_19373 = "<%=SystemEnv.getHtmlLabelName(19373, user.getLanguage())%>";
    var msg_22878_33405 = "<%=SystemEnv.getHtmlLabelNames("22878,33405",user.getLanguage())%>";
    var msg_33338 = "<%=SystemEnv.getHtmlLabelNames("33338",user.getLanguage())%>";
    var msg_33400 = "<%=SystemEnv.getHtmlLabelNames("33400",user.getLanguage())%>";
    var msg_33197_30747 = "<%=SystemEnv.getHtmlLabelNames("33197,30747",user.getLanguage())%>";
    var msg_33325 = "<%=SystemEnv.getHtmlLabelNames("33325",user.getLanguage())%>";
    var msg_32568 = "<%=SystemEnv.getHtmlLabelName(32568,user.getLanguage())%>";
    var msg_83409 = "<%=SystemEnv.getHtmlLabelName(83409,user.getLanguage())%>";
    var msg_18758 = "<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage()) %>";
    var msg_16344 = "<%=SystemEnv.getHtmlLabelName(16344,user.getLanguage())%>";
    var msg_33592 = "<%=SystemEnv.getHtmlLabelName(33592,user.getLanguage())%>";
    var msg_83473 = "<%=SystemEnv.getHtmlLabelName(83473,user.getLanguage())%>";
    var msg_82 = "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>";
</script>
<script type="text/javascript" src="/js/odoc/workflow/workflow/CreateDocumentByWorkFlow.js"></script>

</BODY>
</HTML>
