<%@page import="weaver.workflow.workflow.WorkflowVersion"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.fna.general.FnaBudgetLeftRuleSet"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.systeminfo.label.LabelComInfo"%>
<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@ page import="weaver.general.Util" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs2" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs3" class="weaver.conn.RecordSet" scope="page" />

<%@ page import="weaver.systeminfo.label.LabelComInfo"%>

<%!

private String getActionSetNodeIds(int workflowid, int isnode, int ispreadd, String interfaceid){
	RecordSet rs0 = new RecordSet();
	RecordSet rs1 = new RecordSet();
	StringBuffer nodeIds = new StringBuffer();
	List nodeIdsList = new ArrayList();
	String actionErrorSql = "select a.nodeid, a.nodelinkid " +
			" from workflowactionset a " +
			" where a.interfacetype = 3 and a.isused = 1 " +
			" and a.workflowid="+workflowid+" " +
//TODO ispreoperator=1表示节点前action
			//" and a.ispreoperator=1 " +
			" and a.interfaceid = '"+interfaceid+"'";
	rs1.executeSql(actionErrorSql);
	while(rs1.next()){
		int nodeid = rs1.getInt("nodeid");
		int nodelinkid = rs1.getInt("nodelinkid");
		
		int objid = 0;
		if(isnode==1){
			objid = nodeid;
		}else{
			objid = nodelinkid;
		}
		
		if(objid > 0 && !nodeIdsList.contains(objid+"")){
			nodeIdsList.add(objid+"");
			if(nodeIds.length() > 0){
				nodeIds.append(",");
			}
			nodeIds.append(objid);
		}
	}
	
	return  nodeIds.toString();
}
 %>

<%

String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = "";//通用设置
String needfav ="1";
String needhelp ="";



%>
<html>
<head>
<link type="text/css" rel="stylesheet" href="/css/Weaver_wev8.css">
<link type="text/css" rel="stylesheet" href="/appres/hrm/css/mfcommon_wev8.css">
<script type="text/javascript" src="/appres/hrm/js/mfcommon_wev8.js"></script>
<script type="text/javascript" src="/js/weaver_wev8.js"></script>
<script type="text/javascript" src="/js/ecology8/hrm/HrmSearchInit_wev8.js"></script>
<script type="text/javascript" defer="defer" src="/js/datetime_wev8.js"></script>
<script type="text/javascript" defer="defer" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=3"></script>
<style type="text/css">
.exceptionimg{
	position: absolute;
	overflow: scroll;
	background-color: white;
	display: none;
}
</style>
</head>
<body>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{重新检查,javascript:doRefresh(),_self}";
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{使用说明,javascript:doHelp1(),_self}";
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{异常信息说明,javascript:exception(),_self}";
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
	<div class="exceptionimg" id="exceptionimg" >
		<img src="exception/0.png" />
		<img src="exception/1.png" />
		<img src="exception/2.png" />
		<img src="exception/10.png" />
		<img src="exception/1.png" />
		<img src="exception/11.png" />
		<img src="exception/20.png" />
		<img src="exception/1.png" />
		<img src="exception/21.png" />
		<img src="exception/30.png" />
		<img src="exception/1.png" />
		<img src="exception/31.png" />
		<img src="exception/32.png" />
		<img src="exception/33.png" />
		<img src="exception/34.png" />
		<img src="exception/40.png" />
		<img src="exception/32.png" />
		<img src="exception/41.png" />
		<img src="exception/42.png" />
		<!-- 
		<img src="exception/50.png" />
		 -->
	</div>
<form id="form2" name="form2" method="post" action="">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="重新检查" 
				class="e8_btn_top" onclick="doRefresh();"/>
			<input type="button" value="使用说明" 
				class="e8_btn_top" onclick="doHelp1();"/>
			<input type="button" value="异常信息说明" 
				class="e8_btn_top" onclick="exception();"/>
			&nbsp;&nbsp;&nbsp;
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span><!-- 菜单 -->
		</td>
	</tr>
</table>

<%

String brStr = " ";
StringBuffer tableSql = new StringBuffer();
int orderByIdx = 0;

String sql = "select * from (select a.id,a.field005,a.field006,a.field004, a.field001, b.formid, b.workflowname, b.custompage, b.custompage4Emoble,b.version, " +
		"  (CASE WHEN (b.version is null or b.version = '') THEN 1 ELSE b.version END) versionName from hrm_att_proc_set a " +
		" join workflow_base b on a.field001 = b.id  ) a  where 1 = 1 and field006 = 4 "+
		" ORDER BY workflowname, (CASE WHEN (version is null or version = '') THEN 1 ELSE version END) ";
	
rs.executeSql(sql);
while(rs.next()){
	int mainId = rs.getInt("id");
	int workflowid = rs.getInt("field001");
	int formid = rs.getInt("formid");
	int field004 = rs.getInt("field004");
	String workflowname = Util.null2String(rs.getString("workflowname")).trim();
	String custompage = Util.null2String(rs.getString("custompage")).trim();
	String custompage4Emoble = Util.null2String(rs.getString("custompage4Emoble")).trim();
	String versionName = Util.null2String(rs.getString("versionName")).trim();
	
	String versionStringByWfid = WorkflowVersion.getVersionStringByWfid(workflowid+"");
	StringBuffer versionErrorString = new StringBuffer();
	rs1.executeSql("select DISTINCT a.id, \n" +
			"  (CASE WHEN (a.version is null or a.version = '') THEN 1 ELSE a.version END) versionName \n" +
			" from workflow_base a \n" +
			" where not EXISTS (select 1 from hrm_att_proc_set b where a.id = b.field001) \n" +
			" and a.id in ("+versionStringByWfid+")");
	while(rs1.next()){
		String _versionName = Util.null2String(rs1.getString("versionName")).trim();
		if(versionErrorString.length() > 0){
			versionErrorString.append("、");
		}
		versionErrorString.append("V"+_versionName);
	}
	
	StringBuffer fieldErrorString = new StringBuffer();
	Map<String,String> mapCurFields = new HashMap<String,String>();
	int otype_min_selectvalue = -1;
	int otype_max_selectvalue = -1;
	//当前的流程的考勤对应字段的配置
	String fieldresourceId   ="";
	String fielddepartmentId ="";
	String fieldfromdate     ="";
	String fieldfromtime     ="";
	String fieldtilldate     ="";
	String fieldtilltime     ="";
	String fieldotype        ="";
	String fieldovertimeDays ="";
	String curFiledSql = "select b.mfid,a.field003 from hrm_att_proc_relation a left join hrm_att_proc_fields b on a.field002=b.id where a.field001="+mainId;
	rs2.executeSql(curFiledSql);
	while(rs2.next()){
		mapCurFields.put(rs2.getString("mfid"),rs2.getString("field003"));
	}
	
	if(mapCurFields == null || mapCurFields.isEmpty()){
		fieldErrorString.append("考勤字段没有对应");
	}else{
		if(mapCurFields.get("31") == null){
			fieldErrorString.append(SystemEnv.getHtmlLabelName(413,user.getLanguage())+"没有对应!");
		}
		if(mapCurFields.get("32") == null){
			fieldErrorString.append(SystemEnv.getHtmlLabelName(18939,user.getLanguage())+"没有对应!");
		}
		if(mapCurFields.get("33") == null){
			fieldErrorString.append(SystemEnv.getHtmlLabelNames("1322",user.getLanguage())+"没有对应!");
		}
		if(mapCurFields.get("34") == null){
			fieldErrorString.append(SystemEnv.getHtmlLabelNames("17690",user.getLanguage())+"没有对应!");
		}
		if(mapCurFields.get("35") == null){
			fieldErrorString.append(SystemEnv.getHtmlLabelNames("741",user.getLanguage())+"没有对应!");
		}
		if(mapCurFields.get("36") == null){
			fieldErrorString.append(SystemEnv.getHtmlLabelNames("743",user.getLanguage())+"没有对应!");
		}
		if(fieldErrorString.length() > 0){
			fieldErrorString.insert(0,"考勤字段对应有误:");
		}
	}
	
	
	int resourceId_ismandatory_nodeType0    =0;
	int departmentId_ismandatory_nodeType0  =0;
	int fromdate_ismandatory_nodeType0      =0;
	int fromtime_ismandatory_nodeType0        =0;
	int tilldate_ismandatory_nodeType0        =0;
	int tilltime_ismandatory_nodeType0        =0;

	int resourceId_type = 0;
	int departmentId_type = 0;
	
	int fromDate_type = 0;
	int fromTime_type = 0;
	int toDate_type = 0;
	int toTime_type = 0;
	

	String fieldMustSql = "select e.isview, e.isedit, e.ismandatory, f.field003,d.type \n" +
			" from workflow_nodebase a \n" +
			" join workflow_nodelink b on a.id = b.nodeid \n" +
			" join hrm_att_proc_set c on b.workflowid = c.field001 \n" +
			" join hrm_att_proc_relation f on f.field001 = c.id \n" +
			" join workflow_billfield d on f.field003 = d.id \n" +
			" join workflow_nodeform e on e.nodeid = b.nodeid and f.field003 = e.fieldid \n" +
			" where a.isstart = '1' \n" +
			" and b.workflowid = "+workflowid;
	
	rs1.executeSql(fieldMustSql);
	while(rs1.next()){
	
		int isedit = rs1.getInt("isedit");
		int ismandatory = rs1.getInt("ismandatory");
		int fieldId = rs1.getInt("field003");
		int fieldtype = rs1.getInt("type");

		if(mapCurFields != null && !mapCurFields.isEmpty()){
			if(mapCurFields.get("31") != null && mapCurFields.get("31").equals(""+fieldId) ){
				if(ismandatory==1){
					resourceId_ismandatory_nodeType0 = 2;
				}else if(isedit==1){
					resourceId_ismandatory_nodeType0 = 1;
				}
				if(fieldtype != 1){
					resourceId_type = -1;
				}
			}
			if(mapCurFields.get("32") != null && mapCurFields.get("32").equals(""+fieldId) ){
				if(ismandatory==1){
					departmentId_ismandatory_nodeType0 = 2;
				}else if(isedit==1){
					departmentId_ismandatory_nodeType0 = 1;
				}
				if(fieldtype != 4){
					departmentId_type = -1;
				}
			}
			if(mapCurFields.get("33") != null && mapCurFields.get("33").equals(""+fieldId) ){
				if(ismandatory==1){
					fromdate_ismandatory_nodeType0 = 2;
				}else if(isedit==1){
					fromdate_ismandatory_nodeType0 = 1;
				}
				if(fieldtype != 2){
					fromDate_type = -1;
				}
			}
			if(mapCurFields.get("34") != null && mapCurFields.get("34").equals(""+fieldId) ){
				if(ismandatory==1){
					fromtime_ismandatory_nodeType0 = 2;
				}else if(isedit==1){
					fromtime_ismandatory_nodeType0 = 1;
				}
				if(fieldtype != 19){
					fromTime_type = -1;
				}
			}
			if(mapCurFields.get("35") != null && mapCurFields.get("35").equals(""+fieldId) ){
				if(ismandatory==1){
					tilldate_ismandatory_nodeType0 = 2;
				}else if(isedit==1){
					tilldate_ismandatory_nodeType0 = 1;
				}
				if(fieldtype != 2){
					toDate_type = -1;
				}
			}
			if(mapCurFields.get("36") != null && mapCurFields.get("36").equals(""+fieldId) ){
				if(ismandatory==1){
					tilltime_ismandatory_nodeType0 = 2;
				}else if(isedit==1){
					tilltime_ismandatory_nodeType0 = 1;
				}
				if(fieldtype != 19){
					toTime_type = -1;
				}
			}
		}
		
	}
	
	if(orderByIdx > 0){
		tableSql.append(" UNION ALL \n");
	}
	tableSql.append(" select "+mainId+" id, "+orderByIdx+" orderByIdx, "+workflowid+" workflowid, "+
		" '"+StringEscapeUtils.escapeSql(workflowname)+"' workflowname, '"+StringEscapeUtils.escapeSql(versionName)+"' versionName");

	tableSql.append(", '");
	
	if(versionErrorString.length() > 0){
		tableSql.append("当前流程的以下版本未关联【异常考勤流程】"+versionErrorString.toString()+"，请检查！"+brStr);
	}
	if(fieldErrorString.length() > 0){
		tableSql.append(fieldErrorString+brStr);
	}
	
	if(resourceId_ismandatory_nodeType0!=2){
		tableSql.append("【姓名】必须是必填字段，请检查！"+brStr);
	}
	if(departmentId_ismandatory_nodeType0!=2){
		tableSql.append("【部门】必须是必填字段，请检查！"+brStr);
	}
	if(fromdate_ismandatory_nodeType0 !=2){
		tableSql.append("【异常考勤开始日期】必须是必填字段，请检查！"+brStr);
	}
	if(fromtime_ismandatory_nodeType0 !=2){
		tableSql.append("【异常考勤开始时间】必须是必填字段，请检查！"+brStr);
	}
	if(tilldate_ismandatory_nodeType0 !=2){
		tableSql.append("【异常考勤结束日期】必须是必填字段，请检查！"+brStr);
	}
	if(tilltime_ismandatory_nodeType0 !=2){
		tableSql.append("【异常考勤结束时间】必须是必填字段，请检查！"+brStr);
	}	
	if(resourceId_type<0){
		tableSql.append("【姓名】必须是单人力浏览按钮，请检查！"+brStr);
	}
	if(departmentId_type<0){
		tableSql.append("【部门】必须是单部门浏览按钮，请检查！"+brStr);
	}
	//TODO  增加日期字段的校验
	if(fromDate_type <0 ){
		tableSql.append("【异常考勤开始日期】必须是日期类型，请检查！"+brStr);
	}
	if(fromTime_type <0 ){
		tableSql.append("【异常考勤开始时间】必须是时间类型，请检查！"+brStr);
	}
	if(toDate_type <0 ){
		tableSql.append("【异常考勤结束日期】必须是日期类型，请检查！"+brStr);
	}
	if(toTime_type <0 ){
		tableSql.append("【异常考勤结束时间】必须是时间类型，请检查！"+brStr);
	}
	if(mapCurFields.get("33") != null && mapCurFields.get("35") != null && (mapCurFields.get("33").equals(mapCurFields.get("35")) ) ){
		tableSql.append("【异常考勤开始日期】和【异常考勤结束日期】考勤字段对应的是同一个字段，请检查！"+brStr);
	}
	if(mapCurFields.get("34") != null && mapCurFields.get("36") != null && (mapCurFields.get("34").equals(mapCurFields.get("36")) ) ){
		tableSql.append("【异常考勤开始时间】和【异常考勤结束时间】考勤字段对应的是同一个字段，请检查！"+brStr);
	}
	tableSql.append("' errorInfo ");
	
	if("oracle".equalsIgnoreCase(rs.getDBType())){
		tableSql.append(" from dual \n");
	}
	
	orderByIdx++;
}
//设置好搜索条件
	String backFields =" a.* ";
	String fromSql = " from ("+tableSql.toString()+") a \r";
	String sqlWhere = " where 1=1 ";

	String orderBy = "(case when (errorInfo='' or errorInfo is null) then 1 else 0 end),a.orderByIdx";
	
	String sqlprimarykey = "a.id";
	
	//out.println("select "+backFields+" "+fromSql+" "+sqlWhere+" order by "+orderBy);
	
	String tableString=""+
       "<table instanceid=\"HRM_WF_SET_LIST_HRMSystemTestWfBorrow\" "+
      		" pagesize=\"10\" tabletype=\"none\">"+
       "<sql backfields=\""+Util.toHtmlForSplitPage(backFields)+"\" sqlform=\""+Util.toHtmlForSplitPage(fromSql)+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\" "+
       " sqlorderby=\""+Util.toHtmlForSplitPage(orderBy)+"\" "+
       " sqlprimarykey=\""+Util.toHtmlForSplitPage(sqlprimarykey)+"\" sqlsortway=\"asc\" />"+
       "<head>"+
			"<col width=\"15%\"  text=\""+SystemEnv.getHtmlLabelName(18104,user.getLanguage())+"\" column=\"workflowname\" "+//流程名称
     				" />"+
     		"<col width=\"2%\"  text=\""+SystemEnv.getHtmlLabelName(567,user.getLanguage())+"\" column=\"versionName\" "+//版本
					" />"+
			"<col width=\"75%\"  text=\"配置异常信息\" column=\"errorInfo\" "+
     				" transmethod=\"weaver.fna.general.FnaSplitPageTransmethod.doJsFunc\" otherpara=\"alert_grid+column:errorInfo\"/>"+
					" />"+
       "</head>"+
		"		<operates>"+
		"			<operate href=\"javascript:doEdit_grid();\" text=\""+SystemEnv.getHtmlLabelName(93,user.getLanguage())+"\" index=\"0\"/>"+//编辑
		"			<operate href=\"javascript:openWfEdit_grid();\" text=\""+SystemEnv.getHtmlLabelName(127107,user.getLanguage())+"\" otherpara=\"column:workflowid\" index=\"1\"/>"+//编辑路径
		"		</operates>"+
       "</table>";
%>
	<wea:layout type="1col">
		<wea:group context="" attributes="{'groupDisplay':'none'}">
			<wea:item attributes="{'isTableList':'true'}">
				<wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
			</wea:item>
		</wea:group>
	</wea:layout>
</form>


<script language="javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

function onBtnSearchClick(){}

function doHelp1(){
	window.location.href="/hrm/test/人力资源配置检查.docx";
}

function alert_grid(errorInfo){
	alert(errorInfo._fnaReplaceAll(" ", "\n"));
}

function doRefresh(){
	window.location.href="/hrm/test/HrmSystemTestWfBorrow4.jsp";
}
function exception(){
	if(document.getElementById("exceptionimg").style.display == "block"){
		document.getElementById("exceptionimg").style.display = "none";
	}else{
		document.getElementById("exceptionimg").style.display = "block";
	}
}

function gotoSet_onclick(_url){
	window.open(_url);
}

//基本信息
function doEdit_grid(id){
	showContent(id, null, null, 1);
}

var common = new MFCommon();
var dialog = null;

function closeDialog(){
	if(dialog) dialog.close();
}

function showContent(id, field006) {
	if(!id) id = "";
	if(field006 != "0" && !field006) field006 = "";
	closeDialog();
	dialog = common.showDialog("/hrm/attendance/hrmAttProcSet/tab.jsp?topage=content&subcompanyid=&isDialog=1&id="+id+"&field006="+field006, (id == "" ? "<%=SystemEnv.getHtmlLabelName(82,user.getLanguage())%>" : "<%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>") + "<%=SystemEnv.getHtmlLabelNames("15880,18015",user.getLanguage())%>");
}

function procSet(id, field001){
	if(field001 && field001 != ""){
		var url="/workflow/workflow/addwf.jsp?src=editwf&wfid="+field001+"&isTemplate=0&versionid_toXtree=1&from=prjwf&isdialog=1";
		common.showDialog(url,"<%=SystemEnv.getHtmlLabelName(21954,user.getLanguage())%>");
	}
}

function openWfEdit_grid(id,workflowid){
	procSet(id,workflowid);
}


</script>
</body>
</html>



















































