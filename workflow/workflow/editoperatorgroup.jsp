<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.workflow.workflow.GroupDetailMatrix,weaver.workflow.workflow.GroupDetailMatrixDetail" %>
<%@page import="weaver.workflow.ruleDesign.RuleBusiness"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet4" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet11" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<jsp:useBean id="WFNodeOperatorManager" class="weaver.workflow.workflow.WFNodeOperatorManager" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="CustomerStatusComInfo" class="weaver.crm.Maint.CustomerStatusComInfo" scope="page" />
<jsp:useBean id="WFNodeMainManager" class="weaver.workflow.workflow.WFNodeMainManager" scope="page" />
<jsp:useBean id="FormFieldTransMethod" class="weaver.general.FormFieldTransMethod" scope="page" />
<jsp:useBean id="matrixUtil" class="weaver.matrix.MatrixUtil" scope="page" />
<jsp:useBean id="UserWFOperateLevel" class="weaver.workflow.workflow.UserWFOperateLevel" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="jobTitlesComInfo" class="weaver.hrm.job.JobTitlesComInfo" scope="page" />

<%
 String isclose = Util.null2String(request.getParameter("isclose"));
 String ajax=Util.null2String(request.getParameter("ajax"));
%>
<script type="text/javascript">
var insertindex = 0;
	if("<%=isclose%>" === "1")
	{
		var parentWin = parent.parent.getParentWindow(parent);
		try{
			parentWin._table.reLoad();
		}catch(e){}
		var dialog = parent.parent.getDialog(parent);
		dialog.close();
		
	}
</script>
<script language=javascript>
	var dialog = parent.parent.getDialog(parent);
	$(document).ready(function(){
  		resizeDialog(document);
  		//初始增加一行	
		addMatrixRowNew();
  		//阻止事件冒泡
  		jQuery('#addBtn,#deleteBtn').click(function(event) {
  			if (event) {
				event.stopPropagation();
			}
  		});
	});
	
	function closeCancle(){
		var dialog = parent.parent.getDialog(parent);
		dialog.close();
	}
</script>
<%WFNodeOperatorManager.resetParameter();%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<%
int design = 0;//Util.getIntValue(request.getParameter("design"),0);
String imagefilename = "";
String titlename = "";
String needfav ="";
String needhelp ="";

request.getSession(true).setAttribute("por0_con","");
request.getSession(true).setAttribute("por0_con_cn","");
int isview = Util.getIntValue(Util.null2String(request.getParameter("isview")),0);
int nodeid=Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
int wfid=Util.getIntValue(Util.null2String(request.getParameter("wfid")),0);
int formid=Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
String isbill=Util.null2String(request.getParameter("isbill"));
String iscust=Util.null2String(request.getParameter("iscust"));
int id=Util.getIntValue(Util.null2String(request.getParameter("id")),0);
String nodetype="";
char flag=2;
String sql ="" ;
if(wfid<=0 && id>0){
	sql = "select nodeid from workflow_nodegroup where id="+id;
	RecordSet.execute(sql);
	if(RecordSet.next()){
		nodeid = Util.getIntValue(RecordSet.getString("nodeid"), 0);
		sql = "select workflowid from workflow_flownode where nodeid="+nodeid;
		RecordSet.execute(sql);
		if(RecordSet.next()){
			wfid = Util.getIntValue(RecordSet.getString("workflowid"), 0);
		}
	}
}
RecordSet.executeProc("workflow_NodeType_Select",""+wfid+flag+nodeid);
if(RecordSet.next()){
	nodetype = RecordSet.getString("nodetype");
}
int iscreate = 0;
if(nodetype.equals("0")){
	iscreate = 1;
}
WFNodeOperatorManager.resetParameter();
WFNodeOperatorManager.setId(id);
WFNodeOperatorManager.selectOperatorbyID();
String groupname = Util.null2String(WFNodeOperatorManager.getName());
//已删除的跳转
if(design==1 && groupname.equals("")) response.sendRedirect("addoperatorgroup.jsp?design="+design+"&wfid="+wfid+"&nodeid="+nodeid+"&formid="+formid+"&isbill="+isbill+"&iscust="+iscust);
int canview = WFNodeOperatorManager.getCanview();

int rowsum=0;

ArrayList nodeids = new ArrayList() ;
ArrayList nodenames = new ArrayList() ;
WFNodeMainManager.setWfid(wfid);
WFNodeMainManager.selectWfNode();
while(WFNodeMainManager.next()){
	int tmpid = WFNodeMainManager.getNodeid();
	String tmpname = WFNodeMainManager.getNodename();
	nodeids.add(""+tmpid) ;
	nodenames.add(tmpname) ;
}
WFNodeMainManager.closeStatement();
sql ="" ;

////////多维组织option
String VirtualOrganization = "";
if(CompanyComInfo.getCompanyNum()>0){
	CompanyComInfo.setTofirstRow();
	while(CompanyComInfo.next()){
		VirtualOrganization +="<option value="+CompanyComInfo.getCompanyid() +">"+SystemEnv.getHtmlLabelName(83179,user.getLanguage())+"</option>";
	}
}
if(CompanyVirtualComInfo.getCompanyNum()>0){
	CompanyVirtualComInfo.setTofirstRow();
	while(CompanyVirtualComInfo.next()){
		VirtualOrganization +=" <option value="+CompanyVirtualComInfo.getCompanyid()+"> " +
					(CompanyVirtualComInfo.getVirtualType().length()>4?CompanyVirtualComInfo.getVirtualType():CompanyVirtualComInfo.getVirtualType()) +
					" </option> ";
	}
}
////////
%>
</head>
<body>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<div class="zDialog_div_content">
<script type="text/javascript">
jQuery(function(){
	  jQuery('.zDialog_div_content').css("overflow-x","auto");
})
</script>
<form id="addopform" name="addopform" method=post action="wf_operation.jsp" >
<input type="hidden" value="<%=design%>" name="design">
<%if(ajax.equals("1")){%>
<input type="hidden" name="ajax" value="1">
<%}%>
<input type="hidden" name="selectindex">
<input type="hidden" name="selectvalue">
<input type="hidden" name="nodetype_operatorgroup" value="<%=nodetype%>" >
<input type="hidden" value="<%=nodeid%>" name="nodeid">
<input type="hidden" value="<%=wfid%>" name="wfid">
<input type="hidden" value="<%=formid%>" name="formid">
<input type=hidden name=isbill value="<%=isbill%>">
<input type=hidden name=iscust value="<%=iscust%>">
<input type="hidden" value="<%=id%>" name="id">
<input type="hidden" value="editoperatorgroup" name="src">
<input type="hidden" value="0" name="groupnum">
<%if(ajax.equals("1") || design==1){%>
<input type="hidden"  name="delete_wf_id" value="<%=WFNodeOperatorManager.getId()%>" >
<%}%>
<% if(isview!=1){ %>

<%
if(!ajax.equals("1"))
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:selectall(),_self} " ;
else
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:nodeopaddsave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
if(!ajax.equals("1") && design==1) {
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+ SystemEnv.getHtmlLabelName(15072, user.getLanguage())+",javascript:nodeopdelete(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}
if(!ajax.equals("1")) {
 	if(design==1) {
 		RCMenu += "{"+SystemEnv.getHtmlLabelName(309,user.getLanguage())+",javascript:designOnClose(),_self} " ;
 	}else {
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:history.back(-1),_self} " ;
 	}
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+ SystemEnv.getHtmlLabelName(15072, user.getLanguage())+",javascript:nodeopdelete(this),_self} " ;
}
RCMenuHeight += RCMenuHeightStep;
if(ajax.equals("1")){
	if(design==1) {
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:designOnClose(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}else{
		RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:cancelEditNode(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
}
%>
<%} %>
<table id="topTitle" cellpadding="0" cellspacing="0" >
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" class="e8_btn_top"  onclick="nodeopaddsave(this);"/>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91, user.getLanguage()) + SystemEnv.getHtmlLabelName(15072, user.getLanguage())%>" class="e8_btn_top"  onclick="nodeopdelete(this);"/>
			<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table> 

<wea:layout  attributes="{'expandAllGroup':'true'}">
	<% if(isview!=1){ %>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(15545,user.getLanguage())%></wea:item>
		<wea:item>
	    	<input type=text class=Inputstyle   name="groupname" value="<%=groupname%>" size=40 maxlength="60" onchange='checkinput("groupname","groupnameimage")'>
	    	<span id="groupnameimage" style="display:none">
	    		<img src="/images/BacoError_wev8.gif" align="absMiddle">
	    	</span>	
		    <input type="hidden" name="canview" value="<%=canview %>">
		    <input type="hidden" name="iscreate" value="<%=iscreate%>">
		</wea:item>
		
		<%
			if(iscreate == 1){
		%>	
		<wea:item>
			<%=SystemEnv.getHtmlLabelName(125061,user.getLanguage()) %>


		</wea:item>
		<wea:item>
			<brow:browser viewType="0" name="workflowids" browserValue="" 
                browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowMutiBrowser.jsp?wfids=#id#" %>'
                hasInput="true" isSingle="false" hasBrowser = "true" isMustInput="1"
                completeUrl="/data.jsp?type=workflowBrowser"  temptitle='<%= SystemEnv.getHtmlLabelNames("33806",user.getLanguage())%>'
                browserSpanValue="" browserDialogWidth="600px;" width="auto">
	        </brow:browser>
	        &nbsp;<input type="checkbox" name="deleteBeforeAdd" value="true" checked style="padding-left:5px;"/>
	        <span style="padding-left:5px;"><%=SystemEnv.getHtmlLabelName(125062,user.getLanguage()) %></span>
		</wea:item>
		<%
			}
		%>
	</wea:group>
	<%} %>
	</wea:layout>
	<% if(isview!=1){ %>
<div>
<table class="LayoutTable" style="width:100%;">
			<colgroup>
				<col width="10%">
				<col width="90%">
			</colgroup>
			<tbody><tr height="30px;">
				<td >
					<span class="groupbg" style="display:block;margin-left:10px;"> </span>
					<span class="e8_grouptitle" style="display:block;color:#5b5b5b!important;"><%=SystemEnv.getHtmlLabelName(21956,user.getLanguage())%></span>
				</td>
				<td  colspan="2" style="text-align: center;">

				<table width=100% class=ListStyle cellspacing=1>
					<tr>
						<td width=11%>
							<nobr><input type=radio  name=operategroup checked value=1 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(154,user.getLanguage())%></nobr>
						</td>
						<%if(!nodetype.equals("0")){%>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=2 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15549,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=3 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15550,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=4 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15551,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=5 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15552,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=6 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15553,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=7 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=9 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15586,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(99,user.getLanguage())%></nobr>
						</td>
						<td width=11%>
							<nobr><input type=radio  name=operategroup value=10 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelNames("34066,522",user.getLanguage())%></nobr>
						</td>
						<%}%>
						<td width=11%>
							<nobr>
							<%if(iscust.equals("1")){%>
							<input type=radio  name=operategroup value=8 onclick="onChangetype(this.value)"><%=SystemEnv.getHtmlLabelName(15554,user.getLanguage())%>
							<%}%>
							</nobr>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr class="Spacing" style="height:1px;display:">
							<td class="Line" colspan="2">
		</td>
		</tr>
	</tbody>
</table>
</div>
<!--  -->
		<%} %>
	<wea:layout  attributes="{'expandAllGroup':'true'}">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<% if(isview!=1){ %>
		 	<wea:item attributes="{'isTableList':'true','colspan':'full'}">
	
		<jsp:include page="/workflow/workflow/editoperatorgroup_inner.jsp">
				<jsp:param name="nodetype" value="<%=nodetype%>" />
				<jsp:param name="ajax" value="<%=ajax%>" />
				<jsp:param name="isbill" value="<%=isbill%>" />
				<jsp:param name="formid" value="<%=formid%>" />
				<jsp:param name="VirtualOrganization" value="<%=VirtualOrganization%>" />
				<jsp:param name="design" value="<%=design%>" />
			</jsp:include>		
			<jsp:include page="/workflow/workflow/editoperatorgroupInit.jsp" flush="true">
				<jsp:param name="nodetype" value="<%=nodetype%>" />
				<jsp:param name="isbill" value="<%=isbill%>" />
				<jsp:param name="ajax" value="<%=ajax%>" />
				<jsp:param name="design" value="<%=design%>" />
				<jsp:param name="nodeids" value="<%=nodeids%>" />
			</jsp:include>		

<%-- 节点操作者 start --%>
<div id=odiv_9 style="display:none">
<wea:layout type="4col" attributes="{'cw1':'20%','cw2':'30%','cw3':'20%','cw4':'30%'}">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%>'>
		<!-- 节点操作者本人 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('40','40')" name=tmptype id='tmptype_40' value=40><%=SystemEnv.getHtmlLabelName(18676,user.getLanguage())%></wea:item>
		<wea:item>
			<select name=id_40 onfocus="changelevel(tmptype_40)" style="float:left;">
        	<%
        		for(int i=0 ; i< nodeids.size() ; i++ ) {
            		String tmpid = (String) nodeids.get(i);
            		String tmpname = (String) nodenames.get(i);
            		if(tmpid.equals(""+nodeid))
            		{
            			continue;
            		}
        	%>
            	<option value="<%=tmpid%>"><strong><%=tmpname%></strong>
        	<%}%>
    		</select>
		</wea:item>
		<wea:item><input type=text name=level_40 style="display:none"></wea:item>
		<wea:item></wea:item>
		
		<!-- 节点操作者本人 @author Dracula 2014-7-18 -->
		<wea:item><input type=radio onClick="setSelIndex('41','41')" name=tmptype id='tmptype_41' value=41 ><%=SystemEnv.getHtmlLabelName(18677,user.getLanguage())%></wea:item>
		<wea:item>
			<select name=id_41 onfocus="changelevel(tmptype_41)" style="float:left;">
       		<%
        		for(int i=0 ; i< nodeids.size() ; i++ ) {
            		String tmpid = (String) nodeids.get(i);
            		String tmpname = (String) nodenames.get(i);
            		if(tmpid.equals(""+nodeid))
            		{
            			continue;
            		}
        	%>
            	<option value="<%=tmpid%>"><strong><%=tmpname%></strong>
        	<%}%>
    		</select>
    		<%if(CompanyVirtualComInfo.getCompanyNum()>0){ %>
  				<select class=inputstyle id='id_41_1' style="float:left;">
					<%=VirtualOrganization%>
  				</select>
			<%}%>
		</wea:item>
		<wea:item><input type=text name=level_41 style="display:none"></wea:item>
		<wea:item></wea:item>
	</wea:group>
</wea:layout>
</div>
<%-- 节点操作者 end --%>


<%-- 相关负责人 start --%>
<div id=odiv_10 style="display:none;">
	<table id="" class="LayoutTable" style="display:">
		<colgroup>
			<col width="5%">
			<col width="95%">
		</colgroup>
		<tbody>
			<tr class="intervalTR" style="display:" _samepair="">
				<td colspan="2">
					<table class="LayoutTable" style="width:100%;">
						<colgroup>
							<col width="50%">
							<col width="50%">
						</colgroup>
						<tbody>
							<tr height="30px;" class="groupHeadHide">
								<td >
									<span class="groupbg" style="display:block;margin-left:10px;"></span>
									<span class="e8_grouptitle" style="display:block;color:#5b5b5b!important;"><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></span>
								</td>
								<td class="interval" style="text-align:right;" colspan="2">
									<span class="toolbar"> </span>
									<span class="hideBlockDiv" style="color: rgb(204, 204, 204);" _status="0">
										<img src="/wui/theme/ecology8/templates/default/images/2_wev8.png">
									</span>
								</td>
							</tr>
							<tr class="Spacing" style="height:1px;display:">
								<td class="Line" colspan="2"> </td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
			<tr class="Spacing" style="height:1px;display:">
				<td class="Line" colspan="2"> </td>
			</tr>
			<tr class="items intervalTR" style="display: table-row;">
				<td colspan="2">
					<table id="" class="LayoutTable" style="display:">
						<colgroup>
							<col width="6%"/>
							<col width="15%"/>
							<col width="32%"/>
							<col width="15%"/>
							<col width="32%"/>
						</colgroup>
						<tbody>
							<tr>
							<div style="display:none;">
												 <select class=inputstyle id="__max1">
												 </select>
												 <select class=inputstyle id="__max2">
												 </select>
								 </div>
								<td class="fieldName">
									<input id="matrixTmpType" type="radio" name="tmptype" value="99" onclick="setSelIndex('99','99');" />
								</td>
								<td class="fieldName"><%=SystemEnv.getHtmlLabelName(125352,user.getLanguage())%></td>
								<td class="field">
								 <input type="hidden" id="matrix" name="matrix" />
								<select  class=inputstyle style="width:160px" id="matrixTmp" name="matrixTmp" onChange="Matrix();selectShow()" style="float:left;">
		  						<%
		  						String matrixid = "";
						  	  	String name = "";
						  	  	String desc = "";
								String issystem = "";
									  	sql = "select id,name,descr,issystem from MatrixInfo " ;
								  	RecordSet.executeSql(sql);
								  	while(RecordSet.next()){
								  	     matrixid = RecordSet.getString("id");
								  	  	 name = RecordSet.getString("name");
								  	  	 desc = RecordSet.getString("desc");
										 issystem =   RecordSet.getString("issystem");
										 if("2".equals(issystem)) {
							  	%>	 
							  		<option value=<%=matrixid%> selected>
							  			<%=name%>
						  			</option>
								
							  	<% }else{  %>
									 <option value=<%=matrixid%> >
							  			<%=name%>
						  			</option>	
									<%}%>
								<%}%>
								</select>
								
									<!--<brow:browser viewType="0" name="matrix"
											browserUrl="/systeminfo/BrowserMain.jsp?url=/matrixmanage/pages/matrixbrowser.jsp"
											_callback="matrixChanged"
											hasInput="true" isSingle="true" hasBrowser="true"
											isMustInput="1" completeUrl="/data.jsp?type=matrix"></brow:browser>-->
								</td>
								<td class="fieldName"><%=SystemEnv.getHtmlLabelName(21847,user.getLanguage())%></td>
								<td class="field">
								  <input type="hidden" issingle="true" ismustinput="1" viewtype="0" onpropertychange="" temptitle="" name="vf" id="vf">
								<select  style="width:160px" class=inputstyle id="matrixTmpfield" name="matrixTmpfield"  onChange="selectShow()" style="float:left;">

							  		<option  value="0">
						  			</option>
								</select>
									<!--<brow:browser viewType="0" name="vf"
											getBrowserUrlFn="getMatrixBrowserUrl"
											getBrowserUrlFnParams="1"
											hasInput="true" isSingle="true" hasBrowser="true"
											isMustInput="1" completeUrl="javascript:getMatrixDataUrl(1);"></brow:browser>-->
								
								</td>
							</tr>
							<tr>
								<td colspan="5">
									<table id="matrixTable" class=ListStyle border=0 cellspacing=1>
										<colgroup>
											<col width="5%"/>
											<col width="40%"/>
											<col width="40%"/>
											<col width="15%"/>
										</colgroup>
										<tr class=header>
											<td style="padding-left: 30px !important;" NOWRAP><input type=checkbox onclick="selectAllMatrixRow(this.checked);"></td>
											<td NOWRAP><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(33331,user.getLanguage())%></td>
											<td NOWRAP><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%></td>
											<td style="text-align:right;" NOWRAP>
												<button type=button  Class=addbtn type=button onclick="addMatrixRowNew();" title="<%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%>"></button>
												<button type=button  Class=delbtn type=button onclick="removeMatrixRow();" title="<%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%>"></button>
											</td>
										</tr>
									</table>
								</td>
							</tr>
						</tbody>
					</table>
				</td>
			</tr>
		</tbody>
	</table>
</div>
<%-- 相关负责人 end --%>
<%-- 会签属性 start --%>
<%if (!nodetype.equals("0")) {%>
<div id="signordertr"  >
		<table class="LayoutTable" style="width:100%;">
			<colgroup>
				<col width="10%">
				<col width="90%">
			</colgroup>
			<tbody><tr height="30px;">
				<td >
					<span class="groupbg" style="display:block;margin-left:10px;"> </span>
					<span class="e8_grouptitle" style="display:block;color:#5b5b5b!important;"><%=SystemEnv.getHtmlLabelName(125351,user.getLanguage()) %></span>
				</td>
				<td  colspan="2" style="text-align: center;">

				<table width="80%" class="ListStyle">
					<tr >
						<td ><input type=radio name=signorder value="0" onclick="hideOrganizer(this)"><%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>
							</td>
						<td>
							<input type=radio name=signorder value="1" onclick="hideOrganizer(this)" checked><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>
						</td>
						<td>
							<input type=radio name=signorder value="2" onclick="hideOrganizer(this)"><%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>
						</td>
						<td>
							<input type=radio name=signorder value="3" onclick="hideOrganizer(this)"><%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>
						</td>
						<td>
							<input type=radio name=signorder value="4" onclick="hideOrganizer(this)"><%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>
						</td>
				</tr>
				</table>
		</td>
	</tr>
	<tr class="Spacing" style="height:1px;display:">
						<td class="Line" colspan="2">
	</td>
	</tr>
</tbody>
</table>

</div>

<!--  -->
<%-- 会签属性 end --%>

<%-- 批次、条件 start --%>
<div>
	<wea:layout type="4col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(17892,user.getLanguage()) + "/" +SystemEnv.getHtmlLabelName(15364,user.getLanguage())%>'>
			<wea:item><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></wea:item>
			<wea:item>
				<%if(!ajax.equals("1")){%>
	    	  		<button type=button  class=Browser1 onclick="onShowBrowser4s('<%=wfid%>','<%=formid%>','<%=isbill%>')"></button>
	    	  	<%}else {%>
	    	  		<button type=button name="condtionBtn" class=Browser1 onclick="onShowBrowsers(this,'0','<%=nodeid %>','<%=formid%>','<%=isbill%>','<%=wfid%>')"></button>
	    	  	<%}%>
	    	  	<input type=hidden name=fromsrc id=fromsrc value="2">
	    	  	<input type=hidden name=conditionss id=conditionss>
	    	  	<input type=hidden name=ruleRelationship id=ruleRelationship>
	    	  	<input type=hidden name=conditioncn id=conditioncn>
	    	  	<input type=hidden name=rulemaplistids id=rulemaplistids>
			  	<span id="conditions">
			  
			   	</span>
			</wea:item>
			<wea:item><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%></wea:item>
			<wea:item><input type=text class=Inputstyle name=orders  onchange="check_number('orders');checkDigit(this,5,2)"  maxlength="5"></wea:item>
			
			<wea:item attributes="{\"samePair\":\"Tab_Coadjutant\",\"display\":\"none\"}"><%=SystemEnv.getHtmlLabelName(22675,user.getLanguage())%></wea:item>
			<wea:item attributes="{\"cols\":\"3\",\"samePair\":\"Tab_Coadjutant\",\"display\":\"none\"}">
				<div style="float:left;display:block;">
              		<button type=button  class=Browser1 onclick="onShowCoadjutantBrowser()"></button>
              	</div>
              	<div style="float:left;display:block;padding-left:5px;">
              		<span id="Coadjutantconditionspan"></span>
              	</div>
				<input type=hidden name=IsCoadjutant id=IsCoadjutant>
				<input type=hidden name=signtype id=signtype>
				<input type=hidden name=issyscoadjutant id=issyscoadjutant>
				<input type=hidden name=coadjutants id=coadjutants>
				<input type=hidden name=coadjutantnames id=coadjutantnames>
				<input type=hidden name=issubmitdesc id=issubmitdesc>
				<input type=hidden name=ispending id=ispending>
				<input type=hidden name=isforward id=isforward>
				<input type=hidden name=ismodify id=ismodify>
				<input type=hidden name=Coadjutantconditions id=Coadjutantconditions>
			</wea:item>
			
		</wea:group>
	</wea:layout>
</div>
<%-- 批次、条件 end --%>
<%--
	<table class="viewform" id="Tab_Coadjutant" name="Tab_Coadjutant" width="100%" style="display:none">
		<input type=hidden name=IsCoadjutant id=IsCoadjutant>
		<input type=hidden name=signtype id=signtype>
		<input type=hidden name=issyscoadjutant id=issyscoadjutant>
		<input type=hidden name=coadjutants id=coadjutants>
		<input type=hidden name=coadjutantnames id=coadjutantnames>
		<input type=hidden name=issubmitdesc id=issubmitdesc>
		<input type=hidden name=ispending id=ispending>
		<input type=hidden name=isforward id=isforward>
		<input type=hidden name=ismodify id=ismodify>
		<input type=hidden name=Coadjutantconditions id=Coadjutantconditions>
      	<COLGROUP>	
  			<COL width="15%">
  			<COL width="45%">
  			<COL width="20%">
  			<COL width="20%">
  		</COLGROUP>
   	  	<tr>
   	  		<td style="padding-left:30px;"><span style="display:inline-block;"><%=SystemEnv.getHtmlLabelName(22675,user.getLanguage())%></span></td>
    	  	<td colSpan=3 class="field" style="padding-left:2px;">
    	  		<div style="float:left;display:block;">
              		<button type=button  class=Browser1 onclick="onShowCoadjutantBrowser()"></button>
              	</div>
              	<div style="float:left;display:block;">
              		<span id="Coadjutantconditionspan"></span>
              	</div>
    	  	</td>
		</tr>
	</table>
	 --%>
<%}
else {%>
<input type=hidden name=fromsrc id=fromsrc value="2">
<input type=hidden name=conditionss id=conditionss>
<input type=hidden name=conditioncn id=conditioncn>
<span id="conditions">
</span>
<input type=hidden name=orders  value=0>
<table class="viewform" id="Tab_Coadjutant" name="Tab_Coadjutant" style="display:none">
     <input type=hidden name=IsCoadjutant id=IsCoadjutant>
     <input type=hidden name=signtype id=signtype>
     <input type=hidden name=issyscoadjutant id=issyscoadjutant>
     <input type=hidden name=coadjutants id=coadjutants>
     <input type=hidden name=coadjutantnames id=coadjutantnames>
     <input type=hidden name=issubmitdesc id=issubmitdesc>
     <input type=hidden name=ispending id=ispending>
     <input type=hidden name=isforward id=isforward>
     <input type=hidden name=ismodify id=ismodify>
     <input type=hidden name=Coadjutantconditions id=Coadjutantconditions>
     <COLGROUP>
         <COL width="20%">
         <COL width="40%">
         <COL width="40%">
         <tr>
             <td colSpan=3 style="padding-left:30px;"><%=SystemEnv.getHtmlLabelName(22675, user.getLanguage())%>
                 <button type=button  class=Browser onclick="onShowCoadjutantBrowser()"></button>
                 <span id="Coadjutantconditionspan"></span>
             </td>

         </tr>
 </table> 
<%}%>					 
		</wea:item>
		<%} %>
		<wea:item attributes="{'isTableList':'true'}">
			<%
			String _tableAttr = "";
			if(!ajax.equals("1")){
				_tableAttr = "{'cols':'7','cws':'5%,15%,15%,15%,10%,30%,10%','formTableId':'oTable'}";
			}else{
				_tableAttr = "{'cols':'7','cws':'5%,15%,15%,15%,10%,30%,10%','formTableId':'oTable4op'}";
			}
			%>
			<%
				String oldids="-1";
				int singerorder_flag=0;
				String singerorder_type = "";
				int singerorder_level = -1;
			%>
			<wea:layout type="table" attributes='<%=_tableAttr %>'>
				<wea:group context='<%=SystemEnv.getHtmlLabelName(99,user.getLanguage()) %>'>
					<wea:item type="thead"><input type=checkbox name=checkall onclick="checkAllChkBox();" ></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(63,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(195,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(713,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%>/<%=SystemEnv.getHtmlLabelName(22671,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></wea:item>
					<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(17892,user.getLanguage())%></wea:item>
					<wea:item type="groupHead">
					<% if(isview!=1){ %>
					<%if(!ajax.equals("1")){%>
						<button type=button id="addBtn" Class=addbtn type=button accessKey=A onclick="addRow();" title="A-<%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%>"></BUTTON>
						<button type=button id="deleteBtn" Class=delbtn type=button accessKey=D onclick="if(isdel()){deleteRow();}" title="D-<%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%>"></BUTTON></div>
					<%}else{ %>	
						<button type=button id="addBtn" Class=addbtn type=button accessKey=A onclick="addRow4op();" title="A-<%=SystemEnv.getHtmlLabelName(15582,user.getLanguage())%>"></BUTTON>
						<button type=button id="deleteBtn" Class=delbtn type=button accessKey=D onclick="deleteRow4op();" title="D-<%=SystemEnv.getHtmlLabelName(15583,user.getLanguage())%>"></BUTTON></div>
					<%} %>
					<%} %>
					</wea:item>	
			<%
				sql ="" ;

				ArrayList ids = new ArrayList();
				ArrayList names = new ArrayList();
				ids.clear();
				names.clear();
				
				if(isbill.equals("0")){
			  		sql = "select * from (";
				  	sql += " select workflow_formdict.id as id,workflow_fieldlable.fieldlable as name,0 viewtype,0 groupid from workflow_formdict,workflow_formfield,workflow_fieldlable where  workflow_fieldlable.isdefault=1 and workflow_fieldlable.formid = workflow_formfield.formid and workflow_fieldlable.fieldid = workflow_formfield.fieldid and  workflow_formfield.fieldid= workflow_formdict.id and (workflow_formfield.isdetail<>'1' or workflow_formfield.isdetail is null) and workflow_formfield.formid="+formid;      // 包括多人力资源字段
					sql += " union all ";
					sql += " SELECT workflow_formdictdetail.id AS id,workflow_fieldlable.fieldlable AS name,1 viewtype,workflow_formfield.groupId + 1 FROM workflow_formdictdetail,workflow_formfield,workflow_fieldlable WHERE workflow_fieldlable.isdefault = 1 AND workflow_fieldlable.formid = workflow_formfield.formid AND workflow_fieldlable.fieldid = workflow_formfield.fieldid AND workflow_formfield.fieldid = workflow_formdictdetail.id AND workflow_formfield.isdetail = '1' AND workflow_formfield.formid = " + formid;
					sql += " )t order by viewtype asc,groupid asc,id asc";
			  	}else{
				  	sql = "select * from (";
				  	sql += " select id as id , fieldlabel as name,0 viewtype,0 groupid from workflow_billfield where billid="+ formid+ "  and viewtype = 0";
				  	sql += " union all";
				  	sql += " select a.id, fieldlabel as name,1 viewtype,b.orderid groupid from workflow_billfield a,Workflow_billdetailtable b where a.billid = b.billid and a.detailtable = b.tablename and a.billid="+ formid+ " and viewtype = 1";
				  	sql += " )t order by viewtype asc,groupid asc,id asc";
			  	}

				RecordSet.executeSql(sql);
				while(RecordSet.next()){
					String viewtype = RecordSet.getString("viewtype");
			  		String groupid = RecordSet.getString("groupid");
			  		String name = "";
			  		if(isbill.equals("0")) 
			  			name = RecordSet.getString("name");
			  		else
			  			name = SystemEnv.getHtmlLabelName(Util.getIntValue(RecordSet.getString("name")),user.getLanguage());
			  		if("1".equals(viewtype))
			  			name += "（" + SystemEnv.getHtmlLabelName(17463,user.getLanguage()) + groupid + "）";
					
			  		ids.add(RecordSet.getString("id"));
				    names.add(name);
				}

				//the record in db
				int colorcount=0;
				RecordSet.executeProc("workflow_groupdetail_SByGroup",""+id);
				while(RecordSet.next()){
					int detailid = RecordSet.getInt("id");
					int type = RecordSet.getInt("type");
					int objid = RecordSet.getInt("objid");
					int level = RecordSet.getInt("level_n");
					int level2 = RecordSet.getInt("level2_n");
					String virtualid = Util.null2String(RecordSet.getString("virtualid"));
					if("undefined".equals(virtualid))
						virtualid = "";
					String ruleRelationship = Util.null2String(RecordSet.getString("ruleRelationship"));
					String deptField = RecordSet.getString("deptField");
					String subcompanyField = RecordSet.getString("subcompanyField");
					String signorder = RecordSet.getString("signorder");
					String jobfield = RecordSet.getString("jobfield");
					String jobobj = RecordSet.getString("jobobj");
					
					  //让历史数据属性状态显示为非会签
					if(signorder.equals("")&&(type==30||type==1||type==2||type==3||type==4)&&!nodetype.equals("0")){
						signorder="0";
					}
					int bhxj = Util.getIntValue(RecordSet.getString("bhxj"),0);
					//==========一般类型：人力资源改造start===
					String hrmobjid ="";	
					if(type==3){
						RecordSet4.executeSql("select objid from Workflow_HrmOperator where groupdetailid='"+detailid+"'  order by orders asc ");	
						while(RecordSet4.next()){
							if(hrmobjid.equals("")){
								hrmobjid =Util.null2String(RecordSet4.getString("objid"));
							}else{
								hrmobjid +=","+Util.null2String(RecordSet4.getString("objid"));
							}
						}
					}
					
					//==========一般类型：人力资源改造end===
						
						
					String subcompanyids = Util.null2String(RecordSet.getString("subcompanyids"));
					ArrayList subcompanyidlist=Util.TokenizerString(subcompanyids,",");
					String showname="";
					if(signorder.equals("2")){
	    				singerorder_flag++;
	    				singerorder_level = level;
	    				if("".equals(singerorder_type)){
	    					singerorder_type = ""+type;
	    				}
	    				for(int i=0;i<subcompanyidlist.size();i++){
				        if(showname.equals("")){
				            if(type==1) showname=DepartmentComInfo.getDepartmentname((String)subcompanyidlist.get(i));
				            if(type==30) showname=SubCompanyComInfo.getSubCompanyname((String)subcompanyidlist.get(i));
			            }else{
			                if(type==1) showname+=","+DepartmentComInfo.getDepartmentname((String)subcompanyidlist.get(i));
				            if(type==30) showname+=","+SubCompanyComInfo.getSubCompanyname((String)subcompanyidlist.get(i));
			            }
			        }
				    }else{
				       if(type==1) showname=DepartmentComInfo.getDepartmentname(""+objid);
					   if(type==30) showname=SubCompanyComInfo.getSubCompanyname(""+objid);
				    }

				    String showcondition="";
				    String conditions=RecordSet.getString("conditions");
				    //String conditioncn=Util.null2String(RecordSet.getString("conditioncn"));
				    String conditioncn=RuleBusiness.getConditionCn(detailid, 2, user);
				    //System.out.println(conditioncn);
				    //System.out.println(Util.null2String(RecordSet.getString("conditioncn")));
				    
				    String orders=RecordSet.getString("orders");
				    if(!conditioncn.trim().equals("")){
				        showcondition=SystemEnv.getHtmlLabelName(17892,user.getLanguage())+SystemEnv.getHtmlLabelName(15364,user.getLanguage())+":"+conditioncn;
				    }
    				String IsCoadjutant=Util.null2String(RecordSet.getString("IsCoadjutant"));
			        String signtype=Util.null2String(RecordSet.getString("signtype"));
					String issyscoadjutant=Util.null2String(RecordSet.getString("issyscoadjutant"));
			        String coadjutants=Util.null2String(RecordSet.getString("coadjutants"));
			        String issubmitdesc=Util.null2String(RecordSet.getString("issubmitdesc"));
					String ispending=Util.null2String(RecordSet.getString("ispending"));
			        String isforward=Util.null2String(RecordSet.getString("isforward"));
			        String ismodify=Util.null2String(RecordSet.getString("ismodify"));
					String Coadjutantconditions=Util.null2String(RecordSet.getString("coadjutantcn"));
					if(!Coadjutantconditions.trim().equals("")){
					    if(!showcondition.trim().equals("")){
					        showcondition+="<br>";
			            }
			            showcondition+=SystemEnv.getHtmlLabelName(22675,user.getLanguage())+":"+Coadjutantconditions;
			        }
					//System.out.println("detailid = " + detailid + " orders = " + orders);
    				if(signorder.equals("3")||signorder.equals("4")) orders="";
					oldids=oldids+","+detailid;
					
					
					//==========一般类型：人力资源改造start===
					String objIdStr ="";
					if(type==3){
						objIdStr=hrmobjid;
					}else{
					  objIdStr = String.valueOf(objid);
					}
					//==============end by zt================
						 
						
					//处理相关责任人矩阵

					GroupDetailMatrix matrix = null;
					if (type == 99) {
						matrix = GroupDetailMatrix.read(RecordSet1, String.valueOf(detailid));
						if (matrix != null) {
							List<GroupDetailMatrixDetail> matrixDetails = GroupDetailMatrixDetail.readAll(RecordSet1, String.valueOf(detailid));
							StringBuilder sb = new StringBuilder();
							sb.append(matrix.getMatrix()).append(",").append(matrix.getValue_field());
							for (GroupDetailMatrixDetail matrixDetail : matrixDetails) {
								sb.append(",").append(matrixDetail.getCondition_field()).append(":").append(matrixDetail.getWorkflow_field());
							}
							objIdStr = sb.toString();
						} else {
						    continue;
						}
					}
					%>
					<wea:item>
	    				<%if(!ajax.equals("1")){%>
							<input type='checkbox' name='check_node' value="<%=detailid%>"  belongtype="<%=signorder%>">
	    				<%}else{%>
							<input type='checkbox' name='check_node' value="<%=detailid%>" rowindex="<%=rowsum%>" belongtype="<%=signorder%>">
	    				<%}%>
							<input type="hidden" name="group_<%=rowsum%>_type" size=25 value="<%=type%>">
							<input type="hidden" name="group_<%=rowsum%>_virtual" size=25 value="<%=virtualid%>">
							<input type="hidden" name="group_<%=rowsum%>_ruleRelationship" size=25 value="<%=ruleRelationship%>">
							<input type="hidden" name="group_<%=rowsum%>_id" size=25 value="<%=objIdStr%>">
							<input type="hidden" name="group_<%=rowsum%>_subcompanyids" size=25 value="<%=subcompanyids%>">        
							<input type="hidden" name="group_<%=rowsum%>_level" size=25 value="<%=level%>">
							<input type="hidden" name="group_<%=rowsum%>_level2" size=25 value="<%=level2%>">
							<input type="hidden" name="group_<%=rowsum%>_deptField" size=25 value="<%=deptField%>">
							<input type="hidden" name="group_<%=rowsum%>_subcompanyField" size=25 value="<%=subcompanyField%>">
							
							<input type="hidden" name="group_<%=rowsum%>_signorder" size=25 value="<%=signorder%>">
							<input type="hidden" name="group_<%=rowsum%>_condition" size=25 value="<%=conditions%>">
							<input type="hidden" name="group_<%=rowsum%>_conditioncn" size=25 value="<%=conditioncn%>">
							<%if (!nodetype.equals("0")){%>
							<input type="hidden" name="group_<%=rowsum%>_orderold" size=25 value="<%=orders%>">
							<%}else{%>
							<input type="hidden" name="group_<%=rowsum%>_orderold" size=25 value="0">
							<%}%>
							<input type="hidden" name="group_<%=rowsum%>_oldid" size=25 value="<%=detailid%>">
							<input type='hidden' name='group_<%=rowsum%>_Coadjutantconditions' value='<%=Coadjutantconditions%>'>
							<input type='hidden' name='group_<%=rowsum%>_IsCoadjutant' value='<%=IsCoadjutant%>'>
							<input type='hidden' name='group_<%=rowsum%>_signtype' value='<%=signtype%>'>
							<input type='hidden' name='group_<%=rowsum%>_issyscoadjutant' value='<%=issyscoadjutant%>'>
							<input type='hidden' name='group_<%=rowsum%>_coadjutants' value='<%=coadjutants%>'>
							<input type='hidden' name='group_<%=rowsum%>_issubmitdesc' value='<%=issubmitdesc%>'>
							<input type='hidden' name='group_<%=rowsum%>_ispending' value='<%=ispending%>'>
							<input type='hidden' name='group_<%=rowsum%>_isforward' value='<%=isforward%>'>
							<input type='hidden' name='group_<%=rowsum%>_ismodify' value='<%=ismodify%>'>      
						    <input type='hidden' name='group_<%=rowsum%>_bhxj' value='<%=bhxj%>'>  
						    <input type='hidden' name='group_<%=rowsum%>_jobfield' value='<%=jobfield%>'>  
						    <input type='hidden' name='group_<%=rowsum%>_jobobj' value='<%=jobobj%>'>  
					</wea:item>
					<wea:item>
						<%
							String belongtypeStr = "";
							if(nodetype.equals("0") && !signorder.equals("-1")){
								if(type==30 || type==1 || type==58){//分部、部门、岗位


									if(signorder.equals("1")){
										belongtypeStr = " (" + SystemEnv.getHtmlLabelName(353,user.getLanguage()) + ")";
									}else if(signorder.equals("2")){
										belongtypeStr = " (" + SystemEnv.getHtmlLabelName(21473,user.getLanguage()) + ")";
									}
								}else if(type==2){//角色
									if(signorder.equals("1")){
										belongtypeStr = " (" + SystemEnv.getHtmlLabelName(346,user.getLanguage()) + ")";
									}else if(signorder.equals("2")){
										belongtypeStr = " (" + SystemEnv.getHtmlLabelName(15507,user.getLanguage()) + ")";
									}
								}
							}
							String virtualname = "";
							if(!"".equals(virtualid)){
								if("1".equals(virtualid)){
									virtualname = SystemEnv.getHtmlLabelName(83179,user.getLanguage());
								}else{
									virtualname = CompanyVirtualComInfo.getVirtualType(virtualid);
								}
							}
							
							if(type==1)
							{%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())+belongtypeStr%><%}
							if(type==2)
								{%><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())+belongtypeStr%> <%}
							if(type==3)
								{%><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%> <%}
							if(type==4)
								{%><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%> <%}
							if(type==5)
								{%><%=SystemEnv.getHtmlLabelName(15555,user.getLanguage())%> <%}
							if(type==6)
								{%><%=SystemEnv.getHtmlLabelName(15559,user.getLanguage())%> <%}
							if(type==7)
								{%><%=SystemEnv.getHtmlLabelName(15562,user.getLanguage())%> <%}
							if(type==8)
								{%><%=SystemEnv.getHtmlLabelName(15564,user.getLanguage())%> <%}
							if(type==9)
								{%><%=SystemEnv.getHtmlLabelName(15566,user.getLanguage())%> <%}
							if(type==10)
								{%><%=SystemEnv.getHtmlLabelName(15567,user.getLanguage())%> <%}
							if(type==11)
								{%><%=SystemEnv.getHtmlLabelName(15569,user.getLanguage())%> <%}
							if(type==12)
								{%><%=SystemEnv.getHtmlLabelName(15570,user.getLanguage())%> <%}
							if(type==13)
								{%><%=SystemEnv.getHtmlLabelName(15571,user.getLanguage())%> <%}
							if(type==14)
								{%><%=SystemEnv.getHtmlLabelName(15573,user.getLanguage())%> <%}
							if(type==15)
								{%><%=SystemEnv.getHtmlLabelName(15574,user.getLanguage())%> <%}
							if(type==16)
								{%><%=SystemEnv.getHtmlLabelName(15575,user.getLanguage())%> <%}
							if(type==17)
								{%><%=SystemEnv.getHtmlLabelName(15079,user.getLanguage())%> <%}
							if(type==18)
								{%><%=SystemEnv.getHtmlLabelName(15080,user.getLanguage())+(virtualname==""?virtualname:"("+virtualname+")")%> <%}
							if(type==19)
								{%><%=SystemEnv.getHtmlLabelName(15081,user.getLanguage())+(virtualname==""?virtualname:"("+virtualname+")")%> <%}
							if(type==20)
								{%><%=SystemEnv.getHtmlLabelName(1282,user.getLanguage())%> <%}
							if(type==21)
								{%><%=SystemEnv.getHtmlLabelName(15078,user.getLanguage())%> <%}
							if(type==22)
								{%><%=SystemEnv.getHtmlLabelName(15579,user.getLanguage())%> <%}
							if(type==23)
								{%><%=SystemEnv.getHtmlLabelName(1278,user.getLanguage())%> <%}
							if(type==24)
								{%><%=SystemEnv.getHtmlLabelName(15580,user.getLanguage())%> <%}
							if(type==25)
								{%><%=SystemEnv.getHtmlLabelName(15581,user.getLanguage())%> <%}
							if(type==30)
							{%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())+belongtypeStr%> <%}
							if(type==31)
								{%><%=SystemEnv.getHtmlLabelName(15560,user.getLanguage())%> <%}
							if(type==32)
								{%><%=SystemEnv.getHtmlLabelName(15561,user.getLanguage())%> <%}
							if(type==33)
								{%><%=SystemEnv.getHtmlLabelName(15565,user.getLanguage())%> <%}
							if(type==34)
								{%><%=SystemEnv.getHtmlLabelName(15568,user.getLanguage())%> <%}
							if(type==35)
								{%><%=SystemEnv.getHtmlLabelName(15572,user.getLanguage())%> <%}
							if(type==36)
								{%><%=SystemEnv.getHtmlLabelName(15576,user.getLanguage())+(virtualname==""?virtualname:"("+virtualname+")")%> <%}
							if(type==37)
								{%><%=SystemEnv.getHtmlLabelName(15577,user.getLanguage())+(virtualname==""?virtualname:"("+virtualname+")")%> <%}
							if(type==38)
								{%><%=SystemEnv.getHtmlLabelName(15563,user.getLanguage())%> <%}
							if(type==39)
								{%><%=SystemEnv.getHtmlLabelName(15578,user.getLanguage())+(virtualname==""?virtualname:"("+virtualname+")")%> <%}
							if(type==40)
								{%><%=SystemEnv.getHtmlLabelName(18676,user.getLanguage())%> <%}
							if(type==41)
								{%><%=SystemEnv.getHtmlLabelName(18677,user.getLanguage())%> <%}
							if(type==42)
								{%><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%> <%}
							if(type==43)
								{%><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%> <%}
							if(type==44)
								{%><%=SystemEnv.getHtmlLabelName(17204,user.getLanguage())%> <%}
							if(type==45)
								{%><%=SystemEnv.getHtmlLabelName(18678,user.getLanguage())%> <%}
							if(type==46)
								{%><%=SystemEnv.getHtmlLabelName(18679,user.getLanguage())%><%}
							if(type==47)
								{%><%=SystemEnv.getHtmlLabelName(18680,user.getLanguage())%> <%}
							if(type==48)
								{%><%=SystemEnv.getHtmlLabelName(18681,user.getLanguage())%> <%}
							if(type==49)
								{%><%=SystemEnv.getHtmlLabelName(19309,user.getLanguage())%> <%}
							if(type==50)
								{%><%=SystemEnv.getHtmlLabelName(20570,user.getLanguage())%> <%}
							if(type==51)
								{%><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%> <%}
							if(type==52)
								{%><%=SystemEnv.getHtmlLabelName(27107,user.getLanguage())%> <%}
							if(type==53)
								{%><%=SystemEnv.getHtmlLabelName(27108,user.getLanguage())%> <%}
							if(type==54)
								{%><%=SystemEnv.getHtmlLabelName(27109,user.getLanguage())%> <%}
							if(type==55)
								{%><%=SystemEnv.getHtmlLabelName(27110,user.getLanguage())%> <%}
							if(type==56)
								{%><%=SystemEnv.getHtmlLabelName(26592,user.getLanguage())%> <%}
							if(type==57)
								{%><%=SystemEnv.getHtmlLabelName(28442,user.getLanguage())%> <%}
							if(type==58)
								{%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())+belongtypeStr%> <%}
							if(type==59)
								{%><%=SystemEnv.getHtmlLabelName(15549,user.getLanguage())+SystemEnv.getHtmlLabelName(6086,user.getLanguage())%> <%}
							if(type==60)
								{%><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%> <%}
							if(type==61)
								{%><%=SystemEnv.getHtmlLabelName(126610,user.getLanguage())%> <%}
							if (type == 99)
								{%><%=SystemEnv.getHtmlLabelNames("34066,522",user.getLanguage())%><%}
						%>
					</wea:item>
					
					<wea:item>
						<%
							switch (type){
								case 1:
								case 22:
						%>
							<%="<a href='/hrm/company/HrmDepartmentDsp.jsp?id="+objid+"' target='_blank'>"+DepartmentComInfo.getDepartmentname(""+objid)+"</a>"%>
						<%
						if(bhxj == 1){
							%>
								<br/>[<%=SystemEnv.getHtmlLabelName(125943 ,user.getLanguage())%>]
							<%
						}
						
						
							break;
							case 2:
								RecordSet1.executeSql("select rolesmark from hrmroles where id = "+objid);
								RecordSet1.next();
						%>
							<%=RecordSet1.getString(1)%>
						<%
							break;
							case 3:		
									String viewlastname="";
							 		//人力资源缓存 不好使，部分人员根据id获取不到。本次先查询一下，后续缓存类好使了在缓存缓存获取
									RecordSet4.executeSql("select objid from Workflow_HrmOperator h where h.groupdetailid='"+detailid+"'  order by h.orders asc  ");	
									while(RecordSet4.next()){
							
									 String uid=Util.null2String(RecordSet4.getString("objid"));
									  String lastname=ResourceComInfo.getResourcename(uid) ;
									  if(viewlastname.equals("")){
										  viewlastname="<a href='/hrm/resource/HrmResource.jsp?id="+uid+"' target='_blank'>"+lastname+"</a>";
									  }else{
										  viewlastname+=",<a href='/hrm/resource/HrmResource.jsp?id="+uid+"' target='_blank'>"+lastname+"</a>";
									  }
									}
						%>
							<%=viewlastname%>
						<%
								 
							break;
							case 5:
							case 49:
							case 6:
							case 7:
							case 8:
							case 9:
							case 10:
							case 11:
							case 12:
							case 13:
							case 14:
							case 15:
							case 16:
							case 23:
							case 24:
							case 31:
							case 32:
							case 33:
							case 34:
							case 35:
							case 38:
							case 42:
							case 52:
							case 53:
							case 54:
							case 55:
							case 56:
							case 57:
							case 43:
							case 44:
							case 45:
							case 46:
							case 47:
							case 48:
							case 51:
							case 59:
							case 60:
								String virtualname = "";
								if(!"".equals(virtualid)){
									if("1".equals(virtualid)){
										virtualname = SystemEnv.getHtmlLabelName(83179,user.getLanguage());
									}else{
										virtualname = CompanyVirtualComInfo.getVirtualType(virtualid);
									}
								}
								int index=ids.indexOf(""+objid);
								if(index!=-1){
							%>
							<%=names.get(index)+(virtualname==""?virtualname:"("+virtualname+")")%>
							<%	}
							break;
							case 20:
							%>
							<%=Util.toScreen(CustomerTypeComInfo.getCustomerTypename(""+objid),user.getLanguage())%>
							<%
							break;
							case 21:
							%>
							<%=Util.toScreen(CustomerStatusComInfo.getCustomerStatusname(""+objid),user.getLanguage())%>
							<%
							break;
							case 30:
							%>
							<%="<a href='/hrm/company/HrmSubCompanyDsp.jsp?id="+objid+"' target='_blank'>"+SubCompanyComInfo.getSubCompanyname(""+objid)+"</a>"%>
							<%
							if(bhxj == 1){
								%>
									<br/>[<%=SystemEnv.getHtmlLabelName(84674 ,user.getLanguage())%>]
								<%
							}
							break;
							case 40:
							case 41:
							    String nodename = "" ;
							    int nodeidindex = nodeids.indexOf(""+objid) ;
							    if( nodeidindex != -1 ) nodename = (String) nodenames.get(nodeidindex) ;
							    String nodevirtualname = "";
								if(!"".equals(virtualid)){
									if("1".equals(virtualid)){
										nodevirtualname = SystemEnv.getHtmlLabelName(83179,user.getLanguage());
									}else{
										nodevirtualname = CompanyVirtualComInfo.getVirtualType(virtualid);
									}
								}
							%>
							<%=nodename+(nodevirtualname==""?nodevirtualname:"("+nodevirtualname+")")%>
							<%
							break;
							case 50:
							int indexs=ids.indexOf(""+objid);
							//System.out.print(indexs);
							if(indexs!=-1){
							%>
							<%=names.get(indexs)%>/<%}%><%=RolesComInfo.getRolesRemark(""+level)%>
								<%
							break;
							case 58:
								String jobtitlenames = "";
								ArrayList<String> jobobjlist = Util.TokenizerString(jobobj,",");
			    				for(int n=0;n<jobobjlist.size();n++){
			    					if("".equals(jobtitlenames)){
										jobtitlenames = jobTitlesComInfo.getJobTitlesname(jobobjlist.get(n));
									}else{
										jobtitlenames += ","+jobTitlesComInfo.getJobTitlesname(jobobjlist.get(n));
									}
			    				}
							%>
								<%=jobtitlenames%>
							<%
							break;
							case 99:
								
							    int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
								
								int subcompanyid = -1;
								sql = "select subcompanyid from workflow_base where id="+wfid;
								RecordSet11.execute(sql);
								if(RecordSet11.next()){
									subcompanyid = Util.getIntValue((String)RecordSet11.getString("subcompanyid"),-1);
								}
								
								String rightStr = "WorkflowManage:All";

							    int tempLevel = UserWFOperateLevel.checkUserWfOperateLevel(detachable,subcompanyid,user,false,rightStr);
								if(tempLevel>=1){
								%>
								<%="<a href='javascript:void(0);' onclick='onShowEditMatrixDialog(this);'>"+matrix.getMatrixName(matrixUtil)+"("+matrix.getValueFieldName(matrixUtil)+")</a>"%>
								<%	
								}else{
								%>
								<%=matrix.getMatrixName(matrixUtil)+"("+matrix.getValueFieldName(matrixUtil)+")"%>
								<%
								}
								%>
								<%
							break;
							}
						%>
					</wea:item>
					<wea:item>
						<%
						switch (type){
						case 1:
						case 4:
						case 7:
						case 9:
						case 11:
						case 12:
						case 14:
						case 19:
						case 20:
						case 21:
						case 22:
						case 23:
						case 25:
						case 30:
						case 31:
						case 32:
						case 33:
						case 34:
						case 35:
						case 36:
						case 37:
						case 38:
						case 39:
						case 45:
						case 46:
						%>
						<%if(level2!=-1){%>
						<%=level%>-<%=level2%>
						<%}else{%>
						>=<%=level%>
						<%}%>
						<%
						break;
						case 2:
						 if(level==0){%>
						<%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
						<%}else if(level==1){%>
						<%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
						<%}else if(level==2){%>
						<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
						<%}else if(level==3){%>
						<%=SystemEnv.getHtmlLabelName(22753,user.getLanguage())%>
						<%}
						break;
						case 50:
						{
							if(level2==1){
								out.print(SystemEnv.getHtmlLabelName(22689,user.getLanguage()));
							}else if(level2==2){
								out.print(SystemEnv.getHtmlLabelName(22690,user.getLanguage()));
							}else if(level2==3){
								out.print(SystemEnv.getHtmlLabelName(22667,user.getLanguage()));
							}else{
								out.print(SystemEnv.getHtmlLabelName(140,user.getLanguage()));
							}
							break;
						}
						
						case 42:
						{
							if("0".equals(deptField)||"".equals(deptField)){//说明下拉框中选择的是安全级别
						       if(level2!=-1){
						          out.print(level+"-"+level2);
						       }else{
						          out.print(">="+level);
						       }	
							}else{//说明下拉框中选择的是部门自定义字段 deptField该字段存储值个格式id_fieldname_fieldlabel
							  String outStr="";
							  if(deptField!=null && !"".equals(deptField)){
							    String[] tempStr = Util.TokenizerString2(deptField, "[_]");
							    if(tempStr!=null && tempStr.length>2){
							       String fieldlabelStr=tempStr[2];
							       int fieldlabel= Util.getIntValue(fieldlabelStr,0);
							       outStr=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
							    }
							  }
							   out.print(outStr);
							}
							break;
						}
						
						case 51:
						{
							if("0".equals(subcompanyField)||"".equals(subcompanyField)){//说明下拉框中选择的是安全级别
						       if(level2!=-1){
						          out.print(level+"-"+level2);
						       }else{
						          out.print(">="+level);
						       }	
							}else{//说明下拉框中选择的是分部自定义字段subcompanyField该字段存储值个格式id_fieldname_fieldlabel
							  String outStr="";
							  if(subcompanyField!=null && !"".equals(subcompanyField)){
							    String[] tempStr = Util.TokenizerString2(subcompanyField, "[_]");
							    if(tempStr!=null && tempStr.length>2){
							       String fieldlabelStr=tempStr[2];
							       int fieldlabel= Util.getIntValue(fieldlabelStr,0);
							       outStr=SystemEnv.getHtmlLabelName(fieldlabel,user.getLanguage());
							    }
							  }
							   out.print(outStr);
							}
							break;
						}
						case 58:
						case 60:{
							String relatedid = "";
							String relatedsharename = "";
							int index = -1;
							ArrayList relatedsharelist=Util.TokenizerString(jobfield,",");
		    				for(int i=0;i<relatedsharelist.size();i++){
						        if(relatedsharename.equals("")){
						            if(level==0) relatedsharename=DepartmentComInfo.getDepartmentname((String)relatedsharelist.get(i));
						            if(level==1) relatedsharename=SubCompanyComInfo.getSubCompanyname((String)relatedsharelist.get(i));
						            if(level==3){
						            	relatedid = (String)relatedsharelist.get(i);
							            index=ids.indexOf(""+relatedid);
										if(index!=-1){
											relatedsharename=String.valueOf(names.get(index));
										}
						            }
					            }else{
					                if(level==0) relatedsharename+=","+DepartmentComInfo.getDepartmentname((String)relatedsharelist.get(i));
						            if(level==1) relatedsharename+=","+SubCompanyComInfo.getSubCompanyname((String)relatedsharelist.get(i));
						            if(level==3){
						            	relatedid = (String)relatedsharelist.get(i);
						            	index=ids.indexOf(""+relatedid);
										if(index!=-1){
											relatedsharename += ","+String.valueOf(names.get(index));
										}
						            }
					            }
				        	}
							if(level==0){%>
							<%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())+"("+relatedsharename+")"%>
							<%}else if(level==1){%>
							<%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())+"("+relatedsharename+")"%>
							<%}else if(level==2){%>
							<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
							<%}else if(level==3){%>
							<%=SystemEnv.getHtmlLabelName(21740,user.getLanguage())+"("+relatedsharename+")"%>
							<%}
							break;
						}
						case 59:
						case 61:{
							if(level==0){%>
							<%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
							<%}else if(level==1){%>
							<%=SystemEnv.getHtmlLabelName(21837,user.getLanguage())%>
							<%}else if(level==2){%>
							<%=SystemEnv.getHtmlLabelName(126607,user.getLanguage())%>
							<%}else if(level==3){%>
							<%=SystemEnv.getHtmlLabelName(126608,user.getLanguage())%>
							<%}else if(level==4){%>
							<%=SystemEnv.getHtmlLabelName(30792,user.getLanguage())%>
							<%}else if(level==5){%>
							<%=SystemEnv.getHtmlLabelName(19436,user.getLanguage())%>
							<%}else if(level==6){%>
							<%=SystemEnv.getHtmlLabelName(27189,user.getLanguage())%>
							<%}
							break;
						}
						}%>
				</wea:item>
				<wea:item>
					<%
						switch (type){	
						case 5:
						case 6:
						case 31:
						case 32:
						case 7:
						case 38:
						case 42:
						case 52:
						case 53:
						case 54:
						case 55:
						case 56:
						case 57:
						case 51:
						case 43:
						case 49:
						case 50:
						case 17:
						case 18:
						case 36:
						case 37:
						case 19:
						case 48:
						case 39:
						case 40:
						case 41:
						case 99:
						case 24:
						case 30:
						case 1:
						case 2:
						case 3:
						case 4:
						case 58:
						case 59:
						case 60:
						case 61:
							
						 
							 if(type==30||type==1||type==2||type==3||type==4||type==58){
							    if(!nodetype.equals("0")){
								    if(signorder.equals("0")){%>
									 <%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>
									 <% } else if(signorder.equals("1")){%>
									 <%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>
									 <%}else if(signorder.equals("2")){%>
									 <%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>
									 <%}else if(signorder.equals("3")){%>
									 <%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>
									 <%}else if(signorder.equals("4")){%>
									 <%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>
									 <%}
									break;
								 }
							 }else{
									 if(signorder.equals("0")){%>
									 <%=SystemEnv.getHtmlLabelName(15556,user.getLanguage())%>
									 <% } else if(signorder.equals("1")){%>
									 <%=SystemEnv.getHtmlLabelName(15557,user.getLanguage())%>
									 <%}else if(signorder.equals("2")){%>
									 <%=SystemEnv.getHtmlLabelName(15558,user.getLanguage())%>
									 <%}else if(signorder.equals("3")){%>
									 <%=SystemEnv.getHtmlLabelName(21227,user.getLanguage())%>
									 <%}else if(signorder.equals("4")){%>
									 <%=SystemEnv.getHtmlLabelName(21228,user.getLanguage())%>
									 <%}
									break;
									
								}}
						%>
				</wea:item>
				<wea:item><%=showcondition%></wea:item>
				<wea:item>
					<%if(orders == null || "".equals(orders)){%>
					<%=orders%>
					<%}else{%>
						<%if (!nodetype.equals("0")){%>
							<input type='text' class='Inputstyle' name='group_<%=rowsum%>_order' value='<%=orders%>' onchange="check_number('group_<%=rowsum%>_order');checkDigit(this,5,2)"  maxlength="5" style='width:80%'>
						<%}else{%>
							0
						<%}%>
					<%}%>
				</wea:item>
				<%
				rowsum += 1;
				}
				oldids=oldids+",";
				%>
				
			</wea:group>
			</wea:layout>
			<input type="hidden" name="oldids" size=25 value="<%=oldids%>">
			<input type="hidden" name="singerorder_flag" id="singerorder_flag" value="<%=singerorder_flag%>">
			<input type="hidden" name="singerorder_type" id="singerorder_type" value="<%=singerorder_type%>">
			<input type="hidden" name="singerorder_level" id="singerorder_level" value="<%=singerorder_level%>">
		</wea:item>	 
	</wea:group>
</wea:layout>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="closeCancle()">
	    </wea:item>
		</wea:group>
	</wea:layout>
</div>	
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%--
<%
	if(design==1){
%>
		<jsp:include page="/workflow/workflow/editoperatorgroupScript.jsp" flush="true">
			<jsp:param name="nodetype" value="<%=nodetype%>" />
		</jsp:include>
<%		
	}else{
%>
--%>
<script language="JavaScript" src="/js/addRowBg_wev8.js" ></script>
	<%-- 
	<jsp:include page="/workflow/workflow/editoperatorgroupScriptNotDesign.jsp" flush="true">
	--%>
	<jsp:include page="/workflow/workflow/addoperatorgroupScriptND.jsp" flush="true">
		<jsp:param name="wfid" value="<%=wfid%>" />
		<jsp:param name="formid" value="<%=formid%>" />
		<jsp:param name="isbill" value="<%=isbill%>" />
		<jsp:param name="nodetype" value="<%=nodetype%>"/>
	</jsp:include>
<%--
<% } %>
 --%>
</form>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/e8_btn_addOrdel_wev8.js"></script>
</body>
 <script language="javascript">
	
	//alert("--eam2118-insertindex--"+insertindex);
	Matrix2(insertindex);//这里放在addMatrixRowNew方法外面选择矩阵取值字段内容后就不会默认显示第一条了
	function addMatrixRowNew(){
	var lastRow = jQuery('<tr class="data"><td style="padding-left: 30px !important;"><input type="checkbox" value="'+ insertindex+ '" /></td><td class="cftd"><div class="cf"><span></span></div></td><td class="wftd"><div class="wf"><span></span></div></td><td></td></tr>');
	var lineRow = jQuery('<tr class="Spacing" style="height:1px!important;display:;"><td class="paddingLeft0" colspan="4"><div class="intervalDivClass"></div></td></tr>');
	var matrixTable = jQuery('#matrixTable');
	var formid = <%=formid%>;
	var isbill = <%=isbill%> ;
	var issystem;
	matrixTable.append(lastRow);
	matrixTable.append(lineRow);
	lastRow.jNice();
		

	 lastRow.find('div.cf span').append('<input type="hidden" issingle="true" ismustinput="1" viewtype="0" onpropertychange="" temptitle="" name="cf_'+ insertindex+ '" id="cf_'+ insertindex+ '" ><select style="width:140px" class=inputstyle id="matrixCfield_'+ insertindex+ '"  name="matrixCfield_'+ insertindex+ '" onchange = "selectShow('+ insertindex+ ');changetype('+ insertindex+ ');changetype2('+ insertindex+ ')" style="float:left;">'+jQuery("#__max1").html()+'</select>');

	lastRow.find('div.cf span').append('<span id = "rule_'+insertindex+'">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(353, user.getLanguage())%></span>');
	//jQuery("#matrixRulefield_"+insertindex).parent().before('<div id = rule_"'+insertindex+'">属于</span>');

	lastRow.find('div.wf span').append('<input type="hidden" issingle="true" ismustinput="1" viewtype="0" onpropertychange="" temptitle="" name="wf_'+ insertindex+ '" id="wf_'+ insertindex+ '"> <select style="width:140px" class=inputstyle id="matrixRulefield_'+ insertindex+ '" name="matrixRulefield_'+ insertindex+ '"  onchange = "selectShow('+ insertindex+ ')"  style="float:left;">'+jQuery("#__max2").html()+'</select>');
	


	//matrixTable.append('<tr class="Spacing" style="height:1px!important;"><td colspan="8" class="paddingLeft0Table"><div class="intervalDivClass"></div></td></tr>');
	changeSelectAllMatrixRowStatus(false);
	changetype(insertindex);
	changetype2(insertindex);
	selectShow(insertindex);
	//当下拉框的内容只有一条时，样式为只读，多条时编辑
    if(jQuery("#matrixCfield_"+insertindex).find("option").length <= 1){
        jQuery("#matrixCfield_"+insertindex).attr("disabled","disabled");
    }
    __jNiceNamespace__.beautySelect("#matrixCfield_"+insertindex);
	insertindex = insertindex+1;
}


  function Matrix2(insertindex){
	
	//	alert("---add---insertindex--"+insertindex);
		jQuery("#matrixTmpfield").empty()
		jQuery("#matrixCfield").empty();
		var formid = <%=formid%>;
		var isbill = <%=isbill%> ;
	   var matrixTmp=jQuery("#matrixTmp").val();
	   var issystem;
	//	alert("--matrixTmpT---"+matrixTmp);
		jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixTmp":matrixTmp,"operator":"1"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				
	
				jQuery("#matrixTmpfield").html(returnValues.trim());
				jQuery("#matrixTmpfield").selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixTmpfield")
	    	}
	      }
	   });

	   jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixTmp":matrixTmp,"operator":"0"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				//alert("--insertindex--1111-"+insertindex);
				if(insertindex){
				  // alert("----0-returnValues.trim()---"+returnValues.trim());
				jQuery("#matrixCfield_"+insertindex).html(returnValues.trim());
				
				jQuery("#matrixCfield_"+insertindex).selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixCfield_"+insertindex)
					jQuery("#__max1").html(returnValues.trim());
				jQuery("#__max1").selectbox("detach")
				__jNiceNamespace__.beautySelect("#__max1")
				}else{
				 // alert("----0-returnValues.trim()---"+returnValues.trim());
				 //alert("--insertindex--2222-"+insertindex);
				jQuery("[id^=matrixCfield]").html(returnValues.trim());
				
				jQuery("[id^=matrixCfield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixCfield]")
					jQuery("#__max1").html(returnValues.trim());
				jQuery("#__max1").selectbox("detach")
				__jNiceNamespace__.beautySelect("#__max1")
				}
				//alert(jQuery("matrixCfield").html());
				//changetypeall();
				changetype(insertindex);
				
				   
	    	}
	      }
	   });

	      jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixTmp":matrixTmp,"operator":"2"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				// alert("----0-returnValues.trim()---"+returnValues.trim());
					issystem = returnValues.trim();
					//jQuery("#issystem").val(returnValues.trim());
					if(issystem ==1 || issystem==2)   {	
						jQuery("[id^=matrixCfield]").attr("disabled","disabled");	
						jQuery("[id^=matrixCfield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixCfield]")
					}else{
						   jQuery("[id^=matrixCfield]").removeAttr("disabled");	
						jQuery("[id^=matrixCfield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixCfield]")
						}
	    	}
	      }
	   });


	    jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"formid":formid,"isbill":isbill,"operator":"3"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				//alert("--insertindex-2260--"+insertindex);
				if(typeof(insertindex) ==  "undefined"){
			//	  	alert("--insertindex-2269--"+insertindex);
				 //alert("----3-returnValues.trim()---"+returnValues.trim());
				 if(window.console)console.log("----3-returnValues.trim()---"+returnValues.trim());
				jQuery("[id^=matrixRulefield]").html(returnValues.trim());
				jQuery("#__max2").html(returnValues.trim());
				jQuery("[id^=matrixRulefield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixRulefield]")
				//alert(jQuery("#matrixRulefield").html());
				}else{
						  // alert("----0-returnValues.trim()---"+returnValues.trim());
				jQuery("#matrixRulefield"+insertindex).html(returnValues.trim());
				 jQuery("#__max2").html(returnValues.trim());
				jQuery("#matrixRulefield_"+insertindex).selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixRulefield_"+insertindex)
				
				}
	    	}
	      }
	   });	
	  
	/*   if(insertindex)	{
	   	changetype(insertindex);
	   }else{
	   var matrixTableRows = jQuery('#matrixTable tr.data');
		if(matrixTableRows){
		indexinsert =0;
		for(indexinsert=0;indexinsert<matrixTableRows.length;indexinsert++){
			 changetype(insertindex);
		}
		}
	   }   */
	   
	}

function Matrix(insertindex){
	
	//	alert("---add---insertindex--"+insertindex);
		jQuery("#matrixTmpfield").empty()
		jQuery("#matrixCfield").empty();
		var formid = <%=formid%>;
		var isbill = <%=isbill%> ;
	   var matrixTmp=jQuery("#matrixTmp").val();
	   var issystem;
	//	alert("--matrixTmpT---"+matrixTmp);
		jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixTmp":matrixTmp,"operator":"1"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				
	
				jQuery("#matrixTmpfield").html(returnValues.trim());
				jQuery("#matrixTmpfield").selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixTmpfield")
	    	}
	      }
	   });

	   jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixTmp":matrixTmp,"operator":"0"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				//alert("--insertindex--1111-"+insertindex);
				if(insertindex){
				  // alert("----0-returnValues.trim()---"+returnValues.trim());
				jQuery("#matrixCfield_"+insertindex).html(returnValues.trim());
				
				jQuery("#matrixCfield_"+insertindex).selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixCfield_"+insertindex)
					jQuery("#__max1").html(returnValues.trim());
				jQuery("#__max1").selectbox("detach")
				__jNiceNamespace__.beautySelect("#__max1")
				}else{
				 // alert("----0-returnValues.trim()---"+returnValues.trim());
				 //alert("--insertindex--2222-"+insertindex);
				jQuery("[id^=matrixCfield]").html(returnValues.trim());	
				jQuery("[id^=matrixCfield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixCfield]")
					jQuery("#__max1").html(returnValues.trim());
				jQuery("#__max1").selectbox("detach")
				__jNiceNamespace__.beautySelect("#__max1")
				}
				//alert(jQuery("matrixCfield").html());
				changetypeall();
				//changetype(insertindex);
				
				   
	    	}
	      }
	   });

	      jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixTmp":matrixTmp,"operator":"2"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				// alert("----0-returnValues.trim()---"+returnValues.trim());
					issystem = returnValues.trim();
					//jQuery("#issystem").val(returnValues.trim());
					if(issystem ==1 || issystem==2)   {	
						jQuery("[id^=matrixCfield]").attr("disabled","disabled");	
						jQuery("[id^=matrixCfield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixCfield]")
					}else{
						   jQuery("[id^=matrixCfield]").removeAttr("disabled");	
						jQuery("[id^=matrixCfield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixCfield]")
						}
	    	}
	      }
	   });


	/*    jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"formid":formid,"isbill":isbill,"operator":"3"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("服务器运行出错!\n请联系系统管理员!");
	    		return;
	    	} else {
				//alert("--insertindex-2260--"+insertindex);
				if(typeof(insertindex) ==  "undefined"){
			//	  	alert("--insertindex-2269--"+insertindex);
				// alert("----3-returnValues.trim()---"+returnValues.trim());
				 if(window.console)console.log("----3-returnValues.trim()---"+returnValues.trim());
				jQuery("[id^=matrixRulefield]").html(returnValues.trim());
				jQuery("#__max2").html(returnValues.trim());
				jQuery("[id^=matrixRulefield]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixRulefield]")
				//alert(jQuery("#matrixRulefield").html());
			
				}else{
						  // alert("----0-returnValues.trim()---"+returnValues.trim());
				jQuery("#matrixRulefield"+insertindex).html(returnValues.trim());
				 jQuery("#__max2").html(returnValues.trim());
				jQuery("#matrixRulefield_"+insertindex).selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixRulefield_"+insertindex)
				
				}
				//alert(jQuery("[id^=matrixCfield]").val());
				/*if(jQuery("[id^=matrixCfield]").val()==0){
					alert("---2432-----");
				changetypeall();
				}	  *
					changetypeall();
	    	}
	      }
	   });	*/
	  
	/*   if(insertindex)	{
	   	changetype(insertindex);
	   }else{
	   var matrixTableRows = jQuery('#matrixTable tr.data');
		if(matrixTableRows){
		indexinsert =0;
		for(indexinsert=0;indexinsert<matrixTableRows.length;indexinsert++){
			 changetype(insertindex);
		}
		}
	   }   */
	   
	}

function selectShow(insertindex){

	if(document.getElementById("matrixTmp")){
		 // document.getElementById("matrix").setAttribute("value",document.getElementById("matrixTmp").getAttribute("value")); 
		  document.getElementById("matrix").value=document.getElementById("matrixTmp").value;
	}
	 
	if(document.getElementById("matrixTmpfield")){
	     document.getElementById("vf").value=document.getElementById("matrixTmpfield").value;
		// document.getElementById("vf").setAttribute("value",document.getElementById("matrixTmpfield").getAttribute("value")); 
	 }
	 if(document.getElementById("matrixCfield_"+insertindex)){
		// document.getElementById("cf_"+insertindex).setAttribute("value",document.getElementById("matrixCfield_"+insertindex).getAttribute("value")); 
		 document.getElementById("cf_"+insertindex).value=document.getElementById("matrixCfield_"+insertindex).value;
	 }
	 if(document.getElementById("matrixRulefield_"+insertindex)){
		 //document.getElementById("wf_"+insertindex).setAttribute("value",document.getElementById("matrixRulefield_"+insertindex).getAttribute("value"));
		 document.getElementById("wf_"+insertindex).value=document.getElementById("matrixRulefield_"+insertindex).value;
	 }

	}

	function changetype2(insertindex){
		 //jQuery("#matrixRulefield_"+insertindex).find('div.cf span').after('2221212');
		// alert("-2312-insertindex---"+insertindex);
		 var matrixCfield=jQuery("#matrixCfield_"+insertindex).val();
	   var formid = <%=formid%>;
		var isbill = <%=isbill%> ;
		var typeid;
		//alert("-2317-matrixCfield---"+matrixCfield);
			if(matrixCfield>-1){
		jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixCfield":matrixCfield,"formid":formid,"isbill":isbill,"operator":"5"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
					
				   typeid = returnValues.trim();
				
				   if(162 == typeid){
					
					 //alert("----162----"+jQuery("#rule_"+insertindex).html());
						jQuery("#rule_"+insertindex).html('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(346, user.getLanguage())%>');
					//   jQuery("#matrixRulefield_"+insertindex).parent().before('<div id = Brule_"'+insertindex+'">包含</span>');
				  // lastRow.find('div.wf span').before('包含');
				   }else{
				   	 jQuery("#rule_"+insertindex).html('&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(353, user.getLanguage())%>');
				   }
				
	    	}
	      }
	   });

			}
	
	}

function changetypeall(){
	var matrixTableRows = jQuery('#matrixTable tr.data');
	//alert("--insertindex--2367-"+insertindex);
	//alert("--222--all-");
	var insertindex;
   for(insertindex=0;insertindex<matrixTableRows.length+5;insertindex++){
	   var matrixCfield=jQuery("#matrixCfield_"+insertindex).val();
	   var formid = <%=formid%>;
		var isbill = <%=isbill%> ;
		//alert("-matrixCfield-3333-"+matrixCfield);
		   if(matrixCfield>-1){
		jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixCfield":matrixCfield,"formid":formid,"isbill":isbill,"operator":"4"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
			//alert("succ");
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				//insertindex = insertindex-1;
			//	alert("-insertindex-3333-");
					//alert("--(returnValues.trim()--3333-"+returnValues.trim());
						//alert("--matrixCfield---"+matrixCfield);
				//jQuery("#matrixRulefield_"+insertindex).html(returnValues.trim());
				//jQuery("#matrixRulefield_"+insertindex).selectbox("detach")
				//__jNiceNamespace__.beautySelect("#matrixRulefield_"+insertindex)
				jQuery("[id^=matrixRulefield_]").html(returnValues.trim());
				jQuery("[id^=matrixRulefield_]").selectbox("detach")
				__jNiceNamespace__.beautySelect("[id^=matrixRulefield_]")
				//alert(jQuery("#matrixRulefield_"+(insertindex-1)).html());
	    	}
	      }
	   });
		   }

}

}

function changetype(insertindex){
	var matrixTableRows = jQuery('#matrixTable tr.data');
//	alert("--insertindex--2367-"+insertindex);
if(typeof(insertindex) ==  "undefined"){
	insertindex = 0;
   for(insertindex=0;insertindex<matrixTableRows.length+5;insertindex++){
	   var matrixCfield=jQuery("#matrixCfield_"+insertindex).val();
	   var formid = <%=formid%>;
		var isbill = <%=isbill%> ;
		//alert("--matrixCfield---"+matrixCfield);
			if(matrixCfield>-1){
				//alert("--insertindex-2222--"+insertindex);
				//alert("--matrixCfield-2222--"+matrixCfield);
		jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixCfield":matrixCfield,"formid":formid,"isbill":isbill,"operator":"4"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
			//alert("succ");
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				insertindex = insertindex-1;
			//	alert("-insertindex-3333-"+insertindex);
				//	alert("--(returnValues.trim()--3333-"+returnValues.trim());
			//			alert("--matrixCfield---"+matrixCfield);
				jQuery("#matrixRulefield_"+insertindex).html(returnValues.trim());
				jQuery("#matrixRulefield_"+insertindex).selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixRulefield_"+insertindex)
				//jQuery("[id^=matrixRulefield_]").html(returnValues.trim());
				//jQuery("[id^=matrixRulefield_]").selectbox("detach")
				//__jNiceNamespace__.beautySelect("[id^=matrixRulefield_]")
				//alert(jQuery("#matrixRulefield_"+(insertindex-1)).html());
	    	}
	      }
	   });

			}
}
}else{
	var matrixCfield=jQuery("#matrixCfield_"+insertindex).val();
	   var formid = <%=formid%>;
		var isbill = <%=isbill%> ;
		//alert("--matrixCfield--22-"+matrixCfield);
			if(matrixCfield>-1){
		jQuery.ajax({
		url:"/matrixmanage/pages/matrixbrowserOp.jsp",
		type:"post",
		data:{"matrixCfield":matrixCfield,"formid":formid,"isbill":isbill,"operator":"4"},
		dataType: "text",
		complete: function(){
		},
		success:function (returnValues, textStatus) {
	    	if (returnValues == undefined || returnValues == null) {
	    		alert("<%=SystemEnv.getHtmlLabelName(129417, user.getLanguage())%>");
	    		return;
	    	} else {
				
				//	alert("--matrixCfield--22-"+insertindex);
				//	alert("--returnValues.trim()--22-"+returnValues.trim());
				jQuery("#matrixRulefield_"+insertindex).html(returnValues.trim());
				jQuery("#matrixRulefield_"+insertindex).selectbox("detach")
				__jNiceNamespace__.beautySelect("#matrixRulefield_"+insertindex)
				//alert(jQuery("#matrixTmpfield"));
				//alert(jQuery("#matrixTmpfield").html());
	    	}
	      }
	   });

			}

}
}

</script>
