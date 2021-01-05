
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@page import="weaver.parseBrowser.SapBrowserComInfo"%>
<%@page import="weaver.hrm.resource.ResourceComInfo"%>
<%@page import="weaver.hrm.roles.RolesComInfo"%>
<%@page import="weaver.workflow.workflow.WorkflowComInfo"%>
<%@page import="weaver.parseBrowser.SapBaseBrowser"%>
<%@page import="weaver.parseBrowser.Field"%>
<%@page import="weaver.parseBrowser.StructField"%>
<%@page import="weaver.parseBrowser.TableField"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page"/>
<jsp:useBean id="ResourceComInfo" class="ResourceComInfo" scope="page"/>
<jsp:useBean id="RolesComInfo" class="RolesComInfo" scope="page"/>
<jsp:useBean id="WorkflowComInfo" class="WorkflowComInfo" scope="page"/>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</head>
<style>
		.filed{
			background-color: rgb(222,222,222);
		}
		.filed02{
			background-color: rgb(245,250,250);
		}
</style>
<%
if(!HrmUserVarify.checkUserRight("SAPBrowserSetting:Manage",user)) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

String imagefilename = "/images/hdSystem_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(28229,user.getLanguage());
String needfav ="1";
String needhelp ="";

SapBrowserComInfo sbc = new SapBrowserComInfo();

String sapbrowserid = Util.null2String(request.getParameter("sapbrowserid"));
String function = "";

List assignmentList = new ArrayList();
List export_outputList = new ArrayList();
List import_inputList = new ArrayList();
List struct_inputList = new ArrayList();
List struct_outputList = new ArrayList();
List table_inputList = new ArrayList();
List table_outputList = new ArrayList();

String authFlag = "";
String wfids = "";

String existssapbrowserid = "";

if(!sapbrowserid.equals("")){
	SapBaseBrowser sbb = sbc.getSapBaseBrowser(sapbrowserid);
	if(sbb != null){
		existssapbrowserid = Util.null2String(sbb.getSapbrowserid());
		function = sbb.getFunction();
		assignmentList = sbb.getAssignment();
		export_outputList = sbb.getExport_output();
		import_inputList = sbb.getImport_input();
		struct_inputList = sbb.getStruct_input();
		struct_outputList = sbb.getStruct_output();
		table_inputList = sbb.getTable_input();
		table_outputList = sbb.getTable_output();
		authFlag = Util.null2String(sbb.getAuthFlag());
		wfids = Util.null2String(sbb.getAuthWorkflowID());
	}
	
}

boolean isnew = sapbrowserid.equals("") || existssapbrowserid.equals("");



%>


<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onSubmit(this),_self} " ;
RCMenuHeight += RCMenuHeightStep ;
if(!sapbrowserid.equals("") && sapbrowserid.equals(existssapbrowserid)){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDelete(this),_self} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",sapbrowsersetting.jsp,_self} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM style="MARGIN-TOP: 0px" name=frmMain method=post action="sapbrowsersettingOperation.jsp">
	<input type="hidden" id="operation" name="operation">
	<input type="hidden" id="method" name="method">
	
	<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
	<colgroup>
	<col width="10">
	<col width="">
	<col width="10">
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	<tr>
		<td ></td>
		<td valign="top">
			<TABLE class=Shadow>
			<tr>
			<td valign="top">
				
				<span style="color: red;">
					<%
					String saveFlag = Util.null2String(request.getParameter("saveFlag")); 
					String deleteFlag = Util.null2String(request.getParameter("deleteFlag")); 
					if(saveFlag.equals("S")){
						out.print(SystemEnv.getHtmlLabelName(18758,user.getLanguage()) + "!");
					}else if(saveFlag.equals("E")){
						out.print(SystemEnv.getHtmlLabelName(21809,user.getLanguage()));
					}
					if(deleteFlag.equals("E")){
						out.print(SystemEnv.getHtmlLabelName(20462,user.getLanguage()) + "!");
					}
					%>
				</span>
				
				<table class=ViewForm>
					<COLGROUP> 
					<COL width="20%"> 
					<COL width="80%">
					<TBODY>
						<TR class=Title>
						  <TH colSpan=2><%=titlename%></TH>
						</TR>
						
						
						<TR class=Spacing style="height:1px;">
						  <TD class=Line1 colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(28230,user.getLanguage()) %></td>
							<td class="Field">
								<%if(isnew){ %>
								<input type="text" class="inputstyle" name="sapbrowserid" id="sapbrowserid" value="<%=sapbrowserid %>" size="60" maxlength="60" onchange="checkinput('sapbrowserid','sapbrowseridspan');checkexists(this)">
								<%}else{ %>
								<input type="text" disabled="disabled" class="inputstyle" value="<%=sapbrowserid %>" size="60">
								<input type="hidden" name="sapbrowserid" id="sapbrowserid" value="<%=sapbrowserid %>">
								<%} %>
								<span id="sapbrowseridspan">
									<%if(sapbrowserid.equals("")){ %>
									<img src='/images/BacoError_wev8.gif' align=absmiddle>
									<%}%>
								</span>
								<span id="checkexistsspan" style="color: red;"></span>
								<%=SystemEnv.getHtmlLabelName(31895,user.getLanguage()) %>
							</td>
						</tr>
						
						
						<TR class=Spacing style="height:1px;">
						  <TD class=Line colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(31896,user.getLanguage()) %></td>
							<td class="Field">
								<input onclick="changeAuthFlag(this)" type="checkbox" class="inputstyle" name="authFlag" id="authFlag" value="Y" <%if(authFlag.equalsIgnoreCase("Y")){out.print("checked='checked'");} %>>
							</td>
						</tr>
						
						<TR class=Spacing style="height:1px;">
						  <TD class=Line colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(31897,user.getLanguage()) %></td>
							<td class="Field">
								<BUTTON type="button" class=Browser onClick="onShowWorkflow('wfid','wfNamespan')" id="ShowWorkflow" name=ShowWorkflow <%if(!authFlag.equalsIgnoreCase("Y")){out.print("disabled='disabled'");} %>></BUTTON>
								<SPAN id=wfNamespan>
								<%if(authFlag.equalsIgnoreCase("Y") && wfids.equals("")){%>
								<img src='/images/BacoError_wev8.gif' align=absmiddle>
								<%}else{
									String[] wfidarr = Util.TokenizerString2(wfids,",");
									String wfnames = "";
									for(int i = 0; i<wfidarr.length; i++){
										wfnames += WorkflowComInfo.getWorkflowname(wfidarr[i]) + ",";
									}
									if(wfnames.length() > 0){
										wfnames = wfnames.substring(0,wfnames.length()-1);
									}
								%>
								<%=wfnames %>
								<%} %>
								</SPAN>
								<input type=hidden name="wfid" id="wfid" value="<%=wfids %>">
								<input type=hidden name="wfNames" id="wfNames">
							</td>
						</tr>
						
						
						<TR class=Spacing style="height:1px;">
						  <TD class=Line colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(28231,user.getLanguage()) %></td>
							<td class="Field">
								<input type="text" class="inputstyle" name="function" id="function" value="<%=function %>" size="60" onchange="checkinput('function','functionspan')">
								<span id="functionspan">
									<%if(function.equals("")){ %>
									<img src='/images/BacoError_wev8.gif' align=absmiddle>
									<%}%>
								</span>
							</td>
						</tr>
						
						
						<TR class=Spacing style="height:1px;">
						  <TD class=Line colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(28245,user.getLanguage()) %></td>
							<td class="Field">
								<table class=ViewForm>
									<tr>
										<td colspan="1">
											<BUTTON class = btnNew onClick = "addRow_InputParam();"><%=SystemEnv.getHtmlLabelName(17998 , user.getLanguage())%></BUTTON>
								    		<BUTTON class = btnDelete onClick = "javascript:deleteRow_InputParam()"><%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>
										</td>
									</tr>
									<TR class=Spacing style='height:2px;'><TD style='background-color: white;' colSpan=10></TD></TR>
									
									<tr>
										<td>
											<table class="ViewForm" id="oTable_elmt_InputParam" cols="4">
												<COLGROUP> 
												<COL width="4%"> 
												<COL width="32%">
												<COL width="32%">
												<COL width="32%">
												</COLGROUP>
												<tbody>
													<%
													if(import_inputList != null && import_inputList.size() > 0){
														for(int i = 0; i<import_inputList.size(); i++){
															Field field = (Field)import_inputList.get(i);
													%>
													<tr>
														<td>
															<div>
																<input type="checkbox" name="check_node_ImportParam" id="check_node_importParam_<%=i %>">
															</div>
														</td>
														<td>
														<%=SystemEnv.getHtmlLabelName(28247,user.getLanguage()) %>
														<input type="text" class="inputstyle" name="sapfieldname_importparam" id="sapfieldname_importparam_<%=i %>" value="<%=field.getName() %>" onchange="checkinput('sapfieldname_importparam_<%=i %>','sapfieldname_importparamspan_<%=i %>')">
														<span id="sapfieldname_importparamspan_<%=i %>"></span>
														</td>
														<td>
														<%=SystemEnv.getHtmlLabelName(28248,user.getLanguage()) %>
														<input type="text" class="inputstyle" name="oafieldname_importparam" id="oafieldname_importparam_<%=i %>" value="<%=field.getFromOaField() %>">
														</td>
														<td>
														<%=SystemEnv.getHtmlLabelName(28249,user.getLanguage()) %>
														<input type="text" class="inputstyle" name="constant_importparam" id="constant_importparam_<%=i %>" value="<%=field.getConstant() %>">
														</td>
													</tr>
													<%
														}
													}
													%>
												</tbody>
											</table>
										</td>
									</tr>
									
								</table>
							</td>
						</tr>
						
						
						<TR class=Spacing style="height:1px;">
						  <TD class=Line colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(28251,user.getLanguage()) %></td>
							<td class="Field">
								<table class="ViewForm">
									<tr>
										<td colspan="1">
											<input type="hidden" name="inputstructcount" id="inputstructcount" value="<%=struct_inputList.size() %>">
											<BUTTON class = btnNew onClick = "addRow_InputStruct();"><%=SystemEnv.getHtmlLabelName(28252,user.getLanguage())%></BUTTON>
								    		<BUTTON class = btnDelete onClick = "javascript:deleteRow_InputStruct()"><%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>
										</td>
									</tr>
									<TR class=Spacing style='height:2px;'><TD style='background-color: white;' colSpan=10></TD></TR>
									<tr>
										<td>
											<table class="ViewForm" id="oTable_elmt_InputStruct" cols="2">
												<COLGROUP> 
												<COL width="4%"> 
												<COL width="96%">
												</COLGROUP>
												<tbody>
												<%
												if(struct_inputList != null && struct_inputList.size() > 0){
													for(int i = 0; i<struct_inputList.size(); i++){
														StructField struct = (StructField)struct_inputList.get(i);
														String structName = struct.getStructName();
														List structFields = struct.getStructFieldList();
												%>
													<tr>
														<td>
															<div>
																<input type="checkbox" name="check_node_ImportStruct" id="check_node_ImportStruct_<%=i %>">
															</div>
														</td>
														<td>
															<table class="ViewForm">
																<tr>
																	<td>
																		<%=SystemEnv.getHtmlLabelName(28253,user.getLanguage()) %>
																		<input type="text" name="inputstructname_<%=i %>" id="inputstructname_<%=i %>" value="<%=structName %>" onchange="checkinput('inputstructname_<%=i %>','inputstructnamespan_<%=i %>')">
																		<span id="inputstructnamespan_<%=i %>"></span>
																	</td>
																</tr>
																<tr>
																	<td colspan="1">
																		<input type="hidden" name="inputstructfieldcount_<%=i %>" id="inputstructfieldcount_<%=i %>" value="<%=structFields.size() %>">
																		<BUTTON class = btnNew onClick = "addRow_InputStructField(<%=i %>);"><%=SystemEnv.getHtmlLabelName(17998 , user.getLanguage())%></BUTTON>
															    		<BUTTON class = btnDelete onClick = "javascript:deleteRow_InputStructField(<%=i %>)"><%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>
																	</td>
																</tr>
																<tr>
																	<td>
																		<table class="ViewForm" id="oTable_elmt_InputStructField_<%=i %>" cols="4">
																			<COLGROUP> 
																			<COL width="4%"> 
																			<COL width="32%">
																			<COL width="32%">
																			<COL width="32%">
																			</COLGROUP>
																			<tbody>
																				<%
																				if(structFields != null && structFields.size() > 0){
																					for(int j = 0; j<structFields.size(); j++){
																						Field field = (Field)structFields.get(j);
																				%>
																				<tr>
																					<td>
																						<div>
																							<input type="checkbox" name="check_node_ImportStructField" id="check_node_importStructField_<%=j %>">
																						</div>
																					</td>
																					<td>
																					<%=SystemEnv.getHtmlLabelName(28247,user.getLanguage()) %>
																					<input type="text" class="inputstyle" name="sapfieldname_importstructfield_<%=i %>" id="sapfieldname_importstructfield_<%=i %>_<%=j %>" value="<%=field.getName() %>" onchange="checkinput('sapfieldname_importstructfield_<%=i %>_<%=j %>','sapfieldname_importstructfieldspan_<%=i %>_<%=j %>')">
																					<span id="sapfieldname_importstructfieldspan_<%=i %>_<%=j %>"></span>
																					</td>
																					<td>
																					<%=SystemEnv.getHtmlLabelName(28248,user.getLanguage()) %>
																					<input type="text" class="inputstyle" name="oafieldname_importstructfield_<%=i %>" id="oafieldname_importstructfield_<%=i %>_<%=j %>" value="<%=field.getFromOaField() %>">
																					</td>
																					<td>
																					<%=SystemEnv.getHtmlLabelName(28249,user.getLanguage()) %>
																					<input type="text" class="inputstyle" name="constant_importstructfield_<%=i %>" id="constant_importstructfield_<%=i %>_<%=j %>" value="<%=field.getConstant() %>">
																					</td>
																				</tr>
																				<%
																					}
																				}
																				%>
																			</tbody>
																		</table>
																	</td>
																</tr>
															</table>
														</td>
													</tr>
													<TR class=Spacing style='height:2px;'><TD style='background-color: white;' colSpan=10></TD></TR>
												<%		
													}
												}
												%>
												</tbody>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						
						
						<TR class=Spacing style="height:1px;">
						  <TD class=Line colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(28255 , user.getLanguage()) %></td>
							<td class="Field">
								<table class=ViewForm>
									<tr>
										<td colspan="1">
											<input type="hidden" name="outputparamcount" id="outputparamcount" value="<%=export_outputList.size() %>">
											<BUTTON class = btnNew onClick = "addRow_OutputParam();"><%=SystemEnv.getHtmlLabelName(17998 , user.getLanguage())%></BUTTON>
								    		<BUTTON class = btnDelete onClick = "javascript:deleteRow_OutputParam()"><%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>
										</td>
									</tr>
									<TR class=Spacing style='height:2px;'><TD style='background-color: white;' colSpan=10></TD></TR>
									
									<tr>
										<td>
											<table class="ViewForm" id="oTable_elmt_OutputParam" cols="4">
												<COLGROUP> 
												<COL width="4%"> 
												<COL width="32%">
												<COL width="32%">
												<COL width="32%">
												</COLGROUP>
												<tbody>
													<%
													if(export_outputList != null && export_outputList.size() > 0){
														for(int i = 0; i<export_outputList.size(); i++){
															Field field = (Field)export_outputList.get(i);
													%>
													<tr>
														<td>
															<div>
																<input type="checkbox" name="check_node_exportParam" id="check_node_exportParam_<%=i %>">
															</div>
														</td>
														<td>
														<%=SystemEnv.getHtmlLabelName(28247,user.getLanguage()) %>
														<input type="text" class="inputstyle" name="sapfieldname_exportparam_<%=i %>" id="sapfieldname_exportparam_<%=i %>" value="<%=field.getName() %>" onchange="checkinput('sapfieldname_exportparam_<%=i %>','sapfieldname_exportparamspan_<%=i %>')">
														<span id="sapfieldname_exportparamspan_<%=i %>"></span>
														</td>
														<td>
														<%=SystemEnv.getHtmlLabelName(606,user.getLanguage()) %>
														<input type="text" class="inputstyle" name="desc_exportparam_<%=i %>" id="desc_exportparam_<%=i %>" value="<%=field.getDesc() %>" onchange="checkinput('desc_exportparam_<%=i %>','desc_exportparamspan_<%=i %>')">
														<span id="desc_exportparamspan_<%=i %>"></span>
														</td>
														<td>
														<%=SystemEnv.getHtmlLabelName(15603,user.getLanguage()) %>
														<input type="checkbox" class="inputstyle" name="display_exportparam_<%=i %>" id="display_exportparam_<%=i %>" value="Y" <%if(field.getDisplay() != null && field.getDisplay().equalsIgnoreCase("Y")){out.print("checked='checked'");} %>>
														</td>
													</tr>
													<%
														}
													}
													%>
												</tbody>
											</table>
										</td>
									</tr>
									
								</table>
							</td>
						</tr>
						
						
												
						
						<TR class=Spacing style="height:1px;">
						  <TD class=Line colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(28256 , user.getLanguage()) %></td>
							<td class="Field">
								<table class="ViewForm">
									<tr>
										<td colspan="1">
											<input type="hidden" name="outputstructcount" id="outputstructcount" value="<%=struct_outputList.size() %>">
											<BUTTON class = btnNew onClick = "addRow_OutputStruct();"><%=SystemEnv.getHtmlLabelName(28257 , user.getLanguage())%></BUTTON>
								    		<BUTTON class = btnDelete onClick = "javascript:deleteRow_OutputStruct()"><%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>
										</td>
									</tr>
									<TR class=Spacing style='height:2px;'><TD style='background-color: white;' colSpan=10></TD></TR>
									<tr>
										<td>
											<table class="ViewForm" id="oTable_elmt_OutputStruct" cols="2">
												<COLGROUP> 
												<COL width="4%"> 
												<COL width="96%">
												</COLGROUP>
												<tbody>
												<%
												if(struct_outputList != null && struct_outputList.size() > 0){
													for(int i = 0; i<struct_outputList.size(); i++){
														StructField struct = (StructField)struct_outputList.get(i);
														String structName = struct.getStructName();
														List structFields = struct.getStructFieldList();
												%>
													<tr>
														<td>
															<div>
																<input type="checkbox" name="check_node_ExportStruct" id="check_node_ExportStruct_<%=i %>">
															</div>
														</td>
														<td>
															<table class="ViewForm">
																<tr>
																	<td>
																		<%=SystemEnv.getHtmlLabelName(28258 , user.getLanguage()) %>
																		<input type="text" name="outputstructname_<%=i %>" id="outputstructname_<%=i %>" value="<%=structName %>" onchange="checkinput('outputstructname_<%=i %>','outputstructnamespan_<%=i %>')">
																		<span id="outputstructnamespan_<%=i %>"></span>
																	</td>
																</tr>
																<tr>
																	<td colspan="1">
																		<input type="hidden" name="outputstructfieldcount_<%=i %>" id="outputstructfieldcount_<%=i %>" value="<%=structFields.size() %>">
																		<BUTTON class = btnNew onClick = "addRow_OutputStructField(<%=i %>);"><%=SystemEnv.getHtmlLabelName(17998 , user.getLanguage())%></BUTTON>
															    		<BUTTON class = btnDelete onClick = "javascript:deleteRow_OutputStructField(<%=i %>)"><%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>
																	</td>
																</tr>
																<tr>
																	<td>
																		<table class="ViewForm" id="oTable_elmt_OutputStructField_<%=i %>" cols="5">
																			<COLGROUP> 
																			<COL width="4%"> 
																			<COL width="28%">
																			<COL width="28%">
																			<COL width="20%">
																			<COL width="20%">
																			</COLGROUP>
																			<tbody>
																				<%
																				if(structFields != null && structFields.size() > 0){
																					for(int j = 0; j<structFields.size(); j++){
																						Field field = (Field)structFields.get(j);
																				%>
																				<tr>
																					<td>
																						<div>
																							<input type="checkbox" name="check_node_ExportStructField" id="check_node_ExportStructField_<%=j %>">
																						</div>
																					</td>
																					<td>
																					<%=SystemEnv.getHtmlLabelName(28247,user.getLanguage()) %>
																					<input type="text" class="inputstyle" name="sapfieldname_exportstructfield_<%=i %>_<%=j %>" id="sapfieldname_exportstructfield_<%=i %>_<%=j %>" value="<%=field.getName() %>" onchange="checkinput('sapfieldname_exportstructfield_<%=i %>_<%=j %>','sapfieldname_exportstructfieldspan_<%=i %>_<%=j %>')">
																					<span id="sapfieldname_exportstructfieldspan_<%=i %>_<%=j %>"></span>
																					</td>
																					<td>
																					<%=SystemEnv.getHtmlLabelName(606,user.getLanguage()) %>
																					<input type="text" class="inputstyle" name="desc_exportstructfield_<%=i %>_<%=j %>" id="desc_exportstructfield_<%=i %>_<%=j %>" value="<%=field.getDesc() %>" onchange="checkinput('desc_exportstructfield_<%=i %>_<%=j %>','desc_exportstructfieldspan_<%=i %>_<%=j %>')">
																					<span id="desc_exportstructfieldspan_<%=i %>_<%=j %>"></span>
																					</td>
																					<td>
																					<%=SystemEnv.getHtmlLabelName(15603,user.getLanguage()) %>
																					<input type="checkbox" class="inputstyle" name="display_exportstructfield_<%=i %>_<%=j %>" id="display_exportstructfield_<%=i %>_<%=j %>" value="<%="Y" %>" <%if(field.getDisplay() != null && field.getDisplay().equalsIgnoreCase("Y")){out.print("checked='checked'");} %>>
																					</td>
																					<td>
																					<%=SystemEnv.getHtmlLabelName(28259,user.getLanguage()) %>
																					<input type="checkbox" class="inputstyle" name="search_exportstructfield_<%=i %>_<%=j %>" id="search_exportstructfield_<%=i %>_<%=j %>" value="<%="Y" %>" <%if(field.getSearch() != null && field.getSearch().equalsIgnoreCase("Y")){out.print("checked='checked'");} %>>
																					</td>
																				</tr>
																				<%
																					}
																				}
																				%>
																			</tbody>
																		</table>
																	</td>
																</tr>
															</table>
														</td>
													</tr>
													<TR class=Spacing style='height:2px;'><TD style='background-color: white;' colSpan=10></TD></TR>
												<%		
													}
												}
												%>
												</tbody>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						
						
						
												
						
						<TR class=Spacing style="height:1px;">
						  <TD class=Line colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(28260 , user.getLanguage()) %></td>
							<td class="Field">
								<table class="ViewForm">
									<tr>
										<td colspan="1">
											<input type="hidden" name="outputtablecount" id="outputtablecount" value="<%=table_outputList.size() %>">
											<BUTTON class = btnNew onClick = "addRow_OutputTable();"><%=SystemEnv.getHtmlLabelName(28261 , user.getLanguage())%></BUTTON>
								    		<BUTTON class = btnDelete onClick = "javascript:deleteRow_OutputTable()"><%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>
										</td>
									</tr>
									<TR class=Spacing style='height:2px;'><TD style='background-color: white;' colSpan=10></TD></TR>
									<tr>
										<td>
											<table class="ViewForm" id="oTable_elmt_OutputTable" cols="2">
												<COLGROUP> 
												<COL width="4%"> 
												<COL width="96%">
												</COLGROUP>
												<tbody>
												<%
												if(table_outputList != null && table_outputList.size() > 0){
													for(int i = 0; i<table_outputList.size(); i++){
														TableField table = (TableField)table_outputList.get(i);
														String tableName = table.getTableName();
														List tableFields = table.getTableFieldList();
												%>
													<tr>
														<td>
															<div>
																<input type="checkbox" name="check_node_ExportTable" id="check_node_ExportTable_<%=i %>">
															</div>
														</td>
														<td>
															<table class="ViewForm">
																<tr>
																	<td>
																		<%=SystemEnv.getHtmlLabelName(28262 , user.getLanguage()) %>
																		<input type="text" name="outputtablename_<%=i %>" id="outputtablename_<%=i %>" value="<%=tableName %>" onchange="checkinput('outputtablename_<%=i %>','outputtablenamespan_<%=i %>')">
																		<span id="outputtablenamespan_<%=i %>"></span>
																	</td>
																</tr>
																<tr>
																	<td colspan="1">
																		<input type="hidden" name="outputtablefieldcount_<%=i %>" id="outputtablefieldcount_<%=i %>" value="<%=tableFields.size() %>">
																		<BUTTON class = btnNew onClick = "addRow_OutputTableField(<%=i %>);"><%=SystemEnv.getHtmlLabelName(17998 , user.getLanguage())%></BUTTON>
															    		<BUTTON class = btnDelete onClick = "javascript:deleteRow_OutputTableField(<%=i %>)"><%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>
																	</td>
																</tr>
																<tr>
																	<td>
																		<table class="ViewForm" id="oTable_elmt_OutputTableField_<%=i %>" cols="6">
																			<COLGROUP> 
																			<COL width="4%"> 
																			<COL width="26%">
																			<COL width="24%">
																			<COL width="10%">
																			<COL width="18%">
																			<COL width="18%">
																			</COLGROUP>
																			<tbody>
																				<%
																				if(tableFields != null && tableFields.size() > 0){
																					for(int j = 0; j<tableFields.size(); j++){
																						Field field = (Field)tableFields.get(j);
																				%>
																				<tr>
																					<td>
																						<div>
																							<input type="checkbox" name="check_node_ExportTableField" id="check_node_ExportTableField_<%=j %>">
																						</div>
																					</td>
																					<td>
																					<%=SystemEnv.getHtmlLabelName(28247,user.getLanguage()) %>
																					<input type="text" class="inputstyle" name="sapfieldname_exporttablefield_<%=i %>_<%=j %>" id="sapfieldname_exporttablefield_<%=i %>_<%=j %>" value="<%=field.getName() %>" onchange="checkinput('sapfieldname_exporttablefield_<%=i %>_<%=j %>','sapfieldname_exporttablefieldspan_<%=i %>_<%=j %>')">
																					<span id="sapfieldname_exporttablefieldspan_<%=i %>_<%=j %>"></span>
																					</td>
																					<td>
																					<%=SystemEnv.getHtmlLabelName(606,user.getLanguage()) %>
																					<input type="text" class="inputstyle" name="desc_exporttablefield_<%=i %>_<%=j %>" id="desc_exporttablefield_<%=i %>_<%=j %>" value="<%=field.getDesc() %>" onchange="checkinput('desc_exporttablefield_<%=i %>_<%=j %>','desc_exporttablefieldspan_<%=i %>_<%=j %>')">
																					<span id="desc_exporttablefieldspan_<%=i %>_<%=j %>"></span>
																					</td>
																					<td>
																					<%=SystemEnv.getHtmlLabelName(15603,user.getLanguage()) %>
																					<input type="checkbox" class="inputstyle" name="display_exporttablefield_<%=i %>_<%=j %>" id="display_exporttablefield_<%=i %>_<%=j %>" value="<%="Y" %>" <%if(field.getDisplay() != null && field.getDisplay().equalsIgnoreCase("Y")){out.print("checked='checked'");} %>>
																					</td>
																					<td>
																					<%=SystemEnv.getHtmlLabelName(28259,user.getLanguage()) %>
																					<input type="checkbox" class="inputstyle" name="search_exporttablefield_<%=i %>_<%=j %>" id="search_exporttablefield_<%=i %>_<%=j %>" value="<%="Y" %>" <%if(field.getSearch() != null && field.getSearch().equalsIgnoreCase("Y")){out.print("checked='checked'");} %>>
																					</td>
																					<td>
																					<%=SystemEnv.getHtmlLabelName(28277,user.getLanguage()) %>
																					<input type="checkbox" class="inputstyle" name="identity_exporttablefield_<%=i %>_<%=j %>" id="identity_exporttablefield_<%=i %>_<%=j %>" value="<%="Y" %>" <%if(field.isIdentity()){out.print("checked='checked'");} %>>
																					</td>
																				</tr>
																				<%
																					}
																				}
																				%>
																			</tbody>
																		</table>
																	</td>
																</tr>
															</table>
														</td>
													</tr>
													<TR class=Spacing style='height:2px;'><TD style='background-color: white;' colSpan=10></TD></TR>
												<%		
													}
												}
												%>
												</tbody>
											</table>
										</td>
									</tr>
								</table>
							</td>
						</tr>
						
						
						
						
						
						<TR class=Spacing style="height:1px;">
						  <TD class=Line colSpan=2></TD>
						</TR>
						<tr>
							<td><%=SystemEnv.getHtmlLabelName(21845 , user.getLanguage()) %></td>
							<td class="Field">
								<table class=ViewForm>
									<tr>
										<td colspan="1">
											<BUTTON class = btnNew onClick = "addRow_Assignment();"><%=SystemEnv.getHtmlLabelName(17998 , user.getLanguage())%></BUTTON>
								    		<BUTTON class = btnDelete onClick = "javascript:deleteRow_Assignment()"><%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>
										</td>
									</tr>
									<TR class=Spacing style='height:2px;'><TD style='background-color: white;' colSpan=10></TD></TR>
									
									<tr>
										<td>
											<table class="ViewForm" id="oTable_elmt_Assignment" cols="3">
												<COLGROUP> 
												<COL width="4%"> 
												<COL width="48%">
												<COL width="48%">
												</COLGROUP>
												<tbody>
													<%
													if(assignmentList != null && assignmentList.size() > 0){
														for(int i = 0; i<assignmentList.size(); i++){
															Field field = (Field)assignmentList.get(i);
													%>
													<tr>
														<td>
															<div>
																<input type="checkbox" name="check_node_Assignment" id="check_node_Assignment_<%=i %>">
															</div>
														</td>
														<td>
														<%=SystemEnv.getHtmlLabelName(28265 , user.getLanguage()) %>
														<input type="text" class="inputstyle" name="oafieldname_assignment" id="oafieldname_assignment_<%=i %>" value="<%=field.getName() %>" onchange="checkinput('oafieldname_assignment_<%=i %>','oafieldname_assignmentspan_<%=i %>')" size="40">
														<span id="oafieldname_assignmentspan_<%=i %>"></span>
														</td>
														<td>
														<%=SystemEnv.getHtmlLabelName(28266 , user.getLanguage()) %>
														<input type="text" class="inputstyle" name="sapfieldname_assignment" id="sapfieldname_assignment_<%=i %>" value="<%=field.getFrom() %>" onchange="checkinput('sapfieldname_assignment_<%=i %>','sapfieldname_assignmentspan_<%=i %>')" size="40">
														<span id="sapfieldname_assignmentspan_<%=i %>"></span>
														</td>
													</tr>
													<%
														}
													}
													%>
												</tbody>
											</table>
										</td>
									</tr>
									
								</table>
							</td>
						</tr>
						
						<!-- begin -->
						
						
						
						
					</TBODY>
				</table>
				
				
			</td>
			</tr>
			</TABLE>
		</td>
		<td></td>
	</tr>
	<tr>
			<td>
				&nbsp;
			</td>
			<td>
			</td>
			<td>
			</td>
	</tr>
	<tr>
			<td>
			</td>
			<td>
						
						<table class=ReportStyle>
							<caption><%=SystemEnv.getHtmlLabelName(31898,user.getLanguage()) %></caption>
						<TBODY>
								<tr>
									<td  class="filed">
										<%=SystemEnv.getHtmlLabelName(686,user.getLanguage()) %>
									</td>
									<td colspan="2" style="text-align: center;">
										<%=SystemEnv.getHtmlLabelName(28265,user.getLanguage()) %>
									</td>
									
									<td colspan="3" style="text-align: center;">
										<%=SystemEnv.getHtmlLabelName(31899,user.getLanguage()) %>
									</td>
									
								</tr>
								<tr>
									<td  class="filed">
										<%=SystemEnv.getHtmlLabelName(17997,user.getLanguage()) %>
									</td>
									<td class="filed02">
										<%=SystemEnv.getHtmlLabelName(21778,user.getLanguage()) %>
									</td>
									<td class="filed02">
										<%=SystemEnv.getHtmlLabelName(19325,user.getLanguage()) %>
									</td>
									<td class="filed02">
										<%=SystemEnv.getHtmlLabelName(28255,user.getLanguage()) %>
									</td>
									<td class="filed02">
										<%=SystemEnv.getHtmlLabelName(28256,user.getLanguage()) %>
									</td>
									<td class="filed02">
										<%=SystemEnv.getHtmlLabelName(28260,user.getLanguage()) %>
									</td>
								</tr>
								<tr>
									<td  class="filed">
										<%=SystemEnv.getHtmlLabelName(685,user.getLanguage()) %>
									</td>
									<td>
										FIELDA
									</td>
									<td>
										FIELDMXA
									</td>
									<td>
										SAPPAR
									</td>
									<td>
										SAPSTU
									</td>
									<td>
										SAPTAB
									</td>
								</tr>
								<tr>
									<td  class="filed">
										<%=SystemEnv.getHtmlLabelName(32827,user.getLanguage()) %>
									</td>
									<td class="filed02">
										<%=SystemEnv.getHtmlLabelName(31644,user.getLanguage()) %>
									</td>
									<td class="filed02">
										<font style="color: red"><%=SystemEnv.getHtmlLabelName(31900,user.getLanguage()) %></font>_<%=SystemEnv.getHtmlLabelName(31644,user.getLanguage()) %>
									</td>
									<td class="filed02">
										<font style="color: red">EXPORT</font>_<%=SystemEnv.getHtmlLabelName(20968,user.getLanguage()) %>
									</td>
									<td class="filed02">
										<font style="color: red"><%=SystemEnv.getHtmlLabelName(381,user.getLanguage()) %></font>.<%=SystemEnv.getHtmlLabelName(31901,user.getLanguage()) %>
									</td>
									<td class="filed02">
										<font style="color: red"><%=SystemEnv.getHtmlLabelName(31902,user.getLanguage()) %></font>_<%=SystemEnv.getHtmlLabelName(31149,user.getLanguage()) %>
									</td>
								</tr>
								<tr>
									<td  class="filed">
										<%=SystemEnv.getHtmlLabelName(687,user.getLanguage()) %>
									</td>
									<td>
											FIELDA
									</td>
									<td>
										<font style="color: red">FORMTABLE_MAIN_317_DT1</font>_FIELDMXA
									</td>
									<td>
										<font style="color: red">EXPORT</font>_SAPPAR
									</td>
									<td>
										<font style="color: red">SAPSTU</font>.FIELDSTU
									</td>
									<td>
										<font style="color: red">SAPTAB</font>_FIELDTAB
									</td>
								</tr>
						</TBODY>
						</table>
						
						
			</td>
			<td>
			</td>
	</tr>
	<tr>
		<td height="10" colspan="3"></td>
	</tr>
	
	</table>
</FORM>
</BODY>
<script type="text/javascript" src="/js/jquery/jquery_wev8.js"></script>
<script language="javascript">
var rowindex_inputparam = <%=import_inputList.size()%>;
function addRow_InputParam(){
	
	var ncol = oTable_elmt_InputParam.cols;
	var oRow = oTable_elmt_InputParam.insertRow();
	for(var i = 0; i<ncol; i++){
		var oCell = oRow.insertCell();

		switch(i){
			case 0:
				oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' id='check_node_ImportParam_"+rowindex_inputparam+"'  name='check_node_ImportParam' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(28247,user.getLanguage()) %> <input type='text' class='inputstyle' name='sapfieldname_importparam' id='sapfieldname_importparam_"+rowindex_inputparam+"' onchange=\"checkinput('sapfieldname_importparam_"+rowindex_inputparam+"','sapfieldname_importparamspan_"+rowindex_inputparam+"')\">";
				sHtml += "<span id='sapfieldname_importparamspan_"+rowindex_inputparam+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>&nbsp;";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(28248,user.getLanguage()) %> <input type='text' class='inputstyle' name='oafieldname_importparam' id='oafieldname_importparam_"+rowindex_inputparam+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(28249,user.getLanguage()) %> <input type='text' class='inputstyle' name='constant_importparam' id='constant_importparam_"+rowindex_inputparam+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex_inputparam++;
}


function deleteRow_InputParam(){
	var rows = jQuery("input[type='checkbox'][name='check_node_ImportParam'][checked]");
	if(rows.length == 0){
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>!");
		return;
	}

	if(confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>?")){
	    rows.each(
	    	function(){
				jQuery(this).parent().parent().parent().remove();
	    	}
	    );
    }
}

var rowindex_inputstruct = <%=struct_inputList.size()%>;
function addRow_InputStruct(){
	var ncol = oTable_elmt_InputStruct.cols;
	var oRow = oTable_elmt_InputStruct.insertRow();
	for(var i = 0; i<ncol; i++){
		var oCell = oRow.insertCell();

		switch(i){
			case 0:
				oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node_ImportStruct' id='check_node_ImportStruct_"+rowindex_inputstruct+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<table class='ViewForm'>";
						sHtml += "<tr>";
							sHtml += "<td>";
								sHtml += "<%=SystemEnv.getHtmlLabelName(28253,user.getLanguage()) %>";
								sHtml += "<input type='text' name='inputstructname_"+rowindex_inputstruct+"' id='inputstructname_"+rowindex_inputstruct+"' onchange=\"checkinput('inputstructname_"+rowindex_inputstruct+"','inputstructnamespan_"+rowindex_inputstruct+"')\">";
								sHtml += "<span id='inputstructnamespan_"+rowindex_inputstruct+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
							sHtml += "</td>";
						sHtml += "</tr>";
						
						sHtml += "<tr>";
							sHtml += "<td>";
								sHtml += "<input type='hidden' name='inputstructfieldcount_"+rowindex_inputstruct+"' id='inputstructfieldcount_"+rowindex_inputstruct+"'>";
								sHtml += "<BUTTON class = btnNew onClick = 'addRow_InputStructField("+rowindex_inputstruct+");'><%=SystemEnv.getHtmlLabelName(17998 , user.getLanguage())%></BUTTON>";
								sHtml += "<BUTTON class = btnDelete onClick = 'javascript:deleteRow_InputStructField("+rowindex_inputstruct+")'><%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>";
							sHtml += "</td>";
						sHtml += "</tr>";
						
						sHtml += "<tr>";
							sHtml += "<td>";
								sHtml += "<table class='ViewForm' id='oTable_elmt_InputStructField_"+rowindex_inputstruct+"' cols='4'>";
									sHtml += "<COLGROUP>";
									sHtml += "<COL width='4%'>";
									sHtml += "<COL width='32%'>";
									sHtml += "<COL width='32%'>";
									sHtml += "<COL width='32%'>";
									sHtml += "</COLGROUP>";
									sHtml += "<tbody>";
										
									sHtml += "</tbody>";
								sHtml += "</table>";
							sHtml += "</td>";
						sHtml += "</tr>";
						
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex_inputstruct++;
	jQuery('#inputstructcount').val(rowindex_inputstruct);
	
	var oRow2 = oTable_elmt_InputStruct.insertRow();
	oRow2.className='Spacing';
	oRow2.style.height='2px';
	
	var oCell2 = oRow2.insertCell();
	oCell2.colSpan=10;
	oCell2.style.background='white';
}

function deleteRow_InputStruct(){
	var rows = jQuery("input[type='checkbox'][name='check_node_ImportStruct'][checked]");
	if(rows.length == 0){
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>!");
		return;
	}

	if(confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>?")){
	    rows.each(
	    	function(){
	    		jQuery(this).parent().parent().parent().next().remove();
				jQuery(this).parent().parent().parent().remove();
	    	}
	    );
    }
}


function addRow_InputStructField(i){
	
	var ncol = jQuery('#oTable_elmt_InputStructField_'+i).attr('cols');
	var tmpfieldcount = jQuery('#inputstructfieldcount_'+i).val();
	if(!tmpfieldcount || tmpfieldcount == ''){
		tmpfieldcount = 0;
	}
	var oRow = document.getElementById('oTable_elmt_InputStructField_'+i).insertRow();
		for(var j = 0; j<ncol; j++){
		var oCell = oRow.insertCell();

		switch(j){
			case 0:
				oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node_ImportStructField'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(28247,user.getLanguage()) %> <input type='text' class='inputstyle' name='sapfieldname_importstructfield_"+i+"' id='sapfieldname_importstructfield_"+i+"_"+tmpfieldcount+"' onchange=\"checkinput('sapfieldname_importstructfield_"+i+"_"+tmpfieldcount+"','sapfieldname_importstructfieldspan_"+i+"_"+tmpfieldcount+"')\">";
					sHtml += "<span id='sapfieldname_importstructfieldspan_"+i+"_"+tmpfieldcount+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
			break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(28248,user.getLanguage()) %> <input type='text' class='inputstyle' name='oafieldname_importstructfield_"+i+"' id='oafieldname_importstructfield_"+i+"_"+tmpfieldcount+"'>";
					sHtml += "<span id='oafieldname_importstructfieldspan_"+i+"_"+tmpfieldcount+"'></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
			break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(28249,user.getLanguage()) %> <input type='text' class='inputstyle' name='constant_importstructfield_"+i+"' id='constant_importstructfield_"+i+"_"+tmpfieldcount+"'>";
					sHtml += "<span id='constant_importstructfieldspan_"+i+"_"+tmpfieldcount+"'></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
			break;
		}
	}
	
	tmpfieldcount++;
	jQuery('#inputstructfieldcount_'+i).val(tmpfieldcount);
}
function deleteRow_InputStructField(i){
	var rows = jQuery("input[type='checkbox'][name='check_node_ImportStructField'][checked]");
	if(rows.length == 0){
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>!");
		return;
	}

	if(confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>?")){
	    rows.each(
	    	function(){
				jQuery(this).parent().parent().parent().remove();
	    	}
	    );
    }
}




var rowindex_outputparam = <%=export_outputList.size()%>;
function addRow_OutputParam(){
	
	var ncol = oTable_elmt_OutputParam.cols;
	var oRow = oTable_elmt_OutputParam.insertRow();
	for(var i = 0; i<ncol; i++){
		var oCell = oRow.insertCell();

		switch(i){
			case 0:
				oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' id='check_node_exportParam"+rowindex_outputparam+"'  name='check_node_exportParam' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(28247,user.getLanguage()) %> <input type='text' class='inputstyle' name='sapfieldname_exportparam_"+rowindex_outputparam+"' id='sapfieldname_exportparam_"+rowindex_outputparam+"' onchange=\"checkinput('sapfieldname_exportparam_"+rowindex_outputparam+"','sapfieldname_exportparamspan_"+rowindex_outputparam+"')\">";
				sHtml += "<span id='sapfieldname_exportparamspan_"+rowindex_outputparam+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>&nbsp;";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(606,user.getLanguage()) %> <input type='text' class='inputstyle' name='desc_exportparam_"+rowindex_outputparam+"' id='desc_exportparam_"+rowindex_outputparam+"' onchange=\"checkinput('desc_exportparam_"+rowindex_outputparam+"','desc_exportparamspan_"+rowindex_outputparam+"')\">";
				sHtml += "<span id='desc_exportparamspan_"+rowindex_outputparam+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>&nbsp;";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(15603,user.getLanguage()) %> <input type='checkbox' class='inputstyle' name='display_exportparam_"+rowindex_outputparam+"' id='display_exportparam_"+rowindex_outputparam+"' value='Y'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex_outputparam++;
	jQuery('#outputparamcount').val(rowindex_outputparam);
}


function deleteRow_OutputParam(){
	var rows = jQuery("input[type='checkbox'][name='check_node_exportParam'][checked]");
	if(rows.length == 0){
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>!");
		return;
	}

	if(confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>?")){
	    rows.each(
	    	function(){
				jQuery(this).parent().parent().parent().remove();
	    	}
	    );
    }
}









var rowindex_outputstruct = <%=struct_outputList.size()%>;
function addRow_OutputStruct(){
	var ncol = oTable_elmt_OutputStruct.cols;
	var oRow = oTable_elmt_OutputStruct.insertRow();
	for(var i = 0; i<ncol; i++){
		var oCell = oRow.insertCell();

		switch(i){
			case 0:
				oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node_ExportStruct' id='check_node_ExportStruct_"+rowindex_outputstruct+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<table class='ViewForm'>";
						sHtml += "<tr>";
							sHtml += "<td>";
								sHtml += "<%=SystemEnv.getHtmlLabelName(28258 , user.getLanguage()) %>";
								sHtml += "<input type='text' name='outputstructname_"+rowindex_outputstruct+"' id='outputstructname_"+rowindex_outputstruct+"' onchange=\"checkinput('outputstructname_"+rowindex_outputstruct+"','outputstructnamespan_"+rowindex_outputstruct+"')\">";
								sHtml += "<span id='outputstructnamespan_"+rowindex_outputstruct+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
							sHtml += "</td>";
						sHtml += "</tr>";
						
						sHtml += "<tr>";
							sHtml += "<td>";
								sHtml += "<input type='hidden' name='outputstructfieldcount_"+rowindex_outputstruct+"' id='outputstructfieldcount_"+rowindex_outputstruct+"'>";
								sHtml += "<BUTTON class = btnNew onClick = 'addRow_OutputStructField("+rowindex_outputstruct+");'><%=SystemEnv.getHtmlLabelName(17998 , user.getLanguage())%></BUTTON>";
								sHtml += "<BUTTON class = btnDelete onClick = 'javascript:deleteRow_OutputStructField("+rowindex_outputstruct+")'><%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>";
							sHtml += "</td>";
						sHtml += "</tr>";
						
						sHtml += "<tr>";
							sHtml += "<td>";
								sHtml += "<table class='ViewForm' id='oTable_elmt_OutputStructField_"+rowindex_outputstruct+"' cols='5'>";
									sHtml += "<COLGROUP>";
									sHtml += "<COL width='4%'>";
									sHtml += "<COL width='28%'>";
									sHtml += "<COL width='28%'>";
									sHtml += "<COL width='20%'>";
									sHtml += "<COL width='20%'>";
									sHtml += "</COLGROUP>";
									sHtml += "<tbody>";
										
									sHtml += "</tbody>";
								sHtml += "</table>";
							sHtml += "</td>";
						sHtml += "</tr>";
						
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex_outputstruct++;
	jQuery('#outputstructcount').val(rowindex_outputstruct);
	
	var oRow2 = oTable_elmt_OutputStruct.insertRow();
	oRow2.className='Spacing';
	oRow2.style.height='2px';
	
	var oCell2 = oRow2.insertCell();
	oCell2.colSpan=10;
	oCell2.style.background='white';
}

function deleteRow_OutputStruct(){
	var rows = jQuery("input[type='checkbox'][name='check_node_ExportStruct'][checked]");
	if(rows.length == 0){
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>!");
		return;
	}

	if(confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>?")){
	    rows.each(
	    	function(){
	    		jQuery(this).parent().parent().parent().next().remove();
				jQuery(this).parent().parent().parent().remove();
	    	}
	    );
    }
}


function addRow_OutputStructField(i){
	
	var ncol = jQuery('#oTable_elmt_OutputStructField_'+i).attr('cols');
	var tmpfieldcount = jQuery('#outputstructfieldcount_'+i).val();
	if(!tmpfieldcount || tmpfieldcount == ''){
		tmpfieldcount = 0;
	}
	var oRow = document.getElementById('oTable_elmt_OutputStructField_'+i).insertRow();
		for(var j = 0; j<ncol; j++){
		var oCell = oRow.insertCell();

		switch(j){
			case 0:
				oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node_ExportStructField'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(28247,user.getLanguage()) %> <input type='text' class='inputstyle' name='sapfieldname_exportstructfield_"+i+"_"+tmpfieldcount+"' id='sapfieldname_exportstructfield_"+i+"_"+tmpfieldcount+"' onchange=\"checkinput('sapfieldname_exportstructfield_"+i+"_"+tmpfieldcount+"','sapfieldname_exportstructfieldspan_"+i+"_"+tmpfieldcount+"')\">";
					sHtml += "<span id='sapfieldname_exportstructfieldspan_"+i+"_"+tmpfieldcount+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
			break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(606,user.getLanguage()) %> <input type='text' class='inputstyle' name='desc_exportstructfield_"+i+"_"+tmpfieldcount+"' id='desc_exportstructfield_"+i+"_"+tmpfieldcount+"' onchange=\"checkinput('desc_exportstructfield_"+i+"_"+tmpfieldcount+"','desc_exportstructfieldspan_"+i+"_"+tmpfieldcount+"')\">";
					sHtml += "<span id='desc_exportstructfieldspan_"+i+"_"+tmpfieldcount+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
			break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(15603,user.getLanguage()) %> <input type='checkbox' class='inputstyle' name='display_exportstructfield_"+i+"_"+tmpfieldcount+"' id='display_exportstructfield_"+i+"_"+tmpfieldcount+"' value='Y'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
			break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(28259,user.getLanguage()) %> <input type='checkbox' class='inputstyle' name='search_exportstructfield_"+i+"_"+tmpfieldcount+"' id='search_exportstructfield_"+i+"_"+tmpfieldcount+"' value='Y'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
			break;
		}
	}
	
	tmpfieldcount++;
	jQuery('#outputstructfieldcount_'+i).val(tmpfieldcount);
}
function deleteRow_OutputStructField(i){
	var rows = jQuery("input[type='checkbox'][name='check_node_ExportStructField'][checked]");
	if(rows.length == 0){
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>!");
		return;
	}

	if(confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>?")){
	    rows.each(
	    	function(){
				jQuery(this).parent().parent().parent().remove();
	    	}
	    );
    }
}








var rowindex_outputtable = <%=table_outputList.size()%>;
function addRow_OutputTable(){
	var ncol = oTable_elmt_OutputTable.cols;
	var oRow = oTable_elmt_OutputTable.insertRow();
	for(var i = 0; i<ncol; i++){
		var oCell = oRow.insertCell();

		switch(i){
			case 0:
				oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node_ExportTable' id='check_node_ExportTable_"+rowindex_outputtable+"'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<table class='ViewForm'>";
						sHtml += "<tr>";
							sHtml += "<td>";
								sHtml += "<%=SystemEnv.getHtmlLabelName(28262 , user.getLanguage()) %>";
								sHtml += "<input type='text' name='outputtablename_"+rowindex_outputtable+"' id='outputtablename_"+rowindex_outputtable+"' onchange=\"checkinput('outputtablename_"+rowindex_outputtable+"','outputtablenamespan_"+rowindex_outputtable+"')\">";
								sHtml += "<span id='outputtablenamespan_"+rowindex_outputtable+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
							sHtml += "</td>";
						sHtml += "</tr>";
						
						sHtml += "<tr>";
							sHtml += "<td>";
								sHtml += "<input type='hidden' name='outputtablefieldcount_"+rowindex_outputtable+"' id='outputtablefieldcount_"+rowindex_outputtable+"'>";
								sHtml += "<BUTTON class = btnNew onClick = 'addRow_OutputTableField("+rowindex_outputtable+");'><%=SystemEnv.getHtmlLabelName(17998 , user.getLanguage())%></BUTTON>";
								sHtml += "<BUTTON class = btnDelete onClick = 'javascript:deleteRow_OutputTableField("+rowindex_outputtable+")'><%=SystemEnv.getHtmlLabelName(91 , user.getLanguage())%></BUTTON>";
							sHtml += "</td>";
						sHtml += "</tr>";
						
						sHtml += "<tr>";
							sHtml += "<td>";
								sHtml += "<table class='ViewForm' id='oTable_elmt_OutputTableField_"+rowindex_outputtable+"' cols='6'>";
									sHtml += "<COLGROUP>";
									sHtml += "<COL width='4%'>";
									sHtml += "<COL width='26%'>";
									sHtml += "<COL width='24%'>";
									sHtml += "<COL width='10%'>";
									sHtml += "<COL width='18%'>";
									sHtml += "<COL width='18%'>";
									sHtml += "</COLGROUP>";
									sHtml += "<tbody>";
										
									sHtml += "</tbody>";
								sHtml += "</table>";
							sHtml += "</td>";
						sHtml += "</tr>";
						
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex_outputtable++;
	jQuery('#outputtablecount').val(rowindex_outputtable);
	
	var oRow2 = oTable_elmt_OutputTable.insertRow();
	oRow2.className='Spacing';
	oRow2.style.height='2px';
	
	var oCell2 = oRow2.insertCell();
	oCell2.colSpan=10;
	oCell2.style.background='white';
}

function deleteRow_OutputTable(){
	var rows = jQuery("input[type='checkbox'][name='check_node_ExportTable'][checked]");
	if(rows.length == 0){
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>!");
		return;
	}

	if(confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>?")){
	    rows.each(
	    	function(){
	    		jQuery(this).parent().parent().parent().next().remove();
				jQuery(this).parent().parent().parent().remove();
	    	}
	    );
    }
}


function addRow_OutputTableField(i){
	
	var ncol = jQuery('#oTable_elmt_OutputTableField_'+i).attr('cols');
	var tmpfieldcount = jQuery('#outputtablefieldcount_'+i).val();
	if(!tmpfieldcount || tmpfieldcount == ''){
		tmpfieldcount = 0;
	}
	var oRow = document.getElementById('oTable_elmt_OutputTableField_'+i).insertRow();
		for(var j = 0; j<ncol; j++){
		var oCell = oRow.insertCell();

		switch(j){
			case 0:
				oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input type='checkbox' name='check_node_ExportTableField'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(28247,user.getLanguage()) %> <input type='text' class='inputstyle' name='sapfieldname_exporttablefield_"+i+"_"+tmpfieldcount+"' id='sapfieldname_exporttablefield_"+i+"_"+tmpfieldcount+"' onchange=\"checkinput('sapfieldname_exporttablefield_"+i+"_"+tmpfieldcount+"','sapfieldname_exporttablefieldspan_"+i+"_"+tmpfieldcount+"')\">";
					sHtml += "<span id='sapfieldname_exporttablefieldspan_"+i+"_"+tmpfieldcount+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
			break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(606,user.getLanguage()) %> <input type='text' class='inputstyle' name='desc_exporttablefield_"+i+"_"+tmpfieldcount+"' id='desc_exporttablefield_"+i+"_"+tmpfieldcount+"' onchange=\"checkinput('desc_exporttablefield_"+i+"_"+tmpfieldcount+"','desc_exporttablefieldspan_"+i+"_"+tmpfieldcount+"')\">";
					sHtml += "<span id='desc_exporttablefieldspan_"+i+"_"+tmpfieldcount+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
			break;
			case 3:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(15603,user.getLanguage()) %> <input type='checkbox' class='inputstyle' name='display_exporttablefield_"+i+"_"+tmpfieldcount+"' id='display_exporttablefield_"+i+"_"+tmpfieldcount+"'  value='Y'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
			break;
			case 4:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(28259,user.getLanguage()) %> <input type='checkbox' class='inputstyle' name='search_exporttablefield_"+i+"_"+tmpfieldcount+"' id='search_exporttablefield_"+i+"_"+tmpfieldcount+"'  value='Y'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
			break;
			case 5:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(28277,user.getLanguage()) %> <input type='checkbox' class='inputstyle' name='identity_exporttablefield_"+i+"_"+tmpfieldcount+"' id='identity_exporttablefield_"+i+"_"+tmpfieldcount+"'  value='Y'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
			break;
		}
	}
	
	tmpfieldcount++;
	jQuery('#outputtablefieldcount_'+i).val(tmpfieldcount);
}
function deleteRow_OutputTableField(i){
	var rows = jQuery("input[type='checkbox'][name='check_node_ExportTableField'][checked]");
	if(rows.length == 0){
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>!");
		return;
	}

	if(confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>?")){
	    rows.each(
	    	function(){
				jQuery(this).parent().parent().parent().remove();
	    	}
	    );
    }
}


var rowindex_assignment = <%=assignmentList.size()%>;
function addRow_Assignment(){
	
	var ncol = oTable_elmt_Assignment.cols;
	var oRow = oTable_elmt_Assignment.insertRow();
	for(var i = 0; i<ncol; i++){
		var oCell = oRow.insertCell();

		switch(i){
			case 0:
				oCell.style.width=10;
				var oDiv = document.createElement("div");
				var sHtml = "<input class=inputstyle type='checkbox' id='check_node_Assignment_"+rowindex_assignment+"'  name='check_node_Assignment' value='0'>";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 1:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(28265 , user.getLanguage()) %> <input type='text' class='inputstyle' name='oafieldname_assignment' id='oafieldname_assignment_"+rowindex_assignment+"' onchange=\"checkinput('oafieldname_assignment_"+rowindex_assignment+"','oafieldname_assignmentspan_"+rowindex_assignment+"')\" size='40'>";
				sHtml += "<span id='oafieldname_assignmentspan_"+rowindex_assignment+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>&nbsp;";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
			case 2:
				var oDiv = document.createElement("div");
				var sHtml = "<%=SystemEnv.getHtmlLabelName(28266 , user.getLanguage()) %> <input type='text' class='inputstyle' name='sapfieldname_assignment' id='sapfieldname_assignment_"+rowindex_assignment+"' onchange=\"checkinput('sapfieldname_assignment_"+rowindex_assignment+"','sapfieldname_assignmentspan_"+rowindex_assignment+"')\" size='40'>";
				sHtml += "<span id='sapfieldname_assignmentspan_"+rowindex_assignment+"'><img src='/images/BacoError_wev8.gif' align=absmiddle></span>&nbsp;";
				oDiv.innerHTML = sHtml;
				oCell.appendChild(oDiv);
				break;
		}
	}
	rowindex_assignment++;
}


function deleteRow_Assignment(){
	var rows = jQuery("input[type='checkbox'][name='check_node_Assignment'][checked]");
	if(rows.length == 0){
		alert("<%=SystemEnv.getHtmlLabelName(15543,user.getLanguage())%>!");
		return;
	}

	if(confirm("<%=SystemEnv.getHtmlLabelName(15459,user.getLanguage())%>?")){
	    rows.each(
	    	function(){
				jQuery(this).parent().parent().parent().remove();
	    	}
	    );
    }
}

function onSubmit(obj){
	if(jQuery('#checkexistsspan').html() != ''){
		alert(jQuery('#checkexistsspan').html());
		return;
	}
	if(jQuery("img[src$='images/BacoError_wev8.gif']").length > 0){
		alert('<%=SystemEnv.getHtmlLabelName(15859 , user.getLanguage())%>');
		return;
	}
	document.frmMain.operation.value = 'save';
	document.frmMain.submit();
	obj.disabled = 'disabled';
}

function onDelete(obj){
	if(confirm('<%=SystemEnv.getHtmlLabelName(15097 , user.getLanguage())%>')){
		document.frmMain.operation.value = 'delete';
		document.frmMain.submit();
		obj.disabled = 'disabled';
	}
}

function checkexists(obj){
	var browserid = obj.value;
	if(browserid && browserid != ''){
		jQuery.post('SAPDataAuthSaveDetailAjax.jsp',{operation:'checksapbrowseridexists',sapbrowserid:browserid},function(data){
			eval('var obj = ' + data);
			if(obj && obj.exists == 'Y'){
				jQuery('#checkexistsspan').html('<%=SystemEnv.getHtmlLabelName(28267 , user.getLanguage())%>');
			}else{
				jQuery('#checkexistsspan').html('');
			}
		});
	}else{
		jQuery('#checkexistsspan').html('');
	}
}

function onShowWorkflow(inputename,showname){
    tmpids = $G(inputename).value;
    id1 = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowMutiBrowser.jsp?wfids="+tmpids);
	if (id1){
        if (id1.id!="" && id1.id != 0) {
          resourceids = id1.id;
          resourcename = id1.name;
          sHtml = ""
         
          resourceids =resourceids.substr(1);
          $G(inputename).value= resourceids;
          resourcename =resourcename.substr(1);
          
          resourceids=resourceids.split(",");
          resourcename=resourcename.split(",");
          for(var i=0;i<resourceids.length;i++){
              sHtml = sHtml+resourcename[i]+"&nbsp;";
          }
          $G(showname).innerHTML = sHtml;
	      $G("wfNames").value=sHtml;
        }else{
		  $G(showname).innerHTML ="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
          $G(inputename).value="";
       }
    }else{
    	//$G(showname).innerHTML ="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
        //$G(inputename).value="";
    }
}

function changeAuthFlag(obj){
	if(obj.checked){
		jQuery('#ShowWorkflow').attr({disabled:''});
		jQuery('#wfNamespan').html("<img src='/images/BacoError_wev8.gif' align=absmiddle>");
		jQuery('#wfid').val('');
	}else{
		jQuery('#ShowWorkflow').attr({disabled:'disabled'});
		jQuery('#wfNamespan').html("");
		jQuery('#wfid').val('');
	}
}
</script>

</HTML>
