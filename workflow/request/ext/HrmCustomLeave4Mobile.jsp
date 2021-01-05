<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="weaver.general.Util,weaver.hrm.common.*,weaver.conn.*,weaver.systeminfo.*" %>
<%@ page import="weaver.hrm.attendance.domain.*,weaver.hrm.User,weaver.hrm.HrmUserVarify"%>
<%@ page import="weaver.hrm.schedule.HrmAnnualManagement,weaver.common.StringUtil,weaver.common.DateUtil"%>
<%@ page import="weaver.hrm.schedule.HrmPaidSickManagement,weaver.hrm.attendance.manager.*"%>
<jsp:useBean id="colorManager" class="weaver.hrm.attendance.manager.HrmLeaveTypeColorManager" scope="page" />
<!-- Added by wcd 2015-09-08[自定义请假单4Mobile] -->
<%
	User user = HrmUserVarify.getUser(request, response) ;
	if(user == null){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	HrmAttProcSetManager attProcSetManager = new HrmAttProcSetManager();
	WorkflowBaseManager workflowBaseManager = new WorkflowBaseManager();
	HrmAttVacationManager attVacationManager = new HrmAttVacationManager();
	HrmPaidLeaveTimeManager paidLeaveTimeManager = new HrmPaidLeaveTimeManager();
	int nodetype = StringUtil.parseToInt(request.getParameter("nodetype"), 0);
	int requestid = StringUtil.parseToInt(request.getParameter("requestid"), 0);
	int workflowid = StringUtil.parseToInt(request.getParameter("workflowid"), 0);
	int formid = StringUtil.parseToInt(request.getParameter("formid"), -1);
	if(formid == -1) {
		WorkflowBase bean = workflowBaseManager.get(workflowid);
		formid = bean == null ? -1 : bean.getFormid();
	}
	int userid = StringUtil.parseToInt(request.getParameter("userid"));
	String creater = StringUtil.vString(request.getParameter("creater"));
	if(requestid <= 0) creater = String.valueOf(userid);
	else {
		WorkflowRequestbaseManager workflowRequestbaseManager = new WorkflowRequestbaseManager();
		WorkflowRequestbase bean = workflowRequestbaseManager.get(requestid);
		creater = bean == null ? String.valueOf(userid) : String.valueOf(bean.getCreater());
		nodetype = bean == null ? -1 : StringUtil.parseToInt(bean.getCurrentnodetype(), -1);

		
		//以下的内容是处理当存在 代理人发起请假流程的情况		
		RecordSet rs = new RecordSet();
		Map<String, String> map = new HashMap<String, String>();
		map.put("requestId", "and t.requestId = "+requestid);
		String param = "select id from hrm_att_proc_set where field001 = "+workflowid;
		rs.executeSql(attProcSetManager.getSQLByField006(0, map, false, true, param));
		String resourceIdFrom = "";
		if(rs.next()) {
			resourceIdFrom = StringUtil.vString(rs.getInt("resourceId"),"");
		}
		if(!"".equals(resourceIdFrom)){
			if(!creater.equals(resourceIdFrom)){
				creater = resourceIdFrom;
			}
		}
	}
	String[] fieldList = attProcSetManager.getFieldList(workflowid, formid);
	if(fieldList == null || fieldList.length == 0 || StringUtil.isNull(fieldList[0])) return;
	String currentdate = StringUtil.vString(request.getParameter("currentdate"), DateUtil.getCurrentDate());
	String f_weaver_belongto_userid = StringUtil.vString(request.getParameter("f_weaver_belongto_userid"));
	String f_weaver_belongto_usertype = StringUtil.vString(request.getParameter("f_weaver_belongto_usertype"));
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
	
	float realAllannualValue = StringUtil.parseToFloat(allannualValue, 0);
	float realAllpsldaysValue = StringUtil.parseToFloat(allpsldaysValue, 0);
	float realPaidLeaveDaysValue = StringUtil.parseToFloat(paidLeaveDaysValue, 0);
	if(attProcSetManager.isFreezeNode(workflowid, nodetype)) {
		realAllannualValue = (float)StringUtil.round(realAllannualValue - freezeDays[0]);
		realAllpsldaysValue = (float)StringUtil.round(realAllpsldaysValue - freezeDays[1]);
		realPaidLeaveDaysValue = (float)StringUtil.round(realPaidLeaveDaysValue - freezeDays[2]);
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
	
	jQuery(document).ready(function(){
		//自定义请假单和系统请假单在日期控件中要单独判断
		iscustome=1;
		if(_field_vacationInfo != "") {
			try{
				var vacationInfoObj = jQuery("#"+_field_vacationInfo);
				if(vacationInfoObj.attr("readonly") != true) vacationInfoObj.attr("readonly","readonly");
				showVacationInfo();
			}catch(e){}
		}
		jQuery("input[name='"+_field_fromDate+"']").bind("change",function(){
			setLeaveDays(); 
		});
		jQuery("input[name='"+_field_fromTime+"']").bind("change",function(){
			setLeaveDays(); 
		});
		jQuery("input[name='"+_field_toDate+"']").bind("change",function(){
			setLeaveDays(); 
		});
		jQuery("input[name='"+_field_toTime+"']").bind("change",function(){
			setLeaveDays(); 
		});
		setLeaveDays();
	});

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
	
	function maindetailfieldchange(obj) {
		setLeaveDays();
	}

	function setLeaveDays(){
		if(_field_leaveDays == "") return;
		var resourceId = jQuery("input[name='"+_field_resourceId+"']").val();
		var fromDate = jQuery("input[name='"+_field_fromDate+"']").val();
		var fromTime = jQuery("input[name='"+_field_fromTime+"']").val();
		var toDate = jQuery("input[name='"+_field_toDate+"']").val();
		var toTime = jQuery("input[name='"+_field_toTime+"']").val();
		var leaveDaysObj = jQuery("input[name='"+_field_leaveDays+"']");
		if(leaveDaysObj.attr("readonly") != true) leaveDaysObj.attr("readonly","readonly");
		var newLeaveType = jQuery("#"+_field_newLeaveType).val();
		var leaveDyasType = leaveDaysObj.attr("type");
		
		if(resourceId != '' && fromDate!='' && fromTime!='' && toDate!='' && toTime!=''){
			$.get('/mobile/plugin/1/workflowBillAction.jsp?action=getLeaveDays',{fromDate:fromDate,fromTime:fromTime,toDate:toDate,toTime:toTime,resourceId:resourceId,newLeaveType:newLeaveType},
				function process(dataObj){
					if(dataObj) try {leaveDaysObj.val(dataObj.days);} catch(e) {leaveDaysObj.val("0.0");}
					if(leaveDyasType == 'hidden') leaveDaysObj.prev().html(dataObj.days);
				}
			,"json");
		}
		showVacationInfo();
	}

	function showVacationInfo(){
		if(_field_vacationInfo == "") return;
		
		var newLeaveType = jQuery("#"+_field_newLeaveType).val();
		var resourceId = jQuery("input[name='"+_field_resourceId+"']").val();
		var result = "";
		if(newLeaveType == '<%=HrmAttVacation.L6%>') {
			getAnnualInfo(resourceId);
		} else if(newLeaveType == '<%=HrmAttVacation.L12%>') {
			getPSInfo(resourceId);
		} else if(newLeaveType == '<%=HrmAttVacation.L13%>') {
			getTXInfo(resourceId);
		} else {
			if(newLeaveType != '' && strleaveTypes.indexOf(","+newLeaveType+",") > -1){
		    	getPSInfo(resourceId);
			}else{
				jQuery("#"+_field_vacationInfo).html(result);
				try{jQuery("#"+_field_vacationInfo+"_span").html(result);}catch(e){}
			}
		}
		//confirmLeaveDays();
	}		
	
	function getAnnualInfo(resourceId) {
		var fromDate = jQuery("input[name='"+_field_fromDate+"']").val();
		if(typeof(resourceId) != "undefined" && resourceId != "") {//归档后查看页面中，页面上不存在name的元素
			$.get('/mobile/plugin/1/workflowBillAction.jsp?action=getAnnualInfo',{cmd:"leaveInfo", currentDate:fromDate, nodetype:"<%=nodetype%>", workflowid:"<%=workflowid%>",resourceId:resourceId},
				function process(dataObj){
					if(dataObj) {
						jQuery("#"+_field_vacationInfo).html(dataObj.info);
						try{jQuery("#"+_field_vacationInfo+"_span").html(dataObj.info);}catch(e){}
					}
				}
			,"json");
		}
	}
	function getPSInfo(resourceId) {
		//alert(resourceId + "===getPSInfo");
		var newLeaveType = jQuery("#"+_field_newLeaveType).val();
		if(typeof(resourceId) != "undefined" && resourceId != "") {//归档后查看页面中，页面上不存在name的元素
			$.get('/mobile/plugin/1/workflowBillAction.jsp?action=getPSInfo',{cmd:"leaveInfo", currentDate:"<%=currentdate%>", nodetype:"<%=nodetype%>", workflowid:"<%=workflowid%>",resourceId:resourceId,leavetype:newLeaveType},
				function process(dataObj){
					if(dataObj) {
					 	allpsldaysValue=dataObj.allpsldaysValue;
					 	realAllpsldaysValue=dataObj.realAllpsldaysValue;
						jQuery("#"+_field_vacationInfo).html(dataObj.info);
						try{jQuery("#"+_field_vacationInfo+"_span").html(dataObj.info);}catch(e){}
					}
				}
			,"json");
		}
	}
	function getTXInfo(resourceId) {
		//alert(resourceId + "===getPSInfo");
		var fromDate = jQuery("input[name='"+_field_fromDate+"']").val();
		if(typeof(resourceId) != "undefined" && resourceId != "") {//归档后查看页面中，页面上不存在name的元素
			$.get('/mobile/plugin/1/workflowBillAction.jsp?action=getTXInfo',{cmd:"leaveInfo", nodetype:"<%=nodetype%>", workflowid:"<%=workflowid%>", currentDate:fromDate,resourceId:resourceId},
				function process(dataObj){
					if(dataObj) {
						jQuery("#"+_field_vacationInfo).html(dataObj.info);
						try{jQuery("#"+_field_vacationInfo+"_span").html(dataObj.info);}catch(e){}
					}
				}
			,"json");
		}
	}
	
	function confirmLeaveDays(){
		if(_field_leaveDays == "") return;
		var resourceId = jQuery("input[name='"+_field_resourceId+"']").val();
		var fromDate = jQuery("input[name='"+_field_fromDate+"']").val();
		var fromTime = jQuery("input[name='"+_field_fromTime+"']").val();
		var toDate = jQuery("input[name='"+_field_toDate+"']").val();
		var toTime = jQuery("input[name='"+_field_toTime+"']").val();
		var leaveDaysObj = jQuery("input[name='"+_field_leaveDays+"']");
		if(leaveDaysObj.attr("readonly") != true) leaveDaysObj.attr("readonly","readonly");
		var newLeaveType = jQuery("#"+_field_newLeaveType).val();
		var leaveDyasType = leaveDaysObj.attr("type");
		
		//降低调用的频次,confirm的时候增加对于请假类型的判断
		if(resourceId != '' && fromDate!='' && fromTime!='' && toDate!='' && toTime!='' && newLeaveType!=''){
			$.get('/mobile/plugin/1/workflowBillAction.jsp?action=getLeaveDays',{fromDate:fromDate,fromTime:fromTime,toDate:toDate,toTime:toTime,resourceId:resourceId,newLeaveType:newLeaveType},
				function process(dataObj){
					if(dataObj) try {leaveDaysObj.val(dataObj.days);} catch(e) {leaveDaysObj.val("0.0");}
					if(leaveDyasType == 'hidden') leaveDaysObj.prev().html(dataObj.days);
				}
			,"json");
		}
	}
	
	checkCustomize1 = function(){
		<%if(nodetype!=3){%>
		
		var dt = DateCheck1() ;
		if(dt != "") return dt ;
		
		
		var newLeaveType = jQuery("#"+_field_newLeaveType).val();
		if(newLeaveType == '<%=HrmAttVacation.L6%>') {
			if(allannualValue <= 0){
		        return "<%=SystemEnv.getHtmlLabelName(21720,user.getLanguage())%>";
			}
			if($GetEle(_field_leaveDays)!=null && parseFloat($GetEle(_field_leaveDays).value) > parseFloat(realAllannualValue)){
				return "<%=SystemEnv.getHtmlLabelName(21721,user.getLanguage())%>";
			}
		} else if(newLeaveType == '<%=HrmAttVacation.L12%>') {
			if(allpsldaysValue <= 0){
		        return "<%=SystemEnv.getHtmlLabelName(131655,user.getLanguage())%>";
			}
			if($GetEle(_field_leaveDays)!=null && parseFloat($GetEle(_field_leaveDays).value) > parseFloat(realAllpsldaysValue)){
				return "<%=SystemEnv.getHtmlLabelName(131656,user.getLanguage())%>";
			}
		} else if(newLeaveType == '<%=HrmAttVacation.L13%>') {
			if($GetEle(_field_leaveDays)!=null && parseFloat($GetEle(_field_leaveDays).value) > parseFloat(realPaidLeaveDaysValue)){
				return "<%=SystemEnv.getHtmlLabelName(84604,user.getLanguage())%>";
			}
		}else if(newLeaveType != '' && strleaveTypes.indexOf(","+newLeaveType+",") > -1){
			if(allpsldaysValue <= 0){
		        return "<%=SystemEnv.getHtmlLabelName(131655,user.getLanguage())%>";
			}
			if($GetEle(_field_leaveDays)!=null && parseFloat($GetEle(_field_leaveDays).value) > parseFloat(realAllpsldaysValue)){
				return "<%=SystemEnv.getHtmlLabelName(131656,user.getLanguage())%>";
			}
		} 
		<%}%>
		return "";
	};
	
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
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24044,user.getLanguage())%>");
		        return false;
			}
			if($GetEle(_field_leaveDays)!=null && parseFloat($GetEle(_field_leaveDays).value) > parseFloat(realAllpsldaysValue)){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(24045,user.getLanguage())%>");
				return false;
			}
		} else if(newLeaveType == '<%=HrmAttVacation.L13%>') {
			if($GetEle(_field_leaveDays)!=null && parseFloat($GetEle(_field_leaveDays).value) > parseFloat(realPaidLeaveDaysValue)){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(84604,user.getLanguage())%>");
				return false;
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



function DateCheck1(){
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
	 		
	  		return "<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>";  
	 	}
 	}else{
 		if(fromDate!=""&&toDate!=""&&begin >end)  
	 	{  
	 		
	  		return "<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>";  
	 	}
 	}
 	return "";
}

</script>
