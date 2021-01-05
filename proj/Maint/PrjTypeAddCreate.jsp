
<%@ page language="java" contentType="text/html; charset=UTF-8" %> <%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<%@ taglib uri="/browserTag" prefix="brow"%>
<%
String isclose = Util.null2String(request.getParameter("isclose"));
String isDialog = Util.null2String(request.getParameter("isdialog"));
int typeid = Util.getIntValue(request.getParameter("typeid"),0);
int operationcode = Util.getIntValue(request.getParameter("operationcode"),0);
if (typeid==-1) {
	response.sendRedirect("/base/error/DBError.jsp?type=FindData");
	return;
}
String authorityStr="";
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="/js/weaver_wev8.js"></script>
<LINK href="/wui/theme/ecology8/jquery/js/e8_zDialog_btn_wev8.css" type=text/css rel=STYLESHEET>
<script type="text/javascript">
var parentWin = parent.getParentWindow(window);
var dialog = parent.getDialog(window);
if("<%=isclose%>"=="1"){
	parentWin._table.reLoad();
	parentWin.closeDialog();	
}

jQuery(document).ready(function(){
	jQuery($GetEle("showrolelevel")).css("display","none");
	resizeDialog(document);
});
</script>
</HEAD>
<%

boolean canedit = HrmUserVarify.checkUserRight("EditProjectType:Edit",user);


String imagefilename = "/images/hdCRMAccount_wev8.gif";
String titlename = Util.null2String(request.getParameter("titlename"));
if("".equals(titlename)) titlename = SystemEnv.getHtmlLabelName(119,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<BODY style="overflow:hidden;">
<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="proj"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(21945,user.getLanguage()) %>"/>
</jsp:include>
<div class="zDialog_div_content">
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>

<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%

RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;
/*
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='"+CategoryUtil.getCategoryEditPage(categorytype, categoryid)+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
*/
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>
<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
		<td>
		</td>
		<td class="rightSearchSpan" style="text-align:right;">
			<input type="button" value="<%=SystemEnv.getHtmlLabelName(30986,user.getLanguage())%>" class="e8_btn_top" onclick="doSave(this);">
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</td>
	</tr>
</table>

<FORM id=mainform name=mainform action="PrjTypePermissionOperation.jsp" method=post onsubmit='return check_by_permissiontype()'>
  <input type="hidden" name="method" value="add">
  <input type="hidden" name="typeid" value="<%=typeid%>">
  <input type="hidden" name="operationcode" value="0">
  <input type="hidden" name="mutil" value="1">


<wea:layout>
	<wea:group context='<%=SystemEnv.getHtmlLabelName(440,user.getLanguage())%>'>
		<wea:item><%=SystemEnv.getHtmlLabelName(21956,user.getLanguage())%></wea:item>
		<wea:item>
				<SELECT style="width:160px;" class=InputStyle name=permissiontype onchange="onChangePermissionType()">
				  <option selected value="1"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
				  <option value="6"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
				  <option value="3"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option>
				  <option value="5"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%></option>
				  <option value="2"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option>
				  <option value="7"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option>
			    </SELECT>
		</wea:item>
		<wea:item><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
		<wea:item>
			<span id="showsubcompany" style="display:none;">
				<brow:browser viewType="0" name="subcompanyid" browserValue="" 
						_callback="afterOnShowDepartment"
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=#id#&selectedDepartmentIds=#id#"
						hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=164" temptitle='<%=SystemEnv.getHtmlLabelName(21957,user.getLanguage())%>'>
				</brow:browser>
			</span>
			<span id="showdepartment" style="display:'';">
				<brow:browser viewType="0" name="departmentid" browserValue="" 
						_callback="afterOnShowDepartment"
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=#id#&selectedDepartmentIds=#id#"
						hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=4" temptitle='<%=SystemEnv.getHtmlLabelName(21957,user.getLanguage())%>'>
				</brow:browser>
			</span>
			<span id="showrole" style="display:none;">
				<brow:browser viewType="0" name="roleid" browserValue="" 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp?selectedids=#id#"
						hasInput="true" isSingle="true" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=65" width="50%" temptitle='<%=SystemEnv.getHtmlLabelName(21957,user.getLanguage())%>'>
				</brow:browser>
			</span>
			<span id="showrolelevel"   style="display:none;">
						<%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%>
						  <SELECT style="width:60px;" class=InputStyle name=rolelevel>
							<option selected value="0"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
							<option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
							<option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
						  </SELECT>
					</span>
			<span id="showuser" style="display:none;">
			   <brow:browser viewType="0" name="userid" browserValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=#id#"
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp" linkUrl="javascript:openhrm($id$)" temptitle='<%=SystemEnv.getHtmlLabelName(21957,user.getLanguage())%>'
				></brow:browser>
			</span>
	        <span id="showrejob" style="display:none;">
			   <brow:browser viewType="0" name="jobtitleid" browserValue="" 
				browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?"
				hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
				completeUrl="/data.jsp?type=hrmjobtitles" />
			</span>
		</wea:item>
		<wea:item attributes="{'samePair':'seclevel_td','display':''}"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'seclevel_td','display':''}">
			 <span id=showseclevel name=showseclevel style="display:''">
			<INPUT type=text id=seclevel class=InputStyle style="width:30px;" name=seclevel size=6 value="10" onchange="checkinput('seclevel','seclevelimage')">
			<SPAN id=seclevelimage></SPAN>-
			<INPUT type=text id=seclevelmax class=InputStyle style="width:30px;" name=seclevelmax size=6 value="100" onchange="checkinput('seclevelmax','seclevelmaximage')">
			<SPAN id=seclevelmaximage></SPAN>
			</span>
		</wea:item>
		<wea:item attributes="{'samePair':'jobtitlescope','display':'none'}"><%=SystemEnv.getHtmlLabelName(28169,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'jobtitlescope','display':'none'}">
			  <SELECT style="width: 60px;float: left;" class=InputStyle name=joblevel onchange="getScope();">
				<option selected value="0"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
				<option value="1"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%>
				<option value="2"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%>
			  </SELECT>
			  <span id="showscopedept" style="display:none;">
			  <brow:browser viewType="0" name="scopedeptid" browserValue="" 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=#id#&selectedDepartmentIds=#id#"
						hasInput="true" isSingle="false" width="50%" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=4"  />
			  </span>
			  <span id="showscopesub" style="display:none;">
			  <brow:browser viewType="0" name="scopesubcomid" browserValue="" 
						browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=#id#&selectedDepartmentIds=#id#"
						hasInput="true" isSingle="false" width="50%" hasBrowser = "true" isMustInput='2'
						completeUrl="/data.jsp?type=164" />
			  </span>
			  <INPUT type=hidden name=scopeid value="">
		</wea:item>
	</wea:group>
</wea:layout> 
</FORM>

<script language=javascript>
onChangePermissionType();

function check_by_permissiontype() {
	if (document.mainform.permissiontype.value == 1) {
        return check_form(mainform, "departmentid,seclevel,seclevelmax");
    } else if (document.mainform.permissiontype.value == 2) {
        return check_form(mainform, "roleid,rolelevel,seclevel,seclevelmax");
    } else if (document.mainform.permissiontype.value == 3) {
        return check_form(mainform, "seclevel,seclevelmax");
    } else if (document.mainform.permissiontype.value == 5) {
        return check_form(mainform, "userid");
    } else if (document.mainform.permissiontype.value == 6) {
        return check_form(mainform, "subcompanyid,seclevel,seclevelmax");
    } else if (document.mainform.permissiontype.value == 7) {
    	jQuery("input[name=relatedshareid]").val(jQuery("#jobtitleid").val());
 		var joblevel = jQuery("select[name=joblevel]").val();
 		var checkstr="jobtitleid";
 		if(joblevel==1){
 			checkstr+=",scopedeptid";
 			jQuery("input[name=scopeid]").val(jQuery("#scopedeptid").val());
 		}else if(joblevel==2){
 			checkstr+=",scopesubcomid";
 			jQuery("input[name=scopeid]").val(jQuery("#scopesubcomid").val());
	 	}
        return check_form(mainform, checkstr);
    }else {
        return false;
    }
}

function doSave(obj) {
	var seclevelmain = jQuery("#seclevel").val();
	  var seclevelmax = jQuery("#seclevelmax").val();
	  if(parseInt(seclevelmain)>parseInt(seclevelmax)){
				window.top.Dialog.alert("<%=SystemEnv.getHtmlLabelName(82808,user.getLanguage())%>");
			    return;
	   }
    if (check_by_permissiontype()) {
    	obj.disabled=true;
	    document.mainform.submit();
	}
}

function onChangePermissionType() {
	thisvalue=document.mainform.permissiontype.value;
	//document.mainform.departmentid.value="";
	//document.mainform.roleid.value="";
	//document.mainform.userid.value="";
	if (thisvalue == 1) {
	    //jQuery($GetEle("showrelatedsharename")).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
 		jQuery($GetEle("showsubcompany")).css("display","none");
 		jQuery($GetEle("showdepartment")).css("display","");
 		jQuery($GetEle("showrole")).css("display","none");
 		jQuery($GetEle("showrolelevel")).css("display","none");
 		jQuery($GetEle("showrolelevelspan")).css("display","none");
 		jQuery($GetEle("showuser")).css("display","none");
 		jQuery($GetEle("showseclevel")).css("display","");
 		jQuery("span[id=showrejob]").hide();
 		showEle('seclevel_td');
 		hideEle('jobtitlescope');
    }
	else if (thisvalue == 2) {
	    //jQuery($GetEle("showrelatedsharename")).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
 		jQuery($GetEle("showsubcompany")).css("display","none");
 		jQuery($GetEle("showdepartment")).css("display","none");
 		jQuery($GetEle("showrole")).css("display","");
 		jQuery($GetEle("showrolelevel")).css("display","");
 		jQuery($GetEle("showrolelevelspan")).css("display","");
 		jQuery($GetEle("showuser")).css("display","none");
 		jQuery($GetEle("showseclevel")).css("display","");
 		jQuery("span[id=showrejob]").hide();
 		showEle('seclevel_td');
 		hideEle('jobtitlescope');
	}
	else if (thisvalue == 3) {
	    jQuery($GetEle("showrelatedsharename")).html("");
 		jQuery($GetEle("showsubcompany")).css("display","none");
 		jQuery($GetEle("showdepartment")).css("display","none");
 		jQuery($GetEle("showrole")).css("display","none");
 		jQuery($GetEle("showrolelevel")).css("display","none");
 		jQuery($GetEle("showrolelevelspan")).css("display","none");
 		jQuery($GetEle("showuser")).css("display","none");
 		jQuery($GetEle("showseclevel")).css("display","");
 		jQuery("span[id=showrejob]").hide();
 		showEle('seclevel_td');
 		hideEle('jobtitlescope');
	}
	else if (thisvalue == 5) {
	    //jQuery($GetEle("showrelatedsharename")).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
 		jQuery($GetEle("showsubcompany")).css("display","none");
 		jQuery($GetEle("showdepartment")).css("display","none");
 		jQuery($GetEle("showrole")).css("display","none");
 		jQuery($GetEle("showrolelevel")).css("display","none");
 		jQuery($GetEle("showrolelevelspan")).css("display","none");
 		jQuery($GetEle("showuser")).css("display","");
 		jQuery($GetEle("showseclevel")).css("display","none");
 		jQuery("span[id=showrejob]").hide();
 		showEle('seclevel_td');
 		hideEle('jobtitlescope');
	}
	else if (thisvalue == 6) {
	    //jQuery($GetEle("showrelatedsharename")).html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
 		jQuery($GetEle("showsubcompany")).css("display","");
 		jQuery($GetEle("showdepartment")).css("display","none");
 		jQuery($GetEle("showrole")).css("display","none");
 		jQuery($GetEle("showrolelevel")).css("display","none");
 		jQuery($GetEle("showrolelevelspan")).css("display","none");
 		jQuery($GetEle("showuser")).css("display","none");
 		jQuery($GetEle("showseclevel")).css("display","");
 		jQuery("span[id=showrejob]").hide();
 		showEle('seclevel_td');
 		hideEle('jobtitlescope');
	}else if (thisvalue == 7) {
		jQuery($GetEle("showsubcompany")).css("display","none");
 		jQuery($GetEle("showdepartment")).css("display","none");
 		jQuery($GetEle("showrole")).css("display","none");
 		jQuery($GetEle("showrolelevel")).css("display","none");
 		jQuery($GetEle("showrolelevelspan")).css("display","none");
 		jQuery($GetEle("showuser")).css("display","none");
 		jQuery($GetEle("showseclevel")).css("display","none");
		hideEle('seclevel_td');
		showEle('jobtitlescope');
		jQuery("span[id=showrejob]").show();
	}
}

function getScope(){
	thisvalue = jQuery("select[name=joblevel]").val();
	jQuery("input[name=scopeid]").val("");
	if(thisvalue==0){
		jQuery("span[id=showscopesub]").hide();
		jQuery("span[id=showscopedept]").hide();
	}else if(thisvalue==1){
		jQuery("span[id=showscopesub]").hide();
		jQuery("span[id=showscopedept]").show();
	}else if(thisvalue==2){
		jQuery("span[id=showscopesub]").show();
		jQuery("span[id=showscopedept]").hide();
	}
}

function afterOnShowDepartment(e,datas,fieldid,params){
	if (datas) {
		$GetEle("mutil").value = "1"
	}else{
	
	}
}

</script>
	</div>
	<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout needImportDefaultJsAndCss="false">
		<wea:group context=""  attributes="{\"groupDisplay\":\"none\"}">
			<wea:item type="toolbar">
		    	<input class="zd_btn_cancle" type="button" name="cancel" onclick="parentWin.closeDialog();"  value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage())%>"/>
			</wea:item>
		</wea:group>
	</wea:layout>
	
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include>  
</BODY>
</HTML>
