<%@page import="java.util.HashMap"%>
<%@page import="weaver.fna.general.FnaCommon"%>
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

request.getSession().setAttribute("FnaSubmitRequestJsBorrow.jsp_____"+guid1+"_____"+user.getUID(), guid1);

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

HashMap<String, String> dataMap = new HashMap<String, String>();
FnaCommon.getFnaWfFieldInfo4Expense(workflowid, dataMap);

String main_fieldIdSqr = Util.null2String(dataMap.get("main_fieldIdSqr_fieldId"));
String main_fieldIdSqr_controlBorrowingWf = Util.null2String(dataMap.get("main_fieldIdSqr_controlBorrowingWf"));//还款流程中通过申请人字段控制可选择的借款流程

String dt1_fieldIdHklx = Util.null2String(dataMap.get("dt1_fieldIdHklx_fieldId"));
String dt1_fieldIdHkje = Util.null2String(dataMap.get("dt1_fieldIdHkje_fieldId"));
String dt1_fieldIdTzmx = Util.null2String(dataMap.get("dt1_fieldIdTzmx_fieldId"));

String dt2_fieldIdJklc = Util.null2String(dataMap.get("dt2_fieldIdJklc_fieldId"));
String dt2_fieldIdJkdh = Util.null2String(dataMap.get("dt2_fieldIdJkdh_fieldId"));
String dt2_fieldIdDnxh = Util.null2String(dataMap.get("dt2_fieldIdDnxh_fieldId"));
String dt2_fieldIdJkje = Util.null2String(dataMap.get("dt2_fieldIdJkje_fieldId"));
String dt2_fieldIdYhje = Util.null2String(dataMap.get("dt2_fieldIdYhje_fieldId"));
String dt2_fieldIdSpzje = Util.null2String(dataMap.get("dt2_fieldIdSpzje_fieldId"));
String dt2_fieldIdWhje = Util.null2String(dataMap.get("dt2_fieldIdWhje_fieldId"));
String dt2_fieldIdCxje = Util.null2String(dataMap.get("dt2_fieldIdCxje_fieldId"));

%>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=4"></script>
<script language="javascript">
var _____guid1 = "<%=guid1 %>";

var main_fieldIdSqr = "<%=main_fieldIdSqr %>";
var main_fieldIdSqr_controlBorrowingWf = "<%=main_fieldIdSqr_controlBorrowingWf %>";

var dt1_fieldIdHklx = "<%=dt1_fieldIdHklx %>";
var dt1_fieldIdHkje = "<%=dt1_fieldIdHkje %>";
var dt1_fieldIdTzmx = "<%=dt1_fieldIdTzmx %>";

var dt2_fieldIdJklc = "<%=dt2_fieldIdJklc %>";
var dt2_fieldIdJkdh = "<%=dt2_fieldIdJkdh %>";
var dt2_fieldIdDnxh = "<%=dt2_fieldIdDnxh %>";
var dt2_fieldIdJkje = "<%=dt2_fieldIdJkje %>";
var dt2_fieldIdYhje = "<%=dt2_fieldIdYhje %>";
var dt2_fieldIdSpzje = "<%=dt2_fieldIdSpzje %>";
var dt2_fieldIdWhje = "<%=dt2_fieldIdWhje %>";
var dt2_fieldIdCxje = "<%=dt2_fieldIdCxje %>";

var __workflowid = "<%=workflowid %>";

var __requestid = "<%=requestid %>";


function setDnxhValue(_jsonObj){
	var _objDnxh = jQuery("#field"+dt2_fieldIdDnxh+"_"+_jsonObj._dtlNumber);
	var _objSpanDnxh = jQuery("#field"+dt2_fieldIdDnxh+"_"+_jsonObj._dtlNumber+"span");

	var dnxhId = "";
	var dnxhName = "";
	if(_jsonObj!=null && _jsonObj.id!="" && _jsonObj.id!="0"){
		dnxhId = _jsonObj.id;
		dnxhName = _jsonObj.name;
	}

	_objDnxh.val(dnxhId);
	var _html = dnxhName;
	if(_html=="" && _objDnxh.attr("viewtype")=="1"){
		_html = "<img src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\">";
	}
	_objSpanDnxh.html(_html);
	
	getBorrowRequestInfo(_jsonObj._dtlNumber);
}

function onShowBrowser_fnaBorrowRequestDtl(_obj){
	var objId = _obj.id;
	var _fieldId = objId.split("_")[0];
	var _dtlNumber = objId.split("_")[1];

	var _objJklc = jQuery("#field"+dt2_fieldIdJklc+"_"+_dtlNumber);
	var jklc = _objJklc.val();

	var _w = 600;
	var _h = 360;
	_fnaOpenDialog("/fna/wfPage/dialogRequestDtlRowInfo.jsp?workflowid="+__workflowid+
			"&requestid="+__requestid+ 
			"&_dtlNumber="+_dtlNumber+
			"&main_fieldIdSqr_controlBorrowingWf="+main_fieldIdSqr_controlBorrowingWf+
			"&main_fieldIdSqr_value="+jQuery("#field"+main_fieldIdSqr).val()+
			"&jklc="+jklc, 
			"<%=SystemEnv.getHtmlLabelNames("18214",user.getLanguage()) %>", 
			_w, _h);
}

//browser回调方法
function wfbrowvaluechange_fna(obj, fieldid, rowindex) {
	if(fieldid==dt2_fieldIdJklc){
		var _objJklc = jQuery("#field"+dt2_fieldIdJklc+"_"+rowindex);
		var _objDnxh = jQuery("#field"+dt2_fieldIdDnxh+"_"+rowindex);
		var _objSpanDnxh = jQuery("#field"+dt2_fieldIdDnxh+"_"+rowindex+"span");

		var jklc = _objJklc.val();

		_objDnxh.val("");
		var _html = "";
		if(_objDnxh.attr("viewtype")=="1"){
			_html = "<img src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\">";
		}
		_objSpanDnxh.html(_html);
		
		getBorrowRequestInfo(rowindex);
	}
}

function getBorrowRequestInfo(rowindex){
	var _objJklc = jQuery("#field"+dt2_fieldIdJklc+"_"+rowindex);
	var _objDnxh = jQuery("#field"+dt2_fieldIdDnxh+"_"+rowindex);
	var _objJkdh = jQuery("#field"+dt2_fieldIdJkdh+"_"+rowindex);
	var _objJkje = jQuery("#field"+dt2_fieldIdJkje+"_"+rowindex);
	var _objYhje = jQuery("#field"+dt2_fieldIdYhje+"_"+rowindex);
	var _objSpzje = jQuery("#field"+dt2_fieldIdSpzje+"_"+rowindex);
	var _objWhje = jQuery("#field"+dt2_fieldIdWhje+"_"+rowindex);
	
	_objJkdh.val("");
	_objJkje.val("");
	_objYhje.val("");
	_objSpzje.val("");
	_objWhje.val("");
	
	
	var jklc = _objJklc.val();
	var dnxh = _objDnxh.val();
	
	jQuery.ajax({
		url : "/fna/wfPage/getBorrowRequestInfo.jsp",
		type : "post",
		processData : false,
		data : "_____guid1="+_____guid1+"&jklc="+jklc+"&dnxh="+dnxh+"&requestid="+__requestid,
		dataType : "json",
		success: function do4Success(fnainfo){
			if(fnainfo.flag){
				_objJkdh.val(fnainfo.requestmark);
				_objJkje.val(fnainfo.jkje);
				_objYhje.val(fnainfo.yhje);
				_objSpzje.val(fnainfo.spzje);
				_objWhje.val(fnainfo.whje);
				try{window.calSum(0);}catch(ex1){}
			}else{
				top.Dialog.alert(fnainfo.errorInfo);
			}
		}
	});
}

//调整明细1借款金额后的回调函数
function setTzsmValue(objId, amountBorrowBefore, amountBorrowAfter, memo1){
	var _fieldId = objId.split("_")[0];
	var _dtlNumber = objId.split("_")[1];

	memo1 = memo1._fnaReplaceAll("\"", "“");

	jQuery("#field"+dt1_fieldIdHkje+"_"+_dtlNumber).val(amountBorrowAfter);
	jQuery("#field"+dt1_fieldIdTzmx+"_"+_dtlNumber).val("{&quot;amountBorrowBefore&quot;:&quot;"+amountBorrowBefore+"&quot;,&quot;memo1&quot;:&quot;"+memo1+"&quot;}");
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
	_fnaOpenDialog("/fna/wfPage/dialogAmountOfHistoryQry.jsp?workflowid="+__workflowid+
			"&detailRecordId="+detailRecordId+
			"&requestid="+__requestid, 
			"<%=SystemEnv.getHtmlLabelNames("83",user.getLanguage()) %>", 
			_w, _h);
}


function fnaBorrowAmountDtl1_onFocus_onMouseover(_obj){
<%
if(isNeverSubmit){
%>
	jQuery(_obj).attr("readonly",false);
<%
}
%>
}

//调整明细
function fnaBorrowAmountDtl1_onclick(_obj){
<%
if(isNeverSubmit){
}else{
%>
	_obj.blur();
	var objId = _obj.id;
	var _fieldId = objId.split("_")[0];
	var _dtlNumber = objId.split("_")[1];
	
	var amountBorrowBefore = jQuery(_obj).attr("_dataBaseValue");
	var amountBorrowAfter = jQuery("#field"+dt1_fieldIdHkje+"_"+_dtlNumber).val();
	var memo1 = "";
	var jkmxStr = jQuery("#field"+dt1_fieldIdTzmx+"_"+_dtlNumber).val();
	//jkmxStr = "{\"amountBorrowBefore\":\"123.45\",\"memo1\":\"你好！\"}";
	if(jkmxStr!=""){
		jkmxStr = jkmxStr._fnaReplaceAll("&quot;", "\"");
		var jkmxJson = eval("("+jkmxStr+")");
		amountBorrowBefore = jkmxJson.amountBorrowBefore;
		memo1 = jkmxJson.memo1;
	}
	
	var _w = 600;
	var _h = 360;
	_fnaOpenDialog("/fna/wfPage/dialogAmountOfHistoryAdd.jsp?workflowid="+__workflowid+
			"&objId="+objId+
			"&amountBorrowBefore="+amountBorrowBefore+
			"&amountBorrowAfter="+amountBorrowAfter+
			"&memo1="+memo1+
			"&requestid="+__requestid, 
			"<%=SystemEnv.getHtmlLabelNames("83190",user.getLanguage()) %>", 
			_w, _h);
<%
}
%>
}

//jQuery(document).ready(function(){
	fnaifoverJson_doSubmit = function(obj){
		try{
			enableAllmenu();
			<%
			if(isNeverSubmit){
			%>
			var _xm_array0 = jQuery("input[name^='field"+dt1_fieldIdHkje+"_']");
			for(var i0=0;i0<_xm_array0.length;i0++){
				try{
					var _iptName = jQuery(_xm_array0[i0]).attr("name");
					var _iptNameArray = _iptName.split("_");
					if(_iptNameArray.length==2){
						var _idx = parseInt(_iptNameArray[1]);
						if(!isNaN(_idx) && _idx>=0 && jQuery("#field"+dt1_fieldIdHkje+"_"+_idx).length==1){
							jQuery("#field"+dt1_fieldIdTzmx+"_"+_idx).val("{&quot;amountBorrowBefore&quot;:&quot;"+""+"&quot;,&quot;memo1&quot;:&quot;"+""+"&quot;}");
					    }
					}
				}catch(e){}
			}
			<%
			}
			%>
			var temprequestid = __requestid;
			var poststr1 = "";
			var _xm_array1 = jQuery("input[name^='field"+dt1_fieldIdHkje+"_']");
			for(var i0=0;i0<_xm_array1.length;i0++){
				try{
					var _iptName = jQuery(_xm_array1[i0]).attr("name");
					var _iptNameArray = _iptName.split("_");
					if(_iptNameArray.length==2){
						var _idx = parseInt(_iptNameArray[1]);
						if(!isNaN(_idx) && _idx>=0 && jQuery("#field"+dt1_fieldIdHkje+"_"+_idx).length==1){
						    var hkje = fnaRound2(jQuery("#field"+dt1_fieldIdHkje+"_"+_idx).val(), 2);
						    if(poststr1!=""){
						    	poststr1 += "|";
						    }
						    poststr1 += hkje+",postStrEnd";
					    }
					}
				}catch(e){}
			}
			var poststr2 = "";
			var _xm_array2 = jQuery("input[name^='field"+dt2_fieldIdCxje+"_']");
			for(var i0=0;i0<_xm_array2.length;i0++){
				try{
					var _iptName = jQuery(_xm_array2[i0]).attr("name");
					var _iptNameArray = _iptName.split("_");
					if(_iptNameArray.length==2){
						var _idx = parseInt(_iptNameArray[1]);
						if(!isNaN(_idx) && _idx>=0 && jQuery("#field"+dt2_fieldIdCxje+"_"+_idx).length==1){
						    var cxje = fnaRound2(jQuery("#field"+dt2_fieldIdCxje+"_"+_idx).val(), 2);
						    var jklc = jQuery("#field"+dt2_fieldIdJklc+"_"+_idx).val();
						    var dnxh = jQuery("#field"+dt2_fieldIdDnxh+"_"+_idx).val();
						    if(poststr2!=""){
						    	poststr2 += "|";
						    }
						    poststr2 += cxje+","+jklc+","+dnxh+",postStrEnd";
					    }
					}
				}catch(e){}
			}
			if(poststr1!=""||poststr2!=""){
			}else{
				displayAllmenu();
				return doSubmitE8(obj);
			}
			jQuery.ajax({
				url : "/fna/wfPage/FnaifoverJsonAjaxRepayment.jsp",
				type : "post",
				processData : false,
				data : "poststr1="+poststr1+"&poststr2="+poststr2+"&requestid="+temprequestid+"&workflowid="+__workflowid,
				dataType : "json",
				success: function do4Success(fnainfo){
					if(fnainfo.flag){
						displayAllmenu();
						return doSubmitE8(obj);
					}else{
						var errorType = fnainfo.errorType;
						var errorInfo = fnainfo.errorInfo;
						if(errorInfo!=null){
							errorInfo = errorInfo.replace("\n","<br>");
						}else{
							errorInfo="";
						}
						if(errorType=="alert"){
							displayAllmenu();
							top.Dialog.alert(errorInfo);
							return;
						}else if(errorType=="confirm"){
							top.Dialog.confirm(errorInfo,
								function(){
									displayAllmenu();
									return doSubmitE8(obj);
								},function(){
									displayAllmenu();
									return;
								}
							);
						}else{
							displayAllmenu();
							top.Dialog.alert(errorInfo);
							return;
						}
					}
				}
			});	
		}catch(ex2){
			displayAllmenu();
			alert(ex2.message);
			return;
		}
	}
//});

jQuery(document).ready(function(){
});
</script>