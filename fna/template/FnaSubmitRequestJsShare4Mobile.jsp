<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="java.util.Map"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="java.util.HashMap"%>
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

RecordSet rs = new RecordSet();


FnaSystemSetComInfo fnaSystemSetComInfo = new FnaSystemSetComInfo();
boolean subjectFilter = 1==Util.getIntValue(fnaSystemSetComInfo.get_subjectFilter(), 0);

request.getSession().setAttribute("FnaSubmitRequestJsBorrow.jsp_____"+guid1+"_____"+user.getUID(), guid1);

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

String fieldIdSubject = Util.null2String(dataMap.get("fieldIdSubject_fieldId"));
String fieldIdOrgType = Util.null2String(dataMap.get("fieldIdOrgType_fieldId"));
String fieldIdOrgId = Util.null2String(dataMap.get("fieldIdOrgId_fieldId"));
String fieldIdOccurdate = Util.null2String(dataMap.get("fieldIdOccurdate_fieldId"));
String fieldIdAmount = Util.null2String(dataMap.get("fieldIdAmount_fieldId"));
String fieldIdHrmInfo = Util.null2String(dataMap.get("fieldIdHrmInfo_fieldId"));
String fieldIdDepInfo = Util.null2String(dataMap.get("fieldIdDepInfo_fieldId"));
String fieldIdSubInfo = Util.null2String(dataMap.get("fieldIdSubInfo_fieldId"));
String fieldIdFccInfo = Util.null2String(dataMap.get("fieldIdFccInfo_fieldId"));

String fieldIdSubject2 = Util.null2String(dataMap.get("fieldIdSubject2_fieldId"));
String fieldIdOrgType2 = Util.null2String(dataMap.get("fieldIdOrgType2_fieldId"));
String fieldIdOrgId2 = Util.null2String(dataMap.get("fieldIdOrgId2_fieldId"));
String fieldIdOccurdate2 = Util.null2String(dataMap.get("fieldIdOccurdate2_fieldId"));
String fieldIdHrmInfo2 = Util.null2String(dataMap.get("fieldIdHrmInfo2_fieldId"));
String fieldIdDepInfo2 = Util.null2String(dataMap.get("fieldIdDepInfo2_fieldId"));
String fieldIdSubInfo2 = Util.null2String(dataMap.get("fieldIdSubInfo2_fieldId"));
String fieldIdFccInfo2 = Util.null2String(dataMap.get("fieldIdFccInfo2_fieldId"));

String fieldIdSubject_isDtl = Util.null2String(dataMap.get("fieldIdSubject_fieldId_isDtl"));
String fieldIdOrgType_isDtl = Util.null2String(dataMap.get("fieldIdOrgType_fieldId_isDtl"));
String fieldIdOrgId_isDtl = Util.null2String(dataMap.get("fieldIdOrgId_fieldId_isDtl"));
String fieldIdOccurdate_isDtl = Util.null2String(dataMap.get("fieldIdOccurdate_fieldId_isDtl"));
String fieldIdAmount_isDtl = Util.null2String(dataMap.get("fieldIdAmount_fieldId_isDtl"));
String fieldIdHrmInfo_isDtl = Util.null2String(dataMap.get("fieldIdHrmInfo_fieldId_isDtl"));
String fieldIdDepInfo_isDtl = Util.null2String(dataMap.get("fieldIdDepInfo_fieldId_isDtl"));
String fieldIdSubInfo_isDtl = Util.null2String(dataMap.get("fieldIdSubInfo_fieldId_isDtl"));
String fieldIdFccInfo_isDtl = Util.null2String(dataMap.get("fieldIdFccInfo_fieldId_isDtl"));

String fieldIdSubject2_isDtl = Util.null2String(dataMap.get("fieldIdSubject2_fieldId_isDtl"));
String fieldIdOrgType2_isDtl = Util.null2String(dataMap.get("fieldIdOrgType2_fieldId_isDtl"));
String fieldIdOrgId2_isDtl = Util.null2String(dataMap.get("fieldIdOrgId2_fieldId_isDtl"));
String fieldIdOccurdate2_isDtl = Util.null2String(dataMap.get("fieldIdOccurdate2_fieldId_isDtl"));
String fieldIdHrmInfo2_isDtl = Util.null2String(dataMap.get("fieldIdHrmInfo2_fieldId_isDtl"));
String fieldIdDepInfo2_isDtl = Util.null2String(dataMap.get("fieldIdDepInfo2_fieldId_isDtl"));
String fieldIdSubInfo2_isDtl = Util.null2String(dataMap.get("fieldIdSubInfo2_fieldId_isDtl"));
String fieldIdFccInfo2_isDtl = Util.null2String(dataMap.get("fieldIdFccInfo2_fieldId_isDtl"));

String fieldIdOrgId_automaticTake = Util.null2String(dataMap.get("fieldIdOrgId_automaticTake"));

String fieldIdOrgId2_automaticTake = Util.null2String(dataMap.get("fieldIdOrgId2_automaticTake"));

if(Util.getIntValue(fieldIdSubject2) <= 0){
	fieldIdSubject2 = fieldIdSubject;
}
if(Util.getIntValue(fieldIdOrgType2) <= 0){
	fieldIdOrgType2 = fieldIdOrgType;
}
if(Util.getIntValue(fieldIdOrgId2) <= 0){
	fieldIdOrgId2 = fieldIdOrgId;
}
if(Util.getIntValue(fieldIdOccurdate2) <= 0){
	fieldIdOccurdate2 = fieldIdOccurdate;
}
if(Util.getIntValue(fieldIdHrmInfo2) <= 0){
	fieldIdHrmInfo2 = fieldIdHrmInfo;
}
if(Util.getIntValue(fieldIdDepInfo2) <= 0){
	fieldIdDepInfo2 = fieldIdDepInfo;
}
if(Util.getIntValue(fieldIdSubInfo2) <= 0){
	fieldIdSubInfo2 = fieldIdSubInfo;
}
if(Util.getIntValue(fieldIdFccInfo2) <= 0){
	fieldIdFccInfo2 = fieldIdFccInfo;
}
//查询个人信息
HashMap<String, String> dataMapHrm = new HashMap<String, String>();
FnaCommon.getHrmResourceInfo(dataMapHrm, user.getUID());
String _fnaLastname = Util.null2String(dataMapHrm.get("lastname"));
String _fnaDeptId = Util.null2String(dataMapHrm.get("deptId"));
String _fnaDeptName = Util.null2String(dataMapHrm.get("deptName"));
String _fnaSubcomId = Util.null2String(dataMapHrm.get("subcomId"));
String _fnaSubcomName = Util.null2String(dataMapHrm.get("subcomName"));
String _fnaFccId = Util.null2String(dataMapHrm.get("fccId"));
String _fnaFccName = Util.null2String(dataMapHrm.get("fccName"));
%>
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=8"></script>
<script language="javascript">
var _fnaUserId = "<%=user.getUID()%>";
var _fnaLastname = <%=JSONObject.quote(_fnaLastname)%>;
var _fnaDeptId = "<%=_fnaDeptId%>";
var _fnaDeptName = <%=JSONObject.quote(_fnaDeptName)%>;
var _fnaSubcomId = "<%=_fnaSubcomId%>";
var _fnaSubcomName = <%=JSONObject.quote(_fnaSubcomName)%>;
var _fnaFccId = "<%=_fnaFccId%>";
var _fnaFccName = <%=JSONObject.quote(_fnaFccName)%>;

var _____guid1 = "<%=guid1 %>";
var _____module = "<%=module %>";

var dt1_subject = "<%=fieldIdSubject %>";
var dt1_organizationtype = "<%=fieldIdOrgType %>";
var dt1_organizationid = "<%=fieldIdOrgId %>";
var dt1_budgetperiod = "<%=fieldIdOccurdate %>";
var dt1_applyamount = "<%=fieldIdAmount %>";
var dt1_hrmremain = "<%=fieldIdHrmInfo %>";
var dt1_deptremain = "<%=fieldIdDepInfo %>";
var dt1_subcomremain = "<%=fieldIdSubInfo %>";
var dt1_fccremain = "<%=fieldIdFccInfo %>";

var dt1_subject2 = "<%=fieldIdSubject2 %>";
var dt1_organizationtype2 = "<%=fieldIdOrgType2 %>";
var dt1_organizationid2 = "<%=fieldIdOrgId2 %>";
var dt1_budgetperiod2 = "<%=fieldIdOccurdate2 %>";
var dt1_hrmremain2 = "<%=fieldIdHrmInfo2 %>";
var dt1_deptremain2 = "<%=fieldIdDepInfo2 %>";
var dt1_subcomremain2 = "<%=fieldIdSubInfo2 %>";
var dt1_fccremain2 = "<%=fieldIdFccInfo2 %>";

var dt1_allFieldId_Same = (dt1_subject==dt1_subject2 && dt1_organizationtype==dt1_organizationtype2 
		&& dt1_organizationid==dt1_organizationid2 && dt1_budgetperiod==dt1_budgetperiod2);
		
var fieldIdOrgId_automaticTake = "<%=fieldIdOrgId_automaticTake %>";
		
var fieldIdOrgId2_automaticTake = "<%=fieldIdOrgId2_automaticTake %>";


var _FnaSubmitRequestJsReimFlag = 1;
var __workflowid = "<%=workflowid %>";
var __requestid = "<%=requestid %>";

var browserUtl_subject = '<%=new BrowserComInfo().getBrowserurl("22") %>';
var browserUtl_hrm = '<%=new BrowserComInfo().getBrowserurl("1") %>';
var browserUtl_dep = '<%=new BrowserComInfo().getBrowserurl("4") %>';
var browserUtl_sub = '<%=new BrowserComInfo().getBrowserurl("164") %>';
var browserUtl_prj = '<%=new BrowserComInfo().getBrowserurl("8") %>';
var browserUtl_crm = '<%=new BrowserComInfo().getBrowserurl("7") %>';
var browserUtl_fcc = '<%=new BrowserComInfo().getBrowserurl("251") %>';

var _isFnaSubmitRequestJs4MobileWf = true;
var flag_getFnaInfoData = true;

//**
function dyeditPageFnaFyFun(groupid,rowId,fieldCount,isedit,isdisplay) {
	//手机版修改字段值
	if(groupid == 0){
		//第一行明细
		jQuery("#field"+dt1_budgetperiod+"_"+rowId).bindPropertyChange(function(targetobj){
			var _idx1 = parseInt(jQuery(targetobj).attr("name").replace("field"+dt1_budgetperiod+"_",""));
			if(flag_getFnaInfoData){
				var chg_riqi = jQuery("#field"+dt1_budgetperiod+"_"+_idx1).val();
				getFnaInfoData(_idx1, chg_riqi);
			}
			flag_getFnaInfoData = true;
		});

		if(dt1_budgetperiod != dt1_budgetperiod2){			
			jQuery("#field"+dt1_budgetperiod2+"_"+rowId).bindPropertyChange(function(targetobj){
				var _idx1 = parseInt(jQuery(targetobj).attr("name").replace("field"+dt1_budgetperiod2+"_",""));
				if(flag_getFnaInfoData){
					var chg_riqi = jQuery("#field"+dt1_budgetperiod2+"_"+_idx1).val();
					getFnaInfoData2(_idx1, chg_riqi);
				}
				flag_getFnaInfoData = true;
			});
		}
		
	    jQuery("#field"+dt1_organizationtype+"_"+rowId+"_d").bind("change",function(){
	    	var _obj = jQuery(this);
	    	var fieldID = _obj.attr("id");
	    	var fieldSpan = fieldID+"_span";
	    	var keys = _obj.val();
	    	//var vals = jQuery("select[id="+fieldID+"] option[selected]").text(); 
	    	var vals = _obj.find("option:selected").text();
	
	    	var _fieldID = "";
	    	var _indexno = "";
	    	var fieldIDArray = fieldID.split("_");
	    	if(fieldIDArray!=null && fieldIDArray.length>=2){
	    		_fieldID = fieldIDArray[0].replace("field","");
	    		_indexno = fieldIDArray[1];
	    	}
	    	
	    	var clickType = 0;
	    	
	    	orgType_change(fieldID, fieldSpan, keys, vals, clickType, _fieldID, _indexno);
	    });
		
	    if(dt1_organizationtype != dt1_organizationtype2){
		    jQuery("#field"+dt1_organizationtype2+"_"+rowId+"_d").bind("change",function(){
		    	var _obj = jQuery(this);
		    	var fieldID = _obj.attr("id");
		    	var fieldSpan = fieldID+"_span";
		    	var keys = _obj.val();
		    	//var vals = jQuery("select[id="+fieldID+"] option[selected]").text(); 
		    	var vals = _obj.find("option:selected").text();
		
		    	var _fieldID = "";
		    	var _indexno = "";
		    	var fieldIDArray = fieldID.split("_");
		    	if(fieldIDArray!=null && fieldIDArray.length>=2){
		    		_fieldID = fieldIDArray[0].replace("field","");
		    		_indexno = fieldIDArray[1];
		    	}
		    	
		    	var clickType = 0;
		    	
		    	orgType_change2(fieldID, fieldSpan, keys, vals, clickType, _fieldID, _indexno);
		    });
	    }

		jQuery("#field"+dt1_organizationid+"_"+rowId).bindPropertyChange(function(targetobj){
			var _obj = jQuery(targetobj);
			var fieldID = _obj.attr("id");
			var fieldSpan = fieldID+"_span";
			var keys = _obj.val();
			var vals = jQuery("#"+fieldSpan).html();
			var clickType = 0;
			fnaFyFunCallBack(fieldID, fieldSpan, keys, vals, clickType);
	    });

	    if(dt1_organizationtype != dt1_organizationtype2){
			jQuery("#field"+dt1_organizationtype2+"_"+rowId).bindPropertyChange(function(targetobj){
				var _obj = jQuery(targetobj);
				var fieldID = _obj.attr("id");
				var fieldSpan = fieldID+"_span";
				var keys = _obj.val();
				var vals = jQuery("#"+fieldSpan).html();
				var clickType = 0;
				fnaFyFunCallBack(fieldID, fieldSpan, keys, vals, clickType);
		    });
	    }
		
	    getFnaInfoData(rowId);
	    getFnaInfoData2(rowId);
	}
	
	return;
}

//**
function fnaFyFunCallBack(fieldID, fieldSpan, keys, vals, clickType) {
	//浏览按钮回调
	var _fieldID = "";
	var _indexno = "";
	var fieldIDArray = fieldID.split("_");
	if(fieldIDArray!=null && fieldIDArray.length>=2){
		_fieldID = fieldIDArray[0].replace("field","");
		_indexno = fieldIDArray[1];
	}else{
		_fieldID = fieldID.replace("field","");
	}
	//alert("fnaFyFunCallBack fieldID="+fieldID+";fieldSpan="+fieldSpan+";keys="+keys+";vals="+vals+";clickType="+clickType+";_fieldID="+_fieldID+";_indexno="+_indexno+";dt1_subject="+dt1_subject);
	if(_fieldID==dt1_budgetperiod || _fieldID==dt1_subject || _fieldID==dt1_organizationid 
			|| _fieldID==dt1_budgetperiod2 || _fieldID==dt1_subject2 || _fieldID==dt1_organizationid2){
		if(_fieldID==dt1_organizationid){
			clearSubjectById(_indexno,"");
		}
		if(_fieldID==dt1_organizationid2){
			clearSubjectById(_indexno,"2");
		}
		getFnaInfoData(_indexno);
		getFnaInfoData2(_indexno);
	}else if(_fieldID==dt1_organizationtype || _fieldID==dt1_organizationtype2){
		if(_fieldID==dt1_organizationtype){
			clearSubjectById(_indexno,"");
			orgType_change(fieldID, fieldSpan, keys, vals, clickType, _fieldID, _indexno);
		}else if(_fieldID==dt1_organizationtype2){
			clearSubjectById(_indexno,"2");
			orgType_change2(fieldID, fieldSpan, keys, vals, clickType, _fieldID, _indexno);
		}
	}
	
	return;
}

//*
function clearOrgtype(indexno){
  	var orgtype = getWfMainAndDetailFieldValueForMobile(dt1_organizationtype, "1", indexno);
	var _id1 = "";
	var _name1 = "";
	if(fieldIdOrgId_automaticTake=="1"){
		if(orgtype == "0"){
			_id1 = _fnaUserId;
			_name1 = _fnaLastname;
		}else if(orgtype == "1"){
			_id1 = _fnaDeptId;
			_name1 = _fnaDeptName;
		}else if(orgtype == "2"){
			_id1 = _fnaSubcomId;
			_name1 = _fnaSubcomName;
		}else if(orgtype == "3"){
			_id1 = _fnaFccId;
			_name1 = _fnaFccName;
		}
	}
	setWfMainAndDetailFieldValueForMobile(_id1, dt1_organizationid, "1", indexno);//id
 	var isshowId = getWfMainAndDetailFieldIsshowIdForMobile(dt1_organizationid, "1", indexno);
 	jQuery("#"+isshowId).html(_name1);
 	setWfMainAndDetailFieldSpanValueForMobile1(_name1, dt1_organizationid, "1", indexno);//name
  	try{
  		var _objArray = getWfMainAndDetailFieldSpanObjectForMobile(dt1_organizationid, "1", indexno).find("SPAN");
      	for(var i=0;i<_objArray.length;i++){
     		jQuery(_objArray[i]).html(_name1);//name
     		break;
      	}
  	}catch(ex1){}
}

//*
function clearOrgtype2(indexno){
	var orgtype = getWfMainAndDetailFieldValueForMobile(dt1_organizationtype2, "1", indexno);
	var _id1 = "";
	var _name1 = "";
	if(fieldIdOrgId2_automaticTake=="1"){
		if(orgtype == "0"){
			_id1 = _fnaUserId;
			_name1 = _fnaLastname;
		}else if(orgtype == "1"){
			_id1 = _fnaDeptId;
			_name1 = _fnaDeptName;
		}else if(orgtype == "2"){
			_id1 = _fnaSubcomId;
			_name1 = _fnaSubcomName;
		}else if(orgtype == "3"){
			_id1 = _fnaFccId;
			_name1 = _fnaFccName;
		}
	}
	setWfMainAndDetailFieldValueForMobile(_id1, dt1_organizationid2, "1", indexno);//id
 	var isshowId = getWfMainAndDetailFieldIsshowIdForMobile(dt1_organizationid2, "1", indexno);
 	jQuery("#"+isshowId).html(_name1);
 	setWfMainAndDetailFieldSpanValueForMobile1(_name1, dt1_organizationid2, "1", indexno);//name
  	try{
  		var _objArray = getWfMainAndDetailFieldSpanObjectForMobile(dt1_organizationid2, "1", indexno).find("SPAN");
      	for(var i=0;i<_objArray.length;i++){
     		jQuery(_objArray[i]).html(_name1);//name
     		break;
      	}
  	}catch(ex1){}
}

//**
function orgType_change(fieldID, fieldSpan, keys, vals, clickType, _fieldID, _indexno){
	//alert("orgType_change fieldID="+fieldID+";fieldSpan="+fieldSpan+";keys="+keys+";vals="+vals+";clickType="+clickType+";_fieldID="+_fieldID+";_indexno="+_indexno);
	clearOrgtype(_indexno);
	getFnaInfoData(_indexno);
}

//**
function orgType_change2(fieldID, fieldSpan, keys, vals, clickType, _fieldID, _indexno){
	//alert("orgType_change fieldID="+fieldID+";fieldSpan="+fieldSpan+";keys="+keys+";vals="+vals+";clickType="+clickType+";_fieldID="+_fieldID+";_indexno="+_indexno);
	if(dt1_allFieldId_Same){
		return;
	}
	clearOrgtype2(_indexno);
	getFnaInfoData2(_indexno);
}

//**
function getFnaInfoData(indexno, chg_riqi, chg_je){
	var budgetfeetype = jQuery("#field"+dt1_subject+"_"+indexno).val();
	var orgtype = jQuery("#field"+dt1_organizationtype+"_"+indexno).val();
	var orgid = jQuery("#field"+dt1_organizationid+"_"+indexno).val();
	var applydate = jQuery("#field"+dt1_budgetperiod+"_"+indexno).val();
	if(chg_riqi!=null){
		applydate = chg_riqi;
	}
	
	var _data = "budgetfeetype="+budgetfeetype+"&orgtype="+orgtype+"&orgid="+orgid+"&applydate="+applydate;
	//alert("getFnaInfoData _data="+_data);
	jQuery.ajax({
		url : "/mobile/plugin/1/FnaBudgetInfoMobileAjax.jsp",
		type : "get",
		cache : false,
		processData : false,
		data : _data,
		dataType : "html",
		success: function do4Success(msg){
	    	//alert("getFnaInfoData msg="+jQuery.trim(msg));
	    	try{
		        var fnainfos = jQuery.trim(msg).split("|");
		        
		        var _dt1_remain_array = [dt1_hrmremain, dt1_deptremain, dt1_subcomremain, dt1_fccremain];
		        var _dt1_remain_array_len = _dt1_remain_array.length;
		        var _dt1_remain_only = "";
	        	if(getFnaNotEmptyCount(_dt1_remain_array)==1){
	        		_dt1_remain_only = getFnaOnlyNotEmptyValue(_dt1_remain_array);
	            }
				for(var i=0;i<_dt1_remain_array_len;i++){
					var _dt1_remain = _dt1_remain_array[i];
					if(_dt1_remain_only!=""&&_dt1_remain_only!=_dt1_remain){
						continue;
					}
					var values = fnainfos[i].split(",");
					if((_dt1_remain_only!=""&&_dt1_remain_only==_dt1_remain) || (getFnaSameValueCount(_dt1_remain_array, _dt1_remain)>1)){
						//个人：orgtype==0；部门：orgtype==2；分部：orgtype==3；成本中心：orgtype==4；
						values = fnainfos[orgtype].split(",");
					}
					var tempmsg = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:"+values[0]+
						"<br><span style=\"color: red !important;\"><%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:"+values[1]+"</span>"+
						"<br><span style=\"color: green !important;\"><%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:"+values[2]+"</span>";
			      	var isshowId = jQuery("#"+_dt1_remain+indexno).val();
			      	jQuery("#"+isshowId).html(tempmsg);
			      	jQuery("#field"+_dt1_remain+"_"+indexno+"_span_d").html(tempmsg);
				}
	    	}catch(exSplit01){}
		}
	});	
}

//**
function getFnaInfoData2(indexno, chg_riqi, chg_je){
	if(dt1_allFieldId_Same){
		return;
	}
	
	var budgetfeetype = jQuery("#field"+dt1_subject2+"_"+indexno).val();
	var orgtype = jQuery("#field"+dt1_organizationtype2+"_"+indexno).val();
	var orgid = jQuery("#field"+dt1_organizationid2+"_"+indexno).val();
	var applydate = jQuery("#field"+dt1_budgetperiod2+"_"+indexno).val();
	if(chg_riqi!=null){
		applydate = chg_riqi;
	}
	
	var _data = "budgetfeetype="+budgetfeetype+"&orgtype="+orgtype+"&orgid="+orgid+"&applydate="+applydate;
	//alert("getFnaInfoData _data="+_data);
	jQuery.ajax({
		url : "/mobile/plugin/1/FnaBudgetInfoMobileAjax.jsp",
		type : "get",
		cache : false,
		processData : false,
		data : _data,
		dataType : "html",
		success: function do4Success(msg){
	    	try{
		    	//alert("getFnaInfoData msg="+jQuery.trim(msg));
		        var fnainfos = jQuery.trim(msg).split("|");
		        
		        var _dt1_remain_array = [dt1_hrmremain2, dt1_deptremain2, dt1_subcomremain2, dt1_fccremain2];
		        var _dt1_remain_array_len = _dt1_remain_array.length;
		        var _dt1_remain_only = "";
	        	if(getFnaNotEmptyCount(_dt1_remain_array)==1){
	        		_dt1_remain_only = getFnaOnlyNotEmptyValue(_dt1_remain_array);
	            }
				for(var i=0;i<_dt1_remain_array_len;i++){
					var _dt1_remain = _dt1_remain_array[i];
					if(_dt1_remain_only!=""&&_dt1_remain_only!=_dt1_remain){
						continue;
					}
					var values = fnainfos[i].split(",");
					if((_dt1_remain_only!=""&&_dt1_remain_only==_dt1_remain) || (getFnaSameValueCount(_dt1_remain_array, _dt1_remain)>1)){
						//个人：orgtype==0；部门：orgtype==2；分部：orgtype==3；成本中心：orgtype==4；
						values = fnainfos[orgtype].split(",");
					}
					var tempmsg = "<%=SystemEnv.getHtmlLabelName(18768,user.getLanguage())%>:"+values[0]+
						"<br><span style=\"color: red !important;\"><%=SystemEnv.getHtmlLabelName(18503,user.getLanguage())%>:"+values[1]+"</span>"+
						"<br><span style=\"color: green !important;\"><%=SystemEnv.getHtmlLabelName(18769,user.getLanguage())%>:"+values[2]+"</span>";
			      	var isshowId = jQuery("#"+_dt1_remain+indexno).val();
			      	jQuery("#"+isshowId).html(tempmsg);
			      	jQuery("#field"+_dt1_remain+"_"+indexno+"_span_d").html(tempmsg);
				}
	    	}catch(exSplit01){}
		}
	});	
}

//**
function getOrgSpanAndInitOrgIdBtn(orgtype,orgid,insertindex){
	//alert("getOrgSpanAndInitOrgIdBtn orgtype="+orgtype+";orgid="+orgid+";insertindex="+insertindex);
	var orgSpan = "";
	jQuery.ajax({
		url : "/mobile/plugin/1/GetOrgNameByIdMobile.jsp",
		type : "get",
		processData : false,
		data : "orgtype="+orgtype+"&orgid="+orgid,
		dataType : "html",
		success: function do4Success(msg){
			var orgSpan = jQuery.trim(msg);
	      	var isshowId = jQuery("#"+dt1_organizationid+insertindex).val();
	      	jQuery("#"+isshowId).html(orgSpan);
	      	//jQuery("#field"+dt1_organizationid+"_"+insertindex+"_span_d").html(orgSpan);
  			try{
		      	var _objArray = jQuery("#field"+dt1_organizationid+"_"+insertindex+"_span").find("SPAN");
		      	for(var i=0;i<_objArray.length;i++){
		      		if(_objArray[i].getAttribute("keyid")==orgid){
		      			jQuery(_objArray[i]).html(orgSpan);
		      			break;
		      		}
		      	}
			}catch(ex1){}
			getFnaInfoData(insertindex);
		}
	});
}

//**
function getOrgSpanAndInitOrgIdBtn2(orgtype,orgid,insertindex){
	//alert("getOrgSpanAndInitOrgIdBtn orgtype="+orgtype+";orgid="+orgid+";insertindex="+insertindex);
	if(dt1_allFieldId_Same){
		return;
	}
	var orgSpan = "";
	jQuery.ajax({
		url : "/mobile/plugin/1/GetOrgNameByIdMobile.jsp",
		type : "get",
		processData : false,
		data : "orgtype="+orgtype+"&orgid="+orgid,
		dataType : "html",
		success: function do4Success(msg){
			var orgSpan = jQuery.trim(msg);
	      	var isshowId = jQuery("#"+dt1_organizationid2+insertindex).val();
	      	jQuery("#"+isshowId).html(orgSpan);
	      	//jQuery("#field"+dt1_organizationid2+"_"+insertindex+"_span_d").html(orgSpan);
  			try{
		      	var _objArray = jQuery("#field"+dt1_organizationid2+"_"+insertindex+"_span").find("SPAN");
		      	for(var i=0;i<_objArray.length;i++){
		      		if(_objArray[i].getAttribute("keyid")==orgid){
		      			jQuery(_objArray[i]).html(orgSpan);
		      			break;
		      		}
		      	}
			}catch(ex1){}
			getFnaInfoData2(insertindex);
		}
	});
}

//**
function bindfee(){
	var _xm_array = jQuery("input[id^='field"+dt1_subject+"_']");
	for(var i0=0;i0<_xm_array.length;i0++){
		var indexno = parseInt(jQuery(_xm_array[i0]).attr("id").replace("field"+dt1_subject+"_",""));
		//alert("bindfee indexno="+indexno+";id="+jQuery(_xm_array[i0]).attr("id")+";id2="+"field"+dt1_subject+"_"+indexno);
		if(jQuery(_xm_array[i0]).attr("id")=="field"+dt1_subject+"_"+indexno){
		    var orgtype = jQuery("#field"+dt1_organizationtype+"_"+indexno).val();
		    var orgid = jQuery("#field"+dt1_organizationid+"_"+indexno).val();
			getOrgSpanAndInitOrgIdBtn(orgtype,orgid,indexno);

			if(dt1_organizationtype != dt1_organizationtype2 && dt1_organizationid != dt1_organizationid2){
			    var orgtype = jQuery("#field"+dt1_organizationtype2+"_"+indexno).val();
			    var orgid = jQuery("#field"+dt1_organizationid2+"_"+indexno).val();
			    getOrgSpanAndInitOrgIdBtn2(orgtype,orgid,indexno);
			}
		}
	}
}

//**
function clearSubjectById(rowId, _type0){
	<%if(subjectFilter){ %>
		var budgetfeetype="";
		var orgtype="";
		var orgid="";
		if(_type0=="2"){
			budgetfeetype = getWfMainAndDetailFieldValueForPc(dt1_subject2, "1", rowId);
			orgtype = getWfMainAndDetailFieldValueForPc(dt1_organizationtype2, "1", rowId);
			orgid = getWfMainAndDetailFieldValueForPc(dt1_organizationid2, "1", rowId);
		}else{
			budgetfeetype = getWfMainAndDetailFieldValueForPc(dt1_subject, "1", rowId);
			orgtype = getWfMainAndDetailFieldValueForPc(dt1_organizationtype, "1", rowId);
			orgid = getWfMainAndDetailFieldValueForPc(dt1_organizationid, "1", rowId);
		}
		if(budgetfeetype != "" && orgid !=""){
			jQuery.ajax({
				url : "/mobile/plugin/1/fna/wfpage/getClearSubjectMobile.jsp",
				type : "get",
				processData : false,
				data : "budgetfeetype="+budgetfeetype+"&orgtype="+orgtype+"&orgid="+orgid,
				dataType : "json",
				success: function do4Success(fnainfo){
					if(fnainfo.flag){
						if(fnainfo.change != "1"){
							if(_type0=="2"){
								clearBtnById(dt1_subject2,rowId);
								getFnaInfoData2(rowId);
							}else{
								clearBtnById(dt1_subject,rowId);
								getFnaInfoData(rowId);
							}
						}
					}else{
						top.Dialog.alert(fnainfo.errorInfo);
					}
				}
			});
		}
	<%}%>
}
function clearBtnById(fieldId,rowId){
	var fieldID = "field"+fieldId+"_"+rowId;
	var fieldSpan = "field"+fieldId+"_"+rowId+"_span";
	jQuery("#" + fieldID).val("");
	jQuery("#" + fieldSpan).html("");
	jQuery("#" + fieldID).change();
	if(document.getElementById(fieldID+"_d")){
		jQuery("#" + fieldID+"_d").val("");
	}
	if(document.getElementById(fieldSpan+"_d")){
		jQuery("#" + fieldSpan+"_d").html("");
		var groupidStr=$("#" + fieldSpan+"_d").attr("groupid");
		var rowIdStr=$("#" + fieldSpan+"_d").attr("rowId");
		var columnIdStr=$("#" + fieldSpan+"_d").attr("columnId");
		if(groupidStr&&rowIdStr&&columnIdStr){
			var showObj= document.getElementById("isshow"+groupidStr+"_"+rowIdStr+"_"+columnIdStr);
			showObj.innerHTML = "<span id=\""+fieldSpan+"\" name=\""+fieldSpan+"\" keyid=\"mingxi\"></span>";
		}
	}
}

function fna_doSubmit_4Mobile_callBackFun(_object, _callBackFunType){
	_fna_flag_setPageAllButtonEnable();
	var _s_alertMsg = "";
	if(_callBackFunType==1){
		_s_alertMsg = dosubmit(_object);
	}else if(_callBackFunType==2){
		_s_alertMsg = dosubnoback(_object);
	}else if(_callBackFunType==3){
		_s_alertMsg = dosubback(_object);
	}
	if(_s_alertMsg==true){
		return _s_alertMsg;
	}else{
		if(window.isnewVersion && _s_alertMsg != ""){
			if(_s_alertMsg.indexOf("emobile:Message:")==0){
				var _s_alertMsg_array = _s_alertMsg.split(":");
				if(_s_alertMsg_array.length==4){
					alert(_s_alertMsg_array[2]);
				}else{
					alert(_s_alertMsg);
				}
			}else{
				alert(_s_alertMsg);
			}
			return _s_alertMsg;
		} else {
			return _s_alertMsg;
		}
	}
}

var _fna_flag_setPageAllButtonDisabled1 = true;
function _fna_flag_setPageAllButtonDisabled(){
	_fna_flag_setPageAllButtonDisabled1 = false;
}
function _fna_flag_setPageAllButtonEnable(){
	_fna_flag_setPageAllButtonDisabled1 = true;
}

jQuery(document).ready(function(){
    jQuery("button[name='addbutton0']").bind("click",function(){
    	var indexno = -1;
    	var _xm_array = jQuery("input[id^='field"+dt1_subject+"_']");
    	if(_xm_array.length > 0){
    		indexno = parseInt(jQuery(_xm_array[_xm_array.length-1]).attr("id").replace("field"+dt1_subject+"_",""));
    	}
    	clearOrgtype(indexno);
    	clearOrgtype2(indexno);
		getFnaInfoData(indexno);
		getFnaInfoData2(indexno);
    });
    bindfee();

	doSubmit_4Mobile = function(_object, _callBackFunType){
		try{
			if(!_fna_flag_setPageAllButtonDisabled1){
				return;
			}
			_fna_flag_setPageAllButtonDisabled();
			var temprequestid = "<%=requestid %>";
			var poststr = "";
			var _xm_array = jQuery("input[id^='field"+dt1_subject+"_']");
			for(var i0=0;i0<_xm_array.length;i0++){
				try{
					var indexno = parseInt(jQuery(_xm_array[i0]).attr("id").replace("field"+dt1_subject+"_",""));
					var _idx = indexno;
					if(jQuery(_xm_array[i0]).attr("id")=="field"+dt1_subject+"_"+indexno){
					    var budgetfeetype = jQuery("#field"+dt1_subject+"_"+_idx).val();
					    var orgtype = jQuery("#field"+dt1_organizationtype+"_"+_idx).val();
					    var orgid = jQuery("#field"+dt1_organizationid+"_"+_idx).val();
					    var applydate = jQuery("#field"+dt1_budgetperiod+"_"+_idx).val();
					    var applyamount = jQuery("#field"+dt1_applyamount+"_"+_idx).val();

					    var budgetfeetype2 = jQuery("#field"+dt1_subject2+"_"+_idx).val();
					    var orgtype2 = jQuery("#field"+dt1_organizationtype2+"_"+_idx).val();
					    var orgid2 = jQuery("#field"+dt1_organizationid2+"_"+_idx).val();
					    var applydate2 = jQuery("#field"+dt1_budgetperiod2+"_"+_idx).val();
					    
					    if(budgetfeetype!="" && orgtype!="" && orgid!="" && applydate!="" && applyamount!=""){
						    if(poststr!=""){
						    	poststr += ",s,";
						    }
					    	poststr += budgetfeetype+","+ orgtype+","+ orgid+","+ applydate+","+applyamount+","+
				    			budgetfeetype2+","+orgtype2+","+orgid2+","+applydate2+",postStrEnd";
					    }
				    }
				}catch(e){}
			}
			
			if(poststr!=""){
			}else{
				return fna_doSubmit_4Mobile_callBackFun(_object, _callBackFunType);
			}
			
			
			var _data = "poststr="+poststr+"&requestid="+temprequestid+"&workflowid="+__workflowid;

			var returnvalFlag = false;
			jQuery.ajax({
				url : "/mobile/plugin/1/FnaShareifoverJsonMobileAjax.jsp",
				type : "get",
				processData : false,
				data : _data,
				dataType : "json",
				success: function do4Success(fnainfo){
					if(fnainfo.flag==null&&fnainfo.error){
						_fna_flag_setPageAllButtonEnable();
						alert(fnainfo.error);
					}else if(fnainfo.flag){
						returnvalFlag= true;
					}else{
						var errorType = fnainfo.errorType;
						var errorInfo = fnainfo.errorInfo;
						if(errorInfo==null){
							errorInfo="";
						}
						if(errorType=="alert"){
							_fna_flag_setPageAllButtonEnable();
							alert(errorInfo);
						}else if(errorType=="confirm"){
							if(confirm(errorInfo)){
								returnvalFlag= true;
							}else{
								_fna_flag_setPageAllButtonEnable();
							};
						}else{
							_fna_flag_setPageAllButtonEnable();
							alert(errorInfo);
						}
					}
					if(returnvalFlag){
						return fna_doSubmit_4Mobile_callBackFun(_object, _callBackFunType);
					}else{
						_fna_flag_setPageAllButtonEnable();
					}
				}
			});
			
		}catch(ex2){
			alert(ex2.message);
		}
	}
});

function closeDialog() {
	jQuery.close("selectionWindow");
}

</script>