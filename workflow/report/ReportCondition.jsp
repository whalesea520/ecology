
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="java.net.*" %>
<%@page import="weaver.general.browserData.BrowserManager"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
 <%@ taglib uri="/browserTag" prefix="brow"%>
 <%@page import="weaver.fna.maintenance.FnaCostCenter"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
  <jsp:useBean id="xssUtil" class="weaver.filter.XssUtil" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="UrlComInfo" class="weaver.workflow.field.UrlComInfo" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CustomerInfoComInfo" class="weaver.crm.Maint.CustomerInfoComInfo" scope="page" />
<jsp:useBean id="FieldComInfo" class="weaver.workflow.field.FieldComInfo" scope="page" />
<jsp:useBean id="WorkflowComInfo" class="weaver.workflow.workflow.WorkflowComInfo" scope="page" />
<jsp:useBean id="ReportAuthorization" class="weaver.workflow.report.ReportAuthorization" scope="page" />
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo"></jsp:useBean>
<jsp:useBean id="workflowAllComInfo" class="weaver.workflow.workflow.WorkflowAllComInfo" scope="page"></jsp:useBean>
<%int reportid = Util.getIntValue(request.getParameter("id"),0);

int mouldId = Util.getIntValue(request.getParameter("mouldId"),0);
String newMouldName = Util.null2String(request.getParameter("newMouldName"));

//RecordSet.executeSql("select sharelevel from WorkflowReportShareDetail where userid="+user.getUID()+" and usertype=1 and reportid="+reportid);
int sharelevel = ReportAuthorization.getMaxShareLevel(String.valueOf(reportid),user);
if(sharelevel == -1){
    response.sendRedirect("/notice/noright.jsp");
    return;
} %>
<HTML><HEAD>
<link rel=stylesheet type="text/css" href="/css/Weaver_wev8.css">
<script language="javascript" src="/js/weaver_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
<script language="javascript">
$(document).ready(function(){
	if(!jQuery('#con-12_value').val()){
		jQuery("#con-13_value_browserbtn").attr("disabled","true");
	}
	//$('#button').removeAttr("disabled");
	
	jQuery(".e8tips").wTooltip({html:true}); 
});
function changeclick1(){
jQuery("input[name=requestname_check_con]").attr("checked",true);
//changeCheckboxStatus(document.SearchForm.requestname_check_con,true);
}
function changeclick2(){
jQuery("input[name=requestlevel_check_con]").attr("checked",true);
//changeCheckboxStatus(document.SearchForm.requestlevel_check_con,true);
}
function changeclick10(){
jQuery("input[name=createman_check_con]").attr("checked",true);
//changeCheckboxStatus(document.SearchForm.createman_check_con,true);
}
function changeclick11(){
jQuery("input[name=createdate_check_con]").attr("checked",true);
//changeCheckboxStatus(document.SearchForm.createdate_check_con,true);
}
function changeclick12(){
jQuery("input[name=workflowto_check_con]").attr("checked",true);
//changeCheckboxStatus(document.SearchForm.workflowto_check_con,true);
}
function changeclick13(){
jQuery("input[name=currentnode_check_con]").attr("checked",true);
//changeCheckboxStatus(document.SearchForm.currentnode_check_con,true);
}
function changeclick14(){
jQuery("input[name=nooperator_check_con]").attr("checked",true);
//changeCheckboxStatus(document.SearchForm.nooperator_check_con,true);
}

function changeclick10brow(event,datas,name,callbackParams){
	jQuery("input[name=createman_check_con]").attr("checked",true);
	//changeCheckboxStatus(document.SearchForm.createman_check_con,true);
}
function changeclick12brow(event,datas,name,callbackParams){
	if(jQuery('#con-12_value').val()){
		jQuery("input[name=workflowto_check_con]").attr("checked",true);
		//changeCheckboxStatus(document.SearchForm.workflowto_check_con,true);
		jQuery("#con-13_value_browserbtn").removeAttr("disabled");
		jQuery("#con-13_value").val('');
		jQuery("#con-13_valuespan").html('');
		jQuery("input[name=currentnode_check_con]").attr("checked",false);
	}else{
		afterDelCallback12brow();
	}
}

function get13browurl(){
	var urls = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WorkFlowNodeBrowser.jsp";
	urls = urls + "?wfid=" + jQuery("#con-12_value").val();
	return urls;
}
function changeclick13brow(event,datas,name,callbackParams){
	jQuery("input[name=currentnode_check_con]").attr("checked",true);
	//changeCheckboxStatus(document.SearchForm.currentnode_check_con,true);
}
function changeclick14brow(event,datas,name,callbackParams){
	jQuery("input[name=nooperator_check_con]").attr("checked",true);
	//changeCheckboxStatus(document.SearchForm.nooperator_check_con,true);
}
function changecheckcon(conid,tmpindex){
	var conidval = jQuery("#"+conid).val();
	var id = conid.replace("con","").replace("_value", "");
	if(conidval != ""){
		//document.getElementsByName("check_con")[tmpindex - 1].checked = true;
		jQuery("input[name=check_con][value="+id+"]").attr("checked",true);
		//changeCheckboxStatus(document.getElementsByName("check_con")[tmpindex - 1],true);
	}
}
function afterDelCallback12brow(text,fieldid,params){
	jQuery("#con-13_value").val('');
	jQuery("#con-13_valuespan").html('');
	jQuery("#con-13_value_browserbtn").attr("disabled","true");
	jQuery("input[name=currentnode_check_con]").attr("checked",false);
	jQuery("input[name=workflowto_check_con]").attr("checked",false);
}

function onEditSaveTemplate(){
	var thisval = "";
	$("input[name$=_value]").each(function (i, e) {
		thisval = $(this).val();
		if (thisval != undefined && thisval != "") {
			var ename = $(this).attr("name");
			var eid = ename.replace("con", "").replace("_value", "");
			var targetelement = $("#con" + eid + "_name");
			var temphtml = "";
			//alert($("#" + ename + "span").children().length);
			$("#" + ename + "span a").each(function () {
				temphtml += $(this).text() + ",";	
			});
			var checkspan = /^<.*$/;
			if(checkspan.test(temphtml)){
				temphtml=temphtml.replace(/<[^>]+>/g,"");
			}
			targetelement.val(temphtml);
		}
	});
	var str = $("#templatetype").find("option:selected").text();
    document.SearchForm.action="ReportConditionOperation.jsp?operation=editSaveTemplate&newMouldName="+str;
    document.SearchForm.submit();
}

function setTemplatename(templatename) {
	$("input[name='newMouldName']").val(templatename);
}

function __changeDateForSelect(_this) {
	var _ckele = $(_this).closest("tr").find("input[type=checkbox]"); 
	_ckele.attr("checked", true);
	//changeCheckboxStatus(_ckele[0],true);
}

function changelevel(id) {
	jQuery("input[name=check_con][value="+id+"]").attr("checked",true);
	//document.getElementsByName("check_con")[tmpindex - 1].checked = true;
	//changeCheckboxStatus(document.getElementsByName("check_con")[tmpindex - 1],true);
	
	var organizationtypeobj = jQuery('#organizationtype').val();
	if(("con"+id+"_value") === organizationtypeobj){
			var _id = jQuery('#organizationid_158').val();
			jQuery("#con"+_id+"_value").val('');
			jQuery("#con"+_id+"_valuespan").html('');
			jQuery("#con"+_id+"_name").val('');
			jQuery("input[name=check_con][value="+_id+"]").attr("checked",false);
	}else{
		var _isE8FnaWfOrgTypeFieldId_2 = jQuery.inArray(id+"", fnaOrgType_fieldId_array_2)>=0;
		var _isE8FnaWfOrgTypeFieldId_11 = jQuery.inArray(id+"", fnaOrgType_fieldId_array_11)>=0;
		if(_isE8FnaWfOrgTypeFieldId_2){
			var fnaOrgId_fieldId_array_length = fnaOrgId_fieldId_array_3.length;
			for(var i=0;i<fnaOrgId_fieldId_array_length;i++){
				var _id = fnaOrgId_fieldId_array_3[i];
				jQuery("#con"+_id+"_value").val('');
				jQuery("#con"+_id+"_valuespan").html('');
				jQuery("#con"+_id+"_name").val('');
				jQuery("input[name=check_con][value="+_id+"]").attr("checked",false);
			}
		}else if(_isE8FnaWfOrgTypeFieldId_11){
			var fnaOrgId_fieldId_array_length = fnaOrgId_fieldId_array_12.length;
			for(var i=0;i<fnaOrgId_fieldId_array_length;i++){
				var _id = fnaOrgId_fieldId_array_12[i];
				jQuery("#con"+_id+"_value").val('');
				jQuery("#con"+_id+"_valuespan").html('');
				jQuery("#con"+_id+"_name").val('');
				jQuery("input[name=check_con][value="+_id+"]").attr("checked",false);
			}
		}
	}
}

function changefilingdate(){
	jQuery("input[name=requeststatus_check_con]").attr("checked",true);
	//changeCheckboxStatus(jQuery("input[name=requeststatus_check_con]"),true);
	
}

function changefilingdateck(){
	jQuery("input[name=filingdate_check_con]").attr("checked",true);
	//changeCheckboxStatus(jQuery("input[name=filingdate_check_con]"),true);
}

function changecreatedate(){
	jQuery("input[name=createdate_check_con]").attr("checked",true);
	//changeCheckboxStatus(jQuery("input[name=createdate_check_con]"),true);
}

if(navigator.userAgent.indexOf('MSIE') >= 0) {
	<%
	response.setHeader("Pragma","No-cache"); 
	response.setHeader("Cache-Control","no-cache"); 
	response.setDateHeader("Expires", 0); 
	%>
}else{
	javascript:window.history.forward(1);
}
</script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(15101,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(16532,user.getLanguage())+" - " + SystemEnv.getHtmlLabelName(15505,user.getLanguage());
String needfav ="1";
String needhelp ="";
String bclick = "";


class Node{
	private String fieldid;
	private String valueone;
	private String valuetwo;
	private String valuethree;
	private String valuefour;
	private String type;
	private String httype;
	public String getId(){
		return this.fieldid;
	}
	public void setId(String id){
		this.fieldid=id;
	}
	public String getVal1(){
	   return this.valueone;
	}
	public void setVal1(String val){
		this.valueone=val;
	}
	public String getVal2(){
		return this.valuetwo;
	}
	public void setVal2(String val){
		this.valuetwo=val;
	}
	public String getVal3(){
		return this.valuethree;
	}
	public void setVal3(String val){
		this.valuethree=val;
	}
	public String getVal4(){
		return this.valuefour;
	}
	public void setVal4(String val){
		this.valuefour=val;
	}
	public String getType(){
		return this.type;
	}
	public void setType(String type){
		this.type=type;
	}
	public String getHttype(){
		return this.httype;
	}
	public void setHttype(String type){
		this.httype=type;
	}
	public void reset(){
		this.fieldid="";
		this.httype="";
		this.type="";
		this.valueone="";
		this.valuetwo="";
		this.valuethree="";
		this.valuefour="";
	}
}
Map<String,Node> map=new HashMap<String,Node>();
Node currNode=new Node();
String sql = " select a.formid , a.isbill,a.reportwfid,a.reporttype from Workflow_Report a " + " where  a.id="+reportid ;
RecordSet.execute(sql) ;
RecordSet.next() ;
String isbill = Util.null2String(RecordSet.getString("isbill"));
int formid = Util.getIntValue(RecordSet.getString("formid"),0);
String reportwfid =  Util.null2String(RecordSet.getString("reportwfid"));
int reporttype = Util.getIntValue(RecordSet.getString("reporttype"),-1);
boolean fna = false;//单据号，156、157、158 明细的报销单位和报销类型是相关联的

String organizationtype = "";
String organizationid = "";
if(isbill.equals("1")){
	if(formid==156||formid==157||formid==158){
		fna = true;
	}
}

HashMap<String, String> fnaFeeWfInfo_fieldId_hm = new HashMap<String, String>();
HashMap<String, String> fnaFeeWfInfo_fieldName_hm = new HashMap<String, String>();
HashMap<String, String> fnaFeeWfInfo_fieldIsDtl_hm = new HashMap<String, String>();
List<String> fnaOrgType_fieldId_list_2 = new ArrayList<String>();
List<String> fnaOrgId_fieldId_list_3 = new ArrayList<String>();
StringBuffer fnaOrgType_fieldId_strs_2 = new StringBuffer();//2：承担主体类型；
StringBuffer fnaOrgId_fieldId_strs_3 = new StringBuffer();//3：承担主体；
List<String> fnaOrgType_fieldId_list_11 = new ArrayList<String>();
List<String> fnaOrgId_fieldId_list_12 = new ArrayList<String>();
StringBuffer fnaOrgType_fieldId_strs_11 = new StringBuffer();//11：承担主体类型；
StringBuffer fnaOrgId_fieldId_strs_12 = new StringBuffer();//12：承担主体；
String sqlFna1 = "select b.workflowid, b.formid, b.fieldType, b.fieldId, b.isDtl, b.showAllType, b.dtlNumber, c.fieldname  \n" +
	" from fnaFeeWfInfo a \n" +
	" join fnaFeeWfInfoField b on a.id = b.mainid \n" +
	" join workflow_billfield c on b.fieldId = c.id \n" +
	" where (1=2 "+
	" 	or ((b.fieldType in (2,3) and b.dtlNumber = 1) and a.fnaWfType = 'fnaFeeWf') "+
	" 	or ((b.fieldType in (2,3,11,12) and b.dtlNumber = 1) and a.fnaWfType = 'change') "+
	" 	or ((b.fieldType in (2,3,11,12) and b.dtlNumber = 1) and a.fnaWfType = 'share') "+
	" ) "+
	" and b.workflowid in ("+reportwfid+")";
RecordSet.executeSql(sqlFna1);
while(RecordSet.next()){
	String _wfId = Util.null2String(RecordSet.getString("workflowid")).trim();
	String _fmId = Util.null2String(RecordSet.getString("formid")).trim();
	String _fieldType = Util.null2String(RecordSet.getString("fieldType")).trim();
	String _fieldId = Util.null2String(RecordSet.getString("fieldId")).trim();
	String _fieldname = Util.null2String(RecordSet.getString("fieldname")).trim();
	String _isDtl = Util.null2String(RecordSet.getString("isDtl")).trim();
	String _key = _wfId+"_"+_fieldType;
	fnaFeeWfInfo_fieldId_hm.put(_key, _fieldId);
	fnaFeeWfInfo_fieldName_hm.put(_key, _fieldname);
	fnaFeeWfInfo_fieldIsDtl_hm.put(_key, _isDtl);
	if("2".equals(_fieldType)){
		if(!fnaOrgType_fieldId_list_2.contains(_fieldId)){
			if(fnaOrgType_fieldId_strs_2.length() > 0){
				fnaOrgType_fieldId_strs_2.append(",");
			}
			fnaOrgType_fieldId_strs_2.append("'"+_fieldId+"'");
			fnaOrgType_fieldId_list_2.add(_fieldId);
		}
	}else if("3".equals(_fieldType)){
		if(!fnaOrgId_fieldId_list_3.contains(_fieldId)){
			if(fnaOrgId_fieldId_strs_3.length() > 0){
				fnaOrgId_fieldId_strs_3.append(",");
			}
			fnaOrgId_fieldId_strs_3.append("'"+_fieldId+"'");
			fnaOrgId_fieldId_list_3.add(_fieldId);
		}
	}
	if("11".equals(_fieldType)){
		if(!fnaOrgType_fieldId_list_11.contains(_fieldId)){
			if(fnaOrgType_fieldId_strs_11.length() > 0){
				fnaOrgType_fieldId_strs_11.append(",");
			}
			fnaOrgType_fieldId_strs_11.append("'"+_fieldId+"'");
			fnaOrgType_fieldId_list_11.add(_fieldId);
		}
	}else if("12".equals(_fieldType)){
		if(!fnaOrgId_fieldId_list_12.contains(_fieldId)){
			if(fnaOrgId_fieldId_strs_12.length() > 0){
				fnaOrgId_fieldId_strs_12.append(",");
			}
			fnaOrgId_fieldId_strs_12.append("'"+_fieldId+"'");
			fnaOrgId_fieldId_list_12.add(_fieldId);
		}
	}
}

//获得报表显示项

String strReportDspField=",";//非模版

String fieldId="";//非模版


List ids = new ArrayList();
List isShows = new ArrayList();
List isCheckConds = new ArrayList();
List colnames = new ArrayList();
List opts = new ArrayList();
List values = new ArrayList();
List names = new ArrayList();
List opt1s = new ArrayList();
List value1s = new ArrayList();

if(mouldId == 0){
	//获得报表显示项

	RecordSet.execute("select fieldId,httype,htdetailtype,valueone,valuetwo,valuethree,valuefour from Workflow_ReportDspField where reportId="+reportid) ;
	while(RecordSet.next()){
		fieldId=RecordSet.getString(1);
		if(fieldId!=null&&!fieldId.equals("")){
			strReportDspField+=fieldId+",";
			Node node=new Node();
			node.setId(fieldId);
			node.setHttype(RecordSet.getString("httype"));
			node.setVal1(RecordSet.getString("valueone"));
			node.setVal2(RecordSet.getString("valuetwo"));
			node.setType(RecordSet.getString("htdetailtype"));
			node.setVal3(RecordSet.getString("valuethree"));
			node.setVal4(RecordSet.getString("valuefour"));
			map.put(fieldId,node);
		}
	}
}else{
	RecordSet.execute("select fieldId,isShow,isCheckCond,colName,optionFirst,valueFirst,nameFirst,optionSecond,valueSecond from WorkflowRptCondMouldDetail where mouldId="+mouldId) ;
	while(RecordSet.next()){
		ids.add(Util.null2String(RecordSet.getString("fieldId")));
		isShows.add(Util.null2String(RecordSet.getString("isShow")));
		isCheckConds.add(Util.null2String(RecordSet.getString("isCheckCond")));
		colnames.add(Util.null2String(RecordSet.getString("colName")));
		opts.add(Util.null2String(RecordSet.getString("optionFirst")));
		values.add(Util.null2String(RecordSet.getString("valueFirst")));
		names.add(Util.null2String(RecordSet.getString("nameFirst")));
		opt1s.add(Util.null2String(RecordSet.getString("optionSecond")));
		value1s.add(Util.null2String(RecordSet.getString("valueSecond")));
	}
	RecordSet.execute("select fieldId from Workflow_ReportDspField where reportId="+reportid) ;
	while(RecordSet.next()){
		fieldId=RecordSet.getString(1);
		if(fieldId!=null&&!fieldId.equals("")){
			strReportDspField+=fieldId+",";
		}
	}
}
%>

<BODY>
<script type="text/javascript">
var fnaOrgType_fieldId_array_2 = [<%=fnaOrgType_fieldId_strs_2.toString() %>];
var fnaOrgId_fieldId_array_3 = [<%=fnaOrgId_fieldId_strs_3.toString() %>];

var fnaOrgType_fieldId_array_11 = [<%=fnaOrgType_fieldId_strs_11.toString() %>];
var fnaOrgId_fieldId_array_12 = [<%=fnaOrgId_fieldId_strs_12.toString() %>];
</script>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>

<%
if(mouldId !=0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:resetReportForm(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:onEditSaveTemplate(),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(18418,user.getLanguage())+",javascript:addTemplate(),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:onDeleteTemplate(),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
}else{
	RCMenu += "{"+SystemEnv.getHtmlLabelName(197,user.getLanguage())+",javascript:submit(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(2022,user.getLanguage())+",javascript:resetReportForm(),_self} " ;
	RCMenuHeight += RCMenuHeightStep;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(18418,user.getLanguage())+",javascript:addTemplate(),_top} " ;
	RCMenuHeight += RCMenuHeightStep;
}
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM NAME=SearchForm id=SearchForm STYLE="margin-bottom:0" action="ReportResult.jsp" method="post">
<input type="hidden" value="<%=formid%>" name="formid">
<input type=hidden name=isbill value="<%=isbill%>">
<input type=hidden name=reportid value="<%=reportid%>">
<input type=hidden name=mouldId value="<%=mouldId%>">
<input type=hidden name=newMouldName value="<%=newMouldName%>">

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
		<%if(mouldId !=0){ %>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>"  class="e8_btn_top" onclick="submit()" >
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage()) %>"  class="e8_btn_top" onclick="resetReportForm()" >
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"  class="e8_btn_top" onclick="onEditSaveTemplate()" >
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(350,user.getLanguage()) %>"  class="e8_btn_top" onclick="addTemplate()" >
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(91,user.getLanguage()) %>"  class="e8_btn_top" onclick="onDeleteTemplate()" >
		<%}else{%>
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage()) %>"  class="e8_btn_top" onclick="submit()" >
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage()) %>"  class="e8_btn_top" onclick="resetReportForm()" >
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(18418,user.getLanguage()) %>"  class="e8_btn_top" onclick="addTemplate()" >
		<%}%>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<wea:layout type="2col">
	<wea:group context='<%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%>'>
		<wea:item type="groupHead">
		<span class="noHide">
			<select class="templatetype" id="templatetype" name="templatetype" notBeauty="true"  onChange="onchangeselect()">
	       		<option value="0" <%if(mouldId == 0){%>selected<%} %>><%=SystemEnv.getHtmlLabelName(149,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(64,user.getLanguage())%></option>
			<%
    String trClass="DataDark";
	int tempMouldId=-1;
	String tempMouldName="";
	RecordSet.executeSql("select id,mouldName from WorkflowRptCondMould where userId="+user.getUID()+" and reportId="+reportid+" order by id asc");
	
	while(RecordSet.next()) {
		tempMouldId = Util.getIntValue(RecordSet.getString(1), 0);
		tempMouldName = Util.null2String(RecordSet.getString(2));
%>
       		<option value="<%=tempMouldId%>" <%if(mouldId == tempMouldId){%>selected<%} %>><%=tempMouldName %></option>
<%
	}
%>
     		</select>
     		</span>	
		</wea:item>
		<wea:item attributes="{'colspan':'2','isTableList':'true'}">


<wea:layout type='table' attributes="{'cols':'4','cws':'10%,10%,20%,60%'}">
	<wea:group context="" attributes="{'groupDisplay':'none'}">
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(33541,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15505,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(261,user.getLanguage())%></wea:item>
		<wea:item type="thead"><%=SystemEnv.getHtmlLabelName(15364,user.getLanguage())%></wea:item>
		<!-- 请求标题 -->
<%

if(ids.indexOf("-1")>-1 || mouldId == 0){
%>
		<wea:item>
		<%
		if(strReportDspField.indexOf(",-1,")>-1){
			//currNode=(Node)map.get("-1");
		%>
	  	<input type="checkbox" name="requestNameIsShow" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-1")>-1){
				if(((String)isShows.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("1")){
		%>
					checked
		<%		
				}
			}else if(mouldId == 0){
				
		%>
					checked
		<%	
			}
		%>
		>
		<%
   		}else{
   			//currNode.reset();
   		}
		%>
		</wea:item>
		<wea:item>
		<input type="checkbox" name="requestname_check_con" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-1")>-1){
				if(((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("1")){
		%>
					checked
		<%
				}
			}
		%>
		>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(1334,user.getLanguage())%></wea:item>
		<wea:item>
		<% 
			boolean rn1 = false;
			boolean rn2 = false;
			boolean rn3 = false;
			boolean rn4 = false;
			String requestnamevalue = "";
			if(ids.indexOf("-1")!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("1")){
					rn1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("2")){
					rn2 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("3")){
					rn3 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf("-1")))).equals("4")){
					rn4 = true;
				}
				requestnamevalue = ((String)values.get(Util.getIntValue(""+ids.indexOf("-1"))));
			}
		%>
			<select class="inputstyle" name="requestname" notBeauty="true" onclick="changeclick1()" >
        		<option value="1"  <%if(rn1){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(327,user.getLanguage())%></option>
        		<option value="2"  <%if(rn2){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(15506,user.getLanguage())%></option>
        		<option value="3"  <%if(rn3){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
        		<option value="4"  <%if(rn4){%> selected <%}%> ><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
      		</select>
      		<input type="text" class="inputstyle"  value="<%=requestnamevalue%>" style="width:150px;" name="requestnamevalue" onfocus="changeclick1()"> 
      </wea:item>
      <!-- 紧急程度 -->
<%
}
if(ids.indexOf("-2")>-1 || mouldId == 0){
%>
	  <wea:item>
		<%
			if(strReportDspField.indexOf(",-2,")>-1){
				//currNode=(Node)map.get("-2");
		%>
		<input type="checkbox" name="requestLevelIsShow" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-2")>-1){
				if(((String)isShows.get(Util.getIntValue(""+ids.indexOf("-2")))).equals("1")){
		%>
					checked
		<%		
				}
			}else if(mouldId == 0){
				
		%>
					checked
		<%	
			}
		%>
		>
		<%
   		}else{
   			//currNode.reset();
   		}
		%>
		</wea:item>
		<wea:item>
		<input type="checkbox" name="requestlevel_check_con" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-2")>-1){
				if(((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-2")))).equals("1")){
		%>
					checked
		<%
				}
			}
		%>
		>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(15534,user.getLanguage())%></wea:item>
		<wea:item>
		<% 
			boolean rl1 = false;
			boolean rl2 = false;
			boolean rl3 = false;
			if(ids.indexOf("-2")!=-1){
				if(((String)values.get(Util.getIntValue(""+ids.indexOf("-2")))).equals("0")){
					rl1 = true;
				}
				if(((String)values.get(Util.getIntValue(""+ids.indexOf("-2")))).equals("1")){
					rl2 = true;
				}
				if(((String)values.get(Util.getIntValue(""+ids.indexOf("-2")))).equals("2")){
					rl3 = true;
				}
			}
		%>
			<select class="inputstyle" name="requestlevelvalue" notBeauty="true"  onclick="changeclick2()">
        		<option value="0" <%if(rl1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(225,user.getLanguage())%></option>
        		<option value="1" <%if(rl2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15533,user.getLanguage())%></option>
        		<option value="2" <%if(rl3){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(2087,user.getLanguage())%></option>
			</select>
		</wea:item>
		<!-- 创建人 -->
<%
}
if(ids.indexOf("-10")>-1 || mouldId == 0){
%>
		<wea:item>
		<%
			if(strReportDspField.indexOf(",-10,")>-1){
				//currNode=(Node)map.get("-10");
		%>
		<input type="checkbox" name="createmanIsShow" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-10")>-1){
				if(((String)isShows.get(Util.getIntValue(""+ids.indexOf("-10")))).equals("1")){
		%>
					checked
		<%		
				}
			}else if(mouldId == 0){
				
		%>
					checked
		<%	
			}
		%>
		>
		<%
   		}else{
   			//currNode.reset();
   		}
		%>
		</wea:item>
		<wea:item>
		<input type="checkbox" name="createman_check_con" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-10")>-1){
				if(((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-10")))).equals("1")){
		%>
					checked
		<%
				}
			}
		%>
		>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(882,user.getLanguage())%></wea:item>
		<wea:item>
		<div style="float:left;">
		<% 
			boolean cm1 = false;
			boolean cm2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf("-10")!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf("-10")))).equals("1")){
					cm1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf("-10")))).equals("2")){
					cm2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf("-10"))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf("-10"))));
			}
		%>
			<select class=inputstyle name="createmanselected" notBeauty="true" onclick="changeclick10()">
        		<option value="1" <%if(cm1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(353,user.getLanguage())%></option>
        		<option value="2" <%if(cm2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(21473,user.getLanguage())%></option>
      		</select>
      		</div>
      		<div style="float:left;width:150px;">
	          <brow:browser viewType="0" name="con-10_value" browserValue='<%=browserValue%>' 
			  browserOnClick="" _callback="changeclick10brow"
	          browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
	          hasInput="true"  width="150px" isSingle="true" hasBrowser = "true" 
	          isMustInput='1' completeUrl="/data.jsp"  browserSpanValue='<%=browserSpanValue%>'> 
				</brow:browser> 
		    </div>
      	
      		<input type=hidden name="con-10_value" id="con-10_value" value="<%=browserValue%>">
      		<input type=hidden name="con-10_name" id="con-10_name" value="<%=browserSpanValue%>">

		</wea:item>
		<!-- 创建日期 -->
<%
}
if(ids.indexOf("-11")>-1 || mouldId == 0){
%>
		<wea:item>
		<%
			if(strReportDspField.indexOf(",-11,")>-1){
				//currNode=map.get("-11");
		%>
		<input type="checkbox" name="createdateIsShow" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-11")>-1){
				if(((String)isShows.get(Util.getIntValue(""+ids.indexOf("-11")))).equals("1")){
		%>
					checked
		<%		
				}
			}else if(mouldId == 0){
				
		%>
					checked
		<%	
			}
		%>
		>
		<%
   		}else{
   			//currNode.reset();
   		}
		%>
		</wea:item>
		<wea:item>
		<input type="checkbox" name="createdate_check_con" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-11")>-1){
				if(((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-11")))).equals("1")){
		%>
					checked
		<%
				}
			}
		%>
		>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(722,user.getLanguage())%></wea:item>
		<wea:item >
		<%
			String createdate =  "";
			String createdateend = "";
			if(ids.indexOf("-11")>-1){
				createdate =  values.get(Util.getIntValue(""+ids.indexOf("-11"))).toString();
				createdateend = value1s.get(Util.getIntValue(""+ids.indexOf("-11"))).toString();
			}
		%>
		<span class="wuiDateSpan" selectId="createdatespan" onclick="changecreatedate()" selectValue="">
			<input class=wuiDateSel type="hidden" name="createdate" value="<%=createdate%>">
			<input class=wuiDateSel type="hidden" name="createdateend" value="<%=createdateend%>">
		</span>
		<%--
		<button type=button  type=button class=calendar id=SelectCreateDate onfocus="changeclick11()" onclick="gettheDate(createdate,createdatespan)"></BUTTON>&nbsp;
    	<SPAN id=createdatespan name="createdatespan"></SPAN>
    	<input type="hidden" name="createdate" class=Inputstyle value=""> --%>
		</wea:item>
		<!--  -->
		<!-- 工作流 -->
<%
}
if(ids.indexOf("-12")>-1 || mouldId == 0){
%>
		<wea:item>
		<%
			if(strReportDspField.indexOf(",-12,")>-1){
				//currNode=map.get("-12");
		%>
		<input type="checkbox" name="workflowtoIsShow" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-12")>-1){
				if(((String)isShows.get(Util.getIntValue(""+ids.indexOf("-12")))).equals("1")){
		%>
					checked
		<%		
				}
			}else if(mouldId == 0){
				
		%>
					checked
		<%	
			}
		%>
		>
		<%
   		}else{
   			//currNode.reset();
   		}
		%>
		</wea:item>
		<wea:item>
		<input type="checkbox" name="workflowto_check_con" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-12")>-1){
				if(((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-12")))).equals("1")){
		%>
					checked
		<%
				}
			}else{
			    if(!"".equals(reportwfid) && reportwfid.indexOf(",")<0){
			        %>checked<%
			    }
			}
		%>
		>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(26361,user.getLanguage())%></wea:item>
		<wea:item>
		<% 
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf("-12")!=-1){
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf("-12"))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf("-12"))));
			}else{
				if(!"".equals(reportwfid) && reportwfid.indexOf(",")<0){
				    rs.executeQuery("select workflowname from workflow_base where isvalid in ('1','2','3') and id = ?",reportwfid);
				    if(rs.next()){
				   	 	browserValue = reportwfid;
				   	 	browserSpanValue = Util.null2String(rs.getString(1));
				    }
				}
			}
			String compurl = "javascript:getajaxurl('workflowBrowser&reportwfid="+reportwfid+"')";
			String browserUrl = "/systeminfo/BrowserMain.jsp?url=/workflow/workflow/WFTypeBrowser.jsp?reportCondition=1&reportwfid="+reportwfid;
		%>
      		 <div style="float:left;width:150px;">
			     <brow:browser viewType="0" name="con-12_value" browserValue='<%=browserValue%>' 
				  browserOnClick="" _callback="changeclick12brow" afterDelCallback="afterDelCallback12brow"
		          browserUrl="<%=browserUrl %>" 
		          hasInput="true"  width="150px" isSingle="true" hasBrowser = "true" isMustInput='1' 
		          completeUrl='<%=compurl%>'  browserSpanValue='<%=browserSpanValue%>'> 
				 </brow:browser>  
		     </div>
      		<input type=hidden name="con-12_value" id="con-12_value" value="<%=browserValue%>">
      		<input type=hidden name="con-12_name"  id="con-12_name" value="<%=browserSpanValue%>">
		</wea:item>
		<!--  -->
		<!-- 当前节点 -->
<%
}
if(ids.indexOf("-13")>-1 || mouldId == 0){
%>
		<wea:item>
		<%
			if(strReportDspField.indexOf(",-13,")>-1 && strReportDspField.indexOf(",-13,")>-1){
				//currNode=map.get("-13");
		%>
		<input type="checkbox" name="currentnodeIsShow" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-13")>-1){
				if(((String)isShows.get(Util.getIntValue(""+ids.indexOf("-13")))).equals("1")){
		%>
					checked
		<%		
				}
			}else if(mouldId == 0){
				
		%>
					checked
		<%	
			}
		%>
		>
		<%
   		}else{
   			//currNode.reset();
   		}
		%>
		</wea:item>
		<wea:item>
		<input type="checkbox" name="currentnode_check_con" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-13")>-1){
				if(((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-13")))).equals("1")){
		%>
					checked
		<%
				}
			}
		%>
		>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(18564,user.getLanguage())%>&nbsp;<span class='e8tips' title='<%=SystemEnv.getHtmlLabelName(126631,user.getLanguage()) %>'><img src='/images/tooltip_wev8.png' align='absMiddle'/></span></wea:item>
		<wea:item>
		<% 
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf("-13")!=-1){
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf("-13"))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf("-13"))));
			}
			String compurl2 = "javascript:getajaxurl('currentnodeBrowser')";
		%>
      		 <div style="float:left;width:150px;">
		      	<brow:browser viewType="0" name="con-13_value" browserSpanValue='<%=browserSpanValue%>' 
				  browserOnClick="" _callback="changeclick13brow" browserValue='<%=browserValue%>'
		          browserUrl="" getBrowserUrlFn="get13browurl"
		          hasInput="true"  width="150px" isSingle="true" hasBrowser = "true" 
		          isMustInput='1' completeUrl='<%=compurl2%>' > 
				</brow:browser>      
		          
      		</div>
      		<input type=hidden name="con-13_value" id="con-13_value" value="<%=browserValue%>">
      		<input type=hidden name="con-13_name" id="con-13_name" value="<%=browserSpanValue%>">
     		 
		</wea:item>
		<!--  -->
		<!-- 未操作者 -->
<%
}
if(ids.indexOf("-14")>-1 || mouldId == 0){
%>
		<wea:item>
		<%
			if(strReportDspField.indexOf(",-14,")>-1){
				//currNode=map.get("-14");
		%>
		<input type="checkbox" name="nooperatorIsShow" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-14")>-1){
				if(((String)isShows.get(Util.getIntValue(""+ids.indexOf("-14")))).equals("1")){
		%>
					checked
		<%		
				}
			}else if(mouldId == 0){
				
		%>
					checked
		<%	
			}
		%>
		>
		<%
   		}else{
   			//currNode.reset();
   		}
		%>
		</wea:item>
		<wea:item>
		<input type="checkbox" name="nooperator_check_con" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-14")>-1){
				if(((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-14")))).equals("1")){
		%>
					checked
		<%
				}
			}
		%>
		>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(16354,user.getLanguage())%></wea:item>
		<wea:item>
		<% 
			boolean noot1 = false;
			boolean noot2 = false;
			String browserValue = "";
			String browserSpanValue = "";
			if(ids.indexOf("-14")!=-1){
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf("-14")))).equals("3")){
					noot1 = true;
				}
				if(((String)opts.get(Util.getIntValue(""+ids.indexOf("-14")))).equals("4")){
					noot2 = true;
				}
				browserValue = ((String)values.get(Util.getIntValue(""+ids.indexOf("-14"))));
		        browserSpanValue = ((String)names.get(Util.getIntValue(""+ids.indexOf("-14"))));
			}
		%>
			<div style="float:left;">
				<select class=inputstyle name="nooperator_opt" notBeauty="true" onclick="changeclick14()">
	            	<option value="3" <%if(noot1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(346,user.getLanguage())%></option>
	            	<option value="4" <%if(noot2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(15507,user.getLanguage())%></option>
				</select>
      		</div>
      	   <div style="float:left;width:150px;">
		    <brow:browser viewType="0" name="con-14_value" browserSpanValue='<%=browserSpanValue%>' 
			  browserOnClick="" _callback="changeclick14brow" browserValue='<%=browserValue%>'
	          browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp" 
	          hasInput="true"  width="150px" isSingle="true" hasBrowser = "true" 
	          isMustInput='1' completeUrl='<%="javascript:getajaxurl(1)"%>' > 
			</brow:browser>      
		   </div>

      		<input type=hidden name="con-14_value" id="con-14_value" value="<%=browserValue%>">
      		<input type=hidden name="con-14_name" id="con-14_name" value="<%=browserSpanValue%>">
     		
		</wea:item>
		<!--  -->
		<!-- 流程状态 -->
<%
}
if(ids.indexOf("-15")>-1 || mouldId == 0){
%>
		<wea:item>
		<%
			if(strReportDspField.indexOf(",-15,")>-1){
				//currNode=map.get("-15");
		%>
		<input type="checkbox" name="requeststatusIsShow" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-15")>-1){
				if(((String)isShows.get(Util.getIntValue(""+ids.indexOf("-15")))).equals("1")){
		%>
					checked
		<%		
				}
			}else if(mouldId == 0){
				
		%>
					checked
		<%	
			}
		%>
		>
		<%
   		}else{
   			//currNode.reset();
   		}
		%>
		</wea:item>
		<wea:item>
		<input type="checkbox" name="requeststatus_check_con" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-15")>-1){
				if(((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-15")))).equals("1")){
		%>
					checked
		<%
				}
			}
		%>
		>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(31485,user.getLanguage())%></wea:item>
		<wea:item>
		<% 
			boolean rst1 = false;
			boolean rst2 = false;
			if(ids.indexOf("-15")!=-1){
				if(((String)values.get(Util.getIntValue(""+ids.indexOf("-15")))).equals("1")){
					rst1 = true;
				}
				if(((String)values.get(Util.getIntValue(""+ids.indexOf("-15")))).equals("2")){
					rst2 = true;
				}
			}
		%>
		<select class=inputstyle name="requeststatusvalue" notBeauty="true" onchange="changefilingdate()">
            <option value="1" <%if(rst1){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(251,user.getLanguage())%></option>
            <option value="2" <%if(rst2){%>selected<%}%>><%=SystemEnv.getHtmlLabelName(17999,user.getLanguage())%></option>
		</select>
		</wea:item>
		<!-- 归档日期-->
<%
}
if(ids.indexOf("-16")>-1 || mouldId == 0){
%>
		<wea:item>
		<%
			if(strReportDspField.indexOf(",-16,")>-1){
		%>
		<input type="checkbox" name="filingdateIsShow" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-16")>-1){
				if(((String)isShows.get(Util.getIntValue(""+ids.indexOf("-16")))).equals("1")){
		%>
					checked
		<%		
				}
			}else if(mouldId == 0){
				
		%>
					checked
		<%	
			}
		%>
		>
		<%
   		}else{
   			//currNode.reset();
   		}
		%>
		</wea:item>
		<wea:item>
		<input type="checkbox" name="filingdate_check_con" notBeauty="true" value="1" 
		<%
			if(ids.indexOf("-16")>-1){
				if(((String)isCheckConds.get(Util.getIntValue(""+ids.indexOf("-16")))).equals("1")){
		%>
					checked
		<%
				}
			}
		%>
		>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(3000,user.getLanguage())%></wea:item>
		<wea:item>
		<%
			String filingdate =  "";
			String filingdateend = "";
			if(ids.indexOf("-16")>-1){
				filingdate =  values.get(Util.getIntValue(""+ids.indexOf("-16"))).toString();
				filingdateend = value1s.get(Util.getIntValue(""+ids.indexOf("-16"))).toString();
			}
		%>
			<span class="wuiDateSpan" id="filingdateid" onclick="changefilingdateck()" selectId="filingdatespan" selectValue="">
				<input class=wuiDateSel type="hidden" name="filingdate" value="<%=filingdate%>">
				<input class=wuiDateSel type="hidden" name="filingdateend" value="<%=filingdateend%>">
			</span>
		</wea:item> 
		<!--  -->
		<!-- 签字意见 -->
		<%-- 
		<wea:item>
		<%
			if(strReportDspField.indexOf(",-17,")>-1){
		%>
		<input type="checkbox" name="signopinionsIsShow" notBeauty="true" value="1" checked>
		<%
    		}
		%>
		</wea:item>
		<wea:item><input type="checkbox" name="signopinions_check_con" notBeauty="true" value="1" ></wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(30435,user.getLanguage())%></wea:item>
		<wea:item>
			<input type="checkbox" name="signopinions_check_select" notBeauty="true" value="1" >
			不显示空意见
		</wea:item>
		--%>
<%} %>
	</wea:group>
</wea:layout>

<jsp:include page="ReportCondition_inner.jsp">
   		<jsp:param name="isbill" value="<%=isbill %>" />
   		<jsp:param name="formid" value="<%=formid %>" />
   		<jsp:param name="reportwfid" value="<%=reportwfid %>" />
   		<jsp:param name="sharelevel" value="<%=sharelevel %>" />
   		<jsp:param name="reportid" value="<%=reportid %>" />
   		<jsp:param name="mouldId" value="<%=mouldId %>" />
   		<jsp:param name="fna" value="<%=fna %>" />
   </jsp:include>


	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>
		</wea:item>
	</wea:group>
</wea:layout>
</FORM>

<!--xwj for td2974 20051026   B E G I N-->
<script language="javascript">


function onSaveAsTemplate(){
	var thisval = "";
	$("input[name$=_value]").each(function (i, e) {
		thisval = $(this).val();
		if (thisval != undefined && thisval != "") {

			var ename = $(this).attr("name");
			var eid = ename.replace("con", "").replace("_value", "");
			var targetelement = $("#con" + eid + "_name");
			var temphtml = "";
			//alert($("#" + ename + "span").children().length);
			$("#" + ename + "span a").each(function () {
				temphtml += $(this).text() + ",";	
			});
			var checkspan = /^<.*$/;
			if(checkspan.test(temphtml)){
				temphtml=temphtml.replace(/<[^>]+>/g,"");
			}
			targetelement.val(temphtml);
		}
		//alert(targetelement.val());
	});
	//if(check_form(document.SearchForm,'newMouldName')){
		//if(document.all("todate").value != "" && document.all("fromdate").value > document.all("todate").value){
			//alert("");
			//return;
			//}
	//document.SearchForm.operation.value="saveAsTemplate";
	document.SearchForm.action="ReportConditionOperation.jsp?operation=saveAsTemplate";
	document.SearchForm.submit();
	//}
}
function submit(){
	//if(document.all("todate").value != "" && document.all("fromdate").value > document.all("todate").value){
	//	alert("<%=SystemEnv.getHtmlLabelName(16722,user.getLanguage())%>");
	//	return;
	//}else{
	var thisval = false;

	thisval = getThisVal();
	if(!thisval){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(81551,user.getLanguage())%>");
		return;
	}
	document.SearchForm.submit();
	//}
}

function getThisVal(){
	var tval = false;
	$("input[name$=sShow]").each(function (i, e) {
		if($(this).is(":checked")){
			tval = $(this).is(":checked");
			return tval;
		}
	});
	return tval;
}

function changeE8FnaWfOrgId_browserUrl(id){
	var _isE8FnaWfOrgIdFieldId_3 = jQuery.inArray(id+"", fnaOrgId_fieldId_array_3)>=0;
	var _isE8FnaWfOrgIdFieldId_12 = jQuery.inArray(id+"", fnaOrgId_fieldId_array_12)>=0;
	if(_isE8FnaWfOrgIdFieldId_3 && fnaOrgType_fieldId_array_2.length > 0){
		var _orgType_val = jQuery("select[name='con"+fnaOrgType_fieldId_array_2[0]+"_value']").val()+"";
		if(_orgType_val=="0"){//个人
	  		onShowBrowser(id,"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",null,true);
			return true;
		}else if(_orgType_val=="1"){//部门
	   		var url2 = "/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp";
	   		onShowBrowser2(id,url2,true);
			return true;
		}else if(_orgType_val=="2"){//分部
	   		var url1="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp";
	   		onShowBrowser2(id,url1,true);
			return true;
		}else if(_orgType_val=="3"){//成本中心
			var url4 = "<%=new BrowserComInfo().getBrowserurl("251") %>";
    		//var url4 = "/systeminfo/BrowserMain.jsp?url=/fna/browser/costCenter/FccBrowserMulti.jsp";
    		onShowBrowser2(id,url4,true);
    		return true;
		}else{
			//top.Dialog.alert("请先选择费用承担类型");
    		//return true;
		}
	}else if(_isE8FnaWfOrgIdFieldId_12 && fnaOrgType_fieldId_array_11.length > 0){
		var _orgType_val = jQuery("select[name='con"+fnaOrgType_fieldId_array_11[0]+"_value']").val()+"";
		if(_orgType_val=="0"){//个人
	  		onShowBrowser(id,"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp",null,true);
			return true;
		}else if(_orgType_val=="1"){//部门
	   		var url2 = "/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp";
	   		onShowBrowser2(id,url2,true);
			return true;
		}else if(_orgType_val=="2"){//分部
	   		var url1="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp";
	   		onShowBrowser2(id,url1,true);
			return true;
		}else if(_orgType_val=="3"){//成本中心
			var url4 = "<%=new BrowserComInfo().getBrowserurl("251") %>";
    		//var url4 = "/systeminfo/BrowserMain.jsp?url=/fna/browser/costCenter/FccBrowserMulti.jsp";
    		onShowBrowser2(id,url4,true);
    		return true;
		}else{
			//top.Dialog.alert("请先选择费用承担类型");
    		//return true;
		}
	}
	return false;
}

function onShowBrowser3(id,url){
	var tempvalue = jQuery("#organizationtype").val();
	if(tempvalue!=null && tempvalue !=""){
	   if(document.getElementById("con<%=organizationid%>_value")){
		   if(document.getElementById("con<%=organizationid%>_value").value==""){
			   initFna();
		   }
	   }
	   var value = jQuery("select[name="+tempvalue+"]").val();
	   if(value==3 || value==null || value ==""){
	  		onShowBrowser(id,"/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp");
	   		
	   }else if(value==2 ){
	   		var url2 = "/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp";
	   		onShowBrowser2(id,url2);
	   		
	   }else if(value==1){
	   		var url1="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp";
	   		onShowBrowser2(id,url1);
	   }else if (value == "<%=FnaCostCenter.ORGANIZATION_TYPE+"" %>"){//成本中心
    		var url4 = "<%=new BrowserComInfo().getBrowserurl("251") %>";
    		onShowBrowser2(id,url4);
       }
	}
}
function changevalue(){
	try{
	var tempvalue = document.getElementById("neworganizationid").value;
	document.getElementById("con"+tempvalue+"_value").value = "";
	document.getElementById("con"+tempvalue+"_name").value = "";
	document.getElementById("con"+tempvalue+"_valuespan").value = "";
	document.getElementById("con"+tempvalue+"_valuespan").innerText="";
	}catch(e){
		if(window.console)console.log("--ReportCondition.jsp--->"+e);
	}
}

function initFna(){
	try{
		var check_con = document.getElementsByName("check_con");
		if("<%=organizationtype%>"=="1"){
			for(var i=0;i<check_con.length;i++){
				var cc = check_con[i];
				if(cc.value=="<%=organizationid%>"){
					cc.checked=true;
				}
			}
			document.getElementById("con<%=organizationid%>_value").value = 3;
		}else if("<%=organizationtype%>"=="4"){
			for(var i=0;i<check_con.length;i++){
				var cc = check_con[i];
				if(cc.value=="<%=organizationid%>"){
					cc.checked=true;
				}
			}		
			document.getElementById("con<%=organizationid%>_value").value = 2;
		}else if("<%=organizationtype%>"=="164"){
			for(var i=0;i<check_con.length;i++){
				var cc = check_con[i];
				if(cc.value=="<%=organizationid%>"){
					cc.checked=true;
				}
			}		
			document.getElementById("con<%=organizationid%>_value").value = 1;
		}	
	}catch(e){}
}
//window.attachEvent("onload", initFna);

</script>
<!--xwj for td2974 20051026   E N D-->
<script language="javascript">
//function onShowBrowser2(id,url) {
//	var url = url + "?selectedids=" + $G("con"+id+"_value").value;
//	var id1 = window.showModalDialog(url);
//	if (id1 != null && id1 != undefined) {
//	    if (wuiUtil.getJsonValueByIndex(id1, 0) != "" && wuiUtil.getJsonValueByIndex(id1, 0) != "0") {
//	    	var rid = wuiUtil.getJsonValueByIndex(id1, 0);
//	    	var rname = wuiUtil.getJsonValueByIndex(id1, 1);
//			if (rname.indexOf(",") == 0) {
//				rname = rname.substr(1);
//			}
//			$G("con"+id+"_valuespan").innerHTML = rname;
//			$G("con"+id+"_value").value = rid;
//	        $G("con"+id+"_name").value = rname;
//	    } else {
//	    	$G("con"+id+"_valuespan").innerHTML = "";
//	    	$G("con"+id+"_value").value="";
//	    	$G("con"+id+"_name").value="";
//	    }
//	}
//}

function onShowBrowser2(id,url,_break_changeE8FnaWfOrgId_browserUrl) {
	if(_break_changeE8FnaWfOrgId_browserUrl==null){
		_break_changeE8FnaWfOrgId_browserUrl = false;
	}
	if(!_break_changeE8FnaWfOrgId_browserUrl && changeE8FnaWfOrgId_browserUrl(id)){
		return;
	}
	var url = url + "?selectedids=" + $G("con"+id+"_value").value;
	//var id1 = window.showModalDialog(url);
	var dialogurl = url;
	var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.URL = dialogurl;
		dialog.callbackfun = function (paramobj, id1) {
	
			if (id1 != null && id1 != undefined) {
		    	var rid = wuiUtil.getJsonValueByIndex(id1, 0);
		    	var rname = wuiUtil.getJsonValueByIndex(id1, 1);

				//$G("con"+id+"_valuespan").innerHTML = rname;
				//$G("con"+id+"_value").value = rid;
		        //$G("con"+id+"_name").value = rname;
			    
			    var sHtml = "";
				if (rid.indexOf(",") == 0) {
					rid = rid.substr(1);
					rname = rname.substr(1);
				}
				var idArray = rid.split(",");
				var nameArray = rname.split(",");
				for ( var _i = 0; _i < idArray.length; _i++) {
					var curid = idArray[_i];
					var curname = nameArray[_i];
					sHtml += wrapshowhtml($G("con"+id+"_value").getAttribute("viewtype"), 
							"<a title='" + curname + "' href='" + url + 
							curid + "' target='_new'>" + curname + "</a>&nbsp", curid);
				}
				jQuery($GetEle("con"+id+"_valuespan")).html(sHtml);
				$GetEle("con"+id+"_value").value = rid;

			    hoverShowNameSpan(".e8_showNameClass");
				try {
					var onppchgfnstr = jQuery("#"+ "con"+id+"_value").attr('onpropertychange');
					eval(onppchgfnstr);
					if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
						onpropertychange();
					}
				} catch (e) {
				}
				try {
					var onppchgfnstr = jQuery("#"+ "con"+id+"_value" + "__").attr('onpropertychange').toString();
					eval(onppchgfnstr);
					if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
						onpropertychange();
					}
				} catch (e) {
				}
			    
			}
		};
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";	
		dialog.Width = 550 ;
		dialog.Height = 600;
		dialog.Drag = true;
		dialog.show();
}

function onShowBrowser(id,url,type,_break_changeE8FnaWfOrgId_browserUrl) {
	if(_break_changeE8FnaWfOrgId_browserUrl==null){
		_break_changeE8FnaWfOrgId_browserUrl = false;
	}
	if(!_break_changeE8FnaWfOrgId_browserUrl && changeE8FnaWfOrgId_browserUrl(id)){
		return;
	}
	//var id1 = "";
	if(type=="224"||type=="225"||type=="226"||type=="227"){
		//id1 = window.showModalDialog(url,window);
	}else{
		url = url + "&selectedids=" + $G("con"+id+"_value").value;
		//id1 =window.showModalDialog(url + "&selectedids=" + $G("con"+id+"_value").value);
	}
	var dialogurl = url;
	var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.URL = dialogurl;
		dialog.callbackfun = function (paramobj, id1) {
			if (id1 != null) {
				var rid = wuiUtil.getJsonValueByIndex(id1, 0);
				var rname = wuiUtil.getJsonValueByIndex(id1, 1);
			    
			    var sHtml = "";
				if (rid.indexOf(",") == 0) {
					rid = rid.substr(1);
					rname = rname.substr(1);
				}
				var idArray = rid.split(",");
				var nameArray = rname.split(",");
				for ( var _i = 0; _i < idArray.length; _i++) {
					var curid = idArray[_i];
					var curname = nameArray[_i];
					sHtml += wrapshowhtml($G("con"+id+"_value").getAttribute("viewtype"), 
							"<a title='" + curname + "' href='" + url + 
							curid + "' target='_new'>" + curname + "</a>&nbsp", curid);
				}
				jQuery($GetEle("con"+id+"_valuespan")).html(sHtml);
				$GetEle("con"+id+"_value").value = rid;
			    
			    hoverShowNameSpan(".e8_showNameClass");
				try {
					var onppchgfnstr = jQuery("#"+ "con"+id+"_value").attr('onpropertychange');
					eval(onppchgfnstr);
					if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
						onpropertychange();
					}
				} catch (e) {
				}
				try {
					var onppchgfnstr = jQuery("#"+ "con"+id+"_value" + "__").attr('onpropertychange').toString();
					eval(onppchgfnstr);
					if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
						onpropertychange();
					}
				} catch (e) {
				}
			    
			}
		};
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
		dialog.Width = 550 ;
		dialog.Height = 600;
		dialog.Drag = true;
		dialog.show();
}

function onShowBrowserNew(id,url,type) {
	url = url + "&selectedids=" + $G("con"+id+"_value").value;
	var dialogurl = url;
	var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.URL = dialogurl;
		dialog.callbackfun = function (paramobj, id1) {
			if (id1 != null) {
				var rid = wuiUtil.getJsonValueByIndex(id1, 0);
				var rname = wuiUtil.getJsonValueByIndex(id1, 1);
			    
			    var sHtml = "";
				if (rid.indexOf(",") == 0) {
					rid = rid.substr(1);
					rname = rname.substr(1);
				}
				var idArray = rid.split(",");
				var nameArray = rname.split(",");
				for ( var _i = 0; _i < idArray.length; _i++) {
					var curid = idArray[_i];
					var curname = nameArray[_i];
					sHtml += wrapshowhtml($G("con"+id+"_value").getAttribute("viewtype"), curname, curid);
				}
				jQuery($GetEle("con"+id+"_valuespan")).html(sHtml);
				$GetEle("con"+id+"_value").value = rid;
			    
			    hoverShowNameSpan(".e8_showNameClass");
				try {
					var onppchgfnstr = jQuery("#"+ "con"+id+"_value").attr('onpropertychange');
					eval(onppchgfnstr);
					if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
						onpropertychange();
					}
				} catch (e) {
				}
				try {
					var onppchgfnstr = jQuery("#"+ "con"+id+"_value" + "__").attr('onpropertychange').toString();
					eval(onppchgfnstr);
					if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
						onpropertychange();
					}
				} catch (e) {
				}
			    
			}
		};
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
		dialog.Width = 550 ;
		dialog.Height = 600;
		dialog.Drag = true;
		dialog.show();
}

function wrapshowhtml(viewtype, ahtml, id) {
	var ismust = 1;
	if (viewtype == '1') {
		ismust = 2;
	}
	var str = "<span class=\"e8_showNameClass\">";
	str += ahtml;
	str += "<span class=\"e8_delClass\" id=\"" + id + "\" onclick=\"del(event,this," + ismust + ",false,{});\" style=\"opacity: 0; visibility: hidden;\">&nbsp;x&nbsp;</span></span>";
	return str;
}


function onShowBrowser1(id,url,type1) {
	var dialogurl = url;
	var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.URL = dialogurl;
		dialog.callbackfun = function (paramobj, id1) {
			if (id1 != null) {
				var rid = wuiUtil.getJsonValueByIndex(id1, 0);
				var rname = wuiUtil.getJsonValueByIndex(id1, 1);
				if (type1 == 1) {
					//$G("con"+id+"_valuespan").innerHTML = id1;
					//$G("con"+id+"_value").value=id1;
					
					var sHtml = "";
					if (rid.indexOf(",") == 0) {
						rid = rid.substr(1);
						rname = rname.substr(1);
					}
					var idArray = rid.split(",");
					var nameArray = rname.split(",");
					for ( var _i = 0; _i < idArray.length; _i++) {
						var curid = idArray[_i];
						var curname = nameArray[_i];
						sHtml += wrapshowhtml($G("con"+id+"_value").getAttribute("viewtype"), 
								"<a title='" + curname + "' href='" + url + 
								curid + "' target='_new'>" + curname + "</a>&nbsp", curid);
					}
					jQuery($GetEle("con"+id+"_valuespan")).html(sHtml);
					$GetEle("con"+id+"_value").value = rid;
				
				} else if( type1 == 2) {
					//$G("con"+id+"_value1span").innerHTML = id1;
					//$G("con"+id+"_value1").value=id1;
					
					var sHtml = "";
					if (rid.indexOf(",") == 0) {
						rid = rid.substr(1);
						rname = rname.substr(1);
					}
					var idArray = rid.split(",");
					var nameArray = rname.split(",");
					for ( var _i = 0; _i < idArray.length; _i++) {
						var curid = idArray[_i];
						var curname = nameArray[_i];
						sHtml += wrapshowhtml($G("con"+id+"_value1").getAttribute("viewtype"), 
								"<a title='" + curname + "' href='" + url + 
								curid + "' target='_new'>" + curname + "</a>&nbsp", curid);
					}
					jQuery($GetEle("con"+id+"_valuespan")).html(sHtml);
					$GetEle("con"+id+"_value1").value = rid;
				}
				
			    hoverShowNameSpan(".e8_showNameClass");
				try {
					var onppchgfnstr = jQuery("#"+ "con"+id+"_value").attr('onpropertychange');
					eval(onppchgfnstr);
					if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
						onpropertychange();
					}
				} catch (e) {
				}
				try {
					var onppchgfnstr = jQuery("#"+ "con"+id+"_value" + "__").attr('onpropertychange').toString();
					eval(onppchgfnstr);
					if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
						onpropertychange();
					}
				} catch (e) {
				}
			    
			}
		};
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
		dialog.Width = 550 ;
		dialog.Height = 600;
		dialog.Drag = true;
		dialog.show();
	
	
}

function onShowResourceConditionBrowser(id, url, type1) {
	var linkurl = "";
	var ismand=0;
	var tmpids = $GetEle("con" + id+"_value").value;
	//var dialogId = window.showModalDialog(url + "?resourceCondition=" + tmpids);
	url = url + "?resourceCondition=" + tmpids
	
	var dialogurl = url;
	var dialog = new window.top.Dialog();
		dialog.currentWindow = window;
		dialog.URL = dialogurl;
		dialog.callbackfun = function (paramobj, dialogId) {
			if ((dialogId)) {
				if (wuiUtil.getJsonValueByIndex(dialogId, 0) != "") {
					var shareTypeValues = wuiUtil.getJsonValueByIndex(dialogId, 0);
					var shareTypeTexts = wuiUtil.getJsonValueByIndex(dialogId, 1);
					var relatedShareIdses = wuiUtil.getJsonValueByIndex(dialogId, 2);
					var relatedShareNameses = wuiUtil.getJsonValueByIndex(dialogId, 3);
					var rolelevelValues = wuiUtil.getJsonValueByIndex(dialogId, 4);
					var rolelevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 5);
					var secLevelValues = wuiUtil.getJsonValueByIndex(dialogId, 6);
					var secLevelTexts = wuiUtil.getJsonValueByIndex(dialogId, 7);

					var sHtml = "";
					var fileIdValue = "";

					var shareTypeValueArray = shareTypeValues.split("~");
					var shareTypeTextArray = shareTypeTexts.split("~");
					var relatedShareIdseArray = relatedShareIdses.split("~");
					var relatedShareNameseArray = relatedShareNameses.split("~");
					var rolelevelValueArray = rolelevelValues.split("~");
					var rolelevelTextArray = rolelevelTexts.split("~");
					var secLevelValueArray = secLevelValues.split("~");
					var secLevelTextArray = secLevelTexts.split("~");
					for ( var _i = 0; _i < shareTypeValueArray.length; _i++) {

						var shareTypeValue = shareTypeValueArray[_i];
						var shareTypeText = shareTypeTextArray[_i];
						var relatedShareIds = relatedShareIdseArray[_i];
						var relatedShareNames = relatedShareNameseArray[_i];
						var rolelevelValue = rolelevelValueArray[_i];
						var rolelevelText = rolelevelTextArray[_i];
						var secLevelValue = secLevelValueArray[_i];
						var secLevelText = secLevelTextArray[_i];
						if (shareTypeValue == "") {
							continue;
						}
						fileIdValue = fileIdValue + "~" + shareTypeValue + "_"
								+ relatedShareIds + "_" + rolelevelValue + "_"
								+ secLevelValue;
						
						if (shareTypeValue == "1") {
							sHtml = sHtml + "," + shareTypeText + "("
									+ relatedShareNames + ")";
						} else if (shareTypeValue == "2") {
							sHtml = sHtml
									+ ","
									+ shareTypeText
									+ "("
									+ relatedShareNames
									+ ")"
									+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage()==0?7:user.getLanguage())%>>="
									+ secLevelValue
									+ "<%=SystemEnv.getHtmlLabelName(18941, user.getLanguage()==0?7:user.getLanguage())%>";
						} else if (shareTypeValue == "3") {
							sHtml = sHtml
									+ ","
									+ shareTypeText
									+ "("
									+ relatedShareNames
									+ ")"
									+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage()==0?7:user.getLanguage())%>>="
									+ secLevelValue
									+ "<%=SystemEnv.getHtmlLabelName(18942, user.getLanguage()==0?7:user.getLanguage())%>";
						} else if (shareTypeValue == "4") {
							sHtml = sHtml
									+ ","
									+ shareTypeText
									+ "("
									+ relatedShareNames
									+ ")"
									+ "<%=SystemEnv.getHtmlLabelName(3005, user.getLanguage()==0?7:user.getLanguage())%>="
									+ rolelevelText
									+ "  <%=SystemEnv.getHtmlLabelName(683, user.getLanguage()==0?7:user.getLanguage())%>>="
									+ secLevelValue
									+ "<%=SystemEnv.getHtmlLabelName(18945, user.getLanguage()==0?7:user.getLanguage())%>";
						} else {
							sHtml = sHtml
									+ ","
									+ "<%=SystemEnv.getHtmlLabelName(683, user.getLanguage()==0?7:user.getLanguage())%>>="
									+ secLevelValue
									+ "<%=SystemEnv.getHtmlLabelName(18943, user.getLanguage()==0?7:user.getLanguage())%>";
						}

					}
					
					sHtml = sHtml.substr(1);
					fileIdValue = fileIdValue.substr(1);

					//$GetEle("field" + id).value = fileIdValue;
					//$GetEle("field" + id + "span").innerHTML = sHtml;
					$G("con"+id+"_valuespan").innerHTML = sHtml;
			    	$G("con"+id+"_value").value= fileIdValue;
			    	$G("con"+id+"_name").value=sHtml;
				} 

			    hoverShowNameSpan(".e8_showNameClass");
				try {
					var onppchgfnstr = jQuery("#"+ "con"+id+"_value").attr('onpropertychange');
					eval(onppchgfnstr);
					if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
						onpropertychange();
					}
				} catch (e) {
				}
				try {
					var onppchgfnstr = jQuery("#"+ "con"+id+"_value" + "__").attr('onpropertychange').toString();
					eval(onppchgfnstr);
					if (onppchgfnstr.indexOf("function onpropertychange") != -1) {
						onpropertychange();
					}
				} catch (e) {
				}
			    
			}
		};
		dialog.Title = "<%=SystemEnv.getHtmlLabelName(18214,user.getLanguage())%>";
		dialog.Width = 550 ;
		dialog.Height = 600;
		dialog.Drag = true;
		dialog.show();
}

function resetReportForm() {
	//document.SearchForm.reset();
	var isselected = "#SearchForm";
	jQuery(isselected).find("input[type='text']").val("");
	//清空浏览按钮及对应隐藏域
	jQuery(isselected).find(".e8_os").find("span.e8_showNameClass").remove();
	jQuery(isselected).find(".e8_os").find("input[type='hidden']").val("");
	//清空下拉框

	//jQuery(isselected).find("select").selectbox("detach");
	jQuery(isselected).find("select").val("");
	jQuery(isselected).find("select").trigger("change");
	//beautySelect(jQuery(isselected).find("select"));
	//清空日期
	jQuery(isselected).find(".calendar").siblings("span").html("");
	jQuery(isselected).find(".calendar").siblings("input[type='hidden']").val("");
	
	jQuery(isselected).find("input[type='checkbox']").each(function(){
		jQuery(this).attr("checked",false);
		//changeCheckboxStatus(this,false);
	});
	
	<%if(mouldId != 0){%>
		location.href = "ReportCondition.jsp?id=<%=reportid%>&mouldId=<%=mouldId%>&newMouldName=<%=newMouldName%>";
	<%}%>
}

function getajaxurl(typeId){
	var url = "";
	var whereClause = "";
	if(typeId == "currentnodeBrowser"){
		var workflowid = jQuery("#con-12_value").val();
		//alert(workflowid);
		whereClause = "id IN( SELECT nodeid FROM workflow_flownode WHERE workflowid = "+workflowid+")";
		url = "/data.jsp?type=" + typeId+"&whereClause="+whereClause;
	}else{
		url = "/data.jsp?type=" + typeId;
	}
    return url;
}

function onchangeselect(){
	var changetype = jQuery("#templatetype").val();
	var str = $("#templatetype").find("option:selected").text();

	if(changetype == 0){
		location.href = "ReportCondition.jsp?id=<%=reportid%>";
	}else{
		location.href = "ReportCondition.jsp?id=<%=reportid%>&mouldId="+changetype+"&newMouldName="+str;
	}
}

function addTemplate(){
	var title = "<%=SystemEnv.getHtmlLabelName(18418,user.getLanguage())%>";
	var url = "/workflow/report/reportTemplateAdd.jsp";
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 400;
	diag_vote.Height = 180;
	diag_vote.Modal = true;
	diag_vote.Title = title;
	diag_vote.URL =url;
	diag_vote.isIframe=false;
	diag_vote.show();
}

function onDeleteTemplate(){
	 top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
		 jQuery.ajax({
				url:"ReportConditionOperation.jsp",
				type:"post",
				data:{
					operation:"deleteTemplate",
					reportId:"<%=reportid%>",
					mouldId:"<%=mouldId%>"
				},
				beforeSend:function(xhr){
					try{
						e8showAjaxTips("<%=SystemEnv.getHtmlLabelName(84024,user.getLanguage())%>",true);
					}catch(e){}
				},
				complete:function(xhr){
					e8showAjaxTips("",false);
				},
				success:function(data){
					window.location="ReportCondition.jsp?id=<%=reportid%>";
				}
			});
	 });	
	
}

</script>

<script>
	//add by Yuxf 2016-05-12 QC191648
	jQuery(function() {
		//获取当前页面所传入的select的值，如果为0表示默认模版
		var mouldId = "<%=mouldId%>";

		//如果不加这段代码，在某些情形下（偶发），页面重定向后select内的值没变，导致无法正确响应onchange事件，所以这里把option的value改成当前模版的值
		jQuery("#templatetype").attr("value",mouldId == "0" ? "0" : mouldId);
	});
</script>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/selectDateTime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
</BODY></HTML>

