<!DOCTYPE html>
<%@page import="weaver.workflow.workflow.WfRightManager"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.conn.*"%>
<%@ page import="weaver.workflow.dmlaction.*"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="DataSourceXML" class="weaver.servicefiles.DataSourceXML" scope="page" />
<jsp:useBean id="DMLActionBase" class="weaver.workflow.dmlaction.commands.bases.DMLActionBase" scope="page" />
<jsp:useBean id="FieldBase" class="weaver.workflow.dmlaction.commands.bases.FieldBase" scope="page" />

<%
	String formid = Util.null2String(request.getParameter("formid"));
	String isbill = Util.null2String(request.getParameter("isbill"));
	if (!HrmUserVarify.checkUserRight("intergration:formactionsetting", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}
	String isdialog = Util.null2String(request.getParameter("isdialog"));
	String oldDataTest = Util.null2String(request.getParameter("oldDataTest"));//QC274954 [80][90]流程流转集成-解决DML修改外部数据源会有提示信息，但是点击取消后，数据源依旧会改变的问题
	String fromintegration = Util.null2String(request.getParameter("fromintegration"));
	String typename = Util.null2String(request.getParameter("typename"));
	String actionname = Util.null2String(request.getParameter("actionname"));
	String dmlorder = Util.null2String(request.getParameter("dmlorder"));
	String workflowid = Util.null2String(request.getParameter("workflowid"));
	String dmlsourceinfo = Util.null2String(request.getParameter("dmlsourceinfo"));
	//out.println("workflowid : "+workflowid+" Util.getIntValue(formid,0) : "+Util.getIntValue(formid,0));
	if(!"".equals(workflowid))
	{
		RecordSet.executeSql("select * from workflow_base where id="+workflowid);
		if(RecordSet.next())
		{
			formid = RecordSet.getString("formid");
			isbill = RecordSet.getString("isbill");
		}
	}
	//out.println("workflowid : "+workflowid+" formid : "+formid+" isbill : "+isbill);
	String formname = "";
	int detailTableId = -1;
	if(!"".equals(formid))
	{
		FieldBase.setIsbill(Util.getIntValue(isbill,0));
		String sql = "";
		if("0".equals(isbill)){
			sql = "select formname from workflow_formbase where id = "+formid;
		}else{
			sql = "select h.labelname from workflow_bill b ,htmllabelinfo h where b.namelabel=h.indexid and h.languageid="+user.getLanguage()+" and b.id="+formid;
		}
		RecordSet.executeSql(sql);
		if(RecordSet.next()){
			formname = RecordSet.getString(1);
		}
		
		if(!"".equals(dmlsourceinfo) && dmlsourceinfo.startsWith("detail_")){   //说明选择了明细表
			String [] sourceinfo = dmlsourceinfo.split("_",-1);
			if(sourceinfo.length == 3){
				detailTableId = Util.getIntValue(Util.null2String(sourceinfo[1]),-1);
				FieldBase.setDetailTableId(detailTableId);
			}
		}
	}
	else
	{
		formid = "0";
	}
	//数据源
	String datasourceid = Util.null2String(request.getParameter("datasourceid"));
	//是否需要选择数据源
	/*boolean needcheckds = true;
	if(user.getUID()==1)
	{
		needcheckds = false;
	}*/
	boolean needcheckds = false;
	String triggermothod = Util.null2String(request.getParameter("triggermothod"));
	if("".equals(triggermothod))
		triggermothod = "1";
	//操作类型
	String dmltype = Util.null2String(request.getParameter("dmltype"));
	//表单id
	String dmlformid = Util.null2String(request.getParameter("dmlformid"));
	String dmlformname = Util.null2String(request.getParameter("dmlformname"));
	//是否为明细
	String dmlisdetail = Util.null2String(request.getParameter("dmlisdetail"));
	
	//对应表名称
	String dmltablename = Util.null2String(request.getParameter("dmltablename"));
	//表别名
	String dmltablebyname = Util.null2String(request.getParameter("dmltablebyname"));
	//字段列表
	List fieldList = new ArrayList();
	Map fieldDBTypeMap = new HashMap();
	//字段标签列表
	Map fieldLabelMap = new HashMap();
	//字段名列表
	Map fieldNameMap = new HashMap();
	
	
	int nodeid = Util.getIntValue(request.getParameter("nodeid"),0);
	//是否节点后附加操作
	int ispreoperator = Util.getIntValue(request.getParameter("ispreoperator"), 0);
	//出口id
	int nodelinkid = Util.getIntValue(request.getParameter("nodelinkid"), 0);
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
	<%if("1".equals(isdialog)){ %>
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
			if("1".equals(fromintegration)){
				//RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",/integration/formactionlist.jsp?typename="+typename+",_self} ";
				//RCMenuHeight += RCMenuHeightStep;
			}else{
				RCMenu += "{" + SystemEnv.getHtmlLabelName(1290, user.getLanguage()) + ",javascript:backtoworkflow(),_self} ";
				RCMenuHeight += RCMenuHeightStep;
			}
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
				<td></td>
				<td class="rightSearchSpan" style="text-align:right; width:500px!important">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86 ,user.getLanguage()) %>" class="e8_btn_top" onclick="submitData()"/>
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
		<form name="frmmain" method="post" action="/workflow/dmlaction/FormActionSettingOperation.jsp" target="_self">
			<input type="hidden" id="operate" name="operate" value="add">
			<input type="hidden" id="fromintegration" name="fromintegration" value="<%=fromintegration %>">
			<input type="hidden" id="typename" name="typename" value="<%=typename %>">
			<input type="hidden" id="workflowid" name="workflowid" value="<%=workflowid %>">
			<input type="hidden" id="nodeid" name="nodeid" value="<%=nodeid %>">
			<input type="hidden" id="ispreoperator" name="ispreoperator" value="<%=ispreoperator %>">
			<input type="hidden" id="nodelinkid" name="nodelinkid" value="<%=nodelinkid %>">
			<input type="hidden" id="oldDataTest" name="oldDataTest" value="<%=oldDataTest %>"> <!--QC274954 [80][90]流程流转集成-解决DML修改外部数据源会有提示信息，但是点击取消后，数据源依旧会改变的问题-->
			<%if("1".equals(isdialog)){ %>
			<input type="hidden" name="isdialog" value="<%=isdialog%>">
			<%} %>
			
			
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>' attributes="{'samePair':'BaseInfo','groupOperDisplay':'none'}">
					<wea:item><%=SystemEnv.getHtmlLabelName(195, user.getLanguage())%></wea:item>
					<wea:item>
						<!--QC267860  [80][90]流程流转集成-DML弹出窗口按Backspace会重复插入一条数据  autofocus="autofocus"-->
						<!--282798  [80][90]数据展现集成-新建页面【标识】建议限制前后输入空格 增加onblur事件-->
						<input type=text  class=inputstyle  id="actionname" name="actionname" autofocus="autofocus" style="width:280px!important;" value="<%=actionname%>" onblur="trimActionName(this.value)" onChange="checkinput('actionname','actionnamespan')">
						<span id="actionnamespan">
							<%if (actionname.equals("")){%>
							<img src="/images/BacoError_wev8.gif" align=absmiddle>
							<%}%>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(15451, user.getLanguage())%></wea:item>
					<wea:item>
						<brow:browser name="formid" viewType="0" hasBrowser="true" hasAdd="false" 
			                  browserUrl="/systeminfo/BrowserMain.jsp?url=/workflow/FormBillBrowser.jsp" 
			                  _callback="showFlowDiv" isMustInput="2" isSingle="true" hasInput="true"
			                  completeUrl="/data.jsp?type=wfFormBrowser&isbill=0" width='280px' browserValue='<%= ""+formid %>' browserSpanValue='<%=formname %>' />
			    		<input type="hidden" id="isbill" name="isbill" value='<%= ""+isbill %>'>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(18076, user.getLanguage())%></wea:item>
					<wea:item>
						<select id="datasourceid" name="datasourceid"  style='width:80px!important;' onchange="ChangeDatasource(this);<%if(needcheckds){ %>checkinput('datasourceid','datasourceidspan');<%} %>">
							<option value=''></option>
							<%
							    List datasourceList = DataSourceXML.getPointArrayList();
								for (int i = 0; i < datasourceList.size(); i++)
								{
									String pointid = Util.null2String((String) datasourceList.get(i));
							%>
							<option value='<%=pointid%>' <%if(pointid.equals(datasourceid)){ %>selected<%} %>><%=pointid%></option>
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
					<wea:item>DML <%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></wea:item>
					<wea:item>
						<select id="dmltype" name="dmltype" style='width:80px!important;' onChange="checkinput('dmltype','dmltypespan');changeProcedure();">
							<option></option>
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
					<select id="dmlsourceinfo" name="dmlsourceinfo" style="width:80px!important;" onchange="onShowFormSerach();">
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
						//流程id，节点id或者出口id，是否需要检查数据源以及是数据源是否为空
						if (!"".equals(formid)){
							String maintablename = "";
							FieldBase.getFormTableFields(user,RecordSet,Util.getIntValue(formid,0),Util.getIntValue(isbill,0),0);
							maintablename = FieldBase.getFormtable();
							String formDetailTable = FieldBase.getFormDetailTable();
							boolean hasdetail = false;
							if(!"".equals(formid) && !"0".equals(formid) && !"".equals(formDetailTable)){
								hasdetail = true;	
							}
						%>
						<wea:layout>
							<wea:group context='<%="DML "+SystemEnv.getHtmlLabelName(68,user.getLanguage())%>' attributes="{'samePair':'SetInfo','groupOperDisplay':'none'}">
								<wea:item><%=SystemEnv.getHtmlLabelName(84596, user.getLanguage())%></wea:item>
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
													<input type=hidden id="dmlformid" name="dmlformid" value="<%=dmlformid %>">
													<input type=hidden id="dmlformname" name="dmlformname" value="<%=dmlformname %>">
													<input type=hidden id="dmlisdetail" name="dmlisdetail" value="<%=dmlisdetail %>">
												</td>
												<td class=field>
													<input type=text class=Inputstyle  id="dmltablename" name="dmltablename" title="<%=dmltablename %>" value="<%=dmltablename %>"	onBlur='checkinput_char_num("dmltablename");' onchange="javascript:changeTableField();checkinput('dmltablename','dmltablenamespans');changeImage();"><span id="dmltablenamespans"><%if (dmltablename.equals("")){%><img src="/images/BacoError_wev8.gif" align=absmiddle><%} %></span>
												</td>
											</tr>
										</tbody>
									</table>	
								</wea:item>
								
								
								<%
									if(hasdetail){
								%>
									<wea:item> <%=SystemEnv.getHtmlLabelName(84595,user.getLanguage())%> </wea:item>
									<wea:item> 
									<%=formDetailTable%>
									<input type="hidden" id="maintablename" name="maintablename" value="<%=formDetailTable%>"/>
								    </wea:item>
								<%		
									}else{
								%>
									<wea:item><%=SystemEnv.getHtmlLabelName(26421, user.getLanguage())%></wea:item>
									<wea:item>
										<%=maintablename %>
										<input type=hidden id="maintablename" name="maintablename" value="<%=maintablename %>">
									</wea:item>
								<%		
									}
								%>
								
								<wea:item attributes="{'colspan':'2'}">
								    <div class="listparams e8_box demo2" id="tabbox" style='height:42px;'>
		    							<ul class="tab_menu" id="tabs" style="width:85%!important;">
									    	<li style='padding-left:0px!important;'><a href="#">DML <%=SystemEnv.getHtmlLabelName(21845, user.getLanguage())%></a></li> <!-- 赋值设置 -->
								            <li style="display:none;"></li>
									        <li style="display:none;"></li>
									        <li><a href="#"><%=SystemEnv.getHtmlLabelName(130492, user.getLanguage())%></a></li><!-- 自定义主表DML语句 -->
									    </ul>
									    <div class="tab_box" style="display:none;width:0px;"></div>
									</div>								
								</wea:item>
							<%
							//字段列表
							fieldList = FieldBase.getFieldList();
							if(null!=fieldList&&fieldList.size()>0)
							{
								showExplanation = true;
								//字段类型列表
								fieldDBTypeMap = FieldBase.getFieldDBTypeMap();
								//字段标签列表
								fieldLabelMap = FieldBase.getFieldLabelMap();
								//字段名列表
								fieldNameMap = FieldBase.getFieldNameMap();
							%>	
								<wea:item attributes="{'colspan':'2','isTableList':'true'}">
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
												<tr class="listparams listparams1 listparam" id="fieldValueTable">
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
												<tr class="listparams listparams1 listparams2 listparam" id="fieldWhereTable">
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
															<tbody>
																<tr class=header>
																	<th><INPUT type="checkbox" id="chkAll" name="chkAll" onClick="chkAllClick(this,'wherecheck')"></th><!-- 字段显示名 -->
																	<th><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></th><!-- 字段名 -->
																	<th><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></th><!-- 字段类型 -->
																	<th><%=SystemEnv.getHtmlLabelName(26424, user.getLanguage())%></th><!-- 条件对应字段 -->
																	<th><%=SystemEnv.getHtmlLabelName(685, user.getLanguage())%></th><!-- 字段名称 -->
																	<th><%=SystemEnv.getHtmlLabelName(686, user.getLanguage())%></th><!-- 字段类型 -->
																	<th><%=SystemEnv.getHtmlLabelName(23128,user.getLanguage())%> </th>   <!-- 自定义规则 -->
																</tr>
															</tbody>
														</table>
													</td>
												</tr>
												<tr class="listparams listparams1 listparams2 listparam" style="height:1px!important;"><td style="height:1px!important;" class=line colspan=4 style="padding: 0px;"></td></tr>
												<tr class="listparams listparams1 listparams3 listparam">
													<td colspan=4 vAlign="top"   style="background-color:#FFF"  style='padding-left:0px!important;'>
													<ul class="tab_menu" style="width:85%!important;">
														<li>
															<a href="#"><%=SystemEnv.getHtmlLabelName(130497, user.getLanguage())%></a>
														</li>
													</ul>
													</td>
												</tr>
												<tr class="listparams listparams1 listparams3 listparam">
													<td valign="top" style='padding-left:30px!important;BACKGROUND-COLOR:white;'><%=SystemEnv.getHtmlLabelName(130497, user.getLanguage())%></td><!-- 自定义主表条件 -->
													<td class=field colspan=3>
														<textarea id="dmlmainwhere" name="dmlmainwhere" cols=100 rows=4></textarea>
													</td>
												</tr>
												<tr class="listparams listparams1 listparams3 listparam" style="height:1px!important;"><td style="height:1px!important;" class=line colspan=4 style="padding: 0px;"></td></tr>
												
												<tr class="listparams listparams4 listparam">
													<td valign="top" style='padding-left:30px!important;BACKGROUND-COLOR:white;'><%=SystemEnv.getHtmlLabelName(130492, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(63, user.getLanguage())%></td><!-- 自定义主表DML语句类型 -->
													<td class=field colspan=3>
														<select id="dmlmainsqltype" style='width:80px!important;' name="dmlmainsqltype">
														
															<option value="0" selected><%=SystemEnv.getHtmlLabelName(27670, user.getLanguage())%></option><!-- sql语句 -->
															<option value="1"><%=SystemEnv.getHtmlLabelName(27671, user.getLanguage())%></option><!-- 存储过程 -->
														
														</select>
														<a href="readme.docx" target="_blank" title="<%=SystemEnv.getHtmlLabelName(15593,user.getLanguage()) %>"><%=SystemEnv.getHtmlLabelName(15593,user.getLanguage()) %></a>
													</td>
												</tr>
												<tr class="listparams listparams4 listparam" style="height:1px!important;"><td style="height:1px!important;" class=line colspan=4 style="padding: 0px;"></td></tr>
												<tr class="listparams listparams4 listparam">
													<td valign="top" style='padding-left:30px!important;BACKGROUND-COLOR:white;'><%=SystemEnv.getHtmlLabelName(130492, user.getLanguage())%></td><!-- 自定义主表DML语句 -->
													<td class=field colspan=3>
														<textarea id="dmlmainsql" name="dmlmainsql" cols=100 rows=4></textarea>
													</td>
												</tr>
												<tr class="listparams listparams4 listparam" style="height:1px!important;"><td style="height:1px!important;" class=line colspan=4 style="padding: 0px;"></td></tr>
											</tbody>
										</table>							
									<%if (formid.equals("")){%>
									<span style="color:red;"><%=SystemEnv.getHtmlLabelName(83687, user.getLanguage())%>!</span><!-- 未选择相关表单 -->
									<%}else if(needcheckds&&"".equals(datasourceid)){%>
									<span style="color:red;"><%=SystemEnv.getHtmlLabelName(27672, user.getLanguage())%>!</span><!-- 请先选择数据源 -->
									<%}%>
								</wea:item>	
							<%} %>
							</wea:group>
						</wea:layout>
						<%}%>
						
						<% if(showExplanation){ %>
						<wea:layout><!-- 操作说明 -->
							<wea:group context='<%="DML "+SystemEnv.getHtmlLabelName(19010, user.getLanguage())%>' attributes="{'samePair':'SetInfo','groupOperDisplay':'none'}">
								<wea:item attributes="{'colspan':'2','isTableList':'true'}">
								<table width="100%" >
										<tr>
											<td style='padding-left:30px!important;BACKGROUND-COLOR:white;'>
												<font color="red">1.<%=SystemEnv.getHtmlLabelName(27673, user.getLanguage())%></font><br><!-- 请谨慎使用update，delete操作 -->
												<font color="green">2.<%=SystemEnv.getHtmlLabelName(130498, user.getLanguage())%></font><br><!-- 只能同步当前流程主表数据的到其他数据表中 -->
												<font color="green">3.<%=SystemEnv.getHtmlLabelName(130499, user.getLanguage())%><br><!-- 如果DML类型为update.delete，那么必须有DML主表条件或者自定义主表条件，否则此DML不被执行 -->
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
						
<%if("1".equals(isdialog)){ %>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
		<input type="button" style="display:none;" class=zd_btn_submit accessKey=S  id=btnsearch value="S-<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"></input>
		<wea:layout needImportDefaultJsAndCss="false">
			<wea:group context=""  attributes="{'groupDisplay':'none'}">
				<wea:item type="toolbar">
					<input type="button" class=zd_btn_cancle accessKey=T  id=btncancel value="T-<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" onclick='onClose();'></input>
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

	var inputName = "extravalue";
	if(fieldtable == "fieldWhereTableTr"){
		inputName = "extrawhere";
	}
	var inputHtml = "<input type=\"hidden\" name=\"" + inputName + "\" value=\"\" style=\"\"/>";
	
	var sHtml = inputHtml + "<select name=\"" + selname + "\" onchange=\"onChangeTranstType(this)\">"
			  + "<option value=\"\">&nbsp;</option>"
			  + "<option value=\"1\"><%=SystemEnv.getHtmlLabelName(453,user.getLanguage())%></option>"
			  + "<option value=\"7\"><%=SystemEnv.getHtmlLabelName(126462,user.getLanguage())%></option>"
			  + "</select>";
	oCell7.innerHTML = sHtml;		  
    /*
    var oRow2 = oTable.insertRow(rowIndex+1);
    oRow2.style.height="1px"
    oRow2.style.clear="both";
    oRow2.className="Spacing"
    var oCell5 = oRow2.insertCell(0);
    oCell5.className = "paddingLeft18";
    oCell5.style.height="1px"
	oCell5.colSpan = 7;
    oCell5.style.padding=0;
    oCell5.innerHTML = "<div class=\"intervalDivClass\"></div>";
    */
	isright = isright?false:true;

	//美化下拉框组件
	beautySelect();
}
function onClose()
{
	parent.parent.getDialog(parent).close();
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
					// 281176 [80][90]解决DML接口页面中，点选一行设置删除会删除两行（这行和下一行）的问题 var oRowLine = oRow.next();
					deleteList.push(oRow);
						// 281176 [80][90]解决DML接口页面中，点选一行设置删除会删除两行（这行和下一行）的问题 deleteList.push(oRowLine);
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
function onShowTable(event,data,name){
	if(data){
		if(data.id != ""){
			document.getElementById("dmltablename").value = data.other1;
			document.getElementById("dmlformname").value = data.name;
			//alert(data.id);
			document.getElementById("dmlformid").value = data.other2;
			document.getElementById("dmlisdetail").value = data.other3;
		}else{
			document.getElementById("dmltablename").value = data.other1;
			document.getElementById("dmlformname").value = "";
			document.getElementById("dmlformid").value = "";
			document.getElementById("dmlisdetail").value = "";
		}
	}
	changeTableField();
}
function changeTableField()
{
	checkinput('dmltablename','dmltablenamespans');
	var olddmltablename = "<%=dmltablename %>";
	var olddmlformname = "<%=dmlformname %>";
	var olddmlformid = "<%=dmlformid %>";
	var olddmlisdetail = "<%=dmlisdetail %>";
	var tempdmltablename = document.getElementById('tempdmltablename').value;
	
	var newdmltablename = document.getElementById('dmltablename').value;
	var newdmlformname = document.getElementById('dmlformname').value;
	var newdmlformid = document.getElementById('dmlformid').value;
	var newdmlisdetail = document.getElementById('dmlisdetail').value;
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
				document.getElementById('dmlformid').value = olddmlformid;
				document.getElementById('dmlformname').value = olddmlformname;
				document.getElementById('dmlisdetail').value = olddmlisdetail;
				document.getElementById('dmltablename').value = olddmltablename;
			}, 320, 90);
		}
	}
	var dmltablename = document.getElementById('dmltablename').value;
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
function appendField(dmltype,fieldname,fielddbtype,iscanhandle,obj)
{
	try{
		//alert("fieldname : "+fieldname);
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
		//alert(obj.parentElement.)
		//字段名
		var obj = obj.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement.parentElement;
		//alert(obj.outerHTML)
		//var objfield = obj.parentElement.nextSibling;
		//objfield.value = fieldname;
		//字段类型
		var dbtypecell = obj.nextSibling.firstChild;
		//alert(dbtypecell.outerHTML)
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
    		if((dmlmainsqltype==0&&dmlmainsql.indexOf("update")!=0&&dmlmainsql.indexOf("insert")!=0&&dmlmainsql.indexOf("delete")!=0))
    		{
    			//不正确，请重新输入
    			top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(130492, user.getLanguage())%><%=SystemEnv.getHtmlLabelName(27685, user.getLanguage())%>，<%=SystemEnv.getHtmlLabelName(27686, user.getLanguage())%>!");
   				//document.frmmain.dmlmainsql.focus();
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

var oldDataTest = '<%=oldDataTest%>';
function ChangeDatasource(obj)
{
    var olddatasourceid = "<%=datasourceid %>";
    var thisdatasourceid = document.getElementById('thisdatasourceid');
    var ischange = false;
    var hasField = hasFieldAdd();
	if(hasField || !!$("#dmltablename").val())//274958  [80][90]流程流转集成-解决修改数据源，仍然选择原来的数据源依旧会提示并清空配置数据的问题
    {
        //切换数据源将丢失您的设置,确定切换数据源吗\
        var val = $(obj).val();//274958  [80][90]流程流转集成-解决修改数据源，仍然选择原来的数据源依旧会提示并清空配置数据的问题
        //切换数据源将丢失您的设置,确定切换数据源吗
        if(!(val == oldDataTest)) {//274958  [80][90]流程流转集成-解决修改数据源，仍然选择原来的数据源依旧会提示并清空配置数据的问题
            top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(26431,user.getLanguage())%>?", function () {
                  if(hasField){
                    ischange = true;
                    deleteAllRow('fieldValueTableTr', 'dmlcheck');
                    deleteAllRow('fieldWhereTableTr', 'wherecheck');
                }
                if(oldDataTest == "" && val != "") thisdatasourceid.style.display = "none";//QC 274956  [80][90]流程流转集成-解决DML修改外部数据源的数据内容初始化问题
                oldDataTest = $(obj).val();
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
                    if (op.value == oldDataTest) {
                        op.selected = true;
                    }
                }
				if(oldDataTest !="" && val == "") thisdatasourceid.style.display = "none";//QC 274954  [80][90]流程流转集成-解决DML修改外部数据源会有提示信息，但是点击取消后，数据源依旧会改变的问题
                $(showTextId).attr("title", oldDataTest);//QC 274954  [80][90]流程流转集成-解决DML修改外部数据源会有提示信息，但是点击取消后，数据源依旧会改变的问题
                $(showTextId).text(oldDataTest);//QC 274954  [80][90]流程流转集成-解决DML修改外部数据源会有提示信息，但是点击取消后，数据源依旧会改变的问题
            }, 320, 90);
        }
    }
    else
    {
        oldDataTest = $(obj).val();
        ischange = true;
    }
	//alert(obj.value);
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
		if(oldDataTest != "" )
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
	
	//选择存储过程时，外部主表非必填
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
function changeTriggerMothod(objvalue)
{
	var type = objvalue;
	if(type=="1")
	{
		$("#nodeid").selectbox("show");
		$("#nodeid").selectbox("detach");
        $("#nodeid").selectbox();
        
		$("#ispreoperator").selectbox("show");
		$("#ispreoperator").selectbox("detach");
        $("#ispreoperator").selectbox();
        
		$("#nodeidspan").show();
        
		$("#ispreoperatorspan").show();
        
		$("#nodelinkid").selectbox("hide");
		//$("#nodelinkid").selectbox("detach");
        //$("#nodelinkid").selectbox();
        
		$("#nodelinkidspan").hide();
        
		$("#nodelinkid").val("");
		//$("#nodelinkid").selectbox("detach");
        //$("#nodelinkid").selectbox();
	}
	else if(type=="0")
	{
		$("#nodeid").selectbox("hide");
		//$("#nodeid").selectbox("detach");
        //$("#nodeid").selectbox();
        
		$("#nodeidspan").hide();
		$("#ispreoperator").selectbox("hide");
		//$("#ispreoperator").selectbox("detach");
        //$("#ispreoperator").selectbox();
        
		$("#ispreoperatorspan").hide();
		$("#nodelinkid").selectbox("show");
		$("#nodelinkid").selectbox("detach");
        $("#nodelinkid").selectbox();
        
        
		$("#nodelinkidspan").show();
		$("#nodeid").val("");
		//$("#nodeid").selectbox("detach");
        //$("#nodeid").selectbox();
        
		$("#ispreoperator").val("");
		//$("#ispreoperator").selectbox("detach");
        //$("#ispreoperator").selectbox();
	}
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
			
			//显示转化自定义浏览框的数据库字段类型
			if(fielddbtype.indexOf("browser") != -1){
				<%
				boolean isoracle = (RecordSet.getDBType()).equals("oracle");
				if(isoracle){
				%>
					fielddbtype = "varchar2(1000)";
				<%
				}else{
				%>
					fielddbtype = "varchar(1000)";
				<%
				}
				%>
			}
			//end
			
			iscanhandle = data.a1;
		}else{
			fieldname = "";
			fielddbtype = "";
			iscanhandle = "";
		}
	}
	appendField(dmltype,fieldname,fielddbtype,iscanhandle,obj);
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
	var urls = "/systeminfo/BrowserMain.jsp?mouldID=workflow&formid="+formid+"&isbill="+isbill+"&url=/workflow/dmlaction/dmlFormFieldsBrowser.jsp?mouldID=workflow&formid="+formid+"&isbill="+isbill + "&showdetail=" + showdetail + "&tableid=" + tableid;
	//alert(urls);
	return urls;
}
function onSetFormField(event,data,name,dmltype,tg)
{
	var fieldname = "";
	var fielddbtype = "";
	var showname = "";
	var obj = null;
	//alert("tg : "+tg);
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
			
			//显示转化自定义浏览框的数据库字段类型
			if(fielddbtype.indexOf("browser") != -1){
				<%
				if(isoracle){
				%>
					fielddbtype = "varchar2(1000)";
				<%
				}else{
				%>
					fielddbtype = "varchar(1000)";
				<%
				}
				%>
			}
			//end
			
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
	
	if(selval != ""){
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
}


function backtoworkflow()
{
	window.parent.close();
	dialogArguments.reloadDMLAtion();
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
	var isbill = "";
	if(typeof(datas.isbill) == "undefined")
	{
		isbill = datas.isBill;
	}
	else
	{
		isbill = datas.isbill;
	}
	$("#isbill").val(isbill);
	onShowFormSerach();
	
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
$(document).ready(function(){
	try
	{
		$(".listparams2").hide();
		$(".listparams3").hide();
		$(".listparams4").hide();
		$(".listparams5").hide();
	}catch(e)
	{
	}
	showListTab();
	<%if("1".equals(fromintegration)){ %>
	//changeTriggerMothod(1);
	<%}%>
	try
	{
		parent.document.getElementById("main").style.height= "100%";
	}
	
	
	catch(e)
	{}
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
function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "","dialogWidth:550px;dialogHeight:550px;");
	if (id != null) {
		if (wuiUtil.getJsonValueByIndex(id, 0) != "") {
			if (curl != undefined && curl != null && curl != "") {
				spanobj.innerHTML = "<A href='" + curl
						+ wuiUtil.getJsonValueByIndex(id, 0) + "'>"
						+ wuiUtil.getJsonValueByIndex(id, 1) + "</a>";
			} else {
				spanobj.innerHTML = wuiUtil.getJsonValueByIndex(id, 1);
			}
			inputobj.value = wuiUtil.getJsonValueByIndex(id, 0);
			document.frmmain.action="/workflow/dmlaction/FormActionSettingAdd.jsp"
   			document.frmmain.submit()
		} else {
			spanobj.innerHTML = need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "";
			inputobj.value = "";
		}
	}
}
function onShowFormSerach() {
	$("#oldDataTest").val(oldDataTest);//QC274954 [80][90]流程流转集成-解决DML修改外部数据源会有提示信息，但是点击取消后，数据源依旧会改变的问题
	document.frmmain.action="/workflow/dmlaction/FormActionSettingAdd.jsp";
   	document.frmmain.submit();
}
function onBackUrl(url)
{
	document.location.href=url;
}

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
		}
	}
}
//QC:270474 start 概述:[80][90]数据流转集成-解决DML接口在UPDATE 和DELETE 模式下，自定义SQL格式化问题
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
//QC:270474 end 概述:[80][90]数据流转集成-解决DML接口在UPDATE 和DELETE 模式下，自定义SQL格式化问题

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
