
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.*"%>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.workflow.dmlaction.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="WFManager" class="weaver.workflow.workflow.WFManager" scope="session" />
<jsp:useBean id="DMLActionBase" class="weaver.formmode.interfaces.dmlaction.commands.bases.DMLActionBase" scope="page" />
<jsp:useBean id="FormActionBase" class="weaver.workflow.dmlaction.commands.bases.FormActionBase" scope="page" />
<jsp:useBean id="FieldBase" class="weaver.formmode.interfaces.dmlaction.commands.bases.FieldBase" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user))
{
	response.sendRedirect("/notice/noright.jsp");
	
	return;
}
%>
<%
	String operate = Util.null2String(request.getParameter("operate"));
	int actionid = Util.getIntValue(Util.null2String(request.getParameter("actionid")),0);
	int modeid = Util.getIntValue(Util.null2String(request.getParameter("modeid")),0);
	int expandid = Util.getIntValue(Util.null2String(request.getParameter("expandid")),0);
	DMLActionBase.setActionid(actionid);
	DMLActionBase.initDMLAction();
	boolean isexists = DMLActionBase.isIsexists();
	if(!isexists)
	{
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	//dmlactionname,dmlorder,workflowId,nodeid,ispreoperator,nodelinkid,datasourceid,dmltype
	
	String modename = "";
	String isbill = "1";
	String formid = "";
	String sql = "select modename,formid from modeinfo where id = " + modeid;
	rs.executeSql(sql);
	while(rs.next()){
		formid = Util.null2String(rs.getString("formid"));
		modename = Util.null2String(rs.getString("modename"));
	}
	
	String actionname = "";
	int dmlorder = 0;
	int workflowId = 0;
	//数据源
	String datasourceid = "";
	//是否需要选择数据源
	boolean needcheckds = false;
	
	//操作类型
	String dmltype = "";
	//节点id
	int nodeid = 0;
	//是否节点后附加操作
	String ispreoperator = "";
	//节点出口id
	int nodelinkid = 0;
	int isResetRight = 0;
	int targetmodeid = 0;
	if(!"changetable".equals(operate))
	{
		actionname = DMLActionBase.getActionname();
		dmlorder = DMLActionBase.getDmlorder();
		workflowId = DMLActionBase.getWorkflowId();
		//数据源
		datasourceid = DMLActionBase.getDatasourceid();
		//操作类型
		dmltype = DMLActionBase.getDmltype();
		isResetRight = DMLActionBase.getIsResetRight();
		targetmodeid = DMLActionBase.getTargetmodeid();
		//节点id
		nodeid = DMLActionBase.getNodeid();
		//是否节点后附加操作
		ispreoperator = DMLActionBase.getIspreoperator();
		//节点出口id
		nodelinkid = DMLActionBase.getNodelinkid();
	}
	else
	{
		actionname = Util.null2String(request.getParameter("actionname"));
		dmlorder = Util.getIntValue(Util.null2String(request.getParameter("dmlorder")),0);
		
		workflowId = Util.getIntValue(Util.null2String(request.getParameter("workflowId")),0);
		//数据源
		datasourceid = Util.null2String(request.getParameter("datasourceid"));
		//操作类型
		dmltype = Util.null2String(request.getParameter("dmltype"));
		isResetRight = Util.getIntValue(Util.null2String(request.getParameter("isResetRight")),0);
		targetmodeid = Util.getIntValue(Util.null2String(request.getParameter("targetmodeid")),0);
		//节点id
		nodeid = Util.getIntValue(Util.null2String(request.getParameter("nodeid")),0);
		//是否节点后附加操作
		ispreoperator = Util.null2String(request.getParameter("ispreoperator"));
		//节点出口id
		nodelinkid = Util.getIntValue(Util.null2String(request.getParameter("nodelinkid")),0);
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
	String maintablename = DMLActionBase.getActiontable();
	Map dmlMap = DMLActionBase.getDmlMap();
	Map fieldMap = DMLActionBase.getFieldMap();
	Map whereMap = DMLActionBase.getWhereMap();
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
	
	int index = 0;
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script language="javascript" src="/js/weaver_wev8.js"></script>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="/integration/css/integrationtab_wev8.css" type="text/css">
		<STYLE TYPE="text/css">
		.btn_actionList
		{
			width:200px!important;BORDER-RIGHT: #7b9ebd 1px solid; PADDING-RIGHT: 2px; BORDER-TOP: #7b9ebd 1px solid; PADDING-LEFT: 2px; FONT-SIZE: 12px; FILTER: progid:DXImageTransform.Microsoft.Gradient(GradientType=0, StartColorStr=#ffffff, EndColorStr=#cecfde); BORDER-LEFT: #7b9ebd 1px solid; CURSOR: hand; COLOR: black; PADDING-TOP: 2px; BORDER-BOTTOM: #7b9ebd 1px solid 
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
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage()) + ",javascript:submitData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{" + SystemEnv.getHtmlLabelName(91, user.getLanguage()) + ",javascript:deleteData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",/workflow/dmlaction/DMLActionSettingView.jsp?actionid="+actionid+",_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<form name="frmmain" method="post" action="DMLActionSettingOperation.jsp">
			<input type="hidden" id="operate" name="operate" value="edit">
			<input type="hidden" id="actionid" name="actionid" value="<%=actionid %>">
			<input type="hidden" id="expandid" name="expandid" value="<%=expandid %>">
			
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
					<wea:item>
						<%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%>
					</wea:item>
					<wea:item>
						<input type=text  class=inputstyle  id="actionname" name="actionname" style="width:280px!important;" value="<%=actionname%>" onChange="checkinput('actionname','actionnamespan')">
						<span id="actionnamespan"> <%if (actionname.equals("")){%> <img src="/images/BacoError_wev8.gif" align=absmiddle> <%}%> </span>
					</wea:item>
					<wea:item>
						<%=SystemEnv.getHtmlLabelName(28485, user.getLanguage())%>
					</wea:item>
					<wea:item>
						<span id="workflowspan"> <%=modename%> </span> 
						<input type="hidden" id="modeid" name="modeid" value="<%=modeid%>">
					</wea:item>
					<wea:item>
						<%=SystemEnv.getHtmlLabelName(26419, user.getLanguage())%>
					</wea:item>
					<wea:item>
						<input type=text size=35 class=inputstyle id="dmlorder" name="dmlorder" maxlength=10 value="<%=dmlorder%>" onChange="checkinput('dmlorder','dmlorderspan')" onKeyPress="ItemCount_KeyPress()" onBlur="checknumber1(this);"> 
						<span id="dmlorderspan"> <%	if (("" + dmlorder).equals("")) { %> <img src="/images/BacoError_wev8.gif" align=absmiddle> <% } %> </span>
					</wea:item>
					<wea:item>
						<%=SystemEnv.getHtmlLabelName(18076, user.getLanguage())%>
					</wea:item>
					<wea:item>
						<select id="datasourceid" name="datasourceid" onchange="changeIsShowRight();ChangeDatasource(this);<%if(needcheckds){ %>checkinput('datasourceid','datasourceidspan');<%} %>">
													<option></option>
														<%
															List datasourceList = DataSourceXML.getPointArrayList();
															for (int i = 0; i < datasourceList.size(); i++)
															{
																String pointid = Util.null2String((String) datasourceList.get(i));
														%>
													<option value="<%=pointid%>" <%if(pointid.equals(datasourceid)){ %> selected <%} %>><%=pointid%></option>
														<%
															}
														%>
												</select> 
												<%if(needcheckds){ %> 			
												<span id="datasourceidspan"> <%if (datasourceid.equals("")){%> 	<img src="/images/BacoError_wev8.gif" align=absmiddle> <%} %> 	</span> 
												<%} %>
												<span style="color: #aaa;margin-left: 20px;line-height: 30px;"><%=SystemEnv.getHtmlLabelName(125371, user.getLanguage())%></span>
					</wea:item>
					<wea:item>DML<%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></wea:item>
					<wea:item>
						<select id="dmltype" name="dmltype" style='width:80px!important;' onChange="checkinput('dmltype','dmltypespan');changeIsShowRight();">
							<option></option>
							<option value="insert" <%if("insert".equals(dmltype)){ %>selected<%} %>>insert<%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%></option>
							<option value="update" <%if("update".equals(dmltype)){ %>selected<%} %>>update<%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%></option>
							<option value="delete" <%if("delete".equals(dmltype)){ %>selected<%} %>>delete<%=SystemEnv.getHtmlLabelName(104, user.getLanguage())%></option>
						</select>
						<span id="dmltypespan"> <%if (dmltype.equals("")){%> <img src="/images/BacoError_wev8.gif" align=absmiddle> <%} %> </span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(125368, user.getLanguage())%></wea:item>
					<wea:item>
						<input type="checkbox" id="isResetRight" name="isResetRight" value="<%=isResetRight %>" tzCheckbox="true" onclick="changeValue(this)" <%if(isResetRight==1){%>checked="checked"<%} %> >
					</wea:item>
					<wea:item><span style="line-height: 25px;"><%=SystemEnv.getHtmlLabelName(125369, user.getLanguage())%></span></wea:item>
					<wea:item>
						<div>
						<%
						String targetmodeName = "";
						if(targetmodeid>0){
							sql = "select modename from modeinfo where id = " + targetmodeid;
							rs.executeSql(sql);
							if(rs.next()){
								targetmodeName = rs.getString("modename");
							}
						}
						%>
						<brow:browser viewType="0" id="targetmodeid" name="targetmodeid" browserValue='<%=targetmodeid+""%>' 
  		 				browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp"
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="1"
						completeUrl="/data.jsp" linkUrl=""  width="228px"
						browserDialogWidth="510px"
						browserSpanValue='<%=targetmodeName %>'
						></brow:browser>
						</div>
						<div style="color: #aaa;margin-left: 20px;line-height: 25px;">&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(125370, user.getLanguage())%></div>
					</wea:item>
				</wea:group>
			</wea:layout>
											
												<%
													//流程id，节点id或者出口id，是否需要检查数据源以及是数据源是否为空
													if (modeid>0&&expandid>0)
													{
														String tablesql = "";
														
														List actionSetList = (List)dmlMap.get(maintablename);
														List fieldsList = null;
														List wheresList = null;
														if(null!=actionSetList||"changetable".equals(operate))
														{
															if(!"changetable".equals(operate))
															{	
																if(actionSetList.size()>0)
																	actionsqlsetid = Util.getIntValue((String)actionSetList.get(0),0);
																//action数据源表名
																if(actionSetList.size()>1)
																	actiontable = Util.null2String((String)actionSetList.get(1));
																//表单id
																if(actionSetList.size()>2)
																	dmlformid = Util.getIntValue((String)actionSetList.get(2),0);
																//表单名称
																if(actionSetList.size()>3)
																	dmlformname = Util.null2String((String)actionSetList.get(3));
																//是否为明细
																if(actionSetList.size()>4)
																	dmlisdetail = Util.null2String((String)actionSetList.get(4));
																//对应表名称
																if(actionSetList.size()>5)
																	dmltablename = Util.null2String((String)actionSetList.get(5));
																//表别名
																if(actionSetList.size()>6)
																	dmltablebyname = Util.null2String((String)actionSetList.get(6));
																//自定义条件
																if(actionSetList.size()>7)
																	dmlcuswhere = Util.null2String((String)actionSetList.get(7));
																//指定sql类型
																if(actionSetList.size()>8)
																	dmlmainsqltype = Util.null2String((String)actionSetList.get(8));
																//指定sql
																if(actionSetList.size()>9)
																	dmlcussql = Util.null2String((String)actionSetList.get(9));
																
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
																					%>
																					<button type='button' type="button" class="Browser" onClick="onShowTable(dmltablename,dmlformname,dmltablenamespan,dmlformid,dmlisdetail)"></BUTTON>
																					<span id="dmltablenamespan"><%=dmlformname %></span>
																					<input type=hidden id="actionsqlsetid" name="actionsqlsetid" value="<%=actionsqlsetid %>">
																					<input type=hidden id="dmlformid" name="dmlformid" value="<%=dmlformid %>">
																					<input type=hidden id="dmlformname" name="dmlformname" value="<%=dmlformname %>">
																					<input type=hidden id="dmlisdetail" name="dmlisdetail" value="<%=dmlisdetail %>">
																				</td>
																				<td class=field>
																					<input type=text class=Inputstyle size=20 maxlength=50 id="dmltablename" name="dmltablename" value="<%=dmltablename %>" onBlur="checkinput_char_num("dmltablename");" onchange="javascript:changeTableField();checkinput('dmltablename','dmltablenamespans');"><span id="dmltablenamespans"><%if (dmltablename.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%} %></span>
																				</td>
																			</tr>
																		</tbody>
																	</table>
																</wea:item>
																<wea:item><%=SystemEnv.getHtmlLabelName(81344, user.getLanguage())%></wea:item><!-- 流程主表 -->
																<wea:item>
																	<input type=hidden id="maintablename" name="maintablename" value="<%=maintablename %>">
																	<span><%=maintablename %></span>
																</wea:item>
																
																<wea:item attributes="{'colspan':'2'}">
																	<div class="listparams e8_box demo2" id="tabbox" style='height:42px;'>
									    							<ul class="tab_menu" id="tabs" style="width:85%!important;">
																    	<li style='padding-left:0px!important;'><a href="#">DML<%=SystemEnv.getHtmlLabelName(21845, user.getLanguage())%></a></li> <!-- 赋值设置 -->
																        <li><a href="#">DML<%=SystemEnv.getHtmlLabelName(27957, user.getLanguage())%></a></li> <!-- 条件设置 -->
																        <li><a href="#"><%=SystemEnv.getHtmlLabelName(26425, user.getLanguage())%></a></li><!-- 自定义主表条件 -->
																        <li><a href="#"><%=SystemEnv.getHtmlLabelName(26426, user.getLanguage())%></a></li><!-- 自定义主表DML语句 -->
																        <li><a href="#">DML<%=SystemEnv.getHtmlLabelName(19010, user.getLanguage())%></a></li><!-- 操作说明 -->
																    </ul>
																    <div id="" class="" style="width:15%;height:41px;float:right;">
													         			<TABLE width=100% class="setbutton" id='button1' style="display:none;">
													           				<TR>
													           					<!--th align=left><%=SystemEnv.getHtmlLabelName(32238, user.getLanguage())%></th--><!-- 分部同步对应关系设置 -->
													           					<TD align=right colspan="2" style="background: #fff;">
													           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onClick="addRow('fieldValueTableTr','dml');" class="addbtn"/><!-- 增加 -->
																					<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="delRow('fieldValueTableTr','dmlcheck',true);" class="delbtn"/><!-- 删除 -->
													           					</TD>
													           				</TR>
													         			</TABLE>
													         			<TABLE width=100% class="setbutton" id='button2' style="display:none;">
													           				<TR>
													           					<!--th align=left><%=SystemEnv.getHtmlLabelName(32237, user.getLanguage())%></th--><!-- 部门同步对应关系设置 -->
													           					<TD align=right colspan="2" style="background: #fff;">
													           						<input type="button" title="<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" onClick="addRow('fieldWhereTableTr','where');" class="addbtn"/><!-- 增加 -->
																					<input type="button" title="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage())%>" onClick="delRow('fieldWhereTableTr','wherecheck',true);" class="delbtn"/><!-- 删除 -->
													           					</TD>
													           				</TR>
													         			</TABLE>
																    </div>
																    <div class="tab_box" style="display:none;width:0px;"></div>
																</div>								
															</wea:item>
															
												<%
													allcolnums = FieldBase.getAllcolnums();
													//字段列表
													fieldList = FieldBase.getFieldList();
													if(null!=fieldList&&fieldList.size()>0)
													{
														//字段类型列表
														fieldDBTypeMap = FieldBase.getFieldDBTypeMap();
														//字段标签列表
														fieldLabelMap = FieldBase.getFieldLabelMap();
														//字段名列表
														fieldNameMap = FieldBase.getFieldNameMap();
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
																				<tr class="listparams listparams1 listparam" id='fieldValueTable'>
																					<td colspan=4 vAlign="top" style='padding-left:0px!important;'>
																						<table width="100%" class='ListStyle' id="fieldValueTableTr" style="padding:0px;margin:0px;" cellpadding="0" cellspacing="0">
																							<colgroup>
																								<col width="10%">
																								<col width="20%">
																								<col width="10%">
																								<col width="20%">
																								<col width="10%">
																								<col width="20%">
																							<tbody>
																								<tr class=header>
																									<th><INPUT type="checkbox" id="chkAll" name="chkAll" onClick="chkAllClick(this,'dmlcheck')"></th>
																									<th><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></th><!-- 字段名称 -->
																									<th><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></th><!-- 字段类型 -->
																									<th><%=SystemEnv.getHtmlLabelName(26422, user.getLanguage())%></th><!-- 同步对应字段 -->
																									<th><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></th><!-- 字段名称 -->
																									<th><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></th><!-- 字段类型 -->
																								</tr>
																								<%
																								boolean isright = true;
																								Set columnSet = allcolnums.keySet();
																								int m = 0;
																								for(Iterator i = columnSet.iterator();i.hasNext();)
																								{	
																									String fieldname = Util.null2String((String)i.next());
																									String fielddbtype = Util.null2String((String)allcolnums.get(fieldname));
																									boolean iscanhandle = DBTypeUtil.checkFieldDBType(fielddbtype,dbtype);
																									if(!FormActionBase.isKeyField(fieldsList,fieldname))
																									{
																										continue;
																									}
																									String jfieldid = "";
																									String jfieldname = "";
																									String jfielddbtype = "";
																									String jfieldlabel = "";
																									for(int j = 0;j<fieldList.size();j++)
																									{
																										String tempjfieldid = (String)fieldList.get(j);
																										String tempjfieldname = Util.null2String((String)fieldNameMap.get(tempjfieldid));
																										String tempjfielddbtype = Util.null2String((String)fieldDBTypeMap.get(tempjfieldid));
																										String tempjfieldlabel = Util.null2String((String)fieldLabelMap.get(tempjfieldid));
																										if(null!=fieldsList&&fieldsList.contains(fieldname+"="+fielddbtype+"="+tempjfieldname))
																										{
																											jfieldid = tempjfieldid;
																											jfieldname = tempjfieldname;
																											jfielddbtype = tempjfielddbtype;
																											jfieldlabel = tempjfieldlabel;
																										}
																									}
																									m++;
																								%>
																									<tr style="height:20px;" class="<%=isright?"DataRight":"DataDark" %>">
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
																				<tr class='listparams listparams2 listparam' id='fieldWhereTable'>
																					<td colspan=4 vAlign="top" style='padding-left:0px!important;'>
																						<table width="100%" class='ListStyle' id="fieldWhereTableTr" style="padding:0px;margin:0px;" cellpadding="0" cellspacing="0">
																							<colgroup>
																								<col width="10%">
																								<col width="20%">
																								<col width="10%">
																								<col width="20%">
																								<col width="10%">
																								<col width="20%">
																								<tr class=header>
																									<th><INPUT type="checkbox" id="chkAll" name="chkAll" onClick="chkAllClick(this,'wherecheck')"></th><!-- 字段显示名 -->
																									<th><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></th><!-- 字段名 -->
																									<th><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></th><!-- 字段类型 -->
																									<th><%=SystemEnv.getHtmlLabelName(26424, user.getLanguage())%></th><!-- 条件对应字段 -->
																									<th><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></th><!-- 字段名称 -->
																									<th><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></th><!-- 字段类型 -->
																								</tr>
																								<%
																								isright = true;
																								int k = 0;
																								for(Iterator i = columnSet.iterator();i.hasNext();)
																								{
																									String fieldname = Util.null2String((String)i.next());
																									String fielddbtype = Util.null2String((String)allcolnums.get(fieldname));
																									boolean iscanhandle = DBTypeUtil.checkFieldDBType(fielddbtype,dbtype);
																									if(!FormActionBase.isKeyField(wheresList,fieldname))
																									{
																										continue;
																									}
																									String jwherefieldid = "";
																									String jwherefieldname = "";
																									String jwherefielddbtype = "";
																									String jwherefieldlabel = "";
																									for(int j = 0;j<fieldList.size();j++)
																									{
																										String tempjfieldid = (String)fieldList.get(j);
																										String tempjfieldname = Util.null2String((String)fieldNameMap.get(tempjfieldid));
																										String tempjfielddbtype = Util.null2String((String)fieldDBTypeMap.get(tempjfieldid));
																										String tempjfieldlabel = Util.null2String((String)fieldLabelMap.get(tempjfieldid));
																										if(null!=wheresList&&wheresList.contains(fieldname+"="+fielddbtype+"="+tempjfieldname))
																										{
																											jwherefieldid = tempjfieldid;
																											jwherefieldname = tempjfieldname;
																											jwherefielddbtype = tempjfielddbtype;
																											jwherefieldlabel = tempjfieldlabel;
																										}
																									}
																									k++;
																								%>
																									<tr style="height:20px;" class="<%=isright?"DataRight":"DataDark" %>">
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
																																   idKey:"id",
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
																				<tr style="HEIGHT: 1px!important;" class='listparams listparams2 listparam'><td style="height:1px!important;" class=line colspan=4></td></tr>
																				<tr class='listparams listparams3 listparam'>
																					<td valign="top" style='padding-left:30px!important;BACKGROUND-COLOR:white;'><%=SystemEnv.getHtmlLabelName(26425, user.getLanguage())%></td><!-- 自定义主表条件 -->
																					<td class=field colspan=3>
																						<textarea id="dmlmainwhere" name="dmlmainwhere" cols=100 rows=4><%=dmlcuswhere %></textarea>
																					</td>
																				</tr>
																				<tr style="HEIGHT: 1px!important;" class='listparams listparams3 listparam'><td style="height:1px!important;padding-left:30px!important;" class=line colspan=4></td></tr>
																				<tr class='listparams listparams4 listparam'>
																					<td valign="top" style='padding-left:30px!important;BACKGROUND-COLOR:white;'><%=SystemEnv.getHtmlLabelName(26426, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></td><!-- 自定义主表DML语句类型 -->
																					<td class=field colspan=3>
																						<select id="dmlmainsqltype" style='width:80px!important;' name="dmlmainsqltype">
																							<option value="0" <%if("0".equals(dmlmainsqltype)||"".equals(dmlmainsqltype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(27670, user.getLanguage())%></option><!-- sql语句 -->
																							<option value="1" <%if("1".equals(dmlmainsqltype)){ %>selected<%} %>><%=SystemEnv.getHtmlLabelName(27671, user.getLanguage())%></option><!-- 存储过程 -->
																						</select>
																						</td>
																				</tr>
																				<tr style="HEIGHT: 1px!important;" class='listparams listparams4 listparam'><td style="height:1px!important;padding-left:30px!important;" class=line colspan=4></td></tr>
																				<tr class='listparams listparams4 listparam'>
																					<td valign="top" style='padding-left:30px!important;BACKGROUND-COLOR:white;'><%=SystemEnv.getHtmlLabelName(26426, user.getLanguage())%></td><!-- 自定义主表DML语句 -->
																					<td class=field colspan=3>
																						<textarea id="dmlmainsql" name="dmlmainsql" cols=100 rows=4><%=dmlcussql %></textarea>
																					</td>
																				</tr>
																				<tr style="HEIGHT: 1px!important;" class='listparams listparams4 listparam'><td style="height:1px!important;padding-left:30px!important;" class=line colspan=4></td></tr>
																			</tbody>
																		</table>
																		<%if (formid.equals("")){%>
																		<span style="color:red;"><%=SystemEnv.getHtmlLabelName(83687, user.getLanguage()) %><%=SystemEnv.getHtmlLabelName(127389, user.getLanguage()) %></span><!-- 未选择相关表单 -->
																		<%
																		}
																		else if(needcheckds&&"".equals(datasourceid))
																		{
																		%>
																		<span style="color:red;"><%=SystemEnv.getHtmlLabelName(27672, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(127389, user.getLanguage()) %></span><!-- 请先选择数据源 -->
																		<%
																		}
																		%>
																		<table width="100%" class='ViewForm listparams listparams5 listparam'>
																			<tr style="HEIGHT: 1px!important;"><td class=line1 style="HEIGHT: 1px!important;"></td></tr>
																			<tr>
																				<td style='padding-left:30px!important;BACKGROUND-COLOR:white;'>
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
																					   &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
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
			</form>
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
	checkfield3 = "actionname,dmlorder,dmltype,workflowId,dmltablename,datasourceid";
<%
}
else
{
%>
	checkfield1 = "";
	checkfield2 = "dmltablename";
	checkfield3 = "actionname,dmlorder,dmltype,workflowId,dmltablename";
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
	oRow1.className = isright?"DataRight":"DataDark";
	
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
		   idKey:"id",
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
    
    var oRow2 = oTable.insertRow(rowIndex+1);
    oRow2.style.height="1px"
    var oCell5 = oRow2.insertCell(0);
    oCell5.className = "line";
    oCell5.style.height="1px"
	oCell5.colSpan = 6;
    oCell5.style.padding=0;
	isright = isright?false:true;
}

jQuery(function($){
	changeIsShowRight();
});

function changeIsShowRight(){
	var datasourceid = jQuery("#datasourceid").val();
	var dmltype = jQuery("#dmltype").val();
	var tr = jQuery('#isResetRight').closest("tr");
	var tr1 = jQuery('#targetmodeid').closest("tr");
	if(datasourceid!=""||dmltype==""){
		tr.hide();
		tr1.hide();
	}else{
		if(dmltype=="delete"){
			tr.hide();
		}else{
			tr.show();
		}
		
		if(dmltype=="insert"){
			tr1.show();
		}else{
			tr1.hide();
		}
	}
}

function changeValue(obj){
   if($(obj).attr("checked")){
         $(obj).val(1);
   }else{
         $(obj).val(0);
   }
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
					var oRow = checknameelm.parentElement.parentElement.parentElement;
					var oRowLine = checknameelm.parentElement.parentElement.parentElement.nextSibling;
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
					var deletetr = deleteList[di];
					var lineindex = deletetr.rowIndex;
					if(typeof(lineindex) == "undefined") {
						continue;
					}
					oTable.deleteRow(lineindex);
				}
			}, function () {}, 320, 90);
		}
		else
		{
			for(var di = 0;di<deleteList.length;di++)
			{
				var deletetr = deleteList[di];
				var lineindex = deletetr.rowIndex;
				if(typeof(lineindex) == "undefined") {
					continue;
				}
				oTable.deleteRow(lineindex);
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
	/*
	var tempdmltablename = document.getElementById('tempdmltablename').value;
	if(newdmltablename!="")
	{
		document.getElementById('tempdmltablenamespanimg').innerHTML = "";
	}
	*/
	
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
	
	/*
	var dmltablename = document.getElementById('dmltablename').value;
	if(tempdmltablename!=dmltablename)
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
	*/
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
	var urls = "/systeminfo/BrowserMain.jsp?mouldID=workflow&formid="+formid+"&isbill="+isbill+"&url=/workflow/dmlaction/dmlFormFieldsBrowser.jsp?formid="+formid+"&isbill="+isbill;
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
			
		}else{
			fieldname = "";
			fielddbtype = "";
			showname = "";
		}
	}
	appendFormField(dmltype,fieldname,fielddbtype,showname,obj);
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

		if(dmltype=="dml"){
			setTimeout(function(){
				if(jQuery(obj).find("span.e8_showNameClass").length==0){
					var span = jQuery(obj).find("#dmlfieldnametempspan");
					span.append("<span class='e8_showNameClass e8_showNameClassPadding'><a onclick='return false;' href=''>"+showname+"</a></span>");
				}else{
					jQuery(obj).find("span.e8_showNameClass").html("<a onclick='return false;' href=''>"+showname+"</a>");
				}
			},200);
		}
		
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
	enableAllmenu();
	
    if(check_form(frmmain,checkfield3))
    {
    	var dmlmainsqltype = document.frmmain.dmlmainsqltype.value;
    	var dmlmainsql = document.frmmain.dmlmainsql.value;
    	dmlmainsql = dmlmainsql.toLowerCase();
    	if(""!=dmlmainsql)
    	{
    		if((dmlmainsqltype==0&&dmlmainsql.indexOf("update")!=0&&dmlmainsql.indexOf("insert")!=0&&dmlmainsql.indexOf("delete")!=0)||(dmlmainsqltype==1&&dmlmainsql.indexOf("call")!=0&&dmlmainsql.indexOf("execute")!=0))
    		{
    			//不正确，请重新输入
    			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26426, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27685, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(27686, user.getLanguage())%>!");
    			document.frmmain.dmlmainsql.focus();
   				displayAllmenu();
   				return;
    		}
    		if(dmlmainsqltype==0 && dmlmainsql.indexOf("$detail_table?")!=-1){//操作明细数据
    			var flag=false;
    			if(dmlmainsql.indexOf("insert")!=-1 && (dmlmainsql.indexOf("$detail_main_pkfd$")==-1 || dmlmainsql.indexOf("$detail_main_pkfd_v$")==-1)){
    				flag=true;
    			}
    			if((dmlmainsql.indexOf("delete")!=-1 || dmlmainsql.indexOf("update")!=-1) && (dmlmainsql.indexOf("$detail_pk$")==-1 || dmlmainsql.indexOf("$detail_index?")==-1)){
    				flag=true;
    			}
    			if(flag){
    				top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(26426, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27685, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(32451, user.getLanguage())%>!");
	   				document.frmmain.dmlmainsql.focus();
	   				displayAllmenu();
	   				return;
    			}
    		}
    	}
        document.frmmain.submit();
    }
    displayAllmenu();
}
function deleteData()
{
   	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(26430,user.getLanguage())%>?", function (){
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
				$(".setbutton").hide();
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
function ChangeDatasource(obj)
{
	var olddatasourceid = "<%=datasourceid %>";
	var thisdatasourceid = document.getElementById('thisdatasourceid');
	var ischange = false;
	var hasField = hasFieldAdd();
	if(hasField)
	{
		//切换数据源将丢失您的设置,确定切换数据源吗
		top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(26431,user.getLanguage())%>?", function (){
			ischange = true;
			deleteAllRow('fieldValueTableTr','dmlcheck');
			deleteAllRow('fieldWhereTableTr','wherecheck');
		}, function () {
			var options = obj.options;
			for(var i = 0;i<options.length;i++)
			{
				var op = options[i];
				if(op.value==olddatasourceid)
				{
					//alert("ddddddddddddd");
					op.selected = true;
				}
			}
		}, 320, 90);
	}
	else
	{
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
			document.getElementById("dmltablename").value = data.id;
			document.getElementById("dmlformname").value = data.name;
			//alert(data.id);
			document.getElementById("dmlformid").value = data.other2;
			document.getElementById("dmlisdetail").value = data.other3;
			alert(data.other3);
		}else{
			document.getElementById("dmltablename").value = data.id;
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
});
function onShowFormSerach() {
	document.frmmain.action="/workflow/dmlaction/FormActionSettingEdit.jsp"
   	document.frmmain.submit()
}
function onBackUrl(url)
{
	document.location.href=url;
}

function onShowTable1(inputname,formname,spanname,hiddenname,isdetail){
	var id_t = showModalDialog("/systeminfo/BrowserMain.jsp?url=/workflow/workflow/triggerTableBrowser.jsp?modeid=<%=modeid%>");
	if(id_t){
		if(id_t.id != ""){
			inputname.value = wuiUtil.getJsonValueByIndex(id_t, 2);
			formname.value = wuiUtil.getJsonValueByIndex(id_t, 1);
			spanname.innerHTML = wuiUtil.getJsonValueByIndex(id_t, 1);
			hiddenname.value = wuiUtil.getJsonValueByIndex(id_t, 3);
			isdetail.value = wuiUtil.getJsonValueByIndex(id_t, 4);
		}else{
			inputname.value = "";
			formname.value = "";
			spanname.innerHTML = "";
			hiddenname.value = "";
			isdetail.value = "";
		}
	}
	changeTableField();
}

var dialog = null;
function onShowTable(inputname,formname,spanname,hiddenname,isdetail){
	//searchflag=1只查实体表单
	var url ="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/triggerTableBrowser.jsp?modeid=<%=modeid%>%26searchflag=1";
   	dialog = new top.Dialog();
   	dialog.currentWindow = window;
   	dialog.okLabel = "<%=SystemEnv.getHtmlLabelName(826,user.getLanguage())%>";//确定
   	dialog.cancelLabel = "<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>";//取消
   	dialog.Drag = true;
   	dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";//请选择
   	dialog.Width = 500;
   	dialog.Height = 600;
   	dialog.callbackfun = function(data){
	   	if (data){
	   		inputname.value = wuiUtil.getJsonValueByIndex(data, 2);
			formname.value = wuiUtil.getJsonValueByIndex(data, 1);
			spanname.innerHTML = wuiUtil.getJsonValueByIndex(data, 1);
			hiddenname.value = wuiUtil.getJsonValueByIndex(data, 3);
			isdetail.value = wuiUtil.getJsonValueByIndex(data, 4);
	   	}else{
	   		inputname.value = "";
			formname.value = "";
			spanname.innerHTML = "";
			hiddenname.value = "";
			isdetail.value = "";
	   	}
	   	changeTableField();
    }
   	dialog.URL = url;
	dialog.show();
}
</script>
<style type="text/css"> 
.magic-line{
	display: none;
}
li.current a{
	line-height:35px;
	 border-bottom:3px solid rgb(127,180,233);
}
</style>
