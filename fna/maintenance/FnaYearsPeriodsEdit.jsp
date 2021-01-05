<%@page import="org.apache.commons.lang.StringEscapeUtils"%>
<%@ page import="weaver.general.Util"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>

<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="BudgetModuleComInfo" class="weaver.fna.maintenance.BudgetModuleComInfo" scope="page" />
<HTML>
	<HEAD>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<script type="text/javascript" src="/fna/js/e8Common_wev8.js?r=9"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
		<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
		<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
	</head>
<%	
	if (!HrmUserVarify.checkUserRight("FnaYearsPeriodsAdd:Add", user)) {
		response.sendRedirect("/notice/noright.jsp");
		return;
	}

	String id = Util.null2String(request.getParameter("id")) ; 
	String _type = Util.null2String(request.getParameter("_type")) ; 
	String operationType = Util.null2String(request.getParameter("operationType")) ; 
	int msgid = Util.getIntValue(request.getParameter("msgid") , -1) ; 
	RecordSet.executeProc("FnaYearsPeriods_SelectByID" , id) ; 
	RecordSet.next() ; 
	String fnayear = Util.null2String(RecordSet.getString("fnayear")) ; 
	String startdate = Util.null2String(RecordSet.getString("startdate")) ; 
	String enddate = Util.null2String(RecordSet.getString("enddate")) ; 
	String budgetid = Util.null2String(RecordSet.getString("budgetid")) ;

	RecordSet.execute("select status from FnaYearsPeriods where id = "+id);
	RecordSet.next() ; 
	String status=Util.null2o(RecordSet.getString("status"));
	String showStatus = SystemEnv.getHtmlLabelName(18430,user.getLanguage());//未生效
	if("0".equals(status)){
		showStatus=SystemEnv.getHtmlLabelName(18430,user.getLanguage());//未生效
	}else if("1".equals(status)){
		showStatus=SystemEnv.getHtmlLabelName(18431,user.getLanguage());//生效
	}else if("-1".equals(status)){
		showStatus=SystemEnv.getHtmlLabelName(309,user.getLanguage());//关闭
	}

	boolean canedit = HrmUserVarify.checkUserRight("FnaYearsPeriodsEdit:Edit" , user) ; 

	String imagefilename = "/images/hdMaintenance_wev8.gif" ; 
	String titlename = ""; 
	String needfav = "1" ; 
	String needhelp = "" ; 
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
	RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
			+ ",javascript:onAdd(),_self} ";
	RCMenuHeight += RCMenuHeightStep;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="fna"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(18648,user.getLanguage()) %>"/>
</jsp:include>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td>
				<td class="rightSearchSpan" style="text-align: right;">
					<input type="button" value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="onAdd();">
					<span title="<%=SystemEnv.getHtmlLabelName(23036, user.getLanguage())%>" class="cornerMenu"></span>
				</td>
			</tr>
		</table>
		
		
<input class=inputstyle id=fnayear type=hidden value="<%=fnayear%>" name=fnayear>
<input class=inputstyle type="hidden" name="operation">
<input class=inputstyle type="hidden" name="id" value="<%=id%>">

	<wea:layout type="2Col">
		<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>'>
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(445, user.getLanguage())%>
			</wea:item>
			<wea:item>
				<B><%=fnayear%></B>
			</wea:item>
			
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(97, user.getLanguage())+SystemEnv.getHtmlLabelName(19467, user.getLanguage())%>
			</wea:item>
			<wea:item>
				<%=startdate%> - <%=enddate%>
			</wea:item>
			
			<wea:item>
				<%=SystemEnv.getHtmlLabelName(602, user.getLanguage())%>
			</wea:item>
			<wea:item>
				<%
				FnaTransMethod fnaTransMethod = new FnaTransMethod();
				%>
				<%=fnaTransMethod.getStatus(status, user.getLanguage()+"") %>
				<input name="status" id="status" class="inputstyle" type="hidden" value="0" />
			</wea:item>
		</wea:group>
</wea:layout>
<%
String backfields = "id,Periodsid,startdate,enddate,status ";
String sqlWhere = "where fnayearid=" + id + "and Periodsid<>13";
String fromSql = " from FnaYearsPeriodsList";
String orderby = "Periodsid";
String tableString = "";

String titleExecRatio = "<span>"+SystemEnv.getHtmlLabelName(130115,user.getLanguage())+"</span>"+
		"<span class=\"xTable_algorithmdesc\" title=\""+SystemEnv.getHtmlLabelName(131233,user.getLanguage())+"\">"+
		"<img src=\"/images/tooltip_wev8.png\" align=\"Middle\" style=\"vertical-align:top;\">"+
		"</span>";

tableString = " <table instanceid=\"FnaYearsPeriodsListTable\" tabletype=\"none\"   pagesize=\"" + "12" + "\" >" + 
			"	   <sql backfields=\"" + Util.toHtmlForSplitPage(backfields) + "\" sqlform=\"" + Util.toHtmlForSplitPage(fromSql) + "\" sqlwhere=\"" + Util.toHtmlForSplitPage(sqlWhere) + "\" "+
			" sqlorderby=\""	+ Util.toHtmlForSplitPage(orderby) + "\"  sqlprimarykey=\"id\" sqlsortway=\"asc\" />" + 
			"			<head>" + 
			"				<col width=\"10%\"  text=\"" + SystemEnv.getHtmlLabelName(15486, user.getLanguage()) + "\" column=\"Periodsid\" />" + 
			"				<col width=\"35%\"  text=\"" + SystemEnv.getHtmlLabelName(740, user.getLanguage()) + "\" column=\"startdate\" "+
							" otherpara=\"column:periodsid\" transmethod=\"weaver.general.FnaTransMethod.getStartDate\" />" + 
			"				<col width=\"35%\"  text=\"" + SystemEnv.getHtmlLabelName(741, user.getLanguage()) + "\" column=\"enddate\" "+
							" otherpara=\"column:periodsid\" transmethod=\"weaver.general.FnaTransMethod.getEndDate\"/>" ;
			if("1".equals(status)){
				tableString += "<col width=\"15%\"  text=\"" + StringEscapeUtils.escapeXml(titleExecRatio) + "\" column=\"status\" " +
					" transmethod=\"weaver.general.FnaTransMethod.getTransName\" otherpara=\"edit_status+"+user.getLanguage()+"+column:id+column:status+column:startdate+column:enddate\"/>";	
			}
						
			tableString += "</head>" + 
			" </table>";
%>
<wea:SplitPageTag tableString='<%=tableString%>' mode="run" isShowBottomInfo="false" />
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
	    <wea:group context="">
	    	<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage()) %>" id="zd_btn_cancle" class="zd_btn_cancle" onclick="onCancel();">
	    	</wea:item>
	    </wea:group>
	</wea:layout>
</div>

			
<script type="text/javascript">
var _Label33574 = "<%=SystemEnv.getHtmlLabelName(33574,user.getLanguage()) %>";//正在处理数据，请不要离开该页面，请稍等...

resizeDialog(document);

var _type = "<%=_type %>";
function onCancel(){
	var dialog = parent.getDialog(window);	
	//dialog.close();
	dialog.closeByHand();
}

function onAdd(){
	var id=<%=id%>;
    var fnayear=<%=fnayear%>;
    var _flag=true;
    
    var _data = "operation=edityearperiodslist&id="+id+"&fnayear="+fnayear;
    
	for(var i=1;i<=12;i++){
		var beginDate = jQuery('#beginDate_'+i);
		var endDate = jQuery('#endDate_'+i);
		var beginDateval=beginDate.val();
		var endDateval=endDate.val();
		_data+="&beginDate_"+i+"="+beginDate.val()+"&endDate_"+i+"="+endDate.val();
	    if(beginDateval.trim().length==0||endDateval.trim().length==0){
		    _flag=false;
		    top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(30702, user.getLanguage())%>");
		    return false;
	    }  
	}
	if(_flag){
		openNewDiv_FnaBudgetViewInner1(_Label33574);
		jQuery.ajax({
			url : "/fna/maintenance/FnaYearsPeriodsOperation.jsp",
			type : "post",
			processData : false,
			data : _data, 
			dataType : "json",
			success: function do4Success(msg){ 
				try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
				if(msg.flag){
					var parentWin = parent.getParentWindow(window);
					parentWin.onBtnSearchClick();
					onCancel();
				}else{
					top.Dialog.alert(msg.erroInfo);
				}
			}
		});
	}
}

function edit_status(id,status,startDate,endDate){
	openNewDiv_FnaBudgetViewInner1(_Label33574);
	var _data = "operation=editStatus&id="+id+"&status="+status+"&startDate="+startDate+"&endDate="+endDate;
	
	jQuery.ajax({
		url : "/fna/maintenance/YearsPeriodsStatusOperation.jsp",
		type : "post",
		processData : false,
		data : _data, 
		dataType : "json",
		success: function do4Success(msg){ 
			try{closeNewDiv_FnaBudgetViewInner1();}catch(ex1){}
			if(msg.flag){
				_fnaOpenDialog("/fna/maintenance/FnaWorkflowInfo.jsp?startDate="+startDate+"&endDate="+endDate, 
						"<%=SystemEnv.getHtmlLabelName(130119,user.getLanguage()) %>", 
						800, 600);
			}else{
				window._table.reLoad();
			}
		}
	});
	
	
}
</script>
</BODY>
</HTML>
<SCRIPT language="javascript" src="/js/datetime_wev8.js"></script>
<SCRIPT language="javascript" src="/js/JSDateTime/WdatePicker_wev8.js"></script>
<script type="text/javascript">
function _gdt(_i, _s, _f) {
	try {
		var returnValue = _gettheDate(_i, _s, _f);
	} catch(e){} 
}

function _gettheDate(inputname,spanname, _f){
	var evt = window.event;
    WdatePicker({lang:languageStr,
			el : spanname,
			onpicked : function(dp) {
				var returnvalue = dp.cal.getDateStr();
				$dp.$(inputname).value = returnvalue;
				try{
					if(jQuery("#"+inputname).val()==""){
						jQuery("#span_"+inputname).html("<img src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\">");
					}
				}catch(e){}
				if (!window.ActiveXObject) {
					//手动触发oninput事件
					checkinput(inputname, spanname + "img");
				}
				try {
					if (_f != undefined && _f != null && _f != "") {
						eval(_f + "($dp.$(inputname).value, evt)");	
					}
					
				} catch (e) {}
			},
			oncleared : function(dp) {
				$dp.$(inputname).value = '';
				try{
					if(jQuery("#"+inputname).val()==""){
						jQuery("#span_"+inputname).html("<img src=\"/images/BacoError_wev8.gif\" align=\"absMiddle\">");
					}
				}catch(e){}
				if (!window.ActiveXObject) {
					//手动触发oninput事件
					checkinput(inputname, spanname + "img");
				}
			}
	});
}
</script>

