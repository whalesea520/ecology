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

var dt1_subject2 = "<%=fieldIdSubject2 %>";
var dt1_organizationtype2 = "<%=fieldIdOrgType2 %>";
var dt1_organizationid2 = "<%=fieldIdOrgId2 %>";
var dt1_budgetperiod2 = "<%=fieldIdOccurdate2 %>";
var dt1_hrmremain2 = "<%=fieldIdHrmInfo2 %>";
var dt1_deptremain2 = "<%=fieldIdDepInfo2 %>";
var dt1_subcomremain2 = "<%=fieldIdSubInfo2 %>";
var dt1_fccremain2 = "<%=fieldIdFccInfo2 %>";
		
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


//browser回调方法
function wfbrowvaluechange_fna(obj, fieldid, rowindex) {
	if(dt1_subject==fieldid || dt1_organizationtype==fieldid || dt1_organizationid==fieldid || dt1_budgetperiod==fieldid
			|| dt1_subject2==fieldid || dt1_organizationtype2==fieldid || dt1_organizationid2==fieldid || dt1_budgetperiod2==fieldid){
		if(dt1_organizationid==fieldid){
			clearSubjectById(dt1_subject,rowindex,"");
		}
		if(dt1_organizationid2==fieldid){
			clearSubjectById(dt1_subject2,rowindex,"2");
		}
		if(dt1_subject==fieldid || dt1_organizationtype==fieldid || dt1_organizationid==fieldid || dt1_budgetperiod==fieldid 
				|| dt1_subject2==fieldid || dt1_organizationtype2==fieldid || dt1_organizationid2==fieldid || dt1_budgetperiod2==fieldid){
			getFnaInfoData(rowindex, "");
			getFnaInfoData(rowindex, "2");
		}
	}
}
//渲染浏览按钮initE8Browser_fna _fieldId=field5881_0;0
function initE8Browser_fna(_fieldId, _insertindex, _ismand, _browserValue, _browserSpanValue, _detailbrowclick, _completeUrl, _fieldId2){
	jQuery("#field"+_fieldId+"wrapspan").html("");
	var _isMustInput = "1";
	if(_ismand==1){
		_isMustInput = "2";
	}
	jQuery("#field"+_fieldId+"wrapspan").e8Browser({
	   name:"field"+_fieldId,
	   viewType:"1",
	   browserValue: _browserValue,
	   browserSpanValue: _browserSpanValue,
	   browserOnClick: _detailbrowclick,
	   hasInput:true,
	   isSingle:true,
	   hasBrowser:true, 
	   isMustInput:_isMustInput,
	   completeUrl:_completeUrl,
	   width:"95%",
	   needHidden:false,
	   onPropertyChange:"wfbrowvaluechange(this, "+_fieldId2+", "+_insertindex+")"
	});
}
//生成费用单位浏览按钮事件
function onShowOrganizationBtn_fna(insertindex, _browserId, _browserName, _notDoClearBtnById, _type0){
	if(_notDoClearBtnById==null){
		_notDoClearBtnById = false;
	}
	if(!_notDoClearBtnById){
		if(_type0==""){
			clearSubjectById(dt1_subject, insertindex,"");
		}else if(_type0=="2"){
			clearSubjectById(dt1_subject2, insertindex,"2");
		}
	}
	var _orgIdWrapspan = jQuery("#field"+dt1_organizationid+"_"+insertindex+"wrapspan");
	if(_type0=="2"){
		_orgIdWrapspan = jQuery("#field"+dt1_organizationid2+"_"+insertindex+"wrapspan");
	}
	if(_orgIdWrapspan.length==1){
		var _orgIdObj = "";
		if(_type0==""){
			_orgIdObj = jQuery("#field"+dt1_organizationid+"_"+insertindex);
		}else if(_type0=="2"){
			_orgIdObj = jQuery("#field"+dt1_organizationid2+"_"+insertindex);
		}
		_orgIdObj.val("");
		_orgIdWrapspan.html("");
	    var organizationidismand = _orgIdObj.attr("viewtype");
	    
		var orgType = "";
		if(_type0==""){
			if(jQuery("#field"+dt1_organizationtype+"_"+insertindex).length){
				orgType = jQuery("#field"+dt1_organizationtype+"_"+insertindex).val();
			}else if(jQuery("#disfield"+dt1_organizationtype+"_"+insertindex).length){
				orgType = jQuery("#disfield"+dt1_organizationtype+"_"+insertindex).val();
			}else{
				orgType = jQuery("input[name='field"+dt1_organizationtype+"_"+insertindex+"']").val();
			};
		}else if(_type0=="2"){
			if(jQuery("#field"+dt1_organizationtype2+"_"+insertindex).length){
				orgType = jQuery("#field"+dt1_organizationtype2+"_"+insertindex).val();
			}else if(jQuery("#disfield"+dt1_organizationtype2+"_"+insertindex).length){
				orgType = jQuery("#disfield"+dt1_organizationtype2+"_"+insertindex).val();
			}else{
				orgType = jQuery("input[name='field"+dt1_organizationtype2+"_"+insertindex+"']").val();
			};
		}

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

		if(_type0==""){
		    var detailbrowclick = "onShowBrowser2('"+dt1_organizationid+"_"+insertindex+"','"+browserUtl+"','','"+btnType+"','"+organizationidismand+"')";
		    initE8Browser_fna(""+dt1_organizationid+"_"+insertindex, insertindex, organizationidismand, _browserId, _browserName, detailbrowclick, "/data.jsp?show_virtual_org=-1&type="+btnType, dt1_organizationid);

		    var _orgIdObj = jQuery("#field"+dt1_organizationid+"_"+insertindex);
		    if(_orgIdObj.length==1){
		    	_orgIdObj = _orgIdObj[0];
		    }
			setOrganizationidSpan(insertindex,"1");
			wfbrowvaluechange(_orgIdObj, dt1_organizationid, insertindex);
			
		}else if(_type0=="2"){
		    var detailbrowclick = "onShowBrowser2('"+dt1_organizationid2+"_"+insertindex+"','"+browserUtl+"','','"+btnType+"','"+organizationidismand+"')";
		    initE8Browser_fna(""+dt1_organizationid2+"_"+insertindex, insertindex, organizationidismand, _browserId, _browserName, detailbrowclick, "/data.jsp?show_virtual_org=-1&type="+btnType, dt1_organizationid2);

		    var _orgIdObj = jQuery("#field"+dt1_organizationid2+"_"+insertindex);
		    if(_orgIdObj.length==1){
		    	_orgIdObj = _orgIdObj[0];
		    }
			setOrganizationidSpan(insertindex,"2");
			wfbrowvaluechange(_orgIdObj, dt1_organizationid2, insertindex);
		}
	    
		
	}else{
		if(_type0==""){
			jQuery("#field"+dt1_organizationid+"_"+insertindex+"span").html(_browserName);
		}else if(_type0=="2"){
			jQuery("#field"+dt1_organizationid2+"_"+insertindex+"span").html(_browserName);
		}
	}
}

function setOrganizationidSpan(indexno,type){
	var orgtype1 = getWfMainAndDetailFieldValueForPc(dt1_organizationtype, "1", indexno);
	var orgtype2 = getWfMainAndDetailFieldValueForPc(dt1_organizationtype2, "1", indexno);
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
			setWfMainAndDetailFieldValueForPc(_id1, dt1_organizationid, "1", indexno);
			setWfMainAndDetailFieldSpanValueForPc(_name1, dt1_organizationid, "1", indexno);
			*/
			var _orgFullId = "field"+dt1_organizationid+"_"+indexno;
	        _writeBackData(_orgFullId, 2, {id:_id1,name:_name1},  {hasInput:true,replace:true,isSingle:true,isedit:true});
		}
	}else{
		if(fieldIdOrgId2_automaticTake=="1"){
			/*
			setWfMainAndDetailFieldValueForPc(_id2, dt1_organizationid2, "1", indexno);
			setWfMainAndDetailFieldSpanValueForPc(_name2, dt1_organizationid2, "1", indexno);
			*/
			var _orgFullId = "field"+dt1_organizationid2+"_"+indexno;
	        _writeBackData(_orgFullId, 2, {id:_id2,name:_name2},  {hasInput:true,replace:true,isSingle:true,isedit:true});
		}
	}
}

function bindfee(value){
    var indexnum0 = -1;
	var _xm_array3 = jQuery("input[name^='field"+dt1_subject+"_']");
	if(_xm_array3.length > 0){
		var _iptName = jQuery(_xm_array3[_xm_array3.length-1]).attr("name");
		var _iptNameArray = _iptName.split("_");
		if(_iptNameArray.length==2){
			var _idx = parseInt(_iptNameArray[1]);
			if(!isNaN(_idx) && _idx>=0 && jQuery("#field"+dt1_subject+"_"+_idx).length==1){
				indexnum0 = _idx;
			}
		}
	}
    if(indexnum0>=0){
    	var orgid1 = getWfMainAndDetailFieldValueForPc(dt1_organizationid, "1", indexnum0);
    	var orgid2 = getWfMainAndDetailFieldValueForPc(dt1_organizationid2, "1", indexnum0);
    	if(orgid1 == ""){
	    	setOrganizationidSpan(indexnum0,"1");
    	}
    	if(orgid2 == ""){
    		setOrganizationidSpan(indexnum0,"2");
    	}
    	
		if(value==1){
			jQuery("#field"+dt1_organizationtype+"_"+indexnum0).bind("change",function(){
				var _idx1 = parseInt(jQuery(this).attr("name").replace("field"+dt1_organizationtype+"_",""));
		    	onShowOrganizationBtn_fna(_idx1+"", "", "", null, "");
			});
			jQuery("#field"+dt1_budgetperiod+"_"+indexnum0).bindPropertyChange(function(targetobj){
				var _idx1 = parseInt(jQuery(targetobj).attr("name").replace("field"+dt1_budgetperiod+"_",""));
				getFnaInfoData(_idx1, "");
			});
			
			if(dt1_organizationtype != dt1_organizationtype2){
				jQuery("#field"+dt1_organizationtype2+"_"+indexnum0).bind("change",function(){
					var _idx1 = parseInt(jQuery(this).attr("name").replace("field"+dt1_organizationtype2+"_",""));
			    	onShowOrganizationBtn_fna(_idx1+"", "", "", null, "2");
				});
			}
			if(dt1_budgetperiod != dt1_budgetperiod2){
				jQuery("#field"+dt1_budgetperiod2+"_"+indexnum0).bindPropertyChange(function(targetobj){
					var _idx1 = parseInt(jQuery(targetobj).attr("name").replace("field"+dt1_budgetperiod2+"_",""));
					getFnaInfoData(_idx1, "2");
				});
			}
		    
			getFnaInfoData(indexnum0, "");
			getFnaInfoData(indexnum0, "2");
		}else if(value==2){
			var _xm_array = jQuery("input[name^='field"+dt1_subject+"_']");
			for(var i0=0;i0<_xm_array.length;i0++){
				var _iptName = jQuery(_xm_array[i0]).attr("name");
				var _iptNameArray = _iptName.split("_");
				if(_iptNameArray.length==2){
					var _idx = parseInt(_iptNameArray[1]);
					if(!isNaN(_idx) && _idx>=0){
					    jQuery("#field"+dt1_organizationtype+"_"+_idx).bind("change",function(){
							var _idx1 = parseInt(jQuery(this).attr("name").replace("field"+dt1_organizationtype+"_",""));
					    	onShowOrganizationBtn_fna(_idx1, "", "", null, "");
						});
						jQuery("#field"+dt1_budgetperiod+"_"+_idx).bindPropertyChange(function(targetobj){
							var _idx1 = parseInt(jQuery(targetobj).attr("name").replace("field"+dt1_budgetperiod+"_",""));
							getFnaInfoData(_idx1, "");
						});
					    
						if(dt1_organizationtype != dt1_organizationtype2){
						    jQuery("#field"+dt1_organizationtype2+"_"+_idx).bind("change",function(){
								var _idx1 = parseInt(jQuery(this).attr("name").replace("field"+dt1_organizationtype2+"_",""));
						    	onShowOrganizationBtn_fna(_idx1, "", "", null, "2");
							});
						}
						if(dt1_budgetperiod != dt1_budgetperiod2){
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
}
 
function getFnaInfoData(indexno, _type0){
	var budgetfeetype = jQuery("#field"+dt1_subject+"_"+indexno).val();
	var orgtype = "";
	if(jQuery("#field"+dt1_organizationtype+"_"+indexno).length){
		orgtype = jQuery("#field"+dt1_organizationtype+"_"+indexno).val();
	}else if(jQuery("#disfield"+dt1_organizationtype+"_"+indexno).length){
		orgtype = jQuery("#disfield"+dt1_organizationtype+"_"+indexno).val();
	}else{
		orgtype = jQuery("input[name='field"+dt1_organizationtype+"_"+indexno+"']").val();
	};
	var orgid = jQuery("#field"+dt1_organizationid+"_"+indexno).val();
	var applydate = jQuery("#field"+dt1_budgetperiod+"_"+indexno).val();

	if(_type0=="2"){
		budgetfeetype = jQuery("#field"+dt1_subject2+"_"+indexno).val();
		orgtype = "";
		if(jQuery("#field"+dt1_organizationtype2+"_"+indexno).length){
			orgtype = jQuery("#field"+dt1_organizationtype2+"_"+indexno).val();
		}else if(jQuery("#disfield"+dt1_organizationtype2+"_"+indexno).length){
			orgtype = jQuery("#disfield"+dt1_organizationtype2+"_"+indexno).val();
		}else{
			orgtype = jQuery("input[name='field"+dt1_organizationtype2+"_"+indexno+"']").val();
		};
		orgid = jQuery("#field"+dt1_organizationid2+"_"+indexno).val();
		applydate = jQuery("#field"+dt1_budgetperiod2+"_"+indexno).val();
	}
	
	var _data = "budgetfeetype="+budgetfeetype+"&orgtype="+orgtype+"&orgid="+orgid+"&applydate="+applydate;
    
	jQuery.ajax({
		url : "/workflow/request/FnaBudgetInfoAjax.jsp",
		type : "post",
		processData : false,
		data : _data,
		dataType : "html",
		success: function do4Success(msg){
	    	try{
		        var fnainfos = jQuery.trim(msg).split("|");
	
		        var _dt1_remain_array = [];
		    	if(_type0==""){
			        _dt1_remain_array = [dt1_hrmremain, dt1_deptremain, dt1_subcomremain, dt1_fccremain];
		    	}else if(_type0=="2"){
			        _dt1_remain_array = [dt1_hrmremain2, dt1_deptremain2, dt1_subcomremain2, dt1_fccremain2];
		    	}
	        	var _cnt = getFnaNotEmptyCount(_dt1_remain_array);
	        	if(_cnt==1){
	        		var _dt1_remain_only = getFnaOnlyNotEmptyValue(_dt1_remain_array);
	        		_dt1_remain_array = [_dt1_remain_only];
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
		        	jQuery("#field"+_dt1_remain+"_"+indexno+"span").html(tempmsg);
				}
	    	}catch(exSplit01){}
		}
	});	
}

//jQuery(document).ready(function(){
	fnaifoverJson_doSubmit = function(obj){
		try{
			enableAllmenu();
			var temprequestid = __requestid;
			var poststr = "";
			var _xm_array = jQuery("input[name^='field"+dt1_subject+"_']");
			for(var i0=0;i0<_xm_array.length;i0++){
				try{
					var _iptName = jQuery(_xm_array[i0]).attr("name");
					var _iptNameArray = _iptName.split("_");
					if(_iptNameArray.length==2){
						var _idx = parseInt(_iptNameArray[1]);
						if(!isNaN(_idx) && _idx>=0 && jQuery("#field"+dt1_subject+"_"+_idx).length==1){
						    var budgetfeetype = jQuery("#field"+dt1_subject+"_"+_idx).val();
						    var orgtype = "";
							if(jQuery("#field"+dt1_organizationtype+"_"+_idx).length){
								orgtype = jQuery("#field"+dt1_organizationtype+"_"+_idx).val();
							}else if(jQuery("#disfield"+dt1_organizationtype+"_"+_idx).length){
								orgtype = jQuery("#disfield"+dt1_organizationtype+"_"+_idx).val();
							}else{
								orgtype = jQuery("input[name='field"+dt1_organizationtype+"_"+_idx+"']").val();
							};
						    var orgid = jQuery("#field"+dt1_organizationid+"_"+_idx).val();
						    var applydate = jQuery("#field"+dt1_budgetperiod+"_"+_idx).val();
						    var applyamount = jQuery("#field"+dt1_applyamount+"_"+_idx).val();

						    var budgetfeetype2 = jQuery("#field"+dt1_subject2+"_"+_idx).val();
						    var orgtype2 = "";
							if(jQuery("#field"+dt1_organizationtype2+"_"+_idx).length){
								orgtype2 = jQuery("#field"+dt1_organizationtype2+"_"+_idx).val();
							}else if(jQuery("#disfield"+dt1_organizationtype2+"_"+_idx).length){
								orgtype2 = jQuery("#disfield"+dt1_organizationtype2+"_"+_idx).val();
							}else{
								orgtype2 = jQuery("input[name='field"+dt1_organizationtype2+"_"+_idx+"']").val();
							};
						    var orgid2 = jQuery("#field"+dt1_organizationid2+"_"+_idx).val();
						    var applydate2 = jQuery("#field"+dt1_budgetperiod2+"_"+_idx).val();

						    
						    if(poststr!=""){
						    	poststr += "|";
						    }
					    	poststr += budgetfeetype+","+orgtype+","+orgid+","+applydate+","+applyamount+","+
					    		budgetfeetype2+","+orgtype2+","+orgid2+","+applydate2+",postStrEnd";
					    }
					}
				}catch(e){}
			}
			
			if(poststr!=""){
			}else{
				displayAllmenu();
				return doSubmitE8(obj);
			}
			
			
			var _data = "poststr="+poststr+"&requestid="+temprequestid+"&workflowid="+__workflowid;
			
			jQuery.ajax({
				url : "/fna/budget/FnaShareifoverJsonAjax.jsp",
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

function clearSubjectById(fieldId,rowId,_type0){
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
<%} %>
}

function clearBtnById(fieldId,rowId){
	<%if(subjectFilter){ %>
		var _objIdWrapspan = jQuery("#field"+fieldId+"_"+rowId+"wrapspan");
		if(_objIdWrapspan.length==1){
			var _objId = jQuery("#field"+fieldId+"_"+rowId);
			var _objSpan = jQuery("#field"+fieldId+"_"+rowId+"span");
			_objId.val("");
			_objSpan.html("");
		}else{
			jQuery("#field"+fieldId+"_"+rowId+"span").html("");
		}
	<%} %>
}

jQuery(document).ready(function(){
	jQuery("button[name='addbutton0']").bind("click",function(){
		bindfee(1); 
    });
    bindfee(2);

});
</script>