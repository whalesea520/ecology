
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.general.BaseBean" %>
<%@ page import="weaver.workflow.search.WorkflowSearchUtil" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea" %>
<%@ taglib uri="/browserTag" prefix="brow" %>
<%@ page import="weaver.workflow.request.Browsedatadefinition" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="ProjectInfoComInfo" class="weaver.proj.Maint.ProjectInfoComInfo" scope="page"/>
<jsp:useBean id="crmComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page"/>
<jsp:useBean id="browsedatadefinition" class="weaver.workflow.request.Browsedatadefinition" scope="page"/>

<%@ include file="/systeminfo/init_wev8.jsp" %>
<HTML>
	<HEAD>
		<LINK REL=stylesheet type=text/css HREF=/css/Weaver_wev8.css>
		<script type="text/javascript" src="/js/weaver_wev8.js"></script>
		<script type="text/javascript" src="/wui/common/jquery/plugin/jQuery.modalDialog_wev8.js"></script>
		<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
	</HEAD>
	<BODY style='overflow-x: hidden'>

<%
	String imagefilename = "/images/hdMaintenance_wev8.gif";
	String titlename = SystemEnv.getHtmlLabelName(32752,user.getLanguage());
	String needfav = "1";
	String needhelp = "";

	String workflowid = request.getAttribute("wfid").toString();
	String fieldid = request.getAttribute("fieldId").toString();
	String type = request.getAttribute("type").toString();
	String isbill = request.getAttribute("isBill").toString();
    String formid = request.getAttribute("formId").toString();
	String optionmethod = Util.null2String(request.getParameter("optionmethod"));

	BaseBean bean = new BaseBean();
	String wfdateduring = Util.null2String(bean.getPropValue("wfdateduring", "wfdateduring"));
	String isornshow = "";
	if ("171".equals(type)) {
		isornshow = "no";
	}

	String requestbs = Util.null2String(request.getParameter("requestbs"));
	String requestname = Util.null2String(request.getParameter("requestname"));
	String workflowtype = Util.null2String(request.getParameter("workflowtype"));
	String Processnumber = Util.null2String(request.getParameter("Processnumber"));
	String createtype = Util.null2String(request.getParameter("createtype"));
	String createtypeid = Util.null2String(request.getParameter("createtypeid"));
	String createdepttype = Util.null2String(request.getParameter("createdepttype"));
	String department = Util.null2String(request.getParameter("department"));
	String createsubtype = Util.null2String(request.getParameter("createsubtype"));
	String createsubid = Util.null2String(request.getParameter("createsubid"));
	String createdatetype = Util.null2String(request.getParameter("createdatetype"));
	String createdatestart = Util.null2String(request.getParameter("createdatestart"));
	String createdateend = Util.null2String(request.getParameter("createdateend"));
	String createdatefieldid = "";
	if ("8".equals(createdatetype)) {
		createdatefieldid = Util.null2String(request.getParameter("createdatefieldid"));
	}
	String xgxmtype = Util.null2String(request.getParameter("xgxmtype"));
	String xgxmid = Util.null2String(request.getParameter("xgxmid"));
	String xgkhtype = Util.null2String(request.getParameter("xgkhtype"));
	String xgkhid = Util.null2String(request.getParameter("xgkhid"));
	String gdtype = Util.null2String(request.getParameter("gdtype"));
	String jsqjtype = Util.null2String(request.getParameter("jsqjtype"));

	String requestnameopen = Util.null2String(request.getParameter("requestnameopen"));
	String workflowtypeopen = Util.null2String(request.getParameter("workflowtypeopen"));
	String Processnumberopen = Util.null2String(request.getParameter("Processnumberopen"));
	String createtypeidopen = Util.null2String(request.getParameter("createtypeidopen"));
	String createdeptidopen = Util.null2String(request.getParameter("createdeptidopen"));
	String createsubidopen = Util.null2String(request.getParameter("createsubidopen"));
	String createdateopen = Util.null2String(request.getParameter("createdateopen"));
	String xgxmidopen = Util.null2String(request.getParameter("xgxmidopen"));
	String xgkhidopen = Util.null2String(request.getParameter("xgkhidopen"));
	String gdtypeopen = Util.null2String(request.getParameter("gdtypeopen"));
	String jsqjtypeopen = Util.null2String(request.getParameter("jsqjtypeopen"));

	float requestnameshoworder = Util.getFloatValue(request.getParameter("requestnameshoworder"), 1);
	float workflowtypeshoworder = Util.getFloatValue(request.getParameter("workflowtypeshoworder"), 2);
	float Processnumbershoworder = Util.getFloatValue(request.getParameter("Processnumbershoworder"), 3);
	float createtypeidshoworder = Util.getFloatValue(request.getParameter("createtypeidshoworder"), 4);
	float departmentshoworder = Util.getFloatValue(request.getParameter("departmentshoworder"), 5);
	float cjrfbshoworder = Util.getFloatValue(request.getParameter("cjrfbshoworder"), 6);
	float createdatetypeshoworder = Util.getFloatValue(request.getParameter("createdatetypeshoworder"), 7);
	float xgxmidshoworder = Util.getFloatValue(request.getParameter("xgxmidshoworder"), 8);
	float xgkhidshoworder = Util.getFloatValue(request.getParameter("xgkhidshoworder"), 9);
	float gdtypeshoworder = Util.getFloatValue(request.getParameter("gdtypeshoworder"), 10);
	float jsqjtypeshoworder = Util.getFloatValue(request.getParameter("jsqjtypeshoworder"), 11);

	String requestnamereadonly = Util.null2String(request.getParameter("requestnamereadonly"));
	String workflowtypereadonly = Util.null2String(request.getParameter("workflowtypereadonly"));
	String Processnumberreadonly = Util.null2String(request.getParameter("Processnumberreadonly"));
	String createtypeidreadonly = Util.null2String(request.getParameter("createtypeidreadonly"));
	String createdeptidreadonly = Util.null2String(request.getParameter("createdeptidreadonly"));
	String createsubidreadonly = Util.null2String(request.getParameter("createsubidreadonly"));
	String createdatereadonly = Util.null2String(request.getParameter("createdatereadonly"));
	String xgxmidreadonly = Util.null2String(request.getParameter("xgxmidreadonly"));
	String xgkhidreadonly = Util.null2String(request.getParameter("xgkhidreadonly"));
	String gdtypereadonly = Util.null2String(request.getParameter("gdtypereadonly"));
	String jsqjtypereadonly = Util.null2String(request.getParameter("jsqjtypereadonly"));

	boolean hasChangeData = false;
	if("add".equals(optionmethod)) {
	   browsedatadefinition.setWorkflowid(workflowid);
	   browsedatadefinition.setFieldid(fieldid);
	   browsedatadefinition.setFieldtype(type);
	   browsedatadefinition.setRequestbs(requestbs);
	   browsedatadefinition.setRequestname(requestname);
	   browsedatadefinition.setWorkflowtype(workflowtype);
	   browsedatadefinition.setProcessnumber(Processnumber);
	   browsedatadefinition.setCreatetype(createtype);
	   browsedatadefinition.setCreatetypeid(createtypeid);
	   browsedatadefinition.setCreatedepttype(createdepttype);
	   browsedatadefinition.setDepartment(department);
	   browsedatadefinition.setCreatesubtype(createsubtype);
	   browsedatadefinition.setCreatesubid(createsubid);
	   browsedatadefinition.setCreatedatetype(createdatetype);
	   browsedatadefinition.setCreatedatestart(createdatestart);
	   browsedatadefinition.setCreatedateend(createdateend);
	   browsedatadefinition.setCreatedatefieldid(createdatefieldid);
	   browsedatadefinition.setXgxmtype(xgxmtype);
	   browsedatadefinition.setXgxmid(xgxmid);
	   browsedatadefinition.setXgkhtype(xgkhtype);
	   browsedatadefinition.setXgkhid(xgkhid);
	   browsedatadefinition.setGdtype(gdtype);
	   browsedatadefinition.setJsqjtype(jsqjtype);

	   browsedatadefinition.setRequestnameopen(requestnameopen);
	   browsedatadefinition.setWorkflowtypeopen(workflowtypeopen);
	   browsedatadefinition.setProcessnumberopen(Processnumberopen);
	   browsedatadefinition.setCreatetypeidopen(createtypeidopen);
	   browsedatadefinition.setCreatedeptidopen(createdeptidopen);
	   browsedatadefinition.setCreatesubidopen(createsubidopen);
	   browsedatadefinition.setCreatedateopen(createdateopen);
	   browsedatadefinition.setXgxmidopen(xgxmidopen);
	   browsedatadefinition.setXgkhidopen(xgkhidopen);
	   browsedatadefinition.setGdtypeopen(gdtypeopen);
	   browsedatadefinition.setJsqjtypeopen(jsqjtypeopen);

	   browsedatadefinition.setRequestnameshoworder(String.valueOf(requestnameshoworder));
	   browsedatadefinition.setWorkflowtypeshoworder(String.valueOf(workflowtypeshoworder));
	   browsedatadefinition.setProcessnumbershoworder(String.valueOf(Processnumbershoworder));
	   browsedatadefinition.setCreatetypeidshoworder(String.valueOf(createtypeidshoworder));
	   browsedatadefinition.setDepartmentshoworder(String.valueOf(departmentshoworder));
	   browsedatadefinition.setCjrfbshoworder(String.valueOf(cjrfbshoworder));
	   browsedatadefinition.setCreatedatetypeshoworder(String.valueOf(createdatetypeshoworder));
	   browsedatadefinition.setXgxmidshoworder(String.valueOf(xgxmidshoworder));
	   browsedatadefinition.setXgkhidshoworder(String.valueOf(xgkhidshoworder));
	   browsedatadefinition.setGdtypeshoworder(String.valueOf(gdtypeshoworder));
	   browsedatadefinition.setJsqjtypeshoworder(String.valueOf(jsqjtypeshoworder));

	   browsedatadefinition.setRequestnamereadonly(requestnamereadonly);
	   browsedatadefinition.setWorkflowtypereadonly(workflowtypereadonly);
	   browsedatadefinition.setProcessnumberreadonly(Processnumberreadonly);
	   browsedatadefinition.setCreatetypeidreadonly(createtypeidreadonly);
	   browsedatadefinition.setCreatedeptidreadonly(createdeptidreadonly);
	   browsedatadefinition.setCreatesubidreadonly(createsubidreadonly);
	   browsedatadefinition.setCreatedatereadonly(createdatereadonly);
	   browsedatadefinition.setXgxmidreadonly(xgxmidreadonly);
	   browsedatadefinition.setXgkhidreadonly(xgkhidreadonly);
	   browsedatadefinition.setGdtypereadonly(gdtypereadonly);
	   browsedatadefinition.setJsqjtypereadonly(jsqjtypereadonly);

	   browsedatadefinition.save();
	   hasChangeData = true; 
	} else if ("del".equals(optionmethod)) {
		browsedatadefinition.delete(workflowid, fieldid);
		hasChangeData = true;
	} else {
		if(browsedatadefinition.read(workflowid, fieldid)){
			requestbs = browsedatadefinition.getRequestbs();
			requestname = browsedatadefinition.getRequestname();
			workflowtype = browsedatadefinition.getWorkflowtype();
			Processnumber = browsedatadefinition.getProcessnumber();
			createtype = browsedatadefinition.getCreatetype();
			createtypeid = browsedatadefinition.getCreatetypeid(); 
			createdepttype = browsedatadefinition.getCreatedepttype();
			department = browsedatadefinition.getDepartment();
			createsubtype = browsedatadefinition.getCreatesubtype();
			createsubid = browsedatadefinition.getCreatesubid();
			createdatetype = browsedatadefinition.getCreatedatetype();
			createdatestart = browsedatadefinition.getCreatedatestart();
			createdateend = browsedatadefinition.getCreatedateend();
			createdatefieldid = browsedatadefinition.getCreatedatefieldid();
			xgxmtype = browsedatadefinition.getXgxmtype();
			xgxmid = browsedatadefinition.getXgxmid();
			xgkhtype = browsedatadefinition.getXgkhtype();
			xgkhid = browsedatadefinition.getXgkhid();
			gdtype = browsedatadefinition.getGdtype();
			jsqjtype = browsedatadefinition.getJsqjtype();

			requestnameopen = browsedatadefinition.getRequestnameopen();
			workflowtypeopen = browsedatadefinition.getWorkflowtypeopen();
			Processnumberopen = browsedatadefinition.getProcessnumberopen();
			createtypeidopen = browsedatadefinition.getCreatetypeidopen();
			createdeptidopen = browsedatadefinition.getCreatedeptidopen();
			createsubidopen = browsedatadefinition.getCreatesubidopen();
			createdateopen = browsedatadefinition.getCreatedateopen();
			xgxmidopen = browsedatadefinition.getXgxmidopen();
			xgkhidopen = browsedatadefinition.getXgkhidopen();
			gdtypeopen = browsedatadefinition.getGdtypeopen();
			jsqjtypeopen = browsedatadefinition.getJsqjtypeopen();

			requestnameshoworder = Util.getFloatValue(browsedatadefinition.getRequestnameshoworder(), 1); 
			workflowtypeshoworder = Util.getFloatValue(browsedatadefinition.getWorkflowtypeshoworder(), 2); 
			Processnumbershoworder = Util.getFloatValue(browsedatadefinition.getProcessnumbershoworder(), 3); 
			createtypeidshoworder = Util.getFloatValue(browsedatadefinition.getCreatetypeidshoworder(), 4);  
			departmentshoworder = Util.getFloatValue(browsedatadefinition.getDepartmentshoworder(), 5); 
			createdatetypeshoworder = Util.getFloatValue(browsedatadefinition.getCreatedatetypeshoworder(), 6);  
			cjrfbshoworder = Util.getFloatValue(browsedatadefinition.getCjrfbshoworder(), 7); 
			xgxmidshoworder = Util.getFloatValue(browsedatadefinition.getXgxmidshoworder(), 8);  
			xgkhidshoworder = Util.getFloatValue(browsedatadefinition.getXgkhidshoworder(), 9); 
			gdtypeshoworder = Util.getFloatValue(browsedatadefinition.getGdtypeshoworder(), 10); 
			jsqjtypeshoworder = Util.getFloatValue(browsedatadefinition.getJsqjtypeshoworder(), 11);

			requestnamereadonly = browsedatadefinition.getRequestnamereadonly();
			workflowtypereadonly = browsedatadefinition.getWorkflowtypereadonly();
			Processnumberreadonly = browsedatadefinition.getProcessnumberreadonly();
			createtypeidreadonly = browsedatadefinition.getCreatetypeidreadonly();
			createdeptidreadonly = browsedatadefinition.getCreatedeptidreadonly();
			createsubidreadonly = browsedatadefinition.getCreatesubidreadonly();
			createdatereadonly = browsedatadefinition.getCreatedatereadonly();
			xgxmidreadonly = browsedatadefinition.getXgxmidreadonly();
			xgkhidreadonly = browsedatadefinition.getXgkhidreadonly();
			gdtypereadonly = browsedatadefinition.getGdtypereadonly();
			jsqjtypereadonly = browsedatadefinition.getJsqjtypereadonly();
		}
	}
%>

		<!-- start -->
		<jsp:include page="/systeminfo/commonTabHead.jsp">
			<jsp:param name="mouldID" value="workflow" />
			<jsp:param name="navName" value="<%=titlename%>" />
		</jsp:include>

		<div class="zDialog_div_content">
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td>
				</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="button" class="e8_btn_top_first" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" onClick="btnok_onclick();" />
					<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>" onClick="btncz_onclick();" />
					<input type="button" class="e8_btn_top" value="<%=SystemEnv.getHtmlLabelName(23777,user.getLanguage())%>" onClick="btnsc_onclick();" />
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div id="mainDiv">
			<FORM id=frmMain name=frmMain action=RequestBrowserfunction.jsp method=post>

				<wea:layout type="4col" attributes="{expandAllGroup:true}">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>'>
						<wea:item><%=SystemEnv.getHtmlLabelName(84,user.getLanguage())%></wea:item>
						<wea:item>
							<input name="requestbs" id="requestbs" class="Inputstyle" maxlength="100" value="<%=Util.toScreenForWorkflowReadOnly(requestbs)%>">
							<span id="requestbsspan">
								<%if("".equals(requestbs)){%>
									<IMG src="/images/BacoError_wev8.gif" align=absMiddle>
								<%}%>
							</span>
						</wea:item>
					</wea:group>
					<wea:group context='<%=SystemEnv.getHtmlLabelNames("149,20331", user.getLanguage())%>'>
						<wea:item attributes="{'colspan':'full','isTableList':'true'}">

							<input type="hidden" name="fieldid" id="fieldid" value="<%=fieldid %>">
							<input type="hidden" name="type" id="type" value="<%=type %>">
							<input type="hidden" name="optionmethod" id="optionmethod" value="">
							<input type="hidden" name="wfid" id="workflowid" value="<%=workflowid %>">

							<table class="ListStyle" cellspacing="0" style="table-layout: fixed;">
								<col width="15%">
								<col width="50%">
								<col width="15%">
								<col width="10%">
								<col width="10%">
								<thead>
									<tr class="HeaderForXtalbe"> 
									    <th colspan=2><%=SystemEnv.getHtmlLabelNames("15364,33508", user.getLanguage())%></th>
									    <th><%=SystemEnv.getHtmlLabelName(15513, user.getLanguage())%></th>
									    <th><input id="checkAllOpen" type="checkbox">&nbsp;<%=SystemEnv.getHtmlLabelName(16636, user.getLanguage())%></th>
									    <th><input id="checkAllReadonly" type="checkbox">&nbsp;<%=SystemEnv.getHtmlLabelName(17873, user.getLanguage())%></th>
									</tr>
								</thead>
								<tbody>
									
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(26876,user.getLanguage())%></TD>
										<TD>
											<input name="requestname" id="requestname" class=Inputstyle value="<%=Util.toScreenForWorkflowReadOnly(requestname) %>">
										</TD>
										<TD>
											<input name="requestnameshoworder" id="requestnameshoworder" onblur="checkPlusnumber2(this)" type="text" size=4 value="<%=requestnameshoworder %>">
										</TD>
										<TD>
											<input class="_open" name="requestnameopen" <%if(requestnameopen.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
										<TD>
											<input class="_readonly" name="requestnamereadonly" <%if(requestnamereadonly.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
									</TR>
									<tr class="Spacing" style="height:1px!important;"><td colspan="5" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(33806, user.getLanguage())%></TD>
										<TD>
											<%
												String workflowtypestr[] = Util.TokenizerString2(workflowtype,",");
												String workflowtypess = "";
												for(int i=0;i<workflowtypestr.length;i++){
													if(!workflowtypestr[i].equals("")&&!workflowtypestr[i].equals("0")){
														workflowtypess += (!workflowtypess.equals("")?",":"") + WorkflowComInfo.getWorkflowname(workflowtypestr[i]);
													}
												}
											%>
											<brow:browser viewType="0"
												hasInput="true" hasBrowser="true"
												isMustInput="1" completeUrl="/data.jsp?type=-99991"
												browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MutiWorkflowBrowser.jsp?selectedids="
												isSingle="false"
												name="workflowtype"
												browserValue='<%=workflowtype%>'
												browserSpanValue='<%=workflowtypess%>'>
											</brow:browser>
										</TD>
										<TD>
											<input onblur="checkPlusnumber2(this)" name="workflowtypeshoworder" value="<%=workflowtypeshoworder%>" id="workflowtypeshoworder" type="text" size=4>
										</TD>
										<TD>
											<input class="_open" name="workflowtypeopen" <%if(workflowtypeopen.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
										<TD>
											<input class="_readonly" name="workflowtypereadonly" <%if(workflowtypereadonly.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
									</TR>
									<tr class="Spacing" style="height:1px!important;"><td colspan="5" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(19502, user.getLanguage())%></TD>
										<TD>
											<input name="Processnumber" id="Processnumber" value="<%=Util.toScreenForWorkflowReadOnly(Processnumber) %>" class="Inputstyle">
										</TD>
										<TD>
											<input name="Processnumbershoworder" onblur="checkPlusnumber2(this)" value="<%=Processnumbershoworder %>" id="Processnumbershoworder" type="text" size=4>
										</TD>
										<TD>
											<input class="_open" name="Processnumberopen" type="checkbox" value="1" <%if(Processnumberopen.equals("1")){%> checked <%}%>>
										</TD>
										<TD>
											<input class="_readonly" name="Processnumberreadonly" type="checkbox" value="1" <%if(Processnumberreadonly.equals("1")){%> checked <%}%>>
										</TD>
									</TR>
									<tr class="Spacing" style="height:1px!important;"><td colspan="5" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(882, user.getLanguage())%></TD>
										<TD style="white-space: nowrap;">
											<select name="createtype" id="createtype" onchange="onSelectChanged(this, 'createtypeid');" style="float:left;" _type="1" _formFieldType="1,17,165,166">
												<option value="0"></option>
												<option value="1" <%if("1".equals(createtype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(20558, user.getLanguage())%></option>
												<option value="2" <%if("2".equals(createtype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelNames("17908,30042", user.getLanguage())%></option>
												<option value="3" <%if("3".equals(createtype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(23182, user.getLanguage())%></option>
											</select>
											<span id="createtypeidSpan" <%if(!"2".equals(createtype) && !"3".equals(createtype)){%> style="display: none" <%}%>>
												<%
													String createtypeidss = "";
													if ("2".equals(createtype)) {
														String createtypeidstr[] = Util.TokenizerString2(createtypeid,",");
														for(int i=0;i<createtypeidstr.length;i++){
															if(!createtypeidstr[i].equals("")&&!createtypeidstr[i].equals("0")){
																createtypeidss += (!createtypeidss.equals("")?",":"") + ResourceComInfo.getResourcename(createtypeidstr[i]);
															}
														}
													} else if ("3".equals(createtype)) {
														createtypeidss = WorkflowSearchUtil.getFieldName(formid, createtypeid, isbill, "7");
													}
												%>
												<brow:browser viewType="0" width="200px"
													hasInput="true" hasBrowser="true"
													isMustInput="2" completeUrl="javascript:getCompleteUrl('#createtype');"
													getBrowserUrlFn="getCreatetypeidBrowserUrl"
													isSingle='<%="2".equals(createtype) ? "false" : "true"%>'
													name="createtypeid"
													browserValue='<%=createtypeid%>'
													browserSpanValue='<%=createtypeidss%>'>
												</brow:browser>
											</span>
										</TD>
										<TD>
											<input name="createtypeidshoworder" onblur="checkPlusnumber2(this)" value="<%=createtypeidshoworder%>" id="createtypeidshoworder" type="text" size=4>
										</TD>
										<TD>
											<input class="_open" name="createtypeidopen" <%if(createtypeidopen.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
										<TD>
											<input class="_readonly" name="createtypeidreadonly" <%if(createtypeidreadonly.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
									</TR>
									<tr class="Spacing" style="height:1px!important;"><td colspan="5" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(19225, user.getLanguage())%></TD>
										<TD>
											<select name="createdepttype" id="createdepttype" onchange="onSelectChanged(this, 'department');" style="float:left;" _type="4" _formFieldType="4,57,167,168,1,17,165,166">
												<option value="0"></option>
												<option value="1" <%if("1".equals(createdepttype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelNames("20558,27511", user.getLanguage())%></option>
												<option value="2" <%if("2".equals(createdepttype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(19438, user.getLanguage())%></option>
												<option value="3" <%if("3".equals(createdepttype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(23182, user.getLanguage())%></option>
											</select>
											<span id="departmentSpan" <%if(!"2".equals(createdepttype) && !"3".equals(createdepttype)){%>style="display: none" <%}%>>
												<%
													String departmentnames = "";
													if ("2".equals(createdepttype)) {
														String departments[] = Util.TokenizerString2(department,",");
														for(int i=0;i<departments.length;i++){
															if(!departments[i].equals("")&&!departments[i].equals("0")){
																departmentnames += (!departmentnames.equals("")?",":"") + DepartmentComInfo.getDepartmentname(departments[i]);
															}
														}
													} else if ("3".equals(createdepttype)) {
														departmentnames = WorkflowSearchUtil.getFieldName(formid, department, isbill, "7");
													}
												%>
												<brow:browser viewType="0" width="200px"
													hasInput="true" hasBrowser="true"
													isMustInput="2" completeUrl="javascript:getCompleteUrl('#createdepttype');"
													getBrowserUrlFn="getDepartmentBrowserUrl"
													isSingle='<%="2".equals(createdepttype) ? "false" : "true"%>'
													name="department"
													browserValue='<%=department%>'
													browserSpanValue='<%=departmentnames%>'>
												</brow:browser>
											</span>
										</TD>
										<TD>
											<input name="departmentshoworder" onblur="checkPlusnumber2(this)" value="<%=departmentshoworder %>" id="departmentshoworder" type="text" size=4>
										</TD>
										<TD>
											<input class="_open" name="createdeptidopen" <%if(createdeptidopen.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
										<TD>
											<input class="_readonly" name="createdeptidreadonly" <%if(createdeptidreadonly.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
									</TR>
									<tr class="Spacing" style="height:1px!important;"><td colspan="5" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(22788, user.getLanguage())%></TD>
										<TD>
											<select name="createsubtype" id="createsubtype" onchange="onSelectChanged(this, 'createsubid');" style="float:left;" _type="164" _formFieldType="164,194,169,170,4,57,167,168,1,17,165,166">
												<option value="0"></option>
												<option value="1" <%if("1".equals(createsubtype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelNames("20558,33553", user.getLanguage())%></option>
												<option value="2" <%if("2".equals(createsubtype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(19437, user.getLanguage())%></option>
												<option value="3" <%if("3".equals(createsubtype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(23182, user.getLanguage())%></option>
											</select>
											<SPAN id="createsubidSpan" <%if(!"2".equals(createsubtype) && !"3".equals(createsubtype)){%> style="display: none" <%}%>>
												<%
													String subsames = "";
													if ("2".equals(createsubtype)) {
														String subs[] = Util.TokenizerString2(createsubid,",");
														for(int i=0;i<subs.length;i++){
															if(!subs[i].equals("")&&!subs[i].equals("0")){
																subsames += (!subsames.equals("")?",":"") +SubCompanyComInfo.getSubCompanydesc(""+subs[i]);
															}
														}
													} else if ("3".equals(createsubtype)) {
														subsames = WorkflowSearchUtil.getFieldName(formid, createsubid, isbill, "7");
													}
						  						%>
						  						<brow:browser viewType="0" width="200px"
													hasInput="true" hasBrowser="true"
													isMustInput="2" completeUrl="javascript:getCompleteUrl('#createsubtype');"
													getBrowserUrlFn="getCreatesubidBrowserUrl"
													isSingle='<%="2".equals(createsubtype) ? "false" : "true"%>'
													name="createsubid"
													browserValue='<%=createsubid%>'
													browserSpanValue='<%=subsames%>'>
												</brow:browser>
						  					</SPAN>
										</TD>
										<TD>
											<input name="cjrfbshoworder" onblur="checkPlusnumber2(this)" value="<%=cjrfbshoworder%>" id="cjrfbshoworder" type="text" size=4>
										</TD>
										<TD>
											<input class="_open" name="createsubidopen" <%if(createsubidopen.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
										<TD>
											<input class="_readonly" name="createsubidreadonly" <%if(createsubidreadonly.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
									</TR>
									<tr class="Spacing" style="height:1px!important;"><td colspan="5" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(722, user.getLanguage())%></TD>
										<TD>
											<select name="createdatetype" id="createdatetype" style="float:left;">
												<option value="1" <%if("1".equals(createdatetype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
												<option value="2" <%if("2".equals(createdatetype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15537, user.getLanguage())%></option>
												<option value="3" <%if("3".equals(createdatetype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15539, user.getLanguage())%></option>
												<option value="4" <%if("4".equals(createdatetype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15541, user.getLanguage())%></option>
												<option value="5" <%if("5".equals(createdatetype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(21904, user.getLanguage())%></option>
												<option value="6" <%if("6".equals(createdatetype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(15384, user.getLanguage())%></option>
												<option value="7" <%if("7".equals(createdatetype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(32530, user.getLanguage())%></option>
												<option value="8" <%if("8".equals(createdatetype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(23182, user.getLanguage())%></option>
											</select>
											<span id="createdatetypediv" <%if(!createdatetype.equals("7")){%> style="display: none" <%}%>>
												&nbsp;
												<BUTTON class=Calendar type="button" id=selectbirthday onclick="getTheStartDate('createdatestart','createdatestartspan','createdateend','createdateendspan')"></BUTTON>
												<SPAN id=createdatestartspan><%=createdatestart%></SPAN> -
												<BUTTON class=Calendar type="button" id=selectbirthday1 onclick="getTheendDate('createdatestart','createdatestartspan','createdateend','createdateendspan')"></BUTTON>
												<SPAN id=createdateendspan><%=createdateend%></SPAN>
												<input type="hidden" id=createdatestart name="createdatestart" value="<%=createdatestart%>"> <input type="hidden" id=createdateend name="createdateend" value="<%=createdateend%>">
											</span>
											<SPAN id=createdatefieldidSpan <%if(!"8".equals(createdatetype)){%> style="display: none" <%}%>>
												<%
													String createdatefieldname = "";
												    if (!"".equals(createdatefieldid)) {
												    	createdatefieldname = WorkflowSearchUtil.getFieldName(formid, createdatefieldid, isbill, "7");
												    }
						  						%>
						  						<brow:browser viewType="0" width="200px"
													hasInput="true" hasBrowser="true"
													isMustInput="2" completeUrl="javascript:getFormFieldCompleteUrl('2');"
													getBrowserUrlFn="getFormFieldBrowserUrl"
													getBrowserUrlFnParams="2"
													isSingle="true"
													name="createdatefieldid"
													browserValue='<%=createdatefieldid%>'
													browserSpanValue='<%=createdatefieldname%>'>
												</brow:browser>
						  					</SPAN>
										</TD>
										<TD>
											<input name="createdatetypeshoworder" onblur="checkPlusnumber2(this)" value="<%=createdatetypeshoworder %>" id="createdatetypeshoworder" type="text" size=4>
										</TD>
										<TD>
											<input class="_open" name="createdateopen" <%if(createdateopen.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
										<TD>
											<input class="_readonly" name="createdatereadonly" <%if(createdatereadonly.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
									</TR>
									<tr class="Spacing" style="height:1px!important;"><td colspan="5" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(782, user.getLanguage())%></TD>
										<TD>
											<select name="xgxmtype" id="xgxmtype" onchange="onSelectChanged(this, 'xgxmid');" style="float:left;" _type="8" _formFieldType="8,135">
												<option value="0"></option>
												<option value="2" <%if("2".equals(xgxmtype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelNames("17908,25106", user.getLanguage())%></option>
												<option value="3" <%if("3".equals(xgxmtype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(23182, user.getLanguage())%></option>
											</select>
											<SPAN id=xgxmidSpan <%if(!"2".equals(xgxmtype) && !"3".equals(xgxmtype)){%> style="display: none" <%}%>>
												<%
													String projname = "";
													if(!"".equals(xgxmid)) {
														if ("2".equals(xgxmtype)) {
															String st[]=xgxmid.split(",");
															for(int i=0;i<st.length;i++){
														  		String str01=""+st[i];
														  		if(!str01.equals("")){
															  		projname += "  "+ProjectInfoComInfo.getProjectInfoname(str01);
														  		}
														 	}
														} else if ("3".equals(xgxmtype)) {
															projname = WorkflowSearchUtil.getFieldName(formid, xgxmid, isbill, "7");
														}
													}
						     				 	%>
						     				 	<brow:browser viewType="0" width="200px"
													hasInput="true" hasBrowser="true"
													isMustInput="2" completeUrl="javascript:getCompleteUrl('#xgxmtype');"
													getBrowserUrlFn="getXgxmidBrowserUrl"
													isSingle='<%="2".equals(xgxmtype) ? "false" : "true"%>'
													name="xgxmid"
													browserValue='<%=xgxmid%>'
													browserSpanValue='<%=projname%>'>
												</brow:browser>
					     				 	</SPAN>
										</TD>
										<TD>
											<input name="xgxmidshoworder" onblur="checkPlusnumber2(this)" value="<%=xgxmidshoworder%>" id="xgxmidshoworder" type="text" size=4>
										</TD>
										<TD>
											<input class="_open" name="xgxmidopen" <%if(xgxmidopen.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
										<TD>
											<input class="_readonly" name="xgxmidreadonly" <%if(xgxmidreadonly.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
									</TR>
									<tr class="Spacing" style="height:1px!important;"><td colspan="5" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(783, user.getLanguage())%></TD>
										<TD>
											<select name="xgkhtype" id="xgkhtype" onchange="onSelectChanged(this, 'xgkhid');" style="float:left;" _type="7" _formFieldType="7,18">
												<option value="0"></option>
												<option value="2" <%if("2".equals(xgkhtype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(18647, user.getLanguage())%></option>
												<option value="3" <%if("3".equals(xgkhtype)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(23182, user.getLanguage())%></option>
											</select>
											<SPAN id=xgkhidSpan <%if(!"2".equals(xgkhtype) && !"3".equals(xgkhtype)){%> style="display: none" <%}%>>
												<%
													String crmname = "";
													if(!"".equals(xgkhid)) {
														if ("2".equals(xgkhtype)) {
															String st[]=xgkhid.split(",");
															for(int i=0;i<st.length;i++){
																String str01=""+st[i];
																if(!str01.equals("")){
															  		crmname += "  "+crmComInfo.getCustomerInfoname(str01);
														  		}
														 	}
														} else if ("3".equals(xgkhtype)) {
															crmname = WorkflowSearchUtil.getFieldName(formid, xgkhid, isbill, "7");
														}
														
													}
						      					%>
						     				 	<brow:browser viewType="0" width="200px"
													hasInput="true" hasBrowser="true"
													isMustInput="2" completeUrl="javascript:getCompleteUrl('#xgkhtype');"
													getBrowserUrlFn="getXgkhidBrowserUrl"
													isSingle='<%="2".equals(xgkhtype) ? "false" : "true"%>'
													name="xgkhid"
													browserValue='<%=xgkhid%>'
													browserSpanValue='<%=crmname%>'>
												</brow:browser>
					      					</SPAN>
										</td>
										</TD>
										<TD>
											<input name="xgkhidshoworder" onblur="checkPlusnumber2(this)" value="<%=xgkhidshoworder %>" id="xgkhidshoworder" type="text" size=4>
										</TD>
										<TD>
											<input class="_open" name="xgkhidopen" <%if(xgkhidopen.equals("1")){%> checked <%} %> type="checkbox" value="1">
										</TD>
										<TD>
											<input class="_readonly" name="xgkhidreadonly" <%if(xgkhidreadonly.equals("1")){%> checked <%} %> type="checkbox" value="1">
										</TD>
									</TR>
									<tr class="Spacing" style="height:1px!important;"><td colspan="5" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
									<%
										if(!"no".equals(isornshow)) {
									%>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(15112, user.getLanguage())%></TD>
										<TD>
											<select name="gdtype" id="gdtype">
												<option value="0" <%if(gdtype.equals("")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
												<option value="1" <%if(gdtype.equals("1")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(17999, user.getLanguage())%></option>
												<option value="2" <%if(gdtype.equals("2")){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(18800, user.getLanguage())%></option>
											</select>
										</TD>
										<TD>
											<input onblur="checkPlusnumber2(this)" name="gdtypeshoworder" value="<%=gdtypeshoworder %>" id="gdtypeshoworder" type="text" size=4>
										</TD>
										<TD>
											<input class="_open" name="gdtypeopen" <%if(gdtypeopen.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
										<TD>
											<input class="_readonly" name="gdtypereadonly" <%if(gdtypereadonly.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
									</TR>
									<tr class="Spacing" style="height:1px!important;"><td colspan="5" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
									<%}%>
									<TR>
										<TD><%=SystemEnv.getHtmlLabelName(31787,user.getLanguage()) %></TD>
										<TD>
											<select id="jsqjtype" name="jsqjtype">
												<%
										          ArrayList list= Util.TokenizerString(wfdateduring,",");
										          for(int i=0;i<list.size();i++){
										        	  String qjdate=(String)list.get(i);
									            %>
												<option value="<%=qjdate %>" <%if(jsqjtype.equals(qjdate)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(128935,user.getLanguage())%><%=qjdate%><%=SystemEnv.getHtmlLabelName(26301,user.getLanguage())%></option>
												<%}%>
												<option value="38" <%if(jsqjtype.equals(""+38)){%> selected <%}%>><%=SystemEnv.getHtmlLabelName(332, user.getLanguage())%></option>
											</select>
										</TD>
										<TD>
											<input name="jsqjtypeshoworder" onblur="checkPlusnumber2(this)" value="<%=jsqjtypeshoworder %>" id="jsqjtypeshoworder" type="text" size=4>
										</TD>
										<TD>
											<input class="_open" name="jsqjtypeopen" <%if(jsqjtypeopen.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
										<TD>
											<input class="_readonly" name="jsqjtypereadonly" <%if(jsqjtypereadonly.equals("1")){%> checked <%}%> type="checkbox" value="1">
										</TD>
									</TR>
									<tr class="Spacing" style="height:1px!important;"><td colspan="5" class="paddingLeft18"><div class="intervalDivClass"></div></td></tr>
								</tbody>
							</table>

						</wea:item>
					</wea:group>
				</wea:layout>

			</FORM>
		</div>
		</div>

		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout needImportDefaultJsAndCss="false">
				<wea:group context="" attributes="{\"groupDisplay\":\"none\"}">
					<wea:item type="toolbar">
				    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>" class="zd_btn_cancle" onclick="dialog.closeByHand();" style="width: 50px!important;">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		<!-- end -->
		
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
		RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:btnok_onclick(),_self}" ;
		RCMenuHeight += RCMenuHeightStep;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:btncz_onclick(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;

		RCMenu += "{"+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+",javascript:btnsc_onclick(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>

		<script type="text/javascript" src="/js/browser/WorkFlowBrowser_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/datetime_wev8.js"></script>
		<SCRIPT language="javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
		<script type="text/javascript">
			var parentWin = null;
			var dialog = null;
			try {
				parentWin = parent.parent.getParentWindow(parent);
				dialog = parent.parent.getDialog(parent);
			} catch(e) {}

			<%if (hasChangeData) {%>
				submitData();
			<%}%>

			jQuery(function() {
				jQuery("#checkAllOpen").click(function() {
					if (jQuery(this).is(':checked')) {
						changeCheckboxStatus('input[type="checkbox"]._open', true);
		        		disOrEnableCheckbox('input._readonly', true);
		        		changeCheckboxStatus('input._readonly', false);
			        } else {
			        	changeCheckboxStatus('input[type="checkbox"]._open', false);
		        		disOrEnableCheckbox('input._readonly', false);
		        		changeCheckboxStatus('#checkAllReadonly', false);
			        }
			    });

			    jQuery("#checkAllReadonly").click(function() {
					changeCheckboxStatus('input[type="checkbox"]._readonly:enabled', jQuery(this).is(':checked'));
			    });

			    var $openBox = jQuery("input._open");
			    $openBox.click(function() {
			        changeCheckboxStatus('#checkAllOpen', $openBox.length == jQuery("input._open:checked").length ? true : false);
			        var name = jQuery(this).attr('name');
			        if (name.length > 4) {
			        	name = name.substring(0, name.length - 4) + 'readonly';
				        if (jQuery(this).is(':checked')) {
			        		disOrEnableCheckbox('input[name="' + name + '"]._readonly', true);
			        		changeCheckboxStatus('input[name="' + name + '"]._readonly', false);
				        } else {
			        		disOrEnableCheckbox('input[name="' + name + '"]._readonly', false);
				        }
			        }
			        var $readonlyBoxTemp = jQuery("input._readonly:enabled");
			        changeCheckboxStatus('#checkAllReadonly', $readonlyBoxTemp.length == jQuery("input._readonly:checked").length ? true : false);
			    });

			    var $readonlyBox = jQuery("input._readonly");
			    $readonlyBox.click(function() {
			    	var $readonlyBoxTemp = jQuery("input._readonly:enabled");
			        changeCheckboxStatus('#checkAllReadonly', $readonlyBoxTemp.length == jQuery("input._readonly:checked").length ? true : false);
			    });

			    jQuery("#requestbs").blur(function() {
			       var requestbs=jQuery("#requestbs").val();
			        requestbs = jQuery.trim(requestbs);
			        if(requestbs==''){
			           jQuery("#requestbs").val('');
			           jQuery("#requestbsspan").html("<img src=/images/BacoError_wev8.gif align=absMiddle>");//<IMG src='/images/BacoError_wev8.gif' align=absMiddle>   
			        }else{
			          jQuery("#requestbsspan").html("");
			        }
			    });

				jQuery("#createdatetype").change(function() {
					var createdatetype = jQuery("#createdatetype").val();
					if(createdatetype == '7'){
						jQuery("#createdatetypediv").css('display','');
					} else {
						jQuery("#createdatetypediv").css('display','none');
				    }
				    _writeBackData('createdatefieldid', 1, {id:'',name:''});
					if(createdatetype == '8'){
						jQuery("#createdatefieldidSpan").show();
					} else {
						jQuery("#createdatefieldidSpan").hide();
					}
				 });
		 });

		jQuery(document).ready(function() {
			var $openBoxTemp = jQuery("input._open:checked");
			$openBoxTemp.each(function() {
				var name = jQuery(this).attr('name');
		        if (name.length > 4) {
		        	name = name.substring(0, name.length - 4) + 'readonly';
			        disOrEnableCheckbox('input[name="' + name + '"]._readonly', true);
		        }
			});
			if (jQuery('input._open').length == $openBoxTemp.length) {
				changeCheckboxStatus('#checkAllOpen', true);
			}
			if (jQuery('input._readonly').length == jQuery("input._readonly:checked").length) {
				changeCheckboxStatus('#checkAllReadonly', true);
			}
			resizeDialog(document);
		});

		function submitData() {
			if (dialog) {
				dialog.callback();
			} else {
				window.parent.parent.close();
			}
		}

		function getCreatetypeidBrowserUrl() {
			var valueType = jQuery('#createtype').val();
			if (valueType == '2') {
				return "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?selectedids=" + jQuery('#createtypeid').val();
			} else if (valueType == '3') {
				return getFormFieldBrowserUrl('1,17,165,166');
			}
		}

		function getDepartmentBrowserUrl() {
			var valueType = jQuery('#createdepttype').val();
			if (valueType == '2') {
				return "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" + jQuery('#department').val();
			} else if (valueType == '3') {
				return getFormFieldBrowserUrl('4,57,167,168,1,17,165,166');
			}
		}

		function getCreatesubidBrowserUrl() {
			var valueType = jQuery('#createsubtype').val();
			if (valueType == '2') {
				return "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=" + jQuery('#createsubid').val();
			} else if (valueType == '3') {
				return getFormFieldBrowserUrl('164,194,169,170,4,57,167,168,1,17,165,166');
			}
		}

		function getXgxmidBrowserUrl() {
			var valueType = jQuery('#xgxmtype').val();
			if (valueType == '2') {
				return "/systeminfo/BrowserMain.jsp?url=/proj/data/MultiProjectBrowser.jsp?projectids=" + jQuery('#xgxmid').val();
			} else if (valueType == '3') {
				return getFormFieldBrowserUrl('8,135');
			}
		}

		function getXgkhidBrowserUrl() {
			var valueType = jQuery('#xgkhtype').val();
			if (valueType == '2') {
				return "/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids=" + jQuery('#xgkhid').val();
			} else if (valueType == '3') {
				return getFormFieldBrowserUrl('7,18');
			}
		}

		function getFormFieldBrowserUrl(type) {
			return '/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowFormFieldBrowser.jsp?wfid=<%=workflowid%>&fieldid=<%=fieldid%>&type=' + type;
		}

		function getCompleteUrl(selObj) {
			var valueType = jQuery(selObj).val();
			if (valueType == '2') {
				return '/data.jsp?type=' + jQuery(selObj).attr('_type');
			} else if (valueType == '3') {
				return getFormFieldCompleteUrl(jQuery(selObj).attr('_formFieldType'));
			}
		}

		function getFormFieldCompleteUrl(type) {
			return '/data.jsp?type=fieldBrowser&wfid=<%=workflowid%>&fieldid=<%=fieldid%>&htmltype=3&ftype=' + type;
		}

		function onSelectChanged(selObj, eleId) {
			var valueType = jQuery(selObj).val();
			if (valueType == '2') {
				var eleSpan = jQuery('#' + eleId + 'Span').empty();
				var oDiv = document.createElement("div");
				eleSpan.append(oDiv);
				jQuery(oDiv).e8Browser({
						name: eleId,
						viewType: '0',
						isMustInput: '2',
						getBrowserUrlFn: getBrowserUrlFunName(eleId),
						hasInput: true,
						isSingle: false,
						completeUrl: 'javascript:getCompleteUrl("#'+jQuery(selObj).attr('id')+'")',
						hasAdd: false,
						width: '200px'
				});
				jQuery('#' + eleId + 'Span').css('display', '');
			} else if (valueType == '3') {
				var eleSpan = jQuery('#' + eleId + 'Span').empty();
				var oDiv = document.createElement("div");
				eleSpan.append(oDiv);
				jQuery(oDiv).e8Browser({
						name: eleId,
						viewType: '0',
						isMustInput: '2',
						getBrowserUrlFn: getBrowserUrlFunName(eleId),
						hasInput: true,
						isSingle: true,
						completeUrl: 'javascript:getCompleteUrl("#'+jQuery(selObj).attr('id')+'")',
						hasAdd: false,
						width: '200px'
				});
				jQuery('#' + eleId + 'Span').css('display', '');
			} else {
				_writeBackData(eleId, 2, {id:'',name:''});
				jQuery('#' + eleId + 'Span').css('display', 'none');
			}
		}

		function getBrowserUrlFunName(eleId) {
			var funName = 'get';
			funName += eleId.substring(0, 1).toUpperCase();
			funName += eleId.substring(1);
			funName += 'BrowserUrl';
			return funName;
		}

		function getTheStartDate(inputname,spanname,inputname2,spanname2){
			WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
				var returnvalue = dp.cal.getDateStr();
				$dp.$(inputname).value = returnvalue;
				  onShowBeginDate2(returnvalue,inputname,spanname,inputname2,spanname2);
				}
				,oncleared:function(dp){
				  $dp.$(inputname).value = ''
				}});
		}

		function getTheendDate(inputname,spanname,inputname2,spanname2){
			WdatePicker({lang:languageStr,el:spanname2,onpicked:function(dp){
				var returnvalue = dp.cal.getDateStr();
				$dp.$(inputname2).value = returnvalue;
				  onShowBeginDate2(returnvalue,inputname,spanname,inputname2,spanname2);
				}
				,oncleared:function(dp){
				 $dp.$(inputname).value = ''
				}});
		
		}

		function onShowBeginDate2(returnvalue,inputname,spanname,inputname2,spanname2){
			var date1=jQuery("#"+inputname).val();
			var date2=jQuery("#"+inputname2).val();
			if(date2!=''){
				if(date1>date2){
					top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(16721, user.getLanguage())%>");
					jQuery("#"+inputname).val("");
					jQuery("#"+inputname2).val("");
					$G(spanname).innerHTML = "";
					$G(spanname2).innerHTML = "";
				}
			}
		}

		function onShowWorkFlowBase(inputname, spanname) {
			var retValue = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/MutilWorkflow_Browser.jsp", "", "dialogWidth:550px;dialogHeight:550px;");
			if (retValue != null) {
				if (wuiUtil.getJsonValueByIndex(retValue, 0) != "" ) {
					$G(spanname).innerHTML = wuiUtil.getJsonValueByIndex(retValue, 1).substr(1,wuiUtil.getJsonValueByIndex(retValue, 1).length);
					$G(inputname).value = wuiUtil.getJsonValueByIndex(retValue, 0).substr(1,wuiUtil.getJsonValueByIndex(retValue, 0).length);
				} else { 
					$G(inputname).value = "";
					$G(spanname).innerHTML = "";
				}
			}
		}

		function btncancel_onclick() {
			if (dialog) {
				dialog.closeByHand();
			} else {
				window.parent.parent.close();
			}
		}

		function btnsc_onclick(){//删除
			top.Dialog.confirm('<%=SystemEnv.getHtmlLabelNames("17048", user.getLanguage())%>', function() {
				jQuery("#optionmethod").val("del");
				document.frmMain.submit();
			});
		}

		function checkPlusnumber2(obj){
			var value=obj.value;
			var reg =/^\d{0,3}(\.\d{0,2})?$/g;
			if (!reg.test(value)){
			   obj.value = "0";
			} else {
			  
			}
		}

		function setSelectBoxValue(selector, value) {
			if (value == null) {
				value = jQuery(selector + ' option').first().val();
			}
			jQuery(selector).selectbox('change',value,jQuery(selector + ' option[value="'+value+'"]').text());
		}

		function btncz_onclick(){//重置--将表单中所有的设置清空
			jQuery("#requestbs").val("");
			jQuery("#requestbsspan").html("<IMG src=/images/BacoError_wev8.gif align=absMiddle>");

			jQuery("#requestname").val("");
			jQuery("#requestnameshoworder").val("1.0");

			_writeBackData("workflowtype", 1, {id:'',name:''});
			jQuery("#workflowtypeshoworder").val("2.0");

			jQuery("#Processnumber").val("");
			jQuery("#Processnumbershoworder").val("3.0");

			setSelectBoxValue('#createtype', '0');
			jQuery("#createtypeidshoworder").val("4.0");

			setSelectBoxValue('#createdepttype', '0');
			jQuery("#departmentshoworder").val("5.0");

			setSelectBoxValue('#createsubtype', '0');
			jQuery("#cjrfbshoworder").val("6.0");

			setSelectBoxValue('#createdatetype', '1');
			jQuery("#createdatestartspan").html("");
			jQuery("#createdateendspan").html("");
			jQuery("#createdatestart").val("");
			jQuery("#createdateend").val("");
			jQuery("#createdatetypeshoworder").val("7.0");

			setSelectBoxValue('#xgxmtype');
			jQuery("#xgxmidshoworder").val("8.0");

			setSelectBoxValue('#xgkhtype');
			jQuery("#xgkhidspan").html("");
			jQuery("#xgkhid").val("");
			jQuery("#xgkhidshoworder").val("9.0");

			setSelectBoxValue('#gdtype', '0');
			jQuery("#gdtypeshoworder").val("10.0");

			setSelectBoxValue('#jsqjtype');
			jQuery("#jsqjtypeshoworder").val("11.0");

			jQuery('input[type="checkbox"]').each(function() {
				changeCheckboxStatus(this, false);
				disOrEnableCheckbox(this, false);
			});
		}

		
		function checkDataValid() {
			var requiredInputs = jQuery('#frmMain input:hidden[ismustinput="2"]');
			for (var i = 0; i < requiredInputs.length; i++) {
				var browserInput = jQuery(requiredInputs[i]);
				var browserSpan = jQuery('span#' + browserInput.attr('name') + 'Span');
				if ((browserSpan.is(':visible') || browserSpan.css('display') != 'none') && browserInput.val() == '') {
					return false;
				}
			}
			return true;
		}

		function btnok_onclick(){//保存
		  var requestbs = jQuery("#requestbs").val();
		      requestbs = jQuery.trim(requestbs);
		  if (requestbs == '') {
		      top.Dialog.alert('<%=SystemEnv.getHtmlLabelNames("84,18622", user.getLanguage())%>');
		      return;
		  } else {
		  		if (checkDataValid()) {
					jQuery("#optionmethod").val("add");
					document.frmMain.submit();
		  		} else {
		  			top.Dialog.alert('<%=SystemEnv.getHtmlLabelNames("30933", user.getLanguage())%>');
					return;
		  		}
		   }
		}
	</script>
</BODY>
</HTML>
