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
<%@page import="weaver.fna.maintenance.FnaCostCenter"%>
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
RecordSet rs1 = new RecordSet();

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

int main_fieldIdFysqlc_isWfFieldLinkage = Util.getIntValue(dataMap.get("main_fieldIdFysqlc_isWfFieldLinkage"), 0);

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
boolean isNewWf = false;//是否配置了两个字段
if(!"".equals(fieldIdReqId) && !"".equals(fieldIdReqDtId)){
	isNewWf=true;
}

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

StringBuffer _Fna_content_view_id_array = new StringBuffer();
sql = "select a.id from synergy_base a where a.wfid = "+workflowid;
rs.executeSql(sql);
while(rs.next()){
	String sql1 = "select eid from fnaBudgetAssistant1 where ebaseid='fnaBudgetAssistant1' and hpid = -"+rs.getInt("id");
	rs1.executeSql(sql1);
	while(rs1.next()){
		if(_Fna_content_view_id_array.length()>0){
			_Fna_content_view_id_array.append(",");
		}
		_Fna_content_view_id_array.append(rs1.getInt("eid"));
	}
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
<script language="javascript" src="/fna/js/e8Common_wev8.js?r=15"></script>
<script language="javascript">
var _fnaUserId = "<%=user.getUID()%>";
var _fnaLastname = <%=JSONObject.quote(_fnaLastname)%>;
var _fnaDeptId = "<%=_fnaDeptId%>";
var _fnaDeptName = <%=JSONObject.quote(_fnaDeptName)%>;
var _fnaSubcomId = "<%=_fnaSubcomId%>";
var _fnaSubcomName = <%=JSONObject.quote(_fnaSubcomName)%>;
var _fnaFccId = "<%=_fnaFccId%>";
var _fnaFccName = <%=JSONObject.quote(_fnaFccName)%>;

var _onRefresh_fnaBudgetAssistant1_flag = false;
var _Fna_content_view_id_array = [<%=_Fna_content_view_id_array.toString()%>];

var _FnaSubmitRequestJsFlag = 1;
var _FnaCostCenterStaticIdx = <%=FnaCostCenter.ORGANIZATION_TYPE%>;
var _____guid1 = "<%=guid1 %>";
var _____currentnodetype = "<%=currentnodetype %>";

var haveApplicationBudget = <%=(haveApplicationBudget)?"true":"false" %>;

var main_fieldIdSqr = "<%=main_fieldIdSqr %>";
var main_fieldIdSqr_controlBorrowingWf = "<%=main_fieldIdSqr_controlBorrowingWf %>";
var main_fieldIdFysqlc = "<%=main_fieldIdFysqlc %>";
var main_fieldIdSfbxwc = "<%=main_fieldIdSfbxwc %>";
var main_fieldIdYfkZfHj = "<%=main_fieldIdYfkZfHj %>";

//费用申请流程是否通过标准产品流程字段联动带出明细数据
var main_fieldIdFysqlc_isWfFieldLinkage = "<%=main_fieldIdFysqlc_isWfFieldLinkage %>";

//报销明细字段
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
var isNewWf = <%=isNewWf %>;
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




var __workflowid = "<%=workflowid %>";

var __requestid = "<%=requestid %>";

var browserUtl_subject = '<%=new BrowserComInfo().getBrowserurl("22") %>';
var browserUtl_hrm = '<%=new BrowserComInfo().getBrowserurl("1") %>%3Fshow_virtual_org=-1';
var browserUtl_dep = '<%=new BrowserComInfo().getBrowserurl("4") %>%3Fshow_virtual_org=-1';
var browserUtl_sub = '<%=new BrowserComInfo().getBrowserurl("164") %>%3Fshow_virtual_org=-1';
var browserUtl_prj = '<%=new BrowserComInfo().getBrowserurl("8") %>';
var browserUtl_crm = '<%=new BrowserComInfo().getBrowserurl("7") %>';
var browserUtl_fcc = '<%=new BrowserComInfo().getBrowserurl("251") %>';


//获取借款信息
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
				setWfMainAndDetailFieldValueForPc(fnainfo.requestmark, dt2_fieldIdJkdh, "1", rowindex);
				setWfMainAndDetailFieldValueForPc(fnainfo.jkje, dt2_fieldIdJkje, "1", rowindex);
				setWfMainAndDetailFieldValueForPc(fnainfo.yhje, dt2_fieldIdYhje, "1", rowindex);
				setWfMainAndDetailFieldValueForPc(fnainfo.spzje, dt2_fieldIdSpzje, "1", rowindex);
				setWfMainAndDetailFieldValueForPc(fnainfo.whje, dt2_fieldIdWhje, "1", rowindex);
				try{window.calSum(1);}catch(ex1){}
			}else{
				top.Dialog.alert(fnainfo.errorInfo);
			}
		}
	});
}
//设置单内序号回调函数
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
//显示借款信息浏览框
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

function _fnaBorrowSkfsDtl2_onchange(_obj, _notUpdateVal){
	_fnaBorrowSkfsDtl3_onchange(_obj, _notUpdateVal);
}

function _fnaBorrowSkfsDtl3_onchange(_obj, _notUpdateVal){
	if(_notUpdateVal==null){//是否不更新账户信息
		_notUpdateVal = false;
	}
	var objId = _obj.id;
	var _fieldId = objId.split("_")[0];
	var _dtlNumber = objId.split("_")[1];

	var objKhyh = jQuery("#field"+dt3_fieldIdKhyh+"_"+_dtlNumber);
	var objHuming = jQuery("#field"+dt3_fieldIdHuming+"_"+_dtlNumber);
	var objSkzh = jQuery("#field"+dt3_fieldIdSkzh+"_"+_dtlNumber);

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
//费用报销明细表是否显示在界面上标识
var _fnaSubmitRequestJs_global__oTable0_obj_show_flag=true;
//事前申请流程添加事后报销流程报销明细
function addDetail1Row(fysqlc){
<%if(haveApplicationBudget){%>
	jQuery.ajax({
		url : "/fna/wfPage/getRequestApplicationInfo.jsp",
		type : "post",
		processData : false,
		data : "fysqlc="+fysqlc+"&isNewWf="+isNewWf+"&dt1_fieldIdReqDtId="+dt1_fieldIdReqDtId,
		dataType : "json",
		success: function do4Success(jsonObj){
			_fnaSubmitRequestJs_global_clearSubjectById_flag = false;
			_fnaSubmitRequestJs_global_getFnaInfoData_callBack_flag = false;
			try{
				if(dt1_haveIsDtlField){
					var _oTable0_obj = null;
					if(_fnaSubmitRequestJs_global__oTable0_obj_show_flag){
						_oTable0_obj = jQuery("#oTable0");
						if(_oTable0_obj){_fnaSubmitRequestJs_global__oTable0_obj_show_flag=false;_oTable0_obj.hide();}
					}
					try{
						var addbutton0Obj = jQuery("button[name='addbutton0']");
						var rowArray = jsonObj.rowArray;
						for(var i=0;i<rowArray.length;i++){
							var rowJsonObj = rowArray[i];
						    if(addbutton0Obj.length){addbutton0Obj[0].click();}
							var _xm_array3 = jQuery("input[name='check_node_0']");
							if(_xm_array3.length > 0){
								var _idx = parseInt(jQuery(_xm_array3[_xm_array3.length-1]).val());
								if(!isNaN(_idx) && _idx>=0){
									addDetail1Row_callBack(rowJsonObj, _idx);
							    }
							}
						}
						if(rowArray.length > 0){
							try{window.calSum(0);}catch(ex1){}
							_fnaSubmitRequestJs_global_getFnaInfoData_callBack_flag = true;
							getFnaInfoDataBatch();
						}
					}catch(ex000){}
					if(_oTable0_obj){_oTable0_obj.show();_fnaSubmitRequestJs_global__oTable0_obj_show_flag=true;}
				}else{
					var rowArray = jsonObj.rowArray;
					if(rowArray.length > 0){
						var rowJsonObj = rowArray[0];
						addDetail1Row_callBack(rowJsonObj, "");
						try{window.calSum(0);}catch(ex1){}
						_fnaSubmitRequestJs_global_getFnaInfoData_callBack_flag = true;
						getFnaInfoDataBatch();
					}
				}
			}catch(ex0){}
			_fnaSubmitRequestJs_global_clearSubjectById_flag = true;
			_fnaSubmitRequestJs_global_getFnaInfoData_callBack_flag = true;
		}
	});
<%}%>
}
//事前申请流程添加事后报销流程报销明细回调函数
function addDetail1Row_callBack(rowJsonObj, _idx){
	setWfMainAndDetailFieldValueForPc(rowJsonObj.orgtype, dt1_organizationtype, dt1_organizationtype_isDtl, _idx);
	setWfMainAndDetailFieldValueForPc(rowJsonObj.applydate, dt1_budgetperiod, dt1_budgetperiod_isDtl, _idx);
	setWfMainAndDetailFieldSpanValueForPc(rowJsonObj.applydate, dt1_budgetperiod, dt1_budgetperiod_isDtl, _idx);
	setWfMainAndDetailFieldValueForPc(rowJsonObj.amount, dt1_applyamount, dt1_applyamount_isDtl, _idx);
    
	setWfMainAndDetailFieldValueForPc(rowJsonObj.subject, dt1_subject, dt1_subject_isDtl, _idx);
	setWfMainAndDetailFieldSpanValueForPc(rowJsonObj.subjectname, dt1_subject, dt1_subject_isDtl, _idx);
    
    if(isNewWf){
		setWfMainAndDetailFieldValueForPc(rowJsonObj.fieldIdReqId, dt1_fieldIdReqId, dt1_fieldIdReqId_isDtl, _idx);//请求ID
		setWfMainAndDetailFieldSpanValueForPc(rowJsonObj.fieldIdReqName, dt1_fieldIdReqId, dt1_fieldIdReqId_isDtl, _idx); //请求名称
		setWfMainAndDetailFieldValueForPc(rowJsonObj.fieldIdReqDtId, dt1_fieldIdReqDtId, dt1_fieldIdReqDtId_isDtl, _idx);//明细ID
		setWfMainAndDetailFieldSpanValueForPc(rowJsonObj.fieldIdReqDtName, dt1_fieldIdReqDtId, dt1_fieldIdReqDtId_isDtl, _idx); //明细名称
    }

	onShowOrganizationBtn_fna(_idx+"", rowJsonObj.orgid, rowJsonObj.orgname, true, "1", true);
}
//判断出入的字段id中，是否有报销流程的字段且该字段不是明细表字段
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
						clearSubjectById(_idx);
					}
					getFnaInfoData(_idx);
			    }
			}
		}else{
			if(dt1_organizationid==fieldid){
				clearSubjectById(rowindex);
			}
			getFnaInfoData(rowindex);
		}
	}else if(main_fieldIdSqr==fieldid){
		var _xm_array0 = jQuery("select[name^='field"+dt3_fieldIdSkfs+"_']");
		for(var i0=0;i0<_xm_array0.length;i0++){
			try{
				var _iptName = jQuery(_xm_array0[i0]).attr("name");
				var _iptNameArray = _iptName.split("_");
				if(_iptNameArray.length==2){
					var _idx = parseInt(_iptNameArray[1]);
					if(!isNaN(_idx) && _idx>=0 && jQuery("#field"+dt3_fieldIdSkfs+"_"+_idx).length==1){
						var _skfsJQuery = jQuery("#disfield"+dt3_fieldIdSkfs+"_"+_idx);
						if(_skfsJQuery.length==0){
							_skfsJQuery = jQuery("#field"+dt3_fieldIdSkfs+"_"+_idx);
						}
					    var skfs = _skfsJQuery.val();
						if(skfs=="1" && _skfsJQuery.length==1){
							_fnaBorrowSkfsDtl2_onchange(_skfsJQuery[0]);
						}
				    }
				}
			}catch(e){}
		}
	}else if(fieldid==dt2_fieldIdJklc){
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
	}else if(fieldid==dt4_fieldIdYfklc){
		var _objYfklc = jQuery("#field"+dt4_fieldIdYfklc+"_"+rowindex);
		var _objDnxh = jQuery("#field"+dt4_fieldIdDnxh+"_"+rowindex);
		var _objSpanDnxh = jQuery("#field"+dt4_fieldIdDnxh+"_"+rowindex+"span");
		var jklc = _objYfklc.val();
		_objDnxh.val("");
		var _html = "";
		if(_objDnxh.attr("viewtype")=="1"){
			_html = "<img src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\">";
		}
		_objSpanDnxh.html(_html);
		getAdvanceRequestInfo(rowindex);
	}else if(haveApplicationBudget && main_fieldIdFysqlc==fieldid && main_fieldIdFysqlc_isWfFieldLinkage=="0"){
		var fysqlc = getFysqlc();
		if(fysqlc!=""){
			var check_node_array = jQuery("input[name='check_node_0']");
			if(!dt1_haveIsDtlField || check_node_array.length<=0){
				addDetail1Row(fysqlc);
			}else{
				top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(84642,user.getLanguage())%>",
					function(){
						jQuery(check_node_array).attr("checked","checked");
						var delbutton0Obj = jQuery("button[name='delbutton0']");
					    if(delbutton0Obj.length){delbutton0Obj[0].click();}
						addDetail1Row(fysqlc);
					},function(){
					}
				);
			}
		}
	}
}
//渲染浏览按钮initE8Browser_fna _fieldId=field5881_0;0
function initE8Browser_fna(_fieldId, _insertindex, _ismand, _browserValue, _browserSpanValue, _detailbrowclick, _completeUrl, _fieldId2, _type){
	var _isMustInput = "1";
	if(_ismand==1){
		_isMustInput = "2";
	}
	var _wrapObj = null;
	var _needHidden = false;
	var _viewType = "0";
	if(dt1_organizationid_isDtl=="1"){
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
		isAutoComplete:"true",
		completeUrl:_completeUrl,
		type:_type,
		viewType:_viewType,
		browserValue: _browserValue,
		browserSpanValue: _browserSpanValue,
		browserOnClick: _detailbrowclick,
		hasInput:true,
		isSingle:true,
		hasBrowser:true, 
		isMustInput:_isMustInput,
		width:"95%",
		needHidden:_needHidden,
		onPropertyChange:"wfbrowvaluechange(this, "+_fieldId2+", "+_insertindex+")"
	});
}
//生成费用单位浏览按钮事件
function onShowOrganizationBtn_fna(insertindex, _browserId, _browserName, _notDoClearBtnById, addDetail1Row, _notGetFnaInfoData){
	if(_notDoClearBtnById==null){
		_notDoClearBtnById = false;
	}
	if(_notGetFnaInfoData==null){
		_notGetFnaInfoData = false;
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
		if(jQuery("#field"+dt1_organizationid+"_"+insertindex+"_browserbtn").length==1){
			var detailbrowclick = "onShowBrowser2('"+dt1_organizationid+"_"+insertindex+"','"+browserUtl+"','','"+btnType+"','"+organizationidismand+"')";
		    initE8Browser_fna(""+dt1_organizationid+"_"+insertindex, insertindex, organizationidismand, _browserId, _browserName, detailbrowclick, 
		    	    "/data.jsp?show_virtual_org=-1&type="+btnType+"&bdf_wfid=<%=workflowid%>&bdf_fieldid="+dt1_organizationid, dt1_organizationid, btnType);
		    _orgIdObj = jQuery("#field"+dt1_organizationid+"_"+insertindex);
		    if(_orgIdObj.length==1){
		    	_orgIdObj = _orgIdObj[0];
		    }
		    if(addDetail1Row != "1"){
				setOrganizationidSpan(insertindex);
		    }
			wfbrowvaluechange(_orgIdObj, dt1_organizationid, insertindex);
			if(!_notDoClearBtnById){
				clearSubjectById(insertindex);
			}
		}else{
			/*
			setWfMainAndDetailFieldValueForPc(_browserId, dt1_organizationid, dt1_organizationid_isDtl, insertindex);
			setWfMainAndDetailFieldSpanValueForPc(_browserName, dt1_organizationid, dt1_organizationid_isDtl, insertindex);
			*/
			var _orgFullId = "field"+dt1_organizationid;
			if(dt1_organizationid_isDtl==1){
				_orgFullId += "_"+indexno;
			}
	        _writeBackData(_orgFullId, 2, {id:_browserId,name:_browserName},  {hasInput:true,replace:true,isSingle:true,isedit:true});
	        
		    if(addDetail1Row != "1"){
				setOrganizationidSpan(insertindex);
		    }
			if(!_notDoClearBtnById){
				clearSubjectById(insertindex);
			}
			if(!_notGetFnaInfoData){
				getFnaInfoData(insertindex);
			}
		}
	}else{
		if(jQuery("#field"+dt1_organizationid+"_browserbtn").length==1){
			var detailbrowclick = "onShowBrowser2('"+dt1_organizationid+"','"+browserUtl+"','','"+btnType+"','"+organizationidismand+"')";
		    initE8Browser_fna(""+dt1_organizationid, "null", organizationidismand, _browserId, _browserName, detailbrowclick, 
		    	    "/data.jsp?show_virtual_org=-1&type="+btnType+"&bdf_wfid=<%=workflowid%>&bdf_fieldid="+dt1_organizationid, dt1_organizationid, btnType);
		    _orgIdObj = jQuery("#field"+dt1_organizationid);
		    if(_orgIdObj.length==1){
		    	_orgIdObj = _orgIdObj[0];
		    }
		    if(addDetail1Row != "1"){
				setOrganizationidSpan("");
		    }
			wfbrowvaluechange(_orgIdObj, dt1_organizationid);
			if(!_notDoClearBtnById){
				clearSubjectById("");
			}
		}else{
			/*
			setWfMainAndDetailFieldValueForPc(_browserId, dt1_organizationid, dt1_organizationid_isDtl, "");
			setWfMainAndDetailFieldSpanValueForPc(_browserName, dt1_organizationid, dt1_organizationid_isDtl, "");
			*/
			var _orgFullId = "field"+dt1_organizationid;
			if(dt1_organizationid_isDtl==1){
				_orgFullId += "_"+indexno;
			}
	        _writeBackData(_orgFullId, 2, {id:"",name:""},  {hasInput:true,replace:true,isSingle:true,isedit:true});
	        
		    if(addDetail1Row != "1"){
				setOrganizationidSpan("");
		    }
			if(!_notDoClearBtnById){
				clearSubjectById("");
			}
			if(!_notGetFnaInfoData){
				getFnaInfoData("");
			}
		}
	}
}

function setOrganizationidSpan(indexno){
	if(fieldIdOrgId_automaticTake=="1"){
		var orgtype = getWfMainAndDetailFieldValueForPc(dt1_organizationtype, dt1_organizationtype_isDtl, indexno);
		var _id1 = "";
		var _name1 = "";
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
}

function bindfee(value){
	if(dt1_haveIsDtlField){
	    var indexnum0 = -1;
		var _xm_array3 = jQuery("input[name='check_node_0']");
		if(_xm_array3.length > 0){
			var _idx = parseInt(jQuery(_xm_array3[_xm_array3.length-1]).val());
			if(!isNaN(_idx) && _idx>=0){
				indexnum0 = _idx;
			}
		}
	    if(indexnum0>=0){
	    	var orgid = getWfMainAndDetailFieldValueForPc(dt1_organizationid, dt1_organizationid_isDtl, indexnum0);
	    	if(orgid == ""){
				setOrganizationidSpan(indexnum0);
	    	}
			if(value==1){
				if(dt1_organizationtype_isDtl=="1"){
					jQuery("#field"+dt1_organizationtype+"_"+indexnum0).bind("change",function(){
						var _idx1 = parseInt(jQuery(this).attr("name").replace("field"+dt1_organizationtype+"_",""));
						onShowOrganizationBtn_fna(_idx1+"", "", "");
					});
				}
				if(dt1_budgetperiod_isDtl=="1"){
					jQuery("#field"+dt1_budgetperiod+"_"+indexnum0).bindPropertyChange(function(targetobj){
						var _idx1 = parseInt(jQuery(targetobj).attr("name").replace("field"+dt1_budgetperiod+"_",""));
						getFnaInfoData(_idx1);
					});
				}
				getFnaInfoData(indexnum0);
			}else if(value==2){
				var _xm_array = jQuery("input[name='check_node_0']");
				var _xm_array_length = _xm_array.length;
				for(var i0=0;i0<_xm_array_length;i0++){
					var _idx = parseInt(jQuery(_xm_array[i0]).val());
					if(!isNaN(_idx) && _idx>=0){
						if(dt1_organizationtype_isDtl=="1"){
							jQuery("#field"+dt1_organizationtype+"_"+_idx).bind("change",function(){
								var _idx1 = parseInt(jQuery(this).attr("name").replace("field"+dt1_organizationtype+"_",""));
								onShowOrganizationBtn_fna(_idx1, "", "");
							});
						}
						if(dt1_budgetperiod_isDtl=="1"){
							jQuery("#field"+dt1_budgetperiod+"_"+_idx).bindPropertyChange(function(targetobj){
								var _idx1 = parseInt(jQuery(targetobj).attr("name").replace("field"+dt1_budgetperiod+"_",""));
								getFnaInfoData(_idx1);
							});
						}
						//getFnaInfoData(_idx);
					}
				}
				getFnaInfoDataBatch();
				_onRefresh_fnaBudgetAssistant1_flag = true;
			}
		}else{
			_onRefresh_fnaBudgetAssistant1_flag = true;
		}
	}
	if(value==2){
		if(dt1_organizationtype_isDtl!="1"){
			jQuery("#field"+dt1_organizationtype).bind("change",function(){
				onShowOrganizationBtn_fna("", "", "");
			});
		}
		if(dt1_budgetperiod_isDtl!="1"){
			jQuery("#field"+dt1_budgetperiod).bindPropertyChange(function(targetobj){
				getFnaInfoData("");
			});
		}
		if(dt1_organizationtype_isDtl!="1" || dt1_budgetperiod_isDtl!="1"){
			getFnaInfoData("");
			_onRefresh_fnaBudgetAssistant1_flag = true;
		}
		var orgid = getWfMainAndDetailFieldValueForPc(dt1_organizationid, dt1_organizationid_isDtl, "");
    	if(orgid == ""){
    		setOrganizationidSpan("");
    	}
	}
}

function bindfeeDtl3(value){
    var indexnum0 = -1;
	var _xm_array3 = jQuery("select[name^='field"+dt3_fieldIdSkfs+"_']");
	if(_xm_array3.length > 0){
		var _iptName = jQuery(_xm_array3[_xm_array3.length-1]).attr("name");
		var _iptNameArray = _iptName.split("_");
		if(_iptNameArray.length==2){
			var _idx = parseInt(_iptNameArray[1]);
			if(!isNaN(_idx) && _idx>=0 && jQuery("#field"+dt3_fieldIdSkfs+"_"+_idx).length==1){
				indexnum0 = _idx;
			}
		}
	}
    if(indexnum0>=0){
    	if(value==1){
			var _skfsJQuery = jQuery("#disfield"+dt3_fieldIdSkfs+"_"+indexnum0);
			if(_skfsJQuery.length==0){
				_skfsJQuery = jQuery("#field"+dt3_fieldIdSkfs+"_"+indexnum0);
			}
			if(_skfsJQuery.length==1){
				_fnaBorrowSkfsDtl2_onchange(_skfsJQuery[0]);
			}
		}else if(value==2){
			var _xm_array = jQuery("select[name^='disfield"+dt3_fieldIdSkfs+"_']");
			if(_xm_array.length==0){
				_xm_array = jQuery("select[name^='field"+dt3_fieldIdSkfs+"_']");
			}
			for(var i0=0;i0<_xm_array.length;i0++){
				var _iptName = jQuery(_xm_array[i0]).attr("name");
				var _iptNameArray = _iptName.split("_");
				if(_iptNameArray.length==2){
					var _idx = parseInt(_iptNameArray[1]);
					if(!isNaN(_idx) && _idx>=0){
						var _skfsJQuery = jQuery("#disfield"+dt3_fieldIdSkfs+"_"+_idx);
						if(_skfsJQuery.length==0){
							_skfsJQuery = jQuery("#field"+dt3_fieldIdSkfs+"_"+_idx);
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

//根据人员/部门/分部/成本中心，id获得对应名称（该方法在主表字段通过流程字段联动带出明细时调用）
function getOrgSpanAndInitOrgIdBtn_defalutFieldValue(insertindex){
	var orgtype = getWfMainAndDetailFieldValueForPc(dt1_organizationtype, dt1_organizationtype_isDtl, insertindex);
	var orgid = getWfMainAndDetailFieldValueForPc(dt1_organizationid, dt1_organizationid_isDtl, insertindex);
	getOrgSpanAndInitOrgIdBtn(orgtype,orgid,insertindex,"1");
}

//根据人员/部门/分部/成本中心，id获得对应名称
function getOrgSpanAndInitOrgIdBtn(orgtype,orgid,insertindex,addDetail1Row){
	var orgSpan = "";
	jQuery.ajax({
		url : "/workflow/request/GetOrgNameById.jsp",
		type : "post",
		processData : false,
		data : "orgtype="+orgtype+"&orgid="+orgid,
		dataType : "html",
		success: function do4Success(msg){ 
			var orgSpan = jQuery.trim(msg);
		    onShowOrganizationBtn_fna(insertindex, orgid, orgSpan, true, addDetail1Row);
		}
	});
}
var _fnaSubmitRequestJs_global_getFnaInfoData_callBack_flag = true;
//批量获取预算信息发起ajax请求次数-计数器
var _fnaSubmitRequestJs_global_getFnaInfoDataBatch_ajaxTimes = 0;
//批量获取预算信息ajax请求返回的预算信息json对象全局数组
var _fnaSubmitRequestJs_global_getFnaInfoDataBatch_success_jsonDataArray = [];
//批量获取预算信息ajax请求返回后的回调函数
function call_getFnaInfoData_callBack(){
	var _len = _fnaSubmitRequestJs_global_getFnaInfoDataBatch_success_jsonDataArray.length;
	//判断：计数器   是否   和   批量获取预算信息ajax请求返回的预算信息json对象全局数组   的长度一致，如果一致：则将数组中的预算信息一次性写入页面中
	if(_fnaSubmitRequestJs_global_getFnaInfoDataBatch_ajaxTimes==_len){
		var _oTable0_obj = null;
		if(_fnaSubmitRequestJs_global__oTable0_obj_show_flag){
			_oTable0_obj = jQuery("#oTable0");
			if(_oTable0_obj){_fnaSubmitRequestJs_global__oTable0_obj_show_flag=false;_oTable0_obj.hide();}
		}
		for(var i0=0;i0<_len;i0++){
			try{
				var jsonData = _fnaSubmitRequestJs_global_getFnaInfoDataBatch_success_jsonDataArray[i0];
				var fnaBudgetInfoArray = jsonData.fnaBudgetInfoArray;
				var fnaBudgetInfoArrayLen = fnaBudgetInfoArray.length;
				for(var i=0;i<fnaBudgetInfoArrayLen;i++){
					var __fnaBudgetInfo = fnaBudgetInfoArray[i];
					getFnaInfoData_callBack(jQuery.trim(__fnaBudgetInfo.fnainfos), __fnaBudgetInfo.indexno);
				}
			}catch(ex0){}
		}
		_fnaSubmitRequestJs_global_getFnaInfoDataBatch_ajaxTimes = 0;
		_fnaSubmitRequestJs_global_getFnaInfoDataBatch_success_jsonDataArray = [];
		if(_oTable0_obj){_oTable0_obj.show();_fnaSubmitRequestJs_global__oTable0_obj_show_flag=true;}
	}else{
		//如果上述判断不一致：则100ms后再调用一次本函数。
		setTimeout("call_getFnaInfoData_callBack()",100);
	}
}
//获取所有明细行预算信息
function getFnaInfoDataBatch(){
	if(_fnaSubmitRequestJs_global_getFnaInfoData_callBack_flag){
		_fnaSubmitRequestJs_global_getFnaInfoDataBatch_ajaxTimes = 0;
		_fnaSubmitRequestJs_global_getFnaInfoDataBatch_success_jsonDataArray = [];
		var temprequestid = __requestid;
		var _xm_array = jQuery("input[name='check_node_0']");
		var _xm_array_length = _xm_array.length;
		var _dataHead = "getFnaInfoDataBatch=1&requestid="+temprequestid;
		var _dataBody = "";
		var postCnt = 50;
		var postCntIdx = 1;
		for(var i0=0;i0<_xm_array_length;i0++){
			var _idx = parseInt(jQuery(_xm_array[i0]).val());
			if(!isNaN(_idx) && _idx>=0){
				var budgetfeetype = getWfMainAndDetailFieldValueForPc(dt1_subject, dt1_subject_isDtl, _idx);
				var orgtype = getWfMainAndDetailFieldValueForPc(dt1_organizationtype, dt1_organizationtype_isDtl, _idx);
				var orgid = getWfMainAndDetailFieldValueForPc(dt1_organizationid, dt1_organizationid_isDtl, _idx);
				var applydate = getWfMainAndDetailFieldValueForPc(dt1_budgetperiod, dt1_budgetperiod_isDtl, _idx);
			    
				var dtl_id = "0";
				if(dt1_haveIsDtlField){
					var dtl_id_obj = jQuery("input[name='dtl_id_0_"+_idx+"']");
					if(dtl_id_obj.length){
						dtl_id = dtl_id_obj.val();
					}
				}else{
					dtl_id = "-987654321";
				}

				var _budgetInfoDataKey = _get_budgetInfoDataKey(_idx);
				_fnaSubmitRequestJs_global_getFnaInfoData_posted_hm.put(_budgetInfoDataKey, _idx);
				
	
				_dataBody += "&i0="+i0+"&indexno="+_idx+
					"&budgetfeetype_"+_idx+"="+budgetfeetype+
					"&orgtype_"+_idx+"="+orgtype+
					"&orgid_"+_idx+"="+orgid+
					"&applydate_"+_idx+"="+applydate+
					"&dtl_id_"+_idx+"="+dtl_id;
	
				if(postCnt==postCntIdx || (i0+1)==_xm_array_length){
					var _data = _dataHead+_dataBody;
					_dataBody = "";
					postCntIdx=1;
					//批量获取预算信息发起ajax请求次数-计数器+1
					_fnaSubmitRequestJs_global_getFnaInfoDataBatch_ajaxTimes++;
					jQuery.ajax({
						url : "/workflow/request/FnaBudgetInfoAjax.jsp",
						type : "post",
						processData : false,
						data : _data,
						dataType : "json",
						success: function do4Success(jsonData){
							//批量获取预算信息ajax请求返回后将返回的预算信息json对象，push到全局数组对象中，备用
							_fnaSubmitRequestJs_global_getFnaInfoDataBatch_success_jsonDataArray.push(jsonData);
						}
					});	
				}else{
					postCntIdx++;
				}
			}
		}
		//调用：批量获取预算信息ajax请求返回后的回调函数
		try{call_getFnaInfoData_callBack();}catch(ex0){}
		onRefresh_fnaBudgetAssistant1();
	}
}
//按照_get_budgetInfoDataKey函数返回的key，记录是否发起过ajax请求，hashmap中只缓存明细行序号
var _fnaSubmitRequestJs_global_getFnaInfoData_posted_hm = new _FnaCommonHashMap();
//按照_get_budgetInfoDataKey函数返回的key，缓存预算信息的hashmap对象
var _fnaSubmitRequestJs_global_getFnaInfoData_callBack_hm = new _FnaCommonHashMap();
/*
按照getFnaInfoData发起的获取预算信息的ajax请求的data中的相关信息拼接出唯一key
如果二开中增加过传入参数，此处也需要增加相应参数
*/
function _get_budgetInfoDataKey(indexno){
	var budgetfeetype = getWfMainAndDetailFieldValueForPc(dt1_subject, dt1_subject_isDtl, indexno);
	var orgtype = getWfMainAndDetailFieldValueForPc(dt1_organizationtype, dt1_organizationtype_isDtl, indexno);
	var orgid = getWfMainAndDetailFieldValueForPc(dt1_organizationid, dt1_organizationid_isDtl, indexno);
	var applydate = getWfMainAndDetailFieldValueForPc(dt1_budgetperiod, dt1_budgetperiod_isDtl, indexno);
	var _budgetInfoDataKey = "indexno="+indexno+"&budgetfeetype="+budgetfeetype+"&orgtype="+orgtype+"&orgid="+orgid+"&applydate="+applydate;
	return _budgetInfoDataKey;
}
//获取指定明细行预算信息
function getFnaInfoData(indexno){
	if(_fnaSubmitRequestJs_global_getFnaInfoData_callBack_flag){
		var temprequestid = __requestid;
		
		var budgetfeetype = getWfMainAndDetailFieldValueForPc(dt1_subject, dt1_subject_isDtl, indexno);
		var orgtype = getWfMainAndDetailFieldValueForPc(dt1_organizationtype, dt1_organizationtype_isDtl, indexno);
		var orgid = getWfMainAndDetailFieldValueForPc(dt1_organizationid, dt1_organizationid_isDtl, indexno);
		var applydate = getWfMainAndDetailFieldValueForPc(dt1_budgetperiod, dt1_budgetperiod_isDtl, indexno);
		
		if(fnaRound2(budgetfeetype,0)<=0 || fnaRound2(orgtype,0)<0 || fnaRound2(orgid,0)<=0 || null2String(applydate)==""){
			getFnaInfoData_callBack(" , , | , , , | , , , | , , ||", indexno);
			return;
		}
	    
		var dtl_id = "0";
		if(dt1_haveIsDtlField){
			var dtl_id_obj = jQuery("input[name='dtl_id_0_"+indexno+"']");
			if(dtl_id_obj.length){
				dtl_id = dtl_id_obj.val();
			}
		}else{
			dtl_id = "-987654321";
		}

		onRefresh_fnaBudgetAssistant1();

		var _budgetInfoDataKey = _get_budgetInfoDataKey(indexno);
		var has = _fnaSubmitRequestJs_global_getFnaInfoData_callBack_hm.containsKey(_budgetInfoDataKey);
		if(has){
			var _msgTrim = _fnaSubmitRequestJs_global_getFnaInfoData_callBack_hm.get(_budgetInfoDataKey);
			getFnaInfoData_callBack(_msgTrim, indexno);
		}else{
			var has1 = _fnaSubmitRequestJs_global_getFnaInfoData_posted_hm.containsKey(_budgetInfoDataKey);
			if(!has1){
				_fnaSubmitRequestJs_global_getFnaInfoData_posted_hm.put(_budgetInfoDataKey, indexno);
				jQuery.ajax({
					url : "/workflow/request/FnaBudgetInfoAjax.jsp",
					type : "post",
					processData : false,
					data : "budgetfeetype="+budgetfeetype+"&orgtype="+orgtype+"&orgid="+orgid+"&applydate="+applydate+"&dtl_id="+dtl_id+"&requestid="+temprequestid,
					dataType : "html",
					success: function do4Success(msg){
						var _msgTrim = jQuery.trim(msg);
						getFnaInfoData_callBack(_msgTrim, indexno);
					}
				});
			}
		}
	}
}
function getFnaInfoData_callBack(msg, indexno){
	try{
		var orgtype = getWfMainAndDetailFieldValueForPc(dt1_organizationtype, dt1_organizationtype_isDtl, indexno);
	
		var _msgTrim = jQuery.trim(msg);
	    var fnainfos = _msgTrim.split("|");
	
		var _budgetInfoDataKey = _get_budgetInfoDataKey(indexno);
		_fnaSubmitRequestJs_global_getFnaInfoData_callBack_hm.put(_budgetInfoDataKey, _msgTrim);
		
	
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
	        var dt1_haveIsDtlField_value = (dt1_haveIsDtlField?"1":"0");
	    	setWfMainAndDetailFieldSpanValueForPc(tempmsg, _dt1_remain, dt1_haveIsDtlField_value, indexno);
		}
	}catch(exSplit01){}
}

//jQuery(document).ready(function(){
	//第二次进行《预算校验》
	function _fnaifoverJson_doSubmit2(obj, _data){
		jQuery.ajax({
			url : "/fna/budget/FnaifoverJsonAjax.jsp",
			type : "post",
			processData : false,
			data : _data,
			dataType : "json",
			success: function do4Success(fnainfo){
				var fnainfo_repayment_falg = false;
				
				var fnainfo_repayment = fnainfo.repayment;
				if(fnainfo_repayment.flag){
					fnainfo_repayment_falg = true;
					return _fnaifoverJson_doSubmit3(fnainfo_repayment_falg, fnainfo, obj);
				}else{
					var errorType = fnainfo_repayment.errorType;
					var errorInfo = fnainfo_repayment.errorInfo;
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
								fnainfo_repayment_falg = true;
								return _fnaifoverJson_doSubmit3(fnainfo_repayment_falg, fnainfo, obj);
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
	}
	
	function _fnaifoverJson_doSubmit3(fnainfo_repayment_falg, fnainfo, obj){
		if(fnainfo_repayment_falg){
			var fnainfo_fna = fnainfo.fna;
			if(fnainfo_fna.flag){
				return _fnaifoverJson_doSubmit4(true, fnainfo, obj);
			}else{
				var errorType = fnainfo_fna.errorType;
				var errorInfo = fnainfo_fna.errorInfo;
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
							return _fnaifoverJson_doSubmit4(true, fnainfo, obj);
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
	}
	
	function _fnaifoverJson_doSubmit4(fnainfo_repayment_falg, fnainfo, obj){
		if(fnainfo_repayment_falg){
			var fnainfo_fnaAdvance = fnainfo.fnaAdvance;
			if(fnainfo_fnaAdvance.flag){
				displayAllmenu();
				return doSubmitE8(obj);
			}else{
				var errorType = fnainfo_fnaAdvance.errorType;
				var errorInfo = fnainfo_fnaAdvance.errorInfo;
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
	}

	function getPoststr(){
		var poststr = "";
		if(dt1_haveIsDtlField){
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
						
						var _reqId = getWfMainAndDetailFieldValueForPc(dt1_fieldIdReqId, dt1_fieldIdReqId_isDtl, _idx);
						var _reqDtId = getWfMainAndDetailFieldValueForPc(dt1_fieldIdReqDtId, dt1_fieldIdReqDtId_isDtl, _idx);
						
						if(budgetfeetype==""){budgetfeetype="0";}
						if(orgtype==""){orgtype="-1";}
						if(applyamount==""){applyamount="0";}
					    
						var dtl_id = "0";
						var dtl_id_obj = jQuery("input[name='dtl_id_0_"+_idx+"']");
						if(dtl_id_obj.length){
							dtl_id = dtl_id_obj.val();
						}
						
					    //if(budgetfeetype!="" && orgtype!="" && orgid!="" && applydate!="" && applyamount!=""){
						    if(poststr!=""){
						    	poststr += "|";
						    }
					    	poststr += budgetfeetype+","+ orgtype+","+ orgid+","+ applydate+","+applyamount+","+dtl_id+","+_reqId+","+_reqDtId+",postStrEnd";
					    //}
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
		    
			var dtl_id = "-987654321";
			
		    //if(budgetfeetype!="" && orgtype!="" && orgid!="" && applydate!="" && applyamount!=""){
			    if(poststr!=""){
			    	poststr += "|";
			    }
		    	poststr += budgetfeetype+","+ orgtype+","+ orgid+","+ applydate+","+applyamount+","+dtl_id+",0,0,postStrEnd";
		    //}
		}
		return poststr;
	}
	
	fnaifoverJson_doSubmit = function(obj){
		try{
			enableAllmenu();
			var temprequestid = __requestid;
			var poststr = getPoststr();
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
						    	poststr3 += "|";
						    }
						    poststr3 += skje+",postStrEnd";
					    }
					}
				}catch(e){}
			}
			var poststr4 = "";
			var _xm_array4 = jQuery("input[name^='field"+dt4_fieldIdCxje+"_']");
			for(var i0=0;i0<_xm_array4.length;i0++){
				try{
					var _iptName = jQuery(_xm_array4[i0]).attr("name");
					var _iptNameArray = _iptName.split("_");
					if(_iptNameArray.length==2){
						var _idx = parseInt(_iptNameArray[1]);
						if(!isNaN(_idx) && _idx>=0 && jQuery("#field"+dt4_fieldIdCxje+"_"+_idx).length==1){
						    var cxje = fnaRound2(jQuery("#field"+dt4_fieldIdCxje+"_"+_idx).val(), 2);
						    var yfklc = jQuery("#field"+dt4_fieldIdYfklc+"_"+_idx).val();
						    var dnxh = jQuery("#field"+dt4_fieldIdDnxh+"_"+_idx).val();
						    if(poststr4!=""){
						    	poststr4 += "|";
						    }
						    poststr4 += cxje+","+yfklc+","+dnxh+",postStrEnd";
					    }
					}
				}catch(e){}
			}
			if(poststr!=""||poststr2!=""||poststr3!=""||poststr4!=""){
			}else{
				displayAllmenu();
				return doSubmitE8(obj);
			}
			
			
			var fysqlc = getFysqlc();
			var yfkZfHj = fnaRound2(jQuery("#field"+main_fieldIdYfkZfHj).val(), 2);

			var _data = "poststr="+poststr+"&poststr2="+poststr2+"&poststr3="+poststr3+"&poststr4="+poststr4+"&requestid="+temprequestid+"&workflowid="+__workflowid+"&fysqlc="+fysqlc+"&yfkZfHj="+yfkZfHj;
			
			//第一次进行《预申请预算校验》
			jQuery.ajax({
				url : "/fna/budget/FnaifoverJsonAjax.jsp",
				type : "post",
				processData : false,
				data : _data+"&doValidateApplication=true",
				dataType : "json",
				success: function do4Success(fnainfo){
					if(fnainfo.flag){
						return _fnaifoverJson_doSubmit2(obj, _data);
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
									return _fnaifoverJson_doSubmit2(obj, _data);
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

function getFysqlc(){
	return null2String(jQuery("#field"+main_fieldIdFysqlc).val());
}

var _fnaSubmitRequestJs_global_clearSubjectById_flag = true;
function clearSubjectById(rowId){
<%if(subjectFilter){ %>
	if(_fnaSubmitRequestJs_global_clearSubjectById_flag){
		var budgetfeetype = getWfMainAndDetailFieldValueForPc(dt1_subject, dt1_subject_isDtl, rowId);
		var orgtype = getWfMainAndDetailFieldValueForPc(dt1_organizationtype, dt1_organizationtype_isDtl, rowId);
		var orgid = getWfMainAndDetailFieldValueForPc(dt1_organizationid, dt1_organizationid_isDtl, rowId);
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
							clearBtnById(dt1_subject,rowId);
							getFnaInfoData(rowId);
						}
					}else{
						top.Dialog.alert(fnainfo.errorInfo);
					}
				}
			});
		}
	}
<%}%>
}

function clearBtnById(fieldId,rowId){
<%if(subjectFilter){ %>
	if(fieldId!=null&&fieldId!=""){
		var isDtl = "1";
		for(var i=0;i<dt1_fieldId_array.length;i++){
			if(dt1_fieldId_array[i]==fieldId){
				isDtl = dt1_fieldId_isDtl_array[i];
				break;
			}
		}
		setWfMainAndDetailFieldValueForPc("", fieldId, isDtl, rowId);
		setWfMainAndDetailFieldSpanValueForPc("", fieldId, isDtl, rowId);
	}
<%}%>
}

jQuery(document).ready(function(){
	if(dt1_haveIsDtlField){
		jQuery("button[name='delbutton0']").bind("click",function(){
			onRefresh_fnaBudgetAssistant1();
			try{window.calSum(0);}catch(ex1){}
		});
		jQuery("button[name='addbutton0']").bind("click",function(){
			bindfee(1);
		});
	}
	bindfee(2);

<%if(enableRepayment){%>
	jQuery("button[name='delbutton1']").bind("click",function(){
		try{window.calSum(1);}catch(ex1){}
	});
	jQuery("button[name='delbutton2']").bind("click",function(){
		try{window.calSum(2);}catch(ex1){}
	});

	jQuery("button[name='addbutton2']").bind("click",function(){
		bindfeeDtl3(1);
	});
	bindfeeDtl3(2);
<%}%>
	onRefresh_fnaBudgetAssistant1();
});

var _poststr_fnaBudgetAssistant1 = "";
var _fysqlc_fnaBudgetAssistant1 = "";
function onRefresh_fnaBudgetAssistant1(){
	if(_onRefresh_fnaBudgetAssistant1_flag&&_Fna_content_view_id_array!=null&&_Fna_content_view_id_array.length>0&&window.parent&&window.parent.jQuery){
		var _synergy_framecontent = window.parent.jQuery("#synergy_framecontent");
		if(_synergy_framecontent.length==1){
			var _contentWindow = _synergy_framecontent[0].contentWindow;
			if(_contentWindow!=null){
				for(var i=0;i<_Fna_content_view_id_array.length;i++){
					var _Fna_content_view_id = _Fna_content_view_id_array[i]+"";
					if(_contentWindow.jQuery("#content_view_id_"+_Fna_content_view_id).length==1){
						var _poststr_fnaBudgetAssistant1_tmp = getPoststr();
						var _fysqlc_fnaBudgetAssistant1_tmp = getFysqlc();
						if(_poststr_fnaBudgetAssistant1_tmp!=_poststr_fnaBudgetAssistant1 || _fysqlc_fnaBudgetAssistant1_tmp!=_fysqlc_fnaBudgetAssistant1){
							_poststr_fnaBudgetAssistant1 = getPoststr();
							_fysqlc_fnaBudgetAssistant1 = getFysqlc();
							_contentWindow.onRefresh(_Fna_content_view_id,'fnaBudgetAssistant1');
						}
					}
				}
			}
		}
	}
}


//获取借款信息
function getAdvanceRequestInfo(rowindex){
	var _objYfklc = jQuery("#field"+dt4_fieldIdYfklc+"_"+rowindex);
	var _objDnxh = jQuery("#field"+dt4_fieldIdDnxh+"_"+rowindex);
	var _objYfkdh = jQuery("#field"+dt4_fieldIdYfkdh+"_"+rowindex);
	var _objYfkje = jQuery("#field"+dt4_fieldIdYfkje+"_"+rowindex);
	var _objYhje = jQuery("#field"+dt4_fieldIdYhje+"_"+rowindex);
	var _objSpzje = jQuery("#field"+dt4_fieldIdSpzje+"_"+rowindex);
	var _objWhje = jQuery("#field"+dt4_fieldIdWhje+"_"+rowindex);
	
	_objYfkdh.val("");
	_objYfkje.val("");
	_objYhje.val("");
	_objSpzje.val("");
	_objWhje.val("");
	
	
	var Yfklc = _objYfklc.val();
	var dnxh = _objDnxh.val();
	
	jQuery.ajax({
		url : "/fna/wfPage/getAdvanceRequestInfo.jsp",
		type : "post",
		processData : false,
		data : "_____guid1="+_____guid1+"&Yfklc="+Yfklc+"&dnxh="+dnxh+"&requestid="+__requestid,
		dataType : "json",
		success: function do4Success(fnainfo){
			if(fnainfo.flag){
				setWfMainAndDetailFieldValueForPc(fnainfo.requestmark, dt4_fieldIdYfkdh, "1", rowindex);
				setWfMainAndDetailFieldValueForPc(fnainfo.Yfkje, dt4_fieldIdYfkje, "1", rowindex);
				setWfMainAndDetailFieldValueForPc(fnainfo.yhje, dt4_fieldIdYhje, "1", rowindex);
				setWfMainAndDetailFieldValueForPc(fnainfo.spzje, dt4_fieldIdSpzje, "1", rowindex);
				setWfMainAndDetailFieldValueForPc(fnainfo.whje, dt4_fieldIdWhje, "1", rowindex);
				try{window.calSum(3);}catch(ex1){}
			}else{
				top.Dialog.alert(fnainfo.errorInfo);
			}
		}
	});
}
//设置单内序号回调函数
function setAdvanceDnxhValue(_jsonObj){
	var _objDnxh = jQuery("#field"+dt4_fieldIdDnxh+"_"+_jsonObj._dtlNumber);
	var _objSpanDnxh = jQuery("#field"+dt4_fieldIdDnxh+"_"+_jsonObj._dtlNumber+"span");

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
	
	getAdvanceRequestInfo(_jsonObj._dtlNumber);
}
//显示借款信息浏览框
function onShowBrowser_fnaAdvanceRequestDtl(_obj){
	var objId = _obj.id;
	var _fieldId = objId.split("_")[0];
	var _dtlNumber = objId.split("_")[1];

	var _objYfklc = jQuery("#field"+dt4_fieldIdYfklc+"_"+_dtlNumber);
	var Yfklc = _objYfklc.val();

	var _w = 600;
	var _h = 360;
	_fnaOpenDialog("/fna/wfPage/dialogAdvanceRequestDtlRowInfo.jsp?workflowid="+__workflowid+
			"&requestid="+__requestid+ 
			"&_dtlNumber="+_dtlNumber+
			"&Yfklc="+Yfklc, 
			"<%=SystemEnv.getHtmlLabelNames("18214",user.getLanguage()) %>", 
			_w, _h);
}
</script>