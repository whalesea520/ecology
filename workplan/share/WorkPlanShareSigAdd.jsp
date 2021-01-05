
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.WorkPlan.WorkPlanShare"%>
<%@ page import="net.sf.json.*"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="rs" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="departmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="resourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="rolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page"/>
<jsp:useBean id="subCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page"/>
<jsp:useBean id="workPlanHandler" class="weaver.WorkPlan.WorkPlanHandler" scope="page"/>
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<%
	String planID = Util.null2String(request.getParameter("planID"));
	
	if (planID.equals(""))
	{
		return;
	}

	String[] creater = workPlanHandler.getCreater(planID);
	
	String createrID = "";
	if (creater != null)
	{
		createrID = creater[0];
	}

	String userID = String.valueOf(user.getUID());
			
	boolean canEdit = false;
	
	if (createrID.equals(userID))
	{
	    canEdit = true;
	}
	
	

	//获得所有维度
	boolean hasVirtual = false;
	JSONArray jsonarray = new JSONArray();
	String virtualCompany = "";
	if(CompanyVirtualComInfo.getCompanyNum()>0){
	    if(CompanyComInfo.getCompanyNum()>0){
	        CompanyComInfo.setTofirstRow();
	        while(CompanyComInfo.next()){
	            JSONObject jsonobj = new JSONObject();
	            jsonobj.put("id",CompanyComInfo.getCompanyid());
	          	//应需求分析部要求,主组织架构和其他模块一样统一修改为<行政组织>
	            jsonobj.put("name",SystemEnv.getHtmlLabelName(83179,user.getLanguage()));
	            jsonarray.add(jsonobj);
	            virtualCompany += virtualCompany.equals("")?CompanyComInfo.getCompanyid():","+CompanyComInfo.getCompanyid();
	        }
	    }
	    if(CompanyVirtualComInfo.getCompanyNum()>0){
	        CompanyVirtualComInfo.setTofirstRow();
	        while(CompanyVirtualComInfo.next()){
	            JSONObject jsonobj = new JSONObject();
	            jsonobj.put("id",CompanyVirtualComInfo.getCompanyid());
	            jsonobj.put("name",CompanyVirtualComInfo.getVirtualType());
	            jsonarray.add(jsonobj);
	            virtualCompany += virtualCompany.equals("")?CompanyVirtualComInfo.getCompanyid():","+CompanyVirtualComInfo.getCompanyid();
	        }
	        hasVirtual = true;
	    }
	}
	
	
String imagefilename = "/images/hdCRMAccount_wev8.gif";
String titlename = "";
int needchange=0;
String needfav ="1";
String needhelp ="";
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
		<LINK href="/js/ecology8/workplan/css/workplanVirtual_wev8.css" type=text/css rel=STYLESHEET>
		<SCRIPT language="javascript" src="/js/ecology8/workplan/js/workplanVirtual_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/checkinput_wev8.js"></script>
		<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
	</head>
	<BODY style="overflow: hidden;">
		<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
		<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
		<%
			RCMenu += "{" + SystemEnv.getHtmlLabelName(86, user.getLanguage())
					+ ",javascript:submitData(this),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="schedule"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(20190,user.getLanguage())%>"/>
		</jsp:include>
		<div class="zDialog_div_content">
		
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
			   <td>
				</td>
				<td class="rightSearchSpan" style="text-align:right; ">
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="submitData(this)">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
				</td>
			</tr>
		</table>
			<FORM name="frmmain" action="WorkPlanShareHandler.jsp">												
				<INPUT type="hidden" name="method" value="add">
				<INPUT type="hidden" name="planID" value="<%=planID%>">
				<INPUT type="hidden" name="workid" value="<%=planID%>">
				<INPUT type="hidden" id="f_weaver_belongto_userid" name="f_weaver_belongto_userid" value="<%=user.getUID()%>">
				<INPUT type="hidden" name="delid">
				<wea:layout type="2col">
					<wea:group context="" attributes="{'groupDisplay':\"none\"}" >
					<wea:item>
							<%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%>
					  	</wea:item>
							<!--================== 共享类型选择 ==================-->
						<wea:item>
							<span style="float:left">
							<SELECT name=sharetype onchange="onChangeShareType()"  class=InputStyle style="width:60px;">
								<OPTION value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></OPTION> 
								<OPTION value="5"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></OPTION> 
								<OPTION value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></OPTION> 
								<OPTION value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></OPTION> 
								<OPTION value="4"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></OPTION> 
								<option value="6"><%=SystemEnv.getHtmlLabelName(15762,user.getLanguage())%></option>
								<option value="8"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
							</SELECT>
							</span>
							<span id="useridedSP" style="display:none;margin-left:10px"> 
							<brow:browser viewType="0" name="userided" browserValue="" tempTitle='<%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%>' 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="150px"
							completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
							browserSpanValue=""></brow:browser>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</span>
							
							<span id="subidsdSP" style="display:none;margin-left:10px">
							<brow:browser viewType="0" name="subidsd" browserValue=""  tempTitle='<%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%>' 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="150px"
							completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
							browserSpanValue=""></brow:browser>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</span>
							
							<span id="departmentidedSP" style="display:none;margin-left:10px">
							<brow:browser viewType="0" name="departmentided" browserValue=""  tempTitle='<%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%>' 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="150px"
							completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
							browserSpanValue=""></brow:browser>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</span>
							
							<span id="roleidSPd" style="display:none;margin-left:10px">
							<brow:browser viewType="0" name="roleided" browserValue="" tempTitle='<%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%>' 
							browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" 
							hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="150px"
							completeUrl="/data.jsp?type=65" linkUrl="/hrm/roles/HrmRolesShowEdit.jsp?type=0&id=" 
							browserSpanValue=""></brow:browser>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</span>
							<INPUT type=hidden name=relatedshareid id=relatedshareid value="">
							<SPAN id=showrolelevel name=showrolelevel >
								<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>:
								<SELECT name=rolelevel class=InputStyle style="width:60px;">
									<OPTION value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
									<OPTION value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
									<OPTION value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
								</SELECT>
								
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							</SPAN>
							<span id="jobidSP">
							<brow:browser viewType="0" name="jobid" browserValue="" 
							browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?resourceids="%>'
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2' width="150px" 
							completeUrl="/data.jsp?type=hrmjobtitles" linkUrl="/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=" 
							browserSpanValue=""></brow:browser>
							</span>
							<SPAN id=showseclevel name=showseclevel>
								<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>:
								<INPUT class=InputStyle maxLength=3 size=5 style="width:30px;" name=seclevel onKeyPress="ItemCount_KeyPress()" onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="10">
								<SPAN id=seclevelimage></SPAN>
								- <INPUT class="InputStyle" style="width: 35px !important" type=text id=seclevelMax name=seclevelMax size=6 value="100" onchange="checkinput('seclevelMax','seclevelMaximage')">
								 <SPAN id=seclevelMaximage></SPAN>
							</SPAN>
							<span id=showjoblevel name=showjoblevel style="display:'';margin-left:5px;">
							<span style="float:left;margin-left:15px;"><%=SystemEnv.getHtmlLabelNames("6086,139",user.getLanguage())%>:</span>
							<div style="float:left;margin-left:5px;"><SELECT class=InputStyle name="joblevel" id="joblevel" style="width:80px;"  onchange="onLevelTypeChange()">
								<option selected value="0"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
								<option value="1"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%>
								<option value="2"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%>
							</SELECT></div>
							<span id="sublevelSP" style="display:'';margin-left:5px;">
								<brow:browser viewType="0" name="sublevelids" browserValue="" 
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids=" 
								hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="150px"
								completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
								browserSpanValue=""></brow:browser>
							</span>
							<span id="deplevelSP" style="display:'';margin-left:5px;">
								<brow:browser viewType="0" name="deplevelids" browserValue="" 
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
								hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="150px"
								completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
								browserSpanValue=""></brow:browser>
							</span>
						</span>
						</wea:item>
                        <!-- QC373498 新增共享对象为所有上级的维度 -->
	                    <wea:item attributes="{'samePair':\"virtualSelect\"}">
	                         <%=SystemEnv.getHtmlLabelName(82531,user.getLanguage()) %>
	                    </wea:item>
	                    <wea:item attributes="{'samePair':\"virtualSelect\"}">
	                        <select id="companyVirtualSel" onchange="onChangeCompanyVirtual(this)" style="float:left;margin-left:5px;">
	                            <option value="0"><%=SystemEnv.getHtmlLabelName(382827,user.getLanguage())%></option>
	                            <option value="1"><%=SystemEnv.getHtmlLabelName(382828,user.getLanguage())%></option>
	                        </select>
	                        <div id="companyVirtualDtl" style="display:none;float:left;margin-left:10px;">
	                            <span class="spanSelect spanSelect-default" id="companyVirtualText">
	                                <span class="multiselect-selected-text"></span>
	                                <b class="caret"></b>
	                            </span>
	                            <input type="hidden" id="companyVirtual" name="companyVirtual" value="">
	                        </div>
	                        <SPAN id=companyVirtualImage style="display:none"><img align="absmiddle" src="/images/BacoError_wev8.gif"></SPAN>
	                    </wea:item>
							<!--================== 共享级别 ==================-->
						<wea:item>
							<%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
					  	</wea:item>
					  	<wea:item>
							<SELECT name=sharelevel class=InputStyle>
								<OPTION value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
								<%if(WorkPlanShare.SHARE_TYPE==2&&canEdit){ %>									  
								<OPTION value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
								<%} %>						
							</SELECT>
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
							id="zd_btn_cancle" class="e8_btn_cancel" onclick="dialog.closeByHand();">
					</wea:item>
				</wea:group>
			</wea:layout>
		</div>
		<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>
	</body>
</html>

<script type="text/javascript">
var dialog = parent.getDialog(window);
function btn_cancle(){
	var parentWin = parent.getParentWindow(window);
	parentWin.closeDialog();
}

function submitData(obj)
{
	var checkstr="";
	var thisValue = document.frmmain.sharetype.value;
	var sublevelids = jQuery("#sublevelids").val();
    var deplevelids = jQuery("#deplevelids").val();
    var joblevel = jQuery("#joblevel").val();
	if (thisValue == 1) {
		jQuery($GetEle("relatedshareid")).val(jQuery($GetEle("userided")).val());
		checkstr =",userided";
    } else if(thisValue == 2){
		jQuery($GetEle("relatedshareid")).val(jQuery($GetEle("departmentided")).val());
		checkstr =",departmentided";
	}else if(thisValue == 3){
		jQuery($GetEle("relatedshareid")).val(jQuery($GetEle("roleided")).val());
		checkstr =",roleided";
	}else if(thisValue == 4){
		jQuery($GetEle("relatedshareid")).val("");
	}else if(thisValue == 5){
		jQuery($GetEle("relatedshareid")).val(jQuery($GetEle("subidsd")).val());
		checkstr =",subidsd";
	}else if(thisValue == 6){
		if($("#companyVirtualSel").val() == '0'){
			console.log("0");
		  $("#companyVirtual").val('<%=virtualCompany%>');
		}else if($("#companyVirtualSel").val() == '1'){
          checkstr =",companyVirtual";
        }
		jQuery($GetEle("relatedshareid")).val("");
	}else if (thisValue == 8) {
		if(joblevel==1){
    		checkstr =",jobid,sublevelids";
    	}else if(joblevel==2){
    		checkstr =",jobid,deplevelids";
    	}else{
    		checkstr =",jobid";
    	}
    }
    if (check_form(frmmain,"itemtype,sharetype,seclevel,sharelevel"+checkstr))
    {
    	obj.disabled = true;
	    document.frmmain.submit();
	}else{
		flag=0;
	}
}

jQuery(document).ready(function(){
	onChangeShareType();
	onLevelTypeChange();
	$(".spanSelect").MultDropList({ 
        data: <%=jsonarray.toString()%>,
        hiddenElem:"companyVirtual",
        allDesc:'<%=SystemEnv.getHtmlLabelName(126831, user.getLanguage())%>',
        selectDesc:'<%=SystemEnv.getHtmlLabelName(128937, user.getLanguage())%> ',
		isMust:true,
		mustColumn:"companyVirtualImage"
    });
	resizeDialog(document);
});

function onChangeCompanyVirtual(obj){
    if($(obj).val() == '1'){
        jQuery($GetEle("companyVirtualDtl")).css("display","");
        $("#companyVirtualImage").css("display","");
    }else{
        //$(".spanSelect").selectAll();
        jQuery($GetEle("companyVirtualDtl")).css("display","none");
        $("#companyVirtualImage").css("display","none");
    }
}


function onChangeShareType() {
	var thisValue = document.frmmain.sharetype.value;
	if (thisValue == 1) {
		jQuery($GetEle("subidsdSP")).css("display","none");
		jQuery($GetEle("departmentidedSP")).css("display","none");
		jQuery($GetEle("useridedSP")).css("display","");
		jQuery($GetEle("roleidSPd")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","none");
		$("#showjoblevel").hide();
		$("#showseclevel").hide();
		$("#showrolelevel").hide();
		hideEle("virtualSelect", true);
    } else if(thisValue == 2){
		jQuery($GetEle("subidsdSP")).css("display","none");
		jQuery($GetEle("departmentidedSP")).css("display","");
		jQuery($GetEle("useridedSP")).css("display","none");
		jQuery($GetEle("roleidSPd")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","none");
		$("#showjoblevel").hide();
		$("#showseclevel").show();
		$("#showrolelevel").hide();
		hideEle("virtualSelect", true);
	}else if(thisValue == 3){
		jQuery($GetEle("subidsdSP")).css("display","none");
		jQuery($GetEle("departmentidedSP")).css("display","none");
		jQuery($GetEle("useridedSP")).css("display","none");
		jQuery($GetEle("roleidSPd")).css("display","");
		jQuery($GetEle("jobidSP")).css("display","none");
		$("#showjoblevel").hide();
		$("#showseclevel").show();
		$("#showrolelevel").show();
		hideEle("virtualSelect", true);
	}else if(thisValue == 4){
		jQuery($GetEle("subidsdSP")).css("display","none");
		jQuery($GetEle("departmentidedSP")).css("display","none");
		jQuery($GetEle("useridedSP")).css("display","none");
		jQuery($GetEle("roleidSPd")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","none");
		$("#showjoblevel").hide();
		$("#showseclevel").show();
		$("#showrolelevel").hide();
		hideEle("virtualSelect", true);
	}else if(thisValue == 5){
		jQuery($GetEle("subidsdSP")).css("display","");
		jQuery($GetEle("departmentidedSP")).css("display","none");
		jQuery($GetEle("useridedSP")).css("display","none");
		jQuery($GetEle("roleidSPd")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","none");
		$("#showjoblevel").hide();
		$("#showseclevel").show();
		$("#showrolelevel").hide();
		hideEle("virtualSelect", true);
	}else if(thisValue == 6){
		jQuery($GetEle("subidsdSP")).css("display","none");
		jQuery($GetEle("departmentidedSP")).css("display","none");
		jQuery($GetEle("useridedSP")).css("display","none");
		jQuery($GetEle("roleidSPd")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","none");
		$("#showjoblevel").hide();
		$("#showseclevel").hide();
		$("#showrolelevel").hide();
		<%
		if(hasVirtual){
		%>
		  showEle("virtualSelect");
		<%
		}
		%>
	}else if(thisValue == 8){
		jQuery($GetEle("subidsdSP")).css("display","none");
		jQuery($GetEle("departmentidedSP")).css("display","none");
		jQuery($GetEle("useridedSP")).css("display","none");
		jQuery($GetEle("roleidSPd")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","");
		$("#showjoblevel").show();
		$("#showseclevel").hide();
		$("#showrolelevel").hide();
		hideEle("virtualSelect", true);
	}
	$("input[name=seclevel]").val(10);
	
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
</script>
