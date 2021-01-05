<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.UUID"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String guid1 = UUID.randomUUID().toString();

User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

request.getSession().setAttribute("FnaSubmitRequestJsAdvance.jsp_____"+guid1+"_____"+user.getUID(), guid1);

RecordSet rs = new RecordSet();
int requestid = Util.getIntValue(request.getParameter("requestid"),0);
int workflowid = Util.getIntValue(request.getParameter("workflowid"),0);
int formid = 0;
int currentnodetype = 0;
boolean isNeverSubmit = false;//流程从未提交下去标志位

if(workflowid <= 0){
	rs.executeSql("select workflowid, currentnodetype from workflow_requestbase where requestid = "+requestid);
	if(rs.next()){
		workflowid = Util.getIntValue(rs.getString("workflowid"), 0);
		currentnodetype = Util.getIntValue(rs.getString("currentnodetype"), 0);
	}
}
if(requestid > 0 && currentnodetype==0){
	rs.executeSql("select count(*) cnt from workflow_requestLog a where a.logtype <> '1' and a.requestid = "+requestid);
	if(rs.next() && rs.getInt("cnt") == 0){
		isNeverSubmit = true;
	}
}else{
	isNeverSubmit = true;
}

Map<String, String> dataMap = new HashMap<String, String>();
FnaCommon.getFnaWfFieldInfo4Expense(workflowid, dataMap);

String dt1_fieldIdYfkje = Util.null2String(dataMap.get("dt1_fieldIdYfkje_fieldId"));
String dt1_fieldIdYfkmx = Util.null2String(dataMap.get("dt1_fieldIdYfkmx_fieldId"));

%>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=5"></script>
<script language="javascript">
var _____guid1 = "<%=guid1 %>";

var dt1_fieldIdYfkje = "<%=dt1_fieldIdYfkje %>";
var dt1_fieldIdYfkmx = "<%=dt1_fieldIdYfkmx %>";

var __workflowid = "<%=workflowid %>";

var __requestid = "<%=requestid %>";



//browser回调方法
function wfbrowvaluechange_fna(obj, fieldid, rowindex) {
}

//调整明细1借款金额后的回调函数
function setTzsmValue(objId, amountAdvanceBefore, amountAdvanceAfter, memo1){
	var _fieldId = objId.split("_")[0];
	var _dtlNumber = objId.split("_")[1];

	memo1 = memo1._fnaReplaceAll("\"", "“");

	jQuery("#field"+dt1_fieldIdYfkje+"_"+_dtlNumber).val(amountAdvanceAfter);
	jQuery("#field"+dt1_fieldIdYfkmx+"_"+_dtlNumber).val("{&quot;amountAdvanceBefore&quot;:&quot;"+amountAdvanceBefore+"&quot;,&quot;memo1&quot;:&quot;"+memo1+"&quot;}");
}

//调整明细日志
function showAmountOfHistory_onclick(_obj){
	_obj.blur();
	var objId = _obj.id;
	var _fieldId = objId.split("_")[0];
	var _dtlNumber = objId.split("_")[1];

	var detailRecordId = jQuery(_obj).attr("_detailRecordId");

	var _w = 600;
	var _h = 360;
	_fnaOpenDialog("/fna/wfPage/dialogAdvanceAmountOfHistoryQry.jsp?workflowid="+__workflowid+
			"&detailRecordId="+detailRecordId+
			"&requestid="+__requestid, 
			"<%=SystemEnv.getHtmlLabelNames("83",user.getLanguage()) %>", 
			_w, _h);
}

function fnaAdvanceAmountDtl1_onFocus_onMouseover(_obj){
<%
if(isNeverSubmit){
%>
	jQuery(_obj).attr("readonly",false);
<%
}
%>
}

//调整明细
function fnaAdvanceAmountDtl1_onclick(_obj){
<%
if(isNeverSubmit){
}else{
%>
	_obj.blur();
	var objId = _obj.id;
	var _fieldId = objId.split("_")[0];
	var _dtlNumber = objId.split("_")[1];
	
	var amountAdvanceBefore = jQuery(_obj).attr("_dataBaseValue");
	var amountAdvanceAfter = jQuery("#field"+dt1_fieldIdYfkje+"_"+_dtlNumber).val();
	var memo1 = "";
	var yfkmxStr = jQuery("#field"+dt1_fieldIdYfkmx+"_"+_dtlNumber).val();
	if(yfkmxStr!=""){
		yfkmxStr = yfkmxStr._fnaReplaceAll("&quot;", "\"");
		var yfkmxJson = eval("("+yfkmxStr+")");
		amountAdvanceBefore = yfkmxJson.amountAdvanceBefore;
		memo1 = yfkmxJson.memo1;
	}
	
	var _w = 600;
	var _h = 360;
	_fnaOpenDialog("/fna/wfPage/dialogAdvanceAmountOfHistoryAdd.jsp?workflowid="+__workflowid+
			"&objId="+objId+
			"&amountAdvanceBefore="+amountAdvanceBefore+
			"&amountAdvanceAfter="+amountAdvanceAfter+
			"&memo1="+memo1+
			"&requestid="+__requestid, 
			"<%=SystemEnv.getHtmlLabelNames("83190",user.getLanguage()) %>", 
			_w, _h);
<%
}
%>
}

jQuery(document).ready(function(){
});
</script>