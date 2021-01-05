<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.UUID"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.systeminfo.SystemEnv"%>

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
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=6"></script>
<script language="javascript">
var _____guid1 = "<%=guid1 %>";
var _____module = "<%=module %>";

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

var _isFnaSubmitRequestJs4MobileWf = 1;
var _FnaSubmitRequestJsRepayFlag = 1;
var _isNeverSubmit=<%=isNeverSubmit%>;


jQuery(document).ready(function(){
	loadJkmxLocation();
	
	jQuery("button[name='addbutton1']").bind("click",function(){
		bindfeeDtl2(1);
	});
	bindfeeDtl2(2);
});

function bindfeeDtl2(value){
    var _indexnum = 0;
    if(document.getElementById("nodenum1")){
		_indexnum = document.getElementById("nodenum1").value * 1.0 - 1;
    }
    if(_indexnum>=0){
    	if(value==1){
			var _jklcJQuery = jQuery("#field"+dt2_fieldIdJklc+"_"+_indexnum);
			if(_jklcJQuery.length==1){
				getBorrowRequestInfo(_indexnum);
			}
		}else if(value==2){
			var _xm_array = jQuery("input[name^='field"+dt2_fieldIdJklc+"_']");
			for(var i0=0;i0<_xm_array.length;i0++){
				var _iptName = jQuery(_xm_array[i0]).attr("name");
				var _iptNameArray = _iptName.split("_");
				if(_iptNameArray.length==2){
					var _idx = parseInt(_iptNameArray[1]);
					
					if(!isNaN(_idx) && _idx>=0){
						var _jklcJQuery = jQuery("#field"+dt2_fieldIdJklc+"_"+_idx);
						if(_jklcJQuery.length==1){
							getBorrowRequestInfo(_idx);
						}
					}
				}
			}
		}
	}
}

function loadJkmxLocation(){
	var _xm_array = jQuery("select[name^='field"+dt1_fieldIdHklx+"_']");
	if(_xm_array.length == 0){
		_xm_array = jQuery("input[name^='field"+dt1_fieldIdHklx+"_']");
	}
	for(var i0=0;i0<_xm_array.length;i0++){
		var _iptName = jQuery(_xm_array[i0]).attr("name");
		var _iptNameArray = _iptName.split("_");
		if(_iptNameArray.length==2){
			var _idx = parseInt(_iptNameArray[1]);
			getJkmxLocation(_idx, 0);
		}
	}
}

function getJkmxLocation(rowId, typeId){
	//typeId=0 手机版横排
	//typeId=1 手机版竖排
	var url2 = "/mobile/plugin/1/fna/wfPage/dialogAmountOfHistoryQry4Mobile.jsp";
	//借款历史弹出框
	//可编辑找下拉框,不可编辑找隐藏域
	var detailRecordId = jQuery("#field"+dt1_fieldIdHklx+"_"+rowId).attr("_detailRecordId");
	var __url = url2+"?workflowid="+__workflowid+"&detailRecordId="+detailRecordId+"&requestid="+__requestid;
	var __title2 = "<%=SystemEnv.getHtmlLabelName(2191,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%>";
	
	if(typeId == 1){
		jQuery("#field"+dt1_fieldIdTzmx+"_"+rowId+"_d").hide();
		jQuery("#field"+dt1_fieldIdTzmx+"_"+rowId+"_d").parent().append("<a href='#' onclick='showDialog_Fna(\""+__url+"\", \"\", null, \""+__title2+"\")'><%=SystemEnv.getHtmlLabelName(83211,user.getLanguage())%></a>");
	}else if(typeId == 0){
		if(jQuery("#"+dt1_fieldIdTzmx+rowId).length){
			//可编辑
			var isshowDiv = jQuery("#"+dt1_fieldIdTzmx+rowId).val();
			jQuery("#"+isshowDiv).html("<a href='#' onclick='showDialog_Fna(\""+__url+"\", \"\", null, \""+__title2+"\")'><%=SystemEnv.getHtmlLabelName(83211,user.getLanguage())%></a>");
		}else{
			jQuery("#field"+dt1_fieldIdTzmx+"_"+rowId+"_span").html("<a href='#' onclick='showDialog_Fna(\""+__url+"\", \"\", null, \""+__title2+"\")'><%=SystemEnv.getHtmlLabelName(83211,user.getLanguage())%></a>");
		}
	}
}

function dyeditPageFnaFyFun(groupid,rowId,fieldCount,isedit,isdisplay){
	if(groupid == 0){
		var url1 = "/mobile/plugin/1/fna/DialogAmtEdit4Mobile.jsp";
		var url2 = "/mobile/plugin/1/fna/wfPage/dialogAmountOfHistoryQry4Mobile.jsp";
		
		if(!_isNeverSubmit){
			//还款金额弹出框
			jQuery("#field"+dt1_fieldIdHkje+"_"+rowId+"_d").unbind('click').removeAttr('onclick').click(function(){
				var idArray = jQuery(this).attr("id").split("_");
				var _indexno = idArray[1];
				var amountBorrowBefore = jQuery("#field"+dt1_fieldIdHkje+"_"+_indexno).attr("_dataBaseValue");
				var amountBorrowAfter = jQuery("#field"+dt1_fieldIdHkje+"_"+_indexno+"_d").val();
				var memo1 = "";
				var jkmxStr = jQuery("#field"+dt1_fieldIdTzmx+"_"+_indexno).val();
				//jkmxStr = "{\"amountBorrowBefore\":\"123.45\",\"memo1\":\"你好！\"}";
				if(jkmxStr!=""){
					jkmxStr = jkmxStr._fnaReplaceAll("&quot;", "\"");
					var jkmxJson = eval("("+jkmxStr+")");
					amountBorrowBefore = jkmxJson.amountBorrowBefore;
					memo1 = jkmxJson.memo1;
				}
			   	var __url = url1+"?amountBorrowBefore="+amountBorrowBefore+"&amountBorrowAfter="+amountBorrowAfter+"&rowId="+_indexno+"&memo1="+memo1+"&wfType=2";
			   	showDialog_Fna(__url, "", null, "<%=SystemEnv.getHtmlLabelName(22098,user.getLanguage())%>");
			});
		}
		
		//还款历史弹出框
		getJkmxLocation(rowId, 1);
		
	}else if(groupid == 1){
		getBorrowRequestInfo(rowId);
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

function setTzsmValue(rowId, amountBorrowBefore, amountBorrowAfter, memo1){
	memo1 = memo1._fnaReplaceAll("\"", "“");
	
	//还款金额
	setFieldValue4Mobile(dt1_fieldIdHkje, amountBorrowAfter, amountBorrowAfter, rowId);
	
	//数据回写到还款明细（横排input）
	jQuery("#field"+dt1_fieldIdTzmx+"_"+rowId).attr("value","{&quot;amountBorrowBefore&quot;:&quot;"+amountBorrowBefore+"&quot;,&quot;memo1&quot;:&quot;"+memo1+"&quot;}");
}

function fnaRepayCallBack1(fieldID, fieldSpan, keys, vals, clickType) {
	//浏览按钮回调
	var _fieldID = "";
	var _indexno = "";
	var fieldIDArray = fieldID.split("_");
	if(fieldIDArray!=null && fieldIDArray.length>=2){
		_fieldID = fieldIDArray[0].replace("field","");
		_indexno = fieldIDArray[1];
	}
	
	getBorrowRequestInfo(_indexno);
}

function fnaRepayCallBack2(callbakdata, rowId) {
	//浏览按钮回调
	//_rownum为明细表排序号
	var _rownum = "";
	var _dtid = "";
	var array = callbakdata.split("_");
	if(array!=null && array.length==2){
		_rownum = array[0];
		_dtid = array[1];
	}

	setFieldValue4Mobile(dt2_fieldIdDnxh, _dtid, _rownum, rowId);
	
	getBorrowRequestInfo(rowId);
}

var _fna_flag_setPageAllButtonDisabled1 = true;
function _fna_flag_setPageAllButtonDisabled(){
	_fna_flag_setPageAllButtonDisabled1 = false;
}
function _fna_flag_setPageAllButtonEnable(){
	_fna_flag_setPageAllButtonDisabled1 = true;
}

function doSubmitFna4Mobile_Repay(){
	var returnval = "1";
	try{
		if(!_fna_flag_setPageAllButtonDisabled1){
			return "0";
		}
		_fna_flag_setPageAllButtonDisabled();
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
					    	poststr1 += ",s,";
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
					    	poststr2 += ",s,";
					    }
					    poststr2 += cxje+","+jklc+","+dnxh+",postStrEnd";
				    }
				}
			}catch(e){}
		}
		
		if(poststr1!=""||poststr2!=""){
		}else{
			returnval = "1";
		}
		jQuery.ajax({
			url : "/mobile/plugin/1/fna/wfpage/FnaifoverJsonAjaxRepayment4Mobile.jsp",
			type : "get",
			processData : false,
			async : false,
			data : "poststr1="+poststr1+"&poststr2="+poststr2+"&requestid="+temprequestid+"&workflowid="+__workflowid,
			dataType : "json",
			success: function do4Success(fnainfo){
				if(fnainfo.flag){
					returnval = "1";
					//return true;
				}else{
					var errorType = fnainfo.errorType;
					var errorInfo = fnainfo.errorInfo;
					if(errorInfo!=null){
						errorInfo = errorInfo.replace("\n","<br>");
					}else{
						errorInfo="";
					}
					if(errorType=="alert"){
						_fna_flag_setPageAllButtonEnable();
						returnval = "0";
						alert(errorInfo);
						//return false;
					}else if(errorType=="confirm"){
						confirm(errorInfo,
							function(){
								returnval = "1";
								//return true;
							},function(){
								_fna_flag_setPageAllButtonEnable();
								returnval = "0";
								//return false;
							}
						);
					}else{
						_fna_flag_setPageAllButtonEnable();
						alert(errorInfo);
						returnval = "0";
						//return false;
					}
				}
			}
		});	
	}catch(ex2){
		_fna_flag_setPageAllButtonEnable();
		alert(ex2.message);
		returnval = "0";
		//return false;
	}
	_fna_flag_setPageAllButtonEnable();
	return returnval;
}

function closeDialog() {
	jQuery.close("selectionWindow");
}

function showDialogDnxh4Mobile(_indexno){
	var url1 = "/mobile/plugin/1/fna/DialogDnxh4Mobile.jsp";
	var _jklc = jQuery("#field"+dt2_fieldIdJklc+"_"+_indexno+"_d").val();
	var __url = url1+"?workflowid="+__workflowid+"&requestid="+__requestid+"&jklc="+_jklc+
		"&main_fieldIdSqr_controlBorrowingWf="+main_fieldIdSqr_controlBorrowingWf+
		"&main_fieldIdSqr_value="+jQuery("#field"+main_fieldIdSqr).val()+
		"&rowId="+_indexno;
	showDialog_Fna(__url, "", null, "<%=SystemEnv.getHtmlLabelName(83285,user.getLanguage())%>");
}

function getBorrowRequestInfo(rowindex){
	jQuery("#field"+dt2_fieldIdDnxh+"_"+rowindex+"_d").attr("readonly",true);
	
	var _objJklc = jQuery("#field"+dt2_fieldIdJklc+"_"+rowindex);
	var _objDnxh = jQuery("#field"+dt2_fieldIdDnxh+"_"+rowindex);
	var _objJkdh = jQuery("#field"+dt2_fieldIdJkdh+"_"+rowindex);
	var _objJkje = jQuery("#field"+dt2_fieldIdJkje+"_"+rowindex);
	var _objYhje = jQuery("#field"+dt2_fieldIdYhje+"_"+rowindex);
	var _objSpzje = jQuery("#field"+dt2_fieldIdSpzje+"_"+rowindex);
	var _objWhje = jQuery("#field"+dt2_fieldIdWhje+"_"+rowindex);
	
	var jklc = _objJklc.val();
	var dnxh = _objDnxh.val();

	var _objJkdh_d = jQuery("#field"+dt2_fieldIdJkdh+"_"+rowindex+"_d");
	var _objJkje_d = jQuery("#field"+dt2_fieldIdJkje+"_"+rowindex+"_d");
	var _objYhje_d = jQuery("#field"+dt2_fieldIdYhje+"_"+rowindex+"_d");
	var _objSpzje_d = jQuery("#field"+dt2_fieldIdSpzje+"_"+rowindex+"_d");
	var _objWhje_d = jQuery("#field"+dt2_fieldIdWhje+"_"+rowindex+"_d");
	
	setFieldValue4Mobile(dt2_fieldIdJkdh, "", "", rowindex);
	setFieldValue4Mobile(dt2_fieldIdJkje, "", "", rowindex);
	setFieldValue4Mobile(dt2_fieldIdYhje, "", "", rowindex);
	setFieldValue4Mobile(dt2_fieldIdSpzje, "", "", rowindex);
	setFieldValue4Mobile(dt2_fieldIdWhje, "", "", rowindex);
	
	_objJkdh_d.attr("readonly",true);
	_objJkje_d.attr("readonly",true);
	_objYhje_d.attr("readonly",true);
	_objSpzje_d.attr("readonly",true);
	_objWhje_d.attr("readonly",true);

	if(fnaRound2(jklc,0)>0 && (fnaRound2(dnxh,0)>0 || _objJkdh.val()=="")){
		var _data = "_____guid1="+_____guid1+"&jklc="+jklc+"&dnxh="+dnxh+"&requestid="+__requestid;
		jQuery.ajax({
			url : "/mobile/plugin/1/fna/wfpage/getBorrowRequestInfo4Mobile.jsp",
			type : "post",
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(fnainfo){
				if(fnainfo.flag){
					setJklcMxRowValue(rowindex, fnainfo.requestmark, fnainfo.jkje, fnainfo.yhje, fnainfo.spzje, fnainfo.whje, dnxh, fnainfo.dnxhShowName);
					
				}else{
					alert(fnainfo.errorInfo);
				}
			}
		});
	}else{
		setJklcMxRowValue(rowindex, "", "", "", "", "", "", "");
	}
}

function setJklcMxRowValue(rowindex, requestmark, jkje, yhje, spzje, whje, dnxh, dnxhShowName){
	setFieldValue4Mobile(dt2_fieldIdJkdh, requestmark, requestmark, rowindex);
	setFieldValue4Mobile(dt2_fieldIdJkje, jkje, jkje, rowindex);
	setFieldValue4Mobile(dt2_fieldIdYhje, yhje, yhje, rowindex);
	setFieldValue4Mobile(dt2_fieldIdSpzje, spzje, spzje, rowindex);
	setFieldValue4Mobile(dt2_fieldIdWhje, whje, whje, rowindex);
	setFieldValue4Mobile(dt2_fieldIdDnxh, dnxh, dnxhShowName, rowindex, true);

	var _dnxhEditObjSpan = jQuery("#field"+dt2_fieldIdDnxh+"_"+rowindex+"_span_d");
	var _dnxh_type = jQuery("#field"+dt2_fieldIdDnxh+"_"+rowindex+"_d").attr("type");
	//创建单内序号按钮
	if(_dnxhEditObjSpan.length && _____module!="7" && _____module!="8" && _dnxh_type != null && _dnxh_type!="hidden"){
		var _dnxhEditObjSpanA = jQuery("#a_field"+dt2_fieldIdDnxh+"_"+rowindex+"_span_d");
		if(!_dnxhEditObjSpanA.length){
			_dnxhEditObjSpan.append("<a id='a_field"+dt2_fieldIdDnxh+"_"+rowindex+"_span_d' "+
				" style='margin-left: 10px;' "+
				" href='javascript:showDialogDnxh4Mobile("+rowindex+");'>"+
				"<%=SystemEnv.getHtmlLabelNames("172,83285",user.getLanguage()) %></a>");//选择单内序号
		}
	}
}

</script>