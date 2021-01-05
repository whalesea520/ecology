<!DOCTYPE html>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browser" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
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
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.bgiframe.min_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/lib/jquery.ajaxQueue_wev8.js'></script>
<script type='text/javascript' src='/js/jquery-autocomplete/jquery.autocomplete_wev8.js'></script>
<link href="/js/checkbox/jquery.tzCheckbox_wev8.css" type=text/css rel=STYLESHEET>
<script language=javascript src="/js/checkbox/jquery.tzCheckbox_wev8.js"></script>
<script type='text/javascript' src='/js/jquery-autocomplete/browser_wev8.js'></script>
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/jquery.autocomplete_wev8.css" />
<link rel="stylesheet" type="text/css" href="/js/jquery-autocomplete/browser_wev8.css" />
</HEAD>
<%
if(!HrmUserVarify.checkUserRight("WorkflowReportManage:All", user))  {
        response.sendRedirect("/notice/noright.jsp") ;
	    return ;
    }
String imagefilename = "/images/hdCRMAccount_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(81560,user.getLanguage())+
"-"+SystemEnv.getHtmlLabelName(19025,user.getLanguage()) ;
int needchange=0;
String needfav ="1";
String needhelp ="";

int id = Util.getIntValue(request.getParameter("id"),0);
String dialog = Util.null2String(request.getParameter("dialog"));
String isclose = Util.null2String(request.getParameter("isclose"));
String isBill = Util.null2String(request.getParameter("isBill"));
String formID = Util.null2String(request.getParameter("formID"));
%>
<BODY style="overflow:hidden;">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_self} " ;
RCMenuHeight += RCMenuHeightStep;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:btn_cancle(),_self} " ;
RCMenuHeight += RCMenuHeightStep;

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<%if("1".equals(dialog)){ %>
<div class="zDialog_div_content">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="workflow"/>
   <jsp:param name="navName" value="<%=titlename %>"/>
</jsp:include>
<%}%>
<FORM id=weaver name=weaver action="ReportShareOperation.jsp" method=post onsubmit='return check_form(this,"")'>
<input type="hidden" name="method" value="add">
<input type="hidden" name="reportid" value="<%=id%>">
<input type="hidden" name="dialog" value="<%=dialog%>">
<input type="hidden" name="isBill" value="<%=isBill%>">
<input type="hidden" name="formID" value="<%=formID%>">
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td></td>
		<td class="rightSearchSpan" style="text-align:right; width:500px!important">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" id="zd_btn_submit" class="e8_btn_top" onclick="doSave(this)">
	    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(201,user.getLanguage()) %>" id="zd_btn_cancle"  class="e8_btn_top" onclick="btn_cancle()">				
			<span title="<%=SystemEnv.getHtmlLabelName(83721,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>
<wea:layout type="twoCol">
    <wea:group context='<%=SystemEnv.getHtmlLabelName(2112,user.getLanguage())%>'>
    	<wea:item><%=SystemEnv.getHtmlLabelName(33234,user.getLanguage())%></wea:item>
	    <wea:item>
			<select class=inputstyle  name=sharetype onchange="onChangeSharetype()" style="float:left;width: 120px;">
				<option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
				<option value="3" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
				<option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
				<option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
				<option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
				<option value="6"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
			</select>
	    </wea:item>
	    <wea:item><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
	    <wea:item>
	    	<span id="relatedshareSpan">
			<brow:browser name="relatedshareid" viewType="0" hasBrowser="true" hasAdd="false" 
		 	   		   getBrowserUrlFn="onChangeResource"
    				   isMustInput="2" isSingle="false" hasInput="true"
     				   completeUrl="javascript:getajaxurl()"  width="150px" browserValue="" browserSpanValue=""/>
     		</span>
	    </wea:item>
	    <wea:item attributes="{'samePair':'showrolelevel','display':'none'}"><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
	    <wea:item attributes="{'samePair':'showrolelevel','display':'none'}">
	    	<select class=inputstyle  name=rolelevel  style="float:left;width: 120px;">
				<option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
				<option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
				<option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
			</select>
	    </wea:item>
    	<wea:item attributes="{'samePair':'showlevel','display':''}"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
    	<wea:item attributes="{'samePair':'showlevel','display':''}">
			<span id=showseclevel name=showseclevel>									
				<input type=text class="InputStyle" name=seclevel size=3 value="0" onchange='checkinputseclevel()' style="width: 30px;">
				-
				<input type=text class="InputStyle" name=seclevel2 size=3 value="100" onchange='checkinputseclevel()' style="width: 30px;">
			</span>
			<span id=seclevelimage></span>
    	</wea:item>
    	<!--  -->
    	<wea:item attributes="{'samePair':'showjob','display':'none'}">
			<%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())+SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
 				</wea:item>
		<wea:item attributes="{'samePair':'showjob','display':'none'}">
			<select class=inputstyle  name=joblevel onchange="onChangeJobtype()" style="float:left;">
				<option value=0 ><%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())+SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
				<option value=1 ><%=SystemEnv.getHtmlLabelName(17908,user.getLanguage())+SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
				<option value=2 selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
			</select>
			<span id="relatedshareSpan_6" style="float:left;display:none;">
				<brow:browser name="relatedshareid_6" viewType="0" hasBrowser="true" hasAdd="false" 
			 	   		   getBrowserUrlFn="onChangeResourceForJob" 
	    				   isMustInput="2" isSingle="false" hasInput="true" 
	     				   completeUrl="javascript:getjobajaxurl()"  width="150px" browserValue="" browserSpanValue=""/>
	     	</span>
		</wea:item>
    	<!--  -->
    	<wea:item><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())+SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
    	<wea:item>
			<select class=inputstyle  name=sharelevel onchange="onChangeShareLevel()" style="float:left;width: 120px;">
				<option value="0" selected><%=SystemEnv.getHtmlLabelName(18511,user.getLanguage())%></option><!-- 同部门 -->
				<option value="1"><%=SystemEnv.getHtmlLabelName(18512,user.getLanguage())%></option><!-- 同分部 -->
				<option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option><!-- 总部 -->
				<option value="3"><%=SystemEnv.getHtmlLabelName(130507,user.getLanguage())%></option><!-- 同部门下级部门 -->
				<option value="4"><%=SystemEnv.getHtmlLabelName(6087,user.getLanguage())%></option><!-- 个人 -->
				<option value="5"><%=SystemEnv.getHtmlLabelName(25512,user.getLanguage())%></option><!-- 多分部 -->
				<option value="9"><%=SystemEnv.getHtmlLabelName(17006,user.getLanguage())%></option><!-- 多部门 -->
			</select>
		    <span id="departmentidsDivSpan" style="display:none;height:118px;">
			<brow:browser   name="departmentids" viewType="0" hasBrowser="true" hasAdd="false" 
							getBrowserUrlFn="onShowMutiDepartment"
							isMustInput="2" isSingle="false" hasInput="true"
							completeUrl="javascript:getajaxurl2()"  width="150px" browserValue="" browserSpanValue=""/>	
			</span> 
			<span id="muticompanyidDivSpan" style="display:none;height:118px;">
			<brow:browser   name="muticompanyid" viewType="0" hasBrowser="true" hasAdd="false" 
							getBrowserUrlFn="onShowMutiSubcompany"
							isMustInput="2" isSingle="false" hasInput="true"
							completeUrl="javascript:getajaxurl3()"  width="150px" browserValue="" browserSpanValue=""/>	
			</span>   	
			
    	</wea:item>
    	<wea:item>
    	<%=SystemEnv.getHtmlLabelName(21225,user.getLanguage())%>
    	</wea:item>
    	<wea:item>
    	  <INPUT type="checkbox" tzCheckbox="true" class=InputStyle name="allowlook" value="1" >
    	</wea:item>
    </wea:group>
</wea:layout>
</FORM>
 <%if("1".equals(dialog)){ %>
 <jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
</div>
<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes='{\"groupDisplay\":\"none\"}'>
			<wea:item type="toolbar">
		    	<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="dialog.closeByHand()">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<%} %>
<script type="text/javascript">
jQuery(document).ready(function(){
 jQuery("input[type=checkbox]").each(function(){
  if(jQuery(this).attr("tzCheckbox")=="true"){
   jQuery(this).tzCheckbox({labels:['','']});
  }
 });
});
var dialog = parent.getDialog(window);
var parentWin = parent.getParentWindow(window);
function onChangeResource(){
	var tmpval = $("select[name=sharetype]").val();
	var url = "";
	if (tmpval == "1") {
		url = onShowMutiResource();
	}else if(tmpval=="3"){
		url = onShowMutiDepartment();
	}else if(tmpval=="2"){
	    url = onShowMutiSubcompany('obj');
	}else if(tmpval=="4"){
		url = onShowRole();
	}else if(tmpval=="5"){
		$("select[name=sharetype]").parent().find(".e8_os").hide();
	}else if(tmpval=="6"){
		url = onShowJob();
	}
	return url;
}

function getjobajaxurl(){
	var tmpval = jQuery("select[name=joblevel").val();
	var url = "";	
	if (tmpval == "0") {
		url = "/data.jsp?type=4";
	}else if (tmpval == "1") {
		url = "/data.jsp?type=194";
	}	
	return url;
}

function onChangeResourceForJob(){
	var tmpval = jQuery("select[name=joblevel]").val();
	var url = "";
	if (tmpval == "0") {
		//url = onShowMutiDepartment(obj);
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+jQuery("#relatedshareid_6").val();
	}else if(tmpval=="1"){
	    //url = onShowMutiSubcompany(obj);
	    url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="+jQuery("#relatedshareid_6").val();
	}else if(tmpval=="2"){
		jQuery("select[name=joblevel]").parent().find(".e8_os").hide();
	}
	return url;
}

function onChangeJobtype(){
	var tmpval = jQuery("select[name=joblevel]").val();
	jQuery("#relatedshareSpan_6").show();
	jQuery("#relatedshareid_6span").html("");
	jQuery("#relatedshareid_6").val("");
	jQuery("#relatedshareid_6spanimg").html("<img align=\"absmiddle\" src=\"/images/BacoError_wev8.gif\">");
	if(tmpval=="2"){
		jQuery("#relatedshareSpan_6").hide();
		jQuery("#relatedshareid_6").val("");
	}
}

function getajaxurl() {
	var tmpval = $("select[name=sharetype]").val();
	var url = "";	
	if (tmpval == "1") {
		url = "/data.jsp";
	}else if (tmpval == "3") {
		url = "/data.jsp?type=4";
	}else if (tmpval == "2") {
		url = "/data.jsp?type=194";
	}else if (tmpval == "4") {
		url = "/data.jsp?type=65";
	}else if (tmpval == "6") {
		url = "/data.jsp?type=24";
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

function btn_cancle(){
	parentWin.closeDialog();
}
if("<%=isclose%>"==1){
	var dialog = parent.getDialog(window);
	var parentWin = parent.getParentWindow(window);
	parentWin.location="ReportShare.jsp?id=<%=id%>&isBill=<%=isBill%>&formID=<%=formID%>";
	parentWin.closeDialog();	
}
function doSave(obj) {
	thisvalue=document.weaver.sharetype.value;
	levelsvalue=$G("sharelevel").value;
	var checkstr="seclevel,seclevel2";
	if (thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4){
        if(levelsvalue==9){
           checkstr+=",relatedshareid,departmentids";
        }else if(levelsvalue==5){
        	checkstr+=",relatedshareid,muticompanyid";
        }else{
            checkstr+=",relatedshareid";
        }
	}else if(thisvalue==6){
		var joblevel = jQuery("select[name=joblevel]").val();
		if(joblevel == 2){
			if(levelsvalue==9){
	        	checkstr="relatedshareid,departmentids";
	        }else if(levelsvalue==5){
	        	checkstr="relatedshareid,muticompanyid";
	        }else{
	            checkstr="relatedshareid";
	        }
		}else{
			if(levelsvalue==9){
	        	checkstr="relatedshareid,relatedshareid_6,departmentids";
	        }else if(levelsvalue==5){
	        	checkstr="relatedshareid,relatedshareid_6,muticompanyid";
	        }else{
	            checkstr="relatedshareid,relatedshareid_6";
	        }
		}
	}
	
	if(check_form(document.weaver,checkstr)){
		document.weaver.submit();
		obj.disabled=true;
		document.getElementById("zd_btn_cancle").disabled=true;
	}
}

function onChangeSharetype(){
	var tmpval = $("select[name=sharetype]").val();
	//$("div[class=e8_os]").show();
	$("#relatedshareSpan").css("display","inline-block");
	//$("div[class=e8_os]").parent().find("img").show();
	jQuery("#relatedshareidspanimg").html("<img align=\"absmiddle\" src=\"/images/BacoError_wev8.gif\">");
	jQuery("#relatedshareid_6spanimg").html("<img align=\"absmiddle\" src=\"/images/BacoError_wev8.gif\">");
	showEle("showlevel");
	hideEle("showrolelevel");
	hideEle("showjob");
	$("#relatedshareidspan").html("");
	$("#relatedshareid").val("");
	$("#relatedshareid_6span").html("");
	$("#relatedshareid_6").val("");
	if(tmpval=="5"){
		$("#relatedshareSpan").css("display","none");
		jQuery("#relatedshareidspanimg").html("");
		//$("div[class=e8_os]").parent().find("img").hide();
		$("#relatedshareid").val("");
	}else if(tmpval=="4"){
		showEle("showrolelevel");
	}else if(tmpval=="6"){
		hideEle("showlevel");
		showEle("showjob");
	}else if(tmpval == "1"){
		hideEle("showlevel");
	}
}

function onChangeShareLevel(){
	var thisvalue=$("select[name=sharelevel]").val();
	jQuery("#departmentids").val("");
	jQuery("#departmentidsspan").html("");
	jQuery("#departmentidsspanimg").html("<img align=\"absmiddle\" src=\"/images/BacoError_wev8.gif\">");
	
	jQuery("#muticompanyid").val("");
	jQuery("#muticompanyidspan").html("");
	jQuery("#muticompanyidspanimg").html("<img align=\"absmiddle\" src=\"/images/BacoError_wev8.gif\">");

	if(thisvalue==9){
		$("#departmentidsDivSpan").show();
    }else{
		$("#departmentids").val("");
		$("#departmentidsspan").html("");
		$("#departmentidsDivSpan").hide();
    }
    if(thisvalue==5){
		$("#muticompanyidDivSpan").show();
    }else{
		$("#muticompanyid").val("");
		$("#muticompanyidspan").html("");
		$("#muticompanyidDivSpan").hide();
    }
}

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

function onShowMutiDepartment() {
	var thisvalue=$("select[name=sharelevel]").val();
	var url = "";
	if(thisvalue == 9){
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+jQuery("#departmentids").val();
	}else{
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+jQuery("#relatedshareid").val();
	}
	return url;
}

function onShowMutiSubcompany(obj) {
	if(obj){
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="+jQuery("#relatedshareid").val();
	}else{
		url = "/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="+jQuery("#muticompanyid").val();
	}
	return url;
}
function onShowMutiResource() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+jQuery("#relatedshareid").val();
	return url;
}
function onShowRole() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp";
	return url;
}
function onShowJob() {
	var url = "/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?selectedids="+jQuery("#relatedshareid").val();
	return url;
}

$("#zd_btn_submit").hover(function(){
	$(this).addClass("zd_btn_submit_hover");
},function(){
	$(this).removeClass("zd_btn_submit_hover");
});

$("#zd_btn_cancle").hover(function(){
	$(this).addClass("zd_btn_cancleHover");
},function(){
	$(this).removeClass("zd_btn_cancleHover");
});	

function checkinputseclevel(){
    var tmpvalue = $GetEle("seclevel").value;
    var tmpvalue2 = $GetEle("seclevel2").value;
    
    while(tmpvalue.indexOf(" ") >= 0){
        tmpvalue = tmpvalue.replace(" ", "");
    }
    while(tmpvalue2.indexOf(" ") >= 0){
        tmpvalue2 = tmpvalue2.replace(" ", "");
    }
    
    if(tmpvalue != "" && tmpvalue2 != "" ){
        while(tmpvalue.indexOf("\r\n") >= 0){
            tmpvalue = tmpvalue.replace("\r\n", "");
        }
        while(tmpvalue2.indexOf("\r\n") >= 0){
            tmpvalue2 = tmpvalue2.replace("\r\n", "");
        }
        if(tmpvalue != "" && tmpvalue2 !=""){
            $GetEle("seclevelimage").innerHTML = "";
        }else{
            $GetEle("seclevelimage").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
        }
    }else{
        $GetEle("seclevelimage").innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
    }
}

</script>
</BODY>
</HTML>
