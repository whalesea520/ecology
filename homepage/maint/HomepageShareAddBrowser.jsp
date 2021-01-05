
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
	String hpid =   Util.null2String(request.getParameter("hpid"));
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
	<jsp:include page="/systeminfo/commonTabHead.jsp">
	   <jsp:param name="mouldID" value="portal"/>
	   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>"/>  
	</jsp:include>
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
					<span title="<%=SystemEnv.getHtmlLabelName(2104,user.getLanguage()) %>" class="cornerMenu middle"></span>
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
		
		<div class="zDialog_div_content">
			
			<FORM id=weaverA name=weaverA action="/homepage/maint/HomepageShareOperation.jsp"
				method="post">
				
				<input type="hidden" value="false" name="hasChanged" id="hasChanged" />
				<input type="hidden" name="method" id="method" value="addShare" />
				<input type="hidden" value="<%=dialog%>" name="dialog" id="dialog" />
				<input type="hidden" value="<%=hpid %>" name="hpid" id="hpid" />
				<input type="hidden" value="" name="sharetype" id="sharetype" />
				<input type="hidden" value="" name="sharevalue" id="sharevalue" />
				<input type="hidden" value="" name="formrolelevel" id="formrolelevel" />
				<input type="hidden" value="" name="formseclevel" id="formseclevel" />	
				<input type="hidden" value="" name="formjobtitlelevel" id="formjobtitlelevel" />	
				<input type="hidden" value="" name="formjobtitlesharevalue" id="formjobtitlesharevalue" />							
				
				<wea:layout type="2col">
					<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
						<!-- 对象 -->
						<wea:item><%=SystemEnv.getHtmlLabelName(21956, user.getLanguage())%></wea:item>
						<wea:item>
							<SELECT style="width:100px;" class="InputStyle" name="permissiontype" id="permissiontype" onchange="onChangePermissionType()" style="float:left">
							  <option selected value="1"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
							  <option value="6"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
							  <option value="3"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
							  <option value="5"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
							  <option value="2"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
							  <option value="7"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
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
							<span style="margin-right:15px"></span>
							<input type="checkbox" name="includeSub" value="1"><%=SystemEnv.getHtmlLabelName(125963,user.getLanguage())%>
							</span>
							
							<span id="departmentidSP" style="float:left;">
							<brow:browser viewType="0" name="departmentid" browserValue="" 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="200px"
							completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
							browserSpanValue=""></brow:browser>
							<span style="margin-right:15px"></span>
							<input type="checkbox" name="includeSub" value="1"><%=SystemEnv.getHtmlLabelName(125963,user.getLanguage())%>
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
							
							<span id=showrolelevel name=showrolelevel style="margin-left:10px;display:none;width:100px">
							  <div style="float:left;margin-top:7px;height:17px;line-height:17px;">&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:&nbsp;&nbsp;</div>
							  <SELECT class="InputStyle" name="rolelevel" id="rolelevel" style="width:60px;">
							    <option selected value="0"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
							    <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
							    <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
							  </SELECT>
							</span>
							
							<span id="jobtitleSP" style="float:left;">
							<brow:browser viewType="0" name="jobtitle" browserValue=""
							 browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?selectedids=" 
				         	 hasInput="true" isSingle="false" hasBrowser="true" isMustInput="2" width="200px" 
				         	 completeUrl="/data.jsp?type=24" browserSpanValue="" >
				         	</brow:browser>
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
						<wea:item attributes="{'samePair':\"jobtitletr\"}"><%=SystemEnv.getHtmlLabelName(28169, user.getLanguage())%></wea:item>
						<wea:item attributes="{'samePair':\"jobtitletr\"}">
							<span id=showjobtitlelevel name=showjobtitlelevel style="float:left;">
								<select class=InputStyle id="jobtitlelevel" name="jobtitlelevel" onchange="javascript:changeJobtitlelevel();" >
						         	<option value="1"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%></option>
						         	<option value="2"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%></option>
						         	<option value="3"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%></option>
						         </select>
							</span>
							<span id="departmentSP" style="float:left;">
							<brow:browser viewType="0" name="department" browserValue=""
							 browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp" 
				         	 hasInput="true" isSingle="false" hasBrowser="true" isMustInput="2" width="200px" 
				         	 completeUrl="/data.jsp?type=4" browserSpanValue="" >
				         	</brow:browser>
				         	</span>
				         	<span id="subcompanySP" style="float:left;">
				         	<brow:browser viewType="0" name="subcompany" browserValue=""
							 browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp" 
				         	 hasInput="true" isSingle="false" hasBrowser="true" isMustInput="2" width="200px" 
				         	 completeUrl="/data.jsp?type=164" browserSpanValue="" >
				         	</brow:browser>
				         	</span>
						</wea:item>
					</wea:group>
				</wea:layout>
			</FORM>
		
		</div>
		
	
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
		
	</body>
	<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
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
	
}

function btn_cancle(){
		//parentWin.closeDialog();
		//dialog.closeByHand();
		var dialog = parent.getDialog(window);
		dialog.close();
}
	
if("<%=isclose%>"=="1"){
	var dialog = parent.getDialog(window);
	dialog.currentWindow.location.reload()
	dialog.close();	
}
function setChange(){
	jQuery("hasChanged").value="true";
}

function onChangePermissionType() {
	thisvalue=jQuery("#permissiontype").val();
 	//jQuery($GetEle("sectr")).css("display","");
 	//jQuery($GetEle("secline")).css("display","");
	showEle("sectr");
	showEle("objtr");
	hideEle("jobtitletr", true);
	if (thisvalue == 1) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("jobtitleSP")).css("display","none");
		showEle("sectr");
    }
	else if (thisvalue == 2) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","");
		jQuery($GetEle("showrolelevel")).css("display","");
		jQuery($GetEle("jobtitleSP")).css("display","none");
		showEle("sectr");
	}
	else if (thisvalue == 3) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("jobtitleSP")).css("display","none");
		showEle("sectr");
		hideEle("objtr", true);
	}
	
	else if (thisvalue == 5) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("jobtitleSP")).css("display","none");
		hideEle("sectr", true);
	}
	else if (thisvalue == 6) {
		jQuery($GetEle("subidsSP")).css("display","");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("jobtitleSP")).css("display","none");
		showEle("sectr");
	}
	else if (thisvalue == 7) {
		jQuery($GetEle("subidsSP")).css("display","none");
		jQuery($GetEle("departmentidSP")).css("display","none");
		jQuery($GetEle("useridSP")).css("display","none");
		jQuery($GetEle("roleidSP")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("jobtitleSP")).css("display","");
		
		//jQuery($GetEle("departmentSP")).css("display","none");
		//jQuery($GetEle("subcompanySP")).css("display","none");
		changeJobtitlelevel();
		
		hideEle("sectr", true);
		showEle("jobtitletr");
	}
}

function changeJobtitlelevel() {
	var jobtitlelevel = jQuery("#jobtitlelevel").val();
	
	if (jobtitlelevel == 1) {
		jQuery($GetEle("departmentSP")).css("display","none");
		jQuery($GetEle("subcompanySP")).css("display","none");
	} else if (jobtitlelevel == 2) {
		jQuery($GetEle("departmentSP")).css("display","");
		jQuery($GetEle("subcompanySP")).css("display","none");
	}  else if (jobtitlelevel == 3) {
		jQuery($GetEle("departmentSP")).css("display","none");
		jQuery($GetEle("subcompanySP")).css("display","");
	}
}

function check_by_permissiontype() {
    var re=/^-?\d+$/;
    var thisvalue=jQuery("#permissiontype").val();
    var seclevel = jQuery("#seclevel").val();
    var seclevelMax = jQuery("#seclevelMax").val();
    
    $("#sharetype").val(thisvalue);
    
    if (thisvalue == 1) {
        if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
            alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        
        $("#sharevalue").val($("#departmentid").val());
        $("#formseclevel").val($("#seclevel").val()+"-"+$("#seclevelMax").val());
        
        return check_form(weaverA, "departmentid,seclevel,seclevelMax")
    } else if (thisvalue == 2) {
    	 if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
            alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        
        $("#sharevalue").val($("#roleid").val());
        $("#formseclevel").val($("#seclevel").val()+"-"+$("#seclevelMax").val());
        $("#formrolelevel").val($("#rolelevel").val());
        return check_form(weaverA, "roleid,rolelevel,seclevel,seclevelMax");
    } else if (thisvalue == 3) {
        if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
            alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        
        $("#formseclevel").val($("#seclevel").val()+"-"+$("#seclevelMax").val());
        return check_form(weaverA, "seclevel,seclevelMax");
    } else if (thisvalue == 5) {
    	$("#sharevalue").val($("#userid").val());
        return check_form(weaverA, "userid");
    } else if (thisvalue == 6) {
        if(!re.test(seclevel) || !re.test(seclevelMax) || parseInt(seclevel)>parseInt(seclevelMax))  {
            alert("<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(2245,user.getLanguage())%>")
            return false;
        }
        $("#sharevalue").val($("#subids").val());
        $("#formseclevel").val($("#seclevel").val()+"-"+$("#seclevelMax").val());
        return check_form(weaverA, "subids,seclevel,seclevelMax")
    } else if (thisvalue == 7) {
        $("#sharevalue").val($("#jobtitle").val());
        var jobtitlelevel = $("#jobtitlelevel").val()
        $("#formjobtitlelevel").val(jobtitlelevel);
        if (jobtitlelevel == 2) {
        	$("#formjobtitlesharevalue").val($("#department").val());
        	return check_form(weaverA, "jobtitle,jobtitlelevel,department");
        } else if (jobtitlelevel == 3) {
        	$("#formjobtitlesharevalue").val($("#subcompany").val());
        	return check_form(weaverA, "jobtitle,jobtitlelevel,subcompany");
        } else {
        	$("#formjobtitlesharevalue").val("");
        	return check_form(weaverA, "jobtitle,jobtitlelevel");
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
jQuery(document).ready(function(){
	onChangePermissionType();
});
</script>
