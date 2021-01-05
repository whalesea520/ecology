
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ taglib uri="/WEB-INF/weaver.tld" prefix="wea"%>
<jsp:useBean id="DepartmentComInfo" class="weaver.hrm.company.DepartmentComInfo" scope="page" />
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="RecordSetShare" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="ResourceComInfo" class="weaver.hrm.resource.ResourceComInfo" scope="page"/>
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="RecordSetV" class="weaver.conn.RecordSet" scope="page" />

<%
String crmtypename = Util.null2String(request.getParameter("crmtypename"));
String typeid = Util.null2String(request.getParameter("typeid"));
String itemtype = Util.null2String(request.getParameter("itemtype"));
String isclose = Util.null2String(request.getParameter("isclose"));

//out.print(typeid);
boolean canedit_share = HrmUserVarify.checkUserRight("EditCustomerType:Edit",user);

if(!canedit_share) {
	response.sendRedirect("/notice/noright.jsp") ;
	return ;
 }
%>

<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(119,user.getLanguage())+"- "+SystemEnv.getHtmlLabelName(1282,user.getLanguage())+":"+Util.toScreen(crmtypename,user.getLanguage(),"0");
String needfav ="1";
String needhelp ="";
%>
<BODY>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:checkSubmit(),''} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<jsp:include page="/systeminfo/commonTabHead.jsp">
   <jsp:param name="mouldID" value="customer"/>
   <jsp:param name="navName" value="<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage()) %>"/>
</jsp:include>

<wea:layout attributes="{layoutTableId:topTitle}">
	<wea:group context="" attributes="{groupDisplay:none}">
		<wea:item attributes="{'customAttrs':'class=rightSearchSpan'}">
			<span title="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>" style="font-size: 12px;cursor: pointer;">
				<input class="e8_btn_top middle" onclick="checkSubmit()" type="button"  value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage()) %>"/>
			</span>
			<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span>
		</wea:item>
	</wea:group>
</wea:layout>

<FORM id=weaver name=weaver action="/CRM/data/TypeShareOperation.jsp" method=post >
<input type="hidden" name="method" value="add">
<input type="hidden" name="typeid" value="<%=typeid%>">
<input type="hidden" name="itemtype" value="<%=itemtype%>">
<input type="hidden" name="relatedshareid" id="relatedshareid">

<wea:layout>
	<wea:group context='<%= SystemEnv.getHtmlLabelName(1361,user.getLanguage())%>'>

		<wea:item><%=SystemEnv.getHtmlLabelName(21956,user.getLanguage())%></wea:item>
		<wea:item attributes="{'customAttrs':'class=field'}">
			<SELECT  class=InputStyle name=sharetype onchange="onChangeSharetype()" style="width: 120px;">
			  <option value="1"><%=SystemEnv.getHtmlLabelName(179,user.getLanguage())%>
			  <option value="2" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
			  <option value="5"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
			  <option value="3"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%>
			  <option value="4"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%>
			  <option value="6"><%=SystemEnv.getHtmlLabelName(28169,user.getLanguage())%>
			</SELECT>
		</wea:item>
		
		<wea:item attributes="{'samePair':'showsharetype'}"><%=SystemEnv.getHtmlLabelName(106,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'showsharetype'}">
			<div id="resourceDiv">
				<brow:browser viewType="0" name="relatedshareid_1" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/ResourceBrowser.jsp"
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp" width="180px" ></brow:browser> 
			</div>
			
			<div id="departmentDiv">
				<brow:browser viewType="0" name="relatedshareid_2" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp"
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp?type=57" width="180px;" ></brow:browser> 
			</div>
			
			<div id="subcompanyDiv">
				<brow:browser viewType="0" name="relatedshareid_5" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp"
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp?type=164" width="180px" ></brow:browser> 
			</div>
			
			<div id="roleDiv">
				<brow:browser viewType="0" name="relatedshareid_3" 
			         browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp"
			         isSingle="true" hasBrowser="true"  hasInput="true" isMustInput='2'
			         completeUrl="/data.jsp?type=65" width="180px" ></brow:browser> 
			</div>
			<span id="showjobtitle" style="display:none">
				<brow:browser viewType="0" name="relatedshareid_6" browserValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp?resourceids="
					hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
					completeUrl="/data.jsp?type=24" width="60%" browserSpanValue="" >
				</brow:browser>
			</span>
			
		</wea:item>
		
		<wea:item attributes="{'samePair':'item_jobtitlelevel'}"><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'item_jobtitlelevel'}">
			<SELECT id=jobtitlelevel name=jobtitlelevel onchange="onjobtitlelevelChange()" style="float: left;">
				<option value="0" selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
				<option value="1"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%>
				<option value="2"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%>
			</SELECT>
			<span id="showjobtitlesubcompany" style="display:none">
				<brow:browser viewType="0" name="jobtitlesubcompany" browserValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiSubcompanyBrowser.jsp?selectedids="
					hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
					completeUrl="/data.jsp?type=164" width="60%" browserSpanValue="">
				</brow:browser>
			</span>
			<span id="showjobtitledepartment" style="display:none">
				<brow:browser viewType="0" name="jobtitledepartment" browserValue="" 
					browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="
					hasInput="true" isSingle="false" hasBrowser = "true" isMustInput='2'
					completeUrl="/data.jsp?type=4" width="60%" browserSpanValue="">
				</brow:browser>
			</span>
		</wea:item>
		<wea:item attributes="{'samePair':'showrolelevel'}"><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'showrolelevel'}">
			<SELECT name=rolelevel>
				<option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%>
				<option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%>
				<option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%>
			</SELECT>
		</wea:item>
		<wea:item attributes="{'samePair':'showseclevel'}"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></wea:item>
		<wea:item attributes="{'samePair':'showseclevel'}">
			<wea:required id="seclevelimage" required="true">
				<INPUT class=InputStyle maxLength=3 size=5 name=seclevel onKeyPress="ItemCount_KeyPress()" 
					onBlur='checknumber("seclevel");checkinput("seclevel","seclevelimage")' value="10" style="width: 68px;">
			</wea:required>
				-
			<wea:required id="seclevelMaximage" required="true">
				<INPUT class=InputStyle maxLength=3 size=5 name=seclevelMax onKeyPress="ItemCount_KeyPress()" 
					onBlur='checknumber("seclevelMax");checkinput("seclevelMax","seclevelMaximage")' value="100" style="width: 68px;">
			</wea:required>
		 </wea:item>
		 
		 <wea:item><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%><%=SystemEnv.getHtmlLabelName(139,user.getLanguage())%></wea:item>
		 <wea:item>
		 	<SELECT class=InputStyle  name=sharelevel style="width:120px;">
			  <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%>
			  <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%>
			</SELECT>
		 </wea:item>
	</wea:group>
</wea:layout>
</FORM>

<div id="zDialog_div_bottom" class="zDialog_div_bottom">
	<wea:layout>
		<wea:group context="" attributes="{groupDisplay:none}">
			<wea:item type="toolbar">
				<input type="button" value="<%=SystemEnv.getHtmlLabelName(309,user.getLanguage()) %>" id="zd_btn_cancle"  class="zd_btn_cancle" onclick="parentWin.closeDialog();">
			</wea:item>
		</wea:group>
	</wea:layout>
</div>
<jsp:include page="/systeminfo/commonTabFoot.jsp"></jsp:include> 

<script language=javascript>

  jQuery(function(){
  	hideEle("showrolelevel","true");
  	checkinput("seclevel","seclevelimage");
  	checkinput("seclevelMax","seclevelMaximage")
  	
  	jQuery("#resourceDiv").hide();
	jQuery("#subcompanyDiv").hide();
	jQuery("#roleDiv").hide();
	
	hideEle("item_seclevel");
	hideEle("item_jobtitlelevel");
  	
  });
  	
  function onChangeSharetype(){
	thisvalue=document.weaver.sharetype.value;
  	
	showEle('showseclevel',"true");
	showEle('showsharetype',"true");
	hideEle("showrolelevel","true");
	hideEle("item_seclevel");
	hideEle("showrolelevel");
	hideEle("item_jobtitlelevel");
	$GetEle("showjobtitle").style.display='none';
	$GetEle("showjobtitlesubcompany").style.display='none';
	$GetEle("showjobtitledepartment").style.display='none';
	
	jQuery("#resourceDiv").hide();
	jQuery("#departmentDiv").hide();
	jQuery("#subcompanyDiv").hide();
	jQuery("#roleDiv").hide();
	
	
	if(thisvalue==1){
		hideEle('showseclevel','true');
		jQuery("#resourceDiv").show();
	}
	
	if(thisvalue==2){
 		jQuery("#departmentDiv").show();
	}

	if(thisvalue==3){
 		jQuery("#roleDiv").show();
		showEle("showrolelevel","true");
	}
	if(thisvalue==4){
		hideEle("showsharetype","true");
	}
	if(thisvalue==5){
 		jQuery("#subcompanyDiv").show();
	}
	if(thisvalue==6){
		$GetEle("showjobtitle").style.display='';
		showEle("item_jobtitlelevel");
		hideEle('showseclevel','true');
		document.frmMain.seclevel.value=0;
		document.frmMain.seclevelto.value=0;
	}
}

function checkSubmit(){
	thisvalue=document.weaver.sharetype.value;
	if(thisvalue==4){
		jQuery("#relatedshareid").val("");
	}else{
		jQuery("#relatedshareid").val(jQuery("#relatedshareid_"+thisvalue).val());
	}
	
	var checkinfo = "relatedshareid,seclevel,seclevelMax";
	if(thisvalue==1){//人力资源
		checkinfo = "relatedshareid";
	}
	if(thisvalue==4){//所有人
		checkinfo = "";
	}
    if(check_form(weaver,checkinfo)){
    	enableAllmenu(); //禁用所有按钮
        weaver.submit();
    }
}

function onjobtitlelevelChange(){
	$GetEle("showjobtitlesubcompany").style.display='none';
	$GetEle("showjobtitledepartment").style.display='none';
	if(jQuery("#jobtitlelevel").val()=="1"){
		$GetEle("showjobtitledepartment").style.display='';
	}else if(jQuery("#jobtitlelevel").val()=="2"){
		$GetEle("showjobtitlesubcompany").style.display='';
	}
}
</script>

<script type="text/javascript">
function doClick(){
	location.href="/CRM/Maint/EditCustomerType.jsp?id=<%=typeid%>"
}

var parentWin = parent.getParentWindow(window);
if("<%=isclose%>"=="1"){
	parentWin.location = "/CRM/Maint/EditCustomerTypeInner.jsp?id=<%=typeid%>&winfo=2";
	parentWin.closeDialog();
}
</script>

</BODY>
</HTML>
