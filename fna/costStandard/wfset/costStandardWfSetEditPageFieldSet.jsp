<%@page import="weaver.fna.interfaces.thread.FnaThreadResult"%>
<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="weaver.fna.costStandard.CostStandard"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="weaver.fna.budget.FnaWfSet"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<%
if(!HrmUserVarify.checkUserRight("CostStandardProcedure:edit", user)){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}
CostStandard costStandard = new CostStandard();

String thisGuid = Util.null2String(request.getParameter("thisGuid"));

FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
boolean fnaBudgetOAOrg = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaBudgetOAOrg());
boolean fnaBudgetCostCenter = 1==Util.getIntValue(fnaSystemSetComInfo.get_fnaBudgetCostCenter());


String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";//费控流程 //33075
String needfav ="1";
String needhelp ="";

int detachable=Util.getIntValue(String.valueOf(session.getAttribute("detachable")),0);
int parentid=Util.getIntValue(request.getParameter("paraid"),0);

String nameQuery = Util.null2String(request.getParameter("nameQuery")).trim();

int mainId = Util.getIntValue(request.getParameter("id"));

int tabIndex = Util.getIntValue(request.getParameter("tabIndex"));


int workflowid = 0;
boolean enable = false;

String sql = "select * from fnaFeeWfInfoCostStandard where id = "+mainId;
rs.executeSql(sql);
if(rs.next()){
	workflowid = rs.getInt("workflowid");
	enable = 1==rs.getInt("enable");
}

List fieldIdListAll = new ArrayList();
HashMap fieldInfoHmAll = new HashMap();

List fieldIdListMain = new ArrayList();
HashMap fieldInfoHmMain = new HashMap();

List fieldIdListDt = new ArrayList();
HashMap fieldInfoHmDt = new HashMap();

FnaWfSet.getFieldListForFieldTypeMain(fieldIdListMain, fieldInfoHmMain, workflowid);
int formid = FnaWfSet.getFieldListForFieldTypeMain(fieldIdListAll, fieldInfoHmAll, workflowid);
int formidABS = Math.abs(formid);

String dbTableName = "formtable_main_"+formidABS;
sql = "select DISTINCT detailtable \n" +
	" from workflow_billfield \n" +
	" where detailtable = '"+StringEscapeUtils.escapeSql(dbTableName+"_dt"+tabIndex)+"' \n"+
	" order by detailtable asc";
rs.executeSql(sql);
if(rs.next()){
	String detailtable = Util.null2String(rs.getString("detailtable")).trim();
	int dtlNumber = Util.getIntValue(detailtable.replaceAll("formtable_main_"+formidABS+"_dt", ""), 0);
	
	dbTableName += "_dt"+tabIndex;
	
	FnaWfSet.getFieldListForFieldTypeDetail(fieldIdListAll, fieldInfoHmAll, workflowid, dtlNumber);
	FnaWfSet.getFieldListForFieldTypeDetail(fieldIdListDt, fieldInfoHmDt, workflowid, dtlNumber);
}

List tempFieldIdListAll = new ArrayList(); 
HashMap tempFieldInfoHmAll = new HashMap();
for(Object obj : fieldIdListAll){
	String _id = (String)obj;
	String _type = (String)fieldInfoHmAll.get(_id+"_type");
	
	
	
	//type是workflow_billfield里的浏览按钮类型
	//browsertype是费用标准编辑页面下拉框中的键值
	
	//单成本中心
	if("251".equals(_type)){
		_type = "99902";
	}
	//单科目
	if("22".equals(_type)){
		_type = "99901";
	}
	//单人员
	if("17".equals(_type)){
		_type = "0";
	}
	if("165".equals(_type) || "1".equals(_type)){
		_type = "17";
	}
	//单部门
	if("57".equals(_type)){
		_type = "0";
	}
	if("4".equals(_type)){
		_type = "57";
	}
	//单分部
	if("194".equals(_type)){
		_type = "0";
	}
	if("164".equals(_type)){
		_type = "194";
	}
	
	tempFieldIdListAll.add(_id);
	tempFieldInfoHmAll.put(_id+"_type", _type);
}


String sql_isNull = "ISNULL";
if("oracle".equalsIgnoreCase(rs.getDBType())){
	sql_isNull = "NVL";
}else if("mysql".equalsIgnoreCase(rs.getDBType())){
	sql_isNull = "ifNULL";
}

StringBuffer generateFieldPropertySQL = new StringBuffer();
%>
<html>
<head>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
</head>
<body style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
			+ ",javascript:doSave(),_self} ";//保存
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{" + SystemEnv.getHtmlLabelName(132224, user.getLanguage())
			+ ",javascript:generateFieldPropertySQL(),_self} ";//生成字段属性SQL
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<form action="">
<input id="mainId" name="mainId" value="<%=mainId %>" type="hidden" />
<input id="workflowid" name="workflowid" value="<%=workflowid %>" type="hidden" />
<input id="formid" name="formid" value="<%=formid %>" type="hidden" />
<input id="tabIndex" name=tabIndex value="<%=tabIndex %>" type="hidden" />
<wea:layout type="2col">
	
	<wea:group context='<%=dbTableName %>'>
<%

int fieldValType = 1;

String fieldId_csAmount = "";
String fieldId_costStandardC = "";

sql = "select * from fnaFeeWfInfoFieldCostStandard where mainId=? and tabIndex = ?";
rs1.executeQuery(sql, mainId, tabIndex);
while(rs1.next()){
	String fcsGuid1 = Util.null2String(rs1.getString("fcsGuid1")).trim();
	String fieldId = Util.null2String(rs1.getString("fieldId")).trim();
	if("csAmount".equals(fcsGuid1)){
		fieldId_csAmount = fieldId;
	}else if("costStandardC".equals(fcsGuid1)){
		fieldId_costStandardC = fieldId;
	}
}

String tempFieldId_csAmount = Util.null2String(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_csAmount"));
if(!"".equals(tempFieldId_csAmount)){
	fieldId_csAmount = tempFieldId_csAmount;
}
String tempFieldId_costStandardC = Util.null2String(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_costStandardC"));
if(!"".equals(tempFieldId_costStandardC)){
	fieldId_costStandardC = tempFieldId_costStandardC;
}


List _fyxeList = null;
HashMap _fyxeHm = null;

List fyxeList = new ArrayList();
HashMap fyxeHm = new HashMap();
if(tabIndex == 0){
	_fyxeList = fieldIdListMain;
	_fyxeHm = fieldInfoHmMain;
	
}else{
	_fyxeList = fieldIdListDt;
	_fyxeHm = fieldInfoHmDt;
}
for(Object obj : _fyxeList){
	String _id = (String)obj;
	
	//fieldhtmltype=1 单行文本框
	if("1".equals(fieldInfoHmAll.get(_id+"_fieldhtmltype"))){
		fyxeList.add(_id);
		
		fyxeHm.put(_id+"_fieldname", fieldInfoHmAll.get(_id+"_fieldname"));
		fyxeHm.put(_id+"_fieldlabel", fieldInfoHmAll.get(_id+"_fieldlabel"));
		fyxeHm.put(_id+"_viewtype", fieldInfoHmAll.get(_id+"_viewtype"));
		fyxeHm.put(_id+"_fieldhtmltype", fieldInfoHmAll.get(_id+"_fieldhtmltype"));
		fyxeHm.put(_id+"_type", fieldInfoHmAll.get(_id+"_type"));
		fyxeHm.put(_id+"_dsporder", fieldInfoHmAll.get(_id+"_dsporder"));
		fyxeHm.put(_id+"_detailtable", fieldInfoHmAll.get(_id+"_detailtable"));
	}
}
%>
		<wea:item><font style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(125609,user.getLanguage()) %></font></wea:item><!-- 费用限额 -->
		<wea:item>
			<%
				out.println(FnaWfSet.getSelect(fyxeList, fyxeHm, fieldId_csAmount, user, formid, "csAmount", true, -1, true, "width:380px;"));
			%>
		</wea:item>
		<wea:item><font style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(132218,user.getLanguage()) %></font></wea:item><!-- 费用标准系数 -->
		<wea:item>
			<%
				out.println(FnaWfSet.getSelect(fyxeList, fyxeHm, fieldId_costStandardC, user, formid, "costStandardC", true, -1, true, "width:380px;"));
			%>
			<img src="/wechat/images/remind_wev8.png" align="absMiddle" 
				title="<%=SystemEnv.getHtmlLabelName(382091,user.getLanguage()) %>" />
		</wea:item>
		<wea:item><font style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(85,user.getLanguage()) %></font></wea:item><!-- 说明  -->
		<wea:item>
			<font color="red">
				<%=SystemEnv.getHtmlLabelName(132219,user.getLanguage()) %>
			</font><br>
			<b>
				<%=SystemEnv.getHtmlLabelName(132220,user.getLanguage()) %><br>
				<%=SystemEnv.getHtmlLabelName(126476,user.getLanguage()) %>：FnaCostStandardCtrlAction<br>
				<%=SystemEnv.getHtmlLabelName(126478,user.getLanguage()) %>：FnaCostStandardCtrlAction<br>
				<%=SystemEnv.getHtmlLabelName(126479,user.getLanguage()) %>：weaver.interfaces.workflow.action.FnaCostStandardCtrlAction
			</b>
		</wea:item>
<%
int trIdx = -1;
sql = "select * \n" +
		" from FnaCostStandard a \n" +
		" where a.enabled = ? \n" +
		" order by a.orderNumber, a.name ";
rs.executeQuery(sql, 1);
while(rs.next()){
	trIdx++;
	
	String fcsGuid1 = Util.null2String(rs.getString("guid1"));
	String name = Util.null2String(rs.getString("name"));
	String compareoption1 = Util.null2String(rs.getString("compareoption1"));
	int paramtype = Util.getIntValue(rs.getString("paramtype"), -1);
	int browsertype = Util.getIntValue(rs.getString("browsertype"), -1);
	String definebroswerType = Util.null2String(rs.getString("definebroswerType"));
	if("".equals(definebroswerType)){
		definebroswerType = " ";
	}

	fieldValType = 1;
	String fieldId = "";
	String fieldValue = "";
	String fieldValueWfSys = "";

	sql = "select * from fnaFeeWfInfoFieldCostStandard where mainId="+mainId+" and fcsGuid1='"+StringEscapeUtils.escapeSql(fcsGuid1)+"' and tabIndex = " + tabIndex;
	rs1.executeSql(sql);
	if(rs1.next()){
		fieldValType = rs1.getInt("fieldValType");
		fieldId = Util.null2String(rs1.getString("fieldId"));
		fieldValue = Util.null2String(rs1.getString("fieldValue"));
		fieldValueWfSys = Util.null2String(rs1.getString("fieldValueWfSys"));
	}
	
	if(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid1+"_fieldValType") != null){
		fieldValType = Util.getIntValue(Util.null2String(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid1+"_fieldValType")), 0);
	}
	if(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid1+"_fieldId") != null){
		fieldId = Util.null2String(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid1+"_fieldId"));
	}
	if(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid1+"_fieldValue") != null){
		fieldValue = Util.null2String(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid1+"_fieldValue"));
	}
	if(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid1+"_fieldValueWfSys") != null){
		fieldValueWfSys = Util.null2String(request.getSession().getAttribute("costStandardWfSetEditSaveFnaAjax_"+thisGuid+"_"+tabIndex+"_"+fcsGuid1+"_fieldValueWfSys"));
	}
	
	String sel_display = "";
	String txt_display = "display: none;";
	String wfSys_display = "display: none;";
	if(fieldValType==2){
		sel_display = "display: none;";
		txt_display = "";
		wfSys_display = "display: none;";
	}else if(fieldValType==3){
		sel_display = "display: none;";
		txt_display = "display: none;";
		wfSys_display = "";
	}
%>
		<wea:item>
			<font style="font-weight: bold;"><%=FnaCommon.escapeHtml(name) %></font><!-- 费用标准维度 -->
<%
String compareoption1Name = "";
if("1".equals(compareoption1)){
	compareoption1Name = SystemEnv.getHtmlLabelName(15508,user.getLanguage());//大于
}else if("2".equals(compareoption1)){
	compareoption1Name = SystemEnv.getHtmlLabelName(325,user.getLanguage());//大于或等于
}else if("3".equals(compareoption1)){
	compareoption1Name = SystemEnv.getHtmlLabelName(15509,user.getLanguage());//小于
}else if("4".equals(compareoption1)){
	compareoption1Name = SystemEnv.getHtmlLabelName(326,user.getLanguage());//小于或等于
}else if("5".equals(compareoption1)){
	compareoption1Name = SystemEnv.getHtmlLabelName(327,user.getLanguage());//等于
}else if("6".equals(compareoption1)){
	compareoption1Name = SystemEnv.getHtmlLabelName(15506,user.getLanguage());//不等于
}else if("7".equals(compareoption1)){
	compareoption1Name = SystemEnv.getHtmlLabelName(353,user.getLanguage());//属于
}else if("8".equals(compareoption1)){
	compareoption1Name = SystemEnv.getHtmlLabelName(21473,user.getLanguage());//不属于
}else if("9".equals(compareoption1)){
	compareoption1Name = SystemEnv.getHtmlLabelName(346,user.getLanguage());//包含
}else if("10".equals(compareoption1)){
	compareoption1Name = SystemEnv.getHtmlLabelName(15507,user.getLanguage());//不包含
}else if("11".equals(compareoption1)){
	compareoption1Name = SystemEnv.getHtmlLabelName(82763,user.getLanguage());//属于（含下级）
}else if("12".equals(compareoption1)){
	compareoption1Name = SystemEnv.getHtmlLabelName(82764,user.getLanguage());//不属于（含下级）
}
%>
			（<%=FnaCommon.escapeHtml(compareoption1Name) %>）
		</wea:item>
		<wea:item>
			<select id="<%="s_"+fcsGuid1 %>" name="<%="s_"+fcsGuid1 %>" onchange="selFcsGuid_onchange('<%=fcsGuid1 %>');" style="float: left;">
				<option value="1" <%=fieldValType==1?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(700,user.getLanguage()) %></option><!-- 表单字段 -->
				<!-- <option value="2" <%=fieldValType==2?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(17088,user.getLanguage()) %></option> --><!-- 自定义信息 -->
				<!-- <option value="3" <%=fieldValType==3?"selected=\"selected\"":"" %>><%=SystemEnv.getHtmlLabelName(125676,user.getLanguage()) %></option> --><!-- 流程默认参数 -->
			</select>
			<span id="<%="sel_"+fcsGuid1 %>" style="float: left;<%=sel_display %>">&nbsp;
				<%
					
					String sql_sel = "select * from FnaCostStandard where guid1 = '"+fcsGuid1+"' ";
					rs1.executeSql(sql_sel);
					if(rs1.next()){
						int paramtype_sel = Util.getIntValue(rs1.getString("paramtype"), -1);
						
						List _fieldIdListAll = new ArrayList();
						HashMap _fieldInfoHmAll = new HashMap();
						
						
						if(paramtype_sel==0 || paramtype_sel==1 || paramtype_sel==2){
							for(Object obj : fieldIdListAll){
								String _id = (String)obj;
								String _fieldhtmltype = (String)fieldInfoHmAll.get(_id+"_fieldhtmltype");
								
								//fieldhtmltype=1 单行文本框
								if("1".equals(_fieldhtmltype) || "5".equals(_fieldhtmltype)){
									_fieldIdListAll.add(_id);
									
									_fieldInfoHmAll.put(_id+"_fieldname", fieldInfoHmAll.get(_id+"_fieldname"));
									_fieldInfoHmAll.put(_id+"_fieldlabel", fieldInfoHmAll.get(_id+"_fieldlabel"));
									_fieldInfoHmAll.put(_id+"_viewtype", fieldInfoHmAll.get(_id+"_viewtype"));
									_fieldInfoHmAll.put(_id+"_fieldhtmltype", fieldInfoHmAll.get(_id+"_fieldhtmltype"));
									_fieldInfoHmAll.put(_id+"_type", fieldInfoHmAll.get(_id+"_type"));
									_fieldInfoHmAll.put(_id+"_dsporder", fieldInfoHmAll.get(_id+"_dsporder"));
									_fieldInfoHmAll.put(_id+"_detailtable", fieldInfoHmAll.get(_id+"_detailtable"));
								}
							}
						}else if(paramtype_sel == 3){
							String _browsertype = Util.null2String(rs1.getString("browsertype"));
							
							for(Object obj : tempFieldIdListAll){
								String _id = (String)obj;
								
								String _type = (String)tempFieldInfoHmAll.get(_id+"_type");
								
								//fieldhtmltype=3 浏览按钮
								if("3".equals(fieldInfoHmAll.get(_id+"_fieldhtmltype"))
									&&	_browsertype.equals(_type)){
									_fieldIdListAll.add(_id);
									
									_fieldInfoHmAll.put(_id+"_fieldname", fieldInfoHmAll.get(_id+"_fieldname"));
									_fieldInfoHmAll.put(_id+"_fieldlabel", fieldInfoHmAll.get(_id+"_fieldlabel"));
									_fieldInfoHmAll.put(_id+"_viewtype", fieldInfoHmAll.get(_id+"_viewtype"));
									_fieldInfoHmAll.put(_id+"_fieldhtmltype", fieldInfoHmAll.get(_id+"_fieldhtmltype"));
									_fieldInfoHmAll.put(_id+"_type", _type);
									_fieldInfoHmAll.put(_id+"_dsporder", fieldInfoHmAll.get(_id+"_dsporder"));
									_fieldInfoHmAll.put(_id+"_detailtable", fieldInfoHmAll.get(_id+"_detailtable"));
								}
							}
						}else if(paramtype_sel == -1){
							_fieldIdListAll = fieldIdListAll;
							_fieldInfoHmAll = fieldInfoHmAll;
						}
						
						out.println(FnaWfSet.getSelect(_fieldIdListAll, _fieldInfoHmAll, fieldId, user, formid, "vSel_"+fcsGuid1, true, -1, true, "width:380px;"));
					}else{
						out.println(FnaWfSet.getSelect(fieldIdListAll, fieldInfoHmAll, fieldId, user, formid, "vSel_"+fcsGuid1, true, -1, true, "width:380px;"));
					}
					
					if(Util.getIntValue(fieldId) > 0){
						generateFieldPropertySQL.append("        ").append(costStandard.getCostStandardClause(paramtype, Util.getIntValue(compareoption1), fcsGuid1, "$"+fieldId+"$")).append("\n");
					}
				%>
			</span>
			<span id="<%="txt_"+fcsGuid1 %>" style="float: left;<%=txt_display %>">
				<span style="float: left;">&nbsp;&nbsp;</span>
			<%if(paramtype == 0 || paramtype == 1 || paramtype == 2){ %>
				<input id="<%="vIpt_"+fcsGuid1 %>" name="<%="vIpt_"+fcsGuid1 %>" 
					value="<%=FnaCommon.escapeHtml(fieldValue) %>" 
					style="width:402px;" class="inputstyle" />
			<%}else if(paramtype == 3){ %>
				<%=costStandard.getEdit(fieldValue, "vIpt_"+fcsGuid1+"+"+paramtype+"+"+browsertype+"+"+definebroswerType+"+ +"+user.getLanguage()+"+384px+1") %>
			<%} %>
			</span>
			<span id="<%="wfSys_"+fcsGuid1 %>" style="float: left;<%=wfSys_display %>">&nbsp;
				<select id="<%="vWfSys_"+fcsGuid1 %>" name="<%="vWfSys_"+fcsGuid1 %>" style="width:379px;">
					<option value="1" <%=Util.getIntValue(fieldValueWfSys)==1?"selected=\"selected\"":"" %>>
						<%=SystemEnv.getHtmlLabelName(28595,user.getLanguage()) %>-<%=SystemEnv.getHtmlLabelName(413,user.getLanguage()) %></option><!-- 姓名 -->
					<option value="2" <%=Util.getIntValue(fieldValueWfSys)==2?"selected=\"selected\"":"" %>>
						<%=SystemEnv.getHtmlLabelName(28595,user.getLanguage()) %>-<%=SystemEnv.getHtmlLabelName(1933,user.getLanguage()) %></option><!-- 工号 -->
					<option value="3" <%=Util.getIntValue(fieldValueWfSys)==3?"selected=\"selected\"":"" %>>
						<%=SystemEnv.getHtmlLabelName(28595,user.getLanguage()) %>-<%=SystemEnv.getHtmlLabelName(683,user.getLanguage()) %></option><!-- 安全级别 -->
					<option value="4" <%=Util.getIntValue(fieldValueWfSys)==4?"selected=\"selected\"":"" %>>
						<%=SystemEnv.getHtmlLabelName(28595,user.getLanguage()) %>-<%=SystemEnv.getHtmlLabelName(15390,user.getLanguage()) %></option><!-- 部门名称 -->
					<option value="5" <%=Util.getIntValue(fieldValueWfSys)==5?"selected=\"selected\"":"" %>>
						<%=SystemEnv.getHtmlLabelName(28595,user.getLanguage()) %>-<%=SystemEnv.getHtmlLabelName(22806,user.getLanguage()) %></option><!-- 部门编码 -->
					<option value="6" <%=Util.getIntValue(fieldValueWfSys)==6?"selected=\"selected\"":"" %>>
						<%=SystemEnv.getHtmlLabelName(28595,user.getLanguage()) %>-<%=SystemEnv.getHtmlLabelName(1878,user.getLanguage()) %></option><!-- 分部名称 -->
					<option value="7" <%=Util.getIntValue(fieldValueWfSys)==7?"selected=\"selected\"":"" %>>
						<%=SystemEnv.getHtmlLabelName(28595,user.getLanguage()) %>-<%=SystemEnv.getHtmlLabelName(22809,user.getLanguage()) %></option><!-- 分部编码 -->
				</select>
			</span>
		</wea:item>
<%
}
%>
	</wea:group>
</wea:layout>
</form>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
<wea:layout needImportDefaultJsAndCss="false">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
    	<wea:item type="toolbar">
    		<input class="zd_btn_cancle" type="submit" id="btnClose" onclick="onCancel();" 
    			value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/><!-- 取消 -->
    	</wea:item>
    </wea:group>
</wea:layout>
<%if(generateFieldPropertySQL.length() > 0){
	String key_generateFieldPropertySQL_full = FnaCommon.getPrimaryKeyGuid1()+";generateFieldPropertySQL_full";
	String generateFieldPropertySQL_full = "    select max("+sql_isNull+"(fcsd.csAmount, 0.0)) maxCsAmount from FnaCostStandardDefi fcsd where 1=1 \n"+generateFieldPropertySQL.toString();
	FnaThreadResult fnaThreadResult = new FnaThreadResult();
	fnaThreadResult.removeInfoByInfoKey(key_generateFieldPropertySQL_full, "generateFieldPropertySQL_full");
	fnaThreadResult.setInfoByInfoKey(key_generateFieldPropertySQL_full, "generateFieldPropertySQL_full", "doFieldSQL(\"\n "+generateFieldPropertySQL_full+" \") ");
%>
<input id="key_generateFieldPropertySQL_full" value="<%=key_generateFieldPropertySQL_full %>" type="hidden" />
<textarea id="textareaFnaCostStandardDefi" cols="100" rows="20" style="display: none;"><%=generateFieldPropertySQL_full %></textarea>
<%} %>
</div>

<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...


jQuery(document).ready(function(){
	resizeDialog(document);
});

function selFcsGuid_onchange(fcsGuid1){
	var _s_val = jQuery("#s_"+fcsGuid1).val();
	if(_s_val=="1"){
		jQuery("#sel_"+fcsGuid1).show();
		jQuery("#txt_"+fcsGuid1).hide();
		jQuery("#wfSys_"+fcsGuid1).hide();
	}else if(_s_val=="2"){
		jQuery("#sel_"+fcsGuid1).hide();
		jQuery("#txt_"+fcsGuid1).show();
		jQuery("#wfSys_"+fcsGuid1).hide();
	}else if(_s_val=="3"){
		jQuery("#sel_"+fcsGuid1).hide();
		jQuery("#txt_"+fcsGuid1).hide();
		jQuery("#wfSys_"+fcsGuid1).show();
	}
}

//快速（高级）搜索事件
function onBtnSearchClick(){
}

//生成字段属性SQL
function generateFieldPropertySQL(){
	window.parent.generateFieldPropertySQL();
}

//保存
function doSave(){
	window.parent.doSave1(true);
}

//保存
function doSave2(){
	var mainId = null2String(jQuery("#mainId").val());
	var workflowid = null2String(jQuery("#workflowid").val());
	var formid = null2String(jQuery("#formid").val());
	
	jQuery.ajax({
		url : "/fna/costStandard/wfset/costStandardWfSetEditCheckFnaAjax.jsp",
		type : "post",
		cache : false,
		processData : false,
		async:false,
		data : "thisGuid=<%=thisGuid%>&formid=<%=formid%>",
		dataType : "json",
		success: function do4Success(_json){
		    try{
		    	if(!_json.flag){
		    		alert(_json.errorInfo);
		    	}else{
		    		try{
		    			//确定要保存么？
		    			top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(32130,user.getLanguage()) %>",
		    				function(){
		    					hideRightMenuIframe();
		    					var _data = "operation=editFieldSet&mainId="+mainId+"&workflowid="+workflowid+"&formid="+formid+"&thisGuid=<%=thisGuid%>&r=1";
		    				
		    					openNewDiv_FnaBudgetViewInner1(_Label33574);
		    					jQuery.ajax({
		    						url : "/fna/costStandard/wfset/costStandardWfSetEditOp.jsp",
		    						type : "post",
		    						cache : false,
		    						processData : false,
		    						data : _data,
		    						dataType : "json",
		    						success: function do4Success(_json){
		    						    try{
		    								try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
		    								if(_json.flag){
		    									//var parentWin = parent.parent.getParentWindow(parent.window);
		    									//onCancel2();
		    									top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(18758,user.getLanguage()) %>");//保存成功
		    								}else{
		    									top.Dialog.alert(_json.msg);
		    								}
		    			
		    						    	showRightMenuIframe();
		    						    }catch(e1){
		    						    	showRightMenuIframe();
		    						    }
		    						}
		    					});	
		    				},
		    				function(){}
		    			);
		    		}catch(e1){
		    			showRightMenuIframe();
		    		}
		    	}
		    	
		    }catch(e1){}
		}
	});	
	
	
}

function onShowdate_fna(spanname,inputname){
	var returnvalue;
	var oncleaingFun = function(){
		$ele4p(spanname).innerHTML = ""; 
		$ele4p(inputname).value = '';
	}
	WdatePicker({lang:languageStr,el:spanname,onpicked:function(dp){
		returnvalue = dp.cal.getDateStr();	
		$dp.$(spanname).innerHTML = returnvalue;
		$dp.$(inputname).value = returnvalue;},oncleared:oncleaingFun
	});
	var hidename = $ele4p(inputname).value;
	if(hidename != ""){
		$ele4p(inputname).value = hidename; 
		$ele4p(spanname).innerHTML = hidename;
	}else{
		$ele4p(spanname).innerHTML = "";
	}
}

function onCancel(){
	var dialog = parent.parent.parent.getDialog(parent.parent.window);	
	dialog.closeByHand();
}

function onCancel2(){
	parent.parent.onCancel();
}

function _brow_callback(){
}

</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>

</body>
</html>
