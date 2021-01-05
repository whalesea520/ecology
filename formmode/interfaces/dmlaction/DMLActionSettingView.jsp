
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="DMLActionBase" class="weaver.formmode.interfaces.dmlaction.commands.bases.DMLActionBase" scope="page" />
<jsp:useBean id="FieldBase" class="weaver.formmode.interfaces.dmlaction.commands.bases.FieldBase" scope="page" />

<%
	if(!HrmUserVarify.checkUserRight("ModeSetting:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
		
		return;
	}
	int actionid = Util.getIntValue(Util.null2String(request.getParameter("actionid")),0);
	DMLActionBase.setActionid(actionid);
	DMLActionBase.initDMLAction();
	boolean isexists = DMLActionBase.isIsexists();
	if(!isexists)
	{
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	//dmlactionname,dmlorder,workflowId,nodeid,ispreoperator,nodelinkid,datasourceid,dmltype
	
	
	String actionname = DMLActionBase.getActionname();
	int dmlorder = DMLActionBase.getDmlorder();
	int workflowId = DMLActionBase.getWorkflowId();
	//数据源
	String datasourceid = DMLActionBase.getDatasourceid();
	//是否需要选择数据源
	boolean needcheckds = true;
	if(user.getUID()==1)
	{
		needcheckds = false;
	}
	//操作类型
	String dmltype = DMLActionBase.getDmltype();
	//节点id
	int nodeid = DMLActionBase.getNodeid();
	//是否节点后附加操作
	String ispreoperator = DMLActionBase.getIspreoperator();
	//节点出口id
	int nodelinkid = DMLActionBase.getNodelinkid();
	
	
	String workFlowName = "";
	String isbill = "";
	String formid = "";
	if(workflowId>-1)
	{
		workFlowName = Util.null2String(WorkflowComInfo.getWorkflowname("" + workflowId));
		isbill = Util.null2String(WorkflowComInfo.getIsBill("" + workflowId));
		formid = Util.null2String(WorkflowComInfo.getFormId("" + workflowId));
	}
	String nodename = "";
	if(nodeid>0)
	{
		RecordSet.executeSql("select nodename from workflow_nodebase b where b.id = "+nodeid);
		if(RecordSet.next())
		{
			nodename = RecordSet.getString("nodename");
		}
	}
	String linkname = "";
	if(nodelinkid>0)
	{
		RecordSet.executeSql("select linkname from workflow_nodelink n where n.id = "+nodelinkid);
		if(RecordSet.next())
		{
			linkname = RecordSet.getString("linkname");
		}
	}
	
	//actionid,actiontable,dmlformid,dmlformname,dmlisdetail," +
	//dmltablename,dmltablebyname,dmlsql,dmlfieldtypes,dmlfieldnames,dmlothersql,dmlotherfieldtypes," +
	//dmlotherfieldnames,dmlcuswhere,dmlcussql
	
	Map dmlMap = DMLActionBase.getDmlMap();
	Map fieldMap = DMLActionBase.getFieldMap();
	Map whereMap = DMLActionBase.getWhereMap();
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(26418, user.getLanguage()); //配置接口动作(数据库DML)
		String needfav = "1";
		String needhelp = "";
	%>
	<body>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(93, user.getLanguage()) + ",/workflow/dmlaction/DMLActionSettingEdit.jsp?actionid="+actionid+",_self} ";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + ",javascript:deleteData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form name="frmmain" method="post" action="DMLActionSettingOperation.jsp">
			<input type="hidden" id="operate" name="operate" value="">
			<input type="hidden" id="actionid" name="actionid" value="<%=actionid %>">
			<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
				<colgroup>
					<col width="10">
					<col width="">
					<col width="10">
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
				<tr>
					<td></td>
					<td valign="top">
						<TABLE class=Shadow>
							<tr>
								<td valign="top">
									<table class=viewform cellspacing=1>
										<colgroup>
											<col width="15%">
											<col width="85%">
										<tbody>
											<tr class=spacing>
												<td class=Sep1 colSpan=2></td>
											</tr>
											<tr>
												<td class=line colspan=2>
												<td>
											</tr>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></td>
												<td class=field>
													<%=actionname%>
												</td>
											</tr>
											<tr>
												<td class=line colspan=2></td>
											</tr>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(18104, user.getLanguage())%></td>
												<td class=field>
													<%=workFlowName%>
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(26419, user.getLanguage())%></td><!-- 执行顺序 -->
												<td class=field>
													<%=dmlorder%>
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(15070, user.getLanguage())%></td><!-- 节点名称 -->
												<td class=field>
													<%=nodename %>
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(15611, user.getLanguage())%></td><!-- 出口名称 -->
												<td class=field>
													<%=linkname %>
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<tr>
												<td><%=SystemEnv.getHtmlLabelName(18076, user.getLanguage())%></td>
												<td class=field>
													<select id="datasourceid" name="datasourceid" disabled>
														<%if(user.getUID()==1){ %><option></option><%} %>
														<%
															List datasourceList = DataSourceXML.getPointArrayList();
															for (int i = 0; i < datasourceList.size(); i++)
															{
																String pointid = Util.null2String((String) datasourceList.get(i));
														%>
														<option value="<%=pointid%>" <%if(pointid.equals(datasourceid)){ %>selected<%} %>><%=pointid%></option>
														<%
															}
														%>
													</select>
												</td>
											</tr>
											<tr><td class=line colspan=2></td></tr>
											<tr>
												<td>DML<%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></td><!-- 类型 -->
												<td class=field>
													<select id="dmltype" name="dmltype" onChange="checkinput('dmltype','dmltypespan')" disabled>
														<option></option>
														<option value="insert" <%if("insert".equals(dmltype)){ %>selected<%} %>>insert<%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%></option>
														<option value="update" <%if("update".equals(dmltype)){ %>selected<%} %>>update<%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%></option>
														<option value="delete" <%if("delete".equals(dmltype)){ %>selected<%} %>>delete<%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%></option>
													</select>
												</td>
											</tr>
											<tr><td class=line1 colspan=2></td></tr>
											<tr>
												<td colspan=2>
												<%
													Map allcolnums = new HashMap();
													if (workflowId>0&&(nodeid>0||nodelinkid>0))
													{
														String maintablename = DMLActionBase.getActiontable();
														List actionSetList = (List)dmlMap.get(maintablename);
														if(null!=actionSetList)
														{
															int actionsqlsetid = 0;
															if(actionSetList.size()>0)
																actionsqlsetid = Util.getIntValue((String)actionSetList.get(0),0);
															//action数据源表名
															String actiontable = "";
															if(actionSetList.size()>1)
																actiontable = Util.null2String((String)actionSetList.get(1));
															//表单id
															int dmlformid = 0;
															if(actionSetList.size()>2)
																dmlformid = Util.getIntValue((String)actionSetList.get(2),0);
															//表单名称
															String dmlformname = "";
															if(actionSetList.size()>3)
																dmlformname = Util.null2String((String)actionSetList.get(3));
															//是否为明细
															String dmlisdetail = "";
															if(actionSetList.size()>4)
																dmlisdetail = Util.null2String((String)actionSetList.get(4));
															//对应表名称
															String dmltablename = "";
															if(actionSetList.size()>5)
																dmltablename = Util.null2String((String)actionSetList.get(5));
															//表别名
															String dmltablebyname = "";
															if(actionSetList.size()>6)
																dmltablebyname = Util.null2String((String)actionSetList.get(6));
															//自定义条件
															String dmlcuswhere = "";
															if(actionSetList.size()>7)
																dmlcuswhere = Util.null2String((String)actionSetList.get(7));
															//指定sql类型
															String dmlmainsqltype = "";
															if(actionSetList.size()>8)
																dmlmainsqltype = Util.null2String((String)actionSetList.get(8));
															//指定sql
															String dmlcussql = "";
															if(actionSetList.size()>9)
																dmlcussql = Util.null2String((String)actionSetList.get(9));
															
															List fieldsList = (List)fieldMap.get(""+actionsqlsetid);
															List wheresList = (List)whereMap.get(""+actionsqlsetid);
															
															FieldBase.getDMLActionFields(user,datasourceid,Util.getIntValue(formid,0),Util.getIntValue(isbill,0),0,dmlformid,dmltablename,Util.getIntValue(dmlisdetail),needcheckds);
															maintablename = FieldBase.getFormtable();
															allcolnums = FieldBase.getAllcolnums();
													%>
													<table width="100%">
														<colgroup>
															<col width="15%">
															<col width="35%">
															<col width="15%">
															<col width="35%">
														<tbody>
															<tr>
																<td><%=SystemEnv.getHtmlLabelName(1995, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21778, user.getLanguage())%></td>
																<td class=field>
																	<table width="100%">
																			<tr>
																				<td id="thisdatasourceid" class=field style="display:<%if(!datasourceid.equals("")||needcheckds){ %>none<%} %>">
																					<%=dmlformname %>
																				</td>
																				<td class=field>
																					<%=dmltablename %>
																				</td>
																				<input type="hidden" id="actionsqlsetid" name="actionsqlsetid" value="<%=actionsqlsetid %>">
																			</tr>
																	</table>
																</td>
																<td><%=SystemEnv.getHtmlLabelName(26421, user.getLanguage())%></td><!-- 流程主表 -->
																<td class=field>
																	<%=maintablename %>
																</td>
															</tr>
															<tr>
																<td class=line colspan=4></td>
															</tr>
															<tr class="Title">
																<th>DML<%=SystemEnv.getHtmlLabelName(18020, user.getLanguage())%></th><!-- 主表字段 -->
																<td class=field></td>
																<th><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18020, user.getLanguage())%></th><!-- 流程主表字段 -->
																<td class=field align=right><a href="#" onclick="showTableFieldDiv('fieldValueTableT',this);">[<%=SystemEnv.getHtmlLabelName(27669, user.getLanguage())%>]</a></td>
															</tr>
															<tr><td class=line1 colspan=4></td></tr>
													<%
														allcolnums = FieldBase.getAllcolnums();
														//字段列表
														List fieldList = FieldBase.getFieldList();
														if(null!=fieldList&&fieldList.size()>0)
														{
															//字段类型列表
															Map fieldDBTypeMap = FieldBase.getFieldDBTypeMap();
															//字段标签列表
															Map fieldLabelMap = FieldBase.getFieldLabelMap();
															//字段名列表
															Map fieldNameMap = FieldBase.getFieldNameMap();
															//字段所属的明细表顺序
															Map  fieldDetailMap = FieldBase.getFieldDetailMap();
													%>
															<tr>
																<td colspan=4>
																	<div id="propDiv">
																		<table width="100%" class='liststyle'>
																			<colgroup>
																				<col width="20%">
																				<col width="30%">
																				<col width="20%">
																				<col width="30%">
																			<tbody>
																				<tr id='fieldValueTable'>
																					<td colspan=2 vAlign="top">
																						<table width="100%" class='liststyle' style="padding:0px;margin:0px;">
																							<colgroup>
																								<col width="40%">
																								<col width="30%">
																								<col width="30%">
																							<tbody>
																								<tr class=Header>
																									<td><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></td><!-- 字段名称 -->
																									<td><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></td><!-- 字段类型 -->
																									<td><%=SystemEnv.getHtmlLabelName(26422, user.getLanguage())%></td><!-- 同步对应字段 -->
																								</tr>
																								<%
																								boolean isright = true;
																								Set columnSet = allcolnums.keySet();
																								for(Iterator i = columnSet.iterator();i.hasNext();)
																								{
																									String fieldname = Util.null2String((String)i.next());
																									String fielddbtype = Util.null2String((String)allcolnums.get(fieldname));
																									if(!DMLActionBase.isKeyField(fieldsList,fieldname))
																									{
																										continue;
																									}
																								%>
																									<tr height="20px" class="<%=isright?"dataRight":"dataDark" %>">
																										<td><%=fieldname %></td>
																										<td><%=fielddbtype %></td>
																										<td>
																											<select name="dmlfieldname" width="100px;" disabled>
																												<option></option>
																												<%
																												for(int j = 0;j<fieldList.size();j++)
																												{
																													String jfieldid = (String)fieldList.get(j);
																													String jfieldname = Util.null2String((String)fieldNameMap.get(jfieldid));
																													String jfielddbtype = Util.null2String((String)fieldDBTypeMap.get(jfieldid));
																													String jfieldlabel = Util.null2String((String)fieldLabelMap.get(jfieldid));
																												%>
																												<option value="<%=fieldname %>=<%=fielddbtype %>=<%=jfieldname %>" <%if(null!=fieldsList&&fieldsList.contains(fieldname+"="+fielddbtype+"="+jfieldname)) out.println("selected"); %>><%=jfieldlabel %></option>
																												<%} %>
																											</select>
																										</td>
																									</tr>
																									<tr><td class=line colspan=3></td></tr>
																								<%
																									isright = isright?false:true;
																								}
																								%>
																							</tbody>
																						</table>
																					</td>
																					<td colspan=2 vAlign="top">
																						<table width="100%" class='liststyle' style="padding:0px;margin:0px;">
																							<colgroup>
																								<col width="40%">
																								<col width="30%">
																								<col width="30%">
																							<tbody>
																								<tr class=Header>
																									<td><%=SystemEnv.getHtmlLabelName(15456, user.getLanguage())%></td><!-- 字段显示名 -->
																									<td><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></td><!-- 字段名 -->
																									<td><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></td><!-- 字段类型 -->
																								</tr>
																								<tr id=fieldValueTableT>
																									<td colspan=3 style="padding:0px;margin:0px;">
																										<table width="100%" class='liststyle' style="padding:0px;margin:0px;">
																											<colgroup>
																												<col width="40%">
																												<col width="30%">
																												<col width="30%">
																											<tbody>
																							<%
																							isright = true;
																							for(int i = 0;i<fieldList.size();i++)
																							{
																								String fieldid = (String)fieldList.get(i);
																								String fieldname = Util.null2String((String)fieldNameMap.get(fieldid));
																								String fielddbtype = Util.null2String((String)fieldDBTypeMap.get(fieldid));
																								String fieldlabel = Util.null2String((String)fieldLabelMap.get(fieldid));
																							%>
																								<tr height="20px" class="<%=isright?"dataRight":"dataDark" %>">
																									<td><%=fieldlabel %></td>
																									<td><%=fieldname %></td>
																									<td><%=fielddbtype %></td>
																								</tr>
																								<tr><td class=line colspan=3></td></tr>
																							<%
																								isright = isright?false:true;
																							}
																							%>
																											</tbody>
																										</table>
																									</td>
																								</tr>
																							</tbody>
																						</table>
																					</td>
																				</tr>
																				<tr class="Title">
																					<th>DML<%=SystemEnv.getHtmlLabelName(26423, user.getLanguage())%></th><!-- 主表条件 -->
																					<td class=field></td>
																					<th><%=SystemEnv.getHtmlLabelName(18015, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(18020, user.getLanguage())%></th><!-- 流程主表字段 -->
																					<td class=field align=right><a href="#" onclick="showTableFieldDiv('fieldWhereTableT',this);">[<%=SystemEnv.getHtmlLabelName(27669, user.getLanguage())%>]</a></td>
																				</tr>
																				<tr><td class=line1 colspan=4></td></tr>
																				<tr id='fieldWhereTable'>
																					<td colspan=2 vAlign="top">
																						<table width="100%" class='liststyle' style="padding:0px;margin:0px;">
																							<colgroup>
																								<col width="40%">
																								<col width="30%">
																								<col width="30%">
																							<tbody>
																								<tr class=Header>
																									<td><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></td><!-- 字段名 -->
																									<td><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></td><!-- 字段类型 -->
																									<td><%=SystemEnv.getHtmlLabelName(26424, user.getLanguage())%></td><!-- 条件对应字段 -->
																								</tr>
																								<%
																								isright = true;
																								for(Iterator i = columnSet.iterator();i.hasNext();)
																								{
																									String fieldname = Util.null2String((String)i.next());
																									String fielddbtype = Util.null2String((String)allcolnums.get(fieldname));
																									if(!DMLActionBase.isKeyField(wheresList,fieldname))
																									{
																										continue;
																									}
																								%>
																									<tr height="20px" class="<%=isright?"dataRight":"dataDark" %>">
																										<td><%=fieldname %></td>
																										<td><%=fielddbtype %></td>
																										<td>
																											<select name="wherefieldname" width="100px;" disabled>
																												<option></option>
																												<%
																												for(int j = 0;j<fieldList.size();j++)
																												{
																													String jfieldid = (String)fieldList.get(j);
																													String jfieldname = Util.null2String((String)fieldNameMap.get(jfieldid));
																													String jfielddbtype = Util.null2String((String)fieldDBTypeMap.get(jfieldid));
																													String jfieldlabel = Util.null2String((String)fieldLabelMap.get(jfieldid));
																												%>
																												<option value="<%=fieldname %>=<%=fielddbtype %>=<%=jfieldname %>" <%if(null!=wheresList&&wheresList.contains(fieldname+"="+fielddbtype+"="+jfieldname)) out.println("selected"); %>><%=jfieldlabel %></option>
																												<%} %>
																											</select>
																										</td>
																									</tr>
																									<tr><td class=line colspan=3></td></tr>
																								<%
																									isright = isright?false:true;
																								}
																								%>
																							</tbody>
																						</table>
																					</td>
																					<td colspan=2 vAlign="top">
																						<table width="100%" class='liststyle' style="padding:0px;margin:0px;">
																							<colgroup>
																								<col width="40%">
																								<col width="30%">
																								<col width="30%">
																							<tbody>
																								<tr class=Header>
																									<td><%=SystemEnv.getHtmlLabelName(15456, user.getLanguage())%></td><!-- 字段显示名 -->
																									<td><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></td><!-- 字段名 -->
																									<td><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></td><!-- 字段类型 -->
																								</tr>
																								<tr id=fieldWhereTableT>
																									<td colspan=3 style="padding:0px;margin:0px;">
																										<table width="100%" class='liststyle' style="padding:0px;margin:0px;">
																											<colgroup>
																												<col width="40%">
																												<col width="30%">
																												<col width="30%">
																											<tbody>
																							<%
																							isright = true;
																							for(int i = 0;i<fieldList.size();i++)
																							{
																								String fieldid = (String)fieldList.get(i);
																								String fieldname = Util.null2String((String)fieldNameMap.get(fieldid));
																								String fielddbtype = Util.null2String((String)fieldDBTypeMap.get(fieldid));
																								String fieldlabel = Util.null2String((String)fieldLabelMap.get(fieldid));
																							%>
																								<tr height="20px" class="<%=isright?"dataRight":"dataDark" %>">
																									<td><%=fieldlabel %></td>
																									<td><%=fieldname %></td>
																									<td><%=fielddbtype %></td>
																								</tr>
																								<tr><td class=line colspan=3></td></tr>
																							<%
																								isright = isright?false:true;
																							}
																							%>
																											</tbody>
																										</table>
																									</td>
																								</tr>
																							</tbody>
																						</table>
																					</td>
																				</tr>
																				<tr><td class=line colspan=4></td></tr>
																				<tr>
																					<td valign="top"><%=SystemEnv.getHtmlLabelName(26425, user.getLanguage())%></td><!-- 自定义主表条件 -->
																					<td class=field colspan=3>
																						<%=dmlcuswhere %>
																					</td>
																				</tr>
																				<tr><td class=line colspan=4></td></tr>
																				<tr>
																					<td valign="top"><%=SystemEnv.getHtmlLabelName(26426, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></td><!-- 自定义主表DML语句类型 -->
																					<td class=field colspan=3>
																						<select id="dmlmainsqltype" name="dmlmainsqltype" disabled>
																							<option value="0" <%if("0".equals(dmlmainsqltype)||"".equals(dmlmainsqltype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(27670, user.getLanguage())%></option>
																							<option value="1" <%if("1".equals(dmlmainsqltype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(27671, user.getLanguage())%></option>
																						</select>
																					</td>
																				</tr>
																				<tr><td class=line colspan=4></td></tr>
																				<tr>
																					<td valign="top"><%=SystemEnv.getHtmlLabelName(26426, user.getLanguage())%></td><!-- 自定义主表DML语句 -->
																					<td class=field colspan=3>
																						<%=dmlcussql %>
																					</td>
																				</tr>
																				<tr><td class=line colspan=4></td></tr>
																			</tbody>
																		</table>
																	</div>
																</td>
															</tr>
														</tbody>
													</table>
												<%
															}
														}
													}
												%>
												</td>
											</tr>
											
										</tbody>
									</table>
									<%
									if (workflowId<=0)
									{
									%>
									<span style="color:red;"><%=SystemEnv.getHtmlLabelName(26427, user.getLanguage())%>!</span><!-- 未选择相关流程 -->
									<%
									}
									else if (nodeid<=0&&nodelinkid<=0)
									{
									%>
									<span style="color:red;"><%=SystemEnv.getHtmlLabelName(26428, user.getLanguage())%>!</span><!-- 未选择流程的相关节点或者出口 -->
									<%
									}
									else if(needcheckds&&"".equals(datasourceid))
									{
									%>
									<span style="color:red;"><%=SystemEnv.getHtmlLabelName(27672, user.getLanguage())%>!</span><!-- 请先选择数据源 -->
									<%
									}
									%>
									<table width="100%" class='ViewForm'>
										<tr class="Title"><th>DML<%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%></th></tr><!-- 说明 -->
										<tr><td class=line1></td></tr>
										<tr>
											<td>
												<font color="red">1<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(27673, user.getLanguage())%></font><br><!-- 请谨慎使用update，delete操作 -->
												<font color="green">2<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(27674, user.getLanguage())%></font><br><!-- 只能同步当前流程主表数据的到其他数据表中 -->
												<font color="green">3<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(27675, user.getLanguage())%><br><!-- 如果DML类型为update、delete，那么必须有DML主表条件或者自定义主表条件，否则此DML不被执行 -->
												<font color="maroon">4<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(27676, user.getLanguage())%>：<br><!-- 对各数据库中大对象数据类型字段，以及二进制数据类型字段不做同步，具体如下 -->
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SQLSERVER:binary,varbinary,image<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ORACLE:raw,long raw,blob,clob,nclob,bfile,rowid<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;MYSQL:BLOB,ENUM,SET<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DB2:GRAPHIC,VARGRAPHIC,LONG VARCHAR,CLOB,LONG VARGRAPHIC,DBCLOB,BLOB<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SYSBASE:text,image<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;INFORMIX:text,byte<br>
												</font>
												<font color="dodgerblue">5<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(27677, user.getLanguage())%>:<br><!-- 对于自定义主表条件，具体格式如下 -->
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;userid={?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>A} and lastname='{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>B}' and ....<br><!-- 流程字段名称 -->
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(27679, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127390, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(27680, user.getLanguage())%><br><!-- sql中,以字段名开始(不能以where或者and开始)，{?流程字段名称*}将会被替换为流程中的对应字段的数据。具体sql格式，根据数据源数据库类型决定. -->
												<font color="dodgerblue">6<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(27681, user.getLanguage())%>：<br><!-- 对于自定义主表DML语句，具体格式如下 -->
												</font>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;update hrmresource set lastname='{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>A}',mobile='{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>B}' ... where userid={?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>C} and ...<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(27679, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127390, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(27682, user.getLanguage())%><br><!-- sql中，{?流程字段名称*}将会被替换为流程中的对应字段的数据。具体sql格式，根据数据源数据库类型,以及字段类型决定 -->
												</font>
												<font color="dodgerblue">7<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(27683, user.getLanguage())%>：<br><!-- 由于各数据库中，日期数据类型不同，为保证数据正确同步，建议使用自定义主表DML语句，比如 -->
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;oracle<%=SystemEnv.getHtmlLabelName(15024, user.getLanguage())%>：update hrmresource set b.birthday=to_date('{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>A}','YYYY-MM-DD') ... where userid={?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>B} and ...<br>
												</font>
												<font color="dodgerblue">8<%=SystemEnv.getHtmlLabelName(125163, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(27684, user.getLanguage())%>:<br><!-- 自定义主表DML语句类型为存储过程时，各数据库调用方式如下(未列出的数据库请参看各数据库帮助) -->
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;oracle<%=SystemEnv.getHtmlLabelName(15024, user.getLanguage())%>：call procname('{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>A}','{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>B}'....)<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;sqlserver<%=SystemEnv.getHtmlLabelName(15024, user.getLanguage())%>：EXECUTE procname '{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>A}','{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>B}'....<br>
												</font>
											</td>
										</tr>
									</table>
									
								</td>
							</tr>
						</TABLE>
					</td>
					<td></td>
				</tr>
				<tr>
					<td height="10" colspan="3"></td>
				</tr>
			</table>
	</body>
	<script type="text/javascript">
	function deleteData()
	{
	    if(isdel())
	    {
	    	
	    	document.frmmain.operate.value="delete";
	        document.frmmain.submit();
	    }
	}
	function showTableFieldDiv(obj,obja)
	{
		var objtr = document.getElementById(obj);
		if(objtr)
		{
			if(objtr.style.display=="")
			{
				objtr.style.display = "none";
				obja.innerText = "[<%=SystemEnv.getHtmlLabelName(27687, user.getLanguage())%>]";//显示字段信息
				
			}
			else
			{
				objtr.style.display = "";
				obja.innerText = "[<%=SystemEnv.getHtmlLabelName(27669, user.getLanguage())%>]";//隐藏字段信息
			}
		}
	}
	</script>
</html>