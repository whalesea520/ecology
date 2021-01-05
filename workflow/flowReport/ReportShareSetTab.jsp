<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ taglib uri="/browser" prefix="brow"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSet1" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SubCategoryComInfo" class="weaver.docs.category.SubCategoryComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css" type="text/css" />
<link rel="stylesheet" href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
</HEAD>
<%
if(!HrmUserVarify.checkUserRight("REPORTSHARE:WORKFLOW", user))  {
        response.sendRedirect("/notice/noright.jsp") ;
	    return ;
}
String imagefilename = "/images/hdCRMAccount_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(19024,user.getLanguage())+"-"+SystemEnv.getHtmlLabelName(19025,user.getLanguage()) ;
int needchange=0;
String needfav ="1";
String needhelp ="";

String relatedshareid = Util.null2String(request.getParameter("relatedshareid")); 
String sharetype = Util.null2String(request.getParameter("sharetype")); 
String rolelevel = Util.null2String(request.getParameter("rolelevel")); 
String seclevel = Util.null2String(request.getParameter("seclevel"));
String sharelevel = Util.null2String(request.getParameter("sharelevel"));
String departmentids = Util.null2String(request.getParameter("departmentids"));
String muticompanyid = Util.null2String(request.getParameter("muticompanyid"));
String reportType= Util.null2String(request.getParameter("reportType"));
String typename = Util.null2String(request.getParameter("typename"));
String reportTypeIds = "";

String userid = "0" ;
String departmentid = "0" ;
String subcompanyid="0";
String roleid = "0" ;
String foralluser = "0" ;

if(!relatedshareid.startsWith(",")&&!sharetype.equals("4"))
	relatedshareid = ","+relatedshareid;
if(!relatedshareid.endsWith(",")&&!sharetype.equals("4"))
	relatedshareid = relatedshareid+",";
if(sharetype.equals("1")) userid = relatedshareid ;
if(sharetype.equals("3")) departmentid = relatedshareid ;
if(sharetype.equals("2")) subcompanyid = relatedshareid ;
if(sharetype.equals("4")) roleid = relatedshareid ;
if(sharetype.equals("5")) foralluser = "1" ;

if(!"".equals(typename)){
	if(SystemEnv.getHtmlLabelName(332,user.getLanguage()).indexOf(typename)>-1){
		if("".equals(reportTypeIds)){
			reportTypeIds = "0";
		}else{
			reportTypeIds += ",0";
		}
	}

	if(SystemEnv.getHtmlLabelName(19027,user.getLanguage()).indexOf(typename)>-1){
		if("".equals(reportTypeIds)){
			reportTypeIds = "-1";
		}else{
			reportTypeIds += ",-1";
		}
	}
	
	if(SystemEnv.getHtmlLabelName(19028,user.getLanguage()).indexOf(typename)>-1){
		if("".equals(reportTypeIds)){
			reportTypeIds = "-2";
		}else{
			reportTypeIds += ",-2";
		}
	}
	
	if(SystemEnv.getHtmlLabelName(19029,user.getLanguage()).indexOf(typename)>-1){
		if("".equals(reportTypeIds)){
			reportTypeIds = "-3";
		}else{
			reportTypeIds += ",-3";
		}
	}
	
	if(SystemEnv.getHtmlLabelName(19030,user.getLanguage()).indexOf(typename)>-1){
		if("".equals(reportTypeIds)){
			reportTypeIds = "-4";
		}else{
			reportTypeIds += ",-4";
		}
	}	
	
	if(SystemEnv.getHtmlLabelName(19031,user.getLanguage()).indexOf(typename)>-1){
		if("".equals(reportTypeIds)){
			reportTypeIds = "-5";
		}else{
			reportTypeIds += ",-5";
		}
	}	

	if(SystemEnv.getHtmlLabelName(19032,user.getLanguage()).indexOf(typename)>-1){
		if("".equals(reportTypeIds)){
			reportTypeIds = "-6";
		}else{
			reportTypeIds += ",-6";
		}
	}
	
	if(SystemEnv.getHtmlLabelName(19034,user.getLanguage()).indexOf(typename)>-1){
		if("".equals(reportTypeIds)){
			reportTypeIds = "-7";
		}else{
			reportTypeIds += ",-7";
		}
	}
	
	if(SystemEnv.getHtmlLabelName(19035,user.getLanguage()).indexOf(typename)>-1){
		if("".equals(reportTypeIds)){
			reportTypeIds = "-8";
		}else{
			reportTypeIds += ",-8";
		}
	}	
	
	if(SystemEnv.getHtmlLabelName(19036,user.getLanguage()).indexOf(typename)>-1){
		if("".equals(reportTypeIds)){
			reportTypeIds = "-9";
		}else{
			reportTypeIds += ",-9";
		}
	}

	if(SystemEnv.getHtmlLabelName(19037,user.getLanguage()).indexOf(typename)>-1){
		if("".equals(reportTypeIds)){
			reportTypeIds = "-10";
		}else{
			reportTypeIds += ",-10";
		}
	}	
	
	if(SystemEnv.getHtmlLabelName(21899,user.getLanguage()).indexOf(typename)>-1){
		if("".equals(reportTypeIds)){
			reportTypeIds = "-11";
		}else{
			reportTypeIds += ",-11";
		}
	}							

	if("".equals(reportTypeIds)){
		reportTypeIds = "-999";
	}

}

%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM name="frmSearch"  method="post">
<input type="hidden" name="pageId" id="pageId" value="<%= PageIdConst.WF_FLOWREPORT_REPORTSHARESETTAB %>"/>
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(83476,user.getLanguage()) %>" class="e8_btn_top" onclick="newDialog()"/>		
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(32136,user.getLanguage()) %>" class="e8_btn_top" onclick="deltype()"/>
			<input type="text" class="searchInput" name="flowTitle" value='<%=typename %>'/>
			<input type="hidden" name=typename  value='<%=typename %>'>
			<span id="advancedSearch" class="advancedSearch"><%=SystemEnv.getHtmlLabelName(21995,user.getLanguage()) %></span>
			<span title="<%=SystemEnv.getHtmlLabelName(81804,user.getLanguage()) %>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
		
<!-- bpf start 2013-10-29 -->
<div class="advancedSearchDiv" id="advancedSearchDiv">
<wea:layout type="fourCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(15774,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(15517,user.getLanguage())%></wea:item>
	    <wea:item>
			<select class=inputstyle  name=reportType style="width:200px;">
				<option value="" selected></option>	
				<option value="0"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
				<option value="-1"><%=SystemEnv.getHtmlLabelName(19027,user.getLanguage())%></option>
				<option value="-2"><%=SystemEnv.getHtmlLabelName(19028,user.getLanguage())%></option>
				<option value="-3" ><%=SystemEnv.getHtmlLabelName(19029,user.getLanguage())%></option>
				<option value="-4"><%=SystemEnv.getHtmlLabelName(19030,user.getLanguage())%></option>
				<option value="-5"><%=SystemEnv.getHtmlLabelName(19031,user.getLanguage())%></option>
				<option value="-6"><%=SystemEnv.getHtmlLabelName(19032,user.getLanguage())%></option>
				<option value="-7"><%=SystemEnv.getHtmlLabelName(19034,user.getLanguage())%></option>
				<option value="-8" ><%=SystemEnv.getHtmlLabelName(19035,user.getLanguage())%></option>
				<option value="-9"><%=SystemEnv.getHtmlLabelName(19036,user.getLanguage())%></option>
				<option value="-10"><%=SystemEnv.getHtmlLabelName(19037,user.getLanguage())%></option>
				<option value="-11"><%=SystemEnv.getHtmlLabelName(21899,user.getLanguage())%></option>				 
			</select>
	    </wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(19117,user.getLanguage()) %></wea:item>
    	<wea:item>
			<select class=inputstyle  name=sharetype onchange="onChangeSharetype()" style="float: left;">
				<option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
				<option value="3" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
				<option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
				<option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
				<option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
			</select>
			<span id="relatedshareSpan">
		  	<brow:browser name="relatedshareid" viewType="0" hasBrowser="true" hasAdd="false" 
				 	   getBrowserUrlFn="onChangeResource"
      				   isMustInput="1" isSingle="true" hasInput="true"
       			       completeUrl="javascript:getajaxurl()"  width="150px" browserValue="" browserSpanValue=""/>
       		</span>	
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
    	<wea:item>
			<span id=showrolelevel name=showrolelevel style="display:none">
				<select class=inputstyle  name="rolelevel" >
				  <option value="0"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
				  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
				  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
				</select>
			</span>    	
    	</wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
    	<wea:item><input type=text class="InputStyle" name=seclevel size=6 value=""></wea:item>
    	<wea:item><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())+SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
    	<wea:item>
			<select class=inputstyle  name=sharelevel onchange="onChangeShareLevel()" style="float: left;">
				<option value="" selected></option>
				<option value="0"><%=SystemEnv.getHtmlLabelName(18511,user.getLanguage())%></option>
				<option value="1"><%=SystemEnv.getHtmlLabelName(18512,user.getLanguage())%></option>
				<option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
				<option value="3"><%=SystemEnv.getHtmlLabelName(18513,user.getLanguage())%></option>
				<option value="4"><%=SystemEnv.getHtmlLabelName(25512,user.getLanguage())%></option>
				<option value="9"><%=SystemEnv.getHtmlLabelName(17006,user.getLanguage())%></option>
			</select>
			<span id="departmentidsDivSpan" style="display:none;height:118px;">
			<brow:browser   name="departmentids" viewType="0" hasBrowser="true" hasAdd="false" 
					        getBrowserUrlFn="onShowMutiDepartment"
							isMustInput="1" isSingle="false" hasInput="true"
							completeUrl="javascript:getajaxurl2()"  width="150px" browserValue="" browserSpanValue=""/>	
			</span>  
			<span id="muticompanyidDivSpan" style="display:none;height:118px;">
				<brow:browser  name="muticompanyid" viewType="0" hasBrowser="true" hasAdd="false" 
						getBrowserUrlFn="onShowMutiSubcompany"
						isMustInput="1" isSingle="false" hasInput="true"
						completeUrl="javascript:getajaxurl3()"  width="150px" browserValue="" browserSpanValue=""/>	
			</span>     	
    	</wea:item>
    	<wea:item> </wea:item>
    </wea:group>
    <wea:group context="">
    	<wea:item type="toolbar">
    		<input class="e8_btn_submit" type="submit" name="submit2" value="<%=SystemEnv.getHtmlLabelName(197,user.getLanguage())%>"/>
    		<input class="e8_btn_cancel" type="reset" name="reset" value="<%=SystemEnv.getHtmlLabelName(2022,user.getLanguage())%>"/>
    		<input class="e8_btn_cancel" type="button" id="cancel" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage())%>"/>
    	</wea:item>
    </wea:group>
</wea:layout>	
</div> 

<%
String sqlWhere ="";
if(!"".equals(reportType)){
	if("0".equals(reportType)){
		if("".equals(sqlWhere)){
			sqlWhere = " where reportid in (0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11) ";
		}else{
			sqlWhere += " and reportid in (0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11) ";
		}
	}else{
		if("".equals(sqlWhere)){
			sqlWhere = " where reportid ="+reportType;
		}else{
			sqlWhere += " and reportid ="+reportType;
		}
	}
}

if(!"".equals(reportTypeIds)){
		if("".equals(sqlWhere)){
			sqlWhere = " where reportid in ("+reportTypeIds+")";
		}else{
			sqlWhere = " and reportid in ("+reportTypeIds+")";
		}
}

if(!"".equals(sharetype)){
	if("".equals(sqlWhere)){
		sqlWhere = " where sharetype ="+sharetype;
	}else{
		sqlWhere += " and sharetype ="+sharetype;
	}
	
	if(!"".equals(relatedshareid)){
		if("1".equals(sharetype) && !"0".equals(userid)){
			sqlWhere += " and userid like '%"+userid+"%'";
		}else if("3".equals(sharetype) && !"0".equals(departmentid)){
			sqlWhere += " and departmentid like '%"+departmentid+"%'";
		}else if("2".equals(sharetype) && !"0".equals(subcompanyid)){
			sqlWhere += " and subcompanyid like '%"+subcompanyid+"%'";
		}else if("4".equals(sharetype) && !"0".equals(roleid)){
			sqlWhere += " and roleid ="+roleid;
		}else if("5".equals(sharetype) && !"0".equals(foralluser)){
			sqlWhere += " and foralluser ="+foralluser;
		}
	}

	if(!"".equals(rolelevel)){
		sqlWhere += " and rolelevel ="+rolelevel;
	}
}

if(!"".equals(sharelevel)){
	if("".equals(sqlWhere)){
		sqlWhere = " where sharelevel ="+sharelevel;
	}else{
		sqlWhere += " and sharelevel ="+sharelevel;
	}
	
	if(!"".equals(departmentids)){
		sqlWhere += " and mutidepartmentid like '%"+departmentids+"%'";
	}
	if(!"".equals(muticompanyid)){
		sqlWhere += " and mutidepartmentid like '%"+muticompanyid+"%'";
	}
}

if(!"".equals(seclevel)){
	if("".equals(sqlWhere)){
		sqlWhere = " where seclevel <="+seclevel;
		sqlWhere = " where seclevel2 >="+seclevel;
		
	}else{
		sqlWhere += " and seclevel <="+seclevel;
		sqlWhere += " and seclevel2 >="+seclevel;
	}
}
if("".equals(sqlWhere)){
	sqlWhere = " where reportid in (0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11) ";
}else{
	sqlWhere += " and reportid in (0,-1,-2,-3,-4,-5,-6,-7,-8,-9,-10,-11) ";
}

String orderby =" reportid ";
String tableString = "";
int perpage=10;                                 
String backfields = " id,reportid,sharetype,seclevel,seclevel2,rolelevel,sharelevel,userid,subcompanyid,departmentid,roleid,foralluser,crmid,mutidepartmentid";
String fromSql  = " WorkflowReportShare ";
String para1 = "column:userid+column:subcompanyid+column:departmentid+column:roleid+column:rolelevel+"+user.getLanguage()+"+column:seclevel";
tableString =   " <table instanceid=\"workflowTypeListTable\" tabletype=\"checkbox\" pagesize=\""+PageIdConst.getPageSize(PageIdConst.WF_FLOWREPORT_REPORTSHARESETTAB,user.getUID())+"\" >"+
                "       <sql backfields=\""+backfields+"\" sqlform=\""+fromSql+"\" sqlwhere=\""+Util.toHtmlForSplitPage(sqlWhere)+"\"  sqlorderby=\""+orderby+"\"  sqlprimarykey=\"id\" sqlsortway=\"ASC\" sqlisdistinct=\"true\" />"+
                "       <head>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(15517,user.getLanguage())+"\" column=\"reportid\" otherpara=\""+user.getLanguage()+"\" orderkey=\"reportid\" transmethod=\"weaver.workflow.report.ReportShare.getReportName\"/>"+
                "           <col width=\"0%\"  text=\""+SystemEnv.getHtmlLabelName(15101, user.getLanguage())+"id"+"\" column=\"reportid\" hide=\"true\" orderkey=\"reportid\" />"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(125097,user.getLanguage())+"\" column=\"sharetype\" orderkey=\"sharetype\" otherpara=\""+user.getLanguage()+"\" transmethod=\"weaver.workflow.report.ReportShare.getShareTypeName\"/>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(19117,user.getLanguage())+"\" column=\"sharetype\" orderkey=\"sharetype\" otherpara=\""+para1+"\" transmethod=\"weaver.workflow.report.ReportShare.getShareObj\"/>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(683,user.getLanguage())+"\" column=\"seclevel\" otherpara=\"column:seclevel2+column:sharetype\" orderkey=\"seclevel\" transmethod=\"weaver.workflow.report.ReportShare.getSeclevel\"/>"+
                "           <col width=\"20%\"  text=\""+SystemEnv.getHtmlLabelName(3005,user.getLanguage())+"\" column=\"sharelevel\" orderkey=\"sharelevel\" otherpara=\"column:mutidepartmentid+"+user.getLanguage()+"\" transmethod=\"weaver.workflow.report.ReportShare.getFlowReportLevel\"/>"+
                "       </head>"+
				"<operates>"+
				"<operate href=\"javascript:onDel();\" otherpara=\"column:reportid\" text=\""+SystemEnv.getHtmlLabelName(23777,user.getLanguage())+"\" target=\"_self\" index=\"1\"/>"+
				"</operates>"+                
                " </table>";
%>

<TABLE width="100%" cellspacing=0>
    <tr>
        <td valign="top">  
            <wea:SplitPageTag  tableString='<%=tableString%>'  mode="run" />
        </td>
    </tr>
</TABLE>


</td>
</tr>
</TABLE>
</FORM>
<script language=javascript>
function onChangeResource(){
	var tmpval = $("select[name=sharetype]").val();
	var inputename = "relatedshareid";
	var tdname = "relatedshareidspan";
	var url = "";
	if (tmpval == "1") {
		url = onShowResource(tdname,inputename);
	}else if(tmpval=="3"){
		url = onShowDepartment(tdname,inputename);
	}else if(tmpval=="2"){
		url = onShowSubcompany(tdname,inputename);
	}else if(tmpval=="4"){
		url = onShowRole(tdname,inputename);
	}else if(tmpval=="5"){
		$("select[name=sharetype]").parent().find(".e8_os").hide();
	}
	return url;
}
function getajaxurl() {
	var tmpval = $("select[name=sharetype]").val();
	var url = "";	
	if (tmpval == "1") {
		url = "/data.jsp";
	}else if (tmpval == "3") {
		url = "/data.jsp?type=4";
	}else if (tmpval == "2") {
		url = "/data.jsp?type=164";
	}else if (tmpval == "4") {
		url = "/data.jsp?type=65";
	}		
	return url;
}
function getajaxurl2() {
	var url = "/data.jsp?type=4";	
	return url;
}

function getajaxurl3() {
	var url = "/data.jsp?type=164";	
	return url;
}
function doSave(obj) {
	thisvalue=document.weaver.sharetype.value;
	levelsvalue=$G("sharelevel").value;
	var checkstr="";
	if (thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4){
	        if(levelsvalue==9){
	           checkstr="relatedshareid,departmentids";
	        }else{
	            checkstr="relatedshareid";
	        }
	}

	if(check_form(document.weaver,checkstr)){
	document.weaver.submit();
	obj.disabled=true;
	}
}

//function onChangeSharetype(){	
//	var tmpval = $("select[name=sharetype]").val();
//	$("select[name=sharetype]").parent().find(".e8_os").show();
//	$("#showrolelevel").hide();
//	$("#relatedshareidspan").html("");
//	$("#relatedshareid").val("");
//	if(tmpval=="5"){
//		$("select[name=sharetype]").parent().find(".e8_os").hide();
//		$("#relatedshareid").val("-1");
//	}else if(tmpval=="4"){
//		$("#showrolelevel").show();
//	}
//}

function onChangeSharetype(){
	var tmpval = $("select[name=sharetype]").val();
	//$("div[class=e8_os]").show();
	$("#relatedshareSpan").css("display","inline-block");
	//$("div[class=e8_os]").parent().find("img").show();
	//jQuery("#relatedshareidspanimg").html("<img align=\"absmiddle\" src=\"/images/BacoError_wev8.gif\">");
	//hideEle("showrolelevel");
	jQuery("#showrolelevel").css("display","none");
	$("#relatedshareidspan").html("");
	$("#relatedshareid").val("");
	if(tmpval=="5"){
		$("#relatedshareSpan").css("display","none");
		//jQuery("#relatedshareidspanimg").html("");
		//$("div[class=e8_os]").parent().find("img").hide();
		$("#relatedshareid").val("");
	}else if(tmpval=="4"){
		//showEle("showrolelevel");
		jQuery("#showrolelevel").css("display","block");
	}
}

function onChangeShareLevel(){
	var thisvalue=$("select[name=sharelevel]").val();
	$("#departmentids").val("");
	$("#departmentidsspan").html("");

	if(thisvalue==9){
		$("#departmentidsDivSpan").show();
    }else{
    	$("#departmentids").val("");
		$("#departmentidsspan").html("");
		$("#departmentidsDivSpan").hide();
    }
    if(thisvalue==4){
		$("#muticompanyidDivSpan").show();
    }else{
    	$("#muticompanyid").val("");
		$("#muticompanyidspan").html("");
		$("#muticompanyidDivSpan").hide();
    }
}

//function onChangeShareLevel(){
//	var thisvalue=$("select[name=sharelevel]").val();
//	$("#departmentids").val("");
//	$("#departmentidspan").html("");

//	if(thisvalue==9){
//		$("#departmentidsDivSpan").show();
//    }else{
//		$("#departmentidsDivSpan").hide();
//    }
//}

function disModalDialog(url, spanobj, inputobj, need, curl) {
	var id = window.showModalDialog(url, "",
			"dialogWidth:550px;dialogHeight:550px;" + "dialogTop:" + (window.screen.availHeight - 30 - parseInt(550))/2 + "px" + ";dialogLeft:" + (window.screen.availWidth - 10 - parseInt(550))/2 + "px" + ";");
	if (id != null) {
		var rid = wuiUtil.getJsonValueByIndex(id, 0);
		var rname = wuiUtil.getJsonValueByIndex(id, 1);
		
		if (rid != "") {
			if (rid.indexOf(",") == 0) {
				rid = rid.substr(1);
				rname = rname.substr(1);
			}
			curl = "#";
			if (curl != undefined && curl != null && curl != "") {
				spanobj.html("<a href='" + curl+ rid + "'>"+ rname + "</a>");
			} else {
				spanobj.html(rname);
			}
			inputobj.val(rid);
		} else {
			spanobj.html(need ? "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>" : "");
			inputobj.val("");
		}
	}
}


function onShowDepartment() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=" +jQuery("#relatedshareid").val();
	return url;
}

function onShowMutiDepartment() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" +jQuery("#departmentids").val();
	//disModalDialog(url,$("#"+tdname), $("#"+inputename), true);
	return url;
}

function onShowSubcompany() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=" +jQuery("#relatedshareid").val();
	//disModalDialog(url, $("#"+tdname), $("#"+inputename), true);
	return url;
}
function onShowResource() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp?resourceids="+jQuery("#relatedshareid").val();
	return url;
}
function onShowMutiSubcompany() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="+jQuery("#muticompanyid").val();
	return url;
}

function onShowRole(tdname,inputename) {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp";
	return url;
}

function submitData()
{
	if (check_form(weaver,'PrjName,PrjType,WorkType,hrmids02,SecuLevel,PrjManager,PrjDept'))
		weaver.submit();
}
</script>
</BODY>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDialog_wev8.js"></script>
<script language="javascript" src="/wui/theme/ecology8/jquery/js/zDrag_wev8.js"></script>
<script type="text/javascript">
var diag_vote;
jQuery(document).ready(function () {
	$("#topTitle").topMenuTitle({searchFn:onBtnSearchClick});
	$(".topMenuTitle td:eq(0)").html($("#tabDiv").html());
	$("#tabDiv").remove();		
});

function onBtnSearchClick(){
	var typename=$("input[name='flowTitle']").val();
	try{
		typename = encodeURI(typename);
	}catch(e){
		if(window.console)console.log(e)
	 }
	$("input[name='typename']").val(typename);
	
	window.location="/workflow/flowReport/ReportShareSetTab.jsp?typename="+typename;
}

function newDialog(){
	diag_vote = new window.top.Dialog();
	diag_vote.currentWindow = window;
	diag_vote.Width = 500;
	diag_vote.Height = 350;
	diag_vote.Modal = true;
	diag_vote.Title = "<%=SystemEnv.getHtmlLabelName(611,user.getLanguage())%>" + "<%=SystemEnv.getHtmlLabelName(33666,user.getLanguage())%>";
	diag_vote.URL = "/workflow/flowReport/ReportShareSetAdd.jsp?dialog=1";
	diag_vote.isIframe=false;
	diag_vote.show();
}

function closeDialog(){
	diag_vote.close();
}
		
function deltype(){
	var typeids = "";
	var reportids = "";
	$("input[name='chkInTableTag']").each(function(){
		if($(this).attr("checked")){		
			typeids = typeids +$(this).attr("checkboxId")+",";
			reportids = reportids + jQuery(this).parent().parent().parent().find("td").eq(2).text()+",";
		}
	});
	if(typeids==""){
		top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(20149,user.getLanguage())%>");
		return ;
	}
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function (){
						window.location="/workflow/flowReport/ReportShareOperation.jsp?method=deleteAll&ids="+typeids+"&reportid="+reportids;
	}, function () {}, 320, 90,true);
}

function onDel(id,reportid){
	top.Dialog.confirm("<%=SystemEnv.getHtmlLabelName(15097,user.getLanguage())%>", function(){
						window.location="/workflow/flowReport/ReportShareOperation.jsp?method=delete&id="+id+"&reportid="+reportid;
				}, function () {}, 320, 90,true);
}	
</script>
</HTML>
