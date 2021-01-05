
<%@ page language="java" contentType="text/html; charset=UTF-8" %> 
<%@ include file="/systeminfo/init_wev8.jsp" %>
<%@ include file="/formmode/pub_detach.jsp"%>
<%@ taglib uri="/browserTag" prefix="brow"%>
<%@ page import="weaver.general.Util" %>
<%@ page import="weaver.docs.category.CategoryUtil" %>
<%@ page import="weaver.docs.category.security.*" %>
<jsp:useBean id="RecordSet" class="weaver.conn.RecordSet" scope="page" />
<jsp:useBean id="CheckUserRight" class="weaver.systeminfo.systemright.CheckUserRight" scope="page" />
<jsp:useBean id="CustomerTypeComInfo" class="weaver.crm.Maint.CustomerTypeComInfo" scope="page" />

<%
if(!HrmUserVarify.checkUserRight("FORMMODEAPP:ALL", user)){
	response.sendRedirect("/notice/noright.jsp");
	return;
}

int reportid = Util.getIntValue(request.getParameter("reportid"),0);
int righttype = Util.getIntValue(request.getParameter("righttype"),0);

String subCompanyIdsql = "SELECT b.subcompanyid FROM mode_Report a,modeTreeField b WHERE a.appid=b.id AND a.id="+reportid;
RecordSet recordSet = new RecordSet();
recordSet.executeSql(subCompanyIdsql);
int subCompanyId = -1;
if(recordSet.next()){
	subCompanyId = recordSet.getInt("subCompanyId");
}
String userRightStr = "FORMMODEAPP:ALL";
Map rightMap = getCheckRightSubCompanyParam(userRightStr,user,fmdetachable, subCompanyId,"",request,response,session);
int operatelevel = Util.getIntValue(Util.null2String(rightMap.get("operatelevel")),-1);
subCompanyId = Util.getIntValue(Util.null2String(rightMap.get("subCompanyId")),-1);

%>
<HTML><HEAD>
<LINK href="/css/Weaver_wev8.css" type=text/css rel=STYLESHEET>
<link href="/formmode/css/formmode_wev8.css" type="text/css" rel="stylesheet" />
<SCRIPT language="javascript" src="../../js/weaver_wev8.js"></script>
</HEAD>
<BODY>
<%
String imagefilename = "/images/hdCRMAccount_wev8.gif";
//报表共享权限:添加
String titlename = SystemEnv.getHtmlLabelName(30540,user.getLanguage()) + ":" + SystemEnv.getHtmlLabelName(611,user.getLanguage());
String needfav ="1";
String needhelp ="";
%>
<%@ include file="/systeminfo/TopTitle_wev8.jsp" %>
<%@ include file="/systeminfo/RightClickMenuConent_wev8.jsp" %>
<%
if(operatelevel>0){
	RCMenu += "{"+SystemEnv.getHtmlLabelName(611,user.getLanguage())+",javascript:addValue(),_top} " ;//添加
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(91,user.getLanguage())+",javascript:removeValue(),_top} " ;//删除
	RCMenuHeight += RCMenuHeightStep ;
	RCMenu += "{"+SystemEnv.getHtmlLabelName(86,user.getLanguage())+",javascript:doSave(this),_top} " ;//保存
	RCMenuHeight += RCMenuHeightStep ;
}
//返回
RCMenu += "{"+SystemEnv.getHtmlLabelName(1290,user.getLanguage())+",javascript:location.href='/formmode/report/ReportShare.jsp?id="+reportid+"',_top} " ;
RCMenuHeight += RCMenuHeightStep ;
%>
<%@ include file="/systeminfo/RightClickMenu_wev8.jsp" %>


<FORM id=weaver name=weaver action=ReportShareOperation.jsp method=post onsubmit='return check_by_permissiontype()'>
  <input type="hidden" name="method" value="addNew">
  <input type="hidden" name="reportid" value="<%=reportid%>">
  <input type="hidden" name="righttype" value="<%=righttype%>">
  <input type="hidden" name="relatedid" id="relatedid" value="">
  
<table class="e8_tblForm">
    <TBODY>
     <TR><!-- 共享类型 -->
       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></TD>   
       <TD class="e8_tblForm_field">
         <SELECT class=InputStyle  name=sharetype onChange="onChangeSharetype()" >  
           <option value="1" selected><%=SystemEnv.getHtmlLabelName(1867,user.getLanguage())%></option> <!-- 人员 -->
           <option value="2"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%></option><!-- 分部 -->
           <option value="3"><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%></option><!-- 部门 -->
           <option value="4"><%=SystemEnv.getHtmlLabelName(122,user.getLanguage())%></option><!-- 角色 -->
           <option value="5"><%=SystemEnv.getHtmlLabelName(1340,user.getLanguage())%></option><!-- 所有人 -->
         </SELECT>
       </TD>
     </TR>
     <tr id="tr_virtualtype" style="display:none">
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
     	<TD class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(172,user.getLanguage())%></TD><!-- 选择 -->
     	<TD class="e8_tblForm_field">
     		<span id="showspan1">
         	<brow:browser viewType="0" name="relatedid1" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/hrm/resource/MutiResourceBrowser.jsp?resourceids=" 
         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp" browserSpanValue="" isMustInput="2">
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
         		hasInput="true"  width="50%" isSingle="true" hasBrowser="true" completeUrl="/data.jsp?type=65" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
         <span id="showspan1000" style="display:none;">
         	<brow:browser viewType="0" name="relatedid1000" browserValue="" browserOnClick="" 
         		browserUrl="/systeminfo/BrowserMain.jsp?url=/formmode/setup/MultiFormmodeShareFieldBrowser.jsp?type=&selectedids=&modeId=" 
         		hasInput="true"  width="50%" isSingle="false" hasBrowser="true" completeUrl="/data.jsp" browserSpanValue="" isMustInput="2">
         	</brow:browser>
         </span>
     	</TD>
     </TR>
     

     <!-- 角色级别 -->
     <TR id=rolelevel_tr name=id=rolelevel_tr style="display:none">
       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></td><!-- 共享级别 -->
       <TD class="e8_tblForm_field">
           <SELECT  name=rolelevel>
	           <option value="0" selected><%=SystemEnv.getHtmlLabelName(124,user.getLanguage())%><!-- 部门 -->
	           <option value="1"><%=SystemEnv.getHtmlLabelName(141,user.getLanguage())%><!-- 分门 -->
	           <option value="2"><%=SystemEnv.getHtmlLabelName(140,user.getLanguage())%><!-- 总部 -->
	       </SELECT>
       </td>
     </TR>
	<TR id=rolelevel_line name=rolelevel_line style="display:none;height: 1px">
       <TD class=Line colSpan=2  ></TD>
     </TR>
     <!-- 安全级别 -->
     <TR  id=showlevel_tr name=showlevel_tr style="display:none;height: 1px">
       <td class="e8_tblForm_label" width="20%"><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></TD>
       <TD class="e8_tblForm_field">
       	 <INPUT type=text id="showlevel" name="showlevel" onblur="checkLevel('showlevel','showlevel2',this)" class=InputStyle size=6 value="10"  onchange='checkinput("showlevel","showlevelimage")' onKeyPress="ItemCount_KeyPress()">
         <span id=showlevelimage></span> - 
         <INPUT type=text id="showlevel2" name="showlevel2" onblur="checkLevel('showlevel','showlevel2',this)" class=InputStyle size=6 value=""  onKeyPress="ItemCount_KeyPress()">
       </TD>
     </TR>

     
     <tr><td colspan="2" style="height:10px;"></td></tr>
     <TR>
		<TD colspan="2" style="text-align:right;">
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
		</td>
	</TR>
</TABLE>

 <table id="oTable" name="oTable">
	 <colgroup>
	 <col width="5%">
	 <col width="25%">
	 <col width="30%">
	 <col width="20%">
	 <col width="20%">
	 </colgroup>
	 <tr class="header">
		 <th><input type="checkbox" name="chkAll" onClick="chkAllClick(this)"></th>
		 <th><%=SystemEnv.getHtmlLabelName(18495,user.getLanguage())%></th><!-- 共享类型 -->
		 <th><%=SystemEnv.getHtmlLabelName(119,user.getLanguage())%></th><!-- 共享 -->
		 <th><%=SystemEnv.getHtmlLabelName(3005,user.getLanguage())%></th><!-- 共享级别 -->
		 <th><%=SystemEnv.getHtmlLabelName(683,user.getLanguage())%></th><!-- 安全级别 -->
	 </tr>
 </table>
</FORM>

<script language=javascript>

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

function onChangeSharetype(){
	var thisvalue=$GetEle("sharetype").value;	
    var strAlert= ""
    $("span[id^='showspan']").css('display','none');
	if(thisvalue==1 || thisvalue==2 || thisvalue==3 || thisvalue==4){//需要浏览框
		$GetEle("browserTr").style.display = '';
		$GetEle("showspan"+thisvalue).style.display='';	//浏览框
	}else{
		$GetEle("browserTr").style.display = 'none';
		//$GetEle("showspan").style.display='none';	//不需要浏览框
	}
	if(thisvalue != 4){
		$GetEle("rolelevel_tr").style.display='none';	//角色级别
		$GetEle("rolelevel_line").style.display='none';	
	}else{
		$GetEle("rolelevel_tr").style.display='';	//需要角色级别
		$GetEle("rolelevel_line").style.display='';	
	}
	if(thisvalue == 1){//人员不需要安全级别
		$GetEle("showlevel_tr").style.display='none';	//安全级别
		$GetEle("showlevel_line").style.display='none';
	}else{
		$GetEle("showlevel_tr").style.display='';	//安全级别
		$GetEle("showlevel_line").style.display='';
	}
	if(thisvalue==1||thisvalue==2||thisvalue==3){//人员 
		jQuery("#tr_virtualtype").show();
	}else {
		jQuery("#tr_virtualtype").hide();
	}
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
			if(sharetype != '4'){
				ids = datas.id.substring(1);
				names = datas.name.substring(1);
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
	var relatedids="0";
	var relatedShareNames="";
	if (thisvalue==1||thisvalue==2||thisvalue==3||thisvalue==4) {
		$GetEle("relatedid").value = $GetEle("relatedid"+thisvalue).value;
	    if(!check_form(document.weaver,'relatedid')) {
	        return ;
	    }
	    if (thisvalue == 4){
	        if (!check_form(document.weaver,'rolelevel'))
	            return;
	    }
	    if(thisvalue != 1){
	    	if (!check_form(document.weaver,'showlevel'))
	            return;
	    }
	    relatedids = $GetEle("relatedid").value;
	    //relatedShareNames= $GetEle("showrelatedname").innerHTML;
	    relatedShareNames = $GetEle("relatedid"+thisvalue+"span").innerHTML;
	    if(thisvalue==1||thisvalue==2||thisvalue==3){
	    	//relatedShareNames="("+jQuery("#HrmCompanyVirtual :selected").text()+")"+relatedShareNames
	    }
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
	}
	
	var righttypeValue =  $GetEle("righttype").value;
	var hrmCompanyVirtualValue = jQuery("#HrmCompanyVirtual").val();
	//共享类型 + 共享者ID +共享角色级别 +共享级别+共享权限+下载权限(TD12005)
	var totalValue=shareTypeValue+"_"+relatedids+"_"+rolelevelValue+"_"+showlevelValue
	if(showlevelValue2!=""){
		totalValue +="$"+showlevelValue2;
	}
	totalValue +="_"+righttypeValue+"_"+hrmCompanyVirtualValue;
	var oRow = oTable.insertRow(-1);
	var oRowIndex = oRow.rowIndex;
	
	if (oRowIndex%2==0) oRow.className="dataLight";
	else oRow.className="dataDark";
	
	for (var i =1; i <=5; i++) {   //生成一行中的每一列
		oCell = oRow.insertCell(-1);
		var oDiv = document.createElement("div");
		if (i==1) oDiv.innerHTML="<input class='inputStyle' type='checkbox' name='chkShareDetail' value='"+totalValue+"'><input type='hidden' name='txtShareDetail' value='"+totalValue+"'>";
		else if (i==2) oDiv.innerHTML=shareTypeText;
		else  if (i==3) oDiv.innerHTML=relatedShareNames;
		else  if (i==4) oDiv.innerHTML=rolelevelText;
		else  if (i==5) {if (showlevelText=="0") showlevelText=""; oDiv.innerHTML=showlevelText;}
		oCell.appendChild(oDiv);
	}
	
	jQuery("#oTable").jNice();
}

function removeValue(){
    var chks = document.getElementsByName("chkShareDetail");
    for (var i=chks.length-1; i>=0; i--){
		var chk = chks[i];
		if(chk.checked)
            oTable.deleteRow(chk.parentElement.parentElement.parentElement.parentElement.rowIndex);
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
