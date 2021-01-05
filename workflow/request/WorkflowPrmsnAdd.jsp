
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="Util" class="weaver.general.Util" scope="page" />
<jsp:useBean id="ResourceComInfo"
	class="weaver.hrm.resource.ResourceComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo"
	class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="CheckSubCompanyRight"
	class="weaver.systeminfo.systemright.CheckSubCompanyRight" scope="page" />
<%
	String dialog = "1";
	String isclose = Util.null2String(request.getParameter("isclose"));
	String wfid = Util.null2String(request.getParameter("wfid"));
	String requestid = Util.null2String(request.getParameter("requestid"));
	String currentnodeid = Util.null2String(request.getParameter("currentnodeid"));
	String f_weaver_belongto_userid=request.getParameter("f_weaver_belongto_userid");//需要增加的代码
	String f_weaver_belongto_usertype=request.getParameter("f_weaver_belongto_usertype");//需要增加的代码
	user = HrmUserVarify.getUser(request, response, f_weaver_belongto_userid, f_weaver_belongto_usertype) ;//需要增加的代码
	int userid=user.getUID();  
%>
<html>
	<head>
		<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
		<link rel="stylesheet" href="/css/ecology8/request/requestTopMenu_wev8.css"
			type="text/css" />
		<link rel="stylesheet"
			href="/wui/theme/ecology8/jquery/js/zDialog_e8_wev8.css" type="text/css" />
		<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css"
			type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</head>
	<%
		String imagefilename = "/images/hdMaintenance_wev8.gif";
		String titlename = SystemEnv.getHtmlLabelName(780, user
				.getLanguage());
		String needfav = "1";
		String needhelp = "";
	%>
	<BODY style="overflow: hidden;">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
					+ ",javascript:saveData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
			
			RCMenu += "{" + SystemEnv.getHtmlLabelName(309, user.getLanguage())
					+ ",javascript:btn_cancle(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
			   <td>
				</td>
				<td class="rightSearchSpan" style="text-align:right; ">
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="saveData()">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
				</td>
			</tr>
		</table>
		<div id="tabDiv" >
			<span id="hoverBtnSpan" class="hoverBtnSpan">
					<span></span>
			</span>
		</div>
		<div class="advancedSearchDiv" id="advancedSearchDiv">
		</div>
		<%
			if ("1".equals(dialog)) {
		%>
		<div class="zDialog_div_content">
			<%
				}
			%>
			<FORM id=weaverA name=weaverA action="WorkflowPrmOperation.jsp" method="post">
				<input type="hidden" value="false" name="hasChanged" id="hasChanged" />
				<input class=inputstyle type="hidden" name="method" id="method" value="prmAdd" />
				<input type="hidden" value="<%=dialog%>" name="dialog" id="dialog" />
				<input type="hidden" value="" name="forwd" id="forwd" />
				<input type="hidden" value="<%=wfid %>" name="wfid" id="wfid" />
				<input type="hidden" value="<%=requestid %>" name="requestid" id="requestid" />
				<input type="hidden" value="<%=currentnodeid %>" name="currentnodeid" id="currentnodeid" />
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
						<!-- 对象 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(21956, user.getLanguage())%></wea:item>
						<wea:item>
							<SELECT style="width:100px;" class="InputStyle" name="permissiontype" id="permissiontype" onchange="onChangePermissionType()" style="float:left">
							  <option selected value="1"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
							  <option value="6"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
							  <option value="3"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option><!-- 所有人 -->
							  <option value="5"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option><!-- 人力资源 -->
							  <option value="2"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option><!-- 角色 -->
							  <option value="7"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option><!-- 岗位 -->
							</SELECT>
						</wea:item>
						<wea:item attributes="{'samePair':\"objtr\"}" ><%=SystemEnv.getHtmlLabelName(106, user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':\"objtr\"}" >	
							<span id="subidsSP" style="float:left;">
							<brow:browser viewType="0" name="subids" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
							browserSpanValue=""></brow:browser>
							</span>
							
							<span id="departmentidSP" style="float:left;">
							<brow:browser viewType="0" name="departmentid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
							browserSpanValue=""></brow:browser>
							</span>
							
							<span id="useridSP" style="float:left;">
							<brow:browser viewType="0" name="userid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
							browserSpanValue=""></brow:browser>
							</span>
							
							<span id="roleidSP" style="float:left;">
							<brow:browser viewType="0" name="roleid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=65" linkUrl="/hrm/roles/HrmRolesShowEdit.jsp?type=0&id=" 
							browserSpanValue=""></brow:browser>
							</span>
							
							<span id="jobidSP" style="float:left;">
							<brow:browser viewType="0" name="jobid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?resourceids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=24" 
							browserSpanValue=""></brow:browser>
							</span>
							
							<span id=showrolelevel name=showrolelevel style="float:left;margin-left:10px;display:none;width:120px;">
							  <div style="float:left;margin-top:7px;height:17px;line-height:17px;">&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>&nbsp;&nbsp;</div>
							  <SELECT class="InputStyle" name="rolelevel" id="rolelevel" style="width:40px !important;">
							    <option selected value="0"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
							    <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
							    <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
							  </SELECT>
							</span>
						</wea:item>
						
						<!-- 岗位级别 -->
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
					     				   completeUrl="javascript:getajaxurl()"  width="150px" browserValue="" browserSpanValue=""/>
					     	</span>
						</wea:item>
				    	<!--  -->
						<!-- 安全级别 -->
						<wea:item attributes="{'samePair':\"sectr\"}"><%=SystemEnv.getHtmlLabelName(683, user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':\"sectr\"}">
							<span id=showseclevel name=showseclevel style="display:''">
								<INPUT class="InputStyle" style="width:50px;" type=text id=seclevel name=seclevel size=6 value="0" onchange="checkinput('seclevel','seclevelimage')">
							    <SPAN id=seclevelimage></SPAN>
							        - <INPUT class="InputStyle" style="width:50px;" type=text id=seclevelMax name=seclevelMax size=6 value="100" onchange="checkinput('seclevelMax','seclevelimage2')">
							    <SPAN id=seclevelimage2></SPAN>
							</span>
						</wea:item>
						<!-- 可查看 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(1380, user.getLanguage())+SystemEnv.getHtmlLabelName(504, user.getLanguage())%></wea:item>
						<wea:item>
							<span id=showiscanread name=showiscanread style="display:''">
								<SELECT class="InputStyle" name="iscanread" id="iscanread" style="width:60px !important;">
							    <option selected value="1"><%=SystemEnv.getHtmlLabelName(20306,user.getLanguage())%>
							    <option value="0"><%=SystemEnv.getHtmlLabelName(82613,user.getLanguage())%>
							  </SELECT>
							</span>
						</wea:item>
					</wea:group>
				</wea:layout>

			<input type="hidden" name="f_weaver_belongto_userid" value="<%=request.getParameter("f_weaver_belongto_userid") %>">
			<input type="hidden" name="f_weaver_belongto_usertype" value="<%=request.getParameter("f_weaver_belongto_usertype") %>">
			</FORM>
		<%
			if ("1".equals(dialog)) {
		%>
		</div>
		<%
			}
		%>
		<%
		if ("1".equals(dialog)) {
		%>
		<div id="zDialog_div_bottom" class="zDialog_div_bottom">
			<wea:layout type="2col">
				<wea:group context="">
					<wea:item type="toolbar">
						<input type="button"
							value="<%=SystemEnv.getHtmlLabelName(309, user.getLanguage())%>"
							id="zd_btn_cancle" class="zd_btn_cancle" onclick="btn_cancle()">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		<%
		}
		%>

	</body>
</html>

<script language="javascript" src="/js/ecology8/meeting/meetingbase_wev8.js"></script>
<script type="text/javascript">
if("<%=dialog%>"=="1"){
	var bodyheight = document.body.offsetHeight;
	var bottomheight = $(".zDialog_div_bottom").css("height");
	if(bottomheight.indexOf("px")>0){
		bottomheight = bottomheight.substring(0,bottomheight.indexOf("px"));
	}
	if(isNaN(bottomheight)){
		bottomheight = 0;
	}
	$(".zDialog_div_content").css("height",bodyheight-bottomheight);
	var dialog = parent.parent.getDialog(window.parent);
	var parentWin = parent.parent.getParentWindow(window.parent);
	function btn_cancle(){
		//parentWin.closeDialog();
		dialog.closeByHand();
	}
}

if("<%=isclose%>"=="1"){
	var dialog = parent.parent.getDialog(window.parent);
	var parentWin = parent.parent.getParentWindow(window.parent);
	parentWin.location="/workflow/request/WorkflowSharedScope.jsp?f_weaver_belongto_userid=<%=userid%>&f_weaver_belongto_usertype=<%=f_weaver_belongto_usertype%>&wfid=<%=wfid %>&requestid=<%=requestid %>";
	dialog.closeByHand();
	//parentWin.closeDlgARfsh();	
}
function setChange(){
	jQuery("hasChanged").value="true";
}

function onChangePermissionType() {
	thisvalue=jQuery("#permissiontype").val();
 	//jQuery($GetEle("sectr")).css("display","");
 	//jQuery($GetEle("secline")).css("display","");
 	hideEle("showjob");
	showEle("sectr");
	showEle("objtr");
 	
	if (thisvalue == 1) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","none");
		showEle("sectr");
    }
	else if (thisvalue == 2) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","");
		jQuery($GetEle("showrolelevel")).css("display","");
		jQuery($GetEle("jobidSP")).css("display","none");
		showEle("sectr");
	}
	else if (thisvalue == 3) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","none");
		showEle("sectr");
		hideEle("objtr", true);
	}
	
	else if (thisvalue == 5) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","none");
		hideEle("sectr", true);
	}
	else if (thisvalue == 6) {
		jQuery($GetEle("subidsSP")).css("display","");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","none");
		showEle("sectr");
	}else if (thisvalue == 7) {
		showEle("showjob");
		jQuery($GetEle("jobidSP")).css("display","");
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		hideEle("sectr", true);
	}
}

function check_by_permissiontype() {
    var re=/^\d+$/;
    var thisvalue=jQuery("#permissiontype").val();
    var seclevel = jQuery("#seclevel").val();
    var seclevelMax = jQuery("#seclevelMax").val();
    if (thisvalue == 1) {
        if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
            Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        return check_form(weaverA, "departmentid, seclevel, seclevelMax");
    } else if (thisvalue == 2) {
    	 if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
            Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        return check_form(weaverA, "roleid, rolelevel, seclevel, seclevelMax");
    } else if (thisvalue == 3) {
        if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
            Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        return check_form(weaverA, "seclevel, seclevelMax");
    } else if (thisvalue == 5) {
        return check_form(weaverA, "userid");
    } else if (thisvalue == 6) {
        if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
            Dialog.alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        return check_form(weaverA, "subids, seclevel, seclevelMax");
    } else if (thisvalue == 7) {
    	var joblevel = jQuery("select[name=joblevel]").val();
    	if(joblevel == 2){
        	return check_form(weaverA, "jobid");
    	}else{
	        return check_form(weaverA, "jobid,relatedshareid_6");
    	}
    } else {
        return false;
    }
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

function getajaxurl(obj) {
	var tmpval = jQuery("select[name=joblevel").val();
	var url = "";	
	if (tmpval == "0") {
		url = "/data.jsp?type=4";
	}else if (tmpval == "1") {
		url = "/data.jsp?type=194";
	}	
	return url;
}

function saveData(){
	if (check_by_permissiontype()) {
		$('#weaverA').submit();
	}
}
jQuery(document).ready(function(){
	onChangePermissionType();
});
</script>
