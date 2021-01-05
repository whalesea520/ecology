<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="java.util.UUID"%>

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
String module = Util.null2String(request.getParameter("module")).trim();
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
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=6"></script>
<script language="javascript">
var _____guid1 = "<%=guid1 %>";
var _____module = "<%=module %>";

var dt1_fieldIdYfkje = "<%=dt1_fieldIdYfkje %>";
var dt1_fieldIdYfkmx = "<%=dt1_fieldIdYfkmx %>";

var __workflowid = "<%=workflowid %>";
var __requestid = "<%=requestid %>";

var _isNeverSubmit = <%=isNeverSubmit%>;
var _isFnaSubmitRequestJs4MobileWf = 1;
var _FnaSubmitRequestJsAdvanceFlag = 1;


jQuery(document).ready(function(){
});

function dyeditPageFnaFyFun(groupid,rowId,fieldCount,isedit,isdisplay){
	if(groupid == 0){
		var url1 = "/mobile/plugin/1/fna/DialogAdvanceAmtEdit4Mobile.jsp";
		var url2 = "/mobile/plugin/1/fna/wfPage/dialogAdvanceAmountOfHistoryQry4Mobile.jsp";
		
		if(!_isNeverSubmit){
			//借款金额弹出框
			jQuery("#field"+dt1_fieldIdYfkje+"_"+rowId+"_d").unbind('click').removeAttr('onclick').click(function(){
				var idArray = jQuery(this).attr("id").split("_");
				var _indexno = idArray[1];
				var amountAdvanceBefore = jQuery("#field"+dt1_fieldIdYfkje+"_"+_indexno).attr("_dataBaseValue");
				var amountAdvanceAfter = jQuery("#field"+dt1_fieldIdYfkje+"_"+_indexno+"_d").val();
				var memo1 = "";
				var yfkmxStr = jQuery("#field"+dt1_fieldIdYfkmx+"_"+_indexno).val();
				//yfkmxStr = "{\"amountAdvanceBefore\":\"123.45\",\"memo1\":\"你好！\"}";
				if(yfkmxStr!=""){
					yfkmxStr = yfkmxStr._fnaReplaceAll("&quot;", "\"");
					var yfkmxJson = eval("("+yfkmxStr+")");
					amountAdvanceBefore = yfkmxJson.amountAdvanceBefore;
					memo1 = yfkmxJson.memo1;
				}
			   	
			   	var __url = url1+"?amountAdvanceBefore="+amountAdvanceBefore+"&amountAdvanceAfter="+amountAdvanceAfter+"&rowId="+_indexno+"&memo1="+memo1+"&wfType=1";
			   	showDialog_Fna(__url, "", null, "<%=SystemEnv.getHtmlLabelName(1043,user.getLanguage())%>");
		   });
		}
	}
}

function showDialog_Fna(url, data, isHtml,titleT) {
	var top = ($( window ).height()-150)/2;
	var width = window.innerWidth > 480 ? 480 : window.innerWidth - 20;
	$.open({
		id : "selectionWindow",
		url : url,
		title : titleT,
		width : width,
		height :$( window ).height()/2,
		scrolling:'yes',
		top: top,
		callback : function(action, returnValue){
		}
	}); 
	$.reload('selectionWindow', url);
	
	return false;
}

function setTzsmValue(rowId, amountAdvanceBefore, amountAdvanceAfter, memo1){
	memo1 = memo1._fnaReplaceAll("\"", "“");
	
	//借款金额
	setFieldValue4Mobile(dt1_fieldIdYfkje, amountAdvanceAfter, amountAdvanceAfter, rowId);
	
	//数据回写到借款明细（横排input）
	jQuery("#field"+dt1_fieldIdYfkmx+"_"+rowId).attr("value","{&quot;amountAdvanceBefore&quot;:&quot;"+amountAdvanceBefore+"&quot;,&quot;memo1&quot;:&quot;"+memo1+"&quot;}");
}

function closeDialog() {
	jQuery.close("selectionWindow");
}

</script>