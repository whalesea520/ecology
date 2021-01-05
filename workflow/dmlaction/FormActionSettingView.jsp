
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="FormActionBase" class="weaver.workflow.dmlaction.commands.bases.FormActionBase" scope="page" />
<jsp:useBean id="FieldBase" class="weaver.workflow.dmlaction.commands.bases.FieldBase" scope="page" />
<jsp:useBean id="BaseAction" class="weaver.workflow.action.BaseAction" scope="page"/>
<jsp:useBean id="DMLActionBase" class="weaver.workflow.dmlaction.commands.bases.DMLActionBase" scope="page" />

<%
	if(!HrmUserVarify.checkUserRight("WorkflowManage:All", user))
	{
		response.sendRedirect("/notice/noright.jsp");
		
		return;
	}
	int actionid = Util.getIntValue(Util.null2String(request.getParameter("actionid")),0);
	String fromintegration = Util.null2String(request.getParameter("fromintegration"));
	String typename = Util.null2String(request.getParameter("typename"));
	FormActionBase.setActionid(actionid);
	FormActionBase.initDMLAction();
	boolean isexists = FormActionBase.isIsexists();
	if(!isexists)
	{
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	//dmlactionname,dmlorder,workflowId,nodeid,ispreoperator,nodelinkid,datasourceid,dmltype
	
	
	String actionname = FormActionBase.getActionname();
	String isbill = "";
	String formid = "";
	//数据源
	String datasourceid = FormActionBase.getDatasourceid();
	//是否需要选择数据源
	boolean needcheckds = true;
	if(user.getUID()==1)
	{
		needcheckds = false;
	}
	//操作类型
	String dmltype = FormActionBase.getDmltype();
	
	
	formid = ""+FormActionBase.getFormid();
	isbill = ""+FormActionBase.getIsbill();
	String formname = "";
	if(!"".equals(formid))
	{
		String sql = "";
		if("0".equals(isbill))
			sql = "select formname from workflow_formbase where id = "+formid;
		else
			sql = "select h.labelname from workflow_bill b ,htmllabelinfo h where b.namelabel=h.indexid and h.languageid="+user.getLanguage()+" and b.id="+formid;
		RecordSet.executeSql(sql);
		if(RecordSet.next())
		{
			formname = RecordSet.getString(1);
		}
	}
	
	//actionid,actiontable,dmlformid,dmlformname,dmlisdetail," +
	//dmltablename,dmltablebyname,dmlsql,dmlfieldtypes,dmlfieldnames,dmlothersql,dmlotherfieldtypes," +
	//dmlotherfieldnames,dmlcuswhere,dmlcussql
	
	Map dmlMap = FormActionBase.getDmlMap();
	Map fieldMap = FormActionBase.getFieldMap();
	Map whereMap = FormActionBase.getWhereMap();
	
	Map<String,Map<String,String>> fieldExtra = FormActionBase.getFieldExtra();
	Map<String,Map<String,String>> whereExtra = FormActionBase.getWhereExtra();
	//field htmltype
	Map<String,String> fieldHtmlTypeMap = new HashMap<String,String>();
	//field type
	Map<String,String> fieldTypeMap = new HashMap<String, String>();
	
	String dmlsourceinfo = FormActionBase.getDmlsourceinfo();
	int detailTableId = -1;
	int tablenamelabel = 26421;
	boolean isdetail = false;
	FieldBase.setIsbill(Util.getIntValue(isbill,0));
	if(!"".equals(formid)){
		if(!"".equals(dmlsourceinfo) && dmlsourceinfo.startsWith("detail_")){   //说明选择了明细表
			FieldBase.setShowdetail("1");
			isdetail = true;
			tablenamelabel = 84595;
			String [] sourceinfo = dmlsourceinfo.split("_",-1);
			if(sourceinfo.length == 3){
				detailTableId = Util.getIntValue(Util.null2String(sourceinfo[1]),-1);
				FieldBase.setDetailTableId(detailTableId);
			}
		}
	}

	
	boolean isused = BaseAction.checkFromActionUsed(""+actionid,"1");
	
	// 数据库类型
	boolean isoracle = (RecordSet.getDBType()).equals("oracle");
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<STYLE TYPE="text/css">
		table.viewform td.line
		{
			height:1px!important;
		}
		table.liststyle td.line1
		{
			height:1px!important;
		}
		
		</STYLE>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
		<%@ taglib uri="/browserTag" prefix="brow"%>
		<link rel="stylesheet" href="/wui/theme/ecology8/weaveredittable/css/WeaverEditTable_wev8.css">
		<script src="/wui/theme/ecology8/weaveredittable/js/WeaverEditTable_wev8.js"></script>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
		<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<script type="text/javascript" src="/js/dragBox/parentShowcol_wev8.js"></script>
		<link rel="stylesheet" href="/css/ecology8/request/requestView_wev8.css" type="text/css" />
		<script src="/js/tabs/jquery.tabs.extend_wev8.js"></script>
		<link type="text/css" href="/js/tabs/css/e8tabs2_wev8.css" rel="stylesheet" />
		<script language=javascript src="/js/ecology8/request/e8.browser_wev8.js"></script>
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
			RCMenu += "{" + SystemEnv.getHtmlLabelName(93, user.getLanguage()) + ",javascript:editData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			if(!isused)
			{
				RCMenu += "{" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + ",javascript:deleteData(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			}
			if("1".equals(fromintegration))
			{
				//RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",/integration/formactionlist.jsp?typename="+typename+",_self} ";
				//RCMenuHeight += RCMenuHeightStep;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(93 ,user.getLanguage()) %>" class="e8_btn_top" onclick="editData();"/>
					<%
					if(!isused)
					{
					%>
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(91 ,user.getLanguage()) %>" class="e8_btn_top" onclick="deleteData()"/>
					<%
					}
					%>
					<span id="advancedSearch" class="advancedSearch" style='display:none;'><%=SystemEnv.getHtmlLabelName(21995 ,user.getLanguage()) %></span>&nbsp;&nbsp;
					<span title="<%=SystemEnv.getHtmlLabelName(23036 ,user.getLanguage()) %>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv" >
		   <span style="font-size:14px;font-weight:bold;"><%=titlename%></span> 
		</div>
		<div class="cornerMenuDiv"></div>
		<div class="advancedSearchDiv" id="advancedSearchDiv" style='display:none;'>
		</div>
		<form name="frmmain" method="post" action="DMLActionSettingOperation.jsp">
			<input type="hidden" id="operate" name="operate" value="">
			<input type="hidden" id="actionid" name="actionid" value="<%=actionid %>">
			<input type="hidden" id="fromintegration" name="fromintegration" value="<%=fromintegration %>">
			<input type="hidden" id="typename" name="typename" value="<%=typename %>">
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
												<wea:item><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></wea:item>
												<wea:item>
													<%=actionname%>
												</wea:item>
												<wea:item><%=SystemEnv.getHtmlLabelName(15451, user.getLanguage())%></wea:item>
												<wea:item>
													<%=formname %>
												</wea:item>
												<wea:item>DML<%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></wea:item><!-- 类型 -->
												<wea:item>
													<select id="dmltype" name="dmltype" onChange="checkinput('dmltype','dmltypespan')" disabled>
														<option></option>
														<option value="insert" <%if("insert".equals(dmltype)){ %>selected<%} %>>insert</option>
														<option value="update" <%if("update".equals(dmltype)){ %>selected<%} %>>update</option>
														<option value="delete" <%if("delete".equals(dmltype)){ %>selected<%} %>>delete</option>
														<option value="custom" <%if("custom".equals(dmltype)){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(82816, user.getLanguage())%></option>
													</select>
												</wea:item>
												
												<%--数据来源，主表，明细表1，明细表2，明细表xxx --%>
												<wea:item><%=SystemEnv.getHtmlLabelName(28006,user.getLanguage())%></wea:item>
												<wea:item>
												<%
													List<Map<String,String>> tableList = DMLActionBase.getDmlSource(formid,isbill,user.getLanguage()); 
												%>
												<select id="dmlsourceinfo" name="dmlsourceinfo" style="width:80px!important;" onchange="onChangeSource();" disabled="disabled">
												<%
													for(Map<String,String> sourceTable : tableList){
													String tableName = Util.null2String(sourceTable.get("tableName"));
													String tableId = Util.null2String(sourceTable.get("tableId"));
												%>
												<option value="<%=tableId%>" <%if(tableId.equals(dmlsourceinfo)){%> selected="selected" <%}%> ><%=tableName%></option>
												<%		
													}
												%>
												</select>
												</wea:item>
												
											</wea:group>
										</wea:layout>
												<%
													boolean showExplanation = false;
													Map allcolnums = new HashMap();
													if(!"".equals(formid))
													{
														String maintablename = FormActionBase.getActiontable();
														if(isdetail){
															maintablename = FieldBase.getFormDetailTable();
														}
														List actionSetList = (List)dmlMap.get(maintablename);
														if(null!=actionSetList)
														{
															int actionsqlsetid = 0;
															if(actionSetList.size()>0){
																actionsqlsetid = Util.getIntValue((String)actionSetList.get(0),0);
															}
															//action数据源表名
															String actiontable = "";
															if(actionSetList.size()>1){
																actiontable = Util.null2String((String)actionSetList.get(1));
															}
															//表单id
															int dmlformid = 0;
															if(actionSetList.size()>2){
																dmlformid = Util.getIntValue((String)actionSetList.get(2),0);
															}
															//表单名称
															String dmlformname = "";
															if(actionSetList.size()>3){
																dmlformname = Util.null2String((String)actionSetList.get(3));
															}
															//是否为明细
															String dmlisdetail = "";
															if(actionSetList.size()>4){
																dmlisdetail = Util.null2String((String)actionSetList.get(4));
															}
															//对应表名称
															String dmltablename = "";
															if(actionSetList.size()>5){
																dmltablename = Util.null2String((String)actionSetList.get(5));
															}
															//表别名
															String dmltablebyname = "";
															if(actionSetList.size()>6){
																dmltablebyname = Util.null2String((String)actionSetList.get(6));
															}
															//自定义条件
															String dmlcuswhere = "";
															if(actionSetList.size()>7){
																dmlcuswhere = Util.null2String((String)actionSetList.get(7));
															}
															//指定sql类型
															String dmlmainsqltype = "";
															if(actionSetList.size()>8){
																dmlmainsqltype = Util.null2String((String)actionSetList.get(8));
															}
															//指定sql
															String dmlcussql = "";
															if(actionSetList.size()>9){
																dmlcussql = Util.null2String((String)actionSetList.get(9));
															}
															
															List fieldsList = (List)fieldMap.get(""+actionsqlsetid);
															List wheresList = (List)whereMap.get(""+actionsqlsetid);
															
															FieldBase.getDMLActionFields(user,datasourceid,Util.getIntValue(formid,0),Util.getIntValue(isbill,0),0,dmlformid,dmltablename,Util.getIntValue(dmlisdetail),needcheckds);
															//maintablename = FieldBase.getFormtable();
															allcolnums = FieldBase.getAllcolnums();
													%>
													<wea:layout>
														<wea:group context='<%="DML"+SystemEnv.getHtmlLabelName(68,user.getLanguage())%>' attributes="{'samePair':'SetInfo','groupOperDisplay':'none'}">
																<wea:item><%=SystemEnv.getHtmlLabelName(1995, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21778, user.getLanguage())%></wea:item>
																<wea:item>
																	<%if(!datasourceid.equals("")||needcheckds){ %><%=dmlformname %>&nbsp;<%} %>
																	<%=dmltablename %>
																	<input type="hidden" id="actionsqlsetid" name="actionsqlsetid" value="<%=actionsqlsetid %>">
																</wea:item>
																<wea:item><%=SystemEnv.getHtmlLabelName(tablenamelabel, user.getLanguage())%></wea:item><%-- 流程数据库表名，主表，明细表都可能 --%>
																<wea:item>
																	<%=maintablename %>
																</wea:item>
																<wea:item attributes="{'colspan':'2'}">
																	<div class="listparams e8_box demo2" id="tabbox" style='height:42px;'>
									    							<ul class="tab_menu" id="tabs" style="width:85%">
																    	<li style='padding-left:0px!important;'><a href="#">DML <%=SystemEnv.getHtmlLabelName(21845, user.getLanguage())%></a></li> <!-- 赋值设置 -->
															            <li style="display:none;"></li>
																        <li style="display:none;"></li>
																        <li><a href="#"><%=SystemEnv.getHtmlLabelName(130492, user.getLanguage())%></a></li><!-- 自定义主表DML语句 -->
																    </ul>
																    <div class="tab_box" style="display:none;width:0px;"></div>
																</div>								
															</wea:item>
															
													<%
														allcolnums = FieldBase.getAllcolnums();
														//字段列表
														List fieldList = FieldBase.getFieldList();
														if(null!=fieldList&&fieldList.size()>0)
														{
															showExplanation = true;
															//字段类型列表
															Map fieldDBTypeMap = FieldBase.getFieldDBTypeMap();
															//字段标签列表
															Map fieldLabelMap = FieldBase.getFieldLabelMap();
															//字段名列表
															Map fieldNameMap = FieldBase.getFieldNameMap();
															//字段所属的明细表顺序
															Map  fieldDetailMap = FieldBase.getFieldDetailMap();
															
															//field htmltype
															fieldHtmlTypeMap = FieldBase.getFieldHtmlTypeMap();
															//field type
															fieldTypeMap = FieldBase.getFieldTypeMap();

													%>
															<wea:item attributes="{'colspan':'2','isTableList':'true'}">
																	<div id="propDiv">
																		<table width="100%" class='ListStyle'>
																			<colgroup>
																				<col width="20%">
																				<col width="30%">
																				<col width="20%">
																				<col width="30%">
																			<tbody>
																				<tr class="listparams listparams1 listparam">
																					<td colspan=4 vAlign="top"  style="background-color:#FFF" style='padding-left:0px!important;'>
																						<ul class="tab_menu" style="width:85%!important;">
																							<li><a href="#" style="max-width:100%" >DML <%=SystemEnv.getHtmlLabelName(21845, user.getLanguage())%></a></li>
																						</ul>
																						<div id="" class="" style="width:15%;height:43px;float:right;">
																						<TABLE width=100% class="setbutton" id='button1' >
																	           				<TR>
																	           					<!--th align=left><%=SystemEnv.getHtmlLabelName(32238, user.getLanguage())%></th--><!-- 分部同步对应关系设置 -->
																	           					<TD align=right colspan="2" style="background: #fff;">
																	           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onClick="addRow('fieldValueTableTr','dml');" class="addbtn"/><!-- 增加 -->
																									<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="delRow('fieldValueTableTr','dmlcheck',true);" class="delbtn"/><!-- 删除 -->
																	           					</TD>
																	           				</TR>
														         						</TABLE>
														         						</div>
																					</td>
																				</tr>
																				<tr class="listparams listparams1 listparam" id='fieldValueTable'>
																					<td colspan=4 vAlign="top" style='padding-left:0px!important;'>
																						<table width="100%" class='ListStyle' style="padding:0px;margin:0px;">
																							<colgroup>
																								<col width="15%">
																								<col width="15%">
																								<col width="10%">
																								<col width="20%">
																								<col width="10%">
																								<col width="15%">
																								<col width="20%">
																							 </colgroup>	
																							<tbody>
																								<tr class=header>
																									<th><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></th><!-- 字段名称 -->
																									<th><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></th><!-- 字段类型 -->
																									<th><%=SystemEnv.getHtmlLabelName(26422, user.getLanguage())%></th><!-- 同步对应字段 -->
																									<th><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></th><!-- 字段名称 -->
																									<th><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></th><!-- 字段类型 -->
																									<th><%=SystemEnv.getHtmlLabelName(23128, user.getLanguage())%></th><!-- 转换规则 -->
																								</tr>
																								<%
																								boolean isright = true;
																								Set columnSet = allcolnums.keySet();
																								for(Iterator i = columnSet.iterator();i.hasNext();)
																								{
																									String fieldname = Util.null2String((String)i.next());
																									String fielddbtype = Util.null2String((String)allcolnums.get(fieldname));
																									if(fielddbtype.contains("browser")) {
																										if(isoracle) {
																											fielddbtype = "varchar2(1000)";
																										} else {
																											fielddbtype = "varchar(1000)";
																										}
																									}
																									if(!FormActionBase.isKeyField(fieldsList,fieldname))
																									{
																										continue;
																									}
																									String jfieldid = "";
																									String jfieldname = "";
																									String jfielddbtype = "";
																									String jfieldlabel = "";
																									
																									String jfieldhtmltype = "";
																									String jfieldtype = "";
																									String jtransttype = "";
																									String jextrainfo = "";
																									for(int j = 0;j<fieldList.size();j++)
																									{
																										String tempjfieldid = (String)fieldList.get(j);
																										String tempjfieldname = Util.null2String((String)fieldNameMap.get(tempjfieldid));
																										String tempjfielddbtype = Util.null2String((String)fieldDBTypeMap.get(tempjfieldid));
																										String tempjfieldlabel = Util.null2String((String)fieldLabelMap.get(tempjfieldid));
																										if(null!=fieldsList&&fieldsList.contains(fieldname+"="+tempjfieldname))
																										{
																											jfieldhtmltype = Util.null2String(fieldHtmlTypeMap.get(tempjfieldid));
																											jfieldtype = Util.null2String(fieldTypeMap.get(tempjfieldid));

																											jfieldid = tempjfieldid;
																											jfieldname = tempjfieldname;
																											jfielddbtype = tempjfielddbtype;
																											if(jfielddbtype.contains("browser")) {
																												if(isoracle) {
																													jfielddbtype = "varchar2(1000)";
																												} else {
																													jfielddbtype = "varchar(1000)";
																												}
																											}
																											jfieldlabel = tempjfieldlabel;
																											
																											if(fieldExtra.containsKey(fieldname + "=" + tempjfieldname)){
																												Map<String,String> extraMap = fieldExtra.get(fieldname + "=" + tempjfieldname);
																												if(extraMap != null){
																													jtransttype = Util.null2String(extraMap.get("transttype"));
																													jextrainfo = Util.null2String(extraMap.get("extrainfo"));
																												}
																											}
																										}
																									}
																								%>
																									<tr height="20px" class="<%=isright?"DataLight":"DataDark" %>">
																										<td><%=fieldname %></td>
																										<td><%=fielddbtype %></td>
																										<td>
																											<%=jfieldlabel %>
																										</td>
																										<td>
																											<%=jfieldname %>
																										</td>
																										<td>
																											<%=jfielddbtype %>
																										</td>
																										
																										<%--转换规则 --%>
																										<td>
																											<select name="transttypevalue" onchange="onChangeTranstType(this)" disabled="disabled">
																												<option value="">&nbsp;</option>
																												<%if("3".equals(jfieldhtmltype) && ("1".equals(jfieldtype) || "17".equals(jfieldtype) || "165".equals(jfieldtype) || "166".equals(jfieldtype))){%>
				  	  																							<option value="1" <%if("1".equals(jtransttype)){%> selected="selected" <%}%> ><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>
				  	  																							<option value="2" <%if("2".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(82067,user.getLanguage())%></option>
				  	  																							<option value="3" <%if("3".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(27940,user.getLanguage())%></option>
				  	  																							<option value="4" <%if("4".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>
				  	  																							<option value="5" <%if("5".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(22482,user.getLanguage())%></option>
				  	 																							<option value="6" <%if("6".equals(jtransttype)){%> selected="selected" <%}%>>Email</option>
				  	  																							<option value="7" <%if("7".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%></option>
				  	  																							<%}else if("3".equals(jfieldhtmltype) && ("4".equals(jfieldtype) || "57".equals(jfieldtype) || "167".equals(jfieldtype) || "168".equals(jfieldtype))){%>
				  	  																							<option value="1" <%if("1".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>
																										  	    <option value="2" <%if("2".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(82067,user.getLanguage())%></option>
																										  	    <option value="3" <%if("3".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></option>
																										  	    <option value="7" <%if("7".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%></option>
				  	  																							<%}else if("3".equals(jfieldhtmltype) && ("164".equals(jfieldtype) || "194".equals(jfieldtype) || "169".equals(jfieldtype) || "170".equals(jfieldtype))){%>
				  	  																							<option value="1" <%if("1".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>
																											  	<option value="2" <%if("2".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(82067,user.getLanguage())%></option>
																											  	<option value="3" <%if("3".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>
																											  	<option value="7" <%if("7".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%></option>
				  	  																							<%}else if("3".equals(jfieldhtmltype) || "5".equals(jfieldhtmltype) || "6".equals(jfieldhtmltype) || "7".equals(jfieldhtmltype)){%>
				  	  																							<option value="1" <%if("1".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>
																											  	<option value="2" <%if("2".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(82067,user.getLanguage())%></option>
																											  	<option value="7" <%if("7".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%></option>
				  	  																							<%}else{%>
				  	  																							<option value="1" <%if("1".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>
				  	  																							<option value="7" <%if("7".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%></option>
				  	  																							<%}%>
					  																						</select>
					  																						<%
					  																							if("1".equals(jtransttype)){
					  																						%>
					  																							<input type="text" name="extravalue" value="<%=jextrainfo%>" readonly="readonly"/>
					  																						<%		
					  																							}else if("7".equals(jtransttype)){
					  																						%>
					  																							<textarea name="extravalue" rows="3" readonly="readonly"><%=jextrainfo%></textarea>
					  																						<%		
					  																							}else{
					  																						%>
					  																							<input type="hidden" name="extravalue" value="<%=jextrainfo%>" readonly="readonly"/>
					  																						<%		
					  																							}
					  																						%>
																										</td>
																										
																									</tr>
																									<tr style="height:1px;"><td style="height:1px;" class=line colspan=5></td></tr>
																								<%
																									isright = isright?false:true;
																								}
																								%>
																							</tbody>
																						</table>
																					</td>
																				</tr>
																				<tr class="listparams listparams1 listparams2 listparam">
																					<td colspan=4 vAlign="top"  style="background-color:#FFF" style='padding-left:0px!important;'>
																						<ul class="tab_menu" style="width:85%!important;">
																							<li><a href="#"  style="max-width:100%">DML <%=SystemEnv.getHtmlLabelName(27957, user.getLanguage())%></a></li>
																						</ul>
																						<div id="" class="" style="width:15%;height:43px;float:right;">
																						<TABLE width=100% class="setbutton" id='button2'>
																	           				<TR>
																	           					<!--th align=left><%=SystemEnv.getHtmlLabelName(32237, user.getLanguage())%></th--><!-- 部门同步对应关系设置 -->
																	           					<TD align=right colspan="2" style="background: #fff;">
																	           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onClick="addRow('fieldWhereTableTr','where');" class="addbtn"/><!-- 增加 -->
																									<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="delRow('fieldWhereTableTr','wherecheck',true);" class="delbtn"/><!-- 删除 -->
																	           					</TD>
																	           				</TR>
																	         			</TABLE>
																	         			</div>
																					</td>
																				</tr>	
																				<tr class="listparams listparams1 listparams2 listparam" id='fieldWhereTable'>
																					<td colspan=4 vAlign="top" style='padding-left:0px!important;'>
																						<table width="100%" class='ListStyle' style="padding:0px;margin:0px;">
																							<colgroup>
																								<col width="15%">
																								<col width="15%">
																								<col width="10%">
																								<col width="20%">
																								<col width="10%">
																								<col width="15%">
																								<col width="20%">
																							</colgroup>
																								<tr class=header>
																									<th><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></th><!-- 字段名 -->
																									<th><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></th><!-- 字段类型 -->
																									<th><%=SystemEnv.getHtmlLabelName(26424, user.getLanguage())%></th><!-- 条件对应字段 -->
																									<th><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></th><!-- 字段名称 -->
																									<th><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></th><!-- 字段类型 -->
																									<th><%=SystemEnv.getHtmlLabelName(23128, user.getLanguage())%></th><!-- 转换规则 -->
																								</tr>
																								<%
																								isright = true;
																								for(Iterator i = columnSet.iterator();i.hasNext();)
																								{
																									String fieldname = Util.null2String((String)i.next());
																									String fielddbtype = Util.null2String((String)allcolnums.get(fieldname));
																									if(fielddbtype.contains("browser")) {
																										if(isoracle) {
																											fielddbtype = "varchar2(1000)";
																										} else {
																											fielddbtype = "varchar(1000)";
																										}
																									}
																									if(!FormActionBase.isKeyField(wheresList,fieldname))
																									{
																										continue;
																									}
																									String jwherefieldid = "";
																									String jwherefieldname = "";
																									String jwherefielddbtype = "";
																									String jwherefieldlabel = "";
																									
																									String jfieldhtmltype = "";
																									String jfieldtype = "";
																									String jtransttype = "";
																									String jextrainfo = "";

																									for(int j = 0;j<fieldList.size();j++)
																									{
																										String tempjfieldid = (String)fieldList.get(j);
																										String tempjfieldname = Util.null2String((String)fieldNameMap.get(tempjfieldid));
																										String tempjfielddbtype = Util.null2String((String)fieldDBTypeMap.get(tempjfieldid));
																										String tempjfieldlabel = Util.null2String((String)fieldLabelMap.get(tempjfieldid));
																										if(null!=wheresList&&wheresList.contains(fieldname+"="+tempjfieldname))
																										{
																											jfieldhtmltype = Util.null2String(fieldHtmlTypeMap.get(tempjfieldid));
																											jfieldtype = Util.null2String(fieldTypeMap.get(tempjfieldid));

																											jwherefieldid = tempjfieldid;
																											jwherefieldname = tempjfieldname;
																											jwherefielddbtype = tempjfielddbtype;
																											if(jwherefielddbtype.contains("browser")) {
																												if(isoracle) {
																													jwherefielddbtype = "varchar2(1000)";
																												} else {
																													jwherefielddbtype = "varchar(1000)";
																												}
																											}
																											jwherefieldlabel = tempjfieldlabel;
																											
																											if(whereExtra.containsKey(fieldname + "=" + tempjfieldname)){
																												Map<String,String> extraMap = whereExtra.get(fieldname + "=" + tempjfieldname);
																												if(extraMap != null){
																													jtransttype = Util.null2String(extraMap.get("transttype"));
																													jextrainfo = Util.null2String(extraMap.get("extrainfo"));
																												}
																											}
																										}
																									}
																								%>
																									<tr height="20px" class="<%=isright?"DataLight":"DataDark" %>">
																										<td><%=fieldname %></td>
																										<td><%=fielddbtype %></td>
																										<td><%=jwherefieldlabel %></td>
																										<td><%=jwherefieldname %></td>
																										<td><%=jwherefielddbtype %></td>
																										
																																																				<%--转换规则 --%>
																										<td>
																											<select name="transttypewhere" onchange="onChangeTranstType(this)" disabled="disabled">
																												<option value="">&nbsp;</option>
				  	  																							<%if("3".equals(jfieldhtmltype) && ("1".equals(jfieldtype) || "17".equals(jfieldtype) || "165".equals(jfieldtype) || "166".equals(jfieldtype))){%>
				  	  																							<option value="1" <%if("1".equals(jtransttype)){%> selected="selected" <%}%> ><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>
				  	  																							<option value="2" <%if("2".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(82067,user.getLanguage())%></option>
				  	  																							<option value="3" <%if("3".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(27940,user.getLanguage())%></option>
				  	  																							<option value="4" <%if("4".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>
				  	  																							<option value="5" <%if("5".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(22482,user.getLanguage())%></option>
				  	 																							<option value="6" <%if("6".equals(jtransttype)){%> selected="selected" <%}%>>Email</option>
				  	  																							<option value="7" <%if("7".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%></option>
				  	  																							<%}else if("3".equals(jfieldhtmltype) && ("4".equals(jfieldtype) || "57".equals(jfieldtype) || "167".equals(jfieldtype) || "168".equals(jfieldtype))){%>
				  	  																							<option value="1" <%if("1".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>
																										  	    <option value="2" <%if("2".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(82067,user.getLanguage())%></option>
																										  	    <option value="3" <%if("3".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></option>
																										  	    <option value="7" <%if("7".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%></option>
				  	  																							<%}else if("3".equals(jfieldhtmltype) && ("164".equals(jfieldtype) || "194".equals(jfieldtype) || "169".equals(jfieldtype) || "170".equals(jfieldtype))){%>
				  	  																							<option value="1" <%if("1".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>
																											  	<option value="2" <%if("2".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(82067,user.getLanguage())%></option>
																											  	<option value="3" <%if("3".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>
																											  	<option value="7" <%if("7".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%></option>
				  	  																							<%}else if("3".equals(jfieldhtmltype) || "5".equals(jfieldhtmltype) || "6".equals(jfieldhtmltype) || "7".equals(jfieldhtmltype)){%>
				  	  																							<option value="1" <%if("1".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>
																											  	<option value="2" <%if("2".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(82067,user.getLanguage())%></option>
																											  	<option value="7" <%if("7".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%></option>
				  	  																							<%}else{%>
				  	  																							<option value="1" <%if("1".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>
				  	  																							<option value="7" <%if("7".equals(jtransttype)){%> selected="selected" <%}%>><%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%></option>
				  	  																							<%}%>
					  																						</select>
					  																						<%
					  																							if("1".equals(jtransttype)){
					  																						%>
					  																							<input type="text" name="extrawhere" value="<%=jextrainfo%>" readonly="readonly"/>
					  																						<%		
					  																							}else if("7".equals(jtransttype)){
					  																						%>
					  																							<textarea name="extrawhere" rows="3" readonly="readonly"><%=jextrainfo%></textarea>
					  																						<%		
					  																							}else{
					  																						%>
					  																							<input type="hidden" name="extrawhere" value="<%=jextrainfo%>" readonly="readonly"/>
					  																						<%		
					  																							}
					  																						%>
																										</td>
																									</tr>
																									<tr style="height:1px;"><td style="height:1px;" class=line colspan=5></td></tr>
																								<%
																									isright = isright?false:true;
																								}
																								%>
																							</tbody>
																						</table>
																					</td>
																				</tr>
																				<tr style="height:1px;" class="listparams listparams1 listparams2 listparam"><td style="height:1px;" class=line colspan=4></td></tr>
																				<tr class="listparams listparams1 listparams3 listparam">
																					<td colspan=4 vAlign="top"   style="background-color:#FFF"  style='padding-left:0px!important;'>
																					<ul class="tab_menu" style="width:85%!important;">
																						<li>
																							<a href="#"  style="max-width:100%"><%=SystemEnv.getHtmlLabelName(130497, user.getLanguage())%></a>
																						</li>
																					</ul>
																					</td>
																				</tr>
																				<tr class="listparams listparams1 listparams3 listparam">
																					<td valign="top" style='padding-left:30px!important;BACKGROUND-COLOR:white;'><%=SystemEnv.getHtmlLabelName(130497, user.getLanguage())%></td><!-- 自定义主表条件 -->
																					<td class=field colspan=3>
																						<%=dmlcuswhere %>
																					</td>
																				</tr>
																				<tr style="height:1px;" class="listparams listparams1 listparams3 listparam"><td style="height:1px;" class=line colspan=4></td></tr>
																				<tr class="listparams listparams4 listparam">
																					<td valign="top" style='padding-left:30px!important;BACKGROUND-COLOR:white;'><%=SystemEnv.getHtmlLabelName(130492, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></td><!-- 自定义主表DML语句类型 -->
																					<td class=field colspan=3>
																						<select id="dmlmainsqltype" name="dmlmainsqltype" disabled>
																							<option value="0" <%if("0".equals(dmlmainsqltype)||"".equals(dmlmainsqltype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(27670, user.getLanguage())%></option>
																							<option value="1" <%if("1".equals(dmlmainsqltype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(27671, user.getLanguage())%></option>
																						</select>
																					</td>
																				</tr>
																				<tr style="height:1px;" class="listparams listparams4 listparam"><td style="height:1px;" class=line colspan=4></td></tr>
																				<tr class="listparams listparams4 listparam">
																					<td valign="top" style='padding-left:30px!important;BACKGROUND-COLOR:white;'><%=SystemEnv.getHtmlLabelName(130492, user.getLanguage())%></td><!-- 自定义主表DML语句 -->
																					<td class=field colspan=3>
																						<%=dmlcussql %>
																					</td>
																				</tr>
																				<tr style="height:1px;" class="listparams listparams4 listparam"><td style="height:1px;" class=line colspan=4></td></tr>
																			</tbody>
																		</table>
																		<%if (formid.equals("")){%>
																		<span style="color:red;"><%=SystemEnv.getHtmlLabelName(83687, user.getLanguage())%>!</span><!-- 未选择相关表单 -->
																		<%
																		}
																		else if(needcheckds&&"".equals(datasourceid))
																		{
																		%>
																		<span style="color:red;"><%=SystemEnv.getHtmlLabelName(27672, user.getLanguage())%>!</span><!-- 请先选择数据源 -->
																		<%
																		}
																		%>
																	</div>
																</wea:item>
												<%
															}
												%>
														</wea:group>
													</wea:layout>
												<%
														}
													}
												%>
												
						<% if(showExplanation){ %>
						<wea:layout><!-- 操作说明 -->
							<wea:group context='<%="DML "+SystemEnv.getHtmlLabelName(19010, user.getLanguage())%>' attributes="{'samePair':'SetInfo','groupOperDisplay':'none'}">
								<wea:item attributes="{'colspan':'2','isTableList':'true'}">
								<table width="100%" >
										<tr>
											<td style='padding-left:30px!important;BACKGROUND-COLOR:white;'>
												<font color="red">1.<%=SystemEnv.getHtmlLabelName(27673, user.getLanguage())%></font><br><!-- 请谨慎使用update，delete操作 -->
												<font color="green">2.<%=SystemEnv.getHtmlLabelName(130498, user.getLanguage())%></font><br><!-- 只能同步当前流程主表数据的到其他数据表中 -->
												<font color="green">3.<%=SystemEnv.getHtmlLabelName(130499, user.getLanguage())%><br><!-- 如果DML类型为update、delete，那么必须有DML主表条件或者自定义主表条件，否则此DML不被执行 -->
												<font color="maroon">4.<%=SystemEnv.getHtmlLabelName(27676, user.getLanguage())%>：<br><!-- 对各数据库中大对象数据类型字段，以及二进制数据类型字段不做同步，具体如下 -->
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SQLSERVER:binary,varbinary,image<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;ORACLE:raw,long raw,blob,clob,nclob,bfile,rowid<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;MYSQL:BLOB,ENUM,SET<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;DB2:GRAPHIC,VARGRAPHIC,LONG VARCHAR,CLOB,LONG VARGRAPHIC,DBCLOB,BLOB<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;SYSBASE:text,image<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;INFORMIX:text,byte<br>
												</font>
												<font color="dodgerblue">5.<%=SystemEnv.getHtmlLabelName(130500, user.getLanguage())%>:<br><!-- 对于自定义主表条件，具体格式如下 -->
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;userid={?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>A} and lastname='{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>B}' and ....<br><!-- 流程字段名称 -->
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(27679, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(27680, user.getLanguage())%>。<br><!-- sql中,以字段名开始(不能以where或者and开始)，{?流程字段名称*}将会被替换为流程中的对应字段的数据。具体sql格式，根据数据源数据库类型决定. -->
												<font color="dodgerblue">6.<%=SystemEnv.getHtmlLabelName(130501, user.getLanguage())%>：<br><!-- 对于自定义主表DML语句，具体格式如下 -->
												</font>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;update hrmresource set lastname='{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>A}',mobile='{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>B}' ... where id={?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>C} and ...<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(27679, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(27682, user.getLanguage())%><br><!-- sql中，{?流程字段名称*}将会被替换为流程中的对应字段的数据。具体sql格式，根据数据源数据库类型,以及字段类型决定 -->
												</font>
												<font color="dodgerblue">7.<%=SystemEnv.getHtmlLabelName(130503, user.getLanguage())%>：<br><!-- 对于转换规则中的自定义SQL -->
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;oracle<%=SystemEnv.getHtmlLabelName(15024, user.getLanguage())%>：select lastname from  hrmresource where id={?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>B} and ...<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(27679, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(27682, user.getLanguage())%><br><!-- sql中，{?流程字段名称*}将会被替换为流程中的对应字段的数据。具体sql格式，根据数据源数据库类型,以及字段类型决定 -->
												</font>
												<font color="dodgerblue">8.<%=SystemEnv.getHtmlLabelName(130504, user.getLanguage())%>：<br><!-- 由于各数据库中，日期数据类型不同，为保证数据正确同步，建议使用自定义主表DML语句，比如 -->
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;oracle<%=SystemEnv.getHtmlLabelName(15024, user.getLanguage())%>：update hrmresource set b.birthday=to_date('{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>A}','YYYY-MM-DD') ... where userid={?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>B} and ...<br>
												</font>
												<font color="dodgerblue">9.<%=SystemEnv.getHtmlLabelName(130505, user.getLanguage())%><br><!-- DML类型为存储过程时，在自定义主表DML语句中输入存储过程。格式如下：-->
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;procedurename('{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>A}','{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>B}'....)<br>
												</font>
											</td>
										</tr>
									</table>
								</wea:item>	
							</wea:group>
						</wea:layout>						
						<%}%>
												
											</form>
	</body>
	<script type="text/javascript">
	function deleteData()
	{
	    top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(26430,user.getLanguage())%>?", function (){
			document.frmmain.operate.value="delete";
	       	document.frmmain.submit();
		}, function () {}, 320, 90);
	}
	function editData()
	{
	    document.location.href =  "/workflow/dmlaction/FormActionSettingEdit.jsp?fromintegration=<%=fromintegration%>&actionid=<%=actionid%>&typename=<%=typename%>";
	}
	
	$(document).ready(function(){
		try
		{
			$(".listparams2").hide();
			$(".listparams3").hide();
			$(".listparams4").hide();
			$(".listparams5").hide();
			
			showListTab();
		}catch(e)
		{
		}
		parent.document.getElementById("main").style.height= "100%";
	});
	function showListTab()
	{
		jQuery('#tabbox').Tabs({
	    	getLine:1,
	    	staticOnLoad:false,
       		needInitBoxHeight:false,
	    	container:"#tabbox"
	    });
		jQuery.jqtab = function(tabtit,tab_conbox,shijian) 
		{
			try
			{
				$("."+tab_conbox).show();
				$(tabtit).find("li:first").addClass("current").show();
			}
			catch(e)
			{
			}
			
			$(tabtit).find("li").bind(shijian,function(){
				try
				{
				    $(this).addClass("current").siblings("li").removeClass("current"); 
					var activeindex = $(tabtit).find("li").index(this)+1;
					$(".listparam").hide();
					$(".listparams"+activeindex).show();
					$(".setbutton").hide();
					try
					{
						//$("#button"+activeindex).show();
					}
					catch(e)
					{
					}
				}
				catch(e)
				{
				}
				return false;
			});
		
		};
		/*调用方法如下：*/
		$.jqtab("#tabs","listparam1","click");
		$("#tabs").find("li:first").click();
	}
	function showTableFieldDiv(id1,id2)
	{
		var objtr = document.getElementById(id1);
		var obja = document.getElementById(id2);
		if(objtr)
		{
			if(objtr.style.display=="")
			{
				objtr.style.display = "none";
				jQuery(obja).text("[<%=SystemEnv.getHtmlLabelName(27687, user.getLanguage())%>]");
				//显示字段信息
				//obja.innerText = ;
				
			}
			else
			{
				objtr.style.display = "";
				//隐藏字段信息
				jQuery(obja).text("[<%=SystemEnv.getHtmlLabelName(27669, user.getLanguage())%>]");
				//obja.innerText = "[<%=SystemEnv.getHtmlLabelName(27669, user.getLanguage())%>]";
			}
		}
	}
	jQuery(document).ready(function () {
		$("#topTitle").topMenuTitle();
		$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
		$("#tabDiv").remove();
		$("#advancedSearch").bind("click", function(){
		});
	});
	</script>
</html>
