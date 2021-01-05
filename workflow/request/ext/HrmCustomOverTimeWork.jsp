<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="weaver.hrm.attendance.domain.*"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<%@page import="weaver.hrm.User"%>
<!-- Added by wcd 2015-09-10[加班流程] -->
<jsp:useBean id="strUtil" class="weaver.common.StringUtil" scope="page" />
<jsp:useBean id="dateUtil" class="weaver.common.DateUtil" scope="page" />
<jsp:useBean id="attProcSetManager" class="weaver.hrm.attendance.manager.HrmAttProcSetManager" scope="page" />
<%
	User user = (User)request.getSession(true).getAttribute("weaver_user@bean");
	int nodetype = strUtil.parseToInt(request.getParameter("nodetype"), 0);
	int workflowid = strUtil.parseToInt(request.getParameter("workflowid"), 0);
	int formid = strUtil.parseToInt(request.getParameter("formid"));
	int userid = strUtil.parseToInt(request.getParameter("userid"));
	String creater = strUtil.vString(request.getParameter("creater"), String.valueOf(userid));
	String[] fieldList = attProcSetManager.getFieldList(3, workflowid, formid);
	String currentdate = strUtil.vString(request.getParameter("currentdate"), dateUtil.getCurrentDate());
	String f_weaver_belongto_userid = strUtil.vString(request.getParameter("f_weaver_belongto_userid"));
	String f_weaver_belongto_usertype = strUtil.vString(request.getParameter("f_weaver_belongto_usertype"));
	if(fieldList.length == 0) return;
%>
<script language="javascript">
	var formid = "<%=formid%>";
	var creater = "<%=creater%>";
	var _field_resourceId = "<%=fieldList[0]%>";
	var _field_fromdate = "<%=fieldList[1]%>";
	var _field_fromtime = "<%=fieldList[2]%>";
	var _field_tilldate = "<%=fieldList[3]%>";
	var _field_tilltime = "<%=fieldList[4]%>";
	var _field_overtimeDays = "<%=fieldList[5]%>";
	var _field_departmentId = "<%=fieldList[6]%>";
	var _field_otype = "<%=fieldList[7]%>";
	var f_weaver_belongto_userid = "<%=f_weaver_belongto_userid%>";
	var f_weaver_belongto_usertype = "<%=f_weaver_belongto_usertype%>";
	
	var ua = navigator.userAgent.toLowerCase();
	var s;
	s = ua.match(/msie ([\d.]+)/);
	
	if(s && parseInt(s[1]) <= 8){
		window.onload = function(){
			if(_field_overtimeDays != "") {
				try{
					$GetEle(_field_overtimeDays).style.display = "none";
					jQuery("#"+_field_overtimeDays+"span").html(jQuery("input[name='"+_field_overtimeDays+"']").val());
				}catch(e){}
			}
		}
	}else{
		jQuery(document).ready(function(){
			if(_field_overtimeDays != "") {
				try{
					$GetEle(_field_overtimeDays).style.display = "none";
					jQuery("#"+_field_overtimeDays+"span").html(jQuery("input[name='"+_field_overtimeDays+"']").val());
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
		if(_field_fromdate==fieldid || _field_fromtime==fieldid || _field_tilldate==fieldid || _field_tilltime==fieldid){
			var fromdate = jQuery("#"+_field_fromdate).val();
			var fromtime = jQuery("#"+_field_fromtime).val();
			var tilldate = jQuery("#"+_field_tilldate).val();
			var tilltime = jQuery("#"+_field_tilltime).val();
			var overtimeDaysObj = jQuery("#"+_field_overtimeDays);
			var overtimeDaysType = overtimeDaysObj.attr("type");
			if(overtimeDaysObj.attr("readonly") != true) overtimeDaysObj.attr("readonly","readonly");
		
			setValue(fromdate, fromtime, tilldate, tilltime, overtimeDaysObj, overtimeDaysType, rowindex);
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

	function setValue(fromdate, fromtime, tilldate, tilltime, overtimeDaysObj, overtimeDaysType, rowindex){
		if(fromdate != '' && fromtime!='' && tilldate!='' && tilltime!=''){
			var ajax=ajaxInit();
			var resourceId = jQuery("#"+_field_resourceId).val();
			ajax.open("POST", "/workflow/request/BillBoHaiLeaveXMLHTTP.jsp", true);
			ajax.setRequestHeader("Content-Type","application/x-www-form-urlencoded");
			ajax.send("operation=getLeaveDays&f_weaver_belongto_userid="+f_weaver_belongto_userid+"&worktime=false&f_weaver_belongto_usertype="+f_weaver_belongto_usertype+"&fromDate="+fromdate+"&fromTime="+fromtime+"&toDate="+tilldate+"&toTime="+tilltime+"&resourceId="+resourceId);
			ajax.onreadystatechange = function() {
				if (ajax.readyState == 4 && ajax.status == 200) {
					try {
						var result = trim(ajax.responseText);
						overtimeDaysObj.val(result);
						jQuery("#"+_field_overtimeDays+"span").html(result);
					} catch(e) {
						overtimeDaysObj.val("0.0");
						jQuery("#"+_field_overtimeDays+"span").html('0.0');
					}
				}
			}
		}
	}
	
	checkCustomize = function() {
		var aa = jQuery("#"+_field_fromdate).val();
		var bb = jQuery("#"+_field_fromtime).val();
		var cc = jQuery("#"+_field_tilldate).val();
		var dd = jQuery("#"+_field_tilltime).val();
		var begin = new Date(aa.replace(/\-/g, "\/"));
		var end = new Date(cc.replace(/\-/g, "\/"));
		if(bb != "" && dd != ""){
			begin = new Date(aa.replace(/\-/g, "\/")+" "+bb+":00");  
			end = new Date(cc.replace(/\-/g, "\/")+" "+dd+":00");
			if(aa!=""&&cc!=""&&begin >end)  
			{  
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
				return false;  
			}
		}else{
			if(aa!=""&&cc!=""&&begin >end)  
			{  
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>");
				return false;  
			}
		}
		return true;
	};
	
</script>