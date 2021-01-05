
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.workflow.dmlaction.*"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session" />
<jsp:useBean id="FormActionBase" class="weaver.workflow.dmlaction.commands.bases.FormActionBase" scope="page" />
<jsp:useBean id="FieldBase" class="weaver.workflow.dmlaction.commands.bases.FieldBase" scope="page" />
<jsp:useBean id="BaseAction" class="weaver.workflow.action.BaseAction" scope="page"/>
<jsp:useBean id="DMLActionBase" class="weaver.workflow.dmlaction.commands.bases.DMLActionBase" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("intergration:formactionsetting", user))
{
	response.sendRedirect("/notice/noright.jsp");
	return;
}
%>
<%
	String isDialog = Util.null2String(request.getParameter("isdialog"));
	
	String operate = Util.null2String(request.getParameter("operate"));
	String fromintegration = Util.null2String(request.getParameter("fromintegration"));
	String typename = Util.null2String(request.getParameter("typename"));
	int actionid = Util.getIntValue(Util.null2String(request.getParameter("actionid")),0);
	FormActionBase.setActionid(actionid);
	FormActionBase.initDMLAction();
	boolean isexists = FormActionBase.isIsexists();
	if(!isexists)
	{
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	//dmlactionname,dmlorder,workflowId,nodeid,ispreoperator,nodelinkid,datasourceid,dmltype
	String actionname = "";
	//数据源
	String datasourceid = "";
	//是否需要选择数据源
	/*boolean needcheckds = true;
	if(user.getUID()==1)
	{
		needcheckds = false;
	}*/
	boolean needcheckds = false;
	String isbill = "";
	String formid = "";
	
	//操作类型
	String dmltype = "";
	if(!"changetable".equals(operate))
	{
		actionname = FormActionBase.getActionname();
		//数据源
		datasourceid = FormActionBase.getDatasourceid();
		//操作类型
		dmltype = FormActionBase.getDmltype();
		
		formid = ""+FormActionBase.getFormid();
		isbill = ""+FormActionBase.getIsbill();
	}
	else
	{
		actionname = Util.null2String(request.getParameter("actionname"));
		//数据源
		datasourceid = Util.null2String(request.getParameter("datasourceid"));
		//操作类型
		dmltype = Util.null2String(request.getParameter("dmltype"));
		
		formid = Util.null2String(request.getParameter("formid"));

		isbill = Util.null2String(request.getParameter("isbill"));
	}
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
	int actionsqlsetid = 0;
	
	String actiontable = "";
	//表单id
	int dmlformid = 0;
	//表单名称
	String dmlformname = "";
	//是否为明细
	String dmlisdetail = "";
	//对应表名称
	String dmltablename = "";
	//表别名
	String dmltablebyname = "";
	//自定义条件
	String dmlcuswhere = "";
	//指定sql类型
	String dmlmainsqltype = "";
	//指定sql
	String dmlcussql = "";
	
	String maintablename = FormActionBase.getActiontable();
	Map dmlMap = FormActionBase.getDmlMap();
	Map fieldMap = FormActionBase.getFieldMap();
	Map whereMap = FormActionBase.getWhereMap();
	Map<String,Map<String,String>> fieldExtra = FormActionBase.getFieldExtra();
	Map<String,Map<String,String>> whereExtra = FormActionBase.getWhereExtra();
	String dbtype = DBTypeUtil.getDataSourceDbtype(RecordSet,datasourceid);
	//外部表字段以及类型
	Map allcolnums = new HashMap();
	//字段列表
	List fieldList = new ArrayList();
	Map fieldDBTypeMap = new HashMap();
	//字段标签列表
	Map fieldLabelMap = new HashMap();
	//字段名列表
	Map fieldNameMap = new HashMap();
	
	//field htmltype
	Map<String,String> fieldHtmlTypeMap = new HashMap<String,String>();
	//field type
	Map<String,String> fieldTypeMap = new HashMap<String, String>();
	
	boolean isused = BaseAction.checkFromActionUsed(""+actionid,"1");
	
	// 数据库类型
	boolean isoracle = (RecordSet.getDBType()).equals("oracle");
	
	//数据来源
	String dmlsourceinfo = "";
	if("changetable".equals(operate)){
		dmlsourceinfo = Util.null2String(request.getParameter("dmlsourceinfo"));
	}else{
		dmlsourceinfo = FormActionBase.getDmlsourceinfo();
	}
	
	int detailTableId = -1;
	int tablenamelabel = 26421;
	boolean isdetail = false;
	if(!"".equals(formid)){
		FieldBase.setIsbill(Util.getIntValue(isbill,0));
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
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<STYLE TYPE="text/css">
		.btn_actionList
		{
			width:100px!important;BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
		} 
		table.viewform td.line
		{
			height:1px!important;
		}
		table.setbutton td
		{
			padding-top:10px; 
		}
		table ul#tabs
		{
			width:85%!important;
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
	<script type="text/javascript" src="../action/checkActionName_busi.js"></script>
		<script type="text/javascript" src="/integration/banBackSpace.js"></script><!--QC267860  [80][90]流程流转集成-DML弹出窗口按Backspace会重复插入一条数据-->
	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(26418, user.getLanguage()); //配置接口动作(数据库DML)
		String needfav = "1";
		String needhelp = "";
	%>
	<body>
<%if("1".equals(isDialog)){ %>
<div class="zDialog_div_content">
<script language=javascript >
var parentWin = parent.parent.getParentWindow(parent);
</script>
<%} %>
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:submitData(),_self} ";
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
			else
			{
				//RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",/workflow/dmlaction/FormActionSettingView.jsp?fromintegration="+fromintegration+"&actionid="+actionid+"&typename="+typename+",_self} ";
				//RCMenuHeight += RCMenuHeightStep;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
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
		<form name="frmmain" method="post" action="/workflow/dmlaction/FormActionSettingOperation.jsp">
			<input type="hidden" id="operate" name="operate" value="edit">
			<input type="hidden" id="actionid" name="actionid" value="<%=actionid %>">
			<input type="hidden" id="fromintegration" name="fromintegration" value="<%=fromintegration %>">
			<input type="hidden" id="typename" name="typename" value="<%=typename %>">
<%if("1".equals(isDialog)){ %>
<input type="hidden" name="isdialog" value="<%=isDialog%>">
<%} %>
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
					<wea:item><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></wea:item>
												<wea:item>
												<!--QC267860  [80][90]流程流转集成-DML弹出窗口按Backspace会重复插入一条数据  autofocus="autofocus"-->
												<!--282798  [80][90]数据展现集成-新建页面【标识】建议限制前后输入空格 增加onblur事件-->
													<input type=text size=35 class=inputstyle style="width:280px!important;" id="actionname" autofocus="autofocus" name="actionname" value="<%=actionname%>" onblur="trimActionName(this.value)" onChange="checkinput('actionname','actionnamespan')">
													<span id="actionnamespan">
														<%
															if (actionname.equals(""))
															{
														%>
														<img src="/images/BacoError_wev8.gif" align=absmiddle>
														<%
															}
														%>
													</span>
												</wea:item>
												<wea:item><%=SystemEnv.getHtmlLabelName(15451, user.getLanguage())%></wea:item>
												<wea:item>
													<%=formname %>
													<input type="hidden" id="formid" name="formid" value="<%= ""+formid %>">
										    		<input type="hidden" id="isbill" name="isbill" value="<%= ""+isbill %>">
												</wea:item>
												<wea:item><%=SystemEnv.getHtmlLabelName(18076, user.getLanguage())%></wea:item>
												<wea:item>
													<select id="datasourceid" name="datasourceid" onchange="ChangeDatasource(this);<%if(needcheckds){ %>checkinput('datasourceid','datasourceidspan');<%} %>">
														<option value=''></option>
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
													<%if(needcheckds){ %>
													<span id="datasourceidspan">
													<%if (datasourceid.equals("")){%>
													<img src="/images/BacoError_wev8.gif" align=absmiddle>
													<%} %>
													</span>
													<%} %>
												</wea:item>
												<wea:item>DML<%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></wea:item><!-- 类型 -->
												<wea:item>
													<select id="dmltype" name="dmltype" style='width:80px!important;' onChange="checkinput('dmltype','dmltypespan');changeProcedure();">
														<option value=""></option>
														<option value="insert" <%if("insert".equals(dmltype)){ %>selected<%} %>>insert</option>
														<option value="update" <%if("update".equals(dmltype)){ %>selected<%} %>>update</option>
														<option value="delete" <%if("delete".equals(dmltype)){ %>selected<%} %>>delete</option>
														<option value="custom" <%if("custom".equals(dmltype)){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(82816, user.getLanguage())%></option>
														
													</select>
													<span id="dmltypespan">
													<%if (dmltype.equals("")){%>
													<img src="/images/BacoError_wev8.gif" align=absmiddle>
													<%} %>
													</span>
												</wea:item>
												
													<%--数据来源，主表，明细表1，明细表2，明细表xxx --%>
												<wea:item><%=SystemEnv.getHtmlLabelName(28006,user.getLanguage())%></wea:item>
												<wea:item>
												<%
													List<Map<String,String>> tableList = DMLActionBase.getDmlSource(formid,isbill,user.getLanguage()); 
												%>
												<select id="dmlsourceinfo" name="dmlsourceinfo" style="width:80px!important;" onchange="onChangeSource();">
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
													//表单，是否需要检查数据源以及是数据源是否为空
													if(!"".equals(formid))
													{
														FieldBase.getDMLActionFields(user,datasourceid,Util.getIntValue(formid,0),Util.getIntValue(isbill,0),0,dmlformid,dmltablename,Util.getIntValue(dmlisdetail,0),needcheckds);
														
														if("changetable".equals(operate)){
															if(isdetail){
																maintablename = FieldBase.getFormDetailTable();
															}else{
																maintablename = FieldBase.getFormtable();
															}
														}
														List actionSetList = (List)dmlMap.get(maintablename);
														List fieldsList = null;
														List wheresList = null;
														
														if(null!=actionSetList||"changetable".equals(operate))
														{
															if(!"changetable".equals(operate) || (actionSetList != null && actionSetList.size() > 0))
															{
																if(actionSetList.size()>0){
																	actionsqlsetid = Util.getIntValue((String)actionSetList.get(0),0);
																}
																//action数据源表名
																if(actionSetList.size()>1){
																	actiontable = Util.null2String((String)actionSetList.get(1));
																}
																//表单id
																if(actionSetList.size()>2){
																	dmlformid = Util.getIntValue((String)actionSetList.get(2),0);
																}
																//表单名称
																if(actionSetList.size()>3){
																	dmlformname = Util.null2String((String)actionSetList.get(3));
																}
																//是否为明细
																if(actionSetList.size()>4){
																	dmlisdetail = Util.null2String((String)actionSetList.get(4));
																}
																//对应表名称
																if(actionSetList.size()>5){
																	dmltablename = Util.null2String((String)actionSetList.get(5));
																}
																//表别名
																if(actionSetList.size()>6){
																	dmltablebyname = Util.null2String((String)actionSetList.get(6));
																}
																//自定义条件
																if(actionSetList.size()>7){
																	dmlcuswhere = Util.null2String((String)actionSetList.get(7));
																}
																//指定sql类型
																if(actionSetList.size()>8){
																	dmlmainsqltype = Util.null2String((String)actionSetList.get(8));
																}
																//指定sql
																if(actionSetList.size()>9){
																	dmlcussql = Util.null2String((String)actionSetList.get(9));
																}
																fieldsList = (List)fieldMap.get(""+actionsqlsetid);
																wheresList = (List)whereMap.get(""+actionsqlsetid);
															}
															else
															{
																actionsqlsetid = Util.getIntValue(Util.null2String(request.getParameter("actionsqlsetid")),0);
																//表单id
																dmlformid = Util.getIntValue(Util.null2String(request.getParameter("dmlformid")),0);
																//表单名称
																dmlformname = Util.null2String(request.getParameter("dmlformname"));
																//是否为明细
																dmlisdetail = Util.null2String(request.getParameter("dmlisdetail"));
																//对应表名称
																dmltablename = Util.null2String(request.getParameter("dmltablename"));
															}
															
															FieldBase.resetFieldList();
															FieldBase.getDMLActionFields(user,datasourceid,Util.getIntValue(formid,0),Util.getIntValue(isbill,0),0,dmlformid,dmltablename,Util.getIntValue(dmlisdetail,0),needcheckds);
															allcolnums = FieldBase.getAllcolnums();
													%>
													<wea:layout>
														<wea:group context='<%="DML"+SystemEnv.getHtmlLabelName(68,user.getLanguage())%>' attributes="{'samePair':'SetInfo','groupOperDisplay':'none'}">
																<wea:item><%=SystemEnv.getHtmlLabelName(1995, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(21778, user.getLanguage())%></wea:item>
																<wea:item>
																	<table width="100%">
																		<colgroup>
																				<col width="50%">
																				<col width="50%">
																		<tbody>
																			<tr>
																				<td id="thisdatasourceid" class=field style="display:<%if(!datasourceid.equals("")||needcheckds){ %>none<%} %>">
																					<%
																					String browserUrl = "/systeminfo/BrowserMain.jsp?mouldID=workflow&url=/workflow/workflow/triggerTableBrowser.jsp";
																					if(!"custom".equals(dmltype)) {
																					%>
																						<brow:browser viewType="0" name="tempdmltablename" browserValue='<%= ""+dmltablename %>' 
																							browserUrl='<%=browserUrl%>'
																							hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='2'
																							completeUrl="" linkUrl=""
																							browserSpanValue='<%=dmlformname %>' _callback="onShowTable" _callbackParams=""></brow:browser>
																					<%} else {%>
																						<brow:browser viewType="0" name="tempdmltablename" browserValue='<%= ""+dmltablename %>' 
																							browserUrl='<%=browserUrl%>'
																							hasInput="false" isSingle="false" hasBrowser = "true" isMustInput='1'
																							completeUrl="" linkUrl=""
																							browserSpanValue='<%=dmlformname %>' _callback="onShowTable" _callbackParams=""></brow:browser>
																					<%}%>
																					<input type=hidden id="actionsqlsetid" name="actionsqlsetid" value="<%=actionsqlsetid %>">
																					<input type=hidden id="dmlformid" name="dmlformid" value="<%=dmlformid %>">
																					<input type=hidden id="dmlformname" name="dmlformname" value="<%=dmlformname %>">
																					<input type=hidden id="dmlisdetail" name="dmlisdetail" value="<%=dmlisdetail %>">
																				</td>
																				<td class=field>
																					<input type=text class=Inputstyle size=20 maxlength=50 id="dmltablename" name="dmltablename" value="<%=dmltablename %>"	onBlur='checkinput_char_num("dmltablename");' onchange="javascript:changeTableField();checkinput('dmltablename','dmltablenamespans');changeImage();"><span id="dmltablenamespans"><%if (dmltablename.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%} %></span>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</wea:item>
																<wea:item><%=SystemEnv.getHtmlLabelName(tablenamelabel, user.getLanguage())%></wea:item><!-- 流程数据库表名，主表，明细表都可能-->
																<wea:item>
																	<%=maintablename %>
																	<input type=hidden id="maintablename" name="maintablename" value="<%=maintablename %>">
																</wea:item>
															
																<wea:item attributes="{'colspan':'2'}">
																	<div class="listparams e8_box demo2" id="tabbox" style='height:42px;'>
									    							<ul class="tab_menu" id="tabs" style="width:85%!important;">
																    	<li style='padding-left:0px!important;'><a href="#">DML <%=SystemEnv.getHtmlLabelName(21845, user.getLanguage())%></a></li> <!-- 赋值设置 -->
															            <li style="display:none;"></li>
																        <li style="display:none;"></li>
																        <li><a href="#"><%=SystemEnv.getHtmlLabelName(130492, user.getLanguage())%></a></li><!-- 自定义DML语句 -->
																    </ul>
																    <div class="tab_box" style="display:none;width:0px;"></div>
																</div>								
															</wea:item>
													<%
													allcolnums = FieldBase.getAllcolnums();
													//字段列表
													fieldList = FieldBase.getFieldList();
													
													if(null!=fieldList)
													{
														showExplanation = true;
														//字段类型列表
														fieldDBTypeMap = FieldBase.getFieldDBTypeMap();
														//字段标签列表
														fieldLabelMap = FieldBase.getFieldLabelMap();
														//字段名列表
														fieldNameMap = FieldBase.getFieldNameMap();
														
														//field htmltype
														fieldHtmlTypeMap = FieldBase.getFieldHtmlTypeMap();
														//field type
														fieldTypeMap = FieldBase.getFieldTypeMap();
													%>
															<wea:item attributes="{'colspan':'2','isTableList':'true'}">
																	<div id="propDiv">
																		<table width="100%" class='ViewForm' cellpadding="0" cellspacing="0">
																			<colgroup>
																				<col width="20%">
																				<col width="30%">
																				<col width="20%">
																				<col width="30%">
																			<tbody>
																				<tr class="listparams listparams1 listparam">
																					<td colspan=4 vAlign="top"  style="background-color:#FFF" style='padding-left:0px!important;'>
																						<ul class="tab_menu" style="width:85%!important;">
																							<li><a href="#">DML <%=SystemEnv.getHtmlLabelName(21845, user.getLanguage())%></a></li>
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
																						<table width="100%" class='ListStyle' id="fieldValueTableTr" style="padding:0px;margin:0px;" cellpadding="0" cellspacing="0">
																							<colgroup>
																								<col width="3%">
																								<col width="15%">
																								<col width="10%">
																								<col width="20%">
																								<col width="10%">
																								<col width="15%">
																								<col width="17%">
																							<tbody>
																								<tr class=header>
																									<th><INPUT type="checkbox" id="chkAll" name="chkAll" onClick="chkAllClick(this,'dmlcheck')"></th>
																									<th><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></th><!-- 字段名称 -->
																									<th><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></th><!-- 字段类型 -->
																									<th><%=SystemEnv.getHtmlLabelName(26422, user.getLanguage())%></th><!-- 同步对应字段 -->
																									<th><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></th><!-- 字段名称 -->
																									<th><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></th><!-- 字段类型 -->
																									<th><%=SystemEnv.getHtmlLabelName(23128, user.getLanguage())%></th><!-- 转换规则 -->
																								</tr>
																								<%
																								//System.out.println("fieldsList : "+fieldsList);
																								boolean isright = true;
																								Set columnSet = allcolnums.keySet();
																								int m = 0;
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
																									boolean iscanhandle = DBTypeUtil.checkFieldDBType(fielddbtype,dbtype);
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
																										
																										//System.out.println(fieldname+"="+fielddbtype+"="+tempjfieldname);
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
																									m++;
																								%>
																									<tr style="height:20px;" class="<%=isright?"DataLight":"DataDark" %>">
																										<td><input type=checkbox id='dmlcheck' name='dmlcheck'></td><td>
																											<div>
																												<div class='e8Browser' id='dmle8Browser_<%=m %>'>
																													<script type="text/javascript">
																														$(document).ready(function(){
																															try
																														    {
																														       	jQuery("#dmle8Browser_<%=m %>").e8Browser({
																																   name:"fieldname",
																																   viewType:"0",
																																   browserValue:"<%= ""+fieldname %>",
																																   isMustInput:"1",
																																   browserSpanValue:"<%=fieldname %>",
																																   getBrowserUrlFn:'onShowTableFieldValue',
																																   getBrowserUrlFnParams:"",
																																   hasInput:false,
																																   linkUrl:"#",
																																   isSingle:true,
																																   isMustInput:'1',
																																   completeUrl:"/data.jsp",
																																   browserUrl:"",
																																   hasAdd:false,
																																   isSingle:true,
																																   _callback:"onSetTableField",
																																   _callbackParams:'dml'
																																});
																															}
																															catch(e)
																															{
																																//alert(e);
																															}
																														});
																															
																													</script>
																												</div>
																											</div>
																										</td><td><input type=text id='showtype' name='showtype' value='<%=fielddbtype %>' style='border:0px;' readOnly='true'></td><td>
																											<div>
																												<div class='e8Browser' id="dmle8BrowserValue_<%=m %>">
																													<script type="text/javascript">
																														$(document).ready(function(){
																															try
																														    {
																														       	jQuery("#dmle8BrowserValue_<%=m %>").e8Browser({
																																   name:"dmlfieldnametemp",
																																   viewType:"0",
																																   idKey:"name",
																																   nameKey:"id",
																																   browserValue:"<%= ""+jfieldname %>",
																																   isMustInput:"1",
																																   browserSpanValue:"<%=jfieldlabel %>",
																																   getBrowserUrlFn:'onShowFormField',
																																   getBrowserUrlFnParams:"",
																																   hasInput:false,
																																   linkUrl:"#",
																																   isSingle:true,
																																   isMustInput:'1',
																																   completeUrl:"/data.jsp",
																																   browserUrl:"",
																																   hasAdd:false,
																																   isSingle:true,
																																   _callback:"onSetFormField",
																																   _callbackParams:'dml'
																																});
																															}
																															catch(e)
																															{
																																//alert(e);
																															}
																														});
																															
																													</script>
																												</div>
																												<input type=hidden id='dmlfieldname' name='dmlfieldname' value='<%=fieldname %>=<%=fielddbtype %>=<%=jfieldname %>'>
																											</div>
																										</td><td><input type=text id='dmlfieldshow' name='dmlfieldshow' value='<%=jfieldname %>' style='border:0px;' readOnly='true'></td><td><input type=text id='showtype' name='showtype' value='<%=jfielddbtype %>' style='border:0px;' readOnly='true'></td>
																										
																										<%--转换规则 --%>
																										<td>
																											<select name="transttypevalue" onchange="onChangeTranstType(this)">
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
					  																							<input type="text" name="extravalue" value="<%=jextrainfo%>"/>
					  																						<%		
					  																							}else if("7".equals(jtransttype)){
					  																						%>
					  																							<textarea name="extravalue" rows="3" ><%=jextrainfo%></textarea>
					  																						<%		
					  																							}else{
					  																						%>
					  																							<input type="hidden" name="extravalue" value="<%=jextrainfo%>"/>
					  																						<%		
					  																							}
					  																						%>
																										</td>
																									</tr>
																									<tr style="HEIGHT: 1px!important;"><td style="height:1px!important;" class=line colspan=6></td></tr>
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
																							<li><a href="#">DML <%=SystemEnv.getHtmlLabelName(27957, user.getLanguage())%></a></li>
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
																				<tr class='listparams listparams1 listparams2 listparam' id='fieldWhereTable'>
																					<td colspan=4 vAlign="top" style='padding-left:0px!important;'>
																						<table width="100%" class='ListStyle' id="fieldWhereTableTr" style="padding:0px;margin:0px;" cellpadding="0" cellspacing="0">
																							<colgroup>
																								<col width="3%">
																								<col width="15%">
																								<col width="10%">
																								<col width="20%">
																								<col width="10%">
																								<col width="15%">
																								<col width="17%">
																								<tr class=header>
																									<th><INPUT type="checkbox" id="chkAll" name="chkAll" onClick="chkAllClick(this,'wherecheck')"></th><!-- 字段显示名 -->
																									<th><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></th><!-- 字段名 -->
																									<th><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></th><!-- 字段类型 -->
																									<th><%=SystemEnv.getHtmlLabelName(26424, user.getLanguage())%></th><!-- 条件对应字段 -->
																									<th><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></th><!-- 字段名称 -->
																									<th><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></th><!-- 字段类型 -->
																									<th><%=SystemEnv.getHtmlLabelName(23128, user.getLanguage())%></th><!-- 转换规则 -->
																								</tr>
																								<%
																								isright = true;
																								int k = 0;
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
																									boolean iscanhandle = DBTypeUtil.checkFieldDBType(fielddbtype,dbtype);
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
																									k++;
																								%>
																									<tr style="height:20px;" class="<%=isright?"DataLight":"DataDark" %>">
																										<td><input type=checkbox id='wherecheck' name='wherecheck'></td><td>
																											<div>
																												<div class='e8Browser' id="wheree8Browser_<%= ""+k %>">
																													<script type="text/javascript">
																														$(document).ready(function(){
																															try
																														    {
																														       	jQuery("#wheree8Browser_<%=k %>").e8Browser({
																																   name:"fieldname",
																																   viewType:"0",
																																   browserValue:"<%= ""+fieldname %>",
																																   isMustInput:"1",
																																   browserSpanValue:"<%=fieldname %>",
																																   getBrowserUrlFn:'onShowTableField',
																																   getBrowserUrlFnParams:"",
																																   hasInput:false,
																																   linkUrl:"#",
																																   isSingle:true,
																																   isMustInput:'1',
																																   completeUrl:"/data.jsp",
																																   browserUrl:"",
																																   hasAdd:false,
																																   isSingle:true,
																																   _callback:"onSetTableField",
																																   _callbackParams:'where'
																																});
																															}
																															catch(e)
																															{
																																//alert(e);
																															}
																														});
																															
																													</script>
																												</div>
																											</div>
																										</td><td><input type=text id='showtype' name='showtype' value='<%=fielddbtype %>' style='border:0px;' readOnly='true'></td><td>
																											<div>
																												<div class='e8Browser' id='wheree8BrowserValue_<%=k %>'>
																													<script type="text/javascript">
																														$(document).ready(function(){
																															try
																														    {
																														       	jQuery("#wheree8BrowserValue_<%=k %>").e8Browser({
																																   name:"wherefieldnametemp",
																																   viewType:"0",
																																   idKey:"name",
																																   nameKey:"id",
																																   browserValue:"<%= ""+jwherefieldname %>",
																																   isMustInput:"1",
																																   browserSpanValue:"<%=jwherefieldlabel %>",
																																   getBrowserUrlFn:'onShowFormField',
																																   getBrowserUrlFnParams:"",
																																   hasInput:false,
																																   linkUrl:"#",
																																   isSingle:true,
																																   isMustInput:'1',
																																   completeUrl:"/data.jsp",
																																   browserUrl:"",
																																   hasAdd:false,
																																   isSingle:true,
																																   _callback:"onSetFormField",
																																   _callbackParams:'where'
																																});
																															}
																															catch(e)
																															{
																																//alert(e);
																															}
																														});
																													</script>
																												</div>
																												<input type=hidden id='wherefieldname' name='wherefieldname' value='<%=fieldname %>=<%=fielddbtype %>=<%=jwherefieldname %>'>
																											</div>
																										</td><td><input type=text id='wherefieldshow' name='wherefieldshow' value='<%=jwherefieldname %>' style='border:0px;' readOnly='true'></td><td><input type=text id='showtype' name='showtype' value='<%=jwherefielddbtype %>' style='border:0px;' readOnly='true'></td>
																										
																										<%--转换规则 --%>
																										<td>
																											<select name="transttypewhere" onchange="onChangeTranstType(this)">
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
					  																							<input type="text" name="extrawhere" value="<%=jextrainfo%>"/>
					  																						<%		
					  																							}else if("7".equals(jtransttype)){
					  																						%>
					  																							<textarea name="extrawhere" rows="3" ><%=jextrainfo%></textarea>
					  																						<%		
					  																							}else{
					  																						%>
					  																							<input type="hidden" name="extrawhere" value="<%=jextrainfo%>"/>
					  																						<%		
					  																							}
					  																						%>
																										</td>
																									</tr>
																									<tr style="HEIGHT: 1px!important;"><td style="height:1px!important;" class=line colspan=6></td></tr>
																								<%
																									isright = isright?false:true;
																								}
																								%>
																							</tbody>
																						</table>
																					</td>
																				</tr>
																				<tr style="HEIGHT: 1px!important;" class='listparams listparams1 listparams2 listparam'><td style="height:1px!important;" class=line colspan=4></td></tr>
																				<tr class="listparams listparams1 listparams3 listparam">
																					<td colspan=4 vAlign="top"   style="background-color:#FFF"  style='padding-left:0px!important;'>
																					<ul class="tab_menu" style="width:85%!important;">
																						<li>
																							<a href="#"><%=SystemEnv.getHtmlLabelName(130497, user.getLanguage())%></a>
																						</li>
																					</ul>
																					</td>
																				</tr>
																				<tr class='listparams listparams1 listparams3 listparam'>
																					<td valign="top" style='padding-left:30px!important;BACKGROUND-COLOR:white;'><%=SystemEnv.getHtmlLabelName(130497, user.getLanguage())%></td><!-- 自定义主表条件 -->
																					<td class=field colspan=3>
																						<textarea id="dmlmainwhere" name="dmlmainwhere" cols=100 rows=4><%=dmlcuswhere %></textarea>
																					</td>
																				</tr>
																				<tr class="listparams listparams1 listparams3 listparam" style="height:1px!important;"><td style="height:1px!important;" class=line colspan=4 style="padding: 0px;"></td></tr>
																				<tr class="listparams listparams4 listparam">
																					<td valign="top" style='padding-left:30px!important;BACKGROUND-COLOR:white;'><%=SystemEnv.getHtmlLabelName(130492, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></td><!-- 自定义主表DML语句类型 -->
																					<td class=field colspan=3>
																						<select id="dmlmainsqltype" style='width:80px!important;' name="dmlmainsqltype">
																						
																							<option value="0" <%if("0".equals(dmlmainsqltype)||"".equals(dmlmainsqltype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(27670, user.getLanguage())%></option>
																							<option value="1" <%if("1".equals(dmlmainsqltype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(27671, user.getLanguage())%></option>
																						
																						</select>
																						<a href="readme.docx" target="_blank" title="<%=SystemEnv.getHtmlLabelName(15593,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(15593,user.getLanguage()) %></a>
																					</td>
																				</tr>
																				<tr style="HEIGHT: 1px!important;" class='listparams listparams4 listparam'><td style="height:1px!important;padding-left:30px!important;" class=line colspan=4></td></tr>
																				<tr class='listparams listparams4 listparam'>
																					<td valign="top" style='padding-left:30px!important;BACKGROUND-COLOR:white;'><%=SystemEnv.getHtmlLabelName(130492, user.getLanguage())%></td><!-- 自定义主表DML语句 -->
																					<td class=field colspan=3>
																						<textarea id="dmlmainsql" name="dmlmainsql" cols=100 rows=4><%=dmlcussql %></textarea>
																					</td>
																				</tr>
																				<tr style="HEIGHT: 1px!important;" class='listparams listparams4 listparam'><td style="height:1px!important;padding-left:30px!important;" class=line colspan=4></td></tr>
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
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;update hrmresource set lastname='{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>A}',mobile='{?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>B}' ... where userid={?<%=SystemEnv.getHtmlLabelName(27678, user.getLanguage())%>C} and ...<br>
												   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(27679, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(27682, user.getLanguage())%>。<br><!-- sql中，{?流程字段名称*}将会被替换为流程中的对应字段的数据。具体sql格式，根据数据源数据库类型,以及字段类型决定 -->
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
<%if("1".equals(isDialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick="onClose();"></input>
				</wea:item>
			</wea:group>
		</wea:layout>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				resizeDialog(document);
			});
		</script>
	</div>
</div>
<%} %>
	</body>
</html>
<script language="javascript">
var checkfield1 = "";
var checkfield2 = "";
var checkfield3 = "";
<%
if(needcheckds)
{
%>
	checkfield1 = "datasourceid";
	checkfield2 = "dmltablename,datasourceid";
	checkfield3 = "actionname,formid,dmltablename,datasourceid";
<%
}
else
{
%>
	checkfield1 = "";
	checkfield2 = "dmltablename";
	checkfield3 = "actionname,formid,dmltablename";
<%	
}
%>
var isright = true;
function addRow(fieldtable,fieldname)
{
	var oTable=document.getElementById(fieldtable);
	var rowIndex=oTable.rows.length;
	var oRow1 = oTable.insertRow(rowIndex);
	
	oRow1.style.height=20;
	oRow1.className = isright?"DataLight":"DataDark";
	
    var oCell1 = oRow1.insertCell(0);
	oCell1.style.wordWrap= "break-word";
	oCell1.style.wordBreak= "break-all";
    var sHtml = "<input type=checkbox id='"+fieldname+"check' name='"+fieldname+"check'>";
    oCell1.innerHTML = sHtml;
    jQuery(oCell1).jNice();
    
    var oCell2 = oRow1.insertCell(1);
	oCell2.style.wordWrap= "break-word";
	oCell2.style.wordBreak= "break-all";
	var oDiv = document.createElement("div");
    oDiv.innerHTML="<div class='e8Browser'></div>";
    oCell2.appendChild(oDiv);
    //var sHtml = "<button type='button' class=Browser onClick=\"onShowTableField(this);\"></BUTTON><input type=text id='fieldname' name='fieldname' value='' style='border:0px;' readOnly='true'>";
    if(fieldtable == "fieldValueTableTr") {
    	//var sHtml = "<BUTTON type='button' class=Browser onClick=\"onShowTableFieldValue(this);\"></BUTTON><input type=text id='fieldname' name='fieldname' value='' style='border:0px;' readOnly='true'>";
    	try
	    {
	       	jQuery(oDiv).find(".e8Browser").e8Browser({
			   name:"fieldname",
			   viewType:"0",
			   browserValue:"",
			   isMustInput:"1",
			   browserSpanValue:"",
			   getBrowserUrlFn:'onShowTableFieldValue',
			   getBrowserUrlFnParams:"",
			   hasInput:false,
			   linkUrl:"#",
			   isSingle:true,
			   isMustInput:'1',
			   completeUrl:"/data.jsp",
			   browserUrl:"",
			   hasAdd:false,
			   isSingle:true,
			   _callback:"onSetTableField",
			   _callbackParams:fieldname
			});
		}
		catch(e)
		{
			//alert(e);
		}
    }else {
    	//var sHtml = "<button type='button' class=Browser onClick=\"onShowTableField(this);\"></BUTTON><input type=text id='fieldname' name='fieldname' value='' style='border:0px;' readOnly='true'>";
    	try
	    {
	       	jQuery(oDiv).find(".e8Browser").e8Browser({
			   name:"fieldname",
			   viewType:"0",
			   browserValue:"",
			   isMustInput:"1",
			   browserSpanValue:"",
			   getBrowserUrlFn:'onShowTableField',
			   getBrowserUrlFnParams:"",
			   hasInput:false,
			   linkUrl:"#",
			   isSingle:true,
			   isMustInput:'1',
			   completeUrl:"/data.jsp",
			   browserUrl:"",
			   hasAdd:false,
			   isSingle:true,
			   _callback:"onSetTableField",
			   _callbackParams:fieldname
			});
		}
		catch(e)
		{
			//alert(e);
		}
    }
    
    
    var oCell3 = oRow1.insertCell(2);
    oCell3.style.wordWrap= "break-word";
	oCell3.style.wordBreak= "break-all";
    var sHtml = "<input type=text id='showtype' name='showtype' value='' style='border:0px;' readOnly='true'>";
    oCell3.innerHTML = sHtml;
        
    var oCell4 = oRow1.insertCell(3);
    oCell4.style.wordWrap= "break-word";
	oCell4.style.wordBreak= "break-all";
	var oDiv = document.createElement("div");
    oDiv.innerHTML="<div class='e8Browser'></div><input type=hidden id='"+fieldname+"fieldname' name='"+fieldname+"fieldname' value=''>";
    oCell4.appendChild(oDiv);
    //oCell4.innerHTML = sHtml;
    try
    {
       	jQuery(oDiv).find(".e8Browser").e8Browser({
		   name:fieldname+"fieldnametemp",
		   viewType:"0",
		   idKey:"name",
		   nameKey:"id",
		   browserValue:"",
		   isMustInput:"1",
		   browserSpanValue:"",
		   getBrowserUrlFn:'onShowFormField',
		   getBrowserUrlFnParams:"",
		   hasInput:false,
		   linkUrl:"#",
		   isSingle:true,
		   isMustInput:'1',
		   completeUrl:"/data.jsp",
		   browserUrl:"",
		   hasAdd:false,
		   isSingle:true,
		   _callback:"onSetFormField",
		   _callbackParams:fieldname
		});
	}
	catch(e)
	{
		//alert(e);
	}
    
    var oCell5 = oRow1.insertCell(4);
	oCell5.style.wordWrap= "break-word";
	oCell5.style.wordBreak= "break-all";
    var sHtml = "<input type=text id='"+fieldname+"fieldshow' name='"+fieldname+"fieldshow' value='' style='border:0px;' readOnly='true'>";
    oCell5.innerHTML = sHtml;

    var oCell6 = oRow1.insertCell(5);
    oCell6.style.wordWrap= "break-word";
	oCell6.style.wordBreak= "break-all";
    var sHtml = "<input type=text id='showtype' name='showtype' value='' style='border:0px;' readOnly='true'>";
    oCell6.innerHTML = sHtml;

    var oCell7 = oRow1.insertCell(6);
    oCell7.style.wordWrap= "break-word";
	oCell7.style.wordBreak= "break-all";

	var selname = "transttypevalue";

	if(fieldtable == "fieldWhereTableTr"){
		selname = "transttypewhere";
	}
	
	var sHtml = "<select name=\"" + selname + "\" onchange=\"onChangeTranstType(this)\">"
			  + "<option value=\"\">&nbsp;</option>"
			  + "<option value=\"1\"><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>"
			  + "<option value=\"7\"><%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%></option>"
			  + "</select>";
	oCell7.innerHTML = sHtml;		

	/*
    var oRow2 = oTable.insertRow(rowIndex+1);
    oRow2.style.height="1px"
    var oCell5 = oRow2.insertCell(0);
    oCell5.className = "line";
    oCell5.style.height="1px"
	oCell5.colSpan = 6;
    oCell5.style.padding=0;
    */
	isright = isright?false:true;
	//美化下拉框组件
	beautySelect();
}
function delRow(fieldtable,checkname,isconfirm)
{
	var deleteList = new Array();
	var oTable=document.getElementById(fieldtable);
	var checknames = document.getElementsByName(checkname);
	var len = checknames.length;
	if(len>0)
	{
		try
		{
			for(var i = 0;i<len;i++)
			{
				var checknameelm = checknames[i];
				if(checknameelm.checked)
				{
					var oRow = $(checknameelm).closest("tr");
					var oRowLine = oRow.next();
					deleteList.push(oRow);
					deleteList.push(oRowLine);
				}
			}
		}
		catch(e)
		{
		}
	}
	if(deleteList.length>0)
	{
		if(isconfirm)
		{
			top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
				for(var di = 0;di<deleteList.length;di++)
				{
					deleteList[di].remove();
				}
			}, function () {}, 320, 90);
		}
		else
		{
			for(var di = 0;di<deleteList.length;di++)
			{
				deleteList[di].remove();
			}
		}
	}
	else
	{
		//请选择需要删除的数据
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(22686, user.getLanguage())%>")
	}
}
function deleteAllRow(fieldtable,checkname)
{
	var checknames = document.getElementsByName(checkname);
	var len = checknames.length;
	if(len>0)
	{
		try
		{
			for(var i = 0;i<len;i++)
			{
				checknames[i].checked = true;
			}
		}
		catch(e)
		{
		}
		delRow(fieldtable,checkname,false);
	}
}
function changeTableField()
{
	checkinput('dmltablename','dmltablenamespans');
	var olddmltablename = "<%=dmltablename %>";
	var olddmlformname = "<%=dmlformname %>";
	var olddmlformid = "<%=dmlformid %>";
	var olddmlisdetail = "<%=dmlisdetail %>";
	
	var newdmltablename = document.getElementById('dmltablename').value;
	var newdmlformname = document.getElementById('dmlformname').value;
	var newdmlformid = document.getElementById('dmlformid').value;
	var newdmlisdetail = document.getElementById('dmlisdetail').value;
	var tempdmltablename = document.getElementById('tempdmltablename').value;
	if(newdmltablename!="")
	{
		document.getElementById('tempdmltablenamespanimg').innerHTML = "";
	}
	
	if(olddmltablename!=newdmltablename||olddmlformname!=newdmlformname||olddmlformid!=newdmlformid||olddmlisdetail!=newdmlisdetail)
	{
		//外部主表发生改变,将重新获取字段信息,确定此修改吗
		var hasField = hasFieldAdd();
		if(hasField)
		{
			top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(26430,user.getLanguage())%>?", function (){
				if(newdmltablename=="")
				{
					deleteAllRow('fieldValueTableTr','dmlcheck');
					deleteAllRow('fieldWhereTableTr','wherecheck');
				}
				else
				{
					if((newdmlformid!=""&&newdmlformid!="0")&&olddmlformid==newdmlformid)
					{
						document.getElementById('dmltablename').value = olddmltablename;
					}
					
				    deleteAllRow('fieldValueTableTr','dmlcheck');
					deleteAllRow('fieldWhereTableTr','wherecheck');
			    }
			}, function () {
				//document.getElementById('dmltablenamespan').innerHTML = olddmlformname;
				document.getElementById('dmlformid').value = olddmlformid;
				document.getElementById('dmlformname').value = olddmlformname;
				document.getElementById('dmlisdetail').value = olddmlisdetail;
				document.getElementById('dmltablename').value = olddmltablename;
			}, 320, 90);
		}
	}
	var dmltablename = document.getElementById('dmltablename').value;
	//alert("dmltablename : "+dmltablename+" tempdmltablename : "+tempdmltablename);
	if(newdmltablename!=dmltablename)
	{
		try
		{
			if(dmltablename!="")
			{
				document.getElementById('tempdmltablenamespanimg').innerHTML = "";
				document.getElementById('tempdmltablenamespan').innerHTML = "";
				document.getElementById('tempdmltablename').value = dmltablename;
			}
			else
			{
				document.getElementById('tempdmltablenamespanimg').innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
				document.getElementById('tempdmltablenamespan').innerHTML = "";
				document.getElementById('tempdmltablename').value = "";
			}
		}
		catch(e)
		{
		}
	}
	
}
function appendField(dmltype,fieldname,fielddbtype,iscanhandle,obj)
{
	try{
		if(fieldname=="")
		{
			fieldname = "";
			fielddbtype = "";
			//return;
		}
		if(typeof(fieldname)=="undefined")
		{
			return;
		}
		//字段名
		var obj = obj.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement;
		//alert(obj.outerHTML)
		//var objfield = obj.parentElement.nextSibling;
		//objfield.value = fieldname;
		//字段类型
		var dbtypecell = obj.nextSibling.firstChild;
		dbtypecell.value = fielddbtype;
		
		var formfieldname = jQuery(obj.nextSibling.nextSibling.nextSibling).find("#"+dmltype+"fieldshow").val();
		//alert("formfieldname : "+formfieldname);
		if(""!=formfieldname&&""!=fieldname&&""!=fielddbtype){
			jQuery(obj.nextSibling.nextSibling).find("#"+dmltype+"fieldname").val(fieldname+"="+fielddbtype+"="+formfieldname);
		}else{
			jQuery(obj.nextSibling.nextSibling).find("#"+dmltype+"fieldname").val("");
		}
		//alert(jQuery(obj.nextSibling.nextSibling).find("#"+dmltype+"fieldname").val());
	}catch(e){
		top.Dialog.alert(e);
	}
}
function onShowFormField(obj){
	var formid = '<%=formid%>';
	var isbill = '<%=isbill%>';

	//数据来源,主表，明细表
	var dmlsourceinfo = jQuery("#dmlsourceinfo option:selected").val();
	var showdetail = "0";
	var tableid = "-1";
	if(dmlsourceinfo != null && dmlsourceinfo.indexOf("detail_") == 0){
		showdetail = "1";
		var sourceinfo = dmlsourceinfo.split("_");
		if(sourceinfo.length == 3){
			tableid = sourceinfo[1];
		} 
	}
	
	
	var urls = "/systeminfo/BrowserMain.jsp?mouldID=workflow&formid="+formid+"&isbill="+isbill+"&url=/workflow/dmlaction/dmlFormFieldsBrowser.jsp?formid="+formid+"&isbill="+isbill + "&showdetail=" + showdetail + "&tableid=" + tableid;
	//alert(urls);
	return urls;
}
function onSetFormField(event,data,name,dmltype,tg)
{
	var fieldname = "";
	var fielddbtype = "";
	var showname = "";
	var obj = null;
	//alert(typeof(tg)+"  event : "+event);
	if(typeof(tg)=='undefined'){
		obj= event.target || event.srcElement;
	}
	else
	{
		obj = tg;
	}
	if(data){
		if(data.id != ""){
			showname = data.id;
			fieldname = data.name;
			fielddbtype = data.fielddbtype;
			
			// 显示转化自定义浏览框的数据库字段类型
			if(fielddbtype.indexOf("browser") != -1) {
				<%
				if(isoracle) {
				%>
					fielddbtype = "varchar2(1000)";
				<%
				} else {
				%>
					fielddbtype = "varchar(1000)";
				<%
				}
				%>
			}
			
		}else{
			fieldname = "";
			fielddbtype = "";
			showname = "";
		}
	}
	appendFormField(dmltype,fieldname,fielddbtype,showname,obj);
	
	//根据选择的表单字段的类型,设置不同的转换规则
	setTranstType(obj,data);

	//设置字段隐藏域的值
	setHiddenField(obj,data);
}

//根据选择的表单字段的类型,设置不同的转换规则
function setTranstType(obj,data){
	if(data){
		var fieldhtmltype = data.fieldhtmltype;
		var fieldtype = data.fieldtype;

		var selname = "transttypevalue";
		var objid = jQuery(obj).closest("table").attr("id");
		if(objid == "fieldWhereTableTr"){
			selname = "transttypewhere";
		}
		
		//浏览按钮,单人力、多人力、分权单人力、分权多人力
		if(fieldhtmltype == 3 && (fieldtype == 1 || fieldtype == 17 || fieldtype == 165 || fieldtype == 166)){
			//1:固定值,2:显示值,3:人员编号,4:登录名,5:手机号码,6:email,7:自定义sql
			var shtml = "<select name=\"" + selname + "\" onchange=\"onChangeTranstType(this)\">"
					  + "<option value=\"\">&nbsp;</option>"
				  	  + "<option value=\"1\"><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>"
				  	  + "<option value=\"2\"><%=SystemEnv.getHtmlLabelName(82067,user.getLanguage())%></option>"
				  	  + "<option value=\"3\"><%=SystemEnv.getHtmlLabelName(27940,user.getLanguage())%></option>"
				  	  + "<option value=\"4\"><%=SystemEnv.getHtmlLabelName(412,user.getLanguage())%></option>"
				  	  + "<option value=\"5\"><%=SystemEnv.getHtmlLabelName(22482,user.getLanguage())%></option>"
				  	  + "<option value=\"6\">Email</option>"
				  	  + "<option value=\"7\"><%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%></option>"
					  + "</select>";
		//浏览按钮,部门,多部门,分权单部门,分权多部门
		}else if(fieldhtmltype == 3 && (fieldtype == 4 || fieldtype == 57 || fieldtype == 167 || fieldtype == 168)){
			//1:固定值,2:显示值,3:部门编号,7:自定义sql
			var shtml = "<select name=\"" + selname + "\" onchange=\"onChangeTranstType(this)\">"
					  + "<option value=\"\">&nbsp;</option>"
				  	  + "<option value=\"1\"><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>"
				  	  + "<option value=\"2\"><%=SystemEnv.getHtmlLabelName(82067,user.getLanguage())%></option>"
				  	  + "<option value=\"3\"><%=SystemEnv.getHtmlLabelName(15391,user.getLanguage())%></option>"
				  	  + "<option value=\"7\"><%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%></option>"
					  + "</select>";
		//浏览按钮,分部,多分部,分权单分部,分权多分部
		}else if(fieldhtmltype == 3 && (fieldtype == 164 || fieldtype == 194 || fieldtype == 169 || fieldtype == 170)){
			//1:固定值,2:显示值,3:分部编号,7:自定义sql
			var shtml = "<select name=\"" + selname + "\" onchange=\"onChangeTranstType(this)\">"
					  + "<option value=\"\">&nbsp;</option>"
				  	  + "<option value=\"1\"><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>"
				  	  + "<option value=\"2\"><%=SystemEnv.getHtmlLabelName(82067,user.getLanguage())%></option>"
				  	  + "<option value=\"3\"><%=SystemEnv.getHtmlLabelName(22289,user.getLanguage())%></option>"
				  	  + "<option value=\"7\"><%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%></option>"
					  + "</select>";

	    //3：浏览安，5：选择框，6：附件，7：特殊字段
		}else if(fieldhtmltype == 3 || fieldhtmltype == 5 || fieldhtmltype == 6 || fieldhtmltype == 7){
			//1:固定值,2:显示值,7:自定义sql
			var shtml = "<select name=\"" + selname + "\" onchange=\"onChangeTranstType(this)\">"
					  + "<option value=\"\">&nbsp;</option>"
				  	  + "<option value=\"1\"><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>"
				  	  + "<option value=\"2\"><%=SystemEnv.getHtmlLabelName(82067,user.getLanguage())%></option>"
				  	  + "<option value=\"7\"><%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%></option>"
					  + "</select>";
		}else{
			//1:固定值,7:自定义sql
			var shtml = "<select name=\"" + selname + "\" onchange=\"onChangeTranstType(this)\">"
					  + "<option value=\"\">&nbsp;</option>"
				  	  + "<option value=\"1\"><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>"
				  	  + "<option value=\"7\"><%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%></option>"
					  + "</select>";
		}

		var inputName = "extravalue";
		if(objid == "fieldWhereTableTr"){
			inputName = "extrawhere";
		}
		var inputHtml = "<input type=\"hidden\" name=\"" + inputName + "\" value=\"\" style=\"\"/>";
		shtml += inputHtml;
		
		jQuery(obj).closest("tr").find("select[name='" + selname + "']").closest("td").html(shtml);
		//美化下拉框组件
		beautySelect();
	}
}

//设置隐藏域的值
function setHiddenField(obj,data){
	var hiddenname = "fieldidvalue";
	var objid = jQuery(obj).closest("table").attr("id");
	if(objid == "fieldWhereTableTr"){
		hiddenname = "fieldidwhere";
	}
	var inputHtml = "<input type=\"hidden\" name=\"" + hiddenname + "\" value=\"" + data.fieldid + "\" />";
	jQuery(obj).closest("td").find("input[name='" + hiddenname + "']").remove();
	jQuery(obj).closest("td").append(inputHtml);
}

//转换规则修改时的处理,固定值时,需要显示一个input用于输入,显示自定义SQL时,需要显示一个textarea用于显示
function onChangeTranstType(obj){
	var inputName = "extravalue";
	var objid = jQuery(obj).closest("table").attr("id");
	if(objid == "fieldWhereTableTr"){
		inputName = "extrawhere";
	}
	
	var selval = jQuery(obj).find("option:selected").val();
	
	var _width = jQuery(obj).next("span").width();  //美化后的下拉框的宽度
	if(_width <= 0){
		var _width = jQuery(obj).width();  //下拉框的宽度
	}
	var inputHtml = "";
	if(selval == "1"){    //固定值
		inputHtml = "<input type=\"text\" name=\"" + inputName + "\" value=\"\" style=\"\"/>";
	}else if(selval == "7"){   //自定义SQL
		inputHtml = "<textarea type=\"text\" name=\"" + inputName + "\" value=\"\" rows=\"3\" ></textarea>";	
	}else{
		inputHtml = "<input type=\"hidden\" name=\"" + inputName + "\" value=\"\" style=\"\"/>";
	}

	var tdObj = jQuery(obj).closest("td");
	tdObj.find("input,textarea").remove();
	tdObj.append(inputHtml);
	tdObj.find("input,textarea").width(_width);
}

function appendFormField(dmltype,fieldname,fielddbtype,showname,obj)
{
	try
	{
		if(fieldname=="")
		{
			showname = "";
			fieldname = "";
			fielddbtype = "";
			//return;
		}
		if(typeof(fieldname)=="undefined")
		{
			return;
		}
		var obj = obj.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement;
		//alert(obj.outerHTML)
		
		var dbnamecell = obj.nextSibling.firstChild;
		dbnamecell.value = fieldname;
		//字段类型
		var dbtypecell = obj.nextSibling.nextSibling.firstChild;
		//alert(obj.nextSibling.nextSibling.outerHTML)
		dbtypecell.value = fielddbtype;
		
		var fieldname1 = jQuery(obj.previousSibling.previousSibling).find("#fieldname").val();
		var fielddbtype1 = jQuery(obj.previousSibling).find("#showtype").val();;
		//alert(fieldname1+"="+fielddbtype1+"="+fieldname);
		if(""!=fieldname1&&""!=fielddbtype1&&""!=fieldname){
			jQuery(obj).find("#"+dmltype+"fieldname").val(fieldname1+"="+fielddbtype1+"="+fieldname);
		}else{
			jQuery(obj).find("#"+dmltype+"fieldname").val("");
		}
		//alert(jQuery(obj).find("#"+dmltype+"fieldname").val());
	}
	catch(e)
	{
		top.Dialog.alert(e);
	}
}
function submitData()
{
if(! checkActionName("dml",$("#actionname").val(),$("#actionid").val())){
           	top.Dialog.alert("名称已存在,请重新填写!");
return;
}
	if(!$("#dmltype").val()){		
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15859, user.getLanguage())%>!");
		displayAllmenu();
		return;
	}
	enableAllmenu();
	//如果dml类型为存储过程，则外部主表为非必填
	if("custom" == $("#dmltype").val()) {
		checkfield3 = checkfield3.replace("dmltablename","");
	}
    if(check_form(frmmain,checkfield3))
    {
    	var dmlmainsqltype = document.frmmain.dmlmainsqltype.value;
    	var dmlmainsql = document.frmmain.dmlmainsql.value;
    	var dmlmainsql1 = document.frmmain.dmlmainsql.value;
    	dmlmainsql = dmlmainsql.toLowerCase();
    	//qc273761[80][90]流程流转集成-解决DML接口自定义SQL以回车或空格开始时，提示自定义主表DML语句不正确的问题 start
    	dmlmainsql = dmlmainsql.replace("\\r\\n", "");
    	dmlmainsql = dmlmainsql.trim();
    	//qc273761[80][90]流程流转集成-解决DML接口自定义SQL以回车或空格开始时，提示自定义主表DML语句不正确的问题 end
    	if(""!=dmlmainsql)
    	{
    		if((dmlmainsqltype==0 &&dmlmainsql.indexOf("update")!=0&&dmlmainsql.indexOf("insert")!=0&&dmlmainsql.indexOf("delete")!=0))
    		{
    			//不正确，请重新输入
    			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130492, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27685, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(27686, user.getLanguage())%>!");
    			//document.frmmain.dmlmainsql.focus();
   				displayAllmenu();
   				return;
    		}
    		if(dmlmainsqltype==0&& dmlmainsql.indexOf("$detail_table?")!=-1){//操作明细数据
    			var flag=false;
    			if(dmlmainsql.indexOf("insert")!=-1 && (dmlmainsql.indexOf("$detail_main_pkfd$")==-1 || dmlmainsql.indexOf("$detail_main_pkfd_v$")==-1)){
    				flag=true;
    			}
    			if((dmlmainsql.indexOf("delete")!=-1 || dmlmainsql.indexOf("update")!=-1) && (dmlmainsql.indexOf("$detail_pk$")==-1 || dmlmainsql.indexOf("$detail_index?")==-1)){
    				flag=true;
    			}
    			if(flag){
    				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130492, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27685, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(32451, user.getLanguage())%>!");
	   				//document.frmmain.dmlmainsql.focus();
	   				displayAllmenu();
	   				return;
    			}
    		}
    	}
    	//QC:270474开始  概述:[80][90]数据流转集成-解决DML接口在UPDATE 和DELETE 模式下，自定义SQL格式化问题
    	var lastSql = madeFormateSql(dmlmainsql1,"");
    	//var lastSql="";
    	//var re =new RegExp("end\\)where");
    	//var result= re.test(dmlmainsql.toLowerCase());
    	//if(result){
    	//lastSql = dmlmainsql.substring(0, dmlmainsql.toLowerCase().indexOf("where"))+" "+dmlmainsql.substring(dmlmainsql.toLowerCase().indexOf("where"), dmlmainsql.length);
    	//document.frmmain.dmlmainsql.value = lastSql;
    	//}
    	document.frmmain.dmlmainsql.value = lastSql;
    	//QC:270474结束
        document.frmmain.submit();
    }
    displayAllmenu();
}
function deleteData()
{
   	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>?", function (){
		document.frmmain.operate.value="delete";
       	document.frmmain.submit();
	}, function () {}, 320, 90);
}
function chkAllClick(obj,type)
{
    var chks = document.getElementsByName(type);
    
    for (var i = 0; i < chks.length; i++)
    {
        var chk = chks[i];
        
        if(false == chk.disabled)
        {
        	chk.checked = obj.checked;
        	try
        	{
        		if(chk.checked)
        			jQuery(chk.nextSibling).addClass("jNiceChecked");
        		else
        			jQuery(chk.nextSibling).removeClass("jNiceChecked");
        	}
        	catch(e)
        	{
        	}
        }
    }
}
function showFlowDiv(event,datas,name,paras){
	if($("#formidspan").html()!=""){
		$("#isbill").val(datas.isBill);
		onShowFormSerach();
	}else{
		
	}
	
	
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
	try
	{
		parent.document.getElementById("main").style.height= "100%";
	}
	catch(e)
	{
	}
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
				//$(".setbutton").hide();
				try
				{
					$("#button"+activeindex).show();
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
/**
 *	是否存在设置的字段数据
 **/
function hasFieldAdd()
{
	var hasfield = false;
	var checknames = document.getElementsByName("dmlcheck");
	var len = checknames.length;
	if(len>0)
	{
		hasfield = true;
	}
	checknames = document.getElementsByName("wherecheck");
	len = checknames.length;
	if(len>0)
	{
		hasfield = true;
	}
	return hasfield;
}
var olddatasourceid = "<%=datasourceid %>";//274958  [80][90]流程流转集成-解决修改数据源，仍然选择原来的数据源依旧会提示并清空配置数据的问题
function ChangeDatasource(obj)
{
	
	var thisdatasourceid = document.getElementById('thisdatasourceid');
	var ischange = false;
	var hasField = hasFieldAdd();
	if(hasField || !!$("#dmltablename").val())//274958  [80][90]流程流转集成-解决修改数据源，仍然选择原来的数据源依旧会提示并清空配置数据的问题
	{
		var val = $(obj).val();//274958  [80][90]流程流转集成-解决修改数据源，仍然选择原来的数据源依旧会提示并清空配置数据的问题
		if(!(val == olddatasourceid)) {
            //切换数据源将丢失您的设置,确定切换数据源吗
            top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(26431,user.getLanguage())%>?", function () {
                if(hasField){
                    ischange = true;
                    deleteAllRow('fieldValueTableTr', 'dmlcheck');
                    deleteAllRow('fieldWhereTableTr', 'wherecheck');
                }
                if(olddatasourceid == "" && $(obj).val() != "") thisdatasourceid.style.display = "none";//QC 274956  [80][90]流程流转集成-解决DML修改外部数据源的数据内容初始化问题
                olddatasourceid = $(obj).val();
                document.getElementById('tempdmltablenamespan').innerHTML = "";//QC 274956  [80][90]流程流转集成-解决DML修改外部数据源的数据内容初始化问题
                document.getElementById('tempdmltablenamespanimg').innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";//QC 274956  [80][90]流程流转集成-解决DML修改外部数据源的数据内容初始化问题
                $("#dmltablename").val("");//QC 274956  [80][90]流程流转集成-解决DML修改外部数据源的数据内容初始化问题
                document.getElementById('dmltablenamespans').innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";//出现感叹号
            }, function () {
                var options = obj.options;
                //QC 274954  [80][90]流程流转集成-解决DML修改外部数据源会有提示信息，但是点击取消后，数据源依旧会改变的问题
                var showTextId = "#sbSelector_" + $(obj).attr("sb");//构建实际显示的下拉列表展示的ID的值，这边的下拉列表，做了处理
                for (var i = 0; i < options.length; i++) {
                    var op = options[i];
                    if (op.value == olddatasourceid) {
                        op.selected = true;
                    }
                }
                if(olddatasourceid !="" && val == "") thisdatasourceid.style.display = "none";//QC 274954  [80][90]流程流转集成-解决DML修改外部数据源会有提示信息，但是点击取消后，数据源依旧会改变的问题
				if(olddatasourceid =="") thisdatasourceid.style.display = "";//274958  [80][90]流程流转集成-解决修改数据源，仍然选择原来的数据源依旧会提示并清空配置数据的问题
			    $(showTextId).attr("title", olddatasourceid);//QC 274954  [80][90]流程流转集成-解决DML修改外部数据源会有提示信息，但是点击取消后，数据源依旧会改变的问题
                $(showTextId).text(olddatasourceid);//QC 274954  [80][90]流程流转集成-解决DML修改外部数据源会有提示信息，但是点击取消后，数据源依旧会改变的问题


            }, 320, 90);
        }
	}
	else
	{
		olddatasourceid =  $(obj).val();//274958  [80][90]流程流转集成-解决修改数据源，仍然选择原来的数据源依旧会提示并清空配置数据的问题
		ischange = true;
	}
	//alert('<%=needcheckds%>'+" obj.value : "+obj.value);
	if(obj.value=="")
	{
		<%if(needcheckds){%>
		thisdatasourceid.style.display = "none";
		<%}else{%>
		thisdatasourceid.style.display = "";
		<%}%>
	}
	else
	{
			thisdatasourceid.style.display = "none";
	}
	if(ischange)
	{
		document.getElementById('tempdmltablenamespan').innerHTML = "";
		document.getElementById('tempdmltablenamespanimg').innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
		document.getElementById('dmlformid').value = "";
		document.getElementById('dmlformname').value = "";
		document.getElementById('dmlisdetail').value = "";
		document.getElementById('dmltablename').value = "";
		document.getElementById('dmltablenamespans').innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
	}
	
	changeProcedure();
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
function onShowTable(event,data,name){
	//var id_t = showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/triggerTableBrowser.jsp");
	if(data){
		if(data.id != ""){
			document.getElementById("dmltablename").value = data.other1;
			document.getElementById("dmlformname").value = data.name;
			//alert(data.id);
			document.getElementById("dmlformid").value = data.other2;
			document.getElementById("dmlisdetail").value = data.other3;
			//alert(data.other3);
		}else{
			document.getElementById("dmltablename").value = data.other1;
			document.getElementById("dmlformname").value = "";
			document.getElementById("dmlformid").value = "";
			document.getElementById("dmlisdetail").value = "";
		}
	}
	changeTableField();
}

function onShowTableField(){
	var datasourceid = document.getElementById("datasourceid").value;
	var needcheckds = "<%=needcheckds%>";
	var dmlformid = document.getElementById("dmlformid").value;
	var dmltablename = document.getElementById("dmltablename").value;
	var dmlisdetail = document.getElementById("dmlisdetail").value;
	var urls = "/systeminfo/BrowserMain.jsp?mouldID=workflow&datasourceid="+datasourceid+"&needcheckds="+needcheckds+"&dmlformid="+dmlformid+"&dmlisdetail="+dmlisdetail+"&dmltablename="+dmltablename+"&url=/workflow/dmlaction/dmlTableFieldsBrowser.jsp";
	//alert(urls);
	return urls;
}

function onShowTableFieldValue(obj){
	var fieldname;
	var fielddbtype;
	var iscanhandle;
	var datasourceid = document.getElementById("datasourceid").value;
	var needcheckds = "<%=needcheckds%>";
	var dmlformid = document.getElementById("dmlformid").value;
	var dmltablename = document.getElementById("dmltablename").value;
	var dmlisdetail = document.getElementById("dmlisdetail").value;
	var urls = "/systeminfo/BrowserMain.jsp?mouldID=workflow&datasourceid="+datasourceid+"&needcheckds="+needcheckds+"&dmlformid="+dmlformid+"&dmlisdetail="+dmlisdetail+"&dmltablename="+dmltablename+"&ajax=1&url=/workflow/dmlaction/dmlTableFieldsBrowser.jsp";
	//alert(urls);
	return urls;
}
function onSetTableField(event,data,name,dmltype,tg)
{
	var fieldname;
	var fielddbtype;
	var iscanhandle;
	//Dialog.alert("dmltype : "+dmltype);
	var obj = null;
	//alert(typeof(tg)+"  event : "+event);
	if(typeof(tg)=='undefined'){
		obj= event.target || event.srcElement;
	}
	else
	{
		obj = tg;
	}
	if(data){
		if(data.id != ""){
			fieldname = data.id;
			fielddbtype = data.type;
			
			// 显示转化自定义浏览框的数据库字段类型
			if(fielddbtype.indexOf("browser") != -1) {
				<%
				if(isoracle) {
				%>
					fielddbtype = "varchar2(1000)";
				<%
				} else {
				%>
					fielddbtype = "varchar(1000)";
				<%
				}
				%>
			}
			
			iscanhandle = data.a1;
		}else{
			fieldname = "";
			fielddbtype = "";
			iscanhandle = "";
		}
	}
	appendField(dmltype,fieldname,fielddbtype,iscanhandle,obj);
}
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle();
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();
	$("#advancedSearch").bind("click", function(){
	});
	
	
	//存储过程  非必填控制
	changeProcedure();
});

//切换数据来源，需要相应的切换为主表或者明细表
function onChangeSource(){
	document.frmmain.operate.value="changetable";
	document.frmmain.action="/workflow/dmlaction/FormActionSettingEdit.jsp"
	document.frmmain.submit()
}


function onShowFormSerach() {
	document.frmmain.action="/workflow/dmlaction/FormActionSettingEdit.jsp"
   	document.frmmain.submit()
}
function onBackUrl(url)
{
	document.location.href=url;
}

//dml类型为存储过程的时候，外部主表非必填
function changeProcedure() {
	
	var dmltype = $("#dmltype").val();
	if("custom" == dmltype) {
		$("#tempdmltablenamespanimg").html("");
		$("#dmltablenamespans").html("");
		$("#li_a_3").click();
		
	} else {
		$("#li_a_0").click();
		var dmltablename = document.getElementById('dmltablename').value;
		if(dmltablename!=""){
			document.getElementById('tempdmltablenamespanimg').innerHTML = "";
			document.getElementById('dmltablenamespans').innerHTML = "";
			
		}else{
			document.getElementById('tempdmltablenamespanimg').innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			document.getElementById('dmltablenamespans').innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
		}
	}
}

function changeImage() {
	var dmltype = $("#dmltype").val();
	if("custom" == dmltype) {
		$("#tempdmltablenamespanimg").html("");
		$("#dmltablenamespans").html("");
		
		
	} else {
		var dmltablename = document.getElementById('dmltablename').value;
		if(dmltablename!=""){
			document.getElementById('tempdmltablenamespanimg').innerHTML = "";
			document.getElementById('dmltablenamespans').innerHTML = "";
			
		}else{
			document.getElementById('tempdmltablenamespanimg').innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
			document.getElementById('dmltablenamespans').innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
						$("#tempdmltablenamespan span").remove();
		}
	}
}
function onClose()
{
	parentWin.closeDialog();
}

//QC:270474 START  概述:[80][90]数据流转集成-解决DML接口在UPDATE 和DELETE 模式下，自定义SQL格式化问题
function madeFormateSql(dmlmainsql,test){
	//针对sql的update和delete语句
	var dmlsql = test+dmlmainsql
	var abc ="";
	if((dmlsql.toLowerCase().indexOf("update")==0||dmlsql.toLowerCase().indexOf("delete")==0)&& dmlsql.toLowerCase().indexOf('where') != -1) {//QC275316  [80][90]流程流转集成-解决自定义SQL保存错误的问题
		var x = dmlmainsql.toLowerCase().indexOf('where');
		var preStr = dmlmainsql.substring(0,x);
		var preLast = preStr.charAt(x-1);
		var preWh=dmlmainsql.substring(x,x+5);
		if(preLast != "?" && dmlmainsql.charAt(x+5) != "'"){
			if(preLast !=" " && dmlmainsql.charAt(x+5) != " "){
				abc = test + preStr + " "+preWh+" " + dmlmainsql.substring(x+5);	
			}
			if(preLast !=" " && dmlmainsql.charAt(x+5) == " "){
				abc = test + preStr + " "+preWh + dmlmainsql.substring(x+5);		
			}
			if(preLast ==" " && dmlmainsql.charAt(x+5) != " "){
				abc = test + preStr + preWh+" " + dmlmainsql.substring(x+5);	
			}
			if(preLast ==" " && dmlmainsql.charAt(x+5) == " "){
				abc = dmlsql;	
			}
		}else{
			abc = madeFormateSql(dmlmainsql.substring(x+5),dmlmainsql.substring(0,x+5));
		}
	}else{
		abc = dmlmainsql;
	}
	return abc;
}

//QC:270474 END  概述:[80][90]数据流转集成-解决DML接口在UPDATE 和DELETE 模式下，自定义SQL格式化问题

//是否包含特殊字段
function isSpecialChar(str){
	var reg = /[-\+=\`~!@#$%^&\*\(\)\[\]{};:'",.<>\/\?\\|]/;
	return reg.test(str);
}

//QC 282798  [80][90]数据展现集成-新建页面【标识】建议限制前后输入空格 Start
function trimActionName(value){
    value =  $.trim(value);
    document.getElementById("actionname").value = value;
    
     if(isSpecialChar(value)){
		//标识包含特殊字符，请重新输入！
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131334,user.getLanguage())%>");
		document.getElementById("actionname").value = "";
		document.getElementById("actionnamespan").innerHTML = "<img src='/images/BacoError_wev8.gif' align=absmiddle>";
		
		return false;
	}
}
//QC 282798  [80][90]数据展现集成-新建页面【标识】建议限制前后输入空格 End
</script>
