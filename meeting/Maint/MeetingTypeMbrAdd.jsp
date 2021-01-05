
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
	String dialog = Util.null2String(request.getParameter("dialog"));
	String isclose = Util.null2String(request.getParameter("isclose"));
	String mid = Util.null2String(request.getParameter("mid"));
	String method = Util.null2String(request.getParameter("method"));
	int isgoveproj = Util.getIntValue(IsGovProj.getPath(),0);//0:非政务系统，1：政务系统
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
			<FORM id=weaverA name=weaverA action="MeetingTypeOperation.jsp"
				method="post">
				<input type="hidden" value="false" name="hasChanged"
					id="hasChanged" />
				<input class=inputstyle type="hidden" name="method" id="method"
					value="mbrAdd" />
				<input type="hidden" value="<%=dialog%>" name="dialog"
					id="dialog" />
				<input type="hidden" value="" name="forwd" id="forwd" />
				<input type="hidden" value="<%=mid %>" name="mid" id="mid" />
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
					<!-- 对象 -->
					<wea:item><%=SystemEnv.getHtmlLabelName(21956, user.getLanguage())%></wea:item>
					<wea:item>
						<SELECT class="InputStyle" style="width:100px;" name="membertype" id="membertype" onchange="onChangePermissionType()" >
						<option selected value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
						<%if(isgoveproj==0){%>
							<%if(software.equals("ALL") || software.equals("CRM")){%>
						<option value="2"><%=SystemEnv.getHtmlLabelName(136,user.getLanguage())%></option>
							<%}%>
							<%}%>
						<option value="5"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
						<option value="8"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
						</SELECT>
					</wea:item>
						<!-- 对象 -->
					<wea:item attributes="{'samePair':\"objtr\"}" ><%=SystemEnv.getHtmlLabelName(106, user.getLanguage())%></wea:item>
					<wea:item attributes="{'samePair':\"objtr\"}" >
						<span id="subidsSP">
						<brow:browser viewType="0" name="subids" browserValue="" 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids=" 
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="300px"
						completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
						browserSpanValue=""></brow:browser>
						</span>
						
						<span id="departmentidSP">
						<brow:browser viewType="0" name="departmentid" browserValue="" 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="300px"
						completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
						browserSpanValue=""></brow:browser>
						</span>
						
						<span id="useridSP">
						<brow:browser viewType="0" name="userid" browserValue="" 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="300px"
						completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
						browserSpanValue=""></brow:browser>
						</span>
						
						<span id="roleidSP">
						<brow:browser viewType="0" name="roleid" browserValue="" 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" 
						hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="190px"
						completeUrl="/data.jsp?type=65" linkUrl="/hrm/roles/HrmRolesShowEdit.jsp?type=0&id=" 
						browserSpanValue=""></brow:browser>
						</span>
						
						<span id="crmidSP">
						<brow:browser viewType="0" name="crmid" browserValue="" 
						browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/CRM/data/MutiCustomerBrowser.jsp?resourceids="%>'
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2' width="300px" 
						completeUrl="/data.jsp?type=18" linkUrl="/CRM/data/ViewCustomer.jsp?CustomerID=#id#&id=#id#" 
						browserSpanValue=""></brow:browser>
						</span>
						
						<span id="jobidSP">
						<brow:browser viewType="0" name="jobid" browserValue="" 
						browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?resourceids="%>'
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2' width="300px" 
						completeUrl="/data.jsp?type=hrmjobtitles" linkUrl="/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=" 
						browserSpanValue=""></brow:browser>
						</span>
						
						<span id=showrolelevel name=showrolelevel style="display:none">
						<div style="float:left;margin-top:7px;height:17px;line-height:17px;">&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>&nbsp;&nbsp;</div>
						<SELECT class=InputStyle name="rolelevel" id="rolelevel" style="width:60px;">
							<option selected value="0"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
							<option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
							<option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
						</SELECT>
						</span>
					</wea:item>
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
					<!-- 岗位级别 -->
					<wea:item attributes="{'samePair':\"jobtr\"}"><%=SystemEnv.getHtmlLabelName(28169, user.getLanguage())%></wea:item>
					<wea:item attributes="{'samePair':\"jobtr\"}">
						<span id=showjoblevel name=showjoblevel style="display:''">
							<div style="float:left"><SELECT class=InputStyle name="joblevel" id="joblevel" style="width:80px;"  onchange="onLevelTypeChange()">
								<option selected value="0"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
								<option value="1"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%>
								<option value="2"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%>
							</SELECT></div>
							<span id="sublevelSP" style="display:''">
								<brow:browser viewType="0" name="sublevelids" browserValue="" 
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids=" 
								hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="198px"
								completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
								browserSpanValue=""></brow:browser>
							</span>
							<span id="deplevelSP" style="display:''">
								<brow:browser viewType="0" name="deplevelids" browserValue="" 
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
								hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="198px"
								completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
								browserSpanValue=""></brow:browser>
							</span>
						</span>
					</wea:item>
					<wea:item><%=SystemEnv.getHtmlLabelName(85, user.getLanguage())%></wea:item>
					<wea:item>
							<textarea class="inputstyle" name="desc_n"
								id="desc_n" rows="4" cols="40" value="" style="width:300px;"  maxlength="255" onkeydown="checklength(this, <%=SystemEnv.getHtmlLabelName(20246, user.getLanguage()) %>);"></textarea>
					</wea:item>
				</wea:group>
			</wea:layout>
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
		parentWin.closeDialog();
	}
}

if("<%=isclose%>"=="1"){
	var dialog = parent.parent.getDialog(window.parent);
	var parentWin = parent.parent.getParentWindow(window.parent);
	parentWin.location="/meeting/Maint/MeetingTypeEdit.jsp?id=<%=mid %>&method=member";
	parentWin.closeDlgARfsh();	
}
function setChange(){
	jQuery("hasChanged").value="true";
}

function onChangePermissionType() {
	thisvalue=jQuery("#membertype").val();
 	showEle("sectr");
	showEle("objtr");
	showEle("jobtr");
	if (thisvalue == 5) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("crmidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","none");
		hideEle("jobtr", true);
		
		
    }
	else if (thisvalue == 2) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("crmidSP")).css("display","");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","none");
		hideEle("sectr", true);
		hideEle("jobtr", true);
		
	}
	else if (thisvalue == 3) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("crmidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","none");
		hideEle("objtr", true);
		hideEle("jobtr", true);
	}
	
	else if (thisvalue == 1) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("crmidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","none");
		hideEle("sectr", true);
		hideEle("jobtr", true);
	}
	else if (thisvalue == 6) {
		jQuery($GetEle("subidsSP")).css("display","");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("crmidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","none");
		hideEle("jobtr", true);
	}
	else if (thisvalue == 7) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","");
		jQuery($GetEle("crmidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","");
		jQuery($GetEle("jobidSP")).css("display","none");
		hideEle("jobtr", true);
	}
	else if (thisvalue == 8) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("crmidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","");
		jQuery($GetEle("showjoblevel")).css("display","");
		hideEle("sectr", true);
	}
}

function check_by_permissiontype() {
    var re=/^\d+$/;
    var thisvalue=jQuery("#membertype").val();
    var seclevel = jQuery("#seclevel").val();
    var seclevelMax = jQuery("#seclevelMax").val();
    var sublevelids = jQuery("#sublevelids").val();
    var deplevelids = jQuery("#deplevelids").val();
    var joblevel = jQuery("#joblevel").val();
    
    if (thisvalue == 5) {
        if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
            alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        return check_form(weaverA, "departmentid, seclevel,seclevelMax")
    } else if (thisvalue == 2) {
        return check_form(weaverA, "crmid");
    } else if (thisvalue == 3) {
        if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
            alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        return check_form(weaverA, "seclevel,seclevelMax");
    } else if (thisvalue == 1) {
        return check_form(weaverA, "userid");
    } else if (thisvalue == 6) {
        if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
            alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())+ SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        return check_form(weaverA, "subids,seclevel,seclevelMax")
    }else if (thisvalue == 7) {
         if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
            alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        return check_form(weaverA, "roleid,rolelevel,seclevel,seclevelMax");
    }else if (thisvalue == 8) {
    	if(joblevel==1){
    		return check_form(weaverA, "jobid,sublevelids");
    	}else if(joblevel==2){
    		return check_form(weaverA, "jobid,deplevelids");
    	}else{
    		return check_form(weaverA, "jobid");
    	}
    } else {
        return false;
    }
}

function saveData(){
	if (check_by_permissiontype()) {
		$('#weaverA').submit();
	}
}

function onLevelTypeChange() {
	thisvalue=jQuery("#joblevel").val();
	if (thisvalue == 0) {
		jQuery($GetEle("sublevelSP")).css("display","none");
		jQuery($GetEle("deplevelSP")).css("display","none");
    }
	else if (thisvalue == 1) {
		jQuery($GetEle("sublevelSP")).css("display","");
		jQuery($GetEle("deplevelSP")).css("display","none");
		
	}
	else if (thisvalue == 2) {
		jQuery($GetEle("sublevelSP")).css("display","none");
		jQuery($GetEle("deplevelSP")).css("display","");
		
	}
}
jQuery(document).ready(function(){
	onChangePermissionType();
	onLevelTypeChange();
});
</script>
