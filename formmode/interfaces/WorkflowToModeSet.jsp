<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="weaver.formmode.browser.FormModeBrowserUtil"%>
<%@ page import="weaver.general.StaticObj"%>
<%@ page import="weaver.interfaces.workflow.action.Action"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.conn.*" %>
<%@ include file="/formmode/pub.jsp"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="xssUtil" class="weaver.filter.XssUtil"/>
<jsp:useBean id="WFNodePortalMainManager" class="weaver.workflow.workflow.WFNodePortalMainManager" scope="page" />
<HTML>
<HEAD>
<link type='text/css' rel='stylesheet'  href='/wui/theme/ecology8/skins/default/wui_wev8.css'/>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript" src="/wui/theme/ecology8/page/perfect-scrollbar/perfect-scrollbar_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/browserCommon_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<link href="/js/ecology8/selectbox/css/jquery.selectbox_wev8.css" type=text/css rel=stylesheet>
<script language=javascript src="/js/ecology8/selectbox/js/jquery.selectbox-0.2_wev8.js"></script>
<style>
*, textarea, select{font: 12px Microsoft YaHei;}
.e8_tblForm{
	width: 100%;
	margin: 0 0;
	border-collapse: collapse;
}
.e8_tblForm .e8_tblForm_label{
	vertical-align: top;
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 0;
}
.e8_tblForm .e8_tblForm_field{
	border-bottom: 1px solid #e6e6e6;
	padding: 5px 7px;
	background-color: #f8f8f8;
}
.e8_label_desc{
	color: #aaa;
}
.e8_label_desc1{
	color: red;
}
.e8_tbl_detail{
	width: 100%;
	border-collpase: collapse;
	border-spacing: 0px;
	background-color: #e6e6e6;
	border: 0px solid #e6e6e6;
	border-bottom: 0;
}
.e8_tbl_detail tr th{
	background-color: #e6e6e6;
	border-bottom: 1px solid #e6e6e6;
	text-align: left;
	padding: 1px 4px;
	font-weight: bold;
}
.e8_tbl_detail tr td{
	background-color: #f8f8f8;
	border-bottom: 1px solid #e6e6e6;
	padding: 1px 4px;
	color: #333;
}
div#divPage{
	display: inline;
}
.sbSelectorRed:link, .sbSelectorRed:visited, .sbSelectorRed:hover{
	color:red !important;
}
</style> 
</head>
<%
if(!HrmUserVarify.checkUserRight("ModeSetting:All", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}
boolean existWorkflowToMode = false;
try{
Action workflowToModeAction = (Action)StaticObj.getServiceByFullname("action.WorkflowToMode", Action.class);
if(workflowToModeAction!=null)
	existWorkflowToMode = true;
}catch(org.apache.hivemind.ApplicationRuntimeException e){
}
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(30055,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(82,user.getLanguage());//流程转数据:新建
String needfav ="1";
String needhelp ="";

int id = Util.getIntValue(Util.null2String(request.getParameter("id")),0);
int isadd = Util.getIntValue(Util.null2String(request.getParameter("isadd")),0);
int modeid = Util.getIntValue(Util.null2String(request.getParameter("modeid")),0);
int formid = Util.getIntValue(Util.null2String(request.getParameter("formid")),0);
int workflowid = Util.getIntValue(Util.null2String(request.getParameter("workflowid")),0);



int initmodeid = Util.getIntValue(Util.null2String(request.getParameter("initmodeid")),0);
int initworkflowid = Util.getIntValue(Util.null2String(request.getParameter("initworkflowid")),0);
if(isadd==1){
	modeid = initmodeid;
	//workflowid = initworkflowid;
}


String modename = "";
String sql = "";
int modeformid = 0;
String wfformid = "";
int modecreater = 0;
int modecreaterfieldid = 0;
int triggerNodeId = 0;
int triggerType = 0;
int triggerMethod = 1;
int workflowExport = 0;
int isenable = 0;
int actionid = -1;
String formtype = "";
boolean isdetailform = false;

String maintableopttype="1";
String maintableupdatecondition = "";
String maintablewherecondition = "";
String basedfield = "";
sql = "select * from mode_workflowtomodeset where id = " + id;
rs.executeSql(sql);
while(rs.next()){
	modeid = rs.getInt("modeid");
	workflowid = rs.getInt("workflowid");
	formid = rs.getInt("formid");
	id = rs.getInt("id");
	modecreater = rs.getInt("modecreater");
	modecreaterfieldid = rs.getInt("modecreaterfieldid");
	rs1.executeSql("select formid from workflow_base where id="+workflowid);
	if(rs1.next()){
		wfformid = Util.null2String(rs1.getString("formid"));
	}
	//wfformid = Util.getIntValue(WorkflowComInfo.getFormId(String.valueOf(workflowid)));
	triggerNodeId = rs.getInt("triggerNodeId");
	triggerType = rs.getInt("triggerType");
	triggerMethod = Util.getIntValue(rs.getString("triggerMethod"), 1);
	workflowExport = Util.getIntValue(rs.getString("workflowExport"), 0);
	isenable = rs.getInt("isenable");
	formtype = Util.null2String(rs.getString("formtype"));
	if(formtype.indexOf("detail")>-1){
		isdetailform = true;
	}
	actionid = rs.getInt("actionid");
	if(actionid<0){
		actionid = -1;
	}
	maintableopttype = Util.null2String(rs.getString("maintableopttype"));
	if("".equals(maintableopttype)){
		maintableopttype = "1";
	}
	maintableupdatecondition = Util.null2String(rs.getString("maintableupdatecondition"));
	maintableupdatecondition = Util.toScreenToEdit(maintableupdatecondition,user.getLanguage());
	maintablewherecondition = Util.null2String(rs.getString("maintablewherecondition"));
	basedfield = Util.null2String(rs.getString("basedfield"));
}

//=============字段对应设置信息=====================

boolean initFiled=true;
HashMap existsMap = new HashMap();
sql = "select * from mode_workflowtomodesetdetail where mainid = " + id;
rs.executeSql(sql);
while(rs.next()){
	String modefieldid = rs.getString("modefieldid");
	String wffieldid = rs.getString("wffieldid");
	String key = modefieldid+"_"+wffieldid;
	existsMap.put(key,key);
	existsMap.put(modefieldid,wffieldid);
	if(!"0".equals(wffieldid)){
	  initFiled=false;
	}
}

//=============子表操作设置信息=====================

Map<String,Object> detailtableoptMap = new HashMap<String,Object>();
sql ="select * from mode_workflowtomodesetopt where mainid = " + id;
rs.executeSql(sql);
while(rs.next()){
	String detailtablename = Util.null2String(rs.getString("detailtablename"));
	String opttype = Util.null2String(rs.getString("opttype"));
	String updatecondition = Util.null2String(rs.getString("updatecondition"));
	updatecondition = Util.toScreenToEdit(updatecondition,user.getLanguage());
	String wherecondition = Util.null2String(rs.getString("wherecondition"));
	Map<String,Object> optMap = new HashMap<String,Object>();
	optMap.put("opttype", opttype);
	optMap.put("updatecondition",updatecondition);
	optMap.put("wherecondition",wherecondition);
	detailtableoptMap.put(detailtablename,optMap);
}

if(modeid>0){
	sql = "select modename,formid from modeinfo where id = " + modeid;
	rs.executeSql(sql);
	while(rs.next()){
		modename = Util.null2String(rs.getString("modename"));
		modeformid = rs.getInt("formid");
	}
}

String subCompanyIdsql = "select subCompanyId from modeinfo where id="+modeid;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
}
String userRightStr = "ModeSetting:All";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);

if(modename.equals("")){
	modename = "<img src=\"/images/BacoError_wev8.gif\" align=\"absmiddle\">";
}
String workflowname = WorkflowComInfo.getWorkflowname(String.valueOf(workflowid));
if(workflowname.equals("")){
	workflowname = "<img src=\"/images/BacoError_wev8.gif\" align=\"absmiddle\">";
}

//显示基础设置
String displaystr = "";
if(workflowid<=0){
	displaystr = "style=\"display:none\"";
}

if(modeid>0&&workflowid>0){
	titlename = SystemEnv.getHtmlLabelName(30055,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(19342,user.getLanguage());//流程转数据:详细设置
}

%>
<BODY>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javaScript:doSave(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
}

if(operatelevel>1){
	if(isadd!=1){
		RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javaScript:doDel(),_self} " ;
		RCMenuHeight += RCMenuHeightStep;
	}
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javaScript:doBack(),_self} " ;
RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<form name="frmSearch" method="post" action="/formmode/interfaces/WorkflowToModeSetOperation.jsp">
	<input name="operation" value="save" type="hidden">
	<input name="id" value="<%=id%>" type="hidden">
	<input name="actionid" value="<%=actionid%>" type="hidden">
	
	<input name="initmodeid" value="<%=initmodeid%>" type="hidden">
	<input name="initworkflowid" value="<%=initworkflowid%>" type="hidden">
	<input type="hidden" name="triggerMethodOld" value="<%=triggerMethod%>">
	<input type="hidden" name="triggerNodeIdOld" value="<%=triggerNodeId%>">
	<input type="hidden" name="workflowExportOld" value="<%=workflowExport%>">
	<table class="e8_tblForm">
		<tr <%=displaystr%>>
			<td class="e8_tblForm_label" width="20%">
				<%=SystemEnv.getHtmlLabelName(18624,user.getLanguage())%><!-- 是否启用 -->
				<div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(81954,user.getLanguage())%></div><!-- 勾选此项功能生效。 -->
			</td>
			<td class="e8_tblForm_field">
				<input class="inputstyle" id="isenable" name="isenable" <%=existWorkflowToMode?"":"disabled" %>  type="checkbox" value="1" <%if(isenable==1)out.println("checked");%>>
				<span  style="color:red; display:<%=existWorkflowToMode?"none":"" %>"><%=SystemEnv.getHtmlLabelName(82726,user.getLanguage())%><!-- 未在接口库中注册WorkflowToMode(流程转数据接口 ) --></span>
				<span style="margin-left: 10px; cursor: pointer;display:<%=existWorkflowToMode?"none":"" %>;" onclick="window.open('/integration/icontent.jsp?showtype=10')"><%=SystemEnv.getHtmlLabelName(82725,user.getLanguage())%><!-- 注册接口 --></span>
			</td>
		</tr>
		
		<tr>
			<td class="e8_tblForm_label" width="20%">
				<%=SystemEnv.getHtmlLabelName(16579,user.getLanguage())%><!-- 流程类型 -->
			</td>
			<td class="e8_tblForm_field">
				<brow:browser viewType="0" name="workflowid" browserValue='<%=workflowid==0?"":(String.valueOf(workflowid))%>' 
				 	browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere="+xssUtil.put("where isbill=1 and formid<0") %>'
					hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="2"
					completeUrl="/data.jsp" linkUrl=""  width="228px"
					browserDialogWidth="510px" onPropertyChange="getFormidByChange()"
					browserSpanValue='<%=workflowname%>'>
				</brow:browser>
			</td>

		</tr>
		<tr>
			<td class="e8_tblForm_label" width="20%">
				<%=SystemEnv.getHtmlLabelName(81955,user.getLanguage())%><!-- 触发表单 -->
			</td>
			<td class="e8_tblForm_field">
		  		 <div id="formIdDiv"></div>
			</td>
		</tr>
		<tr>
			<td class="e8_tblForm_label" width="20%">
				<%=SystemEnv.getHtmlLabelName(19049,user.getLanguage())%><!-- 模块 -->
			</td>
			<td class="e8_tblForm_field">
		  		 
		  		 <brow:browser viewType="0" id="modeid" name="modeid" browserValue='<%=modeid==0?"":""+modeid%>' 
  		 				browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp"
						hasInput="false" isSingle="true" hasBrowser = "true" isMustInput="2"
						completeUrl="/data.jsp" linkUrl=""  width="228px"
						browserDialogWidth="510px"
						browserSpanValue='<%=modename %>'
						></brow:browser>
			</td>
		</tr>
		
		<tr>
			<td class="e8_tblForm_label" width="20%">
				<%=SystemEnv.getHtmlLabelName(22050,user.getLanguage())%><!-- 触发类型 -->
			</td>
			<td class="e8_tblForm_field">
		  		<input type=radio name=triggerMethod id=triggerMethod value="1" <%if (triggerMethod==1) {%> checked <%} %> onclick="changeTriMethod(this.value)" >
				<%=SystemEnv.getHtmlLabelName(127798,user.getLanguage())%><!-- 节点触发 -->
				<input type=radio name=triggerMethod id=triggerMethod value="2" <%if (triggerMethod==2) {%> checked <%} %> onclick="changeTriMethod(this.value)">
				<%=SystemEnv.getHtmlLabelName(127799,user.getLanguage())%><!-- 出口触发 -->
			</td>
		</tr>

		<TR id="nodesDiv1">
			<td class="e8_tblForm_label" width="20%">
				<%=SystemEnv.getHtmlLabelName(19346,user.getLanguage())%><!-- 触发节点 -->
			</TD>                                            
			<td class="e8_tblForm_field">
			    <div id="nodesDiv">
				<SELECT class=InputStyle name="triggerNodeId" id="triggerNodeId" >    
					<%
						if (rs.getDBType().equals("oracle")||rs.getDBType().equals("db2")) {
							rs.executeSql(" select b.id as triggerNodeId,a.nodeType as triggerNodeType,b.nodeName as triggerNodeName from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id and a.workFlowId is not null and a.workFlowId= "+workflowid+"  order by a.nodeType,a.nodeId  ");
						}else{
							rs.executeSql(" select b.id as triggerNodeId,a.nodeType as triggerNodeType,b.nodeName as triggerNodeName from workflow_flownode a,workflow_nodebase b where (b.IsFreeNode is null or b.IsFreeNode!='1') and a.nodeId=b.id and a.workFlowId !='' and a.workFlowId= "+workflowid+"  order by a.nodeType,a.nodeId  ");
						}
						while(rs.next()) {
							int temptriggerNodeId = rs.getInt("triggerNodeId");
							String triggerNodeName = Util.null2String(rs.getString("triggerNodeName"));
							boolean selected = (temptriggerNodeId==triggerNodeId);
							String selectedstr = "";
							if(selected){
								selectedstr = "selected";
							}
					%>
							<option value="<%=temptriggerNodeId%>" <%=selectedstr%>><%=triggerNodeName%></option>
					<%
						}
					%>
				</SELECT>    
				</div>                                    
			</TD>		
		</TR>
		<TR id="nodesDiv2">
			<td class="e8_tblForm_label" width="20%">
				<%=SystemEnv.getHtmlLabelName(19347,user.getLanguage())%><!-- 触发时间 -->
			</TD>                                            
			<td class="e8_tblForm_field">                                          
				<SELECT class=InputStyle  name="triggerType" >   
					<option value="1" <%if(triggerType==1)out.println("selected");%>><%=SystemEnv.getHtmlLabelName(19348,user.getLanguage())%></option><!-- 到达节点 -->
					<option value="0" <%if(triggerType==0)out.println("selected");%>><%=SystemEnv.getHtmlLabelName(19349,user.getLanguage())%></option><!-- 离开节点 -->
				</SELECT>                                        
			</TD>		
		</TR>
		
		<TR id="exportDiv">
			<td class="e8_tblForm_label" width="20%">
				<%=SystemEnv.getHtmlLabelName(127800,user.getLanguage())%><!-- 流程出口-->
			</TD>                                            
			<td class="e8_tblForm_field">   
			    <div id="exportsDiv">                                       
					<SELECT class=InputStyle id="workflowExport" name="workflowExport" >  
					    <%
					    	if (workflowid > 0) {
							    WFNodePortalMainManager.resetParameter();
								WFNodePortalMainManager.setWfid(workflowid);
								WFNodePortalMainManager.selectWfNodePortal();
								while(WFNodePortalMainManager.next()){
									String selectedstr = "";
									int tmpid = WFNodePortalMainManager.getId();
									String tmpname = WFNodePortalMainManager.getLinkname();
									if (workflowExport == tmpid) {
										selectedstr = "selected";
									}
					    %> 
					    		<option value="<%=tmpid%>" <%=selectedstr %>><%=tmpname %></option><!-- 出口一-->
					    <%
								}
					    	}
					    %>
					</SELECT>   
				</div>                                     
			</TD>		
		</TR>

		<TR>
			<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(28597,user.getLanguage())%></TD><!-- 模块创建人 -->
			<td class="e8_tblForm_field">
				<input type=radio name=modecreater id=modecreater value="1" <%if(modecreater<=0||modecreater==1){%>	checked<%}%>>
				<%=SystemEnv.getHtmlLabelName(28607,user.getLanguage())%><!-- 流程当前操作人 -->
				<br/>
				<input type=radio name=modecreater id=modecreater value="2" <%if(modecreater==2){%> checked<%}%>>
				<%=SystemEnv.getHtmlLabelName(28595,user.getLanguage())%><!-- 流程创建人 -->
				<br/>
				<input type=radio name=modecreater id=modecreater value="3" <%if(modecreater==3){%> checked<%}%>>
				<%=SystemEnv.getHtmlLabelName(28608 ,user.getLanguage())%><!-- 流程人力资源相关字段 -->
				<select class=inputstyle  name="modecreaterfieldid" id="modecreaterfieldid" > 	
				<%
					int fieldId= 0;
					//sql = "select id as id , fieldlabel as name from workflow_billfield where (viewtype is null or viewtype<>1) and billid="+ wfformid+ " and fieldhtmltype = '3' and (type=1 or type=17 or type=141 or type=142 or type=166) " ;
					sql = "select id as id , fieldlabel as name from workflow_billfield where (viewtype is null or viewtype<>1) and billid='"+ wfformid+ "' and fieldhtmltype = '3' and (type=1 or type=17 or type=166) " ;
					rs.executeSql(sql);
					while(rs.next()){
						fieldId=rs.getInt("id");
				%>
						<option value=<%=fieldId%> <%if(fieldId==modecreaterfieldid){%> selected<%}%>>
						<%=SystemEnv.getHtmlLabelName(rs.getInt("name"),user.getLanguage())%>
						</option>
				<%
					}
				%>
				</select>
			</TD>
		</TR>

	<%
		int modedetailno = 0;
		int detailno = 0;
		HashMap optionMap = new HashMap();
		
		HashMap modeFieldIdMap = new HashMap();
		HashMap modeLabelNameMap = new HashMap();
		
		ArrayList modeFieldIdList = new ArrayList();
		ArrayList modeLabelNameList = new ArrayList();
		
		ArrayList modeFieldNameList = new ArrayList();
        ArrayList modeDetailFieldNameList = new ArrayList();
        
        ArrayList modeFieldTypeList = new ArrayList();
        ArrayList modeDetailFieldTypeList = new ArrayList();
		
		ArrayList modeDetailFieldIdList = new ArrayList();
		HashMap modeDetailIdMap = new HashMap();
		ArrayList modeDetailLabelNameList = new ArrayList();
		
		if(modeid>0&&workflowid>0){
			modeFieldIdList.add("-1");
			modeFieldNameList.add("-1");
			modeFieldTypeList.add("-1");
			modeLabelNameList.add(SystemEnv.getHtmlLabelName(1334,user.getLanguage())+"(requestname)");//请求标题
			
			modeFieldIdList.add("-2");
			modeFieldNameList.add("-2");
			modeFieldTypeList.add("-2");
			modeLabelNameList.add(SystemEnv.getHtmlLabelName(28610,user.getLanguage())+"(requestid)");//请求Id
			//主表名称
			sql = "select tablename from workflow_bill where id='"+wfformid+"'";
			rs.executeSql(sql);
			String maintablename="";
			if(rs.next()) {
				maintablename = Util.null2String(rs.getString("tablename"));
			}
			//流程表单字段信息
			String tempdetailtable = "";
			sql = "select id,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable from workflow_billfield where billid = '" + wfformid + "' order by viewtype asc,detailtable asc,id asc";
			rs.executeSql(sql);
			while(!"".equals(wfformid)&&rs.next()){
				String fieldid = Util.null2String(rs.getString("id"));
				String fieldname = Util.null2String(rs.getString("fieldname"));
				String fieldlabel = Util.null2String(rs.getString("fieldlabel"));
				String fielddbtype = Util.null2String(rs.getString("fielddbtype"));
				String fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
				String type = Util.null2String(rs.getString("type"));
				String viewtype = Util.null2String(rs.getString("viewtype"));
				String detailtable = Util.null2String(rs.getString("detailtable"));
				String labelname = SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlabel),user.getLanguage());
				labelname += "("+fieldname+")";
				String optionstr = "<option value=\""+fieldid+"\">"+labelname+"</option>";
				if(viewtype.equals("1")&&!tempdetailtable.equals(detailtable)){
					//modedetailno++;
					modedetailno = Util.getIntValue(detailtable.replace(maintablename+"_dt", ""));
					tempdetailtable = detailtable;
					//modeFieldIdList = new ArrayList();
					//modeLabelNameList = new ArrayList();
					modeDetailFieldIdList.add("");
					modeDetailLabelNameList.add("------"+SystemEnv.getHtmlLabelName(17463,user.getLanguage())+modedetailno+"("+detailtable+")"+"------");//明细
					String tmpId = "-"+(modedetailno+3);
					modeDetailFieldIdList.add(tmpId);
					modeDetailIdMap.put(tmpId, "$"+detailtable+".ID$");
					modeDetailLabelNameList.add(SystemEnv.getHtmlLabelName(17463,user.getLanguage())+modedetailno +"_"+"ID"); //明细ID
					modeDetailFieldNameList.add("");
					modeDetailFieldNameList.add("");
					modeDetailFieldTypeList.add("");
					modeDetailFieldTypeList.add("");
				}
				if(isdetailform && "1".equals(viewtype)){
					labelname = SystemEnv.getHtmlLabelName(17463,user.getLanguage())+modedetailno +"_"+ labelname;
				}
				if(modedetailno==0){
					modeFieldIdList.add(fieldid);
					modeLabelNameList.add(labelname);
					modeFieldNameList.add(fieldname);
					modeFieldTypeList.add(fieldhtmltype+"-"+type);
				}else{
					modeDetailFieldIdList.add(fieldid);
					modeDetailLabelNameList.add(labelname);
					modeDetailFieldNameList.add(fieldname);
					modeDetailFieldTypeList.add(fieldhtmltype+"-"+type);
				}
				String key = String.valueOf(modedetailno);
				if(optionMap.containsKey(key)){
					optionstr = Util.null2String((String)optionMap.get(key)) + optionstr;
				}
				optionMap.put(key,optionstr);
				
			}
	%>
								<tr>
								    <td class="e8_tblForm_label" width="20%">
								    <table style="width:100%;">
								    	<tr>
									    	<td>
										    	<%=SystemEnv.getHtmlLabelName(21778,user.getLanguage())%><!-- 主表 -->
										    	<div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(81956,user.getLanguage())%><!-- 模块主表字段映射。 --></div>
									    	</td>
									    </tr>
								    	<tr>
								    	<td>
								    		<div style="float:left;width:150px;">
								    		<select id="maintableopttype" name="maintableopttype" onchange="changeMaintableopttype()" style="">
								    		<option value="1" <%if("1".equals(maintableopttype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(30615,user.getLanguage())%></option><!--插入 -->
								    		<option value="2" <%if("2".equals(maintableopttype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17744,user.getLanguage())%></option><!--更新 -->
								    		
							    			<option value="3" <%if("3".equals(maintableopttype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelNames("20839,30615", user.getLanguage())%></option><!--批量插入 -->
							    			
								    		<option value="4" <%if("4".equals(maintableopttype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(127801,user.getLanguage())%></option><!--插入并更新 -->
								    		</select>
								    		</div>
								    		<div id="div_basedfield" style="float:left;width:100px;"></div>
								    	</td>
								    	</tr>
								    	<tr id="mtucTR" <%if("1".equals(maintableopttype)){%>style="display:none;"<%}%>>
								    		<td>
								    		<textarea id="maintableupdatecondition" name="maintableupdatecondition" style="width:80%;height:40px;" onChange="checkinput('maintableupdatecondition','maintableupdateconditionspan')"><%=maintableupdatecondition%></textarea>
								    		<input type="hidden" id="maintablewherecondition" name="maintablewherecondition" value="<%=maintablewherecondition%>"/>
								    		<span id="maintableupdateconditionspan"><%if(maintableupdatecondition.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
								    		<div class="e8_label_desc" style="margin-top:4px;"><%=SystemEnv.getHtmlLabelName(126244,user.getLanguage())%></div>
								    		</td>
								    	</tr>
								    	<tr id="basedfieldDescTR" <%if(!"3".equals(maintableopttype)){%>style="display:none;"<%}%>>
								    		<td>
								    		<div class="e8_label_desc" style="margin-top:4px;"></div>
								    		</td>
								    	</tr>
								    </table>
								    </td>
								    <td class="e8_tblForm_field">
								    <table class="e8_tbl_detail">
								    <tr>
									    <th width="40%"><%=SystemEnv.getHtmlLabelName(28605,user.getLanguage())%><!-- 模块字段 --></th>
									    <th width="30%"><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%><!-- 字段名称 --></th>
									    <th style="width:16px;"></th>
									    <th><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%><!-- 流程字段 --></th>
								    </tr>
		              			<%
		              				//被触发表单字段信息
		              				tempdetailtable = "";
		              				String dataclass = "datalight";
		              				sql = "select id,fieldname,fieldlabel,fielddbtype,fieldhtmltype,type,viewtype,detailtable from workflow_billfield where billid = " + modeformid + " order by viewtype asc,detailtable asc";
			              			rs.executeSql(sql);
			              			while(rs.next()){
			              				String fieldid = Util.null2String(rs.getString("id"));
			              				String fieldname = Util.null2String(rs.getString("fieldname"));
			              				String fieldlabel = Util.null2String(rs.getString("fieldlabel"));
			              				String fielddbtype = Util.null2String(rs.getString("fielddbtype"));
			              				String fieldhtmltype = Util.null2String(rs.getString("fieldhtmltype"));
			              				String type = Util.null2String(rs.getString("type"));
			              				String viewtype = Util.null2String(rs.getString("viewtype"));
			              				String detailtable = Util.null2String(rs.getString("detailtable"));
			              				String labelname = SystemEnv.getHtmlLabelName(Util.getIntValue(fieldlabel),user.getLanguage());
			              				labelname += "("+fieldname+")";
			              				
			              				boolean issinglebrowser =  false;
			              				if("3".equals(fieldhtmltype)&&!FormModeBrowserUtil.isMultiBrowser(fieldhtmltype, type)){
			              					issinglebrowser = true;
			              				}
			              				
			              				if(viewtype.equals("1")&&!tempdetailtable.equals(detailtable)){
			              					detailno++;
			              					tempdetailtable = detailtable;
			              					dataclass = "datalight";
			              					
			              					String detailtableopttype = "1";
			              					String detailtableupdatecondition = "";
			              					String detailtablewherecondition = "";
			              					if(detailtableoptMap.containsKey(detailtable)){
			              						Map<String,Object> optMap = (Map<String,Object>)detailtableoptMap.get(detailtable);
			              						detailtableopttype = Util.null2String(optMap.get("opttype"));
			              						detailtableupdatecondition = Util.null2String(optMap.get("updatecondition"));
			              						detailtablewherecondition = Util.null2String(optMap.get("wherecondition"));
			              					}
			              					
											%>
											</td></tr></table>
											<tr>
											<td class="e8_tblForm_label" width="20%">
												<table style="width:100%;">
													<tr>
														<td>
														<%=SystemEnv.getHtmlLabelName(17463,user.getLanguage())%><%=detailno%>(<%=detailtable %>)
														<input type="hidden" id="detailtablename<%=detailno%>" name="detailtablename<%=detailno%>" value="<%=detailtable %>" />
														<input type="hidden" name="detailnoflag" value="<%=detailno %>" />
														<div class="e8_label_desc"><%=SystemEnv.getHtmlLabelName(81957,user.getLanguage())%><!-- 模块明细表字段映射。 --></div>
														<div class="e8_label_desc1"><%=SystemEnv.getHtmlLabelName(81958,user.getLanguage())%><!-- (模块明细只能映射单个流程明细表) --></div>
														</td>
													</tr>
													<tr id="dtotTR<%=detailno%>" <%if(isdetailform || "1".equals(maintableopttype)){%>style="display:none;"<%}%>>
														<td>
														<select id="detailtableopttype<%=detailno%>" name="detailtableopttype<%=detailno%>" onchange="changeDetailtableopttype(this,<%=detailno%>)" style="width:80px;">
											    		<option value="1" <%if("1".equals(detailtableopttype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%></option><!-- 默认 -->
											    		<option value="2" <%if("2".equals(detailtableopttype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(31259,user.getLanguage())%></option><!-- 追加 -->
											    		<option value="3" <%if("3".equals(detailtableopttype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17744,user.getLanguage())%></option><!-- 更新 -->
											    		<option value="4" <%if("4".equals(detailtableopttype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(126237,user.getLanguage())%></option><!-- 更新(追加) -->
											    		<option value="5" <%if("5".equals(detailtableopttype)){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(31260,user.getLanguage())%></option><!-- 覆盖 -->
											    		</select>
														</td>
													</tr>
													<tr id="dtucTR<%=detailno%>" <%if(isdetailform || (!"3".equals(detailtableopttype)&&!"4".equals(detailtableopttype))){%>style="display:none;"<%}%>>
											    		<td>
											    		<textarea id="detailtableupdatecondition<%=detailno%>" name="detailtableupdatecondition<%=detailno%>" style="width:80%;height:40px;" onChange="checkinput('detailtableupdatecondition<%=detailno%>','detailtableupdateconditionspan<%=detailno%>')"><%=detailtableupdatecondition%></textarea>
											    		<input type="hidden" id="detailtablewherecondition<%=detailno%>" name="detailtablewherecondition<%=detailno%>" value="<%=detailtablewherecondition%>"/>
											    		<span id="detailtableupdateconditionspan<%=detailno%>"><%if(detailtableupdatecondition.equals("")){%><IMG src="/images/BacoError_wev8.gif" align=absMiddle><%}%></span>
											    		<div class="e8_label_desc" style="margin-top:4px;"><%=SystemEnv.getHtmlLabelName(126245,user.getLanguage())%></div>
											    		</td>
											    	</tr>
												</table>
											</td>
										    <td class="e8_tblForm_field">
											<table class="e8_tbl_detail">
												<th width="40%"><%=SystemEnv.getHtmlLabelName(28605,user.getLanguage())%><!-- 模块字段 --></th>
												<th width="30%"><%=SystemEnv.getHtmlLabelName(685,user.getLanguage())%><!-- 字段名称 --></th>
												<th style="width:16px;"></th>
												<th><%=SystemEnv.getHtmlLabelName(19372,user.getLanguage())%><!-- 流程字段 --></th>
										<%}%>
			              				<tr>
			              					<td>
			              						<%=labelname%> <span style="font-size:11px;color:#aaa;"></span>
			              						<input type="hidden" name="modefieldid<%=detailno%>" id="modefieldid<%=detailno%>" issinglebrowser="<%=issinglebrowser%>" value="<%=fieldid%>">
		              						</td>
		              						<td style="font-size:11px;"><%=fieldname%></td>
		              						<td><img src="/formmode/images/arrow_left_wev8.png"/></td>
			              					<td>
			              						<select name="wffieldid<%=detailno%>" id="wffieldid<%=detailno%>" fieldname="<%=fieldname%>"  style="width:100%" onchange="changWffieldStyle(this);setWhereCondtion(this,'<%=fieldname%>',<%=detailno%>);">
			              							<option value="0">&nbsp;&nbsp;&nbsp;&nbsp;</option>
			              							<%
			              								if(detailno==0){
			              									for(int i=0;i<modeFieldIdList.size();i++){
			              										String tempfieldid = (String)modeFieldIdList.get(i);
			              										String tempfieldlabelname = (String)modeLabelNameList.get(i);
				              									String key = fieldid+"_"+tempfieldid;
				              									boolean selected = existsMap.containsKey(key);
				              									String selectedstr = "";
				              									if(selected){
				              										selectedstr = "selected";
				              									}else if(initFiled&&fieldname.equals((String)modeFieldNameList.get(i))&&(fieldhtmltype+"-"+type).equals((String)modeFieldTypeList.get(i))){
				              									    selectedstr = "selected";
				              									}
				              									//if (!("1".equals(fieldhtmltype) && "2".equals(type)) && "-2".equals(tempfieldid) && !selected) { //文本整形,请求id，且数据库还没有这个值得时候
				              										//continue;
				              									//}
		           									%>
		           												<option value="<%=tempfieldid%>" <%=selectedstr%>><%=tempfieldlabelname%></option>
		           									<%
			              									}
			              									if(formtype.indexOf("detail")>-1){
			              										int index = Util.getIntValue(formtype.replace("detail",""));
			              										String tableStr = SystemEnv.getHtmlLabelName(17463,user.getLanguage())+index;//明细
			              										boolean isnext = false;
			              										for(int i=0;i<modeDetailFieldIdList.size();i++){
				              										String tempfieldid = (String)modeDetailFieldIdList.get(i);
				              										String tempfieldlabelname = (String)modeDetailLabelNameList.get(i);
				              										String disabled = "";
				              										if(tempfieldlabelname.indexOf("------")>-1) {
				              											disabled = "disabled";
				              										}
				              												
																	if(tempfieldlabelname.indexOf("------")>-1&&isnext){
																		isnext = false;
				              										}
				              										if(tempfieldlabelname.indexOf(tableStr)>-1){
				              											isnext = true;;
				              										}
				              										//if (!("1".equals(fieldhtmltype) && "2".equals(type)) && tempfieldid.indexOf("ID") > -1) { //文本整形,明细id
				              											//continue;
					              									//}
				              										if(isnext){
				              											String key = fieldid+"_"+tempfieldid;
						              									boolean selected = existsMap.containsKey(key);
						              									String selectedstr = "";
						              									if(selected){
						              										selectedstr = "selected";
						              									}
							           									if (Util.getIntValue(tempfieldid,-3) < -3) {
					           									%>
					           												<option <%=disabled %> value="<%=tempfieldid %>" V="<%=Util.null2String(modeDetailIdMap.get(tempfieldid))%>" <%=selectedstr%>><%=tempfieldlabelname%></option>
					           									<%      } else { %>
					           									
					           												<option <%=disabled %> value="<%=tempfieldid%>" <%=selectedstr%>><%=tempfieldlabelname%></option>
					           									<%
					           											}
				              										}
				              									}
			              									}
			              								}else if("maintable".equals(formtype)){
			              									for(int i=0;i<modeDetailFieldIdList.size();i++){
			              										String tempfieldid = (String)modeDetailFieldIdList.get(i);
			              										String tempfieldlabelname = (String)modeDetailLabelNameList.get(i);
				              									String key = fieldid+"_"+tempfieldid;
				              									boolean selected = existsMap.containsKey(key);
				              									String selectedstr = "";
				              									if(selected){
				              										selectedstr = "selected";
				              									}else if(initFiled&&fieldname.equals((String)modeDetailFieldNameList.get(i))&&(fieldhtmltype+"-"+type).equals((String)modeDetailFieldTypeList.get(i))){
                                                                    selectedstr = "selected";
                                                                }
				              									//if (!("1".equals(fieldhtmltype) && "2".equals(type)) && tempfieldid.indexOf("ID") > -1) { //文本整形,明细id
			              										//	continue;
				              									//}
				              									String disabled = "";
			              										if(tempfieldlabelname.indexOf("------")>-1) {
			              											disabled = "disabled";
			              										}
			              										if (Util.getIntValue(tempfieldid,-3) < -3) {
		           									%>
		           													<option <%=disabled %> value="<%=tempfieldid %>" V="<%=Util.null2String(modeDetailIdMap.get(tempfieldid))%>" <%=selectedstr%>><%=tempfieldlabelname%></option>
		           									<%          } else { %>
		           									
		           													<option <%=disabled %> value="<%=tempfieldid%>" <%=selectedstr%>><%=tempfieldlabelname%></option>
		           									<%
		           												}
			              									}			              									
			              								}
			              							%>
			              						</select>
			              					</td>
			              		<%
			              			}
		              			%>
		              			</table>
		              			</td>
		              			</tr>
		                	</table>
		                	<br/>
		                	<input type="hidden" name="detailno" value="<%=detailno%>">
	<%
		} 
	%>
</form>
<script type="text/javascript">
	var initworkflowid = document.getElementById("workflowid").value;
	var formtype = '<%=formtype%>';
	var isdetailform = <%=isdetailform%>;
	var basedfield = '<%=basedfield%>';
	$(document).ready(function(){//onload事件
		$(".loading", window.parent.document).hide(); //隐藏加载图片
		initFormTypeSelect();
		init_width_for_empty_selector("triggerNodeId");
		init_width_for_empty_selector("workflowExport");
		init_width_for_empty_selector("modecreaterfieldid");
		changeMaintableopttype();
		initSbSelectorStyle();
		changeTriMethod($("input[name=triggerMethod]:checked").val());
	})

	<%
		for(int i=0;i<modedetailno;i++){
			String key = String.valueOf(i);
			String optionstr = Util.null2String((String)optionMap.get(key));
			out.println(" var option" + key + "  = '" + optionstr + "';");
		}
	%>
	
	function init_width_for_empty_selector(targetId) {
		var targetObj = document.getElementById(targetId);
		if(targetObj && targetObj.options.length == 0) {
			targetObj.style.width = '80px';
			$("#" +targetId).selectbox("detach");
			beautySelect(targetObj);
		} 
	}

    function doSave(){
        rightMenu.style.visibility = "hidden";
        if($("#workflowid").val()=='0'){
        	$("#workflowid").val("");
		}
        if($("#modeid").val()=='0'){
        	$("#modeid").val("");
		}
		var checkFields = "workflowid,modeid";
		var maintableopttype = $("#maintableopttype").val();
		if(maintableopttype=="2"){
			checkFields += ",maintableupdatecondition";
			if(!isdetailform){
				jQuery("[name='detailnoflag']").each(function(){
					var detailno = jQuery(this).val();
					var detailtableopttype = jQuery("#detailtableopttype"+detailno).val();
					if((detailtableopttype=="3"||detailtableopttype=="4")){
						checkFields +=",detailtableupdatecondition"+detailno;
					}
				});
			}
		}
		if(maintableopttype=="4"){//插入并更新的时候需要做一些限制判断：流程的请求ID必须有对应；分两种情况
			var T = !($("#formtype").val()=="maintable"); //是否来自明细表触发;明细表触发主表，只需要判断主表中有没有选择明细ID
			if (T==<%=isdetailform%>) {
				var detailno = <%=detailno%>;//明细表个数
				var F = false;
				var N = false;
				if (T) { //明细触发主表，只需判断是否有关联明细ID
					document.getElementById("maintablewherecondition").value="";
					$("select[name=wffieldid0]").each(function(){
						if (parseInt($(this).val()) == -2) { 
						    N = true;
						    //同时获取对应的值给主表条件
						    var m_fieldname =  $(this).attr("fieldname");
						    var mtablewherecondition = $("#maintablewherecondition").val();
						    if (mtablewherecondition == "") {
						    	$("#maintablewherecondition").val(m_fieldname+"="+$(this).val());
						    } else {
						    	$("#maintablewherecondition").val(mtablewherecondition + " ~*~ " + m_fieldname+"="+$(this).val());
						    }   
						}
						if (parseInt($(this).val()) < -3) { 
						    F = true;
						    //获取对应的值给主表条件
						    var m_fieldname =  $(this).attr("fieldname");
						    var mtablewherecondition = $("#maintablewherecondition").val();
						    if (mtablewherecondition == "") {
						    	$("#maintablewherecondition").val(m_fieldname+"="+$(this).find("option:selected").attr("V"));
						    } else {
						    	$("#maintablewherecondition").val(mtablewherecondition + " ~*~ " + m_fieldname+"="+$(this).find("option:selected").attr("V"));
						    }   
						   
						}
					});
					if (!F || !N) {
						alert("<%=SystemEnv.getHtmlLabelName(127808,user.getLanguage())%>"); //必須要選擇一個明細ID和主表請求ID字段
						return;
					}
				} else { //不是明细触发,主表要对应一次请求ID，其它每个明细需要对应一次明细ID
					for (var i = 0 ; i < detailno + 1 ; i++) {
						if (i == 0) {
							$("select[name=wffieldid"+i+"]").each(function(){
								if (parseInt($(this).val()) == -2) { 
								    F = true;
								    //同时获取对应的值给主表条件
								    var m_fieldname =  $(this).attr("fieldname");
								    $("#maintablewherecondition").val(m_fieldname+"="+$(this).val());
								}
							});
						} else {
							$("select[name=wffieldid"+i+"]").each(function(){
								if (parseInt($(this).val()) < -3) { 
								    N = true;
								    //同时获取对应的值给明细条件
								    var m_fieldname =  $(this).attr("fieldname");
								    $("#detailtablewherecondition"+i).val(m_fieldname+"="+$(this).find("option:selected").attr("V"));
								}
							});
						}
					}
				    if (detailno == 0) {
				    	N = true;
				    }
					if (!F || !N) {
						alert("<%=SystemEnv.getHtmlLabelName(127809,user.getLanguage())%>");//主表或者明细表必须要选择对应的ID字段
						return;
					}
				}
			} else { //如果是主表触发，主表里面一定要关联上请求ID
				/**var F = false;
				if (T) { //明细触发，至少要关联明细ID
					$("select[name=wffieldid0]").each(function(){
						if ($(this).val() == "-3") { 
						    F = true;
						    $("#maintablewherecondition").val(m_fieldname+"="+$(o).find("option:selected").attr("V"));
						}
					});
				} else { //至少要关联请求id
					$("select[name=wffieldid0]").each(function(){
						if ($(this).val() == "-2") { 
						    F = true;
						    
						}
					});
				}
				if (!F) {
					alert("主表或者明细表必须要选择对应的ID字段");
					return;
				}**/
			}
		}
		
		var formtypeval = jQuery("#formtype").val();
		if( maintableopttype=="3"){
			checkFields+=",basedfield";
		}
		if(checkFieldValue(checkFields)){
			enableAllmenu();
	        document.frmSearch.submit();
		}
    }
    function doBack(){
    	enableAllmenu();
    	location.href = "/formmode/interfaces/WorkflowToModeList.jsp?modeid=<%=initmodeid%>&workflowid=<%=initworkflowid%>";
	}
	
	function doDel(){
    	window.top.Dialog.confirm("<%=SystemEnv.getHtmlNoteName(7,user.getLanguage())%>",function(){
			enableAllmenu();
    		document.frmSearch.operation.value="del";
    		document.frmSearch.submit();
		});
	}
    function onShowModeSelect(inputName, spanName){
    	var datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/formmode/browser/ModeBrowser.jsp");
    	if (datas){
    	    if(datas.id!=""){
    		    $(inputName).val(datas.id);
    			if ($(inputName).val()==datas.id){
    		    	$(spanName).html(datas.name);
    			}
    	    }else{
    		    $(inputName).val("");
    			$(spanName).html("<img src=\"/images/BacoError_wev8.gif\" align=\"absmiddle\">");
    		}
    	} 
    }
    
    function openURL(){
      var url = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkflowBrowser.jsp?sqlwhere=where isbill=1 and formid<0";
      var result = showModalDialog(url);
      if(result){
	      if(result.name!="" && result.id!=""){
	         $("#workflowspan").html(result.name);
	         $("#workflowid").val(result.id);
	      }else{
	     	 $("#workflowspan").html("<img src=\"/images/BacoError_wev8.gif\" align=\"absmiddle\">");
	         $("#workflowid").val("");
	      }
      }
    }
    function initFormTypeSelect(){
    	var ranindex = Math.ceil(Math.random()*1000);
    	var workflowid = document.getElementById("workflowid").value;
    	$.ajax({
	    		url: "/formmode/interfaces/tableByWorkflowid.jsp?index="+ranindex,
	    		data: {workflowid:workflowid},
	    		dataType: "json",
	    		success: function(data){
	    			var selectHtml = "";
	    			
	    			if(data&&data.length>0){
	    				selectHtml = selectHtml + "<select class=InputStyle id='formtype' name='formtype' onchange='changeformtype()'>";
	    				for(var i = 0;i<data.length;i++){
	    					var name = data[i].name;
	    					var value = data[i].value;
	    					if(formtype==value){
	    						selectHtml += "<option selected value='"+value+"'>"+name+"</option>";
	    					}else{
	    						selectHtml += "<option value='"+value+"'>"+name+"</option>";
	    					}
	    				}
	    				selectHtml += " </select>";
	    				
	    			}
	    			$("#formIdDiv").html(selectHtml);
	    			var targetObj = document.getElementById("formtype");
	     			beautySelect(targetObj);
	       		}
	       });
    }
    $(document).ready(function(){
    	if($("#workflowid").val()!=''){
    		var title = $("#workflowidspan").find("a").text();
			$("#workflowidspan").html("<span class=\"e8_showNameClass\">"+title+"</span>");
    	}
    });
    
    function getFormidByChange(){
    	var ranindex = Math.ceil(Math.random()*1000);
    	var workflowid = document.getElementById("workflowid").value;
    	var triggerMethodObj = $("input[name=triggerMethod]:checked");
    	if(""!=workflowid){
	    	initFormTypeSelect();
	    	//if (!triggerMethodObj || (triggerMethodObj && triggerMethodObj.val() == "1")) {
				$.ajax({
					url: "/formmode/interfaces/NodesByWorkflowid.jsp?index"+ranindex,
					data: {workflowid:workflowid},
					dataType: "json",
					success: function(data){
						var selectHtml = "";
						if(data&&data.length>0){
							selectHtml = selectHtml + "<select class=InputStyle id='triggerNodeId' name='triggerNodeId'>";
							for(var i = 0;i<data.length;i++){
								var name = data[i].name;
								var value = data[i].value;
								selectHtml += "<option value='"+value+"'>"+name+"</option>";
							}
							selectHtml +=" </select>";
						}else{
							var selectHtml =  "<select class=InputStyle id='triggerNodeId' name='triggerNodeId'></select>";
						}
						$("#nodesDiv").html(selectHtml);
						var targetObj = document.getElementById("triggerNodeId");
						targetObj.style.width = '80px';
						beautySelect(targetObj);
					}
				});
	    	//}
			
			//if (triggerMethodObj && triggerMethodObj.val() == "2") {
				$.ajax({
					url: "/formmode/interfaces/ExportsByWorkflowid.jsp?index"+ranindex,
					data: {workflowid:workflowid},
					dataType: "json",
					success: function(data){
						var selectHtml = "";
						if(data&&data.length>0){
							selectHtml = selectHtml + "<select class=InputStyle id='workflowExport' name='workflowExport'>";
							for(var i = 0;i<data.length;i++){
								var name = data[i].exportname;
								var value = data[i].exportvalue;
								selectHtml += "<option value='"+value+"'>"+name+"</option>";
							}
							selectHtml +=" </select>";
						}else{
							var selectHtml =  "<select class=InputStyle id='workflowExport' name='workflowExport'></select>";
						}
						$("#exportsDiv").html(selectHtml);
						var targetObj = document.getElementById("workflowExport");
						targetObj.style.width = '80px';
						beautySelect(targetObj);
					}
				});
			//}
    	}
    	if(event.propertyName=='value'){
			var title = $("#workflowidspan").find("a").text();
			$("#workflowidspan").html("<span class=\"e8_showNameClass\">"+title+"</span>");
		}
    }
    
    function getWorkflowVersion(workflowid){
    	var ranindex = Math.ceil(Math.random()*1000);
    	$.ajax({
    		url: "/formmode/interfaces/getWorkflowVersion.jsp?index"+ranindex,
    		data: {workflowid:workflowid},
    		cache: false,
    		success: function(data){
    			data = jQuery.trim(data);
    			if(data&&data.length>0){
    				jQuery("#workflowversion").html("V"+data);
    			}
   			}
       });
    }
    
    function changeMaintableopttype(){
    	var maintableopttype = $("#maintableopttype").val();
		if(maintableopttype=="2"){
			jQuery("#mtucTR").show();
			if(!isdetailform){
				jQuery("[name='detailnoflag']").each(function(){
					var detailno = jQuery(this).val();
					jQuery("#dtotTR"+detailno).show();
					var detailtableopttypeObj = jQuery("#detailtableopttype"+detailno);
					var detailtableopttype = detailtableopttypeObj.val();
					if(detailtableopttype=="3"||detailtableopttype=="4"){
						jQuery("#dtucTR"+detailno).show();
					}
				});
			}
		}else{
			jQuery("#mtucTR").hide();
			if(!isdetailform){
				jQuery("[name='detailnoflag']").each(function(){
					var detailno = jQuery(this).val();
					jQuery("#dtotTR"+detailno).hide();
					jQuery("#dtucTR"+detailno).hide();
				});
			}
		}
		if(maintableopttype=="3"){
			var url = "/formmode/interfaces/WorkflowToModeSetOperation.jsp";
			var formtypevalue = jQuery("#formtype").val();
			if(!formtypevalue) {
				formtypevalue='<%=formtype%>';
			}
     		jQuery.ajax({
         		url : url,
         		type : "post",
         		processData : false,
         		data : "operation=getBaseField&wfformid=<%=wfformid%>&formtype="+formtypevalue+"&basedfield=<%=basedfield%>",
         		dataType : "json",
         		async : true,
         		success: function do4Success(msg){
         			jQuery("#div_basedfield").html( msg.basedfieldhtml);
         			var targetObj = document.getElementById("basedfield");
         			targetObj.style.width = '100px';
         			beautySelect(targetObj);
         			initSbSelectorStyle()
         		}
     		});
     		jQuery("#div_basedfield").show();
			jQuery("#basedfieldDescTR").show();
		}else{
			jQuery("#div_basedfield").hide();
			jQuery("#basedfieldDescTR").hide();
		}
	}
	function changeformtype(){
		var maintableopttype = $("#maintableopttype").val();
		
		if(maintableopttype=="3"){
			jQuery("#basedfieldTR").closest("tr").show();
			var url = "/formmode/interfaces/WorkflowToModeSetOperation.jsp";
     		jQuery.ajax({
         		url : url,
         		type : "post",
         		processData : false,
         		data : "operation=getBaseField&type=true&wfformid=<%=wfformid%>&formtype="+jQuery("#formtype").val()+"&basedfield=<%=basedfield%>",
         		dataType : "json",
         		async : true,
         		success: function do4Success(msg){
         			jQuery("#div_basedfield").html( msg.basedfieldhtml);
         			var targetObj = document.getElementById("basedfield");
         			targetObj.style.width = '100px';
         			beautySelect(targetObj);
         			initSbSelectorStyle()
         		}
     		});
			
		}
	}
	function changeDetailtableopttype(obj,detailno){
		var dtucTR = jQuery("#dtucTR"+detailno);
		if(obj.value=="3"||obj.value=="4"){
			dtucTR.show();
		}else{
			dtucTR.hide();
		}
	}
	
	function initSbSelectorStyle(){
		var basefield = jQuery("#basedfield").val();
		jQuery(".e8_tbl_detail").find("option[value='"+basefield+"']").each(function(){
			var parSelectObj = jQuery(this).parent().get(0);
			changWffieldStyle(parSelectObj);
		});
	}
	
	function changWffieldStyle(obj){
		var $select = jQuery(obj);
		var option_basefield = jQuery("#basedfield").find("option:selected");
		var basedfieldText = option_basefield.text();
		var ismultibrowser = option_basefield.attr("ismultibrowser");
		var sb = $select.attr("sb");
		var $sbSelector = jQuery("#sbSelector_"+sb);
		var selectText = $select.find("option:selected").text();
		var $modefield = $select.closest("tr").find("input[type='hidden'][name^='modefieldid']");
		var issinglebrowser = $modefield.attr("issinglebrowser");
		if(ismultibrowser == "true" && issinglebrowser=="true" && selectText==basedfieldText){
			$sbSelector.addClass("sbSelectorRed");
		}else{
			$sbSelector.removeClass("sbSelectorRed");
		}
	}
	
	function changeTriMethod(v) {
		if (v == 1) { //节点触发
			jQuery("#nodesDiv1").show();
			jQuery("#nodesDiv2").show();
			jQuery("#exportDiv").hide();
		} else if (v == 2) { //出口触发
			jQuery("#nodesDiv1").hide();
			jQuery("#nodesDiv2").hide();
			jQuery("#exportDiv").show();
		}
	}
	
	function setWhereCondtion(o, m_fieldname, detailno) {
		var T = <%=isdetailform%>; //是否来自明细表触发
		if (detailno == 0) {
			if (parseInt($(o).val()) == -2 && !T) { //当前是请求id，判断其它选项有没有选择过了，如果有选择过，不给选择
				$("select[name=wffieldid0]").each(function(){
					if (o != this && parseInt($(this).val()) == -2) { 
						alert("<%=SystemEnv.getHtmlLabelName(127810,user.getLanguage())%>"); //模塊字段不能對應多次請求ID
						jQuery(o).parent().find("select[ishide!='1']").val("");
					    jQuery(o).parent().find("a[class='sbSelector']").html("");
					    jQuery(o).val("0");
					}
				});
			}
			if (parseInt($(o).val()) < -3 && T) {
				$("select[name=wffieldid0]").each(function(){
					if (o != this && parseInt($(this).val()) < -3) { 
						alert("<%=SystemEnv.getHtmlLabelName(127811,user.getLanguage())%>");//模块字段不能对应多次明细ID
						jQuery(o).parent().find("select[ishide!='1']").val("");
					    jQuery(o).parent().find("a[class='sbSelector']").html("");
					    jQuery(o).val("0");
					}
				});
			}
			if (parseInt($(o).val()) == -2 && T) {
				$("select[name=wffieldid0]").each(function(){
					if (o != this && parseInt($(this).val()) == -2) { 
						alert("<%=SystemEnv.getHtmlLabelName(127810,user.getLanguage())%>"); //模塊字段不能對應多次請求ID
						jQuery(o).parent().find("select[ishide!='1']").val("");
					    jQuery(o).parent().find("a[class='sbSelector']").html("");
					    jQuery(o).val("0");
					}
				});
			}
			
		} else if (detailno > 0) {
			if (parseInt($(o).val()) < -3) { //当前是明细id，判断其它选项有没有选择过了，如果有选择过，不给选择
				$("select[name=wffieldid"+detailno+"]").each(function(){
					if (o != this && parseInt($(this).val()) < -3) { 
						alert("<%=SystemEnv.getHtmlLabelName(127811,user.getLanguage())%>");//模块字段不能对应多次明细ID
						jQuery(o).parent().find("select[ishide!='1']").val("");
					    jQuery(o).parent().find("a[class='sbSelector']").html("");
					    jQuery(o).val("0");
					}
				});
			}
		}
	}
</script>

</BODY></HTML>
