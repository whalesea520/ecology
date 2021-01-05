
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="weaver.WorkPlan.WorkPlanShare"%>
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="net.sf.json.*"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<jsp:useBean id="SubCompanyComInfo" class="weaver.hrm.company.SubCompanyComInfo" scope="page" />
<jsp:useBean id="RolesComInfo" class="weaver.hrm.roles.RolesComInfo" scope="page" />
<jsp:useBean id="CompanyComInfo" class="weaver.hrm.company.CompanyComInfo" scope="page" />
<jsp:useBean id="CompanyVirtualComInfo" class="weaver.hrm.companyvirtual.CompanyVirtualComInfo" scope="page" />
<%
String settype=Util.null2String(request.getParameter("types"));
 
 
String imagefilename = "/images/hdCRMAccount_wev8.gif";
String titlename = "";
int needchange=0;
String needfav ="1";
String needhelp ="";


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
					+ ",javascript:submitData(),_self} ";
			RCMenuHeight += RCMenuHeightStep;
		%>
		<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
		<jsp:include page="/systeminfo/commonTabHead.jsp">
		   <jsp:param name="mouldID" value="schedule"/>
		   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(20221,user.getLanguage())%>"/>
		</jsp:include>
		<div class="zDialog_div_content">
		
		<table id="topTitle" cellpadding="0" cellspacing="0">
			<tr>
			   <td>
				</td>
				<td class="rightSearchSpan" style="text-align:right; ">
					<input type="button"
						value="<%=SystemEnv.getHtmlLabelName(86, user.getLanguage())%>"
						class="e8_btn_top middle" onclick="submitData()">
					<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage()) %>" class="cornerMenu middle"></span>
				</td>
			</tr>
		</table>
			<FORM id=weaver name=weaver action="WorkPlanCreateShareHandler.jsp" method=post >
			<input type="hidden" name="method" value="add">
			<wea:layout type="2col">
				<wea:group context='<%=SystemEnv.getHtmlLabelName(1361, user.getLanguage())%>' >
					<wea:item>
						<%=SystemEnv.getHtmlLabelName(16094,user.getLanguage())%>
					</wea:item>
					<wea:item>
						<%RecordSet.execute("SELECT * FROM WorkPlanType where (workPlanTypeID=0 or workPlanTypeID>6) and available=1 order by workPlanTypeID");%>
						 <select class=inputstyle  name=planType >
							  <option value="-1"><%=SystemEnv.getHtmlLabelName(332,user.getLanguage())%></option>
							 <%while (RecordSet.next()) {%>
							  <option value="<%=RecordSet.getString("workPlanTypeID")%>"><%=Util.forHtml(RecordSet.getString("workPlanTypename"))%></option>
							 <%}%>
							 
						</SELECT>
					</wea:item>
					<wea:item>
						 <%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%>  
					</wea:item>
					<wea:item>
						<span style="float:left">
					   <select class=inputstyle  name=sharetype onchange="onChangeSharetype()" style="float:left;width:70px;" >
							  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
							  <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
							  <option value="3" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
							  <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
							  <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
							  <option value="6"><%=SystemEnv.getHtmlLabelName(15762,user.getLanguage())%></option>
							  <option value="8"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
							  <option value="9"><%=SystemEnv.getHtmlLabelNames("2211,15525",user.getLanguage())%></option>
						  </SELECT>
						</span>
						<span id="useridedSP" style="float:left;margin-left:5px;"> 
						<brow:browser viewType="0" name="userided" browserValue="" tempTitle='<%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%>' 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="150px"
						completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" 
						browserSpanValue=""></brow:browser>
						</span>
						
						<span id="subidsdSP" style="float:left;margin-left:5px;">
						<brow:browser viewType="0" name="subidsd" browserValue=""  tempTitle='<%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%>' 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids=" 
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="150px"
						completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
						browserSpanValue=""></brow:browser>
						</span>
						
						<span id="departmentidedSP" style="float:left;margin-left:5px;">
						<brow:browser viewType="0" name="departmentided" browserValue=""  tempTitle='<%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%>' 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
						hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="150px"
						completeUrl="/data.jsp?type=4" linkUrl="/hrm/company/HrmDepartmentDsp.jsp?id=" 
						browserSpanValue=""></brow:browser>
						</span>
						
						<span id="roleidSPd" style="float:left;margin-left:5px;">
						<brow:browser viewType="0" name="roleided" browserValue="" tempTitle='<%=SystemEnv.getHtmlLabelName(19117,user.getLanguage())%>' 
						browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" 
						hasInput="true"  isSingle="true" hasBrowser = "true" isMustInput='2'  width="150px"
						completeUrl="/data.jsp?type=65" linkUrl="/hrm/roles/HrmRolesShowEdit.jsp?type=0&id=" 
						browserSpanValue=""></brow:browser>
						</span>
						<INPUT type=hidden id=relatedshareid name=relatedshareid value="">
						<span id=showrolelevel name=showrolelevel  style="float:left;margin-left:5px;width:120px;">
						<div style="float:left;margin-top:7px;height:17px;line-height:17px;">&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>&nbsp;&nbsp;</div>
						<select class=inputstyle  name=rolelevel style="width: 40px !important" >
						  <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
						  <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
						  <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
						</SELECT>
						</span>
						<span id=showseclevel name=showseclevel style="float:left;margin-left:5px;">
						<div style="float:left;margin-top:7px;height:17px;line-height:17px;">&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%>&nbsp;&nbsp;</div>
						<INPUT type=text class="InputStyle" id=seclevel name=seclevel size=6 value="10" onkeypress="ItemPlusCount_KeyPress()" onchange='checkNum("seclevel");checkinput("seclevel","seclevelimage")' style="width: 35px !important">
						<SPAN id=seclevelimage style="float:left;margin-left:5px;"></SPAN>
						- <INPUT class="InputStyle" style="width: 35px !important" type=text id=seclevelMax name=seclevelMax size=6 value="100" onkeypress="ItemPlusCount_KeyPress()" onchange="checkNum('seclevelMax');checkinput('seclevelMax','seclevelMaximage')">
						<SPAN id=seclevelMaximage></SPAN>
						</span>
						<span id="jobidSP" style="float:left;margin-left:5px;">
							<brow:browser viewType="0" name="jobid" browserValue="" 
							browserOnClick="" browserUrl='<%="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?resourceids="%>'
							hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2' width="150px" 
							completeUrl="/data.jsp?type=hrmjobtitles" linkUrl="/hrm/jobtitles/HrmJobTitlesEdit.jsp?id=" 
							browserSpanValue=""></brow:browser>
						</span>
						<span id="showjoblevel" name="showjoblevel" style="display:'';float:left;margin-left:5px;">
							<div style="float:left;margin-top:7px;height:17px;line-height:17px;">&nbsp;&nbsp;&nbsp;&nbsp;<%=SystemEnv.getHtmlLabelNames("6086,139",user.getLanguage())%>&nbsp;&nbsp;</div>
							<div style="float:left"><SELECT class=InputStyle name="joblevel" id="joblevel" style="width:80px;"  onchange="onLevelTypeChange()">
								<option selected value="0"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
								<option value="1"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%>
								<option value="2"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%>
							</SELECT></div>
							<span id="sublevelSP" style="display:'';float:left;margin-left:5px;">
								<brow:browser viewType="0" name="sublevelids" browserValue="" 
								browserOnClick="" browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids=" 
								hasInput="true"  isSingle="false" hasBrowser = "true" isMustInput='2'  width="150px"
								completeUrl="/data.jsp?type=164" linkUrl="/hrm/company/HrmSubCompanyDsp.jsp?id=" 
								browserSpanValue=""></brow:browser>
							</span>
							<span id="deplevelSP" style="display:'';float:left;margin-left:5px;">
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
					 
					 
					<wea:item>
						 <%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%>
					</wea:item>
					<wea:item>
						<select class=inputstyle  name=sharelevel>
						  <option value="1" selected><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
						  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
						 </SELECT>
					</wea:item>
				</wea:group>
				</wea:layout>
			</form>
			
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

function checkNum(objName){
	var val=$('#'+objName).val();
	var arr = val.split("");//全部分割
	var ret="";
	for (var i = 0; i < arr.length; i++) {
		if(isNaN(arr[i])||(i==0&&arr[i]==0&&arr.length!=1)) continue;
		ret+=arr[i];
	}
	$('#'+objName).val(ret);
	return true;
} 
var flag=0;
function submitData()
{	if(flag!=0){
		return;
	}
	flag=1;
	thisvalue=document.weaver.sharetype.value;
	var sublevelids = jQuery("#sublevelids").val();
    var deplevelids = jQuery("#deplevelids").val();
    var joblevel = jQuery("#joblevel").val();
	var checkstr="";
	if (thisvalue == 1) {
		jQuery($GetEle("relatedshareid")).val(jQuery($GetEle("userided")).val());
		checkstr ="userided";
    } else if(thisvalue == 2){
		jQuery($GetEle("relatedshareid")).val(jQuery($GetEle("subidsd")).val());
		checkstr ="subidsd,seclevel,seclevelMax";
	}else if(thisvalue == 3){
		jQuery($GetEle("relatedshareid")).val(jQuery($GetEle("departmentided")).val());
		checkstr ="departmentided,seclevel,seclevelMax";
	}else if(thisvalue == 4){
		jQuery($GetEle("relatedshareid")).val(jQuery($GetEle("roleided")).val());
		checkstr ="roleided,seclevel,seclevelMax";
	}else if(thisvalue == 5){
		jQuery($GetEle("relatedshareid")).val("");
		checkstr ="seclevel,seclevelMax";
	}else if(thisvalue == 6||thisvalue == 9){
		jQuery($GetEle("relatedshareid")).val("");
		if(thisvalue == 6 && $("#companyVirtualSel").val() == '0'){
		  $("#companyVirtual").val('<%=virtualCompany%>');
		}else if(thisvalue == 6 && $("#companyVirtualSel").val() == '1'){
		  checkstr ="companyVirtual";
		}
	}else if (thisvalue == 8) {
	jQuery($GetEle("relatedshareid")).val("");
		if(joblevel==1){
    		checkstr ="jobid,sublevelids";
    	}else if(joblevel==2){
    		checkstr ="jobid,deplevelids";
    	}else{
    		checkstr ="jobid";
    	}
    }
 
	
	if(check_form(document.weaver,checkstr)){
		document.weaver.submit();
		//obj.disabled=true;
	}else{
		flag=0;
	}
}

jQuery(document).ready(function(){
	onLevelTypeChange();
	onChangeSharetype();
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

function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value;
	if (thisvalue == 1) {
		jQuery($GetEle("subidsdSP")).css("display","none");
		jQuery($GetEle("departmentidedSP")).css("display","none");
		jQuery($GetEle("useridedSP")).css("display","");
		jQuery($GetEle("roleidSPd")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("showseclevel")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","none");
		$("#showjoblevel").hide();
		hideEle("virtualSelect", true);
		document.weaver.seclevel.value=10;
    } else if(thisvalue == 2){
		jQuery($GetEle("subidsdSP")).css("display","");
		jQuery($GetEle("departmentidedSP")).css("display","none");
		jQuery($GetEle("useridedSP")).css("display","none");
		jQuery($GetEle("roleidSPd")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("showseclevel")).css("display","");
		jQuery($GetEle("jobidSP")).css("display","none");
		$("#showjoblevel").hide();
		hideEle("virtualSelect", true);
		document.weaver.seclevel.value=10;
	}else if(thisvalue == 3){
		jQuery($GetEle("subidsdSP")).css("display","none");
		jQuery($GetEle("departmentidedSP")).css("display","");
		jQuery($GetEle("useridedSP")).css("display","none");
		jQuery($GetEle("roleidSPd")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("showseclevel")).css("display","");
		jQuery($GetEle("jobidSP")).css("display","none");
		$("#showjoblevel").hide();
		hideEle("virtualSelect", true);
		document.weaver.seclevel.value=10;
	}else if(thisvalue == 4){
		jQuery($GetEle("subidsdSP")).css("display","none");
		jQuery($GetEle("departmentidedSP")).css("display","none");
		jQuery($GetEle("useridedSP")).css("display","none");
		jQuery($GetEle("roleidSPd")).css("display","");
		jQuery($GetEle("showrolelevel")).css("display","");
		jQuery($GetEle("showseclevel")).css("display","");
		jQuery($GetEle("jobidSP")).css("display","none");
		$("#showjoblevel").hide();
		hideEle("virtualSelect", true);
		document.weaver.seclevel.value=10;
	}else if(thisvalue == 5){
		jQuery($GetEle("subidsdSP")).css("display","none");
		jQuery($GetEle("departmentidedSP")).css("display","none");
		jQuery($GetEle("useridedSP")).css("display","none");
		jQuery($GetEle("roleidSPd")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("showseclevel")).css("display","");
		jQuery($GetEle("jobidSP")).css("display","none");
		hideEle("virtualSelect", true);
		$("#showjoblevel").hide();
		document.weaver.seclevel.value=10;
	}else if(thisvalue == 6||thisvalue == 9){
		jQuery($GetEle("subidsdSP")).css("display","none");
		jQuery($GetEle("departmentidedSP")).css("display","none");
		jQuery($GetEle("useridedSP")).css("display","none");
		jQuery($GetEle("roleidSPd")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("showseclevel")).css("display","none");
		document.weaver.seclevel.value=10;
		jQuery($GetEle("jobidSP")).css("display","none");
		$("#showjoblevel").hide();
		$("#showseclevel").hide();
		$("#showrolelevel").hide();
		if(thisvalue == 6){
		    <%
	        if(hasVirtual){
	        %>
	          showEle("virtualSelect");
	        <%
	        }
	        %>
		}
	}else if(thisvalue == 8){
		jQuery($GetEle("subidsdSP")).css("display","none");
		jQuery($GetEle("departmentidedSP")).css("display","none");
		jQuery($GetEle("useridedSP")).css("display","none");
		jQuery($GetEle("roleidSPd")).css("display","none");
		jQuery($GetEle("showrolelevel")).css("display","none");
		jQuery($GetEle("showseclevel")).css("display","none");
		jQuery($GetEle("jobidSP")).css("display","");
		hideEle("virtualSelect", true);
		$("#showjoblevel").show();
		$("#showseclevel").hide();
		$("#showrolelevel").hide();
	}

	//TD33012 切换时，增加对安全级别为空的提示；人力资源没有安全级别
	if($GetEle("seclevel").value==""&&thisvalue!=1){
		seclevelimage.innerHTML = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>"
	}
	//End TD33012
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
