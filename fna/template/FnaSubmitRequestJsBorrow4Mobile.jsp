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
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=6"></script>
<script language="javascript">
var _____guid1 = "<%=guid1 %>";
var _____module = "<%=module %>";

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

var _isNeverSubmit = <%=isNeverSubmit%>;
var _isFnaSubmitRequestJs4MobileWf = 1;
var _FnaSubmitRequestJsBorrowFlag = 1;


jQuery(document).ready(function(){
	jQuery("button[name='addbutton0']").bind("click",function(){
		bindfeeDtl1(1);
	});
	bindfeeDtl1(2);

	jQuery("button[name='addbutton1']").bind("click",function(){
		bindfeeDtl2(1);
    });
	bindfeeDtl2(2);
});

function bindfeeDtl1(value){
	var _indexnum = 0;
	if(document.getElementById("nodenum0")){
		_indexnum = document.getElementById("nodenum0").value * 1.0 - 1;
	}
	if(_indexnum>=0){
		if(value==1){
			var _skfsJQuery = jQuery("#field"+dt1_fieldIdJkje+"_"+_indexnum);
			if(_skfsJQuery.length==1){
				getJkmxLocation(_indexnum, 0);
			}
		}else if(value==2){
			var _xm_array = jQuery("select[name^='field"+dt1_fieldIdJkje+"_']");
			if(_xm_array.length == 0){
				_xm_array = jQuery("input[name^='field"+dt1_fieldIdJkje+"_']");
			}
			for(var i0=0;i0<_xm_array.length;i0++){
				var _iptName = jQuery(_xm_array[i0]).attr("name");
				var _iptNameArray = _iptName.split("_");
				if(_iptNameArray.length==2){
					var _idx = parseInt(_iptNameArray[1]);
					if(!isNaN(_idx) && _idx>=0){
						getJkmxLocation(_idx, 0);
					}
				}
			}
		}
	}
}

function bindfeeDtl2(value){
    var _indexnum = 0;
    if(document.getElementById("nodenum1")){
		_indexnum = document.getElementById("nodenum1").value * 1.0 - 1;
    }
    //alert("bindfeeDtl2 _indexnum="+_indexnum+";value="+value);
    if(_indexnum>=0){
    	if(value==1){
			var _skfsJQuery = jQuery("#field"+dt2_fieldIdSkfs+"_"+_indexnum);
			if(_skfsJQuery.length==1){
				_fnaBorrowSkfsDtl2_onchange(_skfsJQuery[0], _indexnum);
			}
		}else if(value==2){
			var _xm_array = jQuery("select[name^='field"+dt2_fieldIdSkfs+"_']");
			if(_xm_array.length == 0){
				_xm_array = jQuery("input[name^='field"+dt2_fieldIdSkfs+"_']");
			}
			for(var i0=0;i0<_xm_array.length;i0++){
				var _iptName = jQuery(_xm_array[i0]).attr("name");
				var _iptNameArray = _iptName.split("_");
				if(_iptNameArray.length==2){
					var _idx = parseInt(_iptNameArray[1]);
					if(!isNaN(_idx) && _idx>=0){
						var _skfsJQuery = jQuery("#field"+dt2_fieldIdSkfs+"_"+_idx);
						if(_skfsJQuery.length==1){
							_fnaBorrowSkfsDtl2_onchange(_skfsJQuery[0], _idx);
						}
					}
				}
			}
		}
	}
}

function getJkmxLocation(rowId, typeId){
	//typeId=0 手机版横排
	//typeId=1 手机版竖排
	var url2 = "/mobile/plugin/1/fna/wfPage/dialogAmountOfHistoryQry4Mobile.jsp";
	//借款历史弹出框
	//可编辑找下拉框,不可编辑找隐藏域
	var detailRecordId = jQuery("#field"+dt1_fieldIdJklx+"_"+rowId).attr("_detailRecordId");
	var __url = url2+"?workflowid="+__workflowid+"&detailRecordId="+detailRecordId+"&requestid="+__requestid;
	var __title2 = "<%=SystemEnv.getHtmlLabelName(2191,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(83,user.getLanguage())%>";
	
	if(typeId == 1){
		jQuery("#field"+dt1_fieldIdJkmx+"_"+rowId+"_d").hide();
		jQuery("#field"+dt1_fieldIdJkmx+"_"+rowId+"_d").parent().append("<a href='#' onclick='showDialog_Fna(\""+__url+"\", \"\", null, \""+__title2+"\")'><%=SystemEnv.getHtmlLabelName(83211,user.getLanguage())%></a>");
	}else if(typeId == 0){
		if(jQuery("#"+dt1_fieldIdJkmx+rowId).length){
			//可编辑
			var isshowDiv = jQuery("#"+dt1_fieldIdJkmx+rowId).val();
			jQuery("#"+isshowDiv).html("<a href='#' onclick='showDialog_Fna(\""+__url+"\", \"\", null, \""+__title2+"\")'><%=SystemEnv.getHtmlLabelName(83211,user.getLanguage())%></a>");
		}else{
			jQuery("#field"+dt1_fieldIdJkmx+"_"+rowId+"_span").html("<a href='#' onclick='showDialog_Fna(\""+__url+"\", \"\", null, \""+__title2+"\")'><%=SystemEnv.getHtmlLabelName(83211,user.getLanguage())%></a>");
		}
	}
}

function _fnaBorrowSkfsDtl2_onchange(obj, _indexno){
	var _Skfs = jQuery(obj).val();
	if(_Skfs == '1'){
		var __Khyh = jQuery("#field"+dt2_fieldIdKhyh+"_"+_indexno).val();
		var __Huming = jQuery("#field"+dt2_fieldIdHuming+"_"+_indexno).val();
		var __Skzh = jQuery("#field"+dt2_fieldIdSkzh+"_"+_indexno).val();
		
		if(__Khyh=='' && __Huming=='' && __Skzh==''){
			var sqr = jQuery("#field"+main_fieldIdSqr).val();
			jQuery.ajax({
				url : "/mobile/plugin/1/fna/wfpage/mainBorrowSqrInfo4Mobile.jsp",
				type : "get",
				processData : false,
				data : "_____guid1="+_____guid1+"&sqr="+sqr,
				dataType : "json",
				success: function do4Success(fnainfo){
					if(fnainfo.flag){
						setFieldValue4Mobile(dt2_fieldIdKhyh, fnainfo.Khyh, fnainfo.Khyh, _indexno);
						setFieldValue4Mobile(dt2_fieldIdHuming, fnainfo.Huming, fnainfo.Huming, _indexno);
						setFieldValue4Mobile(dt2_fieldIdSkzh, fnainfo.Skzh, fnainfo.Skzh, _indexno);
					}else{
						alert(fnainfo.errorInfo);
					}
				}
			});	
		}
		
	}else{
		setFieldValue4Mobile(dt2_fieldIdKhyh, "", "", _indexno);
		setFieldValue4Mobile(dt2_fieldIdHuming, "", "", _indexno);
		setFieldValue4Mobile(dt2_fieldIdSkzh, "", "", _indexno);
	}
}

function dyeditPageFnaFyFun(groupid,rowId,fieldCount,isedit,isdisplay){
	if(groupid == 0){
		var url1 = "/mobile/plugin/1/fna/DialogAmtEdit4Mobile.jsp";
		var url2 = "/mobile/plugin/1/fna/wfPage/dialogAmountOfHistoryQry4Mobile.jsp";
		
		if(!_isNeverSubmit){
			//借款金额弹出框
			jQuery("#field"+dt1_fieldIdJkje+"_"+rowId+"_d").unbind('click').removeAttr('onclick').click(function(){
				var idArray = jQuery(this).attr("id").split("_");
				var _indexno = idArray[1];
				var amountBorrowBefore = jQuery("#field"+dt1_fieldIdJkje+"_"+_indexno).attr("_dataBaseValue");
				var amountBorrowAfter = jQuery("#field"+dt1_fieldIdJkje+"_"+_indexno+"_d").val();
				var memo1 = "";
				var jkmxStr = jQuery("#field"+dt1_fieldIdJkmx+"_"+_indexno).val();
				//jkmxStr = "{\"amountBorrowBefore\":\"123.45\",\"memo1\":\"你好！\"}";
				if(jkmxStr!=""){
					jkmxStr = jkmxStr._fnaReplaceAll("&quot;", "\"");
					var jkmxJson = eval("("+jkmxStr+")");
					amountBorrowBefore = jkmxJson.amountBorrowBefore;
					memo1 = jkmxJson.memo1;
				}
			   	
			   	var __url = url1+"?amountBorrowBefore="+amountBorrowBefore+"&amountBorrowAfter="+amountBorrowAfter+"&rowId="+_indexno+"&memo1="+memo1+"&wfType=1";
			   	showDialog_Fna(__url, "", null, "<%=SystemEnv.getHtmlLabelName(1043,user.getLanguage())%>");
		   });
		}
		
		getJkmxLocation(rowId, 1);
	}else if(groupid == 1){
		var __skfs = jQuery("#field"+dt2_fieldIdSkfs+"_"+rowId+"_d").val();
		if(__skfs == '1'){
			var __Khyh = jQuery("#field"+dt2_fieldIdKhyh+"_"+rowId+"_d").val();
			var __Huming = jQuery("#field"+dt2_fieldIdHuming+"_"+rowId+"_d").val();
			var __Skzh = jQuery("#field"+dt2_fieldIdSkzh+"_"+rowId+"_d").val();
			
			if(__Khyh=='' && __Huming=='' && __Skzh==''){
				var sqr = jQuery("#field"+main_fieldIdSqr).val();
				jQuery.ajax({
					url : "/mobile/plugin/1/fna/wfpage/mainBorrowSqrInfo4Mobile.jsp",
					type : "get",
					processData : false,
					data : "_____guid1="+_____guid1+"&sqr="+sqr,
					dataType : "json",
					success: function do4Success(fnainfo){
						if(fnainfo.flag){
							jQuery("#field"+dt2_fieldIdKhyh+"_"+rowId+"_d").show();
							jQuery("#field"+dt2_fieldIdHuming+"_"+rowId+"_d").show();
							jQuery("#field"+dt2_fieldIdSkzh+"_"+rowId+"_d").show();
							
							setFieldValue4Mobile(dt2_fieldIdKhyh, fnainfo.Khyh, fnainfo.Khyh, rowId);
							setFieldValue4Mobile(dt2_fieldIdHuming, fnainfo.Huming, fnainfo.Huming, rowId);
							setFieldValue4Mobile(dt2_fieldIdSkzh, fnainfo.Skzh, fnainfo.Skzh, rowId);
						}else{
							alert(fnainfo.errorInfo);
						}
					}
				});	
			}
		}else{
			setFieldValue4Mobile(dt2_fieldIdKhyh, "", "", rowId);
			setFieldValue4Mobile(dt2_fieldIdHuming, "", "", rowId);
			setFieldValue4Mobile(dt2_fieldIdSkzh, "", "", rowId);
			
			jQuery("#field"+dt2_fieldIdKhyh+"_"+rowId+"_d").hide();
			jQuery("#field"+dt2_fieldIdHuming+"_"+rowId+"_d").hide();
			jQuery("#field"+dt2_fieldIdSkzh+"_"+rowId+"_d").hide();
		}
		
		jQuery("#field"+dt2_fieldIdSkfs+"_"+rowId+"_d").change(function(){
			var __newSkfs = jQuery(this).val();
			if(__newSkfs == '1'){
				var sqr = jQuery("#field"+main_fieldIdSqr).val();
				jQuery.ajax({
					url : "/mobile/plugin/1/fna/wfpage/mainBorrowSqrInfo4Mobile.jsp",
					type : "get",
					processData : false,
					data : "_____guid1="+_____guid1+"&sqr="+sqr,
					dataType : "json",
					success: function do4Success(fnainfo){
						if(fnainfo.flag){
							jQuery("#field"+dt2_fieldIdKhyh+"_"+rowId+"_d").show();
							jQuery("#field"+dt2_fieldIdHuming+"_"+rowId+"_d").show();
							jQuery("#field"+dt2_fieldIdSkzh+"_"+rowId+"_d").show();
							
							setFieldValue4Mobile(dt2_fieldIdKhyh, fnainfo.Khyh, fnainfo.Khyh, rowId);
							setFieldValue4Mobile(dt2_fieldIdHuming, fnainfo.Huming, fnainfo.Huming, rowId)
							setFieldValue4Mobile(dt2_fieldIdSkzh, fnainfo.Skzh, fnainfo.Skzh, rowId)
						}else{
							alert(fnainfo.errorInfo);
						}
					}
				});	
				
			}else{
				setFieldValue4Mobile(dt2_fieldIdKhyh, "", "", rowId);
				setFieldValue4Mobile(dt2_fieldIdHuming, "", "", rowId);
				setFieldValue4Mobile(dt2_fieldIdSkzh, "", "", rowId);
				
				jQuery("#field"+dt2_fieldIdKhyh+"_"+rowId+"_d").hide();
				jQuery("#field"+dt2_fieldIdHuming+"_"+rowId+"_d").hide();
				jQuery("#field"+dt2_fieldIdSkzh+"_"+rowId+"_d").hide();
			}
		});
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
	
	//借款金额
	setFieldValue4Mobile(dt1_fieldIdJkje, amountBorrowAfter, amountBorrowAfter, rowId);
	
	//数据回写到借款明细（横排input）
	jQuery("#field"+dt1_fieldIdJkmx+"_"+rowId).attr("value","{&quot;amountBorrowBefore&quot;:&quot;"+amountBorrowBefore+"&quot;,&quot;memo1&quot;:&quot;"+memo1+"&quot;}");
}

var _fna_flag_setPageAllButtonDisabled1 = true;
function _fna_flag_setPageAllButtonDisabled(){
	_fna_flag_setPageAllButtonDisabled1 = false;
}
function _fna_flag_setPageAllButtonEnable(){
	_fna_flag_setPageAllButtonDisabled1 = true;
}

function doSubmitFna4Mobile_Borrow(){
	var returnval = "1";
	try{
		if(!_fna_flag_setPageAllButtonDisabled1){
			return "0";
		}
		_fna_flag_setPageAllButtonDisabled();
		if(_isNeverSubmit){
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
		}
		
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
					    	poststr1 += ",s,";
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
					    	poststr2 += ",s,";
					    }
					    poststr2 += skje+",postStrEnd";
				    }
				}
			}catch(e){}
		}
		if(poststr1!=""||poststr2!=""){
		}else{
			returnval = "1";
		}

		jQuery.ajax({
			url : "/mobile/plugin/1/fna/wfpage/FnaifoverJsonAjaxBorrow4Mobile.jsp",
			type : "get",
			processData : false,
			async : false,
			data : "poststr1="+poststr1+"&poststr2="+poststr2+"&requestid="+temprequestid+"&workflowid="+__workflowid,
			dataType : "json",
			success: function do4Success(fnainfo){
				if(fnainfo.flag){
					returnval = "1";
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
						alert(errorInfo);
						returnval = "0";
					}else if(errorType=="confirm"){
						confirm(errorInfo,
							function(){
								returnval = "1";
							},function(){
								_fna_flag_setPageAllButtonEnable();
								returnval = "0";
							}
						);
					}else{
						_fna_flag_setPageAllButtonEnable();
						alert(errorInfo);
						returnval = "0";
					}
				}
			}
		});	
	}catch(ex2){
		_fna_flag_setPageAllButtonEnable();
		alert(ex2.message);
		returnval = "0";
	}
	_fna_flag_setPageAllButtonEnable();
	return returnval;
}

function closeDialog() {
	jQuery.close("selectionWindow");
}

</script>