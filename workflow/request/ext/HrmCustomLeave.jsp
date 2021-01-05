<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="weaver.general.Util,weaver.hrm.common.*,weaver.conn.*,weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.attendance.domain.*,weaver.hrm.User"%>
<%@ page import="weaver.hrm.schedule.HrmAnnualManagement"%>
<%@ page import="weaver.hrm.schedule.HrmPaidSickManagement"%>
<%@page import="weaver.hrm.attendance.manager.WorkflowBaseManager"%>
<!-- Added by wcd 2015-06-25[自定义请假单] -->
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<jsp:useBean id="dateUtil" class="weaver.common.DateUtil" scope="page" />
<jsp:useBean id="attProcSetManager" class="weaver.hrm.attendance.manager.HrmAttProcSetManager" scope="page" />
<jsp:useBean id="attVacationManager" class="weaver.hrm.attendance.manager.HrmAttVacationManager" scope="page" />
<jsp:useBean id="paidLeaveTimeManager" class="weaver.hrm.attendance.manager.HrmPaidLeaveTimeManager" scope="page" />
<jsp:useBean id="colorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<%
	User user = (User)request.getSession(true).getAttribute("weaver_user@bean");
	int nodetype = strUtil.parseToInt(request.getParameter("nodetype"), 0);
	int workflowid = strUtil.parseToInt(request.getParameter("workflowid"), 0);
	int formid = strUtil.parseToInt(request.getParameter("formid"));
	int userid = strUtil.parseToInt(request.getParameter("userid"));
	String creater = strUtil.vString(request.getParameter("creater"), String.valueOf(userid));
	WorkflowBaseManager workflowBaseManager = new WorkflowBaseManager();
	if(formid == -1) {
		WorkflowBase bean = workflowBaseManager.get(workflowid);
		formid = bean == null ? -1 : bean.getFormid();
	}
	String[] fieldList = attProcSetManager.getFieldList(workflowid, formid);
	if(fieldList == null || fieldList.length == 0 || strUtil.isNull(fieldList[0])) return;
	String currentdate = strUtil.vString(request.getParameter("currentdate"), dateUtil.getCurrentDate());
	String f_weaver_belongto_userid = strUtil.vString(request.getParameter("f_weaver_belongto_userid"));
	String f_weaver_belongto_usertype = strUtil.vString(request.getParameter("f_weaver_belongto_usertype"));
	String userannualinfo = HrmAnnualManagement.getUserAannualInfo(creater,currentdate);
	String thisyearannual = Util.TokenizerString2(userannualinfo,"#")[0];
	String lastyearannual = Util.TokenizerString2(userannualinfo,"#")[1];
	String allannual = Util.TokenizerString2(userannualinfo,"#")[2];
	String userpslinfo = HrmPaidSickManagement.getUserPaidSickInfo(creater, currentdate);
	String thisyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[0], 0);
	String lastyearpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[1], 0);
	String allpsldays = ""+Util.getFloatValue(Util.TokenizerString2(userpslinfo,"#")[2], 0);
	String paidLeaveDays = String.valueOf(paidLeaveTimeManager.getCurrentPaidLeaveDaysByUser(creater));
	String allannualValue = allannual;
	String allpsldaysValue = allpsldays;
	String paidLeaveDaysValue = paidLeaveDays;
	float[] freezeDays = attVacationManager.getFreezeDays(creater);
	if(freezeDays[0] > 0) allannual += " - "+freezeDays[0];
	if(freezeDays[1] > 0) allpsldays += " - "+freezeDays[1];
	if(freezeDays[2] > 0) paidLeaveDays += " - "+freezeDays[2];
	
	float realAllannualValue = strUtil.parseToFloat(allannualValue, 0);
	float realAllpsldaysValue = strUtil.parseToFloat(allpsldaysValue, 0);
	float realPaidLeaveDaysValue = strUtil.parseToFloat(paidLeaveDaysValue, 0);
	if(attProcSetManager.isFreezeNode(workflowid, nodetype)) {
		realAllannualValue = (float)strUtil.round(realAllannualValue - freezeDays[0]);
		realAllpsldaysValue = (float)strUtil.round(realAllpsldaysValue - freezeDays[1]);
		realPaidLeaveDaysValue = (float)strUtil.round(realPaidLeaveDaysValue - freezeDays[2]);
	}
	String strleaveTypes = colorManager.getPaidleaveStr();  
%>
<script language="javascript">
	var formid = "<%=formid%>";
	var _field_resourceId = "<%=fieldList[0]%>";
	var _field_newLeaveType = "<%=fieldList[2]%>";
	var _field_fromDate = "<%=fieldList[3]%>";
	var _field_fromTime = "<%=fieldList[4]%>";
	var _field_toDate = "<%=fieldList[5]%>";
	var _field_toTime = "<%=fieldList[6]%>";
	var _field_leaveDays = "<%=fieldList[7]%>";
	var _field_vacationInfo = "<%=fieldList[8]%>";
	var f_weaver_belongto_userid = "<%=f_weaver_belongto_userid%>";
	var f_weaver_belongto_usertype = "<%=f_weaver_belongto_usertype%>";

	var allannualValue="<%=allannualValue%>";
	var allpsldaysValue="<%=allpsldaysValue%>";
	var paidLeaveDaysValue="<%=paidLeaveDaysValue%>";
	var realAllannualValue="<%=realAllannualValue%>";
	var realAllpsldaysValue="<%=realAllpsldaysValue%>";
	var realPaidLeaveDaysValue="<%=realPaidLeaveDaysValue%>";
	var strleaveTypes="<%=strleaveTypes%>";

	var ua = navigator.userAgent.toLowerCase();
	var s;
	s = ua.match(/msie ([\d.]+)/);
	
	if(s && parseInt(s[1]) <= 8){
		window.onload = function(){
			if(_field_vacationInfo != "") {
				try{
					$GetEle(_field_vacationInfo).style.display = "none";
					showVacationInfo();
					
				}catch(e){}
			}
			if(_field_leaveDays != "") {
				try{
					$GetEle(_field_leaveDays).style.display = "none";
					jQuery("#"+_field_leaveDays+"span").html(jQuery("input[name='"+_field_leaveDays+"']").val());
				}catch(e){}
			}
		}
	}else{
		jQuery(document).ready(function(){
			if(_field_vacationInfo != "") {
				try{
					$GetEle(_field_vacationInfo).style.display = "none";
					showVacationInfo();
					
				}catch(e){}
			}
			if(_field_leaveDays != "") {
				try{
					$GetEle(_field_leaveDays).style.display = "none";
					jQuery("#"+_field_leaveDays+"span").html(jQuery("input[name='"+_field_leaveDays+"']").val());
				}catch(e){}
			}
		});
	}
	
	
	function onShowTimeCallBack(id) {
		var fieldid = id.split("_")[0];
		var rowindex = id.split("_")[1];
		wfbrowvaluechange_fna(null, fieldid, rowindex);
	}
	
	function wfbrowvaluechange_fna(obj, fieldid, rowindex) {
		fieldid = "field"+fieldid;
		if(fieldid == _field_vacationInfo){ showVacationInfo();
		}else if(fieldid == _field_fromDate || fieldid == _field_fromTime || fieldid == _field_toDate || fieldid == _field_toTime){setLeaveDays();
			if(fieldid == _field_fromDate) {
				initInfo();
			}
	    }else if(fieldid == _field_resourceId){
			setLeaveDays();
			initInfo();
		}
	}

	function ajaxInit(){
		var ajax=false;
		try {
			ajax = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try {
				ajax = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (E) {
				ajax = false;
			}
		}
		if (!ajax && typeof XMLHttpRequest!='undefined') {
			ajax = new XMLHttpRequest();
		}
		return ajax;
	}

	function setLeaveDays(){
		if(_field_leaveDays == "") return;
		
		var resourceId = jQuery("input[name='"+_field_resourceId+"']").val();
		var fromDate = jQuery("input[name='"+_field_fromDate+"']").val();
		var fromTime = jQuery("input[name='"+_field_fromTime+"']").val();
		var toDate = jQuery("input[name='"+_field_toDate+"']").val();
		var toTime = jQuery("input[name='"+_field_toTime+"']").val();
		var leaveDaysObj = jQuery("input[name='"+_field_leaveDays+"']");
		var leaveDyasType = leaveDaysObj.attr("type");
		var newLeaveType = jQuery("#"+_field_newLeaveType).val();
		
		//降低调用的频次
		if(resourceId != '' && fromDate!='' && toDate!='' && fromTime!='' && toTime!=''){
			var ajax=ajaxInit();
			ajax.open("POST", "/workflow/request/BillBoHaiLeaveXMLHTTP.jsp", true);
			ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
			ajax.send("operation=getLeaveDays&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromDate="+fromDate+"&fromTime="+fromTime+"&toDate="+toDate+"&toTime="+toTime+"&resourceId="+resourceId+"&newLeaveType="+newLeaveType);
			ajax.onreadystatechange = function() {
				if (ajax.readyState == 4 && ajax.status == 200) {
					try {
						var result = trim(ajax.responseText);
						leaveDaysObj.val(result);
						//if(leaveDyasType == 'hidden') 
						jQuery("#"+_field_leaveDays+"span").html(result);
					} catch(e) {
						leaveDaysObj.val("0.0");
						//if(leaveDyasType == 'hidden') 
						jQuery("#"+_field_leaveDays+"span").html('0.0');
					}
				}
			}
		}
		showVacationInfo();
	}
function initInfo(){
		
		var resourceId = jQuery("input[name='"+_field_resourceId+"']").val();
		var fromDate = jQuery("input[name='"+_field_fromDate+"']").val();
		if(typeof(resourceId) != "undefined" && resourceId != "" && typeof(fromDate) != "undefined" && fromDate != "") {
			var ajax=ajaxInit();
			ajax.open("POST", "/workflow/request/BillBoHaiLeaveXMLHTTP.jsp", true);
			ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
			ajax.send("operation=initInfo&nodetype=<%=nodetype%>&workflowid=<%=workflowid%>&resourceId="+resourceId+"&currentDate="+fromDate+"&leavetype="+jQuery("#"+_field_newLeaveType).val());
		
			ajax.onreadystatechange = function() {
				if (ajax.readyState == 4 && ajax.status == 200) {
					try {
						 var result = trim(ajax.responseText);
						 allannualValue=result.split("#")[0];
						 allpsldaysValue=result.split("#")[1];
						 paidLeaveDaysValue=result.split("#")[2];
						 realAllannualValue=result.split("#")[3];
						 realAllpsldaysValue=result.split("#")[4];
						 realPaidLeaveDaysValue=result.split("#")[5];
					} catch(e) {
						
					}
				}
			}
		}
	}	
	
	
function getAnnualInfo(resourceId) {
	var fromDate = jQuery("input[name='"+_field_fromDate+"']").val() ;
	if(typeof(resourceId) != "undefined" && resourceId != "") {//归档后查看页面中，页面上不存在name的元素
	    var ajax=ajaxInit();
	    ajax.open("POST", "/workflow/request/BillBoHaiLeaveXMLHTTP.jsp", true);
	    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
	    ajax.send("operation=getAnnualInfo&resourceId="+resourceId+"&currentDate="+fromDate);
	    ajax.onreadystatechange = function() {
	    	if (ajax.readyState == 4 && ajax.status == 200) {
	    		try{
	    			var annualInfo=trim(ajax.responseText).split("#")[1];
					if(annualInfo == "") {
						//alert("<%=SystemEnv.getHtmlLabelName(125565, user.getLanguage())%>");
						return;
					} else {
						$GetEle(_field_vacationInfo).style.display = "none";
		                jQuery("#"+_field_vacationInfo+"span").html(annualInfo);
						jQuery("#"+_field_vacationInfo).val(annualInfo);
					}
				}catch(e){
					//alert("<%=SystemEnv.getHtmlLabelName(125565, user.getLanguage())%>");
					return;
				}
			}
	    }
	}
}
function getPSInfo(resourceId) {
	if(typeof(resourceId) != "undefined" && resourceId != "") {//归档后查看页面中，页面上不存在name的元素
	    var ajax=ajaxInit();
	    ajax.open("POST", "/workflow/request/BillBoHaiLeaveXMLHTTP.jsp", true);
	    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		ajax.send("operation=getPSInfo&resourceId="+resourceId+"&nodetype=<%=nodetype%>&workflowid=<%=workflowid%>&currentDate=<%=currentdate%>&leavetype="+jQuery("#"+_field_newLeaveType).val());

	    ajax.onreadystatechange = function() {
	    	if (ajax.readyState == 4 && ajax.status == 200) {
	    		try{
	    			var PSallpsldaysValue=trim(ajax.responseText).split("#")[1];
	    			var PSrealAllpsldaysValue=trim(ajax.responseText).split("#")[2];
	    			var PSInfo=trim(ajax.responseText).split("#")[3];
					if(PSInfo == "") {
						//alert("<%=SystemEnv.getHtmlLabelName(125566, user.getLanguage())%>");
						return;
					} else {
					 	allpsldaysValue=PSallpsldaysValue;
					 	realAllpsldaysValue=PSrealAllpsldaysValue;
						$GetEle(_field_vacationInfo).style.display = "none";
		                jQuery("#"+_field_vacationInfo+"span").html(PSInfo);
						jQuery("#"+_field_vacationInfo).val(PSInfo);
					}
				}catch(e){
					//alert("<%=SystemEnv.getHtmlLabelName(125566, user.getLanguage())%>");
					return;
				}
			}
	    }
	}
}
function getTXInfo(resourceId) {
	//alert(resourceId + "===getPSInfo");
	if(typeof(resourceId) != "undefined" && resourceId != "") {//归档后查看页面中，页面上不存在name的元素
	    var ajax=ajaxInit();
	    ajax.open("POST", "/workflow/request/BillBoHaiLeaveXMLHTTP.jsp", true);
	    ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
		var fromDate = jQuery("input[name='"+_field_fromDate+"']").val();
	    ajax.send("operation=getTXInfo&resourceId="+resourceId+"&currentDate="+fromDate);
	    ajax.onreadystatechange = function() {
	    	if (ajax.readyState == 4 && ajax.status == 200) {
	    		try{
	    			var TXInfo=trim(ajax.responseText).split("#")[1];
					if(TXInfo == "") {
						//alert("<%=SystemEnv.getHtmlLabelName(125567, user.getLanguage())%>");
						return;
					} else {
						$GetEle(_field_vacationInfo).style.display = "none";
		                jQuery("#"+_field_vacationInfo+"span").html(TXInfo);
						jQuery("#"+_field_vacationInfo).val(TXInfo);
					}
				}catch(e){
					//alert("<%=SystemEnv.getHtmlLabelName(125567, user.getLanguage())%>");
					return;
				}
			}
	    }
	}
}
	function showVacationInfo(){
	
		if(_field_vacationInfo == "") return;
		
		var newLeaveType = jQuery("#"+_field_newLeaveType).val();
		var vacationInfoObj = jQuery("input[name='"+_field_vacationInfo+"']");
		var vacationInfoType = vacationInfoObj.attr("type");
		var resourceId = jQuery("input[name='"+_field_resourceId+"']").val();
	
		var result = "";
		if(newLeaveType == '<%=HrmAttVacation.L6%>') {
			getAnnualInfo(resourceId);
		} else if(newLeaveType == '<%=HrmAttVacation.L12%>') {
		    getPSInfo(resourceId);
		} else if(newLeaveType == '<%=HrmAttVacation.L13%>') {
		    getTXInfo(resourceId);
		}else{
		    //$GetEle(_field_vacationInfo).innerText = result;
			
			if(newLeaveType != '' && strleaveTypes.indexOf(","+newLeaveType+",") > -1){
		    	getPSInfo(resourceId);
			}else{
		    jQuery("#"+_field_vacationInfo+"span").html(result);
			jQuery("#"+_field_vacationInfo).val(result);
			}
		}
		
	    confirmLeaveDays();
	}
	
	function confirmLeaveDays(){
		if(_field_leaveDays == "") return;
		
		var resourceId = jQuery("input[name='"+_field_resourceId+"']").val();
		var fromDate = jQuery("input[name='"+_field_fromDate+"']").val();
		var fromTime = jQuery("input[name='"+_field_fromTime+"']").val();
		var toDate = jQuery("input[name='"+_field_toDate+"']").val();
		var toTime = jQuery("input[name='"+_field_toTime+"']").val();
		var leaveDaysObj = jQuery("input[name='"+_field_leaveDays+"']");
		var leaveDyasType = leaveDaysObj.attr("type");
		var newLeaveType = jQuery("#"+_field_newLeaveType).val();
		//降低调用的频次,confirm的时候增加对于请假类型的判断
		if(resourceId != '' && fromDate!='' && toDate!='' && fromTime!='' && toTime!='' && newLeaveType!=''){
			var ajax=ajaxInit();
			ajax.open("POST", "/workflow/request/BillBoHaiLeaveXMLHTTP.jsp", true);
			ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
			ajax.send("operation=getLeaveDays&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromDate="+fromDate+"&fromTime="+fromTime+"&toDate="+toDate+"&toTime="+toTime+"&resourceId="+resourceId+"&newLeaveType="+newLeaveType);
			ajax.onreadystatechange = function() {
				if (ajax.readyState == 4 && ajax.status == 200) {
					try {
						var result = trim(ajax.responseText);
						leaveDaysObj.val(result);
						jQuery("#"+_field_leaveDays+"span").html(result);
					} catch(e) {
						leaveDaysObj.val("0.0");
						jQuery("#"+_field_leaveDays+"span").html('0.0');
					}
				}
			}
		}
	}
	
	initInfo();
	checkCustomize = function() {
		<%if(nodetype!=3){%>
		var newLeaveType = jQuery("#"+_field_newLeaveType).val();
		if(!DateCheck()){
			return false;
		}
		
		if(newLeaveType == '<%=HrmAttVacation.L6%>') {
			if(allannualValue <= 0){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21720,user.getLanguage())%>");
		        return false;
			}
			if($GetEle(_field_leaveDays)!=null && parseFloat($GetEle(_field_leaveDays).value) > parseFloat(realAllannualValue)){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(21721,user.getLanguage())%>");
				return false;
			}
		} else if(newLeaveType == '<%=HrmAttVacation.L12%>') {
			if(allpsldaysValue <= 0){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131655,user.getLanguage())%>");
		        return false;
			}
			if($GetEle(_field_leaveDays)!=null && parseFloat($GetEle(_field_leaveDays).value) > parseFloat(realAllpsldaysValue)){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131656,user.getLanguage())%>");
				return false;
			}
		} else if(newLeaveType == '<%=HrmAttVacation.L13%>') {
			if($GetEle(_field_leaveDays)!=null && parseFloat($GetEle(_field_leaveDays).value) > parseFloat(realPaidLeaveDaysValue)){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84604,user.getLanguage())%>");
				return false;
			}
		} else{
			if(newLeaveType != '' && strleaveTypes.indexOf(","+newLeaveType+",") > -1){
				if(allpsldaysValue <= 0){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131655,user.getLanguage())%>");
			        return false;
				}
				if($GetEle(_field_leaveDays)!=null && parseFloat($GetEle(_field_leaveDays).value) > parseFloat(realAllpsldaysValue)){
					window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(131656,user.getLanguage())%>");
					return false;
				}
			}
		}
		<%}%>
		
		return true;
	};
	
function DateCheck(){
	var fromDate = jQuery("input[name='"+_field_fromDate+"']").val();
	var fromTime = jQuery("input[name='"+_field_fromTime+"']").val();
	var toDate = jQuery("input[name='"+_field_toDate+"']").val();
	var toTime = jQuery("input[name='"+_field_toTime+"']").val();
	var begin = new Date(fromDate.replace(/\-/g, "\/"));
	var end = new Date(toDate.replace(/\-/g, "\/"));
 	if(fromTime != "" && toTime != ""){
	 	begin = new Date(fromDate.replace(/\-/g, "\/")+" "+fromTime+":00");  
	 	end = new Date(toDate.replace(/\-/g, "\/")+" "+toTime+":00");
	 	if(fromDate!=""&&toDate!=""&&begin >end)  
	 	{  
	 		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
	  		return false;  
	 	}
 	}else{
 		if(fromDate!=""&&toDate!=""&&begin >end)  
	 	{  
	 		window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
	  		return false;  
	 	}
 	}
 	return true;
}
</script>
