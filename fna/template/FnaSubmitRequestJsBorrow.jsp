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

request.getSession().setAttribute("FnaSubmitRequestJsBorrow.jsp_____"+guid1+"_____"+user.getUID(), guid1);

RecordSet rs = new RecordSet();
int requestid = Util.getIntValue(request.getParameter("requestid"),0);
int workflowid = Util.getIntValue(request.getParameter("workflowid"),0);

int LoanRepaymentAnalysisInnerDetaile = Util.getIntValue(request.getParameter("LoanRepaymentAnalysisInnerDetaile"),0);

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

String main_fieldIdSqr = Util.null2String(dataMap.get("main_fieldIdSqr_fieldId"));

String dt1_fieldIdJklx = Util.null2String(dataMap.get("dt1_fieldIdJklx_fieldId"));
String dt1_fieldIdJkje = Util.null2String(dataMap.get("dt1_fieldIdJkje_fieldId"));
String dt1_fieldIdJkmx = Util.null2String(dataMap.get("dt1_fieldIdJkmx_fieldId"));

String dt2_fieldIdSkfs = Util.null2String(dataMap.get("dt2_fieldIdSkfs_fieldId"));
String dt2_fieldIdSkje = Util.null2String(dataMap.get("dt2_fieldIdSkje_fieldId"));
String dt2_fieldIdKhyh = Util.null2String(dataMap.get("dt2_fieldIdKhyh_fieldId"));
String dt2_fieldIdHuming = Util.null2String(dataMap.get("dt2_fieldIdHuming_fieldId"));
String dt2_fieldIdSkzh = Util.null2String(dataMap.get("dt2_fieldIdSkzh_fieldId"));

%>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=5"></script>
<script language="javascript">
var _____guid1 = "<%=guid1 %>";

var LoanRepaymentAnalysisInnerDetaile = "<%=LoanRepaymentAnalysisInnerDetaile %>";

var main_fieldIdSqr = "<%=main_fieldIdSqr %>";

var dt1_fieldIdJklx = "<%=dt1_fieldIdJklx %>";
var dt1_fieldIdJkje = "<%=dt1_fieldIdJkje %>";
var dt1_fieldIdJkmx = "<%=dt1_fieldIdJkmx %>";

var dt2_fieldIdSkfs = "<%=dt2_fieldIdSkfs %>";
var dt2_fieldIdSkje = "<%=dt2_fieldIdSkje %>";
var dt2_fieldIdKhyh = "<%=dt2_fieldIdKhyh %>";
var dt2_fieldIdHuming = "<%=dt2_fieldIdHuming %>";
var dt2_fieldIdSkzh = "<%=dt2_fieldIdSkzh %>";

var __workflowid = "<%=workflowid %>";

var __requestid = "<%=requestid %>";



//browser回调方法
function wfbrowvaluechange_fna(obj, fieldid, rowindex) {
	if(main_fieldIdSqr==fieldid){
		var _xm_array0 = jQuery("select[name^='field"+dt2_fieldIdSkfs+"_']");
		for(var i0=0;i0<_xm_array0.length;i0++){
			try{
				var _iptName = jQuery(_xm_array0[i0]).attr("name");
				var _iptNameArray = _iptName.split("_");
				if(_iptNameArray.length==2){
					var _idx = parseInt(_iptNameArray[1]);
					if(!isNaN(_idx) && _idx>=0 && jQuery("#field"+dt2_fieldIdSkfs+"_"+_idx).length==1){
						var _skfsJQuery = jQuery("#field"+dt2_fieldIdSkfs+"_"+_idx);
						if(_skfsJQuery.length==0){
							_skfsJQuery = jQuery("#disfield"+dt2_fieldIdSkfs+"_"+_idx);
						}
					    var skfs = _skfsJQuery.val();
						if(skfs=="1" && _skfsJQuery.length==1){
							_fnaBorrowSkfsDtl2_onchange(_skfsJQuery[0]);
						}
				    }
				}
			}catch(e){}
		}
	}
}

//调整明细2收款方式后的回调函数
function _fnaBorrowSkfsDtl2_onchange(_obj, _notUpdateVal){
	if(_notUpdateVal==null){//是否不更新账户信息
		_notUpdateVal = false;
	}
	var objId = _obj.id;
	var _fieldId = objId.split("_")[0];
	var _dtlNumber = objId.split("_")[1];

	var objKhyh = jQuery("#field"+dt2_fieldIdKhyh+"_"+_dtlNumber);
	var objHuming = jQuery("#field"+dt2_fieldIdHuming+"_"+_dtlNumber);
	var objSkzh = jQuery("#field"+dt2_fieldIdSkzh+"_"+_dtlNumber);

	if(!_notUpdateVal){
		objKhyh.val("");
		objHuming.val("");
		objSkzh.val("");
	}

	var sqr = jQuery("#field"+main_fieldIdSqr).val();

	var skfs = jQuery(_obj).val();
	if(skfs=="1"){
		objKhyh.show();
		objHuming.show();
		objSkzh.show();

		if(!_notUpdateVal){
			jQuery.ajax({
				url : "/fna/wfPage/mainBorrowSqrInfo.jsp",
				type : "post",
				processData : false,
				data : "_____guid1="+_____guid1+"&sqr="+sqr,
				dataType : "json",
				success: function do4Success(fnainfo){
					if(fnainfo.flag){
						objKhyh.val(fnainfo.Khyh);
						objHuming.val(fnainfo.Huming);
						objSkzh.val(fnainfo.Skzh);
					}else{
						top.Dialog.alert(fnainfo.errorInfo);
					}
				}
			});	
		}
	}else{
		objKhyh.hide();
		objHuming.hide();
		objSkzh.hide();
	}
	
}

//调整明细1借款金额后的回调函数
function setTzsmValue(objId, amountBorrowBefore, amountBorrowAfter, memo1){
	var _fieldId = objId.split("_")[0];
	var _dtlNumber = objId.split("_")[1];

	memo1 = memo1._fnaReplaceAll("\"", "“");

	jQuery("#field"+dt1_fieldIdJkje+"_"+_dtlNumber).val(amountBorrowAfter);
	jQuery("#field"+dt1_fieldIdJkmx+"_"+_dtlNumber).val("{&quot;amountBorrowBefore&quot;:&quot;"+amountBorrowBefore+"&quot;,&quot;memo1&quot;:&quot;"+memo1+"&quot;}");
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

//查看相关还款流程
function showRelatedProcess_onclick(_obj){
	_obj.blur();
	var objId = _obj.id;
	var _fieldId = objId.split("_")[0];
	var _dtlNumber = objId.split("_")[1];

	var detailRecordId = jQuery(_obj).attr("_detailRecordId");
	
	var _url = "/workflow/search/WFCustomSearchMiddleHandler.jsp?offical=&officalType=-1&fromleftmenu=-1&typeid=&workflowid="+
		"&_isFromShowRelatedProcess=1"+
		"&_borrowDetailRecordId="+detailRecordId+
		"&_borrowRequestid="+__requestid+
		"&LoanRepaymentAnalysisInnerDetaile="+LoanRepaymentAnalysisInnerDetaile; 
	_fnaOpenFullWindow(_url);
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
	var amountBorrowAfter = jQuery("#field"+dt1_fieldIdJkje+"_"+_dtlNumber).val();
	var memo1 = "";
	var jkmxStr = jQuery("#field"+dt1_fieldIdJkmx+"_"+_dtlNumber).val();
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


function bindfeeDtl2(value){
    var _indexnum = 0;
    if(document.getElementById("indexnum1")){
		_indexnum = document.getElementById("indexnum1").value * 1.0 - 1;
    }
    //alert("bindfeeDtl2 _indexnum="+_indexnum+";value="+value);
    if(_indexnum>=0){
    	if(value==1){
			var _skfsJQuery = jQuery("#field"+dt2_fieldIdSkfs+"_"+_indexnum);
			if(_skfsJQuery.length==0){
				_skfsJQuery = jQuery("#disfield"+dt2_fieldIdSkfs+"_"+_indexnum);
			}
			if(_skfsJQuery.length==1){
				_fnaBorrowSkfsDtl2_onchange(_skfsJQuery[0]);
			}
		}else if(value==2){
			var _xm_array = jQuery("select[name^='field"+dt2_fieldIdSkfs+"_']");
			if(_xm_array.length==0){
				_xm_array = jQuery("select[name^='disfield"+dt2_fieldIdSkfs+"_']");
			}
			for(var i0=0;i0<_xm_array.length;i0++){
				var _iptName = jQuery(_xm_array[i0]).attr("name");
				var _iptNameArray = _iptName.split("_");
				if(_iptNameArray.length==2){
					var _idx = parseInt(_iptNameArray[1]);
					if(!isNaN(_idx) && _idx>=0){
						var _skfsJQuery = jQuery("#field"+dt2_fieldIdSkfs+"_"+_idx);
						if(_skfsJQuery.length==0){
							_skfsJQuery = jQuery("#disfield"+dt2_fieldIdSkfs+"_"+_idx);
						}
						if(_skfsJQuery.length==1){
							var _notUpdateVal = false;
							if(parseInt(_skfsJQuery.attr("_detailRecordId")) > 0){
								_notUpdateVal = true;
							}
							_fnaBorrowSkfsDtl2_onchange(_skfsJQuery[0], _notUpdateVal);
						}
					}
				}
			}
		}
	}
}


//jQuery(document).ready(function(){
	fnaifoverJson_doSubmit = function(obj){
		try{
			enableAllmenu();
			<%
			if(isNeverSubmit){
			%>
			var _xm_array0 = jQuery("input[name^='field"+dt1_fieldIdJkje+"_']");
			for(var i0=0;i0<_xm_array0.length;i0++){
				try{
					var _iptName = jQuery(_xm_array0[i0]).attr("name");
					var _iptNameArray = _iptName.split("_");
					if(_iptNameArray.length==2){
						var _idx = parseInt(_iptNameArray[1]);
						if(!isNaN(_idx) && _idx>=0 && jQuery("#field"+dt1_fieldIdJkje+"_"+_idx).length==1){
							jQuery("#field"+dt1_fieldIdJkmx+"_"+_idx).val("{&quot;amountBorrowBefore&quot;:&quot;"+""+"&quot;,&quot;memo1&quot;:&quot;"+""+"&quot;}");
					    }
					}
				}catch(e){}
			}
			<%
			}
			%>
			var temprequestid = __requestid;
			var poststr1 = "";
			var _xm_array1 = jQuery("input[name^='field"+dt1_fieldIdJkje+"_']");
			for(var i0=0;i0<_xm_array1.length;i0++){
				try{
					var _iptName = jQuery(_xm_array1[i0]).attr("name");
					var _iptNameArray = _iptName.split("_");
					if(_iptNameArray.length==2){
						var _idx = parseInt(_iptNameArray[1]);
						if(!isNaN(_idx) && _idx>=0 && jQuery("#field"+dt1_fieldIdJkje+"_"+_idx).length==1){
						    var jkje = fnaRound2(jQuery("#field"+dt1_fieldIdJkje+"_"+_idx).val(), 2);
						    if(poststr1!=""){
						    	poststr1 += "|";
						    }
						    poststr1 += jkje+",postStrEnd";
					    }
					}
				}catch(e){}
			}
			var poststr2 = "";
			var _xm_array2 = jQuery("input[name^='field"+dt2_fieldIdSkje+"_']");
			for(var i0=0;i0<_xm_array2.length;i0++){
				try{
					var _iptName = jQuery(_xm_array2[i0]).attr("name");
					var _iptNameArray = _iptName.split("_");
					if(_iptNameArray.length==2){
						var _idx = parseInt(_iptNameArray[1]);
						if(!isNaN(_idx) && _idx>=0 && jQuery("#field"+dt2_fieldIdSkje+"_"+_idx).length==1){
						    var skje = fnaRound2(jQuery("#field"+dt2_fieldIdSkje+"_"+_idx).val(), 2);
						    if(poststr2!=""){
						    	poststr2 += "|";
						    }
						    poststr2 += skje+",postStrEnd";
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
				url : "/fna/wfPage/FnaifoverJsonAjaxBorrow.jsp",
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
	jQuery("button[name='addbutton1']").bind("click",function(){
		bindfeeDtl2(1);
    });
	bindfeeDtl2(2);
});
</script>