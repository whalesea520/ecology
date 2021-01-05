<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="weaver.hrm.attendance.domain.*,weaver.hrm.attendance.manager.*"%>
<%@ page import="weaver.common.StringUtil,weaver.common.DateUtil"%>
<%@ page import="weaver.hrm.User,weaver.hrm.HrmUserVarify"%>
<%@page import="weaver.systeminfo.SystemEnv"%>
<!-- Added by wcd 2015-09-10[加班流程4Mobile] -->
<%
	User user = HrmUserVarify.getUser(request, response) ;
	if(user == null){
		response.sendRedirect("/notice/noright.jsp") ;
		return ;
	}
	HrmAttProcSetManager attProcSetManager = new HrmAttProcSetManager();
	WorkflowBaseManager workflowBaseManager = new WorkflowBaseManager();
	int nodetype = StringUtil.parseToInt(request.getParameter("nodetype"), 0);
	int workflowid = StringUtil.parseToInt(request.getParameter("workflowid"), 0);
	int formid = StringUtil.parseToInt(request.getParameter("formid"));
	if(formid == -1) {
		WorkflowBase bean = workflowBaseManager.get(workflowid);
		formid = bean == null ? -1 : bean.getFormid();
	}
	int userid = StringUtil.parseToInt(request.getParameter("userid"));
	String creater = StringUtil.vString(request.getParameter("creater"), String.valueOf(userid));
	String[] fieldList = attProcSetManager.getFieldList(3, workflowid, formid);
	String currentdate = StringUtil.vString(request.getParameter("currentdate"), DateUtil.getCurrentDate());
	String f_weaver_belongto_userid = StringUtil.vString(request.getParameter("f_weaver_belongto_userid"));
	String f_weaver_belongto_usertype = StringUtil.vString(request.getParameter("f_weaver_belongto_usertype"));
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
	
	jQuery(document).ready(function(){
		//自定义加班日期控件中要单独判断
		iscustome=2;
		jQuery("input[name='"+_field_fromdate+"']").bind("change",function(){
			setValue(); 
		});
		jQuery("input[name='"+_field_fromtime+"']").bind("change",function(){
			setValue(); 
		});
		jQuery("input[name='"+_field_tilldate+"']").bind("change",function(){
			setValue(); 
		});
		jQuery("input[name='"+_field_tilltime+"']").bind("change",function(){
			setValue(); 
		});
	});
	
	function maindetailfieldchange(obj) {
		setValue();
	}
	
	function setValue(){
		if(_field_overtimeDays == "") return;
		
		var resourceId = jQuery("input[name='"+_field_resourceId+"']").val();
		var fromDate = jQuery("input[name='"+_field_fromdate+"']").val();
		var fromTime = jQuery("input[name='"+_field_fromtime+"']").val();
		var toDate = jQuery("input[name='"+_field_tilldate+"']").val();
		var toTime = jQuery("input[name='"+_field_tilltime+"']").val();
		var overtimeDaysObj = jQuery("input[name='"+_field_overtimeDays+"']");
		if(overtimeDaysObj.attr("readonly") != true) overtimeDaysObj.attr("readonly","readonly");
		var overtimeDaysType = overtimeDaysObj.attr("type");
		
		if(resourceId != '' && fromDate!='' && fromTime!='' && toDate!='' && toTime!=''){
			$.get('/mobile/plugin/1/workflowBillAction.jsp?action=getLeaveDays',{fromDate:fromDate,fromTime:fromTime,toDate:toDate,toTime:toTime,resourceId:resourceId,worktime:'false'},
				function process(dataObj){
					if(dataObj) try {overtimeDaysObj.val(dataObj.days);} catch(e) {overtimeDaysObj.val("0.0");}
					if(overtimeDaysType == 'hidden') overtimeDaysObj.prev().html(dataObj.days);
				}
			,"json");
		}
	}

	checkCustomize1 = function() {
		var aa = jQuery("input[name='"+_field_fromdate+"']").val();
		var bb = jQuery("input[name='"+_field_fromtime+"']").val();
		var cc = jQuery("input[name='"+_field_tilldate+"']").val();
		var dd = jQuery("input[name='"+_field_tilltime+"']").val();
		var begin = new Date(aa.replace(/\-/g, "\/"));
		var end = new Date(cc.replace(/\-/g, "\/"));
		if(bb != "" && dd != ""){
			begin = new Date(aa.replace(/\-/g, "\/")+" "+bb+":00");  
			end = new Date(cc.replace(/\-/g, "\/")+" "+dd+":00");
			if(aa!=""&&cc!=""&&begin >end)  
			{  
				return "<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>";  
			}
		}else{
			if(aa!=""&&cc!=""&&begin >end)  
			{  
				return "<%=SystemEnv.getHtmlLabelName(15273,user.getLanguage())%>";  
			}
		}
		return "";
	};

</script>