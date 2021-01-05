<%@page import="weaver.fna.maintenance.FnaSystemSetComInfo"%>
<%@page import="org.json.JSONObject"%>
<%@page import="java.util.UUID"%>
<%@page import="weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.hrm.User"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.conn.RecordSet"%>
<%@page import="weaver.general.Util"%>
<%@page import="weaver.workflow.field.BrowserComInfo"%>
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
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
	fieldIdSubject2_isDtl = fieldIdSubject_isDtl;
}
if(Util.getIntValue(fieldIdOrgType2) <= 0){
	fieldIdOrgType2 = fieldIdOrgType;
	fieldIdOrgType2_isDtl = fieldIdOrgType_isDtl;
}
if(Util.getIntValue(fieldIdOrgId2) <= 0){
	fieldIdOrgId2 = fieldIdOrgId;
	fieldIdOrgId2_isDtl = fieldIdOrgId_isDtl;
}
if(Util.getIntValue(fieldIdOccurdate2) <= 0){
	fieldIdOccurdate2 = fieldIdOccurdate;
	fieldIdOccurdate2_isDtl = fieldIdOccurdate_isDtl;
}
if(Util.getIntValue(fieldIdHrmInfo2) <= 0){
	fieldIdHrmInfo2 = fieldIdHrmInfo;
	fieldIdHrmInfo2_isDtl = fieldIdHrmInfo_isDtl;
}
if(Util.getIntValue(fieldIdDepInfo2) <= 0){
	fieldIdDepInfo2 = fieldIdDepInfo;
	fieldIdDepInfo2_isDtl = fieldIdDepInfo_isDtl;
}
if(Util.getIntValue(fieldIdSubInfo2) <= 0){
	fieldIdSubInfo2 = fieldIdSubInfo;
	fieldIdSubInfo2_isDtl = fieldIdSubInfo_isDtl;
}
if(Util.getIntValue(fieldIdFccInfo2) <= 0){
	fieldIdFccInfo2 = fieldIdFccInfo;
	fieldIdFccInfo2_isDtl = fieldIdFccInfo_isDtl;
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

<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="weaver.fna.general.FnaCommon"%><script language="javascript" src="/fna/js/e8Common_wev8.js?r=8"></script>
<script language="javascript">
var _fnaUserId = "<%=user.getUID()%>";
var _fnaLastname = <%=JSONObject.quote(_fnaLastname)%>;
var _fnaDeptId = "<%=_fnaDeptId%>";
var _fnaDeptName = <%=JSONObject.quote(_fnaDeptName)%>;
var _fnaSubcomId = "<%=_fnaSubcomId%>";
var _fnaSubcomName = <%=JSONObject.quote(_fnaSubcomName)%>;
var _fnaFccId = "<%=_fnaFccId%>";
var _fnaFccName = <%=JSONObject.quote(_fnaFccName)%>;

var _FnaSubmitRequestJsFlag = 1;
var _FnaCostCenterStaticIdx = <%=FnaCostCenter.ORGANIZATION_TYPE%>;
var _____guid1 = "<%=guid1 %>";
var _____currentnodetype = "<%=currentnodetype %>";

var dt1_subject = "<%=fieldIdSubject %>";
var dt1_organizationtype = "<%=fieldIdOrgType %>";
var dt1_organizationid = "<%=fieldIdOrgId %>";
var dt1_budgetperiod = "<%=fieldIdOccurdate %>";
var dt1_applyamount = "<%=fieldIdAmount %>";
var dt1_hrmremain = "<%=fieldIdHrmInfo %>";
var dt1_deptremain = "<%=fieldIdDepInfo %>";
var dt1_subcomremain = "<%=fieldIdSubInfo %>";
var dt1_fccremain = "<%=fieldIdFccInfo %>";
var dt1_fieldId_array = [dt1_subject, dt1_organizationtype, dt1_organizationid, dt1_budgetperiod, dt1_applyamount, 
                         dt1_hrmremain, dt1_deptremain, dt1_subcomremain, dt1_fccremain];

var dt1_subject2 = "<%=fieldIdSubject2 %>";
var dt1_organizationtype2 = "<%=fieldIdOrgType2 %>";
var dt1_organizationid2 = "<%=fieldIdOrgId2 %>";
var dt1_budgetperiod2 = "<%=fieldIdOccurdate2 %>";
var dt1_hrmremain2 = "<%=fieldIdHrmInfo2 %>";
var dt1_deptremain2 = "<%=fieldIdDepInfo2 %>";
var dt1_subcomremain2 = "<%=fieldIdSubInfo2 %>";
var dt1_fccremain2 = "<%=fieldIdFccInfo2 %>";
var dt1_fieldId_array2 = [dt1_subject2, dt1_organizationtype2, dt1_organizationid2, dt1_budgetperiod2, 
                         dt1_hrmremain2, dt1_deptremain2, dt1_subcomremain2, dt1_fccremain2];

//是否是明细表字段；1：是明细表；0：是主表；-1：未配置字段；
var dt1_subject_isDtl = "<%=fieldIdSubject_isDtl %>";
var dt1_organizationtype_isDtl = "<%=fieldIdOrgType_isDtl %>";
var dt1_organizationid_isDtl = "<%=fieldIdOrgId_isDtl %>";
var dt1_budgetperiod_isDtl = "<%=fieldIdOccurdate_isDtl %>";
var dt1_applyamount_isDtl = "<%=fieldIdAmount_isDtl %>";
var dt1_hrmremain_isDtl = "<%=fieldIdHrmInfo_isDtl %>";
var dt1_deptremain_isDtl = "<%=fieldIdDepInfo_isDtl %>";
var dt1_subcomremain_isDtl = "<%=fieldIdSubInfo_isDtl %>";
var dt1_fccremain_isDtl = "<%=fieldIdFccInfo_isDtl %>";
//所有字段是否是明细表字段：集合数组
var dt1_fieldId_isDtl_array = [dt1_subject_isDtl, dt1_organizationtype_isDtl, dt1_organizationid_isDtl, dt1_budgetperiod_isDtl, dt1_applyamount_isDtl, 
                       dt1_hrmremain_isDtl, dt1_deptremain_isDtl, dt1_subcomremain_isDtl, dt1_fccremain_isDtl];

//是否包含了明细表字段
var dt1_haveIsDtlField = (dt1_subject_isDtl=="1"||dt1_organizationtype_isDtl=="1"||dt1_organizationid_isDtl=="1"
		||dt1_budgetperiod_isDtl=="1"||dt1_applyamount_isDtl=="1"||dt1_hrmremain_isDtl=="1"
		||dt1_deptremain_isDtl=="1"||dt1_subcomremain_isDtl=="1"||dt1_fccremain_isDtl=="1");


//是否是明细表字段；1：是明细表；0：是主表；-1：未配置字段；
var dt1_subject2_isDtl = "<%=fieldIdSubject2_isDtl %>";
var dt1_organizationtype2_isDtl = "<%=fieldIdOrgType2_isDtl %>";
var dt1_organizationid2_isDtl = "<%=fieldIdOrgId2_isDtl %>";
var dt1_budgetperiod2_isDtl = "<%=fieldIdOccurdate2_isDtl %>";
var dt1_hrmremain2_isDtl = "<%=fieldIdHrmInfo2_isDtl %>";
var dt1_deptremain2_isDtl = "<%=fieldIdDepInfo2_isDtl %>";
var dt1_subcomremain2_isDtl = "<%=fieldIdSubInfo2_isDtl %>";
var dt1_fccremain2_isDtl = "<%=fieldIdFccInfo2_isDtl %>";
//所有字段是否是明细表字段：集合数组
var dt1_fieldId_isDtl_array2 = [dt1_subject2_isDtl, dt1_organizationtype2_isDtl, dt1_organizationid2_isDtl, dt1_budgetperiod2_isDtl, 
                     dt1_hrmremain2_isDtl, dt1_deptremain2_isDtl, dt1_subcomremain2_isDtl, dt1_fccremain2_isDtl];

//是否包含了明细表字段
var dt1_haveIsDtlField2 = (dt1_subject2_isDtl=="1"||dt1_organizationtype2_isDtl=="1"||dt1_organizationid2_isDtl=="1"
		||dt1_budgetperiod2_isDtl=="1"||dt1_hrmremain2_isDtl=="1"
		||dt1_deptremain2_isDtl=="1"||dt1_subcomremain2_isDtl=="1"||dt1_fccremain2_isDtl=="1");
		
var fieldIdOrgId_automaticTake = "<%=fieldIdOrgId_automaticTake %>";
		
var fieldIdOrgId2_automaticTake = "<%=fieldIdOrgId2_automaticTake %>";
                       




var __workflowid = "<%=workflowid %>";

var __requestid = "<%=requestid %>";

var browserUtl_subject = '<%=new BrowserComInfo().getBrowserurl("22") %>';
var browserUtl_hrm = '<%=new BrowserComInfo().getBrowserurl("1") %>%3Fshow_virtual_org=-1';
var browserUtl_dep = '<%=new BrowserComInfo().getBrowserurl("4") %>%3Fshow_virtual_org=-1';
var browserUtl_sub = '<%=new BrowserComInfo().getBrowserurl("164") %>%3Fshow_virtual_org=-1';
var browserUtl_prj = '<%=new BrowserComInfo().getBrowserurl("8") %>';
var browserUtl_crm = '<%=new BrowserComInfo().getBrowserurl("7") %>';
var browserUtl_fcc = '<%=new BrowserComInfo().getBrowserurl("251") %>';


//判断出入的字段id中，是否有预算变更流程表更明细业务逻辑字段且该字段不是明细表字段
function getIsMainField(fieldid){
	var _isMainField = false;
	if(dt1_subject==fieldid && dt1_subject_isDtl!="1"){
		_isMainField = true;
	}else if(dt1_organizationtype==fieldid && dt1_organizationtype_isDtl!="1"){
		_isMainField = true;
	}else if(dt1_organizationid==fieldid && dt1_organizationid_isDtl!="1"){
		_isMainField = true;
	}else if(dt1_budgetperiod==fieldid && dt1_budgetperiod_isDtl!="1"){
		_isMainField = true;
	}
	return _isMainField;
}
function getIsMainField2(fieldid){
	var _isMainField = false;
	if(dt1_subject2==fieldid && dt1_subject2_isDtl!="1"){
		_isMainField = true;
	}else if(dt1_organizationtype2==fieldid && dt1_organizationtype2_isDtl!="1"){
		_isMainField = true;
	}else if(dt1_organizationid2==fieldid && dt1_organizationid2_isDtl!="1"){
		_isMainField = true;
	}else if(dt1_budgetperiod2==fieldid && dt1_budgetperiod2_isDtl!="1"){
		_isMainField = true;
	}
	return _isMainField;
}
//browser回调方法
function wfbrowvaluechange_fna(obj, fieldid, rowindex) {
	if(dt1_subject==fieldid || dt1_organizationtype==fieldid || dt1_organizationid==fieldid || dt1_budgetperiod==fieldid){
		var _isMainField = getIsMainField(fieldid);
		if(_isMainField && dt1_haveIsDtlField){
			var _xm_array3 = jQuery("input[name='check_node_0']");
			for(var i=0;i<_xm_array3.length;i++){
				var _idx = parseInt(jQuery(_xm_array3[i]).val());
				if(!isNaN(_idx) && _idx>=0){
					if(dt1_organizationid==fieldid){
						clearSubjectById(_idx, "");
					}
					getFnaInfoData(_idx, "");
			    }
			}
		}else{
			if(dt1_organizationid==fieldid){
				clearSubjectById(rowindex, "");
			}
			getFnaInfoData(rowindex, "");
		}
	}
	if(dt1_subject2==fieldid || dt1_organizationtype2==fieldid || dt1_organizationid2==fieldid || dt1_budgetperiod2==fieldid){
		var _isMainField = getIsMainField2(fieldid);
		if(_isMainField && dt1_haveIsDtlField2){
			var _xm_array3 = jQuery("input[name='check_node_0']");
			for(var i=0;i<_xm_array3.length;i++){
				var _idx = parseInt(jQuery(_xm_array3[i]).val());
				if(!isNaN(_idx) && _idx>=0){
					if(dt1_organizationid2==fieldid){
						clearSubjectById(_idx, "2");
					}
					getFnaInfoData(_idx, "2");
			    }
			}
		}else{
			if(dt1_organizationid2==fieldid){
				clearSubjectById(rowindex, "2");
			}
			getFnaInfoData(rowindex, "2");
		}
	}
}
//渲染浏览按钮initE8Browser_fna _fieldId=field5881_0;0
function initE8Browser_fna(_fieldId, _insertindex, _ismand, _browserValue, _browserSpanValue, _detailbrowclick, _completeUrl, _fieldId2, _type0){
	var _isMustInput = "1";
	if(_ismand==1){
		_isMustInput = "2";
	}
	var _wrapObj = null;
	var _needHidden = false;
	var _viewType = "0";
	if((dt1_organizationid_isDtl=="1" && _type0!="2" && _fieldId==dt1_organizationid+"_"+_insertindex) 
			|| (dt1_organizationid2_isDtl=="1" && _type0=="2" && _fieldId==dt1_organizationid2+"_"+_insertindex)){
		_wrapObj = jQuery("#field"+_fieldId+"wrapspan");
		_wrapObj.html("");
		_viewType = "1";
	}else{
		_insertindex = "null";
		//_needHidden = true;
		_wrapObj = jQuery("#field"+_fieldId+"wrapspan");
		if(_wrapObj.length==0){
			var _tdwrapObj = jQuery("#field"+_fieldId+"_tdwrap");
			var _wrapObj_div1 = _tdwrapObj.children("div");
			var _wrapObj_div2 = _wrapObj_div1.children("div");
			jQuery(_wrapObj_div2).remove();
			_wrapObj_div1.append("<span id=\"field"+_fieldId+"wrapspan\"></span>");
			_wrapObj = jQuery("#field"+_fieldId+"wrapspan");
		}
	}
	_wrapObj.e8Browser({
		name:"field"+_fieldId,
		viewType:_viewType,
		browserValue: _browserValue,
		browserSpanValue: _browserSpanValue,
		browserOnClick: _detailbrowclick,
		hasInput:true,
		isSingle:true,
		hasBrowser:true, 
		isMustInput:_isMustInput,
		completeUrl:_completeUrl,
		width:"95%",
		needHidden:_needHidden,
		onPropertyChange:"wfbrowvaluechange(this, "+_fieldId2+", "+_insertindex+")"
	});
}
//生成费用单位浏览按钮事件
function onShowOrganizationBtn_fna_type1(insertindex, _browserId, _browserName, _notDoClearBtnById){
	if(_notDoClearBtnById==null){
		_notDoClearBtnById = false;
	}
	if(!_notDoClearBtnById){
		clearSubjectById(insertindex, "");
	}
	
	var _orgIdObj = null;
	if(dt1_organizationid_isDtl=="1"){
		_orgIdObj = jQuery("#field"+dt1_organizationid+"_"+insertindex);
	}else{
		_orgIdObj = jQuery("#field"+dt1_organizationid);
	}
	_orgIdObj.val("");
    var organizationidismand = _orgIdObj.attr("viewtype");
    
	var orgType = getWfMainAndDetailFieldValueForPc(dt1_organizationtype, dt1_organizationtype_isDtl, insertindex);

	var btnType = "4";
	var browserUtl = browserUtl_dep;
    if (orgType == "0"){
    	btnType = "1";
    	browserUtl = browserUtl_hrm;
    }else if (orgType == "1"){
    	btnType = "4";
    	browserUtl = browserUtl_dep;
    }else if (orgType == "2"){
    	btnType = "164";
    	browserUtl = browserUtl_sub;
    }else if (orgType == "3"){
    	btnType = "251";
    	browserUtl = browserUtl_fcc;
    }else{
    	return;
    }

	if(dt1_organizationid_isDtl=="1"){
		var detailbrowclick = "onShowBrowser2('"+dt1_organizationid+"_"+insertindex+"','"+browserUtl+"','','"+btnType+"','"+organizationidismand+"')";
	    initE8Browser_fna(""+dt1_organizationid+"_"+insertindex, insertindex, organizationidismand, _browserId, _browserName, detailbrowclick, 
	    	    "/data.jsp?show_virtual_org=-1&type="+btnType+"&bdf_wfid=<%=workflowid%>&bdf_fieldid="+dt1_organizationid, dt1_organizationid, "");
	    _orgIdObj = jQuery("#field"+dt1_organizationid+"_"+insertindex);
	    if(_orgIdObj.length==1){
	    	_orgIdObj = _orgIdObj[0];
	    }
		setOrganizationidSpan(insertindex,"1");
		wfbrowvaluechange(_orgIdObj, dt1_organizationid, insertindex);
	}else{
		var detailbrowclick = "onShowBrowser2('"+dt1_organizationid+"','"+browserUtl+"','','"+btnType+"','"+organizationidismand+"')";
	    initE8Browser_fna(""+dt1_organizationid, "null", organizationidismand, _browserId, _browserName, detailbrowclick, 
	    	    "/data.jsp?show_virtual_org=-1&type="+btnType+"&bdf_wfid=<%=workflowid%>&bdf_fieldid="+dt1_organizationid, dt1_organizationid, "");
	    _orgIdObj = jQuery("#field"+dt1_organizationid);
	    if(_orgIdObj.length==1){
	    	_orgIdObj = _orgIdObj[0];
	    }
		setOrganizationidSpan("","1");
		wfbrowvaluechange(_orgIdObj, dt1_organizationid);
	}
}
//生成费用单位浏览按钮事件
function onShowOrganizationBtn_fna_type2(insertindex, _browserId, _browserName, _notDoClearBtnById){
	if(_notDoClearBtnById==null){
		_notDoClearBtnById = false;
	}
	if(!_notDoClearBtnById){
		clearSubjectById(insertindex, "2");
	}
	
	var _orgIdObj = null;
	if(dt1_organizationid2_isDtl=="1"){
		_orgIdObj = jQuery("#field"+dt1_organizationid2+"_"+insertindex);
	}else{
		_orgIdObj = jQuery("#field"+dt1_organizationid2);
	}
	_orgIdObj.val("");
    var organizationidismand = _orgIdObj.attr("viewtype");
    
	var orgType = getWfMainAndDetailFieldValueForPc(dt1_organizationtype2, dt1_organizationtype2_isDtl, insertindex);

	var btnType = "4";
	var browserUtl = browserUtl_dep;
    if (orgType == "0"){
    	btnType = "1";
    	browserUtl = browserUtl_hrm;
    }else if (orgType == "1"){
    	btnType = "4";
    	browserUtl = browserUtl_dep;
    }else if (orgType == "2"){
    	btnType = "164";
    	browserUtl = browserUtl_sub;
    }else if (orgType == "3"){
    	btnType = "251";
    	browserUtl = browserUtl_fcc;
    }else{
    	return;
    }

	if(dt1_organizationid2_isDtl=="1"){
		var detailbrowclick = "onShowBrowser2('"+dt1_organizationid2+"_"+insertindex+"','"+browserUtl+"','','"+btnType+"','"+organizationidismand+"')";
	    initE8Browser_fna(""+dt1_organizationid2+"_"+insertindex, insertindex, organizationidismand, _browserId, _browserName, detailbrowclick, 
	    	    "/data.jsp?show_virtual_org=-1&type="+btnType+"&bdf_wfid=<%=workflowid%>&bdf_fieldid="+dt1_organizationid2, dt1_organizationid2, "2");
	    _orgIdObj = jQuery("#field"+dt1_organizationid2+"_"+insertindex);
	    if(_orgIdObj.length==1){
	    	_orgIdObj = _orgIdObj[0];
	    }
		setOrganizationidSpan(insertindex,"2");
		wfbrowvaluechange(_orgIdObj, dt1_organizationid2, insertindex);
	}else{
		var detailbrowclick = "onShowBrowser2('"+dt1_organizationid2+"','"+browserUtl+"','','"+btnType+"','"+organizationidismand+"')";
	    initE8Browser_fna(""+dt1_organizationid2, "null", organizationidismand, _browserId, _browserName, detailbrowclick, 
	    	    "/data.jsp?show_virtual_org=-1&type="+btnType+"&bdf_wfid=<%=workflowid%>&bdf_fieldid="+dt1_organizationid2, dt1_organizationid2, "2");
	    _orgIdObj = jQuery("#field"+dt1_organizationid2);
	    if(_orgIdObj.length==1){
	    	_orgIdObj = _orgIdObj[0];
	    }
		setOrganizationidSpan("","2");
		wfbrowvaluechange(_orgIdObj, dt1_organizationid2);
	}
}
//生成费用单位浏览按钮事件
function onShowOrganizationBtn_fna(insertindex, _browserId, _browserName, _notDoClearBtnById, _type0){
	if(_type0=="2"){
		onShowOrganizationBtn_fna_type2(insertindex, _browserId, _browserName, _notDoClearBtnById);
	}else{
		onShowOrganizationBtn_fna_type1(insertindex, _browserId, _browserName, _notDoClearBtnById);
	}
}

function setOrganizationidSpan(indexno,type){
	var orgtype1 = getWfMainAndDetailFieldValueForPc(dt1_organizationtype, dt1_organizationtype_isDtl, indexno);
	var orgtype2 = getWfMainAndDetailFieldValueForPc(dt1_organizationtype2, dt1_organizationtype2_isDtl, indexno);
	var _id1 = "";
	var _name1 = "";
	var _id2 = "";
	var _name2 = "";
	if(orgtype1 == "0"){
		_id1 = _fnaUserId;
		_name1 = _fnaLastname;
	}else if(orgtype1 == "1"){
		_id1 = _fnaDeptId;
		_name1 = _fnaDeptName;
	}else if(orgtype1 == "2"){
		_id1 = _fnaSubcomId;
		_name1 = _fnaSubcomName;
	}else if(orgtype1 == "3"){
		_id1 = _fnaFccId;
		_name1 = _fnaFccName;
	}
	if(orgtype2 == "0"){
		_id2 = _fnaUserId;
		_name2 = _fnaLastname;
	}else if(orgtype2 == "1"){
		_id2 = _fnaDeptId;
		_name2 = _fnaDeptName;
	}else if(orgtype2 == "2"){
		_id2 = _fnaSubcomId;
		_name2 = _fnaSubcomName;
	}else if(orgtype2 == "3"){
		_id2 = _fnaFccId;
		_name2 = _fnaFccName;
	}
	if(type == "1"){
		if(fieldIdOrgId_automaticTake=="1"){
			/*
			setWfMainAndDetailFieldValueForPc(_id1, dt1_organizationid, dt1_organizationid_isDtl, indexno);
			setWfMainAndDetailFieldSpanValueForPc(_name1, dt1_organizationid, dt1_organizationid_isDtl, indexno);
			*/
			var _orgFullId = "field"+dt1_organizationid;
			if(dt1_organizationid_isDtl==1){
				_orgFullId += "_"+indexno;
			}
	        _writeBackData(_orgFullId, 2, {id:_id1,name:_name1},  {hasInput:true,replace:true,isSingle:true,isedit:true});
		}
	}else{
		if(fieldIdOrgId2_automaticTake=="1"){
			/*
			setWfMainAndDetailFieldValueForPc(_id2, dt1_organizationid2, dt1_organizationid2_isDtl, indexno);
			setWfMainAndDetailFieldSpanValueForPc(_name2, dt1_organizationid2, dt1_organizationid2_isDtl, indexno);
			*/
			var _orgFullId = "field"+dt1_organizationid2;
			if(dt1_organizationid2_isDtl==1){
				_orgFullId += "_"+indexno;
			}
	        _writeBackData(_orgFullId, 2, {id:_id2,name:_name2},  {hasInput:true,replace:true,isSingle:true,isedit:true});
		}
	}
}

function bindfee(value){
	if(dt1_haveIsDtlField || dt1_haveIsDtlField2){
	    var indexnum0 = -1;
		var _xm_array3 = jQuery("input[name='check_node_0']");
		if(_xm_array3.length > 0){
			var _idx = parseInt(jQuery(_xm_array3[_xm_array3.length-1]).val());
			if(!isNaN(_idx) && _idx>=0){
				indexnum0 = _idx;
			}
		}
	    if(indexnum0>=0){
	    	var orgid1 = getWfMainAndDetailFieldValueForPc(dt1_organizationid, dt1_organizationid_isDtl, indexnum0);
	    	var orgid2 = getWfMainAndDetailFieldValueForPc(dt1_organizationid2, dt1_organizationid2_isDtl, indexnum0);
	    	if(orgid1 == ""){
		    	setOrganizationidSpan(indexnum0,"1");
	    	}
	    	if(orgid2 == ""){
	    		setOrganizationidSpan(indexnum0,"2");
	    	}
	    	
			if(value==1){
				if(dt1_organizationtype_isDtl=="1"){
					jQuery("#field"+dt1_organizationtype+"_"+indexnum0).bind("change",function(){
						var _idx1 = parseInt(jQuery(this).attr("name").replace("field"+dt1_organizationtype+"_",""));
				    	onShowOrganizationBtn_fna(_idx1+"", "", "", null, "");
					});
				}
				if(dt1_budgetperiod_isDtl=="1"){
					jQuery("#field"+dt1_budgetperiod+"_"+indexnum0).bindPropertyChange(function(targetobj){
						var _idx1 = parseInt(jQuery(targetobj).attr("name").replace("field"+dt1_budgetperiod+"_",""));
						getFnaInfoData(_idx1, "");
					});
				}
				
				if(dt1_organizationtype2_isDtl=="1" && dt1_organizationtype != dt1_organizationtype2){
					jQuery("#field"+dt1_organizationtype2+"_"+indexnum0).bind("change",function(){
						var _idx1 = parseInt(jQuery(this).attr("name").replace("field"+dt1_organizationtype2+"_",""));
				    	onShowOrganizationBtn_fna(_idx1+"", "", "", null, "2");
					});
				}
				if(dt1_budgetperiod2_isDtl=="1" && dt1_budgetperiod != dt1_budgetperiod2){
					jQuery("#field"+dt1_budgetperiod2+"_"+indexnum0).bindPropertyChange(function(targetobj){
						var _idx1 = parseInt(jQuery(targetobj).attr("name").replace("field"+dt1_budgetperiod2+"_",""));
						getFnaInfoData(_idx1, "2");
					});
				}
			    
				getFnaInfoData(indexnum0, "");
				getFnaInfoData(indexnum0, "2");
			}else if(value==2){
				var _xm_array = jQuery("input[name='check_node_0']");
				var _xm_array_length = _xm_array.length;
				for(var i0=0;i0<_xm_array_length;i0++){
					var _idx = parseInt(jQuery(_xm_array[i0]).val());
					if(!isNaN(_idx) && _idx>=0){
						if(dt1_organizationtype_isDtl=="1"){
						    jQuery("#field"+dt1_organizationtype+"_"+_idx).bind("change",function(){
								var _idx1 = parseInt(jQuery(this).attr("name").replace("field"+dt1_organizationtype+"_",""));
						    	onShowOrganizationBtn_fna(_idx1, "", "", null, "");
							});
						}
						if(dt1_budgetperiod_isDtl=="1"){
							jQuery("#field"+dt1_budgetperiod+"_"+_idx).bindPropertyChange(function(targetobj){
								var _idx1 = parseInt(jQuery(targetobj).attr("name").replace("field"+dt1_budgetperiod+"_",""));
								getFnaInfoData(_idx1, "");
							});
						}
					    
						if(dt1_organizationtype2_isDtl=="1" && dt1_organizationtype != dt1_organizationtype2){
						    jQuery("#field"+dt1_organizationtype2+"_"+_idx).bind("change",function(){
								var _idx1 = parseInt(jQuery(this).attr("name").replace("field"+dt1_organizationtype2+"_",""));
						    	onShowOrganizationBtn_fna(_idx1, "", "", null, "2");
							});
						}
						if(dt1_budgetperiod2_isDtl=="1" && dt1_budgetperiod != dt1_budgetperiod2){
							jQuery("#field"+dt1_budgetperiod2+"_"+_idx).bindPropertyChange(function(targetobj){
								var _idx1 = parseInt(jQuery(targetobj).attr("name").replace("field"+dt1_budgetperiod2+"_",""));
								getFnaInfoData(_idx1, "2");
							});
						}
					    
						getFnaInfoData(_idx, "");
						getFnaInfoData(_idx, "2");
					}
				}
			}
		}
	}
	if(value==2){
		var orgid1 = getWfMainAndDetailFieldValueForPc(dt1_organizationid, dt1_organizationid_isDtl, "");
    	var orgid2 = getWfMainAndDetailFieldValueForPc(dt1_organizationid2, dt1_organizationid2_isDtl, "");
    	if(orgid1 == ""){
    		setOrganizationidSpan("","1");
    	}
    	if(orgid2 == ""){
    		setOrganizationidSpan("","2");
    	}
    	
		if(dt1_organizationtype_isDtl!="1"){
			jQuery("#field"+dt1_organizationtype).bind("change",function(){
		    	onShowOrganizationBtn_fna("", "", "", null, "");
			});
		}
		if(dt1_budgetperiod_isDtl!="1"){
			jQuery("#field"+dt1_budgetperiod).bindPropertyChange(function(targetobj){
				getFnaInfoData("", "");
			});
		}

		if(dt1_organizationtype2_isDtl!="1" && dt1_organizationtype != dt1_organizationtype2){
			jQuery("#field"+dt1_organizationtype2).bind("change",function(){
		    	onShowOrganizationBtn_fna("", "", "", null, "2");
			});
		}
		if(dt1_budgetperiod2_isDtl!="1" && dt1_budgetperiod != dt1_budgetperiod2){
			jQuery("#field"+dt1_budgetperiod2).bindPropertyChange(function(targetobj){
				getFnaInfoData("", "2");
			});
		}
		
		if(dt1_organizationtype_isDtl!="1" || dt1_budgetperiod_isDtl!="1"){
			getFnaInfoData("");
		}
		if((dt1_organizationtype2_isDtl!="1" && dt1_organizationtype != dt1_organizationtype2) || (dt1_budgetperiod2_isDtl!="1" && dt1_budgetperiod != dt1_budgetperiod2)){
			getFnaInfoData("", "2");
		}
	}
}
 
function getFnaInfoData(indexno, _type0){
	var budgetfeetype = "";
	var orgtype = "";
	var orgid = "";
	var applydate = "";
	if(_type0=="2"){
		budgetfeetype = getWfMainAndDetailFieldValueForPc(dt1_subject2, dt1_subject2_isDtl, indexno);
		orgtype = getWfMainAndDetailFieldValueForPc(dt1_organizationtype2, dt1_organizationtype2_isDtl, indexno);
		orgid = getWfMainAndDetailFieldValueForPc(dt1_organizationid2, dt1_organizationid2_isDtl, indexno);
		applydate = getWfMainAndDetailFieldValueForPc(dt1_budgetperiod2, dt1_budgetperiod2_isDtl, indexno);
	}else{
		budgetfeetype = getWfMainAndDetailFieldValueForPc(dt1_subject, dt1_subject_isDtl, indexno);
		orgtype = getWfMainAndDetailFieldValueForPc(dt1_organizationtype, dt1_organizationtype_isDtl, indexno);
		orgid = getWfMainAndDetailFieldValueForPc(dt1_organizationid, dt1_organizationid_isDtl, indexno);
		applydate = getWfMainAndDetailFieldValueForPc(dt1_budgetperiod, dt1_budgetperiod_isDtl, indexno);
	}
	
	var _data = "budgetfeetype="+budgetfeetype+"&orgtype="+orgtype+"&orgid="+orgid+"&applydate="+applydate;

	jQuery.ajax({
		url : "/workflow/request/FnaBudgetInfoAjax.jsp",
		type : "post",
		processData : false,
		data : _data,
		dataType : "html",
		success: function do4Success(msg){
			getFnaInfoData_callBack(jQuery.trim(msg), indexno, _type0);
		}
	});	
}
function getFnaInfoData_callBack(msg, indexno, _type0){
	try{
		var orgtype = -1;
		if(_type0=="2"){
			orgtype = getWfMainAndDetailFieldValueForPc(dt1_organizationtype2, dt1_organizationtype2_isDtl, indexno);
		}else{
			orgtype = getWfMainAndDetailFieldValueForPc(dt1_organizationtype, dt1_organizationtype_isDtl, indexno);
		}
		
	    var fnainfos = jQuery.trim(msg).split("|");
	
	    var budgetAutoMoveInfo = "";
		if(fnainfos.length>=5){
			budgetAutoMoveInfo = fnainfos[4];
			if(budgetAutoMoveInfo!=""){
				budgetAutoMoveInfo = "<%=SystemEnv.getHtmlLabelName(126630,user.getLanguage())%>:"+budgetAutoMoveInfo;
			}
	    }
	
	    var _dt1_remain_array = [];
		if(_type0=="2"){
			_dt1_remain_array = [dt1_hrmremain2, dt1_deptremain2, dt1_subcomremain2, dt1_fccremain2];
		}else{
			_dt1_remain_array = [dt1_hrmremain, dt1_deptremain, dt1_subcomremain, dt1_fccremain];
		}
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
	        var dt1_haveIsDtlField_value = "1";
	    	if(_type0=="2"){
	    		dt1_haveIsDtlField_value = (dt1_haveIsDtlField2?"1":"0");
	    	}else{
	    		dt1_haveIsDtlField_value = (dt1_haveIsDtlField?"1":"0");
	    	}
	    	setWfMainAndDetailFieldSpanValueForPc(tempmsg, _dt1_remain, dt1_haveIsDtlField_value, indexno);
		}
	}catch(exSplit01){}
}

//jQuery(document).ready(function(){
	fnaifoverJson_doSubmit = function(obj){
		try{
			enableAllmenu();
			var temprequestid = __requestid;
			var poststr = "";
			if(dt1_haveIsDtlField || dt1_haveIsDtlField2){
				var _xm_array = jQuery("input[name='check_node_0']");
				for(var i0=0;i0<_xm_array.length;i0++){
					try{
						var _idx = parseInt(jQuery(_xm_array[i0]).val());
						if(!isNaN(_idx) && _idx>=0){
							var budgetfeetype = getWfMainAndDetailFieldValueForPc(dt1_subject, dt1_subject_isDtl, _idx);
							var orgtype = getWfMainAndDetailFieldValueForPc(dt1_organizationtype, dt1_organizationtype_isDtl, _idx);
							var orgid = getWfMainAndDetailFieldValueForPc(dt1_organizationid, dt1_organizationid_isDtl, _idx);
							var applydate = getWfMainAndDetailFieldValueForPc(dt1_budgetperiod, dt1_budgetperiod_isDtl, _idx);
							var applyamount = getWfMainAndDetailFieldValueForPc(dt1_applyamount, dt1_applyamount_isDtl, _idx);
							if(budgetfeetype==""){budgetfeetype="0";}
							if(orgtype==""){orgtype="-1";}
							if(applyamount==""){applyamount="0";}

							var budgetfeetype2 = getWfMainAndDetailFieldValueForPc(dt1_subject2, dt1_subject2_isDtl, _idx);
							var orgtype2 = getWfMainAndDetailFieldValueForPc(dt1_organizationtype2, dt1_organizationtype2_isDtl, _idx);
							var orgid2 = getWfMainAndDetailFieldValueForPc(dt1_organizationid2, dt1_organizationid2_isDtl, _idx);
							var applydate2 = getWfMainAndDetailFieldValueForPc(dt1_budgetperiod2, dt1_budgetperiod2_isDtl, _idx);
							if(budgetfeetype2==""){budgetfeetype2="0";}
							if(orgtype2==""){orgtype2="-1";}
						    
						    if(poststr!=""){
						    	poststr += "|";
						    }
					    	poststr += budgetfeetype+","+orgtype+","+orgid+","+applydate+","+applyamount+","+
					    		budgetfeetype2+","+orgtype2+","+orgid2+","+applydate2+",postStrEnd";
						}
					}catch(e){}
				}
			}else{
				var budgetfeetype = getWfMainAndDetailFieldValueForPc(dt1_subject, dt1_subject_isDtl, "");
				var orgtype = getWfMainAndDetailFieldValueForPc(dt1_organizationtype, dt1_organizationtype_isDtl, "");
				var orgid = getWfMainAndDetailFieldValueForPc(dt1_organizationid, dt1_organizationid_isDtl, "");
				var applydate = getWfMainAndDetailFieldValueForPc(dt1_budgetperiod, dt1_budgetperiod_isDtl, "");
				var applyamount = getWfMainAndDetailFieldValueForPc(dt1_applyamount, dt1_applyamount_isDtl, "");
				if(budgetfeetype==""){budgetfeetype="0";}
				if(orgtype==""){orgtype="-1";}
				if(applyamount==""){applyamount="0";}

				var budgetfeetype2 = getWfMainAndDetailFieldValueForPc(dt1_subject2, dt1_subject2_isDtl, "");
				var orgtype2 = getWfMainAndDetailFieldValueForPc(dt1_organizationtype2, dt1_organizationtype2_isDtl, "");
				var orgid2 = getWfMainAndDetailFieldValueForPc(dt1_organizationid2, dt1_organizationid2_isDtl, "");
				var applydate2 = getWfMainAndDetailFieldValueForPc(dt1_budgetperiod2, dt1_budgetperiod2_isDtl, "");
				if(budgetfeetype2==""){budgetfeetype2="0";}
				if(orgtype2==""){orgtype2="-1";}
			    
			    if(poststr!=""){
			    	poststr += "|";
			    }
		    	poststr += budgetfeetype+","+orgtype+","+orgid+","+applydate+","+applyamount+","+
		    		budgetfeetype2+","+orgtype2+","+orgid2+","+applydate2+",postStrEnd";
			}

			if(poststr!=""){
			}else{
				displayAllmenu();
				return doSubmitE8(obj);
			}
			
			
			var _data = "poststr="+poststr+"&requestid="+temprequestid+"&workflowid="+__workflowid;
			
			jQuery.ajax({
				url : "/fna/budget/FnaChangeifoverJsonAjax.jsp",
				type : "post",
				processData : false,
				data : _data,
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

function clearSubjectById(rowId, _type0){
	<%if(subjectFilter){ %>
		var budgetfeetype="";
		var orgtype="";
		var orgid="";
		if(_type0=="2"){
			budgetfeetype = getWfMainAndDetailFieldValueForPc(dt1_subject2, dt1_subject2_isDtl, rowId);
			orgtype = getWfMainAndDetailFieldValueForPc(dt1_organizationtype2, dt1_organizationtype2_isDtl, rowId);
			orgid = getWfMainAndDetailFieldValueForPc(dt1_organizationid2, dt1_organizationid2_isDtl, rowId);
		}else{
			budgetfeetype = getWfMainAndDetailFieldValueForPc(dt1_subject, dt1_subject_isDtl, rowId);
			orgtype = getWfMainAndDetailFieldValueForPc(dt1_organizationtype, dt1_organizationtype_isDtl, rowId);
			orgid = getWfMainAndDetailFieldValueForPc(dt1_organizationid, dt1_organizationid_isDtl, rowId);
		}
		if(budgetfeetype != "" && orgid !=""){
			jQuery.ajax({
				url : "/fna/wfPage/getClearSubjectInfo.jsp",
				type : "post",
				processData : false,
				data : "budgetfeetype="+budgetfeetype+"&orgtype="+orgtype+"&orgid="+orgid,
				dataType : "json",
				success: function do4Success(fnainfo){
					if(fnainfo.flag){
						if(fnainfo.change != "1"){
							if(_type0=="2"){
								clearBtnById(dt1_subject2,rowId);
								getFnaInfoData(rowId, "2");
							}else{
								clearBtnById(dt1_subject,rowId);
								getFnaInfoData(rowId, "");
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
	if(fieldId!=null&&fieldId!=""){
		var isDtl = "1";
		for(var i=0;i<dt1_fieldId_array.length;i++){
			if(dt1_fieldId_array[i]==fieldId){
				isDtl = dt1_fieldId_isDtl_array[i];
				break;
			}
		}
		for(var i=0;i<dt1_fieldId_array2.length;i++){
			if(dt1_fieldId_array2[i]==fieldId){
				isDtl = dt1_fieldId_isDtl_array2[i];
				break;
			}
		}
		setWfMainAndDetailFieldValueForPc("", fieldId, isDtl, rowId);
		setWfMainAndDetailFieldSpanValueForPc("", fieldId, isDtl, rowId);
	}
}

jQuery(document).ready(function(){
	if(dt1_haveIsDtlField || dt1_haveIsDtlField2){
		jQuery("button[name='delbutton0']").bind("click",function(){
			try{window.calSum(0);}catch(ex1){}
		});
		jQuery("button[name='addbutton0']").bind("click",function(){
			bindfee(1);
		});
	}
    bindfee(2);

});
</script>