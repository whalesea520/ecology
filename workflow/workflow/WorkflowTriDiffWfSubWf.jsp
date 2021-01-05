<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@page import="weaver.workflow.workflow.WfRightManager"%>
<%@page import="weaver.workflow.workflow.UserWFOperateLevel"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/tld/browser.tld" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="checkSubCompanyRight" class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="wfrm" class="weaver.workflow.workflow.WfRightManager" scope="page" />
<HTML>
<%
    String imagefilename = "/images/hdMaintenance_wev8.gif";
    String titlename = SystemEnv.getHtmlLabelName(19332,user.getLanguage()) + "：" + SystemEnv.getHtmlLabelName(19343,user.getLanguage())+"（"+SystemEnv.getHtmlLabelName(21591,user.getLanguage())+"）"+SystemEnv.getHtmlLabelName(19342,user.getLanguage());
    String needfav = "";
    String needhelp = "";
    int wfid=0;
    String dialog = Util.null2String(request.getParameter("dialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
%>
    <HEAD>
        <LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
        <SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
        <script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
        <script type="text/javascript">
    	var parentWin = null;
		var curdialog = null;
		if("<%=dialog%>"==1){
			parentWin = parent.parent.getParentWindow(parent);
			curdialog = parent.parent.getDialog(parent);
			function btn_cancle(){
				curdialog.closeByHand();
			}
		}
		if("<%=isclose%>"==1){
			parentWin = parent.parent.getParentWindow(parent);
			dialog = parent.parent.getDialog(parent);
			dialog.close();
		}
		
    </script>
    </HEAD>
<BODY>
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<%}%>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSaveWorkflowTriDiffWfSubWf(this),_self}";
    RCMenuHeight += RCMenuHeightStep;
	if(!"1".equals(dialog)){
    RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:onCancelWorkflowTriDiffWfSubWf(this),_self}";
    RCMenuHeight += RCMenuHeightStep;
    } else {
    	RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btn_cancle(),_self}";
        RCMenuHeight += RCMenuHeightStep;
    }
%>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>{
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" class="e8_btn_top" onclick="onSaveWorkflowTriDiffWfSubWf(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<%

    int detachable = Util.getIntValue(String.valueOf(session.getAttribute("detachable")), 0);
	wfid = Util.getIntValue(request.getParameter("mainWorkflowId"),0);
	boolean haspermission = wfrm.hasPermission3(wfid, 0, user, WfRightManager.OPERATION_CREATEDIR);
	int subCompanyID= Util.getIntValue(Util.null2String(session.getAttribute(wfid+"subcompanyid")),-1);
	int operateLevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subCompanyID,user,haspermission,"WorkflowManage:All");  
    if(operateLevel < 1){   
        response.sendRedirect("/notice/noright.jsp");
    	return;
    }
	
	int triDiffWfDiffFieldId = Util.getIntValue(request.getParameter("triDiffWfDiffFieldId"),-1);
	
	String completeUrl = "/data.jsp";
	String browserUrl = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=";
   	int mainWorkflowId=0;
   	String triggerSourceType = "";
	String triggerSourceOrder = "";
	String triggerSource = "";
	
	String condition = "";
	String conditioncn = "";
	int detailid = 0;
		int triggerNodeId=0;
		String triggerTime="";
		int fieldId=0;

        RecordSet.executeSql("select * from Workflow_TriDiffWfDiffField where id=" + triDiffWfDiffFieldId);
        if(RecordSet.next()){
			mainWorkflowId=Util.getIntValue(RecordSet.getString("mainWorkflowId"),0);
			triggerNodeId=Util.getIntValue(RecordSet.getString("triggerNodeId"),0);
			triggerTime=Util.null2String(RecordSet.getString("triggerTime"));
			fieldId=Util.getIntValue(RecordSet.getString("fieldId"),0);
			triggerSourceType = RecordSet.getString("triggerSourceType");
			triggerSourceOrder = RecordSet.getString("triggerSourceOrder");
			if( triggerSourceType.equals("main") ){
				triggerSource = SystemEnv.getHtmlLabelName(21778, user.getLanguage());
			}else if( triggerSourceType.equals("detail") ){
				triggerSource = SystemEnv.getHtmlLabelName(19325, user.getLanguage()) + triggerSourceOrder;
				//加密
				detailid = RuleBusiness.getDetailTableId(Util.getIntValue(RecordSet.getString("triggersource"), 0), 0);
			}
			
			condition = Util.null2String(RecordSet.getString("condition"));
			conditioncn = RuleBusiness.getRuleInfoByRIds(8, triDiffWfDiffFieldId + "").get(RuleBusiness.RULE_DESC_KEY);  //Util.null2String(RecordSet.getString("conditioncn"));
		}

		String formId=WorkflowComInfo.getFormId(""+mainWorkflowId);
		String isBill=WorkflowComInfo.getIsBill(""+mainWorkflowId);
        //add by liaodong for qc61523 in 2013-11-12 start
		if("".equals(formId)|| "".equals(isBill)){
			RecordSet.executeSql("select formid,isbill from workflow_base where id=" + mainWorkflowId);
			  if(RecordSet.next()){
				  formId = RecordSet.getString("formid");
				  isBill = RecordSet.getString("isbill");
			  }
		}
		//end
		String triggerNodeName="";
        RecordSet.executeSql("select nodeName from workflow_nodebase where id=" + triggerNodeId);
        if(RecordSet.next()){
			triggerNodeName=Util.null2String(RecordSet.getString("nodeName"));
		}

		String triggerTimeText="";
		if("1".equals(triggerTime)){// 到达节点 
			triggerTimeText=SystemEnv.getHtmlLabelName(19348,user.getLanguage());
		}else if("2".equals(triggerTime)){//离开节点
			triggerTimeText=SystemEnv.getHtmlLabelName(19349,user.getLanguage());
		}

		String fieldName="";
		String fieldHtmlType="";
		int type=0;

		if("1".equals(isBill)){
			int fieldLabel=0;
			RecordSet.executeSql("select fieldLabel,fieldHtmlType,type from workflow_billfield where id=" + fieldId);
			if(RecordSet.next()){
				fieldLabel=Util.getIntValue(RecordSet.getString("fieldLabel"),0);
				fieldName=SystemEnv.getHtmlLabelName(fieldLabel,user.getLanguage());
				fieldHtmlType=Util.null2String(RecordSet.getString("fieldHtmlType"));
				type=Util.getIntValue(RecordSet.getString("type"),0);
			}
		}else{
			RecordSet.executeSql("select fieldLable from workflow_fieldlable where formId="+formId+" and fieldId="+fieldId+" and langurageId=" + user.getLanguage());
			if(RecordSet.next()){
				fieldName=Util.null2String(RecordSet.getString("fieldLable"));
			}
			fieldHtmlType=Util.null2String(FieldComInfo.getFieldhtmltype(""+fieldId));
			type=Util.getIntValue(FieldComInfo.getFieldType(""+fieldId),0);
		}

		wfid = mainWorkflowId;
		int rowNum=0;
		int pagenum=1;
	boolean useHrmResource=false;
	boolean useDocReceiveUnit=false;
	if(type==17||type==141||type==166){
		useHrmResource=true;
	}else if(type==142){
		useDocReceiveUnit=true;
		completeUrl = "/data.jsp?type=142";
		browserUrl = "/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserMulti.jsp?receiveUnitIds=";
	}
%>
<script type="text/javascript">
	var fieldValuePlugin={
		type:"browser",
		addIndex:true,
		attr:{
			name:"fieldValue",
			viewType:"0",
			browserValue:"0",
			isMustInput:"2",
			browserSpanValue:"",
			hasInput:true,
			linkUrl:"#",
			isSingle:false,
			completeUrl:"<%=completeUrl%>",
			browserUrl:"<%=browserUrl%>",
			width:"90%",
			hasAdd:false
		}
	};

	var subWorkflowIdPlugin={
		type:"browser",
		addIndex:true,
		attr:{
			name:"subWorkflowId",
			viewType:"0",
			browserValue:"0",
			isMustInput:"2",
			browserSpanValue:"",
			hasInput:true,
			linkUrl:"#",
			isSingle:true,
			completeUrl:"/data.jsp?type=workflowBrowser",
			browserUrl:"/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?isdata=subwf",
			width:"90%",
			hasAdd:false
		}
	};	

	var mappingIdPlugin = {
		type: "hidden",
		addIndex: true,
		name: "triDiffWfSubWfId"
	};

	var isReadPlugin = {
		type: "hidden",
		addIndex: true,
		name: "isRead"
	};
	var dialog = null;
	function onShowBrowser4port(id,rformid,risbill,rwfid,isreject,curtype){
	    if(id==0) {
	        //alert("请先保存新插入的节点出口");
	    } else {
	        dialog = new window.top.Dialog();
	        dialog.currentWindow = window;
	        var url = "/formmode/interfaces/showconditionContent.jsp?rulesrc=8&detailid=<%=detailid %>&formid="+rformid+"&isbill="+risbill+"&linkid="+id+"&wfid="+rwfid+"&isreject="+isreject+"&curtype="+curtype;
	        dialog.Title = "<%=SystemEnv.getHtmlLabelName(126298, user.getLanguage()) %>";
	        dialog.Width = 900;
	        dialog.Height = 500;
	        dialog.Drag = true;
	        dialog.maxiumnable = true;
	        dialog.URL = url;
	        dialog.show();
	    }
	}
</script>
<iframe id="iFrameWorkflowTriDiffWfSubWf" frameborder=0 scrolling=no src=""  style="display:none"></iframe>
<form name="formWorkflowTriDiffWfSubWf" method="post" action="WorkflowTriDiffWfSubWfOperation.jsp" >
	<input type=hidden id='callbackvalue' name='callbackvalue' >
	<input type=hidden id='triDiffWfDiffFieldId' name='triDiffWfDiffFieldId' value=<%=triDiffWfDiffFieldId %>>
	<input type=hidden name="mainWorkflowId" value="<%=mainWorkflowId %>">
	<input type="hidden" name="dialog" value="<%=dialog%>">	
		<wea:layout attributes="{'cw1':'35%','cw2':'65%','expandAllGroup':'true'}">
			<wea:group context='<%=SystemEnv.getHtmlLabelName(31826,user.getLanguage())%>'>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(33383,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<%=triggerSource %>
			</wea:item>
			<%--
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(33384,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<input type='hidden' id='triggerCondition' name='triggerCondition' value='triggerCondition'/>
			</wea:item>
			--%>
			
			<wea:item>
                <%=SystemEnv.getHtmlLabelName(33384,user.getLanguage())%>
            </wea:item>
            <wea:item>
                <!-- <input type='hidden' id='triggerCondition' name='triggerCondition' value='triggerCondition'/> -->
                <button type="button" class=Browser1 onclick="onShowBrowser4port(<%=triDiffWfDiffFieldId%>, <%=formId%>,<%=isBill%>,<%=mainWorkflowId %>)"></button>
                <input type="hidden" name="conditionss" id="conditionss" value="<%=condition %>">
                <input type="hidden" name="conditioncn" id="conditioncn" value="<%=conditioncn %>">
                <input type="hidden" name="conditionkeyid" id="conditionkeyid">
                <input type="hidden" name="rulemaplistids" id="rulemaplistids">
                <input type="hidden" name="ruleRelationship" id="ruleRelationship">
                <span id="conditions">
                <%=conditioncn %>
                </span>
            </wea:item>
            
            
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(21582,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<%=fieldName %>
			</wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(21593,user.getLanguage())%>'>
			<%
			int triDiffWfSubWfIdDefault = 0;
			int subWorkflowIdDefault = -999;
			String isReadDefault = "0";
			String isreadNodes = "";
			String isreadMainwfDefault = "0";
			String isreadMainWfNodes = "";
			String isreadParallelwfDefault = "0";
			String isreadParallelwfNodes = "";
			
			RecordSet.executeSql("select id,subWorkflowId,isRead,isreadMainwf,isreadParallelwf,isreadNodes,isreadMainWfNodes,isreadParallelwfNodes from Workflow_TriDiffWfSubWf where triDiffWfDiffFieldId="+triDiffWfDiffFieldId+" and fieldValue=-1 order by id asc");
			if(RecordSet.next()){
				triDiffWfSubWfIdDefault = Util.getIntValue(RecordSet.getString("id"),0);
				subWorkflowIdDefault = Util.getIntValue(RecordSet.getString("subWorkflowId"),-999);
				isReadDefault = RecordSet.getString("isRead");
				isreadNodes = RecordSet.getString("isreadNodes");
				isreadMainwfDefault = RecordSet.getString("isreadMainwf");
				isreadMainWfNodes = RecordSet.getString("isreadMainWfNodes");
				isreadParallelwfDefault = RecordSet.getString("isreadParallelwf");
				isreadParallelwfNodes = RecordSet.getString("isreadParallelwfNodes");
			}
			
			String subWorkflowNameDefault = WorkflowComInfo.getWorkflowname(""+subWorkflowIdDefault);
			%>
				<wea:item><%=SystemEnv.getHtmlLabelName(19344,user.getLanguage())%><INPUT type=hidden name=triDiffWfSubWfIdDefault  id="triDiffWfSubWfIdDefault" value='<%=triDiffWfSubWfIdDefault%>'></wea:item>
				<wea:item>
					<span>
						<%
							String subWorkflowIdDefaultValue = String.valueOf(subWorkflowIdDefault);
							String subWorkflowNameDefaultValue = subWorkflowNameDefault;
							if(subWorkflowIdDefault == -999){
								subWorkflowIdDefaultValue = "";
								subWorkflowNameDefaultValue= "";
							}
						 %>
						<brow:browser name="subWorkflowIdDefault" viewType="0" hasBrowser="true" hasAdd="false" 
			                browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowTypeBrowser.jsp?isdata=subwf" 
			                linkUrl="/workflow/workflow/addwf.jsp?src=editwf&isTemplate=0&wfid="
			                isMustInput="2" isSingle="true" hasInput="true" onPropertyChange="defaultSubWorkflowChange()"
			                completeUrl="/data.jsp?type=workflowBrowser&isTemplate=0"  width="150px" browserValue='<%=subWorkflowIdDefaultValue%>' browserSpanValue='<%=subWorkflowNameDefaultValue%>' />
			            <input type="hidden" id="old_subWorkflowIdDefault" name="old_subWorkflowIdDefault" value="<%=subWorkflowIdDefaultValue%>" />
					</span>
					<span style="margin-left:10px;display:inline-block;height:100%;line-height:30px;"><a id="subWorkflowIdDefault_a" href="#" onClick="triDiffWfSubWfFieldConfig(<%=triDiffWfDiffFieldId%>, <%=triDiffWfSubWfIdDefault%>, -1, jQuery('#subWorkflowIdDefault').val(), jQuery('#isReadDefault').val(), <%=mainWorkflowId%>)"><%=SystemEnv.getHtmlLabelName(21585,user.getLanguage())%></a></span>                                        	
				</wea:item>
				<wea:item><%=SystemEnv.getHtmlLabelName(31770,user.getLanguage())%></wea:item>
				<wea:item>
					<%
					String completeUrl1 = "/data.jsp?type=workflowNodeBrowser&wfid="+subWorkflowIdDefault;
					
					String nodeNames = "";
					String display = "display:none;";
					String checked = "";
					if("1".equals(isReadDefault)){
						display = "display:inline-block;";
						checked = "checked";
						//读取节点名称
						String sqlGetNodeName = "select id,nodename from workflow_nodebase wn where wn.id=";
						String[] nodeIds = isreadNodes.split(",");
						for(int i = 0 ; i < nodeIds.length; i++){
							if(nodeIds[i].equals("all")){
								nodeNames += SystemEnv.getHtmlLabelName(332, user.getLanguage());
								break;
							}
							
							String sqlTemp = sqlGetNodeName + nodeIds[i];
							RecordSet.executeSql(sqlTemp);
							if( RecordSet.next() ){
								nodeNames += RecordSet.getString("nodename");
								if( i != nodeIds.length - 1){
									nodeNames += ",";
								}
							}
						}
					} 
				%>
					<input type="checkbox" <%=checked %> tzCheckbox="true" id="isReadDefault" name="isReadDefault" value="1" onclick='isreadChange(this)'></input>
					<span id="isreadspan" style="<%=display%>vertical-align:middle;padding-left:5px;">
					<div style='float:left;padding:3px 5px 0px 10px;'>
						<%=SystemEnv.getHtmlLabelName(31773,user.getLanguage())%>
					</div>
					<brow:browser name="isreadNodes" viewType="0" hasBrowser="true" hasAdd="false" 
						getBrowserUrlFn="getIsReadNodesUrl"  isMustInput="1" isSingle="false" hasInput="true"
						completeUrl='<%=completeUrl1 %>'  width="300px" browserValue='<%=isreadNodes %>' browserSpanValue='<%=nodeNames %>' />
				</span>
				</wea:item>
				<wea:item>
				 <%=SystemEnv.getHtmlLabelName(31771,user.getLanguage())%>
			 </wea:item>
			<wea:item>
				<%
					String completeUrl1 = "/data.jsp?type=workflowNodeBrowser&wfid="+mainWorkflowId;
					String nodeNames = "";
					String display = "display:none;";
					String checked = "";
					if("1".equals(isreadMainwfDefault)){
						display = "display:inline-block;";
						checked = "checked";
						//读取节点名称
						String sqlGetNodeName = "select id,nodename from workflow_nodebase wn where wn.id=";
						String[] nodeIds = isreadMainWfNodes.split(",");
						for(int i = 0 ; i < nodeIds.length; i++){
							if(nodeIds[i].equals("all")){
								nodeNames += SystemEnv.getHtmlLabelName(332, user.getLanguage());
								break;
							}
							
							String sqlTemp = sqlGetNodeName + nodeIds[i];
							RecordSet.executeSql(sqlTemp);
							if( RecordSet.next() ){
								nodeNames += RecordSet.getString("nodename");
								if( i != nodeIds.length - 1){
									nodeNames += ",";
								}
							}
						}
					} 
				%>
				<input type='checkbox' <%=checked%>  id="isreadMainwf" name="isreadMainwf" onclick='isreadMainwfChange(this)' tzCheckbox='true' value="1"/>
                <span id="isreadMainwfspan" style="<%=display %>vertical-align:middle;padding-left:5px;">
					<div style='float:left;padding:3px 5px 0px 10px;'>
						<%=SystemEnv.getHtmlLabelName(31773,user.getLanguage())%>
					</div>
					<brow:browser name="isreadMainWfNodes" viewType="0" hasBrowser="true" hasAdd="false" 
						getBrowserUrlFn="getIsReadMainNodesUrl" isMustInput="1" isSingle="false" hasInput="true"
						completeUrl='<%=completeUrl1 %>'  width="300px" browserValue='<%=isreadMainWfNodes %>' browserSpanValue='<%=nodeNames %>' />
				</span>
			</wea:item>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(31772,user.getLanguage())%>
			</wea:item>
			<wea:item>
				<%
					String completeUrl1 = "/data.jsp?type=workflowNodeBrowser&wfid="+subWorkflowIdDefault;
					String nodeNames = "";
					String display = "display:none;";
					String checked = "";
					if("1".equals(isreadParallelwfDefault)){
						display = "display:inline-block;";
						checked = "checked";
						//读取节点名称
						String sqlGetNodeName = "select id,nodename from workflow_nodebase wn where wn.id=";
						String[] nodeIds = isreadParallelwfNodes.split(",");
						for(int i = 0 ; i < nodeIds.length; i++){
							if(nodeIds[i].equals("all")){
								nodeNames += SystemEnv.getHtmlLabelName(332, user.getLanguage());
								break;
							}
							
							String sqlTemp = sqlGetNodeName + nodeIds[i];
							RecordSet.executeSql(sqlTemp);
							if( RecordSet.next() ){
								nodeNames += RecordSet.getString("nodename");
								if( i != nodeIds.length - 1){
									nodeNames += ",";
								}
							}
						}
					} 
				%>
				<input type="checkbox" <%=checked %> tzCheckbox="true" id="isreadParallelwf" name="isreadParallelwf" value="1" onclick="isreadParallelwfChange(this)"></input>
                <span id="isreadParallelwfspan" style="<%=display %>vertical-align:middle;padding-left:5px;">
					<div style='float:left;padding:3px 5px 0px 10px;'>
						<%=SystemEnv.getHtmlLabelName(31773,user.getLanguage())%>
					</div>
					<brow:browser name="isreadParallelwfNodes" viewType="0" hasBrowser="true" hasAdd="false" 
						getBrowserUrlFn="getIsReadParaNodesUrl" isMustInput="1" isSingle="false" hasInput="true"
						completeUrl='<%=completeUrl1 %>'  width="300px" browserValue='<%=isreadParallelwfNodes %>' browserSpanValue='<%=nodeNames %>' />
				</span>
			</wea:item>
		</wea:group>
		<wea:group context='<%=SystemEnv.getHtmlLabelName(33505,user.getLanguage())%>'>
			<wea:item type="groupHead"> 
				<input type=button class=addbtn onclick="addNewRow()" title="<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>"></input>
	  			<input type=button class=delbtn onclick="deleteSelectedRow()" title="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>"></input>   
			</wea:item>
			<wea:item attributes="{'isTableList':'true'}">
				<!-- 分页列表 -->
				<% 
					String  operateString= "";
					operateString = "<operates width=\"20%\">";
					 	       operateString+=" <popedom isalwaysshow=\"true\"></popedom> ";
					 	       operateString+="     <operate  isalwaysshow=\"true\" href=\"javascript:openDialog();\" text=\""+SystemEnv.getHtmlLabelName(33503,user.getLanguage())+"\" index=\"0\"/>";
					 	       operateString+="     <operate  isalwaysshow=\"true\" href=\"javascript:goWorkflowSubwfSetDetail()\" otherpara=\""+triDiffWfDiffFieldId+"+column:id+column:fieldvalue+column:subWorkflowId+column:isread+"+mainWorkflowId+"+column:index\" text=\""+SystemEnv.getHtmlLabelName(21585,user.getLanguage())+"\" index=\"1\"/>";
					 	       //operateString+="     <operate isalwaysshow=\"true\" href=\"javascript:removeValue()\" text=\""+SystemEnv.getHtmlLabelName(91,user.getLanguage())+"\" index=\"2\"/>";
					 	       operateString+="</operates>";	
					 String tabletype="checkbox";
					String tableString=""+
					   "<table datasource=\"weaver.workflow.workflow.WorkflowTriDiffWfManager.getTriDiffWfSubWfList\" sourceparams=\"triDiffWfDiffFieldId:"+triDiffWfDiffFieldId+"\" needPage=\"false\" instanceid=\"chooseSubWorkflow\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_WORKFLOW_WORKFLOWTRIDIFFWFSUBWF,user.getUID())+"\" tabletype=\""+tabletype+"\">"+
					    " <checkboxpopedom  id=\"checkbox\" showmethod=\"weaver.general.KnowledgeTransMethod.getMailCheckbox\" />"+
					   "<sql backfields=\"*\"  sqlform=\"tmptable\" sqlorderby=\"id\"  sqlprimarykey=\"id\" sqlsortway=\"asc\"  sqldistinct=\"true\" />"+
					   operateString+
					   "<head>"+	
					   		 "<col hide=\"true\" editPlugin=\"mappingIdPlugin\" otherpara=\""+type+"\" text=\"\" column=\"triDiffWfSubWfId\"/>"+						 
							 "<col width=\"50%\" editPlugin=\"fieldValuePlugin\" transmethod=\"weaver.general.KnowledgeTransMethod.getFieldValueLabel\" otherpara=\""+type+"\" text=\""+SystemEnv.getHtmlLabelName(21595,user.getLanguage())+"\" column=\"fieldValue\"/>"+
							 "<col width=\"50%\" editPlugin=\"subWorkflowIdPlugin\" transmethod=\"weaver.general.KnowledgeTransMethod.getWorkflowName\" column=\"subWorkflowId\" text=\""+SystemEnv.getHtmlLabelName(19344,user.getLanguage())+"\"/>"+
							 "<col width=\"0%\" display=\"false\" transmethod=\"weaver.general.KnowledgeTransMethod.forHtml\" column=\"triDiffWfSubWfId\" text=\"\"/>"+
					   "</head>"+
					   "</table>";
				%>
				<wea:SplitPageTag  tableString='<%=tableString%>' isShowTopInfo="false"  mode="run"/>
				
			</wea:item>
		</wea:group>
	</wea:layout>
	<INPUT type=hidden name=rowNumTriDiffWfSubWf  id="rowNumTriDiffWfSubWf" value="<%=rowNum%>">
	<INPUT type=hidden name=pagenumTriDiffWfSubWf  id="pagenumTriDiffWfSubWf" value="<%=pagenum%>">
			
</FORM>
<%if("1".equals(dialog)){ %>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<%--<input type="button" value="<%=SystemEnv.getHtmlLabelName(32159,user.getLanguage())%>" id="zd_btn_submit_0" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('1');checkSubmit();">
		    	<span class="e8_sep_line">|</span>
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" id="zd_btn_submit" class="zd_btn_submit" onclick="jQuery('#isentrydetail').val('<%= isEntryDetail%>');checkSubmit();">
		    	<span class="e8_sep_line">|</span> --%>
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="btn_cancle()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<script type="text/javascript">
	jQuery(document).ready(function(){
		resizeDialog(document);
	});
</script>
<%} %>
</BODY>
</HTML>
<script type="text/javascript">
jQuery(function() {
	<%if (!"".equals(Util.null2String(request.getParameter("callbackvalue")))) {%>
		var callbackvalue = '<%=Util.null2String(request.getParameter("callbackvalue"))%>';
		callbackvalue = callbackvalue.split('_');
		var index = callbackvalue[0];
		var isRead = callbackvalue[1];
		if (index == -1) {
			jQuery('#subWorkflowIdDefault_a').click();
		} else {
			var triDiffWfDiffFieldId = '<%=triDiffWfDiffFieldId%>';
			var triDiffWfSubWfId = jQuery('table.ListStyle input:hidden[name="triDiffWfSubWfId_'+index+'"]').val();
			var fieldValue = jQuery('table.ListStyle input:hidden[name="fieldValue_'+index+'"]').val();
			var subWorkflowId = jQuery('table.ListStyle input:hidden[name="subWorkflowId_'+index+'"]').val();
			var mainWorkflowId = '<%=mainWorkflowId%>';
			triDiffWfSubWfFieldConfig(triDiffWfDiffFieldId, triDiffWfSubWfId, fieldValue, subWorkflowId, isRead ,mainWorkflowId, index);
		}
	<%}%>
});

function getIsReadNodesUrl(){
	var url = '/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MainSubWorkFlowNodesBrowser.jsp';
	var subWorkflowDefaultId = jQuery('#subWorkflowIdDefault').val();
	if ( !subWorkflowDefaultId ) return;
	url += ( '?wfid=' + subWorkflowDefaultId );
	
	var isReadNodes = jQuery('#isreadNodes').val();
	if ( isReadNodes == '<%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%>' || isReadNodes == '') {
		url +=  '_0_0';
	}
	else {
		url +=  ( '_0_' + isReadNodes );
	}
	return url;
}

function getIsReadMainNodesUrl(){
	var url = '/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MainSubWorkFlowNodesBrowser.jsp';
	var mainWorkflowId = '<%=mainWorkflowId%>';
	if (!mainWorkflowId) return;
	url += ( '?wfid=' + mainWorkflowId );
	
	var isreadMainWfNodes = jQuery('#isreadMainWfNodes').val();
	if ( isreadMainWfNodes == '<%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%>' || isreadMainWfNodes == '') {
		url +=  '_0_0';
	}
	else {
		url +=  ( '_0_' + isreadMainWfNodes );
	}
	return url;
}

function getIsReadParaNodesUrl(){
	var url = '/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MainSubWorkFlowNodesBrowser.jsp';
	var subWorkflowDefaultId = jQuery('#subWorkflowIdDefault').val();
	if ( !subWorkflowDefaultId ) return;
	url += ( '?wfid=' + subWorkflowDefaultId );
	
	var isreadParallelwfNodes = jQuery('#isreadParallelwfNodes').val();
	if ( isreadParallelwfNodes == '<%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%>' || isreadParallelwfNodes == '') {
		url +=  '_0_0';
	}
	else {
		url +=  ( '_0_' + isreadParallelwfNodes );
	}
	return url;
}


var all = '<span class="e8_showNameClass">'
			+ '<a onclick="return false;" href="#all"><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></a>'
			+ '<span id="all" class="e8_delClass" onclick="del(event,this,1,true,{});" style="opacity: 0; visibility: hidden;">&nbsp;x&nbsp;</span>'
		 + '</span>';
		 
function isreadChange(me){
	if(jQuery(me).attr('checked')){
		jQuery('#isreadspan').css('display','inline-block');
		jQuery('#isreadNodes').val('all');
		jQuery('#isreadNodes').next().html(all);
		
		jQuery('#isreadspan').find('.e8_showNameClass').hover(
			function(){
				jQuery(this).find('.e8_delClass').attr('style','opacity: 1; visibility: visible;');
			},
			function(){
				jQuery(this).find('.e8_delClass').attr('style','opacity: 0; visibility: hidden;');
			}
		);
	}else{
		jQuery('#isreadspan').hide();
		jQuery('#isreadNodes').val('');
		jQuery('#isreadNodes').next().html('');
	}
}

function isreadMainwfChange(me){
	if(jQuery(me).attr('checked')){
		jQuery('#isreadMainwfspan').css('display','inline-block');
		jQuery('#isreadMainWfNodes').val('all');
		jQuery('#isreadMainWfNodes').next().html(all);
		
		jQuery('#isreadMainwfspan').find('.e8_showNameClass').hover(
			function(){
				jQuery(this).find('.e8_delClass').attr('style','opacity: 1; visibility: visible;');
			},
			function(){
				jQuery(this).find('.e8_delClass').attr('style','opacity: 0; visibility: hidden;');
			}
		);
	}else{
		jQuery('#isreadMainwfspan').hide();
		jQuery('#isreadMainWfNodes').val('');
		jQuery('#isreadMainWfNodes').next().html('');
	}
}

function isreadParallelwfChange(me){
	if(jQuery(me).attr('checked')){
		jQuery('#isreadParallelwfspan').css('display','inline-block');
		jQuery('#isreadParallelwfNodes').val('all');
		jQuery('#isreadParallelwfNodes').next().html(all);
		
		jQuery('#isreadParallelwfspan').find('.e8_showNameClass').hover(
			function(){
				jQuery(this).find('.e8_delClass').attr('style','opacity: 1; visibility: visible;');
			},
			function(){
				jQuery(this).find('.e8_delClass').attr('style','opacity: 0; visibility: hidden;');
			}
		);
	}else{
		jQuery('#isreadParallelwfspan').hide();
		jQuery('#isreadParallelwfNodes').val('');
		jQuery('#isreadParallelwfNodes').next().html('');
	}
}

var _init = false;
var subWorkflowIdDefault = '';
function defaultSubWorkflowChange(){
	/*在IE下，第一次加载也会多次触发PropertyChange事件，此段代码用于防止除此加载时的触发*/
	/*********************************start**************************************/
	if( !_init ) {
		subWorkflowIdDefault =  $('#subWorkflowIdDefault').val();
		_init = true;
	}
	if(subWorkflowIdDefault == $('#subWorkflowIdDefault').val() ){
		return;
	} 
	/***********************************end************************************/
	
	jQuery('#isReadDefault').removeAttr('checked');
	jQuery('#isreadMainwf').removeAttr('checked');
	jQuery('#isreadParallelwf').removeAttr('checked');
	
	jQuery('#isReadDefault').next().attr('class', 'tzCheckBox');
	jQuery('#isreadMainwf').next().attr('class', 'tzCheckBox');
	jQuery('#isreadParallelwf').next().attr('class', 'tzCheckBox');
	
	isreadChange(jQuery('#isReadDefault'));
	isreadMainwfChange(jQuery('#isreadMainwf'));
	isreadParallelwfChange(jQuery('#isreadParallelwf'));
}

function openDialog(id){
	//diag_vote = new Dialog();
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelNames("33503",user.getLanguage())%>";
	url="/docs/tabs/DocCommonTab.jsp?dialog=1&_fromURL=63&isTriDiff=1&id="+id+"&wfid=<%=mainWorkflowId %>";
	
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 600;
	diag_vote.Height = 250;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}
	
function addNewRow(){
	jQuery(".ListStyle").addNewRow();
	jQuery(".ListStyle").jNice();
}

function deleteSelectedRow(){
	jQuery(".ListStyle").deleteSelectedRow();
}

var iTop = (window.screen.availHeight-30-550)/2+"px"; //获得窗口的垂直位置;
var iLeft = (window.screen.availWidth-10-550)/2+"px"; //获得窗口的水平位置;
function onShowWorkFlowNeededValidSingle(inputname, spanname,isMand){
	url=encode("/workflow/workflow/WorkflowBrowser.jsp?isValid=1")	
	datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url="+url,"","dialogTop="+iTop+";dialogLeft="+iLeft+";dialogHeight=550px;dialogWidth=550px;")
	if(datas){
		if(datas.id!=""){
			jQuery("#"+spanname).html("<a href='/workflow/workflow/addwf.jsp?src=editwf&isTemplate=0&wfid="+datas.id+"'>"+datas.name+"</a>");
			jQuery("#"+inputname).val(datas.id);
		}else{ 
			jQuery("#"+inputname).val("");
		    if(isMand == 1){
		    	jQuery("#"+spanname).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
		    }else{
		    	jQuery("#"+spanname).html("");
		    }
		} 
	}
}
function encode(str){
    return escape(str);
}

function onShowSubcompanySingle(inputName, spanName, isMand) {
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser2.jsp?rightStr=WorkflowManage:All+selectedids=" + inputName.value)

    if (data) {
        if (data.id != 0) {
            inputName.value = data.id;
            spanName.innerHTML = data.name;
        } else {
            inputName.value = "";
            if (isMand == 1) {
                spanName.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
            } else {
                spanName.innerHTML = "";
            }
        }
    }
}

function onShowDepartmentSingle(inputName, spanName, isMand) {
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?rightStr=WorkflowManage:All+selectedids=" + inputName.value)

     if (data) {
        if (data.id != 0) {
            inputName.value = data.id;
            spanName.innerHTML = data.name;
        } else {
            inputName.value = "";
            if (isMand == 1) {
                spanName.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
            } else {
                spanName.innerHTML = "";
            }
        }
    }
}

function onShowReceiveUnitSingle(inputName, spanName, isMand) {
    data = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/docs/sendDoc/DocReceiveUnitBrowserSingle.jsp")

    if (data) {
        if (data.id != "") {
            inputName.value = data.id;
            spanName.innerHTML = data.name;
        } else {
            inputName.value = "";
            if (isMand == 1) {
                spanName.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
            } else {
                spanName.innerHTML = "";
            }
        }
    }
}

function nextPageTriDiffWfSubWf(){//点击 下一页 连接后执行的操作
	if(document.getElementById("pagenumTriDiffWfSubWf")==null){
		return;
	}

	pagenumTriDiffWfSubWf=document.getElementById("pagenumTriDiffWfSubWf").value;
	pagenumTriDiffWfSubWf=parseInt(pagenumTriDiffWfSubWf)+1;
	document.getElementById("pagenumTriDiffWfSubWf").value=pagenumTriDiffWfSubWf;

	doSearchWorkflowTriDiffWfSubWf();
}
var diag_vote = null;

function triDiffWfSubWfFieldConfig(triDiffWfDiffFieldId, triDiffWfSubWfId, fieldValue, subWorkflowId, isRead ,mainWorkflowId, index) {
	if("" == subWorkflowId || null == subWorkflowId|| subWorkflowId == 0){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21601, user.getLanguage())%>");
		return;
	}
	var needSave = false;
	if (fieldValue == -1) {
		if (subWorkflowId != jQuery('#old_subWorkflowIdDefault').val()) {
			jQuery('#callbackvalue').val('-1_'+isRead);
			needSave = true;
		}
	} else {
		var new_subWorkflowId = jQuery('table.ListStyle input:hidden[name="subWorkflowId_'+index+'"]').val();
		if (new_subWorkflowId != subWorkflowId) {
			jQuery('#callbackvalue').val(index+'_'+isRead);
			needSave = true;
		}
	}
	if (needSave) {
		if (!onSaveWorkflowTriDiffWfSubWf()) {
			jQuery('#callbackvalue').val('');
		}
		return;
	}
	//window.location = "/workflow/workflow/WorkflowTriDiffWfSubWfField.jsp?ajax=1&triDiffWfDiffFieldId="+triDiffWfDiffFieldId+"&triDiffWfSubWfId="+triDiffWfSubWfId+"&fieldValue="+fieldValue+"&subWorkflowId="+subWorkflowId+"&isRead="+isRead+"&mainWorkflowId="+mainWorkflowId;
	var title = "";
	var url = "";
	title = "<%=SystemEnv.getHtmlLabelNames("33504",user.getLanguage())%>";
	url="/docs/tabs/DocCommonTab.jsp?dialog=1&_fromURL=66&ajax=1&triDiffWfDiffFieldId="+triDiffWfDiffFieldId+"&triDiffWfSubWfId="+triDiffWfSubWfId+"&fieldValue="+fieldValue+"&subWorkflowId="+subWorkflowId+"&isRead="+isRead+"&mainWorkflowId="+mainWorkflowId;
	
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 800;
	diag_vote.Height = 600;
	diag_vote.maxiumnable = true;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL = url;
	diag_vote.show();
}

function goWorkflowSubwfSetDetail(id,params,obj) {
	var parArr = params.split(/\+/);
	var triDiffWfDiffFieldId = parArr[0];
	var triDiffWfSubWfId = parArr[1];
	var fieldValue = parArr[2];
	var subWorkflowId = parArr[3];
	var isRead = parArr[4];
	var mainWorkflowId = parArr[5];
	var index = parArr[6];
	triDiffWfSubWfFieldConfig(triDiffWfDiffFieldId, triDiffWfSubWfId, fieldValue, subWorkflowId, isRead, mainWorkflowId, index);
}

function onSaveWorkflowTriDiffWfSubWf(obj){
	subWorkflowIdDefault=$G("subWorkflowIdDefault").value;
	if("" == subWorkflowIdDefault || null == subWorkflowIdDefault|| subWorkflowIdDefault == 0){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage())%>");
		return false;
	}
	var ret = true;
	jQuery('table.ListStyle tbody tr:has(input)').each(function() {
		var fv = jQuery(this).find('input[name^="fieldValue_"]').val();
		var sw = jQuery(this).find('input[name^="subWorkflowId"]').val();
		if (fv == '' || sw == '') {
			ret = false;
		}
	});
	if (!ret) {
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage())%>");
		return false;
	}
	if (!!obj) {
		obj.disabled=true;
	}
	formWorkflowTriDiffWfSubWf.submit();
	return true;
}

function onCancelWorkflowTriDiffWfSubWf(obj){
	window.location = "/workflow/workflow/WorkflowSubwfSet.jsp?ajax=1&wfid=<%=wfid%>";
}

function onSearchWorkflowTriDiffWfSubWf(){//点击右键 搜索 按钮后执行的操作
	if(document.getElementById("pagenumTriDiffWfSubWf")==null){
		return;
	}
	document.getElementById("pagenumTriDiffWfSubWf").value = 1;

	doSearchWorkflowTriDiffWfSubWf();
}

function doSearchWorkflowTriDiffWfSubWf(){//执行Iframe的src改变的操作
	if(document.getElementById("triDiffWfDiffFieldId")==null){
		return;
	}

	triDiffWfDiffFieldId=document.getElementById("triDiffWfDiffFieldId").value;
	
	pagenum=1;
    subCompanyId=0;
	departmentId=0;
	resourceName="";

	superiorUnitId=0;
	receiveUnitName="";

	if(document.getElementById("pagenumTriDiffWfSubWf")!=null){
		pagenum=document.getElementById("pagenumTriDiffWfSubWf").value;
	}

	if(document.getElementById("subCompanyIdTriDiffWfSubWf")!=null){
		subCompanyId=document.getElementById("subCompanyIdTriDiffWfSubWf").value;
	}
	if(document.getElementById("departmentIdTriDiffWfSubWf")!=null){
		departmentId=document.getElementById("departmentIdTriDiffWfSubWf").value;
	}
	if(document.getElementById("resourceNameTriDiffWfSubWf")!=null){
		resourceName=document.getElementById("resourceNameTriDiffWfSubWf").value;
	}
	if(document.getElementById("superiorUnitIdTriDiffWfSubWf")!=null){
		superiorUnitId=document.getElementById("superiorUnitIdTriDiffWfSubWf").value;
	}
	if(document.getElementById("receiveUnitNameTriDiffWfSubWf")!=null){
		receiveUnitName=document.getElementById("receiveUnitNameTriDiffWfSubWf").value;
	}
	document.all("iFrameWorkflowTriDiffWfSubWf").src = "iFrameWorkflowTriDiffWfSubWf.jsp?triDiffWfDiffFieldId=" + triDiffWfDiffFieldId + "&pagenum=" + pagenum + "&subCompanyId=" + subCompanyId+ "&departmentId=" + departmentId+ "&resourceName=" + encodeURIComponent(encodeURIComponent(resourceName))+ "&superiorUnitId=" + superiorUnitId+ "&receiveUnitName=" + receiveUnitName;

}
</script>
<script language="javascript" for="document" event="onkeydown">  
   var keyCode = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;   
   if (keyCode == 13) {  
   		if(document.getElementById("pagenumTriDiffWfSubWf")==null){
			return;
		}
		document.getElementById("pagenumTriDiffWfSubWf").value = 1;
	 
    	if(document.getElementById("triDiffWfDiffFieldId")==null){
			return;
		}
		triDiffWfDiffFieldId=document.getElementById("triDiffWfDiffFieldId").value;
		pagenum=1;
		subCompanyId=0;
		departmentId=0;
		resourceName="";
	
		superiorUnitId=0;
		receiveUnitName="";
		if(document.getElementById("pagenumTriDiffWfSubWf")!=null){
			pagenum=document.getElementById("pagenumTriDiffWfSubWf").value;
		}
	
		if(document.getElementById("subCompanyIdTriDiffWfSubWf")!=null){
			subCompanyId=document.getElementById("subCompanyIdTriDiffWfSubWf").value;
		}
		if(document.getElementById("departmentIdTriDiffWfSubWf")!=null){
			departmentId=document.getElementById("departmentIdTriDiffWfSubWf").value;
		}
		if(document.getElementById("resourceNameTriDiffWfSubWf")!=null){
			resourceName=document.getElementById("resourceNameTriDiffWfSubWf").value;
		}
		if(document.getElementById("superiorUnitIdTriDiffWfSubWf")!=null){
			superiorUnitId=document.getElementById("superiorUnitIdTriDiffWfSubWf").value;
		}
		if(document.getElementById("receiveUnitNameTriDiffWfSubWf")!=null){
			receiveUnitName=document.getElementById("receiveUnitNameTriDiffWfSubWf").value;
		}
		document.all("iFrameWorkflowTriDiffWfSubWf").src = "iFrameWorkflowTriDiffWfSubWf.jsp?triDiffWfDiffFieldId=" + triDiffWfDiffFieldId + "&pagenum=" + pagenum + "&subCompanyId=" + subCompanyId+ "&departmentId=" + departmentId+ "&resourceName=" + encodeURIComponent(encodeURIComponent(resourceName))+ "&superiorUnitId=" + superiorUnitId+ "&receiveUnitName=" + receiveUnitName;
	    return false;
   }   
   

</script>  
