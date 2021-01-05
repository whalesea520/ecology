
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />

<%
int modeId = Util.getIntValue(request.getParameter("modeId"),0);

int formId = Util.getIntValue(request.getParameter("formId"),0);
String billids = Util.null2String(request.getParameter("billids"));
String customid = Util.null2String(request.getParameter("customid"));
%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<BODY>
<%
String imagefilename = "/images/hdCRMAccount_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16526,user.getLanguage());//权限设置
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;//保存
RCMenuHeight += RCMenuHeightStep ;
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:location.href='/formmode/search/CustomSearchBySimpleIframe.jsp?customid="+customid+"',_self} " ;//取消
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<table id="topTitle" cellpadding="0" cellspacing="0">
	<tr>
	<td></td>
	<td class="rightSearchSpan" style="text-align:right;">
		<input type="button" value="<%=SystemEnv.getHtmlLabelName(86,user.getLanguage())%>" id="zd_btn_save" class="e8_btn_top" onclick="javascript:doSave(this)">
		<span title="<%=SystemEnv.getHtmlLabelName(23036,user.getLanguage())%>" class="cornerMenu"></span><!-- 菜单 -->
	</td>
	</tr>
</table>
<table width=100% height=100% border="0" cellspacing="0" cellpadding="0">
<colgroup>
<col width="10">
<col width="">
<col width="10">
<tr>
	<td height="10" colspan="3"></td>
</tr>
<tr>
	<td ></td>
	<td valign="top">
		<TABLE class=Shadow>
		<tr>
		<td valign="top">
<FORM id=weaver name=weaver action="/formmode/view/ModeShareOperation.jsp" method=post onsubmit='return check_by_permissiontype()'>
  <input type="hidden" name="method" value="addShareMore">
  <input type="hidden" name="batchShare" value="1">  <!-- 数据提交的时候无需校验权限 -->
  <input type="hidden" name="modeId" value="<%=modeId%>">
  <input type="hidden" name="relatedid" id="relatedid" value="">
  <input type="hidden" name="billids" value="<%=billids%>">
  <input type="hidden" name="customid" value="<%=customid%>">
  
  <table class="e8_tblForm">
    <COLGROUP>
		<COL width="20%">
  		<COL width="80%">
    </COLGROUP>
    <TBODY>
     <TR><!-- 共享类型 -->
       <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></TD>
       <TD class="e8_tblForm_field">
         <SELECT class=InputStyle  name=sharetype onChange="onChangeSharetype()" >  
           <option value="1" selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> <!-- 人员 -->
           <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
           <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
           <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option><!-- 角色 -->
           <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option><!-- 所有人 -->
           <option value="6"><%=SystemEnv.getHtmlLabelName(6086,user.getLanguage())%></option><!-- 岗位 -->
         </SELECT>
         
         <span id="orgrelationspan" style="display:none;width: 220px;" >
         <select class=InputStyle id="orgrelation" name="orgrelation" onchange="" style="width: 80px;">
         	<option value=""></option>
         	<option value="1"><%=SystemEnv.getHtmlLabelName(15762,user.getLanguage())%></option><!-- 所有上级 -->
         	<option value="2"><%=SystemEnv.getHtmlLabelName(15765,user.getLanguage())%></option><!-- 所有下级 -->
         </select>
         </span>
       </TD>
     </TR>
     <tr id="tr_virtualtype" style="display: none">
     	<td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(34069, user.getLanguage()) %></td>
     	<td class="e8_tblForm_field">
     		<select id="HrmCompanyVirtual" name="HrmCompanyVirtual">
     			<option value="0"><%=SystemEnv.getHtmlLabelName(83179, user.getLanguage()) %></option>
     			<%
     				RecordSet.executeSql("select * from HrmCompanyVirtual  where (canceled is null or canceled<>1) order by showorder");
     				while(RecordSet.next()){
     					String id = Util.null2String(RecordSet.getString("id"));
     					String companyname = Util.null2String(RecordSet.getString("companyname"));
     			 %>
     			 <option value="<%=id%>"><%=companyname %></option>
     			 <%} %>
     		</select>
     		
     	</td>
     </tr>
     <TR id="browserTr">
     	<TD class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%><!-- 选择 --></TD>
     	<TD class="e8_tblForm_field">
     	 <span id="showspan1">
         	<brow:browser viewType="0" name="relatedid1" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=1" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
         <span id="showspan2" style="display:none;">
         	<brow:browser viewType="0" name="relatedid2" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=&selectedDepartmentIds=" 
         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=164" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
         <span id="showspan3" style="display:none;">
         	<brow:browser viewType="0" name="relatedid3" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=4" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
         <span id="showspan4" style="display:none;">
         	<brow:browser viewType="0" name="relatedid4" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" 
         		hasInput="true"  width="50%" isSingle="true" hasBrowser="true" completeUrl="/data.jsp?type=65" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
         <span id="showspan6" style="display:none;">
         	<brow:browser viewType="0" name="relatedid6" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/jobtitles/MutiJobTitlesBrowser.jsp" 
         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=24" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
     	</TD>
     </TR>
     
     <TR id="isRoleLimitedTr" style="display: none;" >
     	<TD class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(82385,user.getLanguage())%></TD><!-- 角色是否受范围限制 -->
     	<TD class="e8_tblForm_field">
     		<table style="width: 90%;">
     			<colgroup>
		   			<col style="width: 15%"  />
		   			<col style="width: 20%"  />
		   			<col style="width: 15%"  />
		   			<col style="width: 35%"  />
		   		</colgroup>
     			<tr>
     				<td>
	     				<SELECT id="isRoleLimited"  name="isRoleLimited" style="width:60px;" onchange="changeRoleLimited()">
				           <option value="0"><%=SystemEnv.getHtmlLabelName(30587,user.getLanguage())%></option><!-- 否 -->
				           <option value="1"><%=SystemEnv.getHtmlLabelName(30586,user.getLanguage())%></option><!-- 是 -->
				       </SELECT>
			       </td>
     				<td id="isRoleLimitedTd2" style="display: none;">
					         <span><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></span><!-- 字段类型 -->
					         <select class=InputStyle id="rolefieldtype" name="rolefieldtype" onchange="roleFieldTypeChange()" >
					         	<option value="1"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
					         	<option value="2"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option>
					         	<option value="3"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option>
					         </select>
     				</td>
     				<td id="isRoleLimitedTd3" style="display: none;"><%=SystemEnv.getHtmlLabelName(82386,user.getLanguage())%></td><!-- 限制字段 -->
     				<td id="isRoleLimitedTd4" style="display: none;">
	     				<brow:browser viewType="0" name="rolefield" browserValue="" browserOnClick="" getBrowserUrlFn="rolefiledChange" 
			         		hasInput="false"  width="260px;" isSingle="false" hasBrowser="true" completeUrl="/data.jsp" browserSpanValue="" isMustInput="2">
			         	</brow:browser>
     				</td>
     			</tr>
     		</table>
     	</TD>
     </TR>
     
     <!-- 角色级别 -->
     <TR id=rolelevel_tr name=id=rolelevel_tr style="display:none">
       <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></td>
       <TD class="e8_tblForm_field">
           <SELECT  name=rolelevel>
	           <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><!-- 部门 -->
	           <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><!-- 分门 -->
	           <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><!-- 总部 -->
	       </SELECT>
       </td>
     </TR>
      <!-- 岗位级别 -->
     <TR id=joblevel_tr name=id=joblevel_tr style="display:none">
       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(28169,user.getLanguage())%></td>
       <TD class="e8_tblForm_field">
           <SELECT  name=joblevel style="width:100px;float: left;" onchange="onJoblevelChange();">
	           <option value="0"><%=SystemEnv.getHtmlLabelName(19438,user.getLanguage())%><!-- 部门 -->
	           <option value="1"><%=SystemEnv.getHtmlLabelName(19437,user.getLanguage())%><!-- 分门 -->
	           <option value="2" selected><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><!-- 总部 -->
	       </SELECT>
	       <span id="joblevel_1" style="display:none;">
         	<brow:browser viewType="0" name="jobleveltext1" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids=&selectedDepartmentIds=" 
         		hasInput="true"  width="40%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=164" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         	</span>
       	 	<span id="joblevel_0" style="display:none;">
         	<brow:browser viewType="0" name="jobleveltext0" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids=" 
         		hasInput="true"  width="40%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=167" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         	</span>
         	<input type="hidden" id="jobleveltext" name="jobleveltext" value=""/>
       </td>
     </TR>
     <!-- 安全级别 -->
     <TR  id=showlevel_tr name=showlevel_tr style="display:none;height: 1px">
       <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
       <TD class="e8_tblForm_field">
       	 <INPUT type=text name="showlevel" id="showlevel" onblur="checkLevel('showlevel','showlevel2',this)" class=InputStyle size=6 value="10" onchange='checkinput("showlevel","showlevelimage")' onKeyPress="ItemCount_KeyPress()">
         <span id=showlevelimage></span>-
         <INPUT type=text name="showlevel2" id="showlevel2" onblur="checkLevel('showlevel','showlevel2',this)" class=InputStyle size=6 value=""  onKeyPress="ItemCount_KeyPress()">
       </TD>
     </TR>
     <!-- 权限项 -->
     <TR>
       <TD class="e8_tblForm_label"><%=SystemEnv.getHtmlLabelName(440,user.getLanguage())%></td>
       <TD class="e8_tblForm_field">
         <SELECT class=InputStyle  name=righttype >
	         <option value="1"><%=SystemEnv.getHtmlLabelName(367,user.getLanguage())%></option>
			 <option value="2"><%=SystemEnv.getHtmlLabelName(93,user.getLanguage())%></option>
			 <option value="3"><%=SystemEnv.getHtmlLabelName(17874,user.getLanguage())%></option>
		 </SELECT>
       </TD>
     </TR>
     
     <TR>
       <TD  colspan=2><br/>
         <TABLE  width="100%">
           <TR>
     		<TD width="*" style="font-weight: bold;"><%=SystemEnv.getHtmlLabelName(26137,user.getLanguage())%><!-- 共享权限 --></TD>
        	<TD width="300px" align="right">
        	<button
		      	type="button"
		      	id="savebutton" name="savebutton"
		      	title="<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>" 
		      	class="addbtn2" 
		      	onClick="addValue()"></button><!-- 添加共享 -->
		    <button
		      	type="button"
		      	id="delbutton" name="delbutton"
		      	title="<%=SystemEnv.getHtmlLabelName(18646,user.getLanguage())%>" 
		      	class="deletebtn2" 
		      	onClick="removeValue()"></button><!-- 删除共享 -->
        	</TD>
           </TR>
         </TABLE>
       </TD>
     </TR>
     <tr>
       <td colspan=2>
         <table class="listStyle" id="oTable" name="oTable" style="margin-top: 5px;">
             <colgroup>
             <col width="3%">
             <col width="20%">
             <col width="20%">
             <col width="17%">
             <col width="20%">
             <col width="20%">
             <tr class="header">
                 <th><input type="checkbox" name="chkAll" onClick="chkAllClick(this)"></th>
                 <th><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></th><!-- 共享类型 -->
                 <th><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></th><!-- 共享 -->
                 <th><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></th><!-- 共享级别 -->
                 <th><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></th><!-- 安全级别 -->
                 <th><%=SystemEnv.getHtmlLabelName(385,user.getLanguage())%></th><!-- 权限 -->
             </tr>
         </table>
       </td>
  	  </tr>
    </TBODY>
  </TABLE>
</FORM>

		</td>
		</tr>
		</TABLE>
	</td>
	<td></td>
</tr>
<tr>
	<td height="10" colspan="3"></td>
</tr>
</table>

<script language=javascript>
function onChangeSharetype(){
	var thisvalue=$GetEle("sharetype").value;	
    var strAlert= ""
    $("span[id^='showspan']").css('display','none');
	if(thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4 || thisvalue==6){//需要浏览框
		$GetEle("browserTr").style.display = '';
		$GetEle("showspan"+thisvalue).style.display='';	//浏览框
	}else{
		$GetEle("browserTr").style.display = 'none';
		//$GetEle("showspan").style.display='none';	//不需要浏览框
	}
	if(thisvalue==6){
		jQuery("#joblevel_tr").show();
	}else{
		jQuery("#joblevel_tr").hide();
	}
	var isRoleLimitedTr = jQuery("#isRoleLimitedTr");
	if(thisvalue != 4){
		$GetEle("rolelevel_tr").style.display='none';	//角色级别
		isRoleLimitedTr.hide();
	}else{
		$GetEle("rolelevel_tr").style.display='';	//需要角色级别
		changeRoleLimited();
	}
	if(thisvalue == 1){//人员不需要安全级别
		$GetEle("showlevel_tr").style.display='none';	//安全级别
	}else{
		$GetEle("showlevel_tr").style.display='';	//安全级别
	}
	changeOrgRelationShow();
}
function onJoblevelChange(){
	var joblevel = $GetEle("joblevel").value;
	jQuery("#jobleveltext").val('');
	if(joblevel=='0'){//指定部门
		jQuery("#joblevel_0").show();
		jQuery("#joblevel_1").hide();
	}else if(joblevel=='1'){//指定分部
		jQuery("#joblevel_1").show();
		jQuery("#joblevel_0").hide();
	}else{//总部
		jQuery("#joblevel_0").hide();
		jQuery("#joblevel_1").hide();
	}
}
var isNeedOrgRelation = false;//是否需要组织关系
function changeOrgRelationShow(){
	var sharetype = $("select[name=sharetype]").val();
	if(sharetype==3||sharetype==2){//部门     分部
		isNeedOrgRelation = true;
	}else{
		isNeedOrgRelation = false;
	}
	$("#orgrelation").selectbox("detach");
	$("#orgrelation").val("");
	$("#orgrelation").selectbox("attach");
	if(isNeedOrgRelation){
		$("#orgrelationspan").show();
	}else{
		$("#orgrelationspan").hide();
	}
}

function checkLevel(befEleName,aftEleName,obj){
	var bef = jQuery("[name="+befEleName+"]");
	var aft = jQuery("[name="+aftEleName+"]");
	if(isNaN(bef.val())){
		bef.val("");
	}
	if(isNaN(aft.val())){
		aft.val("");
	}
	if(bef.val()==""&&aft.val()!=""){
		if(aft.val()<10){
			bef.val(aft.val());
			checkinput("showlevel","showlevelimage");
			return;
		}else{
			bef.val("10");
			checkinput("showlevel","showlevelimage");
		}
		
	}
	if(bef.val()==""||aft.val()==""){
		return;
	}
	if(parseInt(bef.val())>parseInt(aft.val())){
		obj.value = "";
		if(obj.name==befEleName){
			bef.val(aft.val());
			checkinput("showlevel","showlevelimage");
		}else{
			Dialog.alert("<%=SystemEnv.getHtmlLabelName(82808,user.getLanguage())%>");
		}
	}
}

function changeRoleLimited(){
	var isRoleLimitedTr = jQuery("#isRoleLimitedTr");
	
	var isRoleLimitedTd2 = jQuery("#isRoleLimitedTd2");
	var isRoleLimitedTd3 = jQuery("#isRoleLimitedTd3");
	var isRoleLimitedTd4 = jQuery("#isRoleLimitedTd4");
	
	var isRoleLimited = jQuery("#isRoleLimited");
	isRoleLimitedTr.show();
	if(isRoleLimited.val()==1){
		isRoleLimitedTd2.show();
		isRoleLimitedTd3.show();
		isRoleLimitedTd4.show();
	}else{
		isRoleLimitedTd2.hide();
		isRoleLimitedTd3.hide();
		isRoleLimitedTd4.hide();
	}
	changeRolelevelShow();
}

function roleFieldTypeChange(){
	var relatedid1001 = jQuery("#rolefield");
	var relatedid1001span = jQuery("#rolefieldspan");
	var relatedid1001spanimg = jQuery("#rolefieldspanimg");
	
	relatedid1001.val("");
	relatedid1001span.html("");
	relatedid1001spanimg.html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
	changeRolelevelShow();
}

function changeRolelevelShow(){
	var isRoleLimited = jQuery("#isRoleLimited").val();
	var rolelevel_tr = jQuery("#rolelevel_tr");
	var rolefieldtype = jQuery("#rolefieldtype").val();
	var sharetype = jQuery("[name=sharetype]").val();
	if(sharetype!=4){
		rolelevel_tr.hide();
		return;
	}
	if(sharetype==4&&isRoleLimited==0){
		rolelevel_tr.show();
		return;
	}
	
	if(sharetype==4&&isRoleLimited==1&&rolefieldtype==1){
		rolelevel_tr.show();
		return;
	}else{
		rolelevel_tr.hide();
		return;
	}
	
}

function rolefiledChange(){
    var tmpval = $GetEle("rolefieldtype").value;
    var selectedids = $GetEle("rolefield").value;
	var tempurl1 = "/systeminfo/BrowserMain.jsp?url=/formmode/setup/MultiFormmodeShareFieldBrowser.jsp?type="+tmpval+"&selectedids="+selectedids+"&modeId=<%=modeId%>&isRoleLimited=1";
	return tempurl1;
}

function changeFieldType(obj){
	if(obj.value=='1'){
		jQuery("#showlevel_tr").hide();
	}else{
		jQuery("#showlevel_tr").show();
	}
	$GetEle("showspan").style.display='';	//浏览框
	$GetEle("relatedid").value="";
	$GetEle("showrelatedname").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
}

function onShowRelated(inputname,spanname){
	var sharetype = $G("sharetype").value;
	var datas = "";
	if(sharetype == '1'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+inputname.value);
	}else if(sharetype == '2'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+inputname.value+"&selectedDepartmentIds="+inputname.value);
	}else if(sharetype == '3'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+inputname.value);
	}else if(sharetype == '4'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
	}
	if (datas != undefined && datas != null) {
		var ids = "";
		var names = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		if(datas.id != ''){
			if(sharetype != '4' && sharetype != '1000'){
				//ids = datas.id.substring(1);
				//names = datas.name.substring(1);
				ids = datas.id;
				names = datas.name;
			}else{
				ids = datas.id;
				names = datas.name;
			}
			inputname.value = ids;
			spanname.innerHTML = names;
		}else{
			inputname.value = ids;
			spanname.innerHTML = names;
		}
	}
}


function addValue(){
	thisvalue=$GetEle("sharetype").value;
	var shareTypeValue = thisvalue;
	var shareTypeText = $GetEle("sharetype").options.item($GetEle("sharetype").selectedIndex).text;
	//人力资源(1),分部(2),部门(3),角色后的那个选项值不能为空(4)
	var orgrelation = $("#orgrelation").val();
	if(isNeedOrgRelation){
		if(orgrelation==""){
			orgrelation = "0";
		}else{
			var text = $GetEle("orgrelation").options.item($GetEle("orgrelation").selectedIndex).text;
			shareTypeText += " - "+text;
		}
	}else{
		orgrelation = "0";
	}
	var relatedids="0";
	var relatedShareNames="";
	var joblevel = "0";
	var jobleveltext = "0";
	if (thisvalue==1||thisvalue==2||thisvalue==3||thisvalue==4||thisvalue==6||thisvalue==1000) {
	    $GetEle("relatedid").value = $GetEle("relatedid"+thisvalue).value;
	    if(!check_form(document.weaver,'relatedid')) {
	        return ;
	    }
	    if (thisvalue == 4){
	        if (!check_form(document.weaver,'rolelevel')){
	            return;
	        }
	        var isRoleLimited = jQuery("#isRoleLimited").val();
        	if(isRoleLimited==1){
        		 if (!check_form(document.weaver,'rolefield')){
		            return;
		        }
        	}
	    }
	    if(thisvalue == 6){
	    	joblevel = $GetEle("joblevel").value;
	    	if(joblevel=='0'||joblevel=='1'){
	    		jobleveltext = $GetEle("jobleveltext"+joblevel).value;
	    		$GetEle("jobleveltext").value = jobleveltext;
		    	if (!check_form(document.weaver,'jobleveltext')){
		            return;
		        }
	    	}else{
	    		$GetEle("jobleveltext").value = '';
	    	}
	    }
	    relatedids = $GetEle("relatedid").value;
	    relatedShareNames = $GetEle("relatedid"+thisvalue+"span").innerHTML;
	    if(thisvalue==1||thisvalue==2||thisvalue==3){
	    	//relatedShareNames="("+jQuery("#HrmCompanyVirtual :selected").text()+")"+relatedShareNames
	    }
	}
	if(thisvalue != 1){
    	if (!check_form(document.weaver,'showlevel'))
            return;
    }
	var showlevelValue="0";
	var showlevelValue2="";
	var showlevelText="";
	if (thisvalue!=1) {
	    showlevelValue = $GetEle("showlevel").value;
	    showlevelText = showlevelValue;
	    showlevelValue2 = $GetEle("showlevel2").value;
	    if(showlevelValue2!=""&&!isNaN(showlevelValue2)){
	    	showlevelText += " - "+showlevelValue2;
	    }else{
	    	showlevelValue2 = "";
	    }
	}
	var rolelevelValue=0;
	var rolelevelText="";
	if (thisvalue==4){  //角色  0:部门   1:分部  2:总部
	   	rolelevelValue = $GetEle("rolelevel").value;
	    	rolelevelText = $GetEle("rolelevel").options.item($GetEle("rolelevel").selectedIndex).text;
	}else if(thisvalue==6){
		var joblevelspan = '';
		if(joblevel=='0'||joblevel=='1'){
			joblevelspan = '('+$GetEle("jobleveltext"+joblevel+"span").innerHTML+')';
		}
		rolelevelText = $GetEle("joblevel").options.item($GetEle("joblevel").selectedIndex).text+joblevelspan;
	}
	
	var righttypeValue =  $GetEle("righttype").value;
	var righttypelText = $GetEle("righttype").options.item($GetEle("righttype").selectedIndex).text;
	var hrmCompanyVirtualValue = $GetEle("HrmCompanyVirtual").value
	//共享类型 + 共享者ID +共享角色级别 +共享级别+共享权限+下载权限(TD12005)
	var totalValue=shareTypeValue+"_"+relatedids+"_"+rolelevelValue+"_"+showlevelValue;
	if(showlevelValue2!=""){
		totalValue +="$"+showlevelValue2;
	}
	totalValue += "_"+righttypeValue+"_"+righttypelText+"_"+hrmCompanyVirtualValue+"_"+orgrelation;
	totalValue += "_"+joblevel+"_"+jobleveltext;
	
	var isRoleLimited = jQuery("#isRoleLimited").val();
	if(isRoleLimited==1){
		var tempRoleValue = "1";
		var rolefieldtype = jQuery("#rolefieldtype").val();
		var rolefield = jQuery("#rolefield").val();
		tempRoleValue += "_"+rolefieldtype+"_"+rolefield;
		totalValue += "_"+tempRoleValue;
	}else{
		var tempRoleValue = "0";
		totalValue += "_"+tempRoleValue;
	}
	var oRow = oTable.insertRow(-1);
	var oRowIndex = oRow.rowIndex;
	
	if (oRowIndex%2==0) oRow.className="dataLight";
	else oRow.className="dataDark";
	
	for (var i =1; i <=6; i++) {   //生成一行中的每一列
		oCell = oRow.insertCell(-1);
		var oDiv = document.createElement("div");
		if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail' value='"+totalValue+"'><input type='hidden' name='txtShareDetail' value='"+totalValue+"'>";
		else if (i==2) oDiv.innerHTML=shareTypeText;
		else  if (i==3) oDiv.innerHTML=relatedShareNames;
		else  if (i==4) oDiv.innerHTML=rolelevelText;
		else  if (i==5) {
			if (showlevelText=="0") {
				showlevelText="";
			}
			oDiv.innerHTML=showlevelText;
		}
		else  if (i==6) oDiv.innerHTML=righttypelText;
		jQuery(oDiv).jNice();
		oCell.appendChild(oDiv);
	}
}

function removeValue(){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=chks.length-1;i>=0;i--){
        var chk = chks[i];
        if (chk.checked)
            oTable.deleteRow(chk.parentElement.parentElement.parentElement.parentElement.rowIndex)
    }
}

function chkAllClick(obj){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        changeCheckboxStatus(chk, obj.checked);
    }
}

function doSave(obj){
    obj.disabled=true;
    weaver.submit();
}
</script>

</BODY>
</HTML>
