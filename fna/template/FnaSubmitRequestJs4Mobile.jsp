<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="org.json.JSONObject"%>
<%@page import="weaver.fna.general.FnaCommon"%>
<%@page import="java.util.UUID"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="java.util.*"%>
<%@page import="weaver.fna.maintenance.FnaBudgetControl"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%
String guid1 = UUID.randomUUID().toString();

User user = HrmUserVarify.getUser (request , response) ;
if(user==null){
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
}

FnaBudgetControl fnaBudgetControl = new FnaBudgetControl();
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


boolean enableRepayment = false;
boolean enableReverseAdvance = false;
String sql = "select * from fnaFeeWfInfo where workflowid = "+workflowid;
rs.executeSql(sql);
if(rs.next()){
	int fnaWfTypeColl = rs.getInt("fnaWfTypeColl");
	int fnaWfTypeReverse = rs.getInt("fnaWfTypeReverse");
	enableRepayment = (fnaWfTypeReverse>0 && fnaWfTypeColl>0);
	enableReverseAdvance = rs.getInt("fnaWfTypeReverseAdvance")==1;
}

Map<String, String> dataMap = new HashMap<String, String>();
fnaBudgetControl.getFnaWfFieldInfo4Expense(workflowid, dataMap);

boolean haveApplicationBudget = "true".equals(Util.null2String(dataMap.get("haveApplicationBudget")));

String main_fieldIdSqr = Util.null2String(dataMap.get("main_fieldIdSqr_fieldId"));
String main_fieldIdSqr_controlBorrowingWf = Util.null2String(dataMap.get("main_fieldIdSqr_controlBorrowingWf"));//还款流程中通过申请人字段控制可选择的借款流程
String main_fieldIdFysqlc = Util.null2String(dataMap.get("main_fieldIdFysqlc_fieldId"));
String main_fieldIdSfbxwc = Util.null2String(dataMap.get("main_fieldIdSfbxwc_fieldId"));
String main_fieldIdYfkZfHj = Util.null2String(dataMap.get("main_fieldIdYfkZfHj_fieldId"));

String fieldIdSubject = Util.null2String(dataMap.get("fieldIdSubject_fieldId"));
String fieldIdOrgType = Util.null2String(dataMap.get("fieldIdOrgType_fieldId"));
String fieldIdOrgId = Util.null2String(dataMap.get("fieldIdOrgId_fieldId"));
String fieldIdOccurdate = Util.null2String(dataMap.get("fieldIdOccurdate_fieldId"));
String fieldIdAmount = Util.null2String(dataMap.get("fieldIdAmount_fieldId"));
String fieldIdHrmInfo = Util.null2String(dataMap.get("fieldIdHrmInfo_fieldId"));
String fieldIdDepInfo = Util.null2String(dataMap.get("fieldIdDepInfo_fieldId"));
String fieldIdSubInfo = Util.null2String(dataMap.get("fieldIdSubInfo_fieldId"));
String fieldIdFccInfo = Util.null2String(dataMap.get("fieldIdFccInfo_fieldId"));
String fieldIdReqId = Util.null2String(dataMap.get("fieldIdReqId_fieldId"));
String fieldIdReqDtId = Util.null2String(dataMap.get("fieldIdReqDtId_fieldId"));

String fieldIdSubject_isDtl = Util.null2String(dataMap.get("fieldIdSubject_fieldId_isDtl"));
String fieldIdOrgType_isDtl = Util.null2String(dataMap.get("fieldIdOrgType_fieldId_isDtl"));
String fieldIdOrgId_isDtl = Util.null2String(dataMap.get("fieldIdOrgId_fieldId_isDtl"));
String fieldIdOccurdate_isDtl = Util.null2String(dataMap.get("fieldIdOccurdate_fieldId_isDtl"));
String fieldIdAmount_isDtl = Util.null2String(dataMap.get("fieldIdAmount_fieldId_isDtl"));
String fieldIdHrmInfo_isDtl = Util.null2String(dataMap.get("fieldIdHrmInfo_fieldId_isDtl"));
String fieldIdDepInfo_isDtl = Util.null2String(dataMap.get("fieldIdDepInfo_fieldId_isDtl"));
String fieldIdSubInfo_isDtl = Util.null2String(dataMap.get("fieldIdSubInfo_fieldId_isDtl"));
String fieldIdFccInfo_isDtl = Util.null2String(dataMap.get("fieldIdFccInfo_fieldId_isDtl"));
String fieldIdReqId_isDtl = Util.null2String(dataMap.get("fieldIdReqId_fieldId_isDtl"));
String fieldIdReqDtId_isDtl = Util.null2String(dataMap.get("fieldIdReqDtId_fieldId_isDtl"));

String fieldIdOrgId_automaticTake = Util.null2String(dataMap.get("fieldIdOrgId_automaticTake"));

String dt2_fieldIdJklc = Util.null2String(dataMap.get("dt2_fieldIdJklc_fieldId"));
String dt2_fieldIdJkdh = Util.null2String(dataMap.get("dt2_fieldIdJkdh_fieldId"));
String dt2_fieldIdDnxh = Util.null2String(dataMap.get("dt2_fieldIdDnxh_fieldId"));
String dt2_fieldIdJkje = Util.null2String(dataMap.get("dt2_fieldIdJkje_fieldId"));
String dt2_fieldIdYhje = Util.null2String(dataMap.get("dt2_fieldIdYhje_fieldId"));
String dt2_fieldIdSpzje = Util.null2String(dataMap.get("dt2_fieldIdSpzje_fieldId"));
String dt2_fieldIdWhje = Util.null2String(dataMap.get("dt2_fieldIdWhje_fieldId"));
String dt2_fieldIdCxje = Util.null2String(dataMap.get("dt2_fieldIdCxje_fieldId"));

String dt3_fieldIdSkfs = Util.null2String(dataMap.get("dt3_fieldIdSkfs_fieldId"));
String dt3_fieldIdSkje = Util.null2String(dataMap.get("dt3_fieldIdSkje_fieldId"));
String dt3_fieldIdKhyh = Util.null2String(dataMap.get("dt3_fieldIdKhyh_fieldId"));
String dt3_fieldIdHuming = Util.null2String(dataMap.get("dt3_fieldIdHuming_fieldId"));
String dt3_fieldIdSkzh = Util.null2String(dataMap.get("dt3_fieldIdSkzh_fieldId"));

String dt4_fieldIdYfklc = Util.null2String(dataMap.get("dt4_fieldIdYfklc_fieldId"));
String dt4_fieldIdYfkdh = Util.null2String(dataMap.get("dt4_fieldIdYfkdh_fieldId"));
String dt4_fieldIdDnxh = Util.null2String(dataMap.get("dt4_fieldIdDnxh_fieldId"));
String dt4_fieldIdYfkje = Util.null2String(dataMap.get("dt4_fieldIdYfkje_fieldId"));
String dt4_fieldIdYhje = Util.null2String(dataMap.get("dt4_fieldIdYhje_fieldId"));
String dt4_fieldIdSpzje = Util.null2String(dataMap.get("dt4_fieldIdSpzje_fieldId"));
String dt4_fieldIdWhje = Util.null2String(dataMap.get("dt4_fieldIdWhje_fieldId"));
String dt4_fieldIdCxje = Util.null2String(dataMap.get("dt4_fieldIdCxje_fieldId"));
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
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=12"></script>
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

var haveApplicationBudget = <%=(haveApplicationBudget)?"true":"false" %>;

var main_fieldIdSqr = "<%=main_fieldIdSqr %>";
var main_fieldIdSqr_controlBorrowingWf = "<%=main_fieldIdSqr_controlBorrowingWf %>";
var main_fieldIdFysqlc = "<%=main_fieldIdFysqlc %>";
var main_fieldIdSfbxwc = "<%=main_fieldIdSfbxwc %>";
var main_fieldIdYfkZfHj = "<%=main_fieldIdYfkZfHj %>";

var dt1_subject = "<%=fieldIdSubject %>";
var dt1_organizationtype = "<%=fieldIdOrgType %>";
var dt1_organizationid = "<%=fieldIdOrgId %>";
var dt1_budgetperiod = "<%=fieldIdOccurdate %>";
var dt1_applyamount = "<%=fieldIdAmount %>";
var dt1_hrmremain = "<%=fieldIdHrmInfo %>";
var dt1_deptremain = "<%=fieldIdDepInfo %>";
var dt1_subcomremain = "<%=fieldIdSubInfo %>";
var dt1_fccremain = "<%=fieldIdFccInfo %>";
var dt1_fieldIdReqId = "<%=fieldIdReqId %>";
var dt1_fieldIdReqDtId = "<%=fieldIdReqDtId %>";
//报销明细所有字段：集合数组
var dt1_fieldId_array = [dt1_subject, dt1_organizationtype, dt1_organizationid, dt1_budgetperiod, dt1_applyamount, 
                         dt1_hrmremain, dt1_deptremain, dt1_subcomremain, dt1_fccremain, dt1_fieldIdReqId, dt1_fieldIdReqDtId];

//报销明细字段是否是明细表字段；1：是明细表；0：是主表；-1：未配置字段；
var dt1_subject_isDtl = "<%=fieldIdSubject_isDtl %>";
var dt1_organizationtype_isDtl = "<%=fieldIdOrgType_isDtl %>";
var dt1_organizationid_isDtl = "<%=fieldIdOrgId_isDtl %>";
var dt1_budgetperiod_isDtl = "<%=fieldIdOccurdate_isDtl %>";
var dt1_applyamount_isDtl = "<%=fieldIdAmount_isDtl %>";
var dt1_hrmremain_isDtl = "<%=fieldIdHrmInfo_isDtl %>";
var dt1_deptremain_isDtl = "<%=fieldIdDepInfo_isDtl %>";
var dt1_subcomremain_isDtl = "<%=fieldIdSubInfo_isDtl %>";
var dt1_fccremain_isDtl = "<%=fieldIdFccInfo_isDtl %>";
var dt1_fieldIdReqId_isDtl = "<%=fieldIdReqId_isDtl %>";
var dt1_fieldIdReqDtId_isDtl = "<%=fieldIdReqDtId_isDtl %>";
//报销明细所有字段是否是明细表字段：集合数组
var dt1_fieldId_isDtl_array = [dt1_subject_isDtl, dt1_organizationtype_isDtl, dt1_organizationid_isDtl, dt1_budgetperiod_isDtl, dt1_applyamount_isDtl, 
                       dt1_hrmremain_isDtl, dt1_deptremain_isDtl, dt1_subcomremain_isDtl, dt1_fccremain_isDtl, dt1_fieldIdReqId_isDtl, dt1_fieldIdReqDtId_isDtl];

//报销明细中是否包含了明细表字段
var dt1_haveIsDtlField = (dt1_subject_isDtl=="1"||dt1_organizationtype_isDtl=="1"||dt1_organizationid_isDtl=="1"
		||dt1_budgetperiod_isDtl=="1"||dt1_applyamount_isDtl=="1"||dt1_hrmremain_isDtl=="1"
		||dt1_deptremain_isDtl=="1"||dt1_subcomremain_isDtl=="1"||dt1_fccremain_isDtl=="1"||dt1_fieldIdReqId_isDtl=="1"||dt1_fieldIdReqDtId_isDtl=="1");
		
var fieldIdOrgId_automaticTake = "<%=fieldIdOrgId_automaticTake %>";

var dt2_fieldIdJklc = "<%=dt2_fieldIdJklc %>";
var dt2_fieldIdJkdh = "<%=dt2_fieldIdJkdh %>";
var dt2_fieldIdDnxh = "<%=dt2_fieldIdDnxh %>";
var dt2_fieldIdJkje = "<%=dt2_fieldIdJkje %>";
var dt2_fieldIdYhje = "<%=dt2_fieldIdYhje %>";
var dt2_fieldIdSpzje = "<%=dt2_fieldIdSpzje %>";
var dt2_fieldIdWhje = "<%=dt2_fieldIdWhje %>";
var dt2_fieldIdCxje = "<%=dt2_fieldIdCxje %>";

var dt3_fieldIdSkfs = "<%=dt3_fieldIdSkfs %>";
var dt3_fieldIdSkje = "<%=dt3_fieldIdSkje %>";
var dt3_fieldIdKhyh = "<%=dt3_fieldIdKhyh %>";
var dt3_fieldIdHuming = "<%=dt3_fieldIdHuming %>";
var dt3_fieldIdSkzh = "<%=dt3_fieldIdSkzh %>";

var dt4_fieldIdYfklc = "<%=dt4_fieldIdYfklc %>";
var dt4_fieldIdYfkdh = "<%=dt4_fieldIdYfkdh %>";
var dt4_fieldIdDnxh = "<%=dt4_fieldIdDnxh %>";
var dt4_fieldIdYfkje = "<%=dt4_fieldIdYfkje %>";
var dt4_fieldIdYhje = "<%=dt4_fieldIdYhje %>";
var dt4_fieldIdSpzje = "<%=dt4_fieldIdSpzje %>";
var dt4_fieldIdWhje = "<%=dt4_fieldIdWhje %>";
var dt4_fieldIdCxje = "<%=dt4_fieldIdCxje %>";



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


function get_wfDetail_dt1_fieldId(){
	var _dt1_fieldId = "";
	if(dt1_subject_isDtl=="1"){
		_dt1_fieldId = dt1_subject;
	}else if(dt1_organizationtype_isDtl=="1"){
		_dt1_fieldId = dt1_organizationtype;
	}else if(dt1_organizationid_isDtl=="1"){
		_dt1_fieldId = dt1_organizationid;
	}else if(dt1_budgetperiod_isDtl=="1"){
		_dt1_fieldId = dt1_budgetperiod;
	}
	return _dt1_fieldId;
}

function get_wfDetail_dt1_objTagName(){
	var _dt1_objTagName = "input";
	if(dt1_subject_isDtl=="1"){
	}else if(dt1_organizationtype_isDtl=="1"){
		if(jQuery("select[id^='field"+dt1_organizationtype+"_']").length>0){
			_dt1_objTagName = "select";
		}
		//_dt1_objTagName = "select";
	}else if(dt1_organizationid_isDtl=="1"){
	}else if(dt1_budgetperiod_isDtl=="1"){
	}
	return _dt1_objTagName;
}

function get_wfDetail_xm_array(){
	var _dt1_fieldId = get_wfDetail_dt1_fieldId();
	var _dt1_objTagName = get_wfDetail_dt1_objTagName();
	var _xm_array = jQuery(_dt1_objTagName+"[id^='field"+_dt1_fieldId+"_']");
	return _xm_array;
}

function dyeditPageFnaFyFun(groupid,rowId,fieldCount,isedit,isdisplay) {
	//手机版修改字段值
	if(groupid == 0){
		//第一个明细
		if(dt1_budgetperiod_isDtl=="1"){
		    jQuery("#field"+dt1_budgetperiod+"_"+rowId).bindPropertyChange(function(targetobj){
				var _idx1 = parseInt(jQuery(targetobj).attr("name").replace("field"+dt1_budgetperiod+"_",""));
		    	if(flag_getFnaInfoData){
			    	var chg_riqi = jQuery("#field"+dt1_budgetperiod+"_"+_idx1).val();
			    	getFnaInfoData(_idx1, chg_riqi);
		    	}
				flag_getFnaInfoData = true;
		    });
		}

		if(dt1_organizationtype_isDtl=="1"){
		    jQuery("#field"+dt1_organizationtype+"_"+rowId+"_d").bind("change",function(){
		    	var _obj = jQuery(this);
		    	var fieldID = _obj.attr("id");
		    	var fieldSpan = fieldID+"_span";
		    	var keys = _obj.val();
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
		}

		if(dt1_organizationid_isDtl=="1"){
			jQuery("#field"+dt1_organizationid+"_"+rowId).bindPropertyChange(function(targetobj){
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
	}else if(groupid == 1){
		//第二个明细
		dyeditPageFnaFyFun2(rowId);
	}else if(groupid == 2){
		//第三个明细
		dyeditPageFnaFyFun3(rowId);
	}else if(groupid == 3){
		//第四个明细
		dyeditPageFnaFyFun3(rowId);
	}
	
	return;
}
//判断出入的字段id中，是否有报销流程的字段且该字段不是明细表字段
function getIsMainField(fieldid){
	var _isMainField = false;
	if(("field"+dt1_subject==""+fieldid || dt1_subject==""+fieldid) && dt1_subject_isDtl!="1"){
		_isMainField = true;
	}else if(("field"+dt1_organizationtype==""+fieldid || dt1_organizationtype==""+fieldid) && dt1_organizationtype_isDtl!="1"){
		_isMainField = true;
	}else if(("field"+dt1_organizationid==""+fieldid || dt1_organizationid==""+fieldid) && dt1_organizationid_isDtl!="1"){
		_isMainField = true;
	}else if(("field"+dt1_budgetperiod==""+fieldid || dt1_budgetperiod==""+fieldid) && dt1_budgetperiod_isDtl!="1"){
		_isMainField = true;
	}
	return _isMainField;
}
//浏览按钮回调
function fnaFyFunCallBack(fieldID, fieldSpan, keys, vals, clickType) {
	if(fieldID==null){
		return;
	}
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
	if(_fieldID==dt2_fieldIdJklc){
		fnaRepayCallBack1(fieldID, fieldSpan, keys, vals, clickType);
	}else if(_fieldID==dt4_fieldIdYfklc){
		fnaAdvanceRepayCallBack1(fieldID, fieldSpan, keys, vals, clickType);
	}else if(_fieldID==dt1_budgetperiod || _fieldID==dt1_subject || _fieldID==dt1_organizationid){
		var _isMainField = getIsMainField(fieldID);
		if(_isMainField && dt1_haveIsDtlField){
			var _dt1_fieldId = get_wfDetail_dt1_fieldId();
			var _xm_array = get_wfDetail_xm_array();
			for(var i0=0;i0<_xm_array.length;i0++){
				var indexno = parseInt(jQuery(_xm_array[i0]).attr("id").replace("field"+_dt1_fieldId+"_",""));
				//alert("bindfee indexno="+indexno+";id="+jQuery(_xm_array[i0]).attr("id")+";id2="+"field"+_dt1_fieldId+"_"+indexno);
				if(jQuery(_xm_array[i0]).attr("id")=="field"+_dt1_fieldId+"_"+indexno){
					if(_fieldID==dt1_organizationid){
						clearSubjectById(indexno);
					}
			    	getFnaInfoData(indexno);
				}
			}
		}else{
			if(_fieldID==dt1_organizationid){
				clearSubjectById(_indexno);
			}
			getFnaInfoData(_indexno);
		}
	}else if(_fieldID==dt1_organizationtype){
		clearSubjectById(_indexno);
		orgType_change(fieldID, fieldSpan, keys, vals, clickType, _fieldID, _indexno);
	}
	
	return;
}

function clearOrgtype(indexno){
	var orgtype = getWfMainAndDetailFieldValueForMobile(dt1_organizationtype, dt1_organizationtype_isDtl, indexno);
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
	setWfMainAndDetailFieldValueForMobile(_id1, dt1_organizationid, dt1_organizationid_isDtl, indexno);//id
 	var isshowId = getWfMainAndDetailFieldIsshowIdForMobile(dt1_organizationid, dt1_organizationid_isDtl, indexno);
 	jQuery("#"+isshowId).html(_name1);
 	setWfMainAndDetailFieldSpanValueForMobile1(_name1, dt1_organizationid, dt1_organizationid_isDtl, indexno);//name
  	try{
  		var _objArray = getWfMainAndDetailFieldSpanObjectForMobile(dt1_organizationid, dt1_organizationid_isDtl, indexno).find("SPAN");
      	for(var i=0;i<_objArray.length;i++){
     		jQuery(_objArray[i]).html(_name1);//name
     		break;
      	}
  	}catch(ex1){}
}

function orgType_change(fieldID, fieldSpan, keys, vals, clickType, _fieldID, _indexno){
	//alert("orgType_change fieldID="+fieldID+";fieldSpan="+fieldSpan+";keys="+keys+";vals="+vals+";clickType="+clickType+";_fieldID="+_fieldID+";_indexno="+_indexno);
	clearOrgtype(_indexno);

	var _isMainField = getIsMainField(fieldID);
	if(_isMainField && dt1_haveIsDtlField){
		var _dt1_fieldId = get_wfDetail_dt1_fieldId();
		var _xm_array = get_wfDetail_xm_array();
		for(var i0=0;i0<_xm_array.length;i0++){
			var indexno = parseInt(jQuery(_xm_array[i0]).attr("id").replace("field"+_dt1_fieldId+"_",""));
			//alert("bindfee indexno="+indexno+";id="+jQuery(_xm_array[i0]).attr("id")+";id2="+"field"+_dt1_fieldId+"_"+indexno);
			if(jQuery(_xm_array[i0]).attr("id")=="field"+_dt1_fieldId+"_"+indexno){
		    	getFnaInfoData(indexno);
			}
		}
	}else{
		getFnaInfoData(_indexno);
	}
}

function getFnaInfoData(indexno, chg_riqi, chg_je){
	//alert("getFnaInfoData");
	var temprequestid = __requestid;
	var budgetfeetype = getWfMainAndDetailFieldValueForMobile(dt1_subject, dt1_subject_isDtl, indexno);
	var orgtype = getWfMainAndDetailFieldValueForMobile(dt1_organizationtype, dt1_organizationtype_isDtl, indexno);
	var orgid = getWfMainAndDetailFieldValueForMobile(dt1_organizationid, dt1_organizationid_isDtl, indexno);
	var applydate = getWfMainAndDetailFieldValueForMobile(dt1_budgetperiod, dt1_budgetperiod_isDtl, indexno);
	if(chg_riqi!=null){
		applydate = chg_riqi;
	}

	var dtl_id = "0"; //check_node0
	if(dt1_haveIsDtlField){
	    var dtl_id_obj = jQuery("input[name='check_node0']");
		if(dtl_id_obj.length==0){
			dtl_id_obj = jQuery("input[name='check_node_0']");
		}
		//alert("dtl_id_obj="+dtl_id_obj.length+";");
	    if(dtl_id_obj.length>0){
	        var _rowIdx0 = 0;
			var _dt1_fieldId = get_wfDetail_dt1_fieldId();
			var _xm_array = get_wfDetail_xm_array();
	        for(var i0=0;i0<_xm_array.length;i0++){
	            var _idx1 = parseInt(jQuery(_xm_array[i0]).attr("id").replace("field"+_dt1_fieldId+"_",""));
	            //alert("bindfee indexno="+indexno+";id="+jQuery(_xm_array[i0]).attr("id")+";id2="+"field"+dt1_subject+"_"+indexno);
	            if(jQuery(_xm_array[i0]).attr("id")=="field"+dt1_subject+"_"+_idx1){
	                if(indexno+""==_idx1+""){
	                    dtl_id = dtl_id_obj[_rowIdx0].value;
						break;
	                }
	                _rowIdx0++;
	            }
	        }
	    }
	}else{
		dtl_id = "-987654321";
	}

	var _data = "budgetfeetype="+budgetfeetype+"&orgtype="+orgtype+"&orgid="+orgid+"&applydate="+applydate+"&dtl_id="+dtl_id+"&requestid="+temprequestid;
	
	
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
	
		        var budgetAutoMoveInfo = "";
	        	if(fnainfos.length>=5){
	        		budgetAutoMoveInfo = fnainfos[4];
	    			if(budgetAutoMoveInfo!=""){
	    				budgetAutoMoveInfo = "<%=SystemEnv.getHtmlLabelName(126630,user.getLanguage())%>:"+budgetAutoMoveInfo;
	    			}
	            }
	
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
					if(budgetAutoMoveInfo!=""){
						tempmsg += "<br>"+budgetAutoMoveInfo;
					}
					var isshowId = getWfMainAndDetailFieldIsshowIdForMobile(_dt1_remain, dt1_haveIsDtlField?"1":"0", indexno);
					if(jQuery("#"+isshowId).length>0){
						jQuery("#"+isshowId).html(tempmsg);
						setWfMainAndDetailFieldSpanValueForMobile1(tempmsg, _dt1_remain, dt1_haveIsDtlField?"1":"0", indexno);
					}else{
						setWfMainAndDetailFieldSpanValueForMobile(tempmsg, _dt1_remain, dt1_haveIsDtlField?"1":"0", indexno);
					}
				}
			}catch(exSplit01){}
		}
	});	
}

function getOrgSpanAndInitOrgIdBtn(orgtype,orgid,insertindex){
	var orgSpan = "";
	jQuery.ajax({
		url : "/mobile/plugin/1/GetOrgNameByIdMobile.jsp",
		type : "get",
		processData : false,
		data : "orgtype="+orgtype+"&orgid="+orgid,
		dataType : "html",
		success: function do4Success(msg){
			var orgSpan = jQuery.trim(msg);
			var isshowId = getWfMainAndDetailFieldIsshowIdForMobile(dt1_organizationid, dt1_organizationid_isDtl, insertindex);
			jQuery("#"+isshowId).html(orgSpan);
	      	//jQuery("#field"+dt1_organizationid+"_"+insertindex+"_span_d").html(orgSpan);
			//alert("goto orgSpan="+orgSpan+";isshowId="+isshowId);
			try{
		  		var _objArray = getWfMainAndDetailFieldSpanObjectForMobile(dt1_organizationid, dt1_organizationid_isDtl, insertindex).find("SPAN");
				for(var i=0;i<_objArray.length;i++){
					if(_objArray[i].getAttribute("keyid")==orgid){
						jQuery(_objArray[i]).html(orgSpan);
						break;
					}
				}
			}catch(ex1){}
			//alert("goto getFnaInfoData insertindex="+insertindex);
			getFnaInfoData(insertindex);
		}
	});
}

function bindfee(){
	if(dt1_haveIsDtlField){
		var _dt1_fieldId = get_wfDetail_dt1_fieldId();
		var _xm_array = get_wfDetail_xm_array();
		for(var i0=0;i0<_xm_array.length;i0++){
			var indexno = parseInt(jQuery(_xm_array[i0]).attr("id").replace("field"+_dt1_fieldId+"_",""));
			//alert("bindfee indexno="+indexno+";id="+jQuery(_xm_array[i0]).attr("id")+";id2="+"field"+_dt1_fieldId+"_"+indexno+";"+(jQuery(_xm_array[i0]).attr("id")=="field"+_dt1_fieldId+"_"+indexno));
			if(jQuery(_xm_array[i0]).attr("id")=="field"+_dt1_fieldId+"_"+indexno){
			    var orgtype = getWfMainAndDetailFieldValueForMobile(dt1_organizationtype, dt1_organizationtype_isDtl, indexno);
				//alert("bindfee orgtype="+orgtype);
			    var orgid = getWfMainAndDetailFieldValueForMobile(dt1_organizationid, dt1_organizationid_isDtl, indexno);
				//alert("bindfee orgid="+orgid);
				getOrgSpanAndInitOrgIdBtn(orgtype,orgid,indexno);
			}
		}
	}
	if(dt1_organizationid_isDtl!="1"){
	    var orgtype = getWfMainAndDetailFieldValueForMobile(dt1_organizationtype, dt1_organizationtype_isDtl, "");
	    var orgid = getWfMainAndDetailFieldValueForMobile(dt1_organizationid, dt1_organizationid_isDtl, "");
		if(__requestid <= 0){
			clearOrgtype("");
		}else{
			getOrgSpanAndInitOrgIdBtn(orgtype,orgid,"");
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

function clearSubjectById(rowId){
	<%if(subjectFilter){ %>
		var budgetfeetype = getWfMainAndDetailFieldValueForMobile(dt1_subject, dt1_subject_isDtl, rowId);
		var orgtype = getWfMainAndDetailFieldValueForMobile(dt1_organizationtype, dt1_organizationtype_isDtl, rowId);
		var orgid = getWfMainAndDetailFieldValueForMobile(dt1_organizationid, dt1_organizationid_isDtl, rowId);
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
							clearBtnById(dt1_subject,rowId);
							getFnaInfoData(rowId);
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
<%if(subjectFilter){ %>
//dt1_subject, dt1_subject_isDtl
	var fieldID = "field"+fieldId;
	var fieldSpan = "field"+fieldId+"_span";
	if(dt1_subject_isDtl=="1"){
		fieldID = "field"+fieldId+"_"+rowId;
		fieldSpan = "field"+fieldId+"_"+rowId+"_span";
	}
	jQuery("#" + fieldID).val("");
	jQuery("#" + fieldSpan).html("");
	jQuery("#" + fieldID).change();
	if(document.getElementById(fieldID+"_d")){
		jQuery("#" + fieldID+"_d").val("");
	}
	if(document.getElementById(fieldSpan+"_d")){
		if(dt1_subject_isDtl=="1"){
			jQuery("#" + fieldSpan+"_d").html("");
			var groupidStr=$("#" + fieldSpan+"_d").attr("groupid");
			var rowIdStr=$("#" + fieldSpan+"_d").attr("rowId");
			var columnIdStr=$("#" + fieldSpan+"_d").attr("columnId");
			if(groupidStr&&rowIdStr&&columnIdStr){
				var showObj= document.getElementById("isshow"+groupidStr+"_"+rowIdStr+"_"+columnIdStr);
				showObj.innerHTML = "<span id=\""+fieldSpan+"\" name=\""+fieldSpan+"\" keyid=\"mingxi\"></span>";
			}
		}else{
			jQuery("#" + fieldSpan+"_d").html("");
			var groupidStr=$("#" + fieldSpan+"_d").attr("groupid");
			if(groupidStr){
				var showObj= document.getElementById("isshow"+groupidStr);
				showObj.innerHTML = "<span id=\""+fieldSpan+"\" name=\""+fieldSpan+"\" keyid=\"mingxi\"></span>";
			}
		}
	}
<%} %>
}

var _fna_flag_setPageAllButtonDisabled1 = true;
function _fna_flag_setPageAllButtonDisabled(){
	_fna_flag_setPageAllButtonDisabled1 = false;
}
function _fna_flag_setPageAllButtonEnable(){
	_fna_flag_setPageAllButtonDisabled1 = true;
}

jQuery(document).ready(function(){
	//第一行明细
	if(dt1_budgetperiod_isDtl=="1"){
	}else{
	    jQuery("#field"+dt1_budgetperiod).bindPropertyChange(function(targetobj){
	    	if(flag_getFnaInfoData){
		    	var chg_riqi = jQuery("#field"+dt1_budgetperiod).val();
				if(dt1_haveIsDtlField){
					var _dt1_fieldId = get_wfDetail_dt1_fieldId();
					var _xm_array = get_wfDetail_xm_array();
					for(var i0=0;i0<_xm_array.length;i0++){
						var indexno = parseInt(jQuery(_xm_array[i0]).attr("id").replace("field"+_dt1_fieldId+"_",""));
						//alert("bindfee indexno="+indexno+";id="+jQuery(_xm_array[i0]).attr("id")+";id2="+"field"+_dt1_fieldId+"_"+indexno);
						if(jQuery(_xm_array[i0]).attr("id")=="field"+_dt1_fieldId+"_"+indexno){
					    	getFnaInfoData(indexno, chg_riqi);
						}
					}
				}else{
					getFnaInfoData("", chg_riqi);
				}
	    	}
			flag_getFnaInfoData = true;
	    });
	}

	if(dt1_organizationtype_isDtl=="1"){
	}else{
	    jQuery("#field"+dt1_organizationtype).bind("change",function(){
	    	var _obj = jQuery(this);
	    	var fieldID = _obj.attr("id");
	    	var fieldSpan = fieldID+"_span";
	    	var keys = _obj.val();
	    	var vals = _obj.find("option:selected").text();
	    	var _fieldID = fieldID.replace("field","");
	    	var _indexno = "";
	    	var clickType = 0;
	    	orgType_change(fieldID, fieldSpan, keys, vals, clickType, _fieldID, _indexno);
	    });
	}

	if(dt1_organizationid_isDtl=="1"){
	}else{
	    jQuery("#field"+dt1_organizationid).bindPropertyChange(function(targetobj){
	    	var _obj = jQuery(targetobj);
	    	var fieldID = _obj.attr("id");
	    	var fieldSpan = fieldID+"_span";
	    	var keys = _obj.val();
	    	var vals = jQuery("#"+fieldSpan).html();
	    	var clickType = 0;
	    	fnaFyFunCallBack(fieldID, fieldSpan, keys, vals, clickType);
	    });
	}

	if(dt1_haveIsDtlField){
	    jQuery("button[name='addbutton0']").bind("click",function(){
			var _dt1_fieldId = get_wfDetail_dt1_fieldId();
			var _xm_array = get_wfDetail_xm_array();
	    	if(_xm_array.length > 0){
	    		var indexno = parseInt(jQuery(_xm_array[_xm_array.length-1]).attr("id").replace("field"+dt1_subject+"_",""));
	    		if(dt1_organizationid_isDtl=="1"){
		    		clearOrgtype(indexno);
	    		}
				getFnaInfoData(indexno);
	    	}
	    });
	}
    bindfee();

<%if(enableRepayment){%>
	jQuery("button[name='addbutton1']").bind("click",function(){
		bindfeeDtl2(1);
	});
	bindfeeDtl2(2);
	
	jQuery("button[name='addbutton2']").bind("click",function(){
		bindfeeDtl3(1);
	});
	bindfeeDtl3(2);
<%}%>

	//第二次进行《预算校验》
	function _fnaifoverJson_doSubmit2(_object, _callBackFunType, _data){
		jQuery.ajax({
			url : "/mobile/plugin/1/FnaifoverJsonMobileAjax.jsp",
			type : "get",
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(fnainfo){
				if(fnainfo.flag==null&&fnainfo.error){
					//alert(11);
					alert(fnainfo.error);
					return false;
				}else{
					var returnvalFlag = false;
					var fnainfo_repayment = fnainfo.repayment;
					if(fnainfo_repayment.flag){
						returnvalFlag= true;
					}else{
						var errorType = fnainfo_repayment.errorType;
						var errorInfo = fnainfo_repayment.errorInfo;
						if(errorInfo==null){
							errorInfo="";
						}
						if(errorType=="alert"){
							//alert(10);
							_fna_flag_setPageAllButtonEnable();
							alert(errorInfo);
						}else if(errorType=="confirm"){
							//alert(9);
							if(confirm(errorInfo)){
								returnvalFlag= true;
							}else{
								_fna_flag_setPageAllButtonEnable();
							};
						}else{
							//alert(8);
							_fna_flag_setPageAllButtonEnable();
							alert(errorInfo);
						}
					}
					if(returnvalFlag){
						returnvalFlag = false;
						var fnainfo_fna = fnainfo.fna;
						if(fnainfo_fna.flag){
							returnvalFlag= true;
						}else{
							var errorType = fnainfo_fna.errorType;
							var errorInfo = fnainfo_fna.errorInfo;
							if(errorInfo==null){
								errorInfo="";
							}
							if(errorType=="alert"){
								//alert(7);
								_fna_flag_setPageAllButtonEnable();
								alert(errorInfo);
							}else if(errorType=="confirm"){
								//alert(6);
								if(confirm(errorInfo)){
									returnvalFlag= true;
								}else{
									_fna_flag_setPageAllButtonEnable();
								};
							}else{
								//alert(5);
								_fna_flag_setPageAllButtonEnable();
								alert(errorInfo);
							}
						}
					}
					if(returnvalFlag){
						returnvalFlag = false;
						var fnainfo_fnaAdvance = fnainfo.fnaAdvance;
						if(fnainfo_fnaAdvance.flag){
							returnvalFlag= true;
						}else{
							var errorType = fnainfo_fnaAdvance.errorType;
							var errorInfo = fnainfo_fnaAdvance.errorInfo;
							if(errorInfo==null){
								errorInfo="";
							}
							if(errorType=="alert"){
								//alert(7);
								_fna_flag_setPageAllButtonEnable();
								alert(errorInfo);
							}else if(errorType=="confirm"){
								//alert(6);
								if(confirm(errorInfo)){
									returnvalFlag= true;
								}else{
									_fna_flag_setPageAllButtonEnable();
								};
							}else{
								//alert(5);
								_fna_flag_setPageAllButtonEnable();
								alert(errorInfo);
							}
						}
					}
					if(returnvalFlag){
						return fna_doSubmit_4Mobile_callBackFun(_object, _callBackFunType);
					}else{
						_fna_flag_setPageAllButtonEnable();
						return false;
					}
				}
			}
		});	
	}
    
	doSubmit_4Mobile = function(_object, _callBackFunType){
		try{
			if(!_fna_flag_setPageAllButtonDisabled1){
				return;
			}
			_fna_flag_setPageAllButtonDisabled();
			var temprequestid = "<%=requestid %>";
			var poststr = "";
			if(dt1_haveIsDtlField){
				var _dt1_fieldId = get_wfDetail_dt1_fieldId();
				var _xm_array = get_wfDetail_xm_array();
				for(var i0=0;i0<_xm_array.length;i0++){
					try{
						var indexno = parseInt(jQuery(_xm_array[i0]).attr("id").replace("field"+_dt1_fieldId+"_",""));
						var _idx = indexno;
						if(jQuery(_xm_array[i0]).attr("id")=="field"+_dt1_fieldId+"_"+indexno){
							var budgetfeetype = getWfMainAndDetailFieldValueForMobile(dt1_subject, dt1_subject_isDtl, _idx);
							var orgtype = getWfMainAndDetailFieldValueForMobile(dt1_organizationtype, dt1_organizationtype_isDtl, _idx);
							var orgid = getWfMainAndDetailFieldValueForMobile(dt1_organizationid, dt1_organizationid_isDtl, _idx);
							var applydate = getWfMainAndDetailFieldValueForMobile(dt1_budgetperiod, dt1_budgetperiod_isDtl, _idx);
							var applyamount = getWfMainAndDetailFieldValueForMobile(dt1_applyamount, dt1_applyamount_isDtl, _idx);
							
							var _reqId = getWfMainAndDetailFieldValueForMobile(dt1_fieldIdReqId, dt1_fieldIdReqId_isDtl, _idx);
							var _reqDtId = getWfMainAndDetailFieldValueForMobile(dt1_fieldIdReqDtId, dt1_fieldIdReqDtId_isDtl, _idx);
						  
							
							var dtl_id = "0"; //check_node0
							var dtl_id_obj = jQuery("input[name='check_node0']");
							if(dtl_id_obj.length==0){
								dtl_id_obj = jQuery("input[name='check_node_0']");
							}
							if(dtl_id_obj.length>0){
								var _rowIdx0 = 0;
								var _xm_array1 = get_wfDetail_xm_array();
								for(var i1=0;i1<_xm_array1.length;i1++){
									var _idx1 = parseInt(jQuery(_xm_array1[i1]).attr("id").replace("field"+_dt1_fieldId+"_",""));
									if(jQuery(_xm_array1[i1]).attr("id")=="field"+_dt1_fieldId+"_"+_idx1){
										if(_idx+""==_idx1+""){
											dtl_id = dtl_id_obj[_rowIdx0].value;
											break;
										}
										_rowIdx0++;
									}
								}
							}


							if(budgetfeetype!="" && orgtype!="" && orgid!="" && applydate!="" && applyamount!=""){
								poststr += ",s,"+budgetfeetype+","+ orgtype+","+ orgid+","+ applydate+","+applyamount+","+dtl_id+","+_reqId+","+_reqDtId+",postStrEnd";
							}
					    }
					}catch(e){}
				}
			}else{
				var budgetfeetype = getWfMainAndDetailFieldValueForMobile(dt1_subject, dt1_subject_isDtl, "");
				var orgtype = getWfMainAndDetailFieldValueForMobile(dt1_organizationtype, dt1_organizationtype_isDtl, "");
				var orgid = getWfMainAndDetailFieldValueForMobile(dt1_organizationid, dt1_organizationid_isDtl, "");
				var applydate = getWfMainAndDetailFieldValueForMobile(dt1_budgetperiod, dt1_budgetperiod_isDtl, "");
				var applyamount = getWfMainAndDetailFieldValueForMobile(dt1_applyamount, dt1_applyamount_isDtl, "");
			    
				var dtl_id = "-987654321";
				
			    if(budgetfeetype!="" && orgtype!="" && orgid!="" && applydate!="" && applyamount!=""){
			    	poststr += ",s,"+budgetfeetype+","+ orgtype+","+ orgid+","+ applydate+","+applyamount+","+dtl_id+",0,0,postStrEnd";// 主表 
			    }
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
			
			var poststr3 = "";
			var _xm_array3 = jQuery("input[name^='field"+dt3_fieldIdSkje+"_']");
			for(var i0=0;i0<_xm_array3.length;i0++){
				try{
					var _iptName = jQuery(_xm_array3[i0]).attr("name");
					var _iptNameArray = _iptName.split("_");
					if(_iptNameArray.length==2){
						var _idx = parseInt(_iptNameArray[1]);
						if(!isNaN(_idx) && _idx>=0 && jQuery("#field"+dt3_fieldIdSkje+"_"+_idx).length==1){
						    var skje = fnaRound2(jQuery("#field"+dt3_fieldIdSkje+"_"+_idx).val(), 2);
						    if(poststr3!=""){
						    	poststr3 += ",s,";
						    }
						    poststr3 += skje+",postStrEnd";
					    }
					}
				}catch(e){}
			}
			
			var poststr4 = "";
			var _xm_array2 = jQuery("input[name^='field"+dt4_fieldIdCxje+"_']");
			for(var i0=0;i0<_xm_array2.length;i0++){
				try{
					var _iptName = jQuery(_xm_array2[i0]).attr("name");
					var _iptNameArray = _iptName.split("_");
					if(_iptNameArray.length==2){
						var _idx = parseInt(_iptNameArray[1]);
						if(!isNaN(_idx) && _idx>=0 && jQuery("#field"+dt4_fieldIdCxje+"_"+_idx).length==1){
						    var cxje = fnaRound2(jQuery("#field"+dt4_fieldIdCxje+"_"+_idx).val(), 2);
						    var Yfklc = jQuery("#field"+dt4_fieldIdYfklc+"_"+_idx).val();
						    var dnxh = jQuery("#field"+dt4_fieldIdDnxh+"_"+_idx).val();
						    if(poststr4!=""){
						    	poststr4 += ",s,";
						    }
						    poststr4 += cxje+","+Yfklc+","+dnxh+",postStrEnd";
					    }
					}
				}catch(e){}
			}
			
			if(poststr!=""||poststr2!=""||poststr3!=""||poststr4!=""){
			}else{
				return fna_doSubmit_4Mobile_callBackFun(_object, _callBackFunType);
			}
			
			
			var fysqlc = null2String(jQuery("#field"+main_fieldIdFysqlc).val());
			var yfkZfHj = fnaRound2(jQuery("#field"+main_fieldIdYfkZfHj).val(), 2);
			
			if(poststr != "") {
				poststr =poststr.substr(3);
			}
			
			var _data = "poststr="+poststr+"&poststr2="+poststr2+"&poststr3="+poststr3+"&poststr4="+poststr4+"&requestid="+temprequestid+"&workflowid="+__workflowid+"&fysqlc="+fysqlc+"&yfkZfHj="+yfkZfHj;

			//第一次进行《预申请预算校验》
			jQuery.ajax({
				url : "/mobile/plugin/1/FnaifoverJsonMobileAjax.jsp",
				type : "get",
				processData : false,
				data : _data+"&doValidateApplication=true",
				dataType : "json",
				success: function do4Success(fnainfo){
					if(fnainfo.flag==null&&fnainfo.error){
						//alert(4);
						_fna_flag_setPageAllButtonEnable();
						alert(fnainfo.error);
						return false;
					}else if(fnainfo.flag){
						return _fnaifoverJson_doSubmit2(_object, _callBackFunType, _data);
					}else{
						var errorType = fnainfo.errorType;
						var errorInfo = fnainfo.errorInfo;
						if(errorInfo==null){
							errorInfo="";
						}
						if(errorType=="alert"){
							//alert(1);
							_fna_flag_setPageAllButtonEnable();
							alert(errorInfo);
							return false;
						}else if(errorType=="confirm"){
							//alert(2);
							if(confirm(errorInfo)){
								return _fnaifoverJson_doSubmit2(_object, _callBackFunType, _data);
							}else{
								_fna_flag_setPageAllButtonEnable();
							};
						}else{
							//alert(3);
							_fna_flag_setPageAllButtonEnable();
							alert(errorInfo);
							return false;
						}
					}
				}
			});	
		}catch(ex2){
			_fna_flag_setPageAllButtonEnable();
			alert(ex2.message);
		}
	}
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

function bindfeeDtl3(value){
    var _indexnum = 0;
    if(document.getElementById("nodenum2")){
		_indexnum = document.getElementById("nodenum2").value * 1.0 - 1;
    }
    if(_indexnum>=0){
    	if(value==1){
			var _skfsJQuery = jQuery("#field"+dt3_fieldIdSkfs+"_"+_indexnum);
			if(_skfsJQuery.length==1){
				_fnaBorrowSkfsDtl3_onchange(_skfsJQuery[0], _indexnum);
			}
		}else if(value==2){
			var _xm_array = jQuery("select[name^='field"+dt3_fieldIdSkfs+"_']");
			if(_xm_array.length == 0){
				_xm_array = jQuery("input[name^='field"+dt3_fieldIdSkfs+"_']");
			}
			for(var i0=0;i0<_xm_array.length;i0++){
				var _iptName = jQuery(_xm_array[i0]).attr("name");
				var _iptNameArray = _iptName.split("_");
				if(_iptNameArray.length==2){
					var _idx = parseInt(_iptNameArray[1]);
					
					if(!isNaN(_idx) && _idx>=0){
						var _skfsJQuery = jQuery("#field"+dt3_fieldIdSkfs+"_"+_idx);
						if(_skfsJQuery.length==1){
							_fnaBorrowSkfsDtl3_onchange(_skfsJQuery[0], _idx);
						}
					}
				}
			}
		}
	}
}

function _fnaBorrowSkfsDtl3_onchange(obj, _indexno){
	var _Skfs = jQuery(obj).val();
	if(_Skfs == '1'){
		var __Khyh = jQuery("#field"+dt3_fieldIdKhyh+"_"+_indexno).val();
		var __Huming = jQuery("#field"+dt3_fieldIdHuming+"_"+_indexno).val();
		var __Skzh = jQuery("#field"+dt3_fieldIdSkzh+"_"+_indexno).val();
		
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
						setFieldValue4Mobile(dt3_fieldIdKhyh, fnainfo.Khyh, fnainfo.Khyh, _indexno);
						setFieldValue4Mobile(dt3_fieldIdHuming, fnainfo.Huming, fnainfo.Huming, _indexno);
						setFieldValue4Mobile(dt3_fieldIdSkzh, fnainfo.Skzh, fnainfo.Skzh, _indexno);
					}else{
						alert(fnainfo.errorInfo);
					}
				}
			});	
		}
		
	}else{
		setFieldValue4Mobile(dt3_fieldIdKhyh, "", "", _indexno);
		setFieldValue4Mobile(dt3_fieldIdHuming, "", "", _indexno);
		setFieldValue4Mobile(dt3_fieldIdSkzh, "", "", _indexno);
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

function dyeditPageFnaFyFun2(rowId){
	getBorrowRequestInfo(rowId);
}

function dyeditPageFnaFyFun3(rowId){
	var __skfs = jQuery("#field"+dt3_fieldIdSkfs+"_"+rowId+"_d").val();
	if(__skfs == '1'){
		var __Khyh = jQuery("#field"+dt3_fieldIdKhyh+"_"+rowId+"_d").val();
		var __Huming = jQuery("#field"+dt3_fieldIdHuming+"_"+rowId+"_d").val();
		var __Skzh = jQuery("#field"+dt3_fieldIdSkzh+"_"+rowId+"_d").val();
		
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
						setFieldValue4Mobile(dt3_fieldIdKhyh, fnainfo.Khyh, fnainfo.Khyh, rowId);
						setFieldValue4Mobile(dt3_fieldIdHuming, fnainfo.Huming, fnainfo.Huming, rowId);
						setFieldValue4Mobile(dt3_fieldIdSkzh, fnainfo.Skzh, fnainfo.Skzh, rowId);
						
						jQuery("#field"+dt3_fieldIdKhyh+"_"+rowId+"_d").show();
						jQuery("#field"+dt3_fieldIdHuming+"_"+rowId+"_d").show();
						jQuery("#field"+dt3_fieldIdSkzh+"_"+rowId+"_d").show();
					}else{
						alert(fnainfo.errorInfo);
					}
				}
			});	
		}
	}else{
		jQuery("#field"+dt3_fieldIdKhyh+"_"+rowId+"_d").hide();
		jQuery("#field"+dt3_fieldIdHuming+"_"+rowId+"_d").hide();
		jQuery("#field"+dt3_fieldIdSkzh+"_"+rowId+"_d").hide();
		
		setFieldValue4Mobile(dt3_fieldIdKhyh, "", "", rowId);
		setFieldValue4Mobile(dt3_fieldIdHuming, "", "", rowId);
		setFieldValue4Mobile(dt3_fieldIdSkzh, "", "", rowId);
	}
	
	jQuery("#field"+dt3_fieldIdSkfs+"_"+rowId+"_d").change(function(){
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
						setFieldValue4Mobile(dt3_fieldIdKhyh, fnainfo.Khyh, fnainfo.Khyh, rowId);
						setFieldValue4Mobile(dt3_fieldIdHuming, fnainfo.Huming, fnainfo.Huming, rowId)
						setFieldValue4Mobile(dt3_fieldIdSkzh, fnainfo.Skzh, fnainfo.Skzh, rowId)
						
						jQuery("#field"+dt3_fieldIdKhyh+"_"+rowId+"_d").show();
						jQuery("#field"+dt3_fieldIdHuming+"_"+rowId+"_d").show();
						jQuery("#field"+dt3_fieldIdSkzh+"_"+rowId+"_d").show();
					}else{
						alert(fnainfo.errorInfo);
					}
				}
			});	
		}else{
			jQuery("#field"+dt3_fieldIdKhyh+"_"+rowId+"_d").hide();
			jQuery("#field"+dt3_fieldIdHuming+"_"+rowId+"_d").hide();
			jQuery("#field"+dt3_fieldIdSkzh+"_"+rowId+"_d").hide();
			
			setFieldValue4Mobile(dt3_fieldIdKhyh, "", "", rowId);
			setFieldValue4Mobile(dt3_fieldIdHuming, "", "", rowId);
			setFieldValue4Mobile(dt3_fieldIdSkzh, "", "", rowId);
		}
	});
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

function closeDialog(returnIdField) {
	jQuery.close("selectionWindow");
	try{
		fnaFyFunCallBack(returnIdField);
	}catch(e){}
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













function dyeditPageFnaFyFun3(rowId){
	getAdvanceRequestInfo(rowId);
}

function getAdvanceRequestInfo(rowindex){
	jQuery("#field"+dt4_fieldIdDnxh+"_"+rowindex+"_d").attr("readonly",true);
	
	var _objYfklc = jQuery("#field"+dt4_fieldIdYfklc+"_"+rowindex);
	var _objDnxh = jQuery("#field"+dt4_fieldIdDnxh+"_"+rowindex);
	var _objYfkdh = jQuery("#field"+dt4_fieldIdYfkdh+"_"+rowindex);
	var _objYfkje = jQuery("#field"+dt4_fieldIdYfkje+"_"+rowindex);
	var _objYhje = jQuery("#field"+dt4_fieldIdYhje+"_"+rowindex);
	var _objSpzje = jQuery("#field"+dt4_fieldIdSpzje+"_"+rowindex);
	var _objWhje = jQuery("#field"+dt4_fieldIdWhje+"_"+rowindex);
	
	var Yfklc = _objYfklc.val();
	var dnxh = _objDnxh.val();

	var _objYfkdh_d = jQuery("#field"+dt4_fieldIdYfkdh+"_"+rowindex+"_d");
	var _objYfkje_d = jQuery("#field"+dt4_fieldIdYfkje+"_"+rowindex+"_d");
	var _objYhje_d = jQuery("#field"+dt4_fieldIdYhje+"_"+rowindex+"_d");
	var _objSpzje_d = jQuery("#field"+dt4_fieldIdSpzje+"_"+rowindex+"_d");
	var _objWhje_d = jQuery("#field"+dt4_fieldIdWhje+"_"+rowindex+"_d");
	
	setFieldValue4Mobile(dt4_fieldIdYfkdh, "", "", rowindex);
	setFieldValue4Mobile(dt4_fieldIdYfkje, "", "", rowindex);
	setFieldValue4Mobile(dt4_fieldIdYhje, "", "", rowindex);
	setFieldValue4Mobile(dt4_fieldIdSpzje, "", "", rowindex);
	setFieldValue4Mobile(dt4_fieldIdWhje, "", "", rowindex);
	
	_objYfkdh_d.attr("readonly",true);
	_objYfkje_d.attr("readonly",true);
	_objYhje_d.attr("readonly",true);
	_objSpzje_d.attr("readonly",true);
	_objWhje_d.attr("readonly",true);

	if(fnaRound2(Yfklc,0)>0 && (fnaRound2(dnxh,0)>0 || _objYfkdh.val()=="")){
		var _data = "_____guid1="+_____guid1+"&Yfklc="+Yfklc+"&dnxh="+dnxh+"&requestid="+__requestid;
		jQuery.ajax({
			url : "/mobile/plugin/1/fna/wfpage/getAdvanceRequestInfo4Mobile.jsp",
			type : "post",
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(fnainfo){
				if(fnainfo.flag){
					setYfklcMxRowValue(rowindex, fnainfo.requestmark, fnainfo.Yfkje, fnainfo.yhje, fnainfo.spzje, fnainfo.whje, dnxh, fnainfo.dnxhShowName);
					
				}else{
					alert(fnainfo.errorInfo);
				}
			}
		});
	}else{
		setYfklcMxRowValue(rowindex, "", "", "", "", "", "", "");
	}
}

function setYfklcMxRowValue(rowindex, requestmark, Yfkje, yhje, spzje, whje, dnxh, dnxhShowName){
	setFieldValue4Mobile(dt4_fieldIdYfkdh, requestmark, requestmark, rowindex);
	setFieldValue4Mobile(dt4_fieldIdYfkje, Yfkje, Yfkje, rowindex);
	setFieldValue4Mobile(dt4_fieldIdYhje, yhje, yhje, rowindex);
	setFieldValue4Mobile(dt4_fieldIdSpzje, spzje, spzje, rowindex);
	setFieldValue4Mobile(dt4_fieldIdWhje, whje, whje, rowindex);
	setFieldValue4Mobile(dt4_fieldIdDnxh, dnxh, dnxhShowName, rowindex, true);

	var _dnxhEditObjSpan = jQuery("#field"+dt4_fieldIdDnxh+"_"+rowindex+"_span_d");
	var _dnxh_type = jQuery("#field"+dt4_fieldIdDnxh+"_"+rowindex+"_d").attr("type");
	//创建单内序号按钮
	if(_dnxhEditObjSpan.length && _____module!="7" && _____module!="8" && _dnxh_type != null && _dnxh_type!="hidden"){
		var _dnxhEditObjSpanA = jQuery("#a_field"+dt4_fieldIdDnxh+"_"+rowindex+"_span_d");
		if(!_dnxhEditObjSpanA.length){
			_dnxhEditObjSpan.append("<a id='a_field"+dt4_fieldIdDnxh+"_"+rowindex+"_span_d' "+
				" style='margin-left: 10px;' "+
				" href='javascript:showDialogAdvanceDnxh4Mobile("+rowindex+");'>"+
				"<%=SystemEnv.getHtmlLabelNames("172,83285",user.getLanguage()) %></a>");//选择单内序号
		}
	}
}

function showDialogAdvanceDnxh4Mobile(_indexno){
	var url1 = "/mobile/plugin/1/fna/DialogAdvanceDnxh4Mobile.jsp";
	var _Yfklc = jQuery("#field"+dt4_fieldIdYfklc+"_"+_indexno+"_d").val();
	var __url = url1+"?workflowid="+__workflowid+"&requestid="+__requestid+"&Yfklc="+_Yfklc+"&rowId="+_indexno;
	showDialog_Fna(__url, "", null, "<%=SystemEnv.getHtmlLabelName(83285,user.getLanguage())%>");
}

function fnaAdvanceRepayCallBack2(callbakdata, rowId) {
	//浏览按钮回调
	//_rownum为明细表排序号
	var _rownum = "";
	var _dtid = "";
	var array = callbakdata.split("_");
	if(array!=null && array.length==2){
		_rownum = array[0];
		_dtid = array[1];
	}

	setFieldValue4Mobile(dt4_fieldIdDnxh, _dtid, _rownum, rowId);
	
	getAdvanceRequestInfo(rowId);
}

function fnaAdvanceRepayCallBack1(fieldID, fieldSpan, keys, vals, clickType) {
	//浏览按钮回调
	var _fieldID = "";
	var _indexno = "";
	var fieldIDArray = fieldID.split("_");
	if(fieldIDArray!=null && fieldIDArray.length>=2){
		_fieldID = fieldIDArray[0].replace("field","");
		_indexno = fieldIDArray[1];
	}
	
	getAdvanceRequestInfo(_indexno);
}

</script>