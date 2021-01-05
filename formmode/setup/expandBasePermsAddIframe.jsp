<%@page import="weaver.formmode.FormModeConfig"%>
<%@page import="weaver.formmode.service.ModelInfoService"%>

<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ page import="weaver.general.Util" %>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />
<%
if (!HrmUserVarify.checkUserRight("ModeSetting:All", user)) {
	response.sendRedirect("/notice/noright.jsp");
	return;
}
ModelInfoService modelInfoService=new ModelInfoService();
int modeid = Util.getIntValue(request.getParameter("modeid"),0);
int formId = modelInfoService.getFormInfoIdByModelId(modeid); 
int expandid = Util.getIntValue(request.getParameter("expandid"),0);

int layoutformId = Util.getIntValue(Util.null2String(request.getParameter("formId")));
int trighttype = Util.getIntValue(request.getParameter("trighttype"),0);
boolean isVirtualForm=Boolean.valueOf(Util.null2String(request.getParameter("isVirtualForm")));

String subCompanyIdsql = "select subCompanyId from modeinfo where id="+modeid;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
}
String userRightStr = "ModeSetting:All";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
<style>
.codeEditFlag{
	padding-left:20px;
	padding-right: 10px;
	height: 16px;
	background:transparent url('/formmode/images/list_edit_wev8.png') no-repeat !important;
	cursor: pointer;
	margin-left: 2px;
	margin-top: 2px;
	position: relative;
}
.codeDelFlag{
	position: absolute;
	top: 2px;
	right: 2px;
	width:9px;
	height:9px;
	background:transparent url('/images/messageimages/delete_wev8.gif') no-repeat !important;
	cursor: pointer;	
}
</style>
</HEAD>
<BODY>
<%
String imagefilename = "/images/hdMaintenance_wev8.gif";
String titlename = SystemEnv.getHtmlLabelName(16526,user.getLanguage());
String needfav ="1";
String needhelp ="";
if(trighttype==1){//创建权限:添加
	titlename = SystemEnv.getHtmlLabelName(21945,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
}else if(trighttype==0){//默认共享:添加
	titlename = SystemEnv.getHtmlLabelName(15059,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
}else if(trighttype==2){//监控权限:添加
	titlename = SystemEnv.getHtmlLabelName(20305,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
}else if(trighttype==4){//批量导入权限:添加
	titlename = SystemEnv.getHtmlLabelName(30253,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
}

%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;
	RCMenuHeight += RCMenuHeightStep ;
}
RCMenu += "{"+SystemEnv.getHtmlLabelName(201,user.getLanguage())+",javascript:doCancel(this),_top} " ;
RCMenuHeight += RCMenuHeightStep ;

boolean isDefaultShare = false;//是否默认共享

%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>

<FORM id=weaver name=weaver action=expandBaseRightOperation.jsp method=post >
  <input type="hidden" name="method" value="addNew">
  <input type="hidden" name="modeid" value="<%=modeid%>">
  <input type="hidden" name="expandid" value="<%=expandid%>">
  
  <input type="hidden" name="relatedid" id="relatedid" value="">
<table class="e8_tblForm">
    <TBODY>
     <TR><!-- 共享类型 -->
       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></TD>
       <TD class="e8_tblForm_field">
       <table style="width: 100%">
	    	<colgroup>
	    		<col style="width: 220px;">
	    		<col style="width: 80px;">
	    		<col style="width: *;">
	    	</colgroup>
	    	<tr>
	    		<td>
		         <SELECT class=InputStyle  name=rightType onChange="onChangeRighttype()"  style="width:200px;">  
					<option value="1" selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> <!-- 人员 -->
					<option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
					<option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
					<option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option><!-- 角色 -->
					<option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option><!-- 所有人 -->
					<option value="6"><%=SystemEnv.getHtmlLabelName(125969,user.getLanguage())%></option><!-- 继承模块编辑权限-->
		         </SELECT>
	    	</td>
	    		<td>
		    		<span id="modefieldtypespan" style="display:none;width: 100px;" >
		    			<span><%=SystemEnv.getHtmlLabelName(686,user.getLanguage())%></span>
		    		</span>
	    		</td>
	    		<td>
	    		<span id="modefieldtypespan1" style="display:none;width: 100px;" >
	    			<select class=InputStyle id="modefieldtype" name="modefieldtype" onchange="changeFieldType(this)">
			         	<option value="1"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option><!-- 人员 -->
			         	<option value="2"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
			         	<option value="3"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
			         </select>
			        </span>
	    		</td>
	    	</tr>
	    </table>
        
       </TD>
     </TR>
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
         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=167" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
         <span id="showspan4" style="display:none;">
         	<brow:browser viewType="0" name="relatedid4" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp" 
         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp?type=65" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
         
     	</TD>
     </TR>
     
     <TR id="javaTr" style="display:none;">
     	<TD class="e8_tblForm_label" width="20%">java<%=SystemEnv.getHtmlLabelName(32363,user.getLanguage())%></TD>
     	<TD class="e8_tblForm_field">
         	<span class="codeEditFlag" onclick="openCodeEdit();">
				<span id="javafilename_span"><img align="absmiddle" src="/images/BacoError_wev8.gif"></span>
				<div class="codeDelFlag" style="display: none;"></div>
			</span>
			<input type="hidden" id="javafilename" name="javafilename" value=""/>
     	</TD>
     </TR>

     <!-- 角色级别 -->
     <TR id=rolelevel_tr name=rolelevel_tr style="display:none">
       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></td>
       <TD class="e8_tblForm_field">
           <SELECT  name=rolelevel style="width:100px;">
	           <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><!-- 部门 -->
	           <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><!-- 分门 -->
	           <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><!-- 总部 -->
	       </SELECT>
       </td>
     </TR>
     
     <TR id="rolescope_tr" name="rolescope_tr" style="display:none">
       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(82697,user.getLanguage())%></td>
       <TD class="e8_tblForm_field">
           <SELECT id="rolescope"  name="rolescope" style="width:180px;">
	           <option value="1"><%=SystemEnv.getHtmlLabelName(82695,user.getLanguage())%><!-- 限定组织单元范围内 -->
	           <option value="2"><%=SystemEnv.getHtmlLabelName(82696,user.getLanguage())%><!-- 限定组织单元及下属范围内 -->
	       </SELECT>
       </td>
     </TR>
     
     <!-- 上级关系 -->
     <TR  id=higherlevel_tr name=higherlevel_tr style="display:none;height: 1px">
       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(596,user.getLanguage())+SystemEnv.getHtmlLabelName(729,user.getLanguage())%></TD>
       <TD class="e8_tblForm_field">
         <select class=InputStyle id="higherlevel" name="higherlevel" onchange="javascript:changeHigherlevel();" >
         	<option value="1"><%=SystemEnv.getHtmlLabelName(524,user.getLanguage())+SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option>
         	<option value="2"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(15709,user.getLanguage())%></option>
         	<option value="3"><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())+SystemEnv.getHtmlLabelName(15762,user.getLanguage())%></option>
         </select>
       </TD>
     </TR>
     
     
     <!-- 安全级别 -->
     <TR  id=showlevel_tr name=showlevel_tr style="display:none;height: 1px">
       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
       <TD class="e8_tblForm_field">
       	 <INPUT type=text name="showlevel" id="showlevel" name="showlevel" onblur="checkLevel('showlevel','showlevel2',this)" class=InputStyle size=6 value="10" onchange='checkinput("showlevel","showlevelimage")' onKeyPress="ItemCount_KeyPress()">
         <span id=showlevelimage></span> - 
         <INPUT type=text name="showlevel2" id="showlevel2" name="showlevel2" onblur="checkLevel('showlevel','showlevel2',this)" class=InputStyle size=6 value=""  onKeyPress="ItemCount_KeyPress()">
       </TD>
     </TR>
     
 	<tr><td colspan="2" style="height:10px;"></td></tr>
 	<TR>
       <TD  colspan=2 style="text-align:right;">
       <button
	      	type="button"
	      	title="<%=SystemEnv.getHtmlLabelName(18645,user.getLanguage())%>" 
	      	class="addbtn2" 
	      	onClick="addValue()"></button><!-- 添加共享 -->
	      <button 
	      	type="button"
	      	title="<%=SystemEnv.getHtmlLabelName(18646,user.getLanguage())%>"
	      	class="deletebtn2" 
	      	onclick="removeValue()"></button><!-- 删除共享 -->
       </TD>
     </TR>
</table>

<table id="oTable" name="oTable">
             <colgroup>
             <col width="4%">
             <col width="20%">
             <col width="40%">
             <col width="20%">
             <col width="16%">
             
             <tr class="header">
                 <th><input type="checkbox" name="chkAll" onclick="chkAllClick(this)"></th>
                 <th><%=SystemEnv.getHtmlLabelName(32382,user.getLanguage())%></th><!-- 共享类型 -->
                 <th><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></th><!-- 共享 -->
                 <th><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></th><!-- 共享级别 -->
                 <th><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></th><!-- 安全级别 -->
             </tr>
         </table>

</FORM>

<script language=javascript>
$(document).ready(function() {
	onChangeRighttype();
});
function chkAllClick(obj){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=0;i<chks.length;i++){
        var chk = chks[i];
        changeCheckboxStatus(chk, obj.checked);
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
			return;
		}
	}
}

function selectOrgBrowser(){
	var tmpval = $GetEle("orgtype1").value;
	var tempurl1 = "";
	if(tmpval==1){
		tempurl1 = "/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser.jsp?selectedids=&selectedDepartmentIds=";	
	}else{
		tempurl1 = "/systeminfo/BrowserMain.jsp?url=/hrm/company/DepartmentBrowser.jsp?selectedids=";
	}
	return tempurl1;
}

function modefiledchange2(){
	 var tmpval = $GetEle("orgtype2").value;
	 if(tmpval==1){
		 tmpval = "3";//分部
	 }else{
		 tmpval = "2";//部门
	 }
		var tempurl1 = "/systeminfo/BrowserMain.jsp?url=/formmode/setup/FormmodeShareFieldBrowser.jsp?type="+tmpval+"&selectedids=&modeId=<%=modeid%>";
		return tempurl1;
}

function modefiledchange3(){
	var tmpval=1;
	var tempurl1 = "/systeminfo/BrowserMain.jsp?url=/formmode/setup/FormmodeShareFieldBrowser.jsp?type="+tmpval+"&selectedids=&modeId=<%=modeid%>";
	return tempurl1;
}

function zyychange(){
	if(jQuery("#zyy").val()==1){
		jQuery("#showlevel_tr").show();
	}else{
		jQuery("#showlevel_tr").hide();
	}
}

function modefiledChange(){
    var tmpval = $GetEle("modefieldtype").value;
	var tempurl1 = "/systeminfo/BrowserMain.jsp?url=/formmode/setup/MultiFormmodeShareFieldBrowser.jsp?type="+tmpval+"&selectedids=&modeId=<%=modeid%>";
	return tempurl1;
}
function rolefiledChange(){
    var tmpval = $GetEle("rolefieldtype").value;
	var tempurl1 = "/systeminfo/BrowserMain.jsp?url=/formmode/setup/MultiFormmodeShareFieldBrowser.jsp?type="+tmpval+"&selectedids=&modeId=<%=modeid%>&isRoleLimited=1";
	return tempurl1;
}
function modefiledChange(){
    var tmpval = $GetEle("modefieldtype").value;
	var tempurl1 = "/systeminfo/BrowserMain.jsp?url=/formmode/setup/MultiFormmodeShareFieldBrowser.jsp?type="+tmpval+"&selectedids=&modeId=<%=modeid%>";
	return tempurl1;
}
function onChangeRighttype(){
	var thisvalue=$GetEle("rightType").value;
    var strAlert= ""
    $("span[id^='showspan']").css('display','none');
	if(thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4 ){//需要浏览框
		$GetEle("browserTr").style.display = '';
		$GetEle("showspan"+thisvalue).style.display='';	//浏览框
	}else{
		$GetEle("browserTr").style.display = 'none';
	}
	if(thisvalue != 4){
		$GetEle("rolelevel_tr").style.display='none';	//角色级别
	} else {
		$GetEle("rolelevel_tr").style.display='';	//角色级别
	}
	if(thisvalue==1){
		$GetEle("showlevel_tr").style.display='none';	//安全级别
	}else{
		$GetEle("showlevel_tr").style.display='';	//安全级别
	}
	
	if(thisvalue==1000){
	}else{
		jQuery("#modefieldtypespan").hide();
		jQuery("#modefieldtypespan1").hide();
	    jQuery("#higherlevel_tr").hide();
	}
}

function changeHigherlevel(){
	var thisvalue=$GetEle("rightType").value;
		var modefieldtype = jQuery("#modefieldtype").val();
		var higherlevel = jQuery("#higherlevel").val();
		if(modefieldtype==1){
			if(higherlevel==3){
				$GetEle("showlevel_tr").style.display='';	//安全级别
			}else{
				$GetEle("showlevel_tr").style.display='none';
			}
		}else{
			$GetEle("showlevel_tr").style.display='';	//安全级别
		}
}

function roleFieldTypeChange(){
	var relatedid1001 = jQuery("#rolefield");
	var relatedid1001span = jQuery("#rolefieldspan");
	var relatedid1001spanimg = jQuery("#rolefieldspanimg");
	
	relatedid1001.val("");
	relatedid1001span.html("");
	relatedid1001spanimg.html("<IMG src='/images/BacoError_wev8.gif' align=absMiddle>");
}

function openCodeEdit(){
	top.openCodeEdit({
		"type" : "6",
		"filename" : $("#javafilename").val(),
		"formid" : "<%=formId%>"
	}, function(result){
		if(result){
			var fName = result["fileName"];
			$("#javafilename_span").html(fName);
			$("#javafilename").val(fName);
			$(".codeDelFlag").show();
		}
	});
}

function changeFieldType(obj){
	if(obj.value=='1'){
		jQuery("#higherlevel_tr").show();
	}else{
		jQuery("#higherlevel_tr").hide();
	}
	changeHigherlevel();
	$GetEle("showspan").style.display='';	//浏览框
	$GetEle("relatedid").value="";
	$GetEle("showrelatedname").innerHTML="<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
}


function onShowRelated(inputname,spanname){
	var rightType = $G("rightType").value;
	var datas = "";
	if(rightType == '1'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids="+inputname.value);
	}else if(rightType == '2'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/SubcompanyBrowser3.jsp?selectedids="+inputname.value+"&selectedDepartmentIds="+inputname.value);
	}else if(rightType == '3'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/company/MutiDepartmentBrowser.jsp?selectedids="+inputname.value);
	}else if(rightType == '4'){
		datas = window.showModalDialog("/systeminfo/BrowserMain.jsp?url=/hrm/roles/HrmRolesBrowser.jsp");
	}
	if (datas != undefined && datas != null) {
		var ids = "";
		var names = "<IMG src='/images/BacoError_wev8.gif' align=absMiddle>";
		if(datas.id != ''){
			if(rightType != '4' && rightType != '1000'){
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
	thisvalue=$GetEle("rightType").value;
	//alert(thisvalue);
	var rightTypeValue = thisvalue;
	//alert(rightTypeValue);
	
	var rightTypeText = $GetEle("rightType").options.item($GetEle("rightType").selectedIndex).text;
	//人力资源(1),分部(2),部门(3),角色后的那个选项值不能为空(4)
	var relatedids="0";
	var relatedShareNames="";
	if (thisvalue==1||thisvalue==2||thisvalue==3||thisvalue==4) {
		$GetEle("relatedid").value = $GetEle("relatedid"+thisvalue).value;
	    if(!check_form(document.weaver,'relatedid')) {
	        return ;
	    }
	    if (thisvalue == 4){
	        if (!check_form(document.weaver,'rolelevel')){
	            return;
	        }
	    }
	    relatedids = $GetEle("relatedid").value;
	    relatedShareNames = $GetEle("relatedid"+thisvalue+"span").innerHTML;
	}
	
	if(thisvalue != 1){
    	if (!check_form(document.weaver,'showlevel'))
            return;
    }
	
	var showlevelValue="0";
	var showlevelValue2="";
	var showlevelText="";
	var flag = false;
	if (thisvalue!=1&&thisvalue!=1001) {
		if((thisvalue==1000&&jQuery("#modefieldtype").val()=="1")){
			var higherlevel = jQuery("#higherlevel").val();
			if(higherlevel==3){
				flag = true;
			}
		}else{
			flag = true;
		}
		if(flag){
			showlevelValue = $GetEle("showlevel").value;
		    showlevelText = showlevelValue;
		    showlevelValue2 = $GetEle("showlevel2").value;
		    if(showlevelValue2!=""&&!isNaN(showlevelValue2)){
		    	showlevelText += " - "+showlevelValue2;
		    }else{
		    	showlevelValue2 = "";
		    }
		}
	}
	
	var rolelevelValue=0;
	var rolelevelText="";
	if (thisvalue==4){  //角色  0:部门   1:分部  2:总部
	   	rolelevelValue = $GetEle("rolelevel").value;
	    	rolelevelText = $GetEle("rolelevel").options.item($GetEle("rolelevel").selectedIndex).text;
	}
	//上级关系
	var higherlevelValue = 0;
	var higherlevelText = "";
	
	var javaFileName=jQuery("#javafilename").val();
	
	var layoutid,layoutid1,layoutorder;
	
	//共享类型 + 共享者ID +共享角色级别 +共享级别+共享权限+下载权限(TD12005)+javaFileNameChanged+布局ID+布局ID2+布局级别
	//当为默认共享时：   +角色是否受范围限制+范围字段类型+角色限制字段
	var javaFileNameChanged=javaFileName.replace(/\_/g,"#");
	if(javaFileNameChanged==""){
		javaFileNameChanged = "0";
	}
	
	if(showlevelValue2!=""){
		showlevelValue +="$"+showlevelValue2;
	}
	
	var totalValue = "{\"rightTypeValue\":\""+rightTypeValue+"\",relatedids:\""+relatedids
	+"\",\"rolelevelValue\":\""+rolelevelValue
	+"\",\"showlevelValue\":\""+showlevelValue
	+"\",\"higherlevel\":\""+higherlevelValue
	+"\",\"javaFileNameChanged\":\""+javaFileNameChanged+"\"";
	totalValue+="}";
	
	var oRow = oTable.insertRow(-1);
	var oRowIndex = oRow.rowIndex;
	
	if (oRowIndex%2==0) oRow.className="dataLight";
	else oRow.className="dataDark";
	
	for (var i =1; i <7; i++) {   //生成一行中的每一列
		oCell = oRow.insertCell(-1);
		var oDiv = document.createElement("div");
		if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail' value='"+totalValue+"'><input type='hidden' name='txtShareDetail' value='"+totalValue+"'>";
		else if (i==2) oDiv.innerHTML=rightTypeText;
		else  if (i==3) oDiv.innerHTML=relatedShareNames+higherlevelText;
		else  if (i==4) oDiv.innerHTML=rolelevelText;
		else  if (i==5) oDiv.innerHTML=showlevelText;
		
		oCell.appendChild(oDiv);
	}
	
	jQuery("#oTable").jNice();
}

function removeValue(){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=chks.length-1;i>=0;i--){
        var chk = chks[i];
        if (chk.checked)
            oTable.deleteRow(chk.parentElement.parentElement.parentElement.parentElement.rowIndex);
    }
}

function doSave(obj){
    obj.disabled=true;
    weaver.submit();
    
   
}
function doCancel(obj) {
	parent.doClose();
}
function zyytypeChange(){
	if(jQuery("#zyytype").val()!=1&&jQuery("#zyytype").val()!=5){
		jQuery("#zztypetd").show();
	}else{
		jQuery("#zztypetd").hide();
	}
}

</script>

</BODY>
</HTML>
